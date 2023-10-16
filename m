Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539727CA48A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 11:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjJPJwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 05:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjJPJww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 05:52:52 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB64EB;
        Mon, 16 Oct 2023 02:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697449971; x=1728985971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ButIDiCErNxytD4vraOH8UFxC3RVH0U5V+UvXPw1a7g=;
  b=Ssiejja/hK38qWRE9SUEsp772LG8ICprq7eIsIphbjiqmYRc6eM7uGIg
   fqcXkPLKHKOdm9hNoKOg1DfgKXEZG06Wj3Uz9+fbLsgnDU/IyW2uwHYf0
   kw+tlTziA9nbb/bjX3sCs1bRdv1H51AsVYgVCoXDjvykENq2sQ6yRYovt
   4=;
X-IronPort-AV: E=Sophos;i="6.03,229,1694736000"; 
   d="scan'208";a="362070535"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:52:37 +0000
Received: from EX19D004EUC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id 0DFED487FA;
        Mon, 16 Oct 2023 09:52:33 +0000 (UTC)
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 16 Oct 2023 09:52:29 +0000
From:   Nicolas Saenz Julienne <nsaenz@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <vkuznets@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <graf@amazon.de>, <rkagan@amazon.de>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [PATCH] KVM: x86: hyper-v: Don't auto-enable stimer during deserialization
Date:   Mon, 16 Oct 2023 09:52:17 +0000
Message-ID: <20231016095217.37574-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7c2dac6824e2..9f1deb6aa131 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -729,7 +729,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 	stimer->count = count;
 	if (stimer->count == 0)
 		stimer->config.enable = 0;
-	else if (stimer->config.auto_enable)
+	else if (stimer->config.auto_enable && !host)
 		stimer->config.enable = 1;
 
 	if (stimer->config.enable)
-- 
2.40.1

