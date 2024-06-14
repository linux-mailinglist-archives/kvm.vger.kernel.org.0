Return-Path: <kvm+bounces-19650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22326908208
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 04:51:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20F2F1C21FBB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF26185092;
	Fri, 14 Jun 2024 02:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UuFMCzdt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B59C18413D
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 02:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718333361; cv=fail; b=UQ4b3SQqrc4hBmLKN0oj27C249m6fxz2CVdy6kEqOVEP8ZCdREbN21cGfnmn/sgw3lkIZBrQyr0Pv7QLGZ6fKFzOl/rXxaT0K9AT9Lwd2yQvXqkp2lGcuvgNNuszRGFAqcXcRgPaKBRgGZONVHSewqvXkD4VIgK3c6qcabHEPhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718333361; c=relaxed/simple;
	bh=bNdlx7w7HepwYd8K+doLI39fB5knQahoZQg5U4VWfBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ms5eumK+sJhbIDLp1EniKkVsWpew7KCEaeqXH6QX2JyUu6RFGPHMNpbH9MdAHvURq3ijp6GYTHuM4gViL5ZjZYrym7CZldLxRjX3sT0MzAAbYc7glAkWdMX4W1fRtMhoiA5hgXgZR5uXP9SDm8DAH8M5JwJsgr7fubB/i3qaC9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UuFMCzdt; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718333359; x=1749869359;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bNdlx7w7HepwYd8K+doLI39fB5knQahoZQg5U4VWfBE=;
  b=UuFMCzdtAR/a8WWsrAhm/UM98CSDGb5bJ8Cez6m7RbgDf3ZbysVzmsr0
   v3sXQuTIZxTIyIu61ZZ2dy1eLPflbKRh9NM6eTXw30OoRvg1uKbTa48wT
   osxokhzQ9C40rH7VMu2hGX77m02vNQ6j0EdH0sNfG/vEt0P2kvmKeP3L8
   HhGCpWYru7VfkbNnfJcDuxKRRhrOOD3+i7gAi0dN7GUPdVnC1D3xBmBbd
   lT3X1WgdMWfnneGE88boGXsPK/8PXa3chtAtl5ZDDc2rLhHUlGRLjU009
   ylnVjLcN7Rhm0XZNTfL/m5ElwWYX64hWDxYNyoopofaHZ2GBwOg3MeAnC
   A==;
X-CSE-ConnectionGUID: w1kFlIynSbGwj/+hUq6UAw==
X-CSE-MsgGUID: uvC/4h9qSYyVlczIc6l24A==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="26624111"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="26624111"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 19:49:18 -0700
X-CSE-ConnectionGUID: q46HmdPnQVeCzK2VyXetTA==
X-CSE-MsgGUID: ah71wIiNTyqOgSxtjeo3kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="40321344"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 19:49:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 19:49:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 19:49:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 19:49:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 19:49:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGKAub66hyTse1pf2IenakL/hNiCMz0+uxBsahPHdXxCW9c3i5N6trdqqMz6hLmOB48POMWCQHbeNeCNMVPC+Linz9+lW8oPnJrcRHOcYaDMNTEZTT/vAnwOB9EpLmhv/Yt3T5AkbYJSeWjkQvFvFNLFn/JprinGRxpS6szPheQ2XxXLsdMkGwBN249MzAQKDNIOTyobMGyHLAo77KV5/OmsJcnTXAbx6RtQEW3c9grXyJ7GyJ2R2NMM3nYK1aH1gC9MRwLoxSB8y5eTw78NVDvN8f5gK0va038Tq3FCMLCThuHodIltTgD326BrnJTTb7gOWSs7WumvCaXqkKDFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNdlx7w7HepwYd8K+doLI39fB5knQahoZQg5U4VWfBE=;
 b=SFgjrM0T7Vpl+3TV7b+GKca1Z09HUb5sk4g5HLzKK/oRQOX11O2O7GZDV/QP0sDTUa8caIx/mZLspl75UFGZ/wQMJKb0ou54M/r8emhHlk/oL1ydSpp+k4vZ5K4jEOA15dNBlBlM/Hz/jRhAXIxP17uZby8GZ8SoWT1YFZrZkzFZjeuJL5u/s+lVswoQbiXCYmSDYt2nS+r+Hq4Z4cilgYJRUdj43ZPWDSpfyQZbXRyIfJ/88nBArCmdhtdGepxjoM0Am+5FGfnzh0tlHpd6Bs3yyPIRe11MwgKA1NjgrhaTCWjTdY0kY+emtiCLQq13UgmvzWEBUlRWqhkVs8o+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by IA1PR11MB6489.namprd11.prod.outlook.com (2603:10b6:208:3a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Fri, 14 Jun
 2024 02:49:13 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%7]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 02:49:13 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	=?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Eric Blake
	<eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Michael Roth
	<michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann
	<kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, "Qiang,
 Chenyi" <chenyi.qiang@intel.com>
