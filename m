Return-Path: <kvm+bounces-17709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3D98C8D5E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 22:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0001C22A16
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 20:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BB71411CE;
	Fri, 17 May 2024 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0Z+b/f5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECAF14036E;
	Fri, 17 May 2024 20:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715978492; cv=fail; b=A6f5QMsQc+i+7g0plEU0MXA4boVLEyrTxvr2KTndW94etGI4sSh5iZ8O1ImJ4+A4dPB4YMRkAbYeAOWxpaGCF3390biMVz/TQ39HZqSflAYppzTnz0KiOmU3zJs4eUZOXF7ikPBMv+O4LSwxH0zibLwnP0GgO5SUErKbAup6UOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715978492; c=relaxed/simple;
	bh=/xBNORdpWoZEYPUYTWIuFktEqN1+8q/2pq+Pu+B25ic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PUfTSsgRcVHcTah0+L9+wU/Er0wAgSsgb1lgVA0Ho8/SEJYKR2NH9id0+J8PUWpT8zpl843QExpNE7/KqpPxDqOZilLsk3/oC+lwMKfKBtEpe2O5WOa1WM7abAw21zudcD+ZTD0/ILHZ3Wa7RKUKMSMA/maNK//YwiAzxJfWPGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0Z+b/f5; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715978490; x=1747514490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/xBNORdpWoZEYPUYTWIuFktEqN1+8q/2pq+Pu+B25ic=;
  b=a0Z+b/f5GnUHvSUy6fgmXpN16JMUJZz1SS6d54p4F/3sEVLayYPolR5z
   0WDiQfDt9LQeFUrQObEseoeQjl+J1Tkn7qoCHa3/iPvY8meL8IA9ghuIy
   3DfdSfDVZ4y4G+hmaACkJ9a18JzfBgmJQJP+cLdkq4JNDMib05fCkHCg4
   U6IhF+CMUCDqS/mMlmpAzJxm/4iYq9qwXs1djDTn3EJhmFMiBNjEMl3y6
   Oyvr0zSVz1QtW5pFt2B3NB7DOCpNDrK4ZrTLra4nFxjaVzop/mP2a4FWp
   EnAcde6zFqkxZ8XOgzpRzG94XGipFHdgb8Sf6M0pOK/+ClVxFtdTV84ZP
   g==;
