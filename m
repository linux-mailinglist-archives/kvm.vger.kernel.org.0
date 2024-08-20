Return-Path: <kvm+bounces-24664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C56BC958F26
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 22:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB5AB1C21119
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 20:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324251C0DCA;
	Tue, 20 Aug 2024 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GWh1fDzT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888CD1662F4;
	Tue, 20 Aug 2024 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724185306; cv=fail; b=dkvVYqh3J8l0X1BqCldIEeMYizHzWw2V5IMxxxEEjd79uzLBDQhFeBflMhmEmrl8A2OHG0Rluyc3z2MPbtcdOhk9I4mhA6Go7v6FWKtv+lw7FnAGNJPt1Kz86eKqIJHAQw53RbghAm8azkU58mdfcM5PjDdg97jqmwWoNKLrBnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724185306; c=relaxed/simple;
	bh=Lm9lj5QlMyYDej3ifJW7CVewo+OklnveGkLIBx6YG48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jqlJ7XQbhE+EYksQOaAHwJ2KfAUVvTzJp467KypH1e7gfCgfKWCbAt1EmVlZ1ijbDHUPsnbgX0+P6/YivwAuOmHS27SjQ/fDxasZuIuIt9V8QnjYQHGPQqIft7+jOdKlQcxERsdf1nIpC7xb5SoQWJR0qP//C7Qrd/2kpEs0lC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GWh1fDzT; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aTIBEIgh3lWuJ+hCjL2mXOQ+rnzJJpEcRRZJIulKZoMy/fNlknTxUKNx1zgtR1xtPKEWq6vbi+rb60HnuCeVB3Npzjij9XYl7twtMDGrMuaePhliIKZDQk3abJ/Mmc+OWF8ZyHUIcWeV6/e2fZEAs0Xw6N0wxb0I8kDNy8rrdg08FXzD32wtJ88jtJm1fSa6q0LY1KfUErQ7RH8yQkjPpizHbjwfeoDzCM+FTWz+ZyKnKaaOVgkPB5P6w91cCPiVStszWPPLGYrjomnYIYg/MwdejmvMLerKLdHaMebucbA6Zy7r5eWpzUWmb5o69gGoGMaSX1MIn6G8xi8K5Qrbqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOP6ZND+MP+IMskSg4Hkv9aCthfnj1P/RlfttAs11Gs=;
 b=qGdp7dbHI8ni8tAb5z6l2aPnGr50WaZVx3IDHyaGa6F5sMCxmzkFnphU0rvPiJ4QJFAz7Iz9GoXV5PJb4ZKIFk/1emgrh4KOxW2iJDa8xBeOvPuEd6s7gRcZQMCO3M3py/+m2/ecjUW8arhyk3ZoHhKVvMSgEP/8ysvMyGjode75jEAiXpTpD4qkolUEsf2lXnnMSwEBEpA6wM5s/6LbTbRT+3qdQElN8haKOBI15pP0VBwBBsWqKRSq+W+qkCvxicDnlOpxO91UM0Fwb/ApRtJzaMpdj8vdyTp7atC4fxGFHeDaFLa87aTYGpYUkFsIY1tGorkMLdXBceGpWrtkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOP6ZND+MP+IMskSg4Hkv9aCthfnj1P/RlfttAs11Gs=;
 b=GWh1fDzTwVfYMZGxqQNitlGSRaNJKKpNSh2/yJuYy2smKaISpZzn/1FNPRnEjJKwxpWvSynQ8xagUiGnB4r+MoaUAK0QrsoGp26FRMnEbTm8AEptDxpHMRApCrjFGFlxMcJQYz0kJa338XUl4zvJJ1IrSPCxkYIAgGy39i6G9gg0cDF4a8myh5sLFdcW0Rno3Osj+IXXk7PAbPJeeBUoF60NzYqfk7pE8jP/4Mwm/hklkhsLqi48FQIg7BgpmxX8gnWruUiPH0hoN7GIWFynPi3kZ86bssBHarsbMf2aNdf35Tl+eCrCRZnMDK3IlvFHaObsJtR9WSs96Py1Lg9M8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ0PR12MB6927.namprd12.prod.outlook.com (2603:10b6:a03:483::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 20:21:39 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 20:21:39 +0000
Date: Tue, 20 Aug 2024 17:21:38 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240820202138.GH3773488@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
 <20240820120102.GB3773488@nvidia.com>
 <ZsT0Fd5FHS47gm0-@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsT0Fd5FHS47gm0-@google.com>
X-ClientProxiedBy: BL1PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:208:256::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ0PR12MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: d35ca7c0-5e56-4e8a-9712-08dcc155b2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGJaWUxweU5ueDZvMlNrRTF3OHhRdmhEVnVKYTJhTUU0OXAzM0NRYUZHYU14?=
 =?utf-8?B?MVIxOUh4N2dFcWU0d2JEeWp5d09HZGhteGdDMENJZkRMUXVIeEtmWGRlTmtG?=
 =?utf-8?B?T1FwVGhEMkhhdWIzMFlyOFpjUXJVRk5PN1BvYmpQR2lTejV1NUx0Y29Wb3Vq?=
 =?utf-8?B?d0tOYldCT1FYc3ZkaHIxT1NTTHZOc0tvMmxDZyt0clVCS3ZVS1lmQjBMZFhs?=
 =?utf-8?B?WTdBdjFLMmZxTHpZK0xWNG0rL3FOM0R4enlQZ1psTHN6emxUTTZ1VmVyYkM5?=
 =?utf-8?B?c1U2UUwrQ3BtUW1RVTFtZHV2eklxM0RCckJxY0JDeEQ0WS9IYU5rS0UvRnBZ?=
 =?utf-8?B?S0FBc20rWURuUENIQTE0VlZWeHpSVERFZDVyZWhDbmd3RW1iL2Rtb0Y4NDk4?=
 =?utf-8?B?T1ZCaUVSVWNrU1J6ei9nZ1IzbCs0bktydTNFb2RyeXdZK2dzZnN5b0xUVktL?=
 =?utf-8?B?OFNROWdmVlg1M1pjb2tYRGlKMndMR3hRUW9VVGhQK0c4RlhyWnA3emtOSVFz?=
 =?utf-8?B?MXBWZmNDV1ZBZ0VDdTJCZFAwYW5WWEpWZ3h1L0lLQnh2SlFMRlNlUWMyQ0k2?=
 =?utf-8?B?S1VTajRNbVVGVWM2WEZxd0VaQmpnZXNNUTc4bzM3Q01malc0c01yWEwzVXZC?=
 =?utf-8?B?WTU0dU5KMTdIY2lraHNsUVdnTFhhWnNzalRVTjNLKzBsRXNOZ0wyRC93bGlT?=
 =?utf-8?B?a0tnT1E2UmZCWjRJSGNOaVVnaUIrRFZETUVxRWM2OHZPV0xXeS9pcU9tczI4?=
 =?utf-8?B?bTJNZGhqVEwzeTMyVnh5b0RZNDI3RDNZNFl5VmRSWlVtdU5oUkowVVcxTkpN?=
 =?utf-8?B?REhVZ2JMb0s1eHU1L2hncmpEcGJyNUtkV0RUV2ZSSEIxakx6cE01MFl2Wit4?=
 =?utf-8?B?ZEN6R0RiZlhDQUpaVTJvM2tBZVBKaUIzSDlxRFpsY3BCMXVObFdSZHFRaUFa?=
 =?utf-8?B?RTBqRGlGWmd5bjNwNVgxSEpjZTBhUmpTMVMxZGcvNnhmeGlRUGNNYnVnUndT?=
 =?utf-8?B?Z2V6RXZOYnh0VnVhU1I2Vkh2eEh5a3pXN0krS0liOVJSWDlLK3ppMFliWlVx?=
 =?utf-8?B?Mk1yVEI2dWZ3MXNncnkrVFhjQ051RWk3TFMwVW5Nbms1Snp3Ri9lWVFOT0U1?=
 =?utf-8?B?TGl6a2Uxd1FVbk9ZWHRMYzEwcm1XQWJzc0p6SzNMUCt5VXo1SjhXd3Zyc1hO?=
 =?utf-8?B?UXdMTlRvZ21aVDVyTUoxVU9sSStwamMxSG9kbHhZM2VWK3J3eHNXRnBZR1BR?=
 =?utf-8?B?aTlZZUpVYVRFK0lOaWJta1dwWTdzSGp0SVVHSXRjalN0bDhPc3lOOG1TM01J?=
 =?utf-8?B?TDluY2NvQlRxNi9kUE02V1JCeFZVYmdXK3JlYnpwRDAxYmNFc3d6M0dEVFhM?=
 =?utf-8?B?aEJRYmRyWVdDejhDcU10ekY5dDZtaEc0NlQvREE4RWVITEZzZ2ZxMTJJbDI1?=
 =?utf-8?B?UjNNMWdWRDFkMTU0cWVGeGpXVHRvR3hwbkFCUDJsN1RHVC9zUjB4NFpSU21z?=
 =?utf-8?B?bDArb0MySEF5blVDTEt0dGNDMXlveGt1VVBEQ3hObHhYQXZYR0pLbHF4OURX?=
 =?utf-8?B?K2l1UmJIMWRlQTAvdFNEbUowQ1dGY3ZDSE5nUFEzV0ZtdjVNZWIwUzNkWW1F?=
 =?utf-8?B?REVidWN1aDcwdHczSnpwTXNlV1BHWjBONEYwa0F1c0RmZ3lQUVU3ZEc5aExB?=
 =?utf-8?B?c3RIN0YwODVzUjZMR1JFUTZ4YkFlQXFWU1d1cmExUFNqSDNPcTVQTW83QWJW?=
 =?utf-8?B?cUo1Q0pQb2JBUjExT0Rla2dhU0RTK0JNN0d6T1BYWWVFUVNiYzV2Tk5tOU5T?=
 =?utf-8?Q?bOPeaR8ty37eSjJiZ8D9jf3YsDga929ywJ/IQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzJvVVJYd2Q1Nk5YT1h5dmtZV1NoTk5iMnA0UGxHZWNHRWtId1dUUGswNTNF?=
 =?utf-8?B?YlNEelUwQmNrUVlxRGJrd2kvYksrczR2YXdxZDFSM3p6bVhxOUxtRyt0YWFa?=
 =?utf-8?B?dGZvL1QrSk5vRHFZNGMzaEoxaDA5MzVjVnMwSkVDZTdjVWtvK1JBZDJYRHFT?=
 =?utf-8?B?dnZwNlJETnJBaTJmNm9oLy9Jbk5UMWpsYjBTQXMra1dJQXM5UVNpeklpbDQ4?=
 =?utf-8?B?aGh1RnFNMVg2aEllV25oeWtjaW10TWZSeFBxZlRCdkZ0U1dKVTlWdjRla0Qy?=
 =?utf-8?B?b0srYXIzazZERy8rL3c3amMwOExac3lUbFNLVUNibjFZSks4bGY2WGNHK0Vl?=
 =?utf-8?B?VzFXTkgxK2pFVFU2dlUxMkJZQzdiNm1jUHl6VXdWenZhb2xmeU9DUm5xTjk5?=
 =?utf-8?B?dFh2SnF1emQrVGhIQVF5ODcwcWxseElqSmZUYjhTN2cyVmxSanBSbVlGc0cw?=
 =?utf-8?B?UFRxbFhWT3dzaHpqTVkvR1BXWjVpRkZBNklEc3BoU3F0MTZLYzBwYzhFOW5E?=
 =?utf-8?B?RWRDS3c0QnVMM3NNUkF0VW4vbHNnYkg3K0F4bWFzTkp2akNxZ2Fydlo2eStt?=
 =?utf-8?B?cDJCMm5qWU9UaW1lRUlTbFFqS3pHd0haS2ZQYTNaSUdCT1RxdjZKa0ZIWUpm?=
 =?utf-8?B?VmJvQU5yYnVqL3RPejd2RVFpc1ZzMDAzakNtTm51REhKcUgwS2E2MStHb0Ew?=
 =?utf-8?B?VE1WdjZ4SUlNakxzenpjajVOS0xpZHFqTVdOWklIS2pZcGdoNzlsUUQ3cm43?=
 =?utf-8?B?NnVVekltNkZnbWpwK09XRDFjV0FuSGxKeG9EanBHY3FuY1IvT3FBekZVdGs0?=
 =?utf-8?B?MDZJcWt4WnRkZXhPUG5odzNnY3Vock5WVkFlUVdEY1llNWxNeDV5NGdWY29s?=
 =?utf-8?B?VnBWYit5WEQvdTJjbWlqSjhpR3VQQUlzS0ZHTGQ4L05lamh2YkZtWXFORW4w?=
 =?utf-8?B?UncxK0Z4UlN4WVE5Nmk2RkMyNkduMTZTOXYweXZONmxwL2FTRTNBSHhZSGEy?=
 =?utf-8?B?b0xlRFZIUkdNTWR5bFFiaVlSMWx0Mnd4RTV2Q09ya2pmNUVPWGZRNmI1L1BC?=
 =?utf-8?B?ZS9vajdrSFlYcXJpU0t4ZzNjRWVieUZpUXFRbkNpNUhpejJFNWQ3c3Q5eUxE?=
 =?utf-8?B?LzV1NS9YMGs5dWtUeGFJd3NNTHBJb1MvL2E4SXlpNkJ6M3RzVXBoaFRIejl2?=
 =?utf-8?B?bjNWVTN0c05KYnZPUTU5bWNUM1lqN2RDZ0NucFNpNEI0dno4UHlDTGNrRUd2?=
 =?utf-8?B?VFZFcUt3QjJpcG1HVzBsZ3pOQlN4VG4rdzQyYWlpcmdvT2k4RVdVRFI0UU1L?=
 =?utf-8?B?MU1TY1loVW9jTkhQZ1cwMWN3Q2cyMFlVdVhYQkx5S0hBd1dqY2ZsT1VRaFpZ?=
 =?utf-8?B?Wkl2R1h5ekNoWFJZNk0wbE1BbjI5VjBncDdGMVJpbU1aSStzUmo1MFUwUW1L?=
 =?utf-8?B?OVVQMXBqdlNDYWhKZWlzeGpXVUU2VkVXZHYxcEZaS2lzUVdvU1RNTE8yM0dv?=
 =?utf-8?B?NDQwbW5MWnE0WEZoWFhyRUlBSDFqZHJnY0NPeDVXWHdUbXVzRU5CRCswQ0Iv?=
 =?utf-8?B?a1J5a1hTYXdZNGdncGJpZTRDRTJ6RG9DcGRVekFZMkM4aWZUZmthUWIvL2wv?=
 =?utf-8?B?K3I3Y3hORlRZWWlFcnlsaDd2bXJ6MVBIMEwxVmZpTlVzN0lBLzlUR0gzdmFL?=
 =?utf-8?B?dDk3eEp0Y21FZnlUbDlWSGF0YVF5bE1CNGkrYWJFUDdXUm4yYmU4S054UEJq?=
 =?utf-8?B?MzM4TUdNMzVRenlFQU1HbDVDcDluM3NTdXNPTEpCblAyWTNPN3hQaXp4U2ky?=
 =?utf-8?B?QmVrMVlCYVFueU83S3VyVDUyaWZsUEY5eVZrVGlSWVZDQXdrbmFJT0tJdjEv?=
 =?utf-8?B?VG5vL1BNTnBnTFNxZ2c1WUNOVU5TSDV5M2VRRytJZFRnRUc2bUYxcC9rbU9h?=
 =?utf-8?B?MkpML3MyUFVWc3dQandQRmFUSUhrR0FSaWw3TW1OdTdRN3ozRlVrY0FGQ3RI?=
 =?utf-8?B?M09CTUtob3ZSbTcrYzI4UU9GbHAzNE8ycFQvKzNkaEJJQVdnNzRSaFBDRlJC?=
 =?utf-8?B?M20wbHI5U09xZjVrSVdMR256a25DWFY3ZG9qM2tXZXYwd3J1M1puRklOcHR0?=
 =?utf-8?Q?QvmOrnM081T9LEGUaEBT/TU0Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35ca7c0-5e56-4e8a-9712-08dcc155b2ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 20:21:39.5366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsSBFM3T/b1GvIma0j19XkmtI4eSj+o3qMiN50jh07+XvT9MXBmNHjPImx6vOt/y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6927

On Tue, Aug 20, 2024 at 07:52:53PM +0000, Mostafa Saleh wrote:
> On Tue, Aug 20, 2024 at 09:01:02AM -0300, Jason Gunthorpe wrote:
> > On Tue, Aug 20, 2024 at 08:30:05AM +0000, Mostafa Saleh wrote:
> > > Hi Jason,
> > > 
> > > On Tue, Aug 06, 2024 at 08:41:15PM -0300, Jason Gunthorpe wrote:
> > > > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > > > works. When S2FWB is supported and enabled the IOPTE will force cachable
> > > > access to IOMMU_CACHE memory and deny cachable access otherwise.
> > > > 
> > > > This is not especially meaningful for simple S2 domains, it apparently
> > > > doesn't even force PCI no-snoop access to be coherent.
> > > > 
> > > > However, when used with a nested S1, FWB has the effect of preventing the
> > > > guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> > > > cache. Consistent with KVM we wish to deny the guest the ability to become
> > > > incoherent with cached memory the hypervisor believes is cachable so we
> > > > don't have to flush it.
> > > > 
> > > > Turn on S2FWB whenever the SMMU supports it and use it for all S2
> > > > mappings.
> > > 
> > > I have been looking into this recently from the KVM side as it will
> > > use FWB for the CPU stage-2 unconditionally for guests(if supported),
> > > however that breaks for non-coherent devices when assigned, and
> > > limiting assigned devices to be coherent seems too restrictive.
> > 
> > kvm's CPU S2 doesn't care about non-DMA-coherent devices though? That
> > concept is only relevant to the SMMU.
>
> Why not? That would be a problem if a device is not dma coherent,
> and the VM knows that and maps it’s DMA memory as non cacheable.
> But it would be overridden by FWB in stage-2 to be cacheable,
> it would lead to coherency issues.

Oh, from that perspective yes, but the entire point of S2FWB is that
VM's can not create non-coherent access so it is a bit nonsense to ask
for both S2FWB and try to assign a non-DMA coherent device.

> Yes, that also breaks (although I think this is an easier problem to
> solve)

Well, it is easy to solve, just don't use S2FWB and manually flush the
caches before the hypervisor touches any memory. :)

