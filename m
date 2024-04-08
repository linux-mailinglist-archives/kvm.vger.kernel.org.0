Return-Path: <kvm+bounces-13921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D34A89CE39
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FF51B221EC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7B7149C66;
	Mon,  8 Apr 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="moo4OuYb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF0B146A74;
	Mon,  8 Apr 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712614079; cv=none; b=UWeV0m4LWh4F1Xv43NPVEmCESAHtIQyjBSeP6wczpOD1xqgM7EIN3mV/VT8VtbkOWnkd6g/aFHeiqauR8/zehoSAkmyruSC9w5wVbMh1RmiWjon/rusjqAR3QgO5J6knnGxZMV0ROlzhHVSuQKMTLJh+7CxNGAEUe/nF/VyEyM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712614079; c=relaxed/simple;
	bh=P5hRDy1wg+C00YeG8BTUnFaiaw3vCXyKjsGOdD10sf4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TtjdI8xYqSI7sY/GFqof5KhtI+8KoP/HMFroS1eZbz7WPbifmdyi6cmGmtrVZ4Elk3NXl1rq2QFONRrdZ7LfHso/BWlxO7NUAsjvUQOVNXkTpA7xN/vZRPE11OmtjUmL3+s3XsYPbev9kElaGMJv0wVvI4oKUHd1ebDYY2xfrdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=moo4OuYb; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712614078; x=1744150078;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BNWghUNyuV6Lk+YyDToi8Tsw6HLVZtok1GuBByD/mfA=;
  b=moo4OuYbI4mRHszXvSW5YzqcXxBnWbqrWfmewPhXBDX3GGnCeT0Xu6MP
   6ejV2XG0i4e3B07jlSqiDunLaa5a9QjvW0w62P7VqiWnocQAiJz335O2S
   mrX0t0ata1LS0yE151bsqqTcvi63E2Vy0vfDZUTPIqeajm9NNk5iP6kZv
   w=;
X-IronPort-AV: E=Sophos;i="6.07,187,1708387200"; 
   d="scan'208";a="717029174"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 22:07:51 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:39488]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.41:2525] with esmtp (Farcaster)
 id 3f231b9f-fb77-49ec-83b1-2a4b83555169; Mon, 8 Apr 2024 22:07:49 +0000 (UTC)
X-Farcaster-Flow-ID: 3f231b9f-fb77-49ec-83b1-2a4b83555169
Received: from EX19D033EUC002.ant.amazon.com (10.252.61.215) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 8 Apr 2024 22:07:43 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUC002.ant.amazon.com (10.252.61.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 8 Apr 2024 22:07:43 +0000
Received: from dev-dsk-jalliste-1c-e3349c3e.eu-west-1.amazon.com
 (10.13.244.142) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Mon, 8 Apr 2024 22:07:42 +0000
From: Jack Allister <jalliste@amazon.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
CC: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, "Jack
 Allister" <jalliste@amazon.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Add API to correct KVM/PV clock drift 
Date: Mon, 8 Apr 2024 22:07:02 +0000
Message-ID: <20240408220705.7637-1-jalliste@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Guest VMs can be provided with a para-virtualized clock source to
perform timekeeping. A KVM guest can map in a PV clock via the
MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW virtualized MSRs.
Where as on a Xen guest this can be provided via the vcpu/shared
info pages.

These PV clocks both use a common structure which is mapped between
host <-> guest to provide the PVTI (paravirtual time information)
for the clock. This reference information is a guest TSC timestamp
and a host system time at a SINGULAR point in time.

If KVM decides to update the reference information due to a
KVM_REQ_MASTERCLOCK_UPDATE, a drift between the guest TSC and
the PV clock can be observed, this is exascerbated when the guest
TSC is also scaled too.  

If the reference guest TSC & system time within the structure stay
the same there is no potential for a drift between the TSC and PV
clock.

This series adds in two patches, one to add in API/ioctl to allow
a VMM to perform a correction/fixup of the PVTI structure when it
knows that KVM may have updated the KVM clock information and a
second one to verify that the drift is present & corrected.

Jack Allister (2):
  KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock drift fixup
  KVM: selftests: Add KVM/PV clock selftest to prove timer drift
    correction

 Documentation/virt/kvm/api.rst                |  43 ++++
 arch/x86/kvm/x86.c                            |  87 +++++++
 include/uapi/linux/kvm.h                      |   3 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pvclock_test.c       | 223 ++++++++++++++++++
 5 files changed, 357 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pvclock_test.c


base-commit: 8cb4a9a82b21623dbb4b3051dd30d98356cf95bc
-- 
2.40.1


