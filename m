Return-Path: <kvm+bounces-50474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3864AAE60C5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B5FC560776
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3504281356;
	Tue, 24 Jun 2025 09:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h9led1XW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF7D27F4D0
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756994; cv=none; b=oKwaqA/hF5DHR4ZKZndjblqpWHvXRs0d2S3Q/eAatRr7b++ZxSGvXclLByFsFeGBhBWCI5T8RDbZ0pq/QDXIup6o4APB8zBukkpyjQzrVyf/zQl2QJ6IveAh0LZzP9qdUeIk/orvWxnO6YFCd0j7DxzuF8Kh9MVijKKdO174siw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756994; c=relaxed/simple;
	bh=sNqOydOUdFsJOifTupwq4nSErJexqWdbFSAp0X/BHs8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pe/JhfO3bw4tAgBsaw9/ofHjMZGolche2zUsmN7BJfXbqsoNgCk3BLi7wy1wTMpA96eQaMv1cDDqrjntZOIogFy/ekfj6ASQZjH8u19D/WHwpCvndM+NpUpk5+zKjCPlvrCWbEjmwZ43QhQ3h/khYi1T2I0ajrrs3PWStleebNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h9led1XW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a50816cc58so93528f8f.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 02:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750756991; x=1751361791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uwYf71jp03MdxLBkkbihaPjia5WcEiabBGw3WgO3Tes=;
        b=h9led1XWTZfvwQ0HGJ1WTjxeK/BJXJWnRHGOckpcDyaEjH8dNLW2GZorHYpUGrH/zi
         z5bXxjhy8uVdYcYTxbKm3mvRLgueza4siPq16u+syIuf5Ck6cft+EULyr12ig+cJEnL8
         eCoVMLaD6ectFxpzu9H8tyyxznUA6W58dWhqz7lBk4Zo3PFZzIVDCtrGkWcPv9K40ukY
         z69tA0PM/ksXw3fCoL7AZeGvjD62OZXL4+MhO3lXKdrTf8hAwnrz4Wo3YKBEbVPDJLDn
         UFspZcgkrd9blPp3EbNNsRFmv0MKnEG/jpfLz/YF9iMmbgFIXBI3aCnJP8ey8vyJg+r0
         xZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756991; x=1751361791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwYf71jp03MdxLBkkbihaPjia5WcEiabBGw3WgO3Tes=;
        b=wEZ+GCSZLY8Hom6YR+xUjYB5jEzRIbXXYCBjD93845aMrAhHXV6c7ukdulv5i1AP9c
         2TPXwDvBzDiTj5gTjoMvK1uohkmHEgLiCS9NAYkCPdoni5zLqrxSwGXwVca2OqMs2RDP
         DlOiOyg9fy1YxlJRiw7GCFxoz/C+VhZycZW8OLD99mCAEiT3Lrg8Ef7s74+0TZp4Weez
         ojCSrk6/yIz5UoUnhOKZAN0MuARPQqHIJKNOhMTElbHhtJ9gAlo1akFeejf+kqEHbfAA
         ogJ2EmZ++E6uqWYwWJSlcgwCsiSgv8cwup3PvNldPRME6wgWsEJllLCZKM5aUmAiCnaX
         8wNw==
X-Forwarded-Encrypted: i=1; AJvYcCUduga7KXpJ1aMa5CBNZqVED+bXF4UPc3G9sBJwCoKztJcBwUFFDIiqf/iYcSJK45yb7AE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6r1bN4+UhmBbt1L2LOE4FviImJps+UHeAeqDN/Hw5OldjDwD+
	aKvlmQdykuXQcZfyLsaqt73T+vgZn8sTX7mQZxxiTVuGdcEt5nwUgr0O+29jpfRWE4R3z05SQXC
	//w==
X-Google-Smtp-Source: AGHT+IH24B8WCr6OqpYTzgXlBOmAaqywmufYf+A6d0IPqpHPXgTUr1i0hczj9/ID0CWcv/+olmz2NYEObg==
X-Received: from wmqd12.prod.google.com ([2002:a05:600c:34cc:b0:450:cb8f:62cc])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2004:b0:3a4:f50b:ca2
 with SMTP id ffacd0b85a97d-3a6d12fae98mr11445680f8f.8.1750756991731; Tue, 24
 Jun 2025 02:23:11 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:22:55 +0000
In-Reply-To: <20250624092256.1105524-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250624092256.1105524-1-keirf@google.com>
X-Mailer: git-send-email 2.50.0.rc2.761.g2dc52ea45b-goog
Message-ID: <20250624092256.1105524-4-keirf@google.com>
Subject: [PATCH 3/3] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

Device MMIO registration may happen quite frequently during VM boot,
and the SRCU synchronization each time has a measurable effect
on VM startup time. In our experiments it can account for around 25%
of a VM's startup time.

Replace the synchronization with a deferred free of the old kvm_io_bus
structure.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..28a63f1ad314 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -205,6 +205,7 @@ struct kvm_io_range {
 struct kvm_io_bus {
 	int dev_count;
 	int ioeventfd_count;
+	struct rcu_head rcu;
 	struct kvm_io_range range[];
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..b7d4da8ba0b2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5924,6 +5924,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
+static void __free_bus(struct rcu_head *rcu)
+{
+	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
+
+	kfree(bus);
+}
+
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
 {
@@ -5962,8 +5969,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
-	kfree(bus);
+	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
 
 	return 0;
 }
-- 
2.50.0.rc2.761.g2dc52ea45b-goog


