Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4019336773C
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhDVCMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbhDVCMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D54C061343
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e8-20020a2587480000b02904e5857564e2so18227283ybn.16
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9BiWISFCcixYKtSXmCvhEquE6FSPh7cPiu0dynjovJc=;
        b=MuwM5CseSgqeEDzoWHzpoCmV2nW49DwExJhMKTCZlG3NYzsHgXIqlXoAMZcdZAtNZv
         j60C69rDGH3oF3fZbzlYQKRpcOVx+8/dbmMEyNEsa6f5HZuGMDLxFDbLt/jFDl1lnMZg
         1vy8ShI07gkPP3TBnlWSq0DfMGaQahNoSkQsoPIzF3srupZpD5RRM2CcC/hUxerJRcGj
         Ics4x9gqpkCqngZoOCL435CYrD0ITSgX/t+njaAleF6jDSLU6cIGgP6Wkl/PTwpJzOTw
         c3GOAGz3m11NOfFU4cbeU75a6AKCioiPjSEBbzqB9dbzK7n0u874ArYajSuGGa2ggraA
         xuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9BiWISFCcixYKtSXmCvhEquE6FSPh7cPiu0dynjovJc=;
        b=HkTSzVA3Lzb3cPmSCGD5A+2efP6BupWNzFvuyzCJsmrAdEwJpm0/zEYaX/x+artvJ8
         l1wrswcOKubpq6IrIXYkwtx8QpOawCrCEFMlmIghw9wcptL/uGE0mCwEb6oIPpFwLogm
         VihC7QpNmZiJktBnGDB0pGl8D4fipPWoXTvl0m+svV2enmrkorN3/oUhyj6KZuWGQT0g
         kzoeonwrDQWtnM8plsipWydrwaPDrQUMRi1uLmOhiEG485dBFoygMtAzbwYJK5r6gMig
         ReNI++hbj7zkQ0fX0juRMuBzNzsTyMmAxZWZHsv2e7d1Hz5aAkvFwaJb0XqC9znSaUCM
         4yrw==
X-Gm-Message-State: AOAM531+D0UUnlFeIkvp2Z9zYqcNl9XUrk6Z3eQ8y2Ddkm1GeC6GSR3v
        m7s1b5Sl2BgGzUwiUtpymjNVCFrCOss=
X-Google-Smtp-Source: ABdhPJw7qcfEXWiPfgpM+thtO7PWbHa2bde5abvRGKNcMZv7geiC/Pv6bsNVkIQQGYgZaDBLiYVyESeuIto=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:4946:: with SMTP id w67mr1389908yba.141.1619057510250;
 Wed, 21 Apr 2021 19:11:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:20 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 10/15] KVM: SVM: Unconditionally invoke sev_hardware_teardown()
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

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cb227e90dffb..f5684d24e333 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -879,8 +879,7 @@ static void svm_hardware_teardown(void)
 {
 	int cpu;
 
-	if (svm_sev_enabled())
-		sev_hardware_teardown();
+	sev_hardware_teardown();
 
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
-- 
2.31.1.498.g6c1eba8ee3d-goog

