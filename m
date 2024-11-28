Return-Path: <kvm+bounces-32641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75339DB07B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D34128191E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F55D13DB9F;
	Thu, 28 Nov 2024 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ren8luT0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC0F13A865
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755366; cv=none; b=ETfqQqmEihzGV7auxHDzjwqsd5W8s3zdv/g4QleaFDrffH8KQtUI+IfiTjaSRYDe/002Kx1SKPYKL4xfJeVazwH/ckzkXmJpR71QMY8Hkw7htSx77Ia1+EYlfWXMCTOQo5gjAJyoBlWOlZF5HfUxqkvOdzn0c7E3bq3R8NFQk5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755366; c=relaxed/simple;
	bh=UOHD8P5jAo/tu9DZeP+a1DmnkO+B67XGDTnvDmQDwR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KvoIaypvmZa7+5a8YSgAtOA3092UVp+SBfj9K0rU3g2CjTE2uBxGWV7g1Yul4wS2BwRVe2CR/TCAA7TUcxEaZf+kxAYW2olIUiSV9Kz9dj7MhohJZ7bapYQtG9tiCS5UidEC4YPBXPAoJkjO8SsdlL2HAQ6uadg5Q2Amc7DY5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ren8luT0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-212120f90e8so2633655ad.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755364; x=1733360164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ysvaIdmMpR/VmHKwcGzTb4HtexOKJ4Ghx7ZOeauEtvk=;
        b=ren8luT097x+yMTLNnr2h+Aq0eFfU7344rbVXAxh6GR3/wR6SgbXCv8upO3F9dd6Tn
         1sCZD9r2wNP8gIZAspKoycsfW/GHdjyJJkK9AhQJbbKLtP75E/fQVg83mJWFu1nMMBeS
         l1y8rzWk5az2kpjv80rv+vJl6NfdnPxIMoDSotd+PT9nozU6BvRqcPitkCFq+1IwpMGc
         2wHVLwlRmogTC6JCW0txzc/l/MLio6yiK0cp2g+xFB5mGatB5thgp9ggu2b0TgdQbuhw
         cWF/nba4JMvwdtK2BtqVwKDBroj9Xx5ZrTCEgbCVMu1D6j5/m2xAIOzF0r9014YToNrg
         eobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755364; x=1733360164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysvaIdmMpR/VmHKwcGzTb4HtexOKJ4Ghx7ZOeauEtvk=;
        b=YOHCHN4bw0wI3hcArAaFlk56g6g33gBBxNTV/JdvZMGfL/Z6F/gQaBxP5T7FlXR41i
         LGbRRnNmn7RCUfETuJXJKjBEJX9/crXSynKx4ZrQJhIorg08/y/EL9mO7rJMSZftY2Kx
         u8zdkztinctJPTxis+iPJlvf/TwiMHYl7zj+WPaUg14rIzFt3hT3zbdvbrkarQKc8/lF
         CVJjX2z7IUjk6SoAQL79cDwlvr/ZNN5gMqMPb4ofUi8vsd0UpGzI6iskOF7zpERome3/
         pUELOpqTZYk+TfOWgiJupxjwEJaO8DzBa4yKDvOgvapjARSoCQiB/eEolVvRnBw5UQfz
         EFKw==
X-Forwarded-Encrypted: i=1; AJvYcCWVoLcc9NnSgPduzfy6F3WWHSumkMVY6AzRkpB/SNDutqIV6RXmt+6ZTslFv6wnwRsX7bA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2N8hfGOD32MyPobv9CHA9w/+Q0c2lDPS0hZA5NdE5nb6ZGf+6
	wRvDF+Yk0JOdvAtaNWUxysY6BNUV2dZAo4+LQ87ALj2l97ZOJBVxD8kSKpTusybPOALTe5SEp4u
	HwQ==
X-Google-Smtp-Source: AGHT+IE+ChL1KLorT8CIkfmIr19XCryd//IzNWr5z8aQi0CF/Qf3ZQTw4qD7deHM4fsaQ6e/45gZiVf87tA=
X-Received: from plbmb7.prod.google.com ([2002:a17:903:987:b0:211:b7e:ba7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84f:b0:212:618a:461f
 with SMTP id d9443c01a7336-21501b5aed2mr63134555ad.41.1732755363732; Wed, 27
 Nov 2024 16:56:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:39 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-9-seanjc@google.com>
Subject: [PATCH v4 08/16] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
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

Explicitly include ucall_common.h in the MMU stress test, as unlike arm64
and x86-64, RISC-V doesn't include ucall_common.h in its processor.h, i.e.
this will allow enabling the test on RISC-V.

Reported-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 5467b12f5903..fbb693428a82 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -15,6 +15,7 @@
 #include "test_util.h"
 #include "guest_modes.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
-- 
2.47.0.338.g60cca15819-goog


