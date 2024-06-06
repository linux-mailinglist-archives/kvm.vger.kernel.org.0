Return-Path: <kvm+bounces-19028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EACE28FF3B4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 19:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3976E286BEC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20911991A4;
	Thu,  6 Jun 2024 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIuONKfy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F58198E90;
	Thu,  6 Jun 2024 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717694883; cv=fail; b=pGlLy74K5YfHgyL3JjmOMrYc3gHQiX51c3DJijOJ5E3cE1T8MRBlWAFQVuf9J0I7SGZ3Scu9r6FrxlJ2VFz1j9OgNqLahLh9g9npvp28Koz8F5z+7sWBEjKtFiN1R4UQWiPf6zThujAfbE8dNySdP/fnAgHVBL2wuP+oHa3fmYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717694883; c=relaxed/simple;
	bh=q7zXbbohXOZvQrI+qFx19lkfo/L99EPUDSB9rkztnvc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aPCC+ec6qXZJBvXBrFSn+/zvrdgll7JNvaMFPLrk/zzhqxzyYVnzG2/Q6Wj7wnQ/QItCYqA6DOxyjs90hGRHORKreVgK3Vpto8tWw83Mc9rcindaa0vY0idGsJsFCvSwd9io2gbpDGh9qrfh/o68QpMoY8/kGQVbPzviAcxyJCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIuONKfy; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717694882; x=1749230882;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q7zXbbohXOZvQrI+qFx19lkfo/L99EPUDSB9rkztnvc=;
  b=jIuONKfyCsKRuUzfk6Tgw/ahWMIziAgk3/ltDZs5bWAv8SuLD8EvBk0u
   dm8M0DEIPUTWi1iES45n0j6MP7YaH1pSGY6B0z+cPPc8L+FyKJBtzbqMb
   0/0xyVPKIYoqp0zSp9qAKu/LMVnldVBBz5UfcPC5NuO80xNz0r1j9MvcK
   wQ7H92OWHh3AStEnllEa4FTESV8/+ORZuE6IVhErMH9pa0bAUPrNoS+5W
   9Slyl1H4Gqlb7gdOdG9tZhayt9MUYHRdEeaNPiVmB1OjAGEeirZbzb1aS
   TKzTYEAStZez1FAyy8sd33kdK5jQZF/7KEtd8jIH0YTCLLfT62qLSL77O
   Q==;
