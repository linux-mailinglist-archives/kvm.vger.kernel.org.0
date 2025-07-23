Return-Path: <kvm+bounces-53261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24EEDB0F6AA
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3032AA0E01
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312C92DA74A;
	Wed, 23 Jul 2025 15:04:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D702F6FAA
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283089; cv=none; b=I28MwQWQA5AsfztgwxdZD3v/LQA2JqWo/SBwQqHBIkXG4V7ZiumPo49aDQFTkAYpeH0PEMXF/2Q0EFnO2/C+jSJDZdJP1lvyXosL/Ewex858oPvfMfzYIhUscOmJA1pCiLppx2y/62dl8g7z5CHgMeLq8fv6gOFi2OzSf00gC1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283089; c=relaxed/simple;
	bh=hHiAYV/PFD7zDKETWaOJTTY0kPLgsrYy1dL9vrfNRWo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JotSciJzCfk+5aBmPtx4LbiGrPlF7Y89nO6HsWxKoNpzLMkkcLEjsPpV2NHOr1Aq9vNTn2+R9swSe4KOH5M5IqGnFEr+M5LlvJuXFdnYRt5mrO+n3OUuCZQk04Yu8juhCw9VzJYQpi8e7S6oQ/Bitb1TXQy/3+AzHZsedDWJJEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-af2a2a54a95so234268066b.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:04:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753283086; x=1753887886;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3wDLxoVc+HEdX2GMJxvGVJZTBNah2ZOjTXwELNejXA=;
        b=JfLYu48EwAgJUtzJUkqDXEyIQ/ysUjk9CFz/VWAyyE8KRD2PpUGRfT713QAlNStSAd
         1KmhAk0g8pVh2WU6YvSGlq+v1rmnshUtHyzM0YO0dd/pWQ6hFXlRWUrLcuhDNGDnBpgu
         CUp979aH5nmorneWZMgDe56sWIS6qdNlelREYEC9XPKZv3CHRmnfRzQeszqfRiBDT/h9
         Ye5wwzGyhrLK7AGsSHRqr05ACmMeV0uUF7ByXz5ONm8jxIaYiWeeoJPpmg2mnueJ3qHI
         MVZfg8/wxHYw+V3LT60tQuTxz6gP9hXIXOyZKZoyjIsvY8y7g3SRpCYL0IprFjjW+rvc
         TZNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhPWoyP2b47vV5/RnWbI5gkjxHo3X+V22YW0NToXzWOMNf887dUdf/GUWz28nyjXK/nq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvwpuGhHLzlHG9PlY3q7PDNohPRb/xuclfIVB5nclEwh0196qq
	025NrHJdsWLqJ7zA4EGoNKUNhJFt8GeRJRO6x1C1OWMKh81ZM7JoMe61cR2/yaXO
X-Gm-Gg: ASbGncvTOvxj4lZJktIQmATnENBMf/QC4MTygCEJHZVms8pD/Niwo/4RKZKQ2xxojud
	i87yuRZiYjy42vwRzWMH/W6BOy2bAWgmV/SkMGI4K2QekWXN6e6CohTs+M01vNkvaUiK8Mf9ek7
	Dx176fOzAAScnUiKOTuM3eyQy4na6TsWUO4TamBavwXa7HOU1G2GYgTsQ0T9+qfNpsPdkZs8lXP
	B+rxghdYzW5ktsHkk1qgQtS8+Jy7lj7T4ttM8b2BElEOYivKN3bh5rfOsupKtUz4Yg+GTxaLFCQ
	EcoMH3dqjBlsjzAzA0WVaKt0FK2na8g6jBeRVvi991ZNdAx9HtQItRRkpWWXwac2IHeWysAoCc1
	LxMu5aRXu5AP7
X-Google-Smtp-Source: AGHT+IG4M07vIFs4hMRP/029gmdq+4cUNxE2P9XhlYCoD20ic0NnH4DJ8ZRKHcH+ho3414YcpwkJ5g==
X-Received: by 2002:a17:907:3d09:b0:ae3:a240:7ad2 with SMTP id a640c23a62f3a-af2f64bb5bbmr298750266b.2.1753283085272;
        Wed, 23 Jul 2025 08:04:45 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:6::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6cadd8bbsm1053308066b.154.2025.07.23.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:04:44 -0700 (PDT)
Date: Wed, 23 Jul 2025 08:04:42 -0700
From: Breno Leitao <leitao@debian.org>
To: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: vhost: linux-next: crash at vhost_dev_cleanup()
Message-ID: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I've seen a crash in linux-next for a while on my arm64 server, and
I decided to report.

