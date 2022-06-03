Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C722F53C267
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbiFCApk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240113AbiFCAoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:54 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F880344E4
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y4-20020a17090322c400b001637287812bso3475428plg.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bT79LH/T6E4n1fLTC+jwsUR41xuHEOgcpCNU/PDapbY=;
        b=GFoSj2C5Zv8Iq17dJiZu0q96Wl1Suh9vXG1Ut7AlMixIeK1F0UzHlF2AMMQzmZMF4w
         moG70On5GwqpQXllDJIlBdObfNaQx3Ebw4JBcSiZ2sj+TvORlzUvGm4yGnKSn15SlD4Y
         27k3KNmWyfqts6J86I5ogHdSaFtrsZZjFF2Wj53EZANp4ZacxElrUVi+XB+ZU64YttoI
         PVrpfCUHj9xD2HSa+xpvn/A+r2Fldf9OYqQ/jFXTOoxp54bEf7RLk1jxElvlY9IH9rTf
         xqmZBNAgJFUduxLihydvjLTn7FzKRcZVBIq7/cr/bFzAXvQnVohzGTfGY1oVQYpqAPhz
         TVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bT79LH/T6E4n1fLTC+jwsUR41xuHEOgcpCNU/PDapbY=;
        b=SoJxReIxhCZyHEa6wHatK2RifgcYKaFmfL/9f3//DzsmKJ7+8pz0gEQNIGocygkqOX
         g0Bfg0iVx3ycIY9UMCqS++E8Ja0eVURbfysDKT5MvnA3kYRyu/J7DPk6xlYGqLo3a17C
         oBN115jtY++rS9umGcXRUtNlR5Dv2bBmUPtAUfTTYcTGa3KOJV/hR5euOCvhmtLS2mQ+
         kvUDq8kpfjjZRbyu8XwfMVr6rZ1MoZ0yw/DVoqA03wTp6IHZCaCw8p7aVU3fj2nQTVHF
         N3GqZr9eqToRNK2v9Rkij0vwJAnxczI+j3CIozVnwUUBTSmIFORMymTgq5SmGcKIaKf6
         ohnw==
X-Gm-Message-State: AOAM5322No9QglrlsYFceTtl6c5p5PqJtKykrJss6WuneX13cgxHXuV0
        3EAs/ozl2epXQ9v2t+CngbqWB6hzOHM=
X-Google-Smtp-Source: ABdhPJwVtPAXAcemPWEZpF8OkCe5Rhfl4bMfj3eoGH3W5yBUgiJaIUPKbTXCE4sgrHzW0vBUSqSQpa7dv9s=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c951:b0:163:efad:406d with SMTP id
 i17-20020a170902c95100b00163efad406dmr7642474pla.55.1654217076668; Thu, 02
 Jun 2022 17:44:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:40 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-34-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 033/144] KVM: selftests: Harden and comment XSS /
 KVM_SET_MSRS interaction
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

Assert that KVM_SET_MSRS returns '0' or '1' when setting XSS to a
non-zero value.  The ioctl() itself should "succeed", its only the
setting of the XSS MSR that should fail/fault.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xss_msr_test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 7bd15f8a805c..a6abcb559e7c 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -53,7 +53,12 @@ int main(int argc, char *argv[])
 	for (i = 0; i < MSR_BITS; ++i) {
 		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
 
-		TEST_ASSERT(r == 0 || xss_in_msr_list,
+		/*
+		 * Setting a list of MSRs returns the entry that "faulted", or
+		 * the last entry +1 if all MSRs were successfully written.
+		 */
+		TEST_ASSERT(!r || r == 1, KVM_IOCTL_ERROR(KVM_SET_MSRS, r));
+		TEST_ASSERT(r != 1 || xss_in_msr_list,
 			    "IA32_XSS was able to be set, but was not in save/restore list");
 	}
 
-- 
2.36.1.255.ge46751e96f-goog

