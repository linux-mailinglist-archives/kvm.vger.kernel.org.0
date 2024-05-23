Return-Path: <kvm+bounces-18008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5F68CCA0D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 02:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC6C41C21603
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6ED628;
	Thu, 23 May 2024 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNsyzz/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09CE191;
	Thu, 23 May 2024 00:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716423122; cv=fail; b=WzDmdjWyNS3OAUpfoYxIihGCd9CGLSc88lEB9OnvCij9O6Xr5gbtTbPGvVv/sclwga9I0maXKZvit/xsIV3r0Ug0n9c/OIkBwAQ3g5eJW0szCjM4Ep9yy0InrZkCQUB9ld1tITPD6Q1y3gGG8vcLjhcSnOUK/IpqGENnkBFF2c8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716423122; c=relaxed/simple;
	bh=1xJrEGJHUOm1FMj1If0UtzThApBum2Z11yPQlfRcCRk=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nRkIy4oMl/rGH5+uVoiRTfo4TLKF8iKB6DfGW/0aJJpxO+5gP0pGv4SNnWc3WcoZi4IP29HWcPyriZA8AoJwWUK2xseNq/pQ/jfkhiklt4+faPrv/hHnR0LxxrRJoJ7UOErCauwbnFILrs9AT32SDsNUAMdDBiQwWwFkDoGPu8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNsyzz/E; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716423121; x=1747959121;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1xJrEGJHUOm1FMj1If0UtzThApBum2Z11yPQlfRcCRk=;
  b=UNsyzz/Eea6d7QePQqcLIApmxUk6dqLWvB9XUhudoNMrYFO6xgD9WCxS
   vEy3wkyW58mSdGymGPl0gJWYiVf1VOO7BK0uSSrcI5pwdSBRHqXy7B0Og
   DtA1xv5ovBEpNrPvlCBzh08pCbIHrA8AcmYgPIJqqS3v8R5LNSHHkjKvZ
   1B9KMhVmMrXdmZn4nrz8xSf6ach39XglWRVH+pJEBWQTlY0X/NxscqRZI
   yYd0FKTxB3H7coWSrtgOPz71RU9fFLkRRSBwKnRr33+n72opxSQ/7zMsd
   tzQ0tHewjH+dOHr93lf/NLlhIYMrxV9XqtvyEJjXUgskqQdN0TnFocWaa
   g==;
