Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F54DE1DC
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 20:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbiCRTkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 15:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiCRTkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 15:40:10 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D484E10CF36
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:50 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id h14-20020a056602008e00b00645739bbd4dso5695829iob.9
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H8l1nRqzc+GH0BYge+CcpqHIz0FnRWt0KDTVYGKXJUU=;
        b=bY3JkUnzKDMAFmYEofE7g0/RUbdybRqH8McyL3QCx/wwKqxP1R9oyMHfVxLU5Rn4au
         FQ01pJ+bKjV63b/BCTyaEsUMyYtRT80x+3wKXVcME/neBa76g27i9HbIvWdUltAeJHcy
         JCCC8QEiBVS0FlkELwjk1JW6HbLmmjbCn8gjott5uKeZYtMyOpS4gbqEQ9OHhjb1RMDG
         v9D3fEDlSHu0jaYcfOcoEHaZs/YaN6yiFk21fcmdpWc4tqQMHlb0VVEr9ERPjBnN7Pxh
         gv6Wr+muHYlEezdujn0d4ObZu+RHGGZAOpm7c8GEGOmAA+JbioAndNxPLUuDwMUFCuEe
         SzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H8l1nRqzc+GH0BYge+CcpqHIz0FnRWt0KDTVYGKXJUU=;
        b=LFxqM71SlOmXz9DRJzIX8jxI0tws4ZbY/6n4YnTj/FxvPjAp5qf3SXpbyebsIgwu41
         BxMzje8FQY/tWKaPQ2IA6KeictdGp40HEqcCV9H4BE1x5AizFVm4TcvTJvILxHncTt6f
         pfcxtuOZjnqFw6H2EEjAg5pH92TdIzLerBT31KkB0NRok6poa7Qn159iJ4XaDKKHOsNA
         UQQAx8VFqYhy2HlSOcNxjniikGL2ZzVf8AFNVZ3tNmoLzLBOvX4mR+l88OCiUtfaxE9w
         6if6O0sR0k0i6Gv0zFODP3rm8Dbo/w6vx8ys3YWBtJ9RQhUuZzI+CRajl7RSV1ZTWpqH
         wVMA==
X-Gm-Message-State: AOAM5301wsvsr0Q0c21ooddE7Cs23by7AtnlHMP1cDECtKBMJ2+OgHqm
        jIbSY2vAHIPz1G7ub7fpqIM5p1WFz9M=
X-Google-Smtp-Source: ABdhPJyFMO/w4ywussCXIJDpEfAaloVYed9xixsAdo9QBRfZRiXxwrIxNYxqhyOTk46we5JCHvMjyNz5a4k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:ca08:0:b0:2c7:f1c6:3377 with SMTP id
 j8-20020a92ca08000000b002c7f1c63377mr3395684ils.28.1647632330197; Fri, 18 Mar
 2022 12:38:50 -0700 (PDT)
Date:   Fri, 18 Mar 2022 19:38:29 +0000
Message-Id: <20220318193831.482349-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 0/2] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
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

This series addresses a couple of issues with how KVM exposes SMC64
calls to its guest. It is currently possible for an AArch32 guest to
discover the SMC64 SYSTEM_RESET2 function (via
PSCI_1_0_FN_PSCI_FEATURES) and even make a call to it. SMCCC does not
allow for 64 bit calls to be made from a 32 bit state.

Patch 1 cleans up the way we filter SMC64 calls in PSCI. Using a switch
with case statements for each possibly-filtered function is asking for
trouble. Instead, pivot off of the bit that indicates the desired
calling convention. This plugs the PSCI_FEATURES hole for SYSTEM_RESET2.

Patch 2 adds a check to the PSCI v1.x call handler in KVM, bailing out
early if the guest is not allowed to use a particular function. This
closes the door on calls to 64-bit SYSTEM_RESET2 from AArch32.

My first crack at this [1] was missing the fix for direct calls to
SYSTEM_RESET2. Taking the patch out of that series and sending
separately.

Applies on top of today's kvmarm pull, commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

[1]: https://patchwork.kernel.org/project/kvm/patch/20220311174001.605719-3-oupton@google.com/

Oliver Upton (2):
  KVM: arm64: Generally disallow SMC64 for AArch32 guests
  KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32

 arch/arm64/kvm/psci.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

