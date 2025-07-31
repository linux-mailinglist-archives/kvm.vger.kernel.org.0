Return-Path: <kvm+bounces-53801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B1AB17703
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 22:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A7816266F3
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 20:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D570D25F79A;
	Thu, 31 Jul 2025 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmLh5pUl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D11C7013;
	Thu, 31 Jul 2025 20:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753993033; cv=fail; b=e+AQ+SQCxFvkj4Q1LHmYaNg7bCcBS8uiJMf8UW9EjR4m0z3nQ4vQfwUfpuHw2+C0J116+fTAqxtSLAE03bi9NyBtovbZ3LC0JFp40eR4tuM0JgNOBALiBrw+AXg/4QRUOh27ucmgvVrROw2oY109+L4EoBrY/oqB/nqbmWSF6r8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753993033; c=relaxed/simple;
	bh=qKgs+0MGOmnEnHM/gCpmTG48twD9J4mRtkOxpIjS1cs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=gglfn5D81d6cmPCxyIYP0TLcnhPkGQsiNXNs8AvPhg4eFphEBcvCNXPocA18rGjMf7OOJjADYnk3RkUQRDy8SqMGTcN5T+2SKRF0Y3CoIzZq3Xr/NyT8q1NUqT3ph++NVaFFxRWWT6+QikgxU71i2NBWQWa+qzeSsCOWbrHtDB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmLh5pUl; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753993031; x=1785529031;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=qKgs+0MGOmnEnHM/gCpmTG48twD9J4mRtkOxpIjS1cs=;
  b=jmLh5pUlvvmwRhgwEHnQcalDSMC0e2YhiZ5HLQi3UFZikqDvrpoyXhoq
   BXA9/uBAYPFF+5/ixGS7O/T6RoyfDntBnZuK7Rpnw9GTVYlF0w+7nwnyF
   gTt/VOLo/VED9ttZxJ/4QtdL7n4/TsijIqVJLZk1ntfAVNn12wsjJuvKP
   EZg0UZ1G0dHgs9p/jodzjjnBG678BMOPTk2xzBpUeCTqdPfyN0ruCIgh/
   YUXANlC47ZumLYOh5Br+n46GbAoC/xNIv1Tk8Q/8BY0IlTiuSpX6unEI5
   YHmbC9OZ1xwIhOhN0lcr0evwFDxj3dmrk3q30ivjtPAf02jVR3j/sNiUX
   w==;
