Return-Path: <kvm+bounces-54455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C276B21714
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 23:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 720E919077F6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 21:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17982E2DF0;
	Mon, 11 Aug 2025 21:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2j1LxxX3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF7A2D97A4
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 21:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754946657; cv=none; b=jvXFuK01twxuorFuna4RIM79DeftN2UsHepx1ZEIAxwEoS51HSj4ubojvo1+uDS6UJ8BoagJWolRCretylHLD6TkbdDb02JI75dB4I/D2KNBn70gkPnKuXbiyJ4Hd2EKa8tFZmeFpEDrjKLxuI87XGRMGd+SAo5rL8TxUjEilSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754946657; c=relaxed/simple;
	bh=wBLSCAldXdz6Aqzj2ZgVJBIXTJAMMxPB3VZz7oI849c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7XMykkxx7SuJE5h/m3tLvqQBoQtJlZ+ksDlmDvUcGnC2DNVk6+tcxqWgl9pnW0CMGa7o/BJRZBBMtKgB4yAmr+iyMYMCMHVtXQbGFQRQ5y4qB3ciFAmWqh/4b+2KVVRE6Pn+6MZoRDcwJfLcVZCARJ+UpRGZUjgg5YCv7l81Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2j1LxxX3; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b0bd871d9aso111611cf.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754946654; x=1755551454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8kpMVQN+kxcOUo8uXI1h/4+fugPUTPnI8qDv0t+xv0=;
        b=2j1LxxX3pDFT2AOSimcn+wTiNQufFzCZgDot76tTwapuCVzsbZ2i2EYyNxVICk0VwQ
         DL8FzsS+SI4tORdz5o54DxdVC5xCTFaKe6hV5l2I0vJ79974/ToW8tHQOlR5cleegg7m
         NfImwn/UrqcR9ZBdRUQljTY95u60gaYAdzRzEc5A44w6LYD8OwY6K2TDds2Yu6VKjm0L
         pF43f54l4LkJalxjTer8Dk7i/U3gix+3g++QwJGCFwETfVolywEPEkFVFUTxHh0IWV5U
         McVHcmSnJ126BIrv9bjLrVsffUZ69ebwGWW7tx3RI9iKA2ctXzlAX0RpYucOYCTqMWpI
         OlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754946654; x=1755551454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8kpMVQN+kxcOUo8uXI1h/4+fugPUTPnI8qDv0t+xv0=;
        b=jJkKgtvlrYpThcJIUu4vS6+wNZMcC2SOd3FTGu4ILFlfIBQeNK9OdxrgZscKGQLQvx
         xipKu9WMkgbizLLouAR4O5iwLzsfM8qqrj3SruItpT00DJso/AwvdjzTbMAducCJoyT3
         Bp1gFp/vHKNXy54HReA9kZuAIQKzpbxDFQa+1RKBYhmZK9Eeg89B9PNeH6NFrqtdNDmM
         hXFkVJNjor2UZWoTlzcdly3Fx693L5qxHgywrWOrPqyOfsS8wQBMPALDb9d6ZbbnqzgD
         DDXZlWD3mkzxr+ZkB9UXsElVktL3Xqu7zShuIjlIcBXOFcu2AFXSnHHvMK8mM0F6kKeR
         yPTA==
X-Forwarded-Encrypted: i=1; AJvYcCUd1JMkF9GtYKC8izFeMyXHpif6K5UzhBedyjxxDMdJf25n/R7hHbHm+1EYJFO9+IyAiEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg+ggTX3iZqfaKHE3vyn39+MaLJowMWaIjeJlTegVX0oIRa4GM
	v3akSmiVp0olIx2chRma3O8KUFseGeDg9ZD2aZeYQo+03ipyZNy3Xf30QKKnL3rXu83n4gUmE6O
	lXs7+cLvHbdhRtk6rZQv/q6QNM1VoVr4+SAJcAPzk
