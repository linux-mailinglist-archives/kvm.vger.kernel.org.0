Return-Path: <kvm+bounces-33862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B4C9F3465
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 16:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEB5918845B3
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 15:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745D01474BC;
	Mon, 16 Dec 2024 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fHDdbv42"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19413C690
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734362608; cv=none; b=BVtPfZwGKTmn3PwYdoU/o17JlCceWgwFdQTV/6zIvmBIbO9BO/AgLiH7hY9NfyHn1clmG/5uowouidvLI7RCYHHOmw9IJUFadXPjZQFd1t5SCFphfDbO3LLYKO+4pIREQXBQlBUlNAZ1HBAVrG2B/0envvrkTQ9CStbUwN3HcSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734362608; c=relaxed/simple;
	bh=QtQQsUiJel4bUfPgyvGeB68f8I6g4jzU2Xy/nrs5h8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rk26mtl21WlGTrXQOhgYmsEiJrxWVCkNgg27k4DMobz8IZU/DRfLH2gEjWbflNfAWU8GwQU3l5o+4USSHM23Iqr9aZS1kfSQr1EfOLKhJQF1gjTJEiNDAfiLySjK8lU6aZoLnrjcvfsea5Jl8eBG1+BsPJrtwUuHOVmOkS2EO40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fHDdbv42; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734362605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=22hfpCiAB76G1lhRVgQIdpwqzCYya1oQySaYuhV9NKI=;
	b=fHDdbv42PK2BR+ttWGyennbL9DC4p5eY2+9xaVCnyAF7p5zf4JuvLPpKbPC90PGAv075pq
	Q35S8rvrCslrQ/lFS/rwnFLNmUtm1iQbhDQq+PMclATa1bZFx2a8J0TQuVArAeaI+9ogw7
	c1BA/GOJcVyXYbtywgL1IJm6Q2aidkc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-JtIADmn5PveLFK4BxmaZSA-1; Mon, 16 Dec 2024 10:23:24 -0500
X-MC-Unique: JtIADmn5PveLFK4BxmaZSA-1
X-Mimecast-MFC-AGG-ID: JtIADmn5PveLFK4BxmaZSA
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d88ccf14aeso81031936d6.1
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 07:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734362603; x=1734967403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22hfpCiAB76G1lhRVgQIdpwqzCYya1oQySaYuhV9NKI=;
        b=WawXE3zCriTHO/2D48J09kWB/QcIze3vnPLxSIwf4LK9YccyQXV89+c/zBvp2XX5/k
         h4OFSjCB8Himkivnn5Eocawv8tbLB5yEVcZYN+1N3e3CYI3tX6Cz0eBrYT4uRMng4LxW
         49zAUo7FuvBApZcXQLXwq3UOkzzII235+oUQ5YzTIxj+5HPIVHijjGIZ6yBWBT6e3nkC
         OPvx5eqms3fsWkTa5KHlMKTp424nL7wPt2ko0dx0aRnIw8j5tBoZd8OEpW/C6g8HG/Kc
         MSkHaM9jUzh3QeR8vUAPM1Gjc2OxHkpxi3o+TNDESYGJ91m29kZtk7DUcwY/kKBoRU/p
         vn8A==
X-Forwarded-Encrypted: i=1; AJvYcCWwWNhWdmbBdQ4h6yZ6SyBRgfIg1xKb8Nca50jwwIPR/0WINfgkQk8uGq5pdWJ0pDDVBVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpZpkYJIjNup7lOrV0D0CK8Qq4XF17mM0HaitgSDTdEWxgwIkr
	8cO0CYXR/XroK6OYco7ToKI5fnvK4iH2H2kwtZGLDRJrPWJPST8mpp40B3u/WnxV6VCIil8oHqc
	PstsZI1tRTCD/xB4XAd1uvujrtxJ82xop0PGhUNvhzFXe4Ywr50EYT3DKOgS2
X-Gm-Gg: ASbGnctYJs5dfQtnOvm3eXpZYPJclsXGU+UyTjIPkaNAN/PKH/Y10vWg6wPXGKqKONZ
	3BT/Rv0Ixslxjox8b9iY60iGy9BMJ7sN31Gywde2pZNji+Bg1bTx6yVxCaPQ9f1Tl1NqJ+ZzFjd
	wGsrhVlVQcQAN6Add3sL6W7W95zrsUA6ftecYuNzhOQ5i7M0cGn0OQ5FfHkZThmtqUfeyn2dY8D
	npG97154ZRbfVIuWAsvWx2PeWS/cXIiUShxMbdudlj0reqCUkSdsCKMq6XQnDn9M2D1UtBw2+AB
	yZTlwo6+HqBTvpzofUweflrhj2X7XPMuAdTxNQT31dE=
