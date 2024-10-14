Return-Path: <kvm+bounces-28761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403CD99C9BA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0547F283D22
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE10B19F43B;
	Mon, 14 Oct 2024 12:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SV2qtJzU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AA019E806;
	Mon, 14 Oct 2024 12:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728907851; cv=fail; b=lIJPpL7nOjn3gSKkD5ZLvO5zLvjSEEDEw9Kocwgsznt1mgtS1sx5+lcqvRaT6xMEOhNDFEX931aXEGIvm0p6i06IZq7ce9bHNQfVVR5n/RPVqAI6K45YOU04pC2hThjn/slSFA7KrQizbmDyvi1DX5YEuxs1jTcuPYREaTNGH+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728907851; c=relaxed/simple;
	bh=XvUTUyDPnwPqoOUwEuq0trxOV1EfpZ4fsBoMfYlWgJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A8CWVbo4ap4AecT1aFvZ8oi8xFC7Inby5UhQ+Yk929RHwX18NTx5RhTNm2C+VApK7BVgAJmbDe8RKqytwzfyuRsn6ACapOXTe6rhJyDuFgadPOM7n/gVRg91Nv/2XqhePqoYZYqVBYEFk7oVWmZoD7LcLO3ma6+t7uiW4ktLA/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SV2qtJzU; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728907849; x=1760443849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XvUTUyDPnwPqoOUwEuq0trxOV1EfpZ4fsBoMfYlWgJI=;
  b=SV2qtJzUCIv1/Lsb93HMxZMEoZzn8vLKeRC75VxVFJuTXSatCSjpHKbB
   qCdxZRTf92vMkUBpyvE1/XQwHVjKgljfs2Lt+KK7NZkItgEy+MfTaQUno
   9PjS1IceZbG9mCN0cWaB4xtmbTj9lSgR6bDHQ6fvoBsT+skkGsbgnFGVa
   3KTYBukvVi0TIQezdJbZNr/fVn2YgPcnXWsI96+CmWBQlkBecGQAp3K74
   K4W5pfyBbx0qmtOiXYHoewlzrxcllSdueTFQRqBSLaPxZwPvxtoDM37ix
   0Rj43GGzhsfTuDmJrfLs12IOm3P4kYAauPmPvLNUxVTJIF6iOHwWkL2j/
   w==;
X-CSE-ConnectionGUID: Kk+sYqcYTcOQdenH0+uRhA==
X-CSE-MsgGUID: s1HJXsJYTwyO44meoRkiJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="27738708"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="27738708"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 05:10:48 -0700
X-CSE-ConnectionGUID: oLfKFiGaS8yquMiNKqGHng==
X-CSE-MsgGUID: pR6NY98YSLWdl6eVgmM4Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="78002645"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 05:10:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 05:10:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 05:10:47 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 05:10:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyt/41q6shNVJDAUOkRr2bYS2AljinYpv1g51fZW90PkLeGgpeCgvVlIZEwhlzKjWfVrv87zJlRcx1Cl00VHTZhErqsDqq0jyXS0A12gEj+1oweMvdb3R7xwbInE3fwBFJE0MEVH31/rkgsyemAhw19O4XWoVVz9Wrq6tb1EsallVIFTOJE4ICpSJf7uziLmGEGr9iNTRYZ9XRUYJQq8EiUGjWzy5zfmLhwHuTH1At125L2k4WqYoA+PGnJ3b4gS3eDYzhMhK0Ro3VRazfbewZpv2t0TlCh7kMRaxAqB2vNcUKcfAeDyzCZX59z32ty6lHaj14wF9KKHCi5oCRaptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvUTUyDPnwPqoOUwEuq0trxOV1EfpZ4fsBoMfYlWgJI=;
 b=hEZXVWOfSvqXqbk9FmrWnixh+GAYwVGj/mKezDZ4yuXPMNZGcsUcJrpS1LwvIAKRS6WkiBgv0tIVPc28AbKCqz0Amk9lDF7pJVjJ6263p8fN/MaSjdUPDkyJKXEGc0R4ANWNXmiawDHOzVzQHiZLlpBmLfD1YWKe+kEZcnyr5pbzh9iROokTIRLcy2OzYitHGjBX5OWcXoVyCOwEL0A8u22qA//TQ33HDrOPAHecarqQ+2ym2NUsf6+/vnoRHpuQVigLRaplOxUVZ+IWeJCVriC6TS1kZTXyF3Y/Nq4UAbBWVn6rDF090TsvNCRSuM6K0cx1Zk8r6V1SQV7ay1dFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6880.namprd11.prod.outlook.com (2603:10b6:510:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Mon, 14 Oct
 2024 12:10:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 12:10:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] KVM: x86: Clean up MSR_IA32_APICBASE_BASE code
