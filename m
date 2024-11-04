Return-Path: <kvm+bounces-30482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0186B9BB059
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86B861F22727
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308961B0F1F;
	Mon,  4 Nov 2024 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OcJNjV1+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789281B0F1C;
	Mon,  4 Nov 2024 09:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730714140; cv=fail; b=LcQ+FN+OyACr9b8ABIcMgCBrQAtAxRwBu6XQUc27GDgMg5dcbst2ePcmYF5s9q5T9EgrTJiYsjLlH5UUyz5F3QstcbZ5OHzB9Di+v5g+wunwLTFf7mCsHd8El+s+DF9/2BYeulKkTvg6id6oqI6U5M1VDyuKVPn/nvunzxU7E+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730714140; c=relaxed/simple;
	bh=+WcNQ2sHyyExt673qA0JaC63zWQS3BhPr/OI/a+qCBA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y8rR5V2udydhRTnW8uSQrUXM2ujEW9IV0vZE6hEAGnUKvCBnj2GaXYxfSykCuiYKNuzjevoKqMfNXOxxmlDDwdAyPkijTpFafxUreitl/PD7+uUkoqFap7ufw+6wW5ozsDMiKhdvI/RMr38tCyB6xLbhkEbVSPCMEnTY3lP9+b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OcJNjV1+; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730714139; x=1762250139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+WcNQ2sHyyExt673qA0JaC63zWQS3BhPr/OI/a+qCBA=;
  b=OcJNjV1+CqW/kRL2qOI2GUDKImhsKUbi1VpTSwoDBwcidOVvNsOz2KKA
   HnoTGJn/GelpoEf2muxeTk7qdlzoXDtx3s/AVt9DrtiETjh8FoOOdrFe9
   MGepUh5r01pP8V6lSixz8GmZ7YjTTaqWr4Re0b+YpEHm9j6avySbOOL0Q
   2wuzFbe84IQtpK+n56nJZehlpocQ75JwHen9qRC/jf7p1NWQiV+3Og3WO
   K7qhOZDHiqJ+Gkd16rIwMfbDG7RaPCEmWkTDTCs6Q/XhQJ5hOh/kiNqRR
   /qQCQD62retMqec7jA5DKf+Qkt7shpXtrqKxonHi0Z/h8O/p69T4hVxk1
   w==;
