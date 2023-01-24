Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49E6797A7
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbjAXMUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXMUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0C045886
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NO0Vxj0TvyYGxRIeR6HtKCRtmt8deFyema5cizHmwcc=;
        b=TGL4p6LcLtvMNUAd8KgxBdgZczQl5U0ciSNGZA1pF9LGRXPuk9PwiU2M0uq7w9IbnAPtMi
        4bpfuX3pYFOBucoL0+Pf0LmywWu2YMvSgmQfBNTqsIQQnTX0aM/qWf1AOskubGy/Wohwi+
        UwSD77zrps1QJoaYtlF0pm3FUlYqr4A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-fQMi2Gu3NH2ay_k6ijffYQ-1; Tue, 24 Jan 2023 07:19:49 -0500
X-MC-Unique: fQMi2Gu3NH2ay_k6ijffYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 474E73C1022B;
        Tue, 24 Jan 2023 12:19:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D0AF2166B26;
        Tue, 24 Jan 2023 12:19:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 801C221E6A1F; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: [PATCH 00/32] Move and clean up monitor command code
Date:   Tue, 24 Jan 2023 13:19:14 +0100
Message-Id: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the years, many commands got dumped into monitor/, where
MAINTAINERS blames them on Dave and me.  Recent "[PATCH v2 00/13] pci:
Move and clean up monitor command code" (merge commit 33698d3abf8)
evicted commands related to PCI (qapi/pci.json), and "[PATCH v4 00/17]
ui: Move and clean up monitor command code" (merge commit 70d17c3eede)
evicted commands rated to UI (qapi/ui.json) This series evicts most of
the rest.  Commands related to the monitor itself (qapi/control.json
qapi/introspect.json) and miscellaneous commands (qapi/misc.json) stay
in monitor/.

Together, these patches move almost 4000 lines from monitor/ to
subsystems where they belong.

Based-on: <20230119091545.3116376-1-armbru@redhat.com>

