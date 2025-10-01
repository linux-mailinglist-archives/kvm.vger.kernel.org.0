Return-Path: <kvm+bounces-59368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FF6BB1B42
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 22:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 668D416DA2F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 20:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88A62EE5F0;
	Wed,  1 Oct 2025 20:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mGkIdLdy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1882C032E;
	Wed,  1 Oct 2025 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759351796; cv=fail; b=XlnqyLjG/JVyXG0KDaZF2PnBrlL6utUleHhPQn1d5x4qk1JyKsSdzFHGmIPKd5ROjOFkx+ZVBxilmvYCe/liCfLFBbjJFf7bVAt7ZoNIubfh32agOgzmSKXWE08KKghFOIYiAku1UsuL1qwUB6uQs9vMYyEGhBZjMpXckdVA5IM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759351796; c=relaxed/simple;
	bh=MrzlQ/K6YfDfJcOUwONsfapW1fhnubDpMCsGFzTbIxM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YIFHWS1cXYDdEM4re157MdyfYEUAK7JojqVxKAIhF6hSQbC/vDjkf+2tswV/L2fep7IijJqRmrbh3OsW54iqUS6Sz3f6OrN4teZc/HFSx4PhdTnga10wioFm+KYsFj/ugCyOR1jqksmUR4f8k11cr86Uay4ZVinS12w4yGu8tRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mGkIdLdy; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759351795; x=1790887795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MrzlQ/K6YfDfJcOUwONsfapW1fhnubDpMCsGFzTbIxM=;
  b=mGkIdLdy47lQTJST1OR4oamcvN5IZCVz5IANWopIJ4jplujt6WB3O9T1
   gh4/yrw/cLK6dorXmXAbj9xf118LXtpjcUB42jJ2+c+GQ+qxk+rP4jzDf
   Zg2lRe31UDF9YGUhBUX1OUU0BDJugQLUfUpTtGozNTNDCzZNXEnw+ImzG
   feU8TtScemvBGBaz2jQ/XunwFfh55wB715S69a/cBe2+XpLga/XI6Psy9
   yRbzN4eYvPlwVa3LwiolIoeC0SAoee6tysmqIshT/S/qH4eoHqiNbtcc2
   dOrxG7TIK92UySc1eykVql3miJmTNId66EYAjnZGwR7AUhQa/WisMJNc5
   g==;
