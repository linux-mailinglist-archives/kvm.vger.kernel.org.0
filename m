Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607572BD24
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 04:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfE1CQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 22:16:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35317 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfE1CQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 22:16:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id t1so9979654pgc.2;
        Mon, 27 May 2019 19:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ZDBl1BXJV4gRCiUXkGA71uLQKwoJlajjwqJkajUw+4=;
        b=UhuemyhGRRjpvjo5qVobP06kmI59kx+xyITzbazqCStpqZ97FJYVn8OTECed0kbTDB
         Kdwn02w1ZFAgYBYqhaJed3Bbdb79C1flxTAvxTnpLfQvnY4qChYZYEukAZYTl/WFu0XN
         MdiHX14Omw5l1lOKKJGr54Q+t2oLZlJuVm+pv76MeVgjT9OyBdwGBBkArl8dvr/rFg+S
         ztYiwoSaZm+WGfMhznmTRNdS3Z5lTr5dAuHhygrMqPpNY/iVLMNASMRkTMaEADuG5GsC
         mNII9V/PlJW1XlcQBREfPOw6Hkm7NQFc5M98s/jspk8zldav+ELzQEJzbCN2Wg9FbeA9
         /9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ZDBl1BXJV4gRCiUXkGA71uLQKwoJlajjwqJkajUw+4=;
        b=rOzg3mR8HMWTpA/bgsFQUsowfBO0E3RgfWwQiOGOzZgs7s19VVIR1YkxnrTqFFL5vy
         aEzMF71m1gPJAzhpZxEH8r8FFoUws+o+GV3JdTld1p+a4y+eJwU+eoAb6rxOECs+fEIa
         LgKO/kOD4zu7SyZ/Nr/Aiok31kV4Ei58/9uIQGn9Sl/GvWH039hip1s68aybdkqXJ6Jd
         XNSN6szKvNyLR9GPqGVLPpWWslggCJ5SoI0nkx8NEp64/m+ZTENpFr7emRCVZiLYqtKM
         dAkQaTFdPJ89Mtk1v2V5FxWQ+BFPKF1I8f1vZARjiPi2F9SFemdlzzJqScpImXHYZ4eR
         QoDA==
X-Gm-Message-State: APjAAAVAEShS5/2UMxyL4Jm6ZMdxbRXwCzE+OVurX4ddhU6SHmABXay0
        04719IXTvrcBehEe92Px/vcjZYzN
X-Google-Smtp-Source: APXvYqyZGwJxos1Cv1mf9pb4RExFP7Gu1enbMh3+ke3oKkyto5myX+hvjI6a7SDcbuslxz3SfhVkUg==
X-Received: by 2002:a17:90a:1ac5:: with SMTP id p63mr2316194pjp.8.1559009759712;
        Mon, 27 May 2019 19:15:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z11sm16816991pfg.187.2019.05.27.19.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 19:15:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2] KVM: X86: Implement PV sched yield hypercall
Date:   Tue, 28 May 2019 10:15:52 +0800
Message-Id: <1559009752-8536-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
References: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
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
index e7e57de..2f9ec08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7172,6 +7172,28 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 
+void kvm_sched_yield(struct kvm *kvm, u64 dest_id)
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

