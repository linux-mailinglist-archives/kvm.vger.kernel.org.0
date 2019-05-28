Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D92C092
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfE1HvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:51:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36033 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbfE1HvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:51:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id u22so3659954pfm.3;
        Tue, 28 May 2019 00:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcCjT6H+ppzU8yxObmCoxmme1+yJ2Skn/UpNWVNXol4=;
        b=XY0HxMyg3d3xjt/T3hbdmJ9e+Yd85ljT2M6BbObRgNwhuAzKyh+J4/xZwPZoG8BAEA
         AeJLhF6tBBkEHEm1FZWWBJ4tRSg0uQRtYoqLltgWcDjuInf4N5y8jtJ4SUlmYCnG3Nlc
         CuU5OpcFM/EzYvK9Aq6XZT0WlsS9pis0QSFgC7ga4jVqOJ3fkqJyq/mFh1+vuW+BDscB
         xxJzjolO0pIxzh10FEI2XmUfTHBklzwI0xAyZTfN4cqiohIYIyXg94isQzZfoT9mY9Yg
         0Wzc4uSZlL2PWPzg9Yu9maMniEIFgUwcqcxyddJKeuZgEFMRjKH1h9AhBNaaUaBLGBmN
         8khA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcCjT6H+ppzU8yxObmCoxmme1+yJ2Skn/UpNWVNXol4=;
        b=txYcO4aQK0bRAHFS7di6TugHnpYaKRkb52mOBGWua8l3cAukVOQz+1FynvXQJDQuww
         NNE3m6RHnL+D1tyFr8yqcs7Yod3SK6qjRd+3elvO6FyccClH6zqZYijddatKs9zZIWRZ
         gjGHxRZa1a2WKVGSyIxnQETk1C7/+Laz1udgawkhq2ZtSr9B1Ur99RN7m4MNqOObmvEq
         v/dZ/ziuQFBJB6ju4/Y1AA6cs/WysnFfSCoSurLcKw+ZUgulcw2tusVOqbz6lC4Axv7U
         IxpHpoeuhw81j0Z+yd+3jUzKC8WrkukaUlSTkVsx5GwRIa1ur2bVh/dNdwMPVIkrBsfY
         fc3w==
X-Gm-Message-State: APjAAAWCJLfjSuMe0/1pQ6pCBYSQlW34egzxrIbSmtMrLYoDUlb42lQB
        9h/+DpvSzS/fQKDhkkvqijj8MeQi
X-Google-Smtp-Source: APXvYqzCI5UwtJPB62OKAfQrkw4+Gy5neK//ERcEeBfdhJn4r0dlhxT9mven2MVqpojMBhFxlpTVbA==
X-Received: by 2002:a63:e50c:: with SMTP id r12mr116030865pgh.284.1559029873373;
        Tue, 28 May 2019 00:51:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id q20sm18201400pgq.66.2019.05.28.00.51.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:51:12 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 2/3] KVM: X86: Implement PV sched yield hypercall
Date:   Tue, 28 May 2019 15:50:56 +0800
Message-Id: <1559029857-2750-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559029857-2750-1-git-send-email-wanpengli@tencent.com>
References: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
 <1559029857-2750-1-git-send-email-wanpengli@tencent.com>
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

