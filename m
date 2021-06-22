Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C393B0C2B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhFVSDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhFVSCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:31 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799A9C061A11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:59 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w3-20020ac80ec30000b029024e8c2383c1so99062qti.5
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3DOu4+0cS/pshiyG3lLEGT5b6ht46Mdr7WX/lWP7BwI=;
        b=nPFhgWZMt3pAj6j69pD7DLLwWsAoQB/YYk6rWFYo8+uPxN7Cb5TFI8xdvcjXg/tbdU
         VE6yvKbwIzx6/UNezGHZDeYdDr7XlFRGBu6ik6faKHfwfdcpVMKKcr0uZd3apzJbgjR/
         C2XQ3AmTcIrTLfoAO01Ibli6oNE+DO8fzqFAQM4/NbMWUaLzpsXcQzLgd9HLjQnk/RMv
         no4dMjSv47lLhiUwG6hHxaq4EzGYk34NWBRAW58aJaojVESRlTFi97UBtrY/BUMgm3BS
         YylNu8THJxsYJ+mLHcX1BrCBlG5baaR1KCTrdH/JN/mm00XQZLjrola7LD0dKY47Srcq
         dcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3DOu4+0cS/pshiyG3lLEGT5b6ht46Mdr7WX/lWP7BwI=;
        b=lLZazSBof+UicV23yv1EEWPOY8QG5AwSDnZT5esx9tmgB8BIvPeyOeBI6wSeu+J856
         VwjdKHjELri5rrnte5lh5347Kard3nHGYBmdZeOSYg0LdY5B7IcJnqmVNEK+ye0fgEty
         s8I1yS2TCd1UhzCAp/K92aVikqAhLlmtOX3uh4kZzL2V0w+OOHXXo7fetGNcR80IY+Lo
         ThoeQzkYIwYGtLwtDE3d6J2TUlpILNGxXt3eFqSXNzNcvjYJ+Uu2MFwPd8ShvEH0Xk1x
         xcYrs+eE6kBrTr/Ryqp5bR3zHArW+jo++nm62Iv4WBeyXd0KQ0j31rs9j8NUWna6Zj4Y
         TmDA==
X-Gm-Message-State: AOAM530QCW8wsN01TrfjBShHW0unuePtUOpYUsRAhLtbCpIrjuLTBbfY
        1+iB0BngGB2zmTG1pNlXlpxejNpW7rM=
X-Google-Smtp-Source: ABdhPJyqEcXQ5QRnyyYk/tMvJAhfUb/MWnBznsnv5zof568XiwuCyvMnEDTUKCsOfycBj094kFmG6IeF+qs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a5b:384:: with SMTP id k4mr6843302ybp.194.1624384738609;
 Tue, 22 Jun 2021 10:58:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:12 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-28-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 27/54] KVM: x86/mmu: Set CR4.PKE/LA57 in MMU role iff long
 mode is active
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't set cr4_pke or cr4_la57 in the MMU role if long mode isn't active,
which is required for protection keys and 5-level paging to be fully
enabled.  Ignoring the bit avoids unnecessary reconfiguration on reuse,
and also means consumers of mmu_role don't need to manually check for
long mode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0eb77a45f1ff..31662283dac7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4574,8 +4574,10 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 		ext.cr4_smep = ____is_cr4_smep(regs);
 		ext.cr4_smap = ____is_cr4_smap(regs);
 		ext.cr4_pse = ____is_cr4_pse(regs);
-		ext.cr4_pke = ____is_cr4_pke(regs);
-		ext.cr4_la57 = ____is_cr4_la57(regs);
+
+		/* PKEY and LA57 are active iff long mode is active. */
+		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
+		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
 	}
 
 	ext.valid = 1;
-- 
2.32.0.288.g62a8d224e6-goog

