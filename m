Return-Path: <kvm+bounces-34712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16D7A04B43
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 21:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B2453A536C
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283091F708C;
	Tue,  7 Jan 2025 20:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VfwldQnO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8FC1DF98E;
	Tue,  7 Jan 2025 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736283424; cv=fail; b=KQb3MvnQwpkBFuumnQPtoPpE4JTSvJMIT6pJYmVWAb/PI9d9ssvA4f28WpxhmKf0DJwTL7cvKhWIgPSv2KAmuDMaBXhA+fV9THH0HxZCkqFEM8V/isA4O5WNdLIYgM7/LapZsLmKNJ9sr6TMf7QgU2E+F4QwDaAPuZyxILrKMyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736283424; c=relaxed/simple;
	bh=eHzCuu6sxDZiyvU+eTjdaxBuJIjc176FYXiwWPvshqg=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uKyjX33HvcVsiwhph+IDuuYFrCW1hplIzmxlVAx9+yfmEQ5HktQ7/4SVDJjoblQrhlnfGNt7UuSZA/rjuC1buLPOSTqALAOTgvA/ya8cy9NexHVHYd3d56Pw1cisGkGzozMFrGWNBJna0AhFuYUTb5MEzdK/STzRSRj2XvO33XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VfwldQnO; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUx15IyA1IV+qRzlr3XG7zaCZ7a30gkDQmfbXEFEKb0pWJFTlH3CfXjILPpmEdTSN9YlBsnkLI+Gu2kpwhIShtQA5ydH/eLR0l67rI02kXqj1M6QKpN3px8f4qX1krX/CH2nlXC9oRNselhkiHeBXBxX3fuSNNs1qa4E2ubWAmKHhLf4xGdk7clA31LdeheMAYgXPvNIZ/A1RGI0j6ilS1KLXmMxj+lDT5kvqTTBulVLZM4uH3PFQm98WTR1LREvvOyc85S/gVeIf8mzh4BmxCdDPbG5uJ/rj7c15oeLR1mq7U2U5u0fSu5LK84TAAIvoB81KEd7mGfZr46TqbvjgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U07tF09GYVwzVzmcPSTOoVfNY0vaFLiCzV8EDlPOdpE=;
 b=Mp8i4TEMwD7atot606Ce+ZnyvZQjXM84AAL7kG/REjMfafBYOKl02KLQp1krauFp3nj1+Rp1s2jxzlvKlfZD/YES+YZz+wFcm6tJce2Vr6wD34O6PojcxP2a7KTTrrH17LypJPhRkDcKjtnHjrM3nagpfYQXLclYyehbKbqMDghY7s3oEzPwLNIwzw38bIjEm50vhTQdwh1SMx/q7DpN64hnoM0kwgineD49AviOxZpWkZ86NR6NlDoue0b+pOEb4UQQjMLrlLHSI9cZxsagAn+5iK7ceP0mFe48OvxSJ6qjoNkGwgHQ4rz0KpcRg2g2IspfYFfpgft8iGMVBUraOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U07tF09GYVwzVzmcPSTOoVfNY0vaFLiCzV8EDlPOdpE=;
 b=VfwldQnO1y97n2zxrZpRrcguKfwhFpz4KV+LVTit3fJuonWuz/lK4apK6rmiB/b82/6PHQz2/JaBK8m379Wxh1g3VJmSdziynXZ4n6x+QegEKQHlJIE1zDwhbZj16cYr8Lm5krHdApnLUkWg/qkef4l2GUp4V20EqshuVHGjilY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 20:56:55 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 20:56:55 +0000
