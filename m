Return-Path: <kvm+bounces-18074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D16C98CD9F4
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 20:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4652EB22CBC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 18:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0800582C8E;
	Thu, 23 May 2024 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2VP0mLe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305CA8289B;
	Thu, 23 May 2024 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488881; cv=fail; b=arBE6mSYXZDQ8vBbB1Pvllr2fBmuAiZfg1LxiD9vzBmS3hJpeVCoay2SHxM0/XpVhh6oH9QN9abBRdITxg8fDTQ7cmZI61dVUdkF9g3Uuf+bdT2/9AG6UrL5EEtwGYu9pGETcxTLSDFMHOGs2gLsCrWJspjfZX+iLnHHelG350c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488881; c=relaxed/simple;
	bh=O8WNXBr8oVGxgs3U03GdFMsIYmeEH9gmMTZFdmLEWBA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IAHFryf1IKTKEGgXt57qCqAQI9R/H2g0MEMHaLGviPxaBT0Cs872SBHqlAOHrOoQy60v0Ppm8gjJqtZH9uyFL3KwQ7X7vcWlLQPeU/R3MgVapVOCEwxKLOXpgS0mZWDDBUaHV3zWgRg5H7eOTfdDuOvMWoCAgdEBq+wqSu/nkoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2VP0mLe; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716488879; x=1748024879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O8WNXBr8oVGxgs3U03GdFMsIYmeEH9gmMTZFdmLEWBA=;
  b=d2VP0mLeqi8IS8kjwtfEQ/1IbUWAOeOT6jaNjqVIrzLkhjboO19V6H5c
   soi9NsbXcgB/kAGe0jfrzayPg1IZiZgzzephI7Msex7w326A/mZqWjbAW
   DhwSGbuf/wmrEDpYGrfNdH/BF06sY9lYwaj4qXqHnDisX1R/udfrAWInk
   qGecx3nJzk+fuZqJfNRn7k5BCUXm9Qr+W6fPpxdx1/cNEuF/19+QtARpf
   tFeKkzgWOzgQgSuL49JjKds5/2+IL5Xb3q46VGVNIMRjtVfM8ZUy+gixG
   ADo8DbU9Rpv3CovRxrNrm4BmXZG6GC6x5Qr78wPOG+q5u6Sb1QXY7VCAh
   A==;
