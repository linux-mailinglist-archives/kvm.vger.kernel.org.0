Return-Path: <kvm+bounces-38551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB287A3B187
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 07:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1819A7A5D91
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 06:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A0E1BBBDD;
	Wed, 19 Feb 2025 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V7A1Sggs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35A24C6D;
	Wed, 19 Feb 2025 06:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945959; cv=fail; b=Dzt4ku/UoZzM3tVh3Ro0B9/lYwxZk2wifcogFL1pOAgGG9SPIj8lwFclulZMWN8X6sJEgZyCGiNzLOXAhYWUu4mvuVIiCJRxmoauxIfDjdHTHhhN6hRifRyImYsfW3c9VXzLeW8ogqQDA/7nhMkOeTfarqcRq/Zd0LQeWkAzQ1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945959; c=relaxed/simple;
	bh=4ZrUh7dAbEJ3Yq+94KlilHJ5fJW88wI/pwFRZzazH7I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QFRKK4t/k8PCaMmYvWIkgoD/2ILijDAba867UOY64PV8oKvuVxiL2P1KOYCZjQfXV1S8Os1jNFKPF/7U2QwiZGfcMb8CfHzFDwGklemSKDx9yPUtFDs7Uf8CRrRyEpmCpWbrm5Ec1551sytXroK0z6OGsXCQ2lGFRNcMNhZatXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V7A1Sggs; arc=fail smtp.client-ip=40.107.95.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8yk/GjAq8VHVZug8JjFNxxvzR7WQBtjP7wevMQz4dLCjjRceCXODTQ1UT7MDV6Zurv3GNG+iXAaqwqKSUSwut0Xblpbu0658e8UpBzCNhGBE9HUQki8QrDeVtCZ6v2LuXkI9hI43UOi0ZtcY+1YLbBY7Yt104hnkN3wWohNh2h6S8wJlTRou0nsljeuedF6d2Lkis1ggWEHehAJjZ6OilRvtUURUMROamRdeOhgEcYXBreJ4FTLIrlzUA9+SeD7iA5KmcRyB78dzGwYeOpiFXan3afBNrmTp2hQatwM9i2UK9UZUA4Xvsn/eLI0xskv4/yuU10EQuwAVaaZJpsSxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkpqF1+67UTrqXdMK+qqAhvpE/SRg8a+AmseDPi31A4=;
 b=XstCaCmBVsNI7yTxZ91pEz/vgHJx4JlVX2Xy2quwVS5UwXiniUcD67FofDU2nq1sewPf0XeLtpuYdwrqRcmzYFmUGqIHmb6SQCrLz76JZkXXHBxK+uDp7bgmzPbkRaCs1CsvvXPmE55cB8CwRn6COf14D0TsRokwboDTy1qH6Q/oWF8cJ3JJytxSBbdaajQIqwXBk6qk3pHN82Z+Vhw/J2YqHbx37Mt7xlvV/hPyRxUmX90y/M4D1+Qb2R13DUF+BZuf3NqTttvFHN2iNGpYwQHMwE0iCSh1OtTXgaHjDShQLb0Fl1uNEW8LvKwxO21b3L/vf/LMkcwptcYl1GH/8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkpqF1+67UTrqXdMK+qqAhvpE/SRg8a+AmseDPi31A4=;
 b=V7A1SggsfGWpuxoGqAfQUfANmuZsVk6WK3LNb2Qq53PquvTEXShiLgiQZOwRJ+PFKeW8AUIJCbwj6QJ9vSfmRjCD5O3igqhglfYruVGoyNO//9oFgr0kwWNbR3t3sJOnJZ2H2U2p/SK22qQbxXsGQTPQS3W6YbiE8Sh7fmk0qys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DM6PR12MB4386.namprd12.prod.outlook.com (2603:10b6:5:28f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 06:19:14 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 06:19:13 +0000
