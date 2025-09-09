Return-Path: <kvm+bounces-57097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8585EB4AAF4
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 793A81C61A23
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B161831CA46;
	Tue,  9 Sep 2025 10:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jR7MbKVl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D324223ABAF
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757415323; cv=fail; b=VXIrDXE7iE6XBTDigVM6jfRrYKCqEtjtJtqNcyvBAD7VRbkEvd4EUb8ioOg10zSCZuRFwuA8EGmpqzuPkcD6AIa1WOQPTeTjcmxfECaGnjpJxR/bN+L+7J+tWNyawUhYw3rkv2Q7iHEcy+nmXA4N6W9FYUIsMXtSQkRmgXyUELI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757415323; c=relaxed/simple;
	bh=Ayuu3kHfyto4fnOabA8y9rDBA4rzW08j1cgW3CucWek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rv2ZXcbNAeCL29JQxBEv2MFhH7YU9FisdiOmi+6m+ajDkxDvg/Ml1MTfQO/+ysIqNMsjbMiciVpv9OxSW8gU1jwrTmR8hwr77kHb+GZCoippg1eQipD9Bx+8wfPMF7VhMVRto/OfeYg5UrDPp4apUCbasbJ3XApLZrZoK8si8U8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jR7MbKVl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757415322; x=1788951322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ayuu3kHfyto4fnOabA8y9rDBA4rzW08j1cgW3CucWek=;
  b=jR7MbKVlEEuQB/QBRnmaO0wmXfHRsqEcy99eN7/XP+IqZeJERab3gYt7
   dam1azTk1Tl/CvXdzT3KAs/7+upifScnfbqAST3/+h5UB6xx6mG1c+epG
   QBaEWDe6udwEiEExCYj3+DZ3Gn0VPccxkPo30/L3arJMt22Wlb9IyeisP
   FNmfHe/RNZwKWoXhrLOkpMkWqW7G6OihAeOcDvno+F7LzYDK5ZSp4tef/
   oQqoQVLK94FpygidZuOUgHljFJ9k2hoQ2ikSr2fbESPB7hOHkDn35XwRY
   d2ImRTCT69SnmELTGQ2x66aPXM+duVICYGALm3kJ5IYLVFPCFIbJnbS5Z
   Q==;
X-CSE-ConnectionGUID: ZWGXcQeyTLyU8FyFJDjLgw==
X-CSE-MsgGUID: ZnSMZDcgRzmU5oC7udmAbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="69949111"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="69949111"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:55:21 -0700
X-CSE-ConnectionGUID: M9tPLe2bSBC8r0oqMKBGgA==
X-CSE-MsgGUID: tWm2n2BPTu6QBAczhQAbgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172630372"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:55:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 03:55:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 03:55:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 03:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhlKnccuQl6vaxbNBfRRktlRsDOi9OfroXqEpQpi7F7b760TwzF4E1ZUqHNzSRwgfezaWlqWxAAhuFuVw1Q5BgBSW0xMXkmPxRqWwItJlCJ76lIhWISl4Y1Z8xJilSXpMVC0T27buguC4Q1ct3MOzZh/QhhoI6HIPz0YEDbXi+R5mv43W5IIgDFqTHsHxKKPAQ499f8HBLNCSfk4R1E3glLf+/QP06UMPjlVbkdu4bqKfRfIs7ytva3whBOdj4/aFUzfAgPT7USPS0opFBM48cZsmYnMkomdJZ4mwWR42PEKb4Kif8h1ewzT9YOvi7dFLZd7aRqqLzKbdIZNs8PBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ayuu3kHfyto4fnOabA8y9rDBA4rzW08j1cgW3CucWek=;
 b=FxyrE34Y1+h/LGTIY9w7Vl2mVCKDtvMGBqY1bECBUzByLfWRUK+dU//SXuL/Ohr5xwlhvnLBkvaUpuEBEAsTWTaQpqXxpa+xXYaKjfTinzO2Rsz5GfI1EaPZsZALfEo9b6X58sBiwUXhhPbjhs3Tv9ebjH5rv7MuTjXGxCP9EVIvQinSeqY2vlqHnMTVeT5WxsCFPfPS70JsoviPwVlbrmKHHIcBX7vzmQDCNnoid49zd7fYx1tjA07U96cc2TxvavIVP7Z8BQHzzRvq8zYzSZWthjnxEFEkALRE3CGJPvedbBeeyGsVRZmbsqw6/VQTr0CGS+x4ZZlvY7M1Q2zZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV3PR11MB8553.namprd11.prod.outlook.com (2603:10b6:408:1b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 10:55:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 10:55:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for
 __tdx_bringup()
