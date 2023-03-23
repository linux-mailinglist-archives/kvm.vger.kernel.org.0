Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D67F6C7257
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjCWVaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCWVaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:30:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE60E057
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:30:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p9-20020a170902e74900b001a1c7b2e7afso85114plf.0
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679607002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hgyyqWHdWQ1oKWLENS4QWpBGzNOk+HCg4Piu7zsWyU=;
        b=VC7vJHPl1u5wfacX2P96EJMqxgdSZCWjffPShMCpQhljCD3q+t/IY0PHFHLJW4x0rg
         +HUDJHI6x2Zm8AabFW6vVbOnzu6DEnBnDF8hA/Gx/5+DnxfbTHNRqKr2cEm0aaDOBO9u
         dgmwTme9PRlWV7UJYxpoT83rNbX85E39qDw4ieJOvwpVZxbzEvV2fx+5MKoQK0kM2THC
         sXcRyv/9Jq8YDQV/UxeLZCcDiV49HZbyGzj/HrC1m0QGz6aDedUFPgnuTqbMvIxvkP2Q
         BpUu+LPB+KrLPtxSyPnZExIW/h/mAPUQavZXHdZXYsn/OGoeD/vFMVCN6nPodhS8X7hp
         OtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679607002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hgyyqWHdWQ1oKWLENS4QWpBGzNOk+HCg4Piu7zsWyU=;
        b=jDl5s7E0NJeoUFCzJmMx0JHw9GJLYMiI5Sp/mjT58Rs+t5t2pxyHFEqTRCNLT0rnTu
         dNpbULUYhHHUoFTMxFSv4E3vlC0BPJQ6S8H7n+AKVVXV3BViq1oapaBLgfZNMJi9c13s
         LzCefbGT/W+W82gxtXUnlXPVPOOr+rkAp6iGAbxsXAZl1R7EA68vclB3cJkmCXmKrMNY
         coI2UCcagpbeJS+7xdEC0iuScOfqhvnMdX6I5cRJPUQmz/zPeVVvXTRsQSz/CNZYzi2v
         drByiaHgmYcrc60D8SNutt27kwZ/Rg08pfHuFC8mgHN/NVs7q4LupitFU4eq7qwpqov8
         41Xw==
X-Gm-Message-State: AAQBX9fTSCvhj+15rBtTawq8em6GXTJW2Fgt6t5X1BJ3KcG5cqEVYBzW
        vdGr2A7Z+7Wv3aswI+CTzfPMOlxXF+Q=
X-Google-Smtp-Source: AKy350ZQnCo8AtrV1rzzvVI7iZec6PUQD5nZ08WSU0xLErpgfXhjzMSb1qzaV/S6LpA7CAz7kPank1DSvSg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1781:b0:593:fcfb:208b with SMTP id
 s1-20020a056a00178100b00593fcfb208bmr466647pfg.3.1679607001861; Thu, 23 Mar
 2023 14:30:01 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:30:00 -0700
In-Reply-To: <CAL715WKbwRnk6BPSxzzcDpeEhEnJd8sjZHc+9ruV1sQ7iDsyJw@mail.gmail.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZBy2tcQzERBpsoxz@google.com>
 <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com> <CAL715WKbwRnk6BPSxzzcDpeEhEnJd8sjZHc+9ruV1sQ7iDsyJw@mail.gmail.com>
Message-ID: <ZBzE2NZdE7ANB+Hk@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Mingwei Zhang wrote:
> > >  static inline u64 kvm_get_filtered_xcr0(void)
> > >  {
> > > -       return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> > > +       u64 supported_xcr0 = kvm_caps.supported_xcr0;
> > > +
> > > +       BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
> > > +
> > > +       if (supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
> > > +               supported_xcr0 &= xstate_get_guest_group_perm();
> > > +
> > > +               /*
> > > +                * Treat XTILE_CFG as unsupported if the current process isn't
> > > +                * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
> > > +                * XCR0 without setting XTILE_DATA is architecturally illegal.
> > > +                */
> > > +               if (!(supported_xcr0 & XFEATURE_MASK_XTILE_DATA))
> > > +                       supported_xcr0 &= XFEATURE_MASK_XTILE_CFG;
> >
> > should be this? supported_xcr0 &= ~XFEATURE_MASK_XTILE_CFG;
> >
> >
> > > +       }
> > > +       return supported_xcr0;
> > >  }
> Also, a minor opinion: shall we use permitted_xcr0 instead of
> supported_xcr0 to be consistent with other places? This way,  it is
> clear that supported_xcr0 is (almost) never changing.  permitted_xcr0,
> as its name suggested, will be subject to permission change.

Ya, works for me.
