Return-Path: <kvm+bounces-23158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C87049465D2
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40567B2203C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D4113A3FD;
	Fri,  2 Aug 2024 22:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oxUYpSUc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9AF1ABEB6;
	Fri,  2 Aug 2024 22:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722636469; cv=fail; b=pqLBkNH4/PUuz0IjqVzUKPcr0FQv9PkxAPHY1tIJQKRxhuU2T1X1T6R4cbVDAM5DKLBnT+bH1/NfaGgZeLcQ0t5oHj8WNLIpwz9/GsRGWHSFPAi8gDQm5ggiiGJ/GX+Q3ygDzekbdtsHcohPULwiJ/VWU2EagZm/cj2ZX3r7YDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722636469; c=relaxed/simple;
	bh=vAELnMOm2AeWjtF/eO9g2YlyQM/RmHN4IhnWmbvJvLE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gBjVZMJPQRGP1dL44AKJ4e2r+ANfGorZVvzpiQ07NhV4lDMpbijiY3kLIUn2oN65UvKPevAVVNrEHZntZI0KnlOwDoOB8Yd4KHexXGTUD8czmlijd2hFmdJYFRf0uKOcm550KHQb12WiDc+Du9KQZ8I8riDTzOgxnAwvEqXLEFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oxUYpSUc; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwzafAXeyprm6ZsW16EJtCjjQOeysACjoIL6X60CZ5CDvSKd4IuRSMUoD+I45CotM8ACM/k+CMu3tnRTEHc0Fk4E4YXpagmEKF4PnKlCdy55M0DWXU7fgIdUTtT0JQRpajdh5eLB0uUswvRekEi3krTRchLqgckUH7xwnzD207Wve4RSkUbrMnPQfC3MBXr0cYbfvd4Tz42pBypISzLaAuEVzGU/q0hOsQvSxVgXAXBsaCzTtsDyK3eQ4cTajgTZHHdFpFlf3FXwwf2+JyxP6adolyTbrVpkfTMKS3zWGAZ+8xoLPpsSqhMhJPm/uNJnwKXLr4zMYPUlMYPriy073Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAELnMOm2AeWjtF/eO9g2YlyQM/RmHN4IhnWmbvJvLE=;
 b=BIpEdjxId6SD5nBIGCiUmoFA8MVpxkvxYnAWnpOQBbH8GK9Kpbc4Z/WN9X3f/Yx+UGB31l2taiJPHIt986ba4MISEFFLYThtjFELKTYmGAH3kxFSJE9acVpvyAPqRtuWoEFxNNRBlQ69QE9FDMKMgU9vfh5qCpcLEgbm0KauzFX9sx2qM5Q/e1QaTvbPcaxZCe1EEgnmOQLLEEcWmKYl3i1d30rRAdW+oKNmh1FAY2tAURiK+SM35lzTCOfuKy0p7spVoox3JHUG0v5Z+QEGj1dSnZNw1H1mXXi4Tqlyu+/mta5CAv2U42yX5kum/xHip7dFKmygRg8WLp2xcEro2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAELnMOm2AeWjtF/eO9g2YlyQM/RmHN4IhnWmbvJvLE=;
 b=oxUYpSUcXuo19dQwIR3RvpQXzjovL6A3QccgmilUbpVmoGwDUyu9EjuwI3D2vGdot2jetsqHYd7Osfv1naUfGfO1hdiGavReTRvE8hqgSnebISBAPjlw9xx49UdAGoiCa6RnMJKa0C+X81mDCcn7MNaaGebzJIN0mRWoqS4C7ZlDhnehSWB675KWD1r2tPPpzc8BmzmOMYAZcsvYFdowIJ7yUvNWoQWJFO8Q3siHYVLTzML7AIVZ7M4+P1WUIlkw/vNrj0lnQD1zF46fMUpH/i3kL86bb+I67QfTRLr8h0e+Ae6iJnkYJLzg0A/rSvqJiddXP6Dy+RskCO/Qfy8eHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by SA1PR12MB7341.namprd12.prod.outlook.com (2603:10b6:806:2ba::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Fri, 2 Aug
 2024 22:07:45 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7828.024; Fri, 2 Aug 2024
 22:07:45 +0000
Message-ID: <a10e97ce-792a-410f-b68e-d00292987b3a@nvidia.com>
Date: Sat, 3 Aug 2024 01:07:27 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev,
 axboe@kernel.dk, kvm@vger.kernel.org, linux-block@vger.kernel.org,
 oren@nvidia.com
References: <20240801151137.14430-1-mgurtovoy@nvidia.com>
 <20240801111337-mutt-send-email-mst@kernel.org>
 <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
 <20240801112843-mutt-send-email-mst@kernel.org>
 <9400fb28-47c2-4629-af17-df2a95f2d3d8@nvidia.com>
 <20240801114205-mutt-send-email-mst@kernel.org>
 <6a8f0c72-ba77-42c3-8d85-6bb23a23f025@nvidia.com>
 <20240801175617.GA1133773@fedora.redhat.com>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20240801175617.GA1133773@fedora.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0054.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::18) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|SA1PR12MB7341:EE_
