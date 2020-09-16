Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76A226CF18
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 00:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIPWuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 18:50:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:54656 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgIPWuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 18:50:19 -0400
IronPort-SDR: th8Eg01hoTrJhw/58i4gwNIpkBPOB8Yp5+ieRBXJmFQI2sM6/UH6+QK8A6ixY3wvgmudRVgvt1
 +mjFgyeffh1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="159631868"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="159631868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 15:50:18 -0700
IronPort-SDR: Wucms044M2dJy6yu4PwISQysgWFV9TvAzVd3c/iminns7GJTmeX8fH37PW8oLYqE84RcoDX9pf
 kV+strBvDXkw==
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="508169587"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 15:50:17 -0700
Date:   Wed, 16 Sep 2020 15:50:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
Message-ID: <20200916225015.GB12355@sjchrist-ice>
References: <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
 <20200916160210.GA10227@sjchrist-ice>
 <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
 <20200916164923.GC10227@sjchrist-ice>
 <9988f485-ce78-4df4-b294-32cc7743b6b2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9988f485-ce78-4df4-b294-32cc7743b6b2@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 03:27:13PM -0500, Tom Lendacky wrote:
> On 9/16/20 11:49 AM, Sean Christopherson wrote:
> > On Wed, Sep 16, 2020 at 11:38:38AM -0500, Tom Lendacky wrote:
> >>
> >>
> >> On 9/16/20 11:02 AM, Sean Christopherson wrote:
> >>> On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
> >>>> On 9/15/20 3:13 PM, Tom Lendacky wrote:
> >>>>> On 9/15/20 11:30 AM, Sean Christopherson wrote:
> >>>>>> I don't quite follow the "doesn't mean debugging can't be done in the future".
> >>>>>> Does that imply that debugging could be supported for SEV-ES guests, even if
> >>>>>> they have an encrypted VMSA?
> >>>>>
> >>>>> Almost anything can be done with software. It would require a lot of
> >>>>> hypervisor and guest code and changes to the GHCB spec, etc. So given
> >>>>> that, probably just the check for arch.guest_state_protected is enough for
> >>>>> now. I'll just need to be sure none of the debugging paths can be taken
> >>>>> before the VMSA is encrypted.
> >>>>
> >>>> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
> >>>> couldn't be called before the VMSA is encrypted, meaning I can't check the
> >>>> arch.guest_state_protected bit for that call. So if we really want to get
> >>>> rid of the allow_debug() op, I'd need some other way to indicate that this
> >>>> is an SEV-ES / protected state guest.
> >>>
> >>> Would anything break if KVM "speculatively" set guest_state_protected before
> >>> LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?
> >>
> >> Yes, the way the code is set up, the guest state (VMSA) is initialized in
> >> the same way it is today (mostly) and that state is encrypted by the
> >> LAUNCH_UPDATE_VMSA call. I check the guest_state_protected bit to decide
> >> on whether to direct the updates to the real VMSA (before it's encrypted)
> >> or the GHCB (that's the get_vmsa() function from patch #5).
> > 
> > Ah, gotcha.  Would it work to set guest_state_protected[*] from time zero,
> > and move vmsa_encrypted to struct vcpu_svm?  I.e. keep vmsa_encrypted, but
> > use it only for guiding get_vmsa() and related behavior.
> 
> It is mainly __set_sregs() that needs to know when to allow the register
> writes and when not to. During guest initialization, __set_sregs is how
> some of the VMSA is initialized by Qemu.

Hmm.  I assume that also means KVM_SET_REGS and KVM_GET_XCRS are also legal
before the VMSA is encrypted?  If so, then the current behavior of setting
vmsa_encrypted "late" make sense.  KVM_SET_FPU/XSAVE can be handled by not
allocating guest_fpu, i.e. they can be disallowed from time zero without
adding an SEV-ES specific check.

Which brings us back to KVM_SET_GUEST_DEBUG.  What would happen if that were
allowed prior to VMSA encryption?  If LAUNCH_UPDATE_VMSA acts as a sort of
reset, one thought would be to allow KVM_SET_GUEST_DEBUG and then sanitize
KVM's state during LAUNCH_UPDATE_VMSA.  Or perhaps even better, disallow
LAUNCH_UPDATE_VMSA if vcpu->guest_debug!=0.  That would allow using debug
capabilities up until LAUNCH_UPDATE_VMSA without adding much burden to KVM.
