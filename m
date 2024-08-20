Return-Path: <kvm+bounces-24623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B1295868A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 14:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C46728A097
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3BD18FDC3;
	Tue, 20 Aug 2024 12:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jFUcONEH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE8018EFE7;
	Tue, 20 Aug 2024 12:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724155268; cv=fail; b=k+AU685t4tRJSgBlDzVyvujatpJqDgriDi1FvbcTlxJHUzejN7zAQit4Gis73rqqPFc0avFC47DI3vPiyv4wEwjGMAA8z6PA14USUvoI+u7d7aVk4mubNTngblsBC4BgY6IUKZlCVFYdx46lsYzb8qF1lz2i0u8HC/pXkjPbz84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724155268; c=relaxed/simple;
	bh=EmTcHp7FXKlT1G1HjS1IA8RbW6IP4klaLCxlc189mJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PMzB5qt1TehVH12WPAHBR54Nu91ghUJ6RJO3MV0Ef2ygd3jxbS1GuIKVi4JHsCISH6sY5nvXPDUdJKwS+ltwrgMVRrMWwIxzhirwwaEukLBWafNOA3vhNWINAmmviF8YoDzQ4V1g1WluZ8CDn5ZXDwFxjrasOlH5JzRjbIiflpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jFUcONEH; arc=fail smtp.client-ip=40.107.236.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N86HajC28AjsxyJr1NJDNs3NTvKESCKMA1tivg2yru2M6YZ/IPULp/t5ubINqeRCdY2SMj3qs+xrQX2lg/jy8UG1FfmtROU5Q/+ELvPb2Th17XWR8CBwolxHM4Hh7adR6umhA+NU49hd3k+lIpFt87qG4JLG3rHYDjqHs8BJGJmX+K9SH2OHxi+pbk8X50ePAlkXndrFOIW6OhDmS9idUKmlHYZXsKJM6Yv8IQiUXy62/eB3Fim+fJk11j13x5MHz1jCskPsHA0mDMxBdI3atRXH7VVclB6fvBJK9+2cnLdLfJhgo+d0fcfyajMaT77538Eh8UF4DAA9rTmyGdhO7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICd1IQl4iRppIed1BW+PAdVfdetVzyz43u1yOKHsLIQ=;
 b=NU8NREkU2oCbvIosbOYGvAT1GQktf3k/sqz8aViHpJ473c5G0z1rsidH6aau4DWmUU4kmg1w+eSC/tGtRcoMRqPCLYu4qRYPlZGFNnut9UJh+f858mkjwIjR5sHa3YdzsLEIOOFf+Q713BpPb40jC67G1Mb9TtNVyOoOoMviV5VCYq5a33okP90/x4hNvNEIcu81DyCBptekdjFLo1NVgVgcLXIjdEosT0lxMDKbYjIRT0m7OWn68rP0F/wjkSpeLaR05ZUIDQ14/rECmitp3Sge+yVYXhtocZriFxiSYdCj7q3xAsb0VnTPuyLmHt1IaOz0J/0rVWUtglCULoKZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICd1IQl4iRppIed1BW+PAdVfdetVzyz43u1yOKHsLIQ=;
 b=jFUcONEH60pO8CcgPQf3rRgcn8keGAA0P2c1oDimjyAuBUVp8J7wTFu+ciRJ0sFTd4Tv3naxdSlKQCqA/HX/fDKJ1umoYqoAaRByTZb0X4sLfCe6xoI53oLwH7low+ZMxiPRbACKevyFUNvXbaaC+T7TpmUhiuRYMaZ3Wrf9YE4GHX/vl8YWNqNH3xddf929za+ey7PGqSvn7e+JbUGdI62vfIFFkDnKMVOz9H3O9weVPl9EW3U6HW/dq1iHvU3QFWdsWx/dYZJj0MuxQmEkU+HxhbLjNbnWewUudfer11x/CBiGjIwH1kpUfNG8wS8F6nBG2D48k8KjNPrA30XeSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH2PR12MB4328.namprd12.prod.outlook.com (2603:10b6:610:a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 12:01:04 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 12:01:04 +0000
Date: Tue, 20 Aug 2024 09:01:02 -0300
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
Message-ID: <20240820120102.GB3773488@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsRUDaFLd85O8u4Z@google.com>
X-ClientProxiedBy: BL1P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::13) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH2PR12MB4328:EE_
X-MS-Office365-Filtering-Correlation-Id: d20769b9-5422-4e28-8c50-08dcc10fc413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXNCTzR2MEwxTWw0aDViQW5qQkgxNXhEbVgyWVd0M25kS1dNVTE2bXR4dmpl?=
 =?utf-8?B?cnNtVFA5c2l4REl0NUowcFNiOTM3MEZ5TmJ3Z2NzMFY3YTNTU09XQU1CTThZ?=
 =?utf-8?B?MERjWWl4azRHRU8zaTQrbjVoMS9ZZkVJTWZKb0NISkFwTnRsbnRDSmZ1RmNR?=
 =?utf-8?B?TFZzQ2ZWdFp4MlF0b3BrdkowNC9zN1kyOTVqNDBwNHQxOFVqWGE0UjdrRER2?=
 =?utf-8?B?YlRHVGo2d1BXNCt5T1V0TTZiMG93N0VxbHI0OGYrZ0lGbUJEa3BraS9vZFdr?=
 =?utf-8?B?M1dlOWhjTkJnUkhKNXhTSHRtQWw5Q0RkdHdDaDZQTXlQK3grVm8zb3YrSWYx?=
 =?utf-8?B?Vm5wRjlUelg2d2dkOVVkNUVZU0RkM3RuK1JwV05aV09tb2RFTENVREwxWHJo?=
 =?utf-8?B?Z2o5Y0M3aC90ZHBOSURhWjNEbkljRFpPYXY4azlGdSs1bVE2YWZpczRUYVVW?=
 =?utf-8?B?SW5oTVdtN2RCSjM1Y3o0TktaeHM3UHBNUVhDNnAxc3czeGxsUm1udlVCbDBi?=
 =?utf-8?B?ZGUyazgyVExqOVBidExWeDJMTTdJODMrVzVWSUR4eWwxZ1BZOVduUEkyMkpT?=
 =?utf-8?B?clpoNFBvT2g2TDY5aHYrOXYzR2QxQVE1eElXcEVQMTFtaVJISGpiU2NUSGZB?=
 =?utf-8?B?ZWNpK3pjcmVndzdGRng3QmJxYmlQYTVocFpKbngvbFNGZVNMQldIVXBsb0VL?=
 =?utf-8?B?WC84NW94V0ZFSFFzaFU1eGQ3OEVOZHBoWHZJd3pnNWlmRFMxeHVEalBUL0dw?=
 =?utf-8?B?aGFOY0xxZGs4VG4vSTJieVBleDQ3aTRSbDJoUEFvSTQ0T0xEcmNQeGxZbEFa?=
 =?utf-8?B?Wmc1YzBHVDJiWVBKSTVFTnVDazdmTlRZQURnTWhldGJOOHZmYm5yakJub1hK?=
 =?utf-8?B?dHpqQW9wNUZid3ZmVE54Mm5LSld4b3hwNnUxYXdmN05oSG5VTXBZdVBnR05u?=
 =?utf-8?B?WGJSS2RTNWRMUDE2UjFITlVHUnF2WkE3RE40TERURlJnTyszOGg3MzMxWE5o?=
 =?utf-8?B?eUhCR2htSmkrd3Z6MmcveElaUm1OOVBXVUd1RFdZQjNadzhQTlRSayt3SEdh?=
 =?utf-8?B?WXNmYTlKa08wb0pUUWpSZm5lcmpKU3RlWll3WGJZOWFRTmxpNU5VaDhCSGNW?=
 =?utf-8?B?cjNIL2tpUXlldVE5Sy95a3VOUXZHWFNpZWVSQzlwQmNheVlSQlVueFZRVldZ?=
 =?utf-8?B?Tkx4WndmMzJZQW8rZzl0WE8xTXduNXV3UlpsQnJWVnpMTEFoN01id081blJQ?=
 =?utf-8?B?Sm5kNWl4OUFpV2FQZ1pHNVRkUFdDUk1BcFZLTXg5OGN5bE02VlN1Y3p2VzIx?=
 =?utf-8?B?dFNveVhSWGRUc05RYW9QRHBqbFpRMldtNFc0MFhNeW80djNXQW91YmUrVUs0?=
 =?utf-8?B?YVZLV3VzNUdodW9VeWpnanhMcnJYcExJdFZUOVFiUTcraUpqZ203d1hRenFi?=
 =?utf-8?B?NHZGSGkrQThPNlNVUlg4Y1A4a0wwM3pQcGZKZ3B6U2VaM212ak9DaTFCSXV1?=
 =?utf-8?B?Nmt6a2d6MFZwd2RXSGJTK0VBamthTzczTkVOdDBIOExqTy9OalkrUzdwV1dY?=
 =?utf-8?B?dUpZOElrbnhNLytoUmkwOVcyRFpVOHgzS0VJYU8wLzd4Mk9hOWxBMnRNUEd3?=
 =?utf-8?B?citrVjYzSUJyQTM3aUpuRWRZUUZ2WWJUMkRLSER0ZW5JRkVUYWIyanJEcjJY?=
 =?utf-8?B?SVBRdEtyM1ViK1V0b3FKVEhvTXpNN014SGgyRXd6NW9TVGpCK0pKaDZNemZB?=
 =?utf-8?B?UWVGSEU0MzVXWXduSG5kb1VpTnpaYnRMVmNuQnFUSTF5MVJHZkpzekJqeS9C?=
 =?utf-8?Q?I72j2Kz0/0hqCV60G+6SVudte4jfiln8dnJnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UENNOUJWcklPQllLNTZZd01uSjk1Z1g2TWdvWUpNb3E3SzN5eFdZOTFRT3o1?=
 =?utf-8?B?Ykd2cEMvYU9TWFdzUmJmbUxRNVRkOWsxRUJTS3ZnbFBzcW1Mc0dad0JRRS9p?=
 =?utf-8?B?dUxwQkk4OFJ2YUljMzRyZjVVQlFsdTVVRmFsRFovKzlVbWxiU1k1OWtiN1pu?=
 =?utf-8?B?TGNPLy9KdUcvQUJUMFJrYTNTbEoveDJlK09HR0xXelNnY3lLc3dFSlpHNVFF?=
 =?utf-8?B?dWRsamhiRGFlZ3FsVThnSHdFNWNwMjBEcG9GY3hjcjdUUyt6SWtxZkR1L2J3?=
 =?utf-8?B?RVJrOGl6V0EyVms1YzhWamV2eFRBbURtc0cyUDBGcnVMYm80WVFrQ29rTkdO?=
 =?utf-8?B?dnZNWFdyOTJ4Q1VmTzRSa3Z0Y3laRWNrejBWbmVBTi9VcW1ta1loMnRQTDV4?=
 =?utf-8?B?cFlJTFc4TWpXSkFuQmd1cEZEYlFGMVVXL1NnQ1lUOGdEQWNZZFdIcmZURnFX?=
 =?utf-8?B?Z1hZUDVPVUhFZ3hlc25IZVQvbzhHODIreDFVYmZYa0JJWGdNZ2Y3Yi9oL1l2?=
 =?utf-8?B?Tm92RFlhVmxhc3pFNWZaZkdVMkR5Q2xRUnZSZGhvTmpNRm9oUFBoZzFnMGJn?=
 =?utf-8?B?QmhjdDBveFVVOHFPUEdERmZJQ0lTRlpQVHpjOXB1TytOOXlWK0tBQUdTdmtF?=
 =?utf-8?B?a1I0MHVsVWVDaUZ2UzNlVXc2RFhQMGdHamdCRjkvODJVUlIyL005dkYvY1Uv?=
 =?utf-8?B?UG5ObjVpSUxEL2pqS3Y1V2M5bjF6OXVBSkF2cTB6d3dnN0E1UFRYU1pYUVJu?=
 =?utf-8?B?K3VOMHRMM3RuakRlWUF6b09nODdZY0Z1M1JUTDJzNkp0azgxbnRJNDUzeEli?=
 =?utf-8?B?SEVKSnNGblZaRm9MMS9QTWpjTWZZZ0JabEZ1eTRrS0o2Uk5kbTU3cmdJOXBx?=
 =?utf-8?B?aGh4SWt5RUJoUXc0amxXMGx4dEg2SFBkSm9ISERNaXIzYlVPalhyd1c0ZHpa?=
 =?utf-8?B?cE9TSEo5SDNFUDR3VWNFYkl6a2k4UnRaVnlnWlJtcGZNWVh0VllzS1Z0OEN6?=
 =?utf-8?B?TDNUdTdYM1JXQzR2RDg0WWdKZnh1ejIrY1hOeXZqZ0x6VVUwTCtZK0RLZlBZ?=
 =?utf-8?B?OWh5ZUh1TFJlOTFmNWNnK1V2NzBPejR1SWgvK1Qwek93MjlvY3lyeThCajB1?=
 =?utf-8?B?d0RaV2JqMnV5bVdJdmhFeWdRZ0NTZ2JFcUc2NU9NcHR2cUFsbzFBamM0YTlH?=
 =?utf-8?B?eE41SkdJc1IrSW8zdzVpbzBoaVo5U0ZxaUtFZytZcEZyakZSd0UxNzdJcS9y?=
 =?utf-8?B?VnlYTUVVRGtsdjFZSnZ1ckdVcFFzeGU0ZVh2dEFWYnM0UzVQTjZ4S25mbTVP?=
 =?utf-8?B?QXYwYSs2WWcyd1llV3dpVEJnQklwY1hrbGNHQU5DSTZ3WnFlMWYyS0RRczUy?=
 =?utf-8?B?aVFQZ2IvT2UxaTVrZS9laHltRFNJaDlybUNEdERoN0lIbDI4d2ZSNVZYaUZj?=
 =?utf-8?B?V0tKdHFiSWtZKzZtNDdZQ09rLzdwZWx4Z2VPYXlhVDQra2ovV2x0QXdvdVRL?=
 =?utf-8?B?TXcra3A3SGZsdzZia0xNTnRSaVN4bGxlUURNaHd6S3RUYUNYWTdxWVJpcmFo?=
 =?utf-8?B?amJxTldUSHFYSnlydjdORHdXSzErWW50VHQvLzlGb1dGNFowbUhSUWVLNFMv?=
 =?utf-8?B?NjZDVTZnSStia21lWGVtSEVHazJnK3hHb2dIejRrdDFxTGl6d2xNL0ZYS3lu?=
 =?utf-8?B?UU5ZQlZOUDZhLy95ZnZ3L2h3ck54SlR2WmUrNmhTV0dISm9YWVhDTG44MkNw?=
 =?utf-8?B?c1Z5b3Azc2E0MG5tRHhkRzkwV1BLT0VRK0JzNzMrdzNPV29LTXFpb0dKZ3dh?=
 =?utf-8?B?MFduU2lTOFV1bndDMkVYSGtSb2ZZNHBEUndTV0VHNEM2dDAralJWTkEyL0ZM?=
 =?utf-8?B?U3pseTQ5WDhIRVJZbzJXYldKZmorSWRQcEUveG9xSzBGeDlQVm1JQ1Y0R3NV?=
 =?utf-8?B?TTYwekxSME43MjFmbUFlbm1HNjRDRVNKWTh6dVBDOEFEbk1wVkxUWGtqM0dw?=
 =?utf-8?B?WW9uZEVaUmZ2ekQwR2tpOFhQTE1rWmxRbXFzUGZQQTN4NXpRTjIzcERNNE10?=
 =?utf-8?B?OFlSTk5oOTZZdXhtNkZEcHgxeE1nWGtqbFhPS0Q4SkNrdFFkMytJMWxqWFRx?=
 =?utf-8?Q?xz1G75KUQPVYyH4GVrB+MSoES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20769b9-5422-4e28-8c50-08dcc10fc413
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 12:01:03.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij0hoEkQyrNrXrxucmqbVwypXlCej3v847F6jhjAj0Lhz4pYLXfRDtst3jxnNOaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4328

