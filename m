Return-Path: <kvm+bounces-53705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 364E2B155AA
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5574D18A7DB6
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F182853F8;
	Tue, 29 Jul 2025 22:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eM3/rX3r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752C417A30F;
	Tue, 29 Jul 2025 22:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829929; cv=fail; b=rPrZiNrFiXJrWHtQRYoCskDmP/CBrylPRapexNXt3O82uzOn6iu6svLTQ1xTY/+K2bvy4r7C3Po/fowSLQFKAc0pNaFYVcQWJlGAnSCN1Fb8GZdNZP1B15q5Pu3pP9bZbmBR9KdgNRALm3qG0xgtFT1l9frgwpeSY+gUxuXrXKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829929; c=relaxed/simple;
	bh=0BQZK8s+rOvBxuPygMwTBStY9OqqP8t79zb/mhvsBy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xs/47pTwNtp8EZr7Mroe7RT0beSxOb7TEXhNTZ/XswCyuxmmJTqYWiBTNJFGDHq3DuMEPeHLNjKxipRb9fn4O3o0Geh4MaxsqdsilZseD6QJasHgeDecD/2T1+veFeA03t3RHcPgK6A+03411UjOo9Nb1q98F4FnMS1d4ihu8kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eM3/rX3r; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753829927; x=1785365927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0BQZK8s+rOvBxuPygMwTBStY9OqqP8t79zb/mhvsBy8=;
  b=eM3/rX3rpLYGL093tnrSz70cGdqXYpyh8S4blWk7eTkthG23wUIdTtna
   1XWJW3mVUV2Y/nlWjlYdHj4HH7DINu05kgwWGP8IewmEOtElgM/vdcSZU
   9jw5uUpQfZNtReZjVYobdvwymSCn8x7HZj0jKpWq43sXA6vz+5XOVMQAA
   ti44txqQLeGICmqTIXP6Fvhv1s+QH9C31Jq6ze8TZokWzUBdH7dzevVeA
   V6VIlBZZtUaagSFKCYflTgTcRsdLLJXyW+SvqHS88VFU85p1VwYftgS7Y
   aupqHeuZvsSBkuYwD2IZ4kvpTwO5dwBmcy3G90HG/dwKKbdxXpEvVDGBh
   w==;
