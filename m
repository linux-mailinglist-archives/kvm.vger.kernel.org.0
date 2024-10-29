Return-Path: <kvm+bounces-29929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A78099B4478
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:43:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 686B6283BB9
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857432038DD;
	Tue, 29 Oct 2024 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SnUFh14J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41802038CF
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 08:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191419; cv=fail; b=jWYLU50xkyysWEi5f2xtQ4C1Rj6gVTqbAFRXTMdzKcMAzsaBYl5C61ppXkETCcX29LsPA783L0/yB24TFBoI4z/OkenrlH0eTNZzYiVQjovb86uwWPLnXyOs58INBfUbN68j4J59NVUMregwU319rVtxclOIQrwhwogn+xMH9X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191419; c=relaxed/simple;
	bh=MWerARhgAVeOJkO6c3zY7liJnN0gvndVj1w91zqojuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ULL7ApUnP3I3g0u6bEce7HVG6BH4VyzlXy9RoV47SelplrXEGy74KUWA8WDcuvBnKtkGbdNe1853KlbdJDUB9lUmurdAHEcRfPVtoXPPOtl1H6WjtVwV9z5XuhS7hvA6K4t/jDP5A1iOmLivn4uTx7H5PhxMvK0DcUAh2Al05Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SnUFh14J; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/7K7V3dC3JofOclz9OV5WZ/Oh9G1lgrQ0gWGwq/PyGoo8Qh1mB2X7EhqU/97GjIIUaUY5URIWyW6Lr7D1hGr/9I2RqxC+0oZ7YcuP7RmAy0VZaf2FF1B+H5rdCSFU89Cs3SQMuejqaxY9uy+dcboMhdOK5r9BgZ+FlgAX4zuSWtflXeJ/TuWTBbfLreENwHGfAvkpjOYXuJ100ihznMiB4mNEzYj7DJNz0gxosrDeeO0Sd54sAWK7jOjj1+f7txOUeYUAPoh1drkI4a3eExUxz63h2QRgKkzYcYDWjLKXwuHLWEDCrafHVyXRmFnzyKR+hi2/kb9s+oBKJhv3AdYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TtjYgLdh4oCvpXUkHsxsQIXWnjDwPUCsoTgDdEVO6PA=;
 b=qSQgwB7Fjr828uMRvtpzV5BEldEaabEAbzrZaTbq3NLyK8Em0mh7j6yvkAk24A1dQakK3X3DEaJS1wwm1488Yn9kr2Ez1ayb3G7S4ijnb7Sj95cjiDJlhigfF4YYKoKnVj8G67xmjrzHBMGNWHp+snL36ApdWHfDi09LO1jgbEN92ufQf2FNhYfSE5HDWUPvfojlCnpjwQDhssbkdqaolGtxo4LJ9RWfOQoGOONTn+pWuEXO7TZHRCcrGlWWSO2eW12bQb2kwGw4xdE9JGkxO20aFMsnFREkYzUsVNX5dAQPtTgMNmA36z+yLOeCpz9ovLByJb41WCwVTx24U0TFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtjYgLdh4oCvpXUkHsxsQIXWnjDwPUCsoTgDdEVO6PA=;
 b=SnUFh14JDrhzmz+JEwdVBxLMoBG+OF/e7FxogQh+zlhQ1HwIDVmLeMRFKU5hU/iCMjb/cvp0HawQHdUCjGo1xB8L37Axdqwm0wVIHEUigyknlKclDd5mkhsH8vDlaUhHvHgbi5HW/HVkw3cnaa8aeis6bfsX00EQ9KwvD0bELicZ+n7T0sGtuOMQJxicwaQffl30asRto6OLbMIkXs+WZPhRn0CkjJ5+yN6eMpG7b1Hv0p2Z7enbIghDvW7L6h/OGdHxWgUPjmjzM7C4KgdBbx6hgL/JbEC/7HPbJt7RdzIFDQR7z98IQ2o3k9uzG2tOlMwaHPV75JU4v4wRAiOM1g==
