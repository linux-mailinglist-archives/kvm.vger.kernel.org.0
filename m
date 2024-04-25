Return-Path: <kvm+bounces-15883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4518B17D5
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 02:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363B1286E21
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 00:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9C8A946;
	Thu, 25 Apr 2024 00:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z8UT9TB/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DE67483
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 00:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714003837; cv=none; b=P6FA3EZJmejEX6ltpI4FJL3rSSc0jphA5TbQQ8sq1KgmQmJ1M+9xd7M7AVQsX5HlxgjRWK9NNBsaWb9DSGytAzMvhrzezDl8jM7RR9X6MHlFYoWcCz+ergUb1L+0NlXu7LdsE7U28fucaso2xrrAh2V60nfWJWVV8ieOmEmlBxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714003837; c=relaxed/simple;
	bh=4olyWBhbURGb211ubhYVBSsTHwRpqR+5x91FGXsu6m0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DaEhnrD9B7LYXXREmo2kvvgAV/YMStP8nl/gZQymtsnAvgWnmoLSU/NBP890Q0oqOFqDmirGVXFg0EFCB4K2VaGvFhHkqlAfodUw5RuWK/PK55LPNqVsvzfldMWv29OVnln6qp4eRAhFbGMOUQkRo7t91GH/oVgdDHc6hERfFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z8UT9TB/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-60361c6fa70so453622a12.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 17:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714003834; x=1714608634; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5N7e8KrpK+QWo2qlcDE/Q43TLjk+9JOMfjvUXwfuODw=;
        b=z8UT9TB/0GluAFz6GeyaCatIzLaU9xm5Yxa27BPMZelJwQAtFs8aDoDViev1Fi+pwd
         1ppwdrKH4eetcw+UW9SHfwcDKm/FkphLf801wLMferEQXiT6s8B2jSHpQO+4aGmVarvp
         YJxJANh4EE1b+p1zGTQ1tZWXG66dnoBHe88v4Hp4OuYSWUmkKAPTjb5fGOC8g3uINHbC
         6ZYTAsUtUfzL3w9yLpiPRl8wM15tXEsPXMpTCuNIBgRhA2V1RQV9uljvTnC/tp4n25u6
         GBEzzqvHssWTTveg3+M0rfb0U/MmLt7TdkACFUmo48JN+GjzbidFtmyek74Ih+CowlRx
         UwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714003834; x=1714608634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5N7e8KrpK+QWo2qlcDE/Q43TLjk+9JOMfjvUXwfuODw=;
        b=pwNEArO9pqlyv6NFLgpe91NNJ0jdEhlLUqjEsE6W1sCL12OjMvOJa+BJ17L59IYdt6
         LwoL7HtT5JphokfGMwZ9pMEFSrLxQpuuUzFlIDp7fbVknS+Wx6FKpKZVTB1ao0jbJ9qS
         AmbgcrMPWKNMz6MxBMePuKsOk5dspnGR/oefmLQLNkmsB0NyDehZlnkeMuY6DqGuHW8T
         6zj+Uwxska2BxN3tE5HAFFGkr6QH+CcOpoVnBeur3HXMVYic0WBg3Nh14Qns/PUbmfbL
         D21HNywVihdVIEY3KK6K4mAuQ54jC8VbI9swLhdy+r13wTAB53COfsdbAw8m11iCzB8C
         bF5Q==
X-Gm-Message-State: AOJu0YzxcKvxUwRodqYDjhR/ve/4Dugv4H+sxhVFr75MgrJ+LNla0yHM
	B62ldSe7bQTzoScFIbjk0jsCBJxJYP3fw2K37Hh0HXs/Yi6THYkYs23+NhLYdVUHvR5S+DUxld2
	CPw==
X-Google-Smtp-Source: AGHT+IFH7YJejg8aWF910482kJMDW7kl7X1aXoPxYZwY3TSrYpuIPMQ5VJ886sB92FreyvdaA+vS2YP1euA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1d2:0:b0:5dc:8f95:3d with SMTP id
 201-20020a6301d2000000b005dc8f95003dmr31874pgb.2.1714003833568; Wed, 24 Apr
 2024 17:10:33 -0700 (PDT)
Date: Wed, 24 Apr 2024 17:10:31 -0700
In-Reply-To: <20240421180122.1650812-23-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-23-michael.roth@amd.com>
Message-ID: <Zimfdyhq3U2HVX0N@google.com>
Subject: Re: [PATCH v14 22/22] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85099198a10f..6cf186ed8f66 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7066,6 +7066,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>  		struct kvm_user_vmgexit {
>  		#define KVM_USER_VMGEXIT_PSC_MSR	1
>  		#define KVM_USER_VMGEXIT_PSC		2
> +		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3

Assuming we can't get massage this into a vendor agnostic exit, there's gotta be
a better name than EXT_GUEST_REQ, which is completely meaningless to me and probably
most other people that aren't intimately familar with the specs.  Request what?

>  			__u32 type; /* KVM_USER_VMGEXIT_* type */
>  			union {
>  				struct {
> @@ -3812,6 +3813,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
>  }
>  
> +static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_control_area *control;
> +	struct kvm *kvm = vcpu->kvm;
> +	sev_ret_code fw_err = 0;
> +	int vmm_ret;
> +
> +	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
> +	if (vmm_ret) {
> +		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
> +			vcpu->arch.regs[VCPU_REGS_RBX] =
> +				vcpu->run->vmgexit.ext_guest_req.data_npages;
> +		goto abort_request;
> +	}
> +
> +	control = &svm->vmcb->control;
> +
> +	/*
> +	 * To avoid the message sequence number getting out of sync between the
> +	 * actual value seen by firmware verses the value expected by the guest,
> +	 * make sure attestations can't get paused on the write-side at this
> +	 * point by holding the lock for the entire duration of the firmware
> +	 * request so that there is no situation where SNP_GUEST_VMM_ERR_BUSY
> +	 * would need to be returned after firmware sees the request.
> +	 */
> +	mutex_lock(&snp_pause_attestation_lock);

Why is this in KVM?  IIUC, KVM only needs to get involved to translate GFNs to
PFNs, the rest can go in the sev-dev driver, no?  The whole split is weird,
seemingly due to KVM "needing" to take this lock.  E.g. why is core kernel code
in arch/x86/virt/svm/sev.c at all dealing with attestation goo, when pretty much
all of the actual usage is (or can be) in sev-dev.c

> +
> +	if (__snp_transaction_is_stale(svm->snp_transaction_id))
> +		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
> +	else if (!__snp_handle_guest_req(kvm, control->exit_info_1,
> +					 control->exit_info_2, &fw_err))
> +		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> +
> +	mutex_unlock(&snp_pause_attestation_lock);
> +
> +abort_request:
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> +
> +	return 1; /* resume guest */
> +}
> +
> +static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> +{
> +	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned long data_npages;
> +	sev_ret_code fw_err;
> +	gpa_t data_gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm))
> +		goto abort_request;
> +
> +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
> +		goto abort_request;
> +
> +	svm->snp_transaction_id = snp_transaction_get_id();
> +	if (snp_transaction_is_stale(svm->snp_transaction_id)) {

Why bother?  I assume this is rare, so why not handle it on the backend, i.e.
after userspace does its thing?  Then KVM doesn't even have to care about
checking for stale IDs, I think?

None of this makes much sense to my eyes, e.g. AFAICT, the only thing that can
pause attestation is userspace, yet the kernel is responsible for tracking whether
or not a transaction is fresh?

