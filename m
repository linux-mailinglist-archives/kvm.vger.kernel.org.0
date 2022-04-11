Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58354FC2FE
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 19:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbiDKRPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 13:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244749AbiDKRPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 13:15:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F017824940
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:12:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 2so15896157pjw.2
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n3oNrdTxKJ+MoxW65YrXbYK4rkoPX/tBKkcS7/m4AZo=;
        b=Q/wB0ykLqrefjuK5NgTh9FijOKcyQr6sSho/2gt7q5lJEpIRBcsi2KNDdbDxP4CIAy
         /CaznMcwJHRKFtz52MOuzi4LJv+ANXRibnwbiYAUR/210tI+sha1IKB3CKS6iaVinjss
         tF9St7u2e2/msj/pRGJkeKUws6xvNPIU9KSvoAlEXgOixxkAK1fnID8RL3919gMyD4EM
         UDaXah64aS8bBq1xsDXQfsSMA3xigwOf6OvHlru3IFgglxLw7i4banTgHx1jU+V+sWyw
         vIzXenkw34B+2PcbwXoKol2GEZf+s2bA5zuk7K3KfsDLyqGRpyfD/5JFCWFN83ZDYmzj
         ZWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n3oNrdTxKJ+MoxW65YrXbYK4rkoPX/tBKkcS7/m4AZo=;
        b=gVgNtQbDjpGIkz6PWtc+rgjVrLdF8IWjeuToQ1pfb2mKvMZ/bKJgCewGdIfkQDTog3
         vVtDDOfkU/x5de/Hw9HXdVN8Fkj6cFwQvCp3eWChftHH0rjWplWzxLp9ZzHs8WVl1kb9
         UZYY37QWdbE+pa6zG2ezqC6ZH7fNgNDXRHPCVa0clPWerS/sSDGWPpbuLmhbNVD+joaY
         D3EoWEEm4DEawDj98y0Hh+uKBZqE+Xuk6EmpK7A76KR3ri9Fm1MlL3/bUBI+NyXBTetM
         EVo65ygD8XO7659rNuHkUV6gUuFuUPGqrIgXEfWE1l0Z8o0CKOTL8SoKR54g6/0JfKY/
         Qt8A==
X-Gm-Message-State: AOAM530WyspfB3A9A7g6dc6qpXH1aGI3YOTreY8W5Y//32QAytEmATBr
        hNNTtW5whBViAyPbxiCY8r88hw==
X-Google-Smtp-Source: ABdhPJysztOiNeuzOBqJTTEDK51v1XDCo8Ke61TQgShgEeV4D3ONCQibBTntQNmoN3dGlosPcrn1gQ==
X-Received: by 2002:a17:902:7298:b0:158:3a08:3163 with SMTP id d24-20020a170902729800b001583a083163mr11703844pll.133.1649697165171;
        Mon, 11 Apr 2022 10:12:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ng17-20020a17090b1a9100b001c9f79927bfsm68698pjb.25.2022.04.11.10.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:12:44 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:12:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlRhiF1O71TWQr5r@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, David Matlack wrote:
> This series extends KVM's Eager Page Splitting to also split huge pages
> mapped by the shadow MMU, i.e. huge pages present in the memslot rmaps.
> This will be useful for configurations that use Nested Virtualization,
> disable the TDP MMU, or disable/lack TDP hardware support.
> 
> For background on Eager Page Splitting, see:
>  - Proposal: https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/
>  - TDP MMU support: https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
> 
> Splitting huge pages mapped by the shadow MMU is more complicated than
> the TDP MMU, but it is also more important for performance as the shadow
> MMU handles huge page write-protection faults under the write lock.  See
> the Performance section for more details.
> 
> The extra complexity of splitting huge pages mapped by the shadow MMU
> comes from a few places:

I think we should restrict eager page splitting to the TDP MMU being enabled,
i.e. restrict shadow MMU support to nested MMUs.

A decent chunk of the churn and complexity in this series comes from having to
deal with the intersection of things no one cares about in practice (!TDP shadow
paging), and/or things we should be putting into maintenance-only mode (legacy MMU
with TDP enabled).  I see zero reason to support this for legacy shadow paging
without a very concrete, very performance sensitive use case, and the legacy MMU
with TDP should be a hard "no".

With those out of the way, unsync support can also be jettisoned, because barring
use cases I don't know about, hypervisors don't modify TDP entries in the same way
that kernels modify native page tables, i.e. don't benefit from allowing SPTEs to
go unsync.

The other feature that I think we should deprecate (which I'm pretty sure someone on
our team, maybe even you, is planning on proposing upstream) is support for zapping
KVM shadow pages for the shrinker.  In hindsight, we should have done that a few
years ago instead of fixing the bug that made KVM's support meaningful (see commit
ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU pages when shrinking the slab").  Doing
that for nested MMUs only (or at least first) should be less controversial.

The other thing we want to do sooner than later is improve the scalability of the
nested MMU.  A relatively simple way to pick some juicy low hanging fruit, if we
drop the aforementioned features we don't actually need for nested MMUs, would be
to turn all of the tracking structures needed for handling a page fault into
per-root lists/structures, e.g. active_mmu_pages and mmu_page_hash.  Unless L1 is
doing something funky, there is unlikely to be overlap between nested TDP page
tables, i.e. per-root tracking shouldn't cause a memory explosion.

At that point, as a first step/stopgap toward a more scalable nested MMU implementation,
nested TDP page faults, zapping of obsolete pages (memslot updates), and eager page
splitting (I think) can take mmu_lock for read and then take a per-root spinlock.

At a bare minimum, taking mmu_lock for read would prevent a nested vCPU from blocking
the TDP MMU, which in itself should be a big win.  Zapping after a memslot updates
would not interfere at all with re-faulting memory since zapping the obsolete roots
would never get a lock conflict.  And for use cases that spin up a large number of small
L2 VMs, per-root locking will allow KVM to handle page faults for each L2 in parallel,
which could be a huge performance boost for select use cases.

Circling back to eager page splitting, this series could be reworked to take the
first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
order to provide the necessary path for reworking nested MMU page faults.  Then it
can remove unsync and shrinker support for nested MMUs.  With those gone,
dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
some of the complexity/churn.

> Performance
> -----------
> 
> To measure the performance impact of Eager Page Splitting I ran
> dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> vCPU, and backed by 1GiB HugeTLB memory. The amount of memory that was
> written to versus read was controlled with the -f option.
> 
> To measure the imapct of customer performance, we can look at the time
> it takes all vCPUs to dirty memory after dirty logging has been enabled.
> Without Eager Page Splitting enabled, such dirtying must take faults to
> split huge pages and bottleneck on the MMU lock.
> 
>              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
>              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
>              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
>              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
>              | Config: ept=N, tdp_mmu=Y, 100% writes                   |
>              | Config: ept=N, tdp_mmu=Y, 50% writes                    |
>              | Config: ept=N, tdp_mmu=Y, 5% writes                     |

IMO, to justify this there needs to be performance numbers for ept=Y, tdp_mmu=Y,
i.e. for the use case we actually care about.  I don't expect the outcome to be
any different, but it really should be explicitly tested.
