Return-Path: <kvm+bounces-47928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE078AC7757
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 06:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9516A1BA094F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 04:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519FA25290E;
	Thu, 29 May 2025 04:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="gADiATrP"
X-Original-To: kvm@vger.kernel.org
Received: from esa13.fujitsucc.c3s2.iphmx.com (esa13.fujitsucc.c3s2.iphmx.com [68.232.156.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31624DFE4;
	Thu, 29 May 2025 04:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748494436; cv=fail; b=Plm1iRG5SB1hCI2BvnpQR63+qe0vwmzqQOnRtZ7cMGiF+C362CR0B4SgHX+Vo3nlO8aNgEx6FMhkETbL2eK76BxKIdsQ1ZWBKpEOS+hHfc1J/2bHGrcvqal0TAPrVX3oc1T86N+L4u795ipi6wIOA0Fn6NvGg3slPcNcByl8d6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748494436; c=relaxed/simple;
	bh=HNjsYSNDGfMO2NUSLrakQDxfb0LfG7oIOoPopN0Mh3M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pSrkwgS4e9YIAdmAf6lyQraM8fvxQdt2PlMxdBvnrXkQUqUmXdyXFO+XDx4EnTdxryaIGG0hlkLgs9pY+p79NMWy6TfbA2UwKxrHbFc8S/05HhFGzchxVevG8W/7ITIXSpr8cXp7c7fMC8mJxMDuhaLo8Yu05NKY9geht+eEeGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=gADiATrP; arc=fail smtp.client-ip=68.232.156.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1748494434; x=1780030434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HNjsYSNDGfMO2NUSLrakQDxfb0LfG7oIOoPopN0Mh3M=;
  b=gADiATrP0zNb05H3/VlGmv9RxokUsQG85hi8NIJsneSb2gFLWcvBoMG9
   PFzaxwWgq3ECkGQvaJZQbad9v5bFOZgkgJlU1+yuO4+tuf4UdNQNRBukS
   nRUxyxmTXKNp4RCKdmWzgNz6ugB7R3fh1b+qMoHd/sEDBHU8QTexc49NP
   rhruiTeFukBEM9vDL+ZyE1VhIPb8Oxes39Aa6Pny4MMoZI5/Hpb6Hc5G/
   vvCqoPzdWnFMSf4HKENL2UTM9lAGG9LthhWCkHDnIf9KDMIALB5An9UYn
   gDTGZ7StUd62buhM43ZKTMDd90qmb8AmHwFfSpyGuVfCEMXPBzlAxt5Y9
   w==;
X-CSE-ConnectionGUID: FyHafbDsRBKvy0YdeCEdGw==
X-CSE-MsgGUID: ej/iXiCsSTG/j2S/EqHquA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="156450964"
X-IronPort-AV: E=Sophos;i="6.15,323,1739804400"; 
   d="scan'208";a="156450964"
Received: from mail-japanwestazlp17011026.outbound.protection.outlook.com (HELO OS0P286CU010.outbound.protection.outlook.com) ([40.93.130.26])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 13:52:37 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pr9SLaVpeKgJ7OEHwAcYPXogfgGbZnp/yzPvOMv5+AtzBQtU51xkAH3s+UFvBRKeRf6/JCXhKJuVxzDHo6qE1ET7Y1v7Z64SrWKb+eEQWlGs+wXvLyGBkWEM8vsPyrBwQVqNoUu3gIKAIDBg+RiHli01h1lV4Xe7Xgc93zVPc9y7mwe+qiYdhK+76Ef3PYs3LP8+stDcTILudk9lLvUxUXH9XU86F2MMbbod4tVrKDkkMiteqlq4Nb2TqkWAeckvephEabtozND1PkVkSDjthCqtePV01tU40Z99yt2iC19JboHCi4gry/fOm+5bwsLM1kpmX2lGzEgXZbjksx13nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qioMlpApMqt+A1CQCoNF9t5zFK0+B2haNOrT7LS6vI=;
 b=yDwHEBW4uF2Sb9rpd7gDXLlYGVtJ97VhHnXqiz4rROCMVY0hb5sOev8ulcEsXDNEA67QEMI18oR+BpX7fHQHqP/nlvB/AJa0b6e7hgVxklsCRqWUnirwiFZr0UXvfK4ZotLM4MRcOReNLpcnZ+OCIzY3jiY6aRnnIGBknTYcoFTr+SXY0nj+esVcUW2oTixaKkPWLpbXScIB4ws713ZfSxI1VHtGZ6pUtwJb0p0VXfYAwSR3GIAXHRO2+17C138QN6x0qnX7jBwwItify094MrW+4ynsVuEfT3RaCcO28CiSUgtm6yPrRtA2aa7GDqg0jJF1brROaTDfv15anTUH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 (2603:1096:400:389::10) by OS7PR01MB15077.jpnprd01.prod.outlook.com
 (2603:1096:604:36f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.30; Thu, 29 May
 2025 04:52:33 +0000
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8]) by TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8%6]) with mapi id 15.20.8769.022; Thu, 29 May 2025
 04:52:33 +0000
