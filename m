Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C668C6C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfGONve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732095AbfGONvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:51:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6037F3DE0E;
        Mon, 15 Jul 2019 13:51:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 798FA5D705;
        Mon, 15 Jul 2019 13:51:30 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PULL 00/21] Migration pull request
Date:   Mon, 15 Jul 2019 15:51:04 +0200
Message-Id: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 15 Jul 2019 13:51:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit b9404bf592e7ba74180e1a54ed7a266ec6ee67f2:

  Merge remote-tracking branch 'remotes/dgilbert/tags/pull-hmp-20190715' into staging (2019-07-15 12:22:07 +0100)

are available in the Git repository at:

  https://github.com/juanquintela/qemu.git tags/migration-pull-request

for you to fetch changes up to 40c4d4a835453452a262f32450a0449886aa19ce:

  migration: always initial RAMBlock.bmap to 1 for new migration (2019-07-15 15:47:47 +0200)

----------------------------------------------------------------
Pull request:
- update last pull requset
- drop multifd test: For some reason, 32bit and a packed struct are
  giving me too much trouble.  Still investigating.
- New fixes from upstream.

----------------------------------------------------------------

Ivan Ren (1):
  migration: always initial RAMBlock.bmap to 1 for new migration

Juan Quintela (2):
  migration: fix multifd_recv event typo
  migration-test: rename parameter to parameter_int

Peng Tao (1):
  migration: allow private destination ram with x-ignore-shared

Peter Xu (10):
  migration: No need to take rcu during sync_dirty_bitmap
  memory: Don't set migration bitmap when without migration
  bitmap: Add bitmap_copy_with_{src|dst}_offset()
  memory: Pass mr into snapshot_and_clear_dirty
  memory: Introduce memory listener hook log_clear()
  kvm: Update comments for sync_dirty_bitmap
  kvm: Persistent per kvmslot dirty bitmap
  kvm: Introduce slots lock for memory listener
  kvm: Support KVM_CLEAR_DIRTY_LOG
  migration: Split log_clear() into smaller chunks

Wei Yang (7):
  migration/multifd: call multifd_send_sync_main when sending
    RAM_SAVE_FLAG_EOS
  migration/xbzrle: update cache and current_data in one place
  cutils: remove one unnecessary pointer operation
  migration/multifd: sync packet_num after all thread are done
  migration/ram.c: reset complete_round when we gets a queued page
  migration/postcopy: fix document of postcopy_send_discard_bm_ram()
  migration/postcopy: remove redundant cpu_synchronize_all_post_init

 accel/kvm/kvm-all.c      | 260 ++++++++++++++++++++++++++++++++++++---
 accel/kvm/trace-events   |   1 +
 exec.c                   |  15 ++-
 include/exec/memory.h    |  19 +++
 include/exec/ram_addr.h  |  92 +++++++++++++-
 include/qemu/bitmap.h    |   9 ++
 include/sysemu/kvm_int.h |   4 +
 memory.c                 |  56 ++++++++-
 migration/migration.c    |   4 +
 migration/migration.h    |  27 ++++
 migration/ram.c          | 113 ++++++++++++-----
 migration/savevm.c       |   1 -
 migration/trace-events   |   3 +-
 tests/Makefile.include   |   2 +
 tests/migration-test.c   |  55 +++++----
 tests/test-bitmap.c      |  72 +++++++++++
 util/bitmap.c            |  85 +++++++++++++
 util/cutils.c            |   8 +-
 18 files changed, 732 insertions(+), 94 deletions(-)
 create mode 100644 tests/test-bitmap.c

-- 
2.21.0

