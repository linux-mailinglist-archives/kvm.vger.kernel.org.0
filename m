Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49FD3CFFB1
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhGTQAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 12:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbhGTP7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 11:59:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3041C061767
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 09:40:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p9so13993298pjl.3
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 09:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ll0RiUGMAmvrONO+nzQxFqpEs/97py7ihZNr5b1dhP0=;
        b=PEZtiQtiWMdi7vFzMSbRev47alSkv5RYM7hOiBpVFjrIkQB6RVc6YkKqKcOefW/fKP
         Y42zRAQKBib8tKzc4/Oeif2decwbJFIYi9dJXDc6MugQE+ryuq7DQHauE/2g/akaFlnX
         kYfS9YpWsG5CTHYxQnlED4GDEP4F1teLpG4M0cHXDCdsJMdbMjc9/eKJKYEDF5Vqq3aU
         5oSXV+xP6qAX91AZNaByWJKOQ7OCNnRasAVpNbY2ZV+EABYACD7yCw2YM92GJ1aTvl6U
         ip/9lfrG9+yIYkquVRRv+8hW4RYPu57N4/E0TZNqFzlUQchnuVkuSktjys7zqFmAJoDs
         gJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ll0RiUGMAmvrONO+nzQxFqpEs/97py7ihZNr5b1dhP0=;
        b=dbFYfgdJehPsn2KeC61MAdkza2EruITY0ezzHfk9OXQE77oqH35CS0lAILwZf5urwX
         kRuQIf3GojBo7nOFsg8ZcRuP9JbAhQPvH5skGz0hkl1Wiv0cHsuYPy6PSFMiVhIjXq+C
         nMGkk2rHZCTUihR1PBtVguEVeL1tWmxE2gUTdTIAnvdNQQZruT/At3otn5x4b0KtLxnw
         l8JtUsmiPng03d+51A8ZFLjNxU7i+0r2jWVtFYyq1ygamUUjSDs1nMAo4IXdNpPnT5mF
         CTpSgYJKYFgg/vaARfhmiKESAIr+D6qsJtAjctGOZKyFeQTvjwpNvo682jygiY4VHPrO
         jQmw==
X-Gm-Message-State: AOAM533g13kjBUB3XykkdXDpiiWPGDH0+W6Yam0q4QR6WrXez5GEPevG
        TNIUtg/nQiwZ/epXZ45u/RC5rQ==
X-Google-Smtp-Source: ABdhPJyroP8tgh93DCfc3z5U9V+qQ+qSioQG+b9tGScCAvFrwti9nKvzMBMeyynwyPM0BW+TNCCkEg==
X-Received: by 2002:a17:90a:df04:: with SMTP id gp4mr36464585pjb.164.1626799224059;
        Tue, 20 Jul 2021 09:40:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10sm25322836pfg.160.2021.07.20.09.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 09:40:23 -0700 (PDT)
Date:   Tue, 20 Jul 2021 16:40:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 25/40] KVM: SVM: Reclaim the guest pages
 when SEV-SNP VM terminates
Message-ID: <YPb8c5qlZ6JuDR05@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-26-brijesh.singh@amd.com>
 <YPHnb5pW9IoTcwWU@google.com>
 <2711d9f9-21a0-7baa-d0ff-2c0f69ca6949@amd.com>
 <YPIoaoDCjNVzn2ZM@google.com>
 <e1cc1e21-e7b7-5930-1c01-8f4bb6e43b3a@amd.com>
 <YPWz6YwjDZcla5/+@google.com>
 <912c929c-06ba-a391-36bb-050384907d81@amd.com>
 <YPXMas+9O1Y5910b@google.com>
 <96154428-4c18-9e5f-3742-d0446a8d9848@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96154428-4c18-9e5f-3742-d0446a8d9848@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021, Brijesh Singh wrote:
> 
> On 7/19/21 2:03 PM, Sean Christopherson wrote:
> > On Mon, Jul 19, 2021, Brijesh Singh wrote:
> > Ah, not firmwrare, gotcha.  But we can still use a helper, e.g. an inner
> > double-underscore helper, __rmp_make_private().
> 
> In that case we are basically passing the all the fields defined in the
> 'struct rmpupdate' as individual arguments.

Yes, but (a) not _all_ fields, (b) it would allow hiding "struct rmpupdate", and
(c) this is much friendlier to readers:

	__rmp_make_private(pfn, gpa, PG_LEVEL_4K, svm->asid, true);

than:

	rmpupdate(&rmpupdate);

For the former, I can see in a single line of code that KVM is creating a 4k
private, immutable guest page.  With the latter, I need to go hunt down all code
that modifies rmpupdate to understand what the code is doing.

> How about something like this:
> 
> * core kernel exports the rmpupdate()
> * the include/linux/sev.h header file defines the helper functions
> 
>   int rmp_make_private(u64 pfn, u64 gpa, int psize, int asid)

I think we'll want s/psize/level, i.e. make it more obvious clear that the input
is PG_LEVEL_*.  
