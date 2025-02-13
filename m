Return-Path: <kvm+bounces-38087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D83C5A34D2C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 19:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36EF4188DC3B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 18:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0695924BC18;
	Thu, 13 Feb 2025 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wipzcNqm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45DB24BC0F
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469926; cv=none; b=c6ahnzfnK4yYmyB1ELD4GalUcAOlHFOKfj0BF7Wrr2+eoRef6bpOidZ58R9q0c3r0jg/vUXulN3Mo7BM2odz5pCfCqSEYlOZksUPyLALQf0sAPDHwVFWjf7sQFvp9Hc6547geejPvIv0wXJ+WSSBt2p85Couxz3jv6wF75ppcBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469926; c=relaxed/simple;
	bh=hbnkoWg3lv/YYFKHJvhomB8fITcWyPweyE8n5wrds+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/8jtjtg1eMAiyAX1FZ1d0JfAVB3AFfEaU1LZB5n8ly/LmS6IQ4QeV/bNZhViJ8c+1cpy0+YDqdCHwaqYR72BFnwsr4DnMltVd0wXXpK8MPUBFt5E769fGYaqfjObvc9wz5x1QiTe5FDMG8nMYsM+xTaNK1pfq+CEJpmd3Xpt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wipzcNqm; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d143a42980so6621215ab.2
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469923; x=1740074723; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWZgB5w3eSM0BtzO18X6A2qHryHBneRbetiSxyPOf/w=;
        b=wipzcNqmx+gDasdjqsJack+VlJBK6mYn21wTLYY5BT78x79MSC+bUhb/n8p4PR+gR/
         kA+VZ7A5Ku+gtXFWw410CYJwCWaDrgyjeM0ECVJGICL8juGGG0kDTbp/gWXG0EyYbaF8
         ikGGHCnryp3RRDsttP6tFv0y1q4eB7PBd63AEfWU3c5OvLMFEKd+lbeHOEv7I0EXyc+i
         yQFL3TaRRqDz51Sxjkxpkhqa6XzMbk/xF+yzuy95oRJuT4DEKS5Cr9RKOcQ2Y+VC4xX7
         jHXOoQwrYWhM87ZfG8pKOsvY+CIGfSkXjR01zyroYeAAFaxLkSlbEWe5PcYfykMmQ7bz
         Wymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469923; x=1740074723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWZgB5w3eSM0BtzO18X6A2qHryHBneRbetiSxyPOf/w=;
        b=cHFWvzpXCplTGGb+m44F4e6NgT2gDEcmdJk8sT6bat9YrOS87FDOxUiIJlD4L9k+us
         +YUax2EctSsHOPP4DqrgBoENdGpWjJMhnJzw+eLRrerPqNsDaS8fVaqRKaDCYgbhK2Lv
         Kkn16MS8yfAFdlIN1FsGdQ/Symf8vVup9KzNPjmYoEtPyEiXMgjSlVxQEgNWU8hTdQrS
         VO6HvV3tND1Wf/UMVNLx8QOwOZUDCqh+RptJYo/IBHDWjq/n2Cb6lIBur3VTdACZChcM
         cKs7OCSBBLxJ+j26/PxIE0YmfwUI9viymfvxlW/Q5UEr30vV3RXKlGcWGb23Hb1fgbkx
         MvIA==
X-Gm-Message-State: AOJu0Ywv4+Ny2I/JHY8X1Eo4gTYALE4dbj5sJhxSDb3UMHjMgcWek1Nh
	1H3G+mE26Zz1ndC47MEQQacsgP7rMYwEEX9i3DKpB0i1qWc0nyrQuHjcWUfojQM/ecS5q6Lf79S
	QCy+AqUqD/WmxnwriCaocRPmNN51jfhN71AYCz1Pb+JUhjse1JKg7OSH2eebI2uASqPZOMqh6S3
	/yfe+FjEyu7ZVqrccK00UlhC/6YAw24p5vMHFw0WwftAqHszyNr6kA5zQ=
X-Google-Smtp-Source: AGHT+IGInJOaRNM/UmxApk8AjirtA1Ey5wL5ojkxOBaGdRUfXbOtlN+CuOjjpt+ni2zL9WpitRvyEXXQjjs//eksWw==
X-Received: from ilbec25.prod.google.com ([2002:a05:6e02:4719:b0:3d1:8322:8ecb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:144f:b0:3d0:47cf:869c with SMTP id e9e14a558f8ab-3d18c31c4e8mr35827555ab.19.1739469923254;
 Thu, 13 Feb 2025 10:05:23 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:17 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-9-coltonlewis@google.com>
Subject: [RFC PATCH v3 8/8] KVM: arm64: selftests: Reword selftests error
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

It's possible the host has that many counters, but HPMN restricts us
from using them.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32e..b5bc18b7528d 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -609,7 +609,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  */
 static void run_error_test(uint64_t pmcr_n)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
 	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
 	destroy_vpmu_vm();
-- 
2.48.1.601.g30ceb7b040-goog


