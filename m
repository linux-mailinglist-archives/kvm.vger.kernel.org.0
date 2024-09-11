Return-Path: <kvm+bounces-26584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8399975BF7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA9381C22353
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B9C1BE240;
	Wed, 11 Sep 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hya+hz8z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2731C1BDA9F
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087363; cv=none; b=W+mnUQFhriUc9pm01OayC8rSvV7fx2DE0JaCUqe27LvSH91rf/k3UBcwtg6oiTujuo3B9ZJh3PUQQiQT5Qh6krulP2l4C9NTghpPBRFbabDma1xWjLxlr9B55lI4cz6IpctWqO8V4yeIplmTDgErI2fyMHbilfMmrGmAz7c2qYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087363; c=relaxed/simple;
	bh=hTKlj60rYtk0bD0DOzR2zSTjrZ18AZM0vgeJHBtr2dM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AIrdb2Qqm3da6Jx0NVwYSVWi+Hs1Qeu0ISUUfDYfYB7e88jlf9yxFcUbwaYVg6QAJ7j2RDXQe1OLvZeCNOROY6HLDhSHAW18E/skW/0d9VE67980UmuDwmadqche+pK9/fqNUg7jmB8E8oE2zKnkC5RM/5H9XVegMOAoPgkIOPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hya+hz8z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d8dd20d0ddso1431974a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087361; x=1726692161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5I/tJcOHFIa65Wz9gc3TwU6W0/w2a3V6j4MGXxqQ3K8=;
        b=hya+hz8zWaCit7GyLjAcudAcV87uvkS8gzBLkYr2mbeUWDxeexwuqzUNtpb3GGV8lM
         Cn5r5OGAVq3xtULHAOnIymuxAy/8Xl+vdX1urF32cai8jubjP9FoUppfMFLik+kvj5Hy
         52W5LCT/D1tDS5a8YlkUldv2/OoAyFenjAZC236+ArgSivSmr63cCfnq4MfHNOxltCr+
         cxms2ERTe1hZhz0iRNJr7VwWg+rlOy5MYx0FoGXL2owzzL+uDZUMFWLj15EHL22ihREq
         00b0OIwHNrf/ZTKJHosRxeGzbl4VjAzJJY7TCKrlERWQCmqAqfuErx5L2/YFd0Ppwnb+
         RovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087361; x=1726692161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5I/tJcOHFIa65Wz9gc3TwU6W0/w2a3V6j4MGXxqQ3K8=;
        b=YrK6EATIhtZcTZ+3czvYSluHMwBdapcvvDVuPquteNie9HdS1tVOTZ1rAURS4pQcfo
         D5kn5jST1gudKMsepAeH19zzfThL4johjD00r2N3mr1OlxHVOzXUfGxANynSoKMj9uDo
         cMrd5qRcW2BgucV486UtuBh+Z9mEJEar73omtUwTzAzT+/5/Lwor7VkPz+okwOlABzeh
         lHneVVYMvPysC+ftuEF8Gb/LTb4rvnWFELGgmV2lnEoU+6GLVYUELCcZEsBricIODhNu
         xILyotjtE4U3oQDSbWo7zguKIQkkCn7McLNP8O30VgCIRPqgtbvkNv5NxjX6Bxb7KiEi
         pyRA==
X-Forwarded-Encrypted: i=1; AJvYcCW7Td8mSLIeu6OI5Qv+vYk1BdPMyfPB4pLFqLchuYWI7h3KYuc2TGCgYFVRXNkDT+TGtBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3ildE8W6D8uBwvMwgQ9p2OLkFe/UYmC/TZIJLBL+IwLdj9rQ+
	iw6MTqYSkhTBefCHOsqijWd+BAdbhmoccmQIdZDsSiBzhrwRL8vy66bzVXLUlNXM0Koum3IqsMb
	Zng==
X-Google-Smtp-Source: AGHT+IFOw2zNAqVhdCkeZdNi5IKOGHn5wgnynX/KErJqxVULBd4txDltmiT4cacd3crmvx8FKohy/M+nAhA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6fa6:b0:2d3:b1af:ae48 with SMTP id
 98e67ed59e1d1-2db9fcb47f3mr17342a91.2.1726087361313; Wed, 11 Sep 2024
 13:42:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:55 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-11-seanjc@google.com>
Subject: [PATCH v2 10/13] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 5467b12f5903..80863e8290db 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -22,7 +22,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.46.0.598.g6f2099f65c-goog


