Return-Path: <kvm+bounces-15614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AACB8ADEA5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A312B228FC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 07:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8034AED7;
	Tue, 23 Apr 2024 07:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/RgGpfr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F22481B8
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 07:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713858912; cv=fail; b=lRcic+60EdvB3a/MmQpaHRVc9iZ7aZ26WO9tiW58iqZLzwGk4rVXetQMN1pdVt7NRtHwSyaE3uxBEqlgBA4ywvzd4wPINXZWYy44u7Cv4nkoM+bmHXIDZFGlM+0tAEXNzhswwwRUxkrbhxNihm7UFx4bjuAtb7Q7p8194ztiO0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713858912; c=relaxed/simple;
	bh=jx9Up8TsNYuujNbAkaCZ6YTKJNPoRWeBspiV06s1QOk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ACpsmX+FYDB7LYdUkO7TwyetpJFEle/496UWwtA4sAPl1NaRK3c+hAd+pfli1AOU7x0KjnGLCHBwVZiPRhj/xYeggTuK9Kh0/O1Ewd9r3Z/vOFCKZNYsDoNrQxSu5/SykjnKbQUZOBQRI6nb6NJ1pwxqe10qxIpHImXPqDlFxaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/RgGpfr; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713858911; x=1745394911;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jx9Up8TsNYuujNbAkaCZ6YTKJNPoRWeBspiV06s1QOk=;
  b=V/RgGpfrgOrTL1bGR4ETiSVxyrL9zUGLs8NdqQ8T7ywvyp9AUgYdYcEu
   IytNeKkqfP7kSSPI8Yqt3LrWDhfxnoiXVNXgJEuDFtBZZsUVWLmD5Eq98
   Llbl3c+ATnZRdvfPPzJU2pRjO/vZzZW78e1uEVdzafTtivxzzf6vNYCRQ
   ieC1CxnUgqxmZ1Vaimem3ASw0anicKQ1iW9xyO4uWJM9SNYDUgEmdePKx
   Kv9y5sgYDAkMeFHMgbFvsNrRlWNpviORogZiWpooVxYCP2Bwt3Z8lo8j+
   b4EWHbR+EG5qrxP9rj9Muf8KrRn2kPN26VjSdlnVTq9bWHc7dvGO1H/Xj
   A==;
X-CSE-ConnectionGUID: mEO9zmOuT0OFQEeVUwR0cQ==
X-CSE-MsgGUID: lbEwJYU+RAy0nfECAMK6+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9261397"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9261397"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 00:54:55 -0700
X-CSE-ConnectionGUID: I/cLadzyTdyd7CBl5pTYVA==
X-CSE-MsgGUID: rUVpjnqrSLq/eFHiG+OYTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="28943470"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 00:54:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 00:54:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 00:54:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 00:54:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0axK9w9DvWO1OtKgDycdbFG0fQajyh0nRjUos8tpUSvSMjgp2iod9m0it4GU2ChxHw1YoTm4Os1t3lUkBS5nAiAgiquf7qVFDuSzaqm5EsZGgOd/ih/4mLj0PlCONQjQ6isYwooFym7FowC5TlbUVJ1CTApoYJb4i9VRws0FlfRueBGvUk0I6CxBGmHmQrR9bOg5y5YCs+CNshWEPqJL24R0CIsC+5MhcFhxEJi302ZXaNlCOQyDzOtOZGPwvTrI1Dhgb19+qsCsN3fA9KjKMUrED2whHqWnhPEVvFO3fzKSSjViAWps1w8llfHUKz1b2vjpX+rfqkiYnqHLCzeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVSfgWXW1680yR7p+QeF00ZWgHpNr62kNOMxO1LxbHI=;
 b=oGo2cnFahW/doI0/qM/Jy6UODlRwuhjGH23KQE9S9zvJBMgkWrOKxcvLo7WUp+uTa0uoX/wDcOSv2fSWnZqJjStcQ5f8inTnhfvIsMxNgwNpaZRJhxQfphoKFPGIIOHLhcWsmWlmdfs6F/swr8JCOU+hiXf/PuMjn048s1kDooy+x1XKiAF2fmjaB+nyN5jusf9kkV90d0//Mq75raQ+GeAbxMGWVq7pY6E8+/qjDZRu6n6FDWJfVZzwnnXe3xam1iwU5FgumfWMA44MGSMw4+CGGPa6fEdjhOYJ1q1BOaOwvm9ROZ2vldGjmvWZeG8m3GPTJlnNabtiZCJcyAD5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8546.namprd11.prod.outlook.com (2603:10b6:610:1ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Tue, 23 Apr
 2024 07:54:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 07:54:45 +0000
