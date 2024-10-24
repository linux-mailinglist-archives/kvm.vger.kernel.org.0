Return-Path: <kvm+bounces-29583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DE89ADA68
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 05:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB2911F22B64
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 03:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4475016190C;
	Thu, 24 Oct 2024 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MAEtoByA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C1157A59;
	Thu, 24 Oct 2024 03:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740267; cv=fail; b=i+EuSqVI5BBd23tniysz9Xey4A10r0X1H+vfaa5wTTxv6E2oK81/8/nmmUR/gScbfu20FpZOQ2713fyr/ZDxVtswKazmnv5pdEbZXY+VQOVU5daIeWAjBrcnDcw3LOm1giy9eRlo5+AzczTJkZPkbMfhXnuUnApOmUee1h5/kU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740267; c=relaxed/simple;
	bh=ZEAUcMLFWwAnHfSlhv3n4RiEuswj0Bu7zHrwV04v/sk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Eq3XTsEKKhpFJPjZaQ/n8OjiEYl60soy78gIpAHls0AINxu6qew8EFWzXHxc2ZSvvvHIw4gA2XM9gSZkESyly+wvZpC2ydT2Q3LvdkaITJ3F6w5eadP5DymYMTHCDVYT+pYBxgBswXJl51GCJ0WHF4qDQTzsLldGoN9LNgdY65U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MAEtoByA; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KPjZQTkpteMKH3eiLdilrNJfveoN/yn56sKSXCxSv5Fh7buX1aWE6sU2SMWumEUVBAh4PmvGOUqQexuYwb+EhzRAOgCpA6Zts73UG7sPydF0yz9K6Bciozvyfi91+GwWwqm6U1o7PHfxkS4XEK4lE3df7xFkzgbVEei6Z99KpbUKMxhJwibr3TQTVADxSxQCeYsqL2rjW5RuBOWnucMhaWxqc/yhbB8DoajNNmgEUAY3doWpC1MeDyg5U9wh13BtehSXJNuYNP+SjaVouCbj4Ut2jd4RBqQvDyZoVLjSCV44loJmvVNxjaDJNzsipyJ48ZCrAsiHXdAk7URH5vGhcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6n30k5GJQxsuFQ9KFnMYvvtBpIRhRF97eKm37cmVp4=;
 b=ph9kj9DP1EK6SrGAhLeteQ+BaHv/9aLVvTQc2BZICUivZW4X605DN4H+YPZgQOqKvQNHgIssVEO/b04b9yRBH8IHq86Tt62fy07P5oBChM7j9ZMqcnrhhyX3nY4jPIme6Cy77zmhSMxb3+RrBotD5+cntmA8kf9V168olzdnfS4XtGU6g/8EZEUr3001aE+5v0+sf74PztTNuMSUQ6f/S2M8Uk5/tZ9F3Nw92bF8YwqWWrjlp/34E4dA8GqGamurTsh2n2DUZpNku/8NgV+UhCoaXndfowrnXplE3r+iHt1htC9ayNxfQl2g5r3McLFQfOZKu9dD1AFdaMjs5kPoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6n30k5GJQxsuFQ9KFnMYvvtBpIRhRF97eKm37cmVp4=;
 b=MAEtoByANznZVqa2vRdppMoalzt88XxgXyV5xg9+tiHSnVXJdmMk0saBJYx/uHYniKewyK/6cbjvGqBEHNfPbcqCAmwzfcwzRi6vo47A1DviTmOOlhV3fXTCPnPtavlNMUh5xn0PJF0ev6ffAImNgN5C3sYQrPSu91dGYjtgIVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB8056.namprd12.prod.outlook.com (2603:10b6:510:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 03:24:22 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8069.027; Thu, 24 Oct 2024
 03:24:22 +0000
Message-ID: <02e72165-a32b-48da-9eff-199c52cfacf8@amd.com>
Date: Thu, 24 Oct 2024 08:54:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <20241023163626.GKZxkmCi8ZyyCZlkrX@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241023163626.GKZxkmCi8ZyyCZlkrX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::18) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e696782-7ba8-4624-b01e-08dcf3db5a3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mmd6TEZZRlBZTEdWWlZiTFFGRW1XWkRlMjdDYTdSRktOcnJEQ2xWMWlGd3N2?=
 =?utf-8?B?WnMvSWZHNEFVV0NETHdRNjRMTktobHUvM2V0bzMzUURxbkJ4RkNOY2FDQUlI?=
 =?utf-8?B?U0Fjb1ZGdFB2N0hDZ2UvYlpSMFlNN1BnbUpRc2pZVGlKMUJGUkdRWEJxbXdL?=
 =?utf-8?B?cDBGQnVVZ2NNSW41UGJwY3VBZVhzL3IxcndZUGRKYUdrOFlmZ255S20rdjBh?=
 =?utf-8?B?T01UNzkwWGNxUmFXUElCWEJQLzRZcUNYRGJNRHQ1aGROUWprSmpYdTA4MDVa?=
 =?utf-8?B?d2RwNTU2T3ZOV1crUUU1dEVPZTAwcmhUUWVxOG8ranhVTFl2bTRsQ1h2ME40?=
 =?utf-8?B?N3YwVG9ydG55WUEyS0J6WU92Sy9aeEVUd1Bjd3lqczVNYUhhS1pybnpmK295?=
 =?utf-8?B?d0NVWFJpKzlheDl6TmhmNGY3b1pZVTQyL1lHam5IbFNpQVQvQmZsNWN5NTA4?=
 =?utf-8?B?R0EyMnNjVmZsK0lVV3pPR1l4WmZBSGRydEllcldQcVhRSnRzcExjajMrVVRz?=
 =?utf-8?B?NVFGajF6Uy9xbGxqTFI1L09RTm9jQ1h2YW1tanFKdEQxekFjd25EdWpOcjVl?=
 =?utf-8?B?K3JIWG4xVUNRZGFIZzVTVDlzeFlJcndwdUJMaFJ6NXQxbUYrck1mU296YzhQ?=
 =?utf-8?B?cHNkbGFtamZjNlU0ZGN6T0dNa3g3YUFtUDNjODNIeEZ3QTFvUkUwbFNZWjlS?=
 =?utf-8?B?S0R4K0RJeWtJUjJ5eVRTdVJlOUd1NWIxVnQ2cEw1ME9FVWxLQ3RSaWFNMzB4?=
 =?utf-8?B?N3FtOVFuTVJua1VkZVRyVjlnV1Q5SGhTK0dPQnFFOHdZZnVIR2N6QUEzZEJy?=
 =?utf-8?B?eHVjdkhXTndFaWlVak5mSlYxYkVEMVFKRmZ6bDJ4Tk1NUm1vakFaRjl6Ry9X?=
 =?utf-8?B?eE5KbEExeTh5UWQwaUtsdEprWFBsOWlubU16cUZoUWQ5OU5Dc2pPTGJmS1JZ?=
 =?utf-8?B?OUNxckVUVEZXUFFNVXN2LzZDMXRheTBnU2J6N0VHQnRjdk1IMWY3YnhKTVc3?=
 =?utf-8?B?TEtnY09aT21rUm1RY3BCZVE5by9kY2ZPUUZ5ZFV0aUJIZzRaMjBLcEVjSFlZ?=
 =?utf-8?B?cnN2djVadERHNnpyQjE0cDRJWGlUc29nTWpIVXRkNGMwSDNNSVFrZVFnSDlQ?=
 =?utf-8?B?b0NxVWdtUWpvNmxLdkhTbDlUZ2xxZVlHNHh0LzV4dHk0dlZBTkRrczBXY1Qz?=
 =?utf-8?B?SVk4ckxmNHBDS3JZWTFVbnFKR3pPVmNkZW1sQ1lFM0NRVFZseFZNMHlSQ21J?=
 =?utf-8?B?b1k1R0hwSWxKV1Z6aitQRHc0OHVEV0Z2L1h3SnRXaFhLVDVQTnlDcllNYjRL?=
 =?utf-8?B?QitBTWFVZkdhUDBYZS9zMXJXam9KSHlTMmRuUjd3VGFJMGZGeDNrdkRUc1dn?=
 =?utf-8?B?aU4vQVVVZXArNlg0cWJ4b1NYekdScHRKQitDUGt6VTNkRkEwdzRZcWhFOWZo?=
 =?utf-8?B?RkFNRlhtYWhXQkZ5REpuTEhrYXJqWDF1TWsrTWpwcXJVSm9vZEZMemdCdTdk?=
 =?utf-8?B?MFB1Z0JOQWg0M3A0L1F4aFNlQlBwdWJVekJVYUNDZVZHZ1ozRGZDcFZHelRz?=
 =?utf-8?B?U0pvc1pEaGVVenJOYXN6dW0ydWlENUVuTmwrMUdCUTFiUEZMR3VoeExGQmhZ?=
 =?utf-8?B?SDlFQ3owNFJGSVEzb1BYWmJncnVZait1RFN1STRDNjhsSzQyaGE2NXhUR2V4?=
 =?utf-8?B?V3RoTkk3Wm5GTCt2V1RxbmZGYUtkTGZqTEJRQUYrdHh5Y1lXd29pQlllV3JR?=
 =?utf-8?Q?QWeB8Vn8gkOAK2aecSDI9iQ2WJ1y6HvNUKX1PtQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ymg4MmFiTG9QZEViekh6K1FUaEZZcHZKSExaOHMwRmp6VXFyQ1QzaExJMW9u?=
 =?utf-8?B?aVVJY2FQNU4yV1pLQlYvRHNpclZKcGpQQ0tDd2t2VTV0TGZIdVJpNitka2FZ?=
 =?utf-8?B?RHM3Rk85ZDYvcmh5ZG1GYU9MWTdpUUZVd2FHRSttZmw0SXhHV2oxRFFqK1FX?=
 =?utf-8?B?K0E5a3RKbXFYdHhlSmxsZERyU2g5cVlsZzA1bzZWSWs3Vm5iMzlsQjA3SUJw?=
 =?utf-8?B?Z0JiNnZ3b01iMWs3SWE5dld2aFgvcjNLK1NoWnVHZ25tTTU3cVZTMWJIamtx?=
 =?utf-8?B?M3ZqdXZGUk5HNGxQZm0yalhyeXJCWWdlSVdDNWNDNlhLYUpLemM1cUlMZnFH?=
 =?utf-8?B?eEZ0dFpJMjRUMDBuSnNGaHc2R0FDZTdkM2FiUTR4YnJPeExiVkh3MVBzaGJz?=
 =?utf-8?B?R0NCTmdqdUlOOWoveUZ4MzYyY2NpQjlKdGdLd0puTGIxa3lUMm9HQ3Ivd1JH?=
 =?utf-8?B?dnJ1VFpNL09wYjhHRXI3amZNSE9leHRPNS8rNVdKVzJlazlGeVNyREV3TTd4?=
 =?utf-8?B?ejNGSU9zNlhCWWpQdUlCOVJLbGhOcVF3KzFyT1liVVgrQUFJNU56UzhDcTNq?=
 =?utf-8?B?U21lVkZFQVNOL2sxM24rUllERkhacEJVYTY3cU41aGMyY09CelFPMVhBdVg0?=
 =?utf-8?B?ZHhiRGhjSTRVZlkwcWhaZHlGbys4SDcvM0lRWm1OWkp0TmplbFBXSXVDTXE0?=
 =?utf-8?B?OW1QZlA2QVFPQ0E0QVMzUTE5dm5XdzJiOWlDK29ZOWdaaTdRWkdOMHBzS3cy?=
 =?utf-8?B?QW5YMG9VbnNJNnhJb2dHUG1DeXc3ZFgvNThpczZoczVHTXZIaW1oSFlWbkpu?=
 =?utf-8?B?VmZyR3BFNkpqLzVmUTNhSVR5YkpucmtsVkZTdFFnRS96eXNwOTQwYnhoT3hL?=
 =?utf-8?B?NjhoQ3lJc0F6TFdDdHpYQ3MxaTkvd3NYRU5TYlBLNWNBcDNMT2xOWHZudzNK?=
 =?utf-8?B?b1FrVGxNcXVSa3NBb0JGZWttNW5pUVdZMk1QTVVTZEJBb3FBV2lPb3BIcnB5?=
 =?utf-8?B?VlNpRnE3TmViNUl1T2xqcllrd3pyaVdPZGhWRG5TeEVDWTRucFFKMklJWHdm?=
 =?utf-8?B?c0xOeEVjV1JGWVJubHVpYlh2aTZuMFNmek9QdGw1OFBDSzBoVVBIL0ZLWit1?=
 =?utf-8?B?eEFuMXZJSW5USHJYRTFxNnZ5Rk1zRy9iUVBad2R1M3lnVEhBS3luUitlSzZt?=
 =?utf-8?B?MHdHRElmVmxza09pdlR5T0lrSVhidmRHL09iaG5lQ0dNaXRmU1BuN3ZHcXpl?=
 =?utf-8?B?bHp0RndiYnROVWVCVXdUNVFpa3BTaTVXUE0zNUFvNDdZVXNvK0kzSnZNV0Nn?=
 =?utf-8?B?czdjSzBFN1NJUzNtSVBtQWREVTFzVFFMVjUxZXREK2tHUU1ncFE4QVB4S0hn?=
 =?utf-8?B?SHJRYU9hMzI1enc3cUh6STN3bUpqN1F6d3Mwb3VXbVlmTG13cnEvd1NaSDY0?=
 =?utf-8?B?d2puQXpVOTZ0Mys2MVo2dHAySTlRV2VTdzRySVNZSWdEa0tZQ2tvK1ZuUkxZ?=
 =?utf-8?B?L1o0eklna2NUdjdMMWlpVys3YURHbmN2RUxtdHRoVE4zbXA5THg2a2RoN3RR?=
 =?utf-8?B?d3dNZE9mMlFQYmdJQUpyeWtJbG9jRTNLdEpJdEdZb01Jekc1dU9mQ0ZNME8w?=
 =?utf-8?B?SEVWVXN3NnFDMjcxNWdMWFZLNTEyWlRvTlV5QjliMWtwRjdEQk01dnBFQkZ1?=
 =?utf-8?B?bmVaejJFaGhhSER6WFprQVloSUw4ZlVWbmtteUdBVFJHeUdjaW1GbGFCL1Y4?=
 =?utf-8?B?MlBlVjFsdllYeTQwQjQ2Q0xYd0dGMTMwUVpvMitjKzdZaiszVGIrUGFPeWVo?=
 =?utf-8?B?Q0xYNGd0VFBXeGpVY2FqYW9FNmJMeTNGUHhOam5oSEJGbXc4R3l6N2ZGcDQ1?=
 =?utf-8?B?YThSeDZhL0RySDBQWjNHSzdOL2FTemZScG0xSGdCSmdJeitjTDlNUldJbGxt?=
 =?utf-8?B?MytOcjU3VVRHY2xYTFRjcWxHMDhTTTJ6NWlHajRwMVpLTGhkdVVFVExzSlBL?=
 =?utf-8?B?UUhFU2h0RGZZMlNXMlZtSXl4UzN5WTZnWjYxLzRNR2sycUY2VWl2R2lmbkJi?=
 =?utf-8?B?TWhjRDNnNHBsV1lOMHY5YkZmRGwweGNnTEdxUlcwZHNQVVVsV1FxQ3VPQ2tE?=
 =?utf-8?Q?AOmauva/aHsbrYjAcZrCfMwOW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e696782-7ba8-4624-b01e-08dcf3db5a3a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 03:24:22.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXrJKDw9KzRpG3D92QaVzCBjuOFLp0NnlJneoAGV9XKdLv8FjjQgdF4U98HlfOknWDhi0cesnjMs4VXvKcvAlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8056



On 10/23/2024 10:06 PM, Borislav Petkov wrote:
> On Fri, Sep 13, 2024 at 05:06:53PM +0530, Neeraj Upadhyay wrote:
>> @@ -61,8 +65,30 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>>  	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>>  }
>>  
>> +static void x2apic_savic_setup(void)
>> +{
>> +	void *backing_page;
>> +	enum es_result ret;
>> +	unsigned long gpa;
>> +
>> +	if (this_cpu_read(savic_setup_done))
> 
> I'm sure you can get rid of that silly bool. Like check the apic_backing_page
> pointer instead and use that pointer to verify whether the per-CPU setup has
> been done successfully.
> 

Ok agree. In this patch version, APIC backing page allocation for all CPUs is done in
x2apic_savic_probe(). This is done to group the allocation together, so that these
backing pages are mapped using single 2M NPT and RMP entry.
I will move the APIC backing page setup to per-CPU setup (x2apic_savic_setup()) and
use that pointer to do the check.


- Neeraj


