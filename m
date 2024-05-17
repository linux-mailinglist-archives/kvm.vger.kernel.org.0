Return-Path: <kvm+bounces-17691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE378C8B9D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF0561C21392
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FBB4157E9F;
	Fri, 17 May 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FvrM72hR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E8A157473
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967660; cv=none; b=ROuItsKwnVffHdQaKWCNc2mXpN7MxOMS+ppSAGAftzaCZLy5ghMvnmjezUOKFYjGVOW1k2au5OORzdQ7F8qFYYp55PRXX2apEjm/6ZRxtwOd6r8xbvYNQDtpSNfeXG7wB8G3c5QqtDWYfkfH7wiHNlZ4dRj3GWCEAnMIeA7tJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967660; c=relaxed/simple;
	bh=Cay94HGTWkCzW13eekg17Dn31y1awAvnR4+4hGNuRyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVqqbvOWffTpUZRcdBdqDed7/T+2mrtCJ5jma+D5CMa6BtumeAkNBxyB1XkahAwssjDZDax56jM+wYH5GfZa1YmWONoamBw8XfAKSwBA8BDSuvVdG8oOSvmn9asR82CX3yPx0e/TeATehM3R8f5BiHfIzkEY7f2+AwjERUu1QMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FvrM72hR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so13449577276.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967657; x=1716572457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WUhNdB9iIqzolqucVtWTAnagZOY7Bg6qZcQz9vFUY2A=;
        b=FvrM72hRN10JnzzFU2byT4KjiuE8GSzH5W4rV7WdvMX5fkuO4q6nZZ9+dpKB4LPS7V
         a702gWXPOWyiqLXaMOtDl7BROReWuRV76Iez9cEMWg6nYFW/y6rOb83u7tRVSLW7swv4
         YQCVftglVElFz2eKxySCa2mKYOfq+cwslaNGybKabWKxNJPufeUFQHJnG3syAuR6laTF
         qxQRDSzrfd4FTjxPoTqdnIPUNlYr+wDTYCKgMJHYBDTIREcZsJajSCxQD7wpfDHxX71I
         hIsrmoNsKSRJWyHW3pObJIpucI6zO89DRS3+rwyU3vv3jANavajrinLorrkZntqYnqo4
         stEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967657; x=1716572457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUhNdB9iIqzolqucVtWTAnagZOY7Bg6qZcQz9vFUY2A=;
        b=kR/rWnlo1CTfz4bu27K9hyCFaK5fon/jJCMbwa9ryyhnvtdCLlHElzcsluzCXVysd4
         mSPajsLtfCLm+wSOfRtqvqozQHpDoAoAZe9l4pwjE24wX7h1YAYs1O4xBFWPSh6Dq197
         xhaPQYWe2FGMRYRZJBx43njbe+8Bm5PNyJYVavbeZF8jTihl7MzPtFxWBZWiXLr88JdK
         3ft2CuhB8aBCOUIXI62WZ+IvN3HgvWr78FfJWWR0NItbCGYtzyipy6p7/sS8x0XzFmWv
         aw1OkMYX3BT60GAQMstT5B+oy80MD5JCp9oilasfu41zTgJ+wuOOforlsVRIGK6RdSbe
         o+Qg==
X-Gm-Message-State: AOJu0Yx5fFWmYiCvVnY+Em+f1oKWvSKe/4b10mDI+0+mc0YtMDpDnbad
	/31SIge4A88aBYaX8M3MNAq+Ik1qhY1XzXA1wuLZm97H6kUki1Ffosn9+eDD8OcfEfANOwYQ2BR
	tsw==
X-Google-Smtp-Source: AGHT+IFTPW0Wk1n6XlZB5IqAqWVV2h1MhuwZJjgg+6IrPpL1gJ4VNQ4RI3DWEO/Zf6NkYtQyC5efPJOIdJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d353:0:b0:de8:ac4a:1bce with SMTP id
 3f1490d57ef6-dee4f3210b7mr5483067276.13.1715967657453; Fri, 17 May 2024
 10:40:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:16 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-40-seanjc@google.com>
Subject: [PATCH v2 39/49] KVM: x86: Extract code for generating per-entry
 emulated CPUID information
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Extract the meat of __do_cpuid_func_emulated() into a separate helper,
cpuid_func_emulated(), so that cpuid_func_emulated() can be used with a
single CPUID entry.  This will allow marking emulated features as fully
supported in the guest cpu_caps without needing to hardcode the set of
emulated features in multiple locations.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd725cbbcce5..d1849fe874ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1007,14 +1007,10 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	return entry;
 }
 
-static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
+static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
 {
-	struct kvm_cpuid_entry2 *entry;
+	memset(entry, 0, sizeof(*entry));
 
-	if (array->nent >= array->maxnent)
-		return -E2BIG;
-
-	entry = &array->entries[array->nent];
 	entry->function = func;
 	entry->index = 0;
 	entry->flags = 0;
@@ -1022,23 +1018,27 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	switch (func) {
 	case 0:
 		entry->eax = 7;
-		++array->nent;
-		break;
+		return 1;
 	case 1:
 		entry->ecx = F(MOVBE);
-		++array->nent;
-		break;
+		return 1;
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		entry->eax = 0;
 		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 			entry->ecx = F(RDPID);
-		++array->nent;
-		break;
+		return 1;
 	default:
-		break;
+		return 0;
 	}
+}
 
+static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
+{
+	if (array->nent >= array->maxnent)
+		return -E2BIG;
+
+	array->nent += cpuid_func_emulated(&array->entries[array->nent], func);
 	return 0;
 }
 
-- 
2.45.0.215.g3402c0e53f-goog


