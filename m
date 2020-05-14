Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36A1D3D6F
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgENT1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728174AbgENT1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=n4UvJVseBiY31Df4HWIwknp1COnvoobu7zdWwBtzLM4=;
        b=R8ZvsWFV7pDaAwBXuovS6dKD4AX2+Nlfs5AjqjwU6DBt7+UkXJg2KGEwfcMnOCQKSKzqYk
        OlL2ib77bKlA991pL0+Nkuxg0OI6hj2FDFZA2PRrS85CRfjp+6ptO5m3JubuFQ4fbYcvkD
        tow5XVj2fxlGSL+N1or0xpI2YOe1j8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-QC1YYUJePr65c6Y9W0xSUQ-1; Thu, 14 May 2020 15:27:13 -0400
X-MC-Unique: QC1YYUJePr65c6Y9W0xSUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14EEA100CCC0;
        Thu, 14 May 2020 19:27:12 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5502F5C1BE;
        Thu, 14 May 2020 19:27:08 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 10/11] vmx_tests: Silence warning from Clang
Date:   Thu, 14 May 2020 21:26:25 +0200
Message-Id: <20200514192626.9950-11-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index dbf5375..c38115c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8426,7 +8426,7 @@ static void vmx_preemption_timer_zero_test(void)
 	 * an event that you injected.
 	 */
 	vmx_set_test_stage(1);
-	vmx_preemption_timer_zero_inject_db(1 << DB_VECTOR);
+	vmx_preemption_timer_zero_inject_db(true);
 	vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
 	vmx_preemption_timer_zero_advance_past_vmcall();
 
-- 
2.18.1

