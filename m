Return-Path: <kvm+bounces-53959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2C6B1AD80
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 07:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C98A18A1489
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 05:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70E5219A81;
	Tue,  5 Aug 2025 05:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDN6Pk1q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38811E5B88;
	Tue,  5 Aug 2025 05:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754370625; cv=none; b=pE5L6ypVcK7Zv5Ri/sCYgMzxKji8zK3Qn05hIOm2EAwQVFYRoGG6+r4kk0xTyuvs06C2U8pqVZ0ZrYvkgQdLz6wOvh3f4eoupF7Do+WkS8PY9PBrVXFN/Dx1PSXTdUaCNeytK+m8p84b6K0u0t1p75SmUI/PuuuAduKFluYh5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754370625; c=relaxed/simple;
	bh=rz2T/muz4Qw4k3ub258+1cVYVKlDE1bFbShc3SV/tFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ovS543nQc1Ko/rpzatOnFDGa7n7U0zd8GDOkWIXxniS5RgHj6spIDfxeqhfblsJ3PBjbwVJioaLYtJfogcd7vDkUz/K378FzvCpgKnmTGfX+KaFH1N8LJGAj8LNpDoXNKEIRVaZSjyM/Z3MiIw23PnxZIUbG7lMrtMl3W2xKdWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDN6Pk1q; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-31f314fe0aaso4335976a91.0;
        Mon, 04 Aug 2025 22:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754370622; x=1754975422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+uY4cABllPxXs/C2q+4FmYgKlnMM0alRZ+gST3WbRQE=;
        b=BDN6Pk1q1fwQVQt3DhG7jcgHOphkLOOmrBmjJ9ORRaAqPLv7rwStymuG6INZIGsfrU
         pjqWYiTA37TikMz1JZtoi851Vw4spV9XntI0qGMP4ONgg58x0aPP2U6jRRLyTApjqbcd
         VZDXN18ijWH3TUqz1JeeQ1aG+XgJv94y7iZ3OwwIVzuK1EmUfl/uPr0G0K4x87wqYE6S
         S+8HmJjw44nXmcLwfZ4lD9Z8lK56Oz4PVnf1wsZDeTC5rJNCtGKpCeaDGoz8CHYHuZm9
         /rrgVaNZXDbSy3IiBNfakX9ZihJs4oF83bEbdbP6WpXkanRr9gEkKo9NpRiUERrJpvRN
         g5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754370622; x=1754975422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uY4cABllPxXs/C2q+4FmYgKlnMM0alRZ+gST3WbRQE=;
        b=PNXV4ia1evTW38ugKg2iAkmqmnRT2vZwT0XMNtlD1mig5tqSc4pcbuF71YJuAYCMhC
         fE07SYOg566nlqkeJo51OF02XcnOcSGWtxuk4CEdxtJQhgKLBLGFcSDmYMv4ZPfPpgGd
         nP5kWA26Jwqu2qWeavE+j9fnz3v8gm3ICVla1t3c68FfpfLaVFgaV5rHg5vcRihOdQfE
         CvbAV2FB5hZ2vkmjqe0JsfYnR+pb91GMo8TuRJy+fDNT97xgS0OiTA4u8IceYSZtA2NL
         0OnojPv6Wz8obZY8BuEdu3k1NKWmEEVNVrbTHuyCGut4s8BpipivjpoHeNcqHnVPPi0W
         e+rg==
X-Forwarded-Encrypted: i=1; AJvYcCX8XarFxd1yfkLu8iAucbNstozMEHFR2NcW3vMMhTGlOdQzS6EEQMIAfJH1pGJ/iFyQJAKm8gaiFZGDw1Q=@vger.kernel.org, AJvYcCXdgeKOPer7g59Br98wqfvbDVzJizjbbDwBfbPVoRXM/Tx5IUEqm0aSyjf+BcvIe2zqT4cd5M8W@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5h3UAO3Tx3t/rNPudRFpYr2JoNTeUCmYdJdLJnWs3sTu3QLqV
	jFMfHhOL4RGo1+cgHBJpF4SlbiiRwEqQPriEiHVt3Ku9kMthM0Wdekrk
X-Gm-Gg: ASbGncuT1COBDl6cGTAfUQocY1pivjNUK+q642AML1Nfgszsa2VP8IpWhci8/68sNJh
	037HTQRTn4jRp07Glj2pYwMngY6BdC3YFspadHoNU1A22NWdLEaVoUoOGesPM7xnNfZeHYBuEi+
	HX55GlGHRcVQhL5c5yi8b3SOT1Uo32Bq+QrHTcCpWpgGIg/K7tOw0TvkI/5kDnKTmAb0uawRB9F
	BlrqEcezQTjDQa7JXgz8to0JNg1n2jKcLTJW2Kn3rQMzbky72JCI7MwkmmJW7NhK9dnaUM+JIaf
	a7D9blhZ/jaxLumD8VWdVg2t0Hvjd3+Tsz9ZCsUMW4cbOHbnWoJWJjE3ICekvMCbmk07KDqi5pd
	feGnGqgZNDTaePpI+eCkPSQBwdbigSr0tMpkB0vp5CDTD9Y4K1D353yhrx3xa
X-Google-Smtp-Source: AGHT+IHufrTKBXs+K1VueoQh9zPly7G9Z9xC6MOKli9LFxgZM7FAsVi3GX49qoHXnWhLox0TwYq8WQ==
X-Received: by 2002:a17:90b:5804:b0:31f:eae:a7e8 with SMTP id 98e67ed59e1d1-32116203b03mr19506716a91.11.1754370621958;
        Mon, 04 Aug 2025 22:10:21 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3209a850417sm13177953a91.35.2025.08.04.22.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 22:10:21 -0700 (PDT)
From: bsdhenrymartin@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To: huntazhang@tencent.com,
	jitxie@tencent.com,
	landonsun@tencent.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bsdhenrymartin@gmail.com,
	Henry Martin <bsdhenryma@tencent.com>,
	TCS Robot <tcs_robot@tencent.com>
Subject: [PATCH v1] VSOCK: fix Information Leak in virtio_transport_shutdown()
Date: Tue,  5 Aug 2025 13:10:09 +0800
Message-ID: <20250805051009.1766587-1-tcs_kernel@tencent.com>
X-Mailer: git-send-email 2.41.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Henry Martin <bsdhenryma@tencent.com>

The `struct virtio_vsock_pkt_info` is declared on the stack but only
partially initialized (only `op`, `flags`, and `vsk` are set)

The uninitialized fields (including `pkt_len`, `remote_cid`,
`remote_port`, etc.) contain residual kernel stack data. This structure
is passed to `virtio_transport_send_pkt_info()`, which uses the
uninitialized fields.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
---
 net/vmw_vsock/virtio_transport_common.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index fe92e5fa95b4..cb391a98d025 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1073,14 +1073,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_connect);
 
 int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 {
-	struct virtio_vsock_pkt_info info = {
-		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
-		.flags = (mode & RCV_SHUTDOWN ?
-			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
-			 (mode & SEND_SHUTDOWN ?
-			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
-		.vsk = vsk,
-	};
+	struct virtio_vsock_pkt_info info = {0};
+
+	info.op = VIRTIO_VSOCK_OP_SHUTDOWN;
+	info.flags = (mode & RCV_SHUTDOWN ?
+			VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
+			(mode & SEND_SHUTDOWN ?
+			VIRTIO_VSOCK_SHUTDOWN_SEND : 0);
+	info.vsk = vsk;
 
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
-- 
2.41.3


