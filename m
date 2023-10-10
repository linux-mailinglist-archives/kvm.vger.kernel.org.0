Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CAD7C0363
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343536AbjJJS0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 14:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjJJS0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 14:26:40 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Oct 2023 11:26:36 PDT
Received: from 4.mo576.mail-out.ovh.net (4.mo576.mail-out.ovh.net [46.105.42.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5211894
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 11:26:36 -0700 (PDT)
Received: from director11.ghost.mail-out.ovh.net (unknown [10.108.4.132])
        by mo576.mail-out.ovh.net (Postfix) with ESMTP id C0EF827E2C
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:48:28 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-stm2z (unknown [10.110.115.58])
        by director11.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 6CCDA1FD7A;
        Tue, 10 Oct 2023 17:48:27 +0000 (UTC)
Received: from foxhound.fi ([37.59.142.96])
        by ghost-submission-6684bf9d7b-stm2z with ESMTPSA
        id 8psZFmuOJWW+IgUAE6teJg
        (envelope-from <jose.pekkarinen@foxhound.fi>); Tue, 10 Oct 2023 17:48:27 +0000
Authentication-Results: garm.ovh; auth=pass (GARM-96R0014c201574-7c4e-4efe-b59f-e4ee1977f006,
                    0BECE3FDD040DFF140D1580490AC4D25886584D9) smtp.auth=jose.pekkarinen@foxhound.fi
X-OVh-ClientIp: 91.157.111.220
From:   =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To:     seanjc@google.com, pbonzini@redhat.com, skhan@linuxfoundation.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] kvm/sev: remove redundant MISC_CG_RES_SEV_ES
Date:   Tue, 10 Oct 2023 20:49:13 +0300
Message-ID: <20231010174932.29769-1-jose.pekkarinen@foxhound.fi>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10262577655121553062
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrheehgdduudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffogggtgfesthekredtredtjeenucfhrhhomheplfhoshorucfrvghkkhgrrhhinhgvnhcuoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqeenucggtffrrghtthgvrhhnpeeftdelueetieetvdettdetueeivedujeefffdvteefkeelhefhleelfeetteejjeenucfkphepuddvjedrtddrtddruddpledurdduheejrdduuddurddvvddtpdefjedrheelrddugedvrdelieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehjeeipdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-ES is an extra encrypted state that shares common resources
with SEV. Using an extra CG for its purpose doesn't seem to
provide much value. This patch will clean up the control group
along with multiple checks that become redundant with it.

The patch will also remove a redundant logic on sev initialization
that produces SEV-ES to be disabled, while supported by the cpu
and requested by the user through the sev_es parameter.

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
---
 arch/x86/kvm/svm/sev.c      | 18 +++---------------
 include/linux/misc_cgroup.h |  2 --
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07756b7348ae..8a06d92187cf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,13 +37,9 @@
  * this file are not used but this file still gets compiled into the KVM AMD
  * module.
  *
- * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
- * misc_res_type {} defined in linux/misc_cgroup.h.
- *
  * Below macros allow compilation to succeed.
  */
 #define MISC_CG_RES_SEV MISC_CG_RES_TYPES
-#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
@@ -125,13 +121,13 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
 
 static int sev_misc_cg_try_charge(struct kvm_sev_info *sev)
 {
-	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	enum misc_res_type type = MISC_CG_RES_SEV;
 	return misc_cg_try_charge(type, sev->misc_cg, 1);
 }
 
 static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 {
-	enum misc_res_type type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	enum misc_res_type type = MISC_CG_RES_SEV;
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
@@ -2167,7 +2163,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
-	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	unsigned int eax, ebx, ecx, edx, sev_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2236,14 +2232,7 @@ void __init sev_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
 
-	/* Has the system been allocated ASIDs for SEV-ES? */
-	if (min_sev_asid == 1)
-		goto out;
-
-	sev_es_asid_count = min_sev_asid - 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
-
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
@@ -2271,7 +2260,6 @@ void sev_hardware_unsetup(void)
 	bitmap_free(sev_reclaim_asid_bitmap);
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
-	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c238207d1615..23d3cd153f60 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -15,8 +15,6 @@ enum misc_res_type {
 #ifdef CONFIG_KVM_AMD_SEV
 	/* AMD SEV ASIDs resource */
 	MISC_CG_RES_SEV,
-	/* AMD SEV-ES ASIDs resource */
-	MISC_CG_RES_SEV_ES,
 #endif
 	MISC_CG_RES_TYPES
 };
-- 
2.41.0

