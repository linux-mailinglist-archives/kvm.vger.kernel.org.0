Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8366EFB5E
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjDZTxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDZTxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6956C10F0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MkQY9fsnyyJKKZURPiYATPz6MqIWH3qZ3Vc2KWnWzQ=;
        b=DvNVI8n5xZvqQ5WSAjPNGE/m3EwdjfPTWflx4WbVOI0RNRywqarm46xRvu5W2SUcxlgQkW
        wYLMqojAwVvRpj54OJcyEyze1dqU44wO32sHXrv9N7CwNp6mWAHlhrFVeypWDzA65lgYyl
        XkcVVGdRVO+zhtagWeCuZtshcYkacpg=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-vifUBCwUPFa0kxcwaCiA_A-1; Wed, 26 Apr 2023 15:52:19 -0400
X-MC-Unique: vifUBCwUPFa0kxcwaCiA_A-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-43071a7035dso688522137.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538738; x=1685130738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1MkQY9fsnyyJKKZURPiYATPz6MqIWH3qZ3Vc2KWnWzQ=;
        b=ek3i+5EL8PXceVgrLUYYlc+5FNv+F8UtcosyOUqbd6tES88WzxV2Mu2Eb6uSaX1h7a
         fBy6pu29N0ZL4hKXpnYkQ8wF+jgO37W53vh3DnpZD2B/jWOdqQw7CJT+gYpxG8QGSob0
         nY8BAAQ+8l5e4dFE7rQ7j8UhC1Mu5Jox/btPvE2YARu23nLVhJ9ehKMV7tqG1Mg+bvO2
         47O7o4j6mGmAHkmo1nKmMgPrzCMnsh33kzDOkWCynWQtOLrkpZLOaf2NEBOaIHl8nHeh
         aooaJZBv3+iqOYJSHm9OYAoRd5PXrHZVVWgEIfYJVeVNzTCRWiry4nskyUoffBOxlYuD
         s+qg==
X-Gm-Message-State: AAQBX9fpG2Z9dlvf062YvQTjnhmT1TCllpXQMiTCehNMmnCk/p1wkHXy
        Ii4IZXyNFZhX+DAYUhfsCPKBes6h/9tj45m5s77jaJUmsYFKwdpW8Wu/srtAEZTI4hhlvLYdgGy
        elmlGB2FKy+VrAn0BTGG7F/M/uCOWXY7tRmBtc8c2kQ==
X-Received: by 2002:a67:f714:0:b0:423:e2d3:c213 with SMTP id m20-20020a67f714000000b00423e2d3c213mr9310585vso.28.1682538738396;
        Wed, 26 Apr 2023 12:52:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350bMoF4LRfKxW8zm28nZ+qTTPY/2wY9twhLV61swNDcvlYi2VlV4cg49rmOfa8t0AI8T+tzdHShV2HkUVpJY/VM=
X-Received: by 2002:a67:f714:0:b0:423:e2d3:c213 with SMTP id
 m20-20020a67f714000000b00423e2d3c213mr9310581vso.28.1682538738018; Wed, 26
 Apr 2023 12:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-3-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:52:06 +0200
Message-ID: <CABgObfYkjh4M6wt2u64toE7AT8MqZ_ia9SLSmvF46LJa1raMvg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM x86/mmu changes for 6.4.  The highlights are optimizations from Lai
> (.invlpg(), .sync_page(), and rmaps) and Vipin (A/D harvesting).
>
> I am also planning on sending the "persistent TDP MMU roots" patch[*] for
> 6.4-rc1, just waiting a few more days to give syzbot extra time to beat o=
n
> v2, and to settle on whether to guard VM desctruction with mmu_lock or RC=
U.

No problem; due to a slightly ugly coincidence of these PRs with
Italian public holiday on April 25th, and the need to handle RISC-V
separately on the second week anyway, I'll probably send ARM+s390
tomorrow and wait a little more for x86, so we'll get the persistent
TDP MMU roots patch in time.

I'll push all these to kvm/queue anyway in the meanwhile.

Paolo

> [*] https://lore.kernel.org/all/20230421214946.2571580-1-seanjc@google.co=
m
>
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.4
>
> for you to fetch changes up to 9ed3bf411226f446a9795f2b49a15b9df98d7cf5:
>
>   KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V c=
ode (2023-04-10 15:17:29 -0700)
>
> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.4:
>
>  - Tweak FNAME(sync_spte) to avoid unnecessary writes+flushes when the
>    guest is only adding new PTEs
>
>  - Overhaul .sync_page() and .invlpg() to share the .sync_page()
>    implementation, i.e. utilize .sync_page()'s optimizations when emulati=
ng
>    invalidations
>
>  - Clean up the range-based flushing APIs
>
>  - Revamp the TDP MMU's reaping of Accessed/Dirty bits to clear a single
>    A/D bit using a LOCK AND instead of XCHG, and skip all of the "handle
>    changed SPTE" overhead associated with writing the entire entry
>
>  - Track the number of "tail" entries in a pte_list_desc to avoid having
>    to walk (potentially) all descriptors during insertion and deletion,
>    which gets quite expensive if the guest is spamming fork()
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> David Matlack (3):
>       KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()=
 together
