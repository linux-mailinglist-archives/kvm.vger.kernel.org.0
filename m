Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7F44E2AB
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 08:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhKLH5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 02:57:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhKLH5Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 02:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636703665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+/gBy7RhhNPp6PSfdewD04a+ohIEOgBEH7lp12eDp28=;
        b=TDoFYV2cQ+5tPOlJBLtMu6JEvGTouXENb1+weQ9HbS5x0u4mMx8b+ffxtumXVhiJ0dO6Q8
        wqyvHe3DyITd5B6TcnwBOCkqEqP3tSAG7Io7d18fHvQHSa+q90xjyXVZ4E6NPsdKgJ/Bqv
        qgUO7qBk3NW0cNeJaG/hfPkrYzpT0fU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-xtxfIQO2O6--86UB3hHIkA-1; Fri, 12 Nov 2021 02:54:24 -0500
X-MC-Unique: xtxfIQO2O6--86UB3hHIkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBBF79F92B;
        Fri, 12 Nov 2021 07:54:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 699A71002391;
        Fri, 12 Nov 2021 07:54:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] KVM: x86: move guest_pv_has out of user_access section
Date:   Fri, 12 Nov 2021 02:54:22 -0500
Message-Id: <20211112075422.3821671-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When UBSAN is enabled, the code emitted for the call to guest_pv_has
includes a call to __ubsan_handle_load_invalid_value.  objtool
complains that this call happens with UACCESS enabled; to avoid
the warning, pull the calls to user_access_begin into both arms
of the "if" statement, after the check for guest_pv_has.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd7b8b465675..dc7eb5fddfd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3292,9 +3292,6 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
-	if (!user_access_begin(st, sizeof(*st)))
-		return;
-
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
@@ -3303,6 +3300,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		u8 st_preempted = 0;
 		int err = -EFAULT;
 
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		asm volatile("1: xchgb %0, %2\n"
 			     "xor %1, %1\n"
 			     "2:\n"
@@ -3325,6 +3325,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		if (!user_access_begin(st, sizeof(*st)))
 			goto dirty;
 	} else {
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		unsafe_put_user(0, &st->preempted, out);
 		vcpu->arch.st.preempted = 0;
 	}
-- 
2.27.0