X-CSE-ConnectionGUID: y0z+EqZ9Raqj0e+MX8qreA==
X-CSE-MsgGUID: qXqGUDJUQPuYphu7OEimHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="30621921"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="30621921"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 01:55:38 -0800
X-CSE-ConnectionGUID: gL8Fe9IETUG07Byjg5iArw==
X-CSE-MsgGUID: ZAjDvDAyThWDzyYAmilPlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83488051"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 01:55:37 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 01:55:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 01:55:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 01:55:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qbJHV6L5UHUy9Z7DnvO8n7WZVEM7Rdtdw5Qzb4axBTM+OS7ozl5L7GcrUuLWoz76URjO5CQB7qCoV1vDtReuHlKsgi/SleA/xnDPolu/OUUQ4IDLvuIsBJJDMllDYCbllOGxKRqAVAqkmIU2UCkiSNl7T6NymsuirqF/8S58NOXrVHShusTSLzu4azWnxSZUtS0YvAnyZ5zHNZA56WKL3fq1s1rL7YDeCZ8Px3Ee2Gzz1m6oIKJcYf8S2DLreLoJNzaBkar0PhW/66IO/RseNMib8QlxG3eE9dU331CTEIA7I3OcUOmMsUQxoTMBXtC5qU0Uwd4XkfSFd7LO3gGn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WcNQ2sHyyExt673qA0JaC63zWQS3BhPr/OI/a+qCBA=;
 b=V/xzFkzxCqXGZWCtWxMigueLnOkiuys49dyFVNCedGMhqql/VkEGJu0CAONl4KTaliXxo4LjVP8CsW80wjEghbSuNZLUu/ykjrMivhDMr2PlGG22rnq5PHyYfWd1doii6C5YhOwKalNb1Kyr+cv7KbgJrWgmYFmPzPAzH6Hb8xr7H9b+aZXmdhgMQsrRTxatGhAm6/2HC4TPPWxdPEe/XKq1E2cKcqfXapITqLJAK9nBlcYwz7MF8CGgp+44liDEeWprDeFMX2ZVOlqq/HC2vBhuK2euCtc7snyc54DiSiHwNkaaPGey3lB+rlpz8u3zog9qz/+Hep5dqoM88buh/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7101.namprd11.prod.outlook.com (2603:10b6:303:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 09:55:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 09:55:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWAgABdLwCABDPdAIAAEjwA
Date: Mon, 4 Nov 2024 09:55:11 +0000
Message-ID: <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
	 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
	 <ZyLWMGcgj76YizSw@google.com>
	 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
	 <ZyUEMLoy6U3L4E8v@google.com>
	 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
In-Reply-To: <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7101:EE_
x-ms-office365-filtering-correlation-id: 38bfc6be-3a3f-4a35-b791-08dcfcb6c5be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YllDYTA1WnBnZ29nMGZLVHE2cllYZEZjUFJwQ0dyNGtEWDNPZzR3a1NtR3Jn?=
 =?utf-8?B?VHh5eTFWWlhrNHp1cTUyS0d6RFI4TFhsaEs2aTliWVFqRHZaWWIvSnRJWnJ4?=
 =?utf-8?B?R2x3MUdXZTkrQStGMDdRYU55R0ZmMDdGem9IWjFDcG9sR2p2TXVwRXlOaW80?=
 =?utf-8?B?UDN4dENHVFZJMGtRODVJdFBNREFubUxNN3E0WEF5UXVPZTEvdS9NNTdTVTFT?=
 =?utf-8?B?VHM3MDhoU0xjeXZ2TWtoRnhxZjZ4bVRWQXc0VXB6eEFBdldsYk9ZRWEzeml6?=
 =?utf-8?B?ZGMzKzNqTW5rbVMxUkEweklZUVduRzNTY1FIVERya1JGWHExTjVkQXpFM0ZU?=
 =?utf-8?B?UG41K21CRE8yN0hrUlJWVFU5dUZ1a05Gb3U1dWEvWUR4UHFtMVVYT1RvTCtF?=
 =?utf-8?B?RDhLZW80Y2ZyckVNR3FvOHEyZ0JYY0M2ODQ5bkNBZUV1ZXNHekh2UTRqeFJk?=
 =?utf-8?B?Z1p5QkVHY2dlUFRiRnpyNVNoVWNKM2M4c3BsNGJKK3RacnRFRkJNRWJ5R25P?=
 =?utf-8?B?TXd6dEdWOS8rVlU2Rm1UWnZCdGVJZzVra1hKUllVNjd2TWdBM09xNzBPQ3Y2?=
 =?utf-8?B?aDBtMHVSZTZFeEp3d2U2bC9wSzZ3YUkyU21MelV0TkluUldwa3h6TVZUS2JL?=
 =?utf-8?B?T0RQa0w3bWNDN0dZOFlXcTRub3VMSmtIYWF5MGJISlRsK3pEZzdmTy91SnFa?=
 =?utf-8?B?RVJrNlFiNEoyMTdSQ29qYzhxZWV0UWJXamdrQzVqTlVRZ0k2Zkg4WVBLOEll?=
 =?utf-8?B?NTdIOURxYW4wdkJpNkxpbm4zNUtlSjdneWMwU2JFVXg0UkV0THBpSkZ2MDUy?=
 =?utf-8?B?RnRjL29HL3VadnBBVjcwR1FmbERxYlNwZVQvbVBDcDlWblB6NWJQS3hOL3NF?=
 =?utf-8?B?OEpzZ2VBeU9mdjdNOUNtbHRiVFhXeFZaR2hpVUtZc0Vqb2hEZmhVUzRORElH?=
 =?utf-8?B?YWV2SUwxNkwwaFl2dXBpTkkyTHhvOEY4U2l5emU0UjQwU09Xc1NMa1FyMlIr?=
 =?utf-8?B?YVM0dmw0dHBjZm1CRjhNVXZUUy84LzhXRWZCTVQvbnlLSGptdWdmTkRQNXg5?=
 =?utf-8?B?dGkwdURpUUpUc1JRSC9DUDFOcE54eitLOTRvczFTa1dsQmQ2THMxeTBsaWNF?=
 =?utf-8?B?ZFdBZHBOQTJMVitNRC9qb3Nuc2Rxa01QaUllOVA2TWsrNHI2MVlBSkI3eWRT?=
 =?utf-8?B?SkVwOEFsSEdoRVhzaHZVWDVJRjRIeDJ2V1UxRTF4d0VPNWRrcXlEVnJYVmVx?=
 =?utf-8?B?OFh3dzU3cnhCcEdMYkJBNUJJRzR4cS93VkhIUnFnTGlVN3BybGR6OFFJOXVj?=
 =?utf-8?B?UkFKME1JU3RNYWtVK0hUQ2VHbnNHL0tmT0U3Rld1Wm9SeGRWSlVMSHVIbUYx?=
 =?utf-8?B?WXFMYmxhamRMU2tCRnFEZmI3UlNvQmR1MXZYNzZRTkxQTWtPVExqekxnb09o?=
 =?utf-8?B?MTNsQVVqZFd3QU9xVzBHWFQvVVlzZUhxWitNS3dhYkpBejR2Z1pvUFBXZ3Bm?=
 =?utf-8?B?aW9yY2l4OGN2T2labllFQkUybGZsd25Kc0J5N2JxNndScHhTSFJjcHZmMG5F?=
 =?utf-8?B?ZU1vakgyV1JBYXRvczRmcHp2Y01IaHhTSDF2OWtNS204aTd2elMwN29oWFhD?=
 =?utf-8?B?Y05kSXN2dlNIL0JDbHQ2ZnhnTkxxb05qNU5WUjA1VmVsb0p5MEpOWVQ2TkZ4?=
 =?utf-8?B?T3A2L3dKTmZBeTJuTW94MGJ5WVU0cG9kRk9BQkUrK0dmZHh3RE9jQnJscUFP?=
 =?utf-8?B?Y054QnJyVUFlL0VxQTFFRnk0M054d2NzYjZ5K0xKZjVrY25SUUZHaXJjWU1W?=
 =?utf-8?Q?WhWIppPYPvMs4D3HF1AsmaIUbpQxZMMQuKW0g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXVmbDhXK2pjdUNEdlovQUlraGdnYkNvclFUSFZYandwV1NaeVJldGRFeXRv?=
 =?utf-8?B?NWN3OGQzdGNTSDNadEhiNnBmYkhJb1NXOC9vTmNWU3NFb0Q0K0VpSVlIaDNZ?=
 =?utf-8?B?ZVlMaC9pM1VwTHIydC9DNkNOcUZ6UktpcWJkTTRsUjJKbXVEaXJOMlNaMDQ1?=
 =?utf-8?B?WEtGWVNLOU9lemhhemFsaDMxY3E3YTVlN0xUa1lGMyt2SkpGaloraDhHZXJZ?=
 =?utf-8?B?OGZDQUVXczhuZldlOUl1MnNrK2dEbkxXeEJIRmhjZlh0a2t5SS84R0ZCZHI0?=
 =?utf-8?B?ajFZTm1pd1RkSXk2Uld0VXhFSExtRENEcTAvTVFNMk12TEViUVFrUlhhd0E5?=
 =?utf-8?B?UmFzSTdSL1F1WGp6WWdkODFKMlh0ZTlZdWg1QXZUcFcrWExkc3BDV0pobkpp?=
 =?utf-8?B?TW4vdWlQcFpzVkxBdXpmeUJhbkJaVW1nNVd1Z0tqeUtSdEErc2psSG9xbnY4?=
 =?utf-8?B?OW9JNllHMU5wZk5iZTZuOW5TeDdQMUJMakRSUFc0SGFrdkpqYWhxeDcxK3Js?=
 =?utf-8?B?b2U5YU5MVDc2SXBGWSszZ05HZVZxdWdzbFRBeHQyV0UvS2djSllLMkJvQkNL?=
 =?utf-8?B?OHRKTFBCTWl1K01BL3kwZ0xma1psWGd3UllpUngyN2tWeVJnMWlxTlgyMGpk?=
 =?utf-8?B?MUg4WTZiT0ZFbVpMa1cvQ0pWaUI2NEhUOXpqSDFEMjVDVDhoU2Y0bjQ3RFVN?=
 =?utf-8?B?dkVGWGk2TXlnUzJVdUVlVzdNZzIyL3FPeFcweDF1cXBCQUdWbDdoVENqbG81?=
 =?utf-8?B?SlZVOUJRdEVWcTd0WDBFMWxOc2ptZmpOK1VSMjVaMnFIS25mbHFHRU5DMG1X?=
 =?utf-8?B?Y2E1anpza0FoU1JUNnpxdm5jMkJiemtML2NGVVAvbVFrcHkzSDgvMzYvc3U4?=
 =?utf-8?B?MjIxTHRZckVlb3VzZXZzMGpNRk0zSDE5eGhvcmlZUFVYbm1qc0NIL1ZGMFFs?=
 =?utf-8?B?bTNVb3l0R3B0MmZ3RUlweThQckg2Nm5PVExEUzJyT1BPK3lUZG5UYXJZNmZD?=
 =?utf-8?B?emJuQ0NZM3JYL0FWVkdKMmhpS2hyNTcwQ0FPL2FqQVFUVFpLeG12NFhML1dE?=
 =?utf-8?B?SVBuYmVIWUkzT1djaExGOXBMR29KUW9FcjFXbHpBQTY0N0I1aXdLeU5BK3U2?=
 =?utf-8?B?MGlGYTU4L1ZlalpZMFI0eEtJalZIamVROVFXRTVHRGdtT21tRERVTGhtR1FR?=
 =?utf-8?B?WTY0eWpDQUkwQWJZWDZ5VDJQRG1NU0d4TlhXWmZIUjFnMml0ZzBKMWtPREFw?=
 =?utf-8?B?Zm8xSGhUNXJWZEVLaGlLN3lTTU1rV3ZuUmVSUWRLWHhQRFVqVTdEZ3B0TU03?=
 =?utf-8?B?MG9WNkQrYUhIR2ExWnJESGRrK2dEU2hONmFydHhEZnlBQUlLRkxGakp3dFVU?=
 =?utf-8?B?dks0cURVTmxKTE5mS2E4SllZcitjM3VEL01RYU9iaUxUWjU5WnRSOHB5RFdv?=
 =?utf-8?B?MjEyQmpzNHBVQ3RraG1aWlFXcVJSOWY5Rjk4eVN0L29uMVprNG5nRnZ3S1F4?=
 =?utf-8?B?d2hOb2l5Nk9jNGFjaWp5cGNyZGlkQmI2cWthelFxbENSZ0VKbU9KRU14eFkz?=
 =?utf-8?B?Q2plMTdFWlVqSEpQcHkwcUx4MVRvbUhxTkIvNkZNZ0ttbDdTUG9zTUNUdjUz?=
 =?utf-8?B?dERRbFRxWGZTODNtay90aCtsMWUzRGlaLy9Fdmt4bDV6UjJXM2V5TzIzRnc3?=
 =?utf-8?B?V3ZtRTgyQXZya1lGWis3aEVkTmVNY0RoK3JRQTB2L09zalRMWURrb0hGSHRw?=
 =?utf-8?B?TU5pK0NyTjNFSGk4WFRDOFNMRk9yVUlxZXhxSG5yNHYzQ3FtbjgyQk1yNjJW?=
 =?utf-8?B?M1FPQ0pnVGI0Mi9kWXcwbE1GNEIrQUcxQklUKzNwbVRxT1Y4NlNqUnpGR21P?=
 =?utf-8?B?dGtJaEh4d0YyTlgvTldtbzk5dXdFVlRmckFvUlNRcjRlTW9tckZVMXdadlB0?=
 =?utf-8?B?Nmdwc2NVOXNGZnRsRWY3ZGs0cXhlci9kaUtmMXRnV1FaSnpMMmh1QjM1b1Ar?=
 =?utf-8?B?OHE4U3BUQUhPK2dJOFViSWZLZExlTGhUZk5rL1pyb0hFbGRXcTdVU1dvWTR6?=
 =?utf-8?B?VU5NTlpaQnRYdEplcVA2RUI4ekNQVnc1ekxWM296YmpzS0NDMko0ZnlDVWVa?=
 =?utf-8?Q?1fTWMgCqk+3RLLhFvl28ELnQD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <965A45EAEE110F4B9583E2A9BD608E32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bfc6be-3a3f-4a35-b791-08dcfcb6c5be
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 09:55:11.1601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jBiFdRyq4Qic7CUO+/Lgi422IYzv9f6PJxnKba2mFnGuPFJ1xJiKCc1trk34jQoJF7wCDttjdFndx9xEbYXzeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7101
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTA0IGF0IDE2OjQ5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiANCj4gT24gMTEvMi8yMDI0IDEyOjM5IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0K
PiA+IE9uIEZyaSwgTm92IDAxLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBPbiBUaHUs
IDIwMjQtMTAtMzEgYXQgMDc6NTQgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+
ID4gPiA+IE9uIFRodSwgT2N0IDMxLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IC0J
cmV0ID0gX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwodmNwdSwgbnIsIGEwLCBhMSwgYTIsIGEzLCBv
cF82NF9iaXQsIGNwbCk7DQo+ID4gPiA+IC0JaWYgKG5yID09IEtWTV9IQ19NQVBfR1BBX1JBTkdF
ICYmICFyZXQpDQo+ID4gPiA+IC0JCS8qIE1BUF9HUEEgdG9zc2VzIHRoZSByZXF1ZXN0IHRvIHRo
ZSB1c2VyIHNwYWNlLiAqLw0KPiA+ID4gPiAtCQlyZXR1cm4gMDsNCj4gPiA+ID4gKwlyID0gX19r
dm1fZW11bGF0ZV9oeXBlcmNhbGwodmNwdSwgbnIsIGEwLCBhMSwgYTIsIGEzLCBvcF82NF9iaXQs
IGNwbCwgJnJldCk7DQo+ID4gPiA+ICsJaWYgKHIgPD0gcikNCj4gPiA+ID4gKwkJcmV0dXJuIHI7
DQo+ID4gPiAuLi4gc2hvdWxkIGJlOg0KPiA+ID4gDQo+ID4gPiAJaWYgKHIgPD0gMCkNCj4gPiA+
IAkJcmV0dXJuIHI7DQo+ID4gPiANCj4gPiA+ID8NCj4gPiA+IA0KPiA+ID4gQW5vdGhlciBvcHRp
b24gbWlnaHQgYmUgd2UgbW92ZSAic2V0IGh5cGVyY2FsbCByZXR1cm4gdmFsdWUiIGNvZGUgaW5z
aWRlDQo+ID4gPiBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpLiAgU28gSUlVQyB0aGUgcmVhc29u
IHRvIHNwbGl0DQo+ID4gPiBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIG91dCBpcyBmb3IgVERY
LCBhbmQgd2hpbGUgbm9uLVREWCB1c2VzIFJBWCB0byBjYXJyeQ0KPiA+ID4gdGhlIGh5cGVyY2Fs
bCByZXR1cm4gdmFsdWUsIFREWCB1c2VzIFIxMC4NCj4gPiA+IA0KPiA+ID4gV2UgY2FuIGFkZGl0
aW9uYWxseSBwYXNzIGEgImt2bV9oeXBlcmNhbGxfc2V0X3JldF9mdW5jIiBmdW5jdGlvbiBwb2lu
dGVyIHRvDQo+ID4gPiBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpLCBhbmQgaW52b2tlIGl0IGlu
c2lkZS4gIFRoZW4gd2UgY2FuIGNoYW5nZQ0KPiA+ID4gX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwo
KSB0byByZXR1cm46DQo+ID4gPiAgICAgIDwgMCBlcnJvciwNCj4gPiA+ICAgICAgPT0wIHJldHVy
biB0byB1c2Vyc3BhY2UsDQo+ID4gPiAgICAgID4gMCBnbyBiYWNrIHRvIGd1ZXN0Lg0KPiA+IEht
bSwgYW5kIHRoZSBjYWxsZXIgY2FuIHN0aWxsIGhhbmRsZSBrdm1fc2tpcF9lbXVsYXRlZF9pbnN0
cnVjdGlvbigpLCBiZWNhdXNlIHRoZQ0KPiA+IHJldHVybiB2YWx1ZSBpcyBLVk0ncyBub3JtYWwg
cGF0dGVybi4NCj4gPiANCj4gPiBJIGxpa2UgaXQhDQo+ID4gDQo+ID4gQnV0LCB0aGVyZSdzIG5v
IG5lZWQgdG8gcGFzcyBhIGZ1bmN0aW9uIHBvaW50ZXIsIEtWTSBjYW4gd3JpdGUgKGFuZCByZWFk
KSBhcmJpdHJhcnkNCj4gPiBHUFJzLCBpdCdzIGp1c3QgYXZvaWRlZCBpbiBtb3N0IGNhc2VzIHNv
IHRoYXQgdGhlIHNhbml0eSBjaGVja3MgYW5kIGF2YWlsYWJsZS9kaXJ0eQ0KPiA+IHVwZGF0ZXMg
YXJlIGVsaWRlZC4gIEZvciB0aGlzIGNvZGUgdGhvdWdoLCBpdCdzIGVhc3kgZW5vdWdoIHRvIGtl
ZXAga3ZtX3J4eF9yZWFkKCkNCj4gPiBmb3IgZ2V0dGluZyB2YWx1ZXMsIGFuZCBlYXRpbmcgdGhl
IG92ZXJoZWFkIG9mIGEgc2luZ2xlIEdQUiB3cml0ZSBpcyBhIHBlcmZlY3RseQ0KPiA+IGZpbmUg
dHJhZGVvZmYgZm9yIGVsaW1pbmF0aW5nIHRoZSByZXR1cm4gbXVsdGlwbGV4aW5nLg0KPiA+IA0K
PiA+IExpZ2h0bHkgdGVzdGVkLiAgQXNzdW1pbmcgdGhpcyB3b3JrcyBmb3IgVERYIGFuZCBwYXNz
ZXMgdGVzdGluZywgSSdsbCBwb3N0IGENCj4gPiBtaW5pLXNlcmllcyBuZXh0IHdlZWsuDQo+ID4g
DQo+ID4gLS0NCj4gPiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNv
bT4NCj4gPiBEYXRlOiBGcmksIDEgTm92IDIwMjQgMDk6MDQ6MDAgLTA3MDANCj4gPiBTdWJqZWN0
OiBbUEFUQ0hdIEtWTTogeDg2OiBSZWZhY3RvciBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIHRv
IGFjY2VwdCByZWcNCj4gPiAgIG5hbWVzLCBub3QgdmFsdWVzDQo+ID4gDQo+ID4gUmV3b3JrIF9f
a3ZtX2VtdWxhdGVfaHlwZXJjYWxsKCkgdG8gdGFrZSB0aGUgbmFtZXMgb2YgaW5wdXQgYW5kIG91
dHB1dA0KPiA+IChndWVzdCByZXR1cm4gdmFsdWUpIHJlZ2lzdGVycywgYXMgb3Bwb3NlZCB0byB0
YWtpbmcgdGhlIGlucHV0IHZhbHVlcyBhbmQNCj4gPiByZXR1cm5pbmcgdGhlIG91dHB1dCB2YWx1
ZS4gIEFzIHBhcnQgb2YgdGhlIHJlZmFjdG9yLCBjaGFuZ2UgdGhlIGFjdHVhbA0KPiA+IHJldHVy
biB2YWx1ZSBmcm9tIF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKCkgdG8gYmUgS1ZNJ3MgZGUgZmFj
dG8gc3RhbmRhcmQNCj4gPiBvZiAnMCcgPT0gZXhpdCB0byB1c2Vyc3BhY2UsICcxJyA9PSByZXN1
bWUgZ3Vlc3QsIGFuZCAtZXJybm8gPT0gZmFpbHVyZS4NCj4gPiANCj4gPiBVc2luZyB0aGUgcmV0
dXJuIHZhbHVlIGZvciBLVk0ncyBjb250cm9sIGZsb3cgZWxpbWluYXRlcyB0aGUgbXVsdGlwbGV4
ZWQNCj4gPiByZXR1cm4gdmFsdWUsIHdoZXJlICcwJyBmb3IgS1ZNX0hDX01BUF9HUEFfUkFOR0Ug
KGFuZCBvbmx5IHRoYXQgaHlwZXJjYWxsKQ0KPiA+IG1lYW5zICJleGl0IHRvIHVzZXJzcGFjZSIu
DQo+ID4gDQo+ID4gVXNlIHRoZSBkaXJlY3QgR1BSIGFjY2Vzc29ycyB0byByZWFkIHZhbHVlcyB0
byBhdm9pZCB0aGUgcG9pbnRsZXNzIG1hcmtpbmcNCj4gPiBvZiB0aGUgcmVnaXN0ZXJzIGFzIGF2
YWlsYWJsZSwgYnV0IHVzZSBrdm1fcmVnaXN0ZXJfd3JpdGVfcmF3KCkgZm9yIHRoZQ0KPiA+IGd1
ZXN0IHJldHVybiB2YWx1ZSBzbyB0aGF0IHRoZSBpbm5lcm1vc3QgaGVscGVyIGRvZXNuJ3QgbmVl
ZCB0byBtdWx0aXBsZXgNCj4gPiBpdHMgcmV0dXJuIHZhbHVlLiAgVXNpbmcgdGhlIGdlbmVyaWMg
a3ZtX3JlZ2lzdGVyX3dyaXRlX3JhdygpIGFkZHMgdmVyeQ0KPiA+IG1pbmltYWwgb3ZlcmhlYWQs
IHNvIGFzIGEgb25lLW9mZiBpbiBhIHJlbGF0aXZlbHkgc2xvdyBwYXRoIGl0J3Mgd2VsbA0KPiA+
IHdvcnRoIHRoZSBjb2RlIHNpbXBsaWZpY2F0aW9uLg0KPiA+IA0KPiA+IFN1Z2dlc3RlZC1ieTog
S2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4g
Q2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8IDE1ICsrKysrKysrKy0tLS0NCj4gPiAgIGFyY2gv
eDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgfCA0MCArKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMjggZGVs
ZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gaW5kZXggNmQ5
Zjc2M2E3YmI5Li45ZTY2ZmRlMWM0ZTQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmgNCj4gPiBAQCAtMjE3OSwxMCArMjE3OSwxNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2Ns
ZWFyX2FwaWN2X2luaGliaXQoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ICAgCWt2bV9zZXRfb3JfY2xl
YXJfYXBpY3ZfaW5oaWJpdChrdm0sIHJlYXNvbiwgZmFsc2UpOw0KPiA+ICAgfQ0KPiA+ICAgDQo+
ID4gLXVuc2lnbmVkIGxvbmcgX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCB1bnNpZ25lZCBsb25nIG5yLA0KPiA+IC0JCQkJICAgICAgdW5zaWduZWQgbG9uZyBh
MCwgdW5zaWduZWQgbG9uZyBhMSwNCj4gPiAtCQkJCSAgICAgIHVuc2lnbmVkIGxvbmcgYTIsIHVu
c2lnbmVkIGxvbmcgYTMsDQo+ID4gLQkJCQkgICAgICBpbnQgb3BfNjRfYml0LCBpbnQgY3BsKTsN
Cj4gPiAraW50IF9fX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCB1bnNpZ25lZCBsb25nIG5yLA0KPiA+ICsJCQkgICAgICB1bnNpZ25lZCBsb25nIGEwLCB1bnNp
Z25lZCBsb25nIGExLA0KPiA+ICsJCQkgICAgICB1bnNpZ25lZCBsb25nIGEyLCB1bnNpZ25lZCBs
b25nIGEzLA0KPiA+ICsJCQkgICAgICBpbnQgb3BfNjRfYml0LCBpbnQgY3BsLCBpbnQgcmV0X3Jl
Zyk7DQo+ID4gKw0KPiA+ICsjZGVmaW5lIF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKF92Y3B1LCBu
ciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwgY3BsLCByZXQpCVwNCj4gPiArCV9fX19rdm1f
ZW11bGF0ZV9oeXBlcmNhbGwodmNwdSwJCQkJCQlcDQo+ID4gKwkJCQkgIGt2bV8jI25yIyNfcmVh
ZCh2Y3B1KSwga3ZtXyMjYTAjI19yZWFkKHZjcHUpLAlcDQo+ID4gKwkJCQkgIGt2bV8jI2ExIyNf
cmVhZCh2Y3B1KSwga3ZtXyMjYTIjI19yZWFkKHZjcHUpLAlcDQo+ID4gKwkJCQkgIGt2bV8jI2Ez
IyNfcmVhZCh2Y3B1KSwgb3BfNjRfYml0LCBjcGwsIFZDUFVfUkVHU18jI3JldCkNCj4gPiArDQo+
ID4gICBpbnQga3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+
ID4gICANCj4gPiAgIGludCBrdm1fbW11X3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBncGFfdCBjcjJfb3JfZ3BhLCB1NjQgZXJyb3JfY29kZSwNCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gaW5kZXggZTA5ZGFhM2Ix
NTdjLi40MjVhMzAxOTExYTYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+
ID4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gQEAgLTk5OTgsMTAgKzk5OTgsMTAgQEAg
c3RhdGljIGludCBjb21wbGV0ZV9oeXBlcmNhbGxfZXhpdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
DQo+ID4gICAJcmV0dXJuIGt2bV9za2lwX2VtdWxhdGVkX2luc3RydWN0aW9uKHZjcHUpOw0KPiA+
ICAgfQ0KPiA+ICAgDQo+ID4gLXVuc2lnbmVkIGxvbmcgX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIG5yLA0KPiA+IC0JCQkJICAgICAg
dW5zaWduZWQgbG9uZyBhMCwgdW5zaWduZWQgbG9uZyBhMSwNCj4gPiAtCQkJCSAgICAgIHVuc2ln
bmVkIGxvbmcgYTIsIHVuc2lnbmVkIGxvbmcgYTMsDQo+ID4gLQkJCQkgICAgICBpbnQgb3BfNjRf
Yml0LCBpbnQgY3BsKQ0KPiA+ICtpbnQgX19fX2t2bV9lbXVsYXRlX2h5cGVyY2FsbChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgbnIsDQo+ID4gKwkJCSAgICAgIHVuc2lnbmVk
IGxvbmcgYTAsIHVuc2lnbmVkIGxvbmcgYTEsDQo+ID4gKwkJCSAgICAgIHVuc2lnbmVkIGxvbmcg
YTIsIHVuc2lnbmVkIGxvbmcgYTMsDQo+ID4gKwkJCSAgICAgIGludCBvcF82NF9iaXQsIGludCBj
cGwsIGludCByZXRfcmVnKQ0KPiA+ICAgew0KPiA+ICAgCXVuc2lnbmVkIGxvbmcgcmV0Ow0KPiA+
ICAgDQo+ID4gQEAgLTEwMDg2LDE1ICsxMDA4NiwxOCBAQCB1bnNpZ25lZCBsb25nIF9fa3ZtX2Vt
dWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgbG9uZyBuciwN
Cj4gPiAgIA0KPiA+ICAgb3V0Og0KPiA+ICAgCSsrdmNwdS0+c3RhdC5oeXBlcmNhbGxzOw0KPiA+
IC0JcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwlpZiAoIW9wXzY0X2JpdCkNCj4gPiArCQlyZXQg
PSAodTMyKXJldDsNCj4gPiArDQo+ID4gKwlrdm1fcmVnaXN0ZXJfd3JpdGVfcmF3KHZjcHUsIHJl
dF9yZWcsIHJldCk7DQo+ID4gKwlyZXR1cm4gMTsNCj4gPiAgIH0NCj4gPiAtRVhQT1JUX1NZTUJP
TF9HUEwoX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwpOw0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChf
X19fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKTsNCj4gPiAgIA0KPiA+ICAgaW50IGt2bV9lbXVsYXRl
X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICB7DQo+ID4gLQl1bnNpZ25l
ZCBsb25nIG5yLCBhMCwgYTEsIGEyLCBhMywgcmV0Ow0KPiA+IC0JaW50IG9wXzY0X2JpdDsNCj4g
PiAtCWludCBjcGw7DQo+ID4gKwlpbnQgcjsNCj4gPiAgIA0KPiA+ICAgCWlmIChrdm1feGVuX2h5
cGVyY2FsbF9lbmFibGVkKHZjcHUtPmt2bSkpDQo+ID4gICAJCXJldHVybiBrdm1feGVuX2h5cGVy
Y2FsbCh2Y3B1KTsNCj4gPiBAQCAtMTAxMDIsMjMgKzEwMTA1LDEyIEBAIGludCBrdm1fZW11bGF0
ZV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICAgCWlmIChrdm1faHZfaHlw
ZXJjYWxsX2VuYWJsZWQodmNwdSkpDQo+ID4gICAJCXJldHVybiBrdm1faHZfaHlwZXJjYWxsKHZj
cHUpOw0KPiA+ICAgDQo+ID4gLQluciA9IGt2bV9yYXhfcmVhZCh2Y3B1KTsNCj4gPiAtCWEwID0g
a3ZtX3JieF9yZWFkKHZjcHUpOw0KPiA+IC0JYTEgPSBrdm1fcmN4X3JlYWQodmNwdSk7DQo+ID4g
LQlhMiA9IGt2bV9yZHhfcmVhZCh2Y3B1KTsNCj4gPiAtCWEzID0ga3ZtX3JzaV9yZWFkKHZjcHUp
Ow0KPiA+IC0Jb3BfNjRfYml0ID0gaXNfNjRfYml0X2h5cGVyY2FsbCh2Y3B1KTsNCj4gPiAtCWNw
bCA9IGt2bV94ODZfY2FsbChnZXRfY3BsKSh2Y3B1KTsNCj4gPiAtDQo+ID4gLQlyZXQgPSBfX2t2
bV9lbXVsYXRlX2h5cGVyY2FsbCh2Y3B1LCBuciwgYTAsIGExLCBhMiwgYTMsIG9wXzY0X2JpdCwg
Y3BsKTsNCj4gPiAtCWlmIChuciA9PSBLVk1fSENfTUFQX0dQQV9SQU5HRSAmJiAhcmV0KQ0KPiA+
IC0JCS8qIE1BUF9HUEEgdG9zc2VzIHRoZSByZXF1ZXN0IHRvIHRoZSB1c2VyIHNwYWNlLiAqLw0K
PiA+ICsJciA9IF9fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHZjcHUsIHJheCwgcmJ4LCByY3gsIHJk
eCwgcnNpLA0KPiA+ICsJCQkJICAgIGlzXzY0X2JpdF9oeXBlcmNhbGwodmNwdSksDQo+ID4gKwkJ
CQkgICAga3ZtX3g4Nl9jYWxsKGdldF9jcGwpKHZjcHUpLCBSQVgpOw0KPiBOb3csIHRoZSByZWdp
c3RlciBmb3IgcmV0dXJuIGNvZGUgb2YgdGhlIGh5cGVyY2FsbCBjYW4gYmUgc3BlY2lmaWVkLg0K
PiBCdXQgaW7CoCBfX19fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKCksIHRoZSBjb21wbGV0ZV91c2Vy
c3BhY2VfaW8gY2FsbGJhY2sNCj4gaXMgaGFyZGNvZGVkIHRvIGNvbXBsZXRlX2h5cGVyY2FsbF9l
eGl0KCksIHdoaWNoIGFsd2F5cyBzZXQgcmV0dXJuIGNvZGUNCj4gdG8gUkFYLg0KPiANCj4gV2Ug
Y2FuIGFsbG93IHRoZSBjYWxsZXIgdG8gcGFzcyBpbiB0aGUgY3VpIGNhbGxiYWNrLCBvciBhc3Np
Z24gZGlmZmVyZW50DQo+IHZlcnNpb24gYWNjb3JkaW5nIHRvIHRoZSBpbnB1dCAncmV0X3JlZycu
wqAgU28gdGhhdCBkaWZmZXJlbnQgY2FsbGVycyBjYW4gdXNlDQo+IGRpZmZlcmVudCBjdWkgY2Fs
bGJhY2tzLsKgIEUuZy4sIFREWCBuZWVkcyB0byBzZXQgcmV0dXJuIGNvZGUgdG8gUjEwIGluIGN1
aQ0KPiBjYWxsYmFjay4NCj4gDQo+IEhvdyBhYm91dDoNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaA0KPiBpbmRleCBkYmE3OGYyMmFiMjcuLjBmYmE5ODY4NWY0MiAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oDQo+IEBAIC0yMjI2LDEzICsyMjI2LDE1IEBAIHN0YXRpYyBpbmxpbmUg
dm9pZCBrdm1fY2xlYXJfYXBpY3ZfaW5oaWJpdChzdHJ1Y3Qga3ZtICprdm0sDQo+ICDCoGludCBf
X19fa3ZtX2VtdWxhdGVfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQg
bG9uZyBuciwNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBhMCwgdW5zaWduZWQgbG9uZyBhMSwNCj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dW5zaWduZWQgbG9uZyBhMiwgdW5zaWduZWQgbG9uZyBhMywNCj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBvcF82NF9iaXQsIGlu
dCBjcGwsIGludCByZXRfcmVnKTsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBvcF82NF9iaXQsIGludCBjcGwsIGludCByZXRf
cmVnLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaW50ICgqY3VpKShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpKTsNCj4gDQoNCkRvZXMg
YmVsb3cgKGluY3JlbWVudGFsIGRpZmYgYmFzZWQgb24gU2VhbidzKSB3b3JrPw0KDQpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQppbmRleCA3MzRk
YWMwNzk0NTMuLjUxMzFhZjk3OTY4ZCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0K
KysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQpAQCAtMTAwNzUsNyArMTAwNzUsNiBAQCBpbnQgX19f
X2t2bV9lbXVsYXRlX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQp1bnNpZ25lZCBs
b25nIG5yLA0KICAgICAgICAgICAgICAgICAgICAgICAgdmNwdS0+cnVuLT5oeXBlcmNhbGwuZmxh
Z3MgfD0NCktWTV9FWElUX0hZUEVSQ0FMTF9MT05HX01PREU7DQogDQogICAgICAgICAgICAgICAg
V0FSTl9PTl9PTkNFKHZjcHUtPnJ1bi0+aHlwZXJjYWxsLmZsYWdzICYNCktWTV9FWElUX0hZUEVS
Q0FMTF9NQlopOw0KLSAgICAgICAgICAgICAgIHZjcHUtPmFyY2guY29tcGxldGVfdXNlcnNwYWNl
X2lvID0gY29tcGxldGVfaHlwZXJjYWxsX2V4aXQ7DQogICAgICAgICAgICAgICAgLyogc3RhdCBp
cyBpbmNyZW1lbnRlZCBvbiBjb21wbGV0aW9uLiAqLw0KICAgICAgICAgICAgICAgIHJldHVybiAw
Ow0KICAgICAgICB9DQpAQCAtMTAxMDgsOCArMTAxMDcsMTEgQEAgaW50IGt2bV9lbXVsYXRlX2h5
cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogICAgICAgIHIgPSBfX2t2bV9lbXVsYXRl
X2h5cGVyY2FsbCh2Y3B1LCByYXgsIHJieCwgcmN4LCByZHgsIHJzaSwNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGlzXzY0X2JpdF9oeXBlcmNhbGwodmNwdSksDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBrdm1feDg2X2NhbGwoZ2V0X2NwbCkodmNwdSks
IFJBWCk7DQotICAgICAgIGlmIChyIDw9IDApDQorICAgICAgIGlmIChyIDw9IDApIHsNCisgICAg
ICAgICAgICAgICBpZiAoIXIpDQorICAgICAgICAgICAgICAgICAgICAgICB2Y3B1LT5hcmNoLmNv
bXBsZXRlX3VzZXJzcGFjZV9pbyA9DQpjb21wbGV0ZV9oeXBlcmNhbGxfZXhpdDsNCiAgICAgICAg
ICAgICAgICByZXR1cm4gMDsNCisgICAgICAgfQ0KIA0KICAgICAgICByZXR1cm4ga3ZtX3NraXBf
ZW11bGF0ZWRfaW5zdHJ1Y3Rpb24odmNwdSk7DQogfQ0KDQo=

