Return-Path: <kvm+bounces-63439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD45C66C54
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D301234F9FE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0182FD1B9;
	Tue, 18 Nov 2025 00:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="izAvODFh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4A92F549E;
	Tue, 18 Nov 2025 00:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427426; cv=fail; b=FbNx5fcNoPyPwsdbKjpZhrPtSDdVqBo0xxFLfxVfE5i4iQN2ARoKjdSa1M1mORvTDBrslCtNidm7GPsQ/s2BfXiWAiE9WohcSrqrCdfmO99q8Y2XMNYMaaOCBEqV6Pfia+zWbszjT9rNcPTWtVTI5P9/KpGSyC4TbMgFdde739U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427426; c=relaxed/simple;
	bh=XO8GtE8aaiun81k6ceEx2F+yu/uxW2yiGJR5JnXs4D4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WdGrSW5qq5wosFLf8omn6uXva+ocsDn+wKL2JZja1N1FiYPpw00R3svhRMVXLBwsXuc6+Cun+2FxtOdpRyDWOm8OQ0G8B3Esd++bmUw5D511DW84ZCGFtetwPnqTC/AYw6lVnrkxc0dJL6txcVFmq4MY+lHJjI7+ZuyBtmVp7to=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=izAvODFh; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763427425; x=1794963425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XO8GtE8aaiun81k6ceEx2F+yu/uxW2yiGJR5JnXs4D4=;
  b=izAvODFh0JFgSe4sjkubtTkCERTTrAHM2n19zsIn1fkp4g6Nl3a49CIp
   39ziX9q9s0BC8tsagWioP7RAJG26vO0kygukbBl4l3N9I/0HEpB53G9+i
   BCeHPqTIiwP24GZgHT7yWO/lm4gI4AymjT/7hP8tlXh/9mpyk3Xi0TBxU
   QvmZ6+6o+4kmiKVmVQbrDmWGszTIeRBEo9reii021ePHR5sh04JT5atqY
   /zcuM0IdPcULg2ZnfX7H8BNUk6vfUAwKmZ8slBOIwsqFdA3R3Jg621HAu
   AOqp8hS0D9ZnOLjYc3ZcXhX3tCk8jKqwYbjn9jbCyCQYLW3OVOdamjHhe
   Q==;
X-CSE-ConnectionGUID: KEh1rXLoTtGJbGpYxeW5eA==
X-CSE-MsgGUID: hKPauGPXQN6cce5bVajFCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="90914544"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="90914544"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:57:04 -0800
X-CSE-ConnectionGUID: 8Ow4kWg9RS6BILWkRFLN/A==
X-CSE-MsgGUID: gNwq5rZPRl6c6jcHKy/+zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="194712834"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:57:04 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:57:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 16:57:02 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:57:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZG6eWjY+sY2Hj/1VpFZTCTgupiNfDB3k8jBjUfdrPnz+c0xRzmtaW6eR+HgCkvF8UtcS3cwU1Px15ZepBgx5DWw89GSmMfkiTbTOjpLm8vxU7u2Q/RHbhgZmGL9IyaCozTS5FzFz5KEI71j8Stl2WEUgs/wCaCRQGbWrTO33nCAjI1k6Tik+CVUxZo1xaHIblXwEh1SJt0NMvUypkBQjuTVdEKY1hhiGOfAHMtVnQTioe/CYsMswD7Fb7+YMXD8txMOXbdq7Zx5C0YllmFD2+r7+k1qDXM/l2uaMoBV/lLa3B0fSYScf2ISJW8Qc6kP8DnNOcgeC9fI/p0Tfcud3SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XO8GtE8aaiun81k6ceEx2F+yu/uxW2yiGJR5JnXs4D4=;
 b=rvg/unD/zEH/L14iugZUnhZGU8YWJp/Y65iH3uktAme0jTM/bYtRFRUn6o2RbeX+hUm3uQMcQvAqIu3YrSe8fYZxN1SuJCD4NGPmLDaZkSTSIYeV1dz1bYoL8abBKEEG7GSRx1Pa9pKzny1l8Ub2qmvAqb8ibEbKTrOWp3dUlRmtyNlDBbO6fh4mOzgGvL1xRNh9vIaujetmtNMhjCRBKNYLUifGIpCwDbwhZMRbaB2ZmzqqTUjyD/EFwepTGCrQhjXons6enXzurNwejdp5H6KhOFX3/4KN/3rV6m90q441xwTMwBg1+41C+cq69DE1QIjHEE2DGhkG5wVydBCY/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 00:56:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 00:56:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is
 RUNNABLE
