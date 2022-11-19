Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4082630DE9
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 10:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiKSJrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 04:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKSJrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 04:47:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE7BA8C1C
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 01:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=8ljsxJtk0Hm4db2+/NNpXu3Pp4gHr22GOr4wmxtwuN0=; b=fRrt1E0Ap40VxFgDJ1PtJJ7r7g
        W9mB58RJO4t+fUg0eH/3nZIxwEd09Q0dNLTHKGnWHU3ilJOSR6AZrP1UE7QjZlXYzU6IzkVJKqvP3
        xN5aPJidG4lfFZWV44gehce8Zklu0gyx3aKA78AAaOUJ1Mtanw/edsKWw82IQt7nzF7w+vxmWEoDQ
        EmO9ns3tjXv2oQvfXiNXLf/LVH+tZgT3DQ1B0wYodndI+5kS7KLRTm5ZJzebJfC+Mcp3Nuo98SfhO
        hvSMFvuclL5MqomyrOTa4nZWu30ktgbHVW5lZ/k0yIwE73arnE4g33jup975Hz43e1XWWr1Buf3yP
        iOVVVdSA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-002Huh-VN; Sat, 19 Nov 2022 09:47:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-00035m-N6; Sat, 19 Nov 2022 09:46:59 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mhal@rbox.co
Subject: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves within the same page
Date:   Sat, 19 Nov 2022 09:46:58 +0000
Message-Id: <20221119094659.11868-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221119094659.11868-1-dwmw2@infradead.org>
References: <20221119094659.11868-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
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

