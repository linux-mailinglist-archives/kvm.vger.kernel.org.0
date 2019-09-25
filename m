Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4059ABE223
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501941AbfIYQOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:14:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41156 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501893AbfIYQOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id h7so7645749wrw.8
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZsN4yJ+cKefDSI9gMJYMaAs3GGrqpiNIRsh5EA+8dkI=;
        b=BHZYujlkwLRePS3KV8Pytm3XxRmmALvUu5c1dZI6X+Uh3k+S5yF5p+zg90fSUueub9
         jlsl9FC0Rcdzmu5K5CXg/j4VVSIEOWMXSr+ERHSm5NHx2bp4S4bnGnVj6VP1dcqebB4T
         x7sDiAhsYT45R8pzF71NKOTnrbCMiPmUXyS8nTvFlW5BWp8nrMUEza+dx2bQIR307+1l
         TpG7RrBc2lEy19GlNQNgl4o3BC/yvkqmocGU4cNR9dmAb9DjOaSaInxoR7b3MOlwgi5U
         Jz76wUrdowv291ttNCKgSKuJXa/EZEoKQTGyCZAY/sXVQSTeWvejNwXfR4fGGipVFQpv
         8QnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ZsN4yJ+cKefDSI9gMJYMaAs3GGrqpiNIRsh5EA+8dkI=;
        b=oUe+uKnHfo+9mbtlUKkJzNzd1CKSg0ywCdZ1SGm3ZrSZyzK47eh3bU4bReUsfp5FO6
         Z7o5R66p/PFMBA01fZwE70c1Vpt+Xnu+vnsZa4lf0RvmiKkTSJS1K4U6ZAJ3G++hTfBJ
         QnVdQZimKSVkYgpQNlC5Gy/78uOhv8Wl4iR6n8yDvBsTo9ScfI98g0pMqf23KrxaTQww
         HPQHOpg3A5TOvuXhcHQ7zxwbMjU3yl8qjS41q2ABOJDbUislu/TUvddeN03FewmXgKPL
         IKrxsyhHgE1OWUDICa0+VYxtkKmLwbJGDTrsoxR2uNs4kGHkrPPbt9fZ39/bdcDK9d23
         ep+g==
X-Gm-Message-State: APjAAAW3A9yhqzQvheBgND+Hi+YNTRtqd8Lr0bHDtmuX581mAjdraJIv
        wzFtwqgBZdSMqIqpVL4VGxEDEiOz
X-Google-Smtp-Source: APXvYqzxQ595aHipY/R/RnEIWqPcXk9nVhlDI9JG5Y2KzQGEdmblIXKVtm7b6j0L69Ki2EvSgq0ERQ==
X-Received: by 2002:adf:f20e:: with SMTP id p14mr9654648wro.212.1569428071839;
        Wed, 25 Sep 2019 09:14:31 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a71sm4055293wme.11.2019.09.25.09.14.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:14:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 3/4] x86: vmx_tests: prepare for extending guest state area tests
Date:   Wed, 25 Sep 2019 18:14:25 +0200
Message-Id: <1569428066-27894-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the test setup and teardown from test_pat to vmx_guest_state_area_test,
so that we can add more tests after test_load_guest_pat.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8851f64..97aff6e 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6879,10 +6879,6 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 	int error;
 
 	vmcs_clear_bits(ctrl_field, ctrl_bit);
-	if (field == GUEST_PAT) {
-		vmx_set_test_stage(1);
-		test_set_guest(guest_state_test_main);
-	}
 
 	for (i = 0; i < 256; i = (i < PAT_VAL_LIMIT) ? i + 1 : i * 2) {
 		/* Test PAT0..PAT7 fields */
@@ -6942,15 +6938,6 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 		}
 	}
 
-	if (field == GUEST_PAT) {
-		/*
-		 * Let the guest finish execution
-		 */
-		vmx_set_test_stage(2);
-		vmcs_write(field, pat_saved);
-		enter_guest();
-	}
-
 	vmcs_write(ctrl_field, ctrl_saved);
 	vmcs_write(field, pat_saved);
 }
@@ -7239,7 +7226,16 @@ static void test_load_guest_pat(void)
  */
 static void vmx_guest_state_area_test(void)
 {
+	vmx_set_test_stage(1);
+	test_set_guest(guest_state_test_main);
+
 	test_load_guest_pat();
+
+	/*
+	 * Let the guest finish execution
+	 */
+	vmx_set_test_stage(2);
+	enter_guest();
 }
 
 static bool valid_vmcs_for_vmentry(void)
-- 
1.8.3.1


