Return-Path: <kvm+bounces-21379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D3392DCDC
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35D9128351C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D184315A863;
	Wed, 10 Jul 2024 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEvDKZC0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B5C158A35
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654965; cv=none; b=WuunuAYyGwP6jsdJdvpffyvpmxTeO6m1oP4NrypU2IJI3pRViTkbiS8dd2/UF8QaGNkmgXNFT9Srf9knatkMIxstY4cZHjFjy4Wjr0L3n7+ESi+e0i7qkQjB6QOpk0PEPdLPuOYifSAouNkcq2p/9X/2qj6QwAuw8J8pmxasgTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654965; c=relaxed/simple;
	bh=9qd4I5Nt4ZpEq1/DgTQG1WlNzpdV6maR7Ymqr0dBes4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qx7+S6qPTbeVPOUpsX0I5lfNuAoaEwyKoZYiG7hcB1LRLTxa4l4heSrLikXJYSXk6BzMsSyKmk6hsKCA+8V3zC72cZ4XJPelY/UPiBH+wnymB4YbEckCOn7LRoblcwbM8VY+e3nom5TMhaG0iI4vUWl56ruyWLqkrzlSRGppUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEvDKZC0; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e032d4cf26aso518572276.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654963; x=1721259763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Rmzp/FnvTnt3i+tgLuvGyYDZdc9771iECvmROSKp8=;
        b=eEvDKZC0qcAwFW44NHp9Ty3319OenqXh6hjnUhLIDiyiwOJH8lphTbC+E1LPBwmDom
         46LBH4m3KC8SMAX1CKZOsUWQiJb0q8OJWZJ1Jk6Ez+RJW5DeoVTY1M2EtUOQZ6x/871M
         9/mTORt4Z78JiWwyLY3T8LWQW1UMFKLfSP9iKUD4JLiEeOBJbB+C42y4s5CPhQQSUfck
         ZzdpNELz7exs9jZ/y4Gr+B8R3V6mWIzPXgoN5eIgH2KEHCPsfUcZiEy+aWLE8EebuCu2
         629ewLBI/nvpxdjEkS7UATUHmt8Yh6K1/qqbPGpSZ+3tvKn+z0oBYn11CZtUbCfk/eE6
         /lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654963; x=1721259763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Rmzp/FnvTnt3i+tgLuvGyYDZdc9771iECvmROSKp8=;
        b=fuFqxODsux8uzvvgoPmfs8fOq0W+0Vy9bvIYu76Y5I0Jkn7OP/dtUhJwqaiif8IDcQ
         iThaq5VX/zvrQIul4wMQhZ/mIEKT/RDOvdLVtGxAUFYqJidWBTXUr+6bWUIBONC2k0bv
         P8Ks6vbrfq19YxQvYC4Q7MpUWI+nzSj9A4KCTGQvkzMrys5QvH2RG9uEvUFFacE/5O4B
         v2CzIz7lHU4Xhh1C9lOKHO2YZU7822lvxWuIn/w4ymP2rbTPHYeIihoYbZRLrOl+dEeX
         Qgb3GOCwbh9vgXe4AeNOJRZP5Qvpg7a4iOJL3cftMXjtdtOAl/t+SsuSHRSF4LipIc86
         XiRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKYhSOS07rjGmyEnqWtQwOIyNNKJkNkjIMhqw1fMHj65rqrMNsail7OvVgdjL4amnE7S7evMaKXc0MqyJdB4hPLKUF
X-Gm-Message-State: AOJu0YysOoaS3/3pv8advBbHJh9RPdOOtl4Zq0w2PMLjrSvtL16WkDPn
	awCfCKbq4qthr4RNJx6+sAoAFHpcuEGHUJ/ckmRhcDbcyV8TB5TYRgfxOQ0panpQ4/wFCBTf++m
	tBHOTF7yoO0YCylpKRA==
X-Google-Smtp-Source: AGHT+IGzfu/is15/zbZN55ThZYoCmQ5oYPE0p+29NB0c/bvGkmqxURl5E0ogcz1hwkdaxZ/C24+OiRdX8VZRICmx
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2101:b0:e03:31ec:8a24 with
 SMTP id 3f1490d57ef6-e041b17dfb5mr382792276.8.1720654962919; Wed, 10 Jul 2024
 16:42:42 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:09 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-6-jthoughton@google.com>
Subject: [RFC PATCH 05/18] KVM: Add KVM_PFN_ERR_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

When a GFN -> HVA translation (__gfn_to_hva_many()) fails with
KVM_HVA_ERR_USERFAULT as part of a GFN -> PFN conversion
(__gfn_to_pfn_memslot()), we need to return some kind of KVM_PFN_ERR.

Introduce a new KVM_PFN_ERR_USERFAULT so that callers know that it is a
userfault.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4cca896fb44a..2005906c78c8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -97,6 +97,7 @@
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
 #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
+#define KVM_PFN_ERR_USERFAULT	(KVM_PFN_ERR_MASK + 4)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 758deb90a050..840e02c75fe3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3009,9 +3009,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
-
-		return addr == KVM_HVA_ERR_RO_BAD ? KVM_PFN_ERR_RO_FAULT :
-						    KVM_PFN_NOSLOT;
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+		if (addr == KVM_HVA_ERR_USERFAULT)
+			return KVM_PFN_ERR_USERFAULT;
+		return KVM_PFN_NOSLOT;
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-- 
2.45.2.993.g49e7a77208-goog