Thread-Topic: [PATCH 0/7] KVM: x86: Clean up MSR_IA32_APICBASE_BASE code
Thread-Index: AQHbGneeBfoVsGv7KkCJhnOHXAgFf7KGLzcA
Date: Mon, 14 Oct 2024 12:10:44 +0000
Message-ID: <b001ce8393f89090fcfd267db3cbf268c95c39b7.camel@intel.com>
References: <20241009181742.1128779-1-seanjc@google.com>
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6880:EE_
x-ms-office365-filtering-correlation-id: 109e6780-42c1-42e3-26fa-08dcec493af7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dkxaZjZqVU1nOUJleVI5Q3VTN3NjMFVqbnRpV3BUUWNwNWNVSUdvREZxeVdG?=
 =?utf-8?B?ejM5YkNjUHJVT2p5SWg5NnUwVkJzYkhzTElZOG5KM0FxQWpaZmVqVmhPaVdG?=
 =?utf-8?B?Wi9QZFBUSW1wYlpiUDBVbHdrNXhORXVydjR2Y0pCRWJDVmt2ZUxZU25sMGU4?=
 =?utf-8?B?bzBzdDRDejNRY3pKL2lmbytIdERBa0JNSmovSHM0bXZsSjRXakdNQkYvWk5q?=
 =?utf-8?B?cVo5WjZCbDhHbUhxemVNYVhGWjAyWHhpQWJEUERnVDJ2YmZuMnJFVjlOSXJJ?=
 =?utf-8?B?TVgzZmhURmpKcmRNNUcxSDI2d05TTmVhYlFaV0JmMkcyVUJMRUtSVWMxejVQ?=
 =?utf-8?B?RVVKTndvZmVSK0p0VkNWdGUzS3FnU2g3L3d5M0tMTFJEOFd2WU93WEdTUHhZ?=
 =?utf-8?B?NDMzcCtiK1BLeWJtMnJBOEpYWEJITHVCMDlhamtrVDQ1ZWxoT3h1Q0JCbUJq?=
 =?utf-8?B?NHZSVEJBL2V6K09zM2tyMXNsWEhhUk13bDRXcW92SkZzVlRDYXBBUjZUVVFM?=
 =?utf-8?B?TTY3ZlJ6NkFpM0lTdG1TMHNHVW85d2QxRVdCMkp0Y0NPSVlOSmYyWXFwVjR1?=
 =?utf-8?B?QW1lNWd2MHlFbmQveld5Mmc2MVNoOVo2cnBRci9aNUNMWnVOUjAzMUUzenA5?=
 =?utf-8?B?bUplSGlNVHRJZHZBb2Rlem14VnhZZjczdzRzSVRJL2UxUGl2dURRY3FVOGVy?=
 =?utf-8?B?MmZ6L0VWa1FVT2hvV0pYbGQ2NE0wZWpkdjF1dTZ3dVVqbGhUdm9IWTlwQVNU?=
 =?utf-8?B?U0hHZ0Vub3NIMGJXZkN6MkdwcXFYRVo4RjVGTXRaMC85bSsrMlBJK3VmSzg5?=
 =?utf-8?B?eU9jUDRwNjBhZG1TMk1UbDQ3TlE2NnltNk1YQjQrUy9Na0NGaERISGpSZVhP?=
 =?utf-8?B?bkI1ZWd3QXlTaUV2NlNXUW5YSVVueU5hbFRvMzNPaHZtS0VDRFhvQk9IMmcr?=
 =?utf-8?B?bE11SXRncVJ6S0t2UDV4WSs4MVBvNXREd3NlT1I1K0dINi9FU1A2TExseHBL?=
 =?utf-8?B?b3lEYTliNSswaU1hU1BNWDQ0K2NPQUQwWlpmUEhKaWxwdUg1L3ptdzRHbTZq?=
 =?utf-8?B?Qm5FYlJ3bDlQWE9wS05FbjZFTFVuZUphdlZpK0VHMUx6Z0l1N3ZJbnBJM25E?=
 =?utf-8?B?YW5uazRwbGx0ZXBKWW9yRDdwWkVpbmZGb0NERU1EeVBTc2FMQUtBendpMnVy?=
 =?utf-8?B?UnNyYi9hQ3Budzgzc2xwQ3ZHTUZ1V1hrNDVuZ3drSVl4SGtVKzBCZytNVnli?=
 =?utf-8?B?bTZ3U090R1I4aFJ4SVIyOS9iR0JhQ1h6QVVSbE5hS0FZZGZZOHFpeW5yRVcv?=
 =?utf-8?B?YTU3RGJpV0tNVjUvdHpjaDJicnVjU3NtbTVGRHR1SGI0U2ZYb2x3TXAybm1u?=
 =?utf-8?B?a21YQ05jWkkyeWFiWXVPMEFNbCtwclZtN29ETk9mUzR2OGZkbUhNbmhDMVRT?=
 =?utf-8?B?M24vZi94cEdlTnlNenNwMXB2ZktwYmhGekpHZDZsRmFJYk00bk0wdVByYnAy?=
 =?utf-8?B?QWVGMmdQY2UrK0IwSEE1TXpYZVh1M0dLMjUyekhFSjd2ZHhqMWdhZHVFMXpP?=
 =?utf-8?B?VVEwdDFiWmYzSjROL0VML25FNTREZHNzL2x0TmRxMXo1Z0JqWG5MdUN4NW9B?=
 =?utf-8?B?N2paUlpKUXdGTmNlV1lWRG13elBCa2owMkUyVFhHcUUxazQ4ZGRodVNBNnlW?=
 =?utf-8?B?cVFTUzl5ejRtaDFLM2ZxbXA0OTduN3VWZE1RUVpPMnRydEZRdHRsYkdlQzlO?=
 =?utf-8?B?d0FXRmdIdHhNRFdnbGxHWmFua0FvM3lEamJPVWcwMkZjMEZhU3NOLzcyUzBu?=
 =?utf-8?B?a01qdXBpOHh0a3pGOGxnZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVVTc3RKa0VlY2xBZHZOekUxZ3VaU29PUGhNUUVGYWpaVUNSNnBQV2hVWE1X?=
 =?utf-8?B?VE02TUluSmZXT3pmN1U4dWRHRVNzcWtFR3RQYVJQR3hhVExWOGhpNUxNa0Ix?=
 =?utf-8?B?LzE2M01QMWpUaGtKUlJieXJjeGwrSmlDeVkzdTNZNEVRQmxGSHRDYVBJaEVY?=
 =?utf-8?B?cVA0cFZXdUg4djVteHdIRExCMFp5UUxCdDkvMFdhVVBFZnhJZUF0dE9qMDRH?=
 =?utf-8?B?bm5XbnpDMDVUSlZZV3lZWVhqR1doZ3JtZmNjbXgyTVRSbFNvcm90WGRSMVRm?=
 =?utf-8?B?cGlhcDRhLzBaSXErVEhaaDhGVVVtSkZnRXUrWmVGTGxJb3BySjNUM0kzRTRI?=
 =?utf-8?B?eHlpVWk4c0dFY2NldXRaNHJXSXBUM0d1VXBySDJRMjFCMkhyT2hhUW11Smlq?=
 =?utf-8?B?ak1MR050NE5aMy9LSDg5NWpNZkFQM3FySzl0a1daSHVvSTFqbHBJbGgvT2I1?=
 =?utf-8?B?OUwybkFldGx2WmMxZmM1OC81TTMxNEtuelh0WkV1WGp3UnE5N3dtRTdSR2Ra?=
 =?utf-8?B?bHdKVkRYWUxaRGRSNlRoZGxqKzdZTGtJUG1FQXhtQUhMMTMwRHFkVlQyaUs0?=
 =?utf-8?B?aTYyOTgvdGNzSU5BWDRKM3JQK3lMMlN5N2FpbFhGYXFqL1NnbGpHb0trbmZl?=
 =?utf-8?B?a3ZIMWpJb0lpcVZsUXFGT3Z2cGJiQWc5NVAzZVEydzF3alE0WkRLUVpZVU1T?=
 =?utf-8?B?a2FBRHNzZFhVU2VqWlRXeUlyU0tlODBwNjkyNzM1UkhlWDA3NFlFaUFGaGF1?=
 =?utf-8?B?c0gwZDRrQTZXU1lpUUFvZnpsUFVZSzJpR24ySnlDbEwyVko5d3h1R1hWeXYr?=
 =?utf-8?B?N3huMmJaV29XaGxTcCtsUCt6TGg0RVd0cStPSzVweklwcEcyZ2h1UnVLZHdy?=
 =?utf-8?B?b0tzZUx2NVlFRlpsZXN2aDZSUjd0aktTOUNtWS9zWThCcXZXeUVEN1FheXNH?=
 =?utf-8?B?QWlqaUZCMHdrOHVPckVkTCtMOGVWSjVWai9Bb2J0SDNzNjNtNENzTldiL0pQ?=
 =?utf-8?B?VnA0ZWJnZkVibUNFNllqZ0NITDBxalEycHZsbGZySWV5QUttUER5cnhGTVBC?=
 =?utf-8?B?ZGVOK2lqNDhucHZXRm5DQ3dDU05FNS9nWW9sL0o0VnpybjVJTklGdDYxQldq?=
 =?utf-8?B?ei8yNUNLcnBEaVY0TkJrQUpTTGRPQlBwbzROelp4OXdDam1IYm5VaGs5K2lt?=
 =?utf-8?B?NUtuQ3p5MDZ0V0NsWXl6bDRDZnFWY0RvQ1JFU1BJQ1hjSDdGSkR6dWQwL3Fv?=
 =?utf-8?B?ZGU2cVJ3eTdSaXZBbFE4Z0NLMGZzbFpoN3dneVVSeU5HUWlPUUFxNkpkV3RQ?=
 =?utf-8?B?a0dMRDVGRkdCKytTQm8wRXZpQnJWZ1BrYjQzLzN1V3lsdEJDSGlmRHVBSUp6?=
 =?utf-8?B?VmxrMUFhdHdsaFRabFZ4QUFTTnpObEJsLzhLekN1UHVuMEVGb1VvdTlNeldw?=
 =?utf-8?B?T00xOUJwM0JTcFNGYXF5RlBjemY5dGIzU3BVcXVTOXZZNjU3dVp3U2RMdjZB?=
 =?utf-8?B?KzlwR3U3NTczMmdvbGo0cTJOUG1HOWVuWjllNkdKL0Q0UWJMdFRPOG8vaWtQ?=
 =?utf-8?B?L3NjZnZLVHNNZUJiaC9oeVlHSWp1ZU5sZTNWaFRXYkNYNzNzUTFvYWl6THBU?=
 =?utf-8?B?dHc0M1dLWGU0anRDMUJUVndPNWNWVURLNnIxL1FWcEV2QmpQc3RaRE43aDda?=
 =?utf-8?B?a3FjanQzM1BSUmZ4YmhXcHhCVkwrVGNHV0U4RGlqdTZxUGhoNEtaQW5saDR2?=
 =?utf-8?B?c3o0cW5DdTJZQVl2WjdhY1cxRTR2QUhrL25PS1F3aFhkK0x2eTNYT3dOS0Fn?=
 =?utf-8?B?eHhTZkxqWmFIcnVDck9GUlpBMzJudXk4c2R5NEFHc0RrNXBUbjNMKzh1WG1O?=
 =?utf-8?B?eTc3d3JyUGFpV0RuNFIzTjgxZVVsV3dVaWlzdmZBWnllMzJBYUlMcU96OG5k?=
 =?utf-8?B?Z1RYRmxZbkZER3VWUXB0aXVieVBTVThjMmlXNnhEOHZCK095UnJESU9XQnVR?=
 =?utf-8?B?QTFKVEhZUmZ3QWhKZUJpYllIdWlFOElUK0lZN3kveWlySWFnYXN3c1oySW0z?=
 =?utf-8?B?TnlFWVNpS0ZnOVFzOTVUeStKbVJmeGQzNVg1QWhjYUx3b2REWXViQXNTbDFq?=
 =?utf-8?Q?P1okXadhD/BSqGEIJSMfTUW2m?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81E9EFF50C070B4EA5D177BDF89CCA10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109e6780-42c1-42e3-26fa-08dcec493af7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 12:10:44.5568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mjVkWEDrrUZGBdwDPVYJNiaMKmxaS+DvezdwFCMPKmeDRme22AjL749/h1wI7TWMPLZEWuaotx1HJM8YmmfI2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6880
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTA5IGF0IDExOjE3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBDbGVhbiB1cCBjb2RlIHJlbGF0ZWQgdG8gc2V0dGluZyBhbmQgZ2V0dGluZyBNU1Jf
SUEzMl9BUElDQkFTRV9CQVNFLg0KPiANCg0KRm9yIHRoaXMgc2VyaWVzLA0KDQpSZXZpZXdlZC1i
eTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

