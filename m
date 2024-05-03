Return-Path: <kvm+bounces-16464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30008BA478
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 688262845C7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F484A18;
	Fri,  3 May 2024 00:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5IvDHwb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E4256A;
	Fri,  3 May 2024 00:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714695565; cv=fail; b=PIo1fA7EGH8seUY6iLCALx3c9C1Ecrny8mP0pzcfjBsAcj7YeghSKzAPfLOgtwd+OA97S8JD2jBaGq1FPXaEYoRvoxESzuoyH7suOJ+lJetX2c8aD2NmPH5b80/lfShY7t7qjuFUshhC8y0GbuPNVdpRkNsPodhXSqHuU5D363M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714695565; c=relaxed/simple;
	bh=5ueASqp0328u+MLi1PaDjGVsqoouYYd0dLezstZbDxI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=APwQXdUns6/Wlq5IFhNw4kMyun3i4czjUstpfrwPpYaeqPZVPNR8tMRAEpvVmTMcwfmPiOuzAbHKwjFBVGgzhafCIRBzO52sqigLm6fPHmSBiv8sgEGAOyHbq15C2EuuOiwYrJw3EYFiR0076wbKulleiAUNuS6WI+7sFHu4yyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P5IvDHwb; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714695564; x=1746231564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5ueASqp0328u+MLi1PaDjGVsqoouYYd0dLezstZbDxI=;
  b=P5IvDHwbSzsWf8KZN5FtTNpyQatT/nIpqom3uOMwequ+v//c38PjjWPH
   gqnuGy+jNkcPODnFzKjPqZW7TDe0NLJBFO1Z9+e+cD/LLDS1EK5bBQq8B
   y9vfo3qrCQKtBpU2YYssROlKL6oZvTWmI1rxHjXcpzjeKgdPJR2YwMEYH
   1HLplhajN9WjAENjBZVK1cH+Grh5VLjPf/XjRWdXfgWd9/Qc0YPvghQJD
   mLa3llJ5bRjcnEKnyw/j7OwrI9DV04sDNQhVoAPNf/OBNQjxggNksmKHN
   JlDP0p6obPEudfuZoJPFigtzxYMifz3zOjVD7fQSDZ4bYifMAIaFPazjH
   A==;
