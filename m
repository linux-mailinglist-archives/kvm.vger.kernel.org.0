Return-Path: <kvm+bounces-54297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB54B1DE22
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 173665868EF
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A0E2253FF;
	Thu,  7 Aug 2025 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEYHgR5I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE18280A35
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597839; cv=none; b=jPtrKz41e1KxNcAf38Bmxez4Ah+JN1TDv7uNcABba4OCtr3/3eAniwX9HoW6Z4o2BS4UB8X5gQJo7daqbCWDN086EUxPC+9q8mhjf4YzZp6K0BrTD3WvCGpfnMhI/OEQg7WwZEoaQuPFhEkAQG5tWRe14iWByxD8g2EJE/NokxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597839; c=relaxed/simple;
	bh=nf0EzG5NgSXKa/TrkEawzdB34B3daS0Giz+DgYxepKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aDvtji6T1MhJzfuLg9v6dRaRWas6jGV6AisaEa5/Os7iiDKo71dv9FUcE8Ojcs3m24lHQLjb1QFA4Xtskv96GvQ/4nIAUKDZC3M1u9FAnBU7t/nT8Gqfo8WZr5dKRg4lA+gEccA+/mG7hFXh3IYqTIaX4Au0RYMlRhS3mrKGjMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEYHgR5I; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32147620790so1481833a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597836; x=1755202636; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iq172XdXxDqkESP8AaCKlxAjIACVlq1lEydY7qNJG/k=;
        b=eEYHgR5Ig2P560wuONsaZ/RZZ+sv1mUM1WNVm94Ajo5W9FVpE382KJWbsD1sEQMPM5
         7O/9SVcsEe1c4j4xpLPNHUgy0aJKjlooNNC4vcGU7Mgk64yfamNSxXjH6VJNcs4PsDg8
         uc+ztRONLyFPy9XDoQOzyxbLn1twHgBc1lVLWGVesqF6ZAJcUwGRHBhFT0FP5Fj9GcWB
         afETwl2vYRZa96rIZySdHxveUw6ARX//WJVnIIXLgI5xm0IpGDCHcsOuNbVQ/GdwLHwh
         vTp1ZjIGTrVzkkEdBZoSyRqD5BxqMdevBziqeSyyWqCV2TRSQ0yvLsfiyjR6Wj45vdI0
         m92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597836; x=1755202636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iq172XdXxDqkESP8AaCKlxAjIACVlq1lEydY7qNJG/k=;
        b=nCwQEuM/QaDjZM1CPWU7L8X1Mo7jubQ78hY0aqZBIQgQiqi5KYBcytfYqswnXBcgNP
         QLaatQEuGLrQun6/wIgBtNDY1pIg7w1ofpyMOJpdQWofAzK5fnHm3Z+jFEVDfa7Q35X0
         1lv9m5vBqReDkuy0dDhSMgoijaKKqjwk/8uPRg6cJEZfH5bXaFBGJMsslX1ejdzOOIR+
         6fp+gSBgKRog230rXDXK+yPLoMNVaz51OvoPlPCcVEmZHW6U2NeQ1B+1yJDjRplvo6P6
         9XdhFNoaqBEYf/2eFHGiHsVsTpPu9zhSe6DGb/f8fX6u49Zys0uvyklnKyk+M+ZsK/5W
         HC6w==
X-Forwarded-Encrypted: i=1; AJvYcCWCBgVkF+O5qVmpUxq0yHp6rJnxjYuXTu9Gw1+NUIu6fft4rPR2AZgB7J8Aec7rKh0yEA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTl+AOs7Kla/DENY3XOLVSx2ot6xjdXIXz7br8mflXAbFbp4nB
	fwrWTVxD2rLoz9W0t8ejNRfcw6Flp8GUTDCV2Cr2NHMBdcbjyJfg/397RZDm6zz05/JojT0R7jK
	r1g==
X-Google-Smtp-Source: AGHT+IF9GDKYO/YboaNdsTUnSP/4IoWgR2B49CtjJAmqyOJRj3Eemq3TkQ+JtNffql2w5H+tGl/Z0AxnOA==
X-Received: from pjvb4.prod.google.com ([2002:a17:90a:d884:b0:314:29b4:453])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fc3:b0:311:fde5:c4c2
 with SMTP id 98e67ed59e1d1-321839c8a75mr496473a91.1.1754597835694; Thu, 07
 Aug 2025 13:17:15 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:21 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-26-sagis@google.com>
Subject: [PATCH v8 25/30] KVM: selftests: KVM: selftests: Expose new vm_vaddr_alloc_private()
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
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
index 2e444c172261..add0b91ebce0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -652,6 +652,9 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
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
index 14edb1de5434..2b442639ee2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1503,6 +1503,13 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
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
2.51.0.rc0.155.g4a0f42376b-goog


