Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F678261261
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 16:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgIHOJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 10:09:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729954AbgIHN6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 09:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599573442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V8gJHVVzl/wwJZfOQGNWW8wLM+ZCeRs5gKT/LuNGCcw=;
        b=OMQSjk72eXgSD5FvYmLtjRHRyXF82GEjzOE6oLSjDI4RIfFn3mwQlnrq/4SJeiacqXOI2N
        yuuztMu03Ckf16Lv87/tfLHaaByKxZ0Zp0OLCV/E/9XWRKFIwKByCZBoP1JifXK5HpPeDZ
        cu5NgegDxSQqSZX3HkOebZqkXjOzwAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-iMmetHogMoyHJc6VOO_2HA-1; Tue, 08 Sep 2020 09:53:57 -0400
X-MC-Unique: iMmetHogMoyHJc6VOO_2HA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6827A1017DC1;
        Tue,  8 Sep 2020 13:53:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E4D87D8AC;
        Tue,  8 Sep 2020 13:53:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 1/2] x86/kvm: properly use DEFINE_IDTENTRY_SYSVEC() macro
Date:   Tue,  8 Sep 2020 15:53:49 +0200
Message-Id: <20200908135350.355053-2-vkuznets@redhat.com>
In-Reply-To: <20200908135350.355053-1-vkuznets@redhat.com>
References: <20200908135350.355053-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DEFINE_IDTENTRY_SYSVEC() already contains irqentry_enter()/
irqentry_exit().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kernel/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 08320b0b2b27..d45f34cbe1ef 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -270,9 +270,6 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	u32 token;
-	irqentry_state_t state;
-
-	state = irqentry_enter(regs);
 
 	inc_irq_stat(irq_hv_callback_count);
 
@@ -283,7 +280,6 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 	}
 
-	irqentry_exit(regs, state);
 	set_irq_regs(old_regs);
 }
 
-- 
2.25.4

