Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034B0535AD6
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 09:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348430AbiE0H4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 03:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348410AbiE0H4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 03:56:24 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D673125E88
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:56:19 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id e189so4840563oia.8
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKxjalUcljvKnzN5lBKCl4Vp/gLsPH6RAr8Yk+aW0r4=;
        b=ETR+NaVaVl4FmjEFVhzm6fOzYXY7BWGuylgp6IlAxdm/zvWnX/Yne5X3enLi8kt8dV
         ICtcKvY+kvySit5lehcMDaDqVU2cC7qvv5AXqJicDL/X/4mWbryQ60Pz/951MjJs4c20
         0uhtngIbFrBMJIVc6r4xq6lGT/SIS72gjK1huBqB5tDUNG+Me5+lp2XvvkLsnhdSsWtt
         ENco9sM3c6AoatcgFC9Tu6OiecE1n35Y9pGWZvv2B7dDZldRGcWU9plUT1Wq77JfdSt4
         tLinQG9r7DR1kHuOiwX71hSAOMO18i7KwE2pzfP2XETBUtmLvqUQlerNWuGQ6+Mb9Zmg
         PTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKxjalUcljvKnzN5lBKCl4Vp/gLsPH6RAr8Yk+aW0r4=;
        b=mKo192VDtlMaHKew7uufb0TqqaI/iVV/HWFyAzKTsCYxakYa64ePikPihtWqpHZoih
         FDvvwzAhj+YP9d5QdY/GM6xD1uWa/fPdFhFMPlVnBDQxuYa3qblUlbCUWq1oNxDj35d0
         rgyG6R/4vMLgPcejgZSWZzdZtPl5sTsJaMTVmVTfU5fUcGd1eeexRtRK6l0n31uMQe3/
         u4HJXDeUHAOYIm6qsuhfsZ4cStgm9jiWpfMG6TQeGQUmuayMk3V/flZ+gGdRJGkFAW91
         pBFUl8Mt76mXfuTRfWzkjVsZJfJof4M4Ey64jTMLrnkKiDOF3K0j75ivF5hYqR8M5cxf
         4tEQ==
X-Gm-Message-State: AOAM531VAHNQXAmsi92QYawMSqIwNQftxEs8Rc5swyeKAyIAzoJHBjkt
        g3VNDwMkU9h+Q+ylNQTjEywmOyeIBEXCWKBtbF43qQ==
X-Google-Smtp-Source: ABdhPJxaU/ES1nDnDkYzxdzdnAGBT0PhiqjnwkFprfzv9nwJvg+PhTb6hoy2zVozvUV/SSLEyWDtS1I+obPS5iAC5Yk=
X-Received: by 2002:a05:6808:19a7:b0:32b:3cef:631 with SMTP id
 bj39-20020a05680819a700b0032b3cef0631mr3338903oib.294.1653638178580; Fri, 27
 May 2022 00:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
In-Reply-To: <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 27 May 2022 08:55:42 +0100
Message-ID: <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Peter Collingbourne <pcc@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Peter,

On Thu, May 26, 2022 at 9:08 PM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> >
> > From: Fuad Tabba <tabba@google.com>
> >
> > Return an error (-EINVAL) if trying to enable MTE on a protected
> > vm.
>
> I think this commit message needs more explanation as to why MTE is
> not currently supported in protected VMs.

Yes, we need to explain this more. Basically this is an extension of
restricting features for protected VMs done earlier [*].

Various VM feature configurations are allowed in KVM/arm64, each requiring
specific handling logic to deal with traps, context-switching and potentially
emulation. Achieving feature parity in pKVM therefore requires either elevating
this logic to EL2 (and substantially increasing the TCB) or continuing to trust
the host handlers at EL1. Since neither of these options are especially
appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
configuration based on the underlying hardware and which can mostly be provided
straightforwardly by EL2.

This of course can change in the future and we can support more
features for protected VMs as needed. We'll expand on this commit
message when we respin.

Also note that this only applies to protected VMs. Non-protected VMs
in protected mode support MTE.

Cheers,
/fuad

[*] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/
>
> Peter