From: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>
To: 'Steven Price' <steven.price@arm.com>, "'kvm@vger.kernel.org'"
	<kvm@vger.kernel.org>, "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Marc Zyngier'
	<maz@kernel.org>, 'Will Deacon' <will@kernel.org>, 'James Morse'
	<james.morse@arm.com>, 'Oliver Upton' <oliver.upton@linux.dev>, 'Suzuki K
 Poulose' <suzuki.poulose@arm.com>, 'Zenghui Yu' <yuzenghui@huawei.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, 'Joey Gouly' <joey.gouly@arm.com>, 'Alexandru
 Elisei' <alexandru.elisei@arm.com>, 'Christoffer Dall'
	<christoffer.dall@arm.com>, 'Fuad Tabba' <tabba@google.com>,
	"'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>, 'Ganapatrao
 Kulkarni' <gankulkarni@os.amperecomputing.com>, 'Gavin Shan'
	<gshan@redhat.com>, 'Shanker Donthineni' <sdonthineni@nvidia.com>, 'Alper
 Gun' <alpergun@google.com>, "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
Subject: RE: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
Thread-Topic: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
Thread-Index: AQMPKfif4GpC56WX1Xmo2sNneTWC8QG0s1FFsXSt8vA=
Date: Thu, 29 May 2025 04:52:33 +0000
Message-ID:
 <TYCPR01MB11463D8002D90705A7F860B85C366A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-17-steven.price@arm.com>
