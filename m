Return-Path: <kvm+bounces-12498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3EB887054
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3741D1F23F36
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 16:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22245A4D5;
	Fri, 22 Mar 2024 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BL3p2ZIC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7FD58ACB;
	Fri, 22 Mar 2024 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123613; cv=fail; b=oVtAXGTHfPs5O9tHXtSdLovVKOoTqlet9qwC0keDdQG4bckegLhubmNZ09GQDLzw7/3BkEZLsBtpWTsdTEItSta5opwIHFYNVWBUixb5eHmestA7ii6j5jd24dizxpYAIdcRvDFqZMYWf/DI5Z6Dj2zn7WaC8bUKwAGSdSlL/0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123613; c=relaxed/simple;
	bh=UB5s49/ArzMK6fbFTS5lawNlR8YQBdQjdsTqAoe9T1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d8ZmfyWDLeXQtxi7DxRMGADqNgXZ14Rc1FMgSlISJluZsYcrIBfk6TzK4LWI/K//uj66v4Ns8xbJQAHONrduvXcirNHV8Ii90vdYoSymHTeVIN+Y5FstsdHQ/q4RBSih6J6i+y1rIvbiBsweBpXs8sRujg0NiDitCDl+PvZTtqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BL3p2ZIC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711123612; x=1742659612;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UB5s49/ArzMK6fbFTS5lawNlR8YQBdQjdsTqAoe9T1Q=;
  b=BL3p2ZICBAznoZMj3JxvcNUiEr13a2ACFiNek7qHxHNXFB70WtWAB/tD
   UUjjd2AEdonUfqUd10jAF8k65BKF+B6Z/9yAfppVGsplWdbeVGB9Pa7R+
   buLNymIv0OyR5hjSfD1/IQp/tQ9mMHfyV0p7oFgZg/86/GpVyLWOZtEWT
   prKu0ymOLJUX20Xm3i8AaN3kZrB3QnEIN+8k4aMDIoPCMaBjMmYlhwsc4
   6v0u+4X519fQkN36DhlZ03Zl+J0BkR0AEM7MOtp4FKlhJ62HDFkQHz78U
   QkmiNANZdnRGzSEyaybBOIOvaoWafsrE/YC8CrAedJj6dCE2r38XsWRVr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6034984"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="6034984"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 09:06:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="19649658"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 09:06:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 09:06:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 09:06:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 09:06:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 09:06:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gh/l+tVyVxOOO6VOcwBs1J85V7gofl3pOwCiKynu+NLbxTkSxyxCMQAEudVaCW5UDx+Lq7HOxL3MfaD0IxZMVazIlGj19Cg/Eo6Lyytvddvd6G0PXLWwyO5QhXCkbfUyP2rGH5Y4mdGx/ol/5Yb/RTKJfmQnwGWPVfqjnyRSKiv0IzEEvDgRoKMvg54NIApn4I4oLsCzF4Rei+vvFqhmwl2oLuIiFjQyy6+aH59lqfBNZU+5/XxYPOlp0J2TdELGwzjgdBmqdOWgqBXKuhl3N9cFWELVFK1wW/j/sqAAE2Uw7a8ZoFh2pHfA3E29y1bE3GvO41pW6k4JYZ/ReFB7Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UB5s49/ArzMK6fbFTS5lawNlR8YQBdQjdsTqAoe9T1Q=;
 b=A8U6dP2xttu5Hwbxw2663V9f42Y/ApIwy8vTtRAl241wFN9Paw6b2c2zdVm4ZNB+6hCp1L+Ebu7L19GgQtQ6cuSIQwi1vEJTQy84Ca7lfLuFnEXSJ46XVqV5ErEEBhz3iVxARAdqMToJ3oO8YkZwNvMhy3AqsNzf+R0wF4m714mU43aZjy1cQ5i8IqQRefuU2fVCe7SnbEPkez2Nn+y2wk0LJ3lbM7KVoP5xQkfKvqYcEiKTZipew2OIuh+FAWnH3C/8vnegbNYT+JPXfG55NwDRPT61VDBFK+1ymnXxIH/ITlJKK6RNX/WuuLpWCX/hTyuMvEOCmMIErJ6ununSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7104.namprd11.prod.outlook.com (2603:10b6:303:22e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Fri, 22 Mar
 2024 16:06:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 16:06:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHadnriF1ZBxh+AQEWxyxeO2jbjmbFC3WOAgACFwQCAAJXAgA==
Date: Fri, 22 Mar 2024 16:06:42 +0000
Message-ID: <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
	 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
In-Reply-To: <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7104:EE_
x-ms-office365-filtering-correlation-id: 099a5e97-3009-4f50-6420-08dc4a8a108d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZflRBAywFMT9vXRJJ3l3HPvch6b7GjGZnHA5zQ2l3a83uKZrupiG/HRRn1t7Sh/+OO7bAgEkjoHK7BFXdJG8GWtSSsumXJYzc8ISZ9nvUI213fOoDlLR7SqErQkVJO6qfF5llwcEvArL8Qq5KccIVxa5yURayYCJ18Sgz/Pp9oMSCJ/JFnqFvaEZmjG2KSqJJF3qyhNf3FE2a0a+zLoK0TH2jce399E1uiUCUXk4maDDCzIgDLwt/ixnJJW9tad86OdP44R606DarJMAjnTFmY/yEV/SU9auxMOQDMTNbd3/GZLa29IxJTg+LmV5Tge5TXalDtoEHhUbHusDtSr0Vskf6JUO0TsPHJCR7IKT+yDw+bnr9EWiU0PtYlMdafARN/gmoFta6ZNfGcBPgvAMfskyISOOBrrQVSci/rb2Y9tro/SOf1d//H23nSPp/8ST1ubL/lmFw5NBUijKDFnOsddU1Vv4FHCnwY3RtMl+nT6N0vrPafKggfj/JKI9Cl0Qj3xptDd3GPA1ju/UBjk36AylurLtAqdH6zNuTVUCNfB87VpcwPD+wWiP7eg1W+ZpUJAn23fSAYEsZ1vyiJDqHe7zaC7Hp2LAAT4286654A9s0RSK3VVeYgiHLmjqSbRZXyU8lNkyeBsslQgYLxGrxk1zZ7QajKfZuHN26zMbUM1317xz3gORKQpQ+uMIIwZ12eWzvJ7wlm9O9haLiQDa+oIn7DjF+Ts67QQP8dZ9Rac=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGNxZ1F3NFNqR0djM2JOLzRQcEMwQ3JkaVdnT2ZwTmtWMGFSZ1RzelJIVHBs?=
 =?utf-8?B?cjNaU284RXg5RXlJVXlwWGR0V2QzSWhRdmdnN2pJbHU4UEEyRlZKZFB1Umxj?=
 =?utf-8?B?akg4NEVCZHVxbkRUcHp6VFlyL2VmRlNHb01ySVBMc0dSSHRldHNSL3BRNGs3?=
 =?utf-8?B?eFNuRW1QNFgvNWNRY0M3Sk9oWktldUoxVUhJMlhHUGovdjFUcWtqOE00MnpL?=
 =?utf-8?B?Rm82T0RucmJzNEhxVlhYUGwySzIxQU5YRHdOMGYxVWFHaXJsdDlDejRqazBF?=
 =?utf-8?B?dDhPZG41Q3RjWWJSZDhLT2hkYkxibDZWa05pZDUwa3ZpVW9uN0NpYlNXUXdt?=
 =?utf-8?B?Ym00VnF1cklwMUF4cWlGdUVkVHdTU0h6bU5wS3pnQTh6dnp4ZU82dEpnd1hz?=
 =?utf-8?B?STRiTmlqelBQSU1DVzd6NFAvMGU4QXQ0eVErS1hZbGM2S0ZGTThFdVFIWGd4?=
 =?utf-8?B?bzZQZklyV213UWFIT0c1cUVOMFdub0oydU5GOEVYVW1YZnM2VzQ3RTA0b1JE?=
 =?utf-8?B?NG9ZM2J2d3hSNGtNeFMzUk0vVDF0aFhEdEY1UlpaVlhOcnpzYzNuVThjYk5L?=
 =?utf-8?B?dkd1YTZhdkt4a2NpSDM1WmRXZzJ3ZSs3VUtnS05TR2dRSUJwY0prdXczc1FW?=
 =?utf-8?B?Y0xZeE5MSXAyMTZHcnBFU3RReXJ4ZXRIYXdNQW9wc0F6RllDWGlmbUp2MTlF?=
 =?utf-8?B?UFluVDNmSjdnNThWZW5ORndjN3FPRU5qSDV4Z1Y2R2pXdzJlb243VkFpMHZ2?=
 =?utf-8?B?QUd0QkVlOVkwM2kzWU5naGhUMHZ4K25pams2cWVZVUdaRExBTEVwb25Hay8v?=
 =?utf-8?B?TXZyN0d3NHMwcW8yeDM3bDlyekpOeXNia0hFZG12MERlNU5kLy9VTFJxM2ZW?=
 =?utf-8?B?UXhPZXhoYnJkSEtoYkdETVpEZ0xnU1o3blJLKzdKZE1DMFRVM25MRUxHUDVH?=
 =?utf-8?B?eDJnSTBsL1dTYTFtUmRrak1BdWFjV2ZLbnVLNU1pTnlVeDRJblJKM2taWkJ0?=
 =?utf-8?B?R0RXUmI1QU9obkY0VFIweWNvVWJQSUo3TFlhOXV5WHZTZzVEU05HU05SNERI?=
 =?utf-8?B?SDVnbG5MaFlVUGZ4Z1UrRGJraHJDWGVwc293aGNLWG81S2pPTng0emdzeUhV?=
 =?utf-8?B?OVBoT0VzTGF5YnN6dFd5R2ZFaUlLNi9tK21tQ3VOSDFha3dhaWNKMlNTUG5B?=
 =?utf-8?B?UitwWnFsYW1jczlNcU9oYS8yVnR1b2FEcTdlVXdFTURLdFRXRFpJTXN4SlZq?=
 =?utf-8?B?ZWhNeitnRWU5Q0VXeW5sTStadDFMNkhFKzhWNFM5elRkZUl1cmx4TTdVeHRs?=
 =?utf-8?B?dS8zMGlISk5RWGliS0E0ZkxJb0prenRqUVo0dWxEaGVNMmZtK0dhN3FsUnRx?=
 =?utf-8?B?Mi81aGRWN2I4YUlva0pEM0ZzTUNZejNjOEkwZFZKQVB4b2F6NHovTEczNlM4?=
 =?utf-8?B?L2NtNFZFbi9kTThzZXIrWHpZNGswTXhBUVZsdVh1bkRSQlVqai9peU50WG1H?=
 =?utf-8?B?L2FEN1JHM3JLdVBPZVZPaWxpbmI3NjZlWGlZQ1lRcE9ScjBWMXh6amJ5bDh1?=
 =?utf-8?B?VHJJWlcrU0JJNFFaTU9ycFppZ211Mjl3M2FzbGZqMzBHSVdyNitIS0pnYlpQ?=
 =?utf-8?B?WGxoVzBHeEpmaG9Wd3FtZkV6dnVqWEhubFNyL1pYQjk3NUhzb1NGaUFsZDdr?=
 =?utf-8?B?clJYMXFKUmVrQXZMdk12WVlxNUtqemZxSGRza0YydkVPenVVcDZLcHFhdGtm?=
 =?utf-8?B?KzJ0VTM2amxFVk5qNWl0SEhjUjRTMXFDZ3NvMzh4SHJNenl1NTRHeDM4REFa?=
 =?utf-8?B?NW1RMmxHWk1uK3lZcjdSVlNxVmx4VW9GUDZCY1R3TzU5RVBkYlVzSFB0WUNa?=
 =?utf-8?B?VTczWEFQUk5qbWVjckdDQ0tHUTE0eVVTRDhEWUx0MnNaUU1ybVNFSVZSQlhC?=
 =?utf-8?B?azVDMlhpdmk5QkdOVmlVWVA3Y21tb1FKZml3eVFMUlNIRzQ2b1dZcHlyN21n?=
 =?utf-8?B?SWJHK09YVm1NT0d3VEI4S1daQmh1aGVGYzBmYUtlNVp6VEVjY1NScklNb3Zo?=
 =?utf-8?B?ZFBrNDIvSks5NG1HWXd4bkZWUEdXcUk1R0FjOU1ibHVoa3Y4SDlvSWJLTnVE?=
 =?utf-8?B?Q2QrUStMM0creXJqYmVvK3FuMkMwc05TeTVXeVdITVVoaGxNMUdLZzJ3VUJn?=
 =?utf-8?Q?PkTx5eDbHIt9zxYgugd7QEI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C0B6D52E8EA7342AA658FA03581293D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099a5e97-3009-4f50-6420-08dc4a8a108d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 16:06:42.2923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0oKkgU8QMzGEWKWHMCqZLDm1dp4jXsBoE9Zx28pU/guGdpIMdzxJOwu/7ZX0HTla1mVN2mLVaGy5GnI6NswQMyoaAdSQrayjGgaF72aZWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7104
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDA3OjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IEkgc2VlIHRoYXQgdGhpcyB3YXMgc3VnZ2VzdGVkIGJ5IFNlYW4sIGJ1dCBjYW4geW91IGV4cGxh
aW4gdGhlDQo+ID4gcHJvYmxlbQ0KPiA+IHRoYXQgdGhpcyBpcyB3b3JraW5nIGFyb3VuZD8gRnJv
bSB0aGUgbGlua2VkIHRocmVhZCwgaXQgc2VlbXMgbGlrZQ0KPiA+IHRoZQ0KPiA+IHByb2JsZW0g
aXMgd2hhdCB0byBkbyB3aGVuIHVzZXJzcGFjZSBhbHNvIGNhbGxzIFNFVF9DUFVJRCBhZnRlcg0K
PiA+IGFscmVhZHkNCj4gPiBjb25maWd1cmluZyBDUFVJRCB0byB0aGUgVERYIG1vZHVsZSBpbiB0
aGUgc3BlY2lhbCB3YXkuIFRoZSBjaG9pY2VzDQo+ID4gZGlzY3Vzc2VkIGluY2x1ZGVkOg0KPiA+
IDEuIFJlamVjdCB0aGUgY2FsbA0KPiA+IDIuIENoZWNrIHRoZSBjb25zaXN0ZW5jeSBiZXR3ZWVu
IHRoZSBmaXJzdCBDUFVJRCBjb25maWd1cmF0aW9uIGFuZA0KPiA+IHRoZQ0KPiA+IHNlY29uZCBv
bmUuDQo+ID4gDQo+ID4gMSBpcyBhIGxvdCBzaW1wbGVyLCBidXQgdGhlIHJlYXNvbmluZyBmb3Ig
MiBpcyBiZWNhdXNlICJzb21lIEtWTQ0KPiA+IGNvZGUNCj4gPiBwYXRocyByZWx5IG9uIGd1ZXN0
IENQVUlEIGNvbmZpZ3VyYXRpb24iIGl0IHNlZW1zLiBJcyB0aGlzIGENCj4gPiBoeXBvdGhldGlj
YWwgb3IgcmVhbCBpc3N1ZT8gV2hpY2ggY29kZSBwYXRocyBhcmUgcHJvYmxlbWF0aWMgZm9yDQo+
ID4gVERYL1NOUD8NCj4gDQo+IFRoZXJlIG1pZ2h0IGJlIHVzZSBjYXNlIHRoYXQgVERYIGd1ZXN0
IHdhbnRzIHRvIHVzZSBzb21lIENQVUlEIHdoaWNoDQo+IGlzbid0IGhhbmRsZWQgYnkgdGhlIFRE
WCBtb2R1bGUgYnV0IHB1cmVseSBieSBLVk0uwqAgVGhlc2UgKFBWKSBDUFVJRHMNCj4gbmVlZCB0
byBiZQ0KPiBwcm92aWRlZCB2aWEgS1ZNX1NFVF9DUFVJRDIuDQoNClJpZ2h0LCBidXQgYXJlIHRo
ZXJlIGFueSBuZWVkZWQgdG9kYXk/IEkgcmVhZCB0aGF0IFNlYW4ncyBwb2ludCB3YXMNCnRoYXQg
S1ZNX1NFVF9DUFVJRDIgY2FuJ3QgYWNjZXB0IGFueXRoaW5nIHRvZGF5IHdoYXQgd2Ugd291bGQg
d2FudCB0bw0KYmxvY2sgbGF0ZXIsIG90aGVyd2lzZSBpdCB3b3VsZCBpbnRyb2R1Y2UgYSByZWdy
ZXNzaW9uLiBUaGlzIHdhcyB0aGUNCm1ham9yIGNvbnN0cmFpbnQgSUlVQywgYW5kIG1lYW5zIHRo
ZSBiYXNlIHNlcmllcyByZXF1aXJlcyAqc29tZXRoaW5nKg0KaGVyZS4NCg0KSWYgd2Ugd2FudCB0
byBzdXBwb3J0IG9ubHkgdGhlIG1vc3QgYmFzaWMgc3VwcG9ydCBmaXJzdCwgd2UgZG9uJ3QgbmVl
ZA0KdG8gc3VwcG9ydCBQViBDUFVJRHMgb24gZGF5IDEsIHJpZ2h0Pw0KDQpTbyBJJ20gd29uZGVy
aW5nLCBpZiB3ZSBjb3VsZCBzaHJpbmsgdGhlIGJhc2Ugc2VyaWVzIGJ5IGdvaW5nIHdpdGgNCm9w
dGlvbiAxIHRvIHN0YXJ0LCBhbmQgdGhlbiBleHBhbmRpbmcgaXQgd2l0aCB0aGlzIHNvbHV0aW9u
IGxhdGVyIHRvDQplbmFibGUgbW9yZSBmZWF0dXJlcy4gRG8geW91IHNlZSBhIHByb2JsZW0gb3Ig
Y29uZmxpY3Qgd2l0aCBTZWFuJ3MNCmNvbW1lbnRzPw0KDQoNCg==

