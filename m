Return-Path: <kvm+bounces-37595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2638A2C5A8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15AC43A9FC2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C1923ED74;
	Fri,  7 Feb 2025 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MKKeF0Wk"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D4023ED6B
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939057; cv=none; b=oCai0A5VuB94N5HfuCTxboTggynAtjfqIFCOrb9JQ1KhOAxCV8a2gEor1JZcKATEQpQlUyjJ4Vv0W4zCYMmWYoxHjLLyTBhD/yZqw6VZunItlaIoGSAbgumXPyM7uY/MjEfL+2OYaMO+dCPNvMAxQvwNVupYWlPXrjgzx6SilBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939057; c=relaxed/simple;
	bh=UlukBu3lDwjKnWCFhT9ELicpqIX4BokGOc5s5I70Rao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqFJFdAPK37qvLSOLwQ1H2SRXrk5s7D5KPxKUUfhz5rnN+Ib1wVm/1aXNrxWSo+Z8G+Q1NeuNW0RA/+TrQmMJQtsFxNA/bzb/15rf4YYi05HiWS3NFx73ctLz9cr6iLvEoEvjbS7gTW5mLq5R4RwqkofLYuiXIvAIpn5ea99JW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MKKeF0Wk; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jqKBIjWS/VL/NerjFJ7l2smMvefEMdIXeKueSmtNuXM=; b=MKKeF0WkOdZdx0i7NBRAm39on6
	y9Zmbv3IOMDNE0uJoQ39VshYEZvnKrIUoG1hJhXrBp3oBos2Cya+Ac4rigAlMgFSqu+Kxzawoo4mJ
	CgxgnkpqM8EJ2St4+/5PMDGEtWQbz5Tb0g8WLiPJBYkhtLR+W3cYK7V4GG+I3qbW9qwNAIsmbiXZq
	/henGsqGvm0qTFwL7jLGXGjgkakz6CPFNN40julayByQ98c+Baw6d9RnQyHyDYfaKvTKIf5L0AoRF
	WZvPTj8S7xheeQgO6xnRHiyuejR6S0lHRADH+4/XFzUkMVfPltm2R3mYXCLMNvnZTEViY7l4Kcu/+
	MpZaYsxQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgPTx-0000000HBz1-3CSg;
	Fri, 07 Feb 2025 14:37:26 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgPTw-0000000080s-1T6c;
	Fri, 07 Feb 2025 14:37:24 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 2/2] hw/xen: Add "mode" parameter to xen-block devices
Date: Fri,  7 Feb 2025 14:37:24 +0000
Message-ID: <20250207143724.30792-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250207143724.30792-1-dwmw2@infradead.org>
References: <20250207143724.30792-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Block devices don't work in PV Grub (0.9x) if there is no mode specified. It
complains: "Error ENOENT when reading the mode"

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/block/xen-block.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index 034a18b70e..e61eab466c 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -408,6 +408,8 @@ static void xen_block_realize(XenDevice *xendev, Error **errp)
     }
 
     xen_device_backend_printf(xendev, "info", "%u", blockdev->info);
+    xen_device_backend_printf(xendev, "mode",
+                              (blockdev->info & VDISK_READONLY) ? "r" : "w");
 
     xen_device_frontend_printf(xendev, "virtual-device", "%lu",
                                vdev->number);
-- 
2.48.1