While running stress-ng on linux-next, I see the crash below.

This is happening in a kernel configure with some debug options (KASAN,
LOCKDEP and KMEMLEAK).

Basically running stress-ng in a loop would crash the host in 15-20
minutes:
	# while (true); do stress-ng -r 10 -t 10; done
	
From the early warning "virt_to_phys used for non-linear address",
I suppose corrupted data is at vq->nheads.

Here is the decoded stack against 9798752 ("Add linux-next specific
files for 20250721")


	[  620.685144] [ T250731] VFIO - User Level meta-driver version: 0.3
	[  622.394448] [ T250254] ------------[ cut here ]------------
	[  622.413492] [ T250254] virt_to_phys used for non-linear address: 000000006e69fe64 (0xcfcecdcccbcac9c8)
	[  622.447771] [     T250254] WARNING: arch/arm64/mm/physaddr.c:15 at __virt_to_phys+0x64/0x90, CPU#57: stress-ng-dev/250254 
	[  622.487227] [ T250254] Modules linked in: vhost_vsock(E) vfio_iommu_type1(E) vfio(E) unix_diag(E) sch_fq(E) ghes_edac(E) tls(E) tcp_diag(E) inet_diag(E) act_gact(E) cls_bpf(E) nvidia_cspmu(E) ipmi_ssif(E) coresight_trbe(E) arm_cspmu_module(E) arm_smmuv3_pmu(E) ipmi_devintf(E) coresight_stm(E) coresight_funnel(E) coresight_etm4x(E) coresight_tmc(E) stm_core(E) ipmi_msghandler(E) coresight(E) cppc_cpufreq(E) sch_fq_codel(E) drm(E) backlight(E) drm_panel_orientation_quirks(E) sm3_ce(E) sha3_ce(E) spi_tegra210_quad(E) vhost_net(E) tap(E) tun(E) vhost(E) vhost_iotlb(E) mpls_gso(E) mpls_iptunnel(E) mpls_router(E) fou(E) acpi_power_meter(E) loop(E) efivarfs(E) autofs4(E) [last unloaded: test_bpf(E)]
	[  622.734524] [ T250254] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE, [N]=TEST
	[  622.734525] [ T250254] Hardware name: ...
	[  622.734526] [ T250254] pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
	[  622.734529] [     T250254] pc : __virt_to_phys (/home/user/Devel/linux-next/arch/arm64/mm/physaddr.c:?) 
	[  622.734531] [     T250254] lr : __virt_to_phys (/home/user/Devel/linux-next/arch/arm64/mm/physaddr.c:?) 
	[  622.734533] [ T250254] sp : ffff800158e8fc60
	[  622.734534] [ T250254] x29: ffff800158e8fc60 x28: ffff0034a7cc7900 x27: 0000000000000000
	[  622.734537] [ T250254] x26: 0000000000000000 x25: ffff0034a7cc7900 x24: 00000000040e001f
	[  622.734539] [ T250254] x23: ffff0010858afb00 x22: cfcecdcccbcac9c8 x21: ffff0033526a01e0
	[  622.734541] [ T250254] x20: 0000000000008000 x19: ffcecdcccbcac9c8 x18: ffff80008149c8e4
	[  622.734543] [ T250254] x17: 0000000000000001 x16: 0000000000000000 x15: 0000000000000003
	[  622.734545] [ T250254] x14: ffff800082962e78 x13: 0000000000000003 x12: ffff003bc6231630
	[  622.734546] [ T250254] x11: 0000000000000000 x10: 0000000000000000 x9 : ed44a220ae716b00
	[  622.734548] [ T250254] x8 : 0001000000000000 x7 : 0720072007200720 x6 : ffff80008018710c
	[  622.734550] [ T250254] x5 : 0000000000000001 x4 : 00000090ecc72ac0 x3 : 0000000000000000
	[  622.734552] [ T250254] x2 : 0000000000000000 x1 : ffff800081a72bc6 x0 : 000000000000004f
	[  622.734554] [ T250254] Call trace:
	[  622.734555] [     T250254] __virt_to_phys (/home/user/Devel/linux-next/arch/arm64/mm/physaddr.c:?) (P)
	[  622.734557] [     T250254] kfree (/home/user/Devel/linux-next/./include/linux/mm.h:1180 /home/user/Devel/linux-next/mm/slub.c:4871) 
	[  622.734562] [     T250254] vhost_dev_cleanup (/home/user/Devel/linux-next/drivers/vhost/vhost.c:506 /home/user/Devel/linux-next/drivers/vhost/vhost.c:542 /home/user/Devel/linux-next/drivers/vhost/vhost.c:1214) vhost 
	[  622.734571] [     T250254] vhost_vsock_dev_release (/home/user/Devel/linux-next/drivers/vhost/vsock.c:756) vhost_vsock 
	[  622.734575] [     T250254] __fput (/home/user/Devel/linux-next/fs/file_table.c:469) 
	[  622.734578] [     T250254] fput_close_sync (/home/user/Devel/linux-next/fs/file_table.c:?) 
	[  622.734579] [     T250254] __arm64_sys_close (/home/user/Devel/linux-next/fs/open.c:1589 /home/user/Devel/linux-next/fs/open.c:1572 /home/user/Devel/linux-next/fs/open.c:1572) 
	[  622.734584] [     T250254] invoke_syscall (/home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:50) 
	[  622.734589] [     T250254] el0_svc_common (/home/user/Devel/linux-next/./include/linux/thread_info.h:135 /home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:140) 
	[  622.734591] [     T250254] do_el0_svc (/home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:152) 
	[  622.734594] [     T250254] el0_svc (/home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:169 /home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:182 /home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:880) 
	[  622.734600] [     T250254] el0t_64_sync_handler (/home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:958) 
	[  622.734603] [     T250254] el0t_64_sync (/home/user/Devel/linux-next/arch/arm64/kernel/entry.S:596) 
	[  622.734605] [ T250254] irq event stamp: 0
	[  622.734606] [     T250254] hardirqs last enabled at (0): 0x0 
	[  622.734610] [     T250254] hardirqs last disabled at (0): copy_process (/home/user/Devel/linux-next/kernel/fork.c:?) 
	[  622.734614] [     T250254] softirqs last enabled at (0): copy_process (/home/user/Devel/linux-next/kernel/fork.c:?) 
	[  622.734616] [     T250254] softirqs last disabled at (0): 0x0 
	[  622.734618] [ T250254] ---[ end trace 0000000000000000 ]---
	[  622.734697] [ T250254] Unable to handle kernel paging request at virtual address 003ff3b33312f288
	[  622.734700] [ T250254] Mem abort info:
	[  622.734701] [ T250254]   ESR = 0x0000000096000004
	[  622.734702] [ T250254]   EC = 0x25: DABT (current EL), IL = 32 bits
	[  622.734704] [ T250254]   SET = 0, FnV = 0
	[  622.734705] [ T250254]   EA = 0, S1PTW = 0
	[  622.734706] [ T250254]   FSC = 0x04: level 0 translation fault
	[  622.734708] [ T250254] Data abort info:
	[  622.734709] [ T250254]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
	[  622.734711] [ T250254]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
	[  622.734712] [ T250254]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
	[  622.734713] [ T250254] [003ff3b33312f288] address between user and kernel address ranges
	[  622.734715] [ T250254] Internal error: Oops: 0000000096000004 [#1]  SMP
	[  622.734718] [ T250254] Modules linked in: vhost_vsock(E) vfio_iommu_type1(E) vfio(E) unix_diag(E) sch_fq(E) ghes_edac(E) tls(E) tcp_diag(E) inet_diag(E) act_gact(E) cls_bpf(E) nvidia_cspmu(E) ipmi_ssif(E) coresight_trbe(E) arm_cspmu_module(E) arm_smmuv3_pmu(E) ipmi_devintf(E) coresight_stm(E) coresight_funnel(E) coresight_etm4x(E) coresight_tmc(E) stm_core(E) ipmi_msghandler(E) coresight(E) cppc_cpufreq(E) sch_fq_codel(E) drm(E) backlight(E) drm_panel_orientation_quirks(E) sm3_ce(E) sha3_ce(E) spi_tegra210_quad(E) vhost_net(E) tap(E) tun(E) vhost(E) vhost_iotlb(E) mpls_gso(E) mpls_iptunnel(E) mpls_router(E) fou(E) acpi_power_meter(E) loop(E) efivarfs(E) autofs4(E) [last unloaded: test_bpf(E)]
	[  622.734740] [ T250254] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE, [N]=TEST
	[  622.734740] [ T250254] Hardware name: ...
	[  622.734741] [ T250254] pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
	[  622.734742] [     T250254] pc : kfree (/home/user/Devel/linux-next/./include/linux/page-flags.h:284 /home/user/Devel/linux-next/./include/linux/mm.h:1182 /home/user/Devel/linux-next/mm/slub.c:4871) 
	[  622.734745] [     T250254] lr : kfree (/home/user/Devel/linux-next/./include/linux/mm.h:1180 /home/user/Devel/linux-next/mm/slub.c:4871) 
	[  622.734747] [ T250254] sp : ffff800158e8fc80
	[  622.734748] [ T250254] x29: ffff800158e8fc90 x28: ffff0034a7cc7900 x27: 0000000000000000
	[  622.734749] [ T250254] x26: 0000000000000000 x25: ffff0034a7cc7900 x24: 00000000040e001f
	[  622.734751] [ T250254] x23: ffff0010858afb00 x22: cfcecdcccbcac9c8 x21: ffff0033526a01e0
	[  622.734752] [ T250254] x20: 003ff3b33312f280 x19: ffff80000acd1a20 x18: ffff80008149c8e4
	[  622.734754] [ T250254] x17: 0000000000000001 x16: 0000000000000000 x15: 0000000000000003
	[  622.734755] [ T250254] x14: ffff800082962e78 x13: 0000000000000003 x12: ffff003bc6231630
	[  622.734757] [ T250254] x11: 0000000000000000 x10: 0000000000000000 x9 : ffffffdfc0000000
	[  622.734758] [ T250254] x8 : 003ff3d37312f280 x7 : 0720072007200720 x6 : ffff80008018710c
	[  622.734760] [ T250254] x5 : 0000000000000001 x4 : 00000090ecc72ac0 x3 : 0000000000000000
	[  622.734761] [ T250254] x2 : 0000000000000000 x1 : ffff800081a72bc6 x0 : ffcf4dcccbcac9c8
	[  622.734763] [ T250254] Call trace:
	[  622.734763] [     T250254] kfree (/home/user/Devel/linux-next/./include/linux/page-flags.h:284 /home/user/Devel/linux-next/./include/linux/mm.h:1182 /home/user/Devel/linux-next/mm/slub.c:4871) (P)
	[  622.734766] [     T250254] vhost_dev_cleanup (/home/user/Devel/linux-next/drivers/vhost/vhost.c:506 /home/user/Devel/linux-next/drivers/vhost/vhost.c:542 /home/user/Devel/linux-next/drivers/vhost/vhost.c:1214) vhost 
	[  622.734769] [     T250254] vhost_vsock_dev_release (/home/user/Devel/linux-next/drivers/vhost/vsock.c:756) vhost_vsock 
	[  622.734771] [     T250254] __fput (/home/user/Devel/linux-next/fs/file_table.c:469) 
	[  622.734772] [     T250254] fput_close_sync (/home/user/Devel/linux-next/fs/file_table.c:?) 
	[  622.734773] [     T250254] __arm64_sys_close (/home/user/Devel/linux-next/fs/open.c:1589 /home/user/Devel/linux-next/fs/open.c:1572 /home/user/Devel/linux-next/fs/open.c:1572) 
	[  622.734776] [     T250254] invoke_syscall (/home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:50) 
	[  622.734778] [     T250254] el0_svc_common (/home/user/Devel/linux-next/./include/linux/thread_info.h:135 /home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:140) 
	[  622.734781] [     T250254] do_el0_svc (/home/user/Devel/linux-next/arch/arm64/kernel/syscall.c:152) 
	[  622.734783] [     T250254] el0_svc (/home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:169 /home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:182 /home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:880) 
	[  622.734787] [     T250254] el0t_64_sync_handler (/home/user/Devel/linux-next/arch/arm64/kernel/entry-common.c:958) 
	[  622.734790] [     T250254] el0t_64_sync (/home/user/Devel/linux-next/arch/arm64/kernel/entry.S:596) 
	[ 622.734792] [ T250254] Code: f2dffbe9 927abd08 cb141908 8b090114 (f9400688)
	All code
	========
	0:*	e9 fb df f2 08       	jmp    0x8f2e000		<-- trapping instruction
	5:	bd 7a 92 08 19       	mov    $0x1908927a,%ebp
	a:	14 cb                	adc    $0xcb,%al
	c:	14 01                	adc    $0x1,%al
	e:	09 8b 88 06 40 f9    	or     %ecx,-0x6bff978(%rbx)

	Code starting with the faulting instruction
	===========================================
	0:	88 06                	mov    %al,(%rsi)
	2:	40 f9                	rex stc 
	[  622.734795] [ T250254] SMP: stopping secondary CPUs
	[  622.735089] [ T250254] Starting crashdump kernel...
	[  622.735091] [ T250254] Bye!


