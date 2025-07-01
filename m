Return-Path: <kvm+bounces-51231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC961AF06A1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0FA4A0D14
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AC92FE322;
	Tue,  1 Jul 2025 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXErfCOj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D12F1A0BE0;
	Tue,  1 Jul 2025 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751409489; cv=fail; b=GvLM0+l9GkyfhQ0ouKGlyc3yPV26QbMMPaH5QDFU0SovGJSb/VscGpg53D2wnDuajxiExZpPXhkEgvs2FJ09P8487jhEs1qqT5S2D2Z2iVn7NstMots+Noop0dCzXf9yoLdkvZPKW6GZcdmvY9JFscTYsCqlvuSjOFQHUMckj/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751409489; c=relaxed/simple;
	bh=hvyB/MbuGJgthNW0v+Nm3fFB4jvfjYbYc4gdBKv68aw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C2XLIHy9dpDVSI3pveyMw9ISOvMm3bdh/NG5du7XWN04TWjn7Xv/3Ll7fAkbxc7NLGLXe18hFsYxYe0G8thRTwBe2DoMwtSvZ1XDHaJxHVHQivh8yYLAWNKHGHZmlg/ZOpI6e8oV80e2TqWy7/WboLU49bHozCrcFPbcNf9iD64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXErfCOj; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751409488; x=1782945488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hvyB/MbuGJgthNW0v+Nm3fFB4jvfjYbYc4gdBKv68aw=;
  b=XXErfCOjXv81c/UZnl9CE4qXzRESHX4WdFn0m1AX1w7qfvXVSUFxbBIB
   XO3etWhAWFnkAD2AWbJs2ZlwSrsJm9EWb88vf7YzY/xliCjGeRg/uu8uJ
   lo2Ppnh2mhl7qAIT5tkalw36s32VWnMe51mW19fVmcnQKeI5OkUo0u+Am
   h4ELF9Uwn3WO1gkdZJb4+i5YIiuMMxUod0P4xAo9nUDv20ecoOezbhFNk
   3Gg35ceJdWg/iAJL1AehilobJJN8nZjCWK6BTaiPKL9zyq4qkHaY76vH+
   TLOo2dZSXlzVPHAgoMOO7DvTUyuRUmGhtYMmkj4w7ze8uGq1i6kaz+lU/
   A==;
