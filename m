Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058621751A
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 19:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgGGR11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 13:27:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:2939 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGGR11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 13:27:27 -0400
IronPort-SDR: qhnS5c1ONGiJOGylm2vtij2cjGXL+p3F0SvjeTm6tiE4hrD40d1MP3yNGKz566m06IUcgT3t8x
 fqsn7VYeNZ2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="147670617"
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="147670617"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 10:27:26 -0700
IronPort-SDR: OuSpcUAd08hrIa2H9NtKNPS4/LExb711TfIFjx7oAafmvSZKAjzi8BNErBNl2KdZM2gFQdFVkE
 1cE4KKPqAWQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="268257264"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jul 2020 10:27:25 -0700
Date:   Tue, 7 Jul 2020 10:27:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
Message-ID: <20200707172725.GH20096@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
 <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
 <20200707081444.GA7417@linux.intel.com>
 <f3c243b06b5acfea9ed4e4242d8287c7169ef1be.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3c243b06b5acfea9ed4e4242d8287c7169ef1be.camel@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 02:35:59PM +0300, Maxim Levitsky wrote:
> On Tue, 2020-07-07 at 01:14 -0700, Sean Christopherson wrote:
> > Aren't you supposed to be on vacation? :-)
> > 
> > On Tue, Jul 07, 2020 at 10:04:22AM +0200, Paolo Bonzini wrote:
> > > On 07/07/20 08:11, Sean Christopherson wrote:
> > > > One oddity with this whole thing is that by passing through the MSR, KVM is
> > > > allowing the guest to write bits it doesn't know about, which is definitely
> > > > not normal.  It also means the guest could write bits that the host VMM
> > > > can't.
> > > 
> > > That's true.  However, the main purpose of the kvm_spec_ctrl_valid_bits
> > > check is to ensure that host-initiated writes are valid; this way, you
> > > don't get a #GP on the next vmentry's WRMSR to MSR_IA32_SPEC_CTRL.
> > > Checking the guest CPUID bit is not even necessary.
> > 
> > Right, what I'm saying is that rather than try and decipher specs to
> > determine what bits are supported, just throw the value at hardware and
> > go from there.  That's effectively what we end up doing for the guest writes
> > anyways.
> > 
> > Actually, the current behavior will break migration if there are ever legal
> > bits that KVM doesn't recognize, e.g. guest writes a value that KVM doesn't
> > allow and then migration fails when the destination tries to stuff the value
> > into KVM.
> 
> After thinking about this, I am thinking that we should apply similiar logic
> as done with the 'cpu-pm' related features.
> This way the user can choose between passing through the IA32_SPEC_CTRL,
> (and in this case, we can since the user choose it, pass it right away, and thus
> avoid using kvm_spec_ctrl_valid_bits completely), and between correctness,
> in which case we can always emulate this msr, and therefore check all the bits,
> both regard to guest and host supported values.
> Does this makes sense, or do you think that this is overkill?

It doesn't really work because the host doesn't have a priori knowledge of
whether or not the guest will use IA32_SPEC_CTRL.  For PM stuff, there's no
meaningful overhead in exposing capabilities and the features more or less
ubiquitous, i.e. odds are very good the guest will use the exposed features
and there's no penalty if it doesn't.
