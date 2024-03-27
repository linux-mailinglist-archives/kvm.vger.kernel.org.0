Return-Path: <kvm+bounces-12746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B428888D4EA
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 04:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2572F1F3196F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 03:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7169A224F6;
	Wed, 27 Mar 2024 03:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iAhbJhZE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D599C21A06;
	Wed, 27 Mar 2024 03:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711508943; cv=fail; b=S9PLA11VT5BgoImb/38KXjQvTg+Zr41/WhKL61LqvM3L3Tu3tUGY4Fs4VVjZjIN3elrQrZR4/t75b+01gL+h2uov+a43dj8MXfiGb6r6GCJviiSulzXcxa1c3MjU6zNR+d5XgxQNltFXwXSvNcPrlzuumBkcu9zgN+/QT6stHNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711508943; c=relaxed/simple;
	bh=Ujhjzgoe/fx3rfCG9kn9BBQ0l0KR3BqEg85E3lGT8wE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OWdmj4UILUp6I4nCLShMqD3aJ4k3OBBxtgI8b7xxajaOaZF9/zxiY5g6hqR7V7I/+xxRmTqCTpWlZYMyINok5Zo6sgiLTA8+PMzXd++mRJfb665VqGS5FNTl7VDnU3eM2wbk3jBmzFI5T9pQjlh/UI6UtO9osg+2xg9kntIIA48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iAhbJhZE; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711508942; x=1743044942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ujhjzgoe/fx3rfCG9kn9BBQ0l0KR3BqEg85E3lGT8wE=;
  b=iAhbJhZENTKZj/+6h/TmS9wbG8f1tjPxQ5rwaIr8kadjYPvhGF8fwXM2
   Nkdxi88XcouYgB+jVivGzyHX0+Uq+5bIdGb27vs3eaWkPBv5TnO475Fpi
   xULQPH1XrkDFxN/GZ3Xtlk7EzXpfWoWmSVhI3OtPNLB/s3YohJQnMzrxp
   Z/KkuWFutsR8MQGfjBwsfssgNGVUW6FicvIHVrYzYs9XuDM/DKZbow0wj
   pMG/cmy1vVS18j3kzCRXUH+aWzuCfa+wHtZqlNLZSEPcoog5KinF9Nl0K
   tso5ye335w71/VEWRl5rGOncOv9eDqf1sdaDQnQY+LLvoPvKMPj9FHad0
   A==;
X-CSE-ConnectionGUID: yidfHGvWS9G9s0TQPekLYw==
X-CSE-MsgGUID: EHeqTrN8RbKbiJ0D8givfQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="10390966"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="10390966"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 20:09:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="20808657"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Mar 2024 20:09:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 20:08:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Mar 2024 20:08:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 20:08:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXfgzY/AA6WkY2uusb68aSJrRyhDlx//uHcsa842Pe74jBBvnMTRRhiLuHM/rV83ps0OaGMoWkVqpNwLE7nhJpQhS5sw1vYxNQ+r83ek/EYG1zzEAm4D80c57qIpGRJlsmlwdD2I2IQ/E3YoH/Sf20+Fxfp7AntxsqY8oZL0DzP5rfPLqyUz6ewv1dSawWKDn0aVtxsnW4MbTVg/nPExkBoVhC2Mlea5FACxF4UpwMQO8ebYuxo8M7zBcEFa7B5KO+Rwv/TXQDVEV2QvYfGtJtA55+fkVAwPld3TvDAIclV51z02whFuv7e84zXLS2GAvRoMGkByS4eA12MKDXGgXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpyDjVg3Bq/GecoJiQB6i0U0VpHriM0w5UfWGKHUIbk=;
 b=EvV1nbxlZLl5mraJhvZcecoSsL0iHnrb1A6e+aqCm8zVyPgpfwXzb04O2EEhidSH6ncUei0H9KkFpD5HV+F8jawrRsd7ZORuy7xLBqHgS9sdprvGmAs/62uSHjw0BhB5MKl9TkyQHmlJfMTyHmtzr2qW7hhS2bfqmTt+7GZdTfiSf95PPIuaSgMcGA/C8saW9HaLgutaO8aTcU9vgoXgQZuyyDjeReVBsOmVV+gmIsrwkAkjIuxcxqLSb9tJypbVwxNUg5DFeLV0IWM5nTXQ3iVUnLEIDojesEUUxf3cHK5nPYlzKXMQjfCOQYtUqGUolC7iNB2ODPWWQsQD9a7Mpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MW4PR11MB5799.namprd11.prod.outlook.com (2603:10b6:303:181::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 03:08:56 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::12da:5f9b:1b90:d23c]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::12da:5f9b:1b90:d23c%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 03:08:56 +0000
