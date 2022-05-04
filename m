Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3662C51B338
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbiEDW6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379354AbiEDW52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:57:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A155369
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:50 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n4-20020a170902f60400b00158d1f2d442so1365088plg.18
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BtuOPa2+k7Wo3nV0FJhhIgH2qpNxvRgndKjG9WXxzYQ=;
        b=VMGEiHS3xBPCXWfXcPrjsMNoeAlmKvj0asLdht4GlUHodnv9MsN8xgauJ5WCROHHgU
         1Oax3gri3vcpmNDYKyswNkolPIfL3xWmhqU7pCUZ4CPaxgbfRYe5mDN0J+ey/7P7qBqb
         Ftggu/yYDb1/vZIzyL0M2j3KqI+jfekwCokfQozDhTDKrPG0dj3SxL8LctmVSpesoWaW
         BtHLgwwiPagCvSav0PdelWZDduiwOrYdrxZn3+d692HewW9deimy0vRJ3FYwLL5xLiAn
         0gzLNWlQQtK9JxI5Xe3A7JZ4gCpRAwVdpId8U6V0w/Op8bDE91xSbSeAMS8bWBDaA6dF
         8AZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BtuOPa2+k7Wo3nV0FJhhIgH2qpNxvRgndKjG9WXxzYQ=;
        b=Mzrn6ZTKzOLwyOiEYxxebyQB5SVR4776agwcevHOijKPOlqfNb1iPsHFlqr5S7eudq
         YWXYA0q4ibhQaIw1Q7xk/1/8eyxT6wFzi8B496yfqm3W2qOmKQHQcnL1NPFfjUWTAvOu
         aZlHTdZUIAhlZq5F34bxaJBVnmkhh5zV+T91OztfqB+LG7GnrE+mgZ0yvl81KBCK9mkI
         K9IwVp93ql5WeLf60/cIXixSgZLlTfOQoXweXXYPX09Ualgk19gGChkzf2UrShbT1tHw
         GfBFdCkDS2j9QwuxGWqDoS4nsRQpB3M3ZzzHiyJsGMNlCzYA6EIwI58fzZZnDK92rCHY
         Pf8g==
X-Gm-Message-State: AOAM531Ru40UKBuqmFRXfYqGLAKdmP4FosBiA3xNU1HDbmyRrPLhifm6
        sym1DPwrLKQ8mziIb1xNEJb4PzFEAcM=
X-Google-Smtp-Source: ABdhPJx0ucgXAkqwO4kd29UJnogFXX6Noi6zVd9SuhPOMjt3ehAuQHJxlogE7Nlpu40ayYJ9pAPQeStnJlM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:170b:0:b0:50a:6901:b633 with SMTP id
 11-20020a62170b000000b0050a6901b633mr23213764pfx.34.1651704707413; Wed, 04
 May 2022 15:51:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:25 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-80-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 079/128] KVM: selftests: Convert vmx_invalid_nested_guest_state
 away from VCPU_ID
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

Convert vmx_invalid_nested_guest_state to use vm_create_with_one_vcpu() and
pass around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../x86_64/vmx_invalid_nested_guest_state.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
index 489fbed4ca6f..ba534be498f9 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
@@ -9,7 +9,6 @@
 
 #include "kselftest.h"
 
-#define VCPU_ID	0
 #define ARBITRARY_IO_PORT 0x2000
 
 static struct kvm_vm *vm;
@@ -55,20 +54,21 @@ int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva;
 	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct ucall uc;
 
 	nested_vmx_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
 	/* Allocate VMX pages and shared descriptors (vmx_pages). */
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 
 	/*
 	 * The first exit to L0 userspace should be an I/O access from L2.
@@ -88,13 +88,13 @@ int main(int argc, char *argv[])
 	 * emulating invalid guest state for L2.
 	 */
 	memset(&sregs, 0, sizeof(sregs));
-	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	vcpu_sregs_get(vm, vcpu->id, &sregs);
 	sregs.tr.unusable = 1;
-	vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	vcpu_sregs_set(vm, vcpu->id, &sregs);
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vm, vcpu->id, &uc)) {
 	case UCALL_DONE:
 		break;
 	case UCALL_ABORT:
-- 
2.36.0.464.gb9c8b46e94-goog

