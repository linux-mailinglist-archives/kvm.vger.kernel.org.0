Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E261775FD6
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjHIMxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 08:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjHIMxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 08:53:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEE42109;
        Wed,  9 Aug 2023 05:53:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379Cpatv031355;
        Wed, 9 Aug 2023 12:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2023-03-30;
 bh=0QZsX2jbO6id/iaRRnv0TmxxvvP8rcGnUdjnrbggVeE=;
 b=EHPw1hrrhg1yTQEwYhDBLlnh0EFQdIXvnIdONYKFcH9mYEL+H58uVVEOZmnLxlgW2WiL
 KYhi4J0qi1VbdPagCMKL8BXbli2efIWvj55uO62+moCIcT7oJRGQSytHMV71FYB8Rp9k
 XWN+ppHZw6i1S9MtN5By2iGfrY/tZX0iBDcur+hS28ldrouHJdsw4BcLNavlyo27aJOs
 kQPMQfXBxtEbvpKLELqcsuqSRIIA4RIWE7nWPiw5GB38ce1dFJGXb45E7IryGV937wIv
 rYywDyGInS8ZTAYIaEzTigl80IezjPngwcTeDwInoY6oUzlAy9W4gLiiWks4/yHhUCS5 /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9e1u8gup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379C0l5O021712;
        Wed, 9 Aug 2023 12:52:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdyfg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 12:52:28 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 379CqCGF027258;
        Wed, 9 Aug 2023 12:52:27 GMT
Received: from mihai.localdomain (ban25x6uut25.us.oracle.com [10.153.73.25])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s9cvdyf90-2;
        Wed, 09 Aug 2023 12:52:27 +0000
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
Subject: [PATCH 1/7] cpuidle-haltpoll: Make boot_option_idle_override check X86 specific
Date:   Wed,  9 Aug 2023 14:39:35 +0300
Message-Id: <1691581193-8416-2-git-send-email-mihai.carabas@oracle.com>
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
X-Proofpoint-GUID: 12Ohs6U9gYefr7PsRh_c7KrFj31d0E8M
X-Proofpoint-ORIG-GUID: 12Ohs6U9gYefr7PsRh_c7KrFj31d0E8M
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

In the pursuit of letting it build on ARM let's not include what is x86
specific.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
---
 drivers/cpuidle/cpuidle-haltpoll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index e66df22f9695..0ca3c8422eb6 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -104,9 +104,11 @@ static int __init haltpoll_init(void)
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
+#ifdef CONFIG_X86
 	/* Do not load haltpoll if idle= is passed */
 	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
 		return -ENODEV;
+#endif
 
 	if (!kvm_para_available() || !haltpoll_want())
 		return -ENODEV;
-- 
1.8.3.1

