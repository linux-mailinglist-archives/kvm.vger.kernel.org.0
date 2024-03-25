Return-Path: <kvm+bounces-12584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEDA88A44E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 15:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40DBA2E65FF
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA3F13B289;
	Mon, 25 Mar 2024 10:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T9LYx/sE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8313AA35;
	Mon, 25 Mar 2024 10:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711362147; cv=fail; b=hDcygvA6TkdGwf8jJixnlGD0tqurXdcoqOnge+9jXLe9sjZh8R4w0lpZ/iyubeDmyinJz20eDaxitORtgKvUtRR5d9XmM0T6WhACnjdYHiMlZuvH5SwgcuTKI0nJuNOqnbVx5A9gn1f3xXfXnpTnss90Xv+ALpmqqlCp5btY2KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711362147; c=relaxed/simple;
	bh=Dr6GSl6KsDTsU7XYxtbiQOtfNUa0EkndYEaL+xUkYGM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m3SeWuakA9goPj7seb8ieLrGXf1tX5Edt6Jo4PjGPrt9mFJ6ErD1N0BXIzgt50/idXrjoyI3tEj4D3lypvfaLzqSxFDea73K6JI3M6SIb5d4uE8OrOGhLXSicfORMaS6u+a/YgOf/pQjWdtaoG7kyAYTzgIRC+pTE0OhdYZKF/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T9LYx/sE; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711362145; x=1742898145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Dr6GSl6KsDTsU7XYxtbiQOtfNUa0EkndYEaL+xUkYGM=;
  b=T9LYx/sE3l0qT/Z9NQ9+Sj2k11H3Ve/4A9qhQaueb6vch4NSGWgxQkJ5
   CLRMdlRyneKsZM4bZLMiMxgTDgrkX2EvuKf6KAILvO/K1DK8ORkGUnTps
   J8HHQ/XVuEiiPyQig9enjNU/ztowzDu9jQp+/T7+o8QH0vSKqsefkcyT6
   SfAbw4otFrzkPvx+EVzHQYR5N7oZ6yo/WNb7IHGZWkdeo0at5ESLozr8Q
   A+Udxgy+d0POR6eeyUbqUoj/AE2Mj85ncRGQnuHV1ObTowu2VIoRKspvm
   0aiAr5JTKAo+zwaRWpRaQevYEIbJga8I+wYECWZ4YGfztvAtoWcMQkjye
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6469495"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6469495"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 03:22:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="53033552"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 03:22:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 03:22:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 03:22:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 03:22:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdEdjK0nd6rSvuS/FC7zC+cDu6+gq0hVzX4//ffWem/HFzHDK87SwNDsT4mXAYGoLDhLsJYps7qtA9yfj8v7kYlHfumgtDaDub9eiLysCFTT6a7Jp+sNynOz/0D/tEQ09PQYmr1ErTxz1o7MvHHr95Wy9IUfhoNhpsiFMF17yFTTDXMd9vdCcZb7q+1UukDk+BoxrjZ4zHmBxXG2p6R175TRCXz0lKvyC0lArQLKGWUeDa1Jq4rjhcsaiaRvRfR7wR8K+zG3czViFFUDzGCYDmwOSW2GkiAe9VAwM9GnUJbKC2jpJd+KCT3l98STmKQSfQOD16+xGTrThZRk9Xxksw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dr6GSl6KsDTsU7XYxtbiQOtfNUa0EkndYEaL+xUkYGM=;
 b=JMGUorX1QsmmR/spZdwSSeF3Lpcedt8O5EI2X9UcB+c/34CemK/lqkZB+k0bmP+U5dSMYa+/N1J6R0FhN/INlPNAQ2GW7EFU6PGq6r9QYiuPLhYxktzBz+/RylzZVFsUp8whkm5dpBZuGrBE6EzhGPuS6WkFiMhKIgRBHS9lM1tNqaZqrvcXYUOsUDS0AIuLlAlsXJLWmJ33bV8EJq80DgOxj4F4SZbKVJ35ctQpXAPtXmC/mFlVpCZ5AL7XwI4fVHdCi+AGFLGzunyG8mUB8odVESZVDAaBYeOhipMFIxPiWs/fbhiJ4yg/HAElWMoWvn463/bn9AoxmD5m5DmH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 10:22:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 10:22:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Topic: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Index: AQHaaI22CHOAd5HudEy66qf/I7Hhk7FC3swAgAGlYYCAA+dWAA==