X-CSE-ConnectionGUID: 7m7Cw0IGTJi3if39m3TURQ==
X-CSE-MsgGUID: b9L5mUUwRqSSWwr7xFmMQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56481257"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56481257"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 13:17:10 -0700
X-CSE-ConnectionGUID: sr0ac6DfQ7CGy/62bkAG5Q==
X-CSE-MsgGUID: 9mKbCyrcR3u1PeShJSCLNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167587052"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 13:17:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 13:17:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 13:17:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 31 Jul 2025 13:17:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ahc9UVVi+74J54xD/6xT7MB450TeScBfgt1mI2BRDRZ7sZ0bKSQ7I4HZR/Zy9KwPTOzORy9dkRknLaWSkD6m9doWk4wD/qwnkddSBbyG2l27fRq2AdLWaucKWo7xDDZksGaNzkG55UCzPwN9dBabDntJQqBi35ZKEmJJW9MUxUjC+Iqb9zQlGJTgaU17jxE9vJB94nr9igWLG7C2kLwon7tlJ0WFRnyC0ISXcbYQKfOQpOqbF2C2pXXBqDUJQOf9dPuyklSDPAYacRE8QwirqcZuIKyhk//qDlRJwzW5IVvfL4MN9HITWmV0+2pTX6ZB+MbwcbDL1+szEOVJdqJ48w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAu36W+8QbVjmmoSTlqBMamDh+m93XvVX2EXP8R5xPA=;
 b=KP4WVfKbyqvRNvyWe0oOzClLwH1bYOLJX9ogg621zy3eP0mSqy91VBQUzofsTyVCMdt/7P6Uj7/L4IEEDKskxL+PDR6UoghnpfwUIHaMCwvwG4/lXibyTZqp8jPUf0U6Q+npPz663VReSMjG1HJsr8Vyk00o8Yt08aw6QSggTK+++yDobeqUZUmXDoK/LncvlrSDqekfZFeR8tSQXFQNXsmhlD8M9vHRVWoVCiciprBYKuClvrFqOfLOiqqt3RIOERibjGB2l4xVpMtib0mt+70QYg028YmUZE+viw9YUnOQsuMwJoQkbtmKPc6msgIEwrVuOvHB9w3nGfrATCEUFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7002.namprd11.prod.outlook.com (2603:10b6:510:209::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Thu, 31 Jul
 2025 20:17:06 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 20:17:06 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 31 Jul 2025 13:17:04 -0700
To: Chao Gao <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Message-ID: <688bcf40215c3_48e5100d6@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <aEFWgV0a2kLI62Bf@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-5-chao.gao@intel.com>
 <61fd680c4e4afd5eb4455ee0dbbb05c30f0e7a0d.camel@intel.com>
 <aEFWgV0a2kLI62Bf@intel.com>
Subject: Re: [RFC PATCH 04/20] x86/virt/tdx: Introduce a "tdx" subsystem and
 "tsm" device
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: d56c8a0d-56c0-4822-6f10-08ddd06f380e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QlYycGppWDczWlU4WTFMNkwxVDZNZnZmVUVhblVaZmp1dThMbWh1eHVYWDh3?=
 =?utf-8?B?elArdk1pcWQ4WVpFL2Q3SUlVbUdUL2krdUVvSTZ2cUo3QmdmUzNoNXlXdjJU?=
 =?utf-8?B?Y2U3K3ZVM25VWXZKRjZHQXVuMlI4aVlBVlR5NnpoQ2tuNWttNngyUHFReWgr?=
 =?utf-8?B?WjRjMmtoVWhKb0Z1dk16QUpJUXJrUWZMQWh3ZXE5REh3MzNYelAxNjBya0R2?=
 =?utf-8?B?NG9vc1FiUDVYbVkwM1daQmxJWnJRdHBHNkkwVHhpVVhJQXRyUm8vNGRoNkph?=
 =?utf-8?B?YUhlVm1VQW1FWUFUeXRHNUZLSkFVNjlKeWdSRXhoTXhvcjc5ZGR2QWo3OVdC?=
 =?utf-8?B?VWlKblR4RVMzTXdUMys5c01FbVJUdXpMZzNsZTVVcWFYWmVJeXROVzhqaldk?=
 =?utf-8?B?NVhMdnFwem1MY1BHYW9Zb3Y3S1o0WDd3M1BXc083Y001aVc5NWJVQnpWM2pj?=
 =?utf-8?B?MUFPaGRmV0N3RUo5MGNLbzF6NVVXQllBVU14NnRodlZidVNreUU3eGRqSEdR?=
 =?utf-8?B?T1VWS3cvMEx1cjR5andxVngweGo5MEI1ejN5Rm1qOWN2QVN4cnl1UW8vOGNs?=
 =?utf-8?B?ZkpMSXVjeWxwWTg4a1J6REYvSkFKeEZrQU9tblhuSUVjOUhUUDQwOEk2Szds?=
 =?utf-8?B?emlJbUpZTWRHL0JaMVROYkNaUEwwTzJEZHJ1WUNWellnazRoR2xMbVlYWVZp?=
 =?utf-8?B?RWNZZ1NPUGxnUWpvK0hwZTE3YUU1RjQ0OGowZHpHTXpkYSs0MkNTSzFiOVVs?=
 =?utf-8?B?UnpTUXdSZmRyTDNuWnQybXorN1VhZzA1OGpOUERaL1NFTUpSZ2Zwdll0cWNz?=
 =?utf-8?B?aFdheHNvYXhXa0c1RExXbi84SUFGNjJwZjFhTU5JS1pGR1RBMGtIVVV0L0ky?=
 =?utf-8?B?ZUlHZlM0cHY0YkZxdFhtNEs3M0twNlgwbXhad0xHd29pM1Mzc3J5d3Z2Lzcx?=
 =?utf-8?B?aERjcjVUSDlHUDdxNXBsUUZJemdkNjJsTG9HWkluSnpoUTVkNzlETEJNc0p5?=
 =?utf-8?B?RHBuMUoyNHJxd1YwL0NGS2hyVnNFQ01Xd2IzRHF0ekpoMkJ6a0JDekhQUlNq?=
 =?utf-8?B?QWFiTmdobzVkZy8xWWRCcXUwUFY2Y0c4Zk90THdzUjlyYkNYM0VBTGpmRlVG?=
 =?utf-8?B?TW5pZ2dVRmUwcWpZMVRYZzZPZ0J6SlpvdG1iTVhsbzBDOTFpeEhvV2FRZzcx?=
 =?utf-8?B?aGJGY2o4NDNxL1BUTlZrZXRvUzlqSndibUdSZ0RYTE1tUlpoUzhoN2R2dUox?=
 =?utf-8?B?OS9tT0x4NGxHU3o0cTF1OXR3cTIxaVc2eHJNMDNnY1RnY1pvVGp2MHpYRjUw?=
 =?utf-8?B?dXFQcjF4N2dlZzdBUnFDZHl2SUduTXJDSDNnWWt5YXdzMkUrQ0FNUit0ekxI?=
 =?utf-8?B?VlNXQmYvSXZwbkFmdHNNMjEyaVhwVTZyUVA0SVJMTm1QODV2YVo2WFh2TjB1?=
 =?utf-8?B?a0Eya1MzNTZEeDI0WmJyOFduQzBtWC9LWSt2dWxVaXY5OVJhZlhHam9GSEM5?=
 =?utf-8?B?WE0rRlNoRjVlakZnejJzeGFvZWtDRkRyY2l2SGNVdlZ2R092TC9NNGNRUGNJ?=
 =?utf-8?B?THBRWFFhRFJRQ2plNlowWXRrZm1NWlJRN3JVWndiUFJyRWRuUUFkUkgzQUV0?=
 =?utf-8?B?dVN5VEFDR1V0UEowaGt3SklJVkFidHk4UlVZZGVoYzRzME8wQlZ3NWVPWTRW?=
 =?utf-8?B?anZScE8yK2tBWG00c2FKWS82eVBaQVFrcXo2STdSWSs0emg1aWNLNVorWHpW?=
 =?utf-8?B?YU1HUk9GZ0MzcENyS0NZYWtqbERueFhlT0t5dU1MemNmOG5XTXlSY1prWE84?=
 =?utf-8?B?M3B1emR2Q0tiZ2Y2QzV4ZklyVHRwSjVMelpteG10YW9PQTVyZ2ZVc0tmMlRt?=
 =?utf-8?B?Rzh5VDBWN0NyUThzajBoVkFMc2ZtSTJXcDdZY3dCaURBSUZJOEd4ZThMelo4?=
 =?utf-8?Q?+6csABUYlzs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWZDQjRHMlBtRmhGekpxMU5oT2NWNHRwU0dzMXpEWXJvMTI4MThCbDZ3Zk1F?=
 =?utf-8?B?dWIvMkZwNUUvQ2x0VXIvL3FFZldFTnpBNDBBNjk1ZmtJNno1TjBQeERqSVF1?=
 =?utf-8?B?bDVKcW1yMk1wMW9hblNiOGFSdUlzMUxadStVdWtLWnl0VHFTYkNibERrR2Rl?=
 =?utf-8?B?SzZ5YWhjb25hb3BVMEpyRUl6bEJmNlo3RGVGK21zcFRKYzRCYzdHZDVUMENm?=
 =?utf-8?B?amdhcXFaQVg5WnZVRHRkS0crQm41ZGZhNGZKNUlEaUg3Qnd3Y2JtZHcvQ2pR?=
 =?utf-8?B?MWt2bmlSSzlGZjR6cXhhUjQ0dEhTNEdXM3c0emtWZWRvMC9odWJUL05MUTMw?=
 =?utf-8?B?MlJOYXJSZ1ZOOEFQaVBqUzloZ3BJcFNQUm1SemZRSWp1UzlhUTJVUlVXemUv?=
 =?utf-8?B?Tng5enBsaC8yUjlidjd6WmxQYksyREZXSkdpVUFGSjRDZkxya2M5R0p4Nm9Y?=
 =?utf-8?B?dVhzcTA2YW85ZUIwejEzYlFqM2N6REFrNlVsWWs1U1c0dXJ5Y2VzMmtaalli?=
 =?utf-8?B?S0IxYUtSellpbzN6RFk5UzNSb2xKWFZaNk5ubklNNDUwV1FYT2FEWG1kcitz?=
 =?utf-8?B?N05HSXhrTXBSU2s4TEE3Smpld1d1TFJDTGl3N1N2T2hISnJzNk1nOGRCaG5w?=
 =?utf-8?B?WXByOUxTNS90aE5uVG1IMm1TY3R1bW81cTlGNkxORTYwUUdURk9IdWt6aDkw?=
 =?utf-8?B?L2FwcTBORnFSRm9wbmV6eUxZaWkvbDM1dXVicStPMS93NmNmRkNrOXd4OE4v?=
 =?utf-8?B?VUl6QW4ydjc4TkZkYlFhcmZvYVczTnZxN3F3Qk93UDRQMHF4NC9MNmdoeER2?=
 =?utf-8?B?KzZnVUhWUHRhNlpqcE5aYVFFbVpFNEF1RUFSSFhiR1EwWjNVL1FvNmRYTWJX?=
 =?utf-8?B?WHNjcDFjKzZiQnVsMkhnNStpNHQ3Z0cwejJBVGN5bnBwUXlwUDc0TEwwZjJV?=
 =?utf-8?B?ZTNQYzdwSzNsTDRzUENmZm1KV1IzSUlNazB3b3ZyZGxHQTlqOFNkTFVyYmFl?=
 =?utf-8?B?bWw0dkdqZHk0TTFsV1B4YXVFK2dCOW5wK21HTG1LRUZmWjJ2ZlhzMW1uTEVa?=
 =?utf-8?B?WGhEcFJaQXVvOVNBbmN1bzlxcmJGd3VmVkZUVzV1SVJMaE9IakdvandzaTB5?=
 =?utf-8?B?VVlRcEczQ29VNU5ST0tEOWU4N0RXOUZaY0F5T1FNZGcwVUxhQzBVcGt5a3Zm?=
 =?utf-8?B?UW5IRUVyRCtHT0ZqemJPaEFQYlpRekpjSFdWT01zM01qVDhOcEVFa0VUUDV3?=
 =?utf-8?B?MEwwSmVXRzQxZTFKWUZCRWQ0eGo1ZTloZjFVSndCMWZha2RCZ1V5ZFF0NGZQ?=
 =?utf-8?B?SEJiOXBUZXY2WmlWSjhsZkw4azJuejZXNU1rSzRua2t3dHJOOFJkVUF1QzE4?=
 =?utf-8?B?RFRUY2Z4SVlRTU9kM1JJNGkwbkpqNkI2eGd3ZFpNVEZPRzRPVElQS0w2REhp?=
 =?utf-8?B?cVBzNUQzOWlnaDdHSkRFUjNHd01QYXRhNzhhNk5SQUo0dkIrUERBa2NFU000?=
 =?utf-8?B?bGpCMFdhNlFrbld1NlhkbUtoNkp2bGhXRCtuZzYzUEsxcHR5TEVuRWRxcDFI?=
 =?utf-8?B?LzNaTUZhNVAreTduNUlOMlBRc3pRRTNCRnQ2UWNZUkh3UUpCb3E3WTNtRlpv?=
 =?utf-8?B?NlBvNTk1MklaK0ltYzFmbjVObzdJN3M2RFNWbUpGUGN2OWQwZFBGL3luSjl4?=
 =?utf-8?B?NGQ2d09ra05LNnVpVURSNUlJeFBRSnEyWEk3Mk52czNtYTBMT2lCalJJWEph?=
 =?utf-8?B?NDZZU2JPY3dCTlRhbUZtVkJ0MlBMdmhCTEdOQTd4V0V1aUxFSlV5WkNVYkxB?=
 =?utf-8?B?SWxyenRnK1pya1pSeEcwRExCNUJ1WXY2N25EcDA4d0RldlVVcU11NkxkZHIw?=
 =?utf-8?B?czM0Z0hXUEVTVTRlelU2VnRadUJkUm5YMjBxVG5wOEZkMWxuMWxFTDVJeXJY?=
 =?utf-8?B?RUVud2VNdWVBZHliRlNZM2EvNmladU5lVFBJU3Z2K0M3ZVBLYncwcCtwMHpy?=
 =?utf-8?B?bnc1Zkp0THpxcGZoVFJlcFhPVFFsNXdON3hibkpwK2lXWk1oNUpaZ2dZenRu?=
 =?utf-8?B?NzEzSVhhUlMrT2t0d25tMnJCRXIrNHU3dXRUNUtRa0pnU0R5M2tBMitHSW9m?=
 =?utf-8?B?TGdXWnUvazZveGtJZmtpTkhPdllKcHVUZTl2WDVNVy9pQU93Y3lZSnpxWkRj?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d56c8a0d-56c0-4822-6f10-08ddd06f380e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 20:17:05.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4opI4ucuIZ+4cbptSYR7sURTNUiiGFbI/CBT9xZ75y2fmf+56mGIWfsKvmSiFXlhgI4jf52rptxPoi9zTOQWC2cifhRJv4xxlrYuxCj+LPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7002
X-OriginatorOrg: intel.com

Chao Gao wrote:
> On Tue, Jun 03, 2025 at 07:44:08AM +0800, Huang, Kai wrote:
> >
> >>  static int init_tdx_module(void)
> >>  {
> >>  	int ret;
> >> @@ -1136,6 +1209,8 @@ static int init_tdx_module(void)
> >>  
> >>  	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
> >>  
> >> +	tdx_subsys_init();
> >> +
> >>  out_put_tdxmem:
> >>  	/*
> >>  	 * @tdx_memlist is written here and read at memory hotplug time.
> >
> >The error handling of init_module_module() is already very heavy.  Although
> >tdx_subsys_init() doesn't return any error, I would prefer to putting
> >tdx_subsys_init() to __tdx_enable() (the caller of init_tdx_module()) so that
> >init_tdx_module() can just focus on initializing the TDX module.
> 
> Sounds good. Will do.
> 
> btw, I think we can use guard() to simplify the error-handling a bit, e.g.,

In cleanup.h I wrote:

    Lastly, given that the benefit of cleanup helpers is removal of
    "goto", and that the "goto" statement can jump between scopes, the
    expectation is that usage of "goto" and cleanup helpers is never
    mixed in the same function. I.e. for a given routine, convert all
    resources that need a "goto" cleanup to scope-based cleanup, or
    convert none of them.

...because it leaves a minefield for the next person to keep a mental
map of the cleanup scopes vs goto.

In this case all of the cleanup functions take a pointer argument, so it
is a straightforward conversion to track those individual cleanup steps
in local pointer variables with something like below (compile tested
only).

So either convert the entire function, or none of the function to scope
based cleanup.

-- 8< --
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..029db95982f7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,6 +28,7 @@
 #include <linux/log2.h>
 #include <linux/acpi.h>
 #include <linux/suspend.h>
+#include <linux/cleanup.h>
 #include <linux/idr.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
@@ -225,7 +226,7 @@ static void free_tdx_memlist(struct list_head *tmb_list)
  * ranges off in a secondary structure because memblock is modified
  * in memory hotplug while TDX memory regions are fixed.
  */
-static int build_tdx_memlist(struct list_head *tmb_list)
+static struct list_head *build_tdx_memlist(struct list_head *tmb_list)
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid, ret;
@@ -251,10 +252,10 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 			goto err;
 	}
 
-	return 0;
+	return tmb_list;
 err:
 	free_tdx_memlist(tmb_list);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 static int read_sys_metadata_field(u64 field_id, u64 *data)
@@ -306,8 +307,9 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
 	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
 }
 
