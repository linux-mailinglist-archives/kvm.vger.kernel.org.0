Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE4B79353A
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 08:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbjIFGZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 02:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjIFGZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 02:25:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A449B;
        Tue,  5 Sep 2023 23:25:03 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4018af1038cso31534385e9.0;
        Tue, 05 Sep 2023 23:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693981502; x=1694586302; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DSDz3ym8Sv1A+SBkcuToJiss6n9XN70R7Q8nsUTLerA=;
        b=dcJtPzkjqBnf/Zx40d5vY+I7TwlztXZAzSyiVTHKEUOpjZ4QxTHp5OrxeC0dBq3sRR
         nuY18PBWvB3qFNxc5lgv9OxKk3nc26l37pyjxUFy65K3OTfhxQ+Akki0vWVoHO3pY0Nj
         QD/2hkaLdib3SWneVXpp+4CKZezBZ4mnkZmsuwUwIpz9RatAn66CqmiwPxgqU+Qtoska
         0vcIvbKtJf1zxeSwLLSDwPs+9Lyb+L/J4XfRaUo6vjrtUT+4dsH0oefe7ILDTN3tZO0P
         Bs5q2F7zQavDm5wCAbTrjZG1UJAuzP7XnFvlmtM6NaIUAvOPMNB+Rz9PNd6xU9AX73LO
         RACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693981502; x=1694586302;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DSDz3ym8Sv1A+SBkcuToJiss6n9XN70R7Q8nsUTLerA=;
        b=Wn7j9tANaA8uKYTSDk7NhYyBt00SbY003PGhpla/zGBGw0Zq1T84twCJqhZ5IrhCYv
         8rAX1CBxY8wkqOY1pycdniJ4O+SCDNF7AvIl/LAJlwt8rcpU+w73zwcUMqw7xP8BeOU1
         0k/DPGNKWaUy+vAncjsKuDz5iUkKSDiq/zc53Fw/QwWHRC1ck7IO8z9J/a60jvDG1E14
         8RASW1b4ClnTEOUhvSco1lBKYfr0Me2XuFjhozBX0KgM1vkSHTccX+InH9Wo944RcCQe
         kV1s1RvAyNFYnbnbyt6mC7LBRd/SB/I8YAA1CY+wO6Ge+esVB6J1fHuYhZlMtx+EQ2pc
         Z/5g==
X-Gm-Message-State: AOJu0Ywp0rEo0ESkWQNvoDe/5WJW04x9W2Ya+BcT7IAL8yS7El3NTsKW
        P3Bh3rVBi1ZpsH9iDzuIzIkTLxHo+pCUpFbhXVCOKMGLEKQ=
X-Google-Smtp-Source: AGHT+IHTxHuiiPVHl4imd9Zri02xIEIsDW74V9lLYJBzR4D6e5rD4QFkx/eiTJPoW5kqtW+CvnHUc1n9l7/sWb7H//M=
X-Received: by 2002:a05:600c:c3:b0:3fb:e2af:49f6 with SMTP id
 u3-20020a05600c00c300b003fbe2af49f6mr1249933wmm.39.1693981502070; Tue, 05 Sep
 2023 23:25:02 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Wed, 6 Sep 2023 14:24:50 +0800
Message-ID: <CAPm50aLd5ZbAqd8O03fEm6UhHB_svfFLA19zBfgpDEQsQUhoGw@mail.gmail.com>
Subject: [PATCH] KVM: X86: Reduce calls to vcpu_load
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

The call of vcpu_load/put takes about 1-2us. Each
kvm_arch_vcpu_create will call vcpu_load/put
to initialize some fields of vmcs, which can be
delayed until the call of vcpu_ioctl to process
this part of the vmcs field, which can reduce calls
to vcpu_load.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9320019708f9..2f2dcd283788 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -984,6 +984,7 @@ struct kvm_vcpu_arch {
        /* Flush the L1 Data cache for L1TF mitigation on VMENTER */
        bool l1tf_flush_l1d;

+       bool initialized;
        /* Host CPU on which VM-entry was most recently attempted */
        int last_vmentry_cpu;

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fd08a5e0e98..a3671a54e850 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -317,7 +317,20 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 u64 __read_mostly host_xcr0;

 static struct kmem_cache *x86_emulator_cache;
+static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz);

+static inline bool kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
+{
+       return vcpu->arch.initialized;
+}
+
+static void kvm_vcpu_initial_reset(struct kvm_vcpu *vcpu)
+{
+       kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
+       kvm_vcpu_reset(vcpu, false);
+       kvm_init_mmu(vcpu);
+       vcpu->arch.initialized = true;
+}
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -5647,6 +5660,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,

        vcpu_load(vcpu);

+       if (!kvm_vcpu_initialized(vcpu))
+               kvm_vcpu_initial_reset(vcpu);
+
        u.buffer = NULL;
        switch (ioctl) {
        case KVM_GET_LAPIC: {
@@ -11930,11 +11946,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
        vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
        kvm_xen_init_vcpu(vcpu);
        kvm_vcpu_mtrr_init(vcpu);
-       vcpu_load(vcpu);
-       kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
-       kvm_vcpu_reset(vcpu, false);
-       kvm_init_mmu(vcpu);
-       vcpu_put(vcpu);
        return 0;

 free_guest_fpu:
--
2.31.1
