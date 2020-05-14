Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1311D3D6D
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgENT1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728098AbgENT1J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 15:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=nIMdLxZMn/PQTzyjNGQJxXdDAScW95E/bjh0JAPZKB8=;
        b=EFwFL3/jakHjswfcy+o8x63dbvduBndX3/86C4MXSJ7o1ZdoVTA7F4Mkz/uZgid9ETYPmG
        dfZ0nQn0v8qk3VpJnFT6qlcHecERLxTd/KbpfB6MGkJdkDNHkWyQ1XZ0x2oBb2C/DaVWoU
        gss4PqcBpF9jTO+rBV3I2tnXxWhUKLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-pBwNrmziORKK7oyWDtgmsQ-1; Thu, 14 May 2020 15:27:06 -0400
X-MC-Unique: pBwNrmziORKK7oyWDtgmsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F719107ACCA;
        Thu, 14 May 2020 19:27:05 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 418545C1BE;
        Thu, 14 May 2020 19:27:02 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 08/11] x86: use a non-negative number in shift
Date:   Thu, 14 May 2020 21:26:23 +0200
Message-Id: <20200514192626.9950-9-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

Shifting a negative number is undefined. Clang complains about it:

x86/svm.c:1131:38: error: shifting a negative signed value is undefined [-Werror,-Wshift-negative-value]
    test->vmcb->control.tsc_offset = TSC_OFFSET_VALUE;

Using "~0ull" results in identical asm code:

	before: movabsq $-281474976710656, %rsi
	after:  movabsq $-281474976710656, %rsi

Signed-off-by: Bill Wendling <morbo@google.com>
[thuth: Rebased to master - code is in svm_tests.c instead of svm.c now]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/svm_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2f53b8f..be1bddf 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -844,7 +844,7 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
-#define TSC_OFFSET_VALUE    (-1ll << 48)
+#define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
 static void tsc_adjust_prepare(struct svm_test *test)
-- 
2.18.1

