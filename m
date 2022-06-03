Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EDD53C29B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbiFCAnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiFCAnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:43:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9374533887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r10-20020a632b0a000000b003fcb4af0273so2588892pgr.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uBJGXJghPokaEwyj/cEInqgPIVHXmOKBiWBIFEM2HE8=;
        b=SPT3bjMX3fn8/PM3Qzh/pG4k0Dz5u6r49wRmLSF5HvwEw8RVu6pMmjcXoJJuLdjSBY
         mCwZPKi7I5WNiIwcyK1Rb1TA9mHbCaoADvmV3EXgObt40bdCS18bTOvLxhquEtrxRvwr
         WnSeu9/2p5mWcW/3R4KLtUfSOwp2Klw9FvQu5+2FEV3YLDCu7nmjU+aqAeE8anP50kU2
         0JAHsXQMUqgcRCeTzoOb17QDaRauCUWFxCmb/1mhaftvBM7M8jM0qcATSAiByk2YctUY
         NUg4ftshZ53knC9m+pIxlhHnq/cR7UbKOpo6IobGUNeMfMOAmRh4ArxQWcNQyvxobsug
         fb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uBJGXJghPokaEwyj/cEInqgPIVHXmOKBiWBIFEM2HE8=;
        b=0aDI56+C3e+AMrgVZt2B+YWUgCHJjYc1Pptnp5An0DrHCfgbRXhK1OWPadf6PMFcWj
         uMi0cmkOQ9BK5ASar7+WOwi1NIzekMRVQrmHFi3dkz3+a4S5eMeEr5Epm8AZgjCoEXV7
         tvW1ZkESVBdi1a0UD++5/E8m7ZS15TGi2ew8zsYflIGSlJTfCaL6z7ThkeySYjlPuvKX
         XypxHxNhT4LB8o2V13JXyEO6mshsqS5AvqBIoKNrPc60kNEIYhpLsh+NoX2EojedyQLD
         +huZ4M4dQxejfUmNjE0qXvho0FeaB4rua+iiZU/MEvTnUteGqIHgC8geE/5hSoLO5UHD
         4/3g==
X-Gm-Message-State: AOAM531vS7VkENHolWX2Gs85YaairGLBFLnlSAD7PknDB7dwwzLDTPno
        7AAdhtuyKtxcl9rQAovY9Klg5HXs8Bc=
X-Google-Smtp-Source: ABdhPJzVihoLsJgs5GdDWHiehPJH5I0BkgDlQHt6TW97eJpcS3MryCANNqFocuOgczg3ov4E1YBaBrkP/nk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307282pje.0.1654217018748; Thu, 02 Jun
 2022 17:43:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:08 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 001/144] KVM: Fix references to non-existent KVM_CAP_TRIPLE_FAULT_EVENT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

The x86-only KVM_CAP_TRIPLE_FAULT_EVENT was (appropriately) renamed to
KVM_CAP_X86_TRIPLE_FAULT_EVENT when the patches were applied, but the
docs and selftests got left behind.  Fix them.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst                              | 4 ++--
 .../testing/selftests/kvm/x86_64/triple_fault_event_test.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5ffdc37cf7ca..42a1984fafc8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1152,7 +1152,7 @@ The following bits are defined in the flags field:
 
 - KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
   triple_fault_pending field contains a valid state. This bit will
-  be set whenever KVM_CAP_TRIPLE_FAULT_EVENT is enabled.
+  be set whenever KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled.
 
 ARM64:
 ^^^^^^
@@ -1249,7 +1249,7 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
-If KVM_CAP_TRIPLE_FAULT_EVENT is enabled, KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+If KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled, KVM_VCPUEVENT_VALID_TRIPLE_FAULT
 can be set in flags field to signal that the triple_fault field contains
 a valid state and shall be written into the VCPU.
 
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 6e1de0631ce9..66378140764d 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -47,7 +47,7 @@ int main(void)
 	struct ucall uc;
 
 	struct kvm_enable_cap cap = {
-		.cap = KVM_CAP_TRIPLE_FAULT_EVENT,
+		.cap = KVM_CAP_X86_TRIPLE_FAULT_EVENT,
 		.args = {1}
 	};
 
@@ -56,8 +56,8 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	if (!kvm_check_cap(KVM_CAP_TRIPLE_FAULT_EVENT)) {
-		print_skip("KVM_CAP_TRIPLE_FAULT_EVENT not supported");
+	if (!kvm_check_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT)) {
+		print_skip("KVM_CAP_X86_TRIPLE_FAULT_EVENT not supported");
 		exit(KSFT_SKIP);
 	}
 
-- 
2.36.1.255.ge46751e96f-goog

