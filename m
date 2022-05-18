Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1065B52BF99
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbiERPer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiERPep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:34:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F7762A1
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 08:34:43 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nr2-20020a17090b240200b001df2b1bfc40so5960270pjb.5
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 08:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FR9qyGtEo59tSbFrJbMFBVFHC4OKA2OLIt+JMoIDPvM=;
        b=RtS3h7w6VWloSj64YgK8YxUYZKqX5IVbhO1MmjCN7A70qZVqpfOQ5786Qw2V3fGfbs
         OWncq6hdYddmMJ/3fDGm+d9VcRRwoGPORUnyl8GonyRs79stfm/aB9WYjYBBNT7WtF5g
         ohiFV9BU32FC/iyhTxUM5ImlaBnS14jdf1RkmAF7J8R3o0iXbFMsKT7Tq6Pg+JwVSrhA
         Y5WdbKNUMGd+640+L/r//U7KhZ4ktkMrfIf/Hry9lgq8OTicFUuwW7b98pXWzyHvLj7M
         eWhHL1TE14JiYXauOLvzcQQRBacVOYh8D1HEz8Y+8q67pkSCYm9ea3svHKzyMDpsV8XH
         +eDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FR9qyGtEo59tSbFrJbMFBVFHC4OKA2OLIt+JMoIDPvM=;
        b=Zga+OpJt5ceMEfIz47DOyGHRmGD+mOdTDeZePVC8aIxemwZEE2FMb2UFjkXWpRQWwP
         JywJ8UcsgEGtQTvhDcrhdZe/wyMhJaV772069RrR/dIERapk0KSsnoty4ILZ9hDnv0aY
         nK3OxzUVGJ794oCoFrKpEMgNAQSfFvjEiEhDgcpcFXLFFdLV2AWdCQGNWO3gsuqwdLPb
         b82PIOa6/XOPks2olorjaTsKQvV+tib3wNCPTyjFiwScFy3GVY0Vpj0fmh0Ds4cDarC8
         o+c5yZqQKajTpf9zm5GnkcNn2VBqmkqiQjn9MgPG2fmMDuwjmW4AvHgQa7tn8aEEN6BO
         tDyg==
X-Gm-Message-State: AOAM532osNhdNFYT2nKrXHcIDrj34nr5kctZKCKQk7/BKpD9STRKVrAg
        kqXTD6QLZ+oEKLj1wq8/hqyoVw==
X-Google-Smtp-Source: ABdhPJzyykcy3MUxSxpp0AlR8glBuhiHrygpxmJfu0hexllbVvSOfHMABHxBTUyB4oFrQ3Vi0ZV1RA==
X-Received: by 2002:a17:90a:a82:b0:1da:3763:5cf5 with SMTP id 2-20020a17090a0a8200b001da37635cf5mr81975pjw.55.1652888083156;
        Wed, 18 May 2022 08:34:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090b068500b001df99ceff43sm2888402pjz.36.2022.05.18.08.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:34:42 -0700 (PDT)
Date:   Wed, 18 May 2022 15:34:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     Wei Zhang <zhanwei@google.com>, Sangwhan Moon <sxm@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
Message-ID: <YoUSDmKrE6ryO4XB@google.com>
References: <20220412195846.3692374-1-zhanwei@google.com>
 <YnmqgFkhqWklrQIw@google.com>
 <CAN86XOYNpzEUN0aL9g=_GQFz5zdXX9Pvcs_TDmBVyJZDTfXREg@mail.gmail.com>
 <YnwRld0aH8489+XQ@google.com>
 <CAN86XOZdW7aZXhSU2=gP5TrRQc8wLmtTQui0J2kwhchp2pnbeQ@mail.gmail.com>
 <CABCjUKCCc2irAnJrGWfKAnXJj-pb=YNL4F0uAEr-c0LMX22_hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCjUKCCc2irAnJrGWfKAnXJj-pb=YNL4F0uAEr-c0LMX22_hw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022, Suleiman Souhlal wrote:
> On Tue, May 17, 2022 at 4:30 AM Wei Zhang <zhanwei@google.com> wrote:
> >
> > > Please don't top-post.  From https://people.kernel.org/tglx/notes-about-netiquette:
> >
> > Ah, I didn't know this should be avoided. Thanks for the info!
> >
> > > My preference would be to find a more complete, KVM-specific solution.  The
> > > profiling stuff seems like it's a dead end, i.e. will always be flawed in some
> > > way.  If this cleanup didn't require a new hypercall then I wouldn't care, but
> > > I don't love having to extend KVM's guest/host ABI for something that ideally
> > > will become obsolete sooner than later.
> >
> > I also feel that adding a new hypercall is too much here. A
> > KVM-specific solution is definitely better, and the eBPF based
> > approach you mentioned sounds like the ultimate solution (at least for
> > inspecting exit reasons).
> >
> > +Suleiman What do you think? The on-going work Sean described sounds
> > promising, perhaps we should put this patch aside for the time being.
> 
> I'm ok with that.
> That said, the advantage of the current solution is that it already
> exists and is very easy to use, by anyone, without having to write any
> code. The proposed solution doesn't sound like it will be as easy.

My goal/hope is to make the eBPF approach just as easy by providing/building a
library of KVM eBPF programs in tools/ so that doing common things like profiling
VM-Exits doesn't require reinventing the wheel.  And those programs could be used
(and thus implicitly tested) by KVM selftests to verify the kernel functionality.
