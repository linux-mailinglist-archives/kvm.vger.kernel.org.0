Return-Path: <kvm+bounces-29254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 564529A5C94
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E0D8285CD8
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48A41D151E;
	Mon, 21 Oct 2024 07:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hj6owh+b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6541D1731
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 07:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729495196; cv=fail; b=dJwlQ/MCxQnaEvrfD2G7Y0LfQC3Oab1X3v44QyJrtSfm+BgzvZ6PEBD2yELpttWVRQh6/K77g+XXy+sPGc3NkMz2OPpSf8uDbX9yoqLhwC1u9uU+H4AjInMdn/WJXPL4wJiIpVkALhhYwqGj6PH4CDUgN5RzGpp9bHXkfC58b2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729495196; c=relaxed/simple;
	bh=GhRw+rzbhtfUcetpwwtiksSHDSxRG5dNoVByU4C/Zns=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oNaecm2YeqEQ9ZSB8USvKYDyOerWniS4uTpNfcZhmWCUwx6fq9w32cGbg+8ubdX/UK6T4a78Z/24J8ww/MQNxKC4eGGAMxrhoZvVGaVxFKzUxSX5gHXpJ+3l/CGTTKkrGgYrtBL3cU2VRgd+xFNpmTDVYtdX6/fXrotErPJlX/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hj6owh+b; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729495194; x=1761031194;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GhRw+rzbhtfUcetpwwtiksSHDSxRG5dNoVByU4C/Zns=;
  b=Hj6owh+blcwde7H90WhvelJY4smCOK6ysk1md3V875KDhgF9jLgck+tS
   nK2199xMejvLkW0dkde2aejU/r8CSrLnXUa/PbmxLrTFAbQZ4wz2nhdom
   8jMXqvAkgb+EZT6WgSfyWWPVtA0aduOJH1ogHxl3x0M8Y6vmpoHap/HMs
   JXbNZZtLYOxEaMzsVBpzTvdQflG0FKQyhkKwrVySMAA4J6QUD0uYVYVvB
   23H7aI6pFzFEoA0eIBymb+xJqwKtdbmKfxlAJgdpfnY0wvz5skV5cdcoW
   3vsox2aMleioM66aMZsfHAJYtbM/rV8no85AUM9/7i8jXf89fSduppzgb
   w==;
