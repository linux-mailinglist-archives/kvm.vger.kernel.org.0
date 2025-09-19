Return-Path: <kvm+bounces-58195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD06B8B453
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8088A012E7
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A474F28689B;
	Fri, 19 Sep 2025 21:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jNgiDz03"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC421D54D8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315917; cv=fail; b=qQyVDz8lY94MRPoaA5vSwCZ3+H4H8GOkIA90rpzQhl8BtB1Bc+mAhyUdjaLaJEzf6pCB+LG+hY9GhTdxqWxS/bbHgaVuzpIcihqouxHs9G1CJlXCYbqDw2C76W6SdJoffwg5WWvX9PTlal1KM6EHHJJf9KRiyGjT48PGnIkNFvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315917; c=relaxed/simple;
	bh=9fV6yQYKd12xUHPCgUTEjLNzl/xlbHWml4pX0RBoIEk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=psHt0rkzz1NHuLLgn6C696ZPnkmqCmb7bp/ofMMFbMAgDkZQJZf4pO1i2fyqIQ64L1Eynz8zRamlhIcaCGTR1oQg/UImYJZ8Y7kFJLbphW2FCiBfilxghZ7G+RocmKJAMZaYzP5bo8T/81hNA9a9QeDxuu2385WMih0Vhn4ZwfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jNgiDz03; arc=fail smtp.client-ip=52.101.53.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XLUD3OpfQZlnWcOEJbyuN2Kj3RLc5AiDOClTD2iggAp3alVZY8jTkCDw9MH94O/zA/m21FWZtEiehw0qnkkhQ0+LPNzb7vLFpQE51iWCipXTbxSfBaRgZE+3romGmJCVFJfzWqHR5+MlNCG+ZFF/68cAbUdY2GEmk3ECzMcn92mApJG/qHFyGSnbch8w6k+Om/m1SnrbosYo5qM63SK/cqEbR4LZW+XsyfPjBGPlx9qVr/h/iLFYHBcJQob62GQeYUTSTZt2Y9ECl9UbBFqJaHYG91eqcBxrb2OcjHs4qri6nY/fv/S8UV1iiv4eyOX/Z/+yhe5mfsV2zxT5B2gm1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIqUoyG8hNzRfNruP409OeoVuVSjq2NIIYyU5jpCBQ0=;
 b=C3EybV/cSbfM6xlo3ldAxKLz4f7opmeog6rvf75Bb4qvOXvJd0LQfL2OXyvxr4lLgloF4E3rtt7+/NeJdUPhlenhBBYlpQfrXt1VZx5TRA3JJzasnHuO33sQQsY11N3JlWgCg4rbwjenbhBZKpqDfbwotw98qq3xW6nyl3Y3D6UeL0KwuRvTPL/en+Oz6aG0aTF0sb8Sgybtq0C98GcrPsEjl9NSvVTnRf8+4ulEiCKTqqZQiQTvxkrQrN9yoYy+ixyLD1lftDUXMSPKNzJiehBSMZFwFLSUh4yXDF3k42doZ2oeFyDXimNgD9A7sLP1mYP7xujtvhaJTXhRbl9ROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIqUoyG8hNzRfNruP409OeoVuVSjq2NIIYyU5jpCBQ0=;
 b=jNgiDz03ccX49NYntoQcbmspPUke3TZ8K08DtYIqSdUxsDxfjHEiaKbplab5hx8Px/CbfBSRYFFNBkJYWZGwIJ9bjaCAuJDf9ZjQYK2D4iIveicwhwlVuyspp4YyL2x4Y5XoxPaHmBWs4vSLfKl2zU+1DAhQ021cexQ+5+AghZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7174.namprd12.prod.outlook.com (2603:10b6:806:2b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Fri, 19 Sep
 2025 21:05:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 21:05:11 +0000
Message-ID: <a92131b0-9e60-45dd-ba57-00c44d4e83e6@amd.com>
Date: Fri, 19 Sep 2025 16:05:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] target/i386: SEV: Add support for enabling debug-swap
 SEV feature
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <e46cc5fd373ab0e280002c607927ff6640216f2b.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <e46cc5fd373ab0e280002c607927ff6640216f2b.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0157.namprd04.prod.outlook.com
 (2603:10b6:806:125::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: 310f51ec-afec-4cc7-906e-08ddf7c038c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVphVHgzYXlUTkJxaTJzZ3dESWh0S1U3OVpCa0d0c09LVTdUK3N0elp1UjNL?=
 =?utf-8?B?MXFSRmtvaEZNTkRJQ3QrYzZPUThtMU4yU2JVV2hZV3dvWGdhMERIVTZKdE15?=
 =?utf-8?B?cittU2hGbUVYL3dra2Z4cExlbWRPYTl1OUZhbGlxcSs3RjNXOHRsbVhlbkVS?=
 =?utf-8?B?WG1yM3lMeExvYS9NQnJ3ZzZjZmEvSG5XTWpkMGM4TnhWSkVYcGo3T1Q3RTRl?=
 =?utf-8?B?SWxyUmdDSHBIK1pKcHppMGtTTUNjUHVZMTNrSm11NzVjNm9vZFVURTdFWGRj?=
 =?utf-8?B?MCtBTkgxUG1YQ1hBU0liL2tycUxmVzEyV25ScU4zNmpITmFQWng3OCtZVTlT?=
 =?utf-8?B?enRMdjd3WGR3UEpkTmlJVno1akJ5eVI3QThWdnVhMW5KdDc5dkxZUDBYWG94?=
 =?utf-8?B?b09MYkJLZHRFS0Z2LzNlZ1lDaTFvVkNDNXVmMjFNc2tVWloxbmV4Z2pqamla?=
 =?utf-8?B?SzBscmtjM1JPS3ppcHIwTU0wKzV5dEt0NjdHZm9udEhISjRvRVNiUkhuYlhG?=
 =?utf-8?B?dzNLbjlTM1lDVGNuRThQc1lZcWgvZjl3TkpaV0lVQVkzTzdUVkNpTTc1SmhV?=
 =?utf-8?B?RElBdUErcG1pSHo4bDRlMTV3THZkNGYrOFBvT1NyMm05Zm1LZEdkVFBMRHpP?=
 =?utf-8?B?dFpBWldXU3R5YVk3RGRoUHRpR0FBbnl2RmZoVUhhMXdLNTZCN25wZnVqSm81?=
 =?utf-8?B?TFJNZFJHL0tYNXE1OVBYcWFKMEFZUVRheHUxNitkT1F6WWZuc3drM2tEbWMw?=
 =?utf-8?B?Qzl1MndyTkRrbzZUVVdJR1kvNWlMRFpLNGMrVkprOU1vbjBvZm5kemUwSERn?=
 =?utf-8?B?NTd2WWV1elZyMGhTZGJac1N5R3dnak5jT3U0S3Y2d1luT3dDR2QwMTcwUUJz?=
 =?utf-8?B?bGRwN3d2K3dMaGpDWCtWRTNBci81NnlxN1MyUzN5UWJ2M0FqNFJZaXdMdGE3?=
 =?utf-8?B?d0VTajZsUnFvdS90a2xKMERvNG4rVm1uOEEwTmorQTJDY0dPNFh5dk45dmRR?=
 =?utf-8?B?SlNONFc5bk9ySFc2V0llZE1tMXlJazZMYWNVYStDK3dZZ1plUHlXTlR4RlRw?=
 =?utf-8?B?Sy82L2liTmpkcGVseTBnVjB3ZDBhdlRxYjNWdHEycEFTblMySmJybmRIRER5?=
 =?utf-8?B?QnVsc09DVVh2UUUwdkxJWWdvT0JhS2RnR1ZMTm5NV3FkNStjVVJCWmhuYzdn?=
 =?utf-8?B?RVJpL1RtRW5kL1BVYUNaMnlGdVl0K204aUtnTXRWaDFTMkZxZFpMdU1SOVhw?=
 =?utf-8?B?TmNoeTljNSsrSmxsN0Y5bFVqQ0cwcXdWTEw5cG5GeUlkNEFiS2E5RnN3ZnlV?=
 =?utf-8?B?SFlkSkNWbGZ0MWpPTTVYcElxU0hoVFFZSU91ZGxRNjI2cnpuUk5yeE85SDgv?=
 =?utf-8?B?UHc0U3dtOXlQdWtoU09YQnlSQVVZWVhXVU9vQnF1cDc0N1JQTGpoSEdyMTR3?=
 =?utf-8?B?eXh1ZWZWNDVBK3ZyY1kvVEFpRTNNK3pvSnVqbW1rU2s4a3VPWFZ3eWdvVXkr?=
 =?utf-8?B?bVNOUlFRM0dlMnN3TE12TGpGMTZJRVE1dVVVc3dObG5wNWJ6bHBtVUE0RU85?=
 =?utf-8?B?aytUVG5WT3lSMzlCYlBjZnlWT3lqSnRyQ01lYjdRQmNqQXlRUHJ4b2Q3MFZK?=
 =?utf-8?B?L3E2ZjExc0k2U0hQNENVN1NiUTlDSnRHQjluZHFiemdSSmRvSERBMC9wL01y?=
 =?utf-8?B?OTYvYTd6THNlSVliWkZGMFk5dEtLanY0b2FrRDJZVGdHSTZMQ0RCVUxGTGV1?=
 =?utf-8?B?Vk5wbHN0dlRBSWRjcVZzdVIxL0hPenBYNEM1aG8vZ1FiTDRSZU1DcUlCdW1a?=
 =?utf-8?B?RHdYZmFUSGRrc1lmVDllbjJWckkvaFpVKzVQOTJDT2g4SWgwaHZHVVRhdUpv?=
 =?utf-8?B?N1RwUWpaYkZUcm5mSVRXR1dWT1g3QzI2QlVxenJXcndBUjhuMStwdkFvMlZS?=
 =?utf-8?Q?YGjpEQkJXtg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnhXTXkwd3lOaFloYU9kWTJJWk9XVVFpYnJwcFR5Y3Z3VEhyRGtBT2hQOWNJ?=
 =?utf-8?B?UUx5OWpmLzBGVjdUNVRmYkNXdWY5dHkrbHVYTE5UR2dBVk5jb3pUZ0tFa1pw?=
 =?utf-8?B?WXlLbWxPK2ZPVE4zZFFoMEJaOXAzbmZZaEdEYWVERUh0dzhzdUNXbTR2eDZY?=
 =?utf-8?B?ZHRLQkhZSVlHQjMvTVhNMFdONi9uamFMSmt6VWNsT0N5STBVZnkyWXNXdnpj?=
 =?utf-8?B?UmwwcFd3VjBMTlNpbHA1UUVuM1p5d0Z0b2NSbXRxUkVsMCttMDVCRDdWQVM5?=
 =?utf-8?B?N0xGMXhQRy8xZmdBaEViM0xieE5MMWJGRVU1RzBGQVcvbXNjQ0J1YVBDNEtZ?=
 =?utf-8?B?U3lWRDFkRlEyZmVGUm5GSE9ESGpiMStBM2lrS2VyL0xuMWI1eU9ZejFxdmdI?=
 =?utf-8?B?SjhvaW9UVG8ybzBkdktidW1xcG5MNEZkaHZBUlp5cG02c1dxVlh3WThKM1NJ?=
 =?utf-8?B?dC8yRGtnTXVPaU81OTZFZHphT1Q3WWg0akx0a2RSeldpRUhISTBnNEljVko2?=
 =?utf-8?B?MHV5N3Vpa1FXV2lOWnVRa05oaUpZZHNtNC8xWkRtZUlnaXZtd29TR1JGQVcw?=
 =?utf-8?B?Wnd4cTN2dTcwZ3VmVi9lMW0vQkFrVFFjNVR2bEVXZFNQdmhRN3hUWEFGa2pI?=
 =?utf-8?B?QTQ2NlZ6bkhyZ0VzeDFBVzZZOUd4bUMrRmI1aUJVSmVnbHM4WWlvNXVkZFZ4?=
 =?utf-8?B?U1J4WXV6bHR6a1pjL2xHU1VrRkYzNzlYZ3lDSDVTdDJWYXFwaFRSNnB6UGR3?=
 =?utf-8?B?K01ZS2w2S25HYjdWZ2JUUTZMTHFJa0Fzenc1Rk5URysxVkF1YVY2QUozcXhF?=
 =?utf-8?B?d0hqWDQ1WjBzM0JsSmFPTDJoQ01YeDc1UXllNG5WNlh6MnFDSXphOEZpZkVj?=
 =?utf-8?B?eTJQL05xUHhGMExVMXoxZUQ2ZFRZRjJGaWdpc1UvZjFNcHp0TDlyMFQxbjJl?=
 =?utf-8?B?RDZnWGZoVGVYd3g4eUFwM1libE9HNlZtVGc3STQ0YWVacG9SOTU4N1BxcUtJ?=
 =?utf-8?B?MTcxWTNza2x3a0lSYkNtUlZGYkxKSjhEV25iOFNpQzk2RVdBUzgrdFAzMC9L?=
 =?utf-8?B?WnRJRDhMT1EyaVBkcWtCaUJxdkR5SEMzbTZSOCtBYjN6K2tYRzM3OWl3dGxm?=
 =?utf-8?B?SWE4THJ2R3dWZDM5UWJHbkxabGpIRFZ2QnVkYTJnUGJQZFdTWnp5dkNrTFB2?=
 =?utf-8?B?YTRjaEpqSmpPczlEV3ZaeTZGZU9HTEZFeHQ3cFh6U0s1K21aVC9mQVF3ZkJC?=
 =?utf-8?B?VmZhSS92K1h6WllhbGlPVVl1dWlBWVE1WFc4cU9xUklyK3hFbFhuRFRReUFC?=
 =?utf-8?B?bGNkN1ZxSVZqaTBBV1hIT0haalJidUJUNmVMN0R4OGY4djFuZFRZRXpJeHBG?=
 =?utf-8?B?VkMvd2NSaysvV3FGa0huVkF5WFJFdmdHRzM5UXlRcjhrRUhxalBtM01jbjBM?=
 =?utf-8?B?Y2EwWHpSMXVTdTVuN3daYlBzcU8rQTQ1NlA0RFpqNmY3aHFCNld1OE8yUzdM?=
 =?utf-8?B?bE5oSWtCYmJtRjJQM0doNTU3RFFlL2gwbGtTd3VIeXhXODh1NC8zU1laWHlG?=
 =?utf-8?B?ejYvNnBzZVVvYXE0Y09Ia3V4UUtYMlNRdFdrRjV1aXV4Umg2OVlLZzh1azVh?=
 =?utf-8?B?d01kSzdnUjFRZnpsOE1Mek42dmlsNWhVUUJZTzR4c25Ja0NqMHpsSzdSLzNI?=
 =?utf-8?B?RXNQcGpVTW1QTU9UL1hPbTB0cDdCdjRWYXJtN1kwVjdWN0Nhajc2Q003ZnJL?=
 =?utf-8?B?VUNmU0RqN1pQTXBNZ25sL2ttWGg4OURDY0ZZZXZhMFBKNUl6TUFxVUNQR0c3?=
 =?utf-8?B?VlBRdkkrenVocll1ZWFDNjR3MlVqcnVNOEg1eUUrK2hRNk5rclVFbGtkaXI3?=
 =?utf-8?B?K0FFT1Q0eW9MZTVJYzNJREIwTnozUStKUmYweFlaTklBYjVqYTJXME11MEF2?=
 =?utf-8?B?NXk3cDUyRitYUnFxZUczaHJaQW9VamtndlVhaVR5NnQ4UDAySHNSUi90elhQ?=
 =?utf-8?B?TWh0MW9KbGswZWUySDNLK2s4eGdzYmF1R3hPbDhvUnNVZHZpYStCSk5Ca25p?=
 =?utf-8?B?YkMyaHdaNEltVUxJTGhHdjlycFdYTGpXbkZsYTFRbFVuWFJyOU0ycmFTWGln?=
 =?utf-8?Q?r6eJ2KaZrp/OfRm+uS3UZVsn3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310f51ec-afec-4cc7-906e-08ddf7c038c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 21:05:11.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkJ6REb++55Lmr439uDrIwanreBbwcrjBdfbyyUq+7d68+hi+0cyBj0BWuZSXowMMEY/OMzSIIk8ACn0OM3L/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7174

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> objects. Though the boolean property is available for plain SEV guests,
> check_sev_features() will reject setting this for plain SEV guests.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

The actual feature name in the APM is DebugVirtualization, but we have
debug_swap in KVM...  so I guess it's ok to use debug-swap.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.h |  1 +
>  target/i386/sev.c | 20 ++++++++++++++++++++
>  qapi/qom.json     |  6 +++++-
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 102546b112d6..8e09b2ce1976 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -45,6 +45,7 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
>  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
> +#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index f6e4333922ea..4f1b0bf6ccc8 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -319,6 +319,11 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
>      sev_common->state = new_state;
>  }
>  
> +static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
> +{
> +    return !!(sev_common->sev_features & feature);
> +}
> +
>  static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
>  {
>      if (set) {
> @@ -2741,6 +2746,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
>      return 0;
>  }
>  
> +static bool sev_common_get_debug_swap(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP);
> +}
> +
> +static void sev_common_set_debug_swap(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP, value);
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -2758,6 +2773,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
>                                     sev_common_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_bool(oc, "debug-swap",
> +                                   sev_common_get_debug_swap,
> +                                   sev_common_set_debug_swap);
> +    object_class_property_set_description(oc, "debug-swap",
> +            "enable virtualization of debug registers");
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 830cb2ffe781..df962d4a5215 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1010,13 +1010,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @debug-swap: enable virtualization of debug registers
> +#     (default: false) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*kernel-hashes': 'bool',
> +            '*debug-swap': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:


