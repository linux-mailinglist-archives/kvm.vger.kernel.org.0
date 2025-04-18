Return-Path: <kvm+bounces-43652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 159F0A936EF
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C62527A1141
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17675274FDD;
	Fri, 18 Apr 2025 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kYuliqOH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8E82116EE
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744978687; cv=none; b=A7cjSCPihrdpuyV9uhHMXFcX+6JpTIX39g8wCQsjqKx45TKb47H9mXZLtOBrhDAkAbYWRWfWPiqMuii35xaFIiJNf1pt/sWm1tu0PmW/qGCmUs0xSz3+2IsctcWE8FUDaedTWCI3MU0vJV1iQ/BrHMru4yzQ9eE+zV3QqgjzJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744978687; c=relaxed/simple;
	bh=4jk7QVt4nEFg1SlsP3hvz8KbPKus02m6kD3C19TAsa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSuQ/ejr1F7q5+wVjS3eWgZj4tJ7V6xfH1jZgJ3bcDZDCelh/xiJy/IuJO5mUaeL4d43ulENnAFtEyWuQU6bwmR6UdXc8GqJtTIk3d01CTgopdxaaCmUPO5pzHVDQnuoaVDIrtrR2qiFoMCNLbQ7BQhN94OFuM0mLsNlPqCKVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kYuliqOH; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d439dc0548so5931785ab.3
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 05:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744978683; x=1745583483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NgbC0Ho51LBhNAGrJS6KpfvBsql1IBS8J1NX4yoaH+M=;
        b=kYuliqOHk3mRA4mXePaSY8dgwweD7WW/SC5yc3QV2aDjLvws7kU+ZZHqPe3MbSj74N
         atDSlGOwDBlJMIANHQtGRoQzeqZrJ59sYQ5XXHKQlYpAOa62EyNlMpcK+mt+vqo2K76P
         hq4pSeX2Gt+mwwBXB+Y3Ela4B7P2in6BQBn9c/2MqdF9qt8u50E5enVkZW+WtUG8MkdP
         cuT4L/hku7YnT9DlxtJhXxgYdfW67MiA4s/QQNEvX/gNvTpjGDBzZ+xyLymW6DYLZ5u/
         MSiqOrNr0J5oCxIRyrvXXI9s+Jrff5lxiYZIgsCUY49B1IG0hijoIseUO14Jcdpdtq/2
         a8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744978683; x=1745583483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NgbC0Ho51LBhNAGrJS6KpfvBsql1IBS8J1NX4yoaH+M=;
        b=Gwguiui4aZSLx9piRqIdTigDPynY0NnlH6xU8XoKJbIhY0qRtQXLOtJhk0lZ/KSywU
         GE325XIW3Nuxe9Uh86j/RaN+jnGqgR685t523WzHuj/nvGqDC+/Zh6wnFumsmuo7JhFJ
         T6BMFynLAhQZtk0Txwn2Nu0y/M7EBt5/roNOVEOMB/RADhFJGhom5Z//ZgylLDXkxp9i
         vlLvm+L0I2FW5Gn6tV66R3i+t/SAVVaJiYpuKYMR1gJNTV4FdY9JPZQSwahs57Y1OxNj
         2nB/Y/uTzhoFN+I35OIUz2IXASrCFoONeqwMLZX+SjodXpI2dGuASNENWSpLtGnCVUC3
         CTxA==
X-Forwarded-Encrypted: i=1; AJvYcCVEW1y39mJWmrglvurPNtKMtkoY4JuWVVa+8YM6J0RuH1JEOqU2hw+TvIOLvMqfi0qWk7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxypfuC24HiI6RQR5MyCoSF1qvRQ4WE9VsKknt0bCgk31vNkE8e
	d7fTv8SbLNv07hzJvxexFNWSDOlE8P5c9lBEjC63F4184dBgwxsCVz3K0CXJYTc=
X-Gm-Gg: ASbGncvI4q7IY2Zz938c43CwgVS64qMCDs5L/I/NHZfOF8cfKXTNetrUelmuDxDjBhL
	qXdoOPq3H8lOtPpHZ6RDA0hdqzrE0fIrPVaCxcYVjn3qVXCnzJsqNZoPSXPGDNPfy4HjOYtj0fX
	9IUgnyr0whh7J1Z4HIYncHol6QimdL/5BMhxLuZg+eqsLbMMiKXnflnDRPEQ/JRBfHdUWCvOi8w
	Sg6X2AtN7t+x/ZQ+ks0xAdEzhTiKPHa5dC3Zj5+IHKOReOaXRaPZdo5LDLoxWGnGChUXzd0Ff44
	QAL6/Gbmtzycetvq4DO+McnsXEtGZjJwiuU0MvIQhIQ48MYD
X-Google-Smtp-Source: AGHT+IEcKW8yUly7My6VmHwOUQO6x2LKb/qwvAEzz9JLvNvB2Bo85wGWvtKeixpJ/OLzr9zB/iMeqQ==
X-Received: by 2002:a05:6e02:17cd:b0:3d8:211c:9891 with SMTP id e9e14a558f8ab-3d88ed7c3fcmr25688805ab.2.1744978682766;
        Fri, 18 Apr 2025 05:18:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3957613sm406821173.120.2025.04.18.05.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 05:18:02 -0700 (PDT)
Message-ID: <93ef8629-4040-4773-beac-03c62f848727@kernel.dk>
Date: Fri, 18 Apr 2025 06:18:00 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/24] Provide a new two step DMA mapping API
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>
References: <cover.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/25 12:47 AM, Leon Romanovsky wrote:
> Following recent on site LSF/MM 2025 [1] discussion, the overall
> response was extremely positive with many people expressed their
> desire to see this series merged, so they can base their work on it.
> 
> It includes, but not limited:
>  * Luis's "nvme-pci: breaking the 512 KiB max IO boundary":
>    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
>  * Chuck's NFS conversion to use one structure (bio_vec) for all types
>    of RPC transports:
>    https://lore.kernel.org/all/913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com
>  * Matthew's vision for the world without struct page:
>    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
>  * Confidential computing roadmap from Dan:
>    https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch
> 
> This series is combination of effort of many people who contributed ideas,
> code and testing and I'm gratefully thankful for them.

Since I previously complained about performance regressions from this
series, I re-tested the current code. I no longer see a performance
regression on a AMD EPYC 9754 256 core box, nor on AMD EPYC 7763 128
core box.

Tested-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

