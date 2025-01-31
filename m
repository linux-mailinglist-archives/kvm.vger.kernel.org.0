Return-Path: <kvm+bounces-37008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2114A24565
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 23:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 598D1188988D
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 22:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD5719AD89;
	Fri, 31 Jan 2025 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KAs9QT5j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20AF19E7D3;
	Fri, 31 Jan 2025 22:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738363996; cv=fail; b=lPJ5LJ6QoOWlNstOOQ05IUMFFKM+/1+aqrFfmoc2nOINZ4oUa0fdQAMqhqyrlkVCK4tb55aQ436uxFv6Tuxfq21tI8fI9mzx8dFrxz/LWSHept+V8w04E0KWs7/xaYa9GHGVN4eA3S7l7Rv0Otin1RiqOdD4OmGmVLSYCZ/G2Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738363996; c=relaxed/simple;
	bh=mX8aeMeQU6KAmptRSsUytWCxIHdFe4MUjsG7bannAF0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YfxQfUEovqbK66xGrYiGFn+4a8oVCpsvgnAWMtjxc4DdqhRLFQWwcbi6k/wD1UvE+7ij/xC+l9OTd4tDabAn7C84W67p2QVoX6hByeanQZ7vqWabfxbE19VjurnLUGri9KDPOwcsWWKhhU2zXgx+x5LyIIEPYjvmOW3frNVz8GA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KAs9QT5j; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d5jZ9+o40FrWxeTmQ8SsXhc1Zu0WBZ3N1+NLJVrD9egPkCRCe5Vr9mRWWEY9rjx9cuih/cMYrW162iclwiaJCD1PJFULIlIvW6u1gf9doeN2peEh7PeURACK1zbHH6FGpfKd8Ta+ATXolmpQB2rQ1kqcji/RiV+XIxozCXzMMwGINi+w6yGcqOnYpEJX2ey/CwvJTayf82yAza33LNaEvwit6o1InfaWGrQDv2MlC/NmZmmFhFrTkAvT1hxGENuujsN9A3fbpKDbYLrhJHOaxEK/lNIZxRt+E/970OEexrgecv9pVa2vlHZNyJU0npT9ZOSdhMZGBCMsQTf9stPOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UN5Jg4+hTpRVwG/OcEzF/u3p+WRnBGgMw7UoNKZq3I=;
 b=P52S9XOKFnmzDeHu0Ryusw0KeM9aa8xqY4T1JevUHJQ1IhSWDEt/ht4XreQVfbcUxUCNcYTnkRvCAIShBAurFJB12r/vOkakOQI5c+LlFzCnJPUDpGER4um/PBju9WQXR5EaLBC5yEHmixpVRd4iMoxofmkmHfAeG0UQv1QqUjwXS7qGAv/5vaoR86RmgwqvjDl+EMH2vMlqD1fk69gaF1B6eAGKiSAvWVZ0SdJzNaf4GCvFRMCLlBWRsVu/9DFFZhGhGY2osQ+1tSjLGs9WThIKW3BzHvWM8hIfj1VbzAlNjZsQ4/SBKJ1y66L5mNrDkA/P6OBXUn0lCbRsaxVLPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UN5Jg4+hTpRVwG/OcEzF/u3p+WRnBGgMw7UoNKZq3I=;
 b=KAs9QT5jwv2C9BMrxxsydU+2RdAXM7xPryMV2RP+VUX/DX9CPeK68SHEDO4WnbshgG8G+2u9SZ1QXbRb52lx9+SEAfuSBMGaBNPXLrTqv1XkX3lQrnstn6kiNQfOYRQL6kL1HsrTWMG3uVpgFLydKw9JyTvCX5rRelE6YpII4Ig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA0PR12MB7001.namprd12.prod.outlook.com (2603:10b6:806:2c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.21; Fri, 31 Jan
 2025 22:53:12 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8398.017; Fri, 31 Jan 2025
 22:53:11 +0000
Message-ID: <9b338481-39c6-4102-9c4c-19793477242e@amd.com>
Date: Fri, 31 Jan 2025 16:53:07 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] iommu/amd: Enable Host SNP support after enabling
 IOMMU SNP support
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738274758.git.ashish.kalra@amd.com>
 <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
 <Z5wr5h03oLEA5WBn@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z5wr5h03oLEA5WBn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::7) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA0PR12MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dee2349-4a96-4ee2-9d1e-08dd424a09d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2s0RUhoUmc1Q3hTM0hWMlhyTkNsekREZk15SFFFWFg0bXA4emYxWmpDR05Y?=
 =?utf-8?B?elBOTWNuZDJpK3RPMWY1cGhUS2IzMFFKNElYS3VJN2hlUTZRVlhNUHVGRjl6?=
 =?utf-8?B?MTNCREpET3ZlSkZNUzc4akErOTl1bSthWkFtREtET0ZFZkEvUlpKVk5ibDhG?=
 =?utf-8?B?OFRBdVErNml4RFg4Z05Ub1k4UjNXc2drUkJSdlJwRm5Ec0tPTmwrL3hLR3p6?=
 =?utf-8?B?ZUptQVJJYmZzQ2VjZ3FWRjNaMjJMeVpqbXNYZG1ocXhkSkdIR3UzRmhmY0Iy?=
 =?utf-8?B?cEFueVFNcTN2dWRUV28rR1E5RStlcFJaT2tDejRnM2g4T0FhVjg2RVA5VUdi?=
 =?utf-8?B?bWVBeGhvTjJQTGNQbHllSHBobURsMHBvZEZpbVBXbWw1RWFuRFlwVXRGblFX?=
 =?utf-8?B?WWMyWmpYeG5lSzEwS2dsYVljZUNqY3ZGajJSNWlTOWs2b3dXdTdMOTBXNjhU?=
 =?utf-8?B?WVFUV08wSHBaZ1J3KzBiREV1OHliRFVXdGxCNXRxSUN4czFVUVNRSmdZWGZh?=
 =?utf-8?B?OW9HNEEwTitvaGU5KzNiRUdNdXduS3h1elo1THZReFFlR2tEb2J0L0laeVZW?=
 =?utf-8?B?OElNckxCdU1HYkVDcmhtUVBoZTBDNG5XUm5MOTNFVms2akRhZUY3OU5PeWZZ?=
 =?utf-8?B?RDRwMmhNZXdtOWREaFlTYWc1L0UxdUc4VXJHQ05FelRuWGJmS3RDYVlWempi?=
 =?utf-8?B?K3VEUXV5dGZRU1JVL3lDWmcxOU8yRWh3ZFQ1ZTE5SWZUUUg5VGlIMVFxckVa?=
 =?utf-8?B?NFpTNTVOaHplc3BwMm5INkRnOTc5OVBGK3pIaTB5SU9QNG1Za2Jod2xoZEEz?=
 =?utf-8?B?Vi82UFcrYkNoVStyVkpCUDZ1cTFINXFTV0xoZng2Y08xZDRFWE54YUo5d3F0?=
 =?utf-8?B?S0Y2R2hXZG5jcFFmZ0lHdGFEcGc0eGsvWkpjeFdUOFAvSWtDSkp1SW1sU20y?=
 =?utf-8?B?RHYrbTZKQzJITEUrbTMwR3pwUi9YaEJLUUNtbFNRS0FkVVhuSGs2dUVjOG5u?=
 =?utf-8?B?SmlYc0V2UFZiZElFajJhTFpYMHRWaGxkSHJtclJhNTBmYVZoOHJWZEVzczh6?=
 =?utf-8?B?U2gwMGZzR0RTRXRXUmt3SEd2dFZwUjdTNk5oS2t1MXhpa0FPV3BFbVJyUGI0?=
 =?utf-8?B?cStyUlZ1RklXY0ZGUmtPbmpFeWV1cFF6WVI5ZlE3Q1NyZDFuWjJQYzVpQXls?=
 =?utf-8?B?cXlodXdZR3RLeWFHcnVvTy9OR0piZysvVW1HWmx3UTFzV3pDc2JxL0ZQYWJw?=
 =?utf-8?B?b1B4SFo2ZG5mdnhwOWk3emV5UFpkYjdCdHVmZmpLUjRwaCs4OG5Da25EWnB5?=
 =?utf-8?B?SEE0SDh1MC9vcE4zR1ZqS3FCcVlNejJaZlhZaWJZMTFCT1VtM2hPMXRUVFAy?=
 =?utf-8?B?Z0JSaVFLa3RacXpWYk5KbFBuL1VPVFdQUVNQcTZQZ0o5UXQvYkN2azhQeUJZ?=
 =?utf-8?B?WGtFOFUybTJJYlBITTNOQ0d5M0VqYmhZZEdUUnNHMTZDSzBxYWd0d3ZhdjB5?=
 =?utf-8?B?dEtuY0JsRWI3YzY3QlpUYUdldU5IaGt3Ym9WczZOMXlmK0hRVGxhS3g4aElH?=
 =?utf-8?B?ODZxdGpVSlNpQTVmd0NmUnpleDVsKzBpNFV0WWdUZHBpU1ZLVjJwWTZnb2s2?=
 =?utf-8?B?VTB4YTV1R0dpWWo4RklhU3FPYUlPNHNjdFhGU1BmV2doa3Y2K0hXOTYvUEkr?=
 =?utf-8?B?MVV0OFgxdVcwczFMTDlwYWlPYndGQmVFWVF6UnYyQzBqdHNBT1lDU0VTTVJI?=
 =?utf-8?B?RXBiUHBYOUtEU2FtYVhDZEZ0VDlmTFFGd2hlSERsT0QvMHlVM2QwSDRQNGNa?=
 =?utf-8?B?MEMrSFNrQ2p3RmV6TEFHZTdtOGk2M0VQT3JKKzYxZ0tydGRJUGwwQ2MwMTJT?=
 =?utf-8?Q?DlNK5ZdPAnKxf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L010VnliTnNDYTcxZFVHUHNzTmNKcm4ycG1GUHo4QmI1TnRPclc4eVRaUzN0?=
 =?utf-8?B?Y0dJT3g2NDNoV3BBVVpwK2ZXS3VRVnNXdjNqUUNRTHZDWm5Jck5oN0QxVWhh?=
 =?utf-8?B?Z2RCaUZ4V3dpNlo3NVJXSzEzbU4yZVBYY2ZDUGxDTmJ1YUh2blZPdE01ZGFq?=
 =?utf-8?B?L25ORThtYm4rSDF3c0FuemhZazZNaXBWcjA3Wk5ENUorWVB2STRkUWFZWm5T?=
 =?utf-8?B?UFVaZlZTRjNTbWtTazZYVVFPbWNHYitTd3k4ZERGd3ZyZk9ldlR0cFBocXZp?=
 =?utf-8?B?cW5ocndVSzFOcTUwWDEvbmJ2YjdaWk9PWVBhQmRyb0d0dExEY0E1VTlJUHZN?=
 =?utf-8?B?V3dnNllvTjloUGdWazd2cmd4eFZDVkp0Y0ZNYVkrVWVDUDFabEg0MXVGbE9y?=
 =?utf-8?B?ZmlNVUhKVG8rQ2dXL3Q3OHZtQ1Mza2JpUDMzb0oxcXlXbVhTQlRRNEtiSmtv?=
 =?utf-8?B?aUNMNWNIcjUrb3pSQlBhWEdXdGNCRlZDM3BTTGhHeDFIcloxTzFZZ2ZybEtr?=
 =?utf-8?B?QkhmbVRZNU10bGFaWUtseTAxWjNWK2dkUGs5MVowSnRMUVJFSWprMk9kVzll?=
 =?utf-8?B?d1JUekVqd29JSGRNUGNCbS9SOXBUNGlMdE00RlZCN1BzbzVwKzlYN0NMcllp?=
 =?utf-8?B?dzNrQWE5TjVJaFhpQ1diblBLN2Y3MTIyNkhPbTJ3OXlqa3pGVkpRUjhCZi9N?=
 =?utf-8?B?YXhuR0pHaE1zMXMrTDVJWllMTDhuWG1BN1BQekY3ZFJuRm5tMmxsTVMzMTVZ?=
 =?utf-8?B?Yy80RUdJc3RTdTV6d3VwbW5YWGszY1c1QjhJT2ZvWG5taWYvYnRkNmpKcWFC?=
 =?utf-8?B?SU91Y3EyY01hdm1iMXZOWVdiTDJjd3NHWVgzTW9FZCtVTE9kN1MrbHNTUEhE?=
 =?utf-8?B?RHJLK0ZpN08yVDRreE5CYkIrUDJ3WTFYbmVjYndjS2s2RE5zWlR6c2hpTlYz?=
 =?utf-8?B?VmtqSHd5M2JhSVBjU1pRK2xuVVVIQjdGcko1QndQSDhjYTNqNTFTODBBeXhI?=
 =?utf-8?B?RzFBQ25PTmRTR21TR21obGgvdTBjTVVhU1J1VytEUDVxUzR5K0JLd0F0OHpG?=
 =?utf-8?B?T0VONFJLc3YyaStsRjlyMjFIZ3d4TzVaR0RUWWl5TUt1aTRLU0kwMy9HeFpp?=
 =?utf-8?B?QzYydjhTc0Jrek1za3FJZlJDSkJxWmYycVVncEgzWFdaODc5N2tGR0JGaVNm?=
 =?utf-8?B?RzRHaGorUDV4N2lySkFlekszcitaOC9PZENod3M1NEx1VzZGYmg0a1NzZk05?=
 =?utf-8?B?cjhYd3NTTkI5cGtkOGlXK25xZXNyUktoZFRpT1pSZkZHS1g0cVZSd0NuUjhi?=
 =?utf-8?B?T2FUNDk2UEk1VHhQYXNxNytUalVlbHJYOWQwMUJtQVRINHZVMzlmVnlZcGdk?=
 =?utf-8?B?LzRCMU9QbUMvd0FyTk12QzNXczEvVWtrUGhaNlZqd2FIbXRSaHlUdjlMQWtK?=
 =?utf-8?B?cS9kQWZRZkY5WWE0ZE1Mb2ZhTlRnc256WEdlejNyYTFZWXlHdlJSVTFZK3JJ?=
 =?utf-8?B?NW8wVTRFanhoekZZV1M1eUVxNkZXVnpoR1JGNUJtOWVQTHNpWVJNcDVTVW1D?=
 =?utf-8?B?a1J6b2JMZ293V2VOMVR4MTg2bUlQMExZWUNack1zdHBocUZxQnBHQ0xva0lM?=
 =?utf-8?B?VWZGVk9lQi9xT09vRHE0aUpGNlBHOWdERFQxTzBTRXRSMFM0dWxqR2hpNkZI?=
 =?utf-8?B?MzdTdkVtaHU1WGwwcnZzRm9PNStraWhOc1drcUtRNTlmTWFGcG1tSDR4dXNY?=
 =?utf-8?B?MmhQNEt0YXVveXI4Sm9SS2ZnMzZWT3Ryb2J1VWkxY1RkbFNkY25LWFhFVFZJ?=
 =?utf-8?B?RUZ5RGY4VnFQR3psaVVsR1dlZUdnTVRsbkRkWWNiUXo3QTdxWm5ObnVmVFlO?=
 =?utf-8?B?elFmZmRkbkxXaGd5Z3B2Y0hoWVJ2WHFoRG81bmpzUmtZWERqdXdPRm1MMjJT?=
 =?utf-8?B?REMvS0dPbzQ5bkJmbGZESldBSzhRVFpNTG41aEFvL1FVTDdDSTE3ZllWMldZ?=
 =?utf-8?B?UGtybjB6Q3Z0eTU4MTBSK0JZdXQ4Z2djcFVndkRvN3ZMQmRJbjIra3JTbC9N?=
 =?utf-8?B?SnRUYzZuWjdzVDdIREFlVlZUZmZDSnZ0QkRwajhITFlhZmIvNE9Hd1ROZXRJ?=
 =?utf-8?Q?aC1ab2RINzKaA4nVhV+SYpGUo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dee2349-4a96-4ee2-9d1e-08dd424a09d0
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 22:53:11.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87uOdHTzwye/zhftxeIEgUv+ujtiaXLBQZqk4J9bJkGIqXmIxbFr4RXrZ6XFheRGq90i0aix+OOHrnFH5bqWpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7001

