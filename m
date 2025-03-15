Return-Path: <kvm+bounces-41133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0C0A624C6
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 918A4421855
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CA118E362;
	Sat, 15 Mar 2025 02:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36b36eS+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A218B477
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006417; cv=none; b=XknOOkhHUi+wvFQCuxT+lYvVkW8pmyeleHtQkWzJw7XVvh/uo4CdH+w2uYzzCMkFeT7OD98ndDHVpEt7TKJXsGUNLzBua4CHvmXSQn9qibVGb7XY7lpZR/CtWl42Fpb93ZbSZkznuCWSFFpTSo+2ijNZYPxrJnJilfewxJxrDVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006417; c=relaxed/simple;
	bh=U84p6SZxKcFGqIOb3edMWdKOJC3NG2/MOklZXIgpKbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qyXVcE7GqJJbt/4/3A39QcXRJD9KR6lIAsgy/98KXVWqOrbiPWFWDIGRVSAVum0PCZmhIfczbafAZHkhqxtiNjz2pZZKuNsU4oV4izGYMb5pp4KFEpojGnaaH/to7duWc2VhSKjCMttfcXC42oPMfqeqF94iqGEtbQEARpASnCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36b36eS+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so470120a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006415; x=1742611215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bMQrAPcfd3nTq7FKRl/uWgH64wo3Ilzhc0co1/LF5U0=;
        b=36b36eS+Wrm1W4zM1fRaS094HChbvPEUTq/Y+5Iez9EN6HGpBwTIY/20ADlhOpVCDT
         DN+fbeKBBglsM4OOaZ893t/VuhdyvlHhI+Yr68II9Hhm1teyhIAoMU/RRqr/Xg++nMr4
         FbqFnFAn5jEktuYJbHLX3BO1jEw8/ZpMfg1PapU8uh97z1D7VSgW/I/HiJp9qHcaZbat
         ezWmTnphzb9UpKL3T7WLF/0EXYOUmmgzUmIm1KCrPAQLzZO7KAuiDy5R1Y+alrMZwvcU
         8gowYILrflgLSWpFoBtWIbOIgkWN6cl4XUJalzssDw4yoYjMq1fkq8rOtgBWic6LRKxN
         e9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006415; x=1742611215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMQrAPcfd3nTq7FKRl/uWgH64wo3Ilzhc0co1/LF5U0=;
        b=k31bvIFc+MyGdmxGZCBs2wsNLUC5J0W29kNmw+qsZeRO/ZS0sQnyVQFBmfmEdO3OVl
         Y8yIfrtM9nGV0KNdY7y3JJ3aG+paMl7ZuzU3TbkajhSfaXgsmJi8Z4N/5pzHb96bLaCC
         gtwydgy3snRC6ArgHANNPSWRTIzhvfp0DnRZFZ4RmjKlYSyP8/JvtUcOFWV7eTIoSW/G
         yonq1/3A1ohRqyeJeGzI7UFBICj1tX121M2XAHMqY07H7cdetiwppeLkSKJS/g0wHlzY
         druafq6G/xuQ46+G0cbjrJSh+hl1vZpVw1qRjdGJibRagMdhwXe9z7QMiI+BeO/bpyw8
         ivPQ==
X-Gm-Message-State: AOJu0YxItJFp/cspD1ETW9vzRi0OD55VkItCggmO8G6hq33G7llwCYtX
	K/cAg3Qb2cgJ61T6c3ROMafGDdQgz4TXZAr41kF+Bk9aw38SriuGWV2cEfdbKFWXdL4p6viaXT0
	gKw==
X-Google-Smtp-Source: AGHT+IFb6MPgfB+uXSTMtqja083E/Cm6ACXuiGQKGyeJpKw+4RppFmo0v95KG0xwXnNHJcF8PwFt1kR+4Ms=
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:2fb:fac8:f45b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a10:b0:301:1bce:c26f
 with SMTP id 98e67ed59e1d1-30151c7a17dmr5547488a91.3.1742006415689; Fri, 14
 Mar 2025 19:40:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:40:09 -0700
In-Reply-To: <20250315024010.2360884-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315024010.2360884-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024010.2360884-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures using kzalloc()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that the size of "struct kvm" is less than 2KiB, switch back to using
kzalloc() to allocate the VM structures.  Add compile-time assertions in
vendor code to ensure the size is an order-0 allocation, i.e. to prevent
unknowingly letting the size balloon in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ead9e57446a..04e6c5604bc3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1939,7 +1939,7 @@ void kvm_x86_vendor_exit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return kzalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT);
 }
 
 #define __KVM_HAVE_ARCH_VM_FREE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..589adc5f92e0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5536,6 +5536,7 @@ static int __init svm_init(void)
 	if (r)
 		goto err_kvm_init;
 
+	BUILD_BUG_ON(get_order(sizeof(struct kvm_svm) != 0));
 	return 0;
 
 err_kvm_init:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783..01264842bf45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8755,6 +8755,7 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_kvm_init;
 
+	BUILD_BUG_ON(get_order(sizeof(struct kvm_vmx) != 0));
 	return 0;
 
 err_kvm_init:
-- 
2.49.0.rc1.451.g8f38331e32-goog


