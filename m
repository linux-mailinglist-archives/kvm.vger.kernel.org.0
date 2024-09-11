Return-Path: <kvm+bounces-26451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15261974854
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 04:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01F2BB24D5D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFCD2CCB4;
	Wed, 11 Sep 2024 02:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/q5vSow"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E647A3BBD8;
	Wed, 11 Sep 2024 02:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726022939; cv=fail; b=BoTMC8wQ4UyAS1KEcP7rf+mc85PFqjAroX6nrUhWibECNpqVovbRmED7XCCcHh9ysWHPvRUT2bXemTDWdHPWKSXnWFL+G9Jamp0tYqQUrDxkeRFbEhasXP7WF2woAuN7tM6TJr9uVnuVv2WgUe3h8GrvmcnGCc22cVcmswcBfcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726022939; c=relaxed/simple;
	bh=KzeFG1YyX64UhutaiAGEc55H3fa304NNOrzD/5oChHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l9BHwD/qeoA665ICrGNi8V+HuG4LrIeGg+JxTHXmJQH9O/kvNjQm4rk2c+9vi54IjKiKVKlBmx5hxfNpRIGMdAE6ChyLfwhX9B6+DBpMkrAp6icTAkBEHHKfp1krS4OufP2gI8KgMNhq1zDFDb3DeIhLO6VizgsGcSJLradKkCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/q5vSow; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726022938; x=1757558938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KzeFG1YyX64UhutaiAGEc55H3fa304NNOrzD/5oChHM=;
  b=B/q5vSowae7qwKfhRZQl6iKYA+ghYrWq/dCfqtZWZaV7VaHdMcTaRw9l
   nHFrhSptTiTfIjVCb5h0/7R9OwvirdSLR9Am+Z1yFc53HPFnGKIhh+/Bi
   N03F8jqR4UZO5/xcAVwWBA4ucRrZSonyl1+uCS9R2axn65GxhMkfrcPzl
   q5aRFLyV8AVTgVjLH06K8SBH0sYJUFMn0Sh7psvQdYPQ3D7SRlbekgEPe
   8JK/ryjY6YAAhGVZOSYqWLwEQN75Ec9TwlPEDyPfEpSiEHAlTaC++rKNo
   Wd1s420AobzUa2hHi2YYtXazBLeBT196XayGylFw2AHWWk1d7UjIOzMob
   w==;
