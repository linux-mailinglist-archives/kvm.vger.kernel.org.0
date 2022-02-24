Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FF74C2441
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 07:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiBXG4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 01:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiBXG4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 01:56:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43C026A3B5
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:55:28 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z2so897000plg.8
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ip1yGFvWnzVPcI5baHpTJEAS2apjxgastb+/8JG8p0o=;
        b=gnp1J6ZgOgKZkzPE/TLGYw6HgkT6WfdFs7W1DkbrdWUaQfxzzNtyA/uUNoWDzz7DvO
         Wtciz8zSIQ0ArEcg/cbzNutpNRWBvamMYiBoBUkTxpVuS7Cj75p9hEnA0h0qs084b03N
         qZQTC21C6/jYINQh85CgJ8w79TX1lzzx4HvOmf2g32jf8m59KZM99CggJPCBdqbUjlF0
         xhinssQtZVuZ9Z5tLZ9cj+F+lFgwU4VXOAqyWVRK0E/kMW7x77oAl5oLaE6eDHB67huO
         4kQPEcgY6o7kdSzhybeLdqxZ3V/mKX5gYzX3pYEpyUOyx9qzuVdnQ6J7DoR+5y4pGVlg
         D+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ip1yGFvWnzVPcI5baHpTJEAS2apjxgastb+/8JG8p0o=;
        b=UZVJBQmKrZ1SabE27AYFLEXUWc6wsAjA4Pgh9UJCwJWmPalmxpGLZT4qtLdWs5XVz1
         5T6Kz9AmLKETrUwlv6FPCsgWUq419OaBaYAUpFxJxU8eBBr1hUzC6Y8q4Zwxh5mdAvWR
         i76q4b0j5U88z2Re1yeYpoUPskUZwsE/9p8QGjDkFoRhXBbaB4fOjKHWu1tRzMjuGypS
         /T2jUKFJxIGmXOZPXS7Ign987myU7fbr1HdU+TCE6RlwflNjsyxdTqrzxTF2Zbh24j8g
         f4v9OV6GO58BtTZVR05JY82mc+bc+Lh1qTAf4wHaGIvK3SfxEQctgrZ3W1QIuRNyK//X
         ECEQ==
X-Gm-Message-State: AOAM53074kKS79a/CrFGnk5pGp3as8xDAZml4ciN1UGy3wdBq2sdV5rD
        5mCC84/rKpamUI8ZAEfSaSKsCGjPLPwdIo7u/qZluA==
X-Google-Smtp-Source: ABdhPJyRnrb1Nqkq289GPPagDgdXvd0ne4RNNibt9f6cIdLsgHeqzPUNBEyIJbLu8mrs1KnYUl4Uorcr2LHYBB7UWHY=
X-Received: by 2002:a17:90a:9288:b0:1bc:568b:55bc with SMTP id
 n8-20020a17090a928800b001bc568b55bcmr1389089pjo.9.1645685728059; Wed, 23 Feb
 2022 22:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-4-oupton@google.com>
In-Reply-To: <20220223041844.3984439-4-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 23 Feb 2022 22:55:12 -0800
Message-ID: <CAAeT=FyP36QL1Dsjx-7rOJ-bwUtXJD89YxndMo8hvyBjM_z6cA@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON
 PSCI call
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
> implementation may return INVALID_ADDRESS for the CPU_ON call if the
> provided entry address is known to be invalid. There is an additional
> caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
> is returned instead. Check the guest's PSCI version and return the
> appropriate error if the IPA is invalid.
>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
