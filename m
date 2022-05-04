Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E579651B251
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379367AbiEDWyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379423AbiEDWyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB90633F
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s68-20020a637747000000b003aaff19b95bso1352749pgc.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bS1JnwmFoqnz6fKaqQP9Ax0YC4MVWcJGi1pcVulGY0E=;
        b=GJ0tm7YShP4rbsgcay7UeMRP3cb6NJC8p673pBAiMCXrIU2GWFJei0OPF7kuZXNCOX
         Xvpd6Pe34ksgkEHdVIKqAYKUp79jpUhXdYJwgx5ChwjG/+MY8xNnNDcQ8SScOU9vV0Yj
         WGMKK6FpICc1texMyMhciRBgmaY9l5OmbMnh4k6vUsddY2iGSjthQsmdW9bD05EEghTU
         FVINQZR35sFxoQqm2HZJCejIMEHyDeOJq02MEBw2QWsYpiRysaA5cVingbLLhU1PI8KD
         UZrz4PS5uyOUDHnMyOQ3F7SqqiE1Pi52EMQcks/dgoD0maFPJ7JQeJo6jZRLY2QoukWY
         rM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bS1JnwmFoqnz6fKaqQP9Ax0YC4MVWcJGi1pcVulGY0E=;
        b=NrHyWdQQnXaaWVxUDQcMvS6YdfyGPguQOj1RWMEoN9qwhW64kzHkkgntcC8zj0EqqE
         LSA2V20Gdare/2y8BkJA7mYpG8v5VyGOM4KP0XxXxHyq5KoMQvcTrlFSCxk35I1UyUIf
         LH/qyprgpdZWNedd188NUBpqSU/iRH4L1mSZ7M00ed6dqcdIR1HESR/yimWlZgEKLd9i
         u+PmMgSnJfFcwHh2BJIjrkDO0oJ6C1Aadv4uF6nJ3l0wz6OchPmht4hTJcNDfT5tiP6p
         xgl9WxcZpCMMiI9q8eL49nIuU56CeBIz+udYAtNai6a9/ePV0f3g5wi1iXUFdUR4FPIL
         n7JQ==
X-Gm-Message-State: AOAM532h111df8n/jrFa4hqvcZ8dTpZppIXLzDI6x/VdFeoTR4pNqbVj
        a4YNjn2p1l3WOQvTPbG/Qh2OCyh8JqU=
X-Google-Smtp-Source: ABdhPJx8ILgf/ODZTw1L8q8mgG2X/4nVaMXkK6Yxppdi3PH2RaVRqZEiCAMnWA/Nv89d1zz0nIOZXK/92ow=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1205:b0:15e:8cbc:fd2b with SMTP id
 l5-20020a170903120500b0015e8cbcfd2bmr23990616plh.99.1651704620058; Wed, 04
 May 2022 15:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:34 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-29-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 028/128] KVM: selftests: Add a VM backpointer to 'struct vcpu'
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Add a backpointer to 'struct vcpu' so that tests can get at the owning
VM when passing around a vCPU object.  Long term, this will be little
more than a nice-to-have feature, but in the short term it is a critical
step toward purging the VM+vcpu_id ioctl mess without introducing even
more churn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c508a860984f..5d06d384bf10 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -47,6 +47,7 @@ struct vcpu {
 	struct list_head list;
 	uint32_t id;
 	int fd;
+	struct kvm_vm *vm;
 	struct kvm_run *state;
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c654c81f7d9d..937e1b80a420 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1099,6 +1099,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu = calloc(1, sizeof(*vcpu));
 	TEST_ASSERT(vcpu != NULL, "Insufficient Memory");
 
+	vcpu->vm = vm;
 	vcpu->id = vcpuid;
 	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpuid);
 	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
-- 
2.36.0.464.gb9c8b46e94-goog

