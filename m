Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9E4BFD70
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiBVPtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 10:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiBVPtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 10:49:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878633A29
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 07:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eJIsOb+w5CZcMt9B/oMf41HlBDbj/fZfDaQTBaIcUT8=; b=VfiTpnF7MwBzjSYQ+ZXutVaslD
        kscB2K42rXeZXsiwqGVNRvVp2Ax3dvBxD4WomLO4yKcJrbSfmoeYkzSCTxjmRmu4GZ+1Y/S8kihme
        ariz/qeqwM+FRvyeNIe2oNfQZuHmODuRGtTGWHULyfE7p8w/dKpB0/4bQaeXBYSiLIBY47yU8veub
        yG1TbKDZ3oDb75tPusCETi/DbGuFYCYP/HF2g16zXHzp97llfdgggceceK+OJvmvkhLKJHLWZNKzV
        J/mkQFYNNLbQyV9MMjei9b6EW2F0IdYcsHQx/WLYeDLxE2Ubmwig1ZmtqhYZito4AGLlMk8nptrif
        MRgj3ypA==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMXPF-00AOdd-0p; Tue, 22 Feb 2022 15:48:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH] vhost: use bvec_kmap_local in {get,put}u16_iotlb
Date:   Tue, 22 Feb 2022 16:48:47 +0100
Message-Id: <20220222154847.597414-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vhost/vringh.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 14e2043d76852..0f22a83fd09af 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1173,7 +1173,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 			       u16 *val, const __virtio16 *p)
 {
 	struct bio_vec iov;
-	void *kaddr, *from;
+	void *kaddr;
 	int ret;
 
 	/* Atomic read is needed for getu16 */
@@ -1182,10 +1182,9 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
-	from = kaddr + iov.bv_offset;
-	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_atomic(kaddr);
+	kaddr = bvec_kmap_local(&iov);
+	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)kaddr));
+	kunmap_local(kaddr);
 
 	return 0;
 }
@@ -1194,7 +1193,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 			       __virtio16 *p, u16 val)
 {
 	struct bio_vec iov;
-	void *kaddr, *to;
+	void *kaddr;
 	int ret;
 
 	/* Atomic write is needed for putu16 */
@@ -1203,10 +1202,9 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
-	to = kaddr + iov.bv_offset;
-	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_atomic(kaddr);
+	kaddr = bvec_kmap_local(&iov);
+	WRITE_ONCE(*(__virtio16 *)kaddr, cpu_to_vringh16(vrh, val));
+	kunmap_local(kaddr);
 
 	return 0;
 }
-- 
2.30.2

