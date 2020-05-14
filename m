Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DB21D27FD
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgENGld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:33 -0400
Received: from ozlabs.org ([203.11.71.1]:60495 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbgENGlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:32 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j0crHz9sSd; Thu, 14 May 2020 16:41:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=vvYudY/uRKvNzTDTxC0FfBGKSAwOXcVJGXD3YDR90r8=;
        h=From:To:Cc:Subject:Date:From;
        b=Qi1X9mS3JVsGJg+QbwlDGmsYTuiA4YSccRAY/Py97qcQMVRwNMOPvlEs7c7Pn91lu
         GWudnf/ACmQ0Y39KeD7PtetxzEiQhHc/FV+7ArvAPj3DM3cDsg2Q1DWrkBWnz+TisQ
         E9EReUmtMIIyFJvFy6eQpPzjN9qoLK8mWZnJum7c=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 00/18] Refactor configuration of guest memory protection
Date:   Thu, 14 May 2020 16:41:02 +1000
Message-Id: <20200514064120.449050-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
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
"guest-memory-protection" property pointing to a platform specific=0D
object which configures and manages the specific details.=0D
=0D
For now this series covers just AMD SEV and POWER PEF.  I'm hoping it=0D
can be extended to cover the Intel and s390 mechanisms as well,=0D
though.=0D
=0D
Note: I'm using the term "guest memory protection" throughout to refer=0D
to mechanisms like this.  I don't particular like the term, it's both=0D
long and not really precise.  If someone can think of a succinct way=0D
of saying "a means of protecting guest memory from a possibly=0D
compromised hypervisor", I'd be grateful for the suggestion.=0D
=0D
David Gibson (18):=0D
  target/i386: sev: Remove unused QSevGuestInfoClass=0D
  target/i386: sev: Move local structure definitions into .c file=0D
  target/i386: sev: Rename QSevGuestInfo=0D
  target/i386: sev: Embed SEVState in SevGuestState=0D
  target/i386: sev: Partial cleanup to sev_state global=0D
  target/i386: sev: Remove redundant cbitpos and reduced_phys_bits=0D
    fields=0D
  target/i386: sev: Remove redundant policy field=0D
  target/i386: sev: Remove redundant handle field=0D
  target/i386: sev: Unify SEVState and SevGuestState=0D
  guest memory protection: Add guest memory protection interface=0D
  guest memory protection: Handle memory encrption via interface=0D
  guest memory protection: Perform KVM init via interface=0D
  guest memory protection: Move side effect out of=0D
    machine_set_memory_encryption()=0D
  guest memory protection: Rework the "memory-encryption" property=0D
  guest memory protection: Decouple kvm_memcrypt_*() helpers from KVM=0D
  use errp for gmpo kvm_init=0D
  spapr: Added PEF based guest memory protection=0D
  guest memory protection: Alter virtio default properties for protected=0D
    guests=0D
=0D
 accel/kvm/kvm-all.c                    |  40 +--=0D
 accel/kvm/sev-stub.c                   |   5 -=0D
 accel/stubs/kvm-stub.c                 |  10 -=0D
 backends/Makefile.objs                 |   2 +=0D
 backends/guest-memory-protection.c     |  29 ++=0D
 hw/core/machine.c                      |  61 ++++-=0D
 hw/i386/pc_sysfw.c                     |   6 +-=0D
 include/exec/guest-memory-protection.h |  77 ++++++=0D
 include/hw/boards.h                    |   4 +-=0D
 include/sysemu/kvm.h                   |  17 --=0D
 include/sysemu/sev.h                   |   6 +-=0D
 target/i386/sev.c                      | 358 +++++++++++++------------=0D
 target/i386/sev_i386.h                 |  49 ----=0D
 target/ppc/Makefile.objs               |   2 +-=0D
 target/ppc/pef.c                       |  81 ++++++=0D
 15 files changed, 445 insertions(+), 302 deletions(-)=0D
 create mode 100644 backends/guest-memory-protection.c=0D
 create mode 100644 include/exec/guest-memory-protection.h=0D
 create mode 100644 target/ppc/pef.c=0D
=0D
-- =0D
2.26.2=0D
=0D
