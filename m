Return-Path: <kvm+bounces-50428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB204AE5798
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 00:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E1D17B4692
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D02227EA4;
	Mon, 23 Jun 2025 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hTJl3iJD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0E219E0;
	Mon, 23 Jun 2025 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750719115; cv=fail; b=HxPFaduk7gxYvpJflQ4nUde3rjeGBUcx1Iqf94rC1LUPX4QmBUA7VVXFoJt5surL5YlSgSsPRhcagFbY8pJiMPkRTezUG5LVjAMUJ4Ygc2o7vf4OnbOhd8ixKML1H9CzgKhr6ELpDWLQdel/cZm9Q1rdb2nVWWWBl7P+gC1bc0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750719115; c=relaxed/simple;
	bh=077SVm++EI/5pYBPSnB/wY3YjgGb1XE8c3O0xUzE1xs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oVasC8CaBMFfD+h9vsrbXXe6cDN7lXzYfRr7bB7QRbxZsek6FY4Tm76AO+vcLJScoMVKaHJnbzYcJ8Q7N4KwE3SnyPBbWRb1fqfJmShBX5Z2MZPtiB2urNfNfmOj/qEIeLI3zFgaZ5zIzldw647H0g8XHz20B5nIKBSEGEiyGFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hTJl3iJD; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750719113; x=1782255113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=077SVm++EI/5pYBPSnB/wY3YjgGb1XE8c3O0xUzE1xs=;
  b=hTJl3iJD/fWbogihdy1U29FcSYBNc3M938gwY4AUKZ3J0Ut31hDATWXf
   qMe8MzRuXQ/wUVdz7BbnUNg9xPPXExZx2/ZysNdbFaEs4lU6VsoupFL++
   GtlfurgpqQICG2QJyfkuywke/BfO1ASCa/hHj0fu1tQxTd5Yu9mXo5UKT
   XRztCqlJUqq+WwZBn0iPB0rGLWWO1GyosR2Qia9cbXqh2czI5D8RQXb35
   /bv+is8zI5EGXGsHnbJ8bvwqvjYhnpVfy7G2aQQe4aoMQJ32oSZV7zJiw
   ooUkA0VjpY0vb0m+NSbOd5KnNZJLTVEHc9/hXmiDihyjd1LlWHLsHLmqp
   Q==;
X-CSE-ConnectionGUID: D306Ae0/Q/W3XLAzIV4JkQ==
X-CSE-MsgGUID: m0+mDrolSx6uxyQJU+NcOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="52060052"
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="52060052"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 15:51:50 -0700
X-CSE-ConnectionGUID: +odBoWiuSjSCClDEUsgOPA==
X-CSE-MsgGUID: 1DFscX2mQ2qHGShtaDPtyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="155738526"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 15:51:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 15:51:49 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 15:51:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 15:51:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wd3gjqwMzJ2RpdyKwjDtPavLZWxxD2CKAgDKmGDEcnJGpYw5G0MVOu6R8VCKAvhC7k03pG4bzCNjcmp0pGG1Lge9rGuEoshaFQRYQYiPgCibrZO1Mo0Caa3NcKuE64mOCCcIURGtFPaAfHMcaT0dDzA0YDxHuIpZfHKxLZ4yBmjNGFR/D0uT5/lxdUf/EV7Di+PNbCh6gwZaeq6iLcRYp+4dPeJqKvsoyOxoGTDL0M3FeSHZ+TQ7XCjcllHTEf0W/3MJYruvZn+0+o9FmJ48VCKGsvW5g6S190lU8D9CuHFEX9HyZHlMVtkahpbG4pFx69xzQXxBoOpWMLqj4bAuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=077SVm++EI/5pYBPSnB/wY3YjgGb1XE8c3O0xUzE1xs=;
 b=lOgd3+Y+2pcQ5KTF1E9I2MVvVZZ8NqKLNdoPNWCmHkHsEgkdo2ktX6ZmzgT8kKLXe2lzh03RUZQFszESna7ng0X8gCdCQFC9eHkoc/U8jwqlYpM9h6GHHa4j2UA7KJa6uPl4M4Rh/70mLdkEGpfVshuQyi0P+3uTJrSbSArC8xY+yIbbDxwKXurrA9KTF72p2/MuymXt3HZU+W7vOFhkOgk/50Pzq/6p9VxsLz2MaptOR8933ZSvE2eoWwkFYokmtnERIVC28pf6qca7UB2MnCbebYP21RR/NOzWSfHmDtFNReT0cENHd62ZPVc15pBqqHNyQH+v83cLkFAcPhdGVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Mon, 23 Jun
 2025 22:51:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 22:51:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Topic: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Index: AQHb2raQMvS71doOpkSd//tZsUmNFrQFK1QAgANI6wCAAAL4gIAAKpgAgAEMaACAALJ8gIABx94AgABM3ICAACfUAIAAJO8AgAA5jYCABAUmgIAAQsyAgAAprYA=
