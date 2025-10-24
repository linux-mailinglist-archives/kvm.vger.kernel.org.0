Return-Path: <kvm+bounces-61014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2674AC05B8D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4307D188BF81
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 10:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3211B312812;
	Fri, 24 Oct 2025 10:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hYVPqp0d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527C315D51;
	Fri, 24 Oct 2025 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761303220; cv=fail; b=KTU08mUtf5y9zylhCNPw+0F+AammAfamJ9uCD4O/SDrioZpp1lpwAMROx1Jy1yPT3RctkYioPZYBRF/yprkgioKF8M1YFRsaH4YHYLCZYQjPLgSPymyYU+XBFGBuegjw465C26UDYLaTDBdAvvdUogiju0SV6um1izbMHkF58fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761303220; c=relaxed/simple;
	bh=av270d9YYf9xcY7Y62ZvV5FIw9i/2gno7TlW6p4I5zo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YGbDnmkq5LeVh9NWHvQnfPgrrcHlzHdqYubwHL77PEjiMD8UXZSEQKxlO5UINKsns/FSVvjYPOUxPUCuKyIX4TkXgEZx/yD2rCcxg1eyiGiD2RBRPTxc/MeLne7wJsbPTksjlKkgyvUFZITJ5UeHuVJX9oXjXF+UkGhwXaWIhiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hYVPqp0d; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761303218; x=1792839218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=av270d9YYf9xcY7Y62ZvV5FIw9i/2gno7TlW6p4I5zo=;
  b=hYVPqp0d1Wm/sz7rK+eV7sUOAw1tvY541zDh13FeXi/bpWBGLuthNVyH
   Z1dmGmPTTbhJTXp9XsawnvhodLHnnznnNFPPCOij6gKVe6NX5TQQnvW4y
   b1EQ8ps6aSAZs79+TANXFIFPsclRu7tGXTsBW3lcbQ/4Ef3CJCVqYrf+/
   FUN3wsEOxqI1NBeW18Qx6DgzdTq8aEClYJH2fSXSsBDoAVMdg3GMg5x6H
   hsuHM/uQfBw+tuOZYfge4kfap1ob4VRlWj1Zozi/hAWmm8R5Y0GmvdRLg
   ZU3tm48MijpqCtR+u4dOEBJy/EtbERYDSMJD3jNnoN+rWAySa54ChfX9+
   A==;
