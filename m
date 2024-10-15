Return-Path: <kvm+bounces-28888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A360A99EA49
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C5D21F25646
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C11A1C07F7;
	Tue, 15 Oct 2024 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgJvhdys";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mgJvhdys"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2083.outbound.protection.outlook.com [40.107.22.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FE1C07D4;
	Tue, 15 Oct 2024 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.83
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996531; cv=fail; b=jUX+lnwU66vXBDFModLmEy2rtxFdr5jSDjt0yTC4F95YczFsl6czKkEkE7re/OGX4QLe13F4clbd2F1e4967YrRz9wQhqtEcXmbdboG4w+zACZwRiJEyvzeqU4cjIzX+TAXwRlKCcBz82h1AlF6UJcG/7Htbe3txF8t0QLLR1lQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996531; c=relaxed/simple;
	bh=YedFrnokZGHr9b8fM1HXcTUAphz9+uzXnLoe7CervNU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gAlbxwQBbjh77++Wf2Fetg5VKbN1aftkMpvH4WwCnPiif2WARjxiyRgeGL/Roh+u0mEEcIP4z8m2Qzgsz2aYRkUd1DJ/vlg/wM2kq8/W4Nb6k/rUkF7pbTYxif4qodu4fJDMsFzE/ZgQwBA2KF91WCT9PIP7UBGXtuTTq0UW6Lc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgJvhdys; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mgJvhdys; arc=fail smtp.client-ip=40.107.22.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ChsgM3nU/bwSKjBQBusd5+IE83GzM4DYIT38k3bsBzaebLV/1W0c4IPUpHWM4+1lF7TA32GwFtuJQYGTvoVjC0Gyky9FAMKRQPRKpXvnGwaeO9MtEZYYKGIB1ncd1hfPA2mtNi/ploXvZS/L5a43tSxcTtO9+oa+58M8j/ga1pTky2czJnj8d+Ckv+a32dt6GzqPSK/LxRBpI0fpaYcy+K9ZBsIO3TIygpK3lQb6RrvL9mNazsWwgxyiB3AQRwwvwp1AkqoOntd6evMK6uRbyxU6Alm5LprLfA+udnWFz7rgLAC/jszZuxxWSJn1kFOGOB4GN1FTMbGvScHwSEbgjg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=Lo0FuQG0ofPgs0oJvng8bWczYaatC7zn43T1kH/A4UGrU6BKoDoL9RNqc42Ud/NtP3KsCFGiUf0Ijqm7W5a04IgHaVO+g6QKp9vOgb1crsTuB3ykwPZMQi3ZBpvE8g/JSCmAt0i83qNumIZg/qlhoO/booGrhuXAdRMGItz/bY0EsfmDBd5if8jjT/FYbmCTYtn6RV91LnHUsps/Qx9+wkz1lv2dLC8VaX5uRyiu8SCH4fb9vbQ8iflrste8JSi8PswWuVLbA+cLP5yC1s84HzyXiYdI24RtSj/kmj31F78PhLgp5ATJfNfZXyhXpnHGWtaZpyTQVWw9l6Q0ZR5xhw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=mgJvhdys1B4JxRPmNgP4OEmdcwxLs7kXCS9a/ZBQzFdpdwvSCnpA+ZdZKp+uxnzh3YDRZcjF9/1bIYMaTjB7676vzmhLY0lIKSd6ziMlAvGPQTuc/xsm+ewSigaXQFmHAtuhg4QTOZqKHW/sm24I+ynMn3yfCK9DZ6HXQg2ONlg=
Received: from AM6PR10CA0080.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::21)
 by DBBPR08MB6011.eurprd08.prod.outlook.com (2603:10a6:10:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 12:48:42 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:209:8c:cafe::9) by AM6PR10CA0080.outlook.office365.com
 (2603:10a6:209:8c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 12:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 15 Oct 2024 12:48:41 +0000
Received: ("Tessian outbound cd6aa7fa963a:v473"); Tue, 15 Oct 2024 12:48:41 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6a48062eedcba61c
X-TessianGatewayMetadata: Icjp+1A2slBswNVIPftU0NbZtdh5cTiAeKo+ZIqcxcUTjNxh649ZGqxRekc6u2HaZpKWp0x0m5AccMCh0OvPhYTsPnQZZ+Q7lcQ9yyjZcS3nKjIH7NAHXtnOdSrfmqcxeJjAZle/mc86eWftTlpo0q+1cGZQkg0OSnB4wOvqMFY=
X-CR-MTA-TID: 64aa7808
Received: from Lcab9e31480f5.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B5177B8E-12AC-4ECF-9565-3B8854197832.1;
	Tue, 15 Oct 2024 12:48:30 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lcab9e31480f5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 12:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIH6Hc06chxTsu0y6Vle3RuhkJtVTT/03GxALnZ0gUCr6KW8Zrtf1pLaP85zxvM4jX8r5xGSewDTS8nC/Nw2DtKYlhN43ocVp2hwYyZw+3Tx4dW88gGJwLGQJSnKlCs7x8prCjEgczv0tCLB6Uyg3XqqRGA85nWbwWWXOb1t5lI0vVYxsi+/wzrE3U5TEfjRPD8QmQFXPpn7kv/vkhe1c3++eTQdy8RnTRAWv3tlhqg0aBvWX8u5jHeGkuucTRpCcDlw82JCNepTVzGr26AEc2WtPlPuoTfF76rx3pS7R9SVCv4ts7d4tiwbc+elhqNg/24J+XUkxcrh4YbGafG+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=LHhzBqWWXXoZl2nF1GaNzLINj53wtj1imWoyXJ8VD39n3DrWxXoY3QlH/vjRUXt5YJA6mMR9aisfKN6tA1aRt3tD5DPbub/oFosATr8A6z6JfoGN3aKqNgZtJQTet7JX19/AR/AKWVlNAaSLl0JI9Ls9M5wdRQl8Zf9XFkp0zx27iQq4s0ufnXDYqFnEhkPzvGqHDwbp/Q8k3rQU5m+gkduHIWQXJ2U+f+DgCGbm59cZnrSpiESq5uocYeLfQCDCvRYH1V9OiQRRP/r4j2tWNpMc7cKNl044EiZ8ygbLXcIxvhyg2Bq8KqjXlfe/cg9ZT5xSMRq7pOHvXOhEB77mpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB9609zvMbchdkyfXpNxyPlh67FSvA4uhUlZQUoyCyA=;
 b=mgJvhdys1B4JxRPmNgP4OEmdcwxLs7kXCS9a/ZBQzFdpdwvSCnpA+ZdZKp+uxnzh3YDRZcjF9/1bIYMaTjB7676vzmhLY0lIKSd6ziMlAvGPQTuc/xsm+ewSigaXQFmHAtuhg4QTOZqKHW/sm24I+ynMn3yfCK9DZ6HXQg2ONlg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by GV1PR08MB8081.eurprd08.prod.outlook.com (2603:10a6:150:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 12:48:20 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 12:48:20 +0000
Message-ID: <6d4bf0cc-7060-4843-9e15-e4ed23c74839@arm.com>
Date: Tue, 15 Oct 2024 13:48:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/43] arm64: RME: Allocate/free RECs to match vCPUs
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-15-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0169.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::12) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|GV1PR08MB8081:EE_|AMS0EPF000001B6:EE_|DBBPR08MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 902165ff-13d4-4784-bccc-08dced17b2d1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SXNuNnVza0JKSkZnWEFKa0YyWGx1OUd0K252RVRCM2I2bUNNYzExVFJxTTlN?=
 =?utf-8?B?cG1JdjM5SGs0SHc5US8yaXhvSkJCSFo3d1BtdUdDWjg3R3RBVTBiSkVXU3ZX?=
 =?utf-8?B?R21rNGJVSFVHYStXeDN1SGpXZnovUkJsV2NUeFdPemVVbWxNQUthQ0YzYmRm?=
 =?utf-8?B?SGRTbUpMNkVGcUVMaFVSNmVicmxFcStUMXlxemNHK3lwUlJaVEdacjhPMnpS?=
 =?utf-8?B?OWRTTmp0ZW1nUW9LQU9ZS3g1c0o2anpGd1FqOUVYb29DdG5WeThHclMvbE9J?=
 =?utf-8?B?ZTVHZmZaY3owMHFUVVkwQTB4RURpUWJaaXoyS0FLU3l4ZXZQbFVpU25WdGpi?=
 =?utf-8?B?dy8zQ2xBSHdWYmhrVTM3VDRBUWlVbGlma081Ukk2U3FpaW1wWmNzd0ZHVFdC?=
 =?utf-8?B?dkwzK2VFS1JsM0JFWi9YazIvclRJN25TcXJ3cy9uTm9kV2ltSmhRbXczMnY1?=
 =?utf-8?B?TE11YURGWmZ2T1d5OXdwbjQrM3FBaVZ4SnloNW00Y2QraDZydmUvY3ZhNmJx?=
 =?utf-8?B?bGxWUTF4UVRkaDFBYjNPVHhDNjJnYVk2VGFtVjAxOG1zN002S0RMYTZaTjVm?=
 =?utf-8?B?VGRxNHVPMWdhVmlPb1FVY053b3VNR1E4TDVKN3ovZlkxVkdJV0dpNllwWTg0?=
 =?utf-8?B?SlVZVi9kVWRJZWNmeGZrMys1dEJVL2k2RGZNazF4aWNycDc4eG5vRGE1RlIw?=
 =?utf-8?B?NmwzQUY1VU9WWUZlNzQ2ZWdPQk9QeXh0aFo5VkJmbVFpMStsU25qOXBDUCt4?=
 =?utf-8?B?VW9zSnVBaXpDVWE0OTQzaXhlbFNFVENuS1NEY3pFTUJEdC9xcE9YK3g3S1Bk?=
 =?utf-8?B?c2UxWEhxZXdVY2dWUXZINWJjWnJGd0dCU2ZPUS9LTUJBODBGRFZ6WURtWnc1?=
 =?utf-8?B?N1RJelVmd0VqRGtQRXVzR1N1RzhpdzcvdzkrYUVobC9XTFF4RnRCNDFPVTh0?=
 =?utf-8?B?SGtYMlRvOG01ZWtkdVBlNnhTODZHbVFvVnpGUDdhM0JGUmdxdjBFd204S2dp?=
 =?utf-8?B?MSs3QmZaRGZhU1JabHhISUMvcmw4WkR6UFdBYjdLYWViN29zeTl1KzY3YjlE?=
 =?utf-8?B?eVE2Y3NDWktMak9aYmdYOVdzYWZOdXMzWmNNOGNUK1E5cGhzaGY5OWNNOS9K?=
 =?utf-8?B?T3M2VFNKL2JuU3FKdU1KZTJDczIxSDJValZ1SzRiQVJkcHRSb1hYbHJXQmhw?=
 =?utf-8?B?MXNBeDRUb08rWlcyTzFKL05TMEVPU2pXWEpUcFBQQTNJdnpERk5ocmVnVER0?=
 =?utf-8?B?WTRzZnZKS0Vmc3NMNWwvem1hSXIyVmkrR3FLSDRBRHVTY3Bud3NiOGxlVXlo?=
 =?utf-8?B?QjNlOWVMWjQwU1lITXlhYTNpOFVwdjh1Tk41RWFGQWJSVGZjMzhHcUd3TGpF?=
 =?utf-8?B?RmhNVXM5akN5a2FCeHBVdTFTOUNWNjlUd0VrakVLWklmblFoc2Jlcnh5NXVQ?=
 =?utf-8?B?WUIyTlNvT1hoSTdzZDAxd2VQelREK2s3bnk3ZzUxbjRscWpldmNJMVBtam5t?=
 =?utf-8?B?Y0Z5dnRjeVlNWHBHY3ljNS94bW5ma1Zicy9FNDhYSllZT0RzSG53QmVlYXBG?=
 =?utf-8?B?Mk0yVVhZZmF1ZWNpMDE1TVFaRWJvcnBVT0Irb3JYVWQrQU1NLzB2M056NmpJ?=
 =?utf-8?B?ampveHF6RnRiY0x0bmxleUx2OW0wVkFCelBzNzBKdUk5VWJHNzdzbUZkSXRV?=
 =?utf-8?B?YnVHQWtTSE8zN2dkeVZJK2FodVplSC9CbUpYMGNlVjVkajczcmFIWnlRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8081
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	931615dc-6203-4304-d1f9-08dced17a5c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTh2ZnZuN29XZDB4djlST1JXSXE1Z3hqZEpqSzJmVS81Y0NQMXFoTlFJT2pX?=
 =?utf-8?B?MTlDMTdMVzV1ZHBaZXRMTzFvei9saHY5Um1ZbjVwbVdaZUpFanoxUDhlUFBh?=
 =?utf-8?B?NGFvYlRRaDRWSUlVallzeDBLbjRUOTZHMy9LU0p4YXQyLzZtQnB0NGVTMHRH?=
 =?utf-8?B?UHNqYk01L3NqWGl3T3ZOOG5UVUtNWG9JNlhMemVHd282L1Y1WE1WQVgydWdF?=
 =?utf-8?B?OForczkySXQ3NCtHUkxCdURMY3d3WVNibW5RNUFkbUp4Q1dIanp3UFUwdEt3?=
 =?utf-8?B?SzN0RzkyTVMvWlIrdzVtS3Fzcjhqbi8rYjJwQm1TR1l5aFVnNUpPQld6Z0tw?=
 =?utf-8?B?dkZIcmROQ0NlOUlmMUFvdXd0MGdBOWpDYUQ5QVhyNkYxMHpvdFRNWUpKdTJ3?=
 =?utf-8?B?b24vY0gvL1hNdW45MVBYbDVVVlpDMWI3Vm9IanhXcHc4R0QvK1ZRcFlKUHlG?=
 =?utf-8?B?SVY2bGoyVjAwMmd5azFPN2pId0p1azdpeWozTEd0YVh4TmRBdXo1amR6blA5?=
 =?utf-8?B?dzd6dk9xWnAzM3VOQ3YwQUtlOUdlMVdjNmtUa2JTSDB4MThBMGNnWUprajgy?=
 =?utf-8?B?RzBjQUNLOGZLTnVGblVhR3N4d2hHb2JGa24rQ0NQZTVwQ216UkVpem5wWEdi?=
 =?utf-8?B?cEJENG5kVHgvR1k5RjA0cHUrVXdmczAwMDFKN0hwL3gzMEZxVDFwR0M4andE?=
 =?utf-8?B?a0tiQUpuelc1b2hsaE1LQUNGeXpwcjczamdIN3p4UHh0Sjl1T0x6RXlkUnBL?=
 =?utf-8?B?WjE0OWt4akVFeWZEelo2S1FrRkRwSXdXem1uMGdVKzZxQkJ1RFdTVTRSQU5U?=
 =?utf-8?B?enRiNE9CZGpFcWhyMG00OVREQ0VQLzY1THV0Qk9YcDlWOHpQYUhuNUpweTdG?=
 =?utf-8?B?bnNGTE9PdkF6ZVVZeGNCalVtTCtDN2dGbm9pZmJ3anVyLytRZUV5eWUvdzFT?=
 =?utf-8?B?YVI2VkRHS0liTE9hQVJLMmJDSldqdThxY0pERll3K01EL3BHZXFDYnlOOVJ2?=
 =?utf-8?B?cml4alp2QkVDM3dMc3NmNU02TTlXcmlqc3U3OTNFSUxBMUxuNW8rc1JWY2VH?=
 =?utf-8?B?U21FYjhDWWRLcm5hM3NEcGF3Tm5scHhScmxuNmRrU2N2dG1aSUpJT3RpTWhq?=
 =?utf-8?B?NEtSMkV6dUlvYnZsZm0xMjFXbDU5clp0Q2E5azJFZ3BpUzJCejZyNTdWQTIw?=
 =?utf-8?B?YU1WN28raW5hTisySC9GN3lKZndweC9DTEl5L2tFck9VTjNqTmkwYnJYRXNS?=
 =?utf-8?B?NjZTblc5cTVjaWM4T2RLK2tXUjFGVFM3ZGkvU05sS0JkbFlIMk9HUWkzcnc3?=
 =?utf-8?B?UVlMYnFMQXJkcXIvblo3RTlTeUxlMWZZNmFFYklLZTR6OU1Fc2Y5L1pBN1Y4?=
 =?utf-8?B?bGxFdGxVRmNienNaa2I5bmdCbTlVT1ZhNUh0Ump1Z3ZSMWtSa0ROeWh5MW9p?=
 =?utf-8?B?UWh3TXp5U1RibkNrb3ZGa2RmYStUMnJYOUZCM3kwVDBmc0RRcVNLVXQ3Mytn?=
 =?utf-8?B?b1hPenJqVDNTWVF6NFpRYkRyR2g1dWp0WjZjQzhwS2RqeTk2ZmlOdlRGSmRa?=
 =?utf-8?B?eEw1RlBhMVc5L2gwSnRNL1JsbW1NcFhIYndhWXBCODQ4V2dVQTBXNlpXcU5W?=
 =?utf-8?B?VzNYWjZzTUF4QzFET2VKVjd5anZ0ek1pYlFTaUF3VGY2czh2NENQZWJqTU1h?=
 =?utf-8?B?TSs0RzkzQS9XRERhSzVrSFhJVXhqNkNOUUx1eU1DTkdmeUJhQ2JueG9GQ3h0?=
 =?utf-8?B?Q3BqdzZNYWUza1VoNE1sWXRiY0pqbjJIWmMvaWdhcFhUUGNQQ3BQUndMOHpt?=
 =?utf-8?B?Q1cyL3VvSjZ2Tys4allUYU81ZEV4TGE1OUlieDN2NGQvdTNORkNMYjUza2xR?=
 =?utf-8?Q?IWNsztCHnSdu8?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 12:48:41.9107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 902165ff-13d4-4784-bccc-08dced17b2d1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6011

