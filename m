Return-Path: <kvm+bounces-25109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 412C895FCE6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED5A2282D1B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85B119D09C;
	Mon, 26 Aug 2024 22:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EMKPl6uG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D462823DD;
	Mon, 26 Aug 2024 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724712034; cv=fail; b=ZOcjck6CCwlwx6Kdr0YnlpE3iTAXEaTg9lS8KeoVd/Y5Oyv07wFmRbDMItGwg+jpac71e66uckF9epHenW1VYZCct0i1JtyNLA6Y8WHDd/+AZeh0giha5UMOvYmYKXg7QTga8IH+AatZr91eX5IdwVZNDeP+PfqXtVmfivemufg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724712034; c=relaxed/simple;
	bh=SG+Af4ro45Ir3oDBADFs9Cs9XxAopg6tYM5GZ60qUak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RnihDHrIaZDRZhTBMVicZi5MB1NcgaCWX2pcA5rxVoKlpR7AkKK8uPyOc/Ay5WIqLQ8t1U+zGKnX2mHHCl38rN5XavdCDrzDxQaBbJ3/WvozlD8UWhfUspGN+1+3GBIY73q9NDh6kYL0Ai9X8nla/7xdV1LWdasRkrbdZ9r+Fco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EMKPl6uG; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724712032; x=1756248032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SG+Af4ro45Ir3oDBADFs9Cs9XxAopg6tYM5GZ60qUak=;
  b=EMKPl6uGN+nBXcVvON/n0/nz6yVVlUo302h4BZ4mT6zqwvSAyzJYy6oi
   y2em4SAlA/u+AN+62knF9HBcpaI9m9QMHUtSEgP4LcHk8/iRsmahXoW+9
   g8ZTxSgEaDwnYVl5FYy5bEdDf1q93WH7vByWe0ko0D/hhP7ZIZMGJFkXq
   7fzU4whmgKbaBbE87lPn1wM7VY4HvZytMcYvOrtOi3y/fTMTCWHmXZihZ
   OJ0M4135bU0nPjMyg6tVaf6hr7zSsB8dSYus9rs6m/DrOVk0YXLh3LuxV
   fmBRxc+qRt4E35IinQ1xsRMFDGKgWQrN8Eu4lk19ekYXFtOR9c9+KqiFw
   g==;
