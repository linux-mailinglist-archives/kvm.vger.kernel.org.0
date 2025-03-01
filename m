Return-Path: <kvm+bounces-39792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00704A4A7D9
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 03:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A385D189D0BF
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FAC1531E3;
	Sat,  1 Mar 2025 02:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmKcVDgW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385BC34CF5
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 02:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794794; cv=none; b=OTvR2W8SZk8M3RocEDPX7VZ7tx+rU/y37JiQofrWkzak5QUXXavcIw18EoLKdacGjX1SxaLxIglr1sgevSSkrTdE30QB13+vZDipJCQ0lzFI7dINDKVsH7Z3KYJ5L18E+sE0lajPF+I1dKcv1ko0gIOgjpAyqbnGyv9EHu7/qe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794794; c=relaxed/simple;
	bh=QILr9sz++934hZMnPAaOWfrjkPSrPQ7e33IKYh7aSKw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HIDaU+QguubLnuivykk5V5plgikNZnvrHTCZBWEzMo7tMF5+A6x2W7xNURqTEmueAUAXZKWzDKPwydY4YimRkPMZHVFarCSdhGU1U/SCtAnrCEzkK+Mq+Cf9PJ7e+tg7OPEWecBk1MqsisbsXk4ZVc5Mq84gv55lo/GMwhoxM88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmKcVDgW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740794789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46zCjngKgu0E+YSMJfr/bx6ww9fSSQJMKtZm2IK5CIw=;
	b=bmKcVDgWIEP64lCj9VYwFkTV++/P02XF+Ii51W99exoEkr8NREpj9IhOqLcsJCcjcD0S2K
	vWBPXQAmnctBLqnfJ1EszeEYhFAmCxjYuU131LWiZBctbR+i3rjYhd3n3vHXLjbt5O7cEx
	+8RGvmmzl5Gq7ClZHMuT+4icvBmqG9o=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-d5l6vkLbPX-EDfJvV-gB4w-1; Fri, 28 Feb 2025 21:06:21 -0500
X-MC-Unique: d5l6vkLbPX-EDfJvV-gB4w-1
X-Mimecast-MFC-AGG-ID: d5l6vkLbPX-EDfJvV-gB4w_1740794780
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c0ab4035a1so487029985a.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794780; x=1741399580;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46zCjngKgu0E+YSMJfr/bx6ww9fSSQJMKtZm2IK5CIw=;
        b=W9FyJLPb8igASH6JvidBVQQETKMdjgPuB1Ddn6QOZZ2xENdL59sPbWoDIfhAuloXgf
         MybfUdL5J59FbT5BWBvBzWHEJ1Lw2j+7LC+5Qu/2d9OPfzzJHgOAKgogFdIqKCYIWpvu
         cCjlG3lit9Cl6/2T5ndaT///TyPe0ZyrbxNMLNerkosyYwox3w0ISukcV6GMvldfT2hW
         Suf4tzSDNGNNH09OH9KUFaXaymgZOAhgCpQnXDVbjkOAndPxXsQKujo6C4/h3+QOxQTN
         XL3uW2riIQDrJMTTJ+mV7EVnDB4xVCTarisj/T6DxDSX2V4X39Dya3Ng+pj9XVf9N/18
         gBRA==
X-Gm-Message-State: AOJu0YwbNkvTLhug7ZOsYiXO+w0mj++YPdFiE5ElBm5UehOOfFB8KLOu
	HbewxLQGjLJe2GHkcKFI/zbXrusmXfal+y6pBd6d7dTsgPiji5K2dOJvCiqXRne5pbSjKvhFgvk
	QGcKdsKhpOp1uh5YN9v7CYzJEKq6qRL/0/sXtTHbvvSUbrpeg+g==
X-Gm-Gg: ASbGncuw6wDV8hM10aPAtmGTFtIHbNBckCoujAzn1nGkxXEw7st2QGBEk01hO/bx5nn
	9vvvkpiyb4WE0MSS65LzC1OSbgn5eF1osYKR2uLVp+xduIPK+P3kPyzxYpwskyVxCfHGtcej/E1
	VwJ+7Lv9tpTjWPPt+S5bC7GsiD50ROQSvEfewEbpa1+Tq+tV/9SnTiOaQE0v2Di2qdI+IrNAtM7
	5qVvAQHLA547VCH9Vd38wVfu6FdGGjRiBiUNTa3yjPjjZcINYFFYxYZ86VNZp0NULYg24p6y/2Y
	mI5eB/A5nrc8v5o=
X-Received: by 2002:a05:620a:c44:b0:7c0:b2ab:2693 with SMTP id af79cd13be357-7c39c677674mr845297985a.49.1740794780221;
        Fri, 28 Feb 2025 18:06:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhpXzSeEo+5V50OVPiOsYQ1cUO7305mj4KAY43UTC58KJhq3IDdV7uVGbf38Osl3lEN5AvWw==
