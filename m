Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352B428640C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgJGQah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgJGQah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 12:30:37 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D775CC061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 09:30:36 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o9so2878313ilo.0
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYMk+BlOXeIbztTTmOGtrLRWb7ewhHw6QepmeLnJlMQ=;
        b=Y4+NKXdlYiaTxkXT9l/2+Nk56HfwQ2izplaW+tMW3d0vI4hwfIC5V8T2ruDvM0wUNb
         yAPjVLoCd3dSKe2CMd6GozDwwbjRFayGNqlAb00cDAldU9bBDMLQfDJNr1gfV5cHAAaf
         /Z77J4+EhN66Oxu7/U6S2CevfxJwD8Y/meciKSGT0YiMbOeBYXIyiKiYjReB102VMaQ2
         pk01mw9bZbvbUxpipQXJIWIZ8X+p311eE3aTLuxeb5hV41N5AtMTbTX46pfwersSs8SQ
         IxEnrPM5BvSJ9lgamii7Kt//gXnrI3fPFKGpbt95RQHe2+2TJ2LX0CESU0s2JRmQ1an/
         IxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYMk+BlOXeIbztTTmOGtrLRWb7ewhHw6QepmeLnJlMQ=;
        b=nIz+YmZMtfhj7OuX56+lcfBWIk1ZCOZBiZVZnMCMtyb/NA8z5K4b7/qNve2TuhN1up
         CYjGiyMzM63RAUHM/R3EzQ2Cn6csMbuCeOrMTQ/bh6up9DiZxPEeglF4SbMjb5aTTe1r
         wUa74K4tL44U3uKw2dRC1doSwxCRy5ZY4ZBK4k7kFN6c0xYw8tAMde+iPbkhbyWuFBAC
         Svltfu63dJCqQC2m3VXPuuMZ8UerKfnf5MgAwhcDTfJV+/R3BGuahe0qiIQkHfoWivtg
         XSdd/5YMHaeW+sGuTmmaoG+bxCTMwHdynLi9W0A3AZ1834wSgC6EEsk780ppDZNV04VG
         Sb/w==
X-Gm-Message-State: AOAM532FS5BW+YRexU+e3K6sYPrREMK6eiBTF/MC3ft0OpNSYkPxZ5dq
        22ONmyEp+U1sU+Yva1gVNA6hvI04rCFESZzsgWpv4g==
X-Google-Smtp-Source: ABdhPJz1pivHDuMpRIp1ymbBND8FIwBI+9YWjqbDyuFQsSBKh6gKtzo/VQ/hpFczpGrC3Z/Fe1wNF06wJy3f0eJ9Kos=
X-Received: by 2002:a92:cbcd:: with SMTP id s13mr3157728ilq.306.1602088235893;
 Wed, 07 Oct 2020 09:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-19-bgardon@google.com>
 <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com>
In-Reply-To: <44822999-f5dc-6116-db12-a41f5bd80dd8@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 7 Oct 2020 09:30:24 -0700
Message-ID: <CANgfPd_dQ19sZz2wzSfz7-RzdbQrfP6cYJLpSYbyNyQW6Uf09Q@mail.gmail.com>
Subject: Re: [PATCH 18/22] kvm: mmu: Support disabling dirty logging for the
 tdp MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 6:09 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 23:22, Ben Gardon wrote:
> > +     for_each_tdp_pte_root(iter, root, start, end) {
> > +             if (!is_shadow_present_pte(iter.old_spte) ||
> > +                 is_last_spte(iter.old_spte, iter.level))
> > +                     continue;
> > +
>
> I'm starting to wonder if another iterator like
> for_each_tdp_leaf_pte_root would be clearer, since this idiom repeats
> itself quite often.  The tdp_iter_next_leaf function would be easily
> implemented as
>
>         while (likely(iter->valid) &&
>                (!is_shadow_present_pte(iter.old_spte) ||
>                 is_last_spte(iter.old_spte, iter.level))
>                 tdp_iter_next(iter);

Do you see a substantial efficiency difference between adding a
tdp_iter_next_leaf and building on for_each_tdp_pte_using_root with
something like:

#define for_each_tdp_leaf_pte_using_root(_iter, _root, _start, _end)    \
        for_each_tdp_pte_using_root(_iter, _root, _start, _end)         \
                if (!is_shadow_present_pte(_iter.old_spte) ||           \
                    !is_last_spte(_iter.old_spte, _iter.level))         \
                        continue;                                       \
                else

I agree that putting those checks in a wrapper makes the code more concise.

>
> Paolo
>
