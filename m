Return-Path: <kvm+bounces-30387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 861DD9B9B63
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 01:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 284111F22105
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 00:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BB79474;
	Sat,  2 Nov 2024 00:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ik1LXbrV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F21B79C4
	for <kvm@vger.kernel.org>; Sat,  2 Nov 2024 00:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730506112; cv=none; b=HBegGcc4TJxd6sNPNVUBfrWwc1InYFx81f284F0AFvWIiQJeDojJ6z04rXipvToBOUvJd6qqgq/9J87Ie9LpO8b6KMqohUObYEV/QD7d8QhuDzg42mQjsjICPg9e7ZPbKY54OnEo54UZ4z0CVxgRSXrprftoNJj2dt8Yv2XtpGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730506112; c=relaxed/simple;
	bh=Rbij4r8cylGhkgGUg7WpUGdpkZboGKcsQk69ga17bxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RMytTLlXda33BNvHH2NHMBgNmECUzDWTM27WCGtnur2SHDqFrHOe/slvIIYJBUjcvCwE2h/D+vfFnZZ07imARto/s2N+Ia/uSnexFWQwhU+r+Zizt8mCAzq1ZrqtmGClI35C9E39ODjXcXStKbND9Q+rwKtwBKhcwe6VjrQ2yUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ik1LXbrV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7202dfaa53fso3516388b3a.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 17:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730506110; x=1731110910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9t5+hAx/Vx0CBMSZ/K4Xo8KI8HClXDiTkRfLYODx8EU=;
        b=ik1LXbrVNQnsgWF6rbrOsB8r1t9Gfuqn7z+m2PP7e4ivIj4Bob1HLqB21WmcEgy4jb
         kZvi3HBwzGIn/JZMD4iYTe3++hZbHqVhBJc42zq+88f/3ORi1SxS7lMWC1zTWtgu7HZw
         nMaat81114Pw545/9uP4UKOBuiiToVpWYiNWO1xH8P7wSSr5Xkr2E1zjh8SPy4ylTB+q
         legvHK+W2A4/BkfVRQyUH+vT78j/QK68AQK0F0YRf5dsJ1nULKirFzf37pRxKt7/AOPB
         QZC4iCYdy2nu/vfGBJYM8DNJvZkj0WFWXcwrJXQfF9lMivlXoweT5fQfIjejH0hTpayB
         B8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730506110; x=1731110910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9t5+hAx/Vx0CBMSZ/K4Xo8KI8HClXDiTkRfLYODx8EU=;
        b=sIg/4ffHT4QbAOLzBfcc9ts4a4t5/XP5Msn9qvX5GnQ5G58ydDb8qE9lCGNSBvmsQg
         SO588f7Qn0HxRhyNMOJhe4t0tltEbTYtrU4uSEQIrtewB2KYLXRS5TTK31oENxhRr0ST
         9HX+mlm0w1j0n0VT7xjdjjgfLM/Xvlo7cpImMebRCy3r/nTCB5vBaX8JQ6KmygJGEbjF
         MiJsRXAMSbz3/90PcWU55/x7Mn5VChFuupeC158sycDz3sv/WVcz+Yl5Vpb3P9bBajEY
         2wnm4lKTj1qhv34oBWB0MSIS+dD5WzmT4jPmg2LWLcNKWSlqbwvGyJnM4BWdRsEkYfHY
         9uaw==
X-Forwarded-Encrypted: i=1; AJvYcCULhLdtof9u8yghxZ2uKUI/V/qEKtUukf5/Z04FnMjgTcTV/SCay3+Uz/wEsg1WcduNV+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YykNRt28mVpqy8yk0ZEJWtgwOB4+K8UORPrPM6W4hWHZ1t8q6+9
	SzqGEUks+GuPwGmJ4MVf4kKxrPzGlXUg37giZaRK5yKcPHf5tBhKX1BHG7K2efun/qk+EoLaZAn
	rm2Vr/3xDmxvbQ6weP4Dt5w==
X-Google-Smtp-Source: AGHT+IH0e3GALuKo0D69gpU9KNL0giGzOcfcFha1VASPxW64ZNHEOxXwwBULM49bCwY2pfhwLl60b9qTFoYifUuHZQ==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:6a00:600f:b0:71e:5879:689d with
 SMTP id d2e1a72fcca58-720b9e7aaa1mr26792b3a.6.1730506110334; Fri, 01 Nov 2024
 17:08:30 -0700 (PDT)
Date: Sat,  2 Nov 2024 00:08:11 +0000
In-Reply-To: <20241102000818.2512612-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241102000818.2512612-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241102000818.2512612-2-dionnaglaze@google.com>
Subject: [PATCH v3 1/4] kvm: svm: Fix gctx page leak on invalid inputs
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
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

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b72..f6e96ec0a5caa 100644
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
2.47.0.163.g1226f6d8fa-goog


