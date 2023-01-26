Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F377967C270
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 02:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbjAZBfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 20:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbjAZBfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 20:35:01 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE1941B6D
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:34:59 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAH-003VAj-Rt; Thu, 26 Jan 2023 02:34:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=BIQGvLaI/E7IErdePMQzNdgQ/EXlGbsQcdVpQfDGKoM=; b=lfB0LB8owo2vUDXYmolRfigr4b
        Z0UQsUH0iNqRDY99IiUO6iVquK5Jcch5/03TFxBZO8vPkk5/bHa8VWub1fq916Zb/ftY2QJ+wYGfg
        c1KuW50XwerUtFnTCz55/Ybs4sWWCilKJbZF9jFFs7eoQ4K8eGCucFJSweHRaoUSQNwLSgbfx+Xs3
        DZ/Oj61kT0gKKINzPQKMqQdRVgg1IBfWjp70eRTTIyGKjSW9Lnz4vQm9wfk8H5EWVYrPpM27sFWex
        vXwZyKZ+MP38LxUCbV1gcljsnthZrbw3HfewIL6xk59Ilna3J5ZlRB05B6Bg+UEObc7vkC47oVZW+
        I5bMQYOQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAH-0003BD-HV; Thu, 26 Jan 2023 02:34:57 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pKrA7-00010H-Gg; Thu, 26 Jan 2023 02:34:47 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/3] KVM: x86/emulator: Fix comment in __load_segment_descriptor()
Date:   Thu, 26 Jan 2023 02:34:04 +0100
Message-Id: <20230126013405.2967156-3-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
References: <20230126013405.2967156-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The comment refers to the same condition twice. Make it reflect what the
code actually does.

No functional change intended.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 81b8f5dcfa44..91581bfeba22 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1633,7 +1633,7 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	case VCPU_SREG_SS:
 		/*
 		 * segment is not a writable data segment or segment
-		 * selector's RPL != CPL or segment selector's RPL != CPL
+		 * selector's RPL != CPL or DPL != CPL
 		 */
 		if (rpl != cpl || (seg_desc.type & 0xa) != 0x2 || dpl != cpl)
 			goto exception;
-- 
2.39.0

