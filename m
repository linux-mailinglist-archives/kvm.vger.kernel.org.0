Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B124C984CE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfHUTud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729608AbfHUTud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:50:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12DD6300183D;
        Wed, 21 Aug 2019 19:50:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D03FC17D69;
        Wed, 21 Aug 2019 19:50:31 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     maz@kernel.org, mark.rutland@arm.com
Subject: [PATCH] arm64: KVM: Only skip MMIO insn once
Date:   Wed, 21 Aug 2019 21:50:30 +0200
Message-Id: <20190821195030.2569-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 21 Aug 2019 19:50:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If after an MMIO exit to userspace a VCPU is immediately run with an
immediate_exit request, such as when a signal is delivered or an MMIO
emulation completion is needed, then the VCPU completes the MMIO
emulation and immediately returns to userspace. As the exit_reason
does not get changed from KVM_EXIT_MMIO in these cases we have to
be careful not to complete the MMIO emulation again, when the VCPU is
eventually run again, because the emulation does an instruction skip
(and doing too many skips would be a waste of guest code :-) We need
to use additional VCPU state to track if the emulation is complete.
As luck would have it, we already have 'mmio_needed', which even
appears to be used in this way by other architectures already.

Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 virt/kvm/arm/arm.c  | 3 ++-
 virt/kvm/arm/mmio.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 35a069815baf..322cf9030bbe 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -669,7 +669,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (ret)
 		return ret;
 
-	if (run->exit_reason == KVM_EXIT_MMIO) {
+	if (vcpu->mmio_needed) {
+		vcpu->mmio_needed = 0;
 		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
 		if (ret)
 			return ret;
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index a8a6a0c883f1..2d9b5e064ae0 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -201,6 +201,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (is_write)
 		memcpy(run->mmio.data, data_buf, len);
 	vcpu->stat.mmio_exit_user++;
+	vcpu->mmio_needed	= 1;
 	run->exit_reason	= KVM_EXIT_MMIO;
 	return 0;
 }
-- 
2.18.1

