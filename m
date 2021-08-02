Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC93DDE1C
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHBQ4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhHBQ4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:56:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E65C0613D5
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:56:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ep15-20020a17090ae64fb02901772983d308so529570pjb.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h4cfV6ot2MovnCwKNCAgDol+P3P4aIq1+V3yFM6Emug=;
        b=MHijz2vjEIT+b5dMAbYUlhI+Yo59eUba3OHgkHYUtqqIYcBoXAf9wYXouTLaWHaM5A
         tgal9IHPM/S0DowVRhc4llTtD1bUFJjDJbus2wk55FX62QwhalvZRV8Rf7dVvrOgpxox
         S/tiaVkfhn7Zu4jSHxiyFzFScka82jJF93AozMlojcdhOD/FcvCSNyNVrVqfufoAcABV
         4QPmH9sgV7BVf54NN59iOl/syqCuIbB1CI1hCI+8JRgWH1YSt4hXoBbNuGIZ3z3qp+00
         Kbil2XUomwIJg+y1q7ZmUcCwsYMVGWdMrEuDuIpj9Wshb9K/aYX8xl8oFs/5YVvkrxPj
         SzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h4cfV6ot2MovnCwKNCAgDol+P3P4aIq1+V3yFM6Emug=;
        b=jw00IxeJZpI7n7a92W/59emz2gsBAV5xzYmedPbF8AoUG9SPgUPEs10AypCmwuKZtt
         JJRa3cJ9+gmYmvO54V238mOsvO5B6vLLGKu5A72oaAwNuFl50s3uo64srFB2clUeaI4e
         prBijT2pInPDoEpR1aJWGAGYgei0RKhFDNy3T0aMsL0Wy9P3cupnS2mbHsZodr6JVfZM
         L7bL1nCTFXhrpS4g3u+11nyCMOrcuhx2d6P8ok0fe149OJUw7sasizDlLsmlfkPpXAnc
         BN6EQiB2lBDo0c5+0dKu0P301QRAvwMqGroLmFTP/onqOrlF0XI+Kafe4P0+jQ1jSOKt
         Jcwg==
X-Gm-Message-State: AOAM530SxmTFnv1S37GSbcUpFaGOdB8t3ZNvi4fmXIfoHyDGY0qXhuje
        T5aLtXKjDUBw2tck4rSaRErNuzDnZqmc5FVMypaiDirk0t2sTC/pIT5wyq4wQTAGd+ocIo2CXtt
        yosC3uljsGt3QrI+uIRR+2xkJclVfpt9XvGgiBT5u39cJ8wMGLkBfeMcr+cOAHaTC4dPw7zI=
X-Google-Smtp-Source: ABdhPJyA++8U+KQubK3vRZJNQJ9mBGAhAIvoD5oA7KxRWHlmnRCMxU3brMrBjC/hBql8m/UR+wYbTSfbNEZ9MjwL7w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:1627:b029:333:323:2c04 with
 SMTP id e7-20020a056a001627b029033303232c04mr17655804pfc.78.1627923402652;
 Mon, 02 Aug 2021 09:56:42 -0700 (PDT)
Date:   Mon,  2 Aug 2021 16:56:32 +0000
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Message-Id: <20210802165633.1866976-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210802165633.1866976-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 4/5] KVM: stats: Add halt_wait_ns stats for all architectures
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add simple stats halt_wait_ns to record the time a VCPU has spent on
waiting for all architectures (not just powerpc).

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/powerpc/kvm/book3s.c           | 1 -
 arch/powerpc/kvm/book3s_hv.c        | 2 +-
 arch/powerpc/kvm/booke.c            | 1 -
 include/linux/kvm_host.h            | 3 ++-
 include/linux/kvm_types.h           | 1 +
 virt/kvm/kvm_main.c                 | 4 ++++
 7 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..4931d03e5799 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -103,7 +103,6 @@ struct kvm_vcpu_stat {
 	u64 emulated_inst_exits;
 	u64 dec_exits;
 	u64 ext_intr_exits;
-	u64 halt_wait_ns;
 	u64 halt_successful_wait;
 	u64 dbell_exits;
 	u64 gdbell_exits;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 5cc6e90095b0..b785f6772391 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -69,7 +69,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
 	STATS_DESC_COUNTER(VCPU, dec_exits),
 	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
-	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
 	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
 	STATS_DESC_COUNTER(VCPU, dbell_exits),
 	STATS_DESC_COUNTER(VCPU, gdbell_exits),
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1d1fcc290fca..813ca155561b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4144,7 +4144,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 
 	/* Attribute wait time */
 	if (do_sleep) {
-		vc->runner->stat.halt_wait_ns +=
+		vc->runner->stat.generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(start_wait);
 		/* Attribute failed poll time */
 		if (vc->halt_poll_ns)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 5ed6c235e059..977801c83aff 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -67,7 +67,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, emulated_inst_exits),
 	STATS_DESC_COUNTER(VCPU, dec_exits),
 	STATS_DESC_COUNTER(VCPU, ext_intr_exits),
-	STATS_DESC_TIME_NSEC(VCPU, halt_wait_ns),
 	STATS_DESC_COUNTER(VCPU, halt_successful_wait),
 	STATS_DESC_COUNTER(VCPU, dbell_exits),
 	STATS_DESC_COUNTER(VCPU, gdbell_exits),
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b90c9cb8ddbb..9b773fef7bba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1402,7 +1402,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ed6a985c5680..291ef55125b2 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -87,6 +87,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_wakeup;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
+	u64 halt_wait_ns;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a96cbe24c688..af9bcb50fdd4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3185,6 +3185,10 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 	finish_rcuwait(&vcpu->wait);
 	cur = ktime_get();
+	if (waited) {
+		vcpu->stat.generic.halt_wait_ns +=
+			ktime_to_ns(cur) - ktime_to_ns(poll_end);
+	}
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
-- 
2.32.0.554.ge1b32706d8-goog

