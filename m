Return-Path: <kvm+bounces-54964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 371C4B2BCA4
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C8FF5E4121
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E7C31B13C;
	Tue, 19 Aug 2025 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbYXET9f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03331A055
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594542; cv=none; b=Zd68lWnZ+Cf7cV/v5TDfX3mfq+aJs0ZDd2nouYLI0DUB9848547arnDglWmUtcOcy6YMxtoyJppRMfa55+ij2RxozPvZFFykXVXCghxqrBTCFE3QsVdIYYq4o+BAz2ve70AzzhZfo/tgREePkVjZnnsQKjsYEOz+qs6Qz64Iokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594542; c=relaxed/simple;
	bh=Lj8R+QAbvGD/j2/IfIqy36p+Mv51YViuIDGXC2HRQXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KBfGdJFicWVS4D/FjmtaP4Skf65RToB0Pz1sXb70W0zlr7zXEnuPPuj9MJFP3sSNZnAtZtHD080oiTEPV6kx31E3Gm2pptmp/+EAtSz1BDvCgnpnjGvaZKrg/4rm/55kcI/vuWfu8vgKWVaX7pBXDgfk47c7YzDJdRbzrv+UTQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbYXET9f; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso30269315e9.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594539; x=1756199339; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7GQRkJjLj0j3dNMqeMnq8zCLevsX26SkayOg/7wVlQ=;
        b=IbYXET9fBZ6ANe2D6j+vU9pkGZuz09OzoA2CQAinHdUIOe6osNlpxMFXwfXJS6XEc6
         3T6PHm7DC9KaV6wLALEpASqZjAllcog87rGyStN6QhBnr0E13nDe4xwWaehohUlGlPZG
         7WxAzHBvgAkJdykdEsjtKmYe75cndKm1WPrSYI8nU4+P5NWfaaPBVnkpoNZruTQY8xlq
         mYOXHxha078tz0QihctSBf3zpkQR+b2U+DZwbFu3dTdSBIRzLhPZYcz/c73UoM9hb/tE
         U67ciOSJ+ZMxpZ/vW5CjcBCzdXVFUuDMyefzY3BkoqThbOn05y2nXLs6Z9DZTSr2mAYR
         mpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594539; x=1756199339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7GQRkJjLj0j3dNMqeMnq8zCLevsX26SkayOg/7wVlQ=;
        b=FMSMS+iC6z1UU2OTtM2rXKCXhX8OO/ERvpy4T9dHB9u1pIQMjnIlvwDE74LGgJC3cc
         US9S2X9LYRGRMKw4rrFsMXcmS1/Rvpr6IOdm9/SHtyHVHdfW/yHTZY2SIaKbmromY0KS
         lFYtQeaYrAsALR/wVqWhkiE+hLncqf3DJxT20jIKApDHGBDAdVo+noj0v2U7XuAUv69t
         JwJdt50G23YArFlbGIRbycJrcwlqwL3t8hbPAjUbgwYvk6tKYEl7VJ0ZPtS4nET49nR9
         BsGuzV6qTcNIGRpZJRckJ03Gyyja/czJSSzc1emN/cqsM0dC0uihrLAnT5aoLE7yubpN
         T40w==
X-Forwarded-Encrypted: i=1; AJvYcCXwZFZTPaL99sE6+UnbKrotM3OAW/R0Y4kks2QMj+OeIKX/rCTuwTK0ZCHWKm2ZiOGuQtg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/CFHiUT/SWUzcEeIRDauG8L/vUDizbuszkWuBqSL5vbcgD3WP
	NCplCO9yMwqDjkQg8JvKNjf1PyQrNksFR5h3hObdiLo3WZRJNeIaS90RnfZj9hjO81l+c7CNzLj
	4qQ==
X-Google-Smtp-Source: AGHT+IEl+5DEbXQSzekfCwJnh9tAA1jzlM78/0IsLI3MJWSPRp03wLItZPI7GL4eVRBnoTBswnyDHI1oMA==
X-Received: from wmbeq12.prod.google.com ([2002:a05:600c:848c:b0:459:db29:1efa])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f12:b0:459:e3a1:a0c4
 with SMTP id 5b1f17b1804b1-45b46190a32mr1402635e9.30.1755594539541; Tue, 19
 Aug 2025 02:08:59 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:08:51 +0000
In-Reply-To: <20250819090853.3988626-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250819090853.3988626-3-keirf@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: vgic: Explicitly implement
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
2.51.0.rc1.193.gad69d77794-goog


