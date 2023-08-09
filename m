Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2AA775FD0
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjHIMxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjHIMxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:53:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63551FF2;
        Wed,  9 Aug 2023 05:53:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379Cpa59031359;
        Wed, 9 Aug 2023 12:52:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2023-03-30;
 bh=ChGKlt5Hc3xaI+IO83XIpC+0QHNXzdywVGxD5l19MfY=;
 b=wgOIBUvNnnmmByrYwOosfXJnxP32XqKUO4B8bz2Pv3MCuc/FnVOZf47WIlpcnbvEkKBv
 slUWPmfR95R6xzY6wuEARt0ngCOfrsvMIhlDtFE9Zd9zKmYRu/GeUL1fP/pb2MpQGfje
 BY/k55iVR/A/+C1X8AnKYr+TWOXYWOV//UM3RYl64GYwFJ/BHpEKijAgsucYCUMNe1ak
 IoCPPeT39lWTu4NDY1kZ0dp/MSCSrmpSLssJ8/1zP7BFWGJWJS2zJMDywLFYIgF0qZ4L
 6k7l74pUcWjJ2Y38GTcglIkV/WJEuj65qNUhVxOGy0iNa+hf7LqtyPXiqQFiHssj7+iK Aw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9e1u8gu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379BqPTH021455;
        Wed, 9 Aug 2023 12:52:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdyfb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:13 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379CqCGD027258;
        Wed, 9 Aug 2023 12:52:12 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s9cvdyf90-1;
        Wed, 09 Aug 2023 12:52:12 +0000
From:   Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Mihai Carabas <mihai.carabas@oracle.com>,
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
        Joao Martins <joao.m.martins@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH] Enable haltpoll for arm64
Date:   Wed,  9 Aug 2023 14:39:34 +0300
Message-Id: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_10,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090113
X-Proofpoint-GUID: ZD3VwTdIP8fJZ1zSd2eyu7m_v2QOaLpc
X-Proofpoint-ORIG-GUID: ZD3VwTdIP8fJZ1zSd2eyu7m_v2QOaLpc
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

This patchset enables the usage of haltpoll governer on arm64. This is
specifically interesting for KVM guests.

Here are some benchmarks without/with haltpoll for a KVM guest:

a) without haltpoll:
perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 8.410 [sec]

       8.410882 usecs/op
         118893 ops/sec

b) with haltpoll:
perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes
     Total time: 5.183 [sec]
       5.183491 usecs/op
         192920 ops/sec

Joao Martins (7):
  cpuidle-haltpoll: Make boot_option_idle_override check X86 specific
  x86: Move ARCH_HAS_CPU_RELAX to arch
  x86/kvm: Move haltpoll_want() to be arch defined
  governors/haltpoll: Drop kvm_para_available() check
  arm64: Select ARCH_HAS_CPU_RELAX
  arm64: Define TIF_POLLING_NRFLAG
  cpuidle-haltpoll: ARM64 support

 arch/Kconfig                            | 3 +++
 arch/arm64/Kconfig                      | 1 +
 arch/arm64/include/asm/thread_info.h    | 6 ++++++
 arch/x86/Kconfig                        | 1 +
 arch/x86/include/asm/cpuidle_haltpoll.h | 1 +
 arch/x86/kernel/kvm.c                   | 6 ++++++
 drivers/cpuidle/Kconfig                 | 4 ++--
 drivers/cpuidle/cpuidle-haltpoll.c      | 6 ++++--
 drivers/cpuidle/governors/haltpoll.c    | 5 +----
 include/linux/cpuidle_haltpoll.h        | 5 +++++
 10 files changed, 30 insertions(+), 8 deletions(-)

-- 
1.8.3.1

