Return-Path: <kvm+bounces-9409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A10985FDC0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADBD01F22042
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330631552E0;
	Thu, 22 Feb 2024 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MveOPm6P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C8151CFE
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618285; cv=none; b=bneFfYx3w7aikO7yL+kPiFZY8nGPfK8I/Ttry8Ar2Xm4mWsKhK2XT2oGN0LmMwza0BBopnyuUGIdr+CzgiDpnQI6meM4noQy8DvVsWtfvHs+JpNU6xRuLba3DwMl4OWwMbRzh4CVaeDZ29d53CuDXjhG792c1J1f7dhY5QEi3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618285; c=relaxed/simple;
	bh=xoA6/QoNnISiMa1SzXuzX77CZKmuI5864LBCKgX+2hY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V8IQL3yMMXMAGYYH8gMTAsDD5bRF2DmQlqVTuo+cUpr5gTZgW/TSVlZ+RxRzGyUXu0LSFltfV5Ofx4rHqxgsLUaX6QUIY/7sPkzQXLNRhIK6sEOGFu0hammmNgxnj7JVatgDh+h+m+za4s1WDPkrSAMcNmKcIink2MgsZjjrfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MveOPm6P; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so8125929276.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618283; x=1709223083; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CeE6bcXPJ6+XfnAesbZJh5X/3MioJE5wiGBVIwsoMXY=;
        b=MveOPm6Ps15ckSZnNay3zhkDd1Q5b12zgK9lHOdUks5D+OaFbD1/m+WcdmMD8izGz/
         pRKLHQXwN3ccfiDaU3EOBXSfFt4yZ5sl/5tAobhXXmS/IC9XaOdssNyAao/wYaSQNpjG
         sUBwJjpQPcRW3zhYESnx1qfPRLJBMqTFBWW+qURmOynHP0UcqGRq4KN4CZVpZkDc9ac0
         jA8N8KZnZmeFWdH8QKvBtNKXe8wIrLewUNhHtFRwBLq3INsJh71uQPOsIMh3pMu7dHzP
         lw41tX1LlyouIJ05wPz867C0lTIXcoq3uqEInSUHUZmkDaVlkS6gCjwOtO2vQ9fHNk/t
         F1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618283; x=1709223083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CeE6bcXPJ6+XfnAesbZJh5X/3MioJE5wiGBVIwsoMXY=;
        b=FefbJBGt3FX0ySkipv7essK2HzidjUyedUcuof44M3Nj+RtUOyRFIdN3ajHS7z07ME
         IIfJLF1i3QVXQiSt2Vfd9fFoE8xKz6aUjTWo8qwkshZPTmzxD/aI8Au4QszdHuACwMl6
         BWHw5QPpPu0phObpLD9v44HgQko5u1SoQSigMQ1sE/2+UwfKli+oy1iP6AnoCkIzW/X8
         9GTh9TrzRYybcEsuMIclXNT9Twi+012gW426hx01qII6heZ3tnfU4k4kQrbvTKTdMHsP
         eNkeyTrqGvqBgJ9J0dyFjA9v8bqDfz1+kDqCyB9rY19FdSSq7YdGf8OdBxmRYGv/rRLg
         lOOw==
X-Gm-Message-State: AOJu0YzVN+XQ0OY/EDdQ4zWehp68q5vTbLMW1HOOllqkAmBEG7lY5c0z
	Gwfz+OYJoS1bY7Ud+zKwQLfwekgyKD6iC/0gJVhtUjVSqupUlez/y2t8BteZGdz/fqeVQIeY5RK
	EVMUitAG/IvUvX7Dpapkj5soGVLh5LuQA2jzlZ/oJb66RaryVJCiPmDF0M92wuK4qgDJQBckJq3
	eNUGcNwsJ51uxTh+w1sf8zgY8=
X-Google-Smtp-Source: AGHT+IFstTNpKcDxQ2leE1X3c1ER9vVPby1ys0ufBrD4msybQfHDs42OffDOkXrhTSWHmYX9zR+v4HUSxA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1008:b0:dbe:387d:a8ef with SMTP id
 w8-20020a056902100800b00dbe387da8efmr90717ybt.1.1708618282006; Thu, 22 Feb
 2024 08:11:22 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:34 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-14-tabba@google.com>
Subject: [RFC PATCH v1 13/26] KVM: arm64: Create hypercall return handler
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

Instead of handling the hypercall return to guest from host
inline, create a handler function. More logic will be added to
this handler in subsequent patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  8 +++-----
 arch/arm64/kvm/hypercalls.c       | 10 ++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f6187526685a..fb7aff14fd1a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1100,6 +1100,7 @@ void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
 unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
 
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
+int kvm_handle_hypercall_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6bba6f1fee88..ab7e02acb17d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1092,11 +1092,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (ret <= 0)
 			return ret;
 	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
-		smccc_set_retval(vcpu,
-				 vcpu->run->hypercall.ret,
-				 vcpu->run->hypercall.args[0],
-				 vcpu->run->hypercall.args[1],
-				 vcpu->run->hypercall.args[2]);
+		ret = kvm_handle_hypercall_return(vcpu);
+		if (ret <= 0)
+			return ret;
 	}
 
 	vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b93546dd222f..b08e18128de4 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -24,6 +24,16 @@
 	f;								\
 })
 
+int kvm_handle_hypercall_return(struct kvm_vcpu *vcpu)
+{
+	smccc_set_retval(vcpu, vcpu->run->hypercall.ret,
+			 vcpu->run->hypercall.args[0],
+			 vcpu->run->hypercall.args[1],
+			 vcpu->run->hypercall.args[2]);
+
+	return 1;
+}
+
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
 	struct system_time_snapshot systime_snapshot;
-- 
2.44.0.rc1.240.g4c46232300-goog


