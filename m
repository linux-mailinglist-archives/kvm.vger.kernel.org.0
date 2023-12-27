Return-Path: <kvm+bounces-5262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A21BE81EB17
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 02:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D093B1C220F4
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 01:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834961FC4;
	Wed, 27 Dec 2023 01:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hk5d3yTj"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F29290D;
	Wed, 27 Dec 2023 01:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1YmUkz0VIfT+7ufOGukztD/52zdqDSYrXiOaVrLHV08=; b=hk5d3yTjOJ1sAQVGNhUg5ePQrZ
	Z0sjl9lc6F4QreZ2k45x0xO7y2mm3MIHITLd5B8AflR1UrKM+K3EfW4w1dfekjddS3qW0RrI2SYdp
	ptokQ6EBGcYmQ9VIXm4pq7W5R5phqGibXzyuxbzzRsGXs99Jj5k2Aldg7KYWVepZ5r8ihqjwRWqdT
	mPFT/4HfwWnDn6cmbbkRbGMeGUX8ynyxj8XHnRMnXQVBNnyDqSSDZZ6QMLp7ZhEzbKMqUG8wsUm72
	HW0qCV6Ok0OunyMYw9wkA1TfxPNrvQzmOCaZkOnA0S++LxzaWbpKB5MdQcNePe2j2ye9p46BfxKx2
	J8WiPO+A==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIIOc-00Djz9-2U;
	Wed, 27 Dec 2023 01:07:42 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Bibo Mao <maobibo@loongson.cn>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] LoongArch: KVM: add a return kvm_own_lasx() stub
Date: Tue, 26 Dec 2023 17:07:42 -0800
Message-ID: <20231227010742.21539-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stub for kvm_own_lasx() when CONFIG_CPU_HAS_LASX is not defined
should have a return value since it returns an int, so add
"return -EINVAL;" to the stub. Fixes the build error:

In file included from ../arch/loongarch/include/asm/kvm_csr.h:12,
                 from ../arch/loongarch/kvm/interrupt.c:8:
../arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_own_lasx':
../arch/loongarch/include/asm/kvm_vcpu.h:73:39: error: no return statement in function returning non-void [-Werror=return-type]
   73 | static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }

Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/loongarch/include/asm/kvm_vcpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -70,7 +70,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu);
 void kvm_save_lasx(struct loongarch_fpu *fpu);
 void kvm_restore_lasx(struct loongarch_fpu *fpu);
 #else
-static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }
+static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; }
 static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif

