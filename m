Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FCC2310A8
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 19:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgG1RN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 13:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1RN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 13:13:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE56EC0619D4
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 10:13:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w12so7925888iom.4
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 10:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7RHcaI6/eTe56IzgJ5p2FT6CPrKQOVowAeyYJ5JZY8=;
        b=hqBFbZ1EIlbZWPYoCsixxDe1MAR9ZiNu7XW7VsFaOGKOrul7BN73reE5RP2wJUhIMi
         soM8CTX6M0sE6+8mXj356oFq7afSTEN3raZmVx7Iw6ZX1LBvJkmNf8BeFWhXyWgTt5QO
         sX/uSn8oNMCt4QDEShDFJ7/oldS98rYaGFuedhtSNN+eDif4oEixlTqZPeAbfbXRDt/U
         cFfLAi/d75TyOrcppGsnsrwsy1s6s4M/K5qeJH4Qg2x2NnVDLWg00bUa+RswtIAz0yV8
         uZjiyPSCrman08np7drF5ovs+s0yYro3RLrjtBQtnu85Srj/Kdbt8DZ3cLk/3fN4nkny
         9iqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7RHcaI6/eTe56IzgJ5p2FT6CPrKQOVowAeyYJ5JZY8=;
        b=P+PEueLtteb9ESV4Emr7ZfiHC9rBS6bKoxfL7ul/ZqICUakmPbHjBkWFtEak05tjkX
         /7Hojj7XJtKPYGaOxmZ51TEsDv4fA+7cwfKxA7tietgT5ZVI/31ZHf3XLicEQJHOAN/+
         I8MiTzRvZdkgHk0GnNBUCDNW9+sY1or2tk8soy3gIMqMFZn8L6llWwai+au38zF2Ac82
         Rgr2NjZ+0O0e0HJwL4mqqB2jRum1bt6Iv6X2lBhP1leMQl8ZNeb0EBm6e5/cT005m2mC
         HCYxEU93n2Wu4a5NqckeD8G82o/zrX4NLgZYO5400WxeztqbMWE6ag70bGxdOBlSimt/
         JbXA==
X-Gm-Message-State: AOAM533pslRvJCVvn1NAA7n5ZaG7ABcoXSwLjaLnrZOLyXBJIuIO6D61
        YOAWHe4oLjoegoDa2EMSimMA7KcpchCOE48GrDFfxQ==
X-Google-Smtp-Source: ABdhPJzma4OqnK14EV4esOOkgwzNHy5xbaUVnJne8BaCRpJN0GzCX3/MLC6Rh5rtpUGBJ1dGDwx7gOeDEISxL4P9YPA=
X-Received: by 2002:a05:6638:164e:: with SMTP id a14mr9658222jat.18.1595956404815;
 Tue, 28 Jul 2020 10:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200728004446.932-1-graf@amazon.com> <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
In-Reply-To: <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jul 2020 10:13:13 -0700
Message-ID: <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 5:41 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 28.07.20 10:15, Vitaly Kuznetsov wrote:
> >
> > Alexander Graf <graf@amazon.com> writes:
> >
> >> MSRs are weird. Some of them are normal control registers, such as EFER.
> >> Some however are registers that really are model specific, not very
> >> interesting to virtualization workloads, and not performance critical.
> >> Others again are really just windows into package configuration.
> >>
> >> Out of these MSRs, only the first category is necessary to implement in
> >> kernel space. Rarely accessed MSRs, MSRs that should be fine tunes against
> >> certain CPU models and MSRs that contain information on the package level
> >> are much better suited for user space to process. However, over time we have
> >> accumulated a lot of MSRs that are not the first category, but still handled
> >> by in-kernel KVM code.
> >>
> >> This patch adds a generic interface to handle WRMSR and RDMSR from user
> >> space. With this, any future MSR that is part of the latter categories can
> >> be handled in user space.

This sounds similar to Peter Hornyack's RFC from 5 years ago:
https://www.mail-archive.com/kvm@vger.kernel.org/msg124448.html.

> >> Furthermore, it allows us to replace the existing "ignore_msrs" logic with
> >> something that applies per-VM rather than on the full system. That way you
> >> can run productive VMs in parallel to experimental ones where you don't care
> >> about proper MSR handling.
> >>
> >
> > In theory, we can go further: userspace will give KVM the list of MSRs
> > it is interested in. This list may even contain MSRs which are normally
> > handled by KVM, in this case userspace gets an option to mangle KVM's
> > reply (RDMSR) or do something extra (WRMSR). I'm not sure if there is a
> > real need behind this, just an idea.
> >
> > The problem with this approach is: if currently some MSR is not
> > implemented in KVM you will get an exit. When later someone comes with a
> > patch to implement this MSR your userspace handling will immediately get
> > broken so the list of not implemented MSRs effectively becomes an API :-)

Indeed. This is a legitimate concern. At Google, we have experienced
this problem already, using Peter Hornyack's approach. We ended up
commenting out some MSRs from kvm, which is less than ideal.

> Yeah, I'm not quite sure how to do this without bloating the kernel's
> memory footprint too much though.
>
> One option would be to create a shared bitmap with user space. But that
> would need to be sparse and quite big to be able to address all of
> today's possible MSR indexes. From a quick glimpse at Linux's MSR
> defines, there are:
>
>    0x00000000 - 0x00001000 (Intel)
>    0x00001000 - 0x00002000 (VIA)
>    0x40000000 - 0x50000000 (PV)
>    0xc0000000 - 0xc0003000 (AMD)
>    0xc0010000 - 0xc0012000 (AMD)
>    0x80860000 - 0x80870000 (Transmeta)
>
> Another idea would be to turn the logic around and implement an
> allowlist in KVM with all of the MSRs that KVM should handle. In that
> API we could ask for an array of KVM supported MSRs into user space.
> User space could then bounce that array back to KVM to have all in-KVM
> supported MSRs handled. Or it could remove entries that it wants to
> handle on its own.
>
> KVM internally could then save the list as a dense bitmap, translating
> every list entry into its corresponding bit.
>
> While it does feel a bit overengineered, it would solve the problem that
> we're turning in-KVM handled MSRs into an ABI.

It seems unlikely that userspace is going to know what to do with a
large number of MSRs. I suspect that a small enumerated list will
suffice. In fact, +Aaron Lewis is working on upstreaming a local
Google patch set that does just that.
