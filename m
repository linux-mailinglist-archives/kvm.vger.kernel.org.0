Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3DF7BF993
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 13:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjJJLWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 07:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjJJLWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 07:22:17 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Oct 2023 04:22:14 PDT
Received: from 6.mo560.mail-out.ovh.net (6.mo560.mail-out.ovh.net [87.98.165.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED89E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 04:22:13 -0700 (PDT)
Received: from director8.ghost.mail-out.ovh.net (unknown [10.108.1.232])
        by mo560.mail-out.ovh.net (Postfix) with ESMTP id 748D626DA4
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:03:11 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-dnnmd (unknown [10.110.208.237])
        by director8.ghost.mail-out.ovh.net (Postfix) with ESMTPS id CCBC51FE50;
        Tue, 10 Oct 2023 10:03:08 +0000 (UTC)
Received: from foxhound.fi ([37.59.142.105])
        by ghost-submission-6684bf9d7b-dnnmd with ESMTPSA
        id iJQ8KlwhJWUQWgAArvdK0g
        (envelope-from <jose.pekkarinen@foxhound.fi>); Tue, 10 Oct 2023 10:03:08 +0000
Authentication-Results: garm.ovh; auth=pass (GARM-105G0061679898a-46f3-4f1d-875a-19332c22c92d,
                    0BECE3FDD040DFF140D1580490AC4D25886584D9) smtp.auth=jose.pekkarinen@foxhound.fi
X-OVh-ClientIp: 91.157.111.220
From:   =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To:     seanjc@google.com, pbonzini@redhat.com, skhan@linuxfoundation.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] kvm/sev: make SEV/SEV-ES asids configurable
Date:   Tue, 10 Oct 2023 13:04:39 +0300
Message-ID: <20231010100441.30950-1-jose.pekkarinen@foxhound.fi>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2404640727859308198
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrheehgddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeflohhsrocurfgvkhhkrghrihhnvghnuceojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqnecuggftrfgrthhtvghrnhepfedtleeuteeitedvtedtteeuieevudejfeffvdetfeekleehhfelleefteetjeejnecukfhppeduvdejrddtrddtrddupdeluddrudehjedrudduuddrvddvtddpfeejrdehledrudegvddruddtheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehiedtpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are bioses that doesn't allow to configure the
number of asids allocated for SEV/SEV-ES, for those
cases, the default behaviour allocates all the asids
for SEV, leaving no room for SEV-ES to have some fun.
If the user request SEV-ES to be enabled, it will
find the kernel just run out of resources and ignored
user request. This following patch will address this
issue by making the number of asids for SEV/SEV-ES
configurable over kernel module parameters.

Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
---
 arch/x86/kvm/svm/sev.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07756b7348ae..68a63b42d16a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -51,9 +51,18 @@
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
 
+/* nr of asids requested for SEV */
+static unsigned int requested_sev_asids;
+module_param_named(sev_asids, requested_sev_asids, uint, 0444);
+
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* nr of asids requested for SEV-ES */
+static unsigned int requested_sev_es_asids;
+module_param_named(sev_es_asids, requested_sev_asids, uint, 0444);
+
 #else
 #define sev_enabled false
 #define sev_es_enabled false
@@ -2194,6 +2203,11 @@ void __init sev_hardware_setup(void)
 	if (!max_sev_asid)
 		goto out;
 
+	if (requested_sev_asids + requested_sev_es_asids > max_sev_asid) {
+		pr_info("SEV asids requested more than available: %u ASIDs\n", max_sev_asid);
+		goto out;
+	}
+
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = edx;
 	sev_me_mask = 1UL << (ebx & 0x3f);
@@ -2215,7 +2229,8 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
+	sev_asid_count = (requested_sev_asids) ? max_sev_asid - min_sev_asid + 1 :
+						 requested_sev_asids;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
 	sev_supported = true;
 
@@ -2237,10 +2252,11 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	/* Has the system been allocated ASIDs for SEV-ES? */
-	if (min_sev_asid == 1)
+	if (max_sev_asid - sev_asid_count <= 1)
 		goto out;
 
-	sev_es_asid_count = min_sev_asid - 1;
+	sev_es_asid_count = (requested_sev_es_asids) ? min_sev_asid - 1 :
+						       requested_sev_es_asids;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
 
@@ -2248,11 +2264,13 @@ void __init sev_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
 			sev_supported ? "enabled" : "disabled",
-			min_sev_asid, max_sev_asid);
+			min_sev_asid, sev_asid_count);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			sev_asid_count,
+			(requested_sev_es_asids) ? 0 :
+						   sev_asid_count + sev_es_asid_count);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
-- 
2.41.0

