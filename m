Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B14E3F7F
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiCVN1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbiCVN1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EA4F3B2A3
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647955568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mk3hl79SOvvRPnNyVsHVQnRiriDoUuiJYwsyISW4b0k=;
        b=HnxH/dWiG5qdYcUOX8x0sbDblWxYk3DpJvwysjs5rTensNtmzJCvEKEPxTChTm5D3zAsia
        fH+P579ZrOmSu66O9OeKvezz9910JmLIUAeqLsvTeo+GnjUU6QqHSzH0dQmt28iXzSSnyj
        08q2Foo0YtbSEESzWzNhZSNnzaiNA6Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-LyBesW7xMduriNyIWXkdqA-1; Tue, 22 Mar 2022 09:26:07 -0400
X-MC-Unique: LyBesW7xMduriNyIWXkdqA-1
Received: by mail-wm1-f71.google.com with SMTP id 2-20020a1c0202000000b0038c71e8c49cso1278836wmc.1
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mk3hl79SOvvRPnNyVsHVQnRiriDoUuiJYwsyISW4b0k=;
        b=6Pfe6j+nRvUfQkXX5uXAI6E7pmacQ77w3LM+iawoQzABzN1/5Zq1pmNSC5Wjac+O9K
         RCQIcAfNCyIMZMN7sFgnyNg4oUQJQI0/3o1DWJ9F75a4+RYRU/oNdyQh3h488gvqpw8M
         lwLi8KaDQZJB3eceZXpxtmLyk48JrpuzRHgUeEOBzcIvwAks42EZR7fX666GHbszBx+E
         fV1RTH+EFX8+AcsPdOA++ZGD2RN/z0DEjFEMTPTSD/RztITAtEQdp/C4NdUSZ9r25BAJ
         FaTFKqMzMTkMvUWyhjFb8JP4sQ5SmWxN4t7zDlf6q6B0LD6ZrbYgjvNJE9csT88ckQUW
         0K3g==
X-Gm-Message-State: AOAM533nCdwuWhj+ETNLMVt7mnz5nG2s3iYQ/YeP7Uof1lRO2QDCCipj
        5nOEaKjHN+OQm7Gze2Rw8ObNhtskv18Ycojy7WeiF2V5/rM5C93DCtZJByslxYWt1alVwovZwmL
        Z1wHaOhEqPfcn
X-Received: by 2002:a05:600c:1e0d:b0:38c:bb0c:e01 with SMTP id ay13-20020a05600c1e0d00b0038cbb0c0e01mr2299292wmb.115.1647955565894;
        Tue, 22 Mar 2022 06:26:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9R6xweHbYOlT41nX8VS8jupEnB/cxHKbwK3VEwN1bfzNeZZNTKEUKx2jEvOzPtm6sO39XFQ==
X-Received: by 2002:a05:600c:1e0d:b0:38c:bb0c:e01 with SMTP id ay13-20020a05600c1e0d00b0038cbb0c0e01mr2299266wmb.115.1647955565576;
        Tue, 22 Mar 2022 06:26:05 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id b15-20020adfc74f000000b001e888b871a0sm15919477wrh.87.2022.03.22.06.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:26:04 -0700 (PDT)
Date:   Tue, 22 Mar 2022 09:25:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v2 0/3] Use g_new() & friends where that makes obvious
 sense
Message-ID: <20220322092520-mutt-send-email-mst@kernel.org>
References: <20220315144156.1595462-1-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315144156.1595462-1-armbru@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 03:41:53PM +0100, Markus Armbruster wrote:
> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
> 
> This series only touches allocations with size arguments of the form
> sizeof(T).  It's mechanical, except for a tiny fix in PATCH 2.
> 
> PATCH 1 adds the Coccinelle script.
> 
> PATCH 2 cleans up the virtio-9p subsystem, and fixes a harmless typing
> error uncovered by the cleanup.
> 
> PATCH 3 cleans up everything else.  I started to split it up, but
> splitting is a lot of decisions, and I just can't see the value.

