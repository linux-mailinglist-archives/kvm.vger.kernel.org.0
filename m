Return-Path: <kvm+bounces-30867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B9C9BE0FA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058051C22FF4
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E758B1D5CE0;
	Wed,  6 Nov 2024 08:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vw44fnpC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24BB1D54D1
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881846; cv=none; b=kW8Ni001t4RRRVf7lGxWccLJWkWx0oCCTlwUSeDaGBO4Bcz2JpJp5NG09LhcRalTeHemkPYGF1Gr9iCwvUVSqq9u1fymdyvY+2BCQZGXnJo8Y3rryvTOQBFfgROfU5BIsB+15vzVCcJ7CJr83SCcsFiTBKvcVJi+ZyEu1L7zl4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881846; c=relaxed/simple;
	bh=tavsWSyECWwwbRMUfMpNbqjrocxYQjPLaI64Xy8DqdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FRGMF0RwLddYlFJAhVH1pBrC8cfhbjhRAaopqr9MKEvILncaaXfoEzhNiilJheUbxdJl/4WNWNWDpGvRJkfs9qKir6vvSnAkzClYjJ8juYfphcdGc0OsqIPAGTnTBM6SaAssCHrvU2nyDkPF3OWg5HeguuD8K5INDvyqkISyEFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vw44fnpC; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e59dc7df64so7779597b3.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 00:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881843; x=1731486643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=diXjwQHhYDrLApdizCzZAM2Cz7No88ZBnmospkxRJcg=;
        b=Vw44fnpCqOvk7DArdsPYYBwp9tABsKAyeA4cIZBR9FIhC3OGsK2UmiyTMtpjjshJy5
         YbihGVqNmQlRy5g9Jsr72IaBdK9tKxqi7TwuwZDoow/CbxltiKJKrzatvuekreTcQz7U
         LYorITi7cb2VlTxv2+FyFO+kEwKsNinQLg9qFB3G3V21O4D893xmNTw+i8B4kHyAcAgk
         bkHKlqLOY1qJWBCL/v4pCMBF9A6MPE46S6cS194k0kTUViiHyWM3dGV5UmOBYn/yj9pT
         EKxDS4JnQEbuq0By9sOUqEoiCdICokYv8XbGaSxUTiH0KVZoX6XpBhDFLv0/6lx7Xlhe
         ndtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881843; x=1731486643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diXjwQHhYDrLApdizCzZAM2Cz7No88ZBnmospkxRJcg=;
        b=mZZMWwMWmcLIIKhlNfQ0DGzInD2XYLqbquyO+HYudWmMrc2+wdtMmsZvMEutycQSyY
         vfYdMkeyTS/L+xrfJxGjVBz4/tPbacIzN4YroTdIVMi8OWjnSi6MqOuCrf1F/H4/oxcU
         OrOMOCZkgzAxdDN+mhyhKda/DIkGukxrnF09GtKirn0jHCwINmKauPedkhlqGX1oGViH
         +wlJ9PWwlOUEVnCDsdjlLgf00ia38gWxCruBmcmJTXN7CkIRL2h6XRnO+98q4TCsVoX+
         U3O+LhUxtVKkVMIip8tVPa0TTtYeqEP/aDCUoQPOlxExbeSHrMxs5bp/FGR1MTyW3v+A
         Iq3Q==
X-Gm-Message-State: AOJu0YyJc+ZVS8eYUr4owIGEIKVbcn94NrQ32lMnZhlZk2BtfLaz1ZPc
	5uigJTxZi5Wkf69vIoNj7yOrcxmBVvvWsWWweryXZPGvmLyqhlpK0O/LOQJtZ3YGYYis+mV6sPP
	u8Y7gY7DPuv9/7BRz/SSFihnrVba0bP4ztc0t7wXo5h4fYFCiiWIxBnFCU4kJdmxGZMt2elYbMq
	N/LiBLAhVyD1OauMuVP58BVeU5vySlO1jOmD0v5eWMgaCKAxUYcvB+Nss=
X-Google-Smtp-Source: AGHT+IHBjq15b6Y9u9NLiJuGhJ0HwVi1u2HdYmZIETeo0dLVKCCo/ZW6prnAhvaB3StzEMzIb/ffCzTWRHXU7A2VXw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:4a04:b0:6ea:881b:b545 with
 SMTP id 00721157ae682-6eabf0290c6mr591907b3.4.1730881843278; Wed, 06 Nov 2024
 00:30:43 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:33 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-3-jingzhangos@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

vgic_its_save_device_tables will traverse its->device_list to
save DTE for each device. vgic_its_restore_device_tables will
traverse each entry of device table and check if it is valid.
Restore if valid.

But when MAPD unmaps a device, it does not invalidate the
corresponding DTE. In the scenario of continuous saves
and restores, there may be a situation where a device's DTE
is not saved but is restored. This is unreasonable and may
cause restore to fail. This patch clears the corresponding
DTE when MAPD unmaps a device.

Co-developed-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2381bc5ce544..7c57c7c6fbff 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * The spec does not say whether unmapping a not-mapped device
 	 * is an error, so we are done in any case.
 	 */
-	if (!valid)
+	if (!valid) {
+		struct kvm *kvm = its->dev->kvm;
+		int dte_esz = vgic_its_get_abi(its)->dte_esz;
+		u64 val = 0;
+
+		if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+			return -EINVAL;
+
+		vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
 		return 0;
+	}
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
-- 
2.47.0.277.g8800431eea-goog


