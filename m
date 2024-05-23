Return-Path: <kvm+bounces-18090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C95D98CDDC1
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C04A1F23EFA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 23:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F6D12882D;
	Thu, 23 May 2024 23:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IgkGl8yI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D21B662;
	Thu, 23 May 2024 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716507452; cv=fail; b=cclhsDnHLpagrfdQoeahR9PcvgpUEqdnIKOn+rRDR+/UP/9Eiatx7N1RodTPEQL2yywzVRZEouthzg+nQreNG49nAi1V9+wNaP9aTe5kOjSx+KlPYBna0G4q28lnytIh7EFxq7hnCKSlw+uBh4lQUvLqYSjOG84bzIpH9+Z674w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716507452; c=relaxed/simple;
	bh=zLWWN+1Kn7abZrk7EswCn+VKJ5U4s+slO/SDZj21/28=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ddRnrzyhN0wk8vIXFCVdsH/MGP5AuPWe2XfYVzG/gBbhSFL5bOZE2cU34buDdvHABTeLWt1iMxhzznkFmsKjjlKRNJw3NQO6ohVylgaTopl4miNQ7U6aI4m++iUgV0WFogCJnSHFEgNRz7TNujwCNinvataixi2FQmXWZ+SNKHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IgkGl8yI; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716507450; x=1748043450;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zLWWN+1Kn7abZrk7EswCn+VKJ5U4s+slO/SDZj21/28=;
  b=IgkGl8yIitmwyRCFgpQX1YW+aQHK8un44gCu+S8iEURNKRhpSZMlsyO+
   SHKRCCXFBi3z8zeaQ6cSJ4tJ7dYccTxYoiPODFOmUqmfLK/E9Cw2m5zTo
   nBX4YKAs4uadvVzqcKshQnsOrm+jQqiWB0Y2D3ZKP3dUm5J/ZakaSFLa3
   cvn4YjVDjHIikS69CxEXk9aGXTpe7EYCsVQd4hLYQN4w0acuS2klwqUPD
   jfK6uw61Dit2kc6lDDmB9269gjvwxO6FlYqI/rKT142rKo02DcPzXVS37
   86digaNKKpDWUhtPOHdf+smj1hvhCpIpwMscjiJcY3vDsJhHfRH+eHnri
   g==;
