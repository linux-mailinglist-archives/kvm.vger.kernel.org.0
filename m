Return-Path: <kvm+bounces-13010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD70288FF17
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DCA1F24896
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6DD7EEF4;
	Thu, 28 Mar 2024 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Chn5A3My"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E943ABE
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 12:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711629284; cv=fail; b=OH3lzQL5cp/5EnyjcK7vO5y+fgKMYonQ0BfZmO+GoCICvPuAi7bBwgFeTv1sU2DcH6CaofqZxEaf/3a6d4edNpjY0N9xeBMEKP8Rd3RvGiD2aurobpuWPN7J89J4hvMR2VeXvIboHDVyQWUrr3Lq6AHrnpXLglEl+kF+3IhGxu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711629284; c=relaxed/simple;
	bh=ImrpyklM8fhi4elk/m8EoPPaEealrjsv4xXezEWrgFA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MKRe/Tb3siMGUyfZxAyoMD1Dn40y+0AsDMbe17O9Nm924Xdw/4wOkJOBIIBnzNgWgYW3OjedscHujAUkyjaST61wxlsYnrp4xxvITOETQR1kX389nJ2iPoIDF6Ll1DwpAQVxM6I3Pw45igU7LidkqY+gLUiYXYA9s3oJ3CrEQVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Chn5A3My; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711629283; x=1743165283;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ImrpyklM8fhi4elk/m8EoPPaEealrjsv4xXezEWrgFA=;
  b=Chn5A3MyL++xL2Eq5qnuI2tIwhWCohxdDvXq+pO66uz/I3k+Kop98olp
   x5N+ra9ulhaLrCrtJc8c5ZrCTqtVd5CaNLsNYoOG9EFPNmASBrABMavx8
   0tD88wYrS5ZG0bS6/s9FfLcZl1WwmEtOA8UG9aKY/ieyEL4GMQOiBruhK
   lzmFI6WEAiVk4Th/RixgC2ISpBTuyi9myMeZb33hHMdO2V62OlGo+3OmV
   yv3FLaqQtdBwP3QgN9ZO70lF1gLelNPbR1oGNKxdVfUowYkJbobt/b/Ht
   l0YDGHdZdXPsTyzOY/tzKONS/WPyHJDV0AahlNlX/uCQxZmp8fgyPg8AV
   g==;
