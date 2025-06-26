Return-Path: <kvm+bounces-50783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640C7AE9387
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFF897B0766
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ADA1922FB;
	Thu, 26 Jun 2025 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T6O4jX5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366A51865EE;
	Thu, 26 Jun 2025 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750899243; cv=fail; b=Y6cZjICvExkStSv1qgNI0Yd3QV9AVuJkP3tdrDvPXD94C66vupwR20LZAnAC5WlFzFL1Ix1Buk0TI78owZUVLSocdCjJPfWZHSuSeUhEDqdVDMd9TfzoOScwEgKTKg7p0mB842RzFzIN8ZsNxFygxatYr6W7bMpDa9A6iFCSbws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750899243; c=relaxed/simple;
	bh=mmukx1+VGZ1wv/MYk1ly866IumxbnZAPb1CftSXA3vc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g3giKEjO2DjIPvifOWjdBaPta1JfNVm/2Go8FT8kngwiAQCCT6G8ExA0s6yUfY1Ff+80/0C/+J76kV5SLjsFf/ExLitz+awzf492hJzEQOp0rz39zU27uAMi7ebPglET7pu5BXUuhSSIBzmcAysawUuiIonbwyLawOJ0swVenbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T6O4jX5K; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750899242; x=1782435242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mmukx1+VGZ1wv/MYk1ly866IumxbnZAPb1CftSXA3vc=;
  b=T6O4jX5KWLmJM2R+r/kwIzoEoyRlFKYxnhpwXUhiLjCQxDxlBj2V2eqN
   CVavWLD9jPJ1WGOYHiTCgGYc9RBfVYDInzNByyY1SiBKQFbkihX+hxYYA
   qsKNvn/1KkfCcXm6DRECd2CazuFxd5vJEnlk+iyqebaYbDwG+KEcBIbmi
   WvbvhnO8iV5S6cVipDeQs0IpDXdynqv2Nv+o8j3cnJxg4XNOx74W3Rvzq
   L1Vy7HVksg3CjjFPEY7Z6ILX6cOPOn9VTjLwFApCaYqEMVjkpP6ArOi2D
   woiX4VA5VKn0qaozOWMZv84GU2/LLm1xP+x8kKREHJhH6JTfDBeTvKiP+
   A==;
X-CSE-ConnectionGUID: u7g0u89BQxO61lNqDwexWA==
X-CSE-MsgGUID: oA7vccW7RcqFbtwKIy4Bcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="56990215"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="56990215"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:54:00 -0700
X-CSE-ConnectionGUID: AxzSxTy7R3WyJ8x02zrVWA==
X-CSE-MsgGUID: ZXKp+nuRQwmTgP95hIuv9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152668181"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:54:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:53:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 17:53:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.46)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:53:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQ9U+99wbuvxM7fa9YiyaRzL+dIe+VVuguRJxymyJpWnlc7dGLTfg7ypQFmR3fo+QPf+yPze2Zt1Y2WZ6zjazuh2XOaA3ErqEUIGR+e7Ww61glVv5lYA2CGVb5CK9gqMabwFRYQE1EuO4f75ntAa5z5k779Rp1pwyEJqIRODbGAE3433FODLPB07/bZVhugXGCcPjGgdgrNdBpdelpyA6ilXAMWUnqRazE77Ttd+x3RPnhAxgFJGp2NAMO/Apuf9SCfJUsuK3X8q6L8NsL3ycwDnfnEG+9YrBZSD9ycgJ83ZXb9BKQd4Hb61guWctZmIpta8Dlmsz536HEa1ev9cCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mmukx1+VGZ1wv/MYk1ly866IumxbnZAPb1CftSXA3vc=;
 b=BFmMPBKUnzEk2UAVmPx7+lvUVz80Hlc98LrprVJ2HX0XAwkWIi1YZ3A4SeNO00uKBjPppY6hj9OHSq6Lnh2mGwSju4QlBvBFf0DAg+SmeuULC6IN+BImt0GY32a5Hqup3qeBIoTCF4XOfpNKmyJDQQzv9NgoEpINsgVAfy/lAAG5+oLhApzUTtMuH+QfQw3TYr20eSPwwOm7Nh8ijlB282VxkajLdbB5O17WUpsarB/kjq/AWlSRJ0lEbxhsWR7IOZY7VLqFQDv/flrEkxL+cd58Hn0hmm5sdELRKCQ8Yz8WPTm2Oxm8F1gv0P1V69+WaQXseA9+6xwAITQPY96j4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB6717.namprd11.prod.outlook.com (2603:10b6:a03:44f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 00:53:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:53:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHb2XKrD1/c0Ot3oUKBt4hkqezw2bQUtooA
Date: Thu, 26 Jun 2025 00:53:29 +0000
Message-ID: <104abe744282dba34456d467e4730058ec2e7d99.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB6717:EE_
x-ms-office365-filtering-correlation-id: a98f7d07-e9da-46b5-95bd-08ddb44bde28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHRYYXh6Q2hZNU1lb2ErL2MzZDF4VFp2REZpVldKL1FpdUlQNUFFV3BHNnZx?=
 =?utf-8?B?QVJxakhyQis5aUt4bnVOaFMzbmlXdE9GM2dwMVpqc1dja0puQUJ6bHlUUTg4?=
 =?utf-8?B?NzlKVFl2d1UrQ0lZc0V4b0k3eDlCZnV3Y3EyZGZSbGZDbnFRWTNNL3YwUFA5?=
 =?utf-8?B?Y0s4V3NJSmhQUkFoWmFHS3EvTlRBQ21xRkNXK3owSWt2YXBLdjZOT2V4UGts?=
 =?utf-8?B?aGJPRm5ZS2U0LzJxU2x5UC9PWmlLSTlSdnRuNFh3S3RrcGdtVGFnNnVxaDJP?=
 =?utf-8?B?WGxScWlzd0MyblRrcHFEV1NCOTlZTnVXTXJNNnJWWTc3TXNNYU9nTENaRTEv?=
 =?utf-8?B?a2k1ZUtBQ1hiS1NjRy9QNGhpUUpLdVh1MG5VNlp0MVdJSFpKTS9HQitRSi9j?=
 =?utf-8?B?L3djWnFOWGZWSXFVNWxneDkxZ000MmhtMStuZ0hlRTJGY2owdUdjTEk1QmJL?=
 =?utf-8?B?cVRReENrMUlPTzJVRW9qZDc5ZDgyWm1vRHNiTEI4aTl1SzdPRkpVbWhxcUNB?=
 =?utf-8?B?ZWp4bmtZbjRUTlFpa3Zna3BwamVCdHcvYnhkY1dpVXBmcW9iOGwrN2tQZU1J?=
 =?utf-8?B?Wjl2WmRtUUhTcEVqMzUrdjhRVVZzTTBic29hMUxkcGhqUlhHV3ZxZHExY1dp?=
 =?utf-8?B?Z1RzaUJvM1IyZDdCVlpFSlRYSlMrQzNkdkliNEk0TDJ1ZjRzWGtFS1hjTktV?=
 =?utf-8?B?NFQwZjA3c3pDbytyZWVEMllDeVlVNmRrRzdGNndXTkJsZ2Yxd052aysyS0xl?=
 =?utf-8?B?Z0ZqaHYrUGluUmxhZnhoakZzWGZ6SjlpTHFGMDJXaXUzV3hPdDdRaHYxQUE2?=
 =?utf-8?B?aWhMcVo4RlZyeTVtL0FJZFBnRUFxRmZBY2ZNZjdUaVovWmEwRUhDZWVOclFt?=
 =?utf-8?B?OC9HUTFMZXliNGlXQmVUTloyazhvYnFrVHY1cHBhQXhlT2J0RnpMOEpPUTAz?=
 =?utf-8?B?NGl5TlpTMVJMUVczZjJOTUtPU01wcXlBKytZalYyeUpsbDEzSVFjcjcySGRP?=
 =?utf-8?B?WjBRblFGT2dmQURxL1JDZDRqUXBvcFRaTXNPczd6ME1VclpJQVk2UUJoSnpD?=
 =?utf-8?B?aURuZFRyVGtiMDJ2ZVhIR1AvVUlnZTBINjdwT25BRkZ1QThWMmlGUzZoNGRF?=
 =?utf-8?B?cit2RUIxcHpXbzJTcWJlbEVxTHVoYmdDMnFNczhtKzltMkxJVE41cGtXTnpr?=
 =?utf-8?B?R0FQemdJc3Z4VWYxd1JZWW9tbk9hZHBLSTlsQUwvMHM4dXE5cDNnL0QrZmRa?=
 =?utf-8?B?SkZMczlIWm55alBURklEMTNHMk5GdHVBSW03bGJFVmZUU1NqSkVrZlJmSnly?=
 =?utf-8?B?YWRvTmZGNTVFZVp4OWV1WVROL0kwK0RXRitvanpXWWFxbVpPYUx0VjlObHho?=
 =?utf-8?B?VGZXaFFpOTNTVVZ5VERvYUlSRXdiMENJUmtKdHc4Rlh0QUx6bTBPNUtmdFll?=
 =?utf-8?B?VElBMWM3Si9Vb0wzdDBlaUZPaVY3WXRBZFRqek1vYkIyRGhJeThCTUswaDdI?=
 =?utf-8?B?SzhuSWNnTWJlcWxZZ0x5ak5RUkZUNFhuaG1uV21TOXRiRVMrTG9QdTNETmE1?=
 =?utf-8?B?ZVpuVUVXWXROSnlHNEhrV01qalRLRkZvSXhBc05pY2RzbkFtUjRsanN2c1ZV?=
 =?utf-8?B?bFJnazdSbksrS3h4L3gwL0pNeDBMZHA4cmNWZFVSU0o1QURyN010MnJsbkd5?=
 =?utf-8?B?SGVhTEFXb2E0aTFBWW43cXdlMUZaczRqSWhCeDhwSjhZYWRtSFJyeTBJVnFo?=
 =?utf-8?B?dnp5dlgwRXRzcmZ0ZFhVTzFBWFNScGd2SFVrRUdyRkJuQm9Sb1pHcVNZVkNJ?=
 =?utf-8?B?ZVFnbXdOb1ltSEk2aFRUdVZ0VVljV0xzS2diZUVJWDEyL3pMRmRmb2xPYTM3?=
 =?utf-8?B?ZDBpMVlKTk9Oa0pkWEtkbm9rNU1LRkNxNFM2RVJTRjhNbnpsVjdyQ2E3TG9J?=
 =?utf-8?B?bFBKdGlGQ0lFZmM5Z0kvWWs0WDkzM1BJVzNFUjlNTWwyQlNUVDZxVTlRMnhE?=
 =?utf-8?B?NDA2TU95c3JBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blV2VUtkeEdUNkdSYmhYdVFnT1hEeGIwMEhrcmMrdFJCNnk5MzA0Z3g4c0Qv?=
 =?utf-8?B?cmpIMkZmbzBWR1NXTmNTaWZvT2lmRGN5WmZ1aTE4SlRKZmJwUmxpY1JVQXNG?=
 =?utf-8?B?Z2RSN2dpb0RTMkJjRi80NFU4RlR4bE5yanZJOG9heUpDeGJQMnNEaWtIdnov?=
 =?utf-8?B?K1g5K1VJalJXV09LejhMQ3dsUUYya2ZQOVBMQlVPV05UWFVaSUNRV0UyeWpq?=
 =?utf-8?B?ZzR4ejhxdy9ZbEUxSTZWZHE2RDVRb1htVnI5OFN5ZzJqZGlmSGVwZ3ZhcEZm?=
 =?utf-8?B?NE1mSDN0VEdObFdCZEdJSzQ5NS9wbjU3MlZoRExiWGNZNGp2K25ZNk1mUUNa?=
 =?utf-8?B?cExWOW9SOHZjb0sraWY3QkxmdmdjTTVJdjYydjBzbTRBSnIwR3M5eFJGemhH?=
 =?utf-8?B?Z2VCclRRMlh6Tm5uME5IWnExcHdKL0Fqd01Dem5RVWY0aGJPYzNvQlg3T2ZT?=
 =?utf-8?B?bXoralpUbjd1RnZrZko3VGlDbkZIVEx3VDNDQWIweFhpaWJCaVpCNjZyVFJO?=
 =?utf-8?B?QUhPelBaa2NZdTJzcFRqZHR6dGJYejErRHM5NGFMZlhYZDhOVVV2L2h6akdz?=
 =?utf-8?B?dTd3M2pMdVZUMW5OeVVlVjhGMGVoMTlZSEtTbm1mTzFNaVMrbFhINGZUNlZX?=
 =?utf-8?B?WWFLWUllaThjaU5MbjVQWUUrSVlmNStUcnAvVnV0UkpTWk5MUjIzbkl0cW5o?=
 =?utf-8?B?SkNJQllWOU54aUxoUktFc0RCdVBWNHVrRG9hODRpUTA2aVlGWnpMVTJsQit2?=
 =?utf-8?B?T2JpYlh6eEUxeWJkdHVRb0V5Slc4d2gzVUJqc3J2ekdOWUpGSDdrWEdnVzRu?=
 =?utf-8?B?amNxVHhTa2JPWTVjL3pTYk1mNmRva0hHZDVqZVUxU2NBRk95R0xhUkhqZVU1?=
 =?utf-8?B?c3Z0cjUvNTJrNlVtOTI2bHZvcW9vaWZ0Zm5aSjJlWklOVlVYTzdHTTRtVXVa?=
 =?utf-8?B?QWVhNXNyQWE4MlZDSWNiV3JEUjRtdUZCYTRBVVB2U211RndONlF2NjdmMHZE?=
 =?utf-8?B?R3FDMHA1eitVejd1OHlkeHFVOEcvMlh0anJCd2FncVltOC85R1dLenlvaVBY?=
 =?utf-8?B?a0l6S21YNUQyY0VTcmRzSDVpNjdyaFpReU84VGZUbXBCNzhKR1RMWFZuNWg1?=
 =?utf-8?B?dTFjeUVYanVVYW44MC8vbjh3bW9GMGRjMDV3czYxLzBjQzlkcmhaOFAzcHd1?=
 =?utf-8?B?a1I0L2hjUXZWdXNmR1FCQStQQkY5cnVoTjNVMzFobUJTb0dvbi85S3RmQmth?=
 =?utf-8?B?NWFHcEZMVExRK0ZMRW5FV1NRcGl5RDZYcmVTZUxiWTVaTWwyYW1SM2pZZjRi?=
 =?utf-8?B?SGhkOCtFN0FGVjFqbGtTZnVmNTJQREdBa1hpV0Nlb3dIVXJnalFvRDVyL01D?=
 =?utf-8?B?NEVDV2RHRSs2RWxpMDhHNjA3TjdYUVFpNnRocEFvN1lPc2FhQU5jT1BkclZJ?=
 =?utf-8?B?Y2MzbzFZblJtT1BzWVYzcjBCOG9LY2c3enA1WWIrT1dZU1ZGODRacjk4Y1Q5?=
 =?utf-8?B?RjhyTEZwSEJkTVRtZ1dqWXYrTHFpa3FVNDE3aFdJWFF2bUNpVmdXSTl4cWt1?=
 =?utf-8?B?MWYzdmpBQTd2ZHRyb0c0RVFQSG8yckxDTnp1Mml2aVFXWDRHOGo3Q1l4Zkwr?=
 =?utf-8?B?ZHRSZlpncG9EdTcwSlY4NldHMW5IWnNMTTZiN1g0WjlWeG1nd3ozMTZpMUJU?=
 =?utf-8?B?SmVTNVQ1dDlPV1pnaEJ1Z3VWTDdUb2dCMCtNRWZ5d3dadlNFR0FrVUZkbFVM?=
 =?utf-8?B?eTllQ2JGQmxmTHl3Sm1LUUlRc3hNTHZwL3Bia0hZYVV5NzZNWERmajBDNUVU?=
 =?utf-8?B?ckxrTEtkNnUzUHR6S0RPaVA2Rkl2VlZzcGdIZlZYNmJDTGlIdVp6eWRiR0JX?=
 =?utf-8?B?Z0ZJWmdRNi93djdqQ3Z0SWVIb0xaVmdzUnIvRUtXbTdITTJVblVDOSs5YkhZ?=
 =?utf-8?B?Nzgwbi83SXk1VE9LUldlcDRCSDROeEdzRjRITVVnRGdvNDRiV3QwaVRGNkxX?=
 =?utf-8?B?d2I1MEpwS3Qwdmo5bDY4RGsxbCszS2x5WGpwL0pSN2ZVditNOWNxbTg3U2Vr?=
 =?utf-8?B?c2JXM2w1RFh0K296N1BvWHprV1RySlNtRU95YnZiSUNzVDhnTUVlaUxlcG1J?=
 =?utf-8?Q?Z1EsPANuwa6d4bPGSbIC3Q0T5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B62D87CCE537F40A593F2CCB615FDC1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98f7d07-e9da-46b5-95bd-08ddb44bde28
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 00:53:29.8785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hwtSDCK1txleamDRFgfvEQa6MIbvJwj2pG6vltUo5MZNHi4tnDzBa+vhAol9ka/AYhZNI0ZYRhI+OBoLtHNxew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6717
X-OriginatorOrg: intel.com

DQo+ICtzdGF0aWMgaW50IGluaXRfcGFtdF9tZXRhZGF0YSh2b2lkKQ0KPiArew0KPiArCXNpemVf
dCBzaXplID0gbWF4X3BmbiAvIFBUUlNfUEVSX1BURSAqIHNpemVvZigqcGFtdF9yZWZjb3VudHMp
Ow0KPiArCXN0cnVjdCB2bV9zdHJ1Y3QgKmFyZWE7DQo+ICsNCj4gKwlpZiAoIXRkeF9zdXBwb3J0
c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwkv
Kg0KPiArCSAqIFJlc2VydmUgdm1hbGxvYyByYW5nZSBmb3IgUEFNVCByZWZlcmVuY2UgY291bnRl
cnMuIEl0IGNvdmVycyBhbGwNCj4gKwkgKiBwaHlzaWNhbCBhZGRyZXNzIHNwYWNlIHVwIHRvIG1h
eF9wZm4uIEl0IGlzIGdvaW5nIHRvIGJlIHBvcHVsYXRlZA0KPiArCSAqIGZyb20gaW5pdF90ZG1y
KCkgb25seSBmb3IgcHJlc2VudCBtZW1vcnkgdGhhdCBhdmFpbGFibGUgZm9yIFREWCB1c2UuDQoJ
CV4NCgkJYnVpbGRfdGR4X21lbWxpc3QoKQ0KDQo+ICsJICovDQo+ICsJYXJlYSA9IGdldF92bV9h
cmVhKHNpemUsIFZNX0lPUkVNQVApOw0KDQpJIGFtIG5vdCBzdXJlIHdoeSBWTV9JT1JFTUFQIGlz
IHVzZWQ/ICBPciBzaG91bGQgd2UganVzdCB1c2Ugdm1hbGxvYygpPw0KDQo+ICsJaWYgKCFhcmVh
KQ0KPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gKw0KPiArCXBhbXRfcmVmY291bnRzID0gYXJlYS0+
YWRkcjsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArc3RhdGljIHZvaWQgZnJlZV9wYW10
X21ldGFkYXRhKHZvaWQpDQo+ICt7DQo+ICsJc2l6ZV90IHNpemUgPSBtYXhfcGZuIC8gUFRSU19Q
RVJfUFRFICogc2l6ZW9mKCpwYW10X3JlZmNvdW50cyk7DQo+ICsNCj4gKwlpZiAoIXRkeF9zdXBw
b3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJ
c2l6ZSA9IHJvdW5kX3VwKHNpemUsIFBBR0VfU0laRSk7DQo+ICsJYXBwbHlfdG9fZXhpc3Rpbmdf
cGFnZV9yYW5nZSgmaW5pdF9tbSwNCj4gKwkJCQkgICAgICh1bnNpZ25lZCBsb25nKXBhbXRfcmVm
Y291bnRzLA0KPiArCQkJCSAgICAgc2l6ZSwgcGFtdF9yZWZjb3VudF9kZXBvcHVsYXRlLA0KPiAr
CQkJCSAgICAgTlVMTCk7DQo+ICsJdmZyZWUocGFtdF9yZWZjb3VudHMpOw0KPiArCXBhbXRfcmVm
Y291bnRzID0gTlVMTDsNCj4gK30NCj4gKw0KPiAgLyoNCj4gICAqIEFkZCBhIG1lbW9yeSByZWdp
b24gYXMgYSBURFggbWVtb3J5IGJsb2NrLiAgVGhlIGNhbGxlciBtdXN0IG1ha2Ugc3VyZQ0KPiAg
ICogYWxsIG1lbW9yeSByZWdpb25zIGFyZSBhZGRlZCBpbiBhZGRyZXNzIGFzY2VuZGluZyBvcmRl
ciBhbmQgZG9uJ3QNCj4gQEAgLTI0OCw2ICszNDcsMTAgQEAgc3RhdGljIGludCBidWlsZF90ZHhf
bWVtbGlzdChzdHJ1Y3QgbGlzdF9oZWFkICp0bWJfbGlzdCkNCj4gIAkJcmV0ID0gYWRkX3RkeF9t
ZW1ibG9jayh0bWJfbGlzdCwgc3RhcnRfcGZuLCBlbmRfcGZuLCBuaWQpOw0KPiAgCQlpZiAocmV0
KQ0KPiAgCQkJZ290byBlcnI7DQo+ICsNCj4gKwkJcmV0ID0gYWxsb2NfcGFtdF9yZWZjb3VudChz
dGFydF9wZm4sIGVuZF9wZm4pOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJZ290byBlcnI7DQoNClNv
IHRoaXMgd291bGQgZ290byB0aGUgZXJyb3IgcGF0aCwgd2hpY2ggb25seSBjYWxscyBmcmVlX3Rk
eF9tZW1saXN0KCksDQp3aGljaCBmcmVlcyBhbGwgZXhpc3RpbmcgVERYIG1lbW9yeSBibG9ja3Mg
dGhhdCBoYXZlIGFscmVhZHkgY3JlYXRlZC4NCg0KTG9naWNhbGx5LCBpdCB3b3VsZCBiZSBncmVh
dCB0byBhbHNvIGZyZWUgUEFNVCByZWZjb3VudCBwYWdlcyB0b28sIGJ1dCB0aGV5DQphbGwgY2Fu
IGJlIGZyZWVkIGF0IGZyZWVfcGFtdF9tZXRhZGF0YSgpIGV2ZW50dWFsbHksIHNvIGl0J3MgT0su
DQoNCkJ1dCBJIHRoaW5rIGl0IHdvdWxkIHN0aWxsIGJlIGhlbHBmdWwgdG8gcHV0IGEgY29tbWVu
dCBiZWZvcmUNCmZyZWVfdGR4X21lbWxpc3QoKSBpbiB0aGUgZXJyb3IgcGF0aCB0byBjYWxsIG91
dC4gIFNvbWV0aGluZyBsaWtlOg0KDQplcnI6DQoJLyoNCgkgKiBUaGlzIG9ubHkgZnJlZXMgYWxs
IFREWCBtZW1vcnkgYmxvY2tzIHRoYXQgaGF2ZSBiZWVuIGNyZWF0ZWQuDQoJICogQWxsIFBBTVQg
cmVmY291bnQgcGFnZXMgd2lsbCBiZSBmcmVlZCB3aGVuIGluaXRfdGR4X21vZHVsZSgpwqANCgkg
KiBjYWxscyBmcmVlX3BhbXRfbWV0YWRhdGEoKSBldmVudHVhbGx5Lg0KCSAqLw0KCWZyZWVfdGR4
X21lbWxpc3QodG1iX2xpc3QpOw0KCXJldHVybiByZXQ7DQoNCj4gDQo+ICANCj4gIAlyZXR1cm4g
MDsNCj4gQEAgLTExMTAsMTAgKzEyMTMsMTUgQEAgc3RhdGljIGludCBpbml0X3RkeF9tb2R1bGUo
dm9pZCkNCj4gIAkgKi8NCj4gIAlnZXRfb25saW5lX21lbXMoKTsNCj4gIA0KPiAtCXJldCA9IGJ1
aWxkX3RkeF9tZW1saXN0KCZ0ZHhfbWVtbGlzdCk7DQo+ICsJLyogUmVzZXJ2ZSB2bWFsbG9jIHJh
bmdlIGZvciBQQU1UIHJlZmVyZW5jZSBjb3VudGVycyAqLw0KPiArCXJldCA9IGluaXRfcGFtdF9t
ZXRhZGF0YSgpOw0KPiAgCWlmIChyZXQpDQo+ICAJCWdvdG8gb3V0X3B1dF90ZHhtZW07DQo+ICAN
Cj4gKwlyZXQgPSBidWlsZF90ZHhfbWVtbGlzdCgmdGR4X21lbWxpc3QpOw0KPiArCWlmIChyZXQp
DQo+ICsJCWdvdG8gZXJyX2ZyZWVfcGFtdF9tZXRhZGF0YTsNCj4gKw0KPiAgCS8qIEFsbG9jYXRl
IGVub3VnaCBzcGFjZSBmb3IgY29uc3RydWN0aW5nIFRETVJzICovDQo+ICAJcmV0ID0gYWxsb2Nf
dGRtcl9saXN0KCZ0ZHhfdGRtcl9saXN0LCAmdGR4X3N5c2luZm8udGRtcik7DQo+ICAJaWYgKHJl
dCkNCj4gQEAgLTExNzEsNiArMTI3OSw4IEBAIHN0YXRpYyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZv
aWQpDQo+ICAJZnJlZV90ZG1yX2xpc3QoJnRkeF90ZG1yX2xpc3QpOw0KPiAgZXJyX2ZyZWVfdGR4
bWVtOg0KPiAgCWZyZWVfdGR4X21lbWxpc3QoJnRkeF9tZW1saXN0KTsNCj4gK2Vycl9mcmVlX3Bh
bXRfbWV0YWRhdGE6DQo+ICsJZnJlZV9wYW10X21ldGFkYXRhKCk7DQo+ICAJZ290byBvdXRfcHV0
X3RkeG1lbTsNCj4gIH0NCj4gIA0K

