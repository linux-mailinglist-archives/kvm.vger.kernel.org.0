Return-Path: <kvm+bounces-2523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 360387FA8A0
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 19:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 450ADB211DE
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 18:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F523C46E;
	Mon, 27 Nov 2023 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="htlwdGbO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A14019B
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 10:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701108535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbaYTtWJWKS2KvLXYln8ZZMnxtzCOD7lAAgVJfHHtZo=;
	b=htlwdGbOXQLaAxrKRuQusqZtxcBRtETWbrcNzAj/MZp5Y5YDTD8Tk+0E7nNdDdZoSKFlvD
	lMnTI4jtOyfFlcUiWQWeuEcyZBkidK1oEEahdlM9zkh2gg8fi+SxpLN1wbaBdijaUt0gZM
	BDYemy+PgcqVie/SYEBVRJH8Ch5D5Og=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-v_qYN5K6PTWFu7f0_wcZ6g-1; Mon, 27 Nov 2023 13:08:54 -0500
X-MC-Unique: v_qYN5K6PTWFu7f0_wcZ6g-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6d63f6a5abcso4971468a34.2
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 10:08:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701108533; x=1701713333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbaYTtWJWKS2KvLXYln8ZZMnxtzCOD7lAAgVJfHHtZo=;
        b=XHJqfQ1w+7gswM+7vO4QohiBmK2HzDIe+unz/xX7Sae4o+tQS1kyde6ZbkiNhhxGBO
         4afOSQenOIQTTIdjbvB/IRFr2Gaw+91EecAqUzR8MGXL7laCAYjN0uuVs4Zfnam205Nf
         s7xHIkELKT86eXSP3hXAjRU4anqG9fVYW36XmwpHTfpJDnlmI/iU4WOoIP940fu0Bq3h
         UDLWlRSl0anwLGvcKJnQRQ5abZBhbOV9ESCW2rpIu/fpD2eU2HPXK+Kyy5pXbJkw7G9j
         QhdJxlu7zFEiYt9xmJIdYE/j9r7x0oQVIJ/N/wv1iiw7AsCZ1NU7nJeyFPw5oFE0Hp0v
         FeaQ==
X-Gm-Message-State: AOJu0YwCIBJVp4vyYDcdBIiII4M+oZ/ZgsmiRXtf4h9uKxmGWansw3ho
	JT0KOPlnXY5d7E9LCg8fcR4whOW3SnRUax1UdTO3Vjkv6cQRzHsIEzcgtqAkDCgQ5Rx2KSz7uJN
	ZDMaHHgC9Ko93
X-Received: by 2002:a05:6870:55c9:b0:1fa:25de:2f6b with SMTP id qk9-20020a05687055c900b001fa25de2f6bmr8707398oac.23.1701108533458;
        Mon, 27 Nov 2023 10:08:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRy9elN/20CfXFz7tM/XZvEAQYE1oTnRgPx0meubDa212Hw6esHglbJqNzyGPKQ8N6pOMFVg==
X-Received: by 2002:a05:6870:55c9:b0:1fa:25de:2f6b with SMTP id qk9-20020a05687055c900b001fa25de2f6bmr8707374oac.23.1701108533094;
        Mon, 27 Nov 2023 10:08:53 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id pu2-20020a0568709e8200b001fa38179d1bsm1039033oab.56.2023.11.27.10.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 10:08:52 -0800 (PST)
Date: Mon, 27 Nov 2023 11:08:50 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <shannon.nelson@amd.com>
Subject: Re: [PATCH v4 vfio 0/2] vfio/pds: Fixes for locking bugs
Message-ID: <20231127110850.3e4f527a.alex.williamson@redhat.com>
In-Reply-To: <20231122192532.25791-1-brett.creeley@amd.com>
References: <20231122192532.25791-1-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Nov 2023 11:25:30 -0800
Brett Creeley <brett.creeley@amd.com> wrote:

> This series contains fixes for locking bugs in the recently introduced
> pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
> at:
> 
> https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
> 
> However, more locking bugs were found when looking into the previously
> mentioned issue. So, all fixes are included in this series.
> 
> v4:
> - Drop patch 1/3 since it added a spinlock_init that was later replaced
>   by a mutex_init anyway
> 
> v3:
> https://lore.kernel.org/kvm/20231027223651.36047-1-brett.creeley@amd.com/
> - Change reset lock from spinlock to mutex
> 
> v2:
> https://lore.kernel.org/kvm/20231011230115.35719-1-brett.creeley@amd.com/
> - Trim the OOPs in the patch commit messages
> - Rework patch 3/3 to only unlock the spinlock once
> - Destroy the state_mutex in the driver specific vfio_device_ops.release
>   callback
> 
> v1:
> https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/
> 
> Brett Creeley (2):
>   vfio/pds: Fix mutex lock->magic != lock warning
>   vfio/pds: Fix possible sleep while in atomic context
> 
>  drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
>  drivers/vfio/pci/pds/vfio_dev.c | 30 +++++++++++++++++++++---------
>  drivers/vfio/pci/pds/vfio_dev.h |  2 +-
>  3 files changed, 24 insertions(+), 12 deletions(-)
> 

Applied to vfio for-linus branch for v6.7.  Thanks,

Alex


