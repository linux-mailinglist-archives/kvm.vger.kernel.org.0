Return-Path: <kvm+bounces-46383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C92BAB5D8A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 598853AF333
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3022C0302;
	Tue, 13 May 2025 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSlku8fs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A381F2BAE;
	Tue, 13 May 2025 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747167018; cv=fail; b=LOvCGo6LUqa5WPES6pGriXtx2UMc3hhoJW5TsY/3IFLPHmzZML3qslbUKhuxrNcjgmCzRifdIIx50cJCD8e90XrmCV5CrYvWDOYuizwTkdW3c2yzFn3Nnl/9fdn7SN14HNJJi0q1OU596YOLUCuX/uHwuGq1RdeaDkhA84j7364=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747167018; c=relaxed/simple;
	bh=OU6uj/EvPyStBcweciiqARJjd6eaHp1eo5AxakZ4X2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mViCfUEUy1isMiV6Z/c67S3/uUIclF4C4QTsQFSIBU5h4f+fH4zk4ECfVqpqN8CSnEJsz4SWe3BtO9D7VBfo6a646JijTHmLM8slwIMC0NLDeYIEWWsLBluMzIe4Z9F9vNYPW6iCNhWB53ZkoupHxuKiFS6fG1Qr6/8Op8noL6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSlku8fs; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747167016; x=1778703016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OU6uj/EvPyStBcweciiqARJjd6eaHp1eo5AxakZ4X2U=;
  b=aSlku8fsTM3GwpuARtz4JkN0QHRNfXF0awuv+jeynWpBFOz+zGGl08DR
   ZFgmghauPaP5EM4cGqtk5DDqo59DrFQ5YAr7417bd9kGf/s/aY5fH3oj1
   S/8ogRi8xMEuw9EjYZ5R9SAGg/KJpxUFJhe2U2dm15Zq1UBDiOIH4wU1j
   NFEuOhN27mD3wW9rlrLfwgSUA2TT32DGo7jFEej21GSJkPGIdzYB85uyE
   BnRFEbs9kJBH46kUFHQ9Y55evGb6vUzln0X8WObSQVXJTfl/+3AUWFoag
   Kg/mvxtETuP3GuZNDUgRxkwpeUaBAscyrUnC7EHbp3ES5wzHUzV6uZmTG
   w==;