> What I mean is the master itself not the SMMU (the SID basically),
> so in that case the STE shouldn’t have FWB enabled.

That doesn't matter, those cases will not pass in IOMMU_CACHE and they
will work fine with S2FWB turned on.

> > Also bear in mind VFIO won't run unless ARM_SMMU_FEAT_COHERENCY is set
> > so we won't even get a chance to ask for a S2 domain.
> 
> Oh, I think that is only for the SMMU, not for the master, the
> SMMU can be coherent (for pte, ste …) but the master can still be
> non coherent. Looking at how VFIO uses it, that seems to be a bug?

If there are mixes of SMMU feature and dev_is_dma_coherent() then it
would be a bug yes..

I recall we started out trying to use dev_is_dma_coherent() but
Christoph explained it doesn't work that generally:

https://lore.kernel.org/kvm/20220406135150.GA21532@lst.de/

Seems we sort of gave up on it, too complicated. Robin had a nice
observation of the complexity:

    Disregarding the complete disaster of PCIe No Snoop on Arm-Based 
    systems, there's the more interesting effectively-opposite scenario 
    where an SMMU bridges non-coherent devices to a coherent interconnect. 
    It's not something we take advantage of yet in Linux, and it can only be 
    properly described in ACPI, but there do exist situations where 
    IOMMU_CACHE is capable of making the device's traffic snoop, but 
    dev_is_dma_coherent() - and device_get_dma_attr() for external users - 
    would still say non-coherent because they can't assume that the SMMU is 
    enabled and programmed in just the right way.

Anyhow, for the purposes of KVM and VFIO, devices that don't work with
IOMMU_CACHE are not allowed. From an API perspective
IOMMU_CAP_CACHE_COHERENCY is supposed to return if the struct device
can use IOMMU_CACHE.

The corner case where we have a ARM_SMMU_FEAT_COHERENCY SMMU but
somehow specific devices don't support IOMMU_CACHE is not properly
reflected in IOMMU_CAP_CACHE_COHERENCY. I don't know how to fix that,
and we've been ignoring it for a long time now :)

Jason

