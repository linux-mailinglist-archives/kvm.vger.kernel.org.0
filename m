Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028DD4092F1
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbhIMOQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344691AbhIMOLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTyPgTLP4SOCmGfhVH8PJu5ibgccQKaoWGuatJCMp3M=;
        b=QnEqoxJIbupDU6HovTRzJVsA7ieszerzrNnqb78W1Q2V0dS4/qQluEEhK4iEeuj0qX3auy
        5tWVdvrBAQgSXFJp1uZAQEwUbmvXkePaHYTYdFhpyrgaAN78o9JUS/FMBz39iXo1F/Gdf8
        j7JgP7yzYGJRTV+LBAVirCaHqwPAdI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-J4APTnFeOwW3_UvPX0oJSw-1; Mon, 13 Sep 2021 10:10:28 -0400
X-MC-Unique: J4APTnFeOwW3_UvPX0oJSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62A738010F4;
        Mon, 13 Sep 2021 14:10:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BE5619724;
        Mon, 13 Sep 2021 14:10:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 6/7] KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry
Date:   Mon, 13 Sep 2021 17:09:53 +0300
Message-Id: <20210913140954.165665-7-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible that when non root mode is entered via special entry
(!from_vmentry), that is from SMM or from loading the nested state,
the L2 state could be invalid in regard to non unrestricted guest mode,
but later it can become valid.

(for example when RSM emulation restores segment registers from SMRAM)

Thus delay the check to VM entry, where we will check this and fail.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++++-
 arch/x86/kvm/vmx/vmx.c    | 5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..1a05ae83dae5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2546,8 +2546,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * Guest state is invalid and unrestricted guest is disabled,
 	 * which means L1 attempted VMEntry to L2 with invalid state.
 	 * Fail the VMEntry.
+	 *
+	 * However when force loading the guest state (SMM exit or
+	 * loading nested state after migration, it is possible to
+	 * have invalid guest state now, which will be later fixed by
+	 * restoring L2 register state
 	 */
-	if (CC(!vmx_guest_state_valid(vcpu))) {
+	if (CC(from_vmentry && !vmx_guest_state_valid(vcpu))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57609dda1bbc..c3b3c406f4f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6624,7 +6624,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * consistency check VM-Exit due to invalid guest state and bail.
 	 */
 	if (unlikely(vmx->emulation_required)) {
-		vmx->fail = 0;
+
+		/* We don't emulate invalid state of a nested guest */
+		vmx->fail = is_guest_mode(vcpu);
+
 		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
 		vmx->exit_reason.failed_vmentry = 1;
 		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
-- 
2.26.3

