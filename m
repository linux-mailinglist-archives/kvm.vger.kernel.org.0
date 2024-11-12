Return-Path: <kvm+bounces-31549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2F49C4C04
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 02:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBBE71F22DCE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBBE2AF06;
	Tue, 12 Nov 2024 01:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YudwFAVC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB0E19DF8E
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 01:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731376143; cv=fail; b=IThD1L3QS6o6yvU+wQMfiH2vvU17USj4cOOe5DtlgAqTmjheP4tRkRX49rhJU+sTwjNyDkJtaMbNavPVmwDe93Hd8DZ4GhRHl4+aXdF11/48sN2HTB1E+iRjDpj7sVmbzq81Lird1/dUlyacu3gH4UQKJvPMzOyAQp6yF8geKCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731376143; c=relaxed/simple;
	bh=ekqIoHR5e22oMBVDiUzpkZ7CnD8oi48IiSG1n2PMC8M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wx7vQ35/K3Vo4/qFqxD2spEmYc4Waq4OJifSfCrWDVyF5zd0YMMvJdK6hn4itJ+sUc9Idn2/D3+p7NgdZeU4GdcrHkMyooQZUrNO7WzGWmVKNxkaU0dGNVplilJk1jcui2md2lMyCm9KFSykEUc2U+EQZfnxy6BFEF2YjssofOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YudwFAVC; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731376141; x=1762912141;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ekqIoHR5e22oMBVDiUzpkZ7CnD8oi48IiSG1n2PMC8M=;
  b=YudwFAVCgyKhhjrmUHiFOLG9IilyA0DscCkujI74Tt2opXW/6Ns7YYg0
   mZEPT64+MeJgL3E4suEybqoLOmvH8IfV9EMpU2SeSH1V2d3eawXiYZSe7
   drh84Ebo6VoV9u/Jq1rxHGdY5eF42xd7hAedvqExISV00/yMTWh2osNy9
   NBGNvbWIYuR08YTD0WfMHUD/nPzYn7S3Y3Eng/sThBYuT3WE6RxYKe+GP
   WyEOf4pngOeRMoEh69QogDppB2NmNHTKsMqrONksXj76zgHpZs+CtYwjR
   C28gTwpfoHasIOUxeSvq/WNTjhP2J7kz8/dXxBl53C2dwGLFPS04jdBw3
   A==;
