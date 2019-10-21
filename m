Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B69DF8AF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfJUXdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:44 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52953 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfJUXdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:44 -0400
Received: by mail-pf1-f202.google.com with SMTP id u12so12144345pfn.19
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8YsxV0BcIxjrxOZuquH3V7doAs34PC7dcplFOM2TGSY=;
        b=CiwSguc/LjFUTK1kzzuqhVY8BIe5hYYx4yNqO0R4sJ+jmsow+29N5TIyGU0Q2j+4ve
         ZLdwJQqSHXal95s7VNJ+6sgqDCAJlSaR/mqej0yw+oyEjuR2pNmtKCk1vkn7ktpZa3zq
         An1FFbL6usuVfVOyISThZ9oPv1GAcUwpFUFrrSMnLuTYfBAQIFu16Ebzm1r9+JwG56uD
         ro69IsvYHfodtstW9FqKkmgWbMF0gUrUYbMefe3lorcOTeDFnizpfZpoT447Kz+0hmDN
         cnaO9kW7fTVSJgx7WRH9SaM+79JgAF3EgV5hBBFuPd+ozuUu8c6QKsFFrjkKp4XWGvyB
         wLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8YsxV0BcIxjrxOZuquH3V7doAs34PC7dcplFOM2TGSY=;
        b=MU3AV387VrVVO3MyG6Dk1d4naGs8uY6cDPxRVeZf9eg0rpUhCV1Y3jswl+cNpFzXJK
         mIYtugaNwT+HKelK4MPizdzNrWhJL0Krwtgbf9hYJE46+ftleVIUQu6jv/Tbiph0yLEM
         CkBEF+A7ZbjNuPwieCZ8JU7QoE+bShvAOs0UCRzQjAud9dO/s5q3z4WbwrP/hSwGwis+
         kSC68AzkbFtgS+9tMFFlsABB3yHuarHTuGiwgHKkgWqEgSnUmf/D6z6GyhyhWuz6WrDP
         Xns16tIccMOj0CKk6NQCAFAHkMvUyQhPSU3BFA54oPBSvZzwhEJgg6KgFv6It449cxtK
         wepg==
X-Gm-Message-State: APjAAAW3g0InmjvfG0lHUE7m/hSCwp1L5v/UmFZw8rFeykkZkLBNAJE1
        H8GfVwHSmHd7cQdIpECEh0noxcqmwYPhlPOM
X-Google-Smtp-Source: APXvYqy53Fshjz1lpkozQN058MsAHdRpurMzgDIYiEFwKI88T/fp1g+/p8qGHfG9yk8T/e2uZbdQmEb+5c+e8bPj
X-Received: by 2002:a63:cf4a:: with SMTP id b10mr470377pgj.86.1571700823091;
 Mon, 21 Oct 2019 16:33:43 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:22 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 3/9] KVM: x86: Remove unneeded kvm_vcpu variable, guest_xcr0_loaded
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_vcpu variable, guest_xcr0_loaded, is a waste of an 'int'
and a conditional branch.  VMX and SVM are the only users, and both
unconditionally pair kvm_load_guest_xcr0() with kvm_put_guest_xcr0()
making this check unnecessary. Without this variable, the predicates in
kvm_load_guest_xcr0 and kvm_put_guest_xcr0 should match.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I7b1eb9b62969d7bbb2850f27e42f863421641b23
---
 arch/x86/kvm/x86.c       | 16 +++++-----------
 include/linux/kvm_host.h |  1 -
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..39eac7b2aa01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -815,22 +815,16 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 {
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-			!vcpu->guest_xcr0_loaded) {
-		/* kvm_set_xcr() also depends on this */
-		if (vcpu->arch.xcr0 != host_xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
-		vcpu->guest_xcr0_loaded = 1;
-	}
+	    vcpu->arch.xcr0 != host_xcr0)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
 
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->guest_xcr0_loaded) {
-		if (vcpu->arch.xcr0 != host_xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
-		vcpu->guest_xcr0_loaded = 0;
-	}
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
+	    vcpu->arch.xcr0 != host_xcr0)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
 }
 EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..d2017302996c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -278,7 +278,6 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	struct kvm_run *run;
 
-	int guest_xcr0_loaded;
 	struct swait_queue_head wq;
 	struct pid __rcu *pid;
 	int sigset_active;
-- 
2.23.0.866.gb869b98d4c-goog

