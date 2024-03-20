Return-Path: <kvm+bounces-12319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF498881693
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 18:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EC881C21984
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B046A343;
	Wed, 20 Mar 2024 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZieuwMM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C106A01B
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955733; cv=none; b=ix+Iqbt/WAinVHVXeWgPs0q3d4ZqxVYWhsrZhvW2uMTyV0C5bhrdaDTzCCuRwb8s0QZd2fnZjh7TyWBuEACwSbQlpeiCY8R6a9hU7y2JOrXL9hBXxOwSMOMzpFsdH5iSiu7EP05dopAM+juZ09KNiBgFAtTLAK9xEup6bN4H8HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955733; c=relaxed/simple;
	bh=hKG7tJgsPh9DORRVzqkKky8GGHViWeO7vjjgD7DkukQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SCYII9oLJTCfRPUxaFxRKjR+Wb8DGQrcYUqXzFXxJcn12NBIVoQ/6t8+BliCR9KJPYxFWzuOAnwm/Bc+7ryvkdv1y8rMTXh0Ov9V4loDILGtuA07SyRKOEN9Vz475HzbZzZlU2/PpkAC63tEs24sS7t9jEMlGlEoL1azqlnROjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZieuwMM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710955730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jTNbtMbxpop+bQq0JJOZBsIfXIIEPcHQLvpxIITRNNI=;
	b=hZieuwMMCKkvfQxTnk3Oo5BJJJVViFOX3E95W0yxMGZihMJCpkDSKnoRKapFWovJZATho0
	m/Xs5XJziq0datS914fOphnEQoWOZxtC4o0fkvwaViFrNXLzjkJLGDM6sGIqDf9ACabO/Z
	NTeI5XPYKU/SP3/PaJ/svfNXHa8eGwU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-oVvn0kGlM7eF_R77sv7reA-1; Wed, 20 Mar 2024 13:28:49 -0400
X-MC-Unique: oVvn0kGlM7eF_R77sv7reA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ed8677d16so27307f8f.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 10:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955724; x=1711560524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jTNbtMbxpop+bQq0JJOZBsIfXIIEPcHQLvpxIITRNNI=;
        b=HOWsmuqUGY6/UAXlgwNsF9TU5z86uiMg0kS1TewcjEnNUNIk8NmFxAjDWC5hjr1dye
         6OSZy5kMExFfzXczV7lZXpxRa5rybsVAos0du6hmakpHvId2gteGdKncnxAQ2t3+gAO5
         cbPRgorizOwzAh76OfQnN8TYQB7zOzP1C0rAUfPI1Gyky42mw2LuxAoBKnAXrgHrCcJ2
         WC/1K0WGgLCJC7+u/ooloCYSkURM9MR05ORVfVyMO2URXq4jR5i2Cdgbe9nO7rz4n1/9
         3wXoMckZUA+6HTVC+Wq3HA6VuWH3QHcGVrCIer4nrs/O8zHMcXrNEmVyoWPeRswRYQVB
         vkxQ==
X-Gm-Message-State: AOJu0Yzrcp0vy8FZMmNAoVC75mitzCrcwVt2m7BGykIbTyrEKUkDeRTr
	m2BEjm+4NPrr1obdhjKYAT7DEQrXaZE/qCi62senAm/bONLE90wiN2hzo4upT/V8iEl0htzwZNx
	pBdtKNkmzCmomJCQb0dU8NkbSFfK4L7WaaMZtBg9O/kERI2i53whte9Sl1gJY+Gp8WT08wsXKxH
	N3wxwl8D1RqI6hrmFSkNDex2j1
X-Received: by 2002:adf:fd04:0:b0:33e:781d:88c3 with SMTP id e4-20020adffd04000000b0033e781d88c3mr1975592wrr.48.1710955724613;
        Wed, 20 Mar 2024 10:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUSonEpkqIs6UvTEipW/i/Sb8XB2/SyAe+307wQ/mxm28QibJaC/seZsljP+J8ad6yvrWbyDhh8OGlVlaKSgE=
X-Received: by 2002:adf:fd04:0:b0:33e:781d:88c3 with SMTP id
 e4-20020adffd04000000b0033e781d88c3mr1975551wrr.48.1710955724132; Wed, 20 Mar
 2024 10:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-16-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-16-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 20 Mar 2024 18:28:32 +0100