X-CSE-ConnectionGUID: t2pH4GBGROix/0js7mzwKQ==
X-CSE-MsgGUID: pCikK/6BQSGs9rnYj4FEhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="71885012"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="71885012"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:49:54 -0700
X-CSE-ConnectionGUID: EVtCLZKLRtCzaq2zSfo26g==
X-CSE-MsgGUID: 0mj0f1A0SKSk3UPBJPyr7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="184067533"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:49:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 13:49:53 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 13:49:53 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.26) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 13:49:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVHIj5h+NmQudM8fI6PFd7ei03vynUXTRCM7vTLXDXvDtnx2AjB4fTglVCkfMicLb2AV/cotgzlalw805ta1Y9RUIzPRgoed0QaBYiscHyn/qsafMAO3nbEXojYFFf+76MyzFekcuNdpP9qrDbxQzOVuWwNOj2Eiy9UIB4Cda5Yjj/btEiH09uddrCbo5rSbF6yG60xZu1mxsCY2hLQmQwBhZWVbwrkxUSnc5fLKa2gkfYfX1bBOOOzbg3cFx4pRundSgybiyJGc3vogOWgTWKiREvpvqkD8i+fO+U+AucKcsfoJaFrThxi5cQK1jSPkeLw0JeJdvQJ+6SkJipjweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrzlQ/K6YfDfJcOUwONsfapW1fhnubDpMCsGFzTbIxM=;
 b=W2Ty/nY1Ya6Q9S/C2CRUWjxoMhyz3V9YB/A10cBeXFu6zo5T3fSrlJqU5k17MOHOA0qvL/q/W3zhJUnyJPC+jY895eUMi/ZXasOj03yyOKIddEBhgYkca+dNHclsnmh6FWgO+1Qe6dPPqukb7uwOIWjrX/FLmZZGyzM9957dpeNnoFUtu/dTilED7GF2mNW6MV0TwRNES42gecRo1W1Y6l2YbeHlgr4Kk7FIyI56KVZtxYA6bA3v8gqR/wUJvXutLfvdGCJ+YN6xIPNsDzWLQhUe29vmv+v9UM6NnJKfgpaAl9+gnB+rULdcS6t33/kKvc3udwC+l2cYLIbM1SUDSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB6572.namprd11.prod.outlook.com (2603:10b6:303:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Wed, 1 Oct
 2025 20:49:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 20:49:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0s1whGFHeVUeSuikKt1/NBLSaGz4AgAZuegCAAWNMgIAAI4YAgApzb4CAAKnXAIAAi7KAgAAebgA=
Date: Wed, 1 Oct 2025 20:49:49 +0000
Message-ID: <2e0edb645393e2c75d4133b67706d2902fd51f3c.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
		 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
		 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
		 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
		 <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
		 <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
		 <ca13c7f77f2d36fa12e25cf2b9fb61861c9ed38c.camel@intel.com>
		 <894408f8987034fcbe945f7c46b68a840d333527.camel@intel.com>
	 <404c3dddef3025537d2942386ab0ea0f72ab9dc3.camel@intel.com>
In-Reply-To: <404c3dddef3025537d2942386ab0ea0f72ab9dc3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB6572:EE_
x-ms-office365-filtering-correlation-id: c36e96e6-d608-4551-c1e7-08de012c1065
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aDV1RTUvaXp3WW5SeGI1YUMyUDY5R0ZTKzhxWGxkSjZycytCMjR1NnZKczk3?=
 =?utf-8?B?dkIwbUs5Vkx5Q0V4b0VCNGFtRnVVRXV5U0UxYnVsR1B0UWJ3OFR1OHZiYVBv?=
 =?utf-8?B?amRDQjBQVUtNNXIvTkdQYzVuR2c1QXRweGJiSGdZNnZXcGpTVURLLzNXZUJm?=
 =?utf-8?B?QVA0SENLWGJjVFQxTzhzenRuOFFiSFhKWnhjRFBJYlZsMTlmUDllaUZWOHI3?=
 =?utf-8?B?T2xjKzViS3Y2azZ5Y1FkTkYvM3d3U2UxS2tiVVRFNks3ZmpyNnUrY3hLY2Nu?=
 =?utf-8?B?blJUVW1WQjA4dnhxemhjTzc5NkRyY3h4Wi9zNGxPTDFtNlZFTVl2VDhrb0RY?=
 =?utf-8?B?V2JWTjZCMHVJVFBMOWlnUTZKUFU5VVhUOUFKdWZDd3QyeWtzV2pwTnZOemNF?=
 =?utf-8?B?d2ZnTWQrQmNkS0pBaDc5UEJFaWk5Y3U3d0dkTFdZTUhpUVl1L25sOUkyTmdi?=
 =?utf-8?B?MHRXRDhjTEVadnU5SUlaaXdaQkxweWtnbnJJQzFRZ1YvOUlFckQzMnNXYnlT?=
 =?utf-8?B?aGt1dXVvMW94dVNSNGhSTHlrT0pZL1hIeTZHZmJFdFM3QUFmNDVidUZsSFVv?=
 =?utf-8?B?ODZwemVVdndRRnJlV3lyMjZiWjU3d1BFR1ZvcmpnSEF6Rlphc0kzd3pnS21n?=
 =?utf-8?B?U2pyZE1hNDQ5QkJFNnNjR3Y4YlpoZmxOdS80ZTRObHpobnVXNUFiVkE1Y3ky?=
 =?utf-8?B?VHg3NHFDd1lZTXBWVzcrbDk0ZytEUXZvamF4Mlp6Nm1ZbXhUZzJOR2E5RHA3?=
 =?utf-8?B?SUNvMEQ0OHlwdGlYRFBHZFFTUGJlTjhjZE8wS3hQL2xEK0RWQXNwMVdIa25F?=
 =?utf-8?B?OHNDM3l3VnpKM3VWK0JRYVJrWktxN3E2TkhSSHNJNEZac01pRm5UTFNNbmFZ?=
 =?utf-8?B?TzVGWkpOYW5LRWg1OTVEMzdqbkFsVmlLbWd2R0gyVVFjY1UzL3UxNFZaeHJu?=
 =?utf-8?B?L2lvaTR3T29NVFdyTkVwLzdYZk5QYklpbGNWbHRKSUY4dHdZMmwxOE1udE5C?=
 =?utf-8?B?dnZGZnpFckxERzE0cUF2eXFzK2R3RFVYdkZMSnh3RHhVVjkvZkFjbWMzQ3Jw?=
 =?utf-8?B?V0E4ZDNxdTBzR2QyajJtRDcwcDJ6NWlmVk1HRnErOGF0N0pTaE5WbVdHaWhQ?=
 =?utf-8?B?WVlHcEJReGszVFRMRDVxUWRJTmNvSFFSMWZ5QlVCVzdINXg0YTZCc2NKSFM3?=
 =?utf-8?B?WUQ4TzA1dUY4b2Q5eTRNNzBSNTUwS1U5TTBTRTZwc0ZPcFE3TXFwdjMzalBs?=
 =?utf-8?B?UitqdWFBVHBNSVBxTWp5cnFvSVlwTk54SFRxNHA4dmJybFo4bExBZVVrS2Fq?=
 =?utf-8?B?amRhdkhIa2FsNW9nOW4xcndST1JIUkNNR1BWU05nYzBHbkJXaUxTVjNETVhs?=
 =?utf-8?B?a0k3L1huQWEwTUdybDN1UzQxY1FycHFldkttZ1p3TEpFeUlhYjBNSHVacW5Y?=
 =?utf-8?B?SjU3MmduUWVqejcvakM3WlNiclZubExiUHhQZlBwWkRzNWlIaTRzOTdKN0RN?=
 =?utf-8?B?VC9BT0JmQlcxUlpQWGY2MVRmaU9HYzI1d0dqcWxmZ0xGQW5ueDgxMXFrMWwx?=
 =?utf-8?B?bnJadHQ3WEM5NUU5OXpsVVVFaGRJZW00cklLYzluL0ZhUGcrQWZsRGtlcFpZ?=
 =?utf-8?B?dDZMV2RPWUNrMU5Zd1lrMTEvcXFhdTJvcGFHakhKZ3pzbm9aV1JHRnFDUGts?=
 =?utf-8?B?amhDYUNqRGFPOVNtREpZWFB0a3BoL0p6cHkwQ1ZuNmJWRVB6V3BIV011THZW?=
 =?utf-8?B?eFE2ZEZaSC9iWWRpZnBnQzIvNDlGUnQ2WUpnbmtLY1RIL2taSXpWazhpeWth?=
 =?utf-8?B?cHZ5NEwzVDYvS3hKdHdSSDVkQ0JSS0V4VUdmaTNHZjc2NVBucldqK0ZCeWVF?=
 =?utf-8?B?NWdxR2lzQ1FuaWxFWkFRdGtIZmUxa0Nzc2xDV1FORTg0eGF5SUtLV0dJRURi?=
 =?utf-8?B?cFpDZEJ0VzBydmxCNEs2WUhEeG1IbEo2V2RhTFFDQnlma2ZUdHdjMGt0ZGNk?=
 =?utf-8?B?WHIrdFM4dVFZVnNjTHBCTWphRDNvY0JIdDE2bjFrYmlIeTFIODkyUUYrdUxY?=
 =?utf-8?Q?LFs0SW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWpyQXFYYlc3RWV0K2J1US80aGwyT2pHRWFvRU1sUWUwYk9oRWdDU3E0Lzl4?=
 =?utf-8?B?RGFBclZJb0hzTjJWdnVtK3JtS3hMWTRBN2VmL3cwQ1FJaDNWWGxYYXV3elVI?=
 =?utf-8?B?V2s2Ty90WE9wWGpmdFJURVNJNmd5RnIvNWsvZ1gvTlNWeWZ2L1FkbTFEOEw1?=
 =?utf-8?B?NEVYaU4wU2ZlVWl5UjVZanNCb1ZHMkl1ZG9DcFJlN0NwRlBIamZ5ZngvOHZo?=
 =?utf-8?B?RFhheXBpRzJGMW1pbnhIWHNjSjI5WmhhaFlzV21PNHU4SnFTbDEzcXYwZ1NK?=
 =?utf-8?B?cFNkY3ZPeUZaU2tmQzZmMVFlWXZLOG0wSS9Rd1dhYlp4NTE5TEQ4OUhBM3BM?=
 =?utf-8?B?QWNJTnJicjhzUGxpZ01SdnpDeVVTYzlyU1h6dDlkRE1TWCt2ZmxmcWl2MDhL?=
 =?utf-8?B?UVJTSkw1VlFqRWlyZ2pWdW9pamI2Nno0YklhN0MrUUpoSE5DTzdXSkpxa200?=
 =?utf-8?B?WU1naDh5RitURGNYak40anVnVEpFTXQ2SlJxVzhOcVRLMVhVUzh6bzJSQS91?=
 =?utf-8?B?NDAxYW1EQnRmVVZaZlJBcEFXQzVmWnVEckxySGI4bGNSS2gralpTL29CMXp3?=
 =?utf-8?B?MnRYNkZRSkRTSHpPVVhmdEpkM3lPeXVxSVlFbGRDa2wwa3FZaDNKTndoa0xU?=
 =?utf-8?B?RjR5UVdpY1FUU25GY1ZkYU42NE8zVjZGTkttRGE4RHBZaHVXQzVzV1l6Nklv?=
 =?utf-8?B?Q0dHVDF2SGpJVXl0WHgzaWdQTzVSWTArNjJ6MmZMeEEzU0pXTEdZSnJ1dHl5?=
 =?utf-8?B?WFpMeW5mSEJGZGF1Y3c1MGtTZkpoTW03SFVNSW05K2lNMFc3c3dpYzNNV0VM?=
 =?utf-8?B?UHl0T0w1R0Y1WkdJQWw3QmlYZXhlZkVDR1hoaHJvNWdxQU1hZG4xZVRCNmpl?=
 =?utf-8?B?eWhJZkttYUFHRi9tVDZjeWJneXpkMDdZWjdlanNxUlYzaEw3MkxaSThTRkpt?=
 =?utf-8?B?V3lhaHBLRjNWRHVRbFJCQ2xsM0JjTWxMblIwT21jN2ZKNDZ5YXViMzVxNVVU?=
 =?utf-8?B?UkVDUXpmWW50ZDgzTkNHSVZETnhQR2ZQb2JISjZabzFCZVdCNmtHKzFlS0Fn?=
 =?utf-8?B?WkdXVVk4ZFNaVFg2ZVd6MW5DRUtUcXFYc1pqQVdlSFc2OTBxSml3RVVMekJY?=
 =?utf-8?B?YkVpVjJEZjd3aFF5V0QwbVVFWFI2SEtGcXpCN2FVSnZIMGVhT3VyeFptMlda?=
 =?utf-8?B?Zzh3NlhnUUtDRTc5MW9pU2JBNndqSGFieDFyUzZ4N08xU21xakhqTjF4L2dt?=
 =?utf-8?B?a0ZvZElnQmVTL1FkMXNZY3ZTYzFwbXRsclRwUUpUVmxheE5aOTZsdUpBaFRj?=
 =?utf-8?B?Z1hYaXU3WDM4dk1EbEdLMFhqakxuZGJOcTUyQ1AxVmxDZE9iQTlOcFE5cSt4?=
 =?utf-8?B?SjBPYUM5M1dFZHZVY2VzV2xJZ1dNaVZ4dFBIUTlTMGpmdVJYK0FvVzkrMFN5?=
 =?utf-8?B?NVBFK2QzL1VXOWc1ZjB0anJQanVDbFVlWG9wejVDKzVMNm43SjNrWmdZYTU3?=
 =?utf-8?B?d3JpNFFtbzRKTTl1Ni9WV3dUVWExaFBlWDlWdHFSRHZMdTJvQW50QUsvV2o5?=
 =?utf-8?B?WkdKQVB3QSsrdFNXcG5HVzNnaWwxUWRRNlZBVFJHczFpNVZQWEttbkZMc0tG?=
 =?utf-8?B?U0Y3ZnJHb1lkQ3VjY0VnUDUyRUQxMFdIWXR6NUwzbXAyd3g4TWNLSGtQSkt5?=
 =?utf-8?B?THNsRDJEOS9NZDdENDdMT2N4WFZzNkFjQ0hVczVpcVlkWkhHZG9vWHBjdnJJ?=
 =?utf-8?B?UXBXZG45cGJkd2lHcExxa1Yya1Rkc0s4bitiMWJkd3B6aGVUYmlVZHEyN3ZE?=
 =?utf-8?B?WkRnUHhWQnpVM1RqR2Frb2phaHozNEdNUHVXTmpKcFd4UTU3UFFCOW0wTThU?=
 =?utf-8?B?emExNFhwN2d6b0FUcjA1RXV0YjFXT2llT3doeEI3SjM5VW1ySEJrSVNhbnQw?=
 =?utf-8?B?SE9WcEJ2TEZFTVVocU5SRGcrUmNDcmRKNDhWUk1LWGIxTk84Mmx6eWFhaDRr?=
 =?utf-8?B?RDlRTEdqbW5lcmowM3VZaUE1UFM5d3FZckw5bmxORjByYS9rSytVQmxJVlNF?=
 =?utf-8?B?Ti9rT3lZYWpYNkV1T0NBUFdYdXlLd01yaWFvZGpkdzdMTTR0dnBhRmN6aE5q?=
 =?utf-8?Q?x/09vhsgTqJJHHxgmH2SBrZkn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29C50CA48BE80A40BE5C91146F2B96C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36e96e6-d608-4551-c1e7-08de012c1065
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 20:49:49.8274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PMoVk1QeCGBQ0apD3U017kgaTTh/a0xAki7JH+txF60LIt99zq2ZXET8evV13j1isXW8bj6HY/JgWpKrq5tDPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6572
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDE5OjAwICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gSSBndWVzcyB3ZSBhcmUgcmVhbGx5IGRvaW5nIHR3byBzZXBhcmF0ZSBjYWxjdWxhdGlv
bnMuIEZpcnN0IGNhbGN1bGF0ZSB0aGUgcmFuZ2UNCj4gb2YgcmVmY291bnRzIHdlIG5lZWQsIGFu
ZCB0aGVuIGNhbGN1bGF0ZSB0aGUgcmFuZ2Ugb2Ygdm1hbGxvYyBzcGFjZSB3ZSBuZWVkLiBIb3cN
Cj4gYWJvdXQgdGhpcywgaXMgaXQgY2xlYXJlciB0byB5b3U/IEl0IGlzIHZlcnkgc3BlY2lmaWMg
YWJvdXQgd2hhdC93aHkgd2UgYWN0dWFsbHkNCj4gYXJlIGRvaW5nLCBidXQgYXQgdGhlIGV4cGVu
c2Ugb2YgbWluaW1pemluZyBvcGVyYXRpb25zLiBJbiB0aGlzIHNsb3cgcGF0aCwgSQ0KPiB0aGlu
ayBjbGFyaXR5IGlzIHRoZSBwcmlvcml0eS4NCj4gDQo+IHN0YXRpYyBpbnQgYWxsb2NfcGFtdF9y
ZWZjb3VudCh1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwgdW5zaWduZWQgbG9uZyBlbmRfcGZuKQ0K
PiB7DQo+IAl1bnNpZ25lZCBsb25nIHJlZmNvdW50X2ZpcnN0LCByZWZjb3VudF9sYXN0Ow0KPiAJ
dW5zaWduZWQgbG9uZyBtYXBwaW5nX3N0YXJ0LCBtYXBwaW5nX2VuZDsNCj4gDQo+IAkvKg0KPiAJ
ICogJ3N0YXJ0X3BmbicgaXMgaW5jbHVzaXZlIGFuZCAnZW5kX3BmbicgaXMgZXhjbHVzaXZlLiBG
aW5kIHRoZQ0KPiAJICogcmFuZ2Ugb2YgcmVmY291bnRzIHRoZSBwZm4gcmFuZ2Ugd2lsbCBuZWVk
Lg0KPiAJICovDQo+IAlyZWZjb3VudF9maXJzdCA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3Bh
bXRfcmVmY291bnQoc3RhcnRfcGZuKTsNCj4gCXJlZmNvdW50X2xhc3TCoMKgID0gKHVuc2lnbmVk
IGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChlbmRfcGZuIC0gMSk7DQo+IA0KPiAJLyoNCj4g
CSAqIENhbGN1bGF0ZSB0aGUgcGFnZSBhbGlnbmVkIHJhbmdlIHRoYXQgaW5jbHVkZXMgdGhlIHJl
ZmNvdW50cy4gVGhlDQo+IAkgKiB0ZWFyZG93biBsb2dpYyBuZWVkcyB0byBoYW5kbGUgcG90ZW50
aWFsbHkgb3ZlcmxhcHBpbmcgcmVmY291bnQNCj4gCSAqIG1hcHBpbmdzIHJlc3VsdGluZyBmcm9t
IHRoZSBhbGlnbm1lbnRzLg0KPiAJICovDQo+IAltYXBwaW5nX3N0YXJ0ID0gcm91bmRfZG93bihy
ZWZjb3VudF9maXJzdCwgUEFHRV9TSVpFKTsNCj4gCW1hcHBpbmdfZW5kwqDCoCA9IHJvdW5kX3Vw
KHJlZmNvdW50X2xhc3QgKyBzaXplb2YoKnBhbXRfcmVmY291bnRzKSwNCj4gUEFHRV9TSVpFKTsN
Cj4gDQo+IA0KPiAJcmV0dXJuIGFwcGx5X3RvX3BhZ2VfcmFuZ2UoJmluaXRfbW0sIG1hcHBpbmdf
c3RhcnQsIG1hcHBpbmdfZW5kIC0NCj4gbWFwcGluZ19zdGFydCwNCj4gCQkJCcKgwqAgcGFtdF9y
ZWZjb3VudF9wb3B1bGF0ZSwgTlVMTCk7DQo+IH0NCg0KWWVhaCBpdCdzIGJldHRlciBhbmQgY2xl
YXJlci4gIExHVE0uICBUaGFua3MuDQo=

