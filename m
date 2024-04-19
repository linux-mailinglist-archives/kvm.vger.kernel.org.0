Return-Path: <kvm+bounces-15259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF5028AADF5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A62562812D2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE0E84D35;
	Fri, 19 Apr 2024 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JeRFyecb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198B83A09
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713527811; cv=none; b=JHjvDvD6KekRSUPCk8EtvkEDG1wZmF/14VTsggfaOkOME+j8SF6pxIWApfOD8WcPOI9t9gJwAzcDLjqjUnPq1QFGi29arYKNMoKgC9kswF1XHf8mAgB6pOJfYwbkXm70bgiFFopVbGuzl658sz5ok9g6VUpN2wwvQb/kwTBpGeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713527811; c=relaxed/simple;
	bh=fAeObcPdGu8ccYSV8NfFX7vLAWSR1HG5/Hr6N2MU3t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P99Tbs5IlpNVo+crjMkX3EofAkVTiWnKOG79ERcI9VoZHkjJXLoRdzs8GkrQB+gXsec7QT5EkS17Zaeq63Q98BvwGWazJ0S7UMfmugNIkrksvedfGybKROEBEbR7kFoy7loDCVcNlLjmZyOzzu2A/M1bRyBlU4u39mms5AntorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JeRFyecb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713527807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gS+4gv4gKzPY/dfApbn5VMRkZNxT9uevz2D9Iss8dzg=;
	b=JeRFyecbOvw4cXHFQH6TOETfDsz7+SwFFqTr1k8P90uwBIfPT/avY44cLwJ8xqnXyvv1lI
	z62mnnZkiNxxvPFEUHy0Pjve6kfIgHzhenepH9J9EdizQnY+kBx5eclvmtCAVSbiAAtD8a
	IOeMLM033T9Uw77Ck5Njpr2jjscyigo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-xJxW-yFJOrq_WuTHhWkhGA-1; Fri, 19 Apr 2024 07:56:45 -0400
X-MC-Unique: xJxW-yFJOrq_WuTHhWkhGA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34a49f5a6baso590014f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 04:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713527805; x=1714132605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gS+4gv4gKzPY/dfApbn5VMRkZNxT9uevz2D9Iss8dzg=;
        b=uTyAoxIsPUMk/9wLqBJlcN54d02ClZg4daskroGeHeHm4nCoELCHd9tCB4Uq71bQKX
         em64WOaZoqOGtVyRyxnNVIRGAJtW0k6h4UKaSBdVesXNbYTgeDOpoPbYmBP41yXvmF1d
         9zbzq51uqdhOHKyueEkfzN7YTAaF1+RMM/V8zIH1zJuziR8Cb2Ne8sK3cpUqBEShCybI
         PdOoZb3xyf4jxukRqe3ehua5wJWT6UyCzOEf6XC75tuoO2GVAJY/k/XVycT7YdfoKD0L
         f0ylpvZx1n77Yx5L86xM0wR0AnNQdnArwN/n5skoBuZ2hyM5e/ciM8rT5ejeWvlfXl2k
         IKSQ==
X-Gm-Message-State: AOJu0YzaAcmmTSJbpQW6kdHywczm3tatiU5bamP7rKWczWsWhUOpdOCh
	w0hbWp/VbGEpzHZvDOYvnpiv4eEgf7cNI6AQKt8HifAAIVgd18JuqCFv+3CiCyZacP0y5kcRNq9
	dUpt4/FdXgWKBC8PaPHDQ2WHV7Rqkrt4O/1rCFF2P7vXVyZX6BBwWV387P/vNPK127aWTEr7zkX
	lkJo69KRSYCk/CxJZ0CLQGTM4O
X-Received: by 2002:a5d:69c1:0:b0:34a:2026:d773 with SMTP id s1-20020a5d69c1000000b0034a2026d773mr1378090wrw.71.1713527804567;
        Fri, 19 Apr 2024 04:56:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZqO9WwejxEEIelWYSOI9TQADRHyveikGDaBSmecXk0Nh0mlGSOGo2j11aEtmIEH24aSz+oqpUXqYpAq3x9Cw=
