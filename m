Return-Path: <kvm+bounces-30338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 049449B9732
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 352181C21A97
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4B91CDFDE;
	Fri,  1 Nov 2024 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ojTOAm7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED2E1A7AE8
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730484948; cv=none; b=a5toMX44YN68YyFkvXK014ueqP8LNRmBn6osTiQLM/fv4iuVxsdE+c5eu+CyhF1Q6maZUg7uz5k7OYrADUYVclS2IZbaVkSeRJFN0gdEf5sQsLI/Nyegv3w55Jgjnt9k0OwA86BHBDc6cc8X6FIyOCcli4mTMjDWxiBWZ3MyHmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730484948; c=relaxed/simple;
	bh=FW8JHk3YGfbCYGtZ3Mzk1ogv3Mmj+0IgvWXC0ldYUQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bdggL+NKQsjwjJaav8iIaQw1XVC1k9lSOZuCPH15iHPJhasT/p65+szzIK7gVSO3Em5vU+bkA+Bzb/w8rSZ/TUloF8iRUxgrbUy13p/fAqShdlhUnm5jYzEp3Cu+mPnjA/47gncv6hgEvYwzNNijXYTXYuMN4GdNzPucuTswlK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ojTOAm7Q; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2ed2230fcso2694392a91.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730484946; x=1731089746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q2bdkQ9H/fP+Nu98WcPEJqY3qMdHmveh6b6/XkHLIus=;
        b=ojTOAm7Q/67hxd1hadg8fwcoe3tq1AjHqUYDrSsV9R+uyueMTB7o7m720sUfKoO8Mv
         8FWpNgonoXBf3lbQRJwX4afJQzJ0JLcs/XO3r2WQc8YE2Ko1+62hKWQR7UDOIsRiAPjQ
         PN9UQ2nHM5Ti6889Z5xw0mfDCwIxzNYMY5ZGpRO7NjLG/t37z/mhfpaRINZT45+5Rz0W
         NnrCE6Ow8k3Kp6F2sij2dgPxGUxhzyiTYDQ1IaPosuIOqM+wcqXL+eu12/smOB0Krb94
         DcFClmg0uLLZe5rj7DkQZFUAtGfGCeqWgwJGlIixaDNFLzfxJ6gTVBMIMMyWZX+21ICZ
         vN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730484946; x=1731089746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q2bdkQ9H/fP+Nu98WcPEJqY3qMdHmveh6b6/XkHLIus=;
        b=OkL8lsqF8XE8rJ4+YiXrl7ROGNrrUOK7YXu8lJxegpaYr7PmzjPlX4aN7jXrMeya7o
         BmrwvpgnGwKNf0eLTv3hVlQMIdZpkepUIAClLkDtzB7znxIREhg7kdENBY7aLTlC1ZIX
         B33p0sliDyqcsjslP6/8PTIt4N91jIlWgMprQkHSThwtqSbDpxf9YdUAZn/K8zHINB/1
         /fv4mJ2n+hEzkp9INV8yyfO2FzOdQanLqCKJBemYxGKn/36ST1as0idpQJnQI3v4PuZx
         PqJAkkUHplL7WuPKSIONAf0cnCHTQJ642rqJyJna5uLKIBJc0ieHZraS3cj3T2CRfnO5
         hDsg==
X-Forwarded-Encrypted: i=1; AJvYcCVh8obQMr8rQC5xQasjT32mYNTpC2re025S9XsXY3NDhR+dcDvKrkN5xPTMvtT4rSQaIWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXDJRyRLYRstDWaU3Y5ZlVq2ZD7SWmiBVgPtiKPFQVEMI4Ahob
	Qf0vkcJu76iq43khNSrvKMHSg9rmjm0zT0WS0ABqR3pGaPxlHJQyxMNtLfpA/J6ut6MAK7OPZzZ
	Cl3NMVYbmHBVSDP+6Zc395g==
X-Google-Smtp-Source: AGHT+IFlwPuf/K5AJA0znbtgKqO2qjyZICURRqpIPVlJ0DxEHxgaCJsPPCi1KIaDOmrvJ9kcdz+yRyVUuPdSr5nT+g==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90a:62c5:b0:2e2:bad0:926e with
 SMTP id 98e67ed59e1d1-2e93c1c9adamr28528a91.4.1730484946570; Fri, 01 Nov 2024
 11:15:46 -0700 (PDT)
Date: Fri,  1 Nov 2024 18:15:26 +0000
In-Reply-To: <20241101181533.1976040-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101181533.1976040-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101181533.1976040-2-dionnaglaze@google.com>
Subject: [PATCH v2 1/4] kvm: svm: Fix gctx page leak on invalid inputs
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, kvm@vger.kernel.org
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


