Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19729CD58
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgJ1BiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:18 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37354 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832971AbgJ0XLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:11:05 -0400
Received: by mail-pl1-f202.google.com with SMTP id 97so1755451plb.4
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QUFSJ8N3j5rCuH96XCqYU4E4BtH6cunGKFD8JyT6Wpo=;
        b=r/4IraGLuKexwiV4T8yVpqYQRieLnqGD7NDujIsr5sjIwW/pHJ4g8K9GZgIlxKUErl
         eQCCeSTpxSMaMTN99G3mhZD+0SQEWD88QV9wMU8BG1ilN6N0dsdhXlZuUe6lNukF/efA
         CEo0Ow+hxslt3ixHJBW8ZXLaEiPLkrd+FqUV7pqOBVoMT6lfE0i8FQ1fZlpvSMjVgbbX
         UfoN47N89RmfG1WTQW1NF1lYFK88/f2+SEej6qeSBAdTDqJZgRpi6GT1C3doyfM9kZNu
         btoiyts3N7bVspkxPpd2I8GoCHonKDhLX5NOmZPMVWiVkZMKp1oMHzePQHDNm+6ySGZU
         /35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QUFSJ8N3j5rCuH96XCqYU4E4BtH6cunGKFD8JyT6Wpo=;
        b=LqpSBGo2lu9D9hiE4n709s1nPuDpFlmHf0M6BIhYjOGcJEYjffAS6QCz2NLZFkxysI
         cutaEk+tNbHwL6mXJJKkMbFBoGzII1BfWigBiZMTHZ8tP0NBfwf7V1S3NGya9c6ntvSF
         hwfHbxuI1glBb2h5tboqXzRUnql4ZEgs3g2r0zROf1pKBR1w0t86lGi1WnX/E60n5ETe
         6liurtM6pl06Wbty+QbK1ZXpIa/ZJEQt8Gtb51LOPDId5eFXRyXcSolO1JT0iyVtIVo6
         o+PG2LaBIyogydXOllTgoYUVNBkHDTFAItH4tqu9ea3ckK2/g8oiPAAVXYNvzqDFLXPN
         mkVw==
X-Gm-Message-State: AOAM5301Q8/fvaVi8HVnEoZw6Ol0ZepYGcDzHxW3azTtSRIdG6z6INjX
        BiZw4shjhSXmKyhJLuEdRsG4DUwAToyHwPGxndG6lybBk+6DUu5o+0H18Oyl5cOrR89H7iMAaUD
        FqMs3GyLsnChIpkUyzKotdZppLLy/Bzz20PWqiPBp5INC8Va2BwbL8+ILgw==
X-Google-Smtp-Source: ABdhPJwffLlyv05UedwKlZLHNONqYMiSeTcznfUkw8uc84K1VTBGdcmxkXiCkQ0cUMckYZpeI52ooYLBNEw=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a62:6101:0:b029:163:afcb:9b94 with SMTP id
 v1-20020a6261010000b0290163afcb9b94mr4668165pfb.45.1603840263053; Tue, 27 Oct
 2020 16:11:03 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:41 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-4-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 3/6] kvm: x86: reads of restricted pv msrs should also result
 in #GP
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 66570e966dd9 ("kvm: x86: only provide PV features if enabled in
guest's CPUID") only protects against disallowed guest writes to KVM
paravirtual msrs, leaving msr reads unchecked. Fix this by enforcing
KVM_CPUID_FEATURES for msr reads as well.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/x86.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..4016c07c8920 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3463,29 +3463,63 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.efer;
 		break;
 	case MSR_KVM_WALL_CLOCK:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
+			return 1;
+
+		msr_info->data = vcpu->kvm->arch.wall_clock;
+		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
+			return 1;
+
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
+			return 1;
+
+		msr_info->data = vcpu->arch.time;
+		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
+			return 1;
+
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+			return 1;
+
 		msr_info->data = vcpu->arch.apf.msr_en_val;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
+			return 1;
+
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+			return 1;
+
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
+			return 1;
+
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
 	case MSR_KVM_PV_EOI_EN:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
+			return 1;
+
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
 	case MSR_KVM_POLL_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
+			return 1;
+
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
 	case MSR_IA32_P5_MC_ADDR:
-- 
2.29.0.rc2.309.g374f81d7ae-goog

