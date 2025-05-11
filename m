Return-Path: <kvm+bounces-46118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C5AAB2767
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 10:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F132177BB7
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 08:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7FB1BEF6D;
	Sun, 11 May 2025 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LtflK6u5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6018DF86;
	Sun, 11 May 2025 08:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746953884; cv=fail; b=GCLx9l5jAlNZTazLpXhu07uQnTeGvEJOQO3fr1huOoaRMXddZe1Dzl3mvj8ZJvEcj3aiApL8NrNYl9yX1qhEcs8ugjLiB4DBb7CRioMi9yu+oQcCyE5FpE3NdcHWtGNBBc56DR1TVugIrbCwpwjWaBBgTCWN/8QI1y/dDYjNDu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746953884; c=relaxed/simple;
	bh=VEJZc82NODLYmcVE1dcgSKepwhUjZTzRq7EsAxZzY3A=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iY7LVwXHM9ylpnK4Bxhnqxa1GgvfFTaGfMM9qi/Jg2mGR2h6sI8flBGZjaelFVSlNMu1bOhyG7vCijjKLzRwVQ5OWPn39fw4JrBREZhNHI50CcuZKP0cvi0fxJiAgPy14Lu7uOzblEqfI3ZJDHVAEMHPZIO3k5Jqmw7i8aP8K6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LtflK6u5; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746953882; x=1778489882;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VEJZc82NODLYmcVE1dcgSKepwhUjZTzRq7EsAxZzY3A=;
  b=LtflK6u5AHvC1NdQYnLzIz6VTomIJYLc7RxCqdfDrmgw+1bLuiO9KyDb
   O5WQpjBQu34FS1XYa4RMCkeeOgM92ZdIj/ci1yQiG/Vi9FJv4P/GmnLDU
   Icyhq2euP2Mzp9N+aEmIQhb9fAJSJz2EUekeZfPauqINRv/0yl025+Cpp
   3gBOKNaWI0rBGlSpjHEjetwpElsQwVcDQCZ3aaHh77iiw1j6+0BL6MuGm
   i58Rc9vc9QxmBV6cj+xUXN642cO4hfa1WlXsufBtYQCjtRS2DriUz4FCg
   3rQf2rveLgZeP6ZbGj2H3Rpf1qamGAKuqxMFJctv6ssksIQQyinEcY16s
   Q==;
X-CSE-ConnectionGUID: C6YnhZNeS9S/6DXsGLIHHQ==
X-CSE-MsgGUID: K4fB1W9nTbeS3hBg2nc2Bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11429"; a="59753105"
X-IronPort-AV: E=Sophos;i="6.15,280,1739865600"; 
   d="scan'208";a="59753105"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 01:58:01 -0700
X-CSE-ConnectionGUID: BKwMhX18RmGTIHAGJHlgIw==
X-CSE-MsgGUID: VRO7CLfdR46zW1Sn121b4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,280,1739865600"; 
   d="scan'208";a="160335694"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 01:58:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 01:57:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 01:57:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 01:57:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qE6Zw1GkLYjD6f1Hiibxl8kL9WNc0vP2Cz8d3YVvtHi04zh3cEBKram7wpBj7ix5pocXmRbbKLexc/jFvAJj0I9v5lfhe2IFTvAoYzhPKiorz+ylIC6zxp5cZHyN84eFolomidiQ8xJMQPNrElUqB4lcmLF7iNhMPQ9Y0MoDKyaJtJsV40IODkh6eVULBoZV4c2+kPV78rkes1QAboEfX1wsZslxnStiCSddr3F+xEI7tKI1tlM9AaPNWXvwiT1O5haES2ZXTUTLxW/NFnhUcTS3dnLg6YpHAWIN3GZluRrm9pr2e59keeQEhJpAnM6gLANdWRKgpAYbMZj96Fu3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gn+QG2T/ex2II0pAPL0UtQc8MZWdher6+kp/ungypGc=;
 b=ZBttBJp6umFQMZTd61ssti2Azy58lSBBQbuYm1tTY9+0OikF4x0H0vCgtxUla4V4W9hU+Aqira6NPMOB+zLXN+wbXUF+rOkNyBOuUplokJDqNTbM7GLB35Oa8b4jsu282cvvj20HlAsn7+ND2IjQZHFjg3TMg22Bv0NBKL7EJseR/BFQDC7IB+q7cWf9nSlRO1Akek+ZplYu4zZRx0z083p8oKGe089CkYmTCKTKcpdcbp1MraDjCIVejHJ7iuFSFRJoqFYDLx0lx//J8q2dOY3ZPffwgaZvSUwsKcNiy8QYI9mFiYCAq7v4guDz6Gdk2EIcms4GbgA5/yEKoBOzhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
 by DM4PR11MB5264.namprd11.prod.outlook.com (2603:10b6:5:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Sun, 11 May
 2025 08:57:57 +0000
Received: from PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301]) by PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301%2]) with mapi id 15.20.8722.024; Sun, 11 May 2025
 08:57:57 +0000
