Return-Path: <kvm+bounces-57021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872AAB49C1E
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B3A144377A
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61236321427;
	Mon,  8 Sep 2025 21:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aimBWGB7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC41320CA4;
	Mon,  8 Sep 2025 21:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757367152; cv=fail; b=kHrTsiK5Jdo5hfaxDgqZ+3xOg06AJ8LN0b8w7ewXwINFrpZzVBEuWIAms4ldMo6CQH8DQT76QeabnjfyiqVFXnNiNAUJzc7yDXfCezVlH2uaw7bs2TRlbWYKeIqOv5tjIHs7B/wcX8SJrstRizrzjPzH7JowJXUQ/48lGvpbX0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757367152; c=relaxed/simple;
	bh=9H/V1p5oSejuqClYYlp2VftGw2AqCVLG09NJ3sGJ+vY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=APbfo0GMfLbEU/JowUmg1qyvpTvpLFLcMQekZtyRU+7i44NKmR3A34fH9uhKRRYlOpH3cIZyZq/HwSZXOZTDPEWksxV7FmYVz0qpIbvkLPSb5GvUb9yJIQlX6dbufak6ENFIRf52nn6i7NzHN1tas/QHpXaaHjJk+9mfsC5tLZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aimBWGB7; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZm8QgPcJm3k7Uo9q5QRb5n+QmntcgtriCTOge+xFhdvBs6+Tj1b+bL6d5K4vsjrrdViHcv4bppBCEgx85wVEFGGnGbygZnMX6X6UmKjNS0KE6+OBdv0Gq5JcMStFqzYXUEuuN+MS8WIlQc5xllmcJGWLX6mnHmvFbdHahDM4I9iygmgHdmM9sbdsJJdZjdV1lTOZsQ+NuRY9d/osxt/tv6MeRKIyCp5x4AJBJjKk1y59ED8GN9QdLsOQYDWvrfnYheQrLFHmex5K42MU6aKVikc6H8qFG5dItw9emJpJ92pEeO5nFlDWJDBZBpMoT5jlTJJZ72PYZBSW+Ezv4JXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjcZrAKcaciGQWYfFekrs5/P39C4A+gBNwi8ynoOiq0=;
 b=V7EL7H+doJlXrj4Bvk42Y9KI83hrjmciPAewy9V9eCNV599aXWiB4pwp+hNdEgEgzjmDI4AdvKk+JXc2luwAmblhCX09GKokyaEczXtUA2S2HrWepXqCZVjyF12rUiYnJpdyS13gHBwGYafSTBDu0kk+rTS7HMO9dzo6cUzx/pbiZi8qUo2/YrfZnSePJja5UflbwoQo22U1lmQdNnyVLLS8d6NLnsh67dD0+umX/tL673hDZONYzKeRc0WUj5953f5ygSriOnKRd601tdszsCeDaXd/cN0mhf1pkqTTJqM25S2+1WT9+R7AOQjedIqNYy/Lcm8OlJjGd1tqIJvU7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjcZrAKcaciGQWYfFekrs5/P39C4A+gBNwi8ynoOiq0=;
 b=aimBWGB7sf6uq8moMT1Pma5rutysuVdXptSQZD5uIrauIkKf5PN84i8qN1NRBuRKK1l8MAnNXSlHmXPZ77h4x9ZPEuaxWXubC1C0HFrW5H+XSJML+KhgC9qY5hyelQ7Vi6Na/Bb3qqZaAfbSY+Q0WBRNjvn13vJHQ15PnCNiiwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM3PR12MB9390.namprd12.prod.outlook.com (2603:10b6:0:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 21:32:28 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%6]) with mapi id 15.20.9094.016; Mon, 8 Sep 2025
 21:32:27 +0000
