Return-Path: <kvm+bounces-37907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA962A31416
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B45987A1545
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E716B25335B;
	Tue, 11 Feb 2025 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MHWNTFA5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478EF1DF735;
	Tue, 11 Feb 2025 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739298618; cv=fail; b=Fge1+0c8jBOnH6iHjGPgIjSJBLi3feZ/bXvGJkevI5j0sD1LuIMIIT3v9iW6eddR4V8dUH4TQDzKOWEDdl1yko8WtbQU/vf7fJpnhvBL0R7wuMnXcwBltg6LElWqS+z8/3cHy19FBnrB3zOVWL6uDWCjK0v2TrsqiksdvSRcRag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739298618; c=relaxed/simple;
	bh=Jto+ZurXQl/qBusTRYvipyJAk9l/z+IrYcdHeEwONXw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jutCQQkJKsO6OPaljJPbAHXFMA4BVNrAUxZS/Trz6S3mdhPcv8URb0nZvB2pbmenZmtf5SoZSDKBbYt0xi5aq47XtGY26yhuVT2XuTpfStqAMY6xfWfMClpMDZxvaHzt8sJ0K1/817KHe42Atj5kVM7HcpiqKndQCmFBetNoQI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MHWNTFA5; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739298617; x=1770834617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jto+ZurXQl/qBusTRYvipyJAk9l/z+IrYcdHeEwONXw=;
  b=MHWNTFA5uRyfcRJV5TPT470BWocb+Dry8O90cgxVIHxbNqmfncLBzv20
   1LuzdVjII0bIWGeeL4lJpBpd1+MHT1bLp0qONbK4EH6FiB1yT1YOY0Kgp
   /pnz5gsk3N0ylPzpytcnGteXvXIKyEfBwTGsPUXzoDuptreBcd8seHmKQ
   iw3t4KYYoAC0f9kzLHS8LAtVoj0EqZtyBI/JkpCumyVfKQ3tIvb3eG+Y5
   j2iO/OeYl6cGJj47V0xUPk+ngNG64eDZRf35azpNrV6mLJYzVx5YJKu/p
   Y4PAdt3AGdwGWt9QMl7Zd4rELbmkLAWmbCaaTMUmo6j+ufmZQ7BVmoMvi
   Q==;
X-CSE-ConnectionGUID: TKtMhlCxTxq0MNIWO+Cdhw==
X-CSE-MsgGUID: u9sfEmEARriijiwlHMj8EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="39126189"
X-IronPort-AV: E=Sophos;i="6.13,278,1732608000"; 
   d="scan'208";a="39126189"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 10:30:16 -0800
X-CSE-ConnectionGUID: HU+SLJbOSpe4JM6XLEA3NA==
X-CSE-MsgGUID: YDzF+hUOQKe/TFU/WvS6MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116681039"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 10:30:15 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 10:30:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 10:30:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 10:30:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjkpPtyBNRSqN+ceulBL3ULkcmkHn+NL9W9aIIaT5zvACKn9pZX7MZBJMzRWdaswhYlmndhrO19yh2U8JE7LjffTH2MxzPQNxJdQNXUv99GPaf323hCAkncK65tM1oqIJctVHN3RNxSVPTKBjtbmAmtaRn5Qd8XkPjIsSgOoto4WO1lfLWB4OHngsy5IIwoqFJY/tH+ow8cpA65sVsCO/ywgFZNP1j88K3yOeLGQWtmNTEFV0rUS+Y7vz/9Qi7gF28XvKuPqiLgmoeGIDXbim4LUsLcg/knrsiDjLPjwYehbqZqyzOHCYYlIQrQDYcy6sW/qexzSGbINa60jKOd4tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jto+ZurXQl/qBusTRYvipyJAk9l/z+IrYcdHeEwONXw=;
 b=HM8DrvbleeSVjX980f4JJFkaEfj7YBYhYPGk8rJWcGfyE0JKD1yQhbqRH2CLTgHy5LFdAwWkDC8MNpFfzs//MKZnuczc8KFjqlKkcAK3HvMin9YJD8WtmOtspxqXpgkEBpIOg6B79IbAoQazTFEJ/vozdEZ20K4REWm+8huCRjonoURY34xhEncD5VpBNH7L2sfwae7wnrMYBZwQRuLLXWLy8RlLIPzmjSErA+psgK8kRpkxx4A16uf2CSeozmhdSE6efABu66rejTqqmSK1Xi/c//ezSEAZ3NkKOA03boWTiyaN2XsN4qN9i7AzN2KRIwEg0NEEUW+eGb4XgIJpeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 18:29:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 18:29:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Thread-Topic: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Thread-Index: AQHbehfVHEczKAq3gEWCQe7SoPjvmbNBTTyAgAALDACAARlJgA==
