Return-Path: <kvm+bounces-21685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 764E7931F07
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 04:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EECC61F22808
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AA2F9E8;
	Tue, 16 Jul 2024 02:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/ns7y7i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31DC8F3;
	Tue, 16 Jul 2024 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098394; cv=fail; b=eBzZqSQAgq49110aZO2KkM+HKKOR4gbgI/cXYIzi54thcQ4tUrksna1Z7Za27efCWHwTdThPmCPpK4n1qgsbPa/i+h1uq4D8sXaqFLzOCbkdqw/Afjj1227IhjoPVgRPhXmVp3Jn+FaetTLIJKEv+p7fZ3y/RBJMAi3CWgaavyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098394; c=relaxed/simple;
	bh=zPkmfNXrRkUl+ms5EnN/TVkjhKa0oJ6lDP3VvT5h/o0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BzIhHOYDHUB7b3HHjZ25Xb2c+VoZBGL5mp4i6DGh8fA27zb2+dJSs7RcIcSt4KgUdvnhoiIA4fUesNDpM92JFgk+hw9oDZzy9PvHWOJjQUIXyVQ3Z1qR785IqXr4wMyO8P6d7RUI465Bzio7dlobG4Rz2e4ayDzopGaZcbqiYXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/ns7y7i; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721098392; x=1752634392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zPkmfNXrRkUl+ms5EnN/TVkjhKa0oJ6lDP3VvT5h/o0=;
  b=b/ns7y7iZ1MJaeLzrTcjYDhqSXbtvffJhNUwWd6IoO+BPFdyjS/Uw6qK
   nqV/KV5soKqD3Al5YT3O7rqQutr07cGwAp3GJ6AKYPy06Bj8ct3kudSWp
   PsoZ3dXU5Rji7FY2FZjwyIxntlCvhT9tZ/h7iJnovO55LYlLegoQ9/b0B
   P0sjqnGWZg0hnKQBBEJZE7yhiOvaPKtaoN1K5g6yTXf8nkeDGbYQdxdo5
   jrONMKeLPDEbYc9FuFqprLDdMWH1D/cBg3iyKev9elZwfpaHID6O6BrIS
   iS/7wnWFQjBtfarJqd4eLvqtPCAN07TKmndygQ/lDh2CdHxwi78y9n0v/
   A==;
X-CSE-ConnectionGUID: C2kyMLZzTcKAKZgaYm97qA==
X-CSE-MsgGUID: W0S8nX5qS7mxOaXGIq7fIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="29923384"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="29923384"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 19:53:11 -0700
X-CSE-ConnectionGUID: HhW1JPhfThufBxWrzmPBPA==
X-CSE-MsgGUID: aeUboTKvQdOQgGCSzAk6hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="50596476"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 19:53:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 19:53:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 19:53:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 19:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRz9WDNJqIe27fPVfL43GU7NkXae0/88S1Xp5RsREYOG99SNSKsIoXQN1DqcUfWFZsfWFN9cd56TVLEntkwPKdRLCbqI7Q7TphN6xCdmjpzS+DvOUPpcOjL/RuFcqT99tFynRhVfOTRwkxqORvLsccVU1tPw224KLmnrrBHFeyPehWo0XtvH+OSflvaFP+ZzlapRZ9wTsWRkUtWQ4E7oJQ0ZLtn6E3Ybt40GYHfCRzKi4IPyOTV/1tXih5WuA9/uLHyQeLQJy7+4Nfz4VLh3SpPt3lC4ducjZKvjtMWUplIk9GxWvidBIyYY8QGo4kNscRu3t1l0Jt7jdwZgxmFmUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPkmfNXrRkUl+ms5EnN/TVkjhKa0oJ6lDP3VvT5h/o0=;
 b=dcYeUSI/jZ7G45XQvp3Uqs8yELXm0o3W9kdSPZoZ+3AzBnr3ItbpDpr0HC2tl9OtnfzbuuVt5lbg/9+DlVc6ZwrTPF6A5HFCBiZCOUtOUPtVbQqVqbWcFQfPIi5RpFcPU1QdgzafCxpvJjH3nNbRgLInDC7cFLK2rpAvoemoBC8S5woFTI/4wbqGazuS4tDd32cTAPOHUMF2HS9WJKAP5n2mqeJ0+zY26vOsJtOoy7VofS51yvY1NEeR0kIXpuP7/FoIDgUn4wuY/+E7ci2wPDq1V7qCZPirruunNNiC6ColD/IF9HfeADgwpNuLCTp87BlFunPf6nI2fhS4+AFciA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.23; Tue, 16 Jul 2024 02:53:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:53:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Topic: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Thread-Index: AQHa1x52SQHDcx1NlUy5OEbh4zbwNLH4qFWA
