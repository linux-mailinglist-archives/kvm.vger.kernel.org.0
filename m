Return-Path: <kvm+bounces-33955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBC79F4D97
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F4C216BAEF
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5679F1F758A;
	Tue, 17 Dec 2024 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obW6nvlL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716FC1F7086;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445409; cv=none; b=Sxh7xgoTXA29cE1BEP7chTu/XbWyRMyGgJQy5L9zFIEQR9w46M09lGYgID9wtny2yJp+78FIFwLOZPbzuT0I6sFoGjaJBdYjeMCs9hG79CFDLaAVEMFOkkDQEIKfjmMPuAXiF3YzobmHHilY1KYkB981Gd0cSLT+IBvAv/mpXiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445409; c=relaxed/simple;
	bh=wHj4zN377wsDETkTsOjFHCOteV1TAO7OHXuPO+V9MYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VBgfe7E4KYjdy28G3ZENdYBd54shzwIZ0J8nUorEz4pGSjrwxWAHaWifz+JHSj0L+FVkZ2x6R7cHuzXDZVbh8OvhOIyIJxzIWNjhlkO+zN1wP7RyapHnZvgch90kBYND9VsZ6WR2/xrdcapx0QJncOqLbqvSDSVo2ZNcCIsD3CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obW6nvlL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B913C4CED3;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445409;
	bh=wHj4zN377wsDETkTsOjFHCOteV1TAO7OHXuPO+V9MYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obW6nvlLhC7aFXElIrw3wUiRllST8rBB4lolKqmPg2hm/piIKzFuzcNV2AkJ9qOoV
	 svPhr2iywT49TQcEtlfFeRp7UNY4v2GPMn4nrfMpifzL4LmCamcqn98VF4y6F4/1Mx
	 g+pZmq7Y/naH3ggjHCJueIpnH9JIoTnEL/QBrwFefw/ifaPCV+Vg18XmV1Jwe31bvN
	 v+mmGRCBPTHjnN8XXUI6LHBdm0YgMtGbKBTcJKJ+HtiedVRQJtQb1elME5zsimoJxk
	 d2Jp3MTtBVivzvuciUzrB+J2wT9babvI+IKoeC/9ZNyRW0qlxttAhFmEfvEhNmIskW
	 LN17Ir1tyk73A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTv-004aJx-1p;
	Tue, 17 Dec 2024 14:23:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 12/12] KVM: arm64: nv: Document EL2 timer API
Date: Tue, 17 Dec 2024 14:23:20 +0000
Message-Id: <20241217142321.763801-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.rst | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 31f14ec4a65b6..d62ba86ee1668 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -142,8 +142,9 @@ the cpu field to the processor id.
 
 :Architectures: ARM64
 
-2.1. ATTRIBUTES: KVM_ARM_VCPU_TIMER_IRQ_VTIMER, KVM_ARM_VCPU_TIMER_IRQ_PTIMER
------------------------------------------------------------------------------
+2.1. ATTRIBUTES: KVM_ARM_VCPU_TIMER_IRQ_VTIMER, KVM_ARM_VCPU_TIMER_IRQ_PTIMER,
+                 KVM_ARM_VCPU_TIMER_IRQ_HVTIMER, KVM_ARM_VCPU_TIMER_IRQ_HPTIMER,
+--------------------------------------------------------------------------------
 
 :Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
 	     pointer to an int
@@ -159,10 +160,12 @@ A value describing the architected timer interrupt number when connected to an
 in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  Setting the
 attribute overrides the default values (see below).
 
-=============================  ==========================================
-KVM_ARM_VCPU_TIMER_IRQ_VTIMER  The EL1 virtual timer intid (default: 27)
-KVM_ARM_VCPU_TIMER_IRQ_PTIMER  The EL1 physical timer intid (default: 30)
-=============================  ==========================================
+==============================  ==========================================
+KVM_ARM_VCPU_TIMER_IRQ_VTIMER   The EL1 virtual timer intid (default: 27)
+KVM_ARM_VCPU_TIMER_IRQ_PTIMER   The EL1 physical timer intid (default: 30)
+KVM_ARM_VCPU_TIMER_IRQ_HVTIMER  The EL2 virtual timer intid (default: 28)
+KVM_ARM_VCPU_TIMER_IRQ_HPTIMER  The EL2 physical timer intid (default: 26)
+==============================  ==========================================
 
 Setting the same PPI for different timers will prevent the VCPUs from running.
 Setting the interrupt number on a VCPU configures all VCPUs created at that
-- 
2.39.2


