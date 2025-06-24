Return-Path: <kvm+bounces-50500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC469AE67ED
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A16CD3A35BB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE1E2D23B2;
	Tue, 24 Jun 2025 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpPhgW//"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5672D2386
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774239; cv=none; b=ZlOsYM3DZayOwhUFjoL+++qLK0ceVoMxYUiJyItT2lgD4bbAVARCsBUoKNv6szvZnap4PRWcJjNIHzn9Fxw/LNOcElBg6fCKKzBvggLAMH+ymm2CKOumi7WTVxAw3anj+ReiHmeaZ6ustCst90SEL1D7yCeFDIpc11wCRbdutOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774239; c=relaxed/simple;
	bh=c1OqOZi0L6a8x1MgHQq6Hs7UDBb04GSmvQr42NEaa1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWzB1VJwYx/eMPVmcwbZLcrhmLYawaLvhIY9wZZwmPzbcgf3j6w2791VgHNTOcbnNawCPVh2j67RwP/AByavIt14h0e+tSRWWs+hMPg4ilhOzqB/OlGLK67YLSVnzUSkSfBU4omyPfLY8RH+fxmfhLT9yamp3LN4Ejs16wtDU6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpPhgW//; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750774236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uPdNe7cXMdeKaI4Rm8AI/ehc72jL10HFb6fBGbYEdl8=;
	b=CpPhgW//NyWu6hscur1IKzNVZPaicDXwds8rv0aFYOCdFOL1LbZet1/XVxGdcRwKLn9yv+
	qAskKSODXWd098FRJV7Sj6wKs5Lbp9UrAc05TcDoT4hKhFhNZFM+MfZKh2DRLA7RV1j/wo
	fClvG0EKtPYUi8muDyb4QnJGa+1lG2g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-foOIu_S7N72gUSG1_2-w3w-1; Tue,
 24 Jun 2025 10:10:32 -0400
X-MC-Unique: foOIu_S7N72gUSG1_2-w3w-1
X-Mimecast-MFC-AGG-ID: foOIu_S7N72gUSG1_2-w3w_1750774230
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B170A1809CB0;
	Tue, 24 Jun 2025 14:10:29 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.193])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D61701956094;
	Tue, 24 Jun 2025 14:10:24 +0000 (UTC)
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
Subject: [PATCH v6 net-next 1/9] scripts/kernel_doc.py: properly handle VIRTIO_DECLARE_FEATURES
Date: Tue, 24 Jun 2025 16:09:43 +0200
Message-ID: <5541ebff8ab5e80353e14f55217558ffc4341b52.1750753211.git.pabeni@redhat.com>
In-Reply-To: <cover.1750753211.git.pabeni@redhat.com>
References: <cover.1750753211.git.pabeni@redhat.com>
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


