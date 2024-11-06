Return-Path: <kvm+bounces-30868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 880F29BE0FB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4281C2305D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302EA1D61A1;
	Wed,  6 Nov 2024 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwIxGLXj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035191D5CEE
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881848; cv=none; b=oFgAftwZmvm85ApF3bHbQCYAWIX9oO+tULMcDcWYS0fof/SHyLcAZQgCjClI9VYrh36tXtMbKugmMyrdiCtXAcBGUdIkcnYIjGYSz07dAWgcomerwNUZOH9ZdyZbca9eGhasNHpr2rnBAOUD2wVd3AqAl4Fk4X3YQpkzV3eBWeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881848; c=relaxed/simple;
	bh=tCG2vupC8Z4zzofbZHgX6YODMp9jrvmH6QRuS6LWQ1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EI2m8+T1Prb/32YswmKVRzdt03LA5z4w0QXm1h/dHKYBlQJmNQinNAu1W436H+WRoFYdaWkcaOHveBp9JCAuqG+/rdNQIByJGYalPlV5a2q/qfVzOZZ+CUPQVgvE1yxWsOL49jrGg5uqPU2IVFSh5W6MrYp/Rxx0vljlgOLtDck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwIxGLXj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-210d5ea3cf5so6322545ad.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 00:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881846; x=1731486646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9OqfUOMAqbpcWXjOPS3HeNW6CbTb26wA4+Tx2JMJgo=;
        b=qwIxGLXjrCOv5iDVzbKxFu8BTf+5z6rdMumCtd69GN4BWXadt74YyJFu4kAQX7gQYj
         suexwxSyLtxvZeienDiMhUBgsTXfBAxGk8FYjHIhjBgLE25cf0mGloLcHQbJYCvVIjTe
         WCXqEPsqTfeuj2GRGgLhY2P1NbwY56N1k7apPePrCKNGa/Hke/Jasrwl4KmPjirHafsm
         ruJQRVtfN9M8kL8PASN46ybR4Tx+xWqCnKMZeeKCp5zNmFtkH0vYf3gyHq+PJwJkgXVJ
         IZFoz05D9+O2ZLTlL+JOgRJN2sHgXSwaccEPv+C7UaQtMiaGEHBAhCz9Mf36XRkqgzU2
         a6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881846; x=1731486646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9OqfUOMAqbpcWXjOPS3HeNW6CbTb26wA4+Tx2JMJgo=;
        b=WPtw1VjVfTzVxZpXQ0szY4rn3wKx/r/dT5Wn8w7pr6tKKPg9TznRGf6lKQuwfulfG+
         /CHZswkqbg0NUOwarkU3oAHAVhY9BSr9nXfPJNxDzQqJGhap3I0inRxLMNKkC1Qs8rlp
         BmFCrZ0fWn2DQN7v2T3yAZ1AwAWFDR/T/GlerYVBtMioc24p7THELP3ua7pyP7vEDj0b
         xGP4w7vnfdz6Wg3rVJ9gRK9HeGHr6ZhePl/jxIky3uiSnEgPDeqGmNU02xkVOexbolje
         FwuQRdEv3GnEEM4D7tLn3ak3+W/z3zJna011SgQLP8DXTcpk7crLKEVweKY6CtBqAhQT
         S+gg==
X-Gm-Message-State: AOJu0YzARw+/+d5Ef3p2nK+cf14Zb38VOKYIPlpwRg5EFH5Tmze1UvHr
	hmfcI6gtUYGSqptWNyOd8tw/vtBuKmUX8k1skAFez2qgNNzVSOn60KO2tAYW3YEruetBEEzY5g4
	tQhIrib5OAhKISFrHfJ5AG/V1zmimxhK4sPnkucD45NVV2zFLfD8TlPDO+uUAalZ4VudRQdPgAO
	1ieYNb7SpBtkj4/UcWh9vliK7mKX07GZoC1o5Bvam21htToUbHI3n8QrA=
X-Google-Smtp-Source: AGHT+IEIX/6hVDGOmxY1iHcCV7jeryOMcpYeUgvJ4PGHYdhp40R/dK9bTBilzwLgwCsXlLEKi3MnqQQmu9vQlZaSIw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b686:b0:20b:8d7d:fe08 with
 SMTP id d9443c01a7336-2116c9c51demr90245ad.6.1730881844849; Wed, 06 Nov 2024
 00:30:44 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:34 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-4-jingzhangos@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
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

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7c57c7c6fbff..df8408ceae30 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -782,6 +782,10 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
+		u64 val = 0;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,6 +794,11 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
+
+		if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
+			return -EINVAL;
+
+		vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 		return 0;
 	}
 
-- 
2.47.0.277.g8800431eea-goog


