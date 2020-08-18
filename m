Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4812489AD
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHRPYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgHRPYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:24:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B9CC061343
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d26so22573443yba.20
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kN4Uz1/uoG7NUGItZgFrqtddN6gWXvz9muSNZRarF1w=;
        b=P8tsIfdzrYJGShydcl26aucWE9kJ4dhFY1/t27T/z+X0H1jhsDq0pzUgCXdIkl1e4z
         pEYx4MyxRLQlDp2zNa4FiwhKG8v+DqBf0o+3Wg5LJP0GhYfvDwyYCBVzhimpZPNiZiRi
         4bjWPB+BPv7mJUAWFUHBFFCYVUN7/ra06iBgZR+CPAPCcSLSqBH71sCc2zIa8K5cP7TP
         iiKDedjDfkXT0Kh0BOWNKoa/7mXQft9aTLNJX2Os1t2pnHeYt+NHJKl7xO17zmgtVj94
         Dp6QuBv546CJaV5XlieTIOeF3St8iyl2FX84AXYwIrdemmC8+w3oMFcj98mrjDMNY+/x
         Hf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kN4Uz1/uoG7NUGItZgFrqtddN6gWXvz9muSNZRarF1w=;
        b=KO8hfTKdngiT0DCdkhOsnNNwIO5EEUfo6FUduOVwch4Z0TIB5pwj7vqD8vZ32TYCBm
         gsHKZlYbr/Oa6w+UsVM1Pruy+TqAr+pD92xrEkABrD3yAWFK79MRyfhCffDgOZQJEvp7
         bMhq0vkrzu4O4n6r0LAkOZ06jBAyD7Lrilh1ACgA904DokR+D/4A6F1iW3UNfWegmFW5
         SH/sOWLD3QJCtxaV6GLvC+mbVmnNwE6zZXeUnLozXPa9Wud/J5IAvPEKULsBYfdjhpEG
         bwSjrqZap06cs/F6/iHFory5m5Zi8iDn8h9acXYmmF6KolN0qAf4qTqSGDTW0xPecZsk
         WWjg==
X-Gm-Message-State: AOAM530IYESWGY0Q18xoB5yaSAqq5NWWCtSqDXFsOO4oQV2sQFDqWFcE
        LZO8n/+twr6ge29yo9IezxMLqHZCYqyWUZ02DKUmI5pGOuwIv7CN3IzSb/4PPEyfd41w7HuKq0G
        26oL2W1oStsgmAij356+0blTIfiEjAUGzx4cllmCcfgVwkbxl+I5MVb6R1Q==
X-Google-Smtp-Source: ABdhPJwzgm1kTDjZWbhmtm+PkBpCKfY55nrE32hW+LLykyNmYe90PofqwEScjYHpC4iEziukZCz1KBun7yI=
X-Received: by 2002:a25:aa72:: with SMTP id s105mr25937506ybi.463.1597764282019;
 Tue, 18 Aug 2020 08:24:42 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:24:26 +0000
In-Reply-To: <20200818152429.1923996-1-oupton@google.com>
Message-Id: <20200818152429.1923996-2-oupton@google.com>
Mime-Version: 1.0
References: <20200818152429.1923996-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v4 1/4] kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME)
 emulation in helper fn
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I7cbe71069db98d1ded612fd2ef088b70e7618426
---
 arch/x86/kvm/x86.c | 58 +++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db369a64f29..b7ba8eb0c91b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1823,6 +1823,34 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
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
@@ -2974,33 +3002,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.28.0.220.ged08abb693-goog

