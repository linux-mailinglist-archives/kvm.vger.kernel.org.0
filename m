Return-Path: <kvm+bounces-32003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 224219D10B3
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C3841F2324A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D96419ADA2;
	Mon, 18 Nov 2024 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="k3JhEAHK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36B613A86A;
	Mon, 18 Nov 2024 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933604; cv=none; b=hU4IBOlNhD66vDixbncrbKSAeDpnoArT1/chrR/CszgP1AtABkBfx81d70YFlaNzOOGRcfHVDw4oqi4T9qSrxDtm+Cfxa8+JTyv/FAZET/r9L+SL4ShAzoeYgiHyVtqcgNoRImvJh/5mtMqeY57zWnKIGwACEnrKd2Zf6Idh8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933604; c=relaxed/simple;
	bh=00M39CEkTVs3xVd4M1e0BsfnsNXxWk5Gp34SYT7JxJk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F0UaWqF4rJUjGsO3YGVGIK5re1+rwk0MQ3djA2PaoGJ9uq9HwwrscpnCYQuw+nKB7Dlv6xVLAqtbclZ0COJJ9ikj8Otoq2tjzSY+MPv01TYh4OrmQaIV8fE9SucBfSzFIWQANgHSkRvirUhEDVBjdsqqS4CtPb3l/PKgb0Wyw9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=k3JhEAHK; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933603; x=1763469603;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0KIdbqYUO6Zv8eVf+NQoyrINVlwuJ6bN4A3SGV37H6Y=;
  b=k3JhEAHKCayrIiy5OfCzeXI1TXUoUSh9O0uJSvcFUZbte4+wnY1YBGD/
   nhVS0XA5Ptr76gfqHkOqJiHAic0UnvXEkVN1KeuwMx8gZj+QjpnVBD6et
   ri94WqbdScdysJo17r+ImybRrI60VGs85xKnM5n/t0IRxEhtg0x9vzrQh
   g=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="449876552"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:39:58 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:64963]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.74:2525] with esmtp (Farcaster)
 id 0c3fabae-6b8b-4c0f-81ad-6b8450cdad29; Mon, 18 Nov 2024 12:39:56 +0000 (UTC)
