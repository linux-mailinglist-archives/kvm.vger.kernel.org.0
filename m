Return-Path: <kvm+bounces-53667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D3DB1537C
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 21:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 496D17B11E3
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 19:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C937B299AAE;
	Tue, 29 Jul 2025 19:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vl/WN7QU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53771253B64
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817635; cv=none; b=tNc02/UeNTn1H9RbdABvqRpGly1Vdh4UlKZ0iTMp3RkkIm/oROr6qA/wRX/PvwH79tr4nU5woPv/AsSg1hADrxTf7+RWNQ0QNX/M9FIjHxWSTXp4FcARbai/DjkDbREq/IDXctjWCd+AztVGy0Cdpav64V/Lgi52tjVhnp2Ejsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817635; c=relaxed/simple;
	bh=fdpTasDFylH0aih/WYUrRlBApDM32hVkvXUFxrZnj7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NWJs59+HXUPBeI/z+WSHfVFHYBz3BXv6PNx07Aap92D973ocNMXkQLKYv0Xn8KBIXkXOilZFEHOP6Db+nlx8MowFUBox2rv/u8AevHpFVvyVk2z6M+dFAtlEySzIXLY8AdNb1lk2SHixMCvVkhjprqoAggLmjBeHqAsT4vVG3uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vl/WN7QU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31eac278794so3381211a91.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 12:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817633; x=1754422433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7kW936wFYM0Ary5B3+n4kBp/4+0suFDEkHTdVVXpkj4=;
        b=vl/WN7QUcCEBYWjx8aNCRVbyMAuuSuPLGX29IvbSEG+d8CXHVPWProqYm3Ze2OjCVU
         3Nq7EsC4LkXktkEkHh7jMfIZapouws33xSx+8gDTsuQstZ7si1rTAKI2sKmNCeChq+zy
         Upqx8Fj3efd0fvFWzTxVfhaOmiQPq32mri5Gg6kwZhG8vdptNJnFkq/LkXiyOr0GwLrx
         hKgVz46yPHNAZa14Ki9Wd0cv0hgpeqha8c51SrL+1qPHU1hI4A9ASmK1VDzs4crCje8J
         p3x8Hv/63upaOCuuWcIRPZmpOPKmgldZsnPsrqiR4bDfIKwhdu8tIGymIQmsCevIWjCc
         THQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817634; x=1754422434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kW936wFYM0Ary5B3+n4kBp/4+0suFDEkHTdVVXpkj4=;
        b=getieVtjBmAKK6G/bRhPmctrcWWJhMRvpGoogyDNUaAivjDDlxLzB2p/qPmDMLTc+m
         S7VsQIl6QmM1KWXRYYbm+VbbWfr9Ugu3TiR8oIc5th1so3EljGku0wO6uriZSrAP+VfF
         TLxN16ICxW3NaAno/WGpcedr3QCwVHGgrwNTFSqBBc5Fnxx7RJsnFvAlxTII3/+KhKUg
         Y3wQ/blGJXWblfpQgxPvkKKjM64ymWdW5OuyyUkBwjsf3Gk3T+NTwfG7Y9axk6Sml54a
         5Kn25Aa+prICTv3s4lOSVwthbEck2xlax9Zqq8++1pbhruE6BcLqS74m1LdDdIazc/i/
         d6jA==
X-Forwarded-Encrypted: i=1; AJvYcCXk34eFbxcFI2YIAtL9ZAAdVSyeHX0p4b/nIccQ5oKhzP9OCUIZxVwNg1ffofO27qCiq0E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6zB9ai60geqC7t3i0X6AGmJVp2P+3AHBeQPwQQRxPWUrJPENO
	h1nwD7N8yiPdDecu4VEUQV9mAU7hqBDayi+mxRwsFwmuh6pN1wEIq/916HCTrzP5em/NtaMhnNl
	+hUtn0Q==
X-Google-Smtp-Source: AGHT+IELFOFWc8vYkYZRQRf3VfKYyLdceEz1T/Y/HkOfoDthT5RfeT3LHFZMzx5elvj9USSUE7rYmRIpqRk=
X-Received: from pjsc3.prod.google.com ([2002:a17:90a:bf03:b0:31f:a0:fad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2684:b0:313:20d2:c99b
 with SMTP id 98e67ed59e1d1-31f5dd9de5emr917579a91.9.1753817633690; Tue, 29
 Jul 2025 12:33:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:39 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Use for-loop to handle all successful SEV migrations
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Use the main for-loop in the "SEV migrate from" testcase to handle all
successful migrations, as there is nothing inherently unique about the
original source VM beyond it needing to be created as an SEV VM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/sev_migrate_tests.c     | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 0580bee5888e..b501c916edf5 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -14,7 +14,7 @@
 #include "kselftest.h"
 
 #define NR_MIGRATE_TEST_VCPUS 4
-#define NR_MIGRATE_TEST_VMS 3
+#define NR_MIGRATE_TEST_VMS 4
 #define NR_LOCK_TESTING_THREADS 3
 #define NR_LOCK_TESTING_ITERATIONS 10000
 
@@ -72,26 +72,23 @@ static void sev_migrate_from(struct kvm_vm *dst, struct kvm_vm *src)
 
 static void test_sev_migrate_from(bool es)
 {
-	struct kvm_vm *src_vm;
-	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
-	int i, ret;
+	struct kvm_vm *vms[NR_MIGRATE_TEST_VMS];
+	int i;
 
-	src_vm = sev_vm_create(es);
-	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		dst_vms[i] = aux_vm_create(true);
-
-	/* Initial migration from the src to the first dst. */
-	sev_migrate_from(dst_vms[0], src_vm);
-
-	for (i = 1; i < NR_MIGRATE_TEST_VMS; i++)
-		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);
+	vms[0] = sev_vm_create(es);
+	for (i = 1; i < NR_MIGRATE_TEST_VMS; ++i)
+		vms[i] = aux_vm_create(true);
 
-	/* Migrate the guest back to the original VM. */
-	sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
+	/*
+	 * Migrate in N times, in a chain from the initial SEV VM to each "aux"
+	 * VM, and finally back to the original SEV VM.  KVM disallows KVM_RUN
+	 * on the source after migration, but all other ioctls should succeed.
+	 */
+	for (i = 0; i < NR_MIGRATE_TEST_VMS; i++)
+		sev_migrate_from(vms[(i + 1) % NR_MIGRATE_TEST_VMS], vms[i]);
 
-	kvm_vm_free(src_vm);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		kvm_vm_free(dst_vms[i]);
+		kvm_vm_free(vms[i]);
 }
 
 struct locking_thread_input {
-- 
2.50.1.552.g942d659e1b-goog


