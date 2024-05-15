Return-Path: <kvm+bounces-17444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6818C69FF
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0D0A1C2167E
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87D2156237;
	Wed, 15 May 2024 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nTJ3UflU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A381155723;
	Wed, 15 May 2024 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788180; cv=fail; b=P4PoFEDnqK/FCxd/pazFYlxgsueWc/a3UnrUMkzVGQuc7HtJcrKu1yH7XFMcdT5iECNfJ3PhvtosSGwdv+YP4YQwguHClPlf1O6KTM4crpijTG1zuTFkCRJD13k2dtUoOvWYv6rNPjtPXShobKyrqeX9S03jA1gzfg4Q0ezkm3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788180; c=relaxed/simple;
	bh=XIV2PLS8V+0bnUmzeQLdZx8KmelnRTGgyKkIjpqDFUE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PahDPYqhd4DxDu2IvH6Pacm8XLeXVP7m2BVmecfBcp0XFAsyDcUSFi8V446fPhXL98u9L/FrsWXsTFsj2s24N2ltuI4w0tcNPqTTc9p9DhrHfRnEG/UEKeFoQzhUdYNfthB/aMFEhGVsoGXKKJTbvdnw3fzlL5ToViFmiI8dagw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nTJ3UflU; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715788179; x=1747324179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XIV2PLS8V+0bnUmzeQLdZx8KmelnRTGgyKkIjpqDFUE=;
  b=nTJ3UflUvE/PBK2rEqMNZRG9shvAqgOnUO61JXTyidNhbSUC8zX4+oS5
   KiCa17br0zjfwP8mdOum9AW9zo0DmtEmFu8S1OX1p6s1Vop3aPR1d6rOf
   HZz7ayaVGGVM7WwJv+z8y9g7LCjfimgbiKvGXIBhFtPNQkR2nQhhOjPR1
   WyUdwHYrElYWaKc6H6tqDnV5+lP9Inrd2U3zkOsTFPP8f8EfEaiwUKtgA
   Kg1gwWk6laqtzjmPVcGTgIy9L5XJv1r3uIyibNe4zx81tLIWiVesaWm4K
   vRQggBS/BkwfpY+HTF3Ok5FTuhk/kqzwPS5W3V99LwQbzRd/8zUUgM9El
   g==;
X-CSE-ConnectionGUID: /3x26D33R8OERMYHUguMVA==
X-CSE-MsgGUID: E+fFm2pBQNOCfJhqEuM1fA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="14797951"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="14797951"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 08:49:38 -0700
X-CSE-ConnectionGUID: qenZdyL2Sh22FhCZTiugBA==
X-CSE-MsgGUID: UUbHRt3dQTKQ5Jry/j5fdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31026188"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 08:49:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:49:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:49:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 08:49:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 08:49:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuFEDe0frR2QP7bBrrA1k6bNOByXZJjDFraN+02LkBdwlrAhsC56RTiQeIbBmkP1bZfUosIaSmz06lqZo9c7gIAtNHaOhQawNgmSraIHlixfjvqzNPGDV8uMZcQAJwHuwK+bwCfjQ9IPTBWil89ZWnIWz5+MLsAs9JkhQItgkDEDm+VHTFL3vJzcUHbG6cs98OtdOV4CcGxSxWDe6rCgRtU7rG2qZBoImDgT7//xiEWNNkAQprN7Rj5R8RFzUDrlbDNNHIYfmereDAvaDxw9CAkb/GNYXU7hbsi2rtAds3S+C6mRLGCbkeeMhgrEgvMqS2mAbUOTHK36Mw5Ov/NiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIV2PLS8V+0bnUmzeQLdZx8KmelnRTGgyKkIjpqDFUE=;
 b=IJKX3w0dOsKqMNx666PV3ks8se3/GzDmMJ4YNs+9gkHE7DN0u1ksWwbTEJmqkXAbsSn9uvp7QuX01ny4BgVJRfoAlL5R0dx3TlgJXXqFlIYyulLtp4hJaJxXR+mviU00SC6lWxhABUt8ylXLWwUVilh222JxYGr3eUyd2D8ybSOhNes0mGpQEK4yrQenF/F+749lbkvko3mz/ZZl+0jJyc5DW+BTxNGyR/ZMhqT7hh1Dv9WOPxtiIQ2AkbJliedZkb28b7RjdQPqbP4kahlLwSBO3ASlLqk0xuog+Rqbdhqtw+wGhnmsHWH//4jNcq/+VKOBNWNtd5GItncQpyuRFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Wed, 15 May
 2024 15:49:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 15:49:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYbgKAgAAELYA=