>       KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
>       KVM: x86/mmu: Use gfn_t in kvm_flush_remote_tlbs_range()
>
> Lai Jiangshan (14):
>       KVM: x86/mmu: Use 64-bit address to invalidate to fix a subtle bug
>       KVM: x86/mmu: Move the check in FNAME(sync_page) as kvm_sync_page_c=
heck()
>       KVM: x86/mmu: Check mmu->sync_page pointer in kvm_sync_page_check()
>       KVM: x86/mmu: Set mmu->sync_page as NULL for direct paging
>       KVM: x86/mmu: Move the code out of FNAME(sync_page)'s loop body int=
o mmu.c
>       KVM: x86/mmu: Reduce the update to the spte in FNAME(sync_spte)
>       kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_addr()
>       KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in kvm_mmu_invpcid_gva(=
)
>       KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in nested_ept_invalidat=
e_addr()
>       KVM: x86/mmu: Allow the roots to be invalid in FNAME(invlpg)
>       KVM: x86/mmu: Remove FNAME(invlpg) and use FNAME(sync_spte) to upda=
te vTLB instead.
>       kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
>       KVM: x86/mmu: Skip calling mmu->sync_spte() when the spte is 0
>       KVM: x86/mmu: Track tail count in pte_list_desc to optimize guest f=
ork()
>
> Mathias Krause (1):
>       KVM: x86/mmu: Fix comment typo
>
> Paolo Bonzini (1):
>       KVM: x86/mmu: Avoid indirect call for get_cr3
>
> Sean Christopherson (6):
>       KVM: x86/mmu: Sanity check input to kvm_mmu_free_roots()
>       KVM: x86/mmu: Rename slot rmap walkers to add clarity and clean up =
code
>       KVM: x86/mmu: Replace comment with an actual lockdep assertion on m=
mu_lock
>       KVM: x86/mmu: Clean up mmu.c functions that put return type on sepa=
rate line
>       KVM: x86: Rename Hyper-V remote TLB hooks to match established sche=
me
>       KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper=
-V code
>
> Vipin Sharma (13):
>       KVM: x86/mmu: Add a helper function to check if an SPTE needs atomi=
c write
>       KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs ne=
ed wrprot
>       KVM: x86/mmu: Consolidate Dirty vs. Writable clearing logic in TDP =
MMU
>       KVM: x86/mmu: Atomically clear SPTE dirty state in the clear-dirty-=
log flow
>       KVM: x86/mmu: Drop access tracking checks when clearing TDP MMU dir=
ty bits
>       KVM: x86/mmu: Bypass __handle_changed_spte() when clearing TDP MMU =
dirty bits
>       KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
>       KVM: x86/mmu: Clear only A-bit (if enabled) when aging TDP MMU SPTE=
s
>       KVM: x86/mmu: Drop unnecessary dirty log checks when aging TDP MMU =
SPTEs
>       KVM: x86/mmu: Bypass __handle_changed_spte() when aging TDP MMU SPT=
Es
>       KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
>       KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
>       KVM: x86/mmu: Merge all handle_changed_pte*() functions
>
>  arch/x86/include/asm/kvm-x86-ops.h |   4 +-
>  arch/x86/include/asm/kvm_host.h    |  32 +--
>  arch/x86/kvm/kvm_onhyperv.c        |  33 ++-
>  arch/x86/kvm/kvm_onhyperv.h        |   5 +-
>  arch/x86/kvm/mmu/mmu.c             | 506 ++++++++++++++++++++++---------=
------
>  arch/x86/kvm/mmu/mmu_internal.h    |   8 +-
>  arch/x86/kvm/mmu/paging_tmpl.h     | 224 +++++-----------
>  arch/x86/kvm/mmu/spte.c            |   2 +-
>  arch/x86/kvm/mmu/tdp_iter.h        |  48 +++-
>  arch/x86/kvm/mmu/tdp_mmu.c         | 215 ++++++----------
>  arch/x86/kvm/svm/svm_onhyperv.h    |   5 +-
>  arch/x86/kvm/vmx/nested.c          |   5 +-
>  arch/x86/kvm/vmx/vmx.c             |   5 +-
>  arch/x86/kvm/x86.c                 |   4 +-
>  14 files changed, 522 insertions(+), 574 deletions(-)
>

