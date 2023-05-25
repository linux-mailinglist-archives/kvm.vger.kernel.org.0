Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A344B71145D
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbjEYSgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241624AbjEYSfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:35:46 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04CCE78
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:34:24 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmy-004iLE-Qh
        for kvm@vger.kernel.org; Thu, 25 May 2023 20:34:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=0vM1SwvWLRynRevPA8p5AXkpK9F/ciBF2F4nAf4lNug=; b=qVdI6R8Yyb9VarnAxI1q6DLjz0
        Mnlfky4iJAs3rb0M3Bvkxv00vBMVKxkaIiV/46qCloMOdboiK5AIP38LvDHzhL+r47ueiIaYo3vUl
        VL/Q3Up5gaqbTp6lJucIQQXNvLFg7ULjrgcgFwKKgfztf1FncHBqYE4n3IJFLjy3lI7DUuNLHMTz9
        7IJQFxIpGMsBJ2ltnkMSaKaDRqWiLOowgq+1dO3p+tOq7H39bPYbYZke4Wd4J7WVXPi6iOioaBET+
        w6BgnbCens01+Q/vkIKM1xXKqGU0UC4Ef5UQIgVL164RKNCV6GuJOB3dIi3eAEz29B3R8LGiGI01f
        4qV+mrPg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2Fmy-0008Mf-Fc; Thu, 25 May 2023 20:34:16 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2Fms-00047d-8E; Thu, 25 May 2023 20:34:10 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in kvm_recalculate_phys_map()
Date:   Thu, 25 May 2023 20:33:45 +0200
Message-Id: <20230525183347.2562472-2-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525183347.2562472-1-mhal@rbox.co>
References: <20230525183347.2562472-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle the case of vCPU addition and/or APIC enabling during the APIC map
recalculations. Check the sanity of x2APIC ID in !x2apic_format &&
apic_x2apic_mode() case.

kvm_recalculate_apic_map() creates the APIC map iterating over the list of
vCPUs twice. First to find the max APIC ID and allocate a max-sized buffer,
then again, calling kvm_recalculate_phys_map() for each vCPU. This opens a
race window: value of max APIC ID can increase _after_ the buffer was
allocated.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e542cf285b51..39b9a318d04c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
 		 * map requires a strict 1:1 mapping between IDs and vCPUs.
 		 */
-		if (apic_x2apic_mode(apic))
+		if (apic_x2apic_mode(apic)) {
+			if (x2apic_id > new->max_apic_id)
+				return -EINVAL;
+
 			physical_id = x2apic_id;
-		else
+		} else {
 			physical_id = xapic_id;
+		}
 
 		if (new->phys_map[physical_id])
 			return -EINVAL;
-- 
2.40.1

