Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875AB725023
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbjFFWtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbjFFWtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:49:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC8010F7
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:48:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5149e65c244so307249a12.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686091738; x=1688683738;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=11+Fn4bWT5HyJ3ecoDvvkwIK5czC1OHLstovcMpNWzY=;
        b=xcFZ20/KI+gH9h1aswr2cXKq1khb/AkPQgQD7SPzq6sKaNG6t48qOijlqVmbkAcMVU
         RFs7rjdiIE4O9Wy+Y8AQMk5o8G3I3Fb7p7QpAvafuk7IEDDOfdGA3tMKDWEX9CRjNTrZ
         Z4SrXwPoYzdF5UJm/TRHnGPPmkuC71JZwiDk2/HhCakKGFFGDpFjmFkCYn4KhRb9AY9o
         sF5MEw0HUw0U3aJ7KokhAceEYqfdx0V5nVskcI/09ta04XaNf1RuFynMYsTorTQXPup9
         sRRCFoXdF/CwzkLg3bfBrzqWawkcYwxmcgAMO2+/J1wbUfMuI808wmmWz3b3R8SxAdx2
         knyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686091738; x=1688683738;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11+Fn4bWT5HyJ3ecoDvvkwIK5czC1OHLstovcMpNWzY=;
        b=NteDj4c23wAgQF9BFcXQjy+8xQTEcvjeU9EU03kj9jawUDUg8B3YU8EtTqwqDVB1Kr
         mW0K+uZh46ZM4ej4oG0K3qbEg7FamvQk34PuEbvnbZ7z1xa6fH7BS2wgrUAWP453ReA9
         UsJpodyK5Oh/4WXtWv1VQpxvW+QnDgxu9D/rB9U76O6K/NTGTLpdycjvzLpUqYmRoz/X
         dctn6K4jVOHNqNGvesT5964Mwudrl9ep8gqPnfYGqa2DydFhIVjQB8NZ/Uvj2ITfEZ7A
         +eIUiTMfs9IrjbMvwsbFmxRjngAg3ravP4E88u8pwR8m+8D6MBiROYMh1+mmpMNDWRc9
         BMnQ==
X-Gm-Message-State: AC+VfDxtcy6mKAejNLaNtar9ApUI3bGW0qEw5DcrSymHtgEz0cRATWbY
        a8kvdrj9RKlyLDfWM7yIEgsJFF9ZWBy3tXasiXjThWUe6Qrfe73GTzU=
X-Google-Smtp-Source: ACHHUZ7xhee1qjb5EuLRWpJGvhhzLzGQuJgaZrzsesCOJRGZzNc7bWUN57xNpGt1XoyAFy14iHmF2n3zHxQnLo/XN+U=
X-Received: by 2002:a17:907:dab:b0:977:95f4:5cca with SMTP id
 go43-20020a1709070dab00b0097795f45ccamr4445607ejc.54.1686091737924; Tue, 06
 Jun 2023 15:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
 <ZH4ofuj0qvKNO9Bz@google.com> <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
In-Reply-To: <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 6 Jun 2023 15:48:21 -0700
Message-ID: <CAL715WKHLzpnHF+HZH_8fNkUMfHYGHAOQacUNRR0b6-WpUuFMA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
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

> >
> > So I think this?
>
> Hmm. I agree with both points above, but below, the change seems too
> heavyweight. smp_wb() is a mfence(), i.e., serializing all
> loads/stores before the instruction. Doing that for every shadow page
> creation and destruction seems a lot.
>
typo: smp_wb() => smp_mb().
