Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C036974F
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243237AbhDWQoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 12:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhDWQoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 12:44:03 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B918AC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 09:43:25 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id n184so23734376oia.12
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 09:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5sbEm56V+MlayEe0ssGqqMKi2qTZckGwhWF3sRB4kjs=;
        b=hZcflOZhW1kTHKPh/MOTuBJpsU+lzxyBdHrBR6J69BDNsp7BxOsqxDbsfesz0YAz6x
         EMlxdNPV33pbVYjiDRWBFIR5ST4sYmViw9N4Wa6JaHQfFQNNAahzqMiBHkFjEhyJl8ny
         klVqro/0Ght3Ya3T7MUFi+h+oRMDrKn5rv4kqhsZEGKYtl6qHM0SU/Ajmbwqlo/pVckZ
         bUpIdDqCmZvYkahmTTw8h3cKFyJSA1/JM7RYV903Wj4tp+TZvVJEecuNMg5MB4laxi97
         6g2y3TE78nwoV7xnvx5QnAjhRkMXuYBnYg+CuG2RN2O6U3yPMOw6gJ3ZELzS4DTW8rys
         uhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5sbEm56V+MlayEe0ssGqqMKi2qTZckGwhWF3sRB4kjs=;
        b=s8L4zdxoZThpyOXcGH1RnjUHFj8rrpWv0QkYPd2McjLhU/dcdQTk41+jIw0eOmAN2c
         3baXi1H5FnhLff2CbKZLrx3ZqEc9qTehfyL2Gl0dDD6o0J0+eEHoDqPMnuPVJACqsN/4
         JcAl7Z+jx+GmRJNYU+weXXiJyp4UgzHDOp/u9cIE2QY/MERSp8c1a9IHDcQ06YRxGtCl
         rbFvjONrb9H3vKAeig6mOaF+OPEpAHMAzffccHXWFtN91nkI1wPR2bIL//5EJAo/QW9J
         cr/3TnoYhWVrKuzwk/wG3lDM7M+OVtmr+5gQGREeJpeDPPxDuRnP7S0gxNYAnG3+dtH2
         GVAA==
X-Gm-Message-State: AOAM531yK8gSEJjY/N08NegB0IgsJKdNYttw9MYJ3QWk1C78iDDLTHHO
        WBsU9rJ1i3ehOKC0lKAB/whABf1Z1oGzaAkxED/SB1AOlazfoQ==
X-Google-Smtp-Source: ABdhPJysgQcn9yibhvGOjAcVRUlc/4a/H2l4TrLWx4JMZR87q5pqF6PqKzp9BWAfoCT4lIGZ7LlR1vqjpRz6pJMPRFo=
X-Received: by 2002:aca:408b:: with SMTP id n133mr4666392oia.13.1619196204981;
 Fri, 23 Apr 2021 09:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <CALMp9eSu9k57KvGCO6aDEFgkV-Vxrnr1j7CbiLYbtKYG1uwMZQ@mail.gmail.com> <CAAAPnDH_EL3S5WqgLNWQOLruKeStemYtq9vAKVSfV6po3LNGxA@mail.gmail.com>
In-Reply-To: <CAAAPnDH_EL3S5WqgLNWQOLruKeStemYtq9vAKVSfV6po3LNGxA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Apr 2021 09:43:14 -0700
Message-ID: <CALMp9eRyFOUHhg406qMfEy7g=szaOPTAsVgkoNfmO0GBeJAAqA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 9:14 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Thu, Apr 22, 2021 at 5:57 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Wed, Apr 21, 2021 at 5:28 AM Aaron Lewis <aaronlewis@google.com> wrote:
> > >
> > > Add a fallback mechanism to the in-kernel instruction emulator that
> > > allows userspace the opportunity to process an instruction the emulator
> > > was unable to.  When the in-kernel instruction emulator fails to process
> > > an instruction it will either inject a #UD into the guest or exit to
> > > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> > > not know how to proceed in an appropriate manner.  This feature lets
> > > userspace get involved to see if it can figure out a better path
> > > forward.
> > >
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >
> > The instruction bytes are a good start, but in many cases, they aren't
> > sufficient context to decode the next instruction. Should we eagerly
> > provide that information in this exit, or should we just let userspace
> > gather it via subsequent ioctls if necessary?
>
> Why is there a concern for the next instruction?  This patch is about
> userspace helping with the current instruction being emulated.  I'm
> not sure why we would be concerned about the next one.

Sorry; I should have said, "The instruction bytes are a good start,
but in many cases, they aren't sufficient context to decode *the*
instruction." For example, suppose the first byte is 0x48. Without
more context, we don't know if this is a DEC or a REX prefix.
