Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFF6D698C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjDDQyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbjDDQyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:21 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D5EE7B
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y15-20020a62f24f000000b00627dd180a30so14941045pfl.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wjc//4jiaoefoMTIx/bjANejBqqk/+b96CFiQxU8/G0=;
        b=JcjIMNR0H/VZwjyJ7cv7eRvmEYOFq8+TA7O1ouYZR51HTOgxkVuO5pMHV//GlEgGyi
         tml6JQNQ6qleez34H6/CoOkIpGcfla/05Uv3Efmj3XZb6gqyce7fgB3npEONLcBsj/0n
         c7914AUMJvlDgyfRKs2JML2YtSbr2+RU7voNfZE6RWU9CBeILtc5g0uiMIyovprql3FO
         VE7rVVmWHDbtpcRWk2kbQ+H56/KAjgEHsLm8d06PN/fDhoQT8Qy1VeyuQOHRZCCY4uyy
         CLCElbOFl/aaP7JjrUDrbEXOPYdAiQ+RiRXQZ6TkWVWTs/b4ulav4f7TrAuoicIPMNhW
         vQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wjc//4jiaoefoMTIx/bjANejBqqk/+b96CFiQxU8/G0=;
        b=VuJJeCIV0f5J7wVyLVx3HL9/K6Hk9UDbZLHAzscxwzINbxgBC2qe/qa7patl4r4cmD
         dfL4ZCpy6FsXQ1jgnoWaYu2bE4oO/utFXxbAoU0e7SE3hqiQnbsAWp3v73Mg9pDo8/GT
         B/EVt0lplBsLOAHv/pDNmPqwPsFjMa9CgNCFqsewOVvwDkXAAB8uW+2pmT0op6D4tcPr
         oZ7E9g9d+g7tzoqd3JxRSZqC4WX90DtIpM1AcEzN67EIErWkGOvCx1nUq02wJsfalmT7
         3QxW5A2g/XYX4Pj/TyUzvdzIaRIiL74sjwR2Xh7KFan/q3N6gI/m/opu76x9R0B+3lsz
         dT4Q==
X-Gm-Message-State: AAQBX9fRRn1ha4ilC6dPPXmSHtD/NxdRWBjTLqnT+xMkSFiFaGnnN11w
        wk4ShrMfJHMjDoBU/4TLxq+lT0IFIU4=
X-Google-Smtp-Source: AKy350YRyoX7Zw/deTpZmrJhNvj7HooJbAgozKyPmu4JqGjwsuf+XUJ9VlMB1H8ZCM9q2bFerYd0M4RO8SY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:595:0:b0:503:4a2c:5f0 with SMTP id
 143-20020a630595000000b005034a2c05f0mr952596pgf.9.1680627239470; Tue, 04 Apr
 2023 09:53:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:39 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 8/9] x86: Mark the VPID invalidation nested
 VMX access tests nodefault
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the painfully slow VPID-focused nested VMX access tests manual-only,
as they add marginal value (have never found a bug that wasn't found by
the base access test or non-VPID vmx_pf_exception_test), and are all but
guarantee to timeout when run in a VM despite their 240s limit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index e325667b..c878363e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -413,21 +413,21 @@ groups = vmx nested_exception
 file = vmx.flat
 extra_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
 arch = x86_64
-groups = vmx nested_exception
+groups = vmx nested_exception nodefault
 timeout = 240
 
 [vmx_pf_invvpid_test]
 file = vmx.flat
 extra_params = -cpu max,+vmx -append "vmx_pf_invvpid_test"
 arch = x86_64
-groups = vmx nested_exception
+groups = vmx nested_exception nodefault
 timeout = 240
 
 [vmx_pf_no_vpid_test]
 file = vmx.flat
 extra_params = -cpu max,+vmx -append "vmx_pf_no_vpid_test"
 arch = x86_64
-groups = vmx nested_exception
+groups = vmx nested_exception nodefault
 timeout = 240
 
 [vmx_pf_exception_test_reduced_maxphyaddr]
-- 
2.40.0.348.gf938b09366-goog

