Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46A53D48C
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbiFDBWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349943AbiFDBWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E1340C1
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x16-20020a63f710000000b003f6082673afso4560323pgh.15
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IuS7bySLaWk96Nr3FGWjEQAo2Xsg0Uk+ZK8PKSv3jks=;
        b=tPq24DSwyTk5KSO20RDyya7f7yw8xQUbzDozzJsWDZxJdkHTLXmnATymku+8QAns/W
         fBwDfz9KAcO+cqN2Wssbg4VFRtfuMCunAJp5TfF3YqdBOjrzSP9et7q+PXF+TMU7LfLn
         X8tNemgrW3H4Q1z7f4pDazmxOgdWAcO0ctu1dcTWIlOIqS1G+WE3wB4YEH2mUzmf/7kR
         yBehsBBnSl5U5dxKH5v31h2gJQIFFZbtWlHJYPaVah7z+9fWXamR3GxfhwOFHzgMat1A
         ZimjzClQOBmacr7zPKTACaVruoD5OEPiZjgi3GNlJsZbhokfspa5ezz0wi2xECEYueDb
         Pyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IuS7bySLaWk96Nr3FGWjEQAo2Xsg0Uk+ZK8PKSv3jks=;
        b=1QhAyh6S1bHYZVrnuG4hsTuLQEJyhPBFCm9uiSMMy+2wXHvFb1lI0+cjYMzvDz9Kah
         aYHcHsIrsNycDIPvVcevW5oK+5FVh0Y9fa7Wc2AeXz5pMk9BzUJhbL/9J47A8Vbi0UAD
         FxkBd/G2grkY9zDnEGqnaAjVK3j8uMn6ANEX5JAbeOeFj6iOhCa/LGyakmzeh44p/qIQ
         2WCsRJtOHAx+ppwnx79902AcRhLxZs0jUuOLyIBSlKJOdsXqCL1CLfnM7nI3y4o6nHOn
         8WlEV65t8SlITiruQN+9FHPyR16SkuVx5myes1dSjkJERv6kRAV6k/1/DXydhCfUgQTh
         a9jg==
X-Gm-Message-State: AOAM533EotQGMK+e2ieCeLWgYIRvgsKybqyAnmHgyQZfNY/5XBweCffE
        Pn+uuDvJ8yAGr/Z+VHz/a5v7KKzxowQ=
X-Google-Smtp-Source: ABdhPJwuClwILqT2Dv4zyXmcPWZI77NL7R+wjQnwq488gAhRaMBLpiUAi+6R3tHak0WA/bKbmW7OOLU/6CM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr4623pja.1.1654305693476; Fri, 03 Jun
 2022 18:21:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:35 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 19/42] KVM: selftests: Don't use a static local in vcpu_get_supported_hv_cpuid()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use a static variable for the Hyper-V supported CPUID array, the
helper unconditionally reallocates the array on every invocation (and all
callers free the array immediately after use).  The array is intentionally
recreated and refilled because the set of supported CPUID features is
dependent on vCPU state, e.g. whether or not eVMCS has been enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c252c7463970..ae40ff426ad8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1289,9 +1289,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 {
-	static struct kvm_cpuid2 *cpuid;
-
-	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	struct kvm_cpuid2 *cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 
 	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
-- 
2.36.1.255.ge46751e96f-goog

