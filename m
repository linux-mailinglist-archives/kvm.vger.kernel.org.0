Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F042076383F
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjGZOBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjGZOBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:01:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC31E2132
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 07:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690380037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NMiTq/NJ8G71mTK+kun4ROve/cQ69SRajLeV7++tZE=;
        b=L+RnbcRUI0oTgb8e7N2Qlrua+Pz2CW/Sz3gv+hL8L+aZSCgah6pES4Wy6BSrDqta5BPe0J
        3JRCejXGJC85P3JQjXYJQ4A+xQnRBTBRHd8m9rCf0RV+HQujtldgFORuTsC9GHCjXYNAwK
        npa8xcaIGP6XgZALcNU3iVbHHskFKao=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-696-NU3wojVyMBiKj4ZDe-OLeg-1; Wed, 26 Jul 2023 10:00:33 -0400
X-MC-Unique: NU3wojVyMBiKj4ZDe-OLeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E7343C11A09;
        Wed, 26 Jul 2023 14:00:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CC5E40C2063;
        Wed, 26 Jul 2023 14:00:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/3] KVM: x86: check the kvm_cpu_get_interrupt result before using it
Date:   Wed, 26 Jul 2023 16:59:45 +0300
Message-Id: <20230726135945.260841-4-mlevitsk@redhat.com>
In-Reply-To: <20230726135945.260841-1-mlevitsk@redhat.com>
References: <20230726135945.260841-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code was blindly assuming that kvm_cpu_get_interrupt never returns -1
when there is a pending interrupt.

While this should be true, a bug in KVM can still cause this.

If -1 is returned, the code before this patch was converting it to 0xFF,
and 0xFF interrupt was injected to the guest, which results in an issue
which was hard to debug.

Add WARN_ON_ONCE to catch this case and	skip the injection
if this happens again.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8ac..00b87fcf6da4af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10203,9 +10203,13 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r < 0)
 			goto out;
 		if (r) {
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			static_call(kvm_x86_inject_irq)(vcpu, false);
-			WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
+			int irq = kvm_cpu_get_interrupt(vcpu);
+
+			if (!WARN_ON_ONCE(irq == -1)) {
+				kvm_queue_interrupt(vcpu, irq, false);
+				static_call(kvm_x86_inject_irq)(vcpu, false);
+				WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
+			}
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
 			static_call(kvm_x86_enable_irq_window)(vcpu);
-- 
2.26.3

