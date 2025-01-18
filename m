Return-Path: <kvm+bounces-35898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BAFCA15A55
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6540C3A9638
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E42339AEB;
	Sat, 18 Jan 2025 00:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TnztHx5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5AEEA8
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160501; cv=none; b=BP+fX2QDecHeW6D6AL3RTMyR5GhxmOcVtvILxfaDopc0UFTxGyM0tIPRPVtSnwJ/5iEofekN3KH+6if6lO90aG8bFcXDBKZ7gqxIbwjk9j1kTvRWMN8CLZzjYnlxwnRsdd0e4sVdMRe8ruqEkOys9dhDhXFjNyXXBv5SdQbP3+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160501; c=relaxed/simple;
	bh=3gXol23ksU6JtuPr+Jw5wqjRwQCBtE1n0YCNiBf6ZKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jdJMaQ6aG7NWSmgAUK+6hw3jOYOza5x5qECF33vGG4XUxt/0/tNthvNZ1KFSJURpDSi9hTo5zR8U9n6yolJcpmCB/M3oj/iC1Ppj9o5zQLvSd7yQubqrT1RUNZXuOUejEEONP8I4ivBQb436mXuOK6lG4J5E+RQK3ek82nsM8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TnztHx5L; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so7370780a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160499; x=1737765299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x0SpMfbtuEd6NqDuUr8ZNIHs/tJYq4zVu8fned3kIyQ=;
        b=TnztHx5LeskfwOnHnrMdzIpCqIT05XEF24TyeEbRqz0YmvudVAO0hJjLu6Y/I9JlMy
         2yDcHFq3PrZdX8oxyGqkkzKAxvIl52NCp4MHhuzO84Bh6ORd+p/c/SSD7OIDPIEsO6yl
         lnTlDPke3NOJSI3pnX2iqUe2v+83UKR+PdqKx14wicuPh1UYOUczlgdTj6FrxaX719jf
         h+8PBZgHr6O1UQnuf06Y9aAKupkamWKwg33eljfm8ah1z1CNeW8fcHZ5t/xNDsJZvF2D
         rP2g0XuFY4K+IO1vPiJDJODpUuJ0T5crxh4ZP0RWYMPgGPUVtgzS04a/fk++S3wFprlI
         R5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160499; x=1737765299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0SpMfbtuEd6NqDuUr8ZNIHs/tJYq4zVu8fned3kIyQ=;
        b=gSo8XlOqtIo1FZdaCd25Pii9eSkNWXn31Mmpf8McIeT8G7fNg7DIHWq/uR+5/aP7I4
         o2PlY7rMUVTnPGug0E0W32gTqGU1MIEsqmcKKNqhpjn3H/bfdXxEAvxxiMub5sRLC8xp
         68Xqk6A8gxKIvxPJ7A4KF9nH4YVCjxvkCHzOk5E41Y1bZJWzIn7zY3bR6qd5euR/OViQ
         VzuHKGlS+uybA77koR4z0JOR2ZinffYY3WpOk7vmBcgIpaJBJEqBeHvx8xF0yJNN2/L0
         OXRbkYW+IOqaGPj1oLWJMIgZBMH88Bioz1XaECC/1wIgN8q5CJdUcN1yqmvxzFNtppCC
         ZgDg==
X-Gm-Message-State: AOJu0YxifJQWDsT8rbwJ0KTkaKfdmRcYhdTSRxfIimLIgSsf9mryPr9t
	G27SXyAwHBWVKOtfGAE/rrvGr6WZlk6CQ7rD4gDEy58R569al3m8t4uAiMeFlsrvNDIK3lnlTsW
	aOw==
X-Google-Smtp-Source: AGHT+IE3Wt6yS/kbMTrKenM344NMz8PKtKuVuj/WIjxML6HUjTE3l4fOSrMgi5dj9FLjUxwJCF5Kbm4FO3M=
X-Received: from pfbcg12.prod.google.com ([2002:a05:6a00:290c:b0:72d:b526:23ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a883:b0:725:ab14:6249
 with SMTP id d2e1a72fcca58-72daf9beb73mr7702048b3a.2.1737160499666; Fri, 17
 Jan 2025 16:34:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:34:52 -0800
In-Reply-To: <20250118003454.2619573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118003454.2619573-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: selftests: Mark test_hv_cpuid_e2big() static in
 Hyper-V CPUID test
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Make the Hyper-V CPUID test's local helper test_hv_cpuid_e2big() static,
it's not used outside of the test (and isn't intended to be).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 4f5881d4ef66..9a0fcc713350 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -111,7 +111,7 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
 	}
 }
 
-void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 cpuid = {.nent = 0};
 	int ret;
-- 
2.48.0.rc2.279.g1de40edade-goog


