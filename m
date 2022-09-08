Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF55B21E1
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIHPUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiIHPUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:20:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F9A33E33
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:20:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o126so9259245pfb.6
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rOPP6Uu5swigMSQksbn2hbHol8fqfH4qx3zUzGuou0s=;
        b=SKw6t8rRS2GQn2M3D3NgOKrXQm8g6fMc6V31zBcuAt+NDWOtQgspdYheDwHP8gP7uc
         nRxip98S3briinM+V1vqUJXMJK+gk45KiZLtG/+aI3i2z1MHqAqbPHypbpczSXd+Y+fn
         amaEH6OX7wYBlUQ0Te6IqV22hhCG3x5PcZHVdNTfakbn+nxFHMossCoN1E+zqM8HPBLX
         a+CvW8keM4LjPisGpEfgomsc74y0AufuDco72laoiazzGJuNJd5aG4l/j1ClmZD2dInr
         LavX9mOoNeQFC7Ph2QvoGjtdIscd3zF83kU4eEZi2Tgzsu+Six5FZAOo8nrerlSeNgu7
         DN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rOPP6Uu5swigMSQksbn2hbHol8fqfH4qx3zUzGuou0s=;
        b=qOHhrYGMOP4ICAWMXC+xdL1XmiMuyURXkybIKpk6Ch/MjjQpSUbp93usvSQZ2eEUXD
         GIGmY4aCc3m8/CQQtAD3LdhfQaV6XB3302AnzeGYL6SvXFt85z5C4rCpLxsDjTTSfNco
         UVQaWI8UPt47t5buzA90EUZ2jklBmo8iC+j5ehD+TpaLpPrBOOthxPm1uOk5nMZAI2ds
         4h7NuaH4YMM1ASCjIUL+rpSp5E4xOAOLkae4uCv61nMo7E9srLv7dnirJB4ggSGdiKkT
         MIdVAdYg30tFt5jJdqZaKNQaO/fe40us+if96ars1gDX9KGU+R+tk+xT1aU01Q9w2d7F
         3j/g==
X-Gm-Message-State: ACgBeo1twgT5yk544B5oFMwijKkffufPRKqxFnttkMroDj2G6M6Yl0ZW
        IdPFod29ovEs0Eh+iziY3LAiZg==
X-Google-Smtp-Source: AA6agR4uHgeZKOXawKaDnTBpniqg5EdDE/6lD8B729vKktfYTbo+w4REsRSc00v1h3FYfQa3nqKCZw==
X-Received: by 2002:a05:6a00:1408:b0:53a:97e2:d725 with SMTP id l8-20020a056a00140800b0053a97e2d725mr9496127pfu.39.1662650408726;
        Thu, 08 Sep 2022 08:20:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b30-20020aa78ede000000b00540d03f522fsm205433pfr.66.2022.09.08.08.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:20:08 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:20:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix mce_banks memory leak on mci_ctl2_banks
 allocation failure
Message-ID: <YxoIJLlgEfNa/pDY@google.com>
References: <20220819182258.588335-1-vipinsh@google.com>
 <Yw6FD867fK2Blf1G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw6FD867fK2Blf1G@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Sean Christopherson wrote:
> On Fri, Aug 19, 2022, Vipin Sharma wrote:
> > If mci_ctl2_banks allocation fails, kvm goes to fail_free_pio_data and
> > forgets about freeing mce_banks memory causing memory leak.
> > 
> > Individually check memory allocation status and free memory in the correct
> > order.
> > 
> > Fixes: 281b52780b57 ("KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.")
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> 
> Pushed to branch `for_paolo/6.1` at:
> 
>     https://github.com/sean-jc/linux.git
> 
> Unless you hear otherwise, it will make its way to kvm/queue "soon".

Doh.  Dropping this as Paolo already sent a different fix[*] to Linus, commit
3c0ba05ce9c9 ("KVM: x86: fix memoryleak in kvm_arch_vcpu_create()").

Sorry :-(

[*] https://lore.kernel.org/all/20220901122300.22298-1-linmiaohe@huawei.com
