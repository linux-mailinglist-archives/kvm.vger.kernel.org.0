Return-Path: <kvm+bounces-17490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD96A8C6F72
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 396141F232FF
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E681A5F;
	Thu, 16 May 2024 00:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Io4OxFf2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4CE37C;
	Thu, 16 May 2024 00:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715818770; cv=fail; b=lA3qmELNg3QwTCOcG2es9Tdh1neKynse1j38BH9Tlj14X+/HcdKfiuamcgkepo3Ct4AMfuEQDxUuDbHXjtKzolPU8I3pH2nohqOREY+EUvcdYSRsw++1bg/vStLoyF7jO3Ao//8jTQ0lKANOeF1PXIMQE8h2k1Ns4jWiBCi4A04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715818770; c=relaxed/simple;
	bh=nOVodOaX4tiju5h0FxHXSAoOd7+sn4e+KTmqlxLB3yw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GemkEV9j8F0v5r84Q7pa0QQ9KpFEUg1GdhdS7baxT1/XE6r3MdNnaimW+nlRhC+UYcPPNsH4YX98BinF5xmeQQClsIrUdiDh9OTKAQ3pSrPPhDiI3r7w0NBBwrs476Sg3GdNM6KlpmuH6+fYPRqEu/QNB8oV+ShSgft31pPNEQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Io4OxFf2; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715818769; x=1747354769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nOVodOaX4tiju5h0FxHXSAoOd7+sn4e+KTmqlxLB3yw=;
  b=Io4OxFf23rgVjj+S+WPGNlUWOJn+V1gc1uTec0kmnslWRLVzMIDe0OaS
   gcS4EAvnU+72U41qM7kVOeibHr/O3IgtCBz6xMxmkX8LeMfrN3bm5p7Wi
   LQqU9Of8g8OGUnQwfKGgtwQDbFuU/7w/1nw5JPF+BthpiOqyV5D8Za5Jp
   MtiWoErOdx6NEx2bjgTv1vJQJ0sgpYFxrIlf63/d4da/fAdastVCHiwmu
   zOOau/WoCt8/Ak/VNtV/R/ZkTxNO2lGmGrWZxAz946Cf7qI9On3K4du4y
   mqjelikaNRBQpue9ZG4Lv6jtChsF8cBFTtCfVJn2mxVmqN2HQUwEnqNNk
   A==;
X-CSE-ConnectionGUID: NO+gO7pqQKuOf51otrHdSQ==
X-CSE-MsgGUID: rlehBuhGRZyyS0wPzvQ29Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12113937"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12113937"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:19:28 -0700
X-CSE-ConnectionGUID: fYRU8vVKQn28LdTAf1WGMQ==
X-CSE-MsgGUID: s1Xm+UvsQQS/zwnwvhBFlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="62078719"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:19:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:19:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:19:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 17:19:27 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:19:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiiaH4hQQYFNP2Y/WOE2UW8LwUmq+wr5ihBJStvdZYGoMINSl7pR6o+dyOciprQElDU3omAYVyUR3CdhYTeZPoVrjGbnuF5rd+9UWEyMMPebryh69Q4+GRiLTaFvIy/+ejki6IlFzYVxqIuCCGSTSs7wUrR6t5zu0Nm6tA1E1F9Z+DD9jywqkomFBenOpc0s/xleYB2bXpfXY6KzB+NCPRklfSXHPo+RJ6Fd5/c5f6M1661jqVIqAg4CY1BLu3bfGqVqEqhml9a17nJ9Q+x1zWZX6Q7YHAzOAReZT8zGMUYNQbNhJ2AjLALXtqG3ybOiO0VPlCPSWAwUOho6HtwKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOVodOaX4tiju5h0FxHXSAoOd7+sn4e+KTmqlxLB3yw=;
 b=ElAWJkRL7GxJZ3tPfbMS+Cq4E3lcqe82UPPCDuw/4p8lh86iOJ1B0z3hvC5WwA791LR3WM5NhFhslCbx+imd/ecDQ0Bil+b/HWLx/msuHdCJymXy+327bBh/f8aa07ajVZbqMvNuxIjhGkAoaK8mkJuNZA2UE2NxD4SMOaxI2tl6KqwwfKEFSS00OZFI9a6E/C9gJX21m4+RotcMW4FspJPYiDJeBIOZH7WVnuQgCb2NnQWw5SYV48aKBduogqxDeESa+SkTVThEv6iOsVnSSwbn5zS1Nc3hI5jhxN3TVrqglXQWOQU/ExmyxJqzSsuUVNSddF8BNavrziSKa9gYrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 00:19:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 00:19:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7AA=
