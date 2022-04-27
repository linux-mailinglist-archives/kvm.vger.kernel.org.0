Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9013F510DF3
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356725AbiD0BeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351630AbiD0BeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:34:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028732C102
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:30:57 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so334610plh.1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sCWqajasA7ISIMDWcDl8o7kKYsl9k0UXiOkTS2c8CkA=;
        b=CgjAmV3+4L5oDF5/Ww+PKMhWwfZTnIeyhNvyibGENxZ1fU+LuOuGhRPMqS23/A+UnL
         8yD4EvpKtSup8J3Oa3anE+tiHnsreDKDnCmN175zFehTg98rJrfRoQFhcM6VmEidE6Lr
         TsyHBPX5mG0QFRCUZoXGTn6jtjdtjMJl0+7Mujd7v8wDqRGHKbOH4kgZw9xv2EvoSACx
         6VjKo6JFKEAM5nNiyO9Yl9wK1dEGP546Hq0YOv+Zxse9y7VUreXfshGcy6lWuDcFo8mF
         mCEZWgRGWBPpM3pYSZQ+GQ5DwDJodZA7C+pakJx8z/Dp+ID4qO0gMLy/kpLR9i0xy75E
         8IOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sCWqajasA7ISIMDWcDl8o7kKYsl9k0UXiOkTS2c8CkA=;
        b=usLzJsRfey2lb3fsMudkt81l6c5/9W4d33kNYa2fr/duCKQnoDvdhBwZAeHuXv9B1e
         dwMHoXGnJhkY9QVbMFfl6aBrqlw7Tn48JQWaFtKptvjh3GJRwjW+fso/M0C/JaJ/1yAy
         aEze43lh22y7TJ6T9fQDKNPUkkS1uNjJBQWQtYjbSkqjRRXbfumKHk/ZOaS6CbK2pTYi
         4BHcYBwyionRVfLhStVyMXmWFJxYMNhslac8th7PHt89MGkjMBH9gP+zhOCmRXD31pGp
         EfTqi+c4api0QfsZKeGFgiV9kTZ/abG3PzzFJrrHnd0OG5KoPN/S47u353zIOx1mKNOY
         yoqA==
X-Gm-Message-State: AOAM5331/Gqtk+z7EkQHyqmbOL4EvG+BCHov203vZu9B4G3R13pNc6NJ
        IrvWpFR2qe1jUwLcd1HeHGudtw==
X-Google-Smtp-Source: ABdhPJw1q0Fag74CGwko5HHS4Hk4zlk2TrCAQ78XHacUPoQtem1CluOKqzNTZkS5BQBYQuJ8PiRMqw==
X-Received: by 2002:a17:902:e84a:b0:15c:e28c:5f7c with SMTP id t10-20020a170902e84a00b0015ce28c5f7cmr20698565plg.94.1651023056330;
        Tue, 26 Apr 2022 18:30:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y2-20020a056a00190200b004fa865d1fd3sm17211203pfi.86.2022.04.26.18.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:30:56 -0700 (PDT)
Date:   Wed, 27 Apr 2022 01:30:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Message-ID: <YmiczBawg5s1z2DN@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
 <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com>
 <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
 <Ymg1lzsYAd6v/vGw@google.com>
 <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
 <YmiZcZf9YXxMVcfx@google.com>
 <CAL715W+nMyF_f762Qif8ZsiOT8vgxXJ3Rm8EjgG8A=b7iM-cbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715W+nMyF_f762Qif8ZsiOT8vgxXJ3Rm8EjgG8A=b7iM-cbg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> On Tue, Apr 26, 2022 at 6:16 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > > > I completely agree that lookup_address() and friends are unnecessarily fragile,
> > > > but I think that attempting to harden them to fix this KVM bug will open a can
> > > > of worms and end up delaying getting KVM fixed.
> > >
> > > So basically, we need to:
> > >  - choose perf_get_page_size() instead of using any of the
> > > lookup_address*() in mm.
> > >  - add a wrapper layer to adapt: 1) irq disabling/enabling and 2) size
> > > -> level translation.
> > >
> > > Agree?
> >
> > Drat, I didn't see that it returns the page size, not the level.  That's a bit
> > unfortunate.  It definitely makes me less averse to fixing lookup_address_in_pgd()
> >
> > Hrm.  I guess since we know there's at least one broken user, and in theory
> > fixing lookup_address_in_pgd() should do no harm to users that don't need protection,
> > it makes sense to just fix lookup_address_in_pgd() and see if the x86 maintainers
> > push back.
> 
> Yeah, fixing lookup_address_in_pgd() should be cleaner(), since the
> page fault usage case does not need irq save/restore. But the other
> one needs it. So, we can easily fix the function with READ_ONCE and
> lockless staff. But wrapping the function with irq save/restore from
> the KVM side.

I think it makes sense to do the save/restore in lookup_address_in_pgd().  The
Those helpers are exported, so odds are good there are broken users that will
benefit from fixing all paths.
