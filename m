Return-Path: <kvm+bounces-47329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D67BAC0193
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6610E3B4ECC
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8551E70814;
	Thu, 22 May 2025 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZ1nON78"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EDA28F1
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747875368; cv=none; b=M0Hv5FlmZ43/6f5Oe9tRs74cnaG61WUzYnlZWaufAZ4zth1Aor2vUr6ijJQ2p4TUS5x9/iM+ysjwQhq++PFkmZOhucyJRCTWhCLz8bO8aDA3AjgEVyfxnjH1tZVbmFxNTgXiFq+5FNA+vA9hDDawo+MjWGXDUjwMPmQPrHYKtTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747875368; c=relaxed/simple;
	bh=RmfKv3ooNmqxZtp0dXpGdI2YqY3ynDekdBRk/ycgp1M=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WwOlgyrh+crJrfv4wjyHv/mSwWih7BRtirOREiTvtMqNuOFerKxTG96mx1AC4pjCpaRlhvluHote2k1sXiTU6qdkyHaOgQB1UBpc6XZgxy6dQ0OH/s+DT/e3BL+xSQxHsLUwC4p+EG9c3HLIUjPzHCcoazDtwXh9cet0ydcJrvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CZ1nON78; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747875365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nWvO0mY6BHC6eP0jPdFwbPweT5OsbJlQja3VlMg90Ig=;
	b=CZ1nON78Jwfl0Xar+1+mLuPAHIviQ6Be64wq9CvsZk1SCGi4pR+pSkIdP+F1n/ejdRxRSu
	bbtcixH5pGWBz7jP63kcun1//dgMj2daU/GxDX/cf3CGdEDqz7/dqE3c5EOov9nLowUtW2
	CviavIt7CbkHj0dgkHyH8a4pbGIDMqQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-8fX2x-SSP5S7NEvugdqisw-1; Wed,
 21 May 2025 20:56:01 -0400
X-MC-Unique: 8fX2x-SSP5S7NEvugdqisw-1
X-Mimecast-MFC-AGG-ID: 8fX2x-SSP5S7NEvugdqisw_1747875359
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30BC61956094;
	Thu, 22 May 2025 00:55:59 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 74F2C19560B7;
	Thu, 22 May 2025 00:55:56 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 0/5] KVM: x86: allow DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM passthrough
Date: Wed, 21 May 2025 20:55:50 -0400
Message-ID: <20250522005555.55705-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Currently KVM allows the guest to set IA32_DEBUGCTL to whatever value=0D
the guest wants, only capped by a bitmask of allowed bits=0D
=0D
(except in the nested entry where KVM apparently doesn't even check=0D
this set of allowed bits - this patch series also fixes that)=0D
=0D
However some IA32_DEBUGCTL bits can be useful for the host, e.g the=0D
IA32_DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM which isolates the PMU from=0D
the influence of the host's SMM.=0D
=0D
Reshuffle some of the code to allow (currently only this bit) to be passed=
=0D
though from its host value to the guest.=0D
=0D
Note that host value of this bit can be toggled by writing 0 or 1 to=0D
/sys/devices/cpu/freeze_on_smi=0D
=0D
This was tested on a Intel(R) Xeon(R) Silver 4410Y with KVM unit tests and=
=0D
kvm selftests running in parallel with tight loop writing to IO port 0xB2=0D
which on this machine generates #SMIs.=0D
=0D
SMI generation was also verified also by reading the MSR 0x34 which=0D
shows the current count of #SMIs received.=0D
=0D
Despite the flood of #SMIs, the tests survived with this patch applied.=0D
=0D
V5: addressed the review feedback. Thanks.=0D
=0D
I also decided to wrap the read/write of the GUEST_IA32_DEBUGCTL in pmu_int=
el.c as=0D
well, just for the sake of consistency.=0D
=0D
Best regards,=0D
     Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: nVMX: check vmcs12->guest_ia32_debugctl value given by L2=0D
  KVM: VMX: wrap guest access to IA32_DEBUGCTL with wrappers=0D
  KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM=0D
=0D
Sean Christopherson (2):=0D
  KVM: x86: Convert vcpu_run()'s immediate exit param into a generic=0D
    bitmap=0D
  KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |  1 -=0D
 arch/x86/include/asm/kvm_host.h    |  9 ++++++--=0D
 arch/x86/kvm/svm/svm.c             | 14 +++++++-----=0D
 arch/x86/kvm/vmx/main.c            | 15 +++----------=0D
 arch/x86/kvm/vmx/nested.c          |  7 +++---=0D
 arch/x86/kvm/vmx/pmu_intel.c       |  8 +++----=0D
 arch/x86/kvm/vmx/tdx.c             |  3 ++-=0D
 arch/x86/kvm/vmx/vmx.c             | 36 +++++++++++++++++++++---------=0D
 arch/x86/kvm/vmx/vmx.h             |  3 +++=0D
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++--=0D
 arch/x86/kvm/x86.c                 | 18 ++++++++++-----=0D
 11 files changed, 71 insertions(+), 47 deletions(-)=0D
=0D
-- =0D
2.46.0=0D
=0D


