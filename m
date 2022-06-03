Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDA253C20F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiFCAsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240247AbiFCApr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD13344E0
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m11-20020a25710b000000b0065d4a4abca1so5569688ybc.18
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lzpp9s6848SvIawHpEXorX8YbgbwUXWo+CPLyev/LvM=;
        b=bdGgNoYrChHkmeLK1keeGbHD0XfNc7Am5Bd9CMpF42ocesPemIcKmzLe5zoGAUOq4F
         C/H0Hrq5pQwZS2Rj9nGJ8K74+XaWzhsOhCZv4/+vl1SVVAQN0Hf8ezVsz2dCQlRqdgoB
         vNJ5Bw7EjHOnGDzc86rHm4alxXtiKyLY0xDDyte6k28wBXtS1uD6zOMWSg1xnt2wUIPU
         M+xyeM7s3BaZ74Jyi2PsWuicK+fxXUxEsEEHttsgB2A1KPwfRVuhZ94RzjJxfRXgZAAK
         RFHutbLWRtj7rNxsTsy55iBdfCzKIhDmQJ49kQHsODPuZ3OlKJXMWfdFhe3BAba6D/KC
         ojwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lzpp9s6848SvIawHpEXorX8YbgbwUXWo+CPLyev/LvM=;
        b=mQCZEqPWWdFd8HCugybz864QlLszwjiB+5lH8vcQqMnA2EN6EoHNvHaRPg5/qMjPBG
         kvCmZaNmRN09MjGMiuly1KFCMHNlJHe5HMFF/H3tGRoH9vfAcRKPGA5kG1p8liU+sU8Z
         SJy/Ww7U+kp8a7v2/u4i4swJCrvYTSZLxwsQ6Hczsyv2FCObXAHWfe/Kar5NXgc+Eq42
         LdfXS8GXCwXaSPrZ4rXip/vOxkBx+DiIJ4WPDE0iRQsAlQfGrTKTBr8mJ9T8plvdtgVm
         cqkKL3LwdlIxbZGlzxLSsLSdu8yBx3xI1Ai2yd3yqTNl3idlNu0UfvK31ikIggQgyHhm
         yC/g==
X-Gm-Message-State: AOAM532FPI+O0RxEEYQpLUUCBqyaPPeUpNbMJ//uw5cEf5zWNrGja9a8
        IUUaY3JU+yyy6hZdKwOpTxp+NVuJpLw=
X-Google-Smtp-Source: ABdhPJxrfNyoM243yYTiCHsSbFMFwqBH0z87l4vbpnEOKB8fayiW7Dl8XpiCOFoCnGeYGsbEzlKyecaqC1o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:ac50:0:b0:30c:3746:e439 with SMTP id
 z16-20020a81ac50000000b0030c3746e439mr9012964ywj.259.1654217144378; Thu, 02
 Jun 2022 17:45:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:17 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-71-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 070/144] KVM: selftests: Convert vmx_close_while_nested_test
 away from VCPU_ID
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

Convert vmx_close_while_nested_test to use vm_create_with_one_vcpu() and
pass around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==5.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Opportunistically make the "vm" variable local, it is unused outside of
main().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/vmx_close_while_nested_test.c    | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index edac8839e717..da0363076fba 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -18,15 +18,10 @@
 
 #include "kselftest.h"
 
-#define VCPU_ID		5
-
 enum {
 	PORT_L0_EXIT = 0x2000,
 };
 
-/* The virtual machine object. */
-static struct kvm_vm *vm;
-
 static void l2_guest_code(void)
 {
 	/* Exit to L0 */
@@ -53,20 +48,22 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
 
 	nested_vmx_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
 	/* Allocate VMX pages and shared descriptors (vmx_pages). */
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 			    run->exit_reason,
@@ -75,7 +72,7 @@ int main(int argc, char *argv[])
 		if (run->io.port == PORT_L0_EXIT)
 			break;
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-- 
2.36.1.255.ge46751e96f-goog