X-CSE-ConnectionGUID: oz6A+m2gQsCktDmB2lefGg==
X-CSE-MsgGUID: Uyad46qcRhCdJpHc4ds51w==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12365888"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12365888"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 13:41:30 -0700
X-CSE-ConnectionGUID: lQ1TCWZsQEKOMQkbRDZZIg==
X-CSE-MsgGUID: nNayvjNgQkeIHL9YtshY1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="36811670"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 13:41:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 13:41:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 13:41:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 13:41:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 13:41:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm2R2eGg5usiLyycxTEp+k+gvhfPLujC/4RcQpbXZsa1uox3iG7pH19AmSCOHxBnRlxKTAqEdqQ3AI0od0P9Nlw0g28ieJcE+relVnKiGj/3lDRxLYF1TwcojOo5hBCjDiYVl3SyrbQMvRSNPIm4hZiyqErf3V8gdsnydfNu7ioOoCjgBblIHQUodPeiKYLFuOI+H5TXxZjq+z7USRG6ExJdpS2Cnq/FhRaC0ySlBJKws245mi0g72g4ks6jOJwSJH5bD+GY1VVlSkqEH12/WmBZ/O0MhaeA48YK6SqDtg6gLaPzZH0yxcV97bSDSg9DNgqpJP7s4D+2TzlTwBMmww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xBNORdpWoZEYPUYTWIuFktEqN1+8q/2pq+Pu+B25ic=;
 b=l0Qjn2q565OQm1B2vq+8n2/epvk3TJxp0oiHKIJnyxOHJ0cSvLYzp9geI0IUBvHjfHzcOAmxdJX5Wr6meoQZiqP7oEbUrl/OuktEORiuG9yOQfycVdgzj8amAQuYc/hMiqCJ6DVGyrjmgHelqALivYQqR6MRtrhIA75r/Jz3GxGwXgDSH6gOcWNX573LdjtIZcROJYkpjk0i5WfY5yqSfFjSgafu/KlCyIKlPscIBNOPMij+FZwopzeZFkBckDTwQ0qBiq0uGnMR2njD3I0G/fOOiFfttJbfVnrA5VxDEQ39QERZj/v/CiwVvMS+jJ02J08NrS5gWWCOkD4lXItL5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5279.namprd11.prod.outlook.com (2603:10b6:5:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 20:41:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 20:41:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "aik@amd.com" <aik@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"brijesh.singh@amd.com" <brijesh.singh@amd.com>
Subject: Re: [PULL 17/19] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE
 event
Thread-Topic: [PULL 17/19] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE
 event
Thread-Index: AQHaqJqWZ/WMSP/GyEG6SMQiPdTI4Q==
Date: Fri, 17 May 2024 20:41:26 +0000
Message-ID: <96cf4b4929f489f291b3ae8385bb3527cbdf9400.camel@intel.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
	 <20240510211024.556136-18-michael.roth@amd.com>
In-Reply-To: <20240510211024.556136-18-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5279:EE_
x-ms-office365-filtering-correlation-id: 1acf8fef-ffa4-4f5e-0af6-08dc76b1b8f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?M1laMHIvL0NkNTg2bEpHUWtSRkRYLzNtTEFzSWIzdXBKb1BjNWtXeVh6UHhO?=
 =?utf-8?B?dnFKb3hSZlh4WlhQcVdBcXhvRk9xc29nSnMweEJPV24xR3dXRWdwNDJxbmRy?=
 =?utf-8?B?MkN0UmZIUTVhZWl1RXlWM3NIRGNyZGdLVTdjNHhVeDZRVmRHUnhUWmtIalcw?=
 =?utf-8?B?SmFNck12NVgwYnFkejFqaHpOQno2N05Fa3RXUmY5bmZ1NlpzditJSnhnWC9Y?=
 =?utf-8?B?L0F0a1dJSlpzdlRHVGZ3YUhWZEV2YUIyWEdIQm9rSmhRVEVtTkk1SHRiUHY1?=
 =?utf-8?B?SlNINEtZblJmTjVQZFAzTFF5V1BzeitZQ0pOYkFOVmVMRGY1VkU0Z2hUa1VM?=
 =?utf-8?B?TWRmdEd3SkZyT3F3K1MyQXRNMmh0d3VDZDl2cDA2SWVCcWNXTVEweW1mY3lX?=
 =?utf-8?B?NzNrS0pzVkZRV1VEeUl4bFlOTE9RZXN0d0JMOWNNSzcwbTUrOHY0dWFvL0p4?=
 =?utf-8?B?aGcvYmU5K0h1TG9CWFJ1UEd4Z1l4V1pSNEs0OUpob3Z2MkhIZ1FleWVoejds?=
 =?utf-8?B?bENHbFhTcVgzK250Sm9PdDlraks2K0hoYjRMRlpkYVdxUE1oQkdLK3ZnaTlE?=
 =?utf-8?B?VlRoTFpkMngzMk1rbkhlSlJxYkJHRzV5WTJ6bDZKK2RRcVBVblVLRDArT0hi?=
 =?utf-8?B?dmRiYkhsSWN2RmMyQVhvL05QOGc3dGZFOG5oYXJrUk1DMTFBUnlkOE41Zncz?=
 =?utf-8?B?cnhjeTR3U096aFQ4TGJsOU13c2V1UVY2Q3gwL1U1UDRLSTR5WlR4Z0tSRVQ1?=
 =?utf-8?B?bHF2ZGJDVnhoVmZXMFBoalJFK2JXalpEaHQxOU5XTmdTS09hUW9rb0Jsby9h?=
 =?utf-8?B?eVVUa1VTMVpBRzBEeWwzNjZ1TWwxaWdaT3NNU0pUYVZlQjdldTdVdWhYQUc3?=
 =?utf-8?B?bmF4S2Vod2VBRzV0V25iSUZLL0Y0QmVRdlBKRlVFdUNBTkxEeCtrR2xjbWRD?=
 =?utf-8?B?aTBzUzBDeFVDY0VDdmJMWHkyV2EwVVRlNGh4bk50amk2MGxnbWlYeGFjdytT?=
 =?utf-8?B?SnZ1OCtxclhaeXdHblEvL0VnSHhIUlJ3ekFtRjRHaTB1dEprNnFtOVM0cWhP?=
 =?utf-8?B?VXg1aWtyWDNHRyt5b291Z040S2U5RHBJUDFXQWRIbVQ3Q2VrQzNWdnpOMGdk?=
 =?utf-8?B?SEpFR3poRE0wZ1A4SVVSUnh6aUdKRTdYSFd6V1IvMXVIK2JJNGwrODZ4dHVl?=
 =?utf-8?B?c05LOUh0YU9FU1NaV3ora3UzTHduczMwOWd4OWlvQzZPOGJTTlZwSVV4eXRl?=
 =?utf-8?B?d001Nk00WTdFazd2Zms5NFNTYUNGTERiR3MvWjQ1ejlWNEU0UGt2elYzdmpB?=
 =?utf-8?B?ZndkaXNJMUc0TU9mMnlqTytoTWJqWkd6MnNld2hWRGZBQTdINDJlMEdMNGRB?=
 =?utf-8?B?Vi9UdlJWa0dqbXhOM281cDBVQlBhZG5YNkVockFKRHNRS1B2RUxEa3RvZ2tZ?=
 =?utf-8?B?eTZWOVY2SlFJczRaaG5lZzBWQnc3WWNVVTcwbnJBNXJTN2pnM3o4NzlmbWtp?=
 =?utf-8?B?eG82SEhHVS95emdGQWRvb3ZncGczZlNyQStLV3FKWW8wZEtMSll0alRHUU95?=
 =?utf-8?B?VkhEMjV4OW9CeGNvcDVmcnVVcGxycmNGd3lYS2NzY29OcFpxSytrYlpzWUQ4?=
 =?utf-8?B?ZUE4eVB6Ym9NYkp2UUMyQ2FuRHlXV0UwT3pVY3RRQlVkNHlkWjhuc1dxMFMz?=
 =?utf-8?B?cVhoOFpXbTZLT1hacCtMc3BCQXk4SG1CeGZMbm5LaXVPNnBZU3lPYlBhdW1T?=
 =?utf-8?B?dkhuWk9xRThzSnlGcmQrKzRzUHVkMlF2b21uaHFUUWZ5LzcrSHNuTjgzTWV6?=
 =?utf-8?B?cVVYU2NtNy9YQnRZZVlOUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmxqMTdBM1FYdC82a2crS0xWQTBwVGhFd0VxZDRGQkRuQnhuNXpMckhGeEQ2?=
 =?utf-8?B?b0xpTytDTUtFN3FMRFo5SnhBTDZSdE50dVM3bUJ4b1JrVmF3dkxUeHdFbTds?=
 =?utf-8?B?eDFrQVF4OGJ3d2FKTXdUL0ZULzNjR0E4ZlhEQ2JyWjk0SWhQd2Y3Q2Z3UGxr?=
 =?utf-8?B?VlkxUjZBT1F0WHlKMUgxT0Jpd3RvL1NoRFBQT0ZodUJ3VW9xMHo4UlFNMTV6?=
 =?utf-8?B?UjZ1bS9aaGhLdHRvQkNjdHJzWHUvMk9qanpmeWlBTWhOR0wyVzBKaSsxOFlr?=
 =?utf-8?B?dWRnNE03QmE5VytXR1FJVUZDQVVSbTZzWWJmbTN0NXcyTmZhOGtMYzdISEFQ?=
 =?utf-8?B?SnBnNVFmYVlndU96QWFHNnUyeWhYbFh4cGhRVHlubHI2WE93Wlp4R09OMzAz?=
 =?utf-8?B?YmdLM0FFYkFJeTBvczdhb0h6L252TlM2Tk44N09VbVBKQWh0NU41NTRUUU5V?=
 =?utf-8?B?S1hNdE5MZXhIK3RVMzZEWldvZDQ5WWRXcElxWDVpRDNUTVFLWDVvU0wxWGNt?=
 =?utf-8?B?ZXRWdVVienhvSHJaZmM1NzEvdVM4UEx5VnJURTJxYjN0WnJhallRdWY4NENT?=
 =?utf-8?B?WitzUDdmY0VjbXZhR2ZjbDlNV2hrUzRpWkhDNytnWXhiM08xOFpRMHZVT0pV?=
 =?utf-8?B?aWRrYVFwOHNwY2RPVHhycHZ0bnp6ZVBBWUFtcjlURVhBWmtIOVp6dVRldTBi?=
 =?utf-8?B?MExTQ2xEa2o1L1VzVU1GSE9mY2UrdkUzc3pxbFlPRVR6bm9vVjU0bVRTWkFt?=
 =?utf-8?B?dGo2Q3Q2MDQ0KzBCL2VlVXI3UUF0TmJTSnp2NWZoOEVNYmtZSWEzYk15ejA1?=
 =?utf-8?B?SVkvdmhUWVlkRjRGSWhhWS9NMXdRRFJma2xJYkpzUlBPWTh0a0M1N1lCd1Er?=
 =?utf-8?B?NGF4WlpYRms5ZDQ2eWRiUFY0TExJUVRwZjIxSWJsenVDdnd0TkJHbFdHb0NK?=
 =?utf-8?B?bi9MRm5xYjVlWUZTMmhqNHpsZVNUMERZbG9NNGprMkNKZXVOWWw3K2pSbWNk?=
 =?utf-8?B?eng0WVhGTkF0YkJjMDUrR2dHZUFGYzgvaFVuZHpDNFVRV0RrK1FTd200OU4v?=
 =?utf-8?B?Z2dLK2RIaG1VclQ1aHF6TCtvK3k2eHNMcHl5ZzdXZDE2YmllNUkvN1d1V0xw?=
 =?utf-8?B?TE9ybmlYMExQaGJpY21sSndRT2l3UERLRzVIdGQ2SGR1RmZQVkw0Vi9ScHVF?=
 =?utf-8?B?NzFqeXl5ZzFKbjI5RVV4SDg5UWRQeVNzbXFiN1hHNVRDdGRwcHFPZnZNNzM1?=
 =?utf-8?B?dXhhdGRTeUNrSXpWNjFlU3pjZFNuSXVwaUtrSG9EY1dQMUhBcC9YbjFDSGdt?=
 =?utf-8?B?VWhRd3lRS0p6NW91cjRnT090TjdWUzhiTUYyNTd2Sk12UmhBdUgrdWQ5T0N6?=
 =?utf-8?B?ZVMwcy9kUGYya0xRMVlCMUdNRG1PNThaY3dKZmN1V01tdElBcjkwQzc1YzE3?=
 =?utf-8?B?WHQvSDVXSFdHQ0RDNXA2TStMWGsxd0hsYlcrcGRURUY3eHJvYWZEVDQ2ci9r?=
 =?utf-8?B?dUJGbENTY1YvOVhwUThPUldSQlZ3MWtzdU9qS0trQkluVStxUG5ZOFV0T0hO?=
 =?utf-8?B?NW44NUtRamlPSG9TUVRqYkZqSE1HaStFNFM5STI5YkVCR2MzU09WNURqTkow?=
 =?utf-8?B?NHBuWXVKMHZuNWFjVFVIWEJYdE0yNnVJZk0zK0tMd3BpWElRWGY3MW82SWxq?=
 =?utf-8?B?VGFGd0tXS0RGSlhwK1BjQW5FL2NrY0ZTQXZsSmgrVTZpQ3JYam9CRGl5SWlU?=
 =?utf-8?B?Z0hvNTRFZUpRb3hTSGRQV1JqeklCd3psZGdnUVVTT29MV1pYZzNEM2M5Q0Rh?=
 =?utf-8?B?VG9LMmI5YzdQdWQ5SGFSUWZONXNhcTIxbTF2UHRVTXgySkkvNzJvN1dTNnU1?=
 =?utf-8?B?U05RZmVsK1hPNFJGWVl0RTYvNDltb1JzN2tDbldVR1hkNFgwWk8wRnJObUVB?=
 =?utf-8?B?UUtrV2hsaDBUMlcyZ0tsdU54My9EUDRoc3h5Nkxtdi9IbHJSVDdVODFGN2Nh?=
 =?utf-8?B?UitmYlljU2ZnWldQVHo1eVd6Z0VuSS9Fc2tQVWlQTkFhSEQ2aXM3a04zemVX?=
 =?utf-8?B?b09ZaUp4SUkxODcvT0UwZVhnZ25uU2FmZ0JsYmUza0ZvRnVNVWlBckd4YitL?=
 =?utf-8?B?U0Nac0RnbEgwWnIybjYvUmYyS3AzYVplMzM2WXh5Tk50dWhXTXBHR1pGT0xk?=
 =?utf-8?Q?pOYJk89BHkMfYST5D9S2ibs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3700023CB46C742A12B96C4EE3A420B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acf8fef-ffa4-4f5e-0af6-08dc76b1b8f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 20:41:26.3793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lt3K+PAQya1zUs0wg6OpIexHhffsL8NwEuvc6MIud9RUIl+gw4co+BoNyLaaWyDFXqqfODUgCuwTdlDptQMeLKG1zDFML6gkN6a2DZ8tupo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5279
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTEwIGF0IDE2OjEwIC0wNTAwLCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4g
Kwo+ICtzdGF0aWMgaW50IF9fc25wX2hhbmRsZV9ndWVzdF9yZXEoc3RydWN0IGt2bSAqa3ZtLCBn
cGFfdCByZXFfZ3BhLCBncGFfdAo+IHJlc3BfZ3BhLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNldl9yZXRfY29kZSAq
ZndfZXJyKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHNldl9kYXRhX3NucF9ndWVzdF9y
ZXF1ZXN0IGRhdGEgPSB7MH07Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGt2bV9zZXZfaW5mbyAq
c2V2Owo+ICvCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmICgh
c2V2X3NucF9ndWVzdChrdm0pKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gLUVJTlZBTDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+
c2V2X2luZm87Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldCA9IHNucF9zZXR1cF9ndWVzdF9idWYo
a3ZtLCAmZGF0YSwgcmVxX2dwYSwgcmVzcF9ncGEpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChyZXQp
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoHJldCA9IHNldl9pc3N1ZV9jbWQoa3ZtLCBTRVZfQ01EX1NOUF9HVUVTVF9SRVFV
RVNULCAmZGF0YSwgZndfZXJyKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAocmV0KQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0Owo+ICsKPiArwqDCoMKgwqDCoMKgwqBy
ZXQgPSBzbnBfY2xlYW51cF9ndWVzdF9idWYoJmRhdGEpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChy
ZXQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gKwo+ICvC
oMKgwqDCoMKgwqDCoHJldHVybiAwOwo+ICt9CgpJIGdldCBhIGJ1aWxkIGVycm9yIGluIGt2bS1j
b2NvLXF1ZXVlIHdpdGggVz0xOgoKYXJjaC94ODYva3ZtL3N2bS9zZXYuYzogSW4gZnVuY3Rpb24g
4oCYX19zbnBfaGFuZGxlX2d1ZXN0X3JlceKAmToKYXJjaC94ODYva3ZtL3N2bS9zZXYuYzozOTY4
OjMwOiBlcnJvcjogdmFyaWFibGUg4oCYc2V24oCZIHNldCBidXQgbm90IHVzZWQgWy0KV2Vycm9y
PXVudXNlZC1idXQtc2V0LXZhcmlhYmxlXQogMzk2OCB8ICAgICAgICAgc3RydWN0IGt2bV9zZXZf
aW5mbyAqc2V2OwogICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+CmNjMTog
YWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzCgpUbyBmaXggaXQ6CgpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYyBiL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMKaW5k
ZXggNTdjMmM4MDI1NTQ3Li42YmVhYTZkNDJkZTkgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS9z
dm0vc2V2LmMKKysrIGIvYXJjaC94ODYva3ZtL3N2bS9zZXYuYwpAQCAtMzk2NSwxNCArMzk2NSwx
MSBAQCBzdGF0aWMgaW50IF9fc25wX2hhbmRsZV9ndWVzdF9yZXEoc3RydWN0IGt2bSAqa3ZtLCBn
cGFfdApyZXFfZ3BhLCBncGFfdCByZXNwX2dwYQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgc2V2X3JldF9jb2RlICpmd19lcnIpCiB7CiAgICAgICAgc3RydWN0IHNldl9kYXRhX3Nu
cF9ndWVzdF9yZXF1ZXN0IGRhdGEgPSB7MH07Ci0gICAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAq
c2V2OwogICAgICAgIGludCByZXQ7CiAKICAgICAgICBpZiAoIXNldl9zbnBfZ3Vlc3Qoa3ZtKSkK
ICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOwogCi0gICAgICAgc2V2ID0gJnRvX2t2bV9z
dm0oa3ZtKS0+c2V2X2luZm87Ci0KICAgICAgICByZXQgPSBzbnBfc2V0dXBfZ3Vlc3RfYnVmKGt2
bSwgJmRhdGEsIHJlcV9ncGEsIHJlc3BfZ3BhKTsKICAgICAgICBpZiAocmV0KQogICAgICAgICAg
ICAgICAgcmV0dXJuIHJldDsKCg==

