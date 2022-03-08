Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6704D2494
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 00:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiCHXFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 18:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiCHXFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 18:05:04 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BC15EBDE
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 15:04:07 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q19so419324pgm.6
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 15:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w1SxKbRJ8WkX9WltRoD14k9Ob0xVI9Pf1gGrPgXvoiI=;
        b=EVgtw0P+ZA+mu2sZJnZGHuZB7XszskLKawEE3nAiNRP9dEGu7nI2QIrA5TVsfvVAGn
         v2Nrtcwox3fbKRkSXRPXnMZh7HlBOGXfl7QZWo3Az3DsJ/Wu5DocTWIrOK3tyKTA3tPr
         eoZCiTsg9CRb53IFehojTmdmxEuCDbWuul32W1Y0WClJB2Hp2gjAL12Qm0838c+GuVR7
         Bvzv2Sv0dBX9B0aYlYfj7DZXintbNPXxPW801RyfHxHv6fbt+BMdZc9lhNnvSAAXjJ32
         qEw1iU1r3Z8oirwGbptJgohfxu6CvjfIvLlv8XkS2s5KgDMtbBg4cBrHYpRWkmzeKJhp
         c0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w1SxKbRJ8WkX9WltRoD14k9Ob0xVI9Pf1gGrPgXvoiI=;
        b=5zdXSYr9iw3YNgp+AKHlfP6I2xrxasvQ9KAAZ2cA7afLi/U/DFJVA+UWTpVB/c4GuK
         uLAQAFvnVebvwMM0WcyC2YSIpunBnINB+7sjYm/TLMb8wVbRllNNlVbX5dKXqjQS+mtf
         c5iPeXmgEYFkI/HgauY8h1sXUS1lHDmHIRLAO+O/IlokDxFFTsQBamm6CkXiXMUpLDcY
         5977R0h97ZWUV4TZZ2fLEaYvXlNEe9qqkodfy9zaDrR4bGd5msTL3fv6/f6EhFB1yAz9
         OxQAfj5qjcGmf+sGRTaxpuKNVcvMMYhNpD1IMGa+8dd8ZpID/OGN4KPUVsMU8F98DsF9
         Mb/w==
X-Gm-Message-State: AOAM533TDwe2UAMrdYaq9dOyPNMLCOhI9igMvZMZOZnns1iqKwvkfbqc
        rzYAyX4v+6ds/R+DsDBneVMiOeqg0hkfFg==
X-Google-Smtp-Source: ABdhPJytZy0DNaiUVFrbFyiAkMa1BfgnsrX/YkRy+IAt7mzDpdiZQTFzYeLxz3AHzEUWRGM1Ahp1wA==
X-Received: by 2002:a63:1d4b:0:b0:37f:f10b:726f with SMTP id d11-20020a631d4b000000b0037ff10b726fmr15828871pgm.562.1646780646266;
        Tue, 08 Mar 2022 15:04:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm154336pgn.72.2022.03.08.15.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 15:04:05 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:04:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <Yifg4bea6zYEz1BK@google.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-7-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225082223.18288-7-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022, Zeng Guang wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> No normal guest has any reason to change physical APIC IDs,

I don't think we can reasonably assume this, my analysis in the link (that I just
realized I deleted from context here) shows it's at least plausible that an existing
guest could rely on the APIC ID being writable.  And that's just one kernel, who
know what else is out there, especially given that people use KVM to emulate really
old stuff, often on really old hardware.

Practically speaking, anyone that wants to deploy IPIv is going to have to make
the switch at some point, but that doesn't help people running legacy crud that
don't care about IPIv.

I was thinking a module param would be trivial, and it is (see below) if the
param is off by default.  A module param will also provide a convenient opportunity
to resolve the loophole reported by Maxim[1][2], though it's a bit funky.

Anyways, with an off-by-default module param, we can just do:

	if (!enable_apicv || !cpu_has_vmx_ipiv() || !xapic_id_readonly)
		enable_ipiv = false;

Forcing userspace to take advantage of IPIv is rather annoying, but it's not the
end of world.

Having the param on by default is a mess.  Either we break userspace (above), or
we only kinda break userspace by having it on iff IPIv is on, but then we end up
with cyclical dependency hell.  E.g. userspace makes xAPIC ID writable and forces
on IPIv, which one "wins"?  And if it's on by default, we can't fix the loophole
in KVM_SET_LAPIC.

If we really wanted to have it on by default, we could have a Kconfig and make
_that_ off by default, e.g.

  static bool __read_mostly xapic_id_readonly = IS_ENABLED(CONFING_KVM_XAPIC_ID_RO);

but that seems like overkill.  If a kernel owner knows they want the param on,
it should be easy enough to force it without a Kconfig.

So I think my vote would be for something like this?  Compile tested only...

---
 arch/x86/kvm/lapic.c    | 14 +++++++++-----
 arch/x86/kvm/svm/avic.c |  5 +++++
 arch/x86/kvm/x86.c      |  4 ++++
 arch/x86/kvm/x86.h      |  1 +
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c4c3155d98db..2c01cd45fb18 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2043,7 +2043,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)

 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(apic) && !xapic_id_readonly)
 			kvm_apic_set_xapic_id(apic, val >> 24);
 		else
 			ret = 1;
@@ -2634,10 +2634,7 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
 		u64 icr;

-		if (vcpu->kvm->arch.x2apic_format) {
-			if (*id != vcpu->vcpu_id)
-				return -EINVAL;
-		} else {
+		if (!vcpu->kvm->arch.x2apic_format) {
 			if (set)
 				*id >>= 24;
 			else
@@ -2650,6 +2647,10 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		 * split to ICR+ICR2 in userspace for backwards compatibility.
 		 */
 		if (set) {
+			if ((vcpu->kvm->arch.x2apic_format || xapic_id_readonly) &&
+			    (*id != vcpu->vcpu_id))
+				return -EINVAL;
+
 			*ldr = kvm_apic_calc_x2apic_ldr(*id);

 			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
@@ -2659,6 +2660,9 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
+	} else if (set && xapic_id_readonly &&
+		   (__kvm_lapic_get_reg(s->regs, APIC_ID) >> 24) != vcpu->vcpu_id) {
+		return -EINVAL;
 	}

 	return 0;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b37b353ec086..4a031d9686c2 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -442,6 +442,11 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);

+	if (xapic_id_readonly && id != vcpu->vcpu_id) {
+		kvm_prepare_emulation_failure_exit(vcpu);
+		return 0;
+	}
+
 	if (vcpu->vcpu_id == id)
 		return 0;

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa4d8269e5b..67706d468ed3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -177,6 +177,10 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);

+bool __read_mostly xapic_id_readonly;
+module_param(xapic_id_readonly, bool, 0444);
+EXPORT_SYMBOL_GPL(xapic_id_readonly);
+
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index aa86abad914d..89f40c921c08 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -302,6 +302,7 @@ static inline bool kvm_mpx_supported(void)
 extern unsigned int min_timer_period_us;

 extern bool enable_vmware_backdoor;
+extern bool xapic_id_readonly;

 extern int pi_inject_timer;


base-commit: 1e147f6f90668f2c2b57406d451f0cfcd2ba19d0
--

