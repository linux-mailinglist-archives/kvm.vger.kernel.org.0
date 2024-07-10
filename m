Return-Path: <kvm+bounces-21326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E118C92D765
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A68B4281471
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A5A195399;
	Wed, 10 Jul 2024 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZ/RQCVw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D4C192483
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720632478; cv=none; b=rDUCf+PXdchhfczA1osINW4oRIF9EhrfgVONoHsHWIdH4lZbpbHpOky6iL/5x/2AaoRJeMyJLFS0TEpXmnvRkSBPf4ANDUefe8Zhds8dJ6PSjtYGe8Ewb+7x8qJcbR2Xfbwa2B3OMfUM4JIPzgfWI6XKC25t0ZsmYgB6stOZkL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720632478; c=relaxed/simple;
	bh=IfifOGPyaLg3kQUdrerqtXi3VLiuY2GjEHD4EJslXHw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=jTLsISpMpEvgDpR8J2IWc+5ygJa4iJPEw0hiSt8s4JAPC176SVONGzn3dtKgfu1eymmfjgt1mIsdHwDt+F8M7G9eqV/gXqzji/lEHbOQByVZrH2rETuisqbYdVcRWvK7kU6X7adrILGZD/qy493CSoqNgUKrYzv2/TuUuD6EBiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZ/RQCVw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720632475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hYZ6HDiMSyR3QBtyVZQYJMKt1pNSP3qQpWhlUmgQsEw=;
	b=FZ/RQCVwEENmrUbZF/Fqr32p1fLzwOqYaTtdvEZPnTp0XfOIP+FWDw8YsZXOol0AhKvUjT
	XXVR3NQ9kx/NkSh00toWKCi79SQOrCkq5m+pA2Dafs0ktEYtlRi+7EgfsPRIojrV/NAJIs
	4Bg5QYw9Z1IlAkAF/p05YJzzpDqIskc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-btqqF9Y5MYiU94OcLb86wQ-1; Wed, 10 Jul 2024 13:27:54 -0400
X-MC-Unique: btqqF9Y5MYiU94OcLb86wQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7fc9fc043eeso803939f.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 10:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720632473; x=1721237273;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYZ6HDiMSyR3QBtyVZQYJMKt1pNSP3qQpWhlUmgQsEw=;
        b=uAJVSSDdj+p7JMC3BJyRnpyAiyNpzkfruU5fVszt7aPA+wgIeInx5OPtoQb5Uf4tDi
         qpJ6S1a/DoxlTzUFzdC8pujKjwREYd+9vPs6rvTOBgcBCsMn16RXGmfK6DduSrAegQf+
         v82GpVN2g6WUNN7z/kUMuvr6Hvw9AaHS6pokaU5WuzsuVaQx6DxJKHJDRaddmzdnihwg
         u7noK+mYa42R/Hm9WKAZ5T2Kd/rYUxziVgzIePlD7sz1N+z8OUX75oeBFflfG047fTxC
         B2HLgEfa5wRA0avCD+LyKJ4ufLw9ydyw0sCwRTL7F5GnBe6JhqHMIgXCADK4403sAj0N
         kDKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv8s8iMLjBx7VbWWMg2k8YlYAcR2n3Gt+OxJ9fuJg+Ff0TAzPT26wF15Y8H0IrIwzkMN9u/q8ges9fDcdJWbpQaXyX
X-Gm-Message-State: AOJu0YzrpiL3U5PFO5nwLz26NSaM4ggKRfyEjkAEkli+Uvu8eyfc/7Zd
	1Z76VkRD+2i1cINImcqQ5d57FEi3ywvBmEwUE461US0vcfUPbS0MgqvFhUFnMIOOAhj2len5oG+
	mUaBBUSutUfe6eYE34FeuvNHoV2X9aUirjIgNn2YTjlkoqxrITA==
X-Received: by 2002:a5d:9b84:0:b0:7fb:8ff7:8f85 with SMTP id ca18e2360f4ac-80003abbe16mr601718339f.21.1720632473316;
        Wed, 10 Jul 2024 10:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWMPLAIAUsQ5VWLZ9eILEuoRMq0MQDlWAWP6kvNa4PD56qjkNDaRRy9BnTnBuv2KwZspkbgw==
X-Received: by 2002:a5d:9b84:0:b0:7fb:8ff7:8f85 with SMTP id ca18e2360f4ac-80003abbe16mr601716439f.21.1720632472933;
        Wed, 10 Jul 2024 10:27:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ffed95e7e6sm129115239f.53.2024.07.10.10.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 10:27:52 -0700 (PDT)
Date: Wed, 10 Jul 2024 11:27:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v6.10
Message-ID: <20240710112751.7168972e.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

This fixes a late breaking regression introduced in the v6.10 cycle and
appearing in recent stable backports.  Thanks,

Alex

The following changes since commit 256abd8e550ce977b728be79a74e1729438b4948:

  Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10

for you to fetch changes up to 5a88a3f67e37e39f933b38ebb4985ba5822e9eca:

  vfio/pci: Init the count variable in collecting hot-reset devices (2024-07-10 08:47:46 -0600)

----------------------------------------------------------------
VFIO fix for v6.10

 - Recent stable backports are exposing a bug introduced in the v6.10
   development cycle where a counter value is uninitialized.  This leads
   to regressions in userspace drivers like QEMU where where the kernel
   might ask for an arbitrary buffer size or return out of memory itself
   based on a bogus value.  Zero initialize the counter.  (Yi Liu)

----------------------------------------------------------------
Yi Liu (1):
      vfio/pci: Init the count variable in collecting hot-reset devices

 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


