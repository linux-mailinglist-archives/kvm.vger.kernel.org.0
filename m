Return-Path: <kvm+bounces-14786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C40188A6F20
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34C61C218B4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02EC130A42;
	Tue, 16 Apr 2024 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UeGTgh6k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C98B130491;
	Tue, 16 Apr 2024 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713279445; cv=fail; b=GVuv4gFXDBBUFfDSk5sCltC9/jwCIwTj/k8ud/wtrlIVHHFro/g4Ac0NNsr29JIufygG3aAZD/dQqvK8DlhkD9ilfbV7lhNw5ofhz8QeD2f0DiMNW3v6OkdjLuqinLxznxgH99BJsua26SCyU2N+YXZM1HTan2LYfMYpm0kRBd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713279445; c=relaxed/simple;
	bh=V43Ub+U2tVZlAioC8dK/9KNk9AthBg4fRku1kwuBbaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iick2G3JdHZonFqTfmGGuOXkuWiF5VAUwc18HIUjJjsfrb4l/oaozLCdvPcn5ueppdwbQshu5S6d6r75VrkVcoLPrXtJ16nCfi98eXQiiCpml+cc4upLaQxGDwEYv/ci5VgUc7rtnxJcdnSsg/4jRYk8jwTN0/Uw/5ckLklndPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UeGTgh6k; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713279445; x=1744815445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V43Ub+U2tVZlAioC8dK/9KNk9AthBg4fRku1kwuBbaw=;
  b=UeGTgh6kQMXnBByFekdpEYZxuh9LEl5L7y+yiuSmOwPPxNL+VhWPKP1X
   ef2WjWhkm/0aYiZzEmcxHVX8gFj5XBlvbnr5CnNAOI9MCRQs8rPVy+BSk
   a1/7scSA/MqzuvU+08Y0SZcluEYESBjLFsy4Iz+ZcFRFKZFxxm1XmypqE
   rcCLtC/AbhjZ8xeN5Q91f0pFIJ4qeiYsMWt9luTtu4vc5bNEnWu6ra5Ni
   /g0PFGQ0uOJATk9p4y/flGHS3QatNt40B09Q6/NO7jGp0ger7lFaQ3x6+
   iml9YNyQlBLkUsXsxyZGKxPpxsGBleIIflzAwmYhiQYfk49iFnQib1QoJ
   g==;
X-CSE-ConnectionGUID: zmDDaCJ0ThuXqZJvVyF5mw==
X-CSE-MsgGUID: vFstjedoQPqLWmRD9axLsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12509886"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="12509886"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:57:14 -0700
X-CSE-ConnectionGUID: 7lJH3rSsQXqfWB4KIG+IQw==
X-CSE-MsgGUID: OMxkuovRQ4ydNxKKy3Xk5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22340487"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:57:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:57:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:57:09 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:57:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3MRZ4mbTW1dEIm1uS6zRWHtrM+UBQ/dTIPScGXDVQM3sirGpq5JszQ5w+mFRg6AAjfQSjcDRtWisQ1K7zegEYxaD7KVYu+YyT1IWWYVqjCLYYivtgMc/XodozNH/cFzniuuacOyDvgtJkFmsnRoTbS2jMdN7cuiqXiVbkB1SU2ynOTkwjH1npEgz+DT4Ry7vkT0jjfPtN+djAWl4eNbp4wUUsYP0COJrKnTgQXhzjV2zbIvtKly+EIjwwV0hi84uZxzMAKsgGUXg9pMuH1gEmhjLeuSZk3CgmRKdXaCs+LcM82uymfoggp8nG4R+O4PJCEgHo4wjn466iLnAkI1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V43Ub+U2tVZlAioC8dK/9KNk9AthBg4fRku1kwuBbaw=;
 b=n0Szw81VbMQTmzBk3/clm+4mccLf6MOYGGQ/fgP+XLYUhrWHavF7B3tU5xmAs3MSGBV4LddDuUFK7Tx+KnYogecMaiFDZ4LODnlERTK9j6PX4Vxw0mqfVrH9PpzIyLQw6J4GQuGo/Aw8fSG+Tdm3codAy4tH2iNLKe+fnsdFxDN5VZSjaQZ2Se10qOrqefnWvBo93Goyo1hTZW/dMe1fUi8LGQbT6oDiBcW9n8oh4bACKef31mnuQ+KmC/h3W2iGhvNOZmkVpfqJVOubpX6ftyafzGis8ROEC0TtMbod1rvpj1eQzP4DVx+/pExT8CWwjOA6cdMNItmxkwuGqL+ffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.28; Tue, 16 Apr
 2024 14:57:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:57:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 08/10] KVM: x86: Add a hook in
 kvm_arch_vcpu_map_memory()
