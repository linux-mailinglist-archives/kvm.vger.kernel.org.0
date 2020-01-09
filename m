Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1522135C8A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgAIPVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:21:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28988 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727945AbgAIPVx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 10:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=P5RGdQrGsYtgUOKj0M4myzDzBUaBMtcy1aS0kbUYf64=;
        b=HlRgdg4L1OFxKuK1oL71gdPD2nLs5sEInQxTz/meMDlxcrBIgjIpGc5/87km2Q6QcKMaX6
        8tNR0boKB1PbNvm/vL7rZqs6Bquv9gU6Dn07jOadxA4vMJPb5hB5mO99TQrft2gxW9jXA5
        z7GY2FgOBhmKjwdp4kaglMzZYpyw1LA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-Z6-I5PgHMWWbDGkeCQozUg-1; Thu, 09 Jan 2020 10:21:48 -0500
X-MC-Unique: Z6-I5PgHMWWbDGkeCQozUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACD758C2BE1;
        Thu,  9 Jan 2020 15:21:45 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F14D27FB5C;
        Thu,  9 Jan 2020 15:21:36 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 00/15] Replace current_machine by qdev_get_machine()
Date:   Thu,  9 Jan 2020 16:21:18 +0100
Message-Id: <20200109152133.23649-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Blurb from previous question [1]:

  "hw/boards.h" declare current_machine, and vl.c defines it:

    current_machine =3D MACHINE(object_new_with_class(OBJECT_CLASS(machin=
e_class)));
    object_property_add_child(object_get_root(), "machine",
                              OBJECT(current_machine), &error_abort);

  The bigger user of 'current_machine' is the accel/KVM code.

  Recently in a0628599f..cc7d44c2e0 "Replace global smp variables
  with machine smp properties" we started to use MACHINE(qdev_get_machine=
()).
  Following a0628599f..cc7d44c2e0, a5e0b33119 use 'current_machine' again=
.

  qdev_get_machine() resolves the machine in the QOM composition tree.

Paolo answered [2]:

> I would always use MACHINE(qdev_get_machine()), espeecially outside
> vl.c.  Ideally, current_machine would be static within vl.c or even
> unused outside the object_property_add_child() that you quote above.

Let's remove the global current_machine.

I am still confused by this comment:

  /* qdev_get_machine() can return something that's not TYPE_MACHINE
   * if this is one of the user-only emulators; in that case there's
   * no need to check the ignore_memory_transaction_failures board flag.
   */

[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg669475.html
[2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg669493.html

Philippe Mathieu-Daud=C3=A9 (15):
  target/arm/kvm: Use CPUState::kvm_state in kvm_arm_pmu_supported()
  hw/ppc/spapr_rtas: Use local MachineState variable
  hw/ppc/spapr_rtas: Access MachineState via SpaprMachineState argument
  hw/ppc/spapr_rtas: Restrict variables scope to single switch case
  device-hotplug: Replace current_machine by qdev_get_machine()
  migration/savevm: Replace current_machine by qdev_get_machine()
  hw/core/machine-qmp-cmds: Replace current_machine by
    qdev_get_machine()
  target/arm/monitor: Replace current_machine by qdev_get_machine()
  device_tree: Replace current_machine by qdev_get_machine()
  memory: Replace current_machine by qdev_get_machine()
  exec: Replace current_machine by qdev_get_machine()
  accel: Introduce the current_accel() method
  accel: Replace current_machine->accelerator by current_accel() method
  accel/accel: Replace current_machine by qdev_get_machine()
  vl: Make current_machine a local variable

 include/hw/boards.h        |  2 --
 include/sysemu/accel.h     |  2 ++
 accel/accel.c              |  7 +++++++
 accel/kvm/kvm-all.c        |  4 ++--
 accel/tcg/tcg-all.c        |  2 +-
 device-hotplug.c           |  2 +-
 device_tree.c              |  4 +++-
 exec.c                     | 10 ++++++----
 hw/core/machine-qmp-cmds.c |  4 ++--
 hw/ppc/spapr_rtas.c        |  6 +++---
 memory.c                   |  6 ++++--
 migration/savevm.c         | 10 +++++-----
 target/arm/kvm.c           |  4 +---
 target/arm/kvm64.c         |  4 ++--
 target/arm/monitor.c       |  3 ++-
 target/i386/kvm.c          |  2 +-
 target/ppc/kvm.c           |  2 +-
 vl.c                       |  6 +++---
 18 files changed, 46 insertions(+), 34 deletions(-)

--=20
2.21.1

