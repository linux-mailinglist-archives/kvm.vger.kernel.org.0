Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C673C5EA4
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 16:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhGLO7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 10:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhGLO7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 10:59:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A657C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 07:56:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o201so11567305pfd.1
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 07:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=da9YFZ8w4iQ7cuBpy6e9jMfk2ppUfoMBxT36y+4Eyto=;
        b=PKeqwZbrE/w8FnjCInlH/sNZoVF97TNvSrvd4nbBaK8I+tYOkM1WjD0lr/uHcSFPJ2
         p4tgC9BrH0cFBtwQuoSEmwKg3epdyJIq2jumXzZhwChtqefkgPrhmzSgiCKhbX4IzWWz
         OAEo+LgCkvSbPFMCeSpMKkCzvddK6R/Y4A6HdOsWEWUUy3AIE2MbVhkzeMYjrWx5PM82
         0bcarO6FapHPhS4sQChMX1hLUtu1iPeSajmhkr3uHputOS08+Dnt85MUSKXpPKQvSIBU
         izLq6u/33iUX/UDYY+BM2u7IS/vbzJ3K8+fz/JUmYk/FhPNPSV5/jStRG5SR41UJyFnB
         MJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=da9YFZ8w4iQ7cuBpy6e9jMfk2ppUfoMBxT36y+4Eyto=;
        b=IOhcmHBJcwaC4ii92wa842rQTlpQ271sr/cJ8Ik5c1PMR3MtLNFc95UHSHglmY8Rla
         C2S2I0lmD3ATLjEcueuR2UHKTyftEbhXPVUI4V4TDDLYak1EJ06t2ZZr/1DK+UMUJtE1
         X7/Q0y8mo1wQLRWvviiP7Xn2CMJc/zxrHU0fTDiNP2rwmbliFVCZSGUhxi6wTJ5tJ7Xt
         XST+mwZspVDdhKLdCvmSDTDwnxIhCtgdz9LDAAN4P4IdmbAalcb+vgVFI3B1v3t1qMwt
         heEi4ea5uEHk/di1UvPK/cZkz0GDe0sNWJiU2zSV3zuTfQONf/0JIkwgCc8I8QgZVf6G
         fsRA==
X-Gm-Message-State: AOAM530HLBl08ywHjeKrby3Z/haCYRGgU+0tLTKzKAU/sI9r90zHSNI1
        ppH1EsrgKdWrAphyufZ+y8B+9w==
X-Google-Smtp-Source: ABdhPJzjutMX49/wfvR1agCTShyAh3oavFQQjgaaPpBxtcRrEHwNk+KJvyUXehMTP7oJehqrXiBUig==
X-Received: by 2002:a63:655:: with SMTP id 82mr22247880pgg.133.1626101815721;
        Mon, 12 Jul 2021 07:56:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v69sm12937506pfc.118.2021.07.12.07.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:56:54 -0700 (PDT)
Date:   Mon, 12 Jul 2021 14:56:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     harry harry <hiharryharryharry@gmail.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
Message-ID: <YOxYM+8qCIyV+rTJ@google.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021, Maxim Levitsky wrote:
> On Mon, 2021-07-12 at 08:02 -0500, harry harry wrote:
> > Dear Maxim,
> > 
> > Thanks for your reply. I knew, in our current design/implementation,
> > EPT/NPT is enabled by a module param. I think it is possible to modify
> > the QEMU/KVM code to let it support EPT/NPT and show page table (SPT)
> > simultaneously (e.g., for an 80-core server, 40 cores use EPT/NPT and
> > the other 40 cores use SPT). What do you think? Thanks!
> > 
> > Best regards,
> > Harry
> > 
> > On Mon, Jul 12, 2021 at 4:49 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Sun, 2021-07-11 at 15:13 -0500, harry harry wrote:
> > > > Hi all,
> > > > 
> > > > I hope you are very well! May I know whether it is possible to enable
> > > > two-dimensional page translation (e.g., Intel EPT) mechanisms and
> > > > shadow page table mechanisms in Linux QEMU/KVM at the same time on a
> > > > physical server? For example, if the physical server has 80 cores, is
> > > > it possible to let 40 cores use Intel EPT mechanisms for page
> > > > translation and the other 40 cores use shadow page table mechanisms?
> > > > Thanks!
> > > 
> > > Nope sadly. EPT/NPT is enabled by a module param.
> > >
> For same VM, I don't think it is feasable.

Heh, because the MMUs are all per-vCPU, it actually wouldn't be that much effort
beyond supporting !TDP and TDP for different VMs...

> For multiple VMs make some use NPT/EPT and some don't,
> this should be possible to implement.

...but supporting !TDP and TDP in a single KVM instance isn't going to happen.
It's certainly possible, but comes with a very high complexity cost, and likely
even performance costs.

The more sane way to support !TDP and TDP on a single host would be to support
multiple instances of KVM, e.g. /dev/kvm0, /dev/kvm1, etc...  Being able to use
!TDP and TDP isn't strong justification for the work required, but supporting
multiple KVM instances would allow upgrading KVM without having to migrate VMs
off the host, which is very desirable.  If multiple KVM instances are supported,
running !TDP and TDP KVM instances should Just Work.
