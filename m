Return-Path: <kvm+bounces-40117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B12B8A4F4F8
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0DC516D0BF
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766E4155A21;
	Wed,  5 Mar 2025 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YM6I3pEB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B7153800
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143460; cv=none; b=Y6Fp2nNU4rB38cOoz3nNy4Q598rGOIpty9eWpAkggRjZ/07oWTGsQpiKAmLXx8t8qk4az6OQWLir3UdAS7czMcmdM9otcV5NB4iK0RpdwllcQ2Vvi9bowGyqGOJ3MilgN29i5jderBhT9FH+V7gYT2uTLVuE8qHE/tyiXSg3c8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143460; c=relaxed/simple;
	bh=aGKbrULwTdTRyT0A0kuO9eEUK3LxuA3FDrupb74BRd8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E+XIpeQNGAF9RrZEmp7HU+iyIwzchtFQDbDpdwbybE8H9FiLKhHXv08wgTJ3bOzXHUAbkoNxFNzxpdYx7oTHbMwjQk7ibc6G1ORLSjMS29RDHu4TAufk944axk6sEcWBy0hdL5RMfRomP/pEgSeH+LtBgczZLmWaXGJllRGXJEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YM6I3pEB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741143457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k22zgh/jyAhJXidTGCj8WdWHgPrd2RoeEQ1YeZh9VQU=;
	b=YM6I3pEB0GmfPlrfjfNHjokAvn79Ujs2rodJyqwER1NK5AQLIaorJNLcJJkY/Ny/xH1moC
	xVpUtJrAiaBFuxIWPJ+mRL4QF0S+LGRJk73YolvpHTpdMMX2A1DzvOKzfuBsOwRMQwvakp
	LRZuabjzGTWemH2Y5AU7tUjh9rVYksA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-8ksEwDQEOfC1H_N-z3YqpA-1; Tue, 04 Mar 2025 21:57:26 -0500
X-MC-Unique: 8ksEwDQEOfC1H_N-z3YqpA-1
X-Mimecast-MFC-AGG-ID: 8ksEwDQEOfC1H_N-z3YqpA_1741143446
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e6bb677312so118289316d6.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 18:57:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741143446; x=1741748246;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k22zgh/jyAhJXidTGCj8WdWHgPrd2RoeEQ1YeZh9VQU=;
        b=tx1+7wXTkgIrBuPRkksQfHXL/CYwOwyxyvZvNZa1MpWGgdSDQ9eBbf1mpC+voMX1xj
         1BnNxufwAqChojZk2tqSetkvMYGSreNxPQppALV9/kw8AbQAVjkqdT0HEzMgmEqOu7aw
         qct5IbfGhsKFCG7YxZpDs4njDlRVh12KKeEtsWLLGBEVfYOZ8bDHfQ4RroPKN1Y1pzR0
         xIpre4kcYHgvjttqqfK2RmT8CsTfZAf8T7hm1qY3xCFnVkh4bKxSkjKEp7THNq5ZCKdQ
         LtBQOBMwqfZUUaJ9zeSdN13aSsjCTjsoa7hsG8GOcRMftFSk91+VT33WUYMOhd0HERN9
         1w1g==
X-Forwarded-Encrypted: i=1; AJvYcCURrp2t47xFtYsD5ZF8/ocuhAFRkHhViIIA10bT3UGx7Sux+nh/R+8CKSVJYqaq5zcwTv8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy71BnlSsxj5RJGsdVFA/n/HRkqsRnwcKc6haotZDniaAR8+qrW
	N4KSayhxQ7obkRIAERiZZBIsPW/3fbCEc6kZL5YBDlLKccflQ/UPPorDkUFIkUm/U+senRbRuNJ
	BdT5COn0rxuY44Bp7dto8RJDhgzQ1zUMGf2FeeKZfLAgOWgFsMg==
X-Gm-Gg: ASbGncshn958UTcB6HbKj17WocYB3cZ752s3qIuPZbizHDa8NzOwWB+eKIOdrH79P/b
	25ZKJC7rUzKU2Z9E2BycAk1mxijcdYbKgX8Zh+3Dy5C1qUf0HJwg12TkCjGhnaCqZatxC94/NAd
	kYjNgBkqQPs+3SAHzvzDznT5voEYLGCgrqqz8v5nvF7wyeTkY6Hzvef/PbjrFxh6yYbuUwzyqbF
	L7tszEXDd+HdEdqs0p0+dRB5juIAGuZ/rDlJVI8BSyadU/a54kpVB98sncItYeOA8ev25UXOCt2
	MmgO5NpFp5jBepg=
X-Received: by 2002:a05:6214:1d0a:b0:6e8:91fd:cfc1 with SMTP id 6a1803df08f44-6e8e6cc7c25mr25924276d6.8.1741143445884;
        Tue, 04 Mar 2025 18:57:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3t4AK4fYtyo86fru1RHMwYN6P4wHGOvLU4MQp/ldo7sNJZGdqoRV/DagPPmpy/Tv+u7OWHA==
X-Received: by 2002:a05:6214:1d0a:b0:6e8:91fd:cfc1 with SMTP id 6a1803df08f44-6e8e6cc7c25mr25924086d6.8.1741143445523;
        Tue, 04 Mar 2025 18:57:25 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976eb136sm73941656d6.117.2025.03.04.18.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 18:57:25 -0800 (PST)
Message-ID: <910d5380b320ad39081c4a32ba643e6ad1cfcd55.camel@redhat.com>
Subject: Re: [RFC PATCH 09/13] KVM: nSVM: Handle nested TLB flush requests
 through TLB_CONTROL
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 21:57:24 -0500
In-Reply-To: <Z8Yovz0I3QLuq6VQ@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-10-yosry.ahmed@linux.dev>
	 <2dfc8e02c16e78989bee94893cc48d531cdfa909.camel@redhat.com>
	 <Z8Yovz0I3QLuq6VQ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 22:10 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 09:06:18PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > > Handle L1's requests to flush L2's TLB through the TLB_CONTROL field of
