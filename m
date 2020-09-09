Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1719126257A
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 04:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgIIC5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 22:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgIIC5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 22:57:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099BEC061573;
        Tue,  8 Sep 2020 19:57:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x123so855512pfc.7;
        Tue, 08 Sep 2020 19:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Ci4JG02FAd7t2hb7z9AKMELCxudpUg5ze3327gd91Y=;
        b=u1A3ot8Ky7B2j9GgvIOk9jfuL8tdo9WyRMr8t9ugobDiQR196NOocxCyUE2qeLsy9f
         eA85NvUbNVXPTTJlbQtJg2ytBP2SLANU7Jjm/kGwmiidjSbb2Pb/U7JMA6+963A52BwE
         4hhEh/MevUxjxgKqTCGD2QiMvTj2cVEN6aopW84VuV3moCDJWH0C8aieeiFIc5UXx01Q
         XcCWUrNjkeTxdIEA8/GW0Vq3bT9FF6GGBNMZI79UxT6gI6V7Dd8CNv29hR98eoWv4/Wx
         TnzntkA6kH4v+3VW21eqo4otD7ZnuYBYYu7Gz2e+vTwxGSGYTLjlWFvCHaEgCvjGMvYS
         jcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Ci4JG02FAd7t2hb7z9AKMELCxudpUg5ze3327gd91Y=;
        b=L3GgezGOC3cLPBsGETRKL/RSfkSmFP7ZdvJzGcU/Rv1UiR8LCEUPatdbuuQC59XqjU
         HoTz1GIIsBxLpeSeAb+7PklU+S2cqEt50iip3xuSv8Ip54CiV9YAMhcCQWBgUCaRewE+
         Byluwu4N3skYWoAfV64/8/0bFAYACQnmVwq5UICZi/64oL4N+mauJ+eWiMk9E59GmEQ1
         8DJGJTQ8uFHHNWemagEdWgnbmDGa78tT7XHp7W0Q8sXgGaEAz5jT7I/xsApOeMi1AmX4
         JYPi0DL4rphbI2yOOVT8TRA33pkTllmIsTF2Qlnfyl1gDT6J7w3E31kpBHnNRkmzmSCt
         WT2Q==
X-Gm-Message-State: AOAM532Pt+gG8FmGkUgCSS48dTicbLRKUPw4P0dCy43fq8JI/VYxh2Lp
        EccAsQC2Z23NXMBsM2fyJe6DD3cviLI=
X-Google-Smtp-Source: ABdhPJy9r3B86GKGUKXdY2u00hxgmHa5G1Fs6cZ1Avi+W/4ehJwNJ6YKLerD4CUUGZKUidURW1i6zg==
X-Received: by 2002:a65:6707:: with SMTP id u7mr1295575pgf.449.1599620250966;
        Tue, 08 Sep 2020 19:57:30 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l9sm556063pgg.29.2020.09.08.19.57.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:57:30 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: [PATCH RESEND 2/3] KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
Date:   Wed,  9 Sep 2020 10:57:16 +0800
Message-Id: <1599620237-13156-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
References: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Moving svm_complete_interrupts() into svm_vcpu_run() which can align VMX 
and SVM with respect to completing interrupts.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c61bc3b..74bcf0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
 
-	svm_complete_interrupts(svm);
-
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
@@ -3530,6 +3528,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
 
+	svm_complete_interrupts(svm);
+
 	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
 }
-- 
2.7.4