Subject: RE: [PATCH v5 25/65] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Thread-Topic: [PATCH v5 25/65] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Thread-Index: AQHat/7UVxCPTcRwHkSCyrUM2HWwCLHD1SCAgAGR4mCAARaigIAAG47A
Date: Fri, 14 Jun 2024 02:49:13 +0000
Message-ID: <SJ0PR11MB6744C5C945045E0D2A5E5BEF92C22@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-26-xiaoyao.li@intel.com> <ZmGTXP36B76IRalJ@redhat.com>
 <90739246-f008-4cf2-bcf5-8a243e2b13d4@intel.com>
 <SJ0PR11MB674430CD121A9F91D818A67092C12@SJ0PR11MB6744.namprd11.prod.outlook.com>
 <a5d434b5-c1c2-451c-9181-3c9eacbc2999@intel.com>
In-Reply-To: <a5d434b5-c1c2-451c-9181-3c9eacbc2999@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|IA1PR11MB6489:EE_
x-ms-office365-filtering-correlation-id: 94eca6c1-738d-4044-2a75-08dc8c1c92f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|1800799019|366011|7416009|376009|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?L2s4QWNEbWhJVDBjaTIwSElwOEhwZkM4ZGZhNEpackVsVDdnTU82M2JlU09W?=
 =?utf-8?B?TGozanpTNDAxQ1gxNmNoNG9SbHNPTlFMTjd2bDhyQ0RZMjFZbVBhNDQyQ2ZR?=
 =?utf-8?B?WTI5cGlWZTBPMHBkM05Pdm52VDRFeS80UEJaRkptNUJ4UGZMV0dvaFhDR2RQ?=
 =?utf-8?B?VS9RYzE2YmxSRzBWTTNWZmxDMklxN0V1VVI0UTRzdTIvWTZjWW5YRWhMbTd2?=
 =?utf-8?B?Znp3dlk5YjZ1VXhXRWI4cDNFSmFkYVZscWh3bE93WmpldG5IY0hqYlk2djF4?=
 =?utf-8?B?WHRqOEpkRXAza04yYnZKb1BxRXRzdWhXRzNLM3Vwc1AxQnlqWnhkQVY0RWRz?=
 =?utf-8?B?K1JxL25BbmQ4OWVTN0UyNEpIQmhLWHAyOVE4eEgva09abHN3M2dITGdLYUgw?=
 =?utf-8?B?aDd6d3ZPeWhGUzFSQUJvYTZuWElQOXJnTEE2bGQ3UEpYL3JnOVpPWDBEdnh2?=
 =?utf-8?B?bVY0TGJvN0NTZnpmQ1UwaEFrU0JZMTNqTXRqSHRYeFY3QjZYTURtSVcwSW1W?=
 =?utf-8?B?dXBTYjI0Vk1HOW1lZ2lBUmcrZ1dyNzB3b3JmV3MyeVVTM0RtU095K2cwNVll?=
 =?utf-8?B?NXNkOVA4T3RHRkUzek5iRTV2aWM0MUZPQzkyTXF5VGFaYmdTMktqaE1wOFc5?=
 =?utf-8?B?RkZpUkE3bnJrNW0wdUQya3YrL3EwY1RFWkNOLzV2cnlzeHNjY2FmcGpOM1FJ?=
 =?utf-8?B?WElFWFBVOW9GNjEzN1FDSDhZMjJSYXpaMmQvYjBjaEVPSGE2NnM5ckRiVUF1?=
 =?utf-8?B?N3U3cC9vZm1idWluaDNKNExDL3gyQzYxLyt5MmE4VzdESE9RSmJrNERyUncv?=
 =?utf-8?B?cUtWUk5LT2p5a2NnMDA5bk4xWGgxczRoWE8zQndZL3BobzNqWjI1ZWkvVjU3?=
 =?utf-8?B?bytBZnYyRkxZYjE0R3VwS2ljV0tlSEUzZW10b2Z3U3JmZWV0T3hiTHF0UjNF?=
 =?utf-8?B?S1FCR2pKSXhBMjA0NEJrOHBMcHBrOHZqMEg1M3RGR2lBYmNPd2s1TGE4Mzd6?=
 =?utf-8?B?S1pHRU9xeXl0N2JzWDdMRG9JKzFnM0J3b2hLS1lycG1mdWgrOHRFdlJjR2E5?=
 =?utf-8?B?MURpNDNaREZWazdOQ1pieHcyalNEeVNlbFRaNEVlNmx2TnpwSFpUMmNoWFFx?=
 =?utf-8?B?a3dCc3BUeXFEcnFmZVc2clJzemtZQ25DK1M2SU95ZUtmMUMvQjdSQlhxTGRV?=
 =?utf-8?B?ZHFJZHRXdmtJMGlCL0tENy9KMnFmVlFvVmxqQkJoZ0tQd2d4ekRBSGQ0VzEx?=
 =?utf-8?B?TkIyNENnT0xEZWJTNzhITDlyYW1SR2xmYkRVZVhmaU9LVzYxSVMxQWF0M1Jr?=
 =?utf-8?B?TC9iTFhET3orRDlMMk4zc2Q2MDdWa0FwNEREZllmVVNnN0VHaEtkMlE4OHln?=
 =?utf-8?B?a1ZxUlNTRlBMelhYcHNzdG5xWEhXT2FrSk52d1dVMCtxOTQ0dHdkUjQxNk9I?=
 =?utf-8?B?UFBoN0xxaWgvRU1WTkl6TTkvbjhaa3VlK09IbUJhYnp5cW9EZlJUOEE5eEpP?=
 =?utf-8?B?enBmYmYxMUNWWEtVNUNBWjRZTDdSTkhKVG1qOGJ2QUVXQnZNdjNFMlREWDQw?=
 =?utf-8?B?VWJhNTE4ZkwyT2hTaElNTGlVbFVQa0xFVjFWSWU1Sk10VnBXaTFzYmpTelk4?=
 =?utf-8?B?L25zSFdqcWY1TnM4eGRQeDdobFNINnAzNUNqYUVsWW5TWVgwRlhWTDFDdFpH?=
 =?utf-8?B?ekF4cFRlSmlkZmowVE9haWRFUUZCNlZRQVNJZVRXbkROSEFTdENjNDdwMmJL?=
 =?utf-8?Q?wS6cHAA2euft+7Si2LiVB6XEVpBQCbo0YfAzj4t?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(7416009)(376009)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWlBaVBXc3pMVnZ0MWhiYkQwaGk1YnVQalN1bVArMkdWbTRhQ21leGNDTVh6?=
 =?utf-8?B?MDRmZFhmbWNTVy9pTDZCdXRSdEl3YzF5bm5rbTRvNGwvMkhoZmJFMlJtR0dZ?=
 =?utf-8?B?UnQ5bzAxbnltKzJoVExnM0JHRlBZeWMyN3lOOEVUOWttZDVzNGpEM3BBL2VK?=
 =?utf-8?B?MFJLR0VpSmFDd3F4dkdDam8xNW16aHVkZUlGMEo3ZTJqWGdJb2FNcldrdHBF?=
 =?utf-8?B?dTBMaVUxSU1kZzM0VXIvazlmMjRwZU1KejZBRE0vNk9ObXlVZjl1dy9pT0NE?=
 =?utf-8?B?dVhNVnU3RXcrZHk2bzZmZ0xxT3dRYlE0Um5xd0orWWdST043OFM1VmlmS0c4?=
 =?utf-8?B?cVRWSlU4Mm9XZVNCMnhpNGdGUnhHOFdCZGRiSDd0bjkwWUx0THhmYTJVaTlJ?=
 =?utf-8?B?bXUybzRuSjZ4Z2RFQ0lyc3dLdGE0Wkd0Z2k3bklkZUdkZnZKVFhDMWpyeXRQ?=
 =?utf-8?B?MWp4MVRKQU9SaGt0WXI2N3hQSHdZMzFJRHNWMFZLTzhUenBsc0s1QWhEaHVx?=
 =?utf-8?B?azNMR2NYSUd4Y0prbHpVNXl6VXNDTlU0cEJGaFYzckxqenFrVHF6c0MwWVpL?=
 =?utf-8?B?TFVnZXpYRThNcUFhdDZCUjQyN1RRTXFPRDA5ajFWQ3ZISGFRbnBEOG9CQktX?=
 =?utf-8?B?MStpWFRYQ3BaNm16WkF0d0o5UjMzU2MvNkdpdUNoUVZJNmRZYUtWaE85bGkx?=
 =?utf-8?B?TmlHSmg4MERwMUw1ZnRkUTdGVkViSHUweG5MZVpVZVZSSkg4bitNYTVzallR?=
 =?utf-8?B?Um5uTDQwbnhjamFabmJCMDRUTnZUdDlhY0pQWi8rRXFRNDhPcjZtS01EeUp5?=
 =?utf-8?B?THZmSW9tcEZPSlh1ZXVJbWNvaG9hOVEzd2ZVWUtPNjJNUWhoY3lxMHl2VVl5?=
 =?utf-8?B?cFNaTURMMFlKR3kvUEc0T3NmblpHeTR6a1pacE9kT2VuVkpEbVpGenRmUzB1?=
 =?utf-8?B?bmp5K0ZQdnZhRHBpdk5XY1cxT2RkYjRNOGcvTEFzZDVaeC8rblBOTVQrNlVz?=
 =?utf-8?B?Z3pEaGdudEJRMjc3UFBhb01oWEhPYVFXdm14eDh4MW8vTjZDOFZTdjFqUmZM?=
 =?utf-8?B?S1dmUWU1YlJCdHBhZTJqRmdGZDBxMStxZ3djNHNTZmlXWndnNGdyRGpsWjFj?=
 =?utf-8?B?a0pwak16WVNyK1p0ZWg2VFVuNDVINWdHdFFHTFZLenhMbktPTjhNWnZBaGE4?=
 =?utf-8?B?RmZFRUtvVlZKZWM2M2R5Y3hsTVM0VXZiTjZUUWhVdDBZT0dzMVpqVzlWLzBQ?=
 =?utf-8?B?M2RVS3VDeTRHb0pDRGtlalBuRExmYTBiUjNpRTBkcytnME9pbXU0ODM0Y2Yx?=
 =?utf-8?B?eG5nazFhVDRpaHJVYWdYYXYxQndNa1FZdmhKc0ZyYkpsRlFTVzNycElGVHVI?=
 =?utf-8?B?aU1kU3FheTI2ZVhTZnY5b3krT3ZMWCtKeGtsZU1JSllwOEN3cGVYU2RIUTBs?=
 =?utf-8?B?RE9ESjdnV2NLZVZhbWJnTTk0d203WGc4RHA5QkM4a05LSE83UXFHSEpJL0c1?=
 =?utf-8?B?VE4wRkhCT3BoUVpxK2hqN0hsUGNVNFNUZld6Tk1nTUpWbkdJajhDaUIrUG5v?=
 =?utf-8?B?NFdtdnFCSHR2K09uS2tyZU1MKy9DZXlJUlJqdjZSNzBmcGZkdnpUeGoxd2w0?=
 =?utf-8?B?cnNoQTdjTVJBWGtBdys1akZQVzh4aXBJSGNaNU1FNG5wV2hoZGdidER3b0h6?=
 =?utf-8?B?WjMvaGhSK0I2T1FGMGg5bGwxOUp3b1E1VGFEbUpPV0dtbXd2YzQ0dkxkdnlz?=
 =?utf-8?B?Q2h4MU5aVU1RdXVwcjlqVXZlcG9CTUtBcXFDb3lYYWwvU1lzejBicU1zemJV?=
 =?utf-8?B?ZGJSbERyMDhGUzlEajBBMDJrM0J4MWFRc29CdEdMaFFaWWZZbFZsUGpjS0hX?=
 =?utf-8?B?Um1OeGx5aWcwWkdLUlk0b29RbHRVYlVFTm5mNS9RUEhQNzU2T0NCYVhpU0JM?=
 =?utf-8?B?NlhaT0g4UTF2VmNJM1hTeDlXNUVyajZqTzRmckMyaWFnOXJXbHZ3L1hIZEs3?=
 =?utf-8?B?c0VpbFNvdVFhOWNMMVBxeDdHWUpIZm5Gc0ZCMWhaZU5mcmZ0a25NbnhCbWpY?=
 =?utf-8?B?eGdRaHg5TGE2TFZ3UFg1K3MxMmxpMzZNT2xlcEw1dm5mOGFZcHVHYkY0akxX?=
 =?utf-8?Q?W80nr9bT5T9tF2MVi/U3Xz1oZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94eca6c1-738d-4044-2a75-08dc8c1c92f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 02:49:13.1899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0n/GLrltrbaEEFld6iQpeCIBBUi9YTviiNuuL4BJrQ7TIPOKCoA9N5QCQM61fF71UaHVzGqgtmvObsBhK6ROdEOZU0W2AROJsabz7O8p70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6489
