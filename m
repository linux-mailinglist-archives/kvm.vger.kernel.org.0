Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D079FF93
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbjINJH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbjINJHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:07:22 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB4A1BF8;
        Thu, 14 Sep 2023 02:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=9p3EjojVRcDnVHSKvpUes+XfyD1e4JyIwNQ5PTtGcrY=; b=iaGoPaMU1xJDSwLQtlFxK98q7w
        9gB7UIN7MNlXhzpjT49l8Og3mntPxeCxNaqhwfldq7mC5LrcXs4mOSsHUnYJpMNHzv9WG9wkfjsDi
        9OAL2QpTuseE7UF7Xf8cvniJ+r6aXUbKe8DPtPFmot/SwED8zjXa6EVZTpQcWQ0lTAhI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3J-0001ij-Ab; Thu, 14 Sep 2023 08:50:21 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qgi3J-0002T9-3L; Thu, 14 Sep 2023 08:50:21 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/8] KVM: pfncache: base offset check on khva rather than gpa
Date:   Thu, 14 Sep 2023 08:49:42 +0000
Message-Id: <20230914084946.200043-5-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914084946.200043-1-paul@xen.org>
References: <20230914084946.200043-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

After a subsequent patch, the gpa may not always be set whereas khva will
(as long as the cache valid flag is also set).

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 virt/kvm/pfncache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 17afbb464a70..37bcb4399780 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -83,15 +83,18 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!gpc->active)
 		return false;
 
-	if ((gpc->gpa & ~PAGE_MASK) + len > PAGE_SIZE)
+	if (gpc->generation != slots->generation)
 		return false;
 
-	if (gpc->generation != slots->generation || kvm_is_error_hva(gpc->uhva))
+	if (kvm_is_error_hva(gpc->uhva))
 		return false;
 
 	if (!gpc->valid)
 		return false;
 
+	if (offset_in_page(gpc->khva) + len > PAGE_SIZE)
+		return false;
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_check);
-- 
2.39.2

