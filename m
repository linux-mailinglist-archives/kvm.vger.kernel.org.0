Return-Path: <kvm+bounces-30339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 931289B9737
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09CABB21807
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B5E1CF2B7;
	Fri,  1 Nov 2024 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YpTHgRMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7696E1CF286
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730484955; cv=none; b=HjkEN2f0h98VNgryj7r0BNb6XUWxL2JrH89uS59VfTBwNTm2aBSaxyd02uyHG2BbeeP/2+/86rqutcKH5uKexP96lUpdho771t3nO5AU4u4cTLGGT8ZNscme/jtpIHQMw+tC4RMmZvHHK0broxo6vjtDS6CJrS74YtqZm0DLADM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730484955; c=relaxed/simple;
	bh=GSHbBwZfkYhqvZmnpUSaXG42ezayg8nwJR7cfig/aho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OWsxoJKt2iK14p93d2fDEockK5wA1SkxWQ8kdT5nHDPGA7N2E41mCBA6sH7hzUGhoMYzoaz1qO4roLEQL0FC99fUmBSjwyxqLMfDx39jbB3bgS9HYQ3juFPkWWke6Jo4wmmu5NKK/2jdY2Qp1YOMBhXix6DDvrb/sCHGKIg3d0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YpTHgRMA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2fc2b1ce1so2545555a91.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730484954; x=1731089754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEZAnkCadaVg1BrSWxgRmpQSE/TbQcmppmH+q7yf6WQ=;
        b=YpTHgRMAdoZAKkHFfRpC6r90RhqV0TD28pXPHSyTRIlrKLTuXKZA3RT+jLb9A+siZ4
         itulhAA4Yjk+kzxe09vqyvG+OEq7iV0EnBEVNxzKrEbxzQZC/938l+ci149VTBvIPzrZ
         WAdZvDFKD3rZ9oo0vWUfuRMl+Fo2dm9oSesxWg1OPy51yZFdw1Ixsum4ha8XajpBkvdM
         up5Nzb6a+F9Ald2mzE81CzXdkQD9W64EIhqRu1F/trpWNTL7XHuM32xDPM3YUOXOOUt6
         TZ+xEJzh9Ma9CAKccIYa/X2HUnBc3O0461XALm0ivGX5ZgXEcfQBMdbjRbmbU2UojZWx
         x2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730484954; x=1731089754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEZAnkCadaVg1BrSWxgRmpQSE/TbQcmppmH+q7yf6WQ=;
        b=qRPdkYvcD2ctmIWoy6KX2y3LsqGmvL7NMXQLiHYOc+6oBu21DTP/v4kmQ/kd5x7W6o
         zbqe0orQcqtwjHGsGQF17DSk99aPAHK3Sr6dItplD4K4/oEtE6lyshEfE4foz/szy0KK
         E+mpw9PbW/iY764gWCbVV6iD/fk0gFaw/dOLSfptVyEjywGt94xSJRIPZ+M8kN+aLA1Z
         MtfsVRVwDOME4onpjdc3FpF5t31bQ1BtbBnhHyqoi5VSqFIiXIFp8z8ukHVnD6z8jpsd
         gWQeiNax2B4owytBEVZcj+t8GL05Lw2l9J3u+Nlu/HwwUjuhrOLonnHthFBX7BQpJH28
         8Njw==
X-Forwarded-Encrypted: i=1; AJvYcCXtEYjn0vDpTPLG1Bucws2Y2yz+mnRqxDd/6Aa9FYmECqi4LQtYIdazo3WxYQDh6PufS2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaGoDFGcd9Gb38ElQIhO/UdVg4l+g2Jv8fmmG4cOy62QatJjjG
	OEErfRCoinnoT6oTGjlO9YFxy/qp522QijBpF8n6rClpa2U9+yuNZl3tESf2vRoF1u3EQT/lJNo
	S/6oRqFGV5Lyr8rQHgY8dew==
X-Google-Smtp-Source: AGHT+IEXa+QnTPnVNgHoaewOLlIH8wFAnb+M/ihAEAGqYML1uHaPbaA1TFQ+R1PS5raQE1UTHGA6cnlOKUra43n49A==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90b:616:b0:2e2:af52:a7c3 with SMTP
 id 98e67ed59e1d1-2e92cf4f915mr20243a91.8.1730484953636; Fri, 01 Nov 2024
 11:15:53 -0700 (PDT)
Date: Fri,  1 Nov 2024 18:15:29 +0000
In-Reply-To: <20241101181533.1976040-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101181533.1976040-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101181533.1976040-5-dionnaglaze@google.com>
Subject: [PATCH v2 4/4] KVM: SVM: Delay legacy platform initialization on SNP
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When no SEV or SEV-ES guests are active, then the firmware can be
updated while (SEV-SNP) VM guests are active.

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

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f6e96ec0a5caa..8d365e2e3c1b1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -445,6 +445,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		goto e_no_asid;
 
 	init_args.probe = false;
+	init_args.supports_download_firmware_ex =
+		vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
-- 
2.47.0.163.g1226f6d8fa-goog


