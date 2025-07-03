Return-Path: <kvm+bounces-51504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE42AF7E31
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 18:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C0B21BC646C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8723259C93;
	Thu,  3 Jul 2025 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jcTlpW7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943DC20102C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751561503; cv=none; b=uXWSHxRCzp8DBf5SxXpefFSJIIASKWFOnZIJ570HqPFIkCmGO5zXOf1XZ0QvtcsBs8gzJ8L5PheeXJ073e83bEa9vCh6UisIoOP1vrJLe4YTZJdZ/GF+g/fSqIkrUD8hev3KyBn1EyC2RUH35xPwvMjM3kDhDcx6ri68wBFSp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751561503; c=relaxed/simple;
	bh=Bl4U2736cbdaIaL7r32DIiKWiFNjDYw4P426GZbKXHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtUMNNXEhofrj/bH7ObdmgrnNEB4GtAcU/8bg6wP8z4PoZ2Hy8+TIVAYnl7LSxZgvlj+fcMcPM57zfAEyIooB1OLCROpq4T6ccnu63wgC9VD2CLbTNGQymNfrvacFBZnit8la+YAxkSfB+5S3UteECaVU04GBaGrtjjSxy/ytzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jcTlpW7j; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2357c61cda7so176935ad.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751561501; x=1752166301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2Pypm8A2hrX0Dg/6qTKb5Bh6OJzo+0bDjJzK3OFgt4=;
        b=jcTlpW7ju09gWPuru5zpZ/owkYwmZ4TSQJzNFOLE8PhejHe79jwF7zU77pp6Si9iru
         WbSnwL0UZ6jH7M+mupTuWr1k2fF//WjsoJYjZFiKjmLyorvoE8Z/tgDdSmGoHS9Nkq28
         o/vuDXdBIvPiaaBxpcrQc8FCfd24NH3jfrKzIIcUPmN9wwJEHS6+hFUT4v4sEhMtfTx9
         int7G6hLG0h40S2D9dWzDYtc1jzxHtF9/iiAhIoTzD2WDaJxGuD7JjTdD4Xgernot0sY
         fFVLb7h7J8p4FGRDaucvaOysHc/cCLZr2y2qCCBsGAFtqFoEZZCbO6TaVBSpM4e1h3HT
         jO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751561501; x=1752166301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2Pypm8A2hrX0Dg/6qTKb5Bh6OJzo+0bDjJzK3OFgt4=;
        b=NgYh/8aIfjp1d0ChfoBfAAYqyhrSQrUT+CEKc9A4E05G/2Ie5AMeQKfMH1OD9IERdE
         zjb7myKaVdGOMv7nu2E3iWCdOuPW9uODRpmE6Bf4UDMpTUhYebQ1A9THZBHokobkeSiL
         RlsiJqSAhLgJmZ+vqmQ0PqQX06qawNjYc2h2F13Ok6kcT8VazlUoxvt8SF7Vd6k1jc9t
         ftHydbezblr6H3aAW1qll+wXAP2ybNZUQUeEFgwlj2CD2/Cf6S9gpKP/QYbubMAtGzRP
         3f5wfnE0VKXX1p+DZghXJIXYiX5rglAxLV23maHu06e+CVnZDao6A5Bv9qRJ+TJaQClI
         EYWA==
X-Forwarded-Encrypted: i=1; AJvYcCVssKdhe2RpEHhJ7Nja1TFklsNbQlpp7Ybr6UxDs8uhsN4/hgaT0myLn5rdbjVh5G0T95g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtP4vnOheHBbI690jssT0OoJgmgBANwc4SJbRfpnP/WxeS7oaV
	JEZjmiu2hT4oFpQm4mXQ9T6x/8E/D3nXFTxKAyjAzqz3+d653LcZJVwLwghoRFihukK1+hXjv1M
	yycuCOpVN3UUuSWysWtzaodrHcyjPf7x+jpXdOjLi
