Return-Path: <kvm+bounces-49634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FD5ADB88B
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 20:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 796F27A18EB
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 18:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E8428934E;
	Mon, 16 Jun 2025 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yskhbF53"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97EC2BF016
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750097348; cv=fail; b=FqvvOBsaJtVXgcJUMXwnRgXM472qYXAT9rkC4h/jXIUksY6ZLnaoDNVaZLou6U1mzhFzcsi4lEoa2w7Su2z3876oQSexfTuRzvxKYA/t9ATR1rjTziTVlR7RGdc3YA+nbNAByfQyMQrRKWsK8wF/Q3u/wYPF76j4tea/TG6JHuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750097348; c=relaxed/simple;
	bh=fh9cbdmXpbxnXoK+HkMr/beOxXIil7TR5PcMfdjJwV8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WYVFYnmAf3RSsRhn3FrhIRuyV6AnPI11J8dSC3Cc7OF4PJCGVoHb8ldTvCoRGaFrvhbEldbif00Siyql2pxOeKAEvAhs0AHAFV/V+Bz3nHc7wruPpKqNh1fLV1nIbie6/qofe21UKgKLg2tQr/7DgT5HtE7P9/R7OupGixRCxAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yskhbF53; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RxAuspGLbXHy1bL4jBM+loVCfIf28/SP5k/WMLLPq1VQL4t9+y3VieeHIJh3k3DWxLjuG1OJ7Jy0QnCu6SI8hWqgx3IFVydZ/IVzlMHrwqdoSN0x1dpKVU+IkM5nUIBo3CD5tkLHzXuC/R9/xvSFomGnN8s2Nnm+poccFCrpyaHfxLpSCb3Co8eZvuCuIONrtaSYI5TGUeNsHL4ia5QWbkUG2B/ghMEniNBLn8jWv+1PHuhkqiNYPaIJUWcoqzjVT7mdP7HjpNxL+2LyceNQVmLxhets9ESPkOQ0FbZmPDus3UNmGw3S68cJvP3SyKT4kW9EhMeskxXLExv2CMswuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bnwv1ycXm4yzQ8Y55eFqHWlPvhYXxPwAuBaC/7Ts/zE=;
 b=rSUJnLZvr921ILKNG0PnhCeEv+FOvNsldbymMnG2sEpG5/iOVSiTy36+1Cyj6OL7p3v6HwYvKycW3A6GAel3c3NNpQ1SM1HdY2suEG3Pt4kjG0/fGD6DJrdpjwBTs00e2F+JQF8+ls+pbuA9YVN2uMPeXNscqcFyRqoePHJLouQ6uEEMOiKtoX6v/usRcdD9S8fpLq18mnOkMekr8vwyXlbir9F6zOYmh6cSBW/nIIPa7E6z0saA62u/FFov5eWExnj7q12qJCDdl0h6+6lIkiPuidQHPwgcAC57qIxNx7sbaBRxMW4T+L2p46lFjS1wJaHSsHkidhji4aI5vnmITg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bnwv1ycXm4yzQ8Y55eFqHWlPvhYXxPwAuBaC/7Ts/zE=;
 b=yskhbF53/veDBbKnwNVVjHARGeOC0U8pR3WgFKiSUORVuDU91XVatA0XodGPzOQMPwE7syFE6j2cRZs3X7te1FiMbWxTcinQgcUweVcux7HNIMisbJ/tGmV98uPhTowBECbjHJLlRqLqH4iezD+426tmKyb81vIdqi+xs9YYDiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 18:09:04 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%7]) with mapi id 15.20.8835.026; Mon, 16 Jun 2025
 18:09:04 +0000
