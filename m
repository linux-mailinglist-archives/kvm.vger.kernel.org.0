Return-Path: <kvm+bounces-20500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0619172D6
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 22:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE0701C220BD
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 20:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CF91779BA;
	Tue, 25 Jun 2024 20:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z9pmp+mu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF9C17E445;
	Tue, 25 Jun 2024 20:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348999; cv=fail; b=k8zDTm+kTcsMwNS1Yo5t4ICFN4PmHXN0GrYGE5WZ/WYn4vdJqJE1Hne3PFnGthkClEIEMPxOE7GfCCeABSBO49cFfINMrE/OTev09gaqU92iVy0ho3bDMvrkIHN+SQFk5HNL7FysY3Sa6NXCRBwO2ByzR2tbMXywFR28VZ/7pg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348999; c=relaxed/simple;
	bh=zr1FnP3dcRe+PnFwR322Y69jNuB1tJkiAz6W9XIYyEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nEw+pEzS3j3kV5eYuT+WJ4O6PqyceE7SY6mPZKW1TXVv7tx3pG1CfeJP83WObozi4BZgENzDpiOrpD7mVMzKDthiUfjK+a+Urfae1snqZHN2fr96BOxM36HfpZPKNLV8gQPmf99YpGFm0eg64jDCb9V7LfP/N2oy+fLTkxH0P6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z9pmp+mu; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719348997; x=1750884997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zr1FnP3dcRe+PnFwR322Y69jNuB1tJkiAz6W9XIYyEc=;
  b=Z9pmp+mutS5WQ5hEgw4YSYFVpx3zPuW0e7MwMnFV8hjBK8Zbvvx5tCBL
   CLr1/mPtenK9KmLzq7eZ7ma13SWrK45/aXFZ1uXh72liE5gXKovETvv0f
   1bAomy7JJFK6Ks7hsp9IkayUiaooaPpv6a8aBOAfmU7SpTdLTv9p0QUOY
   KH/+amYIj3Ludtc7FWNuoBZWQMt0VN50m/ZgUGgDQ8T6IzdZhUgr10tq9
   w6HbWIPn1FgdhjcqJm0mv7AbOGBk/SIFhBHGYkeXWsFT9dPx4Z3vPdZnp
   a9xFGHiqjSSof7QJHx95l/VXRd80+svdGqqR1veK6ZuUZ2v9GzpvG4J6e
   A==;
