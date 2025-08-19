Return-Path: <kvm+bounces-54939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C858B2B5EB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EB22620E26
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 01:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B065D1E98F3;
	Tue, 19 Aug 2025 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Z2vlis7h"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23871DF246;
	Tue, 19 Aug 2025 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755566766; cv=none; b=b7STXHLKZEZ/BmZuaEbbiP66iDu3uE3nDEthHyOBJonmjhx8Svkt8o3x8fMENURI9bk8tt/tA/31mfbSk43xNywbPUcpyxRH+SC3BN22s5+O8oj020yfLAk5njMWqr2DkyX9jwzzm462QW3o48xnl1JbQocpO5DQMQdJBxghtZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755566766; c=relaxed/simple;
	bh=KMFWf+szge8CEFRLqidpE5roRvFUuOgWAw5WnIoHLPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NU+/iM8lMBR3nXtblXAetTvzrblm7dzcZ0bzQV8FDUbFUB83v9hFbv/brfcKbXCb3TY65kE09psSmkCPuKDOoLNLMVo+7EJSSAqXUK6xnWBmaXVab57pyXeuG6WfERFrxgLiUQlBEhNhFR+skfaIDUgSG3KSRqDqInim/vBYnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Z2vlis7h; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755566760; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=5OVVf637/rFSQpfwdp/hg0O0Ow8p4WzZ4tWTlQ0JpQc=;
	b=Z2vlis7h3Aw8Y1htBF/PY/OAEvKRLvEt2lzhuf+vfcxH4IKSq6GuMF5fXgZdM2QgxFZo/D+Emw4uumq7B8ZgdH3WzOeEiPjyPGLjnVo9mFBQ2+/lFjNcP1gAfnBOMJ14D4oiJZ9NweBKaxDRI62xvIwf1t9KbWDZlhOo873pL0A=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wm4m1nl_1755566758 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 Aug 2025 09:26:00 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org
Cc: alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: Re: [PATCH] RISC-V: KVM: Using user-mode pte within kvm_riscv_gstage_ioremap
Date: Tue, 19 Aug 2025 09:25:58 +0800
Message-Id: <20250819012558.88733-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAAhSdy3omyk7YGVHNV5mgR13cON1SxdpqsxGQJsWWE1Hoyw=5A@mail.gmail.com>
References: <CAAhSdy3omyk7YGVHNV5mgR13cON1SxdpqsxGQJsWWE1Hoyw=5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>>
>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
>> guest interrupt file within IMSIC.
>>
>> The PAGE_KERNEL_IO property does not include user mode settings, so when
>> accessing the IMSIC address in the virtual machine,  a  guest page fault
>> will occur, this is not expected.
>>
>> According to the RISC-V Privileged Architecture Spec, for G-stage address
>> translation, all memory accesses are considered to be user-level accesses
>> as though executed in Umode.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
>Overall, a good fix. Thanks!
>
>The patch subject and description needs improvements. Also, there is no
>Fixes tag which is required for backporting.
>
>I have taken care of the above things at the time of merging this patch.
>
>Queued this patch as fixes for Linux-6.17
>
>Thanks,
>Anup
>

Thanks for your review.
I will send a v2 patch to fix these comments.

Thanks,
fangyu

>> ---
>>  arch/riscv/kvm/mmu.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>> index 1087ea74567b..800064e96ef6 100644
>> --- a/arch/riscv/kvm/mmu.c
>> +++ b/arch/riscv/kvm/mmu.c
>> @@ -351,6 +351,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>>         int ret = 0;
>>         unsigned long pfn;
>>         phys_addr_t addr, end;
>> +       pgprot_t prot;
>>         struct kvm_mmu_memory_cache pcache = {
>>                 .gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
>>                 .gfp_zero = __GFP_ZERO,
>> @@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>>         pfn = __phys_to_pfn(hpa);
>>
>> +       prot = pgprot_noncached(PAGE_WRITE);
>> +
>>         for (addr = gpa; addr < end; addr += PAGE_SIZE) {
>> -               pte = pfn_pte(pfn, PAGE_KERNEL_IO);
>> +               pte = pfn_pte(pfn, prot);
>> +               pte = pte_mkdirty(pte);
>>
>>                 if (!writable)
>>                         pte = pte_wrprotect(pte);
>> --
>> 2.39.3 (Apple Git-146)
>>

