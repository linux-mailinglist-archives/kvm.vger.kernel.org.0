Return-Path: <kvm+bounces-53542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A91B13C8B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 134C5188BBE6
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F1E26E6EC;
	Mon, 28 Jul 2025 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qzeoBtPs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E714266B64;
	Mon, 28 Jul 2025 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711143; cv=fail; b=Q7l99C4smCiWZjMtPrEtwPr5/bIpDAnRXXP1dKEacISyGmXrAMLYa8yJXnn2YQjhOzoTQfpTJQiyV/X5gcnDUEE1CIV1gdwkhDjt39+N3Xm39biJ5Qng4GhybQqtx6moGWspYe2FFgtiNClj60Ck5cRnrRe0feEBwsDjF5QcBLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711143; c=relaxed/simple;
	bh=jiy1kiJwA4HYN1Fc2WOz3fTMeEsqpkzDoc/yIeZL+nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mp5QG9VOtK7nhR6kV15VNZ+dbPN6ozS3UpjepB4XU+E9XjpCo9ODLDQm1judhl/4cjDL8ux+RZAKkrUitOMDrSVwFqfQx5B2afY77a8HOfKyEzgcsDM9icMO5jS2VwvvIRkTfqweVML7h0uPKhiX3K1BQ+ngT+0L0mOgRhkv274=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qzeoBtPs; arc=fail smtp.client-ip=40.107.243.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5opATVTMkyA9xQtBP3qKeOyEUAwEf8rkM1wxyqpSjowRXxPwQTlUsrIVJP8OiWQaS+CUvpnxU7xZGu1m2p3LEk/NJdmlDJz4nkVViNihVnzkwN6GsmlAau19IwPx9bi1r2IlBFH7qB5/5VSkIjAKgSAqeRU2fUoBbc1g3vs9HNvl2BrJvWGNbXcwMMk+2RBnbqwAIvkAIS8tbbMEEN557JvzxRqeDvnVOKtuJI9hpYYuHGNhUFpg7w0jK1TnQlq7d12DeQcK9FaO7exgYt2t8OPBbXNZHvi3CsDO99XNCsWXJzSLchJwsZ1azCUScnkUduJBj7A2Q2pHtGAcw1yzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csuDsxtgLuPrhuzUx4SwJtvvo/bZCViGgeyh9j9pT3U=;
 b=WiLCxaymOVgOZTo3sf5QgL6D5ZCGrjCURZDy0jZR5CiiPTeRk6o+s403F1G1+338XMWlJS7kI8PwD/5tATRIz5slCvpeRjs+UErSAv4aBGGQT55f/eIBW9Zrzpe1GddIOgzpALIFjG+CwFr2NIn1CaqTNyzinyOkmVrIV0NI4JE6Mye1ZZoge16sRRXxoJrvXfH6UI9F+HVQVlXp2xKJWSjJP/5B14ST9MtMFJb/BvPv4sB9OS3bKxGZVH8bAtv+IaPuUocpBnVcAwb6lfegAJJ52bVu7rbf6kwsoZznrEvt+XuB8ohhc+/jkaT2xwJFVkRdMXBG/zGNqT3DwipRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csuDsxtgLuPrhuzUx4SwJtvvo/bZCViGgeyh9j9pT3U=;
 b=qzeoBtPs2lXPnyVcNf9j/CPIOxUHonHrtjuQADHg0KvhfSNeZ2almbOvvAYlJJcoNYwKFzX1Z0dLxnCCUMfq98BVJwD/yWTBxmTYO926BQ46K2Q6cG+ZVetHmhS98fxBfdl17PlbuShhQsE5qVOC/N2myBGnet33xUJwIVknf96omED/bk8iQ946jPY/qpt+O8O4jzw16K554a+bi5MSq0FHk2gC5oRNgd+ZOBcLI5FXbYQOuHANemzqPIy4bnnVA7nPLBakPJwMa4E1Tem1h491hedQl08blDzJbObBIMYmtnYsnZNlYqnzuuzjzAXuRiA/Oux5KO55a9c3zJ/WXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Mon, 28 Jul
 2025 13:58:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Mon, 28 Jul 2025
 13:58:58 +0000
