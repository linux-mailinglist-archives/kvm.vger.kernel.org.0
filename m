Return-Path: <kvm+bounces-7629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BFD844D8E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93930B2DB7F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A8F3FB04;
	Wed, 31 Jan 2024 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jCj4pBkI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D243D0A0
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745381; cv=none; b=d5vsDcyH+6JAS4pykXAnXLXQOytMtggXEAvhad3NqJreKYE8dmHeIQQG04DPvtkqKOKx/kfO1lCMACm9cD72UWEhQbFCg7NswqfNBglxWIAEItS9Tbdzz5no8bpyj7JS6UpJvnnhSIxgWh9RmNiZA88CCkTVtzMIZ/E1Jk/IMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745381; c=relaxed/simple;
	bh=dJzDRHZ4lvHqnCEXSzwyrLR5DGIflpjXQoxReg/o7XY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gNIDZeO7ZRETGoXlrmbC+Nx9LEVR4rr+5noUnNZsnjge4dwKd3aiTU5UkDj+wUUPS8DGtjAQOSsTylkwW07wtdPqXVQpZVFHYrE/CuKydLO5yqN0eHcFIHQPxhb9f+Fz6GxREszEhR9vFUaIzjnr6y4TrtiSPRJyBZcovkP/GfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jCj4pBkI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cf2714e392so232043a12.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706745379; x=1707350179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yNChpOdBDlQ0ccn6PmbEc8ewiIrWgLKikwCTAZH7kF8=;
        b=jCj4pBkI9HgR+IeJsNF9dobIM76elCbTIgKk4h/ayPUdl0+FYpXwmVuUfJ5PzF8A8J
         CBoHx5a/kZTBxoVcnqcGg/G8QDOjsMQcpwPo0grIF5KUG0GjPbTgF29R6NIQbBcnKX7H
         LEK31rmIqNscZOrex+6NzOcgs+Eidca+ZTFRHdEuFaU+9uwsi7hIAUia2cUHr1R7+myb
         gEHeAQ+s9SpIiDoLRI3NBUHKMJ7Q8oD1JB1c5ju0jA2irn2jmzz3FFv4HOTvX5TRju01
         L68CkRgBJel/SnhCVkJ/MQoyoTkzxnrX/4zwgusRuArJB3Nnpigr5ZttMDLSlcE/mE19
         oDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745379; x=1707350179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNChpOdBDlQ0ccn6PmbEc8ewiIrWgLKikwCTAZH7kF8=;
        b=VAtlTKAjqWcldZfO6LARIiMtF/BThmzTK/2ZzgmKHTbUTRZy6uNcYEl4FbvAiJMpiT
         xjbdUViKyzbHVfNW+Q/48X4RYH9GaWt1Xqmq8hkSeIZEj/dK9PK86W8G54C0YImIrvQQ
         5/xLxrC6PesFBSb32LtoCGKvIufojHCcRdW1aBbesoxc4+QdL1at7DFCvjhkAk/x/IwU
         DzK9Pd4aqYRNuvcQBgTQTIILR94xnngEoooPCFqgNR5miNwqJZfuej8K++HJ2ny0OU4U
         aTIrVrfjruHNp6TQipyAiiGrLur2pVI20Q6zzedBVR9dKFO4CqVVrumy99tHmtGaGTKp
         5vvA==
X-Gm-Message-State: AOJu0YxfU+7v4QwR0teHGAHYKNRRK7G//KvYypyDK0poEat2ugOD41ND
	BZps2N3tpto5M0qySW39Qr5ZTyulpnD+LdMWXvFpMsr7r6UXTbfvVsqPKOvqT1XX2gzifNlFSS3
	iyQ==
X-Google-Smtp-Source: AGHT+IFTr/+IS+bV1DcMzvuzP3zhkalRQ/k9HG3wrh1LLkzsqwYxmu0x9I1ATz04QKIOVB1h9pFrfMHC57Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8849:0:b0:5cd:c9af:ff21 with SMTP id
 l70-20020a638849000000b005cdc9afff21mr191194pgd.3.1706745379511; Wed, 31 Jan
 2024 15:56:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 15:56:09 -0800
In-Reply-To: <20240131235609.4161407-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131235609.4161407-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131235609.4161407-5-seanjc@google.com>
Subject: [PATCH v4 4/4] KVM: SVM: Return -EINVAL instead of -EBUSY on attempt
 to re-init SEV/SEV-ES
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Return -EINVAL instead of -EBUSY if userspace attempts KVM_SEV{,ES}_INIT
on a VM that already has SEV active.  Returning -EBUSY is nonsencial as
it's impossible to deactivate SEV without destroying the VM, i.e. the VM
isn't "busy" in any sane sense of the word, and the odds of any userspace
wanting exactly -EBUSY on a userspace bug are minuscule.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 38e40fbc7ea0..cb19b57e1031 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -259,9 +259,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (kvm->created_vcpus)
 		return -EINVAL;
 
-	ret = -EBUSY;
 	if (unlikely(sev->active))
-		return ret;
+		return -EINVAL;
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-- 
2.43.0.429.g432eaa2c6b-goog


