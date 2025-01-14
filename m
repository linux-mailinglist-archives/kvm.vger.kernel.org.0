Return-Path: <kvm+bounces-35446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B01DA112CF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3D1C3A01B0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 21:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3654620F985;
	Tue, 14 Jan 2025 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Durj0Xy+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48420C019;
	Tue, 14 Jan 2025 21:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736889279; cv=fail; b=ox/UBwakg6KOuaNNXwdsKQ2hC1A/PqgjKN0C4xwzN079Vmw5ljlziFnRzy7ecCeAtONxHy/1w+OLo9ZQyPyj9MpXyL+K0c20LQNp0GNGG1WQD3xNene3/UbfrE28kcj0b5YqUXeU1DeC00TATG8VHXh4CCzfq+BTrCp1/Zbg0vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736889279; c=relaxed/simple;
	bh=Rk+67qke222DXf//2pGHMvuA37BkijmNUBYZqKAlV+k=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u61s9+1yvnzsSB/C55InvBloEFa7ge4YhyOezvlDCCfidoqlaoQfsB3T4ZTNIjuF5qYLY/PAaWKF48q9mTzKsVtMnKIzraXXJlV4KRDsKAZRoFsdvJpwrSO9QULZEiyh2ejI2UJJBl3TXmIHFUiH6J15d1kFNkNMa++hQPsoySA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Durj0Xy+; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aRXgucDuy79lqOvuYt9dsa5WnhbFRpSfwRO8SQrsPLsta0T+hMBefyaupOjgUMcgTyBIPaUjO7CUTki5cnZYkhELyCgI1OATsO3mwco1Ixdc9lTYsQugUzzY0aqcJv9Y09OyQzRKrS9MSSgro/bnwM8kMl9jlSsxECz/ky4UlUPOGtfCDECUq7Sb2y06qumPj2pHHz465e2M33/qMxnawvNLwThe3l4T7oMcXGXivuDWvinqcpkSfu2WoF6eclMiZ4Ads/QEuptplURRV2LGs3fPUx/E5q91brGKVeUeBKScT3/n3IdIGboj3dVJktT5eITIAHf9wrR17dtFS9RCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/Z9mBkeaoPhxuQYgPb00gJ+tENPlHGdhbCwLd8napg=;
 b=Vsjrf/Q6SSqJ6/cMCzjIjXS6HiA3qFADPdQ1almlQWJl0r9w6T08138IYXYg0O9sbc/aZ8BjCmwRu0nLGRD7EFyoOqDw/h07G8eEgvm7NX7ceAcDiuf4qqp+r91t2WvpDK+MOzuK21tqi/ZVK/T7E2McwhG1pV4XeyV6ElyFMOZyI7TehpLcvl4pSW6i5sYfpRSfD2m7EXe6gWtFFCjhxbtussu5QZ7oAcG2+HBcgfhZHt5KamsiiboJTjjUEA9ReKKYyEk2QnYmV/ZT6n1ldsjFW/U7IUpKW+PJCIVXpZ7JZK3VIUtl9lgnoJzKyKviTFJ3zn4u4d8Av2VNhOEmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/Z9mBkeaoPhxuQYgPb00gJ+tENPlHGdhbCwLd8napg=;
 b=Durj0Xy+R+wOB2bfwgQnKJ5zvKPuCBdq9vIbHWIddxL9K+XlFVAy1IWFcdnUe8kx6Cdz6YUa2eEehwZabGpYoMIVknzH/+xpPJt4OdUDSQVUFN0oo6UNvkr/EYs2V2Wq/ebFVJD9B8IvqRwUhQTvmayOEcfHR/1FQu8qRNq7pUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN6PR12MB8567.namprd12.prod.outlook.com (2603:10b6:208:478::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 21:14:35 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8335.015; Tue, 14 Jan 2025
 21:14:35 +0000
Message-ID: <f02fee7d-27e8-4ddc-b349-6d0f8c7919fa@amd.com>
Date: Tue, 14 Jan 2025 15:14:31 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
 <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com>
 <5e3c0fe3-b220-404f-8ae0-f0790a7098b6@amd.com>
Content-Language: en-US
In-Reply-To: <5e3c0fe3-b220-404f-8ae0-f0790a7098b6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN6PR12MB8567:EE_
X-MS-Office365-Filtering-Correlation-Id: 591a24b0-4b22-4c12-22ba-08dd34e07217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHhnSVgrSWd6RTUrTVBMOFpwTml5UjlhVEpnMjU4MkFFMC9zRnJtanVpVldj?=
 =?utf-8?B?eGV3V2FxbVZiT3hKTkpOeTdhSXczcTUvWituenVoVFp3ZFBpWHMxZzVib2lN?=
 =?utf-8?B?UlZNc2JDY29LSDBjMTZkeVNnMk1rMndhR1Z6SG5kV25KaWZqWnc4enJwQnRl?=
 =?utf-8?B?RHJYenJ5T045SkhkMXpVWkpra2lKRndad0pJbjU3U3hVb2dyK3lIbTRkSUZj?=
 =?utf-8?B?WGljY2dZMVRVemhYd2VjWjZYNXdSZ0R5SHAxbDhiemY4eGhYb01FaFphaXBx?=
 =?utf-8?B?MkorQkZtV1plNkpWbHlPaWZvVlJrNk9GcEl1SFdhL0pvYmd1TEdyeFNpdjVG?=
 =?utf-8?B?Z3JDT3B4c0VCcHdhTHJ1L3NkdEdVeDdlK0ttT3g0Tm9tdUMzSi9DUU9Ua2Zj?=
 =?utf-8?B?ZXprMVJhSURUMjZjRlpkTS9ieXBsMDRJWnhkZGtWTXZrVGxQWmV2VFhpOG5i?=
 =?utf-8?B?S3N2QXpPM1FoblpPWHgvckRsVXJ0VWhBNXhXRGF4VS9zK0pYKzRKNGxML1VR?=
 =?utf-8?B?ZTNSdkJuaVAxV2IxVmVWM0ZDbFAzcHdpcm5RS2VkMXNwZU9EMWtaVTJMdmd3?=
 =?utf-8?B?eHM5eFI4Ym9XcFk2L3VZOWs3Z3IrVFh2K3c1L0dCQ3haTnI0Z3hSbVBtV0w3?=
 =?utf-8?B?NXc4WkZQQURsMmcwem5maTlJd2s0bGhWVjFNRzlTdEUvUkp2R21CNTkxcGh4?=
 =?utf-8?B?MVJ6U2dQWVVwenBzME4xbDVIWjFYYWVlUC9lYWVzcE8zK3dISndRdzYzLzlR?=
 =?utf-8?B?MFlLK2ErNUxDWlcyaWc1NmxNbHRZdm00UnNqdGhBVS9RSWhENGhZN3BQblUv?=
 =?utf-8?B?ZjUxRWVCeno3WmpjTnEwU3RESGg3b0k5WnpQRkRxTlVpTjlKaDdGMktUcmM5?=
 =?utf-8?B?d2FqRG5LaVlWMEY2eGF4elIrUW44SWpyVUxwMUE1L21OeThOL3ZGK000M3hy?=
 =?utf-8?B?dXdENUp2c1dkTzV5TE5VQ2xObEFrUDkyNDJMdXV6cWFoOHp5aU9WL296em1X?=
 =?utf-8?B?cW9NOFZzbmdST25yMTNQcEphZDdidTRtdUI0Q0N4anNBTXZaanJCZWlyVTJm?=
 =?utf-8?B?Y21xM2VXaVgzeWhtRVdIYWhHT0RicGhTTTIxRjZJaU90eGoyaEY2bXlzUldD?=
 =?utf-8?B?dHhnYlpMWng2Q2VkN3FWUk0rNW5MU242bFhDS0k2b2Njak9XVStlWTI1UE9s?=
 =?utf-8?B?WmsvLzhSbVBCVFZhNnBjQXU0NFlqTnJiY1lkU05GS0I4N2xIa0FWSEpCVno3?=
 =?utf-8?B?WVlST2k1T1NtMEtmV041cUlpYXo0ZVB3ZklVdHk1bnM0dmxIdmpXYTRpSVZw?=
 =?utf-8?B?eE8vdGsyN0NoeXh4SjBTTi9kcHdXTS9BUmlGbkJTUGdWTlZjYlVRRXJZNDgy?=
 =?utf-8?B?U3V0SW5DNHBNeXZxU1ZhcVZPTDlpM0hEYm5iRVgzckc3T0tzQ09kbmNoSXpn?=
 =?utf-8?B?Tm8rRUFQVlFEcnYyWEV3eUVjdUZ4Z1hKejFpMVlrd1pDY3dDem9DK21UK21M?=
 =?utf-8?B?dTZhN1hVczkrdnZmRXVIVjVPeVV5UUlRVDFXMnhWMWY4L0IvZVIrMjJNVUdo?=
 =?utf-8?B?RmhEWExNQUFIU2tNdHVDUHE2S3RiUmdpbEZXRnN4QS9hM013cDhQYnZDWS93?=
 =?utf-8?B?dmgwR3BRdGFoTDJ1N3JXaXZUSTc1Ulp4Q2h6MFc0Q3JRYk5pR2ovaFljcHNH?=
 =?utf-8?B?MEh6TzdKVWM0aVh5WEtFY21OR3pUbGlicDB2WG11dmlwUzdLZE5TQ1JCNzB5?=
 =?utf-8?B?Z2JZSGZEUDFMbDZsU0RrVkYvd1JoUms5R3A2YmNlY2ZZS0tVZ1lzTnQzaURh?=
 =?utf-8?B?NU4xWnNrQ3pVY0JBTFZCSzdpb2c1QmdCbjBHc2ZNMlFVSGpDRDlUYnBNMzRW?=
 =?utf-8?Q?Pk6GZXrDAV72A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUlyMmY1S1NzZnBpR2tXZkJUUUFkYUx6eHZtaHZNSldCZHp4T24ySW05dk84?=
 =?utf-8?B?UjNzS2VpY1V2cE9lYXZVVWFiL2tRaFBqZmRnY29JUiszbFFnb29WNnlFR0ZQ?=
 =?utf-8?B?Z2RhYmg2d1pmTFM1WTJiWXJKd3JaV3I5ZE9KNWxjZXpraEVOcUVjbmVPTDEx?=
 =?utf-8?B?Q1pvdEhBNk9xNnlVVmpVVWliMlFxa0k3b3dVYW5YZ3FKWnQvTHR5emNlSW9q?=
 =?utf-8?B?bG5nNlRicllsVCtKbEU5T0xpVHI4Mmg4Q012U2t1aGlIZ3hTVU84SWwzNmdO?=
 =?utf-8?B?L3ZsdGdRV0ViQ1BBQ25SSk11aXdrZCt4M1JweG0wNmF2dEFsVzhKeVd1SUM5?=
 =?utf-8?B?ckNaN2tUQ2JzVGV4MG11Ly9nNkpYOXBiQThGTCsyQm1kYnRYUTJmQjg0T2Uz?=
 =?utf-8?B?NFBlSWNqbjk5dFlqR3JmREN2dGZ1NDVrcTB5QkhsWUF3Z29BN2JIck1JWTda?=
 =?utf-8?B?d2pRYjlNajJLcFROWlE0NkpWdkoyTVRmc2UwWndRZjBQQU5TZFdPSm41ZnNY?=
 =?utf-8?B?dk8wUDBqaXFOMEZVY2hKT2tWcU1EejNtZEcxbXpvcGk2dFluR29DVXNjMGRU?=
 =?utf-8?B?akpGVjY1bEJHKzlFREx1bEhwbUF6SmpYMFZqK3Z5Y1JXOW5qV09KdngzQUVa?=
 =?utf-8?B?Z3U2UThENUgzQ1lManRKNEhlRUgrUkl0ZnNJaFpXbjFJeTMvSU1NSC9BQm9V?=
 =?utf-8?B?VDJVMFQvdXQxa1NwVVRlRFpURmJYcitMRFd0cWIvVjBoTXJJT1l0V0lOb2ph?=
 =?utf-8?B?bG1nd01oZ21nZnYxUTlSWWNSeW5YVkcvZUI5R2dpNERUTlFkUEpDaUpOQWpE?=
 =?utf-8?B?SjFXazlTZkdjUU9WUTNVc0FuNWFNRXBuL3dsd2JrUkovdUtydmZQVi9JZ2ZW?=
 =?utf-8?B?YTZQV1ZwNlk2aFZVNVZMSFZVUExRbHp3MmRUV1pCblVUdTh0RFRWVU9JaERs?=
 =?utf-8?B?WStNL2h1cGFuOGlJT0krUldGb09LSDBrWCtjMTlmd1BHdTJDdWRTKzd5cVNw?=
 =?utf-8?B?RzdrQmIwMG00SFJPbUM0RUhlOCtHMER4ZVNVK2o4Ym9QYnRZeS9XWFpPa1Fw?=
 =?utf-8?B?a3oyUHFlS3E1Y05nOHh0c2RSWkgrUS9CZkVuaUk5Tk1NbFlzMFlyblBlc2d0?=
 =?utf-8?B?eXlTdVdTZFFDa1EzeFc4VmdWY2lPcVpZQ096R25ucm9zd1J3R1ppWFMwVEk2?=
 =?utf-8?B?aVdraXVpMU5qek11N05XZUlycHF2d0tIUVZQVE5rTVcwcCsrakFzVjNQOFRO?=
 =?utf-8?B?d3A1bFVxMmc5Yks0Y29uZEN1emJCdC9WcTdyU29HT2NmaU9rOFpNdThrWDBN?=
 =?utf-8?B?bC9EUThqU2JxLy9zOTJ4bkhEUXgvUlo2bklsbVJIWGVCTWJTUUZtS0gvM2Rz?=
 =?utf-8?B?WUYzUXJ1eVJvUzhJUm94VXorSVZicldHTUErWTN6YnY4OWdGY2trMzE4ek9K?=
 =?utf-8?B?RFRWTDd4K0Q0SE5sb2dhMkN3Q0g3akJKZk5yTW1DclBQUDJhNCtweHNWOG5p?=
 =?utf-8?B?Y2VQN3ZMUDhGOXJNWFFRdWVVcXV5cDJUbUxyMEwyZ08zbjk0ekxXTXllQmx0?=
 =?utf-8?B?alVEUkV2Yk0zd1RaRjgxU1pGZUdMVDI4ZHFkc0JLRk8zVFlQV0ZEVUx1WjJh?=
 =?utf-8?B?aGU5dXp1dzNOaURuK1p5QTNINHhRZVBmY1NiWHZmTCtLbTZFQXdTaWpwTzRP?=
 =?utf-8?B?MkZqOUwyTnJMd1ZYM2o2SmJtcVRTaTkveEZidmF4b2ZIL3V5WGkwdjVvNnEv?=
 =?utf-8?B?Qi92dnJ2NGFGd3hNbmNuTzN3R3ZKaWZYcnVaMk9WcTNFWHB6bGlqc1FMTWZF?=
 =?utf-8?B?S2FvRmhKU0NDR0N5RkVKd3Zjb3BhU21FRDY0a2I2OEFrZnI0RnpXVDdRZUx5?=
 =?utf-8?B?SFFUTnVIdWJpTEpUUmlKekpIa3JLakRDUUZYNVNGcXJxWGJFemp2amo2THlh?=
 =?utf-8?B?Vm1QeUN6dDVPemZ0M2hkRDFQanVxbW1KZU9MT2dVVTZLeXB3VDViVFZoTlp0?=
 =?utf-8?B?ZVJiU0F2R29VL1FDdkU4R2cyMGxkeStlNmpuT0YweGxwSjdzbGRrQmhKT2JR?=
 =?utf-8?B?NGlYRkcxb2NVRUtqS3pmazYzV0hkLzYzMnpnTmh3Q1hocFFKWnRIK2NZSERx?=
 =?utf-8?Q?8kOvJsGWpN8w/gdGOiTbHhl8e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591a24b0-4b22-4c12-22ba-08dd34e07217
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 21:14:35.0097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeSB5Evn+2G81Yp0MxgVAcoKv47zG8NahG+Un0R7NLu5pQyp2RhN7c4vhkS/u2SWNph74TAVYeQMwG1Se4FJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8567


On 1/13/2025 9:03 AM, Kalra, Ashish wrote:
> 
> On 1/10/2025 6:40 PM, Sean Christopherson wrote:
>> On Fri, Jan 10, 2025, Ashish Kalra wrote:
>>> It looks like i have hit a serious blocker issue with this approach of moving
>>> SEV/SNP initialization to KVM module load time. 
>>>
>>> While testing with kvm_amd and PSP driver built-in, it looks like kvm_amd
>>> driver is being loaded/initialized before PSP driver is loaded, and that
>>> causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fail:
>>>
>>> [   10.717898] kvm_amd: TSC scaling supported
>>> [   10.722470] kvm_amd: Nested Virtualization enabled
>>> [   10.727816] kvm_amd: Nested Paging enabled
>>> [   10.732388] kvm_amd: LBR virtualization supported
>>> [   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
>>> [   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
>>> [   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
>>> [   10.753768] PSP driver not init                        <<<---- sev_platform_init() returns failure as PSP driver is still not initialized
>>> [   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
>>> [   10.763124] kvm_amd: Virtual GIF supported
>>> ...
>>> ...
>>> [   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
>>> [   12.521691] ccp 0000:23:00.1: no command queues available
>>> [   12.527991] ccp 0000:23:00.1: sev enabled
>>> [   12.532592] ccp 0000:23:00.1: psp enabled
>>> [   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
>>> [   12.544389] ccp 0000:a2:00.1: no command queues available
>>> [   12.550627] ccp 0000:a2:00.1: psp enabled
>>>
>>> depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on the list and before kernel/drivers/crypto/ccp/ccp.ko
>>>
>>> modules.builtin: 
>>> kernel/arch/x86/kvm/kvm.ko
>>> kernel/arch/x86/kvm/kvm-amd.ko
>>> ...
>>> ...
>>> kernel/drivers/crypto/ccp/ccp.ko
>>>
>>> I believe that the modules which are compiled first get called first and it
>>> looks like that the only way to change the order for builtin modules is by
>>> changing which makefiles get compiled first ?
>>>
>>> Is there a way to change the load order of built-in modules and/or change
>>> dependency of built-in modules ?
>>
>> The least awful option I know of would be to have the PSP use a higher priority
>> initcall type so that it runs before the standard initcalls.  When compiled as
>> a module, all initcall types are #defined to module_init.
>>
>> E.g. this should work, /cross fingers
>>
>> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
>> index 7eb3e4668286..02c49fbf6198 100644
>> --- a/drivers/crypto/ccp/sp-dev.c
>> +++ b/drivers/crypto/ccp/sp-dev.c
>> @@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
>>  #endif
>>  }
>>  
>> -module_init(sp_mod_init);
>> +/* The PSP needs to be initialized before dependent modules, e.g. before KVM. */
>> +subsys_initcall(sp_mod_init);
>>  module_exit(sp_mod_exit);
> 
> Thanks for the suggestion, but there are actually two major issues here: 
> 
> With the above change, PSP driver initialization fails as following:
> 
> ...
> [    7.274005] pci 0000:20:08.1: bridge window [mem 0xf6200000-0xf64fffff]: not claimed; can't enable device
> [    7.277945] pci 0000:20:08.1: Error enabling bridge (-22), continuing
> [    7.281947] ccp 0000:23:00.1: BAR 2 [mem 0xf6300000-0xf63fffff]: not claimed; can't enable device
> [    7.285945] ccp 0000:23:00.1: pcim_enable_device failed (-22)
> [    7.289943] ccp 0000:23:00.1: initialization failed
> [    7.293944] ccp 0000:23:00.1: probe with driver ccp failed with error -22
> [    7.301981] pci 0000:a0:08.1: bridge window [mem 0xb6200000-0xb63fffff]: not claimed; can't enable device
> [    7.313956] pci 0000:a0:08.1: Error enabling bridge (-22), continuing
> [    7.321947] ccp 0000:a2:00.1: BAR 2 [mem 0xb6200000-0xb62fffff]: not claimed; can't enable device
> [    7.329945] ccp 0000:a2:00.1: pcim_enable_device failed (-22)
> [    7.337943] ccp 0000:a2:00.1: initialization failed
> [    7.341946] ccp 0000:a2:00.1: probe with driver ccp failed with error -22
> ...
> 
> It looks as PCI bus resource allocation is still not done, hence PSP driver cannot be enabled as early as subsys_initcall,
> it can be initialized probably via device_initcall(), but then that will be too late as kvm_amd would have been initialized before that.
> 
> Additionally, it looks like that there is an issue with SNP host support being enabled with kvm_amd module being built-in:
> 
> SNP host support is enabled in snp_rmptable_init() in arch/x86/virt/svm/sev.c, which is invoked as a device_initcall(). 
> Here device_initcall() is used as snp_rmptable_init() expects AMD IOMMU SNP support to be enabled prior to it and the AMD IOMMU
> driver is initialized after PCI bus enumeration. 
> 
> Now, if kvm_amd module is built-in, it gets initialized before SNP host support is enabled in snp_rmptable_init() :
> 
> [   10.131811] kvm_amd: TSC scaling supported
> [   10.136384] kvm_amd: Nested Virtualization enabled
> [   10.141734] kvm_amd: Nested Paging enabled
> [   10.146304] kvm_amd: LBR virtualization supported
> [   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.167701] PSP driver not init
> [   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.177052] kvm_amd: Virtual GIF supported
> ...
> ...
> [   10.201648] kvm_amd: in svm_enable_virtualization_cpu WRMSR VM_HSAVE_PA non-zero
> 
> And then svm_x86_ops->enable_virtualization_cpu() (svm_enable_virtualization_cpu) programs MSR_VM_HSAVE_PA as following:
> wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
> 
> So VM_HSAVE_PA is non-zero before SNP support is enabled on all CPUs. 
> 
> snp_rmptable_init() gets invoked after svm_enable_virtualization_cpu() as following :
> ...
> [   11.256138] kvm_amd: in svm_enable_virtualization_cpu WRMSR VM_HSAVE_PA non-zero
> ...
> [   11.264918] SEV-SNP: in snp_rmptable_init
> 
> This triggers a #GP exception in snp_rmptable_init() when snp_enable() is invoked to set SNP_EN in SYSCFG MSR: 
> 
> [   11.294289] unchecked MSR access error: WRMSR to 0xc0010010 (tried to write 0x0000000003fc0000) at rIP: 0xffffffffaf5d5c28 (native_write_msr+0x8/0x30)
> ...
> [   11.294404] Call Trace:
> [   11.294482]  <IRQ>
> [   11.294513]  ? show_stack_regs+0x26/0x30
> [   11.294522]  ? ex_handler_msr+0x10f/0x180
> [   11.294529]  ? search_extable+0x2b/0x40
> [   11.294538]  ? fixup_exception+0x2dd/0x340
> [   11.294542]  ? exc_general_protection+0x14f/0x440
> [   11.294550]  ? asm_exc_general_protection+0x2b/0x30
> [   11.294557]  ? __pfx_snp_enable+0x10/0x10
> [   11.294567]  ? native_write_msr+0x8/0x30
> [   11.294570]  ? __snp_enable+0x5d/0x70
> [   11.294575]  snp_enable+0x19/0x20
> [   11.294578]  __flush_smp_call_function_queue+0x9c/0x3a0
> [   11.294586]  generic_smp_call_function_single_interrupt+0x17/0x20
> [   11.294589]  __sysvec_call_function+0x20/0x90
> [   11.294596]  sysvec_call_function+0x80/0xb0
> [   11.294601]  </IRQ>
> [   11.294603]  <TASK>
> [   11.294605]  asm_sysvec_call_function+0x1f/0x30
> ...
> [   11.294631]  arch_cpu_idle+0xd/0x20
> [   11.294633]  default_idle_call+0x34/0xd0
> [   11.294636]  do_idle+0x1f1/0x230
> [   11.294643]  ? complete+0x71/0x80
> [   11.294649]  cpu_startup_entry+0x30/0x40
> [   11.294652]  start_secondary+0x12d/0x160
> [   11.294655]  common_startup_64+0x13e/0x141
> [   11.294662]  </TASK>
> 
> This #GP exception is getting triggered due to the following errata for AMD family 19h Models 10h-1Fh Processors:
> 
> Processor may generate spurious #GP(0) Exception on WRMSR instruction:
> Description:
> The Processor will generate a spurious #GP(0) Exception on a WRMSR instruction if the following conditions are all met:
> - the target of the WRMSR is a SYSCFG register.
> - the write changes the value of SYSCFG.SNPEn from 0 to 1.
> - One of the threads that share the physical core has a non-zero value in the VM_HSAVE_PA MSR.
> 
> The suggested workaround is when enabling SNP, program VM_HSAVE_PA to 0h on both threads that share a physical core before setting SYSCFG.SNPEn
> 
> The document being referred to above:
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf
> 
> Therefore, with kvm_amd module being built-in, KVM/SVM initialization happens before Host SNP is enabled and this SVM initialization 
> sets VM_HSAVE_PA to non-zero, which then triggers this #GP when SYSCFG.SNPEn is being set and this will subsequently cause SNP_INIT(_EX) to fail
> with INVALID_CONFIG error as SYSCFG[SnpEn] is not set on all CPUs.
> 
> So it looks like the current SNP host enabling code and effectively SNP is broken with respect to the KVM module being built-in.
> 
> Essentially SNP host enabling code should be invoked before KVM initialization, which is currently not the case when KVM is built-in.
> 
> Additionally, the PSP driver probably needs to be initialized at device_initcall level if it is built-in, but that is much later than KVM
> module initialization, therefore, that is blocker for moving SEV/SNP initialization to KVM module load time instead of PSP module probe time.
> Do note that i have verified and tested that PSP module initialization works when invoked as a device_initcall(). 
> 

As a follow-up to the above issues, i have an important question: 

Do we really need kvm_amd module to be built-in for SEV/SNP support ?

Is there any usage case/scenario where the kvm_amd module needs to be built-in for SEV/SNP support ?

If we can have a requirement that kvm_amd will always be loaded as a module (for SEV/SNP usage case), then it automatically
fixes the above two issues & additionally we can continue on this approach to move SEV/SNP initialization stuff to KVM from
the PSP driver.

Tom and i had a discussion about it and we realized as so far no one has reported this issue of SNP support being broken with respect to
kvm_amd module being built-in (from the time SNP support has gone upstream), it looks like no one is currently using kvm_amd module being
built-in for SNP ?

Looking for feedback/comments on the above.

Thanks,
Ashish


