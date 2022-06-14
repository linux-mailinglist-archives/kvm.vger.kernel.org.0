Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8554BB39
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358180AbiFNULF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357981AbiFNUKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:10:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1154FC75
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so4220273pfa.22
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=o3z+boBvvuABIlKxvViYzVtbgDDM2QmQlL0qvBp6XMI=;
        b=IzAQAcpsNM1EVPwh75OuwuNE/EuroO7nOIrXJjywOj+SCFXcrreHAx5p2O+bIpTR80
         cLB5h07YA92d8XsSI63WQMa3fMaUjrPwcz6h8AGS589ZG/ZVusDCDkpHUgFmv3DOsVXU
         ArEeQDWBXSNufx8+04mkDV0Uf2Z1szeuhWUGnmJsm8TY02BY0A/aUXfMmiksIFnB13uZ
         y/VvHvNTR4tby1DhQRQQ25HTuezE0zLe8IogrR3V93XM6nLh4IuCU59Rec5pzMjhkuza
         QRou5yQzqxFuL0lecIDavFmQ6mFujZLcyR9hIKuDtjsgPOvYDY5xnd2Rl5krMCXbQsSy
         dgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=o3z+boBvvuABIlKxvViYzVtbgDDM2QmQlL0qvBp6XMI=;
        b=OQFjvox0ryN4kxQ2ITCUVCyB8ddaPYtxduxBzhL8JF6+v8WteiqS7M8GcWtjamXfRZ
         1vXpJEciOHNkcQCFPRhaFVQqacViFXZ0Gst/viWKKrrVjBteK+wmaupq5zYgSBR/mmGc
         3tusOQMHRl9QIUv7uB/4Qtqpt52LwGSMZmawNpkSA2NeMYlF2/KowbViW0wed8rC4QGJ
         73ecR6GzvSkbDmUqX0SMVz4WED9occiVJZ8HTfHNKqaLUwo7gXE+Q1k4rzCtrQPEnG1e
         q+vj1F+5qCyNbKO7Vd2VV2gXtgfmFJ1nXh3wccMCh7rHe/fevLzvUCK4p2tB6u3FMrBM
         +yGg==
X-Gm-Message-State: AOAM530rtConzm3YGvScyuF5G4SQ3s9sRKQeiyHYDlXOUS+gX8SeC9l1
        MPtYal5CkLKF/kxrdQjkazh25G2KY90=
X-Google-Smtp-Source: ABdhPJyOHezLBoiZzom/lI2EvhUINKbJYNeT+S59G7Bjs/W8A1gXffmixvdqvPkhIBTuTJWpZxVe6PI2LVQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:6b02:0:b0:3fb:da5e:42a1 with SMTP id
 g2-20020a636b02000000b003fbda5e42a1mr5911425pgc.273.1655237298696; Tue, 14
 Jun 2022 13:08:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:02 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-38-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 37/42] KVM: selftests: Inline "get max CPUID leaf" helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Make the "get max CPUID leaf" helpers static inline, there's no reason to
bury the one liners in processor.c.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h  | 11 +++++++++--
 tools/testing/selftests/kvm/lib/x86_64/processor.c    | 10 ----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 311ddc899322..fd0da7eb2058 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -719,9 +719,16 @@ static inline void vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index,
 	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_SET_MSRS, r));
 }
 
+static inline uint32_t kvm_get_cpuid_max_basic(void)
+{
+	return kvm_get_supported_cpuid_entry(0)->eax;
+}
+
+static inline uint32_t kvm_get_cpuid_max_extended(void)
+{
+	return kvm_get_supported_cpuid_entry(0x80000000)->eax;
+}
 
-uint32_t kvm_get_cpuid_max_basic(void);
-uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 7bce93760cad..522972e0d42c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1056,16 +1056,6 @@ bool is_amd_cpu(void)
 	return cpu_vendor_string_is("AuthenticAMD");
 }
 
-uint32_t kvm_get_cpuid_max_basic(void)
-{
-	return kvm_get_supported_cpuid_entry(0)->eax;
-}
-
-uint32_t kvm_get_cpuid_max_extended(void)
-{
-	return kvm_get_supported_cpuid_entry(0x80000000)->eax;
-}
-
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 {
 	const struct kvm_cpuid_entry2 *entry;
-- 
2.36.1.476.g0c4daa206d-goog

