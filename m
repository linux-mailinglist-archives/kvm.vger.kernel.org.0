Return-Path: <kvm+bounces-44114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD05DA9A9EC
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55C645A418C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F424204C2E;
	Thu, 24 Apr 2025 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PMQjdnnI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195D1E9B32;
	Thu, 24 Apr 2025 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745489978; cv=none; b=jy+b3tFwtwNI/7vMyiJu1HRfxzTFDZmH4QWJKZja+XS/vyW/5NCrvCTX3tSG2NUl1W4f5+eM8OmtQ5mdfo9KmlmDPCsHOtoP72X6z5OGXIK66HligjG/sCDGy+XtjMRJ4BFGbedxC0+YGoJ2zSY5yeMNYlUjnnrmpQr4uN07IQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745489978; c=relaxed/simple;
	bh=N2s2BcXDjzDVGxuA4kX71UjVh3HFxxJt6DnEPEaPjXA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=cYHjuH+zCSz8n+9NKD1hQGJRHaid+yHHokbRZzbOF6aDhqnbrj+PECbk3zqvD/hydtna4lRJiWtP9dHZy+wxXHh15J3QNfqF+TZ/OwAbbWtRmZe8f17aseyr9Lil8f9KaxysFH5gw3LkTEQs21hDEb2LVn6znHawdBTrFA9bKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PMQjdnnI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso5261355e9.0;
        Thu, 24 Apr 2025 03:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745489975; x=1746094775; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1tt+JiBvs/QL64nfkQEuwIxILZiVxeis5k9XCW27jc0=;
        b=PMQjdnnIdX5I+57lGZR6VZ6m57lEkD3N+vOrUcxEmef/AQPBZTt0QEFd7dCuopxx0u
         ug3l0+TYICsEypAO24y76sT6ir+AoqIm6NRyd/7r3MLM2G/uGeY0XBWSds+gPZ+n6LwP
         Im+m03ls9EMyKWKETj/HpaA8mv6HRdpnHApGAbkUdpWZMzNZ/4H6RVdhIPKC54ina1aC
         JowgShiYHpb1F8O6qC4Q5PFl/Arym+vLsDIYYRpjUahA9qsCblC5pcTvCv+zwag5MP7o
         wnY2MmaN1/zuZ0Yzx83PNDjulMwnDg6JlST1FTMREngxH8F3fxrIIdaKwBBuRMwsMRW9
         5UOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745489975; x=1746094775;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1tt+JiBvs/QL64nfkQEuwIxILZiVxeis5k9XCW27jc0=;
        b=rvMZhI5kj3JWdx/tf5/Pn+sDvyWRLU+NBuDlCXs+qfSNjE5evsu5l5wyzK2TnOlkCn
         BCHyRScch2RUg2ye7yhcF4gbCYwJOgHe8muP1XQQoC4420CBYqI1kmlgdDC+rIbWVCk9
         S0dMv311a44VoTb8im9HBi6riyN6ZLnKBz8xQCWspHCKEL0GUEfA1fOKlOG4wLJKvpKI
         KjmhCIaMbAOKxb0Mv5PUesOPpSb/cywsXzBaLTsgEX+v9io50fKA0LQztS1PcVrsxQG6
         BIvq8TiSB83LTVeQFUCe9M5hL4u4cUSkoZ7uqyY28WuqlfVPzLow2/GmG3ZJ0CEe4VK/
         P+0w==
X-Forwarded-Encrypted: i=1; AJvYcCWRVz5jY6JtqzQfnhjrMzFPUN0FNBd+jmfKXNyslzBs7YvDFJT/cmPeDRq9kshVgsI3CbF/wWg1w1LAuY19@vger.kernel.org, AJvYcCWv1wEJZnPVE1odUsIuz1QuQdqyd0dLkzQgqDQ4XIHx35RNV9tna4WMCrHUzLiivbCG05I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR0cLDDFWQX2bkEg7Qat2o/G0y4p1hchMPbZviXgN+cpwVlQDV
	yVhMw73FFu0PaFDSjm87wSQJvPLAOJB4kSfDwEcmShQM8UVKw7ip
