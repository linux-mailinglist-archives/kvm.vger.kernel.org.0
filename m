Return-Path: <kvm+bounces-63292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A1685C6113C
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 08:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5DFF54E8F1F
	for <lists+kvm@lfdr.de>; Sun, 16 Nov 2025 07:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AE4285C99;
	Sun, 16 Nov 2025 07:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEKJPBcv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kWglrojN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4001527D782
	for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 07:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763278594; cv=none; b=acx8P0yS5nl1v+WRWsK4Kp3sC78VzyPFSLHseYjvpVay9J1zyD/3ouIsCXrFbsYxPIghGltwUVEhmfqlB0PGTjUuYVUGizSB0yebH3teBEQX+LoDRD6MVhxviEZTWpW8Abf85elMk1e/RYdq/fQw7KKrau9ELFt+CKFezfQsuxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763278594; c=relaxed/simple;
	bh=y8wCZBoR8voYmXOKUgsqLzpqBH63+zG9KD2XjWV0Mfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l82//peG9dtoIDTmMkB0DyLLs/Y3z5/86UOpQJsxAL0bs8PmukWyy6nrfM5vztPWi9Rx1/kfshT04CKxikKrbPn6xhmM36LZ9OiycegYZrXskb/4G7YaV9aQGwUkhzArSpuO61Fit08o/8zDKlS+FSSMQSj7XDg/YYCtOxQXaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jEKJPBcv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kWglrojN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763278591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=trQJ3e9sH2/7p6hcj43E7jvSF+i5hK8jJlCsMQnk8Kw=;
	b=jEKJPBcv0Xl4nKszwH4MuciAxQuB5u6d2+7T0gLOhtQKQh0IL1IptWUfdaoL01aZwwJo1S
	8F3vzOFIPJsW1ndEsNlhfYfpUo09zosPqR6HwTGfFgLDFdadGbL8fWgFTM+O/yP1qdEHUH
	vBHO/gf7uH7sBbqYokeMNL+PIEs78Vg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-xVfUT-9XNvKs5GYy_9lN4A-1; Sun, 16 Nov 2025 02:36:29 -0500
X-MC-Unique: xVfUT-9XNvKs5GYy_9lN4A-1
X-Mimecast-MFC-AGG-ID: xVfUT-9XNvKs5GYy_9lN4A_1763278588
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429cdb0706aso2924789f8f.0
        for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 23:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763278588; x=1763883388; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=trQJ3e9sH2/7p6hcj43E7jvSF+i5hK8jJlCsMQnk8Kw=;
        b=kWglrojNCL1hLarXXDjcC7kLnjUhSS2YQhuDrO0XxCChXMJZlgSZVpZeLcbsa68dqV
         +iYG2ZKO71LE5BFfD41GBzjVJbNPmSSrplln/d2M2PMsiH2kg1oHIGZk8bhk4KIuoLAV
         m2WNJ9Ar3YQwRJo6QGuMvwOXtvdxTuE/57gOeAkYi5SsFQlQlOkSOVcQBj18I9+1td5y
         5yutsbZzkXIbrla5vk2icG3DbpSzLsg60fVMPI9zvAkdELtvExgpYNvxmICu/zNsb6gy
         JB921kEYMvz+7R8m6DfDWSnlvBd0peFsOrYyocUyoEGlgaw7wp8pjOmUTzpcr5y9+ltP
         f4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763278588; x=1763883388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trQJ3e9sH2/7p6hcj43E7jvSF+i5hK8jJlCsMQnk8Kw=;
        b=EEhh/Y+oBdSp7YrB/VVLKVh6PSHlq5xXbeBkZToPKVhbML8A4lv9fkhlnwBRN54kBP
         o+5YEJaQG4o9hD2q8010/d3uP+COFQOQz3FmGL8n03u7ML3/b0fvYGjqv0wqliMOkUDD
         PTFuWJgKTrZbJcLWQln0QBlm0pKjcTH8GTxl6JnBPoECtt7XJ3npiM3AO2S4mqhS3+Vi
         7wk42Jh5REvq+ttLCHdaiCC9UkoKOqnTpizw70lZPo6qe1u1n7qpBk2pm8mQOAavZ/Bf
         hGau5h3HV8HV1zSaweu+fE82eA3UkGPS2aAc8uVkctqo4/igtfRQ3du11yC8j+UpKRI2
         9JQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIT5BXlL9GG2Aaxm9GGdHvisMZ+dVAsDD+3EdATLD6FDUPhDQKWySexWCcxPO5wHKFMyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQR5Mxsbq31hPfHw93t2/MwY5oenkeQwDnvbtiV3flae9xC+dL
	iEuXyeFJK24scCq/STiBsQ1v4DOApyq1a7+5DcTGmK1n4iop++QE2gGy9bfgVnHmPtVd5/aXPdg
	r27UUGba5PTI2TwJSKN7j0QbIGjotaIUFx2qITl8UpLWVS+tqMldkug==
