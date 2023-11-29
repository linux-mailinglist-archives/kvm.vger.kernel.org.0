Return-Path: <kvm+bounces-2798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2597FE1DA
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24819281DF0
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01D52B9C1;
	Wed, 29 Nov 2023 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1d2nTqP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397751998
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 13:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701293201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qIu73bEmAYNa5+9Duiskzg7KzH7tsLGKxcaWpL0jd+U=;
	b=C1d2nTqPjD2lvUlYV8rumV4mYtQY/TjTQKrQlP9weJrtC7lJIGR5rVFkN+aZsTFeHfvEmO
	SWLkG+T7i+KWkie18VRiP4aQ7c3tf6rWjGB4kbRBMpVl6VZ86wFsALmwf+O8v42sn3jUXR
	0B7hsR9fuRBCGWWHVF/oseBqJA8mEb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-IYmqAZfwOYuflT7jEzpRAg-1; Wed, 29 Nov 2023 16:26:36 -0500
X-MC-Unique: IYmqAZfwOYuflT7jEzpRAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61701848A65;
	Wed, 29 Nov 2023 21:26:30 +0000 (UTC)
Received: from localhost (unknown [10.39.192.91])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C50A02027019;
	Wed, 29 Nov 2023 21:26:26 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Juan Quintela <quintela@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	Jason Wang <jasowang@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Fam Zheng <fam@euphon.net>,
	Eric Blake <eblake@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Alexander Graf <agraf@csgraf.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Stafford Horne <shorne@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cameron Esfahani <dirty@apple.com>,
	xen-devel@lists.xenproject.org,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	qemu-riscv@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	John Snow <jsnow@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Bin Meng <bin.meng@windriver.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	qemu-block@nongnu.org,
	Halil Pasic <pasic@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Anthony Perard <anthony.perard@citrix.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 0/6] Make Big QEMU Lock naming consistent
Date: Wed, 29 Nov 2023 16:26:19 -0500
Message-ID: <20231129212625.1051502-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The Big QEMU Lock ("BQL") has two other names: "iothread lock" and "QEMU global
mutex". The term "iothread lock" is easily confused with the unrelated --object
iothread (iothread.c).

This series updates the code and documentation to consistently use "BQL". This
makes the code easier to understand.

