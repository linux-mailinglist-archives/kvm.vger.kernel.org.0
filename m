Return-Path: <kvm+bounces-55648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42278B347DD
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAB663B6171
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67AF2FE059;
	Mon, 25 Aug 2025 16:44:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEA419CD1D;
	Mon, 25 Aug 2025 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756140291; cv=none; b=GUWVuNc/+3eXlttYDqutG+o8iy4kv3vMq6Jvdge27+am1xwSgKYMim4ov16iLHEL6nVjttd16Hg2oa/vXCDpaIVV5u8EU2CY1vyslBktfKaDOuTTyia9+FgLj8yv9SBtGj76R45iWCFQDdbJe4dT835tKjWfsFTRU/W99nvvELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756140291; c=relaxed/simple;
	bh=Y3xkisiSVIBWNyBSvA6GThK5rhkafC+aHeo8KML5ig0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eyuKBULPbzUsYsqsoCfDXbfc7gMMjibCC5LNpbsXZe85IkEIhhvgtbWD29Vx/a9EhD9vtz7Wi5RqdnUPT3pymVkeDnC+A5L6kBV8nBOmhLe9culypmR06nLC/Egtz6ytTWlg4BJk/WYDQkb63RTMjhuam0hXrZAhdGkGAWRCh3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1uqaJ9-00000001lNk-1pTP;
	Mon, 25 Aug 2025 18:44:35 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: SVM: Fix missing LAPIC TPR sync into VMCB::V_TPR with AVIC on
Date: Mon, 25 Aug 2025 18:44:27 +0200
Message-ID: <cover.1756139678.git.maciej.szmigiero@oracle.com>
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

This is an updated v2 patch series of the v1 series located at:
https://lore.kernel.org/kvm/cover.1755609446.git.maciej.szmigiero@oracle.com/


Changes from v1:
Fix this issue by doing unconditional LAPIC -> V_TPR sync at each VMRUN
rather than by just patching the KVM_SET_LAPIC ioctl() code path
(and similar ones).


Maciej S. Szmigiero (2):
  KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active
  KVM: selftests: Test TPR / CR8 sync and interrupt masking

 arch/x86/kvm/svm/svm.c                        |   3 +-
 .../testing/selftests/kvm/include/x86/apic.h  |   5 +
 .../selftests/kvm/x86/xapic_state_test.c      | 265 +++++++++++++++++-
 3 files changed, 268 insertions(+), 5 deletions(-)


