Return-Path: <kvm+bounces-9450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A168607C7
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 523FC1F22B6F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B1CAD48;
	Fri, 23 Feb 2024 00:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAa7me75"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C66F79C0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648985; cv=none; b=t7ERjyR8jCdgmKew6Dkhyj96keOPJpmBELtlApyYtWfSPJ9eH866+y6SqhRdSQx8W8pAO52xJY0RxM4nFoDU4pGZPvA/uXEqsQJpX0yRWRFY1iMJeXP+FViPJno+RWJcsNRsyF60hCRjpryO9pzf0skXOSqV0JYrC0h38pVGg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648985; c=relaxed/simple;
	bh=e0zqvQX4ZlL0fPn4DwqoWoLqJX7b6wznfe/Oj9KjKhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cYJyqCPGH3d+nziXMDp543109k331Nk21Q4n89GElCMbcYHOTAM1OogDlDaYBOWGFKgX0pcSPgecCoRZ32u0N7ts6sRgCGT2kjIkiY8wEGUpexWGRwNRvuhrlat9hG5scxmU1xjL7m4aG9EXszAzxPkMn0TZ5vaggSo6G7AcW80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BAa7me75; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dc5c7b0399so2820255ad.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648983; x=1709253783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S8c8bYa8F6WSgYnQg5Ml3mIasYavsfmgJ65i8xz9FOg=;
        b=BAa7me75LRuDqlpTm3X0tdjmN0XFop78UuVTZca+6ISLX+0aGhdMgTCZGQv5VGyCf2
         hS0nLEVDmiahO64jlYgZKFjVo40L5HlhTRUvEX1gy5uGfBwVYHmnXZAfdkwMMNRW00Qk
         NZXW+73OxpUHJj1CZj9evmS+zbjWjHckicZhHf/NXRvjO2U9h4VRzR8bgYUT+cf/EY7s
         iAyClbozLWKDut/i+b/lmf7imhSasBcn0RQMGAcILNCPFhhQJSLtsexJZRjFbk+ZI++A
         okD+w5WHIkk42eT3eMupOyKG+PJzToM543jV+/MhxusKHYlMY5Igp3s25aezDaP0vjPF
         GWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648983; x=1709253783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8c8bYa8F6WSgYnQg5Ml3mIasYavsfmgJ65i8xz9FOg=;
        b=ShxB7R07WdkemYSc9FMU/jpN/42KdtJ/EdgLI5ckQIgGCGHuZiu7dqE7u4Bb+KCY1z
         DwN6XzCEwrnv3gdh8Kq+bVqIzNYJtkkcQ+nBiUnJ7RxRfqWdnbhWowTLlGGUT+RJlejO
         EH/Fs6e81g47Po0arlLIbHsFQrOfVrUHRU3zCTNGn9N4lSSmrl5aXu9DjVn3rijCcQ+d
         LM2xnmSV871hb+q4yjw44D71jlXI7cn51nnVsGv3n6a6AMO99k5GanrdsLd+NuZhX9nU
         hCiUO2jx+qIWY15BRtvnt8vnuOCjVdZ6/cXkEmkyhHfy/0olNCy7QqUj9lGQCk8O2w5o
         2ZVw==
X-Gm-Message-State: AOJu0Yw7Es4EUPZB1xo5At71AdqMhGSm2QmaT/s+rLEzyIf94FF2xVbP
	A1x8zUkUxsZWVmurum8hNxWVurEFLSAt/4MXJLH0nNk0UW3ZrzekxqcEORjdJx+xqBViTD7PXzU
	KCw==
X-Google-Smtp-Source: AGHT+IEpcCEeeYEZT1g6/yIIR7SqlJXRiXUY/d+cOATbynjlJc6ZG004EnWI8Es0Ckg1caDaoicixhIztHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d2:b0:1db:d810:89a5 with SMTP id
 n18-20020a170902d2d200b001dbd81089a5mr26791plc.0.1708648983559; Thu, 22 Feb
 2024 16:43:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:48 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-2-seanjc@google.com>
Subject: [PATCH v9 01/11] KVM: selftests: Extend VM creation's @shape to allow
 control of VM subtype
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
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Carve out space in the @shape passed to the various VM creation helpers to
allow using the shape to control the subtype of VM, e.g. to identify x86's
SEV VMs (which are "regular" VMs as far as KVM is concerned).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 9 +++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 070f250036fc..d9dc31af2f96 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -90,6 +90,7 @@ enum kvm_mem_region_type {
 struct kvm_vm {
 	int mode;
 	unsigned long type;
+	uint8_t subtype;
 	int kvm_fd;
 	int fd;
 	unsigned int pgtable_levels;
@@ -191,10 +192,14 @@ enum vm_guest_mode {
 };
 
 struct vm_shape {
-	enum vm_guest_mode mode;
-	unsigned int type;
+	uint32_t type;
+	uint8_t  mode;
+	uint8_t  subtype;
+	uint16_t padding;
 };
 
+kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
+
 #define VM_TYPE_DEFAULT			0
 
 #define VM_SHAPE(__mode)			\
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4994afbdab40..a53caf81eb87 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -276,6 +276,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	vm->mode = shape.mode;
 	vm->type = shape.type;
+	vm->subtype = shape.subtype;
 
 	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
 	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
-- 
2.44.0.rc0.258.g7320e95886-goog


