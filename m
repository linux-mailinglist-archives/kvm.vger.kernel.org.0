Return-Path: <kvm+bounces-52654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E60AB07BB6
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F9381C40D89
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA2A2F549E;
	Wed, 16 Jul 2025 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGW2SqND"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4D42F5C3B
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685239; cv=none; b=enigQD3w101ZVXDMeTfYSWzfuCErEDqLNCDyV9GMKoL4vDmP7HG/LWXa0n0Er6A9tIj0pH1Xc5/6GJ7TPaoKrwKllwURIqcl3zAYUcE+oHowbdlVBy0fxPFk9R1wdZoF2z1NUV3iOMLChmG8ii9VhnOc5YsZoYZdPPnZpwWZM7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685239; c=relaxed/simple;
	bh=VT2e/D8TNHzCkI96xQbHOMePD40bqojitO9TYfZwJRU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9vlC68YLW3GK9m78Q+5d08U6ertMparZ56tDeqV7qdrHDKHDAC9rsV5YtqwiK3+PAB8ArWref83Dj1nhxbvJB/K8l9mQikX54nIHMKheWrgvxqNvfSf0AgOBzGk3NCS6CwEGahTZPlt6ZwXfuCpi1UypFpzq7NqYf+yx9Dlp6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGW2SqND; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752685232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9bKE/0cNtoQ/CuczzprbbV3beLrr2MpjH/0TxwAvYDI=;
	b=EGW2SqNDS+bbvfZeAe7m0XkeSE/5InZp+3e8Cm9971xBLykYMr0Id2ZKD6lhZf2L14cb7E
	m/7j21puwycBSAL1z5yPa+WPPIcNV7qCtSSmndOl4e2MIfmaQBvEJL0v9ZDdhcEouARXw7
	N1R7nTs676nXIO0KAIF44/eoIk4Gb3s=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-FySZuf4qOCmx7oQo4rtb6Q-1; Wed, 16 Jul 2025 13:00:31 -0400
X-MC-Unique: FySZuf4qOCmx7oQo4rtb6Q-1
X-Mimecast-MFC-AGG-ID: FySZuf4qOCmx7oQo4rtb6Q_1752685230
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-87333a93bd9so39039f.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 10:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685230; x=1753290030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bKE/0cNtoQ/CuczzprbbV3beLrr2MpjH/0TxwAvYDI=;
        b=g4/LeOxeX3SdGdkDZfAjz6SiiGdbyAfSwnxkSehyzBEDqjYbiM556Nwlz5AB8Sbhnx
         do2w0LEvnjoBf1chXI69JlK206f1HdViPaPwtJQIdfn7UlwGTH//oIH1QbPPJzb4ZB6s
         HjBPky9gme3Iic0kMRzJeJnSsFgJGnBlauR/qjMBf3rUzlPcjEAEVLOvWatgK1QSCHEO
         BT603WUVeqyLiuoNkE4cqRBeJaIqmL5Z+jRyFm6fyH5l3lfeARmLsH3yagqvdsvERdOP
         afZT1XWghQWdWPFWO+KM+o64dQv3pR4iWhlnRhG5Rxfr0fPZdJJSEqItLV881Zo2Xf39
         S1pg==
X-Forwarded-Encrypted: i=1; AJvYcCWfvqRXHp104IGxSglLHFBQDi7ib1YOt/cD3Bbea07Wx3TnEOUA0GVE3AmVmkVSvin2QYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6OyxXO4wRrIRgxBXdaTbzxe++z6zUIMv0N6KxwgE7MwNK08in
	kB/6PBvtW4TZe9sQjh1+LxSoZBuXUBr3yiJVuSjRBMPu/KvptEjsenKhdCOzmykH4UkwcGKlEzC
	ChVIWqimyC3lqlGnS7ZzF6/jZVw05GDoyWmgY6sO3z/KawwaldKxqSA==
X-Gm-Gg: ASbGncsmTiY4Tk1F8xVbGML7XgezxBLkLFupJ7RRwlRo0RqZEUWLUiRiLsGKR5UteZs
	gS6qUlI84lOyXBlZW3NoJtO47v1oDNKpaewIZzDWfQe1IhGZINrKFj/eWk9mQWMnGCAJv+rPs4d
	tCaP+CM6MVvWevL/Q+euQRdcv7Pa7JjqZp3pf+95zYNA3+ws+2JwKPbQajqGjY5OS8APRAzpr/G
	vVx4gELN4Kviq6XaxCjvMjBdNkOr2BVSBNevNIsyBeXbjnqaiIlXA+WW5VRakbpMzYYTw2OUBB4
	AFwN/xgCtwQ+FZ5sKA3iA91puorU/3pTqbrxn2Qklpo=
X-Received: by 2002:a05:6602:1690:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879c096efeamr126747839f.5.1752685229889;
        Wed, 16 Jul 2025 10:00:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+tZmWUIYwitvuBgGnxfswO12NMpp8mD2icMHkWg5+YtIZRRU8sqVvx4qLf0KrRuHgGBPToA==
X-Received: by 2002:a05:6602:1690:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879c096efeamr126745539f.5.1752685229362;
        Wed, 16 Jul 2025 10:00:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569d0e42sm3119302173.101.2025.07.16.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 10:00:28 -0700 (PDT)
Date: Wed, 16 Jul 2025 11:00:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 Ankit Agrawal <ankita@nvidia.com>, Brett Creeley <brett.creeley@amd.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, Longfang Liu
 <liulongfang@huawei.com>, qat-linux@intel.com, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, virtualization@lists.linux.dev, Xin
 Zeng <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250716110027.7e94129f.alex.williamson@redhat.com>
In-Reply-To: <20250715230618.GV2067380@nvidia.com>
References: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
	<76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
	<20250715230618.GV2067380@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Jul 2025 20:06:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jul 16, 2025 at 01:55:45AM +0300, Dan Carpenter wrote:
> > 5fcc26969a164e Yi Liu          2023-07-18  117  	mutex_lock(&device->dev_set->lock);
> > 5fcc26969a164e Yi Liu          2023-07-18  118  	/* one device cannot be bound twice */
> > 5fcc26969a164e Yi Liu          2023-07-18  119  	if (df->access_granted) {
> > 5fcc26969a164e Yi Liu          2023-07-18  120  		ret = -EINVAL;
> > 5fcc26969a164e Yi Liu          2023-07-18  121  		goto out_unlock;
> > 5fcc26969a164e Yi Liu          2023-07-18  122  	}
> > 5fcc26969a164e Yi Liu          2023-07-18  123  
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14  124  	ret = vfio_df_check_token(device, &bind);
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14  125  	if (ret)
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14 @126  		return ret;
> > 
> > This needs to be a goto unlock.  
> 
> Oop yes, thank you
> 
> Alex can you fix it up when applying?

Yes, I'll apply with:

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 53a602563f00..480cac3a0c27 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -123,7 +123,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 
 	ret = vfio_df_check_token(device, &bind);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
 	if (IS_ERR(df->iommufd)) {


