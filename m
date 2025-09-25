Return-Path: <kvm+bounces-58790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58153BA0D8B
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B8B96C1538
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78376311C10;
	Thu, 25 Sep 2025 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZyiVtvmK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4E030FF36
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821344; cv=none; b=qFbrjnCwnnbBwqKyYF1bH+b+RYSI/YbB+y+wVLlE/OL/1ym7l4AANU6fR4f1fSswLfpf74WnU48Luj9txHco0nWQeGsN0xyYTh3qZzs8VkuhSAf8d/u3MlO/X9ws6HxImsWfn+J4kUPouVoLrSCTa49PwL3W81LsxYm913rsijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821344; c=relaxed/simple;
	bh=PuuZvAh1tDY0QCSwBSanimRBMOrq8kLY5IMjjWh+8co=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TkGNsTHB4RujHVIMpmkLpyLqVVXYj4TVjGIf4zMiavfL0zhd8QupXvfWrlNVj6BPJzaAuz8x7kv8/CgdiUcomhRJv0WIEPKiAXYPE0fSdog8r+wt6Zrp4Ss1bzmLThEKqOhYpkwMze5qHo0svF3V51JIHz8pHXVtlZgTGwbE6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZyiVtvmK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so2029064a91.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821342; x=1759426142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXlB8+SSRRplw/eMnY6X9cuqM5T51OD1clP8ffUYU5E=;
        b=ZyiVtvmKANal6bGC3Ztv4gWESw+3V4YSQ+gwYEjGZXBvJ0aC21kVqANg59iJ95Tsg1
         dhAY6Bf4UL9/inCILdSxP6gSvbMkq1ueEPtUvaientSuofkK4GFH+Di0bafAn0cYHRi2
         WcmegnjuLzpDOG2zsNSEZCtpyo8kVlif5wd+REUG2087kferzcOdVpKOY2Zy1o3BtziB
         uZr8+WuHxTfNfL6cc5yS7m1cmRgHoy6t69W8Jdt4QUNkiFTPFvQ3jctSt4KANh2DC5Sg
         EJBCeDsgJUvALpPH5sm5uBD1+uYUJIYD9NH6NGKka54JdmSsfSzoslNDxYIZXm+XPqyx
         f+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821342; x=1759426142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXlB8+SSRRplw/eMnY6X9cuqM5T51OD1clP8ffUYU5E=;
        b=f3Kyo+JV+SPW5UuciPpyA9bAC9n23XUt4grnIQXeTmUA7YvByD09je1oNhdjBXKf5W
         qSkt+2Y6uCocfAZD71W1kIie8ZchCNLd63gsk0Xeune/jG/4s4/PfeOQ6k8wIoLe/eTc
         xuQizU0dGZe+uV3jjX38BkrDmX93pG5yXubHtC2C/l8gY4H71ItrN4k0WsaoV47wKDRq
         zHv0PzwwaZuIKXLGcHZsOo6LGx3fZPKDkNSSuUg4EN7Mzf6ElriAJLJfxgy0VJrA6O4T
         gU2YaX98zaAZLjLuHSJmzs+5pEjmD8/gkPacu5lLhILiukpLH8dPbbofObk8OVPCSAjX
         m9Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVq++iIR0QHcWXIvcxG2qOyiWWguptyeCx3JaNVYsNf4GTAWlgjh0wDDHzZM22ydrcPdWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCfImKSMbrJuszTrJtzgBVMERZ1tV4wfME44AdcyG9rqukQatV
	g23tunLwV9Tj0+F4dJlkJITPTudMNP5gcvsqlx5kxljciEulSMJxppXr3GR43ocbHSV72IDSLGK
	gnA==
X-Google-Smtp-Source: AGHT+IEZzGQjlcer4TtgJJyp6W2h4duZ2REhE76+yEr5JrO7LsVNgHPdNsMEIaC4XzQAmGY4FsHHPQDEzw==
X-Received: from pjbgb5.prod.google.com ([2002:a17:90b:605:b0:327:dc48:1406])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b8c:b0:32e:7270:949c
 with SMTP id 98e67ed59e1d1-3342a30798emr4459374a91.35.1758821342275; Thu, 25
 Sep 2025 10:29:02 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:29 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-2-sagis@google.com>
Subject: [PATCH v11 01/21] KVM: selftests: Allocate pgd in virt_map() as necessary
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
2.51.0.536.g15c5d4f767-goog


