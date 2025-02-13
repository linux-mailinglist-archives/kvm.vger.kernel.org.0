Return-Path: <kvm+bounces-38101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAE8A35095
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 22:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F70916DB31
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB19269803;
	Thu, 13 Feb 2025 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrEGBq3N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FE91487FA;
	Thu, 13 Feb 2025 21:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739482954; cv=fail; b=cDePG3Rw5NdWaFe1dNOditmfq6DcfU6RIqtA/TbEd5z5ZSW0n8JVh/Bps2uFSxkfSrw2vVHh8HpKPVceEI5KN6a+FKGLxZAzbNEfdHq3iqFDi0gW9dgrzXXbZ/9wbo1DWG8WW0Vn99XdMEZcccA52bpCKGmUu+oH9/sNX65c4+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739482954; c=relaxed/simple;
	bh=MSrBYv76jiDoJTAmBbU+Ktm0Ty/iT8rsbICGIAtFiAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RNsM7RumIQFcZmmsY/oEAOUm2WOkvJwRiY1qD4UhjQTqPzJ03Cm4flo6x7Pgnj0eHgE8QcMy/nV3L3I/2W/K8d2zs88tu6viD0EbZBFMUxOew2YxZBgtPwJEsyyCZ80AC/d7mryet/uz84dB8R5u0Z1HMs8FisxkkutmAyTxLmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrEGBq3N; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739482952; x=1771018952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MSrBYv76jiDoJTAmBbU+Ktm0Ty/iT8rsbICGIAtFiAc=;
  b=TrEGBq3NRu7IDrdgA1QZyHalRIq1LOLtARTZYiuSx9aHebIRIuQLQvcP
   ESEVU5JyzZejMk5oDhRbrsbrPlh687HHWGqFS+HUNQl6Wg6GtpFJXvxsz
   cONqrjQETRgMJf76a7pMONvikUVCxZ13JzgIr5tTb6CtLuoPhHG7KeipG
   Yn9fNbxTACo6SLGuxVOgjjBCnB0RWWNcOUcH7DQgHZsv8MfimVktVzVOu
   JRlMbLUgrRlcVe/XyOOYnUIAJiWondKQb16mIajBt7rv+rypsB6nCIjm+
   mTBcnFfiyok7Wln/mCLgsISIXg2bsaGZHqw2ZOMoYjL46SsyjOEKUU380
   Q==;
