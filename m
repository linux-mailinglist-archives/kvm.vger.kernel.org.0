Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97A0367729
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhDVCMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhDVCMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB769C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso18126301ybe.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8s0SzW+l4+6E9FQkwta1CXoWCr5k2rhkG3YB86R5vGE=;
        b=IUFr8Ehv63gVs8gd2PTxTfVtoYJynmAwaRBpO0kkEzY6jD1vvWafZxEu2vY0QGWooS
         F+WJevqvw5evQnOgKlzmHMXL/W6wcKb0iB7CXpIEjDwqdr3AKjmoT/mw9MEX0hFLHzoO
         gdXAL6HAnU94i0nUW0Zc8hn+psMX5XJTsmCfiLNM7ZcpziQJckPI++f3VX2an/IoLNhN
         QtFymOYkFRVuguzd2eJy2MCb1PvcYSf9hC7iuekDiBX1Ib9uops0Vu63mIb7m9udrNNr
         Yzsu5hXegUFAva10ZkmRbTYQ5l60RciHsmYXs8zuGqCgHHwCva3uHFGvVGZv53OTE3to
         eYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8s0SzW+l4+6E9FQkwta1CXoWCr5k2rhkG3YB86R5vGE=;
        b=G4VFU13sgBcFOdIknTn4xU6vTYmw5cED701YzA8b+j5xNAZ1ECUQuwFmTEy4JNX99R
         h+IJB4B7uNQ5C/WtySGTBiSl7xDFoGfY5K9Mf9OMw4U0+RkyeXILP9W17TOA299NCpkx
         +Py5LA9X6gK45sUK7Z5QRX0vE6QiW7yBZKC3RM2KJk9LXPpQieQW1KQxvnBrkLkKvsxJ
         M/Bl85oJ43Q7UmyBeTPBwgoFIxZxyS+LlNkf90cImLNzu6Y9DsExFenEQ3URsD3flwH4
         FOXG7Ssi4tinVTXPQHAXN141vzbaPvGSLkWYcUoH3FM7eK3QwvVm2ibhn40/LASVcMdI
         QjGA==
X-Gm-Message-State: AOAM532pKiqPWIMcZEbx/WXwoKMKhvtmcagIQ2odvsqiPouAI0yuc4ll
        S2SNLtZ2Q7AIAx3vsY4VLUOLjkfwHmg=
X-Google-Smtp-Source: ABdhPJzwHVJWWNDZJHDzs4jU5ocsCu8TZvEQiZm0Q3IKhnmau9VhTIcLindMSL/WbKeNGrazpmgd3spmeog=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:14d4:: with SMTP id 203mr1322961ybu.261.1619057492934;
 Wed, 21 Apr 2021 19:11:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:12 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 02/15] KVM: SVM: Free sev_asid_bitmap during init if SEV
 setup fails
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

Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
KVM will unnecessarily keep the bitmap when SEV is not fully enabled.

Freeing the page is also necessary to avoid introducing a bug when a
future patch eliminates svm_sev_enabled() in favor of using the global
'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
which is true even if KVM setup fails, 'sev' will be true if and only
if KVM setup fully succeeds.

Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b4e471b0a231..5ff8a202cc01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1788,8 +1788,11 @@ void __init sev_hardware_setup(void)
 		goto out;
 
 	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
-	if (!sev_reclaim_asid_bitmap)
+	if (!sev_reclaim_asid_bitmap) {
+		bitmap_free(sev_asid_bitmap);
+		sev_asid_bitmap = NULL;
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
 	sev_supported = true;
-- 
2.31.1.498.g6c1eba8ee3d-goog

