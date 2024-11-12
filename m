Return-Path: <kvm+bounces-31685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D30EF9C6512
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 00:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 631E01F23D67
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CE921CF8F;
	Tue, 12 Nov 2024 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COv6p2yz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52C721B456
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 23:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453784; cv=none; b=asJy25iBug73Nctmk+4Vwc565DfDR7uEnDrVjOBi2kRoqABN+uvWT9d9DdGg1eWQVlQJwGCkK3t2K0mup2C8qvJjypefwnHcxFpiRtFI1XXD66WBU/mUbLqTahTHDbsdNtqK/ye/UsdI31g9/z5ddymDzLLdXgaJo8g6GYEDUiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453784; c=relaxed/simple;
	bh=Jb7bsAHuq1g+F+AyFt83enXaiVLr1zlWcNhrBiuDpbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VqhYII684SaQayivVt+Kd/hxFXV+yONhgFGsm+mCGyzEQ/zyPWcomNjMbR11cDdt04Shg2KUK3VDDFnOHQhkC4KNckaSSgoEzBo6VqWUygGriCcWM/gZvYTyCbNQS/x6tL/XqO4N2CAkU9VS4D/WpMFuLrOyxICQXD1shzYxNxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COv6p2yz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3705b2883so111860337b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 15:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731453782; x=1732058582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=te/cfPXpVlK1XxYIx1bZceEtuwPH7dTOHve13FO/vjw=;
        b=COv6p2yzzlQ/agU37mZSkJBosG1/nDrIxGPXdeoT1e+f7+nXggvri5hb2ZwVDaaGlm
         QoEuCCvoaicDqhytpFmmFuyey8qSaGcouhcOpZSOA4YC72CckecZ5BYi9UGy6MTk4iEO
         KU7399Vut3BQH99gDJUIsY/UY7J6DH9+ZZzdrZvSOhzRNa+/2iYtWh1GDs/dNHiIJ1R+
         DTyIaX+C8JHuYWtkVtOK54QPERIAamyKT5JvIjAK6BkpzVTBwU3QR3qflGn8fKvmgdzA
         N/WJ1xcQWAFjw1Lt/9DmA4E4gjYJogErJ+7XIAjZZ9mKi3bzbtpUBz9vJloTeaNg9c34
         xF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453782; x=1732058582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=te/cfPXpVlK1XxYIx1bZceEtuwPH7dTOHve13FO/vjw=;
        b=vqIE3fz/UA2EL6PwOJk7HPsg8K24xPUMGTZIwUUwfBgfEEjkOmCTNEt6npxngod3Me
         H52uGjXNHVjUWDoc3kufW15WE2nK37k8G6PooxZbqcEjKGSa9emVyCICvUmVmTmjdOGk
         CzncCByAVm+CGEKDuTjRSUzRij0dqPoljHgIOcvpy+0GE1xVMTfO3JhqbrTUJTM6KEoj
         Kb+ubeIdDnVrwEeb/BGG9vscemtny9xvTNt08k8efQuJ4XQP88UGsn/2AZm9cAig2xwr
         nin/mLv7ylBl9SBZVphhbI/DjtIv+9rTc0XnJPxRRXOEIP9ctA6ya2Af5hJnWdr0XFmJ
         DHsg==
X-Forwarded-Encrypted: i=1; AJvYcCX6oYv29p376QlAagGsFwHZrNwN92rUXrLCstlQsBBQOipNruXXAWk4Jx3l2Rey++tnfMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXMsGPv8tn3CL/g+PyFP9fShvKZ4MPOx3vOzM9MjUF/gsVrATe
	bXfX8brj2Sw58y1Yo3E3awX64YfZuvJRcZedpKbvld3SVsNUNs5R0FEtR2BgjgxuFcY8owKgBAH
	JxwI6eqHzSoscgMMYYHhtfw==
X-Google-Smtp-Source: AGHT+IH0ZHDJ9RxOoA61xD1ipX9jxEyCm6JJVxkz4PucOgUVx/B+vOpDcYEieZFLPHqw48EsYNAyVJqKyr8eL5q2kw==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:3688:b0:6ea:fa4:a365 with
 SMTP id 00721157ae682-6eaddfec9efmr1445227b3.8.1731453781898; Tue, 12 Nov
 2024 15:23:01 -0800 (PST)
Date: Tue, 12 Nov 2024 23:22:40 +0000
In-Reply-To: <20241112232253.3379178-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112232253.3379178-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112232253.3379178-2-dionnaglaze@google.com>
Subject: [PATCH v6 1/8] KVM: SVM: Fix gctx page leak on invalid inputs
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>
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


