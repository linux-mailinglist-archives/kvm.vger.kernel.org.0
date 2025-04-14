Return-Path: <kvm+bounces-43308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B48BA88E77
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 870BF3B458D
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3102343AE;
	Mon, 14 Apr 2025 21:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1GhSnsF7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4722B8CB
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667358; cv=none; b=Q5PFmNppeU69uZCx89LvtPqueEx1huObjOwcr2S2G1RHkfe4R2u072aqtHHy9dVNUxJrRfqM+jFi3PFM1toh/KWwVdBBQgDJbZ6C8IrX2RlLPesQecoa+zKHfs+gHW4siaP59IlSATyWCXinZw4iTC0hSAYxGA46ZoZk6XxmQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667358; c=relaxed/simple;
	bh=RUYEkYTMaq/3BlLYohoirll+7ThOc3FAQ0S52ejBi18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kYXxvQCH3wPUGYoB6goBX6LClTpSXrHRxTKgN6pNhPqfhHoQygLPwReEaO4ZCk6V91BGVvppORzNApPU0vsnT+1BCY1I01gHtbVLGnlI/BZSB7jk4VunPYrPpwtdxWCjOSFGCq26diOpJAnbERtr1g1doH1cMoJjqNuT4yxOMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1GhSnsF7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff798e8c3bso4518747a91.2
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667356; x=1745272156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nMPet3QDUUSXb/aMjIhmKZ7iY71MK1Il6Y5uwK/4fYE=;
        b=1GhSnsF7pP4ccVmf0VOKlcSA8LYxznW0+e5EKlCOcF12WNcSeiIByjIwnnGsmoMegI
         YiSmAVwLKTdRilAx0xUoRP/czjD2zu/yXEJRA5NutKZUhls9HC14TOQmpzIJoOYE78q8
         cZbcwQp9FTw2aeQK/C+1lWZYmclGvOuIrLhG/Ao35v4SZHZUo4BXlrlx23skX52D9y28
         TdDWfyFq+klOjT/knXy9m3+aRjw9vvC9IJi2Ql11/tx6m3p+UCv/VPBXzT+sdj5lMHmf
         It/N5qf+R+RhcigF795IWprTFs92AuDK0PTpLCMyXf6sRV7uj+b7/unYFa0NQ3ahRr5E
         u4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667356; x=1745272156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMPet3QDUUSXb/aMjIhmKZ7iY71MK1Il6Y5uwK/4fYE=;
        b=OFEUO0jp0kY+brPMqE2EKumLBclPYnxfRYmvN9erC9UQWPxPV8QA1bw2nByDCkA6K6
         tz8Pd5SDN6EMDp24C7ryo73Ti0EeXRqxUTooIsmjrBeqm2gSOlGD+hLG/cFx9HSTeHxy
         SvGowRKUt/YGmw3zLHI7JfasHnzCksWgBpOlF94ZLQ7BD1JobknhA70Jx+fjuwigEOfs
         j7HF4V95pq6GfexSYFGqNPbbAM4xuscYClB9zdt5h4O/GWH/2F4eaz7oZ/zFKoKP+Cg4
         7FqN4z0oI+YdnIG93L6qD01w3K+5Ddd/I3nR78CeBeDoOhoQT8zFVMRZVn9Ucm7l+Vt6
         Oi9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTeBv1v6ibV7ZZqzv2nsX5Ob2dLtPNLDoR/g6Ju/pix97Ub0xpus0XjZP6im1d7Bnxzpg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq7LmKZ1wFYXRT+iNF9fVuPPqCyRfBvzeebcCELDugTJlwV49K
	t1GEYhLwahET2ox2AVXNOsVMNvsdIMaqh69khnd3gHCz4afnPTRW9j7qmt8CH8Aq/qzaXzAdpg=
	=
X-Google-Smtp-Source: AGHT+IF6DTwMtcpY+dm9XhXfMkBL/aQSNoT9zozLSWGA40+RquY/Obe0DR00PEcuF3BMTI6cgXnFJZGzFw==
X-Received: from pjbtc15.prod.google.com ([2002:a17:90b:540f:b0:2fa:1fac:2695])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534d:b0:2ee:863e:9ffc
 with SMTP id 98e67ed59e1d1-30823646e88mr17299676a91.21.1744667356611; Mon, 14
 Apr 2025 14:49:16 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:54 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-26-sagis@google.com>
Subject: [PATCH v6 25/30] KVM: selftests: KVM: selftests: Expose new vm_vaddr_alloc_private()
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

vm_vaddr_alloc_private allow specifying both the virtual and physical
addresses for the allocation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 442e34c6ed84..690aef6f887c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -611,6 +611,9 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 				 vm_vaddr_t vaddr_min,
 				 enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_private(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, vm_paddr_t paddr_min,
+				  enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_identity_alloc(struct kvm_vm *vm, size_t sz,
 				   vm_vaddr_t vaddr_min,
 				   enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 008f01831036..9e0e28b6e9dd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1486,6 +1486,13 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 	return ____vm_vaddr_alloc(vm, sz, vaddr_min, KVM_UTIL_MIN_PFN * vm->page_size, type, false);
 }
 
+vm_vaddr_t vm_vaddr_alloc_private(struct kvm_vm *vm, size_t sz,
+				  vm_vaddr_t vaddr_min, vm_paddr_t paddr_min,
+				  enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, paddr_min, type, true);
+}
+
 /*
  * Allocate memory in @vm of size @sz beginning with the desired virtual address
  * of @vaddr_min and backed by physical address equal to returned virtual
-- 
2.49.0.504.g3bcea36a83-goog


