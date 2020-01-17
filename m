Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE7141383
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 22:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAQVoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 16:44:11 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39408 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbgAQVoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 16:44:11 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so27568917ioh.6
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 13:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/x7YEfXTnu7y4p8C/lAV2TQ+Hnzrje2loXceAXbcf8=;
        b=hhoIC6uB/1xM6ya14QQe8JMPIJ9i9FaU+91tiqQcvrWAYepLT1hVgMD3guAZvM22qA
         2tfA99pLQXH0BeFhZqKkFhTcJSH/D5mm2SlX5pMmhWrVcMTmsOrUMBUVCKsgauFPUEhv
         wiVQgHSRNXPekuMm4Qsqs0mwySVvTW2EB0Uu2hV4DN2ZpAO+3a/VYdmEvQtH00NOUOC8
         qykuss+5p3r8jo72AW1jEhqBZqjqZZX0F+4oTW3zFQkSq4t34MrnW4XIFBheKY8vfDF3
         TMyO/SMqKxnY9qn1ulPTzr4cMNs+7zVZv2f1byhoAhKgAaVsLrbAy1AbXHqskr7A5wcX
         uvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/x7YEfXTnu7y4p8C/lAV2TQ+Hnzrje2loXceAXbcf8=;
        b=i79RTulZItb+81lHxYBPFdJAoLuaKdJzGKwC8rGGJJxsiwXbJ6pNdZgkToE2VSertK
         CCY0O8f6tvu04wg8bzmiMMfZULGJsdXN3/THsXFvVE23JMZVeQWXPMfsM3cy9PJJBVFN
         JqdMvifQFWsz4RcZ3yE4lsn/pdwikL2D2yi5ZcvVZqKIaDgd2OMKgfDlnQ1ICm5n3TlG
         1zIHFAYemMsYwY3L6O+UUl09ognjOsGLuy5aPJjYuNMstyqjdflQzAmG1mxn0is0c+Iz
         zNzy6w2p4OQLDwItsPgFfDZuH69rDhqtQLIhlSD7x0i7q/rlyAtC7ny+8dNhLusVJ3fx
         hKBA==
X-Gm-Message-State: APjAAAVRGKZl8bPl3B3Tr0g9wUldzpPG6r8A40qZtasfs8M5OrnjsE+h
        w+ubrSwJI48y4yTfsNlGArcoVVBqVzLd9cF4P2q8pw==
X-Google-Smtp-Source: APXvYqy5pBbKqV841ruxH9nDvJZCLkW85jHOK3n1lveSgX0KX8tWnAde4jw5orrzYoUIQco+Egg+JcLnyh6Q9ix+XIo=
X-Received: by 2002:a5e:8e4c:: with SMTP id r12mr32018340ioo.119.1579297450141;
 Fri, 17 Jan 2020 13:44:10 -0800 (PST)
MIME-Version: 1.0
References: <20200113221053.22053-1-oupton@google.com> <20200113221053.22053-3-oupton@google.com>
 <20200114000517.GC14928@linux.intel.com> <CALMp9eR0444XUptR6a57JVZwrCSks9dndeDZcQBZ-v0NRctcZg@mail.gmail.com>
 <20200114182843.GG16784@linux.intel.com>
In-Reply-To: <20200114182843.GG16784@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 17 Jan 2020 13:43:59 -0800
Message-ID: <CALMp9eR5YA3D000497csjXBa43bNyNSGCCQV2ammwwF=ztAtSQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 14, 2020 at 10:28 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jan 14, 2020 at 09:58:22AM -0800, Jim Mattson wrote:
> > On Mon, Jan 13, 2020 at 4:05 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > Another case, which may or may not be possible, is if INIT is recognized
> > > on the same instruction, in which case it takes priority over MTF.  SMI
> > > might also be an issue.
> >
> > Don't we already have a priority inversion today when INIT or SMI are
> > coincident with a debug trap on the previous instruction (e.g.
> > single-step trap on an emulated instruction)?
>
> Liran fixed the INIT issue in commit 4b9852f4f389 ("KVM: x86: Fix INIT
> signal handling in various CPU states").
>
> SMI still appears to be inverted.

I find the callgraph for vmx_check_nested_events very confusing. It's
called as many as three times per call to vcpu_enter_guest():

    1. From kvm_vcpu_running(), before the call to vcpu_enter_guest().
    2. From inject_pending_event(), in vcpu_enter_guest(), after all
of the calls to kvm_check_request().
    3. From inject_pending_event(), after injecting (but not
reinjecting) an event, but not if we've processed an SMI or an NMI.

Can this possibly respect the architected priorities? I'm skeptical.

Within the body of vmx_check_nested_events(), the following priorities
are imposed:

1. INIT
2. Intercepted fault or trap on previous instruction
3. VMX preemption timer
4. NMI
5. External interrupt

(2) is appropriately placed for "traps on the previous instruction,"
but it looks like there is a priority inversion between INIT and an
intercepted fault on the previous instruction. In fact, because of the
first two calls to vmx_check_nested_events() listed above, there is a
priority inversion between an *unintercepted* fault on the previous
instruction and any of {INIT, VMX preemption timer, NMI, external
interrupt}.

Or is there some subtlety here that I'm missing?