Message-ID: <e32770ac-2bc8-4e09-aad2-0fc219abfc8b@amd.com>
Date: Mon, 8 Sep 2025 16:32:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1755727173.git.ashish.kalra@amd.com>
 <5228c35436be214bd51dd8f141afad311606972f.1755727173.git.ashish.kalra@amd.com>
 <3c96491c-dceb-2a6d-9c7c-b5faf663a184@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <3c96491c-dceb-2a6d-9c7c-b5faf663a184@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0153.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::8) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM3PR12MB9390:EE_
X-MS-Office365-Filtering-Correlation-Id: 72881576-1220-4833-6b6d-08ddef1f3544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkdEM0NhZ3lPQ3ZEb1NOcGpKalZYRWMxbjRiYUx6dGVNQ05LbVpEUUZBMklB?=
 =?utf-8?B?eGE3WjNwVGk5MitzT09NSkIxR3BzczJhWWRFYXE5V1hReGh6b0xJZ1NNbXpH?=
 =?utf-8?B?VG1wbFRnUFdYS0FmQTBqQzUzV0dkV3F3cHFZNFVEN2Y3Q3lxS08wVkkwY2F0?=
 =?utf-8?B?VnpFWmo3bnRxcHdvb1MrVVU4WjJYVmNSNlNQL0ZOWHJZc3VwKzZ1TFRnRXI1?=
 =?utf-8?B?ZW9tQzNyOWpYWWtxUGptMkFYTkNKZnpGUGYrekI1Y3hjenEwWjI5VzVTcWt4?=
 =?utf-8?B?OVdBLzR6ZmFvS1FYalJDb0ZSSmRCL1EzNlBnaDZDNUJIQ3d5dXgrL3pCUVhq?=
 =?utf-8?B?MmYvZ2o2b0Ricm5qY3dDUnNTYmY5NmdzOWpHcTBRUHBjbXJscHppSi9wNkRW?=
 =?utf-8?B?VHBYalJQY3JJSEllREdFRWRjNUxadUMzTWRDaktZU00xczN1OXRxQkRQYitK?=
 =?utf-8?B?dm13UkhPbzRweE9LZVA3YkxJYnk2S2ozeEdONzdxR2V1cHJ0N01xZnFlOGdB?=
 =?utf-8?B?TTBxQUQyN05xdFp5OFhGZFp0a0I0dGtMRTdZSHg3bUxIMkZ5dTRqeHRtVGJO?=
 =?utf-8?B?UXM0NWU5OW50eldPZGxWZXZCRHR2b0FGRG1rak5oSTBBb2trditHRnpub2Q2?=
 =?utf-8?B?OUg2cHo5VUdvKy85bWVYQnNZM3pjdU9ZeVhIZWZGcFJORmsvbWVsRGVBQThi?=
 =?utf-8?B?M3RWL0xDQy9YK2srbENCMStUU2FkUEROWExLTFY4Y2VIeWtsYmJnUjNIbEhl?=
 =?utf-8?B?b1F4Uno1cFVGSjhrUFYwTUQrSERHZjRrQlhxZ0pHWTJvdDV6cVg3blZ6akd2?=
 =?utf-8?B?TS9JUGpJTUs5SzhLdDNBSUlZNXhleFlkZHhJdUxEa3FvSG9tbTMxcTh4RERG?=
 =?utf-8?B?alp2TkIxQVdRdmp2K3FCNVllT2ZVeFA0a01mbnFxMTMwa3NLUlBGV1QvTGR0?=
 =?utf-8?B?WTlGcjdzeFoyMzFjdit1bTJQeHB1OXo0K1VkMlFlQUJmZ2tGSGhBYzgrUE9v?=
 =?utf-8?B?VXN1enZrd1VNeFc2c2tMb0tuMkg2WHVLbnpNTkFubE5vZlg1WENlU2luODhu?=
 =?utf-8?B?endJZW9pdDRtRVNIY1VBWEJERTdoaWpQWEFzQmZxa2IrL2lYT0xKREZsYk9U?=
 =?utf-8?B?TDNyOHg1OEZuOWs0b2tCbHFGQ3psY28vZ205LzVpZDVPaUZLRkFuc1hLc25i?=
 =?utf-8?B?Y3BKRTJNUTh0alBQdWZPanRoTis3NmhXZndTd0NId2wzSHBUdVRzVXQrYmM4?=
 =?utf-8?B?WkVGS2dJRkpKeHN2S2FlVGtJYjhsTzVkSkJsOSt0MDhyVXFmV0lCbTYyd0NU?=
 =?utf-8?B?UGJDdE94aE9zbFhDZlR5ZCtUL25JR1B3NittRHVjUFZ2MjBwRkgrVEQrUUU3?=
 =?utf-8?B?cUtNQXB3VWdSN1RiVDVWQ3BWTy9VRnhDT0FjUzFDdUZ3VDJZZlQrNmY1ZC83?=
 =?utf-8?B?elNOSVhQMWMrNy9oMXpDczFDMFZWcTlRMThLbk5seTZERmhjViszd0QxN2Fr?=
 =?utf-8?B?eTZhN2ptUlpxS3NyS0RJWWJEZTNhdnJ6N1JzV2J3RGtBL3N6VXY0NlRTVFdT?=
 =?utf-8?B?RkRMSE5nc2RXLzRrckFTa1g1REpFL2JFNGRzSFlwaGNnSkFydFBKaWs5U0Ew?=
 =?utf-8?B?Q1ZteCtrRmV0OGVZVHFMRmtiNW1xUzFhOE03V1RTZ3lXUi9tMzNLWUVpOVd0?=
 =?utf-8?B?K2JNd21ueDkyb3RGNmNFQTBwVm9xRkp0YmNQNVpYVXNDSTBLUW4vMHpFdy9k?=
 =?utf-8?B?UVhUWE1sN3l1R25yU2Z4eTA1TE9HOE9QVDhINGFTZkc0ZjBsVGxZeEYzS0VP?=
 =?utf-8?B?Nm1ReEhGREVmMUZpRXFXV0JPd3VYOENtSWhadUZHWEdYTDRBcHJBeVFhTlht?=
 =?utf-8?B?R2lMNDI4cVZKeVc1ZnNoWXpIUlZMcE1iK3lKQTNGaHlWbVNtU25HWjkxZWdQ?=
 =?utf-8?B?NUpnaEdaM21vVDErWWs2ZmlMSWU3VlFEYlNqQ0ZNT2hqMUxDQnNZTzQ2Um1M?=
 =?utf-8?B?ZFpFV3FEZ1FnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFF6NnBKOEMyMWhubzBUOHhjcFFuWnh1amR5aWVsYzJsNm4xNEE3THBIMzhR?=
 =?utf-8?B?Y0MydFcyWGFXc2VFeEtlMkRwcGd0Nms4dXdybnhsaU9ONlo3cnRxWE9HQWMy?=
 =?utf-8?B?MElFNVhLdFB4RHVteit3ZE1ncmhuY01pMGwwRkF5R2plMDN3M09MRnIyTzBE?=
 =?utf-8?B?ak5FS2x4ck1GRkpLNVhmWG5abmp3ZytUQW5aT1hvbEdTeEovMXVaZnljUGpq?=
 =?utf-8?B?OGNTb09uWENnSElQN1p1YUxHYTk2UXYwb2o3RVdBS2hDRW9scnpUVTNURVcy?=
 =?utf-8?B?QVBROGtXbUpaWGRGUUVaQkdWZVZDZWN3eTJQTlpUWVZXenQydkdOa252S0xh?=
 =?utf-8?B?UzZsWERFb1czVnF5ZDNUYzU1dnR1b3psUHlCSTA1YjA3TkJwVGs2RTZPSFVQ?=
 =?utf-8?B?d0hoeUxHNkZodUFVK1Z6a3ZEV0RoVU9DK1Z3c3lTVHNtM2lYVk00bTVETDdT?=
 =?utf-8?B?Vy9qVFVUN29IaE1FbXhVR2NnblBUd0gxTFBNYzltYnJUcDJhR0huSTgxZHdO?=
 =?utf-8?B?bW1DZTE3czBLWWZLeEVuNUV6NmdPMEozWkVWN0RKUGtwbExyb0RpKy9wL3FT?=
 =?utf-8?B?QjJSSnBVSFJLN01pQ0IveDdxcHFzZ3JRM1ZIdSt3NW1CeVpJL2V5bHplT1Fn?=
 =?utf-8?B?aFVhTkU4R3phaTlCL1NwdFRsTDNXR21sNzVhTEpKMnBCdzUxejBPcThJN0xv?=
 =?utf-8?B?cWp4czRLRW04Mi9hbTR0bzl6bUlZZjJsZ3hUNVIwVU92ekhXam5JUzZMMGhC?=
 =?utf-8?B?Z0tNSjlhdE9NeTVSdHpWVTZCcmFIYmlCUzQ3RDk0ZWhobGdZMTREbkQzeG5E?=
 =?utf-8?B?YTRBTW9jWkhUb1NHMjVQYlVtVUdFTjNlOURYcVpjSlkvTlZxSDFtbElmNDd0?=
 =?utf-8?B?UXpDUWZUNTh2ajRGd1QzOWRYK0JuVDVCRmFJYk1VZXRxTm4vdDVVbTNKSDVy?=
 =?utf-8?B?TjNZSjlibHAycUwxNk0wVHplZGE4N2R5N2NpUGdNdE5RcVk3R3ZjVFd4YmpC?=
 =?utf-8?B?a0FacE9UdHV4UWJxK1lQSG9DT2tabWlWd0xQcnNrbkphVTY4aDZUMXBrRWdC?=
 =?utf-8?B?WFlPZWluaHBLTDVsQ28yS1dDMGFRV3VLK2ZXdWVXK0wyd0dRZFF4Mkd3eXh3?=
 =?utf-8?B?anNNKytzbE02U0YxdDRBTkpNMGtjUGdNbDMzSnpTaTZWQjN0dGVQYzRqK0ox?=
 =?utf-8?B?WDUvREZGSFlPelh4ZU5admdNaXJrc0JjYXowakpXK3N4Zjcyd0xaZG9QOFFn?=
 =?utf-8?B?UVFWaFRwaFVyWkhMVkt6REhmOVN1aytNcGdUOEp5cXl5eEhKZjBvZkQvejhW?=
 =?utf-8?B?U0VXSjhMSm9RYlBqM3Vsc0I4ZmtWdVhrR2VTek1FOUg5VUNsWnRKbjM0TTQw?=
 =?utf-8?B?NThPSk1RVitNNno4YzRQVHczaHlTdXAyd2Z6anNFQndwaklaRXA2UjhZVnh3?=
 =?utf-8?B?WUpSRlZyU1krRkJvdERVQXFDN0VLaFpWWisvTEFpZENuTjFLNnFyTUhmTGJ5?=
 =?utf-8?B?UitlaUZQOVFpTGExZmdzUjNKaDNuVVZQS3dSeGZOWDlBb1RIMXh6M1c3ZkE4?=
 =?utf-8?B?N05sT1BaZ0NCbU9MaVExdTNNaHYzb2s4MmppdVk4Zk9tbVFxMWpnaXRqbGZt?=
 =?utf-8?B?Q3NxQnVmbEpoMktKNllnak1SNkJpMDhIOUh3ZnNEMDBUdm5ZQk5ZaW5Sbi9i?=
 =?utf-8?B?b1F3Y0U5ZHNTUVgrSjJ5a2h0Rm1lcUpENWE0V2V3L3FERURDSjVxNjlWQVpQ?=
 =?utf-8?B?aS9kSkRrUzlTYkxTZGR1azBvQnc4bjdRQ2RjblpsTCtCNlNZQ25YSGhoTnUv?=
 =?utf-8?B?TmpYeThyalJ6TkNWSGw3Z29Wa1ZCRTJReHhPOFZXUDRxVEtuMEZYbjNOTFFz?=
 =?utf-8?B?bTJPdUFhZHl4U3pRS0ptYjJZY2xNTGtveXJyR0J2UE14UWQzdGR0KzNLdWZY?=
 =?utf-8?B?Q2pMREh5SzJLWG9FSkw3NktKOHNkWEZabGhZUkxmc0hQbi9VT0lTbDhVN0Jt?=
 =?utf-8?B?V2xpekRzbUVCWGMvOU9CL0UyM3Boc2p3VUwxZmt5cW5UM2lTQmVKRHZCZjVm?=
 =?utf-8?B?UUlWNGVZUC9nQ3VnUVFrc3owdzRCd0hXQnYyeEtSbnFtQ1VYK2lmdzRFWGhq?=
 =?utf-8?Q?+lwGZ2mNcSPcyPq5Sv/THihbj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72881576-1220-4833-6b6d-08ddef1f3544
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 21:32:27.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+MU0E7rWHgx7tp88YVQbXHfdDFAO9FeIGWRfkoQkEX7QvSDc4j1kNmmUKdWi2eW0SK1UScAtZ7vgjdTUdCluA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9390