X-CSE-ConnectionGUID: 8U12K69oTsGgRMdzZLKVQg==
X-CSE-MsgGUID: OccrF5iwRC6r8CIlhpHfeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="15806923"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="15806923"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 16:37:29 -0700
X-CSE-ConnectionGUID: fiaLJ9rDQqmw7cGkBSrRAw==
X-CSE-MsgGUID: 47XtHWweRyuY2Mrz+BhOeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="33945419"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 16:37:29 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:37:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 16:37:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 16:37:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuhLFWe/PkkAmPTtk8NyqyqUBOsUPMHWbQZGD1mi6wUplsRwCbJqvrcTqqQHwaHoY4lnJJY89CQISP2qFMDuTMys/z24aa1ekKagAM4HyMXBikVZAAvaQNpEszt5C2EOijuztPeioh4J8q0/frFXHAG9FHLsUUoEkj5BKt6JIG5gy/hM+5jx2qSQ/j+fBrYRJFCAx02GiMbd6h4TkACXfRhXLuR8jb8yGuIU+4rDOVuf5vfm0pcusv2ABO1zOV8uf0bvmvhI9P5IbyNyj8KEfBZE5Aq8cxp+cO30S80UrJe71vASlRd1DY4Gz4041RIjjwVGXz/RXQ5fXkNmuVdZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qcw3m9mzDQZXeZJP72vONiueK8z6S/x7XnkFisbmUQ8=;
 b=gZKsOMFdvw00DzEWDynOsfSeNaLQrmx8UtEqVB9e7Po1NvsDRzMz3Vp4kyGMqYpmBPtANfMddniqKeEjYaLZlc4F24oBXWr9WxDJMMyztGDZfV9qxbrAMVf/iYAIAdrZkv3CKg9rYnSIR95cReVEESMcY5bLOxM2c+IW0hpk5jYDMMOkk3n1VXtP/MJbPYBuIynoYSLuAW4nzw+heT2djzsPoqM/BAyqAT5bfaBRFrFJ+OxZt3etMpbWdi1TP5UlnxsrwIqw/VasBZ5EvHLbDwDM/IEci4ffUuFQAkTq+zVZPn9Yvm7GlFneRAhm3B3V3lMJi+TL8nNRhUrjdI07Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB6915.namprd11.prod.outlook.com (2603:10b6:930:59::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Thu, 23 May
 2024 23:37:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 23:37:25 +0000
Message-ID: <46713df6-d73e-4816-bbda-a3b2dc723438@intel.com>
Date: Fri, 24 May 2024 11:37:15 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	=?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
	"Sagi Shahar" <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>, "Li,
 Xiaoyao" <Xiaoyao.Li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
 <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
 <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>
 <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:74::20) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 42cb34ce-478c-4a15-3b93-08dc7b814d0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UGowYTlaU0F6VGZ4ajNYREpzcmEvczdNNi84NmFQbStaN3FoMXJybS9PNjhs?=
 =?utf-8?B?M1h3MzVxUkJVanhyaXVOeFlsZGxBZk1FaGVQL2lYdTI2YkMzUzNPb2tSaDJj?=
 =?utf-8?B?ai9MRGJrK01OSzBDWHlPR0g1dHQ3a2VqdnBOSnNwaGxld0RYcXE3cGh3WFJF?=
 =?utf-8?B?T2hNNkwvM3E4WVF6K3lDOFFSQ0UxVnFYbUxmajB0WXd1M250L09kNlRFS1Q3?=
 =?utf-8?B?WU8vd3cxNzN4TWtha053SmRRY2MrOGtGL2xpOE9QdG1XOGhUU3E0TGZ1Q2p6?=
 =?utf-8?B?bGVCdFBXK1VhdWhIWlhSYWJPTlV4RjlwY0xteER4cEhWWUtRVThHM3hyc3cz?=
 =?utf-8?B?UElsOTNnM09wMTBhY29qazZ3bDNjUndrbmZ6MHhmV04zYmNoUjFkK0piOVUy?=
 =?utf-8?B?OUR5UmFBUU5raGNSeEdYbjRUTEFEVTA5YkNhQk9YMS9pTlJQZjRTb2JpS1cx?=
 =?utf-8?B?b0lQMk1TRjJZZmxZczg5aS9WdHprN2hNZ0lkQkdtd1FKc01reWVlbTJuWmFu?=
 =?utf-8?B?OFpEVzdYV3daK2JvUnB5YzJPWW03c3BoVWNMVGU3SkFqMDNJVkd1dXFrTG54?=
 =?utf-8?B?RTFlK28wVlZMUmNDYTd4VGk0WlpTa3JuNEpKenR3SkVPUDdFUFdobm40K1lO?=
 =?utf-8?B?VFZtaFc4TGcyT3orbDlmRmRUZlE0YmhlUE5RUndDTlE1N21icFJpZ2JJY0dM?=
 =?utf-8?B?czYwTXdORkk3cEo2VEdiczhjWW9iUlhucFpUeGcvbCtmTVBWZ0ZCTks5WHM1?=
 =?utf-8?B?bWswVFBndG4yZFlhM0tJTFJ2RGd0bU40TFZiN0RMMk9ZaFYwRmhZdjcrdmow?=
 =?utf-8?B?ZDNRWmNqWDdKRE1MOXZtSWwvN3FvR1o5aVJUaU44TURwdkNxZ285aTZ6U1Bk?=
 =?utf-8?B?VW5YcTJtdGw1UjR1RkllSUNEL1liTmxSdGNmS2lZM29nL1ZFdGxESjcyVS85?=
 =?utf-8?B?Zkl2MnR4aFNXSmdqVWhkNEZWK2tMaVQ0bSs3R1F6aGR2V2ZVMUZtNU9XaFht?=
 =?utf-8?B?aHoycGpPek16SHp2cTcydms2ZzNxMFBCQnoxSGJJNlMvZVVPWXEvOUR1TjdB?=
 =?utf-8?B?YmpxQkRxNGhuaVlNdmZpbVFCcEZ4SXMrNFRldENwa0lreWtRMEhqRUhQdFUv?=
 =?utf-8?B?NmR4WDZMVlM0dklScUVER2pPTDZGSHV4M1Y1SWpBcXZROC9QSm9zeCtOUjcx?=
 =?utf-8?B?RVBPMnlrODZmWUJPUWtqUkhwcXh4VlRNNGRRNnFqaVdLell3K3RDUG1SbFR1?=
 =?utf-8?B?YmFncGVnWThabVg1dG5pZGdvRXVDVTVWWHJwUmorRWZIVnNYSnN4SHIwSWFo?=
 =?utf-8?B?VmxCc1ZTUHhlY1FTNkI5R1lXbXh1dG1RaEpvSnppbzdrWDUxSFNGSnhKUkZM?=
 =?utf-8?B?Umt2QzBtUWhtZ1JxRW1nWTkwMmFsRU1vOURJT3lDZmU4ZDAxQUQ3SU9KZ1Vu?=
 =?utf-8?B?aTFuUXpDQjZRZnozcTltNmxTd3BIYXFhVDdQZU9kUDNPek5Bem1BNnRMZ1Js?=
 =?utf-8?B?Zi9IWC9PaVBiYjY0RVBSb1c2SmowelZVZWRVTkh3OXQzbFRLQ000OFZTdVM2?=
 =?utf-8?B?dDRkakkxeHc0NERxSC9zZnhCTERoU2k2ZVoySHVTb1c2M0pDVm1wdEJSbWVD?=
 =?utf-8?B?bU5rSkdDUDcxMU5uU2lUSkNWNkx0OWU0S3ZjakpjaUgzNStIZVhPa3hlL01q?=
 =?utf-8?B?dmJ5NHFoeDIvTUlhekQ4R0ZoVjlzT1hDZ2R5NDZ0Tm9Oby9aTnp2aU13PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGxLNm9DM1h4WHR1cjVsUWZkRTRPdmxYM1pZOVNqZHArOThjS29MUXZ6Tk5K?=
 =?utf-8?B?V0x4VlB1VzJHR1BGa1oreEdOcVJHL3kxZzJiWjl6WC8xUm1XRFA5OUc0MGdP?=
 =?utf-8?B?SjN2anRQUGl0LzcyK2VvUzEzNlRscUtmTzIyK2EwTElKNGpWcjhieE5DN3ZE?=
 =?utf-8?B?RkZZVXF1eDl2MExNdGczbDlkR3gyVVVMTFBkYzlpTDlYUkhBRC9UZ1pIeTF4?=
 =?utf-8?B?cXFBZExVcmtobmY2M2p6R3hwNG5NbkR3eUlVajVRcGh5VTNUaWw4dngrOUhY?=
 =?utf-8?B?aEh3aS81cUpuMHRCa0NDZGpUR05nZE5XQVBoM1NKbXo4WFFoWEdkaWI0dU93?=
 =?utf-8?B?aVlHS0tCSkhWTzNLbzkyWEZqUS9HMXJ0Zk11RHFPaG45R0NVNVpLZExyQTdn?=
 =?utf-8?B?VmFIMWN1YVY3bmtiTVBid0NlU0xJd0sxR1Y3NXluc1BWQTZWa2EvOEp5blhS?=
 =?utf-8?B?MjNFRUhCOHZqU3NGL3ZQUVBLNmQwODBRQVBoclNUYTVlMDBSbUxYdEFaQ2xa?=
 =?utf-8?B?ZUVjTWZmaVIzZEJac0w5bTlRN2JYVjFRQnFMTzRkb3p3aGtFQklYUTlTYS9Z?=
 =?utf-8?B?MS91TkFIbEduWCtONlRMci9pSkN3Qkk1SEw3TUlvblU0NHU3YkszVHlaWVJG?=
 =?utf-8?B?NENQbW9lQ0pMRERLbHlmQ3RCNHIwb3phcmxpdzcvY0F1Y1lYdU5wUWZxZ0hG?=
 =?utf-8?B?YmFiYkdlMys5VGc5ZFJGN2tqMTk5cXdIZXQ0YUo4TDZUYmRpRVdHSXNhdGUy?=
 =?utf-8?B?Y3JGckUvelExbVVnWVlPNVJUVi8rcms3UENsTjdidXI3bmt4aUFxWDZqZWxj?=
 =?utf-8?B?VzVIMjMvRnYrT1NnWllzWjRHTWFkZFc4S3g2VlQyRnJVME1jeWxQWElQc0Fz?=
 =?utf-8?B?b084bnhrY1ZucWVFdmQwVVA5eXBZRHgrandMc2ZjOExBa0RFUXBLeDgzQXNi?=
 =?utf-8?B?akh1bzhPOGljTlMxQzFnRDNmcE13RUx1YUNReWN4d2JhbFJlYWJJVGw0VDN6?=
 =?utf-8?B?aEc0b0NlaXd1NE1yWUk0aHN0UmpTRVo5eHZiMW10enpUd2sxVFUzZm1uU2FK?=
 =?utf-8?B?WUlGTHA5MFVtNStjVTd5Tjgwelk0bWUyOW40OGxwbHR3QWVzeStnRStTdS80?=
 =?utf-8?B?U2lNKzFUYUpBNkpPN0kzSkIrRGZNZi9ISSs3ZFlPVlJJN2hFNXVNR3RKRWRl?=
 =?utf-8?B?cTgxT29WQkJmbko5NkRzOEpwbHIrSHJJWGRmV2xWYkJ6YktFUlpvV210cklL?=
 =?utf-8?B?dkNtc1VwTDlKYVk4UHFURGovTWdjUE5yck1HQStYd3BaTGhld2pxWWQ5RnhF?=
 =?utf-8?B?UC8yc1hrK1plQlRKRUVOa1Flc0gwam5NZVVoVERVb3E3NklHSzZoV0NQdnl0?=
 =?utf-8?B?MDdzL0V6aHNVSVo0dWtROWt5bFpSVjNzdFZUdkc1aU5KTUFEQ1V3dzhxUEJp?=
 =?utf-8?B?NFFPdG5aUzdBbUJlcmdrY2Qzem5QVndFdWtQZVB4RzNYMTZZbUdXaDA2a080?=
 =?utf-8?B?eVdVbmt5blVVd1lORG1IZytVUWZaWDlSRGdBNE55eFY1K3FRS1AxN0JjQkVs?=
 =?utf-8?B?Y0hjQ1ZiWEpsNjBoWEtCMVptRFB6T0RoeHFNYzJQdjFGNFdCYlZZMW1ScnRy?=
 =?utf-8?B?aXJ3dVhhY1RSYlFxYkRIc0g2NWo4UFI4RmZPd0QyNVlXVVdHVlJUY1lMMUxU?=
 =?utf-8?B?L0pKTWt0ZkVqMkp6NEtFWWlUdlhiemFNYlZzQVdZN2JSazFFY2ZjTEhhMS91?=
 =?utf-8?B?M09namJWdktsZW5RSlhhdW5XNFBReHpqT1FRKytCeCt6cDFXYVM1S3JZYnRS?=
 =?utf-8?B?dXJtQmpTUDFrQXRoVlhxQ0VFdVpyaTQzTk9KNjdJSFFGN2VPL3F2Z25WdTZR?=
 =?utf-8?B?eHVHbnJtekZhakFsWitMQmlLWS9wa2oxdzlwSHdGY05CN29wQVlZSHRJclkx?=
 =?utf-8?B?bU03aHNBelBoTjFHdVNSY2FIYUszcy9JVDN1UXd6QmZvZ1RHaXhqa2FhZHlE?=
 =?utf-8?B?WkgvYnVzUlNENkRLcFdjWldwNHRvWGlhdkwxZS8vODBGRFl1Zm5iWkJKMXl0?=
 =?utf-8?B?amkrYWZ4aEFhNjBVaDVEUkgreU5FYmpDajBhU2lBcEd2cm9DMnFtQ2dmSzNQ?=
 =?utf-8?Q?3vFypgmBGHU4IopjCDzgvh7Zc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42cb34ce-478c-4a15-3b93-08dc7b814d0e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 23:37:25.5564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwUgeY9BhWlXswX3fD5oCktgdzRTmzL08EKiXiQZqZLYGf+pJhhNWyA/KB3/Dqli5ZVynqsw8XLNVLfcBvObJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6915