Message-ID: <e7cdab23-de40-457d-aa69-f0e210206c16@amd.com>
Date: Mon, 16 Jun 2025 13:09:01 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v7 4/6] target/i386: Add couple of feature bits in
 CPUID_Fn80000021_EAX
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, davydov-max@yandex-team.ru
References: <cover.1746734284.git.babu.moger@amd.com>
 <a5f6283a59579b09ac345b3f21ecb3b3b2d92451.1746734284.git.babu.moger@amd.com>
 <aELfPr7snDmIirNk@gallifrey>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <aELfPr7snDmIirNk@gallifrey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P220CA0125.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::18) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb76350-bc24-4471-8d48-08ddad00e0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDlCa1k2dTRJeHd3a3JRSUtha3g2MGc0bmx6cVl2N0xtbFVrZXM3Unp6TXVo?=
 =?utf-8?B?b2FxRWhuQWlJZnBrSi9xVC9SNDJLZHFJbVNyQUoveDBxVnQzTzJ2SzFob05q?=
 =?utf-8?B?cHJ1b0F6MEZ2MGUvS0JGdXpKTmw4QWZ0cDNkakx1bThXRVBrR3orL0tONkxU?=
 =?utf-8?B?ekg0dzc3cW1FOWZzcW5rY1RTNVNWbFNCQTVTWm5lSzh5VFFETG9LcWcvanVR?=
 =?utf-8?B?OXZaQU82SFVvRlZzaTJnTzBVbnZ1dk53aEpHQ2h0cmc4ZjVibFpRWU5xeUNU?=
 =?utf-8?B?ZFQwbndwZGlHQWgyczYwNXpvN0RzWnZLVTVRWXgveGhtSTBsNG9mVk5xaEpt?=
 =?utf-8?B?TFJZY2o1Qm43TzNQNVBrQmJGa3QxaUlRZDVxdEwzeG1HdWRyWnRnUHpUcGlu?=
 =?utf-8?B?eDB5dml5RDZlZ0pEMUdWcUxXS2hUSzBaMnBTM2FqRnRMOHE5RVhFZGhNaDh6?=
 =?utf-8?B?MHdNeFZEcmtjN01jakN2bWNaLzFqa2FVaEZQa2N1ZURSbVErQkhzKzJDM2s2?=
 =?utf-8?B?RFRxRXR4ejc2NTdaRFUrU3F2dUxaOUNTRytpc1QwbnQ2bjdKMjJmT2lia2p2?=
 =?utf-8?B?WlpGWlBuQnNCMDNZdC8rSU5hY1ZJLzJ1TFVGUkI1K1dnYlRKN3A3ODN0aTBB?=
 =?utf-8?B?a0Z0eHhGdEhsbHovMUF6eU5ITHZKU1VxQTVDcnFXOWlTbkowckYzYzZ5ZjdU?=
 =?utf-8?B?a256a3FpN3VDa0xwVEFsRFI4cXphelFFZGRFaEpacUhGWjZBS3BWd1VUNUR2?=
 =?utf-8?B?L0ZDYWZGOFRyeitLdzR3MlFoSmFWbzhnVzE4M2VKc2JCclZORmdFaXk4ejls?=
 =?utf-8?B?OWtaNzV5Vm94L0hhZWRqVHUxREpUbS9YdVVwNzB4WFY0RG10VXFHSncxWDZx?=
 =?utf-8?B?ckFxdnBLdkVPd2ZkNElEVUpJOW1OS1VEUG9BMFZxdW1xMjhCbTEvbHdoNUJL?=
 =?utf-8?B?eXFmTW5yVTUvUXhTNXFjRUhIVUF0VzZwM1QvRC85ZFZGM1NncGNxUFdNY1dG?=
 =?utf-8?B?QU5uVTVJcG9xODBXSE9xL1RKRjE1eEFkcU5ZZmh2VFJ3NDdCdHRVYjRYQkZ5?=
 =?utf-8?B?WC9CT05venQyakhIMndBeHpBaThETTZVVXBIcHNQODdPK3lhR0lOOGUwQWhO?=
 =?utf-8?B?N3RHQ0VoSzlsZkE3Wml1N1RZZjNQWTZ0dVpDVGJJWmVrRXJGWlRNcEZaMDBz?=
 =?utf-8?B?SUhLTjZPZUl1SkhPV1pGbERmd3J3Y3B0M1ZjbG5aRlNTbXZ2azNRWjVkcTVi?=
 =?utf-8?B?VmtPaGdUNEc1MTFmN0U4bkZyR1Fmd3pBNnE1SEZIUnZhK0EvMTFpdkkwYlk5?=
 =?utf-8?B?NnBMNjJSMW5MYWsrWUx1NW05TUlPWS93QkkrWUxNQmxDTUVmUDZqMFNrSDhs?=
 =?utf-8?B?R0xPT0RHclBNckRjWXFsUk1CdERoeDBJSng1WDRldkxqQy9TSGY4SkY3amVN?=
 =?utf-8?B?RXU5czd3d0pKNVRpT0xtdUZ6R1d1cEFMZStIR2k3SUlSTHVtVGdrVTl3aURr?=
 =?utf-8?B?UEs3WU1zZUNidi93QWFHUjc2Vnl1a1NwZStVRG0yRk51RGtuL1A2Wkd1SnlK?=
 =?utf-8?B?UVF6WHViczF1ZDE0N2pjNWlYYjlBaUk2R1hLOFR5L2VObGZMcXU4NHBYM1l6?=
 =?utf-8?B?Z3NGcW5IaVZnQkU4ZGRhZ2dSVFpEcElTR2ZCZkk3cUJZanZGT0NWVGpkSG8v?=
 =?utf-8?B?SXhHUzJaZDFpT1NOWG9MUkF3K1Zmby9pN09mT1MzZmt6WXZDYXFJejljb2pY?=
 =?utf-8?B?RXB6OU1LSUVZOTNDTlc2RXZQUnVrREthREtNbktkbnJ5WEhwNmNoWElSTFJ6?=
 =?utf-8?B?QzdBb290ZFdES3RnQlZXSU51cVFJbW5xOVZUbEpYeGxSVlVaMWdNczkrcVJT?=
 =?utf-8?B?VTFpRFNhRGh4cTdHKzN1cWNtZnc5NmQ4bFQvd0NGNi9OcmF4YU5acmh4bmx0?=
 =?utf-8?Q?Wc0xpfSnNsw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bE1GWGxpcjBWZ3ZvbzZidTV6QWdoNHlBRGZnOEFOVWprdXd3dDNWaTQ3ZFUw?=
 =?utf-8?B?TTBSWWl3SEh6ZDJRSTRCWnh1SnpPZzFoeVhMbmNhdmpidU82d1pyN0Jib0Vn?=
 =?utf-8?B?QUp4aXhvUzBLTHFPS2FOWDI5Q1hrUDdIRXM3VWFmUkllYzh2QUtkU2w1TXZS?=
 =?utf-8?B?djd6VWhmb2VweU1XTXZ4QnQyWFBKbVY1NG1mNzRkdEU2alJvbFpSSmZOUVNB?=
 =?utf-8?B?ejNsbFNLS3dpN2dGL0tRRUd2M3A0K1I4SE5KRVBTdXFZY0FNdlhPSEVGTkI4?=
 =?utf-8?B?WnZoQitobmwvOGdTYVlVc05NTThCQVNnOHZ6WUx5V01RWDlneExKak10Y1da?=
 =?utf-8?B?YndXSUQ4YUZwTFhma0FkTnNqSzdkNlNmTEJPd2I4bVFIdy81OE9MdnFwM1JF?=
 =?utf-8?B?aVB5MDh1Y0dVK0V5VEIxbEthU0F5Zng3MjNFVG5SWUx3MlNHQ2V2S0ZZeEhn?=
 =?utf-8?B?WVE2aVZEa2gzSWVnWnQ0T0tETTNSRU5Cb3BWdDUxMXFpMmxqNTcrUG1aY20y?=
 =?utf-8?B?eHRLMUJXd044OTA3Qkx6dmpsUGxRQTdWVDhpa1VyYlNVL0xBeEtMLzU4Rk92?=
 =?utf-8?B?V1d1a0tvNzFIblNSVEFkdVJHV0dIenpsbFNxY0tMZStrRHZMUE5iL1VoQmdu?=
 =?utf-8?B?R2JJUXNWSFF2bjhCajFSTkJQWWhkNzFyUUIrTEFtaGszcU5IMkpzYTJob09L?=
 =?utf-8?B?N0NaQ1I0aUtqMnJRY015RCsrUzMzT1Z3T1hscEVMNWE1bnVDTzhsZ2hhWWtr?=
 =?utf-8?B?R0ZockJVKzJoc2RMbXBFNmVoYmVxbDNYeGtLSDNTYkZGOGdmZHhYSTlOdmZL?=
 =?utf-8?B?MG5HOTFCOUpmRjFBZG50Ni9ic0hxZXdIa1BsNDlrN3d5cFlFcW9xN3dRU3o0?=
 =?utf-8?B?OXFLMU5SOWJKOTZqRnRZZDlYU1BTMzNhODdZS2NJUlJWcEc5UGV5U1NSNnBw?=
 =?utf-8?B?dGxlWDV4dC9qZUVjQ3NKSld6aFhBaEJsL2RrMFpDemZoSmQyaWEvOVBUa1Ix?=
 =?utf-8?B?V0IyZTg0TE1zMHd3Ukk0UmRvdEl1TUJPS3IyZjltNU5tSkdtOTNOYWtGMXQ5?=
 =?utf-8?B?Wk1MdlQwU05BTGR2VU5JZy8rWTdUMEorekVKMFlyS1RHLy9ldGtFTTFUOTho?=
 =?utf-8?B?WDdyd0EwRW5Qb0dnVmVkN2ZwOG81d0NaMkxmMXZoYkx6VEZyLytUVjU3RUhN?=
 =?utf-8?B?YXBlMEoxK3dBMlRhNWRsa0tNWllOZ09ZeWxGcDIydmR6dGRYZkhCS0tURS9P?=
 =?utf-8?B?dXB3YzZURGlZdWVRWCtoYktQbDNxZkxZMVE1VWxtaHVWUDVxYlVDelk4NUgr?=
 =?utf-8?B?d3J1aDRsZkx3aG9Rd0dzbkJJbFd3QkdLRTcrMmNoM3NGNzJCTmlWenM3TFNx?=
 =?utf-8?B?S3RtS0x4WEFJRFR0ajM4Z3I3RW5Rak80STJrUHZ5RHFzTEdqMitqVDE4cHNv?=
 =?utf-8?B?b1pnOFN0OFdaQ08xREhoTnA4dndLcm9CRjgyUlhnUm9uMG9oOS9sUEQ4d29E?=
 =?utf-8?B?R0VNTFBBYS94OVFhOFdDbnFLazVLWm9YNmhPQXFEK3QxWFNxZmdWRDdwVmI4?=
 =?utf-8?B?TS90SzBsV0xuYk1pcWJqL2NaRTJJWG5tTnV1NFk5ZFRFUk84ZDdKcWdYa3Yv?=
 =?utf-8?B?ZjR6bTlSZXN1dS9aQndhaXd2L1c0RDY1UHFFZTdQVlQrTmo0SENmSWQ0dVZV?=
 =?utf-8?B?bVRIdnV6REo5U2dINXE1TzNLQ2NhTEhCTXhwd0pFbGc0bXJyTzBmRmRYVWtL?=
 =?utf-8?B?M0hobVRwR1RkRHZ0QVFIdW9FVVkrVVhHME81SnVOQldvNXp6OHNEZ1ZKN0Vn?=
 =?utf-8?B?dmhneXcvaTVTVDZuaHdPNUs0czNISzVxczIxZWlPK0Y4NHMvQ3hUMWNrdy9H?=
 =?utf-8?B?MHFZNkVUWGdZOFJoZXNEditKQ3NGenhHVGhFRzJTRjE1YjFBZy8vNUNNdHBh?=
 =?utf-8?B?ckR6NkZUTjlJSVhtcGtjNnNvMEFIRVZ1TWFjS1ZLeHpzS25wUkZmczN5eW5t?=
 =?utf-8?B?dFpGOUxMZHpIUHRrME9aR29udGhqVkoyVmFQUFovenluZkJPbFhHWWJyY3ZE?=
 =?utf-8?B?aHhVRjkxMmJ2bFhGcS9qcHUycW02emhmT0pOZXJSYWpmQVRSKzM2MWdGSEJQ?=
 =?utf-8?Q?SkOc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb76350-bc24-4471-8d48-08ddad00e0bc
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 18:09:04.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0TL0KeDvNrK1S7cNhlBgfbm0uHo44TnPL4ODEMF0EpMsNVEf73RAOzQe9dT34ej
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122

Hi Dave,

On 6/6/25 07:29, Dr. David Alan Gilbert wrote:
> * Babu Moger (babu.moger@amd.com) wrote:
>> Add CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
>> MSR_KERNEL_GS_BASE is non-serializing amd PREFETCHI that the indicates
>> support for IC prefetch.
>>
>> CPUID_Fn80000021_EAX
>> Bit    Feature description
>> 20     Indicates support for IC prefetch.
>> 1      FsGsKernelGsBaseNonSerializing.
> 
> I'm curious about this:
>   a) Is this new CPUs are non-serialising on that write?
>   b) If so, what happens if you run existing kernels/firmware on them?
>   c) Bonus migration question; what happens if you live migrate from a host
>      that claims to be serialising to one that has the extra non-serialising
>      flag but is disabled in the emulated CPU model.

Good question. After looking at the AMD64 Architecture Programmer’s Manual
again, these writes have always been non-serializing. Behavior has not
changed. We're just reporting it through CPUID now. This information
likely isn’t being used anywhere. Let me know if you have any questions.
-- 
Thanks
Babu Moger

