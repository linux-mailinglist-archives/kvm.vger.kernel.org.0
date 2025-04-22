Return-Path: <kvm+bounces-43843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC92A97437
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 20:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFE5017FEC6
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00002980AB;
	Tue, 22 Apr 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mk8zA6hL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0538C202F8F;
	Tue, 22 Apr 2025 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745345166; cv=fail; b=DenaifOc2bM3zFdDu9zA9/LE3mQc17bLBSTKnzZ8ohK1SfOsdYrqSr2nM2yAXCmNjPN3srpbdQdpO7T82apnXH1TzbSLyZ2oT6E+Cg18VykMeS/GJyNt2aaBgJlhI3+6iXJ2O36P8OsUnJIA0kPzbjOpsX3iVz+Ot0IycsMgHAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745345166; c=relaxed/simple;
	bh=fmAdz9mZqTCN037YSzugE3/GeiNS0t4uIgkiQsljs1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nQjySWtxdFBl4eAkk0VYA2fj6XTACzXiUwUECAN1a0Js3Nq6J4XuWmSZiZnXRn1F8T3NwpwnH/rKrjX02cfTpXGbXQL1tVT6PrBDDPE2sgLejO5+bYvJx3I9I4MFE/72lu8xW/Ty073msvs7eFAPLv3jcSNRtgUlLm+SQ6sc770=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mk8zA6hL; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745345154; x=1776881154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fmAdz9mZqTCN037YSzugE3/GeiNS0t4uIgkiQsljs1Q=;
  b=mk8zA6hLHeaEMQayYe8LouJRSvLwZ0HIV8h32KpehFJfBUUw3eqzYjnT
   6FvLMVpjSDXKNSOT1PyoITXQgURVATFtm7GaEKicatWLUEy8Dzkl+I5PC
   w/Bi1ZpxDRuRIUbaHQux4ps3NcZHReLXmqs5PyMIWnoGKnhSxrexE8hwU
   CVlWCafvQlITzMZFsc9Zgh56OzoLf6mU3Jr4wi1LOj1lkNId+f03jTbK5
   2CNGpJILfEV9MV+gnnnYWrxjPGq1gf4LZa1QQBk5ohrFNkajiSRv+FJJL
   gZnlh6i3NpeHVdStgAIUv4Pfg2U+bePYXqj1KZWJkN44ptTSDk6+B2/Lo
   A==;
X-CSE-ConnectionGUID: sEQ+9MNgQwmzhXpuhfJ9ug==
X-CSE-MsgGUID: a9x9uSlCQn68jm11RcuNUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="49584036"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="49584036"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:05:52 -0700
X-CSE-ConnectionGUID: tg6rkUyDRWGhawluYDiHHA==
X-CSE-MsgGUID: bPODpd7jQKGtpFn08n+9WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="131933484"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:05:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 11:05:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 11:05:48 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 11:05:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrHKsvfnU9PUH7UuFFBAKds2RzsV7AJtfFBIgcEHljyS/04NTJlXSfs1U4QEfP4p2UBn/65rrCem1wuwjh5a10IvLD+HlPqPtlQu1aHUaiNBdBXOMQ8do2djyaQbrLqVsYWAcYvBNjkLmJIewyRoRDpE0W2+1gDIrsWSxynsbOHCIutE195AvDOCNgf3C7wfX4Jmd1tLsnev+BgEWwY1m7QdekK0cGhFYR4eBXp+rj3bYVBmuec4ToG1dWWGleI+GJLFeirEn2qc4ypwnIO5Y36qj81jCaS4Yv/hpDdysfYVa42Jugu0iovV1jezh3S7vWyY+TOV5tKfa3Hv/j1W+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmAdz9mZqTCN037YSzugE3/GeiNS0t4uIgkiQsljs1Q=;
 b=fhJIc0H1dxS2IisbW9T7TGDVhr/UJ2sshViBlOTx65nUbwyZWNacgD5Nb4WeDhCd/zrrltjKdLXMcm1gykMjncsDef796sR17kBzBUFlh/8XxlyXF2vRUvj0noF6RoyCoBiSRPoYNsWNbCnX5iOtWM4/FEtg/I6er3Op9zqMuvXL2tm0efuKteh2vCyWUTCBlYjhu7e6YSZR2c9sA3if1NScfM18AUbky26n0Zp+ZQrdkxsl/OhVfpJ5Pq6GvvhchNU+zJ8O+CMW7kwLWYptsvIl06bmzacFcROtXGUgXFyfRXJwqdjlxXQLWBMwOEOdsP6JAkEagnxUimNx4aM91g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.35; Tue, 22 Apr 2025 18:05:42 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec%6]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 18:05:42 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "acme@kernel.org"
	<acme@kernel.org>, "jgross@suse.com" <jgross@suse.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "namhyung@kernel.org"
	<namhyung@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "irogers@google.com"
	<irogers@google.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kan.liang@linux.intel.com" <kan.liang@linux.intel.com>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, "ajay.kaher@broadcom.com" <ajay.kaher@broadcom.com>,
	"bcm-kernel-feedback-list@broadcom.com"
	<bcm-kernel-feedback-list@broadcom.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"luto@kernel.org" <luto@kernel.org>, "Ostrovsky, Boris"
	<boris.ostrovsky@oracle.com>, "kys@microsoft.com" <kys@microsoft.com>,
	"haiyangz@microsoft.com" <haiyangz@microsoft.com>, "Cui, Dexuan"
	<decui@microsoft.com>
Subject: RE: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions
 support
Thread-Topic: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions
 support
Thread-Index: AQHbs1/RMUZdzVvoTE+K/82snKlUebOvyIiAgAAvBoCAAAKQYA==
Date: Tue, 22 Apr 2025 18:05:41 +0000
Message-ID: <DS7PR11MB6077B4D80EB7020C4D3FCD52FCBB2@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <20250422082216.1954310-1-xin@zytor.com>
 <aAevpauKYWwObsB7@google.com>
 <cb4e24a0-fdb7-46d2-9b0e-200f5e3e4c96@zytor.com>
In-Reply-To: <cb4e24a0-fdb7-46d2-9b0e-200f5e3e4c96@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|MN0PR11MB6088:EE_
x-ms-office365-filtering-correlation-id: 763d126e-1844-418b-2adc-08dd81c84bbf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NVNMRjdwSjlnNjNrb0syeUVacnkrQVlBeXk1QUhFbjd5clhnSG1seHcvak84?=
 =?utf-8?B?aCsranpwNG5xRytsMThCTDhETUtXb1J3RmdzV1laQk0rWVBFQ1hENHN2cThM?=
 =?utf-8?B?Y0doa1ArMFNKc1J1SkZmV0sxVFRzTlB0NkQzM0QvTlE2RzlXajJNWlRYeGQ0?=
 =?utf-8?B?MXBYVUpyZXYra0V0Z084RDhPQk9rUUlqK1ZlS1VIc0g4TjlkYWJFUmNINStF?=
 =?utf-8?B?SllvaHNDOWRwNjkvck5HNzN3NmxIOHlmYlNESjk2ays2RG5OYmhWL1BNWmFu?=
 =?utf-8?B?YTA0QnMyNmhKRVhFUkwzU1ExSHZTNGpCOXRsZlBzWEdISmhqVWFRWlRWTW5q?=
 =?utf-8?B?RmhKemlWOUs1cGU2QThORDEvR1g3NnQ2Z0NWMXBpTzh6bVhDcExWS0k0MVVO?=
 =?utf-8?B?N0VoSExXSW04SlovY2dvT2lkVHlWejAwWGR3NzFYSVZYZUdnQ2lreS9aYnpF?=
 =?utf-8?B?cTBaeFBjT2xtNXZwcGIzbXNwWEF5dW04ZjhudDFnK1JWb29RbzNYeVpySzVP?=
 =?utf-8?B?YmRDRGJKSGJsQXJZTG5UNkx6cEZicGpnUnhkZi9mTGZGZEVoSDJVRjFNYmo2?=
 =?utf-8?B?RVB0dklvM1NOM2dBN2dEYWQwUXFpa0dOWHBCbFFhWndKaWhRRm9helFlR3dm?=
 =?utf-8?B?UnpnS3dwSUphbFBiUHhOVlJxWER5TUFmWU5NZENpVnJJdURrSEZ4b21vejl1?=
 =?utf-8?B?b0c0T1ZIU0xseTIyTzBEaGJobEJ2Y2JvT2EyN0xtdUY5VzdnZVlmM2QySkFt?=
 =?utf-8?B?Ukg2UWNGcHNsbVJ2d2RkK0tPR01YSHZoWVo4MENNZlhlbjNhVDhldkVMZTZQ?=
 =?utf-8?B?U2J4Q29HWmVKZG9xV2R4eE1FQ0hBelkxTk52d2wxMTBVSVVqeWRxaFV0Zmdt?=
 =?utf-8?B?RDM0c0U3QkpOMW5LTm5tNzdiNzdaUU93YWJsTUxKUU41TE1Za3M2WDZxS3F4?=
 =?utf-8?B?UERaYktoODdEMTdwUWJUTFp4OHZWVHVDTHVSZDFxUHliM21pWlN0NVhCYTRk?=
 =?utf-8?B?aEVmMDQ1elBMSUxUK0VDaGZSb28rN0lRYjZBTmtjLy9lMlo5NC82dXRhK1FJ?=
 =?utf-8?B?b3VjVkpUOVg2cnZjY1ZHc3Y0bElSdHM5OHZhRVBJM2psdjdZQnZidjFtM3hL?=
 =?utf-8?B?T09Na3FnVnFiMkVZbHdRbndWdTlvRExxMlNSQ2drSnNjM0JiSnVDNkVUZWNT?=
 =?utf-8?B?TFZzTFpKSk5aSGl4a25JZkdXRE4vK09WVmNNdHZtRjRKTHpGNUVLOTc2ZEVT?=
 =?utf-8?B?NTRFTG8vUW5VbVpFT3BMb0lNeXRoSWozK2YzU0NsdFowdmlaY3Zkcythb1Zr?=
 =?utf-8?B?Rmh0Vk5CdnFCeE82aXlqbDVPdDlUWjZLQ09oVkt2UDdibzlySDRYbkgrbmEx?=
 =?utf-8?B?MW9RQVBTdVpNb003VEx1KzBGRTU3RmRFVDVKTnV1bEViLzA5bmFsazZGRWJE?=
 =?utf-8?B?YW9EQUdkK05yR0poTlZLam04QklTU0tFOVVzRnRTODdVOHVYMU1vUlRscDZs?=
 =?utf-8?B?MUlRZEJZWGpRNTZsQ0wyQUp6eUNlNzRLbHh3UHlGMG9aNTRXRHlEVGp1a09v?=
 =?utf-8?B?TFdMeHRJMXo2bVFidldMVW9jRnhOanZ0UHAxRUZVL3dlVlExYWt1dkswVVlB?=
 =?utf-8?B?cmFMQjAxSXBsT0NzNFZGMktKbktSbVpaR3FSSmpTbFpEbW9FYlR3VGtiYnh1?=
 =?utf-8?B?OWtIWldDKytBQ0F2MlZjUVlHbFFGYUdLUy8wQUVsb3pCYmRHeGFHeDlYR1F5?=
 =?utf-8?B?eUFqMlFmdHd0K0plRGVid2p0TEZibUsvUFNpNkVtMTN2REFzN2Yza2hQbWFo?=
 =?utf-8?B?U3lETmVSZVpPZnFlRTVCK3M4eFlaY1dKUFVmQm55ZDJyTjhyUC9CSGowL3k4?=
 =?utf-8?B?dzYxdk4xTzJGcUVkNUJ6N1FhbTNPNndBcGhKV09YNmllTGYwcnVwSElUQmVG?=
 =?utf-8?B?MVYxVXNjR0VremVYUU9ESDBZeFZPNFpwQ1VSRFYyY2Z5Ni9NdUVWQzdSdkZB?=
 =?utf-8?B?R2N0amk3L2J3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDU0SnMzZmhUZXFhY2NTc3FLUkJFS0c0RXZNQURGU2FWN1JXS3F1b1FGelNU?=
 =?utf-8?B?S3pHQXZBRmhZVEJJR2tSTzlMZTlncFNaOVNGUjFPTmV5bHJubVMxZmVsdncr?=
 =?utf-8?B?cGdIWWRHZldSU29FVzg0dzBLQlpMVFBaTjFranN3bmVMalFWVno2SUVaTXpI?=
 =?utf-8?B?blQ4aTJrbVVqTXNRSXhweFpDUHpqMnB5SmxkNWZkV1o1YWNxVlRSTEpzckEr?=
 =?utf-8?B?YzdFZ0d1VE5tWGJRS0NyZE1XVXNFR3lqUktPeEVQbWl5UE4rT083czBGM21s?=
 =?utf-8?B?b0dJT1RGMjVyYXRxVGNGNFh4STYwZTExSjhYVE5Jb2FGZHdYYmlZKzZXc01S?=
 =?utf-8?B?T2dUczlnUFZvRXozRFV4QjB2WUxSYzZhUnI0ckt0QXQrU1lRekdaSE5tTzU0?=
 =?utf-8?B?eVBxd29MelRFR3hXYkl6bGhCWm0vbzZDSzNxRTBVZVVZSEFOZ0ZkRjM2Q2E4?=
 =?utf-8?B?akR2dGpjbDd5MXp6UVd2bmhIblc4NUwwZ0kreGRkVWgxcXNCV1N4SUp3KytM?=
 =?utf-8?B?eU9EY1lrR0d1aGhadjkvQm5BSFMydVBJb3ZBMTJlalJ6S29iVHhVTjc0NzYz?=
 =?utf-8?B?S1NGRnBQR3dTbGpIUVpHc1JpZUJneFVQdDBneit1T3NMaklSY0I0cVBmM3VS?=
 =?utf-8?B?b3VuTVBCUkxXbTNKTHJGS0hBSUdBTTdpV0dLNlM2a1JBajdHZUlDcjQ2eEZG?=
 =?utf-8?B?cnBkWFliR0RNVy9iVnVERVRYeW9MZS9vd3BFVHlPUW1MYm56a0JqeXc0OXYw?=
 =?utf-8?B?UXFJL3c4WXpObDNvVDBPOGQ0N2tnTmVOUHB0R3l3VTlJY29OL0w4SjQ1TFZR?=
 =?utf-8?B?cWV6bW1HRFYwYlYxVnlROTV6YUYwcEJzaER0djV2M1V0ZUZFSVJPa2ozMjhn?=
 =?utf-8?B?Sm1JTzBuMHZmWkpvdERQcEJDVFNGUm1DZWVKcWc2dUtUdDJkaWFualMzVlhX?=
 =?utf-8?B?S0tEb0ZtTlJmblVXNk5vT3ZXRnhIampneU1uUzN5TE0wMTF3NGJLc3JXYzZ1?=
 =?utf-8?B?Qm1tRGo0WXQwNU91bkwySzhFUXRvY2lieTBzMzFvZnEzeVNPdnpxLzRDY1dy?=
 =?utf-8?B?SmhIQzV1MU1udDhXb2pEZkhQUGxKanN1dXZEQ1pYeEM5eHpRMUhNZk1HYjcw?=
 =?utf-8?B?bTc2ZmN5VGJuRW8yQWlVUkNvT1RySDdlVEVRRnB2ZHJVaklCclZyODIyOU0x?=
 =?utf-8?B?L3paU0crNDc1Ym5mYmZxVkhmNjU4NlhQRnQzQVU3MWw4a09UT1QxN2NmZkU4?=
 =?utf-8?B?TXp2cm1aeSt1U1VPaWhoS3lrNFlRTEJKMDl0ZHlaVWJmLzhaQWRBWTQ2VGxT?=
 =?utf-8?B?L3VBNzMvNS85VnpxR2V1QVlkSzdIelo3TUtFL3cvVFhVU0UwM3JkOW1LNjdp?=
 =?utf-8?B?Nng4SXFSWDJzbFFRK0JhS2NOWkFydGZMeUNvbWNDZUZsZmFMTmFKOTVSNEtv?=
 =?utf-8?B?Sk02VHJ6UjU0YWdLNWx4TTdORmZ6ZHNGb21XOTlzNXVyQjdGcjhRUThHaGx4?=
 =?utf-8?B?dm1xR3h4QXhKaUQ0dzdPay9LR0FOWkE0dEtYM1NBWGNyUFpRWnpjRGZ5Z0ox?=
 =?utf-8?B?M1ZqRTZvSkgyNk4vM2YvNllJZndSZjFzcWxCWFVtbDBCTXozUFdqQVptYzIx?=
 =?utf-8?B?TC81M1k2enEvVE1vbEtJbVNNanVRTWJmazBBK0l3ZDhxaTVwK2w5dTV5eFEv?=
 =?utf-8?B?VDI4UmdSQjZQWktBUW5EckcxZTMvSnJsZzNtY1pPbW0wTEhnUGlFV0RRWTJr?=
 =?utf-8?B?ZDNvbnBWQnNYVU5jNTdaSitHZ1B5YnlMNC9KbWNJdm9IS0c4MzRPcVJWOXBG?=
 =?utf-8?B?ZzVkOVVPaEtqNU5IbGxEeVRFTXd2TE84UGl1Tkw0TGorWWRWSHpBR1pNeGZm?=
 =?utf-8?B?V2FISEgzQ0RkejZ4eFE2dGE1aVRsVG9BNUVjTXNFdUdCY1hQVTRPSi9MNjVM?=
 =?utf-8?B?R3NiUHoxc2JyQ1BDSmg1ekQ2V1FKYlFIZy9GOGlOdWFFMldJbDh3SnlXeTE1?=
 =?utf-8?B?M3FpWHlNZllsNmxtWXhtdDY0K0NHbXNuNHhKVmRMeFJaVWNCWkIzemdRbUlm?=
 =?utf-8?B?YS9ST2pNcUR5TG12QlJaUEtyTTRhTThjTjh1TWcwYzJXN01ibVNGMUtNNDlw?=
 =?utf-8?Q?FVrmRNZ2LQl0HyAqX6qEXK1RN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 763d126e-1844-418b-2adc-08dd81c84bbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 18:05:42.0035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aUKkLnmD8IKryCluzdAkPymTPTebGJmXNuuTWarOq92+NwQOOsEDuxXO+aI6KHoa6UnYiM7Pm8RVOlXH9MOLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

PiA+PiBiYXNlLWNvbW1pdDogZjMwYTBjMGQyYjA4YjM1NWMwMTM5MjUzOGRlOGZjODcyMzg3Y2Iy
Yg0KPiA+DQo+ID4gVGhpcyBjb21taXQgZG9lc24ndCBleGlzdCBpbiBMaW51cycgdHJlZSBvciB0
aGUgdGlwIHRyZWUsIGFuZCB0aGUgc2VyaWVzIGRvZXNuJ3QNCj4gPiBhcHBseSBjbGVhbmx5IG9u
IGFueSBvZiB0aGUgIm9idmlvdXMiIGNob2ljZXMuICBSZXZpZXdpbmcgYSAzNCBwYXRjaGVzIHNl
cmllcw0KPiA+IHdpdGhvdXQgYmVpbmcgYWJsZSB0byBhcHBseSBpdCBpcyBhIHdlZSBiaXQgZGlm
ZmljdWx0Li4uDQo+ID4NCj4NCj4gJCBnaXQgc2hvdyBmMzBhMGMwZDJiMDhiMzU1YzAxMzkyNTM4
ZGU4ZmM4NzIzODdjYjJiDQo+IGNvbW1pdCBmMzBhMGMwZDJiMDhiMzU1YzAxMzkyNTM4ZGU4ZmM4
NzIzODdjYjJiDQo+IE1lcmdlOiA0OWI1MTdlNjhjZjcgZTM5NmRkODUxNzJjDQo+IEF1dGhvcjog
SW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+DQo+IERhdGU6ICAgVHVlIEFwciAyMiAwODoz
NzozMiAyMDI1ICswMjAwDQo+DQo+ICAgICAgTWVyZ2UgYnJhbmNoIGludG8gdGlwL21hc3Rlcjog
J3g4Ni9zZXYnDQo+DQo+ICAgICAgICMgTmV3IGNvbW1pdHMgaW4geDg2L3NldjoNCj4gICAgICAg
ICAgZTM5NmRkODUxNzJjICgieDg2L3NldjogUmVnaXN0ZXIgdHBtLXN2c20gcGxhdGZvcm0gZGV2
aWNlIikNCj4gICAgICAgICAgOTNiN2M2YjNjZTkxICgidHBtOiBBZGQgU05QIFNWU00gdlRQTSBk
cml2ZXIiKQ0KPiAgICAgICAgICBiMjg0OWIwNzIzNjYgKCJzdnNtOiBBZGQgaGVhZGVyIHdpdGgg
U1ZTTV9WVFBNX0NNRCBoZWxwZXJzIikNCj4gICAgICAgICAgNzcwZGU2NzhiYzI4ICgieDg2L3Nl
djogQWRkIFNWU00gdlRQTSBwcm9iZS9zZW5kX2NvbW1hbmQNCj4gZnVuY3Rpb25zIikNCj4NCj4g
ICAgICBTaWduZWQtb2ZmLWJ5OiBJbmdvIE1vbG5hciA8bWluZ29Aa2VybmVsLm9yZz4NCj4NCj4N
Cj4gWW91IHByb2JhYmx5IG5lZWQgdG8gZ2l0IHB1bGwgZnJvbSB0aGUgdGlwIHRyZWUgOi0pDQoN
CklmIHBvc3NpYmxlLCB5b3Ugc2hvdWxkIGF2b2lkIGJhc2luZyBhIHNlcmllcyBvbiB0aXAvbWFz
dGVyIGFzIGl0IGdldHMgcmVjcmVhdGVkDQpmcmVxdWVudGx5IGJ5IG1lcmdpbmcgYWxsIHRoZSB0
b3BpYyBicmFuY2hlcy4gVGhlIFNIQTEgaXMgaGVyZSB0b2RheSwgZ29uZQ0KdG9tb3Jyb3cuDQoN
CklmIHlvdXIgY2hhbmdlcyBvbmx5IGRlcGVuZCBvbiBvbmUgVElQIHRvcGljIGJyYW5jaCwgYmFz
ZSBvbiB0aGF0IGFuZCBtZW50aW9uDQppbiB0aGUgY292ZXIgbGV0dGVyIChhcyB3ZWxsIGFzIHRo
ZSBTSEExIHN1cHBsaWVkIGZyb20gZ2l0IGZvcm1hdC1wYXRjaGVzIC0tYmFzZT14eHgpLg0KDQpJ
ZiB5b3UgZG8gZGVwZW5kIG9uIG11bHRpcGxlIHRpcCB0b3BpYyBicmFuY2hlcywgdGhlbiBtYXli
ZSB0aXAvbWFzdGVyIGlzIHlvdXINCm9ubHkgaG9wZS4gQnV0IGluIHRoYXQgY2FzZSBjb3ZlciBs
ZXR0ZXIgc2hvdWxkIHNheSAidGlwL21hc3RlciBhcyBvZiB5eXktbW0tZGQuDQoNCi1Ub255DQo=

