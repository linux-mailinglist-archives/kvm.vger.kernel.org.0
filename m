Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26EF3DC0B9
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhG3WFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:05:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhG3WFF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MBGBDXfJrYcoK/QqjYITo2GK0WNlQOndEHlJrBe9l38=;
        b=CPsYZ1Q45CwenMWgxSsUYKBr0c8IhHsOzlwny0EtbLkc6GQLcoM4LBiwfPVAB7DejMEKi/
        pApxYJ7BlpE7rqnScwtU+3NaRj6FKIonET8Ffa39WspBEap4Pt00Qp6tEc+VCktqLCuLN3
        7YOzCIKwF3JTjB5W+fwGpikKY+TolB0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-OizM_C_hPnaIibSHmC9y-Q-1; Fri, 30 Jul 2021 18:04:58 -0400
X-MC-Unique: OizM_C_hPnaIibSHmC9y-Q-1
Received: by mail-qt1-f200.google.com with SMTP id m22-20020a05622a1196b029026549e62339so5156376qtk.1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBGBDXfJrYcoK/QqjYITo2GK0WNlQOndEHlJrBe9l38=;
        b=LDqo2ATuMeC5p0iuSwO2QdsFSDao3tcUFOvnF8WCKZhblS2gOTGJfJzs9CWoSOF62N
         s8zwZLnKh/sXonYRbuS04HPLADMxZnDbqBl0bbrrU5SrNoZl3F30QVH4DARgRVG/WByn
         oHliZAzZl7Y0e5EczP7l8yDeNNc9ZXWDJTp4h2FYAxx6Ze08wVTFbjaSaiA5G+P3iL+n
         dYoet8i+7Vne0UzQjEnNwfR2KPkg8mSO1AgcAoBjLBo1VCkxGRyEzYTInG4HXlK12fz0
         3+2WTk3GHo+WI3i1ebc4q2ma2q4oreZqJ+9kOyV7aiI6KSSKJJkUfew26mdlQCcdhliE
         Pulw==
X-Gm-Message-State: AOAM533mF+EP3jbWqHhpN1Yq8RXpb1uueV2e1/g8msYg/9vhj/C0RoBM
        eVTBNEqq2+51wzkrnBRg9us1V7rWP4se5E7l33LFg0K/bOBiv9QA45n/JNPnwyNXAiFoOb/s+fV
        aTdqBpzxdGsx9AGxuNkq3egFztE+oViDNpaRa8sbAP4TJUUGxvDnJaq/VqN52FQ==
X-Received: by 2002:a37:a907:: with SMTP id s7mr4426112qke.247.1627682697695;
        Fri, 30 Jul 2021 15:04:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2VCrDGvftm5L4TvkacltSQIYM1l6sE/2yJgSmuDyiEDf3IhZDUxwILuRPsvD5f5MfbbEaXg==
X-Received: by 2002:a37:a907:: with SMTP id s7mr4426079qke.247.1627682697338;
        Fri, 30 Jul 2021 15:04:57 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm1199651qtx.45.2021.07.30.15.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:04:56 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/7] KVM: X86: Some light optimizations on rmap logic
Date:   Fri, 30 Jul 2021 18:04:48 -0400
Message-Id: <20210730220455.26054-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Major change to v3 is to address comments from Sean.=0D
=0D
Since I retested the two relevant patches and the numbers changed slightly,=
 I=0D
updated the numbers in the two optimization patches to reflect that.  In th=
e=0D
latest measurement the 3->15 slots change showed more effect on the speedup=
.=0D
Summary:=0D
=0D
        Vanilla:      473.90 (+-5.93%)=0D
        3->15 slots:  366.10 (+-4.94%)=0D
        Add counter:  351.00 (+-3.70%)=0D
=0D
All the numbers are also updated in the commit messages.=0D
=0D
To apply the series upon kvm/queue, below patches should be replaced by the=
=0D
corresponding patches in this v3:=0D
=0D
        KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger=0D
        KVM: X86: Optimize pte_list_desc with per-array counter=0D
        KVM: X86: Optimize zapping rmap=0D
=0D
The 1st oneliner patch needs to be replaced because the commit message is=0D
updated with the new numbers so to align all the numbers, the 2nd-3rd patch=
es=0D
are for addressing Sean's comments and also with the new numbers.=0D
=0D
I didn't repost the initial two patches because they're already in kvm/queu=
e=0D
and they'll be identical in content.  Please have a look, thanks.=0D
=0D
v2: https://lore.kernel.org/kvm/20210625153214.43106-1-peterx@redhat.com/=0D
v1: https://lore.kernel.org/kvm/20210624181356.10235-1-peterx@redhat.com/=0D
=0D
-- original cover letter --=0D
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
Peter Xu (7):=0D
  KVM: Allow to have arch-specific per-vm debugfs files=0D
  KVM: X86: Introduce pte_list_count() helper=0D
  KVM: X86: Introduce kvm_mmu_slot_lpages() helpers=0D
  KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file=0D
  KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger=0D
  KVM: X86: Optimize pte_list_desc with per-array counter=0D
  KVM: X86: Optimize zapping rmap=0D
=0D
 arch/x86/kvm/mmu/mmu.c          |  98 +++++++++++++++++-------=0D
 arch/x86/kvm/mmu/mmu_internal.h |   1 +=0D
 arch/x86/kvm/x86.c              | 130 +++++++++++++++++++++++++++++++-=0D
 include/linux/kvm_host.h        |   1 +=0D
 virt/kvm/kvm_main.c             |  20 ++++-=0D
 5 files changed, 221 insertions(+), 29 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

