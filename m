Return-Path: <kvm+bounces-60567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F02CBF3415
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 21:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A04F4854EA
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 19:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68E832ED59;
	Mon, 20 Oct 2025 19:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="a5mfG97c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703002BEC23
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 19:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760989402; cv=none; b=r73ju5zeY5flFKcmqHFJwCnT+7nSsslL2naJDSdxxFqzJE445QshF89UnJVWWQ8ZqczMlr57ji2q3HIAxFgZkedFLSbEmngVlve5rk1K1tc6ytBqaXEfG2+8zm3sdicQJiqzJr1itOzVJA8AFTvruGblxEWZHVpEvFspFFDhefI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760989402; c=relaxed/simple;
	bh=46YL1iGrEGxGTcZR7UAy864AfYF4ZbJbASJ+m8Vy1Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vc+gc7PnpfwGPwwuuJuvcUGEOD+4anCbGbg4AzAjhkEqZh205LsDrvQeG+BkE+DGPXJzeBEQ9LN8GCmOb3ZLhr/BIxX3hFF7dSgqTXkGYT6WdhCUTg8zSVIVzrH5DC+bbTFZ/wk3J028ar5ZYQYCroae1hxDLH2sqFsfwAcflDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=a5mfG97c; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-781206cce18so4848725b3a.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 12:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760989400; x=1761594200; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hM5MMLXsYM69EBdIPQteBCdcHt+2UMoOmn9dDxRhd44=;
        b=a5mfG97cKK6L6qg7GB8i3pN9CegqinKOLdXtgwNOj+8P17cnu35zvGkTFlGLxGqx3z
         bwg8A3U8a2el5beYTWcK+ejybL/uQDE/E9tEGC2KtmCOLTrGVKdLQ1mYZOkygQXrfNN+
         904b1+RRGf+upol4SkpetN6iq7WXtNclZEdvVVOxHmrmaEchc0SSFbwplwp9Wc0Iv/5b
         4DFtBhU/aN6PsBLN5p9MbQBLQWkYYc+FFENACx/t7deFYz8gn57iSsPpB0liyRKNivuQ
         toKsm9H5hwzy6fcpgIzwAcY51EacTHkHyyXZL9jgA7tckOf/8Urt51h4+W3eFJ/5tv4O
         +iLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760989400; x=1761594200;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hM5MMLXsYM69EBdIPQteBCdcHt+2UMoOmn9dDxRhd44=;
        b=m5dDyI4qzFnmEKOL9aSKd/bfFYOgZ8UmIppIFaZBUZYvpv8nL3HaI95xw0fhorblyW
         EmWGeosK/JvrOwwDc3C+zydMjmX2scU4wqVNE2t5ebdWS/fQhJczdJ9jzGixzvr4GdMI
         DlW+oogqNmxOxPliUzyYm5EciyOiyNjR5n9hSddniG89xp84YSpMiRTCtQXNiMRjsgHu
         jvNTUOA0+qs7xcNEir4mHUUnIWQU8PbZzepLhfL3IZgOKQCuHaTyQth/y0IlOYnA56UI
         vbvr6Hf2qDYkA36ppQIXfRhR7wMDQy7fth7g848QfpTf7S2qKg55s41wBnhJ/KCz1BTP
         kD7w==
X-Forwarded-Encrypted: i=1; AJvYcCW+pFvVK1e9bJKQ5BkXqo/u6vPj2tzaKLDvMfCkyfkeQEQiP+QEj3ZjDbMoTJYvsX/iO00=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdjslODPA17LvkLQA3oNRtuRykeXp7OqMxqpCuMLBNvPpEVFUa
	tQr8sI99ac60K/hPdUuM9MspeFMCuxYgz+20q4tm3HzpYBhEURTUliry/vDAseigZs8=
X-Gm-Gg: ASbGncumr58Spu72aRJnRGl2Eu49+HRdGH54uge2m36oZE4mOJw4ZfUhFv9R/lV5UA2
	bG0Br76EAOlB6uQmrditKVH8Sq1t4jGBTsyPvwIG6z/rDeEEq1U/DxLDYw9UInXYqv+J1Uu1OP9
	3rN9l+FBNHWuiAC8JKpMlbrOsPZEwNyW/YpXfqBImDzHV1UNLVMIWLsfFAC0VfeCiDdb60fteDo
	veKPCpa7uDHUYfbd75VfixKQhm0ITpl5pXrQOhIzskg08SPTezyUjZ3gMdvHm4jvJnT/aBt6yh1
	pc9UWasi5MHL09NuwSt/IJ4IcJBmGzi5DyqtsQxsiTj5jr4eqiiDq30n4yVZRn2KaOmsZBpBdzY
	Kn220ak4AvDKtYNoLBRQ34gr4hWF7rcxLexuoNZegJKRcz7WApKP7RXBXGUBqcWqgEW8v09hz3I
	oRklZzbEpsVOfrtyOsx1AJXTwzt9dlmLKu9f1OUjad6xAYEwuDjvrLCg==
X-Google-Smtp-Source: AGHT+IEz0c9auRC0TwjskGJJcvcC5ayj8gqgof4QV51C8KuJdIiqhiUNN8QL7OYGY673kk8y9oGq8A==
X-Received: by 2002:a05:6a00:784:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-7a210d8ffd0mr15317951b3a.1.1760989399677;
        Mon, 20 Oct 2025 12:43:19 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bcc1:8cb8:dfc4:4af0:d7c6:a030? ([2804:7f0:bcc1:8cb8:dfc4:4af0:d7c6:a030])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff158f8sm9251975b3a.8.2025.10.20.12.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:43:19 -0700 (PDT)
