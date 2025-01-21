Return-Path: <kvm+bounces-36133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CE0A1816F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 274B17A4A0F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF171F471A;
	Tue, 21 Jan 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGyEB1un"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F41F37B6
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474925; cv=none; b=emr497jNAUqeBQz1T8cTjEfblATzf5VOCo26Ex5Paw/IAjmdhIOLIQAQNERkWAQrkToT2oGuvcD8UC367lUOeDUfIrmrSQeAfi8gizblj9DEkiw70aQomzxKvdjzCAQr/Vk94pkEepNXcVCZN6lGgy6ksl5vjV3dEdrQvLP1Z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474925; c=relaxed/simple;
	bh=UVD0NhJ02K3zx4/Fq20kd5UEy3dYZ50mTKBkSrB9l5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ksOH9157qjgR8aK74YBA9iTfGxJa6dkSYvIOQ9Iv/AQCWSApc6Xt+kCmX8ua7q8VYPqVAjsihq/GMllp7ESQZJVRakrYSeX+qLskHrlIunUKxpI432r/3NY2MD+PrtXNrNodqCxSUO/l4Mbv4nXOHV56MX8LuFjb7ElvWYi5yBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGyEB1un; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaeecbb7309so1101719766b.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737474922; x=1738079722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKYsM/zHuT9lp18swEU+BCDQWm/p86AsP+temL/iA10=;
        b=vGyEB1unrehHTm3xbepn73gow3SZYwFqE60ukqgyg3JSD77e7ewn5s6nnWcx7WWGuK
         th6uLcKdhQ9Xhdpo6klRy367wiwRtDEiw4CTgOht/nqGqJ6y13mPb/jevbC9A96C01UK
         EfcYU37kJkSO2h2mdpM6lSztyvPMVolqHJff1MXX5I9YxnXgOqCUNE3GAw8W8C9p3PvE
         9hRsfyjWkvpgRws6qQ4cZqDWg1rCpce5oMyYbvFPHGbiVxjL7cR4norpTcqRDi698ysa
         Fno/vHcs57c8HOehrjlhtI3ba3n0tCo/8BIHIE/efWZNM5JxYWaSct5AKde11fH1spYi
         gQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737474922; x=1738079722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKYsM/zHuT9lp18swEU+BCDQWm/p86AsP+temL/iA10=;
        b=FmQm9l1fRSAY3ftTYKWNy5eOHlu8mkSRkd6kWToqMLfmcR4qOb8s0mlCkpNl4IwVo9
         U3qQRsErfXAb0KGidA38pOAPcO1ztHv2UnunRDElMSu1fpNqTJLK5wfqOULHSFRF9POs
         ovHNUgjpG6TzqRYSwlhpi0jHta3f9h8+BfFojsMMATnP6q8wYPwd4slhItjkoU2rJvTl
         /Uzcs/Y/UPK0cId8BtT5SOUobFPLVdnQCOvmmvNkCeiVYeKP5Nk8TnvAXJbFEAOhtiiB
         b+wVzvmIN/lR6t1wBdwMXw33wYu1ITMLyKGqh3HkLAEP3TdMXmDXsVwWRk519JwrLALP
         Ostw==
X-Gm-Message-State: AOJu0YwJaiGqh0l3zPl/PCnPqX4ThAHb3cE5eJTI+XV9UInx09gGvD1f
	c+mH3+dQUqdtQBgfG5fb0X3jN2vyeoIxY1PmYoqINRdOwGupDied8wfONcYwzjoEi2M/WiK7PLD
	VGphUIBOqUXEKtjFyK2TRxHdgD5OOwbBoWm4W
X-Gm-Gg: ASbGncsAYWq41T0Q/rK11UprDpIP6J21hW6EK8R7Sa3N1h2rwlkglrQ2wXMiRuHlaDS
	lSJG97Y3aUL8fxZ+b4tBKRKPx5c9kgRI3kaAz6fZWCFjOi0q0IC0=
X-Google-Smtp-Source: AGHT+IF/KudRmy9XWRGc/O4hupDisRMLFDk/aX6uFpRUFR3oe4bJ1fVi/Av+i3fltDXPSXSq7gd6atfiVbXdyV7xjqc=
X-Received: by 2002:a17:907:7f0b:b0:ab2:b77e:f421 with SMTP id
 a640c23a62f3a-ab38b25e296mr1497169066b.23.1737474921325; Tue, 21 Jan 2025
 07:55:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250120215818.522175-1-huibo.wang@amd.com> <20250120215818.522175-2-huibo.wang@amd.com>
