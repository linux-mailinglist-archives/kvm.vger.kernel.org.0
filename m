Return-Path: <kvm+bounces-12605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C924C88AA96
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4337322C00
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B19768E5;
	Mon, 25 Mar 2024 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FU/SqZmT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED661763FB;
	Mon, 25 Mar 2024 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380806; cv=fail; b=eq+fiyIwFiQ2wa1ttp2VWegO53+2n5LoTXUxIruRMlTm64g8qUwUjwbP0kS/OjiEWiSsntApcwtapvXYdthXJhFjpH2hT4fOTEeOruCaWE+4Wj+PkQYyiOpvucXSHRzBJOqAwDv9VO8fXImBIoTSHOYxjkhKVW3wsUJzdW1k+YA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380806; c=relaxed/simple;
	bh=5vt2DwN8XRiFOuxSPm8hYAVKTUjdchTu3EtraJhOpj8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ODaJ8aELcJyXC2vt7gJGOhfHArcaIQAGOHYK3mN4JTP1DnApxAAYDzlnprjZSRU8fxPQLK0jZ420NsHWuqNUWJ1jAC4w0G9xnaZfUu582EbBYgiQ5yPc0OvXBsw5ifWWYGXZQuM5l/7HmfTcZw4E3Fz4Wj/cTEvKI4+tCVe2wGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FU/SqZmT; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711380805; x=1742916805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5vt2DwN8XRiFOuxSPm8hYAVKTUjdchTu3EtraJhOpj8=;
  b=FU/SqZmTdobNazQS4eMZmFS+kswHoSZcuaGi/6FSOYa7za/iKk5Fa5no
   CY0kM3l6XtOuaIFTCOJRvRO+KYu3VCyg6LWzFShfieiDWpPTFN2YlIAGz
   wEhSlr18QVOeyx7Z87KWVN9kEsSWQGbFIOdgxRtYWSq+tnwkvMlF95xT3
   JOVK/SlgeJh+Po3yJb30zMgLGyfd8S7gAOcxE/gbPh+PE95IzYY4jbME9
   AiCUyJ1ED4GSsdI5SVm+neA6IBWdLGqwfuHc+ha4iG/iUvi/lFCFJXvea
   q6dB+fWdL14CHYLBFjlxr0WZG6D00OVvSiNOIyvxCpTR3DVklwnwceGiU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="17784748"
X-IronPort-AV: E=Sophos;i="6.07,153,1708416000"; 
   d="scan'208";a="17784748"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 08:33:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,153,1708416000"; 
   d="scan'208";a="20332070"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 08:33:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 08:33:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 08:33:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 08:33:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWvcHsaaP3dDvZqtZi5dmQ7WO9SpvDd1JKLiTsGthB3B8hlTRlPdj+mXfJVJiGglA1k3rLIz5u/AIHw/hro/DxPOd8R5sQlnuvgtmMGlUblAyCisI6cPuc378UFB0Ha5TvuJXRNHX6ZuaiLlI1BZSozWUOZmbuUfr7euCDySU9az8ko+ex//ygODPFgRtUIl3PA0v7cbkfpgfp5h27IGLSq9rQ/ij3Nb7K4D4Gl6RFCBReROWUbLgqz5tu8WeO5DvqwuimGvx5nsnpKkLI09ssscg4cQzcnrQyFN7P+2Fb5Q3vbaFPxx9KD+2HJPR1GJGLKIkQwKWRnAINCOgH7cQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vt2DwN8XRiFOuxSPm8hYAVKTUjdchTu3EtraJhOpj8=;
 b=bczQV/L/0sr0Kr3f7F6GLJ0kzOU1QDV42IJycCdDLPiKlXPZCCi+ksfi93VoX7RtZL1DI+LYqBhDVUEkAsbQtW73G8tbxWw+Ti4UiPhHda5shnVbv4MFj7pF4tcJrQD7+ZAiy8n0VUDbkDUK29T/TZgiBd11bOUUIeoDqlNDqQc8s2Mc+//7KthslY2L/2qx58yRCUNBAb4s/YjD2IPzJBUPlsqaeLmojBs2rNtYTmQUi4GdTQJgwvnnEp+1F5PbsL4oj0oEyUZfAwhlhT1eneef1tTsf+U/lvJCaBCFgduUoh4EpZNFTMEHhLM2M056He2IFgXs8RABDjxeDgYtCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4597.namprd11.prod.outlook.com (2603:10b6:208:268::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 15:32:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 15:32:59 +0000
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
Thread-Index: AQHadnriF1ZBxh+AQEWxyxeO2jbjmbFC3WOAgACFwQCAAJXAgIAEZVGAgABIQgA=
Date: Mon, 25 Mar 2024 15:32:59 +0000
Message-ID: <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
	 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
	 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
	 <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
