Return-Path: <kvm+bounces-56383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BDBB3C5FD
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 02:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C7813BF60A
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB832EB5A3;
	Sat, 30 Aug 2025 00:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RmUIYNbt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF38223DEF;
	Sat, 30 Aug 2025 00:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756512018; cv=fail; b=GKj7CBFeBZ5ekWgh3Kin6XssDXrxnb3M06hJy6UkjVcMIYPIpoTbEszjoGqHWgyfD7mKmE9A8XT8hG/Fg8yY91PUNuxibkknt8HZoVKDNgDbXV0q/+SbjWksTnf8gtWMn/RmoEMHq03gMmLGBoWA9ne5Y5bmNIsso1aGXRS1I3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756512018; c=relaxed/simple;
	bh=JqIF6wv8sLCnxmTKqLKJOkofMHNN2r0iwBHiO9cXCtg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nB2f6DZ2E1LD0Gr7qY08a7AO9UjoKgN9W7ochf54kkCEcCR7RN/uVo6zAgCJevUEi9084wQfyadabC0mLtjW158ejPcXRx6DbzU1wS30OoMxffXbiwmLRmAPlTm3e8ccJjqHh/UQ3eknm/oRC8XzmH5EL3DADNWovs//sU9UoW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RmUIYNbt; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756512017; x=1788048017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JqIF6wv8sLCnxmTKqLKJOkofMHNN2r0iwBHiO9cXCtg=;
  b=RmUIYNbt/19mj7FCBJFfY8jVjYaKJuhJgJQClMeiQwcIplk4OPGYz5b4
   gGVHRoI1XdKuYtvfT5k3q8T4konqFLEFybjEBXUlvKUiuz5tf3JbYfrTm
   +8SyrxpY9FQMmBuwmPLv9gaN8hIk12mK3m2BslVaoGcL70b9YQ6ogZyse
   Zw84RvycodCPTTvAdu9Q9+/lwzybKjWS/TROZrw1RfJyNnG/41B38cOfn
   6C7CsT5zvMvVNr7/u6GSXarHd3bmM7yngC6Ff07Cji0U5XlsQRZkUqvOR
   155/EgJ6rA8393wVfeoqcZFIsjIe1a3BTafGsWfX1MNl86rEUKjaPj0is
   Q==;
X-CSE-ConnectionGUID: YpNjv/h3SXKtjJLgYTomPA==
X-CSE-MsgGUID: aY/AwAIwT023jOTrMNOv/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="58872183"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58872183"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 17:00:15 -0700
X-CSE-ConnectionGUID: 1k/4rGnfQ6afSe8MpKzGIA==
X-CSE-MsgGUID: tBvMGVePTp6n7nUpt89waw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170400501"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 17:00:15 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 17:00:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 17:00:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 17:00:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuqkvCDAixkYPq2IftizWFQBzRnAFNGLKyD7JcFlLXuuTgYf8uLSY1VvEHs1Ma84Ftts5+q7e/rRwCKQnpwD9XvToc9kFN0NdQeitqCn8M6JQl9fWBS3nGqar7op5X5mPLzH1whjjxH5Su2nHC4d547KoFIdXRlA9sCsk/Fhxz3hEUBTWCM9amO/EDRdXcSq5/YxVlJBGvIADiHXykcv7hnHq6HgvgYu8s6t4+ObaK5uVqTJuij3o3plzOJIHAQSeSXbrGppUGkmH+c3krnDc1g9j3HN0hw6a1z1NrSNjNe5KW+5n8B3rLLinHJXk6630ydI2QBWBxk/FrVU9zPwNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqIF6wv8sLCnxmTKqLKJOkofMHNN2r0iwBHiO9cXCtg=;
 b=iQn5+E4ex7ZnyA++3sEmz3mz35Dd1phnaTrtN9a/BUKfcQ0Kjoy8nArQHe1cbYgWtUo26Tusk56pyYxhl7u+ohLN3rp/QlyER8DFPby5tLjk/bJ4cRtBMyTxxo6MuelWKO7sL5EJerS5ZA57/L7+8RpPEot+9l4IGKAtQyC4HvphAxcsFlXe/4Ipzv8DZqNdQ34wniATQ0nMYBd+eddK3d1+/CxfA+V9neRC/sCelnZHPksnMYSdPwjapTwYCiGOb1nJIL1NLHUS06s0Qc8OgWC0AvCzuWKYhsiVRsaWQ3O8/jnAlPPlVgIibwXITiqPiUQYFGGrVpXRp+wWlj/q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6488.namprd11.prod.outlook.com (2603:10b6:930:30::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Sat, 30 Aug
 2025 00:00:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Sat, 30 Aug 2025
 00:00:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 16/18] KVM: TDX: Derive error argument names from
 the local variable names
