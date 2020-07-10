Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04EB21BF8A
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 00:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgGJWJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 18:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgGJWJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 18:09:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC2C08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 15:09:53 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so7598448iof.6
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1O42Lqss7xnjXBAvxD/sdQosxZlNNbMUE2yCnCx8yY=;
        b=dUaMtKd0ZVLitpFZT1Hi1Atco7PYQaRIdzJlGn6zTEg6DwU8czFm6amzi5l9zutK1M
         fJngrgHapij/FiQJDqpHdPzH7dEKObXMRLHhgBxG03ixKI4P8a6GA+A5vnjn+Mw6Ab2M
         /5MttSBBR9d+3xXQOFhJd5DifwjC3C+KIYaOVqkOXmSNOVd7JrrU44+qeWHa9XTSnR3L
         riVzyoHL2vuW/YRgNpovTQ78qXs8SvqOct1hbx6sa0OTgJqF6csuFn1OE200TBlXUoKo
         pbiJeoZ6VhDm+6VYAq5nnFJAjhy8Jp7RX99yUBWv9fd0fRvEv8jrEhhJ0Fse+4gMA9aD
         wkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1O42Lqss7xnjXBAvxD/sdQosxZlNNbMUE2yCnCx8yY=;
        b=Px5a5ZbiO7awCKr87b8s0xJbG8/S6lrNx4VAuwYtVa/yOyQ7OQA8NJk6api1MBuDhD
         IekgIHhMPSKDZcEStg9E6suQRtsSKPkKYqF6j3BuSXmHqqv4ydSJSIPox4aF3IEMimb0
         w7l0NRjatTmQNfpYe6GjHshTm2dmlfXhSAYLEmXFfuLNNE1AE+jVi+wxbt3sRj31gp63
         h0NJ4zvI3PMD2Ulhe7M5A7cda7EI0VX4TdjbILDftZ6pr+OF1WOQv+AuAsxytcyXqIy4
         BQr5HWAdf8mIavUJ8CGEjMLpyrTJ/e7Yln7IAhIaH7tYcJjdSm5ECEcQ8UEzd3FTkDmT
         CtvA==
X-Gm-Message-State: AOAM532jr7osNOp1CqlgAhLkoZiz7i9X/+As0NBWYlCOiQopyDpg8NgB
        fE8OGDTE30bwh1mbMw41uBnhwwrm1ftGkFgAygpq4A==
X-Google-Smtp-Source: ABdhPJxtoYC12/4Edm4BsybDojSFldjjVm4/aar/zHdDBIEJn/8nr9tHrM/wHVj6A+yhVptiBeoEwHV5bYAQx4PVMrc=
X-Received: by 2002:a05:6602:2e0e:: with SMTP id o14mr49046262iow.164.1594418992072;
 Fri, 10 Jul 2020 15:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200710200743.3992127-1-oupton@google.com> <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
In-Reply-To: <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Jul 2020 15:09:40 -0700
Message-ID: <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 1:38 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/07/20 22:07, Oliver Upton wrote:
> > From: Peter Hornyack <peterhornyack@google.com>
> >
> > The KVM_SET_MSR vcpu ioctl has some temporal and value-based heuristics
> > for determining when userspace is attempting to synchronize TSCs.
> > Instead of guessing at userspace's intentions in the kernel, directly
> > expose control of the TSC offset field to userspace such that userspace
> > may deliberately synchronize the guest TSCs.
> >
> > Note that TSC offset support is mandatory for KVM on both SVM and VMX.
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Peter Hornyack <peterhornyack@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c             | 28 ++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h       |  5 +++++
> >  3 files changed, 60 insertions(+)
>
> Needless to say, a patch that comes with tests starts on the fast lane.
>  But I have a fundamental question that isn't answered by either the
> test or the documentation: how should KVM_SET_TSC_OFFSET be used _in
> practice_ by a VMM?

One could either omit IA32_TIME_STAMP_COUNTER from KVM_SET_MSRS, or
one could call KVM_SET_TSC_OFFSET after KVM_SET_MSRS. We do the
former.

This isn't the only undocumented dependency among the various
KVM_SET_* calls, but I agree that it would be helpful to document it.