X-Gm-Gg: ASbGnctBWS2o4WXY6yN724414XgrSliTpViwlLDUF68HAT7JoYlLkWDHIiH3496gmfU
	ecG/FfhAR1u6flwqzHh3ASnRCrJkxX6gkpyoJ198vXgnF7fUpq1bkkz7shpSYLZHS3CzGScEaIE
	fvhHVdVXl9RKCBHLOUHtg27eigTUGLM/7eR6+cXMq4XJFP6+6uhCfGJzODO+Wc2csU2f33HWfr+
	Ns2JjSqS+gXoZkEYBBiOqqw2Wn8JImCaG3q2Aw=
X-Google-Smtp-Source: AGHT+IGrFd77Bx+EKopvRxbg+m1IeKplQHg0gCIDVl+wT9usSoAPtnU/AdsEjyhI0upm5xEdEbCeQ2tz2jz3wh0En3g=
X-Received: by 2002:a05:622a:1a9c:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4b0ef35f647mr290581cf.3.1754946653817; Mon, 11 Aug 2025
 14:10:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094516.4705-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094516.4705-1-yan.y.zhao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 11 Aug 2025 16:10:41 -0500
X-Gm-Features: Ac12FXwox6fPzU2alMAVmH7V3wy02ekBTE4ia43sewPZz30re1TGyXyUMSAloFo
Message-ID: <CAAhR5DEZZfX0=9QwBrXhC+1fp1Z0w4Xbb3mXcn0OuW+45tsLwA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vannapurve@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com, 
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 4:47=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
> flush is necessary when switching KeyID for a page, like before
> handing the page over to a TD.
>
> Currently, none of the TDX-capable platforms have this bit enabled.
>
> Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
> Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
> supports 4k pages and will fail if there is no PAMT_4K for the HPA.
>
> Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
> of TDX_FEATURES0 is set.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Pulled from
>   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-h=
uge.
> - Rebased on top of TDX huge page RFC v2 (Yan)
> ---
>  arch/x86/include/asm/tdx.h  |  1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index f1bd74348b34..c058a82d4a97 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -15,6 +15,7 @@
>
>  /* Bit definitions of TDX_FEATURES0 metadata field */
>  #define TDX_FEATURES0_NO_RBP_MOD               BIT_ULL(18)
> +#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC     BIT_ULL(23)
>  #define TDX_FEATURES0_DYNAMIC_PAMT             BIT_ULL(36)
>
>  #ifndef __ASSEMBLER__
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 9ed585bde062..b7a0ee0f4a50 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
>         return page_to_phys(td->tdvpr_page);
>  }
>
> -/*
> - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> - * a CLFLUSH of pages is required before handing them to the TDX module.
> - * Be conservative and make the code simpler by doing the CLFLUSH
> - * unconditionally.
> - */
>  static void tdx_clflush_page(struct page *page)
>  {
> +       u64 tdx_features0 =3D tdx_sysinfo.features.tdx_features0;
> +
> +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> +               return;

Isn't the logic here and below reversed? If
TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC bit is set, we want to perform the
clflush()

> +
>         clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>  }
>
> @@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
>
>  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
>  {
> +       u64 tdx_features0 =3D tdx_sysinfo.features.tdx_features0;
>         struct tdx_module_args args =3D {};
>
> +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> +               return 0;
> +
>         args.rcx =3D mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
>
>         return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> @@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
>  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
>                                 unsigned long start_idx, unsigned long np=
ages)
>  {
> +       u64 tdx_features0 =3D tdx_sysinfo.features.tdx_features0;
>         struct page *start =3D folio_page(folio, start_idx);
>         struct tdx_module_args args =3D {};
>         u64 err;
>
> +       if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
> +               return 0;
> +
>         if (start_idx + npages > folio_nr_pages(folio))
>                 return TDX_OPERAND_INVALID;
>
> --
> 2.43.2
>
>

