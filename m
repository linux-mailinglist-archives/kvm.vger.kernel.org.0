Return-Path: <kvm+bounces-54639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F7EB25ACA
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 07:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69496688047
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 05:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5903822128B;
	Thu, 14 Aug 2025 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCw9iIsj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2343C2AEE1
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 05:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755149503; cv=none; b=p8ajLlD+2PkG/MgK+913h/US55FRvm/AdA0nRKbRStvmnpkXqZIi9MGJfIsP3DZXjzdm2iqxXbR7BnbfoIFnMRRvNMEPzFxW5uYFu3IIZkxqpFS67OMMqvlW6VSDXLToNQ9+eHzNEjVQTxHCyDDmUUgEOXXP6JRYhoE/CspBMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755149503; c=relaxed/simple;
	bh=jZvzmSyGn7T089VYJe2yp2prqHAiYftE0tbdCJ3bvK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XLTKQNBHfcPCLMCRjTe8Y6VqnjscG9VwaK2IL8mq2sEgu/suce4EyvOsA4wozAHlY+QzQvbDA9J3gRpOpBsaQPsH+mkEa3ClaAFnv5xS6hkRUVHS5Robcra1u/qi3puTh6ndH6vwA6RaEBqc2TM6GSOJZs2U+r1VUnZlaohEn0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCw9iIsj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-242d3be5bdfso68595ad.1
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 22:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755149501; x=1755754301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5LVkqNa+t7tEOlEpRROaBVNxGWm7/JKJk9MQgMlMwQ=;
        b=UCw9iIsjMA+IkVwjKZ963HLMLXLpCO8Is7qC4fBgFL5rzSpOSGyqNl7MH8m6DGWacT
         wNafMWG4EkhA387wVtJh3/XyFgo21YyC/36MJh5gsFkUA/6Uyyh9bQ99OVVJmGK8JKAt
         umVIE2ob/pl3amR60U8PNLhMLksaVvvdlm2q56lbmWnNSh0YEc+EXTWUt9WGc3fq/qo9
         Bzs5T8bWsh1lIL5jJDqETudvlQH/IfdYXJ+G9JGhufSBUXeCbmTN1yCmCAAp8M7+x2JE
         Uv9951XoKekKZWzJXYd0g1N2JKSZEpO9T3U8ydx1UZPVdcnjcpbqPdmRcwHv+Xdem/Wd
         QGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755149501; x=1755754301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5LVkqNa+t7tEOlEpRROaBVNxGWm7/JKJk9MQgMlMwQ=;
        b=xMxrEHsA2fYPxH68pP7LEWdWyaZILsHd0+kR/gayYIOZOVU9OQ+xFoBqcRblsDpFhJ
         HMdvsh8jbpg+FCzrvB0y3LcO2fAQak/OxwVJ5dtk8nUNdb/lRpm7aAvelxiJeyNMeqcr
         WZU7ngIksnowxpT1KMoJo/0la+vtjquI2RD50DBLbrPlgn0tQxC+bYeNi9mmXO3XlkZH
         zM8NJHBMSauRZPFTM/DHzmkPR7NhFCBeiof67VGVySBWefhu1VkruZa1O1J9aU9E8VeG
         AzwoOmZfaaBLneYHw1Cx3QRurCJN9hIdNWZi/yiDvfwa0FELgvzhaj1tn13xQ5YP6Fec
         Rw7g==
X-Forwarded-Encrypted: i=1; AJvYcCW2ig2gt0Gt/0spLnx8D+rII217dKorUhehzNzBfF6MaKR6GAG8MweFoseBQTuUrJYK4Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDavNHUq9TC/k9hrROouWz+7osbi9yJIlrF9CV3ehjqjCXrHPN
	gpXIkZKAXFYQaSrnv58zcqAyUNwz30WGygp1b/2RWasPXOdS8aZftDOhOUW8CfAqTZb1K7EBdLf
	X/5M/ZYKS+whCE5vQ5/yd/EDtHnJvrONHwqboA7aU
