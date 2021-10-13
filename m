Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADF42CAC4
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 22:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhJMUS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 16:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhJMUS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 16:18:57 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D84C061749
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 13:16:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o133so3459762pfg.7
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 13:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5yhRH7ZIJi4Rd6WTmMMqH8HhEZQLNXc5e/9FRtAhMOI=;
        b=RPhDaWnpurS4y7tVtRZqV2m7TT/CvyExa80zu6eKOfi+Uxq6OHkuPWKuzBu6usovry
         1r5rS6U2o3QdPYKrrldUS3PG46VJM5XJ2jtd33eGezktpZLITFB62sVzB1xF+QWmQaYs
         4lw6stQbe55qE7qBX+H95iI+3MJ7iWrKq5aThQoS+CDOFbq9aHteipRRBoAwV4uM/anD
         EZ86zFuK/mnrh84e5NkEyIliobHoUE58WGdSy5se484Rd0wh2bLKfWmvsE6lHQ/99GMd
         jfvaDnPWztORPtxmDG6KJGEGfMa2WvnYpQvEZrq/5p6G0eQupghkiidJ69V+q6DshQJJ
         eHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5yhRH7ZIJi4Rd6WTmMMqH8HhEZQLNXc5e/9FRtAhMOI=;
        b=pH0WRqGMD/8qfU7BVVutwUgkhJDFY4Y8FTn89c2ZXT22GNapg/QCSMbSl17ZyB+4qW
         0lu/COxwuCw3KpGW+hfJi4g4poMTAhNDgCRyfns0S2RCqFFHP2n4zxiULrfHVxCI/mJO
         48WcxifTVxggGKyoUafs0mSv0EZFSjB5O7Ro1Ag+nrbJWw9jctEXCwXWVvYy+dqsshhD
         Lj7Ok+tDwYSAaxYh4SoexTKypPUd7cl9lZiGWMzK6p71tH+HZacTucEeT6K/5ROEX9F8
         RZnRkpuSVnSwshUhpR+qLRiKc2HW0SZeaMFx07ji1oCNjwg/In3O2zDlyFQ56Pdz73h/
         1n/g==
X-Gm-Message-State: AOAM532k8b69i3kHMu/vhk/q+mt9MBxlWo7aeismglu+Ra13npM2zKi/
        B3aqeKJplVOExOh/fq1z9Vx2xA==
X-Google-Smtp-Source: ABdhPJydTqRd+TbelV+KMJzjHnbhI2cqYnqRbRh8getW270LAhsuC1uWiMUAmXUve3gaAGCtai4VyQ==
X-Received: by 2002:a63:7c5b:: with SMTP id l27mr393227pgn.227.1634156213632;
        Wed, 13 Oct 2021 13:16:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3sm334520pjg.7.2021.10.13.13.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 13:16:53 -0700 (PDT)
Date:   Wed, 13 Oct 2021 20:16:49 +0000
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
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <YWc+sRwHxEmcZZxB@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWYm/Gw8PbaAKBF0@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
> > When SEV-SNP is enabled in the guest VM, the guest memory pages can
> > either be a private or shared. A write from the hypervisor goes through
> > the RMP checks. If hardware sees that hypervisor is attempting to write
> > to a guest private page, then it triggers an RMP violation #PF.
> > 
> > To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
> > used to verify that its safe to map a given guest page. Use the SRCU to
> > protect against the page state change for existing mapped pages.
> 
> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
> forces it to wait for existing maps to go away, but it doesn't prevent new maps
> from being created while the actual RMP updates are in-flight.  Most telling is
> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.

Argh, another goof on my part.  Rereading prior feedback, I see that I loosely
suggested SRCU as a possible solution.  That was a bad, bad suggestion.  I think
(hope) I made it offhand without really thinking it through.  SRCU can't work in
this case, because the whole premise of Read-Copy-Update is that there can be
multiple copies of the data.  That simply can't be true for the RMP as hardware
operates on a single table.

In the future, please don't hesitate to push back on and/or question suggestions,
especially those that are made without concrete examples, i.e. are likely off the
cuff.  My goal isn't to set you up for failure :-/
