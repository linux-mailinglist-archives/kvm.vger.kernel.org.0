Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E8353C1FB
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbiFCA4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiFCAuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505092DAB3
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso3520601pjd.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8JeyZOJgqRFYgLmKXkBPXYw3glS3GBy+qObYYGBlkn8=;
        b=jIg9k4fyVnKA6hURXpd1DSloJ62tqnK/jZ+j2XJWkPiBVxFvgAf1iN1Ek2x9LWibN3
         BycqhT3Q5AuEyjt8d1cwnCCSWJx+5SF/MjNTUvRP1y+R7wS+vQ0YEVR4tW7SOq1dD3oF
         +5dA2AClwovvzyfG9yjYyrdr65dQmcG3dw8h3MIub5QkPDm5VLaxTtlq6krhyRKqqT5U
         J48DsF4JDHgKyuWT13xeplJFmVs2p72nhZMj/4E1pb9xMLh1bMEjGb1lKWIFaPa5LKQd
         gdgoqLqXRgeoSL5roHagtkCg8kqxnG8wgH1NDPR/5Tq+AHn30wZvwWAz1+OraG8G4YhF
         OaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8JeyZOJgqRFYgLmKXkBPXYw3glS3GBy+qObYYGBlkn8=;
        b=ASVfVTC+Z8nw5IJtCb0r7hSiC/hmx5IooldlFkI1ggOe6HS6lqYK3dB12BZq7m+v72
         k50yS8LbVAUMFSvepRvwm0ryP7hVznk80Z4h2NpzMQcOigcCrCf0uazogpu8yny/V+X0
         Yu/cCFr1CBDxQWNjwO4sFqGJgBCbUs/W0M+Cycgnyv65rqR3cNiuWWeuJcipVOPejHZ2
         vcuPNJYqRPfNXXlCzQ+Z2wBewdMa6+EI7O/NoamF4dlIKlCfKYSmy1Fl7SZIPyfvuK5m
         a06qoE/6yaHLjraGAt94awm0PzPzix3i1pLpi3sZqJkDw2EpO6jFsGU9V8K0ZcLmH1Me
         eKKQ==
X-Gm-Message-State: AOAM531qhOJeeg9i8fNFjOxt/o6t/YWjNmq5gXr9Wgz6R1ByEgD2bFD7
        Es7En7FD6iMQfjL+B2FoQSrsi9dF+pc=
X-Google-Smtp-Source: ABdhPJz12WyKDUQSxgUUJgQEaIGlyjnUyF5u7Z+2RR/3K9Oji+MjLkhAJ6QaZojY1ryHer+I3qHJ7w1Wmfs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:be14:0:b0:505:a43b:cf6e with SMTP id
 l20-20020a62be14000000b00505a43bcf6emr74919345pff.33.1654217253233; Thu, 02
 Jun 2022 17:47:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:18 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-132-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 131/144] KVM: selftests: Require vCPU output array when
 creating VM with vCPUs
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Require the caller of __vm_create_with_vcpus() to provide a non-NULL
array of vCPUs now that all callers do so.  It's extremely unlikely a
test will have a legitimate use case for creating a VM with vCPUs without
wanting to do something with those vCPUs, and if there is such a use case,
requiring that one-off test to provide a dummy array is a minor
annoyance.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6ba28018e723..36992bace6c0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -302,10 +302,11 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 				      struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
-	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int i;
 
+	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
+
 	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
 	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
 		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
@@ -326,11 +327,8 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 
 	vm = __vm_create(mode, pages);
 
-	for (i = 0; i < nr_vcpus; ++i) {
-		vcpu = vm_vcpu_add(vm, i, guest_code);
-		if (vcpus)
-			vcpus[i] = vcpu;
-	}
+	for (i = 0; i < nr_vcpus; ++i)
+		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
 
 	return vm;
 }
-- 
2.36.1.255.ge46751e96f-goog