X-OriginatorOrg: intel.com



On 18/05/2024 4:25 am, Kirill A. Shutemov wrote:
> On Fri, May 17, 2024 at 05:00:19PM +0200, Jürgen Groß wrote:
>> On 17.05.24 16:53, Kirill A. Shutemov wrote:
>>> On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
>>>> On 17.05.24 16:32, Kirill A. Shutemov wrote:
>>>>> On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
>>>>>> @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
>>>>>>     	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
>>>>>> +	/*
>>>>>> +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
>>>>>> +	 * always work around it.  Query the feature.
>>>>>> +	 */
>>>>>> +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
>>>>>> +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
>>>>>
>>>>> I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
>>>>> be here.
>>>>
>>>> No, I don't think so.
>>>>
>>>> With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
>>>> problem in case the seamcall is clobbering it.
>>>
>>> Could you check setup_tdparams() in your tree?
>>>
>>> Commit
>>>
>>> [SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility
>>>
>>> in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.
>>>
>>> I now remember there was problem in EDK2 using RBP. So the patch is
>>> temporary until EDK2 is fixed.
>>>
>>
>> I have the following line in setup_tdparams() (not commented out):
>>
>> 	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
> 
> Could you check if it is visible from the guest side?
> 
> It is zero for me.
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index c1cb90369915..f65993a6066d 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -822,13 +822,33 @@ static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
>   	return true;
>   }
>   
> +#define TDG_VM_RD			7
> +
> +#define TDCS_CONFIG_FLAGS		0x1110000300000016
> +

