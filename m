Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8C3A1D51
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFIS7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:59:41 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:43593 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhFIS7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:39 -0400
Received: by mail-qk1-f201.google.com with SMTP id t131-20020a37aa890000b02903a9f6c1e8bfso15237447qke.10
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+FffBBY2+go1B2BMtZvJ9eNlLJMbHhZKlFRx5SYML4I=;
        b=XRCHO9ggXeNd9TJVBNvB3ahyrdazp7foO5rwlZxogjUIb50wIcBOghOOhdugUIbFzg
         X3Sfv7e5Vmbr+qTcBso27QAbpu71lV/dRlX/B0ukV0SGE2y9grH0ZN+HENJ8+urYdX2p
         pKdnNqi5MXGICPtpHsCalxKhqb8KP1DjkoB5X0kTVN1/WFDbGliRXXdGHQNihGpfZUsp
         YMz0+xbHMK/4j5M6Vtxi61dr/3ZG4mSffDy61mCal+pr1rfB5qZeKugVHxVecitG6Kys
         MZmlV6lmq/MLg53ItVhURQJhmJty9U0c7avUwYV/H/hBXPZMbIko0h48H5tyCb/RdJZU
         a2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+FffBBY2+go1B2BMtZvJ9eNlLJMbHhZKlFRx5SYML4I=;
        b=fJv7giqIM2CtNwtdwNMT3TD6hzF+427XSfi5HAphgX8RO2xZj47+peQ5VuH1UgaCWV
         TAU7kuiYjWeZlWwzt1twmxxqPtTXx1ymYBbuiBHNo+/eZhy4Vbx3+8ZAKlCY23KMu0CK
         Yd2Tn4r7ZP2hhQrodvUPPFlQDrthLezGpuTQeiG+XTcnxfYr/utyEYUxzBD+P0NwPT4U
         Cz6yWPvAJnkF9tajZgz2V4a2rEGwDjFtURglNoltrI+Mdofr11RJJ76/Mjcwx9eEbWVO
         M3R7zYdBdkDvpD7FLUZINonQR5jjljqUGkNMkEEneduGhhYU45yTtLN11h0fRM0Wut6n
         Ekig==
X-Gm-Message-State: AOAM530qMx9Y4EUjsa6/iXZ/3Ih7lio/0Z32VYFORg3Pli0UknioxlhC
        CbpsKtpCnVbl7dVh+zWK4dc4CYOIxjM=
X-Google-Smtp-Source: ABdhPJxULQTwk+/7ZGY0vetRd88AdAPGfLZLgtPSuVW0PiGMxQhlUgwHKQqBrvIDyiOYJXTWG1PXahmIpWQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a0c:fa4a:: with SMTP id k10mr1535440qvo.18.1623265004243;
 Wed, 09 Jun 2021 11:56:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:16 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 6/9] KVM: x86: Move "entering SMM" tracepoint into kvm_smm_changed()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invoke the "entering SMM" tracepoint from kvm_smm_changed() instead of
enter_smm(), effectively moving it from before reading vCPU state to
after reading state (but still before writing it to SMRAM!).  The primary
motivation is to consolidate code, but calling the tracepoint from
kvm_smm_changed() also makes its invocation consistent with respect to
SMI and RSM, and with respect to KVM_SET_VCPU_EVENTS (which previously
only invoked the tracepoint when forcing the vCPU out of SMM).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13a33c962657..11ea81c8cb82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7434,14 +7434,13 @@ static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
 static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
+	trace_kvm_enter_smm(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
+
 	if (entering_smm) {
 		vcpu->arch.hflags |= HF_SMM_MASK;
 	} else {
 		vcpu->arch.hflags &= ~(HF_SMM_MASK | HF_SMM_INSIDE_NMI_MASK);
 
-		/* This is a good place to trace that we are exiting SMM.  */
-		trace_kvm_enter_smm(vcpu->vcpu_id, vcpu->arch.smbase, false);
-
 		/* Process a latched INIT or SMI, if any.  */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
@@ -8894,7 +8893,6 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	char buf[512];
 	u32 cr0;
 
-	trace_kvm_enter_smm(vcpu->vcpu_id, vcpu->arch.smbase, true);
 	memset(buf, 0, 512);
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-- 
2.32.0.rc1.229.g3e70b5a671-goog

