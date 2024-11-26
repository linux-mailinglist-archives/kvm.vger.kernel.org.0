Return-Path: <kvm+bounces-32484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C32779D8F96
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBF4DB240E7
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 00:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0A18F54;
	Tue, 26 Nov 2024 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CcmUJlI4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4002C95;
	Tue, 26 Nov 2024 00:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732582017; cv=fail; b=X7yzS9+J+7XzLRZRuUcNCclOn2aAf1Eqf9GfhFbxIxKx8ikKOHswlQZGRXS3Jukl2UCODy5ZUopFA3wfT/pAKO+3BvZF9VcSvb3wSCkqo+nBsvKg6EXC3jDNnfj01S3g4bW2XUvPYKLYCwJUwVt4e8kscEzmo3kQ/53IZg/WEJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732582017; c=relaxed/simple;
	bh=qJzD8awMaJ2rMX4BlVgU0c23MARUSYKXV3xM8OCr3/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EI6KYmKHCXF4YiL7TFzsOdvJtFe2cL+UlpzdPRjqA7D1Vm7WWVjZcmDiUhHxX7QPJOn0PFRVxCq30UYt8zE6pokEcOLzqy0fEcloLFFOhMsMA1ZUzXAk2WTbrSN9Sq6UBOYv0dpyPhO7EslPP+usx13RIp7BLrN6BD8/90varaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CcmUJlI4; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732582015; x=1764118015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qJzD8awMaJ2rMX4BlVgU0c23MARUSYKXV3xM8OCr3/w=;
  b=CcmUJlI4r4xIf14ZHFNV5WIwWUPOgh/+vc60E57dE3MtLvwWrgkbDRvT
   8ka5JlURfwmzHEhTJbucn9snR6D3Ed4hiOfaTiuFEVx5ru1VwPJASF3x4
   P3D/G5lbCE5+zesgclPYL13bGG++7u1fxJP3LtmSRqGGljjbpkEtOB/lf
   ylv9CP0hsPLEZOLhQJm9kL+ksvwI59nJEJ4oPUtTalbqQYNoUKX/OiYuj
   lVn3VP28t1oDxURE+VHIQ/PfK0SWpd0XNMbzEnudWMBeSBBhMxIWQhd1H
   pJW6P+DwpcT/xDvrvGBUQ5mxbOpc3wymS+MWdodmy2R0p9yzO4teDChWa
   g==;
