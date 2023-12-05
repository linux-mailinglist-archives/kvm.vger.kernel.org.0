Return-Path: <kvm+bounces-3421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B74804301
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DB71F2138C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28EE38F;
	Tue,  5 Dec 2023 00:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L30hPDlA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4411F0
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 16:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701734474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93s1ELgfxstgbB9hpuLBR3wLORjWDRcMjxyeQXV1qHs=;
	b=L30hPDlAyzQ5/4jPlkBwPwo+C35s6VyL8ADUi4UuceQ8TyEaR2LzLhqOXGspd8vAMhk8So
	V5dOkUnCsNZE7XN+Nytz3V/61133NagABHoAfjO9OCtgsU4ntG/6XICUBOvMuQhdubnfX8
	qBebl+Sf/2ITVpQFvm5dW0Bhlz8oXas=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-KCi1KeinNZ23Af0scI8ChA-1; Mon, 04 Dec 2023 19:01:12 -0500
X-MC-Unique: KCi1KeinNZ23Af0scI8ChA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7b37d04d83aso417394039f.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 16:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701734472; x=1702339272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93s1ELgfxstgbB9hpuLBR3wLORjWDRcMjxyeQXV1qHs=;
        b=aD2SNVCfSGkvmygXZkwc98kB2sQ4PB74F0wZqSbkqbEpL+66gsf+VYE9YEzbV/1xxA
         4gf/vDYaHH8QYs/docKLcZj+V5K7jqoNUuSMrYTh+FxOWqKWt2Q9NDmiTG4GqCtafOHz
         YM0y1Y5kEGaQ++/ZcMFxHeXhYz3nadxuQR/Spiajo8YMIkcmDiz++7WLvcv6vYX8/C9F
         YqySGH9kSs8xFafJ5m5nvXU6h/pzs5C2szVu0n4jMvJ37f2pAKEmBci5ExuKcwodcSPj
         ZRdolCEIU8t3NlbwcyO/4qUL6bCsycC7q03M5Zvge/lkYd7XUdgE5SfD4ROnbH+uxL7T
         QoOQ==
X-Gm-Message-State: AOJu0YyH8IBcmcDD6qM2ScRQOxjx5ic0yGkOwKJprXhv47fHv7ZL6lWO
	iINYlxPyT/nmJuWWYxyX32K3Ff9e9UNVZZOXDk1JkRlrJcm3lszUZ9jygR7lwM8NCok+fpOgoFL
	9Ee9BLU1kZI8J
X-Received: by 2002:a6b:ef16:0:b0:7b3:989f:ee57 with SMTP id k22-20020a6bef16000000b007b3989fee57mr4464352ioh.7.1701734472031;
        Mon, 04 Dec 2023 16:01:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnJuHCFrwbwVhh2Pq5VkbCt1npgoQecLnLIdP8jj6eymRP8pW+byzWrwnNKbCScAQq4L60Hg==
X-Received: by 2002:a6b:ef16:0:b0:7b3:989f:ee57 with SMTP id k22-20020a6bef16000000b007b3989fee57mr4464338ioh.7.1701734471701;
        Mon, 04 Dec 2023 16:01:11 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id 22-20020a5d9c56000000b007b35043225fsm3092323iof.32.2023.12.04.16.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 16:01:10 -0800 (PST)
Date: Mon, 4 Dec 2023 17:00:48 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <shannon.nelson@amd.com>
Subject: Re: [PATCH v2 vfio 0/6] vfio/pds: Clean-ups and multi-region
 support
Message-ID: <20231204170048.232760ee.alex.williamson@redhat.com>
In-Reply-To: <20231117001207.2793-1-brett.creeley@amd.com>
References: <20231117001207.2793-1-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Nov 2023 16:12:01 -0800
Brett Creeley <brett.creeley@amd.com> wrote:

> This series contains various clean-ups, improvements, and support
> for multiple dirty tracking regions. The majority of clean-up and
> improvements are in preparation for the last patch in the series,
> which adds support for multiple dirty tracking regions.
> 
> Changes:
> 
> v2:
> - Make use of BITS_PER_BYTE #define
> - Use C99 style for loops
> - Fix subject line to use vfio/pds instead of pds-vfio-pci
> - Separate out some calculation fixes into another patch
>   so it can be backported to 6.6-stable
> - Fix bounds check in pds_vfio_get_region()
> 
> v1:
> https://lore.kernel.org/kvm/20231114210129.34318-1-brett.creeley@amd.com/T/
> 
> Brett Creeley (6):
>   vfio/pds: Fix calculations in pds_vfio_dirty_sync
>   vfio/pds: Only use a single SGL for both seq and ack
>   vfio/pds: Move and rename region specific info
>   vfio/pds: Pass region info to relevant functions
>   vfio/pds: Move seq/ack bitmaps into region struct
>   vfio/pds: Add multi-region support
> 
>  drivers/vfio/pci/pds/dirty.c | 309 ++++++++++++++++++++++-------------
>  drivers/vfio/pci/pds/dirty.h |  18 +-
>  2 files changed, 204 insertions(+), 123 deletions(-)
> 

Applied to vfio next branch for v6.8.  Thanks,

Alex


