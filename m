Return-Path: <kvm+bounces-48594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C84F9ACF7C9
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 291433AA711
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4558A27D791;
	Thu,  5 Jun 2025 19:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flbSapbv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B2427CCEA
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151363; cv=none; b=OVm7iIPQX0qc33VWwt9kbjJIOvmLy/RSL8oS26PAIs4JsnZYLpzhrNe7GtLGQ+gBlaQBF3eJGQV8JJHOSSI2UFIHIPKXwsF2lpYGZ6R1Z4EYdSRs0b/s7k3sRBeL9UZUX5VNR8dFswTJOhX+URbp8IRfo8EeB+QqSetUTrqdZJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151363; c=relaxed/simple;
	bh=ooXLobPR/yKLfiUX4MdxMcEi5WZkW/O+Zs6h2QErImQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=muPtIKUSW36dJQoWxWFu2Dqp4di6F6ylGIgodwuojm7K3THnK4ECvLF1JIBtir8RLjcNgR1y0d34Bpl1VNwUisvI8mEUBYWsnZpUhUAgd3amwtPwXM+JfJbX3wzvWU9dfPmuGPGiSPbKe7SDmJclk3W+wxMo5ITrsYm6fKEREsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flbSapbv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26db9af463so1166557a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151361; x=1749756161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fCyRRxIm/ecGYie4eM0DmT+3Z8okQLBx/b9v0eRbBMk=;
        b=flbSapbvwlElKuNy7XLiC3x60shOdyVSUCojZFLiFHXWjlZAxlvLfR3jOotJuIvuC4
         eO0j7TZHI5mDp2dhpd985oSgB6Xqme0oppowaL1g85cwY6rQWSJf9UIYjGF2OF7ASTnI
         c9fBl+VcSgfkf3WGjIHLb2kUZeG2RDbEnZoAjIWPZHAB2shI5WJvfDrQtOdwuYUfQAJa
         gwt9k8u7RbJPdTBhAiywiXu9TlTh3iMAhJnJzBnyMLO0ThX9OzUiBrnekg1JCiKK60y+
         zcS8WPd7GCU8kUQrajPvZfbFQj+MtGeHerQaeQn/vCW5+Rao6p6YP+ics0ooRjNnwhL+
         AQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151361; x=1749756161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCyRRxIm/ecGYie4eM0DmT+3Z8okQLBx/b9v0eRbBMk=;
        b=nieAS3DRvpSmaPxzxpOGG7UXRB6MBLeKZDTTxr17FQMkLvwM2tm0qeASJ56LbTJ/IO
         /CdGE9aI9yMMIk2Vqyuc7qmujWCsbuHSF66YC5DVb4BYpcWbfk2CGTWy2HcbxN6QKf1d
         +yfOiMx9WUpQ2yTkaBe62HDvr4cobo40Dy4DehAJdcsDJfR/T8BQDuLuZRq2Yboll5LN
         /+UAAdT2XbEYZ2dLimFIJxn8TvshtWwYa8iedKDbv51Q3AyIquKto+pOy0kgLG4aMzD4
         aCz1Ze5JpLvAZKL5j7YhkbhgKjuJ13dAdLYhn5hEIzBh1TN7rIo1oZxtbmVmXDhohsDN
         xyAg==
X-Gm-Message-State: AOJu0Yyi+ExG8loGBmccPEFHZLayOabqjJpFMb87bKZ7sZ+jRR7Jo5Gr
	gC1gW4mdo2EimkesR1LIaNxF0jFzWpBeLmLropSvZzQVojtQRpg2RklwYwZRUO7irGYNLUkT4T0
	2e4lv0g==
X-Google-Smtp-Source: AGHT+IHCFGK5JbZbV7eg1aMYGGpghOCLXHL/Bt230OvaU0vxlfB3sdouI40a9GdtW3BpZNp4i/TOW5zW5nc=
X-Received: from pjbqj7.prod.google.com ([2002:a17:90b:28c7:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3812:b0:312:db8:dbd1
 with SMTP id 98e67ed59e1d1-313472d49cbmr1072529a91.5.1749151361382; Thu, 05
 Jun 2025 12:22:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:23 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 5/8] x86: nVMX: Use set_bit() instead of
 test_and_set_bit() when return is ignored
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use set_bit() in vmx_posted_interrupts_test_worker(), as the usage doesn't
actually look at the original value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2f178227..53706000 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -11122,8 +11122,8 @@ static void vmx_posted_interrupts_test_worker(void *data)
 	while (!args->in_guest)
 		pause();
 
-	test_and_set_bit(args->nr, args->pi_desc);
-	test_and_set_bit(256, args->pi_desc);
+	set_bit(args->nr, args->pi_desc);
+	set_bit(256, args->pi_desc);
 	apic_icr_write(PI_VECTOR, args->dest);
 }
 
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