X-Farcaster-Flow-ID: 0c3fabae-6b8b-4c0f-81ad-6b8450cdad29
Received: from EX19D014EUA004.ant.amazon.com (10.252.50.41) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:39:54 +0000
Received: from EX19MTAUEC002.ant.amazon.com (10.252.135.146) by
 EX19D014EUA004.ant.amazon.com (10.252.50.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:39:53 +0000
Received: from email-imr-corp-prod-pdx-all-2b-dbd438cc.us-west-2.amazon.com
 (10.124.125.6) by mail-relay.amazon.com (10.252.135.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:39:53 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2b-dbd438cc.us-west-2.amazon.com (Postfix) with ESMTPS id 8482DA018B;
	Mon, 18 Nov 2024 12:39:49 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <corbet@lwn.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <david@redhat.com>, <peterx@redhat.com>,
	<oleg@redhat.com>, <vkuznets@redhat.com>, <gshan@redhat.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [RFC PATCH 0/6] KVM: x86: async PF user
Date: Mon, 18 Nov 2024 12:39:42 +0000
Message-ID: <20241118123948.4796-1-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Async PF [1] allows to run other processes on a vCPU while the host
handles a stage-2 fault caused by a process on that vCPU. When using
VM-exit-based stage-2 fault handling [2], async PF functionality is lost
because KVM does not run the vCPU while a fault is being handled so no
other process can execute on the vCPU. This patch series extends
VM-exit-based stage-2 fault handling with async PF support by letting
userspace handle faults instead of the kernel, hence the "async PF user"
name.

I circulated the idea with Paolo, Sean, David H, and James H at the LPC,
and the only concern I heard was about injecting the "page not present"
event via #PF exception in the CoCo case, where it may not work. In my
implementation, I reused the existing code for doing that, so the async
PF user implementation is on par with the present async PF
implementation in this regard, and support for the CoCo case can be
added separately.

Please note that this series is applied on top of the VM-exit-based
stage-2 fault handling RFC [2].

Implementation

The following workflow is implemented:
 - A process in the guest causes a stage-2 fault.
 - KVM checks whether the fault can be handled asynchronously. If it
   can, KVM prepares the VM exit info that contains a newly added "async
   PF flag" raised and an async PF token value corresponding to the
   fault.
 - Userspace reads the VM exit info and resumes the vCPU immediately.
   Meanwhile it processes the fault.
 - When the fault is resolved, userspace calls a new async ioctl using
   the token to notify KVM.
 - KVM communicates to the guest that the process can be resumed.

Notes:
 - No changes to the x86 async PF PV interface are required
 - The series does not introduce new dependencies on x86 compared to the
   existing async PF

Testing

Inspired by [3], I built a Firecracker-based setup, where Firecracker
implemented the VM-exit-based fault handling. I observed that a workload
consisting of a CPU-bound and memory-bound threads running concurrently
was executing faster with async PF user enabled: with 10 ms-long fault
processing, it was 26% faster.

It is difficult to provide an objective performance comparison between
async PF kernel and async PF user, because async PF user can only work
with VM-exit-based fault handling, which has its own performance
characteristics compared to in-kernel fault handling or UserfaultFD.

The patch series is built on top of the VM-exit-based stage-2 fault
handling RFC [2].

Patch 1 updates documentation to reflect [2] changes.
Patches 2-6 add the implementation of async PF user.

Questions:
 - Are there any general concerns about the approach?
 - Can we leave the CoCo use case aside for now, or do we need to
   support it straight away?
 - What is the desired level of coupling between async PF and async PF
   user? For now, I kept the coupling to the bare minimum (only the
   PV-related data structure is shared between the two).

[1] https://kvm-forum.qemu.org/2021/sdei_apf_for_arm64_gavin.pdf
[2] https://lore.kernel.org/kvm/CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com/T/
[3] https://lore.kernel.org/all/20200508032919.52147-1-gshan@redhat.com/

Nikita

Nikita Kalyazin (6):
  Documentation: KVM: add userfault KVM exit flag
  Documentation: KVM: add async pf user doc
  KVM: x86: add async ioctl support
  KVM: trace events: add type argument to async pf
  KVM: x86: async_pf_user: add infrastructure
  KVM: x86: async_pf_user: hook to fault handling and add ioctl

 Documentation/virt/kvm/api.rst  |  35 ++++++
 arch/x86/include/asm/kvm_host.h |  12 +-
 arch/x86/kvm/Kconfig            |   7 ++
 arch/x86/kvm/lapic.c            |   2 +
 arch/x86/kvm/mmu/mmu.c          |  68 ++++++++++-
 arch/x86/kvm/x86.c              | 101 +++++++++++++++-
 arch/x86/kvm/x86.h              |   2 +
 include/linux/kvm_host.h        |  30 +++++
 include/linux/kvm_types.h       |   1 +
 include/trace/events/kvm.h      |  50 +++++---
 include/uapi/linux/kvm.h        |  12 +-
 virt/kvm/Kconfig                |   3 +
 virt/kvm/Makefile.kvm           |   1 +
 virt/kvm/async_pf.c             |   2 +-
 virt/kvm/async_pf_user.c        | 197 ++++++++++++++++++++++++++++++++
 virt/kvm/async_pf_user.h        |  24 ++++
 virt/kvm/kvm_main.c             |  14 +++
 17 files changed, 535 insertions(+), 26 deletions(-)
 create mode 100644 virt/kvm/async_pf_user.c
 create mode 100644 virt/kvm/async_pf_user.h


base-commit: 15f01813426bf9672e2b24a5bac7b861c25de53b
-- 
2.40.1