Stefan Hajnoczi (6):
  system/cpus: rename qemu_mutex_lock_iothread() to qemu_bql_lock()
  qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to QEMU_BQL_LOCK_GUARD
  qemu/main-loop: rename qemu_cond_wait_iothread() to
    qemu_cond_wait_bql()
  system/cpus: rename qemu_global_mutex to qemu_bql
  Replace "iothread lock" with "BQL" in comments
  Rename "QEMU global mutex" to "BQL" in comments and docs

 docs/devel/multi-thread-tcg.rst      |   7 +-
 docs/devel/qapi-code-gen.rst         |   2 +-
 docs/devel/replay.rst                |   2 +-
 docs/devel/reset.rst                 |   2 +-
 docs/devel/multiple-iothreads.txt    |  16 ++--
 hw/display/qxl.h                     |   2 +-
 include/block/aio-wait.h             |   2 +-
 include/block/blockjob.h             |   6 +-
 include/exec/cpu-common.h            |   2 +-
 include/exec/memory.h                |   4 +-
 include/exec/ramblock.h              |   2 +-
 include/io/task.h                    |   2 +-
 include/migration/register.h         |   8 +-
 include/qemu/coroutine-core.h        |   2 +-
 include/qemu/coroutine.h             |   2 +-
 include/qemu/main-loop.h             |  54 ++++++------
 target/arm/internals.h               |   4 +-
 accel/accel-blocker.c                |  10 +--
 accel/dummy-cpus.c                   |   8 +-
 accel/hvf/hvf-accel-ops.c            |   4 +-
 accel/kvm/kvm-accel-ops.c            |   4 +-
 accel/kvm/kvm-all.c                  |  22 ++---
 accel/tcg/cpu-exec.c                 |  26 +++---
 accel/tcg/cputlb.c                   |  20 ++---
 accel/tcg/tcg-accel-ops-icount.c     |   6 +-
 accel/tcg/tcg-accel-ops-mttcg.c      |  12 +--
 accel/tcg/tcg-accel-ops-rr.c         |  18 ++--
 accel/tcg/tcg-accel-ops.c            |   2 +-
 accel/tcg/translate-all.c            |   2 +-
 cpu-common.c                         |   4 +-
 dump/dump.c                          |   4 +-
 hw/block/dataplane/virtio-blk.c      |   8 +-
 hw/block/virtio-blk.c                |   2 +-
 hw/core/cpu-common.c                 |   6 +-
 hw/display/virtio-gpu.c              |   2 +-
 hw/i386/intel_iommu.c                |   6 +-
 hw/i386/kvm/xen_evtchn.c             |  30 +++----
 hw/i386/kvm/xen_gnttab.c             |   2 +-
 hw/i386/kvm/xen_overlay.c            |   2 +-
 hw/i386/kvm/xen_xenstore.c           |   2 +-
 hw/intc/arm_gicv3_cpuif.c            |   2 +-
 hw/intc/s390_flic.c                  |  18 ++--
 hw/mips/mips_int.c                   |   2 +-
 hw/misc/edu.c                        |   4 +-
 hw/misc/imx6_src.c                   |   2 +-
 hw/misc/imx7_src.c                   |   2 +-
 hw/net/xen_nic.c                     |   8 +-
 hw/ppc/pegasos2.c                    |   2 +-
 hw/ppc/ppc.c                         |   6 +-
 hw/ppc/spapr.c                       |   2 +-
 hw/ppc/spapr_events.c                |   2 +-
 hw/ppc/spapr_rng.c                   |   4 +-
 hw/ppc/spapr_softmmu.c               |   4 +-
 hw/remote/mpqemu-link.c              |  14 ++--
 hw/remote/vfio-user-obj.c            |   2 +-
 hw/s390x/s390-skeys.c                |   2 +-
 hw/scsi/virtio-scsi-dataplane.c      |   6 +-
 migration/block-dirty-bitmap.c       |  14 ++--
 migration/block.c                    |  40 ++++-----
 migration/colo.c                     |  62 +++++++-------
 migration/dirtyrate.c                |  12 +--
 migration/migration.c                |  54 ++++++------
 migration/ram.c                      |  16 ++--
 net/tap.c                            |   2 +-
 replay/replay-internal.c             |   2 +-
 semihosting/console.c                |   8 +-
 stubs/iothread-lock.c                |   6 +-
 system/cpu-throttle.c                |   6 +-
 system/cpus.c                        |  52 ++++++------
 system/dirtylimit.c                  |   4 +-
 system/memory.c                      |   2 +-
 system/physmem.c                     |  14 ++--
 system/runstate.c                    |   2 +-
 system/watchpoint.c                  |   4 +-
 target/arm/arm-powerctl.c            |  14 ++--
 target/arm/helper.c                  |   6 +-
 target/arm/hvf/hvf.c                 |   8 +-
 target/arm/kvm.c                     |   4 +-
 target/arm/kvm64.c                   |   4 +-
 target/arm/ptw.c                     |   6 +-
 target/arm/tcg/helper-a64.c          |   8 +-
 target/arm/tcg/m_helper.c            |   6 +-
 target/arm/tcg/op_helper.c           |  24 +++---
 target/arm/tcg/psci.c                |   2 +-
 target/hppa/int_helper.c             |   8 +-
 target/i386/hvf/hvf.c                |   6 +-
 target/i386/kvm/hyperv.c             |   4 +-
 target/i386/kvm/kvm.c                |  28 +++----
 target/i386/kvm/xen-emu.c            |  16 ++--
 target/i386/nvmm/nvmm-accel-ops.c    |   6 +-
 target/i386/nvmm/nvmm-all.c          |  20 ++---
 target/i386/tcg/sysemu/fpu_helper.c  |   6 +-
 target/i386/tcg/sysemu/misc_helper.c |   4 +-
 target/i386/whpx/whpx-accel-ops.c    |   6 +-
 target/i386/whpx/whpx-all.c          |  24 +++---
 target/loongarch/csr_helper.c        |   4 +-
 target/mips/kvm.c                    |   4 +-
 target/mips/tcg/sysemu/cp0_helper.c  |   4 +-
 target/openrisc/sys_helper.c         |  16 ++--
 target/ppc/excp_helper.c             |  14 ++--
 target/ppc/helper_regs.c             |   2 +-
 target/ppc/kvm.c                     |   4 +-
 target/ppc/misc_helper.c             |   8 +-
 target/ppc/timebase_helper.c         |   8 +-
 target/riscv/cpu_helper.c            |   4 +-
 target/s390x/kvm/kvm.c               |   4 +-
 target/s390x/tcg/misc_helper.c       | 118 +++++++++++++--------------
 target/sparc/int32_helper.c          |   2 +-
 target/sparc/int64_helper.c          |   6 +-
 target/sparc/win_helper.c            |  20 ++---
 target/xtensa/exc_helper.c           |   8 +-
 ui/spice-core.c                      |   6 +-
 util/async.c                         |   2 +-
 util/main-loop.c                     |   8 +-
 util/rcu.c                           |  16 ++--
 audio/coreaudio.m                    |   8 +-
 memory_ldst.c.inc                    |  18 ++--
 target/i386/hvf/README.md            |   2 +-
 ui/cocoa.m                           |  56 ++++++-------
 119 files changed, 627 insertions(+), 628 deletions(-)

-- 
2.42.0


