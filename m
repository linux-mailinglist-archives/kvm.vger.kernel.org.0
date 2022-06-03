Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5353C255
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiFCApe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiFCAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1432335A9A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q195-20020a632acc000000b003fcb9b2b053so2378736pgq.4
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MJVn8lgVKxvVraUGQdIqlR3qlBQ10uhP3yXGydsZbkA=;
        b=h41HAfLJixbFx0lWwxUXPX0fWFVDWWf3TDfX5ng8Jv57JSORyI8+ZbGdgxk5Qyr0oT
         iNL/1/hSNgXOO/B5gfK8B28rP93y+Kod+oa4D94mBBY95QjlzSDRRUMRUkfB4sHGbTsJ
         eTWI4QFwY3tM0rnC0VjGpV596gg4Ja+9JWP97ZRz0PLN2mPGYywWcHonP2kZlZSrb7Xe
         WryTnZhmTMFhJvfT9PXxNYnAEo2D/3wuPj5uF4iFW/3ZzSXxlfSyu6h0Xdk/0OwvXSVK
         EJHk/GA3LupFh0jVl/LxZRDJH5iUpnV4HnSJt/utr/BxnXOngQImapwcDpqiptJ28BRt
         LDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MJVn8lgVKxvVraUGQdIqlR3qlBQ10uhP3yXGydsZbkA=;
        b=XQocGLmM4ZTLG3rA1p6l8hM0mIxLF2FqdsWDb9e8wVRhouasTqYG6CtFKfrpcDX7M8
         WNBBQ0o7Rd7ai6vsQ3ybz2NeciXQ0K2kbqEKpktF8yvKE0OV1+7BsJkMAnltiBXaC8hW
         Od9W7DVjY1bFLkWXbYmfLNYejuLKB2x7dWuvtKzC1cZoxZZyycOllHkqlb7JalM23cdg
         N5LhKBaw956REFWGe2mDc1daskxtoH5N84KG9tRcIkPzGihAzhre20TNZjL78Z5+BlAB
         uTApG+ljDtfSxh3hl4VeJQKHcbRV86nZuwotdkCQyNL2zG4fMyX919bxHMav/SpacKqq
         ILNg==
X-Gm-Message-State: AOAM532eHsLKEvjrffukfl0R0oi1uBD7dkKQVoVYw73GzBi+0XcUjKRf
        YzZm+y3bnAvaR5pSQ2/M04jHTEp2XwI=
X-Google-Smtp-Source: ABdhPJxwF/uWAoXaSjvBRKiURJu1bgq1NlCZH3n26JoqeD0U6eqjh92J+lNNV9Q7Zl1EI1VrVOnPiVNGwpo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b82:b0:1e6:7853:c004 with SMTP id
 lr2-20020a17090b4b8200b001e67853c004mr8914781pjb.136.1654217039534; Thu, 02
 Jun 2022 17:43:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:20 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 013/144] KVM: selftests: Remove vcpu_get_fd()
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

Drop vcpu_get_fd(), it no longer has any users, and really should not
exist as the framework has failed if tests need to manually operate on
a vCPU fd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 -
 tools/testing/selftests/kvm/lib/kvm_util.c          | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6b7a5297053e..c2dfc4341b31 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -214,7 +214,6 @@ static inline int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	return __vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
 }
 
-int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 45895c9ca35a..73123b9d9625 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1608,15 +1608,6 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	return rc;
 }
 
-int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	return vcpu->fd;
-}
-
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-- 
2.36.1.255.ge46751e96f-goog

