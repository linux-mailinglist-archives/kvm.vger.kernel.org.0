Return-Path: <kvm+bounces-23760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5EE94D6DD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D0A91F222A1
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE97E1991C6;
	Fri,  9 Aug 2024 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gC/un9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C761990C4
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230226; cv=none; b=IQsKRnH5iJ9BiYjp7Hp2rE2bLTjgma9FeDoIzvcPFj55p25Ku9T2BnpeET9sEJnTVDb/cukRrxcWX38lOuaQBxu39vi7cPv2P/GxsEgD6yA0m39oSIx/+XxEY0Y0jinmZOaNUOz12rhXneKDJgFWehjcHkxFLI3/q2qqK4S37aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230226; c=relaxed/simple;
	bh=yFBflmyh8QZBoiRzx8kLH3cDwLhEcq2bi6TGRbUHykE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=grX+VB4Uo2XNElYbrJJcdQwx0c0jnheeZhN+i9oZFctHhhK9WqYnW0f6o0bw/Sh31ApDI0qTLbX0HpLfytHTqEf0bebR/qgMxniUSCl/kuoWjKcBmkV3dfqRC6ZiqvvVYRSKjNW5p7CK/KZMYV18NY2LKN/eOm9ZrhZ4qCL7kxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gC/un9b; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70f0a00eb16so2143619b3a.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230224; x=1723835024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dpThAu81+XUaVEIhWdG34RqJeDJX1In8gD4UvwvDbc0=;
        b=3gC/un9bqirfM3RGD3v3jM7gptwynDEfbIfTwpGFigTG0DRsC/mIrR+hCATCfNiSCT
         YTvDUajzVi6VlZzJFTmLiZLsh0ZRfAt8RyJYlmKJJBQA/tqe4bsTetWlB1r6PWHzZ/M2
         FE75/1jRldImmy0r8Ss4yIEsH9aXKy1ALMSdSjhG2M+swWYSCi+I6g7sR9C8prLeGfHs
         g8TK7Xu5H4r9JknXKrPclC/D1YJUMAovBw5IN24lfEUe6DuDUIwRfoGBulthFXzKK4dC
         aLEy+J/avsEBUrTMZW9WVfvDIPViDAGGOAQc3iUWJNgGmScAkt0P7VHs36jYiN+G5tzU
         7OsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230224; x=1723835024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpThAu81+XUaVEIhWdG34RqJeDJX1In8gD4UvwvDbc0=;
        b=uv51MxphUN3TYJDWosKAebvf18/gRz1ll4S6PIQT2okcq9FNV8LfMcgHSdFdxxh/K2
         ft/ccDDT1rpNAtYkg6ApbK67obkXQNgiutt+qdppbrD2ZqyMtrvd0PsAJX+WpYELSCLX
         F6zdVTX31oCUM3/QwOmTJ4VAXkPvWfDkWqvxf8e3vHtRr7N611HkRFh9AmdwkkyqqP9R
         a4aXSt/qYaMAtHkKG/cCG3pef+eujEn25VNSBz+KxsrQX2ann19o6gmaSsgjbznEWvt7
         lAHNI1ZmviVbfZWfgELMHT8EJrUwlDfkF3qHWmL2jGmd/aKrr6vLZNGEfmqcxBET+932
         udKw==
X-Gm-Message-State: AOJu0YwJxSKsWVmlC+yGz/M0mDGYoDhYiFhTZyEkYaLSnU4OjQXP24MD
	BJFIr0fZgeIsbp4e1+rz8K0N+4hco5wMhxjNhJd24i/xqq9W2B0UQBl3pIChPnZXhNk+Pe+zrwx
	d8A==
X-Google-Smtp-Source: AGHT+IEfQ8yvNuIaJdiTz+V3/PCjs/k37b1h4YSYcKmGqEYlmGjeaAnHP/jSzt4t2a2FLDINbWuuKtX0WoQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f5c:b0:70e:9de1:992e with SMTP id
 d2e1a72fcca58-710dc629036mr28643b3a.1.1723230223713; Fri, 09 Aug 2024
 12:03:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:06 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-10-seanjc@google.com>
Subject: [PATCH 09/22] KVM: x86/mmu: Try "unprotect for retry" iff there are
 indirect SPs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Try to unprotect shadow pages if and only if indirect_shadow_pages is non-
zero, i.e. iff there is at least one protected such shadow page.  Pre-
checking indirect_shadow_pages avoids taking mmu_lock for write when the
gfn is write-protected by a third party, i.e. not for KVM shadow paging,
and in the *extremely* unlikely case that a different task has already
unprotected the last shadow page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09a42dc1fe5a..358294889baa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2736,6 +2736,9 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
 	gpa_t gpa = cr2_or_gpa;
 	bool r;
 
+	if (!vcpu->kvm->arch.indirect_shadow_pages)
+		return false;
+
 	if (!vcpu->arch.mmu->root_role.direct)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
-- 
2.46.0.76.ge559c4bf1a-goog


