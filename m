Return-Path: <kvm+bounces-68409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C10D38948
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:34:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 839553079EDA
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513EA313E24;
	Fri, 16 Jan 2026 22:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uLjDx/UI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684BE288530
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 22:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602826; cv=none; b=BpLkUyucBtLbPp8DFBxrrTgl8utbidhJMu9ScpAZ7ZfnQYXwL7URbkzFIQX46CGuPkr4A6DBRFBuK33HCAnWDWN0ybwk2mtpNl/HtwpRuytLS6uiVYnI4NYjZDqv+4csstU7QEmlYB2QKZUl4tG1+SbrayMJrSJAyn8Zp6iS0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602826; c=relaxed/simple;
	bh=7eJDuDaRU4HEnFjD8M5xCWB8csrNTe+bMKyIlAUEPvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdHZcK9ym9gB3pIyCv/G+JX3KqAQrv8UKdLsMrAIlreSOb60SV8e7o7FHQm0bHt1F2m8ifLOo3juPiQ6SIo1+Z+n2JTyjKJfNQqHjby3d0GN35/JOcHOMyHfEbLbANVOs58LWnJIoNQwucWI6zDg/N/ePuUnyzWj3YBuUKOyqRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uLjDx/UI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a081c163b0so14527225ad.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 14:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768602825; x=1769207625; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOMjigGknPXeAyP77SuRzqAAm/mO2t7w32/ztq/sln8=;
        b=uLjDx/UIvhhO0lkiZqk4zzfxdsA/Qq74jN86NfhO52juO43p6BEDO+lkeBeeAQofdy
         Dgbrvu48LZgCPqzYjgjmZ7AocXbWGSVkc7/OS4h0hFHB3nvNBuwQVWVkY9GKdOfLS+KV
         d28WaqQO4PL5EKLzsmYHYvrp/uWqFmQTgwE9pOHMkG48URIkGUp0w9ysteRmp5NmU2ZK
         66Oqvt5HDthwszlvJCuXhCT3RWy2PooyFnF6Hmpp7qjQ+0n54m3m5kC9lReP+OHIFAFU
         ZJSl5ho0Bz3qw+Ltf/zqFrsya9R8PfHGMREnF98i5y9o8aWcOJs0PLHMkfGNbnnR8JZw
         cHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768602825; x=1769207625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rOMjigGknPXeAyP77SuRzqAAm/mO2t7w32/ztq/sln8=;
        b=XjZgPJY9LI1f1AzIn6NNH6KthDNJ/eqt8inNO8XRwTIOS0cmbYX5rIM0l8HjbO2oPI
         2OOtmE3ed3d0IwNTRI2Ik0X+iHA0o6KG5qnMgttBo0J79FUz6A5F6sninVj9oblx9feE
         na3eS7DhPaE90K3tTUUqTSQGetwXgmO7cKzjkzcvpXuZEW3QxqLY/ecCAhFuOtRgJB1N
         lh7+39Xw9oNJnOIlGjqGSJ5NzG3E7wZ6rSI8FD8wztFln8SnQLRfApt72FWl8CDiLRXx
         hIRfYjBjOAo+1Wp926oxjvrWFTA/gxsqUXHkcnUzyryosWEXTawxo3asOHEEgOjFFAUx
         z7bg==
X-Forwarded-Encrypted: i=1; AJvYcCUS6BECkeggXvRsDMvX4ELX9wDyi+UxD5HNrmz+3wBweUrCIoEr/9RAM4pnoQD5/h/f3Vw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5rQ8HVAbq3eTtR8uuTqptcqUDV3heZqy9gmCB2s/SjFPRWwBN
	KJtxOZHOF9Rk/u7d655PJ7BJ+LPWJVRDLuKD8tp+72uzIbh+S4Kcxh9wG2kkrzRts/wXNE3BBxc
	d2BKa9g==
X-Gm-Gg: AY/fxX5GjhNDdBVcX2yMHV0vDdhvPlWt3uoSoZr6eW1DO6hABFyKyfICt6CfzZ9ra3r
	0sqkoDpsUfhQnHguiO2JBMZAOUSLnc5ApV/Q/AP+JqCvl/4sILTme1Fy8f6UAzpJI0/p7lrdzdG
	Sx8P7GEEaR9PM0E1H7tXywa1BMvBEs/jCHQkyuobT+l19SUiOGyO9/y/V+Scl1nVHUIP5rjpjr/
	H7XzmhSFj20Pt8FJ9otp2aNx8exnMiTMLB/CRHWLswn6ul3hby7atxBUm3FmxKuc3uHucyP8pNo
	zNfeTMIHxvA2tbs3iLiVArhatj+Khu9gbMo7JFCD0AtACkwQ/jNzaruh8RK4NcuXNpY6LpQPYQU
	2p9S4nLtFVqvmiFtR47rY9CzYGdexk51CDYiYbZzYLfVZORTWraVH1t+XBKGbA8Z/M92vmojTxE
	H7aMcyJtKznk1ZdEiv5ZSeKk/ytUZ89x/LICZvvaCEKI+durah8Y5szIVr33qo
X-Received: by 2002:a17:903:3846:b0:2a5:8c1c:744f with SMTP id d9443c01a7336-2a7177ce31cmr41826535ad.40.1768602824591;
        Fri, 16 Jan 2026 14:33:44 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941c088sm29731605ad.91.2026.01.16.14.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:33:42 -0800 (PST)
Date: Fri, 16 Jan 2026 22:33:38 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 0/3] vfio: selftests: Add MMIO DMA mapping test
Message-ID: <aWq8woXQ1E6XO9tA@google.com>
References: <20260114-map-mmio-test-v3-0-44e036d95e64@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114-map-mmio-test-v3-0-44e036d95e64@fb.com>

On 2026-01-14 10:57 AM, Alex Mastro wrote:
> Test IOMMU mapping the BAR mmaps created during vfio_pci_device_setup().
> 
> All IOMMU modes are tested: vfio_type1 variants are expected to succeed,
> while non-type1 modes are expected to fail. iommufd compat mode can be
> updated to expect success once kernel support lands. Native iommufd will
> not support mapping vaddrs backed by MMIO (it will support dma-buf based
> MMIO mapping instead).
> 
> Changes in v3:
> - Rename mmap_aligned() to mmap_reserve()
> - Reorder variable declarations for reverse-fir-tree style
> - Update patch 2 commit message to mention MADV_HUGEPAGE and MAP_FILE
> - Move BAR size check into map_partial_bar test only
> - Link to v2: https://lore.kernel.org/r/20260113-map-mmio-test-v2-0-e6d34f09c0bb@fb.com
> 
> Changes in v2:
> - Split into patch series
> - Factor out mmap_reserve() for vaddr alignment
> - Align BAR mmaps to improve hugepage IOMMU mapping efficiency
> - Centralize MODE_* string definitions
> - Add is_power_of_2() assertion for BAR size
> - Simplify align calculation to min(size, 1G)
> - Add map_bar_misaligned test case
> - Link to v1: https://lore.kernel.org/all/20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>

Reviewed-by: David Matlack <dmatlack@google.com>
Tested-by: David Matlack <dmatlack@google.com>

