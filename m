Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE926D9DE
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 13:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgIQLIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 07:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbgIQLH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 07:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600340858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jPa4Eca2QJFB9z/ho9ZCcjVgGtPPG1+kl3a+IvmFXI=;
        b=fPwK+M3z16gEQ24nJxtTsh2kU9gl8Oj/Ok8N6HMxOpPkqPpEGBpePA/kmRowrRIPgacKPJ
        +e4VLaThKoznD/0eEU6Vic4lSw/xjPG8UPThplBGJjk6l2xFhxgdLQLPaZhOVhAtnH+pU8
        TcxFaHq7XoWglv0fiP6EjobfpNRJnFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-eyXnH01vO8ug49cAiWT_Bw-1; Thu, 17 Sep 2020 07:07:35 -0400
X-MC-Unique: eyXnH01vO8ug49cAiWT_Bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D08888EF01;
        Thu, 17 Sep 2020 11:07:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B233275142;
        Thu, 17 Sep 2020 11:07:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
Date:   Thu, 17 Sep 2020 14:07:23 +0300
Message-Id: <20200917110723.820666-2-mlevitsk@redhat.com>
In-Reply-To: <20200917110723.820666-1-mlevitsk@redhat.com>
References: <20200917110723.820666-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR reads/writes should always access the L1 state, since the (nested)
hypervisor should intercept all the msrs it wants to adjust, and these
that it doesn't should be read by the guest as if the host had read it.

However IA32_TSC is an exception.Even when not intercepted, guest still
reads the value + TSC offset.
The write however does not take any TSC offset in the account.

This is documented in Intel's PRM and seems also to happen on AMD as well.

This creates a problem when userspace wants to read the IA32_TSC value and then
write it. (e.g for migration)

In this case it reads L2 value but write is interpreted as an L1 value.
To fix this make the userspace initiated reads of IA32_TSC return L1 value
as well.

Huge thanks to Dave Gilbert for helping me understand this very confusing
semantic of MSR writes.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7e..d10d5c6add359 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2025,6 +2025,11 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
+static u64 kvm_read_l2_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
+{
+	return vcpu->arch.tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
+}
+
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
@@ -3220,7 +3225,19 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
 		break;
 	case MSR_IA32_TSC:
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
+		/*
+		 * Intel PRM states that MSR_IA32_TSC read adds the TSC offset
+		 * even when not intercepted. AMD manual doesn't define this
+		 * but appears to behave the same
+		 *
+		 * However when userspace wants to read this MSR, return its
+		 * real L1 value so that its restore will be correct
+		 *
+		 */
+		if (msr_info->host_initiated)
+			msr_info->data = kvm_read_l1_tsc(vcpu, rdtsc());
+		else
+			msr_info->data = kvm_read_l2_tsc(vcpu, rdtsc());
 		break;
 	case MSR_MTRRcap:
 	case 0x200 ... 0x2ff:
-- 
2.26.2

