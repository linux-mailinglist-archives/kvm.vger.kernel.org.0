Return-Path: <kvm+bounces-67840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A77CD15959
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 76E98302039D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 22:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35115283FEF;
	Mon, 12 Jan 2026 22:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="kO9UeeRE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gS88dUTJ"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CAE269D18;
	Mon, 12 Jan 2026 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768257171; cv=none; b=FvXDDjRoAcSmVVIIoZjMFYZ7wXNXPJxC1pI87x4BFuKmWoElprqrA8nJlUZVHOCBWVAJWGZJGPALrREppixCbWzujA8h0Kghad8nmWYmY6rkasNtG+7gYUpEEbjF+6op3mIugglVdKeF8zMPzK354koO32JjtSCXpSLKtXywSKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768257171; c=relaxed/simple;
	bh=x0Y8+T56vpt2wLjy2y5lsv//P1lFieQsVosgTMl1AP4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iHlbMOoBnQ+lM9MkQwTW7u+Sxo43m0iRp3Jf/EgmEmJCbnu6rB43E4aHD3boKPHwhEIxW+Vz0gkJd5griF2IE8uoEWSvGDBWAaiFhEJyxzW+XCR1nOeGxWqH8bmOX+Jw9QKutgLQeIXuv9AxrPssD6LYAVbj3CRaw1wfvNFl4bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=kO9UeeRE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gS88dUTJ; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 9A4141D000F9;
	Mon, 12 Jan 2026 17:32:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 12 Jan 2026 17:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768257167;
	 x=1768343567; bh=ZgBrEuDhy3L+HbqTfkoSAu7E5PgSbf+QDr5oTUW4q6g=; b=
	kO9UeeRESmSyeFfvKzuni6bdq/B57jmfZ+XMzpNBjbBLnuhILeVjysXZw6YiHdID
	pwNKsxWcm8OtfmO0NfKzUILiCwDhJveoLuR7RtYa68Veug0wrY5KfxNV1/VVaMn0
	EfZZXNQocIUZzq0jjnGgDVPD/gBeXH4yVepRwf+oihfuElmTDhjRRPx80Agvw0hv
	bAfFJ0YrufW0L+t+JG33WyN2wxqwbH92vi1j2TUP3jT+eKjNIKSlpvPSQNvLq9tx
	ZuFafmv9CLIuUNs2mDgnHT0KxrMkGUWnxIPUivL2H+bnnt0UoCrGjacHUVtYWxNb
	3UrKhXrbozmPiitxLCHRwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768257167; x=
	1768343567; bh=ZgBrEuDhy3L+HbqTfkoSAu7E5PgSbf+QDr5oTUW4q6g=; b=g
	S88dUTJTt9dZ11ZgvPrc2fdP6jQe80jawk07i+DrmIrqvfq8sdAsc1BtxPLDa9lV
	r8p9glV1Ufjjnkpv6nbl2KKZCo4vTyb5JENMnsrHcc2HVsNgmV4kXltCsQQqmB4O
	v11dmMVgm85ntCW32kGKBmeTSipVREOl8SOr9+UeNun+16JUjOeGgmCMzEMCr9wE
	xtrdOCDQSWXETVcV1Of3Xb4MaKeETI2aCGEH6orwpiOcPE2iIr2qBYfil2OqIZtO
	JLjdPZRkxOr/M8gVV/sbpsXUTjG2Hi92tvmE6w/d4PhVBH+l3zxI/Du8UEUppM6Z
	keaBulTPxWwpfJgquUV4w==
X-ME-Sender: <xms:j3ZlaRPDIvQsySsInlKfp--eaV2REk9mXoBVGDngdZE75r1q7GazEw>
    <xme:j3ZlaVdLNQNw4f5b311Dh4w7r46ErpOjhTiV1N2Amxy-3Cx3kDjFHhCEvfj1thQT7
    P99V4AV91p1QgY1-DxjKOBPP3CjiEhpstm5smV9lU8OeQAoA-04>
X-ME-Received: <xmr:j3ZlaQX7qlrvkpg9s8rlh9g8kdSFzJT9bgJYjVNJuEEVcC5D2JztqVYrESE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduudekieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohephedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnthhhohhnhidrphhighhhihhnsehnohhkihgrrd
    gtohhmpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhptghisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epnhgrthhhrghntgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesnhhvihgu
    ihgrrdgtohhm
X-ME-Proxy: <xmx:j3Zladi46_pdzDGRWzislpA68taKdQ_gU6FgJqUEiZKsbqN5qF5fyg>
    <xmx:j3Zlaf8LyatFQTSxxpT4KJsRnaKAIWijYJWpbjWa5OifbXl7812fOg>
    <xmx:j3ZlafZ25u3X90XJSsYO-BGjAXf6A152QoHl-lfrvOnXVCHb-dGTAQ>
    <xmx:j3ZlaW0FjaEt9COe-ZHcFiO3GtB38SbpFKkOAji8RUUr1OBQfxqDjQ>
    <xmx:j3ZlaQAIk-_d9AoQJuPR94BrQx7dAIebKLB6xZC37-qEhC53QM8Iabgt>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Jan 2026 17:32:46 -0500 (EST)
