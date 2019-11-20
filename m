Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6298103740
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 11:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfKTKNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 05:13:49 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38746 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbfKTKNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 05:13:49 -0500
Received: by mail-oi1-f195.google.com with SMTP id a14so21993015oid.5;
        Wed, 20 Nov 2019 02:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lde2KhjY7wfAoIiWkWWnbWFwuvtD6AW2ng2O9SrZAQI=;
        b=tum3HFhYbfwE2ky4iNe0IhOcN4+nZNb/DMn8iw2S81C99M+x5e2EpQ8Kac8CGk22dR
         SgZdMXeUc7J3ZIhOyA5CkcJtybYPj7wt4WMrvym3C5fkFUU6DtSkbg9gpizwYk7xNNTm
         pyFyJsPwCpU+rSp2zDiF49sl68Fl0syhG0ar6BTMKk+n0C7Xdp/Ba6qJ62Ldu+e/Vq4S
         IUWuV5f55JU4oe0yXJObBkBRBhvEHzpfhvr3gOvVP6Ji4F48VB90D0ljh8mW/5BGPYvD
         j9J76EzK4ABxmgE7DW3/pCIxDs0qJX/Wa9k+JCjFJOQd7Qsyy8xlwKh7Paz66kocFjg9
         seRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lde2KhjY7wfAoIiWkWWnbWFwuvtD6AW2ng2O9SrZAQI=;
        b=dp2Asg+LT2tjCaHgCNShZ0aqsQkE+kxWcfc+Hw30zjZc8E18O5c9Ja7XSv2qgXKLUl
         WGfjhHJg0R5bU/y4zMJcTFZyE1nZu39ea6meH1nKHkp6FLSJdBrW57mq8adK0nPQlNGn
         4wM+LqA1Mvw2Z1p6YIMrtDbmueuSDOuD/0LzlHRjRVQZBjyLUgcfO8Ix5Jha9+tPg4F5
         uNpwEcemHjbtTCV6iTHih3ZMZace2SV0aqHp/u7W0ELpz3RCAikZmCFxv3Uj7ZkZi0px
         +yQXLlYpFUzJDEFX97jNgj2PXQqZhpJZZ0TnJC1BN6wePCrlSTLBw1aZ2Dlaz80PfF1U
         eUWg==
X-Gm-Message-State: APjAAAUEFKoluQjdy5gPM2cQyofsUydNXEzRuTMO2jLrjSBAr7T2oPII
        LsP8SA2AOYg9ogIZsMw4HRjte/xtN11J4SNaMCU=
X-Google-Smtp-Source: APXvYqxZSfWMxyflhcnT9tM5lOwDlMuKYqjC59kb27nMC0uIT+CCiDvQijJ51b9M9rmiGv4h+QUrJ21pTECzguY3nOA=
X-Received: by 2002:aca:4a84:: with SMTP id x126mr1978871oia.47.1574244828632;
 Wed, 20 Nov 2019 02:13:48 -0800 (PST)
MIME-Version: 1.0
References: <20191105161737.21395-1-vkuznets@redhat.com> <20191105200218.GF3079@worktop.programming.kicks-ass.net>
 <20191105232528.GF23297@linux.intel.com> <20191106083235.GP4131@hirez.programming.kicks-ass.net>
In-Reply-To: <20191106083235.GP4131@hirez.programming.kicks-ass.net>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 18:13:41 +0800
Message-ID: <CANRm+CxtE-jMCGbhfL5QSU9JDCFcytsF=KQD6QGzT22-5_ZS8A@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is trustworthy
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
On Wed, 6 Nov 2019 at 16:34, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Nov 05, 2019 at 03:25:28PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 05, 2019 at 09:02:18PM +0100, Peter Zijlstra wrote:
> > > On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> > > > Virtualized guests may pick a different strategy to mitigate hardware
> > > > vulnerabilities when it comes to hyper-threading: disable SMT completely,
> > > > use core scheduling, or, for example, opt in for STIBP. Making the
> > > > decision, however, requires an extra bit of information which is currently
> > > > missing: does the topology the guest see match hardware or if it is 'fake'
> > > > and two vCPUs which look like different cores from guest's perspective can
> > > > actually be scheduled on the same physical core. Disabling SMT or doing
> > > > core scheduling only makes sense when the topology is trustworthy.
> > > >
> > > > Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> > > > that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> > > > topology is actually trustworthy. It would, of course, be possible to get
> > > > away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> > > > compatibility but the current approach looks more straightforward.
> > >
> > > The only way virt topology can make any sense what so ever is if the
> > > vcpus are pinned to physical CPUs.
> > >
> > > And I was under the impression we already had a bit for that (isn't it
> > > used to disable paravirt spinlocks and the like?). But I cannot seem to
> > > find it in a hurry.
> >
> > Yep, KVM_HINTS_REALTIME does what you describe.
>
> *sigh*, that's a pretty shit name for it :/

My original commit name this to KVM_HINTS_DEDICATED, commit a4429e53c
(KVM: Introduce paravirtualization hints and KVM_HINTS_DEDICATED),
could we revert the KVM_HINTS_REALTIME renaming? A lot of guys
confused by this renaming now, Peterz, Marcelo ("The previous
definition was much better IMO: HINTS_DEDICATED".
https://lkml.org/lkml/2019/8/26/855).

    Wanpeng
