Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9207B292C13
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgJSRCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgJSRCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 13:02:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737A3C0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:02:19 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j13so919296ilc.4
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nzm5xS7Ci3zh0ph+vnRyetdA6dBSqUpnuk3sW/kk95I=;
        b=WysGNIvRuybRX2GvmUWMW+4DdviNNOiqmoZgG0ZMLS17HdvWMuf+TXqa8sxlYLLkkc
         GwenSHD3Zhu3G1dV4EBV0TmezqSMbkQ5Xs8/GrhO5Vo8EBq8VVhDR05ZkceT8RoIZDbv
         ST97Nq7sKWI8r8e3CN2vSrCPCuZJHqnsjXqrPq8mPRY8i9vu57+/ChUGWSdiK/39k1nV
         zR65FibNQkHgvzyB5kU0LgjmY/Is9sGQ/71umgVeZpQAN8aUyFV0IqKnUwLDaMZFWcuI
         CDwe1FaZmAwK1xvs7cpjHgWVdLlZ9r9rSRao5plI9eX77hCJzvfi8DgfxF3nslsfka8A
         i6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nzm5xS7Ci3zh0ph+vnRyetdA6dBSqUpnuk3sW/kk95I=;
        b=AtN9FSnM4YTAFyzD+ipCspa2xjYC2Qz3pfQZ6NIbzvKK+sKSQltAYbFN76tCc90v7N
         fYd4jFCUNElbEBtnrUooMY2SQBG4yg/BJgyswTybik8RpGhtP/vuZroPX0JUr4igvIMk
         tTVFOD2AmgUJZ056DgWC1OlOd6f5lcaOBu8cG4PuOazpbndmGnp/AjgotZpDa9YXeT6E
         Jc6NYXB9apzFeQeaLYlWFJTuVhIVmZX2KgoJhtbyaVMXIQpvR3zcw3v4aVWUUNCXw0Cq
         FPRcHsRPrpCimDMZTpYIdG+R4DLsru4J+KFufkl9Mn/Y4a0dm7PuAkd5WJbszBkg8Bk5
         P02A==
X-Gm-Message-State: AOAM530ewCUtafaEbrXppGYG5P+CaVPimk0OHbDREWqwt0D+T11Kj5H2
        VZ5uqhse3thCj47GHWTdYn9+Qx63sVxrWPUUXQ2Jnw==
X-Google-Smtp-Source: ABdhPJzGjBi0BbllMUcN7jFM4B/E5Bhs48bxL8FD/eY58JDy0iCHINLDlmREt6KDjCS4Pzo65D+kfVojC5IUHJ2u4OY=
X-Received: by 2002:a92:de07:: with SMTP id x7mr749052ilm.285.1603126938691;
 Mon, 19 Oct 2020 10:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com> <20201014182700.2888246-5-bgardon@google.com>
 <8ee0477f-553a-d22d-a7e9-f2e9186ff27e@redhat.com>
In-Reply-To: <8ee0477f-553a-d22d-a7e9-f2e9186ff27e@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Oct 2020 10:02:07 -0700
Message-ID: <CANgfPd-isMQQ9m94qTz+tPmBMekbLVWrzMig95XbXL4uJ9yoLg@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] kvm: x86/mmu: Allocate and free TDP MMU roots
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

On Fri, Oct 16, 2020 at 7:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/10/20 20:26, Ben Gardon wrote:
> > +
> > +static void put_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     if (kvm_mmu_put_root(root))
> > +             kvm_tdp_mmu_free_root(kvm, root);
> > +}
>
> Unused...

Woops, I should have added an unused tag or added this in commit 7.
It's used by many other functions, but nothing in this patch anymore.

>
> > +static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> > +{
> > +     lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +     kvm_mmu_get_root(root);
> > +}
> > +
>
> ... and duplicate with kvm_mmu_get_root itself since we can move the
> assertion there.
>
> Paolo
>