Date: Mon, 28 Jul 2025 10:58:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 11/16] iommu: Compute iommu_groups properly for PCIe
 MFDs
Message-ID: <20250728135857.GC36037@nvidia.com>
References: <11-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <5051c509-75a3-4ab6-bcfb-4610a660a142@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5051c509-75a3-4ab6-bcfb-4610a660a142@redhat.com>
X-ClientProxiedBy: YT4PR01CA0490.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0e1b78-328b-4556-c2a5-08ddcddee5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWQvUHllRUZiQ29URU1FUkVtUzY3bWRTOVlsbXdsdllPRWRPYmRseGtHZHcr?=
 =?utf-8?B?VzJuZ2w0d1hjT1VvbHdCM1c0NTZwcVVVQlVDMjhBUzN1M0QvOEZjT2RzeW5G?=
 =?utf-8?B?a1pxbEVGNzFGWXdOcWRwYjE5Y0duVXFJR0ZqZ1RJZUNFSUI3YkRNam9VZU4x?=
 =?utf-8?B?aUJUZG9PN2M0LytRNlJWdkpkZUptRDFZTGJidVdUaXdEdkU2eldyTm9oR0JE?=
 =?utf-8?B?SEtWZmc4SkFIY3F0eitXallGY3VNN1hqeDJ0WE9kSDJsMHA1bjFsMTdXWktP?=
 =?utf-8?B?RzRIajNxQkZ6Y2NjRU8rSitwb3dqbHVSYWRYSnVoZGcxKy9ib01mYkx6Sk04?=
 =?utf-8?B?Uk9Dbmh5bDN2aTJmOUxNeUJJYk5ETUNoZVNDWmxRZ0d3Y1J1c24vNlNkQXc4?=
 =?utf-8?B?VmllSDlFbS91UGw0WWRXQzh1dndmRDNVdnJBT1BiemxjUWM0YURPRlR6UHZO?=
 =?utf-8?B?RnBFM0k1Z2JBS3lRYUkzUkl6T1pmdVJYMEtNYW5mK2YwaCtYckJFM09xa0lG?=
 =?utf-8?B?S1prL2NkVTBVVVIxVWJGVElGQkN3WVJ4czJad00rbmtYMmhSbGt6akRYWWhs?=
 =?utf-8?B?dDlpbERvaVhCYVpNdWQ4SEVoUUFCMFlSejdoWWNSZ21wZUFVc1BZekt5cVBx?=
 =?utf-8?B?a2RuMnNNWDdRZXBEdXlXL2FMUXFXME1mR3R4K3RKUHNlcHlMRklGUURRclM0?=
 =?utf-8?B?L1hRMEJxQyt0S09SdDhRWHJrZmttVWFZbjYvMjR5OFF0WG1YTmNNbmpvZzRM?=
 =?utf-8?B?ZVRuZExadDF0N3VhNENKN1dZdmRDOFFaa21aMzBOaU9RUFZaTzQ0VEFraFkv?=
 =?utf-8?B?V1VaMWd1VHlSUXVjdUxZbEtMYURZRFpHUlBrbW50ZWxTSGdSRGlNT3BlQUF5?=
 =?utf-8?B?QjROdEhJMHRuTHNpOVlVcUdoSnRxVjVMOTdFaUhZZ1NRTnhqMnBWbDJ1enJn?=
 =?utf-8?B?L0lSYVBya1c5cGMyNUlPMXZlL05RMG9BeUQ2YXpIV0VJSWpUTzFFR0ZlTEdi?=
 =?utf-8?B?SHhOUU1uQ2wrNGRIUnlaV3pLRSs0U2Vja0ZMVWpjV3JNZlZzRTVUYTAxbm80?=
 =?utf-8?B?V0dwekxkNjQ5TzczYnlvV3pzYkRIaGRkY2E3Mjg4SjF0V3JsazAwcEhxaG93?=
 =?utf-8?B?Ky92OGdVZHFqeDVzWkxsQjdGSW5RSGtlRTNNU0I1eEt3NkxJL21JcytBeFc2?=
 =?utf-8?B?SDZ1OXdrbDM0T25BKzV6OGJaY2lrQXJiNXpveG14OUtSdmFvNGNwdjFPZnRh?=
 =?utf-8?B?Y1pialJiWXltSnd0LzBnWnJucEtSZnRtek1qTU45SWZkd0R5RGwrVXJTSXV2?=
 =?utf-8?B?VWtweEdOckwrY2psNXd3NzcrQU8rUTJTa0gyVWpnUldNbTR1dU5KTFhySUdC?=
 =?utf-8?B?T1Z4VFFYK1d6SkROOFpVb0lwUlk0QWJUNWM0RzA2NjBFbHRSbUVBYk5JTVZV?=
 =?utf-8?B?akVOZEtUaDJQUzlnSjBRSjB2QU03N2o5UjEzWWVOWXRFdHdtRm9USlBRbmxy?=
 =?utf-8?B?NDJuREFuOEVNKzVOQXIwUGdCTGdHTFp2RUNkOVFOTTUxU2dxRC9OZU1zTkxF?=
 =?utf-8?B?VC8wUUZDVExFSmYrdW5sazRWazRWTHJld0xtZm5Ra0pXTm9kaWdIK3NJcm13?=
 =?utf-8?B?QTQreHJZOVd3dEVrc0h6N3N2UEpIelhFVTdKRzUxNmFJeHN1cXQvZnRxdGw2?=
 =?utf-8?B?K3ZSZHZPcS9pSVVuODcycDFmZkxNRE53byttUFpnZzdiSmJDdmV3aFhRdXdY?=
 =?utf-8?B?cG11bWdvb09aM0dEWEJtZkVwTkFnd2dhaWsrWkdFbXpkRk4zMm9mQWxhVmRC?=
 =?utf-8?B?bnpRWUgzZmpPSGhDalY2THBBSDdFa0VMRjFCamVmWXpTTloxZVkxT1RFenRY?=
 =?utf-8?B?ZU5jZ3ErMXo1MFBtd2FMVlJpTVhsSnZ3ZXpuWC9Da3BNeHI1T2dvMHRyMnhQ?=
 =?utf-8?Q?BxMfTkrxR4g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym0vaVR2NzJ2MU1mcEpXVDdjRVp4M0xERWIvYlk2d2piNHRXY1JsaHhnNWZQ?=
 =?utf-8?B?NVdEU0FsUzRyeEJ0eFlOajNEZ2xDckpNSXVUQ3lHREdudGtUelZ6VXY5SzNU?=
 =?utf-8?B?RmZGS3FNTGtnV0V3a0dBSllRVnhIeE9BVWI0TGN5T2RTOGxVQVBWU2NTaG9k?=
 =?utf-8?B?TkhRZjZ4RCttTE85WUVmR21Ya0pnRW00eTEyVy9ZRnFVRUpZVWpyZ2orekFm?=
 =?utf-8?B?ZDZxSlRXblZzTXJiVTNCSUI3NTM0dlliMlQrSm5sY1N5bnJWUGc0YktkTWxG?=
 =?utf-8?B?UTY0aGJOOHoya09PbVBkV3ZXa2tIRkw4Mnd6Q1lOdnVBb1JhNllPYW5CcG9t?=
 =?utf-8?B?Y3VjcDVtVzBCVlZlUEVzUitpeUhNVVppT0FiMHBINlc4QzRwTVVsbkNXNTlU?=
 =?utf-8?B?a01uYUh4c1VRSjBBdThOaTdDRitZZjFaeTdiQS9Eb1g5Rno4U3pYcHZrOHcx?=
 =?utf-8?B?cUF3ZzZQUmVFN09QQzh1R1JmaFJzY3NpdGp2b3psZWNST3FQLzBCK201cU40?=
 =?utf-8?B?RTUyQ1ZwUTNRb0xjbG9VeGs4SVI0OTRmT24vcGZqeFlJRGpNaXUzNXRmVUJK?=
 =?utf-8?B?NlVDYXRSRnhjdkVUb0hrUnNTNUo3aUtBbVR3K0J1L09iOXlqbE1EUWtBTlJG?=
 =?utf-8?B?QkRwYU4wTnBUZjhsMTBGU24xYTlwQVFWMGRaU2NSTE5nUWF3YVJPd0ZKL0lF?=
 =?utf-8?B?Nkh1N2k5TU53Nk55ZURzc1RFdVcrREV3Q2dZT3hiVWdjZXZuT2J6U3djbm1N?=
 =?utf-8?B?QzRqVWw5RytBTnNLQm9QR3JGdTM4MTFUSnluMS9LVzQ3U3Excm5STVo4czJV?=
 =?utf-8?B?QWFqSDgrdFUwRC9CbVpQSEQxendYaUhUb2hGaG03RXo0S1ZhLzBmVTROOUU0?=
 =?utf-8?B?akFTcXg3YVpQU0xJS0pLM2tkNXFWZExDZTNGbFZSVFlxVEpsV20yMEtORDY3?=
 =?utf-8?B?TE51WXZaTGtKSVpIZFZhN2FodTNlTVR0MTc1THZxbXZUZG4zME1EUnR1aHZ3?=
 =?utf-8?B?SjZ3WTg2blZyOEtWRnMxem9qeklXeXQyeUVEQ0lCTTFGaEtUa0R2cWRyRm0r?=
 =?utf-8?B?b1Q0M2VhSUFPVE1yUXFCeXJHNFpVSk5zL1Zkb1Q4Nk5mQnh6ZnNvdE5qVFJT?=
 =?utf-8?B?QWdtcXV0YWQyd09Ra21jR2IyY3E0OVFzZThqR3lIZ3JZd2xFMk9xUUQwMWZy?=
 =?utf-8?B?bU9wT3JlM2lyMmtVV0FseExTZ2RuaTdXTCtkTWJJWEh5ZW5VMjd5NWhtMy84?=
 =?utf-8?B?bVdVeStPRDJDMUt0c0ZCbko0YnZCMUZuT1ZmbktBY2ZxNG44bjRKYW5IZ1do?=
 =?utf-8?B?Z3ZGcEordmhCODRhcWowNlM5R1htdXk1MUR0QjE0RmZJWklqZ3pQcGp3S0Zw?=
 =?utf-8?B?YUk1OE5QZlJSMmIxRkxpUEFZZmJwbnNwaGVzMTY4L25IcDlBTzZBQW0zU3VY?=
 =?utf-8?B?NXdiNHhuSEUycEhnTEoxNGsvc0U1WjVxMDY4UXJ6QXdCRDl5V3FNbndRRUJ2?=
 =?utf-8?B?VDRSNzc4UVZwQ1Q1bnN4cmxHREdiaDhiSmNoaGlzdWZLcW9YYU9VV0Y4QkhJ?=
 =?utf-8?B?KzRnS1AxR1hyRVViV2ExeTdESEFUendxMjNkV2JFb3JVOVR2cDl2Sjk0Rkxw?=
 =?utf-8?B?L3crTjVwU0dDVThacFZsSTA1Z1dVUXFKUnc3VFFEelRmYi9RY2xBMlpmeWM0?=
 =?utf-8?B?Um1Tck53RjM0NnF5WU0yakxzT3ZRSGh6SEVoUWpudENBVGt4SGlGZGZOeFJa?=
 =?utf-8?B?alk5RmljdjJ4d2dFRnZmUkx1NldRY2pTTEhUSVhrZTVldVpuYXB6Mzl3ZU4v?=
 =?utf-8?B?Y1JqUk1NQTd1ck4rQk9XZyt6OFZEY2FUenIwQW4vS2VMT2NEUHN1dkEzS1lM?=
 =?utf-8?B?TXEzWXdNK0pnZDJibUY4RjFoQWZVbU5kT0ZGc2RTUU4rTGpFcWZlaitoMDNU?=
 =?utf-8?B?OHpVd1RzNlNlYlhTZkJ1V2JCV2VQa1duTkw5SGxrTUxMTTdEMTl0cGlWTSta?=
 =?utf-8?B?RGJUeXczb0t0Y2t3am4zeDY2dmpSS0EvaTRXV3JPTHNTck9LZ1NtWXA3ZFph?=
 =?utf-8?B?NjNQTFR2MHlIUk5JYW43b0ExSU9jMndQT0pydmR0bDM1RDF4VUd4QXh0cVN5?=
 =?utf-8?Q?qysE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0e1b78-328b-4556-c2a5-08ddcddee5e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 13:58:58.1147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ohQ/AICwwcDOYvV/ZELKN9NqZ3kk5hQG47W5Z+p+WaznTylSV3ES1uFgP43SQPY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040

