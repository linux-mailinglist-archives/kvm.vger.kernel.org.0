Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A451664F8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgBTRfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:35:07 -0500
Received: from mail-vs1-f54.google.com ([209.85.217.54]:46473 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgBTRfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 12:35:07 -0500
Received: by mail-vs1-f54.google.com with SMTP id t12so3183684vso.13
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 09:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pmepnRQK+Zeo8qJsEnVROV7jHSWSqjA8jl+uj8g9eIM=;
        b=KBNv2kY21Ekq9DJjatjVC+1UAKeTLzMFYY+GIqYkhD0imNTcI/tOFagRTRtxWQQUOZ
         9SvpD59m/sJqW1dNrAUebD/XLNSZn8utkzirgGA6HxmrBwUYAhovlQa/Pm/ujPgRz9xL
         uCtRvZ4QB8pbmF7v4IuLrtM7Smmh6M94elINPcQr0bR5NFcuemcUHkJW1/vxT4zauneD
         m/AuvwRul1Mn3uMMPzjKrH2lspInCYHZFfg6bBBGCr3DSdfKRthWIXhSonr2rHfqrYm5
         +dgWzwFGqf9kZhTAGbjhAahT//foRnRBhg0oXsBGQMU2nKq/ODVNvbMZJAqmFIOFdIrF
         OXKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pmepnRQK+Zeo8qJsEnVROV7jHSWSqjA8jl+uj8g9eIM=;
        b=taDB7SBZpRaV5K7nMjt4g+Tl4TIwwjxEcx5mrU61ayiZ2LvxD1TlqGoUkBhp5y51O2
         MhxTsbX/+zjK5bcltDkMXjs4qBeo7RpaTktsVH3vQNqoth4y0GqxpQVgRH0jUGlTx2jl
         CsUbPio6oFK1iRA5IHhzwh0O064cA2BpaTOY6ufM8hc3VaHWfYraHP8mSM4AScV/wa6n
         xh9HqOJ5b6rEurbCwH5d2nCyUjajSWxkSuI5abvm6BY6GZGe0VWk566Br6L1gI/I94mm
         YWte8fWPo3bXaWvaX4YsnyzCq4PHB0/4mKXVC82WVTYpX7b5zlFIdrBgudONeTq2Q526
         pmDA==
X-Gm-Message-State: APjAAAVTMZP0oPA9oYPzQkrk4/noQy+9plIXDPQ8ThDDQh8BP+wPGXR9
        xqaNnkwt7/t61CLtp49yLCePWn99SxOknT/zKSWj4g==
X-Google-Smtp-Source: APXvYqxJEi1XhN5xBDOdXVTbwudDgBOrXmAcvL/t5e4xbvxev5WQPoqMZZugmV8utCpq8q3pdC2gdhTQxSo3FgsJswA=
X-Received: by 2002:a05:6102:394:: with SMTP id m20mr17887422vsq.235.1582220103799;
 Thu, 20 Feb 2020 09:35:03 -0800 (PST)
MIME-Version: 1.0
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
 <20200218174311.GE1408806@xz-x1> <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
 <20200219171919.GA34517@xz-x1> <B2D15215269B544CADD246097EACE7474BB03772@DGGEMM528-MBX.china.huawei.com>
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB03772@DGGEMM528-MBX.china.huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 20 Feb 2020 09:34:52 -0800
Message-ID: <CANgfPd-P_=GqcMiwLSSkUhZDt42aMLUsCJt+CPdUN5yR3RLHmQ@mail.gmail.com>
Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>,
        Junaid Shahid <junaids@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 5:53 AM Zhoujian (jay) <jianjay.zhou@huawei.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Thursday, February 20, 2020 1:19 AM
> > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org; pbonzini@redhat.com;
> > dgilbert@redhat.com; quintela@redhat.com; Liujinsong (Paul)
> > <liu.jinsong@huawei.com>; linfeng (M) <linfeng23@huawei.com>; wangxin (U)
> > <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > <weidong.huang@huawei.com>
> > Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
> >
> > On Wed, Feb 19, 2020 at 01:19:08PM +0000, Zhoujian (jay) wrote:
> > > Hi Peter,
> > >
> > > > -----Original Message-----
> > > > From: Peter Xu [mailto:peterx@redhat.com]
> > > > Sent: Wednesday, February 19, 2020 1:43 AM
> > > > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > > > Cc: kvm@vger.kernel.org; qemu-devel@nongnu.org;
> > pbonzini@redhat.com;
> > > > dgilbert@redhat.com; quintela@redhat.com; Liujinsong (Paul)
> > > > <liu.jinsong@huawei.com>; linfeng (M) <linfeng23@huawei.com>;
> > > > wangxin (U) <wangxinxin.wang@huawei.com>; Huangweidong (C)
> > > > <weidong.huang@huawei.com>
> > > > Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
> > > >
> > > > On Tue, Feb 18, 2020 at 01:13:47PM +0000, Zhoujian (jay) wrote:
> > > > > Hi all,
> > > > >
> > > > > We found that the guest will be soft-lockup occasionally when live
> > > > > migrating a 60 vCPU, 512GiB huge page and memory sensitive VM. The
> > > > > reason is clear, almost all of the vCPUs are waiting for the KVM
> > > > > MMU spin-lock to create 4K SPTEs when the huge pages are write
> > > > > protected. This
> > > > phenomenon is also described in this patch set:
> > > > > https://patchwork.kernel.org/cover/11163459/
> > > > > which aims to handle page faults in parallel more efficiently.
> > > > >
> > > > > Our idea is to use the migration thread to touch all of the guest
> > > > > memory in the granularity of 4K before enabling dirty logging. To
> > > > > be more specific, we split all the PDPE_LEVEL SPTEs into
> > > > > DIRECTORY_LEVEL SPTEs as the first step, and then split all the
> > > > > DIRECTORY_LEVEL SPTEs into
> > > > PAGE_TABLE_LEVEL SPTEs as the following step.
> > > >
> > > > IIUC, QEMU will prefer to use huge pages for all the anonymous
> > > > ramblocks (please refer to ram_block_add):
> > > >
> > > >         qemu_madvise(new_block->host, new_block->max_length,
> > > > QEMU_MADV_HUGEPAGE);
> > >
> > > Yes, you're right
> > >
> > > >
> > > > Another alternative I can think of is to add an extra parameter to
> > > > QEMU to explicitly disable huge pages (so that can even be
> > > > MADV_NOHUGEPAGE instead of MADV_HUGEPAGE).  However that
> > should also
> > > > drag down the performance for the whole lifecycle of the VM.
> > >
> > > From the performance point of view, it is better to keep the huge
> > > pages when the VM is not in the live migration state.
> > >
> > > > A 3rd option is to make a QMP
> > > > command to dynamically turn huge pages on/off for ramblocks globally.
> > >
> > > We're searching a dynamic method too.
> > > We plan to add two new flags for each memory slot, say
> > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES. These flags can be set through
> > > KVM_SET_USER_MEMORY_REGION ioctl.
> > >
> > > The mapping_level which is called by tdp_page_fault in the kernel side
> > > will return PT_DIRECTORY_LEVEL if the
> > KVM_MEM_FORCE_PT_DIRECTORY_PAGES
> > > flag of the memory slot is set, and return PT_PAGE_TABLE_LEVEL if the
> > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flag is set.
> > >
> > > The key steps to split the huge pages in advance of enabling dirty log
> > > is as follows:
> > > 1. The migration thread in user space uses
> > KVM_SET_USER_MEMORY_REGION
> > > ioctl to set the KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag for each
> > memory
> > > slot.
> > > 2. The migration thread continues to use the KVM_SPLIT_HUGE_PAGES
> > > ioctl (which is newly added) to do the splitting of large pages in the
> > > kernel side.
> > > 3. A new vCPU is created temporally(do some initialization but will
> > > not
> > > run) to help to do the work, i.e. as the parameter of the tdp_page_fault.
> > > 4. Collect the GPA ranges of all the memory slots with the
> > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES flag set.
> > > 5. Split the 1G huge pages(collected in step 4) into 2M by calling
> > > tdp_page_fault, since the mapping_level will return
> > > PT_DIRECTORY_LEVEL. Here is the main difference from the usual path
> > > which is caused by the Guest side(EPT violation/misconfig etc), we
> > > call it directly in the hypervisor side.
> > > 6. Do some cleanups, i.e. free the vCPU related resources 7. The
> > > KVM_SPLIT_HUGE_PAGES ioctl returned to the user space side.
> > > 8. Using KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES instread of
> > > KVM_MEM_FORCE_PT_DIRECTORY_PAGES to repeat step 1 ~ step 7, in step
> > 5
> > > the 2M huge pages will be splitted into 4K pages.
> > > 9. Clear the KVM_MEM_FORCE_PT_DIRECTORY_PAGES and
> > > KVM_MEM_FORCE_PT_PAGE_TABLE_PAGES flags for each memory slot.
> > > 10. Then the migration thread calls the log_start ioctl to enable the
> > > dirty logging, and the remaining thing is the same.
> >
> > I'm not sure... I think it would be good if there is a way to have finer granularity
> > control on using huge pages for any process, then KVM can directly leverage
> > that because KVM page tables should always respect the mm configurations on
> > these (so e.g. when huge page split, KVM gets notifications via mmu notifiers).
> > Have you thought of such a more general way?
>
> I did have thought of this, if we split the huge pages into 4K of a process, I'm
> afraid it will not be workable for the huge pages sharing scenario, e.g. DPDK,
> SPDK etc. So, only split the EPT page table and keep the VM process page table
> (e.g. qemu) untouched is the goal.
>
> >
> > (And I just noticed that MADV_NOHUGEPAGE is only a hint to khugepaged
> > and probably won't split any huge page at all after madvise() returns..)
> > To tell the truth I'm still confused on how split of huge pages helped in your
> > case...
>
> I'm sorry if the meaning is not expressed clearly, and thanks for your patience.
>
> > If I read it right the test reduced some execution time from 9s to a
> > few ms after your splittion of huge pages.
>
> Yes
>
> > The thing is I don't see how split of
> > huge pages could solve the mmu_lock contention with the huge VM, because
> > IMO even if we split the huge pages into smaller ones, those pages should still
> > be write-protected and need merely the same number of page faults to resolve
> > when accessed/written? And I thought that should only be fixed with
> > solutions like what Ben has proposed with the MMU rework. Could you show
> > me what I've missed?
>
> Let me try to describe the reason of mmu_lock contention more clearly and the
> effort we tried to do...
> The huge VM only has EPT >= level 2 sptes, and level 1 sptes don't
> exist at the beginning. Write protect all the huge pages will trigger EPT
> violation to create level 1 sptes for all the vCPUs which want to write the
> content of the memory. Different vCPU write the different areas of
> the memory, but they need the same kvm->mmu_lock to create the level 1
> sptes, this situation will be worse if the number of vCPU and the memory of
> VM is large(in our case 60U512G), meanwhile the VM has
> memory-write-intensive work to do. In order to reduce the mmu_lock
> contention, we try to: write protect VM memory gradually in small chunks,
> such as 1G or 2M. Using a vCPU temporary creately by migration thread to
> split 1G to 2M as the first step, and to split 2M to 4K as the second step
> (this is a little hacking...and I do not know any side effect will be triggered
> indeed).
> Comparing to write protect all VM memory in one go, the write
> protected range is limited in this way and only the vCPUs write this limited
> range will be involved to take the mmu_lock. The contention will be reduced
> since the memory range is small and the number of vCPU involved is small
> too.
>
> Of course, it will take some extra time to split all the huge pages into 4K
> page before the real migration started, about 60s for 512G in my experiment.
>
> During the memory iterative copy phase, PML will do the dirty logging work
> (not write protected case for 4K), or IIRC using fast_page_fault to mark page
> dirty if PML is not supported, which case the mmu_lock does not needed.
>
> Regards,
> Jay Zhou

(Ah I top-posted I'm sorry. Re-sending at the bottom.)

FWIW, we currently do this eager splitting at Google for live
migration. When the log-dirty-memory flag is set on a memslot we
eagerly split all pages in the slot down to 4k granularity.
As Jay said, this does not cause crippling lock contention because the
vCPU page faults generated by write protection / splitting can be
resolved in the fast page fault path without acquiring the MMU lock.
I believe +Junaid Shahid tried to upstream this approach at some point
in the past, but the patch set didn't make it in. (This was before my
time, so I'm hoping he has a link.)
I haven't done the analysis to know if eager splitting is more or less
efficient with parallel slow-path page faults, but it's definitely
faster under the MMU lock.