In-Reply-To: <20250416134208.383984-17-steven.price@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=3cfb0c78-9ffe-4273-9732-ec034cb20816;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2025-05-29T04:40:31Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11463:EE_|OS7PR01MB15077:EE_
x-ms-office365-filtering-correlation-id: fac4332e-36d8-4937-52f8-08dd9e6ca004
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?OWxVTVNQNk1Ia0xCSmRnUFdDUG5rL0I2Y2VsOVhWTUVZeVhDUVdwRTM5?=
 =?iso-2022-jp?B?QUhudk1NbzVwaEV2Nm80VCtqek9vdzJ3Sk56dG10cUNmMk45bm5YdHBs?=
 =?iso-2022-jp?B?Z0dOazRiRkVlVlVleHprNTNtVENNNVZHdFdSNzFYUlVPTmdnM2ptWFdD?=
 =?iso-2022-jp?B?Sm1mUGRRTXJaVHJPdXVOLytwWDJGTlhQeHFQbTdmRmtZbGpObFlxTXJa?=
 =?iso-2022-jp?B?aGtOeG1sWjd6MFBINXh4QXdIWW9RRE9UcnlVcDRnaWpvNnN3V2R4d2oz?=
 =?iso-2022-jp?B?UnRkODYwZXQxZk9KNW1PNzJ2elhCWFUrZFpTdGxESnlsK1BycVNQWGli?=
 =?iso-2022-jp?B?Y2lNNzJpMHY4Z2ZPWEFDM0dsVHZhck9aYWJrVGRET0ZDaDJDbmFlQmRk?=
 =?iso-2022-jp?B?azlFTUN1cG1OazdBcnhzbWhmRk43UFI3Tit1QzZ0TWlEVE9CREIvUlph?=
 =?iso-2022-jp?B?Skc2WnBER04vQkxoSHdKbnBkOURuTSt6K0xFdDFyRE4vS1FVVTg2b040?=
 =?iso-2022-jp?B?UnNXYnVhMGZBY0NQTWt6L2ZyN0l5c3V2VFZUSmhuVklBdmxDanlXajRk?=
 =?iso-2022-jp?B?N0NZOWJZeitMS0hDRWsyTE1KQzlUalh4WStGa1BSMlhhY0pSUFNmWW54?=
 =?iso-2022-jp?B?bTRTbWdndmxsYmYzbDVBdXdPcEQrZFRaV3g4L2ttS3F4VWFoZ0I1MGFZ?=
 =?iso-2022-jp?B?d0gvdERWOUE5MjM3enh6RnZGVVJ6VTliblFQdzB6Nkh6TXBQdDVWMDZH?=
 =?iso-2022-jp?B?aGRSTnQrYjhOYzdSUXhnb3B3aWVPZCtZSGxpSy9BbEo3eWRQc0lJbnhD?=
 =?iso-2022-jp?B?aUdXZitvbkNDSENrUTFMaURQTmNyUmw3T1kxNm5DUmVNcFlNcXJ2VkVI?=
 =?iso-2022-jp?B?U0d6alBqWW96bS9UMTkraklNbE93cnl0SktmcnJqbEp0UW5DWi9wdktP?=
 =?iso-2022-jp?B?RUNTbDhCaXlZa0xaa2NKYmF1dHU3SGxvMUlIdm1kRVhuQTV1d2lEVnFD?=
 =?iso-2022-jp?B?VTBZUGtCS2NEbjNYTFVrcFNpejVkSWlyU0pOUFFIOGpxa1c2bG8xZVpT?=
 =?iso-2022-jp?B?YkFwbzRFWlBzY01FOHQwaHBsRjFzTTVWMDRUaGZmdlJrbXVNTGtTZmpF?=
 =?iso-2022-jp?B?WjJTQzZCOFN6dVc0RFJrZFBCcGJSbzBGdkhzWmNSTmpBRXZEKzJxdmxK?=
 =?iso-2022-jp?B?VEtocUIvSDFiSlpjRUlJbStFemdnWGpTR2wxMkdLZUQreFZqL1lNYjk4?=
 =?iso-2022-jp?B?Z2x4Z2NicmJBT2srUzFETjB2V0phN21rN2JhMnRrOGJ6WnJDMERhSGFx?=
 =?iso-2022-jp?B?L2VJUzZ6M1VNL25ySi90eXBaTzJlM3lKWDIxaEpzTTJuSGF2OXBFM3hZ?=
 =?iso-2022-jp?B?Q0pyWE9NajZqY0lTRHFCSjlaTVdZRFM0SmthMGpnUmppQ1FkSFpvbnNS?=
 =?iso-2022-jp?B?RjFobWNpMTRXVFN3VTNPUHhhS0xjV3pVcE1oR1ROZUVEQlEzQVFvWFpP?=
 =?iso-2022-jp?B?ZVpwS29mSzc3eWtvSkduQVZxaFJhZ1ZGVHFCRVNaSUhUUHNoY0hvNVEz?=
 =?iso-2022-jp?B?eSt3TVB0Sld3TUVxZzVuQS9qNXlvLzN0dUZGMjUwdFFoK1JFejdTUmZq?=
 =?iso-2022-jp?B?eVhCVUQ1YVgvUlViYXpCVGRsZFlRS0Zvak02Z3RPRlIwQkRRSVJDQ2d0?=
 =?iso-2022-jp?B?REZrNDdyNmxrQ3RpSmxLZWFDR0p2VGpUaDdMSWNid1llczZCZytlWEhj?=
 =?iso-2022-jp?B?RUsxVzRkN0NnYno3aUR2YkhUMFR0aFFHMFFPVHFqM1p5d0VvUHRkbkxF?=
 =?iso-2022-jp?B?dHFYQzBibFJ0R29pc0xINlJNN3FxakRuR0IzSVJBOTBZdXVEbDRzcnZG?=
 =?iso-2022-jp?B?SW9iQXU1eU9iSFlVai8rdVdYTS9RRTVFMWJpWEtiNUlyd1gwTEl5TEEr?=
 =?iso-2022-jp?B?SXB6YWlWVVF2M0hTalU2bEl0aDlCcjg0U29ZVXY3cUNUUzZvMkZXYSto?=
 =?iso-2022-jp?B?dkhwTjZzWmZBWkwxZURGWUJ5V1VrZGkvNGZKcU9EMnVmdjlCMEVVb2lP?=
 =?iso-2022-jp?B?WTFMWCttOC8vcW1ma1IxNzZGbmlqSHl3bnB6NHJ6MzloUUJaNm04dS9N?=
 =?iso-2022-jp?B?UWFNaFMrcWxJcWRiM0cwQjRCOVNMRkZQYm4zRElSRHVkNEg4N1VmL25a?=
 =?iso-2022-jp?B?QytxWXg4MjFFQ0lzd1cvNGQ3YnZQdXha?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11463.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?U2QwODlwS0NJL0xHR1lDamdSS1dtTzBWUzlxcG9RVmlZTGdCeXFvVW9u?=
 =?iso-2022-jp?B?OUd6ZzBucmVFVVdtUnhPQ0g3QXg3T3BQUDcwNnNNV3AxMzNlTDRRUFZU?=
 =?iso-2022-jp?B?WENmbmI4NFYvSkE3WGNuMEkyUUhzMEJONFFmbEtwSjBxbDBvQmJBSHd0?=
 =?iso-2022-jp?B?WDJYbVdJTHpPcGJRU3pVU2EybHQwaTBiSGZmQkhRdDNCTE01ajBrSXdo?=
 =?iso-2022-jp?B?c2V5STA2bmRjczVhMzhLUDFWdTk3amFpYVJza2M4dXpOZXEvK3NuVThL?=
 =?iso-2022-jp?B?eTIwUFo4bG9NeDkzL0FZdjMxWDJOZTlqcThUblB1VjBPMXdML1hBRXlD?=
 =?iso-2022-jp?B?cnhMUFVLS2pTWHV3T0JpUWhaTlVpeU1kTlRUNjRkNlZxQzIyaFg5YXFS?=
 =?iso-2022-jp?B?YlR5bll1NFY4bHhEcmZINUVIQTJsVFk1dE9FdjdMRFdrSUxHN2hmdDUw?=
 =?iso-2022-jp?B?SVl2YXgzaEhjUXFmckc0K1dmMGIraGRWV3pVYnVVaFpwdXNRbHZaeVVL?=
 =?iso-2022-jp?B?MDFUSk9uLzZVY3ZPNDN6VDd1b0E3TDY4NlJiMHlaV2FETys5bDJZRTQx?=
 =?iso-2022-jp?B?RlJEQWJUalU5RTdtOEN0eHdjS3NXV2VRYnVRUWkwY3JWMWVPdmFtT1ZH?=
 =?iso-2022-jp?B?cEVxY3RqQjhyWnN0MXNlWjc5V3E4TlZQd1JHUFpCYTBkaklWMDA4Wnlr?=
 =?iso-2022-jp?B?ZUFLMnZTTzBrKzFYeGpjOVdpRnJSOWJzL2VVYnpxbHd4cGZwdWh5NkdQ?=
 =?iso-2022-jp?B?T2V5ZzMwbFM0OWxLZVJqYkpVcTB1aHFWSitFUXl5bGtvcTZvdDZHK0ZU?=
 =?iso-2022-jp?B?WmdycHo0UTFob09kUDdkTncrQmVqRnUxSk5lZXBKTGY5R01xZkxWZ2lk?=
 =?iso-2022-jp?B?K3EweTZKMVZNMjI0ei9WVUlTRTErN25RWVU0UkJmMkRQOGVJcEk0T3Rl?=
 =?iso-2022-jp?B?UnpxSHN1UzNNUzhDNGtSUXV3NUUzOFdyVWZKaXNOc203Wm1oQVIzRkNj?=
 =?iso-2022-jp?B?bksrNkZ1VUY0Y1B4Q0JmbFFUUnk2aUUxQnZSKytVZTFCcEI3TEQ0bGN3?=
 =?iso-2022-jp?B?WTBMRUp2T2ZiZEhUTDBQdk5SSStwTjFIREhiTVkxTk8rN1pnK1U1UmVQ?=
 =?iso-2022-jp?B?UytoallUS0hmSUNpWmNaWjhUZ3ZKUlZ1VzExN28zU2RvV1Q0TXVvc1Qz?=
 =?iso-2022-jp?B?a1BUMkVHVWVJbENwd3NaVDF6OVhSN1RyYm9KMnJDYTRmbGpHSHV3b0ph?=
 =?iso-2022-jp?B?TDdaN09oZGM1WVc0NXZqN29KWDczUUx4a0twTHZuZ3ZRS1dZRTc2dzd3?=
 =?iso-2022-jp?B?MTZ4K3dHYVJRM1JZMmY4Um9DaUMxVEtvMjBnaS94eUdubFNpRWdRSzIz?=
 =?iso-2022-jp?B?WWJFTWRnUW5EUVNZaFpENXNXejhMdVc0UFdKL0Zza09UZDZyMThxclVH?=
 =?iso-2022-jp?B?NTJrMzZxVmhRZERPVURLMWZBL2Fvd25oYWp1R0s4S1V1aEdBdkNaODBi?=
 =?iso-2022-jp?B?REJVT2FmS0pIczVBdGVCaCt4a2JZTGtzek1xYm5mWUwwMU4yZnRzODBu?=
 =?iso-2022-jp?B?ODdsT21GNXVpcUNvZTRQckdLcHJ2Z3Q4eGFJNnp5cC92ci9mY1RncGdC?=
 =?iso-2022-jp?B?NjNJeUViWGtaTzBrTmMwUW9zeXBMSXUzenlZMnRHaVV3bDBWNmpRa01O?=
 =?iso-2022-jp?B?eWl0b1kzakJNNnpZeHdyajJYQWtXUFlmczE4ck1WVmUwaHB3TFpCMWhM?=
 =?iso-2022-jp?B?ekZOcHRBRG8yL2lKRFZIVlBMa0JLQ2NJaEV3RlZMWGJLN2J5c3JzSmQr?=
 =?iso-2022-jp?B?TTg2YTh1WFhtaS81YjZkWjZrY2VmM0grdGVtS2I2djgwanJkZW44d2Nw?=
 =?iso-2022-jp?B?OTY3clptMU9YNEZBdmpZclNWMFJUWGJOTTVCeFNQUnpLQlBSMHd2OVVq?=
 =?iso-2022-jp?B?bGVmOENsclhiZjVXdG95RDI3Njd0bytvYWVJRURmWkNFWXpJVU1sQ1pK?=
 =?iso-2022-jp?B?VXpYZ1lVVkh5eEI1NHVTTFZxeUFDcW1MaXlXRXB2NFAwS0U3NGYxU1Qw?=
 =?iso-2022-jp?B?QzkwUmxlTUNlclJGR0N2Q0x0dVZLNVRXODZCTWg2K2pLSmlaSTBoNlhY?=
 =?iso-2022-jp?B?amd2OUdOQWpqN0hrNnJuTldXcE5WRTIvMThiRTNsK212cEVjNnEzdVA1?=
 =?iso-2022-jp?B?dnRQb29meFVSY2xYZFV4bmg2ZXQyNnpEZldZbVZuelM2K3VxbGEwTlh0?=
 =?iso-2022-jp?B?YlA1dWxXcnBPT0Q2QWpBaVpFVkt4NmhtWWNpKytaOG4vY2RzdFBaa291?=
 =?iso-2022-jp?B?d0pOOUNSY2FyTHc2b2lFbUVnZ0R4dXUzQWc9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WxLDkPAEpMI2Xx1tfDcv8nKQOwDVFyKGOKNgb37qncakhY2c8UBj7OcpU95/+dl4oCzUd/1a0TXTfg5ZpLZx4ftIOqBQS9tSzlrgzirh3nCPGZUEuYzH/MZWHTRg7XeMNGKC3uduy9bZM87Nhs3XsENMf+EIOtQrTAwHRa3ZC9ZBx/FRQe1hDIdNSE6Lu1UKr53X7zDKSFy6gN5y8zNbSdYJS6GdmlKFG89g+4ccJWUEyA1A60XUT+U/u6IZmAgRKWKT8wleVrOoW/LH/tqK3UKGhay3na2C4jER/tSXudeLDfbE3NhxtzyaMvpsMlJMRAFKwuRKsAJr8MswL2DqN9etoMJkRUd2Q1DzcT9Xk10Ho1SIhDT8jpiiOY9QRvGm6kkjD2ixIDbq62fLejMNedb9aB7fnVJuU2f+7jeJtZdp6jQsY8OS+EXhRkro2/pk3IQytwLxO1M+ipYvuqnqwonKvcxdObDuQb3ZfRCGIL/KfDjlPPq10zQnLsEfLaRQQz0Ut6A29SXP8cwDz+jpoVOVQLHvba6l7eSpeK983kJ0C+THSd0uUhVAcqeZ5Db6vC26uBIwgDshNqCus6Nq+62d6BUf+rL5C8bFNheEh4qjpxGxeQ8in7Tt3bqfYOKc
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11463.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac4332e-36d8-4937-52f8-08dd9e6ca004
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 04:52:33.4637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Ki8nnxDmH4fxSJetE9now9JCenf+CjVsVcYYzjDR05RYF3fttQpctQSX2gu/SXwkuPeuVwhxQyBNvCeoii6VG9+/cyxf4qiAHD0gmfmVb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB15077

