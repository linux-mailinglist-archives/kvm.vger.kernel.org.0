Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2073968A0
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhEaUIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhEaUIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 16:08:45 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9F9C061574
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 13:07:04 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id bn21so9025494ljb.1
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 13:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2PYA1pYVKDAI4+09LVa/AjMjJk2rf6grA0gDFLIFu60=;
        b=jMGB9HVWu7We5YKyc81ESVoYoaXoMM9Q5VcAD9ur8rFnJFXGQm8l3uQzQpe1w75++g
         EGGRMbNCSB+pUHPUaToaTLfJM9PSx/lfkp1TPuCum3/5XAfyo8vUnThe7wR/PSxhuNjX
         PLdCe68JHlRwsBMVUV3Yk91Q+xLlWtAed+KQNGnqrFnCqaOSL9WXfhm9HPl89rB9jgBT
         lXNrJVfdnevcf+ZuYu91HI/Oj90bR3leOdHh3fdpECSOLnwVcyXGSf5uEXwZlTvzQz5t
         D0DPjQKZY+R6QDOnDshhaidiSAo3n1Kal6Afo3rBJsdiDsqtiwCAsEyLQy5Cmiku20XH
         G6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PYA1pYVKDAI4+09LVa/AjMjJk2rf6grA0gDFLIFu60=;
        b=lry0eVsE7BOriaeZQup3Y+FrEv3+lLxJ6TUberaSDYYxnPfbts2eTtZr2ZWk8ghM1U
         qacuVIhf3CDfTiBs4ViPK8IYoC9ALxjeNzbu0Jh/L22TTs7Q5GgfpZx8N8/Yia5J6YVa
         zlFNeG2deHM2RPZtZ4lx6cF4HfhdH4UkYGlciB3VUqWkiya5v4PlD+cCnrSf1HF6+ZbG
         xFNs8QiBpM+qY4RqNfmde3SVbn0DfdVzNjBKc6F/dJ/OPCRS+QW4sOXIZXgUMQyGIobE
         vAMnkkcPYzk74ELpUv0W5XhD05OZpyzUEYHCLki1oyAnIF2fEfcCNrA4XOMhPRNjNrCK
         wNgQ==
X-Gm-Message-State: AOAM533iamhdR466a2hMtY2ETEB3zi/UW+QTnKKb4l94kkct4ytKTZgz
        vAH+wEheoqbaCQo02agDV6VIXQ==
X-Google-Smtp-Source: ABdhPJxMTxMJUUNo0WMO/JnVrApwkxYHhCSvQj5H71CpvqX3vnANi8jtHW+c4iUXlu8zYG8p9cfaFQ==
X-Received: by 2002:a2e:7605:: with SMTP id r5mr18025459ljc.414.1622491623271;
        Mon, 31 May 2021 13:07:03 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id f4sm1440832lfu.133.2021.05.31.13.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 13:07:02 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 76C441027C1; Mon, 31 May 2021 23:07:12 +0300 (+03)
Date:   Mon, 31 May 2021 23:07:12 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
References: <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <YK6lrHeaeUZvHMJC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK6lrHeaeUZvHMJC@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 07:46:52PM +0000, Sean Christopherson wrote:
> On Fri, May 21, 2021, Kirill A. Shutemov wrote:
> > Hi Sean,
> > 
> > The core patch of the approach we've discussed before is below. It
> > introduce a new page type with the required semantics.
> > 
> > The full patchset can be found here:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-guest-only
> > 
> > but only the patch below is relevant for TDX. QEMU patch is attached.
> 
> Can you post the whole series?

I hoped to get it posted as part of TDX host enabling.

As it is the feature is incomplete for pure KVM. I didn't implement on KVM
side checks that provided by TDX module/hardware, so nothing prevents the
same page to be added to multiple KVM instances.

> The KVM behavior and usage of FOLL_GUEST is very relevant to TDX.

The patch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/commit/?h=kvm-unmapped-guest-only&id=2cd6c2c20528696a46a2a59383ca81638bf856b5

