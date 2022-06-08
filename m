Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD74544025
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiFHXvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiFHXvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DA216B2F5
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:51 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q62-20020a17090a17c400b001e31a482241so9520901pja.5
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Lg3O4G/p3alDqMbqQnMioPoE5UuKJkcpVmsl6CxKw98=;
        b=QXY7GJPFvn3UEeuRfW+ct86AJGsT1rKk3XiQ0GZXZaKVeVCdRfvXUGAeBiY+ndsu+g
         CdwHdw8RgVxXoubYiXTi+9u+GQdB84Bx0vearoEAE+c5BZYZsZ+6r+zNZ+qUaiswxoiu
         wfDu2tVUEiIkXg/GGmFxQVp4D/aKsH8ceXcvKe+sBR1YvSKAXfEq61O4g5e4t5Ow6VnT
         jX+U2DSds83R+ikAMfm/n9Fuy+NyMwOnUSMhHGqWijvFFzDn0+n+NVoPDqhpfs+takmz
         u+JtOwdIHMi0BSp+zRB0NfrXUGsxyjMCBy7z+Wlt7/dRoqWuNq3vOuKeKnJ6VMWTN3TF
         GRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Lg3O4G/p3alDqMbqQnMioPoE5UuKJkcpVmsl6CxKw98=;
        b=GlbcsW5FQ/J/cKkm1QOBqfF4liDDlvWrWcnNjQ5skr1uAW9VUdKqRjIfFKSg3EUkJB
         fh/TPYv58/cVDeLFQa5ADbbrsaOWd1dCh3MRptTrEfbowSg5gYYEwcNdpMts9UCL7jKt
         Ay6XbN5xfhBcNbS+m+losv+hfyVIuGFyBCF5DZ7K8wqQCYc5LCpGBI8YhLU1yVkJsu9j
         k/IiuICSZNAW6z20kCkT3aHKO9wzKL9Jrm+9tL53sFPnjl86rZttgRfsYl4NhA50aVC2
         oztELwOC3s5v0pUtCfV5LzY2q5vMUK9a3/W9KUdgo9JaLOrvcLpz613dwA+i9/aatlNZ
         62Mw==
X-Gm-Message-State: AOAM532ReFs+u5DueGdzdIuCGr2nE8CQv4l1F/xOtWBftoIw0eMqeuuX
        SXIP85yhR4VsBa/6sXylrV6ikVyKjBM=
X-Google-Smtp-Source: ABdhPJy19wszdEHJtuIBJV3A7i2/DK4lMqALq1fYazpAkh4T4KvrLSrITOSczVI7AZpRLsoKjaoTPEVTWjs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr11742pje.0.1654732370226; Wed, 08 Jun
 2022 16:52:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:33 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 05/10] x86: Provide result of RDMSR from "safe" variant
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Provide the result of RDMSR from rdmsr_safe() so that it can be used by
tests that are unsure whether or not RDMSR will fault, but want the value
if it doesn't fault.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 9 +++++++--
 x86/msr.c           | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index bc6c8d94..82f8df58 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -360,12 +360,17 @@ static inline void wrmsr(u32 index, u64 val)
 	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
-static inline int rdmsr_safe(u32 index)
+static inline int rdmsr_safe(u32 index, uint64_t *val)
 {
+	uint32_t a, d;
+
 	asm volatile (ASM_TRY("1f")
 		      "rdmsr\n\t"
 		      "1:"
-		      : : "c"(index) : "memory", "eax", "edx");
+		      : "=a"(a), "=d"(d)
+		      : "c"(index) : "memory");
+
+	*val = (uint64_t)a | ((uint64_t)d << 32);
 	return exception_vector();
 }
 
diff --git a/x86/msr.c b/x86/msr.c
index eaca19ed..ee1d3984 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -81,7 +81,8 @@ static void test_wrmsr_fault(struct msr_info *msr, unsigned long long val)
 
 static void test_rdmsr_fault(struct msr_info *msr)
 {
-	unsigned char vector = rdmsr_safe(msr->index);
+	uint64_t ignored;
+	unsigned char vector = rdmsr_safe(msr->index, &ignored);
 
 	report(vector == GP_VECTOR,
 	       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
-- 
2.36.1.255.ge46751e96f-goog

