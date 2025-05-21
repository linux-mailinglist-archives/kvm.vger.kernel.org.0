Return-Path: <kvm+bounces-47275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D0FABF81B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214553AE214
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9A21DC9B5;
	Wed, 21 May 2025 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wXkGCkhN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A29188CCA
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838718; cv=none; b=bzX4sFHwB28s7uneCr8u5BDg8izgojVLNvLbb0HHfLP+3c1QsTYjfo7IX03HhFB1Vh6odG24Oz6w+7ekEpFHfe/RNCU57r8GFnnf7uLm+W3zHKgA94cXZ7mYTLOsZyWm2PZFisBcQaoJAxPA22DxI39K/kKsd2CLR9XvMFZTrKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838718; c=relaxed/simple;
	bh=sidpF4sfJBBUleOh6a+6izFFQKVFNqPgJN1yZk4Hjt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W20QMe4ByjlhCDbpu628Wera2oOrb6wx+cdcPtT5bTW3OGgShmeGhL8bI01qFlUN4YW7wj2g8SDErx+ihAXfw/kfJtN6S/qeCMvADjPS3NsEfOjK0CBXrtT/3WTEDdjFSqGP/k0bkGi573WsFldYaIgSpu+wxHwGvmeKtJL2Ztc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wXkGCkhN; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b269789425bso7176127a12.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747838716; x=1748443516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OV3HeD68X5N2HjLL1dYAYLv83kXznVC8n6fW8T6WEmU=;
        b=wXkGCkhNcH8nOeXUdpah+rM6+1ziQfaFNaI3klMoyf1uwo0rQj1lDyL402/P4xjvIc
         +kMgHR+TejQGiFw+/9vxjYvAX1QJHkCKev/9yWIDBWJCWMp2WL67JIN9MfDnCpslvclA
         +Utx5xFkP+YhgN0v9ilQXLK7KT3eJnWLB+EMxGkXyVRsKf+Q3VyG0yjK9LamK7TDRZbS
         bkKREvI9q3YIg3BRYU+YNWxQnKZ7mASUeO+9JIn2q1USDU/Ttc4lTSgykrtynu53cb6K
         qE4/FWmNhg+oiDsRoSl6s+czavVDo3jTEF04C52Kt3LqMV2tp61iQUeL0L2rKdNemZJ+
         PlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838716; x=1748443516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OV3HeD68X5N2HjLL1dYAYLv83kXznVC8n6fW8T6WEmU=;
        b=I5sZ7R0Qd0RyLlzr4uQX0DjWc5SJUePaNzJPZhhZzqtz7U8r8ClTOfZJI5nOXoQjsT
         mxm+rVVeZJUEvk5ZMn2s93ID7tNGPOYYzLkqBRaWSqWo73Bq6rYP8UWcc3lR0m7ZU4vU
         L/yD0jr81chwm6wuQHY24GLuheknYrg/H7RQPSh6R3uSzUYmwas0zan65trH/sNfZlI3
         RLAk1lbq4+Q4IEfImz+3notW0LgizNzjsJ8REnyxMiJnFgAg8FtEdHVg3xjJD6TzNuZD
         n54FpfCCgnpRvZLB8pjuYWtgc8+uOD7BiU6Akk+A6RbnCWkUNK2KChmrlLUq68moK6YH
         1tMw==
X-Gm-Message-State: AOJu0Yw0I5abjHuVj308xAZR58x28CmcVPVQ+J/ugRjyCqG4WP7Eo3bs
	buebcEN9deXQ6yOaWrTQ3Bd/CIqV8LJI74tzB4bU9frBVLOzBQhI/OfoFtQzE712R0tPDW4qk7U
	ei8Wrrw==
