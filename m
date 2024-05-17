Return-Path: <kvm+bounces-17583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8383D8C828D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3D5DB2107A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 08:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E543036B01;
	Fri, 17 May 2024 08:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="byMOpCHn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B98E364AA;
	Fri, 17 May 2024 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715934487; cv=fail; b=asvXxITMIChmCYq79DCrWISDmbZaumHEY3mKoGtb1nqBQyC88GepHgECmhWeaElNLmGMS+ZizCVvQXLy1iWGxZk+iF9gkG94jkKD1az9pYx+jdopEK/D747AmIbUf82pl++eiPygDAd0aBjMGkSKPvji7O7QAnNSLs81JEc1pnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715934487; c=relaxed/simple;
	bh=upuEgSfQulkhomzdwYradm5jL8Zlw/v2LrmOwthCG6Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kqNiaaLdId4YkFiej2BGtnYLIjz/GMcZrib08hCb/vcIYlUeORLo7wUfh5RpzBa0t7SH7GYt8Zh/XN4LIfmCYVCebyGt1fLfzogKhec6lsQiACK2U+ekbMyDgKxZtYVX9trr4Ez+fdU1NS+KEUi32MhFs3ZXKTURsOP/3ZWf5yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=byMOpCHn; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715934485; x=1747470485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=upuEgSfQulkhomzdwYradm5jL8Zlw/v2LrmOwthCG6Y=;
  b=byMOpCHnZRdg9EGlYkckM1NXVp4Bd/++YOtlN8ytTvrZjCUumXQHXX9m
   dvzsn1EqtaFck/dihALC7tQpDDUTcErAcEhEs+h7lFQSqnsKK/Xx5+aHR
   A0wS5MlOop70J6CjAXdMj12ykJ3PbRi9+d2RDOFVi8D4EJXa2m0dpPWLE
   RXlS3yQxheTFm0Jrb/Gr10SEeA3yXbsUaiM1TtI+dOuM155Ck+5Et9u1R
   9vRy/wfER9q8bdmMK2OYSUd8wNG7nTHkTKhEpuERnpdXktpoCTu+pohsm
   jTB2/pJ1G4Kyn5gOmUaqPHaAfgXDkZ8CFDClU1iO9uvzl6/LKfcXiOQjQ
   Q==;
X-CSE-ConnectionGUID: zlO+pP4KR+GH4vXkP6RA7Q==
X-CSE-MsgGUID: V74bi9YiSUegmh0tUv0OAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22677893"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="22677893"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 01:28:04 -0700
X-CSE-ConnectionGUID: c55w+4cKQRi4IBjEvrFE2A==
X-CSE-MsgGUID: kxXTVyeDS2qrLb2uoqCfxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31818843"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 01:28:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 01:28:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 01:28:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 01:28:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+EojPyneI+SgD98cAKCtIRGQnVjMGT7feVn7Pw57op40pH1CzztlUQJiTpwsvRZNRG8DpFn/B+qgovtlpIEgBLEx1CdRlMjJx16BZbWg4yeDBYPaHntHFeloWWxdCKFFOCuCXwS0QAFoclKBJifKBVDotHsrR0hoouXEtAKVunBlE3023fnZvK+Wd4Bok/Y8LLHwG6mYVyFk2QqFur2lqgO2UPYcFtyZCn5LUFma0uMicAz1+sYa6Qe3in5xOWbgkRfKsXzFF+u3P/li0fi1s1kfG44CB+10gfdtevFkwUSwNTKpJqCamEEDQ2WOYdOPgAY8rxnuWLeedwerJnlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWj9icTkNFHHcQ58EAQrXXCO7XaB+oYEjpzgYDL1YPQ=;
 b=S5awem6ZcoccZfMZJ1AKnXh0lRHtICbtC2ihifYJv1/m7p6tNyRV4Qna8NWcRMpXtjsEePdX6Gp0E1+DMP/ctcUNigTw49bImS4u5n7e/oqa0PD+bATfc66qbM2SKJMAFOryYCXacdhI4VxtmSJtHKrSdrUGpgd9UpSIzYvN1y93mWB+w4bAk/2VC/mTfChtGUM+KlZsZ053Ay95Ht+1uNApH5OaYwKOVpF8U152/M3M6WgsrGSma6diJJgKXU8hagtznUN460wzs80DsH1o2Sp32vEMfT9iG/fybXCENXmJ+RdUI6f0q1i1oEIX8tMkbHHnkonVwOmy0YF/AW54yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 08:28:01 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 08:28:01 +0000
