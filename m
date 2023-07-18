Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3075778C
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 11:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjGRJOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjGRJOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 05:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D30210E2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0Za5rKgUBZTxkAktgjwNM5+Kehhc/iwdSkhd6KTsmE=;
        b=Q/76L6BYY7bdqDmgKfQnTKf6nsSFOovLhiq34fuFQJ+BeAM4OAPg+81/uLe8djhh46zJRF
        nQ+yE4gspvJlvnFYUVYBso4fxjE3S5QqRzsd2+Fj7EZzuWYYB2oPsgko/fdZ5VNIPV88th
        2lZ8XXiUk7FrKqmmXlkGWej98I4iBLo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-q8j76lraNJGR3zgugEfZsA-1; Tue, 18 Jul 2023 05:13:24 -0400
X-MC-Unique: q8j76lraNJGR3zgugEfZsA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12E972A59543;
        Tue, 18 Jul 2023 09:13:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95ACD1454142;
        Tue, 18 Jul 2023 09:13:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: x86: check the kvm_cpu_get_interrupt result before using it
Date:   Tue, 18 Jul 2023 12:13:10 +0300
Message-Id: <20230718091310.119672-4-mlevitsk@redhat.com>
In-Reply-To: <20230718091310.119672-1-mlevitsk@redhat.com>
References: <20230718091310.119672-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index c0778ca39650f4..37162c589e8d0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10190,9 +10190,13 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
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

