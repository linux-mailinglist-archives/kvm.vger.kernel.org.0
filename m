Return-Path: <kvm+bounces-32957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7519E2DD0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 287F0165B2B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E97A1FF7CF;
	Tue,  3 Dec 2024 21:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x1+Iowot"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF9F1D79A0
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 21:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733260107; cv=fail; b=EuYfu6NBplxFtgSdC1EZqOKbwSbJLEvfaFj2zydgt0D0FUoGKOxLzEtTUODiT8UYG0LvvntPIZUIFIJXExOtcjCLOgjp4FYJdvLOFe8GyWAoNjaPmuwJ5StOLfw0S/UGt8jTkxzaO0BnDbr80UXsfk7aF8d5dzg1260RC0WHJaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733260107; c=relaxed/simple;
	bh=uup0Ga7Vr7xfo6njdwCiiJmPJ+G6+hWyLL2yAENuvAM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FM/hdgMMTheYXOWaYrV8q4zNNxqrgrhH6s/hvhoMOut4A0U5xHhoVB8fOAlathcDOPXatNzpDA7IAZXuF6qJTLrzi46TilScwkEl7v6WH2Uh2eIwMaiWh5cmGRP/IJk6U//Ke5VZivyr+NCAZqrysebgTCbvNrBlznoIphU2OGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x1+Iowot; arc=fail smtp.client-ip=40.107.96.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1GNDnU3igElFUqGpadrVw+RyKEO9BoJIjyNYhSPvEvIpsztiBMQHtWUZpk9r2ErOnx6C9tXv/rl/o+Er0OfI+hOCzNAmJQRS4WCjmmHBKKURkf+WUWdajVTtPs3Smx3RW/pYkn3BY6zb192UqRsI3v7zR1ykbcGXY/27Uq69S3CoupDJBZb7HbhIwnRcvQD6hkCUZS3/38boc06VS9mrfTg6EC0oWK/h+SpRBspXht7d9mlQQjuDaYo7dvYfJRrJ5Hf6bMlijShVmdm67FeIeAtT1aXbtHRq7DOE12M3Uxz610xRkheQ02gD/xpUDcRnOlAihVKTP5mK1q4ot8j9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo5IUnqQHwToJPs7lmWb93ym93piglgNxszXAxb9NAo=;
 b=B6F89XLyiCmnsbxR/YPNc1OAhNR7AYpGAMtLZPJLFyYqc4s2YBSahVtFALXuXWSheH2FExXskzkyOZ77sBkL1zKG2H2GVnZCNC5vtLCao6zOfnsqquP/PalSu6dCMd1+9SCO4LJhRmBil2/fEnsNdNg9PZhhE2ocUBWvbZc+GtaCd/74rwsk5kdbJFu3MY+RcSeNtsHT1zjlAurs38Hw/nzzJs7bfSKKSB6SNDXww3gghLeSaNCC+ZU2oAJMCTVTpjSBWexK8XcFphcGO4lJ0luAgYcZeOdAMbFb2fAvjz6H1QGea2lEWvXR5JFNmdS9n3diL3eYKg18q5A4KfcUrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo5IUnqQHwToJPs7lmWb93ym93piglgNxszXAxb9NAo=;
 b=x1+Iowotitin3IepVDVBUknmwaOAtkXGRp5h8Jv1AWnZ4SpQfEc3TpUtZVlMIIHaUQpVfNMAXyqRw5RrsegbnSH9cW1LlmX53p64thdNbINuf2m7pHnNUHUv0QxBKBxhi2imbDeu7vGjw9Vk9g/beuK0bG7c65qAAEPC99Ag71I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6225.namprd12.prod.outlook.com (2603:10b6:930:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 21:08:22 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 21:08:22 +0000
Message-ID: <d4eaa16d-c49b-80c2-4e4b-8934f59da199@amd.com>
Date: Tue, 3 Dec 2024 15:08:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/15] KVM: SVM: Invert the polarity of the "shadow" MSR
 interception bitmaps
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-4-aaronlewis@google.com>
 <Z0eEPSUXE8bxhekH@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Z0eEPSUXE8bxhekH@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0149.namprd11.prod.outlook.com
 (2603:10b6:806:131::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 2090f2ed-1b80-4afc-32a0-08dd13de9e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3JXWStwYWVKQ3Q1elNJa2o4MENhbFBXL2JHR3hPOHVKWUZSVHRsOUpqQXpm?=
 =?utf-8?B?RnFpTGlKVmo4aEVCQ01kb3VKVjZaV2RiVWtPRURVM1lzSUh5bEpKbFJEUUEw?=
 =?utf-8?B?SXExY1RBM2dCcWc3MXFKVFRKTm56bkVvTjNwdUJ1dDhWbmRIV1pPMi9kbU9a?=
 =?utf-8?B?WUpHbE1qQ2VEZURNdEptS0lETXBZNjlVckRZSmlKK2dhY29VK1I1bGd0NDEv?=
 =?utf-8?B?bVh4T2ttMnVMckJTNkdqekh5bDJHckpNNmFqRmRsejBiT3JCNFVBS2ZSOXor?=
 =?utf-8?B?SXJ5SGozMXdjR0dkU05Kb1BZa1NjUkloSzZDRHpxVGMxeUFmczRUNnFReDRE?=
 =?utf-8?B?YUNucHFubzBxVkJ1QXkydGtNZ0h4RHdMUWp4SVJsdk5TZ0N6a0hJWjBKZlZB?=
 =?utf-8?B?Qk1ycG92d2h0ajZDNSsya2UzaHUwUzJwK2wwQlhaNTlWWWhHYmg4TytvNFBz?=
 =?utf-8?B?NGJPOEZWYzloNnFUVG1FUWJ0ZEZPcUV1U3hhYUxSa0RWM3M2amVLdUJXVzRF?=
 =?utf-8?B?ZUZaWFFFWll1SEViOXBGTlIxZTBHTHdQNHVzdW96c3I4L1Z3WXlaSXVpanN5?=
 =?utf-8?B?QXRURzBkajlObStDWVRGTlpGWmhCNFhjZjJCa1ZseDR6dEpIYXlmMENsc3lY?=
 =?utf-8?B?VEh1NVl2dE1TTXRsT3dEcDlRc3VwM2pMaEFGZDBMUkhZd3M4aFNneVArN1Nk?=
 =?utf-8?B?QldUYjdPRXByWDZYUWxWTGlkZmE2YWtuVndNMGdJNVdhTU5aMU5DRDNvS0Y4?=
 =?utf-8?B?VVp2T3hPTEVMNy9XYmxwSXFDNmxqSXpLWS9LZThlc250Tk1vZVY2TXk2SzRj?=
 =?utf-8?B?ZGdHZ2pMZzVMQUx4RnFSc2hxUkhERC95TlU3cmdIKzNDcVZEWTgyQUkyQnlY?=
 =?utf-8?B?WkMwclZZeGRsUzFzcGZrczBxNFJ5WmRFMXVLVjQxV1dkUnc1TUVBTGRGWW91?=
 =?utf-8?B?YXdtRDg2RjV5ZS9UZVhJekxaZnVJUVJXTmM5a0JDeHo3aExIbktid0YwckhN?=
 =?utf-8?B?WjExak9QQ2pQWkVnYi9xcGg4bGtzTkhaNFdpcGZVb01jNkFicXB1MUFzeG5T?=
 =?utf-8?B?eFJUbTRQVzZzU21BekNQNnZYd0RVM3h5VWMxN0VvQTNQVmlRVGhhSkRaWDRK?=
 =?utf-8?B?elE4ekxDRmJ2SGd1cDJZQkZDSzZmaXVQWmZtblJ5YjgvaTdFVUZlRmRBanp3?=
 =?utf-8?B?bmF5NGlKT21KM2Evb3MyRFIrOXhveVdKOVdZZkx6ejFyc2NDeGZGdUZScXpa?=
 =?utf-8?B?ejhBbFJSYzhYQk1CWnBkSVFJMEJCaHY0SlNPNk9iY05aRTliSUo5QjJXaURo?=
 =?utf-8?B?dlhyb2pkZ3BsQXY5dmIwS3YzL1J0bGxHQUhVdENiMjVjTXlJSVRickFpMXBS?=
 =?utf-8?B?UFNrc0QySUVMSkg0aUhaa1VZMjEwM0JmaVBjdzBwZmR2cG1uWG5WakFUaS9x?=
 =?utf-8?B?SEdaNEZ3RCt3dm1KZXJIeVIvUXcyVW45QkZxTGpCZTZqa3czRXRDZkJBVFZm?=
 =?utf-8?B?NnpNcldOZWFBWHNlQ0JOeEZGVFk5aUd3eE5NbXlBVW1FQzhFL3o3SFBnRGNT?=
 =?utf-8?B?am9OaGtVNklCK2xPOXd3aWp0Z1hlVlRMZzE3Q1ppdDdIMGlyNVowbFdKdlZP?=
 =?utf-8?B?UnhLeHRZY2tqd2NZajQwZ0t4cjQ1ZnB3YkZKRDZFSm52SDZKTElLa3hpRk1p?=
 =?utf-8?B?NUhoTkRtYldnbkc3UUx1ZndUbTF3SE9OZGtjRzFtLzZwSGVzWldBT1BCRFk5?=
 =?utf-8?B?bTBCdUttMFBmSU5JT25Ka2I3WnR0Y1ZyalZzcTlpWlVISmRNc2N0dk94dmpa?=
 =?utf-8?B?aExKMnQyZXA3cFpvRm9GQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUpQYnlIRmoyWFdTUmhuaXBBa0daaFVoSlo3RFF3cFUrSmJkdjFFUlRnNG1P?=
 =?utf-8?B?NnpReFd1N2hNcmovUzFTUE5mOHZlSC9ST2JsQjJ2N2RMNzduN3ZNOEp2dm5I?=
 =?utf-8?B?aU1iVHJGV0hvVCtsbVN4TUVjc2tYWml6TXpnYzV5Ync4UXd5OVBzb3lzajNh?=
 =?utf-8?B?QWg2RjM5aURmVU9VKzNUSjMrU3Q1elExTWJNLzFnUEJDaTdWd3BydUg5d2R0?=
 =?utf-8?B?ZlFlQVIzZC9FcGxxcWhSQkE4cW9qTFdpcTJEYnAxYlZJWG9MVUtZN1E4TDJW?=
 =?utf-8?B?ZDdyOG1pM2pmUkpGRXZKWXlTNXhreWd4YXRxeHVTTllGUEQ4blJ1aGJ2enpw?=
 =?utf-8?B?cXZjZm5JcnhMcUtreUswMXAzQlpMNGVaNktQMGFqOE4wOWh2ekVIdE4rZktV?=
 =?utf-8?B?VG9SRVBuRy9iT3M2cmdKbDUyemdLbmNzYmoreU10bmRRVms0S3NOZytmZXFM?=
 =?utf-8?B?blV3UGZUb2E5SnE3K2w1Mkp4eWZKdk5xVXYyMG5CV2hXNnFYVHBENXV4WHJG?=
 =?utf-8?B?SFBabkY4OUkwY1luc0s3WDgyQlcrMHZqWlpZTllGWUpCWkF3MWMyLzFteTV5?=
 =?utf-8?B?OXJZT2xXY1NwMlNYU1NXVVJub0RaZ1NWRCs5TVQrdU40Nk9xV2kva09DQmd5?=
 =?utf-8?B?Zkt3MWpUSGk2dVhHUDZTa0xmTlQxei9XQ21uVE9RTFZ2L2cwKzFJUTNRRXFh?=
 =?utf-8?B?ZVhJcjZ3RTZuRmdaTHgzODQ1MW54VFlDd05IQ28wdkhld3hiSXVDSDdMd3dr?=
 =?utf-8?B?THVUVFBYTEV1djlOTDVwZmtOTU9WSUxGbEh5SjRQOGcvZWh1MmozT3VIZTB5?=
 =?utf-8?B?a0NZMEpkdFFBR21OTy9pWFlSZzdxUjh3MVZrMElLQVQ3ZXJDWkVQUjNzODBt?=
 =?utf-8?B?ZmpJSDZFL0F2Ymw0dzRleFhwSFZsdXBYK2lUS3BHT0ZFZ3ZCYjJ4VG9TN2dG?=
 =?utf-8?B?dGV0azlvNnBZeXBZdnkrMnAyLzk2UHFtbWluS1dlNmE0UFVQMkpsM0N5dnFz?=
 =?utf-8?B?ZFpCWEx4REhtTHdNc2MrWHA1b0FoMEV1N3NPNWJ2cG5RKzhUaytpT0krc0ZX?=
 =?utf-8?B?eEJsMk9kdjg1a3QyVHJiU3RzaUdjT3hyTDc4NXhNcnUweHAzVmlBamNadGR5?=
 =?utf-8?B?dzJ4RVJLdkpWVldyc1VsTTRwbEE3SHdobTZDaHRML2Vja2VheGVZNHFobWMr?=
 =?utf-8?B?eUxYREI5ajZZazAwWktNNk55T0V6UlNoY21ySDA0dTZseUg2L2x6NnppM0JB?=
 =?utf-8?B?T2FZMHBjSEdiaXIzTHNscnJmOGhJSWNFSnk0clJJdWZCV2p5bER0bHFReHYx?=
 =?utf-8?B?R0F5Mi9uN01DOHZLZXR4cEE1eDROSCtSdjJkQlVHOGFqYzVrQ2YxM2NXN1ZG?=
 =?utf-8?B?N0pCNFBvV0xBeG9nSzNvV1lWaGZzQXBqT054N0xkQnpGME5KM2NHQ25RdjV6?=
 =?utf-8?B?SEJBS29GVFFXZUFqYk5sVHhEUDU2ZkJoVGEzTzhTNGRCZ2U5WGxSeENMRTBN?=
 =?utf-8?B?dnUwVXUwTVU0dU9RL0RGKzExZ2ZkNmdreGpsZGg2WUJGSVY0RmpqcUpjaksy?=
 =?utf-8?B?WXZlVDN0aWk2bnhvOWFUcUMxQ0dNZTR5MWtxMHExT2w0OUFRc1R2TWFhMHh3?=
 =?utf-8?B?R3pSQTVMeDJORGE3aFZiSWl3MURTaWZsRitaY204L3paUVUyTVVCdE5FUlpU?=
 =?utf-8?B?elJROFZhcFd3V3VISWFFTUJDbldaWDBVQ0ZqNXRDdk0zSy96T1N6NzlqVnJH?=
 =?utf-8?B?TWl2RkNlTDVFaE4wWFVYYkhtSFNlSDc4azZPdk9RK1M0WFh2azJySUZBcHJP?=
 =?utf-8?B?NEFvYnJiVUxWQ1NzQmJxQXdZcFBHdkY4QzY1MEV0bUxCM1AyTktjeGlsWjlz?=
 =?utf-8?B?OWIxQUpXVDQyaUU5eW56OWpkOVNPejh2cnp3dGJXaUNnZkxuZDBjMHBaTUZR?=
 =?utf-8?B?dm5PWG94N3hNSzVrc0dzYWhZZzF3eFF4UU04SzlaZlZqZ0prZWt3Y1kvUTMv?=
 =?utf-8?B?aGxOVXdjNXovWVY5cXZOQ1FiWnVHQ3ZLU1N4MDFWR1lZWCtRVWdwQ2J5TVM4?=
 =?utf-8?B?MG93bG1vYzFSelNpUVljazk0MTNFRVlXQlVZenF6YjdKa3dYdTdnT1JxU2FG?=
 =?utf-8?Q?JXJ+upxOBa1w+t1+N8zES/ive?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2090f2ed-1b80-4afc-32a0-08dd13de9e9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 21:08:22.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYCg+CMOxTjjDg+3mXFZQZefD588r81h3fn9AGHaOnHIYWnC9Jhl9un3MpBH/tGU2sTRF04LzV8lkALbGPgObQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6225

On 11/27/24 14:42, Sean Christopherson wrote:
> On Wed, Nov 27, 2024, Aaron Lewis wrote:
> 
> I'll write a changelog for this too.
> 
>> Note, a "FIXME" tag was added to svm_msr_filter_changed().  This will
> 
> Write changelogs in imperative mood, i.e. state what the patch is doing as a
> command.  Don't describe what will have happened after the patch is applied.
> Using imperative mood allows for using indicative mood to describe what was
> already there, and/or what happened in the past.
> 
>> be addressed later in the series after the VMX style MSR intercepts
>> are added to SVM.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Aaron Lewis <aaronlewis@google.com>
> 
> Your SoB is needed here too.  See "When to use Acked-by:, Cc:, and Co-developed-by:"
> in Documentation/process/submitting-patches.rst.

And actually, since the From: is Aaron's name, Sean needs to be listed
as the Co-developed-by: (with his Signed-off-by:) and not Aaron.

Thanks,
Tom

> 

