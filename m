Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34F3FE171
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346747AbhIARvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346522AbhIARvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 13:51:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF17FC061760
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 10:50:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fs6so114972pjb.4
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 10:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lTCwx671qN0Uv7CtZL+BVS1+Oy6Uwn1k3lSPRkK+jKg=;
        b=tX+iQK/XObeHHie9CEoItYwWrUuxY48SNGKS8OIkVuSOl9Zy8ONZjSy2CselzwLN6U
         fyDvLPYuMEHd2HtKTTBEpeJFwD9IiR/4nv0idT+PmOH6YFqIuelzoQtvb0nTX4PVmdXv
         OWdqauuhaUkvyAW9xaC+yanWAiLb+viasEaEDcErrr4YaU66XQV37GdSUJlrAI18OJ58
         Xf2pXFmsPLt9vio2mK5Noy6PET+oEXr+jLkXY/5X2AQu7JJ++uEMK2w4L6v0f84FrkGP
         aOmqGtD7El0+sCcQxz1LVQjZB3IidTm9OdswbBH+7IPFy1A9z08/jb25AhGGV9cLIDNs
         V6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lTCwx671qN0Uv7CtZL+BVS1+Oy6Uwn1k3lSPRkK+jKg=;
        b=o4DIunEzICmegpJ/+jEa101BKfYI0slb+VpiRZBCBYUtL49fxBw38aN0Mkh/2asXpm
         sMhWDmrYm+S6Fl1qFM4++KBHvzlMgUXq4u7fyrxwOQTz6pr4U9T/DbEy3Yr0N9SoTJPW
         jLtSrw5AadEsZnaZIOTWJCZ1Em5j/q7Yd+Vmf/008ZCDSom8KMeN+8DBkCSgpGKqYrZN
         7cMWDsJvFseBCDFTr0w1fd9IlzLh3GimI5PEq4+2vguIfWmSpg95hO4QYSEBCUYLYC7d
         iHS6Jc7r6CWcq6h2FI6zxeuW3tXfEiQUMFREwrwN64G8MeE3CiBdGLNNcFIe7eoSmSqg
         Q39A==
X-Gm-Message-State: AOAM530mXi61QG2wY+UjEgLwURQVStLYIfF6KZ693t1UbHZ/a33emxvo
        XvsDn9DAyokedVzQBtbJtvAZBg==
X-Google-Smtp-Source: ABdhPJyTBcvoxYT1UazLo75DFYLRiAcTN2BKdr2FfvtOwvNd4cqBc9u77mrXNn/DJzvrSUbkCYr6XQ==
X-Received: by 2002:a17:902:f683:b0:138:fe47:4e47 with SMTP id l3-20020a170902f68300b00138fe474e47mr675191plg.60.1630518617183;
        Wed, 01 Sep 2021 10:50:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o10sm122146pfk.212.2021.09.01.10.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 10:50:16 -0700 (PDT)
Date:   Wed, 1 Sep 2021 17:50:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     jejb@linux.ibm.com, Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <YS+9VHzC0XQF/9NK@google.com>
References: <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
 <a259e10d-39c9-c4a5-0ab4-f42a1b9bfaee@redhat.com>
 <0d6b2a7e22f5e27e03abc21795124ccd66655966.camel@linux.ibm.com>
 <1a4a1548-7e14-c2b4-e210-cc60a2895acd@redhat.com>
 <4b863492fd33dce28a3a61662d649987b7d5066d.camel@linux.ibm.com>
 <214ca837-3102-d6d1-764e-6b4cd1bab368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214ca837-3102-d6d1-764e-6b4cd1bab368@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021, David Hildenbrand wrote:
> > > > Well not necessarily, but it depends how clever we want to get.  If
> > > > you look over on the OVMF/edk2 list, there's a proposal to do guest
> > > > migration via a mirror VM that invokes a co-routine embedded in the
> > > > OVMF binary:
> > > 
> > > Yes, I heard of that. "Interesting" design.
> > 
> > Heh, well what other suggestion do you have?  The problem is there
> > needs to be code somewhere to perform some operations that's trusted by
> > both the guest and the host.  The only element for a confidential VM
> > that has this shared trust is the OVMF firmware, so it seems logical to
> > use it.
> 
> <offtopic>
> 
> Let me put it this way: I worked with another architecture that doesn't
> fault on access of a secure page, but instead automatically exports/encrypts

I thought s390 does fault on insecure accesses to secure pages, and it's the
kernel's fault handler that "automatically" converts the page?  E.g. trap 0x3d
-> do_secure_storage_access() -> arch_make_page_accessible().

> it so it can be swapped. It doesn't send a MCE and kills the host. It
> doesn't require fancy code in the guest firmware to export a page.
> 
> The code runs in the ultravisor -- yes, I'm talking about s390x. Now, I am
> not an expert on all of the glory details of TDX, SEV, ... to say which
> attack surface they introduced with that design, and if it can't be
> mitigated. I can only assume that there are real reasons (e.g., supporting
> an ultravisor is problematic, patents? ;) ) why x86-64 is different.
>
> So whenever I see something really complicated to work around such issues,
> it feels to me like a hardware/platform limitation is making our life hard
> and forces us to come up with such "interesting" designs.

Oh, 100% agree, the TDX "limitation" of poisoning cache line and leaving a land
mine to trip over is absolutely abhorrent.  SEV-ES and SEV aren't much better in
that they happily corrupt guest memory.  I am quite jealous of s390 behavior of
simply faulting on the actual access.

SEV-SNP does fault on the access and could do something similar to s390, but I'm
not totally convinced that's actually desirable as it has ramifications with
respect to debugging host and/or guest.  But it'd be nice to have the option...

> Sure, it's logical in this context, but it feels like "The house doesn't

Heh, for some definitions of "logical".

> have a door, so I'll have to climb through the window.". It gets the job
> done but isn't ideally what you'd want to have. If you understand what I am
> trying to say :)
> 
> </offtopic>
