Return-Path: <kvm+bounces-13398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08826895EA6
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 23:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390781C23FD2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 21:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB8E15E5DB;
	Tue,  2 Apr 2024 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlieJNnv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E415E5B5
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 21:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712092909; cv=none; b=MQF4XY+8PT14E1qFYqfVC5dKCF9glNyMrLweAxCWPrWg1CSRZaSNdwlMjcOkgKymUiq/0qJeN8qGNaccyCYIyg0rlcUzj7VkbuuWLVOoTg+4rCy9woGNuZeFkjs4RIto1FPWcnOFeWRU1C7At4n+wNtyjtjKJ87zI/3eka/Q4ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712092909; c=relaxed/simple;
	bh=CeTf1GnLqEGbq7mpbpnjAmCKKQFZ0fqT+cHVafZlASk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jwTK4PU0EpR5GFZEizMQN9YgCS9HZLkkYaFFCBU96HKNyFfJiB1RBS648A2cE+yZGni+8QjE8vzof8wCAx4bOZVLjQRZ4ChmrZkl96heRsW0n5TCGfALFEV4WDDCBDsxBNzD8CX3jGfyCCaGYIoT2+GIv2m7HT8eVJpKqTh2DB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlieJNnv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712092906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=L+alDoiqMN7Nxu8CAo+qwAjzO+OBQsTVsBJwYvjZdYY=;
	b=RlieJNnvIe2TYL+Z4mCYHUBvhV/xpI13OA2nHL7vFr5EJL7Mej3Il8yyEg9qcBlX+U48So
	dY8DB9nmEwexupwUpAPeKPeprkU6Zr1hGkweW5dmi1uYvahalRMNAD2+byu82cSca+EhEJ
	Qc5AkynbOEaF2XHEACBaDv4HRWg1rH8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-1viEs_XvN6mP1K5ICVYPVw-1; Tue, 02 Apr 2024 17:21:45 -0400
X-MC-Unique: 1viEs_XvN6mP1K5ICVYPVw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3435b7d65efso757941f8f.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 14:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712092904; x=1712697704;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+alDoiqMN7Nxu8CAo+qwAjzO+OBQsTVsBJwYvjZdYY=;
        b=SxWHHaRtL9M1Kx5koV/vriSVGsZ0UBmFPqQlG2Sb66F8grkB/5tbks8yejRlpFzNgG
         wev7fju5xHvbL6TVXCcjGqhbe1d9pc7so2lRRpAcFt90ebKqsQwNZJhfnHjk/xi4Cost
         aUd0xlYaQqu2JKrh9VLffLqv+YmYYvd9y4j/fV+0e7B9IAOuT5ddv/GgwfdwaYMCIErU
         x1VXURjk56Dg5k8I7Nf0UMhfiWUlq2P39FVO8JfsIdpE8O3ib14V66J//fjsnOofGPTq
         rbCIcVNek2YB79VdCFVRSO/RpyAlcLNoTiaYycwez/ng6Vqbpi2z8T3DuNOsrqtQFt5B
         WLVg==
X-Forwarded-Encrypted: i=1; AJvYcCX6Mg07dgEcsEhkGZZyTYpQI6f0KKONATsEiu42teV8hzZm0yMShh/h2Gw1hw57ndAdIG2v7w6bN1+8SiAGxVISHgFc
X-Gm-Message-State: AOJu0Yy24XeRzzEndMnS5s6yb24ck0NaYG3HUBkdUl+dMBNUZJmh2xTe
	dBcxazD9y7Ytwf0s5INHR2PRjIgFKvrjhYrLA5Eryp6KoMnqRUkPRi+8bylx0VrWkZN8ppyAScC
	Gra5nvECL6o4vQsOpMsszcCtSXoXi94eHXer4vwv5VFaUpSgvUQ==
X-Received: by 2002:a5d:598e:0:b0:343:4c43:b38a with SMTP id n14-20020a5d598e000000b003434c43b38amr6924833wri.17.1712092903842;
        Tue, 02 Apr 2024 14:21:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoLR2TiY4NlePQYEkpCrVsZpefzcsOU3LO3zWyGpNr1faKWUSZIEppdou1j4Es/gmuSNpz7Q==
X-Received: by 2002:a5d:598e:0:b0:343:4c43:b38a with SMTP id n14-20020a5d598e000000b003434c43b38amr6924812wri.17.1712092903398;
        Tue, 02 Apr 2024 14:21:43 -0700 (PDT)
Received: from redhat.com ([2.52.21.244])
        by smtp.gmail.com with ESMTPSA id f13-20020a1709062c4d00b00a4df82aa6a7sm6888784ejh.219.2024.04.02.14.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:21:42 -0700 (PDT)
Date: Tue, 2 Apr 2024 17:21:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH] vhost-vdpa: change ioctl # for VDPA_GET_VRING_SIZE
Message-ID: <41c1c5489688abe5bfef9f7cf15584e3fb872ac5.1712092759.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

VDPA_GET_VRING_SIZE by mistake uses the already occupied
ioctl # 0x80 and we never noticed - it happens to work
because the direction and size are different, but confuses
tools such as perf which like to look at just the number,
and breaks the extra robustness of the ioctl numbering macros.

To fix, sort the entries and renumber the ioctl - not too late
since it wasn't in any released kernels yet.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Reported-by: Namhyung Kim <namhyung@kernel.org>
Fixes: 1496c47065f9 ("vhost-vdpa: uapi to support reporting per vq size")
Cc: "Zhu Lingshan" <lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Build tested only - userspace patches using this will have to adjust.
I will merge this in a week or so unless I hear otherwise,
and afterwards perf can update there header.

 include/uapi/linux/vhost.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index bea697390613..b95dd84eef2d 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -179,12 +179,6 @@
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
-/* Get the count of all virtqueues */
-#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
-
-/* Get the number of virtqueue groups. */
-#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
-
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 
@@ -228,10 +222,17 @@
 #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
 					      struct vhost_vring_state)
 
+
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
+
 /* Get the queue size of a specific virtqueue.
  * userspace set the vring index in vhost_vring_state.index
  * kernel set the queue size in vhost_vring_state.num
  */
-#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
+#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
 #endif
-- 
MST


