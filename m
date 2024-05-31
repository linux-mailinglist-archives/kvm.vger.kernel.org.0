Return-Path: <kvm+bounces-18529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FC48D6069
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17E181F23672
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50816157466;
	Fri, 31 May 2024 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUww8ZOQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D4157468
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154104; cv=none; b=bOjIshKK0JdMp82bRHEZBEjWjfBSjP86gM8jCdJn5Lwc/opFJHWJHL4l1saGe+pUKIGC6Higr9jGCvXBWjxtGKPmYav8AkyT1g0WGyILvoHZL9orH4DMGgFVgG8QVHIBVQhd9CWUdrpMuLao1ystq4vMq7iyMN4PZvo7v5bgBYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154104; c=relaxed/simple;
	bh=XYyD52Tu1UfTHKsFCSwxqQp0NXK1mWNnCeX3UnEkF1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cU8fpgYIQP/+QXeRVg6reaVlmE7YL2woIVo8yuLJ3+aKO/CIHNvc1S6oqaEbgUhaI143+9pJ+oBDc/bux/HQPAZFQCSxz83LPcNvilTj9Kk2pA2EuAsem/SWOyUNBg+MvGjiS8G+cXabhigyt9/BC+V+P1oY5u2JNoCRJfFpmns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUww8ZOQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717154101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2jXYYD4cspJOQ9jiYJKbwem/EX2NyyJObMUsqoU6/W0=;
	b=AUww8ZOQpvaeSe1deQspoG/riqP0Eh03efTZ0ehIALHf2lbVFieu2iF6MWs82XhLDrDN5J
	N+TFYSIt2BlLyFp70nHV7sP8STadGd9dT04RnDV1RJsVMeDY2XzFwmgOa/GWSyXNa/OZ23
	jOXVLCf7x/Stx1Opk1n9QN+aR1ugBRo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-fwbYxLPyMxal_4jrriHlwQ-1; Fri, 31 May 2024 07:15:00 -0400
X-MC-Unique: fwbYxLPyMxal_4jrriHlwQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dc5934390so923588f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717154099; x=1717758899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jXYYD4cspJOQ9jiYJKbwem/EX2NyyJObMUsqoU6/W0=;
        b=pUX0fM+FpGNwAY1mP7vUM4hFG1QPNVY4i53sw1lcGHBjGzhMQxU/J3aIHN35OaHZg+
         Z1BpIkgIM/KzUemxP6GkIgNmu7dQUImb0ipK9vZaCMIcesyauFGIsJ0e9zOjwiq8hk7C
         Aa+loo7Vayvnt81nyxkkXyZQS6UG2i16/3RyJKaqLBY/Wog48k+gChTtMCZaSPKxhsvS
         5hLV/+JkZvWcNaWbXTniX85hQCgSUcFrl0gq4zWcKnloe9B8168xRaNO5HklF0Napg/t
         CbVpmDVxJ+FnjKOObEOd1A8bApFMRv8+q3jba0J42m74yAGa2ru3m8YwS36EhyZW4pGT
         a8GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMzTzmfPRH6Li/xrNPIvtD1acb3mFbaNmTlwezPOcMwGxZIHdB5fM83KpgXRi6hpE5u0dRwYbv8zXjlHy0TlHY5A86
X-Gm-Message-State: AOJu0Yw8hT3+bcIi/eE1mzjwcE6ZBRaIyAWBORaLoA8b6AQYUlUdYcjA
	gKuyEWCu4aahiifFDayJlAhlJfgvfSKtoPmAKR5YzRGX96z1hzsyc+JZaropo47hg2PZ+G85Khd
	o6kqbAea16xhhgL+6BonMuu51cg+7OqIhI7VbfLGh2X66mIBLsMhyr9EZvBPfssGBfTNOa5ShnL
	QAfos/FnAg1o8VYPPUXDGqbt/x
X-Received: by 2002:a05:6000:1052:b0:354:f7b9:75bd with SMTP id ffacd0b85a97d-35e0f30aacemr1292516f8f.47.1717154099271;
        Fri, 31 May 2024 04:14:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+52y8MtfKNErYDc3147gk2kO8zuDtDGsX5IsUfjhiIZcf8DvdYxXgSFh+DwIZyfBtHizpAuij4Gou4STJFB8=
X-Received: by 2002:a05:6000:1052:b0:354:f7b9:75bd with SMTP id
 ffacd0b85a97d-35e0f30aacemr1292489f8f.47.1717154098896; Fri, 31 May 2024
 04:14:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-24-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-24-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:14:47 +0200
