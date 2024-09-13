Return-Path: <kvm+bounces-26827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0607C9784BA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8929A1F25EC7
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37D643ABD;
	Fri, 13 Sep 2024 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CmeyVYlH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35B39FCF;
	Fri, 13 Sep 2024 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726240886; cv=fail; b=E0jTMLRwEEef+k4Qvw2EW/n18W6Rv+FwFG2FbNHsfPd2+CLdVY2os9rAsoocU6tJpUmPOUdHpYslemheKi64NRS92RI3d2djErW7ytJZVD3OKI7SQYjZh2YqQs8BqLbcHPH7FoCIWCLAHNu7nCQfLhK8RHxEyyUNK4X1z398uEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726240886; c=relaxed/simple;
	bh=xTJRl6VyuAit39iR9UIxRW7viDSOdnW3ikss8JEY1W4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YpGJmxFPEInlbEqQw0NcZzXzm9rS9WOCiEorsCJKWxNuXQ4SF1mRDyhYwMYXGlWczFz8fxH6DiylJvJ3NqlnyDGFX16gsovuhRWEDjWZfmg1UQQcr2qVDTCTdVWj8Ol97k3a6HFDTjesDzkAy2iRtUo0BcIV3S4m1DhBiJb8iRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CmeyVYlH; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAdnEH2bYXiSEvoCBn+GwPLrFc5UQq+VgUHfm7akSZvvgAehAed1xdkm+r/XPywV0FgVU1YmNSX5Ckvc/6x/cfyRc0s05SHBd+YZ9022UwuEgM6nQ+5onVq+zjDnTus17LYjFmLqx34zQDujfTxKCOj4oZSFPIfhvOv8CkUlp0J1emdacrVqVWOqXgr4e4YF8epSV5gKVxOtGv1WIJ0h6OxIcTG+l0lo5VA39PqUyMDDn4UdtTySA1OzVvocejsyjicGH7DIMrsvFt2D5bbJixMWKLOdTgTQvM6mxUJxr0+WA7WOJVvGvKYiYdrb4fJTlJ2XEWT+y3dChM7o+4DPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XD/N7PCLulC65A8zwGhcMSQvlikc+m7AKfmzpIRCsqE=;
 b=PTEHXDp6jGDfinGtcq7LkjG1JhOv3hLp2IVEyFkZPOYZGLcnknOvXS/qnVlLJqqGlAix4kkxMoiZhGawFhUSt+siju3LE9QMpTiRV2gzxxgxskGI51f0c79AnnWQtMhrhf5A1iCbhYfJ+Z+rsQUVqIugb0j1EpoaFkygOv1/RN1AqoQu37E+xJDPvtvi/MgsKrYv+7CHC6f87OfqU+SaIb9p8k0hbdLcZtivnhu5a5vCRJ1N+hUU/g1pXJrhab6SL+h86t+fQeq7xNiFAK1hQjfXiLQuVQH8s8sgs5p2FuEXGpaMEQyDDTgMFzLhW8C15sqy7uRWTxWIFkADNCnT6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XD/N7PCLulC65A8zwGhcMSQvlikc+m7AKfmzpIRCsqE=;
 b=CmeyVYlHkMWZIuLEPiLkHp3zkF8CRWWDfC5nRIuZ9Kf3xA3Xllsi7dk3k7fu1xrwvVkH42Ukv5hgjV9BcHBLxejif6Yk4wvJgE5ZMZOP5GDm728gqSp+7cNfuVYKZfzYdgbnNy9zPsfxB0+B2NTTBac11klDHhJAGhK84esTCmY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB5843.namprd12.prod.outlook.com (2603:10b6:8:66::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 15:21:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 15:21:20 +0000
Message-ID: <96333d79-8ec3-44bf-7b74-33c67ff2d0df@amd.com>
Date: Fri, 13 Sep 2024 10:21:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 13/20] x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-14-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-14-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:802:20::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 1504e36c-9692-49ef-1b06-08dcd407b8a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ak9aTkhPYWdyUGNObkk4Y1ZCR3p3aGQwa1gxWDgxUnVwNHRRZTk2U1FpS1hy?=
 =?utf-8?B?NnFlUlJsV0E5bDV2UjdXY2pjd3dkK05ZQ3NXeDdmcEdVM1M2QTVTa2kxdW10?=
 =?utf-8?B?cUoyaEhoKzNaSTdpcWcwRzlGS3JHR212NG1MaHFzdkJMakQ3azBwM2FTeXBs?=
 =?utf-8?B?ZGpyMWh2NW1MUm9iaGl3Mk1CY1N4RkhpaWp3emxrK2xUdmZLZUFaeGowcVZz?=
 =?utf-8?B?TFlzekNiUXRnVHkzYndtWVVVRXJvbFJZRWluVFAzeDdHWE5uRENRM1F6R25p?=
 =?utf-8?B?c3BvMk0zVksxYWlUaEZhSUJIR2R0L01vNVpjN2Rqd1NWOUltajRNRy9pTGZX?=
 =?utf-8?B?Y3ZHYkY0M21HL3B0SWJ4VEZPT21RZkxpNGhnNkx0UjY4dVprQkhlNjV2QUxn?=
 =?utf-8?B?K0lLZFhwNllHdit3U3VrWk9aZUpDU2RKQWgxdU12RjBsR2hJUDVwdmpabllZ?=
 =?utf-8?B?MlFhdm1TUm5jR3MvbFV1RlRlOUFSanRxUXpEOEdOQUY2WmhxbUtyeE1xNnRk?=
 =?utf-8?B?RmlYUjU3cEtZYkJZWmtNb2EyNDVVejZQM3lKeTFjM3R3aWZZWS9HZXBqVnpT?=
 =?utf-8?B?eVBGQlZvUjNIR0l6ckYzRElnYXp6djJkRG1FalZhMTlRY1ZsamhlVjRhd1ZH?=
 =?utf-8?B?UmxsbzFyM2ozcUorTTdPZnZVa1hUQzhORHY3eHBQZktHUGNjR0VzeHgrdm9p?=
 =?utf-8?B?d2c4cmZjM3g3cG5VWFNoOHVXWEs1UmMzWjZFU1Uwc05HanJzY29mZ0JGVkdZ?=
 =?utf-8?B?NU5tbncrQ29oRG1qbUs3NlZyNHh1eXlkNTBPSDBRTmV2UXd1aTMwOXFGR1Aw?=
 =?utf-8?B?MmJlYWhURFJJclZkN3g1QVE3YWEzT3hUa3NYMGNjOHBiWk41RWJiMEl5RUVR?=
 =?utf-8?B?WkV4bklQNytrSzFPYXVuVzZ3cjRHb2JERFNYL1JVT1ltbFR3MXBjS3VUV1Nh?=
 =?utf-8?B?YThwL0tHamRhc3Nucy9EUDNHLzV6azJsZW5KSmRtOE1XcndiQ0g0WWpOMWdW?=
 =?utf-8?B?T1NWMUZZSzlDa0swN3RGSGVHUkJDaWZQV2FWQkx4enlPSU4wQ3c5UklYZjJv?=
 =?utf-8?B?RWZEbGZheHdVdWNUc0g3NUphRFVqUnRJMG13SVBBYlJqa1JLQWwrWmpYajhl?=
 =?utf-8?B?V2d0WG9qQ0F1ZlR5S0Fmak9QMHNFY25tQ1N4NDFnZTUrWW5kblF5SC85YmJt?=
 =?utf-8?B?elYwYk9OemRVaWUxTktMelVMYkVVeHZFOU51TXptR0hiTFlxVzM5RGw5dXI4?=
 =?utf-8?B?MTM4K21vTkp0amtEQ20rdXhBcDFaMy9INHEyZ3RpWWcrK2NXZmY2SWhJbTA0?=
 =?utf-8?B?ZFRUY0FrYmRNdjZFY1hKS0FsQ2JNRVZJR1VqMXJnY1hiblptcmJPNTlGbGhm?=
 =?utf-8?B?VnZLOTVYenMvQ2RiTlJkVXZjNmw1SmlvRm5HdXQyamJkeEw2b0JISk96QlNl?=
 =?utf-8?B?Z1BPcCtPUWNzY1F2alhwM0Vrc0pyZ25GTXNld0lXWGVYTEp6SlZNQ2FjTFEw?=
 =?utf-8?B?dUlmMHUyWW0rNVlGZjluNXlPMGVJc29obkRqTkdFYWVxZ0Y2RWs0dDhMYVZm?=
 =?utf-8?B?aGFBYkJsQTY0V3NQR3lMM3R3NHBmT3FQekV3dE5CTDkrbC91WmF4L1psaG5C?=
 =?utf-8?B?SFk0TGg2eTNYT1AyVGx1TXpIeStyWkRIY2dmV1ZCUGRNUWdOU2JZZmVqalZy?=
 =?utf-8?B?YlFaVWl3M0d6WVlYNm4xVXJpVDVYMlR0NGZvZ2JrZTNreUlueG1nZDJPUXpu?=
 =?utf-8?B?bEtlT0kxRE1ROFQyOFFoYW9BclRYZmVyeGRXNnEwMGxJNkNOQ3VuazJpTXZs?=
 =?utf-8?B?WVh5aFlaQmhaM0EycG9Ydz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGhQQTRjM2xueEJ1a1VncHBpQVhqT1hmMFFnVDdVR3YzcUVoMHJoMTJGS3l0?=
 =?utf-8?B?RmpQYWRSeVBteVlCWTB2WVRicm5uWFZscU5RUFVBUGVFODFzUUMzako4b216?=
 =?utf-8?B?ZEIxL3VYbllLZ05oUk9MVEU5Z21tdGtqeUFpMDl2TmUxNXhBYS82U3ZmVUxK?=
 =?utf-8?B?MGJtQmpMUlByb3hsVmIvVDhpU2QxWmczYVoxN2t3NGk5Q1F2RHJWQkRhbXl2?=
 =?utf-8?B?dVRUL3JFRTlXQ2JnTnBPbS8vM3hPL2RQVVAzWU5hRmlPZGpJZlhTbUwwR1g2?=
 =?utf-8?B?azNJM0haTFNZeU4xWjdSUWR1Vlg4WTAyQmhHejNRNmErb1lmbFo0cDViZGh3?=
 =?utf-8?B?QS9xWlI2aDlac082M3hqdnRQWWZRSGY3UFVqVDFQTkNkZnZPTkxZVnV2R3Nn?=
 =?utf-8?B?VFlpMkdmVGpWbktrNnpyUy9ScWFoQXM2NFdPbHQ5SnJuTDl5Ty83YU1haFNF?=
 =?utf-8?B?WWMzTGRFWVljc2ZGYVlIMDVqY0hCZENIWjFCeHZTSGJqTWFCOEpYTG01dk92?=
 =?utf-8?B?ejZLa2lNclhkb2ZRRXBhSWFTWHkvaU9hSHZONVFibkwxNGFjK2RXYXo4NStj?=
 =?utf-8?B?eDN3YnZYWE5kQTNYNWNpMnI2VloyZ2JkVnNicHlhSjdpMEJGaXNlZTdhcFIz?=
 =?utf-8?B?Vkl6NWNHMlJCTWZlYXVZQml2SVlpeVE5RXpEdGFMRk1rajZoeU1pMXVIWTZM?=
 =?utf-8?B?UStMajlQYVVOQnNKaGJ0UXpMdTRxa29wTU0zUFh0WVlLQnJKcjBSSlJyMGNu?=
 =?utf-8?B?OEE2OGFESkwzeDNsbXRid1ZVVHg5YS9hWldFR3Ztc2EvNzVsUDg4dFZNVTV0?=
 =?utf-8?B?Q3Z2VW9PL1BmUUpkR3RxajBZQVgyc01HSUY4Ny9JUGxhL3FoaTJhNVNJYU11?=
 =?utf-8?B?MzYyY0VJYnBQQVhFR292enNmY0ZUQ3hhQVB1cGQ5emJoblYxbkNYMGEvYkpC?=
 =?utf-8?B?K01IbGZYT3FyTlJsNVpXdEFxVTVQQjdQTzFLYmFPU2tvemZXYzBldzZlY0sy?=
 =?utf-8?B?YWNRTVV6Ylp0SGZybEFQbE8rWnMweDNkTlFOSXdPTjhnSWtwalJBaUZQakxF?=
 =?utf-8?B?VU9lU2dRQWZBS1pURjRBVTJjMVpqQ2hqcW95R3l1QllvdTFiQVdTcDg1dlVZ?=
 =?utf-8?B?d3RPZkI5bkNNQk5IV3hFbkR1Qy9Gc3E4UzRUdmdZSEhST29OTjFOTEROK05Z?=
 =?utf-8?B?QmxqUURpcGM0cTRnYXRXYnhBV0ovdGVJdTN5eXdqNStvNWh6NEpUektWcGoz?=
 =?utf-8?B?THFBcDM2dVlWWCs1aVBpTytDKzRSTUZBMEJGdGhONExIaDU3TDA2TzQrWnE3?=
 =?utf-8?B?bm5KcnphK20xZFArcHlyQVRDaHdQQjcvY09jVGdoTzVaT0JteG9zSXJlc0lm?=
 =?utf-8?B?by9qOGF3VmZpeHFHL1ZoQnRXSEJwdGwydTJOZTRVYVNkb2FlWmt3NFJxaElm?=
 =?utf-8?B?Z1ZoOU1SZWpiMURQdVM3R2ZkRDE0RzEvTnNRSG12aEt0c1V5eDJ2OHlvc1NV?=
 =?utf-8?B?bng3c3l1SnRIQ2dqejhJenZsQW1oRW1PaDFjZnRteDRqYjI1UWcwVnB0NG5i?=
 =?utf-8?B?QlA2M050dFo2L1J0bjIwd253VTN3RkIrd1c5dm9FbmJJOUVnNkZFYklGbEd2?=
 =?utf-8?B?eloxNjZmTlRUa1g5UlFGcW1LZkZDSkYrNDM1MnlMTU05ZnNXYjRlVVY2dHl1?=
 =?utf-8?B?N1JuaXBIVnZuUFRacGRyOWN2SnVNWUhESWh6NDZTaWIxSTFBR3ZyMEo3am5i?=
 =?utf-8?B?bHNGclc4clJKMHl1MEFrbjlZMDB2MjJub05QVkpnMVo1c0tSVi9VNWNmekp2?=
 =?utf-8?B?UURxNlp6d0JWMU9HTUt3ZGxkQ211Sy9DM0dTN3puZ2x6eXl2ejg5RVRuaXoy?=
 =?utf-8?B?K0NsYStFd3FQTStSbThIOWJqNGZKYWpRMUZPZlQ4UUl3NG55cDQreTZIcU1L?=
 =?utf-8?B?ekwxKzJQTjhTSDJZSjIwcDhDZlB2VEVyNFZXdVp6RHgybmlXcWI5dm5lSVcz?=
 =?utf-8?B?Tk1LL0JZUXZ3K1o5dmxldjk4ZW1XbHlCM2UyNWdSSXI2Y3YwS201U3FDQ3J2?=
 =?utf-8?B?SjRvUGZWOTUvSkFCOEEvczI5V3kvdEZKK1Fvenlnc3JkYm05TGlyVkVIQkkv?=
 =?utf-8?Q?uk7e2Lkzi3FpdHiYu5Z7UBkWO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1504e36c-9692-49ef-1b06-08dcd407b8a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 15:21:20.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNu4saP6hvByvysWlm9h37dJNL5ynozI506YrSDnWcyaF12zw9oX2faMOkS2BfkaIWeGF4BY7HIOt9znNWGguA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5843

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> Add confidential compute platform attribute CC_ATTR_GUEST_SECURE_TSC that
> can be used by the guest to query whether the Secure TSC feature is active.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  include/linux/cc_platform.h | 8 ++++++++
>  arch/x86/coco/core.c        | 3 +++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index caa4b4430634..96dc61846c9d 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -88,6 +88,14 @@ enum cc_attr {
>  	 * enabled to run SEV-SNP guests.
>  	 */
>  	CC_ATTR_HOST_SEV_SNP,
> +
> +	/**
> +	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine and actively
> +	 * using AMD SEV-SNP Secure TSC feature.
> +	 */
> +	CC_ATTR_GUEST_SECURE_TSC,

If this is specifically used for the AMD feature, as opposed to a generic
"does your system have a secure TSC", then it should probably be
CC_ATTR_GUEST_SNP_SECURE_TSC or CC_ATTR_GUEST_SEV_SNP_SECURE_TSC.

Thanks,
Tom

>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 0f81f70aca82..00df00e2cb4a 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>  	case CC_ATTR_HOST_SEV_SNP:
>  		return cc_flags.host_sev_snp;
>  
> +	case CC_ATTR_GUEST_SECURE_TSC:
> +		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
> +
>  	default:
>  		return false;
>  	}

