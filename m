Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3EE7F52E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 12:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHBKhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 06:37:48 -0400
Received: from foss.arm.com ([217.140.110.172]:49404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfHBKhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 06:37:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2618B1596;
        Fri,  2 Aug 2019 03:37:48 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C51263F71F;
        Fri,  2 Aug 2019 03:37:46 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Tangnianyao <tangnianyao@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] KVM: Call kvm_arch_vcpu_blocking early into the blocking sequence
Date:   Fri,  2 Aug 2019 11:37:09 +0100
Message-Id: <20190802103709.70148-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802103709.70148-1-maz@kernel.org>
References: <20190802103709.70148-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vpcu is about to block by calling kvm_vcpu_block, we call
back into the arch code to allow any form of synchronization that
may be required at this point (SVN stops the AVIC, ARM synchronises
the VMCR and enables GICv4 doorbells). But this synchronization
comes in quite late, as we've potentially waited for halt_poll_ns
to expire.

Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
kvm_vcpu_block(), which on ARM has several benefits:

- VMCR gets synchronised early, meaning that any interrupt delivered
  during the polling window will be evaluated with the correct guest
  PMR
- GICv4 doorbells are enabled, which means that any guest interrupt
  directly injected during that window will be immediately recognised

Tang Nianyao ran some tests on a GICv4 machine to evaluate such
change, and reported up to a 10% improvement for netperf:

<quote>
	netperf result:
	D06 as server, intel 8180 server as client
	with change:
	package 512 bytes - 5500 Mbits/s
	package 64 bytes - 760 Mbits/s
	without change:
	package 512 bytes - 5000 Mbits/s
	package 64 bytes - 710 Mbits/s
</quote>

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 887f3b0c2b60..90d429c703cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2322,6 +2322,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
+	kvm_arch_vcpu_blocking(vcpu);
+
 	start = cur = ktime_get();
 	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -2342,8 +2344,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	for (;;) {
 		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
@@ -2356,9 +2356,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	finish_swait(&vcpu->wq, &wait);
 	cur = ktime_get();
-
-	kvm_arch_vcpu_unblocking(vcpu);
 out:
+	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	if (!vcpu_valid_wakeup(vcpu))
-- 
2.20.1

