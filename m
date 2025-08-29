Return-Path: <kvm+bounces-56358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E34B3C286
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAAF93BE724
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953983451AF;
	Fri, 29 Aug 2025 18:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FtFlhPeM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3C2749CA;
	Fri, 29 Aug 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756492488; cv=fail; b=KyoBsw4CCXcw7xuNsZy7SYjzWE/mCDX494QciNSdZrOaOVqnKkwduyM240Jf6oEu82RE+4G/p1UPcx5ruv4mnFp9wlu0C1cpyP8T9jNGd+5txzGZbg/Qd0Fw9YTbnfueKCjDVzErbingp7jONEgFUy/FN6fUQtS4UcTSjfJgNTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756492488; c=relaxed/simple;
	bh=293VhPvFnPeR3HtAsLkiXP6M8AsawmI0HkdkoeFScrI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SLhOtCSPjoduXT5FLO4OD8W+u//sr0sfC7B+L1jmp58KbrhdoUyvilJAXmSJDTlA6vhDo355oRYRKbneLj0EX3JRcNy9ccsPvY+DLZe0Kt+lxU3VvKhTCNYs4JVNXNWjxQGtT84EqEg9p2jQeD0uQutwMBk14rmFUo1kvOz4EbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FtFlhPeM; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756492487; x=1788028487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=293VhPvFnPeR3HtAsLkiXP6M8AsawmI0HkdkoeFScrI=;
  b=FtFlhPeMSRJDg7uxFHqu1WZNpLHd1sjY7XyL5ul1oW7sJMJSrrRE8Iil
   yX30IReQ6Ilx5F+PHOUX43whgczcNDdRH4Jh9hbTV/FN9pJIaKdUADeF+
   Vc75+O4Ulp+AVtMekbNIPsTC4oAY9NfLDFHqeM3YlnpN9STy2DZRQsJUT
   964qZtuCTVpjqztQ3hDFijd5kD0VAcB3Sw0/aiweVZ1/BX+bxeEQG3e1c
   +/+mSmNqWAed5JlsHlqJoBDkUd8CBFveVM9ot+mczy3+UxpIRaJJ0FChg
   ybDMs6GBOsTnMgSj9Ia+x4ZqPvaY3I2eYKaG8UyMBFab0kAh4GNrenClH
   A==;
X-CSE-ConnectionGUID: 2tK7vTbRSnaFpEQARHkVFw==
X-CSE-MsgGUID: YMyx0E1nRy+Rc9guKeCC3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="76385048"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76385048"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:34:46 -0700
X-CSE-ConnectionGUID: VPgs3WavSoSVc2vcmx5zQw==
X-CSE-MsgGUID: DaO0VaHFQQKkMahP77e0og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175743240"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:34:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:34:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 11:34:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:34:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZ7O10y2YSsCLqlgH3FBfpgBZxzsmfe9X9ROLhgQryb+PRQLOalPUAaxRNMGMxH+Pkqv86Imkvz+PAH7ScasobUGpqGcA/hpPUMaL/B6zI2+wIUf1xKtx51mZX57CPoDutbro8v5kLB08aZ/V/UP/SBj4d0u6zs+sfw8yfSOqTiCQcgnLFbwyyKWgIRF/q5uqNjW4CklsziquJVyvTprkuekGWv2cYrLc1QFSn/p7mCPdBdbBw6sYSrIvcGICbwBbMfZobSFMZ+6eEDIw+V/LDoIp1TG2oXx+bjOjHc80PeQ4B0gPVwUCRClHJAfcJzOzGkxDjREXdKNYxh9I/hP6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=293VhPvFnPeR3HtAsLkiXP6M8AsawmI0HkdkoeFScrI=;
 b=g3UM69WoB3DfHAu/v9aGKaiP3SKeR3QswYWUHuqYOBtrb+exSdu5OuU35U2IGCXD3G8UkNAWQU0FIx2uRt7h55Q0aFbWlAS4QXUyrQNscAHeAW3ObHB28mxUecqtaqToPEcfUbG31mRCR7KXgOxAOUekhy8LqGFDBB6VUxIRVlfCqJkqI/i+jK0n6qx9CBORgjU7JuIxiLVixKiCfladLN+YbQG60N8BswLvhWSjy0KA4mG8PxR1yh03uJWFZrFwbiHQuG51Bsc6h2K4d6tRwjbgMI8IeNyKCvvN1TWLB5vkwAo/zSGrdPQwIG9r8qx1m9vWBompDq5GjlDvjGirHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8748.namprd11.prod.outlook.com (2603:10b6:408:200::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 18:34:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 18:34:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 02/18] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Topic: [RFC PATCH v2 02/18] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Index: AQHcGHjMCiojfeCCEk+h27qMiqup77R59jQA
