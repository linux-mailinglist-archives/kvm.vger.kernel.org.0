Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBC6650A7
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjAKA4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjAKA4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:56:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DF113F91
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:56:00 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so2697927pjb.0
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 16:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LHHWINXpgWQ8X1RAhvss5tXTw045jI9Q+hmOj82PhHI=;
        b=d/h1K4XBhTxSg/yHUwV3qQNrApxphNvm5Vp1r0ZcR9pHOL+fcE/39lQe08nRfIRxiL
         Aoy0tXLXOFI8chfV1dYnPzmP59cL6yK6xes1mqiwgKc/zfg/3FvPSZ3JRktgoRkhJZcP
         BwYIKVPCBgr92oVndlNVEoOx65hYEboe2akrICqwOEro1PTyZX+vVxkrZtv8uRex9kAK
         TDG9nL4T8nWs+9E7DdCVNVrkbrrBq2jEtkt3hGrYU289eCUCdoqSlJdR2G1eJ1QarvSx
         pX2YIsrm1wvOzqTJxiAzh/LnVpR5TVfxnJHZXDwj46leHPhj4Z29I6+kBlp1TYSlvqky
         mqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHHWINXpgWQ8X1RAhvss5tXTw045jI9Q+hmOj82PhHI=;
        b=dJ3OSMfApJ196HVTp4cKiCltZzLWiMrpFlCSEZmm2zJpXQe1xG1eeZ0ndS2zjoOoI7
         MsL8xyIUVOPM6UlecuxKIemtsRgSOvzM7BXMwhxJhXMp8bOw3KvV7mWTVVSGES1/ys1+
         M2cxPRhaDhztGq1kunVponoOW3BR8J4oy0NqWG1A9jLHwXMc8xZ/sjVoCmBsGiM63Qqa
         +SuT3LXLRrX3zQTNlutriQeXLImFw6Y28XuljTTQyibBe1Y+hpchM0ArkFCssVwAFGwS
         GXwSKrkN2kv2nqw0URDIdb+p/gzVS3TCZeGQrnn48i0mkYd4lu1eppIHYzqLPp9ucYlf
         h1HQ==
X-Gm-Message-State: AFqh2ko8XVAnCKWciG/NTaPYXhSt1rpPRGayAGAF8GPQTogR9+W25R/D
        OKa509MgAt+LBNmA9UDiPzwvGVNJOr8EIZ7aqPoajg==
X-Google-Smtp-Source: AMrXdXsYHS/aIJUbc2lrM9W3MRvphUJ+CDg/fAUxo0yMmZfAo9p7h4JAVlo2dZNdQzVfYPqUU13hauz2CKYXF9nuFWw=
X-Received: by 2002:a17:90a:2a82:b0:227:1d0b:5379 with SMTP id
 j2-20020a17090a2a8200b002271d0b5379mr842064pjd.103.1673398559752; Tue, 10 Jan
 2023 16:55:59 -0800 (PST)
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <Y7zG3B3DmFZLU200@google.com>
In-Reply-To: <Y7zG3B3DmFZLU200@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 10 Jan 2023 16:55:43 -0800
Message-ID: <CAAeT=FzJozO+qW3VbiF2ojfDqcf_WTMohh45uxfiUBVfF5bHaQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
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

On Mon, Jan 9, 2023 at 6:01 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Reiji,
>
> On Thu, Dec 29, 2022 at 07:59:21PM -0800, Reiji Watanabe wrote:
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.
> >
> > The number of PMU event counters is indicated in PMCR_EL0.N.
> > For a vCPU with PMUv3 configured, its value will be the same as
> > the host value by default. Userspace can set PMCR_EL0.N for the
> > vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
> > However, it is practically unsupported, as KVM resets PMCR_EL0.N
> > to the host value on vCPU reset and some KVM code uses the host
> > value to identify (un)implemented event counters on the vCPU.
> >
> > This series will ensure that the PMCR_EL0.N value is preserved
> > on vCPU reset and that KVM doesn't use the host value
> > to identify (un)implemented event counters on the vCPU.
> > This allows userspace to limit the number of the PMU event
> > counters on the vCPU.
>
> I just wanted to bring up the conversation we had today on the list as
> it is a pretty relevant issue.
>
> KVM currently allows any value to be written to PMCR_EL0.N, meaning that
> userspace could advertize more PMCs than are supported by the system.
>
> IDK if Marc feels otherwise, but it doesn't seem like we should worry
> about ABI change here (i.e. userspace can no longer write junk to the
> register) as KVM has advertized the correct value to userspace. The only
> case that breaks would be a userspace that intentionally sets PMCR_EL0.N
> to something larger than the host. As accesses to unadvertized PMC
> indices is CONSTRAINED UNPRED behavior, I'm having a hard time coming up
> with a use case.

Yes, I agree with that. I will be looking at adding the validation
of the register field for the v2.

Thank you,
Reiji
