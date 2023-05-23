Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6D70E611
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjEWTzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 15:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjEWTzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 15:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B2120
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 12:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684871689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IUxmQ5P+MH9SvOjqUd5l2+YQ2XDFMIly2tHjSWnRkr0=;
        b=WyiEl/6MOghlowh6fItZP6IBgbi4Jq4N9N7e0xGqairqPp1V9MskdbDfHkB+42IHFQ+epL
        Zt3oUdWm6CUWxv7zMTzK+PYLV638/Bg1TvYQLRZDbbTLpQHJfEZssFhGDJaaOeYBTe//HS
        GlKfcRLYwYhPRQYBshP0Ai/l4Kdzl2c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-gNeZnkYYM_a-OP0OnxG1Tw-1; Tue, 23 May 2023 15:54:47 -0400
X-MC-Unique: gNeZnkYYM_a-OP0OnxG1Tw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06664185A78B;
        Tue, 23 May 2023 19:54:47 +0000 (UTC)
Received: from work.redhat.com (unknown [10.39.193.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 794E4492B00;
        Tue, 23 May 2023 19:54:45 +0000 (UTC)
From:   Tim Wiederhake <twiederh@redhat.com>
To:     "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Tim Wiederhake <twiederh@redhat.com>
Subject: [PATCH 1/2] x86/msr: Read MSRs individually
Date:   Tue, 23 May 2023 21:49:48 +0200
Message-Id: <20230523194949.96149-1-twiederh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reading from /dev/cpu/*/msr with buffer size > 8 would read the data
of the same msr repeatedly instead of the data for consecutive msrs,
as one might expect.

Solve by restricting MSR reads to one per call.

Signed-off-by: Tim Wiederhake <twiederh@redhat.com>
---
 arch/x86/kernel/msr.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7bb17d37db01..058f2b67d0c7 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -58,24 +58,17 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 	u32 reg = *ppos;
 	int cpu = iminor(file_inode(file));
 	int err = 0;
-	ssize_t bytes = 0;
 
-	if (count % 8)
+	if (count < 8)
 		return -EINVAL;	/* Invalid chunk size */
 
-	for (; count; count -= 8) {
-		err = rdmsr_safe_on_cpu(cpu, reg, &data[0], &data[1]);
-		if (err)
-			break;
-		if (copy_to_user(tmp, &data, 8)) {
-			err = -EFAULT;
-			break;
-		}
-		tmp += 2;
-		bytes += 8;
-	}
+	err = rdmsr_safe_on_cpu(cpu, reg, &data[0], &data[1]);
+	if (err)
+		return err;
+	if (copy_to_user(tmp, &data, 8))
+		return -EFAULT;
 
-	return bytes ? bytes : err;
+	return 8;
 }
 
 static int filter_write(u32 reg)
-- 
2.39.2