X-CSE-ConnectionGUID: t/dkaBwFRJugtMqacTfY6Q==
X-CSE-MsgGUID: izBTjmPuSIiN/M/CFYi+7g==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12585898"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12585898"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 17:11:54 -0700
X-CSE-ConnectionGUID: 58luYGMuQiSmgNaMvXSi4A==
X-CSE-MsgGUID: GLiMDlkRRoSCwR2nUYMwgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33532476"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 17:11:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 17:11:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 17:11:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 17:11:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 17:11:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lryrE5cvVQoP+ZXyBNySK9kmKoHK0nd0RUL1RWCpGoO97q6eTWtJux5Kt/QRlvMX4Fc9zwfrJLa9IEIvRP30FHZNV1PEE4spSsgPENflYgHUO2y/4SndRCIC7uWoZAH8EndUM99vWjnIOcq1/la0Ce4NH2TBOg4LB/znecRhjdVD4dPm+sS/3qdBNHVLy6Rgk4u+e60/a9/SU9Nm+s3p27z8BOJF0qUn/old3/NaoYDke4FjGGgqI7enPK5AnUdCRDCixLjuMx00MXvFKhQAVHToAKICmU/rNoBQNykLCzxe/wt4VjKMa6X3f7GL0024UH4OLDdsgjxKxzhkFCmMNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZGkjuhlFoK2n9JlvDkqbjrv5eBeoR34bUqTDSb1+gs=;
 b=W72f+CBodkpEzH4Hc0kSzCI/i/fM3G4S5wnUAeT7m1aG68pZGv264gKzdnULFxIw7+4CX69A+kAo4RvUmMiRY/tiYwhcl361ElTjU3fB3lhkFzwDNFX8FcJbea2WDaeFSeq4XzpP67JOYTlqRU3yAVwHx/Un/MP0ealZwQo9qKmlxztHvsbT2Dt2G8S3KOp2OnC8ZYJs7dKP1clmHPF4rv3OoEpdc8Kgo/m1AMV/YWrUNgLJyfENZxYmGx3As623VNQEZvn2AgCtHpKiNSXFx4IwtA9BSX0U/Hft+MP7zbwyrWyEIz6D6TKBec4eda2Eo7bM5smF0vrweBulesTLfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by DS0PR11MB7336.namprd11.prod.outlook.com (2603:10b6:8:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 23 May
 2024 00:11:46 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 00:11:46 +0000
Message-ID: <a0acd183-a3b9-45cb-b0cb-4c7f0ec0b380@intel.com>
Date: Wed, 22 May 2024 17:11:44 -0700
User-Agent: Mozilla Thunderbird
From: Ramesh Thomas <ramesh.thomas@intel.com>
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: "Tian, Kevin" <kevin.tian@intel.com>, Gerd Bayer <gbayer@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Niklas Schnelle <schnelle@linux.ibm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, Julian Ruess
	<julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
 <BN9PR11MB5276194485E102747890C54D8CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <BN9PR11MB5276194485E102747890C54D8CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::32) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|DS0PR11MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f08ff6-4b9b-444b-8eb7-08dc7abcef20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q24zbUFLSUFYZGxIc28vc2VXQ1RjVzdQc05uZFYwRmJEZHpFd2ZOaDVRc0h1?=
 =?utf-8?B?NWRlWUFQUzVwaHJSUWQvVEM3Sm53Z1Z5bzE3QmZnR3A4ZTNsOGpyZEpIS2hv?=
 =?utf-8?B?U0VKbHZHSWZrRko2SlRwcXJwemhKSHA2VERIUkZyNVNidzVTZE8wMlFhWVdD?=
 =?utf-8?B?UVZpZU9XMXQ0SUN2OUNnMjVnb1h4Yi9hZEVBQzJreHRlb2FnN040OXhyZnRw?=
 =?utf-8?B?TVVjSERIZjBUSDFLTEExeU5iNW9lY3BUNUo4ZzBhYnY1cEpOSTlhUUs5M25Z?=
 =?utf-8?B?dFMvMG5pdnBmZDB1b2MrT0xTOGRBV1NvWkVReVFuZTY2YWZoUkZFV2dTZW96?=
 =?utf-8?B?VEl6Rno4QWFIWXRSWDZBRmgrWDNVQVpudGxVWXRvWnh3YUJNZElseDhKVXhO?=
 =?utf-8?B?UFpIUDB0UlJFcGo0bFZYU2hTVEpCaXJiOEpnU1BSd1lIM2VMSDRWaFF4WVdM?=
 =?utf-8?B?L29EZUlXQk9jekU3V3FDQUZLalBqM1JHZGNqRGc4RGJnRDNBT2Z2Y3R2OWg3?=
 =?utf-8?B?M0h5OUxrZWdKU1NDUVF2QTIvR0pUMlhKSUNUbTJ2b1J2ekZGMTJPREp4dHds?=
 =?utf-8?B?M0U3Tk1vQVhJMjZmbVBaREZXRmxZRWhOZC82N3hGL3hvT2QvQXJlR1NHTGRH?=
 =?utf-8?B?eFhYTGZVdWlGb05CL0puaXZwSTd3a2cvNk5aa1hZQWdvQ2lUa0h0V3RkdXN6?=
 =?utf-8?B?YVNraWdVZlUveGhlTmVRY2JQYThleTlEQlNRd2JiRkVBRm1DdmtWaVJWN0Fl?=
 =?utf-8?B?WFkwVHZRYWpCYmREMVVIM0R3MnUvRnZkRzJCc1FNM2c2RlpiOWNkODJ5S1pU?=
 =?utf-8?B?QjRXeVhsbDlMb1lIQ0U4YlB1aHhPaGlWNGZqeE1nNDRobnliQXcrOXpVRGVT?=
 =?utf-8?B?NzhDdUVaSnF6emMrQ3RKUkw2QzdvRHdMcTZjNGloajdzeEwwZXFUUVRncnd6?=
 =?utf-8?B?VDRabFFlWnIvSWxHa1oxVzhKY3BuRklybjF3NUE3S242d1g5WDd3VWw4NmJY?=
 =?utf-8?B?YlNZTlFyL0dIQ3I0ZkhLRlpLNEtCZFFBek14RnhNN0JYNTdRS2xsVS8zaC9q?=
 =?utf-8?B?SUVNNW9TTWY0b00ybEpPUjRTNUcwOFBsa0I5YkJSdlVOY1dFckpMVXp5RGhR?=
 =?utf-8?B?SkVFWWdaclhIaUlHdWdUbUFYOXB6QzYwYm1OZFEyemg5RkI0Q2diSkxmS2kz?=
 =?utf-8?B?SFg1d0VVRE5JZHlkNE5XVkJoMnliQjN4ejFEN21BdHdRV3ZOM3B2QWpSQ0ll?=
 =?utf-8?B?c0IwbkszcUlZRWRON29Qc1RqWXQ5Y2IrLzdwcllMcG1nRk9qMWEwcEV2bFZx?=
 =?utf-8?B?Zkw4UnJGaWl4K2owQzE4cnd6ZmtMeXpPSlFWaUJISkJPTzBIM0d2bUphcEpB?=
 =?utf-8?B?VnFYL1kwQWMvbXZrQUk3MnZBTVVZMTR4MnU0U0xKOTR2YWlrOXI5YWx5bSsy?=
 =?utf-8?B?Zzhvb1haQ0sxK3BlTkZnZVI3UHpMMVpCMXdtZlZCN3ZhQlNoSnNBOUJSNFZD?=
 =?utf-8?B?dzRDdkxFU2NNMlJ2TDl5L2o5MCtlTUVRVi9GK0o5ZTdySnoweXgzMTF3WlM4?=
 =?utf-8?B?Q0dqT3haYXJ4UjMyZ2NyQUNkMnc1Zlk3eXhIbWlrK2VrSnJMK2JBbC9CWEF5?=
 =?utf-8?B?Z0N4RkczZk4xME1xNzg5RTdFSi90Z2ppZmdKcFlKN0R0L0NtSjhiaEU0ODFQ?=
 =?utf-8?B?TjVZZndKNm4xcEtyR3FoZ2pXN1l0cG5xVm1takRnTStxQUQ1YXpBdW13PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3daM001NTZRL3gyY2hweGtNT2lOZGdjOGtkREorK1dFYnJscFNNODd0MllL?=
 =?utf-8?B?K1BTZGhpQU5GUUxpWnNQc1cyTjFrMWtBZWwrL00zS1BJZDRZTC9zMnh0VGtS?=
 =?utf-8?B?QWgvQ0IwbXlEVDdvM2tuVmMyTVJ4ZGQ2cGtTeFlmM1lKZjNrelhOM0ZIRzQz?=
 =?utf-8?B?OFJxbFRuc2d0MFdLa2NwUWpXZTBDN0ZkV3k0SmZHbjBVTmxIamRLWlNwT0c5?=
 =?utf-8?B?THFzTFRJYkxJSTRZMGhlOXZwU3dUMUVFbEpnSHAvTFZRUFEzQmIxb3JVMjB1?=
 =?utf-8?B?Z3JCTFYydTlJdGkyUW5sZ1NjZGpQU3JzcUNvZEZLWm8xZlp6QzJmRThQeG9Y?=
 =?utf-8?B?N3llQ25tdGwvaXJIK0ZaN1hBWC9JSnlOb0NjNnhqVlBBS2YyRGdIUVpITXA5?=
 =?utf-8?B?Wi9VSG9CQlBRaTBCaEhQamF6Z3J5aGgvZDlPczZJRG5pYnRLbjE2NHZIZ2Vs?=
 =?utf-8?B?cHlMRE9TUEhTTTh4SVNGeHViaThaTHk2RjlVSCt4V08zZU1GTEFSUzdyQS9y?=
 =?utf-8?B?ckZWVm9MUmw4aEdOU2dicThhYmlWNS8zMDFJMGFSWGUrczBSM3cweWhacllU?=
 =?utf-8?B?R2FnZjg1YzFDL1ZjREFxc2k1d1JXRnZheEx3Z0FWdjNndSt4STdwazFwZzU2?=
 =?utf-8?B?RUFCRW52dGRSdDFsY1B1TXdCZHFCbVhLUFZPNmdlOUFnWVJwZS8xaEx5bUJW?=
 =?utf-8?B?SzRnZEdiRUUvalpPMFRsbDVWMVdEbSs3VlpyZTBqZnNXTXBVQTQxd3JDbjFv?=
 =?utf-8?B?K1UyZjV2aERoeVpjVlVwRkF1Sml1TlFldHc5Qm9xNkxLcWpra25OM3lQZkd2?=
 =?utf-8?B?MjUxVnlNUFVQcThxbDRWb2xsWXhJNlEzZy9kTGxnSVN0NWNvcTg4Y0kxOUY4?=
 =?utf-8?B?VUtEdzBMNk02UnFxcDB0Y3dhR0ZPdGdWaWxlT3RXL3V0UTVlYXgyRzhyZnMz?=
 =?utf-8?B?ckpLbnNYMThJZGpGWWs5bDgzaFc1UmM3OTJ6cXlrVHc5dEtiUnNlcmdXVHdk?=
 =?utf-8?B?dGUxK3RjdWZVQUV5N0tvaWpLRHZndUNySFRmNTMzTzNobWlCei93MjY1SWFw?=
 =?utf-8?B?RWhMUUg4dElQRzM2eTJVN292YjJlV3NHV013blVwbU1DOXQvOFNRRHV6SHJC?=
 =?utf-8?B?SE5JOFNuWlR1MjVMQTNxV2p3VWlHSlVEd0kzU1QvN0dDZW9Tc1llTEdIU2xI?=
 =?utf-8?B?dEtqTFRMeUp6b01OZkVnUG40QWpzVFQxTVFkMzlFRlBKdjkxWTViTDVDNTdS?=
 =?utf-8?B?UWc1ZEU5NURuWFhvWWt0YmNlVktXa1M3dGF2OTNERGpTZHBuVXBKWEUwTEJ3?=
 =?utf-8?B?OVhyajBybyt1NGZuakU3WHZCM3RDNWt3eWJhZ1hkQTFWeHF4L1FDUUhnelc2?=
 =?utf-8?B?NWFlTFlWZHhPUllFMEFsalh1aE1CaWRBdDBTM0hlY2UzZFJodEtVUHc3K0VT?=
 =?utf-8?B?NHVqdXk3RTc3bUlNUlEzRElZeDRGbFZOb3hxSnJpZFV3SFB1R2RJci9kSWxF?=
 =?utf-8?B?THFSRDVQMzRoTlJaUTZ4M29pRzA0NHBxZ0RBWWZ4RFY0V2VSanFXTkJ4Witj?=
 =?utf-8?B?UTVQZGRoaUxWVkh5QlhiV3V3MFRyTmx1bURqcUZVWGYvT2lxWmdTRWFuRkNk?=
 =?utf-8?B?a09RNUVucWYrVkE2VG9YR09TVXlMS1BoQmdwMFRkWXYxQUZOcjV3NzloT3lv?=
 =?utf-8?B?NEc5UmNMUHQ1c2YxZjVjWXFReThhbEdPbE5sSm1sOTNLaFA3TVJocFVCTkxT?=
 =?utf-8?B?U2E4Z1FyZ1pOT1lCVG95ZGxKWmRRb1FXSVdSbjROS2ZGTzNiU2cwNmZ0N2V0?=
 =?utf-8?B?ekQ1dmxodHJTaWtQVURJcWNZYmo3ZWFwRk4zSE8yVnU5OXBHZzh3RkpENXdz?=
 =?utf-8?B?b1RCOHVDZ3c5UFRSQXZaTGRnODBZaXFGNW5qWWg1OEhRRnpTcHJxUGJuV1RS?=
 =?utf-8?B?WDJFcERrVk9NWEUyTDBNYWUxVWtzVUVReWRPWkxNRmgwNUFqaHp0dW9qVDFq?=
 =?utf-8?B?eXd5OXNSbU5oZFlJVExRRDQ3akUxYXVKRjVURmIvSjdQTlpTcE5yUEdES1J5?=
 =?utf-8?B?OVBWWllPY0NTTjBhTnY1RGU3dC84ZFJFRHQrTERjRlpOd0pFUVpvYmorSDVy?=
 =?utf-8?Q?s0K9qkiKAnWOBSotYofem4Cuz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f08ff6-4b9b-444b-8eb7-08dc7abcef20
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 00:11:46.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJP/3FFxNuo30d+CCl2+J28rRy/2fvnt95azBZjc0Txx4jFDbkMj/1JOTC7AGoaPADmCcwLXHL6RMUOvlaCHfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7336
X-OriginatorOrg: intel.com

