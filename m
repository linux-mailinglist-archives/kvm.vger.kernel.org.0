Return-Path: <kvm+bounces-15365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D588AB5DE
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12769283165
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12AE13CFA8;
	Fri, 19 Apr 2024 20:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kCWXltvQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738F413C9C2;
	Fri, 19 Apr 2024 20:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713557078; cv=fail; b=DqZUBRLk/uif2ajZahhjPsVNZ35PGGNBLTBTjjyj3ccEaCERzmDZ3Ps7bV47G2GeL6xIrxQCCwR4cw5rt0cX6FXutKECQwNrM89JIJZo3D0Q3MprzBExdI9EvPzfzQg9IntvMskV0BZ2Xy6n66tsFhXE1/02y7iLA4i0Qi3J5Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713557078; c=relaxed/simple;
	bh=9R8wMI74kOz/9mfbTe7eHbn19RfNg42aPwvuhgyVgHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tNNozWwdWQhiMGUduJpy9C9W6ZGyaDtM33Seq9BmemUQhq3BHvJrehKAB2Q2WmzVdo0VhsEeV8idVYxtHKktR1mHc9HVokloDHzx1EiktTlm1LWnqt8/HG6gQoV63tr5094K3h65WiKVEoM0OEjym7cWI0S0Iydo+GKEJf7oNRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kCWXltvQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713557077; x=1745093077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9R8wMI74kOz/9mfbTe7eHbn19RfNg42aPwvuhgyVgHQ=;
  b=kCWXltvQcUPZIUNFxfXhu+QvPTBUKvLO2hm1slJDPTDaykFYte7VRA4F
   ZPejKUrLQBuybbAaz9N58rc/V2Qt0xavoYDNU0cpwEjTlN5nKRTf0HX1X
   xru7/gdt61amn5UGtJgPsLSdTfr/cBNiTvTGGzOLgJcxntASqRn6Hn7eN
   BIqmLc8ZDUe4AakzVXS6lJqQwNSY2Tv8gXBh/ugJLLNp6GwhrRq5LRKKv
   vhZnrHP+tn5fIMmKyDja1VNpx/ikl7tBBISZeq1ND1fJMl+wLhGKUMJ8F
   tAf1aXZQhlQwNmNMAcSDePGc4yjnkFtMtCSoNh6h+pur3utB67yuauP0K
   w==;
X-CSE-ConnectionGUID: zt3jvPFFTJ+yl3yxfNVP0A==
X-CSE-MsgGUID: TPzgoGjoSKC8Ru493l8BgQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="20598351"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="20598351"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 13:04:37 -0700
X-CSE-ConnectionGUID: YlmF8i7TQ2CDV+fDaDvpJw==
X-CSE-MsgGUID: iCsbx/4ZSIqlfzYczvLi6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="60870759"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 13:04:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 13:04:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 13:04:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 13:04:35 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 13:04:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOOQI9eucfc86PydYGXAAtzvqhUDSjnr89ABYxZj5xfq/IT0SNyK0Q+XmQw9+JJzLq4qVo/OFBKMVQMoTFvoSUdDMXxiCnyzQ1q/cz5hwWr6CQvAnHadPobgLPNAFhZS5LeGqQPYUmZsE06p4ZyBUZ2KPBM5xp+td9ctX/peVZMyqtddGHDzQRR/DTcRNtt/oYFiRb0bkERYq4KnicziIo1i7KAiKogyVaUjtaoYcnajQe7DOPtQhIWlMPNi/p79spUZSwYwde+eH8YW+2cFmABQ8JNpcCUf6fyqmX33yjg5sTFfDXbkeqS4rU27gWKSsXmmBnhAuBfA4deZrcHIiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9R8wMI74kOz/9mfbTe7eHbn19RfNg42aPwvuhgyVgHQ=;
 b=g1QN+sTtJbblmeZe16sNQDTJAXX5FLYQtvtGxqXc4RG/kRdbV9RA2OrRO2R/Ipd2UMT09wE1n2k3yTGD3exy0QVFXKsUbE8K5rVySMMgayMIlN4eIvVDuqbBToLKyTfo7NNnPNeEto1vBq7d2ewnd2ZWBdpntXxguF7NpFnxq3eRrkN4g4dLJxnvysHtw/yzG+aII+Xi0MxuI5WdRPk2C+HyXOcG6vj2eVRb6cxpommtpydnTxOHCDHqkAy/U23N2eoQznRfm7wtR5YK44p8wDhYhcUBxwXM9b6/RhWqZqLMlY3bqmfRaJV8cJIDVRmb/XM8XDNyHd641GsMcKPvVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 20:04:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.015; Fri, 19 Apr 2024
 20:04:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAKJ4bAIAJ4iGAgALItgCAAEXagIABVNMAgABY9QA=
