Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2B450473
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 13:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhKOMeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 07:34:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhKOMeE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 07:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636979466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmrvKUYAASjH6mIRSwiOSO3Soa8eQXTmOOyvhFqgyNs=;
        b=NYhNPrytHyLARe6T3SH9dQV1z2j0dTmW4NSeaPb9ytosqBJKzvCi7KtI2aC435cRl3dYFU
        OpcP492Nm/nqF1EdQL4xG08rnC9sf7qOfcVaxiOwCenN8yyNuaAVoHfK4gO8CJl3Q5ufr3
        prJg+1We1f/anXnOMC8iJLvb2PN/I+4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-bNaYmKLENKqikKMWPnIVxg-1; Mon, 15 Nov 2021 07:31:04 -0500
X-MC-Unique: bNaYmKLENKqikKMWPnIVxg-1
Received: by mail-wm1-f69.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso7817937wms.5
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 04:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bmrvKUYAASjH6mIRSwiOSO3Soa8eQXTmOOyvhFqgyNs=;
        b=Ec144O7yLqDPLToyXdS07HHK8VtLstZRfhAba6HYnGvjPELP6cW0O3JysekjDFvo+k
         asSeVa/Sl8c7uCw4iVVdKXGJwad/Hxcm7gs0+bQGyVjorzXVJsT7AImFiO1D2P0K+CAJ
         p35J45kgkdCUlOJZsbBS46bWrCPslO0w9iljv80K1gIytf7N2tWeriZmFFmk8JdNEsta
         OMhepPhKi03IWwJLMMV3FbqeM1AqJEAGCly5UvAEVjf4lthcsmjVePP0hk0f297RFMLh
         edDE6GwN0PvzH9u0lnhFKQ3yb4rRyqcVaRcI6R6wSNjwhPYwodHAxzna2mjpGKOG0whY
         xttQ==
X-Gm-Message-State: AOAM533y+fmZlkpxHK06oSKkHxCwL3aBW2L0n+31ew7nodg8vJ2um1KS
        xapvhWWi0oh5CpqXKWS+RRFGLbNkXzm/7kkhsq6SXspXMIoVuyU67+SJDrwahsrJdI7FdZDkCH8
        vY0byb8OVWQ6z
X-Received: by 2002:adf:f708:: with SMTP id r8mr46380730wrp.198.1636979463371;
        Mon, 15 Nov 2021 04:31:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzH7dBVhHzposGOZpkUWZ27MvoJHO6QECzLEU5yEXHaBNIHFbfvFOSCbhtiEPuokaDOzbkyRg==
X-Received: by 2002:adf:f708:: with SMTP id r8mr46380675wrp.198.1636979463157;
        Mon, 15 Nov 2021 04:31:03 -0800 (PST)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id f7sm22666208wmg.6.2021.11.15.04.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 04:31:02 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:30:59 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZJTA1NyLCmVtGtY@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YY7FAW5ti7YMeejj@google.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (seanjc@google.com) wrote:
> On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > Or, is there some mechanism that prevent guest-private memory from being
> > > accessed in random host kernel code?
> 
> Or random host userspace code...
> 
> > So I'm currently under the impression that random host->guest accesses
> > should not happen if not previously agreed upon by both.
> 
> Key word "should".
> 
> > Because, as explained on IRC, if host touches a private guest page,
> > whatever the host does to that page, the next time the guest runs, it'll
> > get a #VC where it will see that that page doesn't belong to it anymore
> > and then, out of paranoia, it will simply terminate to protect itself.
> > 
> > So cloud providers should have an interest to prevent such random stray
> > accesses if they wanna have guests. :)
> 
> Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.

Would it necessarily have been a host bug?  A guest telling the host a
bad GPA to DMA into would trigger this wouldn't it?

Still; I wonder if it's best to kill the guest - maybe it's best for
the host to kill the guest and leave behind diagnostics of what
happened; for someone debugging the crash, it's going to be less useful
to know that page X was wrongly accessed (which is what the guest would
see), and more useful to know that it was the kernel's vhost-... driver
that accessed it.

Dave

> On Fri, Nov 12, 2021, Peter Gonda wrote:
> > Here is an alternative to the current approach: On RMP violation (host
> > or userspace) the page fault handler converts the page from private to
> > shared to allow the write to continue. This pulls from s390’s error
> > handling which does exactly this. See ‘arch_make_page_accessible()’.
> 
> Ah, after further reading, s390 does _not_ do implicit private=>shared conversions.
> 
> s390's arch_make_page_accessible() is somewhat similar, but it is not a direct
> comparison.  IIUC, it exports and integrity protects the data and thus preserves
> the guest's data in an encrypted form, e.g. so that it can be swapped to disk.
> And if the host corrupts the data, attempting to convert it back to secure on a
> subsequent guest access will fail.
> 
> The host kernel's handling of the "convert to secure" failures doesn't appear to
> be all that robust, e.g. it looks like there are multiple paths where the error
> is dropped on the floor and the guest is resumed , but IMO soft hanging the guest 
> is still better than inducing a fault in the guest, and far better than potentially
> coercing the guest into reading corrupted memory ("spurious" PVALIDATE).  And s390's
> behavior is fixable since it's purely a host error handling problem.
> 
> To truly make a page shared, s390 requires the guest to call into the ultravisor
> to make a page shared.  And on the host side, the host can pin a page as shared
> to prevent the guest from unsharing it while the host is accessing it as a shared
> page.
> 
> So, inducing #VC is similar in the sense that a malicious s390 can also DoS itself,
> but is quite different in that (AFAICT) s390 does not create an attack surface where
> a malicious or buggy host userspace can induce faults in the guest, or worst case in
> SNP, exploit a buggy guest into accepting and accessing corrupted data.
> 
> It's also different in that s390 doesn't implicitly convert between shared and
> private.  Functionally, it doesn't really change the end result because a buggy
> host that writes guest private memory will DoS the guest (by inducing a #VC or
> corrupting exported data), but at least for s390 there's a sane, legitimate use
> case for accessing guest private memory (swap and maybe migration?), whereas for
> SNP, IMO implicitly converting to shared on a host access is straight up wrong.
> 
> > Additionally it adds less complexity to the SNP kernel patches, and
> > requires no new ABI.
> 
> I disagree, this would require "new" ABI in the sense that it commits KVM to
> supporting SNP without requiring userspace to initiate any and all conversions
> between shared and private.  Which in my mind is the big elephant in the room:
> do we want to require new KVM (and kernel?) ABI to allow/force userspace to
> explicitly declare guest private memory for TDX _and_ SNP, or just TDX?
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

