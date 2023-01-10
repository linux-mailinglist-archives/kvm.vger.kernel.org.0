Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D280466369B
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 02:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjAJBST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 20:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjAJBSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 20:18:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A62962EE
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 17:18:16 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id s8so3235831plk.5
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 17:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4WzHP9HtqOS+7EgkyaB7qsHOqXPusLU6aq8lH0si9po=;
        b=SNtfT/pKNP1WO2Z96CPYNglF9ygm6E27LHZYd9dKJr97+T3yZB8afeQxrZR680yggK
         Te7Dpk3vypCFvNdHNkynXANL9iYTtOPUwiEjRR8K+FwQeG4UdRd66/cvqVjMEjOhHqgs
         ok0yeZwvTmLDYP4eEwJ28j8onl0ZaDcvEyt4nH2txkNZnJagDBfnsHj4ZTlwc7mHWmSQ
         deGveKDB8X0kk2Jmtw7pEEYnYS3TWDNM9lhxsCNYnw8nkg7Y9r/cOOoyNA5H9ja9jiqk
         Hq2oDeAbCdQm6M0yglCTebO4WZ7F3zrnJDSASN5KdPtwZ7jA3e2VkmWmujyCFFwXgqFJ
         FY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WzHP9HtqOS+7EgkyaB7qsHOqXPusLU6aq8lH0si9po=;
        b=QibNjZNO4hsNlLXJF6qPeOFTD0SOxxfCozaxu2mHnJTnq7leK1mYEyA5Arc9X94Gwz
         IJSxHjDKJVgfSvgcUSk6g6JqsuFzOTzFJ/ByWvR+maNjxr42nnVi1wtooiz3yzKu4WSZ
         AeJ/r0U8253injjwToXlv16Bw5IiQ87JNLl63UiRI9e449kVS3imdkqcctVyKjnfPnW8
         SFU9pdPIZZzM6VS6W6Qa/gMy6J/ZulcKwiod+16M/Qlm4gCX66RPAFSzjD30TdW5fM8i
         Xwtpek7SJW/IXQN5NHnv2MOEvJul078KeB19uEwE6VpfTyGJ0ZZF/qvAk90/WxLqoPWs
         i1dQ==
X-Gm-Message-State: AFqh2kpQoXAKtK/xmMmwnYcIwOFXK03b+ESgOfdHMIOs5c9IImGQTe+z
        QvBA0fo4Y4IXYdJEUQyamdX29+OCqPdLdSB7cK4D1Q==
X-Google-Smtp-Source: AMrXdXuCNEnCglyKwTg+tL1hvWXJW7ijbzqRmcLjK5pyJ46Isl93+rRt7aWNsVQJVrX6LohrQSCdJ0wBph8xbuZglFc=
X-Received: by 2002:a17:902:bb8b:b0:192:71f0:719e with SMTP id
 m11-20020a170902bb8b00b0019271f0719emr5700133pls.30.1673313495725; Mon, 09
 Jan 2023 17:18:15 -0800 (PST)
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20221230035928.3423990-3-reijiw@google.com>
 <Y7sVx8sv2BYiMihZ@thinky-boi>
In-Reply-To: <Y7sVx8sv2BYiMihZ@thinky-boi>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 9 Jan 2023 17:17:59 -0800
Message-ID: <CAAeT=Fxnkn++j6MObaAhHwb4nTf-g9XGOgzr0NYpA5K6hicFkg@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for
 PMUSERENR_EL0 and PMCCFILTR_EL0
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Sun, Jan 8, 2023 at 11:13 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Dec 29, 2022 at 07:59:23PM -0800, Reiji Watanabe wrote:
> > The default reset function for PMU registers (reset_pmu_reg())
> > now simply clears a specified register. Use that function for
> > PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
> > simply be cleared on vCPU reset.
>
> AFAICT, the fields in both these registers have UNKNOWN reset values. Of
> course, 0 is an entirely valid reset value but the architectural
> behavior should be mentioned in the commit message.

Uh, yeah, the commit message was misleading.
The fields in both these registers have UNKNOWN reset values.
The ones for 32bit registers (PMUSERENR and PMCCFILTR) have zero reset
values though.

I will update the commit message to mention those explicitly.

Thank you,
Reiji
