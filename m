Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9573E71E
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjFZSAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjFZR77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:59:59 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E08130
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:59:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b6824141b4so30975015ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687802398; x=1690394398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=plGPnNmp3bHXDxY2xXZU/U5CRi6+Be1QmjShS9rwEWQ=;
        b=iunKlzH6ltsbsmTPGl7+XjaUEeYmmWTDy3TT6IP4xrB5aNlrVP9Vp1lZHxpk3o75a7
         qjwxuYV1sN3wCVZquQbLIxkIwdl4KzMBXc0rlXex8Cysclc7bpC8alLc7FQd836rfkLv
         j55f8FZweQGGNnoA0+QHljAApsDLS1U243VvAfkj/qfXEbfGJxAGF2sZhjXtGM3TkPgi
         Anm2DbbCLaxLqFjQrVVD4frgeIaYqLnE02wWHyJevds8dex9iGf7Um6Q3G1Tayxjnm0T
         SnJ8p8u4yl2NRftZHyAuVTpgV+QoxhjroYPHQuIO+pYOWUGTTcgBdbYr1kbvFLsPFcDh
         FC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687802398; x=1690394398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plGPnNmp3bHXDxY2xXZU/U5CRi6+Be1QmjShS9rwEWQ=;
        b=KrkpHi1BlrYc6mNaRCwcY8pS1IA/MGfCtSmIdZ5zsvItVZiMvVRwqHunHVDyXbbURZ
         ltvUgVIwF2kjuyl8M0OBc/e5oayW7VS/NW56yM1WOjqsz4U/bvtIDhMJ9VKkEkgeC8Tw
         +ESvRtAEo1Jd3DrWJAqCiHSfYYJYYpvdEjkE+5jHh2wxNiAYDwaV8UcUXN+QjoFL3Vil
         qAVqjp0clQpB04kGnI0xHfy2/njkcLmsVSk1CbyEuHlXl8Rq5XF55pwKRGpkwPDDVktF
         QeR9+ppYrKJlOXRFCUiJ1JO0pJHtZFv5i5mV4SoxqKQG35Pn2hawpGAXoS8K+roxR6wW
         pOZA==
X-Gm-Message-State: AC+VfDyQ9xe+TgUyTKF24Aw34dTEps1N7Y0hl/dvok3NwNtFm3GIHb0M
        3u1dxpwZWhmiTFPWoUC2A89XDQ==
X-Google-Smtp-Source: ACHHUZ5jbABWq71//Y5hMCCaB8WfgqHnonyf6ZDBe1jLvP1W7eesLQPS1y1c5A7yuH9Av7TBQKQinw==
X-Received: by 2002:a17:90a:203:b0:262:c41e:1fcb with SMTP id c3-20020a17090a020300b00262c41e1fcbmr9873356pjc.14.1687802398488;
        Mon, 26 Jun 2023 10:59:58 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id h23-20020a17090aea9700b0025dc5749b4csm3932240pjz.21.2023.06.26.10.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 10:59:57 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:59:54 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: [PATCH 6/6] KVM: Documentation: Add the missing tdp_mmu_page
 into kvm_mmu_page
Message-ID: <ZJnSGrskpTjhZ3qV@google.com>
References: <20230618000856.1714902-1-mizhang@google.com>
 <20230618000856.1714902-7-mizhang@google.com>
 <4e2eae9ab23748ea32fe07d39a704d65d50a0973.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e2eae9ab23748ea32fe07d39a704d65d50a0973.camel@intel.com>
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

On Thu, Jun 22, 2023, Huang, Kai wrote:
> On Sun, 2023-06-18 at 00:08 +0000, Mingwei Zhang wrote:
> > Add tdp_mmu_page into kvm_mmu_page description. tdp_mmu_page is a field to
> > differentiate shadow pages from TDP MMU and non-TDP MMU. When TDP MMU is
> > enabled, sp->tdp_mmu_page=1 indicates a shadow page for L1, while
> > sp->tdp_mmu_page=0 indicates a shadow page for an L2. When TDP MMU is
> > disabled, sp->tdp_mmu_page is always 0. So update the doc to reflect the
> > information.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 0dbdb7fb8cc6..cbad49c37629 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -277,6 +277,10 @@ Shadow pages contain the following information:
> >      since the last time the page table was actually used; if emulation
> >      is triggered too frequently on this page, KVM will unmap the page
> >      to avoid emulation in the future.
> > +  tdp_mmu_page:
> > +    Is 1 if the shadow page is a TDP MMU page. When TDP MMU is disabled,
> > +    this field is always 0.
> > +
> > 
> 
> Hmm.. Again I think "TDP MMU is disabled" is a little bit confusing, but maybe
> it's only me having this impression.
> 
> I think you can just delete the second sentence.

It is not confusing but redundant in this case. I will delete it in next
version.