Hello Sean,

On 1/30/2025 7:48 PM, Sean Christopherson wrote:
> On Fri, Jan 31, 2025, Ashish Kalra wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> This patch fixes the current SNP host enabling code and effectively SNP
>   ^^^^^^^^^^
>> ---
>>  drivers/iommu/amd/init.c | 18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index c5cd92edada0..ee887aa4442f 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
>>  	return true;
>>  }
>>  
>> -static void iommu_snp_enable(void)
>> +static __init void iommu_snp_enable(void)
> 
> If you're feeling nitpicky, adding "__init" could be done in a separate patch.
> 
>>  {
>>  #ifdef CONFIG_KVM_AMD_SEV
>>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> @@ -3219,6 +3219,11 @@ static void iommu_snp_enable(void)
>>  		goto disable_snp;
>>  	}
>>  
>> +	if (snp_rmptable_init()) {
>> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
>> +		goto disable_snp;
>> +	}
>> +
>>  	pr_info("IOMMU SNP support enabled.\n");
>>  	return;
>>  
>> @@ -3426,18 +3431,23 @@ void __init amd_iommu_detect(void)
>>  	int ret;
>>  
>>  	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
>> -		return;
>> +		goto disable_snp;
>>  
>>  	if (!amd_iommu_sme_check())
>> -		return;
>> +		goto disable_snp;
>>  
>>  	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
>>  	if (ret)
>> -		return;
>> +		goto disable_snp;
> 
> This handles initial failure, but it won't handle the case where amd_iommu_prepare()
> fails, as the iommu_go_to_state() call from amd_iommu_enable() will get
> short-circuited.  I don't see any pleasant options.  Maybe this?
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index c5cd92edada0..436e47f13f8f 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3318,6 +3318,8 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>                 ret = state_next();
>         }
>  
> +       if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +               cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
>         return ret;
>  }
>  

