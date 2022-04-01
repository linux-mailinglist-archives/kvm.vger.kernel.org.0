Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40734EE99D
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbiDAINW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344255AbiDAIM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0764D205944;
        Fri,  1 Apr 2022 01:11:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p17so1830279plo.9;
        Fri, 01 Apr 2022 01:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eDstlFrAvrXwvAexPbURvjB3hXUck9RQZ0b7BQhloGk=;
        b=WYcAwxhNIDI0KvdIFnJY7SXXVUsPbAbq+KiIlgtwMepTkOMe77If6zEJ72oV4RqZKI
         gXLZUpNtz+YA7XwDR2YsYNv+GvkLaHnK2Nkr2bKFwZj/lZEJuFjcNJXQG6vBC4T4N6kr
         7MT7s0LC48is8W1tI+tEnjsnbuYVqhq+ZRi21+v1UbPVJB59eaE2Eb8v9MASw0uWYQMU
         7/OlbAjgFBjf7i5hU5J5Aka82HCe0eRRmRCUBcP599RhZ5gqsP/sTuRIXSbJe7vKaN83
         kNfRyxSBBkvV0NEU+ndWPa6mQwZ8itgiOh88yc8pKWpYpww93yhF1jUJ3uR51hL8Cg2r
         ZhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eDstlFrAvrXwvAexPbURvjB3hXUck9RQZ0b7BQhloGk=;
        b=whkoG813GeR+2Wu3UhYQ3gVKvPweVrhkNJIU3As03DamWefAt/pBQmq+9KGBGuSw6L
         j/6GN/1TcxhV+lOSozdTscpbQ9TuAojBFPrSj+4RNmH3bQuf/HfzNIEOx2fHiTH9XtM4
         oE1+4lyQK1F9HhW12wxBq4MWqSZRexOVQwJRYiZZs6PfjscpSuSU8jtex4NdJWKP7z8U
         y63aUVrf54vjBJJ5KFn3fxBfm/+nouMFEzMhtqYW0ne7+adMlOV1NftGVvbdpzsuLrV5
         mWIVZYWP+FsEk3TX7OyPt9eupW7sR0+y4JxvNwUOT+ztBmRi006s6XvsJjHTPu+hXRVT
         UHNw==
X-Gm-Message-State: AOAM5338rkys9yYCOSiNFdVMpBLo4jiQMXngXzmXBDYSswyh9E2Zk/6r
        i6aVq9PdlybIBo6ANg906AdFTA8ouPU=
X-Google-Smtp-Source: ABdhPJy1Jz6RuIeQG6ZFPKVCzSu8yA2b/7j2eo1H/SJ7yWCC7Vw1V5ueouR+wjqzHLAQPrK+pt1loQ==
X-Received: by 2002:a17:902:db03:b0:155:cb6a:7c8e with SMTP id m3-20020a170902db0300b00155cb6a7c8emr9314404plx.125.1648800665400;
        Fri, 01 Apr 2022 01:11:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.11.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:11:05 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/5] KVM: X86: Add last guest interrupt disable state support
Date:   Fri,  1 Apr 2022 01:10:02 -0700
Message-Id: <1648800605-18074-3-git-send-email-wanpengli@tencent.com>
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

Let's get the information whether or not guests disable interruptions.
Except preempt_count, interrupt disable can be treated as another in
critical section scenario.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/x86.c              | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c13c9ed50903..7a3eb2ba1d0f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -857,6 +857,8 @@ struct kvm_vcpu_arch {
 		bool preempt_count_enabled;
 		struct gfn_to_hva_cache preempt_count_cache;
 	} pv_pc;
+	/* guest irq disabled state, valid iff the vCPU is not loaded */
+	bool last_guest_irq_disabled;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f2d2e3d25230..9aa05f79b743 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4584,6 +4584,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	static_call(kvm_x86_vcpu_load)(vcpu, cpu);
 
+	vcpu->arch.last_guest_irq_disabled = false;
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
 
@@ -4676,6 +4677,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
+	vcpu->arch.last_guest_irq_disabled = !static_call(kvm_x86_get_if_flag)(vcpu);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -11227,6 +11229,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 	vcpu->arch.pv_pc.preempt_count_enabled = false;
+	vcpu->arch.last_guest_irq_disabled = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
-- 
2.25.1

