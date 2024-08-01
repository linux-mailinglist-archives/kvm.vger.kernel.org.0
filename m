Return-Path: <kvm+bounces-22958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BEA944F7A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992121C23CF6
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F631B32B7;
	Thu,  1 Aug 2024 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kuKNKDmo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30421B011B;
	Thu,  1 Aug 2024 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722526777; cv=fail; b=O2HL4HkZu4W2TFTedIhY/PG1CTzp0B8MfhMxJ3brFRC89AcRdGVnp8s3L7vFYWTizjrUxpFwagWRCLg0CdibPvlH+9pekCab7NuA1zsmcB2TzOXzPPAIUd2GqLWhiwmon6/prCmqC1BrbsqfaVjb0KCAMRthtCTGfreQK3jmN90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722526777; c=relaxed/simple;
	bh=Q2wUK+MmDa5iVJu7puFX/BPC97ctnXtLCnXxLIjQDeY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oYRxt5PlmQ3PNbysdG656G+X/dn0ZrHriP7qU+jpR1knjUvyjz4CvvQcB8fp3DfqzibYksU/yStS+AJYJXpKHopnzcAhvRt+4yOEPpbKLm/+wXMcj8/pQ4l+pBsXN+g6OKnGLfHzG9AisaEPiq9cg30wjgPi0eYGJ7fL1AjZZFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kuKNKDmo; arc=fail smtp.client-ip=40.107.212.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fZf89SmJW5W0PadVGiDNKZ3cUmZxX5C1Y0eQPT4mhwvCzqK+gUvuMZnZDGrqqCWIdhbeFLpCOMix5vX3VK8PXXgPAa4wKGX/z4SJlz65VXnHLEFNI6WMSRq1Db1u3YSxAMfmFoITGrlZf9S1+1jWCUlsUoHKwz/Ib3nLio2UHm+LPTBZLIENd6RLkTd8Rwg9HLUEizFFB2sM00jgtjjJf2Gf8rnOUKZDR+0GMXVi6I0FtAg5NZCvG5ULe/KtZkv6x/8xnxWyVzrkivWPjUBPvjoNbja281bixB7gl5pfHnVwnDDvU8D9CY1vQbNhD8oLsXnwaeBZLJxXolHQG1A8ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABvkQ+0e98c3jXxUmK2fRyQWEDntdbNukH/S2ydWaJo=;
 b=AmNSFU1DyQDBCSKp3v37730wRO5vEPn/IqVDFWczryHLiShkr2spXE15RqTOBmApaHxYHMMpWkdso4fpOdVSSTNO6cJTXnlpVC22VkwgDpMrx1cQDF/dCFzrTWSvevQ09ZtqVhMTzGdt9uzbWGr7s7DxLXgcYYgn2enY7irHkK+Ish1dPgMBaoiND41jAiQ7nGF3TN6ytMCtjIxBbJ/0bjk6mf+tQ3x0WthTmh6HqyeJSiFZXbVd6MNLL9HF9oYvt/wENNJWvXrWJR3g+B8mZQJhK6F09PuD7UEQmhmwahfw7pRIUSELyW/+QA0jB1ZBpZhy6i/Vx/fh92XTsvQY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABvkQ+0e98c3jXxUmK2fRyQWEDntdbNukH/S2ydWaJo=;
 b=kuKNKDmoz6TWfQhQlHrPdz2tBVcAQMVv/876SOH9tYVS9iCeH/+T2Dz7XvfPEUqtd0dcJL9USJ65a7Tw15klP1wpKx37qSemlatzoI06S4D2dCKSVGAXq5N1ZpXc5VjtF5tH8FGeNwMhzk0qzGh3H7Hr4KRMYpe/+tcHx4qPCd/XPY3HQBm6OqKpMm9jcUExP3Bhe8qYp9wU2AmnLh4zAL74vwD6arr4zcdmx0/Z56iduYTWyETtme5Q2fxzw+AmZadEYkgWLVzKu0xwwJ+bNcwwjh0wsj5qfR42pSZTgyB9ckjNRBNJli+QAwWRL2tyMlEIFgRYY27/ToEtgUJtqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by SN7PR12MB7809.namprd12.prod.outlook.com (2603:10b6:806:34e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Thu, 1 Aug
 2024 15:39:31 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7828.016; Thu, 1 Aug 2024
 15:39:29 +0000
Message-ID: <9400fb28-47c2-4629-af17-df2a95f2d3d8@nvidia.com>
Date: Thu, 1 Aug 2024 18:39:16 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, virtualization@lists.linux.dev, axboe@kernel.dk,
 kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240801151137.14430-1-mgurtovoy@nvidia.com>
 <20240801111337-mutt-send-email-mst@kernel.org>
 <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
 <20240801112843-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20240801112843-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::17) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|SN7PR12MB7809:EE_
