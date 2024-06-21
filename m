Return-Path: <kvm+bounces-20196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA1B9117DA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 03:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 926F01C21092
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4484696;
	Fri, 21 Jun 2024 01:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eI0Niftz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3251366;
	Fri, 21 Jun 2024 01:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718932003; cv=fail; b=bggjsDjI0vt7BjOihxiaGv2J5js/MN6fbXAAxQhAzP20uT5QMR1uPY05yCZwhes5KM2Dxw+GFbG2EOnHoltsTwMipFYtF1tvpYVpkFemBZvi0g9BGWMKFlKZgWtYpFyNU1X0WowFhSGt77bR7z0bCQ4nVYKvrVs/dGRwg3+sBEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718932003; c=relaxed/simple;
	bh=CNFELbruhOhLQvwSmOOCKIyB7WMjV03adyu6bC366tY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iyEYzqO0u1AcqWBl7adbLqrX+6nWJT8siWNyp54qHrOS9kNmKD6eOft+0CRDNfbPgphydbXWytquZNmAkJgUxKjeHvWJyml0wFTL/7atlZyDsJf8sd5V0qbzhnYTRTc5aWH/wc2kl2zsXZqgXV6raBXyNf2OSdeWO5mKIYQl+zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eI0Niftz; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718932002; x=1750468002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CNFELbruhOhLQvwSmOOCKIyB7WMjV03adyu6bC366tY=;
  b=eI0Niftzp58ae8ImFU6jpIbln+BBJmM8JsOALWBHAMzkc/Ml80owToPc
   zpYUI1GHpM3GHcQW0ypzgMDyQbemTdnMFrvKgxlAQVYY05zgwyd5D5fsG
   a7EKSfols0DKz9JVcEsi7STfj2yKB8yqNvWdmlqAfOc5wTegJwCXjxLFC
   2Y09hrSYxuP/FMSCnbDJJTprMeARxk9FLsONEiInMBdYR5bhMfess2vCH
   noH8WMIF7gFRHTsGwUcKJOsYooAf/+13R0XHY2CKJnieU3Ja99jHna940
   zTD2HwwkZ/td5gJ+lqiRdgaO9ZvzcYFQ11Z7YVjkGT/ovdeY7W8kTu2mX
   w==;
X-CSE-ConnectionGUID: v33L8PmHQP+IT/x+6OZg/A==
X-CSE-MsgGUID: L30uBVkjQmywxNq7SpU29w==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15927376"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="15927376"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 18:06:41 -0700
X-CSE-ConnectionGUID: gWpFeOIGS/CXvg2HYPrDuQ==
X-CSE-MsgGUID: GMXR88LuRXWJGV6O2ayUrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42533366"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 18:06:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:06:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:06:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 18:06:39 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 18:06:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0VPkC5gKtByn3J+YyXLZjm9ko5P/AK9zi0CUu1aXY2DAH4jCpDtkcBzaXRh/8dhwHRL9aZNYg8zzUpeNVDvSxt82t0Zt91weWUyRZpqYiBN4bngB1aZqPpCJlzQKAxOrTLn+Ag5WhfbLGHE48tda9EborNG+IbQ3jPP6NN2uqKKQva8ytClRCOKGbukF1T7nOvYiDHra1B4XEPqgW4/9K8bhlVl6CIwBT0tMBjq7tCPG9n9RWiKdDvGB1PpHrPxT/EMYueSQsyBlOL+a1gVTqH6a2t1k9jQ8wB5qUEO/AwPEPWO06rWbrvM8g3W/m2Uy0iPvFEG/MIhOeCMBNU6Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNFELbruhOhLQvwSmOOCKIyB7WMjV03adyu6bC366tY=;
 b=AcJMq/lbIOoHxB+j/OYqGafe43VVG6qousrUzLLzXGB/xi6AdZFRNZO1W5kqYl+I/OeNspd6QSVwUNzt7tdnA+Ah34nDOK6fDgCI4UxFn1Sen9sfSnkXwOHRz4HV0H8lmKBpyFffFJW1W5BYA9xVCHXQX5HunkL2PTE3fI1fmgeLNesXRw+R8JZGfMCLQFVk3jQa3qMTwnTfShavqu+YJkoBgK0v1LvFluwivYWkQ5qnP5+5Z1fpkXCKb4gZZPccocAHM0ymv3NX94kVKrsk3zKB2sGlbgEjJp10/Ou0FsxnhHeUKc/1wVd1xCDB2JpRqd3lGZ/H3uOfZEqBGq4zlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7814.namprd11.prod.outlook.com (2603:10b6:208:408::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 01:06:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 01:06:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Topic: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Index: AQHavVgfQPm70dQw5Eee10kcdYgSb7HGHiqAgAWlogCAAdqzgIADeY8AgABJaACAABJgAA==
Date: Fri, 21 Jun 2024 01:06:37 +0000
Message-ID: <218550c574bd7670e079e9afe068ef88c3aa8cdf.camel@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
	 <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
	 <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com> <ZnGa550k46ow2N3L@google.com>
	 <21b18171d36a8284987f8cf3f2d02f9d783d1c25.camel@intel.com>
	 <ZnTCsuShrupzHpAm@google.com>
In-Reply-To: <ZnTCsuShrupzHpAm@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7814:EE_
x-ms-office365-filtering-correlation-id: 362bb680-f3ec-4a8a-4960-08dc918e6695
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|1800799021|376011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?c1VtVkI1ZmM4SDNpbGN3SmdhRnBLeFI3VktoZ3hDWlJFaVVwU3FYQVdZL0M0?=
 =?utf-8?B?Qm5WQVlPZFF0OEV4dU9WZ3RtYTJ3WlNyVHVtbzkwVmVaSXhqRDZPbXBHUk9y?=
 =?utf-8?B?eGVNYlNCUS9Zd1ZCdEJGYmV0MmlVMHBkYWhHMElzRHhWRTB2Unkwc0ZHdzRR?=
 =?utf-8?B?NXBtTHVVYlN4NStscXlQUVpYTTdsaTRYeFdXemJ4cWFVZWgxRStyMGFBeFo4?=
 =?utf-8?B?SEVVQVozM29tL1FGV1loYW9Ea0dIeDRvSC9tWGVMaHpiTUY4S1ZHNkE4TlZZ?=
 =?utf-8?B?TVNXZ0UyZEFoajZWems4eE4rNVZhU2ZacFZMUmtEZkdaTDNWRWVWaFo2NEV6?=
 =?utf-8?B?dXBxbXNZMUFKMmpjS2gvNTRVdGNGYjNiaDBXOUVtd2NscUFyOGNoVHE0ZVRh?=
 =?utf-8?B?djB6cVlMRlRKZTZGeE5yWG5VL243SDVUbmxkNEZ6dlRhL05HVUpsUDdaWVZW?=
 =?utf-8?B?WDVnRmJFamxhQmlFSytpNER2cnZpQWFMUEd1UDlpZCtVc0tPZkhuaVprRXNK?=
 =?utf-8?B?a3NLQXg4S1BXVFpBQXpMSWdWams5aEV4dnRJK1lFekQ4N21TMk1ZR0tOT3hV?=
 =?utf-8?B?ditidUJnZVVDYlFrSXJzaXVvMDZuZFppVnJaaWpST2lGT3c4SkZnTGdvK3l1?=
 =?utf-8?B?NVdIakZ6a0VlNm51NU5ETlcwTS82Z01mNzh5cUlBenJla0xLNXlndzZPYk5Y?=
 =?utf-8?B?dEFRaFdybFc0ZW1reEc5V1MvL1VKZXR4ZlZHYnVhT3hhMnN4MFlHbVZLdVp1?=
 =?utf-8?B?R3dVcWYrM3lHeTZLVi9EM3c2TVZ5WmUvOGVmalk0c1lSaFk0Y0htV0Vld0VH?=
 =?utf-8?B?SGZneDdxSkE1amFWK1htNGFDaktJb0NYeXFLWnMyVFRwVEJ0N2poZnZuanNz?=
 =?utf-8?B?a1VoYW1yZGJITjFuYnErcUdteExLcitNdTZmYWJBd0xMdlBPOEFieHhzVGw2?=
 =?utf-8?B?b1hGMktqd1BRZ3NKWmpRZytxaTlUKzk0bVR1V1RxUmNVNnpjZWJCdEZwTmdm?=
 =?utf-8?B?QTJsSXBHVHB1Z1JCeEVsN0ovV0IzNEZ6T3lJckFOQlJzTktSVk5tVmp5Qkxt?=
 =?utf-8?B?U1BYTFRIN3ZhTklzMnZ0bndWSndCbVlSc1NNUC9vclRKbDNUc1Z6N0srS1BB?=
 =?utf-8?B?MThBWGgzdjlNVHNhQ0JITWNOL08xUm0zZDZlUGtsZUg0dFdaMUFYUC8xQmsz?=
 =?utf-8?B?R2dsbU1LMjRRQTNHQ3cycW12dk9TMlZ2b0xkUmRJT1Z5Y1VIdGM4ODZzemhm?=
 =?utf-8?B?SVJBWXZVR2F3TDZ4UGVtOVNWNXdKRlpMZ2ZDMGpKL0lKUmsyMGxCTXNRelJU?=
 =?utf-8?B?ZUxFWlRpSnB3M0c0dWRwRWplQWUrcmd6QXFoWjN4R081UUxEbHNZb0t0ZnhX?=
 =?utf-8?B?NzBnM2lVSHNqZ1Boa1ZTUzliU254V3VISmJmZklhaDl0S2gxRDRJSHZpM245?=
 =?utf-8?B?dFFReTlGVFVISEZWdHphNkNWWVNDclFPVHVVK3ZqOG1sVkEyMUZOQzJLeGJE?=
 =?utf-8?B?eTRyb3BZbWhCQVQ5am5ETW1QSVNoUE02OXZkNkdUWlFKS1FIK244RlNpWldX?=
 =?utf-8?B?QkVHeC9yM2NVWHgzUXp4RmZjRHE4M2h3R0pJa1d2Z0FHMzRQZTRBUm5NaDRL?=
 =?utf-8?B?K1l5TnRrZk92WjBHOEFCMVlWZU9yRVJNNEhYajVtNVQydWNoY3ptUHptMEVw?=
 =?utf-8?B?Q0JCZFdxUTFDcDFoNWZEWEh6UTVCSTA1bHMwMXRlRmRvRkNwZmNtNjRsSVVs?=
 =?utf-8?B?dHhtbisrNC9SYXRDbXdZaTBwNzZYdUc4azg5ekF4M0ErOW9CaUtnTTlKQkRI?=
 =?utf-8?Q?kMoVd0fBXtnb1omxBPi6HZblQIce/Cj2+zQbU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkZLRTRWWnM0VGplaW1Eb0pPWUJPTXNUUlVKVTJWeWtCQXdGeDhtZHJsR1Ji?=
 =?utf-8?B?UEN1bS9BVldoNm1jK1VsR290dWFNSDRGcjZ5KzBXL1VheE1Ed2gyRFJEcStm?=
 =?utf-8?B?QlpkRjNSNTZDdEFoS0kyNjJ0TUZvWjVpaHdVNmpWUmg0ZmpRT094b2h4dnds?=
 =?utf-8?B?WHpObVc3REx6QmtoanNWODBOOHlrSTY3SWpXeGxIRlV2S2oySTJmZU5Bb2Np?=
 =?utf-8?B?dm9SenIwWDd0enlrS3Bkd29SVzlQWE5oeW5JSUlNMk9JTHRabkM2aFNrVXdL?=
 =?utf-8?B?dlZKMFkyUHdpWlFSbmVmL1djZVFYaFBuM3hNQUltaXpqcGVTSWloV2hIamVP?=
 =?utf-8?B?SUx0RWZ5WWtaZzRXd01xU2s5RzgrN011c3R6Zll1bkNHLzF0R1hIRHRBQU56?=
 =?utf-8?B?bU9pSWdjK25FQWQ5eWdySEdFNWJhM1JMb1IxV1hPVllKSWVEc01zRkhLd1VY?=
 =?utf-8?B?cUE2TWdSRFFQbHFCell4Ujk3Vm83SVN4VzFFQkR5RVorblR2cll6VTJvQzRB?=
 =?utf-8?B?NlpGWUtYS1Z0dm1GL2NScXVlK1kveGJpZlppSHM2MGdzRXVMNUsrTm51TVhE?=
 =?utf-8?B?d2NnajNlY1B4dERNRituaG1tNnZBSzI4aWh2U1pEV2h0N1BLb1FDOThYa2hV?=
 =?utf-8?B?N2pGNjRpZnUvb2hldy8xaVd0a25mTUEvS1V2aDlQV3hBNlVqTTQvSnhNZEFO?=
 =?utf-8?B?Wk5TWjlJanJpQ2xLeW5BN0VPM09LUWVRYXQySkV2RGZGODl6MWdWQUlnV2FU?=
 =?utf-8?B?bWFqbks3NG95U2pESGt3Ni9va3VCWXh2ZSthcDNIMVdzeG80MDIyOS80SlRX?=
 =?utf-8?B?cnF2TExmTWIySm8xRjVTeXl5Z3VKLzV6YldxVkZJSUJkYTRqNDc3SWxsTzI2?=
 =?utf-8?B?UVpYdkV4VUx6ekdvNmpkNzVGclAxYjZBUGsxUEhqaklPWDg3NWJmN1NRak03?=
 =?utf-8?B?aGpvZDErYi92Rjl2dk9tTkNIK1FZR0F3aVh2TUdCNXhSQmpJUk9aL1hrNnRT?=
 =?utf-8?B?ZnNmTzVsZ1o4djV4RDVvRWkycjZvT2U5QVAyTmVTalV6MmptQk54TG1rUEJM?=
 =?utf-8?B?cXMvS1Vxa1k4bjlQUWxWNjFaRFRxc3dXTk0rRWg0bGk0UFFtcEprcVI2Ynkv?=
 =?utf-8?B?TFJPQS8vMHlMTHhUUFJGUFM4MXFKOU5jS25VK2dFU24vTlNtcmlMenhCZWZt?=
 =?utf-8?B?ZFYvbndrU2YyR3B2QzRDbkc5aEpLelRDQzVjTlNjV3FCNk82M0loa3VPalhD?=
 =?utf-8?B?amNQejZPajQ4alNWOStsSmRKUWY0NkZaUmNCL2psTlhuZjkvY0VRVUtHTm5k?=
 =?utf-8?B?KzQyRUxOT0FES2xNVHVSS3k2b2hPdGZQaFYvNGlHOC9iQm9qTGVaVTlQK1lR?=
 =?utf-8?B?eTYwdHp3SExPM2l1TWxoeWxuczBxN0NzNjR1UHJCSHhHREhUOGJzRFdLMmdE?=
 =?utf-8?B?RzBVakxlZmNJb3pDeStYQ2FsZWZLWkpqMkVBa0V2d05qVzJwQ1NkOW9XM1hD?=
 =?utf-8?B?L3l4a0dtRzQzWUtBSlFHQUkrZmJkZHFFUmZoWEdBS2dzUjdwR0RMWWlvSzdO?=
 =?utf-8?B?QW4vNGoxY2lHTWtGK1ZOdEpXbk9QV2JQUW5YdXJ0M2h1N0pRYVQvU3dZQjh6?=
 =?utf-8?B?N1J0WUo4TDhvZ2xrRnFzamhLdmQyTmxmM2MyMVlXZ0JldHV4OGVSV29OaDhC?=
 =?utf-8?B?c1R6ZXlScWtTeWhCaURkME1BMEprNXJHN29EMURxaTNPOUFlVktIUUQremQz?=
 =?utf-8?B?ejFPV2czKzY4WENuUWdVeEc5NVZYa1diRlRHczY1SmsvMzNHZ2dyVDVyQlAy?=
 =?utf-8?B?d3pGZzNGb1Q1aTFHQ2x4NkNTZ2t5eDNDWGhyaHNHNlBlT1lwY0RCWUhPd2NE?=
 =?utf-8?B?MXFZYnhFQyt3Z0dGU2tqd3Qya1RMTEJoeDdlYzFkcTNuWncxZ1lNL3MyUER4?=
 =?utf-8?B?OWM1M3VtaUtlQkJMTGR4d1hrcmtHZzZSVnBzSDZHZ3BveGQ2NlpPRnlZelEr?=
 =?utf-8?B?WWFPcHJJTk41clhmdk5lblJLdDkwdEdnNkFYZWY0T1NhTUF3NWQrWnVoK1pK?=
 =?utf-8?B?czRHRVJhWjFlZ2loSFF0ejRhUEo5anQ1SVJTVlRlbHVPUlppMC9SbFI5NnhL?=
 =?utf-8?B?d0Y1UkdwK0RPQWNwdjlJNnl1VnJnMFlsSTFzb2NBUnA4dE5UVG9aS3J3MlQ5?=
 =?utf-8?Q?8OyxoHtpLIaPyvSUsQzydJI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17755A19B8DF5646AC266E3919AE38DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362bb680-f3ec-4a8a-4960-08dc918e6695
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 01:06:37.1572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+jNCiRCN+7jegFU7c6JBWEry1VA5R7YElUh8Tu3zRKH4BXA+06ky31odrjv8li8QPLMwh6uZtrswH2Sl7V67cfApByswaicERPw3RWQ9bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7814
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTIwIGF0IDE3OjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gV2hhdCBJIHdhcyBzdWdnZXN0aW5nIGlzIHRoYXQgd2UgY29uZGl0aW9uIHRo
ZSBza2lwcGluZyBvZiB0aGUgbWlycm9yL3ByaXZhdGUNCj4gRVBUIHBhZ2VzIHRhYmxlcyBvbiB0
aGUgcXVpcmssIGkuZS4gemFwICpldmVyeXRoaW5nKiBmb3IgVERYIFZNcyBpZiB0aGUgcXVpcmsN
Cj4gaXMNCj4gZW5hYmxlZC7CoCBIZW5jZSB0aGUgdmVyeSBiaXphcnJlIEFCSS4NCg0KQWgsIEkg
c2VlIG5vdy4gWWVzLCB0aGF0IHdvdWxkIGJlIHN0cmFuZ2UuDQo=

