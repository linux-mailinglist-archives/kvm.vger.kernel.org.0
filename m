Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87F232F7AA
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCFB7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhCFB7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:36 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B213CC061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:36 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n10so4552440ybb.12
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NWzT6+P7p4/sUIe9XHdasSuODaqOkSi2l3PNjG1rnfk=;
        b=kPfIiRtGt8cq6ra8u9ESs8+07GY2Q0m4XuKHrUAiwKH0P1X5UfvWdK7s4PdAcd7p8R
         WootahZCD7fSlJk7H6aqz/i9LtrS2CldioGtkKOmw47k43rG4rqFJrdctVpqJHP2AwkV
         eh4atL6Kvt9GRZ2AwvWpxX+2yZeSwBPPIicEJYhuZS5yOYsTlFXuqYXT5SmNppm4YnkK
         WEAVh4zM0iCc007Hw/gP8hTB7BVC7hngufYCXjJrM9FYIScdktBZmrX1se0w6zC6DblX
         rGmkRxMsUCmI2pv3JG2FiIIM9RUa325AqaXPFP6WIKa09cuJY4Ui82iWV6qun1gEvx5+
         LT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NWzT6+P7p4/sUIe9XHdasSuODaqOkSi2l3PNjG1rnfk=;
        b=ufSjT2r79wdeHFhOx6ibaMpRB9EHSNNmeGKAWDsCTqmaqOmVLH0Bz5QWaFmsQBAXEA
         1ztacKPyIH7f+YzroDV5rE7NhGkEQS4ztkJFHOPBPdboYYFEbLV/bNv2Z+Y1bvv35KrY
         +U74/P4I8HWclHX350tHlR5IrFioaf7mbOn685R0pJ5b40M2n5AA/OlrH58VmTOfBpiQ
         yH0JJ2nNBUa7qdDF1FPP8szLyDXNCtZ/uoMGQ0u5B8alh2oaRfnBEOMMjQHdT8sFs91e
         lOTpHdbEVXDK7FLcgXXN0CT2qpaALxwvTMmkx2HX/oFJ4cL13ceCuQjU6p+HT0hXyRbf
         MlPg==
X-Gm-Message-State: AOAM532hj8zvcwAoqu5NG5IVfc7BzJ2JHnoANu7S5eH1XPvvHYpCUMWS
        Eq2qyw5KldKyvN2+PEbh3oNTJ1Cqr5U=
X-Google-Smtp-Source: ABdhPJwg6bBMBbtpuAbub7YVqqScV8UR0er/X4Sae/H9A0cZkKDujKTJ+wKTYmXwMB4x2TBl0GMf2HA9HrQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:40d8:: with SMTP id n207mr17698269yba.3.1614995975964;
 Fri, 05 Mar 2021 17:59:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:58:59 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 08/14] KVM: SVM: Enable SEV/SEV-ES functionality by default
 (when supported)
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

Enable the 'sev' and 'sev_es' module params by default instead of having
them conditioned on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT.  The extra
Kconfig is pointless as KVM SEV/SEV-ES support is already controlled via
CONFIG_KVM_AMD_SEV, and CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT has the
unfortunate side effect of enabling all the SEV-ES _guest_ code due to
it being dependent on CONFIG_AMD_MEM_ENCRYPT=y.

Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4b46bcd0efc5..bed8fee6c549 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -30,11 +30,11 @@
 
 #ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
-static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
 
 /* enable/disable SEV-ES support */
-static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #else
 #define sev_enabled false
-- 
2.30.1.766.gb4fecdf3b7-goog

