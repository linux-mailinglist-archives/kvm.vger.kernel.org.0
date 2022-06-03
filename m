Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CB653C225
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbiFCA5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240798AbiFCAuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A988B24BC9
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3043024pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=atArEiJp1kb8rVKjSaRcbMKJL55Q7qDngNFebbBXIus=;
        b=a4XpsL8IxxkJ+JjrZIOeRkTqsKontYyIJN3q84RteOSVBDdZlYMxWdTZwTHTHMPQEa
         RaRdV7i9NZKle0Rmz7tf/limvDNcWuu2Zr+TwvkIkwW16FSXNDS394uZclLKYk7nOy0t
         JSTbPgbjb6RQz6F44umXnb2QdnKeZ8xvHan50z698w74JneNTfCHVQHn/F+hPGA3hetg
         6HDPegIZl9Ie6X90WI9yrjXo0dKo3fdqDl8Jth1VaAwwuGHQd4PIWKwZI0RGrrULlwmA
         hLUKcC/B1+meOqS5qOXXS3po5TWa/9gKlv74R/Hkcy1LFLKe6rJ4qjKPU1ylqx0uloYH
         zILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=atArEiJp1kb8rVKjSaRcbMKJL55Q7qDngNFebbBXIus=;
        b=cn0L/v2lB+gf2EnebUW6gsKBrXgWPqKjdyOmquas5tlPhX6Q1C9DadUCxsusMUL7WI
         49I+fuksG2Ifavs9KygSSoQAlskvdM0AO5wBvlFWjpnGiv4nZAiqaryiS4jyBX9uM5vc
         nmyH9SrOoaTy4k9fZgztqIjPi/hVXYkLzVvD/tUEy0CUNkgpM+3nqpciJ6Gt/LkPrgvo
         O9rq5AyXp2jVgov9L+Av+fJU6WaeRbyEeZVcN2CTFbcauGaXna0tuQX8H/Ms5GEJx+14
         g+LTfCL1qHEMO90r7+GIHPbTxhfgoYjKnry2XCbW6CkIc6gIcZlacCYRjOBTI2PcA9PM
         vHKw==
X-Gm-Message-State: AOAM533MhtW40C5jIoADAM4HhNK4pihkgvPfJTxN3KvM9OmIZyd9oByE
        527j3poqoS5IaHardHPgnCuSwcqhpBM=
X-Google-Smtp-Source: ABdhPJyNb8kAM+QHeYchzj+F8Cq3TlF26hN8NFqs8SmsmkHxITbp+A0uJYgT7Ah/Ak3tRlido5K9J7Qt7Sw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:120a:b0:15f:99f:95bc with SMTP id
 l10-20020a170903120a00b0015f099f95bcmr7650867plh.48.1654217231179; Thu, 02
 Jun 2022 17:47:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:06 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-120-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 119/144] KVM: selftests: Convert s390x/diag318_test_handler
 away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert diag318_test_handler to use vm_create_with_vcpus() and pass around a
'struct kvm_vcpu' object instead of passing around vCPU IDs.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==6.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/s390x/diag318_test_handler.c       | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
index 86b9e611ad87..21c31fe10c1a 100644
--- a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -8,8 +8,6 @@
 #include "test_util.h"
 #include "kvm_util.h"
 
-#define VCPU_ID	6
-
 #define ICPT_INSTRUCTION	0x04
 #define IPA0_DIAG		0x8300
 
@@ -27,14 +25,15 @@ static void guest_code(void)
  */
 static uint64_t diag318_handler(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	uint64_t reg;
 	uint64_t diag318_info;
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	vcpu_run(vm, VCPU_ID);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_run(vm, vcpu->id);
+	run = vcpu->run;
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
 		    "DIAGNOSE 0x0318 instruction was not intercepted");
-- 
2.36.1.255.ge46751e96f-goog

