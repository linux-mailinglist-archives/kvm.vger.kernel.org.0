Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9187E550137
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383070AbiFRAQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 20:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383440AbiFRAQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 20:16:28 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5575820BFA
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:16:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q12-20020a056a0002ac00b0051bb2e66c91so2589923pfs.4
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+kEOXupEgF3LEKaQ7ETtoR1RHv4ePLtA8ZhkwBe1RYk=;
        b=Dn05cv6fq5texyrcU+sgiFL6XElkOLr41OAqA7yu/YCnT3xe/CdMaKCDUb1d0e5uXg
         lMPAVJ0reAvcdyRvnIfWoeDL9sd1vhVHkOGHHlgWb1QdAt9GlJOd94PvMY4miywZXe7Y
         idwx5fC1h/wFYKMk0dPdRDEO+xMQ9WvDcMHgED/GS8UD68D98jVJWN4BUMbgzmlEVAhS
         2dIQkU0V/dN0ooZLh037pFfG6H3PI9Z2Wa32o3Jt2pzVHBd8EFgHlKGw6jEM6KaXI4Q+
         /6bGTvgNdYj3gmtIbUzGeExDloxJPM10xvcTCVAWHovIzmFD1dWbvQBhIlwBQPpmdPUz
         vNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+kEOXupEgF3LEKaQ7ETtoR1RHv4ePLtA8ZhkwBe1RYk=;
        b=WBUw+hNPw7is9z3F74AWiBb2nMvogVHxMrCqNDL7lTB6f83uClXYrj11wdf2Iios06
         MwgV5PjaYQxL6pijPd13BwnEghOjz0C6ngOHi56QXNowIkVYb3oFg+SoUb6STI0ZY/ZC
         TmTDXqSremgQu2EbPcL6bykG+C/KhxOmuV8aMbgxTMWBlVcHV0l4ffkXXCU3IfmzCYdP
         6yObkswFuE5nx7DPRr40xXFF25wtLHUsNdrAUgp7uz3KhLynfpdfD4p0LMleP/nv6ASC
         X5TDWxNm0ezHyb6mut6wkkpWGjhaKoL0zV+ymzldaxrz7kN5T66uX7WRkDRrYZA+fscR
         EJRA==
X-Gm-Message-State: AJIora8h5dOmbTmZVWBZOouj+9cuAzbUCddUKnFteo16eL/23phly7qb
        5/vWa1692Yr7FOkWNWh2v777ChbgTUM=
X-Google-Smtp-Source: AGRyM1tH2/eIDP/hPfMRCm8Pd53yxKYarOYPiOjvNi7PZ3OcG2KrqTiKgCQWjn0rLrRXuxKbVTARh+hJDQU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1584:b0:51c:7932:975a with SMTP id
 u4-20020a056a00158400b0051c7932975amr12598033pfk.80.1655511386752; Fri, 17
 Jun 2022 17:16:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 18 Jun 2022 00:16:18 +0000
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
Message-Id: <20220618001618.1840806-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220618001618.1840806-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 3/3] KVM: selftest: Add __weak stubs for ucall_arch_(un)init()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>,
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

Provide __weak stubs for (un)initializing ucall, aarch64 is the only
architecture that actually needs to do work.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/riscv/ucall.c  |  8 --------
 tools/testing/selftests/kvm/lib/s390x/ucall.c  |  8 --------
 tools/testing/selftests/kvm/lib/ucall_common.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/ucall.c |  8 --------
 4 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 37e091d4366e..1c6c0432bdd7 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,14 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 0f695a031d35..3e8d4275c9e4 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,14 +6,6 @@
  */
 #include "kvm_util.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index c488ed23d0dd..a1e563fd8fcc 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,6 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kvm_util.h"
 
+void __weak ucall_arch_init(struct kvm_vm *vm, void *arg)
+{
+
+}
+
+void __weak ucall_arch_uninit(struct kvm_vm *vm)
+{
+
+}
+
 void ucall(uint64_t cmd, int nargs, ...)
 {
 	struct ucall uc = {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index ec53a406f689..2f724f0bed32 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,14 +8,6 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	asm volatile("in %[port], %%al"
-- 
2.37.0.rc0.104.g0611611a94-goog

