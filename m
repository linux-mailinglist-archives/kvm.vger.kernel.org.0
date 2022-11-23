Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4026B634B9B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiKWAUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiKWAUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:20:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD86663D4
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 16:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=x+eM26eJCdZ8sbc1Hnhd3LnlnQYGjwWm7F++PTNqvjc=; b=TvjxyNy/iOImPCqHCJPL/SZli1
        1vHw48cke9ICYPGUPR3p9j3rVWEhPKmRHKUmkIV4uKRx9iCmJNMEuwnlpR2DKGgnDXgrIRJGWMOrr
        5uJvGFHiZB4niclMMUal4Ao5kfhWahttzEXB6D1OYSgX0kbRBZJoWT9T+qCkQdODIcylH48PKn9Df
        Bi5LNgtVZS++xRiUYsBLn5qlQ8by7yHzI+Ktk0zWxPyHXSiMZHqCnpjU4na79wM/4pdmhbVj+BRQ7
        mMaR9AYG0jR5VLq1+9zwo5G0JXqMju/fq23sdm7hgzXPT6jh3z06Z02HLGpX6ocf/2J48mGolPoCF
        OT6MW3Yg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdVF-006uLE-L7; Wed, 23 Nov 2022 00:20:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxdV8-000O7l-I7; Wed, 23 Nov 2022 00:20:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Subject: [PATCH 3/3] KVM: Update gfn_to_pfn_cache khva when it moves within the same page
Date:   Wed, 23 Nov 2022 00:20:30 +0000
Message-Id: <20221123002030.92716-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221123002030.92716-1-dwmw2@infradead.org>
References: <20221123002030.92716-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In the case where a GPC is refreshed to a different location within the
same page, we didn't bother to update it. Mostly we don't need to, but
since the ->khva field also includes the offset within the page, that
does have to be updated.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Cc: stable@kernel.org
---
 virt/kvm/pfncache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index bd4a46aee384..5f83321bfd2a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -297,7 +297,12 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	if (!gpc->valid || old_uhva != gpc->uhva) {
 		ret = hva_to_pfn_retry(kvm, gpc);
 	} else {
-		/* If the HVA→PFN mapping was already valid, don't unmap it. */
+		/*
+		 * If the HVA→PFN mapping was already valid, don't unmap it.
+		 * But do update gpc->khva because the offset within the page
+		 * may have changed.
+		 */
+		gpc->khva = old_khva + page_offset;
 		old_pfn = KVM_PFN_ERR_FAULT;
 		old_khva = NULL;
 		ret = 0;
-- 
2.35.3

