Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6126751B24C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379437AbiEDWyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379439AbiEDWyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:05 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC9911C13
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gb16-20020a17090b061000b001d78792caebso1317050pjb.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CCjFdttK3ojszU+ceLKLHTNc3RJgVsyUXIdUXpmHmJ0=;
        b=F8oSR/oCtITryrxXQb/bUhxlifCVsN/ZGwm4DP8RxFYPNw2529DRRxU7jT6Q+sX6K3
         iqybSuhKP3aJykLC5j03lrbtFgELCVkIP9wzWSDeLRUtOyon3zZ52GaTk9QHaBb0zhnq
         p8GOx2WjqEmArX9vHnsCatMp7KsgCmsQAD7z+9VT4xJlA+o3qV4gwBfo8v24VO+mOEPV
         KpEEbr1L5Czfqe9457KQkn4vSX0zcSO1+ToIExzzEq6sEVUQPTFm95w4kmFo76dyri0e
         KNTnByyik9cdij91szDVlprIduTWrDpl7M8KrDXDSCDNYmJ2jUgH8GE/ZBu2bF6xaleX
         6YdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CCjFdttK3ojszU+ceLKLHTNc3RJgVsyUXIdUXpmHmJ0=;
        b=g7u4VAwq9CdgDZN24mvY6PSKXE3z8JFDZ8J6jkQ3WbHfRA77Zz20B54QSdMg3DYuhJ
         1v1bTn3+EEVo3UV8fCkvSbHymxeXEL2Dnkj/O0xJFxDVcVPr8MH2cwrBY7h57ynydcSA
         jpvTF1XXb/MJLxmZ61N4/BPRkm5MvW219mY4/ZA5ZWtTSl10L9Owm2Nb8DQVXzhK9oTw
         HUS2EoNi6jJQD1EwowaaqaIHKw5gB+gXvsfzNBM9i982DP2iNUdG5VSMgS6qEWINQeF/
         TcuTPu3kO6K8dujLB7YY8K7az1WEpsZCk4O3Hgr1yQ5GSPkStkdDBOf4c/tXbLp31/KZ
         F2XQ==
X-Gm-Message-State: AOAM530kmydVggJc6O+gmeYfzLrUGndOjkzChPYuav1aqJoUu+fHX8Sz
        J19jq3k5fkMuiLMIty/77t5wbnD+6U8=
X-Google-Smtp-Source: ABdhPJyF+9X097h6QDljW/0vVEuPwsUfGtuebUGPmAllqyCOQx3Y0xbVnWuSrXw9faXvqvdPZa8xp0sE0gU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:174a:b0:50d:44ca:4b with SMTP id
 j10-20020a056a00174a00b0050d44ca004bmr22965190pfc.0.1651704621604; Wed, 04
 May 2022 15:50:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:35 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-30-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 029/128] KVM: selftests: Add vm_create_*() variants to
 expose/return 'struct vcpu'
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add VM creation helpers to expose/return 'struct vcpu' so that tests
don't have to hardcode a VCPU_ID or make assumptions about what vCPU ID
is used by the framework just to retrieve a vCPU the test created.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h      | 16 ++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 5d06d384bf10..07c453428e06 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -627,6 +627,22 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 /* Create a default VM without any vcpus. */
 struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
 
+/*
+ * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
+ * additional pages of guest memory.  Returns the VM and vCPU (via out param).
+ */
+struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+					 uint64_t extra_mem_pages,
+					 void *guest_code);
+
+static inline struct kvm_vm *vm_create_with_one_vcpu(struct vcpu **vcpu,
+						     void *guest_code)
+{
+	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
+}
+
+struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
+
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 937e1b80a420..bf14574288e7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -373,6 +373,16 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 					    (uint32_t []){ vcpuid });
 }
 
+struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+					 uint64_t extra_mem_pages,
+					 void *guest_code)
+{
+	struct kvm_vm *vm = vm_create_default(0, extra_mem_pages, guest_code);
+
+	*vcpu = vcpu_get(vm, 0);
+	return vm;
+}
+
 /*
  * VM Restart
  *
@@ -407,6 +417,14 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
+struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
+{
+	kvm_vm_restart(vm);
+
+	vm_vcpu_add(vm, 0);
+	return vcpu_get(vm, 0);
+}
+
 /*
  * Userspace Memory Region Find
  *
-- 
2.36.0.464.gb9c8b46e94-goog