Hello, I comment below.

> Subject: [PATCH v8 16/43] arm64: RME: Handle realm enter/exit
>=20
> Entering a realm is done using a SMC call to the RMM. On exit the exit-co=
des
> need to be handled slightly differently to the normal KVM path so define =
our own
> functions for realm enter/exit and hook them in if the guest is a realm g=
uest.
>=20
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>  * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>    been read (although that can never happen in the current code). Tidy
>    up the condition to handle any future refactoring.
> Changes since v6:
>  * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>    vcpu to the error.
>  * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation
> for
>    this exit type.
>  * Split code handling a RIPAS change triggered by the guest to the
>    following patch.
> Changes since v5:
>  * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>    change on next entry rather than immediately on the exit. This allows
>    the VMM to 'reject' a RIPAS change by refusing to continue
>    scheduling.
> Changes since v4:
>  * Rename handle_rme_exit() to handle_rec_exit()
>  * Move the loop to copy registers into the REC enter structure from the
>    to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>    where the handler exits to user space and user space wants to modify
>    the GPRS.
>  * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>  * realm_set_ipa_state() now provides an output parameter for the
>    top_iap that was changed. Use this to signal the VMM with the correct
>    range that has been transitioned.
>  * Adapt to previous patch changes.
> ---
>  arch/arm64/include/asm/kvm_rme.h |   3 +
>  arch/arm64/kvm/Makefile          |   2 +-
>  arch/arm64/kvm/arm.c             |  19 +++-
>  arch/arm64/kvm/rme-exit.c        | 170
> +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/rme.c             |  19 ++++
>  5 files changed, 207 insertions(+), 6 deletions(-)  create mode 100644
> arch/arm64/kvm/rme-exit.c
>=20
> diff --git a/arch/arm64/include/asm/kvm_rme.h
> b/arch/arm64/include/asm/kvm_rme.h
> index b916db8565a2..d86051ef0c5c 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -101,6 +101,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
> ia_bits);  int kvm_create_rec(struct kvm_vcpu *vcpu);  void
> kvm_destroy_rec(struct kvm_vcpu *vcpu);
>=20
> +int kvm_rec_enter(struct kvm_vcpu *vcpu); int handle_rec_exit(struct
> +kvm_vcpu *vcpu, int rec_run_status);
> +
>  void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   unsigned long size,
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile index
> 2ebc66812d49..c4b10012faa3 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtim=
e.o
> \
>  	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
> -	 rme.o
> +	 rme.o rme-exit.o
>=20
>  kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
>  kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o diff --git
> a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c index
> 7c0bb1b05f4c..cf707130ef66 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1263,7 +1263,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		trace_kvm_entry(*vcpu_pc(vcpu));
>  		guest_timing_enter_irqoff();
>=20
> -		ret =3D kvm_arm_vcpu_enter_exit(vcpu);
> +		if (vcpu_is_rec(vcpu))
> +			ret =3D kvm_rec_enter(vcpu);
> +		else
> +			ret =3D kvm_arm_vcpu_enter_exit(vcpu);
>=20
>  		vcpu->mode =3D OUTSIDE_GUEST_MODE;
>  		vcpu->stat.exits++;
> @@ -1319,10 +1322,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
)
>=20
>  		local_irq_enable();
>=20
> -		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
> *vcpu_pc(vcpu));
> -
>  		/* Exit types that need handling before we can be preempted */
> -		handle_exit_early(vcpu, ret);
> +		if (!vcpu_is_rec(vcpu)) {
> +			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
> +				       *vcpu_pc(vcpu));
> +
> +			handle_exit_early(vcpu, ret);
> +		}
>=20
>  		preempt_enable();
>=20
> @@ -1345,7 +1351,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			ret =3D ARM_EXCEPTION_IL;
>  		}
>=20
> -		ret =3D handle_exit(vcpu, ret);
> +		if (vcpu_is_rec(vcpu))
> +			ret =3D handle_rec_exit(vcpu, ret);
> +		else
> +			ret =3D handle_exit(vcpu, ret);
>  	}
>=20
>  	/* Tell userspace about in-kernel device output levels */ diff --git
> a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c new file mode
> 100644 index 000000000000..a1adf5610455
> --- /dev/null
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_psci.h>
> +
> +#include <asm/rmi_smc.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_rme.h>
> +#include <asm/kvm_mmu.h>
> +
> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
> +
> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu) {
> +	return kvm_handle_guest_abort(vcpu);
> +}
> +
> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +
> +	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
> +		 rec->run->exit.esr);
> +	return -ENXIO;
> +}
> +
> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +	unsigned long esr =3D kvm_vcpu_get_esr(vcpu);
> +	int rt =3D kvm_vcpu_sys_get_rt(vcpu);
> +	bool is_write =3D !(esr & 1);
> +	int ret;
> +
> +	if (is_write)
> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
> +
> +	ret =3D kvm_handle_sys_reg(vcpu);
> +	if (ret > 0 && !is_write)
> +		rec->run->enter.gprs[0] =3D vcpu_get_reg(vcpu, rt);
> +
> +	return ret;
> +}
> +
> +static exit_handler_fn rec_exit_handlers[] =3D {
> +	[0 ... ESR_ELx_EC_MAX]	=3D rec_exit_reason_notimpl,
> +	[ESR_ELx_EC_SYS64]	=3D rec_exit_sys_reg,
> +	[ESR_ELx_EC_DABT_LOW]	=3D rec_exit_sync_dabt,
> +	[ESR_ELx_EC_IABT_LOW]	=3D rec_exit_sync_iabt
> +};
> +
> +static int rec_exit_psci(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +	int i;
> +
> +	for (i =3D 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	return kvm_smccc_call_handler(vcpu);
> +}
> +
> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu) {
> +	struct kvm *kvm =3D vcpu->kvm;
> +	struct realm *realm =3D &kvm->arch.realm;
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +	unsigned long base =3D rec->run->exit.ripas_base;
> +	unsigned long top =3D rec->run->exit.ripas_top;
> +	unsigned long ripas =3D rec->run->exit.ripas_value;
> +
> +	if (!kvm_realm_is_private_address(realm, base) ||
> +	    !kvm_realm_is_private_address(realm, top - 1)) {
> +		vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx,
> ripas: %#lx\n",
> +			 base, top, ripas);
> +		return -EINVAL;
> +	}
> +
> +	/* Exit to VMM, the actual RIPAS change is done on next entry */
> +	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
> +				      ripas =3D=3D RMI_RAM);
> +
> +	/*
> +	 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT, see
> the
> +	 * API documentation
> +	 */
> +	return -EFAULT;
> +}
> +
> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +
> +	__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) =3D rec->run->exit.cntv_ctl;
> +	__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) =3D rec->run->exit.cntv_cval;
> +	__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) =3D rec->run->exit.cntp_ctl;
> +	__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) =3D rec->run->exit.cntp_cval;
> +
> +	kvm_realm_timers_update(vcpu);
> +}
> +
> +/*
> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason)
> +on
> + * proper exit to userspace.
> + */
> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +	u8 esr_ec =3D ESR_ELx_EC(rec->run->exit.esr);
> +	unsigned long status, index;
> +
> +	status =3D RMI_RETURN_STATUS(rec_run_ret);
> +	index =3D RMI_RETURN_INDEX(rec_run_ret);
> +
> +	/*
> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we
> might
> +	 * see the following status code and index indicating an attempt to run
> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need
> to
> +	 * return to user space which can deal with the system event or will tr=
y
> +	 * to run the KVM VCPU again, at which point we will no longer attempt
> +	 * to enter the Realm because we will have a sleep request pending on
> +	 * the VCPU as a result of KVM's PSCI handling.
> +	 */
> +	if (status =3D=3D RMI_ERROR_REALM && index =3D=3D 1) {
> +		vcpu->run->exit_reason =3D KVM_EXIT_UNKNOWN;
> +		return 0;
> +	}
Running kvm-unit-tests-cca selftest(smp) test in quick succession may trigg=
er these conditions, resulting in the following error logs.
 Error: KVM exit reason: 0 ("KVM_EXIT_UNKNOWN")

