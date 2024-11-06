Return-Path: <kvm+bounces-30857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CFB9BDFD3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15CD41C2301C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDA01D223C;
	Wed,  6 Nov 2024 07:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGWCqsn4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861DB1D1724
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879891; cv=fail; b=oOVC/DGv7SXHEOteloOb96bkiOBQZBtFB+FY5GcXyny+1qTf0fr4SQa3U5i8+IAeZx1nOQ5b0iTZVmYrvMxWAQ3L0GPwGXzNEAPX/4LJxfc5ncDIt3VPuA3QoSg38b4mGSsgKpne4mtbOrS6azVi7FtAGCm/IGPMBY/ufqSKWCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879891; c=relaxed/simple;
	bh=8RxqwbYNJ/s+CfL8h09ZwNrN8pSAmBSlagTDzVzG6iI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jWoPrRi21WGclrZf6v9+IrmponyDy2e3zY6Ja/WuFaEF/aYyYuHbGk6sAvYiemlcxp5SN4xi01C0Y7liHqNpMbhM7q+dVnE9QZvZh3sG5xwYEF1n9+6sATrG5BSeaxgrzvEx7UVFuBUDzw/0Ld1JOR3kn8LW0Aq5ZX/mvBP/Cl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGWCqsn4; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879889; x=1762415889;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8RxqwbYNJ/s+CfL8h09ZwNrN8pSAmBSlagTDzVzG6iI=;
  b=iGWCqsn4umQ0dIb0kiCr0fUJB5R6AIOQbsstwMIIeY7VCe2gW9235gjb
   fmQ1P6AjB/WzyT2DSIzgoG4HNqjtbuqwAEPvW0lKHxx0K1ml3VKHfOVRf
   5YXtuUo3igFDwiHds60iMvRBNKUYl3tra44Vt5hUUPp5gtdwBFTvVqYL/
   NM+nFAFGoZT8U/uZycQILf/Ke/fuJCcPynkyLcTymjXOqyeBJ4wh9hCJN
   bDgCWixB8QvvgyMi4POO3FQcJ/jqYsAmO6kuSOYzESqFK48C2SOUL51kj
   Ikh5nhl9ZTfY5oz24+8BNjT7bgZRHrpwl6mGPUWPP8dsCPie4xNdPNeU5
   Q==;
X-CSE-ConnectionGUID: z+1ek1wuQmyDEj2pyPJOig==
X-CSE-MsgGUID: EEO9ek2cQauz8UslfPcBNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42062165"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42062165"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:58:09 -0800
X-CSE-ConnectionGUID: F+PbopWlTVuNAjqMAHvq/w==
X-CSE-MsgGUID: we+rPSqxQ6yJr314PT3ryg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89529679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:58:09 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:58:08 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilYk6cNdO6BcoNSfxQ4G/xPN7Yu10ThG5ovV9hrJZjubXpuDWdpteDLTz10LTzDhFsjEoV8E89HFoEPkklFrYVV7GJmDHlLKm+mbg0li7UgWsFcFcdmFwr6hDegk8Wf8TqHk6O/tLilSR8CHMFOd2DDWy9WM01f6oTz2whyBIsAx1jy/Nv7+2TMYc8v8gNerNqkZF/QZorouTt7DLxFonXElSyWaijZNmNu3OzDge0uo24R1kKwgJJ7eQIyeFZ+vZu5tpwpx5E61ImzMWzZFxFHgB/IjHhxWHXalUyv4k3j4fSKDYZ/dqQcBZoOw78EZEhyqa4+vAEwhnhpPVWNbtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsSUByMjZ6oNgD98vg4yhDZUfUwazOwxrtAPx++8sRk=;
 b=yAuHcRRDylGbPBPqx77UOe3LGD4fgZVS2mtf8Qgj+xbKFjBSPNQAfMLLre0twgYr/p9n01BllpKNS84fySSPQwpBATM05XDMbnU/TCPaA11tt83U5qb29NNqfMBoMSafWEjaMPJn21STSfHSmzChWtfSOoXGRmWLC3kLs/bgAnTH527FHTtFjcnqWg8maF+sBzVBhkreYuEg2mGUCTm+LX97BbFc27mgYrYEROF/HSU/In+2c7KY/N3SesulZN1f4d5eHFhPIGmmERCvPpusY5LcPEbjVs+rtFQz72Um/TTiNIdVOMwDFKOqadsI+TZi4y0OX1GyXx1oww0ih9spVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 07:58:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:58:01 +0000