-static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static struct tdmr_info_list *
+alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
+		struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	size_t tdmr_sz, tdmr_array_sz;
 	void *tdmr_array;
@@ -323,7 +325,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
 	tdmr_array = alloc_pages_exact(tdmr_array_sz,
 			GFP_KERNEL | __GFP_ZERO);
 	if (!tdmr_array)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	tdmr_list->tdmrs = tdmr_array;
 
@@ -335,7 +337,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
 	tdmr_list->max_tdmrs = sysinfo_tdmr->max_tdmrs;
 	tdmr_list->nr_consumed_tdmrs = 0;
 
-	return 0;
+	return tdmr_list;
 }
 
 static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
@@ -888,9 +890,9 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
  * to cover all TDX memory regions in @tmb_list based on the TDX module
  * TDMR global information in @sysinfo_tdmr.
  */
-static int construct_tdmrs(struct list_head *tmb_list,
-			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static struct tdmr_info_list *
+construct_tdmrs(struct list_head *tmb_list, struct tdmr_info_list *tdmr_list,
+		struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	u16 pamt_entry_size[TDX_PS_NR] = {
 		sysinfo_tdmr->pamt_4k_entry_size,
@@ -901,11 +903,11 @@ static int construct_tdmrs(struct list_head *tmb_list,
 
 	ret = fill_out_tdmrs(tmb_list, tdmr_list);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list, pamt_entry_size);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
 			sysinfo_tdmr->max_reserved_per_tdmr);
@@ -919,10 +921,11 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	 */
 	smp_wmb();
 
-	return ret;
+	return tdmr_list;
 }
 
-static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+static struct tdmr_info_list *
+config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 {
 	struct tdx_module_args args = {};
 	u64 *tdmr_pa_array;
@@ -941,7 +944,7 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 
 	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
 	if (!tdmr_pa_array)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
 		tdmr_pa_array[i] = __pa(tdmr_entry(tdmr_list, i));
@@ -954,7 +957,10 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	/* Free the array as it is not required anymore. */
 	kfree(tdmr_pa_array);
 
-	return ret;
+	if (ret)
+		return ERR_PTR(ret);
+
+	return tdmr_list;
 }
 
 static int do_global_key_config(void *unused)
@@ -1065,6 +1071,34 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 	return 0;
 }
 