series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> For instance, MAINTAINERS tells me to split for subsystem "virtio",
> patching
> 
>     hw/char/virtio-serial-bus.c
>     hw/display/virtio-gpu.c
>     hw/net/virtio-net.c
>     hw/virtio/virtio-crypto.c
>     hw/virtio/virtio-iommu.c
>     hw/virtio/virtio.c
> 
> But it also tells me to split for subsystem "Character devices",
> patching
> 
>     hw/char/parallel.c                       |  2 +-
>     hw/char/riscv_htif.c                     |  2 +-
>     hw/char/virtio-serial-bus.c              |  6 +-
> 
> and for subsystem "Network devices", patching
> 
>     hw/net/virtio-net.c
> 
> and for subsystem "virtio-gpu", patching
> 
>     hw/display/virtio-gpu.c
> 
> I guess I'd go with "virtio".  Six files down, 103 to go.  Thanks, but
> no thanks.
> 
> Since the transformation is local to a function call, dropping is
> completely safe.  We can deal with conflicts by dropping conflicting
> hunks, with "git-pull -s recursive -X ours".  Or drop entire files
> with conflicts.
> 
> If you want me to split off certain parts, please tell me exactly what
> you want split off, and I'll gladly do the splitting.  I don't mind
> the splitting part, I do mind the *thinking* part.
> 
> I backed out two changes made by the Coccinelle script:
> scripts/coverity-scan/model.c, because that's special, and
> semihosting/config.c, because it has a typing error similar to the one
> fixed in PATCH 2, and Alex already posted a patch for it.
> 
> v2:
> * PATCH 3: Change to scripts/coverity-scan/model.c dropped [Eric]
> * PATCH 3: Change to semihosting/config.c dropped [Alex]
> * Commit messages tweaked
> 
> Markus Armbruster (3):
>   scripts/coccinelle: New use-g_new-etc.cocci
>   9pfs: Use g_new() & friends where that makes obvious sense
>   Use g_new() & friends where that makes obvious sense
> 
>  scripts/coccinelle/use-g_new-etc.cocci   | 75 ++++++++++++++++++++++++
>  include/qemu/timer.h                     |  2 +-
>  accel/kvm/kvm-all.c                      |  6 +-
>  accel/tcg/tcg-accel-ops-mttcg.c          |  2 +-
>  accel/tcg/tcg-accel-ops-rr.c             |  4 +-
>  audio/audio.c                            |  4 +-
>  audio/audio_legacy.c                     |  6 +-
>  audio/dsoundaudio.c                      |  2 +-
>  audio/jackaudio.c                        |  6 +-
>  audio/paaudio.c                          |  4 +-
>  backends/cryptodev.c                     |  2 +-
>  contrib/vhost-user-gpu/vhost-user-gpu.c  |  2 +-
>  cpus-common.c                            |  4 +-
>  dump/dump.c                              |  2 +-
>  hw/9pfs/9p-proxy.c                       |  2 +-
>  hw/9pfs/9p-synth.c                       |  4 +-
>  hw/9pfs/9p.c                             |  8 +--
>  hw/9pfs/codir.c                          |  6 +-
>  hw/acpi/hmat.c                           |  2 +-
>  hw/audio/intel-hda.c                     |  2 +-
>  hw/char/parallel.c                       |  2 +-
>  hw/char/riscv_htif.c                     |  2 +-
>  hw/char/virtio-serial-bus.c              |  6 +-
>  hw/core/irq.c                            |  2 +-
>  hw/core/reset.c                          |  2 +-
>  hw/display/pxa2xx_lcd.c                  |  2 +-
>  hw/display/tc6393xb.c                    |  2 +-
>  hw/display/virtio-gpu.c                  |  4 +-
>  hw/display/xenfb.c                       |  4 +-
>  hw/dma/rc4030.c                          |  4 +-
>  hw/i2c/core.c                            |  4 +-
>  hw/i2c/i2c_mux_pca954x.c                 |  2 +-
>  hw/i386/amd_iommu.c                      |  4 +-
>  hw/i386/intel_iommu.c                    |  2 +-
>  hw/i386/xen/xen-hvm.c                    | 10 ++--
>  hw/i386/xen/xen-mapcache.c               | 14 ++---
>  hw/input/lasips2.c                       |  2 +-
>  hw/input/pckbd.c                         |  2 +-
>  hw/input/ps2.c                           |  4 +-
>  hw/input/pxa2xx_keypad.c                 |  2 +-
>  hw/input/tsc2005.c                       |  3 +-
>  hw/intc/riscv_aclint.c                   |  6 +-
>  hw/intc/xics.c                           |  2 +-
>  hw/m68k/virt.c                           |  2 +-
>  hw/mips/mipssim.c                        |  2 +-
>  hw/misc/applesmc.c                       |  2 +-
>  hw/misc/imx6_src.c                       |  2 +-
>  hw/misc/ivshmem.c                        |  4 +-
>  hw/net/virtio-net.c                      |  4 +-
>  hw/nvme/ns.c                             |  2 +-
>  hw/pci-host/pnv_phb3.c                   |  2 +-
>  hw/pci-host/pnv_phb4.c                   |  2 +-
>  hw/pci/pcie_sriov.c                      |  2 +-
>  hw/ppc/e500.c                            |  2 +-
>  hw/ppc/ppc.c                             |  8 +--
>  hw/ppc/ppc405_boards.c                   |  4 +-
>  hw/ppc/ppc405_uc.c                       | 18 +++---
>  hw/ppc/ppc4xx_devs.c                     |  2 +-
>  hw/ppc/ppc_booke.c                       |  4 +-
>  hw/ppc/spapr.c                           |  2 +-
>  hw/ppc/spapr_events.c                    |  2 +-
>  hw/ppc/spapr_hcall.c                     |  2 +-
>  hw/ppc/spapr_numa.c                      |  3 +-
>  hw/rdma/vmw/pvrdma_dev_ring.c            |  2 +-
>  hw/rdma/vmw/pvrdma_qp_ops.c              |  6 +-
>  hw/sh4/r2d.c                             |  4 +-
>  hw/sh4/sh7750.c                          |  2 +-
>  hw/sparc/leon3.c                         |  2 +-
>  hw/sparc64/sparc64.c                     |  4 +-
>  hw/timer/arm_timer.c                     |  2 +-
>  hw/timer/slavio_timer.c                  |  2 +-
>  hw/vfio/pci.c                            |  4 +-
>  hw/vfio/platform.c                       |  4 +-
>  hw/virtio/virtio-crypto.c                |  2 +-
>  hw/virtio/virtio-iommu.c                 |  2 +-
>  hw/virtio/virtio.c                       |  5 +-
>  hw/xtensa/xtfpga.c                       |  2 +-
>  linux-user/syscall.c                     |  2 +-
>  migration/dirtyrate.c                    |  4 +-
>  migration/multifd-zlib.c                 |  4 +-
>  migration/ram.c                          |  2 +-
>  monitor/misc.c                           |  2 +-
>  monitor/qmp-cmds.c                       |  2 +-
>  qga/commands-win32.c                     |  8 +--
>  qga/commands.c                           |  2 +-
>  qom/qom-qmp-cmds.c                       |  2 +-
>  replay/replay-char.c                     |  4 +-
>  replay/replay-events.c                   | 10 ++--
>  softmmu/bootdevice.c                     |  4 +-
>  softmmu/dma-helpers.c                    |  4 +-
>  softmmu/memory_mapping.c                 |  2 +-
>  target/i386/cpu-sysemu.c                 |  2 +-
>  target/i386/hax/hax-accel-ops.c          |  4 +-
>  target/i386/nvmm/nvmm-accel-ops.c        |  4 +-
>  target/i386/whpx/whpx-accel-ops.c        |  4 +-
>  target/i386/whpx/whpx-all.c              |  2 +-
>  target/s390x/cpu-sysemu.c                |  2 +-
>  tests/qtest/virtio-9p-test.c             |  4 +-
>  tests/unit/test-hbitmap.c                |  2 +-
>  tests/unit/test-qmp-cmds.c               | 14 ++---
>  tests/unit/test-qobject-output-visitor.c |  2 +-
>  tests/unit/test-vmstate.c                | 42 ++++++-------
>  ui/vnc-enc-tight.c                       |  2 +-
>  util/envlist.c                           |  2 +-
>  util/hbitmap.c                           |  2 +-
>  util/main-loop.c                         |  2 +-
>  util/qemu-timer.c                        |  2 +-
>  util/vfio-helpers.c                      |  4 +-
>  108 files changed, 282 insertions(+), 212 deletions(-)
>  create mode 100644 scripts/coccinelle/use-g_new-etc.cocci
> 
> -- 
> 2.35.1