On Tue, Aug 20, 2024 at 08:30:05AM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Aug 06, 2024 at 08:41:15PM -0300, Jason Gunthorpe wrote:
> > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > works. When S2FWB is supported and enabled the IOPTE will force cachable
> > access to IOMMU_CACHE memory and deny cachable access otherwise.
> > 
> > This is not especially meaningful for simple S2 domains, it apparently
> > doesn't even force PCI no-snoop access to be coherent.
> > 
> > However, when used with a nested S1, FWB has the effect of preventing the
> > guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> > cache. Consistent with KVM we wish to deny the guest the ability to become
> > incoherent with cached memory the hypervisor believes is cachable so we
> > don't have to flush it.
> > 
> > Turn on S2FWB whenever the SMMU supports it and use it for all S2
> > mappings.
> 
> I have been looking into this recently from the KVM side as it will
> use FWB for the CPU stage-2 unconditionally for guests(if supported),
> however that breaks for non-coherent devices when assigned, and
> limiting assigned devices to be coherent seems too restrictive.

kvm's CPU S2 doesn't care about non-DMA-coherent devices though? That
concept is only relevant to the SMMU.

The issue on the KVM side is you can't put device MMIO into the CPU S2
using S2FWB and Normal Cachable, it will break the MMIO programming
model. That isn't "coherency" though.

It has to be Normal-NC, which this patch does:

https://lore.kernel.org/r/20240224150546.368-4-ankita@nvidia.com

> But for SMMUv3, S2FWB is per stream, can’t we just use it if the master
> is DMA coherent?

Sure, that seems to be a weird corner. Lets add this:

@@ -4575,7 +4575,12 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
        /* IDR3 */
        reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-       if (FIELD_GET(IDR3_FWB, reg))
+       /*
+        * If for some reason the HW does not support DMA coherency then using
+        * S2FWB won't work. This will also disable nesting support.
+        */
+       if (FIELD_GET(IDR3_FWB, reg) &&
+           (smmu->features & ARM_SMMU_FEAT_COHERENCY))
                smmu->features |= ARM_SMMU_FEAT_S2FWB;
        if (FIELD_GET(IDR3_RIL, reg))
                smmu->features |= ARM_SMMU_FEAT_RANGE_INV;

IMHO it would be weird to make HW that has S2FWB but not coherency,
but sure let's check it.

Also bear in mind VFIO won't run unless ARM_SMMU_FEAT_COHERENCY is set
so we won't even get a chance to ask for a S2 domain.

Jason

