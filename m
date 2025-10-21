Return-Path: <kvm+bounces-60602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C729BF44C9
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 03:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3917E4F6C8F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 01:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04796284896;
	Tue, 21 Oct 2025 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NdwV/EL3"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4DA2566F2;
	Tue, 21 Oct 2025 01:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761011087; cv=none; b=rX4sGKSmidt7sumLgLDqSqicVJj74IFACB+xaU11JAAj30P8PWH8/7SVc2ZSwRU2j8qDKNsQC703BRtP+pnxn79ObXrrPC5NByLTDvARAN4nn6G6+vbkBX73wDB9fYa69AllXV31aoh+Qu8aU6mxj1/4c27x3r9QjAUScyb6RE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761011087; c=relaxed/simple;
	bh=HOt8jXCUUtE5E4qZPLYHszE6eZo0KCLI3v3FuC9v3z8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=II6MKL8+zKVUWL24O0D6l8VQw0JXS1ORBGldLUqgFDUztHDjhnjKvbBZv/HpbEKHBoe5iXV9hBMF44oWYnybZpc6KYItiv6N0jShXQwIY2YDfV9kqznQU4/ZnX8ampi7zSC2p/PfFPK2/f6g/9EiEC3Kw/yj3eYra7ZiIZjWwlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NdwV/EL3; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761011081; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=3rggCTCwug85NvywRQ6sf6WRszwDZIZt8nJfB05isZ0=;
	b=NdwV/EL3R9bGv/nT6qJRJqE1R2Ku33X2IIQ2AULC1OFX2LSi4eUNDomVBRZbHTDEAQiqEDzIQu2zFRFz+yzpfQ3+AdHjLU28jPhk9+oR0XZwQC4bXyE9YTo05JRrq5xddWfNS3dIbmm473Yn9de1f+Iil+vlvtw5U6rS4MG6PTw=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wqh4M2p_1761011078 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Oct 2025 09:44:39 +0800
From: fangyu.yu@linux.alibaba.com
To: dbarboza@ventanamicro.com
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	jiangyifei@huawei.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org
Subject: Re: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP 
Date: Tue, 21 Oct 2025 09:44:37 +0800
Message-Id: <20251021014437.850-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <ca6a8e5a-f14d-4017-90dc-be566d594eee@ventanamicro.com>
References: <ca6a8e5a-f14d-4017-90dc-be566d594eee@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> 
>> As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
>> vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
>> regions. Using vma->vm_pgoff to derive the HPA here may therefore
>> produce incorrect mappings.
>> 
>> Instead, I/O mappings for such regions can be established on-demand
>> during g-stage page faults, making the upfront ioremap in this path
>> is unnecessary.
>> 
>> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>
>Hi,
>
>This patch fixes the issue observed by Drew in [1]. I was helping Drew
>debug it using a QEMU guest inside an emulated risc-v host with the
>'virt' machine + IOMMU enabled.

Thank you for testing this patch.
As you can see below, because of the previous HPA calculation error,
the GVA is mapped to an incorrect HPA, and finally a store amo/access
exception occurs.

>
>Using the patches from [2], without the workaround patch (18), booting a
>guest with a passed-through PCI device fails with a store amo fault and a
>kernel oops:
>
>[    3.304776] Oops - store (or AMO) access fault [#1]
>[    3.305159] Modules linked in:
>[    3.305603] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.11.0-rc4 #39
>[    3.305988] Hardware name: riscv-virtio,qemu (DT)
>[    3.306140] epc : __ew32+0x34/0xba
>[    3.307910]  ra : e1000_irq_disable+0x1e/0x9a
>[    3.307984] epc : ffffffff806ebfbe ra : ffffffff806ee3f8 sp : ff2000000000baf0
>[    3.308022]  gp : ffffffff81719938 tp : ff600000018b8000 t0 : ff60000002c3b480
>[    3.308055]  t1 : 0000000000000065 t2 : 3030206530303031 s0 : ff2000000000bb30
>[    3.308086]  s1 : ff60000002a50a00 a0 : ff60000002a50fb8 a1 : 00000000000000d8
>[    3.308118]  a2 : ffffffffffffffff a3 : 0000000000000002 a4 : 0000000000003000
>[    3.308161]  a5 : ff200000001e00d8 a6 : 0000000000000008 a7 : 0000000000000038
>[    3.308195]  s2 : ff60000002a50fb8 s3 : ff60000001865000 s4 : 00000000000000d8
>[    3.308226]  s5 : ffffffffffffffff s6 : ff60000002a50a00 s7 : ffffffff812d2760
>[    3.308258]  s8 : 0000000000000a00 s9 : 0000000000001000 s10: ff60000002a51000
>[    3.308288]  s11: ff60000002a54000 t3 : ffffffff8172ec4f t4 : ffffffff8172ec4f
>[    3.308475]  t5 : ffffffff8172ec50 t6 : ff2000000000b848
>[    3.308763] status: 0000000200000120 badaddr: ff200000001e00d8 cause: 0000000000000007
>[    3.308975] [<ffffffff806ebfbe>] __ew32+0x34/0xba
>[    3.309196] [<ffffffff806ee3f8>] e1000_irq_disable+0x1e/0x9a
>[    3.309241] [<ffffffff806f1e12>] e1000_probe+0x3b6/0xb50
>[    3.309279] [<ffffffff80510554>] pci_device_probe+0x7e/0xf8
>[    3.310001] [<ffffffff80610344>] really_probe+0x82/0x202
>[    3.310409] [<ffffffff80610520>] __driver_probe_device+0x5c/0xd0
>[    3.310622] [<ffffffff806105c0>] driver_probe_device+0x2c/0xb0
>(...)
>
>
>Further debugging showed that, as far as QEMU goes, the store fault happens in an
>"unassigned io region", i.e. a region where there's no IO memory region mapped by
>any device. There is no IOMMU faults being logged and, at least as far as I've
>observed, no IOMMU translation bugs in the QEMU side as well.
>
>
>Thanks for the fix!
>
>
>Tested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
>
>
>
>[1] https://lore.kernel.org/all/20250920203851.2205115-38-ajones@ventanamicro.com/
>[2] https://lore.kernel.org/all/20250920203851.2205115-20-ajones@ventanamicro.com/
>

Thanks,
Fangyu

