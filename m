Return-Path: <kvm+bounces-19304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FCF903806
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 11:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DA8D1C219D1
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 09:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420F2176ADC;
	Tue, 11 Jun 2024 09:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfJE/att"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9E12230F;
	Tue, 11 Jun 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718098879; cv=fail; b=QUv8777ENp+hdI7t14KOkBLj4aSHxjSuAbCI3WOiOMh+k0XKjEntfhNDitboKGMdVffw3Mg109uMQg2JDBkDCZstH9QgthLkG3AIFJ2W+6yl/85aDLyVPOy4yIKZ+GCmunEPh7xPV/xd1sFmQCRfzYcgQpnPRqCWZ3ydmyQQWZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718098879; c=relaxed/simple;
	bh=T58avZRbt6UX+3Q1nX9tL/zvLC3RrTLN8UudBNH5RFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F/f1ai6yuE6Y0f6IcTs1O5i6SwMZN1wqGw1PeoHlGFgQM84VdlIdtPokWfb4hELXiMIbIaluNMaVF9w4kngUnvQGqTBsL6WEfSaTpu+rOE0i00PDZ/mv7cWeYu+ju3IA2AlEH4reVnlXwGdK5Qij5cZap99atEoclP2j3YV8Ihw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfJE/att; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718098877; x=1749634877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T58avZRbt6UX+3Q1nX9tL/zvLC3RrTLN8UudBNH5RFo=;
  b=dfJE/att0BNHAM/JfDeY/LdnlSuMsP99dCpUrrkYxAY2HZpnsi+28HsT
   xyR7TDSjLEuxC/PqqBUfrt5mUdTBv7AcL+JQKZANPh7s4nQSYLydP/BS3
   EsXMQAPlzme4DFflxXqUp6BVMITwC6JMmUSCaDTY6JNNUpNoQSC2rDDUi
   dvLl6cYpECm6Rjw+YWbYNZIX0duEC5wS+q7bUFImYCwSdraG07rSpAhwD
   v4HGvlkCcTmz1x3D2L4QNjX5EKVGwjzgqD0rQi0HgCA/bksh3AWOwwwwp
   L7Tm8p3ubMJMvNMQdSYUSinDVp5Zn8eoDIb24yOVIPiwzFvt1wr0qzOwN
   Q==;