X-CSE-ConnectionGUID: dfcpNfYLQTSe6Thgl/8MqA==
X-CSE-MsgGUID: 2ntG3xd2Sy2oVS5l0LuKEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="44145177"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="44145177"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 13:42:31 -0800
X-CSE-ConnectionGUID: xiSfnT2BQwKmgRxJj7E30A==
X-CSE-MsgGUID: OsHgljfPSSKujYmqRia75g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118474240"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2025 13:42:31 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 13 Feb 2025 13:42:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 13 Feb 2025 13:42:30 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Feb 2025 13:42:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzyJNnSvK1NaEDdf8Q7Am93mp2JIZB0aXf9PO9ZLFqQ+tv3eRjasP4HZdHkD+Wkjo84DNyPRZAD8qw2fQc2OClHGIwYh/1Ynk7BJhk17g7COLqx2bIg3l+sJOa2Slbx+T1val0tXC5N7vmDvqLQ4gCaz7eIyje3CFk/vz1Luimox4lxCswGv22pS70uNAeCAwmAjUYduDL79/0cLQlVtenEVuyolTI1PvzuRrnKj4y1EDitk4bkKhXzDjDymiL/sBkgatCy2N17pdK8ODCcJYGGa6ajAeSSchlPKB+K+JE56GhqAeNjmbWQ6I1SxJ0OzXJRlLIPyeubQFw22fM0GpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSrBYv76jiDoJTAmBbU+Ktm0Ty/iT8rsbICGIAtFiAc=;
 b=WpedGsBUfqy4iNAR33IIvfLVPpbFNOI0qGbtTDYMCNNNLMmxMXmY2imUIOx3U1Vj1bf4ewsRKBowwc9bnaXJzVJCoMW07Xi2NJPEmDazYRBjO6AFmwOT2s/VWfkE76EWgvKG45zO7Je+WvgU3e1NyYKqKTDqxV/Bn8AY6p4bwLSLS2ipR0nGGhicmojWrmpq1MRXJfO6NpbMJBSkHtVeZtNWE2CDZrZHObPMnFrm3Sl8yzpnQvyKE96BZlJMgkhZM96EM+wm6M2UYogQaIBQ65cfbjVKeHj3iREdkXp7RJgAyw62ZtdveSrLV5fZjMt3J+THR1dvGJp3+pnUZ4AAAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6422.namprd11.prod.outlook.com (2603:10b6:8:c6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 13 Feb
 2025 21:42:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 21:42:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Topic: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Index: AQHbfDApdlf/cGS1Jk+r9GVy/r2ODbNC81aAgAADFwCAAtFqgA==
Date: Thu, 13 Feb 2025 21:41:59 +0000
Message-ID: <da350e731810aa6726ff7f5dfc489e1969a85afb.camel@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
	 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
	 <Z6wHZdQ3YtVhmrZs@intel.com>
	 <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
In-Reply-To: <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6422:EE_
x-ms-office365-filtering-correlation-id: 95828fb1-43e5-48d9-bdbe-08dd4c773f21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MHNYY0YwRlZMRUREZWVvOFVzemtJc1djZzBzdCs5djFpRVN3QW9RYW9SNisx?=
 =?utf-8?B?RTUzbUxPOGkyL2t2VzkxSTNrdzl1M0ZzQzRFTDlNb2I3dDZ5SXNnUWJHZDRN?=
 =?utf-8?B?RlY3VjBXOEVhSmt4U0tGVGhLZDRBSEt5dXRmVjNiTmJJZCtGMUlYeTlPOEFW?=
 =?utf-8?B?dW1FaGVYWkZ5K05wZUIySE1vSWEweGxvYnBZZkpJaGdTbm94K25aWGdYK0xQ?=
 =?utf-8?B?MUtKWFdlY2QyRFd0bFA0N1NMNG5kRkd3QXZGc2xTRG5sZUo3TW5kSDZWeS8y?=
 =?utf-8?B?ZGtnczJLbnh4SGNPTE16cE10MGY3VzRWS2tYV0lFaTBLUjRUNHVKUVlzdkt4?=
 =?utf-8?B?bURJQmVyMlRKMW5BYkhXdGdoN3RzcUVaWnlVS3kvTG15MGJEaXlQNWlEYTd4?=
 =?utf-8?B?Zk55S2RnbmhYN2FyRys3ejQxVXpoaTl3UEhLQXVUUzBMbk9EUXY5eEp4OUlF?=
 =?utf-8?B?enZpT3FaNlkwRHR1ejJSZkFCVWFqdkM4UGtWbnpEQXhJWUFzYWh5MVhqcVR1?=
 =?utf-8?B?aytvengrTE9TRVQ2ZE1zUVF1M283MHJwUjkrMHNtTGc4VE5icmpJMXNPSEtl?=
 =?utf-8?B?WXAzOFRUZGpwZnFtZnJoL3VrcFNKM3cvOTVYNVJxaUtmeE45eUxaNFJhNTlW?=
 =?utf-8?B?dU5tUW81T2dHbWtBUzI3QUJoK0YydEVUYjFVQWErSGFOdmVWMyt0TUxQM1hK?=
 =?utf-8?B?cG9VZytqUUZtNzZkYXhDNkM2SDdTSUVhSHZWYnU1TnZBOTNVN3BDUVBlc2Fn?=
 =?utf-8?B?bHlrMjlYR1RKc2FIcUNjaVprYlhjSEh2WHFJZjZ0R0xZTmpMbnMyRExIUTJI?=
 =?utf-8?B?WnY3MVZ2WG9aeDdUT1luRHdvTXJYU1BLYXJONW4xZW8yTk9YM3doTjNHWmpr?=
 =?utf-8?B?TXp6eCtBV3BEU2JvVTlQbVc4d2FhbWFGVFBRaW1WQkV1bVRDUUltTCswRWJq?=
 =?utf-8?B?aDJ3L3Rpa2ZKV0dyQVlaVkRnWFdOMnZuOXVobEFCTWNqNlBBSHdNMUtUbnRV?=
 =?utf-8?B?dWJWT3JVYVNIWXFNd0FNZXNKOWd5M0s1Nkl4QlUzRGo0THRxQ0Z1eGwwQlJ5?=
 =?utf-8?B?WGdRNDVCL3pzdlVGcS9NVCtjc3J0Si85ZXY0YU4wMjlNbnh3T3JVZXJVTkpw?=
 =?utf-8?B?YmNST3kvTFBOZWJIRmdzUmRrTmYvd3dWUEoxSng3M2QwSTFTMkdHUzdXb0Zl?=
 =?utf-8?B?b2hzeUQ5WFRPU1A2STArWVAvN1hxNk14QndGOCtpMjVWWkNNRDJpK3RQSlJX?=
 =?utf-8?B?dU5NT3JVQUxVMTZzREFNYXNLVmlnck1WZ1ZNZ0NJd1RaTGk4MjNSVzNOS1l4?=
 =?utf-8?B?c3kweDIwN2NocDVQSWhxUUNGQTFhSDh0VlRXRDJIUWRGOUxmWVJwV1Q1ZnB4?=
 =?utf-8?B?Ykl2NG1RVHl1MjBYQTN2ZCt0VHBwQzNZWGxIMndNVDF4dnBvbnVmQTVUNlN5?=
 =?utf-8?B?N2hORTlKb2dPZFZwN3pzWEVuVEoyLzNHeW9XZEdTeUlKOFFUUlpoM2d4Ums0?=
 =?utf-8?B?Uk1jMjU5VWovbGxvSU4rNExRZFFpdUNHc1Y5U3BqSis5cVlvcGdOOFZWN2RI?=
 =?utf-8?B?WGNRMnpQUEV4ZHBuMG1Ia3N3QXZJYjNDb1ZoakF4eTZXMDljV3NFUWMxTEFt?=
 =?utf-8?B?dXhkck1wNmN2SGxtNEdqTEoydjdBWk5qR3g4WU1HUEpYd3p5ekxUQnhlaS9k?=
 =?utf-8?B?ai9EbzB2Ri9yL3hvZ1JTc2ZYSkZpZ2JCenFqNy9jWXZDOWJObEdBMXcra2w5?=
 =?utf-8?B?d1ZXbjVVcFpiZDljbWwyRmZxT3Z6WXBjTDJGM0lXRTY3Mkx3OG5jREx5SC83?=
 =?utf-8?B?UmlNc0RhcGYvZ1dVRGRTclZZRDhlejg0Q0VjR0ZzSTF1bGlUdHlld0hBVWFM?=
 =?utf-8?B?bGQydU5rNDBwTGJ0Z21GMnJ3ai9HSTVsK1Y1VHQrWHhrTlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1lJUG5KbjBDTXRqaGJGekQ4RkdKOUhyU2lJcmdVZGcvZjhZQzFZZUZMUGlW?=
 =?utf-8?B?eE54eEtvVE9GaWxxNUdGR0dIdk1qZ0VyeldQbXdmNEliMGJWSnhTYXZhU1hP?=
 =?utf-8?B?ODdlSVVDbGU3TjVnUzZhdW1BdS8rRW92NzBDWnoxRkJ2WEM2QlF5dFpmUWFW?=
 =?utf-8?B?b3R4N3oySWR1bFBrTVRQdE5ta3JTMjQyb09oanpUZjFoYmJtOXV4ZjBaTFRo?=
 =?utf-8?B?MFQ0eWR5d2NGOFhlUnVuTm9OY0t6L3M4ZkdGZ2haV2VJN0VNWmpibkRmZHlV?=
 =?utf-8?B?d1cxM2trYUxjYkk0c1VUMU5HMjYvRDhzdVNPZXpaVFBJa1lNZmdWTDMrb1ZZ?=
 =?utf-8?B?ZWhFeDczSm1JYjZRRm9QVlNlWHJJOHMwOFhzSW5HMjB6cFVvbzF3MWJTNjBY?=
 =?utf-8?B?c1lubko4S1JValZPRXExcDR3QlhPQmtpNEh2N3NYTlF6a25vcm1xckJnVVNL?=
 =?utf-8?B?Ly9mUnRweUtpN1N5ZXpyQnZqSkdMdUhwd1cxdlBvcjAvMUtkSVEvMlFoTTMy?=
 =?utf-8?B?aHBURGhwVlR5MitXMHZLTTY5R3NsTXQrYTFldXdFS0FWckVuTG9hbjVtbVYr?=
 =?utf-8?B?UGQrLy9FeGxzVS9zTDcyeFRxbXZPa3RmOGI4bis1eHZsQUR3YWhHMlQrczZG?=
 =?utf-8?B?VGtTcFZZQzEyb0V3YjBjQ1p3ajc3VHFZSy9ta3NhVEtjYkk0c1VTT2JnaS9j?=
 =?utf-8?B?SDNYeU9ySkwzT1pWR2o4bHFZeklEZFM2S1JaWmdVMDdCT296VlVrMy9iU0Qx?=
 =?utf-8?B?MUhRdE5ST2c0cFpxZVpRRUN6dUtIWkRseWdiNjVZT1FCYkJMVThEOHF6bExI?=
 =?utf-8?B?M2tJc1FzTFNTeUZwOGt0SmpyOGNUTHRCcjNSUmVobkxTRWR0ZVJvbDVtMkNJ?=
 =?utf-8?B?ZDdieEVtbTZDVkdSVmY2d1pndWsvNDVEOEV4Q2UwbFNJQVMxS05Ga2VCdmM0?=
 =?utf-8?B?RHJrdzlQRStEQTN4RkpxMnpTb041VUdLdlNwakM0amRpd3BRU3l3R3B5QjdK?=
 =?utf-8?B?aDFlb1Y3ZFVrUTdOSUVaN0U5dnFTT2FKQlFMTXpVUU16czN6azc4eXpBcVNl?=
 =?utf-8?B?VWh3MW1qWElLc1BVakloVnpRSml3b0RscDdOWXltSFVvTVFSUHRSQ21ITXpx?=
 =?utf-8?B?R01OaHR1djNvNEltMXVXUk9ORkJHSDRKMEhBWWJkRHFhOWtuMDNSWnNqU0ov?=
 =?utf-8?B?WGd0NCtXMFdKUDVHQzhrUDNQRkZJTGpWTmxBN1pUTWpFNU9SeTRMMEE4dHZ1?=
 =?utf-8?B?OFBORkFRWWMvQ2tjMmxRRk5MRXhOLzZocVRwcDhlL2tjY3NoSDRMUS81bDhV?=
 =?utf-8?B?MGw1Q25uRmFiNUpjVlh6V053RGk0R1pQR3BLN1JpL1lXOVp4ZFZhZEF0aXo3?=
 =?utf-8?B?eExLSm93QlRQSmJ1VlhlbUlpaHlXTXpYLy9uV2tjRnBCcVMrUzI2U1hYcXkr?=
 =?utf-8?B?YkZNUW0yWnpBSGk0QmhHMzUyUlNDN25HZERYbk1UL2JjYStBQTkwWElzSzNv?=
 =?utf-8?B?NjlwcWt2WDRVOGhSRG84SVd0RllGdWdOOE5SY1V3cVVCOURQNWFvdFVURjQ4?=
 =?utf-8?B?VWp5THNVdE1KRnFGc0FzKzZJdkNnRGRUL1NQaEpFVVJrVW1JWU1hTkdEZFly?=
 =?utf-8?B?T0VtNDUwMThNM1AwU011bGVvUXRaQkRNZ1F2T25WVmMrb0JUOTBqUk5YTm9a?=
 =?utf-8?B?Rm90Zjh6VHNXVGt6NmROakNiU0tjUFZtYkp3dTVjeE90QXFPQWRsV0xycmk5?=
 =?utf-8?B?Y1Nlb1dMczM3Z3k5VFg5ZUFyeDhadHFNZ0FITHg1QnpjOER3RWNqbHVlakJ1?=
 =?utf-8?B?NnYvSTZNaGczZTNSVk54YlF0cGxWeG9pN2pBR0F6SkVqYXlENmlTQnE1anR5?=
 =?utf-8?B?MkEvbDQ2V3BUV0JpODlhY1l2bi85a1ErQVV6alhLeEdzR3U0K3F0dGNCbmJo?=
 =?utf-8?B?YVBwWTl3QlpwdVNvNkhaUnhrU29TSDV3ZkVTUmtJUFVzRzQ5ZDlvaFo2czJM?=
 =?utf-8?B?WDNMaHdDOXhXZmFBTExUaVFRenREcTRGT0NXN2hOZEZ1aVVMY3V6V0hQSHh2?=
 =?utf-8?B?b015Y2d3aG44b05pYmsyZFdLVm1UZnpMUHlobkdNZnBYa3B3aWl2K1lrcEhT?=
 =?utf-8?B?aHFuZ0ExWlZselR1aG9QdEhQajV5TjNleFhIbExJeUF3V2YwNFdKQ1prR2U2?=
 =?utf-8?B?MVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3355C0D46C9005409EFFBB2DD1DB0E59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95828fb1-43e5-48d9-bdbe-08dd4c773f21
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 21:42:00.0169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aDEdnE+eHnFRxQKjmYO4IRbPEsd6T0C3n7OYH8B4YuIwKPCiOgHPzss/Y4VVE2+nwp72aUHR6nQj3AIUNB4nX70kjRa2NvVOIosurGECAAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6422
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAyLTEyIGF0IDEwOjM5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
SUlSQywgYSBURC1leGl0IG1heSBvY2N1ciBkdWUgdG8gYW4gRVBUIE1JU0NPTkZJRy4gRG8geW91
IG5lZWQgdG8NCj4gPiBkaXN0aW5ndWlzaA0KPiA+IGJldHdlZW4gYSBnZW51aW5lIEVQVCBNSVND
T05GSUcgYW5kIGEgbW9ycGhlZCBvbmUsIGFuZCBoYW5kbGUgdGhlbQ0KPiA+IGRpZmZlcmVudGx5
Pw0KPiBJdCB3aWxsIGJlIGhhbmRsZWQgc2VwYXJhdGVseSwgd2hpY2ggd2lsbCBiZSBpbiB0aGUg
bGFzdCBzZWN0aW9uIG9mIHRoZSBLVk0NCj4gYmFzaWMgc3VwcG9ydC7CoCBCdXQgdGhlIHYyIG9m
ICJ0aGUgcmVzdCIgc2VjdGlvbiBpcyBvbiBob2xkIGJlY2F1c2UgdGhlcmUgaXMNCj4gYSBkaXNj
dXNzaW9uIHJlbGF0ZWQgdG8gTVRSUiBNU1IgaGFuZGxpbmc6DQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC8yMDI1MDIwMTAwNTA0OC42NTc0NzAtMS1zZWFuamNAZ29vZ2xlLmNvbS8NCj4g
V2FudCB0byBzZW5kIHRoZSB2MiBvZiAidGhlIHJlc3QiIHNlY3Rpb24gYWZ0ZXIgdGhlIE1UUlIg
ZGlzY3Vzc2lvbiBpcw0KPiBmaW5hbGl6ZWQuDQoNCkkgdGhpbmsgd2UgY2FuIGp1c3QgcHV0IGJh
Y2sgdGhlIG9yaWdpbmFsIE1UUlIgY29kZSAocG9zdCBLVk0gTVRSUiByZW1vdmFsDQp2ZXJzaW9u
KSBmb3IgdGhlIG5leHQgcG9zdGluZyBvZiB0aGUgcmVzdC4gVGhlIHJlYXNvbiBiZWluZyBTZWFu
IHdhcyBwb2ludGluZw0KdGhhdCBpdCBpcyBtb3JlIGFyY2hpdGVjdHVyYWxseSBjb3JyZWN0IGdp
dmVuIHRoYXQgdGhlIENQVUlEIGJpdCBpcyBleHBvc2VkLiBTbw0Kd2Ugd2lsbCBuZWVkIHRoYXQg
cmVnYXJkbGVzcyBvZiB0aGUgZ3Vlc3Qgc29sdXRpb24uDQoNCkJ1dCBpdCB3b3VsZCBwcm9iYWJs
eSB3b3VsZCBiZSBnb29kIHRvIHVwZGF0ZSB0aGlzIGJlZm9yZSByZS1wb3N0aW5nOg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjQxMjEwMDA0OTQ2LjM3MTg0OTYtMTktYmluYmluLnd1
QGxpbnV4LmludGVsLmNvbS8jdA0KDQpHaXZlbiB0aGUgbGFzdCBvbmUgZ290IGhhcmRseSBhbnkg
Y29tbWVudHMgYW5kIHRoZSBtb3N0bHkgcmVjZW50IHBhdGNoZXMgYXJlDQphbHJlYWR5IGluIGt2
bS1jb2NvLXF1ZXVlLCBJIHNheSB3ZSB0cnkgdG8gcmV2aWV3IHRoYXQgdmVyc2lvbiBhIGJpdCBt
b3JlLiBUaGlzDQppcyBkaWZmZXJlbnQgdGhlbiBwcmV2aW91c2x5IGRpc2N1c3NlZC4gQW55IG9i
amVjdGlvbnM/DQo=