X-OriginatorOrg: intel.com

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IExpLCBYaWFveWFvIDx4aWFv
eWFvLmxpQGludGVsLmNvbT4NCj5TdWJqZWN0OiBSZTogW1BBVENIIHY1IDI1LzY1XSBpMzg2L3Rk
eDogQWRkIHByb3BlcnR5IHNlcHQtdmUtZGlzYWJsZSBmb3INCj50ZHgtZ3Vlc3Qgb2JqZWN0DQo+
DQo+T24gNi8xMy8yMDI0IDQ6MzUgUE0sIER1YW4sIFpoZW56aG9uZyB3cm90ZToNCj4+DQo+Pg0K
Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+Pj4gRnJvbTogTGksIFhpYW95YW8gPHhp
YW95YW8ubGlAaW50ZWwuY29tPg0KPj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjUgMjUvNjVdIGkz
ODYvdGR4OiBBZGQgcHJvcGVydHkgc2VwdC12ZS1kaXNhYmxlIGZvcg0KPj4+IHRkeC1ndWVzdCBv
YmplY3QNCj4+Pg0KPj4+IE9uIDYvNi8yMDI0IDY6NDUgUE0sIERhbmllbCBQLiBCZXJyYW5nw6kg
d3JvdGU6DQo+Pj4+IENvcHlpbmcgIFpoZW56aG9uZyBEdWFuIGFzIG15IHBvaW50IHJlbGF0ZXMg
dG8gdGhlIHByb3Bvc2VkIGxpYnZpcnQNCj4+Pj4gVERYIHBhdGNoZXMuDQo+Pj4+DQo+Pj4+IE9u
IFRodSwgRmViIDI5LCAyMDI0IGF0IDAxOjM2OjQ2QU0gLTA1MDAsIFhpYW95YW8gTGkgd3JvdGU6
DQo+Pj4+PiBCaXQgMjggb2YgVEQgYXR0cmlidXRlLCBuYW1lZCBTRVBUX1ZFX0RJU0FCTEUuIFdo
ZW4gc2V0IHRvIDEsIGl0DQo+Pj4gZGlzYWJsZXMNCj4+Pj4+IEVQVCB2aW9sYXRpb24gY29udmVy
c2lvbiB0byAjVkUgb24gZ3Vlc3QgVEQgYWNjZXNzIG9mIFBFTkRJTkcgcGFnZXMuDQo+Pj4+Pg0K
Pj4+Pj4gU29tZSBndWVzdCBPUyAoZS5nLiwgTGludXggVEQgZ3Vlc3QpIG1heSByZXF1aXJlIHRo
aXMgYml0IGFzIDEuDQo+Pj4+PiBPdGhlcndpc2UgcmVmdXNlIHRvIGJvb3QuDQo+Pj4+Pg0KPj4+
Pj4gQWRkIHNlcHQtdmUtZGlzYWJsZSBwcm9wZXJ0eSBmb3IgdGR4LWd1ZXN0IG9iamVjdCwgZm9y
IHVzZXIgdG8gY29uZmlndXJlDQo+Pj4+PiB0aGlzIGJpdC4NCj4+Pj4+DQo+Pj4+PiBTaWduZWQt
b2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4+Pj4+IEFja2VkLWJ5
OiBHZXJkIEhvZmZtYW5uIDxrcmF4ZWxAcmVkaGF0LmNvbT4NCj4+Pj4+IEFja2VkLWJ5OiBNYXJr
dXMgQXJtYnJ1c3RlciA8YXJtYnJ1QHJlZGhhdC5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+IENoYW5n
ZXMgaW4gdjQ6DQo+Pj4+PiAtIGNvbGxlY3QgQWNrZWQtYnkgZnJvbSBNYXJrdXMNCj4+Pj4+DQo+
Pj4+PiBDaGFuZ2VzIGluIHYzOg0KPj4+Pj4gLSB1cGRhdGUgdGhlIGNvbW1lbnQgb2YgcHJvcGVy
dHkgQHNlcHQtdmUtZGlzYWJsZSB0byBtYWtlIGl0IG1vcmUNCj4+Pj4+ICAgICBkZXNjcmlwdGl2
ZSBhbmQgdXNlIG5ldyBmb3JtYXQuIChEYW5pZWwgYW5kIE1hcmt1cykNCj4+Pj4+IC0tLQ0KPj4+
Pj4gICAgcWFwaS9xb20uanNvbiAgICAgICAgIHwgIDcgKysrKysrLQ0KPj4+Pj4gICAgdGFyZ2V0
L2kzODYva3ZtL3RkeC5jIHwgMjQgKysrKysrKysrKysrKysrKysrKysrKysrDQo+Pj4+PiAgICAy
IGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pj4+DQo+
Pj4+PiBkaWZmIC0tZ2l0IGEvcWFwaS9xb20uanNvbiBiL3FhcGkvcW9tLmpzb24NCj4+Pj4+IGlu
ZGV4IDIyMGNjNmM5OGQ0Yi4uODllZDg5YjliNDZlIDEwMDY0NA0KPj4+Pj4gLS0tIGEvcWFwaS9x
b20uanNvbg0KPj4+Pj4gKysrIGIvcWFwaS9xb20uanNvbg0KPj4+Pj4gQEAgLTkwMCwxMCArOTAw
LDE1IEBADQo+Pj4+PiAgICAjDQo+Pj4+PiAgICAjIFByb3BlcnRpZXMgZm9yIHRkeC1ndWVzdCBv
YmplY3RzLg0KPj4+Pj4gICAgIw0KPj4+Pj4gKyMgQHNlcHQtdmUtZGlzYWJsZTogdG9nZ2xlIGJp
dCAyOCBvZiBURCBhdHRyaWJ1dGVzIHRvIGNvbnRyb2wgZGlzYWJsaW5nDQo+Pj4+PiArIyAgICAg
b2YgRVBUIHZpb2xhdGlvbiBjb252ZXJzaW9uIHRvICNWRSBvbiBndWVzdCBURCBhY2Nlc3Mgb2Yg
UEVORElORw0KPj4+Pj4gKyMgICAgIHBhZ2VzLiAgU29tZSBndWVzdCBPUyAoZS5nLiwgTGludXgg
VEQgZ3Vlc3QpIG1heSByZXF1aXJlIHRoaXMgdG8NCj4+Pj4+ICsjICAgICBiZSBzZXQsIG90aGVy
d2lzZSB0aGV5IHJlZnVzZSB0byBib290Lg0KPj4+Pj4gKyMNCj4+Pj4+ICAgICMgU2luY2U6IDku
MA0KPj4+Pj4gICAgIyMNCj4+Pj4+ICAgIHsgJ3N0cnVjdCc6ICdUZHhHdWVzdFByb3BlcnRpZXMn
LA0KPj4+Pj4gLSAgJ2RhdGEnOiB7IH19DQo+Pj4+PiArICAnZGF0YSc6IHsgJypzZXB0LXZlLWRp
c2FibGUnOiAnYm9vbCcgfSB9DQo+Pj4+DQo+Pj4+IFNvIHRoaXMgZXhwb3NlcyBhIHNpbmdsZSBi
b29sZWFuIHByb3BlcnR5IHRoYXQgZ2V0cyBtYXBwZWQgaW50byBvbmUNCj4+Pj4gc3BlY2lmaWMg
Yml0IGluIHRoZSBURCBhdHRyaWJ1dGVzOg0KPj4+Pg0KPj4+Pj4gKw0KPj4+Pj4gK3N0YXRpYyB2
b2lkIHRkeF9ndWVzdF9zZXRfc2VwdF92ZV9kaXNhYmxlKE9iamVjdCAqb2JqLCBib29sIHZhbHVl
LA0KPkVycm9yDQo+Pj4gKiplcnJwKQ0KPj4+Pj4gK3sNCj4+Pj4+ICsgICAgVGR4R3Vlc3QgKnRk
eCA9IFREWF9HVUVTVChvYmopOw0KPj4+Pj4gKw0KPj4+Pj4gKyAgICBpZiAodmFsdWUpIHsNCj4+
Pj4+ICsgICAgICAgIHRkeC0+YXR0cmlidXRlcyB8PSBURFhfVERfQVRUUklCVVRFU19TRVBUX1ZF
X0RJU0FCTEU7DQo+Pj4+PiArICAgIH0gZWxzZSB7DQo+Pj4+PiArICAgICAgICB0ZHgtPmF0dHJp
YnV0ZXMgJj0gflREWF9URF9BVFRSSUJVVEVTX1NFUFRfVkVfRElTQUJMRTsNCj4+Pj4+ICsgICAg
fQ0KPj4+Pj4gK30NCj4+Pj4NCj4+Pj4gSWYgSSBsb29rIGF0IHRoZSBkb2N1bWVudGF0aW9uIGZv
ciBURCBhdHRyaWJ1dGVzDQo+Pj4+DQo+Pj4+ICAgICBodHRwczovL2Rvd25sb2FkLjAxLm9yZy9p
bnRlbC1zZ3gvbGF0ZXN0L2RjYXAtDQo+Pj4gbGF0ZXN0L2xpbnV4L2RvY3MvSW50ZWxfVERYX0RD
QVBfUXVvdGluZ19MaWJyYXJ5X0FQSS5wZGYNCj4+Pj4NCj4+Pj4gU2VjdGlvbiAiQS4zLjQuIFRE
IEF0dHJpYnV0ZXMiDQo+Pj4+DQo+Pj4+IEkgc2VlICJURCBhdHRyaWJ1dGVzIiBpcyBhIDY0LWJp
dCBpbnQsIHdpdGggNSBiaXRzIGN1cnJlbnRseQ0KPj4+PiBkZWZpbmVkICJERUJVRyIsICJTRVBU
X1ZFX0RJU0FCTEUiLCAiUEtTIiwgIlBMIiwgIlBFUkZNT04iLA0KPj4+PiBhbmQgdGhlIHJlc3Qg
Y3VycmVudGx5IHJlc2VydmVkIGZvciBmdXR1cmUgdXNlLiBUaGlzIG1ha2VzIG1lDQo+Pj4+IHdv
bmRlciBhYm91dCBvdXIgbW9kZWxsaW5nIGFwcHJvYWNoIGludG8gdGhlIGZ1dHVyZSA/DQo+Pj4+
DQo+Pj4+IEZvciB0aGUgQU1EIFNFViBlcXVpdmFsZW50IHdlJ3ZlIGp1c3QgZGlyZWN0bHkgZXhw
b3NlZCB0aGUgd2hvbGUNCj4+Pj4gZmllbGQgYXMgYW4gaW50Og0KPj4+Pg0KPj4+PiAgICAgICAg
J3BvbGljeScgOiAndWludDMyJywNCj4+Pj4NCj4+Pj4gRm9yIHRoZSBwcm9wb3NlZCBTRVYtU05Q
IHBhdGNoZXMsIHRoZSBzYW1lIGhhcyBiZWVuIGRvbmUgYWdhaW4NCj4+Pj4NCj4+Pj4gaHR0cHM6
Ly9saXN0cy5ub25nbnUub3JnL2FyY2hpdmUvaHRtbC9xZW11LWRldmVsLzIwMjQtDQo+Pj4gMDYv
bXNnMDA1MzYuaHRtbA0KPj4+Pg0KPj4+PiAgICAgICAgJypwb2xpY3knOiAndWludDY0JywNCj4+
Pj4NCj4+Pj4NCj4+Pj4gVGhlIGFkdmFudGFnZSBvZiBleHBvc2luZyBpbmRpdmlkdWFsIGJvb2xl
YW5zIGlzIHRoYXQgaXQgaXMNCj4+Pj4gc2VsZi1kb2N1bWVudGluZyBhdCB0aGUgUUFQSSBsZXZl
bCwgYnV0IHRoZSBkaXNhZHZhbnRhZ2UgaXMNCj4+Pj4gdGhhdCBldmVyeSB0aW1lIHdlIHdhbnQg
dG8gZXhwb3NlIGFiaWxpdHkgdG8gY29udHJvbCBhIG5ldw0KPj4+PiBiaXQgaW4gdGhlIHBvbGlj
eSB3ZSBoYXZlIHRvIG1vZGlmeSBRRU1VLCBsaWJ2aXJ0LCB0aGUgbWdtdA0KPj4+PiBhcHAgYWJv
dmUgbGlidmlydCwgYW5kIHdoYXRldmVyIHRvb2xzIHRoZSBlbmQgdXNlciBoYXMgdG8NCj4+Pj4g
dGFsayB0byB0aGUgbWdtdCBhcHAuDQo+Pj4+DQo+Pj4+IElmIHdlIGV4cG9zZSBhIHBvbGljeSBp
bnQsIHRoZW4gbmV3bHkgZGVmaW5lZCBiaXRzIG9ubHkgcmVxdWlyZQ0KPj4+PiBhIGNoYW5nZSBp
biBRRU1VLCBhbmQgZXZlcnl0aGluZyBhYm92ZSBRRU1VIHdpbGwgYWxyZWFkeSBiZQ0KPj4+PiBj
YXBhYmxlIG9mIHNldHRpbmcgaXQuDQo+Pj4+DQo+Pj4+IEluIGZhY3QgaWYgSSBsb29rIGF0IHRo
ZSBwcm9wb3NlZCBsaWJ2aXJ0IHBhdGNoZXMsIHRoZXkgaGF2ZQ0KPj4+PiBwcm9wb3NlZCBqdXN0
IGV4cG9zaW5nIGEgcG9saWN5ICJpbnQiIGZpZWxkIGluIHRoZSBYTUwsIHdoaWNoDQo+Pj4+IHRo
ZW4gaGFzIHRvIGJlIHVucGFja2VkIHRvIHNldCB0aGUgaW5kaXZpZHVhbCBRQVBJIGJvb2xlYW5z
DQo+Pj4+DQo+Pj4+DQo+Pj4NCj5odHRwczovL2xpc3RzLmxpYnZpcnQub3JnL2FyY2hpdmVzL2xp
c3QvZGV2ZWxAbGlzdHMubGlidmlydC5vcmcvbWVzc2FnZS9XWFdYDQo+Pj4gRUVTWVVBNzdEUDdZ
SUJQNTVUMk9QU1ZLVjVRVy8NCj4+Pj4NCj4+Pj4gT24gYmFsYW5jZSwgSSB0aGluayBpdCB3b3Vs
ZCBiZSBiZXR0ZXIgaWYgUUVNVSBqdXN0IGV4cG9zZWQNCj4+Pj4gdGhlIHJhdyBURCBhdHRyaWJ1
dGVzIHBvbGljeSBhcyBhbiB1aW50NjQgYXQgUUFQSSwgaW5zdGVhZA0KPj4+PiBvZiB0cnlpbmcg
dG8gdW5wYWNrIGl0IHRvIGRpc2NyZXRlIGJvb2wgZmllbGRzLiBUaGlzIGdpdmVzDQo+Pj4+IGNv
bnNpc3RlbmN5IHdpdGggU0VWIGFuZCBTRVYtU05QLCBhbmQgd2l0aCB3aGF0J3MgcHJvcG9zZWQN
Cj4+Pj4gYXQgdGhlIGxpYnZpcnQgbGV2ZWwsIGFuZCBtaW5pbWl6ZXMgZnV0dXJlIGNoYW5nZXMg
d2hlbg0KPj4+PiBtb3JlIHBvbGljeSBiaXRzIGFyZSBkZWZpbmVkLg0KPj4+DQo+Pj4gVGhlIHJl
YXNvbnMgd2h5IGludHJvZHVjaW5nIGluZGl2aWR1YWwgYml0IG9mIHNlcHQtdmUtZGlzYWJsZSBp
bnN0ZWFkIG9mDQo+Pj4gYSByYXcgVEQgYXR0cmlidXRlIGFzIGEgd2hvbGUgYXJlIHRoYXQNCj4+
Pg0KPj4+IDEuIG90aGVyIGJpdHMgbGlrZSBwZXJmbW9uLCBQS1MsIEtMIGFyZSBhc3NvY2lhdGVk
IHdpdGggY3B1IHByb3BlcnRpZXMsDQo+Pj4gZS5nLiwNCj4+Pg0KPj4+IAlwZXJmbW9uIC0+IHBt
dSwNCj4+PiAJcGtzIC0+IHBrcywNCj4+PiAJa2wgLT4ga2V5bG9rY2VyIGZlYXR1cmUgdGhhdCBR
RU1VIGN1cnJlbnRseSBkb2Vzbid0IHN1cHBvcnQNCj4+Pg0KPj4+IElmIGFsbG93aW5nIGNvbmZp
Z3VyaW5nIGF0dHJpYnV0ZSBkaXJlY3RseSwgd2UgbmVlZCB0byBkZWFsIHdpdGggdGhlDQo+Pj4g
aW5jb25zaXN0ZW5jZSBiZXR3ZWVuIGF0dHJpYnV0ZSB2cyBjcHUgcHJvcGVydHkuDQo+Pg0KPj4g
V2hhdCBhYm91dCBkZWZpbmluZyB0aG9zZSBiaXRzIGFzc29jaWF0ZWQgd2l0aCBjcHUgcHJvcGVy
dGllcyByZXNlcnZlZA0KPj4gQnV0IG90aGVyIGJpdHMgd29yayBhcyBEYW5pZWwgc3VnZ2VzdGVk
IHdheS4NCj4NCj5JIGRvbid0IHVuZGVyc3RhbmQuIERvIHlvdSBtZWFuIHdlIHByb3ZpZGUgdGhl
IGludGVyZmFjZSB0byBjb25maWd1cmUNCj5yYXcgNjQgYml0IGF0dHJpYnV0ZXMgd2hpbGUgc29t
ZSBiaXRzIG9mIGl0IGFyZSByZXNlcnZlZD8NCg0KWWVzLCBxZW11IHByb3ZpZGUgcmF3IDY0Yml0
IGF0dHJpYnV0ZSBidXQgaWdub3JlIHRob3NlIGNwdWlkIHJlbGF0ZWQgYml0cw0KdG8gYXZvaWQg
Y29uZmlnIGNvbmZsaWN0Lg0KDQpZb3UgY2FuIHN0aWxsIHByb3ZpZGUgc2VwdC12ZS1kaXNhYmxl
IGFuZCBkZWJ1ZyBwcm9wZXJ0aWVzIGluIHFlbXUgaWYgeW91IHdhbnQsDQpCdXQgTGlidmlydCB3
aWxsIG5vdCB1c2UgdGhlbSwgaXQgd2lsbCB1c2UgdGhlIHJhdyA2NGJpdCBhdHRyaWJ1dGUuDQoN
ClRoYW5rcw0KWmhlbnpob25nDQoNCj4NCj4+IFRoYW5rcw0KPj4gWmhlbnpob25nDQo+Pg0KPj4+
DQo+Pj4gMi4gcGVvcGxlIG5lZWQgdG8ga25vdyB0aGUgZXhhY3QgYml0IHBvc2l0aW9uIG9mIGVh
Y2ggYXR0cmlidXRlLiBJIGRvbid0DQo+Pj4gdGhpbmsgaXQgaXMgYSB1c2VyLWZyaWVuZGx5IGlu
dGVyZmFjZSB0byByZXF1aXJlIHVzZXIgdG8gYmUgYXdhcmUgb2YNCj4+PiBzdWNoIGRldGFpbHMu
DQo+Pj4NCj4+PiBGb3IgZXhhbXBsZSwgaWYgdXNlciB3YW50cyB0byBjcmVhdGUgYSBEZWJ1ZyBU
RCwgdXNlciBqdXN0IG5lZWRzIHRvIHNldA0KPj4+ICdkZWJ1Zz1vbicgZm9yIHRkeC1ndWVzdCBv
YmplY3QuIEl0J3MgbXVjaCBtb3JlIGZyaWVuZGx5IHRoYW4gdGhhdCB1c2VyDQo+Pj4gbmVlZHMg
dG8gc2V0IHRoZSBiaXQgMCBvZiB0aGUgYXR0cmlidXRlLg0KPj4+DQo+Pj4NCj4+Pj4+ICsNCj4+
Pj4+ICAgIC8qIHRkeCBndWVzdCAqLw0KPj4+Pj4gICAgT0JKRUNUX0RFRklORV9UWVBFX1dJVEhf
SU5URVJGQUNFUyhUZHhHdWVzdCwNCj4+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdGR4X2d1ZXN0LA0KPj4+Pj4gQEAgLTUyOSw2ICs1NDksMTAgQEAgc3RhdGljIHZv
aWQgdGR4X2d1ZXN0X2luaXQoT2JqZWN0ICpvYmopDQo+Pj4+PiAgICAgICAgcWVtdV9tdXRleF9p
bml0KCZ0ZHgtPmxvY2spOw0KPj4+Pj4NCj4+Pj4+ICAgICAgICB0ZHgtPmF0dHJpYnV0ZXMgPSAw
Ow0KPj4+Pj4gKw0KPj4+Pj4gKyAgICBvYmplY3RfcHJvcGVydHlfYWRkX2Jvb2wob2JqLCAic2Vw
dC12ZS1kaXNhYmxlIiwNCj4+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRkeF9n
dWVzdF9nZXRfc2VwdF92ZV9kaXNhYmxlLA0KPj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgdGR4X2d1ZXN0X3NldF9zZXB0X3ZlX2Rpc2FibGUpOw0KPj4+Pj4gICAgfQ0KPj4+Pj4N
Cj4+Pj4+ICAgIHN0YXRpYyB2b2lkIHRkeF9ndWVzdF9maW5hbGl6ZShPYmplY3QgKm9iaikNCj4+
Pj4+IC0tDQo+Pj4+PiAyLjM0LjENCj4+Pj4+DQo+Pj4+DQo+Pj4+IFdpdGggcmVnYXJkcywNCj4+
Pj4gRGFuaWVsDQo+Pg0KDQo=