X-Gm-Gg: ASbGncvR7G1FZai9ff0rkGvLpS0APv+WdyvNnXX+nmCCPkWuWyw18JEZqHieU7RGMYO
	nJjJRYC3qwfAbF8WL/uLrvFBDP/fVi0Jndh2yl1YB/n/z2G9968fenriV6JcrA7a3vWGfyqLTP3
	A7KBUNbUJEjQve3dgoeB3TJ4Iy1auL39M4gKQaTuPmEu0OYC8nK23Q4Chrs5NYsssSUR5j/PH6i
	r7pl95i/EgBecdXuoYvI0raTF5RzwbhCDMsQ5b77Cpg64A=
X-Google-Smtp-Source: AGHT+IFDKsOfNVeujTT3ep/sGHvnByYBZ/JoScmRAGpHffWGDkBCsAMududAym2fsPhHWFP4OlU0YkU4mCSedHl/Eag=
X-Received: by 2002:a17:902:e88f:b0:240:5c75:4d29 with SMTP id
 d9443c01a7336-244588884e5mr2748565ad.0.1755149500742; Wed, 13 Aug 2025
 22:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094616.4776-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094616.4776-1-yan.y.zhao@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 13 Aug 2025 22:31:27 -0700
X-Gm-Features: Ac12FXx7HXi6s_U8y98YfVtv8jGpTEPlMpBsLrxhxzqCYXdQ9oJQT1rAHK3Q8sE
Message-ID: <CAGtprH8a4i-U-4Z6=Bk87FsC2nG+UbTVWB1Sc8oYXMJs7pHUwA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 22/23] KVM: TDX: Handle Dynamic PAMT on page split
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, thomas.lendacky@amd.com, pgonda@google.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 2:46=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> +static struct page *tdx_alloc_pamt_page_split(void *data)
> +{
> +       struct kvm *kvm =3D data;
> +       void *p;
> +
> +       p =3D kvm_mmu_memory_cache_alloc(&kvm->arch.pamt_page_cache);
> +       return virt_to_page(p);
> +}
> +
>  static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
> -                                       enum pg_level level, struct page =
*page)
> +                                       enum pg_level level, struct page =
*page,
> +                                       kvm_pfn_t pfn_for_gfn)
>  {
>         int tdx_level =3D pg_level_to_tdx_sept_level(level);
> +       hpa_t hpa =3D pfn_to_hpa(pfn_for_gfn);
>         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
>         gpa_t gpa =3D gfn_to_gpa(gfn);
>         u64 err, entry, level_state;
> +       LIST_HEAD(pamt_pages);
> +
> +       tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_split, kvm);

This invocation needs a return value check.

> +       tdx_alloc_pamt_pages(&pamt_pages, tdx_alloc_pamt_page_split, kvm)=
;

IIUC tdx_pamt_get() will result in pamt_pages allocation above, so
this step is not needed.

>
>         err =3D tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> -                                 NULL, &entry, &level_state);
> +                                 &pamt_pages, &entry, &level_state);
>
>         if (unlikely(tdx_operand_busy(err))) {
>                 tdx_no_vcpus_enter_start(kvm);
>                 err =3D tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level,=
 page,
> -                                         NULL, &entry, &level_state);
> +                                         &pamt_pages, &entry, &level_sta=
te);
>                 tdx_no_vcpus_enter_stop(kvm);
>         }
>
>         if (KVM_BUG_ON(err, kvm)) {
> +               tdx_free_pamt_pages(&pamt_pages);

If tdx_alloc_pamt_pages() is not needed then this can be dropped as well.

> +               tdx_pamt_put(page, PG_LEVEL_4K);
>                 pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_sta=
te);
>                 return -EIO;
>         }
> +
> +       if (tdx_supports_dynamic_pamt(tdx_sysinfo))
> +               atomic_set(tdx_get_pamt_refcount(hpa), PTRS_PER_PMD);

Should this be
atomic_set(tdx_get_pamt_refcount(hpa), PTRS_PER_PMD -1 );

as tdx_pamt_get would have increased the refcount by 1 already above?

