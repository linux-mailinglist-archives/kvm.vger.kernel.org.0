Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8811429F5FE
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgJ2URY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:17:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgJ2URX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 16:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604002641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMbp27fIPuxy3uweVR9wQJqDnMTsXgFw95Czo3djPPg=;
        b=EWTQucjFgzzOyZyrdENDMIFmx8kmxhZ02VSTlQX8eqed9V1GIIEw9ZUL0kQ1WzbpjOpybt
        nHTDSi7D8nez+c9EhSnrlBb3eC8JRR/gsDvwb90oXTrbanfTZazdcaUxyIl/RVawY+ZrBt
        FlJcdMOSwLdnXtd7HJhKWbu3x62eRZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-ewla7D6KN7aDjIoNqNKpAQ-1; Thu, 29 Oct 2020 16:17:19 -0400
X-MC-Unique: ewla7D6KN7aDjIoNqNKpAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BEC58015F8;
        Thu, 29 Oct 2020 20:17:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE4A60DA0;
        Thu, 29 Oct 2020 20:17:15 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH 3/4] KVM: selftests: Update aarch64 get-reg-list blessed list
Date:   Thu, 29 Oct 2020 21:17:02 +0100
Message-Id: <20201029201703.102716-4-drjones@redhat.com>
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new registers come from the following commits:

commit 99adb567632b ("KVM: arm/arm64: Add save/restore support for
firmware workaround state")

commit c773ae2b3476 ("KVM: arm64: Save/Restore guest DISR_EL1")

commit 03fdfb269009 ("KVM: arm64: Don't write junk to sysregs on reset")

The last commit, which adds ARM64_SYS_REG(3, 3, 9, 12, 0) (PMCR_EL0),
and was committed for v5.3, doesn't indicate in its commit message that
enumerating it for save/restore was the plan, so doing so may have
been by accident. It's a good idea anyway, though, since the other PMU
registers have been enumerated since v4.10.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 3aeb3de780a1..3ff097f6886e 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -352,7 +352,8 @@ int main(int ac, char **av)
 }
 
 /*
- * The current blessed list comes from kernel version v4.15 with --core-reg-fixup
+ * The current blessed list was primed with the output of kernel version
+ * v4.15 with --core-reg-fixup and then later updated with new registers.
  */
 static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -430,6 +431,9 @@ static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpsr),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpcr),
+	KVM_REG_ARM_FW_REG(0),
+	KVM_REG_ARM_FW_REG(1),
+	KVM_REG_ARM_FW_REG(2),
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
@@ -578,10 +582,12 @@ static __u64 blessed_reg[] = {
 	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
+	ARM64_SYS_REG(3, 0, 12, 1, 1),	/* DISR_EL1 */
 	ARM64_SYS_REG(3, 0, 13, 0, 1),	/* CONTEXTIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 3),	/* PMOVSCLR_EL0 */
-- 
2.27.0

