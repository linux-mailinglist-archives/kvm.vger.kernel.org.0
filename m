Return-Path: <kvm+bounces-52341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E113B04333
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 17:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49D824E185D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1227725C82E;
	Mon, 14 Jul 2025 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1XPcjUy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C56246BB6
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505982; cv=none; b=XCG5e/liEeUSYpGEfbRfn4xbgkI2zk8j7TzQ6MwfsSv3sCOcLt2YR7uZEigvupanK/VSGd4NKpz20uagX/zlmLTyzDFxXSYoSROGKkarKjEBbWxc/wpHCLEDDgWMNsnLeQknnIXtos5IrLA+XaaECnF7nxIwVICSRKNZLQFiii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505982; c=relaxed/simple;
	bh=wq3jkDXmL2kbDR8yLPZKxT4RkHzlMSQh4F6k/stG0gE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUZenHhvDUpJP6FlmL+j5rGUkpBBy7vOEFGyQTDxxng6PsOREJA6hsfIGStqozqcACcqQaYjEOWPyA26IOE+c7i7yW8035jQ11SpUack/Jhvw26MohB67WenWNt8EpphAfoCY72pZ84x5Nwed7/b+IX3luDSsL/Wz+EspH8dBXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1XPcjUy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752505979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAuWLDvGONYS4aGI3o9+xx7hOflsVGv3mSCNJ1rkux4=;
	b=e1XPcjUycwHqcVBnMuTCDORZnjuUpcE24raCFN8dV9cDQfyaFobcxGNRYnenyw2QHF+0C+
	nHnJhXWCmz53EpluEOMk7PDjvCSyi5sPF27fL+M1wdDHfk3U2RqBiyS0ambjDWhngb8ezj
	DS2zBMUQ8qMw4rgfaitLhuATIQ2NBtk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-boog__mpMcq9rkb9Pp3YTw-1; Mon, 14 Jul 2025 11:12:58 -0400
X-MC-Unique: boog__mpMcq9rkb9Pp3YTw-1
X-Mimecast-MFC-AGG-ID: boog__mpMcq9rkb9Pp3YTw_1752505977
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3df359a108bso7869275ab.3
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505976; x=1753110776;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UAuWLDvGONYS4aGI3o9+xx7hOflsVGv3mSCNJ1rkux4=;
        b=mx0LC6OTxaHQaPaCz/HT5S03MYTGGRUwnDgTIQBjwMm5zwEjmUV69/RShBKUOSGwPX
         1UQ/qk/VLqjCBHyhW7OWtN2DJZmZK4dpGM1duHULnnfkCrqX1I9uAszAKg9yR9Stk6lO
         IeKb97NLwNFqOQ+ECQQ9hhyPd1EdM9DMeKq7WyOglZrs4vN5aYDUe3lqvMVkQOTQaWuX
         7a7cxxoTFA32XRkSvV32KtV9jmzAHGxArcBukQpw2eD7V47HWgFb9jk3gtetq2HvrA+6
         q0avQG8mAKkhuk/aMA0zI7eG6hcaCsghhOp3i5vyr+Dhb3GigbwfaDQV04RfFPWfbQo3
         t6sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZsE7wAW9Id2I+Ec4bPrzPaciUBdBgICrmi+dglHsOOEWmN7YiL9mQq+PU1oph4P1gWC8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy76uca8XnFfVknkm+UFzYauq6pIfWycvVnPJvVYbuHrVpdNOoJ
	3KIgbUEarabfOfNqpUG/XOPF1WpjnRyUns0WkAPWGOWwF6o+KVonXhDdJdt15noSTxVF5+h//Hu
	o6vAoGNs7lXwC7mc4ydDxTXkarZ81La5gepCCvABMvIqNSNIxkKe7iUgVfP/5xg==
X-Gm-Gg: ASbGncuWbukGIGAK6NrZVHTzPPj2zSHXp/1X3tcrNC/UtRdxEKASkTsKbFa7D/QVP1t
	vir0OJswGjZOS8PUP9sZNKGq4HlSRwW84CXc3fKHCs3hduKTllAlvMZzRNjmnfKkjQY58ANneC8
	VOpo8HOCQepWzAbuDqaEUxSmalSu7HCanWSnspmQADxXeluqdC+hswXa/ieBnGhhGC110RlDs48
	wFnZDHqdWb7BbYkXLACC+ScBUoK49+YqSjt2tBWwrlE25eyOkLZGaBV0UogprLjswBGpPxb8AYg
	zyb7136tINcrKQRbsK9HBMxVwiQSDz5s1eOh8PqcHWk=
X-Received: by 2002:a05:6e02:3083:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3e2543f45a2mr42634965ab.6.1752505976225;
        Mon, 14 Jul 2025 08:12:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQWWnsQP46KCBBDLLmrvxRjBMZE+wrW8uiPq3ltdhzNoM6uXIgiwf7w6/nI+O/Wf1S85BaBQ==
X-Received: by 2002:a05:6e02:3083:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3e2543f45a2mr42634705ab.6.1752505975706;
        Mon, 14 Jul 2025 08:12:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556970df3sm2049358173.90.2025.07.14.08.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 08:12:54 -0700 (PDT)
Date: Mon, 14 Jul 2025 09:12:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>, Brett
 Creeley <brett.creeley@amd.com>, Giovanni Cabiddu
 <giovanni.cabiddu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
 qat-linux@intel.com, virtualization@lists.linux.dev, Xin Zeng
 <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Terrence Xu
 <terrence.xu@intel.com>, Yanting Jiang <yanting.jiang@intel.com>, Zhenzhong
 Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250714091252.118a4638.alex.williamson@redhat.com>
In-Reply-To: <20250714142904.GA2059966@nvidia.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
	<a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
	<20250714142904.GA2059966@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 11:29:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jul 14, 2025 at 09:12:30PM +0800, Yi Liu wrote:
> > On 2025/7/10 23:30, Jason Gunthorpe wrote:  
> > > This was missed during the initial implementation. The VFIO PCI encodes
> > > the vf_token inside the device name when opening the device from the group
> > > FD, something like:
> > > 
> > >    "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > > 
> > > This is used to control access to a VF unless there is co-ordination with
> > > the owner of the PF.
> > > 
> > > Since we no longer have a device name, pass the token directly through
> > > VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> > > VFIO_DEVICE_BIND_TOKEN.  
> > 
> > two nits though I think the code is clear enough :)
> > 
> > s/Since we no longer have a device name/Since we no longer have a device
> > name in the device cdev path/
> > 
> > s/VFIO_DEVICE_BIND_TOKEN/VFIO_DEVICE_BIND_FLAG_TOKEN/  
> 
> Alex, can you fix this when applying the v3 version?

Hmm, where's this v3 version?  Did you already send a version with
Shameer's fix (s/bind.argsz/user_size)?  Lore can't find it.  Thanks,

Alex