X-CSE-ConnectionGUID: QMEl2fmpSManx5KU+PpXNQ==
X-CSE-MsgGUID: ALhejdvjSlWp6dRF2kXBSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="33927126"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="33927126"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 13:56:37 -0700
X-CSE-ConnectionGUID: 6N6IcMftTbOq6Mh0eIaXVw==
X-CSE-MsgGUID: W+YJX7oSQ1Cn9p2CE6pseQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43866166"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 13:56:36 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 13:56:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 13:56:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 13:56:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYrH9mRog6TYImz4TnxLE4/gsDFDv1wVJGpfMARrPLvqMxXD+AgTN8K3M9id1cZAm34F8ASkYPBti+iU7zNg7emeraoDcya5gR4B21VPMme3qpV4Gh5ziiUroeExXvgQd0O3ZId08HSTq0vCe9CCJ0/dVMN8RJoyOnWN89VK99ohVlCQpXpqc3AxXSIhHa9cYzrt54RsujeuWOjeTS+AJpS89Z+2Py8du9spzcJHHI+5FeM78o6QtJvVEOYuTeQ1+J//zGDHVwDQN33dTVXk2bTp8KDdpLT9gb/Saquy1nTsE8nCylxspe1rUFyojIajNo6eg/DX5PQa9iCgxTCMCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zr1FnP3dcRe+PnFwR322Y69jNuB1tJkiAz6W9XIYyEc=;
 b=SdaWQMG4bFoEh7x0asTn7OrKbqWvqOxL8AGuZ2F4sNUs9ReJtUkdeExtegDgpE9cONVSOP44S70x+5k4ULtLG5z2+hsn/3hYWbjvkotONAg5Z1fnSTOhj0pKMlDgwlSip/yI7dmaQnacy32rdFhxWZ17hFDmvqw24LgzbuYrTFIMOyfv1ogt2Cf5JOS/kX5QOTq6M04UJ5qiiWgTOmcURLu8FT5KEL4K/fWnuUGar2Va18mdyfzNdVjC0zkXthgm/4MLKKWCvXxYswS+cftXHsZlVJJf9Xx6ZZP7bXBYRIbCpdUW7AM1YRFTimFBy4jy3xwTS8CnvpD6XS4IDwFb+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7312.namprd11.prod.outlook.com (2603:10b6:8:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 20:56:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 20:56:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Topic: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Index: AQHawpkmqvK9+rV8gk+Fb4hYJXFjCLHRzw4AgADIg4CABASjgIAA908AgAB1KwCAAPZwAA==
Date: Tue, 25 Jun 2024 20:56:33 +0000
Message-ID: <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
	 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
	 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
	 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
	 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
	 <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7312:EE_
x-ms-office365-filtering-correlation-id: 62982458-3e17-47be-b0b1-08dc95594bb7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|366014|376012|1800799022|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?Y2krejg3VHlBYXQybEpQWmF2K1I5TnZ6Q1diMDVMYnYva2hQR25TeU1KMWI2?=
 =?utf-8?B?WHN4emhIVFRIMVBxQ1praTh0dEs5a3VEakw5VkxZVXp5MklpYWE5SWdTaW5D?=
 =?utf-8?B?Umlob3ZDTlg0TFVlR0VVenFQRVZWb3lma2pVTHh3K2phTTZGbGlSOUtGbXpD?=
 =?utf-8?B?UDVydG1HckVINm5IZHdXeExmTnc0L0NXVTdMUG1IbnVpREF1N0dSRGRveW96?=
 =?utf-8?B?UlRmSkZSOU5hRHhTNFd5dlNjeDNNMDNEK3M3V2FIK2o1U1lFd3NZTUFlRWRQ?=
 =?utf-8?B?MmFyQUZZc3BQYWducXJOWHlLTUdPMytidEg1UnBGSHFENWN0U3BmMVYyYUV5?=
 =?utf-8?B?d0ZPU1B6MU9VaWVFNUJBRXFtMXZkMVVsRE9YajZnQ1BiZjJZVk5QRUFlQ0RS?=
 =?utf-8?B?TjYwcXlUeVZBdkZHVHhTR1hXa0FUWmxlbmpac3dIRkhvTXcyUVp1VkFTOWhU?=
 =?utf-8?B?TTBxdnJsVWhJQ2dvcmoraGwvcHZ2NG9lQ3pxMjFBai9DVGFDdnViQnlKbnFm?=
 =?utf-8?B?bVlwRDFsOXppYmI0MlpzeFM1TitLd2FHSGdrR3JQWTI3U1Nsd3plU2Y2VVF5?=
 =?utf-8?B?dWdFYmJNbDRMWG11ZU8yTE5UY3NyWEUwUkc0RXN3bWtVdVlrdnFMVEZlbmxN?=
 =?utf-8?B?WTNsTnQ1NkhjYllIMEFaWlAxS1ptMnpJYVJ4dllzZDFSV1J1OENTY0Z3THRw?=
 =?utf-8?B?aWZ2UTM1b3pjWHZBem9CVE5nRmdOZUJJZ3NrV255UHIxLzNVVGVoZktka1Iw?=
 =?utf-8?B?NE42R1ZNdFFleDc2bE15SGZma1lOTi95bDMrVll2Rk1sT2JCd1dQRFZTQXEy?=
 =?utf-8?B?NDNjZis3eWZXTTQ0Wnh1MDJLRWczWGRoVk9jWmp2ZnFXS1h5VlRhWlZCZFB1?=
 =?utf-8?B?VW9DWHE2Q3l6VWtkcUpoUjBXWFIyWDNqaWhreFFPUE9OOXYvSFFWVmRRNW4w?=
 =?utf-8?B?NUpqeEZaQ3JtZDVqTWgxVysyU2ltV0ZoQlp2WUQ0L1licldWdWNGcXFtaWJu?=
 =?utf-8?B?cGZPZ2hhUnp4akxJRS9abTBrb1VSNmE5Yjg1aE10RE5FK0M2MytycXIvVjBn?=
 =?utf-8?B?VXpDVlpzaVM3R3Frb0c4WXFFSi9YMzV1VmRUVjEwMDFrSUhYYVFFOFhnSytS?=
 =?utf-8?B?dnArZ3VET2ZWakZ3YXk4cVZxMGN6MzRyWno4NzJsdXl1NTRKQVc3ODVVRmhO?=
 =?utf-8?B?WVQ1aWhBQldHWFFYaFRjUEtIdFhZdTVpeDJRRGF3dmo4REZzR0FuQW5VZDl6?=
 =?utf-8?B?b0svUGxVN0kzR1hIU2I0enJKbTQ2NjdmWTc0c3lBSDhTME9YTzcvdytaMFYy?=
 =?utf-8?B?U3crUEQyck1LZXAzR2tENDFrNDMzS2R6UW05QTBkVjF5SjlvSHh4REZXYzV2?=
 =?utf-8?B?Z1JkUDVtYXRjbG5qTVU5RGxlbE1PVUdWclZIblhaUU5HYm56bWYzdzhrNXpG?=
 =?utf-8?B?bzRJTWx0TnJPVWQvUGc0OXE3OEt5OWpYR3hzTDZwNEtsbzRLSlh5WUhTMTZW?=
 =?utf-8?B?eUVOT0lPM3pYaGh3Q1NwQzN5c3lxUFNlbmNpcVFZTWhIZkQwRlJqRERtMWU1?=
 =?utf-8?B?Myt2KzhjOCtaZUh1SnRZcDBiMzNiUGlPRUJwOHBWb2QrdzhIMURLMmg5UDA5?=
 =?utf-8?B?WWpiN1U2ZUVqTGVyeDV0bXRqT3RzMGc0QUZ3bDIwQkh5RHkwZWs0Yk1mNHVx?=
 =?utf-8?B?aFRxb1NxQ0FRN0xHYzRibDk2UHczWGhLWFc4ZVRweXZLRFNmRHIycGxYb0lo?=
 =?utf-8?B?d3F3SVpaelY2aWNwZTJRcktnQVl3OVlaekQyc2luSWlIdUErWEFzMU9yZVVJ?=
 =?utf-8?B?b0NkTjFVRFJLRFJKQ2xEV2VNa0hmSkdlNG5wMXF3dWJ1MTdDU08xVGFrVEZC?=
 =?utf-8?B?NEtoZ2lOY1NFdnpNZW9RV1oyZitzSWZTbUV1azZZVzU3b1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmRvS0Rrckt4WjJvRElzUnZlV294dlNVck9uR2tKd3dkSXR4RlBrM2w3V3lw?=
 =?utf-8?B?ZEErN3p1cHQ5WUZXdWdJTHU4ekx4UU13QUxIblg0OHJFSnk1blZRNW5aaXFF?=
 =?utf-8?B?TDNFZWVySmkrTEtEbWZ1eEZXN2UrdWZ3NDNYNU5seDdINXVBaUdGNDYyUzVa?=
 =?utf-8?B?RDVZQmx2aVFjVlhQc1pTUy94dzVPL0tPdFFmNkVNQkZTY1FBMnhGNGZOeGwz?=
 =?utf-8?B?WlFzaHhIUndna2hmY3c5NXZPUStud2U5Rk1vQTR2T3V2aFBMUWhWUzg1UWUy?=
 =?utf-8?B?eUZweHRIWGdTZXpaamE1N2tkMk0yNnE0bWRDRWFscW1LbEhHK2t4TUwyY2Vy?=
 =?utf-8?B?SVRGMmRpaU13blVDVmhQOGw0SzFoTmV0TmVNdzRVQ3NVREtKMFhkYXBieFB4?=
 =?utf-8?B?bFF2eGtXN1ljbmsxeU1iZ2w2emNzaXJvZGtnRmZqSTlJSDUxZjVOc1pNeEpR?=
 =?utf-8?B?QWpaZjJ6N3JIUWh0dHVTYk5nbUNnaGwyMDQxek5KZDJYT2hENlczM285VTI2?=
 =?utf-8?B?MkNOdnBMUms2NEEwWUhRVk5NaFAyMWZpdmZabk55RXlKQnFnb0pZQkNPeGE0?=
 =?utf-8?B?ZWVIVUlvK3pEOEtxbFMxYmRYYmxjRjQ5YjRyZXhnUnZZcmFEMUtZRGliVTFU?=
 =?utf-8?B?ZDdjc1FXRWt0bitoMjc1U3JYTUVSNnNsdVVabUpBZjBFTklTWHVERGMrMHgx?=
 =?utf-8?B?eVhEcWZFR2RRUklibTlQb1A0NnhSakFDdkNTNjBTZjdicHBYVXliV0c4eEFC?=
 =?utf-8?B?MGFTSWRLdUwwKytjRUtKUnVTQ3Jxc3prcFUyMytsV3VFZVdTRmR4dFYvRUYz?=
 =?utf-8?B?OU55MTRkRjJUNFc1ZjBQZEVIK3NqaG11S2NNUFFXTk9FUnIvOFRHV2pIc2Y3?=
 =?utf-8?B?NjFvS2hRUjdPMWcvak5neC9SZUEvQVdTb3NReTU2ZmdKZHhXNyt2SEU2clJy?=
 =?utf-8?B?Qk8zdytGVlZGTjZxSFZmaU5za3NiZTVVY09wVEpSVjdldExsUFJHTEQ4QXp3?=
 =?utf-8?B?bXhibW5EWkszMGRZL3dhWXlROEVnU2FsTEJqTFJBdGYrQTA0Z1JpdkR3WkN5?=
 =?utf-8?B?VXhCZnExd3BjdGFid05naUE2QTNSZjlPQXQ4QkZFUEl3ZGtLUnl4NkZtVXdT?=
 =?utf-8?B?T1M3WTJXazRGK0dhcWIxZFRBTk14UGc3SlhJQ0x6TGlGTURSbDdaQW9LUVgx?=
 =?utf-8?B?VEsvTWFjd2Vrb2JOZ2VxVDl5R1lnY3gxUjlCQ3liT0J3dVlaNGZrUm92VVU3?=
 =?utf-8?B?V1JPWWp1VXF0N3kxei9CcmlLVmtiN0RBdkIzVW5nbHAwRmlOVXN3WEx0OFJu?=
 =?utf-8?B?R3FxekNaMjBpdzJXeWlOZFUrRzhzMjVhamZ0eXhKaHBEajJueXYyb0FvL0FT?=
 =?utf-8?B?TG5qTEpTSk5HeXJDekNqcDZFaEh4aVloYW1GRmkrS2FRZnZMZEVydHZQWTZh?=
 =?utf-8?B?T3czV0tIdlN2OFRTWUJDWG53c0JCaGc5OVRYZGZsc0s4dUNRSmlPM0JTVVJ6?=
 =?utf-8?B?NTF4alJseXY4N2hqd1JiZGllQ0tVVXVWTEpiSlZsWXpFSS9XaXdWS3VLVWlW?=
 =?utf-8?B?QTJWTmp4Ky9Od0dWRjV6Z1AwME02aVphSEs3VGZiMVZ3OVVwcWxtbS9ucXJT?=
 =?utf-8?B?RGhsaDdtVHM3NUFHdWxlaFc1dE91Z1VVa2ptYkRIN3hvVTVCRW1wY0laWGZR?=
 =?utf-8?B?ZCtNV1ltRENLcTh4UllOWk1HNVZRUlZvb0pVUXY5aUw4SXBXMzVkTzhCclhQ?=
 =?utf-8?B?ZzFveE9VeU4wWThJTWorajRJUFRYSE1NZ2liS1ZqZ0J6NWFFRVVqc0pxS2d4?=
 =?utf-8?B?T3doOHNVYVNVc1hpTmlRSHVEWktsWXFtdFllS2N5RzgyMk83blZUdjNsaXE3?=
 =?utf-8?B?elpUVHNSM3ZLZTFweE9jUkVaUHU1Yms3Mk9qUXFLM0hsa1ZBMXBZcU9VeTZw?=
 =?utf-8?B?YjFKdXFTRnZLN3RvTS9CVmJxL090TGh0SVhWRFNJQ2l3VTJraThhdW0yNXdC?=
 =?utf-8?B?YkRHRGRNeVY4YURhMVJHTEpJMTl3UDdabi8xbk5EUGRwTDY1dnorSXZ0Ujhh?=
 =?utf-8?B?aURIazRrU0Zna1hIU1l3VVBxNHpmNEx6emRDRlBDaDJ1YzROTFF4NzFZNmdp?=
 =?utf-8?B?dVdrKzJZNll5MGhQL0JaVkt4TklVbmJIMXRIakxYRDMvajhsZXdaYnd4UDBL?=
 =?utf-8?Q?hsUHOzlPBloNZ8WKD1m3w/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <239702E8F3E1604B886E02BC8953D783@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62982458-3e17-47be-b0b1-08dc95594bb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 20:56:33.4390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6cnYLLpjZjJCAfzYsO4Vojv9EU0k0IfrUu7MrWRU1LYIPGW8QsbODjLO6RFV7WP4lw73cLR4rT8D+99jpV9j+pt/TF/P0C3SfwrvqOytWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7312
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDE0OjE0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBF
eHBsYWluIHdoeSBub3QgdG8gemFwIGludmFsaWQgbWlycm9yZWQgcm9vdHM/DQo+IE5vLiBFeHBs
YWluIHdoeSBub3QgdG8gemFwIGludmFsaWQgZGlyZWN0IHJvb3RzLg0KPiBKdXN0IHBhc3Npbmcg
S1ZNX0RJUkVDVF9ST09UUyB3aWxsIHphcCBvbmx5IHZhbGlkIGRpcmVjdCByb290cywgcmlnaHQ/
DQo+IFRoZSBvcmlnaW5hbCBrdm1fdGRwX21tdV96YXBfYWxsKCkgIlphcCBhbGwgcm9vdHMsIGlu
Y2x1ZGluZyBpbnZhbGlkIHJvb3RzIi4NCj4gSXQgbWlnaHQgYmUgYmV0dGVyIHRvIGV4cGxhaW4g
d2h5IG5vdCB0byB6YXAgaW52YWxpZCBkaXJlY3Qgcm9vdHMgaGVyZS4NCg0KSG1tLCByaWdodC4g
V2UgZG9uJ3QgYWN0dWFsbHkgaGF2ZSBlbnVtIHZhbHVlIHRvIGl0ZXJhdGUgYWxsIGRpcmVjdCBy
b290cyAodmFsaWQNCmFuZCBpbnZhbGlkKS4gV2UgY291bGQgY2hhbmdlIHRkcF9tbXVfcm9vdF9t
YXRjaCgpIHRvOg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJj
aC94ODYva3ZtL21tdS90ZHBfbW11LmMNCmluZGV4IDgzMjBiMDkzZmVmOS4uYmNkNzcxYTg4MzVm
IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMNCisrKyBiL2FyY2gveDg2
L2t2bS9tbXUvdGRwX21tdS5jDQpAQCAtOTgsOCArOTgsOCBAQCBzdGF0aWMgYm9vbCB0ZHBfbW11
X3Jvb3RfbWF0Y2goc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCwNCiAgICAgICAgaWYgKFdBUk5f
T05fT05DRSghKHR5cGVzICYgS1ZNX1ZBTElEX1JPT1RTKSkpDQogICAgICAgICAgICAgICAgcmV0
dXJuIGZhbHNlOw0KIA0KLSAgICAgICBpZiAocm9vdC0+cm9sZS5pbnZhbGlkKQ0KLSAgICAgICAg
ICAgICAgIHJldHVybiB0eXBlcyAmIEtWTV9JTlZBTElEX1JPT1RTOw0KKyAgICAgICBpZiAocm9v
dC0+cm9sZS5pbnZhbGlkICYmICEodHlwZXMgJiBLVk1fSU5WQUxJRF9ST09UUykpDQorICAgICAg
ICAgICAgICAgcmV0dXJuIGZhbHNlOw0KICAgICAgICBpZiAobGlrZWx5KCFpc19taXJyb3Jfc3Ao
cm9vdCkpKQ0KICAgICAgICAgICAgICAgIHJldHVybiB0eXBlcyAmIEtWTV9ESVJFQ1RfUk9PVFM7
DQogDQpNYXliZSBiZXR0ZXIgdGhhbiBhIGNvbW1lbnQuLi4/IE5lZWQgdG8gcHV0IHRoZSB3aG9s
ZSB0aGluZyB0b2dldGhlciBhbmQgdGVzdCBpdA0Kc3RpbGwuDQo=

