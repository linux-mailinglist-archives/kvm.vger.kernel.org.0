Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6A44EE82
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhKLV0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235736AbhKLV0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:26:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FC460FE3;
        Fri, 12 Nov 2021 21:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636752205;
        bh=lx7eciPrF/BBoyKZDT93AJxWh2JCgt0BeWSKXENAJFQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bJPu5lCSOzrkVvhS7ygoyiJD7QWq/BJp91+5S4lbYZq92OzolpVxpu5Tjp+YDrTw8
         nMNmk56DMjjvq0HImMjWN3n3cmoWSXiUmTcV3GPv7kFTn6gZyFk7QwUwDveyk9r8uh
         DVzMyW9RbqXewpj0Iheo2z9NiivVOB38QXRvLzEewO5CZHAyl2cv4ChNIlFUEbz3oy
         KnvRvcmdpZAqXkTr4tjwzoYpzobPvUVHHY9DAz/sGXl5Q4+X3esbY6Xf+q3OtYexb2
         GDwlzNwhUsLSyO363Hfb4WNqsQUqlp+jMuMTvRjbVjEHcwAvC1rXev9wjbqQm3g/HW
         Kkq6TPAOB8c0A==
Message-ID: <ffcf2585-feef-d86c-efbd-8a53f73437ad@kernel.org>
Date:   Fri, 12 Nov 2021 13:23:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>
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
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <CAA03e5EpQZnNzWgRsCAahwwvsd6+QVnRHdiYFM=GhEb2N1W0GQ@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
In-Reply-To: <CAA03e5EpQZnNzWgRsCAahwwvsd6+QVnRHdiYFM=GhEb2N1W0GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 13:16, Marc Orr wrote:
>>> So cloud providers should have an interest to prevent such random stray
>>> accesses if they wanna have guests. :)
>>
>> Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> 
> I want to push back on "inducing a fault in the guest because of
> _host_ bug is wrong.". The guest is _required_ to be robust against
> the host maliciously (or accidentally) writing its memory. SNP
> security depends on the guest detecting such writes. Therefore, why is
> leveraging this system property that the guest will detect when its
> private memory has been written wrong?

 >
> Especially when its orders or
> magnitudes simpler than the alternative to have everything in the
> system -- kernel, user-space, and guest -- all coordinate to agree
> what's private and what's shared. Such a complex approach is likely to
> bring a lot of bugs, vulnerabilities, and limitations on future design
> into the picture.
> 

SEV-SNP, TDX, and any reasonable software solution all require that the 
host know which pages are private and which pages are shared.  Sure, the 
old SEV-ES Linux host implementation was very simple, but it's nasty and 
fundamentally can't support migration.
