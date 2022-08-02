Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD575884AD
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiHBXHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiHBXH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:07:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E0C4BD39
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 16:07:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 17-20020a631751000000b0041c70216fecso967049pgx.22
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=NxWgyhLS/wEKEZsDnO9RgTHv9lubStrj0Vb693z0PP8=;
        b=E8gvKaUW/8c0xeISmmUx5b/6KR94RL17k2R745A/8QaEgsEoEyo6BULy+MHp1+Q1Hw
         4feqOBmsj4yXeudFu7JS143gFbmxKlBZlF8LZU4mm2G2lLvfEM4MJRzxggTpPbtAEesn
         26iizzQTo0Dv4aSY8aRg9/+cBeBvi3eEp2LajGe1eRp7fcOfwAHXjfWGZz1nk5K97iqA
         NooA5KSHe2Mz7GmTbLiDQ/05jYtf8mkpOcmTM/eNpcq9Q+J2V+KmUu9duJKfnS3OopZa
         yKxVjeYw57tjJGppY2vuFzW619KIVJRg+7bEWmq/9FMwMG/M24FiqUW4wOb3vLzh+1kn
         VR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=NxWgyhLS/wEKEZsDnO9RgTHv9lubStrj0Vb693z0PP8=;
        b=bKSBO4q/6MRfZON/1qDnc83HEL7y3iBEFe5JP0OTn1oPQQ1/qn96/9sBRsjTbOQEd8
         CTATigONvcQaqC4U9MACyQ/AOaNaynNNNk7dcSduAkv/wkv3ulTJ1HKJSawvM9CRALmI
         GVOy2E02SEppdpKamwDQ6pmILN2UilFkPuJPKg/BCyw6C7yZaVV0Yo/gih0DhXLciaiK
         EJu4+28O8kBLnU2GukN8j0nzqNisxIYXZPiZZ4FFQxJUyqdFuw37uDnAYX81fxQGfidX
         OW3656ospSy8bWAnG5yO09kemBXmQIasmI3dBzzObqcYcGfEe5Fy2eJb4MysOnULrmcA
         EMcg==
X-Gm-Message-State: AJIora96R6yViTGsL1cc5QE2/mLvLpeeEz1iyEmvdDcBSUSAeoOR9Q1v
        J3aLNQnswWYKjQCAw6vsoLbL1FY6UUMy
X-Google-Smtp-Source: AGRyM1syAf/a93tY4akFWCwnvKvWhSMYbJNZ5eFwOPqowcs0YDGMOnDQWpV7Ap88gyeED2TvtVHYITeBtchu
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:1a04:b0:52a:d4dc:5653 with SMTP
 id g4-20020a056a001a0400b0052ad4dc5653mr23019501pfv.69.1659481648254; Tue, 02
 Aug 2022 16:07:28 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  2 Aug 2022 23:07:17 +0000
In-Reply-To: <20220802230718.1891356-1-mizhang@google.com>
Message-Id: <20220802230718.1891356-5-mizhang@google.com>
Mime-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 4/5] selftests: KVM: Add support for posted interrupt handling
 in L2
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for posted interrupt handling in L2. This is done by adding
needed data structures in vmx_pages and APIs to allow an L2 receive posted
interrupts

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 7d8c980317f7..3449ae8ab282 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -579,6 +579,14 @@ struct vmx_pages {
 	void *apic_access_hva;
 	uint64_t apic_access_gpa;
 	void *apic_access;
+
+	void *virtual_apic_hva;
+	uint64_t virtual_apic_gpa;
+	void *virtual_apic;
+
+	void *posted_intr_desc_hva;
+	uint64_t posted_intr_desc_gpa;
+	void *posted_intr_desc;
 };
 
 union vmx_basic {
@@ -622,5 +630,7 @@ void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
+void prepare_virtual_apic(struct vmx_pages *vmx, struct kvm_vm *vm);
+void prepare_posted_intr_desc(struct vmx_pages *vmx, struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 80a568c439b8..7d65bee37b9f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -556,3 +556,19 @@ void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
+
+void prepare_virtual_apic(struct vmx_pages *vmx, struct kvm_vm *vm)
+{
+	vmx->virtual_apic = (void *)vm_vaddr_alloc_page(vm);
+	vmx->virtual_apic_hva = addr_gva2hva(vm, (uintptr_t)vmx->virtual_apic);
+	vmx->virtual_apic_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->virtual_apic);
+}
+
+void prepare_posted_intr_desc(struct vmx_pages *vmx, struct kvm_vm *vm)
+{
+	vmx->posted_intr_desc = (void *)vm_vaddr_alloc_page(vm);
+	vmx->posted_intr_desc_hva =
+		addr_gva2hva(vm, (uintptr_t)vmx->posted_intr_desc);
+	vmx->posted_intr_desc_gpa =
+		addr_gva2gpa(vm, (uintptr_t)vmx->posted_intr_desc);
+}
-- 
2.37.1.455.g008518b4e5-goog

