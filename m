Return-Path: <kvm+bounces-71891-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNqlGjFrn2lEbwQAu9opvQ
	(envelope-from <kvm+bounces-71891-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:35:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B83319DE32
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:35:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49F17303B175
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6835931691C;
	Wed, 25 Feb 2026 21:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lD7pE4TF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532432ED141;
	Wed, 25 Feb 2026 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055338; cv=fail; b=G26NI9elP98cELLddHD/AyFP5O4w22q6YS8GjN1IVvUGK4DT2+Y9j7HxzNNpGZj1RH5t5JQ92bGp77kalswf2nYanb2b/J4HuWYm6RSWTVOORDDWHCysGjlyha+kryIVoMEw2J2alWx9dfIFxsGurBGJY4yd9MG3oPhc5oK3NmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055338; c=relaxed/simple;
	bh=IBrnBGOoTW4ToUbPRLtd/NuO5SEBZ6WzAJZoTl1J228=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=tpEjQPszHelWvx0bMR/gA4IamlczLS6rZ+KIJsO3GPE+fhfhEm/Vkv+UyLCHWlAmZ5eiR2vnlXNdFQS+4xlekHKSTBYDtYwjSoMEd+t8YhXVj/xheOYL3SEcCWW333yuuMLvGNSv2pJuqHoZqvCm1pU/hKQxX1uqX9MmDGr12uM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lD7pE4TF; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772055336; x=1803591336;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=IBrnBGOoTW4ToUbPRLtd/NuO5SEBZ6WzAJZoTl1J228=;
  b=lD7pE4TFNAEBNHA6x5wwEnOVCdap+oila6AxvydOC+AKcXea8My7dzVs
   zVoaETBjtMVWLyD6poLrz1YF4nhSb/tp85d4HDexGAbVnxDmeXr5W1sdh
   a9czAViOD7rEOL/2F70NoeUXVzx+KdUolAvLjzvSZQQ1oeB0jYlK4VUZg
   8kiniitpNirBdUu5WLPME/WNJDykviylXLFGUF4XHKJHRrFn7MiQ0ux1x
   HvS1LA8qbH8llmFjiKcEVyvamiKo6aiRRg+xZxvLkqYCP9XGk1ihhwXcX
   XhjhqR+q3+4xUeLBt96K380VHJ2HCffo/PCv/3v0HC7tbqNu1sY27APkF
   A==;
X-CSE-ConnectionGUID: HH0fOjpXTc6ElDhcEfNVQw==
X-CSE-MsgGUID: 2U1OaIsTSLeH+4rKQWTfCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="83438664"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="83438664"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 13:35:35 -0800
X-CSE-ConnectionGUID: pdnLTzmLRX26ZSCLbCKtfw==
X-CSE-MsgGUID: n3w5P7qnRHieUlFtx3Si9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="216496674"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 13:35:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 13:35:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 13:35:33 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.37) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 13:35:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ea3AjjnJOyS6FF9XI80v8E5Mj7joQPiSjYAeAciZga4vOhH+ml2qpSVJ36rrdhzShBzQT0Q+7LfmByg8Ra4rAa19d5a74CG8trVsQ6qoHcnk1XGIWtdpbe93msLQd9lwWWGDam12wWgdex5AeqVV8s/xlWkj1d8aRMw/jsE9UEh+FOyQIH+4jiiNeAgFlA5jash2cdUaVnn+0k28L7hv8Qde2OTBEQq/c/jyFqUrAcvuda8rLlInnHKbTPkPt0v1kzZKp32YPN4m7Z/iqTAc6LvQodvLb5rrfyf0pzekTlmwr9WiaD8nEMSP7NsKrmlxfTJIx3ByzxoizkQpL8QQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s6RnTeNZdZ0H4PRllfMgkUcWCxR2VYnlAq05zp63Q4=;
 b=NwAi4BeiWOyZMyecRlqtvJP5Lr6GcdtbGG9fmUDx4plACNu5KVt8qgpPS7sOH7SSBWhGx/FoZG1mHE9tGyJwwKtqrQDx1XfKzrwjwG3CAscGRIUAAmAR2HZ2mhtReLUDjEOYYMrzb7aO7a/dHOWCAXKbvSIgt0YXhUGOa7lA1OoGESndaCXzjUDAl/awd7zzrR1UfhtrW9HgxQ0jpD+lIpJeEW1sP8GatqjFctnbJkt3QpXAFMEnQi5v/glvnm4iZtJRjGAZkFCjDFcYn5UdjY7Pdm/4jEa9p9DJ0e5nDpB1/m4oFE59uvWzBFIBiLBdwNJzJcDFuxe44x4Uhum9Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB8047.namprd11.prod.outlook.com (2603:10b6:806:2fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 21:35:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 21:35:25 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 13:35:22 -0800
To: Robin Murphy <robin.murphy@arm.com>, Alexey Kardashevskiy <aik@amd.com>,
	<x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, Mike
 Rapoport <rppt@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Neeraj Upadhyay" <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>, Seongman Lee
	<augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>, Nikunj A
 Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <699f6b1ad77cd_1cc51005d@dwillia2-mobl4.notmuch>
In-Reply-To: <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB8047:EE_
X-MS-Office365-Filtering-Correlation-Id: b2a50f56-1d8d-4dee-5c5d-08de74b5c92f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: 5D3urZwrm6b+JKBj9oqAGE/OOEXneEkX2gF+sQtN2lyGQkobNVl1xQs7Aqi2vPigujPYlVh1zEIKM7fdJJNBeYp516gYiwimYPS/JTfBlMXjaHAWMfi5cohLut6iDAQ01FiRsM1l5v1ra12H2ICOA2ZfCzjRDMMKUK35lIXqHHvAB9kg4eEIxKP2CgH3ZQQC3q+oS95vnmT6yw40dph7OPUJ6zUmVbHMOrOHqkZmU2MotIcypg2zAHDaOhhvH0f9ps14bqedAXVJOGJYiLQpr6ApBJ9AtMEFI4onNxOSNLjx2stUhjMRVzfp7tAROIyVRSX+pg+Pehhs2E1b0MCXJis31k1zvPecL6WitszWFEwA067u/3Vf2nF4dTw3PY6V18DqPtANkEkSgtBqbuyyJGV9HKWdYGHj6OpdvTssNXdQ5hsY1JfsEerHBVKy+E9XfqdqQAgDdMS/Z6jWLXwi6Me7GmTz4G6mUq/5aPnHwzu/uh+k1UbsU3nizFrQUh8wpygZK85uNVVwUHmRR7JBz+XWw1qMxNKYIh0nPtBqcmb4GIS9H7DdJdsfqM6F0+pOWcqj0BtmJhhicIl2/vQ9XQkw+ttN89TJ61V0OiFg+NW5dDaN25zBRgqeexio7uyzr+mXcPbbluLoF7hUmgWiVURb7jGTgPSjw/vg6MOHNJd2/Aphj7FhfAZv22sLTfmlOrtZDxgDqmmlb7+aPqirvN9YcWhUmtupph88h/WfTG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUJ6UHFlUGZ6UCtPUkxWSjRFZFNtQ090cjJtM21yZ0tWUVB3dzVLczhCeTVt?=
 =?utf-8?B?S1R6RjY4K0IvM2xOcWZ2OWtmNGZwUy9nS0pReU1BT1RabnZSelNpMm1ZWlhK?=
 =?utf-8?B?b3huUnY0MmVPbVA1cVF1UDhRMWlXNytEQVNYWkZzWmhsSzNBUE44N01UWlIr?=
 =?utf-8?B?OUZjcW41cTlTeUU2Si9NbXhFSWRhcmVOZGh2VGFpYmZ4TjhIWW02QkFxNVFD?=
 =?utf-8?B?b0V3blhTZzBWMGZLeFh6Q202U3NpSytqRmZiZjAvNnhsb2NCWTY2SXVVaTA2?=
 =?utf-8?B?c0YyUjZ3ZlhCVHJrdnNMWnRSM1FRWkx3V2F4bUorRUdiWlo1SE5pcGRRZjJT?=
 =?utf-8?B?WFBJVEtVdlluSW8zWFdrM1ZqRTVHUlArYjlBUzlWWEViS01JMkMzRytBOWl0?=
 =?utf-8?B?WmNHbVpDYWkzeVBFRFdZZGVwbnlHSFJ4cDJXMThFa2t5YUtzM2tlNGVGanRF?=
 =?utf-8?B?UlFxcU0zaGV1QUN4aGlTS3JsaGZWTmptSTFZK2E2NS8yWGVmV05WMVFKcmlZ?=
 =?utf-8?B?aHpuVXhMNzZUY2xCRE8xaEtVaHJHQXlCWkhRL2hLM291dVZvaERNazRZT0VX?=
 =?utf-8?B?U052Z2UwZ2dqMGt1UmV5V1RpcHhkM2FkODRLOEJJdWVNblltQkd0QnhkbHdp?=
 =?utf-8?B?Z2M1QU9WOEJ6TE5sRGdyYXJuQ0R2R3lSVDFBM1hHUWlrWStlT2ZIYzVoaXFR?=
 =?utf-8?B?YjhFMkMvU2M1VUtQcmY0aFkzZGxEdytNQXpLVXN5QU1FeWdqMHN6YkpESjhl?=
 =?utf-8?B?cytvWmhrdnptUUpvb2NNRDJ3T1VIQ2FnSmpZcXYxQXZFS3lBdG1JTnNUVm9D?=
 =?utf-8?B?dVp2TFpXRkV5eVVMR3VIU0dtVUQycHhGZUdsRzZUQ0wrK2h1TVpPYUxFaFZM?=
 =?utf-8?B?UlA4N0VxdzRQMTRUZ0xTclBGYVU5M2xRMEVhejVTY2VwQUQzOUVpaUNmSmZp?=
 =?utf-8?B?VElvVWFrVEJqbWFXQmFzaytkZGN2Z2hhbHlKb3Z0SFNQdG9MaWNsSFZhS04v?=
 =?utf-8?B?ejVZdUdLMWVRSVBGN0x4Z21ZMDRGZmY0QlBWNVZJdVZXa016WE9pN3AxZXR3?=
 =?utf-8?B?OGhHbGExTXZ0cmxFUUExVWtqVlk3V2FUb1J4dVM5WTFJOEVsSjAya3BNYyt6?=
 =?utf-8?B?NDZXV2FKTDlBcml6VlU3SUpGVkU1eTh6TDcrWmVJU09lM0QzRG80WmtrR25T?=
 =?utf-8?B?Qkd2eENkT1NNYlRwMUVUckQvYk1yUlVJbzcxc0xXQjkxWk1BWGR3dzVmeEo3?=
 =?utf-8?B?SnEvUkI0eU8vQmpmaU1EdGFhN2lhbkFDL20vbDl3OUVJSEFwMGthUkZVTGVn?=
 =?utf-8?B?N0lZNkhWb1Ztd2c0OWtBa0lQZWkyK1ZkSTArM3dxWEQ1VU1sSm5MRUtCaDFJ?=
 =?utf-8?B?NC83Q2dpeUtqaXZGU3RBVjRCRW1qNnEyOUZibnZ3QVFHV0tsdjBBZTZuT1pX?=
 =?utf-8?B?d3dRdHE2R1gwQlBWL3E5a0cxaGhJbUJXQStURjUwaWE4K0YwdXF4L2FqY2Nk?=
 =?utf-8?B?WTFBbUNIZlN3OWFqcXhaU1FqTXlEMEVnRyt1VjA5THVXdmtMNmhvQXBrWnNt?=
 =?utf-8?B?QnJMMWtCQk91YUhMS0pONXlvWStTK2tNcWZuWVJyNXdMblMvaGkrU2Vwb3Qr?=
 =?utf-8?B?NUF0a2tiSXFQcTFycDhxaWVyK0dOSzl3M21wV3pESy9ndkxwTE1qSy9Tc0Jx?=
 =?utf-8?B?WXNrbmh6NnFlYnlNSGdnbll6bzA5TXBGZFFoQjdXY2tTcmZwMTFNd3FCek9V?=
 =?utf-8?B?VHBOOWI3bnFoaDY2UFcvYlArUVA5TFlvYUVXM2Y4RVRLSk9jZFB0Y2lXR1Jk?=
 =?utf-8?B?QkJ5VTRMNDMyMjRZaWZkUS9BOHpnQVhVZlhPU0p6QWQ1b04wVWwvNXVqWXBv?=
 =?utf-8?B?Ry84OHdKTG5MOEdNemxHaytFZE8rK3ViMzhFSytGUEpaYm9ERVB6WWxEMFAy?=
 =?utf-8?B?NGpDNXIyNFk0b21paWlVaDBVVVNLTjk3eWN5L2c4QlZZMGFuTDRNcXl5bWV5?=
 =?utf-8?B?VkdlUElLUDlwRUhralJHbXZLZXFwdWQ5S0ZhcHlRcUExRCtRWnhsYjRMVXE5?=
 =?utf-8?B?eFdRVWJXTU15N2xCeGwrd09TRlphWDVvNGZUVGJqWm9HL04yZVZGNGR3elZI?=
 =?utf-8?B?SHpTbGlnZ0Ezb1RSVzZPaXFSQ1N3b3lvVitFM2RsQzhGV3lBYU9pREEwQnpx?=
 =?utf-8?B?eVNQOHZmMjBzb3VXbTNLRDArVzdEbTc5NXJCZlFYOFBCc08xVk9oMjZMZm1v?=
 =?utf-8?B?KzdHRElTV01hRmNTQml6UkMwZ1BJUEdPWS9MSFZZcnZpSjFaa3ZoL2g1VGhr?=
 =?utf-8?B?ejdHVHlCRFVNNS82dFFYaDI2YnQydjVRcjdiS3I2RE9GaEtCbzl6MlVKaUhk?=
 =?utf-8?Q?x2JD/3MzTddzZMUU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a50f56-1d8d-4dee-5c5d-08de74b5c92f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 21:35:24.9415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EY8vf1F+QWkIzGNea7xQBnp6cQnuZuXCwPE/FgUz1azreItRYiiqqrIO01ijFX9FS5vfX9rj72nExz1ZAJ/WQAPoMRnyLDE8VvOrdZHnjZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8047
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_NO_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_FROM(0.00)[bounces-71891-lists,kvm=lfdr.de];
	RCPT_COUNT_GT_50(0.00)[58];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 2B83319DE32
X-Rspamd-Action: no action

Robin Murphy wrote:
> On 2026-02-25 5:37 am, Alexey Kardashevskiy wrote:
> > TDISP devices operate in CoCo VMs only and capable of accessing
> > encrypted guest memory.
> > 
> > Currently when SME is on, the DMA subsystem forces the SME mask in
> > DMA handles in phys_to_dma() which assumes IOMMU pass through
> > which is never the case with CoCoVM running with a TDISP device.
> > 
> > Define X86's version of phys_to_dma() to skip leaking SME mask to
> > the device.
> > 
> > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > ---
> > 
> > Doing this in the generic version breaks ARM which uses
> > the SME mask in DMA handles, hence ARCH_HAS_PHYS_TO_DMA.
> 
> That smells a bit off... In CCA we should be in the same boat, wherein a 
> trusted device can access memory at a DMA address based on its "normal" 
> (private) GPA, rather than having to be redirected to the shared alias 
> (it's really not an "SME mask" in that sense at all).

Not quite, no, CCA *is* in the same boat as TDX, not SEV-SNP. Only
SEV-SNP has this concept that the DMA handle for private memory is the
dma_addr_unencrypted() conversion (C-bit masked) of the CPU physical
address. For CCA and TDX the typical expectation of dma_addr_encrypted()
for accepted devices holds. It just so happens that dma_addr_encrypted()
does not munge the address on  is a nop conversion for CCA and TDX.

