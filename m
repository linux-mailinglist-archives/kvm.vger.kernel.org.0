Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A480C3DA956
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhG2QtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhG2QtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 12:49:03 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80861C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:48:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y34so12200324lfa.8
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DXZNKuVHbOtsiclPBWnL4uJr8QcRCA2WFLB0EDrIQss=;
        b=MLzJm6zGo5s1C/yn5QoO8wdaLFYGAObntZbeF/pK53U5+/cpCYl3DeJy3QdkAdZfFB
         E9qE8e2p+WNuj/RE/UB3O2ywhfpfe655Q2VHgR4hyvt8lFGIkVaAXP2S2fxLJFFhVq7C
         ujWROOX5VLnf+ENc3YnRGqguAibtEUiYkvlvF/t6Iiug+f4ZrdgxsE3Tr7BWWS7Fw6Gr
         vESLZGzELlK4RyKo4sQWK6/i9JvjrVeL2RB6xWzw0+GInnoKTPkD3XNbPAY5IH1gXGU4
         ElMOMmO28CgO+QPlE+Jvd1eZPP26gt9ey4VECPBrJdmwn8q0NNz6w1si+rYVx8BN1Rrv
         LqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DXZNKuVHbOtsiclPBWnL4uJr8QcRCA2WFLB0EDrIQss=;
        b=qj0rg2Q9B3AlSxfJknrVBU6SLhVHuuHimyUZwbKQCD2MWI3ouWFLq2A8okIurQxy9c
         iqTMC/cLt2FcRSbFDs6+PhfeIGDo9ZxoFMiNRkAmXei/KK2pP8SaY9PX2+XrACCJYihq
         8Vkypa7zFB1HIGgluJR4Ug4QyMq6HOo9gVY7zei0s2ZEx5jdjnIWIhUo+2OmQq95EGAx
         U56Js4nbD/8zIVQ+/m5xUBvNMjSFoE9t3x1gejNi53PMs0aandGcT/81bndWX5PewyqI
         P04H0ev8aRJdqtvYrMVf2fmOH4Y4Dr1XEbA3WZwOl5ztyBcF4JOeKvsxHlIaUjHvOZyf
         fjKQ==
X-Gm-Message-State: AOAM533DI5OC/HbxTDJASFKLfXv2buM51+TpROk/kDcxhvAO2AhpJ92Q
        9oB7fHAgY7DVM8hU/t2lzZ0fJinYyjngmbAzPmB13Q==
X-Google-Smtp-Source: ABdhPJzMfkh9cJkFo6xDxinSOXxoNApXRYND8U/413ZAsVGsOrS9yQ1pwDv9M+a5f8evDRO9T7AcAg+J4jXYSGJMGPc=
X-Received: by 2002:a05:6512:128e:: with SMTP id u14mr4336224lfs.483.1627577337579;
 Thu, 29 Jul 2021 09:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618914692.git.isaku.yamahata@intel.com>
 <YK65V++S2Kt1OLTu@google.com> <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
 <20210610220056.GA642297@private.email.ne.jp>
In-Reply-To: <20210610220056.GA642297@private.email.ne.jp>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 29 Jul 2021 09:48:31 -0700
Message-ID: <CALzav=d2m+HffSLu5e3gz0cYk=MZ2uc1a3K+vP8VRVvLRiwd9g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 3:05 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>
> Thanks for feedback. Let me respin it.

Hi Isaku,

I'm working on a series to plumb the memslot backing the faulting gfn
through the page fault handling stack to avoid redundant lookups. This
would be much cleaner to implement on top of your struct
kvm_page_fault series than the existing code.

Are you still planning to send another version of this series? Or if
you have decided to drop it or go in a different direction?

>
> On Thu, Jun 10, 2021 at 02:45:55PM +0200,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> > On 26/05/21 23:10, Sean Christopherson wrote:
> > >    - Have kvm_mmu_do_page_fault() handle initialization of the struct.  That
> > >      will allow making most of the fields const, and will avoid the rather painful
> > >      kvm_page_fault_init().
> > >
> > >    - Pass @vcpu separately.  Yes, it's associated with the fault, but literally
> > >      the first line in every consumer is "struct kvm_vcpu *vcpu = kpf->vcpu;".
> > >
> > >    - Use "fault" instead of "kpf", mostly because it reads better for people that
> > >      aren't intimately familiar with the code, but also to avoid having to refactor
> > >      a huge amount of code if we decide to rename kvm_page_fault, e.g. if we decide
> > >      to use that name to return fault information to userspace.
> > >
> > >    - Snapshot anything that is computed in multiple places, even if it is
> > >      derivative of existing info.  E.g. it probably makes sense to grab
> >
> > I agree with all of these (especially it was a bit weird not to see vcpu in
> > the prototypes).  Thanks Sean for the review!
> >
> > Paolo
> >
>
> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