Date: Wed, 15 May 2024 15:49:33 +0000
Message-ID: <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <ZkTWDfuYD-ThdYe6@google.com>
In-Reply-To: <ZkTWDfuYD-ThdYe6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5195:EE_
x-ms-office365-filtering-correlation-id: e399f86e-fec8-4dda-2624-08dc74f69dcc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UytidS9qZlpOUUNqY2U5K056ejdtT3JKdEEzQy9SclN1cUpJM3JRZUllMWt6?=
 =?utf-8?B?b1ZkT2pYS1NqK1cvU21KVDR4SXFKSlhLT0Z6MWpUVXRKd3huK1VHWVd4R3Fz?=
 =?utf-8?B?V0VVOUcrRUw5VjhrbEhLS0Q1WDc2Vmd3RGZyNERUT1hIS2Q5TDB5bnU3MnZq?=
 =?utf-8?B?ZmFHK214UzdxNG4rU3ZaZkt2dS9Bb2NjZ1dZNjRZcm5VWHV0c3dIQjNJSzJG?=
 =?utf-8?B?S1pJL0VNOWcvaXF1eU5ES0JrSmtyUHhvdjZ6VmoraEZGenR0OGNLbCtmWmE3?=
 =?utf-8?B?alVXRkt4R29JTjc0RWUxdTBDZ0J0eXpWK3Nrdm14dFN0Rk1ReWFzLzVmK1hM?=
 =?utf-8?B?TkdLVWZYMGNyMTlaZjFTT3RORDVGc05VZGpHYXNuRWpRMGhBS1RYTW1sNWhz?=
 =?utf-8?B?WjU5U3RLNDJqRGo2dG5YaFZxLzZKbXRaSkNTRUFMamduWHIwc1ZjbUlIVko1?=
 =?utf-8?B?VkN4dnFMMjZvR21pUi9MN1lET0E4TVhCeGNsdmlza3RhRzJ0Qm5GY0hLNUVt?=
 =?utf-8?B?VW1DV1NsY0FGWHJiTFpONWQwM0VSMktRaWVIT0NWY0hORWh4RG82cTl4YVVt?=
 =?utf-8?B?MHZUeUNXT0tkeUtpK0J4OFlKUFZBekVoZmlUMDN5dTZGbk53N2hyeGZrU0I1?=
 =?utf-8?B?cG9hakd4dXc1UTBCYmFIbWVCdEdOWTE3eEJpMmpFVnd1c0wzQUNoOEJhM2Vw?=
 =?utf-8?B?MkVWdnkzQjdBcWdyeTgwMWU5QUZRZUM1MUIxUW5lV2pDbER5UGRaYmhOb2tu?=
 =?utf-8?B?TjZKekhrbWFCSEVPQVBkWG04TFFGbDJzMFd3QnNVb0tEU3VWYnhJSG96RG1J?=
 =?utf-8?B?SnB1SWNVeVpiQk5tenMxbGtiRFcxSDIrUW4wdXdycnV4VlI0QS9aR3RuQkdV?=
 =?utf-8?B?aWVNN2xFS3ZsZGZBdjFPNFg2enoyK1lTelpBYi85Qk55MEw5Y1NqZW9DcTlS?=
 =?utf-8?B?K2lxY2tQY1VDRExyVGp3RXp4N3AwYUlLOVo1Smg0WkREbWJDZnJteTFWSjdT?=
 =?utf-8?B?NEhPbGlsYUM4RzRtS3ZxVVJVTlpxN3REQnVpTjU1dWFJMDJFamUzaERwdURH?=
 =?utf-8?B?dG50NlFsT09XbkQxcGhsZW5YZXdYamNybjR5eXZHbTRpT1lUeExpc1QvL05h?=
 =?utf-8?B?YWE2TURNalRVOGtJVTNVMm9MdFJmUFR3V0NaWE52bDhGY05ZbG0xbnJPajRC?=
 =?utf-8?B?dHp1UjJUQzNQNkRlZTVIYlFnaWRFTXRtUU1PL3l1aVMzRWV4Nzh1R3ZaQlJ2?=
 =?utf-8?B?OEZPK0I4bHBDMXY1VlVQSmlNUjlERHVGbkRxeDR5QUFiQmk5N2FZa0w4N25y?=
 =?utf-8?B?WkVqeEV2S3RSbS9XOW51TTBuVWcycnRBRHBNZ204T2dFOHgraW9OVzJHM3ds?=
 =?utf-8?B?cjRJV3dOdjJPdGdWRnNZR2FveXBJOUVBL1p3ajdFQ3VIaVd0T285a0xvVUwz?=
 =?utf-8?B?UnRoYWQ0dEUxazZvVVlYNUN6VzhlKzdoYjBoMEYzbjg5UEJkVUxvT0JmVTBT?=
 =?utf-8?B?bHNkK0VqS1FWbEV5ZlBRSnduV2ovOVZuWXQ0MXE4STJOb0REMUVSeFZVOFNt?=
 =?utf-8?B?enNGWmtMUlZsT0o3QmZmMzhtVW5uVHljY3NmZkpFeldyR1ZzcU9qWTBZeTht?=
 =?utf-8?B?NGQ4UG5EQTB5V0lZMjF4MGlaMDIrM3h3SWUwdVR1Q21rRG96c0JFVnR2Y2lK?=
 =?utf-8?B?Z1RULy9CM1ZuL1h3dzVPRHRnVzh3VFZaMmtFTHd6cXRlOGREeWlBM0h5ZzAx?=
 =?utf-8?Q?qsX4Wosb20CanpY2Fo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlFCOWlEWFU5SVhXV2lYWVd5R0RSaUJ3ZTF6VkQxQnV2RUdTQnQ1c3RJRGx6?=
 =?utf-8?B?SXduamFiUVRNaWN2dzBHZU1qcDBlclhCNGFNajQySHhubHlQNnB5aVNXc05a?=
 =?utf-8?B?OVZHb0lHNkFxeTFka1RuOEJkN1U5cFFsY05jUWhsWlJCUTJIVVJpR2pDcGd4?=
 =?utf-8?B?M0dsMGx6VnYwRlM0b2lKL0dHWEU0NWwvaTlzVitaYklXWW5ZZmFHLzVpZDVY?=
 =?utf-8?B?LzFKV3V6UitsSWk0aExNSFc3Ly9lYWpKVWxVeU9URjU3QlhyRjVuOVVCVWFK?=
 =?utf-8?B?OFVxa3FvdUhMU2xjTmpZZ2taeUN4WnczTnE5YXphTHlrTkRoUjByTjhManJw?=
 =?utf-8?B?cmhWUDh3L3kvamg5VmF4SVlqT0xQaksrUlA4TGc2eHJWazM4d2FES2QwYi9N?=
 =?utf-8?B?SzlweTBURld2WVBraTgrT1lGRW50Zk1tQnRsdGNRaUprV04vYWtoS3JwVU5m?=
 =?utf-8?B?am1BVTM4R3ZqV2hLWktDakFiWDE2Uk5TK1NoQ2V4SHo3OStvTTRYRFZJWlp0?=
 =?utf-8?B?MEcyV3ViVm5QaVBBZE12c0lkMUhmdHd0aTY3empLUjlDenZhTHBVemhNNjBm?=
 =?utf-8?B?Y1oxQ3NKdll4eVVhUVpZWGYwaFpMdG5RTnlXeWNPWTc1RlVqMlNSK3UwUGZN?=
 =?utf-8?B?ZHF3VnhnaWZOVmFHMFAvbUxyeGdad0FPaExjWlR1T2pwQk1vN3NtdjcrNHE5?=
 =?utf-8?B?dTVPK1NlcmJHYlRnaGh1RVVlQkdxdDNwa0xwbHFGakNkdUdWY25XOFJzbUhQ?=
 =?utf-8?B?aldORGdPdVdsdHVrdG9EZXJ2amcveHZqUno5TXpzdTFJSXZEU3B0OU1WV05r?=
 =?utf-8?B?NHZCQWJXR0pRWlNNcTFPY25aMTF3YTArVmxrS2sycXNLUk9aemx0TUgyM3py?=
 =?utf-8?B?Njd1R0p4Snd6eVJLT3hUUERhenN4MjdHVDJCNmdpdnpkck9OZjVkbU42bnI0?=
 =?utf-8?B?SnE2STRhMDJFU0JwbG5IU3FNc0E5eDg4U01qQ3ZHbXQrMWN0aW51VEhabEtx?=
 =?utf-8?B?em5ZVXFMeE1kVXlTa3Nhc1ptSyt5aUNicTc4MzFvckptOXh0Y3FTL2IzdEJI?=
 =?utf-8?B?c3o4REFXR0lLUzRhdkc3dm1mMTNOeFBWQ3kyeWVCcGx6azFnb0JIa0NJNDhP?=
 =?utf-8?B?MUVKL0w5b0I4SEhTaXVmUDBIRWRzanB6MGpiTGNYeisrdDFVYWZhU09xOWpP?=
 =?utf-8?B?TmZub0hIVkhwMWx1Y1dvZ1FIY0VBbk1DbENuUlFMTDZxNG1YcWRvRnQzenJT?=
 =?utf-8?B?Q3RJMXFGbmZMVndmTnc3OUlwK3JjMlJtMG1Da05MeURvTDA0c0FvYmdveXV6?=
 =?utf-8?B?cE11cFFuQTgwdFlTUXJjY1BxTkYvdllYY1JjbVpLb21iQUZHRHl4TVQrcHpH?=
 =?utf-8?B?NHI5SEIxZTk3bmpjU2J6M3gwM3BPb0V3ZkNwL3FMNHNwM0MzSHFhNG4vLy9F?=
 =?utf-8?B?cTlpYjlvbVJZMnJobjRDYVVLWmZscXpFYjlWMFdXcEdhUXlzTG53N1E2QmRC?=
 =?utf-8?B?TmN6TXEwQ3lUc3I0TUtSUnRNb2lUc1JMakl0SXRuVlFSOUpQcU9TK1NPcDlU?=
 =?utf-8?B?aVZEN2NBakRVZFNSYjU0dHQ4Y1BsSE1lTWdxeWhBUDhsaW00cXZXSmt1UHcx?=
 =?utf-8?B?WDdabW1mRkR2bkdnYlJZS2pTSWVSRHlHTVVTc21Lb2xzSldENHh2L3FaNWVx?=
 =?utf-8?B?aGxacGVia3F1dk85NklCd1hOUTFtSHAwbzdEbnNxcmVBNkF2Qzg2d2U2aXBi?=
 =?utf-8?B?YVB1a1pDRWFiVGhWUUxhekxIbWVNeXNQdm1pS0drdzVscWExdjc4Q1ZwcndP?=
 =?utf-8?B?S0V1Y3ZZbWxBRlR2Skc4RTFnZHhRckdRS0ZpTXNDdkczMnpVRnlVSTdhR1ZH?=
 =?utf-8?B?cGV0KzF4TklmMnRycDF0czlhTVFwTTB6clhLYTcvWDI2M2ZXaldPSzlWVlJ2?=
 =?utf-8?B?UTBTSjhDT1hxaDNjai82Qk5LVC9IRmV2a1pIUVA2L2h5UlI3akE1OUw4UFlR?=
 =?utf-8?B?TVFxYnA5SUV0Q0xsaUgrRCtvbUZuVG5WeXhSMHlOd2RRLzV6V1FuRnc0T1Rr?=
 =?utf-8?B?dWVWNFp4KzNrRzFjZU1KWGpUMEtleTlsSkgxYlNwSFhvcGp5UVNiQXV5MHFv?=
 =?utf-8?B?eGJ3M0RuSkxCZ0xwYW5kYVVHaExOREkyZTNFSm5rblo4bDVDbmVnWWNtQ0Uz?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3878ABC0ACEAE34EAF862FAF888F4688@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e399f86e-fec8-4dda-2624-08dc74f69dcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 15:49:33.7788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlzf6LZ9BREB5cp7LOsEqBPznupqbNVoQd6XH3zmNyxdCRa+VBgh9Um138vncJ2OPGWZuF+pkS2PICHuvcW3S1OGjC79Zea/MCKrxnHTh2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDA4OjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAxNCwgMjAyNCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4g
