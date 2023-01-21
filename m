Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B223676246
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjAUAT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjAUAT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:19:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE9973AE2
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:19:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u186-20020a2560c3000000b007c8e2cf3668so7483755ybb.14
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1cq5TEY5bFZVJppj5PKXCCtP6lFgiUZJ/1ln+dN3QA=;
        b=d1BYzlQoyUn3i39+FvKM79uWm+WNumy+bfjZlFFt/ZeDDVwQWpIuwDbs8iEHxMAwsW
         KemJHYCtN/DXYLLL7eQMUQ5YoGIbIKVJyQbpifPKbv5sHtgugbasOAGzialVGpfRPQBs
         h4GLFakYbatPvZVmKsx9xS1aKnfRLeWB6nL2XS489S1AQ0FPgdgYIeaomBRx5A/5KSq4
         5zmugkm9l1T4am+6d1w08U/IbwUDhbYYWwsov9TNA0OnGuXEi3eq6lgMQXFz9PW276mF
         Eb19dt3W55wzwsgepb006ykB8rV/nTqzjPvPN8ndjJB2tcFRGQs2nt8kfwwiLKEajqtm
         2wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1cq5TEY5bFZVJppj5PKXCCtP6lFgiUZJ/1ln+dN3QA=;
        b=WoNz69cuneFUPH1dJ1m6EmopindlyzFu7WUrgPGXiNnLI2iJkNAavfVYjLLQ3A8ZfH
         ukjcGGJcgS5T/36CJn0e5TS/P8nyBYu24o5wwL/zMW93MijUSiMSvCBAYt/rDKQcyLqA
         z/ADDOFiRP9CtXWoRpu6kpfQmR77j+GgINseA3EoMUY5WwP9QMQZ3MFmgKlNhPog/3M0
         NjruBbBH80pRiUxZLrURt83SSeCgjDuxZf+KXunnxjlT/u9WdM/33wu3M3FxlL2/imdx
         JMDbf5l6fyVumc53GD57RW3c4c/LsjsFn4zjGvNn6X2XxqmCUW11/Uj75EhygXvM2B0h
         BXlw==
X-Gm-Message-State: AFqh2kolm3G9ck18886Sf2btXXVCRj1W7Ehsaghv83tHpoLJiuBO1CMr
        LxvLjl7QMxMARESWHcyTYKjbxCLnWN411SXOIg==
X-Google-Smtp-Source: AMrXdXsKPQ7RdQsZJh0HCn7FotF1wMUoexsS6TfkTsPP/Sd5BeAcVkKJWPwo+TQ+YiggVLrbHck2EozyECapRFWA7A==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:f908:0:b0:4fa:fa3a:72e with SMTP
 id x8-20020a81f908000000b004fafa3a072emr858885ywm.231.1674260290351; Fri, 20
 Jan 2023 16:18:10 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:15:38 +0000
In-Reply-To: <20230121001542.2472357-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230121001542.2472357-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230121001542.2472357-28-ackerleytng@google.com>
Subject: [RFC PATCH v3 27/31] KVM: selftests: Expose _vm_vaddr_alloc
From:   Ackerley Tng <ackerleytng@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_vaddr_alloc always allocates memory in memslot 0. This allows users
of this function to choose which memslot to allocate virtual memory
in.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c          | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 950fd337898e1..abeffa5a47e88 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -406,6 +406,9 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+vm_vaddr_t
+_vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+		vm_paddr_t paddr_min, uint32_t data_memslot, bool encrypt);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_1to1(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4e5928fa71c44..2f1e592d29dfd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1286,7 +1286,7 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-static vm_vaddr_t
+vm_vaddr_t
 _vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 		vm_paddr_t paddr_min, uint32_t data_memslot, bool encrypt)
 {
-- 
2.39.0.246.g2a6d74b583-goog

