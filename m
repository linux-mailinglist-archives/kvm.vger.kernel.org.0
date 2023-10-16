Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4A17CAD40
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjJPPTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjJPPTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B566FB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=F3UjuhE2FBKcmgLerw1NnKKsKaQ1Vv0F+THBpoMNMME=; b=RUe0h4t2PDLQe/PbrYmnoJGzBv
        XpnXvqi6OUXrxehffQ1Zf3iom+dmkFdob8j4mg/Fas49lSB23CT9QoY4sPBHT4gD/sj7ySvs5Vrf1
        YlBGiPXcApj99d7zg4CiWufTxxd6zJETNOAbQpUZHP7JI/G6hkT4XxZ/Vg0SWIAYmhNl6AkpgMA63
        e2cWIx2oNICYJZFTgnao0HZdGFu0FriQCdSWlVoDiXrgJFb4ucufo8yvmCSkO1VpYxIYLfrsie/tz
        29KhaPmM8aD222XRsxlZECZiMS8rBg9NJydMRO9W4S4Ltm38AFPXw/MPQ+HkcdEr5AesYJTRLYIP9
        SYkllKNQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsPNC-006lqX-62; Mon, 16 Oct 2023 15:19:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0005n5-1t;
        Mon, 16 Oct 2023 16:19:13 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 0/12] Get Xen PV shim running in qemu
Date:   Mon, 16 Oct 2023 16:18:57 +0100
Message-Id: <20231016151909.22133-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I hadn't got round to getting the PV shim running yet; I thought it would
need work on the multiboot loader. Turns out it doesn't. I *did* need to
fix a couple of brown-paper-bag bugs in the per-vCPU upcall vector support,
and implement Xen console support though. Now I can test PV guests:

 $ qemu-system-x86_64 --accel kvm,xen-version=0x40011,kernel-irqchip=split \
   -chardev stdio,mux=on,id=char0 -device xen-console,chardev=char0 \
   -drive file=${GUEST_IMAGE},if=xen -display none -m 1G \
   -kernel ~/git/xen/xen/xen -initrd ~/git/linux/arch/x86/boot/bzImage \
   -append "loglvl=all -- console=hvc0 root=/dev/xvda1"

 blockdev.c                                     |  15 +++-
 hw/block/xen-block.c                           |  26 +++++-
 hw/char/trace-events                           |   8 ++
 hw/char/xen_console.c                          | 522 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 hw/i386/kvm/meson.build                        |   1 +
 hw/i386/kvm/trace-events                       |   2 +
 hw/i386/kvm/xen-stubs.c                        |   5 ++
 hw/i386/kvm/xen_evtchn.c                       |   6 ++
 hw/i386/kvm/xen_gnttab.c                       |  32 ++++++-
 hw/i386/kvm/xen_primary_console.c              | 167 ++++++++++++++++++++++++++++++++++
 hw/i386/kvm/xen_primary_console.h              |  22 +++++
 hw/i386/kvm/xen_xenstore.c                     |  21 ++++-
 hw/xen/xen-backend.c                           |  81 +++++++++++++----
 hw/xen/xen-bus.c                               |  21 ++++-
 hw/xen/xen-legacy-backend.c                    |   1 -
 include/hw/xen/interface/arch-arm.h            |  37 ++++----
 include/hw/xen/interface/arch-x86/cpuid.h      |  31 +++----
 include/hw/xen/interface/arch-x86/xen-x86_32.h |  19 +---
 include/hw/xen/interface/arch-x86/xen-x86_64.h |  19 +---
 include/hw/xen/interface/arch-x86/xen.h        |  26 +-----
 include/hw/xen/interface/event_channel.h       |  19 +---
 include/hw/xen/interface/features.h            |  19 +---
 include/hw/xen/interface/grant_table.h         |  19 +---
 include/hw/xen/interface/hvm/hvm_op.h          |  19 +---
 include/hw/xen/interface/hvm/params.h          |  19 +---
 include/hw/xen/interface/io/blkif.h            |  27 ++----
 include/hw/xen/interface/io/console.h          |  19 +---
 include/hw/xen/interface/io/fbif.h             |  19 +---
 include/hw/xen/interface/io/kbdif.h            |  19 +---
 include/hw/xen/interface/io/netif.h            |  25 ++----
 include/hw/xen/interface/io/protocols.h        |  19 +---
 include/hw/xen/interface/io/ring.h             |  49 +++++-----
 include/hw/xen/interface/io/usbif.h            |  19 +---
 include/hw/xen/interface/io/xenbus.h           |  19 +---
 include/hw/xen/interface/io/xs_wire.h          |  36 ++++----
 include/hw/xen/interface/memory.h              |  30 +++----
 include/hw/xen/interface/physdev.h             |  23 +----
 include/hw/xen/interface/sched.h               |  19 +---
 include/hw/xen/interface/trace.h               |  19 +---
 include/hw/xen/interface/vcpu.h                |  19 +---
 include/hw/xen/interface/version.h             |  19 +---
 include/hw/xen/interface/xen-compat.h          |  19 +---
 include/hw/xen/interface/xen.h                 |  19 +---
 include/hw/xen/xen-backend.h                   |   4 +
 include/hw/xen/xen-bus.h                       |   2 +
 include/sysemu/kvm_xen.h                       |   1 +
 target/i386/kvm/kvm.c                          |   4 +
 target/i386/kvm/xen-emu.c                      |  35 ++++++--
 48 files changed, 941 insertions(+), 680 deletions(-)


