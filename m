Return-Path: <kvm+bounces-59705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9881BBC8C7D
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 13:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 04EE94F9208
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 11:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF212E2DDD;
	Thu,  9 Oct 2025 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbgLN13p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F91B2E1F13
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760009065; cv=none; b=b9U1COB/mAqKoMnCRBZGomFpHwOedeeCwKoWmBPafBZ2YJwnSQyiRv/D4FW5MuUBGIqMbADRpS8UKLgPZek8KF5/RIeJbQeskDR8H21U9nWw5PQRIF0GoVXHpZdCsq5SD2yKji+PybzVRgsONSrasHuA5yr6IzSaN2IsjQVYRg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760009065; c=relaxed/simple;
	bh=35UYEAy9Siw0O4CbsRPOR1KpEIW1hIqotirWcRQXYGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FpF1vserJwhmyfIj3yXXM6XxfJFMyeNd13A8nZMyG8TuW0J/+A01CiNShIiE4689ltE8hxBgttsaxmJsX2yxi8dwVnFxEbGwtlcUpDb+xb10+QBMYUCCvjgAcsLxz/b3lKmQRRZzjCmA3YDTYrU/E8c4++C5kPe+qg36YazzlJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HbgLN13p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760009062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S+cs/cFEiq3598A0wbNjyWy5VUcCWcxIxlRvjHMyPY8=;
	b=HbgLN13pHSo1bIaTqcPt7wfzKEHYNIgS6HVeFIyfkuuxlvqyXtliDOReoXdZWSupm3g+tt
	8L5XsWOP6vvzdQw5G5MRAt8ECkcKVHo0oXA2Yhu9GdxUmFjGJHLVuh9iEpf9QG4F+Ks4V0
	WY9RtGG1t3yyqP9fZ8BoijcVy/HbZVM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-NISkkdseMZm42r_G5ooinQ-1; Thu, 09 Oct 2025 07:24:21 -0400
X-MC-Unique: NISkkdseMZm42r_G5ooinQ-1
X-Mimecast-MFC-AGG-ID: NISkkdseMZm42r_G5ooinQ_1760009061
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-872d1a88c7dso430072985a.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 04:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760009061; x=1760613861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+cs/cFEiq3598A0wbNjyWy5VUcCWcxIxlRvjHMyPY8=;
        b=fIjoFthYRMg3iQ5p1LidHUgc6IGgPy3fy1GdbN/xhifLe+iAlJTTuSzTEEa7AcVw3S
         i1bRRwvTXXLN/gj7VVUeWRo9SDWmUkAhWyWtqWnD7u37Wggr7lJcVv3vGssY2iAxAgDi
         YixqPreuYniDQnWoo6G0hWUZmxAPLGweuZSj2WVc//Z5OHIBEQ3KaQVCGmUw7Wt1XXMD
         UJBc63CYV8dH7zGMH7+7p7elp51jnZoJejlsZEJW4iokbIMqMwlkw3AuGvzp4NtRVxL6
         paNjfN6AMULDB2ndQJdo365mNUZdFM1iZ/bMMlaRgHBf9Q6dzXYwevoh2jURtVQUDAnR
         us3A==
X-Forwarded-Encrypted: i=1; AJvYcCWUr3toH5+m0gNXuFCz4LvsQInG37m2I5gzma5+5VlIPR4TZ7yaY3gveUqMqbyjUItY5tw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNLrIv6WHAIWoYDcyvn/0LURM1iQEUKojq0Aywr6gyanR38p/N
	qRn3KRg1YRizDqhxLYNBFpHaP9MNKY9JNuzbYoEfeh7jGwPmXygRICk9pZn5wvZ/yqbmCtu5HrU
	f90I4GKDHL+ovbhAMFSyFX6G8ZPc89ov0a2Rzpe7PPbbB1UAKpnc9Mw==
X-Gm-Gg: ASbGnctzn9mXfDFVRZVF1Pwk1X45PrHsA3alDcvOK3LV9hEIORKr0aUIPuVA/+11fUj
	CQ8xOi0NI0oVEWrBZO/AHbmXcUv37tAxlhF9sJAcSyE5xkTcwnWaelFWWWnWbOiqygKqJdr396s
	mOPVNTmwoJ5OVBi2qSZwsN8wCUxsPnQuLvGDUaDiKfulSUTu+ahBWBk53/x3U8hF45gmoqN29SD
	FJU9sBP8eEcwnxGyyxqp4Ka6fZtYJgYlmib2NLYERB93SvU6KfkB79HcA/pQVjU7SebaDs2qFG0
	4poaRdJH3iGMr91SJqCwv6tN0DgBBaFLbcU=
X-Received: by 2002:ad4:4ee3:0:b0:802:3b85:ee18 with SMTP id 6a1803df08f44-87b2dbf70c7mr98352966d6.36.1760009060743;
        Thu, 09 Oct 2025 04:24:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvx4dSk41JvbEZka6APS8zgOi8sdCQFv4O7dgaejzBvc7AARV8O85qCp/D4IeK5PK1183PNw==
X-Received: by 2002:ad4:4ee3:0:b0:802:3b85:ee18 with SMTP id 6a1803df08f44-87b2dbf70c7mr98352316d6.36.1760009060013;
        Thu, 09 Oct 2025 04:24:20 -0700 (PDT)
Received: from redhat.com ([138.199.52.81])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bbb1cf52sm181311206d6.28.2025.10.09.04.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 04:24:19 -0700 (PDT)
Date: Thu, 9 Oct 2025 07:24:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 3/3] vhost: use checked versions of VIRTIO_BIT
Message-ID: <6629538adfd821c8626ab8b9def49c23781e6775.1760008798.git.mst@redhat.com>
References: <cover.1760008797.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760008797.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

This adds compile-time checked versions of VIRTIO_BIT that set bits in
low and high qword, respectively.  Will prevent confusion when people
set bits in the wrong qword.

Cc: "Paolo Abeni" <pabeni@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c             | 4 ++--
 include/linux/virtio_features.h | 9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 43d51fb1f8ea..8b98e1a8baaa 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -76,8 +76,8 @@ static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
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
index f41acb035af9..466f7d8ed5ba 100644
--- a/include/linux/virtio_features.h
+++ b/include/linux/virtio_features.h
@@ -9,6 +9,15 @@
 #define VIRTIO_FEATURES_DWORDS	(VIRTIO_FEATURES_QWORDS * 2)
 #define VIRTIO_BIT(b)		BIT_ULL((b) & 0x3f)
 #define VIRTIO_QWORD(b)		((b) >> 6)
+
+/* Get a given feature bit in a given qword. */
+#define VIRTIO_BIT_QWORD(bit, qword) \
+	(BUILD_BUG_ON_ZERO(const_true(VIRTIO_QWORD(bit) != (qword))) + \
+	 BIT_ULL((bit) - 64 * (qword)))
+
+#define VIRTIO_BIT_LO(b) VIRTIO_BIT_QWORD(b, 0)
+#define VIRTIO_BIT_HI(b) VIRTIO_BIT_QWORD(b, 1)
+
 #define VIRTIO_DECLARE_FEATURES(name)			\
 	union {						\
 		u64 name;				\
-- 
MST


