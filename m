Return-Path: <kvm+bounces-648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD377E1E95
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D2B281406
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F138182BF;
	Mon,  6 Nov 2023 10:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fKwQs5UA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7918030
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:40:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3655D136
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4uz818AY0/m+FRzGeIhGz1ZTqpxzLihnWApmCN46dps=; b=fKwQs5UAJQKDc4KMhJikM8x0P+
	jPOTGf+YxCgZTG/biDh3QzX3JwAbu0gE40tBY8XR/RZ3HilkTvWvdgtoMbVM/GryZUjrqPv/srYx4
	+ipkc9VhfDcYvAyXEPUXUUHSwPPlvgV05kdutHUN0YQWlbfVFPhtzdPr9P3gzllPa+c2RQrgYl6xO
	6BYbsvGDvWMmLVvsAho+MJkjTcjB/wbjsPkkpXi882fTxrvbre3s1QCQSJw92wKxWoLxH0GOWQ49U
	osQBPzD5cm4z9Xb9QrnOHQjCv0800KW3Xgu428Cxh5JoUgybYy4O1wohQagI+6cxYjmo5Ua7CiFYT
	qbjp+IOg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qzx1P-005R1j-Rh; Mon, 06 Nov 2023 10:39:56 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1qzx1Q-000qGL-0i;
	Mon, 06 Nov 2023 10:39:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	qemu-stable@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 7/7] hw/xen: use correct default protocol for xen-block on x86
Date: Mon,  6 Nov 2023 10:39:55 +0000
Message-ID: <20231106103955.200867-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106103955.200867-1-dwmw2@infradead.org>
References: <20231106103955.200867-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Even on x86_64 the default protocol is the x86-32 one if the guest doesn't
specifically ask for x86-64.

Cc: qemu-stable@nongnu.org
Fixes: b6af8926fb85 ("xen: add implementations of xen-block connect and disconnect functions...")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/block/xen-block.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index a07cd7eb5d..bfa53960c3 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -115,9 +115,13 @@ static void xen_block_connect(XenDevice *xendev, Error **errp)
         return;
     }
 
-    if (xen_device_frontend_scanf(xendev, "protocol", "%ms",
-                                  &str) != 1) {
-        protocol = BLKIF_PROTOCOL_NATIVE;
+    if (xen_device_frontend_scanf(xendev, "protocol", "%ms", &str) != 1) {
+        /* x86 defaults to the 32-bit protocol even for 64-bit guests. */
+        if (object_dynamic_cast(OBJECT(qdev_get_machine()), "x86-machine")) {
+            protocol = BLKIF_PROTOCOL_X86_32;
+        } else {
+            protocol = BLKIF_PROTOCOL_NATIVE;
+        }
     } else {
         if (strcmp(str, XEN_IO_PROTO_ABI_X86_32) == 0) {
             protocol = BLKIF_PROTOCOL_X86_32;
-- 
2.41.0


