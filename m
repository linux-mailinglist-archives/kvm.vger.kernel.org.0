Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1816171A3
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKBXP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKBXPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:15:25 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2CD38E
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:15:19 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so2228991wma.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BJ6e3sZaYU5TkHCP8lQYWa6Ma1kVXSvBLWNa8mxQ4rs=;
        b=jj8o+ChO2WJQVJ6PCh2YvoqVWVbNnbT8N2l/M2MaJFZrXoCLD2kOolOvOLDfPJMqvw
         zsCkzkvThN+REK+R/EJY2qBbVUQOi9fRqGcl5YoxDccDRz/4U46xWTbveGv9gUMPa7li
         pVe2+ct6lwLX1PiiPF0xx0Txc9IKvBJyNENjsVD7xlY+G3+u6d/W7ACDUDi3+7VmcMta
         I/ZmsMO7W1xl8fp43E0sqNHI/HlEIya2py40EQdtgOh5fOqnJXDh9cRZIn4aCJaQHtRd
         GwsMqcVdQB0DdOMP7npyuRqvAejL+9qzklw8iolKR0ziA/ILfFZHGjSRQw3DvzXmssVA
         5nJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJ6e3sZaYU5TkHCP8lQYWa6Ma1kVXSvBLWNa8mxQ4rs=;
        b=WLGZpT1cDWMRCFuCTOh7Y4o/Yc9uhCiwG9qYnEDRVrnu+Hve4M6hxJR49nOvXrIZIX
         KZmLHZzBn0230vRGI48J1XyhAo9Y+8fha53o5mZQqazEUnW8AsmLue+LicXiVyKWZT86
         x+mzY5aCScbVIX8NDaGuyK6qWza/Fg9OfrGpz3M/5r9Fy41J8Q/ZecP87BqLlFAgTIj+
         xsWYdjH5TFQXv9Dr8WQJXrmk+2MaTTYC4sxuXb3vPk0Dd+ZUoaApzur64K9S0+CB5hDx
         zLyFbo0Hpb1XY/ObelZAA+AZ1ExyqZajKho7790FK20E0KLsz8atOl8x2tdHj+AqARbC
         0N7Q==
X-Gm-Message-State: ACrzQf2D6QpXGqDkpQLm0LUTJwcKfMceKlKBnbO80Gk6XEQoMf5DGznk
        vchBe3TzlHDziBz8szSnWfokfsaMhurTUnw2eev7hw==
X-Google-Smtp-Source: AMsMyM68PZgfHFFTFLVRot1DGl/MA7QTrD74ZZq8pZmCfQalZX/eQx8K36Z/1npdKAJCGWBkm+dGAn7i8qLR1VSmxlg=
X-Received: by 2002:a1c:2543:0:b0:3c6:b7bd:a474 with SMTP id
 l64-20020a1c2543000000b003c6b7bda474mr26338731wml.95.1667430918414; Wed, 02
 Nov 2022 16:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com> <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
 <Y1xOvenzUxFIS0iz@google.com> <CALMp9eT9S4_k9cFR26idssjV+Yz4VH23hXA10PVTGJwNALKeWw@mail.gmail.com>
 <Y1xbINshcICWxxfa@google.com> <67c59554-1d90-0c7c-a436-e2dd0782f4cb@redhat.com>
In-Reply-To: <67c59554-1d90-0c7c-a436-e2dd0782f4cb@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 2 Nov 2022 23:15:06 +0000
Message-ID: <CAAAPnDGexF_2kotfhtQ8cfFkC8oAUQ5_A4Q-RYkH86LvApMkcw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
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

On Wed, Nov 2, 2022 at 5:55 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/29/22 00:43, Sean Christopherson wrote:
> >>> Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
> >>> is writing '0', e.g. it would also skip the case you encountered where the host is
> >>> blindly "restoring" unused MSRs.
> >> The VMM is only blind because KVM_GET_MSR_INDEX_LIST poked it in the
> >> eye. It would be nice to have an API that the VMM could query for the
> >> list of supported MSRs.
> > That should be a fairly easy bug fix, kvm_init_msr_list() can and should omit PMU
> > MSRs if enable_pmu==false.
>
> Aaron, are you going to send a patch for this?
>
> Thanks,
>
> Paolo
>

Yes, I can do that.
