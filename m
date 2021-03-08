Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E943319A6
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhCHVtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhCHVtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:49:39 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9C5C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 13:49:39 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so3792221pjq.5
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 13:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E+umKW6wxaxW//tXwBBv0JMHZeXf2FH8crBpZk5jUgg=;
        b=roL62QLenm6INB6NQQArshLD2zx0uU4/QKM8K7yyS8ToyQfh0fNWBfww/djww/UAum
         l7nu5hFLMs9pttnW3EL7LCzD4wnQwglE+66IehHOVwS/UANfZ7xeSyf7odvVvbFtBG5Q
         ovLuoh63lTVHka+Lt27L/4XemRHHCJ6k6hBeIsnH2hDuEMOyAbDE7Y/XB6r9+aP56oeY
         sDddTkDwKwZg6bex7k69fxL9+ab9QT42KsAEyHUZIREW/J4ErJVdZAmgWkqYluNSbq/X
         NSvl4X3qZlf/3MdYennQv5i4VycbRk9XPUQcEZjMiMas/N/sL0nw7pCnwwMF7xsQWsh9
         SIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E+umKW6wxaxW//tXwBBv0JMHZeXf2FH8crBpZk5jUgg=;
        b=AMiAIf6IBTnKH74H6A+2NgVYRw/epg/G65oBczdij6htjtPPTp7btLdbVZKShu/JvY
         PWZShCMDADuoyrvCxy2KBb+IUj7QlUjss+gQIY/JsgVK6yuZcn/kRPqzLVEw8nq/vj7N
         VdT+wuDELJ05J8isLWO6RLMY6NSjMEE2J5zbqueWxBfZg4KA9vRp9hu+ahQ0gA4JthDt
         KCtZEO0j6dZZCtmImgFcYabxgdQ30M7qz95vu8X8WbvsEtB+ebr4z1b4FIw42JseeXsx
         rVDQwlADJ09ZdZlfLeJj0SBNJ0fRJehH8cqkJjuuE+9UEUw8GCgQXjwPG8pb9uBrOhIu
         Jnpg==
X-Gm-Message-State: AOAM53315GOL7yi4eQuZTRMdm4QHZaIc6cgXcs7ywOpfvFjmeX1PPpTF
        DKPXC12C7Fc88zUH75udoKqzow==
X-Google-Smtp-Source: ABdhPJwAN1gRrtDpwEzyc8Sc1QRATAo85Cq+NyKZdqphQ0C1FR0BrtQxNi1CaPl/mWfxfXRcFvGcHQ==
X-Received: by 2002:a17:90a:55ca:: with SMTP id o10mr924935pjm.173.1615240178779;
        Mon, 08 Mar 2021 13:49:38 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id o62sm10438006pga.43.2021.03.08.13.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 13:49:38 -0800 (PST)
Date:   Mon, 8 Mar 2021 13:49:31 -0800
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
Message-ID: <YEab68TODdlKTctF@google.com>
References: <20210225204749.1512652-1-seanjc@google.com>
 <20210225204749.1512652-21-seanjc@google.com>
 <42917119-b43a-062b-6c09-13b988f7194b@amd.com>
 <YEaE9K/dAjImXv0f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEaE9K/dAjImXv0f@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Tom Lendacky wrote:
> > On the hypervisor, I see the following:
> > 
> > [   55.886136] get_mmio_spte: detect reserved bits on spte, addr 0xffc12792, dump hierarchy:
> > [   55.895284] ------ spte 0x1344a0827 level 4.
> > [   55.900059] ------ spte 0x134499827 level 3.
> > [   55.904877] ------ spte 0x165bf0827 level 2.
> > [   55.909651] ------ spte 0xff800ffc12817 level 1.
> 
> Ah fudge.  I know what's wrong.  The MMIO generation uses bit 11, which means
> is_shadow_present_pte() can get a false positive on high MMIO generations.  This
> particular error can be squashed by explicitly checking for MMIO sptes in
> get_mmio_spte(), but I'm guessing there are other flows where a false positive
> is fatal (probably the __pte_list_remove bug below...).  The safe thing to do is
> to steal bit 11 from MMIO SPTEs so that shadow present PTEs are the only thing
> that sets that bit.
> 
> I'll reproduce by stuffing the MMIO generation and get a patch posted.  Sorry :-/
> 
> > When I kill the guest, I get a kernel panic:
> > 
> > [   95.539683] __pte_list_remove: 0000000040567a6a 0->BUG
> > [   95.545481] kernel BUG at arch/x86/kvm/mmu/mmu.c:896!

Fudging get_mmio_spte() did allow the guest to boot, but as expected KVM panicked
during guest shutdown.  Initial testing on the below changes look good, I'll
test more thoroughly and (hopefully) post later today.

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b53036d9ddf3..e6e683e0fdcd 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -101,11 +101,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #undef SHADOW_ACC_TRACK_SAVED_MASK

 /*
- * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
  *
- * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-19 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
+ * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -116,7 +116,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  */

 #define MMIO_SPTE_GEN_LOW_START                3
-#define MMIO_SPTE_GEN_LOW_END          11
+#define MMIO_SPTE_GEN_LOW_END          10

 #define MMIO_SPTE_GEN_HIGH_START       52
 #define MMIO_SPTE_GEN_HIGH_END         62
@@ -125,12 +125,14 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
                                                    MMIO_SPTE_GEN_LOW_START)
 #define MMIO_SPTE_GEN_HIGH_MASK                GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
                                                    MMIO_SPTE_GEN_HIGH_START)
+static_assert(!(SPTE_MMU_PRESENT_MASK &
+               (MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));

 #define MMIO_SPTE_GEN_LOW_BITS         (MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
 #define MMIO_SPTE_GEN_HIGH_BITS                (MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)

 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);

 #define MMIO_SPTE_GEN_LOW_SHIFT                (MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT       (MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