Date: Mon, 23 Jun 2025 22:51:46 +0000
Message-ID: <bb4e47e7569549d1bb288228e0f7976936c4410c.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <20250611095158.19398-2-adrian.hunter@intel.com>
	 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
	 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
	 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
	 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
	 <aFNa7L74tjztduT-@google.com>
	 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com>
	 <aFVvDh7tTTXhX13f@google.com>
	 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
	 <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
	 <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
	 <CAGtprH9RXM8RGj_GtxjHMQcWcvUPa_FJWXOu7LTQ00C7N5pxiQ@mail.gmail.com>
	 <2c04ba99e403a277c3d6b9ce0d6a3cb9f808caef.camel@intel.com>
	 <CAGtprH-rUuk=9shX9bsP4K=UPVvG1cUJCiXBfW07mZ1cjtkcQw@mail.gmail.com>
In-Reply-To: <CAGtprH-rUuk=9shX9bsP4K=UPVvG1cUJCiXBfW07mZ1cjtkcQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5148:EE_
x-ms-office365-filtering-correlation-id: bd324c28-f7b2-4efa-c735-08ddb2a887f5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K0h2MUZ0TzhpUmt5Vm5PTDI3UjNwa01BU3VMNEc5VC9RbG5DYVBmZnJ3QUZi?=
 =?utf-8?B?MXl6d3pxMHN1czF3bHpudlpQYW5QVFN3T05pMUx2dnZ3eGh0MXRKYml4bERK?=
 =?utf-8?B?aDdIVE1pOUlqaWp3cklITGc2eCtnY24zbU8wY28xQ2FQdHpwanRwZDg4bXQw?=
 =?utf-8?B?UEpUNVBneUJuKzVxNnpVTk9lOTJ5eVBFWGpmcmdrOFlhcXpMaGlWYWsrazJm?=
 =?utf-8?B?dDVHclhPbURRckF5bks0SDRRNVBEWlpiVWhBTm1jbVpuSTJCb3FhNDJhMWZs?=
 =?utf-8?B?UCt6dERlQ0F0eWlqek02S2FGUmFpaEhVeW5NTkpPekNJbnRBWEJ5ZkFoaWlw?=
 =?utf-8?B?aFRPT0FoVE9vMXN5clMyUEQrYi9vaVJvN1Q0VERtb2MrQWxNMVVrK2ZGVU1o?=
 =?utf-8?B?RUVCcDNKNExBSDdORUJrdWJxb0QrT3c4SGM2WGlESTFmS0hWMkVDeTBzMXNS?=
 =?utf-8?B?TGFGbTFVUTRYdXRMWDV3YVdFK1hEUEtmcWRZR0FyeGVPNDF3KzRTcmVYZjE5?=
 =?utf-8?B?UFR1aTRieVNIajlBenpVL2hmWmI1STROblJHUitGc1Z2bkdKWnpUVTlrUDVN?=
 =?utf-8?B?bHVPd2tzYTd0SzlpWEpVUWJNMy9TUStMd2NoQXB4SGh4bmJCS2JLaTZITC9H?=
 =?utf-8?B?SnIrOFVwbC9wdGl6MkFjVy96TGRvZXR2RkthakROQ0VBL0VKMUNPNDM5Wkpw?=
 =?utf-8?B?MU9Gdzlvb3pRYTZKb0t3c2RZTyt6QVVtL3dMY2hjblZ2Z1VTYW9XYzBnaUVU?=
 =?utf-8?B?M3VkVG1EblV0UHJvZEhzWUMzUVo2amY2aUM2R3gxb2dqc0ZpNlZDUDFIQS95?=
 =?utf-8?B?amp0VHBhVXYwLzNpbmdyWE80T01ZVTdTZkl2Sm5XT3hGdE5KTHR2alZtc2JL?=
 =?utf-8?B?ZHFKbk13dHRwMFNNdGxyeHpvUVdESkhVMUIzQUI5d2RWa0RnVzlUVGx0OFYr?=
 =?utf-8?B?QjZsczVCL2hCbEFSajduSVJLdGViM2MyTXlGd3ZueDRBYXNaNThsN1BXbjZu?=
 =?utf-8?B?a00yeG40d2lxV0x3T3ByQ0ZOS2pYbVJqMkVLZlZZaFFrd2xnWGpWK2J1eUtW?=
 =?utf-8?B?YlEyTGk1ay9EZlFySENiV1ZJalZ6R2NuZDhXdHpiMC9FSnpIM0NkMGtPSkRa?=
 =?utf-8?B?cmVJQnpJa2RCTi8vUDA3Qld1ZlJzdHdCVUR4Sm1kZXZLODVzTDBoZk9pREZv?=
 =?utf-8?B?Y2tETHByK0h2VTNnNE9uWU1Mc29qVnI2TC83LzZ1RlVZdTNKVy93bTlOUkMy?=
 =?utf-8?B?cThMNGlBcFltS1dBelpGalJqYVNJeXRZamZSbUFHUFcxQ21OcDd1eEZhaUQ3?=
 =?utf-8?B?dFE4RlM1QVhOY1U4d24xblpTa3hJUUdCdFVCaFZ5dDdlU0RETVF2ajJ3L3NE?=
 =?utf-8?B?aUw5UmxvT3VtdWkwbDRJcVBSQktHSytEVU9ZNmlkcFZRZHljaVU4ZWswT2tr?=
 =?utf-8?B?cHh2L3BTMFhyMngvZlAvMnNQekg3QXhoeHZ2bmNTSmVmSWFyTlJjZVJkOUM5?=
 =?utf-8?B?OEhsZ3ZUdmNCTFBNV2Q1eGQ4YTRubVRURnplVHFBRFFzT2paYkhla0dKandU?=
 =?utf-8?B?VVJEM2RVTzRGa2lDWCtDaysrQy9JZzBXVkZQaVJXZUUvL2lId25NeE1UcmdU?=
 =?utf-8?B?OExEWHZWRlNlb2g1bVgzNm9VczIwUHAwNW91S2tEcGIrY0JCcW1YNWk5OC96?=
 =?utf-8?B?NUs1UXNyQzNHT0RYSjBCdmxBRHFxem9JaGh4ZFY1R2RvWVRvbmdnWGsvZlVH?=
 =?utf-8?B?WDJrS25laGQ4OUpTdDQ2WjVpeFQ2M0xibUgvUk5LWW5VTStGM0xYaUprZVdh?=
 =?utf-8?B?c2hXR1M0dzRISU1JZGNvaGNmbnM4QkxkY004emUyNXJCS2VPeWdpT3pzaGda?=
 =?utf-8?B?UWFHcmZvQmxhaGxncHBBcENwMXhCS3lDTjU3bEkxYllzUG9JQkEyai9WTEtM?=
 =?utf-8?B?UDFMM1RtdysxL00zOXFYRUordHZJS2IzSlZ5dGYxK3k3clcvQ2lPZ1BSN1d3?=
 =?utf-8?Q?PeFoAEA4G/Afc/5JW0V7K1srmOvGiI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1VVRjN2NG5MSEU1RkQ3YkI3TzF5azRyRHN0eWdTa3hYY3o4TjhpY0lxZXZV?=
 =?utf-8?B?M3dmNXB0M0VERkdNUlo1MXI5U0JIbytTTTRNZSt5bjMvSWtzbGdCNlZrYlQ5?=
 =?utf-8?B?VjgwQXgyUjNRaWVHUjdIWWkrTzNFeitacWZMMXJzMkVsMTZNUW9KOGN3eHRE?=
 =?utf-8?B?N3hEWU1QOTN0ODhPSlRET0dDRnEvakFOOXg3dlhhMmhUbWhFNUpuQkhEVUtV?=
 =?utf-8?B?Ym1vRm9MR2ltd2FpdmNRK2lSeEg0dkdRNjNOck93ZTNmWGxyai9IQkJlRFds?=
 =?utf-8?B?Q09YMExvNzNRZHh4U05kRlo4NmtUS0FEZ0Vid2dwQ1NaTnhWUVRoc2daSTJJ?=
 =?utf-8?B?VHY5emxCaldoU1ZSTGxVZGhCYzhEOVA0LzVUN2xCNDJ3YjJVQldrVlBxMDNk?=
 =?utf-8?B?bUhvODJ4L1g5TDZFaXpqc3QwKzJVdDBjaDlyVWhzcEVUbWdOK1BGaHVuTmdl?=
 =?utf-8?B?Y0Q2Y3hzZ0xSK0lZem5kM05mN1Z0OGNWU2ZJelV3RmdjS1FNV3lMQTN0UFZE?=
 =?utf-8?B?RngzRG9rT3hkZGcwcy9vMENOWG1iV0pocnlydFJsT0NEeGYwK3k4eTlyZlFH?=
 =?utf-8?B?ajZNU3FYQXgzTVBOcGVmcGhqR2MrMWVwZ2U5MWNWcHhFeDRFK1NzUnF1eHov?=
 =?utf-8?B?SWNlTlZ3N3pQSE16WTR4by92QUNqU3J0UitMdVpVZm4zbnBSRE56emhZc1pn?=
 =?utf-8?B?OU0xV1ZxYmxQWmF5bmVJZms3cjhjT2h2RWJ4RG1FQ0w2WEJQd3hibk8vRFJv?=
 =?utf-8?B?TjcvMFNVNVR5ZzQ0ck44elJacUNya1RKZkc1TUloeGJoT250aEtmaTlpV002?=
 =?utf-8?B?Ujg2MWNwY29vS2hGYmdqS2dkc2VuVG5sMkRzVlVWS05YblRQR3VoL3BOWHVw?=
 =?utf-8?B?eUxuQzJNalMzSHg2WnRRUDRzazA5N1dCM0N2M0w1M2VFeTFGcGFEYkwyeTU3?=
 =?utf-8?B?TVlIczUzazhUaHNnWkJSeUFFUVdibDdPVlhld3p1UmhxYlFWTnB1K0M3WHJV?=
 =?utf-8?B?WXlkTEQxRnZQYm8rOXczNk9tL0pYdTFsOVF3TzJkdkVBZVhIaTdUWGdxb09h?=
 =?utf-8?B?QlRoVWN2SzJUTUVjNDRxeWQwZWhmSkwySDNZOEtMUUF2TmJiNStKbnR4RHFF?=
 =?utf-8?B?KzNCYnFyeC8wb0JhY3NpNERubUFNLzk2LzhZTUhmY3A2bW93VjNTb0dUK0do?=
 =?utf-8?B?RndzbWRtT0JHT0w0WVhOazRjbjN1UE83S2lXU3NjZHY1SCtKamFLMFJTQ2Q4?=
 =?utf-8?B?WkxBOVE2Y0ZPelRRMnZraFU0VmJ3Z2NSZmh2QUtzVWVNQTNFTElaVDZHbGMz?=
 =?utf-8?B?UnRzamtSZWJubVc0SFN4b0RlWldzSFFXdVBjQTR6enFDTEtyN0tHejVCOWZh?=
 =?utf-8?B?QWtPcmQwd3A0N1VNN0dTOFRyWHd0dkJjVVZWaUxIRTRHTlVKekVZSi9la0dS?=
 =?utf-8?B?b1RacU5YSVFOZTJLK2VyaW5oMXoxcHZKUFdwWS92UjdwcmNFeUZRWGphTUY3?=
 =?utf-8?B?VnhwM200OEhpdVhhRGtsNFpHbzluQ0ZYUWN6Q1MvU3RMVHFHUGhSQW41UWtl?=
 =?utf-8?B?dnhmRG55QjQ1QTI5M2h4YW9WRmV3R21SV1pWRGl6ek9Ia3hqbGpyVUVSWkVx?=
 =?utf-8?B?M25IT2treUlRa0huR0VHQStpb2FMVlRFS0llTUplaE5UcXZJZ2haME5NZE1a?=
 =?utf-8?B?LzFsOFFPWmhYcGYvbnRucWdES2cwQlIycDFMTnMzUGF0bXY1aEFadjRRQlA3?=
 =?utf-8?B?OW0vSkR0bW1uaDhRQjh1M3pLdnRIVGRNeFkzWEh5azlaMTFtRi81WlBGVSt1?=
 =?utf-8?B?ZFAyUGtxVkJuYTMxM0QrVjU3OXFia3pCMjM2N0c2TWlXS1JGUXZLY1pHVTVU?=
 =?utf-8?B?clJaSzY5ZEZpNFYzY1lkU2VBZW1SbTArUndBRkJkZUsrRXFtVlF5OXV6b1Qr?=
 =?utf-8?B?b0puOXJpZDRPc2hxbE1LQUlPMWRiTXVNbDBaQW90MXhMSzdhVVBKanNEL1J0?=
 =?utf-8?B?Umg5TkVKZUtObGcxV2cxd1VCaDJQK2dlcXQ0NEJvNFlud0s1bTdRd3JEdEJh?=
 =?utf-8?B?czVtYXVyd1NKUEtjdkpUZVFwZlFob2V2eldmWGJyeTEzcmpIZnp5OXJBNURI?=
 =?utf-8?B?RGpVQitySW12bVJ0dVVsaVRnc29vWHUydFVNMStNMlZySk9mNCtoZzFyRzZt?=
 =?utf-8?B?Nmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DBEFD3ABF933C4897FA1F5963D78E88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd324c28-f7b2-4efa-c735-08ddb2a887f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 22:51:46.1646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7edMBvO7jPaDE1aGsEYVs//k7RerKl07epP9/OuOze6Gk51ugoQ4u1GSpexo7NPp7h4WDBS902tgZVi+F4uTGySsRUTEQPyg+s9DIMZGVKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTIzIGF0IDEzOjIyIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBBIHNpbXBsZSBxdWVzdGlvbiBJIGFzayB0byBteXNlbGYgaXMgdGhhdCBpZiBhIGNlcnRh