X-CSE-ConnectionGUID: Af0kiUslR1ma+0XCIhXOBA==
X-CSE-MsgGUID: L9w0pT7JT3iLyakiyxXILA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="36181026"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="36181026"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 19:48:57 -0700
X-CSE-ConnectionGUID: sey+zkjoT/CPJTSqp8ElWg==
X-CSE-MsgGUID: rF0N2JfiTm2sgzwesBzEpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="71992274"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 19:48:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 19:48:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIrE2yW13ogOILCA+ZSUEixBPCXvdy+sOVSwKhW3eSSGANWWnVVL/g4472e6YEw178VwK7dDOWCGe6m3JnWPdSrajs+bCdr10Q0E4d/hv5ZYC5gYBwOZfRE5OK5MzFpaogsACqJnkzcDcAdrEtnfy9GglhVAvQK9TojNy59CfCn+Iv88E9qTtJllT8fNpVOJUoS3wpT20fhVttiVw55lANNrS9O5TEYq1iD9sYM6s/izDWkBPwcNE6tNnsQgcUsDyUcv3BnSFdLcjwtiqulB1b5cqeaOirezQe/XbYf7CaUeRySwDSzL1WNlG/c82X7+V5RxIAnWuShyGAG05iDuEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzeFG1YyX64UhutaiAGEc55H3fa304NNOrzD/5oChHM=;
 b=LZzacX28HdzBsRfhjU19L94xId2iwmbxQ1EA3OrepXsACSXP3QyQ1hb40M5E6X4387JsuVNMdGbpdzcywljloeg5pqXZzUc6SaA1gqcKEkopxMw+cDP13G1a2Y8/cWmJkRXVi6nja4GKbd43ggGMPjS/lstJYY/Nu118D1CseT2zDrIbqlOr6Gofwepea7DgJqgpaBMXhWnOS1EPn3lLIxYtRCO+Iv9GVbo2megkNdkODpCBut7VyOgQB/o+p1uyANpaY27iJyyiy4hU+QzOVeM4r/1H3WZtOok4hP9Y1gxQ484ccjWK3qEXSyQdQxRcREdWpdTPgpSsHFx44wHIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5784.namprd11.prod.outlook.com (2603:10b6:510:129::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Wed, 11 Sep
 2024 02:48:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 02:48:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIAAA0gAgAAT6QCAABdPgIABqJEAgAAZagA=
Date: Wed, 11 Sep 2024 02:48:52 +0000
Message-ID: <5f7ee34ca34bdfcc9bf8644b66d05b10cc2d42af.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
	 <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
	 <Zt-LmzUSyljHGcMO@google.com>
	 <8618bce9-8c76-4048-8264-dfd6afc82bc6@intel.com>
In-Reply-To: <8618bce9-8c76-4048-8264-dfd6afc82bc6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5784:EE_
x-ms-office365-filtering-correlation-id: 686b68ab-9735-4d4c-71a6-08dcd20c457f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VXNQTXNIYTNRbTdUSWk0ZlViYnZSVDlaRHFhSy8xNTJVdkNLRkdKd0loRU94?=
 =?utf-8?B?QnRxRlJuRU1TdFh3Y3dPYURqbG1HNExkeWVFVDh6WjFjc01WUkM5TW50Z2sz?=
 =?utf-8?B?R0p1U0JrdkNRd2k1ZkZnYlBDcXMvWmp6cFB1RzVrNHVIMGFYTThGODd2N0sr?=
 =?utf-8?B?QjNFUithckZXZUptbm56Uk9xSmhxV1BtaTRFZzhVeG1DWTlBQk90aklmQlB2?=
 =?utf-8?B?dFYzRFAyaWVROVVmM2J1cDRod0xkNUVGMHdTMjh6bDkvRnNkemVzaExXb0Fu?=
 =?utf-8?B?V3VvaGxZVlN2Mm93blRibXRqRWFzQ1JQUzhnWXpMQ2pVS0Ftd0pDZ2lnM1pv?=
 =?utf-8?B?cnNxNE5ERVlUU1JHV0RBeFVnZVVXd3FmbWVHeWhjTjdNa2lwcnBtREZQakJU?=
 =?utf-8?B?U2tlbjkrNUVYOHMwRVZJU1lsdXRxVERBM0hJeXVtbVZLZlVUOVQxREpKdkN3?=
 =?utf-8?B?Qk5abnBTWkZ5Ky90ZGg0R3FSa0s5cFVhT1ZSR1Y3VEFCVVVjaVdRNkZJNzdj?=
 =?utf-8?B?ZEN4dDdvTUtjNGNWaWw4aHpmTCtQREllQy81ai9WeEZyWFprRDYyaW82aTlV?=
 =?utf-8?B?aDJVMWlVRXcyZG00TXJPcmI1ZkJoWkp1Y0lvdmFNbXZITmF2aEZEMmkyZEFy?=
 =?utf-8?B?S3JlZURmOGJHQzhFVjlZOUYrOUQwbWU5NFgvOWF2NzNhS0NZNm5BY2lzRlhD?=
 =?utf-8?B?WVRvamZqWHkvVGxkUEJsOGowbWE5eWVJWVJMVGx6T3IrRy9yejU2eFRjcEt0?=
 =?utf-8?B?Z2w5ZzRkZlJEWUlsb1Z1SmhwL01rL0JIdWR6c0pkYkJYZ2FjNmtuNVZrZS9Z?=
 =?utf-8?B?QmNPa2x5YWU1bTFTRHdLbFp0L05qbmZscTk2eG9uRjJWZG95Yk00NFY5Um9M?=
 =?utf-8?B?U0twZU1mY2ZGeXZnREVEUy9vZlpUYnJLUERMMXVkWDBQUUY1NUpnQnN5Zk1T?=
 =?utf-8?B?N1VuSlNNakFOMG8wcS81TmpuSDdMUVZhS3A2aXIrOW9HTlVjeXNFVWIxMlpi?=
 =?utf-8?B?WEhOeDE4VERHazJjY1lUb01NN0tqMDQrdFhUSkI5dFp2aUdadmxvdUxyZytZ?=
 =?utf-8?B?TlFhc3huZnFPWFN4L2NneENCa2JpRnY4amYwMlpndFpFNGN5eHdmbG9xellz?=
 =?utf-8?B?MzN6Vk5RL0p1ZDZTTDNUYUhOZFlRZFhiNUFwczV5QTFwczZYcENzaFdiUTVP?=
 =?utf-8?B?bWkxUjVjZmkzTHh5Z284M0I0a25mVndpNDJtSXpYOW1vVzMzbnRJbm1iMEVV?=
 =?utf-8?B?dVlEN0Q5aGVzSGhnbHFXUFJWRTlWUHVXdGU3K05oeXpVbE1MVjVZSS9mdnBZ?=
 =?utf-8?B?V0VxN3hpa3FEYmVLTmpJcnpNSVRrbjNHUjUwMWkrd0Y2eDVtMGZUYWRrZlRy?=
 =?utf-8?B?UXJNRDhmTTgzQ2xBSmJWMGdJclBWeVJFa3FpbXhPMkMzakx2dmgvdEw0YnNk?=
 =?utf-8?B?MTYrYUFTNjJOM2tQVEJnV1lsTE84S3dhYWNGYWRwL2l5eXd2Y3BVb0x1V1k2?=
 =?utf-8?B?K0tITEpnMFUvaTU4WWFzeEpKK1RocXFDUFJleDFDVU91ZC9xS0dneTFHenI5?=
 =?utf-8?B?M3cxUzBRWnY2ZnQ5NE9SQXFqSUwxSjI4YnJTMFZDME1zUWJ0UzhxM01qc2dl?=
 =?utf-8?B?RHU0VjRKVlF2bXZXdkNwRDFXK3NwMDU0bTJQN29xdUNmTWRJYWt2NVA0c200?=
 =?utf-8?B?dnpOQkVPbk1UYlUzM1R0WXU2UEhGbFlGK1FoK3doankwbG5hb3JVRThES1hv?=
 =?utf-8?B?azZ1a080QlZON0dacWc2NlJJRVdqQ1JCaHpLSlRHejFGZlovZXdtOWQxMm5P?=
 =?utf-8?B?UFVFQUhub040dWhrNkhjOHh2eVl3WTNsM3lQKzRRSzhMVTU3TjZpajV5aStP?=
 =?utf-8?B?a094VWR1RVpKanVMSmRubXN1c0hjTTNHb3pxMi9vNTExM2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVQ2SDNvWEplYVpVNStHN3RYMzdEUlA4UWJGVUlVVjg3djdIVU0wdjVwbE9v?=
 =?utf-8?B?cmNoN0VZdXZJazdYaE9IVlMwTk5ETmtYdDkwcEcwMnI5WHNRMkFyenB3Wi95?=
 =?utf-8?B?QURYMzQ1TVZ5ZkJWUlFwZ2xxeVFUazBFUmJXVnAwMjlPUCtZNzEwWmlZd05l?=
 =?utf-8?B?aWgzd3Z5ekNGUTRVYy9tRXFtRndDU0tGSWFESWw1b0FaYnZMYUJBUFhpZHBm?=
 =?utf-8?B?eFZxbHBUWEExRGp5d0xmbU50RXBMYUZIY3JKR2dwUFM5MDUrVE1UenMxTWRM?=
 =?utf-8?B?SG0xYy9SalRXUnBwQmFoMkxhUlVITFZ1QmE1QVcrN0Nqa3VVM0VQMHlMRTd5?=
 =?utf-8?B?Q2d1ZTB6djNlcXlHMDROb0RUd1pJbUZxREdNS3Z2TlNOMjd2a3hVNFZSQmE5?=
 =?utf-8?B?Sm1ocmhkbUk1ZWtvdnFzSEhqYXBFdnVWaE5JZTVvQTJQcDlwVVowd3hQaUsz?=
 =?utf-8?B?bGkxSnN0bmk1Skx2NVo0Tk9HajlnOWczQ2xzQzJBK3FIeE9aSUlhbjMrUXdQ?=
 =?utf-8?B?UTIvNllPaXNCVkp5R0l5Zm5jamt4VGo1eHZYRUF1VHpTN0hSbWw1SnVFM2ll?=
 =?utf-8?B?bjVKOXd0RWFSMWx3cTJHMVcya0dKK2ZHUkZTajRmY2ljWVpNMGZ2aVBtWVR3?=
 =?utf-8?B?VkJVVENScHJjOWNXNHo3Z1NWK1BjdmFUOVJFWm9jaGJXSHNDaU5yZmVuTVYz?=
 =?utf-8?B?ZDhDejdnbDBCSnVac044b0I1YlVnKzJXWVZIWFhGVGRhL21EN1FNZGJRMWFP?=
 =?utf-8?B?SFFMbEd1bUttTmVKd096MWlXYTVTY1BHdEJvdmk0SEc3K21nLzB3ckxydTJy?=
 =?utf-8?B?cUI1aW1OTHVoNHhBOENwb0hrbHJkM3VYVDRmSWEzYXNEeldHZFMxZXptQlRp?=
 =?utf-8?B?QlRrRDBmVnNYSDhyYVFCWjRpZUdtYTFBbCtMSG9zS0Z4ZDZGSUhoc2FrcHRD?=
 =?utf-8?B?VWpJS2hBWVYxV1dYNU9lWTRsS0M0bU1NZDg4T2tHeUxUTi8zdFVaK29IRHB1?=
 =?utf-8?B?amljSVliQjN6WU1KOGgyUXpPWTRvclE5cnY3UUVlQ05yWlpLNXhzaFRoVmZp?=
 =?utf-8?B?a1plTGEvWC8ydjM3clI1R3N1NlZmUEVFOTErdFR0dmttNWhyYnJpVkRyZGZw?=
 =?utf-8?B?MHdNUjFVQTBzZk85dDMxU3NtZHpjTTRpRGc4eWJkcjJTYUY1N0h3dVRlMUc1?=
 =?utf-8?B?WHpNNlFtNHU1N2VrRzN3V0dFSFU5NnhkMlFvR1MvS243WjEzSGR5VEpZUFVm?=
 =?utf-8?B?ZTdmWEJsVnErdHVoTTk0dWdjeVZSSUhJTmxWbHhOcGszZkM5TUpvOVZKQ3Fj?=
 =?utf-8?B?SGZtaTZqMmpwdk1iYmNqQmVwRXlYMXBVeFovbjRleVpNUUhCZnhKNXNobkFn?=
 =?utf-8?B?bGRZa3pzZkwyOHFPR3FYMXNWUm0rMG9SdVN5UVpuMHltOUFlUHJ3L1FkWElU?=
 =?utf-8?B?SWdacEs2YjZLenE3SFJUQkU0aFIxMjUzb2k2UnlzTS90K2VCYWZaS1JNU0hZ?=
 =?utf-8?B?V2t4UlhrUUYrWjgyYXhjZ1MxcGJ6NWxWQnRFTDlsTXJtRCsydGowYWJBSTJK?=
 =?utf-8?B?ak1QdFpwcUxreTJkWmZRQ2JsK1Q2bSswSkEwdXZJcmxoYXdzdlNNcHZYaUNx?=
 =?utf-8?B?RVhYdlB6UkU3TExYTktGbkZoYTlKUEVMdkxYQjRrV3F4dlRMZExXK0ZZZmpX?=
 =?utf-8?B?Y2sySURBWE12RXA3OG04cGR5di90UEJMRlR0ZXVvWmpxZU1ZaW8yVFMzc1hj?=
 =?utf-8?B?R083R3Zrd2VKUWZocEVNTlM2OWQyTk1kaXUzY3BLbGJGT0JWcWdQVG5oRkRO?=
 =?utf-8?B?Y0ZWaHVEU0NYWWlCQTFZVTI1ZDdVdU5ORmkxMnVpMk1MM1VrWXFVelYwQ1hj?=
 =?utf-8?B?NXZGUlpRSU1jZFJ5NWUzZXI1QXQ5a2xwU0huOWlocjc1Vlg5MS9lYlI0ZC90?=
 =?utf-8?B?QlFGT1g1T04yTk84eVB5SFQ3ekFuQlNoMnk3VVo3QlEwcmtETEhxM1M1bTEy?=
 =?utf-8?B?Z0F6R0pyQndpTTNzajl3alZPVXMrOExub0dwQmE3NGYvNHp3eUVkWFFSengr?=
 =?utf-8?B?Yit3YzYzaDVXOWlzNExsbnNJNUZXclphTnZOTCtVaGNEZW5HMTk3RFQrMmgx?=
 =?utf-8?B?L1pmanB1ZWpDdml4TVRLcTl3b0xmc2owTElGWDhUcEN2aXEzVEgyemloZjBQ?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17215FC76C9D474E813ADADFF71328E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686b68ab-9735-4d4c-71a6-08dcd20c457f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 02:48:52.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PlvVMHeeHefyrAX8KOkD7LPZxgiorwKUbB3ud72vddsX6e9Upg2rh4GDovngkyHpGmXCxcdnnAnRKR5wTiSWjSIQjLkjsDLqOks/xflvbL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5784
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTExIGF0IDEzOjE3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IGlzIHRoZSBWTS1FbnRlcg0KPiA+IGVycm9yIHVuaXF1ZWx5IGlkZW50aWZpYWJsZSwgDQo+IA0K
PiBXaGVuIHplcm8tc3RlcCBtaXRpZ2F0aW9uIGlzIGFjdGl2ZSBpbiB0aGUgbW9kdWxlLCBUREgu
VlAuRU5URVIgdHJpZXMgdG8gDQo+IGdyYWIgdGhlIFNFUFQgbG9jayB0aHVzIGl0IGNhbiBmYWls
IHdpdGggU0VQVCBCVVNZIGVycm9yLsKgIEJ1dCBpZiBpdCANCj4gZG9lcyBncmFiIHRoZSBsb2Nr
IHN1Y2Nlc3NmdWxseSwgaXQgZXhpdHMgdG8gVk1NIHdpdGggRVBUIHZpb2xhdGlvbiBvbiANCj4g
dGhhdCBHUEEgaW1tZWRpYXRlbHkuDQo+IA0KPiBJbiBvdGhlciB3b3JkcywgVERILlZQLkVOVEVS
IHJldHVybmluZyBTRVBUIEJVU1kgbWVhbnMgInplcm8tc3RlcCANCj4gbWl0aWdhdGlvbiIgbXVz
dCBoYXZlIGJlZW4gYWN0aXZlLsKgwqANCg0KSSB0aGluayB0aGlzIGlzbid0IHRydWUuIEEgc2Vw
dCBsb2NraW5nIHJlbGF0ZWQgYnVzeSwgbWF5YmUuIEJ1dCB0aGVyZSBhcmUgb3RoZXINCnRoaW5n
cyBnb2luZyBvbiB0aGF0IHJldHVybiBCVVNZLg0KDQo+IEEgbm9ybWFsIEVQVCB2aW9sYXRpb24g
X0NPVUxEXyBtZWFuIA0KPiBtaXRpZ2F0aW9uIGlzIGFscmVhZHkgYWN0aXZlLCBidXQgQUZBSUNU
IHdlIGRvbid0IGhhdmUgYSB3YXkgdG8gdGVsbCANCj4gdGhhdCBpbiB0aGUgRVBUIHZpb2xhdGlv
bi4NCj4gDQo+ID4gYW5kIGNhbiBLVk0gcmVseSBvbiBIT1NUX1BSSU9SSVRZIHRvIGJlIHNldCBp
ZiBLVk0NCj4gPiBydW5zIGFmb3VsIG9mIHRoZSB6ZXJvLXN0ZXAgbWl0aWdhdGlvbj8NCj4gDQo+
IEkgdGhpbmsgSE9TVF9QUklPUklUWSBpcyBhbHdheXMgc2V0IGlmIFNFUFQgU0VBTUNBTExzIGZh
aWxzIHdpdGggQlVTWS4NCg0KV2hhdCBsZWQgeW91IHRvIHRoaW5rIHRoaXM/IEl0IHNlZW1lZCBt
b3JlIGxpbWl0ZWQgdG8gbWUuDQo=

