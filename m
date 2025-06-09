Return-Path: <kvm+bounces-48728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 645FFAD1A0E
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 10:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCEE716BAF8
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 08:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0529C248F69;
	Mon,  9 Jun 2025 08:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="spXg+NuE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4F1FA178
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 08:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749459120; cv=fail; b=BI3B1Cv7f+eKMTHi5syAQSy3d424LnAgut3fXxercmDMNZtEGVaFMQ8ruB9G7A7l33BJU42q6oCB4liu5vM0jgYItCNkZdFzTG6rxFNK17W3PrbVDnssDJe7LjOiNWJ0wBoB15mkpuuBASkAbGOEjB8iO9L6uT2u8RQ+zzgOp9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749459120; c=relaxed/simple;
	bh=rPy7zTr+R1Q64JRLJlNJNLD4gM4wKBwU+q7PgUEhFOY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tETKoVHeVuGwlEVpBMisnJsMlYI3ePrmqpf9490uxSG3JXX/a+31fO82TGZO9+2a2OYqpnoe7sUSijSkNUHMTaJzUBm4vQzVJ+Am9wctqXnOGNvDd5FhZDygVFoTR9YvndFbpitHKZsimHeawxWf2zOgNjrFDYkHAdswS6Ro4VU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=spXg+NuE; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xysnoy00Ybmdkm4ia+m1MLmdfQiX1Cv60jXwQ3xv6wDsTaqwRfo3XWtWaddnkXgAj9OMYXw4Hn2ymMxIOXfFa8W91fVgEF1WSxdmQSDdnqVr3I6iwz1VVsppP4uG1FLkneJeIDoQiL/yCYWvEvmIyzmVfN9vD95/VNAJouTHIU2Pb8wJqxUXHuuAl8fSRjJ8JXvzGkXaktbHy0UmZCg8YkZ6y76IksKrVY+4otfMO54rRVWCwXZhY5J932UeN39zARPLjtw6t7W/chiW9wjZH0UA+ANbAYiHMGMfryWvNu69ZQ0HoTWTdBmA3w2RHgfZZfNPF/UVOsRj0zApJlXe9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2P9JeGJ6/tPft9v2Qyk6ekZimKooUTOPN4JWNxUZlM=;
 b=L9aLmX91dn3PhIFfUviSs6t14ay0d0DD+8IGGXDGFWVQc4TlYuJVxF1iwrv2QXLszcUfTBhAL3s5rxHEoA9YyaZ+2/YI3Sgff8QFXkS0I1gXDrm35jm+EKCE1k8GnGOJ/Q8u8GgmOaKUAjgh5rQgzK9SWPE1SCrw7Bzk3olcc/LIjPp7RtKrcc3UwTgLAHlbyUdLEt/qm+m27uiIVs08kramV+1WhU1LNSGr4F91Y41o897KtbtCqvauNnJ2voz0jm+mcz9WjMux0r/D2zCHWqucyYW+u2kxgeJlNM/aMjD/GKVzrVs2+WyOjiAJMSnvT65KpbZt1KeyQJbwtkItmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2P9JeGJ6/tPft9v2Qyk6ekZimKooUTOPN4JWNxUZlM=;
 b=spXg+NuEEes3u7IIIhNqdTBmZ3IJ+dP6AVZUuxKE69rSskL2L+wgAGLy2746NOnYc80ecq6i7YH67FV14aDpjTtehHMnIKLtmVppg7PTznXukCebmzwuycUgF/FtyCkwhsmcJba+sEhADXgwW98VqBp51Fv7CvvRqh5nlGpCfzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by SJ2PR12MB7943.namprd12.prod.outlook.com (2603:10b6:a03:4c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Mon, 9 Jun
 2025 08:51:56 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8792.039; Mon, 9 Jun 2025
 08:51:56 +0000
Message-ID: <323192cf-dcdb-4676-96a1-c4155a0d70f4@amd.com>
Date: Mon, 9 Jun 2025 14:21:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
 <7dd702a3-e9c3-4213-b0b6-799976d4736a@amd.com>
 <4f6b6a8a-0f75-4123-b06f-a8bf7eb36f06@amd.com>
Content-Language: en-US
In-Reply-To: <4f6b6a8a-0f75-4123-b06f-a8bf7eb36f06@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0036.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26f::6) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|SJ2PR12MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: ee475a8e-7a14-42e2-2294-08dda732e2b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mkp4MDVyZkdTVGpmWFprQ1ZnSEo4VTE0bnFQdVkxZmZ4NkZ3cExRVnVyRzNN?=
 =?utf-8?B?U0g3NFBJdis1anM3UE0reG0xZFl1eWZMeHdjVWIrMGRXQzJhNXNNZlpxQTBk?=
 =?utf-8?B?ZzFhek5PaUY0K0Z2WDhldEd3eGZjZCtieXFNN0V1cGE1Nm1UU2hDTkFxaDFs?=
 =?utf-8?B?cm1oVVJlUWxYVTI3VEVVRXB6VlVXRnFLM0lsNjJnUzlDR1VLdmxrbmZLVUZL?=
 =?utf-8?B?VngvclJUNXM1eUhoN2JrWERxd3RPb0lPcXZLbjdZQ01RVE9jaDBEK3VVaDg2?=
 =?utf-8?B?aXRITVVEcXQwNXB4U2xqYlJIZnJJRHAvSk5WOUlmNDc1aWcvVGJTTU1lY3lC?=
 =?utf-8?B?azZ5UE9MQXZiNVNmclk1Q2hQV1h2dktGbitSMzMxNlpCOWdvRUhHbW9NdmpI?=
 =?utf-8?B?VUptWjRVdTB3bFhmZU1CTXhhMVlndXdUbUdVYjhOVUl0WDExU2V1YnNyN3lz?=
 =?utf-8?B?dEhFQnZlWXptU0pGRlMzYXltbmtPbmk0bCtHZzl0V0FyVXhPaXlRV3p0ZG40?=
 =?utf-8?B?d2dYU2diSnpNMWJiM3lXS1dRbEdvVHNxZm9TQjB3VEZ2a1JVZ1ZXUzFFZllp?=
 =?utf-8?B?RmFFTVNsU2FTS0c3OUhMc1ZZUjVTRHhnbTY4a0c0OW4yZTM1WGtCYmZxNzFP?=
 =?utf-8?B?WlNqUk01M3oyak9wVHZkb0ZvVVJHWUlEOWljaDhXSHl3eGlmV1hTV1RFdUla?=
 =?utf-8?B?eEcxY1VpejdtQ0tPaUE3U2d4a3pqeHR2TmhBSEdlQ1J6VjFwdXFneEE0V1Zh?=
 =?utf-8?B?UHpydW8wU25IWWM1MVhEKzVER2JJUFVGMTEzOENtbnRLS0M3bXBIaURRaW9j?=
 =?utf-8?B?R2pvdzdjTEppWG45TU5SWkFRQjVucW92QlNNM2llR3QvRHYxOVhseit1Sm12?=
 =?utf-8?B?anVoWmxTUVhJcFk2aDlaZmlpV3dma0tEOExkSEg2WjdoL0lZM3lGZUh1d3cz?=
 =?utf-8?B?UWNjUitFSnRudnVLdG4ySC9MREhNeHpUVXhxbWJCUmR4QzRJVG1IaFc0alRU?=
 =?utf-8?B?NTltSzc0SjZCTzJXbkFWTkgxT1EyaDNKY3VJL3EwU29sbllycVR0dUpYOWZY?=
 =?utf-8?B?Rk4veVhIcVg3STZvRzJ5cHVHOXB5NjhBS3ZuYi85RVIxZTBkcTBtVWVEZlgx?=
 =?utf-8?B?MjlFYVpJSEJGcDN5TU1TbmxsUXhzZFVzc3F5WnpFd05zdG1RUkp4U0dGYndp?=
 =?utf-8?B?bXBNYmphUzEyUzMwSWVFRVFobDQ3Z3o5TVdzVmhmTnVmM0tEenJic3JCckRo?=
 =?utf-8?B?TGNHVUZDWVVGVjNqbnptQ3Q4d2duNnhUQSs1YXhkNXFQZUlMWFRYenM0RGQx?=
 =?utf-8?B?MFVoa2ZyWnFvRzBKSkdhWFRwckVLWUtLenhLTndxRHlOaDVUeFVJYm81Nmxp?=
 =?utf-8?B?K0t5VHhCZ2tZZ2taUVZGRUFjNzNveC9SMHBMN21jSlR0R0I1bTRNRW1STitm?=
 =?utf-8?B?eUV2czk0dTRxZ01reUx2Y2twWXdPTFhaK2JQbHNxOVZ5MFQvSUpKRjFOMHE3?=
 =?utf-8?B?U1hMUGQ0djJqZ21OMGg1Z2U2MThwbmZGYVZDaDBFdG84U2VwWVU0SGpEMzgx?=
 =?utf-8?B?SWpmbDZlZ2R6R2FmcUw4ZjJmYTNYWWpONXpBc1JMZGhTdkMyZ1ZxSzdMQ3VR?=
 =?utf-8?B?aDE0THdldVZ2S2RSK2xvYkpxL2NEbUp2ZjE2bjdhRVBBcjIvdDh4TEJyRU5I?=
 =?utf-8?B?bXc2R29zOFhpcExwVGVIUUlsMUxOTlZiZ2lGdzlUTVBqWDIyMHJDRXYvamtS?=
 =?utf-8?B?MnExbEY2NmhiZGxQVExMUDFqRmxEQzMvM0lqd3BvQmhITFhZRXozVXdLa0dm?=
 =?utf-8?B?S3ZURTlHYktwbXdwaXlxRDN3WkZvMVBKVlJvaHFNMTFaUGR4SmZUTzU3MUZE?=
 =?utf-8?B?b0xuOFAxeFdXMEtvdmhvc1B3eXhpb0FkZXkyWVdiajFEWkx1UGJ0YUdnNk5n?=
 =?utf-8?Q?9IbWtHTgapM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGV0bGEveStjR2NkQVNyZjQxUUhmMXZaZ055N1BXS0IyZUM4d29lR0UxR1VY?=
 =?utf-8?B?Y1VHZkU5cnk3VkhTejRyZGpOSDUzUCtyVjRQM21xd2lCRVNMeERoelRtNE9x?=
 =?utf-8?B?ODh1NC85UEJoRTNXclg1QzIySk1TM1QyQWErc3p4U2VLaDJIUi9wOHN0cTd1?=
 =?utf-8?B?WjFqTkNncjk4ZXNTVXJrQThvaDQvNkZKbjRWSVZYcTlpcUQ1V1VCblZtZ0dq?=
 =?utf-8?B?SDN1MlVHZzVUZXdDS0JrSHVnZnBkY3RaOS9xV2FUTWJrYjVTNHViNzdmQnlw?=
 =?utf-8?B?a2xURSs3RTBTV0YwVnNFWFhkTGtvQUUvQ3Y5WDMvUjdtckNDNDU1Skc1MTlC?=
 =?utf-8?B?SloxSUlsSEk4dnNSSHUzYjJHbUVnQ2RNdmZmcjNEQmdDUkNTZjQxekE4NDJ5?=
 =?utf-8?B?aGFNaHdwdVpjQUFmejNUa0lMdnA0eFBMeWsrclk1VG5acmdlZ3FTdUhOcGlo?=
 =?utf-8?B?dXB3a1Y3SHV0OXpqQ3g3OWRmSFk2dGwwMnlxZFRSUHFmdHZXQzdPVkJhM0RU?=
 =?utf-8?B?R1ozQzU5Unlxa25FZVgxVEhwN1FJQkRzSVBleTBtZVpHb1BDaDQ1SVJaNHB3?=
 =?utf-8?B?RU4zRmR6SW5jT3BaMEg0T0hzUHpDRXlPS1lZQWMweWV4bFh4dzhwUEI3K1dl?=
 =?utf-8?B?SkZwRDNJWkFoNHBQbUl6YmhUcEZYUVlPdG1YNG94amd5NWtROTBRWXVGQkti?=
 =?utf-8?B?QjIvenhKSlZjMVJKMXh2cGd3N2JzanVHSENEWWNTZ1d2a21CK1NOUmIweEI4?=
 =?utf-8?B?T2w4blphOW1UTDNTSWRvaUhtakNBeDgra0Fxa29WaUFXT0F3NW83U0oxQjhP?=
 =?utf-8?B?RlN6Q2x0YTl2aTdlckdaTWdFdFUzd3J0TVZER2kxYW5nOGtzNDhNcFBIRUxn?=
 =?utf-8?B?blFpLzZPdDdKRmZMdUljbzgyQmdBRHlBTGJDNEtZQ2QwSmVZR1Mvc1YyUHRM?=
 =?utf-8?B?dHJRdzhDajFobWFzM2tPVGMvQ1NJMEIxN1IyTTlld3ByU2gyeVcyMklGbUc1?=
 =?utf-8?B?WWJhMnlXV2d6eW5iWFhvVDFPOVIxaDBYR0lNTkovdVRXQndyVklaODNjYmJQ?=
 =?utf-8?B?Z2RNQ2JpZTJQQ0x4M2R5czV5ZXQzcVlUeW5hUUpoc3VaSlZQL3JHR0RBOGxv?=
 =?utf-8?B?WHA0U3d6WUJCcmtoV0NKRmcwSVM2dFo2VlVyQmprTG5aakxMdVhVbS9QczEv?=
 =?utf-8?B?M1pkSS9WaHJlUWU4Y044NjkxRjNJZ1c0akJxNHNiOWM2VmpYRnc3eVExa29u?=
 =?utf-8?B?U0p4TDJWYW9GNm1RWTA1VXhaajBKUE9nV2tPd3VndVRJaXd0OGNuR056eEg2?=
 =?utf-8?B?UXFsSVZ6RGdBalY1NGYzclBJclhvY01UQmF6NVBXckFzK1JoZkw5Y01yVHpi?=
 =?utf-8?B?R21tbHBYMk9UamwvUFBYTm1BMkNoRDUzdnpYdkp1TXdSRGY5Sk0weThCYUFw?=
 =?utf-8?B?aEgycVJpT3RvOGtNRzdBbVkzVndxN0NudXg4Z094UkRRckdqVEZwamRkLzFW?=
 =?utf-8?B?V1lBMlJ2WU1BSERVSDRPaFJZUWFjY2hNMkpTMnlhV2ZKNFhFM25TU2ROMTlw?=
 =?utf-8?B?Qnp2YUNQZ2RyaVdwTVpnNm1LUit3MnlqY3RYNkkyZlIyWHYyaU1xSFVhbnNu?=
 =?utf-8?B?Vk1ob1lZU0ZVWXNSY09HM3d0dVljKzdSOEkrNENOVlYydi9DeDZDSE1FVi9m?=
 =?utf-8?B?TjlHcmJKZzEyUjRtUVJvcDJhb1daZnBmcGdTa1NEVnFYMTUrYnRzeUdyZUJN?=
 =?utf-8?B?K0FuMnp1NlRWNUlyRHFWOG5iVmNtcU1sNEhqRWZURWh2cDVkQURhbTBGN25Y?=
 =?utf-8?B?UGh6K3RRakNUTjNubzBUcU1rN3FXbVFTc0g3VEpYcGtDd2JwWDFib2IreFdK?=
 =?utf-8?B?SkhJVzI2K3I1M0YzVHFiR2JJdU1TdzRXelhCQ0xoWUh3eE9RSm9PdzhPSlR4?=
 =?utf-8?B?RUdYSHRqNWZnYjI5bzI1akVkVXhLeTkrRHlualFGZzMrNWVGNmM2enRiYWNV?=
 =?utf-8?B?R2VuVjBOOWdaNkJmTDhxUDVZcmFlTHlVS3JDWFNMMGlqUUtUdWg2MFJ5cDFG?=
 =?utf-8?B?QjJSYjJxN25CZVRhN21INkY5UEd4RS9hV1JXUWd5TllHTXU3ZUw3bmtvZXFa?=
 =?utf-8?Q?KB0IJq+s48LZp2509quz5oZyC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee475a8e-7a14-42e2-2294-08dda732e2b8
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 08:51:55.8101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEB2ssTOcaymSe8sMsKCTmFMYDjL9es9nj1oHdS+4/EHdGTomVTxU0nLC3530Kfd6VtKhKFETK7sdV98SgBLaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7943



On 5/5/2025 10:20 AM, Nikunj A. Dadhania wrote:
> On 4/14/2025 11:20 AM, Nikunj A Dadhania wrote:
>> On 4/8/2025 3:02 PM, Nikunj A Dadhania wrote:
>>> Changelog:
>>> ----------
>>> v6:
>>> * Rebased on top of kvm/master
>>> * Collected Reviewed-by/Tested-by
>>> * s/svm->vcpu/vcpu/ in snp_launch_update_vmsa() as vcpu pointer is already available (Tom)
>>> * Simplify assignment of guest_protected_tsc (Tom)
>>
>> A gentle reminder, any other suggestions/improvement ?
>>
> 
> A gentle reminder.
>

A gentle reminder.

Regards,
Nikunj

