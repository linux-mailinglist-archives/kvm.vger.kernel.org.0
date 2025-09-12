Return-Path: <kvm+bounces-57412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF263B55279
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 013EE1CC6D50
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE48310774;
	Fri, 12 Sep 2025 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1fdtExs8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3F1B21BF;
	Fri, 12 Sep 2025 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757689069; cv=fail; b=EI1vYizM399U/pPEzql36LTL2gJW4Nmitgi1RrlbCCX6sKLSDJ5thpxSH4G5fKtGMYeIKZkztG3Nn4GtlhmmgQ5kvusInIkXxQXKR6blSbiApFPApgLd6tzrTcfa4D6XSzVtHGx+Ig/XzT+STKJP5x35+5x+FzXvlHY6YtX0UNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757689069; c=relaxed/simple;
	bh=bP2Ou1WWFKc2DDhJmpfkbrW4eEe7zeovcFND+XiHip8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YZ71CRIbVshSsIQNg/3svq+Wr2Q0h2RcgwB/kJ8FN4UnkRWd9SimD53JVkbaAB2WSBGBlaBLdDv3925jCqeP57DIgRZdncMZaJWHDkonD4ATszN9X/h3OOz2RgABSsSL5f56khZHo7uxO7D2yk4SXYM1kzgOvIr5oUqjbMSMEeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1fdtExs8; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QiHwf+Ts9ObZ5hdDaTcXbAQtC7uczs7gHYeCoorYZ3bPnmLJyJ0K3ZsqymKsk2HrWMBezuKI7WuVD/h8MijJKI2YGtz/JDrS+TihSWZ3CKL9BoKZEgPmGLVwlCgT6QO+KEzpAFJsp66CdgZxxCWHCgy/rAAFAJ7kMMKUoLV0uiHoksoDpESgLhfk+zMXtigku87/wePP18wCQLiCU2fnlyMoBmiMNqxRBhs8kmCKkgzssld63DQSJwx/abI+xQCk05jnz1Zhryp/x5u2TFnTEvP3azTLt/3bEpNoamc1Dt2t9qwTfRa8aeMorusGT+c4oGVABE92bq0FL4gpl7KoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+4cSmprEGaLIfoCpri8SRQh5RadlrLugmkXHjvjpEs=;
 b=Fm12RVLzvmgvdN3L2oc2mRC0fJIDYT+AheDb/QBFG3QamvktrWL3Fz6ajqLIsslwWvEYWxallktqjeBp2DxoUNEGN6LJi0FWQIFZBZ7f3eWUcSzbNccjnC5oOXyZtM3nIhirygZ4fVNAKrwpkkMEQ6UeYRZJW9Nw8Aeqw6SwKlmk3/nClZS9QusRyZgS6rsGewIxweDLSBiCffUsdaAItUwnSTPsSRkBsZZ8g+Y1lBh8ngXVbjOv2/9G/5z+oKc7BLnZtV5f3nXRjvXVVjNqfRfhCogm5uUBHDN6UiHKuE6rXUOoPx5STsjuxzaKX3jkxRnJ0mBZxk7EwKXssvP99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+4cSmprEGaLIfoCpri8SRQh5RadlrLugmkXHjvjpEs=;
 b=1fdtExs8ymgBS/KlxwFnFKlU+UVHQjIPklMRB1Y46oqz404VIRHQivPGyn7LOmcp67hiylHol64sXLeC9+x75r1CcjXWZaSb82s3RSClcJnXB/3XaoJYLjWtVn72jCKjkbpmUjWjJ8m6+/W49tEyOShUD5+y3STwzFLfh/1o/sk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by SA1PR12MB7248.namprd12.prod.outlook.com (2603:10b6:806:2be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 14:57:44 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:57:43 +0000
Message-ID: <c36a12f6-33bd-4430-92b2-5fd2939d9b24@amd.com>
Date: Fri, 12 Sep 2025 09:57:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] crypto: ccp - Add new HV-Fixed page
 allocation/free API.
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <e7807012187bdda8d76ab408b87f15631461993d.1757543774.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <e7807012187bdda8d76ab408b87f15631461993d.1757543774.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:5:40::20) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|SA1PR12MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 975d5b5b-b3e8-4347-f732-08ddf20cb857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2I0NXlEQzFQd2NiYmdWWFJ0NG01WUpWM2M3eHpJWmI4ZDlpSUpKb0ptQUdI?=
 =?utf-8?B?aGhIWDhWSW5td1F3TUxMdHlSdjMrRWtCMXJSU09pY2FXOVQ3Tk1ZMEMwMHVy?=
 =?utf-8?B?S1lYZkt3dWs1TDlSWm82RUFmcjB1UWlRSkZjS0cxRVMyMWRhWkV3ZWQxZkJO?=
 =?utf-8?B?ZWszazZLdU1ZYlRtYjI3Z1RHUENvNGxVSGE0dUozalRJV2IzSXJ6U2JSRGRx?=
 =?utf-8?B?K3RKNmxkMTZNa3hFWm5Tb0laRDBTaFBPcXZrZVo1NmdxdDgvTFVTV3lzdWdK?=
 =?utf-8?B?OVBiaVR4Ujg4NnNlTXMvMkZuNm04Y1lDTGYwOGd1THFYa0dwMlNkT09ackFH?=
 =?utf-8?B?VEdVS0dHamZqbS9oeVc0MkVLdDdBSGsvbzQrbTJPTkVRWVRvNE9jYTlmc3pB?=
 =?utf-8?B?dVIrOG8xOEE3bVliL0F0Y1E2S3R4ZE8yL251S21WUW1YWnd2c2JwYS9TOG5J?=
 =?utf-8?B?SWpSUEtlOFI3SktmVHVxaVFTaCtGeVMyeGF6Y2hVODR4SlprU3IxNzk5S3Vn?=
 =?utf-8?B?dmxFbjJJcHJUd1JaQ0cxbmNTY211WkI0T0FNSFZ5cTFCNEx5a1lIQUJaOW1k?=
 =?utf-8?B?dWE2cGgyVU5DY3YxL1FMWTYxSTErdkNQcm50U09oSU5wZzU5MmNBZ3YwLzl0?=
 =?utf-8?B?bjRuVTBNWHNjbEMrN2RrZmkzN24vV0VESXEyMHo4Z0E3cGkramhXZjNtUFBQ?=
 =?utf-8?B?SlN6dXV0eVNKbkRMSVZ0Y0VaMkxydEpXTkVjTmVFUG9RM09qYjNqb1A0MWh4?=
 =?utf-8?B?Y082clB4anhlYUZmT21tK1dtamdOQnRvc3hzV3J2ekpIem9nRFBVUElUemNP?=
 =?utf-8?B?NVVuWjlhQ1hSZ0lUVXltS0l5aTJyTWxRWURIV05kbklMa1JZeU9PVUV5QTl4?=
 =?utf-8?B?Q09lZkllT1JVaXJmS2hGSzBrT0gzbFlIMWJVTlhGenIxVEhBWU91UzBOWG9S?=
 =?utf-8?B?cG80TnRSYSttdjFUUUgzejFmMWNBY1hnaW43Y1ZGMjlzbGsyUDR1dFlGempJ?=
 =?utf-8?B?bHhhWk9VMGdHQ3lsMDRwNnM0TDNHUE1VenU1R2IrM2g0eFRQSlZZV0dOTnhV?=
 =?utf-8?B?ekZYdUhuSC9qRldKSkNCSW1wRGxxeFhPNWYybEt4THBMaitxRlVqb25MeStY?=
 =?utf-8?B?VFMvZ3ZOWk1lbVA4VmdsWlJHUkdBUjlxVm03N1MrSUFaSEt2V2tkbnFKa0Fy?=
 =?utf-8?B?RjZhWVpYZnd6a1NPNzFJdEhGNzdJSlhydmtqcnZGOS9IZkVFSXFpUHA2OTJh?=
 =?utf-8?B?ZXNLeTFFMnhCYkJqL3lwSG9nNFYyaU5ldWR1VGJUYitEVStLdTRVclFzSU1y?=
 =?utf-8?B?Ym4rOHBmOG42bmxodjlFR0NIdlBFY3FKTFVJL2xUcVFxRXg1blZiWDRMc3J6?=
 =?utf-8?B?S1gvRnNHbjJ4SjZkUzVEU1EwZmd2bjQ5RWRWbldmdG5DSitSaGRPczY5TzR6?=
 =?utf-8?B?STJvQkZhaFlLbnZvUzVXK3lrRXltQWYyZ2pNZmpsQXFiOGk0THVkMm5ITjJh?=
 =?utf-8?B?Yk9hMDZETTQxS1dNSDFQTE4vbUUwcittRWRpOGtsWG5iaml5eG9VRVVuYmt1?=
 =?utf-8?B?VVdnQjEyVXV3cTNzVnBEYkpiRWxJWWNXS1ZGN29ZN1pFMm41QXRtWkN2RlI0?=
 =?utf-8?B?MzVoWDQzRE5RUFpOK1p3NXAvaTVSQlJxcVNlMGRtRXFpeUpkS1RaNTEyM1Jw?=
 =?utf-8?B?enl2TmJVTUw0TytrT2tINm9ncjdxajhtNE1qRjhmbFJJU0tveW5ET1VadElL?=
 =?utf-8?B?OE4wejVkOWlKSGRucjJiL1UzT29lOExhb0JwVmdBc01scmNBbkFjMkRUTGY4?=
 =?utf-8?B?ZjVKQmZlWkNzTCtWQS95dkdRTFArM2huenE4TERSaVNqdm5mVVFTQ3ZIRjhV?=
 =?utf-8?B?NTZjc3hERnl5dG5QWDUxZ1VsR1A5alI5ZFZYVjNFWDVubmk5NUo3Mmd5aEdt?=
 =?utf-8?B?bzZEWmY2TWp2TTJiRUhRdkthNnFmME1pUW5naTRZeHI4blRMVU5oRUdpTGpW?=
 =?utf-8?B?ekpNTVJsV3d3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFlEWllDK1J5dWxnbzFrRGZtNFB5bVhGTDArTUVJWitJZUtVNnpxSkJ0UHRh?=
 =?utf-8?B?VG9TZTRmSjBLTHNTTW96eExiNW1EUVhIWWpZVzd4ZnJKNSt3U2JSbGtSVkh4?=
 =?utf-8?B?NUYyRkhRbW5FTVUwVDhqam5PQ1FZbVdDU24vQ25QSS9kRjFhVXMyc2J5b3BY?=
 =?utf-8?B?L2VtT2huUy9CTDNBU2FlZU9WQURrNHZGaklJYm8yaTF3NlB0bDRUYU9PWjhH?=
 =?utf-8?B?c2xGZGxVR3ZPRVFwNW1TYndsUUNpOFM0L0N0VFJxK0dTVDBjTWh4N0Z0dEpz?=
 =?utf-8?B?TTQ4NHBQNzQ0VkZMMlFuZk5yd0NGTzh1Um5qR3ZCb2JvMEdoMzlLczdSaGRB?=
 =?utf-8?B?UzdMd3ZFTWdLMG1xN0FMT21QdFhCeVVPbFZXV0hwczFkTklVNFdGazZmem5O?=
 =?utf-8?B?N3pDeGh0Tk1ETVpOenN0M3hDaEM3c01CMnNHMDNKWFMrcVZYN0tURkY3MHc5?=
 =?utf-8?B?VW52dEh6NEY1eEIwdHZNUW4xaW9vWnJWMjdkZnBPNHhyVk9mdUhOemk0Qy84?=
 =?utf-8?B?ZXNuMUkwQzdpem54R3lJUDY2ZmZ0bDMvamcweXBmZXBWKzBsVDhPVXp0K29G?=
 =?utf-8?B?Q2ZTOTZuTzJiOVlEbk9QVEhTSExibEgrdGY4bHdndUFqU3hQRUp6cE5TSjVi?=
 =?utf-8?B?cDJGYks0eSt0OUw3MGJ3UzdZUzBsV1lCbDR1K2crSzB3aklLM05MZEFpNmts?=
 =?utf-8?B?UityeVRGVkt3M1Z3Q0dMWFJMNHVrZkVRU0ZBQTQwTnRISVJGNkY4azVoMGhU?=
 =?utf-8?B?bFlZVXNzNFFaNERVaVlQQysraUVhSVJUMVFUbS9GeU9yeXpKYmxZNUZ6bVlJ?=
 =?utf-8?B?WjM4Sml1aEFYNTRvZExTNTJGYjZhWHhSdVhIcUVtNytUOWYwR2xpNnRwdTVh?=
 =?utf-8?B?Zk1KSmd5K0hQdkNsL05Cdmt0VU0zZXZ3cEZCOUI3VTdWWE5kaUxDMTRKamxj?=
 =?utf-8?B?M0QvbTdMZUg2MHFBZzlrRnM3VkowOEdER2MrbzZZZ3JNUTlVV0NvdTFmZEl2?=
 =?utf-8?B?YTNVbHYxNXQ0d0FPUUNraHdKUU9tRUpyL3BUUjJNTENPU2M3ZkNUYTNuTUEr?=
 =?utf-8?B?d2tvZEJLUHJaN0lQZytyeXd4RDdoZ09reFpRZ3RvajN2VE9MaFNuSEVqaVNN?=
 =?utf-8?B?czd6R3dOZitVWHRyU0tCVlhWbXAydzBtWTZreVdaMnBKR2w5LzdkbVI1bCt3?=
 =?utf-8?B?RXM0Q1I3VDZUQ3pOeHRxUWZjc2JXZ0E3Q1dKendxQjNrOERWL2pGR25uQmRQ?=
 =?utf-8?B?Uk5RZDhPUEd2MkhMMjdkUzE2Z3dmYmFUWmhiVUR2SDNvVGdmRmxTcXVObmlo?=
 =?utf-8?B?ZnZxejNkSzhPN3NEakZlRzRIV0p2aGpUZDN3b2k1cFZLdWx2RzAvSmtOQ1Vk?=
 =?utf-8?B?dzNpanFFaERkVG9OVjdyemR4S0dWM3BRTytodFBYTHJUblJITmR5cVlSY0Js?=
 =?utf-8?B?Vk5UMWhsZEJrTEpKVkhJbHBqUWhUSVVnSkNFWFRkMmJyUUtscUJVd3JEVnJO?=
 =?utf-8?B?dUtnaGdhV1I1RFpDL2MwNi9KKytxN0U1MS9mS0dyeUkxZVB0MzRCbStaWTJl?=
 =?utf-8?B?dXhLNVByakE4S05zV01sVzdhNi9JZ2JQcWs2dUVETThqd3lMVnlNZ1pRZkMz?=
 =?utf-8?B?d1lzZDcxU0diVjJvMkp5OUh6NmYvUXppKy84ZXRjRmoyNm5KZGcvaDRDSDkw?=
 =?utf-8?B?NUlOaU56Y2pQaVIvVS9ZWGRrWDVGdG1kb2tkazZTVVBXbkYyU20wblVMeGc4?=
 =?utf-8?B?Szk1QThSOUdYdmdpWXZlOXhlcmdQRGpiMW1FNEQ3YWhzOXhwNEV5SnBBSWg0?=
 =?utf-8?B?R29YMzVWRStpajZrbTdQQ3lqaVV2dEZBZGo5TVpIOWlCQ0ZCdDFLa1pKb3pn?=
 =?utf-8?B?YytCQTRNNUtSUTZ6NE5CM2o5ZXZQdFlkT2dtcFIyN3BFVnJyb0pzNzd2N3I2?=
 =?utf-8?B?b3JEN0Q1STJ2N2lzRU5SZmRHeVBDMHlFN1pWVFRUbTc4MERLVm5XTnlUYk1t?=
 =?utf-8?B?Skszd2hVWEpWYkV1S01BTDErOE9zdmpGa1g4Wm82Y3lrZFVNbGo3bGRIUXpZ?=
 =?utf-8?B?dVlYSnlXUk1MOXVOQ3J3K29SdzR3Y3JpdE5raERURnR5NW4vMXNuTXZnSWRQ?=
 =?utf-8?Q?oH8puVdvdGY3OEAPZVlGbYQ9M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975d5b5b-b3e8-4347-f732-08ddf20cb857
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:57:43.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoBb9Ng4u8gDFaqwNf1xxFnH05wZo+YosbE5rxoQ6T+s4sypQWtdlrxuO5GEjpamLJSB+zDivm88yIJurY+4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7248

