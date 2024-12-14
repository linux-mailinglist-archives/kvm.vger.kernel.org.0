Return-Path: <kvm+bounces-33825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CF09F207E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 19:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE25B167E05
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 18:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171581AB510;
	Sat, 14 Dec 2024 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mac2ZTDV"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E280C02;
	Sat, 14 Dec 2024 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734202373; cv=none; b=apVEDI8ViEDRzAFw4/XlTzGr01ObtK0Oj5VMGbWTh+PtDvB1WEmb0s4GGyVkiHD2JbTSAvTuJWr4h41BvNjo9GAIYwkZKkbAPQaaU6xBz51filtL5zR1f1zvReVvvx5qrL/aphNmUlR02y/123XFZhwfqc20IwABmQF0I3b1U/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734202373; c=relaxed/simple;
	bh=qvDZd12YYrswCqKpLw2h01S+pNThNTn3rqTN1AKKnR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7xRRYSUt+UudYoPxZm/aIPRXErOZ1tIgZUAm/qib6R6I6aGdn6WQ/EU2OG0jOKhI/4q8vSy48/TdTnjf9hI+03NKuUdfZnV2NtDp/xNfgrdvB+ZD9boYTv+i1GCisGUOBhOrqPRECsWs74l1ztwhODx0p0kpoYxEJY1qWowruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mac2ZTDV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=enJMTLniBM5Kp6PifMU8jQddSGPI7IJTI9vrCiUjSbE=; b=Mac2ZTDVexMsCT4rWTuHkNcmiz
	DwSjvN+8pUkcFoGn97WBGxCO3qkG1vDbkpocoXooQ7TiQxSZyyrLXAPwkxSa1LRKyeWlZe03VSEoR
	6MGpYQFxQ/JBsSUXKQY+IC65KOoz5z/lwzCsUWGjSu4SBYMiFJZHgEhx8/XEtcdvtLbO4pL5LKCma
	aniEMp1EnR0LJc72OHZto0MRKN9mMDNdqAd7pUZnomjVxKOnFSRTokt5JF29jfFOEiSk6/PBEuJcJ
	eRCL9zvMOher6Rco634WbPh/3kLTY/zITGrJAk/NCKv/eWyaoVXEPq/j6ab5kUcka8pVMUt5M65i3
	WO6tbSBg==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tMXFx-00000004TCr-0jUV;
	Sat, 14 Dec 2024 18:52:49 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A1D9930035F; Sat, 14 Dec 2024 19:52:48 +0100 (CET)
Date: Sat, 14 Dec 2024 19:52:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ranguvar <ranguvar@ranguvar.io>, Juri Lelli <juri.lelli@gmail.com>
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"regressions@leemhuis.info" <regressions@leemhuis.info>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM
 guest
Message-ID: <20241214185248.GE10560@noisy.programming.kicks-ass.net>
References: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>

On Sat, Dec 14, 2024 at 06:32:57AM +0000, Ranguvar wrote:
> Hello, all,
> 
> Any assistance with proper format and process is appreciated as I am new to these lists.
> After the commit bd9bbc96e835 "sched: Rework dl_server" I am no longer able to boot my Windows 11 23H2 guest using pinned/exclusive CPU cores and passing a PCIe graphics card.
> This setup worked for me since at least 5.10, likely earlier, with minimal changes.
> 
> Most or all cores assigned to guest VM report 100% usage, and many tasks on the host hang indefinitely (10min+) until the guest is forcibly stopped.
> This happens only once the Windows kernel begins loading - its spinner appears and freezes.
> 
> Still broken on 6.13-rc2, as well as 6.12.4 from Arch's repository.
> When testing these, the failure is similar, but tasks on the host are slow to execute instead of stalling indefinitely, and hung tasks are not reported in dmesg. Only one guest core may show 100% utilization instead of many or all of them. This seems to be due to a separate regression which also impacts my usecase [0].
> After patching it [1], I then find the same behavior as bd9bbc96e835, with hung tasks on host.
> 
> git bisect log: [2]
> dmesg from 6.11.0-rc1-1-git-00057-gbd9bbc96e835, with decoded hung task backtraces: [3]
> dmesg from arch 6.12.4: [4]
> dmesg from arch 6.12.4 patched for svm.c regression, has hung tasks, backtraces could not be decoded: [5]
> config for 6.11.0-rc1-1-git-00057-gbd9bbc96e835: [6]
> config for arch 6.12.4: [7]
> 
> If it helps, my host uses an AMD Ryzen 5950X CPU with latest UEFI and AMD WX 5100 (Polaris, GCN 4.0) PCIe graphics.
> I use libvirt 10.10 and qemu 9.1.2, and I am passing three PCIe devices each from dedicated IOMMU groups: NVIDIA RTX 3090 graphics, a Renesas uPD720201 USB controller, and a Samsung 970 EVO NVMe disk.
> 
> I have in kernel cmdline `iommu=pt isolcpus=1-7,17-23 rcu_nocbs=1-7,17-23 nohz_full=1-7,17-23`.
> Removing iommu=pt does not produce a change, and dropping the core isolation freezes the host on VM startup.
> Enabling/disabling kvm_amd.nested or kvm.enable_virt_at_load did not produce a change.
> 
> Thank you for your attention.
> - Devin
> 
> #regzbot introduced: bd9bbc96e8356886971317f57994247ca491dbf1
> 
> [0]: https://lore.kernel.org/regressions/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org/
> [1]: https://lore.kernel.org/regressions/376c445a-9437-4bdd-9b67-e7ce786ae2c4@mailbox.org/
> [2]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/bisect.log
> [3]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc1-1-git-00057-gbd9bbc96e835-decoded.log

Hmm, this has:

[  978.035637] sched: DL replenish lagged too much

Juri, have we seen that before?

> [4]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.12.4-arch1-1.log
> [5]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.12.4-arch1-1-patched.log
> [6]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/config-6.11.0-rc1-1-git-00057-gbd9bbc96e835
> [7]: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/6.12.4.arch1-1/config

