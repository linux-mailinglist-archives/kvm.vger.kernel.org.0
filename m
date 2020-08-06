Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1423DFC9
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgHFRxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgHFQbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:31:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDC4C0086D5
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 08:14:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z16so33806022pgh.21
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 08:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IEWKHXgY/FO2Lzh5aFVLQspUpNRT0CohKxffXWIy7MY=;
        b=gUQ8RY84bFEwevqDGstP05e0tNYK5t3p37LAnEQs/IHBUy7tJ+EZqruPebc4p5MFJa
         jkEtEUrXAkLSBMx6Si7aOciUb8RbCUIwvcrr9Dp8q/DrExa1C84XDAmG+uk8sp0Xu5F0
         ZJpSHRSsTEEuSUNI9UELKDoWRfG8KGbfUowUcuc+Z0bn4AMsG+iYFuX+lbRrs48H8rn4
         3Mu6X3a40coIuMqRgvvFopRZkOpfrtC36pZw+Y+1M2ZDVRi6GG5aeI4MaFgSZKoTS82L
         nd2u8NEn5Q51AKPIoePOcSBm+ctACEVgXbzCcWDmSj1zSrMHz1SdEh2ZI9ThnLkptJ6q
         0QQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IEWKHXgY/FO2Lzh5aFVLQspUpNRT0CohKxffXWIy7MY=;
        b=jaAbZcREnkatcYYLDl2zmqPtvsdvDaTYTwO2yN4BRnK5iwXUBDmLPUQvKaVE7EoG1o
         jfoWXpXC/X5F07oTCM1iWBVHtM3idaVwRmPzmsoGrdVQhOpuE6XBZIhQ08+YJVcJyVMr
         RIV+gWAYDOD+WmOwX3ohs9yDVlr9srJ7cCJrbHWmJB1DmbFtDrzBnpJUnAaRalGIVl24
         NySsmpv55yjwHjFclE40o6nnKSsUhCp40wtco4qmlSvWFwBK0gqYJu0vnyRG6DsFWpg4
         HxaHA595pIA5uucsRWGQH1AYdUaPMrn0Mp71+r4PHjasaejPWGF8TYwmxUCuU+pGGXb5
         C5dw==
X-Gm-Message-State: AOAM531f84wBpFse0Kefkzj00nwdFwnpqRo4r48N3iRhaezOvw6HbxJ0
        dRGjHUC+w2R80EUvWEin4W+a7v4oTRupeZDYNF9nBHMYxontCq32NtDOf5HpaZU+L6QC9FL4M/O
        a9GiJ2lpxk1j7hyc6WuOzYrcRX7I1Qi6OKBz4+imdJJNJcgfdb/hRk9wbCQ==
X-Google-Smtp-Source: ABdhPJzA7mVX9VGBUysUPwrH7ol7HOsObm8SVAK2HWEx3nzgGFOoreJTSse19pvNlyp40HzwxCy1FUGOKkY=
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr8814253pjd.137.1596726878152;
 Thu, 06 Aug 2020 08:14:38 -0700 (PDT)
Date:   Thu,  6 Aug 2020 15:14:30 +0000
In-Reply-To: <20200806151433.2747952-1-oupton@google.com>
Message-Id: <20200806151433.2747952-2-oupton@google.com>
Mime-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v3 1/4] kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME)
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
---
 arch/x86/kvm/x86.c | 58 +++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc4370394ab8..5ba713108686 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1822,6 +1822,34 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 }
 
+static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
+				  bool old_msr, bool host_initiated)
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