Thread-Topic: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for
 __tdx_bringup()
Thread-Index: AQHcIXN+q1OgUjX1GUOBud0m71VFmLSKrYqA
Date: Tue, 9 Sep 2025 10:55:18 +0000
Message-ID: <20e22c04918a34268c6aa93efc2950b2c9d3b377.camel@intel.com>
References: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
In-Reply-To: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV3PR11MB8553:EE_
x-ms-office365-filtering-correlation-id: 25adf566-9415-47d6-0c9d-08ddef8f5d7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cmc5L1l3ZzV0MnRCcEozMldQU2wxc1oxL2pTZzJZQS9rTXB1YS8xNlgzbDc2?=
 =?utf-8?B?VjhydmJNblhuNEUxTWp4MlFDR1dvUzRlZUVsUk56VitHbXZtTU1KVTNWVWpv?=
 =?utf-8?B?end0WkpXWnhDMSt6SkVaSSszK09YTEFjcTJpWXlDbEFiNkh6OUxDMmxmM3Nu?=
 =?utf-8?B?cXBjY0xyVE1Ub20wZFYwcjV5dGFxZEI4dW1Xb1hxZGJBd1BKazNHU252SDV2?=
 =?utf-8?B?b01JZ252aXNGdUxHSll5YWZSZmxia0p6dmlaWXVRWk55UUhRa2ZHWHZ0b1dP?=
 =?utf-8?B?cnNqRUJqOE9INERqVk5kdmJJemxXbW5lNXhWMGEzTEZ1WjVqSXVQUXRPUWRh?=
 =?utf-8?B?NVFwUElpc2lCYVZaRitONmdiVzBGVkluYzJtODlGSGxBaWMxV2ovOU5iM1cw?=
 =?utf-8?B?Z0lrZHhGdStKWktoYlpXQ2NRRUlrS1loMXhFSGEzaG9NUXlLUjZxU1RiZjdi?=
 =?utf-8?B?UW9PclBwTWY2MGhDNEJ6SFBNZnl2ZCtWK0tOditwUm5pSHA5Ty9ISTdyY01Y?=
 =?utf-8?B?R0hKbXg5OENaSEszY3UxakRGNWRJL1U5VlcrclEvSUw1c28vOFBxMVhOdmQw?=
 =?utf-8?B?QTZGbkJERUFJWlVVTkxzc3V0WE5CY0lWdDQxNFdDekFlWGpiVkswcTZTZUdr?=
 =?utf-8?B?NXJyc3MyWjA4V2Q4aXltdlM4bnhuSno4MEZyQnZBcWlYaGVoNTRNMnlWY2xi?=
 =?utf-8?B?YWxMYTg5R2J2dllEQUJyTXFwS055WFFtQjQ2RkE0dmJYV2k3STlPM0NmTFov?=
 =?utf-8?B?Zk9pWWNSTCtjM3JxTGR3WmNrTXVMRVdwWVRSWG1IeWE0d2UwSzJ1Uk5lK2l6?=
 =?utf-8?B?cjc5WTBvcDZsSEV6ckZQTVBob0kyaXhqNUJSU1ZCTWJBc25GTzRUQzNDRlE3?=
 =?utf-8?B?dXNDQm9yRXVuNHJ1R0VNSjNvRlRXeVFFV2RDalVxSHNZbnk0L2p1ZURDc0kv?=
 =?utf-8?B?eWZsb2trZ282aDJ5K0U4VTVCOFg2OXJESVcweUdHWWdKUEI1VFdXVkt5Skgy?=
 =?utf-8?B?NDFaSU1tR2pKbmlqSzlYcit3VXVaTWY4ZDdMOWNYS0dZVkk1cHBiMWwvbFRC?=
 =?utf-8?B?ZWY2Vis1RkxyRktPcXlLekl1QzJwdmM3bVordldYeVRGWlZjM2UwbUFFc2h5?=
 =?utf-8?B?T25oWTUxTFkzNzdhUnovdnluMWI1R0RFbDFKQ1JMTmIxc3RUb1B5cjUvS0Fm?=
 =?utf-8?B?NUd5MEx0VlFYUXFqV1p1VkdaSDB4NXVReWs1V3pDSnQydnVqZnBQKy9qWDF2?=
 =?utf-8?B?MU9oSnVDY0dqdWhUdjFDRHh0N2JnWXJaT2xac0s3RFl6YU1GY0ZvbVNiNmdD?=
 =?utf-8?B?eTgwYm9Zekc5ODY5eEVRL3h0Z2NCNDcxTDJBMHhYSVNoRkZXeHVoODJ5YXF4?=
 =?utf-8?B?UFlzY25lTzlReDVueldHK1hpYmFkVm9zTCszTndVRGpFb0hWU0ttems2REM1?=
 =?utf-8?B?Z2l1bzNIaGR2YjV2aS9MZm53anlDa29qVjNBOWZLUFdvSXdZUWg1a2NNWjhZ?=
 =?utf-8?B?SE1Od0dwMUZJR2ZCWjM0V0JqclpRUU1qY0dqMUFKOERlSmEyL0FBUHB0V2R2?=
 =?utf-8?B?VUUyM1JESjlYczRRS1J3TWtQdEx2dXV0dWJ1UGEwU2NJaThITVVyc01HelF2?=
 =?utf-8?B?TnFIY0x3NTA0bGNGSTZZdUFVaHVJQnpoWWpxWmsxbzQrb2xudmNKRHpyRWdl?=
 =?utf-8?B?SEFmMktnUE5nSEJ2OG5vRDFlZ2IyUUN4djJGSWVHRlZMZENVcHNybXNEWWxT?=
 =?utf-8?B?emZ4cEI2Q3ppbkZoQW5LRUJvWXptMlVEWkp0WjVXWElxWjRvcEliaDFKM0gv?=
 =?utf-8?B?RUVEWGJaY1RqemorTzAwL0JuYmpJY3FEV0E5Y2JXU0JqM002dlRjZjlSQ2E5?=
 =?utf-8?B?M0RMVWZETEE1anhua3U4U0syR3AyYU05SEVoNER0aWY1OUFGYmZXNGhNVjVE?=
 =?utf-8?B?YU1sV3Fpd005ODh3YXZWUy9mUHgzdEhOWnBBUUIzYU02Z29rd28zMllscW5r?=
 =?utf-8?Q?a6bTJerPjm0KPTnMUcT346qEK9w8ic=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEIwbGlTK3JTWkFqYlRqZ1pUdXNuMHlZN3pLbjI3L0FWUjVmZTZOUHJsd0Nq?=
 =?utf-8?B?WEVNVjJNd0t0SENJRzlrOTQ4NWtwQkxHait6NWpNRVNWRmJ4NkJLUHFORCtN?=
 =?utf-8?B?NjhyQi9yTEN3S05KMXB2N2pTa1p6a05YWTBXaWdJclY2eDArc2ZqY2xMdGI0?=
 =?utf-8?B?cnZjZG5zcXlZeEQvSlNaUWJIRWovSU1VMjdVZHBVZk40YzQyTHNKNFZjVnhP?=
 =?utf-8?B?TkRQV1VaR1JQdGJ5WlBZK3dudHJPOFAzanUwd1k3YVZaNlRrb0ErNDJzSTN3?=
 =?utf-8?B?dnk0NG41K3pyNGFjcVpTaFJwWlZsa2FRTVhKTjRyZlNWMHJtZ3JrNnlvc0o1?=
 =?utf-8?B?N1Q0STFXZU9Nb04wcFVTenB0WEJhazFmOE8zaWorRkRxdFJzUkxiYTJ6aEJE?=
 =?utf-8?B?bmZXTkVnZko5R1pYRFV2TU1RWjJXZTNEcGpkdDJra0tzY3UxSGxGK0RRZm96?=
 =?utf-8?B?Nkx4Y01HZWhzRzRIZnNHWXhjWXhvS2J4bkpibFl2bTRDbFBIVjVabVYrc1hN?=
 =?utf-8?B?TndBekVHcVRGdXIzSXJoUlJMcC94VGpMQk5IUGx4VWJrdVJUK0xzcG1yMVk5?=
 =?utf-8?B?Zkt5dVdIUUlXaU5zdVQzOU5qV1d1TEZjRW4yZXZDMXo0U09lS2YzdEhHQkc5?=
 =?utf-8?B?aWt1OEsxQTFYdHljbXpodGFBdUQ5MkdDS1puRUdLdDJTSnNxOENIOEpkaE9K?=
 =?utf-8?B?SnpCck55NXRzOSt3Zy9MdStJNnpZcEgwa3NXdnE0TDFNaGl4YWdiVFYxbEdX?=
 =?utf-8?B?aDUvR2p0MGE4M1FCVlI4cTE2ZHFMVnFDSjRxSmFEaXZHWG83QzdxcmtmME9p?=
 =?utf-8?B?UW1uQzNHLzhZcmoyZnlWV3Y1aExqMytuNWhqa1ZWeVpDNXozR2dVcTdKUkFm?=
 =?utf-8?B?bjVNb29EZmNOMzhjN21HS2NSc05GMFhydmxvNlZYM2F2aFlYYzFxNGpJNXlH?=
 =?utf-8?B?V3NPOVVWWm4vK1J3MS9yajEzd2lvdzFlUWRuQkozRTJaOS91ZEFCWU4vT1pY?=
 =?utf-8?B?ZjVwVi9BRnNGaDFKeVFBK2krTmxFTC9RbEFoUUJ4QjV1SnV6RXVubzVTNGRW?=
 =?utf-8?B?WThTUGZSK0FwOGRyb3p2ZlJxelFDZzkzKzhaVURJZHRRNUJ6NUpYaVBoQUdR?=
 =?utf-8?B?bW9mTHkzOHJOc2xtNDdzZHFaNEpmYVMrRXpGZGVBemJlM2hrN3kxODNNVEFH?=
 =?utf-8?B?bWp3L0xuMzBxZlhZSmVMMnFLL0FEVnJCcExPVGxzTno2TTJsTDYxV2pBbW9N?=
 =?utf-8?B?V0hTbmlvZ2Y0MnVpa2M3MWR0STZLM25CMHFRbVN6RUkzSG5nNXp3VS9yN0xy?=
 =?utf-8?B?U0Z1Y3VQUEVqcklUWUEwTUVmVUJqbXExL0N6WnBqTmlxOW5WODlJRERYRmRZ?=
 =?utf-8?B?MUVBZmZ2TWp2Z0VOdUduVUM3NzRFamhFSTlQY3NpSmg5VEwvS0pkZkJkcjRJ?=
 =?utf-8?B?cXpwbWV3ZSt5Uk1DUEh4czZSa281aEpEc2VhTmpWb3Q5aGhPUUlkL3IyWHNv?=
 =?utf-8?B?Uk9QcmhJY1VOcGhjcWE3Rk1EM3F5Vy9Gd2hQc08ycFhYR1lieUZac3lkT3RX?=
 =?utf-8?B?YWhiUnJBUHlMM1J1Sm9sYzV3WHR2b0ZWUVhDZUd3d3I4RXFHRXdjUUUxT3Y0?=
 =?utf-8?B?M0l6VEpUZEF4ZmhxUkFNSXJQS0xMVmkvUDZ6TVhzR3hGcEdHOEVOYW51MUhS?=
 =?utf-8?B?QS9Uc2JkRGJYaUtFTWh3UEpEdGpMVEVESXllZU9KeVozaGxvUlN2a05hQ1Bt?=
 =?utf-8?B?UEp1UDk2Vnd4THJTZk5WQjJIL2JDUmMvSXNtWldvd1ArN3c2cTNSRzRpdFB1?=
 =?utf-8?B?TXFhRElvSHNaZmZhWnNCQTNveE9EblJHY08wL3k2MEJFTHlVQkJ3eFR2NXVU?=
 =?utf-8?B?UVJvaDdPWnV0Tk5xNURmb3huTm1ycmtVZkZLUndhTkRWWHBQdVh0WVg4S2sv?=
 =?utf-8?B?MnY5ZkUyQWFrbllqa252dGlsSHllZTBiSXdlaWlmQjJjY2Z5N0ZGc3ozL1Mv?=
 =?utf-8?B?bDBFc2l5TlNRV1BIU0Z6N0RPbklURFZZQnJLWURYRWNwVlA1UnFQVVFFWURE?=
 =?utf-8?B?dTFzQXFWVC96TG1keUM5UXNmcUdFd0o0YkxJZkl2czZObC9iQTMrTDQ1WVNy?=
 =?utf-8?Q?1FO6Z7JP/e1Tv+Q3oCWbnxUnW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4B2D0FC81127B4785832375A0F99BAF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25adf566-9415-47d6-0c9d-08ddef8f5d7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2025 10:55:18.3853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OHuwB2EqqeKHrdOeu7ruN4fD/Ya/QZUU2MQtWBr+8D7FNlb34XMQBaXR8CAPVizhVw6zgP3N870asYrqvaaI9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8553
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTA5IGF0IDEzOjE2ICswMzAwLCBUb255IExpbmRncmVuIHdyb3RlOg0K
PiBGaXggYSBTbWF0Y2ggc3RhdGljIGNoZWNrZXIgd2FybmluZyByZXBvcnRlZCBieSBEYW46DQo+
IA0KPiAJYXJjaC94ODYva3ZtL3ZteC90ZHguYzozNDY0IF9fdGR4X2JyaW5ndXAoKQ0KPiAJd2Fy
bjogbWlzc2luZyBlcnJvciBjb2RlICdyJw0KPiANCj4gUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50
ZXIgPGRhbi5jYXJwZW50ZXJAbGluYXJvLm9yZz4NCj4gRml4ZXM6ICA2MWJiMjgyNzk2MjMgKCJL
Vk06IFREWDogR2V0IHN5c3RlbS13aWRlIGluZm8gYWJvdXQgVERYIG1vZHVsZSBvbiBpbml0aWFs
aXphdGlvbiIpDQo+IFNpZ25lZC1vZmYtYnk6IFRvbnkgTGluZGdyZW4gPHRvbnkubGluZGdyZW5A
bGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCA4ICsr
KysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9r
dm0vdm14L3RkeC5jDQo+IGluZGV4IDY2NzQ0ZjU3NjhjOC4uM2NlN2ZlMDhhZmQ4IDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMNCj4gQEAgLTM0NjYsMTEgKzM0NjYsMTUgQEAgc3RhdGljIGludCBfX2luaXQgX190ZHhf
YnJpbmd1cCh2b2lkKQ0KPiAgDQo+ICAJLyogQ2hlY2sgVERYIG1vZHVsZSBhbmQgS1ZNIGNhcGFi
aWxpdGllcyAqLw0KPiAgCWlmICghdGR4X2dldF9zdXBwb3J0ZWRfYXR0cnMoJnRkeF9zeXNpbmZv
LT50ZF9jb25mKSB8fA0KPiAtCSAgICAhdGR4X2dldF9zdXBwb3J0ZWRfeGZhbSgmdGR4X3N5c2lu
Zm8tPnRkX2NvbmYpKQ0KPiArCSAgICAhdGR4X2dldF9zdXBwb3J0ZWRfeGZhbSgmdGR4X3N5c2lu
Zm8tPnRkX2NvbmYpKSB7DQo+ICsJCXIgPSAtRUlOVkFMOw0KPiAgCQlnb3RvIGdldF9zeXNpbmZv
X2VycjsNCj4gKwl9DQo+ICANCj4gLQlpZiAoISh0ZHhfc3lzaW5mby0+ZmVhdHVyZXMudGR4X2Zl
YXR1cmVzMCAmIE1EX0ZJRUxEX0lEX0ZFQVRVUkVTMF9UT1BPTE9HWV9FTlVNKSkNCj4gKwlpZiAo
ISh0ZHhfc3lzaW5mby0+ZmVhdHVyZXMudGR4X2ZlYXR1cmVzMCAmIE1EX0ZJRUxEX0lEX0ZFQVRV
UkVTMF9UT1BPTE9HWV9FTlVNKSkgew0KPiArCQlyID0gLUVJTlZBTDsNCj4gIAkJZ290byBnZXRf
c3lzaW5mb19lcnI7DQo+ICsJfQ0KPiAgDQo+ICAJLyoNCj4gIAkgKiBURFggaGFzIGl0cyBvd24g
bGltaXQgb2YgbWF4aW11bSB2Q1BVcyBpdCBjYW4gc3VwcG9ydCBmb3IgYWxsDQoNCkxvb2tpbmcg
YXQgdGhlIGNvZGUsIHNlZW1zIGFsbCBjaGVja3MgYWZ0ZXIgdGR4X2dldF9zeXNpbmZvKCkgaGF2
ZSB0aGUNCnNhbWUgcGF0dGVybiB3aGVuIHRoZSBjaGVjayBmYWlsczoNCg0KCXIgPSAtRUlOVkFM
Ow0KCWdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KDQpIb3cgYWJvdXQgd2UganVzdCBpbml0aWFsaXpl
IHIgdG8gLUVJTlZBTCBvbmNlIGJlZm9yZSB0ZHhfZ2V0X3N5c2luZm8oKSBzbw0KdGhhdCBhbGwg
J3IgPSAtRUlOVkFMOycgY2FuIGJlIHJlbW92ZWQ/ICBJIHRoaW5rIGluIHRoaXMgd2F5IHRoZSBj
b2RlDQp3b3VsZCBiZSBzaW1wbGVyIChzZWUgYmVsb3cgZGlmZiBbKl0pPw0KDQpUaGUgIkZpeGVz
IiB0YWcgd291bGQgYmUgaGFyZCB0byBpZGVudGlmeSwgdGhvdWdoLCBiZWNhdXNlIHRoZSBkaWZm
DQp0b3VjaGVzIHRoZSBjb2RlIGludHJvZHVjZWQgbXVsdGlwbGUgY29tbWl0cy4gIEJ1dCBJIGFt
IG5vdCBzdXJlIHdoZXRoZXINCnRoaXMgaXMgYSB0cnVlIGlzc3VlIHNpbmNlIEFGQUlDVCB3ZSBj
YW4gdXNlIG11bHRpcGxlICJGaXhlcyIgdGFncy4NCg0KWypdIHRoZSBkaWZmOg0KDQpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCmlu
ZGV4IDdiODFjZDFmYmJhNS4uMTEzY2IwNzRiOTBjIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTM0NjAsMTIgKzM0
NjAsMTEgQEAgc3RhdGljIGludCBfX2luaXQgX190ZHhfYnJpbmd1cCh2b2lkKQ0KICAgICAgICBp
ZiAocikNCiAgICAgICAgICAgICAgICBnb3RvIHRkeF9icmluZ3VwX2VycjsNCiANCisgICAgICAg
ciA9IC1FSU5WQUw7DQogICAgICAgIC8qIEdldCBURFggZ2xvYmFsIGluZm9ybWF0aW9uIGZvciBs
YXRlciB1c2UgKi8NCiAgICAgICAgdGR4X3N5c2luZm8gPSB0ZHhfZ2V0X3N5c2luZm8oKTsNCi0g
ICAgICAgaWYgKFdBUk5fT05fT05DRSghdGR4X3N5c2luZm8pKSB7DQotICAgICAgICAgICAgICAg
ciA9IC1FSU5WQUw7DQorICAgICAgIGlmIChXQVJOX09OX09OQ0UoIXRkeF9zeXNpbmZvKSkNCiAg
ICAgICAgICAgICAgICBnb3RvIGdldF9zeXNpbmZvX2VycjsNCi0gICAgICAgfQ0KIA0KICAgICAg
ICAvKiBDaGVjayBURFggbW9kdWxlIGFuZCBLVk0gY2FwYWJpbGl0aWVzICovDQogICAgICAgIGlm
ICghdGR4X2dldF9zdXBwb3J0ZWRfYXR0cnMoJnRkeF9zeXNpbmZvLT50ZF9jb25mKSB8fA0KQEAg
LTM1MDgsMTQgKzM1MDcsMTEgQEAgc3RhdGljIGludCBfX2luaXQgX190ZHhfYnJpbmd1cCh2b2lk
KQ0KICAgICAgICBpZiAodGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCA8IG51bV9wcmVzZW50X2Nw
dXMoKSkgew0KICAgICAgICAgICAgICAgIHByX2VycigiRGlzYWJsZSBURFg6IE1BWF9WQ1BVX1BF
Ul9URCAoJXUpIHNtYWxsZXIgdGhhbg0KbnVtYmVyIG9mIGxvZ2ljYWwgQ1BVcyAoJXUpLlxuIiwN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90
ZCwNCm51bV9wcmVzZW50X2NwdXMoKSk7DQotICAgICAgICAgICAgICAgciA9IC1FSU5WQUw7DQog
ICAgICAgICAgICAgICAgZ290byBnZXRfc3lzaW5mb19lcnI7DQogICAgICAgIH0NCiANCi0gICAg
ICAgaWYgKG1pc2NfY2dfc2V0X2NhcGFjaXR5KE1JU0NfQ0dfUkVTX1REWCwNCnRkeF9nZXRfbnJf
Z3Vlc3Rfa2V5aWRzKCkpKSB7DQotICAgICAgICAgICAgICAgciA9IC1FSU5WQUw7DQorICAgICAg
IGlmIChtaXNjX2NnX3NldF9jYXBhY2l0eShNSVNDX0NHX1JFU19URFgsDQp0ZHhfZ2V0X25yX2d1
ZXN0X2tleWlkcygpKSkNCiAgICAgICAgICAgICAgICBnb3RvIGdldF9zeXNpbmZvX2VycjsNCi0g
ICAgICAgfQ0KIA0KICAgICAgICAvKg0KICAgICAgICAgKiBMZWF2ZSBoYXJkd2FyZSB2aXJ0dWFs
aXphdGlvbiBlbmFibGVkIGFmdGVyIFREWCBpcyBlbmFibGVkDQoNCg==

