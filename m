Return-Path: <kvm+bounces-58909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FECCBA55BA
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 00:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32923386A03
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 22:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B422BDC00;
	Fri, 26 Sep 2025 22:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WAOBmdZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27315275B16;
	Fri, 26 Sep 2025 22:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758926525; cv=fail; b=W+QhYbe4boqbP1U9B3laM3chmiC4R9PJGiA+9CNor5yY2zaVtxkQeAkla9e/8En85+JFYbgB7hg716BxTTuHcogfHEc1bkLp2MFmeR+apNOfUQj4a1gKjR8qwYwuGmtFlO+6T/+6rGqutdpXQohYDNjfajjjg65BluUHi1ZxhFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758926525; c=relaxed/simple;
	bh=BCfAgMwmSwF9XOSWluprwpD/1jvSgaUBslojMvo10AA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pBWA2GyQohOIZmlzhSZZ9+Oa8os9dGrAZXn6y4XvdErkZiHEFIiSbvVylUUP1Q3kscZCnZPchkB7sYuyucCfKsMAl3AF1dMyI6JsBZ2euSMUxSntuU6CreBMIQD/kdpG2/c1mmXXr+f1nLRCQBlx0EhIK8Ts7rAhKB6oJU+h5YY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WAOBmdZ3; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758926524; x=1790462524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BCfAgMwmSwF9XOSWluprwpD/1jvSgaUBslojMvo10AA=;
  b=WAOBmdZ37QvfOsEa1enNLq3egGc4i4rOZxRkmOMpURsJCKnN/vRm2jrp
   0OgHweGgPC1nf1GTjh4snNj0FpTLNTfZGmVMMrVf+K8e5RKLZkzoKp6Xw
   KCQmvBsO7gcCrBlMnIVsTn6guhyjdfT1KjrGC7xAYTml+qyGj5sE1IJ68
   fyWtY8+61Qe97zuCO447WjRw791oK4bdSEcLYy10JAaZvaf/0F99Slph/
   PMWKSSrFsEGZ1IPdKbWJ9vVVd7B8PJJgYwG6UJivlaPdXRNwbDVWhigEb
   JvaltiMljLoI6X3ZkJm5iq2s+uEYPhFyt1VHXaI0XR/Fd6Fou4TBUfDxL
   A==;