Received: from BN0PR04CA0096.namprd04.prod.outlook.com (2603:10b6:408:ec::11)
 by CYXPR12MB9277.namprd12.prod.outlook.com (2603:10b6:930:d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 08:43:33 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::19) by BN0PR04CA0096.outlook.office365.com
 (2603:10b6:408:ec::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.28 via Frontend
 Transport; Tue, 29 Oct 2024 08:43:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 29 Oct 2024 08:43:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 29 Oct
 2024 01:43:11 -0700
Received: from [172.27.19.187] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 29 Oct
 2024 01:43:07 -0700
Message-ID: <a647de41-c267-4b23-9166-9bc3ccae7df9@nvidia.com>
Date: Tue, 29 Oct 2024 10:43:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support live
 migration
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
 <20241028121745.17d4d18c.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241028121745.17d4d18c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|CYXPR12MB9277:EE_
X-MS-Office365-Filtering-Correlation-Id: de3aa4bb-7916-4bc8-9250-08dcf7f5c553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azNwSmFZTG5mMnN0TXJyR1ZGVHVGTmhvWnZaTTc3UWJLQUlPU0RlYXhESStz?=
 =?utf-8?B?YVFmWDM4OUJUZUh6TWlQK0hsTVJ6cWM4UEQyRTk3QmFyZmxZWnZCVXRSOXp6?=
 =?utf-8?B?T0R5WTZLTzh5SW14cXZSUmR1eXpFZXdhdkh6dXBOVWF5Z0N2azJld3dvbE94?=
 =?utf-8?B?UFV4QjNGOWU0TWY2VmVCcTg4VmJ3R0p0alNrS2Q2ZlBqdUZmNFVYTzNqQlc1?=
 =?utf-8?B?UU1yS21jNEExMTdWRElqaEN2RnYrcDJKc01ZWnFKRzZFRW1rWGtxL1FpVFAx?=
 =?utf-8?B?N0JpZmVvajlqZFpyRHVOOXkxczdSZ2d0TmNCNTA2c3AvbU1sOHZTNnNnUGpE?=
 =?utf-8?B?STJpL1liaVIxQWtEWkFiNm9IV1JHMUp4NWNOT1pnQUJuQnBGaTFSdXdrUnEx?=
 =?utf-8?B?YkJIRXdqLzlrZm9UNUlocWMyQlBweEJNdFZkaEJkZ1V4dGhkNVJUS0hiN0pr?=
 =?utf-8?B?czI2T1lxTWxKVlJGTS8wWGFsVjBNeXBZV0NINFl5bzczK2FrL3BpdU5xeUZr?=
 =?utf-8?B?YzZQK3RiVmpFcHl3ZjJmZS9XclpQZGhBUjNKSU0vZEIya1JybTN3aXE0dTFI?=
 =?utf-8?B?YXFqZFlDY0hPY3gwN3FCblhqd3o2WmNPUG1LV0FoR0JPdWNyREgxWFFXdGZi?=
 =?utf-8?B?KzYxVUdWWnkzcGNnZThIQ3NnWkNBMVpVYU81eWs4Q1pwTVZSM1VyK3ByZGM3?=
 =?utf-8?B?VU1zejkvR2l3MGZBUW9vbGI1OW5EMnpkTGtpbFRPWlZlVE83L0wrTWZnOGVF?=
 =?utf-8?B?NkpDTmthcTZIWlFWL2kzSHEwaTZwWmhQRUI4d1V5Q2lxeGlDaXlMVTlSQWo1?=
 =?utf-8?B?eTBNZEdzRDN1UDVsaG9yQUJ6b1N3WHdFOEdvcjlMaFl1cTNFQXJsdjdBdldT?=
 =?utf-8?B?R0RydisyQlQ2VzZYMUxVUWdSSXovZmNJUUUyR25TZldlVVRJQlBrMU5CSm5M?=
 =?utf-8?B?TnUwaFhydW1qZE5XVS9rY1UrY1huTFh4RUtzMU00a3ZEN25XRzJoaGVjMVd3?=
 =?utf-8?B?S3Vqbkk0SzEySERTY1RTVS96UzYybDF6d3ZFOXVKWHZnTUFEb3Y4UmJjOS9Z?=
 =?utf-8?B?ZE9zblJNMjErOVpqeFdrVnRhTFA2WDhiSXJncit5MGJLRWhFeVF4WjRuUGlt?=
 =?utf-8?B?VVpiRmxHZDlOMXF6ZTNtejRZeDNtaEgwcXlVS1BHNVozdGtFWGhDTGw0N0lO?=
 =?utf-8?B?d01GdWZRMDRIL09nSDdNN29qRUFjdkZZekl6VW5rMWlGbGZrZkV0QzZUWFhW?=
 =?utf-8?B?UWdkR0NHSXFIMGRoZThBZERkRUpwZmtVQXRtK1ZQYkRhb1lDNFZTc1VZOHlX?=
 =?utf-8?B?YitScTBoRWFmT043SG9GQ0dOL1JzNGJwanF5WXBvdGNZOG82ZERvYnpoYU14?=
 =?utf-8?B?WndPdWxmdlJqRWRhUFl2aTZwdldnME93M29uZUNjVWlleFViSVQ4OWhqOVNZ?=
 =?utf-8?B?Z2lDR2d4VG1oSTdGSWhEUWZnaFNqVGo0VGdTQ3FYT01oUEYxaUgwaEJvMHNK?=
 =?utf-8?B?UHdvODJGaHNXbGFzRXVybHZKampnQk1TMnVBNTU4ZG84NUV6NTNNaFdzV2pP?=
 =?utf-8?B?UDhzM3F3SHN5d2dlU3cwelBuVGs0b0ZydkJUNlNYZ2k1VldncURzOEhnN1pl?=
 =?utf-8?B?RVJyWXpCTzVyWDhaUFhjZGNtOFVDMDg3ZGZ0bXErNDkxT2NZWUg2NDhxZ2da?=
 =?utf-8?B?VGhZcWFuQ283S3hZSncyT0QrVkFSZXF4bnFjRmtZc1VHM3VqWlJpNGlia1FV?=
 =?utf-8?B?cFhxd3J2Z0NOVmhTQmR6Tk5ENTZkbytjcXN5clFqaHM5c1NiY0UySW9mT0xl?=
 =?utf-8?B?U0l6elJSNjh3bDVSa0VuaGpHZ2ZPczVCdUtjaGVKZVFndUNxL1NzaGlnK2k1?=
 =?utf-8?B?MkNnWGxEemlPL1dWK2dNcTl4RUtOWXFTNW1KZUVYOTVhSUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 08:43:32.7373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de3aa4bb-7916-4bc8-9250-08dcf7f5c553
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9277

On 28/10/2024 20:17, Alex Williamson wrote:
> On Sun, 27 Oct 2024 12:07:44 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> This series enhances the vfio-virtio driver to support live migration
>> for virtio-net Virtual Functions (VFs) that are migration-capable.
> 
> What's the status of making virtio-net VFs in QEMU migration capable?

Currently, we don’t have plans to make virtio-net VFs in QEMU 
migration-capable.

> 
> There would be some obvious benefits for the vfio migration ecosystem
> if we could validate migration of a functional device (ie. not mtty) in
> an L2 guest with no physical hardware dependencies.  Thanks,
> 
> Alex
>

Right, software testing could be beneficial, however, we are not the 
ones who own or perform software simulation and its related tasks inside 
QEMU.

So, this task could be considered in the future once its HOST side is 
actually accepted.

Yishai

