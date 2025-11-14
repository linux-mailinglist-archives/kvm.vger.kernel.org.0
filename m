Return-Path: <kvm+bounces-63133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E14C5ABAE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F0E15354319
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC99E22FE0D;
	Fri, 14 Nov 2025 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+K5mbli"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809A02236F2
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079194; cv=none; b=IbEOj4VdhymUwPUoY5RBuE6S0Pv4pnkEVk3GxsNW77ne7itu0FaPk4DTRKo2KxrAfNZuIYjYW/AqeFNinnSRdtt3TeoFwj16vsQfrR31jQirpnkSCw5VwtlGn5trLrAh+eLFCVY3c/OIXgvLZ76PRbN0WK1a+R0MUwnVk7dOJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079194; c=relaxed/simple;
	bh=PL3Qhn7iqi/F3cJTiDIoK+i7tq0WNOMmbjMemBAGU5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T8rGOuuFd8oWkLr4NDrmj37ud4BcBndDjH4nGoi/y2JnodyG8G6Mcj1CJI3+rgwhCA9NCcbWTGJHJ5XWXvySsboUcy78VQd3iAtLIMX0+xaKydyX9Pu59mCQt1vSA1J7b/U/w10vgtZ04Uplrp/f95RILQJgrA5szOqjiJr7qOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+K5mbli; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b80de683efso2818212b3a.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079193; x=1763683993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AlrJv6PsuPgoMU2zaUNJTWd5rKIuTNoQ9zZEmw0g4i8=;
        b=h+K5mbliZtV48NwqivkTB7eLzq2hfTYjfZWk07EgvZXRCoAR47KO/t4TH866RWnoYj
         hQo6lBwrh8Zw28t9504Ix2c60Kdrh72g61h5rFxC26NC55JS8i8HKJwuvGs1jfsbRipA
         8Wy3LuTvr1SOL3oFb+TwpSMc2h0BJJftdXJzwv+59A7vce25PyRC+avKaTKMPFwtGSds
         Xr/t0sFFye4MGWZTAlMrszPOqOP+73iVUk2H7KQCOPiwr/q54puXNZL+Fm1ZW2bWrAkh
         rGRjxNmXQqfkp7iCSKTvyBlwU44uLqTpoHx0vTE7KvYyblf7bjVXEDe1xqx4wwoxQEKb
         Oc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079193; x=1763683993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlrJv6PsuPgoMU2zaUNJTWd5rKIuTNoQ9zZEmw0g4i8=;
        b=hrPOHBWX54AN0OPpuuiPWQ34FBHdrA548lXvr816crd30/6afP6LyazTZswbEbNmZO
         GELVjY8nY61F/nJ52pKY7pyevlVhz8i5ILf33wdZMWg5dO/9Ro7jyYvVPlckbKeA6Q0u
         6itx5+bUwI+BJbV/E4Q/ps3A0F0nKIqZGR1maPdLKFdKTbPbYWBmL3rfrBDz8Ie0ZMz+
         CE029lcwTU/c9Ktf36MiXhNVB01g6cjSrNxg8KETWgW24a5Pe3c6gu142abbWEQQ5TI0
         HT/vGaxpKbukUjkUGYuQxGqHyjiSJlsMHQKra3e4H/XhQPN7bIpjuCBa9zIbOWA88/27
         Mo+w==
X-Gm-Message-State: AOJu0YxERV8HXUxbBoSuscIp5xuMBLpa3dxs76qGY9F5yQ2kA2JhYgsi
	lQLhUjNuvRaQae6r4ITLPS0J0ZNEreZDj+S34bp+edrgnn/H+xkn7SZwz4T/gYDL93tak3Bk20+
	xGNj2gw==
X-Google-Smtp-Source: AGHT+IFb3k6uPfeU14k1uBHTXBwUr50SK27oeBh3kc6eIgEd//VSIwtIHClAKwLnITgKJN2mgLxA2KxsMXM=
X-Received: from pfwy4.prod.google.com ([2002:a05:6a00:1c84:b0:7b8:fc17:3960])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3290:b0:2ca:1b5:9d45
 with SMTP id adf61e73a8af0-35ba17ad16cmr1737350637.32.1763079192700; Thu, 13
 Nov 2025 16:13:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:48 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 07/17] x86: cet: Drop unnecessary casting
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

cet_shstk_func() and cet_ibt_func() have the same type as usermode_func.
So, remove the unnecessary casting.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[mks: make the types really equal by using uint64_t]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index d6ca5dd8..8c2cf8c6 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,7 +8,7 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static u64 cet_shstk_func(void)
+static uint64_t cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
 
@@ -31,7 +31,7 @@ static u64 cet_shstk_func(void)
 	return 0;
 }
 
-static u64 cet_ibt_func(void)
+static uint64_t cet_ibt_func(void)
 {
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
@@ -93,13 +93,13 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.52.0.rc1.455.g30608eb744-goog


