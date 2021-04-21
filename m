Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10049366409
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhDUD0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhDUD0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 23:26:01 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDA6C06174A;
        Tue, 20 Apr 2021 20:25:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f29so28405466pgm.8;
        Tue, 20 Apr 2021 20:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ne5KPOc7SK9cFqWFpyxYwHEZ6kioC/3SR/ZzT9KLMRw=;
        b=bC+IVxfoTSFfaDW5+PbOlxCYWpspTKXhw7XjqjL9tQynWSzMX1xAtbobFyke73dfrC
         GpUmqJR+0YeN5eN5+ulxFikZlYTfPYNzx9qjKcA/4M359vigw/FVlbHfxvrH2TIFB2KQ
         G6jF1WZOlObT2KGIr5tsQIMLMawOzBtZEcl3k2ZEPowG8MPo+Lx4b+LDyRy8OhM56yP9
         0hGCGX8W27NkwttkmiujnK93biBEq50+e3Wl5/mAXQMKNmXtUcUHkUHAlvH9tUkBx6Jg
         gyYrDYqr8quiR66C8AKQbxpUjsYmwJn/CZLCFO01EIy4hX4xHcL6cW2rrGb6Suh17y7D
         +A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ne5KPOc7SK9cFqWFpyxYwHEZ6kioC/3SR/ZzT9KLMRw=;
        b=K4x3gdhpzpYVJ2nCuprQfiG8Mi0on2dgP2Ur5jX7CQI9SMbvNNY6dRUEQbs4+CfFqb
         trPuE7pRPcSFPEXH/7H6dbRbsSlzhdGi+6nfbR7xT6xDqmd79kSz/kLTXI4xiN3IsJF9
         lYlQRtgHqdo27ucS/WyfpatoHw9Uvlxcy29dohvWNnKXA1DuWMBXVwy6rfVi1jsmXuZy
         HTZmWddzJ5xDNIsqXCtgYRXpTP20aPT7U580rqyjyzIwQO34GshSbr2kkfhFdz8su3SR
         sD6nk8CcqZK2fxI4pYIoRaSWltl3hGQWOVm6DZSlShvi3Vyx01KiFjr7MZI5RJrSdCjb
         jmdg==
X-Gm-Message-State: AOAM533nFNXtShOBQqNALwlsMvL0LY/ywcpV9Dz+OUFVisngcFpEwSxv
        2vpAjqMNPcoWk/xXNdgrWEZA0d1oZA==
X-Google-Smtp-Source: ABdhPJycyImxuKTqrEcAMsiMSfP0zKusz02+ZQPZgefe+TPwP9sGqzabZozhVvHrMM7s7CgfEEMRTQ==
X-Received: by 2002:a05:6a00:882:b029:24b:afda:acfa with SMTP id q2-20020a056a000882b029024bafdaacfamr27665486pfj.72.1618975525185;
        Tue, 20 Apr 2021 20:25:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id u24sm367150pga.78.2021.04.20.20.25.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Apr 2021 20:25:24 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: x86: Take advantage of kvm_arch_dy_has_pending_interrupt()
Date:   Wed, 21 Apr 2021 11:25:13 +0800
Message-Id: <20210421032513.1921-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

`kvm_arch_dy_runnable` checks the pending_interrupt as the code in
`kvm_arch_dy_has_pending_interrupt`. So take advantage of it.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/x86.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d696a9f..08bd616 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11125,28 +11125,25 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
 }
 
-bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
-		return true;
-
-	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-		kvm_test_request(KVM_REQ_SMI, vcpu) ||
-		 kvm_test_request(KVM_REQ_EVENT, vcpu))
-		return true;
-
 	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
 		return true;
 
 	return false;
 }
 
-bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
+	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
 		return true;
 
-	return false;
+	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+		kvm_test_request(KVM_REQ_SMI, vcpu) ||
+		 kvm_test_request(KVM_REQ_EVENT, vcpu))
+		return true;
+
+	return kvm_arch_dy_has_pending_interrupt(vcpu);
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
-- 
1.8.3.1

