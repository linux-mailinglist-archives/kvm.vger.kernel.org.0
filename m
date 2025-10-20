Return-Path: <kvm+bounces-60524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6146EBF17AC
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF4E8403736
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 13:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E0431E11C;
	Mon, 20 Oct 2025 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yt7vHsbq"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB01719047A;
	Mon, 20 Oct 2025 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760965952; cv=none; b=KNHua1j8PcxHv2PylqeGRVOr4HCWH2zGtnU9NRZqcbWnh7EUAVCnXjRoG/01/j4b/HmPrspQnQGwMy/W8ZhEIbFqneESzd69D2yhxYsOb194eAN08yeIytxqqdqT3ianukaXimMRBI2KVmcTWkp0Hy3dPNriWVKbyWEcJ+ms3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760965952; c=relaxed/simple;
	bh=DrL2WwRNEFOK1bJtIv9ky7I7c7G4ou42pOsCGy3RwiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GoPKCA8hZ+ilfKiH5FEnK9C/XOHUty1fyS5gIphDWKNc8OaYFqepQd3FlbLSTlb+xots7MW23tYAHfrTlSzYwHD6n6IIZBM4lqKo34j7fwZOyRi+ajMf7+vFCM/VqUq+71Wl4PvSSWfwFO8cTCLxwps/RlcZLx3sA2EEyXwyP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yt7vHsbq; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760965942; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=OBImoBy0givvKDy/jG9fhQjUBUsrZdSED+mmJaxLZFs=;
	b=yt7vHsbqPBhzj0C2lFsoFC37Lw4EKU9X3/YIqJbl2JsKsj+q5iqRE6Pw42NtzGH/Jw7e4Vahh4G+wvgBPdRmrq2Lw4nDA0ghd8F/sXjyYkiprt1WzcrU/xj5JF7jFi+CzhKrfDHosv1+tY5dZRrphQH0WpxOGxFT4joOIFhJkZE=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WqcnIPA_1760965938 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Oct 2025 21:12:20 +0800
From: fangyu.yu@linux.alibaba.com
To: ajones@ventanamicro.com
Cc: alex.williamson@redhat.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	iommu@lists.linux.dev,
	jgg@nvidia.com,
	joro@8bytes.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	robin.murphy@arm.com,
	tglx@linutronix.de,
	tjeznach@rivosinc.com,
	will@kernel.org,
	zong.li@sifive.com
Subject: Re: [RFC PATCH v2 18/18] DO NOT UPSTREAM: RISC-V: KVM: Workaround kvm_riscv_gstage_ioremap() bug 
Date: Mon, 20 Oct 2025 21:12:18 +0800
Message-Id: <20251020131218.68932-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250920203851.2205115-38-ajones@ventanamicro.com>
References: <20250920203851.2205115-38-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>Workaround a bug that breaks guest booting with device assignment that
>was introduced with commit 9bca8be646e0 ("RISC-V: KVM: Fix pte settings
>within kvm_riscv_gstage_ioremap()")

The root cause of the guest booting failure is that an HPA is obtained
in the kvm_arch_prepare_memory_region.

Here [1] might be the correct fixes for this issue.
[1] https://lore.kernel.org/linux-riscv/20251020130801.68356-1-fangyu.yu@linux.alibaba.com/T/#u

>---
> arch/riscv/kvm/mmu.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>index 525fb5a330c0..994f18b92143 100644
>--- a/arch/riscv/kvm/mmu.c
>+++ b/arch/riscv/kvm/mmu.c
>@@ -56,7 +56,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
> 
> 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> 	pfn = __phys_to_pfn(hpa);
>-	prot = pgprot_noncached(PAGE_WRITE);
>+	prot = pgprot_noncached(__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_READ | _PAGE_WRITE));
> 
> 	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
> 		map.addr = addr;
>-- 
>2.49.0

Thanks,
Fangyu

