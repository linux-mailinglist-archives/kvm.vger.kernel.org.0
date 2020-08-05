Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA0423D381
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHEVQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgHEVQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:16:17 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D0C06174A
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:16:17 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hi12so5491721pjb.6
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=la1fBNohyp9Rq0q7N/prOaEAn3Pa3Ne3Ld2u4313kWw=;
        b=bXpi2JLztAZeYO0FKrcoi/neZ2SaOju3+iUfx3+Z4jiX7mN4K6Sq7bqKw4jreYFbyJ
         GrHQszRjcrAL6sEDiyRoBr28+wvCWUMTQNYtnMJDRc/txE2wdF3WWaOwOl2k5E/fjkGi
         TLFmiwLiKWFV8In+Delusu8dHNPPmkThIn++0gAHKzco93VyIagcaeOD3YW4/IdxiAV3
         T6PBS/BgmhjUcAq3JNEdXGpMzuFTAkff7p377MvNxbnLrYqbfIb3eTRJ8s54ptjYt5qm
         aXCnJBvX0IHcRHNXAk8Jbzf+5VA44ftqstXlpiSGKVjoUzRLolqWufbwzng7huCW/6Ul
         ZDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=la1fBNohyp9Rq0q7N/prOaEAn3Pa3Ne3Ld2u4313kWw=;
        b=AEnsMbdTIwUjbPTwk+dYb25HC1ztCSvcJ1Jhg9Fk9Epeo0fJeCBgaf/p+pCtzmPdxH
         bIOJxdEMyivtUcTDoP3OUjMr6laFjQljhjZ4BI1tP5/bNENSeb+4IMYP0rU61rEdPvlN
         hWzOrm1oLRdcZngjk1KqyZ3R6zp4Gc8O2QBWMTD/VChQ5PdkKz/NhrvDtmJ4aKJjoTfv
         suqCRfZAgKsTILqbLRun8WW5JcrxwfQ0Nnn6WYM1GKnLuAQRzmLdZ+vLWe7I+qeOu50O
         Bu7CHMR2WIvGx35Fh69KhPu0oaveoTjitx2NnNwnZkLqGvQw6HVdKI1h17w/pbE9BCbz
         7gQA==
X-Gm-Message-State: AOAM530k6ZprHKfjvrcfEj8NPgISVsV9tLXD2jiBbwOMzlCOyfjs0Gz2
        PKXrJf1/5x0ZP+LuekThzolWlT33MuN/g4fAnFEjUAp4Q2LnQ0hkuXwIQuf7KYuLiygmchSvgpe
        TGIewRBJY16cFpJRRNTZf7SoMKS2VvlAPGzylN2vz5dGYNz6Bn37I6trr4g==
X-Google-Smtp-Source: ABdhPJxm0hDF3GRIJjqfboYKhyLEgT0INlvVWxOxioqjRDAr3Dfw1NulJLURWwjZZVzBfWpTTN+xs8E6aMw=
X-Received: by 2002:a17:902:8e86:: with SMTP id bg6mr5029643plb.57.1596662176080;
 Wed, 05 Aug 2020 14:16:16 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:16:04 +0000
In-Reply-To: <20200805211607.2048862-1-oupton@google.com>
Message-Id: <20200805211607.2048862-2-oupton@google.com>
Mime-Version: 1.0
References: <20200805211607.2048862-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH 1/4] kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME)
 emulation in helper fn
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I7cbe71069db98d1ded612fd2ef088b70e7618426
---
 arch/x86/kvm/x86.c | 58 +++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc4370394ab8..d18582aefa9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1822,6 +1822,34 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 }
 
+void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
+			   bool old_msr, bool host_initiated)
+{
+	struct kvm_arch *ka = &vcpu->kvm->arch;
+
+	if (vcpu->vcpu_id == 0 && !host_initiated) {
+		if (ka->boot_vcpu_runs_old_kvmclock && old_msr)
+			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+
+		ka->boot_vcpu_runs_old_kvmclock = old_msr;
+	}
+
+	vcpu->arch.time = system_time;
+	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
+
+	/* we verify if the enable bit is set... */
+	vcpu->arch.pv_time_enabled = false;
+	if (!(system_time & 1))
+		return;
+
+	if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
+				       &vcpu->arch.pv_time, system_time & ~1ULL,
+				       sizeof(struct pvclock_vcpu_time_info)))
+		vcpu->arch.pv_time_enabled = true;
+
+	return;
+}
+
 static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
 {
 	do_shl32_div32(dividend, divisor);
@@ -2973,33 +3001,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
-	case MSR_KVM_SYSTEM_TIME: {
-		struct kvm_arch *ka = &vcpu->kvm->arch;
-
-		if (vcpu->vcpu_id == 0 && !msr_info->host_initiated) {
-			bool tmp = (msr == MSR_KVM_SYSTEM_TIME);
-
-			if (ka->boot_vcpu_runs_old_kvmclock != tmp)
-				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
-
-			ka->boot_vcpu_runs_old_kvmclock = tmp;
-		}
-
-		vcpu->arch.time = data;
-		kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
-
-		/* we verify if the enable bit is set... */
-		vcpu->arch.pv_time_enabled = false;
-		if (!(data & 1))
-			break;
-
-		if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
-		     &vcpu->arch.pv_time, data & ~1ULL,
-		     sizeof(struct pvclock_vcpu_time_info)))
-			vcpu->arch.pv_time_enabled = true;
-
+		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
+		break;
+	case MSR_KVM_SYSTEM_TIME:
+		kvm_write_system_time(vcpu, data, true, msr_info->host_initiated);
 		break;
-	}
 	case MSR_KVM_ASYNC_PF_EN:
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
-- 
2.28.0.236.gb10cc79966-goog