Hello Tom,

On 9/8/2025 4:18 PM, Tom Lendacky wrote:
> On 8/20/25 17:19, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
>> non-persistent updates to running firmware and settings without
>> requiring BIOS reflash and/or system reset.
>>
>> SFS does not address anything that runs on the x86 processors and
>> it can be used to update ASP firmware, modules, register settings
>> and update firmware for other microprocessors like TMPM, etc.
>>
>> SFS driver support adds ioctl support to communicate the SFS
>> commands to the ASP/PSP by using the TEE mailbox interface.
>>
>> The Seamless Firmware Servicing (SFS) driver is added as a
>> PSP sub-device.
>>
>> For detailed information, please look at the SFS specifications:
>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/Makefile         |   3 +-
>>  drivers/crypto/ccp/psp-dev.c        |  20 ++
>>  drivers/crypto/ccp/psp-dev.h        |   8 +-
>>  drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sfs.h            |  47 +++++
>>  include/linux/psp-platform-access.h |   2 +
>>  include/uapi/linux/psp-sfs.h        |  87 ++++++++
>>  7 files changed, 467 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/crypto/ccp/sfs.c
>>  create mode 100644 drivers/crypto/ccp/sfs.h
>>  create mode 100644 include/uapi/linux/psp-sfs.h
>>
> 
>> +
>> +	/*
>> +	 * SFS command buffer must be mapped as non-cacheable.
>> +	 */
>> +	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
>> +	if (ret) {
>> +		dev_dbg(dev, "Set memory uc failed\n");
>> +		goto cleanup_cmd_buf;
>> +	}
> 

Yes, i was restoring the memory attribute before freeing, but then i realized that if the buffer
is transitioned to HV_Fixed and can't be freed but can still potentially be re-used then who will
setup the buffer to Uncacheable again, but i guess that should not be an issue as SFS driver will 
do that setup again after being unloaded/reloaded again, so i will go ahead and restore the memory
attribute here and in sfs_dev_destroy().

Thanks,
Ashish

> You should restore the memory attribute before freeing it in
> sfs_dev_destroy() and below in the cleanup.
> 
> Thanks,
> Tom
> 
>> +
>> +	dev_dbg(dev, "Command buffer 0x%px marked uncacheable\n", sfs_dev->command_buf);
>> +
>> +	psp->sfs_data = sfs_dev;
>> +	sfs_dev->dev = dev;
>> +	sfs_dev->psp = psp;
>> +
>> +	ret = sfs_misc_init(sfs_dev);
>> +	if (ret)
>> +		goto cleanup_cmd_buf;
>> +
>> +	dev_notice(sfs_dev->dev, "SFS support is available\n");
>> +
>> +	return 0;
>> +
>> +cleanup_cmd_buf:
>> +	snp_free_hv_fixed_pages(page);
>> +
>> +cleanup_dev:
>> +	psp->sfs_data = NULL;
>> +	devm_kfree(dev, sfs_dev);
>> +
>> +	return ret;
>> +}

