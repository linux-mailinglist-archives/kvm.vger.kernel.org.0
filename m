Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E044A331839
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 21:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhCHUMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 15:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhCHULl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 15:11:41 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F45C06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 12:11:39 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so3801743pjb.0
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 12:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=inJpvYK1YMJnyEUoM1LxpFGBkfU9djOOCnPiOu1eiZI=;
        b=UrnslPo3nSqw83+2HmcT3KLPcfVkAD/fOuRoClq0tEi5b1nPZQ+3UWQJGh+TTYMkO3
         1l//NE/z+ViHMOe4opx92Z1rX8R737mfuIDKis8alBfBv8zr1usyEImqY+xU7IOCup/u
         P1tZDd37vCs9jl4a55n7VKMRlZN8yOfzVjK1IERWlHRUNQ3+Ny29I/bP33c9hGlUQsOp
         iClpBzZlj4n5j9WpJ79lAnfKfrdgxMz2J3xraiUpKpMe0ZRtioTXX714pOaahczmh14E
         drfFdQomsrNSV4bHDNdakjbYE4MV32lUf9XWALzfc2103pgqESyDBF1UITmhobXop/CY
         2BVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=inJpvYK1YMJnyEUoM1LxpFGBkfU9djOOCnPiOu1eiZI=;
        b=c4VSJKYeBC7jkhSykD7yrmNel16T6I9CzeBiYpBuQCza0VlynmIeBlzyjxB4TV+9A0
         YXup/P4uKuITv8pZdb6Fhko7i6Lv8MFPqPmw9Fkk5aIDzpLie2SMIO3airyVWF9uv5mk
         NyQB2zZardmfgBW7IAWYEx4UQ4h41bBezSC2i1l6TNRw1lBSppAFJESzbkFazmJ7Nywb
         7hMGNYWvnd9miPtpswHg1mWUgdfdou47TL1SducLmyyLJmc500UbLun4BqB9fZPH6uoD
         FSH7NCGI+cs/eax/jiETyuJy3RV3xtQNkqHVdq5S/rmyLaFXhuHd2XOBimynhuSUdlvo
         K4CQ==
X-Gm-Message-State: AOAM5303WYJITAlYZfCmZ8TZbQnt5dqJTDFCD1oykWjA+plqSalsQ0z4
        pgTynfUn0us4aVC+KxZU/18AXA==
X-Google-Smtp-Source: ABdhPJy85xPIDDDXOyiIL5nJi99l75uOA7O+Owc3vNcVsIW4vP5vCrIbUh9jUooS/eFV8AukhWK40A==
X-Received: by 2002:a17:903:102:b029:e5:fc29:de83 with SMTP id y2-20020a1709030102b02900e5fc29de83mr15275757plc.31.1615234299359;
        Mon, 08 Mar 2021 12:11:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id n5sm11072730pfq.44.2021.03.08.12.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:11:38 -0800 (PST)
Date:   Mon, 8 Mar 2021 12:11:32 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 20/24] KVM: x86/mmu: Use a dedicated bit to track
 shadow/MMU-present SPTEs
Message-ID: <YEaE9K/dAjImXv0f@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
 <20210225204749.1512652-21-seanjc@google.com>
 <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Tom Lendacky wrote:
> On 2/25/21 2:47 PM, Sean Christopherson wrote:
> > Introduce MMU_PRESENT to explicitly track which SPTEs are "present" from
> > the MMU's perspective.  Checking for shadow-present SPTEs is a very
> > common operation for the MMU, particularly in hot paths such as page
> > faults.  With the addition of "removed" SPTEs for the TDP MMU,
> > identifying shadow-present SPTEs is quite costly especially since it
> > requires checking multiple 64-bit values.
> > 
> > On 64-bit KVM, this reduces the footprint of kvm.ko's .text by ~2k bytes.
> > On 32-bit KVM, this increases the footprint by ~200 bytes, but only
> > because gcc now inlines several more MMU helpers, e.g. drop_parent_pte().
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/spte.c |  8 ++++----
> >   arch/x86/kvm/mmu/spte.h | 11 ++++++++++-
> >   2 files changed, 14 insertions(+), 5 deletions(-)
> 
> I'm trying to run a guest on my Rome system using the queue branch, but
> I'm encountering an error that I bisected to this commit. In the guest
> (during OVMF boot) I see:
> 
> error: kvm run failed Invalid argument
> RAX=0000000000000000 RBX=00000000ffc12792 RCX=000000007f58401a RDX=000000007faaf808
> RSI=0000000000000010 RDI=00000000ffc12792 RBP=00000000ffc12792 RSP=000000007faaf740
> R8 =0000000000000792 R9 =000000007faaf808 R10=00000000ffc12793 R11=00000000000003f8
> R12=0000000000000010 R13=0000000000000000 R14=000000007faaf808 R15=0000000000000012
> RIP=000000007f6e9a90 RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> CS =0038 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
> SS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> FS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> GS =0030 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> LDT=0000 0000000000000000 0000ffff 00008200 DPL=0 LDT
> TR =0000 0000000000000000 0000ffff 00008b00 DPL=0 TSS64-busy
> GDT=     000000007f5ee698 00000047
> IDT=     000000007f186018 00000fff
> CR0=80010033 CR2=0000000000000000 CR3=000000007f801000 CR4=00000668
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000d00
> Code=22 00 00 e8 c0 e6 ff ff 48 83 c4 20 45 84 ed 74 07 fb eb 04 <44> 88 65 00 58 5b 5d 41 5c 41 5d c3 55 48 0f af 3d 1b 37 00 00 be 20 00 00 00 48 03 3d 17
> 
> On the hypervisor, I see the following:
> 
> [   55.886136] get_mmio_spte: detect reserved bits on spte, addr 0xffc12792, dump hierarchy:
> [   55.895284] ------ spte 0x1344a0827 level 4.
> [   55.900059] ------ spte 0x134499827 level 3.
> [   55.904877] ------ spte 0x165bf0827 level 2.
> [   55.909651] ------ spte 0xff800ffc12817 level 1.

Ah fudge.  I know what's wrong.  The MMIO generation uses bit 11, which means
is_shadow_present_pte() can get a false positive on high MMIO generations.  This
particular error can be squashed by explicitly checking for MMIO sptes in
get_mmio_spte(), but I'm guessing there are other flows where a false positive
is fatal (probably the __pte_list_remove bug below...).  The safe thing to do is
to steal bit 11 from MMIO SPTEs so that shadow present PTEs are the only thing
that sets that bit.

I'll reproduce by stuffing the MMIO generation and get a patch posted.  Sorry :-/

> When I kill the guest, I get a kernel panic:
> 
> [   95.539683] __pte_list_remove: 0000000040567a6a 0->BUG
> [   95.545481] kernel BUG at arch/x86/kvm/mmu/mmu.c:896!
