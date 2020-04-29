Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714831BD864
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD2JhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:37:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55155 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgD2JhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 05:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zk4COgdMLxZOUPDMABW5oK8rzzY1FgBfPJgdCdDp2KQ=;
        b=UylngXXD3pRgYza9deOQtViYkuZ2hpYVUw5sMk7xuRhzjKIMPKmkSpq68sRkQwbZ+mh27I
        jmigFCsok+a8I7/rbLW4Xp+oSajsgDdwc5t79iOn2JX7C3IU5+cGDbfNS1sFq2cIK9KYLn
        HM1AZ7qOO8rJjTWAsDkcFL4kCW3KQ70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-lHZmN1oBMcCi2YVDRiM7jw-1; Wed, 29 Apr 2020 05:36:55 -0400
X-MC-Unique: lHZmN1oBMcCi2YVDRiM7jw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C74A1800D4A;
        Wed, 29 Apr 2020 09:36:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA2F65D9C9;
        Wed, 29 Apr 2020 09:36:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf page ready notifications
Date:   Wed, 29 Apr 2020 11:36:32 +0200
Message-Id: <20200429093634.1514902-5-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If two page ready notifications happen back to back the second one is not
delivered and the only mechanism we currently have is
kvm_check_async_pf_completion() check in vcpu_run() loop. The check will
only be performed with the next vmexit when it happens and in some cases
it may take a while. With interrupt based page ready notification deliver=
y
the situation is even worse: unlike exceptions, interrupts are not handle=
d
immediately so we must check if the slot is empty. This is slow and
unnecessary. Introduce dedicated MSR_KVM_ASYNC_PF_ACK MSR to communicate
the fact that the slot is free and host should check its notification
queue. Mandate using it for interrupt based type 2 APF event delivery.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 16 +++++++++++++++-
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/x86.c                   |  9 ++++++++-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.=
rst
index 7433e55f7184..18db3448db06 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -219,6 +219,11 @@ data:
 	If during pagefault APF reason is 0 it means that this is regular
 	page fault.
=20
+	For interrupt based delivery, guest has to write '1' to
+	MSR_KVM_ASYNC_PF_ACK every time it clears reason in the shared
+	'struct kvm_vcpu_pv_apf_data', this forces KVM to re-scan its
+	queue and deliver next pending notification.
+
 	During delivery of type 1 APF cr2 contains a token that will
 	be used to notify a guest when missing page becomes
 	available. When page becomes available type 2 APF is sent with
@@ -340,4 +345,13 @@ data:
=20
 	To switch to interrupt based delivery of type 2 APF events guests
 	are supposed to enable asynchronous page faults and set bit 3 in
-	MSR_KVM_ASYNC_PF_EN first.
+
+MSR_KVM_ASYNC_PF_ACK:
+	0x4b564d07
+
+data:
+	Asynchronous page fault acknowledgment. When the guest is done
+	processing type 2 APF event and 'reason' field in 'struct
+	kvm_vcpu_pv_apf_data' is cleared it is supposed to write '1' to
+	Bit 0 of the MSR, this caused the host to re-scan its queue and
+	check if there are more notifications pending.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index 1bbb0b7e062f..5c7449980619 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -51,6 +51,7 @@
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF2	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
=20
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 861dce1e7cf5..e3b91ac33bfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] =3D {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
=20
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2, MSR_KVM_ASYNC_PF_ACK,
=20
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2915,6 +2915,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
 		if (kvm_pv_enable_async_pf2(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_ASYNC_PF_ACK:
+		if (data & 0x1)
+			kvm_check_async_pf_completion(vcpu);
+		break;
 	case MSR_KVM_STEAL_TIME:
=20
 		if (unlikely(!sched_info_on()))
@@ -3194,6 +3198,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 	case MSR_KVM_ASYNC_PF2:
 		msr_info->data =3D vcpu->arch.apf.msr2_val;
 		break;
+	case MSR_KVM_ASYNC_PF_ACK:
+		msr_info->data =3D 0;
+		break;
 	case MSR_KVM_STEAL_TIME:
 		msr_info->data =3D vcpu->arch.st.msr_val;
 		break;
--=20
2.25.3

