Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA592EFC65
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbhAIAtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAIAtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BE4C06179F
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c9so17214160ybs.8
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=292fZgTlFSUh9sat6hWygwmIzdDrAIVyQe5fuEoV9fw=;
        b=hR96DdZVhDK+6qksQXwJIuiZ/+XOj3ixyaTOVgExtrmCRA9k9BiJ8s3YgNFLU3xKuU
         fWsRiWw1w1gvEMoYm/4WwT2wYvA/XzG2nxmCkgdQN5lEU2o7K8hCtDpjCtGO+NTumXRP
         uplxJLr4QbseEMJyzcTJM6Q79qZ9JbZZ4t3fZakIvTFj+eHpG3u+xWYc795ob+Fklal2
         v1ZYK++qgNSSeAcaV1RbXR+IIrS7iZfwAe9eYOQ39xfL4eyYQxA0lnKKwIlQ1poZJRtD
         CXIharTpYAkcZdwr3+0lweYIN+Vul/f/q7ZrGWHMQPR5tLgWCzd/9snJlJ8sjvSsBIAk
         YwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=292fZgTlFSUh9sat6hWygwmIzdDrAIVyQe5fuEoV9fw=;
        b=oXOvbUEh3/hpEZb09S2EpAn00nQTPMMwmzQlb5pGI0PuGvpKiTzaHVzC83J2RwY1jY
         Ajy18HaJtlIEEB1pW/gs9KnhLlBpLriLhelKrkEAWhUUKW/lQ1s5GEPvxssrcpJTjV9M
         EuVhR7Weaj423tR4ZX8wlyelBvPl4CXyEuliyTAFNPyaQQtGu6e78YTzlu5XutRm0vsW
         1ghuNZYLhu73xDwJYvm1M8gxakb91SuL1+zugzoBYnhoywG0psq6DOvmxzvBosxWvsEs
         gTRuGeIFqf29WOoYL74yMCVSxg8FX+IV6a4jkqXwE5ZSwZQDvcH9DxJjTUYV/18eEuKA
         m+Cg==
X-Gm-Message-State: AOAM532s0ujqEqy7lB1kz/CBgbHxVeapGMqH3Vu0DpfGwLrpJ+dmhrqX
        rdJvXVnNkeqB4qZ0OpTkSvPYicXfW4Y=
X-Google-Smtp-Source: ABdhPJw3HsMyJQjGxgzaMAsKqmp4qMnS3gGyTkKUApJqynd6ijFrp0GM3mYvd7UgiHpqBBeZTNZSLHGABVk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:5:: with SMTP id 5mr9415276yba.478.1610153275053;
 Fri, 08 Jan 2021 16:47:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:09 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 08/13] KVM: SVM: Unconditionally invoke sev_hardware_teardown()
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
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
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

