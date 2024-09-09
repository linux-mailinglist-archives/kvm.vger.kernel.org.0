Return-Path: <kvm+bounces-26110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D704971534
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B6FD1C22276
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 10:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CEE1B3F32;
	Mon,  9 Sep 2024 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GM9WcPUl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103251AC8BF;
	Mon,  9 Sep 2024 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725877281; cv=fail; b=PnT/u9PkRxwNoMiXZcKxRUXRVDw3Wam+/YJPryiCW/FZKXjAjOfX7kUJRuRivDE7Gj6JEPjAmYrjXE7n8HRXy30dXQqa2Tomb5SJrUQ3+8C0uhYcrON9larTmfkZ9cXY11oOC2d4EcoinD1pJyKpT6GMBVvfWy8CrRauWoBdsrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725877281; c=relaxed/simple;
	bh=2CtM7cNM0TQP5S74oKup/zfyoyHdtClpe2wPn5u5224=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oT6IVl3oNAdlT+fpk0hxwJWxvbkPkL28aIVjFgtLQBiJihkRtCVHJ69q+upEqHK/cCRvoeIZ26yPXyFSaCmKBDE+3lAOoEzCY+8epNPAxBl3dZN1ZKhrqR1ES6mw2GhidKq3jqkDassX7NV+02vP6w0oohm9r4+O7aRfcX2lq6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GM9WcPUl; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725877280; x=1757413280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2CtM7cNM0TQP5S74oKup/zfyoyHdtClpe2wPn5u5224=;
  b=GM9WcPUlZ4q0cTR10BruhSV6tZzCZsmrHH3/Q5ifmpBTl4aYctmh7f/w
   C255YmG14cZAcKe253PwVcUz0lBwg+Q4B05opyYnd1nOalNMQLyWmlVfo
   fC/UZaxJwy/FyqwcBiHTISQTjd6sXofCMGewmTHsMDfUTnYO8PcfS/xuv
   vx4wu/Si8Pv/6sVoEjiqaaFUpz2ZtdHfu2nVE6wj0+VZpw6yKOJolEXA/
   P3bWx3GMx/A18W487wtLYkQC1ssdpTOZNupv0r6QFMtaZABxSAKxHL3Gl
   YvEAAVenZkubNmXiaEB29f+3A1WfCAJINyn4+5tcwbZ39xco7qDgi4O5N
   g==;
X-CSE-ConnectionGUID: 9sIguWGURXqJtrVGUAaPUQ==
X-CSE-MsgGUID: RFJ5QsPmTu2ufpWePaJBVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24759480"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24759480"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 03:21:13 -0700
X-CSE-ConnectionGUID: V/BJhncTQn6FgDWi24z5lA==
X-CSE-MsgGUID: 2JUuXZjESAmEBt5u9h3YHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="71418733"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 03:21:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 03:21:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 03:21:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 03:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqMfSOi8Dmm4l1/PwMpx3APkFguEubUk+Dc6CMempAZXd+Ks4Xr6fdiQ/W7G9gflPCerHpYe4vGQ4TZAG3p2JIdkUkljRwBfoLBEsbYqWC48qRi4ae1MNQ5bqVBtDSarCAr3C9xjusWXowr0ztcZT2BU0E9QRQY8CZE6+iK2QI88AF+lotpSA4K9C65y23PVFkfABlAKJBOm7tM4UK3G1+KjTrCNE6m0CO1kxpiQHGN9O0glTwAy0X5Qr9RarQQVO7jq1SJQ/tJagrD8iDUTSS24tw4Cr0350jLesEDgn9NlZC2qBfwjEpeXk/mQtAOXXc45RvSZeonhqt4IdDfOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CtM7cNM0TQP5S74oKup/zfyoyHdtClpe2wPn5u5224=;
 b=xc78nMgwQdwGEGIspkn6ighmVNiPiStrxyxCKVTMfnNxVE9E+5Ns0iQ9F5P8OUdKRlrPNGn4u9JCMG7XeVkXziD6zYmvQH+S1touPoZH2hg2b+yOIOzF2U7oY4bGweAZw+cTOwB1UvCS1Ab5Ei4RHrKrCBgJP29Leoeou1nS7M5ZdQ8kRPTWIVaWRtpMKOrjmL0qpOrDW/gjOnRdui3ONC9JI9vjgiQd8J5axAMOOj/5IDwWvRXWIyOKNkZOmwpOYJEYnjAX14x1OU1R9Bn60EmlscHRNzEILb1wsiQE+3A7IVhmNc0VbRZI2oxq0CB90+6X/lxsfDzNFuRf0DtaTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Mon, 9 Sep
 2024 10:21:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 10:21:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 8/8] x86/virt/tdx: Don't initialize module that doesn't
 support NO_RBP_MOD feature
