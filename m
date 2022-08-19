Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D9059A69F
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 21:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351250AbiHSTha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 15:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiHSTh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 15:37:29 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818C8111C11
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:37:28 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so5157060pfb.7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 12:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=INlhfHBbR+mrpRrc8j6hQCO0gPHFYzYHCpXI8V0Afdc=;
        b=dYpSsyF5vC9PM/Zf3WkWXtPPqWIj75jiKJcl4uYrRTs717ddjwVadXE2RvzQN/h3lG
         Fr19kaLvkO/aSxNLs99dfBnLSg0MSs1r5opKSd5+J+bX2XOwoNiTMseUcLfAK6moYqdT
         Bkf+u1roUw1kJT7ejKL5wvEMw+2Qvs8uRPB4zh5tiJBuceX+Qi1ZaK4LgGtL06CnGkzU
         uUAmg52y860cZxrNTwNX+Fc+qFb76ukWf0riwOMWpyK7JX0aSnUZgts7If/8h0bPduhX
         jAo7Ah25oUQrEgqW3QFEuy4qgra7BnNUvx3hmTqHzDqhEAeS9ZfaT762R+IFCiWuoy56
         xkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=INlhfHBbR+mrpRrc8j6hQCO0gPHFYzYHCpXI8V0Afdc=;
        b=IXwQaQdGGQ43O98Q8gIOc5HIu/Ymn/1/LVctk1wWMvKoyK14qU2EiRNJTFHGyt2e10
         B571eEUATdTaucEOaKJtE0ZRKFrC2dEHSc7hiWYt7FjJNhikB/SjtG/BzECURXcnCwud
         25JSI7Wzs36/PxImaNLi3UnBL7yig1fqpyHLbK4L6hq0hlaX6jExqQL2fsAwOW1xV/TD
         r/7w7bW1g5/Erd4QF+ICMiZPvCvG6Qv4BzAXTUsfVEBYdag3EtmIDJntFmEatRD7w2tQ
         bWk+pCM1C5hSRBos4pusH+1pcFGzROZ+OfDYeC3OAQ0MPqsloeerLhwpTltVfWPNq4T3
         fFUw==
X-Gm-Message-State: ACgBeo1CmhB+QcEr5vtaRRtC03/m3ffmBmRvSRD1X8D2s6Km1G0qUAzw
        98U6Lwarvep5ZK/ks5YssA+34g==
X-Google-Smtp-Source: AA6agR5gjnjFEwarHEDfE50bGPmXeJf9YzaewtlPb+FS5gegGsgE7KgmdcBCeL038O9Abhf66ePK8w==
X-Received: by 2002:a05:6a00:2294:b0:52e:2371:8bb with SMTP id f20-20020a056a00229400b0052e237108bbmr9240806pfe.42.1660937847944;
        Fri, 19 Aug 2022 12:37:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b005361708275fsm1446255pfb.217.2022.08.19.12.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 12:37:27 -0700 (PDT)
Date:   Fri, 19 Aug 2022 19:37:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, andrew.jones@linux.dev
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <Yv/mcxPsJGZYV2tU@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
 <CAGtprH-emXA_5dwwdb4noOC-cuy3BTGT8UbKRkPD8j2gjBSu+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtprH-emXA_5dwwdb4noOC-cuy3BTGT8UbKRkPD8j2gjBSu+Q@mail.gmail.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> On Wed, Aug 10, 2022 at 8:20 AM Peter Gonda <pgonda@google.com> wrote:
> >  void ucall(uint64_t cmd, int nargs, ...)
> >  {
> > -       struct ucall uc = {};
> > +       struct ucall *uc;
> > +       struct ucall tmp = {};
> 
> This steps seems to result in generating instructions that need SSE
> support on x86:
> struct ucall tmp = {};
>    movaps %xmm0,0x20(%rsp)
>    movaps %xmm0,0x30(%rsp)
>    movaps %xmm0,0x40(%rsp)
>    movaps %xmm0,0x50(%rsp)
> 
> This initialization will need proper compilation flags to generate
> instructions according to VM configuration.

Can you be more specific as to why generating SSE instructiions is problematic?
The compiler emitting fancy instructions for struct initialization is not out of
the ordinary.
