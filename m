Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340EB165E27
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBTNGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728091AbgBTNGC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gu1OfO+Xr177r6zD7C+F/TxHFq6mosreIYv9UCpXME0=;
        b=MUCDutVhDBbvX3ov+Fy1NTGQKNeK9o2RCCGMZwVhiQZnKU4Uy/2f+jQYVj8gng8mP/n+xj
        uGQBe1IlenUeVZppYdS5QW5juQnXTs6UhS0n+Xm1Bb1qAvwbFYSVD1pCv59YkyF0zf99GX
        +xK23nJuP5wx7gJCbcervH+B538rAU4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-4YOFUXg1NmK0mY8QyJCT9A-1; Thu, 20 Feb 2020 08:05:54 -0500
X-MC-Unique: 4YOFUXg1NmK0mY8QyJCT9A-1
Received: by mail-wm1-f69.google.com with SMTP id g138so576653wmg.8
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:05:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gu1OfO+Xr177r6zD7C+F/TxHFq6mosreIYv9UCpXME0=;
        b=BhEp4ycat83vSIjyap75qQusN6HSbqeLXFCzj1zhvIyUJyHz6C63KrDLKON5aB0OIh
         R0xvrbev8VQhMJ6o1jOYE0N7bVwno1WRLzJaW136hUKysbwq0fBmnDwtHbv1FToDjihk
         7ijo4uAxzDHk+ksgVnG1KQk9sA78nHbYQH3o+dk2+GEnJ+K39JdPi2xpXR8GHvpRH2c1
         UYz9kEB8f9YgJWwWe2MMTrb3ymU4/uuLUTamnQ3oLD6kEiegyp2roDjwUhG0cXOmbb3Q
         vUNAJLD9o50N4RRQrkbAbyMwLBaLhZwSK9M/pSroHt/m2tJbR09tAyqpARcfMNjHJXiy
         ctaQ==
X-Gm-Message-State: APjAAAWq05mwhFG/vh+f73bHsDrIpkyN3tAM03eFWYeC3rWM5RAQMf9k
        L3Chow91Ogr0H4GlZKh296U8p10MOjBsdLsmQccjyoykmZQohRictYBCsvrx4bfD4jPqcDxOE35
        AltI7qxFmr1kn
X-Received: by 2002:a1c:f713:: with SMTP id v19mr4357657wmh.113.1582203953757;
        Thu, 20 Feb 2020 05:05:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqzh9hNepHCOwe2XDVm3wY3ajt8F8GOM+lVXRr3SymvEGFarpB4eXHypTAiBAMMl7y3VSmAESQ==
X-Received: by 2002:a1c:f713:: with SMTP id v19mr4357638wmh.113.1582203953503;
        Thu, 20 Feb 2020 05:05:53 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:05:52 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 00/20] global exec/memory/dma APIs cleanup
Date:   Thu, 20 Feb 2020 14:05:28 +0100
Message-Id: <20200220130548.29974-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is inspired from Peter Maydel cleanup patch:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg680625.html

- Convert 'is_write' argument to boolean
- Use void pointer for blob buffer
- Remove unnecessary casts (Stefan Weil)
- Replace [API]_rw() by [API]_read/write() when is_write is constant

Supersedes: <20200218112457.22712-1-peter.maydell@linaro.org>

Peter Maydell (1):
  Avoid address_space_rw() with a constant is_write argument

