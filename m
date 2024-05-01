Return-Path: <kvm+bounces-16295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE10C8B846A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 04:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 666BB284854
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 02:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B0F1F5F3;
	Wed,  1 May 2024 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bS2RnSm+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024EB1BDCF;
	Wed,  1 May 2024 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714532208; cv=fail; b=L8EUJhdK5SuY3X4syMbyLeSQZNhHK8yYSg8GvJUzPfN7e5uNowVXOE0bmq982DE3ZBubxwhT6Bd1oOqYw61g/sJ9JVF5bL6ULMS5zq8np83NM4Hcn+LulqqJQzV9zuy4m6o9AcM0f3RHFeTdnchKN7PDeLHF6aMTeRuvowRcvgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714532208; c=relaxed/simple;
	bh=M0y8DZfW1W3U6tlZ17lS6rNqSHlej6sRJEsPWhqxOKk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SCYtDp8YgnNuwkdPn1IDgArzL/GIKHKzleD6i6e74DXUEWapWz0kjo9YnogzgQyoFVgGCZux6+hsMho0tEkZSwv7earg/mL4B2pI2wQR1vP8gHc8RxrRcyKu0H6RWoXLJiD4oMD/DFcWWOvYWBQhi4sdSzwiYFqa13A852eN1SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bS2RnSm+; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714532206; x=1746068206;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M0y8DZfW1W3U6tlZ17lS6rNqSHlej6sRJEsPWhqxOKk=;
  b=bS2RnSm+e8s0jhZ1bQuz+wQ8b3Chzb/x6wPVczLJNBYhntHqiZVYkreY
   kNArfIZmHv1Q+TcEjX0NbZOFMeGIViqHONio45KTEwp+m+zDELf3ER+OR
   88cvKByvueNPJywKisy/cm8KveXsjgRwlBpNrBe0zWXNqAdPUD8eAKGOs
   z0ZZYi1AYC+7dzuR1z9iWbUkk8SaQYnYD2CFJTUro1GGjGh33qj5JNUGU
   ZP+9KcgywEvEhuDgYe8d37R95hIpZWIfT+FntOANB4M4fkPYeoapyi2M4
   h7opDKvMu+dO2DUNdj60UFyHC6JkKhmmTd9YunkzFZ0g16N97XTzlJBmB
   Q==;
X-CSE-ConnectionGUID: Uw6MONfiQTeTvPAbtQAvCw==
X-CSE-MsgGUID: xsuWnPSyS76+3WfQjyiH4w==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="20810509"
X-IronPort-AV: E=Sophos;i="6.07,244,1708416000"; 
   d="scan'208";a="20810509"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 19:56:45 -0700
