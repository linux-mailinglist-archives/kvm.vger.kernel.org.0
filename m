Return-Path: <kvm+bounces-70116-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICgdGK2OgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70116-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 051D7DFED4
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C3C030F6AB6
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7260470810;
	Wed,  4 Feb 2026 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ApRMKyWe"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE42225776
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163828; cv=none; b=SeZJxMVIGVXc9hsOmZ0b6z0RmeUamIkB74hpuC2hUx+vshoD8JI4dPnovtugvgjchdfIp5jqRYt3X/G49UrQtEqIGRkcDDnG9i1eaGsPefSbZVlxvhKhQIu++6wOcW/6UTtBVHXhe5jmsQWXRRJZolGy4oL4kfOzEmGg5JGFR00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163828; c=relaxed/simple;
	bh=ESxIp4/yXKBosB0FyqK/1O/fQD+MS4ChEKPfTEhgPBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbC3CJ1Ut/RVnWQoks8GuXoa3ghlN8edh9epYvIQ4xf1wxfZfzR/U5yF15gnqs2vU6wLNRk5Qe21+A2/yRkibrWtqaWQ61rV7W5NMcUfSCBQej3EwhRgHe1rH1orblWYZkW8yl31Sst3on5MPQscJUjryueVKFmcLdPDGzCJqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ApRMKyWe; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770163814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPnG+2FnaGlQfzxXfIjWuGajlOFPpBxdoaiBCLVKvoU=;
	b=ApRMKyWeexGTzglygbcOHhU7Wfd4rnLeiMI+Jogeatu2nhRqIkK0lA//+bUOV3vFAbHCoJ
	mS0BsrYP93R9bxyxRU1fhniBcUvx2p4NhTCXzAkUT0zL/EyR+YUdOmdiWZC6zP6HhDzLGT
	UyQfu6GTd6zJWiBQ6KJq5hvzWsaEowg=
Date: Tue, 3 Feb 2026 16:10:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
 <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70116-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yanjun.zhu@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: 051D7DFED4
X-Rspamd-Action: no action


On 2/2/26 10:14 AM, David Matlack wrote:
> On Sat, Jan 31, 2026 at 10:38 PM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> 在 2026/1/29 13:24, David Matlack 写道:
>>> Add an API to enable the PCI subsystem to track all devices that are
>>> preserved across a Live Update, including both incoming devices (passed
>>> from the previous kernel) and outgoing devices (passed to the next
>>> kernel).
>>>
>>> Use PCI segment number and BDF to keep track of devices across Live
>>> Update. This means the kernel must keep both identifiers constant across
>>> a Live Update for any preserved device. VFs are not supported for now,
>>> since that requires preserving SR-IOV state on the device to ensure the
>>> same number of VFs appear after kexec and with the same BDFs.
>>>
>>> Drivers that preserve devices across Live Update can now register their
>>> struct liveupdate_file_handler with the PCI subsystem so that the PCI
>>> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
>>> to track the list of incoming and outgoing preserved devices.
>>>
>>>     pci_liveupdate_register_fh(driver_fh)
>>>     pci_liveupdate_unregister_fh(driver_fh)
>> Can the above 2 functions support the virtual devices? For example,
>> bonding, veth, iSWAP and RXE.
>>
>> These virtual devices do not have BDF. As such, I am not sure if your
>> patches take these virtual devices in to account.
> No this patch series only supports PCI devices, since those are the
> only devices so far we've needed to support.
>
> I am not familiar with any of the devices that you mentioned. If they
> are virtual then does that mean it's all just software? In that case I
> would be curious to know what problem is solved by preserving them in
> the kernel, vs. tearing them down and rebuilding them across a Live
> Udpate.

Bonding, veth, rxe, and siw can be used in KVM environments.

Although these are software-only virtual devices with no associated 
hardware,

they may maintain state that is observable by userspace.

As a result, Live Update should preserve their state across the update.

Zhu Yanjun