Hi Steven

On 04/10/2024 16:27, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call).

The patch looks good to me. It may be a good idea to mention the strict
ordering of REC creation (i.e., in the ascending order of the mpidr)
mandated by the RMM and how we leave it to the VMM to do it in order.


Suzuki



> 
> See Realm Management Monitor specification (DEN0137) for more information:
> https://developer.arm.com/documentation/den0137/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   2 +
>   arch/arm64/include/asm/kvm_host.h    |   3 +
>   arch/arm64/include/asm/kvm_rme.h     |  18 ++++
>   arch/arm64/kvm/arm.c                 |   2 +
>   arch/arm64/kvm/reset.c               |  11 ++
>   arch/arm64/kvm/rme.c                 | 155 +++++++++++++++++++++++++++
>   6 files changed, 191 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5edcfb1b6c68..7430c77574e3 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -712,6 +712,8 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return vcpu->arch.rec.mpidr != INVALID_HWID;
>   	return false;
>   }
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7a77eed52c7d..122954187424 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -773,6 +773,9 @@ struct kvm_vcpu_arch {
>   
>   	/* Per-vcpu CCSIDR override or NULL */
>   	u32 *ccsidr;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>   };
>   
>   /*
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index e5704859a6e5..3a3aaf5d591c 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,7 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <asm/rmi_smc.h>
>   #include <uapi/linux/kvm.h>
>   
>   /**
> @@ -70,6 +71,21 @@ struct realm {
>   	unsigned int ia_bits;
>   };
>   
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> +	struct rec_run *run;
> +};
> +
>   void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   
> @@ -77,6 +93,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +int kvm_create_rec(struct kvm_vcpu *vcpu);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
>   #define RME_RTT_BLOCK_LEVEL	2
>   #define RME_RTT_MAX_LEVEL	3
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d16ba8d8bc44..87aa3f07fae2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -526,6 +526,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	/* Force users to call KVM_ARM_VCPU_INIT */
>   	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>   	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	/* Set up the timer */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b0ae5ae7bc2..845b1ece47d4 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -137,6 +137,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>   			return -EPERM;
>   
>   		return kvm_vcpu_finalize_sve(vcpu);
> +	case KVM_ARM_VCPU_REC:
> +		if (!kvm_is_realm(vcpu->kvm))
> +			return -EINVAL;
> +
> +		return kvm_create_rec(vcpu);
>   	}
>   
>   	return -EINVAL;
> @@ -147,6 +152,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>   	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return false;
>   
> +	if (kvm_is_realm(vcpu->kvm) &&
> +	    !(vcpu_is_rec(vcpu) &&
> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
> +		return false;
> +
>   	return true;
>   }
>   
> @@ -159,6 +169,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>   	kfree(sve_state);
>   	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>   }
>   
>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 7db405d2b2b2..6f0ced6e0cc1 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -422,6 +422,161 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		phys_addr_t aux_page_phys = page_to_phys(aux_pages[i]);
> +
> +		/* If the undelegate fails then leak the page */
> +		if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
> +			continue;
> +
> +		__free_page(aux_pages[i]);
> +	}
> +}
> +
> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	int ret;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page;
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (rmi_granule_delegate(aux_page_phys)) {
> +			__free_page(aux_page);
> +			ret = -ENXIO;
> +			goto out_err;
> +		}
> +		aux_pages[i] = aux_page;
> +		aux_phys_pages[i] = aux_page_phys;
> +	}
> +
> +	return 0;
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +
> +int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +	struct rec_params *params;
> +	int r, i;
> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
> +		return -ENOENT;
> +
> +	/*
> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
> +	 * flag covers v0.2 and onwards.
> +	 */
> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
> +
> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (!params || !rec->rec_page || !rec->run) {
> +		r = -ENOMEM;
> +		goto out_free_pages;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
> +		params->gprs[i] = vcpu_regs->regs[i];
> +
> +	params->pc = vcpu_regs->pc;
> +
> +	if (vcpu->vcpu_id == 0)
> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	if (rmi_granule_delegate(rec_page_phys)) {
> +		r = -ENXIO;
> +		goto out_free_pages;
> +	}
> +
> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;
> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}
> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	free_page((unsigned long)rec->run);
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	/*
> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
> +	 * pages will be leaked.
> +	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +
> +	/* If the undelegate fails then leak the REC page */
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		return;
> +
> +	free_page((unsigned long)rec->rec_page);
> +}
> +
>   int kvm_init_realm_vm(struct kvm *kvm)
>   {
>   	struct realm_params *params;


