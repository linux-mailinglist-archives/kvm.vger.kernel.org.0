Return-Path: <kvm+bounces-52618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5653B0744B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CD447B2202
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366522F3C35;
	Wed, 16 Jul 2025 11:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4NdAw62a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F5B28CF40
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664066; cv=none; b=AjAZBq96I0K/Kl1cx/Ips3mhbZeEhwlGTOryLk8Q/nmSqtQHuPxwJUiVyDW5NVgR1BeYe+l3g771W2Nz/8cOSPqrQCyA4bhE94faLh1sTV6rzvw5744ytqvITz1MLRziUYWJ3WJfMNxm8SL5pXivsxjcPm7tyDd9v/Q1UsEQC2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664066; c=relaxed/simple;
	bh=10ttIjeYifGJfahCuKUTezWJuXS+ZrMIpJRyy5waZzc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LpKSKf0TIYL1JEapqoQdiFpx6SoYheYnpuFx0O3we47F9IQ0bi4BFndcx1vBEYAB/gTRKfiLa4nbtKzy7vuMdRZoO+GryPlPC9OXizdmenerxKqa+kt4cvxs2E+mhf0gAoQyI/vVrAMlaxRF9hereZT/GMa7Pr5PulBdUAcchOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4NdAw62a; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-606b62ce2d4so6826062a12.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752664063; x=1753268863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TyfcqbggFsVMkhQ3/vS33VSK/7m2OBGtht93BA9q1Nc=;
        b=4NdAw62atsgTKViy+ScQmBGvpjPhhHpsBVUZ8FMqkU1zqvZdy+ebzCTQ7lSusoRyOx
         mbbDtipJA3XlawTfFALk2n3hM+vfaM27ZXavCD/pSQbLDqZnzVNZHBVy8RXij6B/69D9
         xzQ2g+eAGUQI+ypQb6hPJ4lzv4SiSbFARHFihBvCYCe+NrdLHhCLmxzFTDP/P6NmFzKW
         2H2GPLkdXLpsr8CTFAiIlm7XenSHPajZV7rTp8GRYYy/gvmlIM/OMVizM2eyJzcN8IcV
         k+mX3HxHRbLZOj+jHHyMjLpdv/Cpb9l91bkyX/mt2GRr1W6PkN2U37E2UyMDAL/zcSn9
         AdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752664063; x=1753268863;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TyfcqbggFsVMkhQ3/vS33VSK/7m2OBGtht93BA9q1Nc=;
        b=UWzfr0YwmoCMoeH3Avd/2g9UMgJLwY7zn7lMVDExe2WoM8ePyxhNI4uFY3NUQgGlnn
         thdpAfjl9mNUMOQ8vamSkRG/kR3WVMnruhzN9LxpfkDxrL/HCHvyc9ZIaXFTmScLz3wN
         LIb4zLPUxX7dy4S0J/LTkhRH0vH2AxYZmaeXJSwJ2OZ8X6I0OYD9BRlhoDDdQQ1vghGz
         kT+2onHiEcPc6lYD39YUbq1PJoaS+Q35H6UWibvT6kUT0UTPCo8kigmFaPTkXZK1Zden
         w2gS9v5/nENxCymLUmw0uZkqsdIvzT7BlcSgSU0zGKjxFyq57i7Mrx3vschjFJoQeHd4
         PXZA==
X-Forwarded-Encrypted: i=1; AJvYcCWWrIX+uID+aKEhmtgrOH5GwKibaVULeICVGIUb230sfOBp/7Y1hgPFfCSeZYXbhdrpl38=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvYgOSN/xA1n+XTjIdW2kKXnQpZsWfT78Q+csnkk6nWmQEC059
	PwM8KZmBSMFYKng26A0r79lJPRgdTXK1j4iI9qX3ixxPy703jKBG6vRMnWW4SMXfQOAwRlRNlI/
	P3w==
X-Google-Smtp-Source: AGHT+IGeYAejknlz7cV/1SlSOzPhNdhatcheR1F0bGDRmruI6xm7M0czw9xzhGPfq4CQ3wRKJ1YDvke/1g==
X-Received: from ejae12.prod.google.com ([2002:a17:906:44c:b0:ad8:9944:a34])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3f95:b0:ae3:5da3:1a23
 with SMTP id a640c23a62f3a-ae9c99c0d2bmr228038766b.21.1752664062975; Wed, 16
 Jul 2025 04:07:42 -0700 (PDT)
Date: Wed, 16 Jul 2025 11:07:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250716110737.2513665-1-keirf@google.com>
Subject: [PATCH v2 0/4] KVM: Speed up MMIO registrations
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

This is version 2 of the patches I previously posted here:

 https://lore.kernel.org/all/20250624092256.1105524-1-keirf@google.com/

Changes since v1:

 * Memory barriers introduced (or implied and documented) on the
   kvm->buses[] SRCU read paths

 * Disallow kvm_get_bus() from SRCU readers

 * Rebased to v6.16-rc6

Thanks to Sean for the review feedback and patch suggestions!

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
2.50.0.727.gbf7dc18ff4-goog


