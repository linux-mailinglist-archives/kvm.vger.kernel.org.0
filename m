Return-Path: <kvm+bounces-60675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 778F5BF7336
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0CA12355EA6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C17E341671;
	Tue, 21 Oct 2025 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JM5kuWwg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773D340DA8
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761058627; cv=none; b=Ijo6nLvdc8EVJUititGYZvCTMhzUFujUcuClfjyNGhIOXwUwwVbCRmj+NV7cFmZuuq+NhVWZLNaW7ebXzON2DuGYHS9sScdIYUJEF6kD60qTRfAFrWoc6twloN9N84KBJ9PetxVRjEkVBR2Q7ZNkVd6wLLLutRg+3Yl+sSHhXVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761058627; c=relaxed/simple;
	bh=3zLiBpGpx3N7y1mDFocEIkcoo3BHMmz6kvCLUvGCdoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAv/JUIIwd+nQ23wj7NkQe6fHyadIQRZlUfiYf7LgrqbrFqTi/nLt08i5KuFRX0yPqmGqcJEAo2tk+IheW8ozPlyOmkBBAqXr/pROkWjbOKaQXnQaiq5MGKBQjVbVLnnN3mwXNBP8wTc81oM4yH++xOgfBmutISmzNfHH80b9QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JM5kuWwg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ON6jaTzp8OadpSErRLgvJU/FcjQ+VbZlFjItkP49EIg=;
	b=JM5kuWwg0yfA0Vn0T9uhgCh/h8Tengo/gQqqybEVmRqZAiv9jcbPKzO+U9ZAnNqekHDmgf
	EF2ve1nn4CeYcXEMyTVj8npWWoxbzpJrK3IuARGJOh3TcRHFhEgxZFzyhRqF6cL7bn8OIf
	Z++rQ6rUdrRmVY5ndsiReDzZxhdxK/Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-Kpdstlc7NdSujkzu1nd33Q-1; Tue, 21 Oct 2025 10:57:01 -0400
X-MC-Unique: Kpdstlc7NdSujkzu1nd33Q-1
X-Mimecast-MFC-AGG-ID: Kpdstlc7NdSujkzu1nd33Q_1761058620
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so45264595e9.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058620; x=1761663420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ON6jaTzp8OadpSErRLgvJU/FcjQ+VbZlFjItkP49EIg=;
        b=c6xtNlR2sYtwIlVnGv7zBJHM1sL5Ub6j+Gjkz5m59ZiwBJy9HTSqVvYD6L6JmLmc5l
         5UKtFekd71NM69ZAxFPn3lnqB/jlOD6YYbxHkBzsm2MhpEWEPaiYH+IVgx96JVAF8xaq
         zIuU5/9mdTAsAjv8WYXEUPhvlCteJJhg/EDDQRS4zt3ZqqiYuTb5it8QkLamcHSnspRe
         RaGEDyiTfU6u1RPAoSygbItKLrCcNL6IBk5D7K8eJHjWONq8PxGhquwbAr5UhbWtE9oq
         bEr33pXRkm2/eZUeqg3yhR7LhxQcgV7255VCSr9eO6klf7bp4OniakK6W6O50pdpYzTz
         gQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWTgjM/JbfqgCl9ClBT9SypPH1zfiD2H1VXJHj0KOMj//6p4oU/IJQX25+iUCLsSRAuifA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyesUloIl9XoPJGkPX8F0cs0AzEXWCbhZXIKQUQ4/8pCKi/huuv
	dp+LkcVr/QjSay6KzEOYddZmW62L2qN+J2V/yCw8/lRj09Y2GNGs6yP61poFiWbXzMiMho2c6yG
	+vUxZBcckg5/uwLcXlMnrYqDl3cMR1oc52VUVaYlo0GNAM3s8NNWrpg==
X-Gm-Gg: ASbGncvRhkxuANKUkkK1MiQ5CldKrRpBsxZxkEd8PxMobB1494pJ/Aj5iDO7qhNZ9Sd
	3evWfbsQQh+UMeCld/jWGWnkhU8Lz7DtZVCL1pPZ063xxEdGo+Ky7Vmt953MMSBo55MIYnJYWZx
	iiEsyXCXUyyii4eF4oHpBXOgIj30qpfj6tDji9VgMV4qGhbEbkbjZwDrllR4Nz7MY6NEwiQIdkT
	HROHHDr1qaM600PniHU+TZT6JbKui4sMdaevYoeb/pH78WwgawvCrWD/aSEzBjXUHodFHBrx8eW
	F/Yzb0OYBU6ZfxGFwxBvBA8fzjXAZi1ghGCVLtW3CpQlugRXm+Qczqz2zLgMkcv0XjJB
X-Received: by 2002:a05:600c:470d:b0:471:12c2:2025 with SMTP id 5b1f17b1804b1-471179140abmr147850985e9.32.1761058620008;
        Tue, 21 Oct 2025 07:57:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhlH9J/gDJ2/ok4e+k1pdgybvyjWEgAIxCOLewvwxsR9SE4iH4+h2twWM4wXk1Rh2Mp/BOKg==
X-Received: by 2002:a05:600c:470d:b0:471:12c2:2025 with SMTP id 5b1f17b1804b1-471179140abmr147850765e9.32.1761058619536;
        Tue, 21 Oct 2025 07:56:59 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm339012145e9.3.2025.10.21.07.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 07:56:59 -0700 (PDT)
Date: Tue, 21 Oct 2025 10:56:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v2 2/2] vhost: use checked versions of VIRTIO_BIT
Message-ID: <5423d46e5c6f8a4204f8fe1bcea8bf1e21c10f39.1761058528.git.mst@redhat.com>
References: <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

This adds compile-time checked versions of VIRTIO_BIT that set bits in
low and high qword, respectively.  Will prevent confusion when people
set bits in the wrong qword.

Cc: "Paolo Abeni" <pabeni@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c             | 4 ++--
 include/linux/virtio_features.h | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index afabc5cf31a6..e208bb0ca7da 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -76,8 +76,8 @@ static const u64 vhost_net_features[VIRTIO_FEATURES_ARRAY_SIZE] = {
 	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 	(1ULL << VIRTIO_F_RING_RESET) |
 	(1ULL << VIRTIO_F_IN_ORDER),
-	VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
-	VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
+	VIRTIO_BIT_HI(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
+	VIRTIO_BIT_HI(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
 };
 
 enum {
diff --git a/include/linux/virtio_features.h b/include/linux/virtio_features.h
index 9c99014196ea..2eaee0b7c2df 100644
--- a/include/linux/virtio_features.h
+++ b/include/linux/virtio_features.h
@@ -8,6 +8,14 @@
 #define VIRTIO_BIT(b)		BIT_ULL((b) & 0x3f)
 #define VIRTIO_U64(b)		((b) >> 6)
 
+/* Get a given feature bit in a given u64 entry. */
+#define VIRTIO_BIT_U64(bit, entry) \
+	(BUILD_BUG_ON_ZERO(const_true(VIRTIO_U64(bit) != (qword))) + \
+	 BIT_ULL((bit) - 64 * (entry)))
+
+#define VIRTIO_BIT_LO(b) VIRTIO_BIT_U64(b, 0)
+#define VIRTIO_BIT_HI(b) VIRTIO_BIT_U64(b, 1)
+
 #define VIRTIO_FEATURES_ARRAY_SIZE VIRTIO_U64(VIRTIO_FEATURES_BITS)
 
 #define VIRTIO_DECLARE_FEATURES(name)			\
-- 
MST


