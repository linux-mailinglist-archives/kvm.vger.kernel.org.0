Return-Path: <kvm+bounces-47755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF14AC4855
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E550316DA53
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A90C1F460B;
	Tue, 27 May 2025 06:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=debian.org header.i=@debian.org header.b="mFUfyBrl"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.netfort.gr.jp (mx2.netfort.gr.jp [153.126.132.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F38F1E521D;
	Tue, 27 May 2025 06:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=153.126.132.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326984; cv=fail; b=NntrnDARrxG40oxOUffUIugIHaeyKTojq8WhhHsN4zUW4WjTUye97/w6Dv9pdHIo1MIYcAVl1gQI6xLf8nqfFOFxxKaCL55G3sn85Cxfa73UgINAm7ZVJ6Tqkz37JvL702ZAW+k7cSAUm6jgLnGe1QLq6VpufmlTHJHp9hOCgG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326984; c=relaxed/simple;
	bh=cv5PqhuODUa4Fv3oViJQ822Ih46ebETcLVj0zg54N2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mZD6dydywM/ha4SeE1/1s9CNLVv7rMxs3eHJf6UgGuAixcInf0ggH4VctE7VmrWFCmBOlu9EGgoK1wqfCCGTbSr53c3ihasa5ERYtB7U5s01qtBZjIH/9QRKzoyoz78vdKhKQItwECpH//6MGorVKAVb8pC653ORG2547z+M59I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=fail (0-bit key) header.d=debian.org header.i=@debian.org header.b=mFUfyBrl reason="key not found in DNS"; arc=fail smtp.client-ip=153.126.132.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Received: from localhost.localdomain (localhost [IPv6:::1])
	by mx2.netfort.gr.jp (Postfix) with ESMTP id B46205FACE;
	Tue, 27 May 2025 15:23:00 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=debian.org; s=selector1;
	t=1748326980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGMDmbtQ8UaCk9EvT941LLKKCCXUMjMOrCLiTn0R4R4=;
	b=mFUfyBrlNTJYk9h3V4QaqbIbD7IzbNGMDTfqto90C5pAaMkBGG8NQ0aUGI7SrxV/r/xOqm
	Ug1skgAWlbS8zYcjvWUQstHaYVLm9fQ/sLZurwfyDYsogHhuEXfo4oieE2V5dOPwUROfXv
	Bq6BKNWi+S9uzGoaeVPuRDsWeOMxzbc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=debian.org;
	s=selector1; t=1748326980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGMDmbtQ8UaCk9EvT941LLKKCCXUMjMOrCLiTn0R4R4=;
	b=M7qXdmnyWEvmeexh8I7ySZu9vqr4UkO8BIbrY+j6vig5jM06qfJyk77DS9RacKQLrsDM/c
	KeJ/hVozQM25rW0GsNGmZu0kOj8IbGMKJRA8rK40C2lKuCIda7PX7gorA7ASbotZlHWYg1
	OucYilvUGkxEiVA/PZjWy06fnH4QImE=
ARC-Authentication-Results: i=1;
	mx2.netfort.gr.jp;
	none
ARC-Seal: i=1; s=selector1; d=debian.org; t=1748326980; a=rsa-sha256;
	cv=none;
	b=YUi1nPkzrWD+LjXyEDLgaYPL+YrG98/n23tPt63I5hWd2ZBryMtYc7yXE5pRpTt63epAZU
	sPmzE6LNdwIt5RDu7BUowH9Py7i3KjBr3YXTMQpaCPRhvAvOEJtcfC52OimZcY8tqMXyKg
	Hq1f76R0taTNtX6Ve2V5TMTzz4NzVHs=
From: dancer@debian.org
To: mst@redhat.com
Cc: qemu-devel@nongnu.org,
	adelva@google.com,
	uekawa@chromium.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	Junichi Uekawa <dancer@debian.org>
Subject: [PATCH] Fix comment for virtio-9p
Date: Tue, 27 May 2025 15:22:20 +0900
Message-Id: <20250527062220.842342-1-dancer@debian.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527041123.840063-1-dancer@debian.org>
References: <20250527041123.840063-1-dancer@debian.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Junichi Uekawa <dancer@debian.org>

virtio-9p is not a console protocol, it's a file sharing protocol. Seems
like an artifact of old copy-and-paste error.

Fixes: 3ca4f5ca7305 ("virtio: add virtio IDs file")
Signed-off-by: Junichi Uekawa <dancer@debian.org>
---
 include/uapi/linux/virtio_ids.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 7aa2eb766205..747e93a91920 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -37,7 +37,7 @@
 #define VIRTIO_ID_IOMEM			6 /* virtio ioMemory */
 #define VIRTIO_ID_RPMSG			7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI			8 /* virtio scsi */
-#define VIRTIO_ID_9P			9 /* 9p virtio console */
+#define VIRTIO_ID_9P			9 /* virtio 9p file sharing protocol */
 #define VIRTIO_ID_MAC80211_WLAN		10 /* virtio WLAN MAC */
 #define VIRTIO_ID_RPROC_SERIAL		11 /* virtio remoteproc serial link */
 #define VIRTIO_ID_CAIF			12 /* Virtio caif */
@@ -79,6 +79,6 @@
 #define VIRTIO_TRANS_ID_CONSOLE		0x1003 /* transitional virtio console */
 #define VIRTIO_TRANS_ID_SCSI		0x1004 /* transitional virtio SCSI */
 #define VIRTIO_TRANS_ID_RNG		0x1005 /* transitional virtio rng */
-#define VIRTIO_TRANS_ID_9P		0x1009 /* transitional virtio 9p console */
+#define VIRTIO_TRANS_ID_9P		0x1009 /* transitional virtio 9p file sharing protocol */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.39.5


