Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F776A9861
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfIECgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730451AbfIECgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:36:41 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9D85C059B7A
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:36:40 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id n186so706027pfn.6
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6stKbdekXMjRG/f5W66QTsz7042dwBNOPkQ0QpPvAYM=;
        b=JLa2yCy1z/Pp9+Lt9UeFfpdCQhec4Z7bo3yUH4CEfnoBhKMCDU+MJli0yriBRlNu4k
         v2B00+OsYd7hFVdVUoNPccMYRz3mlbMOX4VCKUCoW6douEYYUrgimfpdWyzrKDu2aVjA
         6+oPqBx3q9QVn39AHFdwA/YsmUX0Ohk3pp9tWvtsqcXgtRY9NZKaFLC5rclZQsgcstab
         fWPP9jBaX4Rc/LuUmH7sc8lV2RcNCQSDM7qb9N8qZufz6IUiGDA5H0+icZQj49fgokwV
         FAC4+sAuyZ0AhfJ60yCcKc2hpphC37GF1YA75lawRFbsrT7jO/E0xlibi2eRlC812jRr
         5FGA==
X-Gm-Message-State: APjAAAWtyiUVc5VgHuptTDoynBHR8CC0sVuVg1aUDcyeGTVaOSl8cvM3
        lCgJw24CjGGXFI9y+aTvZgJNBB+c88PX0fEu/nBpWQdNOoWhKIy7ldMR4sWQVIAHK7jH0UqT+Xb
        1dzohpQ8GKV4+
X-Received: by 2002:a63:550d:: with SMTP id j13mr1049545pgb.173.1567650999722;
        Wed, 04 Sep 2019 19:36:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwujyx4mogXKAdzSw35C/1j5ZYEkkWbNOvY6Zy2iqj+yxrNxXN8Kyq3M8rXCTbJMiIT1aQNWg==
X-Received: by 2002:a63:550d:: with SMTP id j13mr1049523pgb.173.1567650999422;
        Wed, 04 Sep 2019 19:36:39 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm326504pjk.23.2019.09.04.19.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:36:38 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v3 3/4] KVM: X86: Tune PLE Window tracepoint
Date:   Thu,  5 Sep 2019 10:36:15 +0800
Message-Id: <20190905023616.29082-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905023616.29082-1-peterx@redhat.com>
References: <20190905023616.29082-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PLE window tracepoint triggers even if the window is not changed,
and the wording can be a bit confusing too.  One example line:

  kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)

It easily let people think of "the window now is 4096 which is
shrinked", but the truth is the value actually didn't change (4096).

Let's only dump this message if the value really changed, and we make
the message even simpler like:

  kvm_ple_window: vcpu 4 old 4096 new 8192 (growed)

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/svm.c     | 16 ++++++++--------
 arch/x86/kvm/trace.h   | 21 ++++++---------------
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
 arch/x86/kvm/x86.c     |  2 +-
 4 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d685491fce4d..d5cb6b5a9254 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1269,11 +1269,11 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 							pause_filter_count_grow,
 							pause_filter_count_max);
 
-	if (control->pause_filter_count != old)
+	if (control->pause_filter_count != old) {
 		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
-
-	trace_kvm_ple_window_grow(vcpu->vcpu_id,
-				  control->pause_filter_count, old);
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    control->pause_filter_count, old);
+	}
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
@@ -1287,11 +1287,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 						    pause_filter_count,
 						    pause_filter_count_shrink,
 						    pause_filter_count);
-	if (control->pause_filter_count != old)
+	if (control->pause_filter_count != old) {
 		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
-
-	trace_kvm_ple_window_shrink(vcpu->vcpu_id,
-				    control->pause_filter_count, old);
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    control->pause_filter_count, old);
+	}
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 8a7570f8c943..f1177e03768f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -890,36 +890,27 @@ TRACE_EVENT(kvm_pml_full,
 	TP_printk("vcpu %d: PML full", __entry->vcpu_id)
 );
 
-TRACE_EVENT(kvm_ple_window,
-	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
-	TP_ARGS(grow, vcpu_id, new, old),
+TRACE_EVENT(kvm_ple_window_update,
+	TP_PROTO(unsigned int vcpu_id, int new, int old),
+	TP_ARGS(vcpu_id, new, old),
 
 	TP_STRUCT__entry(
-		__field(                bool,      grow         )
 		__field(        unsigned int,   vcpu_id         )
 		__field(                 int,       new         )
 		__field(                 int,       old         )
 	),
 
 	TP_fast_assign(
-		__entry->grow           = grow;
 		__entry->vcpu_id        = vcpu_id;
 		__entry->new            = new;
 		__entry->old            = old;
 	),
 
-	TP_printk("vcpu %u: ple_window %d (%s %d)",
-	          __entry->vcpu_id,
-	          __entry->new,
-	          __entry->grow ? "grow" : "shrink",
-	          __entry->old)
+	TP_printk("vcpu %u old %d new %d (%s)",
+	          __entry->vcpu_id, __entry->old, __entry->new,
+		  __entry->old < __entry->new ? "growed" : "shrinked")
 );
 
-#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
-	trace_kvm_ple_window(true, vcpu_id, new, old)
-#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
-	trace_kvm_ple_window(false, vcpu_id, new, old)
-
 TRACE_EVENT(kvm_pvclock_update,
 	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
 	TP_ARGS(vcpu_id, pvclock),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3faa6af8..469c4134a4a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5233,10 +5233,11 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 					    ple_window_grow,
 					    ple_window_max);
 
-	if (vmx->ple_window != old)
+	if (vmx->ple_window != old) {
 		vmx->ple_window_dirty = true;
-
-	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    vmx->ple_window, old);
+	}
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
@@ -5248,10 +5249,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 					      ple_window_shrink,
 					      ple_window);
 
-	if (vmx->ple_window != old)
+	if (vmx->ple_window != old) {
 		vmx->ple_window_dirty = true;
-
-	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
+		trace_kvm_ple_window_update(vcpu->vcpu_id,
+					    vmx->ple_window, old);
+	}
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd45ac73..69ad184edc90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10082,7 +10082,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
-- 
2.21.0

