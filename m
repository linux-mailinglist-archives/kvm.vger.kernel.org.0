Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C773E6B7
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjFZRk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 13:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjFZRkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:40:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CE335B7
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:39:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b8161f564dso12335ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687801126; x=1690393126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnOW0xT5vQ5Av3Y9zgLv4Rm4Hfmf/1VJmsqhaRUinD4=;
        b=TUU5FDQJ3oYqPE3qDHrBI6fwe4I571fEYBA0VqrYAi7cDeMjY0wKJfR/qH2TqovmSL
         iluh0WAWNzpjTuCPT8B2agKYqsBsyj1ZwkrQxsmQl4GlCoQplmsa+3qosl+ZYC9RXnaH
         /TAWG9q8l24d58A9xjxFpcWMfZpsdu/vyNrR76MTJQiJKHPPzA7G6EmJIozjjXCUhGX4
         HgO2d0f1g1UzZjq6jYSlXutQdZJcTv/v/ssxwcfPfI2B1Rmt5hnku7VpFof8YVOfVKUW
         fuaDPRVMPJWEsOIcLs7unSsJzzWuE+LGB5k+keJ+AzelKn9D2wC/sdAoTTKlGToGDgW9
         j09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687801126; x=1690393126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnOW0xT5vQ5Av3Y9zgLv4Rm4Hfmf/1VJmsqhaRUinD4=;
        b=VG1dEWI4Qb39vOamrqXd/Ccxj6ayk3b/ONL2MxnTpuYKnV0anHyAiK7HzeZunM63Bw
         n5vExziKQ8JcxjoO3+fkDFux+L7cpYRL9iRrpGCshvhTS2IHhI7OlwQ+MB5kOKQgGkND
         R+HpT2u5vZggHsIw5UhKpPh/QUvo1kmPvfXGb4nSkQFfnJ1f/w2/Opuh0sovLF/7CUsY
         kVaZucWKPkOL9BOc1eFRFvu6SPQtFFn8Z7AXIT/ZzcSH/snLKvJQ+O0r/xhi2F7HmVs0
         VhStFCIV4+m8pt0epRUNK0xibla9EOzA2VzOptB6hqEyROcSUTphxXXvoWjoGA6JWkqz
         1G5Q==
X-Gm-Message-State: AC+VfDzZcWUsIgVXrKt3AZHCjPvJ0LawDaOvlT9VN8TIUV7VT0oMiwdT
        V1RdNsMeYkJLoDMx2u9sr6fOKAQ6PqeZfnzDRuFMlw==
X-Google-Smtp-Source: ACHHUZ4MH0OZy3lD6UGeyuNNbWYbl4Jr2Ip0p+nhEVV6ESU3PL17fzY9SkLenEMqFlPeT1C9o8cn8wB3BwK8DHU561w=
X-Received: by 2002:a17:902:ecc7:b0:1ae:4008:5404 with SMTP id
 a7-20020a170902ecc700b001ae40085404mr2096040plh.0.1687801125581; Mon, 26 Jun
 2023 10:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
 <ZH4ofuj0qvKNO9Bz@google.com> <CAL715WKtsC=93Nqr7QJZxspWzF04_CLqN3FUxUaqTHWFRUrwBA@mail.gmail.com>
 <ZH+8GafaNLYPvTJI@google.com> <CAL715WJ1rHS9ORR2ttyAw+idqbaLnOhLveUhW8f4tB9o+ZsuiQ@mail.gmail.com>
 <ZH/PKMmWWgJQdcJQ@google.com> <CAL715W+KSgNMk+kTt3=B-CgxTkToH6xmvHWvVmm3V+hir-jE=g@mail.gmail.com>
In-Reply-To: <CAL715W+KSgNMk+kTt3=B-CgxTkToH6xmvHWvVmm3V+hir-jE=g@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Jun 2023 10:38:34 -0700
Message-ID: <CALMp9eRvUky-jcrkJ75N5-kvWWxVMNaf95XpyGTa_k49n48g9A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Jun 15, 2023 at 4:58=E2=80=AFPM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> On Tue, Jun 6, 2023 at 5:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Tue, Jun 06, 2023, Mingwei Zhang wrote:
> > > > > Hmm. I agree with both points above, but below, the change seems =
too
> > > > > heavyweight. smp_wb() is a mfence(), i.e., serializing all
> > > > > loads/stores before the instruction. Doing that for every shadow =
page
> > > > > creation and destruction seems a lot.
> > > >
> > > > No, the smp_*b() variants are just compiler barriers on x86.
> > >
> > > hmm, it is a "lock addl" now for smp_mb(). Check this: 450cbdd0125c
> > > ("locking/x86: Use LOCK ADD for smp_mb() instead of MFENCE")
> > >
> > > So this means smp_mb() is not a free lunch and we need to be a little
> > > bit careful.
> >
> > Oh, those sneaky macros.  x86 #defines __smp_mb(), not the outer helper=
.  I'll
> > take a closer look before posting to see if there's a way to avoid the =
runtime
> > barrier.
>
> Checked again, I think using smp_wmb() and smp_rmb() should be fine as
> those are just compiler barriers. We don't need a full barrier here.

That seems adequate.

> Thanks.
> -Mingwei
