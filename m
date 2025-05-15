Return-Path: <kvm+bounces-46618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E47AB7AC3
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F27097AE949
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B154238C2A;
	Thu, 15 May 2025 00:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hI3XEg2k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8357C22087
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747270447; cv=none; b=ZJxHgH24nS1wc+vaCOHCOJqzPyTPgxWwnJe7gYC6w/ipTrTfWnkqV2DyedGb7/GIRxXCTWc8ZONobKkdFZU3T4TLEIsOLVS1gOzRg185GvG8Ofrlyu5lFEeotadctXnHdSVyVx4PHk+EGai/60hL1VYVJvu6KXef8m5MS5gu6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747270447; c=relaxed/simple;
	bh=O2OUuxS1TvLm8UPF+2JIjDDSuE02I2KvMZIfEj53AHg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=g0wtpAejZSyaGW4BuMRDAz1bUFkGZAkfzFsvX5HELqX+ZdI/KniLSs/YtcPbzpusPePY+N6zVGjEfP+fioToyD9oI7AvUNgc66Dp/3vw1HTUkoRtIZY1ClrC3KJW809O+Zf76T3QL4YjfNFspJKrWfQqlLe/YGTIDDPdAeh9stk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hI3XEg2k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747270444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OwOhaUKYMcYdajHkBCsvthiJ6+3Me92agWtcSjHCN2g=;
	b=hI3XEg2kniWD5oMfF0vIcbIC8lY0nRh00J5DgzowT7fgHzdNn+1ZnYV6n/0YGHWEUk8kSo
	jfmsGw29RXqoh1M3bUyLFtEJXevv7T5Bw5lmTfIqdg1dA2I0FzHf8C58arj04N8k1++0Ag
	wd9i3sG6BCOlXi2rrsWwmFmClWpGk1c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-vIyQgpMtPa-wfEF0LcHqOQ-1; Wed,
 14 May 2025 20:53:59 -0400
X-MC-Unique: vIyQgpMtPa-wfEF0LcHqOQ-1
X-Mimecast-MFC-AGG-ID: vIyQgpMtPa-wfEF0LcHqOQ_1747270438
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6DC51955DCE;
	Thu, 15 May 2025 00:53:56 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3181019560A7;
	Thu, 15 May 2025 00:53:54 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 0/4] KVM: x86: allow DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM passthrough
Date: Wed, 14 May 2025 20:53:49 -0400
Message-ID: <20250515005353.952707-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
V4: incorporated review feedback.=0D
=0D
Best regards,=0D
     Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  x86: nVMX: check vmcs12->guest_ia32_debugctl value given by L2=0D
  x86: KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM=0D
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
 arch/x86/kvm/vmx/nested.c          |  8 +++++--=0D
 arch/x86/kvm/vmx/tdx.c             |  3 ++-=0D
 arch/x86/kvm/vmx/vmx.c             | 36 +++++++++++++++++++++---------=0D
 arch/x86/kvm/vmx/vmx.h             |  4 ++++=0D
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++--=0D
 arch/x86/kvm/x86.c                 | 18 ++++++++++-----=0D
 10 files changed, 70 insertions(+), 42 deletions(-)=0D
=0D
-- =0D
2.46.0=0D
=0D


