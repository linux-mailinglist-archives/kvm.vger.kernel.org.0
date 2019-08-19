Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3355994D10
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 20:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfHSSgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 14:36:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:25529 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbfHSSgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 14:36:45 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 11:36:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="195592515"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2019 11:36:44 -0700
Date:   Mon, 19 Aug 2019 11:36:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nicusor CITU <ncitu@bitdefender.com>
Cc:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@vger.kernel.org" <Zhang@vger.kernel.org>,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Message-ID: <20190819183643.GB1916@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-56-alazar@bitdefender.com>
 <20190812210501.GD1437@linux.intel.com>
 <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 06:36:44AM +0000, Nicusor CITU wrote:
> > > +	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
> > > +				bool enable);
> > 
> > This should be toggle_wrmsr_intercept(), or toggle_msr_intercept()
> > with a paramter to control RDMSR vs. WRMSR.
> 
> Ok, I can do that.
> 
> 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 6450c8c44771..0306c7ef3158 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7784,6 +7784,15 @@ static __exit void hardware_unsetup(void)
> > >  	free_kvm_area();
> > >  }
> > >  
> > > +static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned int
> > > msr,
> > > +			      bool enable)
> > > +{
> > > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;

Is KVMI intended to play nice with nested virtualization?  Unconditionally
updating vmcs01.msr_bitmap is correct regardless of whether the vCPU is in
L1 or L2, but if the vCPU is currently in L2 then the effective bitmap,
i.e. vmcs02.msr_bitmap, won't be updated until the next nested VM-Enter.

> > > +
> > > +	vmx_set_intercept_for_msr(msr_bitmap, msr, MSR_TYPE_W, enable);
> > > +}
> > 
> > Unless I overlooked a check, this will allow userspace to disable
> > WRMSR interception for any MSR in the above range, i.e. userspace can
> > use KVM to gain full write access to pretty much all the interesting
> > MSRs. This needs to only disable interception if KVM had interception
> > disabled before introspection started modifying state.
> 
> We only need to enable the MSR interception. We never disable it -
> please see kvmi_arch_cmd_control_msr().

In that case, drop @enable and use enable_wrmsr_intercept() or something
along those lines for kvm_x86_ops instead of toggle_wrmsr_intercept().
