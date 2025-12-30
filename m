Return-Path: <kvm+bounces-66876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E9470CEAD0E
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7CBC230146F8
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95AD62E5D32;
	Tue, 30 Dec 2025 23:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jCtDd5bb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E322E7F1D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135724; cv=none; b=pa6XvzeR+PRZkvAK4yBq5xZ3RT36/xuMLMNcjssJH7r2i8zFixsBEsl+cors1htBkHlciq0voEXl0qOCHQAombhipqzFV5apREPNIvizwuZK4ffYFtBNfR98mdDXIF5BOHQxqqmyzk94P7wry7c7CxFDsaVnWmVTVEudfusrBv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135724; c=relaxed/simple;
	bh=NTL8KGsm6USzTzkvmwpcMZD2nPHbvkmlY/rR1jDM3PA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jv+ZtBDmuRWQWuoDD9fc2sgh6c1tdKcBD0qZlGGcJKFZXk36vvrp5cSo1Hky6iJd7k/QiRDD5zRqPb0nMdIS93kWirmKXI27pRO8mgGfOP2spqLJRtrDNoqBg7B3kMPtd+PGS35jex4Tvc69Ie6+7x2Pk8Qr+/OkcBwf0nCUMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jCtDd5bb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so22827158a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135721; x=1767740521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=snslv60TkZffEAQE2fKI/7w9i9KGKI8ATFVeEcgF+Qk=;
        b=jCtDd5bbIb/tv7YqEYBezTqu/1qenXfDKzunLM5fXgpJWGQHsAmtf6yaK5jMGtdah8
         dAgOesSk3RqGLPHh4/wUdlPY7+ofxZN1UCwvxzJQaBScdwdgd5eEIlwaa5qmtXSbguEC
         UgNYFpgLptqLjhjubwVu+rX4MxaPGcANWiUuFbB+KpzRE7hyhC383+Fqh+tGWOX5MPu8
         MAZJd24BylJTzFdNA+UK5H/xG3AyMT3tUwY8nUL1KDQhtQsIK4eTR31nDbLDVZ5x9cBm
         VrRBwh6hU0lJEabwEWc3VFQjQOAlMY5WgTBEfzYvryKrsn2trU1X4g9WS7pMHod2hjvY
         uRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135721; x=1767740521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=snslv60TkZffEAQE2fKI/7w9i9KGKI8ATFVeEcgF+Qk=;
        b=eLXu9jYaFzYxAm8yakXk/rfb0BQIhvneXZXuefHAKCf6F9f8K1DpYotVwcMQJdlFV0
         z2yze48wfY61tsprm5MhKCU2xT1uhgHknh3gr0sDzkloZ77cK3LlDBE9JmblOtUGZ35y
         q8nB/OznCvoovKoxDqLOV86ex85tSZaXQpfNP4/7iBc3t4Nif+vZ2oUO0gkjnGzY8Jvo
         wgbkYFgGwniNsGBS7/Ns2B16wV5Tsl404MDZNzt1baDGYcv9biBm+KuE8HnwSJD11Usw
         TuQ6JeSW+PUL4HMzJ6DHxF9G1fFHQ9N1K8pebvP+hpMAKmakJYUVLcC7KGUFpyChU4Xi
         IspA==
X-Gm-Message-State: AOJu0YyzITrBrnTxS1fPBxeV6eKZQ2ezIHZu/Of8hLK8Dpv0PpjcUrA7
	+9506ujsvLPqtDlWQsjiCb/DFKcSOSSyvbHEYN/e4D5TM/idO2tIio9fLpYi427JniKAxXM+zdq
	d09hGDg==
X-Google-Smtp-Source: AGHT+IElvIFPPzPbx/fWhmlKYhmrHPLLecvBIwXjPK26QLj43KDrpSTQ0SF/ILvphJaY0JI4Mn53QzvVzYY=
X-Received: from pjoo4.prod.google.com ([2002:a17:90b:5824:b0:34a:a9d5:99d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0c:b0:341:8bda:d0ae
 with SMTP id 98e67ed59e1d1-34e921b7334mr26690257a91.20.1767135721380; Tue, 30
 Dec 2025 15:02:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:34 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-6-seanjc@google.com>
Subject: [PATCH v4 05/21] KVM: selftests: Stop setting A/D bits when creating
 EPT PTEs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Stop setting Accessed/Dirty bits when creating EPT entries for L2 so that
the stage-1 and stage-2 (a.k.a. TDP) page table APIs can use common code
without bleeding the EPT hack into the common APIs.

While commit 094444204570 ("selftests: kvm: add test for dirty logging
inside nested guests") is _very_ light on details, the most likely
explanation is that vmx_dirty_log_test was attempting to avoid taking an
EPT Violation on the first _write_ from L2.

  static void l2_guest_code(u64 *a, u64 *b)
  {
	READ_ONCE(*a);
	WRITE_ONCE(*a, 1);   <===
	GUEST_SYNC(true);

	...
  }

When handling read faults in the shadow MMU, KVM opportunistically creates
a writable SPTE if the mapping can be writable *and* the gPTE is dirty (or
doesn't support the Dirty bit), i.e. if KVM doesn't need to intercept
writes in order to emulate Dirty-bit updates.  By setting A/D bits in the
test's EPT entries, the above READ+WRITE will fault only on the read, and
in theory expose the bug fixed by KVM commit 1f4e5fc83a42 ("KVM: x86: fix
nested guest live migration with PML").  If the Dirty bit is NOT set, the
test will get a false pass due; though again, in theory.

However, the test is flawed (and always was, at least in the versions
posted publicly), as KVM (correctly) marks the corresponding L1 GFN as
dirty (in the dirty bitmap) when creating the writable SPTE.  I.e. without
a check on the dirty bitmap after the READ_ONCE(), the check after the
first WRITE_ONCE() will get a false pass due to the dirty bitmap/log having
been updated by the read fault, not by PML.

Furthermore, the subsequent behavior in the test's l2_guest_code()
effectively hides the flawed test behavior, as the straight writes to a
new L2 GPA fault also trigger the KVM bug, and so the test will still
detect the failure due to lack of isolation between the two testcases
(Read=>Write vs. Write=>Write).

	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	WRITE_ONCE(*b, 1);
	GUEST_SYNC(true);
	GUEST_SYNC(false);

Punt on fixing vmx_dirty_log_test for the moment as it will be easier to
properly fix the test once the TDP code uses the common MMU APIs, at which
point it will be trivially easy for the test to retrieve the EPT PTE and
set the Dirty bit as needed.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: rewrite changelog to explain the situation]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 85043bb1ec4d..a3e2eae981da 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -432,14 +432,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
 	}
-
-	/*
-	 * For now mark these as accessed and dirty because the only
-	 * testcase we have needs that.  Can be reconsidered later.
-	 */
-	pte->accessed = true;
-	pte->dirty = true;
-
 }
 
 void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-- 
2.52.0.351.gbe84eed79e-goog