Hi Kirill,

Where did you get this metadata field ID value from?  I assume you meant 
below one, from which the ID is 0x9110000300000016?

Or is there anything special rule for using metadata field ID in the guest?

     {
       "Control Structure": "TDCS",
       "Class": "Execution Controls",
       "Field Name": "CONFIG_FLAGS",
       "Description": [
         "Non-attested TD configuration flags"
       ],
       "Type": "64b bitmap",
       "VM Applicability": null,
       "Mutability": "TDH.MNG.INIT/  TDH.IMPORT.STATE.IMMUTABLE",
       "Initial Value": "From TDH.MNG.INIT input",
       "Field Size (Bytes)": "8",
       "Num Fields": "1",
       "Num Elements": "1",
       "Element Size (Bytes)": "8",
       "Overall Size (Bytes)": "8",
       "Base FIELD_ID (Hex)": "0x9110000300000016",
       "Host VMM Access for a Production TD": "RO",
       "Host VMM Access for a Debug TD": "RO",
       "Guest Access": "RO",
       "Migration TD Access": "RO",
       "Host VMM Rd Mask for a Production TD ": "-1",
       "Host VMM Wr Mask for a Production TD ": "0",
       "Host VMM Rd Mask for a Debug TD ": "-1",
       "Host VMM Wr Mask for a Debug TD ": "0",
       "Guest Rd Mask": "-1",
       "Guest Wr Mask": "0",
       "Migration TD Rd Mask": "-1",
       "Migration TD wr Mask": "0"
     },


