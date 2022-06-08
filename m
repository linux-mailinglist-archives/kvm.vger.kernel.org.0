Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219025432ED
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242110AbiFHOpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242082AbiFHOpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:45:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC823DA6C
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 07:44:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so20823120pjm.2
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 07:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Kok+dujBSv1pYm4SU5QGdLBVwlGiTCvuojzr92zXIw=;
        b=RSCESzo+lTY73CNU7aWdBfa4nksl9o0LERuurpAhWqKHcLujgtBYJNkHnbtDSuQhGF
         gj/MsSMJj74HpkMSGXVZaxlY8tu9Lu2gX1+gi4TnI3iBG5vpc0N4s7OqktXKCdalBoNZ
         5KR/XUFQi0o6VvnSxoeqNyUSV0/L96ZLwMbY/uWwG9oY9AMaRyTdZMFiKk85ERCyADD0
         9twgLgf6fuGgvwJzOMHW+4PHYsANfW+yUKjE8txQMtyBXzdohfCe5+uBsRLB84DQs+mL
         RDx07vk1TxA8XllNbICkFHNKzLXs/sdB6R1D40S8O/07a6t2WiSVlbT7AHk+pOHCVv3s
         F5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Kok+dujBSv1pYm4SU5QGdLBVwlGiTCvuojzr92zXIw=;
        b=vrptN8JJ3kF8/dmVb/gXJsQ8+4G2YB67smU4545ja4piFYXbMY5uQy+oCM7IIGGjpo
         c0Gz2MR44N+QOO0in7LtS8FdjA3/v4kJMHx22UWEYr8IPouqaxJ69d8gayoK4iXYHIwy
         kth9/mo7SPlT7DWx/z3Zvmb/R6zlsLnpv3FQKdiMV1cgCtA+pSO9PH5g8WcSPBBoLGtQ
         T0wqMJZPJ94rv647acKuAkemjdv4Ra745H26H3RbGeUbfVjehMICz9leCfkca3pgrVQ2
         BlZiGjLaSDvChOA4TL1ay3/KYs8r5XqsTLymfbnMSUaKiAtmjL3KCKCdHfelQYJc56iw
         OzVw==
X-Gm-Message-State: AOAM531QSdYkwbx6dIubA5Se/Xq8Bh0SnR3t9hgH6OARP4LS28Gl/n/G
        utOn/iZsPwPl2mBuV1yIWe1nWw==
X-Google-Smtp-Source: ABdhPJy6g/mboCHMbLLLVYQCHT3spf/G0NQa7h+tdVsew90iFjvSGnK6GkPIluXurOdH9DFSagRI8Q==
X-Received: by 2002:a17:902:b70c:b0:156:16f0:cbfe with SMTP id d12-20020a170902b70c00b0015616f0cbfemr34467386pls.152.1654699442559;
        Wed, 08 Jun 2022 07:44:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j21-20020a170902759500b001620eb3a2d6sm14774821pll.203.2022.06.08.07.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:44:02 -0700 (PDT)
Date:   Wed, 8 Jun 2022 14:43:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: preserve interrupt shadow across SMM entries
Message-ID: <YqC1rWUNS64LPhoN@google.com>
References: <20220607151647.307157-1-mlevitsk@redhat.com>
 <2c561959-2382-f668-7cb8-01d17d627dd6@redhat.com>
 <Yp+lZahfgYYlA9U9@google.com>
 <06751481c463907f0eeced62d3f11419368823ce.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06751481c463907f0eeced62d3f11419368823ce.camel@redhat.com>
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

On Wed, Jun 08, 2022, Maxim Levitsky wrote:
> On Tue, 2022-06-07 at 19:22 +0000, Sean Christopherson wrote:
> > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > On 6/7/22 17:16, Maxim Levitsky wrote:
> > > > If the #SMI happens while the vCPU is in the interrupt shadow,
> > > > (after STI or MOV SS),
> > > > we must both clear it to avoid VM entry failure on VMX,
> > > > due to consistency check vs EFLAGS.IF which is cleared on SMM entries,
> > > > and restore it on RSM so that #SMI is transparent to the non SMM code.
> > > > 
> > > > To support migration, reuse upper 4 bits of
> > > > 'kvm_vcpu_events.interrupt.shadow' to store the smm interrupt shadow.
> > > > 
> > > > This was lightly tested with a linux guest and smm load script,
> > > > and a unit test will be soon developed to test this better.
> > > > 
> > > > For discussion: there are other ways to fix this issue:
> > > > 
> > > > 1. The SMM shadow can be stored in SMRAM at some unused
> > > > offset, this will allow to avoid changes to kvm_vcpu_ioctl_x86_set_vcpu_events
> > > 
> > > Yes, that would be better (and would not require a new cap).
> > 
> > At one point do we chalk up SMM emulation as a failed experiment and deprecate
> > support?  There are most definitely more bugs lurking in KVM's handling of
> > save/restore across SMI+RSM.
> 
> I also kind of agree that SMM was kind of a mistake but these days VMs with secure
> boot use it, so we can't stop supporting this.

Ugh, found the KVM forum presentation. That's unfortunate :-(

> So do you also agree that I write the interrupt shadow to smram?

Yep, unless we want to block SMIs in shadows, which I don't think is allowed by
AMD's architecture.  Using a micro-architecture specific field in SMRAM is how
actual silicon would preserve the state.
