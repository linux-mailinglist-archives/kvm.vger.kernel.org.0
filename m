Return-Path: <kvm+bounces-42932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5209BA80938
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 14:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B19BF4C846D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B23E26E17B;
	Tue,  8 Apr 2025 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Qf0297N0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Fgq0RluA"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E726E141;
	Tue,  8 Apr 2025 12:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115865; cv=none; b=R3J54HUaTKpGBIkFdYC2sB1xcjzxdTcJ4Qe8zpg/HjhKmEoGBmRjRWfkn7vVrZIOp9lT1HOxbIWjSN+0nBL7irWzILyfNev0IcMPrid4xW1pyfMIvUqoLbppb/teJsape3nJ6mC9793pkNOmB3VGCh4p6o/R+M7u/4zV+H5BZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115865; c=relaxed/simple;
	bh=E2AZipTTbQZtglps7EODNhvVECKl6pYX9kBVNiP95fY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=K8yLQx+zsBzTRf+QhsfWvBVctEuWXTssi0JpX1thB2UJJ54K4gQbf9gyI142uvo1j9KH7qN+EkvCD/hpRy2yoozkPErlYgW/dv0khog6LhDQ2+rzHgxV5zdMt0Xv/m0hOb9b0oqcaTMs7WZpVwNxoBn2WW2SIFrEDsO4yZuELSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Qf0297N0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Fgq0RluA; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 510181140201;
	Tue,  8 Apr 2025 08:37:41 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-12.internal (MEProxy); Tue, 08 Apr 2025 08:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1744115861;
	 x=1744202261; bh=zFcPiZ2dymYdvLOyrug0agUR+Yq1LwHn6b82n9khMg4=; b=
	Qf0297N0imeQiL7hyJIuBesDFq/a+BHRV6/LEPWur/YXXuKI/6r3PZt9rS5Y0vc0
	PnrfpQMzPxPhF4961sVkO7xjPeQP39wn8HSFAXbcgogfLaS7H2GLrIrFY2t89a0J
	h6YXCDdsGtqDNu1c4E1t3zgLp32Ob5TI9Rv6cwYq7MxCkMws5xqtmCPegxELSPa6
	hCxzq6Meypd0fj2IQH5EPo0oQoFwHLbV34hAkeMbLQGNKhNcAM+VLjggfg8TQNlI
	clz49C20jEPQiHBwww6qH1vohrL5KUnacV8CNFCMTHPB01glDLpHAeHBTJoC7xHg
	1NJ8WNzoxP2EflxT9fvZsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744115861; x=
	1744202261; bh=zFcPiZ2dymYdvLOyrug0agUR+Yq1LwHn6b82n9khMg4=; b=F
	gq0RluApzIi0bNAlHRstGMer9QdcAWtQ6SV/MDdmeTKcdBMRJIZaQ529ANUP1tc4
	R7Jzx04bkT0R27M1RWyxyujNcIN2/FjVJ9vP7QT3RNeQdZaUZVA8GHJOwQq0Q+wd
	rKoh8YG/4wrNoitQvUilGZ0Ndo2EdfNcBJDY2KSfOkwgQxe8iB81BbqOp8C6plYw
	59U1k+/iA8gVJiTepKCDQnddfkSy2AqLAk7du1BY2aLq9KuhjQWEe0XNSJsI+V3B
	EWoCq2Fxso6z5at6aYRrSuI9DzaIzuePo5gvvt85ffAAK44wdSXoHynKhDQBNvd4
	G69R0b4EWpOWJWTbaEfLA==
X-ME-Sender: <xms:lBj1Z7hgX3cFpkW0LV58_NIF7J5rMr2Efj0rTurIfQ8OGNnb_NedUg>
    <xme:lBj1Z4CaF4bPuugFG8HjCAB-QCzxWR1xaFwwvo4eHRED9-2-SEzrg9yNlDBfPcski
    gKdJB8bqBI0u6ZITDE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvtdefuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnug
    gsrdguvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeet
    fefggfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohep
    udejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehquhhitggptggrrhhlvhesqh
    huihgtihhntgdrtghomhdprhgtphhtthhopegrihhrlhhivggusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomh
    dprhgtphhtthhopehjrghvihgvrhhmsehrvgguhhgrthdrtghomhdprhgtphhtthhopehj
    fhgrlhgvmhhpvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepkhhrrgigvghlsehrvg
    guhhgrthdrtghomhdprhgtphhtthhopehlhihuuggvsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopehprggsvghnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepohdqthgrkh
    grshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:lBj1Z7EgPLJ8zqV-BwhJaDn18yuAs0d7R3sLR16DH_Ujae8xM6RFaQ>
    <xmx:lBj1Z4RdCM9qLlXZjKC4b3kh5UwXozUBVxSTSgDAg5pu5B1c4PP_DQ>
    <xmx:lBj1Z4wtiJS2jP2YWaO4qJ13ldJJXRcH53SDbNAiSnVH7QSr_PivGg>
    <xmx:lBj1Z-7I3XyQYtYrnodmPe8P6I-m2aivla5dqixH9iL5aQYh-lhXyg>
    <xmx:lRj1Z7XKsbjtdCEd4qgEFEpKQ8t36YicC1s4kOLkwF3pr3f7A4b3PpMs>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5F2962220073; Tue,  8 Apr 2025 08:37:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: T702257fbe5397c0b
