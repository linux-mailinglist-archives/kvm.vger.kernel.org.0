Return-Path: <kvm+bounces-28363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1592C997C75
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 07:33:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C21C1283B97
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 05:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1238319F110;
	Thu, 10 Oct 2024 05:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xt9X5bZG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B186619ABDC;
	Thu, 10 Oct 2024 05:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728538405; cv=fail; b=FMRr9DbnhqbDsIGuUASoI0p+NyXufccSHakMeY2jm1jFsh63igTxFuLyDOX4C+FbziUril6F6IHUkyTEjUyZ92UbrNxhiULAVo+Ti3xjLx/IA7E7wAK1ivxyg6j65AWtba0aNthtVUuzaMpmYC8cS1Z38zACOlujEWuUqvRJRlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728538405; c=relaxed/simple;
	bh=iSYzi1s/KfRBz+wB79cDVahQtez/GxUYzyBv+zwEVnI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V1JE+mi7bnTorEo6hYmqQ5DtKELa1x0LwywpO/q1wlq8dkJJAtVaF0hFV9j5WhRBCC0WobMlaBRu6wRiOtawSf9qq0YiXyahAvh1zGYbw/5hHSqxcF+4SLPdQq/hEz5rs+aG8ocUYfh723s+GRIxzLnhXB7XxGcB0SbMZcMSsAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xt9X5bZG; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCu1oZxRStdcknOcCd4bOt2qfRvJVGhKIkyVMc2qiCfWVNZ1a845WOtChheZe0RlUyUkKvs2Ed58nC8XPz5CBHbIaUSm1Aef8j/RZOQX1Q025yOP8II/wSM5doqFOeH96RLHWqlhvWskXZg2dZm3kZwt0mHExbaeTP4pW4YcKVvJ/6j23NwB51rpqp5U1gT4QRxwf9YvJ6ToLiwiYLvGSMcV2bPbgMFeL7vitBiC9nj/LUdh/eK1l3ucKoxbJ0DopfEjXgchgB2/IW476X8NWqjlIGjGCoIbFwfqB/hvP5dWgTCi9cuOeQIm/bvbc1XcUpjsLur+zUKeOnWQ9DpTGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QagAtTfW3NxdD3jbcnvvJqu/tz9IUQ8Lb5lTp8SvEg4=;
 b=hjAL0k3WaozZlsoJJ4DF++My6547wVG2JQrgh2yJjsNlAiZFy3gozK1vCVXwqvLpcwF7phg13IAFzAE/NC9X/YqnPYpK/2EABhenR/qToA8USk91fvgQL/4DsaRd46gVI0XdVsV+PYRnDHgw7e3D3vRrRAJFai5tieuXV4QzcCducI/Y78uppJqTBKoLqM2qPIIYqumgUkCU4avgpEWnOuTK4cXzK4Z21gUaQY5SrypYcOX9JHh6HHavnVnX+i52H/XaxtSjd9Io37/ect1qOZ1+ExfyTX0kweHzw1DeWoykgCc1hD1WSxnNx5bF4/vP0FPeiYs5qzaPFyCGvUAcqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QagAtTfW3NxdD3jbcnvvJqu/tz9IUQ8Lb5lTp8SvEg4=;
 b=xt9X5bZGBrQgFIvW+jxkiv+Ar93GHFTJYNdt08vIRuyFWCFnG2qkDqU6cE1GmN6f8sQf/veEyGDwLIgIxoNxRbEJhhGjmmO3Ue268nQE3yyjYgRL6Mv3b1ecBrBzgkdOXOOTL/wzjLm7oAd9TSF7upYQTqG1AL7wf2us6OxIT4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) by
 MW4PR12MB7119.namprd12.prod.outlook.com (2603:10b6:303:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Thu, 10 Oct
 2024 05:33:20 +0000
Received: from DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28]) by DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28%7]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 05:33:19 +0000
Message-ID: <57f44e0b-8f01-6449-88fd-569de1a99f04@amd.com>
Date: Thu, 10 Oct 2024 07:33:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5/6] KVM: Don't BUG() the kernel if xa_insert() fails with
 -EBUSY
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20241009150455.1057573-1-seanjc@google.com>
 <20241009150455.1057573-6-seanjc@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20241009150455.1057573-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To CH3PR12MB8186.namprd12.prod.outlook.com
 (2603:10b6:610:129::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8200:EE_|MW4PR12MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: c00140db-0c54-4b74-c8f3-08dce8ed0c8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGlxdWtRQ3NZQ1ZRdzUvS1VudWI5Z0UwYmxJcWliWkdDbk1yYjFCTFVCMDRv?=
 =?utf-8?B?d2MzWFhMSy9ocWVUYWtHOFJmczZMdFhlekZQbDlSakRlNkM2SDNIeHQvc1BM?=
 =?utf-8?B?MFJhTlhNUEJHTy9ibTdWM3F1Znc4YllQQjJTViswL3JVWTZKaXlQRkxPTVV3?=
 =?utf-8?B?UFlaN0FoWGNRd09TcUdxc0cvcFJwWDVsSTd5bFIyNmI2Q2NLNkg2Yi9kNEZv?=
 =?utf-8?B?ZzZ6eHBxNXZYaHpzcTlkL3I2M2dVR250VU5idEpQT2pzWCtQS0Ixek9PM2RE?=
 =?utf-8?B?U0lHL1BoL1NUQ0NiNjlKY3dXQ0ZEUlFENzZkWWd4ZWFObFJ4QnF2TW5mdC9H?=
 =?utf-8?B?cHlNVEJVdk53bHoweEpHdWc3SzY3ZU1pemkxUUVpMlhFbkNrQzNBOUpTSCt0?=
 =?utf-8?B?WWJ5WURmRnpOTnNFME4zdCtLOUpsMEhpalg3ZFZrYm1KYXU3RUZ1RWdVVzhY?=
 =?utf-8?B?VE4zcjM5VGRobEF3SndsRWxGMHNTbzNpdFFOa1hBMkRHUFU3Z0dmcm1sd0Yy?=
 =?utf-8?B?SzVYZ0lwL2J3YndSL1RzcG9IOFJDNWRJc0JtMjRWakkwQzY4Sk4yNy9KUkdX?=
 =?utf-8?B?NUVMWVpOWWp4MU5PajErS0FIR2JtVVl4OTJDVW5IQVBIV01qU1laZHo3Wndn?=
 =?utf-8?B?WWwwNkNHQ2Rmd3Y0SHlIUEk3djJFT3JoaEMvSE1OTmFVbEQ5M2FOZis3Qktv?=
 =?utf-8?B?ZU9ac1prV0ZQN0ZWRzE1QzZ6U3A2SXB0RWRWYWZaa0xkK29BTVlKeUlyM2hL?=
 =?utf-8?B?dGc0VHV1Q1lYYXUxSHprdmdTb2FsQTBJQnFkajJYcS8zbDBPNEJSaUdNNmJv?=
 =?utf-8?B?ZEZUS2FTMlZQOHJ3Ynp3MkVEaldkYXRSaU5rVzhhVTRkZDNFa1RYU3JtTFFo?=
 =?utf-8?B?RDhkWC9jU2RwMWliSFlBVzB4L1JhRE94TXRvYytLdU9BL01TdG9ucUgwcS9D?=
 =?utf-8?B?V3R6U25oM1M1T1E3SUhkTlM1Wjk5MGdYZGhxNXh6R1o0SitacjlHa3JDWFNV?=
 =?utf-8?B?TmZ5MXlWWmplT3k5NWtmYWRpczRqYU1Zbkt0OWRqbXhudXRNRW10T24ra1o5?=
 =?utf-8?B?allKRm9MNmh3RHhlWFp2NjhkdW1ocUorakxtTGZmczNHYldNZGxWWG9WMXV6?=
 =?utf-8?B?bFAveHFUUCttUTNUY1NndlQxNFdUU0NpMzZZR3JWNGltVFV2MGM0bjVJa1o5?=
 =?utf-8?B?cTFlaEdCMGUvZTVSdnp0UUpzc2dCT3M5cEpvVGt2QkxhT212bDZhaTNOZE5l?=
 =?utf-8?B?WkNzcTZYTGVQU0ZSb0FxQm83dHZ4Z25RRm43TXJuWjRWVnFURk1BZ3U4UUZI?=
 =?utf-8?B?akVUWjhtNm9wTnh1Q3ZFTWI0MVlmdSt1QU8ySGpqVkxYVzZZc1BIZStNZFpy?=
 =?utf-8?B?U0hCMmdnd3V5a3pTRkxkaTRzbXlST3VwNWZ3NGVIN3JCQzVSNk5oODRQK2Fx?=
 =?utf-8?B?Njl4WGlGby82d0xGdHhyYVZwbS9ZOFFPNTZLUWI0K1BiL1pvVWlOdzNra1dw?=
 =?utf-8?B?QWpFL2IyT09TejIxbW40UU9TVnViYzRXbmMwTTgzdnRTOFlyd2FDMnc5bEtk?=
 =?utf-8?B?VHpSalZFQmRDVGcrK21MblhJN002OVZzN0VvbkpJc05ReGVQVzQ2NitCa3h0?=
 =?utf-8?B?ZWU0Rm4xN2lVaEl2dDMrTXh5SlBKUERRSlRaR2FVaGs2QTRnZW5oNWFkdU9L?=
 =?utf-8?B?eTZWcWFSWGRrbmZHbGhPMmMxaUw4OTRkZDFxUW1FT1hBa1lCVWxBRzJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8200.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzV1TnhCVXhXb1ZyalRoWmJVbkoxVVlkZmNOZEpIUFlQUVA3bk1SMXFvL2JQ?=
 =?utf-8?B?Mi9rdUFNTWpiOXhsdjFFVkw1K1BaSGJYL3JWRCsrbHYwOHhwemFQMlV6TmJC?=
 =?utf-8?B?YUhENUNlRi9BajU3RHh3ZGU0QjRudzF6ZGpYZjArMEFoMXlqenlieFZmalFv?=
 =?utf-8?B?bTJrZ1JNUjQwMFRiSDEvR0V4QWs5WmRsbkU4R3dPVjZRK2VyUTVzMXY0NmpR?=
 =?utf-8?B?Y3lnNlVWMGNOUEpsdnlZZU1TOFl1aHBNemhVOGNmTTc4bFNjS1Y4bmRITkc3?=
 =?utf-8?B?TXpIbk9tVUJCRWh5QVBPL0NmQ2VvN2tVQWNoY1VjdFlwMlY4dzlvSGZMYWhQ?=
 =?utf-8?B?YjBGT2ZtamFSOHpCSE1EdXBtNm9YcEcxeXVNK05nVUZKdWhxcU80YmFwT2pK?=
 =?utf-8?B?WHBRWTR3SWJ5UklxekQ4ZVNkNnlQNUZMZGs5M2pzYWNpbkxLYjlJR2dsR0Jw?=
 =?utf-8?B?WHRraXl2S0FqTmNyZGQwTW8veUZobWtVYXNyYVJEMHczdlB3a1EvV2V0OGU1?=
 =?utf-8?B?U2p2WmlMTkhFL0NSQ2EyS2xYV3RObXA4ZFhLSE1vTTBTQnlKazYvbXgwNFJU?=
 =?utf-8?B?OXBZdWoxa01SNjROVnoxZHMzbnBpVlVySWIxUHQ2aTRKRldBNXJGNE1wYk1O?=
 =?utf-8?B?NnhLejFFbkNsWjE4clViL2tnTmYrdzhJOGRZZVY0RkFPRjlHV0YwSCtXand3?=
 =?utf-8?B?Y2dydENBZzZ0SlN2U1FsVE9MZGZqUS8xRlk2MDhZdkNPRWZqM1A4WHdiZkdn?=
 =?utf-8?B?SGtGSVNtM2V3UnZZMml5Y2lWL2ZMbWlhWG5hQWx5RDRGWHUzZHZQalZDM3ZW?=
 =?utf-8?B?eDhFUDIvL3B4N3M1RUdZdnhycjJJREpvU0E1WTJ6WHNoS3p1Q2ljT24wWXV1?=
 =?utf-8?B?dzdncVpEUHI0RVpHTUlEdmViUTA3TE9wUlprdytwdzU0bkcwTE94OXQ2ZTlt?=
 =?utf-8?B?MHJpR3llcVJzeWIvUjEvak9wc1hlR1B4T1c2ZWgwbmxrUHBWVEJoS3pwclNp?=
 =?utf-8?B?OWxuRWNTZjYvZUZSaDU3cnRmeHM3ZmdpbUdhaUpMS2Y2ZGp4Si93WnRqKzRD?=
 =?utf-8?B?NHJBQTNadjdQN21XNlZnclJqSHFmNFpFUWhSWWR6Ujh4MkV2bVg4WTFxV3da?=
 =?utf-8?B?Y2JHWnVadWUxVU9UUjNaUXpIVDRtdi9FYzNGT0hmMGV5b2ttWWdYNngwVGVP?=
 =?utf-8?B?NVhDa2VYUFEycCtpeVZhcUhPOFpVYVJlSWpSbEl5d2JidmVrSlQrdmkwN1o5?=
 =?utf-8?B?LzAzZ0hhSEVXSThRQzdxY2xxVEhMd05QSWVBdWRTaTBRbEZVb0wrWDUzeFdC?=
 =?utf-8?B?ZXVhdUs3aHVVZm1wLytncHkyNng3Yy84WlI0aDJSOVZ5ZTFSdWxhalpRc0p5?=
 =?utf-8?B?R1hBc21ENmVRd29GeXo4dkFLNGorT1ZZcHpVRDBKZXFDVjV2OFQ4c1hHQTda?=
 =?utf-8?B?K01CTDY4U290TUpkMS9hUGk2RUZ3YjRXRmZGdlZmWnJsQThwNGE2Q3pKMFdj?=
 =?utf-8?B?Yy9wRFNrOTBpQklvaVZ4cFQrTWkrUXBVV3YzYXh1bGl2blFiY2tMTVlxYlNn?=
 =?utf-8?B?amJRdXkrMUlaTEhQTkFmbVRUb2VuME9rY1M0NllmREFzZGxQZnZkUkVjRE9Z?=
 =?utf-8?B?cGhrQ3hnMW9zMWdQRG04eTQ4TmlPcXJHZTAydXlRU3JPTUcyRGNRWkMzMFg4?=
 =?utf-8?B?REhlTEFqek9BUXFZRjdTZURsQVc0QkwvaEhIbzVBdlNxUkJSelZxcEQveXZx?=
 =?utf-8?B?MVprcXY0RkF1K1ZvQyt3QkxSUlYyRm1ydWtBZWQvLzg3cVNoNmUrcXBQb0Fw?=
 =?utf-8?B?QzdCbnk5YzBOb1ZZTmdmMWhXaFlMdHhDUVRSZ3o1dG8yK04rOUljNzVndStl?=
 =?utf-8?B?bTR3UENGTmtiMnlkR3dHRHNNd3ZkaW5ZQThyWTVSNEpYUnVUcFJBT05oK3lP?=
 =?utf-8?B?SGphVkFqWWhtcjQyaFFEaDBoUm8vcEJMbEZFZTloRTBJK1JMWjRyWFRQMzlv?=
 =?utf-8?B?bCt2MDFBWjJRdGJ6UEhlQWI0Tm1HMmtoVmFScDdHS1dpMW52eVNMa3U1Y3dt?=
 =?utf-8?B?LzB1RGFSVGJPRlFxMjM4Z2Z2NlFFaVBOZUFKaHpyVzZ6dWh2RURGblEyVk1M?=
 =?utf-8?Q?5Zq58e125URrvFcV75k9LkUA3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c00140db-0c54-4b74-c8f3-08dce8ed0c8b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8186.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 05:33:19.8782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQCdC2Dozy+grDDwS/Bro8RlKKfJtdJvIhgu+oFH5nV6AZTSWYHuTUhQe0HP3HVU3RI5GoEVy1G54nh2ywlWvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7119


> WARN once instead of triggering a BUG if xa_insert() fails because it
> encountered an existing entry.  While KVM guarantees there should be no
> existing entry, there's no reason to BUG the kernel, as KVM needs to
> gracefully handle failure anyways.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f081839521ef..ae216256ee9d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4284,7 +4284,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>   
>   	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
>   	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
> -	BUG_ON(r == -EBUSY);
> +	WARN_ON_ONCE(r == -EBUSY);
>   	if (r)
>   		goto unlock_vcpu_destroy;
>   


