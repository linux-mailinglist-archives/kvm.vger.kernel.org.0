Return-Path: <kvm+bounces-25226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB37961DBA
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 06:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49A40285553
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 04:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8665F1494AC;
	Wed, 28 Aug 2024 04:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fkP9Y82C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B808B2F41;
	Wed, 28 Aug 2024 04:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724820494; cv=fail; b=PXIqSnOQDVv4LWFbsAgxcTcdqAy+PIPD1dxTOf7NXwHFaF2pddmiGTksapDotwQFd2xk/bn/Aa0AjkTXl5ejxRhpH+72d2UEZf+aTKPgPf1PsfzBzyN8TyyGzQYZXuQYJytT+kIE/CikXonfOOM9tHbTA3dscDUeujKQUANW1dY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724820494; c=relaxed/simple;
	bh=/IGKssr3YFrl+HkraMMlNz3OKynZscMdH5F8Wg2dTsE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hawQMw20r6QrTSMNMs7cjR8s2WJ5S6bGVkq+ZQJkvr/l4Az2LbwFnQ5uE5acmLuZiuZYRVekPQfGnwzvq1uiquCF+79k1bpFfw9oi7pyB62leBZpGicxtoMY5EV9cTZ6c2OjGUAdLxBP1AQUsG7LrGjL/eu4l35L72hVUT0DEKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fkP9Y82C; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrpdgdrE3NksoV+JmW/G0hIj2aB2P8ppZyBKAfYNNs0+hs83/ZeHbIgwbpGfwts5c9htc8vxdZaGSjbj3awMBqchqEzJIu0biVxmaJ/YqY9svCToI0J/wsuPmk9GwNCz9lge9m4XZXx7zxMr3TVrWsYWtA0tYAhq9tIMJnd2HnzKTGR14QGLWUezjTaia4v28xYE07Uia8k9/dgTPpvk5Phe6ZsO5EN/sQfypvKekT2nJhlqTSqZzGYDOMR2CfRqMlqIyl9l3s5sIFHfLpdOXHtp844ot9NXPby3xh/GGfaOGgkbMqGhJgWojgPSH+LP5TBjw0Ebze3J2Zij3eG1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaGQP+WG2NZecywiXCc7Rk7lPFuFOtzlroVYvhM+4Pg=;
 b=Rh1LT5K+GykSkKiz6bvAqHd1gHhsgO11PzFj7JpTUbRZgXTAAmnwtohInQ9GN5bqgEqR7k/I5C9kteD7ofonNcv/BHLuoVLdoUfzzRPEuW8X2FbqgH/nLBI0lEE6RRnuHpWbwFrOD3kS9hAfgMzpBCfqDcQivfmL0gXG3lxSsbnVHO3XctWd1O18hR5xGqdh8AJZAb0z9tczUOQDB1710c3ihcy4m1j839x++Msg31NfUdw8USwDg7EIvwf/V/Q2/hf1HYQ+dY2xBFDp3LDAQoFxGP1WLygfZNwSwECFl8cf+IfzIX1QWIlUHDiAf/iRPSV7F2rtr1NscrTixF8W/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaGQP+WG2NZecywiXCc7Rk7lPFuFOtzlroVYvhM+4Pg=;
 b=fkP9Y82CdnjLGjz0orYQekikJCFC4aaIvG4TC91+VljuILnQYXjrgTA4VOyIQi8eGUOuRqjIgpGXrwsEUK03ZTcI4yU9AKYKOmocHbf9dfv41bb/HcfEw0p071UNnTugXU3hKXs8RuqipMOgtaY2DQ5/LIpUgeI2wdbVOXNHq3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7SPRMB0010.namprd12.prod.outlook.com (2603:10b6:8:87::8) by
 SJ0PR12MB6830.namprd12.prod.outlook.com (2603:10b6:a03:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Wed, 28 Aug
 2024 04:48:07 +0000
Received: from DS7SPRMB0010.namprd12.prod.outlook.com
 ([fe80::b021:a6a0:9c65:221e]) by DS7SPRMB0010.namprd12.prod.outlook.com
 ([fe80::b021:a6a0:9c65:221e%6]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 04:48:06 +0000
Message-ID: <5b62f751-668f-714e-24a2-6bbc188c3ce8@amd.com>
Date: Wed, 28 Aug 2024 10:17:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-7-nikunj@amd.com>
 <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0194.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::21) To DS7SPRMB0010.namprd12.prod.outlook.com
 (2603:10b6:8:87::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7SPRMB0010:EE_|SJ0PR12MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: ca329d7d-f27f-4bd5-abb0-08dcc71c9b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXgzYklQaFRNQ1dzTlZhSmFLdEN0SE5USGtWQnd4Wmp6UEZObFErbVpmQVFZ?=
 =?utf-8?B?NERJSm1NNFpCd3FJakFJQVdvSWYxcnExZlpHeDZrTTRjSVJrUHYvNkp6U05k?=
 =?utf-8?B?SHplRDlOMmprd3RRZ1M3K2lSRDNDYmJhNTVKRUF4Y055QmxQR2NMK0VxZVVz?=
 =?utf-8?B?cmlRcWdTa3pVNm9mYkVyTkZ3NEZNSkR1aWZSdEY0bXpLakxMa0djd1pIVTI3?=
 =?utf-8?B?UzdIWG1CZ0lYbHhCQnRHUDZOeXFrMElISUJ4enN0UEZJR0N6cHB6ZEt1UGdP?=
 =?utf-8?B?eDZiMG90dkN2a0lhZjlHYlRVSlIxZEJPRXNidG8xUm9GSHdmTTVCb1FPeG9V?=
 =?utf-8?B?RGlxT2prSE42NjUwS1czME5VTS9lOVpwNzZNYkRDRXZUczVZd2IzSllydXJI?=
 =?utf-8?B?ZjJKTXRoZ0tFekhTYmxCQXNwazZ1TUg2R2VQVVZ0VmxMamd0Ym9xK09Ca3hE?=
 =?utf-8?B?b2NjaTJCUGloeUpEMFEweUZPM25mdUU0NEV5Nm9NQ2VvWXYxOThIM0dOWmY1?=
 =?utf-8?B?WDlCRTlwdHVYbUJubFRtaDFDWVcySVBNRUUvem9DRkw3U0phY3gvZGtPVGxx?=
 =?utf-8?B?MmVLQVh0WnhZYnE3aitrVXdCTE9FWkE5aUtKQVY0STg0TWROOFB2VGczWGsv?=
 =?utf-8?B?eElHNzRpcjl5U3VhK1V5TC9aaGJFWTVWR0tKN2Y5dGdkdzViQ0xyUFVqMFdP?=
 =?utf-8?B?NncrOEpZR1hwTFRSR2tDMEloM3JCS2FpYTJWL2FFdkNoUFlLWjZHQk5CWjdi?=
 =?utf-8?B?dCtzc2JuUW9ESnNnaEhZUkxmYWlXZ05nWnRNN2E2c3owdGlvTTNaT0kxaWNC?=
 =?utf-8?B?UWxIZmhsNHZPZzQrUFBwZEcrdUEyZnNMZ3BCalc1QzFrUFI0SEZ6WldzcjlR?=
 =?utf-8?B?OFNDMXdBMDd3TXpXSTlGTnhPY0ZRTGtVWGlSTHhqQS9UYlZWWHJzMnZOQzlx?=
 =?utf-8?B?VHV1c2k4RXBpU2lUYlRoVkozSHZONFVwd2xYazlHVkJGUzlILy9vMXRxN0oz?=
 =?utf-8?B?dmhiUVVVQ1RJR2ltM042OVFRVVFVcUxZQnNCN2U3bWlWNHFML0drbU53RFJx?=
 =?utf-8?B?dmNhWVFJRDlwVUhuUTNFWU44WGcxNStaZUlIZVYxQzFUWHNjNGxPZnhoUzd0?=
 =?utf-8?B?dGxyRHhxV25XaFNILzg0eU5IVFpyL3ZOaWh4YytOSlY1NTVFaXNWWHhxUVBm?=
 =?utf-8?B?TnFZaUR2cjRHYW1INmdtaWQ1bk9NQnJGMit0elRuYUR5MW00SUw2Q0VRcXpU?=
 =?utf-8?B?MjZhQXVWV3pCN1F0cnZaSG9CSy9JOWZhS3VSL1p3WFlIbmZ4bExOZU11MENH?=
 =?utf-8?B?OHRHTi9RamYvV2tMbFEzUW1KbTB2Z0pRMi9zSXpQaEpjeWszaytJSERxTjRC?=
 =?utf-8?B?MGJWU2c5R3drdmpJRHJFbm1HdkVxaElLclN2MHV3anpHaEFZM1ltN0RjSkZJ?=
 =?utf-8?B?dnMzS3lSaEcvNjVxc2hLNVlwNEl0Y1BVQjBtOW4wamMzd3B3bTBERDBuUllK?=
 =?utf-8?B?SHhyVlJEclZ0NnlURGVaOERubWtCUE96bSt5Rnc3ZnpVbUx1UEtKd0xDZTZr?=
 =?utf-8?B?Wm51RVR3a2s4UGRNd3A1c3VqbU02c09SMFZLZTF2OU5IT3hMYjdVb21CNm1C?=
 =?utf-8?B?bDVqT0RnMm5nN2Vjd3dlK2FiazhmUC8vM0Uvc044OWF1UGhjbEpXQXJHV1VT?=
 =?utf-8?B?aDlkQllIaDdsbkdlVExPVWF3RTRTYy96NUMvK0piNVcyaWhRcjJkZ2l6WDR2?=
 =?utf-8?B?VkxDUWNBcXk2eDFGdkZ0ZGREZWc0OW1hb0t2SG5ja293VXRFVWcyb1BRM1JZ?=
 =?utf-8?Q?65mSnFnW5DQvjzRCUM9KjMh/aj0KpJoj1KEw8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7SPRMB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWk3T096ZjI4WjErV0l5V1k2R2MwemxvT2FMakkvKzFyU1d0RElQK0Q0V1N5?=
 =?utf-8?B?N0xzd2wraWczVTNYWDlrekMveEY0Tm5FbVQ5eWc1aHBUMWlYVGkweXpidGZG?=
 =?utf-8?B?ZUtRRityNkFnU0lIb3I2NXdkMEtMRGduNkxHVlVOb0FSbEY1SDBVTjNFV0ZM?=
 =?utf-8?B?Y1ZibEtUWjVmNWtSS2lLZFhkSFV5RGFMV0ZmYlpRNzhIN3dUUFEreDBJVjE2?=
 =?utf-8?B?WTNONTBjdktYT3BlMXZSSUdiYTMyN1hTcjMxbUNNeEZYejZ0WFMyRVFHbjZw?=
 =?utf-8?B?elk4cTNJaUFaVG5CZG42OFBIN1pDK2puajZQWkJwOWlGRnpsWlFUS0FZbURt?=
 =?utf-8?B?QlZwUjFlQUt0cThGK3VnRStCZ3RDa3AxTmhpRUlzVkJrTW9NWDVseHpEbWx3?=
 =?utf-8?B?SUVTd3ZuNEJ6QXNBNmRWbXJ4U2VDN3ZLU2VFaWl4bVRPR2FZclRSOTBFMVgz?=
 =?utf-8?B?VUVQVnRhcWRTSC80dGFoSXN0cUhuZzVkVHduQjYrRW1qdjBOWGRjRzNsUHZJ?=
 =?utf-8?B?N3hHUmlYc2p4Kzg3MEdJcjUyUlBPalYwOS9LMTIrOXpzUHkySldzMFlGbXBl?=
 =?utf-8?B?MWp3OU9oeU81cktMNnlibG94bzhaQXRLQ3lhVHhTVHdCZ08rRWkzRnRGRk1m?=
 =?utf-8?B?RzJ5akJ5NHkwVTNTd2pwdFlZbG1vMUNpUGVzY3dDRTU2OXg0TTR4QkNzRmY5?=
 =?utf-8?B?TGtmK0F1c0tSLytBU1VpclZVcnRQWVM0UDVLNnVGUEdlRUh2UjRLK254Y1ZS?=
 =?utf-8?B?TUZUUVdSK3pmeVNaRlhzM0FmVUlCVlpVOWhUeEREc1Uwa1RGSUJleG9DTXQ1?=
 =?utf-8?B?RWxLM281dzlkU0JyOUtNSnFWeitYRlM0NVRaUysyb1U1em1zTHNTdjRqQ0RF?=
 =?utf-8?B?S2lGVTZobzZQT2cyZUI2bmpza054MGxuTUFyb0VQKzN0RE5leFlnNWNsaUJ3?=
 =?utf-8?B?SEpSdkdKSCs3M1pZc3lTM2F3ZE10S1ZHcFA3aDRMSW82VWNMU2R1RzZDOEJQ?=
 =?utf-8?B?cWdLdkwvenR5azh3QWluWno0ZWxlMUM5ZmFPQVM5NTFGT3Rld2NFczhvSG41?=
 =?utf-8?B?VitUNEVTb2ZlRm9uQjl2SWJsMUFpRTJnYU5Zb3ZvL2VlS0VURlNIOHhCSHk2?=
 =?utf-8?B?WkNiQUh3dUVFL090eTgzS0lzTnlRVEQrVmJLcnUvMkNkTmFXMUVqQ3ZkSXkr?=
 =?utf-8?B?aHhBSGppSTRYeDNtQnFwM0Ruc1N4UHdVOW1nMk1HUFZjSjlnV0dna0VjMDl0?=
 =?utf-8?B?dE12QUN3VWVDaWpLa2lJbnhxSHNPSDhmTE1wM05NK3VLWVNRUWhlcHA3ZVhC?=
 =?utf-8?B?QnRjV2xXVkh4OVZPbDdmb2d5NE1BbFR0MzhwamtSMXJJRk5haTQvdkF0WmtT?=
 =?utf-8?B?N2QxYnRKWk5NNVJFV1NHMmVEZG50ejhkZW5xbGs4amJaKy9KWWlVeDUzUm82?=
 =?utf-8?B?d1JNMW9jRVJiRU9tMGNIenNBY25IMTNLTHo2Q2kwQWVvaHhKeDlTTEFITjBQ?=
 =?utf-8?B?cEZ5dEtIbVZjUnN6NTZOQ3NJODM0TVRLM1pCem5rU05ORUFmSlk2QWtMbGV6?=
 =?utf-8?B?VXo0TXk3WE5LVkxUZFlrYnZib1U0K2Nhd3NIVnB6MGtJekluNWhGSzd4UzVj?=
 =?utf-8?B?SWJGelpmaFhENTNGSHVCN2dxUVVMZlNnazBQTDlGaXd6OCtrL2lTeURLRnI4?=
 =?utf-8?B?Z3ZhWmtJVlpObmJPUTZidVVpaGFGWkttdFZUVXlYNTM3RkQ3WnRQdTA5ODgz?=
 =?utf-8?B?azdhLzQ5QStTc2tsM1pJRmlKNVl3R1lJRU9IZnd3NzVtVmxNK2RMNVFIVElG?=
 =?utf-8?B?YXAyZTJKaGZ0dldtYUpYYlRkdCtHYU43bmpKeG1EMndzTkcxRHArOVNMSmMv?=
 =?utf-8?B?cHZmdmROQWRtUTZyd2lqRm1DcFFuQnpsSU9tTDNiSTFLUkVLaWx5c3ZBSkpU?=
 =?utf-8?B?VFN1TXBieEwzdHRzcVFjWmRXUUVrT09vYWhyS0lwTlZ0ZEVwRGlJTmhMT2Z6?=
 =?utf-8?B?NFRRLzJrYUtLY1NpM2J6MFBmcTI1REVBTjFwU2N3VkY5TnBHTmNaQjkwTmpP?=
 =?utf-8?B?U3p1ckxtNDhQa0l1U3l2UklDdHRjc3ZPN3RXQ2NGaWhhYTEydThacVNHYzQw?=
 =?utf-8?Q?fjXv2lzAfrI8LfG+7cgwWdQIi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca329d7d-f27f-4bd5-abb0-08dcc71c9b61
X-MS-Exchange-CrossTenant-AuthSource: DS7SPRMB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 04:48:06.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2OPLC93iIbQD4SOm9LWw2kuGykMKndGrNwc4zaS3FOjTNaWl0zM1hBbhKtauAQrBqtSnfYI25NkBixnzCWjrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6830

Hi Boris,

On 8/27/2024 5:02 PM, Borislav Petkov wrote:
> On Wed, Jul 31, 2024 at 08:37:57PM +0530, Nikunj A Dadhania wrote:
>> Address the ignored failures from snp_init() in sme_enable(). Add error
>> handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
>> blob or encounters issues while parsing the CC blob.
> 
> Is this a real issue you've encountered or?

As per you comment [1], you had suggested to error out early in snp_init()
instead of waiting till snp_init_platform_device(). As snp_init() was
ignoring the failure case, I have added this patch. Following patch adds
secrets page parsing from CC blob. When the parsing fails, snp_init() will
return failure.

> 
>> This change ensures
> 
> Avoid having "This patch" or "This commit" or "This <whatever>" in the commit
> message. It is tautologically useless.

Sure, will do.
 
>> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
>> index ac33b2263a43..e83b363c5e68 100644
>> --- a/arch/x86/mm/mem_encrypt_identity.c
>> +++ b/arch/x86/mm/mem_encrypt_identity.c
>> @@ -535,6 +535,13 @@ void __head sme_enable(struct boot_params *bp)
>>  	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
>>  		snp_abort();
>>  
>> +	/*
>> +	 * The SEV-SNP CC blob should be present and parsing CC blob should
>> +	 * succeed when SEV-SNP is enabled.
>> +	 */
>> +	if (!snp && (msr & MSR_AMD64_SEV_SNP_ENABLED))
>> +		snp_abort();
> 
> Any chance you could combine the above and this test?
> 
> Perhaps look around at the code before adding your check - there might be some
> opportunity for aggregation and improvement...

Sure, how about the below patch ?

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Wed, 22 May 2024 12:43:42 +0530
Subject: [PATCH] x86/sev: Handle failures from snp_init()

Address the ignored failures from snp_init() in sme_enable(). Add error
handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
blob or encounters issues while parsing the CC blob. Ensure that SNP guests
will error out early, preventing delayed error reporting or undefined
behavior.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/mm/mem_encrypt_identity.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index ac33b2263a43..a0124a479972 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -495,7 +495,7 @@ void __head sme_enable(struct boot_params *bp)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned long feature_mask;
 	unsigned long me_mask;
-	bool snp;
+	bool snp, snp_enabled;
 	u64 msr;
 
 	snp = snp_init(bp);
@@ -529,10 +529,17 @@ void __head sme_enable(struct boot_params *bp)
 
 	/* Check the SEV MSR whether SEV or SME is enabled */
 	RIP_REL_REF(sev_status) = msr = __rdmsr(MSR_AMD64_SEV);
-	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
+	snp_enabled = msr & MSR_AMD64_SEV_SNP_ENABLED;
+	feature_mask = snp_enabled ? AMD_SEV_BIT : AMD_SME_BIT;
 
-	/* The SEV-SNP CC blob should never be present unless SEV-SNP is enabled. */
-	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
+	/*
+	 * The SEV-SNP CC blob should never be present unless SEV-SNP is enabled.
+	 *
+	 * The SEV-SNP CC blob should be present and parsing CC blob should
+	 * succeed when SEV-SNP is enabled.
+	 */
+	if ((snp && !snp_enabled) ||
+	    (!snp && snp_enabled))
 		snp_abort();
 
 	/* Check if memory encryption is enabled */
-- 
2.34.1


1. https://lore.kernel.org/lkml/20240416144542.GFZh6PFjPNT9Zt3iUl@fat_crate.local/

