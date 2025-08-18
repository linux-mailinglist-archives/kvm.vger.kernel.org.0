Return-Path: <kvm+bounces-54904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9D4B2B16F
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 300CF3BA1D6
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D93A263C75;
	Mon, 18 Aug 2025 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bsRXnfdo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D155121FF3F;
	Mon, 18 Aug 2025 19:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755544589; cv=fail; b=H3V6bQljtl5HF4j4KBXg/rhNJp/GPxqUos8bt0gNsB1RowtVUS9s2V74MAW5YSOlaTuP1YIaCpVPtgEo7WFHZRHgFyY6G5bfw9440rfr46AGxwcykZ/lzYNatZidVDnKF3FmbE8Z5+3hYX6O+AuAcyPhSbhOqELWjcxOl5Sq5fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755544589; c=relaxed/simple;
	bh=lAc09NZRvWhKDSElicKtnaRXeS2NbfZ5JZTSnF69xvY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vevmy8CxmObdLu3AQHnoMiqw8UL5m1LrUkHuxCc99wFSOKPhrx+K5rJRvwD9Wce0b94k9GRbNCYGdsbzwsGBx+o7/PXx+eSS9VyVSfkt5QJTl6rsN5Lk98JYv5QQOhXow9YbPE0XbsfSxqLKgeThWa/G6cGL9SNsWpabNTsRVr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bsRXnfdo; arc=fail smtp.client-ip=40.107.236.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lyahx65/vpe/j6uFbRM0VbQTVsvxW2ZDhn0Jj+6JJhaMs9LJNHnXvYfJwmU9MaX+WNQ+n5J0ce7KNM75oD0SLy3tvjV3vuVzlJSIGIP4RJPRgDXxT00PNq1JwE/bYyjNdsrXy4b7nGhq/QNkI2FsjIl7DdSm1AwZTVMo/yBBX03c5847d3rVDtt7gbgwfKAA8SnNMaUcvtE4wKFg1jH0BYkgHanEnkAQlolSfBlRM3zPvjy1YXPssZIQuIqS8G3aVfCWQ74qUOmM/VyovINYV/sQmhKZDY2r5SW8BV204BQ4OLIDW95pxLC23QkiJJa8IkUosttnCjnmgHCmiTXQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7nHrQuCOiolpu1lwUqQ1dGDmXGcK2XjFwmmRyeRnKc=;
 b=cFWNJXYfJQzlgqJ6BcYq3pQsKQN6Zl49xd8rhCpm93xdce8KSlRbaOwX5TriHzJu7/EmqZ/E+rTtFsi6FtlMyQO6sT8fhBC4KBfRXWQmsrZCipO0eGjnGLbx9DoAj6BXjAEgxhImpPXiUoc+5E/xQNzAhvAKBxheAfQg1pn9198EsgHWQo/jcUfguIVzbV6lVQzSYwYipNrmaiCpKwF0+EJeeeRs1bk+2QoOoD2qn34CFEi753mhOlRjoDhta5lbVS1tSVvRYHiq1dOg1tmwLOCh6722Zkb+csNb5fNY/Mht/DaYRlx+N1jm64KtrhozibwDdgEN6BwICmC3b+QLQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7nHrQuCOiolpu1lwUqQ1dGDmXGcK2XjFwmmRyeRnKc=;
 b=bsRXnfdo50dqwy0ST6lhAiBv/iF2MbJGGGqI1MFxud527QMIxfFmFThHWqO7S6ErfnyNkT4b9U8CAvVUgUy6tXZFqOhvNd6OrgFdpbQVdPqAy6W9rm84Hom/hCEDvoJR5ymGtnVL7dLNslOgQXBKGgSCbZPB+sHNZjh7VdcFBBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PR12MB7673.namprd12.prod.outlook.com (2603:10b6:208:435::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:16:25 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Mon, 18 Aug 2025
 19:16:24 +0000
Message-ID: <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
Date: Mon, 18 Aug 2025 14:16:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Neeraj.Upadhyay@amd.com, aik@amd.com, akpm@linux-foundation.org,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
 dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
 john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 michael.roth@amd.com, mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org,
 pbonzini@redhat.com, rostedt@goodmis.org, seanjc@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, x86@kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0015.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::29) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PR12MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1ccdee-d0de-42ff-57f8-08ddde8bb91f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3hHMUlVcnp4THlMeTRHemRCdXIyUTBVK055VDlPUHNmbGUvbjZKVG56WHBn?=
 =?utf-8?B?b2JETU1kOVBTT2d2dHFDZkN2SStCK1VDR3V0REMvR0IyU0hUaWQrM3lOTnh5?=
 =?utf-8?B?VmQ2Q2UzVTJhU3p5SEJjMXo4eksvR0RJNHFWa2xDVENGZUdZVEVxMVo5MkJD?=
 =?utf-8?B?VCtJczRIWXpvbWJsby95QjRsOFU3SDJrN3d0bkt1YTZvYzRFZFkzclh3SktO?=
 =?utf-8?B?TzJQNXl3N3pRMEM1VHFSK3NyN0dibitWTGlIcnVrYUtwSU16VEVsMk5nV2Ft?=
 =?utf-8?B?V0draUwvdk1abXFCc2Q5Z3FmVFNxaURWNjc5TlJkVG02N0RVc1JUUVlhWG02?=
 =?utf-8?B?OWRXU2RrZW9UWUNuQnlGN3NJOXFFUXNJODRMaGRhRGVlZGowaXRVWDNjSTI0?=
 =?utf-8?B?Z3l2WU9ReWZMMjRUU0tyb3AwMFk0c1lOVHArSHFxZFdBeGc5Wk5VL0RTM09p?=
 =?utf-8?B?NEZZU3hBNVJLaTE1ay95TFlpdDlsUEVaeDA2MXU4VVE3MnZJM3BJa2VZNGNz?=
 =?utf-8?B?OWNSTnpNUEdobVFzbVNJZTl0a3doSEkyVFRQOXRTaVZaOEt6My9wWnp5TERu?=
 =?utf-8?B?V2J6TVBBOTkwa05jQzFMbnh1aFdnYzBoK0xtY3Y0ZGxRK2tSMzUrcktKMEdE?=
 =?utf-8?B?RTJVdGsvZ3o1VGUwSmhKR1QycVRGR3JsM1RkR0hkZDVpUHRGeVhhS0x1UEh0?=
 =?utf-8?B?YWI0VG9mdGQ2SDBaLzJOSVFibC9KSmg1SHF1aHlaeVkwQk9vd2dQZFdheXI5?=
 =?utf-8?B?VHAvajJLWnRLRzYxYUtNTUtUWk9PZlcxMUpSYldBWDRQcXY2Qmp0OW9qcWNa?=
 =?utf-8?B?YXA3SXpEdmNvK1JpMjRUYTRNdHc1QXRwMmhWRnliRkhoVlhOUjBLaUlqT3RN?=
 =?utf-8?B?NTdZcnIwbGlHdGttWjhzVDRISmNGcVBDVy9iRWhTLzRpMEI1ellqcnA4eGJS?=
 =?utf-8?B?OS8rTXk4N0VZRFNRUHd3M0RubWRxaG90dXIxblBxbjFaVzZQWUpHOUhUQnA4?=
 =?utf-8?B?OGJRcHJOZEQ3MTZncXg0Zzk3Tkw2c05TUG1FODUvcmxPNVpwbHpuZG15SnIx?=
 =?utf-8?B?bHFHalBaNXlkcE1maERKUzErbzM0SFJRZ0orNE4vbkRUUnM0Vk5wcTBuR3Jy?=
 =?utf-8?B?SUpDU1ErWHlzazFCSTE0K01uSzh0T3JuU1NtZnN6bEJOdUFaN1dvSUxqYTZH?=
 =?utf-8?B?OXM2SnJBbmJibW81UVlPVUF6SUo3cFMxajIvL2VvaEpCNTZORm9NK3JBalVm?=
 =?utf-8?B?UndrU2wzWG42ZXgwOTNGSHRvWnVGTU4rU1lKRGN5MThXd2NxT2FkMVBtbzlL?=
 =?utf-8?B?VnF0SlVzRDQrZkFZY3dYVjVjUkJRM25YaWVIREJmK0lBM0E2cWZsVlROTkNP?=
 =?utf-8?B?c25UeFFUNzFCSVprQURGVzZJV2p0Z0JxZ1F1a1JNKzF3enY4VVU4dFdzdzZh?=
 =?utf-8?B?SWk4UjNyZ3lqU1huU2prZExsVUFSbnJXS2U2Wi82VVBhVnJwRVdBVm1JdFE0?=
 =?utf-8?B?QjBoaXN4ZHBleDdXN3lQdHZUOUlTNmJscXROR1k4TVdpakdKemxLbnlVeUdl?=
 =?utf-8?B?dGhnakM2QjlpK0xVUk9lNWhLZDNyV3RUYnNSelNSTTVCelhlNE40MkIvY1VZ?=
 =?utf-8?B?ZkloYUtjQTRleXk4WmNpcm03NlpLdGc4TmF0WURVWHpoY04xdHNJcUFHL0tL?=
 =?utf-8?B?UUdDeElha3l5Yll1YStSd1JuRWpmWU1iZ1lJZmk3dkVqd1lob2tqSElwWmFp?=
 =?utf-8?B?bmZvRU05dklleXV6RFVjT0R1NE94MVlITGpPQ3I5blFRNGtERDRNL2lpcUJ5?=
 =?utf-8?B?RURYUGVTK201M2JyS0VmSkQxTmhMZjVpY2JwZVNleTdLcGRIVmJrY0IzRHps?=
 =?utf-8?B?UFRYVmxxOXRQVHBtVTNReU5rYzFaNFNwMjlPb3JyZGVXN0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWRNUGFwNmo4S0lvRXp6Qk05Tk9GLy85elU0MkxlRkY0b0MzNElNbHpRTlpP?=
 =?utf-8?B?eW1jdXdEeVgrbjNTZ3paVTdlRjY5MWQxVzFUSDRTWXV6M1FlWEZTWmVDdUUr?=
 =?utf-8?B?ak8xUlllMmg1NU5hZ3NhMHhHSnZSdDRuSGVsdFMrL0tiVTFDQ2NHRUszbFd4?=
 =?utf-8?B?MEwzY1J2M08wWkllWkU0ZXlOTm0vZUkxc0pvTlQwWlVCTHhiQlMzYjVKekR2?=
 =?utf-8?B?MHJkUlY1dkcwQjBYalduSHZDOU56T1laWUlPaUFOS1BVYXNsUWdwZTFnVFpI?=
 =?utf-8?B?ZUJTYWJuQkJ6VVZyRllERWN4bGdRS0lWNmUvYW9zeGYyS3hPeG5SODV1a25r?=
 =?utf-8?B?WWRZVlVENEpnaHJrdVRyckVmeHNOd1dWSVZLaHduK3JKQ2RhYmQwQmZBOUZs?=
 =?utf-8?B?WVZGbUVYSDFxbUNsZXZuQ0I3WHJDdFg0ZzBxc1ZZdi8rSmhRWjhoSmlUblBv?=
 =?utf-8?B?OExNRmVibTdiVytCakxuRHpHSlpUdkJNRTkvZ1BzQzRDL1F2ZUFjL3FHTk02?=
 =?utf-8?B?cXhvQ2Jwc1J6RE4vakprd3VBOTZiSWpvWkNiM1lIbFFXdUNjMDlTT2xUQ1Iy?=
 =?utf-8?B?bFhiK05YeGp0Mk5ZN3gvSTFianRlT1VSOTBBUTZ6R293QUloWWJBNVUwVXZS?=
 =?utf-8?B?QThUTW9OQ2VuQzB0N0hQZXdhR3E1eGJZVmorT1ZHWGt6Z3dpUFA3TkdSaVdh?=
 =?utf-8?B?VTJlc3AvV3J6cVE2Rk1LREFsUE8ycDdoek9lTlQ5MXAyRUVPZE5HNnUzRkNk?=
 =?utf-8?B?aE9YZEFCWGpWUCtSdGF5ZlRGd3dyTjlMaCtuWGxNcTZVNkFkQTBSQVBuV21y?=
 =?utf-8?B?a2xoTmIwTVJqQ3JZNmxDSVZMaXROd1prREtxUHVqRTVXdXo3SkZQQXUzeEJn?=
 =?utf-8?B?RUpQZDdMeDN3cnA1U1JBOGNJQzBOd0g2UXdCcFZ0L3JVanYzMDZkckpIeTFC?=
 =?utf-8?B?U0ZwRUlNUkRTYU5LWlVOU2s1cXFNK0dMb1BVZkh0Q2R4VUUybjJoZ0NzMS95?=
 =?utf-8?B?ODRzSHFBWTVkdU0xWUN6ZGJxQWRpYjhUSmV1T0VnREZFWlZuV1F4TWZjUFo0?=
 =?utf-8?B?SmNhZ2s2WTQrWGpnR2dDN1dFd3hMQUJYcVVBRTlYMVJ2cGxUdFNFclB5Wlo2?=
 =?utf-8?B?T0FTUXFCYU9zY0k3WlM5RDFFS1grYSsvdFNsRG5WaDlwTDZCQnJtc3JqKzRS?=
 =?utf-8?B?U1VvcG9Ja05BRFI3RTJWYU1vaVJNQmdOU1VGWndkTDVJeE9TeGg1NHc2TkZt?=
 =?utf-8?B?OHlPQ2xiZ3cyRm9UN2xLRTIzUjZWeGZtdE0xWHZVOEszWnc2OVJ4b2dORG5S?=
 =?utf-8?B?czl3Q1gwWnRDdlRZVnNGMEV4ejAvZWhMRlNMbTdOWkM2aFliTGlnY0FWck5Q?=
 =?utf-8?B?UEdJcjk5MERaZTF0NGxlV2dlMy9rajR5bndFTFVYbit2a010ZzU2b3FqVlZ3?=
 =?utf-8?B?R1VkOVNGd0dBYmY0dmlrMzdab1lpMlpqSzBCTFk3RkpkVnFVblBwYWhYenM5?=
 =?utf-8?B?UjlQSk9lN24yZzZOdk56K0dGRnFrMmtscVp2K3FEQ0FsQUU4OXNGZHNIMEcw?=
 =?utf-8?B?YVlCZXluT1lqak1yTlZJOGc0VURyR0Y5VkcwK2d1UlJnc0Ywb2FpVmZ5dXJt?=
 =?utf-8?B?MjFMMzFmOWMrRTUzdDlhZnNwS1Rzd1Nkdkh0aWsxVmxYbFpUSGlxZFZOWHha?=
 =?utf-8?B?RXdWQWw4OElGM1c1SlJ4dlpHYzU1RGk3K2dNdFdpNStCdzhONFRHbTFQbGtR?=
 =?utf-8?B?Q2pGQXNHcGVSV2ZZZnFwcDZVMWZEZkRUaE1IUkRCNHhRT3REZ2l3YWRFcnhk?=
 =?utf-8?B?MDhjTklldzlBaExzZEphc1d5bVh5WGZLL0l6NnViWDI1YUthUnY1bGxGRTRH?=
 =?utf-8?B?aHJaTU9PSFcyclJJQ1o0RU5HZEtsK0pLa3lqZ1hwR3pPRzFZK1pRenZ4VlJn?=
 =?utf-8?B?cEFLOWhtdy9XTkV0bVRKRlBxdk44UGk0MStEL1BxMTZvdy9EdjJYVmM4UVR0?=
 =?utf-8?B?T3VLZ3hOZTVxS1RhRGFMOUNhM2o5cU1JcGE1R0NQdUYwV0xPUU9oWVFRZEN2?=
 =?utf-8?B?OWhQNERnZW5ucjNuSCt4Y0dicXJJZlUxMDNTMGZWMllxVStPSk8xT2o1S3Fv?=
 =?utf-8?Q?ifKO1ElqKvfMLXtiusYn60p91?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1ccdee-d0de-42ff-57f8-08ddde8bb91f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:16:24.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 768lkosc/8W7GdnSdrXspbf2Ysw/g4l96GeCuAuvfpo1BJDYsNM+pv2T0x4ytSB3Ard6eLpJnbT3LI19Snwjtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7673



On 8/16/2025 3:39 AM, Herbert Xu wrote:
> On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
>> Hi Herbert, can you please merge patches 1-5.
>>
>> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
>> for patches 6 & 7.
> 
> These patches will be at the base of the cryptodev tree for 6.17
> so it could be pulled into another tree without any risks.
> 
> Cheers,

Thanks Herbert for pulling in patches 1-5.

Paolo, can you please merge patches 6 and 7 into the KVM tree.

Thanks,
Ashish

