Return-Path: <kvm+bounces-35162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB170A09F73
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D81ED164B55
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BB517C68;
	Sat, 11 Jan 2025 00:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfJjxmiW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D11B18E1A
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555435; cv=none; b=pv0Whnbnk6dNeT0nnjTFXuYT4/AEV5i0VRYiZW2iRPjpyb2o397O+tSaBZ7gIaVQVpfKrNr8hKfNloEku5NOt2BfIFBFOpEU255WCYQEKLdBSvAQCRM2V7lOHyWn3OCVMM2qS2Y8z5V8dTVYmEZAYZ/4if0x5GFLSRPcpVKrjcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555435; c=relaxed/simple;
	bh=ZYZYkEZZBfkKU2arptoaqJUAJlhMnndiUETqebZmKlU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IiC0fmOzhKH28nWZAyOQRNVbV1GXuznuUZ3MfEtrzRYHJH1Lum5/Ql3wKNEyJ3LGTi0NHk2PFpSGsASAgZ5qJ+RFDE8xAiH74Ra1yLnud5qKinoRI87V4JzdSS7yaaAW7Vc0l75OM1eEZRCnBA0KzE9lr8gWkTCDLdR11veyDZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UfJjxmiW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso4772487a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555434; x=1737160234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tf3ai7YM4gD3aeEXOHvspZExdducxhbkAx/Bf8bRNDM=;
        b=UfJjxmiWO0FYNe/Rs+Cb3mNXgGFKr2OeCfzttcWyhvEuNN3U2FNUNilKy5WZjK4goj
         3SO+sFB0E4YwzhQUR4E3DhM8cVDpd3ivC4NifqgflrcK5XpYR6HodAeTtDELDfIONuOP
         qsOHxQaAmxSgYLgN5sFia+MGP+ChmPCnuJWH0pLOX8H4knswX9148ylRhWG3UudpeyFn
         Btz5GHRMWsQz+ohVDwE6ndFn50ApQ+njd18kI2vtN74H+BfMTqaXbgYLhi1IpR1wmU6G
         PGCAIqMTy9UYW22GyelS+iRBd1Ck18SiM/IpHcqJZNuMfRWG0Em/ItLGBhr8ljLJfHIo
         0z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555434; x=1737160234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tf3ai7YM4gD3aeEXOHvspZExdducxhbkAx/Bf8bRNDM=;
        b=kzZ53wS10p2awMz3i40aHfU3OqrRIeSXEG6RC0txzVirZ+n+RPCglfmt9RMNYCf5r/
         5uot4+BSzOdqa9Cn8SCejVyJ2u2AC7m3UUK6LhCBUIFvi2j9pnWBZM2L1uuc1wJsgOLR
         085wqBj4O1lLtyhLvuO5fs+Gv4D3rlIuawWnCZlfNCwz/tEhRfZdhyHtmjc9b2ZgsD0x
         IiB3t+6kwU2ipcnyt2SKcpm9u6QnIETo/5R0Et5roQPjI0qrTZXPpCCCVEoUoxGZk9f5
         MbOM5h6qJPClSacJ4Zt2xyl/0qnM/ibRztRjeaEsHZJ0CMcjnCy0XV7Jzpx8jwYAVxs3
         TVVQ==
X-Gm-Message-State: AOJu0Yxgq6ybEiAhBF+0mtnZATMpZDe6lX7IDXPqJVI4LmR/SkjRjSye
	E95uk/kngMlmhb/iY4emhM8vBWFC2rUdNBIf8mHErpPA2Qj7ARgbMVvwN+xnHOBAUZAwEQet1HC
	XQQ==
X-Google-Smtp-Source: AGHT+IEOfPzQKaiEZ+lOue6bQaGOCpx2jkMD63pcudGYIIJGaMpOLZezevh69lEqfxN5HF7M5FGj/Z6+bnQ=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2f4:3ea1:9033])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258b:b0:2f4:4500:bb4d
 with SMTP id 98e67ed59e1d1-2f548eca081mr18398188a91.20.1736555433836; Fri, 10
 Jan 2025 16:30:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:59 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-16-seanjc@google.com>
Subject: [PATCH v2 15/20] KVM: sefltests: Verify value of dirty_log_test last
 page isn't bogus
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a sanity check that a completely garbage value wasn't written to
the last dirty page in the ring, e.g. that it doesn't contain the *next*
iteration's value.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3a4e411353d7..500257b712e3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -514,8 +514,9 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 				 * last page's iteration), as the value to be
 				 * written may be cached in a CPU register.
 				 */
-				if (page == dirty_ring_last_page ||
-				    page == dirty_ring_prev_iteration_last_page)
+				if ((page == dirty_ring_last_page ||
+				     page == dirty_ring_prev_iteration_last_page) &&
+				    val < iteration)
 					continue;
 			} else if (!val && iteration == 1 && bmap0_dirty) {
 				/*
-- 
2.47.1.613.gc27f4b7a9f-goog