Date: Thu, 16 May 2024 00:19:24 +0000
Message-ID: <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
In-Reply-To: <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8345:EE_
x-ms-office365-filtering-correlation-id: 169e962a-86ab-42fa-510a-08dc753dd78e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?aWlUQmdCT1cyNHFUR01wa0t2NkN2WTNZWTZrWVZnYTdHUnlPdnlrMDUxbDk2?=
 =?utf-8?B?a1R4S241U0o4NUFtVEFINWRISUY1RkZUd2Q5NlJGVy9LRm1XbkNadXJHN0dU?=
 =?utf-8?B?Ykw5b0Z5dGdqVVFiQUs5Vnk5dXdudFpuNDdHUEl5WkxTcGRuNFV4WGhDK05F?=
 =?utf-8?B?Q3U5Vkg1cGs5TzFpZmZ6b1ZEbFZtakUvVjRzSVhGYmZiVGFvWDFOdkxmbXAw?=
 =?utf-8?B?UnIyb1ZyQ0MwcjFBcW9zMFB2MUtydXpNQlZRdk4zM2F4eU5pY1BnU2J0bDNH?=
 =?utf-8?B?ZWlrZ2hkTnFtNmkrOGRLM0hYaEZyNHo3UjFqcHBScTg0YTVnQTJPT3FucWhL?=
 =?utf-8?B?L1dqS3dZdEx2b2d0eHFpYThSSWhibUZiam1hRlpyOUZ3N1BOZkgwdzJJUEJ6?=
 =?utf-8?B?UFQ2OFI5V1d5Yi9sNFdOb3d6SHliQ2I0Z3RLNjR0cGhjMVRYNkdsTEV2d3U2?=
 =?utf-8?B?eHltTThoNVpzWHJDNWFjNmNMMjA3ODVJMmxuVFFycW5EUVNaSitsZVl3UDRF?=
 =?utf-8?B?RjZvUUxWMStvZVJ0bkhwOGI0RXVVeE4vQ21rQk1MOW9aNzdSYXZUYmNpdk83?=
 =?utf-8?B?VUZDRzNML0pkdisyQi84dnA1aVl0eDM3QjYzN0RnZm1ZNFEvb25vMms3S3pN?=
 =?utf-8?B?dFZyS2JsSU9CUDZienRFSVRwSjh5NWN4cXVSN2c3MzdJZTdrQ055RE00Ny9H?=
 =?utf-8?B?OExxTE56Y2p4ZmxjR1BIZnFKUGs3V0JxaW1GbitVdjMzeTNYNXJib1dESlZx?=
 =?utf-8?B?VXVlWEQ5Z0FnL3F2MWwrOFE5Yk9nem9wZjZwVzB3MEdpc1RQZTdzUXZONmNp?=
 =?utf-8?B?aHFGSWlBTmZSeVZMZFdqbDNsUUtGUjl1ZWFXOG9Kbkl6c3ExSG95SktQQVpt?=
 =?utf-8?B?anFOdVg5R01Ra0pycGZmQVU1SlJtaEFTRHhaT3R0d2lVbTFRT3FWOEc5Vysx?=
 =?utf-8?B?M0Z3L2pKWlhOVk5kK0Q0ZzNBRXBtS3VNeEdOUzRPTDVpYVVPNWVBS2h0Q1Bp?=
 =?utf-8?B?WWYxTm5EUDRuTGhneHVsRmh1ZXFJSVh1dmZQMy9CZ2F6THJ4Q09pbVZIcnVK?=
 =?utf-8?B?QVpHUG9SNGQrUDBOd0xOY25GS3c4anRuazRGQ3VXcHhTOENNdzlYa3A0N1Ix?=
 =?utf-8?B?SUlHbTNzaTYwMm5NK3JUOWptY0RhWkFBOHdVZVRTZXgzbUM3MStBTnE0RENw?=
 =?utf-8?B?TFlMMU8rQ21qUm95TTNwRlVRNjk1amRHVWtXQUVya3V4dVN6ZHpCVjNxak5W?=
 =?utf-8?B?cXBCVUsyT1RjVlpiMm91eHlNazJWTjdtUW8rV1doc1NkdENTT0xLUW10YUxH?=
 =?utf-8?B?SW1MczJaVXB5V091SXJZSXpldXVvUXRHRmM2OFZ0QTVUYW4rWkUwSzZla24r?=
 =?utf-8?B?aEFLR0x4aFhUTXN2ZWJKM2RPY1lzUlQrM3U2RkhwdnV5S0FxbjZaM2FleW5y?=
 =?utf-8?B?YWt5YWF0SWVLRzNOOTc2MEs2VlVpcEJNeFFXWjM3WFpVdmZtRjhDZGo5RkdG?=
 =?utf-8?B?TjVFOGhhVG5oZStlc0pIVS9kSU5kVXkwSXZoU3hidUtKSnNkQXBUUDhUcHRm?=
 =?utf-8?B?UTNTbEV3Q3dNd1F3VkdMUDFiekJaMzQveGdaQWd5eGMyNUtLZzMwVEsyeXNu?=
 =?utf-8?B?dHFuSTZyTWZUbC93VElMS0ZqUzBtdGhmSDJSdS9JSnp3Q04yZ0FOWDNFQ2RY?=
 =?utf-8?B?NlpWbG5CUEEzTTBSb0NhNzVSVnp5L2YzWmo3VTZHcXh5VEhuaGNpSmJxVnNO?=
 =?utf-8?B?V0dwcmpDcFMvZndqTW1tSEplT2pWdzU5VTFuRGJnQU51UGRiU3BBRmNWc1FQ?=
 =?utf-8?B?dVNISUpJdTJHMTlIN1BZQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEpaeXl1VGlVaXFhYkQ2bCtRUGdVMjUraDVTdFg0RDlmRFRzT3NMWnUxZ2w2?=
 =?utf-8?B?S3l3aFNsek9iWkZocGE3aGNTeURaTkZuVG5xeW40Q0ZNZU43b0FQaTFIMnNJ?=
 =?utf-8?B?MkV6dUowekVFU2JTN0RyckRDaEZpYlg1bmVzb1paQzdkTzN3V1FOT2JxWTh1?=
 =?utf-8?B?SWZDbnpLaEtlb1h5R0dNZ0l4cWJDWlRXYVc3OGJSZ3AzVFNwRlRrTHl1U2xr?=
 =?utf-8?B?YmxxbG41R3V3TWxPYzRMQ2NwanNSaWhyZ3lzUFlndWhVREJlRkF0RTV5eEda?=
 =?utf-8?B?aXZ1Z3ZrUWdzNXJhZ3I5eDRlZTFUbVp4bTRRVzErbE95akxhNFYwL1JPVjc3?=
 =?utf-8?B?L2RUQ3dROVdsRWZzY1hqSFlycC9MUXJNZUl2dmMreHNRYm44QlcyY21TVEVy?=
 =?utf-8?B?c0RoRlg4eFJseTExNHFOTlI0YTF2UmQ1dnk1K003VUR4RUxQUHZNRHZmSW50?=
 =?utf-8?B?alZ1UDV1bFdWcjlyYnlIRDRIaXdycHRrdmNLaXZjUTZDU01pN0Z6akY4Z01W?=
 =?utf-8?B?UUZrVzV3Zkh3RldtdWhpVEQ0cTVpdzMvWDFIQkRMeWJYNjBUdmFTTXhOVlZO?=
 =?utf-8?B?N2pUSCtOVnNSQ2FkZStUVldOeGZMR3BXSU0rT25CMVhtTEtVUGc0NE8xWnNN?=
 =?utf-8?B?LzBtd0tpZUlhYzhrUkdORkEwSCtPMzJJVjFsRWVzekpQa0xoQmRLTEt6aDAr?=
 =?utf-8?B?ZS95cUR5ck5wb2RHV1gveWZOMlVwSDFDL0oybTlWN2FscGIwZkNpQnM5aGZY?=
 =?utf-8?B?TmNqL0FRMHk5L3d3bzRBTklXSzFubytxWldGWXR0MFNoRi9SSCtzeHpWRlBY?=
 =?utf-8?B?bHRyVGtyK1pkVUNPQUlSOVJRMGVsU3RIekh1SWhpYlZ3OFdMWTBWZjQ1SHF6?=
 =?utf-8?B?NWpJblJpSkZaUzYyNmVQUnBrM09ESXI5WVNJdk10S0lZck9wWXVKeGs1TlMz?=
 =?utf-8?B?YmVidkN5T1BRMWc1UVNsQTNFd3g1UUNPMVRFdmUyZFFpa3lOZjYzM1ZmK2hw?=
 =?utf-8?B?N25UU3M5eDUrL3RROUVjRGhtRnhJRFJ2dW1oMndpZ3VPbVlzSm51WHBtV3NB?=
 =?utf-8?B?L1hkZWNGQldCdlhvMmk4MjhGTkdPc1dPSXI1U1hjY0dIOEl0eU1DaGtUZlp0?=
 =?utf-8?B?Y2pUeE82cWY5cDdGMUFvS0NHNUpDaXJKd0xiZVF6azZQVGJuRjRIZFhETlpU?=
 =?utf-8?B?b0krcTJzMkZtbUZPeEh3ekZSWFZMV05Ea1M5Tm5uNENURHM2dzhFWDVTSjBx?=
 =?utf-8?B?SnhDT1pFdXlLNy96dDc0RTRKanFFUEsvWkdXSHdvMW8raXRPalJ3ZnJmSjJE?=
 =?utf-8?B?VUFoc3NHVVVRT1lHRWNyYnd1ZTFLZXdBUE5QZW5pWVdzVm9nZ3F3NHVQdllD?=
 =?utf-8?B?SEJyM2g5SUNhUGpGdTJML3VMMXhMRHI0YjR3QU1BU1h6S1d2aWJiZUE3aGlp?=
 =?utf-8?B?VHhtbFFBaGFKeTNabXBMQ0hkNTFpamxuano4VVlHczR1dTJvYVhtUXlFMGx3?=
 =?utf-8?B?VnNhNDlOMDE1SHUzNy94TTNKczJyZVhVcFFmZ0w4LzFoNEVMcVZFZ2EwekZL?=
 =?utf-8?B?a2RSUUMrbG1ZRG96L2pnZVliOGM4TVYrRG9OcFRIcWdlYU1HNXVaa3lkd2Nq?=
 =?utf-8?B?U0swMHdreE9sZFpaWEZSVkxBMzVrbHV1WWcrSU9Ic2ZjazVMUHk1RC9lRXVZ?=
 =?utf-8?B?Tzk0d2hHclBaYm9Bcm4yaHRLdnc5TXEyOEljcWk5aXJ6OGQ3a0IrWGx2Vitl?=
 =?utf-8?B?d2hRT1JGemNsZ0tqeVNLbkNNbmZ5bE5QSGhsd2Zldi9KTmt1T3dGYWd6aVFj?=
 =?utf-8?B?UkxlWmd0OWIySU5FczlZaFJmbXVkcU9UUUdUUENwU2lmVjBiRjFOcWJGYXhU?=
 =?utf-8?B?dTRGcU11WjIxYjZ4T09LaTJUUVRnREZoaDhVQ2szYnhvWVBtKzBRTWVYeUJP?=
 =?utf-8?B?cVJVczZZc1o5ZnlmbzJPZjVUdjc1RWIrc0g4YWM0VGYwcE5jeFlWSHdGYTM2?=
 =?utf-8?B?RGRYc3E5WmxsR215Vm1oTG5PdDNTU0FLWnpBVzl2MndySzZabllHVktBSVk2?=
 =?utf-8?B?RWZHK245aVVvVk9KOG1ybUUvd052d1c2OWlFN2xzSlNKSGVLMXVsQUJXdE1O?=
 =?utf-8?B?Nk1WNGVrV2RtQkZ3dlp4SVdYQ1pPbGMxRjhwelRhbXBhdjBDZ29GWVpHaS9N?=
 =?utf-8?Q?ZfP0odoETNscpZj5j2bbsvA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DCE89668940DD4C8B3C8E930E8B42BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169e962a-86ab-42fa-510a-08dc753dd78e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 00:19:24.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5rfGU1iN6cN55MZmPtx31ST/pvaAWofgHKUoQvMJ2ieQE7U5dx33hFClAZv1Ah45dSnh65uM6pN4MuBVEj6i8rjJZ01c4TKWztQp+FmYupY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEyOjEyICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gSSBkb24ndCBoYXZlIHN0cm9uZyBvYmplY3Rpb24gaWYgdGhlIHVzZSBvZiBrdm1fZ2ZuX3No