X-CSE-ConnectionGUID: g+Buj3BSQsiX4yS9VdptEQ==
X-CSE-MsgGUID: j8cQYTw1ROyFriEWcvMizQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32092826"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="32092826"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 16:46:55 -0800
X-CSE-ConnectionGUID: S0x8FnP0TvqsJiPXKTdyXw==
X-CSE-MsgGUID: weL3/+OzRVSVgy8GXAOV8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91852002"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 16:46:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 16:46:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 16:46:54 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 16:46:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtcg7ktg5m5EyDAvfmx2NzgIrhbK1HUyURs68BuaE34CF3tW4T7tBWrf1KrU4crRL1LbT18CGbQXehHCblj4IZDrlKSOERjlWEQGq9sdVTlN7UPHZn0qHVygtBz8Fb+PN+ZcyZmyDjFSOE8y9v2tI0VJdZt/92xlxwPF61caL6TBqGX12ePfhIp794DbVQO4aA77VxfXCsPzxFTmqHS+XAbvBWuGL1VMf5ZYdOS3DiJaxtwOFXXj+ib8LNjppNQNmI+zDQrMrwESOKnYojhUY8cgvFGUHLITqYAYS9qfrWaYx/Q4goWYJkuyqbUN09hE2G4Cf5jkBQUl/mUCwElPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJzD8awMaJ2rMX4BlVgU0c23MARUSYKXV3xM8OCr3/w=;
 b=AI0X+E+S70QF60mMD87nZ+DT5GrXpUpKpF7RXZYRXQtpy7cD7eQznwisGkMd383p7q08X2OLJLALywpgMGsTTBKIBbxYtRWvO5jiZpmmM3j5CPKmkciUSlPi92N6nyNvWyGwNKJMIEDBJnqsz40UyRtqVcnTRo0ExnUf7TtRlU9awT2grgZ7YXp5U1rPaBpGyENdKCJQ5RsJp550NyFUz+ql3LNhyTE5/jAZzWzzEsohuttXm5sRSZRL5C/52trE0DEu5stYocKbOJpMNSTJe/KRrWdv8Qa7/JnvwlhAmzsBXiWFVvokjok0eMfDeat1Q9KhtKbllhkv5/5mqX58mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7705.namprd11.prod.outlook.com (2603:10b6:806:32f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 00:46:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 00:46:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Thread-Topic: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Thread-Index: AQHbPAwn74Wd+qQVFUagGKKQXm+TfLLIwUMA
Date: Tue, 26 Nov 2024 00:46:51 +0000
Message-ID: <4a3b3b6bc96e111e5380de4681a20c2734d82a33.camel@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
	 <20241121115139.26338-1-yan.y.zhao@intel.com>
In-Reply-To: <20241121115139.26338-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7705:EE_
x-ms-office365-filtering-correlation-id: 667fd62d-e3eb-4046-54f9-08dd0db3d0fb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3613699012|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VlJEVktBZ3NjSER1a3E1NHEyS2lxU2RBWlg2bERFTWVMSFNJNFh3S0tueGhW?=
 =?utf-8?B?SGpGVjk3TWNydXdvOHcwcUtaNllGVVNIcUozamVmaGhQY04zUTBwWFFxT3px?=
 =?utf-8?B?M3Y4R3lnUnI3OTQrRmkyNVNFVUhodnZNRkQ2Y28zbXpENXNxcXluNUgwREpH?=
 =?utf-8?B?eEp3L3ozM2JvQVd6ZURITEIwSFZLSGpyVDB0WWJjRlIzeW83MGw2eEJ6L3Yv?=
 =?utf-8?B?RjJKWG9RUlI3eldKNjBkNEVsbUl0dkhQOGZNeS9Wa2pKbVlQcjIrdlVackRJ?=
 =?utf-8?B?aFdSUXc4VzM3MnI4MVVpK3RROXNncHM4c0lIOEFDTUw3RlRuSTZqSGNKcllN?=
 =?utf-8?B?TTYwcEQwRkQ4Wm9HT1R1eHA4U08xaTNPaG9iR0VkclFrWlp4T1RwUC9FVmww?=
 =?utf-8?B?QnpITXhESUhLZy82M2Y2QVFDMWlpeFRoN2RYN2dBWExwWVVvNmRNWUQ0Wk1l?=
 =?utf-8?B?Qk42ZWpWMXlPTVJIQXdlYXlsYmtLSlk1T3JyUVpEdHhpSzhDV3RLdWV0eXdw?=
 =?utf-8?B?RHUwYUZweG41OUZGY2IyekgzZlhBd3IvZnJ6RUJTWnlVWWxVcUpqQXV2eUs4?=
 =?utf-8?B?UlptYktIYTBoUkFFWUoyczZzMFV0Y1d6dE1TbThJdHBwbVFaSFJUcG5iU3JM?=
 =?utf-8?B?d3RGb25rdjgwd0o5RzJJa250OENGWmhrMkVpcE9lV1dSU2hSZDU3eWZXSjds?=
 =?utf-8?B?TUtab01EQWpVenJpS1B4aG1Wc21iZWVNSUtDRUF6emg3akN3MTNUTnhYa0RB?=
 =?utf-8?B?RjI0SUlpOFQvTkl6WmJNa3I0T29MR2NOZWh6Tlpub0RhUW04ekZ6Q1UrVTVO?=
 =?utf-8?B?bkpMV21oK0docjgySE11bkVGbGIwMXNGS2JJYjdUL3FhTmVCSDFZM1NrM1l1?=
 =?utf-8?B?MmZoZkZMZXRYRGZMVUZtaFFObE43SktwTTNaUURVbGlSZEFvRCtENUZQUXhU?=
 =?utf-8?B?WXVkUXRhSmIvVitLeUp2TUg3VnFVQkhNQ1N3NzVqaWJLbzBxRzNxSjlmY1dj?=
 =?utf-8?B?YW9WM1AvaEs5VzdpR2JPMDhEKzhENzNMQ29scGNhbm9QeTRhREdvZ0tnT09J?=
 =?utf-8?B?alkzOUJ4VVlJZG9NQkRVRnZmZlM2RzkvaDFDd1NXWkhNUlJoN0hPK0M0Z05R?=
 =?utf-8?B?VUdlZVFITE0xVm4xK1g2djAyRXZvNG8xTlV6bUQ4LzNyTk43aTFBc1hEVmpU?=
 =?utf-8?B?aUt0R0VMaDFEa1dwcEd5VEFHcTQvNU9la3RFbC83RGt2TEtUc3VEQzNyVVI2?=
 =?utf-8?B?Tk5Qa0JqcEgxOXBpbXZGZ2NmdUVsM2dTUnE0TG80dkNNZFEzYWpHZm1yeHJy?=
 =?utf-8?B?bTUzeE44QXNJbTRObDJWT0JyTU9CTmhUM3VsSmxTR0FrRVRXdzNIRzBpRFBR?=
 =?utf-8?B?TE1uSUdjK3FKZ0Nkcld1c3ptejMwUHNVV2lMTWFuVEQrcUlaOXkzT0x2bmxw?=
 =?utf-8?B?bkEvci9tL3hQMEVZMFI5L0lCZk1GNWhNWHJqcjBrM2hNbHdKdjZTd1FPWWx0?=
 =?utf-8?B?WE5lN0VRc09mQnRBTkZpTUlUcTd6U1NDNDdOTnQrNUl1OHl4WVB3QS9xdlE4?=
 =?utf-8?B?Yzl5SExIOEIxdGhqNjlad2Vlc1ZhbUlYQ2xJOC9LMHlpTnRMYnIxVUcvcDVI?=
 =?utf-8?B?bHdUY05LN1daSmxnTk8zQmpjaTZOK25mb1V3Qlg3Q1VmUXdVZmFnWUhBMW9w?=
 =?utf-8?B?VFA3cVk1K0I0UVR5R1hTeVp4ckJMV0RMeEVlcHdRY0hxUWJmZ2VHWmxTL2J1?=
 =?utf-8?B?T3J6ZnZzdnVhWHc0ZVhaUUszQkh4L2dvM1pvb3UycUw4T0lYSmg5S1N4bE5i?=
 =?utf-8?B?QlcrMkxOZnhLeVdqaHZURFJaL3cyZG4xN1hLNHFhYzN1cE1va2JsZm9jMzJ6?=
 =?utf-8?B?ZU9qSkpkNDU1UzkvQ3VzNWl1MnJWeVRHRHhtZzY1dFcvUU1CbjRTN082eTVr?=
 =?utf-8?Q?JPmbR102LClNSA32JbwPfduCFm2xGR3y?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3613699012)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEY3SjFOaXRjcElPWGYvLy9TWDRrOGlUaEFKbzdNY3o1QzZPSXRldTA4a28y?=
 =?utf-8?B?RVRoWkY5ai9yRkRtWGhjVG9ud3p6OFhqYlVrZUFkTGJPaWVmQUVIMFQ4U0ZZ?=
 =?utf-8?B?VzN6RGc4eS95SzNkcnV0TG92K1ZydEpVR2x1MmdCbTkyeS9KaFh1UXR6RWhQ?=
 =?utf-8?B?VGdJSHpIQ0VIR1JUMFJxOUJBeDFUWW9Vcm9EQzVRalloYUF0ODdLWDN4ci9l?=
 =?utf-8?B?cnNIcS9JbXhkSUJzV2xBVUw4M2dwclJDd3dldjVzRWJYbytIalBCMkptRG54?=
 =?utf-8?B?NHh2bm5sVlpyT1ViV1pHaVFkN0R5MWh1ZlFQQUdwQjBrcVloUlZFVmNuUzNK?=
 =?utf-8?B?dnkrTkkzRjRWQmY4eWs0TXVqRnlFczYwcHd0VVJzN0ZXNURCRTVnTkNZRE9h?=
 =?utf-8?B?L0J4aEI2Uy9jWEVod0pod09GSit5cTZsV3doMmpUNGl5S0l3WUpKVHlXR2ZE?=
 =?utf-8?B?Ym5tSllHY1FXenJ5bHBvaUNCREVJSXRINTcza3dMK0NoZ0VOZGNPN2dSVGJw?=
 =?utf-8?B?ZkpCL0NQVG9jR3BaYUtCSTZVNEIxbjZuWFM0SlJHZllQV05BaktlV1RKcFg3?=
 =?utf-8?B?c0xSL2haNXJzSnBiZ1pKT0RHZlROdDc3Y0JkYm4wazgxeFF2TnlscDE2RVRG?=
 =?utf-8?B?ZWlCNTh4dzRZK2Nnd3BVS0xmbmd6VjY2S280SW9lcENOWG1BTzh4MnU3VEZ1?=
 =?utf-8?B?UkRnTUo3UCtTMjQ0RlhlQUFJcWZTb09TK21hSUhkVE0yUmZ3ODhnbTFJc1Q1?=
 =?utf-8?B?MUNJU2tQVldwWFI4WHZjb2sreUR6Znkrc3NJdUNHMGlOYkkwVVhhRlpEU3d2?=
 =?utf-8?B?OXhKb2VHTHNRUHdMK3hhcXM3cUN3VkZZZHBxalo2SHdySG94cEhmeE1lN0Jq?=
 =?utf-8?B?U3JQcnppaERibE96b2R1NDV2TEM1cG9PZTJKRzVrc1dOR0xrNUdJOG4zMEtj?=
 =?utf-8?B?R0ZRQjZQMWhGZGo0SVBSSVVWMFFCaWhoZ2xEc1JOZ054YkxSMGlRNi93ZW1M?=
 =?utf-8?B?S3ZmNkhGSlZlSEMxQWVPcENqYmJnKzFwbTZPVk43cVloUFF1clFnazh1QjNh?=
 =?utf-8?B?K3pnOHlrWGJKRXRUVmFUM21Rbnh5bklyeXZNWXFRclNDdElFc1hhN0c2NEJW?=
 =?utf-8?B?cE12Y3NyMURCczlVUVN3K0xIeEFHeG0yM0Y4bkZlLzVGc20ybzhqM3FDd2Q5?=
 =?utf-8?B?ZWFYbVFaNUpvclVGdCs1K2MveGVCMjJLYjc1NGdJSEpXUWhMbFBIT3pYQjY1?=
 =?utf-8?B?c3JxU1pwbVlBQTZCTkY0Zi9FVFMveGFmaWFsbVhhbGlsMmYvcFlyMys3Smc5?=
 =?utf-8?B?b0Rid0VaMHZ5U1MxT2F3TlVPelkrL2djVjhHZnFuOWpjVTlKOGg1OUl5T05s?=
 =?utf-8?B?Q004dk9wc284RXJLVlV3dHZHdkltQTRDWUNrYm1qQlduMGwvbGxVc1NWVFFl?=
 =?utf-8?B?NS9hY0lxcE1yL2JpVUo0YXFqRXlTVitLcFJFUlFrRWg4MGNyUVZZaG1uNmR1?=
 =?utf-8?B?eVBVK0gxWmVjeVdXa2d2QlJmczVWLzZtVmJCdjJPT2xNQVlDbkhBY0U1THR2?=
 =?utf-8?B?VmwxN2dlRkZqejdDWjVMWXdSMUVpc3kvSDFvZWtRTEh0UVloM1R3MXE3SklO?=
 =?utf-8?B?dS9tbE5SUUdVL3gxbjd1VVV3aEswNGtkWmY4WkpIbVg4Q0dvb1hSNlA2MVNE?=
 =?utf-8?B?WmRLSmhNYWF2MUtxRnNVSGlZL0puc1haVFVjR1cvN21hdVhhUGVsQUxlcTZp?=
 =?utf-8?B?OUI1NjF6d2ZEeUNlbW43cENpc0MrYWFnTzJDZEI3aFlVRHlabGJ4RzB5bGlz?=
 =?utf-8?B?Q0Z3d1hTK1d4TVovMElYdTV6d01aa1BjOXh4UmJHSVk3eUJ4OWV5VXNqN1Nl?=
 =?utf-8?B?RDlST05XT1pDWjhYeVR0TkpZMUg4RlNJRFRUNnpWdC9pOE9LQmZNbkdSL2pN?=
 =?utf-8?B?QVpaRWRMeDBMckRaaVIveTJQdk5YODhTOXc3N2FST0lTOEdIY28xRm9VaGla?=
 =?utf-8?B?b3JVRkszYjJZVlcyU25PcS81NVB5anVwcFIyOEJHU0tYajhPYTNld0NKRXky?=
 =?utf-8?B?S2ZqU0ZkeXNlZTAwSzBvYkxkNkM3M2RQMzhoODM2YzFOQXFNZnZLRUNFd1RR?=
 =?utf-8?B?dkZxOUcwTVAyTVp2YjdVQ1R0bWIySzI5QU1kNCtNK1E0bWx0dkI2MEdxUUl0?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D1CC4C66D456E4FB812E67DF502CD61@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667fd62d-e3eb-4046-54f9-08dd0db3d0fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 00:46:51.2568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8UtVZ4ZtOtJCMGURnCLeyMerfIq8g886dW7u2fEkjGB6a3jfaaQWuWYdGuv5wTAFEfKAds4rvrJXZN/a/IB0Jm4Ia5jBylFexWQArishD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7705
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTExLTIxIGF0IDE5OjUxICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiA9PXBy
b3Bvc2FsIGRldGFpbHM9PQo+IAo+IFRoZSBwcm9wb3NhbCBkaXNjdXNzZXMgU0VQVC1yZWxhdGVk
IGFuZCBUTEItZmx1c2gtcmVsYXRlZCBTRUFNQ0FMTHMKPiB0b2dldGhlciB3aGljaCBhcmUgcmVx
dWlyZWQgZm9yIHBhZ2UgaW5zdGFsbGF0aW9uIGFuZCB1bmluc3RhbGxhdGlvbi4KPiAKPiBUaGVz
ZSBTRUFNQ0FMTHMgY2FuIGJlIGRpdmlkZWQgaW50byB0aHJlZSBncm91cHM6Cj4gR3JvdXAgMTog
dGRoX21lbV9wYWdlX2FkZCgpLgo+IMKgwqDCoMKgwqDCoMKgwqAgVGhlIFNFQU1DQUxMIGlzIGlu
dm9rZWQgb25seSBkdXJpbmcgVEQgYnVpbGQgdGltZSBhbmQgdGhlcmVmb3JlCj4gwqDCoMKgwqDC
oMKgwqDCoCBLVk0gaGFzIGVuc3VyZWQgdGhhdCBubyBjb250ZW50aW9uIHdpbGwgb2NjdXIuCj4g
Cj4gwqDCoMKgwqDCoMKgwqDCoCBQcm9wb3NhbDogKGFzIGluIHBhdGNoIDEpCj4gwqDCoMKgwqDC
oMKgwqDCoCBKdXN0IHJldHVybiBlcnJvciB3aGVuIFREWF9PUEVSQU5EX0JVU1kgaXMgZm91bmQu
Cj4gCj4gR3JvdXAgMjogdGRoX21lbV9zZXB0X2FkZCgpLCB0ZGhfbWVtX3BhZ2VfYXVnKCkuCj4g
wqDCoMKgwqDCoMKgwqDCoCBUaGVzZSB0d28gU0VBTUNBTExzIGFyZSBpbnZva2VkIGZvciBwYWdl
IGluc3RhbGxhdGlvbi4gCj4gwqDCoMKgwqDCoMKgwqDCoCBUaGV5IHJldHVybiBURFhfT1BFUkFO
RF9CVVNZIHdoZW4gY29udGVuZGluZyB3aXRoIHRkaF92cF9lbnRlcigpCj4gCSAoZHVlIHRvIDAt
c3RlcCBtaXRpZ2F0aW9uKSBvciBURENBTExzIHRkZ19tZW1fcGFnZV9hY2NlcHQoKSwKPiAJIHRk
Z19tZW1fcGFnZV9hdHRyX3JkL3dyKCkuCgpXZSBkaWQgdmVyaWZ5IHdpdGggVERYIG1vZHVsZSBm
b2xrcyB0aGF0IHRoZSBURFggbW9kdWxlIGNvdWxkIGJlIGNoYW5nZWQgdG8gbm90CnRha2UgdGhl
IHNlcHQgaG9zdCBwcmlvcml0eSBsb2NrIGZvciB6ZXJvIGVudHJpZXMgKHRoYXQgaGFwcGVuIGR1
cmluZyB0aGUgZ3Vlc3QKb3BlcmF0aW9ucykuIEluIHRoYXQgY2FzZSwgSSB0aGluayB3ZSBzaG91
bGRuJ3QgZXhwZWN0IGNvbnRlbnRpb24gZm9yCnRkaF9tZW1fc2VwdF9hZGQoKSBhbmQgdGRoX21l
bV9wYWdlX2F1ZygpIGZyb20gdGhlbT8gV2Ugc3RpbGwgbmVlZCBpdCBmb3IKdGRoX3ZwX2VudGVy
KCkgdGhvdWdoLgoKCj4gCj4gwqDCoMKgwqDCoMKgwqDCoCBQcm9wb3NhbDogKGFzIGluIHBhdGNo
IDEpCj4gwqDCoMKgwqDCoMKgwqDCoCAtIFJldHVybiAtRUJVU1kgaW4gS1ZNIGZvciBURFhfT1BF
UkFORF9CVVNZIHRvIGNhdXNlIFJFVF9QRl9SRVRSWQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRv
IGJlIHJldHVybmVkIGluIGt2bV9tbXVfZG9fcGFnZV9mYXVsdCgpL2t2bV9tbXVfcGFnZV9mYXVs
dCgpLgo+IMKgwqDCoMKgwqDCoMKgwqAgCj4gwqDCoMKgwqDCoMKgwqDCoCAtIEluc2lkZSBURFgn
cyBFUFQgdmlvbGF0aW9uIGhhbmRsZXIsIHJldHJ5IG9uIFJFVF9QRl9SRVRSWSBhcwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGxvbmcgYXMgdGhlcmUgYXJlIG5vIHBlbmRpbmcgc2lnbmFscy9pbnRl
cnJ1cHRzLgo+IAo+IMKgwqDCoMKgwqDCoMKgwqAgVGhlIHJldHJ5IGluc2lkZSBURFggYWltcyB0
byByZWR1Y2UgdGhlIGNvdW50IG9mIHRkaF92cF9lbnRlcigpCj4gwqDCoMKgwqDCoMKgwqDCoCBi
ZWZvcmUgcmVzb2x2aW5nIEVQVCB2aW9sYXRpb25zIGluIHRoZSBsb2NhbCB2Q1BVLCB0aGVyZWJ5
Cj4gwqDCoMKgwqDCoMKgwqDCoCBtaW5pbWl6aW5nIGNvbnRlbnRpb25zIHdpdGggb3RoZXIgdkNQ
VXMuIEhvd2V2ZXIsIGl0IGNhbid0Cj4gwqDCoMKgwqDCoMKgwqDCoCBjb21wbGV0ZWx5IGVsaW1p
bmF0ZSAwLXN0ZXAgbWl0aWdhdGlvbiBhcyBpdCBleGl0cyB3aGVuIHRoZXJlJ3JlCj4gwqDCoMKg
wqDCoMKgwqDCoCBwZW5kaW5nIHNpZ25hbHMvaW50ZXJydXB0cyBhbmQgZG9lcyBub3QgKGFuZCBj
YW5ub3QpIHJlbW92ZSB0aGUKPiDCoMKgwqDCoMKgwqDCoMKgIHRkaF92cF9lbnRlcigpIGNhdXNl
ZCBieSBLVk1fRVhJVF9NRU1PUllfRkFVTFQuCj4gCj4gwqDCoMKgwqDCoMKgwqDCoCBSZXNvdXJj
ZXPCoMKgwqAgU0hBUkVEwqAgdXNlcnPCoMKgwqDCoMKgIEVYQ0xVU0lWRSB1c2Vycwo+IMKgwqDC
oMKgwqDCoMKgwqAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCj4gwqDCoMKgwqDCoMKgwqDCoCBTRVBUIHRyZWXCoCB0ZGhfbWVtX3Nl
cHRfYWRkwqDCoMKgwqAgdGRoX3ZwX2VudGVyKDAtc3RlcCBtaXRpZ2F0aW9uKQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkaF9tZW1fcGFnZV9hdWcKPiDCoMKgwqDC
oMKgwqDCoMKgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQo+IMKgwqDCoMKgwqDCoMKgwqAgU0VQVCBlbnRyecKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbWVtX3NlcHRfYWRkIChIb3N0IGxvY2sp
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRoX21lbV9wYWdlX2F1ZyAoSG9zdCBsb2NrKQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkZ19tZW1fcGFnZV9hY2NlcHQgKEd1ZXN0IGxvY2sp
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRnX21lbV9wYWdlX2F0dHJfcmQgKEd1ZXN0IGxv
Y2spCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRnX21lbV9wYWdlX2F0dHJfd3IgKEd1ZXN0
IGxvY2spCj4gCj4gR3JvdXAgMzogdGRoX21lbV9yYW5nZV9ibG9jaygpLCB0ZGhfbWVtX3RyYWNr
KCksIHRkaF9tZW1fcGFnZV9yZW1vdmUoKS4KPiDCoMKgwqDCoMKgwqDCoMKgIFRoZXNlIHRocmVl
IFNFQU1DQUxMcyBhcmUgaW52b2tlZCBmb3IgcGFnZSB1bmluc3RhbGxhdGlvbiwgd2l0aAo+IMKg
wqDCoMKgwqDCoMKgwqAgS1ZNIG1tdV9sb2NrIGhlbGQgZm9yIHdyaXRpbmcuCj4gCj4gwqDCoMKg
wqDCoMKgwqDCoCBSZXNvdXJjZXPCoMKgwqDCoCBTSEFSRUQgdXNlcnPCoMKgwqDCoMKgIEVYQ0xV
U0lWRSB1c2Vycwo+IMKgwqDCoMKgwqDCoMKgwqAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gwqDCoMKgwqDCoMKgwqDCoCBURENT
IGVwb2NowqDCoMKgIHRkaF92cF9lbnRlcsKgwqDCoMKgwqAgdGRoX21lbV90cmFjawo+IMKgwqDC
oMKgwqDCoMKgwqAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCj4gwqDCoMKgwqDCoMKgwqDCoCBTRVBUIHRyZWXCoCB0ZGhfbWVtX3Bh
Z2VfcmVtb3ZlwqAgdGRoX3ZwX2VudGVyICgwLXN0ZXAgbWl0aWdhdGlvbikKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB0ZGhfbWVtX3JhbmdlX2Jsb2NrwqDCoCAKPiDCoMKgwqDCoMKgwqDCoMKg
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQo+IMKgwqDCoMKgwqDCoMKgwqAgU0VQVCBlbnRyecKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB0ZGhfbWVtX3JhbmdlX2Jsb2NrIChIb3N0IGxvY2spCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRoX21lbV9wYWdlX3JlbW92ZSAoSG9zdCBsb2NrKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkZ19tZW1fcGFnZV9hY2NlcHQgKEd1ZXN0IGxvY2spCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRnX21lbV9wYWdlX2F0dHJfcmQgKEd1ZXN0IGxvY2sp
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRnX21lbV9wYWdlX2F0dHJfd3IgKEd1ZXN0IGxv
Y2spCj4gCj4gwqDCoMKgwqDCoMKgwqDCoCBQcm9wb3NhbDogKGFzIGluIHBhdGNoIDIpCj4gwqDC
oMKgwqDCoMKgwqDCoCAtIFVwb24gZGV0ZWN0aW9uIG9mIFREWF9PUEVSQU5EX0JVU1ksIHJldHJ5
IGVhY2ggU0VBTUNBTEwgb25seQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9uY2UuCj4gwqDCoMKg
wqDCoMKgwqDCoCAtIER1cmluZyB0aGUgcmV0cnksIGtpY2sgb2ZmIGFsbCB2Q1BVcyBhbmQgcHJl
dmVudCBhbnkgdkNQVSBmcm9tCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW50ZXJpbmcgdG8gYXZv
aWQgcG90ZW50aWFsIGNvbnRlbnRpb25zLgo+IAo+IMKgwqDCoMKgwqDCoMKgwqAgVGhpcyBpcyBi
ZWNhdXNlIHRkaF92cF9lbnRlcigpIGFuZCBURENBTExzIGFyZSBub3QgcHJvdGVjdGVkIGJ5Cj4g
wqDCoMKgwqDCoMKgwqDCoCBLVk0gbW11X2xvY2ssIGFuZCByZW1vdmVfZXh0ZXJuYWxfc3B0ZSgp
IGluIEtWTSBtdXN0IG5vdCBmYWlsLgoKVGhlIHNvbHV0aW9uIGZvciBncm91cCAzIGFjdHVhbGx5
IGRvZXNuJ3QgbG9vayB0b28gYmFkIGF0IGFsbCB0byBtZS4gQXQgbGVhc3QKZnJvbSBjb2RlIGFu
ZCBjb21wbGV4aXR5IHdpc2UuIEl0J3MgcHJldHR5IGNvbXBhY3QsIGRvZXNuJ3QgYWRkIGFueSBs
b2NrcywgYW5kCmxpbWl0ZWQgdG8gdGhlIHRkeC5jIGNvZGUuIEFsdGhvdWdoLCBJIGRpZG4ndCBl
dmFsdWF0ZSB0aGUgaW1wbGVtZW50YXRpb24gCmNvcnJlY3RuZXNzIG9mIHRkeF9ub192Y3B1c19l
bnRlcl9zdGFydCgpIGFuZCB0ZHhfbm9fdmNwdXNfZW50ZXJfc3RvcCgpIHlldC4KCldlcmUgeW91
IGFibGUgdG8gdGVzdCB0aGUgZmFsbGJhY2sgcGF0aCBhdCBhbGw/IENhbiB3ZSB0aGluayBvZiBh
bnkgcmVhbApzaXR1YXRpb25zIHdoZXJlIGl0IGNvdWxkIGJlIGJ1cmRlbnNvbWU/CgpPbmUgb3Ro
ZXIgdGhpbmcgdG8gbm90ZSBJIHRoaW5rLCBpcyB0aGF0IGdyb3VwIDMgYXJlIHBhcnQgb2Ygbm8t
ZmFpbCBvcGVyYXRpb25zLgpUaGUgY29yZSBLVk0gY2FsbGluZyBjb2RlIGRvZXNuJ3QgaGF2ZSB0
aGUgdW5kZXJzdGFuZGluZyBvZiBhIGZhaWx1cmUgdGhlcmUuIFNvCmluIHRoaXMgc2NoZW1lIG9m
IG5vdCBhdm9pZGluZyBjb250ZW50aW9uIHdlIGhhdmUgdG8gc3VjY2VlZCBiZWZvcmUgcmV0dXJu
aW5nLAp3aGVyZSBncm91cCAxIGFuZCAyIGNhbiBmYWlsLCBzbyBkb24ndCBuZWVkIHRoZSBzcGVj
aWFsIGZhbGxiYWNrIHNjaGVtZS4K

