Return-Path: <kvm+bounces-27760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67ABD98B7C1
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FE9A1C2298B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 08:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4DE19CCFC;
	Tue,  1 Oct 2024 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3vtpuUD2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346CF19AA68;
	Tue,  1 Oct 2024 08:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727773188; cv=fail; b=KJtGlEz+fCDYyhJsFe9a6Yw7VbJfW9QS4VJVFt+6qebm5x6t2Pqg47Lrhh/UKQ6fWhiMp0dd8SKRl40C5BNCyk6VZ5YgfXn0Rz3cITGVEFG1aVSADBBtGw9p1+Cjntkctc7Aio5PXZjbS90cyCgATIF89YTZO8WHb8xWZb4KtHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727773188; c=relaxed/simple;
	bh=MTheroJvAXJiZT3+61fFNldC3z9L6OYJ6oGXan0d7wI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uf520qP8sNSEgf+i1sX2M0QUxYHK+U+164vPNRi2y7tenVh+0l1eyPBKQnKN7+bwnpfvtqzVxSvWAvk9jmkYgfkDG/1/o73X49+3LGrbsg2YQdM50pTRC3RKmKUTyojAQjEqjq/qBiseWLBn/kGsSmzLjEMJt51QiA2RBhurpxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3vtpuUD2; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OaKbyb2vLqp1TCilxe3Y3wZ05dygXE2ZHtjt5nyHEfvxcU3Vuv4wOeXCL89MnkH9IM5aLsRo797CWB5iR8hFpccRqnZGMJBegJdMZyfEGwZFyKLl58t/WcSz0k5Clq85gcPO1OGFOpHjmKa0wPcV8otjaZ5RppaUOt70OESRJmqaeb91S/rHIvhbF9QswZMA9qlh5JE8+X5VIeZJjBt5xFO1mdwmFepxl3Nb3YYnUp/R+/WPfcwCc40JXKpuWBCEkMGFAcTEilew7UJCx2r4VxmBm3n2GMeWJx3sJqWdHNrjjaA+mcAVMOzhFR7i8qS/Gma0sIOL0CrOGu7vpqdLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g86IbJysAUIPKQ8PRVfSRh34ykycy+XzUM7B1AyMYvY=;
 b=YvMQqHm1ZQfbOjunHDS0a3fCjmFOvvNUahIv1ER6J43sInUlWzjoSrO1R1rEBjNJ/WK+kqsJRb1UL61iNllo8fxuqeWB+d5J4c974C6tkan/vD4aD+RVF22rS10lwBC/Y1pJVIInLpPkB2rj7RFjBhDq5DqzirfM/1XYquH2BBQEzJxtaDCNi8o6+E1CV2ela2Cf1tgPYFLbXKJBsorFh4GfMFdnYJObqskrah9xk3qbrnVAemoMLDMxX487lSvC2lhbWxWxjWg1SMIPrO9uIOe+yN7wPgAma1jRtIWP3IsOQzQLu+bfOgRGQRCt+nRF3F9XhsApzWj8woJ5WJ0vPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g86IbJysAUIPKQ8PRVfSRh34ykycy+XzUM7B1AyMYvY=;
 b=3vtpuUD24IODbGwj59Zr/OT2/jRrVAVc0uP4HUVHeIWV9lVKn2FHuxvk+fvFA6jreMPf43tqPTb2McRYXF093bwddOnLw1lkqJ8B8tydo7OXv0upJ6Z+D9dIzW6D9JykQd7S1BBuViuSJSPnNR7Zlc5O1lGS6bePG6oyyvl13OE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH8PR12MB6937.namprd12.prod.outlook.com (2603:10b6:510:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 08:59:44 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 08:59:43 +0000
Message-ID: <2e2e6161-9f65-4939-8061-83bf71810076@amd.com>
Date: Tue, 1 Oct 2024 15:59:37 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 david.kaplan@amd.com
References: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
 <ZvrMBs-eScleFMOT@google.com>
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZvrMBs-eScleFMOT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH8PR12MB6937:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b7674b3-017d-4a91-b9ce-08dce1f7643e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dS9aMUtjVVFMZXk3dlFwS0JiVXFoaUFjeHh3TnByVFNHb2hXRU5SUlo2dUpY?=
 =?utf-8?B?Y0FBUzRSbUZUbUNBY2pXYWI0SnVTZlRmY2l0aEdIR1RqMEpvVnU2a2Z1VTRW?=
 =?utf-8?B?T1YzN0JwNnVOVHlodWpyeDFQaE5ZU1l2cTRHVU9aQzM3UnpWKzA2RWF2LzFT?=
 =?utf-8?B?MlpUNCtjUGJlQzdSV0k1ZUtwNDcrSTluQ0FUN083eFNLKzVsYWYrc3FsMVlY?=
 =?utf-8?B?eWpaLzJxZ0QxdC91dHB4S0cwQW9FV2tSa1lRTlJKZWtFVVNLTkV2VWRoeVJE?=
 =?utf-8?B?SXdvZ1NiYWFUU0l0Y1I3Q0sxYWp3S1p4TTJRVFVxdlRtamFnT3dCRnplNGdB?=
 =?utf-8?B?Q0JlSWlsZHY1WnJzaUgxZmo5ejMweTdnY2d4QjAwUi9STkhDS3dQT3JMaVRl?=
 =?utf-8?B?OVlidnpMeUxwSkYxMFFYOU9ZS2FlM0tnVXNJZUxpMmNSQWFGdzE3bGFzUHZz?=
 =?utf-8?B?WXJpWG04QWdtd3ZiMFkvTXphNnJjVkhFZnJ0d1hBOWo0L21DbWRHbW5zZ2FK?=
 =?utf-8?B?N1BJeDdMMDlNM081OEg3RzVjNDBtd3NHSnVuNEhNdVE0MmNJa1JTMlowVU5l?=
 =?utf-8?B?YjBMR2M2TDlJc0I2VWRyZnRwb0JNSGttZ0kwWFVGOHo5WTZzUWQ0bmhNUEhz?=
 =?utf-8?B?TVE2ZFVWODFwODgxdkRZUU55QzFkR2hQSk9HU1E0Tmxka1pEWHdMc2xINkdh?=
 =?utf-8?B?YkFSYkwrZG9NcnAzeXlIbW1XMkFBZi9BNEpTY0JNM2RWNUNZYW8rS0ErVnM4?=
 =?utf-8?B?Uk5KT1hjQitSU2hXeEdIQkRNMHNUUStwdTdGWlY5OWpVNXJpTS9IMitVUWRB?=
 =?utf-8?B?dHJiVWJ5WU5FeVJJUkJGUEZ5ZnlybmhpYU1JU2ExL1FRSFc3ZHZwcERKQnBI?=
 =?utf-8?B?MFJpOTRybHZwQW91QUwrbkRyZ0FRVUJFUDNuc2J3T3FmVVA5Z3RRNGlGTjV6?=
 =?utf-8?B?TmFoNXlzTmZTM1FEMUpGdUQxTXpJR1lsZjNzSE9rMlVWVEZveXBoYnJ5Mk5Q?=
 =?utf-8?B?bGkwM1V3UTNKakd3eGl3M3l1ZVRiODVoRjlUNHZ6M1VnbWV4dFFQdDhYQjZ5?=
 =?utf-8?B?anZDVnRJb1ZJQ0I0aE9FU1pqeUNkYkZlZFJraSs5bzc3SnJITWpSM1lMd083?=
 =?utf-8?B?KzN0ZWVjd3k0SGh2dWdoMTFvOWM5c0I2WDhuVG1PekRpaUluQTFvQnZrYm1M?=
 =?utf-8?B?MGxZZHJoNkZZbHJBN1g3dmNweEMxajhuK2NBMTNURTVIeVhtSC9GVy9pZzN6?=
 =?utf-8?B?Y0RDQ2puN3owYThoNWNCL1hkejVEeFNMOHlkRXZLcXhVMmx3L2Yxb2Rmd3Fx?=
 =?utf-8?B?c1VEUG5mVXBXRFhPSUhjbmlrT3E1MlowSTFrVCtFL3ZiaUszM0VOZFpPbUxM?=
 =?utf-8?B?aWtXYml0LzRIaXRWQTdiZEdDVWdPQlpUV2ovYUZEOHRjMldnanZZVWFpQXFT?=
 =?utf-8?B?YkFhL1VzUjlmcjRiMDZ5TkJBc3VSdkNNcUd5aDRSQmozQWJ1aWNuT28rbG5x?=
 =?utf-8?B?VWFKWTYwZnBCUHdPa1d4Q1IydFIrek50bGtjSkx1ZE9odHhDWnhqdTlKVzNq?=
 =?utf-8?B?Wk5sSlhZcFZvZjRRYlVMK3B3Vkh0Yi9TT2FrQkg2YjdDUmlSeVFjaHQxekZG?=
 =?utf-8?B?aVlsdmMxSzlvQkdzN3l4N1o4Y0l6Nm9GRWl2dlpGUFMvNnJYN1lEN0c5bTlH?=
 =?utf-8?B?ZTZVOHAzbHBMWGw3QkJvM0hvcDFObi9UbzhkUW95WGkrUElnVHZCdTV1dkFL?=
 =?utf-8?B?bE4zK1Rpb1d1TzVVV0p3M05RSVlJdHUrR3MvWmdpREpKZ1hjRWdVbGZnZ3BV?=
 =?utf-8?B?elE2dHFuKzc5N2NMRERtUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wmd5M0pKWnBOQmxuUWluTnA1TlpGZEI3aG9OSHMzdENRT2NUVFExTG92UDJQ?=
 =?utf-8?B?bWNOQXJYU3lNNE0wYkJCaFRkZG1DQy9EMW9pNC80aDJ2ck01WWo2R2R4b25h?=
 =?utf-8?B?amZhMGRtTTcrdUU4V2hKbjlqNGJZN2hMY3VlSW54bWkzaWN4TFlrNGJqRHR6?=
 =?utf-8?B?VC9Gak9mTzFkN25GSjZFUk9kYTI1R1lpUGhESk8zUnh3OGtvUFNUYUp5b3ZZ?=
 =?utf-8?B?RkYvekxiZG5haU80a2FMQURhS2s1YzYvNGpmTGR4YU9VQk9hZlYwKzB0ZHNp?=
 =?utf-8?B?SHQyb0kwdzE2ME5KVmVwRW1tb3ZPUzEvc0lyRW4rRXNobm4wdXZpSER0REhV?=
 =?utf-8?B?WmkwQnlYVnV0Qit3cEpFKzN3aXppZENDMUIrN2llcThOK1hJNzl6UEp6R21r?=
 =?utf-8?B?OC9WMW40UnJESEtjWi84VXg5LzB3UmVEOG9KTjRpbVE1MldLTlQzdEh0WVVX?=
 =?utf-8?B?MXZRSkRHYUk5RTdQclZNS2p5YndoZG1oZ1ZKVngyYUhmVVZxR2FaenhQMHJE?=
 =?utf-8?B?Z20xTjJPOEkvMCtZTXZsSUMzVS9lclQvVE1sVDRhRTN6U2w3T1pyc2lvYVlp?=
 =?utf-8?B?ZmFuaUJ0RDBDTUljUXB3aUlRSE1uVzhTYzQ3WHhWR2dFUkNsWUltdzcvdGdG?=
 =?utf-8?B?N1dWdkFhTXIzM3dkNmIvRVVtWVVnMDM5VlRKODcxekMxWWdoZjBBa1NvdFQ3?=
 =?utf-8?B?MUZuTXljMXl5WlVKaTBWWldDMHZvdElEVlg4b05Fa0hWMDlIWjV4SmFrT0Rl?=
 =?utf-8?B?aDdZYTdkWE5DUjVOUnFsNmp2SVRSeUtkTVc3Z2xZakZKenZsT1lDdVJuR2Vi?=
 =?utf-8?B?czk0V05jaTl2TXBQMVlTekh5Q1h2T0Z3RytXQWREekVpbWJyRlhISEF2M2Mv?=
 =?utf-8?B?V05XVjNNZGNFMy82NTRYL2hJYnJIVVNBeVY0K01SUjh3UkU5SlpXM0F5c0s2?=
 =?utf-8?B?R1dPSDJta1FCM3dFbHRtaXRCRkNWMU1CL1lVWjNsQ0g4YnBKUUlkcGRHVE93?=
 =?utf-8?B?VVpldnJPWUhnb0hybCsyWUZyS3FQWlZwazVKVmZ0UmpnemJWNjh1UDJmd2h6?=
 =?utf-8?B?dEI5ZXNJM3M1ZURQZDhNZDRRbDk5Vk16dWZtMVlBczJPNXVmTU9XeDNzeEdH?=
 =?utf-8?B?WWtJaU9OV054Uk9HTzRQeWlYckFxZUZpQjlnMm5Va09VdFZzU0dCMUVraTZY?=
 =?utf-8?B?VDNxTFJUWXBmNUppaU0zYTRVbDlQTDFHdmgwQUlXY1NwQ2dNVkdBTm5PS1Va?=
 =?utf-8?B?VGdPS2VoakZUTWYzZkRyaEdLL21jbzJNOW9SRTZhNHVtOWxnc0s3SU50YmJy?=
 =?utf-8?B?dTNpbmJJdVM5eDhKZEZFOGU0aXdzTk1NLzhqa2d3QmhualUxODZHNFR4aHNo?=
 =?utf-8?B?YzhrbzU3ZUl1QVIyNnhVNEljaFRLcnE0dlZYc2luTkpXcEdkVTFYRktMbUx0?=
 =?utf-8?B?QUlTSDluYmVJV3VWczFOc3JlZlR1MVZ2a0RmMTVCWVVJSThIYXFMbHBVMVBJ?=
 =?utf-8?B?T1MraWVPTVlHSnV3d3NqaEE2ZUduV0JSL1krUTJPUG5SSS9rcUZXVE1GTWtQ?=
 =?utf-8?B?OHFCdHBNSHIvbnFpVysrdURHVWhYRktBR2pxRHMvQUFPV3dHbXJaU2R4SC9F?=
 =?utf-8?B?a3lkU3BFbmxSekhzWXM5S01hUjg3RE5LMTgyMnVxRS9pdkJVUVpuL1ZuYmdC?=
 =?utf-8?B?Q29JNlc4a2ZML1BKQnRMaDdUNk1obVFMQk0yNXFnY2k2OTgrNjB6Ty9obkRi?=
 =?utf-8?B?YXhKUUFPTVhUQUI0SmhpejRFcEZiWjkxTkhYV0l1Q09NcHhybGRoWEV4aHVr?=
 =?utf-8?B?dFJXRjE3SVZ5WUNYb05odWp0NXN0MUtvOTRXMUJsRGV6R09vRjhzajJmdU41?=
 =?utf-8?B?UlZWeDdCZUlVVXR6S3NmZEZ4RFR6Z2wxWHRZdHkwaTBJNzZBeXFSNUxoTzRs?=
 =?utf-8?B?Ri8vZ0F6NU5BZDJUaUU4SC90QWIxMlRSM2Uvc0d5aVE2MEpOZlRjcUdLcXlR?=
 =?utf-8?B?SlMvN3grQWxmM1NmblRKMW1UcVBMQ1prT24vS05VUDZxZU51YSsvUnVRZlZ6?=
 =?utf-8?B?UmlHdkR2MlNCMExpVTVXMTQxbERjbDFKR04yU1MzZS82REZZOVhSVlhIVjJt?=
 =?utf-8?Q?FZbNvYCXSSQQ8D8ErCtkqZUGP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7674b3-017d-4a91-b9ce-08dce1f7643e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 08:59:43.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFEJoUJHj2eyqHSiqiV+bWdBLATwoOYGrcERMdRZQglCVBob33xfEt0PACZhJlLJujMVZQOrKu+1DG1rZOOysA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6937

Hi Sean,

On 9/30/2024 11:04 PM, Sean Christopherson wrote:
> On Mon, Sep 30, 2024, Suravee Suthikulpanit wrote:
>> On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
>> the guest is running for both secure and non-secure guest. This causes
>> any attempts to modify the RMP entries for the backing page to result in
>> FAIL_INUSE response. This is to ensure that the AVIC backing page is not
>> maliciously assigned to an SNP guest while the unencrypted guest is active.
>>
>> Currently, an attempt to run AVIC guest would result in the following error:
>>
>>      BUG: unable to handle page fault for address: ff3a442e549cc270
>>      #PF: supervisor write access in kernel mode
>>      #PF: error_code(0x80000003) - RMP violation
>>      PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
>>      SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
>>      ...
> This should be "fixed" by commit 75253db41a46 ("KVM: SEV: Make AVIC backing, VMSA
> and VMCB memory allocation SNP safe"), no?

The commit 75253db41a46 fixes another issue related to 2MB-aligned 
in-use page, where the CPU incorrectly treats the whole 2MB region as 
in-use and  signal an RMP violation #PF.

This enhancement is mainly to allow hypervisor to write to the AVIC 
backing page of non-secure guest on SNP-enabled system.

Note: This change might need to be ported to stable 6.9, 6.10, and 6.11 
tree as well.

Thanks,
Suravee