X-CSE-ConnectionGUID: VE4JBUMRS4WqCnvqM6hXcA==
X-CSE-MsgGUID: hjOYFlCjRYGs/4wkxuthPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="16661314"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="16661314"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 11:27:53 -0700
X-CSE-ConnectionGUID: FbFcn3m1QgGl305j7E8EXw==
X-CSE-MsgGUID: QBj6ai9fRGaUYKjOHA4VcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38739278"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 11:27:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 11:27:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 11:27:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 11:27:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 11:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gid1bgtptrrvx3/SSrimSpbqA7UUQUCxZRVgtMwjMHpCMhDDfsZOru5o5JXJYXCLuKtWWfybUeEUHNx/o21Rh0aHs3FcSKmLnEV8hT2LuSWMIrQUILGUGzgWcs30O+aVkiKVt7ZhLrx+feKa5iGH2mdAeI26MsTvXK/bYBpJM2BSPpX19a2uAITnyXUxHIWkOgz02cmEEGpf4UE7onCTyrr5chV5Z+q8d1d75N9sExuHjQnVO04S/6iUJbR2fqMwoI+s8376CKxpHKxH7J13kU+siwhQcZdaphgyG65VgFMEBvAaskdm4Qbun7ZcN/ji5uyOJe8TIsAG9qRnjUmaCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8WNXBr8oVGxgs3U03GdFMsIYmeEH9gmMTZFdmLEWBA=;
 b=dg63rnlOZN8WpjDwDBWgenLWr+h9PLAYtfrkXw3B10bG/+88iZIfgNOc/keQuhfPMy8yh0rHpp+uBuczOCbiN4XHFrbWLvyFHNWtZZtkUNTMLKzY80B81Yhrc85fTETGse2IIMpDkTKneeEY9E8Ct7lT0gEoAM3KFMjaPVcdynV99Ku29ciqc53zk36tbswD2qwpdu50bYz3tEcWztLJBzzgAiQxTt3r7ZpWBrjQVwHGx4dYPJ1IeJZX2zHhDCAL2T1zHK+XZCwwuSN4H0LxLDMJfpQR5l43ld/yJx6/tcqnnd5eq7hKi62dQqHmXJLKG5ut2738WqCOIuzBz83ZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4648.namprd11.prod.outlook.com (2603:10b6:208:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 18:27:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 18:27:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCABP6CgIABBVgAgAAS3ACAAfwwgIAACfeAgAAKoACAAADagIAAAs8AgAE1PAA=
Date: Thu, 23 May 2024 18:27:49 +0000
Message-ID: <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
References: <20240517090348.GN168153@ls.amr.corp.intel.com>
	 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
	 <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <20240520233227.GA29916@ls.amr.corp.intel.com>
	 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
	 <20240521161520.GB212599@ls.amr.corp.intel.com>
	 <20240522223413.GC212599@ls.amr.corp.intel.com>
	 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
	 <20240522234754.GD212599@ls.amr.corp.intel.com>
	 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
	 <20240523000100.GE212599@ls.amr.corp.intel.com>
In-Reply-To: <20240523000100.GE212599@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4648:EE_
x-ms-office365-filtering-correlation-id: 8e564559-df44-4c38-05ef-08dc7b560cbb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZklycS9QMFg3c29Sbml3WkZ3ZEZhbzJkNFVtd2lMNkZtMVB5RmM4UmVCbTBk?=
 =?utf-8?B?UzhQRmIxMWgwazhSWVZqTVY2RzNkTFMzaURxR3RCUTZxTmFFRm4zaVE2bkJC?=
 =?utf-8?B?N1lPOGFhcW1GdmRLbWdvM1g0WVgwbW1YdFBwUlRpd2JyRnFTTWJKTWZmMzlI?=
 =?utf-8?B?K1dWVW1uckNNaE5CSmhUZkt3MHpVVjdUbTdXdjRKcVo0L0ZOeHBneUp5dllv?=
 =?utf-8?B?MFNlT2tDZHNBdDJidm1HTXVhcmFmeGppUVBsZU9uNCs5U1Vra21rR0U3RWpy?=
 =?utf-8?B?SFRKb0NEdmhHWUV3NWV4UlNjT3oxTnJvS0c1SnZRYUdsU21VV205ZmdzSXly?=
 =?utf-8?B?cnRWQy9qRWlkekZvYUM5WW9jL0IyNXdaaFZOSWU1bDh2eFVBTEUwUG1NdDBF?=
 =?utf-8?B?ZThpK1FBM0hRTGJnVjU3YUlPeEd4Y3NtUDlvblAvQWdYS0xsaDBnaGRBTDNQ?=
 =?utf-8?B?VTlqYlBrZi9CS0hNVUY4eC9sVmZlaW93YTY5SjRvNlVJSDlXNVhGQ0t6R1Bj?=
 =?utf-8?B?dWY0V05sa1NDdzNFUFkyZFA2Qk4wck1TODl3bWVIdzJ6NXFaUk1lL1JNZTBt?=
 =?utf-8?B?MHJ4Q2drZGpnZU1Ma2EzZWpZY0dTU3NJSnZlbm4vRFhsWjFJNlFWMlU1N1ZE?=
 =?utf-8?B?dmovWS9iTmVCb2VxYkVqck56MlVGdFFMMDRzdWhrUktFSExkd2VVUERnTFZn?=
 =?utf-8?B?Z3hzcm5zcWw5aFBqVnQwTHJSd0pBaFhKK1NGRWVieU5pek5rRk9WczdCZytz?=
 =?utf-8?B?L0k3aXJJczlRZUcrVUsxcUhPR3JhamllL2lJSXdqSzV3SkFEeUx0dStxdzJp?=
 =?utf-8?B?Q3l3ZW1tUElrL2tqYmVya3ZTWkhUNFg5bjdzc2ZDTTVLbFk4Vzd5aUR4eEVN?=
 =?utf-8?B?WVRWL0o0R1l1ZHR1R0FieUVuSHcwNDVWMzZpaVZPY1JBdmN6SXhwWFBiTWdO?=
 =?utf-8?B?WFpyQllnUU5TMHdnekJJSUlRNHo3NnZwRzR4djlJelNJOCtGVEFsLzRkZ3d4?=
 =?utf-8?B?SDQyM0tkbU02eWdCbTB3UFg1M2plQlJEWjFQU29sWDh0ejZmN3NFV21rTkhC?=
 =?utf-8?B?S3pRN210U3pPWnlINzVLNDA3bHdaenBUSW1OdzMzMUhVNmpPbmk5cVRxQmFr?=
 =?utf-8?B?RlorTWZMUlVCeWxMekw0WFREK2xwTHViNUY5VzVIYTliRTNoRCt3d3lQTkNq?=
 =?utf-8?B?b3Y0L3lmRWNRUVRxdnVPTHBONjlyU3V0NDY1aTk5RTFBQmVuSmhacGgzZ1pI?=
 =?utf-8?B?eHNiVkpXcEIrM2hiRCtkOXUrdEo3bW1KbXhJWlJKcUIzRlZJUUd1QngxVFc2?=
 =?utf-8?B?dms3TXBjLytxT2ltY3ZvcU1rS3VLNlEzSjArZGZCYVNvd0E5MXJaT2pPTjV1?=
 =?utf-8?B?czFMQmw5aGlLNlA3YlRmY3BhNUtDUUhHSGx5ZXVDTFZnRnJBOEFabmVTSmZT?=
 =?utf-8?B?R1R4MEIvNEFqYmdJTk16Ynd6ZXJiOWJBSDVLOGJPWDR2TmlVWStUL2VlWTFY?=
 =?utf-8?B?djh1R3RVanVqZklBcW1GYkZ2d2JZUzFpdHk0RlA5aGZkNkkzR1NZb1NLSEl0?=
 =?utf-8?B?eW4rY09PZTRZNlVCQVZEQ0FvMnBuMmhGK3pnc2IvdHVBdFFNd1VadS9IVlBT?=
 =?utf-8?B?dVBCMXFpYVlkbHhVU1lJRkFsNlo3T1M5SEsxZGNvc0JxRzcxZ3NEcFIySzkx?=
 =?utf-8?B?WEJHcHhuTS9KcEdTWDd5clN1Sk5LdDhhbVY1MG50b05ILy91cWF4Z1lUQTEv?=
 =?utf-8?B?Z0lQTzdiNlpIOWtZU1VKYXNoOUloN3ByeHI5ZGtaYjY5WjdMUnhPMm5rRklK?=
 =?utf-8?B?NVRXa3lHNnRJaXFmc3I4UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlQrWEVRVXRtK2gwakMrMm5sK2FjM0FwYW1RanJwVUViditKUTVSVFFBSHZX?=
 =?utf-8?B?U0tSNU9Tdnh5NXZiWDJHU3MwL1VzSVg5eCsxYzA3bWpHbDZVcVVSSHZqK05w?=
 =?utf-8?B?bHJRZHhhRTBIWFJpdkNGZklhalVjVktCa1dGa3JnbElwbmVnQXBDcUZvcHBR?=
 =?utf-8?B?b2g1N3Vza2xmc2o2VFhmems1Y1dvYmgwa1ZRcE9XMVhmQUVVUVRNMENrMWdN?=
 =?utf-8?B?Slc1aFJuaW00dFFvaTVpUDhGSHBDRUtFNk1jUGYyRUc3dXF0eHZLUGZoc1V6?=
 =?utf-8?B?WFNmeDVxMFc4VWZxMWxseml3ZVdsVWx5eEIwOE9LUWhneU1DRXc2TEdlVkJR?=
 =?utf-8?B?V1dtcjlYNWNLVDhvV1FJKytTTlpscktrbkphUU5pZ1YreE1XRkFCRmdKanoy?=
 =?utf-8?B?NFpGZmdobklwVGIrQ1JHbDZ4L0xMcXFtd2VhOFE0WEE5Tk83N05HS3ZNQXgx?=
 =?utf-8?B?TFFISTVBdFp0VXByZU5xUWVPT21xTkpDd2lSZE1OZTc0SnMxNnREMU9lUWMw?=
 =?utf-8?B?SU9WTG5aekp1clhOY05QemFoZHB0MCt4ZE1pYjMvT3dJMzBjWVhGZ3d2aEFr?=
 =?utf-8?B?T2V1aHlrRG02UnNkZjNmY0c3NlA4VzhWZnRTRitzbHBaUzBrWUZhSXJsYkNm?=
 =?utf-8?B?TzRZaVJ0dnY0YXZZNVBzSnRiNzJJNythNGtZU2tlL2xWaTl0TjBESW92L2NK?=
 =?utf-8?B?bUpGcGVtS2l6Q3Q1VVBGNVFXdFdOZW5BaHAxSTBEenlSa1NMaGRXZUtJb1ZL?=
 =?utf-8?B?aE9BY1BLUHhsd2huSm5weE1QMmZtenhYcmQyckNRdG9rMkw1QkZweFd6WW93?=
 =?utf-8?B?c1FDTjA1UE45cUNjN2VKeld5TmRqTU83a0x5eHZzbi90QXpPSmhORXBDa25P?=
 =?utf-8?B?eG5aN0pnM0QxZG5TN1BvUUFvNzdxdGo4MXFHZjdKRlF1WmNPcWJUbGtiemxL?=
 =?utf-8?B?Yyt6OHlEcGtVNlRTejlpNmFrR0hvMlVlUFdnb2N6VmgzUHYyYUVWSlFVck8z?=
 =?utf-8?B?YTRFZmI0dXRvdFR5QndEOTNXUW45RzQ4VXJtcWxyNThxVE50UzF4V0tCZVhE?=
 =?utf-8?B?OTg0cSs4SmN3cHRYUU4wa09zYmFTTm5rekd0WC9HWkQ4eVQ5bURPNk01YTVm?=
 =?utf-8?B?ZnNacS9PL25BUlZNeVJCY01jU2krVGJLUGFOdGtVY2ZNMGdsK1dtVzZmRDA4?=
 =?utf-8?B?R3UrbFZ1UllXTW5mUkhQR0dSSDNmUHN1UW1kZ2lBRWlFSkdNaTZ0clB6T25o?=
 =?utf-8?B?QmVrSEdRNm0ycTVnTXl6bDdkUnkwcG1WRlhoU1BPTTdLUjZCbkNkbXhDZS8r?=
 =?utf-8?B?YmYyWlFrd0dXOUNLbW5hd2I1alI0VmZUcmJQNm5nSTBVMVptYS9TZWVDOTFX?=
 =?utf-8?B?UDlsNTV0dURGV1lOcDVVeTl4MVZBSEFJcHl4RUxxQXhvSUR6N25weno2WlYr?=
 =?utf-8?B?VW5lZ2dLQ2FWdU1odFdCR3FjdTY5K2tpN0tpZUJGUWt1SDBFd2JBMXBjWUNz?=
 =?utf-8?B?YkFUWFpyc3NJRVpLS0RsQmw3d21MN2VWWUd5aWlwbTI4QjMya215a1FLVUpC?=
 =?utf-8?B?T0dHd0xPNzduL0YyTHpTNGZiN0F5blhoWU5zSW1Ub0dCT1h2UTF2TWVSUWdY?=
 =?utf-8?B?QVAyN0IyZkl2cUdwZVZhMjBYZ1Fmc3Z6a2lmb3EvSVVNUE9CbC8yQlVvMmpL?=
 =?utf-8?B?UXVyaWlXSzI2NWlWeVgrc1ZrZWpUZUN6V1pURitTWXIwL0NZOGdNNnBZdFdY?=
 =?utf-8?B?c0hSUWNWNFNCOFp5WE5Jc1l0WWJBQTI1ViszTS8ybUtncGkrWkhMM09KcHpk?=
 =?utf-8?B?aVhFYUNBYWdIVmdxaWlaRnRJVlE2N3ZvVlJXWDF4YUtZV2VJSTZjRjFmbkdH?=
 =?utf-8?B?RlppNTVxemRiVHBMUFZPT0pGT0s0QlBySXEzMTdUb0QyMkdINEJ6VENITmpF?=
 =?utf-8?B?b0tnNFdoNk5wMDI0VXNzQ3Mxd0dzbk9SMUNzdjFjZmFvaHJQS0wwN0R1MlZ4?=
 =?utf-8?B?NW9ITDZ3UTRBV0xXOGx5dHhPNnlYbEQyV1V0TFh4Unc2WHB0Q0VpSXRVUnBK?=
 =?utf-8?B?UjM2ZmdwMDBna0lVMExUNFpzVWM1VGNkdW4wMzBrcUdGR2F2cFVGK0VnSHpM?=
 =?utf-8?B?cHNxbTI3aDB0cDgvbEYybFJzd2dkSHduWXVhZnNodi80SVNOM3ZObmlvQnF5?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34804ED045DEE045BF648FFC5CBCF85F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e564559-df44-4c38-05ef-08dc7b560cbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 18:27:49.0617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5e5lG0SmKzcyuo3rTW2b4VW5pvB0rGDR2G6vryy1k0ewOSQUEH/Hqq/mvEXx7uBmHMS5CwWah8EKcYTKJBWk5Suh/zVPK8I8BobeLBlSbsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4648
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTIyIGF0IDE3OjAxIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT2ssIExldCdzIGluY2x1ZGUgdGhlIHBhdGNoLg0KDQpXZSB3ZXJlIGRpc2N1c3Npbmcgb2Zm
bGluZSwgdGhhdCBhY3R1YWxseSB0aGUgZXhpc3RpbmcgYmVoYXZpb3Igb2YNCmt2bV9tbXVfbWF4
X2dmbigpIGNhbiBiZSBpbXByb3ZlZCBmb3Igbm9ybWFsIFZNcy4gSXQgd291bGQgYmUgbW9yZSBw
cm9wZXIgdG8NCnRyaWdnZXIgaXQgb2ZmIG9mIHRoZSBHRk4gcmFuZ2Ugc3VwcG9ydGVkIGJ5IEVQ
VCBsZXZlbCwgdGhhbiB0aGUgaG9zdCBNQVhQQS7CoA0KDQpUb2RheSBJIHdhcyB0aGlua2luZywg
dG8gZml4IHRoaXMgd291bGQgbmVlZCBzb210aGluZyBsaWtlIGFuIHg4Nl9vcHMubWF4X2dmbigp
LA0Kc28gaXQgY291bGQgZ2V0IGF0IFZNWCBzdHVmZiAodXNhZ2Ugb2YgNC81IGxldmVsIEVQVCku
IElmIHRoYXQgZXhpc3RzIHdlIG1pZ2h0DQphcyB3ZWxsIGp1c3QgY2FsbCBpdCBkaXJlY3RseSBp
biBrdm1fbW11X21heF9nZm4oKS4NCg0KVGhlbiBmb3IgVERYIHdlIGNvdWxkIGp1c3QgcHJvdmlk
ZSBhIFREWCBpbXBsZW1lbnRhdGlvbiwgcmF0aGVyIHRoYW4gc3Rhc2ggdGhlDQpHRk4gb24gdGhl
IGt2bSBzdHJ1Y3Q/IEluc3RlYWQgaXQgY291bGQgdXNlIGdwYXcgc3Rhc2hlZCBvbiBzdHJ1Y3Qg
a3ZtX3RkeC4gVGhlDQpvcCB3b3VsZCBzdGlsbCBuZWVkIHRvIGJlIHRha2UgYSBzdHJ1Y3Qga3Zt
Lg0KDQpXaGF0IGRvIHlvdSB0aGluayBvZiB0aGF0IGFsdGVybmF0aXZlPw0KDQo=

