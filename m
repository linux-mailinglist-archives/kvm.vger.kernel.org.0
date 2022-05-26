Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC235347BB
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 03:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbiEZBAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 21:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345818AbiEZBAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 21:00:38 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A5969CE2
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 18:00:36 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n2-20020a9d6f02000000b0060b22af84d4so118966otq.1
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 18:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rESdkCwPqse6sStO4+DauKtPsPwAWSccX3gNyrYzPo4=;
        b=cIZ5ZG536zr5k7KHC1Q2keKZ3UzihzmKNsNtKJZ8RAE6TvCSgB1RLGApmzcAS/dZRP
         QV6bCinfKsMLL8f3eK3XxqPXB3NhmPe0VZD2nftSF8fxdP2lBPphTnEotg81hgnX/SiN
         UUnnEEDb09XFjjB8JR67zLVW1qA0SK0/LtEL4UZ+NHH72LckHLOWA0C+qjt9edEjM+xJ
         HARYdTAxCxCUkRRpZ3UEznN+SrXlUBWWTsnEY+HyOGeZ4iSQ0KnXheHSSn3oa3kHIc4z
         JDTSOzM4G5NfXXGXGqQCG7hSrYi5SvItORMf5rdyZQHxRPgLOlmcIifLIUX9kkgE3YpI
         YxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rESdkCwPqse6sStO4+DauKtPsPwAWSccX3gNyrYzPo4=;
        b=ka921cNe1kwbyAGw/fXQr0ITq5YTJSp0bcFiv+f2FoSIY1l8vQPtt7Cn+33EVQWO57
         DYxGzxYAKioz6Z0obFmUUEXLO/AJJjHqOKWuPUaNJwiLAOgnAz+ABkyZ7pDxhnLkQIhI
         rRtWUGZHK9xC/fxKSH2AbgcDCeObK3bZEdYep6FSbiq/pioJ7t2zp0ux0FL66Qnkk1RF
         8WmsudGqwfpQT1LYjsHbTchDG20X4QZ0MiA9BY0z7Hz20mLi0igRBlKGyxZjrP4QCGGZ
         TsqVi1Yy4xUwqKdisPcBtrJUn9Cq7aL6Rjn1G9vbPy0KpZiAlbqZmUGaXSyyQa4H/+BN
         CFhw==
X-Gm-Message-State: AOAM533qsPaZUjpItBHBPorFk2SFGAQtP65qI3dULucFBq3j5NpZpGqb
        YA/RfBA8qd2p2HXH1/Q4k0piBldz1GnyAuligJyJQQ==
X-Google-Smtp-Source: ABdhPJzw3IblBKst7XNW79+bDjJme70ch0qiX3+Acpi7M5r6n+OApvvsHuWk+0EYB9lShYm5w3IHfmkZ8rOZAVNZLqA=
X-Received: by 2002:a9d:6ac8:0:b0:60b:cce:eff0 with SMTP id
 m8-20020a9d6ac8000000b0060b0cceeff0mr7768045otq.75.1653526835206; Wed, 25 May
 2022 18:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220525210447.2758436-1-seanjc@google.com> <20220525210447.2758436-3-seanjc@google.com>
 <CALMp9eRgiPZeGhKHMnwJVSLPvKjPFo4vKzg3=TXTuLL_LSt_fw@mail.gmail.com> <Yo7Np1N1TVD4drxc@google.com>
In-Reply-To: <Yo7Np1N1TVD4drxc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 May 2022 18:00:24 -0700
Message-ID: <CALMp9eQTYY3NiP-3fZgnMn9-nGWTtx7aA3T0-tTvdfeZkhdNrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Add knob to allow rejecting kvm_intel on
 inconsistent VMCS config
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
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

On Wed, May 25, 2022 at 5:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 25, 2022, Jim Mattson wrote:
> > On Wed, May 25, 2022 at 2:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Add an off-by-default module param, reject_inconsistent_vmcs_config, to
> > > allow rejecting the load of kvm_intel if an inconsistent VMCS config is
> > > detected.  Continuing on with an inconsistent, degraded config is
> > > undesirable when the CPU is expected to support a given set of features,
> > > e.g. can result in a misconfigured VM if userspace doesn't cross-check
> > > KVM_GET_SUPPORTED_CPUID, and/or can result in poor performance due to
> > > lack of fast MSR switching.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > There are several inconsistent VMCS configs that are not rejected here
> > (e.g. "enable XSAVES/XRSTORS" on a CPU that doesn't support XSAVES).
> > Do you plan to include more checks in the future, or should this be,
> > "reject_some_inconsistent_vmcs_configs"? :-)
>
> I have no plan, it was purely a reaction to continuing on with a known bad entry/exit
> pair handling being awful.  I hesitated to even apply it to the EPT/VPID stuff, but
> again it seemed silly to detect an inconsistency and do nothing about it.
>
> I'm not opposed to adding more checks, though there is definitely a point of
> diminishing returns.  I'm just picking the really low hanging fruit :-)

The usual KVM approach to a misconfigured guest is to let userspace
shoot itself in the foot, as long as it doesn't put the host at risk.
This change seems to run counter to that.
