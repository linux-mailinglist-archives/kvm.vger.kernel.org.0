Return-Path: <kvm+bounces-17711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 875C68C8D8C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 23:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A01B9B22647
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 21:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029081411C5;
	Fri, 17 May 2024 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DiSDEL0s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FCD1A2C20;
	Fri, 17 May 2024 21:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715980381; cv=fail; b=djS4dElZg3V7lwK3obrqiaPMnTyLpaHT9DsXYtzcjaKDrGzfSwHkkFdrjujNrlJxT6k8XJihoK78RAztsBEXnP62T/saiFT6wmNwG2sDH6x/jTRZO1g4Hy+e9GD+8J03DDdRpyFtXrqPZRW6PSdL5Fpw/Wh2iT6xuFg18wq8uME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715980381; c=relaxed/simple;
	bh=LwCTb70A7JuBh+nI27omrP+96T6Sm/zKdP7cGfTeCbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GD0VbZa43b1ljaqMHbzWSjaG3ryj0O0PId+FrpdMIWtJMSNDOIlam8r5fB1GKVZC1fMFCNttjVJWJCQ13pnTZCm2WUSl3NEABf3XiJoOi87ni6Fg20UmMuuIBAJL6JR0LxA32FMrzpw9SKTENgxDLUgaErLtE4CpqUzurU/pQCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DiSDEL0s; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715980379; x=1747516379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LwCTb70A7JuBh+nI27omrP+96T6Sm/zKdP7cGfTeCbs=;
  b=DiSDEL0smAb2Ep14ZritVOQtVb+spq2saTFBZW9gJcxl9bMUpmfpzmDN
   ymx/QjNfaVM6pej949k+m2vVBDPjk/jDcccwzBjVZW/y6kNb15m6JqpEN
   7ebI2KtcCTy97j3SgQDKJlAPKbqUrMf1b7DQffRjxFqpiYDazxx759R8O
   6Vsd/mWUCCnnzaS48RWjgOaFEWPcmcIm1h60U1jxjdDfbt+7NtpbFoxMm
   rF/Y6kEUTxzw9kvtSKZGdAHuA5xxg1XEgvbAOhM8R+YbuI/ePPpdJyckW
   hi8EeedwsrqMlrsbCZuoPIGLD4YI/6UXR6NnpfDz76x7UWTOFOMb+g8hE
   w==;
