Return-Path: <kvm+bounces-38554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75731A3B3FA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 09:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4089B188DB86
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 08:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C061C68A6;
	Wed, 19 Feb 2025 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdVJB5Un"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82A1C5F29
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953922; cv=none; b=AcLJbF4dJtRDUP9FhxEulVQ65NLTRkT82mS1BPMbUG4zIjOEorNpjcJRM5W+EczIjao9itV+BLNQw5YoHUKWODBA4T/nSIrH8b/XM/I4MfpTcyhB4Y8n9bhHerivIyC9tzbc+JoLEgiyIFCHNdKLGApkh/rN676TMGIwgoGeujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953922; c=relaxed/simple;
	bh=UhnxOOWMxBvGlatftTNDMWcxd2JI+FJKndrlJr1K0X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgS+0v2tSx4WvmmOsMRqfvKn3y1WryF7MkkHL0f/bUthtCvwiFScc1FemLCMKKubpZIsrxkJlB+072ruwLjjQZ4yEF5UM0N1s6fRMLSAKQvHd2hSfEEQXCdSFlOu8iApKA74xrA0SsU4X1oWf9FbM7fD7Uu/+jsstzM9BY7iv4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GdVJB5Un; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739953915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4JbRdqdYJQdJMppsYc3IVc1lHy5Cz2pY+l6GdpwErAU=;
	b=GdVJB5UnwpertiSqmtRWwTKnGy1AOEqkx2PmiwvuasDWQpLQq/MLpr7ulegQBNjwDvvqHL
	10Smxi6M4mxiTrlepoX0tPPAXcAiAfKzPk+BphTGpCA4JWp7zKviTTE3rH5YES20danuR1
	rJDHlAnecNd8bbtkY7k6Wl98tZTU39U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-la6A6ROAMYO-5Kyl0p62jA-1; Wed, 19 Feb 2025 03:31:52 -0500
X-MC-Unique: la6A6ROAMYO-5Kyl0p62jA-1
X-Mimecast-MFC-AGG-ID: la6A6ROAMYO-5Kyl0p62jA_1739953911
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38f455a8e43so1389830f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:31:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739953911; x=1740558711;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4JbRdqdYJQdJMppsYc3IVc1lHy5Cz2pY+l6GdpwErAU=;
        b=mE8tU37xaCq+27/U1NuWSgQYAEEu+Ajc8/SuMnRl9G9qvrtkmI3gIJlE59VxFwp7zT
         139SsRbjQG2pY2HJa+olP9sIReZqbAqm4Xp1KXsMcNEra5qCJepZN870nVOGsgU7YZyM
         uYe+KA9YOxoF+FxlnCg4crbu2vZBwM7kjjmpgkhA2sn/ibSlr+ESOCKWBhr85l24HsFj
         i4fvycZxSzDjSZEYUmyroZuWwSN6GOYpfcAk/mCfJQNLY13vmnOFmYG0LRMwjyO2Lvuy
         urYq7jgvfyNZisgwa/ElgV38uIAkj97xPSkYDnPblT59c8pdb3W8UujHppjk13eSHDwo
         ctaw==
X-Gm-Message-State: AOJu0YxS+exzKU75fgUMtNN+KQyJXvdDgbdHABc+cozj6eA2itlfTZNw
	WI70gLKLQ8mjfWnDcK9FCoCK6TgsAkeEd3vAzmi3Gx0d1zC+VFTd09VVMfEEJMt6e3uF0/9Xz9D
	smKblyOYYUfm+6LIprXoaeFdwyoOVbak0/wWLpCVVTAS0bxjPnIanVAAf1fYF
X-Gm-Gg: ASbGncu8YJG4imTO1TbeYRS01swkSXmFv1BpoXdoBFYLPbmFwsgT+4jgLG4uHXp0gzt
	OtpJs5jVfMLZKuQK6WuoyVimdGnPVwf73Zdi3ZnRn2k/+UOtMM/x7zucSU4mb5emonh8Y6InPvG
	5Hn0j5RUKr0bCt3lyXVCY+QTsyar6KMjtGMvcPuhruaZRkLtpdfADMo3WTMx5zNn0iJuAtopKB2
	FqQO+b/HSU0kEIueOwifsFhPiGPQEdoHZvKk/dkdyiUb9mV48rGs0bq3LgE3Qmry94/AIuryZAg
	bFkUfaOCQpSc0fHXfI+fKx/Tjf4JKF5jcJY=
X-Received: by 2002:adf:ee92:0:b0:387:8752:5691 with SMTP id ffacd0b85a97d-38f34171107mr11521951f8f.47.1739953911496;
        Wed, 19 Feb 2025 00:31:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFK2yPpWvl6gawDQ+6Z/O1hl+oXMmm08C5dns5ahFLa2iCT5uUa7byqQ4lD2sIg9VRBudkicA==
X-Received: by 2002:adf:ee92:0:b0:387:8752:5691 with SMTP id ffacd0b85a97d-38f34171107mr11521934f8f.47.1739953911145;
        Wed, 19 Feb 2025 00:31:51 -0800 (PST)
Received: from [192.168.3.141] (p5b0c68c8.dip0.t-ipconnect.de. [91.12.104.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258dcf08sm17434852f8f.36.2025.02.19.00.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 00:31:50 -0800 (PST)
Message-ID: <3d1315ab-ba94-46c2-8dbf-ef26454f7007@redhat.com>
Date: Wed, 19 Feb 2025 09:31:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: Provide address mask in struct
 follow_pfnmap_args
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
 akpm@linux-foundation.org, linux-mm@kvack.org
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-6-alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250218222209.1382449-6-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.02.25 23:22, Alex Williamson wrote:
> follow_pfnmap_start() walks the page table for a given address and
> fills out the struct follow_pfnmap_args in pfnmap_args_setup().
> The address mask of the page table level is already provided to this
> latter function for calculating the pfn.  This address mask can also
> be useful for the caller to determine the extent of the contiguous
> mapping.
> 
> For example, vfio-pci now supports huge_fault for pfnmaps and is able
> to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
> PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
> for a contiguous pfn range.  Providing the mapping address mask allows
> us to skip the extent of the mapping level.  Assuming a 1GB pud level
> and 4KB page size, iterations are reduced by a factor of 256K.  In wall
> clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