On 5/20/2024 2:02 AM, Tian, Kevin wrote:
>> From: Ramesh Thomas <ramesh.thomas@intel.com>
>> Sent: Friday, May 17, 2024 6:30 PM
>>
>> On 4/25/2024 9:56 AM, Gerd Bayer wrote:
>>> From: Ben Segal <bpsegal@us.ibm.com>
>>>
>>> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
>> vfio_pci_core_device *vdev, bool test_mem,
>>>    		else
>>>    			fillable = 0;
>>> 	
>>> +#if defined(ioread64) && defined(iowrite64)
>>
>> Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and
>> iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is
>> defined and this check always fails. In include/asm-generic/io.h,
>> asm-generic/iomap.h gets included which declares them as extern functions.
>>
>> One more thing to consider io-64-nonatomic-hi-lo.h and
>> io-64-nonatomic-lo-hi.h, if included would define it as a macro that
>> calls a function that rw 32 bits back to back.
> 
> I don't see the problem here. when the defined check fails it falls
> back to back-to-back vfio_pci_core_iordwr32(). there is no need to
> do it in an indirect way via including io-64-nonatomic-hi-lo.h.

The issue is iowrite64 and iowrite64 was not getting defined when 
CONFIG_GENERIC_IOMAP was not defined, even though the architecture 
implemented the 64 bit rw functions readq and writeq. 
io-64-nonatomic-hi-lo.h and io-64-nonatomic-lo-hi.h define them and map 
them to generic implementations in lib/iomap.c. The implementation calls 
the 64 bit rw functions if present, otherwise does 32 bit back to back 
rw. Besides it also has sanity checks for port numbers in the iomap 
path. I think it is better to rely on this existing generic method than 
implementing the checks at places where iowrite64 and ioread64 get 
called, at least in the IOMAP path.

