Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DC23C6E
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392327AbfETPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:42:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36136 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732399AbfETPmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:42:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id s17so15186190wru.3;
        Mon, 20 May 2019 08:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pTMTqWY8E4+UnCZ9AjMEiomm00MjjGjXsokoRCkoYLc=;
        b=DRl+KqdIokWtcnwsE6se0zRs1ML6Kgm5bl5siV1nJDAo4iSmjRnWsw0M798AjhjBF3
         ew4/B/7NlF3XRd8e0/QekmlLtPWw5uoRKUKLuubsrSH6GpaUcg+og9IqBjsqVWjLerZ9
         ASrOFalwLhiL/xx7tppP5YrCN5ob3vLKQUKynHSCEPcZSghHuYvgPZLP6u/VKIh5KO2z
         Hb1AUo1BFbB+4jCjVqnJE7UTQD6RKoB81ZXyEVpV/kjwjO9tpvd+R1Ob50jWsXEAW/ia
         JlbVfWAMOSB+17SuHnnlTbLOzDl1RPLMzHH5UQEGxIQmVKe9rscdfomvyFZQlX/6K4HN
         1Byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=pTMTqWY8E4+UnCZ9AjMEiomm00MjjGjXsokoRCkoYLc=;
        b=hviR3VTPFZETcBTQyAEyKEMkKEl06dxAhjjbNKoLYCQtgHPuxrmmEnIChMs3QHYneT
         X/dE5W2PFG/NwqkO7oif4D0LjPEr2IacX2AIZPXzByiX84t4CK5Qa5xnwBuyCtdLCAB5
         ntuCz2XPEsL/miEsZ56FvFVQ+pnvYU6s4ZcNfV9tq415vdiiCZbxycBL0352hdeoatUl
         vM7swRbM8nIj76MZXvUgEFeTWwZ1Wk6fpyJaLNFo9gWd+ghv2FLQdxJaBKVBvpFmP7O4
         tqCwyJfKOW5RcixNtFH4OjQfW78YxmG6y/hd3xm4arO4GLgv8lH1NapMP46u7D62jur1
         6tTw==
X-Gm-Message-State: APjAAAUzfg/GXv36QFgWn1L4QVGGYt/hfXMgNA3DSUCYVPBrQaV9uvBI
        IixlUwpwZybyMlUyWDuWyMg7e3Im
X-Google-Smtp-Source: APXvYqx/JY1VdrUlB1N4GQpIfYrei6E013ax5TCwwP3gyNNdvMlBuS3CQRLeTY+cgMRCa9akd05eSw==
X-Received: by 2002:a05:6000:41:: with SMTP id k1mr14631085wrx.332.1558366955908;
        Mon, 20 May 2019 08:42:35 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v11sm15851995wrq.80.2019.05.20.08.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:42:35 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/2] KVM: x86/pmu: do not mask the value that is written to fixed PMUs
Date:   Mon, 20 May 2019 17:42:31 +0200
Message-Id: <1558366951-19259-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558366951-19259-1-git-send-email-pbonzini@redhat.com>
References: <1558366951-19259-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, for MSR_IA32_PERFCTR0/1 "the lower-order 32 bits of
each MSR may be written with any value, and the high-order 8 bits are
sign-extended according to the value of bit 31", but the fixed counters
in real hardware appear to be limited to the width of the fixed counters.
Fix KVM to do the same.

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b6f5157445fe..a99613a060dd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -240,11 +240,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	default:
-		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
-		    (pmc = get_fixed_pmc(pmu, msr))) {
-			if (!msr_info->host_initiated)
-				data = (s64)(s32)data;
-			pmc->counter += data - pmc_read_counter(pmc);
+		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
+			if (msr_info->host_initiated)
+				pmc->counter = data;
+			else
+				pmc->counter = (s32)data;
+			return 0;
+		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
+			pmc->counter = data;
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
-- 
1.8.3.1

