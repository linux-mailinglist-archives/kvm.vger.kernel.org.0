Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45236ADDB1
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjCGLlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjCGLkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:40:12 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2680F7B9BA;
        Tue,  7 Mar 2023 03:38:43 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id bo22so12881243pjb.4;
        Tue, 07 Mar 2023 03:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678189120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xBr07fqk3Uu+urBt4c4cihx7vLrlxAn9QH0wdjegu1Y=;
        b=GMo4EBNY0vAkJ/JhtmzVHgtrvMenDLrTsWOjWmavqeReEFASZqRzme1ecj1Lx9jwRq
         OISCZB6GCCll9UKXDAkzRoa7XFXmebggK+bCTS0dJIgrWh0wihiGtkjlER9tfkyAg/aP
         0Fii+h1QQsHzzIlhhQS63AvddxRU9L/Jt3GwzRdGYxrA82q46X1/bNGc4xMTjTLrvHFL
         ElLZk1BHgIBVpYkjEuEXgh8W5fszrvQwhFn4yqlfqr0xFh9HsGQ29oezPdhCUzsJnKvZ
         rRR1HBpjX0EE2ed4wS/kFtfIC3y1jyXI6b98WoZVEjrRI3U8RN2X1P6NzbPp9k3qikrX
         fm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678189120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xBr07fqk3Uu+urBt4c4cihx7vLrlxAn9QH0wdjegu1Y=;
        b=vw3uItXce6GI0zDpoN+qQgZFlt+CvFEJ192U8eyM4VUPND8TdqYW78XaHBDoB0NKN2
         Bq4OzwtOeKK7sQ/WzecAWp+WYj0a6ay14vgFO3BJKi7GZvgHIIrcXe6o8Bl788sEQRJb
         kCXfmkiAA0Zkk63RoD551BDdey9h5oooZ5ML4ymlUrmRG86snPvDOWy6aI90lwM8zCrO
         knOD5OVAGWVwO+WM9anUmqiyuZORI/aZbkabSOVvIRHP2J6sTdFeN30OybhgqcQxvCJo
         vpZgiPsW59amrRgEbrBugYHUkr9v/FBNBvzyU6YPKk68nDivuw/qTiumIZsniqrdjfZz
         UPQg==
X-Gm-Message-State: AO0yUKX89VN1OKttly942LVvWswgyZZji1nJRZMeKRGImQnSaoGtH9JF
        vZZbqbIEtUiBlS7qnFTKgv8=
X-Google-Smtp-Source: AK7set/9lXzBGsl5ZgNcAY4YHsv/xUC197l3u42zj/zoTAYetCEmb18q0gmsoz5ALwsd+5Y8+xN83w==
X-Received: by 2002:a17:902:d50f:b0:19c:d6fe:39c7 with SMTP id b15-20020a170902d50f00b0019cd6fe39c7mr17517044plg.41.1678189119830;
        Tue, 07 Mar 2023 03:38:39 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z15-20020a170902d54f00b0019a928a8982sm8255974plf.118.2023.03.07.03.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:38:38 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit doesn't exist
Date:   Tue,  7 Mar 2023 19:38:19 +0800
Message-Id: <20230307113819.34089-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Unlike Intel's msr atomic_switch mechanism, AMD supports guest pmu
basic counter feature by setting the GUESTONLY bit on the host, so the
presence or absence of this bit determines whether vPMU is emulatable
(e.g. in nested virtualization). Since on AMD, writing reserved bits of
EVENTSEL register does not bring #GP, KVM needs to update the global
enable_pmu value by checking the persistence of this GUESTONLY bit.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd21e8b1a259..f41d96e638ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4866,6 +4866,16 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static __init bool pmu_has_guestonly_mode(void)
+{
+	u64 value;
+
+	wrmsrl(MSR_F15H_PERF_CTL0, AMD64_EVENTSEL_GUESTONLY);
+	rdmsrl(MSR_F15H_PERF_CTL0, value);
+
+	return value == AMD64_EVENTSEL_GUESTONLY;
+}
+
 static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -4911,8 +4921,11 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
 	/* AMD PMU PERFCTR_CORE CPUID */
-	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE) &&
+	    pmu_has_guestonly_mode())
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+	else
+		enable_pmu = false;
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();

base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
-- 
2.39.2

