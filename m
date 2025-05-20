Return-Path: <kvm+bounces-47147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B296ABDF4C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 946881BA7A26
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12DF25DB0B;
	Tue, 20 May 2025 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rde3Ghgo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F6D25178D
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747755596; cv=none; b=qCzMh12qRJrL43q3t0SUEIQKv33qmlBBZ45Yg8vqVZbN/syT1iVmV5YIVrs30FXn3nVbsJV6BX0i0RAlYsarF3Pnx/nfXVtKdHpYfvKF3c6OV814k414I/F8HgNQq+8AZ/N65NEe/xhN0elw7WicsVNOzFW+b6RGPdgMTlQYSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747755596; c=relaxed/simple;
	bh=Gp2hypGim6KPCTrYggCBys1rov6/WLmvezT/1tOHcoI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MxSaJIsQ43wCEYV2vQVWuXt14toXwuAMrRIEKd2NEfhBLJ2b3Dfe2oMmmiEfY1BXu0yAbMf0axeVeUDDM7vNx3RBQaEz3HgS2YCA2fe4YFNBIRdofEN+f0RHqMWLMU29akSSPWCvi9pHVXAIVz3pgy623vwo582w/r6KWssY+Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rde3Ghgo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747755593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qgw858aBfnJTsWLcya2ZIZLM65pgyUp/UWTU3v5tX6E=;
	b=Rde3Ghgo0iWe1ePZs0X/WJLS2wRQxw/N+G2reHsFqITVV25KLgeK/JO/xPwsKhUIfKwVZN
	l0eLg6nlbnQkXb9ksNdMsWuU6z0eW5wUpNA0iDmlM4aXxuz4saRn7S8Joyj5nbYg6KAZrX
	fZeNwsL7O6fE/rEAGo5XwkC37lDBssQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-uMwloul2MHGiwrFCzNFajw-1; Tue, 20 May 2025 11:39:51 -0400
X-MC-Unique: uMwloul2MHGiwrFCzNFajw-1
X-Mimecast-MFC-AGG-ID: uMwloul2MHGiwrFCzNFajw_1747755591
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85b46c0e605so86876039f.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:39:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747755591; x=1748360391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qgw858aBfnJTsWLcya2ZIZLM65pgyUp/UWTU3v5tX6E=;
        b=ONTzBwe8HKKATdKEFwHG5aSvS2RdKW6MlmlV0J4fIMEuTmxRmlakvncLINfAMgtkck
         DYGAyRiBNyER8APQiaKebhtg3cXJyXeDKP0mdH+JDMnX1HykTsHF+BJKuwJFAqKTG1SH
         UwnI1QYt1dCzUEsTAFurNfCX0Z5uDaMFyf7HZQHI0CGYCcqJzhoUwWb2Rksi79Tnl9GY
         v7hdJNDOdeeRcsJ17X0hpgyG2FLxtM32tJoTCtwmXxCWd40T12ET0grbgnEdhrzhXHSW
         DeZIt/OLsuH55npZU/p/ToID4lZ8o+P3zqnEOLi1P65Yph0LZ2kXZSdeJWFcW2VTRnoy
         Ezqw==
X-Forwarded-Encrypted: i=1; AJvYcCU0MRF3fmDPCrj3hhTcppyMC77CfevC5APrVV/zZLKXrkXYyknx42M8MQK5QFvFnGg3/0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw05iimM+tShguPSsg1WaVnP3UoGCkEt+8KI+Uf9mNlCzXiKp0E
	NQ/ivQeLdMQBz+LZ4GGNi9gLOx+DalYR3CY/7oobFfV/50I/CQCX4AGswOVU8gpJpreT6XZZQpZ
	IGYFUtJCqpoBT4a460Q4z+skAbBtijVRptC4P8MCElwpTpLdpVpfheA==
X-Gm-Gg: ASbGnctHd/rLhz4aKoMgefQ7ekcV15b7Xf/dgdvWxdZr+mini+g+RYb5wr7F1tgmTyb
	3McgJdogQOAR82otuNss9pqotFXNPo2oLU3DTaZu9icYqEM+pCQ1qq/P0/M9VOzTD8+sNbPSjaS
	hWNDjlGzKDxQS0Sg1L/3uyDmSflp3u9Y5Urku8JGsr5itJpbPZvkfyD79ReXY4bN5fHTzJGvD/G
	GSVVazRw2gj+tS7J9ZmwA7fRKvECRh4fhOVWFAKi+LeXrEPkEmh93MREgGHHL8LL+8ODSFRL4gZ
	wmQxlV7Ntyg79uk=
X-Received: by 2002:a05:6e02:3810:b0:3dc:787f:2bce with SMTP id e9e14a558f8ab-3dc787f2eb9mr15376425ab.2.1747755591082;
        Tue, 20 May 2025 08:39:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwOHbonV8qiSQBLnfXYbx9Prhpc3EL9LanZ3fzLOv7nzBzsY/s+c9jTUwTOnix05087SeCPw==
X-Received: by 2002:a05:6e02:3810:b0:3dc:787f:2bce with SMTP id e9e14a558f8ab-3dc787f2eb9mr15376255ab.2.1747755590555;
        Tue, 20 May 2025 08:39:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b19aasm2276374173.52.2025.05.20.08.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 08:39:49 -0700 (PDT)
Date: Tue, 20 May 2025 09:39:48 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v8 0/6] bugfix some driver issues
Message-ID: <20250520093948.7885dbe0.alex.williamson@redhat.com>
In-Reply-To: <20250510081155.55840-1-liulongfang@huawei.com>
References: <20250510081155.55840-1-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 May 2025 16:11:49 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> As the test scenarios for the live migration function become
> more and more extensive. Some previously undiscovered driver
> issues were found.
> Update and fix through this patchset.
> 
> Change v7 -> v8
> 	Handle the return value of sub-functions.
> 
> Change v6 -> v7
> 	Update function return values.
> 
> Change v5 -> v6
> 	Remove redundant vf_qm_state status checks.
> 
> Change v4 -> v5
> 	Update version matching strategy
> 
> Change v3 -> v4
> 	Modify version matching scheme
> 
> Change v2 -> v3
> 	Modify the magic digital field segment
> 
> Change v1 -> v2
> 	Add fixes line for patch comment
> 
> Longfang Liu (6):
>   hisi_acc_vfio_pci: fix XQE dma address error
>   hisi_acc_vfio_pci: add eq and aeq interruption restore
>   hisi_acc_vfio_pci: bugfix cache write-back issue
>   hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
>   hisi_acc_vfio_pci: bugfix live migration function without VF device
>     driver
>   hisi_acc_vfio_pci: update function return values.
> 
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 121 +++++++++++++-----
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 +-
>  2 files changed, 101 insertions(+), 34 deletions(-)
> 

Applied to vfio next branch for v6.16.  Thanks,

Alex