Message-ID: <9e00e062-6a05-4658-84fb-1ac5f2502bd9@intel.com>
Date: Wed, 6 Nov 2024 16:02:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
 <BN9PR11MB52769400A082C0CE51B48EA98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52769400A082C0CE51B48EA98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BY1PR11MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: 0823ba6f-3bea-4be1-dc21-08dcfe38bc2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUJzSjZBSEFVaFVNbVdLUDMzV0JCdE1maTA1Skl3bm5zTEVpNkxRbFRFcWJz?=
 =?utf-8?B?Mkx1bkF5Y2FIYk1mbTVEbmdoQUlMazJPdk9mdGkxNXRVbVVnaUlINzNkd25E?=
 =?utf-8?B?TFNIK3FoZjM1Tm0zZW1QKzN0YXBEVWw5NitZNjRIcU1VNzFoOXplTEtxYmlD?=
 =?utf-8?B?N05HZHpDem0xQWp3MGFpTGNVdFdySHgwVUxvUkh4Vm0yMmJ0M3VZNE9mcFBZ?=
 =?utf-8?B?S0d4MHZ3VlBCakxpMjZZL2EwZmQ3MUlwbUNMN0k2eUp5UmpNVW91NUw0K095?=
 =?utf-8?B?eUN3bXJ5WnkwY0NwZkJpd1lJMTJrTGhqdUVUMExUR3EvcUlidWc4MjRsb3ph?=
 =?utf-8?B?cm1KWXJpell1TVFCTGxOQ1dxK3hWTG9PUmpGRXY2VVg3emg4N2ZKSU4zYlFZ?=
 =?utf-8?B?MTN4L3VaYUovTWVZd2Z3MG93ZjVqQlBBY0Rna0RUODhPSUVUeWFCaFlIWW0y?=
 =?utf-8?B?QU5OWlN2aHlpR0svVmZWeVFYditPV0gyanNzeU8waWtjTURnVUo2cnNzdktY?=
 =?utf-8?B?TTRSOFBKOFVDSllRWjF6dnFhUFhabFd2MVJ1YVpkbVJtb1I5djljS25renh4?=
 =?utf-8?B?WDdsbDQ3VkFqYkx5NklmRzM3S0l1U0NCekJHbC81TFYyczc0OFVRWnhrWW1o?=
 =?utf-8?B?bEVBY2xZbER6VWZYTjM3Mm5KZWJueFVmL0hUQ0NMdHIyb1QyODVaR054Vnln?=
 =?utf-8?B?V1JESFc3QkpGWXdJbFVSSlNiU3ZMK1MrVGh2VCt3ZzNDSDl3MWhLTkN1c2ts?=
 =?utf-8?B?WnN2Uk82MUZEWGdBRTFkQ1BEQkF1S1BmOXo2amRGMCtjTzFyNVVRRE5VMUVp?=
 =?utf-8?B?N3BwaHJBM09TQnNKRkpJWEJJTVQ0bzVNVE12emVKMVo2emNOalNYOFVuK2xH?=
 =?utf-8?B?aStxRytaR2FuTkViaG1RdktLbEpUanFreGNhajZLRUk2YkZSK0Y3RW8zTWUv?=
 =?utf-8?B?anZ6VU9sM204L2pjbGRhYWF5dE9TNUcxMHlucHFHSUt1bXczK1dFcCtrZFp4?=
 =?utf-8?B?a21CU0RUUkVPcXlSZlRBUW5ta3NwcitLV2FYR0VBb2ZEZXRHTHhGOXFkeHZE?=
 =?utf-8?B?eGZ4K3QrWHVmVTVzUUdMeWM4VXZFL3dpKy81dFRhTUdKSFZxODlFV0NJL3lB?=
 =?utf-8?B?b1VGN0l0WkJOOGQweG5SSjR5TTdORkp2VmNwcDJFRitiQU5BZzZ2TFRKVEtr?=
 =?utf-8?B?NjZSRDMzWDNlL1ZTVk9FMktlcWpPOHIrcm4wTnI3Zm03WVd4RVRPRytIVDdk?=
 =?utf-8?B?Um05OHY3VmgvSy9ST015VnV6S1h5K1NraXV3TXVzWnpGMVUxSC9HOWNFVlFk?=
 =?utf-8?B?UGtLdXJ0WnBDczNQZlpEOHNrNEhlQWEwTFhTQ1FRbytpY3FmcmEzR0tOYmlZ?=
 =?utf-8?B?bDlZQzdmQTVmNlpBU3VHczh5SFlkeVh2dFlXK055OENIOEFQWHZsTXhndVFt?=
 =?utf-8?B?bzl2d1hzVGhGeW43aTF2STJPTnJaamFFWkpiNmh3QUJyZmczOHE5L1FaZFhC?=
 =?utf-8?B?M2NRTWpMazNZNUxNZXRIMnVmYVYzT3ZJcUhHNTIzZlNMR2JkY1M5K2ZiSC9o?=
 =?utf-8?B?MDN6UjRQVG1SRnFQR2tJeGEwSVB5V1gyUmlLU203OHB3TkR4VFZjY29LZ1o2?=
 =?utf-8?B?aWhOU2xnc0xmZFhHU1FoSExOTVdQRmJXaFhCWUFHV0JsTjgvOGw1OFNyOVBS?=
 =?utf-8?B?ak90VmZCVUo0bzdhYXRvK0Via01LcEtPMmdUSG9VSEVtMm40NVhOdmVDbDJ3?=
 =?utf-8?Q?NZ+IXMoRTk4XaqlGm8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzFpVnpCSzdrcExJRGxqaFF1Qytzb1JpRzB1a3lWTE92Q0g0a3BEU3RDTGpK?=
 =?utf-8?B?R1NXdDdwTGRWUzNaMkF5b0M3V3pFZCsrVjVMQzRHWG45UWhpS3hVT1BneDVQ?=
 =?utf-8?B?WmJKcFMzaWRWTEYxOWZXVC9PWWg0UE5aUGN3bTZxNHBQc1VlRUR4VkRFT1ls?=
 =?utf-8?B?YXVaa1NKdTN0d3JoaDJpTHB2YjZRVFMxZHJ1TUVLL2JzRmRzQ2pHZzlNYlov?=
 =?utf-8?B?L0dFQzFFTDgwQjJodUpudWtLUncrZG9FYlVTamdDaWN6OE40VVA3d2VHK2pJ?=
 =?utf-8?B?NWxXN3F2UW9CL2phVE9TSFRUaENzTVdWK1pFR2lWZEpPdi9oY25BZ1dRb3Jh?=
 =?utf-8?B?Vkdya3cyTW5JdHl1ZkxmVGxNTmo3Q01QYUcxZG5yRkFvVHFoS0daRUlnZDJx?=
 =?utf-8?B?NFprK0tTNEpiVU5hNlMwaWgyY09oTGdFUnhLeHM2MWZqMkVucGNvd2NWTmVR?=
 =?utf-8?B?Ukxabis4c2g0VjFobmE1K252ZkpmdHVtMDcvNThMN21wUnN5WDIxMFJTY3FO?=
 =?utf-8?B?dTk4NzExR1J5TGFzZllqNGRmMGwwWFdya0xDa3dGQlM3R1NZUUtWQks4a0FH?=
 =?utf-8?B?OExVRkI3QVg2YnNDc2RLNHgvOWRCN0p2eHZnbWhGU0NVVVNqeXk3aDdKTWNO?=
 =?utf-8?B?dmtsUjFnZllNNFJJUXNhQ0xoTTBvRU5jK2Q3L3BHaitMeGVGOVVqVHplZEwv?=
 =?utf-8?B?TDd0a0FBR04wMGl6bXJEbGNuM2JlZCs1cEZoVktxMmNzT1ZlWURSWkVEZ2hm?=
 =?utf-8?B?cml2ZlVkQ2pucFJHZTZPeFRoVkxQeTJtUTlHOHg0ejU2QmtHOU13TDdjWXlC?=
 =?utf-8?B?a3R3VXhJdWo3cmJkdWFjR2QyUWpja29vVjNSVlh2NUIyVUxteU9mTWp1Rkh2?=
 =?utf-8?B?N25mbWphcHJvaTkxbkcwNjN0UHlraW1NOG00bUVvNHI5dUF3TGIvOHQ5VndO?=
 =?utf-8?B?dDFqMGg4RDhyZU5saUZDV1licTIwZWlWWURuVjhIdmtLUU5PWUZZRzVlTXBl?=
 =?utf-8?B?dEl3S2hoR2hsbjN1UGR1UHFCNDRTeTJ6aUY2Nkk2MkFRUXlkVElBRTI5SnJ3?=
 =?utf-8?B?SDhBMitTdG54QWJHaVNSTkpqa2JoaDQvTHRSSW9EZXRhRTF1dmE2NUVLaWJX?=
 =?utf-8?B?d3NzWDlwcTdiZVZHSEZOczlCY3JoL0hYOTFuN2FUblJlV0J3VThWODJoOHNr?=
 =?utf-8?B?RTBlU1Jza3hqZzJLaHUrQ2JKakkrdW11UjdBVSt1RndKUTRlL2JVcVNObHpW?=
 =?utf-8?B?QzZ3ZjlPZXo5Ti9xQnZZdEZoSW1wajgvSURlNGtZZTRzKzFZWnkwT2hvcDAx?=
 =?utf-8?B?YlhIRkd5eXZsS3ZNVEJFWFd6VFlyRXFRNFRpN3cxL1FoenRKYjI1WTBTNTgw?=
 =?utf-8?B?a1VrV0pOY1ROZ3dmMUpBclFxL21BaERaczFzaU9mMGYzdjB2VzlmbU1TQnUr?=
 =?utf-8?B?RlkycnlOMWlhMlFqY2JYRWhxVXozK00rU2VtWE02MHRTZGo0OTgwV1l5QWxC?=
 =?utf-8?B?Um80RG9pS2U2SVVSaisxUWo2dWcwNW56a281OFJuSHIrOEZaL2VGWUJld2hh?=
 =?utf-8?B?ZitvOEtsSmoweUlld2lQMlZzVmpCc01ET1hVcGcwWitUQnlGdzF2RVRGTnhm?=
 =?utf-8?B?cFZ4eTlxcXRZanlMcUhNdTNYZmxWTVptWU4zVE0rL3dUY1I4bSt5UlZOZXZK?=
 =?utf-8?B?bktNcDdjWnRVbjF2bll0c2FRdTBHTEd2UGJuTjMwTjRTN1RWQ1NkUXJSZEJk?=
 =?utf-8?B?TllLWEM3bHdRSFVNR0MvUDhQcFRvaFplT3RTYkp5QnRoSld4Qkh3ZlgyOFhE?=
 =?utf-8?B?aDBrREpmU3E2ZUJTWGYyeVBuaU1hRzdvWmthN3p6bTlxMVErZzdReUYrSXBE?=
 =?utf-8?B?azdqdXdRbnUreXpzMVdpSjlkSjZBa2pRdCtMeFBtQ21NK1hLeldKeWk2NXU0?=
 =?utf-8?B?NXFBeG9QVk1XNFBRR2ExYWRvSFpkWTU1Zy95d01aRVRhc3lURkpIZTZwVFZn?=
 =?utf-8?B?cG9hVVBGQ2cwVGNpRFNpOW5uaG96NUZVTXZJTm5QMWMrNTdtVmpyUWpmSnJC?=
 =?utf-8?B?cy9BRlNVK3o4V1FnaEFHaStEUEZOeVMyb3BtOHBFSnRWMWNWSmtSSGdTSnh3?=
 =?utf-8?Q?IhILCI/ABSvhGBMc/IVRXq+rk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0823ba6f-3bea-4be1-dc21-08dcfe38bc2c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 07:58:00.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzOzua4upVmB/ZpghFK9ROCTIl3G0s9wpMRNmzoc1Z2np2mq2ca2CA8DXpldhXgp49YVXZyYi40BuffoTie5Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com