X-CSE-ConnectionGUID: y0LqWckTQqKuSBte/bnosw==
X-CSE-MsgGUID: jgzUJDhRTGqZRdQGYb50cw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="25375842"
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="25375842"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 02:41:17 -0700
X-CSE-ConnectionGUID: WLzU9UXlQhyGvh6DWS6q5Q==
X-CSE-MsgGUID: v7YdHYdFTR67iEDC0IMaMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="39458426"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 02:41:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 02:41:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 02:41:16 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 02:41:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2g2lJdq+fIMLow+OtsQwQ84fvRnZTgrmChBSX1CEvx5KrB9bNrLn9wc3MNnncmOL6Eoq04zJhPbjDkBeT5ahsa5snMj1U72FiQ5MqZVyf8IA4etMghzlfypXTeLUZlbxQ0PCwqUqFJICDqyOHWxFey7nrzxSQt3yBS6N5plTbQjXMIPk2+01t4sWgPZmv2nR5+AYJc53zN2Hq4UV5jmWvo1yjgxNSL3rds5FXvjpccctm9uZnr69mwPiJAWUTS5YGYam66UIAy5m4OJ98wObJm2WlxgV2IXzvOl+6MY8snapZvLVcjRqaNr+eZMbcDYF0Uej7zYF6u5DfPq9vIwjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T58avZRbt6UX+3Q1nX9tL/zvLC3RrTLN8UudBNH5RFo=;
 b=Prmo3ZR7Ud2YG6ibDeIpejughVXuXdvtLLIxxsRvcb+6wmOEigeQlh8JSyY/G5hN/WLZOud5RHVw3Q7zarYyJPuWSt1DyimOl9XTCkrFLAcWkQWMQPdCBKp7STIWn+3urGtU7EGRgWWkKa+Uw18bDoWbLT8AkgM81FvXMcnkNvpaXZfnrmucq4VHbzJsD1Y3prRtRgI7MDdkepr0lovr6Mk6CNt4IS49dlmnhuXgF8NvuArp8CzZBIZJCQar/wTAI1gvAFeyMYinZBM8jByRaVGiSGr9hGffyvcJy/lEYT5hJKlcf3xoQgfEeWs20e4gqL4npEQ0Of8+kGFRLNa3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM3PR11MB8734.namprd11.prod.outlook.com (2603:10b6:8:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 09:41:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 09:41:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Sprinkle __must_check
Thread-Topic: [PATCH] KVM: x86/tdp_mmu: Sprinkle __must_check
Thread-Index: AQHau9cMOldcGp1CmkWtUVIlfjByOLHCT06A
Date: Tue, 11 Jun 2024 09:41:14 +0000
Message-ID: <4552458c1441e3805868fbcf3e95bee4b0d1f2d9.camel@intel.com>
References: <20240611081124.18170-1-pbonzini@redhat.com>
In-Reply-To: <20240611081124.18170-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM3PR11MB8734:EE_
x-ms-office365-filtering-correlation-id: a8d8fd76-46a1-4a86-c695-08dc89faa27f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Unh0eVA3c2ZNTmZYMHlSU0x0dFNhOGFpUXZLUFRaSUtNcWJTb2lzL1Z2Y21o?=
 =?utf-8?B?ZUhsdlN3M1VXeVpocVdIMHlzS29FSk5GbUsxN1pudVFXQnlsVnhQWFdpTmVv?=
 =?utf-8?B?cTBIM2tlMjRMaG5qeURnSGZmL1FPcjVwekh6d2U5MWVaelZsNHBMdEk5UmFB?=
 =?utf-8?B?ODlySGR3MDNuUmVlcVNpNzdNRjhJUTFuNEpidFlBbk9qQlpSM0k0WXdvRjVV?=
 =?utf-8?B?WTNqMkNTeWRnbEFCL3d5Rmgvdk5wZXZjWThxS3FlQkhhZTJsUldZKzVGdnU4?=
 =?utf-8?B?Y0MwbWR6ekI5akp2N09OenRJNTh6THBNa09aVThOS3pDdTRUZzlibCtkbll3?=
 =?utf-8?B?c0tZajJCQ3BCblYwWHFReXhENTJJYVZ1aG9LRmUyMmNFV215c01ZVWd3ajgr?=
 =?utf-8?B?dzdNMGp2L2dFamZ1c25JNGlwZitrRGZJeGpGUnk4VVZPbUNxbmVjakdkZDdu?=
 =?utf-8?B?S0sxaU9ZckoyMTNCZmNaUDhHMy9pUGlmTjhzblpjQWdjSnd0WDRuZFRmY3BN?=
 =?utf-8?B?RGtYV3lWRytmT0xoUVI5VHNlcm1oYXVpVWdaL0gyaTVwUDVqK2NITFRoVFBo?=
 =?utf-8?B?eG9OeHhQRmszMEhYc2dQc0lrUDBWazRIdDhtL3A4OWtNV0FSRG1aZysxTG9x?=
 =?utf-8?B?RzBlU1NMU3VsNHdaVS9tT2FlYkRmRk0xQ3poV0hIVWpDNnRYbUJtejI4T0N0?=
 =?utf-8?B?d0dRMGJXdnVqbUp0M2d2OFo1NmdYeXdONnB5UTlpWndjM0V2eTlCenNaTWdZ?=
 =?utf-8?B?anN5R2twbldqR0c5eGFjbzNtRHFEYWNjSHFWKzJYSGlCUUhQUm5uOEZ1eG1y?=
 =?utf-8?B?RktObC9TUnBwU3R5bUhBZWwzdWJJTEJGK3M3YVpBZVIwRlExckdoU3ZCOUlC?=
 =?utf-8?B?ZHVSVFRWQ2VMMVNmVGEvNUtCcFhWVllnZ0xScXdUUDJTdkt0djl6OURBQjlG?=
 =?utf-8?B?SVlBVFR2ZTJ3VzRtVUVxWEpCcTFpanZLUnVZRTVRWlRJNGRWdVloNjgxd2NC?=
 =?utf-8?B?UXQ2aklIbTlSR2ZyeXNrT016dmRqWHpWZ0NtRnJkY0w2UWdranI0bnJaQ3dZ?=
 =?utf-8?B?UFBCd1JEN3o1bitKNE5NZEVPK1hYSTN6aERSQUxzb0cvQm9YeWY2WnN5NE1D?=
 =?utf-8?B?ZGN0RFY0NzJDNWF0d1NRVjZXbDFSRERlL2hiRkJHRnltK2E3ZWJ5WVJwUlRN?=
 =?utf-8?B?VXhqdndOL0xwbnZydmo2L3BLdmkxeVppeWJHMytRbllZVGV5YTk2K1BMbGli?=
 =?utf-8?B?WEZ6WnlPcExGdElaV0tyWUFxMllKVGdzZ1k3UUlML1VqaUtHem81S1U1TW1W?=
 =?utf-8?B?WEJheWp3YjFiTXgyMlRUWldEYmNXVk92dlIzK0tKdWYxQzJ6c2Y4eU9Mdit2?=
 =?utf-8?B?VWsrSWlLRDE0T1ZWQVJZOHRaYWtGVDA4ZHE1SEpPUnhva1hMQVVwVk11Sy9O?=
 =?utf-8?B?TjBsVldtWkR6Vnh5Mld4WEpCS01Wb2IyS0JKeENlRndjK25TMjhXWk9pbko4?=
 =?utf-8?B?dGxNUlpEeERHc1VqZmkvWlI3VytVdVZhQ25ueWtUNzlnOTF6VjNWdTZ2N1Zu?=
 =?utf-8?B?cnlSdnBYQWhNZWxISmFaV1hQMXppZ1NQTXo5cWRDRDVORURGUDlxSEE1UVZJ?=
 =?utf-8?B?dHpkVmxXVnBQYzFxTUtGTlZhSDF3QzNKa3BOYXY1eDMzZVhHVDBFOFZwSEU5?=
 =?utf-8?B?SVZMRUhTTDQwWDRNRExMM292S2hHZDh4a0lHNUpTVGZDVjhEZmxONnB2RHRu?=
 =?utf-8?B?U0RkVGV1cGUrSGRRNWtWYlBMNGNLa2pRUEpGOGQvTXhMQ1kzb1BYaCsrMUc0?=
 =?utf-8?Q?MWd+gE5M1X0CzAcEb1r2iQ0KQ6NZEVQpnSPAQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjVXWDh1eDd1MmJSb3ZXa3VKV3R0VzQySTJrN215Y0pEQ1BUY3dCYlY1UzV5?=
 =?utf-8?B?alJiVkdGMWFuTzdlUlh0N0srb0VQeEgvQ09BanJPQlNueHlBWk5VYTcxTjlY?=
 =?utf-8?B?RzVNWVNjd2Evc3grVHI4aGZxQnNmOUpKemRoWTRnakRjTUJXSUtFY0dvWElv?=
 =?utf-8?B?dzRJbm9mckI0WGw2VVowb3hiSUxaV2FLMXloYU42MjRKV29iMGZBTDJsT05z?=
 =?utf-8?B?ejcwUFhQbGt3dzZlRktUcm56VEJEOUhzZ2JrMFZsSnNESDlIcGpwNTlHclBH?=
 =?utf-8?B?eVlHOXgyTnBhdnlkeDFSc0tnb3E2WkduNnpBTWxwdmc2ejBaTlVUeHk1d3d3?=
 =?utf-8?B?aHZmOUpuSGh6UFRZaGM5RWs3WVA0cFVLS2w2RS83ZUs2U3N3T2MxS1FtRG9q?=
 =?utf-8?B?UENHL3luVEhCRW1OUCswMG9OMGV1MjF0aVdCV2xZWSt5MlFkUWZ2Q1Q1ck1C?=
 =?utf-8?B?ekd5SlJPYTVDQ29HTHhqTmV1V2VaMUpZYUhtNWZVRVE1anFSR25ldkNvVzgr?=
 =?utf-8?B?MkRhZmpEUFdtbTREZzQ5eXhpSERja0N2dElXWWZNMWtMNkdKMUJreHkvNXhD?=
 =?utf-8?B?bVcwWjluVWhUbldYeGpqSTVrdmNYY0U2TXk4VktFWElabTNlL2JYWWhFUk03?=
 =?utf-8?B?bkZnWGI1enpsSkc3TlV2TEtrRk51NzhHZ3RBQmxWdENWemNtb0hQTjNaaktL?=
 =?utf-8?B?cTVDazRVOU5JcmNpYU81aXpyWW5sbDI2NFhsY0NSeC9sYWhSMWZhTG5vNEpC?=
 =?utf-8?B?ZnlEQnhkaWZTR1pDQzNjSTJZUk1GckxSb2lwbHNhRysrUWxuYThIRjh1ZWtF?=
 =?utf-8?B?S2JwQ1JBTVFhZG1QQytiQ0tXRUtldEhUaFlzdmQ4Ynh6cWdCVHBaZCtLeUMz?=
 =?utf-8?B?MVhJYlJhbVRQMlArd1pqUnJwbTlYdUpnTlBWUGhmK04zUDV3R0NMY3YxUUg4?=
 =?utf-8?B?QmpseURwU1RUR3haU1J1OXorYU1CZWY3ZG9hNHY5VTFBN1dpZTdnWTBUOW5a?=
 =?utf-8?B?UG9KQkVmOTN5M3ZRcWtRMzFHWkZwTGdDUzlWbTdSZHRjSVlUemU5SnJKbnBK?=
 =?utf-8?B?alc5S0FtOW1KdjBEV2F6U1hTeWFISklHNEhCblVYMEFmbU0zRTY1bGRQemZj?=
 =?utf-8?B?cW9tb1YweU1HR2xSTWJ2bjJoZzNURW9McmJJcFFpMG9JRXFHSUlOaldIdkdW?=
 =?utf-8?B?Qm9vbnVETmpBQWdWM09zNjcyNmw3ZitJOEFkelpXUFJJTWNJejkrdjRab1Uy?=
 =?utf-8?B?SURSN3FtNit0cWRSNTZqU2dwcFkvYnI3SFAveWJsaFVMbjU0dnpLVmM0bGNJ?=
 =?utf-8?B?azEzb3AyTFl3VEpKQUMyb0xvWDBGb1pOTTNhTVYwMEtaTVdXUkJkbk9INXBv?=
 =?utf-8?B?SEIzeVpMeUhtd0JlaXUxMWZHamw5THJ5WHZOTUFnbnNzS1RaTXliLzlLLzBX?=
 =?utf-8?B?RlB4UWdRcWlNU29iUDIyRVIyOWVEWTlUNG1GbmlTYnQ5U2ZmMzlhQktVc0li?=
 =?utf-8?B?aDVIeiszWWZaZVkrdWg0ZXhuMUJ0eEozOUxtU3g3U0tSbTNDeFZhVVp3bC9s?=
 =?utf-8?B?L2FxdXVCcWxrRE5PN2lyM3dFcFhQNkpIWTdFOXlCZEhMVDRkbUNYZE9ON25x?=
 =?utf-8?B?T3FxUDZWVUUvU2dicjNPQTJSR2tlTXFuejdZSTVrM2QrUmpGa2pvWitsNDFp?=
 =?utf-8?B?WEdCdHk3Vk9MSmNLZnQxOStSZXRYOGhqaEtxZUxKOVlKTW90clVERkNCdkVC?=
 =?utf-8?B?enZid0h2cG1mSWJiRmpjMnY3WkZWUUdWb3pPSzczRTNsbVk1Y2RBZVlubXNx?=
 =?utf-8?B?YXUxSVFwc2lhQndNZ2dqSTlQS2xLMVVuQ0pXNjROSE1IK2thN1lLWWE5ajlq?=
 =?utf-8?B?bkZDZkFRVjlvNjJza1RUQVhFcUpvQVR6WDE5TEd2UGZkNUJJaUh5VWEzajJt?=
 =?utf-8?B?OVNxNERtVWdNOVZJTzU5cS9nMFEyMUpuaGhhMkxDdnI2R2wySWdkQ1J5Q1lE?=
 =?utf-8?B?Rnk3c0dSQ3NObVlac2JUVWJrblk3Nld6Y2NLSTYwNkNSRjB1RFlHUjZ1c01l?=
 =?utf-8?B?YWg5ZUdXZVlPL1BzbkdXbzNRbTVkZDhGV2lPV01BcDRLNUh0cERvNXVGU29l?=
 =?utf-8?Q?KEFwDGl3QI1OV8im3HzCLeLZ/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAC4E8A5CD8D724484964E64DFA6E7EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d8fd76-46a1-4a86-c695-08dc89faa27f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2024 09:41:14.0654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BnObz4PaHUguIS/7G+uItrnhE6dUqJd5m1jy1htLEh1eOopZKcdqQqMi6PSxHVfxg51GsVF+3X0s9a42EQbukw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8734
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTExIGF0IDA0OjExIC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
VGhlIFREUCBNTVUgZnVuY3Rpb24gX190ZHBfbW11X3NldF9zcHRlX2F0b21pYyB1c2VzIGEgY21w
eGNoZzY0IHRvIHJlcGxhY2UNCj4gdGhlIFNQVEUgdmFsdWUgYW5kIHJldHVybnMgLUVCVVNZIG9u
IGZhaWx1cmUuICBUaGUgY2FsbGVyIG11c3QgY2hlY2sgdGhlDQo+IHJldHVybiB2YWx1ZSBhbmQg
cmV0cnkuICBBZGQgX19tdXN0X2NoZWNrIHRvIGl0LCBhcyB3ZWxsIGFzIHRvIHR3byBtb3JlDQo+
IGZ1bmN0aW9ucyB0aGF0IGZvcndhcmQgdGhlIHJldHVybiB2YWx1ZSBvZiBfX3RkcF9tbXVfc2V0
X3NwdGVfYXRvbWljIHRvDQo+IHRoZWlyIGNhbGxlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElz
YWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBC
aW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQo+IE1lc3NhZ2UtSWQ6IDw4Zjdk
NWExYjI0MWJmNTM1MWVhYWI4MjhkMWExZWZlNWMxNzY5OWNhLjE3MDU5NjU2MzUuZ2l0LmlzYWt1
LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJv
bnppbmlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+IA0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0K