Message-ID: <0c714b55-4fb8-455e-9f09-6f1f431d1356@intel.com>
Date: Fri, 17 May 2024 16:27:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>, Dave Hansen
	<dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com>
 <f2d6d62d-09be-4940-9c6e-92f80811587f@intel.com>
 <ZkY7PblLmWdFYeSa@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZkY7PblLmWdFYeSa@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::23)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b215f0-efe2-4050-a920-08dc764b43f0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1cyT1pHNUpWbW9oYTlDMlpoSEJIQXdkTVBNMXc2MXZvbStxajJtQUdSSFEr?=
 =?utf-8?B?dFRIRkNRd3V2U1k2d3dTRE1ZRW9VZjJUZkZJYzhwSHdpWnY4QSthMUNzdXJ4?=
 =?utf-8?B?TU41a0NZTnVIdDlGYmIvVWRpZnRvRkErWTBPVVhGMG9XZ1BCTlo5NElCUG5G?=
 =?utf-8?B?NmZvRXlocm9xV2EwT0hFcys1Ui9WSHd2eWdOQ2tOS3A5M1dSMUZKOUdmdFlG?=
 =?utf-8?B?eElwQ2VqVlFxZVBpckdQTW4zTWxiZmpyQTU3RDNzUUFFbGFDZUtTZ0VjSk0w?=
 =?utf-8?B?TGI2c3hicmpkSVdNczhQaVZMS05DcVVZeHBQbWI3MEhSUU8wNWVRY0t6MUFY?=
 =?utf-8?B?YXZGR0VaNFljNG1TZUpER3BmanFCWDFpSG0rUU8yUm9wS3JlZ2dKWElQRFpX?=
 =?utf-8?B?azE5bGV5WXlNRkRxZmtmWkd2bjRZdUhUWlZVS3YrZFQ2bFJhTkJkZE9BYmtG?=
 =?utf-8?B?RENLQ00vZENvYzVrWnZKRnJSZ3dNQ0ZHSnhRVTFHNTBWa1BwZ0thUk5PVUov?=
 =?utf-8?B?NUZSRVlXYTFTREdWMnZuUzdFcHRnL3poQk85VzJnQmNrNmhiSnQ1c1ZKOVRi?=
 =?utf-8?B?OTA2VitYWjlldFljcklNdG5ubWZFa3REVHZ4SFVpeXJ3bnJPalBVRkpwd1dN?=
 =?utf-8?B?UHB3UTFqQmpPUzFSUEszOExuRVhwWTFiK2ordnRiNitWV0dkOCtUMTNJTXVt?=
 =?utf-8?B?c2V6Y0hacU8xUk8zYndtZzlFRXBlaGFrMy9UblZIOWVrTnNtNU91K0NyV1Rt?=
 =?utf-8?B?NzFFVzd3VWJPS2tKQy91Qi8yK0Z2azJHaDdjTnl4Y3d6Z3BabmpJV2Nyc1l0?=
 =?utf-8?B?WGFBZWxEaUNjVE1DeXlXaFBTVlZWeGZZV05RZ2x4bzhZTUpkbWFiQ1orZytR?=
 =?utf-8?B?VTR6OGdrODJYSjB1S3FnSnIza2tTSzVwYVlUYmRjYXdLcFF6bzNhRlJRd1Uw?=
 =?utf-8?B?SG9ld09LcmdLamduN3hsM1B2Q2hTRW1UOCtydUZKaTBLL0lxb3hvaEtpTkJl?=
 =?utf-8?B?V0xKNnQ5VlpUV24wSGhLZ1hYTnMwc1VHN2ZDUVFBSHlHdjgwNlk0bW9Paytr?=
 =?utf-8?B?WEgxenVQblYrYThFdnFkaXdkZmpKc3NvMFdLQzhGMDRXRWJVZ3Ava1ZDY3BI?=
 =?utf-8?B?UlI2K3BsZmZ2RGN3UXRnaGQzKysvaXFYelV4QTFpajNzekk3U2RTUkQ3bnpN?=
 =?utf-8?B?dnBCV0dYeFhVVUZmaDVRUjdjcEtoMVYvRktwdDRNZ21kckVYMklXbmFSM2pv?=
 =?utf-8?B?eXJZVXF3ZGoxTEw4RktReTFTRUZyMDE5K3plQTJjaWN3MHlpbVpaUHhINVJv?=
 =?utf-8?B?cGo5UVdWUjdWVXU4NmZubVk3SHp1ZmlXd0NGc3FkYjRSV1RiUnZRbXYydG9x?=
 =?utf-8?B?U3kxRVk3T1ZvOE9pVy9XSGdKdS8yQWNIQ3NRV1FGVDZtNXdkNkY2dmNGeEc2?=
 =?utf-8?B?WHhLTlM5Qm5JZG95OTJLd2hpVmhYMXA4d2ZJZDdMc0g4QUtvSzc3cVJ1c1JF?=
 =?utf-8?B?bUJEaUxUZ0Z2VmhNU1p5Zk5Ga2NyNm5WdFVacG9nWW9OSWJ3QWw4Rmg5aUJY?=
 =?utf-8?B?bXRHa1FoWFdXVWY3YytLd21UY2VidENiQTFlZXl6WlB5SkFaT2RDQjB3VWNU?=
 =?utf-8?Q?bnjCEbvPs6kXZTYEI3RES797BCFDaBsUwUmTurFh0ClY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0psZU5QUzU5cXZHQ082alpjQUNGZ0NHRlBRakRxTDl5ZXJTbHpYT0ZDR21O?=
 =?utf-8?B?UG9wRG8yejZzZmFmM1BIU3Q2NnFDRWZsdGJKQ1ZRRjl1RXZYcDg3SEtyNzlJ?=
 =?utf-8?B?SmJtS3kvcWR6aGFuNEF6dTFDSUsvQzU3YmtRWlg3eWRla1BvcHF4aTJxeWNw?=
 =?utf-8?B?VGVBQkVMYWtsUitzSW91a3ZRNDhvUlNTWmVIMHR1U1hPOHEyUUFESzNianpj?=
 =?utf-8?B?MncxU0hLM3FBbzhPVlNkc2xWLzRSTFdlMEZITWFjWEI5SWNTTmw3TjdRSDNy?=
 =?utf-8?B?TjU3M2FhMVEvd2JMRWJMSG52djFXeG8xeU5vQkJ0QkhBT3FmSVBkcWZKamhD?=
 =?utf-8?B?TTI4SVRWUytRTTIxamRFN2ExcjlwZW5ETkJ6QWFNUWk2Z1lpWERxcU13Y2Mv?=
 =?utf-8?B?WlZOV2twUmZVay96QUNDZThVSkEwdmlwTnZVczBkVU5KQ2ZGOU1tMVZQUGdR?=
 =?utf-8?B?WjJ5QzFnK3Z2QzN2bEV4R2MveWxBZDdycC9vQUdWRDI5OW9QRmhMUzB6c2NX?=
 =?utf-8?B?M1NTb0g4L2E1Yml3T0w2SSs1bFo5UFMxN29tcHBFUWlJK25VZGltS3JIQmIr?=
 =?utf-8?B?K3FYR2MvTWtnb1Rla3FIOUR4Wit5djMzV3ZlN1dGMklHVGV2OEZXV3BCaFVF?=
 =?utf-8?B?YTRsYmVEczhGR25JMkc0ZmsvbGpSL3NYQURtTGx4dCtmaDJqYnEzOUNaVnhs?=
 =?utf-8?B?OUNDK1JPYlpLTTl4enVpazdtakd3WFZReXdSREplWFZ3UW9RTGZ0akhwZUFt?=
 =?utf-8?B?M2lQQjh0QUYzTXFKcExQUFpicUZxeUdVZEhVV1VmcTloTDlzbHhaZ0x3Vjlu?=
 =?utf-8?B?aWtBTlp2TEFKSVpEckxsTWdYZFFHR0RaUHBOYVF6WDNTVVJLWmFKUFFDOExh?=
 =?utf-8?B?ZEcxREtNeERtamJzK2xrL3ZWYWl1c0xlOHptNURLbjBid0NUVmgxWFZVR3Jj?=
 =?utf-8?B?Y1N2bFlyMGtYeFgzM3dXNUU4TVN4UitROTdNUVVMVFF5ZG9kNFljRGlFS2Ni?=
 =?utf-8?B?dW1UTDZFbFBCaUJuMkVaVlB5VllLYlljUURRN0ZEVkxncnhuVGFramlrOGdz?=
 =?utf-8?B?VjIrZzVzN2VWbkhYK1FuUHhpaHArR3hxVnNkZlFJdlBycUxFc255R21mcDh0?=
 =?utf-8?B?K1dXa2VrdE1LMVhXK29MSFVURXNVZ2NqT3UrUkpKOFFEemozRnQrNHdObmNo?=
 =?utf-8?B?NnhHcE5HY2M1SGJYN3BnZURpOFJlQndJNVR0MHo1ejFiekJXNnRIUG0yTHJx?=
 =?utf-8?B?dExGbzA4cUp0MWdDL0dZTjlLcVRqY0NuN2h0dzkvNmQxVyt2SFJ5VXRPdHZv?=
 =?utf-8?B?WXIrSVJUQkdlaTlrWjZyVGpOUUl6SEhLcjdIelFqUTFCd082dlUwc3VQcitS?=
 =?utf-8?B?dDNZR1pnV2hsV0hGRi9UdGpIMjFld0x1WmVodVZNcFJabVVIdU1EZFlMdzhv?=
 =?utf-8?B?TCtOcFZHMzFSd3QzcWdVL1A4azByaHVRV3JpRTd3ck01R3VhQmhCMzREODVn?=
 =?utf-8?B?d0tSbXJJeUlPWFNlb0hjWjVyVTRVcXRmU0hUc3oxaTVpZWVidmNkMGdITjVV?=
 =?utf-8?B?SEN2Y0lXTXB6YVBkQXNiVDBMVHE4N2hIYncvWTM2K2liTTFrVk1MSGlJdHhz?=
 =?utf-8?B?aXpRdUdla21nNXRxS3hJMlkxT0Z1R1FKSEI1amtwUmo2ZkRIaW1GWkRtRmZk?=
 =?utf-8?B?L2YyaUVFblhtZUxaSlFOWjZSU0phT0RFazlDUTVCcWUySkRYdzNyUjliWG53?=
 =?utf-8?B?MUwyM0QyUkN6cWlaYng0NnF3bEs0cENuTUJkdEpqdjFNS2VzU2t3RUg3SDZD?=
 =?utf-8?B?R3hRYmJ0dnVYVTdNdW4wbzc1aWFZK05TOCsrajJsN0VHL2JvUjJNdUFRYk56?=
 =?utf-8?B?NmJ2ZEVvbSt1OXhaNE1WSEJsWS9aTUFHcHc4Wks2LzhxbUQ1ZVRxdWNlQWxG?=
 =?utf-8?B?Qjl4Uk5rY001TUJaYTBnSU1ITlEvTFNudDNaNDNzVmlhdjNTU0JwaUlaQUUr?=
 =?utf-8?B?aTEvWDE0ZzNhdkpvZGVveis4ZENnTlN1Ry9FTjBVdmdDRGNqTjFTYkE4WkNl?=
 =?utf-8?B?d2cxZU8vaUxCVHdWRC9yMHU1OVhZdTd6ZlQvWllKM05KcDNrTTZCNTlpNzly?=
 =?utf-8?B?ajRKM091OVg5NDIwMzFhUk5NYVdJbjIrY1VjdUY4OGVNWmFSUlZqRHRpQlJs?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b215f0-efe2-4050-a920-08dc764b43f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 08:28:01.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: keNJMwXQgfsK4VWPeQpYcn+gPzuS7DxcdOVEfVPbJuEvYHR3HPM6CN9RsAu3TlLk2blgoAtAMgNledhxpKjz9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com

