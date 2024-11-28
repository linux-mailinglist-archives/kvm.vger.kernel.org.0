Return-Path: <kvm+bounces-32643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2E29DB07E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D54161B2E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E972F1AAC4;
	Thu, 28 Nov 2024 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="giwT0Hvl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE232145A11
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755369; cv=none; b=B+xBYaQEWSLJoCOobJx+oNIYCLx3cbnYpjs93NAehUQjDzSTj/OigtpFtbLJm4CO/DPTw5j7ghgdHRb4WndKkAEb4Uba+mx1keCpNEYvcLa0eQ4POnelA/yfIhpu20/jVIK43LmEJvNVW9odqRj3y5X6LG22V8XPbFLGu9XOXnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755369; c=relaxed/simple;
	bh=q3F91ck+dBrsVmQtOZTwjIV0fTw2GsZHZwmuMtwW+6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h6Z/hASEZPA4HszmvCEqbelm/IMqxUmtkgym6VYlEdXNqgFOsPeiXe7on6gj6ZtWfb9sjBTE03BFJBt/d8NQmBXZS3EDJkdeiKy6xyzJWB+Ha99ah2H2rojJL8axb8SqYiohI/qMPqHMmzio7aJSiOcrXb+MATarflsC0CrDFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=giwT0Hvl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee21b04e37so366446a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755367; x=1733360167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Agu6M4WZdSaan2rYdaSmo6PpiQZ+ciRGpotTGWqZBGc=;
        b=giwT0HvluygoClj98kWmTJsdYbnLqtsiBy9cbZ94MuJk8DX1AS0H6FKsW5/jckWscG
         W/Mo+L8JqjD5J0tRK0VmiE4BLnvr7xsiUAuT9Ibjs48VYvFFrlfxcU3egJQpGQ8O4eAD
         Ra56iRulqvbZsiOKmE6E9fxaoqoIRLI2rTC8wBo7hyvuCka+aKlZVfy2VbyCDY0bcosh
         tzDFmf3s/IVwfSfHO0qbWPKFf9GjtrFg1cg1QTufhiOCyOyOjJ7pEL7tp8VcEjor25cC
         ngqn9GqQBQxrHvyKj9WpI/cYxPxmA+HoXkSOT9TDqBUVTcwJpi/9MVxk2trb6mUzG6ay
         swyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755367; x=1733360167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Agu6M4WZdSaan2rYdaSmo6PpiQZ+ciRGpotTGWqZBGc=;
        b=NDtrHsILhHtTJJK5njvSP8KxOQ4kKzAQg41SA9+7VX8WIeI8mBL9AryUl4a+mEDkI6
         JmimONbr8D/Kv0zz0bnHIlqRj71rP5CYAfkDJljPtpLDY8W//KaqEMLKvhyAVbxTVaw3
         ZXEcg+cJDu88xlWf8RtDEamV2rtH0rNDLLuWC1zLgzN64g8by9X+g3fJXXkoUwqI8r2J
         TaIKix/ewP5q3/HWdUBKNqVEE9IYAxY1ah7E8dEybP9VUiLranyBGBYzc0D4JQM6hB0h
         S6/AhJ+hNyYplNnnjGSFg2IIptCKrXDh+1VUxWba3orNMilPkBQ3aooslDsNRPiVft/G
         PYpw==
X-Forwarded-Encrypted: i=1; AJvYcCXak2dtIxBpe18Ab8gdzBqA6ZOZRhy6qIv+6z2YGN/4ioPTvJ57GotOZWhAE5Cti3D6LDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAt7/zxgXQdVoY5rE5LLpKWjbbnAJeZqE4hfYiIoiHh1dUx3Wb
	TCpFKJfbpW/iBUwNEl/1OTLesAZKmo2z3TM77Cpc2T5FD5dIUzBN9Nt3aj+Rjou1JXte4YmbSHh
	QeQ==
X-Google-Smtp-Source: AGHT+IHzlIPOR1Dozv2+kADz6uvilkOgvJy6Ih7MLR3sUMAMwXrp/UBNznMIvAz/TeA8dqsISkWCfiSMkjQ=
X-Received: from pjbcz13.prod.google.com ([2002:a17:90a:d44d:b0:2ea:63a6:d869])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:2ea:7329:43
 with SMTP id 98e67ed59e1d1-2ee08e97ff9mr6674171a91.6.1732755367252; Wed, 27
 Nov 2024 16:56:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:41 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-11-seanjc@google.com>
Subject: [PATCH v4 10/16] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index fbb693428a82..656a837c7f49 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -23,7 +23,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.47.0.338.g60cca15819-goog