Date: Mon, 25 Mar 2024 10:22:19 +0000
Message-ID: <9c592801471a137c51f583065764fbfc3081c016.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
	 <dd389847-6f67-4f5d-8358-5d6b6a493797@intel.com>
	 <20240322224531.GB1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322224531.GB1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6611:EE_
x-ms-office365-filtering-correlation-id: a27a7a1e-e604-4019-8043-08dc4cb573f8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ExavzeqOXmAwgBSw+8o0yA0CCThQWm3J1p2enC+iH/gAic03QU//C/mMRE5qPsYTbkRyVXrqGTuQBIXJs+NrS86OAZNJVmXjgKnAe7seivfVvjnoXNRabRllVYptM07RkKGBvVOej9qZ3/7rsCSXTXFKw1IqbcvphhaQndnufPQTQ9p5PGXUzDC/dqdSKzVVUqQ0Ji71CMLF9Zizo+LN/PftOaPc9Y8UCqa5dxoUlKl7r/5X6PKBm9ncfGeOSgTGMSrmLIdv9Hh4tpRNW/cCudqUzEpUrQklbAje7rgBN2c49uThsitpiUgchx0sNrDqr132nagt8URLn7IoAgmqZijhtJCJrqZqJd5yH7LsrieG3px2eoSp+lNYthPkVK9iyYBP9tJ03USliXqRWgnFczSoxDqQMroxvb3beurk4FQVTR/RpsnYaplBs34VMNwK26sdvctyu+19fRjxUuipwJJT4mG9l//UEPv77hPOLBOnJIA7zD9wWzh285XgVfKJBGwhVm3Z5y/HE05P0hezUYucvduWIKuRr7LkyUmTnDb3aWZoqj9WmCn/5RxO4/taSyAF4d4zzzWPM24eQv++/8IqBscqcpuuHb+gEa3YofsG5IwsTKgxncQ5vk7K2arFeW9p5tnKerad+KblIk4mK2rkpCPjbf7baD0wsAw54UjNg0N2/xt6fiRPK8SA0vgTwjpre1KKj1vFau6nQWqa/mqITaltIcq6ULiWPXAhmOA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmdVbVJOM1ZOVld4QUdCQThFZm4rZjdNREcxUmV6b0hYbG9WS2t6QnpJQW0y?=
 =?utf-8?B?dGhJamJHODhmV3hvWC9pSFA0UUNCcHZVRGhnOXlJcmVkanBkZ2hFK1FISGJC?=
 =?utf-8?B?NzB0RC9DVnpNSzZWZUt0K3FBdHhnWjdZVE4wQWFiVzZ1bVcxcnM3d3h4RkVR?=
 =?utf-8?B?dG9PbENuUGVabWRXWjNWbUp0MG9NLzFtT3NnOFMvN2xLU0lKeUVWc3E2YU9m?=
 =?utf-8?B?dVB4eTcxaVhvZmdkU0Y1RUl4cVdsRGd5T200Y2Q2K2NtdG5YWlRHK0w5cnVa?=
 =?utf-8?B?eUhDVnplRFE1U2lqTHh1WUhXTDR2bENsYjB4QkJwUUJEdXZTYnhSbkVjZzJv?=
 =?utf-8?B?TVp1dTRITDQyR2MxSytxNmd6WU9UYVdDY1FJb3lBdExmVXRMWTVpL2tNenFK?=
 =?utf-8?B?T0J2VEgyWTI2RVltSHFSaEpWQVdjcEpkWVZMbXJtVEc4aFYyRi9ETWZZMlNi?=
 =?utf-8?B?OHlEWnZTbEUzNE9mTXUzS3pNb1ViTDBzenNvZHpJUnlYaUNYN0dCYTR2K0NQ?=
 =?utf-8?B?VWhtTDRWalJKNFlDdy8xTHdMRVZHNTNjVllYRFp3czBuSVBVQm9xS0lncUZm?=
 =?utf-8?B?blR4ZFU5WFBhR1BGR3gxQUV5RDB5S2JjWVZRSFFvV2prTVUzR1crRGNSY2M1?=
 =?utf-8?B?Z3YyZGYzOEVYbzRWbEVUYTZEc0hwTmJPb0FXbHQwTEJyZlF2SytQOE8zNDkz?=
 =?utf-8?B?Tzc3dXhROTgzcWNVQjNKdnZXMVVpaG1nb1MrM3VIeWcwNngvV3dhNjdrcjd5?=
 =?utf-8?B?aVpXemptOVROTXdwS2oyTmVOUTNZZjFyL0FvOGwvNjVYQ0d1b05DbysxZmkz?=
 =?utf-8?B?bFd2d1puT3BNMzNvZDZuY0J2WEx3SGQvRG5DV2JTSUl0OXlyWjl6VUhqbkJp?=
 =?utf-8?B?QTdyYlpoT2tlME1nSTBaN1JYSnJiQjQ5d0FpL3VtdkdaNkU4OEdINU44bUxR?=
 =?utf-8?B?dVVzblpyUmZnYzRpV24xQVdYaEVwbk1XNmE4ckJxd2FhNHhiQVk2S2NzeTNL?=
 =?utf-8?B?UW0wVlJqUUNvMkZHem1ERFpuUnZpNDRCK2Y0N3U5dEdPSmJpVU5GbDcrVjJC?=
 =?utf-8?B?NDBkTkk5K3hHVWJ1em5lZm9qcWhDaDhVc3oyNE5iVXZYVHlDUWE1cmRRcXIx?=
 =?utf-8?B?LzFiZVRUcnRDY01qWlRCUEJraFpzSEdDTXNpWEsrVVhkOWVwckFtdjZDYlNE?=
 =?utf-8?B?SkxDZkY4WTZVL2ZZU0VaN3Y2TmpWQ2tTV0xSZlNpY053Qmp0R1MvUlhOODQz?=
 =?utf-8?B?SmhTNlNSbmNyUjgzV3hYcFBVakpSekFGSHNzR0hWY1FXRm9TNno3cm1JalF4?=
 =?utf-8?B?aVgrYksrRnRYVUd6MmRwTGdPaWJrdC9pd0RqRjIxUEEvQWsydWFHeU9vTE5I?=
 =?utf-8?B?VkJ6TTlBVFZ1bThrdzd1Ny9kai9DUnNGMHlYblJpVVFlUE9BTWNudFJvMFdj?=
 =?utf-8?B?NHJBaVRGZEZ3bEJ6Q2NQVXdkTDllaytlVU5mRW1hMDk5Qmo0dXVESjkvRHdh?=
 =?utf-8?B?akJwZnl3Uzd5WTJOaUpLVU9XR1RQVTQydURuVjlMYVVRS0FnUDFxZ01sV1Vu?=
 =?utf-8?B?UlFEbUlOcDhsZmwyUVhNSFRLRHlvVW1JZDIwN040NWpnR2ZPTnNJSHRHSFlJ?=
 =?utf-8?B?Nk53Qlk3YWpSTUlwcGw5UDArVWdPUzhKNEF6anJndjBidndhVVlTVmRpd2wz?=
 =?utf-8?B?T2pKYWpzSXJEbmFKQlVhMkV4UmM3bkd3eUFZYzFabHlaU2VBTnlrMGl6RGt2?=
 =?utf-8?B?TEpIejU1UWhkM2xQaXJ4dVI2UEwzb2wxcDJUN0FkdkhEY0ZxTEdiZ0Y2Ylov?=
 =?utf-8?B?WU4zaFdSY2RwOTkvNWxTazNaWFM4YzFZY1RsK2oxc1piTVE3UFZiSTRtVDNN?=
 =?utf-8?B?UFV4a2QvWWd2Q3hocUY4cEJMaE1lNHY1QjZzUE5vdFdVS2dyWFRuNWQ4ZSto?=
 =?utf-8?B?dnp4cnBwS0VQZUxwUXpMVTh3OGFtcUpPM3hRVDBGR3N3VWZDWE1US1JGbUNT?=
 =?utf-8?B?TThiTkdjVUU4SmVEMERJT2UxMjlkcVUrSHdITXNUSHdIdUllVW13Wmx0RVBr?=
 =?utf-8?B?eWtybTByM0paakpPQTJQcEJueEtPSEtyWnUwOCs3eDR3NUdDWlN2UTdaSUU1?=
 =?utf-8?B?RVY5TjRUNW1PODQvcTVmWTZlMEU3Z1BNdVhiKy9Uck94YncxMFBEMVIrMEpK?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E6A5E54C400454693C8A97C3D9B63A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a27a7a1e-e604-4019-8043-08dc4cb573f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 10:22:19.7756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OCLppOcwAE4QyE5s50cETTtjZFUc8MRrBYV6mYfNNIgAO5FDPsyHgziNjobs7UHpb1DpAWskjPZFsfm1NRJxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
