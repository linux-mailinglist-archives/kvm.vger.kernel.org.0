Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81708375272
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhEFKgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbhEFKgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:36:12 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688B9C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:35:14 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FbVMg3zCbzQk2X;
        Thu,  6 May 2021 12:35:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297308; bh=4JN931HSmCeaVYB
        IMRaW5B03THpkckpGfKdqRISlKWs=; b=VlQzD6Wyj+rGqGoVC2Ac6R11PMYTnhA
        HMU599hbnLdvU2zVMCUrWVyIZXCYlYmd6wa/Y1wMi48GHTiHdHn+283ZQuQ/IDEf
        S+AY8lA4iBjE0TCl0z+YVAm/j4Q4qSh2FofwbZQkzSgPDSPEn91xKvR9S2Ug2XBg
        V01TLfbQVdLrP8BWivUQzmeulKWIdyCjq9XCne3NZo2kh2CZeheV+vg6WYTn4YDN
        XxWP34rRU86Xwl7rlIWlFnlhMjsAyImHB+dOgJVcMQ//NS3i+4OYZiofQcl1hlH2
        /8w4TbLbv6wfmfk/RxqdQd5aOYL57L+rBZDipAOGXHw82JzwW5S5FJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=MmLU/QbDKCVGFbcSUQg7fOMYABSfInFk3O5ZwCNuN/0=;
        b=nWnHTLKG3FDeM9e7WNnSGaCCN9PzNNMYgtWhUAz1OStThocUbnLghyMDid57TTtYubDGIc
        NH9E91bnhg4LJzfS4OLz+mRld9+fE6TyUYRcml+84Sxj452ipClCeb1jy0wagqxwnHmTva
        R6TjTMQs6O7HZg7aglLd97LS6fmK3gUxfxMbbo4peJdPUKh5h0yKndU8wVuPzmJ1SdQ55i
        FjM6UlA7IqQuLdIV5aXbK9aecmgy48JNA0tOsBYmOSG6fahyu0aPC9Kpcocq7BJB6hgKWR
        MssGqAkGLD/rHYsahSspfeZHTZC1nF/L/cNddYdl6H7zQkyQeJlyrvZkDhryEw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id LK_S_nD90R4j; Thu,  6 May 2021 12:35:08 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 3/8] KVM: X86: Pass an additional 'L1' argument to kvm_scale_tsc()
Date:   Thu,  6 May 2021 10:32:23 +0000
Message-Id: <20210506103228.67864-4-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 7082A1857
X-Rspamd-UID: 6122ac
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

Sometimes kvm_scale_tsc() needs to use the current scaling ratio and
other times (like when reading the TSC from user space) it needs to use
L1's scaling ratio. Have the caller specify this by passing an
additional boolean argument.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/x86.c              | 21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 132e820525fb..cdddbf0b1177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1779,7 +1779,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 void kvm_define_user_return_msr(unsigned index, u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
+u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7bc5155ac6fd..26a4c0f46f15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2241,10 +2241,14 @@ static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 	return mul_u64_u64_shr(tsc, ratio, kvm_tsc_scaling_ratio_frac_bits);
 }
 
-u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
+/*
+ * If l1 is true the TSC is scaled using L1's scaling ratio, otherwise
+ * the current scaling ratio is used.
+ */
+u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1)
 {
 	u64 _tsc = tsc;
-	u64 ratio = vcpu->arch.tsc_scaling_ratio;
+	u64 ratio = l1 ? vcpu->arch.l1_tsc_scaling_ratio : vcpu->arch.tsc_scaling_ratio;
 
 	if (ratio != kvm_default_tsc_scaling_ratio)
 		_tsc = __scale_tsc(ratio, tsc);
@@ -2257,14 +2261,14 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
 	u64 tsc;
 
-	tsc = kvm_scale_tsc(vcpu, rdtsc());
+	tsc = kvm_scale_tsc(vcpu, rdtsc(), true);
 
 	return target_tsc - tsc;
 }
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
-	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
+	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc, true);
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
@@ -2395,9 +2399,9 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 
 static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
-	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
-	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
+	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment, true);
 	adjust_tsc_offset_guest(vcpu, adjustment);
 }
 
@@ -2780,7 +2784,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	/* With all the info we got, fill in the values */
 
 	if (kvm_has_tsc_control)
-		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz);
+		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz, true);
 
 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
@@ -3474,7 +3478,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
 							    vcpu->arch.tsc_offset;
 
-		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
+		msr_info->data = kvm_scale_tsc(vcpu, rdtsc(),
+					       msr_info->host_initiated) + tsc_offset;
 		break;
 	}
 	case MSR_MTRRcap:
-- 
2.17.1

