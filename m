Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A431653D493
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350140AbiFDBYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348977AbiFDBXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:38 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7112FFD1
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 144-20020a621496000000b0051ba2e95df2so4720499pfu.11
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lWV4XxAQvtLDWa2n9sU/+Ng/xr6r4/W2FZ+RD8jHsW8=;
        b=pr+wWRe4GMnyYbms8mLJXpQ81expnFnSAA0vIhEn39IdHEZVE+uKJmZnzhwEO6d5bg
         9jx4XGUBFdaxX87ij2BFaHP2PxM6sOE+ujU9rZ2ltljvlqb60kZWEUA1tQYi9RllK/PC
         9Kd0YcUMZxdxJ54eX/Z30Wb+OXsHo5GDudAq9DObmcybrPce5hKtnUncJ0ohEQ3YOpP/
         0LscbI9J8m0/FofNyXnaGMabv02ch9FpiVNOSJ3QZ4TYRKD4o2/NyMSgvs7LSfozUmbL
         PwPXb/NAkdCW9zLemXfaxBk5gHZbsafOSAxt39DZghh3+jOW2pbwJQalRhBnhafaZX8i
         XcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lWV4XxAQvtLDWa2n9sU/+Ng/xr6r4/W2FZ+RD8jHsW8=;
        b=kvhXhbyJ/DZuJujCQK8PDGp+XNSbOK4KRiKKg+ArwjKoML8Vj1gEt/T7T/s7BWOkvf
         28HnuZ+MTQKqRt25degVKJzL/Dyv+wUVYVw5s4xpEDsxVBCAgM8No4n0+JpZxVe4MI5G
         MNiRTDOqYMd2QKxd3CO2PC/fymsVCRtwex+2vPX+XLB8lu8Kpjx88wRLt1aO/enBJaFx
         Z3vvBtkhhC/Xnzve6BCQyZcaMt/1Y57+jFNvYnAUt3UzIwHeLcBKDFJwXmJDNeVL/NKF
         fAvJ+bkUhmM6ilOnxUCgJqQZhCfB8M/leYIr41OlbGl5Mht8mNVH3F+Rb7kBXtHWUPF5
         OY+A==
X-Gm-Message-State: AOAM5313bxXgAya+dxj7NGWDfv3vBfWJiKdjOqmGSLoe6egUJHYGXFDZ
        7IAc5NhJRy/2ci9oGUAq/xLCuZrOzHg=
X-Google-Smtp-Source: ABdhPJz33S1yjm2idJ8lnaWSE4xhl4nxGv29a7i4KIV4TrX+Yq5aJj/G2Lur+mmWw7sonU2o73vNWaq8d20=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a8b:b0:4e1:52db:9e5c with SMTP id
 b11-20020a056a000a8b00b004e152db9e5cmr79230988pfl.38.1654305729378; Fri, 03
 Jun 2022 18:22:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:55 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-40-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 39/42] KVM: selftests: Skip AMX test if ARCH_REQ_XCOMP_GUEST_PERM
 isn't supported
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

Skip the AMX test instead of silently returning if the host kernel
doesn't support ARCH_REQ_XCOMP_GUEST_PERM.  KVM didn't support XFD until
v5.17, so it's extremely unlikely allowing the test to run on a pre-v5.15
kernel is the right thing to do.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f1290540210d..86e610967e79 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -602,14 +602,7 @@ void vm_xsave_req_perm(int bit)
 
 	TEST_REQUIRE(bitmask & (1ULL << bit));
 
-	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
-
-	/*
-	 * The older kernel version(<5.15) can't support
-	 * ARCH_REQ_XCOMP_GUEST_PERM and directly return.
-	 */
-	if (rc)
-		return;
+	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
 
 	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
 	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
-- 
2.36.1.255.ge46751e96f-goog

