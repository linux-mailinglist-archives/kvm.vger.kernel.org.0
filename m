Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19277233D98
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbgGaDMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 23:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731284AbgGaDMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 23:12:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F45C061574;
        Thu, 30 Jul 2020 20:12:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so6014623pjd.3;
        Thu, 30 Jul 2020 20:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tPJzt6hCr28nMvlRPeU7cuy9KZpdsuKpUl1/2Pv7MJo=;
        b=mLD+hI5qyhPWZAbK5CjoAHjrxXCA29ORK7oi4ZLY7vihruRs7sX/QL/AUBFIi3I5ka
         OEjuZC6ss/bbaEe/CHy3N6YC9k3fhFHAZaWBLzRLNE8vZq88+OIhbTuRyXFcolNncZVg
         5c8JRsgyhNwEaNXvZ9QfGpWMKTYEEhEULmM6mZDNKEqHhgNQYIc6SdPBynbq+NOwRfDQ
         JFgOMjBEcSWpSESrhjfwdQrYvVCrmf2eRDIftNoZ44SNN/t3b895RhOPR6D5ulDAIkjg
         rFA34XgkYpbX9Gv6TN4v0YayoF7UzlIj7BZ6xDwyIiwcC+0/9hbIXwHoTc44Vd2lKqXT
         giTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tPJzt6hCr28nMvlRPeU7cuy9KZpdsuKpUl1/2Pv7MJo=;
        b=LmCO59sp3TjGgA6AyxzQUguCL8Wzt0tCKskRWG+zvirZ6owl8mUsqAeYEQadp26Bv9
         Mm/4zCqSDTlvQ25jbJrKh7CoP0IgX1WuyA3HEL5FW5tC1eNj+Hij+mIVPORH+yYV6GKo
         XlN7SVcaAcwt1C336Or7gAkNil96ZxDr45icv7tV/dHNm9bdbfQEDSvmWyMIF7XnMnJq
         jnYKh+T76HwUURrWJ8GOQgFFoB4eU6EdzQSSn8srBQADJQ4BbJ34f6qD7xt9Q4ZlcqIi
         9YMwABK7myrojCxUfapCbmI5KLPPonWyX+3z1CdX8wEPxDF1cKEtaLlbs7I1vglwKSBo
         D47w==
X-Gm-Message-State: AOAM530VhnfNuL4XNUEed4TSI3Mxq3vgDRa4Mg2OE81zVH0MR7BJgBt0
        0OD6hvCOgQctxTDHKFJ7s+jnwqTJ
X-Google-Smtp-Source: ABdhPJz4SqGEyF0fKUXkl4NNUswbWn0leItPQBNpbUyN94kwgKwftMcOg4m9cQxjICJZw7R9qih0Ow==
X-Received: by 2002:a17:90b:390f:: with SMTP id ob15mr2053196pjb.156.1596165162337;
        Thu, 30 Jul 2020 20:12:42 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id t19sm8221961pfq.179.2020.07.30.20.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 20:12:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 3/3] KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM
Date:   Fri, 31 Jul 2020 11:12:21 +0800
Message-Id: <1596165141-28874-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
References: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

'Commit 8566ac8b8e7c ("KVM: SVM: Implement pause loop exit logic in SVM")' 
drops disable pause loop exit/pause filtering capability completely, I 
guess it is a merge fault by Radim since disable vmexits capabilities and 
pause loop exit for SVM patchsets are merged at the same time. This patch 
reintroduces the disable pause loop exit/pause filtering capability support.

Reported-by: Haiwei Li <lihaiwei@tencent.com>
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * simplify the condition in init_vmcb() 

 arch/x86/kvm/svm/svm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd..bf77f90 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
-	if (pause_filter_count) {
+	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool in_kernel = (svm_get_cpl(vcpu) == 0);
 
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
@@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 }
 
@@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	if (!pause_filter_count || !pause_filter_thresh)
+		kvm->arch.pause_in_guest = true;
+
 	if (avic) {
 		int ret = avic_vm_init(kvm);
 		if (ret)
-- 
2.7.4

