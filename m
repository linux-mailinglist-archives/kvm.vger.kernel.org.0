Return-Path: <kvm+bounces-54343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4AFB1F203
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 05:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A20B218C7D0E
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 03:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44581226D1F;
	Sat,  9 Aug 2025 03:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mV7GIZkl"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3815A848;
	Sat,  9 Aug 2025 03:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754711496; cv=none; b=W4+uxwezXudYJeNAkfIpHVB4D1gEOksG2VZgA2QtTeuse8XD9pHyMWKKTWRvqe0j9MZRjtSN6zWMXCfXtUxjS/lFuAWp+gRii6nVjP1HYdSDXNZpMmsdeb8FFx2y8P1dLRIMsWLarC31q03zcOg8puYHPLCWBlf51n7eupFXCFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754711496; c=relaxed/simple;
	bh=yzPOU2ik3IfjjRNCfP/IOlGUdX8k+21WEE31iQP+/Cc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HoweXpM3wKEmeacvgrMTLhxTKBAPzO4dt98EqUCn+X0D+EP+vsQOz2CYZWHFAolYSYBqevkngHkD/fLI7HqEJCjMoKBlzPlo5jX0BG4Py7/r0nr+0/FDdMGLsKmAMwPvFh2b7UxiBpm77srAjTMpOke4U2oiZTnA0x7GgIS1URs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mV7GIZkl; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754711485; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=XH3EkbdWVrqttexIEF23qR/7W6J8fXZ+aOIZNR/WZ4k=;
	b=mV7GIZklHbVXv4+uW92Izf+W58MfqrpLMzfD1BjSZvtNUiUGsFYoGRlsvhvKZzLfe5OdsBbp906GV3k87UfyU0xQSGKLDf8E1zvNslFQSWlG17naOOkn6TRw4ztjnDFm6lo3DzQPRuPsFSZZVYlnQs2mXV0LwPNuVWe3RfUal8Y=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlItg7x_1754709625 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 09 Aug 2025 11:20:27 +0800
From: fangyu.yu@linux.alibaba.com
To: rkrcmar@ventanamicro.com
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv-bounces@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within kvm_riscv_gstage_ioremap
Date: Sat,  9 Aug 2025 11:20:20 +0800
Message-Id: <20250809032020.51380-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DBX0JNR61UNM.Z42YERAKRFR8@ventanamicro.com>
References: <DBX0JNR61UNM.Z42YERAKRFR8@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
>                                                                    ^^^
>                                                                    hpa?
>

Yes, I think they mean the same thing, RISC-V IOMMU Spec defines spa
(Supervisor Physical Address).

>> guest interrupt file within IMSIC.
>>
>> The PAGE_KERNEL_IO property does not include user mode settings, so when
>> accessing the IMSIC address in the virtual machine,  a  guest page fault
>> will occur, this is not expected.
>
>PAGE_KERNEL_IO also set the reserved G bit, so you're fixing two issues
>with a single change. :)
>

Right, The G bit in all G-stage PTEs is reserved for future standard use.

>> According to the RISC-V Privileged Architecture Spec, for G-stage address
>> translation, all memory accesses are considered to be user-level accesses
>> as though executed in Umode.
>
>What implementation are you using?  I would have assume that the
>original code was tested on QEMU, so we might have a bug there.
>

This issue can be reproduced using QEMU.
Since kvm has registered the MMIO Bus for IMSIC gpa, when a guest
page fault occurs, it will call the imsic_mmio_write function,the
guest irq will be written to the guest interrupt file by kvm.

>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>>  	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>>  	pfn = __phys_to_pfn(hpa);
>>  
>> +	prot = pgprot_noncached(PAGE_WRITE);
>> +
>>  	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
>> -		pte = pfn_pte(pfn, PAGE_KERNEL_IO);
>> +		pte = pfn_pte(pfn, prot);
>> +		pte = pte_mkdirty(pte);
>
>Is it necessary to dirty the pte?
>
>It was dirtied before, so it definitely doesn't hurt,
>

Make pte dirty is necessary(for hardware without Svadu), and here is
the first time to make this pte dirty.

>Reviewed-by: Radim Krčmář <rkrcmar@ventanamicro.com>
>
>Thanks.

Thanks,
fangyu

