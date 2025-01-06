Return-Path: <kvm+bounces-34616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 675B4A02DC5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 17:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55A8C163A19
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0031DDC30;
	Mon,  6 Jan 2025 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blNbyse9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B562C86354
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736180933; cv=none; b=A/7yongDMlNjr7BbY1qnkmwYN3Kd2OQGCae9l1zjnlE7yvNyDW0EkonoiZq7UqSRx6vMeiaiNWsCJx/HSiNBymB+09X1SRjXSylJDz9RICNENnqa3FIUjZeVPk6NYfpv6Djtq4+RSNbepfA3TDqwq0iA5EDxD0IRKc8LLQF2Lbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736180933; c=relaxed/simple;
	bh=bqA1UybnyzZGHI20admmSzA4zWOEjPM4b0uF7KYKxt4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGVrkfyOloGLE468AS+IcWWweP/WFkIodtiUjuex5EYpY3+FXhRUa05ERpIHCFgn3fwTEUFpN2HrBGxlEUic1EETVdtn4g69lQSQcNvSuDULuFK13K+dqJIh9LpAOAUYRxw2EdNctGaMZkykLOv+GO7fTrWqaNnQoa/ORFvrHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blNbyse9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736180930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iTSPijXcjiAMCVDWekBe6V30dPAU6QGdX7quKRrwsHs=;
	b=blNbyse9Ddg9Ek8xxItBx+0vlfPxP16YBTHK/YiNIn174ISRZr3GMPIouCCHdLGZe8ArYc
	YwJbDLX15Fu5l8XN7mTDFTO9s6HYgJSZ+E80AF5u5w2w+46QoIBhGW5EzndHeoyliFDkPq
	5k2PwRIvjJ9lrCGui/IFvzrP0p3YjuU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-Wu5BprnoMSW5JVIkvItXPQ-1; Mon, 06 Jan 2025 11:28:49 -0500
X-MC-Unique: Wu5BprnoMSW5JVIkvItXPQ-1
X-Mimecast-MFC-AGG-ID: Wu5BprnoMSW5JVIkvItXPQ
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84cd123df74so630839f.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 08:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736180926; x=1736785726;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTSPijXcjiAMCVDWekBe6V30dPAU6QGdX7quKRrwsHs=;
        b=r/D+ftUKQcFkUw2jErmjcSP82Q2GMssCt9JzURr4VtZ8yHp03aEgMJN8IuRW1eexmq
         UKb3koiyu+gzOgKhwZfN0wtTMzK1bpo934GJHw53Mql9znXR0oagrHcJG+DPfzrPDj0J
         dB7IlmaXOT8OirShker+pPAffg6vAmIAYHRAF9G+77nStkOYaeDGj9W6lE/XSBwpHRvD
         A7rKprgT7XpOB6wJETGIageYyBIZunNJqYmjPFWQsHBZYoSwxwYxXR5UM40jT9Fx8I5q
         FMrlMDvzuHpjlMf7tr+/t+30MjMRXWoPiuJI9s9+ioW2idxH/2zP6V87HiScqMmn60Ns
         DtLw==
X-Forwarded-Encrypted: i=1; AJvYcCXRkqZULH26hn1xWLmkW/BMXBCjFMnoQ77ateO573aBW04eikqqoaVPFCvZCrb181M65BY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxOBhFwLSt9dgSx4JPXqd3SMEEbM88eNHnqIVxveJp5U9SEGm
	wXWjbpIbZLZUVrrgnZztNKvgzZXqelpDWhTSjJwejHkNIKm4AkXAZZHK/yS3bAEueOqJzFK8hEE
	gBWXKaXRiUK93s8XrAWce37OueynzbdbQTl6mHOsOGEKIDhEyug==
