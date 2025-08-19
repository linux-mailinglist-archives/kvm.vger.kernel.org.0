Return-Path: <kvm+bounces-54987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 072B4B2C697
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 211F917F64F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8662147E6;
	Tue, 19 Aug 2025 14:04:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0011FDA8E;
	Tue, 19 Aug 2025 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612246; cv=none; b=u9z8IDgnRTxo67JV9yUe+UE3lhnbe2q6diXD01BfbYOAngekrUNshBy+c3lKRbaf5LXj3pc8+R1z8AnToyslQePJ2dfbkq5tg9AcCRhUAAmXep27JEd6kwuzkk4UvXuNzcGq0VKT1uFGZL2RX4RUxNJ/oK4DIJnOYm1a2FocAf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612246; c=relaxed/simple;
	bh=72F2xWA+YdfB2QtAEk4aX3LIRSMBxtBbqBIGnK0sQWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jRrcRWZse5ve1ZXR/0BfS9XNyATOvYiyPDTa2gm0ClRdktv3Sc6pPFGLuDv7sBYRTvgIYQfDzhevo6UxJdazIspKCMQpGYaHJhOJZhN4t6M4TKCMj0TDB4vVmY69Q0KSMGxO1szPsfeyGucwvDx1X+HHd2SB8lw7h1wiGtpPmNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uoMRq-00000001OeL-20zC;
	Tue, 19 Aug 2025 15:32:22 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: SVM: Fix missing LAPIC TPR sync into VMCB::V_TPR with AVIC on
Date: Tue, 19 Aug 2025 15:32:13 +0200
Message-ID: <cover.1755609446.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

When AVIC is enabled the normal pre-VMRUN LAPIC TPR to VMCB::V_TPR sync in
sync_lapic_to_cr8() is inhibited so any changed TPR in the LAPIC state would
*not* get copied into the V_TPR field of VMCB.

AVIC does sync between these two fields, however it does so only on
explicit guest writes to one of these fields, not on a bare VMRUN.

This is especially true when it is the userspace setting LAPIC state via
KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
VMCB.

Practice shows that it is the V_TPR that is actually used by the AVIC to
decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
so any leftover value in V_TPR will cause serious interrupt delivery issues
in the guest when AVIC is enabled.

Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
similar code paths when AVIC is enabled.

Add also a relevant set of tests to xapic_state_test so hopefully
we'll be protected against getting such regressions in the future.


Yes, this breaks real guests when AVIC is enabled.
Specifically, the one OS that sometimes needs different handling and its
name begins with letter 'W'.


  KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR when setting LAPIC regs
  KVM: selftests: Test TPR / CR8 sync and interrupt masking

 arch/x86/kvm/svm/avic.c                       |  23 ++
 .../testing/selftests/kvm/include/x86/apic.h  |   5 +
 .../selftests/kvm/x86/xapic_state_test.c      | 265 +++++++++++++++++-
 3 files changed, 290 insertions(+), 3 deletions(-)


