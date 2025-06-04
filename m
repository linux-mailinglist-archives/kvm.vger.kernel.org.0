Return-Path: <kvm+bounces-48409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70092ACDFC5
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9DB53A6AF1
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340DC2900A8;
	Wed,  4 Jun 2025 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cE35S6Gl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4145217F3D
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749045746; cv=none; b=rIey4UcLvHFZYsy2yaE1wbqrwAYr64NUoU+zvrnRHFoIT1y0mlA0dKq9zD6Kh1qUfX5JW3E0FDhSz+AvAwRSqAB1AZz7OoR5fLAHJ5/iYt0r45s7F01l6NL4mMqSK4IdlXCppRnXsnfFebjwm08uirulgNBU5u/m0hCMuBJ9eZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749045746; c=relaxed/simple;
	bh=SF2TUI7mUMzc/jSBFlCExxvSiZraFWQni6zRHWJeB4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O2OdaqmPFAyWC8pKW4uL/Vf/PiiFjr7TkBAmNkz47UOm2qQLYRMcAXB0/zF5Ed7Wyco9rH4a4bdBKF+ppckD8f9qIxQszdfMnFdyYjOu12O05OxkCV0R0aXZHethl7KV7QaFUkpMZty3MccVit5FRK821kcu2uAF+ktJTAdKTOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cE35S6Gl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311b6d25163so6250342a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 07:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749045744; x=1749650544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4H4b6gj2RPA1NSrnkWfDydCjI09ZASRQKphvEZK2b8s=;
        b=cE35S6GlhsRDrfcQ4WEL/rCkHwGVKBsIoIaWsj4cFbPq+IozhwD5kY+6X2L+AR8x8w
         InGzc1vW/cJWKxHrahvIQnghy8uki7b6+RESwHb7olNIzlKsLtELGhuKPygNomX9KhPy
         GQEBmZYCaa38LlbsG36e/iLJQKuQ2cQ80TNPdPt4lIWfG7EPcH5nE/B8NaeCqtBcuhb4
         T4UWqwGlhYxMZS97dhtbTwHOfdoEuZDOC6roBfgEzmjUSt7UksSiSZ4W2/I/sSfcfHFl
         9aiH512lsLaHVmq6cWVDBW1PyCWG3/F/EB8VPmkfLvdA/3X96Udd4kDlfFkM5X7yNxwk
         ruWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749045744; x=1749650544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4H4b6gj2RPA1NSrnkWfDydCjI09ZASRQKphvEZK2b8s=;
        b=q2TuoMg4xzFoqH1+pGI0W2e98RUEKgnkbVPifG68T2Hm0OkIN+YNjuQyH6ng6TQZvp
         m3xZEsVJNRdQB6T0Gr3AMbiGkxZsRAhNJpQpJfW6jh0yvS3cEbyPY0T0+XfWEaUbj9v2
         phuuOV+WJtYJOO5rz7O7BORtrNKTU46DyCopkpHLCXPRzkqNmPLzTfm3VoGPD4b5Ruqs
         coH5boih1KftZbfed90TxTXI/lvdVcB58BN34SvFJg0/LQ4iCiPsWPKJCEucKzRqTntH
         jLAbqMaCDaiEtszDD35GUKOc7r+mgJt4JjMjWegsdr3LIIU2ImYoW0pMRkl4d3ThF+bO
         B8xg==
X-Gm-Message-State: AOJu0YzjYW6TWZ46jWRgHfk1daSLXY6Cm6cq1GqdvmSbjwH0ZslpRnti
	B9RV028mCX42YMESEGd6HcmAcWzgVxxTo+VqfpGMHiPau84HQxWDz7TYS6SctyUTmWoZ9uaetbr
	0TtHEaQ==
X-Google-Smtp-Source: AGHT+IHaoqvtVI0Yz46iIwHy/iA5qtPYPdu+XqdbPfhM44STMOd9JolDoyV7EuaxX4Sn5kzKGTMBLEw92Is=
X-Received: from pjbrj10.prod.google.com ([2002:a17:90b:3e8a:b0:313:221f:6571])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5587:b0:311:d05c:936
 with SMTP id 98e67ed59e1d1-3130cd31f24mr5027744a91.17.1749045744042; Wed, 04
 Jun 2025 07:02:24 -0700 (PDT)
Date: Wed, 4 Jun 2025 07:02:22 -0700
In-Reply-To: <aC-otXnBwHsdZ7B4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522005555.55705-1-mlevitsk@redhat.com> <20250522005555.55705-4-mlevitsk@redhat.com>
 <aC-XmCl9SVX39Hgl@google.com> <aC-otXnBwHsdZ7B4@google.com>