X-MS-Office365-Filtering-Correlation-Id: c2665b6c-d9f2-451e-4d3f-08dcb24021cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0tpN1p3VEl3dytyVDNUR0NMbXpjSUdQQWRJdGFtRkpLUWxjcUF2MTZZZEhM?=
 =?utf-8?B?S0dnUzRrTUtzMnJjZCtiOVpLbnY4RzM0QVRjMDB5ZUs1WG9aMHFyYjk4eEpz?=
 =?utf-8?B?S29WYlo3cU9kbE9WQjdOTmVuNExTdlRiTnlUMmN4WlYzRlh4cEJHTGMrQmFW?=
 =?utf-8?B?ZHZpbEpDZmU1cEljYXcrbklXNDc3VTZlc0MvM0Z5TjZVY2JrK0hrMlB2QXdF?=
 =?utf-8?B?Q2Y1L1F6Q3lBUWxPdUU4QVNlRDdpcWM4UjdjZUZEOC8rUUxteVhHVkpsUXFo?=
 =?utf-8?B?RDhlMWdWK0lnNEZieFcyTnoySkp2Tm85R1dVRTc4VUxKSDJHcjh5M1RVOEpF?=
 =?utf-8?B?dVRsTGg0UjNIbkV1elR5TW5GMHk0bGNJNGVpcEkxN09zczdwditMdTcyMW9U?=
 =?utf-8?B?ZWJXN05ocThmYlBuUER1STVzaTkweDVjTkhYdkhxb3JGSnJCS296cHlJeHV4?=
 =?utf-8?B?OEdOS0MrSnFRUDkxb2ZwYkczVEJ0d1V4S1RzQ0tBSjhGNExsREpWNllLNmZa?=
 =?utf-8?B?QnZYZmxSSkJ1UkQvN3ViNTZHWnVhOWdCV3JWQUhnZ2R0ajNuVVBaUWFRZmNi?=
 =?utf-8?B?VWNYVDBDWExPNFBkd2VnQ0l6ZklhSGtTRlZvMlJ4bllyczlEbFVLYWJiVS9i?=
 =?utf-8?B?WkZxZ0R1U2Y2Wi90WXZmODNKWFNURVpiWWlNc213OHZpMWVPTDB5SWs5MkE0?=
 =?utf-8?B?Szdpcm1wOHE5ZkVyb2ExTlBvcFJVQ0RhWFFEMitGb21WLzk4OS91UU9BTG9M?=
 =?utf-8?B?YzAyQ3JFSUhpR3FrdFlUU2lOaUZWaXduT1VCaUt1MTMwRzBRbFVSZXdzaTVp?=
 =?utf-8?B?Ym1EL0pWTDNsU2dSaVZqVWpDdXBGK3VySlg2SGxKc1ZwU0hFWGVSOWxZY3Jq?=
 =?utf-8?B?TWxsS0tDUHhMUkFoTWhaUkYrRFhqRTE5M1FOMFBnOVhURjltZThCYmIvdkl3?=
 =?utf-8?B?SFptSGc2Nmo1M0Z5bStNQzJybmtvaWpGTkZBYkFXZnpLSFpFZXRtdGw3b3RN?=
 =?utf-8?B?ZnN0cjVNY0wyTE9halVMbVFLbDA0Q3ZxTnJkM2tLcDZ0RjZPSFdMbmQwV0Jl?=
 =?utf-8?B?dGs0MThzTGNkSW5ETTUyTllvSG9FK0w3dGJLZnJkT0VHbUR3ODJsaEhtbkh1?=
 =?utf-8?B?NVFWREExcFluSVhlVXJycjZhcjVBM0xMMldDcW9peURaSGlxclZTWXorSjNW?=
 =?utf-8?B?N0M4NzZHc21BOU1ZMWZ4RnlDb2NmREJQOXIzUVRneUdzM3BkTXFvMHhzN3h2?=
 =?utf-8?B?N1VIL2p0aGE4NEE5UGN4NmZUN1B6Qk9LTXdWODMvc1lmTGR5TDlWL0xxN3Rp?=
 =?utf-8?B?TkZrL0M1dFVRc0VOSGl4ZHBqc3diRWVTZUs3Nk5taXo5NmtBS3RHSGxiVE5h?=
 =?utf-8?B?b2tRNWNTSEExdk0zU0I3MGtZdS9xN21VMllhbktpY1BuQUhUemQyZ3RvYlZO?=
 =?utf-8?B?REdFNnlPQnBKTkZRNUZXUmlRRDNSK1NUSXpHOFFnaGptTlJoNlBDRENZV2Rh?=
 =?utf-8?B?SnpUa2h2OEc4MjA1b1AyMzBnYkJ5cVJWNmtwTTBjZTFZUkZOVG1VdVR4Q3Ry?=
 =?utf-8?B?SUZrMC91aDczTlhDRzhwNjdwVWJJckkxSHpobTdjUzBIV0NHenltbnlXdDhC?=
 =?utf-8?B?WU40U25aR0xXd0pIejNoTWdoSE91bXFWK1I5NkgvWTU1YWZUU2dRaEdtd2ts?=
 =?utf-8?B?V1hqT24xTUNlOHQ3eTVBalVGcDlLTGMwUzdrc3lCZDdyajRpbU9HdmtPVUZP?=
 =?utf-8?B?UjZhZnNWQzMwOGdLd1RuNUhGbnhyR2h2b3ltZUE2R2NheUE3ZjhPRmJwbzls?=
 =?utf-8?B?OFUxTkczRjZQLzNTRElQdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTdNQXByR2g0Vmh6aUJaM21ONnRyUjlmSXdsalJOOXhtYzY0ZThEMFBsRHBN?=
 =?utf-8?B?bnNhRzEySGgvOThxcFc4RFBHcnpMUGdLeW5SbGh4K2JSc2VTakZPS1NwK0ZY?=
 =?utf-8?B?THhWMDZvRzgyU1p5S2Y1OVFBOG9yakFMWkd6T2pJR2lXK3hYYm1YUzUxM0l1?=
 =?utf-8?B?WklVSm1tbTNieXFzc0FaQk5MNnl5d3dqK1NyNEpsN29HeTdqb29rbUkzSnVo?=
 =?utf-8?B?Y01uRmJHN2dZM2tsa0FVbFRkVVFHZ1UybkF6dlRNMXJXQ3kzUGFLd1psc1hT?=
 =?utf-8?B?bWJqK2FUUXBsU1IvalgzMXczZWZhL0RaUmhSMHJiblk2OUF0Ty9CWU94MnhB?=
 =?utf-8?B?dnJhcGxRbjNSNFBHTnYrMU96UXg1dDA3TzZCRExPcjROSWpLSStWYzZJUVR1?=
 =?utf-8?B?aGVBc2djRElXODl4U1YzN2xpUWZyaWp0bVIrRTBLTDUwdEoyT21FL3czOXFh?=
 =?utf-8?B?U1kxOTVOQUExbU4zQm1PNnBrUDdld056SXJ2Ry8yNkNzeE1EK3llQk9aVHcx?=
 =?utf-8?B?ZzN6RlBFd0NkalQwa3VoU0dsajdWQmZxVWpLMFpnTFlMcklnZXFNaW1vNEJP?=
 =?utf-8?B?a0NkZG4wRXZFazdLR3dFQmFjT3NpSHJaclBuSWdQR2xham9JdUV0ZE9keGpk?=
 =?utf-8?B?UmdTRVQyRys5cnRMMzF3K1kwY1AvQUd4RFhaL3RENVhVRmgzYlpaYkJ0bWda?=
 =?utf-8?B?RndPMmJhc2hqLzRzZmRpOFkreGlOV25LWUZlaTNveSs2MmhwTTZmN3E0b0lv?=
 =?utf-8?B?VlQ3Tkl3L3hMMUNqemhsUWZWNlQ5Rms1MGNXOEpvYzAzN21PL1BkL0RFS3kz?=
 =?utf-8?B?bkJxR29aTEN2elF3RllUMzgvaHV1TG96ZlhIT2JyVXF3dG55dExuUDgrU1Mr?=
 =?utf-8?B?ZTBJU1Y3MGYxODcxdkU2a3pVQzdCL2RUQk80WXV2VFUzZXl2U0JHYWhmV1p1?=
 =?utf-8?B?UkR5eElkaHV6Z1psTVBlLzNLYXpIcGErY1dxbk1NUW1hcHZDcDVlTlhUa3VP?=
 =?utf-8?B?dkg4VGc4ZXJFV3VrQkZZUVU1T29CM2FYc2lqdVRSdzN4SUo2b3lIR0lGOVlW?=
 =?utf-8?B?SG1NZk9DUW00YXVNdEJaNVB5V3JiWldnTkhFdVFKMnlBbE5KdTFYamxqYmRM?=
 =?utf-8?B?b3dQSUxzS0R4QUF1cVppM2ROMnFZMHM4YWtPR3RkckI0dVZSNVRiNnB3bEV4?=
 =?utf-8?B?a0pLajVvRDZkek0vcVlUZmFld2ozVFFXeTJONjJpQ0VWdkNyalpCR0RkQXdM?=
 =?utf-8?B?NkdCemhsMTJzdE1RQVJUTjJzVjBKc0tVOGRVL2dMdTFIMkZRZ1ZoT3RzM2FU?=
 =?utf-8?B?dUFLUEphaEpiTFhWUE16ZGpqaWVhQ2Z5OVFEN3pLMUs4QU42dkU5YU9iOE1B?=
 =?utf-8?B?dUV5WDBjZ0xQWWtpUnZWaWd2WGJ0dGNtT2xycDhaOTFsMkVONWNkSldKNWJ3?=
 =?utf-8?B?ZXJ3N3BaUmhJSGpDMlBOSnFkczRLa1hacHcrcTJ2L2MrM2VncVhSc204Yyt5?=
 =?utf-8?B?Y005ekxJUFpmcGdwQ2VFOXRQT1FCU2dFZTFJMk9qVTZGOS9nLzVJMzByaDlj?=
 =?utf-8?B?WG1FZ2ROSGpUQ05WbGJxN2JSdXZ0Ymk5N1IxZzYrL1A5T2dxQUtObEtENm1O?=
 =?utf-8?B?NHF2cEx2dnM3MGtlTzF4Y3NYeko2b1hSVkx4ak5rV3VvVXpkWWViZUM4OTZv?=
 =?utf-8?B?WVVMckd3Q3g5SnAzL3FYL3p3WFFhTGRRYkNFUjR5ZFpoZit6Zm5zdm1yYWht?=
 =?utf-8?B?REd1b0JsSmxqTWNYMUxGNmtKbXR2d2FxajN0dExYc2NleW11LzgzNXlCeTZH?=
 =?utf-8?B?R0ZRcFhjUVVONmZ4aCtmS3JVY3kvUkhteEZ5dmUybmVrbEJDbEx2THZ4UnRT?=
 =?utf-8?B?TGhmUzlRNWZzZ04raysvQXpTUUNMeGtXaklDNm80UjlscllsRGxueG5rZXIw?=
 =?utf-8?B?OHV3NzBpN3FwTmZFRXBudVoxZFFtTVJWcDg4NExPRk9ZMmgxZ0dzTFFTSW40?=
 =?utf-8?B?VytzaVhUUDlCYUd6Z2hWUmVuVzJkeWhnVmxDOWFrL29uTG9lQk9KNlRTVjdp?=
 =?utf-8?B?eTVuY0RmSlEwTitpdU9EOXlmQWhud0w0S0FZRzkvUDRhL0N5bWJZL0cxTWJv?=
 =?utf-8?Q?+L90FBlg6wLUXbu3JFqP9PXub?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2665b6c-d9f2-451e-4d3f-08dcb24021cc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 15:39:29.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKyhhYKsHqzzLWN3wUWDyDrADZOnnUub12ZlPjvPNIg7jfdiWCr7NpQtlJ71M1qaGV3G5lctgmfQy56rko+n3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7809


