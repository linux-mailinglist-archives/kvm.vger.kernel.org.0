Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B383253C32D
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiFCAyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240461AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1969937A9E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:13 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a65624d000000b003fa74c57243so3042109pgv.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HmflTn0VQze0qjz7C+f73GctVnhrRk2ICC14i+42toA=;
        b=WpOIATv6ZgMsXPILGbEqyjwgojnOEWiNdxMeVMXyLvz7ZCT60TjV7GGZ6wOpM0Fj+z
         do8t1d+xYQSUYl7xpPl4LE1Es0UGOYxBaGdCSzCyUQqTzPbLDh77FeakUf77cP6DbLiy
         8s7T11NZZjLbrmusiJhGDy0X91k2H6XudUx4yq/kKF97fsazv7D5SrbHlqVPIboKe1kZ
         TcsX2R/XIQbaKBp6qBPdXTCyZR9hlV/GV5Ap06/xDIImeSxtuk+ugaTrL685ZoC9fEU8
         RENDaGRYfuUWq9zzcZJpVwxrqC1UwnegnhOgPUFrexe22ULpQozT4apstyTZA2dugDtK
         9UyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HmflTn0VQze0qjz7C+f73GctVnhrRk2ICC14i+42toA=;
        b=K3hG086dObmjUAt/NjTBe0v1wPTDol98ojlBqynhpj3X4ZTKCNQf7kXcEgDcizj5e9
         UOLUomOQsaJ6jULteTiaN8aPN5CePpxLvppn79lBTO6iSjA+OHVGcl6W6LjOQKp+ITkE
         EsGVzCB/FGyl0+jQ7PemCq+yWgdNibAQM7Whyrbd3DYih66LoPOvK08MNkKwLtENiGpm
         rmkG2hz/DlbCRGgll97S9PmeYxJRe66zqtLgc6IX4+qoDK0xU+t4v7Guv+qbKTf9ajwV
         UVRSeBR0pwwHU+ge25Cn9deL3EbOEolIcLO4kLS/ypOlowy9sX3e2ft/8EzoWV7WKm9A
         8OZA==
X-Gm-Message-State: AOAM533JZSA7STo3QmiRoZqKX1/DXYPq5BLUV5dAUCZEckIaHZLmkDha
        iRTzjnJiLPIdoaT97sBS6WCbUivhDv8=
X-Google-Smtp-Source: ABdhPJyhlHExZ/NG+G+gYiQrVxDrefRUoP/yWN+pv+AR//5iG5zARzRUBH/cOLzshbWV+i7ACnIM14Jwuzg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a11:b0:512:6f59:f5cf with SMTP id
 g17-20020a056a001a1100b005126f59f5cfmr7758804pfv.45.1654217172776; Thu, 02
 Jun 2022 17:46:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:33 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-87-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 086/144] KVM: selftests: Convert userspace_io_test away
 from VCPU_ID
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

Convert userspace_io_test to use vm_create_with_one_vcpu() and pass around
a 'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note,
this is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing non-zero
vCPU IDs is desirable for generic tests, that can be done in the future by
tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/userspace_io_test.c   | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index e4bef2e05686..0ba774ed6476 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -10,8 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define VCPU_ID			1
-
 static void guest_ins_port80(uint8_t *buffer, unsigned int count)
 {
 	unsigned long end;
@@ -52,31 +50,29 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int rc;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
 
 	memset(&regs, 0, sizeof(regs));
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		if (get_ucall(vm, VCPU_ID, &uc))
+		if (get_ucall(vm, vcpu->id, &uc))
 			break;
 
 		TEST_ASSERT(run->io.port == 0x80,
@@ -89,13 +85,13 @@ int main(int argc, char *argv[])
 		 * scope from a testing perspective as it's not ABI in any way,
 		 * i.e. it really is abusing internal KVM knowledge.
 		 */
-		vcpu_regs_get(vm, VCPU_ID, &regs);
+		vcpu_regs_get(vm, vcpu->id, &regs);
 		if (regs.rcx == 2)
 			regs.rcx = 1;
 		if (regs.rcx == 3)
 			regs.rcx = 8192;
 		memset((void *)run + run->io.data_offset, 0xaa, 4096);
-		vcpu_regs_set(vm, VCPU_ID, &regs);
+		vcpu_regs_set(vm, vcpu->id, &regs);
 	}
 
 	switch (uc.cmd) {
-- 
2.36.1.255.ge46751e96f-goog