X-OriginatorOrg: intel.com

PiANCj4gSGVyZSBpcyB0aGUgdXBkYXRlZCB2ZXJzaW9uLg0KPiANCj4gS1ZNOiBURFg6IEFkZCBw
bGFjZWhvbGRlcnMgZm9yIFREWCBWTS92Y3B1IHN0cnVjdHVyZQ0KPiANCj4gQWRkIHBsYWNlaG9s
ZGVycyBURFggVk0vdkNQVSBzdHJ1Y3R1cmUsIG92ZXJsYXlpbmcgd2l0aCB0aGUgZXhpc3RpbmcN
Cg0KCQkJICAgICAgIF4gc3RydWN0dXJlcw0KDQoiVERYIFZNL3ZDUFUgc3RydWN0dXJlIiAtPiAi
VERYIFZNL3ZDUFUgc3RydWN0dXJlcyIuDQoNCkFuZCBJIGRvbid0IHF1aXRlIHVuZGVyc3RhbmQg
d2hhdCBkb2VzICJvdmVybGF5aW5nIiBtZWFuIGhlcmUuDQoNCj4gVk1YIFZNL3ZDUFUgc3RydWN0
dXJlcy4gIEluaXRpYWxpemUgVk0gc3RydWN0dXJlIHNpemUgYW5kIHZDUFUNCj4gc2l6ZS9hbGln
biBzbyB0aGF0IHg4NiBLVk0tY29tbW9uIGNvZGUga25vd3MgdGhvc2Ugc2l6ZXMgaXJyZXNwZWN0
aXZlDQo+IG9mIFZNWCBvciBURFguICBUaG9zZSBzdHJ1Y3R1cmVzIHdpbGwgYmUgcG9wdWxhdGVk
IGFzIGd1ZXN0IGNyZWF0aW9uDQo+IGxvZ2ljIGRldmVsb3BzLg0KPiANCj4gVERYIHJlcXVpcmVz
IGl0cyBkYXRhIHN0cnVjdHVyZSBmb3IgZ3Vlc3QgYW5kIHZjcHUuICBGb3IgVk1YLCB3ZQ0KDQpJ
IGRvbid0IHRoaW5rIFREWCAicmVxdWlyZXMiIGFueXRoaW5nIGhlcmUuICBJbnRyb2R1Y2luZyBz
ZXBhcmF0ZSBzdHJ1Y3R1cmVzIGFyZQ0Kc29mdHdhcmUgaW1wbGVtZW50YXRpb24sIGJ1dCBub3Qg
cmVxdWlyZW1lbnQgYnkgVERYLg0KDQo+IGFscmVhZHkgaGF2ZSBzdHJ1Y3Qga3ZtX3ZteCBhbmQg
c3RydWN0IHZjcHVfdm14LiAgVHdvIG9wdGlvbnMgdG8gYWRkDQo+IFREWC1zcGVjaWZpYyBtZW1i
ZXJzLg0KPiANCj4gMS4gQXBwZW5kIFREWC1zcGVjaWZpYyBtZW1iZXJzIHRvIGt2bV92bXggYW5k
IHZjcHVfdm14LiAgVXNlIHRoZSBzYW1lDQo+ICAgICBzdHJ1Y3QgZm9yIGJvdGggVk1YIGFuZCBU
RFguDQo+IDIuIERlZmluZSBURFgtc3BlY2lmaWMgZGF0YSBzdHJ1Y3QgYW5kIG92ZXJsYXkuDQo+
IA0KPiBDaG9vc2Ugb3B0aW9uIHR3byBiZWNhdXNlIGl0IGhhcyBsZXNzIG1lbW9yeSBvdmVyaGVh
ZCBhbmQgd2hhdCBtZW1iZXINCj4gaXMgbmVlZGVkIGlzIGNsZWFyZXINCj4gDQo+IEFkZCBoZWxw
ZXIgZnVuY3Rpb25zIHRvIGNoZWNrIGlmIHRoZSBWTSBpcyBndWVzdCBURCBhbmQgYWRkIHRoZSBj
b252ZXJzaW9uDQo+IGZ1bmN0aW9ucyBiZXR3ZWVuIEtWTSBWTS92Q1BVIGFuZCBURFggVk0vdkNQ
VS4NCg0KRllJOg0KDQpBZGQgVERYJ3Mgb3duIFZNIGFuZCB2Q1BVIHN0cnVjdHVyZXMgYXMgcGxh
Y2Vob2xkZXIgdG8gbWFuYWdlIGFuZCBydW4gVERYDQpndWVzdHMuDQoNClREWCBwcm90ZWN0cyBn
dWVzdCBWTXMgZnJvbSBtYWxpY2lvdXMgaG9zdC4gIFVubGlrZSBWTVggZ3Vlc3RzLCBURFggZ3Vl
c3RzIGFyZQ0KY3J5cHRvLXByb3RlY3RlZC4gIEtWTSBjYW5ub3QgYWNjZXNzIFREWCBndWVzdHMn
IG1lbW9yeSBhbmQgdkNQVSBzdGF0ZXMNCmRpcmVjdGx5LiAgSW5zdGVhZCwgVERYIHJlcXVpcmVz
IEtWTSB0byB1c2UgYSBzZXQgb2YgYXJjaGl0ZWN0dXJlLWRlZmluZWQNCmZpcm13YXJlIEFQSXMg
KGEuay5hIFREWCBtb2R1bGUgU0VBTUNBTExzKSB0byBtYW5hZ2UgYW5kIHJ1biBURFggZ3Vlc3Rz
Lg0KDQpJbiBmYWN0LCB0aGUgd2F5IHRvIG1hbmFnZSBhbmQgcnVuIFREWCBndWVzdHMgYW5kIG5v
cm1hbCBWTVggZ3Vlc3RzIGFyZSBxdWl0ZQ0KZGlmZmVyZW50LiAgQmVjYXVzZSBvZiB0aGF0LCB0
aGUgY3VycmVudCBzdHJ1Y3R1cmVzICgnc3RydWN0IGt2bV92bXgnIGFuZA0KJ3N0cnVjdCB2Y3B1
X3ZteCcpIHRvIG1hbmFnZSBWTVggZ3Vlc3RzIGFyZSBub3QgcXVpdGUgc3VpdGFibGUgZm9yIFRE
WCBndWVzdHMuIA0KRS5nLiwgdGhlIG1ham9yaXR5IG9mIHRoZSBtZW1iZXJzIG9mICdzdHJ1Y3Qg
dmNwdV92bXgnIGRvbid0IGFwcGx5IHRvIFREWA0KZ3Vlc3RzLg0KDQpJbnRyb2R1Y2UgVERYJ3Mg
b3duIFZNIGFuZCB2Q1BVIHN0cnVjdHVyZXMgKCdzdHJ1Y3Qga3ZtX3RkeCcgYW5kICdzdHJ1Y3QN
CnZjcHVfdGR4JyByZXNwZWN0aXZlbHkpIGZvciBLVk0gdG8gbWFuYWdlIGFuZCBydW4gVERYIGd1
ZXN0cy4gIEFuZCBpbnN0ZWFkIG9mDQpidWlsZGluZyBURFgncyBWTSBhbmQgdkNQVSBzdHJ1Y3R1
cmVzIGJhc2VkIG9uIFZNWCdzLCBidWlsZCB0aGVtIGRpcmVjdGx5IGJhc2VkDQpvbiAnc3RydWN0
IGt2bScuDQoNCkFzIGEgcmVzdWx0LCBURFggYW5kIFZNWCB3aWxsIGhhdmUgZGlmZmVyZW50IFZN
IHNpemUgYW5kIHZDUFUgc2l6ZS9hbGlnbm1lbnQuIA0KQWRqdXN0IHRoZSAndnRfeDg2X29wcy52
bV9zaXplJyBhbmQgdGhlICd2Y3B1X3NpemUnIGFuZCAndmNwdV9hbGlnbicgdG8gdGhlDQptYXhp
bXVtIHZhbHVlIG9mIFREWCBndWVzdCBhbmQgVk1YIGd1ZXN0IGR1cmluZyBtb2R1bGUgaW5pdGlh
bGl6YXRpb24gdGltZSBzbw0KdGhhdCBLVk0gY2FuIGFsd2F5cyBhbGxvY2F0ZSBlbm91Z2ggbWVt
b3J5IGZvciBib3RoIFREWCBndWVzdHMgYW5kIFZNWCBndWVzdHMuDQoNClsuLi5dDQoNCj4gPiAN
Cj4gPiA+IEBAIC0yMTUsOCArMjE5LDE4IEBAIHN0YXRpYyBpbnQgX19pbml0IHZ0X2luaXQodm9p
ZCkNCj4gPiA+ICAgCSAqIENvbW1vbiBLVk0gaW5pdGlhbGl6YXRpb24gX211c3RfIGNvbWUgbGFz
dCwgYWZ0ZXIgdGhpcywgL2Rldi9rdm0gaXMNCj4gPiA+ICAgCSAqIGV4cG9zZWQgdG8gdXNlcnNw
YWNlIQ0KPiA+ID4gICAJICovDQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIGt2bV94ODZfb3BzIGlz
IHVwZGF0ZWQgd2l0aCB2dF94ODZfb3BzLiAgdnRfeDg2X29wcy52bV9zaXplIG11c3QNCj4gPiA+
ICsJICogYmUgc2V0IGJlZm9yZSBrdm1feDg2X3ZlbmRvcl9pbml0KCkuDQo+ID4gPiArCSAqLw0K
PiA+ID4gICAJdmNwdV9zaXplID0gc2l6ZW9mKHN0cnVjdCB2Y3B1X3ZteCk7DQo+ID4gPiAgIAl2
Y3B1X2FsaWduID0gX19hbGlnbm9mX18oc3RydWN0IHZjcHVfdm14KTsNCj4gPiA+ICsJaWYgKGVu
YWJsZV90ZHgpIHsNCj4gPiA+ICsJCXZjcHVfc2l6ZSA9IG1heF90KHVuc2lnbmVkIGludCwgdmNw
dV9zaXplLA0KPiA+ID4gKwkJCQkgIHNpemVvZihzdHJ1Y3QgdmNwdV90ZHgpKTsNCj4gPiA+ICsJ
CXZjcHVfYWxpZ24gPSBtYXhfdCh1bnNpZ25lZCBpbnQsIHZjcHVfYWxpZ24sDQo+ID4gPiArCQkJ
CSAgIF9fYWxpZ25vZl9fKHN0cnVjdCB2Y3B1X3RkeCkpOw0KPiA+ID4gKwl9DQo+ID4gDQo+ID4g
U2luY2UgeW91IGFyZSB1cGRhdGluZyB2bV9zaXplIGluIHZ0X2hhcmR3YXJlX3NldHVwKCksIEkg
YW0gd29uZGVyaW5nDQo+ID4gd2hldGhlciB3ZSBjYW4gZG8gc2ltaWxhciB0aGluZyBmb3IgdmNw
dV9zaXplIGFuZCB2Y3B1X2FsaWduLg0KPiA+IA0KPiA+IFRoYXQgaXMsIHdlIHB1dCB0aGVtIGJv
dGggdG8gJ3N0cnVjdCBrdm1feDg2X29wcycsIGFuZCB5b3UgdXBkYXRlIHRoZW0gaW4NCj4gPiB2
dF9oYXJkd2FyZV9zZXR1cCgpLg0KPiA+IA0KPiA+IGt2bV9pbml0KCkgY2FuIHRoZW4ganVzdCBh
Y2Nlc3MgdGhlbSBkaXJlY3RseSBpbiB0aGlzIHdheSBib3RoICd2Y3B1X3NpemUnDQo+ID4gYW5k
ICd2Y3B1X2FsaWduJyBmdW5jdGlvbiBwYXJhbWV0ZXJzIGNhbiBiZSByZW1vdmVkLg0KPiANCj4g
SG1tLCBub3cgSSBub3RpY2VkIHRoZSB2bV9zaXplIGNhbiBiZSBtb3ZlZCBoZXJlLiAgV2UgaGF2
ZQ0KPiANCj4gIAl2Y3B1X3NpemUgPSBzaXplb2Yoc3RydWN0IHZjcHVfdm14KTsNCj4gIAl2Y3B1
X2FsaWduID0gX19hbGlnbm9mX18oc3RydWN0IHZjcHVfdm14KTsNCj4gCWlmIChlbmFibGVfdGR4
KSB7DQo+IAkJdmNwdV9zaXplID0gbWF4X3QodW5zaWduZWQgaW50LCB2Y3B1X3NpemUsDQo+IAkJ
CQkgIHNpemVvZihzdHJ1Y3QgdmNwdV90ZHgpKTsNCj4gCQl2Y3B1X2FsaWduID0gbWF4X3QodW5z
aWduZWQgaW50LCB2Y3B1X2FsaWduLA0KPiAJCQkJICAgX19hbGlnbm9mX18oc3RydWN0IHZjcHVf
dGR4KSk7DQo+ICAgICAgICAgICAgICAgICB2dF94ODZfb3BzLnZtX3NpemUgPSBtYXhfdCh1bnNp
Z25lZCBpbnQsIHZ0X3g4Nl9vcHMudm1fc2l6ZSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCBrdm1fdGR4KSk7DQo+IAl9DQo+IA0KPiAN
Cj4gV2UgY2FuIGFkZCB2Y3B1X3NpemUsIHZjcHVfYWxpZ24gdG8gc3RydWN0IGt2bV94ODZfb3Bz
LiBJZiB3ZSBkbyBzbywgd2UgaGF2ZQ0KPiB0byB0b3VjaCBzdm0gY29kZSB1bm5lY2Vzc2FyaWx5
Lg0KDQpOb3Qgb25seSBTVk0sIGJ1dCBhbHNvIG90aGVyIGFyY2hpdGVjdHVyZXMsIGJlY2F1c2Ug
eW91IGFyZSBnb2luZyB0byByZW1vdmUgdHdvDQpmdW5jdGlvbiBwYXJhbWV0ZXJzIGZyb20ga3Zt
X2luaXQoKS4NCg0KVGhhdCByZW1pbmRzIG1lIHRoYXQgb3RoZXIgQVJDSHMgbWF5IG5vdCB1c2Ug
J2t2bV94ODZfb3BzJy1zaW1pbGFyIHRoaW5nLCBzbyB0bw0KbWFrZSB0aGluZyBzaW1wbGUgSSBh
bSBmaW5lIHdpdGggeW91ciBhYm92ZSBhcHByb2FjaC4NCg0K