X-CSE-ConnectionGUID: BbaDWXZIScap2OPT1RSggA==
X-CSE-MsgGUID: KwNgHfRAQlOnCCxcwXdKfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23342624"
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="23342624"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 15:40:31 -0700
X-CSE-ConnectionGUID: CZltnJBPRv+0JfrbGzT7GQ==
X-CSE-MsgGUID: GndRJLHLRSSPGJRH6VZPZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="67338023"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Aug 2024 15:40:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 15:40:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 15:40:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 26 Aug 2024 15:40:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 26 Aug 2024 15:40:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hm92+l6tAG/hmFSnWl9CDQSC4m5s3/w9NE7NLkf5T57I67Jfn00k5hZ1/+aULsad4cAHHyBQrT3q2CXjOkr41bKBR7PaXr3ksGbGWp7e6cviuwqQrsz+FtIQZ0avh7uiUaBmEKRhSNaXxARRaaK8zHSiY1vSfQqNuMcf0Cj/6xdKLp15yNzIQrPCWxZ4UU4TuWCH+PwLxFxRUwV4661Jr0C6tVfUJzLuTrEOo+8c8l5q2R1YhQFY1QNmf3JjwG1ZAZEbINrgQ3HR5pgyMgNndzd6KvZbkyvaCby1jSa49L3W1pcXnMldijisqZKA/A7rnkNXKYUzkdwUnVNgMV4Q+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG+Af4ro45Ir3oDBADFs9Cs9XxAopg6tYM5GZ60qUak=;
 b=tOVBiyudwo/wS6VdC0aU69kas2SJHqeysrrv6mBwVrKP2eHaYFKpSOUC/sEIyaoSF2WuJg+Nf91kE2POUREE/9HZ4sR/7IJmtZ+tv86By6aWLkET81UCeiff66v7N7o5N0CJq1Zhk6perfJOIk5vglbj4eDqPjcPBnWdMiKO3McMQgJIrYhlORBZ1/ZOdSskENMq+spXsiB3HxgOEM9/JU5qqKVrWI8Kc9s7y8H/AFjwRwdIcqxO8FTbdpF7VNYu/KHMxFhzS0XJJR0O/uY/jGcDEVKyscihmWqcNU2NUATVyuKU5t1WareaCCJtpwqmxglF93pJlkDj+aW4ciw+IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6026.namprd11.prod.outlook.com (2603:10b6:208:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Mon, 26 Aug
 2024 22:40:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 22:40:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHa1/rBf1e/y/ONHUu17Yv0cGvYCrIZb5uAgAAKUoCAABHuAIACSXUAgB4WuACAAHXkgA==
Date: Mon, 26 Aug 2024 22:40:28 +0000
Message-ID: <49dabff079d0b55bd169353d9ef159495ff2893e.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
	 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
	 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
	 <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
	 <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
	 <a107b067-861d-43f4-86b5-29271cb93dad@intel.com>
In-Reply-To: <a107b067-861d-43f4-86b5-29271cb93dad@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6026:EE_
x-ms-office365-filtering-correlation-id: 7fe4ec1e-73ff-4763-71ff-08dcc6201581
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RkJpMG43elVRNnFWbVlBN0lvWVBQVXFVZ3gzcXM0aXNYV3krbU5wYmFNejRS?=
 =?utf-8?B?Ni8zeEpFcjg4Tnd6VWpFSmlQQmV3L1ZsaVl4MTVaZVBqNUd6b3pZdlB6Vksv?=
 =?utf-8?B?dGl6ZXh4RkRmemhKMjRaOVJGamgwSTNmT2w4blRPUGFzVThNTDg4WVJZMkRu?=
 =?utf-8?B?R2pxU2U3T0tKa285c25lZUFiZU9NS242ZlJpSnRDODNPWnF2WXVlU3A0MkJh?=
 =?utf-8?B?UlE0bUNZRkNRczJHcFkyallMR0M3cm91M3lnY1N4SXdrL2w1SG9abHhUZTRL?=
 =?utf-8?B?SWNycUl6VG1USHRIZjBRSHhUcFZiN2NwSVRhL2xOeTlqVjZTOE9ubkxrWTIr?=
 =?utf-8?B?RHAxUWN4cnFQM0hyR1luUDJLYzdxUmpoQ1NvcGdSYm5yaDB0TE10R0dCeCs2?=
 =?utf-8?B?dGoyV3MxY3dwNUVhOSsvc2hPVTJuK3V6WjVDOHpuaWVVWVEzMkpLV2JpQXVn?=
 =?utf-8?B?cDhEVm9RdksycHN5cTRWMjR2VnVyZXBHWnJNUW1BWEFIcXNWN2E4bG5qWmRh?=
 =?utf-8?B?TjN6Z1FEajB0d2xYZDlQclMxdVlzUmpNdzVtRkh3VEpMdStYYk9lZVhuTW1l?=
 =?utf-8?B?cHRCRXVoVjg2SVB1YnUzc0hRbkhlSVh1T1R0RjAxbkc1OEIvbTVrOWxVcFpt?=
 =?utf-8?B?YUZJQWU0OExZeUJxSzJRdlJCMHB1bDM2N2x0d29YVGdOM0NrcFBhVW9lam5y?=
 =?utf-8?B?RHdLS21QSXhXSXF5NW1ETHUzSjRJMmk3YmUzaEdOM0pHZWJXd21Lanc5emhi?=
 =?utf-8?B?WlhVTXh0MjBIdlVaRk82V0ZCU1YrY2I4R3JLM3lLVXl2d3BQZmFPdDhWeW5B?=
 =?utf-8?B?NENpMkVBL1NlUTJxT05kbml6NFlRODVONmpRbG5vbFBOdU1LUzVWS2FLVStk?=
 =?utf-8?B?V1dTM3hRNkxhdU40L1dRcXN6dDRjRFE5cHE1QXh1ZEorc3cyVGZOWHdXZ2Jq?=
 =?utf-8?B?WXp0ZVZ4L1VMY2xoVkVjcXRMMVROb1dSMHVRU1ZsQU9DdGdTYWQ1N2t3MnVv?=
 =?utf-8?B?YTREbHROYlV5UGIrcGVPYkk1cThXRXQrUXZvWjg1bmlKM1kvMUtFL1VGZ3cx?=
 =?utf-8?B?QWNOWkVNZmV4NjBYcUNFM1BpUXhFYzBJWlBBTG9vejVRdGkyMXFRVlArNFhl?=
 =?utf-8?B?RmVidldDR1orK05xTVdXbmdkWEErUGpJcDlXbE9FOFdKSlVqWGNOU2tCZnRJ?=
 =?utf-8?B?dFE2bHBjL0tPTVlURUJpald5S2x4dHRxQXR5Uk1Wem11aHpZNm9hbXlKVzM4?=
 =?utf-8?B?TlZNRFlrT2hoUDVLRHVVcFpKNUNiSHMrOU5UZ0VWK3E2RzZIcllrVzFLZUY5?=
 =?utf-8?B?ZVN1NTVEbllXMWhFT2dKWXgxR0Z2aThyZkdqTkcrQnhXLzI0TENWKzdPL0lq?=
 =?utf-8?B?RkpJZkhGbWlIaFU2VVZ0ZUk4c25zSWRUTXpMVHJXaXN1VXJzYmU5Ri8zN0p6?=
 =?utf-8?B?NGdJZy9DK2FTMGw2d0xOYS9yZHlqY2QrWDBIeWhLVDduRGdydUl3UjRTRW04?=
 =?utf-8?B?TkR3SXdwamZwQktGTTVLZGdpVE1Pcmk2Y2xyTHJqQkt4ZlVmZ1RFRTI0UkxS?=
 =?utf-8?B?a25YcS9FL2VwT092QWllNlpQYWtUc0h0bWd0a09ySXNaT1FPeHFXejJYQXJy?=
 =?utf-8?B?TE5oZ2h1U2tyeG93R09yTUJiRHlDRUFPNk9JOW0zNTArKzJYbVF0ZGJ6M0FE?=
 =?utf-8?B?TUdvQndVN1lxNnFKbUI4a0ZycjUyQ2xJSHpTUlhabkxmaFdYZ1Q0U3pDZTdv?=
 =?utf-8?B?WWp1NC80NllwL1MvaWppdVVoWWEvZURWU2hkcTY4eGdjZVc3OUlpbUVta21V?=
 =?utf-8?B?eW1KZWtBRmhKZG8xd2d6ZzRZSkdldzhGVWdQekg5cElnemdGeVVGR0RLcjdL?=
 =?utf-8?Q?142l9/hwDASot?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TS9RVkNubWpGRlNJMjl6QkNZUjFPRVg4aGlOWHZzbmthdnRmZ0k4UEpjTGFW?=
 =?utf-8?B?eWpFc0pFL3g0aldKYTFUN2g3RVZvQTJZbUFETy8vdTAzQXY1SHBEa1Uyc1k2?=
 =?utf-8?B?eXR5YmoyQnNPaVpLVkRxdENmQ050cHVJdk5xSWdkNHIyUVI0VmZHVFpGUW1h?=
 =?utf-8?B?cmRqZkNwYXlCU0ZUbm1JS0lLUFZ0ci9QbWROb25TSkFaV0F0SXFJMmYreXMx?=
 =?utf-8?B?S3F4VEdWd0tXclBCcFc1SVdlRG9TTW9UbmxhR3ZWbi9kdmM2YnVLOWdpWjIr?=
 =?utf-8?B?cTNWQVJWSkVnWWttZWUvajFhMXErdHJPQllTaHBLZHNsRDUvdW53YVpPVVUz?=
 =?utf-8?B?MENkZTJWazFzaVRaOWxJNms1MGI3bHI4Z3pmUmRqRlVGcEQwcWpmQy9CYmNW?=
 =?utf-8?B?cExsYXBrb3BRN1RoWnV4d3ZNREFjTzc1RDVRYXREeUp0WW1ZczJ5aTROUVda?=
 =?utf-8?B?K05BL1lIRGorUzRScElmY2lNWmNWUzd3aEl5YzlVMjkyUTJ2NFRvak95VGlC?=
 =?utf-8?B?OWgrajdhbGg3UHA0cUJ6M3pnZFJQRFRReUI0ZkxPVk82K25YWE5SQXpLMjc3?=
 =?utf-8?B?QUxyeTRDN2RnV0VjcSthYlhJQm1hc3RnTWg1OGZiQ1NOeFJadlpkYWNEYm1F?=
 =?utf-8?B?R3gwRzM3SXIzZUZubzZSMUR3ZnNraVA2ZHdVYzJ6NVBvcUtyc3dvc0RDTlpl?=
 =?utf-8?B?N0M5TFZyaUZuMHpTOWtwM1YwQnNabkFmS2JRYmhMZUFSazB2NlJ5b2FLdzVr?=
 =?utf-8?B?RXJCMFNjRWxxN2JmVEVDQjFpU0lpNk4yVlg0VXp5WTR3R3g4bldJZHF2cmtp?=
 =?utf-8?B?YXNxYlYwRnp0UE1Pd1JUK21ESFRmYjB3QjJtM2RLUStmTWQ2NE1QMjBNRndx?=
 =?utf-8?B?cFY1NDBCMWp3MGdBait1c1l3b3FpWGpNdDhBb1RUUDROMUhoTWdoVm9keUg3?=
 =?utf-8?B?dDlqZlhMbVozS25wa2pkelBVZFN3bjZlYWF2eW1Lc3UyR0ZwdDFIU2QvanZY?=
 =?utf-8?B?ZkdLWWhUbGV0dTVxWGl4VXYzdUcxQ2g2aTFTN0lDeHVMSUJleDFSMW53cC9T?=
 =?utf-8?B?aktTckpIN09ESzhUZXRYY0IrVGc0TDR5UFZTdWxtU3VxZGJhVzFMdTJKai9u?=
 =?utf-8?B?NjQrTkxZR0ZTTW5jUUUrRUJRZkpERm9FZ0liV3djQ2JXUGJDdUQ5WDhGZ0pY?=
 =?utf-8?B?bUN1Z1lCck9QWkVSK3pMdzFmem5MeDdyLzJaUHpFMFRYQWEwL2Q4V3hhMUEw?=
 =?utf-8?B?SXErNTJUVnRONGtGMW1GeTBSTmF6UTBNcTRoK3hUWHBUcHhIVklDckRQWC9C?=
 =?utf-8?B?VHZ6aTFqSUtuYk5vQXhkMlFqcXlSbGVGdnlDNmpWbUl5Q1ZvS1dVTnhPblJF?=
 =?utf-8?B?NWdZcDRaaFJvT2l3ckY5WGEzT0JJREtTeEZYQzhXSVhJMzBZbVZUSUYySkh3?=
 =?utf-8?B?S3V0VlZKeHVEeldURDVsbDlxWlQzcERMZVFWWHc0bkdNbHQwZW1WaDZEeGNv?=
 =?utf-8?B?Q0Y2MGhxTHpHVmJZbHlmR1UrUXI5Q0l3aWRPQ3EvbS8wK003bDFNOHhwQ3hC?=
 =?utf-8?B?QnpjTTNUYUdHSXBXd1p4ZDcyZWJHV2w5SUNBN0tqZ0x2aEVmZmZMaDhKWG5G?=
 =?utf-8?B?WkJWM01uaGxjYUk0ZVlweVVJUjZGeDB3dUtkNmZsQVl3OVNhMmxibFFjUEhP?=
 =?utf-8?B?Y2NjOFNmRCtMNWQ5ZVNUWXl6MEtLenA0TU96ZnpGeEgwK3oyM0NDZitmQjlu?=
 =?utf-8?B?S3RjOHplY2JLcENCZkpRVXUyZTNMWnY1WGNjd3gvUTNEQ29lRGFTNlZSUm9Y?=
 =?utf-8?B?ZEdlV2V5QXdqUkZ2SkdRSFBLMmt0RkdOWWRBK0kyOWlmMG1XRlJLaEJTdkJa?=
 =?utf-8?B?SHhXQW5wdHhldWw0MFBvWGIvWmpNbGZuMzFuVjVZeG90endzc3N4MHVZQ2U1?=
 =?utf-8?B?SHVWbnhibFBmV216ck9BaXZiZVd1NTE4UUQyOFU0U2UrYkhtejRXd05QcWtZ?=
 =?utf-8?B?cjlsTDlhT3FEMWExMCtYRUdaNHV5QXoycXhuK2hqTUJiR0lVTG1oWkJtMGRL?=
 =?utf-8?B?aG1xYmlSTUxiMDdXak93OUVKRFFSZFA5cG1JZlZqeVdCcWpjQU4reXpjSGlz?=
 =?utf-8?Q?w4VVd+JFxNmQ4ptJfOBR01noV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB2C18173F48624FBEEA35ED5CDE40C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe4ec1e-73ff-4763-71ff-08dcc6201581
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 22:40:28.1490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uRurnVk8XQbuILViJRHgYMGJTYTE1SD73Zu5RopxGT7G7TV0L5nQfUJPy5/C+yCjJ55RXcQ71woYddIdyoIJsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6026
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTI2IGF0IDE4OjM4ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiA3LzA4LzI0IDE1OjA5LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyNC0w
OC0wNSBhdCAxODoxMyAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gSHVhbmcsIEth
aSB3cm90ZToNCj4gPiA+IFsuLl0NCj4gPiA+ID4gPiBUaGUgdW5yb2xsZWQgbG9vcCBpcyB0aGUg
c2FtZSBhbW91bnQgb2Ygd29yayBhcyBtYWludGFpbmluZyBAZmllbGRzLg0KPiA+ID4gPiANCj4g
PiA+ID4gSGkgRGFuLA0KPiA+ID4gPiANCj4gPiA+ID4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2su
DQo+ID4gPiA+IA0KPiA+ID4gPiBBRkFJQ1QgRGF2ZSBkaWRuJ3QgbGlrZSB0aGlzIHdheToNCj4g
PiA+ID4gDQo+ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvY292ZXIuMTY5OTUy
NzA4Mi5naXQua2FpLmh1YW5nQGludGVsLmNvbS9ULyNtZTZmNjE1ZDc4NDUyMTVjMjc4NzUzYjU3
YTBiY2UxMTYyOTYwMjA5ZA0KPiA+ID4gDQo+ID4gPiBJIGFncmVlIHdpdGggRGF2ZSB0aGF0IHRo
ZSBvcmlnaW5hbCB3YXMgdW5yZWFkYWJsZS4gSG93ZXZlciwgSSBhbHNvDQo+ID4gPiB0aGluayBo
ZSBnbG9zc2VkIG92ZXIgdGhlIGxvc3Mgb2YgdHlwZS1zYWZldHkgYW5kIHRoZSBzaWxsaW5lc3Mg
b2YNCj4gPiA+IGRlZmluaW5nIGFuIGFycmF5IHRvIHByZWNpc2VseSBtYXAgZmllbGRzIG9ubHkg
dG8gdHVybiBhcm91bmQgYW5kIGRvIGENCj4gPiA+IHJ1bnRpbWUgY2hlY2sgdGhhdCB0aGUgc3Rh
dGljYWxseSBkZWZpbmVkIGFycmF5IHdhcyBmaWxsZWQgb3V0DQo+ID4gPiBjb3JyZWN0bHkuIFNv
IEkgdGhpbmsgbGV0cyBzb2x2ZSB0aGUgcmVhZGFiaWxpdHkgcHJvYmxlbSAqYW5kKiBtYWtlIHRo
ZQ0KPiA+ID4gYXJyYXkgZGVmaW5pdGlvbiBpZGVudGljYWwgaW4gYXBwZWFyYW5jZSB0byB1bnJv
bGxlZCB0eXBlLXNhZmUNCj4gPiA+IGV4ZWN1dGlvbiwgc29tZXRoaW5nIGxpa2UgKFVOVEVTVEVE
ISk6DQo+ID4gPiANCj4gPiA+IA0KPiA+IFsuLi5dDQo+ID4gDQo+ID4gPiArLyoNCj4gPiA+ICsg
KiBBc3N1bWVzIGxvY2FsbHkgZGVmaW5lZCBAcmV0IGFuZCBAdHMgdG8gY29udmV5IHRoZSBlcnJv
ciBjb2RlIGFuZCB0aGUNCj4gPiA+ICsgKiAnc3RydWN0IHRkeF90ZG1yX3N5c2luZm8nIGluc3Rh
bmNlIHRvIGZpbGwgb3V0DQo+ID4gPiArICovDQo+ID4gPiArI2RlZmluZSBURF9TWVNJTkZPX01B
UChfZmllbGRfaWQsIF9vZmZzZXQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+
ID4gKwkoeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPiA+ID4gKwkJaWYgKHJldCA9PSAwKSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gPiArCQkJcmV0ID0gcmVhZF9zeXNfbWV0YWRh
dGFfZmllbGQxNiggICAgICAgICAgICAgICAgXA0KPiA+ID4gKwkJCQlNRF9GSUVMRF9JRF8jI19m
aWVsZF9pZCwgJnRzLT5fb2Zmc2V0KTsgXA0KPiA+ID4gKwl9KQ0KPiA+ID4gKw0KPiA+IA0KPiA+
IFdlIG5lZWQgdG8gc3VwcG9ydCB1MTYvdTMyL3U2NCBtZXRhZGF0YSBmaWVsZCBzaXplcywgYnV0
IG5vdCBqdXN0IHUxNi4NCj4gPiANCj4gPiBFLmcuOg0KPiA+IA0KPiA+IHN0cnVjdCB0ZHhfc3lz
aW5mb19tb2R1bGVfaW5mbyB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KPiA+ICAgICAgICAgdTMyIHN5c19hdHRyaWJ1dGVzOyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIA0KPiA+ICAgICAgICAgdTY0IHRkeF9mZWF0dXJlczA7ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+IH07DQo+ID4g
DQo+ID4gaGFzIGJvdGggdTMyIGFuZCB1NjQgaW4gb25lIHN0cnVjdHVyZS4NCj4gPiANCj4gPiBU
byBhY2hpZXZlIHR5cGUtc2FmZXR5IGZvciBhbGwgZmllbGQgc2l6ZXMsIEkgdGhpbmsgd2UgbmVl
ZCBvbmUgaGVscGVyDQo+ID4gZm9yIGVhY2ggZmllbGQgc2l6ZS4gIEUuZy4sDQo+ID4gDQo+ID4g
I2RlZmluZSBSRUFEX1NZU01EX0ZJRUxEX0ZVTkMoX3NpemUpICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIFwNCj4gPiBzdGF0aWMgaW5saW5lIGludCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXA0KPiA+IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkIyNfc2l6
ZSh1NjQgZmllbGRfaWQsIHUjI19zaXplICpkYXRhKSAgICBcDQo+ID4geyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAg
ICAgICAgIHU2NCB0bXA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXA0KPiA+ICAgICAgICAgaW50IHJldDsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICAgIHJldCA9IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkKGZpZWxkX2lkLCAmdG1wKTsgICAgICAgICAgXA0KPiA+ICAg
ICAgICAgaWYgKHJldCkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBcDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiByZXQ7ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICAgICAgICAgKmRhdGEgPSB0
bXA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gICAg
ICAgICByZXR1cm4gMDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFwNCj4gPiB9ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICANCj4gPiANCj4gPiAvKiBGb3Igbm93IG9ubHkgdTE2
L3UzMi91NjQgYXJlIG5lZWRlZCAqLw0KPiA+IFJFQURfU1lTTURfRklFTERfRlVOQygxNikgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+IFJFQURfU1lT
TURfRklFTERfRlVOQygzMikgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIA0KPiA+IFJFQURfU1lTTURfRklFTERfRlVOQyg2NCkgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+IA0KPiA+IElzIHRoaXMgd2hhdCB5b3Ug
d2VyZSB0aGlua2luZz8NCj4gPiANCj4gPiAoQnR3LCBJIHJlY2FsbCB0aGF0IEkgdHJpZWQgdGhp
cyBiZWZvcmUgZm9yIGludGVybmFsIHJldmlldywgYnV0IEFGQUlDVA0KPiA+IERhdmUgZGlkbid0
IGxpa2UgdGhpcy4pDQo+ID4gDQo+ID4gRm9yIHRoZSBidWlsZCB0aW1lIGNoZWNrIGFzIHlvdSBy
ZXBsaWVkIHRvIHRoZSBuZXh0IHBhdGNoLCBJIGFncmVlIGl0J3MNCj4gPiBiZXR0ZXIgdGhhbiB0
aGUgcnVudGltZSB3YXJuaW5nIGNoZWNrIGFzIGRvbmUgaW4gdGhlIGN1cnJlbnQgY29kZS4NCj4g
PiANCj4gPiBJZiB3ZSBzdGlsbCB1c2UgdGhlIHR5cGUtbGVzcyAndm9pZCAqc3RidWYnIGZ1bmN0
aW9uIHRvIHJlYWQgbWV0YWRhdGENCj4gPiBmaWVsZHMgZm9yIGFsbCBzaXplcywgdGhlbiBJIHRo
aW5rIHdlIGNhbiBkbyBiZWxvdzoNCj4gPiANCj4gPiAvKg0KPiA+ICAqIFJlYWQgb25lIGdsb2Jh
bCBtZXRhZGF0YSBmaWVsZCBhbmQgc3RvcmUgdGhlIGRhdGEgdG8gYSBsb2NhdGlvbiBvZiBhIA0K
PiA+ICAqIGdpdmVuIGJ1ZmZlciBzcGVjaWZpZWQgYnkgdGhlIG9mZnNldCBhbmQgc2l6ZSAoaW4g
Ynl0ZXMpLiAgICAgICAgICAgIA0KPiA+ICAqLw0KPiA+IHN0YXRpYyBpbnQgc3RidWZfcmVhZF9z
eXNtZF9maWVsZCh1NjQgZmllbGRfaWQsIHZvaWQgKnN0YnVmLCBpbnQgb2Zmc2V0LA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgc2l6ZSkgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIA0KPiA+IHsgICAgICAgDQo+ID4gICAgICAgICB2b2lkICptZW1iZXIgPSBz
dGJ1ZiArIG9mZnNldDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gICAg
ICAgICB1NjQgdG1wOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgDQo+ID4gICAgICAgICBpbnQgcmV0OyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gDQo+ID4gICAgICAgICByZXQg
PSByZWFkX3N5c19tZXRhZGF0YV9maWVsZChmaWVsZF9pZCwgJnRtcCk7ICAgICAgICAgICAgICAg
ICAgDQo+ID4gICAgICAgICBpZiAocmV0KQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0
OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiA+ICAgICAg
ICAgDQo+ID4gICAgICAgICBtZW1jcHkobWVtYmVyLCAmdG1wLCBzaXplKTsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gICAgICAgICANCj4gPiAgICAgICAgIHJldHVy
biAwOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICANCj4gPiB9ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCj4gPiANCj4gPiAvKiBXcmFwcGVyIHRvIHJlYWQgb25l
IG1ldGFkYXRhIGZpZWxkIHRvIHU4L3UxNi91MzIvdTY0ICovICAgICAgICAgICAgICANCj4gPiAj
ZGVmaW5lIHN0YnVmX3JlYWRfc3lzbWRfc2luZ2xlKF9maWVsZF9pZCwgX3BkYXRhKSAgICAgIFwN
Cj4gPiAgICAgICAgIHN0YnVmX3JlYWRfc3lzbWRfZmllbGQoX2ZpZWxkX2lkLCBfcGRhdGEsIDAs
IAlcDQo+ID4gCQlzaXplb2YodHlwZW9mKCooX3BkYXRhKSkpKSANCj4gPiANCj4gPiAjZGVmaW5l
IENIRUNLX01EX0ZJRUxEX1NJWkUoX2ZpZWxkX2lkLCBfc3QsIF9tZW1iZXIpICAgIFwNCj4gPiAg
ICAgICAgIEJVSUxEX0JVR19PTihNRF9GSUVMRF9FTEVfU0laRShNRF9GSUVMRF9JRF8jI19maWVs
ZF9pZCkgIT0gXA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZihfc3QtPl9tZW1i
ZXIpKQ0KPiA+IA0KPiA+ICNkZWZpbmUgVERfU1lTSU5GT19NQVBfVEVTVChfZmllbGRfaWQsIF9z
dCwgX21lbWJlcikgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAgICAgICAgICh7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+
ID4gICAgICAgICAgICAgICAgIGlmIChyZXQpIHsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIENIRUNLX01E
X0ZJRUxEX1NJWkUoX2ZpZWxkX2lkLCBfc3QsIF9tZW1iZXIpOyAgIFwNCj4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICByZXQgPSBzdGJ1Zl9yZWFkX3N5c21kX3NpbmdsZSggICAgICAgICAgICAg
ICAgICBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1EX0ZJ
RUxEX0lEXyMjX2ZpZWxkX2lkLCAgICAgICAgXA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAmX3N0LT5fbWVtYmVyKTsgICAgICAgICAgICAgICAgIFwNCj4gPiAg
ICAgICAgICAgICAgICAgfSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBcDQo+ID4gICAgICAgICAgfSkNCj4gPiANCj4gPiBzdGF0aWMgaW50IGdl
dF90ZHhfbW9kdWxlX2luZm8oc3RydWN0IHRkeF9zeXNpbmZvX21vZHVsZV9pbmZvICptb2RpbmZv
KQ0KPiA+IHsNCj4gPiAgICAgICAgIGludCByZXQgPSAwOw0KPiA+IA0KPiA+ICNkZWZpbmUgVERf
U1lTSU5GT19NQVBfTU9EX0lORk8oX2ZpZWxkX2lkLCBfbWVtYmVyKSAgICAgXA0KPiA+ICAgICAg
ICAgVERfU1lTSU5GT19NQVBfVEVTVChfZmllbGRfaWQsIG1vZGluZm8sIF9tZW1iZXIpDQo+ID4g
DQo+ID4gICAgICAgICBURF9TWVNJTkZPX01BUF9NT0RfSU5GTyhTWVNfQVRUUklCVVRFUywgc3lz
X2F0dHJpYnV0ZXMpOw0KPiA+ICAgICAgICAgVERfU1lTSU5GT19NQVBfTU9EX0lORk8oVERYX0ZF
QVRVUkVTMCwgIHRkeF9mZWF0dXJlczApOw0KPiA+IA0KPiA+ICAgICAgICAgcmV0dXJuIHJldDsN
Cj4gPiB9DQo+ID4gDQo+ID4gV2l0aCB0aGUgYnVpbGQgdGltZSBjaGVjayBhYm92ZSwgSSB0aGlu
ayBpdCdzIE9LIHRvIGxvc2UgdGhlIHR5cGUtc2FmZQ0KPiA+IGluc2lkZSB0aGUgc3RidWZfcmVh
ZF9zeXNtZF9maWVsZCgpLCBhbmQgdGhlIGNvZGUgaXMgc2ltcGxlciBJTUhPLg0KPiA+IA0KPiA+
IEFueSBjb21tZW50cz8NCj4gDQo+IEJVSUxEX0JVR19PTigpIHJlcXVpcmVzIGEgZnVuY3Rpb24s
IGJ1dCBpdCBpcyBzdGlsbA0KPiBiZSBwb3NzaWJsZSB0byBhZGQgYSBidWlsZCB0aW1lIGNoZWNr
IGluIFREX1NZU0lORk9fTUFQDQo+IGUuZy4NCj4gDQo+ICNkZWZpbmUgVERfU1lTSU5GT19DSEVD
S19TSVpFKF9maWVsZF9pZCwgX3NpemUpCQkJXA0KPiAJX19idWlsdGluX2Nob29zZV9leHByKE1E
X0ZJRUxEX0VMRV9TSVpFKF9maWVsZF9pZCkgPT0gX3NpemUsIF9zaXplLCAodm9pZCkwKQ0KPiAN
Cj4gI2RlZmluZSBfVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBfb2Zmc2V0LCBfc2l6ZSkJCVwN
Cj4gCXsgLmZpZWxkX2lkID0gX2ZpZWxkX2lkLAkJCQlcDQo+IAkgIC5vZmZzZXQgICA9IF9vZmZz
ZXQsCQkJCQlcDQo+IAkgIC5zaXplCSAgICA9IFREX1NZU0lORk9fQ0hFQ0tfU0laRShfZmllbGRf
aWQsIF9zaXplKSB9DQo+IA0KPiAjZGVmaW5lIFREX1NZU0lORk9fTUFQKF9maWVsZF9pZCwgX3N0
cnVjdCwgX21lbWJlcikJCVwNCj4gCV9URF9TWVNJTkZPX01BUChNRF9GSUVMRF9JRF8jI19maWVs
ZF9pZCwJCVwNCj4gCQkJb2Zmc2V0b2YoX3N0cnVjdCwgX21lbWJlciksCQlcDQo+IAkJCXNpemVv
Zih0eXBlb2YoKChfc3RydWN0ICopMCktPl9tZW1iZXIpKSkNCj4gDQo+IA0KDQpUaGFua3MgZm9y
IHRoZSBjb21tZW50LCBidXQgSSBkb24ndCB0aGluayB0aGlzIG1lZXRzIGZvciBvdXIgcHVycG9z
ZS4NCg0KV2Ugd2FudCBhIGJ1aWxkIHRpbWUgImVycm9yIiB3aGVuIHRoZSAiTURfRklFTERfRUxF
X1NJWkUoX2ZpZWxkX2lkKSA9PSBfc2l6ZSINCmZhaWxzLCBidXQgbm90ICJzdGlsbCBpbml0aWFs
aXppbmcgdGhlIHNpemUgdG8gMCIuICBPdGhlcndpc2UsIHdlIG1pZ2h0IGdldA0Kc29tZSB1bmV4
cGVjdGVkIGlzc3VlIChkdWUgdG8gc2l6ZSBpcyAwKSBhdCBydW50aW1lLCB3aGljaCBpcyB3b3Jz
ZSBJTUhPIHRoYW4NCmEgcnVudGltZSBjaGVjayBhcyBkb25lIGluIHRoZSBjdXJyZW50IHVwc3Ry
ZWFtIGNvZGUuDQoNCkkgaGF2ZSBiZWVuIHRyeWluZyB0byBhZGQgYSBCVUlMRF9CVUdfT04oKSB0
byB0aGUgZmllbGRfbWFwcGluZyBzdHJ1Y3R1cmUNCmluaXRpYWxpemVyLCBidXQgSSBoYXZlbid0
IGZvdW5kIGEgcmVsaWFibGUgd2F5IHRvIGRvIHNvLg0KDQpGb3Igbm93IEkgaGF2ZSBjb21wbGV0
ZWQgdGhlIG5ldyB2ZXJzaW9uIGJhc2VkIG9uIERhbidzIHN1Z2dlc3Rpb24sIGJ1dCBzdGlsbA0K
bmVlZCB0byB3b3JrIG9uIGNoYW5nZWxvZy9jb3ZlcmxldHRlciBldGMsIHNvIEkgdGhpbmsgSSBj
YW4gc2VuZCB0aGUgbmV3DQp2ZXJzaW9uIG91dCBhbmQgc2VlIHdoZXRoZXIgcGVvcGxlIGxpa2Ug
aXQuICBXZSBjYW4gcmV2ZXJ0IGJhY2sgaWYgdGhhdCdzIG5vdA0Kd2hhdCBwZW9wbGUgd2FudC4N
Cg==

