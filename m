Return-Path: <kvm+bounces-36823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B68DFA219D0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155EC1653CC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 09:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320AA1AA1FA;
	Wed, 29 Jan 2025 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CvgDDrZS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A513D8462;
	Wed, 29 Jan 2025 09:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738142687; cv=fail; b=u6jz0nledqY4+mcjOAaTd5VD67FzehijJCF9QusdPUh4H9loqibm3kjVJQjDw9agKywzdGi8rUclHcBOCEp0JiXPz9wdzLwtnGvid7BQ4zZlA6H4W+n9fSvUHV+EW0UAJR6OPOy+r1tAv1zxD7uCDoqiSYucmrXFO1QRiPF/2hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738142687; c=relaxed/simple;
	bh=xNVzhqYU7hL99ASZh9buqyaD6R0h6iOsmN3eeXMpgd0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DgkT0WCblGyn8izTAbD//kknoxGdEV5ECa6GgwQ8OEJlBf6RJgMNVhqU0tTk1ZGKJA07PCvuKqZcqaWInB0ZcqjpORukt4Z07ZswiUMECYdqMtBLZJBztGWGkiggmScqzrU2C4/yJkHxHt1Og6xtNlvY1prmDGcHxScUrWkB0no=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CvgDDrZS; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXO/SWexFJ4BOq69cOQN8dESEaLwZjylGvw7i4V9UL8O8ps+ZAWkM923p1ebdG1PNFTZys2URAPL4FT8pcEVbCzb0A0GfdSwH6QNns6XWnuUh4xGs1h7ZTqf2pOgs3qg2f183f55FhrMl+nvaFUTVRH9u8sqz42KQE6DYvxAkzjkSsxzvJ9er0QzAKhW+9Z8ZMXsC7ac5Ef3Nbnq015n3Xbowub/6TIR/HA0gLTkKFVIJ0G7lIHgDtM6ChxGMCkvxCy0xRWvHCrE31rQfu2pXXonCMwHlzHHZleh9eDJeI9X4aXvCLIIuoNNKsGs0dpoHFRxjcseJwg8ENfnqrxKNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLNxhvxI5rOVz/I4jjztbS0cG6cP4+VzFn2nOewQUr8=;
 b=k0TxsjntKR5uNxOADtQZwYSidDyH1eYqwmll12irktNREvpYQ9bE7XoJ/VVPk30Q8XYt1flquhzlyBo8AwZK6lt6FNfomCEjcNA+I5iAx0B1WNznPpwt5fCqmh4mHRF+Sl5Fkuee0mAzFrcQhDI1jUoZiZ9uFT4nYdI1j+/08VkVMvfInHRWYhOItYNLl/62RX6N/sUK3Bd9sx1qkLMhjGkYcQ8R6/BLZVcZjVtyRMI9o8H/JtxgqE46KiOK/7efWSwgZ8qSkEx25B7LnnG4a44EKWJcqq+v0xpdvXFuv62WfpoCgMXJbDkmhaKaaJIrWI0Fk2sL39GC/5wQTF676g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLNxhvxI5rOVz/I4jjztbS0cG6cP4+VzFn2nOewQUr8=;
 b=CvgDDrZSF4IpAI1h6wUe9PGdZtWGJR4R3SpFx+jRGsWpLUT0S/Fzjgk3b22p2AdDf6K2EQyqkbV/35y4WeZXQyoVhPceLyRCfXinTrrjippFZ5x70+oEsTUQ+iKk7fd/GbRhd4HhrkWaXNZwDffWnfFtRQ8uJpOSzG2rnh8zIhY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MN0PR12MB5882.namprd12.prod.outlook.com (2603:10b6:208:37a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Wed, 29 Jan
 2025 09:24:43 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.017; Wed, 29 Jan 2025
 09:24:43 +0000
Message-ID: <a4ed411d-3233-4d15-94a0-8da177633073@amd.com>
Date: Wed, 29 Jan 2025 14:54:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com, michael.roth@amd.com, dionnaglaze@google.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
 <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
 <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com> <Z5QyybbSk4NeroyZ@google.com>
 <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com> <Z5f2rnMyBAjK88dP@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z5f2rnMyBAjK88dP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::17) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MN0PR12MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea5bb74-e3f5-4fa5-f841-08dd4046c38e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTZ2TUFzRGlMY0pXS2tNbWs0OTFPM25RQ2hKNjM0NjZmQVhGQzd2NUpPSnF5?=
 =?utf-8?B?Zk9QUkRtY3NNbC9Iekp3R1BoYndlZWlWNGJvK2ZwUUVFV1gyNFF2VkJrT3dZ?=
 =?utf-8?B?dEJhNE1vMlhVbml1d3E5N05oWkRPYkVmQXNmVzlsWlVDcGhpMWd4K2hPRXFj?=
 =?utf-8?B?Zk5CL202enNCZXE0ajI4Mk5MdUZzcm9OUjl3cTdtS2IvQkx6OVQ2K3VWN0xV?=
 =?utf-8?B?WnJwZ0d4V0xuelA4M203d29OaFBKYitkcVRmT0d6NGYrbUpFYmQ3VUN1Rmsr?=
 =?utf-8?B?ZldQUEVLbVBVcS9hVVY2dG5FVzBOZDdENFlVbEpNRDZGQnJ0YmZCSkFsWDlC?=
 =?utf-8?B?Q01nV2p4WDNRdjdNZWdkTDBwMkhaNWdQd1kwWDBSbDJsZHRUVVV4SGNDeFBY?=
 =?utf-8?B?ZXBKdTB1MUVTNlRvZGs4RGRUaUwra3ZBYzVFenk0anE3bytjbmxLbzFsS05W?=
 =?utf-8?B?cGJSMkQrM3V2L3doYUxQa09zQVpNVDN2aHQ4MVdGMXd5cTFJNTlIeU03YVZI?=
 =?utf-8?B?VlBUZjE3cmJHZEl1SktvbU56a2EwQTlPMzc0S0hkRGZjQk8wSEthQXJyK0Nw?=
 =?utf-8?B?bEdmbnptUWdiblVCK1dBdXZXUCswK0J1Nm1KWkx3ZVorOU1sUWpNdTBWUDdE?=
 =?utf-8?B?cnRrbGJGUWZSS1pFZmV4YUNHMEVHQnRhMkE4L2dLU1IrTmRnTEJxcE13VU52?=
 =?utf-8?B?RjJjTVBvdGV1ZGdtSE1wMUJwdWc3VGcxMk9GMHhCMjY5bXMrWlhzRFNVbjAr?=
 =?utf-8?B?UjhBMEhZLzg3TFJUeE5ySGJ3MWlOUnlaWjFOQlFrdmdLQ3Q1U0VrdExhdHVQ?=
 =?utf-8?B?VitXeGo5Y2Zwc1dlZjgzSFMxbXJiaktPbjFhYmxJZDJPRkpYKy8xQW9zVTRS?=
 =?utf-8?B?RkFjME50S2ZMYjE5Vmt2ektYWWxsYW9Pd3BrWE5DVmxieDVubmxVTFBrR3Ex?=
 =?utf-8?B?TTQ5Uys4WGVrZ1p4ZmkyK0RENzJnUjZ2N0N3Q0VVZ29tamVVckthTnlyNHJR?=
 =?utf-8?B?b0pha1RWZ2xoZ2JtdGFxaEhzOXhKNFo5S2JkUnhnM08wdFRGV1JENm1KK2VP?=
 =?utf-8?B?MzVHZUpsMWcveGhOTjR4UTNBN1BYRzRZVk5aYW1tLzlEZ1J0T1lyMXRia2tj?=
 =?utf-8?B?ZEQ2TTZBNnFLb0FMWGJQTFJmNDR1M2pHVjRuZFdNUi9mRWhZM0JRR3JQa1RC?=
 =?utf-8?B?OVVaa25xS2JMcjdEQ3Q1NTM2ckpnSll5NG8ydGlaUGZKK3VaeXlSWGRQSnps?=
 =?utf-8?B?VmVYS3ZwaVJVRC9kUGVqNm5OMXVLVFBnQXhnVkZ6YmU5V0QzVVZjU3loTjh2?=
 =?utf-8?B?T2hpUTh4NDhGSWx2RytFVGdtTVh3Q2txWnpITW5SbHZaUDZieDlPMmM2QjZm?=
 =?utf-8?B?OURWb05MVTY5TFYxbllsdTR5RlVlWXdHSmxKeExOU1RzQndNVmxYQnBadHVH?=
 =?utf-8?B?K1g0cWtkYlVaUDROU0pmbVNDZDBoMFN5SUhaMnJEc0JDZUVsUTlHVDhXSDlx?=
 =?utf-8?B?N0pSakdPYmVOYWQydWc1R1p1V2FjeEFlL0lEVEIxTXMweVJsTktmNDNnNVBi?=
 =?utf-8?B?ekNGZnljTkR0MXE2eEJUcTRDQTNMdFRpNkU0VlQ3N3ZpOVRFdVVsYzZvT3Q5?=
 =?utf-8?B?NHZRLzJSMDlKQmFLRTdGK1o5VTBZdXhLanE2cEdBM29WemN0c1cyZitzV201?=
 =?utf-8?B?R2ZkSzFiaTErQzVWSWJIdG1sbXpOYUxmVkFEMHFGUFd1c2d2Z3lIbzh1a2h5?=
 =?utf-8?B?eWZaWUhZRkpmQ3ViZmgwL0EvOWIxWTRxTVRKQUpOTytYNWl5SWtsN3o2QnNy?=
 =?utf-8?B?b1pKSzRNNWxBUW55Y0U0UmNJbDdRY0M0Q3FaZXBXV29ma1N2ditWT3lma09L?=
 =?utf-8?Q?PtXaSdv6czaLl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkoybktHQks0alhJNDE0UENaOGxpdENTVGZDaEtxbHNjdlFscy9obXNsU1hF?=
 =?utf-8?B?UEQ3elNWRlY2dXloeHV3cGtDNWJKaytoWVJRUTU0UmQ5cjJESk43TEQ3amRy?=
 =?utf-8?B?dzFPYXNHZEZ1QjhWT3NEZnZ1WXZqUlkyV3ZtcHVlMWNWNlpLS2tNSTkzR1pa?=
 =?utf-8?B?d1hiRGhsMmZzWkFUdVdJQ1FlZEx5QVpQL1prSXRNTjNONnNxMnF5SnhKbVFh?=
 =?utf-8?B?MVFTNVBtbmNpUlpiSkFzaDFoUHhTTFhhU0dxOVBWSmVrMVdWZWZRWTU4YVZD?=
 =?utf-8?B?bDg2T044NEtwbS9RaTJNUHUwM0M3djVRUFBWTWJBU0pHOHhDbDNsUENKQzRr?=
 =?utf-8?B?NUh3eFgwbmJlY1F4ejJpbWoyZkx3WDNnYmU3TmprZzZNNm5qVzdKeVFwRGIz?=
 =?utf-8?B?blRMQ0NreGVsem5lZzJJTlVydGRreXByWi94Y1pnNzExRGNKeXZmUE5kdjZS?=
 =?utf-8?B?cFd2WUxKMkZjTzk1bmxieDdCU3ltRVRQTDc1M2J5clV2bnlOWFZIWXF2d3h1?=
 =?utf-8?B?djRSZUg0bmlOUDV4S2IvQm1JVGdDL1pOVkVONTdQNkg4T2MrNWlWdXpXU2Z3?=
 =?utf-8?B?ZDZMUkhrRWZmSVZDUGNiZ08vd29DZHVHOG9wK3VpTzViTlh6WHNnY2hsTFVk?=
 =?utf-8?B?UWNiazVtTXBPSVpzZFJmSzIrcnl5M2s4NnM4NE5Ba2lnZFh1YWl4NW1lUDhO?=
 =?utf-8?B?V0xlVEQ5WERYTHVKZmluMVEzVWkyM1hLY3JSUWlLNUUzMlkyNzJYS283bk5S?=
 =?utf-8?B?RXZkTjNSR05kWmg3Wk1Bc0FRelZOWFVxME1OZ1pZUXBQRzkzTkRqWkRlYlRl?=
 =?utf-8?B?SXJhU3psRjNVa2dLRjZuVml6Y3NKeVh0MVUvcXpSbUc4dHlPazZoMnBQOTFO?=
 =?utf-8?B?TVhHOXU3aXQzdWIxdE5xeGtUWFNteUFzTjQrdUxDSlhkWDloZGRTUU8zSVZx?=
 =?utf-8?B?dS9KZzJkMU5HSWlWRnJ5YmZIUFh0Ym5QWGVVT1RiS0ZvbVNva2JBV291ZzV0?=
 =?utf-8?B?aTl2TzFxUDFUSFNRSzJlNW5tV2NCMTdyZzBkSDhFMGkrby8xZ01yaEVPK01U?=
 =?utf-8?B?OUdwYnpldVk5b1NLQytqWVhPcVRVRkF6WXBjSy9Tbmp2Y2YvbzczSU5xSmpq?=
 =?utf-8?B?ZkVUbnp5aVpaRFBKaXpzRkM1NWdDY2oyZ3pBdlBFNUpEMXFhTkZ3bENxUk14?=
 =?utf-8?B?NXZiNkd5Zm52Qm1XY1E5WTliUHRjc3k1Y1JJNnBYU0I3UXdBTFRNMlBDYmJI?=
 =?utf-8?B?d0Z3QTJpeVNiOUIvWm1sRVZDeVJKaVVWRk0ydWJWZTduNDhQeDZoT3J2WndO?=
 =?utf-8?B?ZVJid0tmYjdnckRzd2VPZkNqMnRTL2pxNU1zenNEUTRBdjNFWHh3dWlaaytL?=
 =?utf-8?B?WDNHSDVHM2RrK1JpZkhZRTJtekgyNi81MEx2UmQrc2g4U2o3R2Roamc4b0ZN?=
 =?utf-8?B?NDVyRnJJditkbmtjeGo2dnJ0TDZBbmlGVk9aRGcxWmgyV0t0c1VRRHFpSmZV?=
 =?utf-8?B?TVZxY3pieGxNdWN3VUZ4OTg0TnBIY3FESzh3cG1yMzZLR2J3aEh3YnVEbWRr?=
 =?utf-8?B?ZEFHY3FhZUFDWnNDdWovYitod2F3eVQ5dGc1NEJFcFJIWXlzQnVob0U4ZXZY?=
 =?utf-8?B?emdDRkN3UUNSRjhEQkpQQjdNS3ZNMFQzVkRqNHFtS1ZTZDVzT0laLzFjZ1lE?=
 =?utf-8?B?R1hoN0VZRis1Z2dodnlYVnRzeHJvQnZaTkZQY0ttNWNpSVA4cFMyblFuN3Av?=
 =?utf-8?B?N3hzV0pQQkpock5oUmphc2UxZk5zQzZFU0p5Vnc0Y2VLUFN5dlNQREJUR2Y0?=
 =?utf-8?B?b2w0QTFuNU5XUjFsbkVsOGh6Qys0Zk1BWWxaaXdDWGxSZm9xaDE1TW9wUDlr?=
 =?utf-8?B?czBha0tXN3BITzM3K0NLRGF0TkxzTnJPTnd6ZWdpVG5pbDNlZ3BmZEZNbDUw?=
 =?utf-8?B?d2JCMzl6VWxSVFNSUU4yVSs5Y290U0JBcDUvdmd4YXJId3FBT0dtbFhWYnZG?=
 =?utf-8?B?WjdrcUZ2bWFVWFBkS29mU2J0Sy9ZL0FYUXovZ3FidjNBbGtXMk9EQmFneklG?=
 =?utf-8?B?WUpMU0RDS2MxS2IzcTZDQitydGhINTFXYVhGMTV1ejdJSkZzYXZuZ3pNUUlr?=
 =?utf-8?Q?Xjgss7X/9aenEIUJSid+SogC+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea5bb74-e3f5-4fa5-f841-08dd4046c38e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2025 09:24:43.2707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9cV2fAYAQuBry6RdRMB79L3svzBl5wWSxUjTTtBrbRl8Uo2v8eRqk6/iK0WWttCZ/g6/BLTK87dXx+yrkvwQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5882

