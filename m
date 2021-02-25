Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E217F32499C
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 04:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhBYD5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 22:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBYD5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 22:57:09 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7329C061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 19:56:28 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y202so4484574iof.1
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 19:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VMhssfkntbp6BkEdgeddf6ITSgH2/sACeJhofv7G7Qk=;
        b=pxq5QeWUzVL/vGfbVNLb2osJm/A4y0MvKWH4ryodlpu0IGEyWYJkLK62EquwoT5vXh
         NjkZcEXppruaW6kFhkh974WJiWPRwzLu45wO2HtCpV4jNukAZT1RhMTu43qeag0yBWJz
         po+gSu7r6sRDp+sqq853uK73AqEBXX/5Ci5/PgDbWFH8WHeFGpLcwOUqddgQPo53HFJU
         p8XlSL2wWT8u/rrxAc7omZUYo/nQEJDVAE/+Dxk9+arLL2hPE/xen1C9gnqBQGfnytTY
         j+FXMPiW8pn8RweYVtBm5CtEflk1w5nPIbrkJEb/9RmPioWT6g7WR8pqwby6N9rhNJo7
         R9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VMhssfkntbp6BkEdgeddf6ITSgH2/sACeJhofv7G7Qk=;
        b=ivxMBINhVO6oUYb3+t7QnMA4iKbv+73QFMLnj5dAYPkqfkAOHlvc8sQ+XN7MW+HHE7
         CiMK9JK2SMOH2d2BUIkjzM0wEfoI6yYf/9ba+Hl0XaBKzrU8gZ7/ACW2Do60lTS1ViN9
         R+oTteCTyh/4GcqBdQsc1DOaHo5ED8YyjrGARbYWuifMOkA1p/ZFi5iQ/pRR+O5ZzAtc
         5mRx5+LAyJSOm7LWQ9cWzxzvJxRhzJS1HgPK8bC5o7FjIXBPMqlf3S0vocTM9UAAAAwM
         cJ4dNaL8h4bV8KVXXH5DpfEF/dyV0j9hGuif/NaklQe3SRNXICP8mJccwRDGK5rmNs8F
         WXyQ==
X-Gm-Message-State: AOAM530zlev+RWuX86wN8fc05FBU6pDW72YCjwQlJw51NRK151sQWSE8
        RXSIzewfKWYFtnER8hgZlOw3nnznGMWllylGe/I6uw==
X-Google-Smtp-Source: ABdhPJyLZIGwvciSXuv0EOvVOClNo6/DzD3V+vVlnTp1m0pld87jItvthB4sJcyYaZwS1w1U59K0L9OT7StOa8lDIJM=
X-Received: by 2002:a6b:c40b:: with SMTP id y11mr991070ioa.205.1614225387929;
 Wed, 24 Feb 2021 19:56:27 -0800 (PST)
MIME-Version: 1.0
References: <20210224085915.28751-1-natet@google.com> <YDaOw48Ug7Tgr+M6@google.com>
In-Reply-To: <YDaOw48Ug7Tgr+M6@google.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 24 Feb 2021 19:55:51 -0800
Message-ID: <CABayD+f6q0q2v7pT-hjD=oP_+hAyEW5VA2WoTQNn=5-=OD1e1w@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
> > +     unsigned int asid;
> > +     int ret;
> > +
> > +     if (!sev_guest(kvm))
> > +             return -ENOTTY;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     /* Mirrors of mirrors should work, but let's not get silly */
>
> Do we really care?
Yes, unless you reparent mirrors of mirrors to the original ASID
owner. If you don't do that, I think userspace could pump a chain of
mirrors to blow the kernel stack when it closes the leaf vm, since you
could build up a chain of sev_vm_destroys. Refcounting the ASIDs
directly would also fix this.

Nate's early implementation did the reparenting, but I pushed for the
simplification since it made the locking a bit hairy.
>
> > +     if (is_mirroring_enc_context(kvm)) {
> > +             ret = -ENOTTY;
> > +             goto failed;
> > +     }
> > +
