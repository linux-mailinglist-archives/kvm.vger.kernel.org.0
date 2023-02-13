Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DD7693C7D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjBMCws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMCwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:52:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F168210246
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pC2ZnjMJdJjJjZ5Np3ZMrGQc2xmkYS+iq9hqw7xz0hw=;
        b=h86eueDPdZMWjGNxltdDmX2sjOBGJPH3AbRE8s+V8AVS9kHOmRIhjUEi1XwjEt33mQoiQf
        PgNFof9+dt7Rcej5IpOyoULdiZmEv8UG9DsvKFAjuU7nRHaDLbH5Cu/ntIhETvGvezuzth
        Ylu8c2NIqACwtiGnytJAFam/qJRgwzM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-5qtmKVL9MrKJQjgh1r0MVg-1; Sun, 12 Feb 2023 21:51:53 -0500
X-MC-Unique: 5qtmKVL9MrKJQjgh1r0MVg-1
Received: by mail-wr1-f72.google.com with SMTP id r11-20020a5d498b000000b002c5588d962fso117743wrq.10
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:51:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC2ZnjMJdJjJjZ5Np3ZMrGQc2xmkYS+iq9hqw7xz0hw=;
        b=pNfy5fagWIBtBZhtZ1Ep4csodIKQctffyzQQ1HgybVZcRLaayM56gBavR2L9b4sl5s
         ZTwJVweQu/AKwC5XGn+YCZowxoRsglW+C9HkFlGklTt9ZaZNLm0nSBW0IE/297bqWeKw
         fhfQm2vtY3JIbu6++OUkNFIRL1S5mm39gHakvGtrhYuwn72zfb+XeUFDtV5i9TgHhE6X
         qbdfI1dpfWrBrVOSC+ZmdrKFUN82A+WFF4IgchIGS8qQusLn0DBqogqPTYwurOL2n2ap
         Hg4uVIM1wdsSRFmEME/YDH9pcWd0koqsxgKtXOTsVcCaT9wYn/9oo1/IjTkh8PUqC6Nj
         sBBA==
X-Gm-Message-State: AO0yUKXo8a1OivP5S+biUsx83xVoK99jkHFes19yxnOMLOhXiM8dU7Gj
        Efvg2ao0Suce/uqcX8myiRkUzL2uku1wpaZlLum7nVmO8DWi/6/cyGEoDS2T6n0+d/irzVBVNi3
        l3wO7b/Mrw2at
X-Received: by 2002:a5d:40cd:0:b0:2c5:58fb:fa8e with SMTP id b13-20020a5d40cd000000b002c558fbfa8emr1161466wrq.32.1676256712694;
        Sun, 12 Feb 2023 18:51:52 -0800 (PST)
X-Google-Smtp-Source: AK7set+SBDVTC0JeY9Pojcu0wdzQt5TU/5D1VbnnqJ33QYdv5laHLc/Jy/D6TvzjDPPK0Q7UBYMB1g==
X-Received: by 2002:a5d:40cd:0:b0:2c5:58fb:fa8e with SMTP id b13-20020a5d40cd000000b002c558fbfa8emr1161461wrq.32.1676256712496;
        Sun, 12 Feb 2023 18:51:52 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id i2-20020adfefc2000000b002c553e061fdsm2866896wrp.112.2023.02.12.18.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:51:51 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Li Xiaohui <xiaohli@redhat.com>
Subject: [PULL 00/22] Migration 20230213 patches
Date:   Mon, 13 Feb 2023 03:51:28 +0100
Message-Id: <20230213025150.71537-1-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 3b33ae48ec28e1e0d1bc28a85c7423724bcb1a2c:

  Merge tag 'block-pull-request' of https://gitlab.com/stefanha/qemu into staging (2023-02-09 15:29:14 +0000)

are available in the Git repository at:

  https://gitlab.com/juan.quintela/qemu.git tags/migration-20230213-pull-request

for you to fetch changes up to 7b548761e5d084f2fc0fc4badebab227b51a8a84:

  ram: Document migration ram flags (2023-02-13 03:45:47 +0100)

----------------------------------------------------------------
Migration Pull request (take3)

Hi

In this PULL request:
- Added to leonardo fixes:
Fixes: b5eea99ec2 ("migration: Add yank feature")
Reported-by: Li Xiaohui <xiaohli@redhat.com>