Thread-Topic: [PATCH v3 8/8] x86/virt/tdx: Don't initialize module that
 doesn't support NO_RBP_MOD feature
Thread-Index: AQHa+E/3P+SdiHiIvkuM1k+uG63A47JLeqgAgAPYp4A=
Date: Mon, 9 Sep 2024 10:21:04 +0000
Message-ID: <9856f700e197c9c27319bb1c5ca7f1a24cedb2f5.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
	 <66db92101b565_22a229498@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db92101b565_22a229498@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6798:EE_
x-ms-office365-filtering-correlation-id: a02980cd-5c81-4f48-a59f-08dcd0b91c39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXZTRG85aFE4ekhadncyVHFmUkxCa2Z6ZFNsQlBOTDkzaVU0cmkxMFFyTXJY?=
 =?utf-8?B?YVZKeVB3R3BhTVQ5WjZ4cktkY3FQUk1pbzU0YVJNNmdjNGoyNW11VFlCNjBh?=
 =?utf-8?B?Uy8wdDFNcnBRbm9jY3pab1RTMXlyZE9LbzQ0M01lWDAvM1U3dW9Qc01saUxq?=
 =?utf-8?B?SS9ueTBvbGhRMlVmOEJtN0dSMURRVDdMc3Z1amtKanc3V0pvYzYrNWVWUU1y?=
 =?utf-8?B?UWltYXU0RnpMZ1NSdXNJVzNKcTZzc2s2YkZUclcycHduMy84V2ZyclhoeHkv?=
 =?utf-8?B?S3lpdktkYmxpUXVGQ0d0RnVKc2FjRTgwbGZ5ako1dWV6MFAvYmdadVo2d0pZ?=
 =?utf-8?B?K1JiZlZIcmIzUEFhc1RYMGJ5UFk0YmtOVDhmVlBQMHU4UDRacFFpNnMrUVJt?=
 =?utf-8?B?clVUUDNrU25DZ0lDM01xRS9JYnZwTVVUVUl4ZDNEa3o5ZVM4RzN5c21Tblk1?=
 =?utf-8?B?RzFjaW1EOFQrV0xhbUloNUZkMHBXWHpJYUMwOHJrZ2ZLaHFpNzNwN2dJOVNC?=
 =?utf-8?B?NDdkM2Qzb0h0MU4rQkhPSjR3S3pZdFlLRTFHemhFLzFjQlgxSitaQVp4emRo?=
 =?utf-8?B?ZjB1Ky9tamhKTmxmdURaSG5zdU1oUG92UHk1bVFNL3h0dTlWbkRncmdXdEZL?=
 =?utf-8?B?cm5teFRMM2lYbHQzVDU1RXI4Tk9jbFdYQWtodFBDUS9EdlpQWDRiY2tCeWdE?=
 =?utf-8?B?eVVGZ21aRmNTTVNtUjJkTDZ2a3F6NWs1N2ZtSWdKOGF5MEtPV1A4czN3TFRq?=
 =?utf-8?B?aE9JOVY5SGNXbUJKU0orVURwZzJqb1ptMEltWU8wdElrZTVpdFNRU3NoMXYy?=
 =?utf-8?B?QndLcE9kdkZTTTNkS1VDL0RYSUNNR1g5bGNSd0xocnp6U1RqNnZ2VkFFQ1VB?=
 =?utf-8?B?SEw5bFVYdFIweGZ5SlpjYzlZcjRzb2tnV3QvWUFWVTRSYTE4SGZLc2hVZFUv?=
 =?utf-8?B?UmRmaTVKSG01anlwazFXS3ErUWxQUnBXbFdZbm9UUVFIdWsyWmE3N0RQL05G?=
 =?utf-8?B?bE5VaTk0bFpnVUI0bXNmNWp6Qys2cDdFN2FoL0F0alpDVlJNRFR4TDVHZGQr?=
 =?utf-8?B?dGlwMWpLUk5wTDRNM3hLWGpFS2RXY3NkOHdSWXlsSFFuc1hYVnBESVk4ZlBu?=
 =?utf-8?B?Z3A1WnEyZm11d1RxaS9MejdMTktSOEg2cXdvclB6Rnp0aHlNYm5HTG9nbkJI?=
 =?utf-8?B?SjZYdFBEOGpQVC94OUwwek40RmhJbXBaY1phRGxsdmhmT1BSQ0EwOXZtbk1V?=
 =?utf-8?B?VllLQXNEU01oQjB6eDlDdEx4NXgzbitFNklhYzg3clE3dkRMa2RCTjgveU1N?=
 =?utf-8?B?QVNYOGFFSFhMSU5STlZPN3o3dmVZNXVQNmcvVjduUVk0ay8wc0VhcGJnZHZu?=
 =?utf-8?B?RjB4c1FrQlpucjdUQy96TzVJaTQ5SmhDU1Z2OHNrdDRCK0Jac2xhaTN2ai81?=
 =?utf-8?B?VzJoTGFWdjBQbkNSS3FyUkFuN0ZGc1I0ZVZjNzI2eXVCelhzakdwQWRUSnFw?=
 =?utf-8?B?WlFrbWRzNXJEd1NlQ3ViZWF1Q2tvYzVIR1N3eWlsUG1uSnkvSHMwTG4vOEdI?=
 =?utf-8?B?OURnRXp5ekJQMDk4UTd4SWlqTll2b2FyM3Z5c0VGSU91ZzBGRWNYNGRJVmVr?=
 =?utf-8?B?SHdOUUNWVE0veGczVGJSMnZ5MGV5RUhZS3RrTnIzNU5SYnRJNmVOK1FpRXhQ?=
 =?utf-8?B?WTNJTlI3R2FSOFZ5OGhsTXJUQ20wM3dtcGFxMW1QN25TK0kya1Rkak5HNmFB?=
 =?utf-8?B?Z1krcVZvQklUZWx1bVIvUTEwZHN2d1dKK3JYYU10L3dJdXpJQXg4NS9GWGdZ?=
 =?utf-8?B?TWZTa0s1eEdyUHpHMjZ4UG5aZ3RFMEV3SWdkL0VCQTkxWElJRUpjWWZvTzNH?=
 =?utf-8?B?NzBkbnZjVnplWE50ZGVRb21TSnk3T2M1bTBodEVNbFdYWnNVeXYycGxOZFRM?=
 =?utf-8?Q?y2c5iBqpFVJTd/mwxBF2ahQDSXvYmq4y?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE42eHIxTXgvTmdOdjlaZTlLbHVwWm0rNzZTT21pajU4Y3pSbTN0cU9vZWVD?=
 =?utf-8?B?UnNldWZjK3Y0enlVYkhJUTVwRE9NdEdCSGM5SjBWcHltWW0rLzl2TE5scXRD?=
 =?utf-8?B?TVJScFNjU2k1RjRzL3FKemh0V3BJUVBtMTZzSHhQZHZPRFJIM2M3RWhXUm95?=
 =?utf-8?B?eFZZR0xabjZMOGVJbGtlMzB0NlFHK281RG16ZzdIZ0pYRjhpK3RORkFrdnVR?=
 =?utf-8?B?Z2hWUFc2VkJKdzlRK2RRK2lnWXY0V1JoSzhyTjgwWmhsOGxZdkRCU0tMWk5p?=
 =?utf-8?B?c2gxbjQ3VjVkYk9JS0RFcVExelNRWDVkbmFGK0d2ZjNTbjNlVk44UXo4UUZ1?=
 =?utf-8?B?SlZCWXVaM3VQem00R1ZqV1F2bnBuM0xiVmc1SUdrL283a0xQUkpSSW9FY1Ew?=
 =?utf-8?B?SWFsVk9uZmJ4UjZLTUFPdTdnSGprT3AvU2RuUVV0bVI4LzhxdkgzSzRLUTA5?=
 =?utf-8?B?Nm0zUzM3VVhHSm9DT05oNEpSUVI2OE5zWmdOMXJiQk9NSHF3ZEVYYVdGaEZO?=
 =?utf-8?B?L1dRZ25xQlNYbHNscFNOVW9GRFpRMjhXN29wM1ZhTzh2LzRXQ2tTQUpHVW0r?=
 =?utf-8?B?VzVra1I4cWlGbGd4d0dnK2pXam9CNk95NCtwL2VaQTJ3UzFXYzJzMjhQNnZv?=
 =?utf-8?B?STFkMjBYYTA0aEllTVVWMUpGVGJoVytBQ250Y0pkZU1zVXI0VFFnQzJzSHJl?=
 =?utf-8?B?T3dHL3FIUG1LWnNHUE1mS0FwdTRSTCtMUk96dHdrbUJVYnRGeXBIY2dYMVVm?=
 =?utf-8?B?YTdiUFNSa1Fqc2tvS3hORzVOYUtBczF0NWNKSFRvN2pic3lkeUR4czN0L0Jm?=
 =?utf-8?B?aUVvY2oycUdWODl2TEVIQVZiYXhZdGo2TmdtTzA1MXVaTXVhYTVyakoxWHp5?=
 =?utf-8?B?eTd5ay8xSWRoVmJ5d1RzbVRpYkpvNER6NjF4amhFK1JiWkJyYW1EY2VTRXV6?=
 =?utf-8?B?QTM1MEw5dXU3OHR0bEZBaHNFM1hYVFgwbmVjV3QrbFhlcUdBa3NwMjR3Yjgr?=
 =?utf-8?B?SDhnUFZ0Q0pmRmhKV3NhY2dYcFVZaFhyaTBvcGdkVTNqbVdOb1V1VFFCd2dq?=
 =?utf-8?B?VTVqM0lyUzJoYkFaa0tibnRURHpKeFdGZHRnQ3JxbDJLdlNITWNJVXdpMDVo?=
 =?utf-8?B?bkV2YytiMnN0bGQ2LzhBemlsVk1JYTB5U0RhRWtEREVtaW9RR1lKMTJxWThW?=
 =?utf-8?B?OUxGQS84YzQyeGFuR3JkWldwYysxbmZXeHBCbjNGWFgzYkJISVhnZXliOFJ0?=
 =?utf-8?B?WWxZbklyN3ZPRERRK3dBMmFwRE1LbGpjVU9GSkg0T3FTcGF6QWowT0lJTmxZ?=
 =?utf-8?B?azNRSUNXRWxxbTFHbGlTbGd0WWhRT0huZ0ljK2wrV21iamlESDlqN3c4ZEYx?=
 =?utf-8?B?OVdjd0tGV2lFSlA1dFh2dG55YW9yL1NsUERNblYwS0ljVEFRUys0dmZBbnlZ?=
 =?utf-8?B?YU0veFNRbUNUd0UycW9jZ05xSStLMGI4ZW40STQySUhENStVbHNCNEhncVRQ?=
 =?utf-8?B?WDVabzlRVzE5QnFRYjJBUURaeGtEUzJMRWpFaEs3YmpjY0E5ODNyajJEWkZO?=
 =?utf-8?B?ais3KzN5cDZ5eXFWcmFhODFac2NSeFNsTzBCMzdhbjVSbytqREdQeWNhNWFZ?=
 =?utf-8?B?N0tQTEtGVFNpMGx3enErdGdaemhzb0srVGFIV01Pa1VPWHJXZ0E2UHZxcmRs?=
 =?utf-8?B?VDIzMDV4YWw1djhpSjZSR3VrazRlV0V3dXA2aTY4MlhNZmhka2F4OWpOc2RS?=
 =?utf-8?B?RXo2LzJRMTZidGc5SlMrcDF4YzhzNFNrdzZSZmJVa3UrU2VCSDRtVmwvK0pU?=
 =?utf-8?B?dFpoUjJ3bXdWTjZDSmh1S09wNFVaZkxJTVlGZmF3bVRFM3FKRDJoTUJQL0Rk?=
 =?utf-8?B?b1Zmei96WXpvTnlBbWZKbmQxY1EwK0hkMGVmVHhlS1NsdS9GVWhzdXJnRXp5?=
 =?utf-8?B?SXJoRHYvS2xPdlFzWG9LZW5NNXJmNVZRNEprK2l5eVgwMkFremtwS3lDUzR0?=
 =?utf-8?B?MTdsSk5ydlhXNGNISlZ5TThmdUFUOWdnbWNUdmN1NDN6QXFsRVJ3aHhOd0x3?=
 =?utf-8?B?Lzh4b1FoSnlkdTZjeTI0QkFTZDZHVW4zNDVSZFEzNXlvamRtUmpBVXYxajVU?=
 =?utf-8?Q?uxtx719Yq+0reeOoYizwJQvXP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BA0A0FE1DF27A4088DB0328BDE4085C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02980cd-5c81-4f48-a59f-08dcd0b91c39
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 10:21:04.0536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +IQ+9nIb83dFze/nR0e5nhYumnqAmnM8SD69YUcThyZDFjcm09AtPQpqyUdYFffBMCiF7F2w3HiFOQXoV1Nplw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE2OjM2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEhvdyBhYm91dDoNCj4gDQo+ICAgICBTdWJqZWN0OiB4ODYvdmlydC90ZHg6IFJlcXVpcmUgdGhl
IG1vZHVsZSB0byBhc3NlcnQgaXQgaGFzIHRoZSBOT19SQlBfTU9EIG1pdGlnYXRpb24NCj4gDQo+
IC4uLnRvIGF2b2lkIHRoZSBkb3VibGUgbmVnYXRpdmUuDQoNCldpbGwgZG8uICBUaGFua3MuDQoN
Cj4gDQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBPbGQgVERYIG1vZHVsZXMgY2FuIGNsb2JiZXIg
UkJQIGluIHRoZSBUREguVlAuRU5URVIgU0VBTUNBTEwuICBIb3dldmVyDQo+ID4gUkJQIGlzIHVz
ZWQgYXMgZnJhbWUgcG9pbnRlciBpbiB0aGUgeDg2XzY0IGNhbGxpbmcgY29udmVudGlvbiwgYW5k
DQo+ID4gY2xvYmJlcmluZyBSQlAgY291bGQgcmVzdWx0IGluIGJhZCB0aGluZ3MgbGlrZSBiZWlu
ZyB1bmFibGUgdG8gdW53aW5kDQo+ID4gdGhlIHN0YWNrIGlmIGFueSBub24tbWFza2FibGUgZXhj
ZXB0aW9ucyAoTk1JLCAjTUMgZXRjKSBoYXBwZW5zIGluIHRoYXQNCj4gPiBnYXAuDQo+ID4gDQo+
ID4gQSBuZXcgIk5PX1JCUF9NT0QiIGZlYXR1cmUgd2FzIGludHJvZHVjZWQgdG8gbW9yZSByZWNl
bnQgVERYIG1vZHVsZXMgdG8NCj4gPiBub3QgY2xvYmJlciBSQlAuICBUaGlzIGZlYXR1cmUgaXMg
cmVwb3J0ZWQgaW4gdGhlIFREWF9GRUFUVVJFUzAgZ2xvYmFsDQo+ID4gbWV0YWRhdGEgZmllbGQg
dmlhIGJpdCAxOC4NCj4gPiANCj4gPiBEb24ndCBpbml0aWFsaXplIHRoZSBURFggbW9kdWxlIGlm
IHRoaXMgZmVhdHVyZSBpcyBub3Qgc3VwcG9ydGVkIFsxXS4NCj4gPiANCj4gPiBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvYzAwNjczMTktMjY1My00Y2JkLThmZWUtMWNjZjIxYjFl
NjQ2QHN1c2UuY29tL1QvI21lZjk4NDY5YzUxZTIzODJlYWQyYzUzN2VhMTg5NzUyMzYwYmQyYmVm
IFsxXQ0KPiANCj4gVHJpbSB0aGlzIHRvIHRoZSBkaXJlY3QgbWVzc2FnZS1pZCBmb3JtYXQsIGJ1
dCBvdGhlcndpc2U6DQoNCldpbGwgZG8uICBJZiBJIGdvdCBpdCByaWdodCwgdGhlIGxpbmsgd2l0
aCBtZXNzYWdlLWlkIHNob3VsZCBiZToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2Zj
MGU4YWI3LTg2ZDQtNDQyOC1iZTMxLTgyZTFlY2U2ZGQyMUBpbnRlbC5jb20vDQoNCj4gDQo+IFJl
dmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCg0KVGhh
bmtzLg0KDQoNCg0K

