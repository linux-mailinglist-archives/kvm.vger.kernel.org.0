Return-Path: <kvm+bounces-68389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FD1D38736
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BC803139DAC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF493A4AC1;
	Fri, 16 Jan 2026 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rip9RKY6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ervu5u3W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3697E2F3624
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594526; cv=none; b=VG37+qb76gG9aPyWumJXsRn9DV3kE3pRDraGP5Cm1f+QnFRqxSg7H1cuTTALjdyTi/rtj1mEK1Fm0sotGguo/GxWyzzxDLaaLGxfY64inz4BPgbrsDKmOQYA0oc6KJ2coBVrwypB6qfgbD9N31WcCb8rrfxRLRbJ/p+ImW0P0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594526; c=relaxed/simple;
	bh=ViVCTMWsZOBUvDZkBJy4R4gHYmuB/wp4Twq+n+RK/10=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hIJGSMvN5FyEbAZAlxUCSI7B7ybPJTl6n44fHXS5jjFWxxU/nUZA+JBuZ75nc6er4syCIOo6Voj4c+sUgt2tDQ8qVs89tgJOjiKl4r1YAdOfI4T9W1KlTkVbeuGsBGJ0M23oHvXHOMslFgpWQgW129nHpHNcQ6Gx9rXOWJMIs+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rip9RKY6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ervu5u3W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aokF+MKwgeAstmCjHO7lVmWSXdkq7v/KNJPU3598T+g=;
	b=Rip9RKY6H6XPuN0b3vaIsLJUa6Lz4Lzj6eMuO5Oro+qHXItj2nqjMnaBEOjDlIfccluIZ2
	g6hUWr8OAnL6bYIQJD7JRPK8FvlJWqQT3XfikV6CJrHtBzzakUIl+YJyomNqgYh0UhdQl+
	ETFZcYnv7i6pcVwQ5w1EP8YFtEO6Yfw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-3tS_Hz7gNauw8gkzPegs_w-1; Fri, 16 Jan 2026 15:15:22 -0500
X-MC-Unique: 3tS_Hz7gNauw8gkzPegs_w-1
X-Mimecast-MFC-AGG-ID: 3tS_Hz7gNauw8gkzPegs_w_1768594521
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47ee8808ffbso22825935e9.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594520; x=1769199320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aokF+MKwgeAstmCjHO7lVmWSXdkq7v/KNJPU3598T+g=;
        b=Ervu5u3WqeE00GZCKCJqNmQMRMCsg4Da+4+mti27TLgpxjLGWg2M1h2LMG/sK9GMCo
         yjYBSExNEySC3LUHDmajGyjgXnX92DWZpZREKDBPU6fGcMFDZ18XIk/dT88zwO9GDAMx
         L8T+SgunEG5YHXjLUdylnY8w1/zu6KYIwE/C0NE2uj8EiWTB7LCuNs5VvrlwLDfYvuLv
         ec0aNnAns4p049ZdWn+VIbqa/Ed1b42RfQDOopQoPVJzp5l9jZibKtOsAlgHooHkL/YX
         i5fNn2uBNx5rPmfcjPUJ55lBKF9Ms8XrgINMPNd96uSGcmokvghXTU7tcFkKZSCD88qI
         UIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594520; x=1769199320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aokF+MKwgeAstmCjHO7lVmWSXdkq7v/KNJPU3598T+g=;
        b=gdBaN6VyEH7JAWnim2xsoyJbV6Tjx99HYNAuYPSdGBRcHdzQFgoTukwzPqD4Cpb0PN
         YPi4PLCWf3ljSOSaQ1jBizvoLxrr8zptWje9DpVuUY0nUvRD1j1j4XIIbYI43k3OUn1s
         e6qYBdQ6OpiCp3nDLF3n6YJTbvds78/gb17uKsRG35UBKpHVxxJYcBqsWKiSv7aoKHf/
         caP2dws/KGCyoyBSHjdpgSoO6csGblU2HzTlCMpLuzkcffRCGNJvxa3MSzaKoernWfrQ
         QClRxqRu/6HwG/KR0xPgJo2mRk3pUXZgJbgU1UQ66+82VKgjwq9JFfa3bH/RCwcVH1UI
         WfjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqs5WP9BmR6haJVE0ruG7vAePuDA1lHjd5vfAB1L9pLzYJ/91Q3W9M3/nDPgJW2yPCMik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVWl07XOfFqVnyQZcYqCsz7rRUSqjVc4h0Vr9j2BmqltYlWDzJ
	9cDMe7cTQh7KJnYBGqub79jrBj7kYYH0yVYuSuYAePTchjoGny4/eSLc7tjQONU3oolf2WWJvLl
	YIvfWY4E3DZiQPI++YlbarnLoQt+F0/fq1NcWTAV9UF+Qr/GslJNwqR5/AtYlpg==
