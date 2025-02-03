Return-Path: <kvm+bounces-37135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D09D4A26103
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE4B1884790
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FBC20E02B;
	Mon,  3 Feb 2025 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Obo/iH59"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB6020ADE0;
	Mon,  3 Feb 2025 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738602602; cv=none; b=YbNc8qLkX5c8j1S+XVBoJ79KGek8jNcds+uJ4UQBfJVw+UvlM6I/GKcrT3901jlwMXhgsfjRwhZ+Eh5TnBZsWyCKkcel/sAzod9Mh0G/TIYlREvniNFCcz9/zkgDJ+t9Pxjq706pCFjsEI59nPJnTsk7RvLdLlMPPd4XBGvt48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738602602; c=relaxed/simple;
	bh=/xOWC5s+kBlz25L3alti/wKPz7ym2Cwd9PBQxKFX9Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y68hZ77hq4DPXO0anf9AcNHAq86DsJiuUDV0Bjm+ANX2hd+ZZXhmakxOH0ACGEfnQUgf9LZjKdFtzPusItuTkHjoK3PusTKTlSmaTkSUxxbSKqz52zpf6NcF44a4dknprR/ewC194rUG56REmazmnCJZMNDbfbnN765z7DO65Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Obo/iH59; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B93C4CED2;
	Mon,  3 Feb 2025 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738602601;
	bh=/xOWC5s+kBlz25L3alti/wKPz7ym2Cwd9PBQxKFX9Oo=;
	h=From:To:Cc:Subject:Date:From;
	b=Obo/iH59DoimLTEV+3mdrMYojvojshGcrN6xcvAcqqSV4PNS4OxcVm/uzkYQ+6GC2
	 CuihOQmiSMqiaXOLGBb2m6jOmFJBC2hyWSP9nilxG6S7T0V7zejy1WhFrKfTlKXyFB
	 dtuq8Sjo6+sVnB+AiLL2lqBWDP8EQ42CE5vRCjBrN+hKo6sTD29BNQFZynst6U7Vjv
	 MVMX2u4K44CGmzFjF3YSZELsO16jRCngD7GYuyPDpYkCrLGVRDaUfdJznLl8A8x07G
	 hXaiSogNKJmZCHYvdqO5qo60jeFpKbJTOv6GjPCmHbibgn+HvnEons88aQ3mzcJ0dV
	 SI7QtrPJ5BOjA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 0/3] KVM: x86: Address performance degradation due to APICv inhibits
Date: Mon,  3 Feb 2025 22:33:00 +0530
Message-ID: <cover.1738595289.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When AVIC is enabled (kvm_amd avic=1), guests with kernel-irqchip=on and 
PIT in reinject mode (default configuration) show degraded performance.  
This is because even though APICv is inhibited, we see other inhibits 
being set/cleared causing contention on apicv_update_lock. Rework 
inhibit code so that apicv_update_lock is not required unless APICv 
state is changing. More details in patch 3.

In a test setup with two guests (-smp 16, -netdev tap,vhost=on, -device 
virtio-net-pci,mq=on), multiple instances of netperf TCP_RR sending 
traffic to the other guest, sar shows:

Without this patch series, kvm_amd avic=0 (default):
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ens2 1323407.59 1323406.87 250722.47 126654.46      0.00      0.00      0.00      0.00

Without this patch series, kvm_amd avic=1:
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ens2 1057711.25 1057697.51 200385.83 101225.23      0.00      0.00      0.00      0.00

We see ~20% degradation in packet rate.

With this patch series, kvm_amd avic=1:
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:         ens2 1315433.91 1315434.46 249211.99 125891.47      0.00      0.00      0.00      0.00


- Naveen



Naveen N Rao (AMD) (3):
  KVM: x86: hyper-v: Convert synic_auto_eoi_used to an atomic
  KVM: x86: Remove use of apicv_update_lock when toggling guest debug
    state
  KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons

 arch/x86/include/asm/kvm_host.h |  14 ++--
 arch/x86/kvm/hyperv.c           |  17 ++---
 arch/x86/kvm/x86.c              | 125 ++++++++++++++++----------------
 3 files changed, 72 insertions(+), 84 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1


