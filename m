Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F2955F8D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 05:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFZDf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 23:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfFZDf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 23:35:28 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD8A2168B
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520127;
        bh=bwu3JRlFer6tfX9zJIfIQ3eGTj7LyoViGNSc3TpVHm8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WE58dK3c6MNpnTrS4KSJWik2GvESmqMTeagxMaC8n8fZVsXqOhTRbSE+b6G+zmuAl
         PDMkTukU98Ue+cYhuXEnR4lgQHD5JaeNV7j9TsgLPQK1OmJw81wwx1hDPP293Ci8z6
         nS9R+PbHInk//CeqpJJYUqDPB4kFAPh1XswQ71T4=
Received: by mail-wm1-f54.google.com with SMTP id s15so503297wmj.3
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 20:35:27 -0700 (PDT)
X-Gm-Message-State: APjAAAUWo1mnNFvz6/pQ9jnrskd8uYXfo9sXIaAI4h4s/lrUEdBXpskP
        4uZ5dM8mwbGmEFpNzYTkVm8kHOq7aCppNkK5TpdbfQ==
X-Google-Smtp-Source: APXvYqyZfAzCoJd4al+vWzkiAXWWs0slSD3ODOvqgBz63WxXJbiB546K22w0eDleP0Lby5Z7+6R6o3RBB/Hb4ZSAXVI=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr755114wmj.79.1561520125983;
 Tue, 25 Jun 2019 20:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190613064813.8102-1-namit@vmware.com> <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com> <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
In-Reply-To: <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 25 Jun 2019 20:35:12 -0700
X-Gmail-Original-Message-ID: <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
Message-ID: <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
To:     Nadav Amit <namit@vmware.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 7:39 PM Nadav Amit <namit@vmware.com> wrote:
>
> > On Jun 25, 2019, at 2:40 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 6/12/19 11:48 PM, Nadav Amit wrote:
> >> Support the new interface of flush_tlb_multi, which also flushes the
> >> local CPU's TLB, instead of flush_tlb_others that does not. This
> >> interface is more performant since it parallelize remote and local TLB
> >> flushes.
> >>
> >> The actual implementation of flush_tlb_multi() is almost identical to
> >> that of flush_tlb_others().
> >
> > This confused me a bit.  I thought we didn't support paravirtualized
> > flush_tlb_multi() from reading earlier in the series.
> >
> > But, it seems like that might be Xen-only and doesn't apply to KVM and
> > paravirtualized KVM has no problem supporting flush_tlb_multi().  Is
> > that right?  It might be good to include some of that background in the
> > changelog to set the context.
>
> I=E2=80=99ll try to improve the change-logs a bit. There is no inherent r=
eason for
> PV TLB-flushers not to implement their own flush_tlb_multi(). It is left
> for future work, and here are some reasons:
>
> 1. Hyper-V/Xen TLB-flushing code is not very simple
> 2. I don=E2=80=99t have a proper setup
> 3. I am lazy
>

In the long run, I think that we're going to want a way for one CPU to
do a remote flush and then, with appropriate locking, update the
tlb_gen fields for the remote CPU.  Getting this right may be a bit
nontrivial.