> > CONFIG_HAVE_KVM_PROTECTED_MEMORY has to be changed to what is appropriate
> > for TDX and FOLL_GUEST has to be used in hva_to_pfn_slow() when running
> > TDX guest.
> 
> This behavior in particular is relevant; KVM should provide FOLL_GUEST iff the
> access is private or the VM type doesn't differentiate between private and
> shared.

I added FOL_GUEST if the KVM instance has the feature enabled.

On top of that TDX-specific code has to check that the page is in fact
PageGuest() before inserting it into private SEPT.

The scheme makes sure that user-accessible memory cannot be not added as
private to TD.

> > When page get inserted into private sept we must make sure it is
> > PageGuest() or SIGBUS otherwise.
> 
> More KVM feedback :-)
> 
> Ideally, KVM will synchronously exit to userspace with detailed information on
> the bad behavior, not do SIGBUS.  Hopefully that infrastructure will be in place
> sooner than later.
> 
> https://lkml.kernel.org/r/YKxJLcg/WomPE422@google.com

My experiments are still v5.11, but I can rebase to whatever needed once
the infrastructure hits upstream.

> > Inserting PageGuest() into shared is fine, but the page will not be accessible
> > from userspace.
> 
> Even if it can be functionally fine, I don't think we want to allow KVM to map
> PageGuest() as shared memory.  The only reason to map memory shared is to share
> it with something, e.g. the host, that doesn't have access to private memory, so
> I can't envision a use case.
> 
> On the KVM side, it's trivially easy to omit FOLL_GUEST for shared memory, while
> always passing FOLL_GUEST would require manually zapping.  Manual zapping isn't
> a big deal, but I do think it can be avoided if userspace must either remap the
> hva or define a new KVM memslot (new gpa->hva), both of which will automatically
> zap any existing translations.
> 
> Aha, thought of a concrete problem.  If KVM maps PageGuest() into shared memory,
> then KVM must ensure that the page is not mapped private via a different hva/gpa,
> and is not mapped _any_ other guest because the TDX-Module's 1:1 PFN:TD+GPA
> enforcement only applies to private memory.  The explicit "VM_WRITE | VM_SHARED"
> requirement below makes me think this wouldn't be prevented.

Hm. I didn't realize that TDX module doesn't prevent the same page to be
used as shared and private at the same time.

Omitting FOLL_GUEST for shared memory doesn't look like a right approach.
IIUC, it would require the kernel to track what memory is share and what
private, which defeat the purpose of the rework. I would rather enforce
!PageGuest() when share SEPT is populated in addition to enforcing
PageGuest() fro private SEPT.

Do you see any problems with this?

> Oh, and the other nicety is that I think it would avoid having to explicitly
> handle PageGuest() memory that is being accessed from kernel/KVM, i.e. if all
> memory exposed to KVM must be !PageGuest(), then it is also eligible for
> copy_{to,from}_user().

copy_{to,from}_user() enforce by setting PTE entries to PROT_NONE.
Or do I miss your point?

> 
> > Any feedback is welcome.
> > 
> > -------------------------------8<-------------------------------------------
> > 
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Date: Fri, 16 Apr 2021 01:30:48 +0300
> > Subject: [PATCH] mm: Introduce guest-only pages
> > 
> > PageGuest() pages are only allowed to be used as guest memory. Userspace
> > is not allowed read from or write to such pages.
> > 
> > On page fault, PageGuest() pages produce PROT_NONE page table entries.
> > Read or write there will trigger SIGBUS. Access to such pages via
> > syscall leads to -EIO.
> > 
> > The new mprotect(2) flag PROT_GUEST translates to VM_GUEST. Any page
> > fault to VM_GUEST VMA produces PageGuest() page.
> > 
> > Only shared tmpfs/shmem mappings are supported.
> 
> Is limiting this to tmpfs/shmem only for the PoC/RFC, or is it also expected to
> be the long-term behavior?

I expect it to be enough to cover all relevant cases, no?

Note that MAP_ANONYMOUS|MAP_SHARED also fits here.

-- 
 Kirill A. Shutemov
