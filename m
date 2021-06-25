Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9413B46A1
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFYPek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:34:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFYPek (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ItRg8jkcuxeEzGWTWK3XoenthbGrIhvCHt+k1314tFE=;
        b=XGc93YOka2gnnTD2XZ13W/EKmSr/+VH3VxMyPsMPBmiIs9ZKWWbAs0FxkxBT0yNTklQ1IH
        njWE2f5IMV3bGtU5rKo4Y4mg2Ibv0mUNOQwCWxreFZvGhBnauRCkNBi6h5io1+HwajOD+o
        5+eDLYeVZAcpfwsG3sRS663SV/hEWKo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-wbThIoWeOTORmteGDKD64Q-1; Fri, 25 Jun 2021 11:32:17 -0400
X-MC-Unique: wbThIoWeOTORmteGDKD64Q-1
Received: by mail-io1-f69.google.com with SMTP id v21-20020a5d90550000b0290439ea50822eso7253688ioq.9
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ItRg8jkcuxeEzGWTWK3XoenthbGrIhvCHt+k1314tFE=;
        b=jE+qpQHM75fl6W8Tc7J8vw9fqKkC86S4dP4BiJMURfZ0XDNV6B/K8ZyXtg+l1RTXfz
         Xs9CqO9uMaqrDggMyi4gezOsqVmIf1ZyLLqnaPfLnVQRd/1zInOTqvYrZ7n5XVNUmt7u
         Zv4j52pLbcUmMGeQG4FFUNr/rDHjAZZgCwS2cDJd2R/7GE7iRZhka43Zc4J5JdCrgjyf
         Tl4g6vZJIFxC8z0GRRXne/bbanegLH5ELXUIoten3E0vK2uWR76sGFkkptYpu9MEJYZc
         obMSup3UNL14vrNOw9P0KHDAVMf7QicQxEA7zbeBuMcHBPIgsGMck2z7xahzqh4F91Sp
         JOgw==
X-Gm-Message-State: AOAM531CczHF4xJ3xMR9lUqYlwhnVG/1ovvlg5A09m8LNkBI4A3aBzJ7
        CQvRv8ZqadD8SfcdHnCccRD7m8fPcUiV2cVq/l+JHtGZiV0q4cdF5A58OvvaqJh1ruMiLtJ7uVw
        gvGMb730Ss+JC
X-Received: by 2002:a6b:b215:: with SMTP id b21mr8939071iof.165.1624635136859;
        Fri, 25 Jun 2021 08:32:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy57ROZRgcj3/oPzMmmF/73LyGB+DwoPD927WJAedYRtWlcrmifhtRMLdmkY8DZuHdCB48mYA==
X-Received: by 2002:a6b:b215:: with SMTP id b21mr8939052iof.165.1624635136596;
        Fri, 25 Jun 2021 08:32:16 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id s8sm3668772ilj.51.2021.06.25.08.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:32:15 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/9] KVM: X86: Some light optimizations on rmap logic
Date:   Fri, 25 Jun 2021 11:32:05 -0400
Message-Id: <20210625153214.43106-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:=0D
- Rebased to kvm-queue since I found quite a few conflicts already=0D
- Add an example into patch commit message of "KVM: X86: Introduce=0D
  mmu_rmaps_stat per-vm debugfs file"=0D
- Cleanup more places in patch "KVM: X86: Optimize pte_list_desc with per-a=
rray=0D
  counter" and squashed=0D
=0D
All things started from patch 1, which introduced a new statistic to keep "=
max=0D
rmap entry count per vm".  At that time I was just curious about how many r=
map=0D
is there normally for a guest, and it surprised me a bit.=0D
=0D
For TDP mappings it's all fine as mostly rmap of a page is either 0 or 1=0D
depending on faulted or not.  It turns out with EPT=3DN there seems to be a=
 huge=0D
