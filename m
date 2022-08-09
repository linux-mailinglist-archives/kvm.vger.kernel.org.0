Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6A958D8E6
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbiHIMs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiHIMsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:48:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B212418B33
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 05:48:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BFD123A;
        Tue,  9 Aug 2022 05:48:24 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6DF773F5A1;
        Tue,  9 Aug 2022 05:48:22 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com,
        jean-philippe@linaro.org, maz@kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH] net: Use vfork() instead of fork() for script execution
Date:   Tue,  9 Aug 2022 13:48:16 +0100
Message-Id: <20220809124816.2880990-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a script is specified for a guest nic setup, we fork() and execl()s
the script when it is time to execute the script. However this is not
optimal, given we are running a VM. The fork() will trigger marking the
entire page-table of the current process as CoW, which will trigger
unmapping the entire stage2 page tables from the guest. Anyway, the
child process will exec the script as soon as we fork(), making all
these mm operations moot. Also, this operation could be problematic
for confidential compute VMs, where it may be expensive (and sometimes
destructive) to make changes to the stage2 page tables.

So, instead we could use vfork() and avoid the CoW and unmap of the stage2.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virtio/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/net.c b/virtio/net.c
index c4e302bd..a5e0cea5 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -295,7 +295,7 @@ static int virtio_net_exec_script(const char* script, const char *tap_name)
 	pid_t pid;
 	int status;
 
-	pid = fork();
+	pid = vfork();
 	if (pid == 0) {
 		execl(script, script, tap_name, NULL);
 		_exit(1);
-- 
2.37.1

