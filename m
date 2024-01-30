Return-Path: <kvm+bounces-7403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FA884187B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC6401C21FA6
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 01:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735DF36133;
	Tue, 30 Jan 2024 01:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b233/glJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CFF364A5;
	Tue, 30 Jan 2024 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706578815; cv=fail; b=Wn8FCqsrsIyrnn8y+jlc6qdGNIO926lOcr721RgfyM+s5wpah4Bf83YIvuBtMBF5jbrdbtXRcDqGejg6oqk6Y3bCdlczrmcc6+Dv+QFqCKGlQY4ZQYZYoBBhrYPaUIjGiOodx/XcTTGmwqv50o2gtmiYrw/QcOO+ahU4MvJ6rvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706578815; c=relaxed/simple;
	bh=w8xBkzDO4hRS0ZbpeC8L5941cdvU8mtTLf1rMEc2qVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pYNqH6sxMzr6OCp5taNS8z3iRrCoVHoMRsvymgjMsBS4NTAc5aPC6gnBPM9OyoPECjGxkaZFlDkcp5kiJ3WQnbeVzpsPV/bBiJcnomjgN811xz7+rV2x/lNL/W7OOojN7yLoPcIlbu0yYSarAxzgmNLmehoDcz5zlKe+ay0BCWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b233/glJ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706578813; x=1738114813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w8xBkzDO4hRS0ZbpeC8L5941cdvU8mtTLf1rMEc2qVY=;
  b=b233/glJND2cNRznXiV8HBDfkZrO2VHXTPTxGTtcx2UJTpoGxS8eR3u5
   Yctd8/IcnjaorTW5xoCdcv81jjxc9X+JxTcN8qMqKTvZHZjhEUtwW53Md
   07aVrW1xpdQ7ylbbmaQ/bvqHWMT7/YfR97xtZryq34P4wJnWbmGqXWuba
   M2FvBEHeRZNel6IC6BGvv+zv5NHa+PXdFq37tVSAZ+Hojkbnja/ZjhFuD
   wTPMtSxsJhuA9NKxbzLyLhML9+0tow1oBX6h3bBItzFit2TX0l37tVd3d
   gBzjN0Y5j+mAkoyhrYBrYeN0lQ/cg+2pq4TxZfv1ivoSOY9vcIsCpqhQV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="24612886"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="24612886"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 17:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="1119091260"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="1119091260"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jan 2024 17:40:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:40:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:40:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Jan 2024 17:40:03 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Jan 2024 17:40:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUwX5LTobpnYxHu3EWdBWV8bY41wHL/p49h2m2dskUwwGB2nDlHWO3GskQI5VfuOA43fIIpj9pkfEIMhRlE1ARN7BLnp/wfX/1+BJw9l6sAxt7J9ltw7A/cxFdsVlrBDq8dSEP7zEkbug7cIbN5yYsZnIfYaxs73uLZdF5LGAQo4nZOzCvCtR4MgaoYoaUIdJDCsp0a2HQDg56nZ+nQtdjWxiopXSPCfkH087PVWgcEoJXcQjW755CW+HW9h1qR0jX5FPROAfK/FETrFvm6gw80Dv+slWWl1O/qQFSu5k9aYWTjNBW5cR9RhwdB6llsFZ1KYY8WiVwj//AruIqF43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8xBkzDO4hRS0ZbpeC8L5941cdvU8mtTLf1rMEc2qVY=;
 b=SJn3GJWhz7XTogzyfLAXw7A8xfqimJPsXODPX4GCu7nOidLBYTfPPsFR97ucESDWHPjtR+yrqiB/hkVVv0QZ9yTLqnNA7Aq6yu7OCi4wcjuIDNSuYBU1xa5G3KM7s37/ONWZro8XbcDIJKAN8x5oR1xukpcnQ7SlA3bU9LCTjhXqTManEQDTmzOJPQDwu8DQ018CmrSNFNy4imHW0zHfs9vzHnvDL6b3gBSEfarYoiTHECNerG8UEXCAobC7IY9YUwMoEBbv4voZQNXn2QMHu8czWdp4U4o1Ns3RG5boWOWhP2O5tQw5oKiIOEdckWFdZE5GvZOj9f4Ycq701LKndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7823.namprd11.prod.outlook.com (2603:10b6:208:3f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 01:40:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409%7]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 01:40:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v9 00/27] Enable CET Virtualization