Philippe Mathieu-Daudé (19):
  scripts/git.orderfile: Display Cocci scripts before code modifications
  hw: Remove unnecessary cast when calling dma_memory_read()
  exec: Let qemu_ram_*() functions take a const pointer argument
  exec: Rename ram_ptr variable
  exec: Let flatview API take void pointer arguments
  exec: Let the address_space API use void pointer arguments
  hw/net: Avoid casting non-const pointer, use address_space_write()
  Remove unnecessary cast when using the address_space API
  exec: Let the cpu_[physical]_memory API use void pointer arguments
  Remove unnecessary cast when using the cpu_[physical]_memory API
  hw/ide/internal: Remove unused DMARestartFunc typedef
  hw/ide: Let the DMAIntFunc prototype use a boolean 'is_write' argument
  hw/virtio: Let virtqueue_map_iovec() use a boolean 'is_write' argument
  hw/virtio: Let vhost_memory_map() use a boolean 'is_write' argument
  exec: Let address_space_unmap() use a boolean 'is_write' argument
  Let address_space_rw() calls pass a boolean 'is_write' argument
  exec: Let cpu_[physical]_memory API use a boolean 'is_write' argument
  Let cpu_[physical]_memory() calls pass a boolean 'is_write' argument
  Avoid cpu_physical_memory_rw() with a constant is_write argument

 scripts/coccinelle/exec_rw_const.cocci | 103 +++++++++++++++++++++++++
 include/exec/cpu-all.h                 |   2 +-
 include/exec/cpu-common.h              |  18 ++---
 include/exec/memory.h                  |  16 ++--
 include/hw/ide/internal.h              |   3 +-
 include/sysemu/xen-mapcache.h          |   4 +-
 target/i386/hvf/vmx.h                  |   7 +-
 accel/kvm/kvm-all.c                    |   6 +-
 dma-helpers.c                          |   4 +-
 exec.c                                 |  75 +++++++++---------
 hw/arm/boot.c                          |   6 +-
 hw/arm/smmu-common.c                   |   3 +-
 hw/arm/smmuv3.c                        |  10 +--
 hw/display/exynos4210_fimd.c           |   3 +-
 hw/display/milkymist-tmu2.c            |   8 +-
 hw/display/omap_dss.c                  |   2 +-
 hw/display/omap_lcdc.c                 |  10 +--
 hw/display/ramfb.c                     |   2 +-
 hw/dma/etraxfs_dma.c                   |  25 +++---
 hw/dma/rc4030.c                        |  10 +--
 hw/dma/xlnx-zdma.c                     |  11 +--
 hw/i386/xen/xen-mapcache.c             |   2 +-
 hw/ide/ahci.c                          |   2 +-
 hw/ide/core.c                          |   2 +-
 hw/ide/macio.c                         |   2 +-
 hw/ide/pci.c                           |   2 +-
 hw/misc/pc-testdev.c                   |   2 +-
 hw/net/cadence_gem.c                   |  21 +++--
 hw/net/dp8393x.c                       |  70 +++++++++--------
 hw/net/i82596.c                        |  25 +++---
 hw/net/lasi_i82596.c                   |   5 +-
 hw/nvram/spapr_nvram.c                 |   4 +-
 hw/ppc/pnv_lpc.c                       |   8 +-
 hw/ppc/ppc440_uc.c                     |   6 +-
 hw/ppc/spapr_hcall.c                   |   4 +-
 hw/s390x/css.c                         |  12 +--
 hw/s390x/ipl.c                         |   2 +-
 hw/s390x/s390-pci-bus.c                |   2 +-
 hw/s390x/virtio-ccw.c                  |   2 +-
 hw/scsi/vmw_pvscsi.c                   |   8 +-
 hw/sd/sdhci.c                          |  15 ++--
 hw/virtio/vhost.c                      |   8 +-
 hw/virtio/virtio.c                     |   7 +-
 hw/xen/xen_pt_graphics.c               |   2 +-
 qtest.c                                |  52 ++++++-------
 target/i386/hax-all.c                  |   6 +-
 target/i386/hvf/x86_mmu.c              |  12 +--
 target/i386/whpx-all.c                 |   2 +-
 target/s390x/excp_helper.c             |   2 +-
 target/s390x/helper.c                  |   6 +-
 target/s390x/mmu_helper.c              |   2 +-
 scripts/git.orderfile                  |   3 +
 52 files changed, 360 insertions(+), 266 deletions(-)
 create mode 100644 scripts/coccinelle/exec_rw_const.cocci

-- 
2.21.1

