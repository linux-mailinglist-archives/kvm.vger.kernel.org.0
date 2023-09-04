Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E260791759
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjIDMoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352862AbjIDMoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:30 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAF0CDA
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2bd3f629c76so23138821fa.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831461; x=1694436261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfDnH2zi19spDXT1YZEdk2e2zvrpSHkYzKDFanumPPE=;
        b=Z+49L87zQD41dah6ZjYJ5UUuYpU/3zWRYKDQySzNAu3hks/TZPHT6Lkj10HgcTZHjM
         DIm+wxwU4zAHljhBxkkecu9+JbIkzUOqVvh/5KgUDv4QKZZ7BsJ1A23vIZNheqY+/OTF
         nOOBJjVyumKHx12OWRlzh5lTRwiEAxpnYfqyMKn69jmC6fCrWVMuagwgNzGpP26nldJ1
         lsjukjEwiXCwE7jzKK8dziZj+TI79oa2yduI+tHhAwbqaczWhShPca8Bb/DCgxitpWo8
         HLx+DyLkBqPwuOLk5S6ZSyejBprkCL0aD8GnpIfekvLUpL+STtRCncSXiy9cDHknLeir
         leOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831461; x=1694436261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EfDnH2zi19spDXT1YZEdk2e2zvrpSHkYzKDFanumPPE=;
        b=KrjqOGtS+LsW3B3DPcFOGGlg3Ujpdug99Lsd8XSjwnQKU2u1xgDXnihPrqy2V0IfPv
         Gwt9jRCDIPeYpemYTH+ZU/1zJRn4golo7GfWDgZb1CjvYzG18S8O0DGJWZcNgHs/EP/Y
         FlnXs9BxUi4FLB2Lt3QUmcV92yL9Uo5ZwZRHpfvEnascNrRispfV3hjkVMnFKCc6ILM4
         QFvrpV0+4A5d7kntx47g7r+uONRnAwhapJxZWDjlkmYqwyre1Z8oApf8OGy39hYs5wP+
         bJIoc7RavTRmXbflImGRRVqYyudlYMYO/rVepFqeYSipYCy/llUUYZtZOl3ToR7AzU42
         pPiA==
X-Gm-Message-State: AOJu0YyFW0tdshOBBCl+dNdW/iEktSQPX6mtT8QT6TuYMFxy7VrRjQ+j
        C1acg0QPEF3ecI/ozV6tvHwFJw==
X-Google-Smtp-Source: AGHT+IE976/wb9043fTOX1jLNvYiAsS+SMGWMVP8cKCaRkt7WlpkXdAiG5q4d7+oUS7QvOusWuayLw==
X-Received: by 2002:a2e:a176:0:b0:2bc:c466:60e9 with SMTP id u22-20020a2ea176000000b002bcc46660e9mr6704259ljl.49.1693831461543;
        Mon, 04 Sep 2023 05:44:21 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id gu18-20020a170906f29200b0098f99048053sm6215400ejb.148.2023.09.04.05.44.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:21 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 09/13] target/i386: Restrict declarations specific to CONFIG_KVM
Date:   Mon,  4 Sep 2023 14:43:20 +0200
Message-ID: <20230904124325.79040-10-philmd@linaro.org>
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

Keep the function accessed by target/i386/ and hw/i386/
exposed, restrict the ones accessed by target/i386/kvm/.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm_i386.h | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 470627b750..ff309bad25 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -31,30 +31,35 @@
 #endif  /* CONFIG_KVM */
 
 bool kvm_has_smm(void);
-bool kvm_has_adjust_clock(void);
-bool kvm_has_adjust_clock_stable(void);
-bool kvm_has_exception_payload(void);
-void kvm_synchronize_all_tsc(void);
+bool kvm_enable_x2apic(void);
+bool kvm_hv_vpindex_settable(void);
+
+bool kvm_enable_sgx_provisioning(KVMState *s);
+bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
+
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
 
+void kvm_set_max_apic_id(uint32_t max_apic_id);
+void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
+
+#ifdef CONFIG_KVM
+
+bool kvm_has_adjust_clock(void);
+bool kvm_has_adjust_clock_stable(void);
+bool kvm_has_exception_payload(void);
+void kvm_synchronize_all_tsc(void);
+
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
-bool kvm_enable_x2apic(void);
 bool kvm_has_x2apic_api(void);
 bool kvm_has_waitpkg(void);
 
-bool kvm_hv_vpindex_settable(void);
-bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
-
 uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
 void kvm_update_msi_routes_all(void *private, bool global,
                                uint32_t index, uint32_t mask);
 
-bool kvm_enable_sgx_provisioning(KVMState *s);
-void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
-
 typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
 typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
 typedef struct kvm_msr_handlers {
@@ -66,6 +71,6 @@ typedef struct kvm_msr_handlers {
 bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                     QEMUWRMSRHandler *wrmsr);
 
-void kvm_set_max_apic_id(uint32_t max_apic_id);
+#endif /* CONFIG_KVM */
 
 #endif
-- 
2.41.0