Date: Tue, 16 Jul 2024 02:53:07 +0000
Message-ID: <7318bebe448e88603f5e86bf1bb7f43dce4ce8dc.camel@intel.com>
References: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
In-Reply-To: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB6352:EE_
x-ms-office365-filtering-correlation-id: 987db776-81ce-4321-973c-08dca5426c1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RE5QVzFublF6dkprUlJFRXVIYkkzQ3drNG9aSVlCZjk3RzhtSEZKTjJCWDBB?=
 =?utf-8?B?eUtQWklHK09vUUQ1UW1SZ201NHRRZFdHWGNLV0UxcXBJdUJ5TFhXZlBqb2RU?=
 =?utf-8?B?clRvQmhqZ3ZPWE5VTXgveTJhR2xOai9jZmVzMnF0UTVlYzl5V3VuZzI3U0w1?=
 =?utf-8?B?bHNXcmw0RGR3Q3E4VU1LVCs0K2dEOWdUV2krVFBhOTVRdGdWN2wxZWVScTdU?=
 =?utf-8?B?U0I3SDlZaUd2YlZud05VcVZQTDA5eVY2eHZYaEw3NU5SQ2QvZG84bWJ5cmx1?=
 =?utf-8?B?ZTcrM1Y5MWNFVzFmR0VaaTVGZklBUmk1bkkwKzJ3clRjalhmM3NsbXpxcERQ?=
 =?utf-8?B?YlQ3eFluYmkrQnVFdlk0L2FrdEZ1SWxzQlZXN09lbE1vNldMUUM0bS81M2dq?=
 =?utf-8?B?QVpYOEZpekxGdEQ2dW9GaHJXOS9TYVNvVFN4dkkwLzBnRzZPbDBMQlY3UG0r?=
 =?utf-8?B?cmllRE4xbGZsK0ZOemZMTGt5VUpQMlJXdENEZEgxZHpVZCtQMmZYWk1mYkxU?=
 =?utf-8?B?aUFQbE5paVJtemc2RFFndzNQMU0reHViR0M2VUVTR1dDeU0wYjlPUFFadFJ0?=
 =?utf-8?B?UjhWREtjRzNzWllNN3J6RmpPd2FzMnhOVDNxOThta1kvc1dxb1hlTFZubVkr?=
 =?utf-8?B?NDkxam5CY2lKVzBpLzkyZlZyT1dRa2NmQzNGRDJzVWx0RHZMRWRCa0JOSVl4?=
 =?utf-8?B?N3BwbndoWGhheXdaVkFPUXRUOTZEdlN1Ymxtb0labUVIVDBVeVJtQUszL3RQ?=
 =?utf-8?B?RzMyNUc5N3A0dDdtUStJQkt4azNzY3ArVkVwQXVTZU5NejdaSm1FZkUyZnRP?=
 =?utf-8?B?cmxDWnQrczFHa1Q0U2J5cEYwYW5MVDlVU2kxVzh3YlAvMHpZVGFoWkNzQkhi?=
 =?utf-8?B?OUhRZE9qTVBlTDUvTG1TQjhMTjVreTRXQkk4ZFQwcE5wcG1reWRmNi9oSW03?=
 =?utf-8?B?VnZVT2tWSTkvdlNaeGxlamdra3dxbXRIaXAzZXhxc0piKzlUL1hoTUpIUnZn?=
 =?utf-8?B?VGVDZDhjbkN1Nm9VWUtEak1OTktkUlRlV1dSRk43enlRMEl0Sm1qeWZSdkxy?=
 =?utf-8?B?bm5TMzdaMERsMDFTOUppMktqMjB1SFpuOWFMT1pkOVladFBtOXduZHcyVUVO?=
 =?utf-8?B?cDc4aUpPTm4ySm5GWE5iczBGenhDekw0Zmoyam5xYk16MU1pMm1WQU1uTTFp?=
 =?utf-8?B?Q3BiZmpCbnRSTXVOWFE5dGJ6MC9RT284SFMxcmMyY25MaFl3NXBsUzNFemVL?=
 =?utf-8?B?RWZUSFUwK3l0SXZjY1JjNE5RS2M1cDBlbkVRS2lBWUpQQzlZWDIwVmgwQmpC?=
 =?utf-8?B?M3llZit1U0dlUDJXR0o2dFljTU9LUW02SnlsdklxbnBOcWdMWnFJcVdPdkRX?=
 =?utf-8?B?d2g5cWVBS3drQWo4SE9PYlgzN253aExnSk9EMklWMWpFeWk2VStMOUkyYUlx?=
 =?utf-8?B?UHN1VDE5NGgzdndiYVllbC92K29hdUxHUFdxb01obDJrY3E3NFlwUElxdlF1?=
 =?utf-8?B?ZGR3Qzhudm9zWWtQdldESkFSZmdvT2Z2aTNSQWc1OG10bTVySmJSOVR4UFBV?=
 =?utf-8?B?c1JSRmszVXNKNnc2SXpqZEExYVk1TktLejYzUlEyc21WV0VmbExmQ01mWmVq?=
 =?utf-8?B?OU5zbFBjRjhzOXd4YWh4RW9oWElydy9kR1NuR284S2dyZ2srTGNGUXNHVHhJ?=
 =?utf-8?B?ZndTTGhCME10cTY3MlNjVFVUUnd2MXhNZXUxbXFxY1RZeUZtUy82MWp3RUll?=
 =?utf-8?B?QWVFYk1YeWVNUkJpYVo4Y3VJMG1xbklNWU13R3p0OGxCdFJmOHVPY00xTFhI?=
 =?utf-8?B?RWFJWmFHU3JRUXhHbnVHVFFkcUpOai91VkRGdHNLUGxMMGVFelI0SEVmMmNl?=
 =?utf-8?B?Snc5NWZHMHBxdTYrQ2tKeHg3dXkyWkJ5cGx5bGpxbXVEM0E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3FxNlRCbCtrMHpEcVBEU0o5T0dkWWcyOVdOZjIzWlN4THJXd1ZIZThBODNO?=
 =?utf-8?B?TjFNbWcrUnZUbDVYU1RuMy9lSWNiQkN6TDkxRUtUY3RPbmVYbjZ5alhsbnBE?=
 =?utf-8?B?NmpaSjVvaXJKV0JNRUV0NmtCYTVHcHUrQ2hNOURHMXJGamQxOXk5N291ayty?=
 =?utf-8?B?aFhKbTJ3MWtrKzdCZHFDVUxPcG01ekc0eGppWlBmWXNTc3RleUUxaWZtUHdD?=
 =?utf-8?B?eFBNK1lWMVg1M1FVSnVWSUZQUjVISHYvMTU5akpWSUQwUVdDOUlZQ0l1RTFp?=
 =?utf-8?B?Nzkzdkw5UW9WQndKdzhONzUwVHEyY1VRSTVLRGJqaVg2bnh2UGpBMFhtOWhn?=
 =?utf-8?B?RzNuQXNSVWU5MzA5WHE3SjY3TWovOVZEbTF6azB1RzJDWkhQWVpEYnpibTl4?=
 =?utf-8?B?VUNGRFpWYy9OYUJTODNnOWZRelo3TmIzVEk3UGxrNDU0eXIxU1dQMCtJa3I2?=
 =?utf-8?B?dEwwUElrOCtGb1IrQlpWRFhkRVlOTzl6VGJteHZjYldjNnk3aCtEczZkNlFo?=
 =?utf-8?B?cXE0aEdaN2phS2F3NEdNK2RSK3B2Q0JnK0VDbnVNUkJraFZaOG1ZeDhpLzEv?=
 =?utf-8?B?WFozSlVTdTdwRGcyc0tXU2RjQ2ZqRjZhOG1MZkN3OUZrQXhRQ0JzRTY4MjUv?=
 =?utf-8?B?N1QvSWgxQjZFY0JmSDFGd1Y2ZVNid2xpZVJVdVRzUmRPZGV2WHp2ZFRRYmRE?=
 =?utf-8?B?a0NtaGMzSmNvZ0tvbDRxS0EycXJzODlBcjhFSEd1UEJ1dCtrai9pQTRTemJG?=
 =?utf-8?B?eVFCcmNWdUJwYjN6NEJaZ3ZUclhUQmx5b1QrcXhrZkVYU2I1RkJPVlBNZXEx?=
 =?utf-8?B?d0RuN00yVU5NWi9nUTlZWXFJMDdFdFB6dDV3L2RqUFVzQXZ2clJpMEx5Y25h?=
 =?utf-8?B?SEdiS054eDA2Z3JERkVnUVhtcnRHWWEwRGZMUlE4L05hT0duR0k0UUJsNVlP?=
 =?utf-8?B?YmtjWGdud0NMYmswL1UwQjNyNWtwNkpOTkNncVFqNC9MdlJEUk53dXZYakFu?=
 =?utf-8?B?aFc1WEJXcG93WHFPK2tSNzdPTytuSWhvN1czUnhKV2x5b25wOWl4UTZKM1E5?=
 =?utf-8?B?akt2eUVXdXlzdEhjZTdjUEZBNDZQa1Yva3o3OVZPT3hjcWphUWZjd25pa0x3?=
 =?utf-8?B?dW9CYnNrZE5nT1Nqb1I3UzNzRXVSM3czWFZLbytpaFhqS2VpYTlWSEhablJH?=
 =?utf-8?B?bnl0dUgwdVJaSVhvVUpxbFAyQlNCaDhXTWs2NGJydDNCajBKd1pDZnlHaFNv?=
 =?utf-8?B?RE5vTVFXSzg4V1REcURYY1dtaGpBNW83aVBTOStXZ3UvTTZJc1JIdkNPUzA3?=
 =?utf-8?B?SEY3c0k0UVBoaS9RUFhKSmxkUlhMc25EUVRrd3U2dDdDZlA1Zmt0eE5WYlk0?=
 =?utf-8?B?clljdUx3ZTNaN0V1UDBRbDdjamh3Y0lvOXU5OVl4Q1dBU1ZIYW5RS1ZnL2x5?=
 =?utf-8?B?blJYUWZNTzZ4MkpPT2w1NEpZdW9ZRkVkTmZRdCtqR1NEcUJkRU43bDhkZWNo?=
 =?utf-8?B?MStCMnNvVzRCc3dBZXlKY01tR2FWZ1I3OUdnNVhDK3hxbW5CeGVzSU9BTkdx?=
 =?utf-8?B?L2p6ZDdqOWdFRXMrS3p4R0tGOG9HSjg5THdDMjRKWjhkWXNLTTVpM1IwM0xB?=
 =?utf-8?B?SmpZc0s3aTc1alVJOGdwOW8rRGpxQm1KbVpqWFBQeUZMWUduWHR6RW8rUDdL?=
 =?utf-8?B?WUw4anBvYTdnOXpYNGVqc1JyU0t1QWtJeitvbXBSVFcxemY3c0RTY0VRclBX?=
 =?utf-8?B?RUVibUJRNnUxK2RiMVFJL2dLdjhqbUVybkU3K0l5Njk0OWJJcFJNRnVhUklm?=
 =?utf-8?B?dG10ckx4MzU1WEZQS0RNOGwrMnNFMmFTMUNXRVAwWm52SUhrZVNOWnRpYVQ3?=
 =?utf-8?B?VlVxZjhMVmFCQUdibEVnQzhYZE9qMnFmNHZUNTdMR21zVHlPWVAzUHo0SXF4?=
 =?utf-8?B?UnRUOExiZ2ZwSmRBR2NuTTRTZ2IyMXl5L3ZZZW8xSWxzL3Q1K0xCcnlST05N?=
 =?utf-8?B?c2FKWTcvcmJsUURyZXgraXFZOUxyS1Z0c1JJTnh3WnZmdEtQZzRWVGNQNFA0?=
 =?utf-8?B?YlJkL2toNm9kRmpDRjQ4cWJCWXZ1R2FIaDEyZ3g4bUxBc3B0WEQ1QlBzaURq?=
 =?utf-8?B?VC81aEUxWnYxckhaQXZoTjJlUis1dGJqWHE0M3QyUXdLRmtDQ2RXNDgxWURa?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B63B80E47B1DFB4D95D11446F1F0FAD3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987db776-81ce-4321-973c-08dca5426c1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2024 02:53:07.9576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pt6fE5t17AlPR7YuxfIteqq61aubwIQxAoXJpZa4IjYW+1J0f1bJIj8VPuCsMRmDeAMTkWE971PNB6mmTD867veOiX0AqLq7HPDosV8BdNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDE4OjIxIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBQcmVwYXJlIGZvciBURFggc3VwcG9ydCBieSBtYWtpbmcga3ZtX21tdV9tYXhf
Z2ZuKCkgY29uZmlndXJhYmxlLsKgIEhhdmUNCj4gdGhpcyBwcmVwYXJhdGlvbiBhbHNvIGJlIHVz
ZWZ1bCBieSBub24tVERYIGNoYW5nZXMgdG8gaW1wcm92ZSBjb3JyZWN0bmVzcw0KPiBhc3NvY2lh
dGVkIHdpdGggdGhlIGNvbWJpbmF0aW9uIG9mIDQtbGV2ZWwgRVBUIGFuZCBNQVhQQSA+IDQ4LsKg
IFRoZSBpc3N1ZQ0KPiBpcyBhbmFseXplZCBhdCBbMV0uDQoNCkl0IGxvb2tzIGxpa2UgdGhlIHBh
cnQgd2hlcmUgeW91IHdlcmUgZ29pbmcgdG8gZGVzY3JpYmUgdGhlIFREWCBhbmQgb3RoZXINCnRl
c3RpbmcgZ290IGxlZnQgb2ZmLCBjYW4gZWxhYm9yYXRlPw0K