On 2024/11/6 15:41, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:19 PM
>>
>> +
>> +static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t
>> pasid,
>> +					 struct iommu_domain *domain)
>> +{
>> +	struct device_domain_info *info = dev_iommu_priv_get(dev);
>> +	struct intel_iommu *iommu = info->iommu;
>> +
>>   	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>>   	intel_drain_pasid_prq(dev, pasid);
>> +	domain_remove_dev_pasid(domain, dev, pasid);
> 
> this changes the order between physical teardown and software teardown.
> 
> but looks harmless.

yes.

>> @@ -4310,17 +4357,9 @@ static int intel_iommu_set_dev_pasid(struct
>> iommu_domain *domain,
>>   	if (ret)
>>   		return ret;
>>
>> -	dev_pasid = kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
>> -	if (!dev_pasid)
>> -		return -ENOMEM;
>> -
>> -	ret = domain_attach_iommu(dmar_domain, iommu);
>> -	if (ret)
>> -		goto out_free;
>> -
>> -	ret = cache_tag_assign_domain(dmar_domain, dev, pasid);
>> -	if (ret)
>> -		goto out_detach_iommu;
>> +	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>> +	if (IS_ERR(dev_pasid))
>> +		return PTR_ERR(dev_pasid);
>>
>>   	if (dmar_domain->use_first_level)
>>   		ret = domain_setup_first_level(iommu, dmar_domain,
> 
> this also changes the order i.e. a dev_pasid might be valid in the list
> before its pasid entry is configured. so other places walking the list
> must not assume every node has a valid entry. what about adding
> a note to the structure field?

Do you mean a mark to say the entry is valid or not? Perhaps it's not
needed.  Even it is treated as a valid entry in the new domain or the
old domain, it looks to be fine. The major usage of this structure are
the cache invalidation (already dropped, but it is an example)and svm mm
release path. Either path looks to be fine as they just do more things
that are harmless.

>> @@ -4329,24 +4368,17 @@ static int intel_iommu_set_dev_pasid(struct
>> iommu_domain *domain,
>>   		ret = intel_pasid_setup_second_level(iommu, dmar_domain,
>>   						     dev, pasid);
>>   	if (ret)
>> -		goto out_unassign_tag;
>> +		goto out_remove_dev_pasid;
>>
>> -	dev_pasid->dev = dev;
>> -	dev_pasid->pasid = pasid;
>> -	spin_lock_irqsave(&dmar_domain->lock, flags);
>> -	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
>> -	spin_unlock_irqrestore(&dmar_domain->lock, flags);
>> +	domain_remove_dev_pasid(old, dev, pasid);
> 
> My preference is moving the check of non-NULL old out here.

@Baolu, how about your thought?

> otherwise looks good,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