Message-ID: <aEBR7mbg-iTYdCtJ@google.com>
Subject: Re: [PATCH v5 3/5] KVM: nVMX: check vmcs12->guest_ia32_debugctl value
 given by L2
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 22, 2025, Sean Christopherson wrote:
> +Jim
> 
> On Thu, May 22, 2025, Sean Christopherson wrote:
> > On Wed, May 21, 2025, Maxim Levitsky wrote:
> > > Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
> > > being able to load arbitrary values to hardware IA32_DEBUGCTL.
> > > 
> > > Reviewed-by: Chao Gao <chao.gao@intel.com>
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 3 ++-
> > >  arch/x86/kvm/vmx/vmx.c    | 2 +-
> > >  arch/x86/kvm/vmx/vmx.h    | 1 +
> > >  3 files changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index e073e3008b16..00f2b762710c 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3146,7 +3146,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> > >  		return -EINVAL;
> > >  
> > >  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> > > -	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
> > > +	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > +	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false))))
> > 
> > This is a breaking change.  For better or worse (read: worse), KVM's ABI is to
> > drop BTF and LBR if they're unsupported (the former is always unsupported).
> > Failure to honor that ABI means L1 can't excplitly load what it think is its
> > current value into L2.
> > 
> > I'll slot in a path to provide another helper for checking the validity of
> > DEBUGCTL.  I think I've managed to cobble together something that isn't too
> > horrific (options are a bit limited due to the existing ugliness).
> 
> And then Jim ruined my day.  :-)
> 
> As evidenced by this hilarious KUT testcase, it's entirely possible there are
> existing KVM guests that are utilizing/abusing DEBUGCTL features.
> 
> 	/*
> 	 * Optional RTM test for hardware that supports RTM, to
> 	 * demonstrate that the current volume 3 of the SDM
> 	 * (325384-067US), table 27-1 is incorrect. Bit 16 of the exit
> 	 * qualification for debug exceptions is not reserved. It is
> 	 * set to 1 if a debug exception (#DB) or a breakpoint
> 	 * exception (#BP) occurs inside an RTM region while advanced
> 	 * debugging of RTM transactional regions is enabled.
> 	 */
> 	if (this_cpu_has(X86_FEATURE_RTM)) {
> 		vmcs_write(ENT_CONTROLS,
> 			   vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
> 		/*
> 		 * Set DR7.RTM[bit 11] and IA32_DEBUGCTL.RTM[bit 15]
> 		 * in the guest to enable advanced debugging of RTM
> 		 * transactional regions.
> 		 */
> 		vmcs_write(GUEST_DR7, BIT(11));
> 		vmcs_write(GUEST_DEBUGCTL, BIT(15));
> 		single_step_guest("Hardware delivered single-step in "
> 				  "transactional region", starting_dr6, 0);
> 		check_db_exit(false, false, false, &xbegin, BIT(16),
> 			      starting_dr6);
> 	} else {
> 		vmcs_write(GUEST_RIP, (u64)&skip_rtm);
> 		enter_guest();
> 	}
> 
> For RTM specifically, disallowing DEBUGCTL.RTM but allowing DR7.RTM seems a bit
> silly.  Unless there's a security concern, that can probably be fixed by adding
> support for RTM.  Note, there's also a virtualization hole here, as KVM doesn't
> vet DR7 beyond checking that bits 63:32 are zero, i.e. a guest could set DR7.RTM
> even if KVM doesn't advertise support.  Of course, closing that hole would require
> completely dropping support for disabling DR interception, since VMX doesn't
> give per-DR controls.
>
> For the other bits, I don't see a good solution.  The only viable options I see
> are to silently drop all unsupported bits (maybe with a quirk?), or enforce all
> bits and cross our fingers that no L1 VMM is running guests with those bits set
> in GUEST_DEBUGCTL.

Paolo and I discussed this in PUCK this morning.

We agree trying to close the DR7 virtualization hole would be futile, and that we
should add support for DEBUGCTL.RTM to avoid breaking use of that specific bit.

For the other DEBUGCTL bits, none of them actually work (although, somewhat
amusingly, FREEZE_WHILE_SMM would "work" for real SMIs, which aren't visible to
L1), so we're going to roll the dice, cross our fingers that no existing workload
is setting those bits only in vmcs12.GUEST_DEBUGCTL, and enforce
vmx_get_supported_debugctl() at VM-Enter without any quirk.

  6   TR: Setting this bit to 1 enables branch trace messages to be sent.
  7   BTS: Setting this bit enables branch trace messages (BTMs) to be logged in a BTS buffer.
  8   BTINT: When clear, BTMs are logged in a BTS buffer in circular fashion.
  9   BTS_OFF_OS: When set, BTS or BTM is skipped if CPL = 0.
  10  BTS_OFF_USR: When set, BTS or BTM is skipped if CPL > 0.
  11  FREEZE_LBRS_ON_PMI: When set, the LBR stack is frozen on a PMI request.
  12  FREEZE_PERFMON_ON_PMI: When set, each ENABLE bit of the global counter control MSR are frozen on a PMI request.
  13  ENABLE_UNCORE_PMI: When set, enables the logical processor to receive and generate PMI on behalf of the uncore.
  14  FREEZE_WHILE_SMM: When set, freezes perfmon and trace messages while in SMM.

