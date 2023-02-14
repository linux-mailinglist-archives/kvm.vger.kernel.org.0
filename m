Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE26696D30
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjBNSqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 13:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjBNSqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 13:46:22 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2391A23D9D
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:21 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m12-20020a1709026bcc00b001963da9cc71so9560481plt.11
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 10:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+go4BhcPBxPqXa9WF1he5E5XfcGSfVCPuFvF4GvTBzc=;
        b=BW9GqgUf1FJASuJhuuFGu81Hnjl89OJ5Z7TQ4bQrSTxdB+KNcb/d1qurRVo5ciXqjE
         r4kYbqOEURxhJ+clDgUgUxeGEkhBTXx3fsKv9BcxumA//FemtB2dqCsPqtYnhN8eP/Wf
         P7HZ35twoIBIWhh0+SYGlOfLizui8nxzRu4rzYVjP7oCp7bFpfiy1wjC9WcORisJ4AJB
         onnjoL0v0Pd9Bu3bQ38oHws6dlSWAEdeMjGDg9BJgJYZd17u7adV9xkJldb4yroo9oD3
         NRYj5OBKsvzQsfXDfB+jm4PaErXBR0OjcKx32xzrXZVNYkJSHb+m1C9sAlWfXLZJsagh
         x6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+go4BhcPBxPqXa9WF1he5E5XfcGSfVCPuFvF4GvTBzc=;
        b=dVtqR2ZPxOgHV8riTacdWHnFqPfbb9RaeQWLVVbDINxTFFEhzHgYV/i/gOD8tSiWjj
         eDUF9OTdM0/Yt6XitCrhCvCksfjRB1BiZ8cj4U4yI+BKkbsdX4AK4S5mtd5w1vma/dyx
         ym3Uyg/dTqOm+hJsj6h+UFofoGFI+UTk8Q6IbQMkUJYcKKQMSiOUPbp2795/5lufOMbN
         THe/YE7VVMOrsw+///YmzLLpg1GZ+SXcvnsRLJ1NC5pc/3GksCxlVnAWZYiBTJso5R7u
         22VfjtWXKD9fJXiuLWOEVi9hRZQe1zOIxbdhMMQk2hyMR77BXdWCP7XIEItEbJqU7iVy
         1rWQ==
X-Gm-Message-State: AO0yUKWHD6eACsIloZxzsKemKb5dnen1No8GzXoETq+fe48eZAex6cuS
        k4CHxiccg97ydBbF/F//k/umy7k0V1zu
X-Google-Smtp-Source: AK7set+yJFd50Jozx+ouelF1ogOjQJRtgJa/RcuiNxmep7BHS5FC/WtuO2elD1uMUOxK0PZIvO7lHSndpLB/
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:10:b0:5a8:dd21:cbe3 with SMTP id
 h16-20020a056a00001000b005a8dd21cbe3mr630563pfk.45.1676400380622; Tue, 14 Feb
 2023 10:46:20 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 14 Feb 2023 18:46:00 +0000
In-Reply-To: <20230214184606.510551-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230214184606.510551-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230214184606.510551-2-mizhang@google.com>
Subject: [PATCH v2 1/7] KVM: selftests: x86: Add a working xstate data structure
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>
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

Add a working xstate data structure for the usage of AMX and potential
future usage on other xstate components. AMX selftest requires checking
both the xstate_bv and xcomp_bv. Existing code relies on pointer
arithmetics to fetch xstate_bv and does not support xcomp_bv.

So, add a working xstate data structure into processor.h for x86.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 12 +++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 36 ++++++-------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2a5f47d51388..8110fdfd0d01 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -45,6 +45,18 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+struct xstate_header {
+	u64				xstate_bv;
+	u64				xcomp_bv;
+	u64				reserved[6];
+} __attribute__((packed));
+
+struct xstate {
+	u8				i387[512];
+	struct xstate_header		header;
+	u8				extended_state_area[0];
+} __attribute__ ((packed, aligned (64)));
+
 /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
 enum cpuid_output_regs {
 	KVM_CPUID_EAX,
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b67..d506821a5a26 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -41,10 +41,6 @@
 
 #define XSAVE_HDR_OFFSET		512
 
-struct xsave_data {
-	u8 area[XSAVE_SIZE];
-} __aligned(64);
-
 struct tile_config {
 	u8  palette_id;
 	u8  start_row;
@@ -103,13 +99,13 @@ static inline void __tilerelease(void)
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0" ::);
 }
 
-static inline void __xsavec(struct xsave_data *data, uint64_t rfbm)
+static inline void __xsavec(struct xstate *xstate, uint64_t rfbm)
 {
 	uint32_t rfbm_lo = rfbm;
 	uint32_t rfbm_hi = rfbm >> 32;
 
 	asm volatile("xsavec (%%rdi)"
-		     : : "D" (data), "a" (rfbm_lo), "d" (rfbm_hi)
+		     : : "D" (xstate), "a" (rfbm_lo), "d" (rfbm_hi)
 		     : "memory");
 }
 
@@ -158,16 +154,6 @@ static void set_tilecfg(struct tile_config *cfg)
 	}
 }
 
-static void set_xstatebv(void *data, uint64_t bv)
-{
-	*(uint64_t *)(data + XSAVE_HDR_OFFSET) = bv;
-}
-
-static u64 get_xstatebv(void *data)
-{
-	return *(u64 *)(data + XSAVE_HDR_OFFSET);
-}
-
 static void init_regs(void)
 {
 	uint64_t cr4, xcr0;
@@ -184,7 +170,7 @@ static void init_regs(void)
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
-						    struct xsave_data *xsave_data)
+						    struct xstate *xstate)
 {
 	init_regs();
 	check_cpuid_xsave();
@@ -205,9 +191,9 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	__tilerelease();
 	GUEST_SYNC(5);
 	/* bit 18 not in the XCOMP_BV after xsavec() */
-	set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
-	__xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0);
+	xstate->header.xstate_bv = XFEATURE_MASK_XTILEDATA;
+	__xsavec(xstate, XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILEDATA));
 
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
@@ -244,7 +230,7 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct kvm_x86_state *state;
 	int xsave_restore_size;
-	vm_vaddr_t amx_cfg, tiledata, xsavedata;
+	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
 	u32 amx_offset;
 	int stage, ret;
@@ -284,10 +270,10 @@ int main(int argc, char *argv[])
 	tiledata = vm_vaddr_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, tiledata), rand() | 1, 2 * getpagesize());
 
-	/* xsave data for guest_code */
-	xsavedata = vm_vaddr_alloc_pages(vm, 3);
-	memset(addr_gva2hva(vm, xsavedata), 0, 3 * getpagesize());
-	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xsavedata);
+	/* XSAVE state for guest_code */
+	xstate = vm_vaddr_alloc_pages(vm, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
+	memset(addr_gva2hva(vm, xstate), 0, DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
+	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
 	for (stage = 1; ; stage++) {
 		vcpu_run(vcpu);
-- 
2.39.1.581.gbfd45094c4-goog

