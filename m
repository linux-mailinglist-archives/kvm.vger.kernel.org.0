Return-Path: <kvm+bounces-67538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ACED07C52
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C8EB83009D78
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261D4318EEC;
	Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ypJR0gvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f74.google.com (mail-lf1-f74.google.com [209.85.167.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0A5316909
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946955; cv=none; b=rtMXnM0rvDEXoeC6MleTT/yxnHUc1kxkuhASbb7+mvEx6V/IoeiETsnqIQZ+dR+lOSWz1FffgZG3fN2HWo4AjSnHE7B/ieJt49Hx8UpRtKswIKmlU+UPhgN3xzW+v2xD2vcCxzOHztX2CeaPILZhTuntyUPgxgIMbeCY6nyYUfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946955; c=relaxed/simple;
	bh=lFYklkr6Riz3yTMFrVODIzDh0TCEJHS01mgdHAqzi7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HFaGPdZaP+ZhBCn3UJpUtyuLXcMYNw9JsptfyErm1nkTHHZ1uHIjn1h6BUMQ0sXfnSrGzphElzKlTUlDaPLD4yQE8GRYylQlcxt7N0RFlAVWFJQS/ubqc8/+ByJa7lBy7Rrb6lsMgzAQ3aQMeP3u9D6VaIbMEy/qTeSo7tJU+i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ypJR0gvq; arc=none smtp.client-ip=209.85.167.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-lf1-f74.google.com with SMTP id 2adb3069b0e04-59b6fb01675so3440632e87.2
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946942; x=1768551742; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NqG3laPI6vEHEXOM9R+vgmhZHRmAA+/4qmyfh5dJ4MI=;
        b=ypJR0gvq1rJInbBTXVDcDnT71UsGXD02Zgpdz4hfWJJTk6cFj0vuKIa3Vcp3pWi+2K
         jgUd2jFTJ83gteF26jyGxfvN1K4SYfVExBdwToQpXVFXpEzNS+IynrRBmEQ5Nix+oiAe
         hL3VeVPh8Mx9NCYEusWL71cGjw4WlJ1ZvDDfJFdKv1ImD2OfMI/JG+NuDzZB7oAd/CVX
         3baLVO13Jp+TriXkPx/+vOpMr11z1iouDGFbguInh1WyuqGtX5bDArJiXCtRrwvVcnjY
         H/PtMB9/zn+1zbNmUpuxmQ7C9Xm/Vn9O+C5egWZYwIiRnndrGw+1C2HJSFY/umChL/b6
         gJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946942; x=1768551742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqG3laPI6vEHEXOM9R+vgmhZHRmAA+/4qmyfh5dJ4MI=;
        b=h9gOfjeGK/7xW6HUYCrj7xBvx8RkdH7UZ3yTpS/EDoF8/WwVnDqK4PortY1JVINWEz
         ffG6BFCVpcuXTnaG6PtTCvpW1DhFYNuMAfTTjyBASIJzw1X+SRf6j4WJBWkrI8tKTI/k
         BgmqCaovIYIPv3T5mLb9LtXim+t4Q+ZTleJLsb8dWJd9D8Kex1wJu8HdM+nQu3gc+Apo
         46nLuHFMdOlLJ5W6dYOsqQVFoglIMdyt7ulWFin09FqlgtB/dwyL1TWFXbnIqIt4qc1J
         t+gQkpNNgxexTo6VHJU3bH84fqNGtcDWyElKUWyB/TZN5vpnYKaq90htkoPvtyxskRKa
         avow==
X-Gm-Message-State: AOJu0YxE6KcluY/0UO1uHy+gmjDqZdSnLN19Tk4zeXTCsJRheaAEP8Rx
	thx4Y2mZrf7dC52Pu5SR+mSbhb/2B3QNFGIhmvU4toCBl2QkBJ3zqxHN25isPCU/FmUtHkGqbWu
	EisNnrp+odZzM78A4cEklrnvF2nH+eYKSivKn9Y8uhj+yxbnn7knxbbb0s+s6oeelkngqbAQn1d
	r5KiB+Y/fQj95270Vf40xLBwlO4sY=
X-Google-Smtp-Source: AGHT+IEPiBQu8APfXNA3IWNbMpdOagfDDvRFnwb8uKkQFHMSY7VPVHw12O3QIkHoI1cD4SsInszAzyQFrA==
X-Received: from ljdv18.prod.google.com ([2002:a05:651c:4212:b0:37f:dca2:6c99])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:3c8d:b0:595:81ce:ff83
 with SMTP id 2adb3069b0e04-59b6f03a0b4mr2586927e87.25.1767946941603; Fri, 09
 Jan 2026 00:22:21 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:15 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-3-tabba@google.com>
Subject: [PATCH v4 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5b379da8cb90..607a4e462984 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.52.0.457.g6b5491de43-goog