Thread-Index: AQHcB4B6levBPmVcPUWayckSVIaIxrTt7JcAgASHbACABclrAA==
Date: Tue, 18 Nov 2025 00:56:50 +0000
Message-ID: <8e2f8e880269724d5f39933f8566140e9c4555c5.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094628.4790-1-yan.y.zhao@intel.com>
	 <05bc67e2f6d7ec69d5428dadd1e175abcb9d0633.camel@intel.com>
	 <aRbpnPdgh1h4SDAu@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRbpnPdgh1h4SDAu@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW5PR11MB5811:EE_
x-ms-office365-filtering-correlation-id: d2060991-1b2a-4873-be48-08de263d5be0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cnZ3ZjlwTm03SU42bmxQV0Q2Ykl5UmYwVXlRcVJWbW1sL3lTaGprYUpUUUI0?=
 =?utf-8?B?NGZkanBzSW1xUWxnbzR0Z2dSRGNNQzd0RjNzWS9UT2hINzZWaUZFaTB5bGp2?=
 =?utf-8?B?WlU0Qno0TmhtT1RPZWc5d0J5Ylk2ZXVyY3N4UnFoaENMNkZYOHBRZHJxcFZx?=
 =?utf-8?B?cjJyNWMzejVtbE5vazU0OWdadERWMUQzaHFQWnBhM3gycjFnZTNRUlJhdVJR?=
 =?utf-8?B?TzJXUGc0TTM1R0laak5sb3J2VGtmR0lobVh3OGlhRDBMYkRVRktOZ2NpWjFJ?=
 =?utf-8?B?c1JVbWRJeUltbEg5cWg1UXY5d1R1OHZsa3BOVUpaN0NCc09EUTNjd2xKSzNl?=
 =?utf-8?B?M1p0WHV1L0VBTGlNNkFvN2MySkY5SEkxWCtPclFmbnJVa081K002MmhuM3I0?=
 =?utf-8?B?WXpWamtwSUtGRVJTNDNYK1ZxeFZnVWJxbUJEdkNDN0lUL0xJekI3dTg5Smpk?=
 =?utf-8?B?dUtsb05SbVJPZThkbVl1Vmd0TW5LTEZYeTk1dWVIaFJTU3UwNGtPd01OWHV1?=
 =?utf-8?B?UGhZVFhkWUxuVm1WeE5pRWdiQisxcTFYV1preSsvUnV0bitzL3NMcy9PbU1O?=
 =?utf-8?B?TVhCSEVIY09YYlEzbFBJUE9mL0M2bmNVQkhCV1Yydm9YQ3F6SWVoby9ITGgw?=
 =?utf-8?B?SUNtZjkvUWcrV3NtRHVvZmxlRWV4YzJDa3VaOVdsWTZ6VXRXSy81cXhyVTYx?=
 =?utf-8?B?Z3J2M3ZCOWRSSW1sLzdjaFdDcDB1c2M3Tk9kMWZtQTBTd3VwYUtkS3dabU4r?=
 =?utf-8?B?UU8xMUp3Y1JvSVdPYmJVYkhhdWJvZ3VCWUtzdFVXaFFGRjFjMGp1cEhJRHl0?=
 =?utf-8?B?cGRRd2lvVHMrRFRxYXljQStBME5nemgrOVp2MjlobmhWWVBrVVdHUFFpcUNx?=
 =?utf-8?B?WlNQa2N2MXNNY0JuQXJOQnFoODdXSUg2WDhLYzdEQktGNXhDeTNqWEpYS1BU?=
 =?utf-8?B?K1hqem9xVmN0dG9YQkZnMmoxcExQSUxiSTQ0L0tONkhXdUdodDJLOEVHVGU2?=
 =?utf-8?B?a01nUURZelQzeFJyaTJPL3JReUlOL0NMdFZEcTFNODBKTTV0MGp2Y0l6VnhJ?=
 =?utf-8?B?cHRYMzM4cHI0OXlXSHkxTjVxazhrL1RvQnBkVHgrQnZGSHF4czBEVWwzc1dj?=
 =?utf-8?B?akpHRzF5ckN5blNnZVpJSDczRUhyWk53bExtL2x4Tk5weXg2Nk8xYzVzVWRC?=
 =?utf-8?B?ZWV2Vk5FQWRyRXptRnVyb1NUNHJyRUczT3VTRFRNTUYxckoyU084OW9abzR1?=
 =?utf-8?B?RUppREFTZmZwYmJWNS9pTDlaNGxxbE5RNzZqc1FyTG9vVDd5TkxHekNicEJN?=
 =?utf-8?B?QzFyTlRhMUJNdm9PVmJ2NUQ2b0ZzVGQ1NzlscnpRSjBMdDdNeUhBZTlRVTVu?=
 =?utf-8?B?clNONVk3eVdmUE5wMWNUend2eXdmclM5R0FjVTNRVWxjcTA0YWdwVG1MNDRu?=
 =?utf-8?B?OURoTWlhck14aTFuYjRYaDNpc0hWZXU3aHpzUzh2ZUxldis0WUhMcjBsaThr?=
 =?utf-8?B?Q1o4ZHI0K0FKTjBYbDc5U2YzRURCdDhGYXhRMWsvQlQxS3o1WUdKbGNDTHNV?=
 =?utf-8?B?L1lhWGZyYXp6T3VWTlJUZGRxcTcxNUM0UUhnRXVMak9LZ3NyWkZTSjVxczFL?=
 =?utf-8?B?UzRDOWdabm9uY0FiY0d2SHV5YTBBazJzMUVuZ3duY2pyVGYvclg5RTRTc1Q0?=
 =?utf-8?B?aCs1ekRPYUNBaG9EOGtxMXpHMHUrdnd4MUE2K1Vlc3VnNjNaZDdWcTVETTE3?=
 =?utf-8?B?ajBYMEJQQjJqWDBOa3JWSHV4UDViNkhLZkFBTm9Vbm4wNE5nTnF5MElzV2xn?=
 =?utf-8?B?NHAxOHJ0ZHBjaWtzRHlDYVoxMGQ5WEtBa3kwU1J2emhoMWE0N0lLeGM1bU9m?=
 =?utf-8?B?dVFJUy9xbWdoNlF1V0s3OWlMUkdHTW8zdGptVk9xUTRvTHpHc3NCZXcyaXo3?=
 =?utf-8?B?LzliRmhvclIreTF3T0JXdTdRcWZ3RVBJZGhtRGZXUDRhYWtmTi84a1I1NSs2?=
 =?utf-8?B?L2JuZElDeFl4SHg0dWxKMmxtQ0p3MVVRdHVBUnRId1piL2dzSFNmMXIrcnkw?=
 =?utf-8?B?cUNaSHJRTWJMU3poWmRVTE4zWU5haTZuSVBlQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVRrRFA5L0MyTmR5aFFmd29UeTNBZlBxekdhb2c2UUhQVCs0R3J3NlE2cVdP?=
 =?utf-8?B?c0M4eTRqYUVNRXBOdGYveHB2RmpXRTd0RlpFN0lHL2lzbUswa2M0VXhIVHpt?=
 =?utf-8?B?L3h3Y0FKQ1kvaWZXcmp2Qi9XdzVaRk5ma0c0aXZ4MHpyVk9sMnJjc0dsdHlv?=
 =?utf-8?B?N01la2ZjOGFqTkNxNkp4RmhJTzF5ZDVPUlBWaXkzT1dzSktpMUxpSy90VzVx?=
 =?utf-8?B?SjRKaVl5UUhtTlVHclhFSXRlNGV0QUs2NlIxRGx4RzFJYiswSHoxWjdBN21M?=
 =?utf-8?B?VzRxUlV3SCtpNFJJUGhsT3o1NyswV2Rsb1pCSjZWbnR0MnMzRVg4T0s2YUNn?=
 =?utf-8?B?R05TRXB5aTFmeE5LV2lKQXRHNEx4ZGxCbkcxZk9xRXR4a0hCemZHbVJqdDB6?=
 =?utf-8?B?dkJFYldsL2lwT0txV0FHYVBrcDgrTDdXNUdWSjBHa05sQnB6b2QxUkdna0Rx?=
 =?utf-8?B?WGp6M3FLYTB4RW5GZkFndUdmY25manFWMXB0a3pnSnV4V2lsc1dZZVZsK1Q2?=
 =?utf-8?B?b245dHBUYTg2UDIyaG1jRS9FY3kzZmR1U0ZRc2o2VjBwakVvY2YzOFM0SEVh?=
 =?utf-8?B?eWpDTlh0SmJnV0FsVVJPUHdHeEFrcm40WWxTZFVRNzJGejB3L1g0WjUvd0Z4?=
 =?utf-8?B?eXpRTDJqZUNrUVFrNmZ0VWEyVkVVMjdjN29jNTd5Sml6OUt5NU9TZkxiRWZi?=
 =?utf-8?B?U0R4LzVNV2tsY3BnQ2M2YWl4WDdmdy91cVdpWEcxL2RJak5nVGxQTGkxRHlB?=
 =?utf-8?B?ZzJ3TUhkNDltTlludjFya1ZMWStPTHQyRGcvSFM5QmxXSnR0VWh4YjJ4NG16?=
 =?utf-8?B?c3RpMHhWajlPVDFYLzVxcUNQWnNYaE5Xa2pUUUZqVmZFRlg1a3JIc0cwMlhD?=
 =?utf-8?B?MWZUMUIvb2JsMzJYYzVXYkV3NzFKRWM4WWdWOEZud09MK05HTUhleEFTaHJM?=
 =?utf-8?B?UnNXQkpyWG5WTmlYSXAySGJQSDFQQXVmUVhVZkVBU1JsYUR0RTk3SlNoV2Y0?=
 =?utf-8?B?OENJaHF5QzZPK3JOM0EzQ1g4NkJmZmhrWk5KZ1hUY2JyeXlGNHd1ZVIxRUVD?=
 =?utf-8?B?RHdIR3JyM0piUVFHN0l3cTBaZDliWFRpWjVVTzVTZmFiVWhIRTBXR2lBVjUy?=
 =?utf-8?B?dWhwZm9selQ2K2pmd0tjbDhmdXJqVEVNYWFDODN1ajVOOUNqVFh6MzEya1lR?=
 =?utf-8?B?K29LRFR6c3NzQTMzSE1rb291WTRqQllrWVo2dy9TUEV2Sm1jZGVxQ1FOTi9t?=
 =?utf-8?B?UDdOaVBLMFhMQmI5ZjAxVFZZNUloTm1ucDB1d3NVdGxvR0FZUjMrZmZuNng2?=
 =?utf-8?B?bUR2QjFXWENxTVMrNndBb0VCUlZDR3laZzRldlR6VlJjU0Fwd08yWHdFVHRy?=
 =?utf-8?B?MWozOUdnVmNvbUxzYmhseGlSTkpKSk5mbXZUZm92NTFLYWowRTZ4ZVJWcFIw?=
 =?utf-8?B?K1lsNzBybDBabkw0cU1xL0ZpdTI1NGJ3cXhwT3pSNmNqeHN5MDNCOE5nWENK?=
 =?utf-8?B?N1VBamV5YXdpOVBWVW9Tb0ZZZ0Fqa1BUODVLRXlnNUtxbERPL2FKYTB1NE8w?=
 =?utf-8?B?Y1g0WkFDUlRoRzhNeWNxQnBUMmxnR0d0RWlYRE5TeWdEMGJXWUx2RDQ2Nldm?=
 =?utf-8?B?MkZmbVpUMVhqRkpoRkJXL2hUOFI5SHMzKzdXU3puckdUS0VjbFdMdE5OQTZX?=
 =?utf-8?B?bkFJWXR5cENpWS95ZEs0OVhnVlZLbTNWczRWR2NxaG94MmVCeERoNndOLzZQ?=
 =?utf-8?B?MDZSZjBZSmwyc2Y2Q0t2QUJxNnJ4ZWFpc1VVS0ZLc0NjMjMxTXhnNjRPZVk0?=
 =?utf-8?B?cVIxZTFTRVlncFh3RUsrbHRlVEhJTGhOSS82L1UxMG5PUVV1RGxzek5JMGxI?=
 =?utf-8?B?RUVHTmZBZ1NMQitIYUVHTEpma0hyRzJOd25neWZWUFNZeERNVmV0MHpVWlBt?=
 =?utf-8?B?R0owRzdPQ2ZsTmVYa216YjIzckhiYmlqckc3cFYzY3BQWUR1dFlOTGtmNml4?=
 =?utf-8?B?aFE4NmpCc0c2aTNhYm9GbzhVY0dQdFRqdm1QbXVKSnpCKzR0UjY1WmRjdDZ3?=
 =?utf-8?B?SVlNS2NnZEJNb2NNY242R2N5b29RSWxGSTNva0oyaUFobFdabUxQbHdhcXkr?=
 =?utf-8?Q?wa/zkBCxv1tLRyQqlWRQYQ0n0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF3C2ED5D483B8458B4E6DAB38308D14@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2060991-1b2a-4873-be48-08de263d5be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 00:56:50.9025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0nD1JNPQsK1BnC2n6qGCAysP74Kr7pNEeU4ODknCkmkdyzrRadCtgvxTWNTDabkpscMQ33hZgAyOJwO8Sqc3vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5811
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTE0IGF0IDE2OjM0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMTEsIDIwMjUgYXQgMDc6MjU6MzBQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjUtMDgtMDcgYXQgMTc6NDYgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gKwkvKiBMYXJnZSBwYWdlIGlzIG5vdCBzdXBwb3J0ZWQgYmVmb3JlIFREIHJ1bm5hYmxl
LCovDQo+ID4gPiArCWlmIChLVk1fQlVHX09OKGt2bV90ZHgtPnN0YXRlICE9IFREX1NUQVRFX1JV
Tk5BQkxFICYmIGxldmVsICE9IFBHX0xFVkVMXzRLLCBrdm0pKQ0KPiA+ID4gwqAJCXJldHVybiAt
RUlOVkFMOw0KPiA+IA0KPiA+IE5vdCBhIHBhcnRpY3VsYXIgY29tbWVudCB0byB0aGlzIHBhdGNo
LCBidXQgY291bGQgeW91IGVsYWJvcmF0ZSBhIGxpdHRsZSBiaXQNCj4gPiB3aHkgUFJPTU9URSBp
c24ndCBzdXBwb3J0ZWQgaW4gdGhpcyBzZXJpZXM/ICBUaGlzIGRvZXNuJ3Qgc2VlbSB0byBiZQ0K
PiA+IG1lbnRpb25lZCBhbnl3aGVyZSBpbiB0aGlzIHNlcmllcyAobm90IGluIHRoZSBjb3Zlcmxl
dHRlciBlaXRoZXIpLg0KPiBJIG1lbnRpb25lZCBpdCBicmllZmx5IGluIHRoZSBjb3ZlcmxldHRl
cjoNCj4gDQo+IDYuIFBhZ2UgbWVyZ2luZyAocGFnZSBwcm9tb3Rpb24pDQo+ICAgIFByb21vdGlv
biBpcyBkaXNhbGxvd2VkIChpbiBwYXRjaCA3KSwgYmVjYXVzZQ0KPiAgICAtIFRoZSBjdXJyZW50
IFREWCBtb2R1bGUgcmVxdWlyZXMgYWxsIDRLQiBsZWFmcyB0byBiZSBlaXRoZXIgYWxsIFBFTkRJ
TkcNCj4gICAgICBvciBhbGwgQUNDRVBURUQgYmVmb3JlIGEgc3VjY2Vzc2Z1bCBwcm9tb3Rpb24g
dG8gMk1CLiBUaGlzIHJlcXVpcmVtZW50DQo+ICAgICAgcHJldmVudHMgc3VjY2Vzc2Z1bCBwYWdl
IG1lcmdpbmcgYWZ0ZXIgcGFydGlhbGx5IGNvbnZlcnRpbmcgYSAyTUINCj4gICAgICByYW5nZSBm
cm9tIHByaXZhdGUgdG8gc2hhcmVkIGFuZCB0aGVuIGJhY2sgdG8gcHJpdmF0ZSwgd2hpY2ggaXMg
dGhlDQo+ICAgICAgcHJpbWFyeSBzY2VuYXJpbyBuZWNlc3NpdGF0aW5nIHBhZ2UgcHJvbW90aW9u
Lg0KPiAgICAtIHRkaF9tZW1fcGFnZV9wcm9tb3RlKCkgZGVwZW5kcyBvbiB0ZGhfbWVtX3Jhbmdl
X2Jsb2NrKCkgaW4gdGhlIGN1cnJlbnQNCj4gICAgICBURFggbW9kdWxlLiBDb25zZXF1ZW50bHks
IGhhbmRsaW5nIEJVU1kgZXJyb3JzIGlzIGNvbXBsZXgsIGFzIHBhZ2UNCj4gICAgICBtZXJnaW5n
IHR5cGljYWxseSBvY2N1cnMgaW4gdGhlIGZhdWx0IHBhdGggdW5kZXIgYSBzaGFyZWQgbW11X2xv
Y2suDQo+IA0KPiANCj4gdjEgZXhwbGFpbnMgaXQgaW4gbW9yZSBkZXRhaWxzIChTZWUgc2VjdGlv
biAiUGFnZSBtZXJnaW5nIChwYWdlIHByb21vdGlvbikiIGluDQo+IFsqXSkuDQo+IA0KPiBbKl0g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwNDI0MDMwMDMzLjMyNjM1LTEteWFuLnku
emhhb0BpbnRlbC5jb20vDQo+IA0KPiA+IEUuZy4sIHRoZW9yZXRpY2FsbHksIEkgdGhpbmsgd2Ug
Y2FuIGhhdmUgYSB3YXkgdG8gUFJPTU9URSBtYXBwaW5ncyBmb3INCj4gPiBpbml0aWFsIG1lbW9y
eSBwYWdlcyAodmlhIFRESC5NRU0uUEFHRS5BREQpLCBlLmcuLCByaWdodCBiZWZvcmUgdGhlIFRE
IGlzDQo+ID4gYmVjb21pbmcgcnVubmFibGU/DQo+IFJpZ2h0LiBLaXJpbGwgYWxzbyBhc2tlZCBp
dCBpbiBpbiB2MSBbMV0uDQo+IA0KPiBUaG91Z2ggd2UgaGF2ZSBubyBuZWVkIHRvIHdvcnJ5IGFi
b3V0IHRoZSBucl9wcmVtYXBwZWQgY2FsY3VsYXRpb24gYWZ0ZXIgU2VhbidzDQo+IGNsZWFudXAg
c2VyaWVzLCBJIHRoaW5rIHRoZXJlJ3Mgbm8gbmVlZCB0byBjb21wbGljYXRlIHRoZSBkZXNpZ24g
Zm9yIHRoZSBpbml0aWFsDQo+IHN1cHBvcnQsIGR1ZSB0byB0aGUgbGltaXRlZCB0aGUgYW1vdW50
IG9mIGluaXRpYWwgbWVtb3J5IHBhZ2VzLg0KPiANCj4gSW4gbXkgZW52aXJvbm1lbnQsIGZvciBh
IFREIHdpdGggOEdCIG1lbW9yeSwgdGhlcmUgYXJlIDEwODYgY291bnQgb2YgMk1CIG1hcHBpbmcN
Cj4gYXQgcnVudGltZSwgYnV0IHRoZSBpbml0aWFsIG1lbW9yeSBpcyBtZXJlbHkgMTA0OSA0S0Ig
cGFnZXMgaW4gdG90YWwuDQo+IFNvLCB0aGUgZ2FpbiBpcyBsZXNzIHRoYW4gMi8xMDAwLg0KPiAN
Cj4gV2lsbCBjYWxsIGl0IG91dCBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KPiANCj4gWzFdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hQW4zU1NvY3cwWHZhUnllQHl6aGFvNTYtZGVzay5zaC5p
bnRlbC5jb20vDQoNCkFncmVlZC4gIFRoYW5rcy4NCg==

