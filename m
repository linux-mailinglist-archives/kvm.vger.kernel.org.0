Return-Path: <kvm+bounces-58193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD60B8B420
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C62A1A0812D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770062C327E;
	Fri, 19 Sep 2025 20:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JtZuMAW0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BD29BDAD;
	Fri, 19 Sep 2025 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315536; cv=fail; b=eHGboC/SAbire+L0HzBtwOdvnmdg/da1a49m0pxt3duS6CXiyH/tQe2g7eZNoBsRHpvS/enrCrZyFkz92Efz0mSFMt3862SWXUDrdeAuJSlVPncQmGG4FfoOlCJSzcNzBoM/TxKrp877oAXrAT/kyxpYzsHkhP7aw4DCfP21r44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315536; c=relaxed/simple;
	bh=j4G/e6kT4SjXOyf83ukPHgiP0eCAbA1OfUY3v3k4lMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wz3Bu4bg/RcnO9EMIgb/d9a7aDshbcHjSa+yxBdnI2Nu5GKg8GYjc04Z5jDGbU2/c4Xdkn1jGWV/wi8sXcswnnZq9uLwiobfbWb6rQxpaz7DvKX36WVmNYpOVD7zEibj+k6d+yEo9OrWtRKjrwvGH/fTIsS6bwXqQ2r89nHyz9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JtZuMAW0; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758315535; x=1789851535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j4G/e6kT4SjXOyf83ukPHgiP0eCAbA1OfUY3v3k4lMo=;
  b=JtZuMAW0/LuG6Ekga0AmLuji/4AfK1ogMVV9pJhWecIfX1tKfn0Z+agC
   GpxbFGA8I4gCacTqCGaBIAZH/156/sXHU4cRSIg1OYOOueLFOt6iVmrW+
   c9aMsR+MBpzUjBASb1NLBpXCSxGm5I8Oc2OSgWtldp5d+8qXJR9Hts7xI
   FOJ6NImNUXV7vdTtehSUI+7ajWRcrIt3lU9ikGL65Ep+5DvbU9s5ugQm/
   2SsSVSCFUoSRnh1E+svY3ztFwSzumMmJxHkuakb6CNx82g6EWZ2qeAt7E
   mk1dz+M+yfcN2jJJ6WaK5eMhdCZPdvxQ4SoaTXVlKjTgl6f6TnXraPt4G
   w==;
