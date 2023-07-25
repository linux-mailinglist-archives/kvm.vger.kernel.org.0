Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB5762595
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjGYWDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjGYWDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:03:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AF23591
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-573cacf4804so75942457b3.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322546; x=1690927346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9K41uZJPRAaLfZAxcyXvJMZOSv31CqLM2GpGiII81Fk=;
        b=JTk9de4/K946u8Ay850Ku0iIgatOSwKmZ/i3BV7a+jW4VknP2oV0EIgnk12pyHrwGh
         2MSWY6/f7UiPYJyMQEKZa7TZf5eqN4nX8xSH5LpxDf4iGp7YF75id+IDZXdMTO3Yhx3B
         zRTNGbRsvYuRm3C4lVfXH8nJStrRylftYvpUkafZoYSVvlETwo+SpNkqhRNeDXIG7Se4
         eK9p8lKew0Ad2XFhnXRW2gUCQI8aI/6ELrUH4z2LRvVaXIxIlNpjE5k8IG34DuIOpOd+
         QBU0RdwVCFH5d9zOMZcV0hdMaDb7KYD8+EgVVTzqEPKZmLTJQWUIe1hNcoRjw/+0Klta
         ovPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322546; x=1690927346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9K41uZJPRAaLfZAxcyXvJMZOSv31CqLM2GpGiII81Fk=;
        b=a/nTaIP9zYCcTTiHwJCRPYsaos/G4nN91AAd8erI6fUT6LIuKNcuthaJz5Xw/OW6Zf
         JRJMT25Vnle8UE5zYuRxIFsS7BP4IoAaPi5VO3NdRGoNKjir3b+pHunxFmDOPP0B89G2
         9gvK2gi1zXR82x1EOVU8Yx7Z/W3rV2tVEmqkV27eP0ofUorHGdfADWKfo7vpc1/8vgqX
         RRWwYqzoTXchTA1IoTMeBeVQDMLO84W6YK0S7lIWpdFONAdRo7/JRK+GF18Fqv07mzYl
         nX6ghh+2wUvMteJUuJKERHiiEG3MfnyO/Cm+IL1cLYYGUwFLgOtvR1kFSWw3FKJsD9RO
         xEeg==
X-Gm-Message-State: ABy/qLbdB9zdVr1s5Q2zChPdFwbMwk8ENVhziSfk1+I/pyO42pLMEg/+
        XetpBe8v+8D+Ltf1uB8HZA+wqr2wB5Wh
X-Google-Smtp-Source: APBJJlGVTJ4SPpeiFYtnkUVrNdX14OyOltzfLMR/yqKN/X/VvbxhuLCRXTt2ThJXdftiamLwbSZngrvqdMkm
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a05:6902:56a:b0:d0b:ca14:33fd with SMTP id
 a10-20020a056902056a00b00d0bca1433fdmr1962ybt.8.1690322546274; Tue, 25 Jul
 2023 15:02:26 -0700 (PDT)
Date:   Tue, 25 Jul 2023 22:01:13 +0000
In-Reply-To: <20230725220132.2310657-1-afranji@google.com>
Mime-Version: 1.0
References: <20230725220132.2310657-1-afranji@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725220132.2310657-21-afranji@google.com>
Subject: [PATCH v4 20/28] KVM: selftests: TDX: Verify the behavior when host
 consumes a TD private memory
From:   Ryan Afranji <afranji@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        sagis@google.com, erdemaktas@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, eesposit@redhat.com,
        borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, maciej.szmigiero@oracle.com,
        like.xu@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ackerleytng@google.com
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

The test checks that host can only read fixed values when trying to
access the guest's private memory.

Signed-off-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: Ib30f58764c54122bf554639f0b8adf24b0438b5c
---
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index a6da9fda1c6b..36cc735fad30 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -1062,6 +1062,90 @@ void verify_td_cpuid_tdcall(void)
 	printf("\t ... PASSED\n");
 }
 
+/*
+ * Shared variables between guest and host for host reading private mem test
+ */
+static uint64_t tdx_test_host_read_private_mem_addr;
+#define TDX_HOST_READ_PRIVATE_MEM_PORT_TEST 0x53
+
+void guest_host_read_priv_mem(void)
+{
+	uint64_t ret;
+	uint64_t placeholder = 0;
+
+	/* Set value */
+	*((uint32_t *) tdx_test_host_read_private_mem_addr) = 0xABCD;
+
+	/* Exit so host can read value */
+	ret = tdg_vp_vmcall_instruction_io(
+		TDX_HOST_READ_PRIVATE_MEM_PORT_TEST, 4,
+		TDG_VP_VMCALL_INSTRUCTION_IO_WRITE, &placeholder);
+	if (ret)
+		tdx_test_fatal(ret);
+
+	/* Update guest_var's value and have host reread it. */
+	*((uint32_t *) tdx_test_host_read_private_mem_addr) = 0xFEDC;
+
+	tdx_test_success();
+}
+
+void verify_host_reading_private_mem(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm_vaddr_t test_page;
+	uint64_t *host_virt;
+	uint64_t first_host_read;
+	uint64_t second_host_read;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_host_read_priv_mem);
+
+	test_page = vm_vaddr_alloc_page(vm);
+	TEST_ASSERT(test_page < BIT_ULL(32),
+		"Test address should fit in 32 bits so it can be sent to the guest");
+
+	host_virt = addr_gva2hva(vm, test_page);
+	TEST_ASSERT(host_virt != NULL,
+		"Guest address not found in guest memory regions\n");
+
+	tdx_test_host_read_private_mem_addr = test_page;
+	sync_global_to_guest(vm, tdx_test_host_read_private_mem_addr);
+
+	td_finalize(vm);
+
+	printf("Verifying host's behavior when reading TD private memory:\n");
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_HOST_READ_PRIVATE_MEM_PORT_TEST,
+		4, TDG_VP_VMCALL_INSTRUCTION_IO_WRITE);
+	printf("\t ... Guest's variable contains 0xABCD\n");
+
+	/* Host reads guest's variable. */
+	first_host_read = *host_virt;
+	printf("\t ... Host's read attempt value: %lu\n", first_host_read);
+
+	/* Guest updates variable and host rereads it. */
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	printf("\t ... Guest's variable updated to 0xFEDC\n");
+
+	second_host_read = *host_virt;
+	printf("\t ... Host's second read attempt value: %lu\n",
+		second_host_read);
+
+	TEST_ASSERT(first_host_read == second_host_read,
+		"Host did not read a fixed pattern\n");
+
+	printf("\t ... Fixed pattern was returned to the host\n");
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	setbuf(stdout, NULL);
@@ -1084,6 +1168,7 @@ int main(int argc, char **argv)
 	run_in_new_process(&verify_mmio_reads);
 	run_in_new_process(&verify_mmio_writes);
 	run_in_new_process(&verify_td_cpuid_tdcall);
+	run_in_new_process(&verify_host_reading_private_mem);
 
 	return 0;
 }
-- 
2.41.0.487.g6d72f3e995-goog