Message-ID: <ca6a8e5a-f14d-4017-90dc-be566d594eee@ventanamicro.com>
Date: Mon, 20 Oct 2025 16:43:14 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 pbonzini@redhat.com, jiangyifei@huawei.com
Cc: guoren@kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Content-Language: en-US
In-Reply-To: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/20/25 10:08 AM, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> regions. Using vma->vm_pgoff to derive the HPA here may therefore
> produce incorrect mappings.
> 
> Instead, I/O mappings for such regions can be established on-demand
> during g-stage page faults, making the upfront ioremap in this path
> is unnecessary.
> 
> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---

Hi,

This patch fixes the issue observed by Drew in [1]. I was helping Drew
debug it using a QEMU guest inside an emulated risc-v host with the
'virt' machine + IOMMU enabled.

Using the patches from [2], without the workaround patch (18), booting a
guest with a passed-through PCI device fails with a store amo fault and a
kernel oops:

[    3.304776] Oops - store (or AMO) access fault [#1]
[    3.305159] Modules linked in:
[    3.305603] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.11.0-rc4 #39
[    3.305988] Hardware name: riscv-virtio,qemu (DT)
[    3.306140] epc : __ew32+0x34/0xba
[    3.307910]  ra : e1000_irq_disable+0x1e/0x9a
[    3.307984] epc : ffffffff806ebfbe ra : ffffffff806ee3f8 sp : ff2000000000baf0
[    3.308022]  gp : ffffffff81719938 tp : ff600000018b8000 t0 : ff60000002c3b480
[    3.308055]  t1 : 0000000000000065 t2 : 3030206530303031 s0 : ff2000000000bb30
[    3.308086]  s1 : ff60000002a50a00 a0 : ff60000002a50fb8 a1 : 00000000000000d8
[    3.308118]  a2 : ffffffffffffffff a3 : 0000000000000002 a4 : 0000000000003000
[    3.308161]  a5 : ff200000001e00d8 a6 : 0000000000000008 a7 : 0000000000000038
[    3.308195]  s2 : ff60000002a50fb8 s3 : ff60000001865000 s4 : 00000000000000d8
[    3.308226]  s5 : ffffffffffffffff s6 : ff60000002a50a00 s7 : ffffffff812d2760
[    3.308258]  s8 : 0000000000000a00 s9 : 0000000000001000 s10: ff60000002a51000
[    3.308288]  s11: ff60000002a54000 t3 : ffffffff8172ec4f t4 : ffffffff8172ec4f
[    3.308475]  t5 : ffffffff8172ec50 t6 : ff2000000000b848
[    3.308763] status: 0000000200000120 badaddr: ff200000001e00d8 cause: 0000000000000007
[    3.308975] [<ffffffff806ebfbe>] __ew32+0x34/0xba
[    3.309196] [<ffffffff806ee3f8>] e1000_irq_disable+0x1e/0x9a
[    3.309241] [<ffffffff806f1e12>] e1000_probe+0x3b6/0xb50
[    3.309279] [<ffffffff80510554>] pci_device_probe+0x7e/0xf8
[    3.310001] [<ffffffff80610344>] really_probe+0x82/0x202
[    3.310409] [<ffffffff80610520>] __driver_probe_device+0x5c/0xd0
[    3.310622] [<ffffffff806105c0>] driver_probe_device+0x2c/0xb0
(...)


Further debugging showed that, as far as QEMU goes, the store fault happens in an
"unassigned io region", i.e. a region where there's no IO memory region mapped by
any device. There is no IOMMU faults being logged and, at least as far as I've
observed, no IOMMU translation bugs in the QEMU side as well.


Thanks for the fix!


Tested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>



[1] https://lore.kernel.org/all/20250920203851.2205115-38-ajones@ventanamicro.com/
[2] https://lore.kernel.org/all/20250920203851.2205115-20-ajones@ventanamicro.com/




>   arch/riscv/kvm/mmu.c | 20 +-------------------
>   1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 525fb5a330c0..84c04c8f0892 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -197,8 +197,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   
>   	/*
>   	 * A memory region could potentially cover multiple VMAs, and
> -	 * any holes between them, so iterate over all of them to find
> -	 * out if we can map any of them right now.
> +	 * any holes between them, so iterate over all of them.
>   	 *
>   	 *     +--------------------------------------------+
>   	 * +---------------+----------------+   +----------------+
> @@ -229,32 +228,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   		vm_end = min(reg_end, vma->vm_end);
>   
>   		if (vma->vm_flags & VM_PFNMAP) {
> -			gpa_t gpa = base_gpa + (vm_start - hva);
> -			phys_addr_t pa;
> -
> -			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
> -			pa += vm_start - vma->vm_start;
> -
>   			/* IO region dirty page logging not allowed */
>   			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>   				ret = -EINVAL;
>   				goto out;
>   			}
> -
> -			ret = kvm_riscv_mmu_ioremap(kvm, gpa, pa, vm_end - vm_start,
> -						    writable, false);
> -			if (ret)
> -				break;
>   		}
>   		hva = vm_end;
>   	} while (hva < reg_end);
>   
> -	if (change == KVM_MR_FLAGS_ONLY)
> -		goto out;
> -
> -	if (ret)
> -		kvm_riscv_mmu_iounmap(kvm, base_gpa, size);
> -
>   out:
>   	mmap_read_unlock(current->mm);
>   	return ret;


