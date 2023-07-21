Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BF775D593
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjGUUUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjGUUUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:20:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A794233
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5839bad0ba7so11011567b3.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970774; x=1690575574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wPlbfa+N8zgfbkJ5TFjNvfC430Np593GRATA+kV4uv8=;
        b=YMYRUHzUDCVMuYn52ynlOKvBnRXOyiLr1dfgtoseNBOu4bDGsTucDMvLpEpL1MqmUe
         4GSO5jlD2I9GxnBXQQRXoK5LwMCPEGlozlc4vlePKaqf3bhgsDxPjj+cBfWd7xupVa2/
         i0NHbQtd24teDqosxIhfXN30cvUCTA5BSKtrqljErAnCSidWLnVSreSjcp9t3cgs8/8f
         j1Q2DQWnzLCp1MpXEbmnFdAh1ipvd0bngkKlEdgjYWvm70IfbIeCjdTuzIFN9rQlcRMX
         LZJ/W3WzKqojxqlMu8WlcWnJ0ILoNtfwLgJUzJKLYFQ7bJ52u6OwVjmUKa7/uN93JeuR
         y32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970774; x=1690575574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wPlbfa+N8zgfbkJ5TFjNvfC430Np593GRATA+kV4uv8=;
        b=kYBmleYzichnj+mZoA0xzP0sovf4NE1f2qXqLqWMPgtOF4d+QVF/kzKrVs/sPKqRRT
         DG+gs+0IWMS90TqLNtbSz3TkpZQPc6q1x82CXkEFmP63RpZ3dilnTcMjPjXVy/wNabUz
         4ctsnHWWfyiNMwNIdrLsEtBhfbY4xWTZyMXW3jmrjdOhOhFP99CvlKs4R4K8jDJud/OW
         XHJFDALzWvV6RxDWEwvj+8OjJfSuSfj1WE4Oo+eUY7eyP5ETgyEXu2ODx5bliXEcdmu2
         yobDDxQKbCI6HZrvl03GRM1X1xrI98XH7Oyfkkcv6xYqLzo2g+P4llYyzKuUP/P6U34U
         rc7g==
X-Gm-Message-State: ABy/qLb3jaVjqQ6oxKmV5r7Qa4STYKJ9OmN72hY1tnB1FpkkiKEM49KN
        OYEw1aLOn0xMZ/CU1TRoY70lZlhQmTE=
X-Google-Smtp-Source: APBJJlFEHHeJp5RT7zszaIw4ZA9cDrjfXBLHHV5QoHMtGzvyQ4EWMvYocU2KpSc+oerwCYSdXu+UWVkF0+Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad55:0:b0:583:6f04:4267 with SMTP id
 l21-20020a81ad55000000b005836f044267mr10407ywk.8.1689970774670; Fri, 21 Jul
 2023 13:19:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:55 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-16-seanjc@google.com>
Subject: [PATCH v4 15/19] KVM: VMX: Ensure CPU is stable when probing basic
 VMX support
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
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable migration when probing VMX support during module load to ensure
the CPU is stable, mostly to match similar SVM logic, where allowing
migration effective requires deliberately writing buggy code.  As a bonus,
KVM won't report the wrong CPU to userspace if VMX is unsupported, but in
practice that is a very, very minor bonus as the only way that reporting
the wrong CPU would actually matter is if hardware is broken or if the
system is misconfigured, i.e. if KVM gets migrated from a CPU that _does_
support VMX to a CPU that does _not_ support VMX.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f4fcd82fa6e..0e1f3856a9be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2737,9 +2737,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-static bool kvm_is_vmx_supported(void)
+static bool __kvm_is_vmx_supported(void)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 
 	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
 		pr_err("VMX not supported by CPU %d\n", cpu);
@@ -2755,13 +2755,24 @@ static bool kvm_is_vmx_supported(void)
 	return true;
 }
 
+static bool kvm_is_vmx_supported(void)
+{
+	bool supported;
+
+	migrate_disable();
+	supported = __kvm_is_vmx_supported();
+	migrate_enable();
+
+	return supported;
+}
+
 static int vmx_check_processor_compat(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
-	if (!kvm_is_vmx_supported())
+	if (!__kvm_is_vmx_supported())
 		return -EIO;
 
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
-- 
2.41.0.487.g6d72f3e995-goog