X-Received: by 2002:a05:6214:194e:b0:6d4:2646:109c with SMTP id 6a1803df08f44-6dc844afed0mr215332056d6.3.1734362602936;
        Mon, 16 Dec 2024 07:23:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7QXHgGXzgEjQZ3uTdpr42Buq+L+mX3JmSnr4maysHO6br7rvRW5Vl5hNJwPdDyY7Ey/ZXYQ==
X-Received: by 2002:a05:6214:194e:b0:6d4:2646:109c with SMTP id 6a1803df08f44-6dc844afed0mr215331766d6.3.1734362602600;
        Mon, 16 Dec 2024 07:23:22 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb (host-80-47-197-226.as13285.net. [80.47.197.226])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd279544sm28346516d6.70.2024.12.16.07.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2024 07:23:22 -0800 (PST)
Date: Mon, 16 Dec 2024 15:23:18 +0000
From: Juri Lelli <juri.lelli@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ranguvar <ranguvar@ranguvar.io>, Juri Lelli <juri.lelli@gmail.com>, 
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>, "regressions@leemhuis.info" <regressions@leemhuis.info>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	juri.lelli@redhat.com
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM
 guest
Message-ID: <gvam6amt25mlvpxlpcra2caesdfpr5a75cba3e4n373tzqld3k@ciutribtvmjj>
References: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>
 <20241214185248.GE10560@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214185248.GE10560@noisy.programming.kicks-ass.net>

On 14/12/24 19:52, Peter Zijlstra wrote:
> On Sat, Dec 14, 2024 at 06:32:57AM +0000, Ranguvar wrote:
> > Hello, all,
> > 
> > Any assistance with proper format and process is appreciated as I am new to these lists.
> > After the commit bd9bbc96e835 "sched: Rework dl_server" I am no longer able to boot my Windows 11 23H2 guest using pinned/exclusive CPU cores and passing a PCIe graphics card.
> > This setup worked for me since at least 5.10, likely earlier, with minimal changes.
> > 
> > Most or all cores assigned to guest VM report 100% usage, and many tasks on the host hang indefinitely (10min+) until the guest is forcibly stopped.
> > This happens only once the Windows kernel begins loading - its spinner appears and freezes.
> > 
> > Still broken on 6.13-rc2, as well as 6.12.4 from Arch's repository.
> > When testing these, the failure is similar, but tasks on the host are slow to execute instead of stalling indefinitely, and hung tasks are not reported in dmesg. Only one guest core may show 100% utilization instead of many or all of them. This seems to be due to a separate regression which also impacts my usecase [0].
> > After patching it [1], I then find the same behavior as bd9bbc96e835, with hung tasks on host.
> > 
> > git bisect log: [2]
> > dmesg from 6.11.0-rc1-1-git-00057-gbd9bbc96e835, with decoded hung task backtraces: [3]
> > dmesg from arch 6.12.4: [4]
> > dmesg from arch 6.12.4 patched for svm.c regression, has hung tasks, backtraces could not be decoded: [5]
> > config for 6.11.0-rc1-1-git-00057-gbd9bbc96e835: [6]
> > config for arch 6.12.4: [7]
> > 
> > If it helps, my host uses an AMD Ryzen 5950X CPU with latest UEFI and AMD WX 5100 (Polaris, GCN 4.0) PCIe graphics.
> > I use libvirt 10.10 and qemu 9.1.2, and I am passing three PCIe devices each from dedicated IOMMU groups: NVIDIA RTX 3090 graphics, a Renesas uPD720201 USB controller, and a Samsung 970 EVO NVMe disk.
> > 
> > I have in kernel cmdline `iommu=pt isolcpus=1-7,17-23 rcu_nocbs=1-7,17-23 nohz_full=1-7,17-23`.
> > Removing iommu=pt does not produce a change, and dropping the core isolation freezes the host on VM startup.
> > Enabling/disabling kvm_amd.nested or kvm.enable_virt_at_load did not produce a change.
> > 
> > Thank you for your attention.
> > - Devin
> > 
> > #regzbot introduced: bd9bbc96e8356886971317f57994247ca491dbf1
> > 
> > [0]: https://lore.kernel.org/regressions/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org/
> > [1]: https://lore.kernel.org/regressions/376c445a-9437-4bdd-9b67-e7ce786ae2c4@mailbox.org/
> > [2]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/bisect.log
> > [3]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc1-1-git-00057-gbd9bbc96e835-decoded.log
> 
> Hmm, this has:
> 
> [  978.035637] sched: DL replenish lagged too much
> 
> Juri, have we seen that before?

Not in the context of dl_server. Hummm, looks like replenishment wasn't
able to catch up with the clock or something like that (e.g.
replenishment didn't happen for a long time).