X-CSE-ConnectionGUID: BoYW+/9BSviHJl6lc+hRnw==
X-CSE-MsgGUID: 9S+8TQpzQGOQwHx1IrUPdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31422442"
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="31422442"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 17:49:00 -0800
X-CSE-ConnectionGUID: XUSD4mRaRZe+DhYK92lSBg==
X-CSE-MsgGUID: 5Vvmx9aDS5+q8MC5rcGpeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92142168"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 17:49:00 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 17:48:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 17:48:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 17:48:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+K1SZPzrw2iT3BgGFuqBJQ76isRaV8u27sajlHPGwWiojFCsbjHpLriXwuWo3Ci2Dky7FG9rxt9b10ovq+ZnQf+jvBcdbmVeqoGNrfgY5QZ7Apyli1q0CGAJ/s1y0/95lFzimz6YvjNel38epsvfqUKbLiC1iAX2okufIfImGpm+gGNDKesG6nQVGME0N2BA5hGlvns0t90qvbqjt3aKd3pUNK96tiE6VkbR+4DLy5wcxQZnmjJonpFKyLPvY7be7F71nVk4IVkJLztU35g/xcuDQfsGEih3zZkINB6R7qJ7ogN8Qpw2/cn1dgymdecpDdUThDR4jRD7MpAD7mK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIG0NAMOFWix9V5McfpSbUuSm+waRj2HozjqZR+x2dU=;
 b=QQcltZKqeEpXXx+oV9BKCQ3S29uVD0HAMIWmjDhUgCpAmt+fL/b4eGCbcwgIL6icdpGE1GAeKix8kAtIG5YHd0sfUhJzxFSFUqKqHs9OSDNKD6EFisgxGziBheFyI08A9JM1yzSIGROueuc459/Mhotw0nqMKEsvJsRO/wxPralB7mVqOSRnoUPmnbdOywqIragFIjkcrpN+bHTeyrtkbpR/QHRgVyegUdB5ky7B74g4aCtkvPIIPUz76ZWXtWLtjKfLMju6AVtjr815yz1i3qDXH41LE5k2OSMqCJcftkkit0JiLWxh5/ky7rFkb5eI19VDA+HIx6dtEGjRAOzaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7038.namprd11.prod.outlook.com (2603:10b6:806:2b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 01:48:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.022; Tue, 12 Nov 2024
 01:48:52 +0000
Message-ID: <7cbf3b2f-df84-4277-ae95-54696b0d672c@intel.com>
Date: Tue, 12 Nov 2024 09:53:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
 <20241108121742.18889-4-yi.l.liu@intel.com>
 <20241111170247.01f5314e.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241111170247.01f5314e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:4:7c::34) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fa77e1-e0a2-45c5-c045-08dd02bc28da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDVVcW9iR1Q4WWpjL0NKVVNkem81R0hWVEc0RExla1Q0dmMrRVY1N1YwRkNx?=
 =?utf-8?B?QldZKy9BMllEMW94K1k1QllSV2NhcmNocHhjWFRpQ0hsN2RuYXpGYXR6d2Jl?=
 =?utf-8?B?S05uTmc3VldrajZkdlpWaGphd2pPOHNiZjZaTWZidGZkSWRjbWZ6VlpkME4r?=
 =?utf-8?B?RDFEQ3RVNk5PcUJFS0I2Z2lBTmNjcW1QWDZDSkJYNm9pZ0wwY1IwUlE4SFMx?=
 =?utf-8?B?aWs2d0MwS0NSVmhvUUIzSXJ5WmJTVVd5ODVGR0Rpb1JQOGdaeTBwaXRwdEdU?=
 =?utf-8?B?SWhHNkdvamNHaEdONSs3NGhGK0xRYVcyeGNxWU5OU2tLWlhoWWVaWFY3dHpl?=
 =?utf-8?B?eTkzdTlWM0pHMGFIcUZoWDk3c29XcC9mT1JZS3E0VWZRZWNVenRNK2RFeUdQ?=
 =?utf-8?B?R1ZiaVk5UmcxYXQvOTFxUU9HZmZIcnVkQWx2VDBaZXQ5WkpIN0xTNkZCNXda?=
 =?utf-8?B?RCt2OUNFSjNRbmx6dHl4WS9UZmZHOE9ySEhoV09reHpBd1E0SjJXMHVtRUZW?=
 =?utf-8?B?WlV3WWR1eDJlWnpjdFZsNjNZRlZRbWY2akp0bmRubldzc0lWUzJyVDlJdlZP?=
 =?utf-8?B?dWQ0T0w1NTduY3lDTDNkY0ZRVmVhb3hLalh4aGpqR3BmQUxtUDhSTTFyV2hW?=
 =?utf-8?B?Yk9Xdk5iVzJScUxuZjVvQ3NIZDUyMU9jUjJkMGJWV1pQeWZXU2FqVFFRWDFG?=
 =?utf-8?B?Q1lvUUYybm5rQWVXQXhKdkF1bUxrMmlNRzJxUHNNMDZiRGxrcURBZXQzWXpZ?=
 =?utf-8?B?SXZlSTVyN3dhb1FiY2NvWWdQd09qQ3dVQzBVMGRuOWdVQkpTUmdCLzVRZTJk?=
 =?utf-8?B?QytZcC83Wm0vcHRtOFVQTEZTTEl6TzQzVnRmQUZiTGM3eUtQb2FZMXA0WWQ5?=
 =?utf-8?B?dkNHQkRzb0crMGZSaU92UUZjajZaYXlrMEFnb1YrcTBGRTVGMDJMbzRlYVhK?=
 =?utf-8?B?RFF0V0xwWklkUFNSYXQvTDRMazgrZnF4Q1V0MTl1V3pCNnJEWVp4UFdDYTNr?=
 =?utf-8?B?bnFCdkkzNDlXRGRMK1ViQWxuRkFVVkwzTWVaUG5pRXg0OXNUWnNCeENVa0dw?=
 =?utf-8?B?dk1FWHZmR2c0WTZWWGlOSjBMZm5RQUxUdnRSRTRSRHE4NE0zTEFnaGx0NUpL?=
 =?utf-8?B?SW5KL0tVY3hhMlRvclNSQklGSzdLWTlVN3RNMXFuaVdxdnMwWURQc2cyR3pm?=
 =?utf-8?B?bTZ6NEdkTnJxbWN3ZFMwODRTOHlDVUh4dThhZ1FqQmtqUXcxTmVCYkU4MW96?=
 =?utf-8?B?UW1CZzBzRjFGMzdTcUdCUFhnQmVPQlBTOHM4c0c4S3BTNVRkTmVqVit6MWVJ?=
 =?utf-8?B?SE9NWW1RYVJTMDhDNi9IK2ZQQkxXUFowa2pJODJlZndmajd1OHhUMFhrdzRx?=
 =?utf-8?B?bEdOMmxBMGE0R2FNV0ROSXhFTjVCY2lJZ3V5UGZXbmdMcmpoYnVWbzQzcitw?=
 =?utf-8?B?OHp2OUtzNy9xdGxJU0NudXRCU2ptRHBxZlR0QUptSndaRWNSUXRVK1ovUlJE?=
 =?utf-8?B?VS9jVHdoaWtXZmt0blgwWERXL1R0TUpLa243NVQvcG5VY01zOGF6Tm5BQlJx?=
 =?utf-8?B?M0dZVTg5VUtKNUhScXVtOUVUOXc3UFdoWm5LY2NDRUlERGtxSzVSWStOMFEz?=
 =?utf-8?B?Q0FTZzFQZUpVaDJkdE8xTHZySjN1cjVPajNWU3g4akw4SnAwYTdHNHBTeEdk?=
 =?utf-8?B?ME4rdC9XZm9kQjdEbm1WTnlPT21VM3RNU1NoVGo1c3MxMjV3ZXJuZUFNTzY0?=
 =?utf-8?Q?Qtnn+GIzyiSkfQ3pSs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFFxSVMvTjRjUUxMekRYcmFGTkcxaVdaVnBFcHNNRmZhbm9BK3Y1TXZCaGp3?=
 =?utf-8?B?V2FFazhCZXpoTzV2b2cwaGFyZ3F3WE53NWVTcWxScEYwT2FFM2FIdFJLSVk3?=
 =?utf-8?B?K0RqejhLSzZUdjB0OWg0YUhLekFPREVTU1VSdjlkUlpKOTRtYXhFNDZVR2Ir?=
 =?utf-8?B?QVg0L2NGY3pEMFNrRkZsSlJFMnZPTWN6V2NpMGhCYTVpVmo1ck0yNXA3cm1D?=
 =?utf-8?B?RlRLem9RV0RBd2h4ODNmUGlPaEhYWEJDY08zc0pJSGhRVzNQVS9zMVlwMXE5?=
 =?utf-8?B?dVp1ajhaUlRsOGljbGM0U2RIeE0xdUxtVVRQcnJVVUJ3RWlMU2xJSlorOWNq?=
 =?utf-8?B?S1JxenRjeDd3V3l3dktYdWIyYlhVdWlSaFUxWjRSZklLRnhINGJkWUY5bTkr?=
 =?utf-8?B?MlFPQkNydFpLYU5EcUxtR3JhZHlud3R4c1JUNTZJKzIySGIrZVZmbGcwRith?=
 =?utf-8?B?dEhBUFdQekExRlpML09nOWpnanh6N2VUNWpxZ21uOW5Zak5uSEQ3UWQ0dFdG?=
 =?utf-8?B?UFQydkpkN2JjU0VYRi9OL1RaREwwaTZRZnZ6RGJVWk5tVHF3QTk5N3pTM25j?=
 =?utf-8?B?UWgrYnZyemwwWWdyMDhUZUQwV1NsNTIzL2Mzak0wNDExa2pIRUY2Sjc5aWY5?=
 =?utf-8?B?dXkxVHpabGYwNlR2Z2czRG1wYno4MTlaSTlKNHNpblJMV3pUbUYvdmNVVDNx?=
 =?utf-8?B?cXE0UFpOREJJUkZzT1FNTGM3K2JEdm5rTjVCVTZsNCsrK0czbzQ0ZHg0ai9m?=
 =?utf-8?B?YUFDeTY1YnREb0FNU2dZUjF0YlhxdGM5d0ZWL2psbUkvbHpjdUtKWm1FRUxW?=
 =?utf-8?B?d1NpLzdoeVJSYzJOZyszZDJPK3VMbnRYRXJrSEh4aStzbUFmWGdnUnY3cTdt?=
 =?utf-8?B?cTNoRDE1cjRESC9oOHlxeDZvU3FiVE1HSXJVWnpkT2lDZkJERzBVNmtaUWdQ?=
 =?utf-8?B?Z1BDMit4MWZMMStwZjc5WWNmaXNPblVlMVRtWGl2MmgzSkZ1ZHB1cDZyM0JY?=
 =?utf-8?B?UWJEVzkxOGxET1BGRUtaZ0JaUkU1YUNXaWpjZ0xua0xXa1JRLzBnQ05QNWhZ?=
 =?utf-8?B?RGtLdWxVK0tvd3dXaFZFOVdyckt0OVFZV0U4ajRWVFl1Y1RJVVhrY0Z4eFQv?=
 =?utf-8?B?TUZoRFdNL0hFR3NCc3NpWUJGM0FyWnBIbEVCWWNSZjc3U1o3LzhCSGVXbm5E?=
 =?utf-8?B?Sy83Z0UwNG8yRHc1bi9QZnk2REE5WXR2RW5BYkNhTTJCenUyRlI4OGczWkNV?=
 =?utf-8?B?QUtSWUtQNVA3MGZEZ0t6NXVSQ244K1gzdXZWRHp4bjdXRng0a1E1dDFMczhP?=
 =?utf-8?B?MVZxTDBMcnBRQ21NdUlaMVJiNTIwdmVKWGZHc3o4QTRlVkhSajhYZjM5cG5j?=
 =?utf-8?B?Z0ZMMkZwaWNVQ2FxRE1Ya2xpalErMllFVXNxSFNESXVobEp2aE1PZEozdU1X?=
 =?utf-8?B?cnhaZjVCenhvMHlySjluc09rSllVai80YUNVQ1FCRGxsMTNacExWckd4TVJi?=
 =?utf-8?B?NFFvN0oyRjJwM1NSaXhPVlJhVWozNXljNmIyMG9iYVZRQnZDZDkwU0R2RVgx?=
 =?utf-8?B?YkRzV25vK2UvR0thQ2xJbTZEakRDRWlWQXlJOUlXV1VtOGV0L05XbHdNNEVT?=
 =?utf-8?B?SG5mVStTZXRXNkR4WVBYMHcrZVRBeVc2Skh4STRMRU9wWHQzTmJId1l5V3VF?=
 =?utf-8?B?RUhsR2luUFZUVGRHdlZRYnFQVkNvcmhlUGR2dHdjZlNXdnQ4bGxnZ09RdWow?=
 =?utf-8?B?N1VTSExXUkxROUU3OTRMRk5ueE9CcnROUkhQMnVoWk1nM08zNDErMFZobzFs?=
 =?utf-8?B?am1ROVEwcktrd2lpU2c4bE40OHVxN1RMZSt5NDFYWTJTb0RpaEFPbWU4MHJF?=
 =?utf-8?B?L3hBN3RBbm5XRmRjMGk2SU1QWXd2THpTbDZFdHg2RG1pM040MXBzM205b3Fj?=
 =?utf-8?B?QitCSU5uV2pyWVl1Zng5NExXcGZSUnJGK0RKUDFSUEpEN1RFRlQ4Tk03Z1RT?=
 =?utf-8?B?ZkRYRUxka0tKeFR2Q3MyOWhtNjZVTUdHcTB3QThYV3JMNUZUb0R6QmE1N3Ir?=
 =?utf-8?B?eTJaVGEzR1FKeUZ4THRYNUUzSzgxYjJ2QlJFY1lZRTdRZkxuRWdMNUY2bnVq?=
 =?utf-8?Q?T35bdj19Hy68A0sbHqcFpm9h2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fa77e1-e0a2-45c5-c045-08dd02bc28da
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 01:48:52.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lzx7HZcyCi8XayQw6SGBjUoNF5NKzTMMmP3apqS3lL1BgNdbnCYfxcFHYlmdTMafZYbfCZhKFmdP1UOE60G6rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7038
X-OriginatorOrg: intel.com