On Mon, Jul 28, 2025 at 11:47:44AM +0200, Cédric Le Goater wrote:
> > +	for_each_set_bit(devfn, devfns.devfns, NR_DEVFNS) {
> > +		struct iommu_group *group;
> > +		struct pci_dev *pdev_slot;
> > +
> > +		pdev_slot = pci_get_slot(pdev->bus, devfn);
> > +		group = iommu_group_get(&pdev_slot->dev);
> > +		pci_dev_put(pdev_slot);
> > +		if (group) {
> > +			if (WARN_ON(!(group->bus_data &
> > +				      BUS_DATA_PCI_NON_ISOLATED)))
> > +				group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
> > +			return group;
> > +		}
> > +	}
> > +	return pci_group_alloc_non_isolated();
> >   }
> >   static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
> 
> 
> I am seeing this WARN_ON when creating VFs of a CX-7 adapter :
> 
> [   31.436294] pci 0000:b1:00.2: enabling Extended Tags
> [   31.448767] ------------[ cut here ]------------
> [   31.453392] WARNING: CPU: 47 PID: 1673 at drivers/iommu/iommu.c:1533 pci_device_group+0x307/0x3b0
> ....

Ah, yeah, it thinks the SRIOV VFs are part of the MFD because they
match the slot. I guess the old code had this same issue but it was
more harmless.