Since KVM_EXIT_UNKNOWN is used when no specific exit reason applies, I thin=
k it would be better to make it identifiable as an error.
How about adding and setting a new ARM64 exit_reason value to indicate that=
 the PSCI_SYSTEM_OFF request is conflicting with a running vcpu?

Best Regards,
Emi Kisanuki
> +
> +	if (rec_run_ret)
> +		return -ENXIO;
> +
> +	vcpu->arch.fault.esr_el2 =3D rec->run->exit.esr;
> +	vcpu->arch.fault.far_el2 =3D rec->run->exit.far;
> +	vcpu->arch.fault.hpfar_el2 =3D rec->run->exit.hpfar;
> +
> +	update_arch_timer_irq_lines(vcpu);
> +
> +	/* Reset the emulation flags for the next run of the REC */
> +	rec->run->enter.flags =3D 0;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		return rec_exit_handlers[esr_ec](vcpu);
> +	case RMI_EXIT_IRQ:
> +	case RMI_EXIT_FIQ:
> +		return 1;
> +	case RMI_EXIT_PSCI:
> +		return rec_exit_psci(vcpu);
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		return rec_exit_ripas_change(vcpu);
> +	}
> +
> +	kvm_pr_unimpl("Unsupported exit reason: %u\n",
> +		      rec->run->exit.exit_reason);
> +	vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c index
> 33eb793d8bdb..bee9dfe12e03 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -863,6 +863,25 @@ void kvm_destroy_realm(struct kvm *kvm)
>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>  }
>=20
> +int kvm_rec_enter(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_HOST_CALL:
> +	case RMI_EXIT_PSCI:
> +		for (int i =3D 0; i < REC_RUN_GPRS; i++)
> +			rec->run->enter.gprs[i] =3D vcpu_get_reg(vcpu, i);
> +		break;
> +	}
> +
> +	if (kvm_realm_state(vcpu->kvm) !=3D REALM_STATE_ACTIVE)
> +		return -EINVAL;
> +
> +	return rmi_rec_enter(virt_to_phys(rec->rec_page),
> +			     virt_to_phys(rec->run));
> +}
> +
>  static void free_rec_aux(struct page **aux_pages,
>  			 unsigned int num_aux)
>  {
> --
> 2.43.0
>=20