X-Gm-Gg: ASbGncv241M8q+FgFa+kuOppnmZ0mectRJVFCGU9jJODlX1WGft7o0ZorEALoDT9tsy
	d1IcZW9sJs+5ari13CBEv/Wp3qgpgH4BZq8k0W0Ew6KNM2fmxPtyWBBlkxYM4VHosZQp5EElMgJ
	YLLta8VcIrJaT06/shcT6zN9rQ9TGpRLooJShzTP25ORxiDb9vYrvFY+SpCCozClc2mrCQXQEoT
	bcnOaaC4+g5mNKLewepkEtuqIa0IV0Jc97kVhwwx3OlVDW5L0YuvrTBj9J0xHrT3Vs00sZFh+g0
	XsmZQrSXe0LoDTpxFW4VySd28NQujE7h1N7fRfXpsup40ICHh40U+2fG08emsFqb7XTHo50wfXr
	28zYTphfrEz7Y/Fv/0K0=
X-Received: by 2002:a05:6000:400a:b0:429:d170:b3ca with SMTP id ffacd0b85a97d-42b5939b17emr7494914f8f.55.1763278587911;
        Sat, 15 Nov 2025 23:36:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHB73C9jzGNEMJcoyLW10Er4TItRIsDuHtShghL7qOP8ieTXiS2XFBPepxs04B7pfI6xc2fg==
X-Received: by 2002:a05:6000:400a:b0:429:d170:b3ca with SMTP id ffacd0b85a97d-42b5939b17emr7494887f8f.55.1763278587413;
        Sat, 15 Nov 2025 23:36:27 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f17291sm19698512f8f.32.2025.11.15.23.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 23:36:26 -0800 (PST)
Date: Sun, 16 Nov 2025 02:36:25 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH v3 2/2] vhost: switch to arrays of feature bits
Message-ID: <8cb806c5525729cc8ed4e1f0283e86223ae9cd3f.1763278093.git.mst@redhat.com>
References: <cover.1763278093.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1763278093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The current interface where caller has to know in which 64 bit chunk
each bit is, is inelegant and fragile.
Let's simply use arrays of bits.
By using unroll macros text size grows only slightly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c   | 34 +++++++++++++++++++---------------
 drivers/vhost/scsi.c  |  9 ++++++---
 drivers/vhost/test.c  | 10 ++++++++--
 drivers/vhost/vhost.h | 42 ++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vsock.c | 10 ++++++----
 5 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index d057ea55f5ad..00d00034a97e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -69,15 +69,15 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
 
 #define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
 
