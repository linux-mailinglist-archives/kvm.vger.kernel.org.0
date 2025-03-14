Return-Path: <kvm+bounces-41072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD63A61405
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 932C43BFCB4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E082010E3;
	Fri, 14 Mar 2025 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e9bkylei"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCF01FF7BB
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741963708; cv=none; b=KQFPiAzOgybxLQhOhh/0/+hNq8fD/aTLCPQUqHYEtLEf2YHVT7LL0GEPSPdl9S7cqFl0eC8wj0LbRhfWrqH6q3K6qf4bWtsSJ2yyxQCjzPGc7ActPjaj9QRwyuLCo7baBKms18/Yuk1JvvXBXUwb4P0zbCnpUj9z9FoccLqF7gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741963708; c=relaxed/simple;
	bh=AxZCEgDggaThJawcb274lrza9l/Ka1paShEZneTzReA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bctvlhWReTGwxDph99AWE3ypoeDdn+NgJFuPTrlRu+CyO91m7WfSP9yWCsxCD+eGzyCdcBONAcxJjaRDDKnbEnyYQpNWieFKj/Y2Ny/aruLBTyffa3WrvVO5HgFeY4muP+B+TUad7msIj+k/iL+gFtUYiL/vML3fLsDOywE8ZcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e9bkylei; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741963705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9NEmY1/3EX+C0jP6fbQDXPtdDIUrIk5k8tCSlroRrI=;
	b=e9bkyleimzcyijcu7t+GK34ePsxZc7f92goAdRwZ2tqWhfF55d2J3VNr/ZQMfk0jsOaK+I
	Xkp1Jx0vscmyx+20YvB+xHhCClDFtjp6hAm25Ek4SvN1iFuIYf7/7IP3aiyUBeApUUHx4q
	1E2nTj93GVAuF0QKcU+nx2cIgA9M3sk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-NpZuFgr6MnuHecDRj1BwEg-1; Fri, 14 Mar 2025 10:48:24 -0400
X-MC-Unique: NpZuFgr6MnuHecDRj1BwEg-1
X-Mimecast-MFC-AGG-ID: NpZuFgr6MnuHecDRj1BwEg_1741963703
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce7aa85930so4385415ab.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 07:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741963703; x=1742568503;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I9NEmY1/3EX+C0jP6fbQDXPtdDIUrIk5k8tCSlroRrI=;
        b=kgy/gThW/63R41c2MkghxprIUJKUrZi5ipbPqTcuvS/h3o96Y4vdMQkQFPmLRAOiC/
         ZvGwLzHOp4i9MF95bhJWKRdvELl6MMLu3OdeaO5LeOXWebGT/7HLoEl/OPsN9utxDzab
         hWHS0szqKaV/swRVpp3CLDhQgybKUcwv+c9+xSXKqFbe0cvKbcLTEQCisn8SEbUj3Xq9
         et/bbU0zoHX7pRJ+YsAc+Q+PCJCuV251TQjMn+n7gadc48EXlvVCGG2JbFC6VypEdg1T
         ry98kF2enDYW/K6XobaNjtbIcQN7EZxzNtnzbf7lqRALUuHSnnQgFffiUXcbrYq2be3V
         iFtw==
X-Forwarded-Encrypted: i=1; AJvYcCV5ufCFE0IoR5rjY+gxCzTAZnNTxT4dM1zffT82Pd9FpGVrMzewdszIZLi4n4z7MUbZciM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2cqMt1Bzl7dXOM1iy8iVS2UmSLu0Dij1zUoWzb5Iy0kZ+GBE3
	orgZHU+PngsIwexqcsr2VxHHSdK5IDikUxOnXy6IhDIXEmiYoixHtcfJphoFz/AfqCh+BcNC/P7
	NXE4qu8A/0Tu/Mo1XqvyD34xD84p/9XMQhxy/srbm3PHr2sHygQ==
X-Gm-Gg: ASbGncvLtg7Y6g1eD9tkPLZW5N+MJc3dBACUnau6SLjeL6p0A1zd1js5eZiZGKjYExk
	+ykvX9NC2SZlRpAm4gVS3787ppwUUo2li9zK0NaTF/Aurf3rBB+hc+SwNnqFofdz5XRTKb94ih4
	tAIes1PYWPucBYilxGwyplHx3Ii+CKrj5pF6aLDLUZtiKST6ekUHccOkF0DgZJGI+X/ipvRYl4+
	QSra7pWYHVpM3DofMEYiWgEFTmdQvAzz3EYNLjOL4LMRAvBGad2xEE5qkebmftWipUJoHsGuiNw
	FI3jTOUmpXWqmcLK5cQ=
X-Received: by 2002:a05:6e02:1a2c:b0:3d2:ae27:10f6 with SMTP id e9e14a558f8ab-3d483a7909bmr6063375ab.6.1741963703455;
        Fri, 14 Mar 2025 07:48:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsRk7IYGumLFporN/Er4EBhO3DvN0XX2yIAK9lIhR2xUTzIY3johMT+3KWQzhsVAP/T7QbiQ==
X-Received: by 2002:a05:6e02:1a2c:b0:3d2:ae27:10f6 with SMTP id e9e14a558f8ab-3d483a7909bmr6063255ab.6.1741963702743;
        Fri, 14 Mar 2025 07:48:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f263701f78sm899291173.5.2025.03.14.07.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 07:48:22 -0700 (PDT)
Date: Fri, 14 Mar 2025 08:48:13 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: kevin.tian@intel.com, jgg@nvidia.com, eric.auger@redhat.com,
 nicolinc@nvidia.com, kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
 zhenzhong.duan@intel.com, willy@infradead.org, zhangfei.gao@linaro.org,
 vasant.hegde@amd.com
Subject: Re: [PATCH v8 0/5] vfio-pci support pasid attach/detach
Message-ID: <20250314084813.1a263b66.alex.williamson@redhat.com>
In-Reply-To: <20250313124753.185090-1-yi.l.liu@intel.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 13 Mar 2025 05:47:48 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This series introduces the PASID attach/detach user APIs (uAPIs) that
> allow userspace to attach or detach a device's PASID to or from a specified
> IOAS/hwpt. Currently, only the vfio-pci driver is enabled in this series.
> 
> Following this update, PASID-capable devices bound to vfio-pci can report
> PASID capabilities to userspace and virtual machines (VMs), facilitating
> PASID use cases such as Shared Virtual Addressing (SVA). In discussions
> about reporting the virtual PASID (vPASID) to VMs [1], it was agreed that
> the userspace virtual machine monitor (VMM) will synthesize the vPASID
> capability. The VMM must identify a suitable location to insert the vPASID
> capability, including handling hidden bits for certain devices. However,
> this responsibility lies with userspace and is not the focus of this series.
> 
> This series begins by adding helpers for PASID attachment in the vfio core,
> then extends the device character device (cdev) attach/detach ioctls to
> support PASID attach/detach operations. At the conclusion of this series,
> the IOMMU_GET_HW_INFO ioctl is extended to report PCI PASID capabilities
> to userspace. Userspace should verify this capability before utilizing any
> PASID-related uAPIs provided by VFIO, as agreed in [2]. This series depends
> on the iommufd PASID attach/detach series [3].
> 
> The complete code is available at [4] and has been tested with a modified
> QEMU branch [5].

What's missing for this to go in and which tree will take it?  At a
glance it seems like 4/ needs a PCI sign-off and 5/ needs an IOMMUFD
sign-off.  Thanks,

Alex


