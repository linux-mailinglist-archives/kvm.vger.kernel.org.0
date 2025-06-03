Return-Path: <kvm+bounces-48265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A472ACC115
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:17:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9144A18870B0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220B0268C69;
	Tue,  3 Jun 2025 07:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bV/gXm72"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6EB19066D
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748935043; cv=fail; b=m2aHITNW/QWnn1bQ8IEqcN4H8f/gLvw/sVc1C+Imm5eVK3GXrZ1Ym/xtqr+NxIfqZGGxxtGAzmMfUk+IXROH6Sg+YT92o4RsSoXyznX3NpzvmBJeysEABQEdQK6BV92rZ541uszEDH8VoWsX4Lx9Llc0qhnBU6fLPP59Lj77+ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748935043; c=relaxed/simple;
	bh=oOu5WqqXIDDjyfm+22nZAYZJfz9TAE4aspgQuybsgds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XX4Zr/Nkc32igLD5ng1YGwma2uxhzFQ+5SBlAusfSYnRbnArO+FcmKVicMsqM5M+nZMlWESMSjvwkwtJ9h6p8i531+PJ7NzJTMY85+b3c0hEUy1UEOmmumtjJto2w9k/ZXZn+ZiSmjO+wIPMx7T0BwZZIzUQKEuxodHItyFN6N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bV/gXm72; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqsFf87kAYg9q2Blc6ckluYG4NsHTr+LSGPLtvWSRX/TG4xhmvLIMM9l5UpVnjyINfdbzM4D7oqAdMcqtqKsWrtOUpGHOwQjIF7d7cSJAWLN9QgV1zeJnL2JAJ3hpr8OH0qy1X1XPOiQdMJ4N+H9tcc4ZMMtyfZC9XW0WaqAuEAnMm1aePeW/e/R1ExQNFJl3Encgrizcrxd5yQkRtRohy8n9ohg9whVjGK6CNrfCegvrsf+ECjOP3/Z3draBHLbQkHNE2IZ/ofSRq+e6/Ake5MRSdfSNq+fKbXvWz4L3kyiICFnBS+G7z0fBgivU/6OLYCXZ0b9STtpjwa2pfrFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mkK1KM0ZHueknDOO0aQVoJFHtUk/M8sT/L/rjzCqfI=;
 b=WMVFdDC4Ird/SW3OWED7ewu0WD0Wf470RNpDBVrj0pjDZiOYqDC09hj3BYFHOLZqGi1436lRVCiY74A2fFo149cDP3VHJbq/moGtP2AU5RwaOWNEHcpD81ihMEGyJI6tz4on7uPXJHTINpeUkn3+P8VMdiwt82rYszBgV4cQEnMhuY4NdaL1RNG4EkduOZFG04bqMsmb9AIdyZQ+uihMDwW5uA7fHh+sEkAttcylmb3MTK8TOzNU+SGR5y8nVFHVWMHPfGSbzB/CpeRoGydms6ZWrD6Wp9qrW2bVZoAiGqDa5CbEAAEAUmALll//ZSxnjdB1ZiF2PmV7GdVKW1tpgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mkK1KM0ZHueknDOO0aQVoJFHtUk/M8sT/L/rjzCqfI=;
 b=bV/gXm72YPqVbrczzBHH4BnZU3sR/zCEtgzL2w+6L8Gq9TA7ONewfxDvSoARzqMI4BKXZybcUknXUpPHtjL5hJcyiS99DVX5kOQ8wqXAp3PQvfENbitTtxJ0QnhscNxIxMjuSbpXetgW02ulQVQIn1Yb+m8OPJwvDecBITTXTwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by PH8PR12MB6865.namprd12.prod.outlook.com (2603:10b6:510:1c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Tue, 3 Jun
 2025 07:17:19 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 07:17:18 +0000
Message-ID: <219c32d8-4a5e-4a74-add0-aee56b8dc78b@amd.com>
Date: Tue, 3 Jun 2025 09:17:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Maloor, Kishen" <kishen.maloor@intel.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
 <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
 <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
 <c646012a-b993-4f37-ac31-d2447c7e9ab8@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <c646012a-b993-4f37-ac31-d2447c7e9ab8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0257.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::11) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|PH8PR12MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 72074f4c-9404-414b-ce9c-08dda26eacc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDU1cXdPeG5XcGpOTXFCSEZIbUJaNXVwaEdOSytPWVN4czlaTnRUV2ZpR0Q2?=
 =?utf-8?B?UHQ4WCtVSE5SbThsV25iajdDNXpKdEJhaU1WMUVOTUFLN1N5aW9IRms3eFBV?=
 =?utf-8?B?blRMVlZuME1CenczSHhSYU1FUEUyOEIrK1p6U2RBUEViUkdCS1JwMnhGdWhR?=
 =?utf-8?B?SDQ0b3UvS0VBWkx3RWdsTTlnelNqdjMrMEt0VnRqdk5aOFpJWHYzeHlJdDFR?=
 =?utf-8?B?SUZWSG5XVFVtcEdhYzQrcUFBWXBWdHJnYVl4T0ttSHVvakc2R3lvc002U3Y4?=
 =?utf-8?B?K0NmRENGNVdsT1dQYldqcEw0cUhnNGQrekZJS0RhMnlMRzBFVE9RY2hoTGVW?=
 =?utf-8?B?QVYweC9lQ1cxakVJZU4yWVE1OWpYWnNlOVZhOXZZZmV1ZEhlRW43V0gzTXU5?=
 =?utf-8?B?MkVKcUhjTU1rTWhqWjVKdmNmcjkxM0FHVUZMcUtLSHdtdjN4RFF2eUNrcXJk?=
 =?utf-8?B?N2pWSS9QNnJwdFhUWTQ3ckw4Vm56aTVBdzdtdFNtdDBtbmE3UTFranhhMU9I?=
 =?utf-8?B?d21TeFAyT2F0U3VQa0dGcWZtbDQ0dDFJYStLMjBWL2xWb3V3T0VKZVBKMnlC?=
 =?utf-8?B?MitqOEo3YmppNzlhSmh5YjA2cHFhV2FtTHE5d042TDl5YStGZmpzK2cxc05O?=
 =?utf-8?B?SzRaYkp4K2RkbEFQeUpnSm0yallvMUNGeXVsY3lqVlMzQjhnVUJwejI2ODhS?=
 =?utf-8?B?dEl3NG5kVEtUb3pVSkxMZU9YSkgydG5RZUk3MElSTFF2bnF2ZlkyU0FZcENT?=
 =?utf-8?B?aXppK3htMy9nSnA0dlE4cWh0TUdEeDh4M2phQzBPQmJ4SE4vQXdzd0lsTTN1?=
 =?utf-8?B?eUZ3dENRMVRaZUgwRlRHS2pOSWE3RnJQRDVLamQ3dGkxUVNJeFBHTmRXY2RC?=
 =?utf-8?B?b3p0WEdaaHZiRFliVE9OZjRPNmIvUyswUkZtNElCSDh3UTRQdjNPL25YeVdt?=
 =?utf-8?B?REd2WU5menZscUYxZTRmenh3eDdCSVkwc3pwTkR2YXZVTEFqaUl4aHBmclZV?=
 =?utf-8?B?N2tlNHZCZS9TMktmbGVTK3BySXBvOVdTajFFR29rMmREc1NNSUh1anlGb0xz?=
 =?utf-8?B?Z0ZMSThWUVdmTzZ3Y3MwSE1zRlZFTkZONEtWa0Rva2NHN1JlbTBZUENVRHJ2?=
 =?utf-8?B?Sm0ycjBCWDlSQ2s2WVdCdUZEaTQrbW0wTFFoTmxXcWpLNm1IaDNKZ3lkN1Rz?=
 =?utf-8?B?VUZ3cjB5OUc1eEs1YjlWOXk1d0JTcnMydTltaGpEQi9mTHJzczhYeXFMd3dO?=
 =?utf-8?B?c2JUTmYrZW5USkVQQ3c0MmRTVnRRMitPc2RwOTVJRHdsdHBRNzE5VWVnc2dV?=
 =?utf-8?B?MTZrTjRLNEVhNVBoL1Rudkduc0Z2d29DWW1jZG84UHdIdEtnbHBJN3I4NkZ5?=
 =?utf-8?B?eDBVOEJFdm9obTVzSHdwbUY1Q05zbkFrSHhLMyt0bWF5THY4UVpJYnYyYjlZ?=
 =?utf-8?B?cU1KL2huZmh6OHBoV3hMZGthaS9rMGplRHVtUHJNYlkyZlMyOGttdThHVEgx?=
 =?utf-8?B?MnVyQ3hqQzJNeVA1bVBEV2ZsdlhKUC9yVWFGcUtCdElyZ2RuV1lHd2NmcEhU?=
 =?utf-8?B?ei9pZllsS3NUaCtVUmk4Z2QzQVBLelBjSFlKTk9iNVc0bU43RXhPM1FXOFNn?=
 =?utf-8?B?bmVTdU40NHJJc2paVGVqU0h4anZxU0RhK25HOW9CdENrMmpyeHVJYSt6bC83?=
 =?utf-8?B?WFloclJVZzBHSFRGMjBqaHJ3K0E5OGNWSUNRVy9jbWtDUnlxK3RZeFdCSHZk?=
 =?utf-8?B?YjNlazdTWW1tTE9yeEtEYVVwUHo3VHpyYzhiWGk2RGhoZUV0SmtqcGZRKzNH?=
 =?utf-8?B?MHhjMXI2NzllVE56eCtLT0xBN0tvcklHU3RlMmxDSEl5YzVxV3pzZVZxdEQ0?=
 =?utf-8?B?cEhRRmxPaFR0aCtlaCtnTEoyVzdUUmFLblVtNVA0ajdmb3RCRWh1aGNzdGtW?=
 =?utf-8?Q?D1ou2xIZ9PM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGphUk8vNHVJajBHN0s3d09mejZLQ3ZXT0VTbkZHNnBZeHk4T1ZUU1dEWWZ1?=
 =?utf-8?B?Zms5OW1PNlgyeG51MjBIMU0yeU16NWJOYXFGd1NVRGZ6SnFrUDU5R21lNzcz?=
 =?utf-8?B?ajFydnJqd2tRTjBpV1E3V25ObE5mQnpLMjd6dnhBVzJDc0xxcEkwMnN0UUZ6?=
 =?utf-8?B?Zm9jeitmTDNpR0EyNllyTVRaTGg5d2s0ZWtFWE4xSGJLckFCTFl2K2VGSmtM?=
 =?utf-8?B?NzZad25jWTFWdlJ6TGUrQlkwcXpMcGtjY1prUVc2eVM1TXZvUnp5cDdDTTJz?=
 =?utf-8?B?MW1OVG1Yam5XakJJNTNXVi9ENW9EVC8rUVFzYUc4Q1Rlb2YwYS9LZDNMTlRJ?=
 =?utf-8?B?OC8vVktGeGVqUk5UbUNaellBczdkQUt2M3U5ZnR6YXBzWmlKVlBLSE9RWVlv?=
 =?utf-8?B?dWtTaTR0RkZVaWZxU2U2MTlOK2hmeTZ2VTNSOFVMSmJtazRTMDl1NG9VM0hQ?=
 =?utf-8?B?ZGVPNW4rVDh2UzV2bUpNMWtGRXBPVUhxeXM5eXhCNzU4d2lURjA2NlM2bjRU?=
 =?utf-8?B?VzNnNEZRc0hFMGxJUUNDTHdiZkU1WmFkQStiN0xtTjQ4MDRPUEFxdGsxcjZR?=
 =?utf-8?B?Vm1qb0kxbkRiYUFGZGtGWStPV3dxbVpHcHNKbklvSnZoQWJTbHo5NlRpcjRT?=
 =?utf-8?B?dGQ4czJPcmJOcDQ5d213NE9BYUNJaDZCMWg4NmswM2hrRzU0dG1ua2EybHVi?=
 =?utf-8?B?dG9oK1lwYWVhN1dHcFo1d1hCcG5TcTFERkN4NjJFSHNwanlSc1g1d1FrM0F1?=
 =?utf-8?B?OGh6SjR6QitDd1lqY2pSd3NQcG5obUVwWlhHQzBnNXRGQndrZDRVOEhmQUI4?=
 =?utf-8?B?SW5FV0htaVEwV3hNQkVJY0lqS29vRWhNajA1MHFBamtZTitzdFloZEQxKzRp?=
 =?utf-8?B?OGM2RENHb25DczI3ZnRKN0kySjJwRk11UTQvZisyTnJvN09xT1Z5SmVFeEZo?=
 =?utf-8?B?c2pTR2tkaTA0ckxkSXEwUWJTcmllTkRtQWt2UjZmT2MySmpjeVBYVnN0TlQy?=
 =?utf-8?B?QjVtd3lqaUgrM3FxbDEvZy9yNmFlMFZtZldtQy9EU2ZNVXRoTm5sS09DMTZv?=
 =?utf-8?B?K0hMSm5xT3hHV3BYYWxlOFJvOUZPVWFvTjFqY1pUMm9HMEtmU0MxVGsxcnMz?=
 =?utf-8?B?ZE9kRFFnSWpVODBxTmtpT0kxNURaSFdpMndYY0ZZcisrck9paVJqeC9uS0tL?=
 =?utf-8?B?ZFpuM3JnN292eXB1dlhJMHYxU0ROZmFpcHVzLzNnZWV3d2pwemt4UFZJYlc4?=
 =?utf-8?B?a3NjTHVwZmpsTHpONWI3T3NscFNGSnc5VzZFdVNnSndURHVEajJnTEpvMFpZ?=
 =?utf-8?B?Tm9YQitCWDZESXdJengvT2hjanJnVDdWNGlqZUphdUdQY2hITG9vSVJFRkdT?=
 =?utf-8?B?eU5PUEZsbVJoQTRIaUxtNXU4VEFldHFoKzJLa2pUekFIOUpHSHFKbElvK1FF?=
 =?utf-8?B?MkMyZzN0cWIvekM0enRjc1U1VUdHLzdVYW54MFoxZkMvWTBTeUVEZEVrRjhp?=
 =?utf-8?B?bVc5cFQ4NlBlNm5kbmpQTW5FL0VoT3pyeE05eWs4bFFsTWluTVBOUGxuTnM5?=
 =?utf-8?B?UGIyeWVLelloU0dsUmxsUnhOemQ2dGtCY2ZkcnZhUmFsbXo1bkhlOVBmeE1D?=
 =?utf-8?B?dGtXYnZHTTVhdWIxNTB5ZDRhMjQ1NVhtaVQyVHBWZmorMWJteHV4SUVpcFNU?=
 =?utf-8?B?KzEyWC9rY0x1eTFNSUFxckh2R2psTmc4Rnh2Umg1MHppaXVhcU1meHdMcjlv?=
 =?utf-8?B?Q2g3QXVuMWlsYnJKa0tMVU9RbFl1ZnBTRTBuejZJUUIrZWlvNjE1N0R6MXdT?=
 =?utf-8?B?eXFmcFNMYWVtaGJtVUtFa3k2MTVNMnc0S1E1WEZyQmR1NTg5dXhjeEd0V292?=
 =?utf-8?B?dHRWN2QvbWZHR3ZoZDB6STVoQmsrM210SXBZeWN0SG9TWmhWbllYOHhCUlRI?=
 =?utf-8?B?MURIRmlpTWZpYTBsK1c1eFJ1b3J1ajZYaWt0Y2J3STJ5bUpmTlJLcHJhNmMw?=
 =?utf-8?B?Wk5tS1N0TE80VEdUankxY1ZvRy81KzdNQkVnMGpicU1vMWIvVzNvOWZmK295?=
 =?utf-8?B?dTg3WE44ZUpxTzNpV0Y1Z3puL0RISVFkbXQ1c0ZXODc5RnhITjFybkZEUWdm?=
 =?utf-8?Q?sYn/Uh06QuIOwO+D5PN9hUisf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72074f4c-9404-414b-ce9c-08dda26eacc9
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 07:17:18.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5xQFH7Qu1NG1OKihCWo6g9BX6zIAQ/OSU+qRSdXLTYQzdSIRKXYt8l7l5q2bLI8cIi+JeLlgVn6o5Oz6m+Vhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6865

