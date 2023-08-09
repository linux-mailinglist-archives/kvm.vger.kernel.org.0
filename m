Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA8775FDA
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjHIMyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbjHIMyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:54:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E4210B;
        Wed,  9 Aug 2023 05:53:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379CqAuO005726;
        Wed, 9 Aug 2023 12:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-03-30;
 bh=YyWezMMwGxKKB/jHDRJjdl65qr6ALhU6yWW29edlye8=;
 b=bmegIjY8aMPlI4TWlQ/gNw8pjim7vrfWelPOfnM2t+JThbO6nJTLoKR0g8SCs3qV1slJ
 1odS4WeNNznC/+PMRYtr+PKFc3HGlUVguNEaHs3qjfYcnfq1OHU5wCLzjb33/tz8GyXj
 pUNQw11w6jrpduEEF8xucDO5fx0iVH/TPFvaK/El7whNOBRoRhv4VKFXYAFfDzKogLs+
 BrzNj9FLiUI7+iurRsTJC9EmazJO08l8DJGTFLeK3zFyKtu/A7aBbX1Zew9wmZfu+Q2L
 BTsZ8REi7SfemKhjSJFDrqfJ9nvdnJXLnuzZ626Eg9V8YMZFMPDMwWDtd2BeHXNBpYqy yw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9cuerfv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379BXdcG021556;
        Wed, 9 Aug 2023 12:52:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdyfp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:43 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379CqCGH027258;
        Wed, 9 Aug 2023 12:52:42 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s9cvdyf90-3;
        Wed, 09 Aug 2023 12:52:42 +0000
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
Subject: [PATCH 2/7] x86: Move ARCH_HAS_CPU_RELAX to arch
Date:   Wed,  9 Aug 2023 14:39:36 +0300
Message-Id: <1691581193-8416-3-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_10,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090113
X-Proofpoint-ORIG-GUID: xjNwmyV8x9M_ei9YNJqnuMKodw6deQN5
X-Proofpoint-GUID: xjNwmyV8x9M_ei9YNJqnuMKodw6deQN5
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

ARM64 is going to use it for haltpoll support (for poll-state)
so move the definition to be arch-agnostic and allow architectures
to override it.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index aff2746c8af2..31bd138f406d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1371,6 +1371,9 @@ config RELR
 config ARCH_HAS_MEM_ENCRYPT
 	bool
 
+config ARCH_HAS_CPU_RELAX
+	bool
+
 config ARCH_HAS_CC_PLATFORM
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7422db409770..2eab3be6abbb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
 	select ARCH_HAS_CPU_FINALIZE_INIT
+	select ARCH_HAS_CPU_RELAX
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
-- 
1.8.3.1

