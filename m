Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D0200003
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgFSCGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:10 -0400
Received: from ozlabs.org ([203.11.71.1]:45405 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgFSCGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:10 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GS0p6Yz9sRR; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532368;
        bh=3plDeY4nzUK5TNGdwXZl3rLW3KII0RZMy/LwwJOA+zQ=;
        h=From:To:Cc:Subject:Date:From;
        b=nW1oBNmlP9ShhH8fWDNLyBsl6jA7kUTKJwRFNh2J37Y3xmsaaxqVbvZdpy69Bi7DT
         6VUTVMKEDfU02D7AT08Kz2cCutW9+sgr9M3FMgPWCmgTqowCG0zfbZ7k2e3CNrTLUJ
         I++GvWVXqU1p2B6VuhqiA1zLHNEoBx5NL9wwJCHo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com
Subject: [PATCH v3 0/9] Generalize memory encryption models
Date:   Fri, 19 Jun 2020 12:05:53 +1000
Message-Id: <20200619020602.118306-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
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
"host-trust-limitation" property pointing to a platform specific=0D
object which configures and manages the specific details.=0D
=0D
For now this series covers just AMD SEV and POWER PEF.  I'm hoping it=0D
can be extended to cover the Intel and s390 mechanisms as well,=0D
though.=0D
=0D
Please apply.=0D
=0D
Changes since RFCv2:=0D
 * Rebased=0D
 * Removed preliminary SEV cleanups (they've been merged)=0D
 * Changed name to "host trust limitation"=0D
 * Added migration blocker to the PEF code (based on SEV's version)=0D
Changes since RFCv1:=0D
 * Rebased=0D
 * Fixed some errors pointed out by Dave Gilbert=0D
=0D
David Gibson (9):=0D
  host trust limitation: Introduce new host trust limitation interface=0D
  host trust limitation: Handle memory encryption via interface=0D
  host trust limitation: Move side effect out of=0D
    machine_set_memory_encryption()=0D
  host trust limitation: Rework the "memory-encryption" property=0D
  host trust limitation: Decouple kvm_memcrypt_*() helpers from KVM=0D
  host trust limitation: Add Error ** to HostTrustLimitation::kvm_init=0D
  spapr: Add PEF based host trust limitation=0D
  spapr: PEF: block migration=0D
  host trust limitation: Alter virtio default properties for protected=0D
    guests=0D
=0D
 accel/kvm/kvm-all.c                  |  40 ++------=0D
 accel/kvm/sev-stub.c                 |   7 +-=0D
 accel/stubs/kvm-stub.c               |  10 --=0D
 backends/Makefile.objs               |   2 +=0D
 backends/host-trust-limitation.c     |  29 ++++++=0D
 hw/core/machine.c                    |  61 +++++++++--=0D
 hw/i386/pc_sysfw.c                   |   6 +-=0D
 include/exec/host-trust-limitation.h |  72 +++++++++++++=0D
 include/hw/boards.h                  |   2 +-=0D
 include/qemu/typedefs.h              |   1 +=0D
 include/sysemu/kvm.h                 |  17 ----=0D
 include/sysemu/sev.h                 |   4 +-=0D
 target/i386/sev.c                    | 146 ++++++++++++---------------=0D
 target/ppc/Makefile.objs             |   2 +-=0D
 target/ppc/pef.c                     |  89 ++++++++++++++++=0D
 15 files changed, 325 insertions(+), 163 deletions(-)=0D
 create mode 100644 backends/host-trust-limitation.c=0D
 create mode 100644 include/exec/host-trust-limitation.h=0D
 create mode 100644 target/ppc/pef.c=0D
=0D
-- =0D
2.26.2=0D
=0D
