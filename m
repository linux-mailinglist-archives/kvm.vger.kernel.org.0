Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B273CB1C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbfFKMYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:24:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46795 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388969AbfFKMYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:24:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so7326713pfy.13;
        Tue, 11 Jun 2019 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGX8ZE5HpPEM8W1A+XwV2MspPdA5BLlcqW7hwnjzPDE=;
        b=bF8RdgWyt+9d2epLHryzbj0tkgROcIvkGYmrBrdLRN79pcvcqY37JfpJ2yPxoAXF51
         14GP4T4+hsfzmtZenxi9nRf5wGYW3AbdcQodHfOs4Fr/0A6CDYXsWDxenABFwwhqnNNl
         v9RDab5wX4VMQlZHJCTtpkdN4fg65xnDcD9QeUT/ZeVxccf+Gs70X0mG1KXCKGPKoqhi
         epkBZYEPX3AHnKFD3iPWfKMV37psb+PiV0mDDuV1eiaEBxnNqh1QTduJ44zi3RtW2oQp
         hUhE7a0GuX2hpjDB99OoPrkrjcvgyAbgok0zslDPluKScVDjgGdRgdIU7UsL5hIYWpi9
         UAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGX8ZE5HpPEM8W1A+XwV2MspPdA5BLlcqW7hwnjzPDE=;
        b=eBrhqfDIo3pfHSutvTfi2KbAujy6vpGrntq0qW2Dpk4omBNQQ1rbmEhzRHnmo6lZ9x
         D8Db4oVa0YgYct/vNth5zrFAmj27cMGhm9Ujuc0bkOmM7/E+kIPkMa/Rs5i8LZLdZv7M
         NgTDZkUXYGoOhRHC5kTqo3op4AB3gy7lM2SiNY1Wt7UorjkeRII3hhPO+l2TfHQSZIDD
         ewJsNOCRJYuCmJ8IEaD07J26BXs7ZzoO6IVzzHfHVyiKJrXJqT/bJaFbRRgIwoRm3r+i
         Z9dFS652YxGvAuE89Bn83DlnXc/eccfKuQrg4SeStVAeH1Udj/Yup0fU4R+YuOtbYGH3
         CRdQ==
X-Gm-Message-State: APjAAAWc+AX6EznOhsCpmbD1ssQv/8wHNsB6sTJiRhlwq/nsd6tLS9LA
        yHkLbL5ubXn6RwVcTGCntCe32aBS
X-Google-Smtp-Source: APXvYqwTdZo6LzWhDaT78xZ1R7AU2rhrg0GhTSGylvLrBLcM8qPZeHoK6vpu2bdOS8lFNxcrONfxYg==
X-Received: by 2002:a63:2c50:: with SMTP id s77mr19852056pgs.175.1560255838924;
        Tue, 11 Jun 2019 05:23:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 127sm14832271pfc.159.2019.06.11.05.23.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:23:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 2/3] KVM: X86: Implement PV sched yield hypercall
Date:   Tue, 11 Jun 2019 20:23:49 +0800
Message-Id: <1560255830-8656-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/x86.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35c4884..6d49ea0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7160,6 +7160,23 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 
+static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
+{
+	struct kvm_vcpu *target = NULL;
+	struct kvm_apic_map *map;
+
+	rcu_read_lock();
+	map = rcu_dereference(kvm->arch.apic_map);
+
+	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
+		target = map->phys_map[dest_id]->vcpu;
+
+	rcu_read_unlock();
+
+	if (target)
+		kvm_vcpu_yield_to(target);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -7206,6 +7223,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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

