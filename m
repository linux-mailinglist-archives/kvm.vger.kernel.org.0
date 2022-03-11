Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8968A4D5D5A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiCKIbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbiCKIbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394361B45FD;
        Fri, 11 Mar 2022 00:30:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so7548677pjb.3;
        Fri, 11 Mar 2022 00:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg55DIKCupebm5f4NqZ1g4YC1+NWU4JZUPE3B9his68=;
        b=FSBiFrp2EFh5RmqWuzLMcjAmroQnEnE9yw7vJXNjwVHqRPIWfux2pKZbvcwhluUVV+
         FoPvvMujHYJ5BfIDZ2ABkv/RlqE3Rj4oY5HtjReuw0zGKe/P+KNzExmXwhuhVTrWdGM9
         egDKBCdtHFCpSta8gVPdn3LLtE985CVPqd/TtRuwmw+yg2LBBpVlHLj3G5TzRabUe8Kb
         c1fdRBCTyujvvI3X/kkQ7WC0vmkCoTH4P9qL/Yn8rbHIh4VFUg8z6Dg5KCoebRjFL5Ga
         eiRcdOBDhRsuYANJ6SH2XDKTPikqpSrAjPsuEj/JhweLWgidvO57UHVIgIHog0BqbDIR
         zUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg55DIKCupebm5f4NqZ1g4YC1+NWU4JZUPE3B9his68=;
        b=QyIjUYxDlic6d4WY1k17JJNkSJLtzHZMlMjvcHOT+L3FXUEllKqXYLNFLlsrt1E6DM
         V0CoOFubYQXDKE3/zaImPqLx+fTMlpeWpQqCISd0L807/OZQFF9wqrc6ioigluZmJbMd
         kLNFmLWP1nbi1dPOmS02ruMtZBm26+RrFPuG9AAf6YEJIgSoQPeUs7/WWT0vQnbRSRuZ
         2SQ4jP4M7EbzC5epsclDaw72ZR25WHUPw7YmmJ4uRDGZO73cSscSD4/L1xGshwbtC2f/
         FTjPHp6GVkb6lZ/ORMFXmE1uaMYFKJah7BrSlakCrp7BqXieHfsfQb8xtwaxrt/u/eVc
         c98g==
X-Gm-Message-State: AOAM533jpF1XVSAT2yhBPobtvkhqgb7KME/OEQsoOxujR3A9eaYY0TxE
        TFjhL6Dtlg/8GAC80nLYHt55IfNA2cg=
X-Google-Smtp-Source: ABdhPJyGH6VBWlCi6KneX/AvpkwmrBm1Oe7zOEAaHBwhOGeVdFskQ29FwrAzKSI73+1WUByBy2T9cg==
X-Received: by 2002:a17:90a:1941:b0:1bf:3918:d49e with SMTP id 1-20020a17090a194100b001bf3918d49emr9411051pjh.136.1646987409672;
        Fri, 11 Mar 2022 00:30:09 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:09 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/5] KVM: X86: Add guest interrupt disable state support
Date:   Fri, 11 Mar 2022 00:29:11 -0800
Message-Id: <1646987354-28644-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
References: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
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

Let's get the information whether or not guests disable interruptions.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50f011a7445a..8e05cbfa9827 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -861,6 +861,7 @@ struct kvm_vcpu_arch {
 		bool preempt_count_enabled;
 		struct gfn_to_hva_cache preempt_count_cache;
 	} pv_pc;
+	bool irq_disabled;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af75e273cb32..425fd7f38fa9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,6 +4576,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	static_call(kvm_x86_vcpu_load)(vcpu, cpu);
 
+	vcpu->arch.irq_disabled = false;
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
 
@@ -4668,6 +4669,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
+	vcpu->arch.irq_disabled = !static_call(kvm_x86_get_if_flag)(vcpu);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -11225,6 +11227,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 	vcpu->arch.pv_pc.preempt_count_enabled = false;
+	vcpu->arch.irq_disabled = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
-- 
2.25.1

