Return-Path: <kvm+bounces-54027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C71B1B7C6
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 17:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44DA13B67B5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3602F27FB12;
	Tue,  5 Aug 2025 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Bw7gw8b/"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB1E17E0
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754408905; cv=none; b=kCy+b0cbhD7ayObAOzjbpfBHvOdpzSxnXrWcga0X6cL1GDdHue1D1vM1c07GBCikXxH8IIrhH78o8MSbALJhneL3auyzv2FiEgEZ3umExXn78Ulv2rtRGeG8QFGU3+DpDgFA3TmLhKauqiYo4XRa/ATTNtndnecxmA2ZylyyD8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754408905; c=relaxed/simple;
	bh=CcvHflFvDJQeSkeLcDnfwTWvCZcerkQeAdrB6uGPdlw=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CDtW8P3cvUndMFz441Dp/Ft1evbnWuHv2h9W9ZifajB2fLa52KhFtdFp1WPhTUZauBaA0HmyFgjEhAwyW8wO4R94jTTluP5jxkaDmAsUFSGiSoOzIBMuiU356URnPGUijnb1bi2Dl33aCDc4E7MSZ1TpZFXVGDTuDvDc0QBIxek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Bw7gw8b/; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754408903; x=1785944903;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=u/YHk6r5F/6TkVZCNeCh25387YcUyDbhbd7Z7Pwqa5E=;
  b=Bw7gw8b/9ighsrtVIo8+NLslURR8AoKawNhbhQs6ew7ZA790V76ZGmWW
   eVfc7hyIERz+Zt8Y73eoW9i5giIo+Of6JSCGnyZfE0J7PQ8kiyLahYXhH
   zPphSHuJYh9zCKGqpgzWaQ/jnaE2IAqyMQF+/NRL0+t7XMOFH7CxqBMpv
   MPv+emaz7VBQWyzkkQW8ltbEp9DUY6/CKFEUyoCW3Wevo3tP1AbK50h1e
   z4sdUsZbvJJObiJj3rzrEPuTgxnTajgcgygvIMXfP2M1XfGJMuRHFXP1s
   yQ5eDdjJzfzVWxT7U7NSWhPARUIWeBgYLabApSd+47y/tmjKzyq6tj8vx
   g==;
X-CSE-ConnectionGUID: b6TLrK7XTKynNiwduf2UJQ==
X-CSE-MsgGUID: WwyN0AwzTEaFIimxA0vbGg==
X-IronPort-AV: E=Sophos;i="6.17,268,1747699200"; 
   d="scan'208";a="566198"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-west-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 15:48:12 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:36041]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.234:2525] with esmtp (Farcaster)
 id 25a46ada-04c8-4e1b-bbd1-4ecddcdf9e8e; Tue, 5 Aug 2025 15:48:12 +0000 (UTC)
X-Farcaster-Flow-ID: 25a46ada-04c8-4e1b-bbd1-4ecddcdf9e8e
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 5 Aug 2025 15:48:12 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Tue, 5 Aug 2025
 15:48:09 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>
Subject: Re:[RFC PATCH 0/9] vfio: Introduce mmap maple tree
In-Reply-To: <20250805143134.GP26511@ziepe.ca> (Jason Gunthorpe's message of
	"Tue, 5 Aug 2025 11:31:34 -0300")
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
Date: Tue, 5 Aug 2025 17:48:05 +0200
Message-ID: <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC004.ant.amazon.com (10.13.139.225) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)


Jason Gunthorpe <jgg@ziepe.ca> writes:

> map2 should not exist, once you introduced a vfio_mmap_ops for free
> then the mmap op should be placed into that structure.

Does this mean dropping mmap op completely from vfio ops? I think we
could update mmap op in vfio to have the vmmap structure, no?

> ioctl2 is nasty, that should be the "new function op for
> VFIO_DEVICE_GET_REGION_INFO" instead. We have been slowly moving
> towards the core code doing more decode and dispatch of ioctls instead
> of duplicating in drivers.

ack.

> I still stand by the patch plan I gave in the above email. Clean up
> how VFIO_DEVICE_GET_REGION_INFO is handled by drivers and a maple tree
> change will trivially drop on top.
>

but I think also prior of migrating to use packed offsets, we would need
to fix the previous offset calculations, which means read & write ops
also need to access the vmmap object to convert the offset.



Another question is: since VFIO_DEVICE_GET_REGION_INFO will use mt and
technically will create and return different cookie offset everytime
it's called for the same region, do we expect that this will not break
any userspace usage?  I'm not sure but could be that some user usage
relying on calling the get_region_info to produce the same offset as the
initial call, instead of caching the region offset for example?

Thanks a lot,
MNAdam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


