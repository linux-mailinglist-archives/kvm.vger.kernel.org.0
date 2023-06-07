Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6A727079
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjFGVVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjFGVVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:21:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AE21984
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:21:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb1e332f648so11012918276.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172873; x=1688764873;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Unqvj8+H+sllfGMXcOilGhAvcJvAVb4prt4X1drRl2w=;
        b=b/vLJHmaXzwxNl+NCPntkz0xdkBHlww/WmTgrebccm+mhs6/dVm6bQkE4GitZyQFgR
         OXyafm2+yppGzoRiRQaJgG5AmYolgywzpc10q7CmcKTDysZV6TVIXM6/j3OtnTukNcEp
         GHbkfVm/g07aFRY9eIr4E42F7uDW8ZWv4VtQ1+M4kHqILEPRLJTdbAU8n/DpY1ebSKhv
         EJY2HvngJSpm7vOAY/Bvzc9taj+x8Taiu/99Hr7GCDeFDlzDMjLLO8VJq+OoYmqWGGko
         jv9bP5pPR/DqU5IGGTxR7ZqqZABnVHKHZctLxbiOc1bAH7cslsuUmDb83K81UICUkS/L
         ApQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172873; x=1688764873;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Unqvj8+H+sllfGMXcOilGhAvcJvAVb4prt4X1drRl2w=;
        b=aI//8diMIy4V2IEWVXUkItdv2lUoRW8yyRGpqP7YHM/U63Kw7gin6ysY8x+qZgCxzh
         nLp/oxUBh2qJfsIAX1e+/fQWsQ+zUgbfid+F3AhiaPaxmugFYGTvPsZyRnQYu6nZ07uD
         MEwUlP2aIyLCH+RwnlM3UdfKzr1uwSivGZS04YBmbrvCwjz3z+/N2p/s49yg+crzQou1
         efd5Xv1J+6b8V5pu07eadS+JgdgMylFKB4ZapRWd/pZcM7saAL3gb9umAAkwvcMI0iiR
         jOTEj2sGdL8C17A3hZni0XBQWhC3AzKBUlMnvfMlWTMloEjP22/Hkm2X25pam8Xe/Un5
         ROdw==
X-Gm-Message-State: AC+VfDwZXq5vsOD3ohl76y5sbUcdy+OUTNL/LijMIxNI/wpte29fRWV+
        G/8nvpkx9HzpAv/47j7d9mVRvhK82yw=
X-Google-Smtp-Source: ACHHUZ4zDB3P2c2M4G4oMkYp+uEYPtVZ4Z7xZ1DpY7uj9C3tMO3SygsJU91TB1QlabHYMIEjeyAbuw0BXIs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:686:0:b0:bad:99d:f089 with SMTP id
 128-20020a250686000000b00bad099df089mr3739624ybg.8.1686172873665; Wed, 07 Jun
 2023 14:21:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:21:11 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607212111.1579831-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/pmu: Truncate reserved bits for emulated
 test of full width writes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
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

Mask off reserved bits when stuffing PMCs with full-width writes in the
forced emulation subtest, otherwise the test may fail due to attempting
to set reserved bits.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9cf..d92bd8ad 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -498,6 +498,11 @@ static void check_emulated_instr(void)
 
 	brnch_start = -EXPECTED_BRNCH;
 	instr_start = -EXPECTED_INSTR;
+
+	if (pmu_use_full_writes()) {
+		brnch_start &= (1ull << pmu.gp_counter_width) - 1;
+		instr_start &= (1ull << pmu.gp_counter_width) - 1;
+	}
 	wrmsr(MSR_GP_COUNTERx(0), brnch_start);
 	wrmsr(MSR_GP_COUNTERx(1), instr_start);
 	// KVM_FEP is a magic prefix that forces emulation so

base-commit: 02d8befe99f8205d4caea402d8b0800354255681
-- 
2.41.0.162.gfafddb0af9-goog

