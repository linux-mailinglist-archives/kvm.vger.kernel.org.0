Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7B2CE7AA
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgLDFpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:01 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37939 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgLDFpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:00 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8f5b6bz9sT5; Fri,  4 Dec 2020 16:44:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060658;
        bh=mxWjWsAC0dVXxgKbwgpPWZDm0iZBSpsgilWWeTLy1wA=;
        h=From:To:Cc:Subject:Date:From;
        b=VvdNlqruhi8QpiSlhHbtiZmcLN+T/iqxrEaYWyAPqXmFUKeQj43iZdpFnJU378aJq
         AjsaiHVW2SGmCfXMTOKRxdvm7exQZ1idr85upuRz1XjerQecmgliAPzW6dk5zJeTR/
         d/0Gq7iSG0cFDUmkMNUyMSgSdsgWxSXB75PuKVag=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 00/13] Generalize memory encryption models
Date:   Fri,  4 Dec 2020 16:44:02 +1100
Message-Id: <20201204054415.579042-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A number of hardware platforms are implementing mechanisms whereby the=0D
hypervisor does not have unfettered access to guest memory, in order=0D
to mitigate the security impact of a compromised hypervisor.=0D
=0D
AMD's SEV implements this with in-cpu memory encryption, and Intel has=0D
its own memory encryption mechanism.  POWER has an upcoming mechanism=0D
to accomplish this in a different way, using a new memory protection=0D
level plus a small trusted ultravisor.  s390 also has a protected=0D
execution environment.=0D
=0D
The current code (committed or draft) for these features has each=0D
platform's version configured entirely differently.  That doesn't seem=0D
ideal for users, or particularly for management layers.=0D
=0D
AMD SEV introduces a notionally generic machine option=0D
"machine-encryption", but it doesn't actually cover any cases other=0D
than SEV.=0D
=0D
This series is a proposal to at least partially unify configuration=0D
for these mechanisms, by renaming and generalizing AMD's=0D
"memory-encryption" property.  It is replaced by a=0D
"securable-guest-memory" property pointing to a platform specific=0D
object which configures and manages the specific details.=0D
=0D
Changes since v4:=0D
 * Renamed from "host trust limitation" to "securable guest memory",=0D
   which I think is marginally more descriptive=0D
 * Re-organized initialization, because the previous model called at=0D
   kvm_init didn't work for s390=0D
* Assorted fixes to the s390 implementation; rudimentary testing=0D
  (gitlab CI) only=0D
Changes since v3:=0D
 * Rebased=0D
 * Added first cut at handling of s390 protected virtualization=0D
Changes since RFCv2:=0D
 * Rebased=0D
 * Removed preliminary SEV cleanups (they've been merged)=0D
 * Changed name to "host trust limitation"=0D
 * Added migration blocker to the PEF code (based on SEV's version)=0D
Changes since RFCv1:=0D
 * Rebased=0D
 * Fixed some errors pointed out by Dave Gilbert=0D
=0D
David Gibson (12):=0D
  securable guest memory: Introduce new securable guest memory base=0D
    class=0D
  securable guest memory: Handle memory encryption via interface=0D
  securable guest memory: Move side effect out of=0D
    machine_set_memory_encryption()=0D
  securable guest memory: Rework the "memory-encryption" property=0D
  securable guest memory: Decouple kvm_memcrypt_*() helpers from KVM=0D
  sev: Add Error ** to sev_kvm_init()=0D
  securable guest memory: Introduce sgm "ready" flag=0D
  securable guest memory: Move SEV initialization into arch specific=0D
    code=0D
  spapr: Add PEF based securable guest memory=0D
  spapr: PEF: prevent migration=0D
  securable guest memory: Alter virtio default properties for protected=0D
    guests=0D
  s390: Recognize securable-guest-memory option=0D
=0D
Greg Kurz (1):=0D
  qom: Allow optional sugar props=0D
=0D
 accel/kvm/kvm-all.c                   |  39 +------=0D
 accel/kvm/sev-stub.c                  |  10 +-=0D
 accel/stubs/kvm-stub.c                |  10 --=0D
 backends/meson.build                  |   1 +=0D
 backends/securable-guest-memory.c     |  30 +++++=0D
 hw/core/machine.c                     |  71 ++++++++++--=0D
 hw/i386/pc_sysfw.c                    |   6 +-=0D
 hw/ppc/meson.build                    |   1 +=0D
 hw/ppc/pef.c                          | 124 +++++++++++++++++++++=0D
 hw/ppc/spapr.c                        |  10 ++=0D
 hw/s390x/pv.c                         |  58 ++++++++++=0D
 include/exec/securable-guest-memory.h |  86 +++++++++++++++=0D
 include/hw/boards.h                   |   2 +-=0D
 include/hw/ppc/pef.h                  |  26 +++++=0D
 include/hw/s390x/pv.h                 |   1 +=0D
 include/qemu/typedefs.h               |   1 +=0D
 include/qom/object.h                  |   3 +-=0D
 include/sysemu/kvm.h                  |  17 ---=0D
 include/sysemu/sev.h                  |   5 +-=0D
 qom/object.c                          |   4 +-=0D
 softmmu/vl.c                          |  16 ++-=0D
 target/i386/kvm.c                     |  12 ++=0D
 target/i386/monitor.c                 |   1 -=0D
 target/i386/sev.c                     | 153 ++++++++++++--------------=0D
 target/ppc/kvm.c                      |  18 ---=0D
 target/ppc/kvm_ppc.h                  |   6 -=0D
 target/s390x/kvm.c                    |   3 +=0D
 27 files changed, 510 insertions(+), 204 deletions(-)=0D
 create mode 100644 backends/securable-guest-memory.c=0D
 create mode 100644 hw/ppc/pef.c=0D
 create mode 100644 include/exec/securable-guest-memory.h=0D
 create mode 100644 include/hw/ppc/pef.h=0D
=0D
-- =0D
2.28.0=0D
=0D
