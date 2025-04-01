Return-Path: <kvm+bounces-42290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6682A774C7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 08:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B419188D687
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 06:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0901E5B69;
	Tue,  1 Apr 2025 06:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ICLvjgoc"
X-Original-To: kvm@vger.kernel.org
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262D53BBC9;
	Tue,  1 Apr 2025 06:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743490562; cv=fail; b=RMnoDUXrt4/xzNW/p3sg3qExbCcybQTirxvrdIAPRXlE69BCBHBWXI70hgoZRneeIQTufjuFTKgYOtxipfKXIs86+Uq4agDKR5wb44RxixmmFBzfkz2MxmsnWnN/xa/h87efNj/4bsS+XcoDxLRmSyHD42AsZZ2T0A1YxJvgGtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743490562; c=relaxed/simple;
	bh=OjddLECZeSDeOgI8JY1WYUW0GVv0DNeG3LHPIXRAgFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qpp++ZFYSRKzbUCBKwYzD7TxqTMpFBC598yMsPgUwRPRk3JDWPYHFsXB1CJ7VcjRB0OzT5alJsuRbanOvjUi0sJqA+5X2u0g25KtL5Ue+4rSQnsyKCTOMeuFdqlwP6BlgKkTfRqzzTDRxwh/j60t72k4pf0g2SowCvTNfQ982+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=ICLvjgoc; arc=fail smtp.client-ip=68.232.159.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1743490560; x=1775026560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OjddLECZeSDeOgI8JY1WYUW0GVv0DNeG3LHPIXRAgFE=;
  b=ICLvjgoctfVyu+cGIs7c924UBafIa+i5lAtI6zTD7zZLPjDZCcFWJekT
   9eQX+vEpKD7M3fRxxANtKqXp7oxYeypwlNyhvOCIhE/4hwFyGS5hYQiUe
   qahs/fnas9arsY1a3XPitI0efLOuRmASCoj02+S3p3IQsaFZJiaP///29
   iIbaHtv1gb4e7qSP86fWOUDdV5bgaYrbGkSRAURRYM2mn5HM/vizKREel
   fnnbG6TfsibnG2l+swVcV8bsMSEan5ul+Aq+XHrREi7AuII7BOG5Tfy/c
   OLr+2s+SYZvU1OGIkvhjII+3CJ9Ge5dRFC0rkjJ6/4Z9VXvDsGgljjTFG
   w==;
X-CSE-ConnectionGUID: wWDgokw7SHy0l5bjPBFo2w==
X-CSE-MsgGUID: +SYBCokfSPO7hDBXwgeSzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="151373894"
X-IronPort-AV: E=Sophos;i="6.14,292,1736780400"; 
   d="scan'208";a="151373894"
Received: from mail-japanwestazlp17011027.outbound.protection.outlook.com (HELO OS0P286CU010.outbound.protection.outlook.com) ([40.93.130.27])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 15:54:45 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leRSLNoIuViW5RcqLv3V60Db2llaA/8tqObmnOQTYgmQTlcbRO4ybzEs1r/DZ/p0dhFCx5bZkQ8yuWscgAphmQxaTOfYa4zAV3B713WXulYnAyGbR0u5hXvPzIf+H6xeumgE+rIeUXL+Sz5EJMmeqMUfatI6SwdXjzf3/jm1Jz4TsSFgv2bsCB8qjVXkIUsuXoxzv77ns2JMWGzqofgYmrPJZJFx8HT+Qvo6uYGr1Evq49C+BTwh1yGBlw0KcOm5syb1LeCIbG9LoYwlUQ5zcMFkobecYFLFVcCFspKZyeTZc/2e2kQTUul0qHFqLKPs4PPWeFimnAGtN2PP+XCZ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMA1o3ejEcuS+A8IFOt7cxzkhddbyQNy+8VP2C2mITo=;
 b=r/yPaHLmOJ+AA35cu7wX1TL4QZ5IzXuVJaEaZpTEZit6KWA2c0HFwoCninqnOYbg+D2iL6mPkPEGk58n7kheSNCDhI3osy1ww3mgXw/7FCEoaNP0WhYKuOnT2DjoAS6lCZMj/XT29ns9uyKkGukszFyCnc2jsx2s1GiDWZZid6BoyA//bNEHjg6J0O3jPJAshdqAIwVdz74Ue5tuNbX0LZtj2NQ0OjODxHBjYpqrW+MaLq3ey7OcSSeAbpndgpNX7xwGGVbZrsYu3GGy5bZZ1nh8kGmqHXhr8qiA8Ap0iKIm8FixIUipy0ckWJS/p3G38cbLmu74LIps1BD8LW/bXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 (2603:1096:400:389::10) by TYWPR01MB11326.jpnprd01.prod.outlook.com
 (2603:1096:400:3f0::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.38; Tue, 1 Apr
 2025 06:54:33 +0000
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8]) by TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8%3]) with mapi id 15.20.8583.038; Tue, 1 Apr 2025
 06:54:33 +0000
