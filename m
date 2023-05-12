Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D057012C1
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbjELXw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240645AbjELXvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:51:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EFBDDBC
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9dcfade347so19182801276.2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935457; x=1686527457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sWKYMGr2xJR5IkyvgfWnlRd3TuGoEqGQxpAcHPUuLoI=;
        b=pUFGPT8lQ/LC3slZ956Xv7B1EbQcOcDYHNbvmRed8G+Le657DuRdLRZOVt0MdmVd4I
         Ydyl2I7r3wRIsI9SBdGP/i7lA6jlxdWsd2nnSlVhhRwfFMEi3aWHHPZbLriGmNXAdatO
         y1QH+u5Rsz5HtwQa0+g9efSul3Ejkhs6kB2v3+tIgB5h4Gphu9atedH6s20V6Rleo9ij
         0onVurt26IiMBUNlAwa4atSJ6MHZW1YOXTek0iRKvIc8TJxqPOwG+PQEA2lg6sq+RlKC
         NviqAuSbp1Feg1HWSoekLlYHG3wDxReFRYbYdrNAra3LWjMnEr7dpHt73A7XCp7CdtTs
         OS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935457; x=1686527457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWKYMGr2xJR5IkyvgfWnlRd3TuGoEqGQxpAcHPUuLoI=;
        b=F4FGj28YxPFJ38UkFnl7lH7zvqgkohfemXjDSxvlO2v1Examd7mRvUTwOXtr1xH0/Y
         NBM1WMvW5LZj3SLA8AePvRI53vcCV1lX7n1vKnyZie2U1VnK7V8mVStGD6TFx5Mi/k65
         XvkP6pfIXxlDL+7hfEYNvdrRvlMtshMJf3pkHuqyfbOxYMKOq2gLApZRBn47qJK83YYR
         useBkrzB2M1KbdjRSOV6+QDVdWkJQLl7JLKkYhhaPtrAwUn8yVwU0HlxM90AVg7htJs0
         p23S9ZMYGEAbHkG2B0wzln9RI94zi9WRo/IHWlpIxNjVG/tfET0qMPeBWvSYswVE3cM2
         dYvw==
X-Gm-Message-State: AC+VfDzmKpzZMCgoh5IMkLqnt7nYaq4S6zLhOx6gFjqMnhVUk9LaAj1h
        Nj/lvmaunOd1GOHvPKU6IBbqlaOUzjg=
X-Google-Smtp-Source: ACHHUZ5P5eG1O2xh6I7DcS6GbbsgmunLQLCRTjOmBv0eEmZAGkZ0ZzGU2KFmbbzlScMpsBjgZnG+lvB442A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db0e:0:b0:ba7:1878:5279 with SMTP id
 g14-20020a25db0e000000b00ba718785279mr1398905ybf.4.1683935457377; Fri, 12 May
 2023 16:50:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:23 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-16-seanjc@google.com>
Subject: [PATCH v3 15/18] KVM: VMX: Ensure CPU is stable when probing basic
 VMX support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e00dba166a9e..008914396180 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2740,9 +2740,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-static bool kvm_is_vmx_supported(void)
+static bool __kvm_is_vmx_supported(void)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 
 	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
 		pr_err("VMX not supported by CPU %d\n", cpu);
@@ -2758,13 +2758,24 @@ static bool kvm_is_vmx_supported(void)
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
2.40.1.606.ga4b1b128d6-goog