Date: Tue, 11 Feb 2025 18:29:26 +0000
Message-ID: <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
	 <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
	 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
In-Reply-To: <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6009:EE_
x-ms-office365-filtering-correlation-id: 4bbb0f88-32c2-4a72-f5aa-08dd4aca03db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RW5yV3U5WlhJRVZUVlU0aVFZbmhwK3ROdFBqSlVianNIK3ZPSGc3bGVSYXFh?=
 =?utf-8?B?SDAySXhFRkJJVlQzOFNickNqSzhXK0JsRWVBUHM1b3k4MTdCWmR6cHBWVDNs?=
 =?utf-8?B?Qm5aMWlQQkhiaEc0SHREVkpMMTlFOTNRMGtVU2Y1Z2Z1bjZmbFBsNmIwQmZa?=
 =?utf-8?B?MDU0eElBcjZJWkYwVDFNS1pDKzZiTEp5NlNiNk5LeWE2aWlyb3NHN3F6d0hs?=
 =?utf-8?B?OWE4WlptYTJUUzMvbVcrR1ZZemxOakJ4SEZNblIxRENaK3V1RDl5cDZidTJh?=
 =?utf-8?B?Q1Z4aFZ4UEd4a1lObkczM0UwbHpXeWZKZ1hGcUNuRHJub2VZZ0FzalRQWVJh?=
 =?utf-8?B?c2NpWU1OU1hMR1FMU1FSaUxvWW1vOVAweTYrTEk1eEZreEtBWTcwTHNTVFZI?=
 =?utf-8?B?TVZBMVhkbjVqQzNnYjJxWXFoczlTdFZ3bGhVenR1NzROc0ZnZldEU21jdjhw?=
 =?utf-8?B?aFljRTVVeURWdnU0a3ZWOVhNQm14akkvcjdZUExFaG1UdWFVdjQ2M0hpaEhw?=
 =?utf-8?B?UXczeUltVGVQQ0lzMjJHQ2JOY1AxVm9mQ0FnUW9ZR1lva3RZR3pKYWdWbzMv?=
 =?utf-8?B?a0kzaTVBeU1hNDRhcjhwYk1uOVZ0eHh1R1JXNW5NdTlYakpON1c1S2NiQzJJ?=
 =?utf-8?B?aUI1dlo3bHRLTFJrQmNrQ0laRHBoZUVmR1dXT24zalVINmk0SElVOEZxcFVS?=
 =?utf-8?B?c1d0Slpjb1hvNkRlSlQ1NXVHVVh0R0djc2F3NXI4S3h2bGhVak5pQzBiYmdK?=
 =?utf-8?B?T1NmQU9NZDA0b3lIZVE1d2FYTWtRdEljWEZoNHMxVzdVbnVqb2MyTy9pYlBK?=
 =?utf-8?B?KzZLK2NwdmJHM290ZU1jWHF6M29HV3NuOXJqNDhReHVmSjFBMnVTNENPRUcw?=
 =?utf-8?B?MUllelM1SjBzWXNmOXl2RFQybUwxTjR1VmgyZkdjdHRudSs2NlZBNVB5eXc3?=
 =?utf-8?B?ajhhTGRyaGR3QVZoOEs1bG1iMVAwMUJVSFZQdkRKOHNzbmM1SGVVYk5LZDYz?=
 =?utf-8?B?Y2UyYnNHVDM0SklETXYzTDRYVFhvNU5JT1QwWDUwUG54RHVDSHV1M2pqRXpF?=
 =?utf-8?B?SVN4aEdQeFN2YlJKcU14Q3JRUFRVM0RNRU9yZTZnSi93d2JwUi9RaDEzK0dl?=
 =?utf-8?B?d2JmREVVcU56V1ZLTjRYNGtRbnVEMDJqLzIyaWhzWG1mK09hR014blNScVM3?=
 =?utf-8?B?OUcwM3VwZ0dtWURqT3lDWFA0bzVVaktKZldpbzcwOXdseDVHK0prQk9OZ3l0?=
 =?utf-8?B?bkhkbXdDMlJwaC9RNURUTkZKeEo5UmxqMDBlVkl6d080TWhIa0Fadk0vaUFK?=
 =?utf-8?B?bm5FY2p0cXQrL2h4bEdvdHFONDFnRmRlZDl1RGJWOFhHalZhRzRXSjhTRVBP?=
 =?utf-8?B?VmNFZ2FWbVRhUVhwZ3FscEdxQVlMNWdHYS9BVTl1NGFLeHpRYXR0YkRIbFNB?=
 =?utf-8?B?NXMwV29sYTFVbmVua0hLaW5vNDU5TzFiMzRxY3drNHpvcWR3K0ZxWTN4a28r?=
 =?utf-8?B?azBHSlZHYzdBVlJqRGdRUDZvWk5OQ05IS0E3WXUxek9VR3daQlFrYTQvWU8x?=
 =?utf-8?B?bzY3bDM5ZkQyM3VTT2NQNDB1MGRMN1A3MmZjSnVjemFpcTNvcDcvQU1TWFFl?=
 =?utf-8?B?QVhsZktqUkZQYTNrSEtnOWpweWRLUUllV2Q1eitMYjdmZE5jMEd4OTNnWXNK?=
 =?utf-8?B?Smo1SmJOSXNpUjVkWWx5eTZHY1pnc3VtZDhsNU12V1pHU2NhMFNVNjNIZ0RN?=
 =?utf-8?B?emczSnBpVExzTGNKTFo4Q1oxWmZCbGpOMkVIRHEvZ0lLNE1kcGpwV24yQ0VI?=
 =?utf-8?B?TWFUb3Z1NUVubjkwSk9qN0t2K1lKVTBRdzl1TUNhYXBEMUc4YWNMeDdMdkZU?=
 =?utf-8?B?bWtOdXpkVHkxcjhTbzFYSGUzOXFuZEgzbDRlN25BVmZ6bXdYaWorTi9EdTZX?=
 =?utf-8?Q?Z/qGAtIdK2KizN1BMJLMfO/ikS8zauaf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2krTmhYb0FhWHB2anJSbEdIeEJhVkVkaFhLV0pkcXFFTktxUS9QQllmVFZ6?=
 =?utf-8?B?MVBKOGRmOStXRkFqelhOYVQ2RHg1N1FTV2NqZ1hpcS9NaVVRNVhoS0J6Y3BC?=
 =?utf-8?B?OTJKemNkamdtT2VueVNUZC8zSXVWTUMyd0tNd0xmWDFWZ3BWTVRiZzB6cGFq?=
 =?utf-8?B?TklVeDIzN1RFTVRiVjd5L3ZRMndTUWpUQVBwR003NCtNUnI3ZkQwVTJ0Z3pO?=
 =?utf-8?B?SngyenoxK2RnTE9qZ0lzK3JsV3crVjBQSWVFMDVJeGFNZHZBOTQwWWFtb1ZR?=
 =?utf-8?B?QjBpc2tvcU9vWDZXZFFMUlBPbkxWTC80ZXdVdVFHakdic0p1amRsQUsvbWNB?=
 =?utf-8?B?TmNUamlZRytHQlpBckpiU0VpYVE3clFKU0ZNWk1LYm42UU5JMUlvTEM3VEFh?=
 =?utf-8?B?Z0x0YnFQR05vK2ZzWnhZVkoxTkpWdDI4R3ZKUDJQVHE4M0MxTEx5V2ZtSzVJ?=
 =?utf-8?B?MGZsTUFNYnE4ZGFzVGtvbUFzYlpxS3o0L2xkMzZLRnd3R2ZPTGQ1OWZqNE05?=
 =?utf-8?B?dkxtOStobnBaQm1ZQjlmRmVqeUtwZWRCS3lYdHBEcVBkejMzMDBmRkFtaDdv?=
 =?utf-8?B?bWd3THlIQ21HTFVPYXhQOU4zSStZME1qRjlxZURaeDhBMnhoWUJZbk11Zkdk?=
 =?utf-8?B?Nk1oNldVWU1iWHNKYnRncFE0UWlPS1FibEViNHl4Q1Z5ajlvMTdFdUx6d2hZ?=
 =?utf-8?B?OFk3M3k3Y1B1bWRzOS9JRDd4ZzdXZWgzUDN3VmtlY1BQYnJDN3ZQUWYzK1Az?=
 =?utf-8?B?RVB5ZUtGL01SQys1L3Rza0tkQUxXK0JsVXREbFUwem5pS3EwZWhoTVRERnZr?=
 =?utf-8?B?ZUNOTXB6Z1RDSWNES0FCM21CaXk4ZjVIcm10SVlQZ3pDOVhOU2lRVjkvRDBr?=
 =?utf-8?B?enVZalF2NWQ3YVRxU29nQkhWWjNmZndDdW9ENE1uWTB2MUNseUVBZUdhYklj?=
 =?utf-8?B?b3poRFU2OVhVM0d6YXdiYUp5c2oxSm14UzB4dFhuTjV0d1pjemRqeThOZVFw?=
 =?utf-8?B?WUZFb2gycUlrekFnRW5HR2tWOWIxQldqK3BDSURBU3dKVU5TbDhqeGhtc1Yw?=
 =?utf-8?B?cUVRTURUOFZhQm1SamUyNzF4dDlYaVp6NDMzbitEM052Q2tFL1gvTWdycWlJ?=
 =?utf-8?B?WUdMVHkwYVNwV3ByVFkxOUJBeU81Z3g3TzhpRkJNdS94aDk4WFg4SDFUOE1K?=
 =?utf-8?B?NklQTFh4ZW9vNjdTUU54b0UxdHI4LzcrNmw0TTVJbGxoSzVTR05lZVgwVXll?=
 =?utf-8?B?SXRScUxtV1Uvc1FHdkVQWmp6NjhOTitnbEVlSGhyTnZuUDl1Wlc3VjJjeGFy?=
 =?utf-8?B?TG1LVmJibXBKdFN4c0tFbzV2elNpS0FHR1F4NmErQkgvS042OVRJSjE0UThh?=
 =?utf-8?B?UGhHMVloR1pEMFAvNldZd2NHbVlNTyszSUl1Z095R1RoWmd6SVdraFdyOEp5?=
 =?utf-8?B?SE1ZM2FiVk15Qk5VdFlKckVuWXZBL3BWQzNwK0MzamI5WGw0WkQ1Rll0UUly?=
 =?utf-8?B?ODlRK0VSa0d4S1NISjdyWlJCcENRMXNpNDJENGNwNTQzdWI4SU5ETU0rNTFP?=
 =?utf-8?B?QXFKY01XcVB0bHJrQUdrN0IweHY2QlVMVStON3RZVVQvWG44UE5IKzlKZlFi?=
 =?utf-8?B?Q0JxMVRFaFk0cEIzZ2grQWNHVDc2U3JJY0cydEVPa25oT3NndjZtaFdRVXJj?=
 =?utf-8?B?VTNJNlg2K0xhVzN4QzMrUFlZWlhNS3Q5S3RwQkI1NnVXcVdraFFqN0tTQmdu?=
 =?utf-8?B?U2I3UFNiYkRwMEdZVU4xdktPeXNIQlcyS2YxNW9kSGMrRHI1djVkZERhTlp0?=
 =?utf-8?B?ZjRXcWh2c2lSM1NuUHZ0OEhZREFFVDhFVkdHMVhnRDNyU3l2YmhVRnR0K1ls?=
 =?utf-8?B?RjB1NjB0NFN0STluaHlNNDhCWW5oQjhMdDZBU3VSQ0lESHFqWXg2ajBOUHYx?=
 =?utf-8?B?TUpRQzJucWlkYU1ha3pMMTN0aE0weWZMR1VjeTY3U2hhK3J6ODRkSC9MMmk3?=
 =?utf-8?B?Y1lzaVltNHdsUXZleUQwRUI1bW5TRGMwdktIZmhiMEF2ancvVkxzTUp2WHpD?=
 =?utf-8?B?UldaTjR3aVl3UlN0SkJOYmJDc2p5Um1zeEFEWmFReFVOZVZ4dU9jWndnQTNU?=
 =?utf-8?B?eFc5OUFYTUJEZ1V6RHVNUDVjLzVpeG5GVTVVdEtpT1B3dWRKcFlaRUZqYXBM?=
 =?utf-8?B?Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D0C896BB5091341828DB2C008179C0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bbb0f88-32c2-4a72-f5aa-08dd4aca03db
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2025 18:29:26.4782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: se1lWLIp0RRHyAtky8k8k0zl/C8o4EJjhdxGIN9u5n6WncdT+1836cLbW+z6AQtWy1FQxQ4Pgfz59ZueKvhPyViwE5kbh2pYUn0XrwpeEdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAyLTExIGF0IDA5OjQyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
cyB0aGlzIGEgZml4IGZvciB0aGUgaW50ZXJtaXR0ZW50IGZhaWx1cmUgd2Ugc2F3IG9uIHRoZSB2
Ni4xMy1yYzMgYmFzZWQga3ZtDQo+ID4gYnJhbmNoPyBGdW5uaWx5LCBJIGNhbid0IHNlZW0gdG8g
cmVwcm9kdWNlIGl0IGFueW1vcmUsIHdpdGggb3Igd2l0aG91dCB0aGlzDQo+ID4gZml4Lg0KPiBI
bW0sIGl0IGNhbiBiZSByZXByb2R1Y2VkIGluIG15IFNQUiAobm9uIFREWCkgYWxtb3N0IGV2ZXJ5
IHRpbWUuDQo+IEl0IGRlcGVuZHMgb24gdGhlIHRpbWluZyB3aGVuIG1wcm90ZWN0KFBST1RfUkVB
RCkgaXMgY29tcGxldGVkIGRvbmUuDQo+IA0KPiBBdHRhY2hlZCB0aGUgZGV0YWlsZWQgZXJyb3Ig
bG9nIGluIG15IG1hY2hpbmUgYXQgdGhlIGJvdHRvbS4NCg0KSSBtdXN0IGJlIGdldHRpbmcgbHVj
a3kgb24gdGltaW5nLiBCVFcsIGluIHRoZSBhYm92ZSBJIGFjdHVhbGx5IG1lYW50IG9uIGVpdGhl
cg0KdGhlIG5ldyBvciBvbGQgKmtlcm5lbCouDQoNCj4gwqANCj4gPiBPbiB0aGUgZml4IHRob3Vn
aCwgZG9lc24ndCB0aGlzIHJlbW92ZSB0aGUgY292ZXJhZ2Ugb2Ygd3JpdGluZyB0byBhIHJlZ2lv
bg0KPiA+IHRoYXQNCj4gPiBpcyBpbiB0aGUgcHJvY2VzcyBvZiBiZWluZyBtYWRlIFJPPyBJJ20g
dGhpbmtpbmcgYWJvdXQgd2FybmluZ3MsIGV0YyB0aGF0DQo+ID4gbWF5DQo+ID4gdHJpZ2dlciBp
bnRlcm1pdHRlbnRseSBiYXNlZCBvbiBidWdzIHdpdGggYSByYWNlIGNvbXBvbmVudC4gSSBkb24n
dCBrbm93IGlmDQo+ID4gd2UNCj4gPiBjb3VsZCBmaXggdGhlIHRlc3QgYW5kIHN0aWxsIGxlYXZl
IHRoZSB3cml0ZSB3aGlsZSB0aGUgIm1wcm90ZWN0KFBST1RfUkVBRCkNCj4gPiBpcw0KPiA+IHVu
ZGVyd2F5Ii4gSXQgc2VlbXMgdG8gYmUgZGVsaWJlcmF0ZS4NCj4gV3JpdGUgYmVmb3JlICJtcHJv
dGVjdChQUk9UX1JFQUQpIiBoYXMgYmVlbiB0ZXN0ZWQgaW4gc3RhZ2UgMC4NCj4gTm90IHN1cmUg
aXQncyBkZWxpYmVyYXRlIHRvIHRlc3Qgd3JpdGUgaW4gdGhlIHByb2Nlc3Mgb2YgYmVpbmcgbWFk
ZSBSTy4NCj4gSWYgaXQgaXMsIG1heWJlIHdlIGNvdWxkIG1ha2UgdGhlIGZpeCBieSB3cml0aW5n
IHRvIFJPIG1lbW9yeSBhIHNlY29uZCB0aW1lDQo+IGFmdGVyIG1wcm90ZWN0X3JvX2RvbmUgaXMg
dHJ1ZToNCg0KVGhhdCBjb3VsZCB3b3JrIGlmIGl0J3MgZGVzaXJhYmxlIHRvIG1haW50YWluIHRo
ZSB0ZXN0aW5nLiBJIHdvdWxkIG1lbnRpb24gdGhlDQpyZWR1Y2VkIHNjb3BlIGluIHRoZSBsb2cg
YXQgbGVhc3QuIE1heWJlIFNlYW4gd2lsbCBjaGltZSBpbi4NCg0KQWxzbywgSSB0aGluayBpdCBu
ZWVkczoNCg0KRml4ZXM6IGI2YzMwNGFlYzY0OCAoIktWTTogc2VsZnRlc3RzOiBWZXJpZnkgS1ZN
IGNvcnJlY3RseSBoYW5kbGVzDQptcHJvdGVjdChQUk9UX1JFQUQpIikNCg==

