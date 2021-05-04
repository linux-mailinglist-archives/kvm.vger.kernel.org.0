Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79922372EA6
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhEDRSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhEDRSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696A8C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m68-20020a6326470000b029020f37ad2901so5674695pgm.7
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=x9ju8Y95QmZw6Siui/FK/R18zMsSmb8w0Q5nDcsgnqg=;
        b=v/A3HzwLp+vZV56pMiyGse3+Y7Ns38lqueNgFzl39BqNJ8/nNkwrQwLE7jj0HL6n3b
         bTksTsCS/rwy4KFIpqe8pt2TgSLjkyG/8jr8S2+csy2GFj3kf+Vk+b2KJ26ri0osQnAE
         7zOM779YwH3NA+nudqbsxSiBW7gUOdYB7+pZA91l7wUgytk0IAsvHC0yI4FxxC1QaTRT
         EjKP0xq8zK8bmp7mNLxzwGD66AvagO8ZGcuyxa2AVrDT1g0uouUrsyQULAtR4oy9IMWQ
         hvXGsaW34984PFebHKAzJblE8fgtliDC98prZJTZwDWp655aymPS2gaOd3APbn2NyhSc
         m39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=x9ju8Y95QmZw6Siui/FK/R18zMsSmb8w0Q5nDcsgnqg=;
        b=oXO6DKgpQ7xYNtdlbUH8BkzZEIXnC1bdt8Zf1JeWgo8HIvuRjukA2WTi/S13zR0VMQ
         eN+1Wd6wwEpdcdpCiQqo6ViMSOi50PTE+f2c9XOu40bVsygYe9a6fbjaCJck2X0rAJUj
         YXqKypnb8Y/ajK175xw76p3D2RKI55gpmh2SFles/Zr4DsF5vCjycF3L3WN9tOWvo+2N
         97lrmWPo7WwLmztLRkv5XDzEQCj/JDevfhNAWJpsEn6URbjDMHgvCd0IbR8XGiYeqiV7
         YvE7jfFFBbyfrmxZ7HJA6saIsdairB9LfELw3rkxFxAuON0gW545mbpvUzOghV2G2Mzp
         YS1A==
X-Gm-Message-State: AOAM530oSGqOoweihCPaT+6QbJsmzWuoBuJuIVw6qq9zvyssq3pt1PhG
        U1R9QX7ILNjGEYWoq/1/eZ5mYEqdmr8=
X-Google-Smtp-Source: ABdhPJyMfi4QaGrLYdrW6ssUNtQ+SG89NJapbP1MqWBMxR/nCoes9dndo5SZcIvi2xFF+IwubJiTNFdt5nk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f690:: with SMTP id
 cl16mr29862523pjb.207.1620148671954; Tue, 04 May 2021 10:17:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:23 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 04/15] KVM: x86: Move RDPID emulation intercept to its own enum
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 2 +-
 arch/x86/kvm/kvm_emulate.h | 1 +
 arch/x86/kvm/vmx/vmx.c     | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index abd9a4db11a8..8fc71e70857d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4502,7 +4502,7 @@ static const struct opcode group8[] = {
  * from the register case of group9.
  */
 static const struct gprefix pfx_0f_c7_7 = {
-	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
+	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdpid),
 };
 
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 0d359115429a..f016838faedd 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -468,6 +468,7 @@ enum x86_intercept {
 	x86_intercept_clgi,
 	x86_intercept_skinit,
 	x86_intercept_rdtscp,
+	x86_intercept_rdpid,
 	x86_intercept_icebp,
 	x86_intercept_wbinvd,
 	x86_intercept_monitor,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82404ee2520e..99591e523b47 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7437,8 +7437,9 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
+	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
 	 */
-	case x86_intercept_rdtscp:
+	case x86_intercept_rdpid:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;
-- 
2.31.1.527.g47e6f16901-goog

