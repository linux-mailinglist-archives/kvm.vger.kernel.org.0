Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2E23D38B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHEVVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHEVVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:21:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625A5C06174A
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:21:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g127so14732532ybf.11
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yQtZaZXi+U75DJ3qF2YeU3Fjk111QGLsB9W7wdn91GA=;
        b=t7pTWPdebF0bfhcL89P7swWBkn+mBQvQA9TOHfmNvcDmFWUnYpC6tIt10M8b5uwqzy
         VJqimRCIC0QT6snmk+1D+rG2NF8O+mDPwPnxAGHRd3Uk0gQQR7RBrEWz6F7epHFX0mGP
         4tc4nd8gI/DupSg4aUgnILA7ctu2PIkIBAlyKqqX15M/hXPBXt4uuZKvROEMgxN9eN6q
         q/fUTwpara+3uNn/rEG9ER8lxqmnbD0Hfd2tY1fDZZbEJLuhzbl8u7ae9ZuTs3XTpTrR
         n5iWnS1g1XdGqvZgd/bmzDwRdGA6C473nYAVU05FAKDC4CCRTto2vgDq0gc8Se5KyQAG
         Myzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yQtZaZXi+U75DJ3qF2YeU3Fjk111QGLsB9W7wdn91GA=;
        b=NSY2lv94G6N2w7KCFWusgBuoy5kAsSq9pEYQc+g/9htJeUss1+uIbrP5M7AjQ5Feer
         yiylGzurFoivW1kxcgJYg9nrNR8DWEm17GHuMqA85cftc2T3xLjAEtDxe0gIUd9vanmG
         v9w8FzHOSDVGTvR5ibBx+HC4iTWBk9Eejfws2SzNCTcTqG04hc5kOxykhTyQIUch1q0+
         YV3u1Un/8BHGSTBup/b5nwiOaJEv5IEU2KNXUlUXwM15qKX/6YVtiBAkKk5juU4Z2Abn
         3bbSwWEiHH/K2eQMO5g+hS2P6I+KAnhGTkgNM9RamArK0VnoaWHYZMDqKmLcFK3slvHM
         tIbg==
X-Gm-Message-State: AOAM531mJnGZ7zv3/1wXnsVuRTAUTiSJRVh5x04Zm3nyPbzXgcbBo2CL
        gKZZZkwEJjCIbh3gpxTXcqrNF6R+XEZuLLyABbQeU1QvL0RfMszr5GsOY6HAIE/2jROiOI6kqMo
        s8AKCvoyhTEqEbsKEqaZjk+OWwQRe+TN8WJDF0J0dAD9oCxWl0j26JmtNeQ==
X-Google-Smtp-Source: ABdhPJydJVXkSb37TwBwuFz9m1W1D23r2m9X9q/aeb6i5EVrtSorhWO2TZeCqIB4Q1uR7goI/xGF9B5gk8E=
X-Received: by 2002:a25:a88:: with SMTP id 130mr7575300ybk.52.1596662499619;
 Wed, 05 Aug 2020 14:21:39 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:21:28 +0000
In-Reply-To: <20200805212131.2059634-1-oupton@google.com>
Message-Id: <20200805212131.2059634-2-oupton@google.com>
Mime-Version: 1.0
References: <20200805212131.2059634-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 1/4] kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME)
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

