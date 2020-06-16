Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC01FBE97
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgFPS4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730487AbgFPS4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=HkIZVS3LrWgv6Z1qkiTaYOJCFvxEZGb5PZvGUy2JAtU=;
        b=iTB3psPEtNrZqSV8k4nXOLvkTGVfk7ttqRHfTyCBfInoHZlldbFcLjwGTGPlkoAGEx0hzB
        N8Uspv1hN24WlNG/mFm7JyC1jP0lP9aCwLGLzmX8HUSzUk12RTidusAW9Uvl3Vr5he/NnK
        LVtvwCl6Hz1MFf8rs/2QEZiGQI8SdxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-b8USvjPbO-W-g9LQlvknDQ-1; Tue, 16 Jun 2020 14:56:35 -0400
X-MC-Unique: b8USvjPbO-W-g9LQlvknDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EA84100945B;
        Tue, 16 Jun 2020 18:56:34 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63AF57CAA8;
        Tue, 16 Jun 2020 18:56:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PULL 07/12] x86: use a non-negative number in shift
Date:   Tue, 16 Jun 2020 20:56:17 +0200
Message-Id: <20200616185622.8644-8-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Message-Id: <20200514192626.9950-9-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/svm_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c1abd55..a645d66 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -890,7 +890,7 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
-#define TSC_OFFSET_VALUE    (-1ll << 48)
+#define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
 static void tsc_adjust_prepare(struct svm_test *test)
-- 
2.18.1

