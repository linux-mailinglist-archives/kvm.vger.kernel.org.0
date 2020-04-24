Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A466F1B6E1C
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDXGXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726699AbgDXGXN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:23:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A078C09B045;
        Thu, 23 Apr 2020 23:23:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so2966738pjb.5;
        Thu, 23 Apr 2020 23:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MxB/5+Kd2C0pw05dDYhqC6sr311SJsuN/Ux6MEaNAeM=;
        b=ALTyvKyQUjtlg1598kuRSm4WumDxkjhA8gT+IOrw0J1iqMj9KYEY90As0WJHEcHVWz
         SamkGK23L+Z9bffWYiSZeLeAxbnhyNhJR+dLizlJvZK68g3vmHopsd4o+qQQXcHlTSdh
         YsrptaoTIB1yjQd/1JFsnNOWXYiyu/FXkikO7RG0v6ecwBhF7dzayOUPzRT03K5cYgxr
         zIoFFlYjjq+GnIZ1PUWjzQBOjTcTDVniEbb9vEMqgWyvEYc4lx25ZjNpzthl3tIHQ3K6
         uxXvG0nn+9CxfZnNS8HNZSVipbvLF4gi/HiYMMQNyNpDQ4bVFC9/bZOauoHktiqZD7jB
         lfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MxB/5+Kd2C0pw05dDYhqC6sr311SJsuN/Ux6MEaNAeM=;
        b=KyEYEkCur6d+JCH/th/ozfnkwCfWLhmQx42wsAyF2cUTI1tnqZj50gxzAzGFqaCl0d
         zO6kg7F2wiDU+evjjswTXATb6dsVanzsaE/5Z9S2juwrXFra9rC5KwQsDm03pP9beF1i
         sw8+qN9nvcRsrobMRJQ+v7pC5lq68O8UB7S6AngfvUQ5bbWnZTmWfWCOjxEXaMMRKhYl
         5TbkUcFpZ0qbekOXwNvMbClqsTx83ANgeOVNeTkep2O68kZk8njroBwPpP9xIaE2vPkG
         dnI5O0Ub9trtIhynUKiqTMc708p6hu/qk8q5K8YvuKxDdfGavQp0un4iGEnd0L6DN1Bb
         KPmg==
X-Gm-Message-State: AGi0PuZvh8N8SjnmAYP10PZbuTLOf8MhBxzsBFfBzOMMmpOyLX4eE9A4
        7rLfebTZwERVTCZdCXjw2Gg0Kqab
X-Google-Smtp-Source: APiQypK/mIzK+C1SxJQBVgxJKD0z5j932b08/NaZVr/QTI123ZiXW+iATgxaMwlHykGir3aFTd+rPA==
X-Received: by 2002:a17:90a:db53:: with SMTP id u19mr4771195pjx.41.1587709391365;
        Thu, 23 Apr 2020 23:23:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:23:10 -0700 (PDT)
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
Subject: [PATCH v3 5/5] KVM: VMX: Handle preemption timer fastpath
Date:   Fri, 24 Apr 2020 14:22:44 +0800
Message-Id: <1587709364-19090-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements handle preemption timer fastpath, after timer fire 
due to VMX-preemption timer counts down to zero, handle it as soon as 
possible and vmentry immediately without checking various kvm stuff when 
possible.

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5540.5ns -> 4602ns       17%

kvm-unit-test/vmexit.flat:

w/o avanced timer:
tscdeadline_immed: 2885    -> 2431.25  15.7%
tscdeadline:       5668.75 -> 5188.5    8.4%

w/ adaptive advance timer default -1:
tscdeadline_immed: 2965.25 -> 2520     15.0%
tscdeadline:       4663.75 -> 4537      2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21b66b..028967a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6560,12 +6560,28 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!vmx->req_immediate_exit &&
+		!unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+		kvm_lapic_expired_hv_timer(vcpu);
+		trace_kvm_exit(EXIT_REASON_PREEMPTION_TIMER, vcpu, KVM_ISA_VMX);
+		return EXIT_FASTPATH_CONT_RUN;
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
+
 static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
 		switch (to_vmx(vcpu)->exit_reason) {
 		case EXIT_REASON_MSR_WRITE:
 			return handle_fastpath_set_msr_irqoff(vcpu);
+		case EXIT_REASON_PREEMPTION_TIMER:
+			return handle_fastpath_preemption_timer(vcpu);
 		default:
 			return EXIT_FASTPATH_NONE;
 		}
-- 
2.7.4

