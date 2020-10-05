Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435EB283FCB
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 21:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgJETlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 15:41:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:19752 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgJETlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 15:41:13 -0400
IronPort-SDR: Bdw+cKsjTJ//04f6oh3Zxhgc3NQT9tb006m0ZwF7n152IAfu36hBoiNhk5O9q3DJ5F160QPfg0
 ZQ3O4ZJiEfrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="143832465"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="143832465"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP; 05 Oct 2020 12:26:06 -0700
IronPort-SDR: lxF6D25Y207qlLNXScXhxkLPsDRbK1kc/MVlkM2tgjHEmEqB9WNJ8MI7ZEXXSbfyiX3amIf/dz
 tc0QX9Ic3oBg==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="517163416"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:43:35 -0700
Date:   Mon, 5 Oct 2020 11:43:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>, kvm list <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 6/8] KVM: x86: VMX: Prevent MSR passthrough when MSR
 access is denied
Message-ID: <20201005184320.GA15803@linux.intel.com>
References: <20200925143422.21718-1-graf@amazon.com>
 <20200925143422.21718-7-graf@amazon.com>
 <20201002011139.GA5473@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002011139.GA5473@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 09:11:39PM -0400, Peter Xu wrote:
> Hi,
> 
> I reported in the v13 cover letter of kvm dirty ring series that this patch
> seems to have been broken.  Today I tried to reproduce with a simplest vm, and
> after a closer look...
> 
> On Fri, Sep 25, 2020 at 04:34:20PM +0200, Alexander Graf wrote:
> > @@ -3764,15 +3859,14 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
> >  	return mode;
> >  }
> >  
> > -static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
> > -					 unsigned long *msr_bitmap, u8 mode)
> > +static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
> >  {
> >  	int msr;
> >  
> > -	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
> > -		unsigned word = msr / BITS_PER_LONG;
> > -		msr_bitmap[word] = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
> > -		msr_bitmap[word + (0x800 / sizeof(long))] = ~0;
> > +	for (msr = 0x800; msr <= 0x8ff; msr++) {
> > +		bool intercepted = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
> > +
> > +		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_RW, intercepted);

Yeah, this is busted.

> >  	}
> >  
> >  	if (mode & MSR_BITMAP_MODE_X2APIC) {
> 
> ... I think we may want below change to be squashed:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d160aad59697..7d3f2815b04d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3781,9 +3781,10 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
>         int msr;
>  
>         for (msr = 0x800; msr <= 0x8ff; msr++) {
> -               bool intercepted = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
> +               bool apicv = mode & MSR_BITMAP_MODE_X2APIC_APICV;
>  
> -               vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_RW, intercepted);
> +               vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, !apicv);
> +               vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, true);

I would prefer a full revert of sorts.  Allowing userspace to intercept reads
to x2APIC MSRs when APICV is fully enabled for the guest simply can't work.
The LAPIC and thus virtual APIC is in-kernel and cannot be directly accessed
by userspace.  I doubt it actually affects real world performance, but
resetting each MSR one-by-one bugs me.

Intercepting writes to TPR, EOI and SELF_IPI are somewhat plausible, but I
just don't see how intercepting reads when APICV is active is a sane setup.

I'll send a patch and we can go from there.

>         }
>  
>         if (mode & MSR_BITMAP_MODE_X2APIC) {
> 
> This fixes my problem the same as having this patch reverted.
> 
> -- 
> Peter Xu
> 
