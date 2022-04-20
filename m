Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9307508E8A
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381195AbiDTRi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381169AbiDTRiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B681201BD
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:30 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z18-20020a631912000000b003a392265b64so1393717pgl.2
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Oj7z6gF3UmFPqpARpPyMhAnqQVwNhos0ksWVaS2glIE=;
        b=BHW4MoPP2qr6KkJ/bv2IsG+E7kEQXfxOROPLzA/Q0FGDcoBzR8RG3LaCyDgc+N/VZD
         ebM5y3USor/huYodLjYAIrwk+3trvOyQqnp/3EC2drn0LDVzJNrGW8kjD8kAueuW1sCv
         9SqEOSQTgoVR5UMh2Ggs4IzpLD3upFTu8YsObU3SkgGfjoSNkRzyw7tiqIWKO/1y60PD
         dkJDpj3NgVL9l9i36GP4khKUbxDXLDKKaTmeZaADvtYr1NiPrMNl/FVAKN7Kki3AQ3VM
         SjFcdRFoq2Mzy+dyYsA+ZUCkiTDeAMTcmYg9Sub9vwJqwC6vKt9J4BIu5yhgMpo9WgPi
         Xn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Oj7z6gF3UmFPqpARpPyMhAnqQVwNhos0ksWVaS2glIE=;
        b=EuXjcmgh1XK8Lxdn31WtWi/ukdXwA+zAvKo8DacgPvY3z7ryvkPZLQrqeWy+K5rRcK
         oVhodz7zIry198+CPgNNUObEKkOUuclp41hb2h4U9WkG3w/Up7roFico75Xp78jrS4UJ
         I8bNaEbsOA0uC7AqGNYlEREW1nam2NBMHIRhj7wrXXXGW9ybn6pWCbVs/Ml26E9mAiJ9
         2f46jfcuFFzz2c+CkDutOFzcSk2GjlGwbfMuPBSOImJQGh+grTRCWsa42e7qw9rdB2ai
         UzlScVYFgVX8NOvoti43webuzOpy4kPod9wv2KkGCv9GFtlHS7umpxhuNX60emB7uCdB
         uz7Q==
X-Gm-Message-State: AOAM533UGm0jUe/Fjrjtc7DTQI4AVpZkMJfPnh0pue/yaKSLzkyZmOKT
        kpoCIxM4qFPe/Qlh2FdWU57YEuFtm5Mj
X-Google-Smtp-Source: ABdhPJzDSmuusSkVSzZvaX/pcqMXPsz/BlZMEv7jAS+fuTBtjfO8rwJ48kCEMy1Q77d2R6RIlL4rmKwZsKAJ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a17:90b:33ca:b0:1d4:d5ab:40b0 with SMTP id
 lk10-20020a17090b33ca00b001d4d5ab40b0mr3119586pjb.96.1650476129737; Wed, 20
 Apr 2022 10:35:29 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:10 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 07/10] KVM: x86: Fix errant brace in KVM capability handling
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The braces around the KVM_CAP_XSAVE2 block also surround the
KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
move the curly brace back to where it belongs.

Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..665c1fa8bb57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4382,10 +4382,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
-- 
2.36.0.rc0.470.gd361397f0d-goog

