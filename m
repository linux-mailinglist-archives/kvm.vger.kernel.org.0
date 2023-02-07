Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8068DF50
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBGRvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjBGRu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:50:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF58D20065
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:50:51 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id o187so19490243ybg.3
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NHYthNCs/uoF20ZFkRUqehTGzlGvEoUQyE80/wwf1c0=;
        b=P682S4xmhi0gmdf3Pkax1AWCRl+BRXMVfM8MaPqlBDlER+3t6zfvCM2uePuXqncLDL
         nktKxPRDUmG6t32WjlKjkMb6cudhfSbKwPulG44Wlq9X14aMFJhFXg7LD/BeWr5V0t/y
         9Owauh6LCbLVot2lEGI5s+UrFdN/mKPTvO8Ednd8sWlQPe9+n3E5kc/AajhQxVmhJX66
         u6QIuZ/v5e1mbQER+rQEwNb00x+ip248stHpV+EYXIVDbXRuEkwCMHvqRZGYMEdkpC5O
         SEfl0YGeUXDi5XmOQtmUQCkKvujFX538zSXgq8ncG5ZaEWGgkEkVmeCigdEq/NHNlIta
         03lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NHYthNCs/uoF20ZFkRUqehTGzlGvEoUQyE80/wwf1c0=;
        b=Fr9RryXYhZTnRZZP5lbDHRilA9tVpw2cR7dk4S0sNWHuhqTXmqquX/dZkQp6sKDglW
         zrw/tI2KrjR5jtU7zPRxtraflIzDYrVtvgzHyu3C0DaeuHAwOWxiys3nmMP2nTyRRkE5
         e99ZxLxSAzjPQFa8ZlHEm1qcTdfecPms6XSMutVs0mwvNkFetWKm5izafQyvQYTYEIUy
         ZI40ATVRBLKXV29vq6JOuOaloqwkIqZyaf2TNrxInOUxZS8BCI4KOr+WqkrTA7LlbiXM
         XJnUXtEk7Wt6kj4D+1V2hHT1Uavxkv3LDp5dk2BunS+O4qz6kZsbhQxGMprz6qUFesvu
         shFw==
X-Gm-Message-State: AO0yUKU4/9JkqZ+N6Jxo4YgtIWOYjSTXWi+Z7fQIzte76+1mJ0/P/jhI
        DlEEPe5ngQ3saX5oHv7UlBBd34c/bpgLcos8x7XsdQ==
X-Google-Smtp-Source: AK7set9anGmKon0xVKOvpGVdGi7bxLITfCkJwK78pPfBsAQO/8Xxo0kriOrfr3wa8rlWE9+RN2w0633Iazi/MlIzDz0=
X-Received: by 2002:a05:6902:45:b0:8b1:b64c:648 with SMTP id
 m5-20020a056902004500b008b1b64c0648mr259185ybh.401.1675792250899; Tue, 07 Feb
 2023 09:50:50 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-4-vipinsh@google.com>
 <Y+GTyVHvpskr8YxD@google.com>
In-Reply-To: <Y+GTyVHvpskr8YxD@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 7 Feb 2023 09:50:15 -0800
Message-ID: <CAHVum0dxAnm7SP9iCBk2eMeTNr5u_H=TTgZZJSJpx0Fxw5P-Ag@mail.gmail.com>
Subject: Re: [Patch v2 3/5] KVM: x86/mmu: Optimize SPTE change for aging gfn range
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Feb 6, 2023 at 3:57 PM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Feb 03, 2023 at 11:28:20AM -0800, Vipin Sharma wrote:
> > No need to check all of the conditions in __handle_changed_spte(). Aging
> > a gfn range implies resetting access bit or marking spte for access
> > tracking.
> >
> > Use atomic operation to only reset those bits. This avoids checking many
> > conditions in __handle_changed_spte() API. Also, clean up code by
> > removing dead code and API parameters.
>
> Suggest splitting out the dead code cleanup to make it easier to review.
>

Sounds good.

> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++------------------------
> >  1 file changed, 25 insertions(+), 43 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 83f15052aa6c..18630a06fa1f 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1251,32 +1228,37 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> >  /*
> >   * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
> >   * if any of the GFNs in the range have been accessed.
> > + *
> > + * No need to mark corresponding PFN as accessed as this call is coming from
> > + * MMU notifier for that page via HVA.
>
> Thanks for adding this comment.
>
> Can you just extend it to mention that the information is passed via the
> return value? e.g.
>
>  * No need to mark corresponding PFN as accessed as this call is coming
>  * from the clear_young() or clear_flush_young() notifier, which uses
>  * the return value to determine if the page has been accessed.
>

Sure.
