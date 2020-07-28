Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD12306CF
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgG1JpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 05:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgG1JpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71394C061794;
        Tue, 28 Jul 2020 02:45:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so1791533plk.13;
        Tue, 28 Jul 2020 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v4hzsRw11Wiw6xr0GvgfYpPF0Q4BnW/4rsf/8GkZyQw=;
        b=Zos4drdqzuG48wXtTv4pVVnjusmQl20abj+Kz1EqvewUtCnxXvkgMu0kwocJVglioq
         IGYaSAvrCj7Xt1MwTvrLt/GTXjliBxkNT+YTiZJWKuJI+F0eQxtzPsKj37plB7VyuTSn
         7xN+UTf26Hu/SartpedeJofd3RnImxX3lAT0j1Nfq5AjCYKn8uWbFigOEevIfBzcay0l
         Chljv6Gk/6ZrD3mlVeQHl367jg/cxrG0PLHltEBZnT1E8sat9X3g9KRPskDUUch0z9Cp
         f+L5WVGo7e8klo7kB0PhQ51xQNZaf6u0hk5/VNPMhXxpUZizcUoJbpsXMSTJHN7duWKc
         AmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v4hzsRw11Wiw6xr0GvgfYpPF0Q4BnW/4rsf/8GkZyQw=;
        b=luCF/VdCih1z/QADt95HH5yiJhJmj/yisYGTE3ssq0eO0aNm65iSzYkYPkZHH/ePGa
         Xv6QvC/0AyUMXBt/NJYh+8jUMRMWghgvXahQjv6U9frPUsMpPjEpoPbqUENXODLsu7XU
         ZVODNg33Cx8mvTf3gGu3/IR69d+RuxcFUP5jTDERrM08CcoDYxSoXVpld6kcerCyFSKk
         ZfzRbj9SDnyQ4tTew40ZHCJ7776t1P6NciqSE22xMfRIK+mI6Yv9mgnXQvhOVuOFRzs8
         1oFiSON4MO2zABdqNU1q+5Em9C64uk/3wn72O0eqfOOOkptQOkefH5fr6eVKqOGuRahS
         PfQw==
X-Gm-Message-State: AOAM5326Ox1o8QitFORgMJc8/NgHmbwFI/BxAYiAM9/G22nxG8dnJiGh
        2PCM7tet8B3wjDI1bB0VXHmfpekJ
X-Google-Smtp-Source: ABdhPJxsZ5mYTWHDw/CZGoeaB7OeyI6mv6+zZ2Fpowq9ZFMFVYcxatXVTbH9YxF75bc0dzckLtbQUQ==
X-Received: by 2002:a17:902:59d2:: with SMTP id d18mr11673509plj.243.1595929520819;
        Tue, 28 Jul 2020 02:45:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id r17sm17969173pfg.62.2020.07.28.02.45.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 02:45:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/3] KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM
Date:   Tue, 28 Jul 2020 17:45:06 +0800
Message-Id: <1595929506-9203-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM) drops
disable pause loop exit/pause filtering capability completely, I guess it
is a merge fault by Radim since disable vmexits capabilities and pause
loop exit for SVM patchsets are merged at the same time. This patch
reintroduces the disable pause loop exit/pause filtering capability
support.

We can observe 2.9% hackbench improvement for a 92 vCPUs guest on AMD 
Rome Server.

Reported-by: Haiwei Li <lihaiwei@tencent.com>
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd..c20f127 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
-	if (pause_filter_count) {
+	if (pause_filter_count && !kvm_pause_in_guest(svm->vcpu.kvm)) {
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
+	if (!pause_filter_thresh)
+		kvm->arch.pause_in_guest = true;
+
 	if (avic) {
 		int ret = avic_vm_init(kvm);
 		if (ret)
-- 
2.7.4

