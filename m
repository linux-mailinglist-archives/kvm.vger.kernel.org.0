Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA717762579
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjGYWDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjGYWDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:03:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ECB30E0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c79a5564cso2574139a12.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 15:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690322534; x=1690927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uYb2UntJCk/zn4c108HA9yrg8j3dAHpcDzElziN7WIY=;
        b=xfBM6s26jIZR4tKHpN5cd5tGGN3dCvhjj6B+IBCaPz8I7dc7Wrl2gcTdnsmi5cwETW
         qW+huhKAXm6iJbBQI9IdKm+q01Ajlv5Uv6cOsi2+juIL8bTmUlYqmfLdkRhGwGcwdjh9
         Koz1CrduWFY6PCwFQUVcQfkcclozEzBClHSC4HHvIcjMzFYGYHzv6sLApCC6jc6JELJi
         47M9z0zeEpPwp+7L8Hw8pkPC55y+YtN43Qxv6CUYKhLKHIbHqKQozX1nFMQtrK/U9Suq
         +qvq3c61LKNxLONkIXcYdEcey0KelBhjgwng+T/nmwcGbtOrZwo7I1ZYu5wiU6gQkcv1
         9uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690322534; x=1690927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uYb2UntJCk/zn4c108HA9yrg8j3dAHpcDzElziN7WIY=;
        b=EkcIO+Hc6DTplWlwOqj0PYsebBTwJ1V0tUpSczdiayjBo3GALS5ZicUgeZnjabQFAE
         AbNIav0eCPjQb4tUC79KCZY82D7DxaLuYgd4WZ0tkYEaBorQdzuZ6OpbHnriwtLfJj/i
         ZOf7PzizVZTpSCvFMy414ZNEpX985i3fbX0+laOxBELSbxXUTf7rrUv3R6eyMeKJ+qIp
         TWgEMWMGMv0VFKPyIMPezOTw0PIJdZXlGavYe2OCz7guNAeewJJp63vJJKtQg0k/up8z
         0sM70xbTIuRQaGB0jJ4DNROuI0El63++Nufy3gfO4eyP7osmEf7UNPE2zHlvHrR51o5w
         TL8A==
X-Gm-Message-State: ABy/qLZzDmUUKsqzWge3Js2aFf9C5G21hsUMvHQy/FcyRVwW/L/CYkip
        QGSbm5gG3qmceNwSmOAPrwDGSdA9owAF
X-Google-Smtp-Source: APBJJlFrxhyN0gYmcU9m+L2b/2sDxek5BxJMk4MKZdCLwIXYEIL1JgCEJq+CGpMKSuItzkE4tA0pTqPKqjQY
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a63:8c54:0:b0:55b:5c9b:671e with SMTP id
 q20-20020a638c54000000b0055b5c9b671emr2339pgn.5.1690322534554; Tue, 25 Jul
 2023 15:02:14 -0700 (PDT)
Date:   Tue, 25 Jul 2023 22:01:07 +0000
In-Reply-To: <20230725220132.2310657-1-afranji@google.com>
Mime-Version: 1.0
References: <20230725220132.2310657-1-afranji@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230725220132.2310657-15-afranji@google.com>
Subject: [PATCH v4 14/28] KVM: selftests: TDX: Add TDX IO reads test
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

From: Sagi Shahar <sagis@google.com>

The test verifies IO reads of various sizes from the host to the guest.

Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: If5b43a7b084823707b5b4a546c16800d5c61daaf
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index ca0136930775..9ac0b793f8c5 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -429,6 +429,92 @@ void verify_guest_writes(void)
 	printf("\t ... PASSED\n");
 }
 
+#define TDX_IO_READS_TEST_PORT 0x52
+
+/*
+ * Verifies IO functionality by reading values of different sizes
+ * from the host.
+ */
+void guest_io_reads(void)
+{
+	uint64_t data;
+	uint64_t ret;
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 1,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xAB)
+		tdx_test_fatal(1);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 2,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xABCD)
+		tdx_test_fatal(2);
+
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 4,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+	if (data != 0xFFABCDEF)
+		tdx_test_fatal(4);
+
+	// Read an invalid number of bytes.
+	ret = tdg_vp_vmcall_instruction_io(TDX_IO_READS_TEST_PORT, 5,
+					TDG_VP_VMCALL_INSTRUCTION_IO_READ,
+					&data);
+	if (ret)
+		tdx_test_fatal(ret);
+
+	tdx_test_success();
+}
+
+void verify_guest_reads(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_io_reads);
+	td_finalize(vm);
+
+	printf("Verifying guest reads:\n");
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 1,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint8_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xAB;
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 2,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint16_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xABCD;
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_CHECK_GUEST_FAILURE(vcpu);
+	TDX_TEST_ASSERT_IO(vcpu, TDX_IO_READS_TEST_PORT, 4,
+			TDG_VP_VMCALL_INSTRUCTION_IO_READ);
+	*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset) = 0xFFABCDEF;
+
+	td_vcpu_run(vcpu);
+	ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_SYSTEM_EVENT);
+	ASSERT_EQ(vcpu->run->system_event.data[1], TDG_VP_VMCALL_INVALID_OPERAND);
+
+	td_vcpu_run(vcpu);
+	TDX_TEST_ASSERT_SUCCESS(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	setbuf(stdout, NULL);
@@ -444,6 +530,7 @@ int main(int argc, char **argv)
 	run_in_new_process(&verify_td_cpuid);
 	run_in_new_process(&verify_get_td_vmcall_info);
 	run_in_new_process(&verify_guest_writes);
+	run_in_new_process(&verify_guest_reads);
 
 	return 0;
 }
-- 
2.41.0.487.g6d72f3e995-goog

