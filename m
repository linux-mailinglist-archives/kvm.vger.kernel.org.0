Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD50B470E53
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 00:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344909AbhLJXIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhLJXIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 18:08:34 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1687CC061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 15:04:59 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id b187so12063577iof.11
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 15:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5I5NHgS46XSTVWtKSECiaKdiPzg+nWy0GLfCMRd923Y=;
        b=XY4WIrb2h/Fq6MEWC/l/zYhJ/HxlN3W6fwsKP0IeGpr3Wdy/+/OVgqKQVZle5S2SNl
         GtRtcH8+iYfpv2KUx89DpxjYTHSfO+gKEt7afStUw5JN4dqPGSIJiwb8BZTcXyTq6ULv
         8psjwk2HQ+WAYC9ccFarVQyYOqm5eO0mwLOPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5I5NHgS46XSTVWtKSECiaKdiPzg+nWy0GLfCMRd923Y=;
        b=O8XzunskRcAfP9slOgx20bxMSJf7BhnSVJn2homUtmXI1r3KNJNbSUvFxzCQixbUR8
         HcAXKrxL84l9WxY6lXVhT3s3B9bU70srInpYkW2qJDgmUj5jiZG8BlOuZKGfjpUAvXRH
         A5Y1NimOdsAkXD2iER43nowzjAejFtviolufK7+tbV1npdGsoCUCUXMRc4LlaITUm4U9
         BhBxY5tps5c3xvsatSA9xR5GFdcyAFhwNzZhhatfdv652wBb0zHA5LDLaztGV6VMjipR
         0Ol5Hna6FYbIyYJeaF3WAYRmwRW067AMkGQo3pmTqv0QFC/OJzpo/zUGttij5ccp6XYo
         VlzA==
X-Gm-Message-State: AOAM533kenNyc5zOUMHF+3E9W4EX5EQkGZcHnv+wUfEyjBZ/tqCJ12WO
        rRExO1YHecrCfvxsUjZeDf6zLo0zpH1yhfxIy+zxdf0lLqSbuA==
X-Google-Smtp-Source: ABdhPJzOx6jiq45fs2ZYLx83QQ39kMmHkkwk0yRdJVAXf9TWu4pDN57Rr5EWfVIDuFMrs7mAjOO5+MuCa23j79/aPRY=
X-Received: by 2002:a05:6602:1604:: with SMTP id x4mr24099249iow.84.1639177498281;
 Fri, 10 Dec 2021 15:04:58 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com> <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
In-Reply-To: <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Fri, 10 Dec 2021 23:04:47 +0000
Message-ID: <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've been trying to figure out the difference between "good" runs and
"bad" runs of gvisor. So, if I've been running the following bpftrace
onliner:

$ bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'

while also executing a single:

$ sudo runsc --platform=kvm --network=none do echo ok

So, for "good" runs the stacks are the following:

# bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'
Attaching 1 probe...
^C

@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    kvm_tdp_mmu_unmap_gfn_range+331
    kvm_unmap_gfn_range+774
    kvm_mmu_notifier_invalidate_range_start+743
    __mmu_notifier_invalidate_range_start+508
    unmap_vmas+566
    unmap_region+494
    __do_munmap+1172
    __vm_munmap+226
    __x64_sys_munmap+98
    do_syscall_64+64
    entry_SYSCALL_64_after_hwframe+68
]: 1
@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    kvm_tdp_mmu_unmap_gfn_range+331
    kvm_unmap_gfn_range+774
    kvm_mmu_notifier_invalidate_range_start+743
    __mmu_notifier_invalidate_range_start+508
    zap_page_range_single+870
    unmap_mapping_pages+434
    shmem_fallocate+2518
    vfs_fallocate+684
    __x64_sys_fallocate+181
    do_syscall_64+64
    entry_SYSCALL_64_after_hwframe+68
]: 32
@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    __kvm_tdp_mmu_zap_gfn_range+162
    kvm_tdp_mmu_zap_all+34
    kvm_mmu_zap_all+518
    kvm_mmu_notifier_release+83
    __mmu_notifier_release+420
    exit_mmap+965
    mmput+167
    do_exit+2482
    do_group_exit+236
    get_signal+1000
    arch_do_signal_or_restart+580
    exit_to_user_mode_prepare+300
    syscall_exit_to_user_mode+25
    do_syscall_64+77
    entry_SYSCALL_64_after_hwframe+68
]: 365

For "bad" runs, when I get the warning - I get this:

# bpftrace -e 'kprobe:kvm_set_pfn_dirty { @[kstack] = count(); }'
Attaching 1 probe...
^C

@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    kvm_tdp_mmu_unmap_gfn_range+331
    kvm_unmap_gfn_range+774
    kvm_mmu_notifier_invalidate_range_start+743
    __mmu_notifier_invalidate_range_start+508
    unmap_vmas+566
    unmap_region+494
    __do_munmap+1172
    __vm_munmap+226
    __x64_sys_munmap+98
    do_syscall_64+64
    entry_SYSCALL_64_after_hwframe+68
]: 1
@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    kvm_tdp_mmu_put_root+465
    mmu_free_root_page+537
    kvm_mmu_free_roots+629
    kvm_mmu_unload+28
    kvm_arch_destroy_vm+510
    kvm_put_kvm+1017
    kvm_vcpu_release+78
    __fput+516
    task_work_run+206
    do_exit+2615
    do_group_exit+236
    get_signal+1000
    arch_do_signal_or_restart+580
    exit_to_user_mode_prepare+300
    syscall_exit_to_user_mode+25
    do_syscall_64+77
    entry_SYSCALL_64_after_hwframe+68
]: 2
@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    kvm_tdp_mmu_unmap_gfn_range+331
    kvm_unmap_gfn_range+774
    kvm_mmu_notifier_invalidate_range_start+743
    __mmu_notifier_invalidate_range_start+508
    zap_page_range_single+870
    unmap_mapping_pages+434
    shmem_fallocate+2518
    vfs_fallocate+684
    __x64_sys_fallocate+181
    do_syscall_64+64
    entry_SYSCALL_64_after_hwframe+68
]: 32
@[
    kvm_set_pfn_dirty+1
    __handle_changed_spte+2535
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __handle_changed_spte+1746
    __tdp_mmu_set_spte+396
    zap_gfn_range+2229
    __kvm_tdp_mmu_zap_gfn_range+162
    kvm_tdp_mmu_zap_all+34
    kvm_mmu_zap_all+518
    kvm_mmu_notifier_release+83
    __mmu_notifier_release+420
    exit_mmap+965
    mmput+167
    do_exit+2482
    do_group_exit+236
    get_signal+1000
    arch_do_signal_or_restart+580
    exit_to_user_mode_prepare+300
    syscall_exit_to_user_mode+25
    do_syscall_64+77
    entry_SYSCALL_64_after_hwframe+68
]: 344

That is, I never get a stack with
kvm_tdp_mmu_put_root->..->kvm_set_pfn_dirty with a "good" run.
Perhaps, this may shed some light onto what is going on.

Ignat