X-Gm-Gg: ASbGncvSyfqRDxedWjLdVPRbLjqtDMSOLA0KBpShahrVPLp8FIAk0G9NFVLK0oKbdyK
	VVTudPmrMNaH8WsjnHBViv4qvr8EBkfirmj3UHZ/yggxbYGoLvdIfF2tC/AFroHzrEnbjUVc9+X
	JNDWJ/Ch/9CMClDMBYMrQzhtwChtqD8grx+AyQagK9Xo3k13+3YGJ20KF40Y3OKcl5uT/fJLKL+
	dn2eaeJpg5fTCCm4MCda6GIIpdaV1/7aAvrgnOBT0sYg5qcM6VQjd/pu03T
X-Received: by 2002:a05:6602:2dc2:b0:847:5b61:636c with SMTP id ca18e2360f4ac-8499e4c8cf8mr1605757039f.2.1736180926527;
        Mon, 06 Jan 2025 08:28:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhi2SYCIWSDt6cklfzahC0bZr7S4U+xeNewvxNt7RadojvE0j28xssj9KSgjAMXq4it3yS9g==
X-Received: by 2002:a05:6602:2dc2:b0:847:5b61:636c with SMTP id ca18e2360f4ac-8499e4c8cf8mr1605755939f.2.1736180926206;
        Mon, 06 Jan 2025 08:28:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8eb32asm891093239f.42.2025.01.06.08.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 08:28:45 -0800 (PST)
Date: Mon, 6 Jan 2025 11:28:40 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Ramesh Thomas <ramesh.thomas@intel.com>
Cc: jgg@ziepe.ca, schnelle@linux.ibm.com, gbayer@linux.ibm.com,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, ankita@nvidia.com,
 yishaih@nvidia.com, pasic@linux.ibm.com, julianr@linux.ibm.com,
 bpsegal@us.ibm.com, kevin.tian@intel.com, cho@microsoft.com
Subject: Re: [PATCH v3 0/2]  Extend 8-byte PCI load/store support to x86
 arch
Message-ID: <20250106112840.423340ae.alex.williamson@redhat.com>
In-Reply-To: <20241210131938.303500-1-ramesh.thomas@intel.com>
References: <20241210131938.303500-1-ramesh.thomas@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 05:19:36 -0800
Ramesh Thomas <ramesh.thomas@intel.com> wrote:

> This patch series extends the recently added 8-byte PCI load/store
> support to the x86 architecture. 
> 
> Refer patch series adding above support:
> https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm.com/
> 
> The 8-byte implementations are enclosed inside #ifdef checks of the
> macros "ioread64" and "iowrite64". These macros don't get defined if
> CONFIG_GENERIC_IOMAP is defined. CONFIG_GENERIC_IOMAP gets defined for
> x86 and hence the macros are undefined. Due to this the 8-byte support
> was not enabled for x86 architecture.
> 
> To resolve this, include the header file io-64-nonatomic-lo-hi.h that
> maps the ioread64 and iowrite64 macros to a generic implementation in
> lib/iomap.c. This was the intention of defining CONFIG_GENERIC_IOMAP.
> 
> Tested using a pass-through PCI device bound to vfio-pci driver and
> doing BAR reads and writes that trigger calls to
> vfio_pci_core_do_io_rw() that does the 8-byte reads and writes.
> 
> Patch history:
> v3: Do not add the check for CONFIG_64BIT and only remove the checks for
> ioread64 and iowrite64.
> 
> v2: Based on Jason's feedback moved #include io-64-nonatomic-lo-hi.h
> to vfio_pci_rdwr.c and replaced #ifdef checks of iowrite64 and ioread64
> macros with checks for CONFIG_64BIT.
> 
> https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/
> https://lore.kernel.org/all/20240524140013.GM69273@ziepe.ca/
> https://lore.kernel.org/all/bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com/
> 
> Ramesh Thomas (2):
>   vfio/pci: Enable iowrite64 and ioread64 for vfio pci
>   vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64
> 
>  drivers/vfio/pci/vfio_pci_rdwr.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 

Applied to vfio next branch for v6.14.  Thanks,

Alex