Message-ID: <8e372b68-90b5-4fa6-88a5-79ee0cb4c41f@intel.com>
Date: Tue, 23 Apr 2024 15:58:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <20240419135925.GE3050601@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240419135925.GE3050601@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf756a3-b1e8-440f-e983-08dc636aa428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnBUNzZESitJWEs2THRuN0E3QlR1QXAxN3ZZMVIwMWY5UERjRHFCN0NmUkFy?=
 =?utf-8?B?WW1GVGdGL1NjY0JOMzgvb3NtVWpGbEowb3Y0YWUxa1lXaDZZY0d6RlBscGdi?=
 =?utf-8?B?b21mTUdtNVlkZG12VXNpbFhlRmRNeGtLbzBTQ09TNlNJaUZyZmt3ZCt3cHNo?=
 =?utf-8?B?OElCU2I4R3NYTy91aEJaUVNrRGR4VU9IZ0wvQ0FiYmtnMHBtbFhaNy9vRVZU?=
 =?utf-8?B?em5xSzhqaXVaL2tjdC9UenY1ZGZLY1lLalg0d2RpWnVDTXFFa1lTcDRMd1pX?=
 =?utf-8?B?MDBNeEZtRmprWU1uUDYxZFlISXlvZ1pHcWpGVnNONjFWRUNnV1VhSDdYTTlT?=
 =?utf-8?B?dE5ab1IzREluaXM5QVVFd25ZQzVSaS9DMEZ6bzJGK3FWNmJSS2pYRVN3TDBE?=
 =?utf-8?B?MlJZL1BINlpYOWVNdEpsVXRDTlh3SDJGcEdoOTBiNTV5SXVWR3A4M3JLOEN1?=
 =?utf-8?B?MlRBZ25pZHFxNUdPb2p6STlmUDkzTzJydkZCS21OZUEzWGNQMk9SZWtlK2tq?=
 =?utf-8?B?aWJVTHNSR2J5cmIxRlplTHhNVThqMVNtaDZsUFk4cGl3dDJLV2JvUHlrMHF5?=
 =?utf-8?B?bjlDWTFxRVFIOU5lNytoTDdaKzZVVzY0K3M1ZnJ3V0lrdUozL3ZJeEU5bTVX?=
 =?utf-8?B?SWo4U0ZLVFJDWWk0OTE4M1FZaWxaeGtHREQ3bzdQYVBtQVR6QTlkWnZ5dHdK?=
 =?utf-8?B?R3BJVTd4SElQWnV1NnNFc2lqaVRiN0hMQ3BDcUYrb1lobkR6OGsvcXFjTVpG?=
 =?utf-8?B?Nll0V29UL1M2NjIvZDd6VHB0ekpzTEE4bWk3b0YwN1MvMEl5SDRYY2YzUG5L?=
 =?utf-8?B?Si9WZU5sOW1TLzFVY0JUVHF1V1hyb1Y3bFNCcjB2N1J3OGt6dWZaY21zdmNu?=
 =?utf-8?B?VTYxUDNBOEVOVEhrZDNMa1lBZEhDNjloYzJGM1kwU1JRVjgrMUF6ZldZVXU1?=
 =?utf-8?B?aGtXSUNobklCaVdueVJDa0tZYkNlZlNGQWNkZDNVVENGZzBQM0k0WlAzcjVL?=
 =?utf-8?B?alhic0JQYkV5ODhjOVcvTVRBVHRUYlpaQm5MM3ZiM1o1cForZlFDNFBQMXZw?=
 =?utf-8?B?QVJseGFkV2lVYUdPYUJzc1BMV1Fsckg0V3Fuc0NIVnpjRGNkczFjRWNFUE01?=
 =?utf-8?B?cEpwZlN5UlJEaU82anFhN2FNYzVTcXdXaTFKZHFpT3BwUVRLWDBvZ0t0Qk1E?=
 =?utf-8?B?d2xFZHVVZzNYUUVtaHlpakhPRkZKbmdOSHlQeXZCL2Vhd25FK2w0Qk52TTZK?=
 =?utf-8?B?Z09VTnF0aEdNRDR2Rm1SY2tRdHFNZUtuMmdDTXE3OFFpRmlXZlRyVWw1QWlD?=
 =?utf-8?B?UDRSbE50Y3dYNGJVdHlRQVpOUmFROWxnYWVMRTFrOFBhS1ZRTTZvdFpScHJQ?=
 =?utf-8?B?WmNQbVY1M1hTbEdoT3U5RCtiR1JQaE1CKzlDSU5JdUp3NnUza3V4ZmNBWE1E?=
 =?utf-8?B?b1RVK2xzOThYOE9oaU03MlBYdWlydEtEb0dMVmZIcmhGbWM5VlhhTVRCdjBN?=
 =?utf-8?B?K0xKVUVHQUdLbUJxSlBpaWY1QytYeGdPMUtINkJ0QTRXOG83aVh3d3RJVUhV?=
 =?utf-8?B?TjlRVU1jSzZwOXhScFFKMjVsTzN0cjRBODVaOU9DWVJnckdrSjI4ME1JZVRX?=
 =?utf-8?B?T0tGZHFxTXBIODVpa1BHcWFrSGNVcTFTb0lBSytSbnNtM2xTR3B4QUpGTHlX?=
 =?utf-8?B?YUxSa3UxcFpBdGxYZ3NmdVlIWHZ3cmRzU0VqcTZOMnJsdWdJZGt5ejJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzVkcHdlSjBTRUpUUEltSHhob2JSSGZ3a1MwTXVHcFkvMWEyL0EwdWlBUUlo?=
 =?utf-8?B?aDFTT2JOWFlzNVRmSkNzdndqWWpSWXNnR0RXNFlqeG1BZ2tCVjlSUTYyNU1M?=
 =?utf-8?B?NDJOYmllRGtEUE44Q2VnRGVCKzFpWUwyTjllM3E4WFV4eUtwV2VEY05jZERJ?=
 =?utf-8?B?YzN2ckp0YVVuNFZZSTF0bGUyRTVCbHhNdmxBbkNMODRSR3RzVGNVZ0xSbkNW?=
 =?utf-8?B?eDFjM0Z1cDd3d1BQbjZyZkNDNXc0Qm9OMnJzOWZxMGZaaW0xUDNsZXlrWXVo?=
 =?utf-8?B?ZXU2a1R0eWpGejZVaGV0ZFlzbTIrT0h1L2dBV01JMUlSbFJ3OTcxZkxXWXlS?=
 =?utf-8?B?dlNWSkQzZ2tVQjJHY2dNRmJxa0hIU0VwWmwzN20zTi9yNWk3SUoxSXlFSXMv?=
 =?utf-8?B?cGlYSFV2VklIM2RvQ3poMkZtL2VUMVZjeFR1ck94RnVEVEJxTmYyNnBxRVUx?=
 =?utf-8?B?S2QzOXhxbWpxS1ZSUkxkNTNDSzd5dHU4T3VQZG9DSWlYWXlZaTg1UTBiRXQw?=
 =?utf-8?B?YVJsaEc3YWFBTS9TaFhIcmQ0akplQjBLU1IwL1hYcTlTekcwU3VOQXJrK0Rv?=
 =?utf-8?B?YlFheTBWVkEzYmlSVjVUcURZbzl3U2JqcTg1YkliQWt1S0Rhc2twTGtsSWNO?=
 =?utf-8?B?V2NWUHE0VUVpQ201cVlzUmxheEJ5U2RDVk96aEZpcUI2M2EwRWwzbnRUR2xj?=
 =?utf-8?B?VTIxdUlSTDhoV0FTcTJSeERsT3JDVHdIZFd5TllDdmxvQk94c1lCWGM3KzZw?=
 =?utf-8?B?Mm9HdVQ0b0kzUTVtMUtOZDlvNm5Nd3dGNlFoSk4ycUgrL09wSUhSZW93TDNo?=
 =?utf-8?B?MUhrRkxDOHpOUlVFVzBBSGpYSHQxWnpsMURuUWhndU04R0ZIQlIrNzZPUFlS?=
 =?utf-8?B?QktseUJld3FFNSs0OUUrTmg3VXZZaHpsVGpxbTZUeEp0aXpNamdGN0pQLzZx?=
 =?utf-8?B?SUQvZituQzNYTitpc0V4cEY4c2Z5SE1HNGV3MlYyeWlGMXVZS0l1NCsxbDZX?=
 =?utf-8?B?SU9DTXJzdVlscEd1MXNaQnBtck13eEFvOUV2c2huWlcwQm9zOVJyaWtvekJh?=
 =?utf-8?B?eGlSbnRhdmczY01CSHYxc3RDK0lKWVovVWpNQ1dSWU9iSUhyajN4S2JWaGVq?=
 =?utf-8?B?OFRMcVhUajYwV29yUjdxcjQxUUVPdWdxRU56L2Z3anJIUjIxKzROZER2UTRN?=
 =?utf-8?B?OHMvYjFueUVqbHdURXBtUDMrbHJhZ2ZMWlVyS3VJU3VyVXFrSTdQYU1vZ3Ay?=
 =?utf-8?B?WjlTZVNtWW5BbWNQNk5SSzNhM2YwWWY0UzRPaEJQeitSSWxpL3M1R2xWSUhx?=
 =?utf-8?B?Rno4a2p5dEMrSmpucG1wZnlwcjJUOEowZmdqM0NJTkl5ZW5mREs5V1pmMFUw?=
 =?utf-8?B?cU5NSlE4RjR6UllZKytHTm9UZ3Jrc1BldDJ0cnR5OTgwRTZESmpHYmFUcnBh?=
 =?utf-8?B?cE50TU9CaHZLZ2ZkazI3RGlOc2VlY1hOUjErKzQycHlUM2Z5amZvdVlZbXpK?=
 =?utf-8?B?U1NkMmZjVG8ySXdpLzB1RkVSUVBLd2VCdEFJTmpScXloeFlSb0p3YkdTZUgy?=
 =?utf-8?B?Sm9tQUVoN0lkT000eU83RDhlWW9UQ1o4cWdVYTFvSFQvdU5FemdmQmpXV1RZ?=
 =?utf-8?B?N3o1b0swY3hjQ2pPWWNjR0dKc21BS1doMEVWejZzL2U2WFRXUXZ3cktyOG95?=
 =?utf-8?B?eldCN3QxcTBBTlYwaUZpckZveWZ0REJTNGtjWlNLdWV0dHNMWmhoc0oxakpL?=
 =?utf-8?B?MEo0OEliUzhRRXJ3c0x5M01mTW9XRWtlQVBzRGNXL3NnQmxGeVV6RUFyRmZT?=
 =?utf-8?B?ZmZvNWcrU1UvckpQbGltb01zNndVVlA0dngyUlRidzhwRVpXSHNtK3Bua0t4?=
 =?utf-8?B?aUlpTkowTitlZ2NhcUMwd21iSS8xRDM2Sk4zZjc3SDRHUis1enIza3l0cDVs?=
 =?utf-8?B?VExLNCtRaFRrZHVENFljMzIvZ3hnQUpUWVRkRG1CNnUydCtMVXVzaWYxT1o2?=
 =?utf-8?B?ZHVGNHA4WU9pMDdZOUJaQjRxRUg4YlJ0NFlBcStmdjB0NnRkOE8rbVJGWnZS?=
 =?utf-8?B?OVl0dnFBVzJEbVZKOVlLcndBTGZnTzJCd3AxWUxibUJmY0FqeEQ0UFlqWFNy?=
 =?utf-8?Q?KXMWUCiabn8xhdH0ED2lx6OIf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf756a3-b1e8-440f-e983-08dc636aa428
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 07:54:45.4702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThuFNIDPsOxRRgJ5z0qWWlmXwnWEH/dyF19pMUmYu3V9mHa1BzeEmGV9OuE+AORiwR4a+y8FgadmIjv6pEX9kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8546
X-OriginatorOrg: intel.com

