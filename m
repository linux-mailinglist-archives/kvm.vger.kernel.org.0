Return-Path: <kvm+bounces-28465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24ADE998D7F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928651F22D84
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F7A194C8B;
	Thu, 10 Oct 2024 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vr/EP6i1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF6626AFC;
	Thu, 10 Oct 2024 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578013; cv=fail; b=JPvzSujeLyJnunAio/i6xACw1ovYnlTvJXrZTegRAkMePjj3NS46Vt/JeeF/I1RsZeSUoITrj0MUiInvar5sWXrSPlakRY60612XkikeUrHOxWtyGZNiGrj3jBYFKkmmULtGXSqIz+IwQyTGtJiWR+q5CQQGA2kbHk1y+AJxouw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578013; c=relaxed/simple;
	bh=ECvQd4p8VLwKKVtdMK/lP22dtNAFKHSbBOO87/r3vKE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oXazrcJoAVzXNiZEfeJ69ZYk+vZuvveSGJiBp/bMpAaJQmtFoaVsknErCrKJOSC4DT9rOeM3Mw8eAxs65DudJYqGTDHBBMnw2s7VDw1+GUDuZsg5qFmpYZVGQr4sU6KhQGs2nnjHZTLDuk9lQR6wbxJBPeve8L6GTwfYdMcSMBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vr/EP6i1; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnn2PUaMg114aRWVr1QlRDAli6apDWJmXmaq4mUDqI4tWhOGohnGQmhw5sTEnjliHd2Fx1PT+hMt1D4ZdqK11+Ys3LwDv4eBL1IpIP07MJmjBhxGz5IUtFWPKirW5BPRxWAh/2TojBj/3IUhIcRDbvQM5BgL/xmJ12UYAEdPKKyNj8C83yqSyOylGTOuK76wimSKbz8KvFmxKmRY1ZddReJB2570Khip2kEOEF4bQsnzJZhUHuXutFaIGQ+ZefBr5dF796Fv126XvlHsq2Nl3gec4N0BsMezuZhJS7VR5DqZc8siQA6v3Plekx7XdtFA1je1H2825aGB9HBEt2Yqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFnRw9Vwk+nNZzvIpQ+7i3xLLXoAqOaAm0Ut+7iLlTY=;
 b=fLQ+AWhuqHBnYoUGa8/X2M9/iJmwwIbN0rTb9F4uDVMJMgU1xUBUa1k5LnFEje8wrtkErftH3pQFzd7unAgeUBfKm8gFToIZzj5guiwP6dyK/zybmjvBnM5omf6IUXae0WiQANaQXcAp3iS+kIzZE3Bm5YFMgrYQ2pCshl9CGGYoztMdO08CJ1h+h69I1XuiYk6hrZXEMyFpDsG1DmWWzaHHQ8m5cTaltBJ5gJnn44KpKDieBDh6mAejRRKAKVmCRdA8sH05EH0E13Ks8TOl4O0ctBGHyKe1GLYzBV9CZekM23hMtFtEAP4xudmyXMYMkBz3kYEh/zApP2/FGfL8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFnRw9Vwk+nNZzvIpQ+7i3xLLXoAqOaAm0Ut+7iLlTY=;
 b=Vr/EP6i1b/IStS05UaZF6xBE/qWbSbImYSWrxTdLcZRU9eM68vhGOObrxGZ+4KjRO88m2/91aT0YcKARaVAZ07K32YNCyUj8sWfSW8lTDkCfgijmfctTI4Pq24orvER7KisAHtJ9vmSmWLfJW1eufv0VVw/zVKFjkgjJuyhDcPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SN7PR12MB8792.namprd12.prod.outlook.com (2603:10b6:806:341::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 16:33:29 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 16:33:29 +0000
Message-ID: <a653b3e3-a75b-cdd4-bf58-1bfc9691299c@amd.com>
Date: Thu, 10 Oct 2024 18:33:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/6] KVM: Explicitly verify target vCPU is online in
 kvm_get_vcpu()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20241009150455.1057573-1-seanjc@google.com>
 <20241009150455.1057573-2-seanjc@google.com>
 <cf2aabe2-7339-740a-6145-17e458302979@amd.com> <Zwf4rfOFBlnMtdLQ@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <Zwf4rfOFBlnMtdLQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::22) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SN7PR12MB8792:EE_