On 01/08/2024 18:29, Michael S. Tsirkin wrote:
> On Thu, Aug 01, 2024 at 06:17:21PM +0300, Max Gurtovoy wrote:
>> On 01/08/2024 18:13, Michael S. Tsirkin wrote:
>>> On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
>>>> In this operation set the driver data of the hctx to point to the virtio
>>>> block queue. By doing so, we can use this reference in the and reduce
>>> in the .... ?
>> sorry for the type.
>>
>> should be :
>>
>> "By doing so, we can use this reference and reduce the number of operations in the fast path."
> ok. what kind of benefit do you see with this patch?

As mentioned. This is a micro optimization that reduce the number of 
instructions/dereferences in the fast path.


>
>>>> the number of operations in the fast path.
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>    drivers/block/virtio_blk.c | 42 ++++++++++++++++++++------------------
>>>>    1 file changed, 22 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>> index 2351f411fa46..35a7a586f6f5 100644
>>>> --- a/drivers/block/virtio_blk.c
>>>> +++ b/drivers/block/virtio_blk.c
>>>> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 status)
>>>>    	}
>>>>    }
>>>> -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
>>>> -{
>>>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>>> -
>>>> -	return vq;
>>>> -}
>>>> -
>>>>    static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
>>>>    {
>>>>    	struct scatterlist out_hdr, in_hdr, *sgs[3];
>>>> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>>>>    static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>>>    {
>>>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>>>    	bool kick;
>>>>    	spin_lock_irq(&vq->lock);
>>>> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>>    			   const struct blk_mq_queue_data *bd)
>>>>    {
>>>>    	struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>>>    	struct request *req = bd->rq;
>>>>    	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>>>    	unsigned long flags;
>>>> -	int qid = hctx->queue_num;
>>>>    	bool notify = false;
>>>>    	blk_status_t status;
>>>>    	int err;
>>>> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>>    	if (unlikely(status))
>>>>    		return status;
>>>> -	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>>>> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
>>>> +	spin_lock_irqsave(&vq->lock, flags);
>>>> +	err = virtblk_add_req(vq->vq, vbr);
>>>>    	if (err) {
>>>> -		virtqueue_kick(vblk->vqs[qid].vq);
>>>> +		virtqueue_kick(vq->vq);
>>>>    		/* Don't stop the queue if -ENOMEM: we may have failed to
>>>>    		 * bounce the buffer due to global resource outage.
>>>>    		 */
>>>>    		if (err == -ENOSPC)
>>>>    			blk_mq_stop_hw_queue(hctx);
>>>> -		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>>> +		spin_unlock_irqrestore(&vq->lock, flags);
>>>>    		virtblk_unmap_data(req, vbr);
>>>>    		return virtblk_fail_to_queue(req, err);
>>>>    	}
>>>> -	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>>>> +	if (bd->last && virtqueue_kick_prepare(vq->vq))
>>>>    		notify = true;
>>>> -	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>>> +	spin_unlock_irqrestore(&vq->lock, flags);
>>>>    	if (notify)
>>>> -		virtqueue_notify(vblk->vqs[qid].vq);
>>>> +		virtqueue_notify(vq->vq);
>>>>    	return BLK_STS_OK;
>>>>    }
>>>> @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request **rqlist)
>>>>    	struct request *requeue_list = NULL;
>>>>    	rq_list_for_each_safe(rqlist, req, next) {
>>>> -		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
>>>> +		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>>>>    		bool kick;
>>>>    		if (!virtblk_prep_rq_batch(req)) {
>>>> @@ -1164,6 +1155,16 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>>>>    	NULL,
>>>>    };
>>>> +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>>>> +		unsigned int hctx_idx)
>>>> +{
>>>> +	struct virtio_blk *vblk = data;
>>>> +	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
>>>> +
>>>> +	hctx->driver_data = vq;
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    static void virtblk_map_queues(struct blk_mq_tag_set *set)
>>>>    {
>>>>    	struct virtio_blk *vblk = set->driver_data;
>>>> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
>>>>    static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
>>>>    {
>>>>    	struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
>>>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>>>    	struct virtblk_req *vbr;
>>>>    	unsigned long flags;
>>>>    	unsigned int len;
>>>> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>>>    	.queue_rqs	= virtio_queue_rqs,
>>>>    	.commit_rqs	= virtio_commit_rqs,
>>>>    	.complete	= virtblk_request_done,
>>>> +	.init_hctx	= virtblk_init_hctx,
>>>>    	.map_queues	= virtblk_map_queues,
>>>>    	.poll		= virtblk_poll,
>>>>    };
>>>> -- 
>>>> 2.18.1

