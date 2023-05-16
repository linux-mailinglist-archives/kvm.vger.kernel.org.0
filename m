Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C67055E3
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjEPSVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 14:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjEPSVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 14:21:38 -0400
Received: from out-30.mta1.migadu.com (out-30.mta1.migadu.com [IPv6:2001:41d0:203:375::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F0326AB
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 11:21:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684261294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJIiUAqU0U9NkUHObypH6C3V+XIHAJcOTcw9BCe8MYk=;
        b=AHw2Mna4in3bpSeHQGOK9UcQF7Ic+VOu0Nw7bkq0HabAiT/rFsZvYkaBF9XhXdwjtPdiEu
        xzV+Y8j5JXJy5OlcaxwNvfBIe6HGtPlxoA/p8W4zkVXNH0ExAe24SB++k+sjde6N7MeG5d
        5286z7RvdDWfEjRAURN6C9kZ3JqLsJs=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com
Cc:     gshan@redhat.com, ricarkol@gmail.com, kvmarm@lists.linux.dev,
        qperret@google.com, suzuki.poulose@arm.com, bgardon@google.com,
        andrew.jones@linux.dev, rananta@google.com,
        catalin.marinas@arm.com, kvm@vger.kernel.org, reijiw@google.com,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v8 00/12] Implement Eager Page Splitting for ARM
Date:   Tue, 16 May 2023 18:21:09 +0000
Message-ID: <168426111477.3193133.10748106199843780930.b4-ty@linux.dev>
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
References: <20230426172330.1439644-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Apr 2023 17:23:18 +0000, Ricardo Koller wrote:
> Eager Page Splitting improves the performance of dirty-logging (used
> in live migrations) when guest memory is backed by huge-pages.  It's
> an optimization used in Google Cloud since 2016 on x86, and for the
> last couple of months on ARM.
> 
> Background and motivation
> =========================
> Dirty logging is typically used for live-migration iterative copying.
> KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
> to 4K pages from now on).  It does it by faulting on write-protected
> 4K pages.  Therefore, enabling dirty-logging on a huge-page requires
> breaking it into 4K pages in the first place.  KVM does this breaking
> on fault, and because it's in the critical path it only maps the 4K
> page that faulted; every other 4K page is left unmapped.  This is not
> great for performance on ARM for a couple of reasons:
> 
> [...]

Picking these patches up early, as I'd like to get some mileage on the
patches well in advance of 6.5.

Applied to kvmarm/next, thanks!

[01/12] KVM: arm64: Rename free_removed to free_unlinked
        https://git.kernel.org/kvmarm/kvmarm/c/c14d08c5adb2
[02/12] KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping CMOs and BBM TLBIs
        https://git.kernel.org/kvmarm/kvmarm/c/02f10845f435
[03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
        https://git.kernel.org/kvmarm/kvmarm/c/e7c05540c694
[04/12] KVM: arm64: Export kvm_are_all_memslots_empty()
        https://git.kernel.org/kvmarm/kvmarm/c/26f457142d7e
[05/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
        https://git.kernel.org/kvmarm/kvmarm/c/2f440b72e852
[06/12] KVM: arm64: Add kvm_pgtable_stage2_split()
        https://git.kernel.org/kvmarm/kvmarm/c/8f5a3eb7513f
[07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
        https://git.kernel.org/kvmarm/kvmarm/c/6bd92b9d8b02
[08/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
        https://git.kernel.org/kvmarm/kvmarm/c/ce2b60223800
[09/12] KVM: arm64: Split huge pages when dirty logging is enabled
        https://git.kernel.org/kvmarm/kvmarm/c/e7bf7a490c68
[10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
        https://git.kernel.org/kvmarm/kvmarm/c/3005f6f29447
[11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
        https://git.kernel.org/kvmarm/kvmarm/c/6acf51666d03
[12/12] KVM: arm64: Use local TLBI on permission relaxation
        https://git.kernel.org/kvmarm/kvmarm/c/a12ab1378a88

--
Best,
Oliver
