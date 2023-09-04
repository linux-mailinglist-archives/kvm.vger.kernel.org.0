Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63279175D
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352961AbjIDMok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352918AbjIDMog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:36 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8070E54
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:28 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2bcc4347d2dso20034221fa.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831467; x=1694436267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9c1++OFXiKHirX3uQNfDd/RXZK+lEL70eHdHIGvdol4=;
        b=DFUZ1+IwqePNniguFUpFfmPzV9Ew4KRunYOSRST7uGhjBYq4MrmYU+PNEIf9MX65cy
         0N/0QfWJ33HcXav7Fwk0X1xcm3MFjEKxGAAKfBEoub1xcdYsfLXhSljoisl+icDQtOOo
         3M3NJ0fCLcjgFgbRzyEaXC/Tp6rdolCR/T+9FosWkMNuhlKb6q97CCRxOXgnEsHtbmQi
         OClVmXBibYdP2uNw3+vKY31XTkCquLVl1yz/0aE2R5ibyXbOqn3+cg2WcH18hBQdG0wb
         uLJLUESMuJWtGohaeaDVXvsHuO1pPD9sMkZbu6tAOpOOYpiSjc6YBfctlyILccLMW8ra
         V53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831467; x=1694436267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9c1++OFXiKHirX3uQNfDd/RXZK+lEL70eHdHIGvdol4=;
        b=X+mgfuOEYJC52K6DIq5/VVtXqmPAsGwvBnLKbi8IjdZxA0J5nWzDJf8e4eiCLDLHz8
         Rv5iVpHrc+cOsusUXEgVy2sERb7Gi+2VESodaxDc0HIQZ4reB21xF/shmbzbrw6SorWf
         MV/5s1Ik/C15bN1srsBPmc+mLX8WCc/rgfFdvfx8Z9NAiXwTQlfEJa5/nQyYLPQF91Qv
         x3Ah8CV5VrZRkCnKnRZVYSR43r2YlFxQjx6SXszOGGAcSjBgzJminiscSoRUdeOMdsH+
         myt2y9GXK9DbjzQYnpO03yXPbDFlMDJH4gDfkkPaSYeK9iGDvsU3Jp11aDjaESTnchJp
         pfhQ==
X-Gm-Message-State: AOJu0YygcTCdXQT/75/qo1og4bRQCgJlB+3e3tyKlK4cHUQJ19K246Ym
        +kLSc5u8PD+hg49nvNTJIxMRoA==
X-Google-Smtp-Source: AGHT+IEWA9agBIka4/UEdzmAwtfRA+imBetPWuYVWeGSiJIg5JmAaXx74MtNWsYTkyhrhZ9vNtQo1Q==
X-Received: by 2002:a2e:908a:0:b0:2bc:fce1:54d3 with SMTP id l10-20020a2e908a000000b002bcfce154d3mr7414408ljg.41.1693831467132;
        Mon, 04 Sep 2023 05:44:27 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id f15-20020a1709067f8f00b009934855d8f1sm6127181ejr.34.2023.09.04.05.44.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:26 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 10/13] sysemu/kvm: Restrict kvm_arch_get_supported_cpuid/msr() to x86 targets
Date:   Mon,  4 Sep 2023 14:43:21 +0200
Message-ID: <20230904124325.79040-11-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_get_supported_cpuid() / kvm_arch_get_supported_msr_feature()
are only defined for x86 targets (in target/i386/kvm/kvm.c). Their
declarations are pointless on other targets.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h       | 5 -----
 target/i386/kvm/kvm_i386.h | 3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index ebdca41052..a578961a5e 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -464,11 +464,6 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension);
         kvm_vcpu_ioctl(cpu, KVM_ENABLE_CAP, &cap);                   \
     })
 
-uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
-                                      uint32_t index, int reg);
-uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
-
-
 void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
 
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index ff309bad25..b78e2feb49 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -40,6 +40,9 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
+uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
+                                      uint32_t index, int reg);
+uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 
 void kvm_set_max_apic_id(uint32_t max_apic_id);
 void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
-- 
2.41.0

