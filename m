Return-Path: <kvm+bounces-28980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A3F9A058F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 11:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D1AF1F23293
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 09:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E15205E24;
	Wed, 16 Oct 2024 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vp4SKZRr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vp4SKZRr"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2083.outbound.protection.outlook.com [40.107.241.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D71FDF81
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.83
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729071088; cv=fail; b=I/xTrSOraUZ7dGou9sn1Sw523PdYjxY5estUC9KrYLVSPJ5pWp8OK03KvRP10UM2D4+pGWMVhAHz78hPYrvzzzp5/m6Dj/6mkfRoiYzVSeV0VnVRW9OJfdrxcYYJIj8tDkqLKe5qT3ajGA0PeFP72cAwXf6kZsYea6vxP2nX2L8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729071088; c=relaxed/simple;
	bh=datKsOwxQjVawagrp5eONgffrQmJXX/LNMdL2CG7IM8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NVo30hSgBXiEH8j2RmPuQL8a5N1k4REk7vK3+zRZJ3H0Y3vR8q6Pf4/xFKp41BXsh/PY+nCZQmPJYWJ4yNFl7SiMscZimpc0qfSNWQgFfFOHCFJhMh+vCXGkQESPRS1xTgWrypMmHy5liwZfvXPdDV09GGRgeJ7XstzKL2nM6v4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vp4SKZRr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vp4SKZRr; arc=fail smtp.client-ip=40.107.241.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vHthJk8sTCthEAsNBIq3Ka+rLMuzuymO/+uCPAV7ouwdi1Ewf+SaYZ9bgiWfB1/iwrUJnQwyYvMGsHiLXnCoZMRMBhbnue2HvBeu4UxvDozAxQW5XUe8vTh++YV+It3aOuW0a9r2nnA45+EOw1OzXEo6VrXqdXqLNgvyRmRFBIzpbXTQLdVKuhHtwjsQdqpmVkPPJ2Wqs/K01hq0gKACK+G83JvHM/f3607zJSWJZ5i338O0aP75Kf/gJX4amJSOm3UcIuo6ibSEeqhy88RFGgADAWx6PJELwGhJFq0Nm5avoklmkmp+MO5QO3i6BbKsTjnzI3NUWJN+DnTKlSNh4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6Szv2xoOEddn+RwV6HQCMYxAK9q9tLZ7Vnx2dz/ASA=;
 b=n3f+IXEuuMpOaLOH/OUwHyhpIASFZwZkSbJxVKXHOT2aLx1jLU1sXwqTWM9g6ipRyGz3dj3xvclW/+ET0NEuCq3seQiD65HT6Xm1G7G0VIuApRw/C/o7p5XPk0K93YsNdYIGUdHeaWGhqcqrkVTQt7QJsEwjaqiXOi46AMZYFfWCwXlaxslxhZWV/xzeKfgA9oqejGLTITZE5siIgtBt/MjxN7ZRkLuc/AKd1hpA6C5itORPFIZCw5A5oFq04r8MDSNpyNF14OikBI8Skn6uyO5nkFKBgQiJ/LHnZ9HPlzCDaypLhOs6yVb19QTHDIaIx3TWoV8w8DACpRt3vVq6wA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6Szv2xoOEddn+RwV6HQCMYxAK9q9tLZ7Vnx2dz/ASA=;
 b=Vp4SKZRr0OLsFbSGaTtkCQncNcEuiTNn57mY+BbRGe/kG/NiQOHM+tCTORDS5fT5IqClYF4yfH9rx4Akb2yEMEYR6vYVWOAStMFmcb6afSfub9kpxvlifwM7IEBJ9Kl7bY2L3+FmOqM4m60QqS+cNLlbsBdS+zF2sjWudxdBQIw=