Markus Armbruster (32):
  monitor: Drop unnecessary includes
  audio: Move HMP commands from monitor/ to audio/
  char: Move HMP commands from monitor/ to chardev/
  char: Factor out qmp_add_client() parts and move to chardev/
  hmp: Drop redundant argument check from add_completion_option()
  readline: Extract readline_add_completion_of() from monitor
  hmp: Rename help_cmd() to hmp_help_cmd(), move declaration to hmp.h
  trace: Move HMP commands from monitor/ to trace/
  machine: Move QMP commands from monitor/ to hw/core/
  machine: Move HMP commands from monitor/ to hw/core/
  qom: Move HMP commands from monitor/ to qom/
  block: Factor out hmp_change_medium(), and move to block/monitor/
  rocker: Move HMP commands from monitor to hw/net/rocker/
  hmp: Rewrite strlist_from_comma_list() as hmp_split_at_comma()
  net: Move HMP commands from monitor to net/
  net: Move hmp_info_network() to net-hmp-cmds.c
  migration: Move HMP commands from monitor/ to migration/
  migration: Move the QMP command from monitor/ to migration/
  virtio: Move HMP commands from monitor/ to hw/virtio/
  tpm: Move HMP commands from monitor/ to softmmu/
  runstate: Move HMP commands from monitor/ to softmmu/
  stats: Move QMP commands from monitor/ to stats/
  stats: Move HMP commands from monitor/ to stats/
  acpi: Move the QMP command from monitor/ to hw/acpi/
  qdev: Move HMP command completion from monitor to softmmu/
  monitor: Split file descriptor passing stuff off misc.c
  monitor: Move monitor_putc() next to monitor_puts & external linkage
  monitor: Move target-dependent HMP commands to hmp-cmds-target.c
  monitor: Move remaining HMP commands from misc.c to hmp-cmds.c
  monitor: Move remaining QMP stuff from misc.c to qmp-cmds.c
  monitor: Loosen coupling between misc.c and monitor.c slightly
  monitor: Rename misc.c to hmp-target.c

 MAINTAINERS                          |   10 +-
 meson.build                          |    1 +
 include/monitor/hmp-target.h         |    6 +
 include/monitor/hmp.h                |   27 +
 include/monitor/monitor.h            |    1 +
 include/monitor/qmp-helpers.h        |    3 +
 include/net/net.h                    |    4 +-
 include/qemu/readline.h              |    2 +
 include/{monitor => sysemu}/stats.h  |    0
 monitor/monitor-internal.h           |    1 -
 accel/kvm/kvm-all.c                  |    2 +-
 audio/audio-hmp-cmds.c               |   83 +
 block/monitor/block-hmp-cmds.c       |   21 +
 chardev/char-hmp-cmds.c              |  220 +++
 chardev/char.c                       |   20 +
 hw/acpi/acpi-qmp-cmds.c              |   30 +
 hw/core/machine-hmp-cmds.c           |  208 +++
 hw/core/machine-qmp-cmds.c           |  144 ++
 hw/net/rocker/rocker-hmp-cmds.c      |  316 ++++
 hw/virtio/virtio-hmp-cmds.c          |  321 ++++
 migration/migration-hmp-cmds.c       |  807 ++++++++++
 migration/migration.c                |   30 +
 monitor/fds.c                        |  468 ++++++
 monitor/hmp-cmds-target.c            |  380 +++++
 monitor/hmp-cmds.c                   | 2181 ++------------------------
 monitor/hmp-target.c                 |  178 +++
 monitor/hmp.c                        |   17 +-
 monitor/misc.c                       | 1906 ----------------------
 monitor/monitor.c                    |   30 +-
 monitor/qmp-cmds-control.c           |    1 -
 monitor/qmp-cmds.c                   |  355 +----
 net/net-hmp-cmds.c                   |  170 ++
 net/net.c                            |   28 +-
 qom/qom-hmp-cmds.c                   |   67 +
 softmmu/qdev-monitor.c               |   82 +
 softmmu/runstate-hmp-cmds.c          |   82 +
 softmmu/tpm-hmp-cmds.c               |   65 +
 stats/stats-hmp-cmds.c               |  247 +++
 stats/stats-qmp-cmds.c               |  162 ++
 storage-daemon/qemu-storage-daemon.c |    4 +-
 trace/trace-hmp-cmds.c               |  148 ++
 util/readline.c                      |    8 +
 audio/meson.build                    |    1 +
 chardev/meson.build                  |    6 +-
 hmp-commands.hx                      |    4 +-
 hw/acpi/meson.build                  |    1 +
 hw/net/meson.build                   |    1 +
 hw/virtio/meson.build                |    1 +
 migration/meson.build                |    1 +
 monitor/meson.build                  |    4 +-
 net/meson.build                      |    1 +
 softmmu/meson.build                  |    2 +
 stats/meson.build                    |    1 +
 trace/meson.build                    |    1 +
 54 files changed, 4574 insertions(+), 4286 deletions(-)
 rename include/{monitor => sysemu}/stats.h (100%)
 create mode 100644 audio/audio-hmp-cmds.c
 create mode 100644 chardev/char-hmp-cmds.c
 create mode 100644 hw/acpi/acpi-qmp-cmds.c
 create mode 100644 hw/net/rocker/rocker-hmp-cmds.c
 create mode 100644 hw/virtio/virtio-hmp-cmds.c
 create mode 100644 migration/migration-hmp-cmds.c
 create mode 100644 monitor/fds.c
 create mode 100644 monitor/hmp-cmds-target.c
 create mode 100644 monitor/hmp-target.c
 delete mode 100644 monitor/misc.c
 create mode 100644 net/net-hmp-cmds.c
 create mode 100644 softmmu/runstate-hmp-cmds.c
 create mode 100644 softmmu/tpm-hmp-cmds.c
 create mode 100644 stats/stats-hmp-cmds.c
 create mode 100644 stats/stats-qmp-cmds.c
 create mode 100644 trace/trace-hmp-cmds.c
 create mode 100644 stats/meson.build

-- 
2.39.0

