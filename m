Return-Path: <kvm+bounces-17166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D4CB8C2364
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08515287638
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E801017554D;
	Fri, 10 May 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4riQuE5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8502171E5A
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340445; cv=none; b=g8tdkQCn2AAN/xiTPJ1TWlXes8TipiKgKe7yoCSeHGilm5rzEGUCa7FLTKM8+Az9iGiOQD00jnJoI7OCJwzZr3O3RkcefXh+s15l33V+mA1T6wDCaK2VYThHNOfcA8axzwdxNCLCjbGAxpaWMvtzQ5gDm2dmb8RfopMPExJTkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340445; c=relaxed/simple;
	bh=A//g+5Ndpfg+WpD9P8dw9I0KPXkUbDOvYBE0SxR39LU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u7BZB6VBq3XC1uyystQBlfmw4S4gh7vfSyc2l4u9RSdtCkHV9DkuP0sUcR0u17XrS629y7Lwm8ctBgDwoYaTXv/1QqQoJrrNEVapFzrz3ybA3GcaNgV2uvpupaUHInH5f+2VodMKBt6gxdsVjCf9otYxsJx7EEQEQe2nexZxbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4riQuE5Y; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de74a2635e2so3081724276.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340443; x=1715945243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sbYsZ3117akP+PvJr9gYUoi/CIT+2oSEgeDr5jj+0nI=;
        b=4riQuE5YQ22hGQY2FTloVDoIIGm1YDyoy5QorcBWuvdfIpmm80lVJargn/IdVPJ8O8
         ouVmoeCqXXYGAdrMAluF0FTfraCJtFBQDQRGEtziIz16aLREme9UUdmi239JA9bF67og
         aZA4+8VBhv94QWfnop4wbG7JBLTlEpSUTHQj2jy7BfLew5O//U6wAhBnHmf5O6G9JO0B
         ogBxqUQc6T1D+RDCzMA4TlAzDVxYPuWGbzCJRJD77wW2gDBepKTS2n2dot+t+JrTg1VV
         7eJnmLItZJ2kcRupZYf8BdUmOtu39wtyk1Zj59Wa+AunJCUW9iW+97RON1ELrlbRvDAY
         F8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340443; x=1715945243;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sbYsZ3117akP+PvJr9gYUoi/CIT+2oSEgeDr5jj+0nI=;
        b=uWyZl4CoHVSrQvD5EC/Q6qvcL9vk3WXfGlThNOZNWWwfJ8XYNNAbb/rzoZLEKpOmz/
         nw+6eGJhx131qNbmPAAHKlLwgLxH0JV7LJPb+65YaNiRtUUu9RkuZLr8UpGs1KZ090Mk
         Fm0uCyy6SobrjFAxaypzWfQiThDVU1PsnpdnIOxyHrq9M7cLNHZFY+AmTtrTZjpg3DAD
         vPMiIYZmkYK/R+I3REcYkXrehYVMZVjuIlmQAYaIDAnh2PQkgNrmhrdb3cnTlYbn6lDS
         tU+z2V3XOJrbQc//ATbFpph2qp+N8xdP1CSHsK4lLB2xrHQ1eXvbDYqAwjvvT0AX1J4e
         SdDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNsbEvZILPNHUlObfm+bKFv9r9J+NlpUp60j0DGftbnnp/Y6lDJ9tNo4soTrVYgsvuBTs8F71fOwAf1v3+cW0rLdYk
X-Gm-Message-State: AOJu0YxUxet5DzU+gtcIAi+zb1sIP02pZSo66S/yPWm7xM6bNp4WJ5Pe
	kwpNVdOob7NsdJxB+kFv5rihf/50FQJseI0Gka2LoQWaFYTvFSTpXIZXs63lKsXdcKgcWfFNtw=
	=
X-Google-Smtp-Source: AGHT+IFdj/b7v+ntFzmw+lLCR1C20+GpqYEhAi+SWxria6LS62T7NLsO4dOK8hYMQ4bb7TazgmL1bjHlFQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:100a:b0:de0:ecc6:4681 with SMTP id
 3f1490d57ef6-dee4f30f764mr166230276.1.1715340442754; Fri, 10 May 2024
 04:27:22 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:31 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-3-ptosi@google.com>
Subject: [PATCH v3 02/12] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL=
2")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3e2a1ac0c9bb..96daf7cf6802 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void))=
;
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index bc58d1b515af..bcaeb0fafd2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
=20
 	BUG_ON(kvm_check_pvm_sysreg_table());
--=20
2.45.0.118.g7fe29c98d7-goog


