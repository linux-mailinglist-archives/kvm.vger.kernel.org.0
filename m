Return-Path: <kvm+bounces-12477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD984886944
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 10:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A15289C31
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 09:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B24B3EA71;
	Fri, 22 Mar 2024 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4Brjt2m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1B3D566;
	Fri, 22 Mar 2024 09:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711099756; cv=fail; b=Kw/I9Pn6iOHqaQWcUytzVBHZ+5zDiJ9Qt9Ay+dIg0t/77zMu49i9GTMUEJurYCiCSp6vhfNS7vaIOGK22XRgR1at6iPMPxUL4VTt3SxAEa+IXMX5KeASWth1JogQBvVyxWS+WHOnlYrLmqdL7ORy0TfrggoVv0xDtmcEpN1m7Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711099756; c=relaxed/simple;
	bh=oH4WovRA8UTEIJX9qF2AmTVSQJ7GZDMAKUorbv4nHLw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZQHiUSrAbTFB1E4Y77f/az6iGwhCnlhwB32KlDZy7vg3OUOfiv+XKWpzVo2Mu0CT1KOYhWxB2AFCtEpyJ1q7DeflOIuaSdAvPZkzkgXWuHgttdqfINJMiQfpV0SZwyEEprr1zSYMpwpEonjscohdY7w5fMcrRSuXKdQ7/jW3uZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V4Brjt2m; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711099755; x=1742635755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oH4WovRA8UTEIJX9qF2AmTVSQJ7GZDMAKUorbv4nHLw=;
  b=V4Brjt2mz1zePFOc368XYv6f8NvqvLGbD5jDyns6Wm/WoJNMOqt4IXdd
   ghBKqSdWHQPE1f5qDUSngKFdQCxQO9nveIC5c0SmFarPkJ59LyExtdR3x
   7sQyoSnJYy3pqRStvfdVSXig3ZYFs6n609dXkthaf2wNLMPqKePE59Lsr
   PSEzZan+3U7kxmoTtnUyvmTzhJo7ey0JMD1gHUrd1lDWgSAXL40ltWKJT
   HUJKToKdOnAJgUOofwW0koYV2SGUzdcFbe6L71Y7GO5XwKZCguSFtGana
   cLiBG8g3MTs/v4oqUjrpY+JBe1VvUCvLYLB4SJTHu2/QP3nWDOTQhZoNd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6032662"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6032662"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 02:29:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="14939476"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 02:29:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 02:29:13 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 02:29:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 02:29:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 02:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H211cCZkBhAROzBL7ooBHQ1u3kBBfqfgcUkd3MYitEcdM8OX8Can+AXwg6WhMUl6c8Tb6ufiTnh6YkBPSQkY25GwTiTGdaJR/JlPwxHt8Mtb1XOIFfIOot5J9i/BPt00RtAuTd/xOd8buKHTtyvT8WWN73Kpd2/LviolpAtm6kiXxCPwd93D/rcUiurg7iSGeOZmo9u29Qn9OFZef/PQwaTDzwnqyD3T1QojEnv9xaKGBF13SAMzsJZdarlApRMq1QsTo128V+qPtEePRhTO28Evw47S/oTPt+aA2dehSurAAUsv5AzlkWbI5LGEjal5rI6tn0f2XR1q7AEP/DSvbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oH4WovRA8UTEIJX9qF2AmTVSQJ7GZDMAKUorbv4nHLw=;
 b=Mef4rVZrVuOJXqzMRfw7PHLhIvn1mVJrZoJUj4jMi2+J1zVX4/5D199LytWbJcfZ7Tt9rs9b2zL/oMpMGaI+hSH+SdpA/DEhaOTRJKxbw4nYTSRGv5D4OYKQtZs+fjNRTDg8jjhOGm+8HShdGzgV96TyWRyHL5Km5mTz/PB55RnHuPlipW9S8bd2IDltTIYHA2kT2joNwCP+1Wa1w09oWSsY6jl/C0h44AgLHuRaFQn757KvSF+JAESwKowJYbni/7vQ0QXdLBA8eh9aWodvsZtzq/hLGpCGuwvtj9wILJg4i3JMq/78qElK6ICelSqHYSCDDm9o/nircJ96gaqNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17)
 by DS0PR11MB7621.namprd11.prod.outlook.com (2603:10b6:8:143::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.23; Fri, 22 Mar
 2024 09:29:05 +0000
Received: from BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::19b3:3083:fb8a:85a0]) by BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::19b3:3083:fb8a:85a0%5]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 09:29:05 +0000
From: "Ma, Yongwei" <yongwei.ma@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: RE: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Thread-Topic: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Thread-Index: AQHacb6DIVLYPr146U+t89CC70+ssbFDkiTg
Date: Fri, 22 Mar 2024 09:29:04 +0000
Message-ID: <BL1PR11MB536847E1836C28C941EDE8AD89312@BL1PR11MB5368.namprd11.prod.outlook.com>
References: <20240309010929.1403984-1-seanjc@google.com>
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5368:EE_|DS0PR11MB7621:EE_
x-ms-office365-filtering-correlation-id: b64af15f-6004-4b22-aa3d-08dc4a528475
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eg2Q0TskzZLDNY7nj457fRFPQ0voEx/v42LImlUk0TbCXmEeD3cwAMzqqjNmSc7A/qqw2M8fEjt88HHr23K6+wFWEFzfJ0exB8rItFhEJZVrzhWQaNwrlg3NAO+cRL+MipuAwK575CnMAMOsaWGRujc/R92MkE9OWBQMafw173d1yLDFvwrosJFRDEm5Paib9f9zPPto6ZpfY4grpxpWQjcLRwBbdnMLzl9EoiAHFoGboM1E3ZwVvYlNk9tYqgd2WT9nA9wEnlwYzRPtppWAhUWLtPndWy1uHmGofGIeG7QgJwd7TbUF66B6ftRLj+YpR9CiGbWYuzM2vBfBzqWemsXbWrLxy+amSWOmx/kGQWUyrgee+o9nFORYVM0nfaPhyrTZnlqdopgJghBS5nVjDbbZ/p2jIhKQyzDzTS08/eP4felVd85Z6Uytd/zF/ePt2ed84ERz6MvcIHC1cbfEps61pKu75/Q52II+OFwul3dEGCxkYeDIO85YEljL9XGLOMpwMVtTxMOQVDcAsaMgF3goKOFk1DyoFrrTSLLTia9RTuYX4A8gaZ9eEqLew62hlM4mcuO67B0J4ztKsDasULgWIyQ29fQbvqJF9LrYrPSH+nIkCmyjdmuKfo6w2Rj6s59lQ+G6dFG4FDAqAA9d7JuDWs60IVLhLcoARxXElM98R1sLnbUJYextQlgPrVM/zhKFrsOK+bzFworhsW9LNKDNisg6opebnnzo6xBWh6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5368.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEN0WllpbWw0VlJ4Y2hkSjJNMGMyRjdoRFB0Vi9RTENYK1M1bDdZUGhMSjJV?=
 =?utf-8?B?VStpaVZQZXJIUUZxUUxJNXd3THhFUG1yUEtuZmxkTW85Z0FuMzVKZDZ2Q2xU?=
 =?utf-8?B?QlZISkdoWklEVzlFLzByWHB5RkJCeGV3R0kxYkZTY1FwVDZ2SWlpYzRTYTc1?=
 =?utf-8?B?bU41bU1ZRnRXaWo5cW4wREhTQ2JFVUcyV0NpbEM2R001TDF0ZjlqbDZ5cHJC?=
 =?utf-8?B?SnlvVjdrTHZOb2pMei9uQVZrRk1TcWF5SXNIbmZUVUdHWHVkYkZhN2FvWXFz?=
 =?utf-8?B?ZGZUaVVXdmtMWjk5OXoveS9hMTNBWHluYkR3WDBxaldEWGZBNUd1RmNFbjNw?=
 =?utf-8?B?MlZyb3pHMXByK2N4S2xhYUpSSUxzeFZaQ0ZPWXNwMGNpdnJadzYwYTEvWFZZ?=
 =?utf-8?B?bzJpcjRmelBYNDFLZWJ4S2d4OVUyMVd1UHpaS201bzZwTTIxcmthTzg1NDc0?=
 =?utf-8?B?SmhBc0xCQTEzWGRuV0hSN2N5QmZKYzN6dGhkTHhOS3VTSVpRd25jUjlPbm9h?=
 =?utf-8?B?TExTeGhYck9VTVhEMTFFRDhRL2pyWjk1MkJ2dnVCWWdCL1kzZ2pWVTRMM0hO?=
 =?utf-8?B?NExHaXlDZFJRbEE3RGFkN2VtYVFuRUVlMytvM3h4NkgvOXpZc0NBamNpb3pX?=
 =?utf-8?B?V0dpQmErem1zeSt3dWlIN2s3Vms5Z1N6YmFPUnd3TS85bGpTTDNvbkxCdEkx?=
 =?utf-8?B?d20rZUo4dWdVU0JCWDVRdDg2cTdubVcxVEJzNnc3WVNKeU1vYVl1aWVWdGFQ?=
 =?utf-8?B?OU1YOS8vQzlrQXhaQ1pPY3lMUTYyNE4vZW1xYzlEM28vZEN6QXdlLy9NNVdh?=
 =?utf-8?B?VUQ2UE5jNXRQUlFCWGtJUk5LTFkrT1k1VGZLdUEvVnU5bkpVNWRmazZ4cXA1?=
 =?utf-8?B?RGVKU0g3NzlZMFJKdFRBRkNXTVdncDZENUVCQ2FDeTU4ZVZHdys0eFdpbUw2?=
 =?utf-8?B?ZFF6SURnVVFrYkRLcXdzQWV4QXV5VHdHUFduVEJtNExNM0ZqV0sxYno5Lzlh?=
 =?utf-8?B?c2I2QWFzMFpDemd1bWN5cWdCa3hDRzZzN0RPdnJOYkJhTHljNlNqcHlFbktU?=
 =?utf-8?B?bkZGenNZOGhjNmlMcC9aaHpuWUZPM2ZKNjdFNVZlTkRKMzJvanJKVHhFdEVn?=
 =?utf-8?B?dXdXRk1odVJ1eGwyNE1CWXZWOFV6VFYyWDlqdkN4TkVVZVM2dFdyYWtSSEdi?=
 =?utf-8?B?VDVaVElLekk5NG9yb2ErNFlhLzZrbnRuWm9pamdHV0Q4ekIvaUloRkNxN3dr?=
 =?utf-8?B?aXA5UVNKR216eVViQlgzYjVNaVh1RHUxNkVIVUoxL0tRSDJuejF3N1VBOWdB?=
 =?utf-8?B?VVdUSEwyUFhaTVpRSGxTMHNxVmpJb2E5aHU2WE5rblFIeEdPZmJTSklOMFZ1?=
 =?utf-8?B?SHpOdHEzTjExa1RDY1MyL0ZDRlhleDZGSjNjWWtXcDUybU1BNXpEc0hSdFAv?=
 =?utf-8?B?cUI3eFBFWVptb3cvY3JPdTUrMXZiZ1RNQTZUWUUyMHVVems2QjI3ZG16VHk5?=
 =?utf-8?B?YWdteXNBakN0VHRhUzg2RGZBM0plUnJHRmNVN29qSnJ2akpQRzdzRGJ4L1py?=
 =?utf-8?B?YnlLWG9XakNYYnYycm9CSytXZ0p6bElKMHIrRkRtNlg5U2pta25kTndOVVZQ?=
 =?utf-8?B?UFpKd1h1eWc4eU45MFphU0FmZzZDQkdUaXBKWTd3TlRadTk2ZnkzTDljZVN3?=
 =?utf-8?B?ZFFNWGJ4MnNXZE9OQ1FuTU5kZjZGSG1RRHN2U2VsSTRaczU2NmRYQnlCbkxF?=
 =?utf-8?B?ck9qSkVrSTk0dVZZdWo0eDVOM25MY0gxN3NnZWVKZmFXUkw1a1h1S3dSdWlV?=
 =?utf-8?B?RHVkNDVwdjVYdWhIZ2s2ZUpmUW1PeTl4RHpYQVpldk1Ld3JRTFgvTUpYdzVh?=
 =?utf-8?B?MElHZ3JLdUJESXI0S1Y1d2VVV2E4bXluMWU0ODZoODNMNXRkSnN2ejVVRmEy?=
 =?utf-8?B?M2NMak5LUndWNzJMRnpnYVdJaTlET2lwdG5ycFc1cnBxZzNaUkkyeEdXMnhN?=
 =?utf-8?B?d3FKRVZoUFlaVDg2aXQ1S1RCYkhycUcwZkFHZkN3eEZldWpqZFRsVGd2dTBH?=
 =?utf-8?B?ME1Xd05SbXR0UGlPWFJHTnlWN0wxSWFBUXNSYmV3bjg1dEtsODROZ3ZieXZC?=
 =?utf-8?Q?OaYBtXr5R1O+Qigi9qc6Y0PlP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5368.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64af15f-6004-4b22-aa3d-08dc4a528475
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 09:29:04.9826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzaICpaWzu9FOj3yagbQ+Ho9XJt+kVd8y4asAKiGNAggjGphdxh9uB1KJWbkT/YGv4/1cbf9GedJX23oRuxA5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7621
X-OriginatorOrg: intel.com

