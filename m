Return-Path: <kvm+bounces-9413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04A0285FDC4
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35DDB1C2353F
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F186B153501;
	Thu, 22 Feb 2024 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pra2o31n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7240155306
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618294; cv=none; b=kgJRH1j+Bp0tGNZu9Zzi2h/NaimFS13RD+DMboW9K57vK5iLZq7cW4RUUTwNTN6uhFCyuC3anhijzG76VYwHGV+7JZm56j0hJWKcBrPp8d7G6FCRMnAz4vtXOlWYsP6kV590nD9iCgFg4NJUqe/Pbte8n7RZjr887FMpGFF0M2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618294; c=relaxed/simple;
	bh=6iVb08zKfzH5hJWQLjCXBzmY+3QGd9wO5l8hFYC0rUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJATuQv+fXSlNUlXkYIU7XyUkxZe8sNjNaK4xLJb8XT2lIeHnreR/k1x7/WJqWkSwUIEb3yw8BYigieY0LOJ/sp3cxeSgJP66BvZsfeKc7O3jfRRj+pnY5yPC+4r47FvMskmBYm98HZ3aDuAUboXP/cBhrEyyTUClwd8c5V1fOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pra2o31n; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33d30a3d6f8so745892f8f.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618291; x=1709223091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlwq3mGjsbZmc2k1s/E60FvUuielQ8IuRYRmKjrhRfg=;
        b=Pra2o31nKDs5pTi+NbHICuQEeHEJpLNYYK7+XQvN9cGrUBWkKKYtDu8XbILqYsbPCf
         ciX/2j4ytxMP+8xriN6DNUNLWe7c0IzEjfy7UKAFRUFtE17+UFRzdetbt6bNgUdB6EoD
         wsrjDLHypEqLeYbNq0gblxGqWZ3FTEkM/0UULg4KbJhAe+rvACXyzN6sKvAgCzoMewPz
         PumFJiBN9ZTHppq8sepYHfncuQL4X18SbT88S/H4KA3tNAQ9meME8CJEHe3qcpHjF7+d
         o8sSMJbuj88cN+U6QU588goYMGtHF8YDbHrd/V0XfLXMZqdVHYJdxSMyxbIXDgEG/v6S
         BmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618291; x=1709223091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlwq3mGjsbZmc2k1s/E60FvUuielQ8IuRYRmKjrhRfg=;
        b=LzLCXlZgSpjj3pz2YDU1RSonEKHKqheJ9kTHB57JV788n6TgT9T/yVyZd+pwVqK5o3
         1oWiHYb+dSdJxJx7I5tGVNxP763U8XVi8WxeokpvtjsWmgY3SBlViXdRRvruK7nxS0wN
         w3WulkWYsZjuwgFiNTTm/w/xz7ad/gae4mdGEt1xKYkFdytourozmgAiUIn6+wdYVxa0
         u2tkxWPXW5GGLszPpgfab9yJNbJB5aIi35Lak+1p1mcSeRRI5rlQxZ5RcZDhgIRiUIxD
         S3/vsWUBpRqYYHhqJrHLnVJqS6tqoqgTjajgxLw8vlvf1x6pc60OARwYrlcSZAq+kZED
         YigQ==
X-Gm-Message-State: AOJu0YxrxQ2oEaIDd6aRntRlWGs2n9hOKUp5djkPignKa+OttQQHO0BK
	xm5N85h54noJ/DfAfXGBfq/LeQP5uQRZ7I33qLLqluqoVP6DJ4BrzEcKas7oTOpRjbOWcMl2nz4
	pEKhlovLG26seRkrcKYkVUlSePIqzif/9DJ4WUnYwcAvHSZZVJlRaFH/uz8dI8t+WvtoMpEOTY1
	zrQrqgo50LJKG2UsTRZYYen/E=
X-Google-Smtp-Source: AGHT+IGPBlBEWHSVTXybSf5AXKW9r7iJYYYJVo0ATzUwHor8Yu6mnFaOUn7raP8SctTXcV/NU58hv2UYQg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6f18:0:b0:33d:9fc2:5e26 with SMTP id
 ay24-20020a5d6f18000000b0033d9fc25e26mr109wrb.9.1708618291025; Thu, 22 Feb
 2024 08:11:31 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:38 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-18-tabba@google.com>
Subject: [RFC PATCH v1 17/26] KVM: arm64: Do not allow changes to private
 memory slots
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

Handling changes to private memory slots can be difficult, since
it would probably require some cooperation from the hypervisor
and/or the guest. Do not allow such changes for now.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 391d168e95d0..4d2881648b58 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2158,6 +2158,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		}
 	}
 
+	if ((change == KVM_MR_MOVE || change == KVM_MR_FLAGS_ONLY) &&
+	    ((kvm_slot_can_be_private(old)) || (kvm_slot_can_be_private(new))))
+		return -EPERM;
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
-- 
2.44.0.rc1.240.g4c46232300-goog