YXJlZF9tYXNrKCkgaXMgDQo+IGNvbnRhaW5lZCBpbiBzbWFsbGVyIGFyZWFzIHRoYXQgdHJ1bHkg
bmVlZCBpdC7CoCBMZXQncyBkaXNjdXNzIGluIA0KPiByZWxldmFudCBwYXRjaChlcykuDQo+IA0K
PiBIb3dldmVyIEkgZG8gdGhpbmsgdGhlIGhlbHBlcnMgbGlrZSBiZWxvdyBtYWtlcyBubyBzZW5z
ZSAoZm9yIFNFVi1TTlApOg0KPiANCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBrdm1faXNfcHJpdmF0
ZV9ncGEoY29uc3Qgc3RydWN0IGt2bSAqa3ZtLCBncGFfdCBncGEpDQo+ICt7DQo+ICvCoMKgwqDC
oMKgwqDCoGdmbl90IG1hc2sgPSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSk7DQo+ICsNCj4gK8Kg
wqDCoMKgwqDCoMKgcmV0dXJuIG1hc2sgJiYgIShncGFfdG9fZ2ZuKGdwYSkgJiBtYXNrKTsNCj4g
K30NCg0KWW91IG1lYW4gdGhlIG5hbWU/IFNOUCBkb2Vzbid0IGhhdmUgYSBjb25jZXB0IG9mICJw
cml2YXRlIEdQQSIgSUlVQy4gVGhlIEMgYml0DQppcyBtb3JlIGxpa2UgYW4gcGVybWlzc2lvbiBi
aXQuIFNvIFNOUCBkb2Vzbid0IGhhdmUgcHJpdmF0ZSBHUEFzLCBhbmQgdGhlDQpmdW5jdGlvbiB3
b3VsZCBhbHdheXMgcmV0dXJuIGZhbHNlIGZvciBTTlAuIFNvIEknbSBub3Qgc3VyZSBpdCdzIHRv
byBob3JyaWJsZS4NCg0KSWYgaXQncyB0aGUgbmFtZSwgY2FuIHlvdSBzdWdnZXN0IHNvbWV0aGlu
Zz8NCg==