Message-ID: <b07d0749-8a72-4a0a-a0ad-808d7ea2b922@intel.com>
Date: Wed, 27 Mar 2024 11:08:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 046/130] KVM: x86/mmu: Add address conversion
 functions for TDX shared bit of GPA
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <973a3e06111fe84f2b1e971636cbaa3facf7b120.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <973a3e06111fe84f2b1e971636cbaa3facf7b120.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:54::24) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MW4PR11MB5799:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKvrd9y75kBtQvczLi65/NCdqSdUw6eq9etS4V++QDE9MmIBcHnZGDzOFCpCM/CiPuTNugcNPhEcXSgOLUW2m/AQgA8/aCP0XOTFeRQXEyzTedU3RlZlbDZDfZs6hgBq/11I61UhqT8bltfcR54qAzv34ZAgZIQwKwViT3RqNRugrBizjZl8qFUv0uIXJU0CK9FFtPbqsry3oFNTqyyw4wA3uXFz/AQNP6Qia0UgyeamIxNS7ntCKGDQZNX/U37yVUuzF7b2hzfoKVFdIckyo9XDqnt1w1gsOqc1jcPBpjOkz5P2TKDdqVjPzp7qa3jZ9+PzbmYXODAItdoeM80eK30hvePUKP3moQ5R4IWfLVu7BY/xGDrl+zb6rFAwAEh6XcyqdQqgnomaGlazW9A9sVqw/ifXKzqxiVYDqhYJb/mHnRAGU+Kj9sX7JOJf17Ryusr3pOWkl8OvLy0eM//gyBgmr8cpRbtSwc/PLfEsq8VIlyZkHTn2mMrnikroVQtnC7A9NvPPzwUB623+7wiX/7sxhPfTWYQjBd7jQR1JKQaXsMha/jETZupVWGPCHTMDerDxkVWE/RXJpoKko30xQP/N4X+YpGoWdNAgJmG9el/Tol5Kei3JkmgUTGDKlUAKtYMIHfCpEJjGbzP3iX1HdJLTNcLIK+kS0iA9MNnbz58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2QrYVpWejBOVm8wUVFXN1l0Z0IvZkd3S2JEQmQ3NlU4aVhpMjNmem0rVlhx?=
 =?utf-8?B?U2crUFZoQXlzdm9PTUFRREFrQTgyZmx4QWQ5NnNWRzlGZjR2dVRsS0lNZGFa?=
 =?utf-8?B?cGZkZ2FDbVNmNFBYTllUaFlGdUlKNm80Sy9VbXM5YXU2WEFTaGhFSmNUd0Fm?=
 =?utf-8?B?djQ0cGx2a2F6aFJHVFpNZ1hzVEMxMVZrSkhxY2Rtbk5nVkJ3QjRMbCtsZ2R2?=
 =?utf-8?B?bFR1SVJhb0tTSjhKa2JNUGl2WEdyTTBzQVFJWEtzOS9YMlJVMnpSYUxnOEZK?=
 =?utf-8?B?clJCcG9ORVh1U094RU10dE9TbDRhdG9KTXVZMjdKTUMydCs0UUVjeDhGeUxv?=
 =?utf-8?B?N0ZaSElEZFZQWTIyUTNodlc0WE5YN3hVNnc2cmJFS2V1b1U3Y0VqbXc4dFl5?=
 =?utf-8?B?b05vc1BGQ3RnVXIwWERTNGhabDdXL1BMNGpFYS9mcHl1WHg1eW4zL2prdFZV?=
 =?utf-8?B?eTMxU3FXcHlpcjRwaDg3SEJxbitPWGJNSWlrd1dBT2JJZFk4R1dHem1HWDRH?=
 =?utf-8?B?U3plQmREMlFGVkJYSkorc0owZ3JYcEtkdkNJOFQ1eWhQZFc0Q2JKeUNqSFBr?=
 =?utf-8?B?akJRLy9kTDdMdVVhcndyRGREM1I2UUZBdjdwS2hIazg3L1QvbEtORmZuMEsv?=
 =?utf-8?B?OWhERWg0WWxqbzBONXl4WE9FWjZHZFdxeVpOOHYzNEF1QmFSdC9ZZEVkaS9O?=
 =?utf-8?B?WmFYa3h2RXBHOUFFc2FQdUt1dHU3cXlMcWFQM2JCRHplZkl5cTY4Skp4SVB0?=
 =?utf-8?B?ZkNwMTZ6THFBUHVPNy9QWUpvUTZHRXhNMVVMd0UwaG5xb3pVT21ZTUFsdytN?=
 =?utf-8?B?SEdkNmtnQUsvSkQ1UkVEUVM1NlFIY1dlY3cveDcvN2V1OXc5bkJvRjh3WnlG?=
 =?utf-8?B?T2VXcjBzVDhjdFRhaFJYeUtkSDBDWURRL0xMM0hpOFlXL1Z4a0lIYkxtUmNs?=
 =?utf-8?B?VHk3cTNpQTltaTFrODlkcWcrRDFOejd2eXRUZTlIajE3dHNIdjFDU3YvdkJM?=
 =?utf-8?B?Vkc4dDVTVVcySXpYUVduOGIvRUVMRjhLWE9McGY4eWVocnhSUmVmTXRaUitj?=
 =?utf-8?B?bjNUbDBGSG5JaE9uTEVVY2IwZSs1RDNOT3ErUTMvS2kweEJLc0hGZWgzNVZI?=
 =?utf-8?B?WmxKTVpUUEgyKzZQcUw3N1A5T2h6Sk1PeEd3NUt5eC9hQ2xkY09BL2pMcFc4?=
 =?utf-8?B?OEI0MldDSjZkRTVMOEdESXdjN3ZYODhZSmxYcGR1SUQ3ZFVqL1RtdXRLTTNN?=
 =?utf-8?B?V0UrWEp3U0pvcTVoNTFyb0Z6SEhqNDUvVHpJeTYrOFZJMjEybEFhcFdwUTR4?=
 =?utf-8?B?Q3VaNmpPcFY1UGNIVWM3UFAzZW0wRERWZGVRWmJQWHVrOWR5TWdOV3VvYlB1?=
 =?utf-8?B?TUk1WHVXZkE5Y2szbUtIS1JTWG9HTzRpc2hjZnBiUjZJYlZUaGpjUE9GeFp3?=
 =?utf-8?B?SisvM3ZRZEl5ckI4S2JKRG1BbWRzbG94eW1CdzhkeE9DcUg1NTJtWGQ1ZDNX?=
 =?utf-8?B?ajgvRG1TU1FUUnNnUDFnUjkzNWZvNEhrRmFpUWxtaDRWUTdNczhIc2VRdUhy?=
 =?utf-8?B?RldhYWdra2R4Z1U4ODNjZ3ZSdTlLUmFIR0lLcEsyRGhDRWRkeTNOQitKTlZs?=
 =?utf-8?B?MTlrbDVGdERSY3Zzd3NtRUtYdSswWFpDMzNrc1kzZUgxdnd5YzZ0MWZYUDg0?=
 =?utf-8?B?WWNOSEt0ZVFkZXg3bE9pV3lJb3ZSQnRXbmplaFMrUDRFaUd0RnZvMWJJLzZi?=
 =?utf-8?B?U0tQNFl6NVdENWhtRzRBSlFFeXprdWR3bFR2cVZoSzROWHRqcUsySGlUSTdv?=
 =?utf-8?B?Z2pOR0tZdTVTWjFUK2gxNG1yWUZSVjJTcFkrZ1oxdExxa3c2UFRZcHQ2U0pR?=
 =?utf-8?B?NHd6OUpSK25WTmxrOVNXSUFOclNmZmVvMzdJUU80M3VpYWlNRmdScTZ6UkRO?=
 =?utf-8?B?NUlSdXJuY0RZSms1UlRpZW9WTVlRMzFXNGM0QmRjcCtoc0ljbHd4ZWpvYUNk?=
 =?utf-8?B?RmtFdUNXbjU2RkdETzBTcGt3bTlLMFB4dVFiay9ad05HUFFJSVo0SHJOenJN?=
 =?utf-8?B?L3RtMjVPTDg3bE96eGpwSUJ3UjRJU0NIcVpRYzdxVGpqQzQ2SlljdG00bmVh?=
 =?utf-8?Q?cjYb+LngmrK9xApw/sM3IUosr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a27c87b-f5b6-434f-5623-08dc4e0b3d4b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 03:08:56.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRUmEYi2tJZ5IbGOP7apioX6dmPMlts0U8dJjrrt3+p8UoEeuemYSWnVVW8OXEvJk3VKmnUPgZy+suk5TEJ8mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5799