From: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>
To: 'Oliver Upton' <oliver.upton@linux.dev>
CC: 'Steven Price' <steven.price@arm.com>, "'kvm@vger.kernel.org'"
	<kvm@vger.kernel.org>, "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>,
	'Catalin Marinas' <catalin.marinas@arm.com>, 'Marc Zyngier' <maz@kernel.org>,
	'Will Deacon' <will@kernel.org>, 'James Morse' <james.morse@arm.com>, 'Suzuki
 K Poulose' <suzuki.poulose@arm.com>, 'Zenghui Yu' <yuzenghui@huawei.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, 'Joey Gouly' <joey.gouly@arm.com>, 'Alexandru
 Elisei' <alexandru.elisei@arm.com>, 'Christoffer Dall'
	<christoffer.dall@arm.com>, 'Fuad Tabba' <tabba@google.com>,
	"'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>, 'Ganapatrao
 Kulkarni' <gankulkarni@os.amperecomputing.com>, 'Gavin Shan'
	<gshan@redhat.com>, 'Shanker Donthineni' <sdonthineni@nvidia.com>, 'Alper
 Gun' <alpergun@google.com>, "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
Subject: RE: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
Thread-Topic: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
Thread-Index: AQEtDkc9LTcodmkzl5rPqzVBxQkHJ7ThxWSAgABKxACACXXE0A==
Date: Tue, 1 Apr 2025 06:54:32 +0000
Message-ID:
 <TYCPR01MB114635E18970432A5BDAAC476C3AC2@TYCPR01MB11463.jpnprd01.prod.outlook.com>
References: <20250213161426.102987-1-steven.price@arm.com>
 <TYCPR01MB11463C8CCEFEDAF79868E9BBCC3A62@TYCPR01MB11463.jpnprd01.prod.outlook.com>
 <Z-ObUJQn2dGsgSsO@linux.dev>
In-Reply-To: <Z-ObUJQn2dGsgSsO@linux.dev>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=ea874d93-0b5c-4a8f-bfbd-a570d597358e;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2025-04-01T06:47:33Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11463:EE_|TYWPR01MB11326:EE_
x-ms-office365-filtering-correlation-id: 2d082537-5970-404b-15ea-08dd70ea0eab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?cnRsaUpCQnVEcTN2ZjlNeUh2OFlWemxMbmxaZTU4bC9EVUV1Ym5PSmFN?=
 =?iso-2022-jp?B?Y1I1TkVMbUlNMWpzZFRFWGRHSGNTVzlFcW9zclhoK0ZWcWFoYVFZbnlU?=
 =?iso-2022-jp?B?SGNIYUxPNlhIYXcrcUt1T1lVODYvY0FQcjAwc0dLRHJQM242dDRxWEc1?=
 =?iso-2022-jp?B?MEpyWVpaQklmSVYxU2g2QlpNaE1GTTlYZzhyVkU3N284Szd4R1RTWFB1?=
 =?iso-2022-jp?B?VHlLOWdYV0VDR2RrS1k5TWNZL3I2dnZJdmt6clJnc2VMQitDcjBRUmFl?=
 =?iso-2022-jp?B?a2ZoTEVJZVpXSkI4QVNYRUVLRG9SV3RoVG1DOVV3T2lNcHJWR2V4aHZD?=
 =?iso-2022-jp?B?RC9nWUp5SXVKU3VSenFmeWhPTngzWFN1T0JZc0ZLT00rSTE3bktYY0Ru?=
 =?iso-2022-jp?B?K09jcVNjUk9Gd2hCOGNMVmorcHJvazdwMjR5eFJaVE1iUXVxc3NHeHpT?=
 =?iso-2022-jp?B?N1FJWml4NFBEclVmYzdoNDhnODc1VHEya21wTkVMc3JxOTMwcFdDOWt4?=
 =?iso-2022-jp?B?TmUxbndLMS8rdGdnVnFzTCtwaE1LcHN4bWQ3UkVZY3IweDdBSTRpMG9F?=
 =?iso-2022-jp?B?UDVMbW5tSjNhcnFodFdtTkZTQXVLLzJidE44VWRGUExDUit0cGtZNnNW?=
 =?iso-2022-jp?B?UHFQcHdUZktud2FxUC9TRkZwOVhCYmE1Z0JrRTVZTkkrUllPQVdVZnZy?=
 =?iso-2022-jp?B?QjBhNEJKMlRXeXpoSnY4NVhxWER0aURMU25QMytXbWRJYjg2SWdXM3E4?=
 =?iso-2022-jp?B?aG9UU3N1bWI1QTZaRStzTk95T01YWDJQdU12dFNPSTdmdzVObWhWSFlS?=
 =?iso-2022-jp?B?cHlEckNPUmF0ellWTFVQNTkxRUMzazFuQ1JnVWF6Z05obDkzL1RTYXQ4?=
 =?iso-2022-jp?B?NGMyNmZOeE5wV3lnWE1FNEQzZm1hRHJ5ZWxUeXdsM04yeEpkdG1oaFUv?=
 =?iso-2022-jp?B?WGhWTWlTSlVxLy9XdWh2Q0FvNTdGRCtJQlFFMzdxQS93cHRRS2xIcVFF?=
 =?iso-2022-jp?B?eEtKWDJGUklQbW1pbzFBRSsxcHdIQ0pwYnZvejRHaHEvQ0RNU3ZkUmxv?=
 =?iso-2022-jp?B?RjVUOUd4TzFiS2E5ZlBYNU5zY0QvWVJwd01tSEJMdlA3N3dIN3JFeHJo?=
 =?iso-2022-jp?B?T0greStHWUwweHQ5UlQ2N1FZZlA4MkY1bnplbFpIc3pqZE00SXhqTmcr?=
 =?iso-2022-jp?B?am9FN0lRM2ErdVZFNktVc0VLYXU3eGtXSlN4ZTg0L20wY1phQUtCVUY0?=
 =?iso-2022-jp?B?bmNKZDlQMGMvSVFHQm1ObmRGdm9Bb1htM3dGSDNhek43UlFiUmgzV2JO?=
 =?iso-2022-jp?B?dTVZeXRsOVpaY0VpTVBTNmJ1UUY4RW1pQ2xzeFA0b0FKZ3pwbVFnSGts?=
 =?iso-2022-jp?B?TTRKZUltNkFLNWI2Ly9ZQ3FmU3c1OFZtRkQ3U1hMNlFNTk9JOHZvRk90?=
 =?iso-2022-jp?B?OGVnaVp6eVpvcTBkTjByN2pQb2ZlUktrTVRIbU1DMklBN2k0bnAyWUhm?=
 =?iso-2022-jp?B?K1FYU3NvNGVZY2VudEo1a3NxUFlucGVtZ3pnZTJ0MGx1dnVLU2ZQdVlU?=
 =?iso-2022-jp?B?RjAvcEd2S1VORTNaR1RSNHRMWGZLQ3hQUVljc1BRSzdraEVQSWRYd1pv?=
 =?iso-2022-jp?B?WGlOSlBvVk9Wa05jMUVneE5xVjlXOGN2R3ROSzJZNTdwRHNCQjJCUlF1?=
 =?iso-2022-jp?B?eVlCclJIODN1YkoveW5MUFd0ek5ub3dsSzlDczlpVXhHQ0pjSlN6RVRV?=
 =?iso-2022-jp?B?M2ZZcTdRVUIyU0gzNEloN0YzZTJsTWZyK2xUZm12VXR1TG14RVJUSmZ1?=
 =?iso-2022-jp?B?RjMzOEtmQUFQeEt5c3pKNWcvaTdxZ3gyaktxaHRBekNHRkNvQjAwOUNC?=
 =?iso-2022-jp?B?OVIzSWc3VUJLbk5jTHphLzNONVpsWGF2d0tONFNsRkM1VEpNTFM1Tk44?=
 =?iso-2022-jp?B?YnB5aFpUMHphRllqeEFWQ28vRy9GbFdXeUt2ellZMHBWS0Q5R2tSK1ZR?=
 =?iso-2022-jp?B?SWk2S3NOZFhyT0Npb08rR2RuaXF3L1d3Y0pqOUc1cVF0dnlpak9xOUZV?=
 =?iso-2022-jp?B?QjlmRTB4MktXRW9yMElraUNES0EwM01kSTdKN3dJV1ZTR2xXWGxHWTNt?=
 =?iso-2022-jp?B?eWhMQ0J2djAvTXJmUjhTTER5L1FvRTRrbGlLdE5BOGpFT1RoMjl4djhO?=
 =?iso-2022-jp?B?MUUwPQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11463.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?dEM0cks4VE1yNHF2MGVONEwrSGRVeE5qblB4NkFEb2NDR0s3WnJiS0Zw?=
 =?iso-2022-jp?B?YVVBdGxhcWRuQWdHTFIyNTV4SGJBeXFRYWdVOUhPa05hT3FiaEdCcGRQ?=
 =?iso-2022-jp?B?cjZrSjREYUpHWXgxbXk0L1dob1RZaUNKN2E5Um9mVjdjbEZlWXJxdjRC?=
 =?iso-2022-jp?B?MUMyTHVhd28yZWJmQjJiNXowZmQ2NmFub2xDL2ZxVWtoeHhCY0JXN0tJ?=
 =?iso-2022-jp?B?bFFPdCtFWlNwWXpBODFIUEwwYnJ6L2xhOUNZbzgxUkJZVUtVUE9hVndm?=
 =?iso-2022-jp?B?UGRWeWNRZkxabVg0K2pzU0tpVVhUSDhXenpIZGVGckFCa21Gek1va2JD?=
 =?iso-2022-jp?B?S1NWQmo1NUdpVW1pcmw5dVB4Q3UydkxRdmxMN0UxdGRybmpWU2tYTVFw?=
 =?iso-2022-jp?B?Zm5PdDlZSkg3T1ZoQnM4TVozN0VIOGU4MXRnU2x4a2xnb1pRQjJBL0xQ?=
 =?iso-2022-jp?B?RStTSlVmR2xUWHRQYVd5NHc5dzlKYS9WODBreXhJWm9UK0NQQWNMRklV?=
 =?iso-2022-jp?B?RERGcEdtWm9Ja1hCdnc5S1RONFZqRncvV3lncUszSUZFTElDYkx2V0Zi?=
 =?iso-2022-jp?B?b0FkRzNEcEJyRjlmU3UxcjU4U280ZjlmUWd6UVNreGkzN2RYYk85dE5S?=
 =?iso-2022-jp?B?RXhrdE9LWisxVmZPZFNmTlc2UFpJY1NieXZCbk42WHE2RCttcVljOGtD?=
 =?iso-2022-jp?B?TEVGZjBzaVlhMVNONVdieGxwOFVlb2dlZTBMWWxZRWZxbjJPQlVCWFRk?=
 =?iso-2022-jp?B?cUFBSTdQcm41OHVJSHN0NkNhbGR4RkU1WHhHNklVckdYR0lYaUo2ajI4?=
 =?iso-2022-jp?B?UzluNGdBRFU2NjBqMjhDWXN3cGJOalpndVRnSmZGeW1Bd28rdU85MTNo?=
 =?iso-2022-jp?B?WkMycVltWHo4Y3cydUhCRmdVNDdnTitFbU1VNGtGZmlZNGw3RzcybExm?=
 =?iso-2022-jp?B?elZzYzZvSDVxdXZ6bE1uSUROenFzaFc2bDVncEJNaDBjdC9LRzhONkVS?=
 =?iso-2022-jp?B?dDk3Z1V3b1IwbVFpekRYaEQ5SXNvL05XRlVUNjc3bUJqRWpFeTgrM3Fj?=
 =?iso-2022-jp?B?QkFYNzFDY2NQVHR5cTdTWmRVK2owcGFIWktMMWtadWFHWjNlWGoxeDFU?=
 =?iso-2022-jp?B?eThzRGg4ZTZMTFRpUkhweGZzeUw1c21XcnBYOW5aRmxFK1NYQmROVml1?=
 =?iso-2022-jp?B?aTN4UmZ3bkpvVXBIVUp1SnloczZHajVVL2xPT2Vzc3VybzZjM0dEMTZu?=
 =?iso-2022-jp?B?WkpIcVVBQ3lPNnRiRUFEUHowOWlZM01scElRZCtLaWJwQjlHMHhsa0R5?=
 =?iso-2022-jp?B?REZrSEQ2ZVNteVp1b29xYVB3SEorbk5JMHMreGNSbzNPaG5aRGM4SEIz?=
 =?iso-2022-jp?B?aUZaRVgxcDZveGlRSEFWRkVIaUZkNmV4ZnZ0MStjcm5qckRVVHVSMUZZ?=
 =?iso-2022-jp?B?LzZ1dHNYeHQvOTQ4OEJVdUM5b2RvL2IzN3h0OWs5KzVYSC80dDR5a2RM?=
 =?iso-2022-jp?B?aVNlZmtHUkx5MkFuZWJ3azZoT05VWDlRcGI3NXBnMTJIUkZlVmlDZkpN?=
 =?iso-2022-jp?B?NnM2R0JsSUpEd1JlSC9lUndSZ3lacEQ1R05TK0JUTkpRVlEwSkduaWhQ?=
 =?iso-2022-jp?B?d3NyN1NqTGdIRHpUdDhRa2hCM3hiS2ZYZFVpNW53Q0F1S1NzZVhFR0dQ?=
 =?iso-2022-jp?B?N05GNnBkRlg0d2pJYjhCd0lqa2ExNy9na1BzTkkvMFBtNHdjbGdBVFAy?=
 =?iso-2022-jp?B?Q2F2OFhmT3lLb0ZoaWpLSEE2L2E4SXRsK0YxckRKSGpTWm5nWXE2S01I?=
 =?iso-2022-jp?B?TmNFbENJMDUzcEpRamxDV0FuR1FibjRzY08rZlZDQVFWMHFwUlhZdC9B?=
 =?iso-2022-jp?B?OWFRMCtYOFg1WDE2V3h2SGlCREs3OXcyNGpaTFE3OXhSQ1haL3F1SERB?=
 =?iso-2022-jp?B?cUtSVlJIYUx3ZnE0bzBlSk0wYXdwVjdWTVdCZ3hGaE9ZLzRMdVBUSTJS?=
 =?iso-2022-jp?B?UUxzR3drNUswZ29OdEhlMkY4UTloUHluTFRYejIxSWdLUXhUYkRCOVFW?=
 =?iso-2022-jp?B?MHZlR2ZmUFZoazlNam9zSkFOTzZubmdYSnVabWZ4SnFTODc5VGxxK0RU?=
 =?iso-2022-jp?B?Z0RvRWZOUmdnUWhRaW9HejB3ZWEvS1IveVF2UXR3N1lyZThyYVlweWx6?=
 =?iso-2022-jp?B?blloaXExRHlXVXFJNWtnV2EvVzh1Slc0bTBMamVVdjgwZVQrV0llNS9J?=
 =?iso-2022-jp?B?UGgyNENEdytqd2JXbjdGSXNkZWUwSmFUMXY4cUJxZmdvRU9jeGFrSS80?=
 =?iso-2022-jp?B?aHB6a2Ird3NkVytpekZ1Y1ozOURPWTFhaXc9PQ==?=
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
	CiQOUS6V1Kfr8qnk+W5IkYVf4QoOPHD51eaF0KeqYqMBEcyDDeAENt6h99sO/92knlhxKeEIQxSfd/gV7coill1OQ7StvXURFKQCcpZjnxfgHgcJar9WpwE1pIJzfQmCWiAGq3vUbcBWYo4hrBt9ByU1zH64gT2XxL/U40rz2mQrpEy7Kp9Bi0hJepvaIvaFd9mcBe55EF4MoIkZ00UQ3C7N98ubUdO4JZfUNbfumJ7DmxtSsCro3eV29M/ksiAUQ9kYv5CCyOakxpNZduHAZIBYfSD3I1eyT8lTIcnlUseC8cmaTpWYFdEuWvOEzWSoUPOU9NqCycAnH4BRKhrLNyBHz+qTEZnnmRepkXfNDaYYnvRDUbXNuAGZKu3NQhRirxqFlC1Jldc/fZuF0fhQdW3bV7vA95QBgLuI6fLYu3X12TS8fsI7anMnFLPyCXi5tSVQd5uuFyyG1rXuHwhNW0LBPw8Vx5KqT/lcIzic+sRJKqQkdwViFBZbCn12ca8EogqTARUYubc58fUBy8KpBXx1T6XNKDSRZseAXJe3AvMWKScIEXkOobfzdEmjN+fUJ8XFr7rPejJ7lcbfcH2Dn4gOsYY0AtQC4ooDY6psSLa3lgROFiyvPI9C7o5Ax1xB
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11463.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d082537-5970-404b-15ea-08dd70ea0eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2025 06:54:32.6999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: trIAVd3XUyjqQpTRTQA1Mx0jT5koSSnP1XgIJZxeSb31Nc3rdX0bVjS+0MD+funSqJTaTBu2Ylqx7GMo1ya+JPPwVLjDGyM11eut4sEWeE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11326