On 5/17/2024 12:58 AM, Sean Christopherson wrote:
> On Thu, May 16, 2024, Dave Hansen wrote:
>> On 5/16/24 07:39, Sean Christopherson wrote:
>>>> We synced the issue internally, and got conclusion that KVM should honor host
>>>> IBT config.  In this case IBT bit in boot_cpu_data should be honored.  With
>>>> this policy, it can avoid CPUID confusion to guest side due to host ibt=off
>>>> config.
>>> What was the reasoning?  CPUID confusion is a weak justification, e.g. it's not
>>> like the guest has visibility into the host kernel, and raw CPUID will still show
>>> IBT support in the host.
>> I'm basically arguing for the path of least resistance (at least to start).
>>
>> We should just do what takes the least amount of code for now that
>> results in mostly sane behavior, then debate about making it perfect later.
>>
>> In other words, let's say the place we'd *IDEALLY* end up is that guests
>> can have any random FPU state which is disconnected from the host.  But
>> the reality, for now, is that the host needs to have XFEATURE_CET_USER
>> set in order to pass it into the guest and that means keeping
>> X86_FEATURE_SHSTK set.
>>
>> If you want guest XFEATURE_CET_USER, you must have host
>> X86_FEATURE_SHSTK ... for now.
> Ah, because fpu__init_system_xstate() will clear XFEATURE_CET_USER via the
> X86_FEATURE_SHSTK connection in xsave_cpuid_features.
>
> Please put something to that effect in the changelog.  "this literally won't work
> (without more changes)" is very different than us making a largely arbitrary
> decision.

So I need to remove the trick here for guest IBT, right?

Side topic:
When X86_FEATURE_SHSTK and X86_FEATURE_IBT (no ibt=off set) are available on host side, then host XFEATURE_CET_USER is enabled. In this case, we still *need* below patch: https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/ to correctly enable XFEATURE_CET_USER in *guest kernel*, because VMM userspace can enable IBT alone for guest by -cpu host -shstk, am I right?


