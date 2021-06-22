Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC83B0F20
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFVVD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhFVVD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:26 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90695C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:09 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 2-20020a3709020000b02903aa9873df32so19611018qkj.15
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XDPyuP+76sS7H1b65gbiCra1bWwUEj/k7PFZqKhwftA=;
        b=lirgx8idx0D0/y+AcNZE/SLGdB5CrPBxFGt++QbwAU0JXxOKj1N/byVmAS4gKrvCaN
         szte26D+uI4T9QtT1XkZ/XpixZgakNA4lcQDlh0rZ+/BkIIb2HvAQzRJS/+cJlV6NFc4
         xixCY2IzqKffwYALZ1nGQW4PwXKAxzfremTRfmhvT8YvP4DYV0qZ53vgVGvoF8jp0Zz4
         jFIPSBWgidNPQ5VoUOv0Joe+Gw+avhspAeFMb2a8lcOA9HpjQxnfKAOa5ng3k/dpx6yS
         5VqVwJkDTCN9myoiKt3KHCbR6WkQnSvGpAU9YFkvGyrydViwrhfboxCybbCuEbho13AC
         SapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XDPyuP+76sS7H1b65gbiCra1bWwUEj/k7PFZqKhwftA=;
        b=bQXOxbFdnQ0TW9tqw/kLvlxlzkrT+aXabZvDQaYzWUQX0nRBgv0jNoHCJZN9OFeqaM
         NjhbGV7qCwPkMEF7ziMNymZwL97M7xGmo8R6Yy2iCQ5+SzDUpGlORpZtXPdGtsTmvnaD
         0EsyqJQntET2j9FLj8SLjSQRc6Z3YGbFHTYfGaBpSITe/GzJRLsrr9A9rvqLURaG5DSC
         ZEyugmk30p6JvxX4IziqGymfhwFReoG0Sw/ApvgfHivroq4ZbsB2wcbf+U7tUq6hJ1HN
         bhPOzXyZ7dEgMAg283sTFOuu//KWqedpNmSMy4dy/26XBuFQjeUJQXgqO5kYOhDy90zs
         sdXA==
X-Gm-Message-State: AOAM533GlhtFH5llU7TM88fVpcGBRelXxS3/SAQJUV5FVnc85U/VGVZT
        tan8+UWzxcoGlOXrn6R/oifG7aTAEBw=
X-Google-Smtp-Source: ABdhPJwcab6N00Jq/84QvqMB5Z0L0KDVBDUimNQe/HCvCdVcnKeXaeOEWZ+MH8doUYTBQDlZmV7s41UVvW0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:80c:: with SMTP id
 df12mr834477qvb.18.1624395668731; Tue, 22 Jun 2021 14:01:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:43 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 08/12] nSVM: Clear guest's EFER.NX in NPT NX test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear the guest's EFER.NX when testing that KVM supports the NX bit in
nested NPT.  The guest's EFER (and CR0 and CR4) should not affect NPT
behavior in any way.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b1783f8..fdef620 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -705,6 +705,9 @@ static void npt_nx_prepare(struct svm_test *test)
     test->scratch = rdmsr(MSR_EFER);
     wrmsr(MSR_EFER, test->scratch | EFER_NX);
 
+    /* Clear the guest's EFER.NX, it should not affect NPT behavior. */
+    vmcb->save.efer &= ~EFER_NX;
+
     pte = npt_get_pte((u64)null_test);
 
     *pte |= PT64_NX_MASK;
-- 
2.32.0.288.g62a8d224e6-goog

