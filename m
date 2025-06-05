Return-Path: <kvm+bounces-48601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA0DACF7EF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6170178E3E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EA527F4C7;
	Thu,  5 Jun 2025 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BnCe6vAB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7711327A915
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151612; cv=none; b=N/9D9kugtQqBgB92jxGpcUMuwMfAUy8yUJi7mJYgt05bMtpr4sYOyBY+7tdBsqWX82BonIGnOHVJTL+A8SdfK/i/l+DL+m+396/1jG7tZZ/h/v+jy58N1NPjVPFtctqCTNuZrgFgV356+8abrgxaBHD9vpWNpi5hAZ8MaNXTyQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151612; c=relaxed/simple;
	bh=Ldh85BgJ0A1afvctSSf+zPz3zkjpZenbE5dxtMe/boE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bzgHtpkL6sZpa7N0kPuQRL5yz5GODZPdzrG0WwdyLAG1KB55jLvhx9qY31UxY8HrOt3ieQDSBxRKTh12gdyiUik7Aiy3QXH89aPbUAGfsT6Xj2xrO6hR1vNLlXzYwB5Wgysx1V3u3Scyd+85E9wNzmERp8Cbdwv2UBFyieoqk6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BnCe6vAB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31315427249so1271675a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151610; x=1749756410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AhNF2QJ/6sIWLymqGUc5VaB6vyzF7wr8RyImSXcNFFI=;
        b=BnCe6vABXPLcuegKanGyppWBJungSzah1L9bD8tX2amHwRHBUjWmmwtVdXGbgDXJrb
         HsvI/ov9m2QzGENssW0KkwZ/7DEwd8eZiovxXVkG7YtWft0ULbLYER7mmIAFz7hkbx9Z
         ssxrU7uomrZ9LAlbu3bx8xC+H8yyx70SVbB8LSUVvuxcDRnF+QJYOlBiFGtS33xPsN/p
         Pl7YMsIJGbHdeaUlBfw+PVetN/ZB4yoIjKO20flAJJfNX7XEBUFpoS4eAHwKZGh0TheP
         c7pokCZvmokijiL7y6gjbng2vORexET9Vge0LJKmVK5Ns6BNctWBhjFRmwCdJWL+jCtN
         uFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151610; x=1749756410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhNF2QJ/6sIWLymqGUc5VaB6vyzF7wr8RyImSXcNFFI=;
        b=Hs3KJXWk14n4+T/hOQzZY7s1BNgEMFAT1o0y5dGQ6eEKN7KRo60qHRATgXyWDIfn0c
         4WL1zZJXx2+CpP5KR81rIrQFP5/Cp9cc6A89sEj0QPZEtcKMdwEgT4ICcpGToU/zb+KK
         apVbaE7Ci3wXek/GROpu1h7AdTk5AgYYlyI6JJI07SpjNBZTwE3NMbARlHrnk2cq9u8A
         04+D3mvLbhWxQAw0Ff43sRJ41KdZoYCy6ZV/rUkmbZOM3bxcjUs97lwc6j3x2KZX7R6q
         qAVtRgsCqzfwan+CKonImY2Ts+/5eMVLVvGO2YxTt6L3AEYIs5q99JK14IWYB3XNvLFW
         yL2g==
X-Gm-Message-State: AOJu0YxUbaP/WplUkjymKpV84J9Ai18iA5kvvF8s1qMAcF9eB08Vgdux
	X8BcKCPQPn1NGIdRFHgfTjjxlCjWqlZrzolOGR1zLs24vFZvk6/TjxEUNvZ38SfZUAjZr6SL1IX
	j0KJ/CQ==
X-Google-Smtp-Source: AGHT+IELiuWJSTNCV3aqCJJPSlAAuVPyG2AS28Ch3ANPpqmIOUZQ9wETJMd0qg2p1Y86lFb4837gW8JZZ2M=
X-Received: from pjh6.prod.google.com ([2002:a17:90b:3f86:b0:311:4aa8:2179])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c6:b0:311:b5ac:6f5d
 with SMTP id 98e67ed59e1d1-3134769e684mr1228707a91.29.1749151609762; Thu, 05
 Jun 2025 12:26:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:26:43 -0700
In-Reply-To: <20250605192643.533502-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192643.533502-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192643.533502-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86/msr: Add an "msr64" test configuration
 to validate negative cases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add "msr64" to run the MSR test with a CPU model of "qemu64" instead of
"max" to provide coverage for MSRs that exist in the underlying hardware,
but not in the guest's CPU model.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index a0eef541..a2b351ff 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -171,6 +171,13 @@ arch = x86_64
 file = msr.flat
 extra_params = -cpu max,vendor=GenuineIntel
 
+[msr64]
+# Same as above, but with a minimal 64-bit CPU model to validate cases where an
+# MSR is supported in the underlying hardware, but not the guest's CPU model.
+arch = x86_64
+file = msr.flat
+extra_params = -cpu qemu64,vendor=GenuineIntel
+
 [pmu]
 file = pmu.flat
 extra_params = -cpu max
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


