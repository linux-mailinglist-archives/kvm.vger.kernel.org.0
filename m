Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C3C68B7D4
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 09:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBFI5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 03:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFI47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 03:56:59 -0500
Received: from njjs-sys-mailin01.njjs.baidu.com (mx315.baidu.com [180.101.52.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DFF54C1E
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 00:56:55 -0800 (PST)
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 24D1B7F00043
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:56:54 +0800 (CST)
From:   lirongqing@baidu.com
To:     kvm@vger.kernel.org
Subject: [RFC][PATCH] kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection mode.
Date:   Mon,  6 Feb 2023 16:56:54 +0800
Message-Id: <1675673814-23372-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

Intel VMX APICv accelerates EOI write and does not trap. This causes
in-kernel PIT re-injection mode to fail since it relies on irq-ack
notifier mechanism. So, APICv is activated only when in-kernel PIT
is in discard mode e.g. w/ qemu option:

	-global kvm-pit.lost_tick_policy=discard

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615f..16952a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8051,7 +8051,8 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
+			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
+			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
 
 	return supported & BIT(reason);
 }
-- 
2.9.4

