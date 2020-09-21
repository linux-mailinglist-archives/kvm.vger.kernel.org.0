Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292DD272153
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgIUKiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 06:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgIUKiY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 06:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600684703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONnIZ3SBrEIJ/yZ6oWe7vybmIgHqvGfE9nXfpRPVygs=;
        b=Q+naJDf2MuWw2Gvrg1eIWWFUxonJN2IBiWR7iMlDS27nwwGJNLfFIe1XX5rTMD1DCGQN7u
        s8PO/tCiK4joCz/BSHeTHT82hPkbbaaiIbwArOG9rFXJKiPlO4f/PSJ6XcbmN9PgKL2ebA
        0zym/pcmd4FIG37yDbMaUiWOn8XNy40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-BHYcpO1oM6mJsLJ7ZyS9Pw-1; Mon, 21 Sep 2020 06:38:21 -0400
X-MC-Unique: BHYcpO1oM6mJsLJ7ZyS9Pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A94B21007461;
        Mon, 21 Sep 2020 10:38:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A99A46886C;
        Mon, 21 Sep 2020 10:38:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
Date:   Mon, 21 Sep 2020 13:38:05 +0300
Message-Id: <20200921103805.9102-2-mlevitsk@redhat.com>
In-Reply-To: <20200921103805.9102-1-mlevitsk@redhat.com>
References: <20200921103805.9102-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR reads/writes should always access the L1 state, since the (nested)
hypervisor should intercept all the msrs it wants to adjust, and these
that it doesn't should be read by the guest as if the host had read it.

However IA32_TSC is an exception. Even when not intercepted, guest still
reads the value + TSC offset.
The write however does not take any TSC offset into account.

This is documented in Intel's SDM and seems also to happen on AMD as well.

This creates a problem when userspace wants to read the IA32_TSC value and then
write it. (e.g for migration)

In this case it reads L2 value but write is interpreted as an L1 value.
To fix this make the userspace initiated reads of IA32_TSC return L1 value
as well.

Huge thanks to Dave Gilbert for helping me understand this very confusing
semantic of MSR writes.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7e..ed4314641360e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3219,9 +3219,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_POWER_CTL:
 		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
 		break;
-	case MSR_IA32_TSC:
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
+	case MSR_IA32_TSC: {
+		/*
+		 * Intel SDM states that MSR_IA32_TSC read adds the TSC offset
+		 * even when not intercepted. AMD manual doesn't explicitly
+		 * state this but appears to behave the same.
+		 *
+		 * However when userspace wants to read this MSR, we should
+		 * return it's real L1 value so that its restore will be correct.
+		 */
+		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
+							    vcpu->arch.tsc_offset;
+
+		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
 		break;
+	}
 	case MSR_MTRRcap:
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
-- 
2.26.2

