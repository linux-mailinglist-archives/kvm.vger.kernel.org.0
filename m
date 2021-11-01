Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C27442308
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhKAWLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhKAWLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mg126+9me9ZhZB/Tacp08IAkZeaGvGDXykNGOzkIohU=;
        b=c7aQMpuUKLGHl8F6UHs9Y03QUwYa7eFSRXuM8mF63VBvwTP+DujK5XsuRnyJrqvKTSzRpd
        VYtuGiQmH4i2IpyLp9/2HghZ9gqUPbF7z5il/1rDGYtLDQWthKG/S5fBVcESEc/xCNdkkx
        Ds1IEOgUH+ZF/+MXRTt+LJFkR6Y3rKw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-A_54PQ-wMGS5MYKXYLy_zw-1; Mon, 01 Nov 2021 18:09:15 -0400
X-MC-Unique: A_54PQ-wMGS5MYKXYLy_zw-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so3785807wro.18
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mg126+9me9ZhZB/Tacp08IAkZeaGvGDXykNGOzkIohU=;
        b=MP7PHjtkv9KjQJH/a63ZpBdTyzGxc7fA9ipGfXkVvNkd/OLXwcAwyKu+SeNb3ZDhMv
         R4SNC55d8EKxaq5Uigr4N6L1n0KdP+rkkb0J+l1XWmB74+gD7zeyz/z4lgHc0uGsFcYl
         bdV+eVZFWEmA1fz9J2QtG2fiJ2kxb0fiWmbtB5Tcmu7pAmkyOR/B+VmcyCDPHJKd/sSG
         GxI2G57UqL/8m0cDxwDHNRY2Zy3M4sPLlt0wWM9UOo/pTLbLvFz+XHFBLg+9UCOW6etb
         IAhFXk7QUlD1MhmrhWw7Qdd4lJUCPj3tsPfOlvl4rbGrWwXw0eCKA5Mvn1gTkRTL0tMt
         eHNg==
X-Gm-Message-State: AOAM53016Ov1WTh+H+MU5h7sfAz8Mk2mLgw5olBQjdlmKE1TbepTTILQ
        dOkRs6pVicZU5uSjB4ybPwoY9HE81lsR1WNtAhgJ9NlwKTCU1vckDL6z0Vxhhxn2qJBSKBpkbDU
        JiQpEtcfKdcA6
X-Received: by 2002:a5d:6e8c:: with SMTP id k12mr40207221wrz.401.1635804554336;
        Mon, 01 Nov 2021 15:09:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiYqS6XG9xwq0Xi+0IIDYOMlQDxPDwjRqxs0xc44YT7VvgO+jFUiosfcGK1mj6k1mDxUBPBw==
X-Received: by 2002:a5d:6e8c:: with SMTP id k12mr40207187wrz.401.1635804554086;
        Mon, 01 Nov 2021 15:09:14 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id i15sm630121wmb.20.2021.11.01.15.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:13 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 00/20] Migration 20211031 patches
Date:   Mon,  1 Nov 2021 23:08:52 +0100
Message-Id: <20211101220912.10039-1-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit af531756d25541a1b3b3d9a14e72e7fedd941a2e=
:=0D
=0D
  Merge remote-tracking branch 'remotes/philmd/tags/renesas-20211030' into =
staging (2021-10-30 11:31:41 -0700)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://github.com/juanquintela/qemu.git tags/migration-20211031-pull-req=
uest=0D
=0D
for you to fetch changes up to 826b8bc80cb191557a4ce7cf0e155b436d2d1afa:=0D
=0D
  migration/dirtyrate: implement dirty-bitmap dirtyrate calculation (2021-1=
1-01 22:56:44 +0100)=0D
=0D
----------------------------------------------------------------=0D
Migration Pull request=0D
=0D
Hi=0D
=0D
this includes pending bits of migration patches.=0D
=0D
- virtio-mem support by David Hildenbrand=0D
- dirtyrate improvements by Hyman Huang=0D
- fix rdma wrid by Li Zhijian=0D
- dump-guest-memory fixes by Peter Xu=0D
=0D
Pleas apply.=0D
=0D
Thanks, Juan.=0D
=0D
----------------------------------------------------------------=0D
=0D
David Hildenbrand (8):=0D
  memory: Introduce replay_discarded callback for RamDiscardManager=0D
  virtio-mem: Implement replay_discarded RamDiscardManager callback=0D
  migration/ram: Handle RAMBlocks with a RamDiscardManager on the=0D
    migration source=0D
  virtio-mem: Drop precopy notifier=0D
  migration/postcopy: Handle RAMBlocks with a RamDiscardManager on the=0D
    destination=0D
  migration: Simplify alignment and alignment checks=0D
  migration/ram: Factor out populating pages readable in=0D
    ram_block_populate_pages()=0D
  migration/ram: Handle RAMBlocks with a RamDiscardManager on background=0D
    snapshots=0D
=0D
Hyman Huang(=C3=A9=C2=BB=E2=80=9E=C3=A5=E2=80=B9=E2=80=A1) (6):=0D
  KVM: introduce dirty_pages and kvm_dirty_ring_enabled=0D
  memory: make global_dirty_tracking a bitmask=0D
  migration/dirtyrate: introduce struct and adjust DirtyRateStat=0D
  migration/dirtyrate: adjust order of registering thread=0D
  migration/dirtyrate: move init step of calculation to main thread=0D
  migration/dirtyrate: implement dirty-ring dirtyrate calculation=0D
=0D
Hyman Huang(=E9=BB=84=E5=8B=87) (2):=0D
  memory: introduce total_dirty_pages to stat dirty pages=0D
  migration/dirtyrate: implement dirty-bitmap dirtyrate calculation=0D
=0D
Li Zhijian (1):=0D
  migration/rdma: Fix out of order wrid=0D
=0D
Peter Xu (3):=0D
  migration: Make migration blocker work for snapshots too=0D
  migration: Add migrate_add_blocker_internal()=0D
  dump-guest-memory: Block live migration=0D
=0D
 qapi/migration.json            |  48 ++++-=0D
 include/exec/memory.h          |  41 +++-=0D
 include/exec/ram_addr.h        |  13 +-=0D
 include/hw/core/cpu.h          |   1 +=0D
 include/hw/virtio/virtio-mem.h |   3 -=0D
 include/migration/blocker.h    |  16 ++=0D
 include/sysemu/kvm.h           |   1 +=0D
 migration/dirtyrate.h          |  21 +-=0D
 migration/ram.h                |   1 +=0D
 accel/kvm/kvm-all.c            |   7 +=0D
 accel/stubs/kvm-stub.c         |   5 +=0D
 dump/dump.c                    |  19 ++=0D
 hw/i386/xen/xen-hvm.c          |   4 +-=0D
 hw/virtio/virtio-mem.c         |  92 ++++++---=0D
 migration/dirtyrate.c          | 367 ++++++++++++++++++++++++++++++---=0D
 migration/migration.c          |  30 +--=0D
 migration/postcopy-ram.c       |  40 +++-=0D
 migration/ram.c                | 180 ++++++++++++++--=0D
 migration/rdma.c               | 138 +++++++++----=0D
 softmmu/memory.c               |  43 +++-=0D
 hmp-commands.hx                |   8 +-=0D
 migration/trace-events         |   2 +=0D
 softmmu/trace-events           |   1 +=0D
 23 files changed, 909 insertions(+), 172 deletions(-)=0D
=0D
-- =0D
2.33.1=0D
=0D