Message-ID: <CABgObfaL_OBwWvPbRAocKSprqPZVFsPMamjFNWris3UB5Az0zQ@mail.gmail.com>
Subject: Re: [PATCH v4 23/31] i386/sev: Allow measured direct kernel boot on SNP
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> From: Dov Murik <dovmurik@linux.ibm.com>
>
> In SNP, the hashes page designated with a specific metadata entry
> published in AmdSev OVMF.
>
> Therefore, if the user enabled kernel hashes (for measured direct boot),
> QEMU should prepare the content of hashes table, and during the
> processing of the metadata entry it copy the content into the designated
> page and encrypt it.
>
> Note that in SNP (unlike SEV and SEV-ES) the measurements is done in
> whole 4KB pages.  Therefore QEMU zeros the whole page that includes the
> hashes table, and fills in the kernel hashes area in that page, and then
> encrypts the whole page.  The rest of the page is reserved for SEV
> launch secrets which are not usable anyway on SNP.
>
> If the user disabled kernel hashes, QEMU pre-validates the kernel hashes
> page as a zero page.
>
> Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  include/hw/i386/pc.h |  2 ++
>  target/i386/sev.c    | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
>
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index c653b8eeb2..ca7904ac2c 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -172,6 +172,8 @@ typedef enum {
>      SEV_DESC_TYPE_SNP_SECRETS,
>      /* The section contains address that can be used as a CPUID page */
>      SEV_DESC_TYPE_CPUID,
> +    /* The section contains the region for kernel hashes for measured di=
rect boot */
> +    SEV_DESC_TYPE_SNP_KERNEL_HASHES =3D 0x10,
>
>  } ovmf_sev_metadata_desc_type;
>
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1b29fdbc9a..1a78e98751 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -145,6 +145,9 @@ struct SevSnpGuestState {
>
>      struct kvm_sev_snp_launch_start kvm_start_conf;
>      struct kvm_sev_snp_launch_finish kvm_finish_conf;
> +
> +    uint32_t kernel_hashes_offset;
> +    PaddedSevHashTable *kernel_hashes_data;
>  };
>
>  struct SevSnpGuestStateClass {
> @@ -1187,6 +1190,23 @@ snp_launch_update_cpuid(uint32_t cpuid_addr, void =
*hva, uint32_t cpuid_len)
>                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
>  }
>
> +static int
> +snp_launch_update_kernel_hashes(SevSnpGuestState *sev_snp, uint32_t addr=
,
> +                                void *hva, uint32_t len)
> +{
> +    int type =3D KVM_SEV_SNP_PAGE_TYPE_ZERO;
> +    if (sev_snp->parent_obj.kernel_hashes) {
> +        assert(sev_snp->kernel_hashes_data);
> +        assert((sev_snp->kernel_hashes_offset +
> +                sizeof(*sev_snp->kernel_hashes_data)) <=3D len);
> +        memset(hva, 0, len);
> +        memcpy(hva + sev_snp->kernel_hashes_offset, sev_snp->kernel_hash=
es_data,
> +               sizeof(*sev_snp->kernel_hashes_data));
> +        type =3D KVM_SEV_SNP_PAGE_TYPE_NORMAL;
> +    }
> +    return snp_launch_update_data(addr, hva, len, type);
> +}
> +
>  static int
>  snp_metadata_desc_to_page_type(int desc_type)
>  {
> @@ -1223,6 +1243,9 @@ snp_populate_metadata_pages(SevSnpGuestState *sev_s=
np,
>
>          if (type =3D=3D KVM_SEV_SNP_PAGE_TYPE_CPUID) {
>              ret =3D snp_launch_update_cpuid(desc->base, hva, desc->len);
> +        } else if (desc->type =3D=3D SEV_DESC_TYPE_SNP_KERNEL_HASHES) {
> +            ret =3D snp_launch_update_kernel_hashes(sev_snp, desc->base,=
 hva,
> +                                                  desc->len);
>          } else {
>              ret =3D snp_launch_update_data(desc->base, hva, desc->len, t=
ype);
>          }
> @@ -1855,6 +1878,18 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderC=
ontext *ctx, Error **errp)
>          return false;
>      }
>
> +    if (sev_snp_enabled()) {
> +        /*
> +         * SNP: Populate the hashes table in an area that later in
> +         * snp_launch_update_kernel_hashes() will be copied to the guest=
 memory
> +         * and encrypted.
> +         */
> +        SevSnpGuestState *sev_snp_guest =3D SEV_SNP_GUEST(sev_common);
> +        sev_snp_guest->kernel_hashes_offset =3D area->base & ~TARGET_PAG=
E_MASK;
> +        sev_snp_guest->kernel_hashes_data =3D g_new0(PaddedSevHashTable,=
 1);
> +        return build_kernel_loader_hashes(sev_snp_guest->kernel_hashes_d=
ata, ctx, errp);
> +    }

This is effectively a new method:

    bool (*build_kernel_loader_hashes)(SevCommonState *sev_common,
                                       SevHashTableDescriptor *area,
                                       SevKernelLoaderContext *ctx,
                                       Error **errp);

where the four lines above are the implementation for SNP and the code
below is the implementation for sev-guest.

Paolo


>      /*
>       * Populate the hashes table in the guest's memory at the OVMF-desig=
nated
>       * area for the SEV hashes table
> --
> 2.34.1
>


