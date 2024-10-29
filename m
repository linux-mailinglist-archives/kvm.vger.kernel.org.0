Return-Path: <kvm+bounces-29942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE219B48D1
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F30D0B22E1E
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816D2205AB0;
	Tue, 29 Oct 2024 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="osoTmNvK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2C520514F
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203187; cv=fail; b=eZPJMt1J/Qs4CVP5IgDgfvmUJ7fyCjkEHmwzDjFLBjNzuZm8j2V4NMLMtNv9Av8KbRKFXk6CS9gKzJLdkSTpZgkiiLW0qYIuNF06U2uMhGeHW2xOzxzwhfiw9lABVvK7Hw4Qnb+KnumGkeexsY75Q52nyaz2E3hz82yJ/3wbGNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203187; c=relaxed/simple;
	bh=6c7L+kif1z/v+lLTWa63xn94rhwR1dPugvV5p++iDxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=k5kS5msvl/o3frdfYOy04TLARBrZCxMtYvceZHq4I05F3RwFjp9N+Ygk2t7lyM6vY0dx45hcUpf8e+wniQjw/wMAFltkQrb3onChgzBxVlRZFfMLXu6+Rh9SYiX88UxYH3/uwty0f9Bmy74sTdNZvCJebKC0rzTy+G/gX0R7mtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=osoTmNvK; arc=fail smtp.client-ip=40.107.93.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vt9pDyGP95s4HRTkBJrNH+CDEDdWAHA6aeRHgyP5OIsqRlOZJRozEZMRCZtF7cyjAWDXcwGqk+oFLmSSk4ycLwMa34ZusjD1YB9jKMjapVp9tkdz/AZ7t9EeUP/2Si6xHzDjbgMNzAjFtYTOXNd98/XtFvBckoEiHdqg/H6lmLMvbzUvYwm/4kjGXjz0uryf1jPVyVUQRoDlWSzcMfTyCkTaEqwgqGZT4rHYXAZFYqy+eFLX6ph8rQ7FJDuOCpgtwfRiBD/NUp5Ig7pGzvIrTLJROuxlDLSNy1sn+h2Ofh7x07zRn4I/eNBtTQNsVnynwVCxhGyU6C48qcUst+Zxyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0EvPQ0yK3PKBbTlRtCKmhum8LP2j9W9xLLDmG7bjP4=;
 b=VZjtAaUhbq8QmaMwrYTcXEXV61T8PZlgsDMHn7L+NMt1GIuNR4qqTgh0hBTbtUPKzLTG53XbkQi5lV1d94++ITFD+efJHlJb8+9g7mylS6GRBrx156Po398Hp6CWJfw+QDki+ZsgFqa0cRyOb2idl2npzFksDMAlw3nlLkl2kZEAxydi9Zgk6RceSEYgIk2lM7kNpd8ZsP2ZkKM4URRyJ7XJRN3mzUBeYfUvpv7AqtrmDbI/82Vf1eEsJXK6d2VJTT87A3s79wKwsMElMC8aTL9IEtQd9V4Uo2pWI9h8gcG7NgUL+8KyRCXCuQZwUEIJ/ICet2e3lrwG3ODIhNIHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0EvPQ0yK3PKBbTlRtCKmhum8LP2j9W9xLLDmG7bjP4=;
 b=osoTmNvKRVKdevVQ+HxA4Tpm1X+aXUBTwZ7Q8e5ShnX+GvybKKr8fvgtKF3wuOT+4DqhALR7ERxv13XUnanX2zGnSn/A0tpO0wGp8hjm8Z2EOeXJTpG7xLpbzrXFz/PfpOvIhyPk+ot/PIYPypqAdhLcItE4jVYCyb5eh4apJ29G8/zLrsjJB4EYvIrPYRd9Dn9oaBzQGQZVT/TVCG0XXYtFGe9nhqxa0k4ihOfDglAXrkRsl33gFRqyCUg+6kg36rfm1MHCgD5czMqC9GwIHLTkbE6VNDNiookDTWivqkQJ0LnIgzfm9i02p+j4+BNhvrt+hTDXml8zDkWtDUxHBQ==