Date: Tue, 08 Apr 2025 14:37:07 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Carl Vanderlip" <quic_carlv@quicinc.com>,
 "Oded Gabbay" <ogabbay@kernel.org>,
 "Takashi Sakamoto" <o-takashi@sakamocchi.jp>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alex Deucher" <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Dave Airlie" <airlied@redhat.com>,
 "Jocelyn Falempe" <jfalempe@redhat.com>,
 "Patrik Jakobsson" <patrik.r.jakobsson@gmail.com>,
 "Xinliang Liu" <xinliang.liu@linaro.org>,
 "Tian Tao" <tiantao6@hisilicon.com>,
 "Xinwei Kong" <kong.kongxinwei@hisilicon.com>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 "Yongqin Liu" <yongqin.liu@linaro.org>,
 "John Stultz" <jstultz@google.com>,
 "Sui Jingfeng" <suijingfeng@loongson.cn>,
 "Lyude Paul" <lyude@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>,
 "Gerd Hoffmann" <kraxel@redhat.com>,
 "Zack Rusin" <zack.rusin@broadcom.com>,
 "Broadcom internal kernel review list"
 <bcm-kernel-feedback-list@broadcom.com>,
 "Lucas De Marchi" <lucas.demarchi@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Saurav Kashyap" <skashyap@marvell.com>,
 "Javed Hasan" <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Nilesh Javali" <njavali@marvell.com>,
 "Manish Rangankar" <mrangankar@marvell.com>,
 "Alex Williamson" <alex.williamson@redhat.com>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "Javier Martinez Canillas" <javierm@redhat.com>,
 "Jani Nikula" <jani.nikula@intel.com>,
 "Mario Limonciello" <mario.limonciello@amd.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 "Lijo Lazar" <lijo.lazar@amd.com>,
 "Niklas Schnelle" <schnelle@linux.ibm.com>,
 "Dmitry Baryshkov" <lumag@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net, amd-gfx@lists.freedesktop.org,
 "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
 virtualization@lists.linux.dev, spice-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, Netdev <netdev@vger.kernel.org>,
 linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
 kvm@vger.kernel.org, "Greg Ungerer" <gerg@linux-m68k.org>
Message-Id: <9abf582c-ea8e-42ca-a6d5-34c1e1932f95@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdWN=wurw7qz0t2ovMkUNu0BJRAMv_0U63Lqs2MGxkVnHw@mail.gmail.com>
References: <20250407104025.3421624-1-arnd@kernel.org>
 <CAMuHMdWN=wurw7qz0t2ovMkUNu0BJRAMv_0U63Lqs2MGxkVnHw@mail.gmail.com>
Subject: Re: [RFC] PCI: add CONFIG_MMU dependency
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Apr 8, 2025, at 12:22, Geert Uytterhoeven wrote:
> On Mon, 7 Apr 2025 at 12:40, Arnd Bergmann <arnd@kernel.org> wrote:
>
>> --- a/drivers/pci/Kconfig
>> +++ b/drivers/pci/Kconfig
>> @@ -21,6 +21,7 @@ config GENERIC_PCI_IOMAP
>>  menuconfig PCI
>>         bool "PCI support"
>>         depends on HAVE_PCI
>> +       depends on MMU
>>         help
>>           This option enables support for the PCI local bus, including
>>           support for PCI-X and the foundations for PCI Express support.
>
> While having an MMU is a hardware feature, I consider disabling MMU
> support software configuration.  So this change prevents people from
> disabling MMU support on a system that has both a PCI bus and an MMU.
> But other people may not agree, or care?

I created this patch after Greg said that the coldfire-v4 chips
that have an MMU are not really used without it any more, and
I had accidentally only build tested a patch without CONFIG_MMU.

On ARM, CONFIG_MMU can no longer be disabled on CPUs that have
one, this was a side-effect of the ARCH_MULTIPLATFORM conversion.

I just tried building an SH7751 kernel with MMU disabled but PCI
enable. This produces build errors in several files, clearly nobody
has tried this in a long time.

I'm not entirely sure about xtensa, but it seems that PCI is
only supported on the "virt" platform, which in turn cannot
turn off MMU, even if there are other platforms that can build
with out without MMU enabled.

     Arnd

