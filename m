Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D095A7089
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiH3WUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiH3WUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:20:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99162654E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:20:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e16-20020a17090301d000b00172fbf52e7dso8777704plh.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=/1/sdSVljrZtE+cOlvr7FEjtfDcy2AsBCQfMmau9WfQ=;
        b=Hl5NJHIIf9AjxMn6KkyCTnFp1wbi9nT9TChdGDiN1QnlBXWMcbuTu/orvkNm/XT6X6
         x+yi9M5RODBfwi/1eZg7fqFXu8DstSIpVwVVk1PZHjDV8IhyrpZvy2K4WYJft72eyPfZ
         AnwR8ehdBDS5R5ohZHvImQuYc3s6Nj3pMj5WlsPhC9RssJcPIZkhF+OODAeStTz2b/iJ
         1yN1+NJPHEf+wblVhbTKJ1CAbiPm7LtWcpo8+sfVTLwsded6UwMxIrSmWG35wtNUiMAq
         DNUn2AjMXNEWMoAfEivES+z26jvGelo4VfDMKN/KRE7q0o66Vbgg7cGEXiaWnk3g7+jK
         dKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=/1/sdSVljrZtE+cOlvr7FEjtfDcy2AsBCQfMmau9WfQ=;
        b=CCUuHw8PTxsvAaOLT1hIOSXskyYhvYa47cuLYofc/wrdXAuZwFYSOpcKZJjfw8PXeI
         knjRpCj6NRXQ0gCkY4jUY4ifJMphK8EXHPXdZ5eHe0q6X4T0zpa/jrhmtDtt2BG1xsc7
         Jv8IAiWGyJyQHz6KPsv1p3FjgjlaU8a/4WF7K869Gf4di16Ivxy2qnCrD+J5bs00OHJ+
         1LQfqdu6V+eTrz8TB88gL1Zw0FMLVyKKbeoSozwxl3G3t1ViV6WJJOxxCvDQKVdlscTR
         Y6GaENy+6iOxFLMkVFDi/lDsH9AZDTKCeFCakFHVvmdHi3+JLvRBm3TLclKTTn3+IN5T
         E6EA==
X-Gm-Message-State: ACgBeo11KvwtcP8WF0Q+CtNL6n99qUksIWDPjzDxri6H0NLY51U+8ofK
        r4EakUY9vGimqBs5+SuqMnVY11sRMQ==
X-Google-Smtp-Source: AA6agR6eeDtQGXqnkPM1B1p4L+32NSn7HTIayprlj+H2vAC0mW1iQTGm+kZwcup5REG0kEuCvw/zSq/9hQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a17:902:c613:b0:174:7a32:f76 with SMTP id
 r19-20020a170902c61300b001747a320f76mr15784815plr.165.1661898007252; Tue, 30
 Aug 2022 15:20:07 -0700 (PDT)
Date:   Tue, 30 Aug 2022 22:19:44 +0000
In-Reply-To: <20220830222000.709028-1-sagis@google.com>
Mime-Version: 1.0
References: <20220830222000.709028-1-sagis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220830222000.709028-2-sagis@google.com>
Subject: [RFC PATCH v2 01/17] KVM: selftests: Add support for creating
 non-default type VMs
From:   Sagi Shahar <sagis@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Ryan Afranji <afranji@google.com>,
        Roger Wang <runanwang@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>, Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Like Xu <like.xu@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

From: Erdem Aktas <erdemaktas@google.com>

Currently vm_create function only creates KVM_VM_TYPE_DEFAULT type VMs.
Adding type parameter to ____vm_create to create new VM types.

Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c          | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..2de7a7a2e56b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -26,6 +26,8 @@
 
 #define NSEC_PER_SEC 1000000000L
 
+#define KVM_VM_TYPE_DEFAULT	0
+
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
@@ -642,13 +644,13 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
  * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
+struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages, int type);
 struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 			   uint64_t nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
 {
-	return ____vm_create(VM_MODE_DEFAULT, 0);
+	return ____vm_create(VM_MODE_DEFAULT, 0, KVM_VM_TYPE_DEFAULT);
 }
 
 static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..ac10ad8919a6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -143,7 +143,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
+struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages, int type)
 {
 	struct kvm_vm *vm;
 
@@ -159,7 +159,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	hash_init(vm->regions.slot_hash);
 
 	vm->mode = mode;
-	vm->type = 0;
+	vm->type = type;
 
 	vm->pa_bits = vm_guest_mode_params[mode].pa_bits;
 	vm->va_bits = vm_guest_mode_params[mode].va_bits;
@@ -294,7 +294,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct kvm_vm *vm;
 
-	vm = ____vm_create(mode, nr_pages);
+	vm = ____vm_create(mode, nr_pages, KVM_VM_TYPE_DEFAULT);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
-- 
2.37.2.789.g6183377224-goog

