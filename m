Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA4970D25F
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 05:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjEWDaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 23:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjEWDaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 23:30:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A693791;
        Mon, 22 May 2023 20:30:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ae3f6e5d70so62813315ad.1;
        Mon, 22 May 2023 20:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684812604; x=1687404604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DKMb9AmQA76fDeMluH7dncBirmnwfpNZXYIh/ojYCFg=;
        b=IeNddv1ru8ZPgNG+l/M77WwANktvCP9rB0pZ6K6ryPHZtCx/aJq0uXUtPXitYcQbAh
         WKWWlHySoYSH7AGsTkQNIasmrmAriZ1BZDfC2PvtJASPSMyIek8+B7gTl7hQZrMOZNmi
         xFRv1he1Q6IxNkRoaUH91avfG4itToDtwLdsOyBtVspydsS4ePi/txHckvgaW1oF6Pgz
         iaEIbwOhnGSO8Wm572DPkMd6wMoDe74wlPjOSJ1vzuMgUYSclmVKo01iQAtBOaQcI8eO
         D8mB7gH07/f3dIrfPNSqXrTEJIYPCoG49KMJ/FUxZa2W5JqHH/Hv2D9oaG+cZsiRpUap
         C2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684812604; x=1687404604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DKMb9AmQA76fDeMluH7dncBirmnwfpNZXYIh/ojYCFg=;
        b=DWgmj/Xo/1TQFnHp6Cflq1NTuDSJkMMlh15U6C7f/FZoLtQkUDydFgxvneXfL6nlnO
         bBAPis1n2sMLBZ02NfgJW8gImP5VzgLfSqGX+fy4YZUAMjpheMEUEo0vDwonT0nsTdwl
         00EjtbfEsR+0m1x0CpMjJnJGXdCTgB1qS0W+BemgcDl6lY35hlPX0Q+i2Ou9yEt0MHiV
         VFDL5MOM5CHgJsxd4qQ0CGrhGnaMNN+zFHYaOqbRsDCl0P32Ax5/dG8+tH6bb7EkiFMN
         p5PWWldU9ShBpjxJvcrXEmvAAdqo1AXwnsQYtU0J/jCWX/9JyNAgea+twHz0xCsdk7kl
         Y2PA==
X-Gm-Message-State: AC+VfDwj2PY0yehMH5U+FEs83ofn0NDbTvM5IBXK/OHr3syznqWqGlKn
        o+fvHxUsnlXfFoGWBjHprGA=
X-Google-Smtp-Source: ACHHUZ49yugTSNLzPR7rjVZJws1ctQQe03m6L3IHTT05374cDYQJ27D3E0IvQfR4xzpV/BqLQW8l1g==
X-Received: by 2002:a17:902:c791:b0:1af:ccc2:70dd with SMTP id w17-20020a170902c79100b001afccc270ddmr794319pla.28.1684812603978;
        Mon, 22 May 2023 20:30:03 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id iw10-20020a170903044a00b001ac2f98e953sm5527194plb.216.2023.05.22.20.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 20:30:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/mmu: Assert on @mmu in the __kvm_mmu_invalidate_addr()
Date:   Tue, 23 May 2023 11:29:47 +0800
Message-Id: <20230523032947.60041-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add assertion to track that "mmu == vcpu->arch.mmu" is always true in the
context of __kvm_mmu_invalidate_addr(). for_each_shadow_entry_using_root()
and kvm_sync_spte() operate on vcpu->arch.mmu,  but the only reason that
doesn't cause explosions is because handle_invept() frees roots instead of
doing a manual invalidation.  As of now, there are no major roadblocks
to switching INVEPT emulation over to use kvm_mmu_invalidate_addr().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V1 -> V2 Changelog:
- Better to assert on @mmu instead of deleting it. (Sean)
V1: https://lore.kernel.org/kvm/20230519081711.72906-1-likexu@tencent.com/

 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..258f12235874 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5797,6 +5797,14 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
 
 	vcpu_clear_mmio_info(vcpu, addr);
 
+	/*
+	 * Walking and synchronizing SPTEs both assume they are operating in
+	 * the context of the current MMU, and would need to be reworked if
+	 * this is ever used to sync the guest_mmu, e.g. to emulate INVEPT.
+	 */
+	if (WARN_ON_ONCE(mmu != vcpu->arch.mmu))
+		return;
+
 	if (!VALID_PAGE(root_hpa))
 		return;
 

base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.40.1