On 2024/11/12 08:02, Alex Williamson wrote:
> On Fri,  8 Nov 2024 04:17:40 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
>> a given pasid of a vfio device to/from an IOAS/HWPT.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/device_cdev.c | 69 +++++++++++++++++++++++++++++++++-----
>>   include/uapi/linux/vfio.h  | 29 ++++++++++------
>>   2 files changed, 80 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> index bb1817bd4ff3..4519f482e212 100644
>> --- a/drivers/vfio/device_cdev.c
>> +++ b/drivers/vfio/device_cdev.c
>> @@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>>   int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   			    struct vfio_device_attach_iommufd_pt __user *arg)
>>   {
>> -	struct vfio_device *device = df->device;
>>   	struct vfio_device_attach_iommufd_pt attach;
>> -	unsigned long minsz;
>> +	struct vfio_device *device = df->device;
>> +	unsigned long minsz, xend = 0;
>>   	int ret;
>>   
>>   	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
>> @@ -172,11 +172,38 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>>   	if (copy_from_user(&attach, arg, minsz))
>>   		return -EFAULT;
>>   
>> -	if (attach.argsz < minsz || attach.flags)
>> +	if (attach.argsz < minsz)
>>   		return -EINVAL;
>>   
>> +	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
>> +		return -EINVAL;
>> +
>> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
>> +		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
>> +
>> +	/*
>> +	 * xend may be equal to minsz if a flag is defined for reusing a
>> +	 * reserved field or a special usage of an existing field.
>> +	 */
>> +	if (xend > minsz) {
>> +		if (attach.argsz < xend)
>> +			return -EINVAL;
>> +
>> +		if (copy_from_user((void *)&attach + minsz,
>> +				   (void __user *)arg + minsz, xend - minsz))
>> +			return -EFAULT;
>> +	}
>> +
>> +	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
>> +	    !device->ops->pasid_attach_ioas)
>> +		return -EOPNOTSUPP;
>> +
>>   	mutex_lock(&device->dev_set->lock);
>> -	ret = device->ops->attach_ioas(device, &attach.pt_id);
>> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> 
> I'd just do the ops test here:
> 							{
> 		if (!device->ops->pasid_attach_ios)
> 			ret = -EOPNOTSUPP;
> 		else...
> 
>> +		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
>> +						     &attach.pt_id);

got it.

> 	} else {
> 
> (Obviously if we weren't about to generalize the prior chunk of code,
> we'd test ops before the 2nd copy_from_user)  Thanks,

yes. that's the trade-off for the generalization. :)

-- 
Regards,
Yi Liu