X-Gm-Gg: ASbGncvV2SusBvW9wQU89gGqo/OiPOVgoqtiUe625tZqaevbc/7nZMb2DBWFWvro+/b
	gzUimpl52xr0y1L9NdAd4WggLLVRYYw5J+Vy3X2PER6eQHucYGfxwhIYJXxGX+BIc8PxMNhEbP7
	xf1S1wI0GSi0O1f58l1v37u3C/GyJZnbi25C8jMMJbFz69uHwumtF87LUFJWwnkCYA2hJnQ73RB
	fjcEmEWPflUPhc=
X-Google-Smtp-Source: AGHT+IGXcFD7sYmA1iSdOQUEhyKPfILxX4bu/LO4qd9k2V427lZTYaQxOB0mfeyfOyKYZF5kwyRLF/xzM5IIEUmGxJg=
X-Received: by 2002:a17:902:c942:b0:234:13ad:7f9f with SMTP id
 d9443c01a7336-23c79c4f79bmr3137735ad.22.1751561500326; Thu, 03 Jul 2025
 09:51:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
In-Reply-To: <20250703062641.3247-1-yan.y.zhao@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 3 Jul 2025 09:51:28 -0700
X-Gm-Features: Ac12FXxb-01x2wcZYGaOot8b0VKW1HfuaPXyOLk1ZcRUX_G1vyGSA7jaP9CX_w0
Message-ID: <CAGtprH-Hb3B-sG_0ockS++bP==Zyn2f4dvWpwC73+ksVt7YqJg@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, ira.weiny@intel.com, michael.roth@amd.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 11:29=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region(=
)
> to use open code to populate the initial memory region into the mirror pa=
ge
> table, and add the region to S-EPT.
>
> Background
> =3D=3D=3D
> Sean initially suggested TDX to populate initial memory region in a 4-ste=
p
> way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> interface [2] to help TDX populate init memory region.
>
> tdx_vcpu_init_mem_region
>     guard(mutex)(&kvm->slots_lock)
>     kvm_gmem_populate
>         filemap_invalidate_lock(file->f_mapping)
>             __kvm_gmem_get_pfn      //1. get private PFN
>             post_populate           //tdx_gmem_post_populate
>                 get_user_pages_fast //2. get source page
>                 kvm_tdp_map_page    //3. map private PFN to mirror root
>                 tdh_mem_page_add    //4. add private PFN to S-EPT and cop=
y
>                                          source page to it.
>
> kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> invalidate lock also helps ensure the private PFN remains valid when
> tdh_mem_page_add() is invoked in TDX's post_populate hook.
>
> Though TDX does not need the folio prepration code, kvm_gmem_populate()
> helps on sharing common code between SEV-SNP and TDX.
>
> Problem
> =3D=3D=3D
> (1)
> In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> invalidation lock for protecting its preparedness tracking. Similarly, th=
e
> in-place conversion version of guest_memfd series by Ackerly also require=
s
> kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
>
> kvm_gmem_get_pfn
>     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
>
> However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which =
is
> in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on t=
he
> filemap invalidation lock.
>
> (2)
> Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> - filemap invalidation lock --> mm->mmap_lock
>
> However, in future code, the shared filemap invalidation lock will be hel=
d
> in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> - mm->mmap_lock --> filemap invalidation lock
>
> This creates an AB-BA deadlock issue.
>
> These two issues should still present in Michael Roth's code [7], [8].
>
> Proposal
> =3D=3D=3D
> To prevent deadlock and the AB-BA issue, this patch enables TDX to popula=
te
> the initial memory region independently of kvm_gmem_populate(). The revis=
ed
> sequence in tdx_vcpu_init_mem_region() is as follows:
>
> tdx_vcpu_init_mem_region
>     guard(mutex)(&kvm->slots_lock)
>     tdx_init_mem_populate
>         get_user_pages_fast //1. get source page
>         kvm_tdp_map_page    //2. map private PFN to mirror root
>         read_lock(&kvm->mmu_lock);
>         kvm_tdp_mmu_gpa_is_mapped // 3. check if the gpa is mapped in the
>                                         mirror root and return the mapped
>                                         private PFN.
>         tdh_mem_page_add    //4. add private PFN to S-EPT and copy source
>                                  page to it
>         read_unlock(&kvm->mmu_lock);
>
> The original step 1 "get private PFN" is now integrated in the new step 3
> "check if the gpa is mapped in the mirror root and return the mapped
> private PFN".
>
> With the protection of slots_lock, the read mmu_lock ensures the private
> PFN added by tdh_mem_page_add() is the same one mapped in the mirror page
> table. Addiontionally, before the TD state becomes TD_STATE_RUNNABLE, the
> only permitted map level is 4KB, preventing any potential merging or
> splitting in the mirror root under the read mmu_lock.
>
> So, this approach should work for TDX. It still follows the spirit in
> Sean's suggestion [1], where mapping the private PFN to mirror root and
> adding it to the S-EPT with initial content from the source page are
> executed in separate steps.
>
> Discussions
> =3D=3D=3D
> The introduction of kvm_gmem_populate() was intended to make it usable by
> both TDX and SEV-SNP [3], which is why Paolo provided the vendor hook
> post_populate for both.
>
> a) TDX keeps using kvm_gmem_populate().
>    Pros: - keep the status quo
>          - share common code between SEV-SNP and TDX, though TDX does not
>            need to prepare folios.
>    Cons: - we need to explore solutions to the locking issues, e.g. the
>            proposal at [11].
>          - PFN is faulted in twice for each GFN:
>            one in __kvm_gmem_get_pfn(), another in kvm_gmem_get_pfn().
>
> b) Michael suggested introducing some variant of
>    kvm_tdp_map_page()/kvm_mmu_do_page_fault() to avoid invoking
>    kvm_gmem_get_pfn() in the kvm_gmem_populate() path. [10].
>    Pro:  - TDX can still invoke kvm_gmem_populate().
>            can share common code between SEV-SNP and TDX.
>    Cons: - only TDX needs this variant.
>          - can't fix the 2nd AB-BA lock issue.
>
> c) Change in this patch
>    Pro: greater flexibility. Simplify the implementation for both SEV-SNP
>         and TDX.
>    Con: undermine the purpose of sharing common code.
>         kvm_gmem_populate() may only be usable by SEV-SNP in future.
>
> Link: https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com [1]
> Link: https://lore.kernel.org/lkml/20240404185034.3184582-10-pbonzini@red=
hat.com [2]
> Link: https://lore.kernel.org/lkml/20240404185034.3184582-1-pbonzini@redh=
at.com [3]
> Link: https://lore.kernel.org/lkml/20241212063635.712877-4-michael.roth@a=
md.com [4]
> Link: https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc5=
1.1747264138.git.ackerleytng@google.com [5]
> Link: https://lore.kernel.org/all/20250430165655.605595-9-tabba@google.co=
m [6]
> Link: https://github.com/mdroth/linux/commits/mmap-swprot-v10-snp0-wip2 [=
7]
> Link: https://lore.kernel.org/kvm/20250613005400.3694904-1-michael.roth@a=
md.com [8]
> Link: https://lore.kernel.org/lkml/20250613151939.z5ztzrtibr6xatql@amd.co=
m [9]
> Link: https://lore.kernel.org/lkml/20250613180418.bo4vqveigxsq2ouu@amd.co=
m [10]
> Link: https://lore.kernel.org/lkml/aErK25Oo5VJna40z@yzhao56-desk.sh.intel=
.com [11]
>
> Suggested-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---

Thanks Yan for revisiting the initial memory population for TDX VMs.
This implementation seems much cleaner to me.

Acked-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>

