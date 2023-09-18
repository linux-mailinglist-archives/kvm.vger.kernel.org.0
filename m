Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09B27A4F1B
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjIRQeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjIRQdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:33:52 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D047A80;
        Mon, 18 Sep 2023 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=0eGGXnc5vBmAE8zpS0TzZWx5te66TwGgtV+bYpeTlu4=; b=xv4fEw7Q9+E5M8WA0ZHC3Cbxe5
        Q8KTOSvHlk4j+r5joqIH1D6QOvJqwVA5f+mNyvgkK0QpYl/j1w9xrlqFKuEI/oI6RgL1RkbuCk8+u
        3FyMeo0bTeH81uJFuyoj5LoQ+3BcH1KHWB17+cUdTj9eX7aqrv+5xRARiH8GYltvvzyQ=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRB-0003QI-0l; Mon, 18 Sep 2023 14:41:21 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiFRA-0006IJ-Pk; Mon, 18 Sep 2023 14:41:20 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 04/13] KVM: pfncache: base offset check on khva rather than gpa
Date:   Mon, 18 Sep 2023 14:41:02 +0000
Message-Id: <20230918144111.641369-5-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918144111.641369-1-paul@xen.org>
References: <20230918144111.641369-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

After a subsequent patch, the gpa may not always be set whereas khva will
(as long as the cache valid flag is also set).

No functional change intended.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
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

