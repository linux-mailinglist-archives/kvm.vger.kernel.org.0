Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5476BBD0
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjHAR6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbjHAR6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:58:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEB81BF6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=bnuFTBlWyIdK6w7isk7gkUOUHEpTYmOFBKU1JBhPJE8=; b=ATH50OTpZn6evx3teX6g2Z5miO
        lWsTYdrNNsTAlG6DYn1fKa9g7u14+cAbMrIu7nHsPeSJJh0+MXdTHvT9iyXq/C5p9nlzd19StllfA
        bwA4cKgDpiplRHHxfWdx9JyZkdl26/Q7uNbqehsjPjqncqa8zGxKO2hl2ejrwfasrB5/AIO66BLpC
        vHFZ3QZMtlmjRWObA7sOmyr6myk12IDxx5XS5P+llbQfqUpkMCv9LMB8InA90kwrp7WQnKS8VJCnF
        k7qQJTT44tc6Llv0LNvISJ8lvop4eCUbRW3S0OHi/N0E3YZUgyzun4gFnTicpCgwyQXKXqbjPfjAl
        G1Iv2MtA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qQtd1-00ACU0-Dh; Tue, 01 Aug 2023 17:57:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qQtcz-000bxg-1P;
        Tue, 01 Aug 2023 18:57:49 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Anthony PERARD <anthony.perard@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH for-8.1 1/3] hw/xen: fix off-by-one in xen_evtchn_set_gsi()
Date:   Tue,  1 Aug 2023 18:57:45 +0100
Message-Id: <20230801175747.145906-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230801175747.145906-1-dwmw2@infradead.org>
References: <20230801175747.145906-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Coverity points out (CID 1508128) a bounds checking error. We need to check
for gsi >= IOAPIC_NUM_PINS, not just greater-than.

Also fix up an assert() that has the same problem, that Coverity didn't see.

Fixes: 4f81baa33ed6 ("hw/xen: Support GSI mapping to PIRQ")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/kvm/xen_evtchn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 3d810dbd59..0e9c108614 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -1587,7 +1587,7 @@ static int allocate_pirq(XenEvtchnState *s, int type, int gsi)
  found:
     pirq_inuse_word(s, pirq) |= pirq_inuse_bit(pirq);
     if (gsi >= 0) {
-        assert(gsi <= IOAPIC_NUM_PINS);
+        assert(gsi < IOAPIC_NUM_PINS);
         s->gsi_pirq[gsi] = pirq;
     }
     s->pirq[pirq].gsi = gsi;
@@ -1601,7 +1601,7 @@ bool xen_evtchn_set_gsi(int gsi, int level)
 
     assert(qemu_mutex_iothread_locked());
 
-    if (!s || gsi < 0 || gsi > IOAPIC_NUM_PINS) {
+    if (!s || gsi < 0 || gsi >= IOAPIC_NUM_PINS) {
         return false;
     }
 
-- 
2.40.1

