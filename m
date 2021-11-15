Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E92451DD8
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346954AbhKPAeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343877AbhKOTWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC9EC048766
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:26:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so4469568pjb.2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A9PRl8Edo1EWLltgYNzeLAxhIeguWSTUtvI4vu4lOU0=;
        b=Tv74eWk0THvgIgB6wM77S6Ef1ZXOnEycR/P0bJH/PHV0rI8Xd2WKU7UgRcZBcU1J8d
         70izO3lKwvwLV5d9KsCpEb9gYKTwFplQAH6SMcE6qi4Sg7F51ov9sSSkn1nleOTVRI90
         VBYOU7WTqSm8olxqB+csjjUk5YmghZ9mYNkd/tXqfSW59kxs7JF/DhYXHbWwxrNgIfju
         uoCo2v6lkkLeMTRBUnW0ULL6rMDoNAN2wEteSyBra/V5CM2tI5Aix9i5EIhfjzmOLFwM
         7QS9XB6Wghv45R/RHrO+ZRrVtMQuAZmrizaTWExRWL8igX4GF0a++ljsaMY2CGtqT8ar
         xn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A9PRl8Edo1EWLltgYNzeLAxhIeguWSTUtvI4vu4lOU0=;
        b=ZhAYEbu0yieI+xAsy3PKibzbLZJhrLQPy2vSHO5bEZnafAb8x7TvWSfEL/pGyChNWQ
         tQ/QxNQ408KiEgqSWIQLsQtdMap8n4eqvhvfpjMVdvwa7bmQSz/HcleuXvyHSoDbuiJ6
         q4DiSZqODuv29D/+bs1ZZ+w4lWdgg+pwosKx3rtNo1btGdNXY5wzIIoI6UAwKznCQ3JI
         eA6biXozIyUDNdFocsjyKupmC789n8eT0VSY4DDCxq0EdE70Pi+U7oHXjjhw/rHazVsL
         iKw3GEmFQHWscMIywseT/mpy2RpjLPD86SpzsS6CM3DmhlZOp0Q98GYqMLWw45IxBV3n
         jTOQ==
X-Gm-Message-State: AOAM530dSGCsyhnSxnGTdEQ1FBNUM3NRqy7mouEerRMHD711HXmqhGw4
        al0cuQ0vIVp55HJTBOrSKTh++Q==
X-Google-Smtp-Source: ABdhPJzK5CjhfcvH0PmOfpiEEoynXyH6jQCHvXEWNSTTtJYReVaHOW8puWF5UMHDZMQhJJBwpkgApA==
X-Received: by 2002:a17:903:2306:b0:142:123a:24ec with SMTP id d6-20020a170903230600b00142123a24ecmr37182268plh.21.1637000781046;
        Mon, 15 Nov 2021 10:26:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ot7sm63595pjb.21.2021.11.15.10.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:26:20 -0800 (PST)
Date:   Mon, 15 Nov 2021 18:26:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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
Message-ID: <YZKmSDQJgCcR06nE@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJTA1NyLCmVtGtY@work-vm>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (seanjc@google.com) wrote:
> > On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > > Or, is there some mechanism that prevent guest-private memory from being
> > > > accessed in random host kernel code?
> > 
> > Or random host userspace code...
> > 
> > > So I'm currently under the impression that random host->guest accesses
> > > should not happen if not previously agreed upon by both.
> > 
> > Key word "should".
> > 
> > > Because, as explained on IRC, if host touches a private guest page,
> > > whatever the host does to that page, the next time the guest runs, it'll
> > > get a #VC where it will see that that page doesn't belong to it anymore
> > > and then, out of paranoia, it will simply terminate to protect itself.
> > > 
> > > So cloud providers should have an interest to prevent such random stray
> > > accesses if they wanna have guests. :)
> > 
> > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> 
> Would it necessarily have been a host bug?  A guest telling the host a
> bad GPA to DMA into would trigger this wouldn't it?

No, because as Andy pointed out, host userspace must already guard against a bad
GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
that is completely bogus.  The shared vs. private behavior just means that when
host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
then that is a host bug; that the bug happened to be exploited by a buggy/malicious
guest doesn't change the fact that the host messed up.
