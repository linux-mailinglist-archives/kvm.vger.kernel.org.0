Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13DC368BE2
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 06:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhDWEP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 00:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWEPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 00:15:25 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1C7C061574
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:14:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n2so71914979ejy.7
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ewZRbdSFfqRwOjkDy9qCZ0qjWdLubo+UZrcVTtz9qfM=;
        b=NcrjteydTST8CV9cA+8xOuFUNnE5KPh8bvq53ce7PriuqKv5md5z/36c+1BkSwldVt
         voi5JmLnNH3ERyR4L7B4jv37jgCn6t8IMatx2m0P6qmcEO30/1LRdbhvnAXVe7WhOcst
         +85H7TkIidLB26wmGxbtIA8mii7Sa0ZhwUcD5zjsEjPHwzMSGwSpI19WaZ2d8BXrU5sb
         XtuMU/BRHcHJm6ZZ8JpGZpFfFbyBD/AKep11ScHX75P0PXEb/g52PQL5d88sB/4iVspu
         8xvP/GiMUVeKovtiRdrmYizGKSyVCge05rFtTCoyWz40U9Apd4x+5/+faCUjxutQEqnW
         Ymcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ewZRbdSFfqRwOjkDy9qCZ0qjWdLubo+UZrcVTtz9qfM=;
        b=J1E59aYSegMvm/Sl8NjRFATyzX9lBoDRb6oovr5liKWAoL8A68w2gyVToKqfFahFRS
         2j6kGs1x4uMGBNYL9eZ37K5DFlWs6Q/1uIuMHzCxRdCMMUwSJrVnGNYqRoqhKoNinhND
         EFmLObGawsWFvKu1PDy0ZEcR2mewbb0nfzXuFS1K+RWDQB6Rs4TFu4mmngIrQ+YkdPq9
         u1L5OJkO4h0Pxo34AU0gsMEvHalJQNzMH6mOYtFu6eehNcQKB1Kg8Ujsl1JzbozSEuGI
         2/AOz9hWDqJM4Ag/IL0tTJKYV3c5lBSb/nnv7QwpWevJwzXbOwePa4im2yYCA4XISQgO
         JIuw==
X-Gm-Message-State: AOAM531RA+5mTvWG3Drcjl1Ron7GAV+M3FguVWM1/vXbgIyr20Fe8BRJ
        C1CyJGYZBIAvZATRBcR2nI2Ywm7NEl28dJ/B6JV9Wg==
X-Google-Smtp-Source: ABdhPJyHykrt9feyr6dMIoh8NLCtxTXIBKu47rrjyTryLn6Ss4s1v06APkTLZuHrsDGy4x46/dEOczxQP3hn/swA8Rw=
X-Received: by 2002:a17:906:3153:: with SMTP id e19mr2031287eje.351.1619151286882;
 Thu, 22 Apr 2021 21:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com> <CALMp9eSu9k57KvGCO6aDEFgkV-Vxrnr1j7CbiLYbtKYG1uwMZQ@mail.gmail.com>
In-Reply-To: <CALMp9eSu9k57KvGCO6aDEFgkV-Vxrnr1j7CbiLYbtKYG1uwMZQ@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 22 Apr 2021 21:14:35 -0700
Message-ID: <CAAAPnDH_EL3S5WqgLNWQOLruKeStemYtq9vAKVSfV6po3LNGxA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Jim Mattson <jmattson@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 5:57 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Apr 21, 2021 at 5:28 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Add a fallback mechanism to the in-kernel instruction emulator that
> > allows userspace the opportunity to process an instruction the emulator
> > was unable to.  When the in-kernel instruction emulator fails to process
> > an instruction it will either inject a #UD into the guest or exit to
> > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> > not know how to proceed in an appropriate manner.  This feature lets
> > userspace get involved to see if it can figure out a better path
> > forward.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> The instruction bytes are a good start, but in many cases, they aren't
> sufficient context to decode the next instruction. Should we eagerly
> provide that information in this exit, or should we just let userspace
> gather it via subsequent ioctls if necessary?

Why is there a concern for the next instruction?  This patch is about
userspace helping with the current instruction being emulated.  I'm
not sure why we would be concerned about the next one.