Received: from BY3PR05CA0001.namprd05.prod.outlook.com (2603:10b6:a03:254::6)
 by SA1PR12MB7150.namprd12.prod.outlook.com (2603:10b6:806:2b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.18; Tue, 29 Oct
 2024 11:59:42 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::1c) by BY3PR05CA0001.outlook.office365.com
 (2603:10b6:a03:254::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.15 via Frontend
 Transport; Tue, 29 Oct 2024 11:59:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.16 via Frontend Transport; Tue, 29 Oct 2024 11:59:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 29 Oct
 2024 04:59:22 -0700
Received: from [172.27.19.187] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 29 Oct
 2024 04:59:18 -0700
Message-ID: <852d7d45-8ffc-4d94-89d3-209dbc8bfa34@nvidia.com>
Date: Tue, 29 Oct 2024 13:59:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
 <20241028101348.37727579.alex.williamson@redhat.com>
 <20241028162354.GS6956@nvidia.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241028162354.GS6956@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|SA1PR12MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b78d74b-9c9b-46a9-9e46-08dcf8112c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmxvaG9xVXNveDFlYUJXYXZ3UUJGa0ZyYWdDMnZZNytoZkJGMWc0cGZlSEp6?=
 =?utf-8?B?ODdFSGNDdWpjVUhsZWNPcEQ2S05HQjRpajJUT1djRlBMdmFhVEp3ZHZaK2RY?=
 =?utf-8?B?UEtpcmd2cFcvc21QVkxQTG9uYmxQMkdHYVlCM3NiMy9KOC9RdTNSYUtiVWpa?=
 =?utf-8?B?Tm1XaEdwbWtycG1Sb0NTN3FYeGVKYWZxRGFxcHpCL3QvUmQ2OXR5YndSQStL?=
 =?utf-8?B?N2VwSkljSFk4NjVqZnJuVi9uQ3JqeW5hcUc1WWwzdkgzMHNVSCticTlSUWZn?=
 =?utf-8?B?dE9SYS9mZHZuMDlyaGNqUzcwK29aSVdaUys5MnZIUVdtYVhIRXp6UjRORVI3?=
 =?utf-8?B?V1NVdWorS2RFYkZoS1RHQ0FwNzdrN0wzd3pSMTByQ1RUaVVaL2s0NUE0MUlq?=
 =?utf-8?B?a1k0UjA5RS9FVmdkemE4ZmpYd2FOcXhOR09kMUg2K1pDbm9lMEpEejZZbk52?=
 =?utf-8?B?NjdpTHBmTEFpek1BVUI2T0J3NUphTzE2U2d0MHdkWmU1SGUrRXFYbHpDSEZj?=
 =?utf-8?B?NVRzZXZnU05TYWdvc2hSN3YzZkVhc2hPdE0xNDFBUUNGcmhBb1JsZnkyOGlo?=
 =?utf-8?B?aUlrQ2d1WkR6MlJUZWRidFRRT3MxK0FJRitFT3FYeTdsL0hpRmg2dHFISTBU?=
 =?utf-8?B?ZjN4cFBTZitBQWJhSzdVeHhjWk53RDBTdloydWdNSE9YVlZxOUNKMWtNUDV2?=
 =?utf-8?B?OVVLSHJZVFVDaENtcTM2d0RCQzhYVDZPcjZlVVVuZlRZcm94NitXVVF4MzBU?=
 =?utf-8?B?VTd4TEJrbEVhNHNqUjFJWDYzR0E1UmdVQ0lBOFpla2xNL1c5SVU5NS85Uksv?=
 =?utf-8?B?b1dWTHhNV2p3QjQ3WmtoY3J2UVM1NVQvcmZ6ZmVjc2o1ejJyTTJtQVZsdm8w?=
 =?utf-8?B?YjdodWRhQkMxWHJ3MmMrazZ0R3NRa2N3c2FkMitWdHM3d0N6UC9DQjM4NTVR?=
 =?utf-8?B?dFZvUE9scEZ1ZVR5a01BNVdyTE1JY3JFRGdZbzUrSlJiVkdOcEVZNXUzSEhM?=
 =?utf-8?B?Y0hVL3pUZ0RxR0YrS2JkaVBxNXJsTGV2ZUlLTzAzcEJTQXVzQ0FLZWQzQUJj?=
 =?utf-8?B?cWd6VTBJdnFCSHVPdTZUYzhpVUpwZXlGRXplK3V4RzYrNFdkbm1GOURmbm9H?=
 =?utf-8?B?MUdCa25qNHZoT2QxMjB5UDRZam05WStGTVUrTHBLZ2hIb0xjK09XYndFZllJ?=
 =?utf-8?B?MWdYVVNSaGdKK0h1dzA2RzNtVlU5TGhaWFhjanExQXc5ak8xRnNBejBWNHh1?=
 =?utf-8?B?RktDalN3VDJZUWw5SUhOajl0Y1dpQWdnRnlOS1ZIcnNFRmxTRXR0eGplTUo2?=
 =?utf-8?B?SFBKSTVEb1grUko1OWYwbzNxRnd6QWY2YUpwc2QrZzJJd01wRHBsWUNMTy9m?=
 =?utf-8?B?eTVreTlEb051V1YrSnNEZFg5bkJrdVhlZVNvNzdGS1RRakEyRllGVDNXdGJB?=
 =?utf-8?B?TE9aWU5PZThSdmMxU3hMYTdhamxRcmh1MzhCQmFYNnJhM1Rvby8xRE1wdmxk?=
 =?utf-8?B?SFRzaDZkMTc5ak5QZHpjd2k3ODdPQnhYTitJMVpUWnJSQnl4MTJLVGIzUVBn?=
 =?utf-8?B?eE9ZTHBCaDVDKzB3WUYvT3NaZklhSDRJTDY0azVNWUltNnpoby93dzRDaGlJ?=
 =?utf-8?B?M29ORVo4VERwTisxMDBoK1AyOUt5MlBQRzlwQnpCUDJnak1jZUVmbm1WVkt3?=
 =?utf-8?B?S0pmSTZXTnVBT3AvUFhsQWxWVTl2OHBQWXVSVEpyQU1qcVUzVEJJVnRDSVB2?=
 =?utf-8?B?aVd0d0NaZFBtaUZoaUo2YjF1SnlhOS85WG1PeUNrdEswK3M5OWN4RlFFWm51?=
 =?utf-8?B?T1Z0WnlhOEhHSU05WGNMdmk4cnFGTXdZNlJzMit1WDExWnJqUks3eHZabEpX?=
 =?utf-8?B?RWNLRUc3bDIydnV5RTVISjZHcnJFN0FZb2VNcFA0ekEwMnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 11:59:42.0544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b78d74b-9c9b-46a9-9e46-08dcf8112c48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7150

On 28/10/2024 18:23, Jason Gunthorpe wrote:
> On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
>> On Sun, 27 Oct 2024 12:07:44 +0200
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>> If the virtio spec doesn't support partial contexts, what makes it
>> beneficial here?
> 
> It stil lets the receiver 'warm up', like allocating memory and
> approximately sizing things.
> 
>> If it is beneficial, why is it beneficial to send initial data more than
>> once?
> 
> I guess because it is allowed to change and the benefit is highest
> when the pre copy data closely matches the final data..
> 
> Rate limiting does seem better to me
> 
> Jason


Right, given that the device state is likely to remain mostly unchanged 
over a certain period, using a rate limiter could be a sensible approach.

So, in V1, I plan to replace the hard-coded limit value of 128 with a 
rate limiter by reporting no data available for some time interval after 
the previous call.

I would start with a one second interval, which seems to be reasonable 
for that kind of device.

Yishai

