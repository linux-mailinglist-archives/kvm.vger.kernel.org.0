Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DC858503D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiG2NBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiG2NBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:01:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 663F112096
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3utgSvQfMq03l7uQecO5/SPtc3uVxdHvSsFddtaOGHc=;
        b=B6qqlQmvRS53gUIzOgkithmwFSjSF4raMhvlZa+N0Ep2gkKDxSx2Pn2P6hvmBh4cPRerja
        ASU8WYUxqxC8efgFBINBDaCW2xpuqqgim3Fti9sBtVUhtsy8RaNJRTm05C6sJ0WLaD7tmU
        026WGdaZ531trKk5prWhMhK5mlK7/ss=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-BUzEnK9KNgWeHPsWpcehig-1; Fri, 29 Jul 2022 09:01:01 -0400
X-MC-Unique: BUzEnK9KNgWeHPsWpcehig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE925811E7A;
        Fri, 29 Jul 2022 13:01:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 974892026D07;
        Fri, 29 Jul 2022 13:00:49 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [RFC v2 00/10] Introduce an extensible static analyzer
Date:   Fri, 29 Jul 2022 14:00:29 +0100
Message-Id: <20220729130040.1428779-1-afaria@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces a static analyzer for QEMU. It consists of a
single static-analyzer.py script that relies on libclang's Python
bindings, and provides a common framework on which arbitrary static
analysis checks can be developed and run against QEMU's code base.

Summary of the series:

  - Patch 1 adds the base static analyzer, along with a simple check
    that finds static functions whose return value is never used, and
    patch 2 fixes many occurrences of this.

  - Patch 3 introduces support for output-comparison check tests, and
    adds some tests to the abovementioned check.

  - Patch 4 makes the analyzer skip checks on a translation unit when it
    hasn't been modified since the last time those checks passed.

  - Patch 5 adds a check to ensure that non-coroutine_fn functions don't
    perform direct calls to coroutine_fn functions, and patch 6 fixes
    some violations of this rule.

  - Patch 7 adds a check to ensure that operations on coroutine_fn
    pointers make sense, like assignment and indirect calls, and patch 8
    fixes some problems detected by the check. (Implementing this check
    properly is complicated, since AFAICT annotation attributes cannot
    be applied directly to types. This part still needs a lot of work.)

  - Patch 9 introduces a no_coroutine_fn marker for functions that
    should not be called from coroutines, makes generated_co_wrapper
    evaluate to no_coroutine_fn, and adds a check enforcing this rule.
    Patch 10 fixes some violations that it finds.

The current primary motivation for this work is enforcing rules around
block layer coroutines, which is why most of the series focuses on that.
However, the static analyzer is intended to be sufficiently generic to
satisfy other present and future QEMU static analysis needs.

Performance isn't great, but with some more optimization, the analyzer
should be fast enough to be used iteratively during development, given
that it avoids reanalyzing unmodified translation units, and that users
can restrict the set of translation units under consideration. It should
also be fast enough to run in CI (?).

Consider a small QEMU configuration and build (all commands were run on
the same 12-thread laptop):

    $ cd build && time ../configure --target-list=x86_64-softmmu && cd ..
    [...]

    real    0m17.232s
    user    0m13.261s
    sys     0m3.895s

    $ time make -C build -j $(nproc) all
    [...]

    real    2m39.029s
    user    14m49.370s
    sys     1m57.364s

    $ time make -C build -j $(nproc) check
    [...]

    real    2m46.349s
    user    6m4.718s
    sys     4m15.660s

We can run the static analyzer against all translation units enabled in
this configuration:

    $ time ./static-analyzer.py build
    util/qemu-coroutine.c:122:23: non-coroutine_fn function calls coroutine_fn qemu_coroutine_self()
    io/channel.c:152:17: non-coroutine_fn function calls coroutine_fn qio_channel_yield()
    [...]
    Analyzed 1649 translation units in 520.3 seconds.

    real    8m42.342s
    user    95m51.759s
    sys     0m21.576s