X-CSE-ConnectionGUID: 02ZWF2i5QnWtUid3NtsVWQ==
X-CSE-MsgGUID: nS2nlRTcTaKz05078+rkgQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12028828"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12028828"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 14:12:58 -0700
X-CSE-ConnectionGUID: 7r7VUVerQSmoFCdMr0r0Sg==
X-CSE-MsgGUID: 6IgFAALxQUCEcAZ4Oy1pcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="36476428"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 14:12:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 14:12:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 14:12:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 14:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enjy3pwnOEi5eFNnG2FHNg/MFt5/L21f1iwFOWhfOZ/4u/N1i33O0djW4GHbmSIRxmqt2qmCBolRAik6exCwXnsZMQVQY2CWFBA3ErC20AZ7w/qql4z2v1jPKik8+DlstSzHLqbS7cQ1jnA1zPNqDVt2eUu3IPBsbNZdZnzoqiAs4MVfdv1bIpceoTyLRMiPxnJywVmQp3pF6IIn0Q+Vlxtv6awQIZJ6R+Oh7kNoqSQJGJjEVg6bFqRvxIcqMB2BZzhRjK8a+n/vHv37G/2WFc5XfvQ94V0DHi7KWu83FxP9mXV4s6+CE4zL5X1LNwTf3wLsS51qGEbVVq6sebW36Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwCTb70A7JuBh+nI27omrP+96T6Sm/zKdP7cGfTeCbs=;
 b=TvbDxl6MQEgLqLe/oIYCdsM1csrUdctJw7wkTfHlM8jdr6S1icLGkdcJ/30ORQ1GMYSVwMokELL2+YXLmzPt1zrl4aWXWHKsHXd27btLh1VUHOErEI9+uPVGYQmMRK6IhscqxGLnYY2yVJJz1IfZeq8QuMqKtvxMh+kiMPpwIR5Y9CjtIlZGdnCY148b3W0okH+TEIdKspUGBFvh95SHRBc5zKbo3BU8DLK6aPziqWbF8UWlYZyUyUb4OUjvVXaiPqkPZJeiyREl9lmDgGSZDfY4rfCZW5m9ds+nzQdCWdmZkTLoJBO2RfJYN8oyb5xL3qHf66hGmC0cc/2Xfr44Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7011.namprd11.prod.outlook.com (2603:10b6:930:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 21:12:54 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 21:12:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriAgAAH94CAAAR+AIABbXYAgAAZCoCAABR2gIAAK4iAgAEZFYA=
Date: Fri, 17 May 2024 21:12:54 +0000
Message-ID: <9a28906fbacd81b5889ce3de874c171e343b2d48.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
	 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
	 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
	 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
	 <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
	 <d9c2a9b4-a6b8-4d29-9c22-ebdce77f3606@intel.com>
	 <240f61b5da5015a8205de414a87c3c433b1c09a0.camel@intel.com>
	 <e31f0793-c939-4018-9c3b-041aa8800515@intel.com>
In-Reply-To: <e31f0793-c939-4018-9c3b-041aa8800515@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7011:EE_
x-ms-office365-filtering-correlation-id: e6640a74-11da-4d4e-b701-08dc76b61e51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dWtIUWJqTm96WGtxZnZqNVJEQ0VRRHh3Rk9pbHB6bXA0SG5jVHc0aFViNEV5?=
 =?utf-8?B?cjVJTVpXQWsxMFhydFlTMGhFSjhSVUtHRXRVVmZSbi83YUJQbmtDWnNmZkF5?=
 =?utf-8?B?clJPZjJ3ekFrMHcydmhJazNqQzJObU84ak5NTnFlYk1hbGVkeVVNbjBLanZH?=
 =?utf-8?B?cVF2a3VWMkVyM0o5UjlIdWR5T0sxeTdaQ0MvOWNTbnFHL2VEQlFwcnFaeGpD?=
 =?utf-8?B?Y0RBMDRwNDRPdVFBOEVOa29qZ1d6VTJHaEVIUHFpOTlYKzgzYVZnUTBTUFZj?=
 =?utf-8?B?NlJnN3dYZC8xT2NWZndaV1lwdDc2WDcyaVlvUW1MaTBON3JIVXN5eU12cHF2?=
 =?utf-8?B?QlZqMFZoeGlMVWRXRUdmQ2FSZ3pIQjFSTjg0Ync4ZHJERXdIdjh4YSs2TlNH?=
 =?utf-8?B?dXRLbXgyMUl6Qi9oR3I3V240dUxkNVhkVFJsRHVrSS9nZTdXSGNYbEEyZE5M?=
 =?utf-8?B?anVQM0QrV05nWWFLZVhkc08zeUhtaVgvbXZuczFaUFhQWlgreGVINUlCc01k?=
 =?utf-8?B?dzdiQTFaUzR2SDFHWUNzbHZCV21ZMTZjZ2ErNWlTb3grbi9UL3JDUUFPTEgz?=
 =?utf-8?B?MWdCanIzSXI1YmhtdERwVFYxUGtlaHZaZkxPNGVBRzI5SzlydktQNDlJVVNE?=
 =?utf-8?B?WWtDaE5QYlJYeTFaUk9HWUpSM1cwNkc3cWNXbm9TaHg5VmZqTStTMENXODYw?=
 =?utf-8?B?WW01ZndweVFrZTVxOWx2d1VMcUFMUGpKRXI0N0VpVEhyNE9EL2RSOUprZyt4?=
 =?utf-8?B?ckdaNlFKUHlOLzUxeG9JTjQxdXd1K3ZFL2RqOGJ2SGF2cWIyMHdIR3NFZUIy?=
 =?utf-8?B?cTJ6Y0NHNDFkMGdPcnV3TlhieVMvbjR5bCs1MUNtNHcvdEhtaWMwMFVWN3kz?=
 =?utf-8?B?c1l0STZ1OXFmRUdHZlY4M3dFRFg1cE44b2ZwbnhxVlBqSDRkcDdidHZ3cXlj?=
 =?utf-8?B?Vk1rcjg4a1BzRGpuVjVURmlwZnRCaXQ2dmhoeHhGSDFaR0VWOXAweTBET1Zo?=
 =?utf-8?B?blR6ZC9md3ZQQ1hwaXppZ25GUVVzdHlHRm9OR1Q1WWs3aTM4YXRoZmFJYUxF?=
 =?utf-8?B?R3ErbGFZZ0ZQYUdxL0ZybmNRU0RVc0ppcU85VzdQaVNGYm00c2RPMDJpQWQw?=
 =?utf-8?B?cFZObFFycXhTRGpHaGJtdHRRVHlOQnR5ZVFOMXZJbVpOQ25NNWl0c0Y5bmNv?=
 =?utf-8?B?LzluTnBlWm9wVVJsT0NZOWhEZ0NEeGNWYzk1bUtTWTIwSTBvdktNWm9EL09L?=
 =?utf-8?B?NXhiT0tVNGJoY0o0SU1nUGg1SW1jcE1vdGQ0bXFodWNyZVlIUHdXTHhHdWlx?=
 =?utf-8?B?V2liOG5QY0dNRnJrOEhabjlSRWJvTUR5SFEzNVFYVytVRy9VanFHZ1I1aU1G?=
 =?utf-8?B?dWVVZHEvU050Tk9kSWsvcTJuQWVFR1p0ZG94N1d0dW5tN0NPUTBONkJJUzJW?=
 =?utf-8?B?K3pzc2UxdS9XeG9RNHdlMGRhRktMRkM0SFhrcThuclRIZERSS0lidmxGZkJH?=
 =?utf-8?B?QXViWjdXdithNzRMKzBxTENpOVc0R0pJZ3ZHRTg0YXljcHI5SkpUclY2T2NK?=
 =?utf-8?B?UEhjdmFLUDNsN1VSM1llQVFGSWtLSzd5dDBYcUY4MkJ6SmhGYmloNGFlRFZU?=
 =?utf-8?B?dnJ3RG5vQWkwMnJ2TCtNWFFTLy9YckNoRCs1dXVXMUlyc3dETVdlWTFYZmgw?=
 =?utf-8?B?cWgzcmQ1RTl1dXdnem5FdldLdEpJeWEvMk1tdElkMTg3c2FUa3VVZ3pRNTJi?=
 =?utf-8?B?T1FiTmRyckdPMS9WWGFpcjBFem9ad1JOSHUvRW9YNHdPbHR2cmptWW1tSk95?=
 =?utf-8?B?RCtEck0zWWN5cWcxQWlwQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlcwLzZjNUdCNUVwWFQya1RlYSs3S2w5UmRvU1Z6YXFpbEZqQlByT0hRTlox?=
 =?utf-8?B?N0VlVG5HUjIzaFpUNkdjT1lsTDRiSFcvVnJ3dUZZanR1YjVVaVB6VitNZVVl?=
 =?utf-8?B?S1JuNkxkTkNYbEpOdTJjWkJUbUNXcy81MVUrd3p4UkFQT0hvdHhPejdZdGtr?=
 =?utf-8?B?NzNORFF4NG0yUGFaVEY0b0pKcjN5UUZrUlRYZjF2OTkwbE85UG0wUUl2MGRp?=
 =?utf-8?B?clFVam8xd3NlbXFBam5DNUI0S2F3REd2ZXIvZHo3ZDFxb0l3clJTZW9GbUNm?=
 =?utf-8?B?WkF2MWpLYWRmUkpoczdqbCthSTFTclBYbG5aMjI4dUZKSTdoSEJZMDNDdFpU?=
 =?utf-8?B?UkJCTVFTQjZjaGtHYzloR0lTVlg5d0RFRkRGa0NVclhUaVN2aVV4bFlGNmJK?=
 =?utf-8?B?d1QwM2NPUElSUDZBMk9WZmU0bkFqaVZuMU1MeUVITUYvLy93L0ZCYkpKVzV0?=
 =?utf-8?B?RExiemh4eDNnQjRXVzRucm94SmR6MlZ2bnZnMktqWjUrQzJmZXQ0V2JGdnNQ?=
 =?utf-8?B?OXZkb25jVWg4VkkwK245NDBxbXNzd1l6VC9jK0lkVnR6Y3k1ZHVIL29NUUpr?=
 =?utf-8?B?Y3ZFU3J2K041djR0enBzYXg2TmFBTFc5U0M0TXdIa0ZPN01RSXMyVG5XbFZP?=
 =?utf-8?B?S1lEeXNPYWtpd2Fxb0Jod2kyQml1MGtWWXFzYUpqdVVOUFNuOVpYN2cxRjB4?=
 =?utf-8?B?WVJLWXNpVW9OQ21SbHQrbVkrOWtrZWs2cHN4MEwxS3FXMlBiNGVaQkVrWXJM?=
 =?utf-8?B?Z0FsMzh6Lzh0YmQ0bVBadkhhQzB3M1NiV0RpaU15eEdtSnRDZ1VYRUdsdHgr?=
 =?utf-8?B?NlhPUjNoR0crNTg3Z0dHOGxjcmt2K1dDZXJ4d2hqanRTOThoOW5DN0oyZXNQ?=
 =?utf-8?B?S0ZFVWVwdlhlSjFDeWx2Yi9wbUh0RUlwMVFTVG5qeXIrenhWYUVVNzFQWXkx?=
 =?utf-8?B?R2pQVGpOMGMwM2pqWm9aNldrVnkyVWxXWVRqcFFvbVczQk1IU1Y4SkgzLzFI?=
 =?utf-8?B?cDBOaUE5dnRSRHZqbElVbnZCYzBDUlIrL1FjdmY5Zlpta2Vxb3F6d0t5Rkhy?=
 =?utf-8?B?UFR4bTRTRnlqcVpKaVlYcjBmQ2NybVV3S1M5TC9tbGlRUEpKbGl1enh2UzIr?=
 =?utf-8?B?UXRDL2dtcjQxTXZrZG5pMnF2NDBNS2FvWWVxV0pJMVBFbEsvN0Z3dmxMNWpD?=
 =?utf-8?B?TzNINTN0MU15YmliWVFwVG90YzJ2akV4V05zU3lwM3ozMEVWMzNkZ3o0MjI0?=
 =?utf-8?B?d25JQTM1czl4SU8xM1lGcGRncGFFVkF3T3owRFFXT1k3UDhTUTdZY0tZQ3lR?=
 =?utf-8?B?ZWVXNkJVQ0ZyYjJISVhLZDFzTFBNUFZDeXZVQ2tPRlZvTUZEN2N0M2h0bExj?=
 =?utf-8?B?TnE0ZmVjeEpJUDlGa01MblZ2SDl5cXk1WTdBdGtvY010RzVYOFduUWVrdmsy?=
 =?utf-8?B?SlVxU0k4ZWliRWd4YnhRanBUdWFZeGQ1NmxnWlhZNnpIT0o4cG5QNm5hSEwz?=
 =?utf-8?B?SGZTNERsZFNzQmZveEJ5UGxJT1lXR3Y2WFYwS1Aya3AyU2RaWWMycldJQi9N?=
 =?utf-8?B?TTJrVlptZ3J5amh4ZzN6a1YvdGVjbEpWZFRBU0I2UUU0Y0VacU1FNDByNVdz?=
 =?utf-8?B?L2hJMkRldGdQVXp6K2FvQTVJcGtEbDdWckQ3UXZkSWppWTRMNlhDME1FdkVh?=
 =?utf-8?B?WGJMMjYvaVVDQzJ3VWNSL0JhVnRKTUtnRDVCMnp4amJSS041Zy9MVkJCQWxK?=
 =?utf-8?B?OStBSFhUUVlCbVVQSmFSVXhmVmhpTnJuTlZFYnplK0RRMENoYjRuS09PbXJx?=
 =?utf-8?B?TUpCYkhxWlN6a1RCeThsYzJ4aitvL2c5VGhPZVRuazJmZWFYMmlTN1JlWU96?=
 =?utf-8?B?VDFZcnhaM3Q5TmNrck15RUVId2lOWXFudmlHbkE3Y216WXNWd3VNWkJwVVZy?=
 =?utf-8?B?M2EwUmFvdlI5ZkZhY3FYVE5GaVpKYkp3OTJ6Rlk0L01oU1hLUXltS3dIK0Vp?=
 =?utf-8?B?VUVMeXYxaFJ2elN5bWhxMHBPcGdvVytZWU92dlJqL3V1cDZsZG5UTDVqR0hJ?=
 =?utf-8?B?OWlDdmlUYVVmRkNlT1VjTXlqYjRoTmtHV1AwZGpZVUJWcFQ3MGQyTnNIWjlm?=
 =?utf-8?B?NUt0RXZJUXNkYkRYRE1zSnlJaHNFaStHNFhESTlGVlNXbWtFNlNPbGJsOFJI?=
 =?utf-8?Q?Nte8x3rmh0cm+yJmWPjq2mw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7C34FC59BC7C44D8CF5AEE415C7F23F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6640a74-11da-4d4e-b701-08dc76b61e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 21:12:54.4025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXFaK+C1WJ8HqAuaUs19RlmvOIx0bCLtWYDf47dMWimGZ8ezuCCJ9pgHa9a0cvYt0278fZRhWNwS+q+p8T/XhCgziAdjsbAbBntoWYYqhLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7011
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTE3IGF0IDE2OjI2ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IEkgdGhpbmsgSSBhbSBqdXN0IHRvbyBvYnNlc3NlZCBvbiBhdm9pZGluZyB1c2luZyBrdm1fZ2Zu
X3NoYXJlZF9tYXNrKCkgDQo+ID4gc28gSSdsbCBzdG9wIGNvbW1lbnRpbmcvcmVwbHlpbmcgb24g
dGhpcy4NCg0KSSB0aGluayB5b3UganVzdCBuZWVkIHRvIHN0aWNrIHdpdGggaXQgYW5kIGRpc2N1
c3MgaXQgYSBsaXR0bGUgbW9yZS4gVGhlIHBhdHRlcm4NCnNlZW1zIHRvIGdvOg0KMS4gWW91IGNv
bW1lbnQgc29tZXdoZXJlIHNheWluZyB5b3Ugd2FudCB0byBnZXQgcmlkIG9mIGt2bV9nZm5fc2hh
cmVkX21hc2soKQ0KMi4gSSBhc2sgYWJvdXQgaG93IGl0IGNhbiB3b3JrDQozLiBXZSBkb24ndCBn
ZXQgdG8gdGhlIGJvdHRvbSBvZiBpdA0KNC4gR28gdG8gc3RlcCAxDQoNCkkgdGhpbmsgeW91IGFy
ZSBzZWVpbmcgYmFkIGNvZGUsIGJ1dCB0aGUgY29tbXVuaWNhdGlvbiBpcyBsZWF2aW5nIG1lIHNl
cmlvdXNseQ0KY29uZnVzZWQuIFRoZSByZXdvcmsgSXNha3UgYW5kIEkgd2VyZSBkb2luZyBpbiB0
aGUgb3RoZXIgdGhyZWFkIHN0aWxsIGluY2x1ZGVzIGENCnNoYXJlZCBtYXNrIGluIHRoZSBjb3Jl
IE1NVSBjb2RlLCBzbyBpdCdzIHN0aWxsIG9wZW4gYXQgdGhpcyBwb2ludC4NCg0K

