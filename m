Return-Path: <kvm+bounces-25801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3664796ACF0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 01:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B690B2108C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08F51D7991;
	Tue,  3 Sep 2024 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CYBWDvd9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC31A0BF3;
	Tue,  3 Sep 2024 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725406828; cv=fail; b=iLHBhLnj3aZdKC2Qo45W2m5eAxOJU9HuETdgCLXtJk03ySw3ITmlO7SyhOBNsbfQmLKhOvDAlrXc20aOc2R+JyTvI6K2gbqeJzgbCljnfd5V0XEqbRbz9RmWcPGFdKxIf6BEjSynqWswNPscbOajI/AoUI7aphHXj4vn0/8oC5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725406828; c=relaxed/simple;
	bh=2e3WShGXJ8Y8Phf7wELQT36rTqUpsFm4bRlmz4VkpYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GLT5oKl6y5TTI5WV+7nSEx+7RiPv7kU1tW3n9SzjbHZ/Co9E8skq1LMF86QDEdTvG/cqVb6GGUIx35EFp4INy5n82LMQahHOw4ostsleCDmElGgHU2NfZCc4T8HXd1lrGLKjOguAu6qAiVhI8J1wXUeRxydpJTdTqoiTO6EoddM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CYBWDvd9; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJPOt3JPDhTJ/0qmJn16TaOXBumPckb+/z1G6LssnL6AnZPkSWkOG6IL0v3eie0ctkwhoudM5rmdqP6GIxYvbtezmJ6Nzvn7nCGsnu1F3PIlMZnl+J8rojnf3y7G8u7drEyFcEh8XXXzEVEXJO4bVYMU2AZb9YETu/QiLgmCizZ2dU02TENL6UHW/wXv2hTfvIgyGJ3su/nhkL/QmFEMMLSb2jE+3K83NUG9vJ9GEw+LVU7CdO9fbYY6fEYcKwWBt0j//Tdtuv/0wOYIkjZJtwbPh2MJPUVbxAkwt52XsP7Ahqxse+4CY8scZ0t/0kz4HXw520pFp0GqCCqKZvfnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLfkaWwhL0u0HoesGrlpfpS4OFom8Xrl30Mci1SwY5M=;
 b=psJTHrKdjd0XoEno6pQl0VGKu9xBSzkPsGSHTZJVJyM9IR5iNdUOPCJvjiHTK0B+2GJrQMTmL2lqPHKg1iRuLmotNVyEQlrYS3N/3S0R1W09tZJZfcKCBcAXDuZOeUlA+xoAmbfydcbsK9TG+beApmFCWGiLitswPS96JHFxlFPSJdkxGkKgUErdQflZj5FbUzafUNsTDHIj8EuRWZZoW/Px06hS7FgHcEH3TByM0GHBuxkz6gB+eDhmgyMmY4rQ9W5Tq1DLHXVZeganz1LFv5HVxiUaLdWEmki9KMjMTZrZMPRo2HaxsN1/3kyGVnFWuiHYu90W/QWZJ7ClUd2Aog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLfkaWwhL0u0HoesGrlpfpS4OFom8Xrl30Mci1SwY5M=;
 b=CYBWDvd9y3lA4a2rq7YO7nwlUo6XKElDrrnxaMHDRcp5cmIAPr1vqpMXi5YdnsC2ZVfYS2qRKHu/QJ2fVnhyJwiG0tcD8O99JxIVO60prGojHqOvHXIwiS94Q1AbPiLjAQz+pIC38KKmO7AYI60D8XJ37nQiFpluucH2L8XRrKMBRRAxoEg2mhVRLCR00Qn6fuPxxyFxw7E87aifQeK1cCXzqkzlPYJPYeyyThqgy8G95Y7IKMCj7cOrtnoRJhacI/EKz1hyVYrjsdCPvPeMbw1T4RVai0plnnIo+7brGtX3TRF6qm3QD1bzcNfmAOp6ismCtZrR/ihW+tqWKhMkhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CYXPR12MB9278.namprd12.prod.outlook.com (2603:10b6:930:e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Tue, 3 Sep
 2024 23:40:19 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 23:40:19 +0000
Date: Tue, 3 Sep 2024 20:40:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <20240903234019.GI3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com>
 <20240903001654.GE3773488@nvidia.com>
 <ZtbKCb9FTt5gjERf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtbKCb9FTt5gjERf@google.com>
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CYXPR12MB9278:EE_
X-MS-Office365-Filtering-Correlation-Id: ec7053fb-b25d-4d6d-a08b-08dccc71c588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVNXb1lucmdQM09JS2JHMXBad1ZvNEtzc1B6M0pkVnBXbEt1d3RNOUZ4RHo2?=
 =?utf-8?B?Y0dETnMwNy9wVDcyT2lyVWxBMVRuYmk0dEhoVlhBVXZGMFNManlqM2p4MnlP?=
 =?utf-8?B?WUJkS0x2ZTlQbFFZODhnWDdmUTBENDVSZWlrQVlMYnZFRTZYU2VKVWJ1OHo4?=
 =?utf-8?B?dnUvUllxTFNhWFo0UlA3STRoOGw3azNNNmdaZ0ZiaHJYWVoxbkdsY1IvME9v?=
 =?utf-8?B?bk1FMkplL1NvbnJHc2lMd1UrQXViczJHcmszaE04WTZZMzhDSEhCWVZ4UXZo?=
 =?utf-8?B?VlNuVWtpcGw3bWR0ZEZjY3RTdVNIM1BRc051ZVVXcERHUzF3NHJwQTR4U2wx?=
 =?utf-8?B?T2czMGxQc0NWRGdwRDJrakxhMjdnckpLTGRyRHhzdHJDQUErMFpFTHpoUXN5?=
 =?utf-8?B?aGFDdjUwa1ZTNkpNcHRTWGxiR1k5NGdpWDRxa0tycTlyaDZRaGxXaU44TWFz?=
 =?utf-8?B?REdKUmQ4NGY4VVJxUmJiRGQ0dlBoWG5tbm1hUEZRWWtXam1BaWtiUHhGYlZk?=
 =?utf-8?B?aHZFQlRtR3QrZmpSSFJwM2VORFlGNG82R3RZNU5vayt1Y0hRV1luTGVJQVUr?=
 =?utf-8?B?eWZ0eFBXeFk2dlBqdm53M3hvNTZuYk9JY1RydUNqZG0wUTV3VkpxRWlBcjZh?=
 =?utf-8?B?RUpteE92ek53cmNlZElGU3NkaFN2TDZINnh2Q0VBdFMyaExUa2dUd1dzMm0w?=
 =?utf-8?B?TXY3Lzd5RU41d2pLa0VnR21kNDJhU3Z1UlI5cmFVemIrbVFQbXZIT1IwS3Rh?=
 =?utf-8?B?dWVSOENpM1UyajhyaWpBazUwWEQyR0dnVXFFOE9aUW1ObGNxRGpDdHk5SVkr?=
 =?utf-8?B?SENaQmdISHlTdStTQk1EL3I0NjdsWnRQQVhxQ0F0WXVrUzgxYWtlVHRSYlpa?=
 =?utf-8?B?aVFMNmd4OHRwZVZzajMvamdpNkdDV2VYRFBQMlVyRmJmMGVGbTE1czYvWHkw?=
 =?utf-8?B?RUFtK2pCNHdacWNJa1VINmk0aUI2aCtuSklGMWE4NWEyUkwwZTVUcVZrZml5?=
 =?utf-8?B?bWNVMjRqVEpBMFhIYWFyVmx0Rk9idlhZWEhIblc4ZWU4a0l0YnJaMWNPbUpp?=
 =?utf-8?B?bFMwekNTdVIxNGtVK0djOU9hOEovNVBJdXcxcFc1YzB5WXFYZ2pyb3B4dHBl?=
 =?utf-8?B?cU9FSEVMNXJSOFdrYkZRTXc3ZERzY1d1eklybVJMZXBaRHhFdFFycWppRWVN?=
 =?utf-8?B?cGFFVldKSHFKREFPZVJneVBPOTZQTzNheEJERUdrT2tJcFJZZEJFNzZhOWkx?=
 =?utf-8?B?dnJNRVJGSkNja3Z2TWhlMml2VjJ3SENVVDU4ZmhaSk4xZzFkamFwNzBCZWRI?=
 =?utf-8?B?TDBiM1lvZVhESnZ3R1F0VWhpZzg2RmdDRkNzOXc4SzQ0Z09wYWRUL2c5Vjhz?=
 =?utf-8?B?ZnZoSk56aXlodTlLVGhxVEtDUzZxemIxTWVKdEk3aGhsZkEvQ3FXSGhLQ0hz?=
 =?utf-8?B?VmV4SjVZZFFCNVBwRmlScDJoSXRmWEUwbWxEQkxZaHlCOUQxanZzM2hYM0VJ?=
 =?utf-8?B?b0Rlcy92ZStIS0ptU0FyOFBJb09ZMGtPeFFkcmFSOU1tbDRzdTF5V2R1aVJK?=
 =?utf-8?B?dWR5K0FjcndraTRZSlREd3RjNllTSERGcUR4SEw5cXlaTm5Gc1lpd1hCaEpR?=
 =?utf-8?B?TC9RVUpnemVlN2hvRnRDK0cyak5HN1NFSkwyRjZPc1h3akFVTmNLdnFNWUwx?=
 =?utf-8?B?VzZ0R0ttUXd4TUZoK2JjQ0t3TzJxcHN4ZU5NVnBTSndYaTN1TXhVTUNvOUVB?=
 =?utf-8?B?SXR3S3JRNDFIV3VLb2FkOTRwY0srOThFdzNqTnlUcndCMWozYWQweGsrRTJq?=
 =?utf-8?B?Uzk0UjFYRmE0MGUwbFZoUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGgzSURRVjJNV1REUTNzaGJieWxPcGFBazB4RHIrKy8wUUVyTVM1SHorR05F?=
 =?utf-8?B?aG95MHRUblJYUWEyNS9lSFVGUG1xWVdGYUdFZmFiQVh5WmZCQjdUWmFpOURi?=
 =?utf-8?B?VkxsdW0zVm1tYU1Vb2NBOFdBc1gwbjRPQW9sclR5OWNBU282d3RiYkQ5RTBs?=
 =?utf-8?B?SG9NRld5Y1ZFSGpPaWtZUzRSeHpub29HM0hMbG1PTTROTFI3b3c4Z3YvM1dw?=
 =?utf-8?B?UmhJelhoZExSdldIaWw4M3AyNHNtdEVjNlJxcVJlWVVWdHBSQUNuNVpVaFE2?=
 =?utf-8?B?Mkw3U1JiR1dqVUcvRHdldi9VNzFoSXJzT2QvSkFlV1NSaDlJWnRsdUcvYmhP?=
 =?utf-8?B?alFmRCtlekZwR2lNQmRQL3pIcWxPVjhESHJzOEM3dlBjNVJ0SDd1STlZMHY5?=
 =?utf-8?B?emp6WkdlNzlRMkFwMThWaTNHVk01YWQrd3hzeTdLaDJGNGE0RlRQdi92VmpF?=
 =?utf-8?B?bnlrMTB1Ym5KM2NpdE1PS0dTcTRhYitTM1k0aDAwNnJNQnVOcENRcVJ3L29O?=
 =?utf-8?B?eG1XRzJkSkZYUU8yWldKeU1SaDMxazVtam8waVRqbVo5akNlSUgzUk9PZ2lN?=
 =?utf-8?B?MmJSWWJtTC9UajZ6K3Q1eEtZK3ZxZGhvUCtEQm9yRTA5bDV6TG95SlZlaDY5?=
 =?utf-8?B?WVY4U0FHQUNhY085RHh4UUpjRFZCMTl4emhlWWlXR051cXovdk04TkVnaWZI?=
 =?utf-8?B?TmhDdjNTVElRY2FWQ0RZa1FocDRZelRIc0RzbFFPVlJoYzdGbFNLZ2s2bnov?=
 =?utf-8?B?YlJlVnlhM3lDd0RXV1JSdDcvcVp1aU1uWlVlaG5RSDNTLzFYcFJJR3RvRHgz?=
 =?utf-8?B?SDJ3Y0laczVndmZDRzBZbEZhMHFDNlc5TnpDcFVIV2ptd21yanVWMituUGhZ?=
 =?utf-8?B?cXJXV2c1cjREQjZVZWwzS2ViYUdpaGtTQ0ZWNmJIOEo2ZnN2b3RLWmVrUUJ4?=
 =?utf-8?B?WVJUcm9NTGx2QTRhQjl0U0FuUzUrRGhKRXBwcS9jVDNlMlJ3WkJ6QVZ0U2I1?=
 =?utf-8?B?T2xHU0QrVnNjbnNVeFpvSGN2Tkg5RlhabDhMdWNvdGtVUEpEanZWaWhhSzhh?=
 =?utf-8?B?RFkwSHRpQ0YzdUJRUlBUNm1SVnVKbGVkWTZGTlIwNEF0bHJlSjZaa3pKV290?=
 =?utf-8?B?STJHbitkVmc1L0d3MUFMOG5MRmlteUJvYXk3dkt4eHRxVlRPU3luL1dPV1g3?=
 =?utf-8?B?N0ExdHlrZU8rbU4vRmM5a1FRZWlFQ3NkcDNUcG84dUE5ZGo2cU1nUGUvUnd3?=
 =?utf-8?B?NjMyd0Q3VHhJOGphTks3aVIvcDRuejl2Z0loZ3hhZkFRZGFPZTVZbW9uVkI1?=
 =?utf-8?B?RWM1NTVZaUVLejBTOG1kaFJjQjMzd2N2UWtteTdOSU9kdWFrK2FsaDhVdkNN?=
 =?utf-8?B?aUs3ck4rQ3YxSmY2RGd2ODR0ekFjd1hhWVladXJwY25YbVZ2K2xYbGVBUGkz?=
 =?utf-8?B?SXEwMld3MlZ5aFhHN3NJTTRKZlhRaHJDTWhsV2ZCTmR0QVRwT1h1TE4wRkhi?=
 =?utf-8?B?eXlDWjhTQml5N2hzeUVMcEVYSFBMSE9iejAxTGNJQmdUZkZaaUdZZVNDOE4y?=
 =?utf-8?B?Q3pieXJnMUhYMThmcFliUERsK3ZxekVuNE80b25aNEtDQ1dPdlNDMjZ3WmFB?=
 =?utf-8?B?amVOakdqbUJBR3dab2lWN0tHQitMbXlzNTRCR0ppaEdKc0hIVjJJSEhYa2kx?=
 =?utf-8?B?c1UxbzkyalhUbktIT2hPRys4SWhNMlhEa0J2eVZkUkpKTnVyTXJPZldjemxl?=
 =?utf-8?B?eWJyTExBNGxuWHM5SnVFM2pNaG1lQXlUbTVuVUw1UmhNbm5GN0JPMFg1MTVq?=
 =?utf-8?B?bGU2VHk0K21VMThjMHdqYlZwZGhmVVBmOVdKM3RKd1RWeFozR0t2Mk1sbStl?=
 =?utf-8?B?VHNDd1RTdnU4YmxtTGYxdDQ1WTVRUkVtYm1RQXBkaUtHNW1CdTlCd2tRM0ph?=
 =?utf-8?B?QmNWSUJPZkYyMGFLWVpaMGpMZlNLTGRKSlFxcTFTM1V5NEtwSnZLR1pJU2x4?=
 =?utf-8?B?bm1NeEM5NzRxQTZVbktadk5FZ1FmM3ZoK25odWtpeDR3ZFIxVDcrc1FBVDlH?=
 =?utf-8?B?elBJNVJSV1h5QnlOby9RN1A1YXR4eEd2cy9KcUtWU1A3c0V0SDBCZWJoQU5Y?=
 =?utf-8?Q?5GQrjPvi3uSiZzcBhEc3L7tzi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec7053fb-b25d-4d6d-a08b-08dccc71c588
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 23:40:19.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9gkTZtcuyVxFv+wkDD52Pahk4GttFPpL1VtWGXgnEwajjklL9CwZyZDrCABa9We
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9278

On Tue, Sep 03, 2024 at 08:34:17AM +0000, Mostafa Saleh wrote:

> > > For example, KVM doesn’t allow reading reading the CPU system
> > > registers to know if SVE(or other features) is supported but hides
> > > that by a CAP in KVM_CHECK_EXTENSION
> > 
> > Do you know why?
> 
> I am not really sure, but I believe it’s a useful abstraction

It seems odd to me, unpriv userspace can look in /proc/cpuinfo and see
SEV, why would kvm hide the same information behind a
CAP_SYS_ADMIN/whatever check?

> I don’t have a very strong opinion to sanitise the IDRs (specifically
> many of those are documented anyway per IP), but at least we should have
> some clear requirement for what userspace needs, I am just concerned
> that userspace can misuse some of the features leading to a strange UAPI.

We should probably have a file in Documentation/ that does more
explaining of this.

The design has the kernel be very general, the kernel's scope is
bigger than just providing a vSMMU. It is the VMM's job to take the
kernel tools and build the vSMMU para virtualization.

It is like this because the configuration if the vSMMU is ultimately a
policy choice that should be configured by the operator. When we
consider live migration the vSMMU needs to be fully standardized and
consistent regardless of what the pSMMU is. We don't want policy in
the kernel.

Jason

