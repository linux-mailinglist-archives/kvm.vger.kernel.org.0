Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8A653D457
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350304AbiFDBXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350221AbiFDBWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A4F13E00
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u128-20020a25dd86000000b0066073927e92so4075038ybg.13
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Mfje/LGEsIL1Phc7prlzE2OIDnqfhuSW/tqukwpVxsI=;
        b=D3glnvYPbXr/z3GEfKzM+4eXG6LBrh6/RJH0PVe111Y26a4ttKlQ6AAMFb9Z+3izZ8
         kJhWLrzfivtnwfB7zEw6GjRRynu+w+p+DrmRQmNtrGF0SSZF3ycQMaa94bmBoswb6u6k
         22zr5Oa4iIfSm2D8i0T5tMGpdvUX6bG9QgM/HgJI4iaDt7JL9MkLZm/0hnpBRtf07TQB
         6cH7zN5WdaNp+t6zEOCMmzZ+OUOeq8RsVkUo7TWYvp9dFVeV3R+jRpUKRbQdbp87Vvoh
         n7OTM894lZ7i46UUNPOt952rkfPLjPr5mcFY0NBTt7VqDlsZ7Q+zHnLAnlzExbUUzCEe
         XEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Mfje/LGEsIL1Phc7prlzE2OIDnqfhuSW/tqukwpVxsI=;
        b=h1B1p68EqVfM8nrLSIj3aZSE5jnPwZh+hjnYfFEW5Zp6zeMrkAMwWh0RDNU1D+3iBj
         rRkvMUQ9iSWA+t1XiX8fkC/fVkKZlr5WOho0Fo/RJtiLwoALfyxBwSdnrAirP/JeSwZ+
         dQYaUIdMZBDzHVIJkBjKsJZh2pgou41jZKxexRc8I0mKzVyNJr+rv7PCLCjpldbdDaIg
         u+IZPeVKeDm1by7SAe36d4OrG15B5BG6zjQ8uXgj7AZAF166Bhlc7NYGpTlH8Mjnrg9J
         ktFqgkd3jzRNfOaLNE9hLiABW3fDRR+PgOOKOrBSGEMbQ5lrgKEPZw/Smz21qW6na8/k
         MKOg==
X-Gm-Message-State: AOAM5320bZkLDmwlfuTDm1caZ2jJUFSzf0T2hVgcsPoSExzgZaR4yrla
        Qje0I0xehOj+xOt9TzS/hEUyui8fAfs=
X-Google-Smtp-Source: ABdhPJyuu7qyy+NAD0XIM4dph2EYsRlc1nM27AAK2h4houaEceAl5McsPosj+Sh7NPGTrV6WgqJypRNTMaY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1146:b0:660:9278:80fa with SMTP id
 p6-20020a056902114600b00660927880famr6695754ybu.172.1654305708092; Fri, 03
 Jun 2022 18:21:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:43 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 27/42] KVM: selftests: Use vcpu_get_cpuid_entry() in CPUID test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vcpu_get_cpuid_entry() instead of an open coded equivalent in the
CPUID test.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 8723d73dcdbd..694583803468 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -147,7 +147,6 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 
 static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid2 *cpuid = vcpu->cpuid;
 	struct kvm_cpuid_entry2 *ent;
 	int rc;
 	u32 eax, ebx, x;
@@ -157,7 +156,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
-	ent = get_cpuid_entry(cpuid, 0x7, 0);
+	ent = vcpu_get_cpuid_entry(vcpu, 0x7);
 	ebx = ent->ebx;
 	ent->ebx--;
 	rc = __vcpu_set_cpuid(vcpu);
@@ -165,7 +164,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	ent->ebx = ebx;
 
 	/* Changing MAXPHYADDR is forbidden */
-	ent = get_cpuid_entry(cpuid, 0x80000008, 0);
+	ent = vcpu_get_cpuid_entry(vcpu, 0x80000008);
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-- 
2.36.1.255.ge46751e96f-goog

