Return-Path: <kvm+bounces-41595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FD8A6AE1D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA668A6A70
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1CF229B12;
	Thu, 20 Mar 2025 18:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qE2czymN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E9227EB4
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742497051; cv=fail; b=CUnjrCRVzi/li5RRjEvWdUYiqHskXgeM5s0fXST1wCofnMHP1gz34zalbd4bLv3Lk2Oalsq8rBthVFE7ydvrcu/UzDPbM7YDK7mONb3Qc3Pw4RicuUtgk7PDaHr7aFcGryRXLY52AQ5W//4zlhkKQnC3Fucutv2H+pXE7/ksgxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742497051; c=relaxed/simple;
	bh=HTVgz0bA8zrzBjpptBebCxlKioxcRArTDf/lq9SWiXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OZ8SWEFUPThlTo9UFKOcBzPPjVPZuha9CWKe+GbUXoH71Pjw0oK3ILmxczDwn/M71+/m7u5eCblzo/E7+j1vHXPy5AZ4HEC77g5kp8VNcYBtF5cvSmbwhVlU7aO9SVAisEk88k9dFW9cEUNuc4W3WxNvItLwL1tUbhrn08Pq6G8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qE2czymN; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w8y/HSzXtZF569U3V+WQuJq2y+Pa/i3hzMLkBFQJcmSMgWc1X8XymZkdFly1Lnpj59qzxzIBVC+zuHY7cb0YaLyiWSEO19vq56Z5RXQjLL/DtD77wkty0trt84KQDt45wrmixvGcmRS+0cP9sJunWRUMGw1+cA6T8wfCc3lPEGSjaL9gVI6iQP5XBEjAtsFjUUWrXZUwFt3pTvctbSHxTvr9AE7mj2KkYKRcvAWmV8JLzybjImNi9xcx5wxpfKAWmrgtHfHhjhdsoU+4LzQUw7tynPwrN5s+E1qoPlqJ/4ipagBrTHCSE50ttkF+AjKRuHpEJetEhofekhTYhOpIKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTVgz0bA8zrzBjpptBebCxlKioxcRArTDf/lq9SWiXA=;
 b=kvANs4uu5FEjmjIaWER3yMvg5o9mGKOmSjJo/8OolqDC6QYmffGXCEmb/xVUNInQ4je7PF5TlBSjh7LfhbF4+/uzMZoNjRMwUXswZgxkxQQ5XXsdE0Wwtt8u9M2xGo4tWvNjhOTubYiQCbWASEgPDbDCs9wroBXns9KeRt5IWWv92X0Q3k6PZoV7nTCsU3MRFzvhaWNO1kMoILfmX+7SKqop62MXpWHVFcw15+6Vz8MuwtmZmpfTl3XNshkrHS1BzzG4P1q37oWRXN0g4ZrjaVawnSs1bhHEebgONDLfht7yUNVPtBcTzH505wsJEx8y9pTwwq+p0CibsGeXwD6pOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTVgz0bA8zrzBjpptBebCxlKioxcRArTDf/lq9SWiXA=;
 b=qE2czymNFtpBho+vVdydfFVIg9uvyMwrQF7qpoPwA8OWnHVdnCp/9DllLDx2zDgTsU8D99Mfw0TXw+nFeWFWsfIuPGi6F0BWapy9ds1IU9Gtgp5OpMfxznXx6hhFbK2cRnPhGtdHVxmFGt32ox1gHpYk/y4B7t9zIT9S6bazymx8TRcYeYRzbWjq/X2nZh5/wQaKlw94uRU2kdRVNmS4dfj/IYZAAI52pEIeQ/gN9XEpxpAbhHppxJk/FGEs8ySFJn+WAlrWMMMG6HGZiYrpfL7QWOeIwJb7wi9lDHYzAasaRkKfLOHi5nmJQe89vztRZy+2P1I2IJ6tmYGaIl9TRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8875.namprd12.prod.outlook.com (2603:10b6:a03:543::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Thu, 20 Mar
 2025 18:57:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.034; Thu, 20 Mar 2025
 18:57:27 +0000
Date: Thu, 20 Mar 2025 15:57:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
	kevin.tian@intel.com, eric.auger@redhat.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <20250320185726.GF206770@nvidia.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8875:EE_
X-MS-Office365-Filtering-Correlation-Id: 1caf3e81-40b0-43ce-2d13-08dd67e10edf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uLnh3w/x1SXWwaJKHZp0iFlJQ7cvbjp4mbhwLzcgGV+p3TayazDH+6WK7F08?=
 =?us-ascii?Q?6IVj9gliuo0UyI6zSDd5syNq7ROYRfKwINPxcL8gxFDiXMvx95QDhNs+1V7E?=
 =?us-ascii?Q?tj6ZOefeRrefBVUwcmIYZxkmfsOwOzmkS1ZdrCvf0aI5hddMsLOwaLW0o6wa?=
 =?us-ascii?Q?N09emWxorswKWD4elWwcTAOq2Q6KqM7D5LF2NX5P2YWv/oSdQD8ES0ZNkFCw?=
 =?us-ascii?Q?INw8s1fKpBy1UneKG8qbf6pD8ZjhhUatmJyPSNERfiiFhT9RVttVjLIOx68+?=
 =?us-ascii?Q?oBgn12HkOCbFdNrYUbutE0sedDn9l69kp10CfFGnEgRzZkrE7VYw9QzF7myr?=
 =?us-ascii?Q?UA6erHC2Y3eQoI3egz8dTEWi3PleqYh0AwbucNX26xhY53ed4sfEzwekXPI9?=
 =?us-ascii?Q?M2Vjr6/RWs4N/wmahJxO8wP2UAhB0YqW+1aKzjFT7Ouv/sp2TtQLPqsql4dz?=
 =?us-ascii?Q?+G55LMAXp0yeCT0eW8tMQTCE5GPkALF4BvzoGISsl+eIJw0G4v3drslHHTpk?=
 =?us-ascii?Q?5qYSONyX+6oVelLCnI1dnE0mSkCZhOfMfBz4I0wAzN5QLM+X0YFlNdv/Gavv?=
 =?us-ascii?Q?CATeCmdoE7mDqDK0rnmzWRAqIhzcxTKX8SPNZUeTjnOJyVF28zLsBc9qFfAe?=
 =?us-ascii?Q?QxZOeLi0IFmnliN9OlrXn2xkLa3VOWuyBVdyjphxSFIf9PnEI5bmnqKPMFg7?=
 =?us-ascii?Q?EVbir1c9NyFaxfnFYaBFvENSmT7SQcc8bIeR97xhlLiMWjnbmDyekLNH62Wi?=
 =?us-ascii?Q?uoIpUXxr/znkO6QsIthsiCpFH1BIBl8ImMDlu8IUWkdEexw0k0Q+9dHdHART?=
 =?us-ascii?Q?KVzLJhxI2oTPsU7jmOhKaDLlego13wOlbE1TdgqBUkT46AReRsT9XGS8KMAn?=
 =?us-ascii?Q?J7Zi5ywA+EXABZpbWe+45FcXADypZn1AVc3asD9LdY0pyxdg+TD1UWIczs8O?=
 =?us-ascii?Q?+fb1VxrJ0uESyfkQG2C/WV/oW6dFHkY6gKCyGbRC64GDEu6GC3eCH4qjakoO?=
 =?us-ascii?Q?J/uEERX7SQbR9GWAVdYN9Gcxwozk57SbR0XsKVa62Nn0N20dgBHzfhhVlPGe?=
 =?us-ascii?Q?uHoQx1iqx/ofbsgP0gLQCRwNZgWSIHh+cfrNAgPNQGbF5Po/OA5Oa6+CtuHB?=
 =?us-ascii?Q?WQZRXxCB1qHRpXXywAVJRY2JAoqfJu6VoNKZZoINPgSsP6EhfGYL6DJzegxa?=
 =?us-ascii?Q?o68TCRg/LBdSmv6s1kOj65orH/xMoxVjuz+FyW0GoPQTvrFLxJdif4FH1Jd1?=
 =?us-ascii?Q?aSPktRfBWQOxtyWz9ng8p9GdtFIZKwCi4UYO2XVAKtCc0zdxXpd8H2UbTOgF?=
 =?us-ascii?Q?PtWc0gftMQImE34BCQXOjjuZHhPVtOe2rf4XgJLLv/j5/eeDeScPHRqi0G1X?=
 =?us-ascii?Q?CQ8lG4qM4gQqpRBkqwUkUa1iOMee?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xwEbqGQzRr+eGcYSspffStjW0i9+rw0Y3TlKLTZWC0J4ri/3fH9ir354a3ev?=
 =?us-ascii?Q?80vAI1el1rKlb2ixDUmp1HdzMCrwRQssUq8aAUIXM+81wBrSyMsYNMz//lf0?=
 =?us-ascii?Q?JW/HAp6nUQ3JTZrzMtlSALO44WpGJjyqWK3c8BOaeV3ygsZh5nR2tTBBi62j?=
 =?us-ascii?Q?71liGiJ2OMi6nkbMbD+X1TjJQo1xBxH1Qg7bSnLVqTvXlnYMZY8n28AfvC7I?=
 =?us-ascii?Q?2fYidHGRJA69Oo7/Sq3h8bfRT11WS4x/QjevKCURYgfKMqg3ZJIg3tvLfQlT?=
 =?us-ascii?Q?Ut2/UCKeIwotYAS0EDpjZytm63GnqkRQX3Drq3jvyS/Ud3n1TCRqPG4eFl1p?=
 =?us-ascii?Q?jFhEj/JFLjh/r+Vl+Si9J4kB6+Ab1Y6pzNWKSfFulnnm1I8aeYBj2SzueAsL?=
 =?us-ascii?Q?IvgcD29ZjBZNOPu8Jx5rrpxrdovNcVtwYW7TCGemRkWUpb7Yc3FmgFwOKpnx?=
 =?us-ascii?Q?9rAG421JrKey1sojbmHlK27eHZoX3KUdJhHgC27rQXEAiRAogWSi/XLftP/C?=
 =?us-ascii?Q?ByG1guUxmPhoLGRakkQ1QySzuANoGV/BN6iQllhM5O+7PGfTr7g/SbJ0U8Ka?=
 =?us-ascii?Q?njdVYJTBVrdT+/ZXyKg/nVWK3X/v8mZBNGESxpm9qNfprFJt/FAwUbxOxFx7?=
 =?us-ascii?Q?WmtD5M/r3i6oWobmbMc5q7oiirEkoI75GfmtWdVMPMyuGZ8kI9Is5h5ONS/r?=
 =?us-ascii?Q?m1f0jdOMDHpV+xtoSA0ZurxfYHMIx5qEKRa/jO+Y/EpW3leA/sCh2PoivRra?=
 =?us-ascii?Q?aQ7Z/G0IzebaAvSm2rbCIJ75qq9iWZ+yWjvE/90olzr+hW9epPqkWG8usQVk?=
 =?us-ascii?Q?Wqt6KnZ9cTGbu5Zvp1LUsWXodi771zseghAFWxfdvDPxXAWhd5wKkd5J5zwA?=
 =?us-ascii?Q?NOYgfOy1juo19iPVQlcN1AsRiqhkTarWBiwW++z7/5Q7i0sZ6H3tz3re0JKA?=
 =?us-ascii?Q?jHi8VvkSojWcJ3ZogWk7MlQC3yJ62yR8ewZYz0N+k/eXvhSiy+u+7XTxmSkn?=
 =?us-ascii?Q?sJi5ykqXaaYmY40O/mRmv54peNOSvNTJpNklTiVRQoVvbiIfe0ov624Ha55Z?=
 =?us-ascii?Q?AJgW+HRA3Nn4Q40083HDwSeFao2a171HMZvPm+tjEyVn/qG6veQIu9xyOfTI?=
 =?us-ascii?Q?ofzbEXEAUx9U3lymVSqu7UgIyUkkGYMK5eAepA3e1bf1bn98i7qlNErzOnvS?=
 =?us-ascii?Q?X0axJOZRRfRFSfiQhnEphp9V+Fy0IgKScid8EGE6+yqcwikt3M9IhkM1rl+i?=
 =?us-ascii?Q?fdqI7MuQBF3qNywxpXOAuOZTT+Ab83Sgtl4dNfW9PrKJyW/bC49iXrkSxJ5H?=
 =?us-ascii?Q?lWzDCHcn/it0hkMTdRWIkHIFPc8dluaBij4/WMmAe/yfA9ayRSdVeyZdgw40?=
 =?us-ascii?Q?wGXESlATvS6Wum5XaF36L6x1PED/qRnfGRG60QOFE8e+bmU6wJha0OeVcWpz?=
 =?us-ascii?Q?RVfbXMvox1CB1a0W2PISQw1AdqplsnpyEMMoXRlKjFQIiBGThhhR1blY9tSa?=
 =?us-ascii?Q?+stkxsEDscv2d4g64LdJkoX9F5dN2uEQ8a4pu1UpOvihwlc2VYm7w8NU6uWI?=
 =?us-ascii?Q?024R5D7nbLy/mT0CpMOrS1wyyNnJFmd4YAvP9KFp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1caf3e81-40b0-43ce-2d13-08dd67e10edf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 18:57:27.3642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mINL5yQNdF5HNfJrHBcUzxbt+4iniqgO03hmsBnJIJOvnF9EJ+tRfr/UVFvPQLgq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8875

On Thu, Mar 20, 2025 at 09:47:32AM -0700, Nicolin Chen wrote:

> In that regard, honestly, I don't quite get this out_capabilities.

Yeah, I think it is best thought of as place to put discoverability if
people want discoverability.

I have had a wait and see feeling in this area since I don't know what
qemu or libvirt would actually use.

Jason

