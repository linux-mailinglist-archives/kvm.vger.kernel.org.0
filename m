Return-Path: <kvm+bounces-14970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C227B8A843C
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 196BAB21A5D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D57A13F442;
	Wed, 17 Apr 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLHBWB4Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642E128811;
	Wed, 17 Apr 2024 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713360024; cv=fail; b=QbjX/bOjTV53cg6Z45Stc3Dlak36hD+uZmkZLj9+ypH/HrRgvN1ickDAmp7e+z9PCE0G/rvhkPSvAWEqOT2MJ2+FUtqdBUNbprFcigmzbPJsJhY+ZTGy7EsnUVMRe238afX9EuOSnxDd/TT9gHswGg6i6CfnqsPcJq3c0KfV9+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713360024; c=relaxed/simple;
	bh=rOpSYBw/4pJwP4/dwP6JhX7VKG7MWSbGhq/dJ1dAMc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mKtGGtId0Qle5xcmm9/YBsex7s/ajdubs++bEZUfp9F4UwErqhMail7j4qKEEE3UcKIONSZ2dRSo08wbrMStyrn2ohZ9RVWE6Bkub70HYWaqIg/OY0H+bLcYHi2/P7w+2PI54EsX9xTPQddT0t1+itx7OO5t69/iRkmE1/w1ieU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLHBWB4Y; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713360022; x=1744896022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rOpSYBw/4pJwP4/dwP6JhX7VKG7MWSbGhq/dJ1dAMc4=;
  b=hLHBWB4YgWxoMU3OTFmAg50+zuQKiK2Awt9EoR3+ktPSQaAbLl7bf2h6
   xvOM2B3fKFBRaHEvNiJNa9vg78nADjdGnZPYPpBL7mvOqzEzhmJ7aPavU
   pks8knvvx3KwKvD8gSW3POr6tJig8pPY0KL5zF8JtBd/zHNJWgbk5aUyo
   /TwJe5soLxh4CJMER0rKwR5Ver/Rn2inQ4RmtmtFz/xCf1NxTc36HXSJ0
   iedzmT4UlTf67ECE5WsaCdG4aoyw4d/QtsfhOSaJZGIPDGEISoofBovUZ
   5q4qs1QZS3nlQAPApuAtHjDOVcGZOjDyOpMxHgmhY81lKuv6rf7jIqE89
   Q==;