Date: Fri, 19 Apr 2024 20:04:26 +0000
Message-ID: <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
	 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
	 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
	 <ZiFlw_lInUZgv3J_@google.com>
	 <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
In-Reply-To: <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5290:EE_
x-ms-office365-filtering-correlation-id: 93ad64ea-39fb-4e10-8415-08dc60abea73
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XtIWdlN5MBzzcvu8dWithkzlHKkgGTYfAUbE2yQ7IDEjQmT3JhcGI3HWv3p32AtGUPgLFk1o+pzUlswk2VWuHmK+Ns6yFKDp/B4+qVS+qdUlAKu2QtX0J/CnKbFD5FDrbt+RSj69szlZzNUrJsA+Ccq+Bbcu9+k0wkPrk4GlOeFyAAg3jZn7pX0cBWqqDk2bkQ+a/oIKMdJ4/q719DaxBey7p3HU5qKGJ5JFBRpLW7sqHglqSd6e+EXbHc6QeprWy9LRG6z6ssdaja89AIWZ4lerQJiNUp3wZsUVyQXSaX/hT8CKXEpz//1NA1sE+DCHAU2X21E710UMzuyK2dWOAd4hjp/3cMG47Ebg0BkhrxzbZWJkZJAGgUFwmwmfzGotSDqKKC0B4h0zFhzclOe67F0JayFMevOVhd25Z7BQJfTXEayqdduZiK9R7aZ/HKYajdsRByDKIV34S9zHK0JnK6DakfTGRl97hrNguLCKviujv/ymV8AwMIbfLo3DDDHll4YILyUJWC8RRzywOTghRx4EdF4ohlGU34/9I4rKzKk1rIp3TPUJiod/ZPyez79gY2ES3tRzj7ULczAuG4DgL4RacCVuBdpH1uzb2hkRiwH5507zsWR8H1eF++22h4jkvpDrGIrga9MpSGkQTMeEWRp1JdZTSnIvGZQ6xuKG7DmtjRQe2NLBKQm5sQAUPl9DU4eM8RqaAghbiB6Jj81/9kYLYDPYD8wu1RmptOPybi0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXZ6ZUdFbVhrOTVyeUE2MTF2ak1Ya0pyNDBEZlJHQUtoWTFTeXJFK2NFL0Jp?=
 =?utf-8?B?SzNzMDhhYk5NNlJSZlBhMXk1bCtCc21qeFBWeUtQaVJPMnJRalpBcmxjQXpI?=
 =?utf-8?B?cXVRWkdTOSt4OFN0NWFkcEcyN3ZMdWxJWFd4U01aSEVObVl4b3ZLQkhmbURu?=
 =?utf-8?B?NU12N1JJVjhqcThXWkFyb1ZRWGlrTXJad1RiQzFPOTNJZzBXRkxtUm8wSkJl?=
 =?utf-8?B?TlBjUk1DejZIU1hDUzgzMFA4Mm1qem1FSWJHUDM3LzZuNVR5enErbU9ZZTZX?=
 =?utf-8?B?djBDdVZjcXMzcEtOeE8rUE5HOFhBY2pkMVB6WGVtNk1IQ1psQ2dDeDFUNUha?=
 =?utf-8?B?MkR6YkNmVEd3bVhLRVBqa2FjRTV4NG1PeWVVOGxOeXFaSUZCSUliM0RCbGdU?=
 =?utf-8?B?MVA3Nkh2ZFVpUHdhRnVIQlJiM1FtaGFjT1lPbFhSRmt0Wk90enl6L0NEVGo1?=
 =?utf-8?B?Q2pmY0kwQnFTZWR2MDd5UzZ0SXZjM2kwWDdQYklSM0VTZXRFNjF6V0xZcStM?=
 =?utf-8?B?WUMyN2xVdGJhM0hVMDZqVVNyQ0hmYlpCT05UVmdsaG9DU0JvZTU5TzdRZndD?=
 =?utf-8?B?QW90b29yd3BiVHZUMUtTTzZuVTFJc0EyL0JtK2JSMGhBUW9RYUFONUo3UlNs?=
 =?utf-8?B?QWpNWnBXWlJzUHdRT0xET0Nka1hxSEx2MlpvaThVMEV6ckhoM004dkN4NUM4?=
 =?utf-8?B?VkJ2cHRMYWhNUVVHZmlmOHA3d0FVS21XaEd3cjFHdVdRQThhUGpxblVXYXl6?=
 =?utf-8?B?OGRRblY1V0VGVTBzYUVDVEhXcU56eUJ6dmdIS0t3aHdpb2pDR1VaOEJRTjQ2?=
 =?utf-8?B?ank1Y3AxckVIVEpkWUF6Wkl6MzBGTXU0bVUra2FNVmprQ1BZM2s5YTRldVpX?=
 =?utf-8?B?NDRJY1Z5dEdwZE9qWllIOUNZMzM3Q3FUelIrL0xaemdaZ1NST085TkcvZTZF?=
 =?utf-8?B?MU00WS9YSTlyMFppT2J5NTZqMFNnellNalJpWEdZc2hXUWRnVVNaOHRxMGZo?=
 =?utf-8?B?bWZhRElDaG1leWhzR1lPV2wyYWhTKzU0Nm5pTzNhT3JsbWVQbnZsOWFKdFd3?=
 =?utf-8?B?UWVFNDhOVzNoTVlRRlBkZlMrUWVucGI2RWhlbDJJV3JVV0Zma1JiRWpSVk1t?=
 =?utf-8?B?VzgxNndOUkV0UVplZWFtMW13dndmOGRjcHN2Qks4MFJ2ZTkwM2ZQcGtUUnRE?=
 =?utf-8?B?UXNPU01DRFQxTzZmOEt1QkdLY1h0N3dodzNNYm5JSHl3eWJ6bm9LSjA4RGJh?=
 =?utf-8?B?M0hISi94Y3FxSlg4NW9MOVdJdFBPRlJLMHhhd2pMQlp6a2dMendNRUZ4ZVlW?=
 =?utf-8?B?N2ZpVDliU1Q5RXRrK092ZmQrWi9FY1VtZDlDQ3ZsaGtHV2ZRbmxTMXZaMVgv?=
 =?utf-8?B?dUZJOHhieHJQNnZCZ2VwYnd5VnNKNlRkYVdTS3VsazRrZ3U1SWdNdHRkQjd1?=
 =?utf-8?B?bnRPTmZtOGRqLzF6R1p6VlVreDNHSzdub0xKVklOREg1UDBleGdERFY5UUxG?=
 =?utf-8?B?YkRiRUc2dm00Y2MwWmRMby9zV25CUWl6QS81TUkxSVRmY2JDVDBsbGxCRndu?=
 =?utf-8?B?YjFsdWUvem45YmREZWk5QlN1ejBYYjRJSDU2VE8vUnhlSzI2NHBicTdGMzUz?=
 =?utf-8?B?KzFvaTJRT3A4V3NTY3BnaU1iUkRFRTNucVU5ck1BNXJKQTRxNDRtSVRZbVY4?=
 =?utf-8?B?d0d5VjhiM2l3ejNxN3hjOXZLeEkrTlhITDZKdVZDVStCSkI2WGl6bXNlbmh0?=
 =?utf-8?B?Q2pRK1dtRVRkUGpwN3hqWThnOEIvQjJBR1BvVDh6SnZ4Mi9kVUhOVXZndlVF?=
 =?utf-8?B?VU96ZTRsVGtvUG9VMWhjdzM2VUNTUThybU1QTVZDQjU2ODZJbjhGSlVxY2hw?=
 =?utf-8?B?YWRabE9jOCt4MVNvcUg0YWpRK001NlBlOHFLQ0lSOVJhV1QxTHloNWF0QjN4?=
 =?utf-8?B?Si9pcHpsWk1ETTBhbXJXNlZBczFXanFvd3k5MGltd3NpSkZIY0VWYWZVQlRo?=
 =?utf-8?B?SWRIazNLVjd5VlpoRmFFUjY1SjBFTTlBbkdNVGp4MFowd3ljOUFuQU53WEtI?=
 =?utf-8?B?aHkvVmE4dDlvQXMydE80ak5oVkRSdDZ3V2kvMGZURHJEZkwxcDBGR2RRZTFx?=
 =?utf-8?B?aHNBQ0RvR09RQWZaYWptcWhwTmtXMDVlNmNKbzFRVHlaMGM1cDNacGJocVpU?=
 =?utf-8?Q?Y7ejU3c3GeFLkBsidAImsK8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7C4DC60F1D572458FDFB15C1741EADB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ad64ea-39fb-4e10-8415-08dc60abea73
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2024 20:04:26.8635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1f631bIYvcC7vC+qLVtz3VvGV2W8PQ2SIcIP4QYCrkC3U06fAcCh8+LSDHBm6rwhksCjzig2sxH5ZZveOkwzigppvoby0Uu0+xbgABvWbrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTE5IGF0IDE3OjQ2ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiANCj4gPiBTaWRlIHRvcGljICMzLCB0aGUgdWQyIHRvIGluZHVj
ZSBwYW5pYyBzaG91bGQgYmUgb3V0LW9mLWxpbmUuDQo+IA0KPiBZZWFoLiBJIHN3aXRjaGVkIHRv
IHRoZSBpbmxpbmUgb25lIHdoaWxlIGRlYnVnZ2luZyBvbmUgc2VjdGlvbiBtaXNtYXRjaA0KPiBp
c3N1ZSBhbmQgZm9yZ290IHRvIHN3aXRjaCBiYWNrLg0KDQpTb3JyeSwgd2h5IGRvIHdlIG5lZWQg
dG8gcGFuaWM/DQo=

