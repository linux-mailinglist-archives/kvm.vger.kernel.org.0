Return-Path: <kvm+bounces-32024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D37119D1742
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 18:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94774282E67
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 17:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC80199EA3;
	Mon, 18 Nov 2024 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jJ5sg/lZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78005197531;
	Mon, 18 Nov 2024 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731951468; cv=fail; b=lr8YTFizLEv1NVY3Ap5XMtfoXEVStBu2lWw8ZANdcIwB7NBjDzOHgmrIiL47DwJjuRkpaUnwlbAyP5xSbVJQS4xlQspsxvn68rx5yS9zsuFrdSKfwnylDtQ6cy4+a/Wfg0ZPTlGu1wOZmNFrtjAcPUVFARJkRDplWorLGZ4fS8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731951468; c=relaxed/simple;
	bh=IBXvqN8MYC9lCPv/7aZaB2+526+WzpL6eNyPLvBsZj4=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=VfMfV/Wj6DDLlsvJPTzHHtKdf6i/kveJPVTfnxS+k+ww36dJhi1ylwLDNdKDf79MUFAdIJhbS9V4jUEHnFUP9dd5f1Stxacw08cCoWnU/2iQvZyS44n25TviPSh+GogVR2gc5qoW11wrk3TWJGJBphf7voJJLdLJ/NF/jgoKN1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jJ5sg/lZ; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgB10xnyQKA3coFcpPIGTzIBmMb2s8TGb50yOtiVhTx1R3Dr3OJvQO1tWJ4atm8K8rkfwM3LFW3ML2LDERSai/k3R/eo0fCDLuo26fiPrjcw2239r38XYXhbfZzdv2VfGr5Q7FiAK0PzpaD4k/cLPsEvaM/EU00zUM7ChLDC3NqBlz8ape5nz+nX2Zrsor47U0YHfMtZeapkiZraTbP2F1bFQbuB6DyjKKswkkUkOjLjTat7L5v+RFEHlHyvghRo3FnCTpzcRaSHH6R/RnJORcOhHo/+CMaAsBeUjplNaldesGxERI6YWmal35rDDfPz27qguoU0QWSFGZg1OdRxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUIlAV/wSwutlUVczAyme3N8ZL2UXThvIWSTIcoaOY0=;
 b=szfNTztbfOVWERJdLrkHa7h9wC1RPL4jYUgtUS91xLIdFkFMjAATvuUvbpf6yShbMKVS+A/cIIl33vTB7T6HSb3Y5TQEVbwp6i6HdYi5XTHoPT6YOfboH5QLpEH1CQTzSBoDoecBLoXJf4UziFbN8RJoqq71+8350ZCC70dKGUJ1DbCcasp74hz5yIIRCfyjFR+b/HeIMIqFfL+giyETiSQWUnZZNOtI8u4Zzfz3Kd7Pt5tp2aCnWmluZfhpe9cPu1I352Xy+FpOA4iOT4RCACztkAUaHbyQX6PVcFYcVyx2tpdWjkEK/7p6aj0WAQdC4i3e2BZu+WZysJ6lS+Qc1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUIlAV/wSwutlUVczAyme3N8ZL2UXThvIWSTIcoaOY0=;
 b=jJ5sg/lZhwLRBT/gbVFQ4D0CMaZ9zR2UcxWMRU/Q3bbpaSqktphaAO+8snxWk7SPMtVFglRjWNrGtamOqrp7inTeeLGl/HPwBfAJbU1cxLoKU9eJLqRi05rGq8SC4BntcEuPnzXf/94W7gwnfQPjlIJOFFe6Pu64gE9rgxOqIIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Mon, 18 Nov
 2024 17:37:43 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8158.023; Mon, 18 Nov 2024
 17:37:43 +0000
