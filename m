Return-Path: <kvm+bounces-52514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1414EB06264
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F5F3ACD05
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6441722068F;
	Tue, 15 Jul 2025 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cl8Z956g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989D7204F8B;
	Tue, 15 Jul 2025 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592115; cv=fail; b=e6HGfS8UOtkc50X1g1JirAOMLlHiQzgASqT0Hyze5dS+TYEdd3amqt3WIcK2aC+KcQdx9rpIhcy7/GG4EthG1oiqUoWO4ZDNJ1zXU/QFYHUPSE5YxyMUSalHz58wkutVJD2CMH2GpoyRJrlly2kv96PnTV+tJ0H+NZEHWaqLJss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592115; c=relaxed/simple;
	bh=etnAiWHa9sQ2O+utS/44EE8pOl/PdxArtLG7Mtatd+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KSCkoz4FbIGyvz2fc038CLP4nPCHHs5mvlw6uWZ0roXwyCO8Xm14/Kh8r3SpW5K5RIDpnzc0Ok3La5AmQbmM4gFrQ2A2nlUIh6tvh3FACq4Db/ex1N/Nfe5pNkMsrhXZQxAdZXnxIWYq3HV8nIPUnfS7n+hiQ8tKx4T9IghqOWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cl8Z956g; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752592114; x=1784128114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=etnAiWHa9sQ2O+utS/44EE8pOl/PdxArtLG7Mtatd+w=;
  b=Cl8Z956g/jVApPuViTzhAfkPQcZW4ZfjsBVUAEd8vSb4kI+dnoDjKEBh
   +Yteanni8xyo9Nyw4BS20Y3ZoVkJt6jf3/6dJD+Is5DKsB5UH3+9zGqMP
   rZg3UqtYXu0W7JXDAJMo2RgC5bRCk6Uf5gl6GzZyl3whmm1CcqRLdIHm0
   qSVxH64ulCKmi/kBqK0i9kc4AJgldQwOK3dFb0844xPn3FqcidllSVuKn
   0HE43A9Igh2r0LILAYDOtfVueNUTB8Al6U76lLMHsSljEFOsl+bXwrc1j
   nsj01jd1jKxyOy3Qaszc5G0c0hLzROKdM66viK6inXc9yVPKWrjnRReb6
   g==;