Received: from DBBPR09CA0007.eurprd09.prod.outlook.com (2603:10a6:10:c0::19)
 by DU4PR08MB10911.eurprd08.prod.outlook.com (2603:10a6:10:571::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 09:31:18 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:c0:cafe::c4) by DBBPR09CA0007.outlook.office365.com
 (2603:10a6:10:c0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 09:31:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 09:31:17 +0000
Received: ("Tessian outbound 5c9bb61b4476:v473"); Wed, 16 Oct 2024 09:31:17 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: a7d3f10eb382dabf
X-TessianGatewayMetadata: 3/rWgQ8bnKOFO3n7mQOXwpR7myjpqhPSITauvoq7f/cWCkl/0X71Iwfo86nk4Kp5dPye+uZX/+QSnAJcDVVXdkdBtaaue/TZbjrZxLGL4cWb2yKiAYDP5ldXB8uVcDYrSN8ClxQqo00L+dUbfcSweDky7qUSVycBJxvqBHTkUzU=
X-CR-MTA-TID: 64aa7808
Received: from L8fff0ac55deb.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2F8444A7-25E2-4351-B9C3-BFBC602439A6.1;
	Wed, 16 Oct 2024 09:31:11 +0000
Received: from EUR02-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L8fff0ac55deb.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2024 09:31:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjwmnddTB/MtGKmHcFFb6/Qvduhu40QX55uhxd2z1FVb8H9ngiWv0gEwmb5J0TXa7wvsSFVBoUZeFb3Po/Be2r42d55I9SiORlsgWOuDDXcF9kinyfvhAN9hHdbIlcZ+Xx8e3Eyi5bdwBPzwHPcgOlu+qeXEwN01JgcDZ9lhbp66b8RZDqWxdmwngv/FFk5XW3eKTkFRabA81LvFJj0zzAf5k7U2ZFGmDaOR9LdqHFYBTb4P+7MalJvj3EM6G5r0jp6chtsTJp5Ivvx44cKDXkseqvFrsPS7oGQbf/jLvAq4L1+MgrZgyctocFE9Uc4WjXogIu8gkGmMN3xX4Dzl4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6Szv2xoOEddn+RwV6HQCMYxAK9q9tLZ7Vnx2dz/ASA=;
 b=cnoH1/LRrSS/veqQDyfJYhDcHn11mbrTVSXxXJJDDzJnPQ4eLOkkePxWq6MeuAxBNkHRs8aSyp13b21bxhgJrMMfKEwjBPIHpDS56Ux9ZpBk2wlji5FfwwNb6UQ2KCYIRQe1pAri7znOcJ0c4o1dy0PiV+N3HkAlloZoAT5Rb2rvrsWCoJ+yLjOVtaniaV3dBcSMU5Toc8TwXHRjzgtuNv+WZc9B6ZsSLj+RT9b9S9LWX8SbuB8EY8Cww9askKXT6EQBylelludAmuu5GiePvXDNkD2bL6d/es9GruGlqs0lRiJhcT571rTu2Fx1zkd9RKgZHWHwZdLNyS8i6HrcTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6Szv2xoOEddn+RwV6HQCMYxAK9q9tLZ7Vnx2dz/ASA=;
 b=Vp4SKZRr0OLsFbSGaTtkCQncNcEuiTNn57mY+BbRGe/kG/NiQOHM+tCTORDS5fT5IqClYF4yfH9rx4Akb2yEMEYR6vYVWOAStMFmcb6afSfub9kpxvlifwM7IEBJ9Kl7bY2L3+FmOqM4m60QqS+cNLlbsBdS+zF2sjWudxdBQIw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by PAVPR08MB9860.eurprd08.prod.outlook.com (2603:10a6:102:2f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Wed, 16 Oct
 2024 09:31:07 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 09:31:07 +0000
Message-ID: <a56cae74-c5ba-4a83-b77e-2ab522ef3113@arm.com>
Date: Wed, 16 Oct 2024 10:31:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, linux-coco@lists.linux.dev,
 KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0356.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::19) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|PAVPR08MB9860:EE_|DB1PEPF000509ED:EE_|DU4PR08MB10911:EE_
X-MS-Office365-Filtering-Correlation-Id: 1335357b-9957-423b-e452-08dcedc54970
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|3613699012;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?N2lGdTM4cVQ3SFFnTGdJNGtXaWZERUNTUFNRaDRLUE8ycDBnQXZ5ajRodVNu?=
 =?utf-8?B?czFsS01hRldVZ1E5R0IvbmpxamVmTXVkWlF0MXIralBJUVlUd1g4M3B2azZG?=
 =?utf-8?B?T2pYVFgxTXBCVHV6dmlubUxkaHlOaE1DbHBNWlVaOW9rZUkvOGhFQkl0NjlH?=
 =?utf-8?B?Vk9TbjZzN0xwRCtuTnhQWlNUUlJ6c1hvUDJsMFFjRVM2blFSWGZ3VlQ5N2JL?=
 =?utf-8?B?YUN0TU1FNkE3MW9kMVAwcnZocEpMeXVUSGxpQlhSa0JNdTFqWHUrMTdnU0Qz?=
 =?utf-8?B?NDZZT2k5d1Fqd2hYcU5pc2dMZndSYnplaWtVZVNoTVJIRElLWjY5TFRGQlBO?=
 =?utf-8?B?WmRsNGRsUzhaMnh4dS9mNzh3aWoxMVpBcDdIVWc0MHpxc0FYVWxLUEZRSWVQ?=
 =?utf-8?B?Q1R6cmQzQ3pKUEJVU2xpdlRVNXdhRTVkSHZKS3FzZ29OYWY2WkFCL0kvU0Nk?=
 =?utf-8?B?aDVPU0dDd05Pd01hY3B1OHZ5MmlGWTVYTmZnWGQ4VWdqd1J6eSt2ZHZmTEIv?=
 =?utf-8?B?MUd2Y1BzdW4zWGFIdUxxNEM2L3Jibm5jUy8vVFlSOXRtbmV3ZlZ4bDBCYmV6?=
 =?utf-8?B?SHhacHlTWG1KZm53RGJ3Tm94OTgvUzdKNUtTTEpOZGszT1BvNzFXWDBwbFU4?=
 =?utf-8?B?VlF4VkRUb1RvZGtMVjV2Y3F4WFo5cmREVG9VTTRxTmJOdm13bG5vMG5rY0R6?=
 =?utf-8?B?Vnl2VGc5WXhhMWt3aXp4Ti9pWEo5d2Y1eFhReUtKQTFKN25IVUpYVmVQSUxj?=
 =?utf-8?B?S01LWGZKMURjeFNLaGpCNnUyVHdRbW9OWFlMdGVpL2ZoZmpoT3JZSzQ4OTF3?=
 =?utf-8?B?bFNqNVdBNG9BcTdzWE5ad1NNQ2JHUGRONkJEUWp5T1VKd3ZLTHN6UDFzU0FC?=
 =?utf-8?B?Nm9OelgxRzRVNVc4VUxXUDVjVlR2eTFORzlGbytMaDJUeFovVzNvTTJpbzRP?=
 =?utf-8?B?Ym9YNGppZ1hsS1hJRXpTbDc3bjRpaUdnR2F0eVk3bC9OZTRMM1dxekpnWVZw?=
 =?utf-8?B?Ryt5RTFjYXdsbHVaeUFDN01zSWJaUjNzVW94UDNuRlUrSlFTVVp5aU4yWXlU?=
 =?utf-8?B?eUdPWGtyU3BBVGFibGk3dXhuWjNmZUlmWlJBU0lsSnBCRmZEUVB0WDVCYzJI?=
 =?utf-8?B?dnNNb0VvaldXUWduR3B6QkdOM2lLaVYyb1FzM0RqOTJLYkdVaXlFUzF5Y1RQ?=
 =?utf-8?B?WVROaEt0b0RlVkQ4M2tTOHJiMmU4NU10WWtCVWJ2TnRmdUt6ZWt0cURaS0Fw?=
 =?utf-8?B?K1pvaHFPYS9STW1Wbnd3dTNGMFNta29qaWx4QldIeWhsSkV5TW9MUks0eGRH?=
 =?utf-8?B?Q1FEVW5QbllVTjhYcTA2OElTV3J1eERJYWdVMS8yWlhYTjR5ZVFNcmpieWx1?=
 =?utf-8?B?U3M3ZEpWTVVDQlE4VUpjSmlKQTNQaVFjdFRpd2NzVFgwbXBjb2o2MFl1bUwx?=
 =?utf-8?B?ZndBUm1lZU1tV1FVczZYbklSSG1ISjIvcE0wOUdJM1kweDZ2SkFQQTFDQlRl?=
 =?utf-8?B?aStQb3ArL1RzQlh0RGk4M0Q1SlBWejY2UzBXL01SV2p4SEY0TnZkWHg2anBm?=
 =?utf-8?B?eHlncmtibmFkY2pvbnpaNjdCR2d1b09nWjJpaDhPMmROVmFtVEV0aDV1WmhN?=
 =?utf-8?B?aUk2WDd6S1Zqc1dMcTFNUE93a0VObFNQZCs4dVNsS2k3anF0RFZubzZBVVZX?=
 =?utf-8?B?bUtzZ3JBNVpHSytLeUVQOXFRemJjcUxzL0ZMWklGQ2ZrcDRmNEFycHpWUVFG?=
 =?utf-8?B?S3YwM3NORUhPb3E0RWNKOGJ1VDA5M2tucSs0YW85cHJBK2EzYWUzQlppM0tz?=
 =?utf-8?B?ajR3MVJZeW9sV2JFZUxVQT09?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9860
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93daae88-e134-441e-4eb8-08dcedc54307
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|35042699022|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2lydkZMcGgwWGNHQWpzTHd0R0lLZUNQWHNGNUo3WnpZaGU0Y2NNNjFRWStk?=
 =?utf-8?B?ZzNiQzFnc04wMEJHaHFqQVhoWHVGNkhzVUFITnMxNzNzREYza21XK1hucmlD?=
 =?utf-8?B?d3pFQjZSN3U5YzRJbVIxRkZCeXR0bHFRTk9mYjVFQzFjSUtFbWxJcFZ4RnBa?=
 =?utf-8?B?bkI2TjR6THVKb1JXLzM3RW9qd0RjREljcXBVYkxRaldSb1c3ZWhxbEt3Q1lD?=
 =?utf-8?B?dDR1T2d2RVNHYmlQcDBUSzZETS90S2lRejJLWDVPajRmbzAwcXhJaE1ZNnVU?=
 =?utf-8?B?R3NYMEVOcmhNNWRvK0szSjlJcVRIT2xOWG1TL0tadU1IbWVIS0JpNjZQMnhC?=
 =?utf-8?B?VnhYL3c4UEFySFFEb0gxbUc5NHRkNHJyWFVsZXpoSlBxVi85M0V6MnJzN2J5?=
 =?utf-8?B?RkhzVVJBa2x5Z3pjQncrYkpTRmFoelpmK1hpektpT1ZEbmI4YjFWZ2RUSk1o?=
 =?utf-8?B?Snd2V2U2b2F4UEg1WGV0RXZTUGFtNGdLVWhtUlZMSElJMzlZT2xkYXpzSStJ?=
 =?utf-8?B?a0N4K0tlRXdyclowa0k5Vk9LTndleW1BOHVOTS9yUnVrY3lCdWNOZFhuRHdX?=
 =?utf-8?B?eDdzaGIwMGhGejRUbWY3QnNZcHFSRDNRbHM4SUQ3eHJ4aWRWVGhwOTJHSTRO?=
 =?utf-8?B?M0NNUnRRMVRUV2RvSkFKMW5GeGhZNzk0d3p6aGtnTG9UWGtULzJjWiszZ0R0?=
 =?utf-8?B?OUJTbFFlVURrdVo2ZVlZWWZBSFdDWE0wbzhiOWd4ZzZCQmR4YkpxR3F4ZVRM?=
 =?utf-8?B?YVVZVjAzVlVIK3I1VUdtdXh3a1JzbmlPWVZUcEpBZUF2ZDJGWm1YWlp5VGxp?=
 =?utf-8?B?RUN6d3hDTVJMeTFYamhjSVU2LzN6RStKMmJmekhGdUJiUm5BK3prTWFyc1FO?=
 =?utf-8?B?WlN3WGxiUTcrZ0VzU1hiSm9DN3U1QXNMUWNFTnZ4c2VIU25Lcmx6SkxSYlVy?=
 =?utf-8?B?YXE1NmFiT1VYR0dpaHZOaHE4akpucHJxWndQVnozMmN1VE5qL202b3Q4aXJr?=
 =?utf-8?B?U1A3VGVqZVNqZ0NRbW9KNkYwTnpTS0xGL3pQYUpoQWVMUGxCZ3UxaHg2eUVm?=
 =?utf-8?B?Q1B2QStocjdJT0JlUFgyeDhiQkRQN3VxRTBoS0ZQSUQvcnBUNkhmUCsvUlcy?=
 =?utf-8?B?aFJlVFI4Kzh6YmlRSHp5RlluTU5GUXgrZm05Z1BTeHA4UEIvWEt1UVk1UnRq?=
 =?utf-8?B?NmpzbEdXZ1NXd2RDMFVVaDkrcDloSUpiUG51T2NzTkdxaWJtbk94aXNXb1NO?=
 =?utf-8?B?UzY0U2Z6VFRnb1VrNkZJMXVxL21qbktyV3BSL2djRGtwK05YcVpOcHRIWU45?=
 =?utf-8?B?RW1FNEE1QllNK08zVWFEdXRkNk81eFpoV3o3OUppS2ZqRTlCYUhwaUFsQi9r?=
 =?utf-8?B?dmh2ejMzQ09IUlU0L1FwaDNMSXJWTk9zMDRtb0x4SmYxZmpXSFczMnhtd203?=
 =?utf-8?B?UjgwNTJyWjhia1E3NGhkalVucmI5OUVJT1F6eXd6OEhjQWhPT09YTUJTQlN2?=
 =?utf-8?B?TU9hUVVsQnVZZEE0SEFjekhPZFpDWmwyM2Q2bVk2b05hOCtkdkROS1pZWlpx?=
 =?utf-8?B?Wk1yQzlwOS9qdjJTekhYSkhxQ2hZY29nRlRHVElSamt0Qzl5Ymh5LytCRWgw?=
 =?utf-8?B?bkZCWW55c2k1a3IrRHZXeU9IUC9kd3gxQUVRQitHdFRhQWdPdlcvd0k5U2ZT?=
 =?utf-8?B?cVZBUzZlWDNPRTVkL09iWkNDRGpsN0dWQ09GTDJhTnVpQTVERm9WQ3RTcGo3?=
 =?utf-8?B?aTl0OHAyc054a0ZsdTFnL3RRUDRsRmdCdG1zTURZL1hxc091OHN2ZE1Yd0Zn?=
 =?utf-8?B?MDNjb2oxellPNE1wSzJ2VldsWXI4VjA3MHROaVcvdXJZV01qdm13VzdRd3Z2?=
 =?utf-8?Q?F483Bn8EXkzZr?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(35042699022)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 09:31:17.6243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1335357b-9957-423b-e452-08dcedc54970
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB10911

Hi David,


On 10/10/2024 14:39, David Hildenbrand wrote:
> Ahoihoi,
>
> while talking to a bunch of folks at LPC about guest_memfd, it was
> raised that there isn't really a place for people to discuss the
> development of guest_memfd on a regular basis.
>
> There is a KVM upstream call, but guest_memfd is on its way of not being
> guest_memfd specific ("library") and there is the bi-weekly MM alignment
> call, but we're not going to hijack that meeting completely + a lot of
> guest_memfd stuff doesn't need all the MM experts ;)
>
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
> development of guest_memfd, in particular:
>
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
>
> Topic-wise it's relatively clear: guest_memfd extensions were one of the
> hot topics at LPC ;)
>
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
> starting Thursday next week (2024-10-17).
>
> We would be using Google Meet.

Thanks for setting this up, please could you count me in ?


Suzuki

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

