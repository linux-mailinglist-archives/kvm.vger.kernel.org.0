Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC272EA0D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 03:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfE3BFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 21:05:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38687 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfE3BFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 21:05:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id a186so2091627pfa.5;
        Wed, 29 May 2019 18:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nl87Zzt2g/Jhk18hZDpMWkRfM4v7xHWaSrq5qLezpJc=;
        b=Lf/QLagolBqTstdBtF0EHeqzeM+OeTuLhSpkv/iHTh0H0681R/OJPR3dS9Lu92ch0C
         gC2Hyub52q69czChb5oYC5DDr+BQDqRClJJOf0UUNMJcPWzmC7EKsbLSi4heAHpJ1LX0
         zT27udAuTMtT20uuAWhmHZS9ivfLb4V111AeyLNwC/K3p75Q313wSqUsbuiLk+BN+xys
         O1r1MjMWpOpEg+GSUz8d8P6smE1ZXxLuGlpHVl9kBO+daVsPmH6jnnTZ8e1ygQA8Eelg
         ikCkQQnkF/tWqFEyF2Jjs00VOOcs5AvJnz0dl61zcn5GkbIfGoZdEd8WPK+MriVfxQEK
         ER4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nl87Zzt2g/Jhk18hZDpMWkRfM4v7xHWaSrq5qLezpJc=;
        b=IuWrRq9RIkF67TWcBpPTbivB4r5AmhZ46tHVANn5O3U0I7AdYzyEr3x5h0XPfmzIWr
         p5qWnjn8JbGk154N5Xz5KZAB0uU/pwZhGyAxKt+Hch33Y/xqv7He7VDXKUh4ei3WeYM8
         oJRhaAHJ6atFIXibir6vA051joWOEemLudOiidnczj9Jnb+Iuy7TXBleY0eWY2Botw0W
         Anvb13NazSb+Zp+kEO3Zbrf3kXM5cfLwymYEBfAEsDapWzXmEkFNTxj3Ea/J/ALD9D8C
         URxS+y6LRnl0Q8+BNe5RAC1OaT74mv683oo/Uasw40l8WitA3GdOGL5sTMJnyJt7n+c9
         t8Tw==
X-Gm-Message-State: APjAAAVVvWDX4cxRudrQjyFbPHoiGwsibMtYAHm2P3x9cRwd337FCmQb
        p2dnGrcDTOgHZ9ZYzcaHFr77ulqx
X-Google-Smtp-Source: APXvYqzn35UrHLbk3sYI0EeUtfr/XAbRlrVdSiTj/y3EKOPC/FZ7tWNsFsfV47WqqsEh3cl9SxPkZg==
X-Received: by 2002:a62:ed0a:: with SMTP id u10mr621128pfh.243.1559178323036;
        Wed, 29 May 2019 18:05:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id c76sm861965pfc.43.2019.05.29.18.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 18:05:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 2/3] KVM: X86: Implement PV sched yield hypercall
Date:   Thu, 30 May 2019 09:05:06 +0800
Message-Id: <1559178307-6835-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
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

17% performance increasement of ebizzy benchmark can be observed in an 
over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush 
call-function IPI-many since call-function is not easy to be trigged 
by userspace workload).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7e57de..8575b36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7172,6 +7172,28 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 
+static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
+{
+	struct kvm_vcpu *target = NULL;
+	struct kvm_apic_map *map = NULL;
+
+	rcu_read_lock();
+	map = rcu_dereference(kvm->arch.apic_map);
+
+	if (unlikely(!map) || dest_id > map->max_apic_id)
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