X-MS-Office365-Filtering-Correlation-Id: 17173dba-dc43-4587-3d18-08dcb33f894b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHZINGJRVVZtMWhsN2tEY3B4UGp1VjNYTEE4OFIzb1laNlFwU2Z2VU8rV0FY?=
 =?utf-8?B?S0YwMHVuVjQwZ1FrUjRSalBDdWgyNnlpQ1JxUENKeDlyN0thKzBSR3hYUjND?=
 =?utf-8?B?Q2JJRU5aV2N3ZkE1bDBXdDFwK05RR2IxL3dtMStncTUyZUZHbnpZWENuVlgy?=
 =?utf-8?B?S09memxrUXlIVXJLRUVHRHlXYysrcHNyczN2ME5GU2doK21xMGhXazdiSW52?=
 =?utf-8?B?Y3JYN3BvZ3lrVHpDT0ZocE02QnZOaGZSMDdKQUJnWHBacWg1czJrOE50UExt?=
 =?utf-8?B?OExPSWhMTlVkWGxYZUJobUxTWXdmcmlhdVgzZHlPV2loTFdhMHhER3d2Wnpm?=
 =?utf-8?B?VWgwMGN3emhDaC9DN2kzSmtDQ2I0R0xIWFZEWkhnR1JCeW1TekNTd0VuQ204?=
 =?utf-8?B?RzJ6NnJCdGZqaEVjdVZqd3NndEtpMXBRK1gzem9wMy9JSEFCbERzMWVXR1Fx?=
 =?utf-8?B?NGxDTWtVb25tRW1MODVHbENpMkxyNFh4b3ZJbmpIUmZraDZzTWZIZnN1Z3N6?=
 =?utf-8?B?T0cvNWY4emhTc1VOd3ZweW1uSUlFL0hZaWhjeFNEdm9jdXQvU0dhbDArbm5E?=
 =?utf-8?B?OGFzU3Bnalpld0NUblRkT1F1WGowWHJ0dE0za0Z2K01vWEdTMmFnbjV2Ympm?=
 =?utf-8?B?QWtxL2lBTlZqMTF0WDFUQVhtNDMxVmlqOUVKNnFtZTR2QTRYaGJ5M1JQWkor?=
 =?utf-8?B?N3ZNaEJmRm5mc0FmYWNkV3VrcnF4N0xKS0xCc1d4M0xXc3pyUzlhaGZIdDl6?=
 =?utf-8?B?TnJiQTgveHB5UXlLK1I2Zy9wak0yT3JFRGxzaG9heFdtSGNMbGIyQWdqYkxJ?=
 =?utf-8?B?UWRoa2lYb25qK0pvSWZVaXQwLzRwOVllNHRwR0JnemJUWjViLzRDVy9SQ3po?=
 =?utf-8?B?VlA5N0J2b1VRQ1pGU0NJQU1Bb2VlV1BsUWVKSUtTaklCTG1xVnNEMmpUOERW?=
 =?utf-8?B?b2JBVHB1S3RHMEFTRy9yOGFBb1J5THRIZVg3Sm9UT1pVK3pLbURIbWtSb3RW?=
 =?utf-8?B?WGtMZmNvREI1OVlwQ0taYUlQRlQ5THRNVzZxWi9tMENuaGZOaE1lTjVhRVBB?=
 =?utf-8?B?R2lDNXZvS3N1UlpTSldkNzh0dTZtM29IdFJwL00yQmJnWUNIMzdmamwzdEJZ?=
 =?utf-8?B?cHdmZCswVnJRNE8ydmd3UjRibUxlVmJDcFEyTUVnUzVhVkd5N2kxYTNvUFdX?=
 =?utf-8?B?bWlxc3hMV0R4cmhLR2wyVjZYUWxZeFplOEZWS05oTW5pcTE0WFkyVGxUQmNx?=
 =?utf-8?B?NmpzdzhDNG5uK1VoY2t6czJZcU11bVFHc2Y1VTRxUWJ2NTcxVGhkeWFuaG9X?=
 =?utf-8?B?bnRLc0FYL3BZSXRseDlCMVNKeXBXQncwVWZIeXRvdnp0TTF0L0NvZ29FUVdB?=
 =?utf-8?B?U2VLdGxLWDdVRFhyUys5aW5UY0xrL2g2eFZ3M1MyU25wQnB1OXNscjNMcVd1?=
 =?utf-8?B?UGZ2ZW41azBqMm5YN01vdld0TGprci9rOXBNdmFWUVV6Q3dYNGNsemF1QUdX?=
 =?utf-8?B?cDdsOTNhUXp3d2ljZWJ0OTZ0YXIyQk5uNWo2RG5JeFBSNTh0bWRqQVNKZWlo?=
 =?utf-8?B?VW9LSmFkRjRIYkRFMlNadThCMTVoRjcyVnRiOEo3eTR3UHJrY3JIYzVybWRD?=
 =?utf-8?B?V3JXMmVoRHo3L1hRaFY0d2FOalEzZXUydWNZTnhOb01Ya0xQR3pscHpnRFVP?=
 =?utf-8?B?Tndpdnh1SXJiWnhkaEFkUnhKUUdDcnIxWjlVSnZOa1hGTXdUem43Wmp4SGx0?=
 =?utf-8?B?ZTBvNlBNOWM3SXlaSUI5eDVFclh4MjVNWkt0Z2twcUh6US9OTWlnTG5mNit3?=
 =?utf-8?B?NmRhZ0U1Y2hkeWR0TlZiQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3Jva2IvSUpiTVdudW02MENPay9wYVExMEUvOEg3Mk1yTFlzc0ZCQVAzMnIw?=
 =?utf-8?B?TkNGNWJFMjd2b3gvZmlsOXF2ZWRPY0lCNytJbHZvQzhnWGNYUEtDWjZCcWRX?=
 =?utf-8?B?Tm9Zd3RwMzd2dy9TWmNvc3dBTHBoV0t0UFUzbVVHUEo2NzZOajNzZHZWMys5?=
 =?utf-8?B?aER2TVdWM3hUNkt0YkpNY3RlVkZ3emxwV3lBVTIvcm8zWW8zL21HanJLS01u?=
 =?utf-8?B?bVlGQjN0QnlROXd1cTFLMVJpb0cwc0RzNk0waXdyRFVOY3hKTXY5cmwxWUgy?=
 =?utf-8?B?TVZVZjNBdlJUMDYrRTZvcFphd0FvSmdCSEljZnVFQnZYSlRMSS9xZlBvOG5E?=
 =?utf-8?B?d3pkWE1EWGxkZ0xwcElwYzd5OXEwNHNjeWViTjFGQ1h4alBZcklSRFJ3SGhs?=
 =?utf-8?B?NmxWZ1NFajlyVXk2Qkg2OFNJTlE4eHN0MGcwM014T0lOcDlQWEF1a2RkOHY1?=
 =?utf-8?B?U0w3bTJyck11NWZOSWlqOUZNZElPT1p5bkJWOXJiNEExSHBzejhKNUR4WVFB?=
 =?utf-8?B?Mmh4MW5rcGxUVHlIbldHT0p2RVd0Tmp6Sys4T3ZzZkxrWUV6ZWxLY0ZOMEZj?=
 =?utf-8?B?M2Y1R1JyQjFTK1BDVGlmWi9DSDd4ZHh4dWVjMS9kaXFEaU44UHh4KzRDZFRJ?=
 =?utf-8?B?YmhkT0pZQWNjd3JLYS80cERwTjlZU0ZDaEwwNkNRdmgvaEJjZ3plZHZYNGtP?=
 =?utf-8?B?R0tRQVE5WkZVdWZsdzl2WHNOV01RRUx1RjZTQlQ4TytidEZrU255WWQrRytr?=
 =?utf-8?B?azZ2QXFmWTh3RVJ2M1BQdWpBejRFZGl3ajFUMlZuaENmcFBFZmVOanIrN0tK?=
 =?utf-8?B?RlBZL2N0WVVaWE10c0JOMjZGSlpIdjJvdDh3TVQvbnZKRERJT2xydFR1OWt3?=
 =?utf-8?B?WS91Y1R6SnpNU3UwVThoTEJneXZVeG5CZzV3YnErM1k0a1F3czVtMm16SU9n?=
 =?utf-8?B?Wk1ROU9kRnNWREI0cFJ5c21HbkZ2QUY5NkQyZ0s5a2xlaFl2SVY1RnkyeEE4?=
 =?utf-8?B?L0dDdkVMZS9QMTZMVUY2R29CeUd5QTU2cksyRUpGY3RUb0U4VlVpVHJ2Mk5m?=
 =?utf-8?B?SkZVZU9vTVU1NUF2OUVPYW10NmhEYlVxTW91TzFFOG1ab2xFNlRjNzRzczVm?=
 =?utf-8?B?OFplU1hzYUFaQjRaZnptQk9tbFVkL2p0Z0x1d3ppVkJCdTR0dHlDNkJ5UEZh?=
 =?utf-8?B?VEg1c0VJOHRocGFjbGk1VVVUMHM4VHA3c0xRbkxaWXNXcEJPZ0NZMEVmNXRB?=
 =?utf-8?B?Z05ydmZvM1RmRDlGME5OaFUyWHRqY0xIWG5SRjNrR1N5bzd6QkhydUZCVFhU?=
 =?utf-8?B?aUZDTXZ5SzVrWjVrSExqMFR4Y1NSeGxVV0tWM095NTRwOGk2M3JqWjhUeWlr?=
 =?utf-8?B?c21TZjdza1VONVUzYXZ5cTkwR0w1YlZ6ajE5WHgwbStUTkR4N0U1QXlnOGlT?=
 =?utf-8?B?QmkvMkp2M3VqTHFpWUdUTlQwNDYzdy9nUVlLTitIcEF0Q1p5YnBVS1pZbWJM?=
 =?utf-8?B?bXNycDIwWkpRdUV6RXFTaUhxbGlQTVRIREMrU3J6TTRFMC8zczFBNHdTeXpG?=
 =?utf-8?B?U3NRZ1R6alIvb3dkakhaOTVLTU9WNW9sdVNsOHlFdnpYejZUK1FOZjgrNktF?=
 =?utf-8?B?cTVlYUVxaUFXaDFRM2FicUttM05KSkRDdjZtenBMSjNwZmp2eUhITTlqdmVj?=
 =?utf-8?B?Q25xSHpRYVB5VFI1bzczd2V1S080UkZKK0VVT2N0VTd2UmI3R1RwdlVmQVla?=
 =?utf-8?B?WUp0YlJ6TFA2VURSNkh5KytxYkliRFhoVUExRGIwcTZqM0FPWFJaRjdxUi9k?=
 =?utf-8?B?SFZ5VnpUdkgxNTJXelRIMCszdHZQYWo4emRiRXdoazh1RXdBNUlPRFBybm9w?=
 =?utf-8?B?dnJ5WnUxWGE5ZERYV0IyUnpVczdVK2xEQmRKZjJTMm9Pc0FISUJrblNjanRv?=
 =?utf-8?B?T0g0T3ZIZ1laYnh4L21vb3JTN085ZWdWeWNZei9oWFR2OHlWeWx1b0hxYmZ3?=
 =?utf-8?B?cEQwQzJMbHhnNndGay9NK3FzQ0NzZzM1SlNRQjNNSU9SNWxPVFJCUDErMjZv?=
 =?utf-8?B?cWphaVlpenNEM0phWWN6M0Rjem5HcTB6ZUpoYzNuUjBidUdzY05PL0RnZjZN?=
 =?utf-8?Q?Lhi7UF8yaVyOCk/tUfSl0qKRN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17173dba-dc43-4587-3d18-08dcb33f894b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 22:07:44.9750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5X2muO3vrD4Z9H0ftVKaWz4scQMXdJl9k7TvyNM6baadyCdnlWLJMeUdMY3Y5A/7wt9nMJioGDcc0GZlPuabg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7341