Message-ID: <cb60951a-a8fc-4232-80eb-311e2bd16c81@amd.com>
Date: Tue, 7 Jan 2025 14:56:52 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 Peter Gonda <pgonda@google.com>
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
Content-Language: en-US
In-Reply-To: <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0187.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::12) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: af1c05fd-37ca-498b-925f-08dd2f5dd1c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z01GTy9kTW5hYk9Pd2pNMDNRTk5jWHZMdnFjUFcxSENtM2RnWUNCMktORWYr?=
 =?utf-8?B?VXNQZEIvWjd2K3pVbHdVWDlqb1d1S0ljN1phblA0VW5YNm5xOG12eHJ6RTFU?=
 =?utf-8?B?Y0F2ZXhISmtOTUIzTnRHdjZJVUhLZFR1N1hsQi9LTW9Ib1I2OFdmbXBPclVH?=
 =?utf-8?B?YWNidW9Pb2Y5VS9XVnE2cDI4YXl0Qk1RRU5GT3I2QnB1YzU0S2R4K3hEdjBV?=
 =?utf-8?B?QzYyU3ZIb3pFQWVrbE1CU0R0V2RmcE1nUWUzYW1WVFNvNURCb3J1cDhDL2E2?=
 =?utf-8?B?Z3BlYS84dm4rZEo4bVBLQXlQYW9hdjVVVnRDMlVqaWY0QTVQSGdzNEt3eWVX?=
 =?utf-8?B?OTZkd2FWak1ZZE1TSkpjYmZPemliazZiQi9Kdm11Zmh3dHNHcnJZdlZPeGE4?=
 =?utf-8?B?bXBGY25wUjRZV0hnWCtmdDg0WU5FR3N5Uy8vemlVMTRnN3pWYmRLOXlRSkV6?=
 =?utf-8?B?V1pvT1lkWGk3WkZkNDlYOXBZaVVIQUEzQ2YxSUlyMkpISWFjcStURFkyZmF3?=
 =?utf-8?B?SVRHYU1kQlM1UU1yL25DSHVONGpHTUN5MHNXY1FONzBJUzQ3T1Z5ZVBSS0tj?=
 =?utf-8?B?Vy9wSE1MQ2ZtYTRoeGwrK2ErQVAzWXRrWXBOY0pwN1FYdm9NbC9FRmc3dHFH?=
 =?utf-8?B?Zm5PMTc2TURJc1lFOHh1RGVWa2VhSGdCMnlPcjVlVW5mVVova1J3UVM3UTJO?=
 =?utf-8?B?N0M0L252aVlzMWhsQlZPdC9DYUU4SmMrei9DYVIvVlRzRmk4RU9wSXl6Vkl1?=
 =?utf-8?B?OU9JdVYrZWFjelc2RmI5MVdtVkozY1NqK1YyZnhZam8zK1lKb1k5dGk5dDV6?=
 =?utf-8?B?Q00yeTdyU0N6TFU5aDVub01NaUtKa3ZzUVUrWEYyM3RMeEhveHVBclFWekM4?=
 =?utf-8?B?Q085MU04b3lGMStPYmw2VmpYc0lhdmp0UjFSOU9ObGNxZjFXdkRhRmdMSlNs?=
 =?utf-8?B?SGtEaEN6Q2NaS3piMjVoMFFtcmNRdXZ0RC8zcnE5SXFyMVJWdXlhaFc4Vmxk?=
 =?utf-8?B?L3JpVWJMVzBOeHlMajQ5L1pBNlJGNHBkSmt0N0VjYnQ5dlZVd0JzVFVkR3l2?=
 =?utf-8?B?SXY5N2Fyblh6TEU5Z1I4SE9ZVXFkTU5kU0dPTjc2dVJPeHg1aGNyU1I1VW1P?=
 =?utf-8?B?bk9rL0JhR3pPU1pSaElhYUpZaU95VzlibFJRbzBBSkJ0N2J1SFk1RVNJQm5H?=
 =?utf-8?B?dEVpTFNtWlZ6dnN6akxNMEZ0YVJVZko0eExUT1lmaFlLeHRsUDZUTkJWM0NY?=
 =?utf-8?B?dzNDM0t1Z2Z6eHd5YXA2M2lBUDYyQlpRczdVb1I1cEtrR2laRCtaTWdBcVdZ?=
 =?utf-8?B?TTRzUmoyQ1dVZ1dqWStxT0FOU1QwU3hISVdQR29vWTBIMnhNUitKeEJiMFJi?=
 =?utf-8?B?WjJMb1o5d2lqQnB6NURHYTQ2RExNNVByUjBJM3ZMMlkxQjVFTGN2KzBTdmJn?=
 =?utf-8?B?MTB5UkFGOFVhVEtsN3BrRFJVTEhzTzlZY3orOXI3U1FocWxjZmp3clVJdTA4?=
 =?utf-8?B?SXhJOE1TMnZ1Z1JuRFk4Ni9oN0FXR2tBUEpjcXhidTFJNHVjV0Uxa3ZnZUlS?=
 =?utf-8?B?OXNPNXhsVFNtMkE2L0QyOWl0czBDQmp1aDQ4SG9RUVFRUUVxMTV3bUgyakdJ?=
 =?utf-8?B?SHl4YXgxT3VUUnlCaGVDcFhJM0xPR1B6T2dFLytkTTFLeUVBQ3BUSUtmYlFK?=
 =?utf-8?B?M2RBdVM1WWFIL2xSd2N3c3Jnb3l2UExpSmVQMGVndm4xRVNsRU5XMDBxTTBP?=
 =?utf-8?B?SUVpajgrTkZiR3BRYjQ2UCtsazBhZzhVQ3FOZk5FdzNoeGNuc1Y0ZTUrTDhm?=
 =?utf-8?B?bFBsNno4aXdFWUk3bnVseFdUL1dEeitJOEx6dktKTVpodWJuOGhPekw3eUJU?=
 =?utf-8?B?N3huQUdrT3RFamFIV09XMVh5TmwxL0J4K1g4amovR2FCbG1NVFFWS0ZnK0lw?=
 =?utf-8?Q?ab2Uj0qJrAI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2U1TWtyQlJ0dTJMTjhDUVV6S1FCa3ZWWnMzeEF0SDBIV0Z1WUozZ3JqdDRF?=
 =?utf-8?B?NlM4YzRtK1p0Z3BLNFBnT0thYmg0dFR3NGRpcWhBRVdaNjZrMk5aMVFmbmxL?=
 =?utf-8?B?M202Q2V6cDRNL010UEFocTJYa3Fyd2pGMExtOHZMUDE3Rnc3ejRnSU1NVW5v?=
 =?utf-8?B?QksvZEY0WDY5cm0zY1daalhzYkR0MEo4L2piSTBzL3MrV1pWR1NsOXBpbVoy?=
 =?utf-8?B?azc0VVZqQUdCYlpaK0RRdE1sRVRVN3VJbFRRaU5JYTZWeEUzQW5TTXljNnlh?=
 =?utf-8?B?STM4dnUyUHRJV3Y5MFp1dGxhMTdJTkxyUVZ0MTExWDB3QmZPRjd4c3czSy9O?=
 =?utf-8?B?WFRIcnM2aVBtZFZPL1ozcEJVZm5UdVo4MDlNYlgwcU51ZC9neHJmM2hhdmdY?=
 =?utf-8?B?MEM2bXpKZndnNDVSa0xHRFcrWnlYS1JFdWJ6bDE5T0R2MWkyckp0bUVJWUxD?=
 =?utf-8?B?M3M5dy81d2h0MkZOS3dsTXZtZjU4NDgwa3RXL3pZdTNneVpyVnBYcHBEbDY5?=
 =?utf-8?B?dU5Pb2ZEQ3d4Uk5BMkVPQkRCNUp5c3ErVkZieDRHWVNEM3UzcWhETXpHOVRR?=
 =?utf-8?B?dDFqNEZxU0Qzek9lSDdjNW9FcHdwRXZERmdRZW9DcWpXczBPNmk5cFBQMUdQ?=
 =?utf-8?B?UGpxQ05sM0l5T0RXTVhsUmkrR0tIdjREdWt5NDBOL00wck83aXk2dVZXeUxa?=
 =?utf-8?B?S1FGTDNWMm9ZM3pVTFZqY3FVdFBHRndqYlIyOXNBZ2RMdmFyemlNbGd1aytq?=
 =?utf-8?B?Q1JUV3ZwaDgzeGJ0UGhQdjBxaVFuNTlhNVlqTnpsVS9SeUUxY0JnVWh3REJj?=
 =?utf-8?B?eFNsVktnS0VycXI3SW1oelBJdTk5K1cvdzhLOGZ3QUtncXorMW11c25iUlpj?=
 =?utf-8?B?anQ4cW1CZVRZcWFoNCtKa3ovMWFnYjNOQWhvekFxWUNmS29rVUVKQmxMZFBW?=
 =?utf-8?B?TnIzSDE1UlJZaHpsMHcrWU9QaVBrNkthWTJyMkpScmhrY0xGc2xRSXRzOFJk?=
 =?utf-8?B?cWdmeXY1eVY3UWx5cHFyVjZmM0ttS0lVdGZqejZGeXdyaHBhNU5MSEpLT29Y?=
 =?utf-8?B?RzdBVzlaOFp4Y0JnL0JmeittQThvK0J4QUtINmx2ZzRid1lHL2lyaWtKa3ZV?=
 =?utf-8?B?WU0xMElIN29nbUMyeHFrVWRQeDhlSlFnVnh6cTZlOW9SVzNtSnB1Z09ZbWk5?=
 =?utf-8?B?cHFPczhBaUZuZ25YSTNHZkVWeWlkWmxKNkJQUWRtLy9SMHdua1U0M3BSSm5t?=
 =?utf-8?B?K1JZWWprRmk1dnV6bmtJbUxTMXdsSjRTUDJaVWZ4MURFcmRwdEVPbzFkVlJw?=
 =?utf-8?B?N2duaEpIbXdxN0ladnJDeEtIcHhJUW1TMm12Ukl0ay9ZZFZvU3h1WGxwcFNQ?=
 =?utf-8?B?TDdWbkFnd2E3cXBYV2k0QzQySGVQZnNBa0JRVHlmR0FYaVZJMnRtdHB0dHVn?=
 =?utf-8?B?THpteittN3NoNmhmbnRBN01BSHZEdXhxWHBLdk45WFRORitpcm9uS2J3TmdS?=
 =?utf-8?B?dXRReFVodUlBMXlOZld3SUJFMUdQeEF2a2x5anRJejZOM1J6aUV3Y2sxS3Fr?=
 =?utf-8?B?dW0wdVljcGovcXprZ05iTTQzdFFRaitNY3hnVnpDc3NaV1NkU2I3Q05kWDAr?=
 =?utf-8?B?T2hQTUZFckkyY2IycHJaazlmbFp5SjVleUFEc2FLRDhjZFFtRUFiN2dPak4w?=
 =?utf-8?B?TjJzT1dKZnVzSTR6VVFrTkU1N2I1RW4vcW5KdHowd0I3RitjZkdHc0pLZzN5?=
 =?utf-8?B?RTAwTTgwSEc4QUpUZXJKNDVPTmNzLzM5Q3RIK2ZlaDVUZkFnNVl3VzVKRHQx?=
 =?utf-8?B?RlRDcVNKNnhjQ3IyRzZIbm1nOXRzbHorTzZmaDRYYmdYMWJXUkxnZ0JmNlVJ?=
 =?utf-8?B?dEk2YkNMa0dUb3RjYWRPa0NUUkNtVktFVFpuNHJnQzVoeXhTSnIrUWNNb05x?=
 =?utf-8?B?cTFMbmg4U21BaHgrYXZZczdlNTFIVG13b0tuWVZFb29OYk1VQzhtMUpGT3dn?=
 =?utf-8?B?VjJaczRqWWZZM2hsWDVtMkIwMFRuSzlJZStkeGl4K0RBWWduY3hOMXJRVDJ6?=
 =?utf-8?B?c2xqUWluOHVkaVZORDFqek9MRTdTa3VJV01hSDdTUlc0czZPZUVFclp0MXNw?=
 =?utf-8?Q?BfdQLEd1sQiL07aKpbfqpMCFy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1c05fd-37ca-498b-925f-08dd2f5dd1c1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 20:56:55.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSOM9rNk7XZdjKNY9GmdyxtI8IVQhw89YTJJpJRsR46mQWB/w/TqhFBTKzZJeDX3091B3FCdluZzEs7/P4GVTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

