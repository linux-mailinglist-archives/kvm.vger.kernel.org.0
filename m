Return-Path: <kvm+bounces-55238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 197FEB2ECFD
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 414BDB60270
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508B02E7BCB;
	Thu, 21 Aug 2025 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OA/XPXwc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5C92C21E1
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750569; cv=none; b=FBCD0AO+3iGVbdXnRkOlnQ/Ar3BRETzOV5VVo53fvCr+Wwr7h6GEhftS7UWigtcCyKVClA0l9P8eE+DxxiHTW+lItkdpMDaT5xXnlrdMRw74nXn00UgmLBCgCPCPGAmpJg2jfmPU0N+8Rd5l02PrLWdEhUIjQ7gnNeAomVASQsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750569; c=relaxed/simple;
	bh=zv6FIq6T2D4dzhmzgUAB2L3Ur5jBTL/fvuA0Mkkyy30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g4NbXJHMkgkUGwJ2p8TMGwyEUl58USNtZZL9KqNUJMNnojv2Bcom5xgr3mNnSKfjAefhsG/xx+Os0/fskU7AhAlFsslJoz88pwJ7SmFi0SrW+hitEUezX3rx6jlv3xmxPGJbwGeckbpzuuo91Der+1WiyZjzB8R3H50TAzimtlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OA/XPXwc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b474d5ff588so429574a12.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750567; x=1756355367; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSoL5yGq80yHyQhliQTZCs8Xn2sZ4IJIZQ/AIr3ktz0=;
        b=OA/XPXwcy6AL4rewcNCblLJxyhf5wdO+T9BWdbJtTT2jBG4ncEMHJZiskR40p0nZkQ
         A/NOkhNT6lM+6XlbAKRuGBo98iwzRSeVtlBV72yQbtqb9zk8Vs0oaD3AMqOuv0mCo/bJ
         jtD5mUyJ/UDg/h5cB3u3YuN0JT9ie8GC8/xrwogNsWv8aW3XnOdCiAsUB31sd/bWS8gx
         qFzJ0MfxvKCRldAa9HSIhS3HzIVeoautAl32BojAyytWNQRXV5+/EFUVmpyJ9qG4JvC3
         gexVhUa2rdTu7rVTbsAsrTJiK5aJ7G8pRQT1yA5WEvSh1TAHqNS9hQzB3VYwB4dkcDaR
         deTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750567; x=1756355367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pSoL5yGq80yHyQhliQTZCs8Xn2sZ4IJIZQ/AIr3ktz0=;
        b=eHcTGoA5SmY0hlmv7Q26PE4sAyu+dqgwO0GSgVQPc3EFB4YMDFdhTpjTkrrbCuUKNJ
         lSmGqNm1fRc+ncmwYdXED3FwoMeVW5zgh1S2GOnnLxa9fQRq+83ArBEewHXZalHK+4YV
         HUhb3CrfzL892G8M6HR71a7r+2SBCDgCY5kygT+bcJYRRiy3HNKYIZzp5fTNhHJdeaIW
         J/7DjgQCYdTti1S1JokCokBhH+cvM2SXxzoyKcDkubERJmRTmgxYMEgoOpWR5oIJTsUx
         jiyFcoBqwL942xRN4RNcTvA9p2KHHkfA3ReN3sMO/wz+6kZnF2yOpyNMr3cdAj9NJR0k
         nhFg==
X-Forwarded-Encrypted: i=1; AJvYcCUDRFG1nJqwyOOVfFR1wR2XM/Cjh6ChaoFukH7spddL9K7v3F0UNBcuQKX+n+Kj32UdD8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwnEGDTcb8UeVNkvjoAWfbaofvZ+ib/wRsLyCTgS+jMzjXBImq
	rJmxnouwbBKvUl+81ck4RPpDEhZpTpNWVLcWis8N0xauZuPdkBsAFbL/iS6PrmAR7JmzTSuy8D+
	CgA==
X-Google-Smtp-Source: AGHT+IFzy47sIgRRcuXNryiWz69eC2dqNE9p2/+PJhLwuwKSwGj1Za3Zb8r/eXfaTtlojCZl+N9VPBLMvA==
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:31f:b2f:aeed])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3383:b0:243:78a:82b6
 with SMTP id adf61e73a8af0-24330aaaee3mr1322859637.48.1755750567082; Wed, 20
 Aug 2025 21:29:27 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:28:55 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-3-sagis@google.com>
Subject: [PATCH v9 02/19] KVM: selftests: Allocate pgd in virt_map() as necessary
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

If virt_map() is called before any call to ____vm_vaddr_alloc() it
will create the mapping using an invalid pgd.

Add call to virt_pgd_alloc() as part of virt_map() before creating the
mapping, similarly to ____vm_vaddr_alloc()

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c3f5142b0a54..b4c8702ba4bd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1609,6 +1609,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
+	virt_pgd_alloc(vm);
 	while (npages--) {
 		virt_pg_map(vm, vaddr, paddr);
 		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
-- 
2.51.0.rc1.193.gad69d77794-goog


