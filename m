Return-Path: <kvm+bounces-40434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32030A57372
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4A37189911B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DA5257AFF;
	Fri,  7 Mar 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DivcZmOY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFED20FA9C
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382464; cv=none; b=AiAR4eRTLw7xz1EVxRtWUPdWJ2VTSFA1HlkNUvZ78Z8iv3yvQFXY367lk39qwlbseaCFfdGzOUM+o1e9XXyF7mtRgS4TKUk6MdlCzhgMI1e8xjA/XD+gQncr9Yqz95AVf//aVElyWwqfcpZU3abEjB2KMCi0UQWDqP+smxHIdf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382464; c=relaxed/simple;
	bh=qrcIMU9U9DsBF5V3/PQV1D3t6SaK+EsSQxKpxWX4Vpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p+2xJ8Ha9lcAHeccS61Pv1c3DWThKtCTQOJE4Yyy3qZwLa+Ko9QTvfuOj2ZYtkaoqLRPtfGN2k/jOdMdNyVLWFfM6lv57lIT9jzjTqivbrZN2bEfIqS7b6GmSPZvFbVtHszGKAcDgpCurg2UeDB+cR/qWVIC6s3kzi+vqYwrLJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DivcZmOY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TVPc86QDGWiEvS+VR4wqbSlUQGU+L2IWUkT/81scyXw=;
	b=DivcZmOYLE8ARJONiIztLH0+dcWZHx1sRJCPzPEdcSoWMb0VlD3SrCKdpOnwzsg2CLWYAT
	bnHpKIG94ere7FlIYYyglRgbZggbkDn5qv6hCHI3YPV3EmYRkfWlSY966jm8iK5T7MU3WL
	VWaYDVTe+/DBwZ8jeGizOPUxkqP7F3w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-ZeGQP00UO-ukQBiQPD0alw-1; Fri,
 07 Mar 2025 16:20:56 -0500
X-MC-Unique: ZeGQP00UO-ukQBiQPD0alw-1
X-Mimecast-MFC-AGG-ID: ZeGQP00UO-ukQBiQPD0alw_1741382455
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D62418004A9;
	Fri,  7 Mar 2025 21:20:55 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 850471956095;
	Fri,  7 Mar 2025 21:20:54 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 00/10] KVM: TDX: TD vcpu enter/exit
Date: Fri,  7 Mar 2025 16:20:42 -0500
Message-ID: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

The changes from v2 here mostly come from Xiaoyao's review, with which
I mostly agreed:

- moving the preparation for user return notifiers to prepare_switch_to_host,

- squashing "x86/virt/tdx: Make tdh_vp_enter() noinstr" into patch 1

- dropping "KVM: TDX: Set arch.has_protected_state
  to true" which is now part of one of the earlier series.

- replacing TDX_REGS_UNSUPPORTED_SET with the strict list of registers
  that (at least potentially) are made available in unencrypted form

The major change however is rewriting "KVM: TDX: restore host xsave
state when exit from the guest TD" to not use kvm_load_host_xsave_state().
There's a disagreement between me and Sean on that topic, but posting
the patches is the best way to clear that up.  Also for this reason I'm
including an extra patch at the end providing the hunks that were (or
should be) only needed in order to appease kvm_load_host_xsave_state();
I have tested without it and unlike the rest it is not included in kvm-coco-queue.

Paolo

Adrian Hunter (2):
  KVM: TDX: Disable support for TSX and WAITPKG
  KVM: TDX: Save and restore IA32_DEBUGCTL

Binbin Wu (1):
  KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct

Chao Gao (1):
  KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
    wrmsr

Isaku Yamahata (5):
  KVM: TDX: Implement TDX vcpu enter/exit path
  KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
  KVM: TDX: restore host xsave state when exit from the guest TD
  KVM: TDX: restore user ret MSRs
  KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
    behavior

Kai Huang (1):
  x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

Paolo Bonzini (1):
  [NOT FOR UPSTREAM] KVM: TDX: put somewhat sensible values in vCPU for
    encrypted registers

 arch/x86/include/asm/kvm_host.h  |  12 +-
 arch/x86/include/asm/tdx.h       |   1 +
 arch/x86/kvm/vmx/common.h        |  68 ++++++++++
 arch/x86/kvm/vmx/main.c          |  48 ++++++-
 arch/x86/kvm/vmx/nested.c        |  10 +-
 arch/x86/kvm/vmx/posted_intr.c   |  18 +--
 arch/x86/kvm/vmx/tdx.c           | 264 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h           |  20 ++-
 arch/x86/kvm/vmx/vmx.c           |  99 +++++++--------
 arch/x86/kvm/vmx/vmx.h           | 104 ++++++---------
 arch/x86/kvm/vmx/x86_ops.h       |  11 ++
 arch/x86/kvm/x86.c               |  28 ++++-
 arch/x86/virt/vmx/tdx/seamcall.S |   3 +
 arch/x86/virt/vmx/tdx/tdx.c      |   8 ++
 arch/x86/virt/vmx/tdx/tdx.h      |   1 +
 15 files changed, 541 insertions(+), 154 deletions(-)

-- 
2.43.5


