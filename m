Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527C823DF0D
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHFRgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730566AbgHFRg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:36:29 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995BAC061575
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 10:36:29 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id x24so12681531otp.3
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 10:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWs6Ffw3WpIeedVEGxgmLg1+uarFaPgN9gTHSd3ibmg=;
        b=h7MloIJOtgd8oNMv9KiDhQ69SKAd0MGHCzbPV18/Axq05hG/Lf4Yd/8WmCguybwVfi
         w8eh5OFkmAX/tvplpoaVXn0OvcNNxw7LSnRNnxTdygO42DapwzcYU3bZbGEFdC3I+dHx
         TVE/M/hePiLA9rUDysYU8NV20KFE4WIEDoDTcvTKeVTGbeiGTDR41qT4yPCW4/q9P+ck
         NPaGnP70XjfFAWXhUjBGWQpOuR/+4FxscdbYWYMwd9Vd41KBJYDjapTuGIV5pJYHxyyB
         iCblLMlfT3wipepuRTpqpNBWg7y/0JuovsT4+iR4DqK4NslMxW24i9PNdEWkjES+E9mf
         qrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWs6Ffw3WpIeedVEGxgmLg1+uarFaPgN9gTHSd3ibmg=;
        b=cNUR9PO3zfmea51BIADns87rz+e7OgkHjhUXpx0ems3hECr2mr8cqs+u8fJ503wqJ7
         HOxRZNk4lLntRUPA13YXVA3yGnlqw2HTc913ae03f8e0Z6NYo9S+FyLMVBioIC/R6ln9
         uVNHAQsuInIUsj2JIFh8D9GrCdD2PshHr5yXvjQkwSOt+5jrZnb3kD/QpSfZtBuWDAYw
         dB/5fNO2e6pRiyTY9re/yg1AIsngZaNkEO8uUphKba2v7CIFubLEF7qynHc53vLx2QxZ
         c6HsKN7mfi26DeGt6ye6KVwBFYfCxZvf/DrVGgKQbG27Frdoz18YlyqIPtGnIAR6N88m
         QMlg==
X-Gm-Message-State: AOAM531EIyYKns6saOKyhDR8kgHHrfIv88IeJkoXdg70ilpEI9+6kLub
        Ln0s4wB4KGU/n6BHEatO90sm9odjaFfeIYVJ+2ZOLQ==
X-Google-Smtp-Source: ABdhPJw5W+NsuSxoqJYZWbtd8UCN7aRv3GVPEARZjYQheJcs+k9kdmtCeRNsSS+ueHAwpQKOvpXtfbmCdpiamXMXNZw=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr8043964ota.56.1596735388579;
 Thu, 06 Aug 2020 10:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200728143741.2718593-1-vkuznets@redhat.com> <20200728143741.2718593-3-vkuznets@redhat.com>
 <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com> <20200805201702-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200805201702-mutt-send-email-mst@kernel.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 Aug 2020 10:36:16 -0700
Message-ID: <CALMp9eRonv7Ds2fw_fByqpQcyQBuq3fEXNnzi6ZmEHd2nHYO+w@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 5, 2020 at 5:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Aug 05, 2020 at 10:05:40AM -0700, Jim Mattson wrote:
> > On Tue, Jul 28, 2020 at 7:38 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > >
> > > PCIe config space can (depending on the configuration) be quite big but
> > > usually is sparsely populated. Guest may scan it by accessing individual
> > > device's page which, when device is missing, is supposed to have 'pci
> > > hole' semantics: reads return '0xff' and writes get discarded. Compared
> > > to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
> > > real memory and stuff it with '0xff'.
> >
> > Note that the bus error semantics described should apply to *any*
> > unbacked guest physical addresses, not just addresses in the PCI hole.
> > (Typically, this also applies to the standard local APIC page
> > (0xfee00xxx) when the local APIC is either disabled or in x2APIC mode,
> > which is an area that kvm has had trouble with in the past.)
>
> Well ATM from KVM's POV unbacked -> exit to userspace, right?
> Not sure what you are suggesting here ...

Sometimes, maybe. That's not the way the emulation of most VMX
instructions works, should they access unbacked memory. Perhaps that's
just a whole slew of bugs to be fixed. :-)
