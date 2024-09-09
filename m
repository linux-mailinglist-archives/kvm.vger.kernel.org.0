Return-Path: <kvm+bounces-26129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C9C971D6D
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301681C2349A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CF018EB1;
	Mon,  9 Sep 2024 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQbbyUpF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EA83FC2
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725894197; cv=none; b=sFVD83XIqx/KICIkVu0Zcsrv4CRvIl78OlfoVunlcKclJLOnJz/hN7cPrm/OxhkpGLzj/acYXX64fShBxZET4LUqslKnTZ+NAro7j3zsbttIJzZjLLta1uyg5p6uBBp7W2OqD0MgDdeszjNkWk499OjDQ4AweeOCvJXb406WFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725894197; c=relaxed/simple;
	bh=L0M1mffjiRIPOCuH2OrIjQfgVOyprWyp9psV4eYNvAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZWsMKDJlLz+eVRaDhHLrhXb97xwj2tEXTpoMjRLt60+9vJjYs53JF+QbxNFDEJkJ8JxyYsKhnTrft1QHL9umrEWqw3cHUIIcVcb5cMtxgZvlc4LvRPnfOeu0D4cyWnG4Z2gudakBuhUROpm7aQvdbl1wgWCm4JskMqxtUI7icU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQbbyUpF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725894194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6l+xHNqXTthDlFZ3K9cVgVJ/sPPZ9HvpzFqB6gZQUko=;
	b=LQbbyUpFJd+q7CoGR6j3DlhyRxOTue2ivwpPKveSWJJjFe5lFqArSjzUnPKoeiE0soqWe3
	TeuOUx/Oar7EUiQF8AVQFbSBs0Iq1LdoLHjhX9zE8RjncEPBzB/9JxyVhti6UowBGC50sk
	KtxYlQuEPtzOte27JE1/AUuSLff1pzQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-8F_3ZG15OEy_vrY6dSoEtQ-1; Mon, 09 Sep 2024 11:03:13 -0400
X-MC-Unique: 8F_3ZG15OEy_vrY6dSoEtQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6c353a05885so47254396d6.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 08:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725894193; x=1726498993;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6l+xHNqXTthDlFZ3K9cVgVJ/sPPZ9HvpzFqB6gZQUko=;
        b=mrCB6p4oG17xAwgyiij7zGFPE9QZkf8AGZi/ZMNnt4eodcdOA6/5m9agOxzZ8TLpnc
         ptkI5VMqeoXpVzjvBryhOItv46l3T88FdkiaWpqq5FKiL0QtHQywC61buvVqRjmbAF1P
         Dc7CVP1ay5gM7MUgBMQE4Lrc4g5PZ5LbpOAI1O6Chponkizt7lEiNVK7stKnL0DYZ/Hb
         WYTIFCgfKbieStgpcDb5q5aQXa3/ngrh7B+Qzvefw1z9/+IHqsPZLQt6Q3du7AP4sKU6
         /bDF9nDCJ49ofDigC9of+GLEpUUCKmsdI3MzT5CQHzHQUPUeU366KrXq0oNC0qniSdxh
         wqFA==
X-Forwarded-Encrypted: i=1; AJvYcCVCP7iw53SefUVvCxd/KRRo3jbiTg8QhLGiLIJSrjnOes8FB/YPqekPwr5+zigeE3gl2L0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhjgy3JwrxymmHDeb9lAdSRq8RzD9iqRfihiOhAyqogIwSCH0b
	FiuxZGoV3dBnmhyokv9uFzCATaLKaZKwXBL3m67WOMsbaJUXZtqgUs47l65QfsPDHoocig/4+bO
	N+AzSmZAcTiM9/JMn+HYrXOEtylJ06/w/CqgrQgvrZn19v6d3CA==
X-Received: by 2002:a05:6214:5b84:b0:6c3:5789:62f8 with SMTP id 6a1803df08f44-6c5323fe2b4mr100989326d6.19.1725894193161;
        Mon, 09 Sep 2024 08:03:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXyNgnw3o/IQrxRWaaUJgRseDSr7DTlug9i0O8HD+tnUNFFXmzQMuc9otVGIFfDiIY6ds48Q==
X-Received: by 2002:a05:6214:5b84:b0:6c3:5789:62f8 with SMTP id 6a1803df08f44-6c5323fe2b4mr100988886d6.19.1725894192696;
        Mon, 09 Sep 2024 08:03:12 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c53432dfb8sm21272326d6.24.2024.09.09.08.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 08:03:12 -0700 (PDT)
Date: Mon, 9 Sep 2024 11:03:09 -0400
From: Peter Xu <peterx@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <Zt8OLSI3e3K8tFpU@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <SA1PR12MB7199DE6F9F63EEAD93F66249B0992@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB7199DE6F9F63EEAD93F66249B0992@SA1PR12MB7199.namprd12.prod.outlook.com>

On Mon, Sep 09, 2024 at 04:03:55AM +0000, Ankit Agrawal wrote:
> > More architectures / More page sizes
> > ------------------------------------
> > 
> > Currently only x86_64 (2M+1G) and arm64 (2M) are supported.  There seems to
> > have plan to support arm64 1G later on top of this series [2].
> > 
> > Any arch will need to first support THP / THP_1G, then provide a special
> > bit in pmds/puds to support huge pfnmaps.
> 
> Just to confirm, would this also not support 512M for 64K pages on aarch64
> with special PMD? Or am I missing something?

I don't think it's properly tested yet, but logically it should be
supported indeed, as here what matters is "pmd/pud", not the explicit size
that it uses.

> 
> > remap_pfn_range() support
> > -------------------------
> > 
> > Currently, remap_pfn_range() still only maps PTEs.  With the new option,
> > remap_pfn_range() can logically start to inject either PMDs or PUDs when
> > the alignment requirements match on the VAs.
> >
> > When the support is there, it should be able to silently benefit all
> > drivers that is using remap_pfn_range() in its mmap() handler on better TLB
> > hit rate and overall faster MMIO accesses similar to processor on hugepages.
> 
> Does Peter or other folks know of an ongoing effort/patches to extend
> remap_pfn_range() to use this?

Not away of any from my side.

Thanks,

-- 
Peter Xu