+DEFINE_FREE(free_tdx_memlist, struct list_head *,
+	    if (!IS_ERR_OR_NULL(_T)) free_tdx_memlist(_T))
+DEFINE_FREE(free_tdmr_list, struct tdmr_info_list *,
+	    if (!IS_ERR_OR_NULL(_T)) free_tdmr_list(_T))
+DEFINE_FREE(free_pamt_all, struct tdmr_info_list *,
+	    if (!IS_ERR_OR_NULL(_T)) tdmrs_free_pamt_all(_T))
+DEFINE_FREE(
+	reset_pamt_all, struct tdmr_info_list *,
+	if (!IS_ERR_OR_NULL(_T)) {
+		/*
+		 * Part of PAMTs may already have been initialized by the
+		 * TDX module.  Flush cache before returning PAMTs back
+		 * to the kernel.
+		 */
+
+		wbinvd_on_all_cpus();
+		/*
+		 * According to the TDX hardware spec, if the platform
+		 * doesn't have the "partial write machine check"
+		 * erratum, any kernel read/write will never cause #MC
+		 * in kernel space, thus it's OK to not convert PAMTs
+		 * back to normal.  But do the conversion anyway here
+		 * as suggested by the TDX spec.
+		 */
+		tdmrs_reset_pamt_all(_T);
+	}
+)
+
 static int init_tdx_module(void)
 {
 	int ret;
@@ -1088,70 +1122,49 @@ static int init_tdx_module(void)
 	 * holding mem_hotplug_lock read-lock as the memory hotplug code
 	 * path reads the @tdx_memlist to reject any new memory.
 	 */
-	get_online_mems();
+	guard(online_mems)();
 
-	ret = build_tdx_memlist(&tdx_memlist);
-	if (ret)
-		goto out_put_tdxmem;
+	struct list_head *memlist __free(free_tdx_memlist) =
+		build_tdx_memlist(&tdx_memlist);
+	if (IS_ERR(memlist))
+		return PTR_ERR(memlist);
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
-	if (ret)
-		goto err_free_tdxmem;
+	struct tdmr_info_list *tdmrlist __free(free_tdmr_list) =
+		alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
+	if (IS_ERR(tdmrlist))
+		return PTR_ERR(tdmrlist);
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdx_sysinfo.tdmr);
-	if (ret)
-		goto err_free_tdmrs;
+	struct tdmr_info_list *tdmrpamt __free(free_pamt_all) = construct_tdmrs(
+		&tdx_memlist, &tdx_tdmr_list, &tdx_sysinfo.tdmr);
+	if (IS_ERR(tdmrpamt))
+		return PTR_ERR(tdmrpamt);
 
 	/* Pass the TDMRs and the global KeyID to the TDX module */