Message-ID: <96ab5caf-948f-a2ee-c8c3-41a919f5a39a@amd.com>
Date: Mon, 18 Nov 2024 11:37:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Jim Mattson <jmattson@google.com>, babu.moger@amd.com
Cc: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-3-davydov-max@yandex-team.ru>
 <2813ba0d-7e5d-03d4-26df-d5283b9c0549@amd.com>
 <CALMp9eT2RMe9ej_UbbeoKb+1hqWypxWswqg2aGodZHC0Vgoc=Q@mail.gmail.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/2] x86: KVM: Advertise AMD's speculation control
 features
In-Reply-To: <CALMp9eT2RMe9ej_UbbeoKb+1hqWypxWswqg2aGodZHC0Vgoc=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0183.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: efc32034-14cc-4857-bf42-08dd07f7b4e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2tPRHpzS2VHYy9IRVFYL3M2TndlRUlrUjdYcXJ2WDZjNnp5U0JjVmd1bHBR?=
 =?utf-8?B?QTJSZVljVDNnYVRoVW9TZlAxK1RQWkl4N2c4aXAzUnMrbC9GNGg4WmZ3c25a?=
 =?utf-8?B?OEhBSm1XbjNKNlpxcWw2dE55eFdvZmRHWUlnWGlGMDY4ZzBsZjNKblJGSnJD?=
 =?utf-8?B?bjZLR2NYb1IvT2xja3JwVzZwcWt5c04rZ0tLYWZJYnYyOEVuM2dyZWZiN09G?=
 =?utf-8?B?YkNMaHU4dDRrYkNjd1dFdVc1K3dGdVdQRUVILzVFN0h1cm1rYzJKVS8wc1M1?=
 =?utf-8?B?Y3pEODRucVVMM2duWEZHYWRoSmhoekhhTUFZSkFUalFXT1I5eHJLcVoxK3FK?=
 =?utf-8?B?UVlJWTZXalBVTG15S2xLYUcvTVFwWDdhNlE2VlBVc2FGT0ZpMFE1K1h1OXJS?=
 =?utf-8?B?WUtoWUV0RUU1UEdJT3EyUjRtZjdyZHJFVENiRDA2SlJyZG9OZ3NwUVpzOXdq?=
 =?utf-8?B?TldoTk9lZFZqVjRCRzNJSjhzVXU4enFjVTdNUnRnRlJmdTNlRVltdXJ5ZWRL?=
 =?utf-8?B?dzBrb0o1b2Z1bXBJcU1iY3lxemVpbHRxemxwR3BFdGJjeStuTVhuWlk4Zy9P?=
 =?utf-8?B?V3JkYzNaNUkrSVIzWlptNXdvc2xzdHdMemlCRnhscWdvcFZhZ290b0tndXRF?=
 =?utf-8?B?YlIwaTZKUWkvTElzNlhDQ3p0QmtUK3JSUWYrWjF4djZ4WXRwWWI4aWVERVV4?=
 =?utf-8?B?Rmd3bko5TFlKSWxoYmJXZ21ZL2tLMEx3RnVVZi9VSHI0T0hFMXphOThhRW50?=
 =?utf-8?B?bndNSWhYN1VyeFZuMXBMVTFENmJyK3BhZVNtTVh4Mk1uM0QwZ1hjSUJJdTlv?=
 =?utf-8?B?MnY4QUNSNXUzallxeXNWVUU0QnJObklQUWNRcGpVQ3VwU1BhOHlLQWpMYXIy?=
 =?utf-8?B?eFQyRXBEZWt3UUs2TERGa3JWNG4zTlRwbGVjbVh1eS9CVmhnNkNmS1dHU1R5?=
 =?utf-8?B?bTVoMk1wTTNqdFQ0MitvOUl1OCtDQm5BS2YrRzJJSTBTOFZuQmJYVFZEcThu?=
 =?utf-8?B?eFAyWjlsSUlrOWZ3Q2hPdnludmI4TlBITG9JVERTSGNXcng0LzJjQzc1THdz?=
 =?utf-8?B?RzNYdGwvQ2Rkd1JSMHh5dktudnI2UFJ1c3Z2eXgzSytjQVhPYStSTWc0SkZB?=
 =?utf-8?B?R1RmcGhvQzQ3bzdlc1pqOGxOWnB6OW5PekREK1RTZFJ2TjdNTjFleDlMQzNQ?=
 =?utf-8?B?SmkxQWpwMFIybkpVVHFvZnA0bDM5RUFIVlN5THhTaUtXM2xTUDRJSGdLTXU1?=
 =?utf-8?B?S1VaWFo0V3VXWGl5bC82ZWtDUXJKUHg5eEFXems5bUh3bVVsYTRuV09QZjFm?=
 =?utf-8?B?NHUrS3NFTzlPYWpwNEtRTWlQbExhWWFaVWFSQmtPeG5MR0ZKVXBkeVF2dVd4?=
 =?utf-8?B?US9pTm0xUzB3OVFlSEZTREF1V09ZZ25nLzhxYXhZa3plWHZMQk5wMmM5aW1s?=
 =?utf-8?B?c2E5UmdVMERoTUpmeUNKeVh2dXYxNzQ0NEU1QmtKMDQ0VWYyUHJ3ZDRScERQ?=
 =?utf-8?B?ckI4Z05JM1Y1THU0aVFSTWtPQi9tMmxqVFpTcG9OcG1FVWZEOWh5bFB4SnJY?=
 =?utf-8?B?VlBFZUtDSkJrRkJpSlZuYWJOeDhSNmdleHpKeTdZanBsK0N5dWxSQnZRbWdR?=
 =?utf-8?B?SnhSZERId0hSd00yVC9SUFpWUjNnTEZHamZjcXR2NlByVTMvb3JwNmphUE5L?=
 =?utf-8?B?dDdmRmR5VEJYZ01FL2gvUFhXMFFoQ2dYdXcxQzNJNHhmZHNoWjRVbW5ZTDBj?=
 =?utf-8?Q?BYaUmkzgUAmefooqUvDZm4Hw7qahxxpkwQ1cFzj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGNBbVYwQ25kYVZ3akpvalhFVjI3SjNwNHBxQUNtaU1XUTg3d0lQeFJIWjcv?=
 =?utf-8?B?bGpKck85eEU3QkwrY3FkUFJ5V2FTVFhhbVdvb1RhK3M2em1uSFIzK0NCSHlC?=
 =?utf-8?B?QjNON3pwMHZDa2pPWHVLK0MzQXRJT1hwcFZhL1NUUVhuYnFXU21KaEV5THFm?=
 =?utf-8?B?eXo5b2Y2NW1NNEVzTU9oUHFWQzF4ZmtBR2VyUDU4bVkrU3FjYjY2NGNnWHZB?=
 =?utf-8?B?SnhNSWhnRk9yZkVLZXRjU0MzRGxGcllBQnVrY29NRU5aUVFZVkVhU00xV0g5?=
 =?utf-8?B?M3ByV3RUZ2EvWUdQMjlVRDFiUSt1ZHBLY3Z4Vk01ai82SlBnR3JwT0hrSVNU?=
 =?utf-8?B?cVRTMnd2d2hEdWhyZkhrV1pmWk1zenBTYVJRRVU2OWZ5SmtjeVY1UzZMT2RZ?=
 =?utf-8?B?RUxXTGR5V1I0c2c5TE41OGxMOWlHNmNtSXhBbUtHZEkvamgza2RzS1pkcG1m?=
 =?utf-8?B?TzZEVjdHb3N4aHp4ZEdzcEVxU2JTc3hSUEx5R3QwQ2tEei83elN0Q3pFOXNZ?=
 =?utf-8?B?WkNSZ3lYMHJRckZWU1JkN0lQWHZ2TnBqU1dGTk9PRkd5a1I2UHZ2RDBkNjBn?=
 =?utf-8?B?SmtVcmdIYjgwSHkvTjg0NDYwSWE5R1Zla3RrNCtoSi9aYnQ2OVRiRjJwOEI5?=
 =?utf-8?B?OHU4UW8rYklyY01leDJNU05BNE9lMzNHRFJ5d29VVUxkeXo5Vk5XVjl0YTkz?=
 =?utf-8?B?VVRYQU13bDdlTHdOaGZ4WFVBSHhnb1k4Um5Yd0dGWXVRQ2s1NjVtQk96MVBS?=
 =?utf-8?B?WXJXakhOWlNza3J5UDlTV1ZVeGNpK1laTlBrU0NxWGIwbGxNeHNaT0t1bVZR?=
 =?utf-8?B?Zkw5WWo1N2RZYzNmeWZFR0dVWXk4UHNCd3JvN0NUSTBZUFlRdHRVTDVPK1VK?=
 =?utf-8?B?bWhzRG82SlJXRlJKTEZja3F1OCtmZzk4WTh4b3FJekJ6eFRlUlcvQko2anBB?=
 =?utf-8?B?ODRmM0VDODNzNVpPb2FWWkN3M0wrRGxzdERGc0RhUXJzck10NkpmSm55N0w0?=
 =?utf-8?B?aU8wY3NLZ2lvc2EvRlpRZEIwZjRRL1Y1dEJUSEpmZDdEbnMvb09adHNMRFhn?=
 =?utf-8?B?dGpTdlhNTEE3MDBlRVdrN0VvblZyd0V5VWRiYmtmejY0TGIvTWFsMFdIWjNB?=
 =?utf-8?B?clZmaStTRVlqdEtUN3pXeG43L0dKemM1NHQvMklLc0RmcHF0U0pHZnVyVEta?=
 =?utf-8?B?YUhCc0pNR083NjhoSlNjS3FKU0JDWmYvVldSTUNoRFNpZ0pQaUdlVkRRUFZ2?=
 =?utf-8?B?MEgzem03MEtDVFpzU2pxSXhwWlNQWDFiQzA2STQ5N1ZINVJLUy9rTGVZQnhN?=
 =?utf-8?B?aVhMMXk1djFubmo3RGwraWFBcHZ0M09WTFRmbjVhdDZpV1RxNVREUkZvZEFs?=
 =?utf-8?B?REVwamRzMms3K1VVSGM0bFhWUHovVEtzQUNPZUdxd0sxUnV3MmVjVWlzN2ZW?=
 =?utf-8?B?bzhQU3BHaGR1T0RoQjRPYzJBUEl0OHk4cU1halhOWU9Va3FPSC9hMjd3VTNu?=
 =?utf-8?B?ZmhaR2l5cVBoc0poWndLSGkwdmlyZ09jb2JNY05KOG5CZXJYeFFBeStNRW01?=
 =?utf-8?B?THhPTnY2VFF6eFJIUE5JVHhFQWw2eE55NExWYTZvT1pQblMybENrdTd1R0VB?=
 =?utf-8?B?YTNNdUo2WUVtK1hlVVRna0VhRDFsa2s3eVkvbGhBMEYzTEN2M2NTVm1rTW5q?=
 =?utf-8?B?VlVKQitLSTN4c2FTeS8rSk9pcVIxM2hqRVFNVzI3UGE1SlZHRlRTVHovSFpV?=
 =?utf-8?B?dXVtZHdueHhjMnFQVVhtYkJ0RU1VeWNURE1Rd3lHejFkRWF6TmZuWDJIYk1N?=
 =?utf-8?B?R0NHaDRLR2prWm1iQ3FidENxNG1NakVjSHE0cXc4REpoNG4rQ1YzdkU4K2Js?=
 =?utf-8?B?UmZuNWp5Z1lkQjBmaE50VjhCRzhMaDZEY2lYK0xOd0pINDAyeVBORlVGeE4y?=
 =?utf-8?B?V2pYZWJlSEdFR3Z1Y3FUeFJGcGVabGREQitIY0haTTBEVHpOZy9CV1h6MTFD?=
 =?utf-8?B?cC9sUEtySG5kaG5DZ2FtaUJBSlFRWHU2dGNYUURhS0xmWXpPWG5SSjdKcG14?=
 =?utf-8?B?aFdHNkZLTDNTWVkrcDdMN0hpcFJvYWk1QkZlRmwvNWFBUHVpN3ZBa0MzZjZr?=
 =?utf-8?Q?6LMWwxwBOzjO59C4c/XFL2jJs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc32034-14cc-4857-bf42-08dd07f7b4e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 17:37:43.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 97dgg4JyzerzSd3dB/XqA5XrtyMqFtEVIuU7tw9hW74sEcePBiM25YuShABEsQIOy5N7FYkUSLnf/f2lybLcdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

