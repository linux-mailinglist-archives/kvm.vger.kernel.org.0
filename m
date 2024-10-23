Return-Path: <kvm+bounces-29506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 165949ACA85
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 442971C2478D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2168B1C9B65;
	Wed, 23 Oct 2024 12:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFZ1DUSv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3981C8306
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687538; cv=none; b=I2ZX0+FHsJtMcaf7DFXa6LNPNYLXVcaU+tkozmkfpt0GjWqxa0JaDGCfs5aWfStGwBmjpDmKjhX1p94vCefezOTBBaDOCmgCi6PzfZqgqwRDXwQeZXQUxNBIiMzL8rUcRU9HTuElob7Yuu6K2dl9Qyg06d92oqkGMF7LTpn9QoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687538; c=relaxed/simple;
	bh=WshHWyxxgI+uj1ZjdHww7jvwGM3j0rTV6TexHBQBTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dhvZzwtwF9JiabSyU0U254/MeaRLVJKHxHRHVkRI34sc0yZ9kiPLLjy0C6i7BJnJTf78PRBsp3d8t3MN5i1W0J/bAjQfGZ/vNgfXhU1wQ5sIG4SwAwf2BwVGMsanP6GcB7ga6xxcJ8s1q07yonBWdhWWa02rBCMHwmcH/FqKJ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFZ1DUSv; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71f5208217dso1166357b3a.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729687536; x=1730292336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I7pfA/j37MqLPTGcrn51IFuaXu8foQFPZ0zj68ZlFyU=;
        b=eFZ1DUSvGqmFUPODbk3+W7C+A9qRz00W2HhcSzkd9xRMnuUFDDTKtbd10S6STYd6OQ
         sz5qPF2kVRFngjxW1MNp74p8vZj/dIb8EabtFwjEjJKoCcsdO668KIQuLta8vdUc685j
         PDi7zBy6AEPv6ajGRo1U4nKAzMKF8SMeXWWBbuAy/GSw6LX+vKwdDsHYK+bF7fhpNoKY
         3YkYfuMCA1DKjxd6dA1xUna9cQlsaY7C1/1ledcp+D4Tq+Xf2IkILS0N4Y91T7tQWoUh
         nx+pY52embCH+APEQXWBBBvpZxL4VB9xh0zkzLpu6WLgfRbeEXZiPXZXYzytrta6qisj
         WoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687536; x=1730292336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I7pfA/j37MqLPTGcrn51IFuaXu8foQFPZ0zj68ZlFyU=;
        b=ZBmR/h+LnFgK+oN9nRaNGASYbRB187SZnziPnJtKhep8TnDOIUMl6dS28f2iUlnifw
         HcQkgPnOaiks5e5FrsMsS2aUujbdHpOqMr47rt3fjfVmxGgu/v8DolgaJicZGYQzVW3G
         Nx50CMxUFu4LT6z7hqqjTrMC8MdF5LMX2SuCdunvt7TrgeJf3Asqx/znlI6HczZyJhA8
         num3ZbDZGxaNgXVV8e9ipcrk/ZLXMRa4+cWAE/AzlTMG/H010oNSFsYEGiKhjW7aznz4
         k7h1Bpib3ZbjxYQbNt3drEnjI3jihD0SxAN1rhM5didecgoj2LoU/C2qLfAI3p3sM6mW
         C6EA==
X-Forwarded-Encrypted: i=1; AJvYcCXJILPlJAdjlhqSNf/vBAeYIlS5FRdRilKoYnfQvoThHWRnbrrYbOuXGwESN0d+ywd39IE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGd2zY/wHqie1vmW3/mwSNFvi28cBahQxAxB5n/NCpvcsb8JzR
	O4uSnO93qqW6jTj1b8iwo0Gn+vvXl9UjZKLHKwoSKYLxiBWI9ZRy
X-Google-Smtp-Source: AGHT+IEIGcgP1KsqWIoRP14JHPudbF0VqZkBL84XPvZ8D0xpTQoJwWMSXL+PNa53q7JDskXMB8AnFQ==
X-Received: by 2002:a05:6a00:98d:b0:720:2e44:8781 with SMTP id d2e1a72fcca58-72030a8a415mr3449656b3a.11.1729687535765;
        Wed, 23 Oct 2024 05:45:35 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13eb0c8sm6261639b3a.182.2024.10.23.05.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:35 -0700 (PDT)
From: Yong He <zhuangel570@gmail.com>
X-Google-Original-From: Yong He <alexyonghe@tencent.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: wanpengli@tencent.com,
	alexyonghe@tencent.com
Subject: [PATCH] KVM: x86: Try to enable irr_pending state with disabled APICv
Date: Wed, 23 Oct 2024 20:45:27 +0800
Message-ID: <20241023124527.1092810-1-alexyonghe@tencent.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yong He <alexyonghe@tencent.com>

Try to enable irr_pending when set APIC state, if there is
pending interrupt in IRR with disabled APICv.

In save/restore VM scenery with disabled APICv. Qemu/CloudHypervisor
always send signals to stop running vcpu threads, then save
entire VM state, including APIC state. There may be a pending
timer interrupt in the saved APIC IRR that is injected before
vcpu_run return. But when restoring the VM, since APICv is
disabled, irr_pending is disabled by default, so this may cause
the timer interrupt in the IRR to be suspended for a long time,
until the next interrupt comes.

Signed-off-by: Yong He <alexyonghe@tencent.com>
---
 arch/x86/kvm/lapic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..7373f649958b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3099,6 +3099,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 						apic_find_highest_irr(apic));
 		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
 	}
+
+	/* Search the IRR and enable irr_pending state with disabled APICv*/
+	if (!enable_apicv && apic_search_irr(apic) != -1)
+		apic->irr_pending = true;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
 		kvm_rtc_eoi_tracking_restore_one(vcpu);
-- 
2.43.5


