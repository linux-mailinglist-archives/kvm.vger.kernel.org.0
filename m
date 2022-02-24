Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBD4C245D
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 08:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiBXHIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 02:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiBXHIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 02:08:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1FF22F976
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 23:08:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m22so1257825pja.0
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 23:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUMb4AVvanmWYO4fyDpaR3WwHIHA1HS4iYPCky/2b1o=;
        b=I+dKm1uFEn6jTF3g1+sBeTHv80CIAU+f5gP02ph3FvVTKEsRvFmof4QoJwAyL1o7C3
         ZIsceVtOYhoHp+yHDRw/MDpXKXvPl3qWou8WfMMqg2ezb0/D6uJWjoD18ZmlsPmgJ8Os
         01vq6oH4j1YXTxA17rUnvFcFg48eg/u6kRH+m9Qrs8PigDYl5OqHhLoNpcg0YidG5WOH
         9Tt3KxXesVMKnalH5MneSmpRjGdF9p8XfT8YEbt1PSCX4nC9J1qHBEVb00qHBqLS9xf8
         KbxdqUgcnullT092qTKFB8NMWBE5nKZLc+DcAA9jFCfi395SBHKAwlNMX7qiw5NHzy/8
         JKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUMb4AVvanmWYO4fyDpaR3WwHIHA1HS4iYPCky/2b1o=;
        b=GVcvTLqczjGRY7i48UWOle1eZ65Um1SEnKy3H0Zns4S9pGO/VGBrgpDA49Mn6CP//W
         tuRHczNOncKdwBaaV26TfiMEfT6XbGFJjDBlIYDy4qSOZfG5aaS9xMADSYi/E8WwO4Uk
         vMgDf5iTeRLP1nj5SIrYW3T7PvPgXrSBMcsX5lcJUDHNIttElxb/uQXZAu5BRo6WPE3A
         EHgex0O8/P3faWxhyRgv9bSq1VX0JrDewcXv6EnbzBNXjXrhHg9oN3C0oBzOQcJTITY4
         fBLyN6A4jSdL5fgqS00SOD30CNdtFfzOeVDgWshrCPI30fnCrzVdrLLKTeubA588zawf
         qX5w==
X-Gm-Message-State: AOAM533cFj79PPmmkw9iMe4oPjdTVEbcq/KHTidZoLvp6Fld0hz8yuox
        jASW5bVfDU2RjYQYOt5LTrCZI2ftND5JqSTld+r6kCo/gU/2bg==
X-Google-Smtp-Source: ABdhPJzNt3mHF18BypBkAErSy6XHq7Iq3acinzWGyGToaKTSih4h37R44XGrA+hPk5btrU4dXQ13JKrnJampKnvU2e0=
X-Received: by 2002:a17:902:7296:b0:14f:2a67:b400 with SMTP id
 d22-20020a170902729600b0014f2a67b400mr1572795pll.172.1645686489919; Wed, 23
 Feb 2022 23:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-6-oupton@google.com>
In-Reply-To: <20220223041844.3984439-6-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 23 Feb 2022 23:07:54 -0800
Message-ID: <CAAeT=Fz7jCBGS6UkMJRjgRfOo-8Bs5S0kkJfpmyq9Q+bwGD=+A@mail.gmail.com>
Subject: Re: [PATCH v3 05/19] KVM: arm64: Dedupe vCPU power off helpers
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
> vcpu_power_off() and kvm_psci_vcpu_off() are equivalent; rename the
> former and replace all callsites to the latter.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