aW4gbWVtb3J5IHNwZWNpZmljDQo+IG9wdGltaXphdGlvbi9mZWF0dXJlIGlzIGVuYWJsZWQgZm9y
IG5vbi1jb25maWRlbnRpYWwgVk1zLCB3aHkgaXQgY2FuJ3QNCj4gYmUgZW5hYmxlZCBmb3IgQ29u
ZmlkZW50aWFsIFZNcy4gSSB0aGluayBhcyBsb25nIGFzIHdlIGNsZWFubHkNCj4gc2VwYXJhdGUg
bWVtb3J5IG1hbmFnZW1lbnQgZnJvbSBSTVAvU0VQVCBtYW5hZ2VtZW50IGZvciBDVk1zLCB0aGVy
ZQ0KPiBzaG91bGQgaWRlYWxseSBiZSBubyBtYWpvciBpc3N1ZXMgd2l0aCBlbmFibGluZyBzdWNo
IG9wdGltaXphdGlvbnMgZm9yDQo+IENvbmZpZGVudGlhbCBWTXMuDQoNClllcywgaGF2aW5nIHRo
ZW0gd29yayB0aGUgc2FtZSBzaG91bGQgcHJvYmFibHkgaGVscCB3aXRoIG1haW50YWluYWJpbGl0
eS4gQXMNCmxvbmcgYXMgbWFraW5nIHRoZW0gd29yayB0aGUgc2FtZSBkb2Vzbid0IGNhdXNlIHRv
byBtdWNoIGNvbXBsZXhpdHkgc29tZXdoZXJlDQplbHNlLiBpLmUuIGtpbmQgb2Ygd2hhdCB3ZSB3
ZXJlIGRpc2N1c3NpbmcgaGVyZS4NCg0KPiANCj4gSnVzdCBtZW1vcnkgYWxsb2NhdGlvbiB3aXRo
b3V0IHplcm9pbmcsIGV2ZW4gd2l0aCBodWdlcGFnZXMgdGFrZXMgdGltZQ0KPiBmb3IgbGFyZ2Ug
Vk0gc2hhcGVzIGFuZCBJIGRvbid0IHJlYWxseSBzZWUgYSB2YWxpZCByZWFzb24gZm9yIHRoZQ0K
PiB1c2Vyc3BhY2UgVk1NIHRvIHJlcGVhdCB0aGUgZnJlZWluZyBhbmQgYWxsb2NhdGlvbiBjeWNs
ZXMuDQoNCkhtbSwgdGhpcyBpcyBzdXJwcmlzaW5nIHRvIG1lLiBEbyB5b3UgaGF2ZSBhbnkgaWRl
YSB3aGF0IGtpbmQgb2YgY3ljbGVzIHdlIGFyZQ0KdGFsa2luZyBhYm91dD8NCg0KPiANCj4gPiBG
b3IgVERYIHRob3VnaCwgaG1tLCB3ZSBtYXkgbm90IGFjdHVhbGx5IG5lZWQgdG8gemVybyB0aGUg
cHJpdmF0ZSBwYWdlcyBiZWNhdXNlDQo+ID4gb2YgdGhlIHRyYW5zaXRpb24gdG8ga2V5aWQgMC4g
SXQgd291bGQgYmUgYmVuZWZpY2lhbCB0byBoYXZlIHRoZSBkaWZmZXJlbnQgVk1zDQo+ID4gdHlw
ZXMgd29yayB0aGUgc2FtZS4gQnV0LCB1bmRlciB0aGlzIHNwZWN1bGF0aW9uIG9mIHRoZSByZWFs
IGJlbmVmaXQsIHRoZXJlIG1heQ0KPiA+IGJlIG90aGVyIHdheXMgdG8gZ2V0IHRoZSBzYW1lIGJl
bmVmaXRzIHRoYXQgYXJlIHdvcnRoIGNvbnNpZGVyaW5nIHdoZW4gd2UgaGl0DQo+ID4gZnJpY3Rp
b25zIGxpa2UgdGhpcy4gVG8gZG8gdGhhdCBraW5kIG9mIGNvbnNpZGVyYXRpb24gdGhvdWdoLCBl
dmVyeW9uZSBuZWVkcyB0bw0KPiA+IHVuZGVyc3RhbmQgd2hhdCB0aGUgcmVhbCBnb2FsIGlzLg0K
PiA+IA0KPiA+IEluIGdlbmVyYWwgSSB0aGluayB3ZSByZWFsbHkgbmVlZCB0byBmdWxseSBldmFs
dWF0ZSB0aGVzZSBvcHRpbWl6YXRpb25zIGFzIHBhcnQNCj4gPiBvZiB0aGUgdXBzdHJlYW1pbmcg
cHJvY2Vzcy4gV2UgaGF2ZSBhbHJlYWR5IHNlZW4gdHdvIHBvc3QtYmFzZSBzZXJpZXMgVERYDQo+
ID4gb3B0aW1pemF0aW9ucyB0aGF0IGRpZG4ndCBzdGFuZCB1cCB1bmRlciBzY3J1dGlueS4gSXQg
dHVybmVkIG91dCB0aGUgZXhpc3RpbmcNCj4gPiBURFggcGFnZSBwcm9tb3Rpb24gaW1wbGVtZW50
YXRpb24gd2Fzbid0IGFjdHVhbGx5IGdldHRpbmcgdXNlZCBtdWNoIGlmIGF0IGFsbC4NCj4gPiBB
bHNvLCB0aGUgcGFyYWxsZWwgVEQgcmVjbGFpbSB0aGluZyB0dXJuZWQgb3V0IHRvIGJlIG1pc2d1
aWRlZCBvbmNlIHdlIGxvb2tlZA0KPiANCj4gRm9yIGEgfjcwMEcgZ3Vlc3QgbWVtb3J5LCBndWVz
dCBzaHV0ZG93biB0aW1lczoNCj4gMSkgUGFyYWxsZWwgVEQgcmVjbGFpbSArIGh1Z2VwYWdlIEVQ
VCBtYXBwaW5nc8KgIDogMzAgc2Vjcw0KPiAyKSBURCBzaHV0ZG93biB3aXRoIEtWTV9URFhfVEVS
TUlOQVRFX1ZNICsgaHVnZXBhZ2UgRVBUIG1hcHBpbmdzOiAyIG1pbnMNCj4gMykgV2l0aG91dCBh
bnkgb3B0aW1pemF0aW9uOiB+IDMwLTQwIG1pbnMNCj4gDQo+IEtWTV9URFhfVEVSTUlOQVRFX1ZN
IGZvciBub3cgaXMgYSB2ZXJ5IGdvb2Qgc3RhcnQgYW5kIGlzIG11Y2ggc2ltcGxlcg0KPiB0byB1
cHN0cmVhbS4NCg0KUGFyYWxsZWwgcmVjbGFpbSBpcyBtaXNndWlkZWQgYmVjYXVzZSBpdCdzIGF0
dGFja2luZyB0aGUgd3Jvbmcgcm9vdCBjYXVzZS4gSXQncw0Kbm90IGFuIGV4YW1wbGUgb2YgYSBi
YWQgZ29hbCwgYnV0IGEgcGl0ZmFsbCBvZiByZXF1aXJpbmcgYSBzcGVjaWZpYyBzb2x1dGlvbg0K
aW5zdGVhZCBvZiByZXZpZXdpbmcgdGhlIHJlYXNvbmluZyBhcyBwYXJ0IG9mIHRoZSB1cHN0cmVh
bWluZyBwcm9jZXNzLiBXZQ0Kc2hvdWxkbid0IGRvIHBhcmFsbGVsIHJlY2xhaW0gaW9jdGwgYmVj
YXVzZSB0aGVyZSBhcmUgc2ltcGxlciwgZmFzdGVyIHdheXMgdG8NCnJlY2xhaW0uIEl0IGxvb2tz
IGxpa2Ugd2UgbmV2ZXIgY2lyY2xlZCBiYWNrIG9uIHRoaXMgdGhvdWdoLiBNeSBiYWQgZm9yIGJy
aW5nIGl0DQp1cCBhcyBhbiBleGFtcGxlIGZvciBleHBsYWluaW5nIHRoZSBkZXRhaWxzLg0KDQpX
ZSBoYXZlIG5vdCBwb3N0ZWQgdGhlIGFsdGVybmF0ZSBhcHByb2FjaCBiZWNhdXNlIHdlIGhhdmUg
dG9vIG1hbnkgVERYIHNlcmllcyBpbg0KcHJvZ3Jlc3Mgb24gdGhlIGxpc3QgYW5kIEkgdGhpbmsg
d2Ugc2hvdWxkIGRvIHRoZW0gaXRlcmF0aXZlbHkuIEFsc28sIGFzIHlvdSBzYXkNCmh1Z2UgcGFn
ZXMgKyBLVk1fVERYX1RFUk1JTkFURV9WTSBnZXRzIHVzIGFuIG9yZGVyIG9mIG1hZ25pdHVkZSB0
aGUgd2F5IHRoZXJlLg0KSXQgcHV0cyBmdXJ0aGVyIGltcHJvdmVtZW50cyBkb3duIHRoZSBwcmlv
cml0eSBsaXN0Lg0KDQo+IA0KPiA+IGludG8gdGhlIHJvb3QgY2F1c2UuIFNvIGlmIHdlIGJsaW5k
bHkgaW5jb3Jwb3JhdGUgb3B0aW1pemF0aW9ucyBiYXNlZCBvbiB2YWd1ZQ0KPiA+IG9yIHByb21p
c2VkIGp1c3RpZmljYXRpb24sIGl0IHNlZW1zIGxpa2VseSB3ZSB3aWxsIGVuZCB1cCBtYWludGFp
bmluZyBzb21lDQo+ID4gYW1vdW50IG9mIGNvbXBsZXggY29kZSB3aXRoIG5vIHB1cnBvc2UuIFRo
ZW4gaXQgd2lsbCBiZSBkaWZmaWN1bHQgdG8gcHJvdmUgbGF0ZXINCj4gPiB0aGF0IGl0IGlzIG5v
dCBuZWVkZWQsIGFuZCBqdXN0IHJlbWFpbiBhIGJ1cmRlbi4NCj4gPiANCj4gPiBTbyBjYW4gd2Ug
cGxlYXNlIHN0YXJ0IGV4cGxhaW5pbmcgbW9yZSBvZiB0aGUgIndoeSIgZm9yIHRoaXMgc3R1ZmYg
c28gd2UgY2FuIGdldA0KPiA+IHRvIHRoZSBiZXN0IHVwc3RyZWFtIHNvbHV0aW9uPw0KDQpTbyB0
aGUgYW5zd2VyIGlzIG5vPyBJIHRoaW5rIHdlIHNob3VsZCBjbG9zZSBpdCBiZWNhdXNlIGl0IHNl
ZW1zIHRvIGJlDQpnZW5lcmF0aW5nIGEgbG90IG9mIG1haWxzIHdpdGggdGhlIHNhbWUgcGF0dGVy
bi4NCg==

