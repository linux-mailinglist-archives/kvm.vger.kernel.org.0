Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7DD44F492
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 19:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhKMShv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 13:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhKMShu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 13:37:50 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C078C061767
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 10:34:57 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q126so10851047pgq.13
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 10:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zSxj8eRX0cnZYbcOeH01JUaZh5KPAX40UEWt0+2IJiM=;
        b=NGgVBK0eIHprea6mvLCk+5HiStmbJEiIRPJQRX+o5aC3tSlJkXN3kamK5bFgym//aa
         6KOd4p512Oy5/fNf3MbduQ39nKhukOr7CCnKpuyi3YhCyWaEAc6Dd2TIM9s0HuaItkbq
         vNfddajdmOPiGl0PyNKqY2hon4hYsuQHJvhuqfG5uxdLPfAW6rOrZBLLlaSWlNhQss1q
         BCI7DLCqDKJv+wkROMwzJQ+xn2NZF6njWm8eA0hhyzjuuElnSrWIsaN92o+K/j7sRM3v
         bcz/TnaZabI69pok77atryvFxVbqUynR3hethfIzf4yQMntzJm86GsFwEMwKmoogd9Em
         tdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zSxj8eRX0cnZYbcOeH01JUaZh5KPAX40UEWt0+2IJiM=;
        b=dIWAB0HcVfHn/c161g9pqCB0LpgTxSiGewHxRIYntId3ej85PK4Tk9nRh2Et5pXGLc
         +piiS0ajmpfS1/kZBO/z58T8rpr25TRRFIuMIuQFkonK/OfjuKGzPv/9vfDPiPHB1O4G
         QP9zBH3BE76KknyMw6MzKO+N8JZltblJWcmBHsbJaavVHEev8+2PHAB3U8eY1cng7m0Y
         49D/md8a8t+O3ipvy+kKR1wkYzFk8ILTHP48PwxV7j9tvAmaBkYGqYzTnS3DdMvWlk90
         zfUFREZDKEuK/V63ZxgGc6bA/wI+a8YrFj8aKazb9iM1c/hTi2iK4nTns5RoWY4ezB2G
         5dLw==
X-Gm-Message-State: AOAM531puA2nQNgcMOxn86RJx4CXA3qFSZSAUUJSzGcCvWmDCsWi1ii8
        /EkDA9X9A+4buSAPKt21/puqRg==
X-Google-Smtp-Source: ABdhPJxeDdCpGqvSMmznYnDhqmjUQVZ7YRfHUv6xQxIKfIgqzs5xPqbn0hQnNT4ChktEWJKfOne+lQ==
X-Received: by 2002:a63:86c1:: with SMTP id x184mr14326986pgd.469.1636828496852;
        Sat, 13 Nov 2021 10:34:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ml24sm8101994pjb.16.2021.11.13.10.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:34:56 -0800 (PST)
Date:   Sat, 13 Nov 2021 18:34:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
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
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZAFTBXtC/yS7xtq@google.com>
References: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic>
 <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <YY8AJnMo9nh3tyPB@google.com>
 <CAA03e5G=fY7_qESCuoHW3_VdVbDWekqQxmvLPzWNepBqJjyCXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5G=fY7_qESCuoHW3_VdVbDWekqQxmvLPzWNepBqJjyCXg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Marc Orr wrote:
> > > > If *it* is the host kernel, then you probably shouldn't do that -
> > > > otherwise you just killed the host kernel on which all those guests are
> > > > running.
> > >
> > > I agree, it seems better to terminate the single guest with an issue.
> > > Rather than killing the host (and therefore all guests). So I'd
> > > suggest even in this case we do the 'convert to shared' approach or
> > > just outright terminate the guest.
> > >
> > > Are there already examples in KVM of a KVM bug in servicing a VM's
> > > request results in a BUG/panic/oops? That seems not ideal ever.
> >
> > Plenty of examples.  kvm_spurious_fault() is the obvious one.  Any NULL pointer
> > deref will lead to a BUG, etc...  And it's not just KVM, e.g. it's possible, if
> > unlikely, for the core kernel to run into guest private memory (e.g. if the kernel
> > botches an RMP change), and if that happens there's no guarantee that the kernel
> > can recover.
> >
> > I fully agree that ideally KVM would have a better sense of self-preservation,
> > but IMO that's an orthogonal discussion.
> 
> I don't think we should treat the possibility of crashing the host
> with live VMs nonchalantly. It's a big deal. Doing so has big
> implications on the probability that any cloud vendor wil bee able to
> deploy this code to production. And aren't cloud vendors one of the
> main use cases for all of this confidential compute stuff? I'm
> honestly surprised that so many people are OK with crashing the host.

I'm not treating it nonchalantly, merely acknowledging that (a) some flavors of kernel
bugs (or hardware issues!) are inherently fatal to the system, and (b) crashing the
host may be preferable to continuing on in certain cases, e.g. if continuing on has a
high probablity of corrupting guest data.
