Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1FB4EE999
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbiDAIN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344281AbiDAIM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49391204C92;
        Fri,  1 Apr 2022 01:11:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c2so1827945pga.10;
        Fri, 01 Apr 2022 01:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LuKtWHDzvGHRbTbHDfM3kJ4nrniR7w02cItd/4r8DqU=;
        b=YdX39apgvnvZ8QQVQdWr5LlQxY8QpbVH31PhVXTAMoy91XsIiSLDTvhI7PCXp10QRP
         F39A+XLdemPxw9t/hrX1kk62N4zBPjQkxNM1qA0kVNpK/fL4Lud/12YNHeL5vt1IdeZO
         n+GfYKa5uAQrmqq9ZI0C6Xlc7kMY/DbBj/j+ts/HBhQMt6VS7lyhaPrwPgcgUDbny/YD
         VZbIcMuzV9HULOEwrh0ZbNlmtcW3HMDd/taNaonlgvEbCJG1Re/Fs5SOPynqFPwYt2K1
         ko270Zis3TJSJEEqQk1PbC3q23n0GATDTYVdX9wmM66K/3eRY6PG6DB0BykYq9VOZ4r9
         XsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LuKtWHDzvGHRbTbHDfM3kJ4nrniR7w02cItd/4r8DqU=;
        b=KRSTuYEqwwdy/4UFM4Lr/n1N5K/1guiKqI9BzC1+W05TrAlGWdvpkv/bAcZH5sLq/s
         LBIvaHNZXXU14UEJKShC/Ofxvt2HXv4g5dsx4Q3kW7uEjjK5thUFdHKyaeSsIzyWp+IU
         PGsw+Q+JPn+dCSRiCkOa3iINR7iNBNFXnNGfLiegyLpNY25llWGoYl2Eb9/+IWHLkytI
         DhkdiugQlBmELccyEQp4qrwex2RA4q0XQ9zVHn0YI5zXUOOVFM0E1an8/E9RowKvdOoK
         AT9sU1OoWj4MiAFG81diNefQGnzEoCGgBw+2sadiCyVTc4OAJ936TnxolYSf7s5Cw6rg
         Abww==
X-Gm-Message-State: AOAM531cUiXIzmEVrFAmmbSKogN60lkE/7nfevt2hVDqtFM5vP/e2fae
        hFgg5ADD7qxxkrNkTCPMsH7Ah81ubvw=
X-Google-Smtp-Source: ABdhPJwvsw4GLwJVMFco4Y6dng/C9MrWFoCGIYj0lk98wlFSIAaeN8N8I+LQnuoKvVQb9K/faEfR1A==
X-Received: by 2002:a63:1c14:0:b0:36b:28ef:f8ce with SMTP id c20-20020a631c14000000b0036b28eff8cemr14111944pgc.96.1648800670613;
        Fri, 01 Apr 2022 01:11:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.11.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:11:10 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 4/5] x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
Date:   Fri,  1 Apr 2022 01:10:04 -0700
Message-Id: <1648800605-18074-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The x86 guest passes the per-cpu preempt_count value to the hypervisor,
so the hypervisor knows whether the guest is running in the critical 
section.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 79e0b8d63ffa..5b900334de6e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -366,6 +366,14 @@ static void kvm_guest_cpu_init(void)
 
 	if (has_steal_clock)
 		kvm_register_steal_time();
+
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT)) {
+		u64 pa = slow_virt_to_phys(this_cpu_ptr(&__preempt_count))
+			| KVM_MSR_ENABLED;
+		wrmsrl(MSR_KVM_PREEMPT_COUNT, pa);
+
+		pr_debug("setup pv preempt_count: cpu %d\n", smp_processor_id());
+	}
 }
 
 static void kvm_pv_disable_apf(void)
@@ -442,6 +450,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	if (!shutdown)
 		apf_task_wake_all();
 	kvmclock_disable();
+	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT))
+		wrmsrl(MSR_KVM_PREEMPT_COUNT, 0);
 }
 
 static int kvm_cpu_online(unsigned int cpu)
-- 
2.25.1

