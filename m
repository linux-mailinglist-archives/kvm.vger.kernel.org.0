Return-Path: <kvm+bounces-29927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B615D9B43BD
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9E081C21494
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E312036F2;
	Tue, 29 Oct 2024 08:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ng0mueca"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEAD201246
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 08:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730189165; cv=none; b=VjhclQYX0cUJAF/04QGiP4mlx1zXlhK7J6/omA2e3B2UovCddhOkkX24KYE9q9Fw/wN6mOov/6JFLkJGUS9uG3x+9+woNdBb00v44EzTCwe25OqcRiAMGHph7AVjPlpPK1GV304sxFbqQex/RSL2Mks3iDK8AyQbdSVtWBGca88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730189165; c=relaxed/simple;
	bh=ewE5C91VqIEclE8EE6eSORF2urCUiFplqwhKVbQgjUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t5l86HLtla1gHKaNKHoITqKk8hiRZTuzTVFgWC2qKUfvj+RPcRLpur2J6ZoBOEpCNxRuUPUw4GvaW6502ZEoeFKQAcQoGW8LYSbMMP2hrfp1Mkr4YeXICGiVeQocgzy6H5y3jhbCaAGfUivvAkAkjvod0nrRQl1Eyj6nN6UJbmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ng0mueca; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f1292a9bso5985309e87.2
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 01:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730189162; x=1730793962; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpKc/KqpX5HtlgfK6Baua5GTCTYuIvnrrTfwnIfrUok=;
        b=ng0muecaB4itgqGZeduwNimjnEtrTW8EnQKfOWQ+3IsMLY13VQFjlQQLoZeg1wyKV8
         Hg62Hc1A66mKP5rvTGvayBqJigoAeHge/iV2hdBLXoSCU6B/3bS5ou2HCRbrLzh5JxjR
         8idQyF3n7Dp1Bjq+x4oMXKLhqPPAQ/MH402vMsrn2M6sPnFnAIsvrVPrjskPo3yaMM4H
         22jErb64/NZUzpfQkd/NuIbFYAidSKStI2z+ToGs/0zhUhHdqat+8H2jZTToDvnMMC/C
         MNFatU4D9UxTT8jsukEeaiAyOObVaj+fnxGi8C5ktMlWAPUnHM6Ib2zId6tpiuX9WDrA
         tzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730189162; x=1730793962;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZpKc/KqpX5HtlgfK6Baua5GTCTYuIvnrrTfwnIfrUok=;
        b=UARRki6CYQjc02kujBqVsc2Mo6iuHxZ6MU4lh68acZKwLIEwxqaw3TX6NE9Tq5sduM
         jB1x4RDGxZxmuGwH5hjiiRFCKV6cDKhB9u1BNbmIV9IOHVBg/vnckm7vGzr94zpTQNOA
         OCRt9J+thaSGp+Ic50uy1KpbL2XxtsigZh4SLvhcmkYmzoEw3fCXSHbVT1yWiobq6WYA
         wuLp8RucxVgnmPrGD9ioYa0n0mOx+PmW32vc9NhBAjC04z58m86x93/aLTLji39UFGnU
         84B+ckVpTlMHVWotxBle/D2WXznoADcdKt2V3/S2RaeQKbM2ZnW5p4owWIRMBI3Vx+kL
         SQLA==
X-Forwarded-Encrypted: i=1; AJvYcCUnE+zthIaBfOqK0nRSO9vdClBOG+phbBB5dTuAlVl32cvtoTBVUM13TDIfU+pF1a8oahY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRa9lmH5MEL9G8eQx5UToRrL3nvuetPw/WKf4Hwxbw3JKmEhiX
	uVhfU4QsqfdoDFuFqBAb2XiLS4Ocq6+kXkZswXIbQcIrQjqLPE693vkMntq17tSwL9c/2KouR//
	EMTMBIjWIzz1xr5M/EcsW50eFNJaclN/ylhuzjd7SPBYiR4ncjtSDwv2dU4z7dQ==
X-Google-Smtp-Source: AGHT+IFdMeju8u+bLvoWRylkETprLuQWVbYwdSt0OlbdfpFshotvbQALRsmdDmsdtxr9Bkka0/GgKYmryi5IgB6xkZk=
X-Received: by 2002:a05:6512:39ce:b0:539:fc86:ce38 with SMTP id
 2adb3069b0e04-53b34c35b65mr4163098e87.60.1730189161784; Tue, 29 Oct 2024
 01:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HN4VnL04EbadWh9cQf+YpTzvscvXBdHY8nte6CW8RVvg@mail.gmail.com> <b7f79653-4bfd-42f6-a641-479d2973190f@intel.com>
In-Reply-To: <b7f79653-4bfd-42f6-a641-479d2973190f@intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Tue, 29 Oct 2024 16:05:50 +0800
Message-ID: <CABQgh9H8LJstiwDon3=e2uMruVwCS9AyGutcct6WyMODSo5=AA@mail.gmail.com>
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Yi Liu <yi.l.liu@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Oct 2024 at 10:48, Yi Liu <yi.l.liu@intel.com> wrote:
>
> On 2024/10/29 10:35, Zhangfei Gao wrote:
> > VFIO migration is not supported in kernel
>
> do you have a vfio-pci-xxx driver that suits your device? Looks
> like your case failed when checking the VFIO_DEVICE_FEATURE_GET |
> VFIO_DEVICE_FEATURE_MIGRATION via VFIO_DEVICE_FEATURE.

Thanks Yi for the guidance.

Yes,
ioctl VFIO_DEVICE_FEATURE  with VFIO_DEVICE_FEATURE_MIGRATION fails.
Since
if (!device->mig_ops)
    return -ENOTTY;

Now drivers/vfio/pci/vfio_pci.c is used, without mig_ops.
Looks like I have to use other devices like
drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c, still in check.

Thanks Yi.

