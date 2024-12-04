Return-Path: <kvm+bounces-33068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0959E444A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7962B16940C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC0D1F540A;
	Wed,  4 Dec 2024 19:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HynfjS9g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8DB1C3C14
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339660; cv=none; b=luxgb/Tj5KlxjvG8os5wBTd+h5B0v1CAxKiDvuhHkefUACMXXwf9JZewjFHhdK/Ijp0bVh3d6FFg7B/Wos/bUo/44J2CRQjn48SDVNqLpMHfVRPR4dI6YsaC+THHKWMAMRivw0su3dFmSiByfZP8tpOKOHpiMgGtHxhh9OCRTZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339660; c=relaxed/simple;
	bh=gwG4wHoxIC9ohviESrC4i1SBquoILkHgmJR3YvyQL40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=agOquxNGbS6aMDwq7yCj9lwdyMR7RqCh116k0D8/ex3p4AnMWk9vKFq7kXl8rZnIRRUvaSDwgEiehv6a/JokKGt6sUDrxspJXOLmEcDZCzXCGAZR+duIExZjsezetRmCjZdvXFcPfEfOYj4Fx7cuLYWIf0Lf17CRZfc2pOvFuFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HynfjS9g; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-85bd8a1a59cso17685241.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339658; x=1733944458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rnZJyT6N3r8vTjoa4UcLa/XGdQ+PqihxUkrotorxiRo=;
        b=HynfjS9gexIPiXe0xn8pvL/i2eC2Ggh91wY+OOggUnrAwLxAjOIBijfWJSvdnLKJOA
         IDIQ0UpU4YJKosuerBA3hZPGSkUY5DOfLZTe2xv9Oma6DL0ILGK14eogVDe1tH3R4aHu
         WDaB3GyTR/CkclNtL/FiD1aMx7xwLuW5CoixkQWJxTbzFnoN6bD7bo6atK6prLlAIy+d
         eFA8kbCN1gEQPGR7ICo/vdLJu5zic2VZrqAV6SAZds5uEkZeHz3z2tWVEiFIw42C+uYf
         sUP+a1/E0aH/MMPZYF78OdT5A65OzEfKhfDNGfcuCFyjQhjpidTPdTds+toCaSmVnS+l
         z0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339658; x=1733944458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rnZJyT6N3r8vTjoa4UcLa/XGdQ+PqihxUkrotorxiRo=;
        b=gLXgHXxM3oOvoecvLw5E/YXXRXUlEFT4m2mxTI1bb2RbkH1+F5r100mXUC6xcHoBb2
         F92ocS+8WbmpCaI4mUTnM4i227VaSQfWLA1V/vtbNBB7S2a2lFDN0SP43G2mXvOaUsla
         XJJ4fsKitW+1JD7blSsz6bbykW1VVYPg4fAOD9zt3PSo+o+T6kr+5cf0ULHwkPXaobUm
         z1A0A6zfL2HzhpbELb05tpCdHeu9mJB0ArXRuz57DfHlfI5KB5P80gkpKf3v1Jz2LL7S
         Kx3Q91rThm2V6bDH1Ye9KXQczN9BBKQko84H+wzaVw9EfLZIGGlX9mF8PbpI1yxqeGVH
         G1tg==
X-Forwarded-Encrypted: i=1; AJvYcCVYyz+mbIuE4axRl1SvLDG/7tq9tQaX0yFt5SaZ5vP/0HY1tKfc1yUy2RoGYvVg8399Yf8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9X5cK+jwrb4P4DNM7uSiEBx8GaMyUdzHrba34urMoXl4OsN5y
	7c1pYIyw3O6nIJ29dtgo3qXzHQvKGxcjk2WyIzIIWpkIosq12lJ8M2EXLJTSc7qmpM3JklKoIHg
	cELgNhgiywI82KJGnkw==
X-Google-Smtp-Source: AGHT+IHeflh53wCdtG/eOTj3NVvzDZ1TR16bpwDBvuZyMyTF5KFF0ZrmPFZ5n9dphqqxj6PK08wZjYTOW77Q8bPv
X-Received: from vkbfc18.prod.google.com ([2002:a05:6122:4b12:b0:50d:6d20:c212])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:8d0:b0:50d:4cb8:5aef with SMTP id 71dfb90a1353d-515bf2ff82amr10640137e0c.6.1733339657905;
 Wed, 04 Dec 2024 11:14:17 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:38 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-4-jthoughton@google.com>
Subject: [PATCH v1 03/13] KVM: Allow late setting of KVM_MEM_USERFAULT on
 guest_memfd memslot
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Currently guest_memfd memslots can only be deleted. Slightly change the
logic to allow KVM_MR_FLAGS_ONLY changes when the only flag being
changed is KVM_MEM_USERFAULT.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 23fa3e911c4e..fa851704db94 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2009,9 +2009,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
@@ -2025,6 +2022,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return 0;
 	}
 
+	/*
+	 * Except for being able to set KVM_MEM_USERFAULT, private memslots are
+	 * immutable, they can only be deleted.
+	 */
+	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
+	    !(change == KVM_MR_CREATE ||
+	      (change == KVM_MR_FLAGS_ONLY &&
+	       (mem->flags ^ old->flags) == KVM_MEM_USERFAULT)))
+		return -EINVAL;
+
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
 	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
@@ -2040,7 +2047,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
-- 
2.47.0.338.g60cca15819-goog


