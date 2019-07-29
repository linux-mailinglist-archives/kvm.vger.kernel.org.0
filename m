Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CA7846F
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 07:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfG2FdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 01:33:01 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37405 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfG2FdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 01:33:01 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so27056275plr.4
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2019 22:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dl9/+u0b6L/IcklRFKklE/XMP6QZhufwp9r7/QOwquY=;
        b=ua+sProjCIRzLvxS4QT1MHBlqOpB7AhbFURjrRlWcv72ugbgZQhKB3ZUUtRRQSR3H+
         KDJsVTx9hDjIXplU1fYOw2br2wyjfeMdohHhsG8mizCLQtdRynOWtGRR5X9u42I4AiG4
         Y7NOTncks7wylIBGh4G5tys2iv/kizxd3Pg1WVYqbLB+ShO7KkZb/M4BJerftvBpLdy0
         ThmShgR+MgZ6vtK0/gz2TYS9n8RwiYNBQZaZbuymnZCWWSXIl61EFtwV9h/uIJqFXqJN
         z4R++VdExX/uZ6rwklvxfQrD0TVSY6a32W+Y1WEYUJCsUbnfGCjNNahjEUNH55yMDlqy
         L0jQ==
X-Gm-Message-State: APjAAAWdY7WDN6iZwbGtT4Sr81V9hHz0Ac96+AOQ5gqA2BthX68jhW9N
        4xxVhBcZFuQ7cgrV5G97Gh3dvD3ZDlY=
X-Google-Smtp-Source: APXvYqwJ75zOeV3IXYaS4xaDewF73/KCZ1eplBMwKI992xyAk5GCZmKqw8Ou8QQfAw1iWvlwpBI0DA==
X-Received: by 2002:a17:902:e011:: with SMTP id ca17mr110382769plb.328.1564378379971;
        Sun, 28 Jul 2019 22:32:59 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o129sm30498550pfg.1.2019.07.28.22.32.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 22:32:59 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
Subject: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Date:   Mon, 29 Jul 2019 13:32:43 +0800
Message-Id: <20190729053243.9224-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729053243.9224-1-peterx@redhat.com>
References: <20190729053243.9224-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PLE window tracepoint triggers easily and it can be a bit
confusing too.  One example line:

  kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)

It easily let people think of "the window now is 4096 which is
shrinked", but the truth is the value actually didn't change (4096).

Let's only dump this message if the value really changed, and we make
the message even simpler like:

  kvm_ple_window: vcpu 4 (4096 -> 8192)

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/svm.c     |  8 ++++----
 arch/x86/kvm/trace.h   | 22 +++++++++-------------
 arch/x86/kvm/vmx/vmx.c |  4 ++--
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 48c865a4e5dd..0d365b621b5a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1268,8 +1268,8 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	if (control->pause_filter_count != old)
 		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
-	trace_kvm_ple_window_grow(vcpu->vcpu_id,
-				  control->pause_filter_count, old);
+	trace_kvm_ple_window_changed(vcpu->vcpu_id,
+				     control->pause_filter_count, old);
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
@@ -1286,8 +1286,8 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	if (control->pause_filter_count != old)
 		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
-	trace_kvm_ple_window_shrink(vcpu->vcpu_id,
-				    control->pause_filter_count, old);
+	trace_kvm_ple_window_changed(vcpu->vcpu_id,
+				     control->pause_filter_count, old);
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 76a39bc25b95..91c91f358b23 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -891,34 +891,30 @@ TRACE_EVENT(kvm_pml_full,
 );
 
 TRACE_EVENT(kvm_ple_window,
-	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
-	TP_ARGS(grow, vcpu_id, new, old),
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
+	TP_printk("vcpu %u (%d -> %d)",
+	          __entry->vcpu_id, __entry->old, __entry->new)
 );
 
-#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
-	trace_kvm_ple_window(true, vcpu_id, new, old)
-#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
-	trace_kvm_ple_window(false, vcpu_id, new, old)
+#define trace_kvm_ple_window_changed(vcpu, new, old)		\
+	do {							\
+		if (old != new)					\
+			trace_kvm_ple_window(vcpu, new, old);	\
+	} while (0)
 
 TRACE_EVENT(kvm_pvclock_update,
 	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac371c0a..cc1f98130e6a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	if (vmx->ple_window != old)
 		vmx->ple_window_dirty = true;
 
-	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
+	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
@@ -5229,7 +5229,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	if (vmx->ple_window != old)
 		vmx->ple_window_dirty = true;
 
-	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
+	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
 /*
-- 
2.21.0

