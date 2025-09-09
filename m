Return-Path: <kvm+bounces-57089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 721C2B4A92E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AE7B362880
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C273148BA;
	Tue,  9 Sep 2025 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="24FroGgq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3C313E08
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757412016; cv=none; b=B5DWqkP8iZRTZInGbzZ10wgmMOvT06xTRvRTseZlEQKTCxdbRTHfxraL2kKhMB5d6g7th30O8vhVTigaOILXUFRfiZa3N6VMSHAlUL6ll9HWENL8sDeZnwR+7v2Q57cAcVDestno50vh/6WWPgdspjIxRupbeVf+gmbfNdFcrnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757412016; c=relaxed/simple;
	bh=6c+zGjj9MhN1ayyQiF4cUe7JTj8htqtbFqism2pdC1U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UOlRpPrUK8xVl5yUqLRiEgbq8kH8yMQ03MTWiOP6AR5zPIg8M/HIQRjzBFa0eMXgBxPxvg8gHFgZ/FbkP+Zsx/W7ZIMBHpWV/8ZT83Q7WoMt0Ouskt9KHth5OM30gKhAxegFiPQ69D2KEr0unicAlcU0rg4QTy8QbMC9wFxA8CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=24FroGgq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso32073735e9.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 03:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757412013; x=1758016813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AhNRxbrdg6ISPZIm1nvZ8swSV1Z5SsxYmrn66VE+GBs=;
        b=24FroGgqMGCumH+Gxg81MFP8nD3Sv81LXe32+SNXKQ3+nR0w9DbufzZv8yCn7H5gWe
         1upw/IZMZfQYRC0gEHuOec8W5zKTDT6rpLZsqM2KK9bWkfquNr3J1xcAxlouuKfGVWao
         KIzUT3hBLkOFq4P1KW8t5+bVd10lGRo5WGiNkcZEs1CFPE3kPa4dxhhk+GXCx10Lqcxl
         Mfz3mASddryw/NpI26WR5spuHDKD+Avc+Y47aPA9rrIoa7VEP//v/sNus2yDtappKefi
         QOjLdigIPeSRTN567L8DP+O5hDSKxHnhDlGqxJjyIJYOEaLcFNwOFiiOi80Hjanj3C/a
         n2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412013; x=1758016813;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AhNRxbrdg6ISPZIm1nvZ8swSV1Z5SsxYmrn66VE+GBs=;
        b=tNghCsC5UYqM9E5fMiITmWX+wAzrEoc+87w/4JSdLRt77AOxza55A+n9xNERrKXUx3
         lq+/u8mAQ6yIBc2e9q3hWDQQicKe3QoR6qa50O/GRoFWZ7tag/OwhoHRUf96RnVvT2l6
         pVCechKv73FDI5VPgpFRVRudKsm+Vhpo4aPxguZpo/8IrKB6FE5WUrXIlDckQ8qs0M5u
         9ii47uXy23fUOcYBbCUXpf/fa/X/bgFrRNgfrUrRwX40NjM/sMLbfTDK+pog14E/RxWl
         /OWaekZyONxOxgNP+p0vhSN1tfEHcyl1unoFvFOqA6Qtb3V14GpRZW0TBbVLl+0YirjU
         Ru6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVABMcBXJAifuSXwJ/MCF7hMgCCZhwgvtsNZJcw2nFPTsrhcehI0XYV+31Mc8YwwN6YZXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHULKLGqQiV1pm0DCaoYxmnRMFuSWE3pV/DFqlU3q/RD97l89Q
	5H4SupbcHfnSO1f334ERmJs4jrBtBjkdbuMPT9g1SDQXZIl+Hb3QDqNutjt34pcWIlOIQ2eJroB
	Kig==
X-Google-Smtp-Source: AGHT+IHzO6iJLK1mxVbt9ybO2bWPuop/A7UNojIEaCpW+tXljzJMk3ZXSHK8g7FlH1Jeu7qwJB64pyZuYg==
X-Received: from wmbfa7.prod.google.com ([2002:a05:600c:5187:b0:45b:89e7:5038])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ecd:b0:45d:d5fb:1858
 with SMTP id 5b1f17b1804b1-45dddee8e80mr91499155e9.21.1757412013569; Tue, 09
 Sep 2025 03:00:13 -0700 (PDT)
Date: Tue,  9 Sep 2025 10:00:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909100007.3136249-1-keirf@google.com>
Subject: [PATCH v4 0/4] KVM: Speed up MMIO registrations
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

This is version 4 of the patches I previously posted here:

 https://lore.kernel.org/all/20250819090853.3988626-1-keirf@google.com/

Changes since v3:

 * Rebased to v6.17-rc5
 * Added Tested-by tag to patch 4
 * Fixed reproducible syzkaller splat
 * Tweaked comments to Sean's specification

Keir Fraser (4):
  KVM: arm64: vgic-init: Remove vgic_ready() macro
  KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
  KVM: Implement barriers before accessing kvm->buses[] on SRCU read
    paths
  KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()

 arch/arm64/kvm/vgic/vgic-init.c | 14 +++--------
 arch/x86/kvm/vmx/vmx.c          |  7 ++++++
 include/kvm/arm_vgic.h          |  1 -
 include/linux/kvm_host.h        | 11 ++++++---
 virt/kvm/kvm_main.c             | 43 +++++++++++++++++++++++++++------
 5 files changed, 53 insertions(+), 23 deletions(-)

-- 
2.51.0.384.g4c02a37b29-goog


