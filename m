Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00ED52F2742
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbhALEpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:45:54 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:41799 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbhALEpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:53 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0R0784z9sWC; Tue, 12 Jan 2021 15:45:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426711;
        bh=7hHllMpehAyZjZNsuKhkyTJVPh53/m3oZinqtAXXwig=;
        h=From:To:Cc:Subject:Date:From;
        b=jIoVRrqF9kp65OoqeHl3I+JcrR8Aao8xY6IDnC3P5tSNvuft/QMx4yw1G3taZ8Zrl
         tpSYa9cPixT/DRMOeibFsRXkGWHOmTHvfmwRXhV9kh4Uvwhc/ZXbcO1JiSGMb61ESf
         p6cYcCBEeSoVNl+l4Wg4GoOIANmq+61iwwMJYv6g=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 00/13] Generalize memory encryption models
Date:   Tue, 12 Jan 2021 15:44:55 +1100
Message-Id: <20210112044508.427338-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
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
"confidential-guest-support" property pointing to a platform specific=0D
object which configures and manages the specific details.=0D
=0D
Note to Ram Pai: the documentation I've included for PEF is very=0D
minimal.  If you could send a patch expanding on that, it would be=0D
very helpful.=0D
=0D
Changes since v5:=0D
 * Renamed from "securable guest memory" to "confidential guest=0D
   support"=0D
 * Simpler reworking of x86 boot time flash encryption=0D
 * Added a bunch of documentation=0D
 * Fixed some compile errors on POWER=0D
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
  confidential guest support: Introduce new confidential guest support=0D
    class=0D
  sev: Remove false abstraction of flash encryption=0D
  confidential guest support: Move side effect out of=0D
    machine_set_memory_encryption()=0D
  confidential guest support: Rework the "memory-encryption" property=0D
  sev: Add Error ** to sev_kvm_init()=0D
  confidential guest support: Introduce cgs "ready" flag=0D
  confidential guest support: Move SEV initialization into arch specific=0D
    code=0D
  confidential guest support: Update documentation=0D
  spapr: Add PEF based confidential guest support=0D
  spapr: PEF: prevent migration=0D
  confidential guest support: Alter virtio default properties for=0D
    protected guests=0D
  s390: Recognize confidential-guest-support option=0D
=0D
Greg Kurz (1):=0D
  qom: Allow optional sugar props=0D
=0D
 accel/kvm/kvm-all.c                       |  38 -------=0D
 accel/kvm/sev-stub.c                      |  10 +-=0D
 accel/stubs/kvm-stub.c                    |  10 --=0D
 backends/confidential-guest-support.c     |  30 ++++++=0D
 backends/meson.build                      |   1 +=0D
 docs/amd-memory-encryption.txt            |   2 +-=0D
 docs/confidential-guest-support.txt       |  48 +++++++++=0D
 docs/papr-pef.txt                         |  30 ++++++=0D
 docs/system/s390x/protvirt.rst            |  19 ++--=0D
 hw/core/machine.c                         |  71 +++++++++++--=0D
 hw/i386/pc_sysfw.c                        |  17 ++-=0D
 hw/ppc/meson.build                        |   1 +=0D
 hw/ppc/pef.c                              | 122 ++++++++++++++++++++++=0D
 hw/ppc/spapr.c                            |  10 ++=0D
 hw/s390x/pv.c                             |  58 ++++++++++=0D
 include/exec/confidential-guest-support.h |  48 +++++++++=0D
 include/hw/boards.h                       |   2 +-=0D
 include/hw/ppc/pef.h                      |  26 +++++=0D
 include/hw/s390x/pv.h                     |   1 +=0D
 include/qemu/typedefs.h                   |   1 +=0D
 include/qom/object.h                      |   3 +-=0D
 include/sysemu/kvm.h                      |  16 ---=0D
 include/sysemu/sev.h                      |   4 +-=0D
 qom/object.c                              |   4 +-=0D
 softmmu/rtc.c                             |   3 +-=0D
 softmmu/vl.c                              |  17 +--=0D
 target/i386/kvm/kvm.c                     |  12 +++=0D
 target/i386/sev-stub.c                    |   5 +=0D
 target/i386/sev.c                         |  93 +++++++----------=0D
 target/ppc/kvm.c                          |  18 ----=0D
 target/ppc/kvm_ppc.h                      |   6 --=0D
 target/s390x/kvm.c                        |   3 +=0D
 32 files changed, 540 insertions(+), 189 deletions(-)=0D
 create mode 100644 backends/confidential-guest-support.c=0D
 create mode 100644 docs/confidential-guest-support.txt=0D
 create mode 100644 docs/papr-pef.txt=0D
 create mode 100644 hw/ppc/pef.c=0D
 create mode 100644 include/exec/confidential-guest-support.h=0D
 create mode 100644 include/hw/ppc/pef.h=0D
=0D
-- =0D
2.29.2=0D
=0D