V2hlbiB2aXJ0dWFsaXppbmcgc29tZSBDUFUgZmVhdHVyZXMsIEtWTSB1c2VzIGt2bV96YXBfZ2Zu
X3JhbmdlKCkgdG8gemFwDQo+ID4gZ3Vlc3QgbWFwcGluZ3Mgc28gdGhleSBjYW4gYmUgZmF1bHRl
ZCBpbiB3aXRoIGRpZmZlcmVudCBQVEUgcHJvcGVydGllcy4NCj4gPiANCj4gPiBGb3IgVERYIHBy
aXZhdGUgbWVtb3J5IHRoaXMgdGVjaG5pcXVlIGlzIGZ1bmRhbWVudGFsbHkgbm90IHBvc3NpYmxl
Lg0KPiA+IFJlbWFwcGluZyBwcml2YXRlIG1lbW9yeSByZXF1aXJlcyB0aGUgZ3Vlc3QgdG8gImFj
Y2VwdCIgaXQsIGFuZCBhbHNvIHRoZQ0KPiA+IG5lZWRlZCBQVEUgcHJvcGVydGllcyBhcmUgbm90
IGN1cnJlbnRseSBzdXBwb3J0ZWQgYnkgVERYIGZvciBwcml2YXRlDQo+ID4gbWVtb3J5Lg0KPiA+
IA0KPiA+IFRoZXNlIENQVSBmZWF0dXJlcyBhcmU6DQo+ID4gMSkgTVRSUiB1cGRhdGUNCj4gPiAy
KSBDUjAuQ0QgdXBkYXRlDQo+ID4gMykgTm9uLWNvaGVyZW50IERNQSBzdGF0dXMgdXBkYXRlDQo+
IA0KPiBQbGVhc2UgZ28gcmV2aWV3IHRoZSBzZXJpZXMgdGhhdCByZW1vdmVzIHRoZXNlIGRpc2Fz
dGVyWypdLCBJIHN1c3BlY3QgaXQgd291bGQNCj4gbGl0ZXJhbGx5IGhhdmUgdGFrZW4gbGVzcyB0
aW1lIHRoYW4gd3JpdGluZyB0aGlzIGNoYW5nZWxvZyA6LSkNCj4gDQo+IFsqXSBodHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMjAyNDAzMDkwMTA5MjkuMTQwMzk4NC0xLXNlYW5qY0Bnb29nbGUu
Y29tDQoNCldlIGhhdmUgb25lIGFkZGl0aW9uYWwgZGV0YWlsIGZvciBURFggaW4gdGhhdCBLVk0g
d2lsbCBoYXZlIGRpZmZlcmVudCBjYWNoZQ0KYXR0cmlidXRlcyBiZXR3ZWVuIHByaXZhdGUgYW5k
IHNoYXJlZC4gQWx0aG91Z2ggaW1wbGVtZW50YXRpb24gaXMgaW4gYSBsYXRlcg0KcGF0Y2gsIHRo
YXQgZGV0YWlsIGhhcyBhbiBhZmZlY3Qgb24gd2hldGhlciB3ZSBuZWVkIHRvIHN1cHBvcnQgemFw
cGluZyBpbiB0aGUNCmJhc2ljIE1NVSBzdXBwb3J0Lg0KDQo+IA0KPiA+IDQpIEFQSUNWIHVwZGF0
ZQ0KPiA+IA0KPiA+IFNpbmNlIHRoZXkgY2Fubm90IGJlIHN1cHBvcnRlZCwgdGhleSBzaG91bGQg
YmUgYmxvY2tlZCBmcm9tIGJlaW5nDQo+ID4gZXhlcmNpc2VkIGJ5IGEgVEQuIEluIHRoZSBjYXNl
IG9mIENSTy5DRCwgdGhlIGZlYXR1cmUgaXMgZnVuZGFtZW50YWxseSBub3QNCj4gPiBzdXBwb3J0
ZWQgZm9yIFREWCBhcyBpdCBjYW5ub3Qgc2VlIHRoZSBndWVzdCByZWdpc3RlcnMuIEZvciBBUElD
Vg0KPiA+IGluaGliaXQgaXQgaW4gZnV0dXJlIGNoYW5nZXMuDQo+ID4gDQo+ID4gR3Vlc3QgTVRS
UiBzdXBwb3J0IGlzIG1vcmUgb2YgYW4gaW50ZXJlc3RpbmcgY2FzZS4gU3VwcG9ydGVkIHZlcnNp
b25zIG9mDQo+ID4gdGhlIFREWCBtb2R1bGUgZml4IHRoZSBNVFJSIENQVUlEIGJpdCB0byAxLCBi
dXQgYXMgcHJldmlvdXNseSBkaXNjdXNzZWQsDQo+ID4gaXQgaXMgbm90IHBvc3NpYmxlIHRvIGZ1
bGx5IHN1cHBvcnQgdGhlIGZlYXR1cmUuIFRoaXMgbGVhdmVzIEtWTSB3aXRoIGENCj4gPiBmZXcg
b3B0aW9uczoNCj4gPiDCoC0gU3VwcG9ydCBhIG1vZGlmaWVkIHZlcnNpb24gb2YgdGhlIGFyY2hp
dGVjdHVyZSB3aGVyZSB0aGUgY2FjaGluZw0KPiA+IMKgwqAgYXR0cmlidXRlcyBhcmUgaWdub3Jl
ZCBmb3IgcHJpdmF0ZSBtZW1vcnkuDQo+ID4gwqAtIERvbid0IHN1cHBvcnQgTVRSUnMgYW5kIHRy
ZWF0IHRoZSBzZXQgTVRSUiBDUFVJRCBiaXQgYXMgYSBURFggTW9kdWxlDQo+ID4gwqDCoCBidWcu
DQo+ID4gDQo+ID4gV2l0aCB0aGUgYWRkaXRpb25hbCBjb25zaWRlcmF0aW9uIHRoYXQgbGlrZWx5
IGd1ZXN0IE1UUlIgc3VwcG9ydCBpbiBLVk0NCj4gPiB3aWxsIGJlIGdvaW5nIGF3YXksIHRoZSBs
YXRlciBvcHRpb24gaXMgdGhlIGJlc3QuIFByZXZlbnQgTVRSUiBNU1Igd3JpdGVzDQo+ID4gZnJv
bSBjYWxsaW5nIGt2bV96YXBfZ2ZuX3JhbmdlKCkgaW4gZnV0dXJlIGNoYW5nZXMuDQo+ID4gDQo+
ID4gTGFzdGx5LCB0aGUgbW9zdCBpbnRlcmVzdGluZyBjYXNlIGlzIG5vbi1jb2hlcmVudCBETUEg
c3RhdHVzIHVwZGF0ZXMuDQo+ID4gVGhlcmUgaXNuJ3QgYSB3YXkgdG8gcmVqZWN0IHRoZSBjYWxs
LiBLVk0gaXMganVzdCBub3RpZmllZCB0aGF0IHRoZXJlIGlzIGENCj4gPiBub24tY29oZXJlbnQg
RE1BIGRldmljZSBhdHRhY2hlZCwgYW5kIGV4cGVjdGVkIHRvIGFjdCBhY2NvcmRpbmdseS4gRm9y
DQo+ID4gbm9ybWFsIFZNcyB0b2RheSwgdGhhdCBtZWFucyB0byBzdGFydCByZXNwZWN0aW5nIGd1
ZXN0IFBBVC4gSG93ZXZlciwNCj4gPiByZWNlbnRseSB0aGVyZSBoYXMgYmVlbiBhIHByb3Bvc2Fs
IHRvIGF2b2lkIGRvaW5nIHRoaXMgb24gc2VsZnNub29wIENQVXMNCj4gPiAoc2VlIGxpbmspLiBP
biBzdWNoIENQVXMgaXQgc2hvdWxkIG5vdCBiZSBwcm9ibGVtYXRpYyB0byBzaW1wbHkgYWx3YXlz
DQo+ID4gY29uZmlndXJlIHRoZSBFUFQgdG8gaG9ub3IgZ3Vlc3QgUEFULiBJbiBmdXR1cmUgY2hh
bmdlcyBURFggY2FuIGVuZm9yY2UNCj4gPiB0aGlzIGJlaGF2aW9yIGZvciBzaGFyZWQgbWVtb3J5
LCByZXN1bHRpbmcgaW4gc2hhcmVkIG1lbW9yeSBhbHdheXMNCj4gPiByZXNwZWN0aW5nIGd1ZXN0
IFBBVCBmb3IgVERYLiBTbyBrdm1femFwX2dmbl9yYW5nZSgpIHdpbGwgbm90IG5lZWQgdG8gYmUN
Cj4gPiBjYWxsZWQgaW4gdGhpcyBjYXNlIGVpdGhlci4NCj4gPiANCj4gPiBVbmZvcnR1bmF0ZWx5
LCB0aGlzIHdpbGwgcmVzdWx0IGluIGRpZmZlcmVudCBjYWNoZSBhdHRyaWJ1dGVzIGJldHdlZW4N
Cj4gPiBwcml2YXRlIGFuZCBzaGFyZWQgbWVtb3J5LCBhcyBwcml2YXRlIG1lbW9yeSBpcyBhbHdh
eXMgV0IgYW5kIGNhbm5vdCBiZQ0KPiA+IGNoYW5nZWQgYnkgdGhlIFZNTSBvbiBjdXJyZW50IFRE
WCBtb2R1bGVzLiBCdXQgaXQgY2FuJ3QgcmVhbGx5IGJlIGhlbHBlZA0KPiA+IHdoaWxlIGFsc28g
c3VwcG9ydGluZyBub24tY29oZXJlbnQgRE1BIGRldmljZXMuDQo+ID4gDQo+ID4gU2luY2UgYWxs
IGNhbGxlcnMgd2lsbCBiZSBwcmV2ZW50ZWQgZnJvbSBjYWxsaW5nIGt2bV96YXBfZ2ZuX3Jhbmdl
KCkgaW4NCj4gPiBmdXR1cmUgY2hhbmdlcywgcmVwb3J0IGEgYnVnIGFuZCB0ZXJtaW5hdGUgdGhl
IGd1ZXN0IGlmIG90aGVyIGZ1dHVyZQ0KPiA+IGNoYW5nZXMgdG8gS1ZNIHJlc3VsdCBpbiB0cmln
Z2VyaW5nIGt2bV96YXBfZ2ZuX3JhbmdlKCkgZm9yIGEgVEQuDQo+ID4gDQo+ID4gRm9yIGxhY2sg
b2YgYSBiZXR0ZXIgbWV0aG9kIGN1cnJlbnRseSwgdXNlIGt2bV9nZm5fc2hhcmVkX21hc2soKSB0
bw0KPiA+IGRldGVybWluZSBpZiBwcml2YXRlIG1lbW9yeSBjYW5ub3QgYmUgemFwcGVkIChhcyBp
biBURFgsIHRoZSBvbmx5IFZNIHR5cGUNCj4gPiB0aGF0IHNldHMgaXQpLg0KPiA+IA0KPiA+IExp
bms6DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjQwMzA5MDEwOTI5LjE0MDM5
ODQtNi1zZWFuamNAZ29vZ2xlLmNvbS8NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSaWNrIEVkZ2Vjb21i
ZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gVERYIE1NVSBQYXJ0
IDE6DQo+ID4gwqAtIFJlbW92ZSBzdXBwb3J0IGZyb20gIktWTTogeDg2L3RkcF9tbXU6IFphcCBs
ZWFmcyBvbmx5IGZvciBwcml2YXRlIG1lbW9yeSINCj4gPiDCoC0gQWRkIHRoaXMgS1ZNX0JVR19P
TigpIGluc3RlYWQNCj4gPiAtLS0NCj4gPiDCoGFyY2gveDg2L2t2bS9tbXUvbW11LmMgfCAxMSAr
KysrKysrKysrLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBi
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gPiBpbmRleCBkNWNmNWIxNWExMGUuLjgwODgwNWIz
NDc4ZCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ID4gKysrIGIv
YXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiA+IEBAIC02NTI4LDggKzY1MjgsMTcgQEAgdm9pZCBr
dm1femFwX2dmbl9yYW5nZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90DQo+ID4gZ2ZuX3N0YXJ0LCBn
Zm5fdCBnZm5fZW5kKQ0KPiA+IMKgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGZsdXNoID0ga3ZtX3Jt
YXBfemFwX2dmbl9yYW5nZShrdm0sIGdmbl9zdGFydCwgZ2ZuX2VuZCk7DQo+ID4gwqANCj4gPiAt
wqDCoMKgwqDCoMKgwqBpZiAodGRwX21tdV9lbmFibGVkKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoGlm
ICh0ZHBfbW11X2VuYWJsZWQpIHsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
LyoNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICoga3ZtX3phcF9nZm5fcmFu
Z2UoKSBpcyB1c2VkIHdoZW4gTVRSUiBvciBQQVQgbWVtb3J5DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIHR5cGUgd2FzIGNoYW5nZWQuwqAgVERYIGNhbid0IGhhbmRsZSB6
YXBwaW5nIHRoZSBwcml2YXRlDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IG1hcHBpbmcsIGJ1dCBpdCdzIG9rIGJlY2F1c2UgS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBlaXRoZXIN
Cj4gPiBvZg0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0aG9zZSBmZWF0
dXJlcyBmb3IgVERYLiBJbiBjYXNlIGEgbmV3IGNhbGxlciBhcHBlYXJzLCBCVUcNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogdGhlIFZNIGlmIGl0J3MgY2FsbGVkIGZvciBz
b2x1dGlvbnMgd2l0aCBwcml2YXRlIGFsaWFzZXMuDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAqLw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBLVk1fQlVH
X09OKGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKSwga3ZtKTsNCj4gDQo+IFBsZWFzZSBzdG9wIHVz
aW5nIGt2bV9nZm5fc2hhcmVkX21hc2soKSBhcyBhIHByb3h5IGZvciAiaXMgdGhpcyBURFgiLsKg
IFVzaW5nIGENCj4gZ2VuZXJpYyBuYW1lIHF1aXRlIG9idmlvdXNseSBkb2Vzbid0IHByZXZlbnQg
VERYIGRldGFpbHMgZm9yIGJsZWVkaW5nIGludG8NCj4gY29tbW9uDQo+IGNvZGUsIGFuZCBkYW5j
aW5nIGFyb3VuZCB0aGluZ3MganVzdCBtYWtlcyBpdCBhbGwgdW5uZWNlc3NhcmlseSBjb25mdXNp
bmcuDQoNCk9rLCB5ZXAgb24gdGhlIGdlbmVyYWwgcG9pbnQuDQoNCj4gDQo+IElmIHdlIGNhbid0
IGF2b2lkIGJsZWVkaW5nIFREWCBkZXRhaWxzIGludG8gY29tbW9uIGNvZGUsIG15IHZvdGUgaXMg
dG8gYml0ZQ0KPiB0aGUNCj4gYnVsbGV0IGFuZCBzaW1wbHkgY2hlY2sgdm1fdHlwZS4NCg0KSW4g
dGhpcyBjYXNlIHRoZSBnZW5lcmljIHByb3BlcnR5IGlzIHRoZSBpbmFiaWxpdHkgdG8gcmUtZmF1
bHQgaW4gcHJpdmF0ZSBtZW1vcnkNCndoZW5ldmVyIHdlIHdhbnQuIEhvd2V2ZXIgdGhlIHJlYXNv
biB3ZSBjYW4gZ2V0IGF3YXkgd2l0aCBqdXN0IG5vdCAgaXMgYmVjYXVzZQ0KVERYIHdvbid0IHN1
cHBvcnQgdGhlIG9wZXJhdGlvbnMgdGhhdCB1c2VzIHRoaXMgZnVuY3Rpb24uIE90aGVyd2lzZSwg
d2UgY291bGQNCnphcCBvbmx5IHRoZSBzaGFyZWQgaGFsZiBvZiB0aGUgbWVtb3J5IChkZXBlbmRp
bmcgb24gdGhlIGludGVudGlvbiBvZiB0aGUNCmNhbGxlcikuDQoNClRvIG1lIEtWTV9CVUdfT04o
KXMgc2VlbSBhIGxpdHRsZSBsZXNzIGJhZCB0byBjaGVjayB2bSB0eXBlIHNwZWNpZmljYWxseS4g
SXQNCmRvZXNuJ3QgYWZmZWN0IHRoZSBmdW5jdGlvbmFsIHBhcnQgb2YgdGhlIGNvZGUuIFNvIGFs
bCB0b2dldGhlciwgSSdkIGxlYW4NCnRvd2FyZHMgdm1fdHlwZSBpbiB0aGlzIGNhc2UuDQoNCj4g
DQo+IFRoaXMgS1ZNX0JVR19PTigpIGFsc28gc2hvdWxkIG5vdCBiZSBpbiB0aGUgdGRwX21tdV9l
bmFibGVkIHBhdGguwqAgWWVhaCwgeWVhaCwNCj4gVERYIGlzIHJlc3RyaWN0ZWQgdG8gdGhlIFRE
UCBNTVUsIGJ1dCB0aGVyZSdzIG5vIHJlYXNvbiB0byBibGVlZCB0aGF0IGRldGFpbA0KPiBhbGwN
Cj4gb3ZlciB0aGUgcGxhY2UuDQo+IA0KPiANCg0KUmlnaHQuDQo=

