Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1020C4F9DB1
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbiDHTeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 15:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiDHTeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 15:34:05 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567E765D15
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 12:31:59 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b43so12724149ljr.10
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 12:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSWnDwy5GUt+/a1J0rUjaMHTPO1fZjePnYOnz6ECODs=;
        b=J6rvlAz9Cp2QJU3tbf7mrKqVNZevpebfjuzhj0pqCUB0Tmk3hHxua8Tdy+DWDAeXI8
         /DelK0hyCzlNgGxefMxcPQM6gz/ybu3fFgH2UaRHk1dhHGheMGNbQNCgBamTehsvHw+R
         7ndDmkMsdiavJjLfWlBHgoxCmXQcWDnhrysc7Bcc+V/zcET1BdEFF2qINQmU146jKxwG
         OOtEXpDFZXusiU1TBivQDJf62aX9yIemLwtVeqRFt7I3vpIt+EyP571k3ueSj5P7lm89
         gvXO24Z+gZDe6jU+LJHEcj4xCwT2oCf+KRacp+Bm2XThH9+cvZYViXcg082Raxc4jguA
         vmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSWnDwy5GUt+/a1J0rUjaMHTPO1fZjePnYOnz6ECODs=;
        b=6yarpOQ/gBH4YGP6X9QvbqcaHTT1tSRQgr2x331oROYmd9+M7+G9AVqqJSSbUP+HtM
         7PkS25WpViIlh3YsV6paOF9WdClbPE+VSbFwniQCsXU8i2Rl7ZFsU21s4Nt8nUNDg+9v
         sSSs0Zth3PNtgoUZROBf6NpRsuQx1Lf2emE0+7CREw24yIW1kKD685JMu/QHyPefpthC
         pC1REp7+Myk8BIyVXvi2OR8CESnYZPLT6QcloPgjz54ASuv9Uc5wM36z95xjK6R3nDNP
         hsNYhQduxEeP3WA8HQDpQ0KJTWLsfCeSuHjOwIJ39jHJCugf48u8PsIiPQX2RaHjTvlX
         /03w==
X-Gm-Message-State: AOAM530Gd/z5D6yKHSXNlkMC6MLu8m5ArXRYOxT8Mni7bSLn/P1Vb4iZ
        54qQ1N6Y1SlAEz6HHV3jDHsYC89yq8822U8dEiNneQ==
X-Google-Smtp-Source: ABdhPJzsUYXxD/Pf/ZTVjarORMIi/VmYEjOnj9R5+hRboeJTgfHXR94L/O5B/aaXwBqY8p+XumxLGjlznhO42PwsLLw=
X-Received: by 2002:a2e:875a:0:b0:249:829a:d5f7 with SMTP id
 q26-20020a2e875a000000b00249829ad5f7mr12515935ljj.173.1649446317358; Fri, 08
 Apr 2022 12:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220325233125.413634-1-vipinsh@google.com> <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
 <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com> <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
In-Reply-To: <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 8 Apr 2022 12:31:21 -0700
Message-ID: <CAHVum0d=WoqxZ4vUYY37jeQL1yLdiwbYjPSPFAa1meM5LUBDQQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Sun, Mar 27, 2022 at 3:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/26/22 01:31, Vipin Sharma wrote:
> >>> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> >>> +static noinline void
> >>
> >> What is the reason to add noinline?
> >
> > My understanding is that since this method is called from
> > __always_inline methods, noinline will avoid gcc inlining the
> > slot_rmap_walk_next in those functions and generate smaller code.
> >
>
> Iterators are written in such a way that it's way more beneficial to
> inline them.  After inlining, compilers replace the aggregates (in this
> case, struct slot_rmap_walk_iterator) with one variable per field and
> that in turn enables a lot of optimizations, so the iterators should
> actually be always_inline if anything.
>
> For the same reason I'd guess the effect on the generated code should be
> small (next time please include the output of "size mmu.o"), but should
> still be there.  I'll do a quick check of the generated code and apply
> the patch.
>
> Paolo
>

Let me know if you are still planning to modify the current patch by
removing "noinline" and merge or if you prefer a v2 without noinline.

Thanks
Vipin