In-Reply-To: <20250120215818.522175-2-huibo.wang@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 21 Jan 2025 07:55:09 -0800
X-Gm-Features: AbW1kvYXh1FY-XHZNWehxRDisei0XUsnIDSKTKWC3EPJRPyFhjQsAUTNDR_MKWM
Message-ID: <CAAH4kHZL-9R+MLLvArcwQ2Zpk+gtqYTvVMR01WA1kVJ9goq_sw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
To: Melody Wang <huibo.wang@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, roedel@suse.de, Tom Lendacky <thomas.lendacky@amd.com>, 
	ashish.kalra@amd.com, liam.merwick@oracle.com, pankaj.gupta@amd.com, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 1:58=E2=80=AFPM Melody Wang <huibo.wang@amd.com> wr=
ote:
>
> From: Michael Roth <michael.roth@amd.com>
>
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
> Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
> the exit for cases where userspace does not support
> certificate-fetching, in which case KVM will fall back to returning an
> empty certificate table if the guest provides a buffer for it.
>
>   [Melody: Update the documentation scheme about how file locking is
>   expected to happen.]
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Melody Wang <huibo.wang@amd.com>

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

> ---
>  Documentation/virt/kvm/api.rst  | 106 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/svm/sev.c          |  43 +++++++++++--
>  arch/x86/kvm/x86.c              |  11 ++++
>  include/uapi/linux/kvm.h        |  10 +++
>  include/uapi/linux/sev-guest.h  |   8 +++
>  6 files changed, 173 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index f15b61317aad..f00db1e4c6cc 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7176,6 +7176,95 @@ Please note that the kernel is allowed to use the =
kvm_run structure as the
>  primary storage for certain register types. Therefore, the kernel may us=
e the
>  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not=
 set.
>
> +::
> +
> +               /* KVM_EXIT_SNP_REQ_CERTS */
> +               struct kvm_exit_snp_req_certs {
> +                       __u64 gfn;
> +                       __u32 npages;
> +                       __u32 ret;
> +               };
> +
> +This event provides a way to request certificate data from userspace and
> +have it written into guest memory. This is intended to handle attestatio=
n
> +requests made by SEV-SNP guests (using the Extended Guest Requests GHCB
> +command as defined by the GHCB 2.0 specification for SEV-SNP guests),
> +where additional certificate data corresponding to the endorsement key
> +used by firmware to sign an attestation report can be optionally provide=
d
> +by userspace to pass along to the guest together with the
> +firmware-provided attestation report.
> +
> +KVM will supply in `gfn` the non-private guest page that userspace shoul=
d
> +use to write the contents of certificate data. The format of this
> +certificate data is defined in the GHCB 2.0 specification (see section
> +"SNP Extended Guest Request"). KVM will also supply in `npages` the
> +number of contiguous pages available for writing the certificate data
> +into.
> +
> +  - If the supplied number of pages is sufficient, userspace must write
> +    the certificate table blob (in the format defined by the GHCB spec)
> +    into the address corresponding to `gfn` and set `ret` to 0 to indica=
te
> +    success. If no certificate data is available, then userspace can
> +    either write an empty certificate table into the address correspondi=
ng
> +    to `gfn`, or it can disable ``KVM_EXIT_SNP_REQ_CERTS`` (via
> +    ``KVM_CAP_EXIT_SNP_REQ_CERTS``), in which case KVM will handle
> +    returning an empty certificate table to the guest.
> +
> +  - If the number of pages supplied is not sufficient, userspace must se=
t
> +    the required number of pages in `npages` and then set `ret` to
> +    ``ENOSPC``.
> +
> +  - If the certificate cannot be immediately provided, userspace should =
set
> +    `ret` to ``EAGAIN``, which will inform the guest to retry the reques=
t
> +    later. One scenario where this would be useful is if the certificate
> +    is in the process of being updated and cannot be fetched until the
> +    update completes (see the NOTE below regarding how file-locking can
> +    be used to orchestrate such updates between management/guests).
> +
> +  - If some other error occurred, userspace must set `ret` to ``EIO``.
> +    (This is to reserve special meaning for unused error codes in the
> +    future.)
> +
> +NOTE: The endorsement key used by firmware may change as a result of
> +management activities like updating SEV-SNP firmware or loading new
> +endorsement keys, so some care should be taken to keep the returned
> +certificate data in sync with the actual endorsement key in use by
> +firmware at the time the attestation request is sent to SNP firmware. Th=
e
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
> +    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT`=
`,
> +    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
> +    Documentation/virt/coco/sev-guest.rst for more details) in such a wa=
y
> +    that the certificate blob needs to be updated, should similarly take=
 an
