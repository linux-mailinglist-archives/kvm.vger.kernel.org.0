Return-Path: <kvm+bounces-12022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB3487F1AA
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 625E71F2253C
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 21:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BADF58222;
	Mon, 18 Mar 2024 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5bhkmNd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8685156763
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795744; cv=none; b=qw/oUlQlmJUT8oUkprWDDIcZOHsMmRrA48lYfU8CRfJ3N33zY4KCyAxlgCoxZTzXZnw6A1pcT+oZXtmGN0Xd9sMzZmhJuYiBSxHRx8Jl/mYgdYkztSOF+V0uT0F5xu7NwIkd4ZMvbssBOVb6zEZFV3T5OXqfS7UG/GqLQaPbYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795744; c=relaxed/simple;
	bh=BXZLP7MOa5Xo2y9G1WmsmS2tlN82SwZ5joLRxkLlD8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=spD7I7K9TmUMEiRyjwpGztsJXrlAwopfITsOes39ctdqEzBiOr5vgI/ARAs3N+gBL3jpn76JZGn8ZVpMpwlHkA+f6G0yaZopPe07weTbb0VQ//5WQyuXR4cofl24MeCvNuo4rOPK32tJxfuR8EDNpqO3totAqwc4UQ4aY89YH2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D5bhkmNd; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5687ebddd8eso5341a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 14:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710795740; x=1711400540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5gZjTRSl4x8yAd+Qw3jrLTaZ/uMFzSSgIEwAnGQaeg=;
        b=D5bhkmNdzrMld7/pTzSImHD4D/4rVxvWz+VsbEKNq0nD+6Tzoejt7zQ0B7QHJy95aQ
         iH77w3QE+vsfUUl8ykojUzDQSdp1R8jlgaoA/hfhd7Uwsj23MbiRBlBRshIzpsVRAvbD
         AtINRlOAE8c3uCL/OHoY0dW5PCY5GVNJ05sll3vqtOQzPEqVN6VQxJrEdZpZACrt1Pj0
         Y6bWHSnKDxbJu3hNPN2nILmVoL274UtEt6T+FEyBC1HGMqmr1sTpKtYLjKbCMBRWCb20
         ECehfowdeCE0DdoxDFAlZimPrCPAAcKtQEi6j8iai5q1yWlcde8qUzFdgLWIZ6m/KCid
         zbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710795740; x=1711400540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O5gZjTRSl4x8yAd+Qw3jrLTaZ/uMFzSSgIEwAnGQaeg=;
        b=ChHPVsmNbXjdw1rP1DeimdHJI7PoUejGOrCKYokt6uUWtdFkmLLkTw5Ly5e3IuQB6x
         MMoB8N87oCbY8GZNV74QCBr6eVwvlHzset3aT1F65n0HFs0NOeczkhXGFP++reSdeGlk
         h8ZLbWQYopX6O0Uj29DCAgQN/1bp3fMry+QjwZIgx/Zmue4QcoLmtmq0szXQ48sxWjSt
         1DroIoKrLtx7xLpNcVzmk7nXGYqP7A0uhKEw5rnlLSs3pTrzjmVi7FGwcNYmoTz+8Aac
         KreEoWvv/MelrxDBYS6kk6EejRsIzK8NuO4RT60EjfsMRrr4JzN6EoA6r/eb6GyisQFt
         zD7g==
X-Gm-Message-State: AOJu0YwRtrBCjocweBhg76Ny2MUzILp0Vhs61cQnqf2hQ21AtCqTlVsa
	PY4UXDEECNhqUJ+JluPkoav7z6rgauIP8qL9X7j+ULMo1azp5uV5uybN6E1tgH7hrL8u7qr3DOb
	ks7qddPREQgwtROEi+YruadREMCjCzIwfOZjw
