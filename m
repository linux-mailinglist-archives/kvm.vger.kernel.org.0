Return-Path: <kvm+bounces-31198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 059AB9C1265
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 00:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE1B62861F2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8EE219CB2;
	Thu,  7 Nov 2024 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHTcfKDz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0F2194B2
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022126; cv=none; b=Bm+IbHMZN5h6eAVSrELmp4vz5hBNjRdjuEATX1srJdme5dw589yLDjvIFIqor+Jn6qc+2ZhKDTLzgA1TBJb6OYPrJy1RQVSp5kgH7PgpTue7hSNuF9HSnxCI2Qz9ujFbfmlUOKbLP41K/YT+OJOoMLGFmM1hibWpTANhmbYLNTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022126; c=relaxed/simple;
	bh=Jb7bsAHuq1g+F+AyFt83enXaiVLr1zlWcNhrBiuDpbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NNHUvvuNhbw4r94gPf2+X6lZH9yqq+JzaMnfmUhGE7douCsRu0YiQPc4/UMgMTEtzfu6uh3O1Cc6KkaUezsyTf6M+i9BItXOkmFIGfBx6FqUvXG8hucyvEV7zfZzIbBzo5U0YTxS7+kPUas/FYxTo91Sp/3VVnATELxqhlwje64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lHTcfKDz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20e5df3e834so14474285ad.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 15:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731022124; x=1731626924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=te/cfPXpVlK1XxYIx1bZceEtuwPH7dTOHve13FO/vjw=;
        b=lHTcfKDzqh+LKNhPiVqUBJaLQjkfYZhAWmZpW/0zdlAQqlrdMTo8B34CGgksaMGUS8
         iJMImm7838FMv+E133DwEChNc3nqr8/XXLjM8mltjYJwMjVNrJpj88mowOktnfEn0Ogc
         2zLKTH1DT6UI4EhC905Do2OjsYJ/s4yo7xgUj3ocRKZjVSoEhr5yFgXOMU8EgLj/i3Wb
         Gyks7eA7CHqrZmuw4YtwLC8meW7o+yTeIuD+7F47aOTtCcWPt/r590Dgwo7ndtB7eDJT
         LByAukzGceCom1avHaY9Sp7zbMJdKnMKOsP+k6jH21oK6d9+oZah+hTaiLqkGfVvs7zx
         KHLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731022124; x=1731626924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=te/cfPXpVlK1XxYIx1bZceEtuwPH7dTOHve13FO/vjw=;
        b=HcgvCH5kxWJqyozI/sOGM1iuPoMs7oifHhrOUQlWyi86LXC4JkPwLI8AlLBVmLZHnx
         zjuMjB3kkHPGobyVW1r3BeGeJN6Wnhv+YhRN4BgqVAMg4a1XJ62B8O4TDXhiWVU11AqI
         i1Hh3nGlq+8Vzh1HKPdGNfilM3cybbCahva8sI8ffLtak+r9mQrC8fRIWM11UBS4Wjur
         g5gBRnkJBCGCj5d1U4Y/11mOEnEDd7f38MeGpup9r6P8hxqeZrzG7zMuLHkEdhTXiTHV
         BMHEGH7kuseo4aklXpWinavcMHJiQJFBdLHVh/URNUSFeViLHbJ7G+XBWKxND7OC2fOY
         i/kg==
X-Forwarded-Encrypted: i=1; AJvYcCWoHX2Ukz5ofSiuBDyTRRpnB1cndYv4UUwLfz1IePeOjl2cxpanLF2tp6YAUZSxdH48PSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAYoLExt5Vo3gNGc7uQALlvsa20BV1e/oLgv+gU6oi5l29nEHE
	XLvQYt1TNG1ILP1tDKL9A+icvE48AT9a29ZXMiIKV+Aog2o/aNUBjLG2nJ1IbnpITo944vhlqIn
	RbnMUcfH/GBTW9ctQQEQLog==
X-Google-Smtp-Source: AGHT+IHFPAiltfAOVNolJAl2h+HhOSP1M/MZxsyy6Dv9FYk8AEUT5WM30aZEucZ6W0XBVDTeoqUU8aas5mUiHtIsXw==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a17:902:8a87:b0:20b:bc4b:2bc4 with
 SMTP id d9443c01a7336-2118359a483mr25935ad.10.1731022124362; Thu, 07 Nov 2024
 15:28:44 -0800 (PST)
Date: Thu,  7 Nov 2024 23:24:41 +0000
In-Reply-To: <20241107232457.4059785-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107232457.4059785-2-dionnaglaze@google.com>
Subject: [PATCH v5 01/10] KVM: SVM: Fix gctx page leak on invalid inputs
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, stable@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Ensure that snp gctx page allocation is adequately deallocated on
failure during snp_launch_start.

Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>
CC: stable@vger.kernel.org

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c6c8524859001..357906375ec59 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (sev->snp_context)
 		return -EINVAL;
 
-	sev->snp_context = snp_context_create(kvm, argp);
-	if (!sev->snp_context)
-		return -ENOTTY;
-
 	if (params.flags)
 		return -EINVAL;
 
@@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
 		return -EINVAL;
 
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
-- 
2.47.0.277.g8800431eea-goog