> +    exclusive lock on the certificate blob for the duration of any updat=
es
> +    to endorsement keys or the certificate blob contents to ensure that
> +    VMMs using the above scheme will not return certificate blob data th=
at
> +    is out of sync with the endorsement key used by firmware.
> +
> +This scheme is recommended so that tools could naturally opt to use
> +it rather than every service provider coming up with a different solutio=
n
> +that they will need to work into some custom QEMU/VMM to solve the same
> +problem.
> +
> +However, userspace is free to implement their own completely separate
> +mechanism for handing all this and completely ignore file locking. QEMU =
is
> +only trying to play nice with this above-mentioned reference implementat=
ion
> +and cooperative management tools, and not trying to profess to provide a=
ny
> +sort of synchronization for cases where those sorts of management-level
> +updates are performed without utilizing this reference implementation fo=
r
> +synchronization.
>
>  .. _cap_enable:
>
> @@ -9020,6 +9109,23 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs,=
 and especially not in
>  production.  The behavior and effective ABI for software-protected VMs i=
s
>  unstable.
>
> +8.42 KVM_CAP_EXIT_SNP_REQ_CERTS
> +-------------------------------
> +
> +:Capability: KVM_CAP_EXIT_SNP_REQ_CERTS
> +:Architectures: x86
> +:Type: vm
> +
> +This capability, if enabled, will cause KVM to exit to userspace with
> +KVM_EXIT_SNP_REQ_CERTS exit reason to allow for fetching SNP attestation
> +certificates from userspace.
> +
> +Calling KVM_CHECK_EXTENSION for this capability will return a non-zero
> +value to indicate KVM support for KVM_EXIT_SNP_REQ_CERTS.
> +
> +The 1st argument to KVM_ENABLE_CAP should be 1 to indicate userspace sup=
port
> +for handling this event.
> +
>  9. Known KVM API problems
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index e159e44a6a1b..dae1a572d770 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1438,6 +1438,7 @@ struct kvm_arch {
>         struct kvm_x86_msr_filter __rcu *msr_filter;
>
>         u32 hypercall_exit_enabled;
> +       bool snp_certs_enabled;
>
>         /* Guest can access the SGX PROVISIONKEY. */
>         bool sgx_provisioning_allowed;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..4896c34ed318 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_svm *s=
vm, gpa_t req_gpa, gpa_t resp_
>         return ret;
>  }
>
> +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +       struct vmcb_control_area *control =3D &svm->vmcb->control;
> +
> +       if (vcpu->run->snp_req_certs.ret) {
> +               if (vcpu->run->snp_req_certs.ret =3D=3D ENOSPC) {
> +                       vcpu->arch.regs[VCPU_REGS_RBX] =3D vcpu->run->snp=
_req_certs.npages;
> +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +                                               SNP_GUEST_ERR(SNP_GUEST_V=
MM_ERR_INVALID_LEN, 0));
> +               } else if (vcpu->run->snp_req_certs.ret =3D=3D EAGAIN) {
> +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +                                               SNP_GUEST_ERR(SNP_GUEST_V=
MM_ERR_BUSY, 0));

Discussion, not a change request: given that my proposed patch [1] to
add rate-limiting for guest messages to the PSP generally was
rejected, do we think it'd be proper to add a KVM_EXIT_SNP_REQ_MSG or
some such for the VMM to decide if the guest should have access to the
globally shared resource (PSP) via EAGAIN or 0?

[1] https://patchwork.kernel.org/project/kvm/cover/20230119213426.379312-1-=
dionnaglaze@google.com/

> +               } else {
> +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +                                               SNP_GUEST_ERR(SNP_GUEST_V=
MM_ERR_GENERIC, 0));
> +               }
> +
> +               return 1; /* resume guest */
> +       }
> +
> +       return snp_handle_guest_req(svm, control->exit_info_1, control->e=
xit_info_2);
> +}
> +
>  static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa,=
 gpa_t resp_gpa)
