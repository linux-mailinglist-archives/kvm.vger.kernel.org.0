Return-Path: <kvm+bounces-13784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7955789A80B
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 02:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3C57B23A2F
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5575DC8E1;
	Sat,  6 Apr 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SeVgtKeM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B74C7C;
	Sat,  6 Apr 2024 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712365123; cv=fail; b=uDxe0vliX+k8oUvdOj1mzGDIck6sia4rrGOjlGjtztg3Xg9xUI9MSMzZZX+pO+vSUQ4niAMMrOcA7yTHmSsq6MCnzbFRhp0d72NSjhgYyIPUje9A9gFvWfAGazxhIuHxfu1Ph/9kBnR0jLuoQElDrGzv/fJTSSf+A4kqNxx1oXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712365123; c=relaxed/simple;
	bh=Yj/iCdV3q7PJNZBhvbWlf/71hOyuS1Pv3hRgYd6DS94=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WEeNoIxLhq5tnR75y21RrbYxRcQ/qg7WGAXh3luTZsxDcex883bSkaEouNsGz6m3csEdCujGcZzS4YFY32D+DxS+iKos46YCbqvS6Lc5/kCIMjcTeMEWBc0kkmx8SMuI4HNDdG4/JVgtD/TlzjwFyfPgfTvL8CmGRVeVY5h+CVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SeVgtKeM; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712365122; x=1743901122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Yj/iCdV3q7PJNZBhvbWlf/71hOyuS1Pv3hRgYd6DS94=;
  b=SeVgtKeMbXuYH2JX63ihAyW3Q4UWOZV0XjjgiNfg/QpY8Fv2jD2jlxY5
   x3ByUuY/YJVxj4JO2Nvrlb7Ycj1uyflkhc9StApkzSDQp6ZXoFdDjNHdr
   AV9kEvWl20CjgkUJMy7lbOwOyo4qWMNIFLQYfYosJBATMFjg1LMN3Jhu3
   LBlIM8GWpDM1Y6umVO5bYfF6Cyj5mawJzi/fhoBCPsMrpwAo46A/CGn8t
   hd7+XdS2cw4r1kP1/hP2A8GFfVKK2Rr0MjeQPrpN9VNlwshO7PSo+1M5G
   cH2hiBUeDi+l7Av+OvogsI9vdpE0NpaGQzZSbG69CizguP7t1myG+wILe
   w==;
