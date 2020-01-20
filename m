Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA618142BC3
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgATNIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 08:08:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31128 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbgATNIa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 08:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b6DMbPH+ad8np/5lLxTXgCNi4TM1mHo6rbFScT/ddvI=;
        b=EWgc6agGin2T3f6wD0ua68RoM36xiJY4fJq2GfNfA/GgbIHMUGQnPoAuE4db+U1j0tJQat
        G/aCnVLzF7p3iIi7qxEO5MBDbbWQ73DDm2F5IB+8sXHDQRfx5KKSuMB2dVhZU0swvW4iqC
        4CcnLnUYWzuRM808OP249jzRJl5z5EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-LJvWDoqpPTOWOevsIS2Ryw-1; Mon, 20 Jan 2020 08:08:28 -0500
X-MC-Unique: LJvWDoqpPTOWOevsIS2Ryw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1161A0CC7;
        Mon, 20 Jan 2020 13:08:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91C4560BF7;
        Mon, 20 Jan 2020 13:08:26 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64: KVM: Add XXX UAPI notes for swapped registers
Date:   Mon, 20 Jan 2020 14:08:25 +0100
Message-Id: <20200120130825.28838-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two UAPI system register IDs do not derive their values from the
ARM system register encodings. This is because their values were
accidentally swapped. As the IDs are API, they cannot be changed.
Add XXX notes to point them out.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.txt    |  8 ++++++++
 arch/arm64/include/uapi/asm/kvm.h | 11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.=
txt
index ebb37b34dcfc..11556fc457c3 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -2196,6 +2196,14 @@ arm64 CCSIDR registers are demultiplexed by CSSELR=
 value:
 arm64 system registers have the following id bit patterns:
   0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
=20
+XXX: Two system register IDs do not follow the specified pattern.  These
+     are KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT, which map to
+     system registers CNTV_CVAL_EL0 and CNTVCT_EL0 respectively.  These
+     two had their values accidentally swapped, which means TIMER_CVAL i=
s
+     derived from the register encoding for CNTVCT_EL0 and TIMER_CNT is
+     derived from the register encoding for CNTV_CVAL_EL0.  As this is
+     API, it must remain this way.
+
 arm64 firmware pseudo-registers have the following bit pattern:
   0x6030 0000 0014 <regno:16>
=20
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
index 820e5751ada7..c72387e48851 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -220,10 +220,17 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
 #define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
=20
-/* EL0 Virtual Timer Registers */
+/*
+ * EL0 Virtual Timer Registers
+ *
+ * XXX: KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT are not defined
+ *      with the appropriate register encodings.  Their values have been
+ *      accidentally swapped.  As this is set API, the definitions here
+ *      must be used, rather than ones derived from the encodings.
+ */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
+#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
=20
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
--=20
2.21.1

