Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89002CE043
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 22:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgLCVAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 16:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLCVAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 16:00:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B93C061A51
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 12:59:43 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 4so1881373pla.6
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 12:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=S5ra3fFtwyrR4DBSDAkXB7bmFSTJjJvoJm1aScqSvD8=;
        b=CMgmPGQ3LRAJ91emyWbIDeeu4Npdy86zsS9HBSAc8ghZ8AyFtq8IPAKujurb3BXMl6
         qydVnY5AUbZc+vdzxNbWWmIYmU4B56Pn368RqYqcA/O84Rn1fAmI+r5iI/4QxefdR5L4
         iQPuaefyDoLSUm69oF0b5m4cjGZdtvwKugIsWO4AGpChjbjG3aZNa/TpTARfvmP7XDMv
         kYG4ybDJe0sJEk612YLAPX11BceZM8h3ap3K0/bEhhEFT2n2BI4/ChT6ITK0bUC3ZAtT
         gej5444rFOdUyWbg53TWG8bvVleKc4MyYctWo1+IF5Y2QdMGnyziGqHn4tNa6P/rBz3k
         R3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=S5ra3fFtwyrR4DBSDAkXB7bmFSTJjJvoJm1aScqSvD8=;
        b=l4BaOkRfV1slAQ+wc0ZcLOYJjE1qKRS6Lm5xQg9ubGuA0XDKjkHgn4b5yatlHBBpNI
         coQkwpeJ+j/c0RoDAICE1AwKNRX8gZ7aOUgF9ZShlu+pWo324RpVZnJV+/Lg36vMjzd+
         plBjBSL38yTjXMMHpR9ASQpP7hINkauNm84hMzH9defslcWWIlqp2eKGngtbmQPrnpoZ
         vY3/ARr99Yi5wYiDFp1zMJzqaQVEB5R8UOjO+iyYJiotnf63VoXB1OfDvc8hurSVdkeI
         sKgtwi4P3JyALzWFZXyADjk97YvH8k6OvsS5bBHiSQTUaYWDtkY8MRzrFGqd0CSF3Uax
         jwPw==
X-Gm-Message-State: AOAM5335QjkkKNvlCq9pd4ZcrQ0z2+qh4DVf8k+HE45g0zd2ogHF145F
        Bzl44WAaFfCQtbLdSJjCNABm3AFbXih8Ng==
X-Google-Smtp-Source: ABdhPJzp6sEpJwizJg9kJ4t6HFh8/cL5/4seSshW8xQdAExolaPsro05znE1zqmIooU9dIASPm7CyJikDZMC8w==
Sender: "jacobhxu via sendmgr" <jacobhxu@mhmmm.sea.corp.google.com>
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:f693:9fff:feef:a9a1])
 (user=jacobhxu job=sendmgr) by 2002:a62:1a16:0:b029:197:eabc:9b74 with SMTP
 id a22-20020a621a160000b0290197eabc9b74mr683802pfa.62.1607029182775; Thu, 03
 Dec 2020 12:59:42 -0800 (PST)
Date:   Thu,  3 Dec 2020 12:59:39 -0800
Message-Id: <20201203205939.1783969-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH] kvm: svm: de-allocate svm_cpu_data for all cpus in svm_cpu_uninit()
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpu arg for svm_cpu_uninit() was previously ignored resulting in the
per cpu structure svm_cpu_data not being de-allocated for all cpus.

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 79b3a564f1c9..da7eb4aaf44f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -530,12 +530,12 @@ static int svm_hardware_enable(void)
 
 static void svm_cpu_uninit(int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, raw_smp_processor_id());
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 
 	if (!sd)
 		return;
 
-	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
+	per_cpu(svm_data, cpu) = NULL;
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
 	kfree(sd);
-- 
2.29.2.576.ga3fc446d84-goog

