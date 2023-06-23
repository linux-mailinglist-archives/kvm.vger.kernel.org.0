Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8273BA76
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjFWOnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjFWOnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:43:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD21FCC;
        Fri, 23 Jun 2023 07:43:18 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b505665e2fso13614595ad.0;
        Fri, 23 Jun 2023 07:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687531397; x=1690123397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCmF5COxqcBz+bGliJVhA6+1kR4LAcgvJJb20tO8jM8=;
        b=jcyqyMG1wIs6GJGoo7I3pPCED9Krx2Vaj0waG5amzO4Ns1tqpiLZ9M/qlewBCF4gwz
         UGpn5RATeeCn54m9iuWWnOHqdwVJohXON9PmlJ5ZSBkCAxiEo5W1nYwc8E0r3gVT5cFK
         A11zigd3kveLCiwk56rR87HO1BHKWrmp/nBeKbgwvxwQ/SMYbeDMNaLjMQ9vuWeMDeFm
         IkWJdGZbRiUjPYr1YGV7ik7GXEH+/CcnBLL01ZXHG69uzW+C4jGZrqx8M3tx3j+wo4a1
         RubQq84ZpE9WmTCW4EnIXYVre4n9nXZAk4i1zxrd4tN/zFy/HbHXC0hMpXspLbZyr3Ye
         skwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687531397; x=1690123397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCmF5COxqcBz+bGliJVhA6+1kR4LAcgvJJb20tO8jM8=;
        b=FCnFoKUCjPqKFNzuE5ATnaBAkE0ekQDsKPGkNFVEGT2kO5chsC3EbVwlR8djx1EG/e
         SQrglHXqR5wjSiQ/WFrfaCedFjq3nZLYivE0+n+Dqb9853qnySs1MVezwudagjO62Fvp
         RqiqRGqUoTWFuyFBUzLLph+gwxCIeROShgM7SplSiSix87V7MZOe8FigeXSLTBccr9Ye
         aaZawuGCTlraZMRL6eh5tRKfyigV1UjhQXfHGxkBT2HZZ1+5tZAEoXfQZL9k9kjoOeiY
         NjiNCWj5pluc32JLyXvlraRYjZ0VEADvFj5uLgClHpT6xszuqZ0WJy9iOXnM/qD2FN3S
         /MSw==
X-Gm-Message-State: AC+VfDy9ZEcdb+ZmEKaj/0FJeq4Usevq3mNF52HUIHcniFTeFFST901S
        PHTQaR2dC5WkZIiQewWofpw=
X-Google-Smtp-Source: ACHHUZ7ua2+VdjpIoG2bin7SPKhD7svUhBDP+s0RbDt8MG94CNs7CI3NKjv+L7lHnuAnF8fpRsO3Zg==
X-Received: by 2002:a17:902:d4c9:b0:1b6:6dc8:edeb with SMTP id o9-20020a170902d4c900b001b66dc8edebmr19631665plg.21.1687531397261;
        Fri, 23 Jun 2023 07:43:17 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id jn9-20020a170903050900b001b19d14a3d5sm7309227plb.68.2023.06.23.07.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 07:43:16 -0700 (PDT)
Date:   Fri, 23 Jun 2023 07:43:15 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pgonda@google.com" <pgonda@google.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230623144315.GC3436214@ls.amr.corp.intel.com>
References: <20230612042559.375660-5-michael.roth@amd.com>
 <20230614164709.GT2244082@ls.amr.corp.intel.com>
 <20230620202841.7qizls3u3kcck45g@amd.com>
 <20230620211845.GV2244082@ls.amr.corp.intel.com>
 <20230621230031.37hdnymbjzwjgbo2@amd.com>
 <c116b7ab8ca02116f2b8d19a8214161c3b30576c.camel@intel.com>
 <20230622153229.vjkrzi6rgiolstns@amd.com>
 <25037dfe969698dd109daee8c6dbe0d08a874a08.camel@intel.com>
 <20230622233906.GA3436214@ls.amr.corp.intel.com>
 <5ec0664fe81df54019ef5934f2dc6dfadf1d649c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ec0664fe81df54019ef5934f2dc6dfadf1d649c.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 11:52:56PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-06-22 at 16:39 -0700, Isaku Yamahata wrote:
> > On Thu, Jun 22, 2023 at 10:31:08PM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > > If there are better ways to handle *how*
> > > > that's done I don't have any complaints there, but moving/adding bits
> > > > to GPA/error_flags after fault time just seems unecessary to me when
> > > > fault->is_private field can serve that purpose just as well.
> > > 
> > > Perhaps you missed my point.  My point is arch.mmu_private_fault_mask and
> > > arch.gfn_shared_mask seem redundant because the logic around them are exactly
> > > the same.  I do believe we should have fault->is_private passing to the common
> > > MMU code.
> > > 
> > > In fact, now I am wondering why we need to have "mmu_private_fault_mask" and
> > > "gfn_shared_mask" in _common_ KVM MMU code.  We already have enough mechanism in
> > > KVM common code:
> > > 
> > >   1) fault->is_private
> > >   2) kvm_mmu_page_role.private
> > >   3) an Xarray to tell whether a GFN is private or shared
> > > 
> > > I am not convinced that we need to have "mmu_private_fault_mask" and
> > > "gfn_shared_mask" in common KVM MMU code.  Instead, they can be in AMD and
> > > Intel's vendor code.
> > > 
> > > Maybe it makes sense to have "gfn_shared_mask" in the KVM common code so that
> > > the fault handler can just strip away the "shared bit" at the very beginning (at
> > > least for TDX), but for the rest of the time I think we should already have
> > > enough infrastructure to handle private/shared mapping.
> > > 
> > > Btw, one minor issue is, if I recall correctly, for TDX the shared bit must be
> > > applied to the GFN for shared mapping in normal EPT.  I guess AMD doesn't need
> > > that for shared mapping.  So "gfn_shared_mask" maybe useful in this case, but
> > > w/o it I believe we can also achieve in another way via vendor callback.
> > 
> > 
> > "2) kvm_mmu_page_role.private" above has different meaning.
> > 
> > a). The fault is private or not.
> > b). page table the fault handler is walking is private or conventional.
> > 
> > a.) is common for SNP, TDX and PROTECTED_VM. It makes sense in
> > kvm_mmu_do_page_fault() and __kvm_faultin_pfn(). After kvm_faultin_pfn(), the
> > fault handler can mostly forget it for SNP and PROTECTED_VM. (large page
> > adjustment needs it, though.) This is what we're discussing in this thread.
> > 
> > b.) is specific to TDX. TDX KVM MMU introduces one more page table.
> > 
> > 
> 
> I don't buy the last sentence.  Even it's not necessarily for AMD from
> hardware's perspective, but the concept remains true for AMD too.  So why cannot
> we use it for AMD?

We can use it for AMD. Let me rephrase it.
TDX only uses it now. SEV-SNP may or may not use it at their option.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