X-Received: by 2002:a5d:69c1:0:b0:34a:2026:d773 with SMTP id
 s1-20020a5d69c1000000b0034a2026d773mr1378043wrw.71.1713527804105; Fri, 19 Apr
 2024 04:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com> <20240418194133.1452059-11-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-11-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 13:56:33 +0200
Message-ID: <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
Subject: Re: [PATCH v13 10/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 9:42=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> A key aspect of a launching an SNP guest is initializing it with a
> known/measured payload which is then encrypted into guest memory as
> pre-validated private pages and then measured into the cryptographic
> launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
> can attest itself after booting.
>
> Since all private pages are provided by guest_memfd, make use of the
> kvm_gmem_populate() interface to handle this. The general flow is that
> guest_memfd will handle allocating the pages associated with the GPA
> ranges being initialized by each particular call of
> KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
> and then the post_populate callback will do the work of setting the
> RMP entries for these pages to private and issuing the SNP firmware
> calls to encrypt/measure them.
>
> For more information see the SEV-SNP specification.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
>  arch/x86/include/uapi/asm/kvm.h               |  15 ++
>  arch/x86/kvm/svm/sev.c                        | 218 ++++++++++++++++++
>  3 files changed, 272 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Docum=
entation/virt/kvm/x86/amd-memory-encryption.rst
> index 1b042f827eab..1ee8401de72d 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
>
>  See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch inpu=
t.
>
> +19. KVM_SEV_SNP_LAUNCH_UPDATE
> +-----------------------------
> +
> +The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-prov=
ided
> +data into a guest GPA range, measuring the contents into the SNP guest c=
ontext
> +created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that=
 GPA
> +range so that it will be immediately readable using the encryption key
> +associated with the guest context once it is booted, after which point i=
t can
> +attest the measurement associated with its context before unlocking any
> +secrets.
> +
> +It is required that the GPA ranges initialized by this command have had =
the
> +KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documenta=
tion
> +for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
> +
> +Parameters (in): struct  kvm_sev_snp_launch_update
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_update {
> +                __u64 gfn_start;        /* Guest page number to load/enc=
rypt data into. */
> +                __u64 uaddr;            /* Userspace address of data to =
be loaded/encrypted. */
> +                __u32 len;              /* 4k-aligned length in bytes to=
 copy into guest memory.*/
> +                __u8 type;              /* The type of the guest pages b=
eing initialized. */
> +        };
> +
> +where the allowed values for page_type are #define'd as::
> +
> +       KVM_SEV_SNP_PAGE_TYPE_NORMAL
> +       KVM_SEV_SNP_PAGE_TYPE_ZERO
> +       KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
> +       KVM_SEV_SNP_PAGE_TYPE_SECRETS
> +       KVM_SEV_SNP_PAGE_TYPE_CPUID
> +
> +See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page =
type is
> +used/measured.
> +
>  Device attribute API
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/=
kvm.h
> index bdf8c5461a36..8612aec97f55 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -699,6 +699,7 @@ enum sev_cmd_id {
>
>         /* SNP-specific commands */
>         KVM_SEV_SNP_LAUNCH_START =3D 100,
> +       KVM_SEV_SNP_LAUNCH_UPDATE,
>
>         KVM_SEV_NR_MAX,
>  };
> @@ -830,6 +831,20 @@ struct kvm_sev_snp_launch_start {
>         __u8 gosvw[16];
>  };
>
> +/* Kept in sync with firmware values for simplicity. */
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL           0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO             0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED       0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS          0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID            0x6
> +
> +struct kvm_sev_snp_launch_update {
> +       __u64 gfn_start;
> +       __u64 uaddr;
> +       __u32 len;
> +       __u8 type;
> +};
> +
>  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
>  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4c5abc0e7806..e721152bae00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -262,6 +262,35 @@ static void sev_decommission(unsigned int handle)
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
> +       if (WARN_ON_ONCE(rc)) {
> +               /*
> +                * This shouldn't happen under normal circumstances, but =
if the
> +                * reclaim failed, then the page is no longer safe to use=
.
> +                */
> +               snp_leak_pages(pfn, 1);
> +       }
> +
> +       return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level)
> +{
> +       int rc;
> +
> +       rc =3D rmp_make_shared(pfn, level);
> +       if (rc)
> +               snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT)=
;
> +
> +       return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>         struct sev_data_deactivate deactivate;
> @@ -2131,6 +2160,192 @@ static int snp_launch_start(struct kvm *kvm, stru=
ct kvm_sev_cmd *argp)
>         return rc;
>  }
>
> +struct sev_gmem_populate_args {
> +       __u8 type;
> +       int sev_fd;
> +       int fw_error;
> +};
> +
> +static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_=
pfn_t pfn,
> +                                 void __user *src, int order, void *opaq=
ue)
> +{
> +       struct sev_gmem_populate_args *sev_populate_args =3D opaque;
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       int n_private =3D 0, ret, i;
> +       int npages =3D (1 << order);
> +       gfn_t gfn;
> +
> +       pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
> +                __func__, gfn_start, pfn, npages);
> +
> +       for (gfn =3D gfn_start, i =3D 0; gfn < gfn_start + npages; gfn++,=
 i++) {
> +               struct sev_data_snp_launch_update fw_args =3D {0};
> +               bool assigned;
> +               void *vaddr;
> +               int level;
> +
> +               if (!kvm_mem_is_private(kvm, gfn)) {
> +                       pr_debug("%s: Failed to ensure GFN 0x%llx has pri=
vate memory attribute set\n",
> +                                __func__, gfn);
> +                       ret =3D -EINVAL;
> +                       break;
> +               }
> +
> +               ret =3D snp_lookup_rmpentry((u64)pfn + i, &assigned, &lev=
el);
> +               if (ret || assigned) {
> +                       pr_debug("%s: Failed to ensure GFN 0x%llx RMP ent=
ry is initial shared state, ret: %d assigned: %d\n",
> +                                __func__, gfn, ret, assigned);
> +                       ret =3D -EINVAL;
> +                       break;
> +               }
> +
> +               vaddr =3D kmap_local_pfn(pfn + i);
> +               ret =3D copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_S=
IZE);
> +               if (ret) {
> +                       pr_debug("Failed to copy source page into GFN 0x%=
llx\n", gfn);
> +                       goto out_unmap;
> +               }
> +
> +               ret =3D rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_L=
EVEL_4K,
> +                                      sev_get_asid(kvm), true);
> +               if (ret) {
> +                       pr_debug("%s: Failed to convert GFN 0x%llx to pri=
vate, ret: %d\n",
> +                                __func__, gfn, ret);
> +                       goto out_unmap;
> +               }
> +
> +               n_private++;
> +
> +               fw_args.gctx_paddr =3D __psp_pa(sev->snp_context);
> +               fw_args.address =3D __sme_set(pfn_to_hpa(pfn + i));
> +               fw_args.page_size =3D PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> +               fw_args.page_type =3D sev_populate_args->type;
> +               ret =3D __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CM=
D_SNP_LAUNCH_UPDATE,
> +                                     &fw_args, &sev_populate_args->fw_er=
ror);
> +               if (ret) {
> +                       pr_debug("%s: SEV-SNP launch update failed, ret: =
0x%x, fw_error: 0x%x\n",
> +                                __func__, ret, sev_populate_args->fw_err=
or);
> +
> +                       if (snp_page_reclaim(pfn + i))
> +                               goto out_unmap;
> +
> +                       /*
> +                        * When invalid CPUID function entries are detect=
ed,
> +                        * firmware writes the expected values into the p=
age and
> +                        * leaves it unencrypted so it can be used for de=
bugging
> +                        * and error-reporting.
> +                        *
> +                        * Copy this page back into the source buffer so
> +                        * userspace can use this information to provide
> +                        * information on which CPUID leaves/fields faile=
d CPUID
> +                        * validation.
> +                        */
> +                       if (sev_populate_args->type =3D=3D KVM_SEV_SNP_PA=
GE_TYPE_CPUID &&
> +                           sev_populate_args->fw_error =3D=3D SEV_RET_IN=
VALID_PARAM) {
> +                               host_rmp_make_shared(pfn + i, PG_LEVEL_4K=
);
> +
> +                               if (copy_to_user(src + i * PAGE_SIZE,
> +                                                vaddr, PAGE_SIZE))
> +                                       pr_debug("Failed to write CPUID p=
age back to userspace\n");
> +                       }
> +               }
> +
> +out_unmap:
> +               kunmap_local(vaddr);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (ret) {
> +               pr_debug("%s: exiting with error ret %d, undoing %d popul=
ated gmem pages.\n",
> +                        __func__, ret, n_private);
> +               for (i =3D 0; i < n_private; i++)
> +                       host_rmp_make_shared(pfn + i, PG_LEVEL_4K);
> +       }
> +
> +       return ret;
> +}
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +       struct sev_gmem_populate_args sev_populate_args =3D {0};
> +       struct kvm_sev_snp_launch_update params;
> +       struct kvm_memory_slot *memslot;
> +       unsigned int npages;
> +       int ret =3D 0;
> +
> +       if (!sev_snp_guest(kvm) || !sev->snp_context)
> +               return -EINVAL;
> +
> +       if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(p=
arams)))
> +               return -EFAULT;
> +
> +       if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
> +           (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
> +            params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO &&
> +            params.type !=3D KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
> +            params.type !=3D KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
> +            params.type !=3D KVM_SEV_SNP_PAGE_TYPE_CPUID))
> +               return -EINVAL;
> +
> +       npages =3D params.len / PAGE_SIZE;
> +
> +       pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
> +                params.gfn_start, params.gfn_start + npages, params.type=
);
> +
> +       /*
> +        * For each GFN that's being prepared as part of the initial gues=
t
> +        * state, the following pre-conditions are verified:
> +        *
> +        *   1) The backing memslot is a valid private memslot.
> +        *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIB=
UTES
> +        *      beforehand.
> +        *   3) The PFN of the guest_memfd has not already been set to pr=
ivate
> +        *      in the RMP table.
> +        *
> +        * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested =
page
> +        * faults if there's a race between a fault and an attribute upda=
te via
> +        * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be uti=
lized
> +        * here. However, kvm->slots_lock guards against both this as wel=
l as
> +        * concurrent memslot updates occurring while these checks are be=
ing
> +        * performed, so use that here to make it easier to reason about =
the
> +        * initial expected state and better guard against unexpected
> +        * situations.
> +        */
> +       mutex_lock(&kvm->slots_lock);
> +
> +       memslot =3D gfn_to_memslot(kvm, params.gfn_start);
> +       if (!kvm_slot_can_be_private(memslot)) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       sev_populate_args.sev_fd =3D argp->sev_fd;
> +       sev_populate_args.type =3D params.type;
> +
> +       ret =3D kvm_gmem_populate(kvm, params.gfn_start, u64_to_user_ptr(=
params.uaddr),
> +                               npages, sev_gmem_post_populate, &sev_popu=
late_args);
> +       if (ret < 0) {
> +               argp->error =3D sev_populate_args.fw_error;
> +               pr_debug("%s: kvm_gmem_populate failed, ret %d (fw_error =
%d)\n",
> +                        __func__, ret, argp->error);
> +       } else if (ret < npages) {
> +               params.len =3D ret * PAGE_SIZE;
> +               ret =3D -EINTR;

This probably should 1) update also gfn_start and uaddr 2) return 0
for consistency with the planned KVM_PRE_FAULT_MEMORY ioctl (aka
KVM_MAP_MEMORY).

Paolo


