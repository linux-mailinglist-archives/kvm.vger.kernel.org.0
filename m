Return-Path: <kvm+bounces-38801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F523A3E763
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6EB83BFC5B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E951F1506;
	Thu, 20 Feb 2025 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LRsfHnU5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FFA1B4247;
	Thu, 20 Feb 2025 22:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089914; cv=fail; b=F//Dp8Bzdpl6roJQbJvdVvg+6EF1rZt9LeF3h2ffGyGbTF0DJt9bLzgo0+VnqNc+TOLWkc+RtnU0Pdiq2fBNF6JVwjUqOW93mFt7xrH9hcyJnHfCbcICC4iKpuDHRiN+FgtQbSNNGvSs3hAQ0RP/eER9sx8LmXSmzKJbQ44iHjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089914; c=relaxed/simple;
	bh=PiIttr61t19j5RFP0refs9/pqmEJQEitIPom7ZwlB3c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TlNx4HHhbjr/TVmfE2Lwh9Sm9PfHv+CMj6HZ371pE5ZKy5YElxW/j9pfk72N/H39kIQAcyBtwn2lwA6vV76gU/03DknLrzwKw+UYx0ztzHTAktKei7Z3rpnfSLsD3AtCbcS3zYPXZ9/BZ4K9Vqq/WfGqeUBPN3knEPIsrBLwInI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LRsfHnU5; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OtD/vVvMIobTjRvaPsPS5luvL5P09xTIFVdkka7CJnnw6DIJ22oL8vdraSLkfsMXDrL7W4yOBU47c1xew+i6glhqcLGl9+hrMx91BMgs59Np6sppUMYEyKLA2eaJdk049ErAPifX7xV6xKUcJ6EYXWB1bfR0h/5dOge2MHj87ND1RfxX0/ZNBdGDzi8tdp9NTsPVjuGUNNeKulj5qxdfu+75ZIpoINo9Stg9G1u3qCOIdMMyXwa0oJv6CuLLMPulfklwLTz/1NQTlqDpqPHGVi33olBN5MbJVI3DNZsgzjEms/Xg2/l8Pt/n04M1qUyvmd0mdIliLRKQlXIS5IcMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQ2Jl61SoQ/1me8EK2s2IK6ZB7YddrTsOiLiVkYUpAU=;
 b=iSunVx4tcrV/1Pe3k9VC20i8uoLjTSWhDkaPF/wGF3kd3KhSL1yqu1LMEVFP333alUlbQrXoJN1O0wNRfu+b2EdqcZ0pSGp1chSLa2IC8lCSEj/Z5WDjd3pQmiZwNQ9cTR/TheJD8N2InQrgZE0XkZsvfPj7EVFfrvEvskVYgSDgxdcr2FHVEBXFh8QvxPhByYUsf7S/t0fuU413NDhI6Z6Vqc2DBrTt1NGvYYpJ8BsAjpH58QWpLcWEH7Y+PGwF4vIqjjAO/wgHrSwFmkw9Y9vDJ/ZGSBDhefCf8wpp5U1/6nLXzIf/kKPsD2ZFSSoq5DFWfsJim1dNBO/bHLgsBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQ2Jl61SoQ/1me8EK2s2IK6ZB7YddrTsOiLiVkYUpAU=;
 b=LRsfHnU5bgBd/bdXdK1V9PLO7zLG5igpdnqpbgbLaMcSLbflhOhLmh1pyIWH++GmRuhtfuI0uAiWH1pXtJXWI7/YSLVz5JyABUUATR1gqYdWQ68R7fvOBbsTWdcZ7SSYm5/LOobs52IGaOBS4drQsFN+NVt+p3kq6hnMbmT9q0o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB7331.namprd12.prod.outlook.com (2603:10b6:510:20e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Thu, 20 Feb
 2025 22:18:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8445.020; Thu, 20 Feb 2025
 22:18:26 +0000
Message-ID: <f227fa9a-f609-41f3-a63b-1c37ded33134@amd.com>
Date: Thu, 20 Feb 2025 16:18:22 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
 <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com>
 <27d63f0a-f840-42df-a31c-28c8cb457222@amd.com>
 <CAAH4kHYXGNTFABo7hWCQvvebiv4VkXfT8HvV-FPneyQcrHA-9w@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHYXGNTFABo7hWCQvvebiv4VkXfT8HvV-FPneyQcrHA-9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN1PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:408:e0::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3d54d6-777e-4989-7e86-08dd51fc7eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEhGQ0d1bHpONzhnNU4veUEranVYNGRHdXM1aTl5K0wwUkIwSUY3Y1RFT2tY?=
 =?utf-8?B?em5zT0xEczJEVEYxRXNGWkQ0WldmZ1dTcldIb2dVNlRkTkpoczlRbVVWcXhq?=
 =?utf-8?B?a1ZoZ3pwZTdEdzdGSUlNaVRZZEgwNmlCZ0FCMVY1QlpEZXdyZUg4Ykk3Qnha?=
 =?utf-8?B?NVRKMWIvT3pZWm9QbGFKSDF4cTZXM3RyVDJkMUpJV05waWtJSmhIOU0yQnoy?=
 =?utf-8?B?RU9neFQzb2FoK2lBK1l1VXFaYzhMa1lhQkdybU1TUFZtWmdQSkR3clVYZWZX?=
 =?utf-8?B?TEp3VWx5bXFUNlhqY3h4dUJxYUtVRklPTWlDOHE0L2hoaXNjcVZsdGpJN0RD?=
 =?utf-8?B?Y3I1QTFQdjBBYmt2MjY5MlJpSTJpeHVsOWhSOEJ1VDBaNFVwYXJvUkM4eCtS?=
 =?utf-8?B?L0ZXNW5OQUx0RmZpb3NSejdMcFJYQ1NZZXBiL2w4VUsrTEcrS1dLTXE1ellK?=
 =?utf-8?B?NlVCTjlCUE8vZkYyM0lGMnE4VGRUbGs3SGo4dDlVTjV1RExXbkRkVXRUQS9o?=
 =?utf-8?B?R0N0bFRlRitKSnoyOUM3cm1XT01BYUhveU5UZWt3V2oyaVQ2VUJubEF0SzRn?=
 =?utf-8?B?ekgwaXEyN3I2dllKWTN1T05xYURyRk9TZXdvcVdaUG5Xa2F3VzdNOWVjYkNi?=
 =?utf-8?B?cnd4NjRsOXhjV0RPajJ3VUV4bHllTUpFelRtZGdRVVBGM2MvbWtYcUFRMEFn?=
 =?utf-8?B?U2Jjd01yQkNmVXJZMmRXSkphNGcvS1BiV05KVUpsMG94R3NST2VGS29IdkxC?=
 =?utf-8?B?SkJMbjNpU0xVN2wzbk1rUTFWQVdORU1BQWpVenVPUkxmQWt4Q1ZQZk9LM1Uy?=
 =?utf-8?B?ZHM4SGVzUnZ6bWVVQ09hUEZydFRzOEZKUGFZUUR3Q1VFcGJPWmlKRUFXRDZP?=
 =?utf-8?B?Skd1VXd1VmlJd3NZTnhIMnQ2US95MFpNMEEyNVZIWTZwOEh5eXprRkpWZFVq?=
 =?utf-8?B?STF1YUVyRmMwYTdiWUNmMGlNbmMwTDNsUnVGVkNFMGtXSnZRRU1ldGdQNEFh?=
 =?utf-8?B?SDZHZEF5N1hKYTFmYXBLcUlnTHhZMnpXWk93b3l0MFovUU1OVFpwQlZERno0?=
 =?utf-8?B?Q1dGdy9xRnN6Zk4vRVRIam5IREJyQllNNWYrWTN4WXVsUDNpRVhrbStqRFcw?=
 =?utf-8?B?Nlh5YzhheTNRSTZ5RzJ6eGxJSzR3cVpJL2ZVVEJCVUV3ZTlrQkpFeEIrMHRW?=
 =?utf-8?B?d3R3bDFBUEZwclpYKyszeXhvSkM3MmdXNmFETU5TSmhpTW1weDZQdDV4VzdG?=
 =?utf-8?B?Q3VJU3hRUXZoRUJEekVsTWJocFYrLzhvVjl0UEhwbUpUbXRQUEcrVXg4cDhz?=
 =?utf-8?B?TTN6VmIrYy9PS211RTNRK01wRldGZjBFQWJnczlVbVFsWmhCOXlCREdtVmQr?=
 =?utf-8?B?a2lqTHR3ZG8wU0hCSEVTWXpSOGFxc05OaFlVMHl0clVPZ1FXZnRZVG01WjdT?=
 =?utf-8?B?d2xRcGQzc1FLdXJVbi83QXlXbHNFNGt1R3M4cTNhVlRFWm9QSFlBbjcyaFk5?=
 =?utf-8?B?eVZ1dk8zSHVNVlBIckZUUDRLNlU5OTAyU0xOMnVCNTFmK0tpTTQxLzlOSVZG?=
 =?utf-8?B?aHJvOEliN2h3YTdqbkdsb1QxRXV6YytVcHdpVE4wZTRocTduc0gzcjYxTkh5?=
 =?utf-8?B?UVViMFFhazZUcDI1NGU5VlkzMnl4R1duWXFHNW9XVktHNzVvdVk1aU1QQ2ZF?=
 =?utf-8?B?dkxoM0ttM0NtajN6UmhTQ2NQRzNFRmRBeXE1Z2kwQmhOczlvTWhXOGxXNUY3?=
 =?utf-8?B?NDRKVkFyQmJzWERhVEs4TXEwRUZnMUpqeXI4akFGMXhJdVJtSVNkaWRLaU5X?=
 =?utf-8?B?dlI0R083Z3UrZVZwWmM2RHlOb1pnZ1duYzBra2M4djZzRFZ0YXJ5VThNOE9a?=
 =?utf-8?Q?jAfZdoYJMTgon?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blB3OURpbjlzYkZ3aXFWdmNwc3JmUDRNUHVwa1VQd3V0WG13V3VCcHZXQm5v?=
 =?utf-8?B?MnFwTHhmdUhsYzVYcENrT0FjU1dFTFJmVFUwMGtMSGZOeTl4UDhlUFJTMkFw?=
 =?utf-8?B?ZWprVWJRbXg5dzQzeTZmcStoRUQ4S2tBRWVSSVdqZ2RNTU1raENTL2R1SEVU?=
 =?utf-8?B?K280czdTakpsZk9uSmNTV2o0aTRUcXBZRXZ3d0k3YlJYUXFoSXJ4aW96UnQr?=
 =?utf-8?B?UWFRbXl3aHE3Z0VlZExzRXhnamM3Sy9qZmJEUHByWmgxUTZxekgzeTYxdWVK?=
 =?utf-8?B?UUU1WUhIOUd4WUIvK2JQWWF1Wm1CSUF6YzVrK1BFMFdpTWgzbklDbVlQeE10?=
 =?utf-8?B?ZVdpTGJqMW1JQkNQUWJqbHVRMVJ3K0RWdmZuMGs4ZkM4elVSZzMwcVZZaEVu?=
 =?utf-8?B?RTNZSFN3Q1pXNDN2MW5NemVQeTlLTjVvcHBEdkVkTDg3QnpWYVc4QU5rKzM1?=
 =?utf-8?B?SFFkRkh1ejBkZG5ZSzNOU2xNN0FkanZza3Z0YytQN05NTkVqNVJzMk5OcUJI?=
 =?utf-8?B?NkFXZDRXQzJONkEwUXduTTBZbWtVNTg5SFd5WVkyTXRDYlpaZWg1WVk0ditz?=
 =?utf-8?B?NnllRm1CMGpGT1Jta2dZb2xjdk9WSTZTUkFUT0ZEL1F0eGc5SktGSkxmbHBZ?=
 =?utf-8?B?R2V1bWtJUFZSMXRpa0t1UzhNRDBSMzJjdmU4NE5aa0M4UUVIQVNBZ1lPVmRU?=
 =?utf-8?B?OEZZYzB3eWxtYlFHcCtaWFlranFWZGdNbXBMWTRHeERXcDQ2MkFpbEd5S3VR?=
 =?utf-8?B?dmZQcUZ0Zy9ycEZYRlBSM1dXZGUwWSt5c3daWnRpS0huOUdRUEVoMWp2UU1i?=
 =?utf-8?B?ZDROV3cwSnN1VHgzd3hOdEpXak4rb0JJOFQvaVBaaGhVNFJFZlB0OWxXWkdH?=
 =?utf-8?B?VkNlYUhHTTVra2kvN3h5Q3NpR21mRndCMWJEeUlGbnR5ZmJiZ1NDV3JVRU9M?=
 =?utf-8?B?UGhvNHJQbmNYSUhOTGNxWGxXS2lYMDVpWndWZkgycllPcERZMlF4andqY25w?=
 =?utf-8?B?Yk93cjNZK3dvQmNOZHlLTnhyLzJsM003Ry8xYUZoelhPVHArRmlNa3B6eVRy?=
 =?utf-8?B?eDlJZzhTMW5XeGRJK3RDaExWSU5JUUdLQmVQYzl1K2FvSCtJbEVFUmNGMjlw?=
 =?utf-8?B?b1ByMHZRNGVZdm81clFWVzFMbVNHQitMdEYzcDdFM1FySTR3T2p2YU9WN253?=
 =?utf-8?B?bVhaSnAydUhWQTFHaFZGVnU0cThkRTFJejJsM0FsUjR5QTAvZ3U4emMvMkpI?=
 =?utf-8?B?cGk2WWlhb1hxdUt4Szlpd1haTW1ERm8zV28zVjgwNGpKY2FjVzN6YU94WjZO?=
 =?utf-8?B?Q2ErRkFZa2MxcGJzNUhqZFdRNk5UZDVuaEVudlp3cWR4RlVzYldKYzdMVTJJ?=
 =?utf-8?B?WWxuUUoxcDE0N2FmV1QxZ2NiU3VKYnZ6RC8wWEFPNjcxaXU5U3YyazNDaFR2?=
 =?utf-8?B?NkRndHZSa1JRQmx0QlZ2aUQrREx3Q0t2N0IzelNOaHFQQnJmSkZRblZWWUZ2?=
 =?utf-8?B?VzNMYmt2YUNoRks0dklKanEydzZWSk8xdmNTb3h2aHlmYXdFRi9sczA1c2JJ?=
 =?utf-8?B?RUpqUnpuYTJoNFVhakRwQUtjQzYzcGVpL3J3V2ozUmVTVldhd3REWFVMb0FV?=
 =?utf-8?B?RHp1K2lNZUlWS0l6SFFZekdpOFhpajh6VW1MRXRuZDFNeU5QTER6ZzAyNjAx?=
 =?utf-8?B?VjJEbGVzSGFwRHV0TnJTaXdyZXZ5RHN4aWJIcmhSNUY3TzBhcFBuMzRQQWxF?=
 =?utf-8?B?SmdacUFSVDREc2lzWHh2Smd2ek81Mkh6TUFCN2Q3QUtjNlQvcldDeXhyd3d0?=
 =?utf-8?B?SEIzRG9IQ0t5K29XbFdXQ1dtZmg0cmxyS09qdzg4OEczNmtKR1Fob1Rhd1Z2?=
 =?utf-8?B?elRuZ0dQZEI5SlBwYjVJVXM2MDhadGswbGIzRU1IRkNoRm1DNSs3bUsrYko0?=
 =?utf-8?B?OXZBajJidDloRFF2MGhmSDNlSEhkTzFxalFhVlZoR2dkckZKQjJ1eGZRY0Uz?=
 =?utf-8?B?NEpPaTEreDlqMFpYMVRSckdHK2hoZEJCQTMzRnBJdU5CalNMdVVVOUM0eG9P?=
 =?utf-8?B?ZFljQ0tVVWJkSXhJOWhVTXR2WTVlQThSamJlNEJvRUlUVnYxLzJPM2hoTjc3?=
 =?utf-8?Q?Y9EVGiJSbDzAUi/w4UBtuNXuC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3d54d6-777e-4989-7e86-08dd51fc7eff
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 22:18:26.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0bi0WKeTp6jGEyMlU1c1mpCI+CIB3NZFlX+cfVqJ3BIDp8Mf8xwfhclsGhDpI0ngWturN8ay+H5xClTUJLpfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7331

On 2/20/2025 3:37 PM, Dionna Amalie Glaze wrote:
> On Thu, Feb 20, 2025 at 12:07 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>>
>> Hello Dionna,
>>
>> On 2/20/2025 10:44 AM, Dionna Amalie Glaze wrote:
>>> On Wed, Feb 19, 2025 at 12:53 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> Modify the behavior of implicit SEV initialization in some of the
>>>> SEV ioctls to do both SEV initialization and shutdown and add
>>>> implicit SNP initialization and shutdown to some of the SNP ioctls
>>>> so that the change of SEV/SNP platform initialization not being
>>>> done during PSP driver probe time does not break userspace tools
>>>> such as sevtool, etc.
>>>>
>>>> Prior to this patch, SEV has always been initialized before these
>>>> ioctls as SEV initialization is done as part of PSP module probe,
>>>> but now with SEV initialization being moved to KVM module load instead
>>>> of PSP driver probe, the implied SEV INIT actually makes sense and gets
>>>> used and additionally to maintain SEV platform state consistency
>>>> before and after the ioctl SEV shutdown needs to be done after the
>>>> firmware call.
>>>>
>>>> It is important to do SEV Shutdown here with the SEV/SNP initialization
>>>> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
>>>> followed with SEV Shutdown will cause SEV to remain in INIT state and
>>>> then a future SNP INIT in KVM module load will fail.
>>>>
>>>> Similarly, prior to this patch, SNP has always been initialized before
>>>> these ioctls as SNP initialization is done as part of PSP module probe,
>>>> therefore, to keep a consistent behavior, SNP init needs to be done
>>>> here implicitly as part of these ioctls followed with SNP shutdown
>>>> before returning from the ioctl to maintain the consistent platform
>>>> state before and after the ioctl.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++-------
>>>>  1 file changed, 93 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>> index 8f5c474b9d1c..b06f43eb18f7 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>>>>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>>>>  {
>>>>         struct sev_device *sev = psp_master->sev_data;
>>>> -       int rc;
>>>> +       bool shutdown_required = false;
>>>> +       int rc, error;
>>>>
>>>>         if (!writable)
>>>>                 return -EPERM;
>>>> @@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>>>>                 rc = __sev_platform_init_locked(&argp->error);
>>>>                 if (rc)
>>>>                         return rc;
>>>> +               shutdown_required = true;
>>>>         }
>>>>
>>>> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>>>> +       rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
>>>> +
>>>> +       if (shutdown_required)
>>>> +               __sev_platform_shutdown_locked(&error);
>>>
>>> This error is discarded. Is that by design? If so, It'd be better to
>>> call this ignored_error.
>>>
>>
>> This is by design, we cannot overwrite the error for the original command being issued
>> here which in this case is do_pek_pdh_gen, hence we use a local error for the shutdown command.
>> And __sev_platform_shutdown_locked() has it's own error logging code, so it will be printing
>> the error message for the shutdown command failure, so the shutdown error is not eventually
>> being ignored, that error log will assist in any inconsistent SEV/SNP platform state and
>> subsequent errors.
>>
>>>> +
>>>> +       return rc;
>>>>  }
>>>>
>>>>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>>  {
>>>>         struct sev_device *sev = psp_master->sev_data;
>>>>         struct sev_user_data_pek_csr input;
>>>> +       bool shutdown_required = false;
>>>>         struct sev_data_pek_csr data;
>>>>         void __user *input_address;
>>>>         void *blob = NULL;
>>>> -       int ret;
>>>> +       int ret, error;
>>>>
>>>>         if (!writable)
>>>>                 return -EPERM;
>>>> @@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>>                 ret = __sev_platform_init_locked(&argp->error);
>>>>                 if (ret)
>>>>                         goto e_free_blob;
>>>> +               shutdown_required = true;
>>>>         }
>>>>
>>>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>>>> @@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>>         }
>>>>
>>>>  e_free_blob:
>>>> +       if (shutdown_required)
>>>> +               __sev_platform_shutdown_locked(&error);
>>>
>>> Another discarded error. This function is called in different
>>> locations in sev-dev.c with and without checking the result, which
>>> seems problematic.
>>
>> Not really, if shutdown fails for any reason, the error is printed.
>> The return value here reflects the value of the original command/function.
>> The command/ioctl could have succeeded but the shutdown failed, hence,
>> shutdown error is printed, but the return value reflects that the ioctl succeeded.
>>
>> Additionally, in case of INIT before the command is issued, the command may
>> have failed without the SEV state being in INIT state, hence the error for the
>> INIT command failure is returned back from the ioctl.
>>
>>>
>>>> +
>>>>         kfree(blob);
>>>>         return ret;
>>>>  }
>>>> @@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>>>         struct sev_device *sev = psp_master->sev_data;
>>>>         struct sev_user_data_pek_cert_import input;
>>>>         struct sev_data_pek_cert_import data;
>>>> +       bool shutdown_required = false;
>>>>         void *pek_blob, *oca_blob;
>>>> -       int ret;
>>>> +       int ret, error;
>>>>
>>>>         if (!writable)
>>>>                 return -EPERM;
>>>> @@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>>>                 ret = __sev_platform_init_locked(&argp->error);
>>>>                 if (ret)
>>>>                         goto e_free_oca;
>>>> +               shutdown_required = true;
>>>>         }
>>>>
>>>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>>>>
>>>>  e_free_oca:
>>>> +       if (shutdown_required)
>>>> +               __sev_platform_shutdown_locked(&error);
>>>
>>> Again.
>>>
>>>> +
>>>>         kfree(oca_blob);
>>>>  e_free_pek:
>>>>         kfree(pek_blob);
>>>> @@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>>         struct sev_data_pdh_cert_export data;
>>>>         void __user *input_cert_chain_address;
>>>>         void __user *input_pdh_cert_address;
>>>> -       int ret;
>>>> -
>>>> -       /* If platform is not in INIT state then transition it to INIT. */
>>>> -       if (sev->state != SEV_STATE_INIT) {
>>>> -               if (!writable)
>>>> -                       return -EPERM;
>>>> -
>>>> -               ret = __sev_platform_init_locked(&argp->error);
>>>> -               if (ret)
>>>> -                       return ret;
>>>> -       }
>>>> +       bool shutdown_required = false;
>>>> +       int ret, error;
>>>>
>>>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>>>                 return -EFAULT;
>>>> @@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>>         data.cert_chain_len = input.cert_chain_len;
>>>>
>>>>  cmd:
>>>> +       /* If platform is not in INIT state then transition it to INIT. */
>>>> +       if (sev->state != SEV_STATE_INIT) {
>>>> +               if (!writable)
>>>> +                       goto e_free_cert;
>>>> +               ret = __sev_platform_init_locked(&argp->error);
>>>
>>> Using argp->error for init instead of the ioctl-requested command
>>> means that the user will have difficulty distinguishing which process
>>> is at fault, no?
>>>
>>
>> Not really, in case the SEV command has still not been issued, argp->error is still usable
>> and returned back to the caller (no need to use a local error here), we are not overwriting
>> the argp->error used for the original command/ioctl here.
>>
> 
> I mean in the case that argp->error is set to a value shared by the
> command and init, it's hard to know what the problem was.
> I'd like to ensure that the documentation is updated to reflect that
> (in this case) if PDH_CERT_EXPORT returns INVALID_PLATFORM_STATE, then
> it's because the platform was not in PSTATE.UNINIT state.
> The new behavior of initializing when you need to now means that you
> should have ruled out INVALID_PLATFORM_STATE as a possible value from
> PDH_EXPORT_CERT. Same for SNP_CONFIG.
> 
> There is not a 1-to-1 mapping between the ioctl commands and the SEV
> commands now, so I think you need extra documentation to clarify the
> new error space for at least pdh_export and set_config
> 
> SNP_PLATFORM_STATUS, VLEK_LOAD, and SNP_COMMIT appear to not
> necessarily have a provenance confusion after looking closer.
> 
> 

I am more of less trying to match the current behavior of sev_ioctl_do_pek_import()
or sev_ioctl_do_pdh_export().

All this is implementation specific handling so we can't update SEV/SNP firmware
API specs documentation for this new error space, this is not a firmware specific return code. 

But to maintain 1-to-1 mapping between the ioctl commands and the SEV/SNP commands, 
i think it will be better to handle this INIT in the same way as SHUTDOWN, which
is to use a local error for INIT and in case of implicit INIT failures, let the
error logs from __sev_platform_init_locked() OR __sev_snp_init_locked() be printed
and always return INVALID_PLATFORM_STATE as error back to the caller.

Thanks,
Ashish


