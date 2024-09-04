Return-Path: <kvm+bounces-25874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB0E96BB6C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426FA28573C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAD21D6C6C;
	Wed,  4 Sep 2024 12:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kz/o9aU+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714711D5CDA;
	Wed,  4 Sep 2024 12:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725451270; cv=fail; b=CogISX4T9bfvw6vxKx8MZJScui4xZvfgWoBjF/NCIaQ69p1JPj8UaxB9pEw160CEKfeuWLmX5p5JNfTHPRVB8XXl4c/XhItvDj9zt1wHbwKPK+lV6AjrTXFs/AGi9FoMarWZOsj7UlMw9fXbkTrJ4DtokI8ehfw5GF+jsnLHeFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725451270; c=relaxed/simple;
	bh=zyH7Kpi+T0Ety3nenMg7Qz5Kf606rAjg1cQRWNU7mRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n5vSOuxyP6np5iXBgXezNgSy9ZR02+65PXBgU4rmZmEDmsHxusDhpnpFPR/xqx+ChlNuUquM2/a9BFGNlRXn/w+ZTABwTb1lXbFy3YP87gPC9fJphpehO9rwluQbNiqVTIzFxjrIoVrhYh6qymHFueGD9xIi85K3yBlYFPVG0wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kz/o9aU+; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t72KmuTDdMAGxPtgDvi4/cUi/reQcKJ/kk0BmeZ2yaTBytHtC51TJDGszikY9JzRxPTduTNrmDtWd/FfETpVqaRzaxbY9zX780NFUziRSHimrrs6wkELO0r0h9YpkdvhRB2AmcvzQAr2kyorf/ni3SWofmuLmfzOdo8iIvMZRUNa2vr2ba5c1Iu+nWXn8DMEgqqE0WIOdD9gV9LvlmAPWTh31D6OQnSghBeKZC/9Wa0ZtNf1AFUnjf1tp9ceSAYNFnnoAog+VgWyaQ2HwCQf/PxFDjCFgqwBzQnpv/odpY0GvL3UmSKFgZd4Um85DAN7QrnVS60LgC1tvvmZdl+rZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18WgC/YD8FGZD37SfXhhhAnO8yp7qKVhB9weAsro6zk=;
 b=TsMzMFbfDsu/ex3T12sutBFE5gBP2wWxENbMn0XVjsxUwLm6QvWX341jWskUmBK9MDcAzdf9uLH527kWxsNnl33i1Hhin537BAIQAb9RIN+YLITeoGEFFobYf2L/+QuHT3ftlJS3b2zER6ImenWmLU4k/ms240OL0TjrqjcpACMRufIWzZV85Z19LucRw+8pxIFetcg2D0t+JwWm+GihUY04/Pkbgkq6jrRZrpWOiM7rKHTqnbgiH+kKFgffbOLf94xx32Ooi7h/mJfitpTh83uyiyX0DlgOS/7XlDdniuyd5Mba32LtMDSdb7sTmBPV+b3G5Hrh/HQxz9ToPd/jfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18WgC/YD8FGZD37SfXhhhAnO8yp7qKVhB9weAsro6zk=;
 b=kz/o9aU+Y1h/IJDn0YZ1Coe2RWQCubmwYT5Va7M48euuG+CqLHXnMdFCqxhnXF0/wLGfhIKCqrr0Ryie22Sspcd6xgUXccE35xFb1RoCGjqF2fjDx87Hvl5sgY+6GY1Gn6xws6LEsNp19rg5iw6LdG1A32sKmHez3ZkSM3fVZ+g5UvszCV4Nkjp1F+hsy/FADT0rt/jg72Tvikugk2yqOrEDPKFsNbiaen1q8C0KSm27x0Hk73iuPXV8OiRObn+RTLgQgKZXuB95fKf3Q9+GczHoWNPCFcadPix2e0Mh6ttM4+Xc70bb/kQRaLFOUxoUzx+O4CLzQq6QSG8Dxw7Zmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 12:01:04 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 12:01:04 +0000
Date: Wed, 4 Sep 2024 09:01:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Mostafa Saleh <smostafa@google.com>,
	"acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
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
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <20240904120103.GB3915968@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com>
 <20240903001654.GE3773488@nvidia.com>
 <ZtbKCb9FTt5gjERf@google.com>
 <20240903234019.GI3773488@nvidia.com>
 <9e8153c95b664726bd7fcb6d0605610a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e8153c95b664726bd7fcb6d0605610a@huawei.com>
