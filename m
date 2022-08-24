Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8137159F1CB
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiHXDFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiHXDEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:04:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C76682D21
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u5-20020a17090a1d4500b001fad7c5f685so140801pju.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=QS3GyiQHMtJaewExRFxiVXHtNgugPAPONAEB+gOLENg=;
        b=r6pUv+BDLLMr9gKlI4YQ1euEfADxHPXQIdjtVupk0sd4tRGqw1azZt9PJVzOCdDZ9v
         AUBkgq6sRb3oL9VEHnukNNAuGFR2ULSDG64liTcCy8Uk+qN9NnMxHwHiUYVrjc+W9BFx
         6XILwlG4JWwp6rQVtrHGCmr0lOMV97438+pKiEsTgdCT6wRRED9ZKx6WyUpOa3MXBVZb
         QeYxGaoU8XWNzbagMDBnD/D88jUQifYDT0SZvXWlTQocpHdAdVf/OP5j6h/b16DquHTI
         QkDW9M+Db2xFp4ll74NXcmZGGsXtBPl5Yu1dn6IV56Q3EcqJQtnsnHTUD0fkHZjCkeFR
         qpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=QS3GyiQHMtJaewExRFxiVXHtNgugPAPONAEB+gOLENg=;
        b=toBSnfFzMeA1skeY4yJHjXrjF21of2j0fsRkxRvnYIqCryikp3s483hwk6gR+n7sHo
         JK6QLU/IyFr16ZF5wskkeAsdtcUise0G8CCDFOC2Jq6r6oyqb8gn6NjTcHgYwSjsYZMq
         Hl1FiU3jiWJHOMFk+EC0a1EHZHA9t3SFXeoYlcW0+7hFZWNQjciCC+9mJM4yWIh9BXIB
         A/ZTtHipeUpVnfGoLP/uFDbIHeFIgmnX6CxkvqoBsDINiI4QDkecCzVOravgyEO39UF+
         KbhSO+PzHVVl5PQAM/ICBNiiLof3JUF+jKEa3B6l047h1VgTwFbfAtGdIY/Mv4yjw6Me
         EGFQ==
X-Gm-Message-State: ACgBeo3Dh3Z4PRvrBvu/qNemGZHDup+BFWbA63gyokd5dldmPNfAY1Fk
        GqTgBogjGeCyKx+OvxrgndMx8A/sbHY=
X-Google-Smtp-Source: AA6agR6YDxEtHHJCiqTX22qR6mH/9yT+ZMFpqKfaJq1K4XbfZDxJ51m2j/nzIsmo+zkdg6ysH7DTq2VJ0dQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr151319pjb.1.1661310155734; Tue, 23 Aug
 2022 20:02:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:35 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-34-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 33/36] KVM: nVMX: Always set required-1 bits of
 pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Similar to exit_ctls_low, entry_ctls_low, procbased_ctls_low,
pinbased_ctls_low should be set to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
and not host's MSR_IA32_VMX_PINBASED_CTLS value |=
PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR.

The commit eabeaaccfca0 ("KVM: nVMX: Clean up and fix pin-based
execution controls") which introduced '|=' doesn't mention anything
about why this is needed, the change seems rather accidental.

Note: normally, required-1 portion of MSR_IA32_VMX_PINBASED_CTLS should
be equal to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR so no behavioral change
is expected, however, it is (in theory) possible to observe something
different there when e.g. KVM is running as a nested hypervisor. Hope
this doesn't happen in practice.

Reported-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e9b32744e0d..4b8301137d75 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6588,7 +6588,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
 		msrs->pinbased_ctls_low,
 		msrs->pinbased_ctls_high);
-	msrs->pinbased_ctls_low |=
+	msrs->pinbased_ctls_low =
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
-- 
2.37.1.595.g718a3a8f04-goog