On 2024/4/19 21:59, Jason Gunthorpe wrote:
> On Thu, Apr 18, 2024 at 02:37:47PM -0600, Alex Williamson wrote:
> 
>> Some degree of inconsistency is likely tolerated, the guest is unlikely
>> to check that a RW bit was set or cleared.  How would we virtualize the
>> control registers for a VF and are they similarly virtualized for a PF
>> or would we allow the guest to manipulate the physical PASID control
>> registers?
> 
> No, the OS owns the physical PASID control. If the platform IOMMU
> knows how to parse PASID then PASID support is turned on and left on
> at boot time.

I think you mean host os. right?

> There should be no guest visible difference to not supporting global
> PASID disable, and we can't even implement it for VFs anyhow.
> 
> Same sort of argument for ATS/etc
> 
>>> If kernel exposes pasid cap for PF same as other caps, and in the meantime
>>> the variant driver chooses to emulate a DVSEC cap, then userspace follows
>>> the below steps to expose pasid cap to VM.
>>
>> If we have a variant driver, why wouldn't it expose an emulated PASID
>> capability rather than a DVSEC if we're choosing to expose PASID for
>> PFs?
> 
> Indeed, also an option. Supplying the DVSEC is probably simpler and
> addresses other synthesized capability blocks in future. VMM is a
> better place to build various synthetic blocks in general, IMHO.
> 
> New VMM's could parse the PF PASID cap and add it to its list of "free
> space"
> 
> We may also be overdoing it here..
> 
> Maybe if the VMM wants to enable PASID we should flip the logic and
> the VMM should assume that unused config space is safe to use. Only
> devices that violate that rule need to join an ID list and provide a
> DVSEC/free space list/etc.

