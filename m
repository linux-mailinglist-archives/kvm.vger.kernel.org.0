Return-Path: <kvm+bounces-37250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D3CA277FE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D075F1881544
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48772215F54;
	Tue,  4 Feb 2025 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrB7sdOo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38F2153E3
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738689006; cv=none; b=i0iggcmTwAHqXPFymXoLEOGo5EmPjktFPyhYF8gmJhRFKLbP85xI8E+4mgp3PVl9XR28rpgWFZZ2qmLPtWGmg5mQuoAzCKJNhNnamiRUbqCdKsU4OdAQm4aUpvsEyeZyCTwTpPpWg2ltwUzZncgp7ynC/A55NRYYAzrYiLxyV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738689006; c=relaxed/simple;
	bh=aVdUf/jirZqzieIHKHookQNKvH1vSUgrLR/ENBo03zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSRzyFIMFa55sMciyn7G64xcuob4jum2OTXHYLEOOrCWE26LnhmPg0Npxt4M60N7hgLcENC7ywumYtLgsa4nrHzodh15JbpaM4j9SEt3/bkwCyOVy+iXr6n6qO/fFn8og7Zzk95E/oi9U1FfDbO5Pq2n0jyFU6KVOUVyG0SeZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CrB7sdOo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738689003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVCjVJKRa6rCGzbxsVtoaTu9+R8rthqeY0TG7PHLpqo=;
	b=CrB7sdOoJ7XZQ46lbsJClGfSjO9POcfVKT09panwRrCO6k4b+2agCloynQD7qDTYiGPKcW
	kB4rXyatgQ9nHyV44/OV8ICcXI5Pqj1hgYEpyT0XOiHpnfimK11frqqXIZeRZdA6PHqsXo
	nQdTDqWYd4lntAahKYDRoM3f72zOoc8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-k0Mo1iK-P8SfEg5Hczb2ig-1; Tue, 04 Feb 2025 12:10:02 -0500
X-MC-Unique: k0Mo1iK-P8SfEg5Hczb2ig-1
X-Mimecast-MFC-AGG-ID: k0Mo1iK-P8SfEg5Hczb2ig
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6ebe1ab63so1599016485a.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:10:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738689002; x=1739293802;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVCjVJKRa6rCGzbxsVtoaTu9+R8rthqeY0TG7PHLpqo=;
        b=KWI3jrVEugNjyR9qwHOi2aNlJJ69G0MzMCha51kzalhNj/F3BtIOqkofr448pymMQQ
         bDVLpXrKvIAM3Ih2d2A29FQiDcQlYuo2iSVUy/+gTeMbRgkZfVcQ2sJq9491zMS4c9Fi
         zEpC6LUSLsNnpinOpkKvuO38DVojexPc4aQGfR9IlNH1Sl3PVkBIObxMAePdrfQQC1nK
         6LmvTXslvF7bc5WUyJz1agQLfjWAOIrmNjom6odoNn6/xzj7tjbat3XQvqrptrTKSVQT
         /9vfivhyoXzGz5dC82OAZCaGRv2lf2Y1q2uKjZ7+WR2fYSFYZT3zdt5/0mOvHqzTdUwz
         mJSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlgtQ11IhCd9Z3t5QxPnp9MnlqxaTKPg0bHfvc40oYPOwJ59rx+oAuCSnyt/PtvcUErZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUn9UnfIbmp68C9Y47oeT8wKE2f/nXttnEWPma0dkVt740tsVk
	8p6ILH9ERjnnBNiAX9VJD8KVThSAnD58NTroHeK9S8x1DzQCimj/A585bitG4Xd0caycZQD+MZH
	PKgPARZ9WmiNk6ehjF1RtmPxQgNEY5oBhyioEoNtcyuxVLHYHaQ==
X-Gm-Gg: ASbGnctW9ixENYYBYG/16uxFteIFrDCdhrYVNbHull8IsgfNqW5QUvycjG+2vCcC/at
	xq6pZJnA2pzeSEFprG9zi32b2uyhKSMVKUPYqeEBjqvscWCa0bgJ1KBiF0xASPlmT6atzByvB8f
	QwDls/YlvrdEmwnYP0oEsf1XpD3s39tNMT0l+yjDgJvB8zchYSX27rmHW+/UNPr42ZXfjUhfuZC
	IIX/b4DW0sb+3z+CFzAUL1ek1Yh7CT/tz0PFs549BDgT2vzPkZxDFpmJLDxZ/HhIAo3hkvNzQeN
	irkPR7Ix5M0DocsFAJmt8b13ckfm+3lM8EXN8IWtUBMKxsjm
X-Received: by 2002:a05:620a:2b43:b0:7b6:773f:4bd9 with SMTP id af79cd13be357-7bffcd72656mr4004062685a.42.1738689001898;
        Tue, 04 Feb 2025 09:10:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEC4lE0HJi92BGr28xSeI4M1nJBeQd9vtedvuNpDv0EWzjAYwIvs6C+dMvku0kr8+woH+SH8w==
X-Received: by 2002:a05:620a:2b43:b0:7b6:773f:4bd9 with SMTP id af79cd13be357-7bffcd72656mr4004058785a.42.1738689001642;
        Tue, 04 Feb 2025 09:10:01 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a906518sm655190085a.84.2025.02.04.09.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 09:10:01 -0800 (PST)
Date: Tue, 4 Feb 2025 12:09:59 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?=E2=80=9CWilliam?= Roche <william.roche@oracle.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 1/6] system/physmem: handle hugetlb correctly in
 qemu_ram_remap()
Message-ID: <Z6JJ5wapMy7PAhwO@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-2-william.roche@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250201095726.3768796-2-william.roche@oracle.com>

On Sat, Feb 01, 2025 at 09:57:21AM +0000, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> The list of hwpoison pages used to remap the memory on reset
> is based on the backend real page size.
> To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
> hugetlb page; hugetlb pages cannot be partially mapped.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


