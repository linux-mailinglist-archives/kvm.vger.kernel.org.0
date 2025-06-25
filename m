Return-Path: <kvm+bounces-50602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A55AE7466
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25947179440
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3129D161302;
	Wed, 25 Jun 2025 01:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="L/my3A85"
X-Original-To: kvm@vger.kernel.org
Received: from esa8.fujitsucc.c3s2.iphmx.com (esa8.fujitsucc.c3s2.iphmx.com [68.232.159.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02311E87B;
	Wed, 25 Jun 2025 01:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750815977; cv=fail; b=e91ZxQyxl89eROsbPMJtQVMx5JKUhVHvUEC0hhRFPiSq8QVwpquYPlbAvG7IUXeUMQkpTmhS6cxiU8YrhYN0i4n6EGrOcuXJo6mP5tw7V4FpeSkoy25Txmh+7r1Z+cOHzhnhpnkJy/WNpTEVYQJmUh3ZavzveOi9PlFQCYk5LjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750815977; c=relaxed/simple;
	bh=KjeidXAse7Sj2Vqh2Wd/rt9k39DQvkiThSvQ9Pk3Ups=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H5CfIVsKNWCdZkWLzkCZHDTY+MlhAwQWVt2CCXbXSfsBcq8kjazOeoihxPZyqb2Q+ftOUi7PlMV9Hbw2e0ym1TYTnImmT5hLrpwEWcKUnnWEUnjRwaMREN52+ccF/kPUaiPnCItjDwlLKYhLuTdBTvKcSZw9eLzQUb/pItxT23w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=L/my3A85; arc=fail smtp.client-ip=68.232.159.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1750815974; x=1782351974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KjeidXAse7Sj2Vqh2Wd/rt9k39DQvkiThSvQ9Pk3Ups=;
  b=L/my3A85kkXbLuyJPVN+yPAHDzgy+1MVHyRkkd1W4rxco+qM9rJZHvtI
   ljYDId49WtcQxyUVd3M7mGBugUQQzKH/tfXd0eMXvkHAqZGBAqYIOke9s
   UHDfb3vpFVUsdoutECgSndapg4okxzjvaRxYoJTOPlRe72vOMaya1NgsT
   GP+p5TWbCpVprVMGOqc0o8bhpF1wa7gBDVeioq3biNElYcMXM/GrIbP6H
   7WkSAO9A9P6evcFYvKqoNqhwZvh1OfiOsldNGNtyBe7S8gnwJEKKmTuF0
   z/UaN+eHJWMBtSZfyet6i0u2ix/w/JzwUb1NVaK2BJkiKAhODisSGXy/R
   Q==;
X-CSE-ConnectionGUID: kMyvWnW0SE6K8JJmvW5Yag==
X-CSE-MsgGUID: kyMPb5XfSCK8wr1sgaD0kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="159615434"
X-IronPort-AV: E=Sophos;i="6.16,263,1744038000"; 
   d="scan'208";a="159615434"
Received: from mail-japanwestazon11010015.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([52.101.228.15])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 10:46:01 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QCnDQY/uWlNmkgcQTeG6bIJ0CHeXzrUP6P2Szbv9E7BvCs6BpucSW9fJFsVm+1LwLFza08kRW4AU2I8Ycam5nXYl2fxAWTLjcUAaYgf83BXdy0hgU1h0K5PbGxQtTWkiI1ucA1NAyJvkf97Tcz5piFXzjRhh5gY/3nqe6esLHbk3XdkoPQB2jP56jXPQon1RpQnruJP0O1hldp++6meROqYYWFSGD8FvmXzSh0JiEuAZZUMhRCqIkFUP/N5TN6zZiMRQxtd5YNJXtdscf/awnmcTQQyDXND1YNmK5bULvwOcZCfWmQyVKrWI+GLozRFlXxXiuTJhX2axpjoRApblJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNA5QwNZxWdwPZQPifN0sOLqJ3+ZZ5BVPihV5lF0NJs=;
 b=clTM9SxFAztorKAPvkhFSWYgCYpjW3PMyrl/fafZIEpEGMbmenez/reC8UC+fD+qO4yJ5UmEJvfprUnndWdlBZhCnCdytKD1sOJSuIPWqRvFNBwmdEOz95qvVk8435aG/4x9/AHpG+uMLHBXjPZ23GYQG57IEd25fPXE9jNQfBTzNYZe3bhcxxFbNLpTkGl8UpHBhH72BfX5zedIRBG+NO1pRKI0k6PwNP68AQ0fWVJmDjBHIxmmoyOi9J1AVNtBuQfs2eAVONXBloxGSJ72CjrrCTHOVjv2ryJJoHuR6BHBIVHrOv+5RzraLQ9osOgDTBdPGcq4koakaOfKTPOPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYXPR01MB1886.jpnprd01.prod.outlook.com (2603:1096:403:12::19)
 by OSCPR01MB12688.jpnprd01.prod.outlook.com (2603:1096:604:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 25 Jun
 2025 01:45:58 +0000
Received: from TYXPR01MB1886.jpnprd01.prod.outlook.com
 ([fe80::c110:9520:20ab:e325]) by TYXPR01MB1886.jpnprd01.prod.outlook.com
 ([fe80::c110:9520:20ab:e325%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:45:57 +0000
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
Subject: RE: [PATCH v9 16/43] arm64: RME: Handle realm enter/exit
Thread-Topic: [PATCH v9 16/43] arm64: RME: Handle realm enter/exit
Thread-Index: AQHb2r6YT7eP93r6y0iehVFFNbA4eLQTLm+S
Date: Wed, 25 Jun 2025 01:45:57 +0000
Message-ID:
 <TYXPR01MB1886B05D8257CE01B15EF6D3C37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-17-steven.price@arm.com>
In-Reply-To: <20250611104844.245235-17-steven.price@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=8cb4c2d3-b633-4804-a708-05f466c6ac80;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2025-06-25T01:36:40Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYXPR01MB1886:EE_|OSCPR01MB12688:EE_
x-ms-office365-filtering-correlation-id: 9017339f-2c1b-4807-b29a-08ddb38a07fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?ZzczcXZBNTI3MjhBUnB3cUxzMmF1RkhYeDA2eTRzSGtTZzdrVWczTnRL?=
 =?iso-2022-jp?B?VkExLy9LQWkxNnpMZUROVVZDUkVWQm9sWTJHYnIzK2RkR0Y0RHZtVnd1?=
 =?iso-2022-jp?B?RjhSRkJhNTBRREgraXFnTGpocWlvMU5mUTJtaVpUM2MyOGZnQnNTZnpr?=
 =?iso-2022-jp?B?M1ZlK1VsajUvU251L01GRVZIeGV0eHY5NnJhMWgyYWlVT3l5d2Y5STIy?=
 =?iso-2022-jp?B?SEg4WUViN0REMkFsMXZxUjROSVQ0UGhxMGNDQm9YTU5YS1VZRWo3MG5I?=
 =?iso-2022-jp?B?dEFXS1ZpYjlUTnNZVXFJZUlFM21NVzRGZkF4VUZ3WkJNQmZHOGszb0JN?=
 =?iso-2022-jp?B?a3p3ZnZ3WTJnMFdOOEZ1RTdFZlFVVk1TOTVZc1BTb0NOZGVxOXlGdVBJ?=
 =?iso-2022-jp?B?RXMrQkpzbTB4aWF0UGFSRzh5bW5tdmxRZUNtZzZvNTVGVzUxNU1kMFpu?=
 =?iso-2022-jp?B?SlF5a0NOK1Z3Qk0yaDBua3Fid2dWSDE2L1JmWUx3Mno0dGNIQUhqL3lF?=
 =?iso-2022-jp?B?Sk9oZnZxRWdTYko0QkZEb1BzWS9OSVZzd003R3FGZEN6bXJjT3dqcE1G?=
 =?iso-2022-jp?B?blVwM3Flb0JhdEMvRlhFMHJBL3phQ1JxMEdrZDQvZ0dzSTJ0WHhZbXVU?=
 =?iso-2022-jp?B?NUhVMmd5a2daRXZXalE1YUk0V3FBNDNUK05WcjdkNVJscGNHOXYzZEtw?=
 =?iso-2022-jp?B?T2V4c1lMRFRmK1lOVWF3eUROZGh2M3BLTFNqMjdZMERDbEhrcGxuQlBN?=
 =?iso-2022-jp?B?Z2sxcFpnaEl0dnZqSEZkTE80Q3R3dWtWei9wb0xueVk0TTJNeEt0VFc2?=
 =?iso-2022-jp?B?NitpWDZESEhFNEx5M2VMV243Uk4wci9IOHZFWmYwaGp6QjNMbFEvbE5M?=
 =?iso-2022-jp?B?QXRxNjdMMzFoVEZISks0d01EVE1Qb1V5RnMzU0I2eEZROG9lYnNnaDFG?=
 =?iso-2022-jp?B?bkRoMkhTY3VybWN4M0duSm9aQmZGdkYzUDJMQmRHVkRUNHBmMjdLTG10?=
 =?iso-2022-jp?B?V2hXNHV3WGtBM0hTQzJ2TytOczhnc0RuVmtYYXhXVHZEbVdoNWFib1BF?=
 =?iso-2022-jp?B?RjcyZ2N0Ky83dHNKWXZOT05qQ2J1dWlPUnd6MmUxV3lycjNQN0NoVFcr?=
 =?iso-2022-jp?B?cllFRXp4cnN1WXU3V3BaMnQ2dEtwZFYvNktVeUVYWWNCR3pNcFVBUGJh?=
 =?iso-2022-jp?B?YmhsdUZseHFQSG1vTXdxaHlHYXZ5SDNBQkJxSWFhcGtTSUdBVmlSd3Z4?=
 =?iso-2022-jp?B?dW9Wd2Zld2dYam1kRlBBZlBkZFJZdFJlUnlTd1F6S2w3V25LejQxeGlV?=
 =?iso-2022-jp?B?cmU0bGdLYzVJSkhGNS9JZEw2ekdPNWJZcmJmbVlvYnNCVktDT0pFaHVD?=
 =?iso-2022-jp?B?VDVpem1LRU5TcU1kczlkTmo5eitWMy9NNzFIM1pEL3hHMFNNTi81R0NV?=
 =?iso-2022-jp?B?MVhBUU10c0RHV0djZ3Y0QXNWWTJRSkZEVGZTUDF2QmxMbTNpYjFBN1Ir?=
 =?iso-2022-jp?B?OXh0UE0xbGFTdXFuRXBlNG1vWml3NHBmbVhjVm1oWWtydHo4QkRJbmQy?=
 =?iso-2022-jp?B?MURoMUlIa0ZpVFhaSzArbTVGZ1RTL2IydWVqUXhtZWtHNTlTWDZnVFY0?=
 =?iso-2022-jp?B?dVR4Wk5EQk1lNUpXRXE0Rkxrb2ZVTHZ6VURxVUt4ZC82OVRBVkRaeUNN?=
 =?iso-2022-jp?B?dlNNNnhjTkVyWm9UZnpIb2JPbnByNzlCVVF5b3JpOFRkS1RrTW9va25o?=
 =?iso-2022-jp?B?YUc4RTVJMlgxOW9pVVR0Qk4xTjdQSW9DaitQU1Exb0lOdWNoMzJZQ3JY?=
 =?iso-2022-jp?B?V0JFclVOTzk0VVN6c0JwckFlcEVPa3BGdGVPVVgyY25RUGo1NHR3Kzhy?=
 =?iso-2022-jp?B?QWhNOWJrMlRZSlVnNE1wNUNnekU1eXhGWi84TjFVNktScTFZM21BV2o2?=
 =?iso-2022-jp?B?WTR5TTc1TlppRTN3QURRczFTYmtsYVJrT2tiTXJYS3k4anJMMExhd0RY?=
 =?iso-2022-jp?B?WktrQVZWTFRtWXQxczA3UFV5Z0JIb0N1RngweithWUdqbHUxUDhtTjBZ?=
 =?iso-2022-jp?B?UkdvRnJkNDhvb2Z2OCtVTXlUajRFenZCOG5PVDZzdFlaR1c0UmxITnhn?=
 =?iso-2022-jp?B?dXpuSlhyQThYWE91RzFGbmlUTEF6cndBSFpwRGh3SzJkNERQTkt6a04w?=
 =?iso-2022-jp?B?aHFrVzhhb1dOV0JNdkdMUngvM21lNm5a?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYXPR01MB1886.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?aVNOOE9mN0RmRWhOWDdLSHJVWkpVZm9udGRNdXo0cEJtVVVTQUZRTjNI?=
 =?iso-2022-jp?B?aDdpakpzQjBKalZLK2pmdEtRUVVTUFJxUW9uaDlSTVBaOTBLK2RXWDI3?=
 =?iso-2022-jp?B?N1dCaDlzdlBtSGFDQzdzYkQ1ZXdaaTVLVEFTbTlubmlWVkxvb0ZtYkVi?=
 =?iso-2022-jp?B?TFR3aEl6WlRFZDFOYzV4MEx2L0NTSlArMjZXcG5mVzZXR0s2VFV6dnVD?=
 =?iso-2022-jp?B?VGVqYXVaczVLQ2thUHJ6RjJsWUhkWFBCUlJaTUhlVDd0M0tMWXhqalN3?=
 =?iso-2022-jp?B?dmhjelptMnFrTUZURzhHKytqdVBFVTM3bGRnZTJaNjRha2RXaEF2R0U5?=
 =?iso-2022-jp?B?MTA0TzdVaWFaVGxrRCtuMHlmQU1kLzJyWUJ4cW9uUGZwUFN4U1dKOTNr?=
 =?iso-2022-jp?B?WURCTGZGVGhkZ2xJTUdkekxGc3U1R0xxRkRzdmxwZzNMamtXWkxTckJo?=
 =?iso-2022-jp?B?d3dQY3ZLVmU3bEYzTHpzeFM5a3R0Qmt5bWlFczlISDcvc3d0dk9naTNj?=
 =?iso-2022-jp?B?K0NTeVNtSXJoNGp4bExmS2dxcFpTVC84TWgwMHJIZ3pRS1A1M29JMFhV?=
 =?iso-2022-jp?B?Snk4b3FvZ3YvendSRzg4SGN4cnVYZnhxMzdhaHBwOXRBaml3aGo3UXNM?=
 =?iso-2022-jp?B?c0Y2Z3pDVGYrbXZCVzFuWi9qcys4WHh4L3pYOWhyWGRpQ2tZOXZFbCtS?=
 =?iso-2022-jp?B?NC93VTFGbEpWV3RLUWZJQU5qZVNFa3VJdjFXbGJYcDFlVjJUQUg5QVBY?=
 =?iso-2022-jp?B?Q0hrQkh5aExTbzRKTzRobWlvOVdCZW4zNklMamtTUmFxNXdQSlVtUjZy?=
 =?iso-2022-jp?B?QXI4K01JMTU5dFVaS293SVNaWG1oUlFzWXBGZUJOZm1zWGxFQkhtcVBl?=
 =?iso-2022-jp?B?cEZsbS9PZmU0MFpJbVRXc1owS0FiWjErMDVmWDZEcVRPRGNZWTY1cjVM?=
 =?iso-2022-jp?B?UWhIRmhxQXVFelpZNkpUSEVZM0pWWERxK2xFWFczVFpOU2kveEkwc0JO?=
 =?iso-2022-jp?B?eE5GWk9qeW1XQTRTWVNHMEFsTklOSGNwTjQ5OUdSeC9CZ20xVTRhR1lH?=
 =?iso-2022-jp?B?UGlBb0pibUFEWVhCUWU1eUE3WUJjSjNFSXNvR2JqSHJQRGNVb1FzaU1K?=
 =?iso-2022-jp?B?NnlVUTBhaDl0ckJKTytmT3haWmIxM1dIelhIWDVIWkdBTmE5cUdMN1pJ?=
 =?iso-2022-jp?B?amRRaFlzREsxY0RaQ25MbVdXZFl3cjNuUCsyWUhDZUk3OEpMbHMzeG1k?=
 =?iso-2022-jp?B?RGZkdXBWd2R5cGhHN09TMHlrcTJJR0tUNzlFbU9SN3lTLzJIL1JmMldm?=
 =?iso-2022-jp?B?M1R1VitlMENnZlk0WHpSVFZhWUhjWkExYitZbWtMWC9HaUZoN1hIaU1q?=
 =?iso-2022-jp?B?VWZqM084UlRVRTVpdHhNKy9mYlhqT2dydnFxQ3pnU0ZVc2tnOUxCaEtz?=
 =?iso-2022-jp?B?Rjk0QmpPUW54NGlZZkdTbnZVendyL3lFNmNzeFBWTVMyMmtvTjI4WlVI?=
 =?iso-2022-jp?B?MlJEUGRLSzNWSHJDanQwaFE1TEZFQ1hLb0oyNnl2NWx5N2xvLzlGa0Ur?=
 =?iso-2022-jp?B?L3FNTWp2TkxRNnlXSkZDWTk0NEFobzBobGQzbFdCWDB0MVBHQ1R2bHFT?=
 =?iso-2022-jp?B?VnNCSG5pM0Q1bXZqTUxtNk9ORjBuVEtGQmRTSm1RQStjQmgxaXFOejNG?=
 =?iso-2022-jp?B?b2FsVjRNN2xnalR2dnJhbTg5T0JjQ2VtSk5JcHgvOC9pcHc2cEhTNDhj?=
 =?iso-2022-jp?B?VDdGOC9VV1kvSVAyaEc1K0p6R3Ava29GL1dZY3Jtb1dlZ3VJTDFuc3Bi?=
 =?iso-2022-jp?B?amxWL1grbkxibmFWeDd4L1dDTFcweE1pWW5vNDRRaVdwNWxZUXNmbVp6?=
 =?iso-2022-jp?B?Ky9zQkFMR01tTE5tb2hYblN6MDJERDM5WjNpTWt3MHJtZThFSUhhQWdm?=
 =?iso-2022-jp?B?cEZZSDEzSnh0Z1ozRzRnL09adGdHZUVJdFNaMWY1clUzT1ZCQ0dRNkxP?=
 =?iso-2022-jp?B?STFVclBVd0JqL1QwODk1Q2NvajZ2SUtFb2pzdVlVTzJlQWJ1d2RJOXRk?=
 =?iso-2022-jp?B?RGtyV1dzd2tNQ21YanJzMDFLOFhVb2dIWGpIZWwvQ09NdjJ0TkdaaUxw?=
 =?iso-2022-jp?B?VkVuT0JPNitwOGdKQjc5YnBLdFlhS3FDclNSOHZQeVErYzU1aUlwcTZk?=
 =?iso-2022-jp?B?b0t4c0pkL1U3bUdTSWxCekliVFpVbU5sc2RpSm5lQ2I0K3Rqdi91SUdi?=
 =?iso-2022-jp?B?WFpNOE9UT3g3OUNDWEZpVDBzS2kvZXhiT2xJa0Jub3JXdXA5Q2dOeUNS?=
 =?iso-2022-jp?B?c0NIcjRVNWRZdzlMRVptajhNRzlROVJuL3c9PQ==?=
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
	NzBQC7eidAVC+uFv//ORLsHkCoqsnuoqKputkytCpNEkJIEYtycq6s1XcelQ91ObV6EDZWOwCllLA2Fitbh7g2I4e6+00JKLdXFpaq2m5BEaGTP9OKNy73vZ1USKdsZ48KGhZ36aP5RLAbk/X6fGdc5Yvny/WKiMzcWCxKKvijaAkFTVl71Lde8+8ISArWS7f12fMIbkY0u35qmos2YqKpSzzSKo5Ldj6Hw0w7Dom+29nKWIKr6igsFiy/uEvhrmQ/AUA2+cKTZDYBFnw331HCoeRz56Si1fUdu57Ec/Y87phAdp/sbsx4HWe5GApTSKnyRzajBBeQ+8ig56KGc8ceiVORR4HiQbGjeHSl0Yw7+hiVafNYRMJeWrfwxxNaPMbeVp6TPFxefwc8FKKiD0vkB3+rfEjptK6bKxyBivfhBQCvl4RoZry49N1BnUBEMTsJ55zTQuy1oxy1dmx/nQMP+bRAq3ma6xBPwPpWkRIuIe3mB4dxansgqG7L1WljGbkJAihMGgx+WbdTUZBxOt4TGmwISfjfFjT1liMaq17Wr7igLXR+GcNvDlJlKyEy2O6RDciKkw0Y6U9BT+wycw7FZI+FHVslSDtA/Ip0SxcAx7Nab8j4O5ncwkX5UzvbbD
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYXPR01MB1886.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9017339f-2c1b-4807-b29a-08ddb38a07fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 01:45:57.7079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S4MeG1bqJE0OY5ke/tOtDzODr0VxXDbAmshaAZPsOXqLHRv3wjFEGb6DeSqpuXGQFy4XPfpz3d7Pq2efKdD3bU3Jxd8MkQNqHBEjbCPfeW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB12688

> Entering a realm is done using a SMC call to the RMM. On exit the exit-co=
des
> need to be handled slightly differently to the normal KVM path so define =
our own
> functions for realm enter/exit and hook them in if the guest is a realm g=
uest.
>=20
> Signed-off-by: Steven Price <steven.price@arm.com>

I confirmed that the kvm-unit-tests execution does not output any error mes=
sages.
Reviewd-by: Emi Kisanuki <fj0570is@fujitsu.com>

> ---
> Changes since v8:
>  * Introduce kvm_rec_pre_enter() called before entering an atomic
>    section to handle operations that might require memory allocation
>    (specifically completing a RIPAS change introduced in a later patch).
>  * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>    HPFAR_EL2_NS as a valid flag.
>  * Fix exit reason when racing with PSCI shutdown to return
>    KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
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
>  arch/arm64/include/asm/kvm_rme.h |   4 +
>  arch/arm64/kvm/Makefile          |   2 +-
>  arch/arm64/kvm/arm.c             |  22 +++-
>  arch/arm64/kvm/rme-exit.c        | 178
> +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/rme.c             |  38 +++++++
>  5 files changed, 239 insertions(+), 5 deletions(-)  create mode 100644
> arch/arm64/kvm/rme-exit.c
>=20
> diff --git a/arch/arm64/include/asm/kvm_rme.h
> b/arch/arm64/include/asm/kvm_rme.h
> index 8e21a10db5f2..321970779669 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -101,6 +101,10 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
> ia_bits);  int kvm_create_rec(struct kvm_vcpu *vcpu);  void
> kvm_destroy_rec(struct kvm_vcpu *vcpu);
>=20
> +int kvm_rec_enter(struct kvm_vcpu *vcpu); int kvm_rec_pre_enter(struct
> +kvm_vcpu *vcpu); int handle_rec_exit(struct kvm_vcpu *vcpu, int
> +rec_run_status);
> +
>  void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   unsigned long size,
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile index
> 18e46c902825..863f401a36b2 100644
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
> 6a5c9be4af2d..ba2f6e0c923c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1228,6 +1228,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (ret > 0)
>  			ret =3D check_vcpu_requests(vcpu);
>=20
> +		if (ret > 0 && vcpu_is_rec(vcpu))
> +			ret =3D kvm_rec_pre_enter(vcpu);
> +
>  		/*
>  		 * Preparing the interrupts to be injected also
>  		 * involves poking the GIC, which must be done in a @@ -1273,7
> +1276,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
> @@ -1331,8 +1337,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>=20
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
> *vcpu_pc(vcpu));
>=20
> -		/* Exit types that need handling before we can be preempted */
> -		handle_exit_early(vcpu, ret);
> +		if (!vcpu_is_rec(vcpu)) {
> +			/*
> +			 * Exit types that need handling before we can be
> +			 * preempted
> +			 */
> +			handle_exit_early(vcpu, ret);
> +		}
>=20
>  		preempt_enable();
>=20
> @@ -1355,7 +1366,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
> 100644 index 000000000000..aa937272afc0
> --- /dev/null
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -0,0 +1,178 @@
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
> +	if (!is_write)
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
> +		/* Set RMI_REJECT bit */
> +		rec->run->enter.flags =3D
> REC_ENTER_FLAG_RIPAS_RESPONSE;
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
> +		vcpu->run->exit_reason =3D KVM_EXIT_SHUTDOWN;
> +		return 0;
> +	}
> +
> +	if (rec_run_ret)
> +		return -ENXIO;
> +
> +	vcpu->arch.fault.esr_el2 =3D rec->run->exit.esr;
> +	vcpu->arch.fault.far_el2 =3D rec->run->exit.far;
> +	/* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
> +	vcpu->arch.fault.hpfar_el2 =3D 0;
> +
> +	update_arch_timer_irq_lines(vcpu);
> +
> +	/* Reset the emulation flags for the next run of the REC */
> +	rec->run->enter.flags =3D 0;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_SYNC:
> +		/*
> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
> +		 * see __get_fault_info()
> +		 */
> +		vcpu->arch.fault.hpfar_el2 =3D rec->run->exit.hpfar |
> HPFAR_EL2_NS;
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
> fe75c41d6ac3..b13db573f64b 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -936,6 +936,44 @@ void kvm_destroy_realm(struct kvm *kvm)
>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>  }
>=20
> +/*
> + * kvm_rec_pre_enter - Complete operations before entering a REC
> + *
> + * Some operations require work to be completed before entering a
> +realm. That
> + * work may require memory allocation so cannot be done in the
> +kvm_rec_enter()
> + * call.
> + *
> + * Return: 1 if we should enter the guest
> + *	   0 if we should exit to userspace
> + *	   < 0 if we should exit to userspace, where the return value indicat=
es
> + *	   an error
> + */
> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
> +
> +	if (kvm_realm_state(vcpu->kvm) !=3D REALM_STATE_ACTIVE)
> +		return -EINVAL;
> +
> +	switch (rec->run->exit.exit_reason) {
> +	case RMI_EXIT_HOST_CALL:
> +	case RMI_EXIT_PSCI:
> +		for (int i =3D 0; i < REC_RUN_GPRS; i++)
> +			rec->run->enter.gprs[i] =3D vcpu_get_reg(vcpu, i);
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +int kvm_rec_enter(struct kvm_vcpu *vcpu) {
> +	struct realm_rec *rec =3D &vcpu->arch.rec;
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

