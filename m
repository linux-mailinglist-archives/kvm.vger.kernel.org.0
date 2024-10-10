Return-Path: <kvm+bounces-28520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5B39990C8
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AEE128424C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260C52040B9;
	Thu, 10 Oct 2024 18:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uDM694X6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88608204085
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584784; cv=none; b=LuD2pu/NzBq2fHklJkEsa+TY+StU4eZlA9cBSUU5PbiACvIM1LvGYWWyENmtIg4HnhMNU+jyzQ9hi/oYR/JerF6wH4OazLAwXylKDlUH2W94HOVg9TKukIa+DYb897CVjyZJfIVVve2CbFcyQR5VrGksRb7cngqNUAwiU68zESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584784; c=relaxed/simple;
	bh=acp8IhS6KrAOGkkRIhpxPxZ31aINXkAYcQRqekRRiYM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=APjL5vScxqGjfRMwPg4XVpvbZu36gFvs5SePFrl93p3gg8Is4k3LJJZptGbMHiKg+UU12Hf2hx/C1dqHRqnrfhVrjW6b/EGYLbfRja8pAga7Z2jwkpZzk2l2v3VwURP2xP2TrQdfOrc3HXQXcCSidIxRAIFKZh7qUCxpDUFB43s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uDM694X6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e29b4f8837so18944057b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584781; x=1729189581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHy2j9VNwFKd5G/Ubc3O4QkXvNoIm5ox3M6XZ4oswcY=;
        b=uDM694X6zZ+HAFlWAM1UtiI7QC1H/CwpkaKKHAjYXOuVOyiyi8G2+ZRbvZR0h01V6j
         8791sMmDTkwkGnskijypQOT+tDDsu2qoAbvNhrjSu8cnn2Yf+uO5xePCPOmvECf9djFK
         fsVWQVcfW3vXWJZ5a3vaAM4SKhoxfc5D8P+vhcEIXDdTEO5XqLZLB1zx45NWSP8UMPbF
         MG11ZZjR+IA7jhtkoRfRVawnyLm9IVUQgSJOtxuEzxhp8dmQ5HIX07OMvFBqgFcoRCYF
         AhIeNaKp3fuopM9y6UO3qLYo5AoppeiYECEIkGUsWLp6Rmoyl18Vp1Mv+YuUwhDmE05H
         JYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584781; x=1729189581;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CHy2j9VNwFKd5G/Ubc3O4QkXvNoIm5ox3M6XZ4oswcY=;
        b=EExEahAHUGzZp/wr2d7ZTQ4he0GHesYpxBEMkPLBYLeLQfStkpFY0QpU9hK3oLfIcK
         /BjKlPEc3sDf9A4LV7PzjzGk7Rh0nY89Dq+uGSJbfU8O+1HKWghmeuThIJF46kS24hiC
         d/+uhyUUUnbrP2q9hou2rVvCyEoRo1iEK0c1XxpcuR5u+OajnM5DEMFS50GXG8pkLKJW
         QmLegMdcUTEZRHewBGIrcCIYTVbdQCoyqzQeSJZL/7Xz4DpSP8GyH7SgjfzrqTtMx9Ft
         J9ESvGv67MYNTmTEWmXljPHriJmL6MOyPLvwSIXIBEbpZ1o/K74NjuFSv8mN5Z+eq87m
         VgLg==
X-Gm-Message-State: AOJu0YzR7jZiaLsiNAV7rY0CQBIzzF01/9ec114jWT4fPh/hpTX4sKFI
	iLH2xsLbnNWJChXP/Sig7UT0fHqwCFeFvSRf4x0QAvr1iE5ib4dAWRaM1o/MNG6xfuRR69sPHeX
	H+w==
X-Google-Smtp-Source: AGHT+IEBXjEpYcXfPYRm3Nf4G9ZN1ucR55aqjscHr2p9QPsSrcRZYI0185ucK64AXquh+1QVcruWQv+kNDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5605:b0:6be:523:af53 with SMTP id
 00721157ae682-6e32f2f4e28mr919077b3.3.1728584781575; Thu, 10 Oct 2024
 11:26:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:45 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-44-seanjc@google.com>
Subject: [PATCH v13 43/85] KVM: Add kvm_faultin_pfn() to specifically service
 guest page faults
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

Add a new dedicated API, kvm_faultin_pfn(), for servicing guest page
faults, i.e. for getting pages/pfns that will be mapped into the guest via
an mmu_notifier-protected KVM MMU.  Keep struct kvm_follow_pfn buried in
internal code, as having __kvm_faultin_pfn() take "out" params is actually
cleaner for several architectures, e.g. it allows the caller to have its
own "page fault" structure without having to marshal data to/from
kvm_follow_pfn.

Long term, common KVM would ideally provide a kvm_page_fault structure, a
la x86's struct of the same name.  But all architectures need to be
converted to a common API before that can happen.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 346bfef14e5a..3b9afb40e935 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1231,6 +1231,18 @@ static inline void kvm_release_page_unused(struct pa=
ge *page)
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
=20
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page);
+
+static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
+					bool write, bool *writable,
+					struct page **refcounted_page)
+{
+	return __kvm_faultin_pfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn,
+				 write ? FOLL_WRITE : 0, writable, refcounted_page);
+}
+
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6dcb4f0eed3e..696d5e429b3e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3098,6 +3098,28 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu,=
 gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
=20
+kvm_pfn_t __kvm_faultin_pfn(const struct kvm_memory_slot *slot, gfn_t gfn,
+			    unsigned int foll, bool *writable,
+			    struct page **refcounted_page)
+{
+	struct kvm_follow_pfn kfp =3D {
+		.slot =3D slot,
+		.gfn =3D gfn,
+		.flags =3D foll,
+		.map_writable =3D writable,
+		.refcounted_page =3D refcounted_page,
+	};
+
+	if (WARN_ON_ONCE(!writable || !refcounted_page))
+		return KVM_PFN_ERR_FAULT;
+
+	*writable =3D false;
+	*refcounted_page =3D NULL;
+
+	return kvm_follow_pfn(&kfp);
+}
+EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);
+
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages)
 {
--=20
2.47.0.rc1.288.g06298d1525-goog