X-CSE-ConnectionGUID: AzGTjsQaSCqtL52LmRd1yw==
X-CSE-MsgGUID: JQl9k/JVRjKeE4sQCCqntQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56265761"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56265761"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 15:58:47 -0700
X-CSE-ConnectionGUID: ugIEZnKkRoGjBukNeanguA==
X-CSE-MsgGUID: +XJBksqKSzWFGEeLjy035w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163284688"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 15:58:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 15:58:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 15:58:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.81) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 15:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMrRsSwmhO1lN0TPNPSYKqq/+8rHWpJjOdSc/JxkiIbbYVLugkFN2SolnxgKiHp27YR+mWqoQRGl/pgZAt4PmpopbUjmp4z/tUE3PcBZ4nQGaxVq37Y/C+2pdV2oeaSr8kIGabj5zncPYR/HJbG/PUHpgmPMCd3KW+qT8n0xur9NpKhboQ/Q5MUJ5ZdSJwk2pkkP+LlerDpnENHJ33eoLA9fkYUCJwRgf8bgaDjPIZsmeY8hZjY9HuQWhviFp/ZTron/vuZZebu6n3QQjGXo3dw108Sm/7DLQ4qklMduDVkf/bdeTrgzYSHXPFCEjNiPQjhg+BNw0KeJoebpeVE2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BQZK8s+rOvBxuPygMwTBStY9OqqP8t79zb/mhvsBy8=;
 b=NKFwzF6PruE2i934/TQ6O6hEuSyG4+jBvW8CnFBl9l4qOxUgcmIPYcHfOSk+PLQlUTR2TaagXyix47744HX7iKKc8X40Bj5GYLJ68d7u69z4hx3f30QceCpBaJCYXzcwpVnX93TxcxetVgNFwWRXtIQg8b+K+bviG67rxXtjh/YtH7d8h6H49XyInLpNEJAMwE8y52y8AdbO+ZWI5UcMGpxgrJruAL9rsaWz1Eh/Vm74pKJAQfsy6/+LcB+szJiVQ2lz0KTtjPuq1DHK+d9KYpEkRHYphi1GvWMCwgEG/VvmjCTYjiONqo4IH73UwkZp5KZ0DBatRHXoOsJIgQ8KrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9226.namprd11.prod.outlook.com (2603:10b6:208:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Tue, 29 Jul
 2025 22:58:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Tue, 29 Jul 2025
 22:58:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "maz@kernel.org" <maz@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Topic: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Index: AQHcAL+7V9fiN+6xT0aRmIRaSyEMmrRJrnYAgAAHnACAAADmgA==
Date: Tue, 29 Jul 2025 22:58:02 +0000
Message-ID: <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
	 <20250729193341.621487-3-seanjc@google.com>
	 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
	 <aIlRONVnWJiVbcCv@google.com>
In-Reply-To: <aIlRONVnWJiVbcCv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9226:EE_
x-ms-office365-filtering-correlation-id: dacdd09f-f2e8-479b-f03a-08ddcef35f44
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WTcvNEVhbTVKbFlwc2pXVkhnRkUzTml1Z0xvd3UrTnZPNHZlSTNiTUgzLzJV?=
 =?utf-8?B?c2wvYzNIMHdMUlI0YmdHTWdWWnFvWkF2eHdIbW9oVURZb1VZT3pQTWFBRHNO?=
 =?utf-8?B?T2dXRk8yc2lPVlNVcE8vQ21ZaHZPNFJ2QmEyaWg1VFl3QWlHcGw4TnZ0MEZn?=
 =?utf-8?B?cVZic2NRQ1pCc3JQRSs3eWJQaEJPVmtPV2xpTkVyY01lZ0NYL2pWYW9KUSs2?=
 =?utf-8?B?L1lKZ1A4VDFMMUN5d3hYbXpTNHBnUDcvZmVwTTJJRjkxYWNodGN6Z0pOMnY2?=
 =?utf-8?B?WTFXbUN6eDJzcDRGS3NpYzV6VGYvSGVZQnZqU1BXdFdkR0JrSTlqOGZhRC9X?=
 =?utf-8?B?STcvY1ArU205V1dINUhqajZjNytCL2FDY2E0UVA0VjNucUhkUFByYkNuY0wr?=
 =?utf-8?B?dkhXTkZkdUhGdmZybktzR05NVDBDdXJtQzlkU1dUUnEvNUU3aXJ1SFdCZHdk?=
 =?utf-8?B?RkQxeWl1YzZDbFNsRWZsN2taNGhvRU9Zb3d4V1NWS0l5SHFvanNvdlRLMWZO?=
 =?utf-8?B?TDRRV3Y5eWJlSXMxbUxBZnROaVBiUFd2a3ZBOE8yQUUyem50blZKeHZQcDNa?=
 =?utf-8?B?K0N2dXhTYkFISWkybDNlVHczckRnQytnV25XZ3BNTFo3V1JtNUZlUEtGN2pT?=
 =?utf-8?B?KzFtNkluODhzT2NUaVduNWo2N1FXM093bVZiNW9Rc2Nna0tLYXJIZGUyN0hi?=
 =?utf-8?B?KzZ2eFFrT2hmMXhNZFhxZHY2bEVwa05CV0hGZFlMVkNqcC9RTjY0YkJsNzg4?=
 =?utf-8?B?a2Vha1JaM0d5UUtIQXRjZzEzaWNkWG1idk9ramhPRjZaRjNFcDNXSGtkc0JM?=
 =?utf-8?B?UDdCajFnKzAwK2pFbWIxQ1FZcVhxRmMrSXFRYVJGSXBQbk1QNTF2UmZCcDNm?=
 =?utf-8?B?bzY3YnVLMTNjd21OcjlOK21GdUtKQ3lPRjAvWTc1U2QzbUsvZ2ZwdXFxOHEv?=
 =?utf-8?B?cE9ZZnVSSWRZa29UVGZrM3Q1Y3pnWEhocGViNlh5Nk9ua3JzUnovSjFYQ2hM?=
 =?utf-8?B?YWVwdHJWUUthaUw4SE9yZ2hJTHFMbmtiWDREcUVRWmRBYk03WUJwc0NSUHhh?=
 =?utf-8?B?Um9OMXdJWXdTUTNGTWtaOVlmcEJWYXhoUVhONWk0dVhIek1ud3hUdEpJaG8z?=
 =?utf-8?B?VUt3TUVRNEtDMlFtVjQzT2hWR3JPbGM0TlVHR0pOTFhhOXpwMElZZUhDdjNZ?=
 =?utf-8?B?bmtldUVUck1JalhWbytSN3JwemlETk04ZnhlL1dTV09tQ1BJK2EybWxRTHlm?=
 =?utf-8?B?THNsNUl2YWRqS216OEZZL2RwSHhOd085ejNubWVVTytIc0VGR05JK3NiZkxs?=
 =?utf-8?B?TTlLV2phNHlQTXoxT0p6VlVPREU2andDcFpuOGtrOWhaM245REhMQ1NoTEhF?=
 =?utf-8?B?MUNCSXgvZTFEMkVBa212TWNhZ0Z5bTdpODZsRm45SGNVWWUvOWJGaVU5WE9k?=
 =?utf-8?B?YlgvMHI1SXpDMWhzSzZKR0hoekpZc1BER2YwMHVXVkNnZzJodVVEbGJreDAz?=
 =?utf-8?B?TWRWci8vQ1dva2RHL0srR1hOTkNjNHRwVEtUM3FtQWN6b2twVUFpSU5VeU5T?=
 =?utf-8?B?c2kzNnczdituWEN5MGFyUDA5NWh4dFNiMzVFUldzQ3VFaENlRGpyVEdOcGdv?=
 =?utf-8?B?RmZDa1BuWFVTVDJpZnN0cDZLbzRFVk1FQzJwUUhHbzVTUCtNR1dNdGU3WUtt?=
 =?utf-8?B?VVdCUE8zR3ZRbGtnSjNodk5QM2pHd0Q0WHU5OXRxQzdKMXFvaWlCYVhFeWxS?=
 =?utf-8?B?czYvUEk1UitEa2N4NUlpa1NCTVVzb282Zm52ckxRdXdHWjFYT3RLUHU0UmMr?=
 =?utf-8?B?REFiNUFVT0wzVG1BZTNyTjMveC8wMWJ2c2U4Rjc1ZllDT1hMSmZHWWdNNjht?=
 =?utf-8?B?ZU5oc0diQ0piemNyanhOMzdzcGNHVDNOUTBOTzNxYS9way9aYk1aendvOG95?=
 =?utf-8?B?Z21jaStvdXkyYkpSYnpsaWI4MEFBdWQxVDRQNTFIVlV6YzZMMXJ3S05VcXdy?=
 =?utf-8?B?NjJOMDdWTjRRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXpFRkQyTWhibkhQYnBDTUFDYVJsOUI5VFlXWjJWWENsSXdGS2Y2cU9yUFg4?=
 =?utf-8?B?R1FUL2V4N0xyOHpIbGdQNmc0Z3QwNVZBTm9aUHE1NTZRbUQrZ2JiWkRNUFdM?=
 =?utf-8?B?aysreDRiVCs5UXhMN0lqdEhFeXVxMHdVNlBGNTRiV1ZNRDZQaEhRSmhkWW5U?=
 =?utf-8?B?eEtlbVRGOVdya09XajU0cjFHdHIyZW82SUplcTg4ZDJLdW5kZ2MzV1E1SU5Q?=
 =?utf-8?B?amJ1T2F0dWovSU8yU2dVdURlV1cweFdJKzZUNXJ6VkpHZDdYMUw0VlpTQ1k3?=
 =?utf-8?B?ZEJ6YU80RWxWMmtaUGc1VEdHUjFpVU5OTWI4WUhJWnB3QkhZSk0zakt2RDk3?=
 =?utf-8?B?cUtBa3BPNi8wN0tlT3U0eFNOQjFxN09RR2xQaHlMQStueERDNncyQXNmcS95?=
 =?utf-8?B?R2ZweU5wQmxsQk54V2FCYjNrU2RxMUh4eURlSlpsem11K0J1T0E2Z3lOdmhP?=
 =?utf-8?B?RGNUa3R3MUx1N0RndTIwVis3ZlRXU3Z3ZU1UNFJ0K3I2c0IzcXUzWEl2ZTYr?=
 =?utf-8?B?cXJlK0tYM0RPZjhwSGM1MHBwZExIeVY0VUkyUUN5eS9FaitVUks5aTd0WDk5?=
 =?utf-8?B?T2xYTDBmT0NuL09FcUU3b1hoZFlkbGdtaEI2eFA4bXFFazB5STB0UUsxczl1?=
 =?utf-8?B?cE9wTGUvSnBPNFl4YWlVNDBDQlVVSi8vYzBYczVHNDB0M2lBUE42VEpSa1Rq?=
 =?utf-8?B?VlBwdU0vdDB3eWRwWnkybG9PMUVFZU1SeWZuazE5YkhNNTA5eFA3NFViNnRV?=
 =?utf-8?B?d25YNGNVaFpxdldQWnRaUGFKRWFhVDl0UkdJV1JhZ0FId1owY0NTUVdNZTBP?=
 =?utf-8?B?Z0tZOTNBSmtvYytmM3dFL1lyc1ZudUdvVVhjTjZLZ0txMlJ4NDVsQ3BSd0Jh?=
 =?utf-8?B?bys4dnkwamRJRFFwWnlPb2VRT1FQaWlLcUtEMUt1WUtuNGpHbDFCNU41S1Q4?=
 =?utf-8?B?OWFXOXM5eS9BejdJVFljbGhhTVNobmozSjZRSnJ0a0N0dWJzVWo3RFRTWDBs?=
 =?utf-8?B?eThmeEFmcmZTVkpvYkF4TW1BekloQkNmSEhBajI0Y054TUZza2RNSElWckI4?=
 =?utf-8?B?V1JTZmlOQlYwWm12VzdHYnB2YnRPaEdKaUxPdldUOUNOOUR3YVhNczlGMVJ6?=
 =?utf-8?B?bGdCYTJKL1dwdnAvTG5DcGZJODQrMFpyZitwcUg3YzZYdjFtK3h5NjVWY2NM?=
 =?utf-8?B?TUQ5WnkzdkJLaGs4TzFlQmtxRWVvQm5icTJrS3grMDFVd083U29NeEwxVm9h?=
 =?utf-8?B?eEdscWVOYTZuZ29jTVEwMVVYRWxoYmNNR04vbVJVbEIzLy9nYlIrWGZXeER4?=
 =?utf-8?B?c0lQQkUwaklLVEJlVzZYcHZXK1U0U2pPcnFjQWw1SWc2d016ZkQxcnlKQTRr?=
 =?utf-8?B?V2k2d0xVeFdVRzhCeS9ObDJ6bWExaG1ET2RldldUbEZjWUpTWnV2clFQakx3?=
 =?utf-8?B?OWk4LzN1ZWpTanhkZU1mVnpTTlhCV3FUdit4Q2NvL2Z3c3JhRldWTzlSbXVS?=
 =?utf-8?B?U0haY3o1VTV5b0E5TVFsVVZGRCsramhVMHZpUWNHdkY4MFN1UTBQUmlsUVRv?=
 =?utf-8?B?RE5ndExubFBOZkZwREJVNFZWR0MzRVZQcE9sd0xUZ1cyWm1jNzJMeUxkcVl4?=
 =?utf-8?B?bHdkSjNzR2tvTkI5Wmh1ZmRGN1BSUE1BU1FyS05LTlNSMlhPUVhIYUljem1S?=
 =?utf-8?B?dXNFMGZ6OUx1NGxaMDhvZHAvOXJON2pwcHUvUnMzWXZIVUlveW1KSmFXV3N0?=
 =?utf-8?B?eVY1bk10S2dvY0src1JnVlFKTlkzM05ZL1VSUi9pRUcyVnNPZnpyaWVVK0Yr?=
 =?utf-8?B?eTB0b2FDeEwvTlp0OTZjSlI0WnBTU1c2WFpVdlpOQTAxWWNrUjgvTGw4YVYw?=
 =?utf-8?B?OUFsR2llQlFtcXdHb2Z3WkVMN2gzaFFncEc3azM5RTlkbUloM1UxMEtwR0wz?=
 =?utf-8?B?TzNPZHd0cnNvR1Q5dmhiV2pEVmoraWczZ2FGR0lnbWJUVlMwSnZXT05NNGxD?=
 =?utf-8?B?YjNuNUhhVGN6emEzRlV1RjBYZ3pycjh4YWtUZU0rbVl5M1lKYjJGNUdTRXJP?=
 =?utf-8?B?VERaTFJQMmYrSmcxRXMxQkRHdkg0dnAxR09wbUNlUEJzNTFwQ2pmOFp5d2xn?=
 =?utf-8?B?M0J0dmRpNkQ2SUVPeG4zUU9FcnJ5dFVqekpOc0JPcC9GdU1pdVFJWnVPWFlP?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B52B4C29841A14E83DDEE0B14BAB3C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dacdd09f-f2e8-479b-f03a-08ddcef35f44
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2025 22:58:02.6861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDcJSZPjKkOdGmezQQ2NZfMzUE411rnQF4KauRRtIYlz6jq71sHId3VHAoLtT/MqmAG46ahYyqjOpnAQHM0ZRkxVMAFaRTmiWR/OALF8i+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9226
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTI5IGF0IDE1OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFRoZSB2bV9kZWFkIHdhcyBhZGRlZCBiZWNhdXNlIG1pcnJvciBFUFQgd2lsbCBL
Vk1fQlVHX09OKCkgaWYgdGhlcmUgaXMgYW4NCj4gPiBhdHRlbXB0IHRvIHNldCB0aGUgbWlycm9y
IEVQVCBlbnRyeSB3aGVuIGl0IGlzIGFscmVhZHkgcHJlc2VudC4gQW5kIHRoZQ0KPiA+IHVuYWNj
ZXB0ZWQgbWVtb3J5IGFjY2VzcyB3aWxsIHRyaWdnZXIgYW4gRVBUIHZpb2xhdGlvbiBmb3IgYSBt
aXJyb3IgUFRFIHRoYXQNCj4gPiBpcw0KPiA+IGFscmVhZHkgc2V0LiBJIHRoaW5rIHRoaXMgaXMg
YSBiZXR0ZXIgc29sdXRpb24gaXJyZXNwZWN0aXZlIG9mIHRoZSB2bV9kZWFkDQo+ID4gY2hhbmdl
cy4NCj4gDQo+IEluIHRoYXQgY2FzZSwgdGhpcyBjaGFuZ2Ugd2lsbCBleHBvc2UgS1ZNIHRvIHRo
ZSBLVk1fQlVHX09OKCksIGJlY2F1c2Ugbm90aGluZw0KPiBwcmV2ZW50cyB1c2Vyc3BhY2UgZnJv
bSByZS1ydW5uaW5nIHRoZSB2Q1BVLsKgDQoNCklmIHVzZXJzcGFjZSBydW5zIHRoZSB2Q1BVIGFn
YWluIHRoZW4gYW4gRVBUIHZpb2xhdGlvbiBnZXRzIHRyaWdnZXJlZCBhZ2FpbiwNCndoaWNoIGFn
YWluIGdldHMga2lja2VkIG91dCB0byB1c2Vyc3BhY2UuIFRoZSBuZXcgY2hlY2sgd2lsbCBwcmV2
ZW50IGl0IGZyb20NCmdldHRpbmcgaW50byB0aGUgZmF1bHQgaGFuZGxlciwgcmlnaHQ/DQoNCj4g
IFdoaWNoIEtWTV9CVUdfT04oKSBleGFjdGx5IGdldHMgaGl0Pw0KDQpTaG91bGQgYmU6DQoNCnN0
YXRpYyBpbnQgX19tdXN0X2NoZWNrIHNldF9leHRlcm5hbF9zcHRlX3ByZXNlbnQoc3RydWN0IGt2
bSAqa3ZtLCB0ZHBfcHRlcF90DQpzcHRlcCwNCgkJCQkJCSBnZm5fdCBnZm4sIHU2NCBvbGRfc3B0
ZSwNCgkJCQkJCSB1NjQgbmV3X3NwdGUsIGludCBsZXZlbCkNCnsNCglib29sIHdhc19wcmVzZW50
ID0gaXNfc2hhZG93X3ByZXNlbnRfcHRlKG9sZF9zcHRlKTsNCglib29sIGlzX3ByZXNlbnQgPSBp
c19zaGFkb3dfcHJlc2VudF9wdGUobmV3X3NwdGUpOw0KCWJvb2wgaXNfbGVhZiA9IGlzX3ByZXNl
bnQgJiYgaXNfbGFzdF9zcHRlKG5ld19zcHRlLCBsZXZlbCk7DQoJa3ZtX3Bmbl90IG5ld19wZm4g
PSBzcHRlX3RvX3BmbihuZXdfc3B0ZSk7DQoJaW50IHJldCA9IDA7DQoNCglLVk1fQlVHX09OKHdh
c19wcmVzZW50LCBrdm0pOw0KDQo=

