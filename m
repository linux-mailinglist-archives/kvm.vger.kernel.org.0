Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975BD48EF45
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 18:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbiANReT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiANReS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 12:34:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80330C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:34:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so22826007pjf.3
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tlKPtWrMnNhQ2zUBMOVAbMivXCD/K2BWvR3jQNPgLzU=;
        b=XX3A9YU5P9pPfPub0Or+FHT3A4oAky7zr4urlHgkYLnqB8z7/2b/EqK5iiG4E0wOeq
         N8Gx2uQyyhrP09NCe/+hw0TLcUD++Kg4nWrW+cQTtwy5GQZHnIykaefKz2QN4YnF3knv
         eb473RVPUHUxe7QZUu/8Wy2g4lEYhCJ6z1y7fza6hsRUk/wBlDEBYocvGe6w9Iz4K1Oz
         VFfDevOC91HFlntLAk4esr1Krz0O6G3MMuzjAvVK8cZJ8O12aoVYTc3J/DhFB7iMyUuH
         5VzZJ9pY6RXLejBX1fkmWlWGaoT9owo0Sq1xp2NtTmd4sbA0N3e37MZ954j0He81pN90
         V6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tlKPtWrMnNhQ2zUBMOVAbMivXCD/K2BWvR3jQNPgLzU=;
        b=vmGrqvHNQZmgkood+jaPRtzy8XBPvU5DE5xjBOTYsPLeDkVW70nmA9LrW6GetiegC0
         siQCktzLynA1y7AUUnLdBNj5LU2dn7ihvUyTEPlN9A6y0CbsAzTKOMKOfcBtNgWIHKYr
         JWyiFmDA9ybhapMjdYIGen68ysDdc4FRWiq3C93Ht8K9bmzrQJ133X3s7mAExyUD0NFA
         X+BgTrYVnj9N8VUW5Hstbxsz4LNkP3mJWjzAaBs5EYhu1rv1JSF3kOfkYZgxTBCvt5qh
         G/68Lo4ZMy8cm+ebnaYPvmMtIK9cpbHGTWEW6S0jG0tFlclXkNkt393Ep+PHb5dbwDS+
         1qlQ==
X-Gm-Message-State: AOAM53197JTbH+dg8jN/KVQYD3lLHKyEIfx4vvunhJ0HUgmGEKCEbepU
        fTzALNulRYior7plO1POrJDvmA==
X-Google-Smtp-Source: ABdhPJz1nB+cPSjOOz5jtCNG/Q3eF2z8Mhc+k8GHztrKxvqDTpfgl1RSQPKNxFC16oai0HPPZj9WSw==
X-Received: by 2002:a17:90a:e018:: with SMTP id u24mr11720844pjy.95.1642181657872;
        Fri, 14 Jan 2022 09:34:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o3sm5560840pjr.2.2022.01.14.09.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 09:34:17 -0800 (PST)
Date:   Fri, 14 Jan 2022 17:34:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
Message-ID: <YeG0Fdn/2++phMWs@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-6-guang.zeng@intel.com>
 <YeCZpo+qCkvx5l5m@google.com>
 <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Zeng Guang wrote:
> kvm_lapic_reg_read() is limited to read up to 4 bytes. It needs extension to
> support 64bit read.

Ah, right.

> And another concern is here getting reg value only specific from vICR(no
> other regs need take care), going through whole path on kvm_lapic_reg_read()
> could be time-consuming unnecessarily. Is it proper that calling
> kvm_lapic_get_reg64() to retrieve vICR value directly?

Hmm, no, I don't think that's proper.  Retrieving a 64-bit value really is unique
to vICR.  Yes, the code does WARN on that, but if future architectural extensions
even generate APIC-write exits on other registers, then using kvm_lapic_get_reg64()
would be wrong and this code would need to be updated again.

What about tweaking my prep patch from before to the below?  That would yield:

	if (apic_x2apic_mode(apic)) {
		if (WARN_ON_ONCE(offset != APIC_ICR))
			return 1;

		kvm_lapic_msr_read(apic, offset, &val);
		kvm_lapic_msr_write(apic, offset, val);
	} else {
		kvm_lapic_reg_read(apic, offset, 4, &val);
		kvm_lapic_reg_write(apic, offset, val);
	}

I like that the above has "msr" in the low level x2apic helpers, and it maximizes
code reuse.  Compile tested only...

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Jan 2022 09:29:34 -0800
Subject: [PATCH] KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes

Add helpers to handle 64-bit APIC read/writes via MSRs to deduplicate the
x2APIC and Hyper-V code needed to service reads/writes to ICR.  Future
support for IPI virtualization will add yet another path where KVM must
handle 64-bit APIC MSR reads/write (to ICR).

Opportunistically fix the comment in the write path; ICR2 holds the
destination (if there's no shorthand), not the vector.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 59 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc35deff..cc4531eb448f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2787,6 +2787,30 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 	return 0;
 }

+static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
+{
+	u32 low, high = 0;
+
+	if (kvm_lapic_reg_read(apic, reg, 4, &low))
+		return 1;
+
+	if (reg == APIC_ICR &&
+	    WARN_ON_ONCE(kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high)))
+		return 1;
+
+	*data = (((u64)high) << 32) | low;
+
+	return 0;
+}
+
+static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
+{
+	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
+	if (reg == APIC_ICR)
+		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	return kvm_lapic_reg_write(apic, reg, (u32)data);
+}
+
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2798,16 +2822,13 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (reg == APIC_ICR2)
 		return 1;

-	/* if this is ICR write vector before command */
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return kvm_lapic_reg_write(apic, reg, (u32)data);
+	return kvm_lapic_msr_write(apic, reg, data);
 }

 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = (msr - APIC_BASE_MSR) << 4, low, high = 0;
+	u32 reg = (msr - APIC_BASE_MSR) << 4;

 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
 		return 1;
@@ -2815,45 +2836,23 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	if (reg == APIC_DFR || reg == APIC_ICR2)
 		return 1;

-	if (kvm_lapic_reg_read(apic, reg, 4, &low))
-		return 1;
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
-
-	*data = (((u64)high) << 32) | low;
-
-	return 0;
+	return kvm_lapic_msr_read(apic, reg, data);
 }

 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
 	if (!lapic_in_kernel(vcpu))
 		return 1;

-	/* if this is ICR write vector before command */
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return kvm_lapic_reg_write(apic, reg, (u32)data);
+	return kvm_lapic_msr_write(vcpu->arch.apic, reg, data);
 }

 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 low, high = 0;
-
 	if (!lapic_in_kernel(vcpu))
 		return 1;

-	if (kvm_lapic_reg_read(apic, reg, 4, &low))
-		return 1;
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
-
-	*data = (((u64)high) << 32) | low;
-
-	return 0;
+	return kvm_lapic_msr_read(vcpu->arch.apic, reg, data);
 }

 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
--
