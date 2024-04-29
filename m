Return-Path: <kvm+bounces-16146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D88948B5422
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 11:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15FF11C218EF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 09:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7064322EEB;
	Mon, 29 Apr 2024 09:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGGCczmC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642D320300;
	Mon, 29 Apr 2024 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714382512; cv=none; b=OtonOwB5KGXkw+tVXI+ammbht8A5Kifq60ShwAmevsWIKjLFjjYyPw1nfSkrm9SJMnREpAzOPI1fpms9dFSBh6UzpIDpUVzJQbC183dv+XK31AEivmnDQFnHsUYy/4DfERqVXb7+0lJISrDaMC2g4SEgkZ6mex59HLZ4UBm+Urg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714382512; c=relaxed/simple;
	bh=RYP47pychMJazvWWYbs34D9U+KDiYMmu3kJmqSc4RBA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eQlJTOj3qLaa2IGynxvY1XEBy69l8nJtjz8zbdLtrfFPlyegpvtBxZpGEtNiP8xTm72fjvPPEvWQOeg4zc/x+C3Io9Uo0OYNVALI7sF59iN8TlcxLOYsrqCnjYHV5Ndi8yKkMIWvvlhkxDJtLehElgkKktDxzDOOwXOqHrA27EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGGCczmC; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f043f9e6d7so4334882b3a.3;
        Mon, 29 Apr 2024 02:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714382511; x=1714987311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J9UFM0QgrM1FAh0+vb7l+Th4iJA3HL3efcqlB9gfYVY=;
        b=TGGCczmCR7npqeFgumPKFt1rQgAxe9MDZ9vvkcS8F75j6J/4yN2WGfv1GODgdgcbcI
         HaWVAUN6AwUlB/FJn5wOeH6HfC560ceQvei4Oh3VaoL7NlL4/cdCeVgypJi5T/OITjjf
         MHej2fRZLzQX+jzD2XWF83xB5OtBWKLc7EFZT7nhdmRDrtwiM10qCVP/n8hTyYNoNyq5
         LVEHEbN5YytaaAcVNFhn0f28W16tVHNfAmUIooVJ18vWa9/5Uh4SfvJqAshz4/MIfe+K
         Tz6dHEqPN4a17WECqqjmquCv+5itFJjrcNLLge+v3No+A1Og31zsNvMZRtI0sUmbAr2n
         6PZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714382511; x=1714987311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J9UFM0QgrM1FAh0+vb7l+Th4iJA3HL3efcqlB9gfYVY=;
        b=eiZ334sll0+bpzkpDI8yB3c22yW/MjoP28AvprvTBce97pBXX1jl5YzA9V20AGh04J
         C/CxUXfjy75UZnXJh+1nu0iBqKB+LNBAf9NGdwcqVdKG4HUefWSBJemLNFeJldJ3Gyzm
         +9ylYNr4brinojXag7ExcQAKxAaP4xYDc/xliOONmXW10feDqjOCwHbTAWixOjp5duk8
         Mbwur3mrLSx8RlgRor22XCZxaW3fY6NgeyPue7xnJmtl7rl0CQLTJwSfDNq7by1kd0Su
         7NvNloi20UIEEl/o8L4aPyOjpWY1JeeQi5CNSMvpsZKCl/qka8EnAG3o1TLfV+87QZuQ
         gQ9w==
X-Forwarded-Encrypted: i=1; AJvYcCXOke+AjiUjVWx63/KltiNSF39CEJXkr5+5qri+kGIxNtPIoDxt604174/McFZjIjxw0JOMs0sb+nEJeeTL90n22ifjES/Xn+bq4lvnzEhz5pFQOe26fJeYKNs2In3SEj6l
X-Gm-Message-State: AOJu0YyAeupcIUj6IA2h1B8gWIygxIBAo0hKp5K/1826BIRczB71geQE
	tJW1yVs7AUmu5ii0xMa8Q6DmkFTsW1ZOtPauszUiocDz8AAgr5nTASVNaBXtAsY=
X-Google-Smtp-Source: AGHT+IFUWMxCtXR0YEgu24XHMxJDW5kxEJj7RXx/NjNPsp2tU9ljNIxOlNFDAkPSTudVDNteHZSAFA==
X-Received: by 2002:a05:6a00:3a09:b0:6ea:74d4:a01c with SMTP id fj9-20020a056a003a0900b006ea74d4a01cmr10302896pfb.14.1714382510598;
        Mon, 29 Apr 2024 02:21:50 -0700 (PDT)
Received: from localhost.localdomain (122-116-220-221.hinet-ip.hinet.net. [122.116.220.221])
        by smtp.gmail.com with ESMTPSA id b16-20020a63d810000000b005e438fe702dsm18503787pgh.65.2024.04.29.02.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 02:21:50 -0700 (PDT)
From: Yu-Wei Hsu <betterman5240@gmail.com>
To: anup@brainfault.org
Cc: atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Yu-Wei Hsu <betterman5240@gmail.com>
Subject: [PATCH] RISC-V:KVM: Add AMO load/store access fault traps to redirect to guest
Date: Mon, 29 Apr 2024 09:21:13 +0000
Message-Id: <20240429092113.70695-1-betterman5240@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When unhandled AMO load/store access fault traps are not delegated to
VS mode (hedeleg), M mode redirects them back to S mode.
However, upon returning from M mode,the KVM executed in HS mode terminates
VS mode software.
KVM should redirect traps back to VS mode and let the VS mode trap handler
determine the next steps.
This is one approach to handling access fault traps in KVM,
not only redirecting them to VS mode or terminating it.

Signed-off-by: Yu-Wei Hsu <betterman5240@gmail.com>
---
 arch/riscv/kvm/vcpu_exit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2415722c01b8..ef8c5e3ec8a0 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -185,6 +185,8 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_INST_ILLEGAL:
 	case EXC_LOAD_MISALIGNED:
 	case EXC_STORE_MISALIGNED:
+	case EXC_LOAD_ACCESS:
+	case EXC_STORE_ACCESS:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
 			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
 			ret = 1;
-- 
2.25.1


