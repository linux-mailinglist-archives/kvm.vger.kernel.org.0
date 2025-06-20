Return-Path: <kvm+bounces-50134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E45EBAE211E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F07FE3B03F0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D8C2EA16F;
	Fri, 20 Jun 2025 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avX19urG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C50F2EA151
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441233; cv=none; b=pRowA3DiAziYtVGq4/TAt5Ld9Nc3KYuMFzMuoyMuLA6WnpnjDz8hsrIkKpnKNOmVYWEDDkswv9Mr6/A1350kKztAu1BqRyXTM8xrO4heP6tLCNBmR2ASjJ35qUhF9Yu03Bcr0gpLH2XRhylpa8ItdX+5RmxvERi1dGV9ayPDXRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441233; c=relaxed/simple;
	bh=c1OqOZi0L6a8x1MgHQq6Hs7UDBb04GSmvQr42NEaa1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRGvwyXLY6geUK5HAitWVr6hxAN1p6l6NoXzZOW9ugFQ//oSwwQyrvqcPvYNPs2e5l/Xim9Avgj2gZCbyCPPP9lwG1DwkTsIHldw86Fi6+eWTAE2p5ZdqEBJYFyWzzQHz6EfvGObNxBVKkK4ABYwut7fnTRUVRpNCrokuLtLrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avX19urG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uPdNe7cXMdeKaI4Rm8AI/ehc72jL10HFb6fBGbYEdl8=;
	b=avX19urG6dH+SeWk5SE47H6lodaF5/S13YxUlH1yR3NE10ua9NIUKrEublGQgsIcoLjWTn
	obu0e+oE4ZT0e1o7FdcTZFwWUKmD2liaoHLXsTRKO7MgNjte5i6f9MtLJcPBzk1Sq/D6H4
	4ZAkX6cgQm8XrBpmR/pzAbMsM24HwLE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-Sxv6xbOUMxKhpmT6HuxSEw-1; Fri,
 20 Jun 2025 13:40:29 -0400
X-MC-Unique: Sxv6xbOUMxKhpmT6HuxSEw-1
X-Mimecast-MFC-AGG-ID: Sxv6xbOUMxKhpmT6HuxSEw_1750441228
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92DD819560AA;
	Fri, 20 Jun 2025 17:40:27 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 278D019560AD;
	Fri, 20 Jun 2025 17:40:21 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kvm@vger.kernel.org
Subject: [PATCH v5 net-next 1/9] scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
Date: Fri, 20 Jun 2025 19:39:45 +0200
Message-ID: <63851a5184c4b25ed85ee897d4a8b52544296dc9.1750436464.git.pabeni@redhat.com>
In-Reply-To: <cover.1750436464.git.pabeni@redhat.com>
References: <cover.1750436464.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The mentioned macro introduce by the next patch will foul kdoc;
fully expand the mentioned macro to avoid the issue.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 scripts/lib/kdoc/kdoc_parser.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
index 062453eefc7a..3115558925ac 100644
--- a/scripts/lib/kdoc/kdoc_parser.py
+++ b/scripts/lib/kdoc/kdoc_parser.py
@@ -666,6 +666,7 @@ class KernelDoc:
             (KernRe(r'(?:__)?DECLARE_FLEX_ARRAY\s*\(' + args_pattern + r',\s*' + args_pattern + r'\)', re.S), r'\1 \2[]'),
             (KernRe(r'DEFINE_DMA_UNMAP_ADDR\s*\(' + args_pattern + r'\)', re.S), r'dma_addr_t \1'),
             (KernRe(r'DEFINE_DMA_UNMAP_LEN\s*\(' + args_pattern + r'\)', re.S), r'__u32 \1'),
+            (KernRe(r'VIRTIO_DECLARE_FEATURES\s*\(' + args_pattern + r'\)', re.S), r'u64 \1; u64 \1_array[VIRTIO_FEATURES_DWORDS]'),
         ]
 
         # Regexes here are guaranteed to have the end limiter matching
-- 
2.49.0


