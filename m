Return-Path: <kvm+bounces-43379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8F0A8ACA8
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 02:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF80517E62A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 00:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840F71A5B98;
	Wed, 16 Apr 2025 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIpN202J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14A1A23AD
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744763160; cv=none; b=fzdJ0HzkYlTForgXAS8DSd99nNV9bFy7JzvAgq2ruasDBgwr1Pidry6z1D6U//C7pEsyBeYNZOXvn3S/g5Sy+li1pIsbnF/p5S2S1CHNz614+Daj0dHYTXp7Llt8rtS4yrqV9QC7EV88cirNvhyEUjgcmIvnXyKDXQfhKu1I3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744763160; c=relaxed/simple;
	bh=rAQB06qNKaTpCQ5F1V2P860tIuKiVC0zxgSe13IoRek=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=s5lAZ+4WgcWpYHbIhHFSI/M9J5MqHXr4kJuzRy1vMcwS+BheDFdWVHPExUwTjcR3RoA8+FNVaemc19Sw5O6CdWiKTTEbOf2VhBn0GZ5z4LfmAVuaEObiTKHaZ49r/0mfwkuXB0W7bp5n57UFvdbrfD5d7hBINmAnQAb4omJ6Nqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIpN202J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744763157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6VRzsCXdjsEm2LcwvX2WIfWWs2J/juCRAQ9Ar72ntks=;
	b=TIpN202JY6JgRW9qxzzNzqxiQwgVa8xNqLsjqF1n130a/u8rsgid0QM706e7pQhV9BMQZq
	i7m59VBRgOu4I5l7Xxkf3BFcCqFydjYDKBvF+SJw96cLzCmojWI63vwj7qwV+D5Mc/uf7O
	/CX9eZgWR+tsk0fO2tWJgGAzdPukvBM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-41e5qrCiPtW36mNL1R4woA-1; Tue,
 15 Apr 2025 20:25:52 -0400
X-MC-Unique: 41e5qrCiPtW36mNL1R4woA-1
X-Mimecast-MFC-AGG-ID: 41e5qrCiPtW36mNL1R4woA_1744763150
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50FE8180025B;
	Wed, 16 Apr 2025 00:25:50 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.37])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 686BB180B489;
	Wed, 16 Apr 2025 00:25:47 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] KVM: x86: allow DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM passthrough
Date: Tue, 15 Apr 2025 20:25:43 -0400
Message-Id: <20250416002546.3300893-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
Best regards,=0D
     Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write with access=0D
    functions=0D
  x86: KVM: VMX: cache guest written value of MSR_IA32_DEBUGCTL=0D
  x86: KVM: VMX: preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while in the=0D
    guest mode=0D
=0D
 arch/x86/kvm/svm/svm.c       |  2 +=0D
 arch/x86/kvm/vmx/nested.c    | 15 +++++--=0D
 arch/x86/kvm/vmx/pmu_intel.c |  9 ++--=0D
 arch/x86/kvm/vmx/vmx.c       | 87 +++++++++++++++++++++++++++---------=0D
 arch/x86/kvm/vmx/vmx.h       |  4 ++=0D
 arch/x86/kvm/x86.c           |  2 -=0D
 6 files changed, 89 insertions(+), 30 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