X-Gm-Gg: ASbGncuUx/YaODPunyU9TBudpDFYtSYezclEVEIieig3b8d+88SnEEKdamr5lv0bIxb
	/ebmVIXuosq37j0rtdezJvPBBMdgZ5bM9ormuZcR96cec36wnU7hxQq0wxT6OUthM4kbx+rWv3p
	DHklyPtfMwo2Rvpbz1HarCJh5inKmDJTHVcOAiEMsq+i9Hakodn7/T6saEBHVgCrxm7YBhzXVcy
	QayXoQ5k4/xR9+iF248opK+HTy8JQEzVW9amDTjxIViizBJzZJRtNSeA5fIm2AxsxdffkFhR00X
	YJ9Vf567PrcgLBsByNd+tfts7ff9EuSN2T93cldC1gDbqtqsVrJOWFFh7ms4j2QJ2BCI9pFy2am
	FmqNtgb9TseConJo7q46IYg==
X-Google-Smtp-Source: AGHT+IGU3dE7mOe0k8jag2/WwmwmZW16j8TNvMk1B2MzBanVRVP6xUmi1yhNxAb4AHKWCz0sZxRcYQ==
X-Received: by 2002:a05:600d:10:b0:43d:683:8caa with SMTP id 5b1f17b1804b1-4409bd22cf7mr18604175e9.15.1745489974655;
        Thu, 24 Apr 2025 03:19:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:f708:e6f8:ba5c:1977? ([2001:b07:5d29:f42d:f708:e6f8:ba5c:1977])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29bf8fsm14995935e9.1.2025.04.24.03.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 03:19:34 -0700 (PDT)
Message-ID: <a850503bc9bd789d2531fa64c5321d2d9cce5725.camel@gmail.com>
Subject: Re: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for
 punch hole of private memory
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: yan.y.zhao@intel.com
Cc: ackerleytng@google.com, binbin.wu@linux.intel.com,
 chao.p.peng@intel.com,  dave.hansen@intel.com, david@redhat.com,
 fan.du@intel.com, ira.weiny@intel.com,  isaku.yamahata@intel.com,
 jroedel@suse.de, jun.miao@intel.com,  kirill.shutemov@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,  michael.roth@amd.com,
 pbonzini@redhat.com, pgonda@google.com,  quic_eberman@quicinc.com,
 rick.p.edgecombe@intel.com, seanjc@google.com,  tabba@google.com,
 thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz, 
 x86@kernel.org, xiaoyao.li@intel.com, zhiquan1.li@intel.com
Date: Thu, 24 Apr 2025 12:19:32 +0200
In-Reply-To: <20250424030858.519-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-04-24 at 3:08, Yan Zhao wrote:
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 4bb140e7f30d..008061734ac5 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -292,13 +292,14 @@ static struct folio *kvm_gmem_get_folio(struct
> inode *inode, pgoff_t index, int
>  	return folio;
>  }
> =20
> -static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t
> start,
> -				      pgoff_t end)
> +static int kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t
> start,
> +				     pgoff_t end, bool need_split)
>  {
>  	bool flush =3D false, found_memslot =3D false;
>  	struct kvm_memory_slot *slot;
>  	struct kvm *kvm =3D gmem->kvm;
>  	unsigned long index;
> +	int ret =3D 0;
> =20
>  	xa_for_each_range(&gmem->bindings, index, slot, start, end -
> 1) {
>  		pgoff_t pgoff =3D slot->gmem.pgoff;
> @@ -319,14 +320,23 @@ static void kvm_gmem_invalidate_begin(struct
> kvm_gmem *gmem, pgoff_t start,
>  			kvm_mmu_invalidate_begin(kvm);
>  		}
> =20
> +		if (need_split) {
> +			ret =3D kvm_split_boundary_leafs(kvm,
> &gfn_range);
> +			if (ret < 0)
> +				goto out;
> +
> +			flush |=3D ret;
> +		}
>  		flush |=3D kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
>  	}
> =20
> +out:
>  	if (flush)
>  		kvm_flush_remote_tlbs(kvm);
> =20
>  	if (found_memslot)
>  		KVM_MMU_UNLOCK(kvm);
> +	return 0;

Should return ret, not 0

