Return-Path: <kvm+bounces-3422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B57804303
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0330E2813C3
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F521A52;
	Tue,  5 Dec 2023 00:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aE63Iudc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1B0FA
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 16:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701734477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=piqqSuejkLyQ9Pz7D5Lal3VWKengn4Yquh06lKaxnuU=;
	b=aE63IudcaBk/pTg+okQJADOE/tlBxENlL4yxOBAa2IsJ236nRncWjqqczSoPc2uOeixlbT
	q6SlRjGMv43Gx1XMoqbc4pyWLGK2HuBL/R+dQtluL2C9ROp8SQ2A+7LL/bZf8q0bxLgA2F
	Skz8M2SrKlA/NKxdpaiGfmktXpBhDZY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-u7VeLtPiP2uttvAu8ad7vw-1; Mon, 04 Dec 2023 19:01:16 -0500
X-MC-Unique: u7VeLtPiP2uttvAu8ad7vw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7b3eb690a44so466507939f.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 16:01:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701734475; x=1702339275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=piqqSuejkLyQ9Pz7D5Lal3VWKengn4Yquh06lKaxnuU=;
        b=WZZfXaq63d6esCtB8C9pCWqJpvFvo0xVWL59RLFPuWjA0yV97xs3Yws2rTyQ98zsSn
         yZf4UxCitv+wukhYlluktoleftY8rKvOsWb9BbnRaOzAWjkuxrmulxxpSwkFgYgoQuPg
         MFITM4h3YEa73y0pg6NuZyiVuPN6C45bRwCR6PAXjiVVHV2HppaldkExhpQD7/+DzSxM
         u8L6QwnN3jbIcWp+VXJ4irxuU91SyxeTy5cdwNP/2hk8w+MS4HINN2y7ImsxIjpUemdp
         3QPOIDYHW6IL3bFKi9PiE87z8IH3G1P36JJmRPXYFX5/hVX6o+X+Kg7pwcxbCs4PObVe
         oz4A==
X-Gm-Message-State: AOJu0YztkI6GM5ga8+QcWIyg0tizHi0t7zPiu1T3WfnAwbUD7mLWXp1B
	zM2W01vimsHI/6WTsaunxSZziybvjwOkmBGBlqlF8nYNbm9XDA/7uYzWPhKg7wQp2v6F8LiHPk2
	xzJNB0yespYY+
X-Received: by 2002:a6b:7f4d:0:b0:7b4:3be1:91ac with SMTP id m13-20020a6b7f4d000000b007b43be191acmr3339960ioq.22.1701734475336;
        Mon, 04 Dec 2023 16:01:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGV4QsoEor/o1mXZFFWnfqE2M4ZJmwBU7oSlYy855J1CQD2NGlbB8584jTohaen0QHRqQmAGA==
X-Received: by 2002:a6b:7f4d:0:b0:7b4:3be1:91ac with SMTP id m13-20020a6b7f4d000000b007b43be191acmr3339949ioq.22.1701734475085;
        Mon, 04 Dec 2023 16:01:15 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id 22-20020a5d9c56000000b007b35043225fsm3092323iof.32.2023.12.04.16.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 16:01:12 -0800 (PST)
Date: Mon, 4 Dec 2023 17:00:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <bcreeley@amd.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v19 0/3] add debugfs to migration driver
Message-ID: <20231204170040.7703f1e1.alex.williamson@redhat.com>
In-Reply-To: <20231106072225.28577-1-liulongfang@huawei.com>
References: <20231106072225.28577-1-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 Nov 2023 15:22:22 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> Add a debugfs function to the migration driver in VFIO to provide
> a step-by-step debugfs information for the migration driver.
> 
> Changes v18 -> v19
> 	maintainers add a patch.
> 
> Changes v17 -> v18
> 	Replace seq_printf() with seq_puts().
> 
> Changes v16 -> v17
> 	Add separate VFIO_DEBUGFS Kconfig entries.
> 
> Changes v15 -> v16
> 	Update the calling order of functions to maintain symmetry
> 
> Changes v14 -> v15
> 	Update the output status value of live migration.
> 
> Changes v13 -> v14
> 	Split the patchset and keep the vfio debugfs frame.
> 
> Changes v12 -> v13
> 	Solve the problem of open and close competition to debugfs.
> 
> Changes v11 -> v12
> 	Update loading conditions of vfio debugfs.
> 
> Changes v10 -> v11
> 	Delete the device restore function in debugfs.
> 
> Changes v9 -> v10
> 	Update the debugfs file of the live migration driver.
> 
> Changes v8 -> v9
> 	Update the debugfs directory structure of vfio.
> 
> Changes v7 -> v8
> 	Add support for platform devices.
> 
> Changes v6 -> v7
> 	Fix some code style issues.
> 
> Changes v5 -> v6
> 	Control the creation of debugfs through the CONFIG_DEBUG_FS.
> 
> Changes v4 -> v5
> 	Remove the newly added vfio_migration_ops and use seq_printf
> 	to optimize the implementation of debugfs.
> 
> Changes v3 -> v4
> 	Change the migration_debug_operate interface to debug_root file.
> 
> Changes v2 -> v3
> 	Extend the debugfs function from hisilicon device to vfio.
> 
> Changes v1 -> v2
> 	Change the registration method of root_debugfs to register
> 	with module initialization. 
> 
> Longfang Liu (3):
>   vfio/migration: Add debugfs to live migration driver
>   Documentation: add debugfs description for vfio
>   MAINTAINERS: Update the maintenance directory of vfio driver
> 
>  Documentation/ABI/testing/debugfs-vfio | 25 +++++++
>  MAINTAINERS                            |  1 +
>  drivers/vfio/Kconfig                   | 10 +++
>  drivers/vfio/Makefile                  |  1 +
>  drivers/vfio/debugfs.c                 | 90 ++++++++++++++++++++++++++
>  drivers/vfio/vfio.h                    | 14 ++++
>  drivers/vfio/vfio_main.c               |  4 ++
>  include/linux/vfio.h                   |  7 ++
>  include/uapi/linux/vfio.h              |  1 +
>  9 files changed, 153 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-vfio
>  create mode 100644 drivers/vfio/debugfs.c
> 

Applied to vfio next branch for v6.8.  I resolved some whitespace
issues and updated the date and kernel release version in the
Documentation as well.  Thanks,

Alex