X-Received: by 2002:a05:620a:c44:b0:7c0:b2ab:2693 with SMTP id af79cd13be357-7c39c677674mr845295985a.49.1740794779907;
        Fri, 28 Feb 2025 18:06:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c36fef6b03sm317253085a.41.2025.02.28.18.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:06:19 -0800 (PST)
Message-ID: <2dfc8e02c16e78989bee94893cc48d531cdfa909.camel@redhat.com>
Subject: Re: [RFC PATCH 09/13] KVM: nSVM: Handle nested TLB flush requests
 through TLB_CONTROL
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 21:06:18 -0500
In-Reply-To: <20250205182402.2147495-10-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-10-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> Handle L1's requests to flush L2's TLB through the TLB_CONTROL field of
> VMCB12. This is currently redundant because a full flush is executed on
> every nested transition, but is a step towards removing that.
> 
> TLB_CONTROL_FLUSH_ALL_ASID flushes all ASIDs from L1's perspective,
> including its own, so do a guest TLB flush on both transitions. Never
> propagate TLB_CONTROL_FLUSH_ALL_ASID from the guest to the actual VMCB,
> as this gives the guest the power to flush the entire physical TLB
> (including translations for the host and other VMs).
> 
> For other cases, the TLB flush is only done when entering L2. The nested
> NPT MMU is also sync'd because TLB_CONTROL also flushes NPT
> guest-physical mappings.
> 
> All TLB_CONTROL values can be handled by KVM regardless of FLUSHBYASID
> support on the underlying CPU, so keep advertising FLUSHBYASID to the
> guest unconditionally.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.c    |  6 +++---
>  2 files changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0735177b95a1d..e2c59eb2907e8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -484,19 +484,36 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
>  	/* Handle pending Hyper-V TLB flush requests */
>  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
>  
> +	/*
> +	 * If L1 requested a TLB flush for L2, flush L2's TLB on nested entry
> +	 * and sync the nested NPT MMU, as TLB_CONTROL also flushes NPT
> +	 * guest-physical mappings. We technically only need to flush guest_mode
> +	 * page tables.
> +	 *
> +	 * KVM_REQ_TLB_FLUSH_GUEST will flush L2's ASID even if the underlying
> +	 * CPU does not support FLUSHBYASID (by assigning a new ASID), so we
> +	 * can handle all TLB_CONTROL values from L1 regardless.
> +	 *
> +	 * Note that TLB_CONTROL_FLUSH_ASID_LOCAL is handled exactly like
> +	 * TLB_CONTROL_FLUSH_ASID. We can technically flush less TLB entries,
> +	 * but this would require significantly more complexity.
> +	 */

I think it might make sense to note that we in essence support only one non zero ASID
in L1, the one that it picks for the nested guest.


Thus when asked to TLB_CONTROL_FLUSH_ALL_ASID 
we need to flush the L2's real asid and L1 asid only.


> +	if (svm->nested.ctl.tlb_ctl != TLB_CONTROL_DO_NOTHING) {
> +		if (nested_npt_enabled(svm))
> +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +	}
> +
>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
>  	 *
> -	 *  - Honor L1's request to flush an ASID on nested VMRUN
> -	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
>  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> -	 *
> -	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
> -	 *     NPT guest-physical mappings on VMRUN.
>  	 */
>  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> @@ -504,9 +521,18 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  
>  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
>  	/* Handle pending Hyper-V TLB flush requests */
>  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
>  
> +	/*
> +	 * If L1 had requested a full TLB flush when entering L2, also flush its
> +	 * TLB entries when exiting back to L1.
> +	 */
> +	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);

Makes sense.

> +
>  	/* See nested_svm_entry_tlb_flush() */
>  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> @@ -825,7 +851,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
> +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip,
> +				      vmcb12->save.cs.base);
>  	nested_vmcb02_prepare_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1764,7 +1791,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	nested_copy_vmcb_control_to_cache(svm, ctl);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
> +	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip,
> +				      svm->vmcb->save.cs.base);
>  
>  	/*
>  	 * While the nested guest CR3 is already checked and set by
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8342c7eadbba8..5e7b1c9bfa605 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5242,9 +5242,9 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
>  
>  		/*
> -		 * KVM currently flushes TLBs on *every* nested SVM transition,
> -		 * and so for all intents and purposes KVM supports flushing by
> -		 * ASID, i.e. KVM is guaranteed to honor every L1 ASID flush.
> +		 * KVM currently handles all TLB_CONTROL values set by L1, even
> +		 * if the underlying CPU does not. See
> +		 * nested_svm_transition_tlb_flush().
>  		 */
>  		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
>  

Patch looks OK, but I can't be 100% sure about this.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



