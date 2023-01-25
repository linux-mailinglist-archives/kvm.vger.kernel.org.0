Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7F67BF47
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbjAYVxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAYVxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:53:11 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565B086A8
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:53:08 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id d188so17573805oia.3
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FK/9T29iODZ59+f1JESHnd65s/n5b9dY4UEOyjBbcEU=;
        b=b04tS0O7N/N1riUBFoYctrcBokH18TCZYDw1crIuvH0vRs3879TSHEHgIYpJgN5F7U
         l6Jvb3DA4UinIge9ko3eVA0xGQHU/uFDSYnYurZwwqFI2AmIpZSSocg5RGf+8+mc+8sV
         L8DB35lMrp8eE6dvbKuMCDfVIiMcgKd4dGPIYs5WmEiTDMhjBfteqeUec9/NjkWf3cfb
         cZZf6uoj67288SzlA199jUnie2PlaoqF/cmhPelc8hT+i8pnnicf7PuRk4eIkM+ghbbO
         WFlwthEy/nIjyTXPxryFyDoa3HERXQBXaP4bnVLTULy5jajJf20OH+UJh+OkucXazIlm
         JlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FK/9T29iODZ59+f1JESHnd65s/n5b9dY4UEOyjBbcEU=;
        b=O6bQkAA42s851oNn1LtNQXHkAT/bQpAQBWyO48icGdb0N+quJmMoypXNIcNEj7A6We
         QoOFoaHm4+bX7YJwbyq/UV1NEas8omP6B05mMG+4LcjsqGzbZlhMPCAp4YEtbbo4ppnC
         p/WFAeAJTrJyvrzYtKMruSPizMVq0dlst2wmIrCdWJhTiVF52+wLnRwrpI4NzHrcr+gb
         sEnWSNkHsJkr8dRwa0JcOn0M290KzI/8MIZ/8QXD1TqE8ZKg5wO4RH47ChFIRY5JvYSu
         jthH3VC2G71fWHzvaHxjnR2d8Vzfqz/GChs2uuIuSV+orIsmc/f6ET8Xm9+0eUKx7viJ
         MIvg==
X-Gm-Message-State: AFqh2kp7dYMipUSPOORtSMvpRHRsMovIw3zVPssL9gWEt8sguRqSG+Mt
        S8W8Er+d3uPm0kAyGnT8IIeb7M8LOdl1x2L62Z0fKg==
X-Google-Smtp-Source: AMrXdXuyaO7b1tJc+dr7mmKNnVfcM8OpbeMgqTOB+gTbqM/Ybvjftr2ysl8nBnAGotjaDqCxGVWxb8sYOYxE2fh8ark=
X-Received: by 2002:aca:2b16:0:b0:364:4a32:d98a with SMTP id
 i22-20020aca2b16000000b003644a32d98amr1363175oik.157.1674683586013; Wed, 25
 Jan 2023 13:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com> <20230109215347.3119271-5-rananta@google.com>
 <Y9BhiOyvMvu/L0J4@thinky-boi>
In-Reply-To: <Y9BhiOyvMvu/L0J4@thinky-boi>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 25 Jan 2023 13:52:54 -0800
Message-ID: <CAJHc60yPWrry_+g=rxJs26SBW4oz-ovrBZ=OyzbBieTaA=36gQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/6] KVM: arm64: Optimize TLBIs in the dirty logging path
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Tue, Jan 24, 2023 at 2:54 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Raghavendra,
>
> I find the commit title rather ambiguous. May I suggest:
>
>   KVM: arm64: Use range-based TLBIs for write protection
>
> On Mon, Jan 09, 2023 at 09:53:45PM +0000, Raghavendra Rao Ananta wrote:
> > Currently the dirty-logging paths, including
> > kvm_arch_flush_remote_tlbs_memslot() and kvm_mmu_wp_memory_region()
> > ivalidates the entire VM's TLB entries using kvm_flush_remote_tlbs().
> > As the range of IPAs is provided by these functions, this is highly
> > inefficient on the systems which support FEAT_TLBIRANGE. Hence,
> > use kvm_flush_remote_tlbs_range() to flush the TLBs instead.
>
> This commit message gives a rather mechanical description of the commit.
> Instead of describing the change, could you describe _why_ this is an
> improvement over the VM-wide invalidation?
>
Of course. I assumed the optimization would be obvious, but sure,
it'll be better to describe it.
FYI, thanks to David's common code for range-based TLBI, this patch
shrunk to just one line, and would impact only the flush after
write-protect.

Thanks,
Raghavendra
> --
> Thanks,
> Oliver
>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 7 ++++++-
> >  arch/arm64/kvm/mmu.c | 2 +-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 00da570ed72bd..179520888c697 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1433,7 +1433,12 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> >  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> >                                       const struct kvm_memory_slot *memslot)
> >  {
> > -     kvm_flush_remote_tlbs(kvm);
> > +     phys_addr_t start, end;
> > +
> > +     start = memslot->base_gfn << PAGE_SHIFT;
> > +     end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> > +
> > +     kvm_flush_remote_tlbs_range(kvm, start, end);
> >  }
> >
> >  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 70f76bc909c5d..e34b81f5922ce 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -976,7 +976,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
> >       write_lock(&kvm->mmu_lock);
> >       stage2_wp_range(&kvm->arch.mmu, start, end);
> >       write_unlock(&kvm->mmu_lock);
> > -     kvm_flush_remote_tlbs(kvm);
> > +     kvm_flush_remote_tlbs_range(kvm, start, end);
> >  }
> >
> >  /**
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
> >
