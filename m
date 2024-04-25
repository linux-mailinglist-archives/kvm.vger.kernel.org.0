Return-Path: <kvm+bounces-15946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7512A8B268D
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F14D01F217F3
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29A3433C4;
	Thu, 25 Apr 2024 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ew1WRC1O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6DCF513
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062720; cv=fail; b=GIG6AaP/hTmq/PjuiVhfEz96B0w/9GhzURzeAnIuEvJr/+vRQoIc5LeT+Fu5eAuPskJdbvhw1QLHv5isj7H7F0rU4Z1CLs9YLh8M7scdW0ywz4C1qXIAuCtoTtxIpTcZ8OXqKGCommN7CzEMQH7n+5WaclrRvkglot8d6MgoroI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062720; c=relaxed/simple;
	bh=JxRzK7SYdKoNRfWaHmDlRL4fylW29rcA9kO7x2C18hI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JRnJYnuQSmmjy/QmTrrpxdXoJBKxGGpKSh4tjv+etVgIc/Fx20qpikbRiZbUELON1iimad1xauJFncNoqODkddZXpRuvLEZhNBASfmo6qk8QwP7t/RD9QCOFEwCbO3cD+nAdLJJR6K8nd4Yz5TdpPDRML9cB7AzhZkcbaqlpj10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ew1WRC1O; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714062719; x=1745598719;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=JxRzK7SYdKoNRfWaHmDlRL4fylW29rcA9kO7x2C18hI=;
  b=Ew1WRC1ObjWKw0lyVnQmJvnFZE8etP5zy9nL62fmHvhmlbeM+t0bwrpf
   O7V9bvwbRnXm1WSLZYSCwRyyqvYi/a+Zfu5QzGHxSxtCa74YqlUja2qMm
   S58kFMQtFQZwABsrddd9z3UOSmBTWN6hrIUWgZtvNUJY9a1CcprJDTWe8
   XbHEUkQ0uPCjtlSNZwY9Cspu2g4gSsUCc8ArGRrlZVoQSnRUoCpsJm1VT
   RHRH6E5VJizPZh90XGR8519khtt1r9V4tQ0GzWIu0yZ4oYpqt3zOusCgL
   SVbORp0kKq8x4+9wJoXk8gHl8ZfXY7+A7stlF5U6nm+3EJvt53GpDk8+9
   Q==;