X-CSE-ConnectionGUID: kz7s3QRHRVulz0TWE0ay5A==
X-CSE-MsgGUID: H8AwCDaBTZCcDxJ7gjGTFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54907515"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54907515"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 08:08:26 -0700
X-CSE-ConnectionGUID: vhKaBXtrR72ZFdjFuU5mCQ==
X-CSE-MsgGUID: 4/ITtBShT0Gri96O8Z+j8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="157354456"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 08:08:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 08:08:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 08:08:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.81)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 08:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdT6XSBpsEHIJCORMBB0rTu3AtmvJiCqksuaHoz1qPRiQ8nrfr2RrH+yHGF41lInQw+gs6MIKK63vQU9jIUuSpPZoYfpG/zV0qQendrZ/qeYmHfJK8WXBbkzCDX1ODmvTbaX4RkjLNuqf+PjkwZE+1M+1DMIKozbnlm2wpuXKl67rnMj+g1k27YlWvAqSXo8vMjphbUT6KOmoNPYEzaaYAfy4gAEO2lRNuydP1lLHdNECCnB85Rih1qT8wtwRY/hlwldIEBJ+by2MX4QDvJ1vLArhPBSGY5VeJmMJupSt1Lq82Znqtbr/deXd/RPSM/zjceldoH43ce378IYcRg/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etnAiWHa9sQ2O+utS/44EE8pOl/PdxArtLG7Mtatd+w=;
 b=GbiVMMatcTL1neHCGIEa/xAYy6qtmK6xNVnv1/TpspC71PPIQIBvof45UvigMjIvWq5EkuelTKok9/72wPCKW0SE5hzcovPuumdIrsrcaGnS7XzIlHGNBg++MhKfeGVW7fmBQEO8QfUmnB3RpAQItTOjXuiS1R/4WqRGSmXuO/qgA4zzzDWn2nircPs8aPT1sOaMK42iR8mzxZVE453pFzUalIUL+RM7xGoV3drNSt5hpTegklmRg7zxlQ0KjNKfanm94z2HTjGHRWn1UcRk3h6yFxH0svSkXwBlEgAYL01IvCDrWJJhExISNcz3uoL+Dd4KIOV9BTckooVTxDsE5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5034.namprd11.prod.outlook.com (2603:10b6:806:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Tue, 15 Jul
 2025 15:08:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 15:08:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kirill.shutemov@intel.com"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "tabba@google.com"
	<tabba@google.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao,
 Jun" <jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIAAXakAgAANiACAAXZuAIAAMLoAgAlDjYCAA28yAIAAOYQAgAC45ICABPMsAIABQ7EA
Date: Tue, 15 Jul 2025 15:08:17 +0000
Message-ID: <345e890e65907e03674e8f1850f5c73f707d5a36.camel@intel.com>
References: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
	 <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
	 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
	 <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
	 <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
	 <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
	 <aHCdRF10S0fU/EY2@yzhao56-desk>
	 <4c70424ab8bc076142e5f6e8423f207539602ff1.camel@intel.com>
	 <diqzikju4ko7.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzikju4ko7.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5034:EE_
x-ms-office365-filtering-correlation-id: a401c23c-59a1-4034-b38a-08ddc3b16d93
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Tys4V09FZ3B5VzhjU09HMmpMeTZORVl6Q1pDaHM0dlpHS0l3UnZkRmdydVMz?=
 =?utf-8?B?cjFsdTVPWnMxQlRFWHdKRnd1U2lSTWtMYkVaUHdOdzVwZGYvbDI3RjRjYjE2?=
 =?utf-8?B?UXdUMDkvM2xoL1hKcFhlTTBDMk0xQ3VSdTdGRUZZM0dwSHRPK0t3Nk5xZzVG?=
 =?utf-8?B?SFF4QnhnWjJUTGZxZlo0Z21yLzk0ZjVpQWpYbHRUeXBvQWxVbURrdWRLV1RY?=
 =?utf-8?B?eUtyeXErT1lkRS9yMHZESmk5dkorMGJyM05XRHpvb1Jrcnp4UUJiZjFlMndU?=
 =?utf-8?B?anpndHBNZzRnZDVNcVdKQk9lcUg4WS90bjFid25QOWhQWGs4RTlON1FaWStw?=
 =?utf-8?B?Zys4L3k0c25CSGc2cGIvQ00rQ0ZLempvL1BtZHRMRUtYY2g2cXhVUC8zdHY5?=
 =?utf-8?B?UXlyd2hSOUhEd1ArNmRkUmVGTXNsVDlkR1dXbW1zbzRmMXRaT3lxQ3RWTHhE?=
 =?utf-8?B?L3B0dkFLYzNjdzRXblNqaUlHcEQxOFh3bGVHY1FRMVdscTZ2WnpBeVNxMEpn?=
 =?utf-8?B?Umg0TWtVQzIzSUNYNlBCZG5RU3piMjArekpKZGswd21qYStUR2pNaDVUa2pY?=
 =?utf-8?B?dmhZRkVZZGlQTUN1SGJOdWNYbHQ0N0VnTURvcysvRUlYOXNUK0tmZGplNi9r?=
 =?utf-8?B?OVdqOUdBRzRxdkh3d2lRVW5URFEvVkFvQ0h3dTZ5UzROWFdNQWRZSWxzaTBG?=
 =?utf-8?B?anFkRGx2MzVpNGdJazhHVzhUSVpTUmNLalJqTWpCQzgvYXlReWdjTDZ5RGpx?=
 =?utf-8?B?bS9wR1NETE9ZbStQRTVJNlVyZG80TXZ5NjgycUdjRGdBV0p2VDdiM2I3Tzhx?=
 =?utf-8?B?SFZXNGtWaW5SWXY1cjJ3VUFDeTBvVVI5QzlmNjVaUUVhczRiOWpEaHVya1Mr?=
 =?utf-8?B?VVlncVV0d1J1M0JzdHBRbW5BTkpKVkI1QTdxeFo5R1J3NVZuU1VZemNFK3ll?=
 =?utf-8?B?NjZsbXNURW5uODNHQ0x6YU12cTZxdVFMT0FFT1J0S2dLUVBoZTQvNnFkWk9S?=
 =?utf-8?B?cC9Eb2FPZ3I1SStaYmxoUWFLOGQvWGxBSzBPelB5QUJDSjBpbUxTOHg4STQy?=
 =?utf-8?B?QnlRUERLVmNnVmlMTWVtcFQvSFlZNkJ6RVc5MCtUeTltdFlXT0hSRjIvcWdh?=
 =?utf-8?B?a0NDTmtlZzdZSE9ZMVAwOWZQQ2UrbW9keUVvSHd3RzRQTkozR3hrQ3ViOXRK?=
 =?utf-8?B?a3pwcEhxeHk4cUJGR1FWd09hWDBBYXlzV1VHc3JwTm1DYjdTQUh0VmF4RzJk?=
 =?utf-8?B?bWNMSnVkSkRzcmxVNmZJcXJ2c2FjTHdYbVpRcmZDUjBFMDE0YWNPWmtiYzcz?=
 =?utf-8?B?VVFnd0g3a1pWS2FTRHFnbC9ZYXA5WlZXaTY3TkpPR0JMU3dPVWhhTEpEUHpa?=
 =?utf-8?B?RVN6TlBhR2haOUNGQ3BaTzdPb29MMUtLWkVxZFF5T1NMUGpRSW5idTc2THFQ?=
 =?utf-8?B?R1hMVXlITWZUY2xTZWN1VGF3RVBOVCt6RDRPSEszVFZZWjBXTStpZkUrVHB1?=
 =?utf-8?B?UThWL290TGZZcURzbjI4U1NtU0pVS3UxcC9rREZob1hWNTcvZXBPcTkwdHB3?=
 =?utf-8?B?V2gyTUlvQmM5UmdyOUo4eEN2UWo5ZFJiL3pHZkMrK3ltb0dYbG4wMkgvK2sv?=
 =?utf-8?B?RHdHRkEvczNJREVxUlZPRFZLRTBQMG1BWGtLTFVJb1Yxay81aWprMkE2NUNT?=
 =?utf-8?B?Z3VVWTM0MVV4b3lGWTNYSGcyUzh6a3BzdEh3SFdYV3g2K3Y3RDJyRHFKQ0pG?=
 =?utf-8?B?ZEJ5ZTZlOU1LWVovdkZCUTlVRDN0UTZrYlZneHVERnM2dlE4WS9PWnFDS01T?=
 =?utf-8?B?MjFsTEZWaU9OZHM4bGdYTXl1czhud2NXbzA1dndRMWM4bFhkSm9kVTIxMk5Z?=
 =?utf-8?B?MnhrNHVrY0J2N1BBZW9NTUNjMTFOZHVId002S3l3YU42Nzk4bDZ2NEZKd0lw?=
 =?utf-8?B?Sm9XM3R3WWN3Y3F3bnVDeHlKWE94QmY3UzBSdjUyYTlKTlFmNUpGQXJTdHVt?=
 =?utf-8?B?N3pNQitFQXBnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0ZSMEhPL2pFdnh0bi9XWlpLODl3TVFFU3hxV0N0Q1U2Y1IrYUZ2d2JROENM?=
 =?utf-8?B?TStTR1l4K1lyZ3BTVjhuWTNTc3lPcVRwYVAyVGZpbjRZYXU3Y2x3TXUwUmN3?=
 =?utf-8?B?NDN6YXNzK0M2amxJSFE5anRKalFaT3dPbFlvdlU2VWhHZUY3SGtVU2ZNbTAx?=
 =?utf-8?B?bXFhUzlsM040a24yNGhLNDY3WmpTcVZaS0YydVVDb3YwRDBTMDVBbnl2T1Nq?=
 =?utf-8?B?dCt3UVNJd2tTdFFtQktLRWNKaTVaQjYzN1VnTURpZXREeTJHUzcwZjVkdWU1?=
 =?utf-8?B?dXFhcXZvdkI1bU1UZVhMVGRocTZiT3hKQmdncnk5K2pYNzRwWlRnUndlSnd5?=
 =?utf-8?B?cG1Yd3BTdFdSN2txYlYzcUZMRUJ5c0dxRW1xTVFncUR6eHhHNDJvamVzaTJH?=
 =?utf-8?B?Z2ppNWw0SDhDaDVvSWpNaW81ajV2bW5aODl1bTN0SERCSERyY1pNcXBCb3Z0?=
 =?utf-8?B?cklTc1lxY1JzYUtmRDNWVXlyYWM0eEdZS0JsckljRkN4QXI4UmR0alRsekdl?=
 =?utf-8?B?eEZRQXdrSVQramtVekVnaWFrKzlSOTUyeWpMN0lPSHMzeTI3MGZPa0RIV1or?=
 =?utf-8?B?V1VHTmNjcDRjTzBPRlNESGROT0NuZnhRRGNJWGQ5a2tET0I2M3g0VlVhUk0w?=
 =?utf-8?B?and3QzIyd250cFZrZzA5cXNxbDl3S3ZGRnIzbjNsa1dRNThUZU8yYXN4bnBv?=
 =?utf-8?B?YVpKSWtoQjVKVjZmclFKclRSWVdBV0Vodlo5SXNmRGlMSXA1eUIwZk40UWdR?=
 =?utf-8?B?WVhhZ2hqQWs5eEVuSXhsTmprQkk1OHVIU1VPTDFSMzByUmV4dTFaRXVBeUJD?=
 =?utf-8?B?N3AwL0R1RmIxRUtrUDNLWGxHajBsRUJoaWdkQkgxYnpJOW9MYk5DemdnRDh5?=
 =?utf-8?B?Q1NwSk1ONXh4RERNM0lXVjBnaVhpSnlGN2pkS0JQdGQ5RW14N1lBR2FQU0tQ?=
 =?utf-8?B?RG5DS2RQMXFxeXdjaHEveklrWHk5eTREWjZEOFNzN1F1MVZYV241Nk83aVMw?=
 =?utf-8?B?Yyt1a01oSzFxdi9KMDBUcDFYdnRhcTdTV3NWNmFPSTlFOXZmckFYa0xyRjBx?=
 =?utf-8?B?NkJ0RlcrWTN3WHdJdTM4RFFhV25iTWJBQmltYlFJalhYQUFRbTBoSTEzQW5o?=
 =?utf-8?B?amx0OGMwRlFDNzdrcUk3Z3QwcmpDNEpSZU9vR3dSeG9lc1VIdFFYZlZoWlJY?=
 =?utf-8?B?ZHhWblpQeFEwMFNzTEZYVlZaN0g0MXNFWVA0S1lUUElxZkQ4cDgvTGNSMk52?=
 =?utf-8?B?Q2JMQjV1dGF3QzdKcWlvdHg2SlhWbVllRkNnZkZ3MnltMVJ2Um5zeFByRjB0?=
 =?utf-8?B?aDF2eDQ1NjNBTDBxdzVxNlcyR3VIQjhZeDFpbVZ0dUNXdUc4KzY3ajNCaWNj?=
 =?utf-8?B?S09CaTcvNU11dHNnSEtNdjJHUi9hcVQ2RlovbHdtQVJYVkFJbnZrc3RsbXZT?=
 =?utf-8?B?RGdHMTk1S0NuT1B0SFBKRlBIUU9OWkpMdm80OFJ4bnRGRFJtQlVNVlcrSmJs?=
 =?utf-8?B?VDBiWmdRdE0vOFYvT1N4dWRRTlRiUlUvdXhnTlhKdHljelJVSENtb1ZNY09P?=
 =?utf-8?B?ZlNGVTg4aHZyRXY3QmlxVlFyaU1xRHNlK3Vick5IbysrUE5vMFdFTG9sRU5u?=
 =?utf-8?B?MzkvVWczMi9neGtjUU5VMzgvTmEwNURwU2dlZi93VTVvNDd4WWNTUE8wQngy?=
 =?utf-8?B?YmhTV0JmcUJ2MEYxdWpTdU9qTFdzSEV4YWdQN3pzYmZBR1BJSEd4Tm9sZEJw?=
 =?utf-8?B?YkJINlJSaFJobGFzUGJTZDhXTFM3V1MzMkF2YVpxeVJyRWVSajJKZUQ3RVcz?=
 =?utf-8?B?TTRITm93UkxPZjVQcHZLQ3ZDcXJCcUExb0hFdFFvZEtXTWd2Y0hjRlZaNkZt?=
 =?utf-8?B?b0o2dzRycXI0MnRlM0N1c05OOWxUYzBOcG5MZy9YdWxPdDB5d0E2UmNVUzRa?=
 =?utf-8?B?Y0xoOGlKN0l5SGxTbU1oUFExSythQnQ5cytOcGpDaml6SkM1OVFaSk1ERDF0?=
 =?utf-8?B?UitLUUJqS01BWnhzUjU5VHFkdGVPTW1IUFJZL2lkOXVKcGluVWVRZUowYVlV?=
 =?utf-8?B?YUZPQjJMRm9nSC9FaFVJYUxwSENJVWh6K1Q2cDMrQmFqZGFFa0J0ZFg3ckZn?=
 =?utf-8?B?eHhUdnRrbFN2S2xHR21ybi84ODI2V3h5Mms4bmdrUnlxMGNiMUluY3NMcjYv?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12ABBF6BAB080D4AA6C2316178F379D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a401c23c-59a1-4034-b38a-08ddc3b16d93
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 15:08:17.1346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ksCL8uC/9LLVOgZRMKbqbW4V9/o2BX05wuAa68GA+D4rI/SvxzpxOpwyoC15ZnsA3gPcuZYtmOm94mHlXSdFiBgkROXZPyACbzC3R5SZ0Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5034
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTE0IGF0IDEyOjQ5IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IEknbSBvbmJvYXJkIGhlcmUuIFNvICJkbyBub3RoaW5nIiBtZWFucyBpZiB0aGVyZSBpcyBhIFRE
WCB1bm1hcCBmYWlsdXJlLA0KPiANCj4gKyBLVk1fQlVHX09OKCkgYW5kIGhlbmNlIHRoZSBURCBp
biBxdWVzdGlvbiBzdG9wcyBydW5uaW5nLA0KPiDCoMKgwqAgKyBObyBtb3JlIGNvbnZlcnNpb25z
IHdpbGwgYmUgcG9zc2libGUgZm9yIHRoaXMgVEQgc2luY2UgdGhlIFREDQo+IMKgwqDCoMKgwqAg
c3RvcHMgcnVubmluZy4NCj4gwqDCoMKgICsgT3RoZXIgVERzIGNhbiBjb250aW51ZSBydW5uaW5n
Pw0KPiArIE5vIHJlZmNvdW50cyB3aWxsIGJlIHRha2VuIGZvciB0aGUgZm9saW8vcGFnZSB3aGVy
ZSB0aGUgbWVtb3J5IGZhaWx1cmUNCj4gwqAgaGFwcGVuZWQuDQo+ICsgTm8gb3RoZXIgaW5kaWNh
dGlvbiAoaW5jbHVkaW5nIEhXcG9pc29uKSBhbnl3aGVyZSBpbiBmb2xpby9wYWdlIHRvDQo+IMKg
IGluZGljYXRlIHRoaXMgaGFwcGVuZWQuDQoNClllYS4NCg0KPiArIFRvIHJvdW5kIHRoaXMgdG9w
aWMgdXAsIGRvIHdlIGRvIGFueXRoaW5nIGVsc2UgYXMgcGFydCBvZiAiZG8gbm90aGluZyINCj4g
wqAgdGhhdCBJIG1pc3NlZD8gSXMgdGhlcmUgYW55IHJlY29yZCBpbiB0aGUgVERYIG1vZHVsZSAo
VERYIG1vZHVsZQ0KPiDCoCBpdHNlbGYsIG5vdCB3aXRoaW4gdGhlIGtlcm5lbCk/DQoNCldlIHNo
b3VsZCBrZWVwIHRoaXMgYXMgYW4gb3B0aW9uIGZvciBob3cgdG8gY2hhbmdlIHRoZSBURFggbW9k
dWxlIHRvIG1ha2UgdGhpcw0Kc29sdXRpb24gc2FmZXIuIEZvciBmdXR1cmUgYXJjaCB0aGluZ3Ms
IHdlIHNob3VsZCBtYXliZSBwdXJzdWUgc29tZXRoaW5nIHRoYXQNCndvcmtzIGZvciBURFggY29u
bmVjdCB0b28sIHdoaWNoIGNvdWxkIGJlIG1vcmUgY29tcGxpY2F0ZWQuDQoNCj4gDQo+IEknbGwg
cHJvYmFibHkgYmUgb2theSB3aXRoIGFuIGFuc3dlciBsaWtlICJ3b24ndCBrbm93IHdoYXQgd2ls
bCBoYXBwZW4iLA0KDQpJIGhhdmUgbm90IGV4aGF1c3RpdmVseSBsb29rZWQgYXQgdGhhdCB0aGVy
ZSB3b24ndCBiZSBjYXNjYWRpbmcgZmFpbHVyZXMuIEkNCnRoaW5rIGl0J3MgcmVhc29uYWJsZSBn
aXZlbiB0aGlzIGlzIGEgYnVnIGNhc2Ugd2hpY2ggd2UgYWxyZWFkeSBoYXZlIGEgd2F5IHRvDQpj
YXRjaCB3aXRoIGEgd2FybmluZy4NCg0KPiBidXQganVzdCBjaGVja2luZyAtIHdoYXQgbWlnaHQg
aGFwcGVuIGlmIHRoaXMgcGFnZSB0aGF0IGhhZCBhbiB1bm1hcA0KPiBmYWlsdXJlIGdldHMgcmV1
c2VkP8KgDQo+IA0KDQpUaGUgVERYIG1vZHVsZSBoYXMgdGhpcyB0aGluZyBjYWxsZWQgdGhlIFBB
TVQgd2hpY2ggcmVjb3JkcyBob3cgZWFjaCBwaHlzaWNhbA0KcGFnZSBpcyBpbiB1c2UuIElmIEtW
TSB0cmllcyB0byByZS1hZGQgdGhlIHBhZ2UsIHRoZSBTRUFNQ0FMTCB3aWxsIGNoZWNrIFBBTVQs
DQpzZWUgaXQgaXMgbm90IGluIHRoZSBOREEgKE5vdCBkaXJlY3RseSBhc3NpZ25lZCkgc3RhdGUs
IGFuZCBnaXZlIGFuIGVycm9yDQooVERYX09QRVJBTkRfUEFHRV9NRVRBREFUQV9JTkNPUlJFQ1Qp
LiBUaGlzIGlzIHBhcnQgb2YgdGhlIHNlY3VyaXR5IGVuZm9yY2VtZW50Lg0KDQo+IFN1cHBvc2Ug
dGhlIEtWTV9CVUdfT04oKSBpcyBub3RlZCBidXQgc29tZWhvdyB3ZQ0KPiBjb3VsZG4ndCBnZXQg
dG8gdGhlIG1hY2hpbmUgaW4gdGltZSBhbmQgdGhlIG1hY2hpbmUgY29udGludWVzIHRvIHNlcnZl
LA0KPiBhbmQgdGhlIG1lbW9yeSBpcyB1c2VkIGJ5IA0KPiANCj4gMS4gU29tZSBvdGhlciBub24t
Vk0gdXNlciwgc29tZXRoaW5nIGVsc2UgZW50aXJlbHksIHNheSBhIGRhdGFiYXNlPw0KDQpXZSBh
cmUgaW4gYSAidGhlcmUgaXMgYSBidWciIHN0YXRlIGF0IHRoaXMgcG9pbnQsIHdoaWNoIG1lYW5z
IHN0YWJpbGl0eSBzaG91bGQNCm5vdCBiZSBleHBlY3RlZCB0byBiZSBhcyBnb29kLiBCdXQgaXQg
c2hvdWxkIGJlIG9wdGltaXN0aWNhbGx5IG9rIHRvIHJlLXVzZSB0aGUNCnBhZ2UgYXMgbG9uZyBh
cyB0aGUgVEQgaXMgbm90IHJlLWVudGVyZWQsIG9yIG90aGVyd2lzZSBhY3R1YXRlZCB2aWEgU0VB
TUNBTEwuDQoNCj4gMi4gU29tZSBuZXcgbm9uLVREWCBWTT8NCg0KU2FtZSBhcyAoMSkNCg0KPiAz
LiBTb21lIG5ldyBURD8NCg0KQXMgYWJvdmUsIHRoZSBURFggbW9kdWxlIHNob3VsZCBwcmV2ZW50
IHRoaXMuDQo=

