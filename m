Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53FA36700C
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbhDUQ1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 12:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhDUQ1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 12:27:20 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41890C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:26:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id m13so42936061oiw.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 09:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mc4Wz/Ltt0NhR+/+CNrXA0voQfkr4j+wi0eXrEYYBoE=;
        b=mVapQl9TEL29cGGqX9itdR7/UJK7ZSMs/FFd0T8DnM2fa+Y4G/VxkvysIJWLeyDVs2
         HIMYv+tLAfdapIABJq6XOGrSSwTJUmFrHBCN6NRDg1A3bUGa+ZJUnHiaFHa5YHN/z+Pl
         gNQbrwUC1H6LUnrkDsaX3jIXZ8SMlZx78RJly++luQvFjyqD5pbWp+IYyfr2lu9Dj/dn
         yKtXUShIHzeTpUEvJxVvxmm4hsEUYmU8iVWJTP9jaXEd/w81Qt8wgjZ4kk5FCj0WrROz
         9046l+03sFR8AqoaKbjRCQ3EWUp3rxLjGfvl+6ScmC2I3e5eLJguTtogSVzeqKp//Vuo
         jhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mc4Wz/Ltt0NhR+/+CNrXA0voQfkr4j+wi0eXrEYYBoE=;
        b=Am0Cru4docoydgimoIAk3iF2j9ezfnEsH/SLxugWdgXCflYdcY0kEm0pyK+yVS/nXb
         LNaHbJ9IO3havpCzozh9crqOWJtQ+4s7sXV1ysK3Lts51ISVCq0kcfqGrhO9Dw/iHokq
         XB16BxDnQuoBJptNOvP9iYkQxoIqOu8eJdTJXsROf37SPSuIqUL5g+RCGwc6EvM0hDrY
         b0c/ShdFTYFI/xRgFZh+lag4u1fXA7eb4+at11hJ+k0QWvSLO/sWFic1HvxRQbcygiby
         UFZaoaDXrtKPFQHamd2k/+Fq1KQ8rPidV6crin5nIZyWGtYXo4MmCBkcQf94mhHrCafE
         yiUQ==
X-Gm-Message-State: AOAM5300/LbmB6sxUBh6b+7RYwj8imp3zmyamVJ8gaOSbu4w7RYmjXwH
        bV63qZcpu2a1y0Q4JgPHDcUl5d/euZtunYiUXMiuCw==
X-Google-Smtp-Source: ABdhPJyNyuRKvNR2QR6coFrtTNnTJL25Mg5vMTjeAdL6Yhceu9GrpPh48bTgBJQZjGawLDGba3GUbZuH7aghffpuY/I=
X-Received: by 2002:a05:6808:b2f:: with SMTP id t15mr3515949oij.6.1619022405322;
 Wed, 21 Apr 2021 09:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <YH8eyGMC3A9+CKTo@google.com> <m2sg3kt4jc.fsf@dme.org>
In-Reply-To: <m2sg3kt4jc.fsf@dme.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Apr 2021 09:26:34 -0700
Message-ID: <CALMp9eQZLe_8esohDqt_0eLffOrAeC0vS1RSVw152z2RhmPntw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 1:39 AM David Edmondson <dme@dme.org> wrote:
>
> On Tuesday, 2021-04-20 at 18:34:48 UTC, Sean Christopherson wrote:
>
> > On Fri, Apr 16, 2021, Aaron Lewis wrote:
> >> +                    KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> >> +            vcpu->run->emulation_failure.insn_size = insn_size;
> >> +            memcpy(vcpu->run->emulation_failure.insn_bytes,
> >> +                   ctxt->fetch.data, sizeof(ctxt->fetch.data));
> >
> > Doesn't truly matter, but I think it's less confusing to copy over insn_size
> > bytes.

> And zero out the rest?

Why zero? Since we're talking about an instruction stream, wouldn't
0x90 make more sense than zero?