> Hi Emi,
>=20
> On Wed, Mar 26, 2025 at 02:14:35AM +0000, Emi Kisanuki (Fujitsu) wrote:
> > Hi all,
> >
> > I tested Linux-cca cca-host/v7 patch with our Internal simulator based =
on
> QEMU (with CCA and MPAM support).
> > A panic occurred when starting Realm, but I don't think this is a probl=
em with the
> cca-host/v7 patch.
> > The location of the panic is [1].
> >
> > [1]https://lore.kernel.org/linux-arm-kernel/20241030160317.2528209-4-j
> > oey.gouly@arm.com diff --git a/arch/arm64/kernel/cpuinfo.c
> > b/arch/arm64/kernel/cpuinfo.c index 44718d0482b3..46ba30d42b9b 100644
> > --- a/arch/arm64/kernel/cpuinfo.c
> > +++ b/arch/arm64/kernel/cpuinfo.c
> > @@ -478,6 +478,9 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm6=
4
> *info)
> >  	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
> >  		__cpuinfo_store_cpu_32bit(&info->aarch32);
> >
> > +	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
> > +		info->reg_mpamidr =3D read_cpuid(MPAMIDR_EL1); ///////
> panic occurred here.
> > +
> >  	cpuinfo_detect_icache_policy(info);
> >  }
> >
> > There was no problem with the cca-host/v5 patch (based on v6.12).
> > This panic is caused by accessing MPAMIDR_EL1 when the chip supports
> MPAM.
> > This functionality was enabled when the cca host patch base version was
> rebased from v6.12 to v6.13.
> >
> > I am not familiar with TF-A, but I think this maybe a TF-A's bug.
> > Because It seems TF-A sets MPAM3_EL3.TRAPLOWER to 0 during normal
> guest boot in manage_extensions_nonsecure_per_world function[2].
> > However, TF-A does not set it to 0 during Realm guest boot in
> manage_extensions_secure_per_world function.
> > Therefore, a trap occurs against EL3 (TF-A), and it is likely being pro=
cessed as
> an invalid instruction (Undef).
>=20
> Your instinct is correct that this is *not* a kernel bug. It is the respo=
nsibility of the
> RMM to provide a consistent feature set to the Realm.
>=20
> Looks like this was addressed recently in TF-RMM by hiding FEAT_MPAM:
>=20
> https://github.com/TF-RMM/tf-rmm/commit/7b0874403726d215c40054abfd5d
> 8704049f8dac
>=20
> Thanks,
> Oliver

Hi Oliver
Thank you.=20
We will backport the patch you mentioned.

I have verified the following
1. Launching the realm VM using Internal simulator =1B$B"*=1B(B Successfull=
y launched by disabling MPAM support in the ID register.
2. Running kvm-unit-tests (with lkvm) =1B$B"*=1B(B All tests passed except =
for PMU (as expected, since PMU is not supported by the Internal simulator)=
.[1]

Tested-by: Emi Kisanuki <fj0570is@fujitsu.com>
[1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v3

Best Regards,
Emi Kisanuki

