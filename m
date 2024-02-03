Return-Path: <kvm+bounces-7881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10925847D95
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6112FB28278
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70D911713;
	Sat,  3 Feb 2024 00:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vjb9Ij/6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A4EADF
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918976; cv=none; b=aexMVm7peY0Kc3PRSjguv9zJz1wrw+oFoJRBkw4XBwnPs25UdNr9395LA2s5AAnoUU9KlZtUGIpjmFT3wgwmoPWvBSfb0d0CkEYbWXcH2RtDt9U09S2HrJgi2yc+obGdaD2M3WkaEOEYNy6jtbd7gJC6VGRRjh3ACkAgdkpD/ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918976; c=relaxed/simple;
	bh=D8mb0FRK9gpBnBRXkQEG+PB9Dag5X8x5Fbzx9RXG+Rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1hY2aIZcWYBFoz+k+8oQa8KzkcPvIBiDXRBiLVPx8h/twjay39+hckyhYebM8/HuHGp4UBHRk/vxJhf3QimRZYaH91oZS897p/ReWZMyZiDeU0XZ/Xqtv2akTiZ/mpIKmPh39tA7Y8bntjmqG6UJnFyODjM7iZ4NBTNpX4Am4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vjb9Ij/6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d542680c9cso31547885ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918973; x=1707523773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uGdQAEk26j5OxpYXu3PaMK7EeL8Au0IOP5m2/Y3bZT0=;
        b=vjb9Ij/6tmv+EekvnSYVIlmbw7VBjrmOZp+aU/COej0BFX1gexhugakIc0C53NjjGf
         TUcpWjHo/jGoTlU8hnPwYl9yQX9h7/J13VZydkPJ1EGR+vSL8Qv0b8/LzSTT/FPCBXCx
         avmHI0sDDTogW2uBzRhR7LtPj1NUvlqfdkm8mho8NPTd9cKZnMIvMtewqNmPDxTZ6+Wr
         nXExugYjWuWs3H8fTsWvW1XvYdSgqrQnqvXBPSBZaiJlLzPtnRcp/YkKZ4CxlBraZ3Sr
         aHHyXufNt4tSytE6stJz1IU5aDrxRRUAdlKig4Iyd24OVyWTq1pxjhT655Vp8Zhp7Q9G
         3bdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918973; x=1707523773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uGdQAEk26j5OxpYXu3PaMK7EeL8Au0IOP5m2/Y3bZT0=;
        b=lMw0Nu1NX4+tN2fMwfyb/6FbBnOupBsHL/vdotJTejl1zuXdOs3d4CC84B6PRqLhYk
         YG1STQM/QGZq62Izwp1ocgW7BhNhYj4/8CR9gqFuUyA0VGbX5xpTYlO33rb1vf39ayLo
         TYMweFiEmvyBUYXM9V2erFqhUhrF43nI/Vk360P3/zo+dcWutaLThupo4gr1Nf8YFLA4
         hrFo4sc1bQaNxvaUbYet/f9fDDrhr6hIYfqRqOdaeW2N/dLF8PcWBRCgGWanyz79d+0K
         O9AYfTg3bCIj1ivToq9PY0/ZFW4pijZOeC/kHLpjuDBQGwWVMqY498hd8FLiLS27KZUR
         W1WQ==
X-Gm-Message-State: AOJu0YyW6r+3fPKxhw0R2H3vVzqOm7uL66fS5zMKgdWjM+c8PQOm6y9i
	a6cSBKlR2qev1xDNo1KvrQaFMBD98JNsQJ9aZdHwSMsw5f2tD2d5ndDvaJrxBw3lejjnLzzsbfw
	YvQ==
X-Google-Smtp-Source: AGHT+IFjC15kDw5iExzgefryGqdvDfKmWm4cQaCALbm/PwXRZkCDFthW43qe2jb3I/GBr57667GkOb1b5Sk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80c:b0:1d9:855b:629f with SMTP id
 u12-20020a170902e80c00b001d9855b629fmr3990plg.11.1706918972726; Fri, 02 Feb
 2024 16:09:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:12 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-7-seanjc@google.com>
Subject: [PATCH v8 06/10] KVM: selftests: Explicitly ucall pool from shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Allocate the common ucall pool using vm_vaddr_alloc_shared() so that the
ucall structures will be placed in shared (unencrypted) memory for VMs
with support for protected (encrypted) memory, e.g. x86's SEV.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 816a3fa109bf..f5af65a41c29 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,8 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				      MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.43.0.594.gd9cf4e227d-goog