-	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
-	if (ret)
-		goto err_free_pamts;
+	struct tdmr_info_list *tdmrconfig __free(reset_pamt_all) =
+		config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
+	if (IS_ERR(tdmrconfig))
+		return PTR_ERR(tdmrconfig);
 
 	/* Config the key of global KeyID on all packages */
 	ret = config_global_keyid();
 	if (ret)
-		goto err_reset_pamts;
+		return ret;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
 	ret = init_tdmrs(&tdx_tdmr_list);
 	if (ret)
-		goto err_reset_pamts;
+		return ret;
 
-	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
+	retain_and_null_ptr(tdmrconfig);
+	retain_and_null_ptr(tdmrpamt);
+	retain_and_null_ptr(tdmrlist);
+	retain_and_null_ptr(memlist);
 
-out_put_tdxmem:
-	/*
-	 * @tdx_memlist is written here and read at memory hotplug time.
-	 * Lock out memory hotplug code while building it.
-	 */
-	put_online_mems();
-	return ret;
+	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
 
-err_reset_pamts:
-	/*
-	 * Part of PAMTs may already have been initialized by the
-	 * TDX module.  Flush cache before returning PAMTs back
-	 * to the kernel.
-	 */
-	wbinvd_on_all_cpus();
-	/*
-	 * According to the TDX hardware spec, if the platform
-	 * doesn't have the "partial write machine check"
-	 * erratum, any kernel read/write will never cause #MC
-	 * in kernel space, thus it's OK to not convert PAMTs
-	 * back to normal.  But do the conversion anyway here
-	 * as suggested by the TDX spec.
-	 */
-	tdmrs_reset_pamt_all(&tdx_tdmr_list);
-err_free_pamts:
-	tdmrs_free_pamt_all(&tdx_tdmr_list);
-err_free_tdmrs:
-	free_tdmr_list(&tdx_tdmr_list);
-err_free_tdxmem:
-	free_tdx_memlist(&tdx_memlist);
-	goto out_put_tdxmem;
+	return 0;
 }
 
 static int __tdx_enable(void)
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index eaac5ae8c05c..6d3f997c7fe8 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 #include <linux/bug.h>
+#include <linux/cleanup.h>
 
 struct page;
 struct zone;
@@ -239,6 +240,8 @@ static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+DEFINE_LOCK_GUARD_0(online_mems, get_online_mems(), put_online_mems())
+
 /*
  * Keep this declaration outside CONFIG_MEMORY_HOTPLUG as some
  * platforms might override and use arch_get_mappable_range()

