Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5162F7D08F3
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376365AbjJTG7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376317AbjJTG7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D884D4C
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nAfeS/vzyP7MoEpy1KQtU5AOFF+AJFXpcwzmlihebDM=;
        b=cxMWTAUSrMESIfL94BYQNNaSxVlw/saZZoZkg+q63T+OHSn3Zn/T3rhAw0jnv1IO9AUfB/
        wwNQDJXzmKdev03XjAPys+XUooitij/D5peloiK54hOEg3GnIfCbYVBrJvSEHp4sm2RuTH
        YnUPYyjgQxjncp0dHIbAOxQb+3eUhPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-_q0KFm05Oie46LZjrXv01A-1; Fri, 20 Oct 2023 02:58:01 -0400
X-MC-Unique: _q0KFm05Oie46LZjrXv01A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BE9788B767;
        Fri, 20 Oct 2023 06:58:00 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B30B925C0;
        Fri, 20 Oct 2023 06:57:52 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Juan Quintela <quintela@redhat.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-arm@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        qemu-ppc@nongnu.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Xu <peterx@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jeff Cody <codyprime@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Fabiano Rosas <farosas@suse.de>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Greg Kurz <groug@kaod.org>, qemu-block@nongnu.org
Subject: [PULL 00/17] Migration 20231020 patches
Date:   Fri, 20 Oct 2023 08:57:34 +0200
Message-ID: <20231020065751.26047-1-quintela@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 0d239e513e0117e66fa739fb71a43b9383a108ff:

  Merge tag 'pull-lu-20231018' of https://gitlab.com/rth7680/qemu into staging (2023-10-19 10:20:57 -0700)

are available in the Git repository at:

  https://gitlab.com/juan.quintela/qemu.git tags/migration-20231020-pull-request

for you to fetch changes up to 7789331b03ae3bffcb2de925a093796b3b9907ff:

  tests/qtest: Don't print messages from query instances (2023-10-20 08:51:41 +0200)

----------------------------------------------------------------
Migration Pull request (20231020)

In this pull request:
- disable analyze-migration on s390x (thomas)
- Fix parse_ramblock() (peter)
- start merging live update (steve)
- migration-test support for using several binaries (fabiano)
- multifd cleanups (fabiano)

CI: https://gitlab.com/juan.quintela/qemu/-/pipelines/1042492801

Please apply.

----------------------------------------------------------------

Fabiano Rosas (13):
  migration/multifd: Stop checking p->quit in multifd_send_thread
  tests/qtest: Allow qtest_qemu_binary to use a custom environment
    variable
  tests/qtest: Introduce qtest_init_with_env
  tests/qtest: Allow qtest_get_machines to use an alternate QEMU binary
  tests/qtest: Introduce qtest_has_machine_with_env
  tests/qtest: Introduce qtest_resolve_machine_alias
  tests/qtest/migration: Introduce find_common_machine_version
  tests/qtest/migration: Define a machine for all architectures
  tests/qtest/migration: Specify the geometry of the bootsector
  tests/qtest/migration: Set q35 as the default machine for x86_86
  tests/qtest/migration: Support more than one QEMU binary
  tests/qtest/migration: Allow user to specify a machine type
  tests/qtest: Don't print messages from query instances

Peter Xu (1):
  migration: Fix parse_ramblock() on overwritten retvals

Steve Sistare (2):
  migration: simplify blockers
  migration: simplify notifiers

Thomas Huth (1):
  tests/qtest/migration-test: Disable the analyze-migration.py test on
    s390x

 include/migration/blocker.h     | 24 +++++---
 include/migration/misc.h        |  6 +-
 tests/qtest/libqtest.h          | 32 +++++++++++
 tests/qtest/migration-helpers.h |  4 ++
 backends/tpm/tpm_emulator.c     | 10 +---
 block/parallels.c               |  9 +--
 block/qcow.c                    |  6 +-
 block/vdi.c                     |  6 +-
 block/vhdx.c                    |  6 +-
 block/vmdk.c                    |  6 +-
 block/vpc.c                     |  6 +-
 block/vvfat.c                   |  6 +-
 dump/dump.c                     |  4 +-
 hw/9pfs/9p.c                    | 10 +---
 hw/display/virtio-gpu-base.c    |  8 +--
 hw/intc/arm_gic_kvm.c           |  3 +-
 hw/intc/arm_gicv3_its_kvm.c     |  3 +-
 hw/intc/arm_gicv3_kvm.c         |  3 +-
 hw/misc/ivshmem.c               |  8 +--
 hw/net/virtio-net.c             |  6 +-
 hw/ppc/pef.c                    |  2 +-
 hw/ppc/spapr.c                  |  9 +--
 hw/ppc/spapr_events.c           |  6 +-
 hw/ppc/spapr_rtas.c             |  2 +-
 hw/remote/proxy.c               |  7 +--
 hw/s390x/s390-virtio-ccw.c      |  9 +--
 hw/scsi/vhost-scsi.c            |  8 +--
 hw/vfio/common.c                | 10 +---
 hw/vfio/migration.c             | 22 ++------
 hw/virtio/vhost.c               |  8 +--
 migration/migration.c           | 44 ++++++++++-----
 migration/multifd.c             |  3 -
 migration/ram.c                 |  5 +-
 net/vhost-vdpa.c                |  7 ++-
 stubs/migr-blocker.c            |  4 +-
 target/i386/kvm/kvm.c           |  8 +--
 target/i386/nvmm/nvmm-all.c     |  3 +-
 target/i386/sev.c               |  2 +-
 target/i386/whpx/whpx-all.c     |  3 +-
 tests/qtest/libqtest.c          | 98 ++++++++++++++++++++++++++++-----
 tests/qtest/migration-helpers.c | 52 +++++++++++++++++
 tests/qtest/migration-test.c    | 54 +++++++++++++++---
 ui/spice-core.c                 |  3 +-
 ui/vdagent.c                    |  5 +-
 44 files changed, 344 insertions(+), 196 deletions(-)

-- 
2.41.0