+Adding Peter

On 1/7/2025 12:34 PM, Kalra, Ashish wrote:
> 
> 
> On 1/7/2025 10:42 AM, Tom Lendacky wrote:
>> On 1/3/25 14:01, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Remove platform initialization of SEV/SNP from PSP driver probe time and
>>
>> Actually, you're not removing it, yet...
>>
>>> move it to KVM module load time so that KVM can do SEV/SNP platform
>>> initialization explicitly if it actually wants to use SEV/SNP
>>> functionality.
>>>
>>> With this patch, KVM will explicitly call into the PSP driver at load time
>>> to initialize SEV/SNP by default but this behavior can be altered with KVM
>>> module parameters to not do SEV/SNP platform initialization at module load
>>> time if required. Additionally SEV/SNP platform shutdown is invoked during
>>> KVM module unload time.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 943bd074a5d3..0dc8294582c6 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>  	if (ret)
>>>  		goto e_no_asid;
>>>  
>>> -	init_args.probe = false;
>>>  	ret = sev_platform_init(&init_args);
>>>  	if (ret)
>>>  		goto e_free;
>>> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>>>  void __init sev_hardware_setup(void)
>>>  {
>>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>> +	struct sev_platform_init_args init_args = {0};
>>
>> Will this cause issues if KVM is built-in and INIT_EX is being used
>> (init_ex_path ccp parameter)? The probe parameter is used for
>> initialization done before the filesystem is available.
>>
> 
> Yes, this will cause issues if KVM is builtin and INIT_EX is being used,
> but my question is how will INIT_EX be used when we move SEV INIT
> to KVM ?
> 
> If we continue to use the probe field here and also continue to support
> psp_init_on_probe module parameter for CCP, how will SEV INIT_EX be
> invoked ? 
> 
> How is SEV INIT_EX invoked in PSP driver currently if psp_init_on_probe
> parameter is set to false ?
> 
> The KVM path to invoke sev_platform_init() when a SEV VM is being launched 
> cannot be used because QEMU checks for SEV to be initialized before
> invoking this code path to launch the guest.

Peter, I believe that you have a different path to test SEV INIT_EX which 
won't be affected by this QEMU check. 

I will add back the probe field and psp_init_on_probe parameter for the 
CCP module, but i will need your help to test and verify if SEV INIT_EX
works with this patch-set.

Thanks,
Ashish

> 
>> Thanks,
>> Tom
>>
>>>  	bool sev_snp_supported = false;
>>>  	bool sev_es_supported = false;
>>>  	bool sev_supported = false;
>>> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>>>  	sev_supported_vmsa_features = 0;
>>>  	if (sev_es_debug_swap_enabled)
>>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>> +
>>> +	if (!sev_enabled)
>>> +		return;
>>> +
>>> +	/*
>>> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
>>> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
>>> +	 * VMs in case SNP is enabled system-wide.
>>> +	 */
>>> +	sev_platform_init(&init_args);
>>>  }
>>>  
>>>  void sev_hardware_unsetup(void)
>>> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>>>  
>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>>> +
>>> +	/* Do SEV and SNP Shutdown */
>>> +	sev_platform_shutdown();
>>>  }
>>>  
>>>  int sev_cpu_init(struct svm_cpu_data *sd)
> 


