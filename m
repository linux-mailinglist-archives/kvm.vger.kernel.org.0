Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BDF1BB675
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgD1GXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726463AbgD1GXq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C3EC03C1A9;
        Mon, 27 Apr 2020 23:23:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l20so1886467pgb.11;
        Mon, 27 Apr 2020 23:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oQfltYNxiPjEH77FfOHpysAJQ9qhxIF+HiwY5HDOYEg=;
        b=na1g+X5kfYLb3TSDeKHaz9nHOucdv8OBXFIYXvDOTe0/LDDQpP7S+ngzWqWkMFF8P2
         +EEtmI+zlu5C5KBfm+/htgzONU+jf+GKEevYCdSstpf4OdbGsOkKxQkllYcIo4O48fP1
         ImqWa7uJzyJnKm2g5QXpUIULaxlE3wFTK6lsqHvXD8fteSAD7W7Qfl4/1M9lfTTWT1se
         7qX+eMYgrSEjkAq2N7m1qtZ2l9t4RxG23M19y5H/vtsW0y3+8QD7anTOgi265fWt0NsD
         bI3FDiKz3OVg9gMj93babGkkJ/vsUXNABFShyI4SwL3OGZNLuEj6gKOIjtd1iK8eM6is
         wSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oQfltYNxiPjEH77FfOHpysAJQ9qhxIF+HiwY5HDOYEg=;
        b=XPNdUzPZ3PI3/lY1dpfOTZ7vIp2LXMoK1DUVeXngFo0zkoaL3CEIkZdQTJcSYM45FZ
         3BJ9zPXHeycVC4tYJSifv9jT8vbFl6L3xVLALHL15eYennZ3U+tYtU3I6hXWqdcL0KjL
         XWoahoRJlwd9bk5kggWwRvKbcCKs2a9V3/G4beHERx3Jl8dJxg6cbZRQhfSCte0u1ETi
         Vd4QawSKBpOX1VeGQHMQt4YUL1eO8PdaEBQZXYViqEC7FwW99VUJybtMhoo1Zrs0rQFf
         8q32Mnh46xNvmLwxpJYee1tPeK7N7z5CRlUKPM803ZLtXJcaXeunk/hHdjBEYyJbHLMG
         xliQ==
X-Gm-Message-State: AGi0PubsgvZbKZGXRy8/JXhgZt++gGMQVbtq648ov1W3oKwC5e7SI3d2
        pPDOah5/4TaOCl11bAy2rwYlQvOR
X-Google-Smtp-Source: APiQypKp1hI4VWMsNDTx5ZJ2YDneopaWSbNacQZzEDnVuNIoRpzvPLBXOQoCT+NgPVoa0SdmA4aqAg==
X-Received: by 2002:a63:d806:: with SMTP id b6mr2196905pgh.72.1588055025038;
        Mon, 27 Apr 2020 23:23:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:44 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 2/7] KVM: X86: Enable fastpath when APICv is enabled
Date:   Tue, 28 Apr 2020 14:23:24 +0800
Message-Id: <1588055009-12677-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

We can't observe benefit from single target IPI fastpath when APICv is
disabled, let's just enable IPI and Timer fastpath when APICv is enabled
for now.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8fc65..1e7220e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3344,7 +3344,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu) &&
+	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active &&
 	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
 	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		return handle_fastpath_set_msr_irqoff(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b5adb4..f207004 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6585,7 +6585,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 
 static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu)) {
+	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
 		switch (to_vmx(vcpu)->exit_reason) {
 		case EXIT_REASON_MSR_WRITE:
 			return handle_fastpath_set_msr_irqoff(vcpu);
-- 
2.7.4

