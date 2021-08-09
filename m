Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8163E4B01
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 19:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhHIRkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 13:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbhHIRkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 13:40:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1196C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 10:40:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f8-20020a2585480000b02905937897e3daso4865480ybn.2
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 10:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J36Wx/RkTb0D4oTQeLsHsT1q0l8StXG1g3yJDRFzPZE=;
        b=VdTTxR661OL3+D5jswoMHXZIoH3185bNJA+vHUPtyk+nv1RVhw48mrJAUzZm07Bt6r
         DyAdUL2h1TLN5GaCLOsG3sInSLCU/uemQ9DGHfm6ph9xXASmnUc2hKyar26TxDz9SpdL
         5XzXbtKpihv9i/vvyu8wkVBh4+a8qcg2NShVlbJ9o1c8Z444LaKAGWi8LIo6PeZqEwWf
         CkK09U8+KicN0lDfvdsZ64/P3fyh4fb/TTxpFRxE+BYMuEqO2OI4ph/qMuxmdRHlh9ym
         g2r3yfBEsybF6onKjyQYnMmqFSTJ3HrEeTG1VHAldc/ZwcA7BvP9GqmSYET6/h601hnG
         Wb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J36Wx/RkTb0D4oTQeLsHsT1q0l8StXG1g3yJDRFzPZE=;
        b=erhjGxtCN5S2KV07mMtH1qlDxC/DyowJMbWktwDAjPWokwp/nwoxQ6P3JueCbI/Drn
         QJ2dY+K6ai8BSvttUGZPkincCVGzFIirgvhDAvVgasBDvnSbSjjhOX8VqMTYYQtOdawB
         a1IM3s43VBW6kTwkCLPdJq8YodoQFgnZH5BzErZV+//vcBTpeAX1nBCsv6wp/xickWAH
         p23iZF9r99spYo/5cBnYjW7p/VQBLYCn/qAbWdxnIS9C7eDbd/5/qZkafTFHcJSolNDP
         gZOQtPhA/30EZ3KBYZsv1QflhioiLXuhnvhsNJfUG56A+vxYQULP39SuNj8V3Z9b7d2c
         Ezcg==
X-Gm-Message-State: AOAM530tawBh0Bdzzpm8+aT61BvJjOMuMl6aln1y5p2O03l2ezddp3BR
        1fD5YTNKWLhbQZJAx4vluANUToP8rZA=
X-Google-Smtp-Source: ABdhPJxfsVYalWjf7EAWF143gPK9KWWTt1llY4AdJOvSpHxmE3x5I+M8k/C6dMXHmNMbqBjXGNz74hdfTiY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b967:644e:62eb:1752])
 (user=seanjc job=sendgmr) by 2002:a25:c4:: with SMTP id 187mr33657699yba.373.1628530809907;
 Mon, 09 Aug 2021 10:40:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  9 Aug 2021 10:39:55 -0700
In-Reply-To: <20210809173955.1710866-1-seanjc@google.com>
Message-Id: <20210809173955.1710866-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210809173955.1710866-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 2/2] KVM: x86: Move declaration of kvm_spurious_fault() to x86.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

Move the declaration of kvm_spurious_fault() to KVM's "private" x86.h,
it should never be called by anything other than low level KVM code.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
[sean: rebased to a series without __ex()/__kvm_handle_fault_on_reboot()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 arch/x86/kvm/svm/svm_ops.h      | 2 +-
 arch/x86/kvm/vmx/vmx_ops.h      | 2 +-
 arch/x86/kvm/x86.h              | 2 ++
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 56540b5befd0..45e618902623 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1798,8 +1798,6 @@ enum {
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 
-void kvm_spurious_fault(void);
-
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 8170f2a5a16f..22e2b019de37 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -4,7 +4,7 @@
 
 #include <linux/compiler_types.h>
 
-#include <asm/kvm_host.h>
+#include "x86.h"
 
 #define svm_asm(insn, clobber...)				\
 do {								\
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index c0d74b994b56..9e9ef47e988c 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -4,11 +4,11 @@
 
 #include <linux/nospec.h>
 
-#include <asm/kvm_host.h>
 #include <asm/vmx.h>
 
 #include "evmcs.h"
 #include "vmcs.h"
+#include "x86.h"
 
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 44ae10312740..7d66d63dc55a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+void kvm_spurious_fault(void);
+
 static __always_inline void kvm_guest_enter_irqoff(void)
 {
 	/*
-- 
2.32.0.605.g8dce9f2422-goog