X-CSE-ConnectionGUID: RGPFGekAQu6mPCosgVdtpQ==
X-CSE-MsgGUID: JerGAg3pTD28lGZJqoZ80Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="48908939"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="48908939"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:10:15 -0700
X-CSE-ConnectionGUID: q9tmMJ0dQ9CeGWBrHQbqIA==
X-CSE-MsgGUID: zYW82Vn6SpKHIC/WQQQXqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="168750335"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:10:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 13:10:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 13:10:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 13:10:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8RbX8/6gVw0zsX2CMCRHgumU09U/EasBwExW+0LkWn0GMGLdUBf1qdtUY+4w/l/QPSl+PxPp91M2FwIPDqjfu0hpCXiBC1ASIU1MFonzZFwmLywTYkyGhq4lxGVSwqf2C8FEiwlWTM3NLLHuL1bfWXTgKOVsHO/cvObG4KtBPBBvW1hQ8A2ts9fqHU/bHgh5dSbfoPYdrZKy0DQqX7skR4CeVJECiBI9AavJ8alVU+Pj9DZErsHKdzyQTYu/6WatjBwSL8ycxUGtt5Jej38qeLCWDl9SmUOQgMgpAb3zcXjeTWwVU0Pogb3g7isrkbF6Cd4krVCRGBjDt6GaVY5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OU6uj/EvPyStBcweciiqARJjd6eaHp1eo5AxakZ4X2U=;
 b=nAXvjC3EZDtXtM3mMRkoLVSXGFh+QMYy5cMdevJ5eYgJBtnOnrH6jhsuJnGgQnzYg6Vq8veKxzvBNYnkkvatEbu/UdyGk/xh4sItOOvrXICF5jeedHex1p4zv9/0fFzGL+EiurC5zNV+DTl+w+EwvTlBAaIpZvJuAGZLgwdsECdLyDz04zCWK8XZFRCeCgvQYSOLeyyO3LUnrB5IlJl4p0FpZF/u7N6tea0+KYJhsM3LjKPt8/o45ee+O4MTOJKlD7c91e+W4PZifBKzO5hgqZ6RjPlsRqFcPZ5xqv5jaH34xjlWW63yy+wcnwgWSGEqUkg34VTyufp5INktnG1lMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7032.namprd11.prod.outlook.com (2603:10b6:303:227::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 20:10:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 20:10:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICA
Date: Tue, 13 May 2025 20:10:10 +0000
Message-ID: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030618.352-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7032:EE_
x-ms-office365-filtering-correlation-id: 7ccb924a-f1e7-40b0-8a40-08dd925a29e6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZWVwaTcvNDlsaEhpbVRVc3lWSTE0WVNNNjZ6aUZyc0lUVnRGa1VTYWFROEZj?=
 =?utf-8?B?dTZvV1BZckE4Q2swSW1RSzBITkZiRVA5UUFzd09UNENYQ0k5eVhIU3hsTHBB?=
 =?utf-8?B?SDNTMlJKZlo3cjNDTmhocXliMmljSTZPVDhzU0k1MmtiSmhiVG5Ea1BvbGRz?=
 =?utf-8?B?aEdVU1ZkR1o3dUtCWEt1dkJLZjBSTUE0UHJ0Ym9VcHN5dUp3bUpZSGwvNXhE?=
 =?utf-8?B?VjRDaTRpd0E5MDhrblF6aWdGcGlOSDhuTjRTVWtJWDN4Y1BVOWlqU3hVRU5r?=
 =?utf-8?B?dXNiWi9VVVh1MmtvZEpzYjBTZTFLSGM2N1ZZNFBqQlBGY3B3ak1jMWc3V0I2?=
 =?utf-8?B?V2hYK2xxRW5YV2E3d1g1eFpPRUVLTzk5TzBNT3pqMEt2d2lyWDNYTU9mb3hP?=
 =?utf-8?B?M2F6QThjcDR4UWUrSlNaWWl4OU9sNUk1N3RiZzRmYmc5Y2V1akhwZG8vQ0J1?=
 =?utf-8?B?QnVvZmI2UzR0NXFySG5EZFBqeDJJU1B2TGk0eFBzc21wWDNyRndDaCtMc0hy?=
 =?utf-8?B?OC83UnhZQ242YXhsRkF3SFlGSW90aUxBK3hzS3dPYmZ1NVhjM0FWYTZHMEE0?=
 =?utf-8?B?b3NyRWxnaFQzVW05ZDgrSWtSb2xpMWk2QUhHUXU1eUNRTXgybm5uUFdEa29B?=
 =?utf-8?B?YWRTcjlwWkI5bm9LNlAvMktvYVRwUEhKT1l4WGJOdXNWdWxPMjVEb3dTYVFh?=
 =?utf-8?B?THV0ZUxmdldyRVgzOFpsSXYwKzZ0ejNpdWV5QkYvRXVQdGxQMjdSMEpaaXlo?=
 =?utf-8?B?ZTE5U1pMUDlnQ0d5a2ZJVVRyR211dVA4TGF4ay8zUVZNYjQvZ2FZcE16dTZr?=
 =?utf-8?B?by9vbGJ1WlVtT1RFdEU5UW1qRFdLYkhyTUZFUmFWZnhKeTBhTXRCQXl6Wktz?=
 =?utf-8?B?cCttZDdhRnNhNG9abktrZnVRb2JJTjA3d1o4cjJ2aFNoTUZSR05xMk9kMHY0?=
 =?utf-8?B?b2Vpa0pYdG54RXV0d21JckxESitKTTVGSFhOcXFnc1lxZDBxV1cyTEFDUTZT?=
 =?utf-8?B?Vk9sb0IzM3YwSTRacml6dDE2QmNTMGJvVzc2UnZxVERGNkJQYWZCbE53UzAy?=
 =?utf-8?B?Z1EwQnZuUEw3TU9YU3oydWd6Z0VJcXFGUUdCQmZ3SFYwb2R3OWU2RzlBYXAv?=
 =?utf-8?B?N2RESjZWejBGeGx1YjZZR3YwZEhpYkVmQms4eUcwODh5K0duQ2hkMGVuTFhD?=
 =?utf-8?B?UlM0ZldKMHU1MmcyeVZqTW8vSFIyRkxNcnYyUkFZRkhFSTNUYXdKQTJ6MFhW?=
 =?utf-8?B?ajM0VmlxL0VYY0E2djNMekZrdzNCclkvcE9RWmMzdVc2YmhTdWs4Nm5pVVlm?=
 =?utf-8?B?US9OTnR2ODZLK2sremRGM2pDb09rTE5WQlJGN0NkV3lqdEJJT2x4cDBDaUty?=
 =?utf-8?B?WEEyZHh4bHhnWG9nalowbTMxclBBMUNWNE5YRVd6bjRZL3QvMVpmYXd0RDJK?=
 =?utf-8?B?cHZoVEVNT3lKTEZXNlVBOVNFa0pVSWNLbVVBMU5ZTFhCMFBueGVRUk1sRGsx?=
 =?utf-8?B?UWtVN3dkejZiMGhxWmNvQy9ra1JKOUJBZUorV0lGUkg1YkE0ODdIazR0M01W?=
 =?utf-8?B?SmFwSS85NUgrNEdkMEJKSnBzQXc2NW82Q1Q3NEY5bDdna3lWbHQ5cTJzeGFr?=
 =?utf-8?B?NjFJYjFqZjdrTkFqaE4zM1pZZmFYYTFyNVR0R3hpQUZ1ZEZhQURVS1puTjBZ?=
 =?utf-8?B?c1Z3dXlSeWxBSUxxaGlqcmxZRzVrMndvZytlcEZqaDQ2SEl5dDduQkc2QkFZ?=
 =?utf-8?B?d05QaWU1R0IxOGlCd0huSkRiL1V3QkJVN0g2WTh2RTVmOHNWdjdEMElZdE44?=
 =?utf-8?B?K05kYnVHYk1ERjAzN0hidno3S21tc05XQ2pCL3gvTGxDeEVlK3c5bDU1dUVk?=
 =?utf-8?B?cDBrdURLMmRpd1ZqVHNidTJuWHRsTTZjclRvWjYvQU9wRmJXQ0pWRzhmQy9D?=
 =?utf-8?B?ckcrZjNWbXpyYVBxdlhqZVVuODRRQ1pBQkM5ZVQ3SEhJcU9qbXgwRnJLZ2xM?=
 =?utf-8?Q?RXQ3CYAlZmlEJpqgArwMW02Lpm/3vw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGd3YmVwSm5MTTVTYVNjYm5BcVlYRGc1aVJZQkZEUEdHb1paVzdmMGRsUzdW?=
 =?utf-8?B?R3hzdjdrMnpDY0tpdGVCc2gzY1RZWjhhbGRlMU83U3dTTU85SjBEK1Z4Ry9B?=
 =?utf-8?B?UUFyV0FlSExQTkZna2VVV0hHWVZ6Q0t5MzhUZ3NTRk54UzJCaWVTWDY1cHZG?=
 =?utf-8?B?bFlBbEFkRmhKR051VWVMTEVyTGpqcWdsVEF5MHdXMlMwRjlrOHlTNVRLdTdN?=
 =?utf-8?B?dUdjVjU0ejNpSVV0SlBLbzg3ZEQxTktra3BMSUNteUkrTFcreTJhUG1IKzcx?=
 =?utf-8?B?VG5hRVVIOWtENXplYTVLVXNteTVtN1YyNTBmU2laM252Z3JFeWIwRXJHT1hV?=
 =?utf-8?B?bERJWDN2ajE4VUwrUTNreUNsNXEwemRIUTNVK0VDNlFBMWxHSjA0anFzK0hJ?=
 =?utf-8?B?RllSZlZsbkFXb21FYzlwSFo4cENNSEdPVmFBMGM1RU9tQmQ0S1FiL2xlc3Zx?=
 =?utf-8?B?aGZndjd6MjJDemtkMzNsNU1zamIxMXFSUFhXQU5YTkwycnlzVExub3orM2tv?=
 =?utf-8?B?b3dXYStEQXJrMlNZekRFSDdrOHFndWZUdVRVZldxL25LZWw4dFNsdnB4V2pn?=
 =?utf-8?B?WmFJKzNROUw5Ym1hQUR6UUd0VER3bllCNnRoUUhuaStGOEliWDRieFZ0bVEv?=
 =?utf-8?B?OWI4ZGJEUEVhTTBzT0tYTDJFVjB0M3VLWklGdlU3U2o5YXJzSmhCRVFzY1pC?=
 =?utf-8?B?SkdhVXllZU00bVJ3cHBBRzJBTGNXdGZ4cFQyV0w0M3gyWFV4YjZ2cEE4d3dt?=
 =?utf-8?B?MTdtMG04MS8zRzNXaGtyYWE2RFhubjJ2WG9VUG9xaGIxemo1LytYMGtGU1VF?=
 =?utf-8?B?bVdmNTA2TjdIVE5JMU9CcWRjQU5YZUF1SVZhWitVeGJMb21Bd3FmaERFWUJk?=
 =?utf-8?B?UmZGUFBpcVhXZkMvQjQrSHZZVzlkY3FlekliV29yTEtFQjBDbFFKNU11eHhy?=
 =?utf-8?B?N0IzcS9Gem04NngvZkdLdVJZa3Qrd1pQWlhoN0M0Q3NPeEs5ZmF5U2gyc3Zz?=
 =?utf-8?B?bHIwUVUxbHJrRXM3WFNVc3ROcnltNURPSS9ERGdncDFwckd6TkJnZTJIZXJJ?=
 =?utf-8?B?M2prYWVCYkxFZGY0NjNjTXluRUs0a2Y2M2xYOVQ2NFRzM1JsZXB6S3JVaG9h?=
 =?utf-8?B?Tjkrakc5ejJXQk9zSG42THp1QVBySzBCMDZITjZIWEU1UERRaHZQdG54ZTNo?=
 =?utf-8?B?bE13MzU1UDV2YVhoZk5XL2JobUVCRVcrNFBJcERJazJqNEgyTGt6QVZmemRl?=
 =?utf-8?B?MW1QZHoxWXZpMmJ5TjlXZndZSzBienIxWmtGK1plSWw3N3UrSXkrVUNlajdD?=
 =?utf-8?B?MCtPOFhiTVI0MCtQN2VRRlpNZ1lRMGJsRjgydmtlZmdTeUNmZUsrNTNtM01X?=
 =?utf-8?B?UzBUWnRkM3NPSVFtWnlYUUJTUE1hZXBXYkEvRGt1Tk9GTU5ycWFiVFZkZTJq?=
 =?utf-8?B?bGYwM1RNSEM2c1J2TWxuY3R4T1N6TVJ5dXRYM0ZQai9XdTVMVHNVWjVoZklo?=
 =?utf-8?B?T3FxWnlGaEgvaUNWVFZEOXVqUGVBdzVOM21PSUFTdUp5dTcrbnptSGU4UHRJ?=
 =?utf-8?B?ZWs5cG1XMkl3WFBQLzhNZWl5QzNYWTUyNGlXTXJoM3hLRkhhWlAzeWZGUHg3?=
 =?utf-8?B?S1p3NFJjU09qNkhNZ1k3ZUpSa1VwdFpJdnhVaU9wOFJpcFhWdGZMT3JLdFNy?=
 =?utf-8?B?alVKQmZzUHA2VGt5QU44VFJBMUg4MEJ3SjRYeS93S2RkZkFQTHpRV0ZGMjlR?=
 =?utf-8?B?Wld5NjJ2OWJqbkpUcXIwMFB2SzBnR1FiMThTcEQ1UURKaTlTQ0ZJaEs4cFp2?=
 =?utf-8?B?UDJ2eE9iOEJweFZIME5qUDhBdWdnVTZubFFEQmpzNmhraEowWW05S0dtZkht?=
 =?utf-8?B?cVVhRFpyMTVtbzFQTkwwVnBVZ3liUUxTTmNQMTVpWXoyVnRaaEZDLzA0eHdr?=
 =?utf-8?B?N2VsVk56R0drQy9WUlAzc3ZaMWJWYVBTQ25na082SFZhNkJZMkFKT0x4VjZM?=
 =?utf-8?B?cUdCMmVGTVdXWDdxUUNFSWJZUUJWN3JaTDdsNTZoRnVNSTYwdjJnYmZnYmV5?=
 =?utf-8?B?SWRjWjJxemxZdHkyb2w5VGJMRXp1TVZyTnZ3Y1hIajFZc2FkdGNWUk9GQUNv?=
 =?utf-8?B?K1ZYNTNTZXNMNUhOajlxS1RZMjUwazJqSVg1dzR3QlFrd0NnVDNvUWJ2OUNz?=
 =?utf-8?Q?7codae4tHsB89MTPC/fsdZo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3C201031250B4488FB5C3B74208A43F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccb924a-f1e7-40b0-8a40-08dd925a29e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 20:10:10.3938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Sa07wfADQRpmX0i2nefSoWtRLzQJtDZSuUMfFK8Vq6RDDZwW2h41ouQo3DQkLvKWvVuxDtvXeeQmaFaR2mJ8EKJnXKT9ulsWPYHb3JYev8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7032
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQWxs
b3cgVERYJ3MgLnByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwgaG9vayB0byByZXR1cm4gMk1CIGFm
dGVyIHRoZSBURCBpcw0KPiBSVU5OQUJMRSwgZW5hYmxpbmcgS1ZNIHRvIG1hcCBURFggcHJpdmF0
ZSBwYWdlcyBhdCB0aGUgMk1CIGxldmVsLiBSZW1vdmUNCj4gVE9ET3MgYW5kIGFkanVzdCBLVk1f
QlVHX09OKClzIGFjY29yZGluZ2x5Lg0KPiANCj4gTm90ZTogSW5zdGVhZCBvZiBwbGFjaW5nIHRo
aXMgcGF0Y2ggYXQgdGhlIHRhaWwgb2YgdGhlIHNlcmllcywgaXQncw0KPiBwb3NpdGlvbmVkIGhl
cmUgdG8gc2hvdyB0aGUgY29kZSBjaGFuZ2VzIGZvciBiYXNpYyBtYXBwaW5nIG9mIHByaXZhdGUg
aHVnZQ0KPiBwYWdlcyAoaS5lLiwgdHJhbnNpdGlvbmluZyBmcm9tIG5vbi1wcmVzZW50IHRvIHBy
ZXNlbnQpLg0KPiANCj4gSG93ZXZlciwgc2luY2UgdGhpcyBwYXRjaCBhbHNvIGFsbG93cyBLVk0g
dG8gdHJpZ2dlciB0aGUgbWVyZ2luZyBvZiBzbWFsbA0KPiBlbnRyaWVzIGludG8gYSBodWdlIGxl
YWYgZW50cnkgb3IgdGhlIHNwbGl0dGluZyBvZiBhIGh1Z2UgbGVhZiBlbnRyeSBpbnRvDQo+IHNt
YWxsIGVudHJpZXMsIGVycm9ycyBhcmUgZXhwZWN0ZWQgaWYgYW55IG9mIHRoZXNlIG9wZXJhdGlv
bnMgYXJlIHRyaWdnZXJlZA0KPiBkdWUgdG8gdGhlIGN1cnJlbnQgbGFjayBvZiBzcGxpdHRpbmcv
bWVyZ2luZyBzdXBwb3J0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lhbyBMaSA8eGlhb3lh
by5saUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55
YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFv
QGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jIHwgMTYgKysrKysr
Ky0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94
ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCBlMjNkY2U1OWZjNzIuLjZiM2E4ZjNlNmM5YyAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0v
dm14L3RkeC5jDQo+IEBAIC0xNTYxLDEwICsxNTYxLDYgQEAgaW50IHRkeF9zZXB0X3NldF9wcml2
YXRlX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ICAJc3RydWN0IGt2bV90ZHgg
Kmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+ICAJc3RydWN0IHBhZ2UgKnBhZ2UgPSBwZm5f
dG9fcGFnZShwZm4pOw0KPiAgDQo+IC0JLyogVE9ETzogaGFuZGxlIGxhcmdlIHBhZ2VzLiAqLw0K
PiAtCWlmIChLVk1fQlVHX09OKGxldmVsICE9IFBHX0xFVkVMXzRLLCBrdm0pKQ0KPiAtCQlyZXR1
cm4gLUVJTlZBTDsNCj4gLQ0KPiAgCS8qDQo+ICAJICogQmVjYXVzZSBndWVzdF9tZW1mZCBkb2Vz
bid0IHN1cHBvcnQgcGFnZSBtaWdyYXRpb24gd2l0aA0KPiAgCSAqIGFfb3BzLT5taWdyYXRlX2Zv
bGlvICh5ZXQpLCBubyBjYWxsYmFjayBpcyB0cmlnZ2VyZWQgZm9yIEtWTSBvbiBwYWdlDQo+IEBA
IC0xNjEyLDggKzE2MDgsNyBAQCBzdGF0aWMgaW50IHRkeF9zZXB0X2Ryb3BfcHJpdmF0ZV9zcHRl
KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCWdwYV90IGdwYSA9IGdmbl90b19ncGEo
Z2ZuKTsNCj4gIAl1NjQgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGU7DQo+ICANCj4gLQkvKiBUT0RP
OiBoYW5kbGUgbGFyZ2UgcGFnZXMuICovDQo+IC0JaWYgKEtWTV9CVUdfT04obGV2ZWwgIT0gUEdf
TEVWRUxfNEssIGt2bSkpDQo+ICsJaWYgKEtWTV9CVUdfT04oa3ZtX3RkeC0+c3RhdGUgIT0gVERf
U1RBVEVfUlVOTkFCTEUgJiYgbGV2ZWwgIT0gUEdfTEVWRUxfNEssIGt2bSkpDQoNCkl0J3Mgbm90
IGNsZWFyIHdoeSBzb21lIG9mIHRoZXNlIHdhcm5pbmdzIGFyZSBoZXJlIGFuZCBzb21lIGFyZSBp
biBwYXRjaCA0Lg0KDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+ICAJaWYgKEtWTV9CVUdf
T04oIWlzX2hraWRfYXNzaWduZWQoa3ZtX3RkeCksIGt2bSkpDQo+IEBAIC0xNzE0LDggKzE3MDks
OCBAQCBzdGF0aWMgaW50IHRkeF9zZXB0X3phcF9wcml2YXRlX3NwdGUoc3RydWN0IGt2bSAqa3Zt
LCBnZm5fdCBnZm4sDQo+ICAJZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pICYgS1ZNX0hQQUdF
X01BU0sobGV2ZWwpOw0KPiAgCXU2NCBlcnIsIGVudHJ5LCBsZXZlbF9zdGF0ZTsNCj4gIA0KPiAt
CS8qIEZvciBub3cgbGFyZ2UgcGFnZSBpc24ndCBzdXBwb3J0ZWQgeWV0LiAqLw0KPiAtCVdBUk5f
T05fT05DRShsZXZlbCAhPSBQR19MRVZFTF80Syk7DQo+ICsJLyogQmVmb3JlIFREIHJ1bm5hYmxl
LCBsYXJnZSBwYWdlIGlzIG5vdCBzdXBwb3J0ZWQgKi8NCj4gKwlXQVJOX09OX09OQ0Uoa3ZtX3Rk
eC0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUgJiYgbGV2ZWwgIT0gUEdfTEVWRUxfNEspOw0K
PiAgDQo+ICAJZXJyID0gdGRoX21lbV9yYW5nZV9ibG9jaygma3ZtX3RkeC0+dGQsIGdwYSwgdGR4
X2xldmVsLCAmZW50cnksICZsZXZlbF9zdGF0ZSk7DQo+ICANCj4gQEAgLTE4MTcsNiArMTgxMiw5
IEBAIGludCB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2Zu
X3QgZ2ZuLA0KPiAgCXN0cnVjdCBwYWdlICpwYWdlID0gcGZuX3RvX3BhZ2UocGZuKTsNCj4gIAlp
bnQgcmV0Ow0KPiAgDQo+ICsJV0FSTl9PTl9PTkNFKGZvbGlvX3BhZ2VfaWR4KHBhZ2VfZm9saW8o
cGFnZSksIHBhZ2UpICsgS1ZNX1BBR0VTX1BFUl9IUEFHRShsZXZlbCkgPg0KPiArCQkgICAgIGZv
bGlvX25yX3BhZ2VzKHBhZ2VfZm9saW8ocGFnZSkpKTsNCj4gKw0KPiAgCS8qDQo+ICAJICogSEtJ
RCBpcyByZWxlYXNlZCBhZnRlciBhbGwgcHJpdmF0ZSBwYWdlcyBoYXZlIGJlZW4gcmVtb3ZlZCwg
YW5kIHNldA0KPiAgCSAqIGJlZm9yZSBhbnkgbWlnaHQgYmUgcG9wdWxhdGVkLiBXYXJuIGlmIHph
cHBpbmcgaXMgYXR0ZW1wdGVkIHdoZW4NCj4gQEAgLTMyNjUsNyArMzI2Myw3IEBAIGludCB0ZHhf
Z21lbV9wcml2YXRlX21heF9tYXBwaW5nX2xldmVsKHN0cnVjdCBrdm0gKmt2bSwga3ZtX3Bmbl90
IHBmbikNCj4gIAlpZiAodW5saWtlbHkodG9fa3ZtX3RkeChrdm0pLT5zdGF0ZSAhPSBURF9TVEFU
RV9SVU5OQUJMRSkpDQo+ICAJCXJldHVybiBQR19MRVZFTF80SzsNCj4gIA0KPiAtCXJldHVybiBQ
R19MRVZFTF80SzsNCj4gKwlyZXR1cm4gUEdfTEVWRUxfMk07DQoNCk1heWJlIGNvbWJpbmUgdGhp
cyB3aXRoIHBhdGNoIDQsIG9yIHNwbGl0IHRoZW0gaW50byBzZW5zaWJsZSBjYXRlZ29yaWVzLg0K
DQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbnQgdGR4X29ubGluZV9jcHUodW5zaWduZWQgaW50IGNw
dSkNCg0K