Hi Sean,


On 1/28/2025 2:42 AM, Sean Christopherson wrote:
> On Mon, Jan 27, 2025, Ashish Kalra wrote:
>> Hello Sean,
>>
>> On 1/24/2025 6:39 PM, Sean Christopherson wrote:
>>> On Fri, Jan 24, 2025, Ashish Kalra wrote:
>>>> With discussions with the AMD IOMMU team, here is the AMD IOMMU
>>>> initialization flow:
>>>
>>> ..
>>>
>>>> IOMMU SNP check
>>>>   Core IOMMU subsystem init is done during iommu_subsys_init() via
>>>>   subsys_initcall.  This function does change the DMA mode depending on
>>>>   kernel config.  Hence, SNP check should be done after subsys_initcall.
>>>>   That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
>>>>   And for that reason snp_rmptable_init() is currently invoked via
>>>>   device_initcall().
>>>>  
>>>> The summary is that we cannot move snp_rmptable_init() to subsys_initcall as
>>>> core IOMMU subsystem gets initialized via subsys_initcall.
>>>
>>> Just explicitly invoke RMP initialization during IOMMU SNP setup.  Pretending
>>> there's no connection when snp_rmptable_init() checks amd_iommu_snp_en and has
>>> a comment saying it needs to come after IOMMU SNP setup is ridiculous.
>>>
>>
>> Thanks for the suggestion and the patch, i have tested it works for all cases
>> and scenarios. I will post the next version of the patch-set based on this
>> patch.
> 
> One thing I didn't account for: if IOMMU initialization fails and iommu_snp_enable()
> is never reached, CC_ATTR_HOST_SEV_SNP will be left set.
> 
> I don't see any great options.  Something like the below might work?  And maybe

