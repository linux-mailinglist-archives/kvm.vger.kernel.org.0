Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560CE6056F3
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiJTFnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJTFnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:43:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32434123476
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so8201957pjb.0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTH7ZmIDUvfRqYyd1HhBU5CIbrwUrGIrg8Vkup78EQQ=;
        b=a0kob/6IV3hX8wveVUZp8aIkDTHPSkKD5x0boK7exvWYmVqS1xKXjC980frftI1iB8
         OWCsn1M7ioegFzfpZDpYLhsw7YxdRjT1mqJh6jP7+GD6gBX65QrnaGUXiiGWxjhSn2aS
         /+R3vDIVC5QbrkbrkeoXpCeR63kcHlllzNsasi2HfB9dkxUIrG4HllTXWAz7kLz5flMg
         PKkcNWAIF9qF2dNNuqMTKpGOzyb4SJKBkGqu59mOkKQVVJMIiug52s+14wVOER9MNH0R
         LNFZfjxYmtfAvlWRsxg/hxtMqa48+J7IPUDMYSOQEcdhdSX7ZLvH6BjAXQCbljrXZYqA
         pyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NTH7ZmIDUvfRqYyd1HhBU5CIbrwUrGIrg8Vkup78EQQ=;
        b=o8WEa8G0Z5oP9o3p0bct6R0EtyUQwiNRAlG/1F/5PLEe9wiArNE5Q1zG3wi0DFfi23
         EhkTPNDQ2yitUQQf3nUWtATvobJK7tLGuGZgKBrfvl3fTxPDpZ4uDJc5t6lqKhkIW91C
         jTQGdsHUD2aW1zH7LoiPAjKY4x3RhDCAliTUGJX2pYy9d0m6zH8Th/nDFyH83R/7vULs
         QPpWxPCGgx4Mc8fwpAjYAfKGGDEE41XG4TCFPFstUua5/YCOlBIFFqkT/K1pOcshcr+r
         CrfFUyI22nQAWN0ZMHfOrwN7FiUmlWzPDYTO/+blDobQUDnjQ6zU7cmAbzfNJ7B7L6fP
         7EwA==
X-Gm-Message-State: ACrzQf1BIkSxg9ToYOSfaooOh5OPVH2WebSiN6ot2XvqsHYryh/8I1hw
        w8UwQZ0lzihDeLC3lH0KcRUmkV22uDY=
X-Google-Smtp-Source: AMsMyM7HKrCTV8qQjJ+AeuKopjnwPGTiQp5PNWWQkgWncAh69Zqd6D1WMZdPZsMDLEvCA6w055Dg1d+ZtUw=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:d2cc:b0:182:d901:5d28 with SMTP id
 n12-20020a170902d2cc00b00182d9015d28mr12606746plc.142.1666244628304; Wed, 19
 Oct 2022 22:43:48 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:42:01 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-9-reijiw@google.com>
Subject: [PATCH v2 8/9] KVM: arm64: selftests: Add a test case for a linked watchpoint
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the debug-exceptions test doesn't have a test case for
a linked watchpoint. Add a test case for the linked watchpoint to
the test. The new test case uses the highest numbered context-aware
breakpoint (for Context ID match), and the watchpoint#0, which is
linked to the context-aware breakpoint.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 362e7668a978..73a95e6b345e 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -22,6 +22,9 @@
 #define DBGWCR_WR	(0x2 << 3)
 #define DBGWCR_EL1	(0x1 << 1)
 #define DBGWCR_E	(0x1 << 0)
+#define DBGWCR_LBN_SHIFT	16
+#define DBGWCR_WT_SHIFT		20
+#define DBGWCR_WT_LINK		(0x1 << DBGWCR_WT_SHIFT)
 
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
@@ -171,6 +174,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_monitor_debug_exceptions();
 }
 
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
+			   uint64_t ctx)
+{
+	uint32_t wcr;
+	uint64_t ctx_bcr;
+
+	/* Setup a context-aware breakpoint for Linked Context ID Match */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked watchpoint (linked to the context-aware breakpoint) */
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E |
+	      DBGWCR_WT_LINK | ((uint32_t)ctx_bp << DBGWCR_LBN_SHIFT);
+	write_dbgwcr(addr_wp, wcr);
+	write_dbgwvr(addr_wp, addr);
+	isb();
+
+	enable_monitor_debug_exceptions();
+}
+
 void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
 		       uint64_t ctx)
 {
@@ -306,6 +331,16 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	write_sysreg(0, contextidr_el1);
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
 
+	/* Linked watchpoint */
+	reset_debug_state();
+	install_wp_ctx(wpn, ctx_bpn, PC(write_data), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
 	GUEST_DONE();
 }
 
-- 
2.38.0.413.g74048e4d9e-goog

