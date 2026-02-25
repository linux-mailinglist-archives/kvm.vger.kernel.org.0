Return-Path: <kvm+bounces-71818-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGwHIzbLnmm0XQQAu9opvQ
	(envelope-from <kvm+bounces-71818-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 11:13:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A79195941
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 11:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 071173035025
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 10:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987E2392813;
	Wed, 25 Feb 2026 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="JzCv6ioD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d2xUmUU6"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7C9374180;
	Wed, 25 Feb 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772014275; cv=none; b=TqZW6fnTt0x+Cdv8ovguOzjYOXWI8GdpOtXzmBZE1T/K+GzDcM2zIzmClO5Jo7PzY5idXdv9fv0Z5ny630ghAC2KSNoGCj1c4QsLbZAV4/Sz9N7MTgJ+FqIQIGuBuFy9qCzTG4UU1Q37Y7PRiru039JZd4Yeal2WBMlG6l9zSGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772014275; c=relaxed/simple;
	bh=eSZii8dv7Xz5UWGE+/ISFeZ7qD7AF9CYPLIPb7rv3xU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eSua5iznFSYAVJYdb6/RkzxMc+Qgu4PgCMNLOdqrn5Y9MOCYDgYRbfCXAAVSbwvKo90Rhn3GCfLm2n0Xu6pE5duBIo9EAqZ9mRFNVElh14x/hmboqUoQCsCoCJ4I7ps1wDlp6SSaNLHSJg3e5GsC280H4PtdNieSL8IMn6D4J3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=JzCv6ioD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d2xUmUU6; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 9146C1D0019D;
	Wed, 25 Feb 2026 05:11:10 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Wed, 25 Feb 2026 05:11:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772014270;
	 x=1772100670; bh=Ncaaat0snY7jJs/mEFoT42GaKoP2o+ezuKrxHb8TFHY=; b=
	JzCv6ioDB0BqXmfsEZCXvPY0Sw3htaDMC8jYmlpdD4EeEuqPe0yRRpO69yDgbCHu
	Ovc2CnavUo9tkie66kIrQps/1b/0aufJBzTsRfSkV0sFZgpySyrRdmaurXJX/Kv4
	2H5qwEK0BWoFWBTdMAsqdmR7063YBnAoO4bY3O8LdPnDodJZM+/wxrSwsLfp4tWJ
	X8YMFO+ROkiwGRAs4ttyk90aWoBCD+o1UdAOL0YVGTY3S9awhifHEdA7rokmU9nh
	0tkErVS01mNgcCsw85uyebX7CAksZ+bOuBMG8oyw/nAO2302eRArxAvnVrM7gihq
	s44uR3lWMOLm//JUvSIzEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772014270; x=
	1772100670; bh=Ncaaat0snY7jJs/mEFoT42GaKoP2o+ezuKrxHb8TFHY=; b=d
	2xUmUU6PwqSZ6SNVm4CvwfUXHUhAEiiUf5gn5loHCngarTUd296AKFNNOGT7NWIg
	ytLhKDbTrbbi+XNGBGoyi77TdP6vcpoHofl77wXzK60p/Ynp+H8ovKsr6bAEQIxC
	QByZUtmcNO/ezvIGJndr7QzwbvpSlE+XLB2T1JlcAUWTVUxeb7ttEZo/t2XYwMsk
	H66nSbbjVxL9SUbOw82jF1Sn5+Lbhi57+EHFUvvWnMEwNP4rEOCRBIf6MSnFQ64v
	bFPSl+M5OXr0ExN0uOfnvxNsaHmgrn2thoHifQ0oUAqv3JyKOaRjaRTl2/mT8S9C
	gTbhPJ4QxFD/UO7Tf5thg==
X-ME-Sender: <xms:vcqeaSdl1AFj4zzsRhA0jdoUiMl3H4L6hN6VWfk6ta3Yzu8ozygWDA>
    <xme:vcqeaXDv0odtLvq8mOrUb5U7RWjmhBFFlsV8lFS03lkP756KEoEILtk-2HkcDTb09
    PvcqtE_CgKT72ItlGq7eyqqPJgZgfMLV3f5GRGDSZLzCMikUDAaa3Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgedvkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgtohhmpdhrtg
    hpthhtoheprghlvgigsehshhgriigsohhtrdhorhhgpdhrtghpthhtohepkhhvmhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhptghisehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgsrghrnhgvshesvhhirhhtuhhouh
    hsghgvvghkrdhorhhgpdhrtghpthhtohephhhprgesiiihthhorhdrtghomh
X-ME-Proxy: <xmx:vcqeaWABzzyozLOu5b5Pu-HIQUZNYEa2WJI-pYf-WhN0cqJiUkF8Ng>
    <xmx:vcqeafnQSPK9WLjHYS9GqIpIan86rO7Yzzqbm9nx9qWUmE97nPP2dA>
    <xmx:vcqeafxt2btud1ALsSnf0DFvhzf_UTfKbWKJf-j7Sy7PNuIzNPeYJA>
    <xmx:vcqeaRRanbW1aooC6fQCUUA7fYUYyQavWFP1OIKpgtkegt1WEBmIjA>
    <xmx:vsqeabS-LvgbqlhtBxAjMqXlULUV_7nxq-zJb0Y4qrrZUjpVtLeqjimx>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A9E0D700069; Wed, 25 Feb 2026 05:11:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: APJbg_pXKWbw
Date: Wed, 25 Feb 2026 11:10:49 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Dan Williams" <dan.j.williams@intel.com>,
 "Alexey Kardashevskiy" <aik@amd.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>,
 "Andy Lutomirski" <luto@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Bjorn Helgaas" <bhelgaas@google.com>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Neeraj Upadhyay" <Neeraj.Upadhyay@amd.com>,
 "Ashish Kalra" <ashish.kalra@amd.com>,
 "Stefano Garzarella" <sgarzare@redhat.com>,
 "Melody Wang" <huibo.wang@amd.com>,
 "Seongman Lee" <augustus92@kaist.ac.kr>,
 "Joerg Roedel" <joerg.roedel@amd.com>,
 "Nikunj A Dadhania" <nikunj@amd.com>,
 "Michael Roth" <michael.roth@amd.com>,
 "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
 "Andi Kleen" <ak@linux.intel.com>,
 "Kuppuswamy Sathyanarayanan"
 <sathyanarayanan.kuppuswamy@linux.intel.com>,
 "Tony Luck" <tony.luck@intel.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Denis Efremov" <efremov@linux.com>, "Geliang Tang" <geliang@kernel.org>,
 "Piotr Gregor" <piotrgregor@rsyncme.org>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 "Alex Williamson" <alex@shazbot.org>,
 "Jesse Barnes" <jbarnes@virtuousgeek.org>,
 "Jacob Pan" <jacob.jun.pan@linux.intel.com>,
 "Yinghai Lu" <yinghai@kernel.org>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 "Xu Yilun" <yilun.xu@linux.intel.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Kim Phillips" <kim.phillips@amd.com>,
 "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Claire Chang" <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
Message-Id: <61d6cd68-cd51-4c6c-92fc-5aa6d01fccaa@app.fastmail.com>
In-Reply-To: <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-2-aik@amd.com>
 <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to parse it
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[arndb.de,none];
	R_DKIM_ALLOW(-0.20)[arndb.de:s=fm3,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[arndb.de:+,messagingengine.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71818-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[arnd@arndb.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[57];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,arndb.de:dkim,intel.com:email,app.fastmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 02A79195941
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, at 07:16, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
> [..]
>> +struct tdi_report_header {
>> +	__u16 interface_info; /* TSM_TDI_REPORT_xxx */
>> +	__u16 reserved2;
>> +	__u16 msi_x_message_control;
>> +	__u16 lnr_control;
>> +	__u32 tph_control;
>> +	__u32 mmio_range_count;
>> +} __packed;
>> +
>> +/*
>> + * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
>> + * Base and size in units of 4K pages
>> + */
>> +#define TSM_TDI_REPORT_MMIO_MSIX_TABLE		BIT(0)
>> +#define TSM_TDI_REPORT_MMIO_PBA			BIT(1)
>> +#define TSM_TDI_REPORT_MMIO_IS_NON_TEE		BIT(2)
>> +#define TSM_TDI_REPORT_MMIO_IS_UPDATABLE	BIT(3)
>> +#define TSM_TDI_REPORT_MMIO_RESERVED		GENMASK(15, 4)
>> +#define TSM_TDI_REPORT_MMIO_RANGE_ID		GENMASK(31, 16)
>> +
>> +struct tdi_report_mmio_range {
>> +	__u64 first_page;		/* First 4K page with offset added */
>> +	__u32 num;			/* Number of 4K pages in this range */
>> +	__u32 range_attributes;		/* TSM_TDI_REPORT_MMIO_xxx */
>
> Those should be __le64 and le32, right? But see below for another
> option...

If these come from DMA transfers from a device, yes.

>> +} __packed;

The structure appears to be allocated with kzalloc, so it is always
aligned to __alignof__(u64) or higher, and it's better to drop the
__packed annotation.

>
> /*
>  * PCIe ECN TEE Device Interface Security Protocol (TDISP)
>  *
>  * Device Interface Report data object layout as defined by PCIe r7.0 
> section
>  * 11.3.11
>  */
> #define PCI_TSM_DEVIF_REPORT_INFO 0
> #define PCI_TSM_DEVIF_REPORT_MSIX 4
> #define PCI_TSM_DEVIF_REPORT_LNR 6
> #define PCI_TSM_DEVIF_REPORT_TPH 8
> #define PCI_TSM_DEVIF_REPORT_MMIO_COUNT 12
> #define  PCI_TSM_DEVIF_REPORT_MMIO_PFN 0 /* An interface report 'pfn' 
> is 4K in size */
> #define  PCI_TSM_DEVIF_REPORT_MMIO_NR_PFNS 8
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR 12
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_SIZE (16)
> #define PCI_TSM_DEVIF_REPORT_BASE_SIZE(nr_mmio) (16 + nr_mmio * 
> PCI_TSM_DEVIF_REPORT_MMIO_SIZE)
>
> Any strong feelings one way or the other? I have a mild preference for
> this offset+bitfields approach.

I assume by bitfield you mean the macros above, not the C structure
syntax with ':', right? The macros seem fine to me, while C bitfields
again would make the code nonportable due to architecture specific
bitfield positioning.

       Arnd