Message-ID: <e5ede906-0dd2-4f41-86e1-1364c8321774@intel.com>
Date: Sun, 11 May 2025 11:57:50 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Adrian Hunter <adrian.hunter@intel.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250425075756.14545-1-adrian.hunter@intel.com>
 <20250425075756.14545-2-adrian.hunter@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20250425075756.14545-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB3PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:8:1::18)
 To PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6054:EE_|DM4PR11MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a90fb10-1eff-4951-702f-08dd9069ec96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M2MvdDhLcmNwV3VwM25hajFkQVRrOFUxSGNIL1lKODgvWWRKUk8rN3pHbGZs?=
 =?utf-8?B?WWZuQ0NFbGxzVzhteVlRRGhhWmI1MnY5VDhsc0loVHNOQ0kzUVNDNFNrS1lZ?=
 =?utf-8?B?bVhEaVlFNWpWZEpENmVzRlNkMldRN2Z5Mm12NmdFb0MrVjhtSFk1SFFpVHhx?=
 =?utf-8?B?T2llblQxQTZOUkp5VTFlMEx1cFkwZGVzNmRPYlQyNHNUaWtVWEJicmRXNTRk?=
 =?utf-8?B?Y3FzcEtJYlpXVXlNYUhQdzdzN1V3dTNlUWVmcVNaWEMySVdla3RmNE1JMllU?=
 =?utf-8?B?NG03M3gxa1ZQdG5mSUxrVkVYemY5ZEdZcW5yQ0dwRTV6K2tqRXNPTVJiWkZh?=
 =?utf-8?B?UHdKMjVLMW45azRLWnpqY3ozRkdMYjRIV0NpQk9yS2ZraU1HbC9XUHNBVDQ1?=
 =?utf-8?B?aFgwZUgrY1JNVENSelJDSmdySno0Y29BTEdFWllMQVNIU09tczNhOVhQMWIr?=
 =?utf-8?B?bG0rSlowSVppY2paT2gyUjFJMjdVRWYxWXRaY1FONTloQUoyVkpkWWpoV3la?=
 =?utf-8?B?TjNFVUVHaFlpZG1aY3BSOUVUUWJva3kyVXBNaGFIT0t4WjVhcGhSWkhaem00?=
 =?utf-8?B?RGlhQnNYYlZiVWdLZFlQZEdwdi81clg2cW5FdXBtLzlLOWt2QWFwaUZxMmpl?=
 =?utf-8?B?bkt2am9YMEd3c09EczdYSlovSm9rZVd6dmtIS0NkL09zYkJ6OEhFS2lkMnFl?=
 =?utf-8?B?SjlQbm41bGQ2MmZoUlljbDcyMnQ2WUdoekE3clE3WUlYUzhlVHlqZ3V0czBS?=
 =?utf-8?B?dWVJbFV0SkladHNFNEtFS2wvSXpUMWtDR05sclZiVk44MVhaWDF2VWo0NVN2?=
 =?utf-8?B?RmV1emlpL1oxN1hnTXE0Qm9zcC81NVM5WjFMN0pCSU9Pc2VJbTJmMG50Ungy?=
 =?utf-8?B?bGJCMysxRDdDYkNsWU0xQnowdG1pQWdBdjB2eUpFYW5ONzU3MVRBdkNMYjBV?=
 =?utf-8?B?MDBLeUJZMFp0QU9IZndTa3ZOQm1PNm1zVjYwWVZzRW1iMkxyblE3U0FTNGxp?=
 =?utf-8?B?YWZ1U3hpQjF5T0gySGI0WDkyaTYyNDZXZjZBaTZTNVlpVEhzck5GaUF1aFZR?=
 =?utf-8?B?UmcyajhWUXp1QVpNUkZIZG9kbE1XRndvMXdVQkVSbGFEYURXZWNFUkREU0gx?=
 =?utf-8?B?THFrQjNTUmV1K3I2a3l0bENnRjRmUkhZVGRsUU1ER0lxeU9hcWM1ZlF4eW1C?=
 =?utf-8?B?YWVBK2h6OFZHaXB5Mm9Cd1lkU3d2NG5YcjFuRzBnUStaa2ZDOXpGV3R0aXlm?=
 =?utf-8?B?VndLWXk4SllUcm10SmNJVzJRcXl2ZnI0SUo0MHF1WXVxSUNmME41bEhCTzJJ?=
 =?utf-8?B?eS9pY1J1cXU3VDRIdTZ5OC9tYytiOWpicVJpV3VxWkFldEZpMzZZNy9WL3hV?=
 =?utf-8?B?ckRLYWtySE52amlQa0szY1hlRVFrUkVHQWR2NHRvNDd6SlVGSU1jdFBSSjY3?=
 =?utf-8?B?Y2xNWk1uanZaVEV0akh2M05RZVNEbFNEQ1Vhdy9TV2RCUHhtdkFkUExsa2tG?=
 =?utf-8?B?aExmdnRTKzZYQ1hvWENoQXcxcmdES1BvR1ZlMGdpd1ZDQ0FPcUFOeFZsb2Vl?=
 =?utf-8?B?Qkd1aHUwalhiVDgwcHFxVWY5NE5zSStjeXZEektaVnVtVnFOb01YcENHUHVE?=
 =?utf-8?B?cldQRzJBbGRnQ1d5M3k4WUFCNk1BUHpzVU1XanpWbnkzK21OKzFMdVViM1pX?=
 =?utf-8?B?c2hVQitOMU9FM0M4SjZCTWFEUHpLUGRNam1vclJhTERPZ254L1hodnZVUFVa?=
 =?utf-8?B?ZFpaZ3I2ZlZLZENOdTF2Y1Vlc2d2cUxuWkczR2pmYzdicUlPMHlGa3dTTmFa?=
 =?utf-8?B?NUloc21ZZWVDVnVmbWtQeDIrNVhycldaWk5nQkQxbzhDR1BCcUlBdlV2RS9w?=
 =?utf-8?B?TXY1OWJLUTVzVXAxQ3Q3L2JOT1F6bUlQcUVBNGdKVERIUGc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6054.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmQ4VFlOZ2hJZWVuSWZyUkpTa0pUcEwyRzJYMEVSZXRma0MrZ3NRYjAzd3p0?=
 =?utf-8?B?M3BiclRCaXpHcDNOZ2FCU3pxWDlORjcxakh1NUxEWHlWbDlkTi9JcldiZ0Z2?=
 =?utf-8?B?ZDZhcU0yTW9Mb1dvMnZNY015SDR2S3pSSmkvbkRaRnNzK1Y3SEpKQnBEczA5?=
 =?utf-8?B?eWU1QW50ZU5ydW1jM0tuSElaeUVSVTNQUzBHTGoyY2hlYjViaGthc2V1YzBI?=
 =?utf-8?B?QnZkVXp4NEQ0VkNRdk5iRkZORUh2MjFCN050dUdWRXQzZWVucXE3WGw3YU16?=
 =?utf-8?B?YURDY0c0SFhXekJ6N1VFU283eTloWUYrYlpONTJUNU1HUmRKT0t1dHZvR3ox?=
 =?utf-8?B?WVdVYytBNUVudmE4cDZjM0hCZkZaZFpHYzFCM3kzU3N2RGRmM3A3MnJZaU1k?=
 =?utf-8?B?S3VIMUdNTEVHSDc5WEFlRnk5QjhvKy9xZFpuYUlObjloZytCOTNYZVQweUxi?=
 =?utf-8?B?QVd5L2hVT3d6djFESTJNQktoajJMQzV4dHNnV3JxTVk5Y1phR2NtdUtueFhE?=
 =?utf-8?B?WlRCTjIzVXFUYUo1OEswdTNDRWRYc2JkWGtSUUE4cWh2YmVweGRGZ3V5M0dr?=
 =?utf-8?B?V3pPVy85UzNtVGJYVmtNQmZhU3JybjllTnM0OHBod1ZnVm1rUVZXNEhtdGh6?=
 =?utf-8?B?ODl1UmZiNm5NY1NCc2F6K2h1NEtlSFc2RzdjejM1dXVIcll3VjdNMEVNQlVB?=
 =?utf-8?B?SzN4MVBTaFVQVWpoeFBaaW53Zytrb0JXY25iekZ6bjJBdnIvRXg1M1RnMWNW?=
 =?utf-8?B?TzhESXdYd2RKZDQ0MGlGOEVhQWRXdTB0dDltTkd5blBiSG85T0s0dEl5RitF?=
 =?utf-8?B?RXAvelFTUTJ1TDlLQlNhZGVHSXEyUnFVWEZ5REZYWU5rWUY5N2tlYWJWL2to?=
 =?utf-8?B?dHBjdTdlTHhMTmd2TFN3bWQ1dTF6ckNBdTNpcTZOdDhReC9YYmVOMWhudnBi?=
 =?utf-8?B?OFF4YlU2d3lqU21MUU1hemsxS1M3T3FsWDRUWGo3YXFaS2MwSkMyaUgxOVpJ?=
 =?utf-8?B?MFNFYkFodHRXL2VjTXp6cXhmSkxSSUxwOEJGTklmQVVuYjJEbHFVdndyc0U3?=
 =?utf-8?B?eWwyalRlajZDRGZhNWg0QkJ5emM2VnV2TDJScVp0TFlsRnFQTk10bkFJOWpV?=
 =?utf-8?B?a3IycEhlZGN6QWxuSUp1bS93ZXJjWEpPN3cxS0lqalpZNTZrU0txaFUwWmtw?=
 =?utf-8?B?Ry9xOHJ2ZWRObmd2SHJNbFJPS2huQ2NhOExWcXgvT0VkVy9BOHdFWEFvSm9j?=
 =?utf-8?B?T0FuU3EyVXZrWVBRcUhzQ0laZWREK3FENHNxYklZbm01M0xWQkFGUHQ4UVR4?=
 =?utf-8?B?Z01vckt2MDZyaG04TVE4dm05a3N2ZWhYNytOQ1RHeFBpdFNhcFdnVmJ1VXdM?=
 =?utf-8?B?SXJ5STZDMUY4bkU3MkQ4K1laRW5Ibk5la2gyL3U4Nmt2TjAzYnM1VVZDb0FM?=
 =?utf-8?B?NzBEUjlxbEdXRitCVUZ4bmtoVFFNeDZZUXdDZVdMd0Zvb3FqSFZrVC9WU3ZS?=
 =?utf-8?B?b21iZFc3VlBWNFdwUEQzazRBQWljSVFVeHl2NzBuemNoVzNYbnl3SUlLaVJL?=
 =?utf-8?B?MVdxV0lISDl3UVJYUW9DN2NjNXNtZ0dHOGFnNXpJRzAwbDNGQlZTQTIyRzF6?=
 =?utf-8?B?bGxHbFZoaHlDU3FOV3BDRmxpbldUWDVIV3dxTGpsV1NkbTNkNnRNY1BDRFR3?=
 =?utf-8?B?ZFlERTdiWldkaGx2MVdFVnRqdGdnSzk5OWd3bjdGN2I2U2lXaVJpWXJJUEV0?=
 =?utf-8?B?TWp3WVB4bjRLcmhqR0RHRGRhblh4VVU5ZHVMTmtCbkkveU5Va3o3TktTN0xt?=
 =?utf-8?B?UHNVNU9nWUVoTForb2YwM3hZM0RiYTdyRmwrMmgzNFFSQ0xkRTk1WDBlQSt6?=
 =?utf-8?B?RjU2VjhxOWRKdFEyK0MzZ3Q1dldEcjhsVzFGTUREUEFiUm96TlFMNTVvMjVR?=
 =?utf-8?B?TmRaOWp4L1hicFZTYnVpbC9TdEVsRXcxaEpIUGpoME53NnpDZHdIdjFhaTVx?=
 =?utf-8?B?NGttWng1NlkwMStKWTgvSFZYUnNRVUR1bXFRQnRIMmRqT1dvYmlVeGZlVXU0?=
 =?utf-8?B?NXVXY0ZxTjE5WDdIbEptZy9YZ2dJQllFVE5KbVQ3VU01bnd4bVFPaFpKWUVT?=
 =?utf-8?B?NTZ3NWF6M3A1aE5uTFNwMk1lS0FZMVQ5L1NtR0FVTE0xTnAyV2w0REpER3hL?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a90fb10-1eff-4951-702f-08dd9069ec96
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6054.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2025 08:57:57.5514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJn1ndJrAgs+0/6k7S4U11rGh+6dJLOII7EgkUZU/HHRYU3hulmpRm21UtGS7UdXqb78ogsxPT2v/qCD9qatGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5264
X-OriginatorOrg: intel.com

On 25/04/2025 10:57, Adrian Hunter wrote:
> +static int tdx_terminate_vm(struct kvm *kvm)
> +{
> +	if (!kvm_trylock_all_vcpus(kvm))

Introduction of kvm_trylock_all_vcpus() is still in progress:

	https://lore.kernel.org/r/20250430203013.366479-3-mlevitsk@redhat.com/

but it has kvm_trylock_all_vcpus(kvm) return value the other way around, so
this will instead need to be:

	if (kvm_trylock_all_vcpus(kvm))

> +		return -EBUSY;
> +
> +	kvm_vm_dead(kvm);
> +
> +	kvm_unlock_all_vcpus(kvm);
> +
> +	tdx_mmu_release_hkid(kvm);
> +
> +	return 0;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -2817,6 +2825,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_TDX_FINALIZE_VM:
>  		r = tdx_td_finalize(kvm, &tdx_cmd);
>  		break;
> +	case KVM_TDX_TERMINATE_VM:
> +		r = tdx_terminate_vm(kvm);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;


