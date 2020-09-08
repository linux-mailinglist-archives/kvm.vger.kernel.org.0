Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9B261252
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 16:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIHOFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 10:05:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42088 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729960AbgIHN6e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 09:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599573442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X1hNV4i8uub6ijBLYfvIMUcO2VCeKoB+63SdtC7XLQY=;
        b=Pzsb51KSJWg4HlfWrrXu+d9XrBmmdJajz2JEosd30HnyTVUUuEZRRYnUipg2hgEYxOyIEj
        pjJmiIx85S4Wpr8U/8drZ4+Z1RFQUDYSpdZ3jyfmT82/lbW7bIfqnQnvU3bC3PwxMzhsPm
        dhI5RXM9BIJbZBLTFc8v+WdOYIpUVbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-cfLqL6_9NVGGsoJZl_Oh2w-1; Tue, 08 Sep 2020 09:54:00 -0400
X-MC-Unique: cfLqL6_9NVGGsoJZl_Oh2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F033AF200;
        Tue,  8 Sep 2020 13:53:59 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7D2F60DA0;
        Tue,  8 Sep 2020 13:53:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 2/2] x86/kvm: don't forget to ACK async PF IRQ
Date:   Tue,  8 Sep 2020 15:53:50 +0200
Message-Id: <20200908135350.355053-3-vkuznets@redhat.com>
In-Reply-To: <20200908135350.355053-1-vkuznets@redhat.com>
References: <20200908135350.355053-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge commit 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
tried to adapt the new interrupt based async PF mechanism to the newly
introduced IDTENTRY magic but unfortunately it missed the fact that
DEFINE_IDTENTRY_SYSVEC() doesn't call ack_APIC_irq() on its own and
all DEFINE_IDTENTRY_SYSVEC() users have to call it manually.

As the result all multi-CPU KVM guest hang on boot when
KVM_FEATURE_ASYNC_PF_INT is present. The breakage went unnoticed because no
KVM userspace (e.g. QEMU) currently set it (and thus async PF mechanism
is currently disabled) but we're about to change that.

Fixes: 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kernel/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d45f34cbe1ef..9663ba31347c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -271,6 +271,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	u32 token;
 
+	ack_APIC_irq();
+
 	inc_irq_stat(irq_hv_callback_count);
 
 	if (__this_cpu_read(apf_reason.enabled)) {
-- 
2.25.4