Thread-Topic: [RFC PATCH v2 16/18] KVM: TDX: Derive error argument names from
 the local variable names
Thread-Index: AQHcGHjWp7aMifHk/ECAWv71HzxMcrR6USKA
Date: Sat, 30 Aug 2025 00:00:06 +0000
Message-ID: <dc3f18f3bae563c709ce15906a6d171b035de1de.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-17-seanjc@google.com>
In-Reply-To: <20250829000618.351013-17-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6488:EE_
x-ms-office365-filtering-correlation-id: ab574191-a917-4cbe-9a9a-08dde7582d63
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YjIxZlp5aWx1eVlCTDFtTno2YTdLZVJWZUdQaXFlTUcyNzJGa2g4SDZCSEhM?=
 =?utf-8?B?ZjduL1dxSWpFcE4yRVAwOGpzcGZWVGM5Q1VlTStxMDBjSEdISy9DaXNSVlZu?=
 =?utf-8?B?a0dkVUlYbzBrbGJ6WFRXTGVCbENmUjlzRHFDTUxYL0hsM1NzMVNSTmswVFE1?=
 =?utf-8?B?c0IvZm1DTm9KeDFlT3RSelpaZ3dndnJvWi9XS1dBdXVKUUJ6OTlKMGxTN202?=
 =?utf-8?B?UXhsbUpEUnlHc0ljb1FYRW5MSVFnQ2hWY0xpblU0UHl4cSttZG1neWNlRlE2?=
 =?utf-8?B?WXg4bm1ER0xjWnVIMk9UenJpbGJXSEFkZjJzT2hJWmp2NjBaYzZhN0JSQUJq?=
 =?utf-8?B?aVExRllWWHV6Z25jOHR3emFzaytiZmtjSFRkRmlDVjFtbjkzcnJkU01wNHlq?=
 =?utf-8?B?aW9tbm5HYUxxcE03QkUwcFNydmpPQysvNVpyN0pyMEcwdzFDNmVpQWxzOUds?=
 =?utf-8?B?WkV3V2ozRUMwbEtUcEQ0aEZ0M0NIK0MxNnh5RkVkdGEzdk04RVBSNmxCNTNy?=
 =?utf-8?B?c0VyeGNWdXJWbENCM0I2cVQrOTg3cllBY2toaHZIaVZicHRySVpBeEtFVkpa?=
 =?utf-8?B?YjdxRGtpaVlYS3Q4Q2xoYWMxeUhpaDdFUzhURVdkcXo0ZjVhOTZHRmdleCt3?=
 =?utf-8?B?aTdqeE5rcWp0eS8zQWZIZ0pSZlV6YW1pUmZRa1JxTWt5elQ0aG9aM2dFR29s?=
 =?utf-8?B?VjJGdDZ2U0JWTjNuT3BrbHZDWUtXTGFJdHd4NnlCbVdNSlZzRnBBVExtOWsy?=
 =?utf-8?B?Qk5XNW9GNTVHWGVpZ010azZISHltU2ZaNm5zalRXMlYzTGRvckQ0blI1bWkv?=
 =?utf-8?B?d0hEU0tjbHBKV3hzOURQRkNDMUxxdE1NVWtZU09SZ1MyY2hmd1VJOHMybWFo?=
 =?utf-8?B?TFh2YkExODdzejhpUy9seEU0akxTdFRRR2dhblhqY2JaSVZxSDhjQTZZS2VJ?=
 =?utf-8?B?dkIwSVBFS3ozd0dkQTdlRkN2NjJoeXZiSTMxc3dmV0xKWEhJUjJpeG42VWxx?=
 =?utf-8?B?ZGdVMjZ3K2d3WGl5THQ0UWVyaUVqWk5RZ1haVEYweUdqdEZlRVArQ3dhV1pV?=
 =?utf-8?B?WlViTS9tR0xnNlVlVjdRMHBnQ01pNVF5QVQ5V0hhNnAxL1J3S3prZHg2RmxT?=
 =?utf-8?B?bVJNYUVqK25STEEySUxtNlNXb1Y5QzNuanlaVzFIbjkzSUxOYmdZWTNYdFRS?=
 =?utf-8?B?T0hBdDZ6cnFhNkVKVXNDNE9BOXVKV0NQM1RyU2IyVlNCWFlMVjJyZ1J3RllP?=
 =?utf-8?B?MHBGUlI0VGFDcGV2bXRzR2lRZzA0UXBDZjVGN2dMb1pUdWtMcVE1NFU5SWJ6?=
 =?utf-8?B?WXkvbkYxNC9Xeno3d3U1MzU5UkJZZmxMbDFQbjlNOHlLdDlqSnllbFhpWElW?=
 =?utf-8?B?Z0VQRHFLRjZFRmRhdzlDMWZoT2d4OW1RanBCK3R0Y3IzcVhGN2psWk94NUhp?=
 =?utf-8?B?MzZrbXZMWTVUQlBsRE1UZUx4UUliTXQzVFE0anZvdVF1NzNzWUg3Y1hYTnN4?=
 =?utf-8?B?Y0xQN21naWJUWGFEYVNYTU1kNVB4dUowMmVsV3gwRHg4QTQ0Mmk2UHBKbVEz?=
 =?utf-8?B?VkMvVFJ3U2lBRFkrVWxwbTFNOWFNcWhYcloxMGxQa1ZnMTcvcnJBZk1LY3Ru?=
 =?utf-8?B?YXN0a0RSd3NyemRNSFpsblU3bW5JME1FbGNVZzBGeUVNQktIMyttYktqYXRS?=
 =?utf-8?B?eG5iUjljc1ZwbWFkanJwK3hyOENZM0QwbmxWQzBEdmJwUGVXdWg0dW9QYUw1?=
 =?utf-8?B?QUFNdXYxWkZUY0o2YTc5S1psQjNpaVNnamdwZ2kybVhsWjFtZno2U0kxQWd2?=
 =?utf-8?B?K2RYMXFuTW1lcW9vc1pLdkI4eGw5RTJJL1YzZ3NQTHRwRyt4THJSY01YbFVn?=
 =?utf-8?B?ZlJwUFQyTTQrWlJia0pEdnNWSjZoMUxTdStxK2JkaUpZbi82UkoxVkRzRFdt?=
 =?utf-8?B?M2FBTXFWalVpS1JiTHVLaXZBWEhUMFBjblVwSC9CMTRrMU91U2d6ZFN3TU5G?=
 =?utf-8?B?UEdna1I4TDZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlpsOUxIVnVFMFpRZkFsSWhmVm5FV3ZlOS9UeW13MmtFZVJsRU44K3d1TTlP?=
 =?utf-8?B?bzhYdzJtcVZHTEtZMEtsMWNMY3dWcmVRL1QxamplT1RGdmIyQWpqTEdMa250?=
 =?utf-8?B?K1d0Q0dnNzhUVi80UTVCUnIvVkZMcHVMcUd3S002VzNGQmNwOUY1S0oyVTdY?=
 =?utf-8?B?S1d1SlFUTnJYcXdHMlFvLzhJaGJrL3NvbU02bjNJVjU1Y0JMT2JEWk1CdWRr?=
 =?utf-8?B?dW5udGFwUVBMaW5ELzFvc3FhazFMNU9BVTNXcEVjNVFDcHR3QmZ0RDdua0ZR?=
 =?utf-8?B?V2ZVN25nRFBNZm1lZVYxQk5rcEFZcmJKNXdMeGJwa1pNbzArZU1ITkE5c0Q0?=
 =?utf-8?B?VEJ2ZlNNbEx3MGNQTlZTbXk3YTBiT2RPSGdyQ2hKVkRFVDJGa1pseDZidlcx?=
 =?utf-8?B?ZEFrTFZuUEo1MUdnNUJVRDdVM2ROeHBHYTVaaUtSZThseE9yMzRadUg5VFla?=
 =?utf-8?B?eHZQMEZiWC9ra2VXYUNzYkx5cnYyZENKOGxYYzkrR2wzSUxhWTlQcWt4UzF0?=
 =?utf-8?B?bFpYTkZ2WnVESDJPdTF1ZCs5Zzh3T2VVbXhpSWsvajJlYWIxajhzREdMRXpq?=
 =?utf-8?B?aU1aelVsOEs5RDhZcis0alF1ZjlYeDdTL3VrTGRCWXM4RFNYZDllVjZOa2Yy?=
 =?utf-8?B?ZG1VWFU5ckVmSmYyTzBoTlcxekJmQlBQdklhbFNvRGtmRXBYNWZueTFxZFNT?=
 =?utf-8?B?QTJXRElvQnlMMTIvQlVuVU1sZ0tuSFo4cjRWWms1R3hCODZTRytpeTZUalZF?=
 =?utf-8?B?SHFqa3phYXVjcEFBYURCaFJtUmNuK1NyS0pEVE9CZVdUYUZMZ3ZXRjRsUklP?=
 =?utf-8?B?Ym91K1dsQTl3djZ0L0paUU9sOUJSNU5hdXF1TVljVXN5VHJET3R3L1hieENo?=
 =?utf-8?B?V2JOT0JvOFprL095dHhXaitucEIycXBydVBIdDNzZVZGazBGTHhlVUJMNkto?=
 =?utf-8?B?WnQ5MWxXU2RsRVVjN3dQeUIwQlRLUUhsSHVOMTVZcVZYN3lyU3N3ZjIxZGht?=
 =?utf-8?B?eXlCR09wK3lDWHZqNEtOV0M2V0FPTVQyaVBEcy9FVndCNmt5QmFrVnhQWXBw?=
 =?utf-8?B?VmZtSDBIbHlvV0prYU50dzNWUFN4ZWRZdERMMTJJd21zbGtUTGxwSnJ1ZHFz?=
 =?utf-8?B?MWR3d2tRMm1JZlI4c2hnVmtWTTV6UnNoa3FjOXlvVFlmQ1ZoTm9hWkJHSXBh?=
 =?utf-8?B?N1Y1NHY1ZFJxU01vRys3TFhXaTZ4NGJjVU1sUnRYZDhrc09IQ0JrVFJHN1ZF?=
 =?utf-8?B?UmFlWFAvUHpNU3MyMTlqdWdCdVpsb1hBTTZBYkhkK1dKblZRNmZueUJDWTJN?=
 =?utf-8?B?amxzYkdpLzJjQlFydmN5NklIemVSK3B4YlpCanZoYTRUWG0ybGlwbUF0SEdS?=
 =?utf-8?B?a0h0MEJiQnNERC82dGt2RDluZXlnUUxBWlEwZG1sSzNIcjZZd29wK1ZJRjBa?=
 =?utf-8?B?a2NvajV5RkkxQ2h1SlY3TmVUN05iZ0ptMDVMZDVaYzdUNCtIL1lzWFRTcm92?=
 =?utf-8?B?cVRxeTBYUUpna2c3NHpOSVR4eWk5T0pSRSsyREFFMm5GTlZENmVGalQ5NzN2?=
 =?utf-8?B?RkhwYUVwbmJET1p2QmZjNmZIWEFEY2ZkMi9zSEVKdzhkY1BWcmxPMW9nWkFs?=
 =?utf-8?B?SVRMalJ1RCtwaFNZMlpPUjNwM2pYTTVnWnA5RXpUelNRbVo0RlplR21zaFJx?=
 =?utf-8?B?UldkcFA5d2pGQ2NNZVg0RzRHd3dTY3JiRU5uUjdnZ1FGUmpEZEREak5XVFV1?=
 =?utf-8?B?TlBpNnRUeVFZQTMxZkV2ZVJsY252VzlMQ21GT1pMOUpUREF2UWZCSUZ3S1FL?=
 =?utf-8?B?TVVKNkJlTGZZUWYzd25OcHVoTTNpQ1dscHJGYUFCbXdlZTZQWlNWS0p2M2dG?=
 =?utf-8?B?STVzSGFWREY3WGNOSkd0clMyd2U5WW1UR3QreG9ON1hoU1AyLy9nWmVQcXZm?=
 =?utf-8?B?dXc2YzU5aGM5c0w4QkNSUTZPT3d6N0RtS21rekVVTXZCWit6clY0dVV5QzQ3?=
 =?utf-8?B?LzN2dGJEeVcwWmtJamFRQVZ6RmtiN0laZkJQa2lEZS9oTklKQ1Y5akhubDZQ?=
 =?utf-8?B?d3N1cldmb2g1UkJLdUE5MGRYcGhWTHRuWGZDRktMdXAyU1BwWDFGNWRJKzUy?=
 =?utf-8?B?N0JzVHluQStZRU83S0tNMDNzdkFiSWVhVVBSbjJOVFcveGo0dzBkVklEK0lz?=
 =?utf-8?Q?dIGQJgftWl9SNTe8DSLOSaM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10D39D2F89AB5D43B8E3A9F30C0CF27D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab574191-a917-4cbe-9a9a-08dde7582d63
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2025 00:00:06.1096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+FImxGTR+v4Px7AedUUweXL7mGjfxxbiPab+Rv8dgz8z9+MikxG/TyVO0GvVZ8WmsjloYvQO2i4+4q45moivbhANTDc53y88oiTlcmaE/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6488
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXaGVuIHByaW50aW5nIFNFQU1DQUxMIGVycm9ycywgdXNlIHRoZSBuYW1lIG9mIHRo
ZSB2YXJpYWJsZSBob2xkaW5nIGFuDQo+IGVycm9yIHBhcmFtZXRlciBpbnN0ZWFkIG9mIHRoZSBy
ZWdpc3RlciBmcm9tIHdoZW5jZSBpdCBjYW1lLCBzbyB0aGF0IGZsb3dzDQo+IHdoaWNoIHVzZSBk
ZXNjcmlwdGl2ZSB2YXJpYWJsZSBuYW1lcyB3aWxsIHNpbWlsYXJseSBwcmludCBkZXNjcmlwdGl2
ZQ0KPiBlcnJvciBtZXNzYWdlcy4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogUmljayBFZGdlY29tYmUg
PHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQoNClRlc3RlZCB0aGF0IGl0IGFj
dHVhbGx5IHByaW50cyBvdXQgd2hhdCBpcyBleHBlY3RlZC4NCg==

