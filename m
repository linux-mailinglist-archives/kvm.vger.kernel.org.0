Return-Path: <kvm+bounces-66872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 337DBCEAD14
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4469830351E3
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5412E22BD;
	Tue, 30 Dec 2025 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1AFyCcnW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D48286425
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135717; cv=none; b=Nx0T4P8ZdEtKK7ZIFUsLQ9bZ9YJufkeH6xrNkx5w6KavdwNMBn9hJVkMqS2hKXYj5N6jWuaiBgZUDlQakkKZ/W6+RXhFhZrsuBVqTAJORRm/k7B3y2KJ6EmtYcfk508cPBtRQhUFriSOWGQ59axWuXyeKT+8BZAcEaWlCTQYGw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135717; c=relaxed/simple;
	bh=Kg4SWKOUtIjisFIyNIjWRo8qDsjuJqrQPq7nPM7bE2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ktvcEU86NbBwSx3ha0BoQGCNTcaJ0TrqVqaPnW6hOdMQCcAYSISCIp4E7sW+LEwLLBSpFNJr+Ybx1a0k0FyOz53mRkFka9q0A8/Isg2y2oT3piGU6041MsEY5yZvsz0Hwtd4GFDrJMxuRHf2iZFKW7jwJmDDmrxJKDst9ZK63rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1AFyCcnW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c387d3eb6so9527454a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135714; x=1767740514; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DRWkfiIT0OBRt/HR5AGE/0OZHtoELcBJ5J9uDz4mIeY=;
        b=1AFyCcnWvtFlecobYpYDNrC122F47kVzq3K01cHvCqxd2FcLlPqGmNDTPFFb8jlp/E
         DkSdd3NSyyPUSySlS7I3Wo8uXorvFymP4lcl/tNqpCRmanPsqQIr+qd1RnpdiL2fGefI
         iWjdWA0l62C9fUO888JbImnz/Ner9dr2KbKWRN53bMKiDfFfRJ6APvK6UhApBxyjyN/s
         c3lbDV5AMFKZq1eIxxy7QLg/SWMcldALCTonYL0PxQ6bAa6WDFfNLlA5TK+XnK/+e82f
         YbV41UoGIo9XdV+Bjbl0ULyzq7RTaWXlbtUqCbKUoWgEuxrPWoYsdrtUeBiflJSLXiyX
         EL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135714; x=1767740514;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DRWkfiIT0OBRt/HR5AGE/0OZHtoELcBJ5J9uDz4mIeY=;
        b=rehkLNZ0dhyyugV+iuIpeCL6cBO8WQqGKoO8Nrvw7IWDo4/33Q87OV4s2UPVW6++Ho
         qaSBa+LnQ0Bz7BB0CtWkDbC8B8lHmYcCOQpKUCxaNzD4y+YkdlTW4vYomSlDysFyrrq8
         XBq2vTmDv7BWwmMQFO6LkxyaXVowVY/tB+mbvUAjZCbjfyB+RPQnlYmGom7c67KuP74i
         OdBqrJKk62imVQDFDpgLgQ3yCxUMbR/dpHy5Zym0UCnOvHa/qd5QtActBHJbudi/mB+B
         /y0i6zjhme8bcN9C22zcJniquuKL909gOP0PiD86ufyN/20Wafd01JcoK29eRd+spoEq
         lhBQ==
X-Gm-Message-State: AOJu0YxA7Nf2nZWdtlM7HJZQQ4lrQeQec4eY84+vB/ECcYN/3p7kiMem
	rdbTMQeDud5JInmy9LoiAcTsOqdWIZ1md5sxX8EzBvXB/AdPVAMN+zkG/35qoJmVjhJfUgGIOTl
	5MbfKMA==
X-Google-Smtp-Source: AGHT+IFqovkU/eUlOykY6HWolLjXCahq1FJtAZ+GEK7lClBpAjuVhdcXVPtQL/MTMKhhYaxAhrGpJ6Ohw/A=
X-Received: from pjmm16.prod.google.com ([2002:a17:90b:5810:b0:34b:fe89:512c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f47:b0:34c:3501:d118
 with SMTP id 98e67ed59e1d1-34e9211d455mr26888073a91.1.1767135714342; Tue, 30
 Dec 2025 15:01:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:30 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-2-seanjc@google.com>
Subject: [PATCH v4 01/21] KVM: selftests: Make __vm_get_page_table_entry() static
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

The function is only used in processor.c, drop the declaration in
processor.h and make it static.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 2 --
 tools/testing/selftests/kvm/lib/x86/processor.c     | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..c00c0fbe62cd 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1367,8 +1367,6 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 36104d27f3d9..c14bf2b5f28f 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -306,8 +306,8 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level)
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+					   int *level)
 {
 	int va_width = 12 + (vm->pgtable_levels) * 9;
 	uint64_t *pte = &vm->pgd;
-- 
2.52.0.351.gbe84eed79e-goog