You will need libclang's Python bindings to run this. Try `dnf install
python3-clang` or `apt install python3-clang`.

It takes around 1 to 2 seconds for the analyzer to load the compilation
database, determine which translation units to analyze, etc. The
durations reported by the analyzer itself don't include those steps,
which is why they differ from what `time` reports.

We can also analyze only some of the translation units:

    $ time ./static-analyzer.py build block
    block/raw-format.c:420:12: non-coroutine_fn function calls coroutine_fn bdrv_co_ioctl()
    block/blkverify.c:266:12: non-coroutine_fn function calls coroutine_fn bdrv_co_flush()
    [...]
    Analyzed 21 translation units (58 other were up-to-date) in 5.8 seconds.

    real    0m7.031s
    user    0m40.951s
    sys     0m1.299s

Since the previous command had already analyzed all translation units,
only the ones that had problems were reanalyzed.

Now skipping all the actual checks, but still parsing and building the
AST for each translation unit, and adding --force to reanalyze all
translation units:

    $ time ./static-analyzer.py build --force --skip-checks
    Analyzed 1649 translation units in 41.2 seconds.

    real    0m42.296s
    user    7m14.256s
    sys     0m15.803s

And now running a single check:

    $ time ./static-analyzer.py build --force --check return-value-never-used
    Analyzed 1649 translation units in 157.6 seconds.

    real    2m38.759s
    user    29m28.930s
    sys     0m17.968s

TODO:
  - Run in GitLab CI (?).
  - Finish the "coroutine_fn" check.
  - Add check tests where missing.
  - Avoid redundant AST traversals while keeping checks modular.
  - More optimization.

v2:
  - Fix parsing of compilation database commands.
  - Reorganize checks and split them into separate modules.
  - Make "return-value-never-used" ignore __attribute__((unused)) funcs.
  - Add a visitor() abstraction wrapping clang_visitChildren() that is
    faster than using Cursor.get_children() with recursion.
  - Add support for implementing tests for checks, and add some tests to
    "return-value-never-used".
  - Use dependency information provided by Ninja to skip checks on
    translation units that haven't been modified since they last passed
    those checks.
  - Ignore translation units from git submodules.
  - And more.

Alberto Faria (10):
  Add an extensible static analyzer
  Drop unused static function return values
  static-analyzer: Support adding tests to checks
  static-analyzer: Avoid reanalyzing unmodified translation units
  static-analyzer: Enforce coroutine_fn restrictions for direct calls
  Fix some direct calls from non-coroutine_fn to coroutine_fn
  static-analyzer: Enforce coroutine_fn restrictions on function
    pointers
  Fix some bad coroutine_fn indirect calls and pointer assignments
  block: Add no_coroutine_fn marker
  Fix some calls from coroutine_fn to no_coroutine_fn

 accel/kvm/kvm-all.c                        |  12 +-
 accel/tcg/plugin-gen.c                     |   9 +-
 accel/tcg/translate-all.c                  |   9 +-
 audio/audio.c                              |   5 +-
 block.c                                    |   2 +-
 block/backup.c                             |   2 +-
 block/block-copy.c                         |   4 +-
 block/commit.c                             |   2 +-
 block/dirty-bitmap.c                       |   6 +-
 block/file-posix.c                         |   6 +-
 block/io.c                                 |  52 +-
 block/mirror.c                             |   4 +-
 block/monitor/block-hmp-cmds.c             |   2 +-
 block/nvme.c                               |   3 +-
 block/parallels.c                          |  28 +-
 block/qcow.c                               |  10 +-
 block/qcow2-bitmap.c                       |   6 +-
 block/qcow2-snapshot.c                     |   6 +-
 block/qcow2.c                              |  38 +-
 block/qcow2.h                              |  14 +-
 block/qed-table.c                          |   2 +-
 block/qed.c                                |  14 +-
 block/quorum.c                             |   7 +-
 block/ssh.c                                |   6 +-
 block/throttle-groups.c                    |   3 +-
 block/vdi.c                                |  17 +-
 block/vhdx.c                               |   8 +-
 block/vmdk.c                               |  11 +-
 block/vpc.c                                |   4 +-
 block/vvfat.c                              |  11 +-
 blockdev.c                                 |   2 +-
 chardev/char-ringbuf.c                     |   4 +-
 contrib/ivshmem-server/main.c              |   4 +-
 contrib/vhost-user-blk/vhost-user-blk.c    |   5 +-
 dump/dump.c                                |   4 +-
 fsdev/virtfs-proxy-helper.c                |   3 +-
 gdbstub.c                                  |  18 +-
 hw/audio/intel-hda.c                       |   7 +-
 hw/audio/pcspk.c                           |   7 +-
 hw/char/virtio-serial-bus.c                |  14 +-
 hw/display/cirrus_vga.c                    |   5 +-
 hw/hyperv/vmbus.c                          |  10 +-
 hw/i386/intel_iommu.c                      |  28 +-
 hw/i386/pc_q35.c                           |   5 +-
 hw/ide/pci.c                               |   4 +-
 hw/net/rtl8139.c                           |   3 +-
 hw/net/virtio-net.c                        |   6 +-
 hw/net/vmxnet3.c                           |   3 +-
 hw/nvme/ctrl.c                             |  17 +-
 hw/nvram/fw_cfg.c                          |   3 +-
 hw/scsi/megasas.c                          |   6 +-
 hw/scsi/mptconfig.c                        |   7 +-
 hw/scsi/mptsas.c                           |  14 +-
 hw/scsi/scsi-bus.c                         |   6 +-
 hw/usb/dev-audio.c                         |  13 +-
 hw/usb/hcd-ehci.c                          |   6 +-
 hw/usb/hcd-ohci.c                          |   4 +-
 hw/usb/hcd-xhci.c                          |  56 +-
 hw/vfio/common.c                           |  21 +-
 hw/virtio/vhost-vdpa.c                     |   3 +-
 hw/virtio/vhost.c                          |  11 +-
 hw/virtio/virtio-iommu.c                   |   4 +-
 hw/virtio/virtio-mem.c                     |   9 +-
 include/block/block-common.h               |   2 +-
 include/block/block-hmp-cmds.h             |   2 +-
 include/block/block-io.h                   |   5 +-
 include/block/block_int-common.h           |  12 +-
 include/qemu/coroutine.h                   |  43 +-
 io/channel-command.c                       |  10 +-
 migration/migration.c                      |  12 +-
 net/dump.c                                 |  16 +-
 net/vhost-vdpa.c                           |   8 +-
 qemu-img.c                                 |   6 +-
 qga/commands-posix-ssh.c                   |  10 +-
 softmmu/physmem.c                          |  18 +-
 softmmu/qtest.c                            |   5 +-
 static-analyzer.py                         | 801 +++++++++++++++++++++
 static_analyzer/__init__.py                | 348 +++++++++
 static_analyzer/coroutine_fn.py            | 280 +++++++
 static_analyzer/no_coroutine_fn.py         | 111 +++
 static_analyzer/return_value_never_used.py | 220 ++++++
 subprojects/libvduse/libvduse.c            |  12 +-
 subprojects/libvhost-user/libvhost-user.c  |  24 +-
 target/i386/host-cpu.c                     |   3 +-
 target/i386/kvm/kvm.c                      |  19 +-
 tcg/optimize.c                             |   3 +-
 tests/qtest/libqos/malloc.c                |   5 +-
 tests/qtest/libqos/qgraph.c                |   3 +-
 tests/qtest/test-x86-cpuid-compat.c        |   8 +-
 tests/qtest/virtio-9p-test.c               |   6 +-
 tests/unit/test-aio-multithread.c          |   5 +-
 tests/vhost-user-bridge.c                  |  19 +-
 ui/vnc.c                                   |  23 +-
 util/aio-posix.c                           |   7 +-
 util/uri.c                                 |  18 +-
 95 files changed, 2160 insertions(+), 519 deletions(-)
 create mode 100755 static-analyzer.py
 create mode 100644 static_analyzer/__init__.py
 create mode 100644 static_analyzer/coroutine_fn.py
 create mode 100644 static_analyzer/no_coroutine_fn.py
 create mode 100644 static_analyzer/return_value_never_used.py

-- 
2.37.1

