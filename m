Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AD06488CD
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLITHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiLITHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:07:21 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F91789A;
        Fri,  9 Dec 2022 11:07:20 -0800 (PST)
Date:   Fri, 9 Dec 2022 19:07:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670612838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWmH4e1mGrQaOKoXcB+GepAJzEfWN1IWTXh/7cR74Ow=;
        b=AswdAfd5Q+mOjP5g961Yuon0PbYZHfxSUDlGJ+/buNi7IHM9bd6ULaRiGOzBuN6ci0izSW
        B5EIV4JzGif6x12auQAsZB3J+bcstx7A9s7T7t3T4uADc2KhM2k8w4j4zr2MLJSJNCfruM
        B8PoL86EPm1zOzsehSZsoQ31jqDCN7U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
Message-ID: <Y5OHVzBSHPmAq2FO@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 11:38:20AM -0800, David Matlack wrote:
> [ mm folks: You are being cc'd since this series includes a mm patch
>   ("mm: Introduce architecture-neutral PG_LEVEL macros"), but general
>   feedback is also welcome. I imagine there are a lot of lessons KVM can
>   learn from mm about sharing page table code across architectures. ]
> 
> Hello,
> 
> This series refactors the KVM/x86 "TDP MMU" into common code. This is
> the first step toward sharing TDP (aka Stage-2) page table management
> code across architectures that support KVM. For more background on this
> effort please see my talk from KVM Forum 2022 "Exploring an
> architecture-neutral MMU":
> 
>   https://youtu.be/IBhW34fCFi0
> 
> By the end of this series, 90% of the TDP MMU code is in common directories
> (virt/kvm/mmu/ and include/kvm/). The only pieces that remaing in
> arch/x86 are code that deals with constructing/inspecting/modifying PTEs
> and arch hooks to implement NX Huge Pages (a mitigation for an
> Intel-specific vulnerability).
> 
> Before:
> 
>   180 arch/x86/kvm/mmu/tdp_iter.c
>   118 arch/x86/kvm/mmu/tdp_iter.h
>  1917 arch/x86/kvm/mmu/tdp_mmu.c
>    98 arch/x86/kvm/mmu/tdp_mmu.h
>  ----
>  2313 total
> 
> After:
> 
>   178 virt/kvm/mmu/tdp_iter.c
>  1867 virt/kvm/mmu/tdp_mmu.c
>   117 include/kvm/tdp_iter.h
>    78 include/kvm/tdp_mmu.h
>    39 include/kvm/tdp_pgtable.h
>  ----
>   184 arch/x86/kvm/mmu/tdp_pgtable.c
>    76 arch/x86/include/asm/kvm/tdp_pgtable.h
>  ----
>  2539 total
> 
> This series is very much an RFC, but it does build (I tested x86_64 and
> ARM64) and pass basic testing (KVM selftests and kvm-unit-tests on
> x86_64), so it is entirely functional aside from any bugs.
> 
> The main areas I would like feedback are:
> 
>  - NX Huge Pages support in the TDP MMU requires 5 arch hooks in
>    the common code, which IMO makes the NX Huge Pages implementation
>    harder to read. The alternative is to move the NX Huge Pages
>    implementation into common code, including the fields in struct
>    kvm_mmu_page and kvm_page_fault, which would increase memory usage
>    a tiny bit (for non-x86 architectures) and pollute the common code
>    with an x86-specific security mitigation. Ideas on better ways to
>    handle this would be appreciated.
> 
>  - struct kvm_mmu_page increased by 64 bytes because the separation of
>    arch and common state eliminated the ability to use unions to
>    optimize the size of the struct. There's two things we can do to
>    reduce the size of the struct back down: (1) dynamically allocated
>    root-specific fields only for root page tables and (2) dynamically
>    allocate Shadow MMU state in kvm_mmu_page_arch only for Shadow MMU
>    pages. This should actually be a net *reduction* the size of
>    kvm_mmu_page relative today for most pages, but I have not
>    implemented it.
> 
>    Note that an alternative approach I implemented avoided this problem
>    by creating an entirely separate struct for the common TDP MMU (e.g.
>    struct tdp_mmu_page). This however had a lot of downsides that I
>    don't think make it a good solution. Notably, it complicated a ton of
>    existing code in arch/x86/kvm/mmu/mmu.c (e.g. anything that touches
>    vcpu->arch.mmu->root and kvm_recover_nx_huge_pages()) and created a
>    new runtime failure mode in to_shadow_page().
> 
>  - Naming. This series does not change the names of any existing code.
>    So all the KVM/x86 Shadow MMU-style terminology like
>    "shadow_page"/"sp"/"spte" persists. Should we keep that style in
>    common code or move toward something less shadow-paging-specific?
>    e.g. "page_table"/"pt"/"pte".

I would strongly be in favor of discarding the shadow paging residue if
x86 folks are willing to part ways with it :)

>    Also do we want to keep "TDP" or switch
>    to something more familiar across architectures (e.g. ARM and RISC-V
>    both use "Stage-2")?

As it relates to guest memory management I don't see much of an issue
with it, TBH. It is sufficiently arch-generic and gets the point across.

Beyond that I think it really depends on the scope of the common code.

To replace the arm64 table walkers we will need to use it for stage-1
tables. I'm only hand-waving at the cover letter and need to do more
reading, but is it possible to accomplish some division:

 - A set of generic table walkers that implement common operations, like
   map and unmap. Names and types at this layer wouldn't be
   virt-specific.

 - Memory management for KVM guests that uses the table walker library,
   which we can probably still call the TDP MMU.

Certainly this doesn't need to be addressed in the first series, as the x86
surgery is enough on its own. Nonetheless, it is probably worthwhile to
get the conversation started about how this code can actually be used by
the other arches.

--
Thanks,
Oliver