X-MS-Office365-Filtering-Correlation-Id: 239b707c-7fcc-48fc-7f59-08dce9494591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3VMeVBYV2JIVmlXb3pYUDZNai9BRkxERXFyYy9hSWZTUWpyeWo2Q2ZLdU5T?=
 =?utf-8?B?TVVyWEV5Zjg3V1JvSzJSVnpQNmJrWGh5bEp6SzVEbXlYSjU3MzNCam42SVd0?=
 =?utf-8?B?dmhwNE9Xdm10THo4VmdaZGFNVElySnhsQVIyTXhmQ29iRDhXcTJKL1RmcUVt?=
 =?utf-8?B?NzgrSGFtYmdKeFdZbEhpb21rTHdISkg0T2ZHRnR2VXUxRWJtMExPUGFlNTFr?=
 =?utf-8?B?VEw3KzVUQ1RNcnhmTUJSQitSTE9UeGlvWEN3SDJBSytWSGFrWnNQbk0ySG5J?=
 =?utf-8?B?TEVXM1hFeHJYUjBnekZYUG54bEliNFlENGQ0S2k2NzM4SXBwdUJic3BXK3lR?=
 =?utf-8?B?eUJnbEI0aE9rV08wM1NlU05pOTdodHhYZ0dHVEZsOSs5QVdqSkJ3UDdLM2lw?=
 =?utf-8?B?UDZXRThNU09ndlYzeW4xRW9jOFlXRDNQZjUwR041UHRmSXpnOXJ4MFRqUlNt?=
 =?utf-8?B?SExhNVU2bHFoRjd2MG5iSWZZUUZuS3EzQWtLdGQ0OThyY1AyanhaeUU4ZFho?=
 =?utf-8?B?N21JdWlzNjhnZS9Ha0lZdWE3elE4UmZ6LzgrbUJyZCtoSEFQSGl2QkxiOFhR?=
 =?utf-8?B?L1YrZkRqdjlLRGgvTDBVSTlvRElqZEtlSGNtNUJYelkxV3IwOERyQWI1QWpj?=
 =?utf-8?B?c3NuSFl6K2VzV3lBTDQwUTZjOG9haEZpVlVodHJLUmpTZUxQVWhWU2FsNUxv?=
 =?utf-8?B?MFpIb2ZzOWFTYWc3NnlXZVd3VHdMZXRlcWF5S3BUeUhyd3JxdVVnakx2ZTZ4?=
 =?utf-8?B?UDkzQmo4cnUzd01iYXdGNEg5Vk45azgzM2JRQ2k5T0l4TlFlaWFJcVVSa2M5?=
 =?utf-8?B?aHZVdUNwVFNPNzIyY2hCSkpWaTdZaGtlakQwVFJQU3VadVcvdnN6K25ZOVZi?=
 =?utf-8?B?UG5QR1Y1bFh2aFVXSE1rV3BvUXR3eVlSbnFLMFJJVkRPNTJGbUJObm5rNHoy?=
 =?utf-8?B?Nng3VGR0WHprTFhVZ1N6UGJOeGhrNTBINzBXZmUzc0NiVVVJcWxBS0p6TlpG?=
 =?utf-8?B?dENUbnZFYlBtM3R3UThucUZ4Mk1yK0owYmhpV1RMOWFFN3ZXdktLZGc5bi80?=
 =?utf-8?B?bTZGRmd0TlNlOWdiUStVb01kOHphSkE4NVh6Y0V5RzhMYmZtRzl2YnNWanhk?=
 =?utf-8?B?N1kxT05UMzFtQzVUVzBiQVVUYzQ3OUJ4aERIQldwcDN2ZG9VMlJsNWNkbHdk?=
 =?utf-8?B?aHJpRGc5MFNOR2FROG5oam1zR1lDcjY2NTRla283eU5qZ0JURjVYWTl2SXZw?=
 =?utf-8?B?US9TN0xCTnBxNk53bTFyVGptdnpwWXpzc0VOSFB4T2srZTNQK1YwRFEzaFJ6?=
 =?utf-8?B?dGFFWWpyZ0VJbEVWZnE4VlZNdzloSUZsam1aTjJ5MXlEL0F5Q1BkT1Bmb0JQ?=
 =?utf-8?B?TnU5YlUycXhvUzRTWGNTcnNpN25kSWp6eXR5Vkl0RWxITzAvSS9DMEY0ck42?=
 =?utf-8?B?ajJrM25nOVhGTUVTYVg1TTRPYStEWUhrTDFoOUhrK3ExbWtVRUF6ZGdFTEZ3?=
 =?utf-8?B?QVNnTTJJbk5zbGw2aFR3MWk0bTl5T3B1Tm5KazRkMHJtRVZOWWp6dEE1aTQx?=
 =?utf-8?B?TXVEcUlpZ0JwY1ZRU2VSZWhBckoyZnV0cm9CaG43QzF3MWhHZW1NT2R4bW12?=
 =?utf-8?B?S3ExNnVrd052NEV3UzdrcEx6YjFVaEN5WXRIS25uYkZNRCtWT0RQVkNFSGZp?=
 =?utf-8?B?SFlSeG9kL0lDQjZqWEt3U0x1cXJZc2c3ZXZUNzVJL0lCdWdYK0UxTkFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzUwRCt3QmFmUXA0OHd3allPNVhXaFBvV0V5bEVSbHRIQldRSlYwblBBcXNj?=
 =?utf-8?B?ZnlBS3pxZzIyRWpiSmlUaGJKVUdkUHh3cnpNc3RoUHRCakdkVXBldnp5eEFG?=
 =?utf-8?B?bDVSYUZKZ1pmOHIrZmZvRWd0c2pHa1Z0UCtOMVRkSTc2WlJic2ZOODZTQ0ZG?=
 =?utf-8?B?SG5QZGZ3dTVmaFZrOEZ2TVNxaWpycTFBemQ3MTZqV21LdTJnbEZKSG95NkJz?=
 =?utf-8?B?NDBWUzhoNXFyTVdiV1BscW0rYlcrZEs5NFdNNktWRHREQWUrdXpEUzdnd0ph?=
 =?utf-8?B?aUxxbUNSd3JIUzFKTUZkdmlQR0JBUk1PbDc5bGx1RUtSM3ZpbFRVNWM2akY0?=
 =?utf-8?B?OFFENEJOMzF1UkRnSFc0RmVMa0Z3N3FSMXdaWkxteitEK1BGZDY4LzI3c21w?=
 =?utf-8?B?R2dPcmx5b1FNVTlhZGhOMGZMRCs5SEFPVmhYZXA4WGNJVTVFZFdlVEdoTHJN?=
 =?utf-8?B?cFhsUVJXeXV0YVBMTDNJVFJ3cXlrS0J1ajAzbjlBSnhpck9qMndxN2VOQzR4?=
 =?utf-8?B?YlIyMHdNbVVKYjM0akdFZUJFMmZvcHVrZHp5U0srQ0M2eWo2Wlp0d01qS1I1?=
 =?utf-8?B?alNGVEJBbmoyWldUWXdyZ1U1S3hRTVYyU0owUWp3WmRzOEFpc05MZ1pVRzZU?=
 =?utf-8?B?dStxalY4WkkzVkw3enArSVZBZnpFRXRzWmhTUjl2bk9TL0M1dndORGxyZ0Fq?=
 =?utf-8?B?WlVPR2h4TWZUdDZRMGFmc2lVQ3lWMm1RRzZ3WVJwaGRqcHByWm9QTDZNTEVm?=
 =?utf-8?B?aThwTURNYnFCMHA2MXI5YTBDMEJ5MFF6TGJXY1FpM3VLb2cyZFdndU9sRjFp?=
 =?utf-8?B?UlN1RzRzUDEzVXBnRGhFdjJ6WllKMVBSekpGeit1ZHlBZkp5emJEMHN1ZHNk?=
 =?utf-8?B?MVhsMG1lVkZqZC9Ub2FkTXpYdnZFM0lUcndKMnEvN0JORnhUeFppcE13Qm8r?=
 =?utf-8?B?OU9yWlNqb0tCaEVRT2twS3dKSlNnNkUzWnJ1bGhqcXlTWVY0a3dseExQa1pF?=
 =?utf-8?B?UmdRTUNCL1FwSmlLcVY3cjRLOUtvUXZpK3YwQ0xCbGhEVFlmeHRiYzBRTGxk?=
 =?utf-8?B?SnJ5VlQwUWNsS3ZRQkpZZitveGZ5M1M0ZHBFRUpDL29KR2RxNUNWUUFTUC84?=
 =?utf-8?B?R0JwbjN2eDVxVlVSSlR0V2pQZTg1NkVKZjZMMmR6VkwrQklJaWdqMmFpSmFF?=
 =?utf-8?B?WlhpN2RNcWZpVEtFeTdadHRRWEtiYnNaam44amZEU0RxOFVqUjVQeWVvc2hn?=
 =?utf-8?B?QUlmTk9ESWtKVXFONWVic3BRSHorNDRuc3lNT3I5Q2NRd1VqOEQwVjlhdEhP?=
 =?utf-8?B?UUYrNUtJaWVsYWtIREpJNG0zdDdNdFY2QnZhMWhMMVY3MGE0bDJ4TXJscitW?=
 =?utf-8?B?UEE2eWRzejNxbUJpRzZsT3lhdGFmTDd2R1RqYVlBNU1nMHNEWmFWd01qUWRT?=
 =?utf-8?B?bmhVV0ZhZjN0L2hhbkNkb2lHazY3R3dTMEljSDRSMG9PMWxiNHJmY3FNTWhJ?=
 =?utf-8?B?N1lTYk9MTVhlUWh0TExrcldVMXIvaUt3WkEwd1FRaGZ6M1p4Qy9MTnNGRFN3?=
 =?utf-8?B?SFkzT2NybnYrSEFka2xBYWJ0NHk3cVVTV0VuZ0pRK0lQWURlQ05zQkRtNEFQ?=
 =?utf-8?B?cytTMkE5N3J1MDlkaFZVSE4va2JNMzlERCtiNkRHdS9PeDJaWC9aRGE2ZXVT?=
 =?utf-8?B?dDMyYXFlNnhUMmtWUExOdEZNbEs5VTFtdkhQZXRKQWdGbjBuZm12K2FVMEtY?=
 =?utf-8?B?ZVBMelFxbnpFR0dTTjRwd0MrZ1hyU2xkdHZLcHUrTEx4aEQvaGRoUnU2azhs?=
 =?utf-8?B?YTN2cmhCdGdwbVU0M09xNVVCT0lVVXJwRGpSZ1dCU0hUcW56NmRCMU1mYUtt?=
 =?utf-8?B?ejZRckhoQUw0N2wvQWtoTTdPdHhYVERSeGZiSjNHQkNFdUFXWG56TlMrQkRv?=
 =?utf-8?B?dkp0VExvL09kR0xxUk1HSjROb01OcFllNm1xK1FQK014WTY2MloybitkQ2FZ?=
 =?utf-8?B?bjRKQmhxNUorRU8rcXZnNk5oZHpKRHg3UXlHczEzdU0zUGJWdzdzSHBLRWI5?=
 =?utf-8?B?ZE9IQUJDODlKZnZSdEZmdE1VbmxXVEpPZkYyUDR5THBUMVJCMkR1YWlvdWI2?=
 =?utf-8?Q?6VYGaoqopRf98qed9KTmsu4Ec?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239b707c-7fcc-48fc-7f59-08dce9494591
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 16:33:29.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFBkg9tqdxvnfFAmG5OM+hqmM4vwljLAyv//4ND7lnrThypFx9QNxYkADwlAsNX4mPbpkMkrrWFdFdbwmSwBpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8792