Message-ID: <a63c4589-6a2a-4ad8-8f58-2b791c8011d9@amd.com>
Date: Wed, 19 Feb 2025 07:19:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] KVM: SVM: Simplify request+kick logic in SNP AP
 Creation handling
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-7-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250219012705.1495231-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0263.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::6) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DM6PR12MB4386:EE_
X-MS-Office365-Filtering-Correlation-Id: ff7e36aa-9072-4880-fe3f-08dd50ad5454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzAzYlFiUXVPZE85dmZsMXZub3dQUURQTUd2SmpsdzQrYjBJdU1tZ0Z0MTZo?=
 =?utf-8?B?bmlGVnN4aXh1bXVONVdTZzVWUDVLeE9vZUZoTEYrYUNjM0FENFNFaWJaNjhQ?=
 =?utf-8?B?Y2FvdU1Jb2hoRGZISldabDg4UE1mUzJSalB0UFYvWmZISXNLVWxxRGkxajJY?=
 =?utf-8?B?S1h1a2hXOTF6d0lLOUtlUDV0RmljY0R6ZnEwNisvZmZQYzIzWjJ2ei9URjlm?=
 =?utf-8?B?a1ZlekxmUGxiN1U2dmp2WlFaTXQ2ZkZDTnBVVXRjeWEwTWpFR0dmeUJLRjdu?=
 =?utf-8?B?bUhOM1RxcXR1Y251aDlDWm9rc0F4a2lQOWUwRC9JQ3pIY0FMMDNBREJIZ0dK?=
 =?utf-8?B?bUlucGNMWTZqSTVKZGZxTkgvNDBOL3ZiOEFrdURJRkl1MVQ2eWlPdXJSazAv?=
 =?utf-8?B?THhoNlhDTk1IelowMnRVbVlIUW5JSlh2OWhiMzJ6UFhTczBDSUZha0pNSXdV?=
 =?utf-8?B?K0tSRHM5em5CZGNBOTdJalNJdjZJSkNwR2t3T1RSOXJUVlBwaFltdFc3emsy?=
 =?utf-8?B?ZnJtaG9qRU8zbkljazFYU2xXTDJhL0N1ZzhEQUwxVzQzWlN1L1VNb09SNDQx?=
 =?utf-8?B?bnA4U0IyQTVsc3Y1TC8wWXBCbGQ3TGdvMDhlU0FlSVN6MTdMZnFaanFQRFVw?=
 =?utf-8?B?UUVoOTBvb3FEUFF6cVJ0WEUxZ3Rybk1QQ2YzWEE3V3lLekd0WDI5ZFNjZEJE?=
 =?utf-8?B?dmNUVjRDdmMrUTJ1NlYrN3RTTjBOMmNPMEZaRDhVTHNHQWRGbEZGa3Q4QjlV?=
 =?utf-8?B?VUtFa2FLYm1PdDFuTUM2azhUc09uUnlJWE02TzVZQkhvd3REbzluU1J2VCti?=
 =?utf-8?B?WDFsU0F2VHpvUWo3ZU1WYTRxZWdKeUtlN2VCaG1lTFhZSm5qRDNaeGUyWW44?=
 =?utf-8?B?dm5IRnRLbGpSQU1Ta2FTVXk0Sk1rSk1DS0xpUGlmdG8xRktLenRGYzIzRldV?=
 =?utf-8?B?RUdHb3dDN0hpeFZoMmpYQmZGVDJKY2dGaWpEcWhjTGhLeGxXME1IcHZkbFlr?=
 =?utf-8?B?S0g2cllBWDUzWmVNdHR3aFZzQ3NZaFltcU5UekYrejhCdHlNZ1E2QnFYMkFX?=
 =?utf-8?B?UzY3RFViZks2WEFwZS90cSszRWFHbWk0dUNRQWpua3hqbzYxRnNIOHV1cXJK?=
 =?utf-8?B?UFFzS29HaTlxVThzcVQ3UVlJQTVRWG8za2hXdWxJdnYwUkxRZ1gwTkRsb2lT?=
 =?utf-8?B?MDR3VVhhTE1haGo2ZTFaNzRldVNDaEZDU1NPU0dLRXRsc2FGclFXcDNXTTB6?=
 =?utf-8?B?NlQwNk5UYjBueW4zZDJUR2l1VDA1blJjcjhrRDkxRncxVUoydHBWeTRqTHNB?=
 =?utf-8?B?RXBmazNRRTdkMmgwTzhqM3F2Y2VSbFBta0U3WGxRK1dsV1JoeFp2VEhFRDFR?=
 =?utf-8?B?S0Z1dE5XVE4yTURJYTdaTnNVWFVEenNjUUd4NXRIeitqQUpMZnl5SmFucktn?=
 =?utf-8?B?SnlSbUl5NnpRU1FIVWd0TTBRTkg1N05pNWx2SnZoenZwWjNJMk9KVWlCZVFZ?=
 =?utf-8?B?bWZCYVpza1A1RVdBZWcvT2JTcml2aitGWjlmSjVBbmd1eXBSQ2ZBcWoreWdV?=
 =?utf-8?B?QU9qUUJMV0xqTjUrd2xjdEU5VlhwK251MEZwM3FoZEQ1QUJJNWJNanpPelRm?=
 =?utf-8?B?bU4xbzAwU3V3cytZa2dYMTI3NHU3SkZHMURYT09ZTDdaUURFeWk4TktFbVZF?=
 =?utf-8?B?U1VuYmZaeUlqaHpKZU5JTlFaVG9KTllOMUc4UFUvQys1R3JxVHdXNWVwRjRs?=
 =?utf-8?B?eURwZi93TlNPZ1dpcnpmZk5TOTFRUllDUnhzc015dG9mcS9BbUZyL1o5Z1Iw?=
 =?utf-8?B?UXJyNUJwVkw1NmV6ZHJhNUw2N29UbEY2VWxpLzBGcmJQUGJNcVFwYmZXS1U4?=
 =?utf-8?Q?UvJo1qQBg2/eu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2R2RjVPZTV0d1ZCc0tJN005N1ZwN09XNVF1R2UyLzQ0bDZRSXFiTmE2a1Fx?=
 =?utf-8?B?VjczYlREcGZBeEpnaWo5SnlBSzRCZWJTdWxJblZXQkI3R3V5cGNuc2szRnd1?=
 =?utf-8?B?bDZMcEJwcjduemRpZTlHa3QvbCtWaEFyZDZvNVBSMUV6eFhLZUVvb0ZtMTZD?=
 =?utf-8?B?OFFHOTdvY096T1ZmU1hJQmlUVXhPdnpBUWtBNXpiWUJZMHU4K1Q1U2J4SGhm?=
 =?utf-8?B?ek9zZlVYNWhnMGFwaHQ1NXpGeWRBZzZ1dWNKSFpNZzJ3cG5XSDl5WmZEU3hJ?=
 =?utf-8?B?MkpnTFIxMFA1ZnIxdUs5bmRXNnFyOXB2b1k2a1BQcVM0ZUltVWxpUWw5UEYv?=
 =?utf-8?B?eDZJd3p4NmovSmdKM3JzLzVpY0tucTd5dmJ0RUlMWXpaTE5YdnR2eE1GaDhp?=
 =?utf-8?B?REdzM0JDMnhncG9KRjJVWmNwOUlBaXE1bmtldExSY1lMNmFzTlgveEk4MjNY?=
 =?utf-8?B?Zi9JaEx1Wm43bFhRUEpYaUdaN2VSeHVra003Wm1aMk4xeDJudERWb05vaE83?=
 =?utf-8?B?akFON0V4STAwdlcxNW1FTVFNWVQ2YWdodGxCVGpjS09jc2pkQUM5QVNWVm5X?=
 =?utf-8?B?R2cxYllzT2Nmb1BGbXNaaXhwYXZ4cVZQN3dlSFBSWGNLR2IvQ0JzVVZJeS9W?=
 =?utf-8?B?a1g5Z1RCS3pRdTZ3SGs2Qmt5a3RqWWZkVVA4RmdyT3hDYU9LZ05ScE50Wmxl?=
 =?utf-8?B?bVE0MThCbmVDS2xIeHRVSmtpU2txU0ROZVlON3VzSEdWa1RsQ09nV0ZRdlEw?=
 =?utf-8?B?bXlweFN3MjJCaGFEZEd3K251akoyVDAyQ2JsOUZkYVpnZHpsb3BpSm9peEJS?=
 =?utf-8?B?WVY4L0tuY0NwQVZRNHNqamtWZ1lsS20rYUE5K1FUdXNpcDllZ0pZSVZzblg0?=
 =?utf-8?B?WFFyOW1KSVRwK0ovQnVrZWkyTUxRS3o5ZFRaeHhtUG9BZ1loaExLYW1zbElQ?=
 =?utf-8?B?SEJkYTJwNXBqT21OOTI2bTV0TlVKbGNBODNDT05meHhJRzB3dzFhZng4MWta?=
 =?utf-8?B?V2svSEkybUV1S3prTmFoYUdjT0U1NXBjd29IcDgrZ0w1Uldyc3dBdWNWYmxH?=
 =?utf-8?B?ZnlRUEdoTythZ1lOM0NpalRtWHd0QWRDZFF5K0VLN3lEdkZLU3lERmdUd1lp?=
 =?utf-8?B?VnVkdUNaUVBmY3lmbldKZ002eWFDbS9lUi8rdHhxNWovNmQvazFSRml5MmhJ?=
 =?utf-8?B?RVk2aU9ZZzR0OFhQenV1VWJ3V0lSZXlhN2JEY2xNRHZ6VTRzZm9jWDd2dHhQ?=
 =?utf-8?B?cjVFQ2ZzaytFK1E2d0k3VnZZVzBWd1pMaVJwR3Y2NFJzcDhJejZyOGQ2eVlT?=
 =?utf-8?B?T3JwQWxPUWFLZzNnSzkyaWhOZmZvM3FNVzVESmZuOUNrOFFhRjNZdlhsOE50?=
 =?utf-8?B?dnFTREErSUcyQ2NDMTVWTEFrVHVTZlBXMDNONDNjUzh6N0JXczRqSzQrSTdE?=
 =?utf-8?B?VkIwdE44VEFReENLRGxWaUNtc1U2d2R1RE5yZ2NsaHoxdWgycjFIdkF5VWwv?=
 =?utf-8?B?S0dYc1FqRE1QdWZqWk1xTWNVeEdiZjZrcUU2blYxdEpqdlo0cHdGVDdvQVY0?=
 =?utf-8?B?UmlzTkpEdjVPajhHOTdPdWlDY0lZSGx4MzJSQXA2OSs0TWZnMzdTREZPVDFj?=
 =?utf-8?B?Y244dTNpT1lBTWZUSmVPNmNWVHZvd0p4anY3SEhVWStjRmlHbWo4ZEJTSWtm?=
 =?utf-8?B?VDNlbFpHc3d2N0h6M1NET2djbnRrTVJtOHVFbk1lMTBBS1FFZ25LWVFmWXo1?=
 =?utf-8?B?QmZWanRwWVRNcUZ5emk2WkRYRFRTN2VTb0FuNmYwWWlNcTRIU1R6T1J4SW1w?=
 =?utf-8?B?UkRFL0RjS2I5ZGZtblJVQ21xWWlGbEhtWVAvWmlkRlRuS3hTSHJvK2ZROUxR?=
 =?utf-8?B?K0Y5YkJ2ZG1kbnh4N1dKeU52YzBsd3M0UkFQeGJnKzFFU1duRjcrT2l6dlB2?=
 =?utf-8?B?TTRVT0RDOGJpWkZqYjcxbysxcHBaUkpGN3NJWjlsZ3E2TmRuamxPZGd0eVpK?=
 =?utf-8?B?QXBMMnU0VlVqNWczckxsNE83aTIxRzIvZ0JtSUxZUjRrR3hvVHAyRVRnVlh3?=
 =?utf-8?B?ZlBVeERqQkd5R0RveVUyNE5zUnNNdXUxSmNoYjFwSldES2t2TVZpaXJyRkhP?=
 =?utf-8?Q?A+13bJCcezutl2E2DsSI9RBsf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7e36aa-9072-4880-fe3f-08dd50ad5454
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 06:19:13.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axvXyStklBWHEZFikPATppf4P+eBPo1LYfDSCUv5ezlMNi3RioPdL8Czjvk1woN1aMtFKou0Ri8HRrlTNLAYmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4386

