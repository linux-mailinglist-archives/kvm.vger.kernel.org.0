Return-Path: <kvm+bounces-26038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4D796FDDF
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7562D1F2426F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302FF15ADB3;
	Fri,  6 Sep 2024 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ly0fUayQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EE813D251
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725661118; cv=none; b=o1lPuCRZDx0DJ4dcBmRAgu2sFzrjjfLw9isTGB+CSO8oAVxMl+EUAmrifNBEyLmmP6an9kwHfgX4hJwXYac4OisQ+UPqg69AmtQqDL9jwYV8SLy3UqMcliwxHnMQTD8aCJynxC+zhsSIPbVYdGcm2K15yHjQeG7cjLN5VqqYTNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725661118; c=relaxed/simple;
	bh=oDnyoADLZxxoDCVd/HnrxeAvpVLH1ZwcrkNTr9tiixs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=alGLSFItQ9q8CIYggJ8yjzuVA5WfrLCzPYoeWOnVupC4QRe1zAckinnUBP4YzxZgiwgfi7XNsLAA9oT8rOimWHRwpzkZ/STFv0EySyHd7OzBZV57HwVjjBpXtri4RbpvdcSd1loKEYiUhlFKqzCNItQTXU7A+eaAd4SZOupA6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ly0fUayQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725661115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fPS3RfxI/ckV+ClTMJfETVTJewuiT7qYQwOs4/LgDPw=;
	b=Ly0fUayQvyF4jxE7Ra9B1aPC7vUYbEv/3SRl1shrDC3gdJ/BzOxDniw/XAzaIgfmFMafwu
	PLSayBcUOWupLeqSxYXlEc442Kbv8191BrGpJiiSg6LI387orjB/jpx+cYYRlZLoavdef6
	jGI5AhiU/0cb0iaWROEWmXlYRzmlgUg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-HiVZOmlkMNKEVfOjyRGsUQ-1; Fri,
 06 Sep 2024 18:18:32 -0400
X-MC-Unique: HiVZOmlkMNKEVfOjyRGsUQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A28E619560B1;
	Fri,  6 Sep 2024 22:18:27 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1944E19560AA;
	Fri,  6 Sep 2024 22:18:24 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 0/4] Relax canonical checks on some arch msrs
Date: Fri,  6 Sep 2024 18:18:20 -0400
Message-Id: <20240906221824.491834-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Recently we came up upon a failure where likely the guest writes=0D
0xff4547ceb1600000 to MSR_KERNEL_GS_BASE and later on, qemu=0D
sets this value via KVM_PUT_MSRS, and is rejected by the=0D
kernel, likely due to not being canonical in 4 level paging.=0D
=0D
One of the way to trigger this is to make the guest enter SMM,=0D
which causes paging to be disabled, which SMM bios re-enables=0D
but not the whole 5 level. MSR_KERNEL_GS_BASE on the other=0D
hand continues to contain old value.=0D
=0D
I did some reverse engineering and to my surprise I found out=0D
that both Intel and AMD indeed ignore CR4.LA57 when doing=0D
canonical checks on this and other msrs and/or other arch=0D
registers (like GDT base) which contain linear addresses.=0D
=0D
V2: addressed a very good feedback from Chao Gao. Thanks!=0D
=0D
V3: also fix the nested VMX, and also fix the=0D
MSR_IA32_SYSENTER_EIP / MSR_IA32_SYSENTER_ESP=0D
=0D
V4:=0D
  - added PT and PEBS msrs=0D
  - corrected emulation of SGDT/SIDT/STR/SLDT instructions=0D
  - corrected canonical checks for TLB invalidation instructions=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: drop x86.h include from cpuid.h=0D
  KVM: x86: implement emul_is_noncanonical_address using=0D
    is_noncanonical_address=0D
  KVM: x86: model canonical checks more precisely=0D
  KVM: nVMX: fix canonical check of vmcs12 HOST_RIP=0D
=0D
 arch/x86/kvm/cpuid.h         |  1 -=0D
 arch/x86/kvm/emulate.c       | 15 ++++++-----=0D
 arch/x86/kvm/kvm_emulate.h   |  5 ++++=0D
 arch/x86/kvm/mmu.h           |  1 +=0D
 arch/x86/kvm/mmu/mmu.c       |  2 +-=0D
 arch/x86/kvm/vmx/hyperv.c    |  1 +=0D
 arch/x86/kvm/vmx/nested.c    | 35 +++++++++++++++++---------=0D
 arch/x86/kvm/vmx/pmu_intel.c |  2 +-=0D
 arch/x86/kvm/vmx/sgx.c       |  5 ++--=0D
 arch/x86/kvm/vmx/vmx.c       |  4 +--=0D
 arch/x86/kvm/x86.c           | 13 +++++++---=0D
 arch/x86/kvm/x86.h           | 49 ++++++++++++++++++++++++++++++++++--=0D
 12 files changed, 102 insertions(+), 31 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D


