Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A646575D57F
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjGUUTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGUUTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055A3E0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bd69bb4507eso2275795276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970754; x=1690575554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RNIzxG+DyKxhv7/WUhcg42RyR1LzF+A7NEJm4Wy1bYU=;
        b=VLZQUdsQavq82AMjpjS9rdHI6jO9sP6xssXKUkaB7U/GQwL8nid7eG6wVk1JwgqkoT
         FFTkgw45ADeMUlu5ALDnr115Ixck3boFbgPyZpQreyFzl6yJ+S/V+dJuYxQ5XWvOE/eI
         4kkQnZ9H9c5aWJmAayTqrjC0yCMJ1b22MPWz1FBwlIMfjWdFE90FsWNd70jKxCl95sG3
         QXIGYOX/P4AermBbmroCFajzBcZIR2L3b4+vbW3tHy384n+r5uiD9o4Vvd532w5CUlex
         ObV2LDr84QRbQEztcWeYQ+Dwl6PU4ML/7junWpBh6RsYoPWUnLQw+9OhPN5uWwkg48ZQ
         mHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970754; x=1690575554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNIzxG+DyKxhv7/WUhcg42RyR1LzF+A7NEJm4Wy1bYU=;
        b=QrSK/7E3lDRNanUrcktvu9afn+s+Gn1PJQ2yDmuWoUz5I26dqnIn9PP0bQAq5APzvz
         skL03ISmnfdPoJ3lof3TpTJUn6KqdB8Ri/+W2vAdkhEXeqpeU+mz2hSUdSeJ9hjYI+24
         kWekrQouCFIbFLQVG9+P1N9ReobLeLCnQ6AM8jcOC3L7igc3IS4X2ijsJOfnOn++wbkD
         sTFOS3dVe/F/vRBvHuUixXeQAwZJmXnsbEor6B3X7QCYQUZMYvf/P2cllSqABR/SR87h
         zI9m45C4PqNKA0GidneqBuMO9L4CCrLeaiwG6TlO1AsmnkR7+PIapyrGi6mReehid1W0
         dTJQ==
X-Gm-Message-State: ABy/qLZiaHZxxAGktVStVYvcgugeSBUPND0lmzHekTeGN4qDpwI1zR6c
        ArAkhKzWCuGLz+pyTW3z4oq1z+Q4Nzw=
X-Google-Smtp-Source: APBJJlF/B9hp1aDOjZGhKyt3iXYT71YIQNpTjE8kJ9mxksplOcD8TO2n3UiT2Q1QOPU47P+izOZbgiJ3zSE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b310:0:b0:cfd:d50f:df5b with SMTP id
 l16-20020a25b310000000b00cfdd50fdf5bmr17452ybj.13.1689970754335; Fri, 21 Jul
 2023 13:19:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:45 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-6-seanjc@google.com>
Subject: [PATCH v4 05/19] x86/reboot: Assert that IRQs are disabled when
 turning off virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that IRQs are disabled when turning off virtualization in an
emergency.  KVM enables hardware via on_each_cpu(), i.e. could re-enable
hardware if a pending IPI were delivered after disabling virtualization.

Remove a misleading comment from emergency_reboot_disable_virtualization()
about "just" needing to guarantee the CPU is stable (see above).

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 48ad2d1ff83d..4cad7183b89e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -532,7 +532,6 @@ static inline void nmi_shootdown_cpus_on_restart(void);
 
 static void emergency_reboot_disable_virtualization(void)
 {
-	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
 	/*
@@ -821,6 +820,13 @@ void cpu_emergency_disable_virtualization(void)
 {
 	cpu_emergency_virt_cb *callback;
 
+	/*
+	 * IRQs must be disabled as KVM enables virtualization in hardware via
+	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
+	 * virtualization stays disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
 	rcu_read_lock();
 	callback = rcu_dereference(cpu_emergency_virt_callback);
 	if (callback)
-- 
2.41.0.487.g6d72f3e995-goog

