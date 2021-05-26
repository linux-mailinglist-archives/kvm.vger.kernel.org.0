Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D33392117
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 21:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhEZTsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 15:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhEZTsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 15:48:31 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB86AC06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 12:46:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t193so1842899pgb.4
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 12:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hEQ3MdXmpdNmcX6sa1MKz2lUFHPHmPostz9Pp0Yt+54=;
        b=b1ledajAYuzSP2VsYjLXXA+yLdhz9jMTPLKR8jN1BmCm06HetxB4+K+9y1UkLgPGJU
         8FJJevRA+tNRkxZEmKTbGAEI201rzRZoz5+VL7ftvW0M84XkhdamXP09FeQBf0gDMQGU
         0k9I1ORp07R5N8pLA1QDajOqd6fOK0a7s0zKXZ7MRZknul8dbZAVK3KNwxMHmNCQfBLY
         jJ3jy8WK2GAgyehfuQVJdPflw5Uv2kQBba7LRL5vNSkwHjO/TeZhiuXKJEuo7EZFqXnP
         6CqLhRB4GytEUeiguuk8nexR6qzpY5MWCLAB7GLELwSWrKeTRKKlEoIKE4X5J/7EgIkv
         hv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hEQ3MdXmpdNmcX6sa1MKz2lUFHPHmPostz9Pp0Yt+54=;
        b=DAoaAwVAHOT+kxSx1y2TlaODSjtC/Akp+b22YmvzC9Gl3/2vnGhpbfImDvO5AlpAx5
         pVqZvtR2X7UOxztZieFNPV6NK4DBPYaV3SY1yMCej/DGBA4wvcAg9VjXX1gZPf5HaJhB
         hrv5TQp+AM2u3dhw1UlGDgbVFh8TLVZLy0lZyQDhuRLVTXNUk1yHwRvij4n9lqQ5hb+J
         o4VeU0f0KU6RYZxFh0ylfQqDHS+dpnuH0J+IZExsyOWMACT74ya4IC8/g1rSgYRWA2JS
         tmf6ifL38n/tttEIhaMRL4WH8yyi9LOhjOWKgkWaAzVYUoBibWS0DLC7xRFGbuWPFv+E
         aU5g==
X-Gm-Message-State: AOAM530dUm/kzsAsH1wo8xwAI83xl2Bgj1kSeC7w48xX5Hog+RSNaX2i
        czj2pJir3srBe9YVJsxxsYpGSg==
X-Google-Smtp-Source: ABdhPJwBXUXILPsFBDFo9CFR/JDpKVm78Qh7x+mpCE2hRYo8JoIxtQJXcXaDoL8EHmqAouWcIEOiWQ==
X-Received: by 2002:a62:cec9:0:b029:2e3:9125:c280 with SMTP id y192-20020a62cec90000b02902e39125c280mr65079pfg.11.1622058417033;
        Wed, 26 May 2021 12:46:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id f9sm46220pfc.42.2021.05.26.12.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 12:46:56 -0700 (PDT)
Date:   Wed, 26 May 2021 19:46:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <YK6lrHeaeUZvHMJC@google.com>
References: <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521123148.a3t4uh4iezm6ax47@box>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021, Kirill A. Shutemov wrote:
> Hi Sean,
> 
> The core patch of the approach we've discussed before is below. It
> introduce a new page type with the required semantics.
> 
> The full patchset can be found here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-guest-only
> 
> but only the patch below is relevant for TDX. QEMU patch is attached.

Can you post the whole series?  The KVM behavior and usage of FOLL_GUEST is very
relevant to TDX.

> CONFIG_HAVE_KVM_PROTECTED_MEMORY has to be changed to what is appropriate
> for TDX and FOLL_GUEST has to be used in hva_to_pfn_slow() when running
> TDX guest.

This behavior in particular is relevant; KVM should provide FOLL_GUEST iff the
access is private or the VM type doesn't differentiate between private and
shared.

> When page get inserted into private sept we must make sure it is
> PageGuest() or SIGBUS otherwise.

More KVM feedback :-)

Ideally, KVM will synchronously exit to userspace with detailed information on
the bad behavior, not do SIGBUS.  Hopefully that infrastructure will be in place
sooner than later.

https://lkml.kernel.org/r/YKxJLcg/WomPE422@google.com

> Inserting PageGuest() into shared is fine, but the page will not be accessible
> from userspace.

Even if it can be functionally fine, I don't think we want to allow KVM to map
PageGuest() as shared memory.  The only reason to map memory shared is to share
it with something, e.g. the host, that doesn't have access to private memory, so
I can't envision a use case.

On the KVM side, it's trivially easy to omit FOLL_GUEST for shared memory, while
always passing FOLL_GUEST would require manually zapping.  Manual zapping isn't
a big deal, but I do think it can be avoided if userspace must either remap the
hva or define a new KVM memslot (new gpa->hva), both of which will automatically
zap any existing translations.

Aha, thought of a concrete problem.  If KVM maps PageGuest() into shared memory,
then KVM must ensure that the page is not mapped private via a different hva/gpa,
and is not mapped _any_ other guest because the TDX-Module's 1:1 PFN:TD+GPA
enforcement only applies to private memory.  The explicit "VM_WRITE | VM_SHARED"
requirement below makes me think this wouldn't be prevented.

Oh, and the other nicety is that I think it would avoid having to explicitly
handle PageGuest() memory that is being accessed from kernel/KVM, i.e. if all
memory exposed to KVM must be !PageGuest(), then it is also eligible for
copy_{to,from}_user().

> Any feedback is welcome.
> 
> -------------------------------8<-------------------------------------------
> 
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Fri, 16 Apr 2021 01:30:48 +0300
> Subject: [PATCH] mm: Introduce guest-only pages
> 
> PageGuest() pages are only allowed to be used as guest memory. Userspace
> is not allowed read from or write to such pages.
> 
> On page fault, PageGuest() pages produce PROT_NONE page table entries.
> Read or write there will trigger SIGBUS. Access to such pages via
> syscall leads to -EIO.
> 
> The new mprotect(2) flag PROT_GUEST translates to VM_GUEST. Any page
> fault to VM_GUEST VMA produces PageGuest() page.
> 
> Only shared tmpfs/shmem mappings are supported.

Is limiting this to tmpfs/shmem only for the PoC/RFC, or is it also expected to
be the long-term behavior?

> GUP normally fails on such pages. KVM will use the new FOLL_GUEST flag
> to access them.