Date: Fri, 29 Aug 2025 18:34:39 +0000
Message-ID: <0a7785b3e985ec98b7f94f149afabdb86efb08d5.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-3-seanjc@google.com>
In-Reply-To: <20250829000618.351013-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8748:EE_
x-ms-office365-filtering-correlation-id: b7e988c6-2161-4f77-9592-08dde72ab6b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V1R5QnE2V0s3QVBveFZPY2EvKzJaOWFKdDBSbXc0RTNQc0JUR0VTQ1hBTytU?=
 =?utf-8?B?OVVzWmR5RVllS1NCTGh3cDZ2N1FJMFA2VlV0cUtjNXk5MElaUjQrT0dPUVp3?=
 =?utf-8?B?N2xxSTV6aGlHNktLM1JNNmt4VS9IcmFSVFBjYUFjby9qeUwweUtnZWhwajdD?=
 =?utf-8?B?U0ZmRmpxcFlyY3VzcFZESkZYQlZjTDFOUG9mNjFHejBxMmpyUGZyRjdnbHRY?=
 =?utf-8?B?SEFveHNUZUVnaXZJcGlvSHl1OTBVQU01anBFQUxLVEl6KzdhVDlYcTFISjhP?=
 =?utf-8?B?MngwMHoyZWpoNHFsTnJ6aFhSeUpQZEFzeS9PejdORVBaOUlwWUxhL1dLTGc3?=
 =?utf-8?B?N0M2TStEM3VQaVJwcFNYUVRWbCtTdTRsQ1VzQzZHQWFsYk1QUCtzTHUybEZD?=
 =?utf-8?B?blRsVldWcCtYa2xQemVHVUJteEpETnk4elpacEE2V2VDckt5c3grQUV3T2Zn?=
 =?utf-8?B?V2hDaEQycFhmM0s2QmxwUjhUNmNNSU9leEZGR1Q5S3RPKzl1TzZlQmRBWmsy?=
 =?utf-8?B?Mm9MeThHanRSSnpWRGJsYlZaLzBLa2swZDJSK1ZGNXdWengyUWFJY2VJNEZF?=
 =?utf-8?B?TnVFWVp0ZkhlWXVzUjV0akhURm43c2x5TnJZcWFmVmlVZXk1b0d6NXZtakYv?=
 =?utf-8?B?M08reWU3eEd5RThXa0l3emtKTjA5UGdFQkF5VjByWjZ6VUE3Z2lLTXlUbUZ3?=
 =?utf-8?B?RUdRRURYY2RqVVd6eXdvUlBreXQxeGZhS3IxV1FKdU4xUXFXRFo0TTZ3c0N5?=
 =?utf-8?B?ck9ZbnJlRHE4bDdiVGtNRTFWb0ZHU0ZTSStkcWxUVVpUZmxaTEVtVG9OS1Rw?=
 =?utf-8?B?ME5VOUZETW1SWEVvOXlLRU1sekp4b0RYZG9NaXRMV0VDcTlGOUhnc0JYbEp0?=
 =?utf-8?B?RjhrTTJVMlVjZGdvM04yM1dkNkkxd1hvRkN2N0RhU0xqeVAvYlhpTEd5bllF?=
 =?utf-8?B?K2NTNitKRnpiV2huTDVFekFqcWE4ZUUxRjdrV3N6aFZhYkNab244NzJwSEJt?=
 =?utf-8?B?aHdwR3BrOTY2V3laMWZBbkZzV0V2S1lVOVV0WWNMc2ZHalIrOWFTYUYrTnNF?=
 =?utf-8?B?TWM4cGlhUFpVRk9qVGZzcmh0QnFhbHd5d0V4THMrNUJsenMwT241RGxaeGV6?=
 =?utf-8?B?U0J6TmtYWCtNakRTZWpJb0RkMGVIWE9LWm91RXZhUDRNc1FVSXFBVHFlVkZh?=
 =?utf-8?B?VVdXOFpjTjRDRTNWTFl5WENEbzNZZlpmaWx0MjFwMUNBeXRVdGphVVdrMmJ6?=
 =?utf-8?B?M3kyZDRLSVFOTWxPdUxFV0gzQ3VWSkFFSTBaNDk2N1RaM0w2aytrSW9NWXJv?=
 =?utf-8?B?VFFmbjg1VkdMd1FnV0U2ZlFWUytpcjEwdS9OSVlrMW8zNWNlSm93Mm9ueHhC?=
 =?utf-8?B?alFVdnlML3cxc0R1SHlrdGhGeGtWYlArUlhDdkRwSHVkUU5Xc3UxaWNrMzk4?=
 =?utf-8?B?a3hiZFl0N2dqT21OT21DaFNXWXN4L0ZTeWxEYkxodmhTWlpBRUtLWGpoL3pn?=
 =?utf-8?B?bXhDc0tObGxNU1l4VnZoL2hKcUMyTGkvZ1VETFprV0RabGYwWGh2em1sZFhj?=
 =?utf-8?B?cXo2ZDV1OVRML0xRSnQ2c1VUc2k3Q2YzNlYyd2VEa2hUZFo4N1NjSkZjVjkv?=
 =?utf-8?B?U04rc3RJd3pkYU42NDlrRy9iNVJVRnFtNThLVUxZR3oyOXgvYnQwN1VqZWgv?=
 =?utf-8?B?MmNMQldvMXowTW04QVNrMWNPVVJmeG9IQ3h3QXBYbEl4QXQyQ0M0OWxaaExK?=
 =?utf-8?B?UHB3MWdwdVh6VW9UV3RsMG11V29VMHdjeTc2OUxDSlBxMFZJZys4SEkxa3Z0?=
 =?utf-8?B?S1o2US92ZGR3VDZmVzJHNU1HVlB5ajdoMFhYTStiSGk3TEZmU3lRVTJwd0hR?=
 =?utf-8?B?QzJQd0dEMzVqLysvWjd5WUpZVlFZcHV5bGZZMWEvTFJiU2FHVjVaa3BNa1dM?=
 =?utf-8?B?cWFDZTlxeXN4dEIwMGxDRjdPNnlsbUJvRFJjQkRjWUdOVkVYaGUvM2ZpNXMw?=
 =?utf-8?B?OUY2eTkwWlNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WSs0bkFhTUdmWXRsWjV1ME4zay9SZHpWZ0FTblhoclFHTld2VGIvcytZeDVQ?=
 =?utf-8?B?WklTQ20wMy9wRTlmdHFkd2hLdy9RNlpPSmo2aUQzb2cva1pKY2dURTViejhW?=
 =?utf-8?B?ODVpTlpqQmhsK2YyT2Q3QS9BSUw5OFlENVJLWXBGeiswRi80SGdQUldsVkt6?=
 =?utf-8?B?T0d0eE9HL0l5RzlBZlZHc3pTenJZQkV1ZEQwRFA5eHRDdDBuZytWWjVKR0NU?=
 =?utf-8?B?ZmhhbEJvSkdIQkFNUG1FTENnZTdyZW1TMDRneUxDVllLRnp4cFljemtvYVh5?=
 =?utf-8?B?SzdZeFhOc01wcWVyZnlxQnJJemRVc3MrQmdUaDJBY1E1MkZ5SE9iWkluU2sx?=
 =?utf-8?B?dElRdW56T3VnRDB5NGdhdTg3UHJLakp4V0ZZOVE2RU9naXBHbnc0UU1FYVd5?=
 =?utf-8?B?a2d1TlU4QzVCcE1RbjNLdzdnc1pSQkNkZHMvVGtaOTR5VFAvQ082bkkxR2NQ?=
 =?utf-8?B?OWdpTlZBc1Rpa0VWUi81c2N3WU1OZUZtbGRMc1BCa2pFWXUxTjJKdWhFbUNj?=
 =?utf-8?B?TCtXdnd2QlJEMThtVWtvdzEzK2gvYU1KdzgydVpBTS8zaFlGVWNOZld0N1NZ?=
 =?utf-8?B?UVhuMUJLZUExUDk3UGRiVWtac1RkZTlLdUh6bGcxNGpZUGlFZHB2eU1QdkJM?=
 =?utf-8?B?bnV5VlJuYzBaRjQ0QWlxVnc0M1VrRTRPcGpZR2d4dUtaS3UrTEpZL0pZbk5x?=
 =?utf-8?B?VFBoYkNPWnBlcjI4RlJkZHBYS0t6THN3RUdITk81Q2RXai92akRGb3VVWHFO?=
 =?utf-8?B?b1NCdVJHTDN2Tmw1dXRKSVc1VXU5bXk2eXV1bGhYZ2ZONGJSVGFHa1lNUFlH?=
 =?utf-8?B?NXJuTjF3ZU8vZUFFTUswNVRsaUtBVVNEV2c3azJ1NkZaNlhMVGp2ME5TTFNY?=
 =?utf-8?B?TkdFTDZPcXRjZXVhNmx6SFpSejNOQlNmTlFrQ1p6Z1F6YktSNGFoV0JsQU9L?=
 =?utf-8?B?YzY5ZVZ5NFM2dGpzK3ZCSWIrQVFMNlhPcVNiYWhoVTdXaVFPVmtYdFZsMCti?=
 =?utf-8?B?cUhIUEQyZHZORjMyeWRqQkxHU1YrSytVL0JIQnB5aDE2WEhSZGorRzZTVFB3?=
 =?utf-8?B?aUU0VEVkSGJGeExHenRqOHlXSGVybzdoK2FHZEVFemxvYzBGb0psMnF4NTlJ?=
 =?utf-8?B?ZWZSTXo3dExabWNQd1ZIaER2WnBEejlteVhsUDV6MEl3V0dwRzdpWEp0WVEv?=
 =?utf-8?B?eFgzeHpFOGkxV3lMdEFBTjU0bGpQYUZPa3d0V3JrdUtTZW4vemZpc3ZlbDBh?=
 =?utf-8?B?K1VNMW04TW01c0hBOWtMRTdxb1JhdHE3a3VrMXlRRnh6S0VoL2VpSkR5R3Z2?=
 =?utf-8?B?MXdESHB2S0JFR3BTb25PVUdBcENjV3hmalhUS3F6UzJtekE4RkUxODAyazV1?=
 =?utf-8?B?SERqYVBxaW9ubFlLSVZHVUhVZHY0T3BuYWJxdTYyaWt3aVYvQ3M3LzhUbVln?=
 =?utf-8?B?ZzY1K2RodFpOWWl2WTZqNUEvUE9wS2VKNTVRczFEb2s0MlVHNFhLczFRUjlw?=
 =?utf-8?B?c2oyV2dRRmt2UDJla3JnOTBJN3FPMzVweHhOSTU2VnJ4Ym5iSGdkL09ubEtE?=
 =?utf-8?B?bHNvdmNBYVp6QTZzdnRVdW9NQXU0QUFFVkg4bGpUUWdsZHBra1dyd3VLMkRy?=
 =?utf-8?B?QnF3b2RMRHlSZG5wa1dQYXYyUUpQSk1sRHdqNEFlWEQrWWhpQUFuZk1CTE4w?=
 =?utf-8?B?dmpRdG9uOTdoblJqMm9RbFFaZDUvWlJ3L0Z1eG9zU0hNbDJ6R0ZNKzNUOHo0?=
 =?utf-8?B?RytOelN4OUwxSE1YeGdhVnNlK3JyRkNCK0dvRWFyd0FFek5UMkUrc3JHZ0gr?=
 =?utf-8?B?elhZeml0V0NOTCt3YVhjM0RtRDVHRHlaYThuZ3Q3ZEN1RTJYaVp0RmdOdDli?=
 =?utf-8?B?UHkyb2pRUG9VQVAxYW13Sm9vWFdWWXlMYzBycTBTaDRwQ3hUVTRwNlJUQStO?=
 =?utf-8?B?QzhYbGgxc0tFeE9zUFB5U3Q3a1NBN2RpSDNnWjY4VVBmZlJDVzJJNitma2RS?=
 =?utf-8?B?aVB3ZldZeTllcGpkWGJmMkpxRjdvNlNmaFRwUVU3bjVMRFZqbGxoT21PS21T?=
 =?utf-8?B?dXZjWU0xaDRRcEpDQjR0MU0wNEdQR3RwTHVnNnBVRjFMaDkzeHBQblB0cU1B?=
 =?utf-8?B?Z2NNRHRkQmhWQmpkdXR6WjUwMjNDZHRFcVcveXlCa3pzKzZtZ1pNc2xhRitj?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C82E0BCE521037419F8106D7FC4E089E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e988c6-2161-4f77-9592-08dde72ab6b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 18:34:39.6255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1oUsF3Rxno/g7GhYXrGFW41A658mbSXjUQceaSvGdxGw74Z/eJgLHid9WAqct4eKlJENTmXHmb02cBbO685sDGgqIIjfEc1plW5QmYCGCeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8748
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gQEAgLTQ5OTQsNiArNDk5NCw2NSBAQCBsb25nIGt2bV9hcmNoX3ZjcHVf
cHJlX2ZhdWx0X21lbW9yeShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+IMKgCXJldHVybiBtaW4o
cmFuZ2UtPnNpemUsIGVuZCAtIHJhbmdlLT5ncGEpOw0KPiDCoH0NCj4gwqANCj4gK2ludCBrdm1f
dGRwX21tdV9tYXBfcHJpdmF0ZV9wZm4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBnZm5fdCBnZm4s
IGt2bV9wZm5fdCBwZm4pDQo+ICt7DQo+ICsJc3RydWN0IGt2bV9wYWdlX2ZhdWx0IGZhdWx0ID0g
ew0KPiArCQkuYWRkciA9IGdmbl90b19ncGEoZ2ZuKSwNCj4gKwkJLmVycm9yX2NvZGUgPSBQRkVS
Ul9HVUVTVF9GSU5BTF9NQVNLIHwgUEZFUlJfUFJJVkFURV9BQ0NFU1MsDQo+ICsJCS5wcmVmZXRj
aCA9IHRydWUsDQo+ICsJCS5pc190ZHAgPSB0cnVlLA0KPiArCQkubnhfaHVnZV9wYWdlX3dvcmth
cm91bmRfZW5hYmxlZCA9IGlzX254X2h1Z2VfcGFnZV9lbmFibGVkKHZjcHUtPmt2bSksDQoNClRo
ZXNlIGZhdWx0J3MgZG9uJ3QgaGF2ZSBmYXVsdC0+ZXhlYyBzbyBueF9odWdlX3BhZ2Vfd29ya2Fy
b3VuZF9lbmFibGVkDQpzaG91bGRuJ3QgYmUgYSBmYWN0b3IuIE5vdCBhIGZ1bmN0aW9uYWwgaXNz
dWUgdGhvdWdoLiBNYXliZSBpdCBpcyBtb3JlIHJvYnVzdD8NCg0KPiArDQo+ICsJCS5tYXhfbGV2
ZWwgPSBQR19MRVZFTF80SywNCj4gKwkJLnJlcV9sZXZlbCA9IFBHX0xFVkVMXzRLLA0KPiArCQku
Z29hbF9sZXZlbCA9IFBHX0xFVkVMXzRLLA0KPiArCQkuaXNfcHJpdmF0ZSA9IHRydWUsDQo+ICsN
Cj4gKwkJLmdmbiA9IGdmbiwNCj4gKwkJLnNsb3QgPSBrdm1fdmNwdV9nZm5fdG9fbWVtc2xvdCh2
Y3B1LCBnZm4pLA0KPiArCQkucGZuID0gcGZuLA0KPiArCQkubWFwX3dyaXRhYmxlID0gdHJ1ZSwN
Cj4gKwl9Ow0KPiArCXN0cnVjdCBrdm0gKmt2bSA9IHZjcHUtPmt2bTsNCj4gKwlpbnQgcjsNCj4g
Kw0KPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmt2bS0+c2xvdHNfbG9jayk7DQo+ICsNCj4gKwlp
ZiAoS1ZNX0JVR19PTighdGRwX21tdV9lbmFibGVkLCBrdm0pKQ0KPiArCQlyZXR1cm4gLUVJTzsN
Cj4gKw0KPiArCWlmIChrdm1fZ2ZuX2lzX3dyaXRlX3RyYWNrZWQoa3ZtLCBmYXVsdC5zbG90LCBm
YXVsdC5nZm4pKQ0KPiArCQlyZXR1cm4gLUVQRVJNOw0KDQpJZiB3ZSBjYXJlIGFib3V0IHRoaXMs
IHdoeSBkb24ndCB3ZSBjYXJlIGFib3V0IHRoZSByZWFkIG9ubHkgbWVtc2xvdCBmbGFnPyBURFgN
CmRvZXNuJ3QgbmVlZCB0aGlzIG9yIHRoZSBueCBodWdlIHBhZ2UgcGFydCBhYm92ZS4gU28gdGhp
cyBmdW5jdGlvbiBpcyBtb3JlDQpnZW5lcmFsLg0KDQpXaGF0IGFib3V0IGNhbGxpbmcgaXQgX19r
dm1fdGRwX21tdV9tYXBfcHJpdmF0ZV9wZm4oKSBhbmQgbWFraW5nIGl0IGEgcG93ZXJmdWwNCiJt
YXAgdGhpcyBwZm4gYXQgdGhpcyBHRk4gYW5kIGRvbid0IGFzayBxdWVzdGlvbnMiIGZ1bmN0aW9u
LiBPdGhlcndpc2UsIEknbSBub3QNCnN1cmUgd2hlcmUgdG8gZHJhdyB0aGUgbGluZS4NCg0KPiAr
DQo+ICsJciA9IGt2bV9tbXVfcmVsb2FkKHZjcHUpOw0KPiArCWlmIChyKQ0KPiArCQlyZXR1cm4g
cjsNCj4gKw0KPiArCXIgPSBtbXVfdG9wdXBfbWVtb3J5X2NhY2hlcyh2Y3B1LCBmYWxzZSk7DQo+
ICsJaWYgKHIpDQo+ICsJCXJldHVybiByOw0KPiArDQo+ICsJZG8gew0KPiArCQlpZiAoc2lnbmFs
X3BlbmRpbmcoY3VycmVudCkpDQo+ICsJCQlyZXR1cm4gLUVJTlRSOw0KPiArDQo+ICsJCWlmIChr
dm1fdGVzdF9yZXF1ZXN0KEtWTV9SRVFfVk1fREVBRCwgdmNwdSkpDQo+ICsJCQlyZXR1cm4gLUVJ
TzsNCj4gKw0KPiArCQljb25kX3Jlc2NoZWQoKTsNCj4gKw0KPiArCQlndWFyZChyZWFkX2xvY2sp
KCZrdm0tPm1tdV9sb2NrKTsNCj4gKw0KPiArCQlyID0ga3ZtX3RkcF9tbXVfbWFwKHZjcHUsICZm
YXVsdCk7DQo+ICsJfSB3aGlsZSAociA9PSBSRVRfUEZfUkVUUlkpOw0KPiArDQo+ICsJaWYgKHIg
IT0gUkVUX1BGX0ZJWEVEKQ0KPiArCQlyZXR1cm4gLUVJTzsNCj4gKw0KPiArCXJldHVybiAwOw0K
PiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3RkcF9tbXVfbWFwX3ByaXZhdGVfcGZuKTsN
Cg0K

