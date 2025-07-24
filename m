Return-Path: <kvm+bounces-53358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C18B10956
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1143FAC27B2
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 11:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9497285C81;
	Thu, 24 Jul 2025 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DnX6UdKX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE3E23D291;
	Thu, 24 Jul 2025 11:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753357079; cv=fail; b=RD9VeM1ahH8M9tEOu+5WaYkrUsNCHhIpHt7Ifa5HW4dO6xDrSOcBc+9lzCyZ8mC8mFWrVM59g+CpGgaQ8RT2rrNId7FeLmIRDrQSVFkcGwUveLCCwReVetvX9YyZI/THWQtP53y9sXjmlTJZJKd1+bOidlrvUMU/wle+3uypSlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753357079; c=relaxed/simple;
	bh=u2s1dS0TLWnFWLWitfTxv5PxkLh3NTRbDoBPpxziZMM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Up7oGGCUepkDnARRFBYZWKHMjB1j+vKqTcHV8e92OqBX5P3AprmHKLDCGXHr3pp0oY+hF/wm03NomemoQ51uM6/Ndixm4VOrfjfXmb7GMPYwjbmJ0s/rd+NVGdtM1xj4WRQ1Ps50Jd3cSdpiB0rrIiS8854EB3seDRYnn2T63Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DnX6UdKX; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753357079; x=1784893079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u2s1dS0TLWnFWLWitfTxv5PxkLh3NTRbDoBPpxziZMM=;
  b=DnX6UdKXoZpZRX40nl7/7gzEICZcc5nMjYJmjhWHy9WrBxpKExTGMoOZ
   5TQcmOetfGsPDkgUOieOUaS8t4QM/aaO52DUrEVn/lwUCnAFlr+FWcBpL
   9MvBJnGd4cHe+tVmqIeDH9BQlch4yBlxVERtaf9j3Kl8PSQpoM6NOmS6T
   n5Z7NXhURQ88jhTBKFKg1b7hKkvovYjjZZY0NKTk1hsGB241iaM7NKYfF
   Cum/f1OKm5ig4ZCGRbSGRPpKbAJa84Y+WubQpU+qaGzuCGillCueZQKeT
   kaB36mhcczVypwZYRsxOrubtAGnqLZAqsRYZb6llXtRQ7jmCrZUhYUmxV
   A==;
X-CSE-ConnectionGUID: E/y4Fi2pTc6e3rEiIl/niw==
X-CSE-MsgGUID: ub1Ok1sCQcqZD2TW7sdbYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78210865"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="78210865"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:37:58 -0700
X-CSE-ConnectionGUID: ko43b1f3RDe6aBg8t2j3pg==
X-CSE-MsgGUID: E3zbwNofTmKNvjqBBNKDlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="160698279"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:37:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 04:37:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 04:37:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 04:37:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNolNXmC23ayiQG8fn95q0xFrNbOtecpc120yr8PrQ0ccrDelaj5omvQZhC9XXgP8C5gaNqJOM7TFfSU8qf+PDoTs6DvoavIej0PgCEUnnqMPeLXTGtMXujFMd9bwhQ/dQpeDtlQyEHjSoxC1lDSD3lVr7ArCsEYJjIHIv59vs2iId8OxNF7OeJH+uzqPYz0Bgo6AkCNzQf5iMu1NBTGnLh8SHG8paIdsI6j96JOGn66MhLBZGRmHdKMURCUrVbkaMnjeTtih7Vh5vMDDHgX8K9vIaUtM6O+jTshuygQByIUWmCOMGzZ41IlFi6EY86lyDZsET/EIkoJ+OxERWjE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2s1dS0TLWnFWLWitfTxv5PxkLh3NTRbDoBPpxziZMM=;
 b=XZpm7lBgLL1bFc4kQTkvJkHpo71bMlSWsReS98sks4oTi9J1VWhEh8XuxykqrBwMCOSM3IZX54F+L7OCVa6I9+N0d1qetbhALJlEp5CCM9XuMg7MshVllzM4mrBAZBFbdTL0IfIaurrUHfu8c5Oz3vKjszCXn6UN2O9FhjFbpbnkazOV/to24O7lCD+i9FOfKrfTfUj+0WQTsnsxi4W4OR8zEyZyrsbdCr/O8eUo7b3BS9jJgPFsJweDD+2HNr9xlHAf5cucaXQZ0rSzDG8+ZBa+q/zsV73xGaOXSRBgKOF/8g5kodWQ8y/oqIfEL0znqXQ7Bv2+zGVupy+i3euFoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 11:37:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 11:37:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "minipli@grsecurity.net" <minipli@grsecurity.net>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