-static const u64 vhost_net_features[VIRTIO_FEATURES_U64S] = {
-	VHOST_FEATURES |
-	(1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
-	(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-	(1ULL << VIRTIO_F_RING_RESET) |
-	(1ULL << VIRTIO_F_IN_ORDER),
-	VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
-	VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
+static const int vhost_net_features[] = {
+	VHOST_FEATURES,
+	VHOST_NET_F_VIRTIO_NET_HDR,
+	VIRTIO_NET_F_MRG_RXBUF,
+	VIRTIO_F_ACCESS_PLATFORM,
+	VIRTIO_F_RING_RESET,
+	VIRTIO_F_IN_ORDER,
+	VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO,
+	VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO
 };
 
 enum {
@@ -1734,14 +1734,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_net_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = vhost_net_features[0];
+		features = VHOST_FEATURES_U64(vhost_net_features, 0);
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~vhost_net_features[0])
+		if (features & ~VHOST_FEATURES_U64(vhost_net_features, 0))
 			return -EOPNOTSUPP;
 
 		virtio_features_from_u64(all_features, features);
@@ -1753,9 +1753,13 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 		/* Copy the net features, up to the user-provided buffer size */
 		argp += sizeof(u64);
 		copied = min(count, (u64)VIRTIO_FEATURES_U64S);
-		if (copy_to_user(argp, vhost_net_features,
-				 copied * sizeof(u64)))
-			return -EFAULT;
+
+		{
+			const DEFINE_VHOST_FEATURES_ARRAY(features, vhost_net_features);
+
+			if (copy_to_user(argp, features, copied * sizeof(u64)))
+				return -EFAULT;
+		}
 
 		/* Zero the trailing space provided by user-space, if any */
 		if (clear_user(argp, size_mul(count - copied, sizeof(u64))))
@@ -1784,7 +1788,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 		}
 
 		for (i = 0; i < VIRTIO_FEATURES_U64S; i++)
-			if (all_features[i] & ~vhost_net_features[i])
+			if (all_features[i] & ~VHOST_FEATURES_U64(vhost_net_features, i))
 				return -EOPNOTSUPP;
 
 		return vhost_net_set_features(n, all_features);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 98e4f68f4e3c..04fcbe7efd77 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -197,11 +197,14 @@ enum {
 };
 
 /* Note: can't set VIRTIO_F_VERSION_1 yet, since that implies ANY_LAYOUT. */
-enum {
-	VHOST_SCSI_FEATURES = VHOST_FEATURES | (1ULL << VIRTIO_SCSI_F_HOTPLUG) |
-					       (1ULL << VIRTIO_SCSI_F_T10_PI)
+static const int vhost_scsi_features[] = {
+	VHOST_FEATURES,
+	VIRTIO_SCSI_F_HOTPLUG,
+	VIRTIO_SCSI_F_T10_PI
 };
 
+#define VHOST_SCSI_FEATURES VHOST_FEATURES_U64(vhost_scsi_features, 0)
+
 #define VHOST_SCSI_MAX_TARGET	256
 #define VHOST_SCSI_MAX_IO_VQ	1024
 #define VHOST_SCSI_MAX_EVENT	128
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 42c955a5b211..af727fccfe40 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -308,6 +308,12 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 	return r;
 }
 
+static const int vhost_test_features[] = {
+	VHOST_FEATURES
+};
+
+#define VHOST_TEST_FEATURES VHOST_FEATURES_U64(vhost_test_features, 0)
+
 static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			     unsigned long arg)
 {
@@ -328,14 +334,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_test_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_TEST_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_TEST_FEATURES)
 			return -EOPNOTSUPP;
 		return vhost_test_set_features(n, features);
 	case VHOST_RESET_OWNER:
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 621a6d9a8791..d8f1af9a0ff1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/vhost_iotlb.h>
 #include <linux/irqbypass.h>
+#include <linux/unroll.h>
 
 struct vhost_work;
 struct vhost_task;
@@ -279,14 +280,39 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 				eventfd_signal((vq)->error_ctx);\
 	} while (0)
 
-enum {
-	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
-			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
-			 (1ULL << VHOST_F_LOG_ALL) |
-			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
-			 (1ULL << VIRTIO_F_VERSION_1)
-};
+#define VHOST_FEATURES \
+	VIRTIO_F_NOTIFY_ON_EMPTY, \
+	VIRTIO_RING_F_INDIRECT_DESC, \
+	VIRTIO_RING_F_EVENT_IDX, \
+	VHOST_F_LOG_ALL, \
+	VIRTIO_F_ANY_LAYOUT, \
+	VIRTIO_F_VERSION_1
+
+static inline u64 vhost_features_u64(const int *features, int size, int idx)
+{
+	unsigned long res = 0;
+
+	unrolled_count(VIRTIO_FEATURES_BITS)
+	for (int i = 0; i < size; ++i) {
+		int bit = features[i];
+
+		if (virtio_features_chk_bit(bit) && VIRTIO_U64(bit) == idx)
+			res |= VIRTIO_BIT(bit);
+	}
+	return res;
+}
+
+#define VHOST_FEATURES_U64(features, idx) \
+	vhost_features_u64(features, ARRAY_SIZE(features), idx)
+
+#define DEFINE_VHOST_FEATURES_ARRAY_ENTRY(idx, features) \
+	[idx] = VHOST_FEATURES_U64(features, idx),
+
+#define DEFINE_VHOST_FEATURES_ARRAY(array, features) \
+	u64 array[VIRTIO_FEATURES_U64S] = { \
+		UNROLL(VIRTIO_FEATURES_U64S, \
+		       DEFINE_VHOST_FEATURES_ARRAY_ENTRY, features) \
+	}
 
 /**
  * vhost_vq_set_backend - Set backend.
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ae01457ea2cd..16662f2b87c1 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -29,12 +29,14 @@
  */
 #define VHOST_VSOCK_PKT_WEIGHT 256
 
-enum {
-	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
+static const int vhost_vsock_features[] = {
+	VHOST_FEATURES,
+	VIRTIO_F_ACCESS_PLATFORM,
+	VIRTIO_VSOCK_F_SEQPACKET
 };
 
+#define VHOST_VSOCK_FEATURES VHOST_FEATURES_U64(vhost_vsock_features, 0)
+
 enum {
 	VHOST_VSOCK_BACKEND_FEATURES = (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2)
 };
-- 
MST


