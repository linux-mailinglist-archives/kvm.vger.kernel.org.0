Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01AC5A72BF
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiHaAhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiHaAhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE43FAA35D
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e16-20020a17090301d000b00172fbf52e7dso8950953plh.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=/40liOollMBH1ZRbQ+xHU8ilIurWaxIwKYg1b454SxY=;
        b=aZWV7k7C0KKRCKubddCf7VMQ7bDDSvLw+GK5/Mbn2MjsfrZNnShKbKB7/WZF/1d4+g
         RSS9cgiDfUkGsw9+THoUZXFeDvZG3WUzFqKpkR1es1FzfsDltZfj8VnUjOA/qkwlElKK
         kCjYrqmwNno3LS1nUXtDEPBlP8D65C7ZxDOlYg2v13ynC5yh2/6U6BSusIfgvHtqCytA
         CZaTkKk1LzUdIPyq4Qcly6LPmsjBAnsHrK1+Z42tfnAyQA6gGDnxvtBG5L7Kd/WNZaS2
         BXAPCd67Krn93Dh380aNgu9fHk5I+vP35KdYhdN/2Hxisnvxm4V2vn6vRQ0ipYApwsMd
         jYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=/40liOollMBH1ZRbQ+xHU8ilIurWaxIwKYg1b454SxY=;
        b=fDDiwctZAioOd3MGOyJkQwA8qXoYEdRLyT5nInDee6+Iti/cZe6/4zHxk500raheT/
         eTRLhXx3evKU2BGmV1E7GO5tjv1CEdPQOkuXzftIPSxJ+R3fbkiEXNWelFrK5EhVHHyf
         VWficFsVRSeU27YD5C6Y5nLvcCGT+K1op4dM5vtztlq/3eVTwXmxIWljanFOD9Fjw07f
         1PPHELiFFdEQmvUCu4nbR73mNNEG8a2IohYqEEpQKSCosRxGGnxUyBlqRGtLwZZZ7JRD
         m0LwV0Q/US8+A0WhX/uDgxjGX4UzsS/6FvbOSo98Ic72dM6h2obmwUijeLkKwbokti3W
         AZfw==
X-Gm-Message-State: ACgBeo3GcdE/oJvGFQpA4sMhYWnD/bhYPVKgqiUABxuRMRy9vajDoilK
        N7/M7qZvryZdu6Nb8GgBDzFcu6hs/F0=
X-Google-Smtp-Source: AA6agR73Eip8P/5C6mv8DnUy/A1DO/pS8BJ7VyLRc7c1lmsipWaiHse5sS9+hxiWtTXaWi/MpZvwYHIr0bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10cf:b0:528:48c3:79e0 with SMTP id
 d15-20020a056a0010cf00b0052848c379e0mr23441121pfu.18.1661906121153; Tue, 30
 Aug 2022 17:35:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:54 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-8-seanjc@google.com>
Subject: [PATCH 07/19] KVM: SVM: Drop buggy and redundant AVIC "single logical
 dest" check
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Use the already-calculated-and-sanity-checked destination bitmap when
processing a fast AVIC kick in logical mode, and drop the logical path's
flawed logic.  The intent of the check is to ensure the bitmap is a power
of two, whereas "icrh != (1 << avic)" effectively checks that the bitmap
is a power of two _and_ the target cluster is '0'.

Note, the flawed check isn't a functional issue, it simply means that KVM
will go down the slow path if the target cluster is non-zero.

Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3c333cd2e752..14f567550a1e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -411,15 +411,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			 * Instead, calculate physical ID from logical ID in ICRH.
 			 */
 			int cluster = (icrh & 0xffff0000) >> 16;
-			int apic = ffs(icrh & 0xffff) - 1;
-
-			/*
-			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
-			 * contains anything but a single bit, we cannot use the
-			 * fast path, because it is limited to a single vCPU.
-			 */
-			if (apic < 0 || icrh != (1 << apic))
-				return -EINVAL;
+			int apic = ffs(bitmap) - 1;
 
 			l1_physical_id = (cluster << 4) + apic;
 		}
-- 
2.37.2.672.g94769d06f0-goog