X-CSE-ConnectionGUID: eJ+pyjccQraKp0dJyPI6Zw==
X-CSE-MsgGUID: f2Nq+qYwQzeOher8gTDPeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14304994"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14304994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:19:17 -0700
X-CSE-ConnectionGUID: gM3XsRQaRHu4CBcAIojtnQ==
X-CSE-MsgGUID: ydzoK/SRRr+FkeZFEqBFXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="50488588"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:19:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:19:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:19:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:19:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZe/PTjuTjyS3VWo3cl+f0BIyuc5+hBYqKRc25+a6UAWq2v7Ck/yQO3E/PG5B9F3TOTrKOS2N9YQ+rFwjr/uy6J3pX6ha+1jKASSHHa+YwcwEhZ+1UML8rG6h+TdiB3L3ABNu+UU6WmMq6PXV/MSacEdM8ceuKjpSCkO/HAVIGox+82GblknwOkQMIm6juA/xVkSGOzR9raXVV/1NALxO28emYxDnYlLeAM1tekt9pK+Vd++SSB11qjGPk1EWI6R/IyfhGfGCeuD3poZv3r7wb9pYX2g9dLsr8O39UQcLuR3HgvMuJxxGqwx7Qi1D+AeLpgppCt8mxqde4/C7ueLow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ueASqp0328u+MLi1PaDjGVsqoouYYd0dLezstZbDxI=;
 b=UI/UzrMyzAB13uvD8mo+W4W5RDeEOT017lUuK7Ww30+WmO8TQ+Ss/kiTeGyLSdPkEmSl/yfid6Amq3LW339LlFYNrO5mwxFgEswAA2R4Xq0WrlFNr9hi4l4l6R0sQo3hcHsPeZF8w11opuynlvjU77XLdj9LpIwhjmJdcDQTnnhM61Pf7iefp4pO5KomQMUfe5YqaZRWLfUmM+rrVUtbn8Y2wt79nw9RBw+TEdvCNg0lLWfMmsGJVBPjfkmk4Kr1jJHBx27anh1YcH7peizVRA03pDcdaygQcDqYeqTIyyn4VZoY5PMf5EtoV6jumbLu57S1xZDgxm20TakuDsZAnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7197.namprd11.prod.outlook.com (2603:10b6:208:41a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Fri, 3 May
 2024 00:19:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:19:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHanO1LV4iR6HM/g0OQuJggcdeiqbGEpTKA
Date: Fri, 3 May 2024 00:19:14 +0000
Message-ID: <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
In-Reply-To: <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7197:EE_
x-ms-office365-filtering-correlation-id: b0b054af-191e-4037-7d7e-08dc6b06aa15
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZHVkK3pCQTN0eFpKOXVMTFoxUlBRQXNEMmQvck44aEdtQ1V4cXM2VGxUTHJ6?=
 =?utf-8?B?QkVybEN4cW9KZU05Y2I4dzF5L0NkeXlvZURtbjRMZktnL0Z4eURqVVhlcGVQ?=
 =?utf-8?B?YzJTM2tqMUhmWnVXd2lwZkJCQ08zWll6VU1aWmtoWFdReWFHU3B4elk3QXRn?=
 =?utf-8?B?L2NGeG1FOHNtenduU3E0Q1ZEaUVaM2pYaVhOVkFIeDViNGVPOU16ZTdrQlRj?=
 =?utf-8?B?Ni9NalZ2U1lGL05SQ2NmWWl1aG01emdTVUcxaEZaejlXZUdjdzBUb3Q0RGc1?=
 =?utf-8?B?Zk5kSCtDanliYmxEMW9TOUhqK0FrNFhZMUF2OTYzUGE2NENZdG9FMXVTckhB?=
 =?utf-8?B?ZXJLbURxU3EyVHpTWFJTc2lCVUJDSmplblpNTHcwV3pqbjRNbTdMUzZRQVJu?=
 =?utf-8?B?b2I0ZmJpMGVKbFZJQVBtdzQzMHJKdG9zRW5sTTZvRVFmT2MxYVNjdWxQV2V1?=
 =?utf-8?B?VWQ1Q2xaS0JkNDFuajZWUWlhd3NYbjhFOFdJaGRCekwrSGtRVUIxKzBaR3Ri?=
 =?utf-8?B?S0tjTHpZbmwvOXR6NWNHWXdLbjJXRER4dks1NGdzd0J0UHhNM0ZYR0wvZXd1?=
 =?utf-8?B?cU1UUkJDS1N1VmtmNU52azI2V2w2UDhudVovTmFFSThYZkV2b2pvd2hNYUxD?=
 =?utf-8?B?ZHkxTkNja1JhRDM4VVY0NWVCR0xpVlM4eXc5eDArYUpLYUx6d0RFTzVOQTNV?=
 =?utf-8?B?ZFo0Y0lWeVc3VHNlRlhWRS85b0ZmRENWRk45RUVlSkdzcGdIOW9wNHJzb21u?=
 =?utf-8?B?TVdqYXhrT3NWQ1ZzZDRLMTBjdGgwLzZ0WEFNT1NFVmNjOGNuNmdXY3lOTDVB?=
 =?utf-8?B?cWdCMGFMWjk3VzdhM2NYSFFHb1B6Yy92S0U0MzlwMjNheTNkbkttbFk1Nkk3?=
 =?utf-8?B?NUd3R25zSGNram8veFc0SW1wTkViVUUyQ05CdzZZV3JkYVFBTDF1bk01enBX?=
 =?utf-8?B?NUM3ZWVwQzM2cXpCZjRJaVRuaFYycUsrcDhmWmFnZ21vbDAycTlqVHV2cnE3?=
 =?utf-8?B?MnA5OUZrS2M1RE1sOC9vWm50Y3N5UDdhdjBtR0R1aWxEYW5UWTRjaUk0RlJM?=
 =?utf-8?B?bGxHc2xIc21rdlY1WVp3NUh2K1BZRWVhckpVZkRsSE9rMUsvNGpsM0I3eEZD?=
 =?utf-8?B?M0ZzY0lvWGhzcE9mY3dqdklSbDEwNXBEclUzRWp0VXVCVWNYSncrNC9rSFU0?=
 =?utf-8?B?aXNCb2dDREwrU09UNE9DaGUya0FmYXpIT2VrV3pDZmxNOWN0cVRQaThia3Nr?=
 =?utf-8?B?L2pqTXhlVCt3TjQzS2V6aW1ScWVTbzRwbFAwYWtXNkk2K05VaTcybElldjhF?=
 =?utf-8?B?d2pBSkNHT2ExY3NJb1RkY0czTjJxdGY1ZUx0MXkrUTZIb2lZZFFNRVlFVVFj?=
 =?utf-8?B?bnpjYXNkOGY4aUpQT3dobWFwZEt6UFRCOENzZEo1aU5ldExiczkwQmtlT2JW?=
 =?utf-8?B?U3dTQXY3dXJqYXRVZE5xb2JqOW5hZ1VqZVVOd3FiUWhIUzJSVUhBWnk1TTJo?=
 =?utf-8?B?aW5CU2JDNkpoZm1adWtSdVpGYnRPcmdSdHZNdjdlU1BtczdSbGxBRVlTWEdO?=
 =?utf-8?B?bFlSMmVZUURCcjRZQkpXcGFjT0tSejQ5eUZVRjNoanFLK1IyMFpqYWRka2ZN?=
 =?utf-8?B?dzRTV24rTUsrczcxbjVRMTk0cTVHQWdMeWNkL01RdzIwZWNCSDVPTFo3NCtx?=
 =?utf-8?B?cjVRWDJEdVNJUWc1eDZzbmRCczRnL1JFc3JUTVMwelNNWWtQTzkwbjNCZEl6?=
 =?utf-8?B?YVpERHBDQXBaZGhlUHVYUmJxZk1Sa2RONXdQc0tlV052ZmU3U2QwL2Z6cXFN?=
 =?utf-8?B?cWE4MTFaSDR4NXZucTFSQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjlFS2dKdFU5SlNGdHNmaVFBNnBvUEQvN1RQT0VjS3A1RU1aL0gvUi9JSW1p?=
 =?utf-8?B?bUxmeHo5NWJIU2NHQ2NGL2t6OXRXNmt6S0lFQU1MTWhGTjZrOFNXRHFCc0lN?=
 =?utf-8?B?cmMrUnFGdGtwSWpZaGl3R2JOdVRUS1hmcERMV2NsN0tKeXFwNTJUVFlsK3RL?=
 =?utf-8?B?Ylp0bWRIdC9EOTRycVpEUHR2TFdOQW85Q1RzSUlSMlZYRXppTjB2N1o5VUIx?=
 =?utf-8?B?VjZyR2dITFpTVVU3NWNoK216Y2M3RUtDZzRtQ3hIRzhKekVRSEF3dWVwcTg0?=
 =?utf-8?B?eG8xUHVxeStNemhlZUlGTlZ5dTE1K3JKLzgxTVdRSDFrZzQ1Vmw5dkpxTW1t?=
 =?utf-8?B?R0RjTlNWYjNCdFVyNzZlc3UwNzdqZVlWYUFlTVZXMmZETlRMUjRSSjAweXc5?=
 =?utf-8?B?VlhWb0Z4dml6eFpGUGFIaklEK1RjWTg4dTZXM2NwTlJkbk9keWdSVThoZ3Yz?=
 =?utf-8?B?M1k1OEt6d0NtSEpvV0tvbGV3SzljWUx4RC9Ia1Juc2lERmgzb1psYWd1ajJW?=
 =?utf-8?B?Rlh5T3psOFo2WlRIVkZMeGJDWkswVXdadEVNcTdRcGVrVWNLUDRFam5nZHRG?=
 =?utf-8?B?ZnEzeE1kM3JTd0ZWNlFVbDJNeUVsYjYwRzhlUnE0Nk9Yc2pTSUQ1Lzd5T2tl?=
 =?utf-8?B?ZU9NUStseEt0aERPUlBwdGlPcVpEMmFSSWR0TFBjV2FKbUJYOW5HR2psbXhh?=
 =?utf-8?B?bkJ2TlFIN2pPOTZRUFFFQXk4ZUsya3RYbWFmUmRmOHQveHlseXVVZU8rTlBz?=
 =?utf-8?B?U0M0cHZzUW9iOXF0M2hwWDgyMXdRUHBxL2RFcnhnYzRTR05MOW91M1dMd1R0?=
 =?utf-8?B?WE51N3ZqQWpUTnpTTDBXMzV4eFVFN3NuQkFKWVBJT3Z4TkxYdHZLbUtSaUhU?=
 =?utf-8?B?L2tFelAyMjV1NWNtREdyMGE5MUs4bC9YamNpd3ZoZCtPNTlNMUU0U1lkMzRr?=
 =?utf-8?B?anNLYS9pSnVySzFPSDJwM2t0TDNGYlE5OVAwakVhWG9JOU9KeGVWYndEOXd5?=
 =?utf-8?B?dXBYYUZkdDNZaTVwaFFDT05pS3pjRXBzK0RTL0NxbVdhdnVYUlVkOUJldXJS?=
 =?utf-8?B?TmJlaUJ1Umd5N0l3OXdxblZFM0JRTmZhZkk0WWxSVEl2RFo1V0sydWNBZVdv?=
 =?utf-8?B?bDJiMkxnaWVVMDJzU2RsaW9tazR2UFdmVGVBSWo2MHJCdENsc1RBa3ROOFFX?=
 =?utf-8?B?ZDdzMTY3ZURvR1RiaDcrOTl6eXZuV3d4MExyZkZTOWxOQjMvenV6dVNMVi9I?=
 =?utf-8?B?REF5WjJrcWlodWttS3FWK1lzR0xkVW9jSDZGQlkwVW9VcEJyL1E3dWNGdlRz?=
 =?utf-8?B?aVVJbVAzVkRzQTE2NkRaSDBKWk1XTmkzLzM5R2pPb2tqZzJ2Mng0SlBjVnlp?=
 =?utf-8?B?aWw1UEZmMHd6dm8yMENGNTlMM0hydlg4ai9HUzVicUhqQXQrUFUxaDhwVHl4?=
 =?utf-8?B?bVRHVEhOV2VwVmZxaFlyM0JTS280RXk5S1lwOUF2T2daQzJ3d3I4eFVxMGwx?=
 =?utf-8?B?WktHK1d3RWxLejZZd1F6ME95SittaVhueForREJQM29xMVNPdFBndmNKSkxG?=
 =?utf-8?B?YWdUVnYwL05WcVBBYVRUTkViOXpoRFNEQ2I1cEtZT2VpRFVrd1g5YzkzdG1x?=
 =?utf-8?B?TmNkN2tsbWh5eVhjTjAvdDQ1dGQ2djlvcXNXRkFkRWRCL0lxWmFzS0dTSmV2?=
 =?utf-8?B?cDhpbk14NjhmSVd0amtxSGI4cFRRRXBhZnk0TWJQcGUzK1NvREZVS3JxbENS?=
 =?utf-8?B?ZzVUVEZ2bW1wNXhkZEw1Y0VNUVlLalNoRGNaeGZ0Wmd4emh2VWJjUGlNdEhY?=
 =?utf-8?B?bkFXUTNaN0hFNXhqaE9HQ1RQRnNaSmlSV3RyTEhwTGF4NGo0dno1NkJIUkFt?=
 =?utf-8?B?NlhvTFhnZC9iZ1Y2cnppWnlGKzZmMlgvak9lRTFqb3dKc1FEb1lwSE1yUDVy?=
 =?utf-8?B?Um5UZ0tBSVl4Q0x0WXRkcDAzbEZ2NHVQR2l6dVA1YWtOMUxLV2swTmlyT2sw?=
 =?utf-8?B?RDhaeHZrbXZ2bkJsajlkNHYzQzh0UGZLTTA1Z2JBenVXU0ZoQW1JN1k2L09T?=
 =?utf-8?B?NU1KSVU1VWxENTJLSVhtdDFPZXQ1ODgrQi90RVhvRTU0YVl5a1I0SlNDRnhY?=
 =?utf-8?B?ZDNaSndFYWkxdVRnU21zaENmd1ZHaWx6ZmZsc29RanExSmw4Uyt6Si8vNlI2?=
 =?utf-8?Q?uhygQ1LthnhuV8cxN0Qnrh8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AB83FFDFC1B274B949F7B6A57E7A22B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b054af-191e-4037-7d7e-08dc6b06aa15
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:19:14.7175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gfix6kLY52bQXk1sJgKlxpcFzUnf/3+hz6LCcp/i83mxfir7mM6tt3OWwa1WUb5bQPdXQZr1vv+QAsixiA9TRzmefXv5j8Rh7R4SIAzOPrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7197
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IEZv
ciBub3cgdGhlIGtlcm5lbCBvbmx5IHJlYWRzIFRETVIgcmVsYXRlZCBnbG9iYWwgbWV0YWRhdGEg
ZmllbGRzIGZvcg0KPiBtb2R1bGUgaW5pdGlhbGl6YXRpb24uwqAgQWxsIHRoZXNlIGZpZWxkcyBh
cmUgMTYtYml0cywgYW5kIHRoZSBrZXJuZWwNCj4gb25seSBzdXBwb3J0cyByZWFkaW5nIDE2LWJp
dHMgZmllbGRzLg0KPiANCj4gS1ZNIHdpbGwgbmVlZCB0byByZWFkIGEgYnVuY2ggb2Ygbm9uLVRE
TVIgcmVsYXRlZCBtZXRhZGF0YSB0byBjcmVhdGUgYW5kDQo+IHJ1biBURFggZ3Vlc3RzLsKgIEl0
J3MgZXNzZW50aWFsIHRvIHByb3ZpZGUgYSBnZW5lcmljIG1ldGFkYXRhIHJlYWQNCj4gaW5mcmFz
dHJ1Y3R1cmUgd2hpY2ggc3VwcG9ydHMgcmVhZGluZyBhbGwgOC8xNi8zMi82NCBiaXRzIGVsZW1l
bnQgc2l6ZXMuDQo+IA0KPiBFeHRlbmQgdGhlIG1ldGFkYXRhIHJlYWQgdG8gc3VwcG9ydCByZWFk
aW5nIGFsbCB0aGVzZSBlbGVtZW50IHNpemVzLg0KDQpJdCBtYWtlcyBpdCBzb3VuZCBsaWtlIEtW
TSBuZWVkcyA4IGJpdCBmaWVsZHMuIEkgdGhpbmsgaXQgb25seSBuZWVkcyAxNiBhbmQgNjQuDQoo
bmVlZCB0byB2ZXJpZnkgZnVsbHkpIEJ1dCB0aGUgY29kZSB0byBzdXBwb3J0IHRob3NlIGNhbiBi
ZSBzbWFsbGVyIGlmIGl0J3MNCmdlbmVyaWMgdG8gYWxsIHNpemVzLg0KDQpJdCBtaWdodCBiZSB3
b3J0aCBtZW50aW9uaW5nIHdoaWNoIGZpZWxkcyBhbmQgd2h5IHRvIG1ha2UgaXQgZ2VuZXJpYy4g
VG8gbWFrZQ0Kc3VyZSBpdCBkb2Vzbid0IGNvbWUgb2ZmIGFzIGEgcHJlbWF0dXJlIGltcGxlbWVu
dGF0aW9uLg0K