On 9/10/25 17:55, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is active, the TEE extended command header page and
> all output buffers for TEE extended commands (such as used by Seamless
> Firmware servicing support) must be in hypervisor-fixed state,
> assigned to the hypervisor and marked immutable in the RMP entrie(s).
> 
> Add a new generic SEV API interface to allocate/free hypervisor fixed
> pages which abstracts hypervisor fixed page allocation/free for PSP
> sub devices. The API internally uses SNP_INIT_EX to transition pages
> to HV-Fixed page state.
> 
> If SNP is not enabled then the allocator is simply a wrapper over
> alloc_pages() and __free_pages().
> 
> When the sub device free the pages, they are put on a free list
> and future allocation requests will try to re-use the freed pages from
> this list. But this list is not preserved across PSP driver load/unload
> hence this free/reuse support is only supported while PSP driver is
> loaded. As HV_FIXED page state is only changed at reboot, these pages
> are leaked as they cannot be returned back to the page allocator and
> then potentially allocated to guests, which will cause SEV-SNP guests
> to fail to start or terminate when accessing the HV_FIXED page.
> 
> Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 182 +++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   3 +
>  2 files changed, 185 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9e797cbdf038..2300673c6683 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -83,6 +83,21 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  static bool psp_dead;
>  static int psp_timeout;
>  
> +enum snp_hv_fixed_pages_state {
> +	ALLOCATED,
> +	HV_FIXED,
> +};
> +
> +struct snp_hv_fixed_pages_entry {
> +	struct list_head list;
> +	struct page *page;
> +	unsigned int order;
> +	bool free;
> +	enum snp_hv_fixed_pages_state page_state;
> +};
> +
> +static LIST_HEAD(snp_hv_fixed_pages);
> +
>  /* Trusted Memory Region (TMR):
>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>   *   to allocate the memory, which will return aligned memory for the specified
> @@ -1158,6 +1173,165 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  	return rc;
>  }
>  
> +/* Hypervisor Fixed pages API interface */
> +static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
> +					    enum snp_hv_fixed_pages_state page_state)
> +{
> +	struct snp_hv_fixed_pages_entry *entry;
> +
> +	/* List is protected by sev_cmd_mutex */
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (list_empty(&snp_hv_fixed_pages))
> +		return;
> +
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
> +		entry->page_state = page_state;
> +}
> +
> +/*
> + * Allocate HV_FIXED pages in 2MB aligned sizes to ensure the whole
> + * 2MB pages are marked as HV_FIXED.
> + */
> +struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
> +{
> +	struct psp_device *psp_master = psp_get_master_device();
> +	struct snp_hv_fixed_pages_entry *entry;
> +	struct sev_device *sev;
> +	unsigned int order;
> +	struct page *page;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return NULL;
> +
> +	sev = psp_master->sev_data;
> +
> +	order = get_order(PMD_SIZE * num_2mb_pages);
> +
> +	/*
> +	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
> +	 * also needs to be protected using the same mutex.
> +	 */
> +	guard(mutex)(&sev_cmd_mutex);
> +
> +	/*
> +	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
> +	 * page state, fail if SNP is already initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return NULL;
> +
> +	/* Re-use freed pages that match the request */
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
> +		/* Hypervisor fixed page allocator implements exact fit policy */
> +		if (entry->order == order && entry->free) {
> +			entry->free = false;
> +			memset(page_address(entry->page), 0,
> +			       (1 << entry->order) * PAGE_SIZE);
> +			return entry->page;
> +		}
> +	}
> +
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!page)
> +		return NULL;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry) {
> +		__free_pages(page, order);
> +		return NULL;
> +	}
> +
> +	entry->page = page;
> +	entry->order = order;
> +	list_add_tail(&entry->list, &snp_hv_fixed_pages);
> +
> +	return page;
> +}
> +
> +void snp_free_hv_fixed_pages(struct page *page)
> +{
> +	struct psp_device *psp_master = psp_get_master_device();
> +	struct snp_hv_fixed_pages_entry *entry, *nentry;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return;
> +
> +	/*
> +	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
> +	 * also needs to be protected using the same mutex.
> +	 */
> +	guard(mutex)(&sev_cmd_mutex);
> +
> +	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
> +		if (entry->page != page)
> +			continue;
> +
> +		/*
> +		 * HV_FIXED page state cannot be changed until reboot
> +		 * and they cannot be used by an SNP guest, so they cannot
> +		 * be returned back to the page allocator.
> +		 * Mark the pages as free internally to allow possible re-use.
> +		 */
> +		if (entry->page_state == HV_FIXED) {
> +			entry->free = true;
> +		} else {
> +			__free_pages(page, entry->order);
> +			list_del(&entry->list);
> +			kfree(entry);
> +		}
> +		return;
> +	}
> +}
> +
> +static void snp_add_hv_fixed_pages(struct sev_device *sev, struct sev_data_range_list *range_list)
> +{
> +	struct snp_hv_fixed_pages_entry *entry;
> +	struct sev_data_range *range;
> +	int num_elements;
> +
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (list_empty(&snp_hv_fixed_pages))
> +		return;
> +
> +	num_elements = list_count_nodes(&snp_hv_fixed_pages) +
> +		       range_list->num_elements;
> +
> +	/*
> +	 * Ensure the list of HV_FIXED pages that will be passed to firmware
> +	 * do not exceed the page-sized argument buffer.
> +	 */
> +	if (num_elements * sizeof(*range) + sizeof(*range_list) > PAGE_SIZE) {
> +		dev_warn(sev->dev, "Additional HV_Fixed pages cannot be accommodated, omitting\n");
> +		return;
> +	}
> +
> +	range = &range_list->ranges[range_list->num_elements];
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
> +		range->base = page_to_pfn(entry->page) << PAGE_SHIFT;
> +		range->page_count = 1 << entry->order;
> +		range++;
> +	}
> +	range_list->num_elements = num_elements;
> +}
> +
> +static void snp_leak_hv_fixed_pages(void)
> +{
> +	struct snp_hv_fixed_pages_entry *entry;
> +
> +	/* List is protected by sev_cmd_mutex */
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (list_empty(&snp_hv_fixed_pages))
> +		return;
> +
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
> +		if (entry->page_state == HV_FIXED)
> +			__snp_leak_pages(page_to_pfn(entry->page),
> +					 1 << entry->order, false);
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -1248,6 +1422,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  			return rc;
>  		}
>  
> +		/*
> +		 * Add HV_Fixed pages from other PSP sub-devices, such as SFS to the
> +		 * HV_Fixed page list.
> +		 */
> +		snp_add_hv_fixed_pages(sev, snp_range_list);
> +
>  		memset(&data, 0, sizeof(data));
>  
>  		if (max_snp_asid) {
> @@ -1293,6 +1473,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		return rc;
>  	}
>  
> +	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> @@ -1896,6 +2077,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  		return ret;
>  	}
>  
> +	snp_leak_hv_fixed_pages();
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 5aed2595c9ae..ac03bd0848f7 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -69,4 +69,7 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
> +void snp_free_hv_fixed_pages(struct page *page);
> +
>  #endif /* __SEV_DEV_H */


