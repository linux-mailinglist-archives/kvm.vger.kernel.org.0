Return-Path: <kvm+bounces-48442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 376F5ACE46C
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E7321897295
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192A920D4E2;
	Wed,  4 Jun 2025 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lymUixuI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9731FECAF
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062197; cv=none; b=ClGZ1AQMPRG/KoxDMLEEQSkeJNrJ2a1d16eMrMKRcIgiRmR8TxcF3XqHTBtDaaU0x85HJ3b6ht+0KyZiaGgEqyXHKLYCKxybQr+idHeOe1IyOJ9LkkCfM3Y0r5AD5gFgq+GahwQ0W8B/LRBAcvMGlmPaPby14C9AWSpgda6udyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062197; c=relaxed/simple;
	bh=jbc+l8e1U+zDBO6NeaKiwsB3CSymxGCVCerhoPOSYO8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rX/myDopy+q81v3PnS+vqawABQyKgs7iPJgMIEdkYV7k3Rn7OTeEJWFT6bGSOO6SqtlNXEKB7GAPRVUvs3oU0bDU4cDMgoJQ5uVDTwZi/I4GGAmRHvBkE0b1PJ2t9sU9jk6fJ5eSJOYak9+wpGgrZbIycAoqU7zNWOIipfRt6F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lymUixuI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2ede156ec4so111776a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062195; x=1749666995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JDJq5zGEs0owZAhl4h5+DdYH5qR4x6JsprsuFGCgTPw=;
        b=lymUixuIui1ZB+ZlexdMJYwKsRs2SVmIE4NtBSMYzSVO16XlxrBOWoU7AyCPfebYcV
         Lq2wZketZMcppmoJiBzF4PBWwvpI3G2jezKm7w7zPg9r+lPX3agpsIWLzAPh+Ahhe5dv
         huTipjcxRmI545A6w6ajMUwfbXCRilc/C1p0t6hvSgB2obVmXDh6e41gLrbBfvb9GuRe
         Bcp/I6aPea/v4Kfcsa6TPdWrbsCC+MsTtwPfZNvPfn0azx5WmXld4n4S4y6jKmU2DXIR
         cH5PM7uulIBCJdy3n/s/HlpdZJPKNQQgMYek6sVZfYL+4s84oFYEYAjn55A5jEwmKfG6
         kN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062195; x=1749666995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JDJq5zGEs0owZAhl4h5+DdYH5qR4x6JsprsuFGCgTPw=;
        b=gRV73ZhMuwgDUBb3zoZW3nXdlk8eK6lphyGbEky+QXWeg6KROAHyXcaoJTrDsCt1oB
         /o0qS+RNzSJIKjR3RTgpWAL40F32fpbRIHc3dVzMeqQ0uxaxLySlSLWmDsOv+6xIpIWW
         P0dI8it3Ls22spynlbdvBzRP5VV/6WMmOX2h+6tx1QPtauh74JYYVqA3z/DVhhn+kzXA
         nEz4UWiTWvsqNMrP4dprR9R5hd5a2319TNH8d2Wjky1O0wzurfVFwaIYf/fHDft6gfBe
         Fgrg2YucA7ymjBEifkINUnwxP2+C8LYEdlI7a9Yb9BqDooIZyGJ88E+am6jSeYGH8rWF
         f0Mg==
X-Gm-Message-State: AOJu0Yw2ZFGrsbk2eXtIv1/Zr4HBQLDFPaSri+jxojhsiB88ezMpezqF
	Y4JTZT2yNPQJ94jNbpacVWZXGJrrKacbBa7gvOmd0V9Qfw53rx/Vxyxgol6awN25JewMU0Oiz+r
	o/PtYUQ==
X-Google-Smtp-Source: AGHT+IFTs58HANKy0xsDxT7XvYJrfQy4m+3waWvJVs2qa1L3IUsgyE6Odg47thu97U8XTMhVcnUOmqQPbKk=
X-Received: from pgbcr3.prod.google.com ([2002:a05:6a02:4103:b0:b2c:3d70:9c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9f8b:b0:214:f8b1:e385
 with SMTP id adf61e73a8af0-21d22aa2f5bmr6404245637.2.1749062195150; Wed, 04
 Jun 2025 11:36:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:23 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 6/6] nVMX: Force emulation of LGDT/LIDT in iff
 FEP is available
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Force emulation of LGDT/LIDT in the canonical host values test if and only
if forced emulation is available, otherwise the resulting #UD will result
in failures.

Note, use of the cached is_fep_available is critical for the LIDT test as
the "slow" check for FEP support requires being able to eat a #UD, i.e.
would fail when the current IDT is garbage (loaded with one of the
arbitrary canonical test values).

Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2f178227..2cc6d5a5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10881,12 +10881,13 @@ static int set_host_value(u64 vmcs_field, u64 value)
 	case HOST_BASE_GDTR:
 		sgdt(&dt_ptr);
 		dt_ptr.base = value;
-		lgdt(&dt_ptr);
-		return lgdt_fep_safe(&dt_ptr);
+		return is_fep_available ? lgdt_fep_safe(&dt_ptr) :
+					  lgdt_safe(&dt_ptr);
 	case HOST_BASE_IDTR:
 		sidt(&dt_ptr);
 		dt_ptr.base = value;
-		return lidt_fep_safe(&dt_ptr);
+		return is_fep_available ? lidt_fep_safe(&dt_ptr) :
+					  lidt_safe(&dt_ptr);
 	case HOST_BASE_TR:
 		/* Set the base and clear the busy bit */
 		set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);
-- 
2.49.0.1266.g31b7d2e469-goog


