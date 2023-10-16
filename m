Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0387CB11D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjJPRLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjJPRLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:11:02 -0400
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EE183E7;
        Mon, 16 Oct 2023 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697475530; x=1729011530;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=auMjyAtIvReWTmo+5WvQGZtqHXOUxJt+w4yHlsfTNX4=;
  b=YX7cUdTkHdAJj1ncCZjtcpesO/9DeN5pkVaZUCG0Z/2QuTfEyYDpgrhj
   HOl2Y649umKBaH55iIP5f7nDA/sBF6G/yoRyK1O3VWhLhI3/Av8shKVid
   Io9YVNNqeu13MukBC7TINgi2mmQotF71qTG2STScVzPUfY1E9SLNzBpcm
   c=;
X-IronPort-AV: E=Sophos;i="6.03,229,1694736000"; 
   d="scan'208";a="613692706"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 16:58:47 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
        by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id 3898B81A9E;
        Mon, 16 Oct 2023 16:58:45 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:10860]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.26:2525] with esmtp (Farcaster)
 id 6af131f8-1777-4266-95f4-c22af1c82f27; Mon, 16 Oct 2023 16:58:44 +0000 (UTC)
X-Farcaster-Flow-ID: 6af131f8-1777-4266-95f4-c22af1c82f27
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 16 Oct 2023 16:58:39 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 16 Oct 2023 16:58:34 +0000
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <vkuznets@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <graf@amazon.de>, <rkagan@amazon.de>,
        <linux-kernel@vger.kernel.org>, <anelkz@amazon.de>,
        Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [PATCH v2] KVM: x86: hyper-v: Don't auto-enable stimer during deserialization
Date:   Mon, 16 Oct 2023 16:56:19 +0000
Message-ID: <20231016165616.33442-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By not honoring the 'stimer->config.enable' state during stimer
deserialization we might introduce spurious timer interrupts. For
example through the following events:
 - The stimer is configured in auto-enable mode.
 - The stimer's count is set and the timer enabled.
 - The stimer expires, an interrupt is injected.
 - We live migrate the VM.
 - The stimer config and count are deserialized, auto-enable is ON, the
   stimer is re-enabled.
 - The stimer expires right away, and injects an unwarranted interrupt.

So let's not change the stimer's enable state if the MSR write comes
from user-space.

Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---

Changes since v1:
 - Cover all 'stimer->config.enable' updates.

 arch/x86/kvm/hyperv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7c2dac6824e2..238afd7335e4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -727,10 +727,12 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 
 	stimer_cleanup(stimer);
 	stimer->count = count;
-	if (stimer->count == 0)
-		stimer->config.enable = 0;
-	else if (stimer->config.auto_enable)
-		stimer->config.enable = 1;
+	if (!host) {
+		if (stimer->count == 0)
+			stimer->config.enable = 0;
+		else if (stimer->config.auto_enable)
+			stimer->config.enable = 1;
+	}
 
 	if (stimer->config.enable)
 		stimer_mark_pending(stimer, false);
-- 
2.40.1

