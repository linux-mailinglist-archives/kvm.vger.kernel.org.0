Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4122C3E1910
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbhHEQHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242655AbhHEQHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 12:07:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9F1C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 09:06:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so15956373pjb.2
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 09:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gS8FXqlIEEYizkg3i3gXTEp2lHp5Ys6haxL7lS48eI8=;
        b=miRBqZUA8BbUIlZohBuu/kNx4j1tzah82MIu4dyhQGdEA0VMlmks9FBmM8o1OfLbDE
         LGg4+1FIyJnQojI0aE/D+9o3NVgjua82cVV6t/gUhboPyFCqN1Ga74AYWV9Jbb2ojx+G
         uLC4Pgxq4AkM+pZeaTQLCNQU/tyWOi6ibMtFPKZz+vvNd09+DzLB69uQbWRTkmc8Ikfq
         yXXsy0CRAsx1PBm96IIT769fOoDdkgQRaP/gRlJsFrRJ/tLJTCkzqB8ZYW0zLfb48Ts2
         Rdm/QpnNp4zkbO2BE0eQBajw936AYGGnR1Oh5MUJEzCS3tgshADKN0dnaEhaBa0UlrpL
         oszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gS8FXqlIEEYizkg3i3gXTEp2lHp5Ys6haxL7lS48eI8=;
        b=kYpuB51VzLKeP2UOZLzZDdFQnD3AjlMa1P7ZVPMeo/u3Yc9HouY7y2p1TtUhTP8Mu+
         BdWtE39z8RjfPieokbPcrj9LLlsPlNg8+E+zyvrzioNapHnHp2XSWDlXb0B0Pc1UwfGr
         +KcFPmXtz+2Z7Mv2xc0LhlWATvjDIRd5ILynQkoE2aZ/ia3Q8JXcuHvZaHjQp3HXowv9
         g7TRBZbG3odkxlAzTCq6fg43xd8pARdh2s9mskFbZTgA09AdjUq35z84I8qzrUeMRHDp
         ACJ/tDQ6KlxO1qF4V4MgKRXclypWrfD+voZhOAz+rUJOHh1WycCSfEwPbvyS2OIy4W5W
         q1Vw==
X-Gm-Message-State: AOAM5316yaoRbmfNhgrxhe8b4xlqNtGc2B2ONzTy9oAxMwnNIVjKJKfR
        iLdF/E/A1N9MbAqMB9Pas6p6hQ==
X-Google-Smtp-Source: ABdhPJxelZ+Nxxc4JwbVy64K4qs/9MVt5N26BOgWzQ/3UeKKo3CG9tIj7GO/UOHPjDVmDR4y9iuAoQ==
X-Received: by 2002:a17:90a:150d:: with SMTP id l13mr5379126pja.93.1628179605081;
        Thu, 05 Aug 2021 09:06:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a21sm10421833pjo.15.2021.08.05.09.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:06:44 -0700 (PDT)
Date:   Thu, 5 Aug 2021 16:06:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Message-ID: <YQwMkbBFUuNGnGFw@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
 <20210805234424.d14386b79413845b990a18ac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805234424.d14386b79413845b990a18ac@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Kai Huang wrote:
> On Fri, 2 Jul 2021 15:04:47 -0700 isaku.yamahata@intel.com wrote:
> > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > @@ -2020,6 +2032,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >  	sp = kvm_mmu_alloc_page(vcpu, direct);
> >  
> >  	sp->gfn = gfn;
> > +	sp->gfn_stolen_bits = gfn_stolen_bits;
> >  	sp->role = role;
> >  	hlist_add_head(&sp->hash_link, sp_list);
> >  	if (!direct) {
> > @@ -2044,6 +2057,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >  	return sp;
> >  }
> 
> 
> Sorry for replying old thread,

Ha, one month isn't old, it's barely even mature.

> but to me it looks weird to have gfn_stolen_bits
> in 'struct kvm_mmu_page'.  If I understand correctly, above code basically
> means that GFN with different stolen bit will have different 'struct
> kvm_mmu_page', but in the context of this patch, mappings with different
> stolen bits still use the same root,

You're conflating "mapping" with "PTE".  The GFN is a per-PTE value.  Yes, there
is a final GFN that is representative of the mapping, but more directly the final
GFN is associated with the leaf PTE.

TDX effectively adds the restriction that all PTEs used for a mapping must have
the same shared/private status, so mapping and PTE are somewhat interchangeable
when talking about stolen bits (the shared bit), but in the context of this patch,
the stolen bits are a property of the PTE.

Back to your statement, it's incorrect.  PTEs (effectively mappings in TDX) with
different stolen bits will _not_ use the same root.  kvm_mmu_get_page() includes
the stolen bits in both the hash lookup and in the comparison, i.e. restores the
stolen bits when looking for an existing shadow page at the target GFN.

@@ -1978,9 +1990,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
                role.quadrant = quadrant;
        }

-       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn_and_stolen)];
        for_each_valid_sp(vcpu->kvm, sp, sp_list) {
-               if (sp->gfn != gfn) {
+               if ((sp->gfn | sp->gfn_stolen_bits) != gfn_and_stolen) {
                        collisions++;
                        continue;
                }

> which means gfn_stolen_bits doesn't make a lot of sense at least for root
> page table. 

It does make sense, even without a follow-up patch.  In Rick's original series,
stealing a bit for execute-only guest memory, there was only a single root.  And
except for TDX, there can only ever be a single root because the shared EPTP isn't
usable, i.e. there's only the regular/private EPTP.

> Instead, having gfn_stolen_bits in 'struct kvm_mmu_page' only makes sense in
> the context of TDX, since TDX requires two separate roots for private and
> shared mappings.

> So given we cannot tell whether the same root, or different roots should be
> used for different stolen bits, I think we should not add 'gfn_stolen_bits' to
> 'struct kvm_mmu_page' and use it to determine whether to allocate a new table
> for the same GFN, but should use a new role (i.e role.private) to determine.

A new role would work, too, but it has the disadvantage of not automagically
working for all uses of stolen bits, e.g. XO support would have to add another
role bit.

> And removing 'gfn_stolen_bits' in 'struct kvm_mmu_page' could also save some
> memory.

But I do like saving memory...  One potentially bad idea would be to unionize
gfn and stolen bits by shifting the stolen bits after they're extracted from the
gpa, e.g.

	union {
		gfn_t gfn_and_stolen;
		struct {
			gfn_t gfn:52;
			gfn_t stolen:12;
		}
	};

the downsides being that accessing just the gfn would require an additional masking
operation, and the stolen bits wouldn't align with reality.
