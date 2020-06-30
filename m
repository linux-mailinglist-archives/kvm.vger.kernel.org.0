Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064D20EA1C
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgF3AQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 20:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgF3AQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 20:16:53 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88652C061755;
        Mon, 29 Jun 2020 17:16:53 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id d4so17078257otk.2;
        Mon, 29 Jun 2020 17:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LoJkbpQEJ/7kCO6soZpUK1Fa5w/uxhfe+XsMfi/wXsQ=;
        b=jfVVGor58svmAJpb85NgXWFPb5MaixA2/7PkoZdjOj6f5B2n7gGjn6DIaEbqH9ZJfI
         EcUnwGt44Gx4SV8jfKsvI/6doC62Jsy3wTjtBDQr6DT+bLo8uNl3fVIwUi4yfTBYuLps
         ezPQJl3O3l3hFBLmrzUArQRN2ERqk/j5L5U2FHQi47J4WzwlFuQd83ljeJtNoJ1j92BB
         lPs1nBDbqtkWsAIeasT6opLz/859jdQlPTjNVn31VpFEt7NxqEDl7ZV1A0RdfL/j6577
         incT8JWZeTJXDKnin3D7ZDTjwj4Pcwm06p3jNIwibXz3XeV/HcLfIbqKU5Ak01YxUfyQ
         SHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoJkbpQEJ/7kCO6soZpUK1Fa5w/uxhfe+XsMfi/wXsQ=;
        b=pkjaBvGw0V94PeWVj3B8Lulm5Wk9P3Zs7AMM0AfQ0cWIOc4PMI3JszIaa6YX/momKm
         9L8ZNL3MZqrL/R64LssZeuJXLaRbq9gyZei7dIPsgv3nz6g8UVcyr6E2PYqf+lyAdPbk
         tKhNZ+94DNE/MY9AUkl7gTzuVcB/dKWKaa23KTMjeUrRmkCx41zHsnIr4j2ysh6E6stV
         U82rneXp5ucUVGepxwieAUyM4MBrTD7mgs6ZffrKs0ODRvJZRJEGAUm2WSf3FGST58s5
         PDC+a09m6T/bsBF64IBQ77AnR3SPFNvRmoGc9z7LdaAJoxlfW6J+1/sriQ6gxDDM6Jmq
         3Ehg==
X-Gm-Message-State: AOAM530BpC0UhCoF1QO3nOUYT21phrhciUt/ooRG6yJqRzPyjMOWSpsr
        zO+0bzGzSak3TURJwWKUTogsiuBvQabalUTb5x4=
X-Google-Smtp-Source: ABdhPJzut6Wv9skBg3QezX/53wVPagQKY5Ns5iTn5U3lYHn/XtINnqa4uHw4jLNddFgFwnA3qm9MPJ8lSU/lHeCJHjg=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr6081413oth.56.1593476212981;
 Mon, 29 Jun 2020 17:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
 <877dvqc7cs.fsf@vitty.brq.redhat.com> <f9b06428-51c3-09af-48cc-d378182916fd@redhat.com>
 <20200629154212.GC12312@linux.intel.com>
In-Reply-To: <20200629154212.GC12312@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 30 Jun 2020 08:16:41 +0800
Message-ID: <CANRm+Cx7-kEDKTSmoocgwRa+q30LdVhbaLth_dLss6wshAnOHg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Jun 2020 at 23:42, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Jun 29, 2020 at 03:59:25PM +0200, Paolo Bonzini wrote:
> > On 29/06/20 15:46, Vitaly Kuznetsov wrote:
> > >> +  if (!lapic_in_kernel(vcpu))
> > >> +          return 1;
> > >> +
> > > I'm not sure how much we care about !lapic_in_kernel() case but this
> > > change should be accompanied with userspace changes to not expose
> > > KVM_FEATURE_ASYNC_PF_INT or how would the guest know that writing a
> > > legitimate value will result in #GP?
> >
> > Almost any pv feature is broken with QEMU if kernel_irqchip=off.  I
> > wouldn't bother and I am seriously thinking of dropping all support for
> > that, including:
>
> Heh, based on my limited testing, that could be "Almost everything is
> broken with Qemu if kernel_irqchip=off".

It is broken for several years. :)