X-CSE-ConnectionGUID: cAAiQKs2RMihfT+qm/nPvg==
X-CSE-MsgGUID: ZK2Hhgj1RAmawFXpD4jb1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,244,1708416000"; 
   d="scan'208";a="26750164"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Apr 2024 19:56:45 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 19:56:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Apr 2024 19:56:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Apr 2024 19:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0SSqFohSpAf8r6rlzVjoAY4JK+80+ifQsqD9xp3b3TWurwFSNv3yQqIhzP7bbbq3D6TNkk8OKCNplB/OjbLlO/6CtMHZGZ/AYna2ofDOo3ANTdR86zjNTHlcLIMER4xvITSoTrR3bP8SgtV9BL7sp9LPmSvcSVXLGX+YYyHB/ssaJJA6KgYOk/pFOkxCIonskwmMkVSm5cMvwnjxAJl06YYnUjZfMvmXlX9L4AgjxNgP2H4uk6rE7+Zc7L9AEEZ9Ei93ywaQNvpKYUPggXP4IfmJ5u5m7+E0Fr57Gny1RglCPaRbN7chWYpkdS9eDNKREsBZoWA8Y9yXYbyECOx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aU9WGqYJjBOtn1iys5S4xO7DEV/Hl7ubDoJ+Tnoa+Ac=;
 b=fm2pW4y4rE8CRQIeqKWKlSn+Fe3Ij9cRJulrg0125aS0i6t+zPmo3IWrynRJZt8rR7JdQa23KlD3Uu+DhOG71yOHh0ArRaYQ5fAy7keBQStzQY5HAMla/y0Fc/Lv+I0gN2NePcWB6X4sglqx0XN/HqU8tBgTmd+2LjEWyaoL4EoZMp/lhCt9N+xySnpdxgifCikjgEY8q7XZY1ViGA2BjeCVwguZystRrEIONYqk8XD9zHJpkjqxc/Jwg57wCtA7R89aCrLJITkkvrVrN22ukwqnSJfvmb+F3DKvoc+GtOb7cvI3Cm2NYgPZKzdUrXG7TN3len9djHnmE1V0DK6IEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8502.namprd11.prod.outlook.com (2603:10b6:510:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 02:56:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 02:56:42 +0000
Message-ID: <d143b41e-e8f9-4f89-a571-6771ff538aa7@intel.com>
Date: Wed, 1 May 2024 14:56:30 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, "Bo2
 Chen" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com>
 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
 <ZiqFQ1OSFM4OER3g@google.com>
 <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
 <Zircphag9i1h-aAK@google.com>
 <b2bfc0d157929b098dde09b32c9a3af18835ec57.camel@intel.com>
 <Zi_93AF1qRapsUOq@google.com>
 <2eab6265-3478-45db-86a5-722de6f39e74@intel.com>
 <ZjEYqCgtt4ZgVKth@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZjEYqCgtt4ZgVKth@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:303:b8::6) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: 9430df2c-52a0-4784-ff3c-08dc698a543a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K1V2NXArQXhkdmtYY0gwRjlXRDBVcUVVUnBPWXhkcHJMZkM0MTd6dG5HdGY3?=
 =?utf-8?B?ajA0V3BvUENaVVFNZ3JwRklkeFFXTlBGRU81VHdQcEoybEFMM1BkbTVuRE1M?=
 =?utf-8?B?RlJOQkJWTkE5YS9nREk5SVJneDVKc0ZmVnFhZDBaT0VxdVNUalJKUm9ZbGNE?=
 =?utf-8?B?VHlhOHB1cXdGc1NjM1hremd2OG5qOUhUaU9PY0hoQUMwM2hqZ2c0ZFlTeStP?=
 =?utf-8?B?bzd1OXFGY1hReExvdGE2Unl1T08xY1RLaTUvSVhFWk91TllZejNlb3RwZHAy?=
 =?utf-8?B?c0xLT2xGRDh5bFN2cCt5WW5SOVNhNTFaQ0tXRTZ6YUVydGV3REs5QmlqZW14?=
 =?utf-8?B?dFdWZGJ2bFd5ZzZxcisyRFkrZXVGZkl2M0d4WktXWTIvVU9Xdk9OL3AzTFEv?=
 =?utf-8?B?a2drenp0T2R0aUJiWWtJZThMYTJuenFlMmt0RWhJOERYZnY2L3F1MWVRTDVL?=
 =?utf-8?B?amF0SWtFNGU4Q1dLSVVSbDZoclM3VFEwcGoybkhIcEI5QUMzd3NIR0RXdEho?=
 =?utf-8?B?U3JxNTc3U09kaDFJQnk1SUNKT3I0Zk4yM2s4ZHRyVUJaa0dwYVgzZCs3Yzhn?=
 =?utf-8?B?cld3SElMY1JBb2ZZd3JOSmp6MFNJOWE3N2xsN1dzRUltOGNET0Z3R3kzcFQy?=
 =?utf-8?B?Z0VVbEcvTDcvZEo1U3Z2Y3piRkZ0bTBiTmZTZUZiWnU1b2dxR0VtQVlDNEx2?=
 =?utf-8?B?NFNZdHdPS0ZmVXRvUWVLRFhnWENvaGx4NUg1RTV6Q1BqdHAwNlVhakJSaXFk?=
 =?utf-8?B?QWkrckppbWtMTTRaTHRaS0VkVUFpb2h0c0cwZEhiQk5nME9Dc3ZjcXdPNWgv?=
 =?utf-8?B?dzZyKzZQek9sY20yT3ByM0JkWm9odkN5emFFWHRIK3B4M2ZPQW9qMkhqVGJh?=
 =?utf-8?B?c0Fuazc4TG15WkpLYjdwcmRKUnczNVQ2QUR6c0RRU2hOYTZhZW5NTmpHQTVS?=
 =?utf-8?B?ZFZvS1ZFT1NIbHlNZi9IcXVteDI2NG9SQnQ0L1JrNldYVEluTGpkazMzOHEv?=
 =?utf-8?B?UEQ5OHJOOVQ3L1paRzRMSi9tcklFaDhEVnpBcERxN0lLUERTeTl3amZFNlZj?=
 =?utf-8?B?WnNjZ1J0YlByeUFlTlFxdGhSWHpRNy83ZW4xWENnUHNuTzJSaHhoTUtaUnBm?=
 =?utf-8?B?bEkxdmptK00vc2o5TTNPWEZEcjN0TENjUjZtMFhZOVdBZVNIL2dNN0ZueC92?=
 =?utf-8?B?SjhWaWZXNVk4dFpKK0plUkxLS1lSeTJUeS9tYkJFc1Arek1rOXNhYk5ZaEN3?=
 =?utf-8?B?ejZrMHhuVTgyeHdOU200VWtZTkdSQkZiQ1hLcERlbVZueXhmbllkT1FhMHho?=
 =?utf-8?B?NEdndEVOaVRnY1BsT3RHWTJMSkw1UjFhM3lub1A1L2F0MWhNbFpzZW5zZVZm?=
 =?utf-8?B?U3N0RzNjSTVFNFBndUpEaS9qUmJheVlvR2ErdEZ6U1VPWUQ1b3dVOTNUWXhq?=
 =?utf-8?B?T2lKS05lYThrMGk3YStjWVVXQ0ZSRElzMkNSS3ZIVXhkeWdpWlB4Sis2TXJJ?=
 =?utf-8?B?WlVXRFBVZjRUZEFRenc5emo5Z2dLc3lmMUVkbXZCMDA3Y1BrQ1lubjh2enJi?=
 =?utf-8?B?YUxUYXZFZ0N1aVZIVnlLdGFhYlZ2a2ovZnk2eU1MV2pPcnAvcjBWMVY1QUJT?=
 =?utf-8?B?USs1WlpYWDMzdkhraDJXaUJndTIyOENnWS9UYWNWQ25lR1FiMk45eG1BSzk0?=
 =?utf-8?B?bjNVWE1MUWNQTGR2RHRySnk5RmhqczRwK1JkbUUya2l4Si9RelYvWlRRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUZ0WkYvREV6TFVBajA2ZTNSd2ZWRFpOSmNxcUpXUTlrSjVabXoxMU94VERa?=
 =?utf-8?B?bDJiRU84WndhOFQ3TkMxNitoT2p0Zm5PaHBRQmFzNlptMlV4RENnZWhtQVhE?=
 =?utf-8?B?K05tc1J5RE9ZcTkwOG5JdGxTYkNhdzZld0t6anpXQ0YyMGViS3BNdy9IWHJp?=
 =?utf-8?B?YnUvSE1vQVR5ZE0yV0FpVkI0aVg0Y09ZNXV1dFZzREtDUmVQQTRUZUxEOTBk?=
 =?utf-8?B?TXhjdlFKZkEyNGtkd3RQQmtmM1NaaitiOHZKVVEvR3RzUW9ZRGJnWldTVG9O?=
 =?utf-8?B?cHhleW02cUx6MnhkWDFJT1hIWjlLbWJ4UlM1eUhrZURDTjlGRy9iQy95Q1NR?=
 =?utf-8?B?YlNiZHpMbUpMY2cxTFRHT1JKYnFiNERuaW9JZ0tHUWNhSUwxNXV6dkhRWTlO?=
 =?utf-8?B?SU1TcWRSYUJkVTY2WGtXTGVpbCthTGlOUXlMT294OFhlUUN1N29DcldpRE5z?=
 =?utf-8?B?RjVoaDNQR2FVNnpCV2swekxNUWdYWkRxNFpnalQzQ2dHTVN2ZnEwS0ErOTVL?=
 =?utf-8?B?RWh5VVNVZUh6V3ZtejJDVElFeVloTmpDbjFUc2JsVWxlbUtGeWV6RHE4L0k2?=
 =?utf-8?B?TXY0Q0o1emRhd0xYeElWaUpPUUwwT1hsNk81UWZCSkVoWXdEd3FwUjhjb2VH?=
 =?utf-8?B?K3dxTTJyanE5MjUvZ2QzR3FUYVc1WUQvVEpiSGd5YkRSUVRhOFZ1S1N0ZC9x?=
 =?utf-8?B?eXZibG8xandtWmJwc0g0VWpWMThXZFdaMXVrQjlKV1BMY1VMcU0rRG9INDNI?=
 =?utf-8?B?M2kxZDBOcFNQcm9SN2haTVNzZ242OHord0Q3UVcydlU0UE9PeGFSTlR3anUy?=
 =?utf-8?B?eUVtU01sOVhJbXBqcmRJWk94TlFFMU9FcnZ5d0txTTRqd2RRTkZSNmI0SXRN?=
 =?utf-8?B?Sk53RDdZdXFBTC8yTXpIL1o1MlFpRWtaNUVRc0U3b2NLSEtoQ05zcGdFQzdO?=
 =?utf-8?B?RXVPUk4wVFBRc0RKZUs2UmVwa292MlMrWGpZTjVxRjE3S2JuVjBjRFh6cHhD?=
 =?utf-8?B?ckhUbGVpNDRoajlQbzR2Qm1jYklIamtkWm91WmxrYmNsckhDYmlwZlBEMFpV?=
 =?utf-8?B?RkMxeGdlbm5YT1RId1ExSzI1amtHNDFIK0QrQjRuNUhtOFUzUTBBdWVRYmxD?=
 =?utf-8?B?aklmK0pTekZMMVczVWFCMGo4WXdaNU9BdnNuQ0oxZ291UzBuc1BwdGNoYWw2?=
 =?utf-8?B?UG9WWHV6QUJUbUFMZFJSYnZ2VzVITzczYjRNNEtscUk4aUJhbGNYNXNqUjhx?=
 =?utf-8?B?ekN4Uk15N2pka1VZdEw4OVU2WmdsMDdScW55SVNGejVORlI5d0JYWDQ4ZU9T?=
 =?utf-8?B?YWt5T0ovYnlQYWJ3VEpDaVN2Q2JYWkc1QXUyL1k2YWdrb2pYM3UrUUR0Z0tM?=
 =?utf-8?B?VE9IbHY3alhOekJOenlzNUZhQW9KWjV0REFMNkwrU0s0OWt2aEZxWU5xcmhS?=
 =?utf-8?B?dTJaZDY0ZkRldHo1NllsVUMrTnRmMmFBTW1aRk1ld2dOZlY1TzNWOW9vWkJ1?=
 =?utf-8?B?eFB1bXUxdjh0RUZwR0ZkdlZvYVloMmRsWUNucmRRNktoSVlIdHpPeVorZUpw?=
 =?utf-8?B?Tk12MERlaEJpTklhTUlsbjE5Ri9Pd0RScE85a3lCTEg4WHlLMXpJRFl4YTQ1?=
 =?utf-8?B?TXd6S0NLQlFRWktzZVRuUW90Z2ZoVlNzaU5DWFltM1hKQUZPRjZvcVFEaTlD?=
 =?utf-8?B?UXJpS2pMS3M4NTYrR05rVFpPWTlpTVg5S0F2K1JVVVdqaDAyQ1BtWC9Fclkr?=
 =?utf-8?B?dnN1ZzZmK2tVdW9uSmZTQ3BhTm9xNGJRdm1ydVZlV01ldkUvUmhjeDdSSXAw?=
 =?utf-8?B?VFB2RnhLM25Ha2xpMUF5RkFSTmFNQS9Ra2RWSzlaVDJGTUo5Y2o4aDRBWXhj?=
 =?utf-8?B?VXNka21QeWUrNUpwSGI5Q1NRTW9BSDQ5YlZTbWRKTURYeWs2R05iNjhOSTdu?=
 =?utf-8?B?U2pLY1N4MERPZk55c1NjOGZTb1R0N1NPSzFSWVkxNlE4MjhxbHpKVVJTVkdo?=
 =?utf-8?B?VXdIVVJFR0pRMC9mVkowZWt1N3hwTEJFdmx5Vys0QkVaOWNEaUN2MXRDOWFX?=
 =?utf-8?B?bXV4K2dRaDFhc01rMkNGZE1qa2M3MUxXeVNtVU5YUGt6RW1xQjV2TlBHT21Z?=
 =?utf-8?Q?TuasR+LddRtjnBbBsGFBPxegm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9430df2c-52a0-4784-ff3c-08dc698a543a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 02:56:42.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sm8yxq2GXN24i1tsM0cxXlrqY3gTUtALry3qY/fDyhTRG4nwpbMj/HLXq7LTonNbwh93Ae6SkY9+z6KYSbv3Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8502
