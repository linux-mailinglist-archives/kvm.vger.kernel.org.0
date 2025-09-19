Return-Path: <kvm+bounces-58190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4B2B8B330
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC9B7585756
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232F0244679;
	Fri, 19 Sep 2025 20:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1fO+BBwo"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011045.outbound.protection.outlook.com [52.101.57.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF591DEFE8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758314138; cv=fail; b=IM3T2AGfjUXZmxy6/SSxn+pEw+D7Jl7CO0pFW0x3Wih/PMqhNtwrIpnqlqIyq/0K5kH/S5Xu+JBgC/r7WWJxjkR07WJryjrpqIKCZCd+eLFnVz6jc/dPwt8xjn1msWFoR7GfPhOHAUXJnJigdglpzIjhMt3+vmFQ38qQRUHuiBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758314138; c=relaxed/simple;
	bh=tACC40ReDiDX1EKiWT411f1SXF0mRxaE7lOa5oiGDVk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZXLyeqRi8xj3i8yUbJYVdJssSL6IMa1ekai/GG9N6yNL8zZkox+7cnZqgpc3FR0IWkmZRSq198mGnmy1Ss/nEE+4wGFKV9f/GPsr3TeIqDBbEvUO8qge3HtKPcnj1Tu4Dc+hjxZRD9LfRg7TWaXM5Wwl1aJrJweFPMUohaAGznM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1fO+BBwo; arc=fail smtp.client-ip=52.101.57.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AgPY39TKYQOf8Vh5PJdKBt+NoJj88aNz0j8NkYuG8DQdVYde7qkzbiG1fOvDMHBSbNkOWHDVrS4XlcsMcoIBl/l2rxYtrEuX+mR1lkSHPhf1Uu+aLhFoNdEvMTz+CE3usSGWznpSaC1y1IpBTHxvbUscjDg0FJA0CQI1pImpS3ficwn/cX3h/4S1cbbHB45a/z2Jdh01DiNqXhEbHosEQ4chFOv77VVbCupoJXXY5WzQKm4hCfjT2JQLFTxGIkRjv+lsCZJXnS9UXHjP7XLgCQ6vTT+ToknG101EY28vgEZyvs6C3v4eMxbp+GxphwnmtDaaSMcTKMO9BW/RH/Qgow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuQS5gxt6mwKTG+GyJWvsYysD6Rhp+ipQzvTvSQwsj8=;
 b=dcIzRx626mfxXoiKszPEGN049WpGtFxDIRpcvjec0Oj4zhZ/NKgfDqtjKSgKLmd6h7I97F9e4V7uxPYamABqpFmLkEBR134PZqEGUdfthEniYaA1zedjmEZ8RTQP5f8FfdvWRv7sAxIazAaWF1UJtxyel2VouKPMaLkfr8+J9aMUYbHk47azCGXb1BAw3yBxWiEBE0d6Fx0ZhwaSdMkPxQFRz/ntoA7iTCypqyxSyojvh99JlyJrO7k0mmCoThDQrpyPJVy0in9mNlMXTJQJcv3nDn60TmvsnqklqZ9m0DiO8oiA3TrvCOt+hHFa66AyjXErLQTDgNU6kHqdzuYa/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuQS5gxt6mwKTG+GyJWvsYysD6Rhp+ipQzvTvSQwsj8=;
 b=1fO+BBwoyqRi4I/RheZMvW6MHvYR0wf1wD8T4b+s2NcP7pShs9VSN3OCOLTCjeEcqUS4BfnVMT8688RJ10fQ1VTkAG0lWkZOC3mH45jtTUp3v0c0sEvTl8CP2gj8UMtzZukl2QkClAr/mRzSsWR+ysC8HYw8x2E88jjFHR8QBT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7796.namprd12.prod.outlook.com (2603:10b6:510:275::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 20:35:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 20:35:33 +0000
Message-ID: <e72b23b3-45c4-4a77-9985-67472d3e83ff@amd.com>
Date: Fri, 19 Sep 2025 15:35:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] target/i386: SEV: Consolidate SEV feature validation
 to common init path
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <eba12d94afd504ff87d25b9426a4a4e74c3a0c70.1758189463.git.naveen@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <eba12d94afd504ff87d25b9426a4a4e74c3a0c70.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:8:57::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7796:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f046995-16fc-45d5-b6f8-08ddf7bc14f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2ZtcXNiYk1lY0VNcStGRkJ1dG1CcHU4NkRFclBWSThud0Q0L0w0cHNDRmdO?=
 =?utf-8?B?aS95c0FCOEFXcnhjMGdSVVNZT0gyMkZCWDJOOU5XTGV6RkV5bEI4SEZpQ3lX?=
 =?utf-8?B?N2pCN0dFTDBubmVRQkRhZktNZkpLY0VvR0xpWWxuTjBwdjZLQjI2bEEya0ln?=
 =?utf-8?B?UWVGdG0vaHNCQlBMZ09ROStYWXpMTWprdnlzS21hcTRYSmNnOTdQM3ZKc1JL?=
 =?utf-8?B?WHR2WE8zS2FhSzgyR3ZFSEErc25pOC9Ld2Z5NlRMajI0b0xHUHd1RlBFdVg0?=
 =?utf-8?B?b0kzU01oU3JqZHQ0aFFKNVJUYUNEYmE0bEpGT1REVHdWaGxyMGU5M2Z3dWdJ?=
 =?utf-8?B?a0gxWkkyZGZFelYxVGZOL29jUU9tNGJsdGh1MFdKdUtpREswa1c1TE9LZDRr?=
 =?utf-8?B?UnN0dTRrTzM2UFo3RU9pNGFWQlpZbFNTMUNvMHAwYVRZUXFWUGhESWpheVhV?=
 =?utf-8?B?bHZGQWNaUnlPZlI1TVZHNnNSMUY5NFFhYXpLb1p6a1ZQM0hQTXpjZGl6T0o4?=
 =?utf-8?B?cDVNYlpycjZ6aitnN3RQdUJvOXo2UjcyU1ljSXZaclZJcFVKaHJCS1AvWitk?=
 =?utf-8?B?WDBWWGF4KzhtRU1tbWUxSElZVlJValB0YThmNlFwclhVWUhXOFkxbFhoZE5J?=
 =?utf-8?B?am04YnZlWitTc0JLQjh4UXlxKzZXYzdsdEpqVEpKL2Y1bUdVTUlkM3gvT04y?=
 =?utf-8?B?UEIyaUNXd0FtdlhKTVVhVnB0TXI2ME5PSS9wclovUzhKZDZ6Z01pRWl5dkE0?=
 =?utf-8?B?aytMYzJVbm90TElNU002dHMrbnV5RUxuSTcxZ2xwbzE2RVVpVGFjOGVVdlhS?=
 =?utf-8?B?N2VsbTY3QUVnM2VyKzNpQ1JGajF2eDBseDJFV0lCRnhRVzJISkZkRTJNMWw5?=
 =?utf-8?B?ZEo0VU5GMVlLVnM1enI2WUJuQ2Jnc0E2QnM4STlzMWhpcWJ3ZTRuUUtPaHl3?=
 =?utf-8?B?U1hPZjNmU1ppY1VYV3VMdGw1SGxrL1RXT3dTVyt3SmkyaWxBRVB5bjRvVTAy?=
 =?utf-8?B?UXVHbmVJR2oyYksyNFZZb1BSQzRjSVF5ODk3WGlKZ1dnN3ZkRk5LL1hDcUlv?=
 =?utf-8?B?MUpJNHluSVZ6am9KbkE2NlE3aDc0dlVjUFpaNUlVd1hHWFFHWWZ4a01SNG5y?=
 =?utf-8?B?NkVXMnN0a1EvTjhubXQ1RTFRUHhlQVN3RjE0WlFzK05xN0V6VzVNSVpxUCt3?=
 =?utf-8?B?djJYNWZxa2ZTM3JCb3JYSkMwTHZmVzhhS2dzd2k5bXBsb3JaeGsrWGVuRnA2?=
 =?utf-8?B?eWlMd3FxSnE3RWVKMWlDaERCSlpDemkrMzJKdHAwNGx0QWpnTytnT3o1YWJr?=
 =?utf-8?B?Rlp6aVB2aUFhYjVoY095VVM0RkM3bTg2bUdlbWovKzc2N0c4UzJkdm53ajBV?=
 =?utf-8?B?YzEzZTlyYjVFUGdIV256YTFjUGhpR25DdVlISzJxa0RCMmhwQ2VJcG1RT3FS?=
 =?utf-8?B?SDRMUUlTWlhXb2tpUnJidkgrYStMYko0d1BwTURNcEgvNVEwRnBxNTZuUXV4?=
 =?utf-8?B?ZEIxaW0ydXRsM0lIMjZYT3U0ZHdwZngzWTVBMUVTRkltZE5LaVhrTHVGNlVC?=
 =?utf-8?B?b1M0cEJWeGRDOVRNNkFOZmkzYXNiemVTL3VzOWFrcTdlTWxkMXJkWE9CZ1p2?=
 =?utf-8?B?YUdxR1I5UnE3UXJweGt2OUM5aDBNS013UXNud3BxQWFXdjNGSmZaNngveDZZ?=
 =?utf-8?B?alZXRU9PT0lXVEdyUmk3NTNKaFN6SEQ4VmZweG00ZmN6ZFRHbUx0WHV0WE5D?=
 =?utf-8?B?SGJHcTE1VExZQkxpQS9ud0E1aXAycmVhcW9zbWJiczVZZVNHeVZNU2o2ZzRP?=
 =?utf-8?B?TFcyWjlwc3o2eTljUlM3TExUZXBnaHgyclErMHhncnZsaEQvdGoySVZtbE93?=
 =?utf-8?B?ZHduSVdncUZzNERWRG53M3FzUDFLL09LUkVlelpTNzN5bE1BQm1wczVUMURC?=
 =?utf-8?Q?j3yMT70w7ps=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXFDamxPdmt6dWFKdThZUlhXc1BLVGgzWnNucTIxZVpXZU5UUjJsRXRZU3g5?=
 =?utf-8?B?YVE0ek9TNFc4ZVg0MWxVdlJOZ2JIUTNjU2JHbUx5d0E3UWN4bm9GMzZ6YUcx?=
 =?utf-8?B?NkZYUmVTUXRvdklDNjV2bFRYRlJLaThFYVF0RXlVb0FnWXhuZ0t2U3JhQ1Qw?=
 =?utf-8?B?WEZ0SWRiVkRqcGU1L0Z1RE9EZmNLQUpBRlV1Qi8yKzFEZEpvcXF1enB1dGxN?=
 =?utf-8?B?V0RPb2hOTHBSZFJkR2VYMGFnTDVudythNVNCQlZLVFJsQTZQSVVaeVMvK0ZK?=
 =?utf-8?B?MDEzeVBjUFE0WkxyUG51aHE3dHR5dmhSUUgwN08yamd5aTg2aVFBbFdzaVhl?=
 =?utf-8?B?Ti9sV2xyZHRjTzFwSXF3UzYrY3hJeVVxTjVGdlYwTEYrbXk1ZU15dWc2em5z?=
 =?utf-8?B?blNjZUdiWThyV2wyZEZTYmVScnNzaUxYOVBPNG1ieGxjRVBrTkJ2VjBiWG4v?=
 =?utf-8?B?OFBuOXBoZTN6MXNHQURYaWdXZk9UZHFXSGVhb2Q0WG1EWHRySHROekYzQ3NS?=
 =?utf-8?B?d3ZYamFwRHdEUVdRdUJXMFBCUFhoV2s4YXk0L1QyelplNWgzZ1Q4VVdCb2dR?=
 =?utf-8?B?K1ZSeHlaU0NzOU1sQmdOYUJyQ0RLbnhzR0c3UE9obCtYVXpKK01aYlJvUWNy?=
 =?utf-8?B?b3hNWDJRL2tsUnJJU3k1T1hZT0JRWU5vTmtpNzVKa3QyVUt0ekVqSGhRS2hq?=
 =?utf-8?B?YmhwanpYdU85R2c3bTl0UnF5S0lUMDIxdjVrcEoxWkc3bW5ycUFjUE44M040?=
 =?utf-8?B?VXNoZ2thazR4SG1EY21tSTUzQTl0b1dVNkFKZVp2emNJZCtxbVA1LzBHMS95?=
 =?utf-8?B?NGdVTEVqZTNGdUg1QlpRV3BwbnZKOURZS3JOQ2R2ZnR3ZUlFTkloMHN3N2RN?=
 =?utf-8?B?V3J3SVpLVSt2LzNuRTFVek5QYW9QRXlNKytyN3JrNDFReVJuaTY2MTk3eEtM?=
 =?utf-8?B?SlZPUmhTVzdjWk80a3YrYkJuZk02aFFYZ2d5SXluVXUrWlpDd21TOXFSS1Fm?=
 =?utf-8?B?NXo1SnZMWE5UaHoyNzdSVEtzZzY4UDROS0k4MmtPdXpSVytTajNkWVFxbXpm?=
 =?utf-8?B?RCtEcmJMWk5SUTI5VFQ3K2xpOXZQT21qSmFIeUZKamVtZ0laaEtRb054b3R1?=
 =?utf-8?B?TE12WTEvY2xkQXFORmdrMDRRZjZna3JONml1TUsrZjVXUnlHbEdXRFk5cDR0?=
 =?utf-8?B?dVF4MThsT3ZpSmNLZWRRdUtEcENIdUpOQkx1Z0RlVlRoTGZRYUV6M01SRWNi?=
 =?utf-8?B?NE5DOWl1NmtwT2NIR1cyVUFtSWdYcXVmdnU1NDF5cFM4QmF3K3lTcEtXcmJl?=
 =?utf-8?B?ZHRsMXd2OUtiTnVSR1VSRmVJUmhNSVEvOXltWlZIUXJJVnJSUkwzQkpscUMr?=
 =?utf-8?B?dkphWW1qTVVXY1BFemRsSGdKWmFHaCtDRTVwTjRIb0VIb3I4SUZBU29WMjlW?=
 =?utf-8?B?TnNUR1dkNmNoaXA4elZnQ0xtZkZ0ZHRzWTA0eDhZUW9aZDhueDdmSm5OYjRr?=
 =?utf-8?B?eDhBWUlLRkxxSkdac3NPZm52N3ppRTBhOGZEaTlDY2g4VVlHK2pmUmRMaVVH?=
 =?utf-8?B?eDlOZldoVXRCelVGekZhK3QxTGZqZTAzU2lNL3EyNVd6WFRYYXllendETmFC?=
 =?utf-8?B?ejlhV2UxMU5LdWtuamVaU0psWkxtNkZiSnVONjJ3RDdYSTJId2NFenh3ek90?=
 =?utf-8?B?aWllVG5GMUtudWs5SUtXR3FKeDR2Vlh0NzdvVXFpYjYxSEJGSTc3ZEg0Wmhs?=
 =?utf-8?B?UXFkQkFzSGFzdldaNnl3Y09UN3JmR1pVVUJhQURGSHpHUkdUYTFyM2EvME13?=
 =?utf-8?B?czQ4aUlHZWtoeUx4UkIyNGVNUUdGRlJWY0RyZWNGSTFZT3UyZWRJSlJCYmt3?=
 =?utf-8?B?UVYxQ1MwZHplWlJKVkVGOUE1TllSNzZGaHdKVnVxVmdaR0IrKzRFWmlCK29C?=
 =?utf-8?B?WWNVSkR1TXRjVWVidWtLVmxRT2w0cTM2Qzk1SjFsMkRUZGZFaDAzMmlBc0J4?=
 =?utf-8?B?cU5SbEwxRENKVHJ1ZDhZbTROd3lRNGlMNzhIVTRZU05zaUxQZ0E4WGxhMkFB?=
 =?utf-8?B?dEdTbDQxQ0krblc4c3RQSWVxWUh5b3lZY2tZWmFVNFJXd2JNRDdNa0lvZHMx?=
 =?utf-8?Q?FB5fvBco7bP+Bzf2CvrM+WaBg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f046995-16fc-45d5-b6f8-08ddf7bc14f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:35:33.5586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PzGAOnQDhdzeM8776LXouXXJmOr+1Cf3ZFKCp1w9ebIeFvQV8s0TT9UCx7HpqstuJkIHsCQhbg61tWMaNm3EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7796

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Currently, check_sev_features() is called in multiple places when
> processing IGVM files: both when processing the initial VMSA SEV
> features from IGVM, as well as when validating the full contents of the
> VMSA. Move this to a single point in sev_common_kvm_init() to simplify
> the flow, as well as to re-use this function when VMSA SEV features are
> being set without using IGVM files.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c4011a6f2ef7..7c4cd1146b9a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -595,9 +595,6 @@ static int check_vmsa_supported(SevCommonState *sev_common, hwaddr gpa,
>      vmsa_check.x87_fcw = 0;
>      vmsa_check.mxcsr = 0;
>  
> -    if (check_sev_features(sev_common, vmsa_check.sev_features, errp) < 0) {
> -        return -1;
> -    }
>      vmsa_check.sev_features = 0;
>  
>      if (!buffer_is_zero(&vmsa_check, sizeof(vmsa_check))) {
> @@ -1913,6 +1910,10 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>              }
>          }
>  
> +        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
> +            return -1;
> +        }
> +
>          /*
>           * KVM maintains a bitmask of allowed sev_features. This does not
>           * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> @@ -2532,9 +2533,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
>                             __func__);
>                  return -1;
>              }
> -            if (check_sev_features(sev_common, sa->sev_features, errp) < 0) {
> -                return -1;
> -            }
>              sev_common->sev_features = sa->sev_features;
>          }
>          return 0;


