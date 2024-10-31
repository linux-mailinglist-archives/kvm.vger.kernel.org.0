Return-Path: <kvm+bounces-30261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888BF9B85E7
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B47A282978
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972311D0F7E;
	Thu, 31 Oct 2024 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0i7SD/K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A231CEAD5
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 22:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412605; cv=none; b=MZEBUiq/JFOdkf5kWH8qUI+SnXfdrGg/pC4oVj5OVstNon2K69B0tMVFkH8cEISwslDkOOxK6hZrncRY5AwbeW81q3xBWg1MkKTjZwpu6IWO5i+BhKP7sD0xL71qpXhzvUd+1ZsjwSaCRcBf953Ll6HRVdVKc6Vz2R8l+2qsryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412605; c=relaxed/simple;
	bh=9jy7OKH5Gw4DyEdcwI9/11CnAl9Znm8UsxuOcfs9oDY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HeceVTHYcwNNurJKBIEfophyUaxsLDFAWhQOrNgzEEWOvar29gzjp3siYWEzkBEG17wZUeu3vK6mCSvQ016wgLhsPZ+cD0YGSdv3ODssw7lUGbe8ILVDU3x2yKN8Nbmeuunlwo5Hx0Eq7Pqj2ooI/Or0dTQ+LOok84dUK+Ehxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0i7SD/K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730412598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdTjHkCcsfnnKS2t3sdvmvU/eSjQzYm9Ho2FZ+8bgBM=;
	b=d0i7SD/KIs3GK/YyoqJoFRvw/MhNKQsrOvzT7vvvnsACVLeaxiagxvL58SBCUpr1cLRwBP
	JUlldLR/mb2cqETkjTewe7iREWT5UtHM7QcOfK4n4+lYovRIKfrS6hXU/bW76XzKf8K/p8
	H14C9ssE4CaBcUg2Z42qvzu0LvmGts0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-gmwX7qdLN7OOXjZOK5S58w-1; Thu, 31 Oct 2024 18:09:55 -0400
X-MC-Unique: gmwX7qdLN7OOXjZOK5S58w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4dc12d939so2314625ab.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 15:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412595; x=1731017395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdTjHkCcsfnnKS2t3sdvmvU/eSjQzYm9Ho2FZ+8bgBM=;
        b=oPnG+Zwo8o2c53JK48NXA8wm1QHRFMDihgrLqizYVCAVS3VligpxXLBX8lYRiCe3Ex
         uPlb0MfAGrU2AKAl68xCEREGeYqd1AYHfyU6QOVkhsDPGXzyUkhnuFRKs87BOSUWGmO9
         Saut6BDHxI8hjYakYJA/jCOpTq9GeYJoS0fmGK4JMaWXzkrl2dGbLV0kAoMGkDJVe1tG
         1NEWGQfcqr+44OBQxILF35HyXMHdxDNQB0iWcMtr/5Bz+XglQZKkmskqXVcGR6dGq6x9
         +YV1L1QXsEFiltvmYZen1qVc/gR91jLzS+rdcpdsN0Qv0YbIHxvGrmQuUMeoEg+y7Yxh
         ANlg==
X-Forwarded-Encrypted: i=1; AJvYcCX0UIDQtu30kCjz39+AZ9RoP++wA4JNw8tJZ93oG+f+7CprhRGuFJt7MK1I687Yfb197PA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnWGo1oaFZFCErs97oQpEWujCDKFQ6/pt7Cp/ZwwoklDY5vFH4
	v8XVtzdW7NMwCvRmCDTTo2igXPi9o6UKzMdx4aNxrnwpwKSYqHMAtWq12DshI906OJoA18slVsv
	fDxtDY7/K4BLUeZgRnsVZiH91h2AV9EIzIo2wNrvCV07jvSwPaA==
X-Received: by 2002:a05:6e02:1aa8:b0:3a0:9c77:526d with SMTP id e9e14a558f8ab-3a4ed28374dmr53647065ab.2.1730412594744;
        Thu, 31 Oct 2024 15:09:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHes6NcyeGK9ZmJwopYOsZWbir4fr/Y/edup6IPaveMm0NTJdKZw7jSWysnUlNcfO2TCoircQ==
X-Received: by 2002:a05:6e02:1aa8:b0:3a0:9c77:526d with SMTP id e9e14a558f8ab-3a4ed28374dmr53647005ab.2.1730412594307;
        Thu, 31 Oct 2024 15:09:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de04977d7esm460341173.99.2024.10.31.15.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 15:09:53 -0700 (PDT)
Date: Thu, 31 Oct 2024 16:09:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v11 4/4] Documentation: add debugfs description for hisi
 migration
Message-ID: <20241031160952.3b93d4af.alex.williamson@redhat.com>
In-Reply-To: <20241025090143.64472-5-liulongfang@huawei.com>
References: <20241025090143.64472-1-liulongfang@huawei.com>
	<20241025090143.64472-5-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Oct 2024 17:01:43 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
> 
> Update the file paths that need to be maintained in MAINTAINERS
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
> 
> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
> new file mode 100644
> index 000000000000..89e4fde5ec6a
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
> @@ -0,0 +1,25 @@
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
> +Date:		Oct 2024
> +KernelVersion:  6.12

We're currently targeting v6.13, which is likely Jan 2025.  Thanks,

Alex

> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the configuration data and some status data
> +		required for device live migration. These data include device
> +		status data, queue configuration data, some task configuration
> +		data and device attribute data. The output format of the data
> +		is defined by the live migration driver.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
> +Date:		Oct 2024
> +KernelVersion:  6.12
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the data from the last completed live migration.
> +		This data includes the same device status data as in "dev_data".
> +		The migf_data is the dev_data that is migrated.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
> +Date:		Oct 2024
> +KernelVersion:  6.12
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Used to obtain the device command sending and receiving
> +		channel status. Returns failure or success logs based on the
> +		results.


