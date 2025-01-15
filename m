Return-Path: <kvm+bounces-35499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24DA0A117F3
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 04:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3893C167C5E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D822F155333;
	Wed, 15 Jan 2025 03:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="awMP1rh4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCB84C98
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736912410; cv=fail; b=s7hbI5nj+Sj6pqSNULLE1sWi5QOk2HNPaabcgcV6AbDdB9EvWrr+MwPdXRgvJoWqk33nwMBhfvEI0mX77mPMIOl49HSSNDKqiz/RzfYNye/lZ463cwd1qiQQWkI5oPSXm6dAq/VqPowhCYvjeuxFPw2eNINT1uIa7IauSYLkFYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736912410; c=relaxed/simple;
	bh=YPmubDgaa8BKbor5Dfmsw8Sxf+7Kr00d1juiGvezAco=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cZBDoGUryq8AusSkm06QmqycAwENp8cCCQVFuEh+5ATo2xppdw8ikgielm7fJLWfTKoq871A6vl2MUb+YSeOqjPafACs/49c5PcFQB4dgrKTodhVvyoqY19yn67EPAaqtEZNSug4MPJfgQVtlHMdfUW8HXpBkO//wDN55bmdwZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=awMP1rh4; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOug8f9YSxgU78mhFGYghIbkGmmOoqVJdoby754q6mNyVEqjSyGl+nzh3VznPZuLGvprY/0G4BnWxFbceNzpLFAAMT152zIc8UqPkJJrUFu2xqe1v0HSN6mtdHHs5ihzUjP6h6y9HyDBWPegG+hBodzfTuxSzxcvrD3rzKt5IxAnIFOs7KjV6+Q0VCtgI/gd/j4qkEFav4epsyEnCE28OF5a2TkwfFtFzVuK6g8hVsAIG6N0SNY8yDyBIXlUPuw3kqkDfhLMefTexO2xr+yURgv+RYv7gGlDOLMxliRVyPtf6AB7D6EZMBwHkCh9airW4kK/PomYrcryzkRqqiKn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSHjjRdQ17/qs24cYlk+rteK9S0b203ZENtdk0PRwog=;
 b=ixWzQwquqDVxtah1M67hZOfdh0ZxFdJZRtJoRtxExVq6RdMA/dDfg5+DXAE/LsujQHkTNBeBd8odAGKQTlLnC07Zkl5LJ950kSvywI3vLnPTRVRQCnn48OFahml9RR80839qEamCmvFtFlV8TBujYKgVpE5PiBKtUGX6PhtMK11TMiXsSd0YDwq1Ksl3VPXNNbLyrhEck6A3OkBUemsZUJ/vNRMktiLH2FbaY6N0/QD6b0RoGYeiWWLdgvRcnnvjtaqdToNubNj4zi3GLf2YBgtuA+web9dZSE68Ut9uAzeIyuBRPR4LgSeFP5SDjJ+yZaSyUnsnqU+ECoB1KfXDrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSHjjRdQ17/qs24cYlk+rteK9S0b203ZENtdk0PRwog=;
 b=awMP1rh4h3t78c3aM4CyukRxTVz5AORvf9ODtBYUFm5XFJHn+TWDuj210+G1Dn4EmjYuokLVP74KrswFMtIKcEpixDAEEvMet3XxXe3cg1mcYjPV2CwIEfcLKrxsqkcjDEDXansgRcCpICEga1PKbjoRooHSEUF/QeERVtpKU0U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4487.namprd12.prod.outlook.com (2603:10b6:208:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 03:40:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 03:40:05 +0000
Message-ID: <9d925eaa-ba32-41f4-8845-448d26cef4c7@amd.com>
Date: Wed, 15 Jan 2025 14:39:55 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 0/7] Enable shared device assignment
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
 <20250110132021.GE5556@nvidia.com>
 <17db435a-8eca-4132-8481-34a6b0e986cb@redhat.com>
 <20250110141401.GG5556@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250110141401.GG5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OS7PR01CA0187.jpnprd01.prod.outlook.com
 (2603:1096:604:250::17) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c998ed-d8be-47e8-a6b4-08dd35164d01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXNKdGxLbXpUVjBpQjh5RnFKR2JpWnZseFUxeVdRVEVYTFNHdk4xSlh6U1Fw?=
 =?utf-8?B?Z2FyNlZGZkJ3bVllMk5kVGFndCtONStVNm15MW1vOVBaL3RKR0F6RXBQam1y?=
 =?utf-8?B?Nk0ydExYOVBMdUk0NTQ1VXp5OGNKQnJnMkFRVXAvVHpBU1A5VWJqQjlCRkVk?=
 =?utf-8?B?T05PVHcyb1h6Tng5dEVqcUJwbDdXck5aaDVrQWMvK1QwaWZrSlkxL05UaWk5?=
 =?utf-8?B?M1Q3V2FlY3lzSGJPWDVndkp6aHlVYXdRaENHZ3VKTXU4YkRSY0tjR2g5bHhB?=
 =?utf-8?B?NS9oZExUbzlkQytQMVNhT3ZXQlZoOE5YV1NGV3pxQUI3K041R1F2STdMUUJD?=
 =?utf-8?B?Ti9GQUdIRm4zQ3VjdUh5dkRCd1dsYitWSzgwNDB6NURoQlUyTkV6dkI0WVZM?=
 =?utf-8?B?eEFsMzJ2T3B2SVc1MTdUYnJMb09jaFE3d0VjV1hvbXc5eGIyd1p4YWVBVzJk?=
 =?utf-8?B?SDNYaE51aWdKaHg3NjJkNXlWMjhvVW1lbHBlRHovUHdDRXpYVHYxNzB0VGE0?=
 =?utf-8?B?TVpZaVJub2h0YXZQMmdZbjNvUjJHcUczR1p6NUpjcXVQbWhTdUdLZGxCN2Jx?=
 =?utf-8?B?N3MxZFF2cFg2QkloRjVnMGF3NzJSZWM5QnEzeU10U0VGZTFYYW5jcXNtV3Nr?=
 =?utf-8?B?UFBVMjJ0Rk9VazZncG1CSHBMS0kwZERNWmZqcWhzd09BOThmU0FSTjg3UURK?=
 =?utf-8?B?Rmp5b01pTzIxK2V1M000Q2hiQjV2SVNrUHBsQlhNbW84Q2hKR0FkRjJPelRr?=
 =?utf-8?B?VWZoTWJZd1M3ckFLQXRQbkxDb2J6NDJVUW93UitYT0lRcVJpRDI5WEpZWFQy?=
 =?utf-8?B?bmtablZ1UjY1SlpsYllRaWJSdUUxRTFhOGdEMjllNm1JMS9aMTdza0JMK1JV?=
 =?utf-8?B?U0E5bnFtWW5iZFQvUE52eCs1eGh6Y2xlY09lT2pKaktkeHhhSWtXYUNpMWNL?=
 =?utf-8?B?Q2w4V0lSbGFubzJMRkVmQVd0aXIxUU5SMDR2UTNyZzdxS3o5dWJzYVA4WlFk?=
 =?utf-8?B?MDkwcTQwbTdjWENmblRlcGxGOFFjdjBXRkorZTUxKzZ0M2ExUkpFNlVIYTl3?=
 =?utf-8?B?aTBITzNhMTNURDdYeE0xWGM3czhRV3AyYUhhT1hnZU5oRjdqRnEwS1VWTWti?=
 =?utf-8?B?c2pBemFLekxQdWtLbW05QXJJMDl1QmkyTXhhcXRjZ2JLSUREN0NIZldnc1Fr?=
 =?utf-8?B?cmY5YmVBQjFIOHJaWmFKa1BhaEdNTmg1NXcvLy82a1A0QXF0RGlQbG1ncHpK?=
 =?utf-8?B?NUZ4S1l6aVV1TEpld2xPTUJ5dm54dnRpSEhOdHhKOC9HVGt3ZmpQd1VycDJo?=
 =?utf-8?B?Tm9GSlNXYVBwOEQyY2E3NGJPNWNWYmtKZHYvdkpmMUtZSnpWVFZwdG5WVDdT?=
 =?utf-8?B?RitUcERkNzdpU3crTDFLa1V5WVY1bHJoaWNXSTU1bnBaUEVEM09rSVh2Ny9T?=
 =?utf-8?B?M2h1amlGSW9CeUF1dk9UTUFmbEtqSEJaRWo3aUNIU2tSdWpDMUdPaTN1TGpU?=
 =?utf-8?B?QlhWb3crU0VHbkhRL01RaE1GMHJiNFdTaXY5SFdTTFFBcXF1N2Y0MUo2d3A0?=
 =?utf-8?B?UzlKWVNhYnl4VmYzMFdrREZWRW9GNkNnQ0xmL0J6bzRmZXZWbTNkN21uek92?=
 =?utf-8?B?eHhqS3BJV1o0eTNlOG5YeUd2SU90ZEY5bkNmNjFtd1NIc1F2UEpKWE52TEs2?=
 =?utf-8?B?cDc0STlGRVozUEdTWWRMSXQ0c2dTTldyKzlkbGZIaEZBTDBLNEVsdEN0alNG?=
 =?utf-8?B?UUMxTS80MzZteDZXek9oc0tEdHFmbGt6QklNMFJMSlNEWWRqUlNwSjFZQ0Mz?=
 =?utf-8?B?Yk85Nll0ditVM3dRQTJPSldwc3BNWkhTVi9aYjlmKzZaRGttbTJ2Y0pmcTds?=
 =?utf-8?Q?GOH+FJtJpighI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnROL2V1S0FqNkoxYTVUZ2dmaG9raFpFTEJwd0tQVk1FTVc2VmI1K04vOHAx?=
 =?utf-8?B?cDFKcDcwL2lUR3pnaEprWGNOU3N1VDVZd0dlZEZId1BKcEM1aXVOK0NSUnpy?=
 =?utf-8?B?d3U4c212Y1RMME5MSTlVYlJBVVpNMFlZZEsydldDMGNCRnh4T0pmRE03cFd3?=
 =?utf-8?B?cUhpckhMRCtPL3hobllOQ3NMT29tVXdoWm5pREp2NnQzd0VjT2NBV1ZFVzNt?=
 =?utf-8?B?dDJNT1pvTlVrNkd2eExsVW4xNk9qc24wWU9QVDdKdTFSNW5xdFhrdUl4WlJk?=
 =?utf-8?B?akorb04ycC82ZzFJbFBwaUNmZmdRbkg2UERmQnJKdVg1Tk1GQjQwNURKMzB3?=
 =?utf-8?B?OGhQYytMbUlNWXF3cHBDdEN2akh2YWM5TEZoRmovd2JrczdtWUpLMEI0UE5U?=
 =?utf-8?B?NmVZMjBsWnZXbkFRQ2ZIbXpxcXZHSkUzQzdCd0pvSWpLa1k2VHkycGQvaXBS?=
 =?utf-8?B?NWYyZjZhRDZneElQWmNnNW9GTXdjcERKcytFNHE5amlvbllxUEl6ZURHd3NR?=
 =?utf-8?B?a0xZT0VIZU5qUUtFbTVEdHhzT0p6N1JUdUV6OHB1amlhY081SlZES0t4RkZi?=
 =?utf-8?B?UWg3LytvK2xpaVhWZTFNd1dqdzF5QnlaWCtudkdKWnluQXdZNkpGTm5CUDBx?=
 =?utf-8?B?eEdnbk5FN2hpNTRkZUxLUGRmTHNRN0JhaWFCckNtS3FIN2d2eWxHbk1wM1dQ?=
 =?utf-8?B?VWhRM3VqOUdJblFLSEJhL253YW84Y0Z3cEhXN3Z3UCtxclJoS29sam56YzE1?=
 =?utf-8?B?aGZZZm1nZncrbW1Pa1BBeUgzUExTWXZCVEQrZVcwUUZoRStGalZsUFJwQTZD?=
 =?utf-8?B?RUtvVW5Za2F5bGpVNHMxand6bHRKOUZFdXlyeUpKdG1FRklRZUpYeGtBYytZ?=
 =?utf-8?B?Z0Z2aEtjYy8yalhSeis5NzJOTlF2N1daelZqcTZ4dm5FS1BOM0Q3QU5mZU0w?=
 =?utf-8?B?NE1LNmtHSHQvc1JieWI2UjZFUHlhTENEekJwNktCQlBGc254NFpCbjhKWUZI?=
 =?utf-8?B?WXJZaGNDRjlqTENwQlJiakErMS9JMmVubVNzZnNRYkdSQ211dFc2N3VFcG11?=
 =?utf-8?B?U0xrdklMM0NZZGk5YlhSS0cyQkIyN0pFYThnSDA4aGZJOSsrbU5qbDBPQ1FH?=
 =?utf-8?B?VEd1Y3lyNi9xWEdWWVdaeHV2UnNLSENYR1hwdm4zdzVlc29GYmdpcWxRLzdM?=
 =?utf-8?B?TUxNZDRDb3ZQVzV1Y042VVJnbWh0MU1lbUhlTzY0aU5GbkNKS01CN3AyWXJi?=
 =?utf-8?B?QWtXT3c1TXFqbEYvbEdQY0lVakxsdDBtdklYRFc4czJzZThpaDI2LzNRRk0w?=
 =?utf-8?B?MGJYcER3R29HRVlyNGhBS2llV3ZTaWhaeGR3NHI5a3QvLzdNTCtWaXFIYVlE?=
 =?utf-8?B?eUZMSE9kaUxZOHNFOEMydGdyY3F6K0FZZEJ3dUhpUmxtWkhSeS9KVW1tTENX?=
 =?utf-8?B?anUzS044ZXVNMzR1M05uRTZwaGMxNkFVYTdvN2xxNHNlbUpSdGw1d1ZuNVpV?=
 =?utf-8?B?MjR0b0lGUjJBd2VKWjkxZ1lXTGFhcThxOUg1Sm9TdVJYRDA5cXkwNEhFZVdR?=
 =?utf-8?B?S1p5ckxCbENYT0pTNlIzUGxTU2NoNmlKQXo4ZVdHNzFTZGVnbnJhc29wYWh5?=
 =?utf-8?B?MVRWWkZpaGJRczZpS1lMNU1DUk4zVEhIN2Fuc3BhMHJmMGF4cmlndFJQRzU2?=
 =?utf-8?B?UFhpWlFZNHZKSVpEK1lvOHpCOGlEczNobmd4Y0x1d3Z3QmpFUlIxYW5TYlRM?=
 =?utf-8?B?S3ZZRnRlMGtwQTFwcjJqclA5UUhUSWNqM1h2SFU5Z1A4TWU0ZGNRQ29JQVpX?=
 =?utf-8?B?bzZpWjVkbnZIdzJGdkFqeXZlUys2S2h1aE4zbnVjQStXZWVoR2RFdi9yaW91?=
 =?utf-8?B?RFVZMEkxU1JRaDIzQWptalNzMkcwanF2bTRtdStRRDM1ZWZkekhXRzFSTDE1?=
 =?utf-8?B?UGZwS2QrRXA0QjZQRjFEQjBXNk5uMVU1K1BOWmx6bkVZZnd4TkYzZFZGcUxV?=
 =?utf-8?B?TkxFRFBSMGI2cGQvSGswWmhDejFNU1NHSkJHUmp1ZXQ3YWpwT3hKelNSWVB5?=
 =?utf-8?B?NDdrcEhaZ2t3cEszTUtyTmlkNHNzVHA1aVkrQ3M0NDJDTnVNR1hqSmpPeURv?=
 =?utf-8?Q?DHel4Sp7vIUyV/6PAxTK7oQzY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c998ed-d8be-47e8-a6b4-08dd35164d01
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 03:40:05.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2ZtRonDPJqnKqG6M2k21rCnDdM6KjUjkj/PuxyQBKVk5ISyW8wJaxOScC4QDIiJQz4q0Tnz4fNRN9uleV9YDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4487