X-CSE-ConnectionGUID: AHhAhek3T/yCVqWbM9qA0w==
X-CSE-MsgGUID: UzlU4edNTqKj7d44eidfrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60823010"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="60823010"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 13:58:54 -0700
X-CSE-ConnectionGUID: F2fWMdEYSmCicF6CxQLXgg==
X-CSE-MsgGUID: g2gr68YJRuKPpCyRnlztfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="213078350"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 13:58:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 13:58:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 13:58:53 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 13:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=as9GaZ9xLm928EZROQKj+TFf6ybRN638LaVR2n6B/HVv8EbIGJBlAblUc6XopP/cVhFy3Wqp+kT76qry8xjw9EgaAZ7n67fPDV427A0fwnM6cSwHnrkwKCg3L6C4N4fjPY7zjv0NOOpaC0w+WSqZPhmuF22JFj8h47J5ibA4oRtmoBK7hj9bJYiJPQHivVCFkJM9hF1fkSmPJ5Sau4c+bLYNV0Hq8bcar9q7IpPsr+cMhwWOOWELgAiN3gizL3uy8dZpSatA+ycixSmUHKswIJLMAgco6BqnE1ZBk9pTEajg3hMvOFX2tEzaTZ/E9xbm71UCFNPiE9Nh3clbh0NsCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4G/e6kT4SjXOyf83ukPHgiP0eCAbA1OfUY3v3k4lMo=;
 b=eE0leERA7BEZvGRg9NjIlG3sCh5UPrsOJ/RVsMGtKwQ8YX8k49kI0wYaa61SP4/M96mwpegsIVbtUwsn/qpy1ECdzSG5IeF1g24/izaUk1I1KINiOMf38lDhHeArv5nqJNOQFvfa32H4UVKXptL4IDcjnpx4D5qGKonxewaRHdAbT5mxcmbu2RRVh8+KPy/MUNyJYL3M7/n7lhLLqmEtEgGo7Hjyx8WsVuNKSdjmR8LuMIsBmeyzsYPbcybcI5veSAGoy7pzm4G+PnW/gKQjRb2IPH0c2W8rR1MEZ6u54OrTu38g3n+8amXkL7t2Po5AOvcaT8f4OKHM/8kgjGixuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6749.namprd11.prod.outlook.com (2603:10b6:806:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 20:58:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 20:58:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "john.allen@amd.com" <john.allen@amd.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "minipli@grsecurity.net"
	<minipli@grsecurity.net>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Topic: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Index: AQHcJDxrz3xGOm0mWkiTyxf0AvaeS7SWLnQAgAAQWgCAAArpgIAAEmYAgAAVbYCAAvB+gIAADMgAgAACsoCAAAr2gIAABUiAgAAKAACAAQGjgIAAQAgAgAA6fIA=
Date: Fri, 19 Sep 2025 20:58:45 +0000
Message-ID: <ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com>
References: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
	 <aMnAVtWhxQipw9Er@google.com> <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
	 <aMnY7NqhhnMYqu7m@google.com> <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
	 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com> <aMxs2taghfiOQkTU@google.com>
	 <aMxvHbhsRn40x-4g@google.com> <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
	 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
	 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
	 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
	 <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
In-Reply-To: <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6749:EE_
x-ms-office365-filtering-correlation-id: 38bf4a92-5e0a-408c-457e-08ddf7bf530a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UzR3SVhISmRyRDIwYklINHkzWGMzandaVytUZDFIN1h4SnU1Z1ZNYVEyVVZB?=
 =?utf-8?B?Z0dXdFc2a3dQWE4weTlsNkU1VWpvNnpmcngzVUg2ZWl2K2ZHL2d1K2RaUDdC?=
 =?utf-8?B?OGl4YkpKTlZ6RjFoc2pLQXFsaklhaFpqU1liS21PSERmSTdxSTd6RXE1RmJl?=
 =?utf-8?B?M0VVcEhPS0tLZjRVUlVhUzFlTFE1UTVQdEJ3NU9PMUdTZmYySURuUDlWZ1Aw?=
 =?utf-8?B?SWZEVEZnSG51VkZXWVBYL1ZFWjdITmlWUitoNlRTWCtidzhTTGd6bHF0Mlg2?=
 =?utf-8?B?ZGtRMlNBNlpHdTdkNXVqUUZiTXgwWllPb3g0aE9VOWtUeFJmL1ZnNDlkNUM4?=
 =?utf-8?B?SDJOSWZWTXhyeENZZExrajI2RWZia0RhdlJMWjVJR3hKMjF1RGRSWVB0a3hy?=
 =?utf-8?B?WnZPdCtWWlJTQ1A4WUx3TW92ZFlIbFJLQkdwdEVOQkd2ZGRYb0RxQmxLMGZV?=
 =?utf-8?B?WnpXcW8xZVZvMjZHNS9iSmpXWjBVTEdPK0R1aTNzWjRpSFVFbVJ1OGRmZS9q?=
 =?utf-8?B?VmhpWkhMSjlTZ3hXdjZYU0s4K3M3Zmxva3Y0QkhiY3BaWXhscVN3UU9FTW1k?=
 =?utf-8?B?M29hVmFuK1pqQjVpakRWWjBkZTlDL1o3aTYxZUxyaktCUzhrdXZTZ2RmUVRh?=
 =?utf-8?B?MUZIUnZJeHlEVWVPUE5WTVJiSENCcUloY3FHWjAwYWk5Qmk5WlJXTmJJV2dv?=
 =?utf-8?B?OWJEM1UxWmlvZE4zWmY4TzVrQjVNeUg3VTlQTlJkYzRoWDA3M1p2QS9vVXhz?=
 =?utf-8?B?RFlXOFRDSnM4cjJIcEgrTFZvbDJ0ZW10UmhLWFNxb2UvR1FDeURyb1V5MGVQ?=
 =?utf-8?B?ektTZVBtbGlreFBnbUMzYkJWdzYzYlBSOG1uZkpCeGpwMFBLR1NianlKYjc3?=
 =?utf-8?B?Q0JzNk5SbEdWVlBZRXkvcUtYWTRaTll3MEN5ZXBKQmUwNFZOL0Y1Ti9EQVE1?=
 =?utf-8?B?WWNFelpLTEx6QlBPdmNCQkJFdG5TTExlY3BVL0QzSkNrVGF0TkF3VEhoZ1ZR?=
 =?utf-8?B?NUJ5bWlmQXI0WWpOTjA1YVlvaFM3MzhzOHFhakxEZGFBL1o1UFBkREtjbEtU?=
 =?utf-8?B?QzRxWkpGSkYrV2p1SHJ2MXlvZlpmV2pZTkVVT2YvMVNxSGVBYzRtUXljNVlR?=
 =?utf-8?B?bmd5RXlpaWJrQ3poQXd2SFB6S2JrOGw1c0YrQ3ZwZUxXek1NRDlxT0xLdHc5?=
 =?utf-8?B?NlJiemRjMWkwT013WjRLWjRyWEdhMFEweklvaU9YVGFMWGpHZTBidzRHNXhy?=
 =?utf-8?B?cnhJaHQvcHE2aVpGWjlEcHoxS2xvQm9vMHlTTmJhKzlRcXZwaU4rMmRlLzdy?=
 =?utf-8?B?andQbFB5Um9uTVFnaU9DUmZaODF4VFloZTZjaDJBTVRBNXZaajA5T2EwWml0?=
 =?utf-8?B?L0JiRVpEbnRpdkFFdzhrdTdzMUMzOERVT05rYVE2Z0NnVU1VcGM4YVh2dTZH?=
 =?utf-8?B?ODQ2VkJsRVkwd3B5NTJkaE5Qei80UTBaUUFTQTJrNzBWV1dFMVhLWWFES0lI?=
 =?utf-8?B?endQT0xJRzlROEQ0MnkrejVNakhiUGc4ZEJKVW81RWpXcjVXYlpKSjNBUmY2?=
 =?utf-8?B?MCtSL1U4Wlk1L2NuSnFUMXhwK1gwUFNlbm5JK2FaaGlPREcrdk5sR2doc2t1?=
 =?utf-8?B?ZFZBOUZCSHFwYWtLUEtuZHBiRkhqeEkxRVI2NXBrVFB1WWhYdjAyYWVVU1dv?=
 =?utf-8?B?d3BCYWF6a0J0MkgwNmpoZzBieFdOVXBiRGEzcXpkdnVRYnVKblp6ay8wNk8r?=
 =?utf-8?B?VjFwanVpZFNHcGMwNjBVdGE4TEpMUzhiWjdyVXhleHBEVjY1TndMUkIvenQ4?=
 =?utf-8?B?cDY0a3lNNWt0VjNaWTN0N2cvSXV4bmtYcjhtbnAvNUE4R3o3YXNHZDFVc0xp?=
 =?utf-8?B?Q0xudGFxNHpIVnIwd2NjcVVmVWF5NndYNUtaYnp3V1lxWDNYNEdGVUVNUmJQ?=
 =?utf-8?B?T1VsQjFTamJzZjFUalVTdlRwQUJDMzRNS2dTTzhrdVVBRWpod0pKejVwNWRL?=
 =?utf-8?B?MUVoSVdFSXRBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3MwMFhJUTJ2NVpqZEhBbDZNSUNTSTJOWjI2eEMrZzBwd0FwaVFhWThYVnVL?=
 =?utf-8?B?R1lhYVBBTnEzRm00K2VodTl2MWtVTjZId3FRd09TRXljM2ZXQkZMRVhNU1hS?=
 =?utf-8?B?ZmM1Y3dsMWxuY3VFdFhmblJRN2VZenNaTm5mMzI3dzdRS1ZEYkZtTmMyZktj?=
 =?utf-8?B?R2Vxb2lLZGRCUFd1ZEdOK2o2MzhvaGVoaGM5TDZKRURDYWI4dDdoY2xhbjVH?=
 =?utf-8?B?RWhNN3NSMmhOYnVNTlg5SjV2NUNwY2V2dk9xM3Y4ai9Vb3hWYTlRTnNmMFVk?=
 =?utf-8?B?dEFhU0pSdG9wMkJQSVdVT2NKT3ZKbDM1MkU3dm5GWE1lK0FXNkhoQS8rQ1My?=
 =?utf-8?B?UTdZZDdpR21rSWdnYVV3VkV2aWRNQ0xCRzlzZVYzTmdwRGE0WENNYzQxTVRE?=
 =?utf-8?B?SENmd3pPblZRSThBV3NXOTdpQmIzTGxBS2FDVXdMZVM0Z254ZTBMZFpPK3NP?=
 =?utf-8?B?ektTVmJ0UU9jeG5rZFFaTklua2Q1dlVyRXVoVnpsTEg0N2Z5RVFPNGRYaVQ4?=
 =?utf-8?B?cU16QzRoYVJGVUMxU2dRMmQ5UVI4UnVCNHkrbTVhV1Z1aWdTc3ovTWgyYVUr?=
 =?utf-8?B?ODJrK3ZROUFIaDFHMURzeFoyMER2cEswYmZ6eDh2Q1VzM2JJUEVVWENMTE93?=
 =?utf-8?B?QUVweE9hWjEyRjdZcFhaL1pvYjZaY00ybjlCVUVOdlIwYWNwZGJQRE9pQ1o0?=
 =?utf-8?B?MEdYLzdEQXV0b3dnbndUdk5jVHdoRE1FMkFzNUVYUU9sQzdkdmY5MjhBKzJt?=
 =?utf-8?B?Ykl6Q2VRWmxWNGg5TFRDM21oZnJXOWh5a29pdzRvc3BpQ3NIb3dKOXdOS3dP?=
 =?utf-8?B?dEVTWmE4ZjVvNnZiMEZWYXUzZU5QcVNUL1cyVFhsa0JEQitCMkFzWlltRkRl?=
 =?utf-8?B?aVpmK1Z4SDZMVHF4OVNGSmovWTJLeS91enBYUktld3hqTy9PVmd4VmNscDNZ?=
 =?utf-8?B?RVVZaS8zTGp0YmxlZlBZaHBPaGJYazY1bHFYT05HN2E5WUNjMnl0Q09jaDNP?=
 =?utf-8?B?KzVoaW5uT05GTzEydTM0enNUdkFIbS8rNEEzd3M3VFBRcVlsdUkvY3JJODV4?=
 =?utf-8?B?dnpSS3QwUllYa3RJMHpxTXpjYjJDdnQ2MnJsakpEWkxVaE9CeDQzU0NOdk9V?=
 =?utf-8?B?L01GN3k0VngwanIwb0NYRkRvNWhXcnNweG8yT0U4WTlPQ0FLRjF5V2hxcGpU?=
 =?utf-8?B?OXhmTEMyaU52NnBHaGlHako1OVVWL1F1eDNkVk5WQTAvVjYyUlR4aXZlRHN2?=
 =?utf-8?B?c0tLRWh1bzg5TThTQTZHKy9QRDVDYmhMbGNKN0VZVHRGd1dwQnNteHB4bnk1?=
 =?utf-8?B?S3FHenNuSE5hQ0psMGE3ZGdHZ1JlUWZaT2JEdzhPcGdNT2x0Z3VKeTh1Z29y?=
 =?utf-8?B?OTlhTWNFSW9QYUJncXJ0NGNncnFzZVZMbUVoOCtBaDhLbGNaQ0tDNG9kVkhG?=
 =?utf-8?B?NVZnb2JnYmVZQW5EbEhXMFZOU1BFM2w3dWRCUWMvVUNES3NyaEg4K1FDUmZJ?=
 =?utf-8?B?aDJGWjFsVDNGRVkyUVowZm42WFhNZXlpOEVXUXMvcGthaUsvaUJ5VFUveUJ5?=
 =?utf-8?B?UlprOUZYa1JFVzRDbVU5WXhxU3VxaVJ3bHFMaHBVYzg3cmVMc1NiMU5Jd3Zh?=
 =?utf-8?B?ZE9XaTVLYnhzQW01K2pZRnA4bmplVlo4VzVxMXJnNnFvQm5QZVp0M1p6SmYy?=
 =?utf-8?B?NFYyY3pPL2l3aFY2N09WU29pdzZyd0pDUnppVDRySk15L0FHSkVlZFBWYWtV?=
 =?utf-8?B?eFA3Y2JIN1VveVI2YlNBMk5TTmFBd2tZSnE5aHNiLzlBYzJPZUVRVnRrWmNv?=
 =?utf-8?B?RUQ1VGc5aTh0a0Q5VzdYbnl6LzFHenVRTGVwbmJrUVlteXNRTXViKzBJblR5?=
 =?utf-8?B?Yy9tVGhTdEY0dEJiazVqOEhaQnM1cFVMZXdqdUpMaXVGUG5MWmZUM3dIR2tD?=
 =?utf-8?B?Tk9sWnA3WnNOM0JBQ2VKajJxSlhnbFloS2VsdWZzNDV3Q0NwaUFyRlBDVnNp?=
 =?utf-8?B?Sm5wR2ptT1RiSUxKNGJ5bWQ5TmpiVXVvKy95QVZPeUl5OW5vcmMxS3lkWFA2?=
 =?utf-8?B?RzdESE8yVGl3ZEs4QUpnVENtLzc0RWtwd0RSck9xNGkzZTR4NTFOREtkaWdj?=
 =?utf-8?B?Y0RZRitORHh2eEtvOG9nZWIrK21qNUdUYXFHamZyTnZ0dHhWZnFUOC9aZ0Jv?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49396FC2A04E4C4C867C365DAC7D819E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bf4a92-5e0a-408c-457e-08ddf7bf530a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 20:58:45.9944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtyOkeCWORWiom4RGxwzHCPChcog5cZcYBnqvNgrBSfNsaqpCHq+wQk854PwgXE5/RFju9KU5fjcy+VFBblYhF78dfWHSc3rHiN28WBetVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6749
X-OriginatorOrg: intel.com

K0tpcnlsLCBhIENFVCBzZWxmdGVzdCB0aGF0IGRvZXMgaW50ODAgZmFpbHMgb24gU0VWLUVTLg0K
DQpPbiBGcmksIDIwMjUtMDktMTkgYXQgMTA6MjkgLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3Rl
Og0KPiBQUywgd2UgZG9uJ3Qgc3VwcG9ydCBDRVQgb24gVERYIGN1cnJlbnRseSBldmVuIHRob3Vn
aCBpdCBkb2Vzbid0IHJlcXVpcmUNCj4gZXZlcnl0aGluZyBpbiB0aGlzIHNlcmllcywgYnV0IEkg
anVzdCByZW1lbWJlcmVkIChmb3JlaGVhZCBzbGFwKSB0aGF0IG9uIHRoZSB3YXkNCj4gdXBzdHJl
YW0gdGhlIGV4dHJhIENFVC1URFggZXhjbHVzaW9uIGdvdCBwdWxsZWQgb3V0LiBBZnRlciB0aGlz
IHNlcmllcywgaXQgd291bGQNCj4gYmUgYWxsb3dlZCBpbiBURFggZ3Vlc3RzIGFzIHdlbGwuIFNv
IHdlIG5lZWQgdG8gZG8gdGhlIHNhbWUgdGVzdGluZyBpbiBURFguIExldA0KPiBtZSBzZWUgaG93
IHRoZSB0ZXN0IGdvZXMgaW4gVERYIGFuZCBnZXQgYmFjayB0byB5b3UuDQoNClRoZSB0ZXN0IHBh
c3NlcyBvbiBhIFREWCBndWVzdDoNCg0KW0lORk9dCW5ld19zc3AgPSA3ZjhjOGQ3ZmZmZjgsICpu
ZXdfc3NwID0gN2Y4YzhkODAwMDAxDQpbSU5GT10JY2hhbmdpbmcgc3NwIGZyb20gN2Y4YzhlMWZm
ZmYwIHRvIDdmOGM4ZDdmZmZmOA0KW0lORk9dCXNzcCBpcyBub3cgN2Y4YzhkODAwMDAwDQpbT0td
CVNoYWRvdyBzdGFjayBwaXZvdA0KW09LXQlTaGFkb3cgc3RhY2sgZmF1bHRzDQpbSU5GT10JQ29y
cnVwdGluZyBzaGFkb3cgc3RhY2sNCltJTkZPXQlHZW5lcmF0ZWQgc2hhZG93IHN0YWNrIHZpb2xh
dGlvbiBzdWNjZXNzZnVsbHkNCltPS10JU2hhZG93IHN0YWNrIHZpb2xhdGlvbiB0ZXN0DQpbSU5G
T10JR3VwIHJlYWQgLT4gc2hzdGsgYWNjZXNzIHN1Y2Nlc3MNCltJTkZPXQlHdXAgd3JpdGUgLT4g
c2hzdGsgYWNjZXNzIHN1Y2Nlc3MNCltJTkZPXQlWaW9sYXRpb24gZnJvbSBub3JtYWwgd3JpdGUN
CltJTkZPXQlHdXAgcmVhZCAtPiB3cml0ZSBhY2Nlc3Mgc3VjY2Vzcw0KW0lORk9dCVZpb2xhdGlv
biBmcm9tIG5vcm1hbCB3cml0ZQ0KW0lORk9dCUd1cCB3cml0ZSAtPiB3cml0ZSBhY2Nlc3Mgc3Vj
Y2Vzcw0KW0lORk9dCUNvdyBndXAgd3JpdGUgLT4gd3JpdGUgYWNjZXNzIHN1Y2Nlc3MNCltPS10J
U2hhZG93IGd1cCB0ZXN0DQpbSU5GT10JVmlvbGF0aW9uIGZyb20gc2hzdGsgYWNjZXNzDQpbT0td
CW1wcm90ZWN0KCkgdGVzdA0KW09LXQlVc2VyZmF1bHRmZCB0ZXN0DQpbT0tdCUd1YXJkIGdhcCB0
ZXN0LCBvdGhlciBtYXBwaW5nJ3MgZ2Fwcw0KW09LXQlHdWFyZCBnYXAgdGVzdCwgcGxhY2VtZW50
IG1hcHBpbmcncyBnYXBzDQpbT0tdCVB0cmFjZSB0ZXN0DQpbT0tdCTMyIGJpdCB0ZXN0DQpbT0td
CVVyZXRwcm9iZSB0ZXN0DQoNCg0KSSBndWVzcyBpbnQgODAgd2FzIHJlLWVuYWJsZWQgZm9yIFRE
WCwgYWZ0ZXIgYmVpbmcgZGlzYWJsZWQgZm9yIGJvdGggY29jbw0KZmFtaWxpZXMuIFNlZSBjb21t
aXRzIHN0YXJ0aW5nIGJhY2sgZnJvbSBmNDExNmJmYzQ0NjIgKCJ4ODYvdGR4OiBBbGxvdyAzMi1i
aXQNCmVtdWxhdGlvbiBieSBkZWZhdWx0IikuIE5vdCBzdXJlIHdoeSBpdCB3YXMgZG9uZSB0aGF0
IHdheS4gSWYgdGhlcmUgaXMgc29tZSB3YXkNCnRvIHJlLWVuYWJsZSBpbnQ4MCBmb3IgU0VWLUVT
IHRvbywgd2UgY2FuIGxlYXZlIHRoZSB0ZXN0IGFzIGlzLiBCdXQgaWYgeW91DQpkZWNpZGUgdG8g
ZGlzYWJsZSB0aGUgMzIgYml0IHRlc3QgdG8gcmVzb2x2ZSB0aGlzLCBwbGVhc2UgbGVhdmUgaXQg
d29ya2luZyBmb3INClREWC4NCg0KDQo=