X-OriginatorOrg: intel.com



On 1/05/2024 4:13 am, Sean Christopherson wrote:
> On Tue, Apr 30, 2024, Kai Huang wrote:
>> On 30/04/2024 8:06 am, Sean Christopherson wrote:
>>> My suggestion is essentially "throw in a CR4.VMXE check before
>>> TDH.SYS.LP.INIT if it's easy".  If it's not easy for some reason, then don't do
>>> it.
>>
>> I see.  The disconnection between us is I am not super clear why we should
>> treat TDH.SYS.LP.INIT as a special one that deserves a CR4.VMXE check but
>> not other SEAMCALLs.
> 
> Because TDH.SYS.LP.INIT is done on all CPUs via an IPI function call, is a one-
> time thing, and is at the intersection of core TDX and KVM module code, e.g. the
> the core TDX code has an explicit assumption that:
> 
>   * This function assumes the caller has: 1) held read lock of CPU hotplug
>   * lock to prevent any new cpu from becoming online; 2) done both VMXON
>   * and tdx_cpu_enable() on all online cpus.

Yeah but from this perspective, both tdx_cpu_enable() and tdx_enable() 
are "a one time thing" and "at the intersection of core TDX and KVM"  :-)

But from the perspective that tdx_cpu_enable() must be called in IRQ 
disabled context, and there's no possibility that other thread/code 
could potentially mess up VMX enabling after the CR4.VMXE check, so it's 
fine to add such check.

And looking again, in fact the comment of tdx_cpu_enable() doesn't 
explicitly call out it requires the caller to do VMXON first (although 
kinda implied by the comment of tdx_enable() as you quoted above).

I can add a patch to make it more clear by calling out in the comment of 
tdx_cpu_enable() that it requires caller to do VMXON and adding a 
WARN_ON_ONCE(!CR4.VMXE) check inside.  I just don't know whether it is 
worth to do at this stage given it's not something mandatory because it 
requires review time from maintainers.  I can include such patch in next 
KVM TDX patchset if you prefer so we can see how it goes.

> 
> KVM can obviously screw up and attempt SEAMCALLs without being post-VMXON, but
> that's entirely a _KVM_ bug.  And the probability of getting all the way to
> something like TDH_MEM_SEPT_ADD without being post-VMXON is comically low, e.g.
> KVM and/or the kernel would likely crash long before that point.

Yeah fully agree SEAMCALLs managed by KVM shouldn't need to do CR4.VMXE 
check.  I was talking about those involved in tdx_enable(), i.e., 
TDH.SYS.xxx.

