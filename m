Return-Path: <kvm+bounces-27464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6009863D8
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3BE289FF4
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691F579E5;
	Wed, 25 Sep 2024 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hZptCDyx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45631B963;
	Wed, 25 Sep 2024 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727278893; cv=fail; b=nEeHas35EJxOe9bPE3zTeWcAhdU/P8ckGhbPwDqjQk5+rI2O0AHTKQZ4d3GI8UotMAwidyOSSdHcNFesqZaye4kzzq7SxL60taQbrbTTDuaUOAGUWtM1TUXBcC/uiXEgQixbMfOeyeOJWkgOypqmuMy1cfIaLH2R+kxzAQvq0uE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727278893; c=relaxed/simple;
	bh=PnebbK0Y0du9w9Q7wV4sXUQdJ5IukyTIuQ/NRP6t+0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IcmRh8ObXj8/Xw9C8EWTCyGxqqz9hCKu10/RRDhrKd42s4LbVg9IKaMxJPoTdtCcCmvAu9/WrcBWgF3y5rj5U9LXJG/hY6U0dQtEsCWTVHOSLTqzb/im2tJFWwl1mAsiQVgJGzD8+CSo1n0kWlqNIXZVhn1ywasXyDrdK5z8HCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hZptCDyx; arc=fail smtp.client-ip=40.107.95.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHyvr1Fj72laq3qtwfjWH9JVecKhUXWqzs6+mVigqAukgniN69S0N5ODFkycMlDsijwQfgxYHXEoIpPty04pr7oqKDAt/EHZHmK3CeSG/u4ITm2pck/Qres6F+perqaaCgMQS6XaPSrDkTyGLCWUSgVqKxdNDYlp6LibDq0zsqiubn9PSkuGz7EZCTqCLtvRWk0jT02zrK+bvSEGzKTLg81C/3ZkWw1GNsXuI2gFqZAdHfeFJzEtDs+BDcHcV3hYdjT0LdNc1uzhIubP8FEA0EpyqWDZ1ayK2IjYT1FoYSYg9kzZYUhhqfViiXZncAP3zFY4mwXZYOzIChNJxbX9Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xs4LZivPZGMly2pzyL8rAK9QFNP+e/UBOFhNRIOkR90=;
 b=CVdonFqVIT2GhkL9mLaLLXc/xCemBe/WOKjKpq8c8TPJFY6rDgcQYo70h1n3l1mx9vTC1dlBa/KwZ8l/i4KEFfj1DHQB3YtK4Cz7T1mYDXON+Ye4OD5P8COiDQ74XsPluvLlPb+WSE5XHOXFu8cRGku9m7A9ljGrgeSCUhLG7wGHsPtrboVvsMjcm+u48ZIcJKUyPQIt+FgbWITZ/nx5ilaJfWWYaKS2g5LMAODKeILhnxX3XR7U1qF83vyH9vkcUbiUXn2eAzZ1RdtLyCSbd+2RYEICKVoEnWcZfVLsAIikhTzno0j88aX/7EwKO0zfncOK7cSLIZRhWA0YfOHQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs4LZivPZGMly2pzyL8rAK9QFNP+e/UBOFhNRIOkR90=;
 b=hZptCDyxrHgwdJhHIefCg3nGlWak7QPAN7MD0HFVtvXb3UMiRQrxDmlUnXgR0PJsJz/6PRvVCb2g3Qc41Gtkh7arh+uYATmKvOW/1FbAKh6CUnJ8LBnWy4HK+LvapBHJ40edPqyyyPK7AnIK8vUDH3Rjw2XbqjuXpYvwoKI/MUSj/pcPbGQsGOiDlz0Ewy7RUmpCmRWdMZzYK+QuNaElirGb7haxo9XcNnMa5qEcHxkyENSNKWtCOK549UBxG2tIaKgsvXKdr8R+ugQOJ0a8+JD6UKPH+yohwxMnRw2n2KRZI69l5JuQtUwZlIzHXUBT7dqw0NSUep1OBNoc02u+kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB7306.namprd12.prod.outlook.com (2603:10b6:510:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Wed, 25 Sep
 2024 15:41:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 15:41:28 +0000
Date: Wed, 25 Sep 2024 12:41:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240925154126.GU9417@nvidia.com>
References: <20240823132137.336874-13-aik@amd.com>
 <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
 <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240923160239.GD9417@nvidia.com>
 <BN9PR11MB527605EA6D4DB0C8A4D4AFD78C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240924120735.GI9417@nvidia.com>
 <CAGtprH__2qLkwu-FvKEECVDn=sek42rVLWHuin9cwSbYVAOi=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH__2qLkwu-FvKEECVDn=sek42rVLWHuin9cwSbYVAOi=w@mail.gmail.com>
X-ClientProxiedBy: MN2PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:23a::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: 541d4fdf-f52e-4ac6-c148-08dcdd78851c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1loeitXb2xYS2JFc3k1NkxYdkY1c1hjd3llS1dmV0FValpSTnRBM2hpdEhO?=
 =?utf-8?B?eXBiT2JMRmI3WGd2dXIwQi9QcnBjM3dqanhyYlUxUzhOSjE3SzZTUGhZK2pz?=
 =?utf-8?B?TGtMTENETGZYdWNsVG5TdlVWSjE5NGhPdXZnVXl5Y2IxWXpid0NWL0wvQUFL?=
 =?utf-8?B?UktKQmtUTDRGQXVOUHVuZmRRUUpuLzNNQkVoeWVxZW9GdWo5bFB1SXpsb3Rn?=
 =?utf-8?B?OE01UEJTd3Q1eFZvN0lQNkQ5dmd3LzROeHNDaG5qVndJVm5LM2JZL2F6Wkh5?=
 =?utf-8?B?SXlpTEpiOHpPWTZBWXRCdXhpN3A5b0ZLMUQrWE1pVXVOdU5BdFBjRzdDbHBH?=
 =?utf-8?B?WkthZnYzbEpsQkFBbTNpMlVFQkR3MUg2UjVlSlFZWENGZDVEayt6eFkyVzl6?=
 =?utf-8?B?SjhrMTF2UFhGemttdklLRnRmd1hBM3FZREZDOTZsM1FDV0NPa2Ztd1c5NkND?=
 =?utf-8?B?NThWUkM4VlRVUnVGZTBETTY0cmt0dFhyY3dzRi9DVDVhT2doeStxcVl6ZGZ1?=
 =?utf-8?B?L3c5VlZZbnVKaEJsVUpLcjRncllzNDE0aGNjWjBZb21XS0lmRWRmN21aTkNk?=
 =?utf-8?B?dExqNGVQRjZNSFBWZm02Q2EzMmNyaFpKK2tXWVhiUTlXbUc2Si9uSzlLMENx?=
 =?utf-8?B?QUQ3dmpPWW01RllYYmtlRHJ5WldKSWo3TkQ2Mk5jQU50YjFqRFNvV01jMDd0?=
 =?utf-8?B?RGtRL1FSQXh2YkROd3ZCcWtIWUwvUDV2N1NYaU5lVWVoYWUxYjd2YjdnaTJw?=
 =?utf-8?B?K3hlZnM2ay9xajBGRDRjRW1MMlUyU3RoYjNsVkxyNTJiMDY4TW9Uc0NxM09s?=
 =?utf-8?B?eWNLNS8zNEVhRktmU0ptNjhacnYzblp5djFieUp3b251K09qTkQzNW0yNEZw?=
 =?utf-8?B?MFNZMDNWMHF5Yk82eVhuN2YySCtzOENQTzdFYmRRQlo2QTl4T3paa3FyYkxV?=
 =?utf-8?B?Y2NjbUQyazU4bEUwcTlsYWNaNWxodUdMUi9EUXVCWW51T3hXUzMyem01UGpL?=
 =?utf-8?B?T3k5bXhHeXFuMmdqajB5QVJ5T0l4NWs4WkVXMXp5ZVdoZFBTLzdPc0doczQz?=
 =?utf-8?B?QlN0WEl6NVk1VmUyRXc3RUFwRk5tcTM4QkloWGJxRTY1MSs5bmdDNHNqQXM5?=
 =?utf-8?B?WjRSWGg3dHN0YW1wcm9DSVA0MCsrSHd2Uml2YTdERFgzc2s4VTZ5VzF5cjY0?=
 =?utf-8?B?NXBzaXMreXZQYTdkc050SCtZUCtBdm1STjNicU5KdWZaaXdNbktKY0x5aGp5?=
 =?utf-8?B?WkdLL1hON2tncm9mTnFZQUpQMk1NNk1XVmRZblZUUTNLUTNTVms3VUVxWE9w?=
 =?utf-8?B?QTJZMEZoaEV4WEhGSnloZUh4QUgwaTR2VkpZL0VydWhEN3dmd1B6cVRxS09s?=
 =?utf-8?B?dkdPZ1VEZnFzL0Vqd2xDQzllVjFLYnZQOWZOOHhHTXUycWVwRDk3azJlamhq?=
 =?utf-8?B?Zkcvd3o5QlVWSzlOTmJKVFVGSm9hRnM5b1pHS3doR1JvdDRid1FTRkk0ZFNw?=
 =?utf-8?B?WGpxNFRQQzdSM2FUZ2NtUjhhMlRsWG5FcVYySlB0aWhTYzJqMG5WRmRSbGNR?=
 =?utf-8?B?QWFsd0pDVkNXVVIvNjNNNjZLK0RTQ2RjbGw3RE9kQ0l0RGxUWTduaE1BZk1J?=
 =?utf-8?B?Rmd3WVpPZUhJSk4weVM3dXQ5NXpTTElyamtFK3FNdlhqYnIzZjhYUG44Qkw1?=
 =?utf-8?B?TUxUZ0hYcWZYTWNiR0VIeFNBN3g2czB4Nkl6L0FZN1RWak5nZGNpeEF5Vk9q?=
 =?utf-8?B?N0ZYSWtabzJZcW1mUjNtTzVEVk1BWGFoWlk1U1hDemd3UHNBUFNwOTI4VEFB?=
 =?utf-8?B?cEl5OGRUMkZUWUpja01wQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGExQ2NhSmUwL0MxcExQa0hoT3JMdVVWWjhEVVBMSTFCUTBzKzhBMkh0Wnp2?=
 =?utf-8?B?N1BqaFM4V1NrbmRRalY3Y09wOHRtWjcvdGFJTmtlV2UxNXhIb09Ud0tuZVBC?=
 =?utf-8?B?KzcxZVBKSE90Y2w3bUN4eXg0RkM5RGMzVHlLT1lOdGdrTk56dXVneCtPZVRD?=
 =?utf-8?B?SlJGYXhBWmtHbTd5S3EwZGllMThZck5BRFNzT3Jndnp0RDEwTkRxTzhSS3Mv?=
 =?utf-8?B?NjRLRjNJOUNKdUVpZ1Vac1FKSTlkSDk0U2JiZzg5RlRINk1KdVlEc29DRVAz?=
 =?utf-8?B?MThMK3V2MExRbkVZS0NQTWRBSkg3S2V1NmNJTGJVUnlIUkJUSWxGZjFNNllw?=
 =?utf-8?B?NkxOZFlFR3krS3ZrWDRRUmYweldreld6WEpaYzlYdW1ybnZ1ZWk3aEc1Umtq?=
 =?utf-8?B?cUxNWE9SMEJKM3lnQVQzT0lHcmhoRDF5bEIzdGh6ZzRveDNWaVBMODNpYWlq?=
 =?utf-8?B?eSsyYXJ2ZVZ0dGxQN3d1c2ZaVDZFNHZHdXpBUEUwbjMxcVpIRkxzQWFkZTBl?=
 =?utf-8?B?M0xtai80a1RNS3RHd1RhdEdCWVJoQWhyYVFRbVVrTGx2MEQ4eklRQnJmcnIv?=
 =?utf-8?B?ZnJWekFYNnlHeEpMME5QS3NCVnFLOXNzSkdraFlyNGx0V0ZOTmNUY1lVSjhx?=
 =?utf-8?B?QnlFdEtieVNNeGFSTmZ4S2ZLL2RhbHZFcHZSdTY5OTZmWjBZaG5pdTNqV2gz?=
 =?utf-8?B?Nzh4bmo1KzBWYWNTNVlWbzdqb1BqRWJHUmFNd0E2eVo1MXhZeWwzZjM5Vnl1?=
 =?utf-8?B?TWFRSWhzZXM4dzUxOTBubTZIQUxPaXVnc2pHZlovUUUreGRQcjA3N01RSDRj?=
 =?utf-8?B?WWcyN055a0dVSlRsbVNoYmtvYlRNODBnbTRYdENQTzBKbkJLSjA0ZnZzcFNj?=
 =?utf-8?B?TnFZSnhzNVYzcjlvMTB0WnpzL3N2NUcwTGhwbXhqZ2dxSGl6NHNJeUFkTlFw?=
 =?utf-8?B?dVdrYjR6aUhWVHdlS2VzWUFMZ2t4Ym5yci9ucGNCQkIxL1dVZ2xJTlFTTFpL?=
 =?utf-8?B?ZG5GZFRETXZqa24weEI1elhSaExobnMrUmJwSzNpTHBGb2R2UVhMOXdzeTA5?=
 =?utf-8?B?aW5kc1J2VVpidXBHK1NiV3F3dWZ1WDNVYUwxL0k4VjZNbzc3dWl5bEhoeVI3?=
 =?utf-8?B?V1Z2OFUyZTBCSWx6TXJLcjlqdnZNcGxsYS9vUzR6YUVmTUwvbSsxS2FkNGtS?=
 =?utf-8?B?cFlDSkpiVzgwVnhOajJxMEZaQWhyKzV0L085QXpRSU9UL3BDUnJCSmFiTUZu?=
 =?utf-8?B?YXU0UnJ1TEpCNUh4bjZtSDVrYlorSzBFaWthMXBuYXdKQzNDNWZsai8zK2l4?=
 =?utf-8?B?ZWNRSzI2bnNWemVWR1dLNVNBK3NvaDFiODhQWUVhZk9xaGdvSmdoRSs1TXZI?=
 =?utf-8?B?dXgxcUo2cW01c0ZYcktGNkVHbDBlUGR3N1dkOGltNGxEdmxsOWRDcFBiTnAw?=
 =?utf-8?B?R3ZWemg5QmVtcUJGVzRQSlR3N3lLMTAzeW1KNXp3ajZabWs2bCtncHdiaC9M?=
 =?utf-8?B?NWwvSk9GaExGUytjUTB5MVVCZGU0cW4vYyt3TXVEdnZFS0lUY3JacE9FTnd4?=
 =?utf-8?B?Rm1Takx3VFlISUNyMXd1b21WTHRmdS8wS2FpdUVUTmRVeGtXUUxiMnNXUnJJ?=
 =?utf-8?B?eUI5Q3FXcFFVY0JQV05oc2labmlCeTYzUm9QWTk2UktLd0ZLeHZOYk9IRWJN?=
 =?utf-8?B?NVBTejhHV3dKZnd2WWZFbUxLUytnUzNOZHZDT0psL2taYjR1a083MkhvVW5T?=
 =?utf-8?B?TlpUOHhqOUd6Q1BXTU5OTGxBTS9INXhyaGgxbCtmNlZiYmVUSGIrS0NCL1Na?=
 =?utf-8?B?OU55Q2pTdWlmU05FRGIzajUrakxGZFJKdjBFOTkzcVA5SFAvMzZjK1BxSjVS?=
 =?utf-8?B?U2grU0lQZEpmVVBKWmY0VGFaS09JbkdWeTM5M29lQ0Jta3A0SXNxbXNBSnRQ?=
 =?utf-8?B?RzRGbE4xazNYSThwckhJZFBHRG05dlNlTGUyanUrNU9CRHBTUG9QclpRL1hk?=
 =?utf-8?B?em5kSEFNV3UzSjFZTjhNS0xoTkNiajV4ZUlNNE9wNmZqbTZ2bU5TZmFvcU91?=
 =?utf-8?B?dm91cnRCRFVDSHdRVGgrYndUZDNGWmlBN0xrSEV4dmdRN3JjRFJ1czJqbUdy?=
 =?utf-8?Q?yLoM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 541d4fdf-f52e-4ac6-c148-08dcdd78851c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 15:41:28.0151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORv0Q5t+dba59Tfr9pqLYEdXC4zpKok1Dml9L1LrJMP1Pm6KNR/QJVjGpvPEnkOX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7306

On Wed, Sep 25, 2024 at 10:44:12AM +0200, Vishal Annapurve wrote:
> On Tue, Sep 24, 2024 at 2:07 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Mon, Sep 23, 2024 at 11:52:19PM +0000, Tian, Kevin wrote:
> > > > IMHO we should try to do as best we can here, and the ideal interface
> > > > would be a notifier to switch the shared/private pages in some portion
> > > > of the guestmemfd. With the idea that iommufd could perhaps do it
> > > > atomically.
> > >
> > > yes atomic replacement is necessary here, as there might be in-fly
> > > DMAs to pages adjacent to the one being converted in the same
> > > 1G hunk. Unmap/remap could potentially break it.
> >
> > Yeah.. This integration is going to be much more complicated than I
> > originally thought about. It will need the generic pt stuff as the
> > hitless page table manipulations we are contemplating here are pretty
> > complex.
> >
> > Jason
> 
>  To ensure that I understand your concern properly, the complexity of
> handling hitless page manipulations is because guests can convert
> memory at smaller granularity than the physical page size used by the
> host software.

Yes

You want to, say, break up a 1G private page into 2M chunks and then
hitlessly replace a 2M chunk with a shared one. Unlike the MM side you
don't really want to just non-present the whole thing and fault it
back in. So it is more complex.

We already plan to build the 1G -> 2M transformation for dirty
tracking, the atomic replace will be a further operation.

In the short term you could experiment on this using unmap/remap, but
that isn't really going to work well as a solution. You really can't
unmap an entire 1G page just to poke a 2M hole into it without
disrupting the guest DMA.

Fortunately the work needed to resolve this is well in progress, I had
not realized there was a guest memfd connection, but this is good to
know. It means more people will be intersted in helping :) :)

> Complexity remains the same irrespective of whether kvm/guest_memfd
> is notifying iommu driver to unmap converted ranges or if its
> userspace notifying iommu driver.

You don't want to use the verb 'unmap'.

What you want is a verb more like 'refresh' which can only make sense
in the kernel. 'refresh' would cause the iommu copy of the physical
addresses to update to match the current data in the guestmemfd.

So the private/shared sequence would be like:

1) Guest asks for private -> shared
2) Guestmemfd figures out what the new physicals should be for the
   shared
3) Guestmemfd does 'refresh' on all of its notifiers. This will pick
   up the new shared physical and remove the old private physical from
   the iommus
4) Guestmemfd can be sure nothing in iommu is touching the old memory.

There are some other small considerations that increase complexity,
like AMD needs an IOPTE boundary at any transition between
shared/private. This is a current active bug in the AMD stuff, fixing
it automatically and preserving huge pages via special guestmemfd
support sounds very appealing to me.

Jason

