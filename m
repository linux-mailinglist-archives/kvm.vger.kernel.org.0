Return-Path: <kvm+bounces-28517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F6B9990BE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D5121F24462
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC045202F74;
	Thu, 10 Oct 2024 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gciGGDh5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C0B202F66
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584777; cv=none; b=X6iWYT7p1qY3E9dpMRWfNtHRGmhmXcTNMez8HcjDxA6q9H0y3Bi1PtkJbEKNw3nuP2BQE64/+J/MXdRubmSDUoTnLkVmMXFGtu5h0MU14bl9ixljRJDnAcXu+OmZTdzVomCbR9f1zAbMLCgpRfwU4pq9JbA1DutoL71dtrN5dik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584777; c=relaxed/simple;
	bh=PQXxus6kr8nuokmnnM+Lbqq2T+wYMcW3c8L/2YrIVXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MwZm3FNB58mXKYcj1TV5HX2/QdISqL0MLrRPKMdPtn4SiShpdG6fcoDhfpvAovrqU1kK0MDW98WmJje3EzldJzJ3tGHNvT3u1AY5S1zivUItci7lUQ2UDHbmQ4pp5smcPObfwC/6WeOH04dpqmgD50mJNq7Tz+eswHjfv53ep10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gciGGDh5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e123d3d22so1428899b3a.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584776; x=1729189576; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAJaAoo95YXsHy4joQlb4gblEl3cKLpcYsG4EH0XckI=;
        b=gciGGDh5HFpYWLuKNpe3Ev4O1droYOafPNHG8yohFPMnZzjhRji78ghkqI9VqZhT+B
         Juf6rcXU/vrIP8E/Z1uAY9snG3nfyrtMdkveyBqYvx2MzjD4hY+IMWPMKq+/pXqVwVGX
         ea0byuwg6VXoi/3PVusUXLHHDb//D85kFO9B+vfoit+AWNu+8Ifoj/K1gWHZ1ayEP7bM
         5W/mtnUCiPZ18zjIWT0zKiLM5FJtZBfhithRFXzW4f9XDSnPiQ81VGioPPD2PpwuXPhl
         XqHt3I/ZMv4OFkktHewNKir892D4AGcVInKoLbwo/PslHwbVt4L20OtMF8zjtlhzbESm
         QwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584776; x=1729189576;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GAJaAoo95YXsHy4joQlb4gblEl3cKLpcYsG4EH0XckI=;
        b=W70Ev+bYGbCFx9qjYqz/TcV9r8SeSeSKLCZtJlrs2S/Lk6gI1IfFrpi9oHgA4Gyk9I
         FJYLNcJ759wX8KWIMVbgUejQKPJhgC6JnRmdgWFq4FuhUZJjNtq7rjL8n+To+7H5W+pu
         eJOZGDfEqUq6LfgVACvhL6zVrQHIRUAfbhqtV8Qz3FyzkJrP6TIw16oDEzm7lbOn53ZW
         QNM5AlqMJ0EuQ2vuLEbQU48lKA9MzxCREfS9SIpgmMpzwuTO8HH/a5RyWkAaYINpC6N8
         bTGEsMTC5I9cx23nZXVSWN0UpGOkDxBLPU8y7OO3hRiBlv6ms1236rN55czfjxr1JjH9
         /n0Q==
X-Gm-Message-State: AOJu0YwnCajRl/4ON+bd86W+pIqwI6T6iz7iq7IeA/PZCSPOwkM+dLvK
	ZpZMtFDRTnuXZsrvTdGIxq9SuAo8lXvihLTyxf/KMYJxwmU8MDepI1066tIvdIlG9uP7Wth9sly
	QJQ==
X-Google-Smtp-Source: AGHT+IEXxr/4vsCtgUsUHHkctm5xGRqb6tsNipBtkL7vgMjj75AzVZauqGsQqnffIf336Hhi8e9e6vZrhMQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:9184:0:b0:71d:f7c9:8cb3 with SMTP id
 d2e1a72fcca58-71e1dbf1ab5mr7792b3a.5.1728584775458; Thu, 10 Oct 2024 11:26:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:42 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-41-seanjc@google.com>
Subject: [PATCH v13 40/85] KVM: x86/mmu: Add helper to "finish" handling a
 guest page fault
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to finish/complete the handling of a guest page, e.g. to
mark the pages accessed and put any held references.  In the near
future, this will allow improving the logic without having to copy+paste
changes into all page fault paths.  And in the less near future, will
allow sharing the "finish" API across all architectures.

No functional change intended.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 12 +++++++++---
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 65d3a602eb2c..31a6ae41a6f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4357,6 +4357,12 @@ static u8 kvm_max_private_mapping_level(struct kvm *=
kvm, kvm_pfn_t pfn,
 	return max_level;
 }
=20
+static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
+				      struct kvm_page_fault *fault, int r)
+{
+	kvm_release_pfn_clean(fault->pfn);
+}
+
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				       struct kvm_page_fault *fault)
 {
@@ -4522,7 +4528,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * mmu_lock is acquired.
 	 */
 	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn=
)) {
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_mmu_finish_page_fault(vcpu, fault, RET_PF_RETRY);
 		return RET_PF_RETRY;
 	}
=20
@@ -4598,8 +4604,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 	r =3D direct_map(vcpu, fault);
=20
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
=20
@@ -4685,8 +4691,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vc=
pu,
 	r =3D kvm_tdp_mmu_map(vcpu, fault);
=20
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index a476a5428017..35d0c3f1a789 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -836,8 +836,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, str=
uct kvm_page_fault *fault
 	r =3D FNAME(fetch)(vcpu, fault, &walker);
=20
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
=20
--=20
2.47.0.rc1.288.g06298d1525-goog


