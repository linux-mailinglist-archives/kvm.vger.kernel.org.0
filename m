Return-Path: <kvm+bounces-51731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D318AFC3A5
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8C05189E80E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1836259CB9;
	Tue,  8 Jul 2025 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFPbdQF9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FC521B905
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958575; cv=none; b=dKywDDj1Ql7tlUP8okA4Yh31z/3CmAQWEilXI48r6Ok7qap51dXTf5s1iAIPvog0umJn6MXX/d6J67XoPEqnL4GVBzaGKtkCpeg9sc0vaMys/jPoFc0Z39/fERvdwLu9sm/MQUL7x8r1iUOrtzcV4S4pCRZzbJASQ4MYqzSTaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958575; c=relaxed/simple;
	bh=c1OqOZi0L6a8x1MgHQq6Hs7UDBb04GSmvQr42NEaa1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRv2AdxctcoW9vsKD+fLv6TyjuImAqVc9lMQWgjC0cAXa1aJ6hzhEtxQpD53/Nzv5k07nRA/aoqRbiiZLoFCunMOFGqY5THX9FRzsERJPytDTNPdtns0TeG+FZ64RiB13B59zx9qKVAlq2WAPEv9xOfTsyq8u+yVNgZKqn60emk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFPbdQF9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uPdNe7cXMdeKaI4Rm8AI/ehc72jL10HFb6fBGbYEdl8=;
	b=UFPbdQF9LcqVlIyhVC12AXP8S1moUMxYsSZkDS8KE5BEeb6zuKxVKYh2cGJJJI4vLBMk8I
	2I3HZCmG/lN+DFpERxf8/En9K/5bVNbZxxZOcqC8VmkZYb+9PJHBX4MJzEfSSeQZT0DJg5
	Nb2F8RdBVIeyXkyd1A2uU2StWLTL8pw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-3WVPtwTTN0qwZRuccRMB7Q-1; Tue,
 08 Jul 2025 03:09:29 -0400
X-MC-Unique: 3WVPtwTTN0qwZRuccRMB7Q-1
X-Mimecast-MFC-AGG-ID: 3WVPtwTTN0qwZRuccRMB7Q_1751958567
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C2F318DA5C0;
	Tue,  8 Jul 2025 07:09:27 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.252])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 03919195608F;
	Tue,  8 Jul 2025 07:09:21 +0000 (UTC)
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
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v7 net-next 1/9] scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
Date: Tue,  8 Jul 2025 09:08:57 +0200
Message-ID: <ca8beb7f4b0af9f919cada2fd607187455ac55bb.1751874094.git.pabeni@redhat.com>
In-Reply-To: <cover.1751874094.git.pabeni@redhat.com>
References: <cover.1751874094.git.pabeni@redhat.com>
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


