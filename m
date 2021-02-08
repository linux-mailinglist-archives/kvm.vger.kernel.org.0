Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4DA312A80
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBHGIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:08:54 -0500
Received: from ozlabs.org ([203.11.71.1]:52753 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhBHGIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:08:20 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwY530HTz9sVS; Mon,  8 Feb 2021 17:07:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764457;
        bh=QsTd9JlyiVYrs3pv84qEB+xJRgsi2LtjtpT0TDKtuCg=;
        h=From:To:Cc:Subject:Date:From;
        b=aojv2eevwznM1oxyGihVQxinvEvYiPX62FHlR8nZqngu2v/iNZkiZnKQ+rsMbzt1/
         BqfFh4ldp7ESi64E6ll0DW8qrZ49ibRyHGoFFI24DH3zMdM2lS65Eep4usEI+sadR2
         /bwgnwi2cgv9P4rTan5QIRfIf8XIecGYsBBiu2qE=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, qemu-devel@nongnu.org, peter.maydell@linaro.org,
        dgilbert@redhat.com, brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     richard.henderson@linaro.org, ehabkost@redhat.com,
        cohuck@redhat.com, david@redhat.com, berrange@redhat.com,
        mtosatti@redhat.com, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        mst@redhat.com, borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        jun.nakajima@intel.com, frankja@linux.ibm.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Thomas Huth <thuth@redhat.com>,
        andi.kleen@intel.com, Greg Kurz <groug@kaod.org>,
        qemu-s390x@nongnu.org
Subject: [PULL v9 00/13] Cgs patches
Date:   Mon,  8 Feb 2021 17:07:22 +1100
Message-Id: <20210208060735.39838-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 5b19cb63d9dfda41b412373b8c9fe14641bcab60=
:=0D
=0D
  Merge remote-tracking branch 'remotes/rth-gitlab/tags/pull-tcg-20210205' =
in=3D=0D
to staging (2021-02-05 22:59:12 +0000)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://gitlab.com/dgibson/qemu.git tags/cgs-pull-request=0D
=0D
for you to fetch changes up to 651615d92d244a6dfd7c81ab97bd3369fbe41d06:=0D
=0D
  s390: Recognize confidential-guest-support option (2021-02-08 16:57:38 +1=
10=3D=0D
0)=0D
=0D
----------------------------------------------------------------=0D
Generalize memory encryption models=0D
=0D
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
Changes since v8:=0D
 * Rebase=0D
 * Fixed some cosmetic typos=0D
Changes since v7:=0D
 * Tweaked and clarified meaning of the 'ready' flag=0D
 * Polished the interface to the PEF internals=0D
 * Shifted initialization for s390 PV later (I hope I've finally got=0D
   this after apply_cpu_model() where it needs to be)=0D
Changes since v6:=0D
 * Moved to using OBJECT_DECLARE_TYPE and OBJECT_DEFINE_TYPE macros=0D
 * Assorted minor fixes=0D
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
----------------------------------------------------------------=0D
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
 accel/kvm/kvm-all.c                       |  38 ------=0D
 accel/kvm/sev-stub.c                      |  10 +-=0D
 accel/stubs/kvm-stub.c                    |  10 --=0D
 backends/confidential-guest-support.c     |  33 +++++=0D
 backends/meson.build                      |   1 +=0D
 docs/amd-memory-encryption.txt            |   2 +-=0D
 docs/confidential-guest-support.txt       |  49 ++++++++=0D
 docs/papr-pef.txt                         |  30 +++++=0D
 docs/system/s390x/protvirt.rst            |  19 ++-=0D
 hw/core/machine.c                         |  63 ++++++++--=0D
 hw/i386/pc_sysfw.c                        |  17 +--=0D
 hw/ppc/meson.build                        |   1 +=0D
 hw/ppc/pef.c                              | 140 ++++++++++++++++++++++=0D
 hw/ppc/spapr.c                            |   8 +-=0D
 hw/s390x/pv.c                             |  62 ++++++++++=0D
 hw/s390x/s390-virtio-ccw.c                |   3 +=0D
 include/exec/confidential-guest-support.h |  62 ++++++++++=0D
 include/hw/boards.h                       |   2 +-=0D
 include/hw/ppc/pef.h                      |  17 +++=0D
 include/hw/s390x/pv.h                     |  17 +++=0D
 include/qemu/typedefs.h                   |   1 +=0D
 include/qom/object.h                      |   3 +-=0D
 include/sysemu/kvm.h                      |  16 ---=0D
 include/sysemu/sev.h                      |   4 +-=0D
 qom/object.c                              |   4 +-=0D
 softmmu/rtc.c                             |   3 +-=0D
 softmmu/vl.c                              |  27 ++++-=0D
 target/i386/kvm/kvm.c                     |  20 ++++=0D
 target/i386/sev-stub.c                    |   5 +=0D
 target/i386/sev.c                         |  95 ++++++---------=0D
 target/ppc/kvm.c                          |  18 ---=0D
 target/ppc/kvm_ppc.h                      |   6 -=0D
 32 files changed, 595 insertions(+), 191 deletions(-)=0D
 create mode 100644 backends/confidential-guest-support.c=0D
 create mode 100644 docs/confidential-guest-support.txt=0D
 create mode 100644 docs/papr-pef.txt=0D
 create mode 100644 hw/ppc/pef.c=0D
 create mode 100644 include/exec/confidential-guest-support.h=0D
 create mode 100644 include/hw/ppc/pef.h=0D
=0D
--=3D20=0D
2.29.2=0D
=0D