X-Google-Smtp-Source: AGHT+IEeTmwVlYaTlQFYxlXvbl4oy21icgsEGds5/vQFLPfEpqjkg9FddL9Vfq4OEdSGr+6Yp9d4ksWEb1M=
X-Received: from pjx8.prod.google.com ([2002:a17:90b:5688:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c8c:b0:2fe:8c22:48b0
 with SMTP id 98e67ed59e1d1-30e7d555a3bmr30484637a91.15.1747838716138; Wed, 21
 May 2025 07:45:16 -0700 (PDT)
Date: Wed, 21 May 2025 07:45:14 -0700
In-Reply-To: <20250428195113.392303-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250428195113.392303-1-michael.roth@amd.com> <20250428195113.392303-2-michael.roth@amd.com>
Message-ID: <aC3m1uMmp28gSm3r@google.com>
Subject: Re: [PATCH v6 1/2] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, liam.merwick@oracle.com, dionnaglaze@google.com, 
	huibo.wang@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 28, 2025, Michael Roth wrote:
> For SEV-SNP, the host can optionally provide a certificate table to the
> guest when it issues an attestation request to firmware (see GHCB 2.0
> specification regarding "SNP Extended Guest Requests"). This certificate
> table can then be used to verify the endorsement key used by firmware to
> sign the attestation report.
> 
> While it is possible for guests to obtain the certificates through other
> means, handling it via the host provides more flexibility in being able
> to keep the certificate data in sync with the endorsement key throughout
> host-side operations that might resulting in the endorsement key
> changing.
> 
> In the case of KVM, userspace will be responsible for fetching the
> certificate table and keeping it in sync with any modifications to the
> endorsement key by other userspace management tools. Define a new
> KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
> the buffer the guest has provided as part of the attestation request so
> that userspace can write the certificate data into it while relying on
> filesystem-based locking to keep the certificates up-to-date relative to
> the endorsement keys installed/utilized by firmware at the time the
> certificates are fetched.
> 
>   [Melody: Update the documentation scheme about how file locking is
>   expected to happen.]
> 
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Tested-by: Liam Merwick <liam.merwick@oracle.com>
> Tested-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Melody Wang <huibo.wang@amd.com>

Heh, gotta love the chaos that of tossing around a patch between its original
author and someone else.

The SoB chain should technically be:

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
[Melody: Update the documentation scheme about how file locking is
         expected to happen]
Signed-off-by: Michael Roth <michael.roth@amd.com>

> ---
>  Documentation/virt/kvm/api.rst | 80 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/sev.c         | 50 ++++++++++++++++++---
>  arch/x86/kvm/svm/svm.h         |  1 +
>  include/uapi/linux/kvm.h       |  9 ++++
>  include/uapi/linux/sev-guest.h |  8 ++++
>  5 files changed, 142 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index ad1859f4699e..a838289618b5 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7194,6 +7194,86 @@ Please note that the kernel is allowed to use the kvm_run structure as the
>  primary storage for certain register types. Therefore, the kernel may use the
>  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>  
> +::
> +
> +		/* KVM_EXIT_SNP_REQ_CERTS */
> +		struct kvm_exit_snp_req_certs {
> +			__u64 gfn;

Hmm, a bit late on feedback, but I think I'd prefer to provide the gpa, not the
gfn.  The address provided by the guest is a GPA, and similar KVM exits like
KVM_HC_MAP_GPA_RANGE provide gpa+npages.

> +			__u64 npages;
> +			__u64 ret;
> +		};
> +
> +This event provides a way to request certificate data from userspace and
> +have it written into guest memory. This is intended to handle attestation
> +requests made by SEV-SNP guests (using the Extended Guest Requests GHCB
> +command as defined by the GHCB 2.0 specification for SEV-SNP guests),
> +where additional certificate data corresponding to the endorsement key
> +used by firmware to sign an attestation report can be optionally provided
> +by userspace to pass along to the guest together with the
> +firmware-provided attestation report.
> +
> +KVM will supply in `gfn` the non-private guest page 

KVM cannot guarantee the page is non-private.  Even if KVM is 100% certain the
page is shared when the userspace exit is initiated, unless KVM holds several
locks across the exit to userspace, nothing prevents the page from being converted
back to private.

> that userspace should use to write the contents of certificate data. 

Please don't write documentation in the style of the APM, i.e. don't describe
KVM's behavior in terms of what userspace should or should not do.  Userspace
can do whatever it wants, including terminating the guest.  What matters is what
information KVM will provide, and how KVM will respond to various userspace
actions.

> The format of this
> +certificate data is defined in the GHCB 2.0 specification (see section
> +"SNP Extended Guest Request"). KVM will also supply in `npages` the
> +number of contiguous pages available for writing the certificate data
> +into.
> +
> +  - If the supplied number of pages is sufficient, userspace must write

As above, there is nothing userspace "must" do.      

Side topic, what sadist wrote the GHCB?  The "documentation" for MSG_REPORT_REQ
is garbage like this:

  If there are not enough guest pages to hold the certificate table and
  certificate data, the hypervisor will return the required number of pages
  needed to hold the certificate table and certificate data in the RBX register
  and set the SW_EXITINFO2 field to 0x0000000100000000

It's very frustrating that proper documentation of WTF 0x0000000100000000 means,
and where the seemingly magic values comes from, is left to software.

> +    the certificate table blob (in the format defined by the GHCB spec)
> +    into the address corresponding to `gfn` and set `ret` to 0 to indicate
> +    success. If no certificate data is available, then userspace can
> +    write an empty certificate table into the address corresponding to
> +    `gfn`.
> +
> +  - If the number of pages supplied is not sufficient, userspace must set
> +    the required number of pages in `npages` and then set `ret` to
> +    ``ENOSPC``.
> +
> +  - If the certificate cannot be immediately provided, userspace should set
> +    `ret` to ``EAGAIN``, which will inform the guest to retry the request
> +    later. One scenario where this would be useful is if the certificate
> +    is in the process of being updated and cannot be fetched until the
> +    update completes (see the NOTE below regarding how file-locking can
> +    be used to orchestrate such updates between management/guests).
> +
> +  - To indicate to the guest that a general error occurred while fetching
> +    the certificate, userspace should set `ret` to ``EIO``.

And definitely don't mix "should" and "must".

My preference would be to first document what KVM will do/provide (which you've
done), and then document how KVM will complete the #VMGEXIT.  Leave all other
details to other documentation (more below on that).  E.g. (definitely audit
this for correctness):

----
::

    /* KVM_EXIT_SNP_REQ_CERTS */                                    
    struct kvm_exit_snp_req_certs {                                 
      __u64 gpa;                                              
      __u64 npages;                                           
      __u64 ret;                                              
    };          

KVM_EXIT_SNP_REQ_CERTS indicates an SEV-SNP guest with certificate requests
enabled (see KVM_SEV_SNP_ENABLE_REQ_CERTS) has generated an Extended Guest
Request NAE #VMGEXIT (SNP_GUEST_REQUEST) with message type MSG_REPORT_REQ,
i.e. has requested a certificate report from the hypervisor.

The 'gpa' and 'npages' are forwarded verbatim from the guest request (the RAX
and RBX GHCB fields respectively).  'ret' is not an "output" from KVM, and is
always '0' on exit.  KVM verifies the 'gpa' is 4KiB aligned prior to exiting to
userspace, but otherwise the information from the guest isn't validated.

Upon the next KVM_RUN, e.g. after userspace has serviced the request (or not),
KVM will complete the #VMGEXIT, using the 'ret' field to determine whether to
signal success or failure to the guest, and on failure, what reason code will
be communicated via SW_EXITINFO2.  If 'ret' is set to an unsupported value (see
the table below), KVM_RUN will fail with -EINVAL.  For a 'ret' of 'ENOSPC', KVM
also consumes the 'npages' field, i.e. userspace can use the field to inform
the guest of the number of pages needed to hold all certificates.

The supported 'ret' values and their respective SW_EXITINFO2 encodings:

  ======     =============================================================
  0          0x0, i.e. success.  KVM will emit an SNP_GUEST_REQUEST command
             to SNP firmware.
  ENOSPC     0x0000000100000000, i.e. not enough guest pages to hold the
             certificate table and certificate data.  KVM will also set the
             RBX field in the GHBC to 'npages'.
  EAGAIN     0x0000000200000000, i.e. the host is busy and the guest should
             retry the request.
  EIO        0xffffffff00000000, for all other errors (this return code is
             a KVM-defined hypervisor value, as allowed by the GHCB)
  ======     =============================================================
----

> +
> +  - All other possible values for `ret` are reserved for future use.
> +
> +NOTE: The endorsement key used by firmware may change as a result of
> +management activities like updating SEV-SNP firmware or loading new
> +endorsement keys, so some care should be taken to keep the returned
> +certificate data in sync with the actual endorsement key in use by
> +firmware at the time the attestation request is sent to SNP firmware. The
> +recommended scheme to do this is to use file locking (e.g. via fcntl()'s
> +F_OFD_SETLK) in the following manner:
> +
> +  - The VMM should obtain a shared/read or exclusive/write lock on the
> +  certificate blob file before reading it and returning it to KVM, and
> +  continue to hold the lock until the attestation request is actually
> +  sent to firmware. To facilitate this, the VMM can set the
> +  ``immediate_exit`` flag of kvm_run just after supplying the
> +  certificate data, and just before and resuming the vCPU. This will
> +  ensure the vCPU will exit again to userspace with ``-EINTR`` after
> +  it finishes fetching the attestation request from firmware, at which
> +  point the VMM can safely drop the file lock.
> +
> +  - Tools/libraries that perform updates to SNP firmware TCB values or
> +    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
> +    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
> +    Documentation/virt/coco/sev-guest.rst for more details) in such a way
> +    that the certificate blob needs to be updated, should similarly take an
> +    exclusive lock on the certificate blob for the duration of any updates
> +    to endorsement keys or the certificate blob contents to ensure that
> +    VMMs using the above scheme will not return certificate blob data that
> +    is out of sync with the endorsement key used by firmware.
> +
> +This scheme is recommended so that tools can use a fairly generic/natural
> +approach to synchronizing firmware/certificate updates via file-locking,
> +which should make it easier to maintain interoperability across
> +tools/VMMs/vendors.

IMO, this is completely out of scope for KVM_EXIT_SNP_REQ_CERTS.  I would *love*
to see documentation for how userspace can implement attestation and certificate
management, but that belongs in Documentation/virt/kvm/x86/amd-memory-encryption.rst
as it obviously involves far more than just KVM_EXIT_SNP_REQ_CERTS.

>  .. _cap_enable:
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..b74e2be2cbaf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4042,6 +4042,36 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>  	return ret;
>  }
>  
> +static int snp_req_certs_err(struct vcpu_svm *svm, u32 vmm_error)
> +{
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_error, 0));
> +
> +	return 1; /* resume guest */
> +}
> +
> +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_control_area *control = &svm->vmcb->control;
> +
> +	switch (READ_ONCE(vcpu->run->snp_req_certs.ret)) {
> +	case 0:
> +		return snp_handle_guest_req(svm, control->exit_info_1,
> +					    control->exit_info_2);
> +	case ENOSPC:
> +		vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
> +		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_LEN);
> +	case EAGAIN:
> +		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
> +	case EIO:
> +		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
>  {
>  	struct kvm *kvm = svm->vcpu.kvm;
> @@ -4057,14 +4087,13 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  	/*
>  	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
>  	 * additional certificate data to be provided alongside the attestation
> -	 * report via the guest-provided data pages indicated by RAX/RBX. The
> -	 * certificate data is optional and requires additional KVM enablement
> -	 * to provide an interface for userspace to provide it, but KVM still
> -	 * needs to be able to handle extended guest requests either way. So
> -	 * provide a stub implementation that will always return an empty
> -	 * certificate table in the guest-provided data pages.
> +	 * report via the guest-provided data pages indicated by RAX/RBX. If
> +	 * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspace
> +	 * to fetch the certificate data. Otherwise, return an empty certificate

Maybe "to let userspace handle the request"?

> +	 * table in the guest-provided data pages.
>  	 */
>  	if (msg_type == SNP_MSG_REPORT_REQ) {
> +		struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  		struct kvm_vcpu *vcpu = &svm->vcpu;
>  		u64 data_npages;
>  		gpa_t data_gpa;
> @@ -4078,6 +4107,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  		if (!PAGE_ALIGNED(data_gpa))
>  			goto request_invalid;
>  
> +		if (sev->snp_certs_enabled) {
> +			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
> +			vcpu->run->snp_req_certs.gfn = gpa_to_gfn(data_gpa);

As above, I think it makes sense to just do ".gpa = data_gpa".

> +			vcpu->run->snp_req_certs.npages = data_npages;
> +			vcpu->run->snp_req_certs.ret = 0;
> +			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
> +			return 0; /* fetch certs from userspace */

Eh, I'd drop the comment.  KVM isn't "fetching" anything.

> diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
> index fcdfea767fca..38767aba4ff3 100644
> --- a/include/uapi/linux/sev-guest.h
> +++ b/include/uapi/linux/sev-guest.h
> @@ -95,5 +95,13 @@ struct snp_ext_report_req {
>  
>  #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
>  #define SNP_GUEST_VMM_ERR_BUSY		2
> +/*
> + * The GHCB spec essentially states that all non-zero error codes other than
> + * those explicitly defined above should be treated as an error by the guest.
> + * Define a generic error to cover that case, and choose a value that is not
> + * likely to overlap with new explicit error codes should more be added to
> + * the GHCB spec later.
> + */
> +#define SNP_GUEST_VMM_ERR_GENERIC       (~0U)

This probably should go in arch/x86/include/uapi/asm/kvm.h, because it's not a
GHCB-defined error code.  And we really, really don't want guests taking specific
action for this error code, because that risks introducing VMM specific logic into
guest code that is supposed to be VMM agnostic.