X-CSE-ConnectionGUID: 5768VIUwSOazbkKcvxR/YA==
X-CSE-MsgGUID: 1JW1HmMGRCO4DUT+PtOGmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8710494"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="8710494"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 06:20:21 -0700
X-CSE-ConnectionGUID: ec277lhpSFCOeSj2t0UeZg==
X-CSE-MsgGUID: LeeEx4Z2RtGOe2QvQfLZUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22497935"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 06:20:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 06:20:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 06:20:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 06:20:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 06:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN8+AeidWYhbI7es9dZ3sUnMRj1gvhIO4mxuJu73I7nSunGfnF5y5HBbIeRheRMr8TVjmwu4kOrHoMB5lHJYTJLgR4zhyUnlEuWbyOfyKEGegozKKSWqbuocC9GKJUVeuNLb7PT87t9+PDvqYZ/NZ3tEs/z8zbIdcele7siY3WRFdp9sCNRoNkUZbhIjxm0KI4R2DeFhj1BTP1Y89HUvDxHqX6OkEUutDjVwQ2WoxN9gBhzlGH+m35kDLtsPx2ryKL44X1v9+JrOqQBdZIH/NgyDu6NO/fqhlKzNYJcVjXkxAHUcQ3bNbNolwr6ZdtgmcNqItGSRmw8GccFmHIJFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOpSYBw/4pJwP4/dwP6JhX7VKG7MWSbGhq/dJ1dAMc4=;
 b=ZEu0/RdmTgEoDHhwv3CgF1C5UJ4BzCZusGp2nA8wc+0bPIo3IEOs9wRhg43m8q9VGdlolaDhlPKJ75E9rXIA8TNhOQyJL5GLpu0NtciwklDjLi0tOPfL6Xj4+9P7EwaplheL1PDy+9TD1sC8RhWYBplrFBT8EEdW8ctwgakr+TdaIPPxoql6o5+iyZIDxBEkoq+/Kdfq1+/T2Obz/QVL/ggEb/Iwl2uh3hStzW2kKQpZHL0ls5jqNKM+p2BA1zYZzLcHY3fORTJhh6w+y5qq4p2VPCTisBEsrFzvhANmjyFYcGFUOVuhHRCx4vrevdSyLKcerCyFlwZZ+pqZINvA4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7051.namprd11.prod.outlook.com (2603:10b6:510:20e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Wed, 17 Apr
 2024 13:20:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 13:20:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AA==
Date: Wed, 17 Apr 2024 13:20:17 +0000
Message-ID: <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
	 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
	 <20240322212321.GA1994522@ls.amr.corp.intel.com>
	 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
	 <ZhawUG0BduPVvVhN@google.com>
	 <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
	 <Zhftbqo-0lW-uGGg@google.com>
	 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
	 <Zh7KrSwJXu-odQpN@google.com>
In-Reply-To: <Zh7KrSwJXu-odQpN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7051:EE_
x-ms-office365-filtering-correlation-id: 083a5e5e-68c0-4562-a3a6-08dc5ee11ff9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w++0izfy5JHHCeFuelv+CXnaVMR3gi20nsR8WKGgKlHVF5GZN2fDm8Hw23YslQ0fon8w5GBQvrnBwYKPvbGUVAE9bq2oUpGAm5yZw7QPMRFpN2uzHWT6/6a0CBltKz8nFjMToGcQ9j6In/X6upIDDHvaykpBOOpLql1EvsAt1PzJ6t7VQsQX1rtF+uwdiBPeldJYVFchjzsa0lVyhXNAoD3TO0gOquSB5PBtBN1yRmBKBFNlqk2GWacLTUfkWG7U8mm0mvIdMlb+aRF8J+u31padB8Sc/7jdS8djB4VLdx7+7bV/EWWniA538Z89l2sbi+89FumPDM/KipO5B3oBG6dwxjPZazJOs7yV3+KYfb34cJl0BXZMjC2mdfkFFkZCnVmsrHrdjG7vM0/ANTaVK61S3Av28MlrTIN9wm/PmqgfNnFEJz2eD5a+m85Jj/F43IPdp7ZyrZlvw2K7hra9oUnJvLq/3P5TcKJkbg7eJe6VIIHV08uc3k7fq5J3ABN1a6hPCKMhVOz0RGxdSvDBepqAmKL+WqXLj15jFkFJwQNkpHI4zc/BFNX4CZKmc9Iu6oII6kMcNk9OB8AkeS0+jKK8RM8tvh8fT3sYRFlsWz9LQFBvPr/JvfB+4VTYwbqX687udO/sD8CuO119eHgW67vHEKW0FwEq6ujtjRkiCcqgvu1eCmCFKtsLzl1GdnuE8MV+rBMWrZTWKo+dA+9ALQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym5QUXdQcnhLY0haR2JFSFFObDlhV0xBOWpMa2lKb0FmMHJWZXBQNmFNUDBV?=
 =?utf-8?B?UzBMLzR4MFBZWUNubGcvd0VmcHZCMHRIUHB4dEJVcUh2YnZuWWVOb2w2UG9N?=
 =?utf-8?B?M3pzSXZ6NXFqc0VkanpUWlgzdlZZLzNld0FxZnlGMzB0ZnlyT0krN2J5YXAy?=
 =?utf-8?B?ME1ROUJVQnQwWXJYbys0SG5YTlBBb1lIR0lTRkNCUmptb3o1dDI1U21FZHNO?=
 =?utf-8?B?VjREb2ZUVmVHUG9sR3NCM0drbXBMQXhQTXFJc1lqT2xYa0Q4bnlSeFFNeit3?=
 =?utf-8?B?ZDdNZGF3aUhnY041dS84eXJ0eEIrTVYyaVZ1TUJQaWppNGw1WkQ1aU8wbHRZ?=
 =?utf-8?B?c3BZNmNRakJ3YmttRmhZVmZFZDVDVElnbXlaYW05eGNoNTFCWDk1dVNuMTVO?=
 =?utf-8?B?VjVnbkp4RlYwNDhxb04rRnFrZUxNK29tRk1vVDRzdzRGSThtWFplbEJ5RnNI?=
 =?utf-8?B?NkZnQVJxVVBrN2V5dTBYcjg5K2JWOEVjcXhFeU1YdXY3RWFWRmpYSUw2NFN6?=
 =?utf-8?B?Mm80elZkYWs2YjgwallLY0hYZjh0QUlBTmRjSGk3UlRpSGIyOVJtd0hxbmlZ?=
 =?utf-8?B?SjdGTCtwbGh0WTdrM2xkNmVCU3Bna0JzNXpqbndMVHFaTTA5bW9XTU51dllM?=
 =?utf-8?B?N0M0UTJHRFphV3JXWk1UZElveUtISUFVcFViYXUwVzdsYVhueWwyeFZza2xZ?=
 =?utf-8?B?bCtodDZIRVNQeFlSTUpkZ1M5aFRxTGFGaGc2OWhQcURBbzJWMjFubTFBQ3I3?=
 =?utf-8?B?emgralJkUTR5M3dWejlVd0duU2IyVko1WXpEeDZ6Y1dsYkJNT0ZEMy9QTU1h?=
 =?utf-8?B?M0oxbkpBUzVtancvSUtFNkNGeXh3TjdPQmlLbTZRclNUb3Yrcmo0S2VOcWVr?=
 =?utf-8?B?bXhzKzNFSE8yNlloZEJJTjFCVDlIQXNweDNmNnU4dXZ1WnpuUU95b2g4UXBu?=
 =?utf-8?B?bG5SOVBjc0krYTMza2trT2NxWSs2MS81R0czSWdvbVVub0tGTWZpdU5WZUtV?=
 =?utf-8?B?SU9ZR0FpWmg0SWQ0RmtyNy9xZHF6ak02emVvNG5zNXZPQ0kzRWdXdmNXbUpT?=
 =?utf-8?B?QUZYQlhpUkxDWFo1cjVrZW1PRk96VHE5OUpNMVZlcnRVNlUvWkdzZE1FeFBP?=
 =?utf-8?B?QmUzWnArN0NKem5jTHZrZ1hQYmNWbkpSQlJ0MGV1RlBzTUREL3VUeGxFY1E0?=
 =?utf-8?B?ZE5LWUo5WjdyR0x2QTZYdFVmL3p4Z0MvVkV1N1VwT1E3KzVhQU5QZHRkdWxy?=
 =?utf-8?B?RDltOFpBWk5xNEFOL2xZRlNHODlTeURWc1Y4b0hwci9jVlkyUEM1eVZlZC8v?=
 =?utf-8?B?RmNDM3pHajN5T0JoYzJoNm5RKzI5QVpFUXZadWVZcUhzdFFlWmRjbW9mT3E1?=
 =?utf-8?B?UG9tb0lESEZOSnRJaExHdWM4eHp4NE9Db1VUMHM3VjNXTUljYzNXdVVxa0RT?=
 =?utf-8?B?aUdCWVR4NW1hR2R2T0NXWW9ROGl5aUV0aWFxTUpvYlZKR0MxQTJ1V1ZiQlB5?=
 =?utf-8?B?RFR3Z3dReUV4cWtXNXlaeTlNTVZMOE03NktLVkNTYlpEY0JNRk5zMGNxTWdY?=
 =?utf-8?B?TDA3em96dExyTGdUTnphdTZsWEkxUlgra3laSGdlb21wQjh0RGc0RTl3UU9R?=
 =?utf-8?B?bzA5RkhuR1hzbmo4T29xVStRWXM0NlhhaDV2MFYwbVQxRGlkQ21lOGM0Nkdw?=
 =?utf-8?B?WUZzRjdGNGgza1Jqcm90bTRtUGNJUWhIdEJBRjYwN1g1bCtPYlg5Q21RalZn?=
 =?utf-8?B?NjlzQWZEcVUrWkhocjJHK2VNWnByU2gyU1phU1U5TjFXNUZqYU5mRWVxYmVV?=
 =?utf-8?B?QkNhM0VoaVlsTklsRThCZmN0OHdwS25MVUFKWWNrUlhFSXYrVEh2VllYWk5H?=
 =?utf-8?B?am85QjE0enU3R2UzUHEzWkVrNDE3QndoVkphTUt0MEowUFJ1S0tnT3pJYVMv?=
 =?utf-8?B?UnIvU2pxNU9KL1dTT0VBQ3crZ1BTYUdObzJRT24xZElLZzlvZ2JJQ3p2bnUz?=
 =?utf-8?B?b0JXUVVqYk5jVzV3eTJ1RW9KaXAwaGV1TW0rUmtZWE5HTDJLd2o1OUg5cmcr?=
 =?utf-8?B?M0phUzlhS1NyZzRwNVkrc3p4MVNndjMyUVIxYjNLZlU5dnJxaTNRenROMGs1?=
 =?utf-8?B?VjE2bVFWTUlEMzNlaldNdTlJbU9GTzdjWjJBN1FxRXJMMWp6Tmp0ajJGUjIv?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <477B7CCF4169DC4492095BE3FC095E73@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083a5e5e-68c0-4562-a3a6-08dc5ee11ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 13:20:17.6779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ieoEKuO6+IOKaBNtjFN1I/I5JKdoksdEq46693yxM6kXQ2NuP03e5fFlUl0BnmSwTcqWVoZvdmqE+/ZyQwVGcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7051
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTE2IGF0IDEzOjU4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEFwciAxMiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIDEy
LzA0LzIwMjQgMjowMyBhbSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IE9uIFRo
dSwgQXByIDExLCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IEkgY2FuIGNlcnRhaW5s
eSBmb2xsb3cgdXAgd2l0aCB0aGlzIGFuZCBnZW5lcmF0ZSBhIHJldmlld2FibGUgcGF0Y2hzZXQg
aWYgSQ0KPiA+ID4gPiBjYW4gY29uZmlybSB3aXRoIHlvdSB0aGF0IHRoaXMgaXMgd2hhdCB5b3Ug
d2FudD8NCj4gPiA+IA0KPiA+ID4gWWVzLCBJIHRoaW5rIGl0J3MgdGhlIHJpZ2h0IGRpcmVjdGlv
bi4gIEkgc3RpbGwgaGF2ZSBtaW5vciBjb25jZXJucyBhYm91dCBWTVgNCj4gPiA+IGJlaW5nIGVu
YWJsZWQgd2hpbGUga3ZtLmtvIGlzIGxvYWRlZCwgd2hpY2ggbWVhbnMgdGhhdCBWTVhPTiB3aWxs
IF9hbHdheXNfIGJlDQo+ID4gPiBlbmFibGVkIGlmIEtWTSBpcyBidWlsdC1pbi4gIEJ1dCBhZnRl
ciBzZWVpbmcgdGhlIGNvbXBsZXhpdHkgdGhhdCBpcyBuZWVkZWQgdG8NCj4gPiA+IHNhZmVseSBp
bml0aWFsaXplIFREWCwgYW5kIGFmdGVyIHNlZWluZyBqdXN0IGhvdyBtdWNoIGNvbXBsZXhpdHkg
S1ZNIGFscmVhZHkNCj4gPiA+IGhhcyBiZWNhdXNlIGl0IGVuYWJsZXMgVk1YIG9uLWRlbWFuZCAo
SSBoYWRuJ3QgYWN0dWFsbHkgdHJpZWQgcmVtb3ZpbmcgdGhhdCBjb2RlDQo+ID4gPiBiZWZvcmUp
LCBJIHRoaW5rIHRoZSBjb3N0IG9mIHRoYXQgY29tcGxleGl0eSBmYXIgb3V0d2VpZ2hzIHRoZSBy
aXNrIG9mICJhbHdheXMiDQo+ID4gPiBiZWluZyBwb3N0LVZNWE9OLg0KPiA+IA0KPiA+IERvZXMg
YWx3YXlzIGxlYXZpbmcgVk1YT04gaGF2ZSBhbnkgYWN0dWFsIGRhbWFnZSwgZ2l2ZW4gd2UgaGF2
ZSBlbWVyZ2VuY3kNCj4gPiB2aXJ0dWFsaXphdGlvbiBzaHV0ZG93bj8NCj4gDQo+IEJlaW5nIHBv
c3QtVk1YT04gaW5jcmVhc2VzIHRoZSByaXNrIG9mIGtleGVjKCkgaW50byB0aGUga2R1bXAga2Vy
bmVsIGZhaWxpbmcuDQo+IFRoZSB0cmFkZW9mZnMgdGhhdCB3ZSdyZSB0cnlpbmcgdG8gYmFsYW5j
ZSBhcmU6IGlzIHRoZSByaXNrIG9mIGtleGVjKCkgZmFpbGluZw0KPiBkdWUgdG8gdGhlIGNvbXBs
ZXhpdHkgb2YgdGhlIGVtZXJnZW5jeSBWTVggY29kZSBoaWdoZXIgdGhhbiB0aGUgcmlzayBvZiB1
cyBicmVha2luZw0KPiB0aGluZ3MgaW4gZ2VuZXJhbCBkdWUgdG8gdGFraW5nIG9uIGEgdG9uIG9m
IGNvbXBsZXhpdHkgdG8ganVnZ2xlIFZNWE9OIGZvciBURFg/DQo+IA0KPiBBZnRlciBzZWVpbmcg
dGhlIGxhdGVzdCByb3VuZCBvZiBURFggY29kZSwgbXkgb3BpbmlvbiBpcyB0aGF0IGJlaW5nIHBv
c3QtVk1YT04NCj4gaXMgbGVzcyByaXNreSBvdmVyYWxsLCBpbiBubyBzbWFsbCBwYXJ0IGJlY2F1
c2Ugd2UgbmVlZCB0aGF0IHRvIHdvcmsgYW55d2F5cyBmb3INCj4gaG9zdHMgdGhhdCBhcmUgYWN0
aXZlbHkgcnVubmluZyBWTXMuDQo+IA0KPiA+IA0KDQpIb3cgYWJvdXQgd2Ugb25seSBrZWVwIFZN
WCBhbHdheXMgb24gd2hlbiBURFggaXMgZW5hYmxlZD8NCg0KSW4gc2hvcnQsIHdlIGNhbiBkbyB0
aGlzIHdheToNCg0KIC0gRG8gVk1YT04gKyB1bmNvbmRpdGlvbmFsIHRkeF9jcHVfZW5hYmxlKCkg
aW4gdnRfaGFyZHdhcmVfZW5hYmxlKCkNCg0KIC0gQW5kIGluIHZ0X2hhcmR3YXJlX3NldHVwKCk6
DQogICANCiAgIGNwdXNfcmVhZF9sb2NrKCk7DQogICBoYXJkd2FyZV9lbmFibGVfYWxsX25vbG9j
aygpOyAgKHRoaXMgZG9lc24ndCBleGlzdCB5ZXQpDQogICByZXQgPSB0ZHhfZW5hYmxlKCk7DQog
ICBpZiAoIXJldCkNCgloYXJkd2FyZV9kaXNhYmxlX2FsbF9ub2xvY2soKTsNCiAgIGNwdXNfcmVh
ZF91bmxvY2soKTsNCg0KIC0gQW5kIGluIHZ0X2hhcmR3YXJlX3Vuc2V0dXAoKToNCg0KICAgaWYg
KFREWCBpcyBlbmFibGVkKSB7DQoJY3B1c19yZWFkX2xvY2soKTsNCgloYXJkd2FyZV9kaXNhYmxl
X2FsbF9ub2xvY2soKTsNCgljcHVzX3JlYWRfdW5sb2NrKCk7DQogICB9DQoNCk5vdGUgdG8gbWFr
ZSB0aGlzIHdvcmssIHdlIGFsc28gbmVlZCB0byBtb3ZlIHJlZ2lzdGVyL3VucmVnaXN0ZXINCmt2
bV9vbmxpbmVfY3B1KCkva3ZtX29mZmxpbmVfY3B1KCkgZnJvbSBrdm1faW5pdCgpIHRvDQpoYXJk
d2FyZV9lbmFibGVfYWxsX25vbG9jaygpIGFuZCBoYXJkd2FyZV9kaXNhYmxlX2FsbF9ub2xvY2so
KQ0KcmVzcGVjdGl2ZWx5IHRvIGNvdmVyIGFueSBDUFUgYmVjb21pbmcgb25saW5lIGFmdGVyIHRk
eF9lbmFibGUoKSAod2VsbCwNCm1vcmUgcHJlY2lzZWx5LCBhZnRlciBoYXJkd2FyZV9lbmFibGVf
YWxsX25vbG9jaygpKS4gIA0KDQpUaGlzIGlzIHJlYXNvbmFibGUgYW55d2F5IGV2ZW4gdy9vIFRE
WCwgYmVjYXVzZSBvbmx5IF9hZnRlcl8gd2UgaGF2ZQ0KZW5hYmxlZCBoYXJkd2FyZSBvbiBhbGwg
b25saW5lIGNwdXMsIHdlIG5lZWQgdG8gaGFuZGxlIENQVSBob3RwbHVnLg0KDQpDYWxsaW5nIGhh
cmR3YXJlX2VuYWJsZV9hbGxfbm9sb2NrKCkgdy9vIGhvbGRpbmcga3ZtX2xvY2sgbXV0ZXggaXMg
YWxzbw0KZmluZSBiZWNhdXNlIGF0IHRoaXMgc3RhZ2UgaXQncyBub3QgcG9zc2libGUgZm9yIHVz
ZXJzcGFjZSB0byBjcmVhdGUgVk0NCnlldC4NCg0KQnR3LCBrdm1fYXJjaF9oYXJkd2FyZV9lbmFi
bGUoKSBkb2VzIHRoaW5ncyBsaWtlIFRTQyBiYWNrd29ya3MsIHVyZXRfbXNycywNCmV0YyBidXQg
dGhleSBhcmUgc2FmZSB0byBiZSBjYWxsZWQgZHVyaW5nIG1vZHVsZSBsb2FkL3VubG9hZCBBRkFJ
Q1QuICBXZQ0KY2FuIHB1dCBhIGNvbW1lbnQgdGhlcmUgZm9yIHJlbWluZGVyIGlmIG5lZWRlZC4N
Cg0KSWYgSSBhbSBub3QgbWlzc2luZyBhbnl0aGluZywgYmVsb3cgZGlmZiB0byBrdm0ua28gc2hv
d3MgbXkgaWRlYToNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmgNCmIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KaW5kZXggMTZlMDdhMmVlZTE5
Li5lZDhiMmYzNGFmMDEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQpAQCAtMjMxOCw0ICsy
MzE4LDcgQEAgaW50IG1lbXNsb3Rfcm1hcF9hbGxvYyhzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpz
bG90LA0KdW5zaWduZWQgbG9uZyBucGFnZXMpOw0KICAqLw0KICNkZWZpbmUgS1ZNX0VYSVRfSFlQ
RVJDQUxMX01CWiAgICAgICAgIEdFTk1BU0tfVUxMKDMxLCAxKQ0KDQoraW50IGhhcmR3YXJlX2Vu
YWJsZV9hbGxfbm9sb2NrKHZvaWQpOw0KK3ZvaWQgaGFyZHdhcmVfZGlzYWJsZV9hbGxfbm9sb2Nr
KHZvaWQpOw0KKw0KICNlbmRpZiAvKiBfQVNNX1g4Nl9LVk1fSE9TVF9IICovDQpkaWZmIC0tZ2l0
IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCmluZGV4IGZiNDlj
MmE2MDIwMC4uM2QyZmY3ZGQwMTUwIDEwMDY0NA0KLS0tIGEvdmlydC9rdm0va3ZtX21haW4uYw0K
KysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KQEAgLTU2MDEsMTQgKzU2MDEsMjMgQEAgc3RhdGlj
IGludCBrdm1fb2ZmbGluZV9jcHUodW5zaWduZWQgaW50IGNwdSkNCiAgICAgICAgcmV0dXJuIDA7
DQogfQ0KDQotc3RhdGljIHZvaWQgaGFyZHdhcmVfZGlzYWJsZV9hbGxfbm9sb2NrKHZvaWQpDQor
c3RhdGljIHZvaWQgX19oYXJkd2FyZV9kaXNhYmxlX2FsbF9ub2xvY2sodm9pZCkNCit7DQorI2lm
ZGVmIENPTkZJR19LVk1fR0VORVJJQ19IQVJEV0FSRV9FTkFCTElORw0KKyAgICAgICBjcHVocF9y
ZW1vdmVfc3RhdGVfbm9jYWxscyhDUFVIUF9BUF9LVk1fT05MSU5FKTsNCisjZW5kaWYNCisgICAg
ICAgb25fZWFjaF9jcHUoaGFyZHdhcmVfZGlzYWJsZV9ub2xvY2ssIE5VTEwsIDEpOw0KK30NCisN
Cit2b2lkIGhhcmR3YXJlX2Rpc2FibGVfYWxsX25vbG9jayh2b2lkKQ0KIHsNCiAgICAgICAgQlVH
X09OKCFrdm1fdXNhZ2VfY291bnQpOw0KDQogICAgICAgIGt2bV91c2FnZV9jb3VudC0tOw0KICAg
ICAgICBpZiAoIWt2bV91c2FnZV9jb3VudCkNCi0gICAgICAgICAgICAgICBvbl9lYWNoX2NwdSho
YXJkd2FyZV9kaXNhYmxlX25vbG9jaywgTlVMTCwgMSk7DQorICAgICAgICAgICAgICAgX19oYXJk
d2FyZV9kaXNhYmxlX2FsbF9ub2xvY2soKTsNCiB9DQorRVhQT1JUX1NZTUJPTF9HUEwoaGFyZHdh
cmVfZGlzYWJsZV9hbGxfbm9sb2NrKTsNCg0KIHN0YXRpYyB2b2lkIGhhcmR3YXJlX2Rpc2FibGVf
YWxsKHZvaWQpDQogew0KQEAgLTU2MTksMTEgKzU2MjgsMjcgQEAgc3RhdGljIHZvaWQgaGFyZHdh
cmVfZGlzYWJsZV9hbGwodm9pZCkNCiAgICAgICAgY3B1c19yZWFkX3VubG9jaygpOw0KIH0NCg0K
LXN0YXRpYyBpbnQgaGFyZHdhcmVfZW5hYmxlX2FsbCh2b2lkKQ0KK3N0YXRpYyBpbnQgX19oYXJk
d2FyZV9lbmFibGVfYWxsX25vbG9jayh2b2lkKQ0KIHsNCiAgICAgICAgYXRvbWljX3QgZmFpbGVk
ID0gQVRPTUlDX0lOSVQoMCk7DQogICAgICAgIGludCByOw0KDQorICAgICAgIG9uX2VhY2hfY3B1
KGhhcmR3YXJlX2VuYWJsZV9ub2xvY2ssICZmYWlsZWQsIDEpOw0KKw0KKyAgICAgICByID0gYXRv
bWljX3JlYWQoJmZhaWxlZCk7DQorICAgICAgIGlmIChyKQ0KKyAgICAgICAgICAgICAgIHJldHVy
biAtRUJVU1k7DQorDQorI2lmZGVmIENPTkZJR19LVk1fR0VORVJJQ19IQVJEV0FSRV9FTkFCTElO
Rw0KKyAgICAgICByID0gY3B1aHBfc2V0dXBfc3RhdGVfbm9jYWxscyhDUFVIUF9BUF9LVk1fT05M
SU5FLA0KImt2bS9jcHU6b25saW5lIiwNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAga3ZtX29ubGluZV9jcHUsIGt2bV9vZmZsaW5lX2NwdSk7DQorI2VuZGlmDQorDQorICAg
ICAgIHJldHVybiByOw0KK30NCisNCitpbnQgaGFyZHdhcmVfZW5hYmxlX2FsbF9ub2xvY2sodm9p
ZCkNCit7DQogICAgICAgIC8qDQogICAgICAgICAqIERvIG5vdCBlbmFibGUgaGFyZHdhcmUgdmly
dHVhbGl6YXRpb24gaWYgdGhlIHN5c3RlbSBpcyBnb2luZw0KZG93bi4NCiAgICAgICAgICogSWYg
dXNlcnNwYWNlIGluaXRpYXRlZCBhIGZvcmNlZCByZWJvb3QsIGUuZy4gcmVib290IC1mLCB0aGVu
DQppdCdzDQpAQCAtNTYzNyw2ICs1NjYyLDI0IEBAIHN0YXRpYyBpbnQgaGFyZHdhcmVfZW5hYmxl
X2FsbCh2b2lkKQ0KICAgICAgICAgICAgc3lzdGVtX3N0YXRlID09IFNZU1RFTV9SRVNUQVJUKQ0K
ICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQoNCisgICAgICAga3ZtX3VzYWdlX2NvdW50
Kys7DQorICAgICAgIGlmIChrdm1fdXNhZ2VfY291bnQgPT0gMSkgew0KKyAgICAgICAgICAgICAg
IGludCByID0gX19oYXJkd2FyZV9lbmFibGVfYWxsX25vbG9jaygpOw0KKw0KKyAgICAgICAgICAg
ICAgIGlmIChyKSB7DQorICAgICAgICAgICAgICAgICAgICAgICBoYXJkd2FyZV9kaXNhYmxlX2Fs
bF9ub2xvY2soKTsNCisgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByOw0KKyAgICAgICAg
ICAgICAgIH0NCisgICAgICAgfQ0KKw0KKyAgICAgICByZXR1cm4gMDsNCit9DQorRVhQT1JUX1NZ
TUJPTF9HUEwoaGFyZHdhcmVfZW5hYmxlX2FsbF9ub2xvY2spOw0KKw0KK3N0YXRpYyBpbnQgaGFy
ZHdhcmVfZW5hYmxlX2FsbCh2b2lkKQ0KK3sNCisgICAgICAgaW50IHI7DQorDQogICAgICAgIC8q
DQogICAgICAgICAqIFdoZW4gb25saW5pbmcgYSBDUFUsIGNwdV9vbmxpbmVfbWFzayBpcyBzZXQg
YmVmb3JlDQprdm1fb25saW5lX2NwdSgpDQogICAgICAgICAqIGlzIGNhbGxlZCwgYW5kIHNvIG9u
X2VhY2hfY3B1KCkgYmV0d2VlbiB0aGVtIGluY2x1ZGVzIHRoZSBDUFUNCnRoYXQNCkBAIC01NjQ4
LDE3ICs1NjkxLDcgQEAgc3RhdGljIGludCBoYXJkd2FyZV9lbmFibGVfYWxsKHZvaWQpDQogICAg
ICAgIGNwdXNfcmVhZF9sb2NrKCk7DQogICAgICAgIG11dGV4X2xvY2soJmt2bV9sb2NrKTsNCg0K
LSAgICAgICByID0gMDsNCi0NCi0gICAgICAga3ZtX3VzYWdlX2NvdW50Kys7DQotICAgICAgIGlm
IChrdm1fdXNhZ2VfY291bnQgPT0gMSkgew0KLSAgICAgICAgICAgICAgIG9uX2VhY2hfY3B1KGhh
cmR3YXJlX2VuYWJsZV9ub2xvY2ssICZmYWlsZWQsIDEpOw0KLQ0KLSAgICAgICAgICAgICAgIGlm
IChhdG9taWNfcmVhZCgmZmFpbGVkKSkgew0KLSAgICAgICAgICAgICAgICAgICAgICAgaGFyZHdh
cmVfZGlzYWJsZV9hbGxfbm9sb2NrKCk7DQotICAgICAgICAgICAgICAgICAgICAgICByID0gLUVC
VVNZOw0KLSAgICAgICAgICAgICAgIH0NCi0gICAgICAgfQ0KKyAgICAgICByID0gaGFyZHdhcmVf
ZW5hYmxlX2FsbF9ub2xvY2soKTsNCg0KICAgICAgICBtdXRleF91bmxvY2soJmt2bV9sb2NrKTsN
CiAgICAgICAgY3B1c19yZWFkX3VubG9jaygpOw0KQEAgLTY0MjIsMTEgKzY0NTUsNiBAQCBpbnQg
a3ZtX2luaXQodW5zaWduZWQgdmNwdV9zaXplLCB1bnNpZ25lZA0KdmNwdV9hbGlnbiwgc3RydWN0
IG1vZHVsZSAqbW9kdWxlKQ0KICAgICAgICBpbnQgY3B1Ow0KDQogI2lmZGVmIENPTkZJR19LVk1f
R0VORVJJQ19IQVJEV0FSRV9FTkFCTElORw0KLSAgICAgICByID0gY3B1aHBfc2V0dXBfc3RhdGVf
bm9jYWxscyhDUFVIUF9BUF9LVk1fT05MSU5FLA0KImt2bS9jcHU6b25saW5lIiwNCi0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAga3ZtX29ubGluZV9jcHUsIGt2bV9vZmZsaW5l
X2NwdSk7DQotICAgICAgIGlmIChyKQ0KLSAgICAgICAgICAgICAgIHJldHVybiByOw0KLQ0KICAg
ICAgICByZWdpc3Rlcl9zeXNjb3JlX29wcygma3ZtX3N5c2NvcmVfb3BzKTsNCiAjZW5kaWYNCg0K
QEAgLTY1MjgsNyArNjU1Niw2IEBAIHZvaWQga3ZtX2V4aXQodm9pZCkNCiAgICAgICAga3ZtX2Fz
eW5jX3BmX2RlaW5pdCgpOw0KICNpZmRlZiBDT05GSUdfS1ZNX0dFTkVSSUNfSEFSRFdBUkVfRU5B
QkxJTkcNCiAgICAgICAgdW5yZWdpc3Rlcl9zeXNjb3JlX29wcygma3ZtX3N5c2NvcmVfb3BzKTsN
Ci0gICAgICAgY3B1aHBfcmVtb3ZlX3N0YXRlX25vY2FsbHMoQ1BVSFBfQVBfS1ZNX09OTElORSk7
DQogI2VuZGlmDQogICAgICAgIGt2bV9pcnFmZF9leGl0KCk7DQogfQ0KDQo=

