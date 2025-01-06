Return-Path: <kvm+bounces-34617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7F2A02DC7
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 17:29:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 127EE3A53A5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102761DD9AD;
	Mon,  6 Jan 2025 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJPAyymO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737586354
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736180945; cv=none; b=pTTPmR+NXpN781temkz3O2zT277r8EYCl/u0d+q033lgbQsPiMt1XptLJ/bw8+jr2g4S44HWjSLyltmfUwIWE+Bcl5x/x0Yo/cEJjC1ZLcwNlvEk5AyJ7fKaoQImtQsGKQMO7P0n4AK57mspsRXXbuwG2zleIKZqxi2hm/MhpsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736180945; c=relaxed/simple;
	bh=2LfuYpkSvp62H0o1Ji/Y+L3Mw0WHxQLmPvOJ6qRVTUM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aiXKb/oNJ9o8e9mk2YSjxVC1JhQiNuKc48tktt5P3sdNwIIdOzHBM6/4hYSQ1L1D2PGpIuLEs2U3jFJJGH8y+k5PFGol8hTNWWebkDt1DHPvwQ1cdZkqqorfXqDRzominrOwO7WcaO3wXPglOOGWe27MxixIq6EXqrOjGpPMo8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJPAyymO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736180941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FWa29MPCTNwd9C2KvQs8doP+KaAm9JiR9RjxBQhwWQQ=;
	b=MJPAyymOvFN5SsLEWrC8mwbzX0gm0/WJZy8kNv6kDJMfJ4L9mT2IAAJz5hSZTl5MZp/pYo
	AC9vRCWJrNK5JxBBcriTB36iw3ioLj4rBf0YiWlYxTBWvJmzdDO7fx2uGKWpR4hbgdPlCq
	pNMklCeOA1Gq+SAYiAijIwz4eTxccww=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-93MTumQxOgubL7qsHjSppw-1; Mon, 06 Jan 2025 11:29:00 -0500
X-MC-Unique: 93MTumQxOgubL7qsHjSppw-1
X-Mimecast-MFC-AGG-ID: 93MTumQxOgubL7qsHjSppw
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-849cc81984eso31797639f.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 08:29:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736180940; x=1736785740;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWa29MPCTNwd9C2KvQs8doP+KaAm9JiR9RjxBQhwWQQ=;
        b=KFBYkQkbiy7WMuOr2rNOrIBvza1XhZN7fghPOsiXfFf+wReA/nnLnVcuvsGKQULvEo
         gv486FmFmZ2cKYHCg0yNAEUBTjrjXl1t0OSXhilnZp8wYvQBQ7LBRg8ypgNsmkz7t2Dg
         ymmRPL/YNmrh5Qnd6yQrsn2gHiA6HkdtNhcqPGwtZJHH2ul4PYlUFAcNw5h0ngyQ/3yb
         77CsGvOje3Ap/WV6oH1D8rWOPTVRw7ErnN0LlqdGZSLwiSLSg0ApcSIS7+QKhMWCg6uk
         YVB8fGL5fx2lbhMJVDK2me794o9X2zOVd5Kj2b8Y58uaifkvxL7sgYGhzFpf7NiR1sIV
         V3Ig==
X-Gm-Message-State: AOJu0YwByYfK5dJua7ZmrDqKHYIrZoegOux/2Qm9nvkDONuCdc8WwIW7
	AJO3Fw/0RlcG5ZYQBoZVaWKBqzEqPDyhKOCHfoELGUB/iP8F4GUxbi8bMVR9MWBvAqfYS2yu/dL
	WisaqSilGr/Eg49JRmkasjK/QrxBEJd3L3lXQ9fApXDhd03Uo5w==
X-Gm-Gg: ASbGncsVaXFch363xMb1u6nzndXWetP6lX/DLZHEEzWxnj0JagkMTfzno91dYTLXTNh
	EwdmrxD/kLIdMrM++tHdu4MBgQOgmyfwQcuOQdl/uhQgsevFuIOk8Re0OGmmwoEMnkNPbnorL6T
	gn3M3I0bveS6Ykf+hXQR0ueDPxtdxRvM2efNdHT5yrJl4F7GtRGIFCkM4WZC22sc/6ozIPhUpMu
	p8WK45zc0gm3zhrqX4esBy2Qj+Tyd8R5Fgh4iSd6hkw+hNaCPgy98cvT8HO
X-Received: by 2002:a05:6602:6d15:b0:835:3bd5:5733 with SMTP id ca18e2360f4ac-8499e499a65mr1564373939f.1.1736180940132;
        Mon, 06 Jan 2025 08:29:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiz/EsGSb8ZhnxPz0SSCTM3u9xZKGboQfFo76n91+WsK/Z3Im+FTrsgYg+IAUJbeqj9iusng==
X-Received: by 2002:a05:6602:6d15:b0:835:3bd5:5733 with SMTP id ca18e2360f4ac-8499e499a65mr1564373039f.1.1736180939528;
        Mon, 06 Jan 2025 08:28:59 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c1de6f2sm9111199173.133.2025.01.06.08.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 08:28:59 -0800 (PST)
Date: Mon, 6 Jan 2025 11:28:46 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>
Cc: <kvm@vger.kernel.org>, <kevin.tian@intel.com>, <yishaih@nvidia.com>,
 <ankita@nvidia.com>, <jgg@ziepe.ca>
Subject: Re: [PATCH v2 0/2] Use setup ROM as fallback for ROM bar
Message-ID: <20250106112846.039f63c7.alex.williamson@redhat.com>
In-Reply-To: <20250102185013.15082-1-Yunxiang.Li@amd.com>
References: <20250102185013.15082-1-Yunxiang.Li@amd.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Jan 2025 13:50:11 -0500
Yunxiang Li <Yunxiang.Li@amd.com> wrote:

> On some servers the upstream bridge does not have enough address window
> for the ROM bar, currently this will result in the vdev not having a ROM
> bar and this causes issues if ROM content is needed by the guest driver.
> 
> On x86 the device's ROM may be passed via setup data to pdev->rom, so it
> can be used as a fallback. However, it can't be exposed transparently as
> a PCI resource like the shadow ROM, because it is not aligned to power
> of two boundaries. So special handling need to be added in vfio to make
> use of this data just like in the GPU drivers.
> 
> Yunxiang Li (2):
>   vfio/pci: Remove shadow ROM specific code paths
>   vfio/pci: Expose setup ROM at ROM bar when needed
> 
>  drivers/vfio/pci/vfio_pci_config.c |  8 +++---
>  drivers/vfio/pci/vfio_pci_core.c   | 40 ++++++++++++++----------------
>  drivers/vfio/pci/vfio_pci_rdwr.c   | 25 ++++++++++++-------
>  3 files changed, 38 insertions(+), 35 deletions(-)
> 

Applied to vfio next branch for v6.14.  Thanks,

Alex