X-CSE-ConnectionGUID: uwqBnwrkTda59cULrKok0w==
X-CSE-MsgGUID: B2YujqWLRAGE9JHPfUxvGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="11506860"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="11506860"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 17:58:41 -0700
X-CSE-ConnectionGUID: GHZy8TwKRn+FxMS7meVrpQ==
X-CSE-MsgGUID: NgteIrOFTzKu0xRZe5+rcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="24023612"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Apr 2024 17:58:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Apr 2024 17:58:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Apr 2024 17:58:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Apr 2024 17:58:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Apr 2024 17:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUuLQcA9u6FRL8nksz/Z4w5SsvmbP4c/50nKYBEdbW//oMkTKva1LtMsz6JGqERh9LZp/OQTZd958HgPIp2D3/jBOerhHX09r5WfpdBt7AyGmnKqztxOOQqa1PTXgQjhWc8zy5+uQWZTVgXHzkWHmIkFnlVFtQjc5Cn1HuoQPygaQv6pFSMljt0dQcuXfcqXqieF3cR5pE+O+0kgv1/j3q6Jrz7GhTSjnGOgCaN1efurpZ+p5gEp7AXrJ88lZLoDe1qQdJRPtz3toFilQ6+xvWDjA0AjnqsU/xcrkcuZi2dAq1I6Z0Kfq0mXw+PUvSDML1h+CqEIgzSdb2uQ5FsJMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yj/iCdV3q7PJNZBhvbWlf/71hOyuS1Pv3hRgYd6DS94=;
 b=EDn3b/kQM0tuJ3LGnV4TYLwNEMeU9AhAzsqmdtqRgQ3WCWnntslZtIq/lkMciBs7v5MXa2k/zn3l/YznEk6e5vwca2szFX+ZCG6BpGXKhBFF6RXIbUkd6FwYz1uTfFFwGIGJ/dlm8vWqbHTeqzPCqOEb+TK6nk1NnFeU3wtE4WMfN9vHn+KS81IyxAXLoUDmUmahZ3TeQZuMitJ1yZw/pk8T3xgf/QuEERu88dfKsJ+qcpQSpUBf7qvgcZySDVq6mV8uotawshhDdJCQAeTNW90bV5Ro+1plGbLY0Ho2BuYZK/WTCBomiwzNHLQTRNE3VDRF9qenuOqkZmUaW9fJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5169.namprd11.prod.outlook.com (2603:10b6:303:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.24; Sat, 6 Apr
 2024 00:58:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Sat, 6 Apr 2024
 00:58:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Topic: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Index: AQHaaI3KAQ1iVMSqikKm0e5+Em3C07FTx1GAgANBugCAA5NJAIAADaUA
Date: Sat, 6 Apr 2024 00:58:35 +0000
Message-ID: <f61bb57eba91c68e7cf50c4e806de94c2341ad16.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
	 <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
	 <20240403173344.GF2444378@ls.amr.corp.intel.com>
	 <a2386cbfc8a4e091f86840df491fb4d999478f44.camel@intel.com>
In-Reply-To: <a2386cbfc8a4e091f86840df491fb4d999478f44.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5169:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVYvK/iSo873z0ikAR60YLvj67otZR7VTOJ8F1CUdG1RRq1OqS0tgHi5y3hWElK8WFjcu39GP4yBU4p6thq/vCGRAo7Bl47QmYzi5BslMRmuFc/ClXwMiBRtaGi+2gn6qFAsrO3dfTiwF097fNLOnMEDv77nfJOVwXGLap4H6lsGFSrL2frHFPU6GKDsKtZiJgS0oYHPqQN+ZDxk4oJOCAn4MjoCAa8HfUUuvJNAvTuUF34ikdjSuIL2cgvvVbX/m4BaPiQDrIy+gtociSREZMIw1N2CT5n3+jBf5aD0nSxqbjhuYZi9Go5uQiOI0W57t/bXCQFZgYVAeJCbA3Ygxz2mSdIHtQhvo38zsepQ7t7muQc+kRaBAjghadbLX5obSzScnNgsR2m/3VG0ox5hzJGX1PZCE3/pDR3eRu/22zW2kRHOmbyTzJbo83zgyvPN81bspI/xd2LLL8nOUQGvvlbQMf5vldVFUaUZkN5C7VVqAkBaZiWtBc5ObHfkPBhh6DQL1cE+nWt+AnCjoiR4UT24uPyL/CLRmqIUuxQtGFZZk7C/LM3z9IyAt2Cc8sqaQghRYZsG2D4/RQAR3J1TQg+chc458+Rfdc7TvdAVW9q4e8wj75w35XeA44fe0DAfkmf2WomVnvNRNpeddFBv1JmadeR6IvnkPEK7n49Q/V0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFJWVExPQXE1UUtwb0FpUDlTYUYxNmI1MHF1UlFyTUlPWllGblZPSE9HMUlY?=
 =?utf-8?B?MmNSVWhZSXBEbDlpU1JaaDUxcjhYWWtuV0FMdVp3dGtaK0o2ZzJua1NrWURw?=
 =?utf-8?B?TWNLM2hmWjNyMHBaZklMLzdLaUoyYUJzYVVGVDZ6Si90L2pxWittM09ncU5k?=
 =?utf-8?B?dlhpRVVPb1RGK2NlVTZqcnd1WXZiOWtwT1BuTERUMnRyK0RzR0ZJKzNFRDdW?=
 =?utf-8?B?TmR2dkZqTGFQMFBacE5vWENGVytJTmR3SnQ5VCs5T2IvKzdSRUtWK1R2Y0NK?=
 =?utf-8?B?VGxWMnNDVytiYUFJNTA4eGV1VlRySmcxV2FIeXZ1WTJNRnVLeG5DUWV0eFhr?=
 =?utf-8?B?NTVvRThTSy9WNGMrNWhTaCtzRnhxZnpSTVN6ZVJzRzFkQjZlOGluNWJ3Y2Mw?=
 =?utf-8?B?c0w5SE0rZ1o2alNObm9YUWM1RVovc1hkcEpZbTJhQTF2d2JmUDB4eVJrQ2Zm?=
 =?utf-8?B?M3g5UW9HaDhwK2JSM3JOeGR2bXk5YW5iVDJkbWJjN1A3UTZobzhxQ0RUWVY2?=
 =?utf-8?B?TTNNRzQzc05FeGZ6RjB5L0UvOG0wU2dUVWpnMnZvNWdsZko2SnFzUW5RRTBM?=
 =?utf-8?B?cWdzc3dVdldmY2t3UmpCaytKSnp1cmNHWGRqSkJVL1FLUENaUnA2UkNrYmNa?=
 =?utf-8?B?NmowUC9RZFoxUkIyT2MzckJHd0txUFB5NHpYeUpDM2FVUlh2eXpjZzdDVVll?=
 =?utf-8?B?Uk51V0h3bG9HWmw1dWRBR0Z1KzBMWVBiRXZ5UmN0eHFid3lPempUQmt2SjF0?=
 =?utf-8?B?cklpeUtWM1VUYXZFb0txZmVLWkFPenpDM1NIS2k0amhaUldEQnpYeTZwU3lX?=
 =?utf-8?B?a2pJL3RrVWovU0czOXd1OXEvclNINUdsVUlEeWdydE5BdTdyWHZPaWtKcHF5?=
 =?utf-8?B?MGhUYm05TkFLdWlKK2IyQXdNVFUvM2NrZmZoSmg3V1R5bThtRXBWN1lTaERH?=
 =?utf-8?B?aG5BQWhNWDQrZzlnNXZRV1FNa1FZQlJtT2RrdEozOHJIbDJqc3ZZSmVLcjJI?=
 =?utf-8?B?KzBLaDZlYnZSdnB3WlA0MEpTQmxuSm1wcHdzbVdiV0xBTElwaGNJMXh3eUls?=
 =?utf-8?B?ckxkbG1kbkFMYlNrbGFZZFRUN0VNb0Fta1NXOFVOL0ZoYjlWUm9ham1qM0ds?=
 =?utf-8?B?ZmdIODEzeUJlbEdWcEdPZ3pYZUdjcjl2SzJzb2JlV2RpdFZGYTJxQjR4ZWxr?=
 =?utf-8?B?TFFjOFl5cktiZXQxQkoyZkR4MU5ybGZMOWI5R2o4ZU1QY0NlR25sUGhnaEVp?=
 =?utf-8?B?Q0QzZDBrcm52RkJNTVNNWUdTYW1XU25NOUpDRno5Vk1reGh0ZnA5WU4xR1Q5?=
 =?utf-8?B?YlFuVko2SUlzSUordTE5bW5YbTdFNlUwRUR1SjA2RE5SVld2ZVRHS25VZm1o?=
 =?utf-8?B?eGZrMnpvZ1AzZ1RScklzc0FjUGo3Qkc4a0JVeFV3amk3V3U5Y0RJUGcyTHRq?=
 =?utf-8?B?QU9JZE82OEtobnFCMVhudVRVaW13NVRPc3MweTBkdmRwTkFWT2tveE5Na3lI?=
 =?utf-8?B?ZWZlcnZ1UC9sZmpkTExHY0hhVTkwcS83aXJzQ3VYWDJYZnNmVXJhTjlXS2NN?=
 =?utf-8?B?UmVYZnQ5Q3FjaTFXSUpmN1JSN2dlTmhaeG45S3dGSEduWi8zQldFNFQwRU9r?=
 =?utf-8?B?NnJQa3hTZHZCR1N3eUc5dUdWL1pyNnVxNDFiRVVZVWpQclF2cVBMZFV6R0d0?=
 =?utf-8?B?bG04Y01nRXlHZDNDQnJKUjEvMGQ3Njl2QVBDTTVKd3BhbUV4MmE1VXU5RVdy?=
 =?utf-8?B?amRWejZMUEl0VGczUVFyQUt5bHlMWXE5a1BhVFlZMlFmRnpoU0hHVGd6OHpm?=
 =?utf-8?B?MktsV202MHBRa2hDV1lvZlF5ZzJEci9La3REZ2czQkRhWVRzRE9Vc1p3Q0ZX?=
 =?utf-8?B?WnYvcjIwdHVBZGVmNU1Xa0JxTUJuTFRaR2NWKzNQZXZkL0d1NGx4eDlxcUZn?=
 =?utf-8?B?UEhZcFIvdmNzVjNsb1IzZk5FOUhUdEFld1NobWNkNm9zNkpxQjhXcWNlYk90?=
 =?utf-8?B?Y1E4ZmZRUzBtTm5xRllhL1hLMWFsTDQvNHM4ZGg3aFpHNzVmVklXNkt2L2pD?=
 =?utf-8?B?czFpSitwQ0dLbjhZQS81Y3JweFBaU3ZHN3JnMFF5enZOSXErV3gzWmRER2NE?=
 =?utf-8?B?RXltR0hGZ05GWjZBZ09mcEVPWEh5Mkt3STZTS09leVpvR0xZdlFHVGswTTBS?=
 =?utf-8?B?cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0B67189779E944D8C048D6BF280270D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6804e6c-9562-494f-0308-08dc55d4b045
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2024 00:58:35.8094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9rFuu/p4pj6YAPuVctrSXG6Fr9RGekzgyDKsW7xcLU+kuWrB52WilImQv/eQfkW9aC6fLMNrSBtO5VA/HhtZSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5169
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA0LTA2IGF0IDAwOjA5ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gV2VkLCAyMDI0LTA0LTAzIGF0IDEwOjMzIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3
cm90ZToNCj4gPiBPbiBNb24sIEFwciAwMSwgMjAyNCBhdCAxMTo0OTo0M1BNICswODAwLA0KPiA+
IEJpbmJpbiBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4g
PiANCj4gPiA+IA0KPiA+ID4gT24gMi8yNi8yMDI0IDQ6MjYgUE0sIGlzYWt1LnlhbWFoYXRhQGlu
dGVsLmNvbcKgd3JvdGU6DQo+ID4gPiA+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4u
ai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBGb3IgdmlydHVh
bCBJTywgdGhlIGd1ZXN0IFREIHNoYXJlcyBndWVzdCBwYWdlcyB3aXRoIFZNTSB3aXRob3V0DQo+
ID4gPiA+IGVuY3J5cHRpb24uDQo+ID4gPiANCj4gPiA+IFZpcnR1YWwgSU8gaXMgYSB1c2UgY2Fz
ZSBvZiBzaGFyZWQgbWVtb3J5LCBpdCdzIGJldHRlciB0byB1c2UgaXQNCj4gPiA+IGFzIGEgZXhh
bXBsZSBpbnN0ZWFkIG9mIHB1dHRpbmcgaXQgYXQgdGhlIGJlZ2lubmluZyBvZiB0aGUgc2VudGVu
Y2UuDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gPiDCoMKgIFNoYXJlZCBFUFQgaXMgdXNlZCB0byBt
YXAgZ3Vlc3QgcGFnZXMgaW4gdW5wcm90ZWN0ZWQgd2F5Lg0KPiA+ID4gPiANCj4gPiA+ID4gQWRk
IHRoZSBWTUNTIGZpZWxkIGVuY29kaW5nIGZvciB0aGUgc2hhcmVkIEVQVFAsIHdoaWNoIHdpbGwg
YmUgdXNlZCBieQ0KPiA+ID4gPiBURFggdG8gaGF2ZSBzZXBhcmF0ZSBFUFQgd2Fsa3MgZm9yIHBy
aXZhdGUgR1BBcyAoZXhpc3RpbmcgRVBUUCkgdmVyc3VzDQo+ID4gPiA+IHNoYXJlZCBHUEFzIChu
ZXcgc2hhcmVkIEVQVFApLg0KPiA+ID4gPiANCj4gPiA+ID4gU2V0IHNoYXJlZCBFUFQgcG9pbnRl
ciB2YWx1ZSBmb3IgdGhlIFREWCBndWVzdCB0byBpbml0aWFsaXplIFREWCBNTVUuDQo+ID4gPiBN
YXkgaGF2ZSBhIG1lbnRpb24gdGhhdCB0aGUgRVBUUCBmb3IgcHJpYXZldCBHUEFzIGlzIHNldCBi
eSBURFggbW9kdWxlLg0KPiA+IA0KPiA+IFN1cmUsIGxldCBtZSB1cGRhdGUgdGhlIGNvbW1pdCBt
ZXNzYWdlLg0KPiANCj4gSG93IGFib3V0IHRoaXM/DQoNCkxvb2tzIGdvb2QuICBTb21lIG5pdHMg
dGhvdWdoOg0KDQo+IA0KPiBLVk06IFREWDogQWRkIGxvYWRfbW11X3BnZCBtZXRob2QgZm9yIFRE
WA0KPiANCj4gVERYIGhhcyB1c2VzIHR3byBFUFQgcG9pbnRlcnMsIG9uZSBmb3IgdGhlIHByaXZh
dGUgaGFsZiBvZiB0aGUgR1BBDQoNCiJURFggdXNlcyINCg0KPiBzcGFjZSBhbmQgb25lIGZvciB0
aGUgc2hhcmVkIGhhbGYuIFRoZSBwcml2YXRlIGhhbGYgdXNlZCB0aGUgbm9ybWFsDQoNCiJ1c2Vk
IiAtPiAidXNlcyINCg0KPiBFUFRfUE9JTlRFUiB2bWNzIGZpZWxkIGFuZCBpcyBtYW5hZ2VkIGlu
IGEgc3BlY2lhbCB3YXkgYnkgdGhlIFREWCBtb2R1bGUuDQoNClBlcmhhcHMgYWRkOg0KDQpLVk0g
aXMgbm90IGFsbG93ZWQgdG8gb3BlcmF0ZSBvbiB0aGUgRVBUX1BPSU5URVIgZGlyZWN0bHkuDQoN
Cj4gVGhlIHNoYXJlZCBoYWxmIHVzZXMgYSBuZXcgU0hBUkVEX0VQVF9QT0lOVEVSIGZpZWxkIGFu
ZCB3aWxsIGJlIG1hbmFnZWQgYnkNCj4gdGhlIGNvbnZlbnRpb25hbCBNTVUgbWFuYWdlbWVudCBv
cGVyYXRpb25zIHRoYXQgb3BlcmF0ZSBkaXJlY3RseSBvbiB0aGUNCj4gRVBUIHRhYmxlcy7CoA0K
PiANCg0KSSB3b3VsZCBsaWtlIHRvIGV4cGxpY2l0bHkgY2FsbCBvdXQgS1ZNIGNhbiB1cGRhdGUg
U0hBUkVEX0VQVF9QT0lOVEVSIGRpcmVjdGx5Og0KDQpUaGUgc2hhcmVkIGhhbGYgdXNlcyBhIG5l
dyBTSEFSRURfRVBUX1BPSU5URVIgZmllbGQuICBLVk0gaXMgYWxsb3dlZCB0byBzZXQgaXQNCmRp
cmVjdGx5IGJ5IHRoZSBpbnRlcmZhY2UgcHJvdmlkZWQgYnkgdGhlIFREWCBtb2R1bGUsIGFuZCBL
Vk0gaXMgZXhwZWN0ZWQgdG8NCm1hbmFnZSB0aGUgc2hhcmVkIGhhbGYganVzdCBsaWtlIGl0IG1h
bmFnZXMgdGhlIGV4aXN0aW5nIEVQVCBwYWdlIHRhYmxlIHRvZGF5Lg0KDQoNCj4gVGhpcyBtZWFu
cyBmb3IgVERYIHRoZSAubG9hZF9tbXVfcGdkKCkgb3BlcmF0aW9uIHdpbGwgbmVlZCB0bw0KPiBr
bm93IHRvIHVzZSB0aGUgU0hBUkVEX0VQVF9QT0lOVEVSIGZpZWxkIGluc3RlYWQgb2YgdGhlIG5v
cm1hbCBvbmUuIEFkZCBhDQo+IG5ldyB3cmFwcGVyIGluIHg4NiBvcHMgZm9yIGxvYWRfbW11X3Bn
ZCgpIHRoYXQgZWl0aGVyIGRpcmVjdHMgdGhlIHdyaXRlIHRvDQo+IHRoZSBleGlzdGluZyB2bXgg
aW1wbGVtZW50YXRpb24gb3IgYSBURFggb25lLg0KPiANCj4gRm9yIHRoZSBURFggb3BlcmF0aW9u
LCBFUFQgd2lsbCBhbHdheXMgYmUgdXNlZCwgc28gaXQgY2FuIHNpbXB5IHdyaXRlIHRvDQo+IHRo
ZSBTSEFSRURfRVBUX1BPSU5URVIgZmllbGQuDQoNCg0K

