Return-Path: <kvm+bounces-50473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45320AE60C4
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B2101925B3D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29D227FB1B;
	Tue, 24 Jun 2025 09:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gThEaZUq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F527C179
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756992; cv=none; b=t1x6cMOEAabQ3uc0cK8pjlbWDHzGJPaB4lZo26I5BRhe7bzFJ+mzCE+awAd/kcUF1IVhmlk+8D/FqLs3dDQKgyfL1LywZuF5nDHhKin/MBxXVIKQzwf8JOTdqy6681pXnecSSeN9+dDws/Im3PzH8q9sVpxh/QJmuGvSkNxP/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756992; c=relaxed/simple;
	bh=583wsMDBMJrMhyGcOptLAkwUC1sLZ7/fwnjcJ8OxnvE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AYIngnjCnVI20zc6R81ZWIbrPEncAUW/fODWd/si+Zyc1FBQrOqhluksHWq5+ynfo9zH1YAsrb8kTifFpZ14Dyn7Mugid3Xm3V5Sp42dJ3QQm4dZFRWsDne7hxb2p0kOGVdBgS0KcPgf63MgttXlewmSbgz5cPmUOBZapl473C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gThEaZUq; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso3200908f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 02:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750756989; x=1751361789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UC6vq5jBb1v1bd72k3pkcapbf6E4MjOjFHfh0Y/a140=;
        b=gThEaZUqaulHp8CvIs77Pkb5zR6fwiXv9ppwfm6bKgZh/zUVeL/JETqV9pBh3qt7Ei
         P+PxpqoWipRNQUezVszI/pd9NljmXvJk6AtG1CMXVkKZQQqfOYtjPMMbmjw8dCC+VS1q
         sbV4AB/DkW4uI6umuLD3cTZX/PtNMapWfSbUnA1rD83sg7oK3gpJPPdQIxUdUMLyOwGx
         v5roOXZMGgpLY3ES6TySj8sJy0xswP9UiFTZlMS880O4jF8dKjGnlORHbboAl6xRCaQC
         8Jb38Kb/qR8dC0o6Pm98yBt5jZKT+lhpsujXnJuU/CVStWAJsMC5/FGJ8gyeRyvSWqtL
         o9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756989; x=1751361789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UC6vq5jBb1v1bd72k3pkcapbf6E4MjOjFHfh0Y/a140=;
        b=kjfQViAtNEJwF3SstQxh93SyWjTI68A/HnVgKUZWTztghIEz713P8caAEsilpGyVtF
         TNTaTNu56ECb0t4cwUVfF4kN7GmtPptWLzrF/wI2Gl8d9uE19xTOMwxfldAbtWGm+r3a
         erf2imvRuO6qb2UaGAxXyj8JOGd/kcpo8BgzwjwITqomMWt3smCACwuJGyBaDvS0RQjy
         rFG+6jJjo+oHIxztZFqHAmdllPJgjXooieckGuUOZYKjUm+sw2ab1PAqY4bA8p78r5Ky
         jL3MCgopM8ezn1tb9/c4slRL7Hlh+f5azBoohdS4TPDuIrbKJhDMEwvhlPSDI42rZH5p
         IhxA==
X-Forwarded-Encrypted: i=1; AJvYcCVSpWpLQvYzAH28WSxuG250oYfaLhxsxM31SmFj4MSk23pPOTx2CbSyVG/uICYNTj116II=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW7Y9tGA95WzYlBNx69rjCxZEh/0HRcuk9JfSGuzTybJhIQOKk
	kEBgQVLGMUMKN41DMuwa95Icd6MFkn9h2XEHWi3WA7Qt3INwv/uhXGkWS2VAwoI3mHfT+l+c1nA
	JcQ==
X-Google-Smtp-Source: AGHT+IEr7r98giCBtL0yinhHNgdvxQNlG3HKjSDL95dDG4D8sHcl523PslIHgko1ki0lJc9tb1d51y0i9A==
X-Received: from wmbdt3.prod.google.com ([2002:a05:600c:6303:b0:451:deba:e06f])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2582:b0:3a4:dc42:a0ac
 with SMTP id ffacd0b85a97d-3a6d1324294mr13113188f8f.49.1750756989691; Tue, 24
 Jun 2025 02:23:09 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:22:54 +0000
In-Reply-To: <20250624092256.1105524-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250624092256.1105524-1-keirf@google.com>
X-Mailer: git-send-email 2.50.0.rc2.761.g2dc52ea45b-goog
Message-ID: <20250624092256.1105524-3-keirf@google.com>
Subject: [PATCH 2/3] KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Keir Fraser <keirf@google.com>
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
index 502b65049703..bc83672e461b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	gpa_t dist_base;
 	int ret = 0;
 
-	if (likely(dist->ready))
+	if (likely(smp_load_acquire(&dist->ready)))
 		return 0;
 
 	mutex_lock(&kvm->slots_lock);
@@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
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
2.50.0.rc2.761.g2dc52ea45b-goog


