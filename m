Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A94442AAE
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKBJto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhKBJtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:40 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB0C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:05 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id c22-20020a0568301af600b00553c94299b0so10746090otd.20
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nEjtp48gVyB++aYe5TOFGmHYLzUAbR8AMXiOP8caS+Q=;
        b=PH5s6nRr9C9ryg6R7K3KVE7lekvhJ4vWen1srtKgyckfyIL506uPsp1thUwsDGBp2I
         s0rtpTcgH5+RkIAsgGui4xxyoFy2FcKhuqD+zlL2WiqoCNePlOfIDPzVfVMzLVNidPjE
         kDEqKvU6sNqdwfuqSVPXBVcUcyFM0qCKpCDbvWbSDAhF1onWqasK3EH8UcK/mYSHPksz
         mu2apwuLuFAzZv2kxhvJanRAtOYb3H5MRH72mlIaj7J5/KI9xqRFZFs16+BhvHOxddyt
         171ryqXBNwgM1szDlWottlMAZQwysc78EQeNEGivOGb68Tzn2pW9Yt4pXEWl5Giqs3mz
         GENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nEjtp48gVyB++aYe5TOFGmHYLzUAbR8AMXiOP8caS+Q=;
        b=NEHanUVye2I6/PtefXC0araoDclOj+ZBhF7rZABpjwRGN8F2J8ppuZSmB0RtmHYgj4
         S+S2fgr6TlITgt/ko7LJ7SB/ZBMQci5gkeXdkXPhLrHWJbR75997CMFyELGl8O58Ttnf
         ooJtKV9BcZirJXMiMuMxBwmIvEBOGfqhlISLjB7JPUnqT09DF7ssLIzMRTnkBuOY/9FL
         ZddPL9puEYcYrtU1n/SGaQNEWXeLu7XeM6Ie0rw4B/SrpjFlhy3SGR9t/mIsN7vmOSKa
         a5KYSbXdmTd5wGK/hcKBmUvvTrCHsG56j4BNALcGNAOrlcQFVZxm46SRoosE9ONTdnXF
         NMzA==
X-Gm-Message-State: AOAM532t4sNGJ45aCz2ISaRI70VvWJdYfCa5bQsTAuuQUHjazXfp2vLA
        1Sa0OkKpjvbWvdLVAax2BTYoiA9nAgU=
X-Google-Smtp-Source: ABdhPJxr747gitpVlJ/b+QoTgbMhfsQFRzNX4vE8pGYUrpL6y/peDJCUncRK+fGW//73XuPwhgpbn5iWeqM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6830:1ace:: with SMTP id
 r14mr25706515otc.232.1635846424779; Tue, 02 Nov 2021 02:47:04 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:50 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-6-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OSLSR_EL1 is now part of the visible system register state. Add it to
the get-reg-list selftest to ensure we keep it that way.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..0c7c39a16b3f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -761,6 +761,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 1),	/* ID_PFR1_EL1 */
-- 
2.33.1.1089.g2158813163f-goog

