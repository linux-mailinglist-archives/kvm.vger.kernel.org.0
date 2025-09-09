Return-Path: <kvm+bounces-57091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B7C9B4A946
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65D5C1887C42
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674C5314B6B;
	Tue,  9 Sep 2025 10:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXTk7AZy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9E33148B6
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757412019; cv=none; b=qAo65lR9oiw+lMTaPLOpi3+xqLebiGN3i1EGWxCmTu8Uw1XaiyajRQNzAsy0DAeiX/UD7Mf/n9ochZ9Bt0ZGrfSPOpOwbzx6od7XebCrVbe9Q9iQb4Tp47wKGHuiBxZJ9NbPXDShRjmx39oneiMcMoXDZPAk9k+/1kxKRUBNChI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757412019; c=relaxed/simple;
	bh=C65JVKMfdNUvB842mIc5ZPEsMCIkTNLE2L0PO540/+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K84zetCEBkWxmghuOR+9lbzn9TpdawnyrSOUcqs4Mccfjj86uXodMspZRF7C6tkm9eSdH6/Z2yuzURktlbIjodElUHbYvhVsycgTlMDYebUG+W8pih1E0vnh9VhP16O/zxKyl1EFhIMHz7yjbAOVnFMngXyn0LUHaxH2YKIoicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXTk7AZy; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3e50783dda8so1808502f8f.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 03:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757412016; x=1758016816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2APtNHHyxo533cskw92lxdMihs7PuU7RV34cw5AXBI=;
        b=CXTk7AZyFh2F/Oau567Cj/+Jc6Wtk50lJsVP0MKO1MADRt8msngzQ5zeVA9g4OY8VB
         /ZIJkiVpZBa6r/IoEtj14iweB9CtUpW4U97bZLSxaX1LI3VHMjHnEZjbsvVzkkG3JDP1
         gR9bejYmga3twp2lLzuDT1fgVQWyEEebUEsrlcRaV3SxcQdPSuukCEtshK06uMZqw69r
         0VvlgOSpubCfWXPIKcr0xx4qcTOBccUucrbNv9XwTZbBYsWWMTBNJ/4NxQfaYpKW5qCx
         QZ0A0AViFLaLOmvtXMIfXMe0pGZguKvj/hM4lKWPVUjm2K6HLiEhnpv8zZ7b6NikuRxj
         7rZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412016; x=1758016816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2APtNHHyxo533cskw92lxdMihs7PuU7RV34cw5AXBI=;
        b=UuG8aWiX9/0RCD2tESFCEw/3FPMfgMHXAWZ6fv2sUypaBGiI+FnkyqI6mWoDcfPJNI
         +dAyvk3XAhaJREXA2ohj12fgucfhgX88bEjmeDOCDiCWCR2WLJrFFS7+5U4mVczMODln
         UaAV3rcc5Mmal87MEcAmkP3bJnPrZy054VJyxvZk2tHuTTIDfynMu9xJmm4uZL550STq
         vvoHrn3zMZ27CEA9JByHD5W9kaE31CR1WFUuAOHkSqmntMA04eKZ6SgwHxlt68EoIDjV
         FGB4d3ORvBXwbXy9QK65is7STDeDKi5m57WYJ4auz4dgkCKgFsSx9C9xgSKyMdozz88B
         KPFw==
X-Forwarded-Encrypted: i=1; AJvYcCWXM/Rpviopab+HwWwNvevnsnqO0r/V1AqZfOEDW9HABm2DW/sbqEQIF5QvrKnJ8AQrV5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUxM/rr/UBh7BL7sMHv8IycrTHUM4N1j1WkXs3DWDv9njWEIAQ
	BCNjaY75cFPtAKEeFWOzk0N78D3w5e1ttyrCk/x0Qzb8DoaSlzTdzKUxT+GG414pm+957fxu5DH
	S1A==
X-Google-Smtp-Source: AGHT+IEaeuL7yLD0zJ6dVDDu1CnL/lrOdGiAdKs9KWet1I8AXuefzYo8TDKeImXKCQUtFMCZRXRSbCKA3g==
X-Received: from wmbbi7.prod.google.com ([2002:a05:600c:3d87:b0:45b:885a:402d])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d13:0:b0:3e7:481d:7a6b
 with SMTP id ffacd0b85a97d-3e7481d7f17mr6380076f8f.10.1757412015873; Tue, 09
 Sep 2025 03:00:15 -0700 (PDT)
Date: Tue,  9 Sep 2025 10:00:05 +0000
In-Reply-To: <20250909100007.3136249-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909100007.3136249-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909100007.3136249-3-keirf@google.com>
Subject: [PATCH v4 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation to remove synchronize_srcu() from MMIO registration,
remove the distributor's dependency on this implicit barrier by
direct acquire-release synchronization on the flag write and its
lock-free check.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 3f207b5f80a5..ccccb5c04ac1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -562,7 +562,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	gpa_t dist_base;
 	int ret = 0;
 
-	if (likely(dist->ready))
+	if (likely(smp_load_acquire(&dist->ready)))
 		return 0;
 
 	mutex_lock(&kvm->slots_lock);
@@ -593,14 +593,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		goto out_slots;
 	}
 
-	/*
-	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
-	 * registration before returning through synchronize_srcu(), which also
-	 * implies a full memory barrier. As such, marking the distributor as
-	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
-	 * a completely configured distributor.
-	 */
-	dist->ready = true;
+	smp_store_release(&dist->ready, true);
 	goto out_slots;
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.51.0.384.g4c02a37b29-goog


