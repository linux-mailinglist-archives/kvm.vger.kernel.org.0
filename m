Return-Path: <kvm+bounces-31199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B73319C1269
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 00:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 455E41F231FD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 23:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF2621A4DC;
	Thu,  7 Nov 2024 23:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WbGOVIs0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B244219CB1
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022129; cv=none; b=LcsBMbz8ryuPXvq5YTx+eR7/AeShQobQJL6nt8ZaxuNzxj84tKuQHKXjVIgXBDuM1eMAhrsCKTlzsmTjCnPFhmwYPYgJj70Kd7VXgQmO5UN4ENQI3KsO3TqNTr16VjwtBPwKG86zu5hcjksBZaNVSQTonkIqrXHL2YyF3Xz9MjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022129; c=relaxed/simple;
	bh=ayby78yQOyjOz6ls+yE5cxTfghhQvc3yyzZlL7gs+bU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E587HyikrAoz6s8cD9vagVyYDupHhPPqEv+GUfZiLok6xgoJD52d88yYd2lI6fcuI/i3V35P8/9d24oCmu16tC5t2NN5R1Oq2sppxa9WuYYTDVRNJ+SOkOXAa8VVNhEaHGC8W4yLcYX+kbA5O3h+9a3IptaBJjbfOQDQYlPhJP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WbGOVIs0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea9618de40so27304357b3.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 15:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731022126; x=1731626926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WmL++hD8fgHMSusvyHDFwqq57StgWysj/njcEHmccMk=;
        b=WbGOVIs05QBUu/kA+FtWQ6Ah9sHo6mDXK7iTFwS0M04KUafF529xhoIFIdV/STizsN
         m9BS9V2iO3vsGFT7QdWpMbbf8BVhnFeK4GESfNf4/FLs5B+hArggrfO+0BcdGU79qZ2w
         zwcmAvBRBnk3hsnTMm+8hWgGFdhClxjIE3idIHM2+Az4ToNihkkGBObgYxIoZte9dQ4J
         BPPOhXN7nr/RLIeZDPCVjuJ6j5szypZr1QCdkuFnd3Jf1th05otOnOO0X4GynZ3emycH
         JBkqtXHttdAnsmX13O8R9K3di9vHRch/xN0nF+tvPmWwFslgyvq1uQVw/O1xdNwSvFwR
         QKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731022126; x=1731626926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmL++hD8fgHMSusvyHDFwqq57StgWysj/njcEHmccMk=;
        b=hlDpXt30eD/UbJGYkbpoTdPNKA2qfCvNTujafQnfqgruY53eHwZY0xWhwvuobKafRO
         cVeb5Y6ymW/na6TIzn+EC9s11kn7OtlzRojnro/2vI/OI1PnOb9OY1pUh1pwmjiR4Vgq
         npvRC+o4rB1Aek5pxdjgYzsmvXd7ps63k1MSIn5kVsmHB82a8xwaWKdBSdWIQV1hDCWz
         nT4uGgfKoCb/ScOZx9z6jHzYzpEJI/9RrSaayGL/mdcHMdOXk8ewSVQnrPoEjnscgIs2
         J0QB6MU/dXNxIA43YjcLatVh3MTSA0f/VBY6pWs4V0K3HRfBvmmn7/WrMh0gzsBu08kc
         FN1Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1EI5hfiaFNgGmREmIeo8hSQxp5toBFJf5f1MPL/SM3CxPY1gNOVe47PXYcBCanEkSK2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8y8K67NgBZOH4THBShmjetG7as9O0XmAVDC+FTes/gnI/DPOP
	Iestw7DP0TA0fZz7BqRe5d1CjBsrUoOE98tMso+6XzBgfc2ZxDFSYH0/dLUBwIhR9M/F1m4IWLi
	WjL8f4SohNN6cVCGiXH2kcw==
X-Google-Smtp-Source: AGHT+IHZp/clRKmQZ8fJk7ELtkAKGCrs2CU91VNe+31QXmURSkfx5SINiU/puhbXGTHvPt4yQyv2DjU9QK+SpStkvA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:7307:b0:6ea:3c62:17c1 with
 SMTP id 00721157ae682-6eaddd75f83mr94917b3.1.1731022126529; Thu, 07 Nov 2024
 15:28:46 -0800 (PST)
Date: Thu,  7 Nov 2024 23:24:42 +0000
In-Reply-To: <20241107232457.4059785-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107232457.4059785-3-dionnaglaze@google.com>
Subject: [PATCH v5 02/10] KVM: SVM: Fix snp_context_create error reporting
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, stable@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Failure to allocate should not return -ENOTTY.
Command failure has multiple possible error modes.

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
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 357906375ec59..d0e0152aefb32 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2171,7 +2171,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* Allocate memory for context page */
 	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
 	if (!context)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	data.address = __psp_pa(context);
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
@@ -2179,7 +2179,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
 			rc, argp->error);
 		snp_free_firmware_page(context);
-		return NULL;
+		return ERR_PTR(rc);
 	}
 
 	return context;
@@ -2227,8 +2227,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	sev->snp_context = snp_context_create(kvm, argp);
-	if (!sev->snp_context)
-		return -ENOTTY;
+	if (IS_ERR(sev->snp_context))
+		return PTR_ERR(sev->snp_context);
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
-- 
2.47.0.277.g8800431eea-goog


