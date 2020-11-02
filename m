Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483862A3389
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgKBTDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:03:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbgKBTDT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 14:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604343797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DZ9FLP/h7oQU/WTir0mNtH8qW5ViOpp522zv7JM/0s=;
        b=WL+90QZb+dsic5YWHtPpAFdeyAbEpJG8+7WPkZzZo/Di12BGIRmYJoisKULQnM/9eRAfYn
        BMfXvpylbSB/csC7JzdTaENqLnMFSEMKLvyMwhtYGaiQqG0aGzWfafPth4lOS/p10s5S0Z
        Pkgl3U7wLI6Wg4UVqwk++XIzAG2V+K8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520--mxUgGWuPZGmod8LDqJk-g-1; Mon, 02 Nov 2020 14:03:16 -0500
X-MC-Unique: -mxUgGWuPZGmod8LDqJk-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EF261099F67;
        Mon,  2 Nov 2020 19:03:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D88F5B4A1;
        Mon,  2 Nov 2020 19:03:12 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH v2 2/3] KVM: selftests: Update aarch64 get-reg-list blessed list
Date:   Mon,  2 Nov 2020 20:02:52 +0100
Message-Id: <20201102190253.50575-3-drjones@redhat.com>
In-Reply-To: <20201102190253.50575-1-drjones@redhat.com>
References: <20201102190253.50575-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
enumerating it for save/restore was the plan. It's a good idea anyway,
since the other PMU registers have been enumerated since v4.10.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 6fae4c3cb0c6..db97001f37f7 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -352,7 +352,10 @@ int main(int ac, char **av)
 }
 
 /*
- * The current blessed list comes from kernel version v4.15 with --core-reg-fixup
+ * The current blessed list was primed with the output of kernel version
+ * v4.15 with --core-reg-fixup and then later updated with new registers.
+ *
+ * The blessed list is up to date with kernel version v5.10-rc2
  */
 static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -430,6 +433,9 @@ static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpsr),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpcr),
+	KVM_REG_ARM_FW_REG(0),
+	KVM_REG_ARM_FW_REG(1),
+	KVM_REG_ARM_FW_REG(2),
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
@@ -578,10 +584,12 @@ static __u64 blessed_reg[] = {
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
2.26.2

