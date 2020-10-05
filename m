Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBAB2842A9
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 00:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgJEWsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgJEWsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 18:48:21 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DCBC0613A7
        for <kvm@vger.kernel.org>; Mon,  5 Oct 2020 15:48:21 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l16so9315581ilt.13
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sX6Hxo8zbSqrVxxKpSXQc3U5v59mG8RdH/i1tZ3jiPA=;
        b=YD+hAZWEqY/HCKuyHzyLhCb1kabb4sMChClpf33g3/NWLr6tQcnHqkUV7THOpeihTK
         U6MdF0vXiO+KnuyYOpzEBUg/cVnzjWz+ZH1+5H8TZLYWc1wBGbDQbYifbVS62UtlrFM8
         oz0hCRA+bh74SKhLdyCLc2KBHPaQCRJxpxVJrlBibmWUuGFYf1C3sHhPJcHlCdMuH0lw
         yygrWmiBU0BONM2QMa6BesEBrh5xcnJHGNMao8YrH4TLzuNwOQssF3EuYiaLApGnREp/
         o1/eK5eFd/MAHeKKSzDygLg7/taxtAP4/gGhbYLwCRwQq/ULEFVdUU46PZi9SbVHnbCT
         1qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sX6Hxo8zbSqrVxxKpSXQc3U5v59mG8RdH/i1tZ3jiPA=;
        b=la5OxiqKt92b1RNAXiUiXBhyUxSRD4iM6+HHNfUVU2xWUkfFCl6P4q8HdTE96yoo+Y
         sig35kFZ7vPYfBCHeYHIOiIo31PCB/XwJuKm3ndM2b0aVgppSw2s8oibiEa7ip7tAsou
         YkBmnb0s0TQFRzW+T8Bj+3siSLvmSTh5csfR0ejXfNcmHjUdd++ChtSiTKcGHQ5EzJN3
         +Es4Lm80JFyku8DL5C1fUiYrvbNFIJdm266HwGXPfxwLl7dSH6JvKlhORWWSQq8Mj92E
         H1d6fSiDr0v0iIHZUPVwDsKQemytHCRH7eKyLFxczTCDGreOO2IhNDgADVTWNbgIFd9g
         tcxA==
X-Gm-Message-State: AOAM5333qVDVFJf5VcirCvxxQUBGBRN57Yg9THB7xbqC2QTtYgCxi9oX
        yS48H4/eTO3sgvEH792Y25p+eLAMykB+cp2bpSchmg==
X-Google-Smtp-Source: ABdhPJxXis+pI9mZPtgyd3zD7qrLvqeoS8zVEmRPGxXpMrtc3lqFsBVEqo+8sV9/F3wyVpww9gNM2W/DkU0/bOZIjaw=
X-Received: by 2002:a92:1e07:: with SMTP id e7mr1212827ile.154.1601938100745;
 Mon, 05 Oct 2020 15:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-23-bgardon@google.com>
 <a95cacdb-bc65-e11e-2114-b5c045b0eac5@redhat.com>
In-Reply-To: <a95cacdb-bc65-e11e-2114-b5c045b0eac5@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 5 Oct 2020 15:48:09 -0700
Message-ID: <CANgfPd83xGh_82OZEjHQO-+vX0kuCFQPwOTwSGYErd9whyjycw@mail.gmail.com>
Subject: Re: [PATCH 22/22] kvm: mmu: Don't clear write flooding count for
 direct roots
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

On Fri, Sep 25, 2020 at 6:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 23:23, Ben Gardon wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 42dde27decd75..c07831b0c73e1 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -124,6 +124,18 @@ static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
> >       return NULL;
> >  }
> >
> > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > +                                 union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     root = find_tdp_mmu_root_with_role(kvm, role);
> > +     if (root)
> > +             return __pa(root->spt);
> > +
> > +     return INVALID_PAGE;
> > +}
> > +
> >  static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> >                                                  int level)
> >  {
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index cc0b7241975aa..2395ffa71bb05 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -9,6 +9,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> >
> >  bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> > +hpa_t kvm_tdp_mmu_root_hpa_for_role(struct kvm *kvm,
> > +                                 union kvm_mmu_page_role role);
> >  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> >  void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> >
>
> Probably missing a piece since this code is not used and neither is the
> new argument to is_root_usable.
>
> I'm a bit confused by is_root_usable since there should be only one PGD
> for the TDP MMU (the one for the root_mmu).

*facepalm* sorry about that. This commit used to be titled "Implement
fast CR3 switching for the TDP MMU" but several refactors later most
of it was not useful. The only change that should be part of this
patch is the one to avoid clearing the write flooding counts. I must
have failed to revert the other changes.

>
> Paolo
>