>  {
>         struct kvm *kvm =3D svm->vcpu.kvm;
> @@ -4079,12 +4103,10 @@ static int snp_handle_ext_guest_req(struct vcpu_s=
vm *svm, gpa_t req_gpa, gpa_t r
>         /*
>          * As per GHCB spec, requests of type MSG_REPORT_REQ also allow f=
or
>          * additional certificate data to be provided alongside the attes=
tation
> -        * report via the guest-provided data pages indicated by RAX/RBX.=
 The
> -        * certificate data is optional and requires additional KVM enabl=
ement
> -        * to provide an interface for userspace to provide it, but KVM s=
till
> -        * needs to be able to handle extended guest requests either way.=
 So
> -        * provide a stub implementation that will always return an empty
> -        * certificate table in the guest-provided data pages.
> +        * report via the guest-provided data pages indicated by RAX/RBX.=
 If
> +        * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspa=
ce
> +        * to fetch the certificate data. Otherwise, return an empty cert=
ificate
> +        * table in the guest-provided data pages.
>          */
>         if (msg_type =3D=3D SNP_MSG_REPORT_REQ) {
>                 struct kvm_vcpu *vcpu =3D &svm->vcpu;
> @@ -4100,6 +4122,15 @@ static int snp_handle_ext_guest_req(struct vcpu_sv=
m *svm, gpa_t req_gpa, gpa_t r
>                 if (!PAGE_ALIGNED(data_gpa))
>                         goto request_invalid;
>
> +               if (vcpu->kvm->arch.snp_certs_enabled) {
> +                       vcpu->run->exit_reason =3D KVM_EXIT_SNP_REQ_CERTS=
;
> +                       vcpu->run->snp_req_certs.gfn =3D gpa_to_gfn(data_=
gpa);
> +                       vcpu->run->snp_req_certs.npages =3D data_npages;
> +                       vcpu->run->snp_req_certs.ret =3D 0;
> +                       vcpu->arch.complete_userspace_io =3D snp_complete=
_req_certs;
> +                       return 0; /* fetch certs from userspace */
> +               }
> +
>                 /*
>                  * As per GHCB spec (see "SNP Extended Guest Request"), t=
he
>                  * certificate table is terminated by 24-bytes of zeroes.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c79a8cc57ba4..cdcdc5359a87 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4782,6 +4782,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>         case KVM_CAP_READONLY_MEM:
>                 r =3D kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
>                 break;
> +       case KVM_CAP_EXIT_SNP_REQ_CERTS:
> +               r =3D 1;
> +               break;
>         default:
>                 break;
>         }
> @@ -6743,6 +6746,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 mutex_unlock(&kvm->lock);
>                 break;
>         }
> +       case KVM_CAP_EXIT_SNP_REQ_CERTS:
> +               if (cap->args[0] !=3D 1) {
> +                       r =3D -EINVAL;
> +                       break;
> +               }
> +               kvm->arch.snp_certs_enabled =3D true;
> +               r =3D 0;
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 502ea63b5d2e..dcaadd6f5b18 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -135,6 +135,12 @@ struct kvm_xen_exit {
>         } u;
>  };
>
> +struct kvm_exit_snp_req_certs {
> +       __u64 gfn;
> +       __u32 npages;
> +       __u32 ret;
> +};
> +
>  #define KVM_S390_GET_SKEYS_NONE   1
>  #define KVM_S390_SKEYS_MAX        1048576
>
> @@ -178,6 +184,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_NOTIFY           37
>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>  #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_SNP_REQ_CERTS    40
>
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -446,6 +453,8 @@ struct kvm_run {
>                         __u64 gpa;
>                         __u64 size;
>                 } memory_fault;
> +               /* KVM_EXIT_SNP_REQ_CERTS */
> +               struct kvm_exit_snp_req_certs snp_req_certs;
>                 /* Fix the size of the union. */
>                 char padding[256];
>         };
> @@ -933,6 +942,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_PRE_FAULT_MEMORY 236
>  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>  #define KVM_CAP_X86_GUEST_MODE 238
> +#define KVM_CAP_EXIT_SNP_REQ_CERTS 239
>
>  struct kvm_irq_routing_irqchip {
>         __u32 irqchip;
> diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-gues=
t.h
> index fcdfea767fca..4c4ed8bc71d7 100644
> --- a/include/uapi/linux/sev-guest.h
> +++ b/include/uapi/linux/sev-guest.h
> @@ -95,5 +95,13 @@ struct snp_ext_report_req {
>
>  #define SNP_GUEST_VMM_ERR_INVALID_LEN  1
>  #define SNP_GUEST_VMM_ERR_BUSY         2
> +/*
> + * The GHCB spec essentially states that all non-zero error codes other =
than
> + * those explicitly defined above should be treated as an error by the g=
uest.
> + * Define a generic error to cover that case, and choose a value that is=
 not
> + * likely to overlap with new explicit error codes should more be added =
to
> + * the GHCB spec later.
> + */
> +#define SNP_GUEST_VMM_ERR_GENERIC       ((u32)~0U)
>
>  #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

