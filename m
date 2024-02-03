Return-Path: <kvm+bounces-7876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7581B847D8B
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54D81C22792
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E942F53;
	Sat,  3 Feb 2024 00:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCaTiZpY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4EE80B
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918965; cv=none; b=q4R/K8tnndzZef1hYQheSFB5x3zfxSSvE2GN2GfddkZOi74yMJqUnRPTKu7K8XLlKEV+Cf3cnn8hInLq8EAzWQV4ILNKFkQabxGnZunsi/WklvnHUU78lqXrXdfto+88q+ZU0FU23gE4ABmXq+sftCYWYdXa78A+7V24UbOqQEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918965; c=relaxed/simple;
	bh=DQsGPwFy3v7uPs21OAJ9r/tyAnYHLR0BBzOxzUXWZ6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EmLEgVOj9Ug56sjY/bxKEHiEi92edaYEbZkspBMkvl6GhMMkxq20KFIH5ur6oS3m658eTWlSNTxZWqZH2IjLoQqZmc+OumK+O1UiSvMVc1eZIscXl9gGqLnF+5cpaKoHa4FyyWSKMlSdVyWnAUt9QUh5JRMxBVN690lfX/HWvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCaTiZpY; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b9f4a513so4091912276.3
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918962; x=1707523762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OEEHd6q2TChurvVJ9QWQDtWt/fR7D+phxscUNFsCU/w=;
        b=NCaTiZpYfUYV6aEyCd55jbXAuVRLGHmocKLd11khnbFf2d5SITGcQY1/VCKor88P6T
         3b1ofVmwetI1rzqzVVhX9zsr0ixBt1+8QA5DkNfal0P9y24cGACiyD0+QNg2rf3iIX2K
         y0QwynEX1sSrkt5ZVdphd0vqyUU2M40rf5B3GIQMmAfilEss7MmkQYdSMR1XOoTxBu9+
         vCO6+der2su51qtCCadahvKTHcYjoA18XH4IGAyg/k6PKdjw16h6G2a/Bhfu7JXKKO+4
         jHyCBvzhLs7M2NDnF+eMpyWLdL5BovQm6CW8l3FcjnKmI1mdcLiYjYDm0ipJvfSdJHz/
         XCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918962; x=1707523762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OEEHd6q2TChurvVJ9QWQDtWt/fR7D+phxscUNFsCU/w=;
        b=pI6jjiyJYGB9P3gukAOlC7aCaXKDGX6xnSuFpFHzP/czL2vDSfDXFr/ivt8zEZiFzh
         H7ofbfFiIOt8pglHiY0vwJoeMy7Z+E6Rt9P22+9STUemg/rdVogSnPV+mYZEMOwHi+UX
         32BvBwlQ3neGuEY591okUqcY7ulVvDSqI9dREEz7PYcnuhEuup3HJ1g3QvowwuT3LW5U
         KuINfGpHZx8ZRSDGRFu+nD/uFt8KAiFPJuqXbaDuwxugsyvnNxE7AmReAjp/8TeXlKje
         fFvl41NqUpivccl2U+qhJHSboyMTbdWeVdBTQznruM2l3VDGRBsw1jIMe8TOETcQF/fg
         cdkA==
X-Gm-Message-State: AOJu0Yytf7Ut7qlRi4VW33boCE7wPEtT5DFJsTzx3xKRZz+LZkeJN7WY
	RQY73A2j7ZGM7+/wvZBz0npbO6CSLtHicQ178Tzp6px5vPKMd6KINGXBNrE1kVn+l7WROR4th54
	9AQ==
X-Google-Smtp-Source: AGHT+IEcnlTVvkgM/agP2AI7SK0XtZwpf1RNWRzpnYbOzQzjKWA86nEjOukuZ0+7uKPyvsge0rWvGPAYF88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2402:b0:dc6:e7e8:caae with SMTP id
 dr2-20020a056902240200b00dc6e7e8caaemr1059362ybb.0.1706918962763; Fri, 02 Feb
 2024 16:09:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:07 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-2-seanjc@google.com>
Subject: [PATCH v8 01/10] KVM: selftests: Extend VM creation's @shape to allow
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
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
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
2.43.0.594.gd9cf4e227d-goog


