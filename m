Return-Path: <kvm+bounces-5265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 646F181EB44
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 02:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3355283485
	for <lists+kvm@lfdr.de>; Wed, 27 Dec 2023 01:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138CA1FDC;
	Wed, 27 Dec 2023 01:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xNkGEoU8"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D61C3E;
	Wed, 27 Dec 2023 01:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SuZFcoL6i0kMdM6kD/totFTlC3QefOClRnBM4XrBqqI=; b=xNkGEoU8W2YOPy99YSbSwfTb2X
	9TVDUtwsIvSZFHkSIErhjTrIyzaO8yvHnT/vmaQsfQO6ZP70iWmZ+UHO0HJ8LARfQ/2ewkB8g4x4A
	eDH2pNJTDmpSftzLOXuqeuxMCEFRd82lU/AzSCNF9kJjJjVItMZVyP05pMw9YIDnARTjDsULCgsJP
	4N8sJ7+RFRlakKrvUObPc4MAsa1SkZxQvsc/MQ/i04RlF0UW0cFlyJeefmT/YHMXpdf1H+wi65s1Z
	cSNRbWFVWH/mJTWchgOe6cz5pyAAevJwxWscvdR33zEM7591nLfBOrqcMryHgbf6tTR1bVVwOfUOA
	NKyX1H4g==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIId9-00DlNz-19;
	Wed, 27 Dec 2023 01:22:43 +0000
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
Subject: [PATCH v2] LoongArch: KVM: add returns to SIMD stubs
Date: Tue, 26 Dec 2023 17:22:40 -0800
Message-ID: <20231227012240.6545-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stubs for kvm_own/lsx()/kvm_own_lasx() when CONFIG_CPU_HAS_LSX or
CONFIG_CPU_HAS_LASX is not defined should have a return value since they
return an int, so add "return -EINVAL;" to the stubs.
Fixes the build error:

In file included from ../arch/loongarch/include/asm/kvm_csr.h:12,
                 from ../arch/loongarch/kvm/interrupt.c:8:
../arch/loongarch/include/asm/kvm_vcpu.h: In function 'kvm_own_lasx':
../arch/loongarch/include/asm/kvm_vcpu.h:73:39: error: no return statement in function returning non-void [-Werror=return-type]
   73 | static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }

Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
v2: also update kvm_own_lsx() as requested by Huacai

 arch/loongarch/include/asm/kvm_vcpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -- a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -60,7 +60,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu);
 void kvm_save_lsx(struct loongarch_fpu *fpu);
 void kvm_restore_lsx(struct loongarch_fpu *fpu);
 #else
-static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { }
+static inline int kvm_own_lsx(struct kvm_vcpu *vcpu) { return -EINVAL; }
 static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
 #endif
@@ -70,7 +70,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu);
 void kvm_save_lasx(struct loongarch_fpu *fpu);
 void kvm_restore_lasx(struct loongarch_fpu *fpu);
 #else
-static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { }
+static inline int kvm_own_lasx(struct kvm_vcpu *vcpu) { return -EINVAL; }
 static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
 #endif

