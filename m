Return-Path: <kvm+bounces-64830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE6DC8CF1E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 254543B1A2C
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5213161BD;
	Thu, 27 Nov 2025 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqMckK5O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hw6jYxpx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC692C026E
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764225642; cv=none; b=hUIli88qsi1P6XkvQQNz3ahov+d85RDl3N4cP1Hs0bb9egTDAFVCCyupZLx1RgIFb/r1CMnRwUDyGG0lEUOHN++IVdGlSZtpeGzvlqzZVMqJ8wyPZi3fZDBG1qaQ9N227ORLvsg3KSisAOfmUI0AisHnmMJgEDgDPE8X2IesHgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764225642; c=relaxed/simple;
	bh=p4zBspV0umYpwlxraVSt9LbhsuCRfZnCfl2fUmVODfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ib2+clSd7SOdqDCir6C/gtKL0aB0yhJVmd04pWrzwRHcSIiIywzr2j/pl+3lTxou+h4/jLwTYbTifVEZNQvVKPXhwUeEal2L2yfvXSG58lRspKot3xLW5U+CEcGhQQpBcVgJOiEfS4JVEZtDs4bV7vW08wJam62DZwMT9m5ymPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KqMckK5O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hw6jYxpx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764225639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFZFceCxodv+sVrwXshrWOSA01PvSJh54J0xHtV2LxM=;
	b=KqMckK5OlIm5OfN8CI+1xGSUykS/5rvlMMwlRrNABDokK3BrNXgZPkoqGQqh1RnbXiepVb
	fejs+f7Ek17gzRsvoiy/lXZwp0SZ897HnLP8lgYjHMrksmm8y68TwVjIu6c/xyg6f0qv8k
	XVz9jJC7sujuR9Hu6T/flc70aji5LJ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-7x9w7DmEMZW2n0HvBu8LlA-1; Thu, 27 Nov 2025 01:40:37 -0500
X-MC-Unique: 7x9w7DmEMZW2n0HvBu8LlA-1
X-Mimecast-MFC-AGG-ID: 7x9w7DmEMZW2n0HvBu8LlA_1764225636
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477563e531cso3169625e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 22:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764225636; x=1764830436; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFZFceCxodv+sVrwXshrWOSA01PvSJh54J0xHtV2LxM=;
        b=hw6jYxpxwPKIFKJGvab+MkvyWyCbd827Ljgf6Dmmt8Hn0CT7rL62onmKBUd1VdHnAo
         YI3iylFQxACvau8rTBkosao51et2ddJBigJo1nTvpDc//3olZ3rQ801CGtD0TKVs/tb9
         eX05AFNGoP3FLX/gpXgPkH2LHie0hflArld1mja6rZGRMmKGZo0fs+9ikG6g+14KXqd+
         k5B29FvaR3vNimVFKMlOkk5bl8VMCJTDk42l6HNaWhQczgcHAly+X+FeRGpPhf+zxFiZ
         fkHQfI+81lEFGXyWG2WJmpgIdmCO3kSAIu8tB/E049IYipx3Yp3iKsFc/cXhCx5iXHLl
         Me6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764225636; x=1764830436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFZFceCxodv+sVrwXshrWOSA01PvSJh54J0xHtV2LxM=;
        b=VL9pniRqn9Bflv9erG1dud5k8adM7USghrg1SgVM2ijmecju+6iadS1snlGZBv1Tok
         9QksLZj9nj+CSO5G/JNcW2uYVEr9Z58PW6eXY18Y/WONE9v7HeSNXy/MGaoA1YA3JBK+
         sKeulpJLcu3W8e6p3pY7VRN4ZiJlX+4uagiL6hdrcQCuUz2D8l/RZuYRn2JbOquszBSH
         bsaRJgLOY1uChEPbBrZvujFLiRF+RahAyrLxyfkBl6TZJqomIiM1lzJ12UHS9YcpuPxI
         a1r8r3WmuhcPmZokpTsF+4VGwgojQE/EdXEHZrSvHAsf6QoMFobc+p+/Nt3XRJ1EU2F2
         Fqmw==
X-Forwarded-Encrypted: i=1; AJvYcCX68IH+C/s5imA22e4kdYYl6Y0zuG0B1s7cbHa8Os68ytq3yrsXA0UeDAyDA6lv/QjWw38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHBhnr7T5M3TTFub56yckiYttERaFbP0H+UXCHMTK+LQKszwjx
	sxWhmQSVL0k/T4s3vzIxWCiIHRxiMcCdLyskOYKIPWyYSCiH31fCiVltLGVp1IbWjpgmwqWrJBt
	x1q+y4e24Gm2xTCHOrrX6MOPsnLP2PGM5iezdtblLneBEx8L96gFlDw==
X-Gm-Gg: ASbGncsaD4Z1Gp6tv8/OY12CHp+uqnXp/iyaI5ynRUsqzvRP/rfvu533fX1x1kYgzqN
	Q3srCUVGCxN5Dfn8jUvn6/TYH6O58tfjfsnRwB7rddlqA197oM+ew6CZByflIqo9esmCFIfo39Q
	q4bU/3s/ROOoO4EPs7fVSUskrhqomOAmsjMkg+FVHyVhAOGoTTvMkvCr6sUAVwF4dikqHl8s1NF
	sqUg+DZ4GkCw4wN8B/quZwImyqMve1ViZX/+s4SQwcmrkOCk4lxkQSC24FKIWVQJ6H6UV/WXnBO
	r2Mq8YW+es3iOK5Hyy7bdN4Ryaa/OgV4TWOoDXtyu5QgHfGOGgwJs5SY2vuCkQdtR+chM9NjhHW
	674ny7Qkel6Df5O9gBk7XFYNbCdpyxA==
X-Received: by 2002:a05:600c:3543:b0:477:1ae1:fa5d with SMTP id 5b1f17b1804b1-477c1142268mr180867325e9.20.1764225635776;
        Wed, 26 Nov 2025 22:40:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmaKJl3GPl1IrG9e+lyxemKaHO0wPm9ET8yhjMSTC9B7Xozmw3CvG5GdadD3czzW5PwSFbkA==
X-Received: by 2002:a05:600c:3543:b0:477:1ae1:fa5d with SMTP id 5b1f17b1804b1-477c1142268mr180867165e9.20.1764225635290;
        Wed, 26 Nov 2025 22:40:35 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790b0c44dcsm78642495e9.11.2025.11.26.22.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 22:40:34 -0800 (PST)
Date: Thu, 27 Nov 2025 01:40:33 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v6 2/3] vhost/test: add test specific macro for features
Message-ID: <23ca04512a800ee8b3594482492e536020931340.1764225384.git.mst@redhat.com>
References: <cover.1764225384.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764225384.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

test just uses vhost features with no change,
but people tend to copy/paste code, so let's
add our own define.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 42c955a5b211..94cd09f36f59 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -28,6 +28,8 @@
  */
 #define VHOST_TEST_PKT_WEIGHT 256
 
+#define VHOST_TEST_FEATURES VHOST_FEATURES
+
 enum {
 	VHOST_TEST_VQ = 0,
 	VHOST_TEST_VQ_MAX = 1,
@@ -328,14 +330,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
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
-- 
MST