Message-ID: <CABgObfatM3QoT6WYj4MU60XY_T2xeekn_DcKh0_RhN5-B0Xs9A@mail.gmail.com>
Subject: Re: [PATCH v11 15/35] KVM: SEV: Add KVM_SNP_INIT command
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 6:26=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> +        struct kvm_snp_init {
> +                __u64 flags;
> +        };
> +
> +The flags bitmap is defined as::
> +
> +   /* enable the restricted injection */
> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
> +
> +   /* enable the restricted injection timer */
> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)

The flags are the same as the vmsa_features introduced by
KVM_SEV_INIT2, which is great - SNP does not need any change in this
department and this patch almost entirely goes away.

>         if (sev_es_debug_swap_enabled)
>                 save->sev_features |=3D SVM_SEV_FEAT_DEBUG_SWAP;
>
> +       /* Enable the SEV-SNP feature */
> +       if (sev_snp_guest(svm->vcpu.kvm))
> +               save->sev_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;

... on the other hand this begs the question whether
SVM_SEV_FEAT_SNP_ACTIVE should be exposed in the
KVM_X86_SEV_VMSA_FEATURES attribute. I think it shouldn't.

This means that this patch becomes a two-liner change to
sev_guest_init() that you can squash in patch 14 ("KVM: SEV: Add
initial SEV-SNP support"):

     sev->es_active =3D es_active;
     sev->vmsa_features =3D data->vmsa_features;
+    if (vm_type =3D=3D KVM_X86_SNP_VM)
+        sev->vmsa_features |=3D SVM_SEV_FEAT_SNP_ACTIVE

Also, since there is now sev->vmsa_features (that wasn't there at the
time of your posting), I'd even drop sev->snp_active in favor of
"sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE". It's only ever used in
sev_snp_guest() so it's a useless duplication.

Looking forward to see v12. :)  If you have any problems rebasing on
top of https://lore.kernel.org/kvm/20240227232100.478238-1-pbonzini@redhat.=
com/,
please shout.

Paolo


>         pr_debug("Virtual Machine Save Area (VMSA):\n");
>         print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*s=
ave), false);
>
> @@ -1883,6 +1914,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user=
 *argp)
>         }
>
>         switch (sev_cmd.id) {
> +       case KVM_SEV_SNP_INIT:
> +               if (!sev_snp_enabled) {
> +                       r =3D -ENOTTY;
> +                       goto out;
> +               }
> +               fallthrough;
>         case KVM_SEV_ES_INIT:
>                 if (!sev_es_enabled) {
>                         r =3D -ENOTTY;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a3e27c82866b..07a9eb5b6ce5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -76,6 +76,9 @@ enum {
>  /* TPR and CR2 are always written before VMRUN */
>  #define VMCB_ALWAYS_DIRTY_MASK ((1U << VMCB_INTR) | (1U << VMCB_CR2))
>
> +/* Supported init feature flags */
> +#define SEV_SNP_SUPPORTED_FLAGS                0x0
> +
>  struct kvm_sev_info {
>         bool active;            /* SEV enabled guest */
>         bool es_active;         /* SEV-ES enabled guest */
> @@ -91,6 +94,7 @@ struct kvm_sev_info {
>         struct list_head mirror_entry; /* Use as a list entry of mirrors =
*/
>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
>         atomic_t migration_in_progress;
> +       u64 snp_init_flags;
>  };
>
>  struct kvm_svm {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c3308536482b..73702e9b9d76 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1869,6 +1869,9 @@ enum sev_cmd_id {
>         /* Guest Migration Extension */
>         KVM_SEV_SEND_CANCEL,
>
> +       /* SNP specific commands */
> +       KVM_SEV_SNP_INIT,
> +
>         KVM_SEV_NR_MAX,
>  };
>
> @@ -1965,6 +1968,16 @@ struct kvm_sev_receive_update_data {
>         __u32 trans_len;
>  };
>
> +/* enable the restricted injection */
> +#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
> +
> +/* enable the restricted injection timer */
> +#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
> +
> +struct kvm_snp_init {
> +       __u64 flags;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.25.1
>


