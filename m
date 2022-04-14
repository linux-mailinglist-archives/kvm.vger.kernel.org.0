Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA2A50054B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbiDNFDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiDNFDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:03:12 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF724BC0
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:00:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id be5so3720361plb.13
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+uxBXn2CsAxnZsOAkfx1jrlhANZjdH2Cp3uCpCwX/Q=;
        b=ds/hJKiggiortsqecqFtGUrCyrcqkBHtAGput5CsQRJ0dw9pMAoowE2pq/91qZOd8t
         Ek0I1JpwDJhw4o5eWzICQ24kFHMxvifi12A85LhkF7QmHE1zmLsqqPEFM0mqiqWBMxtl
         SwpHErS9M143cM/R4Xalrjki7yZuxe+l4zWufOhfyRF1o7gQfDfcMnTFfP1vV1TlkuVF
         gPk1i3CLo0/u2dLpAj9uOQTOzU1n60JtRyN07f2l/gPQMFt49IYZ4lh6i0cNclX6dsS6
         rQUhxKNTGUnoGw4QqH75EmhmufQIpxUzKLh0hvYv6Z7keAVn4b/pY7PW3/ibY1ijNxaB
         V5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+uxBXn2CsAxnZsOAkfx1jrlhANZjdH2Cp3uCpCwX/Q=;
        b=vJriecjE7sBV1S9yorRsimWKommUGmrsQcvx7fvIr/hAJUskFMqPkEUmczm+OoYJva
         /VnYdfaKBtnixpGFB9NZcCCsyhCXMQK29Ebmt/hlTzB0XXnJuIelhZg9BT22k7gx+p4K
         Olvomy+Yqy+ht33NqpsmlefslAAu248Mp+DUftZ3IdbmRTrjWSEosxKobLyN1jQuXHE1
         I0v/XGU+qszO2EhaYqHk3K2zbOFxPm2Ae+kI3Aqrg1FcH4oUU5YM610EsesnO+4XXNxQ
         o+JwJmDZtDQeZQuwWwIMrzLjcQmcxvoc56tgQzvqey+tN24AHmtn81YxreaUTzIESbyX
         6yFg==
X-Gm-Message-State: AOAM531YD7VQD3z/1yEh9x2fJTcION8i9elt0Slqro4FKYjnkYGP4SnR
        kS2vBVvqxZ6kHlqK8B3KFz80h1IOtMH3qx3tJvXGmQ==
X-Google-Smtp-Source: ABdhPJyLSdBGfP7VGWSb+ZOmT/YRV2i9sQeReQWr6TjWWrEU5MkTR0ZUVdVc7rqaYxu5HKB3hHhTfxeHACQ/lHPq128=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr45929939pll.172.1649912448731; Wed, 13
 Apr 2022 22:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-2-oupton@google.com>
In-Reply-To: <20220409184549.1681189-2-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Apr 2022 22:00:32 -0700
Message-ID: <CAAeT=FwWB2d-Kea-BQxC--AXZXPSNJh2BoS0_ZMjaKs45rJmeg@mail.gmail.com>
Subject: Re: [PATCH v5 01/13] KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> Depending on a fallthrough to the default case for hiding SYSTEM_RESET2
> requires that any new case statements clean up the failure path for this
> PSCI call.
>
> Unhitch SYSTEM_RESET2 from the default case by setting val to
> PSCI_RET_NOT_SUPPORTED outside of the switch statement. Apply the
> cleanup to both the PSCI_1_1_FN_SYSTEM_RESET2 and
> PSCI_1_0_FN_PSCI_FEATURES handlers.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
