Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0A12C0B6
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfE1H4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:56:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47062 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfE1H4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:56:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so4081118pgr.13;
        Tue, 28 May 2019 00:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcCjT6H+ppzU8yxObmCoxmme1+yJ2Skn/UpNWVNXol4=;
        b=r9JapoW1TH03Z/msb2tYdBDcW+hg2JYfMfbi9w7RxLk2HRF018D93yT2si+fcWvWJY
         awPPWDkG3esohpIPq+sPC+d9BmmDseTIzY+MY7hgLZSfnX+bemH8hy6ftlhBI74VHnLR
         6jj6HKcdtouJ68EbmdMAVXrC02sUsTtkwgwMs/GZe/jnlKaQVcBlJ5cm7o5VVAQZQK6n
         +Gk8ec9f7wATmcKF9Jo7vZ+l1XKsXscjs7KpjDVstDmhNXQx6Otj9c1lLGsaSA4Lc+hV
         zOHe4ve5j7rYdLat+R7sraBfQT65GZm91JLYLJ22YlrHWfL4i0Vy70zYCZFUFMHHCkeQ
         jw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcCjT6H+ppzU8yxObmCoxmme1+yJ2Skn/UpNWVNXol4=;
        b=GR8S+RuS7Xi16znXoR6jqJUxXqED3Vs4Z2c/WSDRc3Lq8n1xKAY5QNo9A9zwCg0xNA
         JVIFfqXpYRI+vUVHi3SBch8O3TepWfRRAb+yK2rikfSXqqaySmHCsOjkGWpQd9kf40AY
         f43fzFoyWxw5h6IcdZeuA5xLUbNfPUdiRLphiYNyUV+rmWe1Ubk7fC2xy9e+TQBE7C7a
         WWkrTAY32auGdWUbNZcKGe3vj23skZHZrfI7d/VVoyfn/58+NIcMDcNDHbbRDR6KURjr
         XpaIsAg9+EyizLNzsFUZUzxuWMCQ7GCps0OfSk6tgwx9mplBglLHqPMj9iIthyW3C7uA
         VW+g==
X-Gm-Message-State: APjAAAXu0XQXFo4gErt1UIfqsvpeSDaUS4r8ZzEaSYioNh7wSGptGCVV
        bqv7ktxxljzO5Kpek7VTKYZqylV9
X-Google-Smtp-Source: APXvYqykojq1rbvP+sqE1AFM44WkyozcRq8ufVLdy925zEx8t//KLsj8Hj/DGg7G8sgPNaOqUhEzrQ==
X-Received: by 2002:a63:246:: with SMTP id 67mr132546747pgc.145.1559030203643;
        Tue, 28 May 2019 00:56:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id t64sm2906920pjb.0.2019.05.28.00.56.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:56:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 2/3] KVM: X86: Implement PV sched yield hypercall
Date:   Tue, 28 May 2019 15:56:34 +0800
Message-Id: <1559030195-2872-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559030195-2872-1-git-send-email-wanpengli@tencent.com>
References: <1559030195-2872-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The target vCPUs are in runnable state after vcpu_kick and suitable 
as a yield target. This patch implements the sched yield hypercall.

17% performance increase of ebizzy benchmark can be observed in an 
over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush 
call-function IPI-many since call-function is not easy to be trigged 
by userspace workload).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7e57de..f73af3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7172,6 +7172,28 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 
+static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
+{
+	struct kvm_vcpu *target;
+	struct kvm_apic_map *map;
+
+	rcu_read_lock();
+	map = rcu_dereference(kvm->arch.apic_map);
+
+	if (unlikely(!map))
+		goto out;
+
+	if (map->phys_map[dest_id]->vcpu) {
+		target = map->phys_map[dest_id]->vcpu;
+		rcu_read_unlock();
+		kvm_vcpu_yield_to(target);
+	}
+
+out:
+	if (!target)
+		rcu_read_unlock();
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -7218,6 +7240,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_SEND_IPI:
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
+	case KVM_HC_SCHED_YIELD:
+		kvm_sched_yield(vcpu->kvm, a0);
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
-- 
2.7.4