On 10/10/2024 5:54 PM, Sean Christopherson wrote:
> On Thu, Oct 10, 2024, Pankaj Gupta wrote:
>> On 10/9/2024 5:04 PM, Sean Christopherson wrote:
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index db567d26f7b9..450dd0444a92 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -969,6 +969,15 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
>>>    static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>>>    {
>>>    	int num_vcpus = atomic_read(&kvm->online_vcpus);
>>> +
>>> +	/*
>>> +	 * Explicitly verify the target vCPU is online, as the anti-speculation
>>> +	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
>>> +	 * index, clamping the index to 0 would return vCPU0, not NULL.
>>> +	 */
>>> +	if (i >= num_vcpus)
>>> +		return NULL;
>>
>> Would sev.c needs a NULL check for?
>>
>> sev_migrate_from()
>> ...
>> src_vcpu = kvm_get_vcpu(src_kvm, i);
>> src_svm = to_svm(src_vcpu);
>> ...
> 
> Nope, sev_check_source_vcpus() verifies the source and destination have the same
> number of online vCPUs before calling sev_migrate_from(), and it's all done with
> both VMs locked.
> 
> static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
> {
> 	struct kvm_vcpu *src_vcpu;
> 	unsigned long i;
> 
> 	if (!sev_es_guest(src))
> 		return 0;
> 
> 	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> 		return -EINVAL;
> 
> 	kvm_for_each_vcpu(i, src_vcpu, src) {
> 		if (!src_vcpu->arch.guest_state_protected)
> 			return -EINVAL;
> 	}
> 
> 	return 0;
> }

Yes, right!

Thanks,
Pankaj