On 01/08/2024 20:56, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2024 at 06:56:44PM +0300, Max Gurtovoy wrote:
>> On 01/08/2024 18:43, Michael S. Tsirkin wrote:
>>> On Thu, Aug 01, 2024 at 06:39:16PM +0300, Max Gurtovoy wrote:
>>>> On 01/08/2024 18:29, Michael S. Tsirkin wrote:
>>>>> On Thu, Aug 01, 2024 at 06:17:21PM +0300, Max Gurtovoy wrote:
>>>>>> On 01/08/2024 18:13, Michael S. Tsirkin wrote:
>>>>>>> On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
>>>>>>>> In this operation set the driver data of the hctx to point to the virtio
>>>>>>>> block queue. By doing so, we can use this reference in the and reduce
>>>>>>> in the .... ?
>>>>>> sorry for the type.
>>>>>>
>>>>>> should be :
>>>>>>
>>>>>> "By doing so, we can use this reference and reduce the number of operations in the fast path."
>>>>> ok. what kind of benefit do you see with this patch?
>>>> As mentioned. This is a micro optimization that reduce the number of
>>>> instructions/dereferences in the fast path.
>>> By how much? How random code tweaks affect object code is unpredictable.
>>> Pls show results of objdump to prove it does anything
>>> useful.
>> This is the way all modern block drivers such as NVMe PCI/RDMA/TCP use the
>> driver_data.
>>
>> These drivers don't have driver specific mechanisms to find the queue from
>> the hctx->queue->queuedata like vblk driver has for some unknown reason.
>>
>> It is pretty easy to review this patch and see its benefits, isn't it ?
>>
>> It is not expected to provide extreme perf improvement.
>>
>> It is introduced for aligning the driver to use common MQ mechanisms and
>> reduce dereferences.
>>
>> This is not "random code tweaks".
> If you cannot observe a performance change, then adjusting the commit
> description to explain this as a code cleanup to reduce dereferences and
> local variables, improving code readability seems fine to me. I think
> it's a nice cleanup when presented as such rather than a performance
> optimization.
>
> Stefan

Sure. Please check the bellow adjustment:

virtio_blk: implement init_hctx MQ operation

Set the driver data of the hardware context (hctx) to point directly to
the virtio block queue. This cleanup improves code readability, reduces
the number of dereferences, and minimizes local variables in the fast
path.