X-CSE-ConnectionGUID: HsCUA851QGqZMOEiqQYC4g==
X-CSE-MsgGUID: 600lef0JSZO3/dyg4PKS1w==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14566588"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14566588"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 10:27:59 -0700
X-CSE-ConnectionGUID: O1r65RsrQfiwIDjAgZb7Mw==
X-CSE-MsgGUID: 6u1eVdRMRRCLT1CUC92Tow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="38050104"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 10:27:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 10:27:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 10:27:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 10:27:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 10:27:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/+GPWu0Kt36ierVLadTUZZz/yKVFb5XMwDrYf5WM351kIHuAMtUQXyRl36XTA2YwiXLpYVy9ZfueKKMyc5XbEBtSp8UGJW+AHIXGyk1/dXfFzTA8EgnLtPIyyLiZ5bFX19O3hnjWRL+gG4MU50owbxGojfruXk/6w/q5gWjVz2E5lvEh1GkHLUlK3+lqHyhjsSVKUVsD96HeGfo/Ghpt0tocBv0kXBmFsIk4b1eKZjx/Uhyj1OnDMXU+jBE2IRTKvCYdX9TfxvNbFqE+B224VDrKUb5uYDhp0N0vLoM2RjUO6JrGiobF8/FDyCzUYliKt5lkLsykOOHo6tQSValcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaZ8Q8DUg/CRZ2pLkL0gXX2MAxuPKv3sEfGSYm5hJ48=;
 b=YmK7s/OgIT1wIzFdsGvclWdJa5VQHeliwzzn7L3gbRLCtJzWA7abXRCuJwpmWudMeL7rERpYRRhCV+tx24PQ9sELhUUwjv2Uo06Zs8qOLjw5IVSt6VDtkA7c9iwwUnLihCthpe5XyzGViWdDhi4mC4nh/1xULUcZjVAeLH3S/btuhHESK10dyn5WcqJKn3xrLDw3uONl+RYoCC0C18loztJUf/2FfyAdK7sTVDD8nSGDQkMEkn885WTWgclC1IEtyOAzbPln1Vb7eAz2JuhxC1q5aO4k2DHOi6uOuXrXVzhuljXtNnrt11uQ/yWuow5BJHJaBB2k4KtNFiW/2RzNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7506.namprd11.prod.outlook.com (2603:10b6:8:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 17:27:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 6 Jun 2024
 17:27:54 +0000
Message-ID: <688f492d-f999-450f-9ae9-d5dab078d2a8@intel.com>
Date: Thu, 6 Jun 2024 10:27:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <Zl38b3lxLpoBj7pZ@google.com>
 <d2d64211-bd70-4212-811f-c039d2d8dabd@intel.com>
 <ZmB0s7UsfSe90kqr@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZmB0s7UsfSe90kqr@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:303:83::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7506:EE_
X-MS-Office365-Filtering-Correlation-Id: 779dee6a-0fb9-486a-6f20-08dc864e0017
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXArRC80Q2VjV0hKZy8zRjFSRGc1ZVdoZHZiOENFVm1xUmVQQ1RFRGxtYUF4?=
 =?utf-8?B?MmpzZXFzZmRWbStVM3c4WWpubFF6eDRJUm9kSS9tRllnQjNHdXlNZVRXbnpu?=
 =?utf-8?B?Z2pYajlpYy9ZR01IWEFmZDZnblNwWC9ZMHBVQWZlZnArNEdva1ljT3pKRndJ?=
 =?utf-8?B?SmtlLzJqU1hObWREWFU1TWZ2d2tOUkRGYWN3NDFDeFR2eHJrL0ZOazFhMnJ1?=
 =?utf-8?B?dXl4T1h6RFAyT3NjaFF1TGlmcSt5RFgrNUtwbkJGZ3FFZjdIbFVLMC9xWU9p?=
 =?utf-8?B?R3ZsTzk1M3NYOHRNVGVQRDk1QUUzWDVrL1VMTnVINm5KQTIwUDZGWWUzK3Fy?=
 =?utf-8?B?SGY4ZDA2S0I0a2pkaERZQXRidDNaKzUrdnF0ajREMGtxQ29DSmdpakNQOGU3?=
 =?utf-8?B?anhhMzNTSmtzKzREUmdwa3hmM2EvRjRKa1BNeDd6UzR0b2dqdFNENUFBYzNv?=
 =?utf-8?B?a3NIY0UrQkh2TUxYaUNFOGU3MGxGTUd4NjRrUXNQR0s3dmhBQTZ4VkpuM1I2?=
 =?utf-8?B?ZDBQR2pxWTUwTzQyZTNGY2hnSjJMamFyYy91V2Z1NHFoZkJGblFVSm40a21D?=
 =?utf-8?B?YkhnYnpzcVVuQm9yVGNuUlZuelUwK1pEeDhjWUxlcmgwV3hnbUVXaXNpNkJZ?=
 =?utf-8?B?NnhRd3dNTldyRXBLODNUalJabHp6OGJvOUxURk52dklQSGlZTzdIQmVmR04r?=
 =?utf-8?B?b0tWSmh5eTkzbDdsL0xmMnJ1VUgzN01qc3R1c0MyOFVhS3dyeFZBdlhuQ2Zy?=
 =?utf-8?B?U0Ntb3VYdVRHTUJtWGVuWHhncjVwcHV5S0FEUFhPRVJkRUM4N1hMK0YrSXRF?=
 =?utf-8?B?NExzK3dQckNKMXlMZW9kandLK0VGcXhWb2thUTB0UUJaaXdnVXJhSlE5WVVN?=
 =?utf-8?B?bzVXMktldHJIUktFZUdaVDFqWDZNc20vemo3eWRTWlVPOTY1MmlRek9uMlZj?=
 =?utf-8?B?M0p3NFA5Z1RQYkFjM1ZJcXpRS050T1VEcEdEK2d6NFpBb01vRnZFeFZoK3JX?=
 =?utf-8?B?djdESjhSWjcvRldXdDdzN1pIYzlMMDlTczRrb3JsSWNJM1RrN01uNjduZHh0?=
 =?utf-8?B?THRkUDhCMlY1TFU1Y3ZWMnRXbmFoMzBkMmV4bE96T2lyeG9ZNjJtZm1Ca3Fw?=
 =?utf-8?B?OWE5NWtjL3VUVFhmYVgzTEorb0pkUUFuY2ZWck5Yd0c3TnhqaGFxT1R3eFVv?=
 =?utf-8?B?ZFh0RUphVnIvZHkvaEY2OGY2TE5ERUhyajJsMjVXc3pSZW5tYWw4by84RkRr?=
 =?utf-8?B?VXVmZnVMNDU2MXduRlVuSmhuKzFLWWhMWXQ2ejdQSERDYW92N2FHbDcwelpG?=
 =?utf-8?B?a05KVUwrUm96Z2UzdDV1OGxPOXRqM09ud0hKQjRVUms1MlFSN2xNQitxOXh2?=
 =?utf-8?B?TVZyV014TFJjaTdQK2tTcEMxV2pxNGRndjRRcmRUL0Q5Z0h5dGpMRVdtVWpL?=
 =?utf-8?B?RGZjREZPUmVYN2JXR3ZtaWhRdDdLT2Z6SDdIanBHU0tCU0FIUHhyZ0hTd0No?=
 =?utf-8?B?R0VPS0taZlRRR1A1Mzk4RGRneVlwMkVDMlZqZE9jUXdnWlZGZTRXd3YrdC9i?=
 =?utf-8?B?ZndGcXIwRnhINklnQVpxQTN3TXh5Z3hoUm84M2VFVzMvdmU1TVEzampVZkFQ?=
 =?utf-8?B?UXpyOFNBVHU1S3JDUUEwV08wNW10eDZwZWVsZnZPNXdUQmdQeVRLMHA3SExE?=
 =?utf-8?B?djJvdE00enlOYUJWdk9rUFJMMllsS1NmTUNEdEdqTWQ3aE0xUlpXdzVLNm82?=
 =?utf-8?Q?BPnHdr7F+hlyqyhi5itL9IcjREQUXaKz1K7kVY1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N25pOWJ3VE1zVjMvNUhYZTdpaFBqYUJGMlY0SmxqZHJYdFFwSUMyOUdmZys3?=
 =?utf-8?B?ZkRjbW5mWWQvaEF2VjFwUDZBcXh2ZDFxMGtTdlpGc1JvaEQvTlJNZkVyU3Ny?=
 =?utf-8?B?NE1PRUlnSWVHemcrZ1E5YU5GRjdsVnB1S21OYWJUNDh4T2Z3L1l2Zk0vekNZ?=
 =?utf-8?B?Nkdka1c2di9YRnI1c0JocllxUURvMHhaWDlES3p5UlJIZnFmL3JsbzlEQnZ4?=
 =?utf-8?B?cytiaytiNXlYR0dEaGRpVE5pa0lJZUxsUGVyTWs3NjNFUUxONTlOT0hRb2w5?=
 =?utf-8?B?SmFycVVhdjM4L3l2WklLaXY1R2lwOEtiS0FBeGFFSUxmM3pqZ0V5aEVOdmg2?=
 =?utf-8?B?NzJVbzZOcUFZYTNWNHdzSWtabm5xTmU3TlRTSjl5cU5pZHdxenZzRHozSnJY?=
 =?utf-8?B?anNGNlZnMmxRclVOb2o5ZTFIRldPV20vVWlaZVFML3VxTG5KTlhXaVlQRWdo?=
 =?utf-8?B?S0hJRThQbk5YdWk0YzdERXY5ZG0ybVhuY1F1QjM5Rzl4anVwK21VRGd2LytZ?=
 =?utf-8?B?MTNiZzNaK0dpUG0waWRnQVVsRVMwMDNOek9hMktlYXlmc3JBalIxcWtrSnA1?=
 =?utf-8?B?RnFxODE0cWEvZEpicGNtUWQrVjF0amlwOSs1eEVWcFJoRVpNRTdET1YvNXVt?=
 =?utf-8?B?dmgxVi9rc0ZVbXdhditkbU8wSVFyeUdYU2hzbkFWeXlraWtIR3d2Ym9vb013?=
 =?utf-8?B?NjVBVmtmQUFwazVvaFVOZlVjVlZPbS9iMnJLMk5CMG52TEZFK2VpY2pkamNW?=
 =?utf-8?B?T1VPeUJWcUhybExmWnd3OXJ0OC9QbkdKVDhtTmV5VHJaT0tkRnQzSGlFWmg1?=
 =?utf-8?B?YVZMY3UxemYrL3Ircy9JV0tPbFRSd1BVWXVxRjZJTGUvTkVOT0YybHJxT1VE?=
 =?utf-8?B?bVRnNGZXcXhVWE1YRDdoeDB4UzJ0UUFGbnNYbEZRWkk1RG5OSkFrVXdyRnBl?=
 =?utf-8?B?Qi9UU2NjaGR5cEh1ME9Yelh1V2c4K1BZNDNvYlk2U3JUcUFDL21STlZBVDBx?=
 =?utf-8?B?RWM1cWFBTHg1UlcrYXRETXluelQwaTFSSE54aTJCNDdxTlFVRVBld2NXNlB5?=
 =?utf-8?B?aVNvQWRqalA1aWQwNHBSeEFlUnI1dEVCSU1OS0sxZXhBN3hmZndTUURDOStX?=
 =?utf-8?B?ektFMHo4S3QvbGh4d3JzTWJsVE1FSEJaYnpaZXFOTHFDaFZva1NyVXhHcmpT?=
 =?utf-8?B?N0lxU0xTMHY5c1B1WmlrRURrOVhpSXRKWkNMSWVUeGcxNm9wWWRtL2J4UTZK?=
 =?utf-8?B?YitDT1pYS3J3TC9wQjh0RHFVLzZEcVJDOEpnRGh6eG1QZWI0dHcvK2RTQ3Na?=
 =?utf-8?B?cXVYMmxTTStYQjJDZWw4M1YvdWN4T2svd0x0ZlF3My8zRlpIWEtqRUhiWm9Z?=
 =?utf-8?B?VU03dlVYZHE0Nm9iTTl0S3YyREZKc25OckhKUmdNMUZhbHNiN2ErYm5sQmdu?=
 =?utf-8?B?OFRETi9qcGlpSnpWbWFSR3cxWFZCVlpjb2czamZGWnFMMVlIQzNodGozNzV2?=
 =?utf-8?B?d0lmSzNac1dmbnBLRVR4WlFjSU9TcVRUSjk2azVrQVpidmlGR1RXUU0yMDRx?=
 =?utf-8?B?UlVpZERZNVFQb01vZUlZL3A4cWliVmt5TEplQ01Tb2hLSGQ1UVEwOGp5UHVF?=
 =?utf-8?B?a0kyYmY2bXlrbG1aU0UvamlZVlJaeVVZdFNOSm1uaE43MHg3VXJMdy83SFBa?=
 =?utf-8?B?MHI2OUp5OU5tSkJDY3VTU1hsUUpRS2owZTNOVzF6ajRRRm4wYjRwYm1tY05h?=
 =?utf-8?B?dDIrMTVNaVlWM29iOVRKTUMyVlJ0Vnpndm5TREVhQUpvdDBqSmhSc3FtRVhE?=
 =?utf-8?B?VU8ySXhCUFlUOXMvemR0S20vVWVRdHVyQjI4QVN4MU5pejN0Ym1iVFR0NjBW?=
 =?utf-8?B?Mzl1dDUxeEpzVEN0N2lpREJMQTlkUHp1UHVFQ0orMURoYzVlSm5udEFMQkFy?=
 =?utf-8?B?NWVhMFo4ZHpvWE5NSXk5MXZ3aTRoK1BtZnUvQ1FPZ00wVlNCMzUwK0Z0Wjlr?=
 =?utf-8?B?djBvall6ZXZ5U3ZoUWo2UHZkS21Yc2JHZjRLTGU1TWRZWklkbkcxV0crT1Rt?=
 =?utf-8?B?bFl3dEhER0NKSHo1dzlrNjVKV1BYVlJOcEppdTBIMm9teVVlTXVLNitvczZS?=
 =?utf-8?B?by80ZGJFS1gxZ09zOUFUWUxxR05TSE1ISG51RXdnY0NpMzVucm82VUF0ejQ0?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 779dee6a-0fb9-486a-6f20-08dc864e0017
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 17:27:54.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oPjBiLCxBSSKfhfZiBcVbvhbG+6rbj6mjXMB1riTjZ6CZy9+rLY4OQl3xd6ZXtN2B3M8KdUrokwGdi4c8qesEQAzfaAqVG+T4vfSxDfqeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7506
X-OriginatorOrg: intel.com

Hi Sean,

On 6/5/24 7:22 AM, Sean Christopherson wrote:
> On Tue, Jun 04, 2024, Reinette Chatre wrote:
>>>> +/*
>>>> + * Pick one convenient value, 1.5GHz. No special meaning and different from
>>>> + * the default value, 1GHz.
>>>
>>> I have no idea where the 1GHz comes from.  KVM doesn't force a default TSC, KVM
>>> uses the underlying CPU's frequency.  Peeking further ahead, I don't understand
>>> why this test sets KVM_SET_TSC_KHZ.  That brings in a whole different set of
>>> behavior, and that behavior is already verified by tsc_scaling_sync.c.
>>>
>>> I suspect/assume this test forces a frequency so that it can hardcode the math,
>>> but (a) that's odd and (b) x86 selftests really should provide a udelay() so that
>>> goofy stuff like this doesn't end up in random tests.
>>
>> I believe the "default 1GHz" actually refers to the default APIC bus frequency and
>> the goal was indeed to (a) make the TSC frequency different from APIC bus frequency,
>> and (b) make math easier.
>>
>> Yes, there is no need to use KVM_SET_TSC_KHZ. An implementation of udelay() would
>> require calibration and to make this simple for KVM I think we can just use
>> KVM_GET_TSC_KHZ. For now I continue to open code this (see later) since I did not
>> notice similar patterns in existing tests that may need a utility. I'd be happy
>> to add a utility if the needed usage pattern is clear since the closest candidate
>> I could find was xapic_ipi_test.c that does not have a nop loop.
> 
> Please add a utility.  ARM and RISC-V already implement udelay(), and this isn't
> the first test that's wanted udelay() functionality.  At the very least, it'd be
> nice to have for debug, e.g. to be able to insert artificial delay if a test is
> failing due to a suspected race suspected.  I.e. this is likely an "if you build
> it, they will come" situations.

Will do.

> 
>>> Unless I'm misremembering, the timer still counts when the LVT entry is masked
>>> so just mask the IRQ in the LVT. Or rather, keep the entry masked in the LVT.
>>
>> hmmm ... I do not think this is specific to LVT entry but instead an attempt
>> to ignore all maskable external interrupt that may interfere with the test.
> 
> I doubt it.  And if that really is the motiviation, that's a fools errand.  This
> is _guest_ code.  Disabling IRQs in the guest doesn't prevent host IRQs from being
> delivered, it only blocks virtual IRQs.  And KVM selftests guests should never
> receive virtual IRQs unless the test itself explicitly sends them.

Thank you for clarifying.

> 
>> LVT entry is prevented from triggering because if the large configuration value.
> 
> Yes and no.  A large configuration value _should_ avoid a timer IRQ, but the
> entire point of this test is to verify KVM correctly emulates the timer.  If this
> test does its job and finds a KVM bug that causes the timer to prematurely expire,
> then unmasking the LVT entry will generate an unexpected IRQ.
> 
> Of course, the test doesn't configure a legal vector so the IRQ will never be
> delivered.  We could fix that problem, but then a test failure would manifest as
> a hard-to-triage unexpected event, compared to an explicit TEST_ASSERT() on the
> timer value.
> 
> That said, I'm not totally pposed to letting the guest die if KVM unexpectedly
> injects a timer IRQ, e.g. if all is well, it's a cheap way to provide a bit of
> extra coverage.  On the other hand, masking the interrupt is even simpler, and
> the odds of false pass are low.

Understood. Will mask the interrupt in LVT entry as you suggested initially. While
checking which bits to set I realized that the existing test was enabling oneshot
mode in an entry where those bits are actually reserved. This is now fixed also.

I plan to send the changes as next version of this work, with merged patches
dropped from series.

Reinette