So, if the kernel decides to hide a specific physical capability, the
space of this capability would be considered as free to use as well.
is it?

> I'm guessing that list will be pretty small and hopefully will not
> grow.

any channel to collect this kind of info? :)

> It is easy and better for future devices to wrap their hidden
> registers in a private DVSEC.

hmmm, do you mean include the registers a DVSEC hence userspace can
work out the free space by iterating the cap chain? or still mean
indicating the free spaces by DVSEC? I guess the prior one.

> Then I'd suggest just writing the special list in a text file and
> leaving it in the VMM side.. Users can adjust the text file right away
> if they have old and troublesome devices and all VMMs can share it.

So for the existing devices that have both pasid cap and hidden registers,
userspace should add them in the special list, and work out the free space
by referring the file. While for the devices that only have pasid cap, or
have the hidden register in a DVSEC, userspace finds a free space by
iterating the cap chain. This seems to be general for today and future.

>>> 1) Check if a pasid cap is already present in the virtual config space
>>>      read from kernel. If no, but user wants pasid, then goto step 2).
>>> 2) Userspace invokes VFIO_DEVICE_FETURE to check if the device support
>>>      pasid cap. If yes, goto step 3).
>>
>> Why do we need the vfio feature interface if a physical or virtual PASID
>> capability on the device exposes the same info?
> 
> Still need to check if the platform, os, iommu, etc are all OK with
> enabling PASID support before the viommu advertises it.

This means we don't expose physical or virtual PASID cap, is it? Otherwise,
host kernel could check if pasid is enabled before exposing the PASID cap.

-- 
Regards,
Yi Liu