In-Reply-To: <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4597:EE_
x-ms-office365-filtering-correlation-id: 8e04fbd3-3100-478a-792f-08dc4ce0da21
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SfN4I/n2novtNf8d8xo7ccy1q5QJpWCZQEZZn4Ha6yKa5Jd28h1Az8F0TGrlJMM98697WQ1fce+7zwITBszLnOA6wG9P/sl6j/NCImDMDFEcw30Is/U4/vkva1zBSBuCm3n6DsRPK+fM6RJjcb3G5tFQGniLF01S+B20Ahmwe9HJuad7DNzdpAq6MiPatCJmQpqAsXcE1a/ukdFY2JK2ZDxBJTi3iZHik1mZYZg2EQO2cWmPPuXiVBSzF1sUGF6xNkUDbPCwlWby5PKsNKxZ1cSiA5wKUrUYAA2VteLGvWOaeoK0nWSmYz9v3vA00PKx8FGhg7sb39WmnUf46SRCIFe3gChZdJjv8Y5C+j+CH9ReoZIb1/HpPLGnyvL8EyvFcTA5QxSFnizE45uutjh/z9Pb9ZCI+VqaPsjlfk9V/KrHQ3rfRoHn8Zu/Apvt+flNwf88RX5MPu/GKhTY3mdb44ptGjcDupe7/XGbnZq0FedyHPSgclYc8zHKnfkZtpiUrqIZdQ7RtZ/W+5OO/VyFMpH7re6GYMVIXex2QYXeNBGKPxwMdnHytKRBLJo8J4AssQM1Dokqj3JOIp7MSe6PWdHbd2WmH5XNRdwwI4okXPPYbR+oli/QwmsnKWOM9jT8iH5nPEDT0za1iIBi/9VQumsFG1xPhRYqc57lPeLpHKoCVlKDYBIraS3ZDDpY9VzotHiJCOcGPz/72x0JX+wlOeEr68IW1CBVeWgUx9e7zpc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1hzdldsaGJxanVIY29TK0RjNW1hNVZTL3R6NWNKSzFIekhDaURRZ3RNczRx?=
 =?utf-8?B?c1Rpc0NLQUJBQkJya3FmQjJySFA1aXhOY1JhTm9pNWFDMU1XRGNKL05ValA2?=
 =?utf-8?B?Y1BQMXdWOEFWcHdPNmoxZWtRVjAxdU12ektoUlpmTUtZRERSV0QwL2szazAr?=
 =?utf-8?B?OVVSckJLTjBZbGtMRXpEVzJ3YUdxWDl1T0JOaHVOZkNRWFNmeVBOdDJZMUlo?=
 =?utf-8?B?WEliSlc2c2lma2Z5V3VzRkJWa2Z1emkvekx5bU9WZ1BUanhKUURPOEk0bU1U?=
 =?utf-8?B?bzJVQ3NGdy9jd3RQaXNIVlI4MXlEYmw0VXRGV3VrODk0ZWtXRXRpeTZCVGE3?=
 =?utf-8?B?NGpRc01JeEdQZzBNUHdCZmRaM3gvRHA1YU5CaVY2YTJ6UFVDOEwvQXlxT1c5?=
 =?utf-8?B?cmp5dFJ5akJvelNUSFpPclZNOE00YlI0STJYTHFyR3RERE5yalVPSHducFo4?=
 =?utf-8?B?a3hXMStQUU1qYldscDZRUEJ5a2lXa1JoZ29Zd1hmcGNIQmtvNEVpcVBoYXYx?=
 =?utf-8?B?M0VwaFJqZEJ1NzNZMTFOZHh1ZFJUM0NDelhTcGRrZWJrUnErSmFzc0I2YW43?=
 =?utf-8?B?alMwRi9hVFBhRmRJQ3BVS0hXc3pKc29CN3dwenpsMlNRYTZRQkcxU05QeE9N?=
 =?utf-8?B?SHpjWTNYZGVZL3ovS0l6SnZuTnZsMUVkenZGcWRLYUd5cnNCdFZINzd1bnVE?=
 =?utf-8?B?MWpjUWlSRVNqTWpDcWZDdWs2VHZQdlpFRm14QnRidGhpRmNiT0pRL2x6SG9Y?=
 =?utf-8?B?K1U5T2w2WFUxek5sdDVLQjUvOS9uK0xiOXptNWZGWnEvWW10T2J0MlFlYjdu?=
 =?utf-8?B?L014ODJyOFZ5YlhvNlBPcVVvc3Vqc21LTHlsN3VrR3hPNkM0eUV2TEtadSt0?=
 =?utf-8?B?cEFZNDhtSnp0dzJhRUVQV2JyLzAvb1dCR0lDbTEwRDFXNGx4ZE9yTmZvcFJm?=
 =?utf-8?B?VDkxVXlpQU9iVDllNHNEemEvUW51dGNTUS9JbEV0SnZOTUhpcmZzWjIvQnVo?=
 =?utf-8?B?ejhJTVZDTU5Hb0JnWWEvdi9jQ0FrbERjaWE4M0MxcUgrd3dPOW1xU3pubzNn?=
 =?utf-8?B?ZzRaQkcyWStMcjNlTzBEWWEwVXRmRFJ0YzdkWXpHVDMvdGJpWDd1MmlYR1pK?=
 =?utf-8?B?NVk0d1IzeHpObVgvRW5DTTFnL3EzVWt5a01sUW9TalEvMHY2ZVRPYWxTbDhS?=
 =?utf-8?B?RjFhZHJpZDBvQi8rS0NoUUt6ajR4UEMxL2hNZzNOeG84Sit1Zm5NZXp4ekc4?=
 =?utf-8?B?dDM0a2k3Rld6TEFFU21GZ3lwb0ZJamRoQzdibVNRdEIzVEN4UFdVUWhKQnd5?=
 =?utf-8?B?RFE3NU1aWjYxRHJxRFQ0QUxBZkE4aHU1bC9iOUxpOFg2QzlMY01rVStON2ps?=
 =?utf-8?B?MU1HTXYxTmhram05dkhJSjEvSTJkK1hnMkJXNnloRFNiUU1veVREZE9JQ2t6?=
 =?utf-8?B?SVk3VDFvYjdNSUVnU0VBR0RtYlNBVkxhOVJwRVRjQVMyditNT2l5WkNtZGFp?=
 =?utf-8?B?MHhBN3MzKzBvajRKUnZneUxiTGxsdjRiWVNReGtOOGxaaTZjdzM3RTBsbnF0?=
 =?utf-8?B?Wk9QNkV3SGlLWmx3WFZEaC9KSWxQalBEYTZ1dDlIY2Rod0wvazJsejhHVVRC?=
 =?utf-8?B?cEUzV2hOQ1JIeVN0WTRKSFFkZ1FQQS9RTXdzM1ZxdDZEbXBXYTRBUHBrekdO?=
 =?utf-8?B?b1VhV2xZSlFtL0NjS014T0lCTk1BbElBWEtIMWdxOVFUZDNBU3QxdW9qeStW?=
 =?utf-8?B?YzRLSXlpY1czMDBqbUc1SHNDemducFhYZEhGRG5WcHRkRzNBT3JSMzkxUXVF?=
 =?utf-8?B?U0dsdFg1Y2F3UkpDU0RGcG1YRG1FVXlETUdWdFY0SkNjUEgyeTdmTkx1S00y?=
 =?utf-8?B?cmpHSVVIdm9hYityL01FUHV4aFRRSVdtZXFTaUZRQjQyZEVWSENEcWNFWWxP?=
 =?utf-8?B?UStSNkJuckZHMzFDbFFKb2I4UG5EUkVMbVNYTzEvM001UUN3ajNaamJ0UVVB?=
 =?utf-8?B?Rk50K2YyRDA3YkpwZDVwOFZENXJjRVdicmhkL3Y1aVdZMnZSSDZXazhpUWpl?=
 =?utf-8?B?TVFkVGk2TWM4cm9EMk1yMWdXNnlNQitaem01dUJIdVFPY2E1eHhUc3M4K1RX?=
 =?utf-8?B?b1VGQTNzajM0NlpUcCt1Ym5tMGcxOVhPL3pNUTRYK1AzUkRlaW04VldvVnNB?=
 =?utf-8?B?SkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D802CD61998084DAC77030AF63A99C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e04fbd3-3100-478a-792f-08dc4ce0da21
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 15:32:59.5347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyPfbSc63qeUj3Q4vX+GwWb0LGkkL3ioiM/AkmcwsXp4OPXvMFZCS9dxdtphPVYvrXleBLSps+hswqVXIflP6u00A8wEnEcX5ihsYQPo62s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4597
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTI1IGF0IDExOjE0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBU
byBjb25maXJtLCBJIG1lYW4geW91IHdhbnQgdG8gc2ltcGx5IG1ha2UgS1ZNX1NFVF9DUFVJRDIg
cmV0dXJuIGVycm9yIGZvciBURFgNCj4gZ3Vlc3Q/DQo+IA0KPiBJdCBpcyBhY2NlcHRhYmxlIHRv
IG1lLCBhbmQgSSBkb24ndCBzZWUgYW55IGNvbmZsaWN0IHdpdGggU2VhbidzIGNvbW1lbnRzLg0K
PiANCj4gQnV0IEkgZG9uJ3Qga25vdyBTZWFuJ3MgcGVyZmVyZW5jZS7CoCBBcyBoZSBzYWlkLCBJ
IHRoaW5rwqAgdGhlIGNvbnNpc3RlbmN5DQo+IGNoZWNraW5nIGlzIHF1aXRlIHN0cmFpZ2h0LWZv
cndhcmQ6DQo+IA0KPiAiDQo+IEl0J3Mgbm90IGNvbXBsaWNhdGVkIGF0IGFsbC7CoCBXYWxrIHRo
cm91Z2ggdGhlIGxlYWZzIGRlZmluZWQgZHVyaW5nDQo+IFRESC5NTkcuSU5JVCwgcmVqZWN0IEtW
TV9TRVRfQ1BVSUQgaWYgYSBsZWFmIGlzbid0IHByZXNlbnQgb3IgZG9lc24ndCBtYXRjaA0KPiBl
eGFjdGx5Lg0KPiAiDQo+IA0KWWVhLCBJJ20ganVzdCB0aGlua2luZyBpZiB3ZSBjb3VsZCB0YWtl
IHR3byBwYXRjaGVzIGRvd24gdG8gb25lIHNtYWxsIG9uZSBpdCBtaWdodCBiZSBhIHdheSB0bw0K
ZXNzZW50aWFsbHkgYnJlYWsgb2ZmIHRoaXMgd29yayB0byBhbm90aGVyIHNlcmllcyB3aXRob3V0
IGFmZmVjdGluZyB0aGUgYWJpbGl0eSB0byBib290IGEgVEQuIEl0DQoqc2VlbXMqIHRvIGJlIHRo
ZSB3YXkgdGhpbmdzIGFyZSBnb2luZy4NCg0KPiBTbyB0byBtZSBpdCdzIG5vdCBhIGJpZyBkZWFs
LiANCj4gDQo+IEVpdGhlciB3YXksIHdlIG5lZWQgYSBwYXRjaCB0byBoYW5kbGUgU0VUX0NQVUlE
MjoNCj4gDQo+IDEpIGlmIHdlIGdvIG9wdGlvbiAxKSAtLSB0aGF0IGlzIHJlamVjdCBTRVRfQ1BV
SUQyIGNvbXBsZXRlbHkgLS0gd2UgbmVlZCB0byBtYWtlDQo+IHZjcHUncyBDUFVJRCBwb2ludCB0
byBLVk0ncyBzYXZlZCBDUFVJRCBkdXJpbmcgVERILk1ORy5JTklULg0KDQpBaCwgSSBtaXNzZWQg
dGhpcyBwYXJ0LiBDYW4geW91IGVsYWJvcmF0ZT8gQnkgZHJvcHBpbmcgdGhlc2UgdHdvIHBhdGNo
ZXMgaXQgZG9lc24ndCBwcmV2ZW50IGEgVEQNCmJvb3QuIElmIHdlIHRoZW4gcmVqZWN0IFNFVF9D
UFVJRCwgdGhpcyB3aWxsIGJyZWFrIHRoaW5ncyB1bmxlc3Mgd2UgbWFrZSBvdGhlciBjaGFuZ2Vz
PyBBbmQgdGhleSBhcmUNCm5vdCBzbWFsbD8NCg0KDQoNCg==

