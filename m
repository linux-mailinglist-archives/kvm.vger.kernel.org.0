Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4152775FE6
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjHIMzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjHIMzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:55:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435002106;
        Wed,  9 Aug 2023 05:55:04 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379CrAMj003841;
        Wed, 9 Aug 2023 12:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-03-30;
 bh=3CBdIWj34ZRhxUcc3rj18We/Fw9vZjncSXWx3xdqX8c=;
 b=jqUvKmcI0iRH7yyuqD+FJpXcehOvbBlaOcQ8ZTYMRUh2ISAX6kUZNU7PQno+4c4dIMRT
 Cc7b1hALhsNVK/4AT8wIWKeARWbjY6s7Fguqi/QXtRYHmlqSf5tKuckVHY1RP03iNOt/
 0zIOWxapVCetvWSMWAkGDbOzOBuDw4jxWtTj73DXFQ30fWgUxNaFoQvphxsWfTzeVJz4
 eO6AkOG7sfCi3ezRVMLcCg5DLx/tcbusKx0/02KY4Zt+XCvnTjz1PvhoTDqT/YczDW+H
 xdLUzrU0REkQXNdtpV5CJBpr/44gOiVYYnW2+hCxwZB88wqJI6ZAVQneG1L6ggaV6Cef pA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9efd8mfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:54:17 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379CLjKs021450;
        Wed, 9 Aug 2023 12:54:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdyh79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:54:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379CqCGP027258;
        Wed, 9 Aug 2023 12:54:15 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s9cvdyf90-7;
        Wed, 09 Aug 2023 12:54:15 +0000
From:   Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 6/7] arm64: Define TIF_POLLING_NRFLAG
Date:   Wed,  9 Aug 2023 14:39:40 +0300
Message-Id: <1691581193-8416-7-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_10,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=869 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090114
X-Proofpoint-GUID: WCDia_qDu-gV8Dwp3ZO2w_zOHE8um58f
X-Proofpoint-ORIG-GUID: WCDia_qDu-gV8Dwp3ZO2w_zOHE8um58f
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

The default idle method for arm64 is WFI and it therefore
unconditionally requires the reschedule interrupt when idle.

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had
reverted it because WFI was the only idle method. ARM64 support
for haltpoll means that poll_idle() polls for TIF_POLLING_NRFLAG,
so define on arm64 *only if* haltpoll is built, using the same bit.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 553d1bc559c6..d3010d0b2988 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,9 @@ struct thread_info {
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE) || IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE_MODULE)
+#define TIF_POLLING_NRFLAG      16      /* poll_idle() polls TIF_NEED_RESCHED */
+#endif
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -90,6 +93,9 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE) || IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE_MODULE)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#endif
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
1.8.3.1