X-CSE-ConnectionGUID: SKnhiFE8S3ubsijvkluyyQ==
X-CSE-MsgGUID: +cFXBQRDTamAQxAHjZ9+8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67127894"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="67127894"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:53:38 -0700
X-CSE-ConnectionGUID: hK2h2xsMQQmn+/HhmqBeVA==
X-CSE-MsgGUID: jENooWc0SRWwsLld0aCclw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="183577256"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:53:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 03:53:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 24 Oct 2025 03:53:37 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 03:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zIHL9m8bxR75prPivzkmew7csDTzG2K4uRc0Y7euY7hihSLxG7kqkGTZHnVQ+cwZVAqlD+7nuQbFUg454zrdk4HtxRfefZoSy5EcWVTFfXOQiTjEXODMHrPODihQNkIM1tadiOhcdXr09BCkzYhDvxE1PhZegNqSKJGkRq24TuVSKMCAfYxk+qIAFw/6dK7QKuQFVs0LbHJb7iLjGaO/QjuNqcagUeVOeb3QhixshjAVsD62kektNygcZnfblTdr3tEOTCUFSsE/RuuCtedDjuFEZE/KhAnOXZ8GYPKHyZ9X0+9tzBa4O/3BTxvlSjOONoWKcI4ukV/RSNB+H+VDqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av270d9YYf9xcY7Y62ZvV5FIw9i/2gno7TlW6p4I5zo=;
 b=p/v4NphEdPuNJ41k8NicBiXTC2oFFpMMJrUoq9mP5zxgsW1WzgXwQjvSYdJw196Tmvroprbo4DZtm0lmiKxWlElSy8eC3GHIoONNtLx50I+iBsZJf2c2P97GPM0RIirYl6cQskbwH3EZapqLNycbkaKXk8Da15QzGPrhSTaNglhwKJ1duE3IimN2TuBv1iZZJSpGBeC3LsMA4XBSu0f6USfUbNul4RiCqsYEv4CHiFE/UGKbTQzcZJn2cnHo1XuSTTi6uPVkahRO1gNjcS+RTIbXY9FnMA3+i0cRxde9+o823lRWFkKNuJfEgP7ya7Qjb7wS9zDZ1wjkiK8XCynXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB8055.namprd11.prod.outlook.com (2603:10b6:a03:530::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 10:53:34 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 10:53:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Topic: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Index: AQHcPv2zs83Y32BYWUWhhrWchNoLBbTRKuOA
Date: Fri, 24 Oct 2025 10:53:33 +0000
Message-ID: <8f8b4041abb730ed7dec97aaa7a8273fe680d87a.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-25-seanjc@google.com>
In-Reply-To: <20251017003244.186495-25-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB8055:EE_
x-ms-office365-filtering-correlation-id: 89f3b8a6-e69c-44bf-797e-08de12eb93dc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dUkxTStjZzlqSGZUblFHbVFab3F1dHFaRWJxaENqK0xMRlBTZ2tpeTNhSllj?=
 =?utf-8?B?VTVsdmZhd2JjeEh4SXo4anVMT3JTNGI0M0tWVUlhcjU1d2xsU0NPdUd6elVy?=
 =?utf-8?B?d2JKakxmM0wxb0tQbnEyTWpHQ1h1cklMcmYrOUZucHhuYzVvZThBT3RxYVdV?=
 =?utf-8?B?SGJtMjJpOWxuNWI2WEloWmxRYWpyTzJQTjVETUNXcGlWZmY2UVh2MWJRalBF?=
 =?utf-8?B?R1dpNlV2TmdSS0tSSEorcmF4ZlhFVDRDaCsyVS9rUWdpOXdXSWdabUljblZh?=
 =?utf-8?B?K0M5YWVETUdqOG1aZVJmdCtmZmFrcmlKOE93bG44d1lYSnI1bk5kNzJZdkI5?=
 =?utf-8?B?YjJaNE1RczZ5Yk9IR1dOUGxMb3hhRTdIWFRCVEtYNyttSk0zVDdqMDJoVVpG?=
 =?utf-8?B?WWpoOFplUGJSQnR3VmRNejF1SnpaRTRxMG9qZDdEZzFXS3YxU0FpbVhBR0l5?=
 =?utf-8?B?L3dMazg4SzJvSVN5NDZHREpvVXcwOFJpbERzVmZTWXFBdnU1SUNTenQwVmpp?=
 =?utf-8?B?eEhNVjIzamlXV01neDhudkk1VmJiZ3NGeWlsamlaL3NIYVVacnJaOWVUbjE3?=
 =?utf-8?B?WXJDMXc0SlpoSEhndlNJN0RPeVZvOCtSYXViVkxuQlNSMmRjZU5RSS9nd0I0?=
 =?utf-8?B?R1NpeGJ4RHNhT0xXT1JwNXB5NnhLVkNDT1F1YVQzNlpRMW1LTGFaNjd0RVpC?=
 =?utf-8?B?ZGlaK3ZPV2R5MTlUZlJEakVqS0pZV0JCSGpvUXVMckR6UGhFQXhsWDJwTmxt?=
 =?utf-8?B?VWdPeEV0bkFwVFppdzRsWkdCQVMvTVNvRXZTdGVBSXpwckd1S2dCdkJoWjhh?=
 =?utf-8?B?YnB2Q1NVbkNQdTl2NGozanBiSEhmMmRLbGJDb1k4WGpsR2tiVVhHdVVmNHhQ?=
 =?utf-8?B?QkxaUXRUclBSSjdlSE5wbHJ0M09WeWZReks3RFltVks0WlpSb0JLQk1LdnVt?=
 =?utf-8?B?MVdibzdiRVRXeW9ZaUdaUzc5a3h5TGNtVTE0bHhlbmQ2dUFOZ05lbUErcWxT?=
 =?utf-8?B?dE9WSU9TeUtwSjBJb1NJZlZkVVkrNENFUFFjaE9LZGtlMEFXbmNmcXVJazA2?=
 =?utf-8?B?a1RidzF4WER2TmxKZCswdm5MeWoxM2JVSjAvRmQ2RlNyRjlLSUhSS0Uzem4w?=
 =?utf-8?B?d09iKzdrajdzZFBJU1Jna3dqaWlOUHRXb1cxKzJZcEd0NUNlYzB5Nmk4UHNq?=
 =?utf-8?B?TFlhN05QVjJGN3BqZGRnbm9SME1uV0ZxOEozNHFtZFJVSDJVQ0dIb1RKemll?=
 =?utf-8?B?aVFudUt5Q05DZzZmdXVMeTd4REpVVmlkemJnK3NwYUtSMGJIM3RHQkhEUk5z?=
 =?utf-8?B?VDdUbEFaSzVKZ2RHSFRMRlVvbWZaQWhIK2JCRDJ1ZXI4ZUliYURueDIxaVRQ?=
 =?utf-8?B?OWlnRU9ZaVpzbE1lYjI0MkpCOEhCRWVZc1pGUDNjR250RHU2NzVZcFAwVzU2?=
 =?utf-8?B?bUhYRVdvNURnZjBMTUUzcFJtRHN5RDlBRzd5aFZXQUlzZnZNN1NCWU9pcUE1?=
 =?utf-8?B?WjFPQXZjOVdrZms4clFGMC91S2lJS3hjOUFEUG5Sa2xXZjJ3SUpCQm1BaWFk?=
 =?utf-8?B?blJxTno3Z01jOHJvTjdueUlCTjFVR1B1dzhxRE9pQ2xZMkhSUGhNQUJ1U1FD?=
 =?utf-8?B?aUJJTlBtZWlkRmtuTUpoVXFYNGFyb0pIU2svT20wRTV0VGtMY1o0RmJLWmRn?=
 =?utf-8?B?bXJtUVNhdUJiQ1c5RGlJZVZNSnBjRmgyQmp6c2NEMDlPZlB4cWRCdzdxdzNQ?=
 =?utf-8?B?NndLVnNDeS8zRXZYSzVYc29WMGI5akhjaTJWZjFGcktPKy9MY0h5M0srVlM1?=
 =?utf-8?B?VkowSmxUZzR5YVdMQnJNTXhuWUdBN05CVlBpS2RGZGpMbUJYdlorU2taMU1r?=
 =?utf-8?B?MkFyakR2TGZweUJNWlhNampTVHpqVkdZQk9MbkZFMVJIamRRM1NlKzdnL1VF?=
 =?utf-8?B?amdOaCtUcGZzSTl4cWZOb3ljVHVpZ3VNeG1BVGJWLzZRS0J3ZGI2NGw2M2Yw?=
 =?utf-8?B?WFZUcHduL1R2QkE3NG03emQrVUhsMEI5ckZhRmFKOEFWQTJmY3ZrYWNnLzlo?=
 =?utf-8?B?RjllSWFpSHErSkRlQmVmQ2tBN3QvVU4yL0Zndz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXMwVjNSaFVOZXJiK0xqNnFUY2IxVWpKRkdUVjNnQUx1MTk0eHBmbVp4WXRN?=
 =?utf-8?B?bWJmaFdIbThLbitiWWtUeTY3d2pQWW0zM0lUM2R6cjhoK3pteE9vVXI5Tkx6?=
 =?utf-8?B?bVBjL0I1UzltdlZRbExzYkpnNTlZcDNzdW1UeEFHMGVxOW1WdUxRZThKZTgz?=
 =?utf-8?B?WUxZdWZJQ3BkUFh3SmhPR1ZBZjdNRWV6VDF2dDZ1dm1kUkIwMHVrT3dTSitX?=
 =?utf-8?B?clZQT1NHeU5KUGQ0Z1U2VGc2UzRvc0NPdWxoVFovVWpEWWRreUoxa3l3QytV?=
 =?utf-8?B?ZWYvNHBTOWkvODhCNU5lZ01BVTlYcW5OY3hHYi9qWjI1dm5yaWpNdW9POTFN?=
 =?utf-8?B?ZVFKUzVqOWZiMkh1TVFTRXVMN0R1L0svZEdGaU9nSUZzcjA4ejhKWTk5VmxS?=
 =?utf-8?B?MkIyM2xEUWxMNFB6VjVocjRnMkNzV1VyU0hWQm1oRFltbWV1R1FOWVc1VHRG?=
 =?utf-8?B?RXBQUDJObFRjbnpxRkVuSm0rZUJmd1VUeXY4Q01XSHM4aDhKTm94MExlRGJN?=
 =?utf-8?B?T0JYQVdjdmdvOVBVdkNSRkNpcVlkaElXMWEvd2JjSGYwNXRKTFVQL1I1cnVa?=
 =?utf-8?B?NWpVbEtuY3hmQVVnZnJsdEswMTdiWnpSRFF2a2Z1dnB2V0RRUy92Rk0wRlV0?=
 =?utf-8?B?MFY2UmpKdG5zeDg2UVphTE9XZ2JRK3dYaXpqOEdDTVdCa05IMzVRR2lKWlVM?=
 =?utf-8?B?ME0yZzcxTzh6K3BUanVaaTI3dDliQ0lHMnFtMk5QWmxUWHhaQzd0amxaNmhQ?=
 =?utf-8?B?aHlWVGVnWTVFN1dXSkxzRC9TRWxBMXlpUVV5M1YrYzVLMnF1b1QyUEg4Y1pD?=
 =?utf-8?B?UHVnZjVudVV3bGVyZTRHVDFxMHNHcGh1c09GTDVqYk1HWHJSY3UyTUk0ODdV?=
 =?utf-8?B?S2dKMFhRVnA2M3VJS1MyL0dWSlJJUlV6dG5oTy9NUVJGWmo1djV5SWF3dmwr?=
 =?utf-8?B?UXlHU2xiakxXU2Q5cTFiY1RvRGM2dDViREh2cXdMQWR4Y0dsd0g1dktPd3V1?=
 =?utf-8?B?UDVoSDJZZWlsK1RkUm1ncktwZTFyVlpnWFpNY3owcnM2YnlSVG5HZzZEUGF2?=
 =?utf-8?B?ZmxBMGhTQ1RhaEpnSTVFdU9zbUtXb1VqRWVxMGxpRzYrYUhLUDRMVUV2Ymgy?=
 =?utf-8?B?cFl1RVR1Z3V3YnFMOHh1Tlp1aWlVSExjcGJrNHA5SGsycjJKbkhVUlRIcjZP?=
 =?utf-8?B?dXBhQm52cWd6UUx1M0o1Ync5MWwxaDF3dC8zR0RuSzh3ZHpTeFFQZUFFeGR2?=
 =?utf-8?B?eU93ZEdDM2Uwc3BIK0dkSFVHTUhrcnY2cmN5YkRiRnRmNWVXTWtLUEpzNW1I?=
 =?utf-8?B?QmZsLys2akJKUS93SzU5RTNrblpVQ1FocklSdzZhcllrNWIzaVVKY0Y3ZmNI?=
 =?utf-8?B?SCtCd2VsRkR3YlRNdnFBcVg0RzVCRmwzUWpROWVXelFDTTFwSU8rYzYrckh1?=
 =?utf-8?B?OSthQlU0V1NEWWEwdEFseDEwK2hvTHdGcDZBdm4wM2gxMnd6L0FOUER4MnI1?=
 =?utf-8?B?aURiV2JYQUlBRHJMTnh6Z2dZZzI5RFFPNUtDUGgyTzYxTlA5V3pVWXl1b0h5?=
 =?utf-8?B?encxdUdkZlhzOHRWdVRHbFp1L3R1eUwwM3pEV0VUa3JzMFQ4bDlpcDBQQnVZ?=
 =?utf-8?B?NWtyRC8wcVR2Q3dYajFRTUNqNWJIdWp6QktJYXJtTnYyVWpzQWJraWdic1B4?=
 =?utf-8?B?ZDVmR1dhd2QwR1dydHJTL25LNUlqTDEySHhyajU2NVM3V1NoOUttOTRRRHpR?=
 =?utf-8?B?Qm1LejFQR3dmaGZkVEk4MVZtT2JxS3FBSlBPb0xhMU5VTjZSWTlXR1ZKekZG?=
 =?utf-8?B?RGxIY3FWWTl1d3AxZ0VRS3lBcDRtYW85U1pndG05ZkpYT3RJRzlqUnhjUkw0?=
 =?utf-8?B?ZVpBT1BCNURsWWhvYS9wclZ4WkFqTzhNREtCMXZkS0ZEWVVrbkx2blVKY2I0?=
 =?utf-8?B?Ujc0RDFCYjI2YWFjQ1p3OGhHRGsvK2J5eGdHN092enQ0ZE9ZVU05V3JleXU5?=
 =?utf-8?B?ZjBCSndVUzdNS0ZFYWY1dngrZk92SlhHalh1amdWTXZCYW1Fb21BeStQU05K?=
 =?utf-8?B?dEg1bXNCU2Vqcjh5NVB3Ty9MUU5SQVpDQmNjdk5BR1hKM2pGaTlCUjRuc1gx?=
 =?utf-8?Q?kVV/0eha1fHoRxXvcJs5o8UPi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B31DE47781E52A4E939EA0210517D9E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f3b8a6-e69c-44bf-797e-08de12eb93dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 10:53:34.0214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvhLF4sPJ21u4zR5oPN3qEkpOwj8YUYcEDFpFVMoHVTjgwtFUhnAt2OToLzVcv/zbkFG/9uIH0etGdvQbEipaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8055
X-OriginatorOrg: intel.com

DQo+ICANCj4gK3R5cGVkZWYgdm9pZCAqdGR4X3ZtX3N0YXRlX2d1YXJkX3Q7DQo+ICsNCj4gK3N0
YXRpYyB0ZHhfdm1fc3RhdGVfZ3VhcmRfdCB0ZHhfYWNxdWlyZV92bV9zdGF0ZV9sb2NrcyhzdHJ1
Y3Qga3ZtICprdm0pDQo+ICt7DQo+ICsJaW50IHI7DQo+ICsNCj4gKwltdXRleF9sb2NrKCZrdm0t
PmxvY2spOw0KPiArDQo+ICsJaWYgKGt2bS0+Y3JlYXRlZF92Y3B1cyAhPSBhdG9taWNfcmVhZCgm
a3ZtLT5vbmxpbmVfdmNwdXMpKSB7DQo+ICsJCXIgPSAtRUJVU1k7DQo+ICsJCWdvdG8gb3V0X2Vy
cjsNCj4gKwl9DQo+ICsNCj4gKwlyID0ga3ZtX2xvY2tfYWxsX3ZjcHVzKGt2bSk7DQo+ICsJaWYg
KHIpDQo+ICsJCWdvdG8gb3V0X2VycjsNCj4gKw0KPiArCS8qDQo+ICsJICogTm90ZSB0aGUgdW5p
bnR1aXRpdmUgb3JkZXJpbmchICB2Y3B1LT5tdXRleCBtdXN0IGJlIHRha2VuIG91dHNpZGUNCj4g
KwkgKiBrdm0tPnNsb3RzX2xvY2shDQo+ICsJICovDQo+ICsJbXV0ZXhfbG9jaygma3ZtLT5zbG90
c19sb2NrKTsNCj4gKwlyZXR1cm4ga3ZtOw0KPiArDQo+ICtvdXRfZXJyOg0KPiArCW11dGV4X3Vu
bG9jaygma3ZtLT5sb2NrKTsNCj4gKwlyZXR1cm4gRVJSX1BUUihyKTsNCj4gK30NCj4gKw0KPiAr
c3RhdGljIHZvaWQgdGR4X3JlbGVhc2Vfdm1fc3RhdGVfbG9ja3Moc3RydWN0IGt2bSAqa3ZtKQ0K
PiArew0KPiArCW11dGV4X3VubG9jaygma3ZtLT5zbG90c19sb2NrKTsNCj4gKwlrdm1fdW5sb2Nr
X2FsbF92Y3B1cyhrdm0pOw0KPiArCW11dGV4X3VubG9jaygma3ZtLT5sb2NrKTsNCj4gK30NCj4g
Kw0KPiArREVGSU5FX0NMQVNTKHRkeF92bV9zdGF0ZV9ndWFyZCwgdGR4X3ZtX3N0YXRlX2d1YXJk
X3QsDQo+ICsJICAgICBpZiAoIUlTX0VSUihfVCkpIHRkeF9yZWxlYXNlX3ZtX3N0YXRlX2xvY2tz
KF9UKSwNCj4gKwkgICAgIHRkeF9hY3F1aXJlX3ZtX3N0YXRlX2xvY2tzKGt2bSksIHN0cnVjdCBr
dm0gKmt2bSk7DQo+ICsNCj4gIHN0YXRpYyBpbnQgdGR4X3RkX2luaXQoc3RydWN0IGt2bSAqa3Zt
LCBzdHJ1Y3Qga3ZtX3RkeF9jbWQgKmNtZCkNCj4gIHsNCj4gIAlzdHJ1Y3Qga3ZtX3RkeF9pbml0
X3ZtIF9fdXNlciAqdXNlcl9kYXRhID0gdTY0X3RvX3VzZXJfcHRyKGNtZC0+ZGF0YSk7DQo+IEBA
IC0yNjQ0LDYgKzI2ODQsMTAgQEAgc3RhdGljIGludCB0ZHhfdGRfaW5pdChzdHJ1Y3Qga3ZtICpr
dm0sIHN0cnVjdCBrdm1fdGR4X2NtZCAqY21kKQ0KPiAgCUJVSUxEX0JVR19PTihzaXplb2YoKmlu
aXRfdm0pICE9IDI1NiArIHNpemVvZl9maWVsZChzdHJ1Y3Qga3ZtX3RkeF9pbml0X3ZtLCBjcHVp
ZCkpOw0KPiAgCUJVSUxEX0JVR19PTihzaXplb2Yoc3RydWN0IHRkX3BhcmFtcykgIT0gMTAyNCk7
DQo+ICANCj4gKwlDTEFTUyh0ZHhfdm1fc3RhdGVfZ3VhcmQsIGd1YXJkKShrdm0pOw0KPiArCWlm
IChJU19FUlIoZ3VhcmQpKQ0KPiArCQlyZXR1cm4gUFRSX0VSUihndWFyZCk7DQo+ICsNCj4gIAlp
ZiAoa3ZtX3RkeC0+c3RhdGUgIT0gVERfU1RBVEVfVU5JTklUSUFMSVpFRCkNCj4gIAkJcmV0dXJu
IC1FSU5WQUw7DQo+ICANCj4gQEAgLTI3NDMsNyArMjc4Nyw5IEBAIHN0YXRpYyBpbnQgdGR4X3Rk
X2ZpbmFsaXplKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV90ZHhfY21kICpjbWQpDQo+ICB7
DQo+ICAJc3RydWN0IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+ICANCj4g
LQlndWFyZChtdXRleCkoJmt2bS0+c2xvdHNfbG9jayk7DQo+ICsJQ0xBU1ModGR4X3ZtX3N0YXRl
X2d1YXJkLCBndWFyZCkoa3ZtKTsNCj4gKwlpZiAoSVNfRVJSKGd1YXJkKSkNCj4gKwkJcmV0dXJu
IFBUUl9FUlIoZ3VhcmQpOw0KPiAgDQoNClNpbmNlIHlvdSBhcmUgY2hhbmdpbmcgYm90aCB0ZHhf
dGRfaW5pdCgpIGFuZCB0ZHhfdGRfZmluYWxpemUoKSwgbWF5YmUNCmp1c3QgY2hhbmdpbmcgdGR4
X3ZtX2lvY3RsKCkgaW5zdGVhZCAobGlrZSB0ZHhfdmNwdV91bmxvY2tlZF9pb2N0bCgpKT8gwqAN
ClRoaXMgaXMgbm90IHJlcXVpcmVkIGZvciB0ZHhfZ2V0X2NhcGFiaWxpdGllcygpIGJ1dCB0aGVy
ZSdzIG5vIGhhcm0gdG8gZG8NCml0IHRvbyBBRkFDSVQuDQo=