This is surely hackish but it will work.

Though to add here, as mentioned in the patch commit logs, IOMMU needs to enabled for SNP_INIT to succeed. 

If IOMMU initialization fails and iommu_snp_enable() is never reached, CC_ATTR_HOST_SEV_SNP will be
left set but that will cause PSP driver's SNP_INIT to fail with invalid configuration error as 
IOMMU SNP sanity checks in SNP firmware will fail (if IOMMUs are not enabled) as below: 

[    9.723114] ccp 0000:23:00.1: sev enabled
[    9.727602] ccp 0000:23:00.1: psp enabled
[    9.732527] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
[    9.739098] ccp 0000:a2:00.1: no command queues available
[    9.745167] ccp 0000:a2:00.1: psp enabled
[    9.805337] ccp 0000:23:00.1: SEV-SNP: failed to INIT rc -5, error 0x3
[    9.866426] ccp 0000:23:00.1: SEV API:1.53 build:5
...
and that will cause CC_ATTR_HOST_SEV_SNP flag to be cleared. 

> 
> Somewhat of a side topic, what happens if the RMP is fully configured and _then_
> IOMMU initialization fails?  I.e. if amd_iommu_init_pci() or amd_iommu_enable_interrupts()
> fails?  Is that even survivable?

Actually, SNP firmware initializes the IOMMU to perform RMP enforcement during SNP_INIT,
but as i mentioned above if IOMMU is not enabled then SNP_INIT will fail. 

Thanks,
Ashish

> 
>>  
>>  	amd_iommu_detected = true;
>>  	iommu_detected = 1;
>>  	x86_init.iommu.iommu_init = amd_iommu_init;
>> +	return;
>> +
>> +disable_snp:
>> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
>>  }
>>  
>>  /****************************************************************************
>> -- 
>> 2.34.1
>>


