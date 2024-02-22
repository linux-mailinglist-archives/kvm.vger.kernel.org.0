Return-Path: <kvm+bounces-9410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FE185FDC1
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C594F284002
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9335E1552EF;
	Thu, 22 Feb 2024 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sH37pWqd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445251552E3
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618287; cv=none; b=eO3mFGOnAv/mdNqP1qf4zjlV++YAu9CkVICClFlLbu4lLuJV8YG4hL2NueTYnKQepvS3qh9nJUVMHRy8R/w/9qVvC17PFKY6wk3+AkMcB97CJiokallxnQXLUOf5QmILN+WDhYrSofCmH+viEjGx+PZ8QyrYQtljnJZ31P/xJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618287; c=relaxed/simple;
	bh=1fhJh/ibEAt9iibbZOz9A9qGlg/9anxYzd7bD0l9kms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ked0GzRoePiRSoSGZLOASp927i8hxAsdW0nJUqCQvzvz7Ljyt4ragKD6gLNmQsUXZ9psvGBOspzjoh+8VQ1A+FvcgVlbkf85TGnA3z2j2LfNWHFEzvcaXq54s7VJfk0mKuYhGRd/TgSITTyquEjqn2eRkV2AAkGXB46K87eyaV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sH37pWqd; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4128db855f3so1734895e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618284; x=1709223084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JeXGqmOcCD6OWH01LjQYoqIdkS33u4slmuUVqoK/zr0=;
        b=sH37pWqdFEi4XHn1W7YLO0yXfEBfkEa+wtUAhxvPa78BHWHfF+Sf8vxRYQw5H3Df9F
         RW2GxBHtdjrwgMfzbv7IabvIrTTMXVN/n2zgE8DeA+osTpqbmAv1acPsgzGZDKUo3Yf3
         yHDUtFDlwM1iuev7Z46vmN7o7GHxdlu4DXZHZZJX8+gD2xgqNZ8NPscV/fIdEg32yM81
         hT+Ezc5KXHTMtQZ3ERPULyxsrwloKZUxvWeCtyYuGvzMm+42E3W1TztdBlEmFysA4+BW
         k+OpveFlOEaNoTa9AZBZIO03lvea8Qq2AdKGvBTUCf4lEtCNM8+skWooM8i9YB65bNT6
         2wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618284; x=1709223084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeXGqmOcCD6OWH01LjQYoqIdkS33u4slmuUVqoK/zr0=;
        b=i6QliUY8tLxLbRrHEjlJs9eH0fzz6iUv6EjjA+cpyjs/pDTz2g5zRDBOcehCQ6cOXk
         c4yGiGvqy6Oxwe5vVAQgwNmdXu9SKw9Tq74KWeEq2OJz193bbJljGlP5HJeVNVQn4XCh
         7OwMMqZcAyOUsUJ5JGqicIPxbJBNJjLZI7mTeQE8/3YL2JvrRll2iNIjt7D70bJsrfQG
         NTe68xGUwYMvNSm+bv6+siZd3NLq8Ejpkf+iK0qd7ApkILk91ERBvA6gQRJGvBL0A9uk
         aU6geWojiy3h4OHw7lFbaluFv1/LFlpe+UL/pSd4xUTQtrFmwzfQ+OB8CLqsMJJO1cdO
         Qi6g==
X-Gm-Message-State: AOJu0YzEAy3Ezyf0St7e+iU3CXO322bh6W5ruzyFl+hwwDpG6JYCrqmL
	eZsreWnOocNLPZKLVGx2QKrQ0wXGA8y5rCaybWnHW2NleEBDPkdS9GCmDQXR2aN1WzsepK+kGWE
	33/La56wyIJNUcyRt8tWZeDyk/ePlSHyHkej9UsxM+3CVUaenQDIBq027AQsTeDENhMBf2yaPUK
	SuyzzjpsuKh7qwv4tCpmyoi+8=
X-Google-Smtp-Source: AGHT+IHKd6JqGW6Vstnw5Qq8fNH5c73bty2H414xCAYg3AGlYLFMhVl1S0JC1GCtT88jjKDZLnmCrPVUzw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1f17:b0:412:72d3:cfdb with SMTP id
 bd23-20020a05600c1f1700b0041272d3cfdbmr24338wmb.2.1708618284296; Thu, 22 Feb
 2024 08:11:24 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:35 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-15-tabba@google.com>
Subject: [RFC PATCH v1 14/26] KVM: arm64: Refactor code around handling return
 from host to guest
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Make the code more consistent and easier to read.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab7e02acb17d..0a6991ee9615 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1085,17 +1085,14 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	int ret;
+	int ret = 1;
 
-	if (run->exit_reason == KVM_EXIT_MMIO) {
+	if (run->exit_reason == KVM_EXIT_MMIO)
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret <= 0)
-			return ret;
-	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+	else if (run->exit_reason == KVM_EXIT_HYPERCALL)
 		ret = kvm_handle_hypercall_return(vcpu);
-		if (ret <= 0)
-			return ret;
-	}
+	if (ret <= 0)
+		return ret;
 
 	vcpu_load(vcpu);
 
@@ -1106,7 +1103,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_activate(vcpu);
 
-	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->flags = 0;
 	while (ret > 0) {
-- 
2.44.0.rc1.240.g4c46232300-goog