On 11/15/24 14:32, Jim Mattson wrote:
> On Fri, Nov 15, 2024 at 12:13 PM Moger, Babu <bmoger@amd.com> wrote:
>>
>> Hi Maksim,
>>
>>
>> On 11/13/2024 7:30 AM, Maksim Davydov wrote:
>>> It seems helpful to expose to userspace some speculation control features
>>> from 0x80000008_EBX function:
>>> * 16 bit. IBRS always on. Indicates whether processor prefers that
>>>    IBRS is always on. It simplifies speculation managing.
>>
>> Spec say bit 16 is reserved.
>>
>> 16 Reserved
>>
>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> 
> The APM volume 3 ( 24594—Rev. 3.36—March 2024) declares this bit as
> "Processor prefers that STIBP be left on." Once a bit has been
> documented like that, you have to assume that software has been
> written that expects those semantics. AMD does not have the option of
> undocumenting the bit.  You can deprecate it, but it now has the
> originally documented semantics until the end of time.

Just for accuracy, the APM version referred to has bit 16 declared as
"Processor prefers that IBRS be left on.", not STIBP.

Thanks,
Tom

> 
>>> * 18 bit. IBRS is preferred over software solution. Indicates that
>>>    software mitigations can be replaced with more performant IBRS.
>>> * 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
>>>    is set indirect branch predictions are not influenced by any prior
>>>    indirect branches.
>>> * 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
>>>    confusion. It's used during mitigations setting up.
>>> * 30 bit. IBPB clears return address predictor. It's used during
>>>    mitigations setting up.
>>>
>>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>>> ---
>>>   arch/x86/include/asm/cpufeatures.h | 3 +++
>>>   arch/x86/kvm/cpuid.c               | 5 +++--
>>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>> index 2f8a858325a4..f5491bba75fc 100644
>>> --- a/arch/x86/include/asm/cpufeatures.h
>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>> @@ -340,7 +340,10 @@
>>>   #define X86_FEATURE_AMD_IBPB                (13*32+12) /* Indirect Branch Prediction Barrier */
>>>   #define X86_FEATURE_AMD_IBRS                (13*32+14) /* Indirect Branch Restricted Speculation */
>>>   #define X86_FEATURE_AMD_STIBP               (13*32+15) /* Single Thread Indirect Branch Predictors */
>>> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON       (13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
>>
>> You might have to remove this.
> 
> No; it's fine. The bit can never be used for anything else.
> 
>>>   #define X86_FEATURE_AMD_STIBP_ALWAYS_ON     (13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>>> +#define X86_FEATURE_AMD_IBRS_PREFERRED       (13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
>>> +#define X86_FEATURE_AMD_IBRS_SMP     (13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode Protection */
>>>   #define X86_FEATURE_AMD_PPIN                (13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>>>   #define X86_FEATURE_AMD_SSBD                (13*32+24) /* Speculative Store Bypass Disable */
>>>   #define X86_FEATURE_VIRT_SSBD               (13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 30ce1bcfc47f..5b2d52913b18 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
>>>       kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>>>               F(CLZERO) | F(XSAVEERPTR) |
>>>               F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>>> -             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
>>> -             F(AMD_PSFD)
>>> +             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
>>> +             F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
>>> +             F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
>>>       );
>>>
>>>       /*
>>
>> --
>> - Babu Moger
>>
> 

