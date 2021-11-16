Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED2845395F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbhKPS3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhKPS3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 13:29:31 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3279DC061764
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:26:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b11so18129652pld.12
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U0muw/pk5BQDok3Q5lPpJXidVuYkuyrdzH8jZXEAbNc=;
        b=awbmYI68su+KL24wmN9QlTGjCxBVTsbebJn6HnREIiE1hcieUyaSquNCC1P7Q0EKIc
         QoTOxpNQOxGZr9EgcoHfrTl9WlDQaYLHND+B0ej4SbEPnLsNvB90eGdle+cdGPlJNqX2
         dnS0gZo+9kHQQrzVBEmJs2HirTQ3F7492T7YGy2stGJxRAOO8JpVY1N7vJFwyfnEqbCf
         W/t8ZlLALbLhAVx5p3ozRSDSeyPedenNTuA1o39ssb0eZUJhqKtmArMydGjGWczJ4oRA
         wzu63aLTDcEhWxXPSc9jmisFBRo+HtRa5HS1sQwswAPl2NCnBF9ZFnCQoixIyJDBN8RP
         qlJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0muw/pk5BQDok3Q5lPpJXidVuYkuyrdzH8jZXEAbNc=;
        b=SyB6pUFoa35oDjkiwJ0CMsb/wbq/VUXmd3YJJwMQzSQygaldEkHanBETiDjygRd+1U
         CMdj8vgj3PVTP12L8asknJwbCNDuhOCjyIHlMfGiujlHIicuubTNdYyLpQ3r5Rxnlc4y
         1VWi4mES6VZuBaUq4kbpJji6tN+v7DfopiPzTFtNQkojcVwKl97O1xcmBx1rIASa34TQ
         zf+y5m+6lca6aTaKTR38aqHPkptyI5BIHRyUqZBmD5D8fZMCo+cwJQHWJkjCRPjdPtWf
         scTBnpR1el1GFlToUrHJGFvQdbLEdxDaittIZ6AepMVhCr8JDXTGuEGqVgSrCVvK6WzC
         UFXw==
X-Gm-Message-State: AOAM531mKvk1idy9n7RCGoGyM0AqHuNzsbT4KogOrFkZwdo1Tjkv5Kai
        9GfVmPfTkNjy+KBsOK4dImThcA==
X-Google-Smtp-Source: ABdhPJw8HRH8xYD3IacFC4bFZ9REYP2/8EOdbVoGt1XfjR4JZepz4sWi/UhJMw10juH4zM+78SNn7g==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr1422161pjb.238.1637087193552;
        Tue, 16 Nov 2021 10:26:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w189sm2148500pfd.164.2021.11.16.10.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 10:26:32 -0800 (PST)
Date:   Tue, 16 Nov 2021 18:26:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Marc Orr <marcorr@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZP31a8acsfD+snJ@google.com>
References: <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
 <YZKxuxZurFW6BVZJ@google.com>
 <CAA03e5GBajwRJBuTJLPjji7o8QD2daEUJU7DpPJBxtWsf-DE8g@mail.gmail.com>
 <8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com>
 <YZOwbjGVEfa/wLaS@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZOwbjGVEfa/wLaS@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Joerg Roedel wrote:
> But as Marc already pointed out, the kernel needs a plan B when an RMP
> happens anyway due to some bug.

I don't see why unexpected RMP #PF is a special snowflake that needs a different
plan than literally every other type of unexpected #PF in the kernel.
