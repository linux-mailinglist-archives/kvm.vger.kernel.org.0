Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B60AC1D2
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390726AbfIFVDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:38 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39613 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390367AbfIFVDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:38 -0400
Received: by mail-pf1-f202.google.com with SMTP id n186so5516148pfn.6
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E3INAiH7EAqRlDXl9ihNS8SQNTvURjPeKhaz0/tf9Mg=;
        b=A+7hjrdFoAbeMivWPApH9FdJUVJjKoQNJzi0vco2ZVK3Lb3smVuCtZGQAwvORBBMni
         Bvw+H5zfQUNfq1hCQ+6lL5dfpFJTjKf2VMcf17zEC8qBiM79v2I5ZLLe4A3ITQ0DS31t
         oMEFTmYwUIVw1zhydMWKow/iJsjQE4hct1MtDScR9g0Ekva23B8uQM5S+yPFsCFJHvo1
         4ZFZzZ6O+3HJJGbir4i1OouZjD3v3SpCCrqxXXXayhBTxLPuA3DIDAZrcUTDAuPcWuWC
         yNEB0FlO2p8AXKhCe7mB2oCKrpBh92vAuPdE+p8phjfBFuXJQ9EVjQk2pJTjZPJpnDb4
         ohKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E3INAiH7EAqRlDXl9ihNS8SQNTvURjPeKhaz0/tf9Mg=;
        b=Clnr/lyIoeYciGf+swEIrMb7EY5/QNWPHFB9CxqOj/GB7H9HIunF143Kj7anyGddbt
         lxM/pKSpqfmnenQw3ROGwxxDcZSA+dQclOcHcvCFad1twaVzvRPFbUGVtSfYRskLZQvn
         hzaDGFMQMULyB2faYGQVBYtfx773tbbhHm72jId0hie4TAjYNnFkWoEKdjpGIUDZai2z
         Nb2tJx9AhDLDxmzZns4AW334jFpxIqfNU5WrP4QCYS1fg3/LuN7xLj3tAf/7v9hK7SXj
         lZeOrLM5vI/t0PZIfIoBjfUuhWbiUzWoI29z5T6EKRgLjmc9eCpKXqX8SqFM9kK9Pz8w
         7Weg==
X-Gm-Message-State: APjAAAU1uEQSoL99siWaInuiup/jsQ2We4ol8eSJV2NBMzOWka3/sLGI
        P9w6YpxiwggyR5uAWhJTkd2HAbk4w6J8y/ViariAuIx+6CW3uTapGso7xjQjIoEF21w6azntZUt
        +YVg4P1TqxG+COmOU3GGTw1Mik6UbbgLSNA+dLCOyV6d0cVSytcAX0/Lv1Q==
X-Google-Smtp-Source: APXvYqz5NgAnY67peE4dh5Ip4+ZyedJdtALkBwBciFkApWxKJFvVPZoTXlBnxdFITeAcjUeSGkSbaGH3AeY=
X-Received: by 2002:a63:205f:: with SMTP id r31mr2336839pgm.159.1567803816771;
 Fri, 06 Sep 2019 14:03:36 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:11 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-8-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-test PATCH v4 7/9] vmx: Allow vmx_tests to reset the test_guest_func
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest state tests are to be grouped together under a single
vmx_test, vmx_guest_state_area_test(). However, each sub-test is an
independent test that sets up its guest. test_set_guest() only allows a
guest function to be set once in the lifetime of a vmx_test.

Add a new helper, vmx_reset_guest(), which the guest state tests may use
to set the guest function more than once. Also, this function will reset
the VMCS as if running another independent test.

Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx.c       | 13 +++++++++++++
 x86/vmx.h       |  1 +
 x86/vmx_tests.c |  2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6079420db33a..37e31c284399 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1772,6 +1772,19 @@ void test_set_guest(test_guest_func func)
 	v2_guest_main = func;
 }
 
+/*
+ * Reset the target for the enter_guest call, re-initialize VMCS. For tests
+ * that wish to run multiple sub-tests under the same vmx_test parent function
+ */
+void test_reset_guest(test_guest_func func)
+{
+	assert(current->v2);
+	init_vmcs(&(current->vmcs));
+	v2_guest_main = func;
+	launched = 0;
+	guest_finished = 0;
+}
+
 static void check_for_guest_termination(void)
 {
 	if (is_hypercall()) {
diff --git a/x86/vmx.h b/x86/vmx.h
index 75abf9a489dd..217114c3bf3a 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -824,6 +824,7 @@ void enter_guest_with_invalid_guest_state(void);
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
 void test_set_guest(test_guest_func func);
+void test_reset_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24a771a..6f46c7759c85 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6858,7 +6858,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 	vmcs_clear_bits(ctrl_field, ctrl_bit);
 	if (field == GUEST_PAT) {
 		vmx_set_test_stage(1);
-		test_set_guest(guest_state_test_main);
+		test_reset_guest(guest_state_test_main);
 	}
 
 	for (i = 0; i < 256; i = (i < PAT_VAL_LIMIT) ? i + 1 : i * 2) {
-- 
2.23.0.187.g17f5b7556c-goog