X-CSE-ConnectionGUID: yFgHCml3Stm/PPF4n/IVrg==
X-CSE-MsgGUID: jTeXGznnS5i5dVAm3s5xqw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6890325"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6890325"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 05:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16627034"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 05:34:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 05:34:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 05:34:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 05:34:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 05:34:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jA39V1h2Lva0FlmDk5Ux4Z50A8GgrER4BUznL6RXITr3gKhPyK7uLYkHxIYdiix/Io+fGWzfLNUaRzoLUxFy6SyJZtVzxVcSe8osR7IRO2JdFO2jViCRDJx44gOQdORrzTklQ1iYTzZ+G8HCNJKVLVrQ5N4t/z6KCqXpCuaWJvTMboA+kErQbKO497sZmPx9FH4zad+4e/Ae/61c9E68MmK40Rl4SYmGTy/on4KtCa3sMOVil+9X5aAx5rPDEy6CJ6nxCBdIVIaAVM7uX45/N/Lm7fyM2C1Dnk8lfU4kJRGlwg7XKe/AeNWgd4xROxSfA9imBFM5D1UVYfL/YrmHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaKXqRBJ/c7qA8tFSqJSZe8xMHBXLoFFOj4bmi57Bpk=;
 b=dJMHfNK3dwXrRv8LUPgBOiwxWun/BWmM+FTpx8fsfMyVC3j4tJRSrTN3RXaY16QZ73/BzH193XDSuuwkZZan/Dd6npKdkHNGOTpRyLTBpR74x+K86rmMOSIXRwE0e92Um03bXmZMjKp0pOzYdCrOjv07QWx8PzM0MWWjhCFSnh4Dg9/otR6NaH/r91mps8rOnfcQ1OnlATiV/LcS3LdfCVeOS2WRkrNE9mnH25EvwuzyyDsWmaevPZOSU+0PWtfLv5+0Zj9FOEceDfGZ46qJgonwj5urYE38N7HYVOicYFm8xLSf0PX2VfNIa+bTQVoMooifjrSZzUe2+GTuJ4ZRNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV2PR11MB6069.namprd11.prod.outlook.com (2603:10b6:408:17a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 12:34:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 12:34:39 +0000
Message-ID: <05d7736b-c432-4d8e-abf5-267aea036f75@intel.com>
Date: Thu, 28 Mar 2024 20:38:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Pass domain to remove_dev_pasid() op
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-2-yi.l.liu@intel.com>
 <20240327130234.GE946323@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240327130234.GE946323@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::26)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV2PR11MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9c7d30-72ba-4d91-b51d-08dc4f236f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vD3ZyH0lL6kJKzO6/H0Q9HOaox9xD8vDKkpudXnlUeS8VZMuIr+gNa+lGa30Eqc9r4GtZvtdVyPd7JIxSKhN3A7TQhS281avG5BktN8GbUsIJPjjptjZZK+nrbia6B8AsQLiiNT778hItUZyLtb0sB1MTXdLFXtdeghzy8ErmDIU5u50XqGJ2JRrS96+p8+XbzUuejfpfPh7hh4Zdmx2s3Blecf1alnV64GPR327+rRQNfK/fFKZxXaw6TIpOFlpyK5vFHMQS1Hh7Vsu1S2ZO19l4gwdCTWZhTDzgZheTqv+3u8gR0Xt/49WxCMuSZaQuTXQR283t2wkAPSxYRGKfGOHUKAdWKJ48YrCAGMklm72pMuVn8K11EZnNysJsmU/oA3ADcmJgxXU+7eQN8XuDwXrtmonznyYk7/r10ZPCL0Re5KvkKEC5I/E/cDaz7TLZ+7qbwfl4NuXqbIhEfOqL57sEvm3xk2aEWt0DQ1eZiyCDiJMv2JhHlSwB7MnG3Aj5G4zT89XHfkKXZGlowrdVn0eD/RsTEN1kDhmUqRApm8uapeAQAOx/ivc/0OsFt3Rj3pUxHx8cAzW//HswIrtfORirnCG2d+neMcsofttXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFF3blY2SzRkTVdnTU4xbldMYlRHZ3d1U2FLVkZCZXZKdm5QTHlTRzRQRmNO?=
 =?utf-8?B?K2MwNDl5dDYzU0NFbXY4a3Rlemw1OFRPUkJvRWVwN0RBQ3IxNmljNjdWbzIw?=
 =?utf-8?B?Z1BIL1hZKzc4NVRIdDg1Y3kzTmZ4Wk9YZDBwbUlJRVlPcit4VEt2SHArdGhB?=
 =?utf-8?B?aGlVRTl5bTd6aXlmVXY4UEdOTmxIZDNUNGpEMXZkV2grNjVyYWdsM21RRXpx?=
 =?utf-8?B?a0VmNm9COGlRU0xUOURzWWpEaXBSQmR5TFdxaFRrVFByZlMweFUxdTQ5MWJn?=
 =?utf-8?B?TW10YUpWend2RGt2eGM1c2pFUHRvWE55Q3dHQXduVzRia0hoWHVJUXd2SFhJ?=
 =?utf-8?B?UjNwSGtVbXFGZ0crQ004MS9kRVl1RTQralFVSUh4WlRoaGxWYlVwNFh2b25N?=
 =?utf-8?B?VEhNWldyUFlvWEZ0M2FJZ1VqSXNHRU9icnZCdjF2RkkreWxXM0VLM2F4bmVo?=
 =?utf-8?B?SVZlMTVoQ3hROGZzQ0hubnFVcFRXWE5wQVhaVi94Qy80ME5UQWZodzZPRVRZ?=
 =?utf-8?B?N0pDOVYrUWREVHY0NjUvaVltaUk5OWJycFVSMmFPaElHSmlwaENPRlpaUk1E?=
 =?utf-8?B?SjlKTytqQzR6TmhvOXNIb1RCMy9MSWJhRzd5MFE2V0EzOFJNZVNkWjdxeHdF?=
 =?utf-8?B?MEV4bHJDT3hCeGdqSVdvdi9jdllaanM4VFJ0Q0lmaDJoRURnNUdpWkhLSmt6?=
 =?utf-8?B?Q0VJN1pWemxJRzA2L29NVEczK0h4STJzZnlsWjlCcFZRVG9Ldm43d05pUjlM?=
 =?utf-8?B?bUdERGFMSGU0WFZIYkVCSWgvckpBU2g2RFdMYXM0REdsd2RjMCtXbkp3YUZR?=
 =?utf-8?B?MFRrMVVMVjRjZmtibFFxTUJBbXg5NjJqVExBbnRwMGpGVUtMTWc1TmNRcHNX?=
 =?utf-8?B?bXFQN2VrcUhYSWVRbVFPczJIRFE5MWFpem1RU3V6dnZFYnRCYythQlpkT3Fh?=
 =?utf-8?B?ODZvWnVnOXQvaGRFaUlGQkdVbW90d1R5NWVvV2ZhTHkvU1BwaHZjZUdkNmJI?=
 =?utf-8?B?OFBJMU5OYndEbHBXSUFlUWFKdUIzK0NoRlJ5UWZTYVJMTHdXcUNFOVQ3YmtV?=
 =?utf-8?B?eEdzTm5BckRNQmhjMnpaVGEwM2U5bHJBZUtib1doYVBTTTNpVGtKWXY1WnFG?=
 =?utf-8?B?R1VKU2NvaDcwMEdJd2ZVYmtXY3dRYUFEWEZTWWRFTzgwd2tRTm12UVNWOUV4?=
 =?utf-8?B?U3BXSGI2dFBQbmdsQm9tdGNuYm9rbVM0bVJ0YlNtdEZ1bDA1MDZSQ2dqcHdo?=
 =?utf-8?B?TmZQN0dCeWR3QTR5dXlBWHVIZVFnZmw4cG80enRyblVUQVhWd3JkVDA4VDBG?=
 =?utf-8?B?TUlGa2ozQnYzSms3dktocm8wdGsxWEFnajdDR2ZmWkZXMnRSRmw4THZWcTZx?=
 =?utf-8?B?TzZLdFpvUXVEZTFueERCNkdpcG00SitFSHM1SGhJQ2NrbDdwaXR4WGUxRnRp?=
 =?utf-8?B?M3gyU1RkY3BwYnp5T0Q0aXRLWklhZ2RjUmhGb1BwVFlhUmJjR2hFV2wwRXhR?=
 =?utf-8?B?a09NeWloaEROcmV2cW93bGYxNCtpK2pFWDJpRWZKRmtPNStWSUZkSFdsdVZq?=
 =?utf-8?B?UTV6ZWVMTW5mOEZsb0VtVHIvaFFqWTRCekFPdmZKUlM2OGduU0tvSStVNXk4?=
 =?utf-8?B?WHFDOE85UEF2NDRrb2pjVGJKSFd0V0s4NWlHa2pMYWVMT09HV2tEcXltNTBH?=
 =?utf-8?B?VDVMU1ltdFNhWU0rVENXQ21tNlpuaTFmcTFMdTE2MG83SXcrVis1TllYejlq?=
 =?utf-8?B?NVdVRVRsN2JTd3NQYVZBMW5PK1ZyTDJTaHZRdE9sYms3TWdXU0Nienl6NlhB?=
 =?utf-8?B?MDFMcVp5RUphUmJvWmJLVU1qYmNoWklXdnErNHU5a1I3NVJ4TXNHNDNFY0c2?=
 =?utf-8?B?OGpsR041NlRLZ0tvYkxydCtnYlE4N2tlcnZ6YTZnUG9RWkJYYWhNOXRuRlNR?=
 =?utf-8?B?dUY1RDhxTTVoRHhMNUJFeWxQdGJyeU15bWpGeDBtUXhaaEN2QkE4OVhYWURh?=
 =?utf-8?B?Mjk2YXBiR1hqWkZDazRBU3pROG1sMTQ4akZKSW5RUThSL0lSNTdZSU1kcnIr?=
 =?utf-8?B?VXlrRFJvZWxMNDVFMm1yOUZLanE3ZHhsWCtMbFVOWWRnV2pWOG5ZNjZsNG1p?=
 =?utf-8?Q?/qptqfDkIvfFxYF8kkNbsRghb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9c7d30-72ba-4d91-b51d-08dc4f236f96
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 12:34:39.7915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NT20toUVyYthJhxjSBV/W4K/AG4LKlg5HoLqy4mW9BJuHDjdK45iH3SLYYsPMq0IDUzGGPO9PJXhQBL8Pc3weg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6069
X-OriginatorOrg: intel.com

On 2024/3/27 21:02, Jason Gunthorpe wrote:
> On Wed, Mar 27, 2024 at 05:54:32AM -0700, Yi Liu wrote:
>> Existing remove_dev_pasid() callbacks of the underlying iommu drivers get
>> the attached domain from the group->pasid_array. However, the domains
>> stored in group->pasid_array are not always correct. For example, the
>> set_dev_pasid() path updates group->pasid_array first and then invoke
>> remove_dev_pasid() callback when error happened. The remove_dev_pasid()
>> callback would get the updated domain. This is not correct for the
>> devices that are still attached with an old domain or just no attached
>> domain.
>>
>> To avoid the above problem, passing the attached domain to the
>> remove_dev_pasid() callback is more reliable.
> 
> I've relaized we have the same issue with set_dev_pasid, there is no
> way for the driver to get the old domain since the xarray was updated
> before calling set_dev_pasid. This is unlike the RID path. Meaning
> drivers can't implement PASID replace.
> 
> So we need another patch to pass the old domain into set_dev_pasid
> too...
> 
> This looks fine
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I dropped your r-b as the description changed. Please have another look
at the v2 of this patch. :)

[1] 
https://lore.kernel.org/linux-iommu/20240328122958.83332-3-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu

