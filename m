Return-Path: <kvm+bounces-31189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C11B9C1133
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43DC31F24BCE
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E26218933;
	Thu,  7 Nov 2024 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="boqyfgfd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068FD21892D
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015713; cv=none; b=HggwMkDRB1RMStCKoD1DYOvfD2FBCyMQMB0jfxHhFKlMAT+iaC7FjXDeAl9nwKDytqsHi66shmDpiqNwl75pIuxKPhR7PJbl/B6+gWZdvizM6FGLjIHd+X7YMGQ53wfKFs0KyFLbrhvluU4IaJJh6kOthCAHATEdbNiTU5Ckvz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015713; c=relaxed/simple;
	bh=jOOlJLiPiEa5ClNb9LHsnzMeOqeBRTZ/5JpT4ENcDZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hk630Qe7DYmrdLK/cYthWJu+rh5Y4GjSqU329oP/hKyfDBrWxlVhGWZFNzRO+pJZZqNPM1wr/AgNv0ugRk29HHrO5hTt3ncJldgGxPYfAaD4oz0UmIX+TPBR0nEmZGevUom99IJCANxr0dsce3mcRmXUGTfL/5Dx1F9FVtlWd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=boqyfgfd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e5bd595374so1244600a91.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015711; x=1731620511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fS4eYbDYlT6ZjxYCs7YFPGo/Zn24dUoWIUuzZbUwo90=;
        b=boqyfgfdDxKIYPEBHjU2yFGegJT0vQwvkEFUaZyI5ST/GJyU82q0ILdF9u4zevaCkJ
         s0LnHdKGCxSjqF79JDkv374opeB+TUFZmAYXHf/r1klGt2U3AlNY80GTAMUk3F3bzK4M
         DAXPGU1GsnOpn4GeoqV/A1CraDorYHYTUNJNNpy75dqdP43EiHrc195SSh8mUKLxhEDp
         xalKgxWD/CM8mhCzriJI1WGFOQWKUNFDH60ullmZv6cfol+3Fh8py9CelG8031+S1xRU
         yYKpbD8KpImeUqCCBEV9jpkwzdnDgrucK/HjBYF0/ZbAztSvvUTMyvdXbCclHs06fBwH
         yKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015711; x=1731620511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fS4eYbDYlT6ZjxYCs7YFPGo/Zn24dUoWIUuzZbUwo90=;
        b=RuQhL4XGhkL9RZuCcyiGAV2yWdH3/ooeI+/pvAXOvOQZ+KGnd4CdJU2ZOgFkMb87nt
         J/rldrc/tKjzkdLGc7k7S1YJM+Uz1Y1F23/UuYTveLmJI4RKIcsbsOXcuuxWUe0b3XFf
         /aeyqwqPtE2ZKdhP9zzrkkVuUaX214PQj3NC37/1n6gYIIBUXCjJXx0nclkLPHSRw6Aw
         wGfWo2geuBFoiPP3DpaKwmiHi9ndevHq9zCaV2eQ+s1E/LRQECy4jvleHQtViCCrxN4H
         B5++2uDtOAppixJ74CimXDJ+pF68ygKFNbFxH3XN3oEkcXNgP8NXN/a1RXEREdCfdAU4
         r55Q==
X-Gm-Message-State: AOJu0YyD9ZGqlLYHH7wBEOv5BbhIVoncz2H+p6pPhkGoqvfKtX6X2nz8
	l1/YprpwlCmI/kcNI6GfPMMj1kF1K5fIIoT+q0e8M5iYvp28QKJdDZPjOcjueb0Ld1kx9dTKknH
	MeTnRN8B4fsjC9IDKL+NGgQMqg1BPl3MgYjA/JbBsvNXbNR+W8K9FgIUYD7vFimxf9zHUORPhPO
	SizuAomZeDWVVanzT824Z3Z5ndq2UtnKUfWHZaCasxTXSq1gGiVG0HW7Q=
X-Google-Smtp-Source: AGHT+IHZvcyra0ifDWGBgFJCy/j+FkQf7fYD/6K0phYB7aIm7PHY7A4aDCP/RnuVnWME187Wgbt6jqNTLj0tZimfxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:b018:b0:2e2:b41b:8549 with
 SMTP id 98e67ed59e1d1-2e9b20ab802mr988a91.4.1731015708623; Thu, 07 Nov 2024
 13:41:48 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:37 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-6-jingzhangos@google.com>
Subject: [PATCH v4 5/5] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
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

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7f931e33a425..5d5104af8768 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -782,6 +782,9 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,7 +793,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
-		return 0;
+
+		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;
-- 
2.47.0.277.g8800431eea-goog


