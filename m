Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF68A5EFED9
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiI2UrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiI2UrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:47:17 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72EF153111
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902d2c900b001782ad97c7aso1723724plc.8
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=ehn7f9oYjeKdJef39Xo4xVYoRftFjfIcprmKivEos50=;
        b=sdQTGo3Zyf4/v7/Ep9gB6zG08PK3T1mf9q5pzLqxg/zUpHiB4rf0mz5Y3UtIXhwN33
         mnUXa49AUCRUz+7p3Cz+aFZsN8v2PpPcr9hW9CLsDQ3ZAOt6nHxzKUsKdv8k17Bw+V0H
         0aJVEtafzjCvf4U2eDZ59gMyqgGUUEYLOke5uQd5zLnylqewV6B+mcPnftG7qqSzj39i
         x9mugM99cWYswS+DynTJvTXduLFrG2M4hyeACo4JcISB81aJA3WU6rug1zsEsuCB92/g
         23o191TthVU0kQOPhe1AU1h2TmORYICCVA+W4ZY+ok9Ovw67i9zzbv6Uosdy/58G6cEQ
         yZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=ehn7f9oYjeKdJef39Xo4xVYoRftFjfIcprmKivEos50=;
        b=x62Dj44lwfoay2NoMU8OC11VdKHs/5IVWKkfXI7dKFITrI7brpyhdVk3uFDugMIzy0
         0O2YWSKTw4Hy/IQvL/kr3heIdxvn/h0dl+rkmzY4SYg8pYAPaRsiv3MTH6Z0KZBM2cNo
         GOMVEiEZF6DW/xD5Y9uFMV7Hi8TIhsPPpKSPIzTLMwzRbQpEsWV/iwbZoYzpFKQjiYTw
         UTnqcNOznSuvTPI/PMHpd62/8ucranHwiQVQSSNeJEZDV6skhdo8HgWy0JstJT3hFA92
         6JAxOp9m0iUX8PSThEqszeUyE4UlGlrGRKMV1TjHuP1L7MZFbJINZQjw71MbSEOraUso
         NzbQ==
X-Gm-Message-State: ACrzQf0qLuyNumMMyVPwX1WwwDROquWInENvpegfqH4H38WMn4lxnu4g
        eMecd4pcE1/6Z152oYT58LnGcAxReeSrhQ==
X-Google-Smtp-Source: AMsMyM74wjVxCiWgJuMZPHq5qb+JKY+VTdhbKP7fh6WXauTmHFwWfc+zUVGHkep25d1vtMSRdatwhH1aod3OxQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:903:2302:b0:178:286c:86a8 with SMTP
 id d2-20020a170903230200b00178286c86a8mr5058980plh.172.1664484436263; Thu, 29
 Sep 2022 13:47:16 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:05 -0700
In-Reply-To: <20220929204708.2548375-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929204708.2548375-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929204708.2548375-2-dmatlack@google.com>
Subject: [PATCH 1/4] KVM: selftests: Use MMIO to trigger emulation in emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Use MMIO to force KVM to emulate the flds isntruction in
emulator_error_test, rather than relying on KVM_CAP_SMALLER_MAXPHYADDR.

KVM_CAP_SMALLER_MAXPHYADDR is not enabled by default when TDP is
enabled. So developers that run all selftests against KVM in its default
configuration do not get test coverage of
KVM_CAP_EXIT_ON_EMULATION_FAILURE.

When TDP is disabled, KVM_CAP_SMALLER_MAXPHYADDR is enabled by default,
but emulator_error_test actually fails because KVM does not need to
emulate flds.  i.e. The test fails to induce and emulation failure.

Fixes: 39bbcc3a4e39 ("selftests: kvm: Allows userspace to handle emulation errors.")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../kvm/x86_64/emulator_error_test.c          | 36 ++++++-------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 236e11755ba6..2dff57991d31 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -11,18 +11,12 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define MAXPHYADDR 36
-
-#define MEM_REGION_GVA	0x0000123456789000
-#define MEM_REGION_GPA	0x0000000700000000
-#define MEM_REGION_SLOT	10
-#define MEM_REGION_SIZE PAGE_SIZE
+#define MMIO_REGION_GPA	0x700000000
+#define MMIO_REGION_GVA	0x700000000
 
 static void guest_code(void)
 {
-	__asm__ __volatile__("flds (%[addr])"
-			     :: [addr]"r"(MEM_REGION_GVA));
-
+	__asm__ __volatile__("flds (%[addr])" :: [addr]"r"(MMIO_REGION_GVA));
 	GUEST_DONE();
 }
 
@@ -152,34 +146,24 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t gpa, pte;
-	uint64_t *hva;
 	int rc;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
-
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
-
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
 	vm_enable_cap(vm, KVM_CAP_EXIT_ON_EMULATION_FAILURE, 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    MEM_REGION_GPA, MEM_REGION_SLOT,
-				    MEM_REGION_SIZE / PAGE_SIZE, 0);
-	gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
-				 MEM_REGION_GPA, MEM_REGION_SLOT);
-	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
-	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
-	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
-	memset(hva, 0, PAGE_SIZE);
-	pte = vm_get_page_table_entry(vm, vcpu, MEM_REGION_GVA);
-	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
+	/*
+	 * Create a virtual mapping so the guest can access MMIO_REGION_GPA.
+	 * MMIO_REGION_GPA is not mapped by a memslot so KVM will treat the
+	 * access as MMIO and attempt to emulate the flds instruction, which
+	 * will then generate an emulation error.
+	 */
+	virt_map(vm, MMIO_REGION_GVA, MMIO_REGION_GPA, 1);
 
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

