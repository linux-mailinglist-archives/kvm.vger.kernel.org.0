Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF47CE7CE
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjJRTgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJRTgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:36:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B698118
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:36:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7e4745acdso112422467b3.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 12:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697657779; x=1698262579; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAYupYDi7ZgBrpbS0crO9kzm+ROt8j7biCCEFgYY3C4=;
        b=rKzCUT9QJ/a9qrTbSCFBiZCR6snApE87nBIc6I7j0ZKElFL44dYC0oompkS0n/3CK+
         I8GPADO1DztqYi/2HUhJ4Hgtf4ICoE/p4OjxwIy1fFfRBIH7OHQjA1b8Sqryt9Aqy/Xl
         o0EnRkza1LYVqzHzvFPO/GXB9AYrsG5YTWZVry6ijIqYLqzYlX8G1wRChNxufvfA1gFo
         wKMaxsapgCU6XhRR4TfNCvOrdpGOzf/fYYPFMmabtVqXiaM1UoU8vT5f2GA9Ym5kKJeE
         0bQ56wQgKojNhG7evZlCE6Z3tLCHCXotO/2a813VwlE1ePWAkLrgsMjF/kPXhepc2Q3F
         4DyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697657779; x=1698262579;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAYupYDi7ZgBrpbS0crO9kzm+ROt8j7biCCEFgYY3C4=;
        b=J773Lo39q90VhbtgXSTf9bw/BlqXtsWlxmFt0ceHtdMfX+nRlYQWUZSF3ioRKr01Jf
         CLkbVsuLdmi46hVCP23jNypSq0nLPYF0Hc3AqHd/arQbBT8tk+I/KGDKte7JfeBc5G1J
         0Z7xEpSHRPOK19LoAIjyHijeUUQ9TyLBz1O73DBCmplYV/X+m720b9/FH5eRGdsrPmVf
         mWiHdBdv7E3AhWGUYWKyexxITq88K3RLWgyXnAtC950cqhCpQnYn7NaztvN56/M1PulK
         L7PAklvGMFHpG1rkh4aVgw4+f5MWTiJa6LObSfbsvhdkVOE3attX5/rqLgq/b9AGaxuJ
         tuXg==
X-Gm-Message-State: AOJu0YzYA2o261r+dzKkqF2oDNdDto08IZmrWyslbNAotobWzgSFfuyh
        KFdrGZv+8RdDe1H0okvvPdofoWm9CwE=
X-Google-Smtp-Source: AGHT+IHpKe/BK4Ew2tPwGz7dIt+Esd9cYH2BfIKiQOgvI+kJXTrt1OpFLwPeDnJ02mISbxkHJgBhceEdEO8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2386:0:b0:d9a:ff08:e090 with SMTP id
 j128-20020a252386000000b00d9aff08e090mr8611ybj.5.1697657779565; Wed, 18 Oct
 2023 12:36:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 12:36:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018193617.1895752-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Explicitly require FLUSHBYASID to enable SEV support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a sanity check that FLUSHBYASID is available if SEV is supported in
hardware, as SEV (and beyond) guests are bound to a single ASID, i.e. KVM
can't "flush" by assigning a new, fresh ASID to the guest.  If FLUSHBYASID
isn't supported for some bizarre reason, KVM would completely fail to do
TLB flushes for SEV+ guests (see pre_svm_run() and pre_sev_run()).

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..d0c580607f00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2191,10 +2191,13 @@ void __init sev_hardware_setup(void)
 	/*
 	 * SEV must obviously be supported in hardware.  Sanity check that the
 	 * CPU supports decode assists, which is mandatory for SEV guests to
-	 * support instruction emulation.
+	 * support instruction emulation.  Ditto for flushing by ASID, as SEV
+	 * guests are bound to a single ASID, i.e. KVM can't rotate to a new
+	 * ASID to effect a TLB flush.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_SEV) ||
-	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
+	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)) ||
+	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
 		goto out;
 
 	/* Retrieve SEV CPUID information */

base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc
-- 
2.42.0.655.g421f12c284-goog