X-CSE-ConnectionGUID: aI41/bsOSku7euheuYrMNQ==
X-CSE-MsgGUID: CdxT3f+xSZWGE0Hx5kDz6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="60966840"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="60966840"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:42:03 -0700
X-CSE-ConnectionGUID: Wy8FXWu3QTq7gG524znWMQ==
X-CSE-MsgGUID: N/sFHJFHSqi46CRelA48jA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:42:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:42:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 15:42:01 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:42:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AeV2R8jAF7ZU32vlMUC5NlTlg7CvaQ7lXJgFao2W4f1jdkyj0M4e4ioHSSlN9HvxVRAJiXCAYN5YZ1V5vWn85GdLFaruZjk8WWe16Yioz7FIJv8lY1SzXVatUYhJrBRAdbBFORLCUAKuogCL+X/tgdTu5PnTeR1uZMCeu8KiPwThAW8flDFoJysP8aM7MxTSVJQculc8VIHqElMXJP34xE814yH5EwOZK/k26VvYRB94xB+nFcQsYqxp4dqzGr36786HnxCxZJ9/Zn+EJydH3ryqxzQ/mddPOVXZcQaLpK0L7Zh/BId4uBDo8HNcLzGSniQbHrHT5nbsI9AL3mFrUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCfAgMwmSwF9XOSWluprwpD/1jvSgaUBslojMvo10AA=;
 b=GYxdfPAZX9aSAgy0w/Wvjkmlkr6On1a/bK62spPDNPpqpGc05jYHiwaEhe8qgJokTcAFS1GWCHpCcUgQtDAVo2auVXqgdZME58jHZ+4yfYXtdwlVxb/38RnUU+YG0ATHO08U15EMSzFM1ozPVyntG9dY/LBYI1N2qycC9yURVVYBSU+/Cv4goBlByRakDdYqA2T9sQI+vKbpgNvmMbOcEcoVcMyfc2VPjgFrwe61S5umxAmM4j2HimNloni5Io6WsbrcEQGzarLbjTTfDzWHSs1It8gJFoPVW18M8qb5qP1B3+Hfi1hRrlhTdHjtDBWlK+HGiZfo/T/0e0E9D+r8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7397.namprd11.prod.outlook.com (2603:10b6:8:103::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 22:41:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 22:41:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcKPM1NzNrnMrGfkmDv8ppN4f8QLSfFdeAgAcFsYA=
Date: Fri, 26 Sep 2025 22:41:53 +0000
Message-ID: <d3375b508b0d3b53a6ac7fff5e5494613cee47a9.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
	 <348ae3abccbead93119ddf9451ef26292634f977.camel@intel.com>
In-Reply-To: <348ae3abccbead93119ddf9451ef26292634f977.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7397:EE_
x-ms-office365-filtering-correlation-id: 40d00ea8-ce66-47a0-850b-08ddfd4de418
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZXN0cUw4QURLRFhIOE5WQ0hldlZIOFovY29VVHNBN1lmZlVNSHdXbjRLdytT?=
 =?utf-8?B?YndhYVlUNkdDOFRqcXNzZjJ2OXRHNmkya096eXBvQWlmZTBxK0UyNDE4Vmcx?=
 =?utf-8?B?MDFYbkJ3VlZ5RlI5ZUVhdExQTndSMzBpNXI2YXR4R0YvMGRONVh3VjNoV3NK?=
 =?utf-8?B?WjBUNncwemFtWjV4SDREZk5zTytxa2Qvdk1QOU53U3FiOENhcFZmTVF5cWNV?=
 =?utf-8?B?dUNDYTlnNld2aW1UU0tsbkNncU10dEdvTVpYQzI4a2hqeWt5RUxZM004ZTBt?=
 =?utf-8?B?dExpMzhvcUpKNVgyMUVEeDZDaGpXdFZpT0h5M3hYeUFHZzJWRXdOanhiQXBx?=
 =?utf-8?B?aW5FVE1SNVNvQ1NZdUhjK2FOVkhyK3p5QjNGUERUYTUwdFo3MWZYUXJvck1C?=
 =?utf-8?B?RmJISEQyek5LU0ZkNlJNb091ZHM4SUljMy96bVRudkJvWnRrS2pES25EalRH?=
 =?utf-8?B?OWJlaXc1cWJ5L05CTlpZekRBQnJaNXA4dFd0MmFDWXltTmtpNDVDR00vbVR2?=
 =?utf-8?B?WkNubThBRm9jUUFrQlRyb3lqRm5VN1Y1eDJFU3lDSkxEOUFWTHdFYzlQMEEr?=
 =?utf-8?B?ZEh5MWc1WFY5K3NYeVpmcEVrcWVxZlRySDlaRi82ZEMzV2JBbkRYb2VpZk1O?=
 =?utf-8?B?UUNxRmhsbHhzdjl0T0t5ZlE3QzVDeDEzTUtBZFBaRFFMNmNNNDh5cVE4N0ZH?=
 =?utf-8?B?WjIvUk5MSXREbmZvOG9PeEc1dTJmVEF2SXovUWloaUFxVHZwMGZoMmZ4WXNS?=
 =?utf-8?B?azlVTWFFSENiaVNTM3lhMHVkQUtkQ2RvOC9FVDNKTE1Mby9NT0RuTnV0VUJE?=
 =?utf-8?B?VndOTWs0ZlFtejcvYVJDNjF3dWxjTGRJdnlENjJUZWpXcXhqTDRzK1FwOGpa?=
 =?utf-8?B?a0RKN2VJeHRQVjAzTytTVjZ6dHhmdlE1dTI4SVZpZHNGTngvdUhlczBJL2ll?=
 =?utf-8?B?VmtURWx1cEVqaHlEbmpMVXd1UHZwSlVNZzBiaVVHQWxNOVRYWGVzMkQ0b0du?=
 =?utf-8?B?T0g1ZUNBc1Z3b2xBVnJsTnR0dVN3SThvOG0yL3duaUc2dWk3ZnU0dS93WWZ1?=
 =?utf-8?B?WjBBaFBkOU5kSGJTUzQ4dTVGeUcyY25RK1BNWlYyTGVqZ3cwSmZwNmFZcURu?=
 =?utf-8?B?UjFKemNHZnVnRXNNcmlnVTM1MHFGL3NZeDVGVFdHMWVCN2w2SlNOdWxhNUNY?=
 =?utf-8?B?VXlxcjludVUrUkZBYzVubnNFNW4vSXdsNS8wNWk1bjlsRzc3OHI3aHVXSlV1?=
 =?utf-8?B?Mng1Wk4raXl4dEZsc21VV0l0K3Z6VzVMeUNTUDY0ZjQraWo0bWxXaGpTSmZ3?=
 =?utf-8?B?Qi9KYkx6dldXR2xUNDk1MTFpM1VoMXdGVDZPNUpXVjVaYXVZbGliZkROTFlO?=
 =?utf-8?B?TlUrWnBpRnRSRjdkQUUvQ2g2Zk4xbUJLTjhxcmttSE1Xa2xhMzE5UC9tWC9r?=
 =?utf-8?B?aSsrb1FnMnlwQ2dsSU81dEN0c1JnM2RQS1RSTHJHOVcwSlpkVVdYcFdLU3c1?=
 =?utf-8?B?MHQzQUJXNVdnZkczUTFZTDZjbnpmdnBmWjY5U1drbEQxNG1EVldXbkYrWDBi?=
 =?utf-8?B?YklhVkZHUVdHYzYwc0RiV21VUXFQcWdWZ05WMmRsYWxRLzB4WGI3czVEQXI4?=
 =?utf-8?B?RmYvTk1lR041dXhOVDBlZXZWWFB5YXdOVUl1bmkvMUh4K1l5YXRMM0xBdFI4?=
 =?utf-8?B?V3FJdDlxcHlsb0RCMzBiYzNyZEpTb0xaUHJ2UXJ4QUZvb08yd3YwSVJ5ZXhl?=
 =?utf-8?B?WHo1ZFF6SndZczhDeHlnekMwMzhBOWpBdjkwaUxVakNhbzdIWEJaMkJXWnZS?=
 =?utf-8?B?bk1YK0JvQlhYZkVsNjc3UlZSQXdnQ0R0REhmVXF0ODVkZEtjRGw4R2Y2cVMr?=
 =?utf-8?B?Y3RicFRVaXBvS0liWm1FOHRreFE1RXRrcjV0a3RmNkNXcmprdDdhTkg3UXA5?=
 =?utf-8?B?TUhlblpUWExvSkE4RzlIRnZjeE5KaHlNWTVqb09kMjBFeVZQRDJJVE1DVDJz?=
 =?utf-8?B?TmlGZGpQRDdTcVF6dGJ1RjZtUzhCNWpTbWsvL1lyWUpNMHEwR25oSTUvVXZx?=
 =?utf-8?B?cCtNV1NReXZyOHUyQXpKMmVTRlpsS28vUEdJZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MS9KY2wxWkhpdjB6OVYzWUJNemZwQlZXY25lcEhjd2lkL1lsd01mYXZJUUg1?=
 =?utf-8?B?VW1DVmM2dEZsR3JEcEdFZnFiU0tGUUhqS3ozeUt3Q2NLZU5hZ1c5WnhKbFFk?=
 =?utf-8?B?YldWTlFPK2orbXJBS0NhcklMMWYxWmVwYTQwUm9veDVTSFJsNnMvNFdJUXhK?=
 =?utf-8?B?SmoydTJBa3Z3d0VBSkZxY3N4OWpsT0swUlN4cUdReGVjS0M0dE9nb055Nlpn?=
 =?utf-8?B?TmwrN3R3RFliS1RRc2dtOXcwMmFLdG82ZnBIMkh2b2dWVDF3WFdXL1o1Z3Mr?=
 =?utf-8?B?UG1vOFFqOHlqN2pxdlRRZG9MeUdZS0RoRklrZnF0cXJ2UmxJdjNheW5LNGRr?=
 =?utf-8?B?ZGRHVjY4OXNXTTNIWWlwU1hacnpFRVNReUs1dWVSZzQzeVlXbnAzNWl2R1ZV?=
 =?utf-8?B?R1VrUkl2dXBYQ3JQRmowZWozK052bFlLSllPZGtWTk12RmdCOFVDcDRLV1Nh?=
 =?utf-8?B?L1l3RkNvMlF3bUZwY092S3RrMnpnZ3VvbkY1dERFbTIwVkVQZHZ3MXFLUmMy?=
 =?utf-8?B?YXB4bk5Cc2lwRWk4Qm9tNDU3V1dTQmpZM3FFNTZGQ2Jpb09PZE9CTXlvRXdZ?=
 =?utf-8?B?MzBIbGdMemhVSXpSTzZHUzdINGJLNjRZRWJVS3U4NWxDNEZhaGtLRXpNeWVq?=
 =?utf-8?B?VmwyMEx5cFNSRk8vNmYyZHZtOGozMWN4cjNiKytwTHNjcTM3ZUM3eFZaSnV0?=
 =?utf-8?B?WGw0eFJFRzd4cXBmT0JOZlhkK0dPQ0dZNHpLNmVzbVMyS2QxdmtRQ0VHbTU5?=
 =?utf-8?B?alg1Ny9veEFQQXlPbjNTRlpLd29JSHNkam4zSW9NNHFxNWRHOFBBZ0JuN1My?=
 =?utf-8?B?aW5yVUtQQ1UvN0JGQkIrOTVtYjRxUi9ITHZPMjZRNEdHRGZhYmpSck9MbGUy?=
 =?utf-8?B?OTZpQk5sRlN3YjRxQlArT2lTcS9ncHY5N1UrTDdmcEhPVW5UbENUTWdzL3RP?=
 =?utf-8?B?MUgrVlZKV3lEMXpUc0tBbkNVL3FlL2pPbVBTWHFHQk5WMDRYZnUxZVFhcktZ?=
 =?utf-8?B?blgzRWV0L1JmMEtqblZZbUcxdGI3b3VqVDNuMUVYSGEzcW1PSmdvbTJxUUlY?=
 =?utf-8?B?emZNeERQQnNnTitQRlBYbnFIdEFnT1JlZ213TUhUdU0zcnNUVTZtUGQzUklP?=
 =?utf-8?B?NldSczV4Q2hKUEh3MUQ2S3VxamExbndGckVHcTNRTi9ibUdrMHJMLzE3cUo0?=
 =?utf-8?B?Zm5tTjhPcXhMeDJ5cERBWHROdjQ3ZjhmZ2FjdnA5aU5Ua3k2REt4b3BUU0Fn?=
 =?utf-8?B?SlBBcjFHYlJtSEZIS2RJQkRGRjZMc0EzTCtXQ0M3a2NIODBQcVNZSEpNWm9o?=
 =?utf-8?B?TjMwQng5b3VsNFJiN2NlVkR4Y1lxTkxMZDVHTVhnR3ZTVmpMYnFqRnFQR0NI?=
 =?utf-8?B?c1d0UzR0Y1VQVnhHQmZoNThXWE1Uc1MydVQ5N1FYbEMvbGFSQ1dKT1dsdkFi?=
 =?utf-8?B?M1F1WDFDV1FRQXdna05Ec1p6Y0R5c3dRc3NxRmdNNW8vWUlGRUV3bkd2V3Zt?=
 =?utf-8?B?M29KUk9RSHg4QmczdlZyTW9ianloVnlnaDZzQXhMUnhmaGhaQi9RUW5CeWFP?=
 =?utf-8?B?ZmxZQzltY0tGUm50L2pHMEwxcTJhYTB1RDJwdThtTXZ4OXRLb1d5L0hxcXNH?=
 =?utf-8?B?SzhPMkxoQmRSSW9oTFhpaWtML2F4YjhWOFN0Tnc1STU5RE94V1hTT2N4UGw2?=
 =?utf-8?B?R1hGbTlYNUxCbTByVThBQXpsRXRvOEszeHFYanJxeFRJVG1FcjVZZ28xMHNG?=
 =?utf-8?B?djJZamMwdExxWmp1QnpBY0F5VUhNbjdQY0FOZ1hmM3RTQ0dCZExUUmNvZ3k3?=
 =?utf-8?B?WVYwcmlsYzRZRnE1b3pDb29qdlluVHQ2SFAyZGJuYng5RkJnR043YVozd0xN?=
 =?utf-8?B?TGxkSzBJODJxVVM2TExxN2dUSDRlOU5XbkJOY2FXTmNiWTRMSlpBSE1CTWF5?=
 =?utf-8?B?dlMyd2N6TmlTZEdyREtKbjVWOVRUbVdOMjBNRU5uUmp6dW5MQ2VUVDhTaEFV?=
 =?utf-8?B?SHpNOGxOeStocERqY0txRVRKdU41RGZSY2RERzNIcUtaYURzd1prUXo2ckdM?=
 =?utf-8?B?REVnc0JTc2VKZ2R2NVZMN1BuWk5RSnRYcEZ2MVhpVEFZWTQ0ZTNVcXIyT280?=
 =?utf-8?B?N2E4TWRGOHRPb1Z2SGxxZ1VMUzI2dFhKUzVwWjVDOFgzOXIyaUtHZm9qQU5W?=
 =?utf-8?Q?D6ih+E4YJpHGzICsMC94SGI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D1CF371F225BA43AE82EA4933FCE27C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d00ea8-ce66-47a0-850b-08ddfd4de418
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 22:41:53.7278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z+ZidV6ndDzEl11phP5lFglcmdarWixuRIgJGvi7j4XIcpDxK7A5VziwnV50SHvDu+TsYQI5Uu2WpadIatt4lDteY4o/Pw8MnJBaEqI9dkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7397
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTIyIGF0IDExOjI3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIEl0IG1pZ2h0IGhhdmUgY29tZSBmcm9tICdwcmVhbGxv
YycsIGJ1dCB0aGlzIGlzDQo+ID4gYW4gZXJyb3INCj4gPiArCQkgKiBwYXRoLiBEb24ndCBiZSBm
YW5jeSwganVzdCBmcmVlIHRoZW0uDQo+ID4gVERILlBIWU1FTS5QQU1ULkFERA0KPiA+ICsJCSAq
IG9ubHkgbW9kaWZpZXMgUkFYLCBzbyB0aGUgZW5jb2RlZCBhcnJheSBpcw0KPiA+IHN0aWxsIGlu
IHBsYWNlLg0KPiA+ICsJCSAqLw0KPiA+ICsJCV9fZnJlZV9wYWdlKHBoeXNfdG9fcGFnZShwYV9h
cnJheVtpXSkpOw0KPiA+IA0KPiANCj4gVGhpcyBjb21tZW50IHNob3VsZG4ndCBiZSBpbiB0aGlz
IHBhdGNoP8KgIFRoZSAncHJlYWxsb2MnIGNvbmNlcHQNCj4gZG9lc24ndA0KPiBleGlzdCB5ZXQg
dW50aWwgcGF0Y2ggMTIgQUZBSUNULg0KDQoNCk9oLCB5ZXAuIFRoZSBjb21tZW50IHNob3VsZCBi
ZSBhZGRlZCB3aGVuIHByZWFsbG9jIHN0YXJ0cyBnZXR0aW5nIHVzZWQuDQo=