On 2/19/2025 2:27 AM, Sean Christopherson wrote:
> Drop the local "kick" variable and the unnecessary "fallthrough" logic
> from sev_snp_ap_creation(), and simply pivot on the request when deciding
> whether or not to immediate force a state update on the target vCPU.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Straightforward cleanup.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


> ---
>   arch/x86/kvm/svm/sev.c | 15 +++++----------
>   1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8425198c5204..7f6c8fedb235 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3940,7 +3940,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   	struct vcpu_svm *target_svm;
>   	unsigned int request;
>   	unsigned int apic_id;
> -	bool kick;
>   	int ret;
>   
>   	request = lower_32_bits(svm->vmcb->control.exit_info_1);
> @@ -3958,18 +3957,10 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   
>   	target_svm = to_svm(target_vcpu);
>   
> -	/*
> -	 * The target vCPU is valid, so the vCPU will be kicked unless the
> -	 * request is for CREATE_ON_INIT.
> -	 */
> -	kick = true;
> -
>   	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>   
>   	switch (request) {
>   	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> -		kick = false;
> -		fallthrough;
>   	case SVM_VMGEXIT_AP_CREATE:
>   		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
>   			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
> @@ -4014,7 +4005,11 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   
>   	target_svm->sev_es.snp_ap_waiting_for_reset = true;
>   
> -	if (kick) {
> +	/*
> +	 * Unless Creation is deferred until INIT, signal the vCPU to update
> +	 * its state.
> +	 */
> +	if (request != SVM_VMGEXIT_AP_CREATE_ON_INIT) {
>   		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
>   		kvm_vcpu_kick(target_vcpu);
>   	}