number of pages that can have tens or hundreds of rmap entries even for an =
idle=0D
guest.  Then I continued with the rest.=0D
=0D
To understand better on "how much of those pages", I did patch 2-6 which=0D
introduced the idea of per-arch per-vm debugfs nodes, and added a debug fil=
e to=0D
do statistics for rmap, which is similar to kvm_arch_create_vcpu_debugfs() =
but=0D
for vm not vcpu.=0D
=0D
I did notice this should be the clean approach as I also see other archs=0D
randomly create some per-vm debugfs nodes there:=0D
=0D
---8<---=0D
*** arch/arm64/kvm/vgic/vgic-debug.c:=0D
vgic_debug_init[274]           debugfs_create_file("vgic-state", 0444, kvm-=
>debugfs_dentry, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_64_mmu_hv.c:=0D
kvmppc_mmu_debugfs_init[2115]  debugfs_create_file("htab", 0400, kvm->arch.=
debugfs_dir, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_64_mmu_radix.c:=0D
kvmhv_radix_debugfs_init[1434] debugfs_create_file("radix", 0400, kvm->arch=
.debugfs_dir, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_hv.c:=0D
debugfs_vcpu_init[2395]        debugfs_create_file("timings", 0444, vcpu->a=
rch.debugfs_dir, vcpu,=0D
=0D
*** arch/powerpc/kvm/book3s_xics.c:=0D
xics_debugfs_init[1027]        xics->dentry =3D debugfs_create_file(name, 0=
444, powerpc_debugfs_root,=0D
=0D
*** arch/powerpc/kvm/book3s_xive.c:=0D
xive_debugfs_init[2236]        xive->dentry =3D debugfs_create_file(name, S=
_IRUGO, powerpc_debugfs_root,=0D
=0D
*** arch/powerpc/kvm/timing.c:=0D
kvmppc_create_vcpu_debugfs[214] debugfs_file =3D debugfs_create_file(dbg_fn=
ame, 0666, kvm_debugfs_dir,=0D
---8<---=0D
=0D
PPC even has its own per-vm dir for that.  I think if patch 2-6 can be=0D
considered to be accepted then the next thing to consider is to merge all t=
hese=0D
usages to be under the same existing per-vm dentry with their per-arch hook=
s=0D
introduced.=0D
=0D
The last 3 patches (patch 7-9) are a few optimizations of existing rmap log=
ic.=0D
The major test case I used is rmap_fork [1], however it's not really the id=
eal=0D
one to show their effect for sure as that test I wrote covers both=0D
rmap_add/remove, while I don't have good idea on optimizing rmap_remove wit=
hout=0D
changing the array structure or adding much overhead (e.g. sort the array, =
or=0D
making a tree-like structure somehow to replace the array list).  However i=
t=0D
already shows some benefit with those changes, so I post them out.=0D
=0D
Applying patch 7-8 will bring a summary of 38% perf boost when I fork 500=0D
childs with the test I used.  Didn't run perf test on patch 9.  More in the=
=0D
commit log.=0D
=0D
Please review, thanks.=0D
=0D
[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92=
281efe5b3=0D
=0D
Peter Xu (9):=0D
  KVM: X86: Add per-vm stat for max rmap list size=0D
  KVM: Introduce kvm_get_kvm_safe()=0D
  KVM: Allow to have arch-specific per-vm debugfs files=0D
  KVM: X86: Introduce pte_list_count() helper=0D
  KVM: X86: Introduce kvm_mmu_slot_lpages() helpers=0D
  KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file=0D
  KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger=0D
  KVM: X86: Optimize pte_list_desc with per-array counter=0D
  KVM: X86: Optimize zapping rmap=0D
=0D
 arch/x86/include/asm/kvm_host.h |   1 +=0D
 arch/x86/kvm/mmu/mmu.c          |  97 +++++++++++++++++------=0D
 arch/x86/kvm/mmu/mmu_internal.h |   1 +=0D
 arch/x86/kvm/x86.c              | 131 +++++++++++++++++++++++++++++++-=0D
 include/linux/kvm_host.h        |   2 +=0D
 virt/kvm/kvm_main.c             |  37 +++++++--=0D
 6 files changed, 235 insertions(+), 34 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

