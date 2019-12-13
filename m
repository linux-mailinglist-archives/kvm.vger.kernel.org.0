Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A36E11E7EE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfLMQST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:18:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56002 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726404AbfLMQST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eictPqqvfDWdLCnWulB6nvsiJMgILd7otDTiwQaZME4=;
        b=W7FtgtZy02cgeowTjxtRgkyZ4xFT2qSVGM77Q+xQmb5rJO9AOgBIT2ez5KWeNhvYZQ0aZq
        we01nH6WoRkLxRGiSg3khpteMc7lhCzlZolJJkWc1gcfDC76VlR8wDehbqlrGVloctr7pt
        KAUKgVhiPknzDQ6XqFhbXdrD55H72cs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-termAq3FMgGFGnyF0OlLXA-1; Fri, 13 Dec 2019 11:18:14 -0500
X-MC-Unique: termAq3FMgGFGnyF0OlLXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E942800D41;
        Fri, 13 Dec 2019 16:18:12 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F91219C4F;
        Fri, 13 Dec 2019 16:17:57 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 00/12] hw/i386/pc: Move PC-machine specific declarations to 'pc_internal.h'
Date:   Fri, 13 Dec 2019 17:17:41 +0100
Message-Id: <20191213161753.8051-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Since you posted your "x86: allow building without PC machine
types" series [1], I looked at my past work on this topic
(restrict "hw/i386/pc.h" to the X86 architecture).
I'm glad to see in [2] you remove most (all) of the last uses.
Since I haven't looked at this for some time, my WiP branch was
quite diverged from QEMU master. I guess I could salvage most of
the easy patches. The rest is QOMification of GSI/IOAPIC which
require various changes with the i8259, so I'll keep that for
later.

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664760.html
[2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg664765.html

Philippe Mathieu-Daud=C3=A9 (12):
  hw/i386/pc: Convert DPRINTF() to trace events
  hw/i386/pc: Move kvm_i8259_init() declaration to sysemu/kvm.h
  hw/i386/pc: Remove obsolete pc_pci_device_init() declaration
  hw/i386/pc: Remove obsolete cpu_set_smm_t typedef
  hw/i386/ich9: Remove unused include
  hw/i386/ich9: Move unnecessary "pci_bridge.h" include
  hw/ide/piix: Remove superfluous DEVICE() cast
  hw/ide/piix: Use ARRAY_SIZE() instead of magic numbers
  hw/intc/ioapic: Make ioapic_print_redtbl() static
  hw/i386/pc: Rename allocate_cpu_irq from 'pc' to 'x86_machine'
  hw/i386/pc: Move x86_machine_allocate_cpu_irq() to 'hw/i386/x86.c'
  hw/i386/pc: Move PC-machine specific declarations to 'pc_internal.h'

 hw/i386/pc_internal.h             | 144 ++++++++++++++++++++++++++++++
 include/hw/i386/ich9.h            |   2 -
 include/hw/i386/ioapic_internal.h |   1 -
 include/hw/i386/pc.h              | 133 ---------------------------
 include/hw/i386/x86.h             |   2 +
 include/sysemu/kvm.h              |   1 +
 hw/i386/acpi-build.c              |   2 +
 hw/i386/microvm.c                 |   2 +-
 hw/i386/pc.c                      |  47 ++--------
 hw/i386/pc_piix.c                 |   1 +
 hw/i386/pc_q35.c                  |   1 +
 hw/i386/pc_sysfw.c                |   1 +
 hw/i386/x86.c                     |  30 +++++++
 hw/i386/xen/xen-hvm.c             |   1 +
 hw/ide/piix.c                     |  29 +++---
 hw/intc/ioapic_common.c           |   2 +-
 hw/pci-bridge/i82801b11.c         |   1 +
 hw/i386/trace-events              |   6 ++
 18 files changed, 211 insertions(+), 195 deletions(-)
 create mode 100644 hw/i386/pc_internal.h

--=20
2.21.0