+CC Tony & Kishen

>>>> In this patch series we are only maintaining the bitmap for Ram discard/
>>>> populate state not for regular guest_memfd private/shared?
>>>
>>> As mentioned in changelog, "In the context of RamDiscardManager, shared
>>> state is analogous to populated, and private state is signified as
>>> discarded." To keep consistent with RamDiscardManager, I used the ram
>>> "populated/discareded" in variable and function names.
>>>
>>> Of course, we can use private/shared if we rename the RamDiscardManager
>>> to something like RamStateManager. But I haven't done it in this series.
>>> Because I think we can also view the bitmap as the state of shared
>>> memory (shared discard/shared populate) at present. The VFIO user only
>>> manipulate the dma map/unmap of shared mapping. (We need to consider how
>>> to extend the RDM framwork to manage the shared/private/discard states
>>> in the future when need to distinguish private and discard states.)
>>
>> As function name 'ram_block_attributes_state_change' is generic. Maybe
>> for now metadata update for only two states (shared/private) is enough
>> as it also aligns with discard vs populate states?
> 
> Yes, it is enough to treat the shared/private states align with
> populate/discard at present as the only user is VFIO shared mapping.
> 
>>
>> As we would also need the shared vs private state metadata for other
>> COCO operations e.g live migration, so wondering having this metadata
>> already there would be helpful. This also will keep the legacy interface
>> (prior to in-place conversion) consistent (As memory-attributes handling
>> is generic operation anyway).
> 
> When live migration in CoCo VMs is introduced, I think it needs to
> distinguish the difference between the states of discard and private. It
> cannot simply skip the discard parts any more and needs special handling
> for private parts. So still, we have to extend the interface if have to
> make it avaiable in advance.

You mean even the discard and private would need different handling and 
we cannot use a common per RAMBlock object metadata store? That was the 
reason I suggested in v4 to go with a base abstract class with common 
bits and implementation can be based on specific derived class. As that 
seemed cleaner and future extensible, otherwise we would need a major 
overhaul in future to this code.


Thanks,
Pankaj