X-CSE-ConnectionGUID: cqyE1Hw5TO6X4PmOc8pbRA==
X-CSE-MsgGUID: Sj+PtPOvTyCoDJb7XbWgsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57501543"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="57501543"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 15:38:07 -0700
X-CSE-ConnectionGUID: zRtnHd2OT0e3ti3HqDQsoA==
X-CSE-MsgGUID: gu7JwhS7Syy7ZkUdNhkJFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="184848062"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 15:38:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 15:38:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 15:38:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 15:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mdLYxvYhUwkK2YQRDLyroxg15GkOQlpts8ZIHQrDJ7zlfcHxe8gM3dFNJTdDjUXwgFaJQfE9Dkc3bRSsDHLti0n0weNPuHiNkSpJ8ZWJGX9uepmAaaC37iZs99Zi04Q3C7medYUvC8wmYmF28pjn6JPNO7nRCOfpp/Rtn8kplGOsBdi4c6vPvvUftPcdrnVYsubG6sEWKxpArFKSYCjx/eHFRF1QvnT4ldktB/nY9tKDrKLwH9TbT7waLr9RokL4EuvfS8oySmtb3ygF3aNwQhdlIH7zQroe4yAfvTxeXCZN10OLr6xmb8LCiAMmro1RiZaaAdS+Qu+XyO/zFsdHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvyB/MbuGJgthNW0v+Nm3fFB4jvfjYbYc4gdBKv68aw=;
 b=uZy9KAa7em+nyJqrAkAZn9PwJxlFzT9QRZq4ap9fJp9X7aW/VSla/AqTH1DIZ/GCnGL8WHQD3a6oqOFJl8Z4tnE7l2XzBpswfd0ZQLeXsJdJEO8IL5rPRX9aVmoln4CggUL7ViJoY2s8oSrej6lOCpD8PiC9eqq5m7kx+I2eG2p6xf5M0NxZi6OX0xH3sl0Dsgr3qgM0nBUuOJi2/kUUyBAjGv6oVuT2HJ4uPvJ+Adcl/PSkNnZQ5pioipm15EjfHAltrluy8TUgsfxhndf8KrS130haADaiyi0+Umxdb4YReXX4GaAXQB8/jILRcg5teSj+Z2XGl+Icc8pkDCmpVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8131.namprd11.prod.outlook.com (2603:10b6:8:190::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 1 Jul
 2025 22:37:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 22:37:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIAAXakAgAANiAA=
Date: Tue, 1 Jul 2025 22:37:21 +0000
Message-ID: <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8131:EE_
x-ms-office365-filtering-correlation-id: a51bc5b9-d740-4e31-6285-08ddb8efd7f4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a1ZJZmJXdk0yYjNLT1YzNXpZd250VHhXbEJLQjkzOFVCRG1DRVprQlh1V3J2?=
 =?utf-8?B?SVdrdHVvMmNxekh2QXRNWEsrSjVOa3JOeUNuRUduWEd0RGVVWXBJLzArMUtQ?=
 =?utf-8?B?aWx0VFJOY1FsY3ZFRk9qSEpmQjVwNW5vZTFzMlNMa2VreWlxS25LMEF6SmVZ?=
 =?utf-8?B?OVV4K05BakppRGViUFBsdmxZTXIremdaMG5GSkNFNERYQ3R5dHp4Nlg4T3Y5?=
 =?utf-8?B?Mi9PcDNTU21kSy9KbndyU1R2anB1dHpRMXg5U1ovaXhOTHJ4dkp6d2thRTB3?=
 =?utf-8?B?QmxTOS9MU21jcUdobXRYNnlDT3pmM1pMem5wa1Vld05wTWNVdTlHeDVEUkRC?=
 =?utf-8?B?MXlqUlZBcm1ZODBWVnBmZkhoQmRaMHRxR0w5dTdQVVJ4N3ZRMkRUWEx0R1gr?=
 =?utf-8?B?QnY0NWQzb0FkRGRyTXBaQ1hBRmxydUhsUUxDSm41MHhBSWtSVHRFWUE5WVo5?=
 =?utf-8?B?U1Q1RmVQL1oxRG84cCtRczFTNTF3NWQ1Ry9FRGx0RHFsSGlGZUZITC9lS0Rj?=
 =?utf-8?B?ZGFhZHI4MkpRU0ExUWRFdUtFMGNMbGlUR092dWNiU0hWUkFqWUZjYmtabEpt?=
 =?utf-8?B?WXF0OEVRZDBDTmUrUE5xYU05TFR2ZVI5aFQxdndwMzBlRHMzR2lreTI1eVdw?=
 =?utf-8?B?Z3BldjE0Ynd1YXBCVWdjZlhMSGNQdGdRNVRPd0Nnb2xYamRGNUtCN0pNQiti?=
 =?utf-8?B?a092dUVSZU9reG16SVhsYzg5NU9aRU12SlRRbjgvZjR6L1ZqL0JqWGU5RThG?=
 =?utf-8?B?Qkl3QUl4TUR2Q25FcDJmRk5qOTNLeWxvbW1zdThZWDRJd3B6MHB4VlJpTTlS?=
 =?utf-8?B?OTgrZG1yc0xLVUxpdHJXbGNiMnpRazhzZVRjaGQ2RTRlSXJnbW82Ynp2QStx?=
 =?utf-8?B?Z0NFWE5ZT253cVBxM3ZrMUQ3c2hVSko0dEZ2WXhzekVjcUNTZ1IzV1p1NmV1?=
 =?utf-8?B?UkJlMWFkbWlvSGxHaHI2TW1qL2loZldGVERoc2poeDIzVVlzTkwzRXJ0RTdn?=
 =?utf-8?B?QmMxa0VtWmVpWXhYR20zUDJzUmFlWS85UzJvWFZERHA3WDdsYmhIZmhjakhi?=
 =?utf-8?B?MmpaVUhRL3ErZHB6ZmpveTMvczRIU0t1dHFhSWkzT05XNTQxRjZtYXh5L0dC?=
 =?utf-8?B?SDYrMGtaaW5jbE5uM1daUXpwSHVuQUE3WjBPN0g5YnlndnpsbDJrazVSUDdD?=
 =?utf-8?B?L2lHRktrN0lVN1c0RUNMSXAxQXRSNDQvOXRkbGdIUFdSNUtiUG1KMDVRWGlk?=
 =?utf-8?B?SkdadS9SRnZwSDJFaGxCL3ZDaGlBUTQzVERBVjhUQzlXN0JocGtqYlpndkpZ?=
 =?utf-8?B?Kzc3M0VwK0ExUnd4RkJyWjQ5UnNYOFVMNUxrWUdFbnVHUm1MMXlvRGZWRlpp?=
 =?utf-8?B?QjEwbUt5ZUt0TTd5ejJnd09IeU5vM1ZocjBLR0U3YlErc0k3MFA1Zkp4ZmhL?=
 =?utf-8?B?TmpneWc0c0ZMQ0hDSktzblhpL0Q5eGdmU21jN2hFUm55SVhNR2JWd1A5djJ6?=
 =?utf-8?B?Sk90UVg5TXllUy9GUVo2YktzWjdFWkhJN2d6YlBtaXZwQ01aVVhDT0NTOTRO?=
 =?utf-8?B?Rm1MVnArSG1Fa243ZHhEeVhnUytGajd2amR1T205NWVYZGVqK2pNc081WVk2?=
 =?utf-8?B?b2VZZXpyZ3JJWlJiM3NrOE44TGt6NlBHY01VTkN2QlVFR0owSEpaaDE3dllD?=
 =?utf-8?B?d0JMa3IvdzhTQXpDWVViVjdNSGtnekFlMmlDeDhGZVFjU3Evb3lieXhOYm1h?=
 =?utf-8?B?bjd1cDBIbTFTTldOZU43cHRoN3A1MkkxUzdBWmZRdldjeS9qdm9VWmFYTHE3?=
 =?utf-8?B?cnJSNFY0VGF1SWpSVlVRNm1Cc2UrazhNM1NSZ080RHJoZ1NtYjZLNzFOK3dp?=
 =?utf-8?B?UmRQZmdrNTdXQzBKR3dYVWJEbEFBUUlCdnhTY3VoU1VHaEFieWN0SHpTK2hm?=
 =?utf-8?B?ZWR4MW0wR2lndnk0R2hTQ3RzSENWZ0RIb0JoaXpNb3dzQW5jQWgwTXh4SXZm?=
 =?utf-8?Q?ywha2Pj5hq82nMzRIqgV6+5J2lnqWM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1dseWZ0VFhFKzhUVnZJK05IeUp4azNZaXEvYng0cHg1OUd2bUFDNVY2NHZk?=
 =?utf-8?B?blZNU0xEN0RIQi90VFJSWmRObUk0aXVPYzhhaExWRDV3aklnSGgyZytlWnhJ?=
 =?utf-8?B?bzR4Ykx4VW9NWDQ0N3RnMjRkb3JraWpDbDRKVEVBNTNhSlFraVlvZG5tV3V1?=
 =?utf-8?B?Wk5hbThPcllrYzVpb3U4ZUJQMEtvZ0J5MGs3YkpYSkFoc3FFZTFjWHBBaG1w?=
 =?utf-8?B?djJwZXhSQ21JRmVEdWY5YmJ3dldpdFBDSFRxSXo1ZTQvTUkrODcrK1NGVUVh?=
 =?utf-8?B?WHZJemluUGxVbVhnaFFHdDJzdU45aHYwZ3ZnS091NUlkRE1FZWtxb1YyZXJK?=
 =?utf-8?B?bkkxTjdsdFQwcmpabVBBVG91UElxc09rYzl3amlVT2gyL3FoSHhNUXAxVCtE?=
 =?utf-8?B?V081d1VUZWdnN2pMQ3dwWHVCY21jVXRYVHV0bUJ1TjJnK3VwOGFvK3VRRi9P?=
 =?utf-8?B?cmV5a3lGaVpnQWdYUFNwaU5hS3B2dDlDRTdLNnd1b3crZ2NpSHNqYjl0elEz?=
 =?utf-8?B?RUxnUDd0Z010WnUvdzZkbk13d29pLzY1RjlVbjRJd2QxcEdFRHI3bkRkY09n?=
 =?utf-8?B?R21iVTZ3UzNqQmFjemJmZDFKaHpnV3k4TTNZOXl1SlFDNURaSUp4ekZqSUpP?=
 =?utf-8?B?ZnlCK2wrZlRiT1YxUFEwaE4wbTF3OFRydmM0WkpuRk9PU2JFUS9kK3BveGsx?=
 =?utf-8?B?dGxaN1R3RXR3a2JvWjlweFN3MDQxczNwTC9waDRzc1pHY25ibjVINHdOUy9H?=
 =?utf-8?B?ZTVSdW8xNzQzUE40Mm9MWDJIT2dSQ3AwVk1VbHd0S1grWG9ZSk0vVnVhTWtC?=
 =?utf-8?B?V21KNklucURBYjNsM1R2T045MHBTeDdTeVY1T0pQbCttMXFzUk0rY3QxdTgx?=
 =?utf-8?B?OVBnbjE0TDRGRW5XeHpCZmVxWmpNdEk2REtyRnRaN0ZRaWFEZ0s3YWc3VHRZ?=
 =?utf-8?B?SnB5VU9FM04wTG1BbWNZcnFyNnFkVXRuU1VFRUdheGExOFVyY0p0S0kvL2cx?=
 =?utf-8?B?aE9TaFFBbHVUaGdQeXYzSVRTU1huejBnRU5EVEY0WC93WEwyUFJOYit0R1hZ?=
 =?utf-8?B?TGxCb1l3QjhyM0ZjSVJQdG9TeU1Na0t1R3p6RDRtR1F2VVNlRFhmWWlKN1Yr?=
 =?utf-8?B?djRIZWxLc0NLMmUvUWdmR25ibVZWQnJoWVRYalRXYWVYUk9uN2xCK3VSaStp?=
 =?utf-8?B?NmZDQkN1aEpybS81SDVUaU5mSnorZCtwTGpHNU1rLy8vK000cExVUmRGZk5u?=
 =?utf-8?B?cEdnVHNoRG1INDF2SXorcnFWUk5ZeW9TdE5nd0lsL1J6VGtZdzdPQXRwK0Fw?=
 =?utf-8?B?bHkzb0dCL1NCL0lUT0drRStFZDRqbG15YzhScllJRTFPN1d0cU5SVzM4bEcr?=
 =?utf-8?B?ZUpjVXZRL0FpbVVWaVJGMzlVQkZBTG9mcjNBcTEvZ2piTWFkOEJ1NXZ5d3Jp?=
 =?utf-8?B?NHAvQlJmOFdIekh0UFJpY0hzbWRLMVFUQWJDY0lMZ0hwdDZiK0FFL2ErU2tJ?=
 =?utf-8?B?dGZlaGhhZWUzU2Q2d0N0ZkIrdHNaaGZJMjczbGtVME1VNTEzTHErMVFnMGJK?=
 =?utf-8?B?Zmd4bGZkWC96L2RWUjBCbmpud0pMTmtkUnNTTjBHbTNOL3Z6Q1llbVUzUmZI?=
 =?utf-8?B?RnE4c0krRDVGYmVCcC9nSksyOGgvaUpuNVNZMk41bHcreGpSWHVFVlBTKzVy?=
 =?utf-8?B?N2lUZnoybzg4UUVSUUY5L1o0TVBDd2E3bzdaazBoKzZJQlBMeTNiL1VidXpo?=
 =?utf-8?B?ckNoS3dWNVNGTC9mbEpkdkV0WEo4NUlyc0QzVks3TEFqdGdVZUNWckpwbU4w?=
 =?utf-8?B?QkVISk81c2ZxZWc2V1UrWmZka2JCWkhBaGdxWGNPTUxXeit5eU9TTGlJWmNq?=
 =?utf-8?B?MVFuZmh0Wjh5YlFTejlzczhLaTBuVjhRMmRPSk5QVVpuMEoxQ3dDRzNYSFBh?=
 =?utf-8?B?S2ExR1RLK1c3RzhjWDAvRnArT1JuTUVyZ0hrcTlrMnk3OTI5aXpRcVFnWUxl?=
 =?utf-8?B?S015TFNBV0kybWxQWFcyUkxPZkdxWXpnVUduanFVSEE0ZW5icDAvaU9vaUlp?=
 =?utf-8?B?NjN0d0g4SmhBQlpjZGtHcU1mS21GajdYekoxSjV2T1Y2M3hsY2hSamIzMWZt?=
 =?utf-8?B?aytmVzNNMFErTy95Q2xxZ1MvamFpU1JyWFVSUmduMFM1Q21kZDRWa3U0bHVG?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A585CBC19C8C0043849D9343AD34F6CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a51bc5b9-d740-4e31-6285-08ddb8efd7f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 22:37:21.6027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qExvA2XtG1IeV7uPZ5Le0cTcUN6+VVnCUIPUw2E/z5fYy1TV1J0rJtm4V9tzE49MJg/Uxcoq4AFf1xGlKlREmvP4Dsk+TioNB8/fTVm3CzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8131
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDE0OjQ4IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IFBlcmhhcHMgd2UgaGFkIGRpZmZlcmVudCB1bmRlcnN0YW5kaW5ncyBvZiBmL2cgOlANCg0KQWgg
eWVzLCBJIHRob3VnaHQgeW91IHdlcmUgc2F5aW5nIHRoYXQgZ3Vlc3RtZW1mZCB3b3VsZCB1c2Ug
cG9pc29uIGludGVybmFsbHkNCnZpYSBzb21lIGdtZW1fYnVnZ3lfcGFnZSgpIG9yIHNpbWlsYXIu
IEkgZ3Vlc3MgSSB0aG91Z2h0IGl0IGlzIG1vcmUgb2YNCmd1ZXN0bWVtZmQncyBqb2IuIEJ1dCBh
cyBZYW4gcG9pbnRlZCBvdXQsIHdlIG5lZWQgdG8gaGFuZGxlIG5vbiBnbWVtIHBhZ2UgZXJyb3Jz
DQp0b28uIEN1cnJlbnRseSB3ZSBsZWFrLCBidXQgaXQgd291bGQgYmUgbmljZSB0byBrZWVwIHRo
ZSBoYW5kbGluZyBzeW1tZXRyaWNhbC4NCldoaWNoIHdvdWxkIGJlIGVhc2llciBpZiB3ZSBkaWQg
aXQgYWxsIGluIFREWCBjb2RlLg0KDQo+IA0KPiBJIG1lYW50IHRoYXQgVERYIG1vZHVsZSBzaG91
bGQgZGlyZWN0bHkgc2V0IHRoZSBIV3BvaXNvbiBmbGFnIG9uIHRoZQ0KPiBmb2xpbyAoSHVnZVRM
QiBvciA0SywgZ3Vlc3RfbWVtZmQgb3Igbm90KSwgbm90IGNhbGwgaW50byBndWVzdF9tZW1mZC4N
Cj4gDQo+IGd1ZXN0X21lbWZkIHdpbGwgdGhlbiBjaGVjayB0aGlzIGZsYWcgd2hlbiBuZWNlc3Nh
cnksIHNwZWNpZmljYWxseToNCj4gDQo+ICogT24gZmF1bHRzLCBlaXRoZXIgaW50byBndWVzdCBv
ciBob3N0IHBhZ2UgdGFibGVzIA0KPiAqIFdoZW4gZnJlZWluZyB0aGUgcGFnZQ0KPiDCoMKgwqAg
KiBndWVzdF9tZW1mZCB3aWxsIG5vdCByZXR1cm4gSHVnZVRMQiBwYWdlcyB0aGF0IGFyZSBwb2lz
b25lZCB0bw0KPiDCoMKgwqDCoMKgIEh1Z2VUTEIgYW5kIGp1c3QgbGVhayBpdA0KPiDCoMKgwqAg
KiA0SyBwYWdlcyB3aWxsIGJlIGZyZWVkIG5vcm1hbGx5LCBiZWNhdXNlIGZyZWVfcGFnZXNfcHJl
cGFyZSgpIHdpbGwNCj4gwqDCoMKgwqDCoCBjaGVjayBmb3IgSFdwb2lzb24gYW5kIHNraXAgZnJl
ZWluZywgZnJvbSBfX2ZvbGlvX3B1dCgpIC0+DQo+IMKgwqDCoMKgwqAgZnJlZV9mcm96ZW5fcGFn
ZXMoKSAtPiBfX2ZyZWVfZnJvemVuX3BhZ2VzKCkgLT4NCj4gwqDCoMKgwqDCoCBmcmVlX3BhZ2Vz
X3ByZXBhcmUoKQ0KPiAqIEkgYmVsaWV2ZSBndWVzdF9tZW1mZCBkb2Vzbid0IG5lZWQgdG8gY2hl
Y2sgSFdwb2lzb24gb24gY29udmVyc2lvbnMgWzFdDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsL2RpcXo1eGdoamNhNC5mc2ZAYWNrZXJsZXl0bmctY3RvcC5jLmdvb2dsZXJz
LmNvbS8NCg0KSWYgYSBwb2lzb25lZCBwYWdlIGNvbnRpbnVlZCB0byBiZSB1c2VkLCBpdCdzIGEg
Yml0IHdlaXJkLCBubz8gSXQgY291bGQgdGFrZSBhbg0KI01DIGZvciBhbm90aGVyIHJlYXNvbiBm
cm9tIHVzZXJzcGFjZSBhbmQgdGhlIGhhbmRsaW5nIGNvZGUgd291bGQgc2VlIHRoZSBwYWdlDQpm
bGFnIGlzIGFscmVhZHkgc2V0LiBJZiBpdCBkb2Vzbid0IGFscmVhZHkgdHJpcCB1cCBzb21lIE1N
IGNvZGUgc29tZXdoZXJlLCBpdA0KbWlnaHQgcHV0IHVuZHVlIGJ1cmRlbiBvbiB0aGUgbWVtb3J5
IGZhaWx1cmUgY29kZSB0byBoYXZlIHRvIGV4cGVjdCByZXBlYXRlZA0KcG9pc29uaW5nIG9mIHRo
ZSBzYW1lIG1lbW9yeS4NCg0KPiANCj4gPiBXaGF0IGFib3V0IGEga3ZtX2dtZW1fYnVnZ3lfY2xl
YW51cCgpIGluc3RlYWQgb2YgdGhlIHN5c3RlbSB3aWRlIG9uZS4gS1ZNIGNhbGxzDQo+ID4gaXQg
YW5kIHRoZW4gcHJvY2VlZHMgdG8gYnVnIHRoZSBURCBvbmx5IGZyb20gdGhlIEtWTSBzaWRlLiBJ
dCdzIG5vdCBhcyBzYWZlIGZvcg0KPiA+IHRoZSBzeXN0ZW0sIGJlY2F1c2Ugd2hvIGtub3dzIHdo
YXQgYSBidWdneSBURFggbW9kdWxlIGNvdWxkIGRvLiBCdXQgVERYIG1vZHVsZQ0KPiA+IGNvdWxk
IGFsc28gYmUgYnVnZ3kgd2l0aG91dCB0aGUga2VybmVsIGNhdGNoaW5nIHdpbmQgb2YgaXQuDQo+
ID4gDQo+ID4gSGF2aW5nIGEgc2luZ2xlIGNhbGxiYWNrIHRvIGJhc2ljYWxseSBidWcgdGhlIGZk
IHdvdWxkIHNvbHZlIHRoZSBhdG9taWMgY29udGV4dA0KPiA+IGlzc3VlLiBUaGVuIGd1ZXN0bWVt
ZmQgY291bGQgZHVtcCB0aGUgZW50aXJlIGZkIGludG8gbWVtb3J5X2ZhaWx1cmUoKSBpbnN0ZWFk
IG9mDQo+ID4gcmV0dXJuaW5nIHRoZSBwYWdlcy4gQW5kIGRldmVsb3BlcnMgY291bGQgcmVzcG9u
ZCBieSBmaXhpbmcgdGhlIGJ1Zy4NCj4gPiANCj4gDQo+IFRoaXMgY291bGQgd29yayB0b28uDQo+
IA0KPiBJJ20gaW4gZmF2b3Igb2YgYnV5aW5nIGludG8gdGhlIEhXcG9pc29uIHN5c3RlbSB0aG91
Z2gsIHNpbmNlIHdlJ3JlDQo+IHF1aXRlIHN1cmUgdGhpcyBpcyBmYWlyIHVzZSBvZiBIV3BvaXNv
bi4NCg0KRG8geW91IG1lYW4gbWFudWFsbHkgc2V0dGluZyB0aGUgcG9pc29uIGZsYWcsIG9yIGNh
bGxpbmcgaW50byBtZW1vcnlfZmFpbHVyZSgpLA0KYW5kIGZyaWVuZHM/IElmIHdlIHNldCB0aGVt
IG1hbnVhbGx5LCB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSB0aGF0IGl0IGRvZXMgbm90IGhhdmUNCnNp
ZGUgZWZmZWN0cyBvbiB0aGUgbWFjaGluZSBjaGVjayBoYW5kbGVyLiBJdCBzZWVtcyByaXNreS9t
ZXNzeSB0byBtZS4gQnV0DQpLaXJpbGwgZGlkbid0IHNlZW0gd29ycmllZC4NCg0KTWF5YmUgd2Ug
Y291bGQgYnJpbmcgdGhlIHBvaXNvbiBwYWdlIGZsYWcgdXAgdG8gRGF2aWRIIGFuZCBzZWUgaWYg
dGhlcmUgaXMgYW55DQpjb25jZXJuIGJlZm9yZSBnb2luZyBkb3duIHRoaXMgcGF0aCB0b28gZmFy
Pw0KDQo+IA0KPiBBcmUgeW91IHNheWluZyBrdm1fZ21lbV9idWdneV9jbGVhbnVwKCkgd2lsbCBq
dXN0IHNldCB0aGUgSFdwb2lzb24gZmxhZw0KPiBvbiB0aGUgcGFydHMgb2YgdGhlIGZvbGlvcyBp
biB0cm91YmxlPw0KDQpJIHdhcyBzYXlpbmcga3ZtX2dtZW1fYnVnZ3lfY2xlYW51cCgpIGNhbiBz
ZXQgYSBib29sIG9uIHRoZSBmZCwgc2ltaWxhciB0bw0KVk1fQlVHX09OKCkgc2V0dGluZyB2bV9k
ZWFkLiBBZnRlciBhbiBpbnZhbGlkYXRlLCBpZiBnbWVtIHNlZSB0aGlzLCBpdCBuZWVkcyB0bw0K
YXNzdW1lIGV2ZXJ5dGhpbmcgZmFpbGVkLCBhbmQgaW52YWxpZGF0ZSBldmVyeXRoaW5nIGFuZCBw
b2lzb24gYWxsIGd1ZXN0IG1lbW9yeS4NClRoZSBwb2ludCB3YXMgdG8gaGF2ZSB0aGUgc2ltcGxl
c3QgcG9zc2libGUgaGFuZGxpbmcgZm9yIGEgcmFyZSBlcnJvci4gQWx0aG91Z2gNCml0J3Mgb25s
eSBhIHByb3Bvc2FsLiBUaGUgVERYIGVtZXJnZW5jeSBzaHV0ZG93biBvcHRpb24gbWF5IGJlIHNp
bXBsZXIgc3RpbGwuDQpCdXQga2lsbGluZyBhbGwgVERzIGlzIG5vdCBpZGVhbC4gU28gdGhvdWdo
dCB3ZSBjb3VsZCBhdCBsZWFzdCBjb25zaWRlciBvdGhlcg0Kb3B0aW9ucy4NCg0KSWYgd2UgaGF2
ZSBhIHNvbHV0aW9uIHdoZXJlIFREWCBuZWVkcyB0byBkbyBzb21ldGhpbmcgY29tcGxpY2F0ZWQg
YmVjYXVzZQ0Kc29tZXRoaW5nIG9mIGl0cyBzcGVjaWFsbmVzcywgaXQgbWF5IGdldCBOQUtlZC4g
VGhpcyBpcyBteSBtYWluIGNvbmNlcm4gd2l0aCB0aGUNCmRpcmVjdGlvbiBvZiB0aGlzIHByb2Js
ZW0vc29sdXRpb24uIEFGQUlDVCwgd2UgYXJlIG5vdCBldmVuIHN1cmUgb2YgYSBjb25jcmV0ZQ0K
cHJvYmxlbSwgYW5kIGl0IGFwcGVhcnMgdG8gYmUgc3BlY2lhbCB0byBURFguIFNvIHRoZSBjb21w
bGV4aXR5IGJ1ZGdldCBzaG91bGQgYmUNCnNtYWxsLiBJdCdzIGluIHNoYXJwIGNvbnRyYXN0IHRv
IHRoZSBsZW5ndGggb2YgdGhlIGRpc2N1c3Npb24uDQo=