Thread-Topic: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
Thread-Index: AQHb7MEHsNTd42jdC0eG+hcAF6ZNrLRBRTqA
Date: Thu, 24 Jul 2025 11:37:49 +0000
Message-ID: <eeec8f7d96b9dd9482a314b8ed81d3e26f6f6b9d.camel@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
	 <20250704085027.182163-2-chao.gao@intel.com>
In-Reply-To: <20250704085027.182163-2-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5239:EE_
x-ms-office365-filtering-correlation-id: 4ee499ed-1036-4c56-07c1-08ddcaa68496
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?by9qWWYvb1pLRnF1WVkrQTc5dzJYMzUvNkJrYUV3cEVlUTZ1emNZaStjdStU?=
 =?utf-8?B?TXZ3bVBleWlvKzM0MmhTdm5aYmJiVXgzYWZJUXZvUUs2RVdoSnB2R2NZZDh5?=
 =?utf-8?B?R1ZPeGhjKzBUeU5qbFRNeDdRQzBPbS9Oclp5NVZDVFloMHpLbW85cUdIalN6?=
 =?utf-8?B?czkzbG9ucjZWRFBFWkVaVVdlb3lCTWlwSWVVMUlJS2hJM1FUYmNBeEFnQitW?=
 =?utf-8?B?ZEQ5bWhZdUEzeUl6MVowOVRybkYwWmFLZmlxUUpFWnorVmxoTmxwR1FNcGRH?=
 =?utf-8?B?c2tPZGhNcDFTZWxkZjJyN0IvRVlnTkQ2V09RMG1jN2xIK2xsMDV1c25jODU4?=
 =?utf-8?B?dytKMU90bUd4eXMzbnkwR0hVa21yNlAwNHFoaTBoczdFdkRsam16ck42M3NS?=
 =?utf-8?B?aTNSVmRpd1Q2YUdwMm5EOFc1TEx6Q1BZTnlqRVhUUk1XS2szNGQvdFFvNDdI?=
 =?utf-8?B?SXRLR2ZqWWcrR2F2RU91MUZpZnBBeS9rZk1ydzdoWVZvN0xMM2JreDMvY3Za?=
 =?utf-8?B?WEUzamN5OVBhWEZKL3oxUGNzR3NOQzRTMHNKNWU1L2JRTGQ5RVgyVm1JcWRs?=
 =?utf-8?B?N2V4UDQwblYvL04zcXR3a3BHTjVMN3pTbHhwN1JNR25zUWIvOFUwS2xBNFdO?=
 =?utf-8?B?RGFEb1pHWlFFTWFiVU9seWg1T2R1R1VCVFVmdXVNZjZGTk9pZ0NXZmJ3c3kv?=
 =?utf-8?B?NktCUnZCNTM0N2o5QlFTWXgrcGNqSjc1UXhZKy82eHZRcXdINkVuajcrSzNl?=
 =?utf-8?B?bjF5NzU5SEFGVjMrV1plWWo4RGhCMVhuSUU4eFVhU25VRG5tYUFJWFZQUGUz?=
 =?utf-8?B?a0Fxd3JIUy80cmMrRTVHRVIzYkVOei9HRGgvazFMZ3E4ck9WanVVU1Q1aTBV?=
 =?utf-8?B?QzZsVEFNS1lRWDRqck55bmlLYm1XeGUvZ3VVRVRMdVZISUhSV0VKc2I3OEd0?=
 =?utf-8?B?ejZFZStNOGE0dlk3clQ1U3gzcjVPMVF0YnJONGdObXlUdGJwTktmaGRGTWFX?=
 =?utf-8?B?cUhGSVc3Q0s2THRmK2tqbW02dytwLzBpM0ZmT0k3RmZsN25LaFFmcUpJYk1Z?=
 =?utf-8?B?VWFQNElGM09CRUlxTkQxK3dxMUVQZ3puKzNCa0xLTTZPUVFqK3c1N3pLU1RU?=
 =?utf-8?B?bUMwMDE0VnJ4L0tpa09kak1QQzZXSWpCQm5BSEs5amRwZWRPUU9nazg0ZVZJ?=
 =?utf-8?B?ZGpWKzU2UlBZTnFFR2ZtVWJuL3hrT21qaTQ3dUVpZVFKZ09iaWs4TjVBYjlm?=
 =?utf-8?B?Ym9Eb2JtZmY3U0JrcTFEbWtjYlVobUhzUGJqNTdBQ2NGREJVemZYelBwaDNR?=
 =?utf-8?B?cFYwQVV3TGhOMjNsWXVXSTYwSHVUQzRRbW14OVNQcSs3cDFORE4zMWREd05a?=
 =?utf-8?B?YXgrb2xUZkRreVJaR2lLbGZSVk9iUTJsb0lSQ3pvRFpOTUVDZzYwMEp5VlpQ?=
 =?utf-8?B?SXFjTHZRUXRMWnVBRGErcHZ3cmptWlJZa0c4bHI2d0tzblRVZ2FxVUJ2S21p?=
 =?utf-8?B?RGNhSW5SeE1Tak95VnBTYjRyQ1ljRFpxajEvTzM0OTE5Z3N6ZEdlL0ltQTJQ?=
 =?utf-8?B?aEd4ekJhcWtYbU5kM3ZPNjc5dVUwRnBOZGpiUnFvTkJrdWJqSXUyTjNGbHF2?=
 =?utf-8?B?QUFIQTRUelRmdnJQYkYxR2t1WWZvdFkzeUMvbWdRdSswKzIyRkJCdm01V3I0?=
 =?utf-8?B?MzVxVzgvUTRYc3pkbG92RmhtQ1FBYXpVNG5GbmlRUEJITm9aY2E1dzJKM1JM?=
 =?utf-8?B?NkFCQjV4MlkvTDNzRVAvNmU1YWkzYnhTclRjaG5uYWc3UEY1Q1RTdkxWdWt0?=
 =?utf-8?B?UHNud0hNVWpEVGlIZU01TlNzMHBuNjVBZnZEdHhqYXJORHloSzBwYjVPUmc1?=
 =?utf-8?B?UzJMTW5WVWlhR1duemtHajc1bjdyaEIvU2Y4M3dSdm5Cbk5uR3A0bWE0MjVB?=
 =?utf-8?B?MDlpYnFLQkN3M1JFTjRvL05UU1BTcFVyZVlOMTNOUHllM1d6Rksrd1JxaXVL?=
 =?utf-8?Q?iJ6rrZPQ0B5ZcFYbxD2CGarK0+TG0g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0dtNktlMFR6bG1IakloYWp5UzRGdml1UFVESC9NK2dXcThSb2p3Yk5HWGZD?=
 =?utf-8?B?S1kzSHJxTDV4a2NRY0s1Mm1tREk4bC9CRDgvS2ovM3Eyc3dsS2VwaFV1LzBj?=
 =?utf-8?B?clNUTktucXFnY0svVzFSQzVSTTVQYlg4Y0d4eTFvNE41NnN1RW4rbkJsa1BH?=
 =?utf-8?B?WjByc0ExSnNzZWtiZHd2N2VvMWxoZlRJQVZmSGFIU3FJK0tnN2ZubTdjOVVC?=
 =?utf-8?B?ZmxLc0RsUFI0RmlHUzBHNUhSNWdUa0JnWTZEOXpZK1JleWU5eFMxTW1zUjlC?=
 =?utf-8?B?Mkx3RlFQcitLdzFvL2xWTDJLdWQwazFJV3htVU5TcXVZeXVNWkc1anpja3VQ?=
 =?utf-8?B?RHhQWFBGaDFUQ0pBb1VjdE5kK3pWVzRRK0VwdmEzM1dZRkZmT0dML3JJRW55?=
 =?utf-8?B?cUtFd0pNbUEwZ0pxRlVVd0p6bXNzWjNoN3daYi94bW9MdktFaTArNm9Eb1Jo?=
 =?utf-8?B?QkdZTHkyaG5VanNGSi8wZnFGMnhXRUpBekRBRFFJc2Y3bzd6MXl2VlJWYWo0?=
 =?utf-8?B?NUxKQU5Mc2wycFRRU3dETy8vMW9OekpsMXNoYWp5eXl4dEI1THRBdmNnbk5V?=
 =?utf-8?B?b0F5WWhveXNTTzFyaEhyVkhZS243OFNpcmJid2ZzQzBVaEhIQUFUb0ZrQUpz?=
 =?utf-8?B?Z1NidVVtS1JCNVJCWDJxRlZZZSt6N3ZnUTkxN2dyYXBrOU0wdkV5VkR5Q1c1?=
 =?utf-8?B?cE51aWtxZ3hOdEpVbmlJcTc2ZHpWVFJsVmRkWWRjVnRQZ1VOMjhSTDhFSmhP?=
 =?utf-8?B?eUNCeTREK0d0NVNIdlNxeXN2ZW1qd0lwZUZ5ek9IbHVpS01rd0twSUNESFRo?=
 =?utf-8?B?bWYzYWR5MWdoeGQ1dEo2ckRJM1NXcVdtVW9zVmx6MFFYOW5KaVhUclZNQjVm?=
 =?utf-8?B?UlJsbDVtdUdwcmNNSEFueFVWT3hnZUI0SHoyWE5XeWc4QXFYOGY3aHhwb2dD?=
 =?utf-8?B?bkxPcXhmNzBWWVp4Z1F3VDVxNXZqZ3VmUVFxODBRaUJObTA0dFR4QVBqeUZi?=
 =?utf-8?B?NjNDK2tOVWhmTWdLMEtoNmpLdkh1SEFSMHNZVlFzRHdYVDhZS2V3U3BqTFdv?=
 =?utf-8?B?MlRnRGdTc1JDUGU2WS9xVGJ1Q2ovOEZuMldJQmpETjl6MmU5dkNGb3FOUXVR?=
 =?utf-8?B?enNPcW5tZ3RJZ1p1dXNiNmdMZE9oMS8zVzlVSXRodmlnMWY1RVBiN2I3SjBs?=
 =?utf-8?B?SzFEa0N4em51dDI5d2owY2x1RFFPSmJOK0F4Qzdzenl3WGcxR2Z2Wm1maGYr?=
 =?utf-8?B?TXdPZ0JyV1psNFN3QVJHWXduMFhKM0RCUTkvdTdWWmgwVUJXRXhPQnpxYml6?=
 =?utf-8?B?bEs2c1NwMVYvNW1MTkpGbWQ4QTZEaUFzQWdQc0pXM3gvRlJFdXRhbFFuL0Jk?=
 =?utf-8?B?clBRK3JsMDhSZGhqeFBQejZMUU1GVTVXaEVxcE42YmpzWFE1eW5zdGFRQjFw?=
 =?utf-8?B?NkVWZ0pjVnR3Qm45Q1pUbjdaVlMrRTUvQWZZVTFkdlRNYVRySGVsdlIwdXdK?=
 =?utf-8?B?RXpuQXp5Qy9UVzZvQ2V2V3RZbXR2UzBlL0hkY25WU0xWREdDMlBMbENtdlRQ?=
 =?utf-8?B?TURLc081R2Q0aTNvZVd0ancvTnhrN0pNalVUampXaDFiVDhnR0s0c0h2WVI2?=
 =?utf-8?B?Qk92VXNHRXllK3FFMUtpSnZOejk5Y1NSTUpmeVA1eEozbUxoQWYzOXB0QTgx?=
 =?utf-8?B?cnBsWW5mY3ZkUjN6b1ZGd0lVd1BqSmhkdmpmSmI1SHVGM1BiREI2T2ZHbi82?=
 =?utf-8?B?OFZpcXZqc2V2azdZTE41RzZoMENqdTNDUk5BTkEvclY0NFJYak80NTMwNHZ6?=
 =?utf-8?B?aUl0OHdBYzJEQ3A0SEE0VTdrYkI2NElRT0l2bCtFUCt4UEVYSEFwZHJNTjBk?=
 =?utf-8?B?U3BGRXpHa1FwNURoYUlBajcyOUVUNmNlcXd2aExaaGI4RDc0dDg3aWxRUTY1?=
 =?utf-8?B?eHlTUlFxNTFvL2VUYVA1Rk1JaFlSemRYQmMzVnAwZHlOdHcrbnZDSmNDRzBa?=
 =?utf-8?B?VkJ1cUU2S2cvL1dGTU1sSkdnZzJ6V3JUcld0ZVZ1L1hsZ0pVNWpkM1dqM2Jo?=
 =?utf-8?B?WmVPVjNGVSswblU3SG9Kb1BmbXFEREt4QjBaYUdiNXZoY2lUc3pxak13dU9o?=
 =?utf-8?Q?aQOD5XQVIX5EMiunkJj4vFmX9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97C5E4C1F7B8ED458A23D3AE1206B0BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee499ed-1036-4c56-07c1-08ddcaa68496
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 11:37:49.3966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK5Xut7VKlFcY45j1s/O3bOQhUkRCBW9L+7G9ogpef0qCqtgLN7rfoxaolNsas4putaOwTQ8TUpDLqf6FyEidQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTA0IGF0IDAxOjQ5IC0wNzAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRnJv
bTogWWFuZyBXZWlqaWFuZyA8d2VpamlhbmcueWFuZ0BpbnRlbC5jb20+DQo+IA0KPiBSZW5hbWUg
a3ZtX3tnLHN9ZXRfbXNyKCkqIHRvIGt2bV9lbXVsYXRlX21zcl97cmVhZCx3cml0ZX0oKSogdG8g
bWFrZSBpdA0KPiBtb3JlIG9idmlvdXMgdGhhdCBLVk0gdXNlcyB0aGVzZSBoZWxwZXJzIHRvIGVt
dWxhdGUgZ3Vlc3QgYmVoYXZpb3JzLA0KPiBpLmUuLCBob3N0X2luaXRpYXRlZCA9PSBmYWxzZSBp
biB0aGVzZSBoZWxwZXJzLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9A
aW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFdlaWppYW5nIDx3ZWlqaWFuZy55YW5n
QGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IE1heGltIExldml0c2t5IDxtbGV2aXRza0ByZWRoYXQuY29tPg0K
PiBSZXZpZXdlZC1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCg0KTml0OiBJIGRv
bid0IHRoaW5rIHlvdXIgUmV2aWV3ZWQtYnkgaXMgbmVlZGVkIGlmIHRoZSBjaGFpbiBhbHJlYWR5
IGhhcw0KeW91ciBTb0I/DQo=

