Return-Path: <kvm+bounces-63134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E23C5ABA5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7948E3B8D46
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41211E7C18;
	Fri, 14 Nov 2025 00:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fYSzj09+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395922D4DC
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079196; cv=none; b=oWTCLVih/GjHB883yYApp4BrhbfWoUSMhFU636++3lBOaF9/CtuTMUOr9iX6nhF6s4uhhMuqlfxy/3LLiHgm2fks1bi/ODDTKJ/NE6SmV7EOI9xR4+XrOyl7FENSLHpZE+TRrENFuFgjRPP9rC7rUpzX8xldXG0h+HiMm0Vb3Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079196; c=relaxed/simple;
	bh=drnhf4HWccfdCRAqsv6Wpb1qqqVWH2tm3oJf1ZUDKTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YRIUKbcW0z+1E6zOh/qFPQ08n0xmhwvJt7/ccfx5vHpqCRBZFsqEsiA36A+pJiMRgzcFZ+c4GNCHAq+bqDFI+7hPMhJ4A0EFy1QjKvquPAmtYg85ClxnWy/HYwNIOgqrTXWtHcDf6/jO0jTFliBSMStRvCmSsp/0Xn1V27bPclQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fYSzj09+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34374bfbcccso1604598a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079194; x=1763683994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QwhkZoiw2YNzZ9paPLFlvXCeWSMScaZEgEdXJUEBb0c=;
        b=fYSzj09+zZN2pZ4AskcORSMC7RHLAEz+u1ay2B9P1TGhAUhYak2onJoRfrBUv9q5Ed
         YS7YYN/SbiJlzzpqzp+M/QIdy9NrsJ2JHOpfChCmx556QAK7pHg/emFsgIkZ98A1z3Wi
         S+MhfRt/3G1Uqxh8B/nBgu/edR3QxO3MyyW2+yjNvDHj4j0gj0nvWvWZKr7Io+mO0DE3
         gn03VqtRxntg77WYKtzO1brX8gUuakTPBARl70y9pFvtw4uSN5Lc3KM4nykmEufTeGiw
         2MnnFxKWERrt+wb+4Dtr2Yi9xAHVeBieAejZoYEdMZVB2TLIPN0yvio1aiEszqinojLl
         Z+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079194; x=1763683994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QwhkZoiw2YNzZ9paPLFlvXCeWSMScaZEgEdXJUEBb0c=;
        b=X13GzO90QMjrYuVkfXxH5u4WPp241wr6ZozJ9ED7rO9D6NB2pRCiwpnfmfCYs1Msnx
         hRwD6nypicrX2IihAzOkeHHeD1Q5y0ne9j2CrZDa7Q0BILDlVvbsh+pB5cabCFG1RP8W
         Wx+RA5hV13UDJuphvao2lQ8oa0qBNd6ibIgTLrIMF72h24E4pVLryuIk3PoIQRgMF+xj
         3zm8EoBebUanKsg32HMbMgdDqUjZkeck55HJYWmIbgjxBNeRSRTvlK85u43osE1pTYs5
         7HTZ1H8q3WPdcFr4qUnKW0S/SKEn8uNZdHJe0XKJstV0p9aPDvJ+dj2I+A0TeH7gtc3h
         ujAg==
X-Gm-Message-State: AOJu0Yyr+tlaRUWYzX7jO9VOs4jn3jhh18rwgAea/yCTgtKOhQ/iqq/g
	cZeibT1QNaR7ShzOtBOB655xJrDTUGzuJ/oB87q9/GrGPQxivJtZI7hXNj5TJeDzNi3tkMC6QVG
	Pcy5csQ==
X-Google-Smtp-Source: AGHT+IH86zxg8hv+XzfU8hOiC42ANK3GMR05Mz4qsYPbP8SFw+oqKmZkeTDezE/T/QdOp5ozGCVz4z7deJo=
X-Received: from pjo8.prod.google.com ([2002:a17:90b:5668:b0:33b:5907:81cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c4:b0:32e:9da9:3e60
 with SMTP id 98e67ed59e1d1-343fa74fd8cmr1121120a91.36.1763079194571; Thu, 13
 Nov 2025 16:13:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:49 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 08/17] x86: cet: Validate writing unaligned
 values to SSP MSR causes #GP
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Validate that writing invalid values to SSP MSRs triggers a #GP exception.
This verifies that necessary validity checks are performed by the hardware
or the underlying VMM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index 8c2cf8c6..80864fb1 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -56,6 +56,7 @@ int main(int ac, char **av)
 	char *shstk_virt;
 	unsigned long shstk_phys;
 	pteval_t pte = 0;
+	u8 vector;
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
@@ -105,5 +106,9 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
 
+	/* SSP should be 4-Byte aligned */
+	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
+	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
+
 	return report_summary();
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


