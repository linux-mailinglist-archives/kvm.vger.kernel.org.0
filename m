Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED4E63E4FD
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiK3XOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiK3XNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:13:35 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34299F30
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b17-20020a25b851000000b006e32b877068so17950607ybm.16
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=syK6eF0z1YIhw5KnDfEJ/sqHR3QdYzGhfq3h/5i5Sas=;
        b=GVS6tfQs69HM9iPg5RyanavfgqTtstL/hP2NZwyz6ZiOn7sQ0OggFONinN3Xpq5A5O
         ROAGkLrScqRoWmoumJCapQkQLkR93EZiZmJgM/igbQR0yiEQhTM5NlbokX/zSqXnB7+r
         NTk4xoTIRJmdEYgV5XTVp3WbKa8QFND0VjYsfazhzfL9lIlQKqNHJYrNBIvwG1lwEaBo
         U+Ok61fL2GtL8yDcgFKd5TgqnT7w/4A4Fxq0CZ9SiNKAiH0owEiGaxOBRpIJfpm0capw
         Q57SZ4+/8uPzzEqCtGgs63hTCqUtPFogvCulI6jofLJAraG2Zyu8sPd3r85eKSZc1cYA
         LlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syK6eF0z1YIhw5KnDfEJ/sqHR3QdYzGhfq3h/5i5Sas=;
        b=roGyHhZiv/CNPnNfTYDpXLGE3HOQRhxzFsOV6AkT9alIPIQDSUVYdQYYk1RxvKIMFg
         ahGQJ55Gv8rLGOJnhaVEzSvPLjXbK1A54PmsLoAGmIvKVQU6cAmT/Z2m52BvejGonVui
         VwHCBo8mklxU6l1ltaZvI/NxcaA2QhsptFn/FAx2o7WcMmIWHp6DIxlUIg337YCsnyTV
         PewHlalT6Ynm4X3xUcTEpAbemLin2YqM62CfDYsoYArymg7Oeqrs6mz3web5tPJoPdP1
         z4MQy/YpKAg9Abc6plag8K8Tf6W9W2w3bdWM0Q5vLSO9cBozL/RC5frSud1FmmELQiY8
         JX8g==
X-Gm-Message-State: ANoB5plTGfN10G1OmXvZ+cACxYp/9QVyjwVYK4GlJYhiOTSapPyL5qJx
        I7+0AKy/PdcFUVhl1Ap00rJdunKsCtU=
X-Google-Smtp-Source: AA0mqf6GlYmz6ao1Ocazy6XnieuesyYU9e/N0B6T5bGw3DwYIfX3lPKm+B7r5ybTp9p3YaVUKLjnuY7j4Vk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:e8b:b0:3c9:bdbf:444d with SMTP id
 cq11-20020a05690c0e8b00b003c9bdbf444dmr15670072ywb.56.1669849829390; Wed, 30
 Nov 2022 15:10:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:14 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-31-seanjc@google.com>
Subject: [PATCH v2 30/50] KVM: VMX: Make VMCS configuration/capabilities
 structs read-only after init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
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

Tag vmcs_config and vmx_capability structs as __init, the canonical
configuration is generated during hardware_setup() and must never be
modified after that point.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..45162c1bcd8f 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -66,13 +66,13 @@ struct vmcs_config {
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
-extern struct vmcs_config vmcs_config;
+extern struct vmcs_config vmcs_config __ro_after_init;
 
 struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 };
-extern struct vmx_capability vmx_capability;
+extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 76185a7a7ded..654d81f781da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -488,8 +488,8 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-struct vmcs_config vmcs_config;
-struct vmx_capability vmx_capability;
+struct vmcs_config vmcs_config __ro_after_init;
+struct vmx_capability vmx_capability __ro_after_init;
 
 #define VMX_SEGMENT_FIELD(seg)					\
 	[VCPU_SREG_##seg] = {                                   \
-- 
2.38.1.584.g0f3c55d4c2-goog

