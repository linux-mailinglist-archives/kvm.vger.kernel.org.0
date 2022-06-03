Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECDF53C22F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiFCAq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiFCApL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F233887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:10 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c2f3431b4so55446327b3.21
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VZMwLmFqO453NHprqwEEDpT8gC6YhxFhEoVIqaq5qNQ=;
        b=RZPO/BZvQ6+tlf6F61RdUXEyZo2pt9UgbKBDaKQgoXVaf2hQLnCU2GdNQb4etp5S0S
         Fa8wHOP3EVbG9DN0mTOH8dfq7SJ6w789/YYFTuaj5gojST8OV/5QnMEqhQ/ZYeEV0Xdc
         ndoTyLDWjU7TgfR03lt6NtZcIOW4w8jYuxoO/CGsMc29pCDcrEylQKQvsHGQ6iodLR1W
         BXoqVzLF47Qp2sqhw71NHmgcpaR/tWgN3MACsorJYA3PQOEBFSV0xNTRkSIUhI77quex
         9OyTWuf8e7VtNvKcYIR5U+PrxHRtvY3+p1v6RwGu2KXX3cQelYGT5velWWtiYi968+Bi
         Io2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VZMwLmFqO453NHprqwEEDpT8gC6YhxFhEoVIqaq5qNQ=;
        b=hBtVE9YSlU+gxj+4Dzrq2+OurgWOAfKUZFvCLI/qzAZY3eSmhU+fj/osCt88l+9VX+
         XIYqJt9FiWuWNrRX/ZGXnVHjuL7Z1BPIqjZW7PvbwT/aA31qD3RD9DJXb0G/VXm8Bjdo
         RBxR4h7qQfOFYQIPoblGjEtFVyc9GfzUkhp2p+2e9gklZacm82S84npohJdPyeo+98Cb
         ud5Zv1T7kh1tokEfz+c5o5EiU+vAX5ZUci4WxMqNfjeI4uoTTgoKem993PArNZlKjqNY
         7E7dgSGAN98rzrzyWzfdq4GdrkmFT9sPphj9ynADsl3eWyJ4Xcv7MXjKvSbec+GPTZ7a
         wwOQ==
X-Gm-Message-State: AOAM5331VusA6TwJdSE+LacyUwo9L5DdSKVI63gFyj51OlGpYTzU3pDO
        qKsDaFB7WI1r4fnYaiVdTcIXnxr6R1o=
X-Google-Smtp-Source: ABdhPJyvo+2ll/p2OR5AVovkndzYR4mFDAyHaQ/X8PTogoLDLjktOHVeFdF1jZS4k4FVf+f5jQQMa1G4HWw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:7308:0:b0:65b:eb8b:de95 with SMTP id
 o8-20020a257308000000b0065beb8bde95mr8527850ybc.195.1654217110100; Thu, 02
 Jun 2022 17:45:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:58 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-52-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 051/144] KVM: selftests: Convert rseq_test away from VCPU_ID
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

Convert rseq_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..fd754de0b74c 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -20,8 +20,6 @@
 #include "processor.h"
 #include "test_util.h"
 
-#define VCPU_ID 0
-
 static __thread volatile struct rseq __rseq = {
 	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
 };
@@ -207,6 +205,7 @@ int main(int argc, char *argv[])
 {
 	int r, i, snapshot;
 	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
 	u32 cpu, rseq_cpu;
 
 	/* Tell stdout not to buffer its content */
@@ -228,14 +227,14 @@ int main(int argc, char *argv[])
 	 * GUEST_SYNC, while concurrently migrating the process by setting its
 	 * CPU affinity.
 	 */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker, 0);
 
 	for (i = 0; !done; i++) {
-		vcpu_run(vm, VCPU_ID);
-		TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+		vcpu_run(vm, vcpu->id);
+		TEST_ASSERT(get_ucall(vm, vcpu->id, NULL) == UCALL_SYNC,
 			    "Guest failed?");
 
 		/*
-- 
2.36.1.255.ge46751e96f-goog

