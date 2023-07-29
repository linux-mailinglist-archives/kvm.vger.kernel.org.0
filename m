Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1857679D0
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbjG2Aj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbjG2Aik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:38:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B60468D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d052f49702dso2562979276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591044; x=1691195844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hrn38U8XG/46tZy+we7A1as/nu6Sx8AH5e7Mkf5XcGI=;
        b=kYyOWNI3Tn0tKjaJAbKUbe+RATw5K4fjxiUuaXudh6bQsz0nk+rrWkEwGxoeUE8Rdi
         rXRXsprqtFcJhBkVPM20n/0HtgaEsCoVa8v6/kCKFy7oX2SIHFWg51BkdkmGFEmzSepP
         2gAPtNBnJLTWooycD5UVhbOrN4nOcu3008l3Ceyp9g6PnhBXl4EEwwEtEuZLHJfgU/A5
         UkgXflZWtB7aJlaJepJStf7zhJU2AjXbqkCBxzCqurBavTp7EKn7rwX8d9x+RFTF5RwE
         V2ZZUTjWybiOP9xtSUsLs67rNkXjEZ7XhdkUZ4LcC4gsP4I7E7M3kQhVj8JQpnmfVP0o
         TyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591044; x=1691195844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrn38U8XG/46tZy+we7A1as/nu6Sx8AH5e7Mkf5XcGI=;
        b=B36afH/YvUwIiFvZOCUA0biZneyikXjlmq2khtQSZWU2NnmGS4e9LMtY8MhFFEiWPt
         CY6AZG7kD+rPi8xYqGvLMAz7l0wwuZ4t3j3IU04dgXqwWR+XnsxJbpz8FPKtKLfQD6ap
         cw5nH/6ob3Jg9n5EJHhFHdWXiHNDjYRoqf7iRtAusIH4kP8TrFX93TqaaDsIRRcblIJF
         MQG0QM6oqXC4ay9rMILm4OUY1gncjd2p+AKxV/V30SwBbWodXDfx+P81UEk8VlLU9jQ0
         z4TQVibhKsMHRjFNDZmf1wIe3gmoFexl5rcA7zhSs40TrWQiTKPq/j3k8NxPNLuoaB/q
         rvtQ==
X-Gm-Message-State: ABy/qLZIEYCEhq5kRAHyn5cNcwCY6ASOLx3RdWzZsG9iH5GJgeON9iFL
        kb7zso9ss7QsoIV580OTjvM3o9XLtCc=
X-Google-Smtp-Source: APBJJlGHOQ591JfApZ8THfZnSHgzN+MSYyAoPeR1h4t6+1y6LGBQsuLklV2KgJfnPiU38m7V2ogUBR0+WxY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1611:b0:d0d:587c:e031 with SMTP id
 bw17-20020a056902161100b00d0d587ce031mr20024ybb.9.1690591044658; Fri, 28 Jul
 2023 17:37:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:29 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-21-seanjc@google.com>
Subject: [PATCH v4 20/34] KVM: selftests: Convert x86's CPUID test to printf
 style GUEST_ASSERT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert x86's CPUID test to use printf-based GUEST_ASSERT_EQ() so that
the test prints out debug information.  Note, the test previously used
REPORT_GUEST_ASSERT_2(), but that was pointless because none of the
guest-side code passed any parameters to the assert.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index d3c3aa93f090..eb1b65ffc0d5 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -4,6 +4,8 @@
  *
  * Generic tests for KVM CPUID set/get ioctls
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
@@ -35,10 +37,10 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 			guest_cpuid->entries[i].index,
 			&eax, &ebx, &ecx, &edx);
 
-		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
-			     ebx == guest_cpuid->entries[i].ebx &&
-			     ecx == guest_cpuid->entries[i].ecx &&
-			     edx == guest_cpuid->entries[i].edx);
+		GUEST_ASSERT_EQ(eax, guest_cpuid->entries[i].eax);
+		GUEST_ASSERT_EQ(ebx, guest_cpuid->entries[i].ebx);
+		GUEST_ASSERT_EQ(ecx, guest_cpuid->entries[i].ecx);
+		GUEST_ASSERT_EQ(edx, guest_cpuid->entries[i].edx);
 	}
 
 }
@@ -51,7 +53,7 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 
 	GUEST_SYNC(2);
 
-	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF) == 0x40000001);
+	GUEST_ASSERT_EQ(this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF), 0x40000001);
 
 	GUEST_DONE();
 }
@@ -116,7 +118,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 	case UCALL_DONE:
 		return;
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
 			    exit_reason_str(vcpu->run->exit_reason));
-- 
2.41.0.487.g6d72f3e995-goog

