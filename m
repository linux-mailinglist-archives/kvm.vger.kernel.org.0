Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194AB363F54
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhDSKLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 06:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhDSKLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 06:11:16 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA870C061760
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 03:10:45 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n8so55143006lfh.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 03:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zu9j1wjDjVkPmp9+MDbUYSq/opn21hdEYi2SoFE0G38=;
        b=2LjTTSlb/HS0t4OCyCPR5n54BZUrC67zqEW9gNRUxmv8X0KzjAkpqXGsW5TKWl7fRW
         V+zzwiuaQqljXyBZTDlWxrL3VpESCGckDvZEprHjil56QDYLKqoufkWOB+Z7w8LRjNt5
         v3Zgwt639jnsOrP9EUIrG40W6F2wNMYoWiRP6JbYiasJGduQklPnbLecz8d8HhwwIXuE
         btcog1szy30k0xb7odbF4ehAkhrNSUgnTgdacZ/UiCbFCvRAp5s9O7t9lK5J7LtTGBN2
         NsFIBJVO09qYDVLg2WB0VwNzWyklYM17JZHxmwAIj3DciLZFIaj7VPL4tO7FQh1wcQNg
         sKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zu9j1wjDjVkPmp9+MDbUYSq/opn21hdEYi2SoFE0G38=;
        b=YdDDSN5KTiq3UavGeDoVBro9pdb8u650DggRjlX+Y8pP9A08Xs3P5d6s+oEpHERUK6
         +x4+1wmNyeWGfEjPBy2JXaggt6LkbPNO1KqcadUirut45PggK4uEs9Gd7ciNDRDoN5yB
         dFJN9jz7Z8ctmtVU1VEY4uzzlVWIC97GqG59RkWeX08msCXoTkm5Qq1SnZseNZQNvqHi
         IS2HMK7ybi/dXDwy32VBowzL5y2PJREBe/UR+hyX49mVLayxleb3UiB3pqLQ776OeJQx
         /AGQJwL1Xp4aMjTSozYE2K/3W8GX/z8W3n2JE7qR3rX/2hWQUoqkMskONJaKTaL8wIdl
         aZBw==
X-Gm-Message-State: AOAM5311y9gyAY/h0XCeszP1zKuQtc+jrpHAJr/NwuJK7IkSOhd11p67
        mUah4Gob//BbxfaMcCz5Il72jg==
X-Google-Smtp-Source: ABdhPJyUF3dNClX1XwBoeI6qAE9kwKRdTk+Rcod7QjPwhM1cLAn5iDwDJp3HXyxxIfQzSrHVEDuGWw==
X-Received: by 2002:a05:6512:1288:: with SMTP id u8mr11575728lfs.319.1618827044344;
        Mon, 19 Apr 2021 03:10:44 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k2sm1777953lfg.107.2021.04.19.03.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 03:10:43 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id D293C102567; Mon, 19 Apr 2021 13:10:42 +0300 (+03)
Date:   Mon, 19 Apr 2021 13:10:42 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
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
Subject: Re: [RFCv2 02/13] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20210419101042.txf6pj3kr6z5bkh5@box.shutemov.name>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-3-kirill.shutemov@linux.intel.com>
 <20210416161030.GC22348@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416161030.GC22348@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 06:10:30PM +0200, Borislav Petkov wrote:
> On Fri, Apr 16, 2021 at 06:40:55PM +0300, Kirill A. Shutemov wrote:
> > Provide basic helpers, KVM_FEATURE, CPUID flag and a hypercall.
> > 
> > Host side doesn't provide the feature yet, so it is a dead code for now.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h   |  1 +
> >  arch/x86/include/asm/kvm_para.h      |  5 +++++
> >  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
> >  arch/x86/kernel/kvm.c                | 17 +++++++++++++++++
> >  include/uapi/linux/kvm_para.h        |  3 ++-
> >  5 files changed, 27 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 84b887825f12..d8f3d2619913 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -238,6 +238,7 @@
> >  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
> >  #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
> >  #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
> > +#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* "" KVM memory protection extension */
> 
> That feature bit is still unused.

Sorry. Will drop it.

-- 
 Kirill A. Shutemov
