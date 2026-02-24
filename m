Return-Path: <kvm+bounces-71673-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEOBNsYbnmntTQQAu9opvQ
	(envelope-from <kvm+bounces-71673-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:44:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 342E318CDED
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E0DC6305EB78
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A4233B6F5;
	Tue, 24 Feb 2026 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nr2Mpe6V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74633DEDD;
	Tue, 24 Feb 2026 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771969454; cv=fail; b=rlktFpZPn5B5c2+UH5p1a13XBf6PxskUqeNI3NuTmzdaX3f7ln2Z4OYUs5innDqa/CQzTXkMj20CwB+xlLsUS8s4v06a0Q+akpzmqxFUeXMkG4joE/2FbShcnQ9IZPCBeQmup3ZpHcVu2uMMzv3KNXjxczPjJrIizvbUoQ+Tb1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771969454; c=relaxed/simple;
	bh=dVdhSlkcFYYvOrFNdo0Bx78TlmFINIia++16Z6teJuE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aym33sAEC3VgJRHR5W1DkUeF7Ey0qpea83f5svj6SjLdHyxGtNYwBepikx7M97PiLPop+E8WYf6AJZx55MaVtCGLMGqHeYRzwR/t5w0r3M6D9hrlUuVb2z0tkHuRePQw/JqmaVumhdsnSNm4N/pWy+NAfvlt7eUfiM7GiKkNG+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nr2Mpe6V; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771969453; x=1803505453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dVdhSlkcFYYvOrFNdo0Bx78TlmFINIia++16Z6teJuE=;
  b=Nr2Mpe6VqxIJnWxqAd8YpAhvvyD0sWabS0PyTOsmFaBjLXXR2Rf51jen
   mOEf2OZyZwbIy7QnlJVNIyBNQ5y9ka6Ysm6le+6GBxuC80suQA3uwIt5f
   O70GKIDohD9qagYz21rnhgkUrbVw82pbAlFtR8dWXq4hYVxXI9HIDvvdP
   KqOsdbmBLm8f8bs4FQb6Lv1kLuaIivfY7i/bLmVI3tGaeumul0yvOOr4P
   bTPgn7TMP60LjIGSNLsECiIqJEWR8XD2shRNQqjNbChqocRMnJ2jzwmRo
   CBreePvscIwIRGNED8Kk+YP3+2ZERnUlIMp++s7eAcDRwqxhAR2Q3ZKQY
   Q==;
X-CSE-ConnectionGUID: zUaPJ+DySdyJG+nH16b4Ug==
X-CSE-MsgGUID: /aYWQRGQTTKpeVnHMGk41g==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="73041560"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="73041560"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 13:44:12 -0800
X-CSE-ConnectionGUID: rkPTsqUqQtCj5lT1dnukvQ==
X-CSE-MsgGUID: 5kKDKoZnQsa4VMnNa+qvFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="239036317"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 13:44:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 13:44:12 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 13:44:12 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.38) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 13:44:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIWkTakksx1EH9enrs2TZ963TAUQunx082BW7ihzT1h/2VLxkuYKhODsaI/0ZzO+12xTF0WzY5nQbDBs6tmSzsTteMdmiSb73yBUrtryRValhxO5XM2Tr2AinROS3ir5LBAajsF/QXBI/VvlA5x9DdAVrAYYGnEcFhmqekEimFv9BvyfNpqV1I0NooBHqAdZMMOGfL2Bdmb1QEspw82O2BckSmmd5l7qhS1PtfimGbeZ2pGY+HkM8pSKqbJzIXh4Zhw4TaEmPdX7+RDFG0tFaR9ZEPo3fE3oma/xkQmWRdHuuSdrD5hiqtx+szxgc8uSOkjzQNnG5hN4SrVCJ39w+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVdhSlkcFYYvOrFNdo0Bx78TlmFINIia++16Z6teJuE=;
 b=pHlv8sf+2IlFkBEt0p5KbL2trfewd8sF6p2FvjktjM+8cul2tM7Knl75UXBjsLi9TexBVuEG7jaDkCLNyu4msZIUqOa8L5KGLGF1wba/iBZKwKe9R2Jzm58QeL0RVwIJhd/a+bMgV0d3C4LRNuHJOYE4Wy4uoMFkSn7k754xZrg7gLR+B+J9vCAnNOQSNzAaSNySRJlvliH88Rk+5A1QXCGdpJOW0csKX4BVP7v7WK6AD7WP/WpRrNVILvmrcRoAQcE9fr3wc1hHHueoUSb3EKsP5eTD7ukZizHXqf5YcBBnpq7jh7udjHJSxNgyhL7fDgWG201Pxx52vzP4co3imQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6452.namprd11.prod.outlook.com (2603:10b6:510:1f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 21:44:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 21:44:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "changyuanl@google.com" <changyuanl@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Wu, Binbin"
	<binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Topic: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Index: AQHcpQ2GOhqLqfK3/0a3C1hWKddGMrWRGDiAgABzA4CAAHjVAIAALWAAgAAgxYCAABEWAA==
Date: Tue, 24 Feb 2026 21:44:06 +0000
Message-ID: <9ee78e5cb63c0c33e2486142240ab159664f574f.camel@intel.com>
References: <20260223214336.722463-1-changyuanl@google.com>
	 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
	 <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
	 <aZ3LxD5XMepnU8jh@google.com>
	 <d6820308325d5f8fee7918996ef98ab3f7b6ce6d.camel@intel.com>
	 <aZ4NUZdbH6PPUr5K@google.com>
In-Reply-To: <aZ4NUZdbH6PPUr5K@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6452:EE_
x-ms-office365-filtering-correlation-id: f0b00118-a3c1-426a-1cca-08de73edd5db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RUtRZEFzaFF2Vm9kb2lDZmxYbzR1a0JIZG1kS2E1V2QvdU1TRXFEOVIvalVE?=
 =?utf-8?B?d3JxdHBkTlNJWktMR0lCUFowQmthK2hHOVBzQjdZQUlndk1NMkpMQmEzSy9P?=
 =?utf-8?B?anJQS25yWEJLRE9YVkw1VkVlYVdlbm9WN2piY0p4bGZDUEdLaGtmQkVBSEJI?=
 =?utf-8?B?YzROYkVuMEZBbGRIaVlmeHVNdXZqTnlTdHZEdHhQSDJ1bmZBeFlrcGx4SERl?=
 =?utf-8?B?VVdvOXEwSk9ia0NGeS9tVTk0OU4xUE1CU0ovZEt5SnZ4ckpLOFFudDUyTHNP?=
 =?utf-8?B?V29JOTd0MUdUellXSkp6NXl6TUwyUjhrM3g1MXdjNlV3Qlg1ZisxVWtSTG4w?=
 =?utf-8?B?M3RhT1JZSUo1dWZrdHRzamYyV3VoYnFGcFRLRStlSGJ1QVQ1bCtOUHRiYXdx?=
 =?utf-8?B?YU8rOC83TDJnYWZZaGFTYkJGUHNLSTdyK2UwMUlidERxM0poN3BWL3FsMVIw?=
 =?utf-8?B?UUpNTHlSL2tUZlZ5cDJOejZlL3JadUtqZzluRU9hNEw5VXIzYThOTUdhYmFa?=
 =?utf-8?B?SFpoU0E1dy9WRytCOGtoMUlMMUFlU3pUa1hyNU5ZbUdqWk5xZDFRbHBqc3U1?=
 =?utf-8?B?dUpiaU1YOHdDcTRvV29XZmw2UE5SNDRLckpHNTJDd0w1WTdyZmlOME9wTXdW?=
 =?utf-8?B?dXBra3J5QzBTMWhjRENYYVJ3a1FteS8xMWxtUTd0OFZ2WVhMSnpiWTdCekVv?=
 =?utf-8?B?RGRJelkrQjVxK081TitUSEU1bmdnMDBCQzY3V0VsSzQxWis5N3NFL0htU3lj?=
 =?utf-8?B?cDFtaHUvVTk2M29aRzgwS1lRWk8rV3VEOWN5K1pIUDJOMFhMSHdvd1JVWWhN?=
 =?utf-8?B?WjI4SlpWSndNMzBjVGVzdGk4ZjNXMjNadlJTZUZTYVNGdFRqUXkzVTBlWkpK?=
 =?utf-8?B?OGZoNWhKdXVVZW96anJMemFYa0k4N0dSeE5CeWhSQVFXTDgzSHJnZldXTkhQ?=
 =?utf-8?B?aVAyUXdldU50THRMQWVPMFpjZDA2a0pYaVNwVDVsc05FcDQ5cnpZUUVmM2p5?=
 =?utf-8?B?c25USVVVQXk0aHExeFF5Qmx1OWthT2Flc245aU1wbzNhS0FjbEdsajEyRXlq?=
 =?utf-8?B?bU05YWNlUEhvR2pjTk9PbEtmQWhoQk52SVhiRUdndjROZmZxc3NLYVA0cVJS?=
 =?utf-8?B?NVhkUlljbzYyR09XNlRpbUhqZ3dtMDFSUHNwVGw1cEVrQWdiZUt4UTd2bGlI?=
 =?utf-8?B?YWMrN1NDSVhhaGloNDFDekhOZUJLbllQWlltY2J5OW1FY1NQbjJFOHIxeHdq?=
 =?utf-8?B?UVlZUnJKamcxek43WktrZEVGZWZyQ1EvREZ5enFrbGlqY2dtVGVLajRsVzhp?=
 =?utf-8?B?eC9HbmZCYzlaWmd0U0kxcXpZcTcvMUxaTzR3ZmpkZlJGSzFxWEUrUTI0UDl3?=
 =?utf-8?B?dUcwTXZDM3VPWDRUWGxTMnhSNEZ1dFo0SzlSckthdVR0UFBiRlh0ckJLRzU3?=
 =?utf-8?B?SUFWVVgyWHB2bWZQRm12MjE1L2NqSHVpNjlrR2lEcDhMRTVKZU1hTWxkU0c1?=
 =?utf-8?B?SnA0T3F2NTZEakVyN1c3RG1OS2FBTW9oTzJNUVQxSWtnNVRjZXFiYmNZcjZl?=
 =?utf-8?B?N0VIQS9ESk5qU29Fb3Bka2lJajdMZk5XNVJqS3pXaThpblY0S296aTRhWWNt?=
 =?utf-8?B?OVlDeFF6aWUzckprU0tjR3A0Ymw0Y0hDSnExSDZTeHRXcEREMWtLMFBQeDlF?=
 =?utf-8?B?MVV0RHlXS1AzcUVWWEtiZVFCckovUUNHL3hIdkY4M1NNMEtyUHN1Z1dKVGt4?=
 =?utf-8?B?Q0xmQy85U3ZFb0pEMTRSZEZXa1lFeDNxY3E3b3cvY29PVDRiRXgvbU1UYWJw?=
 =?utf-8?B?dHpsY3NDS2FZM1hMa1NxaFp4VE9aeUpIbVptV3hkMUNQUUtKbU8wdHRTa0Rq?=
 =?utf-8?B?dXI4QlRRdy9oWThQL3JuWWpTTEk1WG5hVm0rek81MWlmL2Jxdzc4Q2dUMnBt?=
 =?utf-8?B?anhJY0hvOTRSN0YzME8rZTBqR3dQbSsvUHFORzRMWjBzSDQyOVdsWENieFVY?=
 =?utf-8?B?YVZYMDIwUmVkRHFKUmt4MW1GRVVyeTZUWk9Ydys5Vm5PdVVOZ29qbFpNTkRV?=
 =?utf-8?B?UmJJTjA3ZU1aRVdxMEwwYVYxQ1laSDl4dTdUVTVVMmtFTVQ2c2FuZWxOcDBF?=
 =?utf-8?B?U1lmeWlJaDdIcUVSTUlPS2Z0WmJxUzExY21vMFAzT0RIUGc4a0xSdzdzazZ5?=
 =?utf-8?Q?D7ye6JdDnjrPyB8/ONpczUo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UC92SVBWbVBjMW1QdEdGZmE0dlo0NUk0NmNwYmdZM1I3cGlIdStPK3pneStY?=
 =?utf-8?B?bWJNSFk2OElmanc4Uk16MVNCMmpuRTNXc054Skw4ck9uY0xER1orZnlhU3Rq?=
 =?utf-8?B?ckdKTk1uWHgrUFZ6Vm1ERWdaUk5DRnVZMGpONVRBM2FWeEJBZ202TmhSQk1q?=
 =?utf-8?B?a2RqRGxMMFk3QnVKT0x0NnpzOGlVWWJ1SGJrS0FCTk0rc1VScTVUc3ZJTDBq?=
 =?utf-8?B?ejE3SDBiWllwdit6NmdEVjBaMFczNTcxMTlwRUNKUTllV2lKalB4MzhZS1Uv?=
 =?utf-8?B?YUZQRXdiYXdmMFRVSkpBVG1uaVNRZm5Wc3ZCeVVqbGRGb3pOTlhJZGtNdXdY?=
 =?utf-8?B?dUt1U2ZJdnE3Sm9YWnJiT29zazZERk9ianF2akpydlZSbm1ETFkxbFJtNEUx?=
 =?utf-8?B?MU1wNEpJeWo0VWRRNjlGaXAxb3NlV1pNV2krOVc3UTgrRm45aXRENEdnV3pN?=
 =?utf-8?B?UzZmaUlRL1BjS2ozV1h3ZFRuZTVQM21uOExNTmlraUFIdm9ESzBSU1hna29Y?=
 =?utf-8?B?OWwrWjAyZ1JCbUJaTkY3dlNZWkwzMXFWelpGaU1YQ1pUaFhleXYrQ3JlUHQ0?=
 =?utf-8?B?aTRTck10OW52T25UTnJNK3hNNUFCUGplZGpVZ2xUTWVid3pPYTBHVnJiaUNE?=
 =?utf-8?B?RDVWYXZOQjBlc0tteENvRDVWZk1kcGNwdDBsR1pVWk1QYTBGZEMzL1YwaG1m?=
 =?utf-8?B?d3pHbityT3l0cm5XSThkQnJNa0RyK3JXcXZzYWZuSUlUYUZITnY3SVc1clRz?=
 =?utf-8?B?c1lodkZsRlhkU2d6eThvVmZpYWM0bEN5eXZDcHJiQVJZWnNkZUU0czJ2ZTho?=
 =?utf-8?B?SjdEcHdVWHdLTFZMWjYvRnVjTnFwV0ttcFBvcXplSStQYkcvN2hwZzl3Z0hn?=
 =?utf-8?B?OW9ua0FWK2EybmxBZFdXdkNHN1J0dXhqSDNUTmpMUmpIa2htZHRtWUlWY3Ax?=
 =?utf-8?B?Rlc2TmxqZnllL3gyQmtYOHBpMUoyN1JIUzJWOEVKVzVwT0lBUlpDUVFzZkE0?=
 =?utf-8?B?aElJQ1BmVjQ1YTZJN0YvbmNONnFPMTVQbXhCaUJXWDB1cUIrUzR2MGJtR0M5?=
 =?utf-8?B?d0ljNzlubDhBcmdnZXdrMzRIaFczVUxtY1ZmYXptQjUrMVJOZ1cxTkFvamts?=
 =?utf-8?B?UDc4L1ZaU3hBajJWY0dlakdYS1UxR2tJNXdYaEFueU94WDk4NDlncmNCbUJj?=
 =?utf-8?B?RzR6SVRxbVFYTk5ycnFQMUx2M0hRckRnTGwybVlmdk8wcm1wVFNnckhjWDBP?=
 =?utf-8?B?VnVkRlg1V0g0OWFoNXhXS3dja2dPdUFSSEtjS3pKaU9QUFVtQ3RCN21DUXB6?=
 =?utf-8?B?T3RhanNvQ1Y2bVo5a0RFOXcvZnArYXAxanE5L3JzNWJvbWZDZFhnRHlzOTUr?=
 =?utf-8?B?bTArdHdaT3pvcGFoZnhhaC9YUVNGM1kremI1WmwwOXJXTkxxTFRFQ09XYWVE?=
 =?utf-8?B?Ymxaak5hSGRCNGlSb0dycGZDeUhwWC9pS2ZOSHRGZEF5dTQ3bGtoTTBsUnNs?=
 =?utf-8?B?bWp1a1QvZFJUZkJOV1lZTzNWVGxFdTVUaEpySCtMNXlNRUJoMElJbTRTNUM2?=
 =?utf-8?B?ZlROWXdiZ29RbytxNGxqNDFTampiVTFlRU55YU9QRlRmck1PM05hSWRLdjA3?=
 =?utf-8?B?by83SnZPSkxjaHJTVk10bW1iK1JGcGVrbXdaK2tkQmd3K2dtZHpyMk9LMVY5?=
 =?utf-8?B?cWRuUnpTSzMzVncybCtjMjVFMHovTlFZalVLRjEzWUYzVzNPdWY2ZnhXZWNO?=
 =?utf-8?B?Rks0MTJoN245VUJtUmxEblZOdjBvQkVKSUlJQU83YjNXSU1OR0lJQno4NE5X?=
 =?utf-8?B?TWYxWVRTQWFZL2pRRVdoTlU3aFNKMEI3K3pBOEU2NERGUUp6Zjh2US9hNi9p?=
 =?utf-8?B?V0VSWHB2RW9ZT2wzbERTb1FJWllYeWtZeXI5YVQ0T0RLLzdST21OMXg0Z3cy?=
 =?utf-8?B?WTQ4YnNaTHRWZmNZTkRFb0djd3d3Z01wcGV5MFRzZ2xwTmNBb1U2OGw4Yk9h?=
 =?utf-8?B?TWU2cm9Oa3pFVkI1OUJiNXdHSjM3aFoyWmdoS1RKQmhGYjBVcWVwZ0syY2NN?=
 =?utf-8?B?WkphZklkTWRkZ3JjMTkyS25CU0QyRXFMSXo3VU9VTlRMcUVWd1VjYmtNY2Mr?=
 =?utf-8?B?dnd6VGx2SGtCdERIbmJTS0lpMjl3RnFtb0ZYTHBWOVpaYStTWUlZbUV2RU5n?=
 =?utf-8?B?bXZ0Nk9SMkhSQndlMU5ERGtGZ0JWOVcwdkJueUZCSUk5a0JNcG9YOGFHUlQx?=
 =?utf-8?B?YnA0cjJxdlRnSFl3L1JvMkJaWUhGZGd3bkg3L2NEZGU4VmVRS0VLSEJDb1pQ?=
 =?utf-8?B?d003TDJ6MzlsaXY5QUo0QXJYNjUzUmxneHhXMnkxWXh6UEhRakt0Z3BXemtl?=
 =?utf-8?Q?Tx4zbLWOqs67mkRI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1162231AD202544982195E6BD51A31EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b00118-a3c1-426a-1cca-08de73edd5db
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 21:44:06.5277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cx9qHZ15WskRo8OEoH8Ih1ruxxYj1F/fYLjMgKDeKR7HLNabnOtllp8tna84FyqSveiaPGScX1HcpMu4i3N8SHTVwiOSYxL/Q/I8Kcwwbjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6452
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71673-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 342E318CDED
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEyOjQyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEknbSBzdGlsbCBub3QgY2xlYXIgb24gdGhlIGltcGFjdCBvZiB0aGlzIG9uZSwg
YnV0IGFzc3VtaW5nIGl0J3Mgbm90IHRvbw0KPiA+IHNlcmlvdXMsIGNvdWxkIHdlIGRpc2N1c3Mg
dGhlIFdJUCBDUFVJRCBiaXQgVERYIGFyY2ggc3R1ZmYgaW4gUFVDSyBiZWZvcmUNCj4gPiBkb2lu
ZyB0aGUgY2hhbmdlPw0KPiANCj4gU3VyZSwgSSBkb24ndCBzZWUgYSBydXNoIG9uIHRoZSBwYXRj
aC4NCg0KU2hvdWxkIHdlIHRyeSBmb3IgdG9tb3Jyb3cgb3IgbmV4dCB3ZWVrPw0KDQo+IA0KPiA+
IFdlIHdlcmUgaW5pdGlhbGx5IGZvY3VzaW5nIG9uIHRoZSBwcm9ibGVtIG9mIENQVUlEIGJpdHMg
dGhhdCBhZmZlY3QgaG9zdA0KPiA+IHN0YXRlLCBidXQgdGhlbiByZWNlbnRseSB3ZXJlIGRpc2N1
c3NpbmcgaG93IG1hbnkgb3RoZXIgY2F0ZWdvcmllcyBvZg0KPiA+IHBvdGVudGlhbCBwcm9ibGVt
cyB3ZSBzaG91bGQgd29ycnkgYWJvdXQgYXQgdGhpcyBwb2ludC4gU28gaXQgd291bGQgYmUgZ29v
ZA0KPiA+IHRvIHVuZGVyc3RhbmQgdGhlIGltcGFjdCBoZXJlLg0KPiA+IA0KPiA+IElmIHRoaXMg
d2FybiBpcyBhIHRyZW5kIHRvd2FyZHMgZG91YmxpbmcgYmFjayBvbiB0aGUgaW5pdGlhbCBkZWNp
c2lvbiB0bw0KPiA+IGV4cG9zZSB0aGUgQ1BVSUQgaW50ZXJmYWNlIHRvIHVzZXJzcGFjZSwNCj4g
DQo+IE1heWJlIEknbSBtaXNzaW5nIHNvbWV0aGluZywgYnV0IEkgdGhpbmsgeW91J3JlIHJlYWRp
bmcgaW50byB0aGUgV0FSTiB3YWFhYXkNCj4gdG9vIG11Y2guwqAgSSBzdWdnZXN0ZWQgaXQgcHVy
ZWx5IGFzIGEgcGFyYW5vaWQgZ3VhcmQgYWdhaW5zdCB0aGUgVERYIE1vZHVsZQ0KPiBkb2luZyBz
b21ldGhpbmcgYml6YXJyZSBhbmQvb3IgdGhlIGtlcm5lbCBmYXQtZmluZ2VyaW5nIGEgQ1BVSUQg
ZnVuY3Rpb24uwqANCj4gSS5lLiB0aGVyZSdzIG5vIHVsdGVyaW9yIG1vdGl2ZSBoZXJlLCB1bmxl
c3MgbWF5YmUgQ2hhbmd5dWFuIGlzIHBsYW5uaW5nIHdvcmxkDQo+IGRvbWluYXRpb24gb3Igc29t
ZXRoaW5nLiA6LUQNCg0KSGVoLCB3ZWxsIHdlIGFyZSBhbHJlYWR5IHNlZWluZyBuZXcgQ1BVSUQg
Yml0cyB0aGF0IGNhdXNlIHByb2JsZW1zLiBOb3QNCnN1c3BlY3RpbmcgYW55IHNlY3JldCBtb3Rp
dmVzLCBidXQgbW9yZSB0cnlpbmcgdG8gZ2xlYW4gc29tZXRoaW5nIG9uIHlvdXINCnRoaW5raW5n
LiBXaWxsIGJlIGVhc2llciB0byBkaXNjdXNzIHRoZSB0b3BpYy4NCg0KPiANCj4gPiB3aGljaCBJ
IHRoaW5rIGlzIHN0aWxsIGRvYWJsZSBhbmQgd29ydGggY29uc2lkZXJpbmcgYXMgYW4gYWx0ZXJu
YXRpdmUsIHRoZW4NCj4gPiB0aGlzIGFsc28gYWZmZWN0cyBob3cgd2Ugd291bGQgd2FudCB0aGUg
VERYIG1vZHVsZSBjaGFuZ2VzIHRvIHdvcmsuDQoNCg==

