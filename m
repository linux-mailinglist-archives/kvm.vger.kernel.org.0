Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A753B42C78A
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhJMR0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbhJMR0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:26:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD9AC061749
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 10:24:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so4947359pjb.5
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 10:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=znXxY8k0yLhwBo4efWALoeW3xXIEX4hKO/JqS3b4Dyg=;
        b=Z6YEV8Cobp8BBjd4T6EW5woNqLhuBZaG7SxbSekXJNyXJWRkz1azJSTu3gOp4dXKdO
         4FBHrg/Domvx507fqMSOgFtt/Xv69x+Y84bt8auhTLLYQhJZOlaTd3wQmym3OaJKgtH+
         WqkA5fvqnwNY6A6nZAFtPRp/4kAM3o0TS0Dn9QUKQzIlVAX0UqpyATB3bzmxjBik9hFC
         +KRZ3lxRKUFEnm2cWjd/yV1GyemnKu6e+fItC343CgRoKyestVhd5nxdLXR4grlSVLu4
         l1EYljp0lpYLbg7qvECY8qrKHFYNObgOsbE8Hs5p/b6NJTjhEWVJ3wJT6EiFnMG5c2bo
         vfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=znXxY8k0yLhwBo4efWALoeW3xXIEX4hKO/JqS3b4Dyg=;
        b=Lv4KxW+X1QIUuP4CM6onwMmhELJU48DW4CH4VodFX0JqFlaP/X+xSJmWwPZL3ItV1v
         a+27j/OzHuPyO2jfIKFAkVgbSNTAMN++1Wp6Zb/OO/R7BoLpGkVhbfXlB1kpKDLyoZi0
         ZhLxqxW0HOe7MjGs8ZjphEjCfKuggT1jHEzdYJYQBTf8yNZ3njzJVu9oq9gVJnuukgh5
         nwRDzr2Dj2oKIXN1SZqXZv6O3+mAiJ99xdX/dWtgim02pblJ8n0w1+5EhAWwHQfCCyXO
         +XQaNkx5esZ0nUq9EIfhzXmHKCfYLXPUeI+VNFpUbZQfQwepSBue/ub/wG0ilmic/7rQ
         S28A==
X-Gm-Message-State: AOAM532BeRFJqNekHpv2y/hmDWaqC2KyoAvC8gDfQJJdfaeOMGnC39uv
        pvnTCC2nKWivQUTJgYGm4wK0KRK98TDpgg==
X-Google-Smtp-Source: ABdhPJwaiA5rH696JEVs1LyaPKo4rf9o9kfJpWWgIN+FdZR7N051iOYsTHra9i4SBRSPNHgi4Pjmnw==
X-Received: by 2002:a17:90b:782:: with SMTP id l2mr618878pjz.190.1634145887734;
        Wed, 13 Oct 2021 10:24:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 14sm133224pfu.29.2021.10.13.10.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 10:24:47 -0700 (PDT)
Date:   Wed, 13 Oct 2021 17:24:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <YWcWW7eikkWSmCkH@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-38-brijesh.singh@amd.com>
 <YWYCrQX4ZzwUVZCe@google.com>
 <a677423e-fa24-5b6a-785f-4cbdf0ebee37@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a677423e-fa24-5b6a-785f-4cbdf0ebee37@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Brijesh Singh wrote:
> > The more I look at this, the more strongly I feel that private <=> shared conversions
> > belong in the MMU, and that KVM's SPTEs should be the single source of truth for
> > shared vs. private.  E.g. add a SPTE_TDP_PRIVATE_MASK in the software available bits.
> > I believe the only hiccup is the snafu where not zapping _all_ SPTEs on memslot
> > deletion breaks QEMU+VFIO+GPU, i.e. KVM would lose its canonical info on unrelated
> > memslot deletion.
> >
> > But that is a solvable problem.  Ideally the bug, wherever it is, would be root
> > caused and fixed.  I believe Peter (and Marc?) is going to work on reproducing
> > the bug.
> We have been also setting up VM with Qemu + VFIO + GPU usecase to repro
> the bug on AMD HW and so far we no luck in reproducing it. Will continue
> stressing the system to recreate it. Lets hope that Peter (and Marc) can
> easily recreate on Intel HW so that we can work towards fixing it.

Are you trying on a modern kernel?  If so, double check that nx_huge_pages is off,
turning that on caused the bug to disappear.  It should be off for AMD systems,
but it's worth checking.

> >> +		if (!rc) {
> >> +			/*
> >> +			 * This may happen if another vCPU unmapped the page
> >> +			 * before we acquire the lock. Retry the PSC.
> >> +			 */
> >> +			write_unlock(&kvm->mmu_lock);
> >> +			return 0;
> > How will the caller (guest?) know to retry the PSC if KVM returns "success"?
> 
> If a guest is adhering to the GHCB spec then it will see that hypervisor
> has not processed all the entry and it should retry the PSC.

But AFAICT that information isn't passed to the guest.  Even in this single-page
MSR-based case, the caller will say "all good" on a return of 0.

The "full" path is more obvious, as the caller clearly continues to process
entries unless there's an actual failure.

+       for (; cur <= end; cur++) {
+               entry = &info->entries[cur];
+               gpa = gfn_to_gpa(entry->gfn);
+               level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
+               op = entry->operation;
+
+               if (!IS_ALIGNED(gpa, page_level_size(level))) {
+                       rc = PSC_INVALID_ENTRY;
+                       goto out;
+               }
+
+               rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
+               if (rc)
+                       goto out;
+       }
