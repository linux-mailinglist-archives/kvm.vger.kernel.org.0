Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7977365E49
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 19:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhDTROe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 13:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhDTROc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 13:14:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A498AC06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:13:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nk8so7031853pjb.3
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Rx/7pSrdOTjrqYhkD0rnBzZE6qiwPWA0fsq/Ig+gAU=;
        b=qElD0nGptQO4d5U4icvmkxRPze4zkw8T5nITuq2CJ3NAoim/A7H2VCs5KmyfYmgVjP
         Qjlyxn+oTHT03jlEabF8sslzpFRPgJXF0q6cH08Ng0Zs75M4LQMwZEB7yQqEArBSQjn7
         QcBPdULWeGd1CKL/pSbMqc8wY6FAbX529h9WVfl1EVkevAj09dxJnXWAdAiFQUwJwLS1
         YVasQwzrAVDDd4tA9/FJkEfqnGnn39XrbMdFSJRAthEl+IX6pDtcp7sfvPeZ6fF/EwmB
         RXRA0hYu3q0HHarA1T7KQmIaZ91C+cbPKmPvxggjX5ElNLx4bawB9VUzKF5TuKb5/Wtm
         fhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Rx/7pSrdOTjrqYhkD0rnBzZE6qiwPWA0fsq/Ig+gAU=;
        b=uoVG9UO39GH+ICk5YGZtsjb7stJ26TSUrErj5w6bIM9LfmrAody/NR23bufcNgtpGO
         TQJnDLSCiAVF3dlyyK8lmA26TSH+YRO2DlEU12K2WLKyZTylp17Fo9vhbLHKcbQhgoWq
         AwXzq94Ndqvl1Vnhp+s73w/16ARP7UEMORHwoqsobzlf5LxT4iZH9V9je131uc2HaFQ4
         vRuQsb6zxWfYBk7IMcSg+B6ejT4fW1mETsosGowMrbDxzOc1lcKOj+ZUDDlE0duTdpYu
         2aJVXv+GrcwRAICb1UHc0Avrr/tUrGjMH6328rQitASVv7QDMxNKllkn0DPj9Oyw1jgd
         TbuA==
X-Gm-Message-State: AOAM533awhK4cmoTTSPlpqAYQ2aMLszOyl3NKfbqnP7XmbypGzpxcS4I
        tJtozpCC85zP34tykxR0jGpnYg==
X-Google-Smtp-Source: ABdhPJxFoch6bgHpPlK19OfXQhArjeTBWax5ZS4JHCVF4ImqcGbfNd87Wsh3hWG62bOhbKqRAG72qw==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id v10-20020a1709029a0ab02900e6bf008a36mr30106258plp.51.1618938839090;
        Tue, 20 Apr 2021 10:13:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d18sm2871703pjx.46.2021.04.20.10.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 10:13:58 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:13:54 +0000
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
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <YH8L0ihIzL6UB6qD@google.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Kirill A. Shutemov wrote:
> On Mon, Apr 19, 2021 at 08:09:13PM +0000, Sean Christopherson wrote:
> > On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > > The critical question is whether we ever need to translate hva->pfn after
> > > the page is added to the guest private memory. I believe we do, but I
> > > never checked. And that's the reason we need to keep hwpoison entries
> > > around, which encode pfn.
> > 
> > As proposed in the TDX RFC, KVM would "need" the hva->pfn translation if the
> > guest private EPT entry was zapped, e.g. by NUMA balancing (which will fail on
> > the backend).  But in that case, KVM still has the original PFN, the "new"
> > translation becomes a sanity check to make sure that the zapped translation
> > wasn't moved unexpectedly.
> > 
> > Regardless, I don't see what that has to do with kvm_pfn_map.  At some point,
> > gup() has to fault in the page or look at the host PTE value.  For the latter,
> > at least on x86, we can throw info into the PTE itself to tag it as guest-only.
> > No matter what implementation we settle on, I think we've failed if we end up in
> > a situation where the primary MMU has pages it doesn't know are guest-only.
> 
> I try to understand if it's a problem if KVM sees a guest-only PTE, but
> it's for other VM. Like two VM's try to use the same tmpfs file as guest
> memory. We cannot insert the pfn into two TD/SEV guest at once, but can it
> cause other problems? I'm not sure.

For TDX and SNP, "firmware" will prevent assigning the same PFN to multiple VMs.

For SEV and SEV-ES, the PSP (what I'm calling "firmware") will not prevent
assigning the same page to multiple guests.  But the failure mode in that case,
assuming the guests have different ASIDs, is limited to corruption of the guest.

On the other hand, for SEV/SEV-ES it's not invalid to assign the same ASID to
multiple guests (there's an in-flight patch to do exactly that[*]), and sharing
PFNs between guests with the same ASID would also be valid.  In other words, if
we want to enforce PFN association in the kernel, I think the association should
be per-ASID, not per-KVM guest.

So, I don't think we _need_ to rely on the TDX/SNP behavior, but if leveraging
firmware to handle those checks means avoiding additional complexity in the
kernel, then I think it's worth leaning on firmware even if it means SEV/SEV-ES
don't enjoy the same level of robustness.

[*] https://lkml.kernel.org/r/20210408223214.2582277-1-natet@google.com
