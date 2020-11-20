Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3272BAAA0
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgKTM44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:56:56 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50174 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgKTM44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605877016; x=1637413016;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Tu3ky8QtpoG4/ntezhBA0uUewx/dtdgS9ou84KSbXl8=;
  b=kemxds01Hy9ZOiA/cyOlZsjA2fDKKF7z08zVtylrUMQJ8NWoZkPkWnlt
   I8La4by+AA5nfQb+nQKwlvhSYY+LIttlBvFBSESfGmzpg6whV0R1LA7jU
   bf5ioDaWQ2bEdSMiViuRG+kKSK1JFA/B1lJ2Lo32zPLyiTzmD9yba1itl
   k=;
X-IronPort-AV: E=Sophos;i="5.78,356,1599523200"; 
   d="scan'208";a="65112994"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 20 Nov 2020 12:56:48 +0000
Received: from EX13D01EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 930ACA18CE;
        Fri, 20 Nov 2020 12:56:43 +0000 (UTC)
Received: from EX13D52EUA002.ant.amazon.com (10.43.165.139) by
 EX13D01EUA002.ant.amazon.com (10.43.165.199) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:42 +0000
Received: from uc995cb558fb65a.ant.amazon.com (10.43.162.50) by
 EX13D52EUA002.ant.amazon.com (10.43.165.139) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:37 +0000
From:   <darkhan@amazon.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <corbet@lwn.net>, <maz@kernel.org>,
        <james.morse@arm.com>, <catalin.marinas@arm.com>,
        <chenhc@lemote.com>, <paulus@ozlabs.org>, <frankja@linux.ibm.com>,
        <mingo@redhat.com>, <acme@redhat.com>, <graf@amazon.de>,
        <darkhan@amazon.de>, Darkhan Mukashov <darkhan@amazon.com>
Subject: [PATCH 0/3] Introduce new vcpu ioctls KVM_(GET|SET)_MANY_REGS
Date:   Fri, 20 Nov 2020 13:56:13 +0100
Message-ID: <20201120125616.14436-1-darkhan@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D32UWB001.ant.amazon.com (10.43.161.248) To
 EX13D52EUA002.ant.amazon.com (10.43.165.139)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Darkhan Mukashov <darkhan@amazon.com>

The ultimate goal is to introduce new vcpu ioctls KVM_(GET|SET)_MANY_REGS.
To introduce these ioctls, implementations of KVM_(GET|SET)_ONE_REG have
to be refactored. Specifically, KVM_(GET|SET)_ONE_REG should be handled in
a generic kvm_vcpu_ioctl function.

New KVM APIs KVM_(GET|SET)_MANY_REGS make it possible to bulk read/write
vCPU registers at one ioctl call. These ioctls can be very useful when
vCPU state serialization/deserialization is required (e.g. live update of
kvm, live migration of guests), hence all registers have to be
saved/restored. KVM_(GET|SET)_MANY_REGS will help avoid performance
overhead associated with syscall (ioctl in our case) handling. Tests
conducted on AWS Graviton2 Processors (64-bit ARM Neoverse cores) show
that average save/restore time of all vCPU registers can be optimized
~3.5 times per vCPU with new ioctls. Test results can be found in Table 1.
+---------+-------------+---------------+
|         | kvm_one_reg | kvm_many_regs |
+---------+-------------+---------------+
| get all |   123 usec  |    33 usec    |
+---------+-------------+---------------+
| set all |   120 usec  |    36 usec    |
+---------+-------------+---------------+
	Table 1. Test results

The patches are based out of kvm/queue.

Darkhan Mukashov (3):
  Documentation: KVM: change description of vcpu ioctls
    KVM_(GET|SET)_ONE_REG
  KVM: handle vcpu ioctls KVM_(GET|SET)_ONE_REG in a generic function
  KVM: introduce new vcpu ioctls KVM_GET_MANY_REGS and KVM_SET_MANY_REGS

 Documentation/virt/kvm/api.rst     | 80 ++++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h  |  5 +-
 arch/arm64/kvm/arm.c               | 25 +++-------
 arch/arm64/kvm/guest.c             |  6 ++-
 arch/mips/include/asm/kvm_host.h   |  6 +++
 arch/mips/kvm/mips.c               | 32 ++++++------
 arch/powerpc/include/asm/kvm_ppc.h |  2 -
 arch/powerpc/kvm/powerpc.c         | 20 ++------
 arch/s390/include/asm/kvm_host.h   |  6 +++
 arch/s390/kvm/kvm-s390.c           | 38 +++++++-------
 arch/x86/kvm/x86.c                 | 12 +++++
 include/linux/kvm_host.h           | 18 +++++++
 include/uapi/linux/kvm.h           | 11 ++++
 virt/kvm/kvm_main.c                | 62 +++++++++++++++++++++++
 14 files changed, 244 insertions(+), 79 deletions(-)

-- 
2.17.1

