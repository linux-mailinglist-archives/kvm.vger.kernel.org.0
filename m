Return-Path: <kvm+bounces-56746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C931B432EC
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92D701C25992
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EBD28725B;
	Thu,  4 Sep 2025 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQu2SncI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8CA2857EA
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968906; cv=none; b=C2zTsQ9ApGNzLl6qevWoSGxuS3eRtGNtmJRbmIirtL9tDJVFtourVAE5h2kT21z5sjyQUCltt6+1O0OWtPhIHqlW8sB0+B6zbcCnAwJQ6KmVYzV41MfjhB/p/cSpHm155IPvL+S9a2YK3UE7B5yVLlArXAm/XtD7H0uYpZFo0gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968906; c=relaxed/simple;
	bh=faOGkpSzpOyOpNjAb1lIsIvMQ/6D2s/m8DjORXdbeBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zwq5tMOApeHehH3VkZDnJiTAvZmUlnad/WFBSxU3dl6i2MSl99q0GLgH+4earQMKqok1XhiZGwK64AwuSh+uuwliWSy0G/vXqYE0ca+Qohbkg43KBVo5WC0LRaItCZzGKiyTcBQdiCltxEZsAeAmuGYXYGaTc9TcUZLxHdUcl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQu2SncI; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77237977e7aso617475b3a.1
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968905; x=1757573705; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASqlFc0gx6M5+AiwFcVEnxp7D9dEbOExh/FBrBmvKuE=;
        b=wQu2SncIvbSbZ4GodfwVvwcAlVC9fe8E/lqIGu2Mats2og34CLKwyFe/XWH1HCiofN
         1K8BKq1kDvQMKEqTrrnKaLB/eoPFgLmcYLR+MHIGprW/ddBlaXYnhkVp4iebcZ/VskKx
         f9BFMrR2Dav/8kMTuw42s/1GHQ6JFq1+xar6qOIZRH7pdf2NIWxWoU/ivprxIY/bMnBL
         lnxHo11ihOGVFL0xv7TeUTbj6vnMdvPmpnPz2xw0/qCGZAb8WAcI7rNLDLSxDYyK9V36
         tUE0/W/7bMDiB7IoTnzgBeEG0xIGgGliWMafcaBsBla7M1eZY3jbzqmmO9axOUDwutbo
         OeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968905; x=1757573705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ASqlFc0gx6M5+AiwFcVEnxp7D9dEbOExh/FBrBmvKuE=;
        b=eJq45PYu6gvmisKyewz8qqwZP8+gYGH7kPS77v1f+PU6bury6WAkyr7IsurUG02CN7
         XKD2NomQdnZOkEdFlZ2KxAmvw76yHVBi3RX2TnlaU0DmBxrwX3eA+nHJCIRjipmanrlM
         oqlserw2GOP+jvli8DpZIE5yieLXtil0wBWdRf3zEoQ0sN2DysvIxAOBHpUAWgbQJHHv
         wAue6NE8/67QK/16KLsYoiCRn3YIYNXZ4Lch4+ZrAS/wsr6BGrsPR/YKxKnvmGy6NF8Y
         FpJydHpcjv3OqHRwxGoi91mk3MPTI41/G2CEEz7eukxpSa46Y3vQCfU7gAjtcpMiri3g
         6aWg==
X-Forwarded-Encrypted: i=1; AJvYcCVvS9spK6pguTrwIwhEos2v89SZmrHbiLY1Ac+VhM3gz5zKlinOHKaZOlZxrHYNtO9Gq/o=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy2YY7N+GSOFeXZ4F1yB+muFDUaSq6P8bPYokRT5+LdBiAzvso
	KYh0zSyivGWulscC2pFxsT+B7PndgtUCX0oh6MGyMsBZk/lZ2IC7tDmO+rdA3eGl0JD+F6Ft/7D
	ERA==
X-Google-Smtp-Source: AGHT+IGD4KfK7NxbzN0CDzkoj/otOhDOsc4uzoW3Q6Gl7r7SokK8q8EF58+f6sfFSh2rTUNKYH1JEJ1SXg==
X-Received: from pfuf51.prod.google.com ([2002:a05:6a00:b33:b0:772:7103:df0f])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e04:b0:76b:c882:e0a
 with SMTP id d2e1a72fcca58-7723e21e636mr18372274b3a.5.1756968904663; Wed, 03
 Sep 2025 23:55:04 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:31 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-2-sagis@google.com>
Subject: [PATCH v10 01/21] KVM: selftests: Allocate pgd in virt_map() as necessary
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

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
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
2.51.0.338.gd7d06c2dae-goog


