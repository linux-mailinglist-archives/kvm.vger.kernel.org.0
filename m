Return-Path: <kvm+bounces-70159-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDvCGxsKg2k+hAMAu9opvQ
	(envelope-from <kvm+bounces-70159-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:58:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D90E3657
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC6DB30D5974
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 08:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AED39E167;
	Wed,  4 Feb 2026 08:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uOvP5/7f"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B173D2FCC0E;
	Wed,  4 Feb 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770195275; cv=fail; b=Z2KXSXPQs8vuu32UaCPnf98J2gja1zvxgdkjNsTbh0fGwWoUQYR1WPZbmDMhytSRZ0wxutSG4rXhe59SxYgRqxGoFculOpP1saNp5R3QHJEBWvXSemjI8h/yuKu+HMutHhMIrkT7EHCNY81hfGFH6MbrWTbqKNmHk7oxt3g2uK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770195275; c=relaxed/simple;
	bh=e9wx4jd75PD5eLtPYNmBT2bEuleQqr/T5FRcgMdrDEc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RB0o5oMa7Kdiy+Xn6tvsyF4zeaVowQ9S4kj+tdDE9CBfO3YLcHlUdPm/HernLSeKjRPil3UqG0/Tu+8ojcPcNbtWoMm0RO11h23vwaigytTVG7DJPrW7tlvwdnFYbR0cNIeob6CSUNHfhz+2bhEeNacT17sQUA0mM8A+ImHdvq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uOvP5/7f; arc=fail smtp.client-ip=52.101.52.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sg/UkPtcW8RgjJ/jZ1X0FUksuaeJozZkNrDpmkjVDxWbfRqUMTJrfEI3XN/OJG4EGvwXKlfaWXXjUWBF7oPtyqI0sG4anT2bjTA4OGQUFaAfRFRYJFd9ZglIQjFhy+U8qYh4Qb9IsGjEwxqIOuU2Zw3OSaJMFpUOtnAhRVSLGTgH+wotKMQqjTKhel8nmXN3NGk0dhUFa34Etzx/k84SrAu7Nvke+yvLZadTSYnpXdKryDpPSCK1JvrItHhnmKDlj2wS69WokiMPUAUmtvEiMSA9dVroXo4r78gSASxRsFz1EVeZFUtiQpcwPDLGbzFLL60LiOl/AOuUXw/7t9Rm5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sutKFJYB8MGYttqOdWyY3vUw3F2EsH+vIPckwvABVI=;
 b=U25brUfaJqajWnzBkdbyiO/s9x8XnfU+Eiwvkd05DyBWjbZ5KXcVkKDM3Z8IeBdTOLR4p5HsJgHbLvaLp8YiXppB3OR2kTrSktwLbnUUh8T0crZw9gpX7HmB2ZoMoeaTT6hq3BsX+rQoSczD/CHQRuNKOulQPfmuxsjuV07GktruVeIntXSsfVCp6D3jCCO1l7row8lq7JzUzWJUpzTHUYPzsCPOi/wfIdvRbxRIh75BEAncHEoRUgekLxiPqpGBdsv/rwC/zDopAXzlk6EwsZZ7800ZN0aZCf7f72kF7dg584LKMSD3fQQ8DgJJbhAqRB15Rj5bIpdFKY89kBGhVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sutKFJYB8MGYttqOdWyY3vUw3F2EsH+vIPckwvABVI=;
 b=uOvP5/7fzZzi6y9vJtiNdR551oJR9VtRnB3w6nLOTdcIfYqMi1Rsb0TzVAEsWyRoUdhk4SmWsymHY+gpFsfGnqACPLdGbx9oqdDFz5KefRBkEp9+bag47zcQsN8b5+p0k+ifOMTAS2OkLOXjqtS7OmxyPJwj4Ie5tAkEwe1WbpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB6755.namprd12.prod.outlook.com (2603:10b6:303:1ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 08:54:29 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 08:54:29 +0000
Message-ID: <6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
Date: Wed, 4 Feb 2026 09:54:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate shared
 buffers
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
 Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Gerd Hoffmann <kraxel@redhat.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Felix Kuehling <Felix.Kuehling@amd.com>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, kvm@vger.kernel.org
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal> <20260204081630.GA6771@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260204081630.GA6771@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0434.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::7) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: eb77b1ee-834b-4caf-8ebd-08de63cb017c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVc3cUxFTHpHQlVwSDhLR0plR0wxMFZ6bmtLYkcvaDJvQ01MVGFBVFV5Z3pO?=
 =?utf-8?B?TUtDMCtIN0RqNThsTDE0L00vRGVrY2REbU9URlJPZjU0OW9LNmUrOVBNNVdq?=
 =?utf-8?B?SFhBL2x4c2s1QkVIc1p1VjU4bWRXVHJvQ2tzTHBJSEJid2JRUU1INXc5RnE2?=
 =?utf-8?B?UEFVQTM2cXlFVytGMzlIS0FZN2x6MWMwRmRnZUoxL21WLzJVMFVLVFZ2N0ww?=
 =?utf-8?B?aGpwNmpWQ0Viby9nK2F1Y0pFZnBWRzRvdlZsV3RBNTRobWNSWHJOK2Y0K0g5?=
 =?utf-8?B?SHFPWUxSMHhNSWxDRUJTWkVoQVFYMlg5eXJ5NGJpcVowOTVGU3JZWFA5Z1BF?=
 =?utf-8?B?bFlveGMrVkxpVlByWGxHOEJrZGlBR2tKVkhLTER6R2I5Wmgwb3pxalRWL2xz?=
 =?utf-8?B?WWxVMEdJZjBhTTdkbUJyK0Y1UmpHMUxrQTFYNVZxRzI1cnVvMk0wVmlzU3Bn?=
 =?utf-8?B?SXE5UHU0TlZxalBNb09uMTBCQTZQQ2xxU3c5aVRBRDZQOE10cVU5Ynl1d2RY?=
 =?utf-8?B?WkdBcDQ1LzBzeVRReThOcTIxdW1PTDg3Y2UxcUxUUjdOTExzVXJUVFBySysz?=
 =?utf-8?B?eXUvWW1NMXdKOWRKM1pWWEZVUmRqQnJrZnFtaDVJRFRxdlZpSkFCcllFYVpJ?=
 =?utf-8?B?MkJ2VVFjVjhQczhJSllrRk9DdldiSDE2NmNSM0UwTEFtWTVZcTgycHVCRVVB?=
 =?utf-8?B?d0JsNWg0V1BuSGdzclpJV3M4NzlCc1JoNFFjSnVTeVQwQTh0SVpuTHZSVlBo?=
 =?utf-8?B?ZUFrb0c2VWxGQmtjR04waWlPbGpPcTFndzlkVS9qNTZrL0VLaVdMVE93ODU0?=
 =?utf-8?B?UDUwL0RMNTF3eXo1YjNoUVorZ3BTb0VUWFQvMklyMXVUaWxEejNwdFhucWVE?=
 =?utf-8?B?SENrVnZJa0FvbVFUVnZJeTlsZzRsUHo3Y3RrVTIzMHB0VExSWkVEN2pTM0g4?=
 =?utf-8?B?MDQ2QURkWUI0UXFkZ2ZtTWg2RXdjQWk5Ky9rcXFiVGxFUkhPNEVUVTdHVzdT?=
 =?utf-8?B?OHlJZ2U4bEpscWEyUmNXMmhWbUhENzlTYit1bVZ0YVMwSktKYmZLVzZZRzBq?=
 =?utf-8?B?Z0dRcU5hajBHSGFoRFN5bXltblM4VTBIOVBhS0g3L2x3YzJzdDRkcUtYeWJT?=
 =?utf-8?B?SGk0TXVSMFhkSFZvcXBYTE5NaENWeXA0NWtxSHBJUG53aG4yaDllWkFOMWJr?=
 =?utf-8?B?Tm1pT3k1NmFpQ2xzeVZDSDVCS3NSdndKN1VUY1VTNmN5YnR1THNiTUZ6UkJl?=
 =?utf-8?B?UndaWmlBMUF0ZHJTdUpkV2hObFVaT21DdURqbUVsYWtCNVl0TmR6dDBJM1dT?=
 =?utf-8?B?cGNLWGVBVE1Ed2t2bXlCbzJ3aHZYNDZYQ1RaOTlMMWZzUlBlMi9LTGdLNDlX?=
 =?utf-8?B?SDVhTDMxNVlnMTlWaWZubC9EN1Z2N3doWE9QbnQxZEdQRjNhK1VjQVdQcXlv?=
 =?utf-8?B?VG16eUZIeUJ1TEUwN0pMeVlSenRjQkkrSzZKNExvMFJUeW9QZUsxd2tGT2lW?=
 =?utf-8?B?Y2FFeTY5MzBySGxXSFhudUZENmNhS3ZrSS93aVBoajdRc0w3c1M2VzI5Rmgy?=
 =?utf-8?B?K2dTM2p1WnJoTGRPaGpDZVA3cTFTdm05aU5hRmVpVXdIWDVqazJLemVwRmJh?=
 =?utf-8?B?K3lJOFFHRVhpMWlqUkZpZ0ZnUjVRb1B2OHF4ckxGUE9sSG9XL0hyRTloMnVa?=
 =?utf-8?B?eXZtS25rbHc4ekJldzFGOWYrdUVDa00xN0ZBeUJWaXZkQ1d2aEw0TU9zODFR?=
 =?utf-8?B?WHRYM2grN2JveUVGU2lSd1hlU1kzaS9HMVhqcStVUmQxMU1vcUZOYVhvSVJt?=
 =?utf-8?B?SGt1UTNacHg1S3BEbjdRTi9xQi9lOXcvcno0WWpKRkVDVk9RZ0c3dVJ6aHpu?=
 =?utf-8?B?Z0RzbDVrbTF4WE5CMFpPUEl4bEh0Ui9RMkk1UFVsV1hSeGg3cG5tMGs5eXlG?=
 =?utf-8?B?Ni9IcS9jUU5UaEhubGhHRjg0UkpFTGluSEpGeFJ1cnYxbFMrVGszTDlSOE5n?=
 =?utf-8?B?ZDRteEZobi9KUGFVMCtTZDRGZ21oRG9udXRoTDBIbnlnSzRielNJSW8rVHkz?=
 =?utf-8?B?RmlERjJUY2JwTGNzbnFkRDNLV3Baeldha2tFMUpQRGYyZFBERGZHVzNqby9U?=
 =?utf-8?Q?F1QU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUZMSVExLzRUZ1p5ejZVRDNSNEtMeUpLRVFnL3h2YWdIOG9Ya01JRDk3QTVT?=
 =?utf-8?B?cnlWVS9ueFZJbHIrV3ZoZFhMZmRnd1QwaVNLQWJRUWlnajkxaldvcnVmcFlX?=
 =?utf-8?B?dmJpVFAyaHNQVjRPL0RKbXlFYlp2VWc3czI3NDVOSzY0WlFCbEl4MUNHNC95?=
 =?utf-8?B?UmlFUnJneE1UajRnK1M4RTlKNklENHVDWENvdUU2QlBCNDJQOEIraXRjc2g2?=
 =?utf-8?B?WU5WZ1ZjUnNwRU11cVFHVllJM21zUDc5NjB3MW9LOE96VGR0aDZMRWhoZStU?=
 =?utf-8?B?SHB2eW1qcHRtYWZsSTVkS2luMUl4ZnAyd3krT2NxbmJtUlRtL1NXL3dyS3Vm?=
 =?utf-8?B?Q2JQY3BXTWFNMWs2RXg0bzJIMDhsOFFKUDZPenEvQWc1RlhDQlFaWitXNDA4?=
 =?utf-8?B?aVdnZ0hCMzlPbDdhaWw4NXBzM1FYcDh4S29vRHA4NWFaWXBRR1JCdzFQdGRF?=
 =?utf-8?B?blo1aWRJYzdMK1hsOWQ5MTJ6blpVQkF3VEkyNE90MFEvVjhmTDlkS1hwcVUv?=
 =?utf-8?B?Q3hkME5hR2kzSWdXZ1M3VHBLMFlLZE9OeGxudEZUYXh0aTkyWFZIVjllbXA1?=
 =?utf-8?B?WGFnek9IL2RZaUFEVGlXRWRITVB1OVpWcHR2TlJ0ZmFkdm14Z1U1QUZ5VUo4?=
 =?utf-8?B?WmJMMVp2RzVaWnB4S2kzVy9KUHE2anY5VG9zYUFiZXBSR09adFNyQVkrZStU?=
 =?utf-8?B?MG91TmZpejBrem1ob0t6dVdySVZ3c0Nkajg1KzI2dG03bnVDbGIvUjltamUz?=
 =?utf-8?B?TytGK2VBTHRiS2RlYmEySkdKbFBpZmp0aDRmS25iYW16Z0lUV1pwdFZza2ZW?=
 =?utf-8?B?SURqSExSbTJDM29sUGpZZDIxMytEWU9oSUkrUi93VUJ0KzBKKytlcmVGSGJQ?=
 =?utf-8?B?MllSVm1wOTdLdUFxbU9GNXdqYnZ6dnJEUk5FQ0tHajZLZ1d5MG1VNzlvc2RK?=
 =?utf-8?B?Ym5aZHRaSkpSVkhZdllVVDNZZ2NKZXZwQXVwbmgxbFY2SWRndVlWRzFITmlt?=
 =?utf-8?B?NjZxZjBZVUd2OE8yVy9aVjhGZzdDSWVBaitrc2t1U3NUWTRUV3NUeUFBZkVQ?=
 =?utf-8?B?MVNwVjNqOTJyUEE3c1Zzbm5RNFpRdnBGN0d1UjFhaFZwd3JVUHVwSm9acE02?=
 =?utf-8?B?bStYTGFoM2ZVZEtVY1RzUW56NGgwNEp3VDBTZzVNa2tWQkNJRU02TktLRGts?=
 =?utf-8?B?QVNGTzJ0TWx3N3hqaU05WFVTWHpuMzVkcmkxQzgyMmljd1cwR3Q1ZVVyeVp2?=
 =?utf-8?B?MUNPcVVWbW05ME1LanRNdFU1ckVTN2p2NmZEajk3ekxGN0Q1anBUUDUxRnhw?=
 =?utf-8?B?ckQ2Rk5mT0xza3YwcFY0OHNYMmE1RWE1WElvcDZjSC93STU3UkVTcm5uWHBr?=
 =?utf-8?B?eG55QlQ3TEZjMTBBWElodU1YUVFjcFdmWEVFOS9RY0JWMXFvSm1ENHlWTlZq?=
 =?utf-8?B?Y1I1bWhndlByOGlCVzhGd28zSGJPeUlybHVLZXdPM2xhQ0dhdGlMeG8vbmVW?=
 =?utf-8?B?SGI0TGR1SUZCUTBVQjdybXU1UmV5eUpFRFNMOTBlWTRjeXBtUGhEMDNWZUtZ?=
 =?utf-8?B?c2I5Z1crY20wbW1jY25jN3Z3YTBHTnN4Q2lTQ1ExVzRqNzR1QWJmc01WV2RY?=
 =?utf-8?B?eDFNL2t0STdGMVpCYjRIUkkxOUhpaVVILzNTaHREQ1BqOXowM0VBTVd1RzhZ?=
 =?utf-8?B?akRIQVpuNWlUS3NaOEgwanZtWk5nZ2hHN3hiNThsbEpQVVFaK01pakR2Sm5a?=
 =?utf-8?B?TUVqZ3ZkZHpEWmc1L3d6V2ZILzgvOU9UY1F0aEdzdkRucWhXby93bUd0b2Uz?=
 =?utf-8?B?SVlPTWVNemZSRDc5TGdzRzJWekpwaFJrVlRuZ3JpZWtXWTQ1MGVoQUdVY0Rm?=
 =?utf-8?B?OEtMb1E3aDk0dlNZQ3JvRklPejFMemlHMXhaNnpoL1VDa2tlT2xZZ2tOZ1Nz?=
 =?utf-8?B?dHRHRVYrbURPYzVzZnR6OTBWVTNMOWZIdnNrUnRubmlrVXQza2NWbGxndlB6?=
 =?utf-8?B?MURGdEtZdDBVbjEyMW94ejB3cXl0VkdPV1FjWVo1OU16eU9DUit2SkdBYTZB?=
 =?utf-8?B?aVRVN2Y2SVRZSWVqUmFoUytXdFo2d2NMWkpuS2RzLzNVZXpSQ3k1eGNyT1hC?=
 =?utf-8?B?bWpaODk4ZE5SQWIzS2RrRlJjWHBXNW10MmNYTkcxVmR0N1hneXhCQ2lIZ3FD?=
 =?utf-8?B?bmxrTWM5bVJXVEJHeDZ6OXNFVmNjMzhEZ0J4ZkpuZ3dpeW53VzJCNWtNSTcz?=
 =?utf-8?B?WjhzZWhEb25QUUcwb1ZKTVg4VjhXdDRmaUFNbnBTc3ZRRFZLUUxDaDJYQWxt?=
 =?utf-8?Q?XQRS8ng78k+nQeQ2VH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb77b1ee-834b-4caf-8ebd-08de63cb017c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 08:54:29.0525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iU1f9yQR3eMKaQDdIgwKB0qcwY86ZgCc9Z0Hge4syM60227RJKh5yELwm2Ds/Zkr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6755
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	TAGGED_FROM(0.00)[bounces-70159-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D0D90E3657
X-Rspamd-Action: no action

On 2/4/26 09:16, Leon Romanovsky wrote:
> On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote:
>> On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
>>> Changelog:
>>> v7:
>>
>> <...>
>>
>>> Leon Romanovsky (8):
>>>       dma-buf: Rename .move_notify() callback to a clearer identifier
>>>       dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
>>>       dma-buf: Always build with DMABUF_MOVE_NOTIFY
>>>       vfio: Wait for dma-buf invalidation to complete
>>>       dma-buf: Make .invalidate_mapping() truly optional
>>>       dma-buf: Add dma_buf_attach_revocable()
>>>       vfio: Permit VFIO to work with pinned importers
>>>       iommufd: Add dma_buf_pin()
>>>
>>>  drivers/dma-buf/Kconfig                     | 12 -----
>>>  drivers/dma-buf/dma-buf.c                   | 69 ++++++++++++++++++++-----
>>>  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
>>>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
>>>  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
>>>  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
>>>  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
>>>  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
>>>  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
>>>  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
>>>  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
>>>  drivers/iommu/iommufd/pages.c               | 11 +++-
>>>  drivers/iommu/iommufd/selftest.c            |  2 +-
>>>  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 ++++++++++++++++++++++-------
>>>  include/linux/dma-buf.h                     | 17 +++---
>>>  15 files changed, 153 insertions(+), 96 deletions(-)
>>
>> Christian,
>>
>> Given the ongoing discussion around patch v5, I'm a bit unclear on the
>> current state. Is the series ready for merging, or do you need me to
>> rework anything further?
> 
> Christian,
> 
> Let's not miss the merge window for work that is already ready.

Mhm, sounds like AMDs mail servers never send my last mail out.

As far as I can see all patches have an reviewed-by, I also gave an rb on patch #6 (should that mail never got out as well). The discussion on patch v5 is just orthogonal I think, the handling was there even completely before this patch set.

For upstreaming as long as the VFIO and infiniband folks don't object I would like to take that through the drm-misc branch (like every other DMA-buf change).

So as long as nobody objects I can push that today, but I can't promise that Dave/Linus will take it for the 6.20 window.

Regards,
Christian.

> 
> Thanks
> 
>>
>> Thanks
>>