PiBGaXJzdCwgcmlwIG91dCBLVk0ncyBzdXBwb3J0IGZvciB2aXJ0dWFsaXppbmcgZ3Vlc3QgTVRS
UnMgb24gVk1YLiAgVGhlIGNvZGUgaXMNCj4gY29zdGx5IHRvIG1haW4sIGEgZHJhZyBvbiBndWVz
dCBib290IHBlcmZvcm1hbmNlLCBpbXBlcmZlY3QsIGFuZCBub3QNCj4gcmVxdWlyZWQgZm9yIGZ1
bmN0aW9uYWwgY29ycmVjdG5lc3Mgd2l0aCBtb2Rlcm4gZ3Vlc3Qga2VybmVscy4gIE1hbnkgZGV0
YWlscw0KPiBpbiBwYXRjaCAxJ3MgY2hhbmdlbG9nLg0KPiANCj4gV2l0aCBNVFJSIHZpcnR1YWxp
emF0aW9uIGdvbmUsIGFsd2F5cyBob25vciBndWVzdCBQQVQgb24gSW50ZWwgQ1BVcyB0aGF0DQo+
IHN1cHBvcnQgc2VsZi1zbm9vcCwgYXMgc3VjaCBDUFVzIGFyZSBndWFyYW50ZWVkIHRvIG1haW50
YWluIGNvaGVyZW5jeQ0KPiBldmVuIGlmIHRoZSBndWVzdCBpcyBhbGlhc2luZyBtZW10eXBlcywg
ZS5nLiBpZiB0aGUgaG9zdCBpcyB1c2luZyBXQiBidXQgdGhlDQo+IGd1ZXN0IGlzIHVzaW5nIFdD
LiAgSG9ub3JpbmcgZ3Vlc3QgUEFUIGlzIGRlc2lyYWJsZSBmb3IgdXNlIGNhc2VzIHdoZXJlIHRo
ZQ0KPiBndWVzdCBtdXN0IHVzZSBXQyB3aGVuIGFjY2Vzc2luZyBtZW1vcnkgdGhhdCBpcyBETUEn
ZCBmcm9tIGEgbm9uLQ0KPiBjb2hlcmVudCBkZXZpY2UgdGhhdCBkb2VzIE5PVCBib3VuY2UgdGhy
b3VnaCBWRklPLCBlLmcuIGZvciBtZWRpYXRlZA0KPiB2aXJ0dWFsIEdQVXMuDQo+IA0KPiBUaGUg
U1JDVSBwYXRjaCBhZGRzIGFuIEFQSSB0aGF0IGlzIGVmZmVjdGl2ZWx5IGRvY3VtZW50YXRpb24g
Zm9yIHRoZQ0KPiBtZW1vcnkgYmFycmllciBpbiBzcmN1X3JlYWRfbG9jaygpLiAgSW50ZWwgQ1BV
cyB3aXRoIHNlbGYtc25vb3AgcmVxdWlyZSBhDQo+IG1lbW9yeSBiYXJyaWVyIGFmdGVyIFZNLUV4
aXQgdG8gZW5zdXJlIGNvaGVyZW5jeSwgYW5kIEtWTSBhbHdheXMgZG9lcyBhDQo+IHNyY3VfcmVh
ZF9sb2NrKCkgYmVmb3JlIHJlYWRpbmcgZ3Vlc3QgbWVtb3J5IGFmdGVyIFZNLUV4aXQuICBSZWx5
aW5nIG9uDQo+IFNSQ1UgdG8gcHJvdmlkZSB0aGUgYmFycmllciBhbGxvd3MgS1ZNIHRvIGF2b2lk
IGVtaXR0aW5nIGEgcmVkdW5kYW50IGJhcnJpZXINCj4gb2YgaXRzIG93bi4NCj4gDQo+IFRoaXMg
c2VyaWVzIG5lZWRzIGEgX2xvdF8gbW9yZSB0ZXN0aW5nOyBJIGFyZ3VhYmx5IHNob3VsZCBoYXZl
IHRhZ2dlZCBpdCBSRkMsDQo+IGJ1dCBJJ20gZmVlbGluZyBsdWNreS4NCj4gDQo+IFNlYW4gQ2hy
aXN0b3BoZXJzb24gKDMpOg0KPiAgIEtWTTogeDg2OiBSZW1vdmUgVk1YIHN1cHBvcnQgZm9yIHZp
cnR1YWxpemluZyBndWVzdCBNVFJSIG1lbXR5cGVzDQo+ICAgS1ZNOiBWTVg6IERyb3Agc3VwcG9y
dCBmb3IgZm9yY2luZyBVQyBtZW1vcnkgd2hlbiBndWVzdCBDUjAuQ0Q9MQ0KPiAgIEtWTTogVk1Y
OiBBbHdheXMgaG9ub3IgZ3Vlc3QgUEFUIG9uIENQVXMgdGhhdCBzdXBwb3J0IHNlbGYtc25vb3AN
Cj4gDQo+IFlhbiBaaGFvICgyKToNCj4gICBzcmN1OiBBZGQgYW4gQVBJIGZvciBhIG1lbW9yeSBi
YXJyaWVyIGFmdGVyIFNSQ1UgcmVhZCBsb2NrDQo+ICAgS1ZNOiB4ODY6IEVuc3VyZSBhIGZ1bGwg
bWVtb3J5IGJhcnJpZXIgaXMgZW1pdHRlZCBpbiB0aGUgVk0tRXhpdCBwYXRoDQo+IA0KPiAgRG9j
dW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0ICAgICAgICB8ICAgNiArLQ0KPiAgRG9jdW1lbnRh
dGlvbi92aXJ0L2t2bS94ODYvZXJyYXRhLnJzdCB8ICAxOCArDQo+ICBhcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oICAgICAgIHwgIDE1ICstDQo+ICBhcmNoL3g4Ni9rdm0vbW11LmggICAg
ICAgICAgICAgICAgICAgIHwgICA3ICstDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jICAgICAg
ICAgICAgICAgIHwgIDM1ICstDQo+ICBhcmNoL3g4Ni9rdm0vbXRyci5jICAgICAgICAgICAgICAg
ICAgIHwgNjQ0ICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14
L3ZteC5jICAgICAgICAgICAgICAgIHwgIDQwICstDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAg
ICAgICAgICAgICAgICAgIHwgIDI0ICstDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmggICAgICAgICAg
ICAgICAgICAgIHwgICA0IC0NCj4gIGluY2x1ZGUvbGludXgvc3JjdS5oICAgICAgICAgICAgICAg
ICAgfCAgMTQgKw0KPiAgMTAgZmlsZXMgY2hhbmdlZCwgMTA1IGluc2VydGlvbnMoKyksIDcwMiBk
ZWxldGlvbnMoLSkNCj4gDQo+IA0KPiBiYXNlLWNvbW1pdDogOTY0ZDBjNjE0YzdmNzE5MTczMDVh
NWFmZGNhOTE3OGZlODIzMTQzNA0KPiAtLQ0KPiAyLjQ0LjAuMjc4LmdlMDM0YmIyZTFkLWdvb2cN
Cj4gDQpWZXJpZmllZCBpR1BVIHBhc3N0aHJvdWdoKEdWVC1kKSBvbiBJbnRlbCBwbGF0Zm9ybXMs
IFRHTCBDb3JlKFRNKSBpNS0xMTM1RzcvQURMIENvcmUoVE0pIGk3LTEyNzAwL1JQTC9NVEwgVWx0
cmEgNyArIFVidW50dTIyLjA0IExUUy4NCkJvdGggTGludXggVWJ1bnR1IDIyLjA0IFZNIGFuZCBX
aW5kb3dzMTAgVk0gY291bGQgYm9vdCB1cCBzdWNjZXNzZnVsbHkuIA0KM0QgYmVuY2htYXJrIEdM
bWFyazIgY2FuIHJ1biBhcyBleHBlY3RlZCBpbiB0aGUgZ3Vlc3QgVk0uDQoNClRlc3RlZC1ieTog
WW9uZ3dlaSBNYSA8eW9uZ3dlaS5tYUBpbnRlbC5jb20+DQoNCkJlc3QgUmVnYXJkcywNCllvbmd3
ZWkgTWENCg==

