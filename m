Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351DB22BC36
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgGXC6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGXC5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:50 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C3EC0619D3
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 19:57:50 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlv1BKjz9sRN; Fri, 24 Jul 2020 12:57:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559467;
        bh=g66FwVz1r6nGsK6XJ5UcsyTZuDIgWFh7d1+V/6AC+0I=;
        h=From:To:Cc:Subject:Date:From;
        b=C5PGevUJgzVOgAIu9G1YJhVIdy5YZzXT+TIXBMNYd8rze8zDPZv1/8gf29OGzcCak
         ATvVaZzSVokHz9AhNsJE1rtRAYtsBidm6G0Lzm0Tm4MbDJ8y+aiBC7OIzzEzqzEBN8
         qbj5gC930eEbwMu5xJee3GuQS/SvIHYplFgh53EY=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [for-5.2 v4 00/10] Generalize memory encryption models
Date:   Fri, 24 Jul 2020 12:57:34 +1000
Message-Id: <20200724025744.69644-1-david@gibson.dropbear.id.au>
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
Please apply.=0D
=0D
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
David Gibson (10):=0D
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
  s390: Recognize host-trust-limitation option=0D
=0D
 accel/kvm/kvm-all.c                  |  40 ++------=0D
 accel/kvm/sev-stub.c                 |   7 +-=0D
 accel/stubs/kvm-stub.c               |  10 --=0D
 backends/Makefile.objs               |   2 +=0D
 backends/host-trust-limitation.c     |  29 ++++++=0D
 hw/core/machine.c                    |  61 +++++++++--=0D
 hw/i386/pc_sysfw.c                   |   6 +-=0D
 hw/s390x/pv.c                        |  61 +++++++++++=0D
 include/exec/host-trust-limitation.h |  72 +++++++++++++=0D
 include/hw/boards.h                  |   2 +-=0D
 include/qemu/typedefs.h              |   1 +=0D
 include/sysemu/kvm.h                 |  17 ---=0D
 include/sysemu/sev.h                 |   4 +-=0D
 target/i386/sev.c                    | 148 ++++++++++++---------------=0D
 target/ppc/Makefile.objs             |   2 +-=0D
 target/ppc/pef.c                     |  89 ++++++++++++++++=0D
 16 files changed, 387 insertions(+), 164 deletions(-)=0D
 create mode 100644 backends/host-trust-limitation.c=0D
 create mode 100644 include/exec/host-trust-limitation.h=0D
 create mode 100644 target/ppc/pef.c=0D
=0D
-- =0D
2.26.2=0D
=0D