Please apply.

[take 2]
- rebase to latest upstream
- fix compilation of linux-user (if have_system was missing) (me)
- cleanup multifd_load_cleanup(leonardo)
- Document RAM flags (me)

Please apply.

[take 1]
This are all the reviewed patches for migration:
- AVX512 support for xbzrle (Ling Xu)
- /dev/userfaultd support (Peter Xu)
- Improve ordering of channels (Peter Xu)
- multifd cleanups (Li Zhang)
- Remove spurious files from last merge (me)
  Rebase makes that to you
- Fix mixup between state_pending_{exact,estimate} (me)
- Cache RAM size during migration (me)
- cleanup several functions (me)

Please apply.

----------------------------------------------------------------

Juan Quintela (8):
  migration: Remove spurious files
  migration: Simplify ram_find_and_save_block()
  migration: Make find_dirty_block() return a single parameter
  migration: Split ram_bytes_total_common() in two functions
  migration: Calculate ram size once
  migration: Make ram_save_target_page() a pointer
  migration: I messed state_pending_exact/estimate
  ram: Document migration ram flags

Leonardo Bras (4):
  migration/multifd: Change multifd_load_cleanup() signature and usage
  migration/multifd: Remove unnecessary assignment on
    multifd_load_cleanup()
  migration/multifd: Join all multifd threads in order to avoid leaks
  migration/multifd: Move load_cleanup inside incoming_state_destroy

Li Zhang (2):
  multifd: cleanup the function multifd_channel_connect
  multifd: Remove some redundant code

Peter Xu (6):
  linux-headers: Update to v6.1
  util/userfaultfd: Support /dev/userfaultfd
  migration: Rework multi-channel checks on URI
  migration: Cleanup postcopy_preempt_setup()
  migration: Add a semaphore to count PONGs
  migration: Postpone postcopy preempt channel to be after main

ling xu (2):
  AVX512 support for xbzrle_encode_buffer
  Update bench-code for addressing CI problem

 .../x86_64-quintela-devices.mak               |    7 -
 .../x86_64-quintela2-devices.mak              |    6 -
 meson.build                                   |   17 +
 include/standard-headers/drm/drm_fourcc.h     |   34 +-
 include/standard-headers/linux/ethtool.h      |   63 +-
 include/standard-headers/linux/fuse.h         |    6 +-
 .../linux/input-event-codes.h                 |    1 +
 include/standard-headers/linux/virtio_blk.h   |   19 +
 linux-headers/asm-generic/hugetlb_encode.h    |   26 +-
 linux-headers/asm-generic/mman-common.h       |    2 +
 linux-headers/asm-mips/mman.h                 |    2 +
 linux-headers/asm-riscv/kvm.h                 |    4 +
 linux-headers/linux/kvm.h                     |    1 +
 linux-headers/linux/psci.h                    |   14 +
 linux-headers/linux/userfaultfd.h             |    4 +
 linux-headers/linux/vfio.h                    |  142 ++
 migration/migration.h                         |   15 +-
 migration/multifd.h                           |    3 +-
 migration/postcopy-ram.h                      |    4 +-
 migration/xbzrle.h                            |    4 +
 migration/migration.c                         |  138 +-
 migration/multifd.c                           |   87 +-
 migration/postcopy-ram.c                      |   31 +-
 migration/ram.c                               |  148 +-
 migration/savevm.c                            |   56 +-
 migration/xbzrle.c                            |  124 ++
 tests/bench/xbzrle-bench.c                    |  469 ++++++
 tests/unit/test-xbzrle.c                      |   39 +-
 util/userfaultfd.c                            |   32 +
 meson_options.txt                             |    2 +
 migration/multifd.c.orig                      | 1274 -----------------
 scripts/meson-buildoptions.sh                 |    3 +
 tests/bench/meson.build                       |    6 +
 util/trace-events                             |    1 +
 34 files changed, 1278 insertions(+), 1506 deletions(-)
 delete mode 100644 configs/devices/x86_64-softmmu/x86_64-quintela-devices.mak
 delete mode 100644 configs/devices/x86_64-softmmu/x86_64-quintela2-devices.mak
 create mode 100644 tests/bench/xbzrle-bench.c
 delete mode 100644 migration/multifd.c.orig

-- 
2.39.1