Thread-Topic: [PATCH v9 00/27] Enable CET Virtualization
Thread-Index: AQHaTm7+Rcyn+RV2bkySwgIepGisrLDxnZsA
Date: Tue, 30 Jan 2024 01:40:01 +0000
Message-ID: <01235a152b201705bf59088d36eb820f5b35b8de.camel@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7823:EE_
x-ms-office365-filtering-correlation-id: 0226d0c1-0390-40a5-2088-08dc2134601f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ou65+Q0HQ85rQLDX6lOBct2KO9tgvs3GHQ58XaWMv6inkGdB0B37xW6ESmRT648l8KAU/dfPOAFhTlHDiNyC3sozOpB+Lr6379IaquZbmt9E0OKFj3Vi+k6fWb0I8RhOoRhXvosm9vVyANzECn5vszBaH2jJUlTk2DYX0ukN/TrOlLawhAIP8q5NI8rQC8XTNbVy+f3pnk2QxAGlZMn9rtpSYNTRcvokJrQ68WSczf+NCTdhLdBtS4HWZS9ryyJqPf2F5FBbA90XREY3zHB9IYPjnhAMrT6MtrbAentFNkKxOdYf6K9GH9Ulb5jphAPsA4d4FyBsvo8CL4K1cOU1kT1v2IwVb54DxeFqm0ebSwmYSl2fdsR11uwWhhUThAQhw+aNHlqow/D4cZ+naXG5CwJ0aC55s2sug8jt5TvcMFlexfgiK1vrD2VG8ZQZ31zPnkXJrDPRd8trvGRndUXvEZ5MSRVkAEr1jS3i9DeAZ4AZfQE+4ps/tiVNNfLJnsYKI5VcWUWhUejPkDuaHAck1n0V9+YbDxB5Cv8SASEblT+cS1SUo/bGCyy0NDrUlySHgoYbBVz7r9vhJ0iIh/RSBYqsvP6Rh2WVwVyhonokSPuZT9lW9+o9LVk7opGlak4w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(346002)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(6512007)(6506007)(66946007)(478600001)(122000001)(38100700002)(316002)(8936002)(8676002)(5660300002)(4326008)(41300700001)(2616005)(71200400001)(6486002)(2906002)(64756008)(66476007)(76116006)(54906003)(110136005)(66556008)(66446008)(26005)(921011)(36756003)(558084003)(86362001)(82960400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0Nxbm1tRFBWaE9HYndXQ3h1V2JVR05MMVMwRU1FS2pLbUs0UkorOVE3NmJv?=
 =?utf-8?B?V3h6MGhyaDJBZk1FemRKakZ3M0NEck05dlZLc3NTM2xwYm9nbkoyK0UyRXlx?=
 =?utf-8?B?NUtubnlpRW1NMVh3bEdQYzI1VGJMTm95YU1vM2dMVTlIaUpFRmREWjhRaGJy?=
 =?utf-8?B?SjJuSTFTbUJPa0lzcDJNZ1l4dERPVmhUcUptOVZDVllOZW90dEZmVlRXek81?=
 =?utf-8?B?ejYzeHRNbEZYQVBLTlVXTWxnRFdVeXpHK1pyTFUwc0QyT0x0aG42VUwvdjJr?=
 =?utf-8?B?NkREQzVNNzIzS0J6V2ZhNGZrNVhpWWVlMmJnZytQeXhpV2MwYW56MmlhYWdZ?=
 =?utf-8?B?Ym5uTXJ5R3kwUU5MV3FVVGpQSkNzWWN3L29CeGFYOE5Wb0NVOHBIbVZjc25I?=
 =?utf-8?B?dTVvbGFkUjBWOG5Jb0lFVHNWSmZiWFJVdFRXUkJTb0NyS2tyT3ZWenlPZXNM?=
 =?utf-8?B?VU5hTHhMdmdJNUIrQU12US8yZFpnMEk2djB4bW8wbFV6aHF5SUlvcEQxbVBi?=
 =?utf-8?B?VW9HQ2djdlRuUkFGaWo2aTJydjRiVzNBa09QT2N0NVlBU21rWWNvRThjWXhn?=
 =?utf-8?B?N1A4VnNNWWZ5Ykd1QkEybXF2bGx0bHp1UXJ0OWxJU3BnZGp1aXlsZlhtM29u?=
 =?utf-8?B?R0M2UTZ2ejVZZmI4L2lkd1FhcWFURHVoR24vZTNxc1U1MkUrUHJ4S0w1QTkw?=
 =?utf-8?B?TEozTzEyWHl6UmhaVVdQMVRNSWtTS2lvc01xUlZOUWVxOHd1MFdSRW9DZzNq?=
 =?utf-8?B?eUY5ejk2Wm1nSllBVThhVUFKeUhIeC83MHczVlF6YlM2ckdxRkN0UnQ0MWpz?=
 =?utf-8?B?TlJhWnJXdzlwRnVDZUw0ZE1IbEVMQ282OHE0eFo5NUVOT2dMTmY2Vlo2ZUhz?=
 =?utf-8?B?OUYwN0FMRXgyUUR5RkFyY3N1NW1KRVNkUWpqVlRreGd0Vi96R3Q4ZkxHaVhC?=
 =?utf-8?B?NVVXSmJ0a3dZTkU1T0ZOVFhVWVZLVFFwR2c2UWE4V3JvUnBFeFZpOWFqc01u?=
 =?utf-8?B?aHh5anpNV0k2d0ZiV3E2ZVFocU1tY1BranRzL0ZoTDIyb0NkdDlPOGdHWW1N?=
 =?utf-8?B?dkxLZHIwOVFrU3hZK3ZSbUc2RmJJZ243RkRMVUlhZXZtZWt2WFc4a0tkYzhH?=
 =?utf-8?B?SUZQK1FETmVseHdibXZDRUxHakRnbDVJVENXMzJVR3lGb2JCT3JCTDdtOHdw?=
 =?utf-8?B?dGdzRlZQemsvQjhybjlXbHZoTjlBRTdSNkdKLy9hZENTMWcwNXA2NVBjMEdZ?=
 =?utf-8?B?NWlaVEpVYXBSNVNPMHRONmVQRU83MnRHL2tUM3lSdmg3S1V0SlE2TUo3QmNT?=
 =?utf-8?B?RzkxNk0xNkNMYXd5RWZzcUNsRnhieXlLWVpib2dqYy9mT0lUUmJuSTZrOS9i?=
 =?utf-8?B?NHIraTlKb0VORXpsb2hRak9mSzUvVlZWTkJOSWExc0w0c0svMVo4SHk4ang5?=
 =?utf-8?B?VW1JOHpvY0xzVlh5RjVuSkx5YUx0T3dxLy9VSS9STk5OT0R3bHpsVUx5cGxV?=
 =?utf-8?B?b21yaUZJTklkaTNVb3dnclN1RU5PQ3JBbTVjK3hrZVRBTmpSVjhzWC81NGNh?=
 =?utf-8?B?NkJsL2oxOXBEWDBnYXFnc3ladWNHQnBDWGlKT2UvOWhpdzVjOGUxYVJGcStM?=
 =?utf-8?B?R0ZFakQraWUrbkFRWGQxVWpNd1k0bFpjNG9GSjZ1N1JCVnhzeXd5MzFSdFha?=
 =?utf-8?B?b05jdnRxQmlJbXFvekIrbWxFbHF0TU9WYml4cCtHUkJsWlQyQTN5MkNPQVdY?=
 =?utf-8?B?TzVRRjRNcmRwY2FDOE5ZWmJjQmhFUHlFelgyT2Y4b1FBWG1VWEZndXNFWU9Z?=
 =?utf-8?B?WFdOOHBxRHFubzhFRGdUaGF3ek03enl1ZGQrcVk5Um10MDUxNnVQdnZ6WXg3?=
 =?utf-8?B?TGNjY0JxeUFMTFhYaUcwODB3bzlEZjRJS2hEazFXTklNQnpqNUhmdGUvWC9q?=
 =?utf-8?B?T2Faejdxb095UTRxNW8wVGNOanB1MVdUb2FNT25LZGlJYkRZM1lpVnl4S1NY?=
 =?utf-8?B?NVVDWlJScmVOYWs4cjQ2QUltbWx4NEd2Yjlycm1na0JCM0I2U3ZhNHVkL0Jl?=
 =?utf-8?B?S2tQa0lJRHRVSGlaVnBYcXBZWldueWE4SUxDRlBWRFl5UWRVcmFTM05ZbmJJ?=
 =?utf-8?B?TzNkM2dDVm4zTUJNNkV4SzFXRk5FTHRBSjI3NHRWSDYzc1Fpd1FQUWE2Q3Rs?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA905CC302C0AC48B6F5F3DB579AFE72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0226d0c1-0390-40a5-2088-08dc2134601f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2024 01:40:01.4055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izQP7fu5qZraqCU4zTEkJFgzfDjcimDAEO5nzcfX64ERRsRobGqtyEdO9kOYfLjgTQ65UBEFE+aL5QElt39GfM0JaRdN9uBzKiLOeQURMyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7823
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAxLTIzIGF0IDE4OjQxIC0wODAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBUaGlzIHNlcmllcyBwYXNzZWQgYmFzaWMgQ0VUIHVzZXIgc2hhZG93IHN0YWNrIHRlc3QNCg0K
SSByZXRlc3RlZCB0aGlzIHdpdGggc29tZSBoZWF2aWVyIHVzZXJzcGFjZSBzaGFkb3cgc3RhY2sg
YWN0aXZpdHkgYW5kDQpkaWRuJ3Qgc2VlIGFueSBwcm9ibGVtcy4NCg==

