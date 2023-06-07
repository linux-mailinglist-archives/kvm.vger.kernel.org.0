Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FD6726952
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjFGS7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjFGS7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:59:14 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [IPv6:2001:41d0:203:375::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D01BEC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:59:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686164347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wzo9Zb54Peqok5A7q67D4Ki/JABbQcqy7ot1VdQjGro=;
        b=icMMB5lQ29Gl1dqFe4YUANxtj76I3r1N4oYp/pgJUvs5D/jR/AOakc9glTKblCht42IHet
        /t01CIWQ0bnmZ4AMNQUHZY6FWs3PFnmOdx1d90DwvAA2aZnLvR2HPQIS97p1WG03uTjTmv
        mgm6NHLA2ZAYjlwuCsZ3Itty3gWHsn4=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 1/3] arch-run: Extend timeout when booting with UEFI
Date:   Wed,  7 Jun 2023 20:59:03 +0200
Message-Id: <20230607185905.32810-2-andrew.jones@linux.dev>
In-Reply-To: <20230607185905.32810-1-andrew.jones@linux.dev>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Booting UEFI can take a long time. Give the timeout some extra time
to compensate for it.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 scripts/arch-run.bash | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 51e4b97b27d1..72ce718b1170 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -94,7 +94,17 @@ run_qemu_status ()
 
 timeout_cmd ()
 {
+	local s
+
 	if [ "$TIMEOUT" ] && [ "$TIMEOUT" != "0" ]; then
+		if [ "$CONFIG_EFI" = 'y' ]; then
+			s=${TIMEOUT: -1}
+			if [ "$s" = 's' ]; then
+				TIMEOUT=${TIMEOUT:0:-1}
+				((TIMEOUT += 10)) # Add 10 seconds for booting UEFI
+				TIMEOUT="${TIMEOUT}s"
+			fi
+		fi
 		echo "timeout -k 1s --foreground $TIMEOUT"
 	fi
 }
-- 
2.40.1