X-CSE-ConnectionGUID: 5bgNpndnQFq5GeTDyPAo4Q==
X-CSE-MsgGUID: 9M6AOni0S/ylFKAVSLktPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="40353784"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="40353784"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 00:19:48 -0700
X-CSE-ConnectionGUID: xbwIWTujQ0mpkx9x8rglRg==
X-CSE-MsgGUID: sK47M6q8QCiMdgVr23RCgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79087411"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 00:19:48 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 00:19:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 00:19:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 00:19:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2RsIdvbSCWO97NC+xSfBmekxaug8vKYR21sqtvy5fuZiaNUgblq6eLYvcYP8E8GrzcUtrjOuaA6iuwuNjk0+B0E7itoTEkG8NcL6PxHpkUBG36rRbVuwV8GsqZiZe2LzlOlO6vGN3x06uUnffmWB7u+uwpYTXE7vR9EtDzBOLdOuYJSnACOG6kgG14F68JYZA9gM9iD12F2Wfv5Kyo9F6Sk/3uVDDFbJRk5fwlpxLy30LRlK9nqjD9UlhwGeP8NdnEhR/Ta4RS4o4b3XS+YKsx4iFVRgpTiuG4BTNpL3+yY4hBEN/Wf1ofOHaNORCdyrJZlnilrFcJePvBJ0Fyebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GQhXHPWdD6pFIVWvSCR+vQRh2TlxudNLrHrXRmYZW4=;
 b=EKipBjp8tL8fHW5FiVGOrivBFpIjBPA+E6czJVgz2h0P5WD0MckTk8nk2vWCjiNdtSa3FGxip9Zerp1TIb5UQ1v3buL8GU9XzIy4TImowse8yaaLrsQZKOyHYnt1/xN+0InStsDynN300X41s1cYPI0sRFbvghyE6VDXBjyk9a8ppl7g2IXR0Z4bcDOHwVs1NBbzKM630GVk6zG6bXnOP5BXCGZ5BS2RrrgxO97KzD8wDPX4W7hJAakElbWEKYeS2RG2+B/SEAqD4PWfMYhhRehE1+HjwiLGvK1IEqxXt8Tv5xNPStyIV4H2zetii2CBhmQCeF+T0VyYakVEygGOdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6808.namprd11.prod.outlook.com (2603:10b6:806:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 07:19:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.024; Mon, 21 Oct 2024
 07:19:37 +0000
Message-ID: <bab356e9-de34-41bb-9942-de639ee7d3de@intel.com>
Date: Mon, 21 Oct 2024 15:24:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
 <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
 <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
 <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:195::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f1088d-b3ee-45fe-89b4-08dcf1a0b854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YnFGbXluRGpMcEtDN01GUUVmYmtZcXJnVm1OOWtxcnoxRis3aHA5VzNyT0xq?=
 =?utf-8?B?NEk5a241TGEzcTUveUxFU05NcWpyK3ZoL1U1b2lDbzZZcnh3M2lNU0hXekRE?=
 =?utf-8?B?OWZPSnAyV3hmRE1qaUFlNEpHT2U5VXgyK05YaWFLN0lBeTl2Mm5ac2hGUEFN?=
 =?utf-8?B?Q0JpNyt3M0grOFF4dEpqS3FWb2lNbkxaaldocndHN0RKOFFydlNvY1J0bjB0?=
 =?utf-8?B?Q040MXlNdjd5cWZHWDJUUDh3azFJMjhzSDk5WU5TUEVhK1p4QUswck9ITmk4?=
 =?utf-8?B?aVh1eGZQdzJXK1Fva2VUcDA0RWdtWUhnRWhWdTNpbFZPQmJrM1QzQ2RrSi95?=
 =?utf-8?B?Ukk1a1EweXcxeVJKN2MrRTUxdnV3T2lMaW94L0Y5bXpZVHV2TFJQdDlUUko4?=
 =?utf-8?B?T2RMR2F5NUJCd1lPY2xGQ283eWNwMHpRdWVmcGJtc29FTWoxR0tsMmFGcklo?=
 =?utf-8?B?dlRSdThUTUFrNjlqYjJSMm5BWFcwMFUvMktFUDBnZDRPWU5EQlJaWmFIMzc5?=
 =?utf-8?B?Y05rTWpHd1hVS3NyK1E2YkwrUmlQcWVhRzAwU21Sa29lMHNhMTFEd2JaWGw3?=
 =?utf-8?B?OVA5aERESnk2bDlQTjlSTkcrVWhGVXoyVEc1OHJXR0ttMUZOM0p5Njd3TXpz?=
 =?utf-8?B?RFJYckhQN0RlOEl3aDZ4UllDQTAzYVdmRUFWbjM2YVBMeklmQzNiaHhvZm9u?=
 =?utf-8?B?OEMwSEE3VmlvSkpmQUlFbnFvSElnZUJqMDM3K215eWJCSFliSkJQRThxM0xI?=
 =?utf-8?B?eWRickxLaHZZbFdNQndGV2l5R0h5NS9zbG5qTnIyS2NhMFFqRUxsU01CQW9W?=
 =?utf-8?B?MTFGU3NVU3NNTkd3b3BQMXA4ZmJzRjFtZlRHR1JiYmx6RnNDZzZXamdpaG9Y?=
 =?utf-8?B?Qk1nUlJUTzFMRGhQVnlCWFNqMllPNStnMzdtUHVpYzlhRzg3em5tTXN0RUNT?=
 =?utf-8?B?N2lua0drRnNBUzdTSWQzWFVQNjZ3TC94WHNyU2NnUkQzaVNyckhMcjg1KzBa?=
 =?utf-8?B?WTBKSGlmOHRXUjE4bnFPTXpFU1NsNzdUUW0wSjJPN2JEdWpOdXhJU21sMGdp?=
 =?utf-8?B?TzVXK0ZOS2xnWnBvNDdzMVhqYytXV1BwbTRhRkJ1WURtb2pMa3VUVnA0NDUz?=
 =?utf-8?B?UStLV2pWQXl2T1BrMUpUUG45V1Z2VjZIbTZvUlFOSEcrVHRTRHN2ejhPbE1u?=
 =?utf-8?B?TkJOT1BZSWp6MTRoTUg0bHkzOWROTXdIS0FnTEw0OFFkQU8rbForM2VMMzZx?=
 =?utf-8?B?cGY4ZDZjbTVQNUdsWGd5V1FDamNYS3pSTFM5allPQU50K2NDZHZEWWVPSWU5?=
 =?utf-8?B?SDFvUHdHck5NSEI4TDBEbFNDM24raDJMbkI5dUh2MStoMWZQekFrb0daS3U4?=
 =?utf-8?B?d1V4NjlaV1ptRDhQczRmOUt1RGZ3bDh3Qi90YW5SY2VXUjNSN1dSZGxMSFdS?=
 =?utf-8?B?OVQ5ekgyZXdSeUtrWjhkK1pMNHVtRDFEMkhWczl6Y3E4US9nL0k3ajlPV0F5?=
 =?utf-8?B?anM3NUFOVzQyZDNGNFdxT0doc2t1WXRIR0tNYmZaWnRPUFBkMTA3V2NCSHVJ?=
 =?utf-8?B?bGgwVmkzZ25sNnhvYWhVS3lSNzZWVU9QbGRmSDhUZDNyYmpNUjFOcldnaW14?=
 =?utf-8?B?NHpSd1pqSkw5blkwTUIrSk1xcjY1cExHWGsveGRnZzA0VytqZEk3ek9vaG0x?=
 =?utf-8?Q?z48+/wrOYMnA/5zYDPHL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHZIZG5pQTNoSnppSTUrQzhiSTh6NVRrbmxVQjJSeHFMdFJTR2x0Z0sva1V2?=
 =?utf-8?B?U3Blei9sQnNFVzVtZ1IrNGhGL3dLMWhLWjYrU1hnUVYrQmoyRlZJbm03SDRn?=
 =?utf-8?B?aWtWR1NRWjNIbkJiMWE5Y0k1c3BkamhRNS93TVFROTlUTE1IK0hmWnlxYVcx?=
 =?utf-8?B?bGxKSU94YVZZam5sV0lHNDc5YThIMlZuY1ZkL2RuZDY4NE5GajgvcUdUc20v?=
 =?utf-8?B?TDhWblR4OGVlT2FHeVJhRmNPVC84UlJNcmVoK1M5WjV5bG9rak12QTFzV25F?=
 =?utf-8?B?bHFQWXM5b2Fxd3ZqYXJwcmMyTENkSDc0V0MydUNXU3E5SXhtU1BpTk5kSUQ3?=
 =?utf-8?B?L1FuU3RjUWwzU1p0ZkwvRVlkR2hwMGFiNktaWTU0cXdBTHg0Z3FUYS8rUUp4?=
 =?utf-8?B?Z1QwQ2FTZzNuRXJ4eFhjcWhuTkVmYzd0NmhydzA3R0wwM1U3WVpyejkrcUps?=
 =?utf-8?B?S1l1SGl0bk9KcGxtK3NCdlM1ayt0b3pDNWFrUDN6SHhnellPeGQwbGRBcW9L?=
 =?utf-8?B?Kzk5RmNsT01mZzJOUWpTeTZ3WGlkQlVwWXNYdDB5T2VMZkZXYlIrYTF0Q3Fk?=
 =?utf-8?B?OENHTEdtVXVKajFYUEFHWXBxQ2tvWm5JNmpYRlNVMjFoTFFQMGQzaEFzUVZJ?=
 =?utf-8?B?bnlkSVFEeWFwUXBmU1JVWnFnVk5TOGlxQWJQSjZaYmpjeGVITi9SVVRWV1Bv?=
 =?utf-8?B?c09wcGIxMU5mWlpJakMzanI2SDdDZVVRSE1OTDFUMGFRRjNmSndFMjdHOFZQ?=
 =?utf-8?B?MlNod3hic0hxa2ljdzN6ekpyRHRwQncwY2o5RjFDeEczcVpvd21GRUZ2N3ZW?=
 =?utf-8?B?bHBzaXkwMURSdjAzbXd2cHdkU3VBVDNFR1BwcWpaQXJVL0ZlYy9icnNpQW9E?=
 =?utf-8?B?dWRQNmxlRTg0TWUxbW02eHBvK3NhWExRUW1LNzZrek9IeXg1dXNVTDF1Snkr?=
 =?utf-8?B?SXR3RUxlSVRRRDdDakUwTEd2WjkvcDRrcEFGdUk0MjlRVm1vbldPNk5JbGli?=
 =?utf-8?B?Um9scWIvV2tCZmhDMVBsblZnMEMxNFdoUGNlUEowRmVBR2VFNnREaXFFMEQr?=
 =?utf-8?B?c3pNQmFobitlcHh2RTEvQ0N2TmhkRG52SEgvM3NoMEVadkZNWWp5cmkxaTZL?=
 =?utf-8?B?R0o0eTdOekhldWVJak9hdDQyRnNDREJjNXhLaXVMRkNvWkFtbUEwc2hVeStn?=
 =?utf-8?B?QlJ0eVRFVWJvYnFCbGZYanlGZWNvYi8xdldMZHdiK0lMdTlYblFPeVJOSjRt?=
 =?utf-8?B?b0EzaFB4RW54WmZna24yK0d1ZzM2eU9LbTBsQlg1QnRtMkdlaGpZSjNDdUZG?=
 =?utf-8?B?VVZFMitvWGh2SWFWL29ZcFg3cnBTY0hEQTh1eG5PN1phdlk4VmlVdFAzQkNF?=
 =?utf-8?B?OGRkNVZ1R1VxcitxYitiZkhObkVNWmYvWEhEZXNWcFcrUWs1QWRtV3lpenJy?=
 =?utf-8?B?Y0t0V1R2SGxkRjd2bUlIVTgvSEVGRVpvT1UzcHR3aU1Cd3YySWJ0TVRmOGN3?=
 =?utf-8?B?MzZVSlBsRDhubVovamVsYU53aUk4SWVEYlpBYjV3dk5DNkloRDFMSFpMSDNh?=
 =?utf-8?B?TzI3QnBUQ2ZkV21MbzNSSGVOZ2ZGT1JmMFlJSXJKek13bFRiWW9pRXBRSHYr?=
 =?utf-8?B?aHFiVjQ1VEsva0FTUW5ZZ2MzeG0yd0dOZm9yS1lhQ1BaOTVYNjNXKzd6MXRF?=
 =?utf-8?B?QUp0dEZaQnBrYjZsMGREQXc2dGYzVk1qL0toNDN0RTc2R0ZIL1hXVXBlcE1n?=
 =?utf-8?B?eGJpT3V4N01kQm9NbnRMT2lEc1krVFU1SnhZdmRSbHc1RXJma2tFdEpoNnhX?=
 =?utf-8?B?VzduZGdvaHpBYXd5MDRUQUl1ZmFrTmpiN1hCNHpWRUE0Um9MQVI3ak5xY2lw?=
 =?utf-8?B?a2FNTjVXdVRKNTlBVDUyQjRncmw1QXUyb2pZL0JhL3dwL25vZ0MrZjRJRVc3?=
 =?utf-8?B?Ui9DaHJ2N2lQMlRxMHNJRFZYQkNXdmxTWGhibERzRTY1dm84Z09EYTF3dTRV?=
 =?utf-8?B?cmJnNjU5Nlh6Nnc1Ry9XM1JjYTRsRDF4V1QxK1AvZzh4V0RpbWtLYVd2eUhy?=
 =?utf-8?B?WGh1ODZ4VTdEWk1NaGNqeXd0QnphSjY3ZnJpRzZUSUZnSkQ0MFl0QUNtUCtX?=
 =?utf-8?Q?BXI2QwzM2me+BaYbJ5qr8qAm6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f1088d-b3ee-45fe-89b4-08dcf1a0b854
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 07:19:37.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJWzBdBr6iKXp0iRVECqlmZbvzheyB8APbbIWoG8qQqis+AtU6HnlMwM5SfepMPyWK5RRpYK3debb+UlIsk+OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6808
X-OriginatorOrg: intel.com

On 2024/10/21 14:59, Baolu Lu wrote:
> On 2024/10/21 14:35, Yi Liu wrote:
>> On 2024/10/21 14:13, Baolu Lu wrote:
>>> On 2024/10/18 13:53, Yi Liu wrote:
>>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>>>> There are paths that need to get the pasid entry, tear it down and
>>>> re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
>>>> entry can avoid duplicate codes to get the pasid entry. No functional
>>>> change is intended.
>>>>
>>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>>> ---
>>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>>>> index 2898e7af2cf4..336f9425214c 100644
>>>> --- a/drivers/iommu/intel/pasid.c
>>>> +++ b/drivers/iommu/intel/pasid.c
>>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu 
>>>> *iommu,
>>>>   /*
>>>>    * Caller can request to drain PRQ in this helper if it hasn't done so,
>>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>>> + * Return the pasid entry pointer if the entry is found or NULL if no
>>>> + * entry found.
>>>>    */
>>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>> device *dev,
>>>> -                 u32 pasid, u32 flags)
>>>> +struct pasid_entry *
>>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device 
>>>> *dev,
>>>> +                u32 pasid, u32 flags)
>>>>   {
>>>>       struct pasid_entry *pte;
>>>>       u16 did, pgtt;
>>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu 
>>>> *iommu, struct device *dev,
>>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>           spin_unlock(&iommu->lock);
>>>> -        return;
>>>> +        goto out;
>>>
>>> The pasid table entry is protected by iommu->lock. It's  not reasonable
>>> to return the pte pointer which is beyond the lock protected range.
>>
>> Per my understanding, the iommu->lock protects the content of the entry,
>> so the modifications to the entry need to hold it. While, it looks not
>> necessary to protect the pasid entry pointer itself. The pasid table should
>> exist during device probe and release. is it?
> 
> The pattern of the code that modifies a pasid table entry is,
> 
>      spin_lock(&iommu->lock);
>      pte = intel_pasid_get_entry(dev, pasid);
>      ... modify the pasid table entry ...
>      spin_unlock(&iommu->lock);
> 
> Returning the pte pointer to the caller introduces a potential race
> condition. If the caller subsequently modifies the pte without re-
> acquiring the spin lock, there's a risk of data corruption or
> inconsistencies.

it appears that we are on the same page about if pte pointer needs to be
protected or not. And I agree the modifications to the pte should be
protected by iommu->lock. If so, will documenting that the caller must hold
iommu->lock if is tries to modify the content of pte work? Also, it might
be helpful to add lockdep to make sure all the modifications of pte entry
are under protection.

Or any suggestion from you given a path that needs to get pte first, check
if it exists and then call intel_pasid_tear_down_entry(). For example the
intel_pasid_setup_first_level() [1], in my series, I need to call the
unlock iommu->lock and call intel_pasid_tear_down_entry() and then lock
iommu->lock and do more modifications on the pasid entry. It would invoke
the intel_pasid_get_entry() twice if no change to
intel_pasid_tear_down_entry().

[1] 
https://github.com/torvalds/linux/blob/master/drivers/iommu/intel/pasid.c#L317

-- 
Regards,
Yi Liu

