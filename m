Return-Path: <kvm+bounces-26315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDB5973D80
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83C4E1F28114
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5021A2851;
	Tue, 10 Sep 2024 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VTCft29k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91A1A256A;
	Tue, 10 Sep 2024 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725986381; cv=fail; b=NweahbF9Ej8YcEuarJMICk2aY/jF7lhMo/3odS6SI2lxsggfLgMBmLZQz9b8KWr1TmTx773lBBGq1c8N9JuGBoatq11k8HGHzxIcN3pB0L5ZLGH7YZ6s/JTebKe/cBGwPOAH/wAlFUFKUGhTV/Te4zgMUCJskrETTfeMkYXMptk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725986381; c=relaxed/simple;
	bh=dpZib7+AHlyMUn2t23qcqa7Ym8J5e4oPjhReL+wrfEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nWq0sSTQMGD30FsPNDYz3KeXYA8Aud0KVsLKEFvjvKelcD/H/6AwQ9y0StbJeNjzc8tq2jc+vokFmWOPWGntm58aPsl171312cT86HVTde0MucIsurjzZP84tY09mKJ9mmqmco+jYqhRK647LznQdMFAUPLsNLAij8lGvVtNpH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VTCft29k; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725986379; x=1757522379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dpZib7+AHlyMUn2t23qcqa7Ym8J5e4oPjhReL+wrfEA=;
  b=VTCft29ksy3WHfYnPqqkMUHU7AsO5uhqNqHz2qTkJpRndKZ0Pcmp3e8R
   +CSQ654Mj6gYEFCq4MOxK1P0HrCGxxVE7skSymVZ9knjhDq4CMjm7pKF5
   Fe6DLSJzBE7jPptEH0KFqpmy4FbqWrhn+/I1EUZOe+a0/O9kmeE6EiNfR
   PBNwVsvGZPyWnW7d1g10iFdglECBiRcOvsFNiqqlTu4nR+Q6Ybfi6LTBG
   Y709FnFnW8BaulRMZ3ePcMeudpGojNyLH+DA3QTs3qbPZsuypbxyZMJN9
   op1FeKNmH0XdPfkCS0JI0EV0CI/GDY1BEuOaDrgrC0p3Tlq+O1++uZ+KI
   Q==;
X-CSE-ConnectionGUID: j80FUbTSQ0+tS6fXZm7B/g==
X-CSE-MsgGUID: 4Da3S/z7TMGsOjDNW/lgmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="47267795"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="47267795"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 09:39:36 -0700
X-CSE-ConnectionGUID: cAd8EAQtTWe6XsJeyGxhkg==
X-CSE-MsgGUID: QSw6gJMmRt+egRQ30l41Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="71471924"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 09:39:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 09:39:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 09:39:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 09:39:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=di9TdRWo0BMygU5QlvRJUYJY+bwBIIWcrI7ViVZd3y2SeEuO+Uo9a4jjGz2gRG9Iqoq36a4eaG8CPec74wWuhlnXyz4zA2/TvAE53asdgMShFdWWGLqMhpuo33LSyV/Y3mQkEMFbvXcZ0ikzkfz4J7uHOvSyKKWeq05k76odF7XEYjE3bJ7pBLFA61EvGHjNkKL6kRKeH6W1b3TYFbWTjer00iVKUFtwLVIK1VdDy304qEr84KgeARj8bwXhozgjf1WkK9XBFlEGUbiirbUMFk5pQ3K3faiaVmvN8sBgR66ihepmPg0K5SFl/nnPPkMfCYhwsZ4zD6RZh7iGnUsmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpZib7+AHlyMUn2t23qcqa7Ym8J5e4oPjhReL+wrfEA=;
 b=hoKTqHf3XnIHK2Q258JF/NDV01MKNFksWYzt+k7PdWH1WX/vcEuc7Il1FBmK14QEiR7Uc6JjGAgbw/ZNI7YkDLNd1JTQD7Co3fAdVoYsjVUOuSpFGoieSoKBGvFMa5Oqu6w+GeQXytlhpcWiQhyeEzK8oBqSY+i6fnH59r0RO+AW29rQgI24oGR6KUMPcgjX5g6ouGzp/9vSNVo8aKBTFVO+f35aXazp+QWg8O/mib9YpKruZtJLKovffNxhufZ4Iu3QIDE5trsxwjETceGsop2qwzcdmQ54P7TiAw2clmx+RVoKgBMw6ujGJoMs79UJD2OxlNmNPxg+F5BYDKOMZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Tue, 10 Sep
 2024 16:39:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 16:39:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free TDX
 private host key id
Thread-Topic: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free
 TDX private host key id
Thread-Index: AQHa7QnMV1ngoQ2e1UOkx4byFOQuTbJRYnsAgAADdQA=
Date: Tue, 10 Sep 2024 16:39:31 +0000
Message-ID: <e5dd31c924e8be70d817fe71e69d40053ae7f15a.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-8-rick.p.edgecombe@intel.com>
	 <661e790f-7ed8-46ce-9f7c-9776de7127a8@redhat.com>
In-Reply-To: <661e790f-7ed8-46ce-9f7c-9776de7127a8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ1PR11MB6129:EE_
x-ms-office365-filtering-correlation-id: e2283aac-cbae-4ee5-03a0-08dcd1b7255d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Wkgrb2hRenhlMXBLYVZQWkxBMW44NkM1cWpoNlRhY2RRR2lQNTY5czFIeGl1?=
 =?utf-8?B?b08ySzZLdEdxRXZJdkJDamtqME9zOWxpNVVrVnp5YmNSMWpZb3M0N3dsVEQ0?=
 =?utf-8?B?em5pL1NWdkpuQkFsZUllTXdtV0tsNndYblEyVmVFNkQzMzVyUVRKcVlPbCtz?=
 =?utf-8?B?bk1KVzI1VmhDTTB5bUppeWJzK0dXblhGcTM2bEhZUWxLRXRtMEp6bzZGbGtN?=
 =?utf-8?B?WE1STHA0amtTRlFpU1FYSXFKZmZMSExtSDg5Tm11SlRqT2g2M05LZWNpUzdF?=
 =?utf-8?B?S1NsbGJLWWE5MDg2ZUtnRy9Gc3B4Q3I3UE1XUnRhekJsQUp0eEE4dXdqSHE3?=
 =?utf-8?B?UWM4cnRlVmdJRlVyeWY5cDdMc01rRjV5R29Wc3hJb1RuZVpDeDUvOTlpNU82?=
 =?utf-8?B?RFBJVnB0QUpjeWprMlVIaTMvcGZ3alRTbjVySWtPRm5VMXNlSFUzTmMyZEpY?=
 =?utf-8?B?MnpmOHhuRlB6bXlPd2NtclNwNGJIUkZUb2ZRY3hYejRRejZrcDhyM3R5RTl2?=
 =?utf-8?B?NEdyNVl6Y2J0emdPNm0rRlhFVUtOZ1NXZUNudDNUamp6cndKSm1UMHdtYlNO?=
 =?utf-8?B?dktadk4ycmRJY3pOeWdKZHZCc1g3NWpqQmxyZk5sTWtsNkt6ckFWQmlURWdD?=
 =?utf-8?B?QWZ5MmM3QlF0R3R5UkZWTWpReXNYZ1p3U0RsV2YyU3daQ0d4QUZTMU5zL3Iw?=
 =?utf-8?B?bVg1am1iaXFMa0Zpc25qY1g5SlR3QUVhanRwMHVPUnFYYXp2REVaRXgwN0ht?=
 =?utf-8?B?aTRvOUllSFZpM2t6dDIzMWUwcVpiS2lJVFpvWE5IK0FObVVpSS9hdmlSbWIx?=
 =?utf-8?B?Mi9Nc0Y3bDRqVFBMN3VROFQ1Y2xtcjE5QlJsYzV4c0lkZHNpTzJKcjhvWjNP?=
 =?utf-8?B?Y0xzeXBHQnp3UElyTWV3SVN0TXJsa2srYjRqSzRDcHJzL2JoZFVrcG5SZkRr?=
 =?utf-8?B?Z0NUU2cyTFJLeGgwbE9RYUs4U1BnOFZWMS82RzBjaUluSkFOVDRwSUJHVHhr?=
 =?utf-8?B?ckhoeU5IWVp6TUNIRnhZbmw3YWU5a2oxUzFRKzVvOGwzb01wSnJYb2Vsc1Jy?=
 =?utf-8?B?UkRpMnNPakoveXA3Rkh2Z3NlR1NmUGdjYUk1RDNDTGRETGxFUU5Pd1F1U3pu?=
 =?utf-8?B?am9xcGZCbWVHRm5qMHdmR1liY0ZVYmlaYWk5L3YxYnp1RWtCREN5WHUvSlIy?=
 =?utf-8?B?UG1aTThlYjdoWHZNNHJZenlPdzJ1clc3Y0pDeWpPOXNtNVRTZU45SUx5NmJK?=
 =?utf-8?B?M0syU1NYUjhmM0J0STQ1K1pzOWR2WnN5dGNZK1FwanZqeUlvakJKQjdvdVlR?=
 =?utf-8?B?UHg1QXpwNXBkMzVhanV4clUyYTdUaC9IU2VOdm5Jam11R3ZNOVdaWXIzd2xn?=
 =?utf-8?B?WitXV3VBc25aNUVFQ2JOM2g1ZXdleUhaUTdFQ3NKQ0tlbjRkVTZLZ3Z3U0ho?=
 =?utf-8?B?Zng4N0lZczVodG96aFhXbFVUWE4zdWFCazA4Qk9FdENIeUdZdFN6M2N0WEVu?=
 =?utf-8?B?RzlGakdqTVkwaFJSYzBDRk82aEFvTDJ2bTdadCtVSlhvd0hnTXFKVDk1ZEJq?=
 =?utf-8?B?aWNTcGxOaGEwUHZQL2tNM1R1SmoxUEdqSXh0OGRERmlsZlhCSFdoSVZqQVdZ?=
 =?utf-8?B?clZLSWNjV1ptaVhqV2QxZmpudHBsSkVZSHhYZndJZU02Z0FaMGN4ZlJma1Na?=
 =?utf-8?B?UjhXcnAyUzhEemJ1S293c3JjWkF1NVdEZGFVOXhNbGVpSkd1VmdQQUUxTEJF?=
 =?utf-8?B?SHlqeFFsYXd3bzFuMjBtZGpIZWoyTlFLWTlDTklmZmcvSENINTAyNkVTOGww?=
 =?utf-8?B?SW82eHRwZlFkSnhSMmdGSFF4MGNSNm5IL0tGQ2JqZVNvNVcxaTMzYm43Nk5I?=
 =?utf-8?B?VWxyanlHQzZ1Mzh2V2xtZWVaeklmUFcyeEtxTk1wbjVFY3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmxWbHQvTVhuZzRaYnhmdldVaVNya1FUQ2VLMGVDTThoREVUU2VRTjFXSit1?=
 =?utf-8?B?NnR3c215bGlCMngzMHZCNHlNbXpkYWROY1Z3Yk5pVkJmclBURUp1YXhObDlM?=
 =?utf-8?B?VFRLMFdMQ2g3WjVkWEtpZzNraktKbUZqb0kwai9JWlNNb2FKN2tqYkg2TkhP?=
 =?utf-8?B?Rk5EY3FLUm8vVnlFSWZ1TldtRTlQT3N5eGtZb3hiamVucFU4YU9uYzZ4cFUx?=
 =?utf-8?B?OXFQR0t2czV4Ym5USzFpK2x4VGJ0NGVBV2p6VEhiK3Rpd3dzVFJmWGQ0RU5O?=
 =?utf-8?B?WWtud1JjMGpYZS9keUQxMVhTVXl5UFFVdHJOMEhRYmlIK0RTbTRIWUgzQVJk?=
 =?utf-8?B?YkJmclpGTzlwbUd1NDNhNHNnT0RJTWFJbVdra3UwWU84OGRxQXZqVWZqc3BY?=
 =?utf-8?B?Nk42TjdSQjZoTGd1WHZXTkorcVc0RWFxVEREYmZrN2VaMEowVThFcmwyTFlD?=
 =?utf-8?B?Y1J4c3NsL081RTJKMGF0b3NnUmtVWmxQOVZydUEyTzJpR203T3pReW00eFVR?=
 =?utf-8?B?S0RXL3BJd2ppb1dCWURUNnVMdjBZVGdhbElMMGdlbTV4eW5HWm1lMVBHMTh0?=
 =?utf-8?B?MjFucWp1SXdHVVFuUVMvdllKM1J6aEdlNllOYWowcWZML2Ruc3dMd1JWWHRl?=
 =?utf-8?B?bnJRRE1qaFJnekV5RTNmdThPQWtZNHJUN3ZhYlJ5NDAvQVFWVEVoT1NmZ1Nz?=
 =?utf-8?B?aVZHSzU2aU9CRTVTc2U0UnhEdDR3dW1YTmJXZWd0cE9kSjVsbUlVTmY3N2tO?=
 =?utf-8?B?bWpwckQxd3FEWjFuemJjcXJ3TEVTbnpJcVJVamxIaDFIcWlOMHB1R0tSQ1JS?=
 =?utf-8?B?SjFTUkJSUHlxcnY2SW01T2J4OVo2djlrRlB0WTNVYTVuWkIyOXNmQ25EL2Jv?=
 =?utf-8?B?S2l0OVBHODJScG5RemxkVThOY1BYVWo3dG9XZUdGeVZWeXVheW1JSEhKZDJ1?=
 =?utf-8?B?UzJPdFlTa3EzTUh6RklzTWMwbnlWUzBsaEJMQis0ZGNJRExEc3BoYklwUFVx?=
 =?utf-8?B?M3E1SXE2cnI4clhRTnprM2ZxUVJEUnE2L3d4QS9KOU4xMUNqQ3RFKzUzRDNI?=
 =?utf-8?B?cG9ZMGRKR1d1bU40NHQvUkswQlNZVC9BQnYyNldFZ2NFQlpKeGVVaGxOdzI2?=
 =?utf-8?B?THpTL0dSSkNZTVhBSHlXa25ZNlIrc0ZTdlBxMDJYczRkRytwT05YdWFWaW1o?=
 =?utf-8?B?UHlQbDJON0Qxd2FyK0lwWHpUS1NuRE9oSHFEUTNrTTZpakdIVEJ0UXdTUmVo?=
 =?utf-8?B?dGR4QlBjLzJLWWpkblpQeTRKR05CSFMxOVhwOHYxeTU1WWs5UWZldE91QnVD?=
 =?utf-8?B?YUxUMG00cnNlN2hHSU8vVm1QRGlBdmpBRUFhWWlqUFo3MW5aSzc2U2hJb21l?=
 =?utf-8?B?MklZVUUyUTVIZ1E3Q1F5MGNBLytXVWpWTlNRZmRGbXp5M01LMWh1U3lwRzJH?=
 =?utf-8?B?QVR1cTZRQmR2dUFEU2JxcXQ1Q21TczhJWVcyeVlCTVB5ZTdSYTBlYVJkaGo0?=
 =?utf-8?B?cE54UUMyMGV0MFAzWFlWQ2dnaDA4bjNYMFBhaHpMTFVOMWYxZ1JqcWdCc1B3?=
 =?utf-8?B?Q1JyRnYzdjhUekRNWE9heEkvK1JnNVRYVHFYNHZ6SS9EYWtmV3ZvcGdqdUJr?=
 =?utf-8?B?c1NVOGY3VG0rTmVMNXFsT056VWRPcTBLMk0vTFhUcU8vMnVhNnZuUUU3T3V3?=
 =?utf-8?B?ZU9NNjR4dHBFcys3eldjUXluTFpnNExuMmI3U3FEYzR4bmhzU0E0aExxY2c3?=
 =?utf-8?B?T291bFNiOGVUd29hVW9Yb0d1d092NGFwUUhDSzNmdWJvN2RZbDd0WUNzdHJ5?=
 =?utf-8?B?cFdYVGw5ems3b0oxeUVtVHdQZ2FPUzFUa1I3NmZYNTh4eGNvNW5Ec0taOFky?=
 =?utf-8?B?Y1B0eEhEWktNSkkzVzZZeERoV3Rja0srMCtjTk1yZWRERVgxN3M4c053MEZl?=
 =?utf-8?B?QjNoUEtnVThjN3lMTUJUcCtTcFMzRCtpZEpTY2VkTHVVaTRGRytaRWNkc2ph?=
 =?utf-8?B?eTAwU3NHSUhMbjlZN2IzRWw2ZjYvTjVDdHZuQnUwcVZYT3VGK29lazFranZL?=
 =?utf-8?B?MWlnYXc0NTE5N3BqSkoyMHZsa2JkV2JnajZZNVlpUWFMMzE2b2NxanBqL2oz?=
 =?utf-8?B?RTRNL1NyY1NpN1hDWXczdzZEbXVQOUZVdnUrcS8ramRhYlRsOTdxTFVPNERq?=
 =?utf-8?Q?Q8t4EKtRhV+QDrxSa241u3U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B717DF3AF1515648AF3FBB3DF4F33F66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2283aac-cbae-4ee5-03a0-08dcd1b7255d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 16:39:31.5254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fnPxFzDLq9H+cMypYG99M29FggTEaY9KDB9nBb5/O8Kg04JjFuVhlOJUPrjwUqtQAUzJZdZ7SJK4vOSVyTr3zr9XUiOaLpD9OUXy1IJ3aUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6129
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDE4OjI3ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA4LzEzLzI0IDAwOjQ4LCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToNCj4gPiBGcm9tOiBJc2Fr
dSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+IA0KPiA+IEFkZCBoZWxw
ZXIgZnVuY3Rpb25zIHRvIGFsbG9jYXRlL2ZyZWUgVERYIHByaXZhdGUgaG9zdCBrZXkgaWQgKEhL
SUQpLg0KPiA+IA0KPiA+IFRoZSBtZW1vcnkgY29udHJvbGxlciBlbmNyeXB0cyBURFggbWVtb3J5
IHdpdGggdGhlIGFzc2lnbmVkIEhLSURzLiBFYWNoIFREWA0KPiA+IGd1ZXN0IG11c3QgYmUgcHJv
dGVjdGVkIGJ5IGl0cyBvd24gdW5pcXVlIFREWCBIS0lELg0KPiA+IA0KPiA+IFRoZSBIVyBoYXMg
YSBmaXhlZCBzZXQgb2YgdGhlc2UgSEtJRCBrZXlzLiBPdXQgb2YgdGhvc2UsIHNvbWUgYXJlIHNl
dCBhc2lkZQ0KPiA+IGZvciB1c2UgYnkgZm9yIG90aGVyIFREWCBjb21wb25lbnRzLCBidXQgbW9z
dCBhcmUgc2F2ZWQgZm9yIGd1ZXN0IHVzZS4gVGhlDQo+ID4gY29kZSB0aGF0IGRvZXMgdGhpcyBw
YXJ0aXRpb25pbmcsIHJlY29yZHMgdGhlIHJhbmdlIGNob3NlbiB0byBiZSBhdmFpbGFibGUNCj4g
PiBmb3IgZ3Vlc3QgdXNlIGluIHRoZSB0ZHhfZ3Vlc3Rfa2V5aWRfc3RhcnQgYW5kIHRkeF9ucl9n
dWVzdF9rZXlpZHMNCj4gPiB2YXJpYWJsZXMuDQo+ID4gDQo+ID4gVXNlIHRoaXMgcmFuZ2Ugb2Yg
SEtJRHMgcmVzZXJ2ZWQgZm9yIGd1ZXN0IHVzZSB3aXRoIHRoZSBrZXJuZWwncyBJREENCj4gPiBh
bGxvY2F0b3IgbGlicmFyeSBoZWxwZXIgdG8gY3JlYXRlIGEgbWluaSBURFggSEtJRCBhbGxvY2F0
b3IgdGhhdCBjYW4gYmUNCj4gPiBjYWxsZWQgd2hlbiBzZXR0aW5nIHVwIGEgVEQuIFRoaXMgd2F5
IGl0IGNhbiBoYXZlIGFuIGV4Y2x1c2l2ZSBIS0lELCBhcyBpcw0KPiA+IHJlcXVpcmVkLiBUaGlz
IGFsbG9jYXRvciB3aWxsIGJlIHVzZWQgaW4gZnV0dXJlIGNoYW5nZXMuDQo+IA0KPiBUaGlzIGlz
IGJhc2ljYWxseSB3aGF0IERhdmUgd2FzIGFza2luZyBmb3IsIGlzbid0IGl0Pw0KDQpUaGlzIHBh
dGNoIGhhcyB0aGUgYWxsb2NhdG9yIGluIEtWTSBjb2RlLCBhbmQgdGhlIGtleWlkIHJhbmdlcyBl
eHBvcnRlZCBmcm9tDQphcmNoL3g4Ni4gUGVyIHRoZSBkaXNjdXNzaW9uIHdpdGggRGF2ZSB3ZSB3
aWxsIGV4cG9ydCB0aGUgYWxsb2NhdG9yIGZ1bmN0aW9ucw0KYW5kIGtlZXAgdGhlIGtleWlkIHJh
bmdlcyBpbiBhcmNoL3g4NiBjb2RlLg0K