>  *IOMMU Group 11 :
> 	b1:00.0 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
> 	b1:00.2 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
> 	b1:00.3 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
> 	b1:00.4 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
> 	b1:00.5 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
> 	b1:00.6 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
> 	b1:00.7 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function

This are all on the MFD's slot slot..

>  *IOMMU Group 12 :
> 	b1:00.1 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]

The one is basically what triggered the WARN_ON, it was done before
SRIOV "changed" the slot.

>  *IOMMU Group 184 :
> 	b1:01.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
>  *IOMMU Group 185 :
> 	b1:01.1 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function

These two are on another slot so they no longer matched

It should be fixed by ignoring VFs when doing MFD matching.

> Other differences are on the onboard graphic card:
> 
>  *IOMMU Group 26 :
> 	02:00.0 PCI bridge: PLDA PCI Express Bridge (rev 02)
> 	03:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. Integrated Matrox G200eW3 Graphics Controller (rev 04)
> 
> becomes :
> 
>  *IOMMU Group 26 :
> 	02:00.0 PCI bridge: PLDA PCI Express Bridge (rev 02)
>  *IOMMU Group 27 :
> 	03:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. Integrated Matrox G200eW3 Graphics Controller (rev 04)

Yes, this is a deliberate improvement. PCIe to PCI bridges like this
do keep the bridge isolated from the VGA. Only the downstream PCI
devices alias with each other and are non-isolated.

Thanks,
Jason

