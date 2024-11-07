Return-Path: <kvm+bounces-31188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2D29C1132
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51FE028595A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3283721948C;
	Thu,  7 Nov 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXEPcqsD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF088218D6F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015709; cv=none; b=a7cavy2mgoZXquCCoCxSiTRuyQFg3ZelSECbWWjTaYLpEyc0XYhLU2JXcr+bqq/JDMKgcxYMsqEfgv8OlJ2ck/o0VA3MBxCj0T1CC0lN7eDVkzCEtiLZ09yudRlsCPpgSq6aiybXCpByUtAoKDAlFcwhvI/n78ej1taoPS1Y2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015709; c=relaxed/simple;
	bh=r5PBaY2BtyI/IhYtOVfMJDxFChBMs+Kl4IcmdMX9iPM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nIY61+srYu3VDIUKzgrPle7vpdetd0vtrMXkO4vDzp+s5kz2aeBiNDnp0EYeyq3bPR/rOang/CsV98ix/ogJnVrr1xAs1oq7IM38uFok5w9b5Wj5e61pIh2mc0i69s9f86BgoczGI81s40+O+O3QAZ2d9gxZd6iOnq6v6bcB05o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXEPcqsD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e455defb9so1743127b3a.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015707; x=1731620507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XtpqsepAghjHxA0kDCxZtEi1YPJ/CrW2sXJeZXJ/pOo=;
        b=EXEPcqsDlPbHJycEZhwtdKY6aVBJuODZAmBjPamw58sUfiSvBPc8LCYtGDs2st3v5e
         lHmYLC2+GL3XD+fYeTRiDM9f1D0Csb0sBNTMJFgQOH92K0CarPjNgq0nK6YD5nc9lDCO
         jLNFQr8TQzB0q++/inWTLFeyuad/833fjiZ7mqhuq1N2HoT/8CgImNVvfuzsDJYyD1jx
         iqTOMhHbgo371CKXymXIWfAKIeOGAbCDpGOXFC8i3OH7BT+fF0jXgHPanZrX+1YAepbM
         7ckw4hyGiHV0qB+5wicohEf1FhcUMl5k52ZbrCgIQKD/72NeUnXRShHjzOLljb25Hrk8
         zzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015707; x=1731620507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtpqsepAghjHxA0kDCxZtEi1YPJ/CrW2sXJeZXJ/pOo=;
        b=dpZiOUHmOqZ5fuaERCzk+3I7gTxUCYqCnl5yBhWts2HbUfGABrhKaFZyuzKBt/T6ot
         INga9dvQnL7JcUKBDhNVliloR22rAearsGEiMo75l/qNOG5JkoyAIb8BJ2M6IxwxzKrD
         FnfIr3lL9N1oT0Md8EZOjn+Kdbaa233R0i0t97n8qIu8ap28HQ5jbAQPfqYyRkXGiN0I
         8sd3hQ1vpurgY/fKHAwv5aYRm6wTgBSrwJnFq/RqaYvfCEbZVSf3VH0fh35BicAGQC6j
         XEsLxuHNGIkiKWqIcYE99C1f+LDglSUhNSSRq+BgP0P9tq8Yz9wCS4pFmUkn3LGQSrFs
         2WGQ==
X-Gm-Message-State: AOJu0YwtJa0hhiOpknbQt4kmExq/rSinLZ/AwSDAhxSlKOWcHgUWfTix
	cXuXk3OdVKqjHII2lDtu4jW00Q2PfpmRAKhJTUxJ5pHqleVCnkhUNldStQiwSJWjMmwwxu8kuuG
	JHwBMcD6w5pPpO5qw7NP5I29wSZE8QU5TsyuiyxyIrfGfNFTZFy6y+lnpMJbXyHz9zZx0Dptl8D
	zh9DhRiEtVtFm9IYXSjOsfmSTMd3tmaofsR6RgdjrNaP9DLPnFAo5GoWY=
X-Google-Smtp-Source: AGHT+IHw+xM1HlMo/mm9/jXnKYIrDslMzGRFzsHZqSD7GyTGZbxTc8P6vl53dGA2leVXUp61huR9YQcKulFNDJfrGg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:ccb:b0:71e:591d:cb4f with
 SMTP id d2e1a72fcca58-724133eff5emr22007b3a.6.1731015706680; Thu, 07 Nov 2024
 13:41:46 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:36 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-5-jingzhangos@google.com>
Subject: [PATCH v4 4/5] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
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
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9ccf00731ad2..7f931e33a425 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1139,9 +1139,11 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
+	int dte_esz = vgic_its_get_abi(its)->dte_esz;
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1162,7 +1164,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * is an error, so we are done in any case.
 	 */
 	if (!valid)
-		return 0;
+		return vgic_its_write_entry_lock(its, gpa, 0, dte_esz);
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
-- 
2.47.0.277.g8800431eea-goog