X-Google-Smtp-Source: AGHT+IFivxti4l4UI/CAm+HxOzS2U25vJiH0+czbF7e4DZfoW53/wo+Dx8ivStQaqHTTVwkli/GuvoWdN+oEvPRUZQE=
X-Received: by 2002:aa7:c3d0:0:b0:568:ce1e:94e5 with SMTP id
 l16-20020aa7c3d0000000b00568ce1e94e5mr17596edr.5.1710795739649; Mon, 18 Mar
 2024 14:02:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-19-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-19-michael.roth@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Mon, 18 Mar 2024 15:02:04 -0600
Message-ID: <CAMkAt6qtnfkhU_Ks6=U-Zg7r-k7CT2WzVPLq5xdLML9JHr5rhQ@mail.gmail.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, peterz@infradead.org, 
	srinivas.pandruvada@linux.intel.com, rientjes@google.com, 
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 10:27=E2=80=AFAM Michael Roth <michael.roth@amd.com=
> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into
> the guest's memory. The data is encrypted with the cryptographic context
> created with the KVM_SEV_SNP_LAUNCH_START.
>
> In addition to the inserting data, it can insert a two special pages
> into the guests memory: the secrets page and the CPUID page.
>
> While terminating the guest, reclaim the guest pages added in the RMP
> table. If the reclaim fails, then the page is no longer safe to be
> released back to the system and leak them.
>
> For more information see the SEV-SNP specification.
>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  28 +++
>  arch/x86/kvm/svm/sev.c                        | 181 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 228 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Docum=
entation/virt/kvm/x86/amd-memory-encryption.rst
> index b1beb2fe8766..d4325b26724c 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -485,6 +485,34 @@ Returns: 0 on success, -negative on error
>
>  See the SEV-SNP specification for further detail on the launch input.
>
> +20. KVM_SNP_LAUNCH_UPDATE
> +-------------------------
> +
> +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It als=
o
> +calculates a measurement of the memory contents. The measurement is a si=
gnature
> +of the memory contents that can be sent to the guest owner as an attesta=
tion
> +that the memory was encrypted correctly by the firmware.

Nit: The measurement is a rolling hash of all the launch updated pages
and their metadata. The attestation quote contains a signature of
information about the SNP VM including this measurement.

Also technically the attestation doesn't confirm to the guest owner
the memory was encrypted correctly, I don't think we can
cryptographically prove that. But the attestation does provide the
guest owner confirmation about the exact steps the ASP took in
creating the SNP VMs initial memory context. If the ASP firmware is
bug free and follows the spec, your 'memory was encrypted correctly by
the firmware' line is implied.