Date: Mon, 12 Jan 2026 15:32:45 -0700
From: Alex Williamson <alex@shazbot.org>
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Nathan Chen <nathanc@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: VFIO_GROUP_GET_DEVICE_FD triggering an "unlocked secondary bus
 reset" warning
Message-ID: <20260112153245.1e64dca9@shazbot.org>
In-Reply-To: <BN0PR08MB6951416BAFA500FC9902DAA68381A@BN0PR08MB6951.namprd08.prod.outlook.com>
References: <BN0PR08MB6951416BAFA500FC9902DAA68381A@BN0PR08MB6951.namprd08.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jan 2026 21:58:44 +0000
"Anthony Pighin (Nokia)" <anthony.pighin@nokia.com> wrote:

> When adding a PCI device to a VFIO group, the following is triggered:
> pcieport 0000:00:00.0: unlocked secondary bus reset via: pci_reset_bus_function+0x188/0x1b8 
> 
> As a result of:
> 920f6468924f ("PCI: Warn on missing cfg_access_lock during secondary bus reset")
> 
> PCI topology is very simple:
> # lspci -vvvtn
> -[0000:00]---00.0-[01-ff]----00.0  10ee:7011
> 
> Full backtrace is as follows:
> [  125.942637] Hardware name: Freescale ARMv8 based Layerscape SoC family
> [  125.942642] Call trace:
> [  125.942648]  dump_backtrace from show_stack+0x20/0x24
> [  125.942669]  r7:600f0013 r6:600f0013 r5:c11bd5e8 r4:00000000
> [  125.942672]  show_stack from dump_stack_lvl+0x58/0x6c
> [  125.942688]  dump_stack_lvl from dump_stack+0x18/0x1c
> [  125.942706]  r7:c3663483 r6:c1c2e000 r5:00000000 r4:c1c2e000
> [  125.942709]  dump_stack from pci_bridge_secondary_bus_reset+0x74/0x78
> [  125.942724]  pci_bridge_secondary_bus_reset from pci_reset_bus_function+0x188/0x1b8
> [  125.942740]  r5:00000000 r4:c3663000
> [  125.942742]  pci_reset_bus_function from __pci_reset_function_locked+0x4c/0x6c
> [  125.942761]  r6:c104aa58 r5:c3663000 r4:c366347c
> [  125.942764]  __pci_reset_function_locked from pci_try_reset_function+0x64/0xd4
> [  125.942782]  r7:c24b3700 r6:c36630cc r5:c3648400 r4:c3663000
> [  125.942784]  pci_try_reset_function from vfio_pci_core_enable+0x74/0x29c
> [  125.942802]  r7:c24b3700 r6:c3663000 r5:c3648400 r4:00000000
> [  125.942805]  vfio_pci_core_enable from vfio_pci_open_device+0x1c/0x34
> [  125.942825]  r7:c24b3700 r6:c3648400 r5:c3648400 r4:c3648400
> [  125.942828]  vfio_pci_open_device from vfio_df_open+0xc8/0xe4
> [  125.942844]  r5:00000000 r4:c3648400
> [  125.942847]  vfio_df_open from vfio_group_fops_unl_ioctl+0x3dc/0x704
> [  125.942861]  r7:c24b3700 r6:00000013 r5:c3179cc0 r4:c3648400
> [  125.942863]  vfio_group_fops_unl_ioctl from sys_ioctl+0x2d4/0xc80
> [  125.942879]  r10:c24b3700 r9:00000012 r8:c3757300 r7:beb3c8e8 r6:00003b6a r5:c3757301
> [  125.942883]  r4:00003b6a
> [  125.942886]  sys_ioctl from ret_fast_syscall+0x0/0x5c
> 
> Some added debug shows that the trylock is successful for the device being attached. However,
> the parent (controller) is not locked, leading to the warning.
> 
> [  126.254846] pci_cfg_access_trylock: locked for 0000:01:00.0
> [  126.255081] pci_parent_bus_reset called for dev 0000:01:00.0
> [  126.255086] pci_parent_bus_reset: checking conditions for dev 0000:01:00.0
> [  126.255091]   pci_is_root_bus: 0
> [  126.255096]   subordinate: 00000000
> [  126.255102]   bus->self: e8833d2c
> [  126.255108]   PCI_DEV_FLAGS_NO_BUS_RESET: 0
> [  126.255112] pci_parent_bus_reset: resetting bus for dev 0000:00:00.0
> [  126.255120] pcieport 0000:00:00.0: unlocked secondary bus reset via: pci_reset_bus_function+0x21c/0x220
> 
> The reset methods are as follows:
> # cat /sys/devices/platform/soc/3500000.pcie/pci0000:00/0000:00:00.0/reset_method
> pm
> # cat /sys/devices/platform/soc/3500000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/reset_method
> bus


Thanks for the report, I'm surprised we haven't seen more of this.
The warning was added in 7e89efc6e9e4 ("PCI: Lock upstream bridge for
pci_reset_function()"), where locking of the parent bridge was added
for pci_reset_function() but not for pci_try_reset_function().  There's
another case too where vfio_pci_core_disable() makes use of
__pci_reset_function_locked() and was also not updated to match the
requirement enforced by 7e89efc6e9e4  Thanks,

Alex