X-ClientProxiedBy: MN2PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:208:d4::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 865fc5a9-7054-4fe5-95d1-08dcccd9408a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnliQnh1eDlSdElPMDdFRVpod1N4TGc4QkhUbWM1UWxWbFhxMUVvY0hlSXAy?=
 =?utf-8?B?U1FPOHB6cXpBb1FCeC85eE1VR1Y3STAzbDdESmp3QXhOQXNVRzZtbjIvNUoy?=
 =?utf-8?B?QVc3TDZrb0JnQndBTHpPdXV3VWhld1Q4TjhQYnB1VTNCOHlZYWk4TEZ1Tm5K?=
 =?utf-8?B?OVlpTnV4SytaWjJ0TVZIR1EvTFk5QVRBMmtQMzFuR1ZESDFUWUhoQ2h0SlJz?=
 =?utf-8?B?QlpLN2VhT25sdnJGWWxhaVg5emxJbzFvMHpMUXlleE5mL1FwNEFNSDliaFRH?=
 =?utf-8?B?cGhSK210ZTBBZlBKaUlnSkVIOUh0RDJSc0RoV0JWVHNwVFlRelU2cU1qZ0t5?=
 =?utf-8?B?N3R4OTFXY3VZSU1oVkFxVVpvY3E4VWw2OTFtT0YrbWNacE9oTndleHVzblR2?=
 =?utf-8?B?NW5PT2U0ODNlL3pHTnZlb1JDMktwMFd3ejlGV0VnNFpWZmNXZGl6UHRZbnZZ?=
 =?utf-8?B?dFowL1ZWKy9sU0xNYnZnMjJNcXlZS3AvSXA4RGxuK1h4OTh2dlRtMlM4MkRG?=
 =?utf-8?B?V25QcFJyWjNSOTlYYU1Vc2toUGVNeUgrNUtDdkk2ckI1REZqSWtCekZFZGtX?=
 =?utf-8?B?R2w2dXRneTZvbWx5MUhwU2sxd0F1em1pc055YkFKZk1RUDA4VjJjb1dkbjBY?=
 =?utf-8?B?NVNHU0NjYlIyQnluaWZGY0kxNWxzdlhoU3g2WGNFb01XcmZCUjN5N2FMdHRi?=
 =?utf-8?B?MVVzd2FqVUt4TjdsemF0UHl1MkV3c05Ga3lVVXFJMWd4Lyt4MUNaT1dXcExt?=
 =?utf-8?B?U3lUQlJ2VUUzUHhwS3hXT05BR09jOUZmVjlDUUFzcnNGV1V6akYyM2FTK0k2?=
 =?utf-8?B?b0tITXk5WVJmYUZXUTl6dlIzcDJMV3pUWUQvZDU0VndKc213ckg5NVZvNmVj?=
 =?utf-8?B?dE9EMThMeEtSTlB5TTVLQVdFcjRjQ2hxNm80dlB3WEhZbUc0Y2U0MGJFQW82?=
 =?utf-8?B?VnlWUGRsTDhXL3YvaXF3WFh2dFpiTVdCS0ZUTk56RVFEQm40Um9VRUFDdEdt?=
 =?utf-8?B?ZVNXaTFONGJDanBYWVc2ZHVVRXVZMEpOS3ZmZXFFMnVlVUZtaitKYW90cWZF?=
 =?utf-8?B?TmYwa3RleGc1bURSYVROZG5ROUg0ZzlOK1FOcjFUdU5HZVBIYi9BVGxUV3hv?=
 =?utf-8?B?VU9QaTdVam5CSlRzNVBMd25XMGErQmw1VmJyR2NLZ0RtUnJmNVdkNDk0eCtP?=
 =?utf-8?B?ZVdBUDFaR2ZOY3l3REdFWjJscC9acmhONFlRMWRRanJ2a1FNU25kNFdLT0VE?=
 =?utf-8?B?UDB4c3hPbXBHdyswWHM0bkZkcjAyK2krYTYrb1JtYkQ3L2tpOWJlQ0tRdEY4?=
 =?utf-8?B?ZVY1QTlyeGhTRnpVV1NOZWMwQTJNdU1EZ0VJckoxT3Z4cHRrbUQyMi8yejB1?=
 =?utf-8?B?WUNLMHhrN1ZsRmQ3YkhlOFVISmN5SEpvUnNGUTVmYkN3WlJGVVFiYmNqN3Z4?=
 =?utf-8?B?QzMwMlZHT1lYZ0NWUnU4SkFnQnpLdjIrdjZLNXZQVWErVlJMSHJxZ2lCSDZV?=
 =?utf-8?B?b2Ryb05EZ2NWbmJ0a0I4bFJ2SmJtOGFUQ3BGd0FYMmFXaFRpTnJzeTN4QjRP?=
 =?utf-8?B?U25pZHVuZXJTdXlscEh1M0M1MzlUazd5R1BvR0pPVmNObUxFR2tkZXZyNHlI?=
 =?utf-8?B?Lzd1UjF6bDR6VmVmZlFjM3VYMEJOR1BqaDZwcUdvell2Z1A4ZDQwU2tIcGpW?=
 =?utf-8?B?aDRSdXoxRHNSK1J6WnJtNEhlUTNJeUxNaWNPV09WWXVXRFpFRElUU20vSW1W?=
 =?utf-8?B?b3p1OFZuTkEwd2ZGT3FPempGeHRUYjZQcW95NzN3bEMza29VT3p2OWJMYmMv?=
 =?utf-8?Q?n2zA8N/kQl5w/iV24obNuGFp6M5+nfTyActXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlJ6bE9nSUVib25YQmtIWFdTcnM2VGpBZE1nR1YrZ3NBWWUxNjhBeHJPeEdy?=
 =?utf-8?B?dUppOS9NMzFHbnY0REl6R2hDTXNsTWNhY3ZZWks3MmY1c29GeHhuY2hKWVpU?=
 =?utf-8?B?WG1Cd1BSTldhWTZydmZxTUpLRTg5OEFIOXlsMDlSR1dHcXJJMFVwOHRUZDVQ?=
 =?utf-8?B?bHZWQlVDQWhvekp1VWJtT1pqQWRGTi9rN09sVEpHZXQ3Qm8weVkzbHBxNFFP?=
 =?utf-8?B?c0x6Y2IvU2ErcU0reXptVU1zbElidDBKeVBHNkw3TXc5Mit1UnN3NDZxc0RF?=
 =?utf-8?B?eVdlNmtGNnAvNFlQYWtQdUN4YldDSGpib2hGcTFXaTJrbGhCNDVCTGttVHE5?=
 =?utf-8?B?d0pWTU9tQmZJYXNMZ0dsQzVYb01VbTY0bytyd0F5clp3ajQ2UFc5cTFpc2c5?=
 =?utf-8?B?RWpoV011UXZ1WVF4WE40b1ppd0tIcVA4ekkyK0l3aTduU012L2E2TGsvQUxt?=
 =?utf-8?B?SHMydXRjZy9Cc0c2NUNXYitwekR4Z3FWb2xxWm5KSkcyNmlETUI4cnFrSXBS?=
 =?utf-8?B?SlBvRWJLeEtKZXBlZlFOV0xpZG1acWlVK1pydEU2ZVB2S1I0VFoxaGpPenpN?=
 =?utf-8?B?RFZIcEdpNzdibVcyOG1lY3FFWEo4aWJNTk9Selg1cW93K0tmQWlPTjRFU0Iz?=
 =?utf-8?B?eTdzRHdOVUdsSEFuU0dIcnRFU3F5SGdKN05peWM0cHhPZDhNamJKMWRnT0lv?=
 =?utf-8?B?V2J1K1ZMbTJDZnpqNGpxNXhYWml0Vit2MytiNEFkeVJiTkJ2L2k2RjJndzBS?=
 =?utf-8?B?d3ltTmlkZWh1UnlZVnNJaW5hN090cGZpWnlhMjEzK0NoZk9Jam1WKzk4REZ1?=
 =?utf-8?B?WGJEUjlaMTdJcHB2MC80OFV1MTl1NHcrY2gwTmUraEtOeWU0N1RVaXk2UXp5?=
 =?utf-8?B?R0pQNU1LZExSRTg2aGtLYUtFVHhkS1BHdGQxS2RjRFBUclZNNzQydEh2a0ZK?=
 =?utf-8?B?Rlhod05WcHdZckVncG1DRUlwdTJkUmgvMDJRSWYvTERkMUZ2R2tNTis4Lzd3?=
 =?utf-8?B?cWFydVJyM09LRjZxZ2c2RWZCM1VwUDdrZFlBMmNtajhkZHBFMHZubVY4cFpQ?=
 =?utf-8?B?K2RjUXZOWDhlTjl2MXNMYU5hbFZMZTFITXdSNnBOUzJZUU9GNllNMmZmeXdV?=
 =?utf-8?B?d0RUR0piUTY3M1lwL0hHank4MUJOYUYxdGowdi8wcUlyeHZmNVdGdS9veDIy?=
 =?utf-8?B?SCtwb1E2aFEwblBmSllaSEJqWWRsN0xsNEltQkVmRmh5dCtEWi8xL1lLcW1I?=
 =?utf-8?B?WG9zWTY3cUVCbGt0c0kwVWNrcGVuWkhxUlZNUFoxaHVGSkRqYld5akhRZ2w2?=
 =?utf-8?B?U2JsdWRacUM3cHl3UlRuQlRLN2pZeU1VT01MWUJVSE51TkRwU0RvSTEyNnBv?=
 =?utf-8?B?aitsRzZ2S3Z5THU3NGhDSDMrUVR2ZFU4bThlUkV5RXZIZmNpTGV1cmxiLzQ3?=
 =?utf-8?B?aUF2eTY2TkpzOHkzZ3gyRFpkdWVrRlIybXpaQlZnSjc1eGJYU0dpdXlhcmNw?=
 =?utf-8?B?dnV6VkxIdGkzcDc4RGJwSklINFRMT0Z5SEQwL0FwV1krRGpzT3BrS0xQWElj?=
 =?utf-8?B?aytkMlVtZFZRUDhEK1hWSGhLUFUxcUtZQU9palUvNDNWWCszK0sycWdyYXlp?=
 =?utf-8?B?bWRMV1dxeWZCRlJJdU0zdkN1eUtJeWpFRlVuRnhqT3NycmRCa1RLL29Qb1Zp?=
 =?utf-8?B?RzFZSVAwblRkY3I2LzB4aEJ3ZXNMcDZ5TVVmS21HakhpK1kwUkRiUElIOEZD?=
 =?utf-8?B?VitZM2ZtSkNSQ1hFeUFPTHBydGlLbWhxbzJmS3lxd1pmbVRSRXVjRzFzRzFI?=
 =?utf-8?B?M2ViVmZvek1YK2lRRDQrQVp6YlV0THpFWXE2Vit3TTZjMUw2K21BOHhXS1pk?=
 =?utf-8?B?bnJENmJwbkZ4eXJoUmwrNFBOb2ZvVDNtSXRJcXJSVE5pamw4alhhRjBnS0dR?=
 =?utf-8?B?cDRwcGx0aHZQOHlCdjUvNm5IRXhaTllCOVhwVjlmTVR0S1RORThlSkdnTVhK?=
 =?utf-8?B?RmFyS0ZBQ0Voa01vTmdSOUpXMmtMTjBEcTRJc1M3ejFrNms5RlpsOHU1bW5Q?=
 =?utf-8?B?dWYyQXUvbnR6bHR1V2xERnBIdmkwdzUrckJRRjNmdEFtSEhTY2JrTFZ3cWk0?=
 =?utf-8?Q?AZc8NJbNVh8twmxPwlimOWHM1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865fc5a9-7054-4fe5-95d1-08dcccd9408a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 12:01:04.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdiamznpW45ZHHUMllRyI4Uhs7eWB0PjwC7TQhHUZeXsRYHntvbo68zDqjK5njZj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Wed, Sep 04, 2024 at 07:11:19AM +0000, Shameerali Kolothum Thodi wrote:

> > On Tue, Sep 03, 2024 at 08:34:17AM +0000, Mostafa Saleh wrote:
> > 
> > > > > For example, KVM doesn’t allow reading reading the CPU system
> > > > > registers to know if SVE(or other features) is supported but hides
> > > > > that by a CAP in KVM_CHECK_EXTENSION
> > > >
> > > > Do you know why?
> > >
> > > I am not really sure, but I believe it’s a useful abstraction
> > 
> > It seems odd to me, unpriv userspace can look in /proc/cpuinfo and see
> > SEV, why would kvm hide the same information behind a
> > CAP_SYS_ADMIN/whatever check?
> 
> I don’t think KVM hides SVE always. It also depends on whether the
> VMM has requested sve for a specific Guest or not(Qemu has option to
> turn sve on/off, similarly pmu as well).  Based on that KVM
> populates the Guest specific ID registers.  And Guest /proc/cpuinfo
> reflects that.
> 
> And for some features if KVM is not handling the feature properly or
> not making any sense to be exposed to Guest, those features are
> masked in ID registers.
> 
> Recently ARM64 ID registers has been made writable from userspace to
> allow VMM to turn on/off features, so that VMs can be migrated
> between hosts that differ in feature support.
> 
> https://lore.kernel.org/all/ZR2YfAixZgbCFnb8@linux.dev/T/#m7c2493fd2d43c13a3336d19f2dc06a89803c6fdb

I see, so there is a significant difference - in KVM the kernel
controls what ID values the VM observes and in vSMMU the VMM controls
it.

Jason