On 11/1/25 01:14, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2025 at 02:45:39PM +0100, David Hildenbrand wrote:
>>
>> In your commit I read:
>>
>> "Implement the cut operation to be hitless, changes to the page table
>> during cutting must cause zero disruption to any ongoing DMA. This is the
>> expectation of the VFIO type 1 uAPI. Hitless requires HW support, it is
>> incompatible with HW requiring break-before-make."
>>
>> So I guess that would mean that, depending on HW support, one could avoid
>> disabling large pages to still allow for atomic cuts / partial unmaps that
>> don't affect concurrent DMA.
> 
> Yes. Most x86 server HW will do this, though ARM support is a bit newish.
> 
>> What would be your suggestion here to avoid the "map each 4k page
>> individually so we can unmap it individually" ? I didn't completely grasp
>> that, sorry.
> 
> Map in large ranges in the VMM, lets say 1G of shared memory as a
> single mapping (called an iommufd area)
> 
> When the guest makes a 2M chunk of it private you do a ioctl to
> iommufd to split the area into three, leaving the 2M chunk as a
> seperate area.
> 
> The new iommufd ioctl to split areas will go down into the iommu driver
> and atomically cut the 1G PTEs into smaller PTEs as necessary so that
> no PTE spans the edges of the 2M area.
> 
> Then userspace can unmap the 2M area and leave the remainder of the 1G
> area mapped.
> 
> All of this would be fully hitless to ongoing DMA.
> 
> The iommufs code is there to do this assuming the areas are mapped at
> 4k, what is missing is the iommu driver side to atomically resize
> large PTEs.
> 
>>  From "IIRC you can only trigger split using the VFIO type 1 legacy API. We
>> would need to formalize split as an IOMMUFD native ioctl.
>> Nobody should use this stuf through the legacy type 1 API!!!!"
>>
>> I assume you mean that we can only avoid the 4k map/unmap if we add proper
>> support to IOMMUFD native ioctl, and not try making it fly somehow with the
>> legacy type 1 API?
> 
> The thread was talking about the built-in support in iommufd to split
> mappings. 

Just to clarify - I am talking about splitting only "iommufd areas", not 
large pages. If all IOMMU PTEs are 4k and areas are bigger than 4K => 
the hw support is not needed to allow splitting. The comments above and 
below seem to confuse large pages with large areas (well, I am consufed, 
at least).


> That built-in support is only accessible through legacy APIs
> and should never be used in new qemu code. To use that built in
> support in new code we need to build new APIs.

Why would not IOMMU_IOAS_MAP/UNMAP uAPI work? Thanks,

> The advantage of the
> built-in support is qemu can map in large regions (which is more
> efficient) and the kernel will break it down to 4k for the iommu
> driver.
> Mapping 4k at a time through the uAPI would be outrageously
> inefficient.

> 
> Jason
> 

-- 
Alexey


