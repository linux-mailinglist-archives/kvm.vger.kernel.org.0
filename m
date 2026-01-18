Return-Path: <kvm+bounces-68447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC37D39830
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 17:58:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C537300E034
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 16:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB7C23EAB4;
	Sun, 18 Jan 2026 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lvF1EtfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C931416A395
	for <kvm@vger.kernel.org>; Sun, 18 Jan 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768755510; cv=none; b=aATjRGLcm6vppHLIVUU5d3LlvK7gLv58qF9zWy3Q+Ih9Mwv9ZxE9udb/l4NQBPoZUTcEdqWOXCnO1Lvqy6diyueIKV8mFZZtxee3s2Mmb4qJCEowiIafEhovk7mtCn+HkC2TZW7NJSItfX42wtIQvkLbscauY1zI0RVUH+XVuN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768755510; c=relaxed/simple;
	bh=0zgzcjV2i1ItPBygPoRVnUl5OQb076Xxb+6J+rVvyEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMqIsPb+LOcAUTv8UBjD6c4t877Xbz/sRaumAhNb5G1swEVgSi5gmAy/6qelRBavWXlWW/ySvfMMzlbBB3M+eoL8bevoReedikrzGecDXlJLJG2z/vOzv5E1dkz/nfZEFxgCNstboGpz6afRSsv0X6RQfB+gqVrs+CyL+LhYU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lvF1EtfY; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7cfd6f321b5so2114919a34.2
        for <kvm@vger.kernel.org>; Sun, 18 Jan 2026 08:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768755507; x=1769360307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bv4mJ1WA5PkVw1gpZVpA4eWj7mOEd86WM3sQnHXBrw8=;
        b=lvF1EtfYc+IJun7o9rp8joLoIoRv+4+tCQsAwgov1ZqZU4K+KI5fIeYnyDpG63J8gv
         EG1Ok3jiHh7pHuRMxZFnGi8Ofo4KtCILti56fxsaD/iM2y/nU7XkbRA/kpef8bPMwRQV
         jDZbcD/GwECo9HL+zVmvTRVGxkgT14YptjwKGVrmY4L8Fg4OXYIH5phySH8CCB3GD8Gb
         Yise6X4N49bQW6ZqjHcCp8mpEXrVoCxCJFvfJi6kiZAcoPD8AHBc6eM8IzJTm3whnaA5
         8D5Fspq2qs2cw6YSipeF1AvHIWJ61vPrDGbr+A+/KNUdyGOvR0yzYSv1tX/N7LVmeoGL
         v2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768755507; x=1769360307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bv4mJ1WA5PkVw1gpZVpA4eWj7mOEd86WM3sQnHXBrw8=;
        b=dXjzqssiEBbA8IOi9h+tQhUQlRnUGYg59Vvnw+r71zBDlXdVwmq8/Aol5gf0tMbY8F
         xBMai5q+MliS4Uktp0nJIRM+cAiMAM05nTCxSLiBlkGZLIvDsXyp5N+VWaQeZXzZ7Vnx
         sNjmzw6bzinL/RjZ+L4O0f4l8Ppt66mIAxgwZa4RoI0BfIz9L3tJjNo5278byjs9X1xV
         Cqt9+sO1ZnHyucmbkVuTBBSdTENub3BGhL00Z3zYz4MGTJ1k026I0qdDAvp+Mw/tmKMs
         CZTX4VsxZkVHlmVTdvxQMEpDja4mOBVP9aw/D9MSaAhOasWflZManO7lthUN/ilHqlBi
         U6rg==
X-Forwarded-Encrypted: i=1; AJvYcCUtVgt7iXpoRQVTnhogkMwO9WOjlIT2uEhfzmpxlFqGO8PT62XcBUWCkUPHPffYpAxlSvk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh+eK8AnXu/s/C5m9Pl7lY36J6U/bx6UKib3TPFRUaB0vmEhS1
	cUIkKHaRH/qxw1RRcfFhXIFOhPtvGnbWLmMnPFj58FpWD7gebnB7r2kLBkziERufah4=
X-Gm-Gg: AY/fxX4SzGBL6zDWb07Hw/O2NKRMc0q9iLEy6ZjZ/2kD+RxuOlWdR18xBQxovTwe0xS
	sizKpSE8Ax6RKK1/zG4b4CCvi68EEZxmLHBWUT6TYd/FzHk0J1zoFtSaJE10v58YlYblQwbowt9
	evyJzaKZPQ7CBvcUW/9wm5lFaJnr+bHLrGctNgVzIf91K5ljGkbcc2NIin95znmhGqmU4zayytM
	pqqGQoVwKQqwljDdmEHjz2zANn5kCH+Xpnbdz9jx7UAiO7z56zpZVaax/a+xZGjfk65iO1V5iJA
	O0zzJHDw3QXHWpZ4h1Yag0XOUe1HOPZSV1hAjjeMtAEFx3ZURdtDB2d7Aj40XFCtfFDhKq+Afm/
	ePrzzwz6u5PegWD9DbzU4eMX2CeU6LAkK8OCaVE1nb5n+AJjULd5nKgzy7AaOOUsvycr2+92xGZ
	SFfYh6b4NOlSdUV49owhxmkK+Y4xalHuPB3ghwlDu1iaKBjsvW37fUJIsdaA7Ag7bG7hZ43A==
X-Received: by 2002:a05:6830:3156:b0:7cf:d213:7ecf with SMTP id 46e09a7af769-7cfdee7a81amr4387364a34.32.1768755506711;
        Sun, 18 Jan 2026 08:58:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0efe41sm5290925a34.11.2026.01.18.08.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 08:58:26 -0800 (PST)
Message-ID: <184b3699-1eb6-4701-b827-47b34e997af2@kernel.dk>
Date: Sun, 18 Jan 2026 09:58:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_types=3A_reuse_common_phys=5Fvec_type_instead_of_DM?=
 =?UTF-8?Q?ABUF_open=E2=80=91coded_variant?=
To: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Ankit Agrawal
 <ankita@nvidia.com>, Matthew Wilcox <willy@infradead.org>
References: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>
 <20260114121819.GB10680@unreal> <20260116101455.45e39650@shazbot.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260116101455.45e39650@shazbot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/26 10:14 AM, Alex Williamson wrote:
> On Wed, 14 Jan 2026 14:18:19 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
>> On Wed, Jan 07, 2026 at 11:14:14AM +0200, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> After commit fcf463b92a08 ("types: move phys_vec definition to common header"),
>>> we can use the shared phys_vec type instead of the DMABUF?specific
>>> dma_buf_phys_vec, which duplicated the same structure and semantics.
>>>
>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>> ---
>>> Alex,
>>>
>>> According to diffstat, VFIO is the subsystem with the largest set of changes,
>>> so it would be great if you could take it through your tree.
>>>
>>> The series is based on the for-7.0/blk-pvec shared branch from Jens:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-7.0/blk-pvec
>>>
>>> Thanks
>>> ---  
>>
>> Alex,
>>
>> Could you please move this patch forward? We have the RDMA series [1] that
>> depends on this rename, and I would like to base it on the shared branch.
>>
>> [1] https://lore.kernel.org/all/20260108-dmabuf-export-v1-0-6d47d46580d3@nvidia.com/
> 
> I tried to ping Jens regarding why the branch with this code hasn't
> been merged into their for-next branch, maybe you have more traction.
> Thanks,

I get a lot of emails, and pings inside existing series don't always get
seen... Usually better to do a forward for a ping, then it's a lot more
likely to get seen sooner.

-- 
Jens Axboe

