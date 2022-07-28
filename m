Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621F258481A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiG1WSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiG1WSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:18:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E530D79690
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f5d66fcdeso27305037b3.21
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=dlAQ25g7cHOrtPCAbZedzQqF/rNgEGei+alqD2VO+U0=;
        b=ranUuoK5voHAwixMI/x/m9wejbxqlpuz1JUNeOylf+rBUm8WJMT/OqkOdy1q5Eb6Dr
         3JR7xS4Cb91uCyZl/BnVBFA6ZBZ70u24gdmu35wwVkYOEXskLd7TSLZ56bymQ3DBRgIv
         fgHzaKbKOA1SJTw0JcEm0LOA8ZuLsWaDMweTh2vUz4LgEPmmqcSkKNi59UYoyEP8Kchn
         6198Ja4Yxa/LKkTkcbmKL0dK0mfdD/moAs4VaaEnOeIGscD+r31xHr+OxH4CJ3UxRlPt
         5nzqwOmitScFftivZL4DtMG1BVSQ+cHmrF40SEyqoe/3E5VGH4fRXYJt6nWGRAubgjPK
         7Eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=dlAQ25g7cHOrtPCAbZedzQqF/rNgEGei+alqD2VO+U0=;
        b=ckYpMCE3LRFe4WAOlis8VsJHXel+7ZiWYzEYlvPKv92uZFwo6L1DJzMQPayKsKivj5
         aAt6TlcytXYcxV6+y74XzTH0+IZATFgL5IDA/DaOiqgLHEl7/bRb0v+aH6qiqg/vdxoe
         Xj/xd+ScqtUYT19jUQ7xszXQGYxsY4S7Nj3zLFlLzfZQyfcfnicaXxu5taXEdR5IXc7x
         AUVE58kfsS8LEpUAYdRx/eoMoIGrUJwgkEpZiNOQiDCML6in1Ik2az3X8v13gw5Yz+VU
         md/D03J/Em2TEZhDjz/EmPOhwr00eO9+9flqZ/mS9Oe6GM8r+ASLLoz9GcZXJxfjhKNU
         iB9w==
X-Gm-Message-State: ACgBeo39tB00DNsL6OR68Qci+DC9xuAHhhDC+v7pO7u+GOYqstDb3W+p
        mY/HsBESJXLFIcvIM1VkIHpxTAJzc50=
X-Google-Smtp-Source: AA6agR4I1F5vmYYMNMXJj9swMHJA4N7Yx/Yl22BHI4TcelA/kfsehihejzDsmTQCFZAm5dVxzayZxDkP9LQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2613:0:b0:671:810e:8e75 with SMTP id
 m19-20020a252613000000b00671810e8e75mr575929ybm.625.1659046687139; Thu, 28
 Jul 2022 15:18:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Jul 2022 22:17:58 +0000
In-Reply-To: <20220728221759.3492539-1-seanjc@google.com>
Message-Id: <20220728221759.3492539-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220728221759.3492539-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 3/4] KVM: SVM: Adjust MMIO masks (for caching) before doing
 SEV(-ES) setup
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
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

Adjust KVM's MMIO masks to account for the C-bit location prior to doing
SEV(-ES) setup.  A future patch will consume enable_mmio caching during
SEV setup as SEV-ES _requires_ MMIO caching, i.e. KVM needs to disallow
SEV-ES if MMIO caching is disabled.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aef63aae922d..62e89db83bc1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5034,13 +5034,16 @@ static __init int svm_hardware_setup(void)
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
 
-	/* Note, SEV setup consumes npt_enabled. */
+	svm_adjust_mmio_mask();
+
+	/*
+	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
+	 * may be modified by svm_adjust_mmio_mask()).
+	 */
 	sev_hardware_setup();
 
 	svm_hv_hardware_setup();
 
-	svm_adjust_mmio_mask();
-
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
2.37.1.455.g008518b4e5-goog