X-Gm-Gg: AY/fxX6d43lI25gArHyuOvUM570BxhhagwijT4sgkE9bhTjaJhMEFIz5KeEWvXJKzKC
	e2c/b1sPPmzfW+JYRND4UU3fTf31Ye40z0XIA9DiV5toGGfxZhG4PxMpHke5Kxy8nPPcLafjDkF
	EoXxP3Kbdvp+jKBJW53etTw+u6EEojbso32l5rk3HhJO6zIAqVDrnoaqgrK7j45FihAcr48l+Rg
	q3lvxoWzdxuW0ZnBQnQXf00oCpWHTBkzwC7wtb3JVprlgQlaxsWTlxL8gZQn5VU4t1Qwg3qlpq4
	XE+zREkV0FIIqqjDUwM71b9yhGC+CnqB3bDHeMwcSHmTmMoZaDFBAGZDnzjYTVFBrqA+uDAHKsB
	6nDdyTDfshXxxBw6uTBISf5OEiKa7SR/GKH3rYoIqhXSjAZpSG3S6yvJjOxgd
X-Received: by 2002:a05:600c:3494:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-4801e33a85bmr58520575e9.22.1768594520524;
        Fri, 16 Jan 2026 12:15:20 -0800 (PST)
X-Received: by 2002:a05:600c:3494:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-4801e33a85bmr58520355e9.22.1768594520094;
        Fri, 16 Jan 2026 12:15:20 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435699271easm7009669f8f.14.2026.01.16.12.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:15:19 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: virtualization@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	kvm@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Asias He <asias@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH RESEND net v5 0/4] vsock/virtio: fix TX credit handling
Date: Fri, 16 Jan 2026 21:15:13 +0100
Message-ID: <20260116201517.273302-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resend with the right cc (sorry, a mistake on my env)

The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till
v4: https://lore.kernel.org/netdev/20251217181206.3681159-1-mlbnkm1@gmail.com/

Since it's a real issue and the original author seems busy, I'm sending
the v5 fixing my comments but keeping the authorship (and restoring mine
on patch 2 as reported on v4).

From Melbin K Mathew <mlbnkm1@gmail.com>:

This series fixes TX credit handling in virtio-vsock:

Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
Patch 2: Fix vsock_test seqpacket bounds test
Patch 3: Cap TX credit to local buffer size (security hardening)
Patch 4: Add stream TX credit bounds regression test

The core issue is that a malicious guest can advertise a huge buffer
size via SO_VM_SOCKETS_BUFFER_SIZE, causing the host to allocate
excessive sk_buff memory when sending data to that guest.

On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
32 guest vsock connections advertising 2 GiB each and reading slowly
drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
recovered after killing the QEMU process.

With this series applied, the same PoC shows only ~35 MiB increase in
Slab/SUnreclaim, no host OOM, and the guest remains responsive.

Melbin K Mathew (3):
  vsock/virtio: fix potential underflow in virtio_transport_get_credit()
  vsock/virtio: cap TX credit to local buffer size
  vsock/test: add stream TX credit bounds test

Stefano Garzarella (1):
  vsock/test: fix seqpacket message bounds test

 net/vmw_vsock/virtio_transport_common.c |  30 +++++--
 tools/testing/vsock/vsock_test.c        | 112 ++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.52.0


