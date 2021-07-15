Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B03CAEDF
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 00:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhGOWEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 18:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhGOWEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 18:04:31 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14460C061762
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 15:01:38 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id o201so6878764pfd.1
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9jvEc/h/THBeTUkwPAoRSgqYhPmWM3TSUH2ndN0LRm8=;
        b=rwIKgnVQb/lhYzggOkvchhxuONYzKssGf9H99HCKM5VwPfQcCyTjDypbxAHMiqjIaR
         TLjC2hDTINMJDxfyoOgBZwe58jCmiiju7Fbk3PdIKg5RKqU5K85i5GDNPyxx6aOi9uih
         bawTV2dwRQ4S0brAex48X2epI7iCvjKbcNBdZyLCQsog/dA0SZDDBMNhQVJUTbY95lHB
         71Pcc7schfd9er9IutSMfXZjuiblOE7/ZpyWo1V2uVElZzpqq8gpujPY2jPB7USQJTVv
         xo64pQN6e/UTV4EzY2AYHHsj18yiml6GevIFWW9Id9f7y4urBKkOmkmfd9EwiOPFf1gL
         VfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9jvEc/h/THBeTUkwPAoRSgqYhPmWM3TSUH2ndN0LRm8=;
        b=QpNAn6bHx7evoixYBnd8qqgAB5FcQQLmLNbUzwLYKBfIYm18c1UjMHrhe6b/3G4DlP
         /JgpCkMRNil6LFSaN3iHqC6jI/ox2AfhEZwSQqgTSvx/TAIMVmBnMCLPt+ep34XtumCm
         rsbVs9+8zvmy0IfA8967iPTRMz2F0kZmpwjWYFppMLBhkahcbLigoBjHhB21i08aXETC
         U42rLZljXd544nCnFtRrC0nV4Dq6hJdsxOiKg6OYn3m8o8tAI2uhNyCqQLxMrRsU5n+B
         qVexZ1hkiP8vaSQXPnfKGakoqy6GjlKLMlKwd0ZVScv0RAzpEzuRjfIaekRkQvRaSd27
         feTQ==
X-Gm-Message-State: AOAM531nj3b+L0K/sq27SmcAoDG/apkWV4KRNP8212D1tm2lJ1iR0ddM
        mnCQw1/WtRduWD9lyBWQlTXNLQ==
X-Google-Smtp-Source: ABdhPJzAKUiKYrVRt+O0swD9fmSDNiqt4JwMSVJBx9f2RIAc2POXqS8BXzD7wqEcF4PklBBImUFUfg==
X-Received: by 2002:a62:1d86:0:b029:32a:311a:9595 with SMTP id d128-20020a621d860000b029032a311a9595mr6841892pfd.74.1626386497357;
        Thu, 15 Jul 2021 15:01:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r9sm9731898pjf.52.2021.07.15.15.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 15:01:36 -0700 (PDT)
Date:   Thu, 15 Jul 2021 22:01:33 +0000
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
Subject: Re: [PATCH Part2 RFC v4 07/40] x86/sev: Split the physmap when
 adding the page in RMP table
Message-ID: <YPCwPd2OzbBPs9DH@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-8-brijesh.singh@amd.com>
 <YO9kP1v0TAFXISHD@google.com>
 <d486a008-8340-66b0-9667-11c8a50974e4@amd.com>
 <YPB1n0+G+0EoyEvE@google.com>
 <41f83ddf-a8a5-daf3-dc77-15fc164f77c6@amd.com>
 <YPCA0A+Z3RKfdsa3@google.com>
 <8da808d6-162f-bbaf-fa15-683f8636694f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8da808d6-162f-bbaf-fa15-683f8636694f@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021, Brijesh Singh wrote:
> 
> 
> On 7/15/21 1:39 PM, Sean Christopherson wrote:
> > On Thu, Jul 15, 2021, Brijesh Singh wrote:
> > > The memfd_secrets uses the set_direct_map_{invalid,default}_noflush() and it
> > > is designed to remove/add the present bit in the direct map. We can't use
> > > them, because in our case the page may get accessed by the KVM (e.g
> > > kvm_guest_write, kvm_guest_map etc).
> > 
> > But KVM should never access a guest private page, i.e. the direct map should
> > always be restored to PRESENT before KVM attempts to access the page.
> > 
> 
> Yes, KVM should *never* access the guest private pages. So, we could
> potentially enhance the RMPUPDATE() to check for the assigned and act
> accordingly.
> 
> Are you thinking something along the line of this:
> 
> int rmpupdate(struct page *page, struct rmpupdate *val)
> {
> 	...
> 	
> 	/*
> 	 * If page is getting assigned in the RMP entry then unmap
> 	 * it from the direct map before its added in the RMP table.
> 	 */
> 	if (val.assigned)
> 		set_direct_map_invalid_noflush(page_to_virt(page), 1);
> 
> 	...
> 
> 	/*
> 	 * If the page is getting unassigned then restore the mapping
> 	 * in the direct map after its removed from the RMP table.
> 	 */
> 	if (!val.assigned)
> 		set_direct_map_default_noflush(page_to_virt(page), 1);
> 	
> 	...
> }

Yep.

However, looking at the KVM usage, rmpupdate() appears to be broken.  When
handling a page state change, the guest can specify a 2mb page.  In that case,
rmpupdate() will be called once for a 2mb page, but this flow assumes a single
4kb page.  The current code works because set_memory_4k() will cause the entire
2mb page to be shattered, but it's technically wrong and switching to the above
would cause problems.