X-CSE-ConnectionGUID: VdnGbGxbTc6Aj/IAru8d+A==
X-CSE-MsgGUID: rHp2S27BSHWHx7BVDX6tdw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13547211"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="13547211"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:31:58 -0700
X-CSE-ConnectionGUID: h8KeiNK8TMqZUXhlU+KxgA==
X-CSE-MsgGUID: 5ehqSathTa6d5/2YH0FIcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="29925196"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 09:31:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 09:31:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 09:31:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 09:31:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 09:31:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7J7tgDZWtM/HUZx3+u0fYipaId9nuUkMrMnt4S0hiZRKBEBR/TZoeq7gJ6YXtNqDHup+nl6bRrFTJVjyH4uUYFQPk3fP+5yAYznw65uJGsKtSu3dPnSRf3wwQsVe4McWCYbjDaOs+5DL2NmZ2JneBTk4/kg8cO5OShKJGwqVaACT8eHIRBOClVtVJrmLjDv2r8SNYZeiKXviZwmtqqKuV+q6J2suUQYttfqPLmBUTftrAx6wc7Cr1qLC/FR1z1ElTSY7XIoGhtUQQ4qd4G9wqEpi0Jjb1Rlmy13gkVJ4TCOMSCEKXmpCBdltls8sEuclNZY8xUfMU9E4JsDg+lQJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxRzK7SYdKoNRfWaHmDlRL4fylW29rcA9kO7x2C18hI=;
 b=Y751Dyztz3JR1rooL7NheehBdkZxCPtpoPOUkslIPrIGL6y6gv+OPNj1cc7+yNnhJoLlTAQNKzQBLqu4Lxw/dKv4RH9Q02tONNuP9etQlkL/67J6A98z/dwPBYY5LQwri6bf1L2+wUvvDaYAozbXGrqvluil/YwKLvpJMSHH2KZ9o697eJ9cW2JUe4Vhxy3vFqey+hMQTOZmnI8Wx3qbE8/EtqJOfLZ9JO5NLY/i9WFNwDKCjhLOEZtr5BvZhmCNkuHIPRn44MdNM/tH3w4zYxWHdxOVWbFv3rtQpGKc6Q5qExBJYSlYr+3D0Nz6Qekh912f91bEZVgN51ThmpoLbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7899.namprd11.prod.outlook.com (2603:10b6:930:7e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 16:31:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 16:31:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoA=
Date: Thu, 25 Apr 2024 16:31:52 +0000
Message-ID: <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
In-Reply-To: <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7899:EE_
x-ms-office365-filtering-correlation-id: 87c16ab4-90b9-4280-fafb-08dc654536da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UDZxQ1pkemxqcW1sUmlyRit4YVN6SlIzNGI5S1dkSTRRQlFLdzBEVTN3S2tr?=
 =?utf-8?B?NHFPa2UrV3ZacUZqZGh0dXgrU2hFcEc5cDRWRWZSMnhvUExVWmtnd0V0OWdH?=
 =?utf-8?B?Nm1jKy83d0YxcU1JTVJCQVptKzYwWm16d0RQcjU4Wjk3NW0yRUpaUWt2Smh2?=
 =?utf-8?B?SEZsdjA2TDdFQUQ4SVhtczJXUVNpTEZ5RGU3ek9NWldoYTNyWi9hcCtTbkd3?=
 =?utf-8?B?Qmh5RjV0T09qVHNxUDhNN05kWTZISkk0c0s5Q0IxL0VIalVJTnlHTWFOSU8y?=
 =?utf-8?B?bUVrS0Z6d05RcTd5M3kxVDdRQno0aFkrdFE1NHRRTElHMkRKSS94TkJJWjQy?=
 =?utf-8?B?MkZqeWpmK0dUb25QdzBad3EzcklVeUdVU041NWZIQTNWVDlxRzJhNDN0eHph?=
 =?utf-8?B?aTRONUZLSzdWYXBQc2hUMkFQTU9GaDVENmNCTmRsQVdRSTJnc0VXZnVPMUhX?=
 =?utf-8?B?bk9NY3ZjZGdZLzF0RkFwZGhHckcrZ3JyUWF0NmJpaFJoNTdKN2dZZmpmNTNR?=
 =?utf-8?B?bVhrUTMrNlZiVmNVS0F3eXNGcHBUL1lRUmh5bTdDVVoyQkNCR0pqamR0MGN1?=
 =?utf-8?B?bXd6Vk5GVU5Sc2dnWlMyNnZaMmplUnE3QUdxa1VHRzJSOTlnNnhsdWRXN21Y?=
 =?utf-8?B?OVZkeDBDaTc5VWgwT3FTLzNkL1E1dVR5M0FyUldrWjM0NmFqSERyaFlvMlhl?=
 =?utf-8?B?eXoxQ05OL0x0aHVmNWsrUHJoY3lYSVZqSXBTaE8wL0JRaklGT3RMUHNTSEF4?=
 =?utf-8?B?NEJteDBReVFQcDJMVVpobFJmNkMrLzZTVmx6amg3SzhvS2l6V05EVkRnUXFH?=
 =?utf-8?B?ejJvSUpyeVJjc01DV2JoNVBidGp2bS85cFNTaXNlUkFaTSt3L1Z4SHh2TVY5?=
 =?utf-8?B?OW53ZlRxV0c5MGcrSGs2blNpb1ZrSSsvem1DZ0VyZitUUEtNVlhQSk9mSkFM?=
 =?utf-8?B?WFZtcjRRT2UvSXhVWHdmejRxOVRGZWFLOUJtRWxmNkw5cExBNzNMeUMyT0Q0?=
 =?utf-8?B?Zi9uR083Zk5DclhjNDVRS29UODZhS0hlenJVTmNBVCtFOWxWQUNrMkRxejBh?=
 =?utf-8?B?TWxFNHMzbG1IdVhJcGQ2NDZOMG01SGtLQVA5Nk5ibXdjUDd6aElzVU1DcUVu?=
 =?utf-8?B?cXdqcW9kQTd2bDRBTCtNYk9JaUJsYktDZE9pRThMcXdrbEtLeEJsWU0wVU45?=
 =?utf-8?B?OHRHV3dTUEhBVU04V3IzQ0FseVhEbW1NREM0UUZoeUczcTJkbE95aUExMWFv?=
 =?utf-8?B?QUtveUhvbEpTdVZ2NHVlQ20rMmRuTHpkMzVaQTFiUWpvT241OUtNQ0ZIUWFy?=
 =?utf-8?B?UWFPVUJPSTFWeHk1ODBBcHRyNW96L1ArYmhTTkl1M0dZT1Vlb1ZOSFJxckpG?=
 =?utf-8?B?OFJMMjFTTGxyUisyUlJCL01qZUtZMXBVWUNMeWEyTTFjWmRqRlBwUXQyVnJh?=
 =?utf-8?B?YnRXV2xkQURPR1VFUmtHRkV6bDZHb3ZlZGlzZ1o0S0lmcHRXYlBVZndkQkRr?=
 =?utf-8?B?Z0hvSkhQRWVDRW95bUR3elM3dzZZU2RuOHc2bzNuS1dSNk1yTTYrb3Ywb0Zn?=
 =?utf-8?B?Y2c4OElyaDZyalV5WmFnSWpCbG5wamlORlIyUUI1ckdVTDcyVkxHVlZUY3o4?=
 =?utf-8?B?Qko5dG53d3l5Q0Q4L3FoRE1YM1FnTmpueTFFU1FwdGxwRHl2SmkyMURtczZh?=
 =?utf-8?B?dkZRL1VMcVhQN0tvUDBSa2VWWEYvN2ZlcXdDRzlwbWhWQnpCMitxTDRzVk9U?=
 =?utf-8?B?blo5YitOR2xRQ21ZVG42aHBDSjFIa1l6VGsvMStlUXpzeERnanowSy9CemFa?=
 =?utf-8?B?RmE4bGhINnZheUVjRlVndz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXpJL3hEaTdqSkNpK1grYnRMZnI2MEN4djgxWkJXdXBLQ3RhV0o0MDdEMkRp?=
 =?utf-8?B?eUlLV2F2Ym1EMHlkUFk4V2FGN2JlYmxTRXNTQWlaUnVka0ZFYXU2NVdlVHBv?=
 =?utf-8?B?QXRmbUtSS3NPZEE3V3hzT25wTHhvbUloMjRsekJMVjFOSTRsOE0yaUhKZlhR?=
 =?utf-8?B?NW8wclQwVlJrU2hqaERQWFJ4dVdSZmsyV3R3NXRnTUJiNjRYY0tabHh4TEwx?=
 =?utf-8?B?V1VzUWZ2bWVGRnpYUktoWDJqRXoxcXphRlJUYkZtL3F4d3BqbTBJanJMaGpy?=
 =?utf-8?B?Q1FxU2xtYTY5bWhWWWZDMEQvV1oxK3pieCtvYmtGNlJ2MCtQWTBlcWJRQWhC?=
 =?utf-8?B?WjFST0phcmVzTldCM01GQ1pGM0lPR2UvWFU2UzhYT1k5VjBveUk0TGM4MU40?=
 =?utf-8?B?aTlLU3cvMnpZSytFNnI3THd5bmc3UW8zNmpTSzg1eVoxZnpXYXRudklHeTE0?=
 =?utf-8?B?eVNoNTNqSVhvTUFQZnVVN2ZMVlRkTXRNdWlRcGR5SlVMa1hENjZ4cmpGdzkr?=
 =?utf-8?B?aVdBVG1OVTVNV0MvVFBvWFJQL3VsR3huMDdOanEyVWxtK3kwSm9ZTjF5Wjc2?=
 =?utf-8?B?bzNtaStqeUZwK2VYQ3RCT1dMWnc3NHpzc05KR05LaUJyanVPQlczL2wwdFph?=
 =?utf-8?B?aFdPTFI1dTEvcmVKZFNGbXE2ZHZ6NGJ1MUtmWEtVV3BEVmdWdFdPOGFEU2JX?=
 =?utf-8?B?eGxyTEh4Y1dsdWVROWdBS0xGRm95d3IrRndGUWxhN2ltdHA3eXhYYU8zSGtD?=
 =?utf-8?B?VVBnWk1RUVNReDRvZEdORWN1TU1EenZzOENCSlN6K0hPMUNHRkhBMlBONVM0?=
 =?utf-8?B?T1RqMVN5S0ZrWlZkbGlIayt0bHlMbXZncy93Nmp3VEdkcE1HS2dlZ0pXV05w?=
 =?utf-8?B?ZjhpL1dna0ZLS0lFT1MxSC94RzBsQzl5bUhuZi8zY3Q2bGhPS3FyWjFmajRy?=
 =?utf-8?B?M2VFVWZBR2t5bUttdFBLa2ZkUi9xS3RQVTJPS3pjdW1HWTFTdDBsaU1uSXBk?=
 =?utf-8?B?ay9tVGJMVmxncmtpTWlXMFRIclZQRnNHT2lwTEZzem8yajNjaTZFM2s3Wndl?=
 =?utf-8?B?K0t4a0NxaTBHRGdVL3FIMTZORXZJNTFyelRqSll5dTcxa2k5NFJ6NnJ0ZEtB?=
 =?utf-8?B?cGI4UnB1aXgxUmJQRXA2SjRnUUFGb2xibVg4bkRpU0hEd2c4cGtwZnpXZWlX?=
 =?utf-8?B?N1d5Rjh2cm1YUFlObjhnQ3QvSjM4cVU4YStHMmxWZ3VDVmFMMFRMeW1yUDlN?=
 =?utf-8?B?Sk94RUkxUFM1VzhNRUN4dlNGMWhPT3A3TlpCLzkrSGZkMTNQUGNVU1J0SDVL?=
 =?utf-8?B?SVNxZnVCY2M2VWx3ZkJpOXh0MVlXYy9pOWFsS25OQWdBTWhXYzVwb25HZmFM?=
 =?utf-8?B?Y1dkcjF3Si9wZ25UU3E4WHpidEpVR0tRTUY4RkgrcGY0SVJhWGJXSDJNZGcy?=
 =?utf-8?B?amU0cXhvWEgybUw4T25PeTgyUmgzRm1DWVFnWFNHWFA1QWNBa3NQMTBoV3dK?=
 =?utf-8?B?OTUzbFovYmVxWTFEa0c1cFczVzJMUDJObit3cmh4UVh1T0FnVXVadHh2a3Rj?=
 =?utf-8?B?TUxRNHNuaC9kSSttazZ5WE95Ujc2MktoNE9vOHFiS2cxb2ViTU9OMVFqb2dE?=
 =?utf-8?B?VWJVZWIrWGhwTnp6T2pFVyszMyt5dlNkUUtKaFBOSnFkRXFiUGo0ZmtlS2li?=
 =?utf-8?B?Wld2Q0tIODVLK1FIeUJGNXV5c2Y3SDBoWExhRUI0VGpiUDd5N1hacnZ6aEho?=
 =?utf-8?B?dXNuRWZpOVFuWnhsVWRXNDROYUJTdmQvNXI1M0NVTDIvVXlJaWNoL1p3Q2lY?=
 =?utf-8?B?WWhwTjhUZFZGQ2ZnUEErZVdVNmhIQnFYMWsxQUFlc29vVEVJRWwzaGdLM0ZX?=
 =?utf-8?B?allXelZPa2dCc216WEl6TFc5YkNsa3ArZFovN3ZGUGZXNFJJb2Y4T3ZUVmNh?=
 =?utf-8?B?R1p3V2xMeCtKYzRSV1UrdGRadlNIb0dOSU5zS3NmY3lFUXF0RVo0UzZSc2dL?=
 =?utf-8?B?L2JzUkZWK05rSjhRYUcvTEFaUXZDM1haV3YwTGhsZDNQTlFlTFdDK3g3M0ZM?=
 =?utf-8?B?UGZyNlAvR3p0YzRKcUlHa3dmcUwzcVhxandDT2JsMkRVODRIck5jYVd2ajNp?=
 =?utf-8?B?c1ZTOVpvMGlENE8zVkVCM1MwRmpDaDJtaVlaN1BCM3VjUlg2RFhLeE54NGtO?=
 =?utf-8?Q?BOoEt91pqgYVDWXwNBRQ0R0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA3D6EF580900E4A9945E98994D54CC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c16ab4-90b9-4280-fafb-08dc654536da
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 16:31:52.7212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NJGiwmE5zElNi7kg0un0FDegefYrzvV1gkoFc4rsSWOiNkXD2taBYD1IAWpzDGeq3lT5oEfwQiHOFgEWeSF03aJxfFHsOcKc6oev+Fu9Rro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7899
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDIzOjA5ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IFRoZSBpZGVhIGlzIHRoYXQgVERYIG1vZHVsZSBjb3VsZCBhZGQgdGhlIGNhcGFiaWxpdHkgdG8g
Y29uZmlndXJlIHRoZXNlIGJpdHMNCj4gPiBhcw0KPiA+IHdlbGwsIHNvIHRoYXQgVERzIGNvdWxk
IG1hdGNoIG5vcm1hbCBWTXMgZm9yIGNhc2VzIHdoZXJlIHRoZXJlIGlzIGEgZGVzaXJlDQo+ID4g
Zm9yDQo+ID4gdGhlIGd1ZXN0cyBNQVhQQSB0byBiZSBzbWFsbGVyIHRoYW4gdGhlIGhvc3RzLiBU
aGUgcmVxdWlyZW1lbnRzIHdvdWxkIGJlLA0KPiA+IHJvdWdobHk6DQo+ID4gwqDCoCAtIFRoZSBW
TU0gc3BlY2lmaWVzIHRoZeKArzB4ODAwMDAwMDguRUFYWzIzOjE2XSB3aGVuIGNyZWF0aW5nIGEg
VEQuDQo+ID4gwqDCoCAtIFRoZSBURFggbW9kdWxlIGRvZXMgc2FuaXR5IGNoZWNraW5nLuKArw0K
PiA+IMKgwqAgLSBUaGUgMHg4MDAwMDAwOC5FQVhbMjM6MTZdIGZpZWxkIGlzIHVzZWQgdG8gY29t
bXVuaWNhdGUgdGhlIG1heA0KPiA+IGFkZHJlc3NhYmxlDQo+ID4gwqDCoCBHUEEgdG/igK8gdGhl
IGd1ZXN0LiBJdCB3aWxsIGJlIHVzZWQgYnkgdGhlIGd1ZXN0IGZpcm13YXJlIHRvIG1ha2Ugc3Vy
ZQ0KPiA+IMKgwqAgcmVzb3VyY2VzIGxpa2UgUENJIGJhcnMgYXJlIG1hcHBlZCBpbnRvIHRoZSBh
ZGRyZXNzYWJsZSBHUEEuDQo+ID4gwqDCoCAtIElmIHRoZSBndWVzdCBhdHRlbXB0cyB0byBhY2Nl
c3MgbWVtb3J5IGJleW9uZCB0aGUgbWF4IGFkZHJlc3NhYmxlIEdQQSwNCj4gPiB0aGVuDQo+ID4g
wqDCoCB0aGUgVERYIG1vZHVsZSBnZW5lcmF0ZXMgRVBUIHZpb2xhdGlvbiB0byB0aGUgVk1NLiBG
b3IgdGhlIFZNTSwgdGhpcyBjYXNlDQo+ID4gwqDCoCBtZWFucyB0aGF0IHRoZSBndWVzdCBhdHRl
bXB0ZWQgdG8gYWNjZXNzICJpbnZhbGlkIiAoSS9PKSBtZW1vcnkuDQo+ID4gwqDCoCAtIFRoZSBW
TU0gd2lsbCBiZSBleHBlY3RlZCB0byB0ZXJtaW5hdGUgdGhlIFREIGd1ZXN0LiBUaGUgVk1NIG1h
eSBzZW5kDQo+ID4gwqDCoCBhIG5vdGlmaWNhdGlvbiwgYnV0IHRoZSBURFggbW9kdWxlIGRvZXNu
J3QgbmVjZXNzYXJpbHkgbmVlZCB0byBrbm93IGhvdy4NCj4gDQo+IFRoaXMgaXMgbm90IHRoZSBz
YW1lIGFzIGhvdyBpdCB3b3JrcyBmb3Igbm9ybWFsIChub24tVERYKSBWTXMuDQo+IA0KPiBGb3Ig
bm9ybWFsIFZNcywgd2hlbiB1c2Vyc3BhY2UgY29uZmlndXJlcyBhIHNtYWxsZXIgb25lIHRoYW4g
d2hhdCANCj4gaGFyZHdhcmUgRVBUL05QVCBzdXBwb3J0cywgaXQgZG9lc24ndCBjYXVzZSBhbnkg
aXNzdWUgaWYgZ3Vlc3QgYWNjZXNzZXMgDQo+IEdQQSBiZXlvbmQgWzIzOjE2XSBidXQgd2l0aGlu
IGhhcmR3YXJlIEVQVC9OVFAgY2FwYWJpbGl0eS4NCj4gDQo+IEl0J3MgbW9yZSBhIGhpbnQgdG8g
Z3Vlc3QgdGhhdCBLVk0gZG9lc24ndCBlbmZvcmNlIHRoZSBzZW1hbnRpY3Mgb2YgaXQuIA0KPiBI
b3dldmVyLCBmb3IgVERYIGNhc2UsIHlvdSBhcmUgcHJvcG9zaW5nIHRvIG1ha2UgaXQgYSBoYXJk
IHJ1bGUuDQoNCklmIHdlIGxpbWl0IG91cnNlbHZlcyB0byB3b3JyeWluZyBhYm91dCB2YWxpZCBj
b25maWd1cmF0aW9ucywgYWNjZXNzaW5nIGEgR1BBDQpiZXlvbmQgWzIzOjE2XSBpcyBzaW1pbGFy
IHRvIGFjY2Vzc2luZyBhIEdQQSB3aXRoIG5vIG1lbXNsb3QuIExpa2UgeW91IHNheSwNClsyMzox
Nl0gaXMgYSBoaW50LCBzbyB0aGVyZSBpcyByZWFsbHkgbm8gY2hhbmdlIGZyb20gS1ZNJ3MgcGVy
c3BlY3RpdmUuIEl0DQpiZWhhdmVzIGxpa2Ugbm9ybWFsIGJhc2VkIG9uIHRoZSBbNzowXSBNQVhQ
QS4NCg0KV2hhdCBkbyB5b3UgdGhpbmsgc2hvdWxkIGhhcHBlbiBpbiB0aGUgY2FzZSBhIFREIGFj
Y2Vzc2VzIGEgR1BBIHdpdGggbm8gbWVtc2xvdD8NCktWTS9RRU1VIGRvbid0IGhhdmUgYSBsb3Qg
b2Ygb3B0aW9ucyB0byByZWNvdmVyLiBTbyBhcmUgdGhlIGRpZmZlcmVuY2VzIGhlcmUNCmp1c3Qg
dGhlIGV4aXN0aW5nIGRpZmZlcmVuY2VzIGJldHdlZW4gbm9ybWFsIFZNcyBhbmQgVERYPw0K

