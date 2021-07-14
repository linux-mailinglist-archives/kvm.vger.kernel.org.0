Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FEA3C93E1
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhGNWdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbhGNWdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3088DC061762
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id j17-20020a63cf110000b0290226eb0c27acso2710486pgg.23
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vSk4PrTqRRwcqhupjszeaAACsXVyJ0E1vQTmnoEDT1w=;
        b=ewrhIlPFa7nrn5V7dkW6IIEzVDGj+CzxYfs/Je0/eP+pa6iH5ggLirvMmIThx/X3Jl
         pdiWX+3Kwonpd382EatujQFMrqRGzmYYFFZo+u94+cF9mnjNvQ6Ghzxu7uioCAoSObXI
         4UKjuoAOXXCak+m9paGlIlvK1NAgK5h5KBSQQ3tggjVzUaMeBcRExWlUGRG7A9ZyzXC/
         Pw2SzuCNp2FZSVGln71+EpT5sr5QAoFcXOEvkBDN/q+AAM77+UG1ec8iBtfKiPClnoie
         plcJ9JI1/4K00efaBOy1BwrSqVO8u0SpfoIZZOvg6TFUtxZi05el3G9T24jV8jp+HzxX
         Di6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vSk4PrTqRRwcqhupjszeaAACsXVyJ0E1vQTmnoEDT1w=;
        b=kh5HpYpKAX81vOizu7NQBRQcyQZI1coQ3lXpuH3Ei+EWpdIT9z14fZAKzp/YZfFjVZ
         5YUI+lwcfMNlajG5yxWjvExnJ/f0uLsBUdnoDXluSZgg6W39DhJ2xVC4uq1Fv4+Y4xzJ
         Pq0K1EnZmdmbcnsGyXKDRLUgIcw1R6b3OlomvhuQhqWIrijEHLWy7YcqIQpXqQjWk7NA
         ue+0hXfjgQw6Bhk00S2sxrGqCl8IDb2b8Yxek2Tw5rA+QqwqUKWe4M4r9iVXbB068uD3
         R3rmTzvmab4uHpaSMLrmcdGOEU9OACYCR/Aqd+lIE6cxpfl/ZVDxTd0Kb6PoxKM5d1MF
         XIIw==
X-Gm-Message-State: AOAM5317Swx5Y8XR8RGLwAA6h6LPu5F+lNEMqlCPyWfAaNZ94J/5SrQk
        OJN5tvgzup43h9TU+SUjUPSwnIxkxYOhGLBL/KaxeCwyOi6/wH82CTz4jjUiI+oK8tUDdS+vCVg
        pyP9Y2edqL1umUR5va41y90TRKm4YLu7F/buwxr8Y3uNsaIyK8Fkq7TCP/q/4yJddRg134OA=
X-Google-Smtp-Source: ABdhPJxEhuKOS6Ebn1mxgOK9o0hXweHka2Z2LedyMocOIVXPmOcbzOpVgdLsXnbKFXfaKJZA1AV30jvgl0Aowrm3qQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:1951:: with SMTP id
 17mr5993821pjh.49.1626301844600; Wed, 14 Jul 2021 15:30:44 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:32 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-6-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 5/6] KVM: stats: Add halt_wait_ns stats for all architectures
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
index cd544a46183e..92698a5e54fd 100644
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
index c44cf5029e30..2414f3c7e6f7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1369,7 +1369,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_poll_invalid),		       \
 	STATS_DESC_COUNTER(VCPU_GENERIC, halt_wakeup),			       \
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_success_ns),	       \
-	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns),		       \
+	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_wait_ns)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 723f8a77a8ea..d70f8f475da1 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -102,6 +102,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_wakeup;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
+	u64 halt_wait_ns;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6980dabe9df5..88bf17e7bf51 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3126,6 +3126,10 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
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
2.32.0.402.g57bb445576-goog

