Return-Path: <kvm+bounces-36082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6A48A1766C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 04:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B19F33AA776
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 03:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228311898F2;
	Tue, 21 Jan 2025 03:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D1GqJKKC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBB53208;
	Tue, 21 Jan 2025 03:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737431966; cv=fail; b=StnLRJc31K6Qjr9ak+IngoZXeznT6awLbHoZIQTYxto91PjJaHYVljyIJd6bMdfro02C6pVJVNMhyBgSIa8lg16PKdBw4POek938s20x51STFN6/birVfKKQP9Wg9NACXaZ+mElvVQepCG3QW1O0RyasrPeiFA0xjvDIn+lejsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737431966; c=relaxed/simple;
	bh=qcOvMS6pPyhbQbIfs8wg3yW6ZQN57LRWzJNpnruPbCw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lVAd7oNUc1WZkTEJ09t+PmmKAaPmrF3OZvXFQyGvuyxBmvl3XS4/ZU6I4QhDvpwNLtD4rpguCTYXsOOcHr1sy8p/Q1esNMAir8wl5My6jwX4gf9yShojs4o2Mco0FGzAAExkhdm6/VR45RKkwcDRafwKbscFGNmBmojqIw5Sk6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D1GqJKKC; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5KxfVPGLNSXTfEoUOVABM9RqLyPGO71t9IyeUYm67L1tUCt9EQVyHj1H/fEKuPdQu5m3PohlsSnkV0bxXaUHrsQI05aRCMRxMYRidJLnCqdCkOeSSp3qI682m+1Xw0+Tchiatx0oHWvJa1oRBFkVqFsg/SSSHyJf/AVwp3tXDMENi79td6qYnM7wzT5FU8wOIRX/5wNLXuOytyWapVPPvzugMI1jfHkxBVs8D3TvuFQek+7UnYh4lapowIx/MTFHmOF3oebyAFQUSC2PRd12qpmfPzgPeTIqxQlmfMenYriJRCtVIorHxl3VQxvq/1J30rm1eATrzcLIc8ki/5UeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jl5PR7y9zdCw/Ol4rSlMqXHDXphJKt1UruHl5X1xXks=;
 b=xV3OmXmfm7/H7zhPpC61r1UQE7oEtF6iCwV0+2uS8zD5qMSHGzlP+tH+o5EvHoWR0teB+icasRT0PYjo9d1EI7tW6INSrDr9CpJG3OfyqdwJFlQyMxb0uGoqAiItOKWSDN7prrLF0wjZiTaJmvHDO8uN7kYcaLM4CEMEOT3kzRe6F1s3VL1xNurgL42/rnmRiW+nuhaTqqnRIsniKNxWsd7Xd7CIBDbGRdeb2bW6gGupsO9ryOpVrY0rb07XYDPixv3Vzhm1RQKu/kwD1nGVdAB/xEww6OyApcA/IIwMSK8I9/Sgn2rUbm7IEqu36zUgE7uzTQ+cWoiGZ/TbIvhfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jl5PR7y9zdCw/Ol4rSlMqXHDXphJKt1UruHl5X1xXks=;
 b=D1GqJKKCYSNKqwbr1HTRF896H15Txb92QyBOSQncE2jk4KCo+SyoBO6MqC61Yzh9whLQhnwYWSK+KRtlYLG8JS6q93D2mwpy7V+anJspokVcPaJKk+x8Jlse/u7ZWapcpJ5AOHOb4ZGldwzLfDPvSjm68U5wSzqinT+MGCk9hdM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB7427.namprd12.prod.outlook.com (2603:10b6:510:202::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Tue, 21 Jan
 2025 03:59:21 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 03:59:21 +0000
Message-ID: <6cd04b94-bc3b-4772-b127-e2c8ba23b536@amd.com>
Date: Tue, 21 Jan 2025 09:29:11 +0530
User-Agent: Mozilla Thunderbird
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com> <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com> <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com>
Content-Language: en-US
In-Reply-To: <Z4gqlbumOFPF_rxd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB7427:EE_
X-MS-Office365-Filtering-Correlation-Id: 7925f4cd-c994-4ea7-f9af-08dd39cffc2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTJEcUIzVzRpSU5lWTJyMEcwZEZmYUNFK0MreXpiTzgvVUNZeUlPRThsNERy?=
 =?utf-8?B?YlVVQU0vWCtra29pY3pWWVNKdEc5WC9mMWVMMVN6aXYrM0pZOGtudms0WUhY?=
 =?utf-8?B?U2NhVzJZYWRzTHJ0N1hRcHQ4R2xIaEhudDcyMktJUkxxWDNhVnV4bk1jeFU2?=
 =?utf-8?B?c1d5dGZ1QWJmeVNteE4yeWRmcEdOU1diUXFXeEZPekZKYjBQN2dOY3BubnlZ?=
 =?utf-8?B?NnRaeDBKdHNBZWN4K0gvVTh6NTZHa0VuYWJ6Y2U5aUpWc0xSUlNvc1dhTE9y?=
 =?utf-8?B?OXBtTFVUSVFYL0Q3a2MwYTBnZkhrK3RvTjNhWm1aR3p5d2dUQ0ZhN3RrUFRu?=
 =?utf-8?B?UVRiUlQ5dHBVTHVwZjcyWmdPWTZWajBSWmpJL0hGZ3RzOXZKbUEzM2ZHSFd5?=
 =?utf-8?B?SFBBVlZhSHdaenZxUm41SmhhWll2dExVTHlBYmhZb0dRakRNOGFUM21xdURZ?=
 =?utf-8?B?TEpGbFQrRkszWk4xNmpaaGhXMm5hODNWSkpIdS8rTlZvSllrK3VJSHRNQmVw?=
 =?utf-8?B?NWlsWHpjZ3RWZGNGcUpPVU1zbmtwbnB5SU4zZnNpd05YVXFjSTgvUEI3Q1lM?=
 =?utf-8?B?cXd5N1lNeG96TW0waEdTY3VQdFZMVE9SNnFOMzhmWFB1bS9STTZ6ZlZhdDM2?=
 =?utf-8?B?aExNaDZKbjlLRmszdllQWm5rVVNtdVZmUThJQjlvc0cwY25LNGFSRnEwTkhS?=
 =?utf-8?B?NzFjczkzM0YvWWhucVVuSjRWRGdmUGsycjlHSVJhMXU2QW13SWppcDJxT2Va?=
 =?utf-8?B?OUtqTWh4ZGZ2ZEVsT1ZSd0J2TEg5WEYyQU16QTBxTmp1R2JzMCszWlFZOGc5?=
 =?utf-8?B?eHcrTDFvNXFGYVROVTdtNGxweGI4TEZkbU9QdGNSWVZueE5FbUoxT3R1c0Vo?=
 =?utf-8?B?bHZhRGJMdVQ3V1JwUWdpbzY0ZjNCd1dXTGxFN0lsbCtJV2FiR2dCZTBIVGdL?=
 =?utf-8?B?L0x5TEc1WnFFTHJ4ZVVrMjVkSHdNdGw4aHZ6aWlPZDdra0J3QU80c1YweU1Y?=
 =?utf-8?B?dktLa1RwUjZHM21Kb1BIcmFlSzQ5cmJmUTRLb0M3NHp4bFBJUTZRNnRYUWcr?=
 =?utf-8?B?eHpvbGtIallydXl6SVdWdHo1R3dnNUZZd2c1MUtwZ25Gc3A3UEhUdHFuRm40?=
 =?utf-8?B?N1ozaFhOUVM5VnhQSTNvT0I1WjN4Nys2Ny9zMHJZY3NNWUdaandNQXdOQWJB?=
 =?utf-8?B?a25vU1RYUDBNYmIyZGVNSHhSZnlVOXgzQ0pjQ3NVSklaWHI5OGdPQWpNY01M?=
 =?utf-8?B?dWg0WjJMRnROa1ZuREE5ZVkra3NTWHpUTjdqSEpaZkp5WkV5Q3M2ZElVNVl6?=
 =?utf-8?B?ano3TEl4M2MzUFUxZXdocEVxckdiSGJBWmpvQ0JVb1NNSUdkL1NMbjRyMXZq?=
 =?utf-8?B?eFhFWnE4YkQ3VllsajNsWG9QUDQ3Y096N3NMVmVlQVdTN0xRWGMrRHBSR2Fk?=
 =?utf-8?B?bUJtU0EyM2hlcVYzMFplR3RmMUFxYnVKSGVSU1RsVkpiTnZKUk9OM3VCNzUy?=
 =?utf-8?B?bDRJYzlIODl4dU9OOXRId3NkYTV3ODJiM2VjZG1zVXVBc282ekxBWFJEZ0tk?=
 =?utf-8?B?MUpEam4zcTlaUlYrTi96K09ud1hXdFlsVnRzd24rVnJ4Q3R3b0Z3ZHlCcjJr?=
 =?utf-8?B?dEJNWnViRWlrMVlKKzRBamk4em81VjdzZWJGK1MraEJqaHFGd2RLL1FLK1NU?=
 =?utf-8?B?MWErNisxU2k2UXUya0FyZmhlb1pRYnMrd21kK2hSNVNtNEhIMjc2N1YrZnkx?=
 =?utf-8?B?clVIc1YraWNWSXJlaDBCZXR5VEJTRW5pZDgzSVRpQlVrTWZ0ZEQ4d0U3U0dN?=
 =?utf-8?B?WHIxUm85b0FUcm82NFVQa3pCOU1IN2pKa1M5NDcxemMvbDV5SUxMQkhSTzk3?=
 =?utf-8?Q?+PnAEm+mxJDfL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlJsQnBjUm5uZzRpenhoZmkwUDU2Y1ZDTWhUcUJpK2d1c0ZhcVNXOXJzM1dK?=
 =?utf-8?B?WFNVNUZXVDcrQ3o1Rk1xWG9uNmg1QTBCZnA5dEgzUGo5TFk4dGZyclFTRFhD?=
 =?utf-8?B?ZVV6MUNQUmxDSkl4UEdwRGVsb09FNWsyTWdyVDJpZlErakt6UTF2dUNhekht?=
 =?utf-8?B?MElEZlhLd0FTN0tCcnNnY2ppMjZtaDdOMlRpQVNlSWtlZm9TeHd0VFZTQ2d0?=
 =?utf-8?B?SkhJazRQZnRJRzlZTzBuSW8zVjM0R0p6ZjAzaXBUNjFlTWxFcVNPSU1IWTlq?=
 =?utf-8?B?UTdxWEZPVVI5YWtPdyt3SXF0aUNBSllTS0VsSHVlRWwrcTFuVDc3NkdhT2Zl?=
 =?utf-8?B?dFp6bzdUeVhweG0xaFdDUlF0YUU3SldKVGhPVHdmR2V3RnFDTkFVZ3AxVTJj?=
 =?utf-8?B?bGZhWFNIYWprZ2Y5WDlHTE13VlZKNXhyc2o2c0ZXZUlLbUVkYUdEY3BySmRr?=
 =?utf-8?B?eERabE84QXhrTHMrQjBVWVZtUG5JVlQrbkZKMGs4ZytUaTg3MTZjbHRwdGFS?=
 =?utf-8?B?cFJIVlpGZVQ4d2hWWW5FRjJ3ZnloaHA5TUlqVU0relcwWUZYbXA0MHlleGUw?=
 =?utf-8?B?YXRySjUxY25mb29UYlNqWEQvaEFTbkNMK3JWYnZTcXlZTGtRQkxxMEJyMmU4?=
 =?utf-8?B?bFJYOFBiMnpnVENkMG5UYVRjK2hjK0hwQmh0NjZ3RCthR3IvMEh4UTlDSEpI?=
 =?utf-8?B?Si9KOExFeDZiQU9OS0VJc21UNWUxN1pyUU9DVEU0M2J1MFJJSGpOVXcrM0dr?=
 =?utf-8?B?YnZVNjlkM0R1eHBQNDVkcUJTMDUxMDB1ekpKaVAyL1FFcVBwOEc0R0o5VWpw?=
 =?utf-8?B?Tk0wZXhGcjRqMDNJOXpUdGNLN3Mxd3E0Q2VjZ285TTlITVYyTC9Kd1BXdzBV?=
 =?utf-8?B?d3ZXajFjRkplZC9ESjVuR2hpWEVDMkdBZDZIcTczUTFBSmpGZmEwR1hQdksr?=
 =?utf-8?B?S3JBQXVWSDNwZnl5VUtWVFltUDdGTWx2NzQ1cmZIV0ZrR1VFcFBpWU9yQ0pU?=
 =?utf-8?B?NnNXekNDOVl6cE42MnpnYlhpS2hCRXZvelB4b213QkZCa3VGa0p0ZkNsWktD?=
 =?utf-8?B?Tm5qUS9BbitROEwvQklMclNBK0FlNmFUZGdadU9LMjJBMDdaSVptcGtmeFZX?=
 =?utf-8?B?NWlEWjJqdXF0dUxMZ2FMV0hwMmNjeUxjRjZJQll1dWZYZmJlek9FaGlUUUpZ?=
 =?utf-8?B?SnBWL2RseVRKQ011a2lldUdyU3JSVkMrOW45WUpxUVBrM3ZIcVc4NlJ5bFBi?=
 =?utf-8?B?MEtuN3NLdWVoSEVWNWF5L0xFaW1vMHI0WnJQZWt4bjJQR05oM0Vjd05iS3A5?=
 =?utf-8?B?K01iS1B3VGJzSzB1WjRhSkU1V3E1YWhNTVMwd3d6YnQ5WFRwbDJGckRGMExM?=
 =?utf-8?B?OStzUUZscVgyYVUyb1JxU2hoajJGaEt1WHpFTGJkVDhpQXF3amUybDh2M2c0?=
 =?utf-8?B?eDdkRENRRXJSVWl2WE9FZzFNSG5qb3k1Szk5VXY3QStRVmtvdCtXMjEyVGRL?=
 =?utf-8?B?dHFmRXEyMUhqaHRzUVdnWVRrM1lNSjVRVEpLeHRoc1p3TmNGZDloNnpscTUw?=
 =?utf-8?B?ZTR2TEdYWDYwMmRJNGU4dzdlell2VmVpRGlHNERzVHhqL0RDQ3RkMTJJUklU?=
 =?utf-8?B?QzB6ZlBWU2p3WVZvcmdCVFQ0V3MweW1ya3I5dSt2dksvQ3BCcU1SSVhrM3Bq?=
 =?utf-8?B?YTZ3ZXdFOUFxQUxlcFh2MXRvWlNGazNpNjVrK0pwcEVyNVh6Tk54T0NoRkky?=
 =?utf-8?B?eEd4L3lqUnNkUGJiSGZSYm1HRHZwMmVMS3o0NjdhTk5SNW83bU96UndrNmla?=
 =?utf-8?B?RDFSNUt5WEdVRFJTNnprWkl4b2h5QlFFNEVMaXMxT0l0ckJVU0hrNjZWeFJ3?=
 =?utf-8?B?YlBuVjl5dFNkQjhQN2dKMFFwMU1jYytyb3ZpNElZSnJBclN6QTlMMkF3ZmJh?=
 =?utf-8?B?cmxwN1pDd2tqQ3hZNkd4QWZRMUZBOTZHRXBES2dyTzU3dy85dmlvVEZ4WVVV?=
 =?utf-8?B?TElRY0lMdG8xMXorOGZCTFpZUWtUSkFSZWtEYjk3QmFLdUxnSGN1ZGtnZHg3?=
 =?utf-8?B?a2pvekpwVEdpQVhSM2F4ZCtZOTBzV1I1aVNIWTFSNmtnN3ZpOG5ub090VzFi?=
 =?utf-8?Q?9WUy6CIZfqhcIO2DEPlGq1baP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7925f4cd-c994-4ea7-f9af-08dd39cffc2a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 03:59:21.1726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfKMkrO2Du6tARClo0vkEsJYw9jYvhQa3GALED/oEIhqow3uopUPuoDM4EVxHtRzaSsGRtoaCrs6kGGtl4uQnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7427



On 1/16/2025 3:07 AM, Sean Christopherson wrote:

> My strong vote is prefer TSC over kvmclock for sched_clock if the TSC is constant,
> nonstop, and not marked stable via command line.  I.e. use the same criteria as
> tweaking the clocksource rating.  As above, sched_clock is more tolerant of slop
> than clocksource, so it's a bit ridiculous to care whether the TSC or kvmclock
> (or something else entirely) is used for the clocksource.
> 
> If we wanted to go with a more conservative approach, e.g. to minimize the risk
> of breaking existing setups, we could also condition the change on the TSC being
> reliable and having a known frequency.  I.e. require SNP's Secure TSC, or require
> the hypervisor to enumerate the TSC frequency via CPUID.  I don't see a ton of
> value in that approach though, and long-term it would lead to some truly weird
> code due to holding sched_clock to a higher standard than clocksource.
> 
> But wait, there's more!  Because TDX doesn't override .calibrate_tsc() or
> .calibrate_cpu(), even though TDX provides a trusted TSC *and* enumerates the
> frequency of the TSC, unless I'm missing something, tsc_early_init() will compute
> the TSC frequency using the information provided by KVM, i.e. the untrusted host.
> 
> The "obvious" solution is to leave the calibration functions as-is if the TSC has
> a known, reliable frequency, but even _that_ is riddled with problems, because
> as-is, the kernel sets TSC_KNOWN_FREQ and TSC_RELIABLE in tsc_early_init(), which
> runs *after* init_hypervisor_platform().  SNP Secure TSC fudges around this by
> overiding the calibration routines, but that's a bit gross and easy to fix if we
> also fix TDX.  And fixing TDX by running native_calibrate_tsc() would give the
> same love to setups where the hypervisor provides CPUID 0x15 and/or 0x16.

One change that I wasn't sure was about non-Intel guests using CPUID 0x15H/0x16H,
that you have already answered in the subsequent emails. At present, AMD platform
does not implement either of them and will bail out from the below check:

        /* CPUID 15H TSC/Crystal ratio, plus optionally Crystal Hz */
        cpuid(CPUID_LEAF_TSC, &eax_denominator, &ebx_numerator, &ecx_hz, &edx);

        if (ebx_numerator == 0 || eax_denominator == 0)
                return 0;

> All in all, I'm thinking something like this (across multiple patches):

Tested on AMD Milan and changes are working as intended:

For SecureTSC guests with TSC_INVARIANT set:
* Raw TSC is used as clocksource and sched-clock
* Calibration is done using GUEST_TSC_FREQ MSR

For non-SecureTSC guests with TSC_INVARIANT set:
* Raw TSC is used as clocksource and sched-clock
* Calibration is done using kvm-clock

For non-SecureTSC guests without TSC_INVARIANT:
* kvm-clock(based on TSC) is used as clocksource and sched-clock
* Calibration is done using kvm-clock

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 0864b314c26a..9baffb425386 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -663,7 +663,12 @@ unsigned long native_calibrate_tsc(void)
>  	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
>  	unsigned int crystal_khz;
>  
> -	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +	/*
> +	 * Ignore the vendor when running as a VM, if the hypervisor provides
> +	 * garbage CPUID information then the vendor is also suspect.
> +	 */
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
> +	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return 0;
>  
>  	if (boot_cpu_data.cpuid_level < 0x15)

Regards
Nikunj

