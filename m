Return-Path: <kvm+bounces-47427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73845AC1827
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6598750830C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EEF12D29B5;
	Thu, 22 May 2025 23:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QeE7hTOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58D2D1930
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957071; cv=none; b=pdRBi5HInbpT/nqccRIZL3rRhHsax2wf+f0VD/11fVtU3WxGDwN2J5dnZ1nGTAED/PsV5GdUi4JnkdGYRvw3u6rvIBKcNq9aND+oj59UGvGGDqn6+YdbSEiqMJjbOEdxzN3AT+0hn/TktCbszP4hATsNyPzBtsk5PYA6+bN8aYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957071; c=relaxed/simple;
	bh=rKtp5xfoIimuXjCjQBqX07AVfylVXbINV44Xdk84ous=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K7f+LNg0V27fmfa+gcbeumpdl3Mp0Zruh4cI9YPIyEiLSV22pWEp6dbvAyQKfuDgerWdaU9uQyPiyzHAfQNFyT3N5CdhX8PZCQEXeXYBlmBnqZKB/q6dvjhVecHIH2JuU5x5PHofrYFXR7g4bp/F2DdgPFhIe/pMXfrFpZaxfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QeE7hTOb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310a0668968so2191937a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957070; x=1748561870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DbY8RCgDJTqdxQLDkHfni+7ks/LJfloWj75h6P2Hb4U=;
        b=QeE7hTOb64D9guwsXs+QkxPqYqYyi4tckCb6dBIQCy/QwDk3F3zWNriozymP22c87p
         esHTVkdLqxi5iK1L+g5FlfwBhstHQiQulee1DtNVui1J9q5F19l170gzDd4gIwfAYtS0
         qpqI21bdXIJ5BQvfGzsq5EU6/SVI8EWAr9mKea1SOxdbPHnUFjQ+crwtSHmXyufQtePA
         0WXfyxc8QD1l1g16s3Vkb1rVR6WjChtrPNYAcOiNNwPVSW/khx6L34+P7gw9TVs3zyyP
         xobfBwCARAQSh67DCUGiqXxbF/H8OC4l2stYu4YsdqgB9baPa6bKWqP5T1x8MYLCq8Ke
         oKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957070; x=1748561870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DbY8RCgDJTqdxQLDkHfni+7ks/LJfloWj75h6P2Hb4U=;
        b=plL9vbTNOQF/yVIxxDj2TD41cTcmY5rWdlNjJ7+iHj1eO7mJZwcdJWyjz9g5vCvnfW
         fCaibFyN4F6xMlaPBEmDoNcn6vkpZWtfqjm4wRim7QOCKKz+EsyzSKppL/g3qcOkirQ8
         8NJssLrBK5LtAaRoB6G5dNnmfx0QaUGsbdqiOdbNevhfGbia5x/lrDdjtCLnbnQ6onhW
         vhcL4KxbH0qTrbd6TBsPgIqMC8TmoPATsLMRSEoZ1iP1Sv+LNL0thjv7jgl2RBZCUMh2
         EFzYdZBQ9ANKu4qx4PQQWFgM/W5yUtSiqdmcp+txJWAzLZx3U2OktAdnPDQ22NEovTQW
         xrNA==
X-Forwarded-Encrypted: i=1; AJvYcCWEkYtolPz7xttBWX9hwRhemLGt1QEIijHzFsnKE64bc0JINo/yo254nMTJvLK8O6N8hHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOLidhR5pxfV+y0sLCkQii4/bCktWrjl45OJ/EU8Cq6SBkNVra
	d3HAFrZYlFeJ9Ng0pZ/ylOfuPMJQMlx2F/nlA4KQFZrachsjGS3nqAUXSX3jIcmuc6pI97fq9dM
	cVAdqvw==
X-Google-Smtp-Source: AGHT+IGjzBQd6j4J8ysyd/Avsyzv8cw/ixuwdZ+zXrYI9Hkoyaw+vaTqL9WLjC62S+SSSB53dg47wGK8xzs=
X-Received: from pjbpt3.prod.google.com ([2002:a17:90b:3d03:b0:2ff:852c:ceb8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4e:b0:310:8d9a:eb1c
 with SMTP id 98e67ed59e1d1-3108d9aeb4fmr12062419a91.21.1747957069850; Thu, 22
 May 2025 16:37:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:29 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-6-seanjc@google.com>
Subject: [PATCH v3 5/8] KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use wbinvd_on_cpu() to target a single CPU instead of open-coding an
equivalent, and drop KVM's wbinvd_ipi() now that all users have switched
to x86 library versions.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d0e9180148d..d63a2c27e058 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4965,11 +4965,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return r;
 }
 
-static void wbinvd_ipi(void *garbage)
-{
-	wbinvd();
-}
-
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
@@ -4991,8 +4986,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (kvm_x86_call(has_wbinvd_exit)())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
-			smp_call_function_single(vcpu->cpu,
-					wbinvd_ipi, NULL, 1);
+			wbinvd_on_cpu(vcpu->cpu);
 	}
 
 	kvm_x86_call(vcpu_load)(vcpu, cpu);
-- 
2.49.0.1151.ga128411c76-goog