Thread-Topic: [PATCH v2 08/10] KVM: x86: Add a hook in
 kvm_arch_vcpu_map_memory()
Thread-Index: AQHaj4x/brYwZSkNI0CNKJFAEds1W7Fq/ZiA
Date: Tue, 16 Apr 2024 14:57:05 +0000
Message-ID: <a8451fb59f300b6953e2d4a3cd06281400439212.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <7194bb75ac25fa98875b7891d7929655ab245205.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <7194bb75ac25fa98875b7891d7929655ab245205.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV2PR11MB5998:EE_
x-ms-office365-filtering-correlation-id: 9dc6278b-1eac-4312-5d41-08dc5e257b97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MgEe6A/b70Z7UJ7zjkDoJMNPCB6jZqD6fYyZ5EOfi3nqOMpN44suH+ILOIgzAJjXNvTf8fA9FtEFDEuHSg1XW6fSRRQNaBR/ywKYGetx9DE/0+9gX0hNfIe/c/ZJBtttukC7a3jynyzPL1loRInLpIC2uLnGw6F1wpA4h0SlJMgh/AaV9RRX0BVssm48jkO/S/iCvoNYl0Tt7ZxHzAMkPpV65XKbnwrxlx8y2mrSp81bhCmwx4IB1CYkVWIPYUdGaqB7pUerCJeA97xywSipj1YfPVQ9PqeMXdnMu0RYN80WL1WlCuLHq8f+xSabhj5SEJHEh6N/soclrdiqm7N3D6g65jvaHRVxDFEn/eSIcxT6jfPB/seuMuotZBencnkPkz+ixs/pNPMoCO1JTMvXDit5Gw6o0Gxlkwfc0zqpdmRk8VORHGnjO7liqwcl8aTYemTnOtvM3zXxr7DhmWQRoZiyM4SMrdLjAM+6i+VijNpm/8NCdAbWGVnyQfEyD1xMKQYv8iqovhl0pvyobogMGQa69PT2xq5a3THKrSt6XFJYwoKulDe6dC9G1qjGdjRJ0vrf+5yC44Vgd7FUWw7DZcB/zKOZTWQMQ4lyWFiibp/RRIHxS7Pzsdl6RLQJVd688jyiDSFdgASp9Ct15LZFUL6ODYqAXXe9jxkUZfBceZj01HaV2mw0Xo+zJVO4y0OL74N+HwyNa3Wyj2MeenuSiRoHzszQyeim/rKaYaWJkn8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWRGYzlzVW5UN2N0Z3RYclZDcGZENU8zWDlpY0t2c1A1dm13MGZkZFFJaXdk?=
 =?utf-8?B?d1lsZ2NFUG5YcDZuTkY4djA5RTlZdGZkeFVjUG9WbDduTmNEWDAxWHYrMC9Z?=
 =?utf-8?B?SGVoaFczY0dzS3dWWHZWTVMvRU9JSHJHVEd4Sm4wWHV3ZWdqNzNCT09iV0Mr?=
 =?utf-8?B?Q0tXVG91anFEcktLZUtzSlFvdE83RFJERmpxZzhWQVhaL3JGUWhWa0t4clFB?=
 =?utf-8?B?NmpuUDc3NkVLUDI4ODBweFF2K0QvblV3WkNzdlF0NFlaV2RPYk5keFd5Qmty?=
 =?utf-8?B?cnd0M21wOWlhZVZzNTBoMnNTbTBwU0F6VHlBeklpNzZTZzN4bWRyek5UUjZG?=
 =?utf-8?B?bStUTEh2T2pMNGhwbEcvUW9JY3dNV0dqSEovWHQ5TWhQVk1WN1Z0d3BNSXpp?=
 =?utf-8?B?bGpHVGowdGppY1k1VHZGRnAwZGVyUENTNDJxWlVYNit6T0NNVlU1OVRpTEs1?=
 =?utf-8?B?ZjIvRUd3SDNvbzc1T3hUTk1hSlFKOGhqKzNFRG56NW81aERWd0RRdWVzYUEy?=
 =?utf-8?B?S3Z3TFFzMGZtdUNLYVh2bDI3dVgycVJEcllCRmdFUzNjVzVtVFFSOWIyeXRk?=
 =?utf-8?B?V21TdUhNdTYzbWJzcDJCQ09uQllNRlUyQkE0a2hjMTA0eVBwcEl6VFp6ZWs0?=
 =?utf-8?B?VXk0Mnl5WSszelZkYm9uZDFZV0xjV2pwaEtFY1phVWQzYlVJMm5makovZ204?=
 =?utf-8?B?elQwUXkrUDlSSThNY2dManRrc3RHUW4wWGRHV3RHejBZcDVlYkZNVFNUU2kr?=
 =?utf-8?B?VVZ6Wk9KYmV5WlgvbWVYaElKMUJ2czFwK1BtQ1BBUGFjU29NQkljU25ZKzhp?=
 =?utf-8?B?c3hLb1M2YjNWZVp5WUgzUTVVOXlLbTNrdTlHWHZYT21nQzB4NENGV096bVB0?=
 =?utf-8?B?UmJGRTBCcmpzbDdCdWdKNU8vTmVSQnBiU2p6ZVNCaVpOZVpRSUJrTjB5b1RO?=
 =?utf-8?B?UnF2d2lBeFA0bmNzOXd0U3UrUHhLVmo3eU53U1daWFRBUXFXdjhqbiswY2VE?=
 =?utf-8?B?cVpmVFVoL0pReXVPY2pybUZ3eWxHcHJ1bjQ0b1RkWm45SG9LbVJVSmRSRmhH?=
 =?utf-8?B?YzdmZEl0elpxNGdrb2s3b0NzOXlXWDlnZDlxdlJoUmkyRlBKajJZKzQzNkMr?=
 =?utf-8?B?KzQ4QVQ3OGxjWFUxYU9hN1RxL1hIc2dHZVZkQkJ5Z0hUcGFFT0I1SHRldkho?=
 =?utf-8?B?SDIwYWord1J2K3R5UDlnUTFKTVVUSjJBSm5mOXdmRjBoeWdUM25RVkJpYXRr?=
 =?utf-8?B?bFJ2eW9NL1dzU3B6b3gvcHdXRU52aUU0NmprSE1iakxxRURzMjgrY0ZNOS9s?=
 =?utf-8?B?UVpYbFpBR3RCS29xaVZGTFhUZE0wOUdrSEtTTDRhK3dvU3lQNUpQUXBOMFJP?=
 =?utf-8?B?U3lXc21HNi9wQnF3ei92cklXbUZZemszUE5TaU9ORGE1N3pLRWFpY3dQbzN3?=
 =?utf-8?B?V01IK2RjWm9qeTRxeFg4WVhTK0lYalUxMkN2Qko4Sm9BbVNFU0FtbExRMHVQ?=
 =?utf-8?B?ckJtaXp5dHZDN0QrZmsrUHlMdDNzMFlqWWxKU3hTYVppOWhjdHI3U2JUZFdR?=
 =?utf-8?B?MkIrK2p0cHl5OFkzMUY5bVNEOEFiSjgxeTNIOFYrNjBsYXZHNUxqSFEranlT?=
 =?utf-8?B?YW8xQ011VDlnM2RTSnpkTmJVbE5zZ053d3FuL0g0ZllXeTNzUXl2dnNjb0Rh?=
 =?utf-8?B?SGIveUd6c01hVGpxdnAzUkpqR1FIUUNXZGVlMHpNYytrN2NSS2JRZk1JSVJK?=
 =?utf-8?B?Z2RGN1hzb1h0eU1QK0NVcDc5MHZRN0tFZi9YaUpZV2NlVmtINWlQclJKN0NQ?=
 =?utf-8?B?RU1EWHV1YmtFam5zNDFlRjM2a1lTRzk2WjVGQUZwRlgrZTZ2YnUySzRZVzZt?=
 =?utf-8?B?YVdCZ1ZYakJZbEN6QytaVkpqSWpsUGNiTzIrOHhxMTd2OVNZODFNcUk1dEN2?=
 =?utf-8?B?Y3ROeXJqVkdYWEVLR2UvOTFkRzFSYjJVeWVyeVUzWEFXR2JRQjJsQTRMdTBS?=
 =?utf-8?B?TVVidVZuL1dSMlZQY0RKemx1bDUzYVJ1V1l6alZRdTh5dDBpNlNkOFVENDZJ?=
 =?utf-8?B?ajRJU1M3TjNIMVhwbFgzeDh3TjFSMmtlMElwS2h1NHFJQUdDZ0F6eUxNblVB?=
 =?utf-8?B?M2UwN3hWeXFjdzdXdkhNOVlvYjN5dkFxa25CMlhNc25mOGtSdEpJOFp2MkhS?=
 =?utf-8?Q?CBluZliq3da7J1ITNdNkNYc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E6397A55E03E94C869B06F907975AAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc6278b-1eac-4312-5d41-08dc5e257b97
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:57:05.8631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ynj/ZU1GNXXEV6flxfsvxN9sUerW5IvbEFpkzi9xlXu76h4JrzjnDP95rvemG2LLf+Mh0Shf3axezbbdkBppMRlBvBNbENHnINfB2n0l0Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gK3N0YXRpYyBpbnQga3ZtX3ByZV9tbXVfbWFwX3BhZ2Uoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBrdm1fbWVtb3J5X21hcHBpbmcgKm1hcHBpbmcsCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdTY0ICplcnJvcl9jb2RlKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IHIgPSAwOwo+
ICsKPiArwqDCoMKgwqDCoMKgwqBpZiAodmNwdS0+a3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4
Nl9ERUZBVUxUX1ZNKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIG5vdGhp
bmcgKi8KCk9uIHRoZSBJbnRlbCBzaWRlLCB2dF9wcmVfbW11X21hcF9wYWdlIHdpbGwgaGFuZGxl
IGRvaW5nIG5vdGhpbmcuIElzIHRoZXJlIGEKcmVhc29uIHRoZSBBTUQgc2lkZSBjYW4ndCBkbyB0
aGUgc2FtZSB0aGluZz8KCj4gK8KgwqDCoMKgwqDCoMKgfSBlbHNlIGlmICh2Y3B1LT5rdm0tPmFy
Y2gudm1fdHlwZSA9PSBLVk1fWDg2X1NXX1BST1RFQ1RFRF9WTSkgewo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoa3ZtX21lbV9pc19wcml2YXRlKHZjcHUtPmt2bSwgZ3BhX3Rv
X2dmbihtYXBwaW5nLQo+ID5iYXNlX2FkZHJlc3MpKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCplcnJvcl9jb2RlIHw9IFBGRVJSX1BSSVZBVEVfQUND
RVNTOwoKTm90IHN1Z2dlc3RpbmcgdG8gZG8gYW55dGhpbmcgYWJvdXQgaXQgZm9yIHRoaXMgc2Vy
aWVzLCBidXQgdGhlcmUgc2VlbXMgdG8gYmUgYQpncm93aW5nIGFtb3VudCBvZiBtYW51YWwgS1ZN
X1g4Nl9TV19QUk9URUNURURfVk0gY2hlY2tzLiBJIGd1ZXNzIHRoZSBwcm9ibGVtCndpdGggZ2l2
aW5nIGl0IGl0cyBvd24geDg2X29wcyBpcyBmaWd1cmluZyB3aGljaCBhcmNoIGNhbGxzIHRvIHVz
ZS4gSG1tLgoKPiArwqDCoMKgwqDCoMKgwqB9IGVsc2UgaWYgKGt2bV94ODZfb3BzLnByZV9tbXVf
bWFwX3BhZ2UpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHIgPSBzdGF0aWNfY2Fs
bChrdm1feDg2X3ByZV9tbXVfbWFwX3BhZ2UpKHZjcHUsIG1hcHBpbmcsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyb3JfY29kZSk7
Cj4gK8KgwqDCoMKgwqDCoMKgZWxzZQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ID0gLUVPUE5PVFNVUFA7CgpEbyB3ZSBhY3R1YWxseSBuZWVkIHRoaXMgbGFzdCBjaGVjaz8KCj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiByOwo+ICt9Cgo=

