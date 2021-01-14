Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DC32F566E
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbhANBsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbhANAlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:41:13 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCB9C0617BF
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:58 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id k126so3029201qkf.8
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=292fZgTlFSUh9sat6hWygwmIzdDrAIVyQe5fuEoV9fw=;
        b=IcnYna8K4DS03EhbgmYafZnVxDj379RLm8bCjdpPDUE9RyoriLUT1HlUkpeB4Xnm+Y
         uRsGRyTafPvmq9f+bxeNYJ8wTzt2p0huhmLkwIIudgJLxrKcJ0cwNAobv3oyBotjrtN+
         DHQkb9OV94+iiGgGAZ2rvgE83CvCDySov1H1GoFCamGFuaPf6BQNYrZ7mdnnTrEYKxRP
         kpbr6GlX5QWL8HmlXEQyw6w9kQjBTM9WWrnSyKI9fRJ/eN4zt1BjvEjmyyGxFbITjkzt
         wMozgFrOvdqNTfksYrxC//KWRM1SVy5VQT+WQuYlZ8bXXYbUasKhvdt0zuE4pDXcwNti
         JteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=292fZgTlFSUh9sat6hWygwmIzdDrAIVyQe5fuEoV9fw=;
        b=c1huSOH/YWk69TmEvKhlO2SwGImf7hSsWHMQMcSk61V64DnRmiNybO4+a13fnLX8Co
         cSEu5qmSzU+b5yuSDyZByI6C7qLlSsvV603nF9AjI/iNZSIdv6aWCdj2UwPZduuNoWl6
         cTycsgnc8Pz+C9+vw+XCsloikbKpi/k4m55tazbkYbpAiWoeZxG7/g9LOmQ4qId2K5Fk
         sWqDxCmCIH6mNJcKwMK6Dtz4aRdar7TsWriv+NhKDYquad938zxWqgANT5gK9UK0cn3H
         j2xjW/lQfhmreRp6nvMsq3rK6W38+CoKu9f+NCMx15Vcw/11EUYQDCqx+ydgcPOBPKOU
         wrdA==
X-Gm-Message-State: AOAM532emcjryFyiiEP603LXYBUNNfPbJFRz798WVQ/R7QHnUxtWLfik
        EELr5Gt85U9W5Fy1U6xUBoHK0rqzPSs=
X-Google-Smtp-Source: ABdhPJw8pliD7Fv+cR+neB6QIex3TgFqy4yftORPPzVF5RRo7A7OcaTceN4RXvu9BIfaKZhy9GpC6zHMRZg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:2f91:: with SMTP id v139mr7283714ybv.491.1610584677671;
 Wed, 13 Jan 2021 16:37:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:03 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 09/14] KVM: SVM: Unconditionally invoke sev_hardware_teardown()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the redundant svm_sev_enabled() check when calling
sev_hardware_teardown(), the teardown helper itself does the check.
Removing the check from svm.c will eventually allow dropping
svm_sev_enabled() entirely.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f89f702b2a58..bb7b99743bea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -887,8 +887,7 @@ static void svm_hardware_teardown(void)
 {
 	int cpu;
 
-	if (svm_sev_enabled())
-		sev_hardware_teardown();
+	sev_hardware_teardown();
 
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

