Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3193088AC
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 12:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhA2L5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 06:57:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232349AbhA2L42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 06:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611921001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cMS/7pknUs0YwtKE5mir0RQEvSlJ4gZuoZK/GL0Bh2Y=;
        b=V+Np74pZDHBoxkmgbxmuV5QR72nl7GYRg1cmm1E6F80+/vlw9SAxt4axUwlmR6YcUSy2Th
        882wWKdPVpIlxmFqNRgN0hksybcJSqaPokw4oXjKHkNZ4d9330R317eXQTEprVMF3dc1sr
        aVzMJloSOHcCwj07URmM//MbxvF/pJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351--eV7d5yzP3q2OGNv-XIFLQ-1; Fri, 29 Jan 2021 05:19:15 -0500
X-MC-Unique: -eV7d5yzP3q2OGNv-XIFLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECCB418C8C01;
        Fri, 29 Jan 2021 10:19:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7317B60C04;
        Fri, 29 Jan 2021 10:19:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off
Date:   Fri, 29 Jan 2021 05:19:12 -0500
Message-Id: <20210129101912.1857809-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace that does not know about KVM_GET_MSR_FEATURE_INDEX_LIST
will generally use the default value for MSR_IA32_ARCH_CAPABILITIES.
When this happens and the host has tsx=on, it is possible to end up with
virtual machines that have HLE and RTM disabled, but TSX_CTRL available.

If the fleet is then switched to tsx=off, kvm_get_arch_capabilities()
will clear the ARCH_CAP_TSX_CTRL_MSR bit and it will not be possible to
use the tsx=off hosts as migration destinations, even though the guests
do not have TSX enabled.

To allow this migration, allow guests to write to their TSX_CTRL MSR,
while keeping the host MSR unchanged for the entire life of the guests.
This ensures that TSX remains disabled and also saves MSR reads and
writes, and it's okay to do because with tsx=off we know that guests will
not have the HLE and RTM features in their CPUID.  (If userspace sets
bogus CPUID data, we do not expect HLE and RTM to work in guests anyway).

Cc: stable@vger.kernel.org
Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 arch/x86/kvm/x86.c     |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc60b1fc3ee7..eb69fef57485 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6860,11 +6860,20 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
 			/*
-			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
-			 * let's avoid changing CPUID bits under the host
-			 * kernel's feet.
+			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
+			 * interception.  Keep the host value unchanged to avoid
+			 * changing CPUID bits under the host kernel's feet.
+			 *
+			 * hle=0, rtm=0, tsx_ctrl=1 can be found with some
+			 * combinations of new kernel and old userspace.  If
+			 * those guests run on a tsx=off host, do allow guests
+			 * to use TSX_CTRL, but do not change the value on the
+			 * host so that TSX remains always disabled.
 			 */
-			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			if (boot_cpu_has(X86_FEATURE_RTM))
+				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			else
+				vmx->guest_uret_msrs[j].mask = 0;
 			break;
 		default:
 			vmx->guest_uret_msrs[j].mask = -1ull;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76bce832cade..15733013b266 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1401,7 +1401,7 @@ static u64 kvm_get_arch_capabilities(void)
 	 *	  This lets the guest use VERW to clear CPU buffers.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_RTM))
-		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
+		data &= ~ARCH_CAP_TAA_NO;
 	else if (!boot_cpu_has_bug(X86_BUG_TAA))
 		data |= ARCH_CAP_TAA_NO;
 
-- 
2.26.2

