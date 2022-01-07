Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17D3487C9C
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbiAGS41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232041AbiAGSzb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTky+Ff5k+SsgPAlcEGFVL3q/vgzgcpj3M9H7vE1YZA=;
        b=QEXPSJaKj/51V0WN5xELyyCe672OIPH0aOQo8V5U0/UxfzCfnbzf/Na9uH5VA9SeCv3WlY
        EV9Zvm6u5+T+FUZRpSlIIBMMqqRQNHetvPK2JoidL0ofPtGYoYR6npD6Jcr39c+WyIAD1W
        4nXBXZsD2Ehn8MJztIzWXrZgZDvCAWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-qXADCnr5OUW8e_ccQcvgmg-1; Fri, 07 Jan 2022 13:55:27 -0500
X-MC-Unique: qXADCnr5OUW8e_ccQcvgmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F9BF10168C0;
        Fri,  7 Jan 2022 18:55:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921A58CB2B;
        Fri,  7 Jan 2022 18:55:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 13/21] kvm: x86: Emulate IA32_XFD_ERR for guest
Date:   Fri,  7 Jan 2022 13:55:04 -0500
Message-Id: <20220107185512.25321-14-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Emulate read/write to IA32_XFD_ERR MSR.

Only the saved value in the guest_fpu container is touched in the
emulation handler. Actual MSR update is handled right before entering
the guest (with preemption disabled)

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-14-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb9534590a3a..2475b64cb762 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1377,7 +1377,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
-	MSR_IA32_XFD,
+	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -3699,6 +3699,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
 		break;
+	case MSR_IA32_XFD_ERR:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+			return 1;
+
+		if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
+			     vcpu->arch.guest_supported_xcr0))
+			return 1;
+
+		vcpu->arch.guest_fpu.xfd_err = data;
+		break;
 #endif
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
@@ -4028,6 +4039,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
 		break;
+	case MSR_IA32_XFD_ERR:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+			return 1;
+
+		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
+		break;
 #endif
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
@@ -6465,6 +6483,7 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_IA32_XFD:
+		case MSR_IA32_XFD_ERR:
 			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
 				continue;
 			break;
-- 
2.31.1


