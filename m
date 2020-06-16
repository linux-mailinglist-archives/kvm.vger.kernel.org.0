Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCB71FBE99
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgFPS4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730337AbgFPS4n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 14:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=p+mkbEnudir9dIPe3RaAA9y7QvMIFQSz5R+sX80GQrA=;
        b=QO/rPzYAdQ9IdJOknSszxhLzbXRSSgMK8MueztPj+XJ9flF12GCdiWzil0N3P9Pk4oUFqT
        G8fq1aojQkd4GiR212lHKCq1BlWIPEbRaIzl0dZjhDNTq/ugedrNAxNiIOziEknG4J4AZI
        ElgvLGAoY9LTYh5nw/7dnjXF94sS1iY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-fq_FBSn4N465s_xz9owe2Q-1; Tue, 16 Jun 2020 14:56:40 -0400
X-MC-Unique: fq_FBSn4N465s_xz9owe2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A49091009618
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:39 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB2A87CAA8;
        Tue, 16 Jun 2020 18:56:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 09/12] vmx_tests: Silence warning from Clang
Date:   Tue, 16 Jun 2020 20:56:19 +0200
Message-Id: <20200616185622.8644-10-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang complains:

x86/vmx_tests.c:8429:40: error: converting the result of '<<' to a boolean
 always evaluates to true [-Werror,-Wtautological-constant-compare]
         vmx_preemption_timer_zero_inject_db(1 << DB_VECTOR);
                                               ^

Looking at the code, the "1 << DB_VECTOR" is done within the function
vmx_preemption_timer_zero_inject_db() indeed:

	vmcs_write(EXC_BITMAP, intercept_db ? 1 << DB_VECTOR : 0);

... so using "true" as parameter for the function should be appropriate
here.

Message-Id: <20200514192626.9950-11-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index fcd97a1..36e94fa 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8544,7 +8544,7 @@ static void vmx_preemption_timer_zero_test(void)
 	 * an event that you injected.
 	 */
 	vmx_set_test_stage(1);
-	vmx_preemption_timer_zero_inject_db(1 << DB_VECTOR);
+	vmx_preemption_timer_zero_inject_db(true);
 	vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
 	vmx_preemption_timer_zero_advance_past_vmcall();
 
-- 
2.18.1