We did explore few other options. But I don't see any other better option.

Below code works fine.  But we still need to handle `iommu=off` or
`amd_iommu=off` kernel command line. Below change will take care of this
scenario. Does this looks OK?

----
commit 8e9296346e8f6a0831a5f6076c81a636bf044a41
Author: Vasant Hegde <vasant.hegde@amd.com>
Date:   Wed Jan 29 14:47:04 2025 +0530

    iommu/amd: SNP fix

    Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada0..08802316411f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3426,18 +3426,24 @@ void __init amd_iommu_detect(void)
 	int ret;

 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return;
+		goto disable_snp;

 	if (!amd_iommu_sme_check())
-		return;
+		goto disable_snp;

 	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
 	if (ret)
-		return;
+		goto disable_snp;

 	amd_iommu_detected = true;
 	iommu_detected = 1;
 	x86_init.iommu.iommu_init = amd_iommu_init;
+	return;
+
+disable_snp:
+	/* Disable SNP if amd_iommu is not enabled */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 }

 /****************************************************************************




> keep a device_initcall() in arch/x86/virt/svm/sev.c that sanity checks that SNP
> really is fully enabled?  Dunno, hopefully someone has a better idea.

That will not solve the initial problem this series trying to solve (i. e.
kvm_amd as built and making sure SNP init happens before device_initcall() path).

I think with your patch and above changes it should work fine.

-Vasant


> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 0e0a531042ac..6d62ee8e0055 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3295,6 +3295,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>                 ret = state_next();
>         }
>  
> +       if (ret && !amd_iommu_snp_en)
> +               cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
> +
>         return ret;
>  }