> > > VMCB12. This is currently redundant because a full flush is executed on
> > > every nested transition, but is a step towards removing that.
> > > 
> > > TLB_CONTROL_FLUSH_ALL_ASID flushes all ASIDs from L1's perspective,
> > > including its own, so do a guest TLB flush on both transitions. Never
> > > propagate TLB_CONTROL_FLUSH_ALL_ASID from the guest to the actual VMCB,
> > > as this gives the guest the power to flush the entire physical TLB
> > > (including translations for the host and other VMs).
> > > 
> > > For other cases, the TLB flush is only done when entering L2. The nested
> > > NPT MMU is also sync'd because TLB_CONTROL also flushes NPT
> > > guest-physical mappings.
> > > 
> > > All TLB_CONTROL values can be handled by KVM regardless of FLUSHBYASID
> > > support on the underlying CPU, so keep advertising FLUSHBYASID to the
> > > guest unconditionally.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++++-------
> > >  arch/x86/kvm/svm/svm.c    |  6 +++---
> > >  2 files changed, 38 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 0735177b95a1d..e2c59eb2907e8 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -484,19 +484,36 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
> > >  
> > >  static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> > >  {
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > >  	/* Handle pending Hyper-V TLB flush requests */
> > >  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> > >  
> > > +	/*
> > > +	 * If L1 requested a TLB flush for L2, flush L2's TLB on nested entry
> > > +	 * and sync the nested NPT MMU, as TLB_CONTROL also flushes NPT
> > > +	 * guest-physical mappings. We technically only need to flush guest_mode
> > > +	 * page tables.
> > > +	 *
> > > +	 * KVM_REQ_TLB_FLUSH_GUEST will flush L2's ASID even if the underlying
> > > +	 * CPU does not support FLUSHBYASID (by assigning a new ASID), so we
> > > +	 * can handle all TLB_CONTROL values from L1 regardless.
> > > +	 *
> > > +	 * Note that TLB_CONTROL_FLUSH_ASID_LOCAL is handled exactly like
> > > +	 * TLB_CONTROL_FLUSH_ASID. We can technically flush less TLB entries,
> > > +	 * but this would require significantly more complexity.
> > > +	 */
> > 
> > I think it might make sense to note that we in essence support only one non zero ASID
> > in L1, the one that it picks for the nested guest.
> > 
> > 
> > Thus when asked to TLB_CONTROL_FLUSH_ALL_ASID 
> > we need to flush the L2's real asid and L1 asid only.
> 
> This is described by the comment in nested_svm_exit_tlb_flush(). Do you
> mean that we should also mention that here?
> 
> I guess one way to make things clearer is to describe the behavior for
> all values of TLB_CONTROL here, and in nested_svm_exit_tlb_flush() just
> say /* see nested_svm_entry_tlb_flush() */. Would that improve things?

I guess that this will be a bit better.
This was just a tiny nitpick though, just something I wondered a bit when
reviewing.


Best regards,
	Maxim Levitsky



> 
> > 
> > > +	if (svm->nested.ctl.tlb_ctl != TLB_CONTROL_DO_NOTHING) {
> > > +		if (nested_npt_enabled(svm))
> > > +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > > +	}
> > > +
> > >  	/*
> > >  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
> > >  	 * things to fix before this can be conditional:
> > >  	 *
> > > -	 *  - Honor L1's request to flush an ASID on nested VMRUN
> > > -	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
> > >  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> > > -	 *
> > > -	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
> > > -	 *     NPT guest-physical mappings on VMRUN.
> > >  	 */
> > >  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > >  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > > @@ -504,9 +521,18 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> > >  
> > >  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> > >  {
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > >  	/* Handle pending Hyper-V TLB flush requests */
> > >  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> > >  
> > > +	/*
> > > +	 * If L1 had requested a full TLB flush when entering L2, also flush its
> > > +	 * TLB entries when exiting back to L1.
> > > +	 */
> > > +	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
> > > +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > 
> > Makes sense.
> > 
> > > +
> > >  	/* See nested_svm_entry_tlb_flush() */
> > >  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > >  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > > @@ -825,7 +851,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> > >  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
> > >  
> > >  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > > -	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
> > > +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip,
> > > +				      vmcb12->save.cs.base);
> > >  	nested_vmcb02_prepare_save(svm, vmcb12);
> > >  
> > >  	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> > > @@ -1764,7 +1791,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> > >  	nested_copy_vmcb_control_to_cache(svm, ctl);
> > >  
> > >  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > > -	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
> > > +	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip,
> > > +				      svm->vmcb->save.cs.base);
> > >  
> > >  	/*
> > >  	 * While the nested guest CR3 is already checked and set by
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 8342c7eadbba8..5e7b1c9bfa605 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -5242,9 +5242,9 @@ static __init void svm_set_cpu_caps(void)
> > >  		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
> > >  
> > >  		/*
> > > -		 * KVM currently flushes TLBs on *every* nested SVM transition,
> > > -		 * and so for all intents and purposes KVM supports flushing by
> > > -		 * ASID, i.e. KVM is guaranteed to honor every L1 ASID flush.
> > > +		 * KVM currently handles all TLB_CONTROL values set by L1, even
> > > +		 * if the underlying CPU does not. See
> > > +		 * nested_svm_transition_tlb_flush().
> > >  		 */
> > >  		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
> > >  
> > 
> > Patch looks OK, but I can't be 100% sure about this.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 



