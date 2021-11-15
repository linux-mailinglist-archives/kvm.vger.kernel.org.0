Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16945208E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345595AbhKPAzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbhKOTVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:23 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5787C07DE4D
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:17:56 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v19so4440203plo.7
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zVIigt5hFRhwoHdnPkqdezNkgtT3bQVD+JV1TZ0yBQk=;
        b=aIFb+Bg2kAQ6u2avnkXgX+2F+XsjwU8PJbAILzNG66y0Npi9zFLasu3DiaXqW2vnUq
         XQn2eLnu4wHnrtJsF/JKd/GXTb/hXXs1b1tvMaulKoZJJG/RKlWLZNxsr6DJPAMgyhyQ
         gLSA7I+KjaST0YMZnMn+HI9FW40+/+MwqE+2nhY8Y+6N2j7cMXMxniw6Tf0yVSTkiE3U
         w1EBeHcm/riM8DRmyCdwozujjMclAB0IhtYBKO4J4uioDIWabX2Ng1GO2HH+mbCJlpC9
         38U5GlMY9tw62ZR1mlT3p0jLcsVoNuP7Qbvh/lSUuU7SQnhyzDLppN9qLlWFSqBZZGwk
         +MGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zVIigt5hFRhwoHdnPkqdezNkgtT3bQVD+JV1TZ0yBQk=;
        b=kL8DwqZZ7xQ2gGio5Fz0oC4wlO37tR5tamJo+7OJY0JqpjE6tSAZQEzHBcc+dP03Hc
         WGm5fZTrNsijCO5Rw9ak7lU+DOKZzQb6B1EC+Poj1EmntWxWKdoPBSj7MLurl1DxugpU
         o+b714FFMRa4egh0g942yJ4kyZVUrPWFKwvjbe5k9fstkfmCc+o1YCUKXT09lzdiKOW9
         qwtAQcaxUEgmXAFhwNbPoLWdTrEVF5CNuSF8lzVG3LFEOTS8ZofuTjX4cFSAGsdY3aeF
         hejULMdO8snRj+fJWyrWNANooYRS7uCxQb1O/Uh4XhCXWvL5H7Uk6nUWeTqWGTlZI1L3
         BM0A==
X-Gm-Message-State: AOAM532BuYAeOBeXL44usXn1bV7OKP6l8dSVYxJP5jVopIqU1fg00Yrj
        UQKXv3F0fYq03LQJhQ7+98SX+Q==
X-Google-Smtp-Source: ABdhPJyEk01A4cEBJRk2IJwMDA9ufuQA+Un9JScTgr2yhZJMzSPbmQlcRKUkuJ1yVS564FPMQwEnDg==
X-Received: by 2002:a17:90b:4b04:: with SMTP id lx4mr647925pjb.11.1637000276010;
        Mon, 15 Nov 2021 10:17:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c3sm11160202pgk.16.2021.11.15.10.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:17:55 -0800 (PST)
Date:   Mon, 15 Nov 2021 18:17:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKkT1jwfGbkrGqu@google.com>
References: <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
 <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
 <YY8Mi36N/e4PzGP0@google.com>
 <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
 <YZADwHxsx5cZ6m47@google.com>
 <CAA03e5HwYtn+eG1f5eP-SrZPyE4D2uf0v10=VkVoTNQQk87Kew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5HwYtn+eG1f5eP-SrZPyE4D2uf0v10=VkVoTNQQk87Kew@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021, Marc Orr wrote:
> On Sat, Nov 13, 2021 at 10:28 AM Sean Christopherson <seanjc@google.com> wrote:
> > The behavior is no different than it is today for regular VMs.
> 
> Isn't this counter to the sketch you laid out earlier where you wrote:
> 
> --- QUOTE START ---
>   - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
>   - if kernel accesses guest private memory, it does BUG/panic/oops[*]
>   - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
> --- QUOTE END ---
> 
> Here, the guest does not get killed. Which seems hard to debug.

No, it does contradict that statement.
 
  If the guest requests a conversion from shared=>private without first ensuring
  the gfn is unused (by a host "device"), the host will side will continue accessing
  the old, shared memory, which it locked, while the guest will be doing who knows
  what.

In this case, the guest will have converted a GPA from shared=>private, i.e. changed
the effective GFN for a e.g. a shared queue, without informing host userspace that
the GFN, and thus the associated HVA in the host, has changed. For TDX that is
literally the same bug as the guest changing the GFN without informing the host, as
the SHARED bit is just an address bit with some extra meaning piled on top.  For SNP,
it's slightly different because the C-bit isn't strictly required to be an address
bit, but for all intents and purposes it's the same type of bug.

I phrased it "guest will be doing who knows what" because from a host userspace
perspective, it can't know what the guest behavior will be, and more importantly,
it doesn't care because (a) the guest is buggy and (b) the host itself  is _not_ in
danger.

Yes, those types of bugs suck to debug.  But they really should be few and far
between.  The only reason I called out this specific scenario was to note that host
userspace doesn't need to take extra steps to guard against bogus shared=>private
conversions, because host userspace already needs to have such guards in place.  In
prior (offline?) conversations, we had assumed that host userspace would need to
propagate the shared vs. private status to any and all processes that map guest
memory, i.e. would require substantial enabling, but that assumption was wrong.

> If allowing userspace to inject #VC into the guest means that the host
> can continue to serve other guests, that seems like a win. The
> alternative, to blow up the host, essentially expands the blast radius
> from a single guest to all guests.

As mentioned in other threads of this conversation, when I say "host crashes", I
am specifically talking about scenarios where it is simply not possible for the
host kernel to recover, e.g. an RMP #PF violation on the IDT.

Setting that aside, injecting a #VC into the guest is not in anyway necessary for
a buggy host userspace to terminate a single guest, host userspace can simply stop
running that specific guest.
