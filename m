Return-Path: <kvm+bounces-39863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC6FA4B9FF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 09:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D0DB1893726
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 08:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29571F4168;
	Mon,  3 Mar 2025 08:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYjlLeYW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD61F3FF3
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 08:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991981; cv=none; b=OYYbUZ6q6UtV51lUuA2zKAGI7C3+laMEuNnPAUrrq7fsbxjBlNBZzIDEtNYxVNY60wqhuilt86VIjDtuAqqRVAzv4BNENvNGM0bRX6PtM/ihz11OtrhfjsDvLfZ6AJzahN9mXQJdaQjasD5alHHr0GTmZF2XoUXMKCHfPdiw5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991981; c=relaxed/simple;
	bh=7BJ75VnqDYEbE9e13G+MCHppvDrRT82moH7VLX3ZmAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=il9mobRNhrvMHZXSEHmBSe5JF5U58Q60D9ghabyKlC1GsG11nlHudrVIPZqt4jEynKYcWLZbvTDEK2pfnvqX1tCUnzcTkpmPYR6cQlzrrx760K88UJAWL7UVLGzNnLr1f/0HXvMHn/9/j4Rhs31wsTUHWPOagBN3HFqGQs6flRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KYjlLeYW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740991978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x5f0Ge/u6HApn0cHLmrjeezLoP0KdtHv+tljpLM2u/w=;
	b=KYjlLeYWqKLkKWb6GhI0K+TR6gDip80zFMZgsVxyeEpw1BFCn7V3Pmd/+3j9WsBNxzMS6/
	rFRfNCfRfJ96IdNeyq+oMWdLbxglSiToc+f8rR8r7z79lxel70bDxAu/OQqniU6kZ/L3/W
	w3coEpfDeOac8FSQK7JUPF0LdRLl+Is=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-IsZul_cCOuK_8Kn6VbhoCQ-1; Mon, 03 Mar 2025 03:52:47 -0500
X-MC-Unique: IsZul_cCOuK_8Kn6VbhoCQ-1
X-Mimecast-MFC-AGG-ID: IsZul_cCOuK_8Kn6VbhoCQ_1740991966
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e4a0d66c69so5196897a12.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 00:52:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740991966; x=1741596766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5f0Ge/u6HApn0cHLmrjeezLoP0KdtHv+tljpLM2u/w=;
        b=wlZaSJIRpXTLYgXaMai0rEEjnVkXCvyezSJ/hsu3wUUaNuEXBNQiCVV3hwXq8XL4dq
         GC1RBcllrajQCRaYPnPub85v5pBoc6jAq2h0ppLlaap1zXSJR8sf+2+JdVGtwEm2ikyI
         wFqrVUzevhJM6UGIXyQGnpncFq5TPilUzLTPUDWO9outG0RVx+ddN4Pl2hKuguBLg5ga
         u6cLJHX4Au0Q6Q+jxLEQQHEiUuO1RAdNk+Tw7xEzWfy/G8VlXhssC6cDUZQB5ksJ0/Ed
         rjQH4kjMXVrIdhkWx1vBW3AzsngSg0snnmIw/DW6VbelkXAyPNJu0+8ozm8+tXe0lBjv
         vQMQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8w9hBMg5eWOzb1kyM/efkaLNtzjmwUdx8m6flERGxgTH4uDcBheUbxLSjSsH0bGwqtlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdl+ByH0W6jY7Vcgy8IJaXFRjXF0Cz03XzjXUXzd4uWW2evtOf
	CLyarJ5T2KJj3ARjZFrl05WD3mtHA6BMf/vndl1LYAtEUa+DMdVZ/n6RO32OLDQDkrSsPpm3vy6
	7Eyj9ivDDjsRCFneujxCP+KHeazLQkgf/XaYQWn28Wy/dmnY4Hw==
X-Gm-Gg: ASbGncvNrNpbgSpl+ntokxuFM5nW9pfZaFG7df7AtxiWcBDDGSnkGzxhyZJigl8oqf9
	d2Y0QuLCU0y48xc6ugprNYOfpM4hornaUspjGYk9pAyb5MlUyaNrhCebDHiHFYCzVqq2JWQN2GJ
	ILiev4BbXEDnkyJfu7zRyjQPxAkEZ497gwthUg0mzCNGtePq7NGvN2tIUHbt76kwEaKenvMIgLZ
	WD1G6PwbNAEce1MzNITWa7Oti+ov2oyOoSWSq4wMcmTv2C7yER5Lr10v8XuRG+e8MA3R123++5S
	9C71fgqzucEzNY+MYB1+AR2OSrKE2foifeYMPCWbwN3EarGaniXzu7I6eiEDOgOxH8JPZicF
X-Received: by 2002:a05:6402:270d:b0:5de:5263:ae79 with SMTP id 4fb4d7f45d1cf-5e4d6adec08mr13660770a12.12.1740991965903;
        Mon, 03 Mar 2025 00:52:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHo44UCmf/nhSiQ3s6omsM4aVzpmAfPARCDmTuHp0dZeSeSv2Z6WHtZA+hKBPUeIaCokWugDw==
X-Received: by 2002:a05:6402:270d:b0:5de:5263:ae79 with SMTP id 4fb4d7f45d1cf-5e4d6adec08mr13660741a12.12.1740991965384;
        Mon, 03 Mar 2025 00:52:45 -0800 (PST)
Received: from localhost.localdomain (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3fb5927sm6466076a12.53.2025.03.03.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 00:52:43 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH] vhost: fix VHOST_*_OWNER documentation
Date: Mon,  3 Mar 2025 09:52:37 +0100
Message-ID: <20250303085237.19990-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VHOST_OWNER_SET and VHOST_OWNER_RESET are used in the documentation
instead of VHOST_SET_OWNER and VHOST_RESET_OWNER respectively.

To avoid confusion, let's use the right names in the documentation.
No change to the API, only the documentation is involved.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vhost.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index b95dd84eef2d..d4b3e2ae1314 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -28,10 +28,10 @@
 
 /* Set current process as the (exclusive) owner of this file descriptor.  This
  * must be called before any other vhost command.  Further calls to
- * VHOST_OWNER_SET fail until VHOST_OWNER_RESET is called. */
+ * VHOST_SET_OWNER fail until VHOST_RESET_OWNER is called. */
 #define VHOST_SET_OWNER _IO(VHOST_VIRTIO, 0x01)
 /* Give up ownership, and reset the device to default values.
- * Allows subsequent call to VHOST_OWNER_SET to succeed. */
+ * Allows subsequent call to VHOST_SET_OWNER to succeed. */
 #define VHOST_RESET_OWNER _IO(VHOST_VIRTIO, 0x02)
 
 /* Set up/modify memory layout */
-- 
2.48.1


