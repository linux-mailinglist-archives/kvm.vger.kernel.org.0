Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D2A54BB79
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358124AbiFNUKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357901AbiFNUJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE844FC61
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902d48400b001640bfb2b4fso5328372plg.20
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8CAKrp2Z8ftc2PspLOtgMbM3jnTmjfGGexJauokjvSQ=;
        b=LP06UuiX73tTu8Qg7T/691M0mzRF0kjN7OVbuQAf60HJbvRNImjYmbTOvJYQZrPnIR
         YWchqRCu1wHbGDsqBAj4Nl++xVMEaSQ8CUiV0f+OiEtR/fcUsS0FO4DXM28zelnF0wwF
         PfmR4ND+Up9ZHuTmUDagxP0ie0CkptdavgZlT2Wd4zNeb8JCAMA9RZzBenxoiQsPPyEW
         XktGDJd74lyIul3dbDy77GyVJ1ndKWcqKg4VPfmz9Q22YUhJARZ2Bg5zHVnIIxvl4JLi
         /l34r20C0uZv7sYs6QHEn9eCI5q/RMw3lEQpAaR7RGsmOfd4hq4CDFgPQxuW4hyZtpLx
         ozOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8CAKrp2Z8ftc2PspLOtgMbM3jnTmjfGGexJauokjvSQ=;
        b=dZ3VibtITE8C4CbjTOG4T7iSBEaSRa89fpV+dMOmIQETa20l2tdI0FQH5AGCDMxH53
         Z48T3HDcBSLre2mD2VO65LMbO3MCVS30xi0M+JrqO7l1ILntthQCQr9Da2Zux6IjK4Vn
         I4jJDx1V5oJj054gEfATa60w8R0pDGC4KLyi+shmbR+CzO3ILOd8iq9EYWN9AmLReKiu
         aii+/IXyy4l31oZi+pBpiaarvxTemdO6xVS9A9V9AMjsnSRMXRsaTIVb1xYHGo1yCCMu
         0JMakZG9F98D7tnH1VyDfZ6JLN+8QLHbHvuGvjWBqM89cqWrjKACM+hpZ/OgQy0kcQZB
         JNTw==
X-Gm-Message-State: AOAM5328kQImqADnb0gM5jb+iDJOqY7Ex1snnMM+r4BktNEPiI7Sg6J5
        Onmr74uxbZlP0m8OYhX+ZvDZnj+rPNk=
X-Google-Smtp-Source: ABdhPJyddL2Xxx5Ba016b/xeNk7X22tFDKDeOdgQTAwBpplAF+EoXjNwbLs8Vcen8+EViIVd2cuCdJf/qKI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:990e:0:b0:51f:2b9f:6402 with SMTP id
 z14-20020aa7990e000000b0051f2b9f6402mr6299117pff.9.1655237297066; Tue, 14 Jun
 2022 13:08:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:01 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-37-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 36/42] KVM: selftests: Rename kvm_get_supported_cpuid_index()
 to __..._entry()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Rename kvm_get_supported_cpuid_index() to __kvm_get_supported_cpuid_entry()
to better show its relationship to kvm_get_supported_cpuid_entry(), and
because the helper returns a CPUID entry, not the index of an entry.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f56a3a7a4246..311ddc899322 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -697,15 +697,15 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 	vcpu_set_or_clear_cpuid_feature(vcpu, feature, false);
 }
 
-static inline const struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_index(uint32_t function,
-									   uint32_t index)
+static inline const struct kvm_cpuid_entry2 *__kvm_get_supported_cpuid_entry(uint32_t function,
+									     uint32_t index)
 {
 	return get_cpuid_entry(kvm_get_supported_cpuid(), function, index);
 }
 
 static inline const struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_entry(uint32_t function)
 {
-	return kvm_get_supported_cpuid_index(function, 0);
+	return __kvm_get_supported_cpuid_entry(function, 0);
 }
 
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
-- 
2.36.1.476.g0c4daa206d-goog

