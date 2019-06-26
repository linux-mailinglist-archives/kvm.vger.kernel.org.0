Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4801857083
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfFZSWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZSWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:22:09 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4B6217F9
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561573328;
        bh=RCUZ20s+FO/ACLr0Oia7zO1LHuxkGngcQaAh4XmHjFw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DWcrF2jASB5Nyc7Lay2ty4eigHh4hjHhsAgxAEAt38NGI3MQAtToTRiyul2ItRjlz
         yANgdkyXusdbSXn2GZFy6vSFJeJO8l26MDk9Gru27/ICyAhi44mIwUdMGx0yMR+RbD
         s5bXkxxmOjSjFyuORb180Urq3qgMEngzxN7sd6GY=
Received: by mail-wr1-f49.google.com with SMTP id k11so3884169wrl.1
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 11:22:08 -0700 (PDT)
X-Gm-Message-State: APjAAAWLvm0TYHlBbLwKgLUTNZDMWfN+8eenMc1nP2hOmtvYybU9b7z3
        FIu//l+6q6jLiF000BV5n0qkIVXoNfuZ6WqweJ56WA==
X-Google-Smtp-Source: APXvYqzBxY4A3/fHzFsZp/lckxSB2259/DoEQvS3DVOHEjr3/bNQHVWVcK4ly/vBTttvpRhufA67lVArmUoWdpgsxMg=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr4920678wro.343.1561573326724;
 Wed, 26 Jun 2019 11:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190613064813.8102-1-namit@vmware.com> <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com> <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
 <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
 <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com> <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
 <A52332CE-80A2-4705-ABB0-3CDDB7AEC889@vmware.com> <CALCETrW2kudQ-nt7KFKRizNjBAzDVfLW7qQRJmkuigSmsYBFhg@mail.gmail.com>
 <878stockhi.fsf@vitty.brq.redhat.com>
In-Reply-To: <878stockhi.fsf@vitty.brq.redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 26 Jun 2019 11:21:54 -0700
X-Gmail-Original-Message-ID: <CALCETrWWzk+kHJorkVZAdAm90nYUbS+zgvDxqp5KRvf8vU_xqg@mail.gmail.com>
Message-ID: <CALCETrWWzk+kHJorkVZAdAm90nYUbS+zgvDxqp5KRvf8vU_xqg@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Nadav Amit <namit@vmware.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 10:41 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
>
> > All this being said, do we currently have any system that supports
> > PCID *and* remote flushes?  I guess KVM has some mechanism, but I'm
> > not that familiar with its exact capabilities.  If I remember right,
> > Hyper-V doesn't expose PCID yet.
> >
>
> It already does (and support it to certain extent), see
>
> commit 617ab45c9a8900e64a78b43696c02598b8cad68b
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Wed Jan 24 11:36:29 2018 +0100
>
>     x86/hyperv: Stop suppressing X86_FEATURE_PCID
>

Hmm.  Once the dust settles from Nadav's patches, I think we should
see about supporting it better :)