X-OriginatorOrg: intel.com



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> GPA.shared is set, GPA is covered by the existing conventional EPT pointed
> by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
> VMM has to issue SEAMCALLs to operate.
> 
> Add a member to remember GPA shared bit for each guest TDs, add address
> conversion functions between private GPA and shared GPA and test if GPA
> is private.
> 
> Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
> kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
> the new member to remember GPA shared bit is guaranteed to be zero with
> this patch unless it's initialized explicitly.
> 
> 			default or SEV-SNP	TDX: S = (47 or 51) - 12
> gfn_shared_mask		0			S bit
> kvm_is_private_gpa()	always false		true if GFN has S bit set

TDX: true if GFN has S bit clear?

> kvm_gfn_to_shared()	nop			set S bit
> kvm_gfn_to_private()	nop			clear S bit
> 
> fault.is_private means that host page should be gotten from guest_memfd
> is_private_gpa() means that KVM MMU should invoke private MMU hooks.
> 
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v19:
> - Add comment on default vm case.
> - Added behavior table in the commit message
> - drop CONFIG_KVM_MMU_PRIVATE
> 
> v18:
> - Added Reviewed-by Binbin
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.c          |  5 +++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5da3c211955d..de6dd42d226f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1505,6 +1505,8 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	gfn_t gfn_shared_mask;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index d96c93a25b3b..395b55684cb9 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -322,4 +322,37 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +/*
> + *			default or SEV-SNP	TDX: where S = (47 or 51) - 12
> + * gfn_shared_mask	0			S bit
> + * is_private_gpa()	always false		if GPA has S bit set
> + * gfn_to_shared()	nop			set S bit
> + * gfn_to_private()	nop			clear S bit
> + *
> + * fault.is_private means that host page should be gotten from guest_memfd
> + * is_private_gpa() means that KVM MMU should invoke private MMU hooks.
> + */
> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
> +{
> +	return kvm->arch.gfn_shared_mask;
> +}
> +
> +static inline gfn_t kvm_gfn_to_shared(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_to_private(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
> +{
> +	gfn_t mask = kvm_gfn_shared_mask(kvm);
> +
> +	return mask && !(gpa_to_gfn(gpa) & mask);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index aa1da51b8af7..54e0d4efa2bd 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -906,6 +906,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	kvm_tdx->attributes = td_params->attributes;
>  	kvm_tdx->xfam = td_params->xfam;
>  
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
> +
>  out:
>  	/* kfree() accepts NULL. */
>  	kfree(init_vm);

