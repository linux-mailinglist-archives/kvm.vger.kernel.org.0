Return-Path: <kvm+bounces-47744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 861B3AC4731
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EF1C7A9B25
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 04:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68681D5165;
	Tue, 27 May 2025 04:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=debian.org header.i=@debian.org header.b="yYnS8vmN"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.netfort.gr.jp (mx2.netfort.gr.jp [153.126.132.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103BD5464E;
	Tue, 27 May 2025 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=153.126.132.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748319407; cv=fail; b=WtjpwN/DtPOZUP7uJJ5Muw40i7JOufkKCDltc4JswifVhzruwjelNKv2wWq5H5LQLpQVyLh7sPnWQJqv/PZu2sJpjDCKF/Y/PYJ47DncHCoQvgu7yEvvha9wHQmsq+yWUQiTzi3K25aITbVDew4ATi5GFi8S4WhKYganHUBnwj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748319407; c=relaxed/simple;
	bh=ziaQqO1A9/1mMs/3cBHQUsKCE4UzRmUMuEss55hv/nw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZQlr0hU7bZvdYScllquKWtq/L3yzzBdqs6rrriGeJYm6bg3OjiE+rb4/yGI8jzXI+b9jJddAncHUoCZbRKIBZAEEre839yMSvQcekjUc5MtCj9XVeL63u+dVPVCMOSxzZMI+fakma1dQS+tc2dsTyAN0Eyhq7YtgG/KP3oN7/ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=fail (0-bit key) header.d=debian.org header.i=@debian.org header.b=yYnS8vmN reason="key not found in DNS"; arc=fail smtp.client-ip=153.126.132.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Received: from localhost.localdomain (localhost [IPv6:::1])
	by mx2.netfort.gr.jp (Postfix) with ESMTP id 3FD1B5FACE;
	Tue, 27 May 2025 13:11:25 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=debian.org; s=selector1;
	t=1748319085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3v7be1f/CX26xwm33bkMhE4PM2rqH6kLl8sWw3wQMng=;
	b=yYnS8vmNPhh6e4ObGS8nOaNmgubtvDv3hyYS9NbQFe1oAfmImln9146Buas7qEAdwd7o8W
	IdeJIfkc0GzML5Gv9o09wdkAfUrOPsnFhxnbhS7jnkXzO99rSmz+LxfepsC6E4ipxG8Qp1
	BVN+sOZ6maEiDjo/SlY1/IdaImYeS8s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=debian.org;
	s=selector1; t=1748319085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3v7be1f/CX26xwm33bkMhE4PM2rqH6kLl8sWw3wQMng=;
	b=JYClznlIQ7csvSvFJ3NaFAADvvywCvtVBgCMb1GnITrwb21qkWlquWot/baXhE2EhV5FHp
	7jJa4zYZ/gdlmERx0G9pqeozJgK+hlovRrj3DfZia6Ei/xuMpecryCMjRIRbeVXF0Noyl7
	Gm937LIte9S3JTHLxS8IVhU5VjHr+G8=
ARC-Authentication-Results: i=1;
	mx2.netfort.gr.jp;
	none
ARC-Seal: i=1; s=selector1; d=debian.org; t=1748319085; a=rsa-sha256;
	cv=none;
	b=jT2pSYX+oNqT0xrqXfCfTd5QfZoLdU0lTXT+TL5Y3Yb0GN6gukNJWHZ4H0+aq5fEighz06
	2q4qvxU/ZPafxak8Azrc5wWVyeTUGm3pR4nNowQjXgg8jeSpk1yauWpAni11sIdcVcG4tU
	A0XC/amUvDK3L+K/lw8XtaPEZ6Gzi9I=
From: dancer@debian.org
To: mst@redhat.com
Cc: qemu-devel@nongnu.org,
	adelva@google.com,
	uekawa@chromium.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH] Fix comment for virtio-9p
Date: Tue, 27 May 2025 13:11:23 +0900
Message-Id: <20250527041123.840063-1-dancer@debian.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Junichi Uekawa <uekawa@chromium.org>

virtio-9p is not a console protocol, it's a file sharing protocol. Seems
like an artifact of old copy-and-paste error.

Fixes: 3ca4f5ca7305 ("virtio: add virtio IDs file")
Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
---
 include/uapi/linux/virtio_ids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 7aa2eb766205..deb9dfa52944 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -37,7 +37,7 @@
 #define VIRTIO_ID_IOMEM			6 /* virtio ioMemory */
 #define VIRTIO_ID_RPMSG			7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI			8 /* virtio scsi */
-#define VIRTIO_ID_9P			9 /* 9p virtio console */
+#define VIRTIO_ID_9P			9 /* virtio 9p */
 #define VIRTIO_ID_MAC80211_WLAN		10 /* virtio WLAN MAC */
 #define VIRTIO_ID_RPROC_SERIAL		11 /* virtio remoteproc serial link */
 #define VIRTIO_ID_CAIF			12 /* Virtio caif */
-- 
2.49.0.1164.gab81da1b16-goog


