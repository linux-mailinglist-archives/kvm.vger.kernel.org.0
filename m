Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7333432F7B2
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCFCA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 21:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhCFB7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:41 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A1AC06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:41 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id g18so3326790qki.15
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EaNTtcaGPwfD+VvuXcCpuD7ywnV0eDg95uW62rbzM4A=;
        b=VbAvCNnxOrpQgDgNqdZCbbZakM4DkWtLewiQuIriORQXOPQXa8GlpOSnKcuATHccfx
         NrPffEFxsNsEpf945kX/DxwU1DAvqs2CoRpHAtXfkwCQmgg53jWZnWeq4hOaoI1dgu3h
         ntQuAcpjvLK3XQ5xO4TEd21SOpHEVB7b8ddpkjl0TN2VbC1c/aXJA1u8HWJKST6tWFrU
         Ie2kBOkZZ5dgA7AqdTkaQxSwnPba3VH2hYb66AqjdsYje21JGxrImqKGKRPASo0A9pCn
         owHR1k1Ea6yuY6jcQ1QBwSKIcEAyylM5ZdJoFksRVuAL/1CaK4f1HtTVmdAulQPUOXHm
         3kFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EaNTtcaGPwfD+VvuXcCpuD7ywnV0eDg95uW62rbzM4A=;
        b=Pc/5PJDGkuG5rpkcEJP/AXQff0drznSf1qQwqixVy6bYPeNGaHwUZujRtLnw5tQNI3
         R3l5fO1WCFN6iPU+R+ZcI5QOROUi5e3SQ+QBkYyX7dCi9l20bXi5wN51O1tyzM8bWEPU
         1iKCSMKnNVRN/24pCNTeVvtXD0SV+tPWcBDkArQav505pfJSDWglrdn02aCctTKaGbFx
         Jlsc7AHhTjbi1T1QC7ygRF2SHXj/UTLfPAYDv0XWQlKnPC9RqPJzamR9vaeaMwvAvu0E
         /Wa+m+Faf/NaQ1u1M40VJmPmxObhjNyMQsOLSiY72NCE+PFHP1Mk2x5oYZSyCMMzJ5ZY
         Z/wA==
X-Gm-Message-State: AOAM531zRCUW29/BQqh7v/kMnlT5fAHd2SJDwmS/X+RTLoq172NCf4xd
        /46FaH/0bZ8JtGofxJiGRG+9HecYD9M=
X-Google-Smtp-Source: ABdhPJzw67+6peb/QWJcovBgcnMAP0xgjdGxtVaYuCp7pkvgXHk3IJLzU1Vg47gzveDVYHUNFEjKmbpZM+k=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a0c:b7a1:: with SMTP id l33mr11544153qve.17.1614995980607;
 Fri, 05 Mar 2021 17:59:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:01 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 10/14] KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
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

Query max_sev_asid directly after setting it instead of bouncing through
its wrapper, svm_sev_enabled().  Using the wrapper is unnecessary
obfuscation.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bed8fee6c549..63d4f624c742 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1353,8 +1353,7 @@ void __init sev_hardware_setup(void)
 
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
-
-	if (!svm_sev_enabled())
+	if (!max_sev_asid)
 		goto out;
 
 	/* Minimum ASID value that should be used for SEV guest */
-- 
2.30.1.766.gb4fecdf3b7-goog

