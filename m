Return-Path: <kvm+bounces-59910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E3ABD4AE3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 092B2540759
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74529311976;
	Mon, 13 Oct 2025 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H76ihorC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B830DEB6
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369193; cv=none; b=nQqbTg5pXpE7nLLhUgQU/LhCpMSl+iqvfeqy6ufr0iR5grVCWObE9iU6K2iaRs5SNRTnRvsFc2ly7ATJLMxDU5hTIdWi2lg/fj/ncpaRjHx+T4q8mXT88HH2EGSS/tlDKAxRz2tU8+snH3HEhYME9hFI7Zy3b9OY0jw92cizwvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369193; c=relaxed/simple;
	bh=gR+HxQZ5Ps5HzOMs2Fd2vwAZAI0viEAdbAcy/yn+CaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VtCPOpZk4nI/eok9BY25Hl6QlDBU00PdEfhlaZQF70dWdIWnq/AcuJnEHeUwgJ1v3uYB/VHP7I6LrsVKHNVbAfX7ofPE1TxYTsrxlDWVL/FEUPwHXMp4rM5inuN6f8Z9618gfz77tO6vq3i3JpHnyoxRSQvBIwtekKy/Ld+7Nfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H76ihorC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760369190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7+wzjnqJB4THueAfimc/qkfTpa1defvaMULnsvxNcPo=;
	b=H76ihorC1DTSA7IACcmsGys8jU8MZBWWGjY0hQyAQ/mfIFIFsAVUNM4i8n1+P/hYPXlWiq
	kvUn/7aefWH7RI693tAX8ZW6LIZo318IXtJ8Y1kLsCA2LJv/N0qjD8fLhfKK8DoZI9rVyL
	y1YpMT1spzUra4/igDAT2WZ3I96OkWo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-rsEQL3-hP9-AmLqB_In2pA-1; Mon,
 13 Oct 2025 11:26:26 -0400
X-MC-Unique: rsEQL3-hP9-AmLqB_In2pA-1
X-Mimecast-MFC-AGG-ID: rsEQL3-hP9-AmLqB_In2pA_1760369183
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D8C71800357;
	Mon, 13 Oct 2025 15:26:23 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.89.76])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2A701954107;
	Mon, 13 Oct 2025 15:26:19 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex@shazbot.org,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liulongfang@huawei.com,
	kwankhede@nvidia.com,
	yishaih@nvidia.com,
	ankita@nvidia.com,
	jgg@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	brett.creeley@amd.com,
	eric.auger@redhat.com,
	giovanni.cabiddu@intel.com,
	dmatlack@google.com,
	pbonzini@redhat.com,
	torvalds@linux-foundation.org
Subject: [PATCH] MAINTAINERS: Update Alex Williamson's email address
Date: Mon, 13 Oct 2025 09:26:11 -0600
Message-ID: <20251013152613.3088777-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Switch to a personal email account as I'll be leaving Red Hat soon.

Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

I'll intend to send this via a signed tag pull request during
v6.18-rc.  Thanks

 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index d2edd256b19d..ace467e3d0e2 100644
--- a/.mailmap
+++ b/.mailmap
@@ -27,6 +27,7 @@ Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
 Aleksandar Markovic <aleksandar.markovic@mips.com> <aleksandar.markovic@imgtec.com>
 Aleksey Gorelov <aleksey_gorelov@phoenix.com>
+Alex Williamson <alex@shazbot.org> <alex.williamson@redhat.com>
 Alexander Lobakin <alobakin@pm.me> <alobakin@dlink.ru>
 Alexander Lobakin <alobakin@pm.me> <alobakin@marvell.com>
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..2d2e9da401d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26874,7 +26874,7 @@ S:	Maintained
 F:	drivers/vfio/cdx/*
 
 VFIO DRIVER
-M:	Alex Williamson <alex.williamson@redhat.com>
+M:	Alex Williamson <alex@shazbot.org>
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git https://github.com/awilliam/linux-vfio.git
@@ -27037,7 +27037,7 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/test-drivers/vimc/*
 
 VIRT LIB
-M:	Alex Williamson <alex.williamson@redhat.com>
+M:	Alex Williamson <alex@shazbot.org>
 M:	Paolo Bonzini <pbonzini@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Supported
-- 
2.51.0