> +
> +Parameters (in): struct  kvm_snp_launch_update
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_update {
> +                __u64 start_gfn;        /* Guest page number to start fr=
om. */
> +                __u64 uaddr;            /* userspace address need to be =
encrypted */
> +                __u32 len;              /* length of memory region */
> +                __u8 imi_page;          /* 1 if memory is part of the IM=
I */
> +                __u8 page_type;         /* page type */
> +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> +        };
> +
> +See the SEV-SNP spec for further details on how to build the VMPL permis=
sion
> +mask and page type.
> +
>  References
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e2f4d4bc125c..d60209e6e68b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -245,6 +245,36 @@ static void sev_decommission(unsigned int handle)
>         sev_guest_decommission(&decommission, NULL);
>  }
>
> +static int snp_page_reclaim(u64 pfn)
> +{
> +       struct sev_data_snp_page_reclaim data =3D {0};
> +       int err, rc;
> +
> +       data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
> +       rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +       if (rc) {
> +               /*
> +                * If the reclaim failed, then page is no longer safe
> +                * to use.
> +                */
> +               snp_leak_pages(pfn, 1);
> +       }
> +
> +       return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> +{
> +       int rc;
> +
> +       rc =3D rmp_make_shared(pfn, level);
> +       if (rc && leak)
> +               snp_leak_pages(pfn,
> +                              page_level_size(level) >> PAGE_SHIFT);
> +
> +       return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>         struct sev_data_deactivate deactivate;
> @@ -1990,6 +2020,154 @@ static int snp_launch_start(struct kvm *kvm, stru=
ct kvm_sev_cmd *argp)
>         return rc;
>  }
>
> +static int snp_launch_update_gfn_handler(struct kvm *kvm,
> +                                        struct kvm_gfn_range *range,
> +                                        void *opaque)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct kvm_memory_slot *memslot =3D range->slot;
> +       struct sev_data_snp_launch_update data =3D {0};
> +       struct kvm_sev_snp_launch_update params;
> +       struct kvm_sev_cmd *argp =3D opaque;
> +       int *error =3D &argp->error;
> +       int i, n =3D 0, ret =3D 0;
> +       unsigned long npages;
> +       kvm_pfn_t *pfns;
> +       gfn_t gfn;
> +
> +       if (!kvm_slot_can_be_private(memslot)) {
> +               pr_err("SEV-SNP requires private memory support via guest=
_memfd.\n");
> +               return -EINVAL;
> +       }
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,=
 sizeof(params))) {
> +               pr_err("Failed to copy user parameters for SEV-SNP launch=
.\n");
> +               return -EFAULT;
> +       }
> +
> +       data.gctx_paddr =3D __psp_pa(sev->snp_context);
> +
> +       npages =3D range->end - range->start;
> +       pfns =3D kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL_ACCOUNT=
);
> +       if (!pfns)
> +               return -ENOMEM;
> +
> +       pr_debug("%s: GFN range 0x%llx-0x%llx, type %d\n", __func__,
> +                range->start, range->end, params.page_type);
> +
> +       for (gfn =3D range->start, i =3D 0; gfn < range->end; gfn++, i++)=
 {
> +               int order, level;
> +               bool assigned;
> +               void *kvaddr;
> +
> +               ret =3D __kvm_gmem_get_pfn(kvm, memslot, gfn, &pfns[i], &=
order, false);
> +               if (ret)
> +                       goto e_release;
> +
> +               n++;
> +               ret =3D snp_lookup_rmpentry((u64)pfns[i], &assigned, &lev=
el);
> +               if (ret || assigned) {
> +                       pr_err("Failed to ensure GFN 0x%llx is in initial=
 shared state, ret: %d, assigned: %d\n",
> +                              gfn, ret, assigned);
> +                       return -EFAULT;
> +               }
> +
> +               kvaddr =3D pfn_to_kaddr(pfns[i]);
> +               if (!virt_addr_valid(kvaddr)) {
> +                       pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (ui=
nt64_t)kvaddr, gfn);
> +                       ret =3D -EINVAL;
> +                       goto e_release;
> +               }
> +
> +               ret =3D kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZ=
E);
> +               if (ret) {
> +                       pr_err("Guest read failed, ret: 0x%x\n", ret);

Should these be pr_debugs()?  This could get noisy.

> +                       goto e_release;
> +               }
> +
> +               ret =3D rmp_make_private(pfns[i], gfn << PAGE_SHIFT, PG_L=
EVEL_4K,
> +                                      sev_get_asid(kvm), true);
> +               if (ret) {
> +                       ret =3D -EFAULT;
> +                       goto e_release;
> +               }
> +
> +               data.address =3D __sme_set(pfns[i] << PAGE_SHIFT);
> +               data.page_size =3D PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> +               data.page_type =3D params.page_type;
> +               data.vmpl3_perms =3D params.vmpl3_perms;
> +               data.vmpl2_perms =3D params.vmpl2_perms;
> +               data.vmpl1_perms =3D params.vmpl1_perms;
> +               ret =3D __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_=
UPDATE,
> +                                     &data, error);
> +               if (ret) {
> +                       pr_err("SEV-SNP launch update failed, ret: 0x%x, =
fw_error: 0x%x\n",
> +                              ret, *error);
> +                       snp_page_reclaim(pfns[i]);
> +
> +                       /*
> +                        * When invalid CPUID function entries are detect=
ed, the firmware
> +                        * corrects these entries for debugging purpose a=
nd leaves the
> +                        * page unencrypted so it can be provided users f=
or debugging
> +                        * and error-reporting.
> +                        *
> +                        * Copy the corrected CPUID page back to shared m=
emory so
> +                        * userpsace can retrieve this information.

Typo: userpsace

