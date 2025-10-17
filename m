Return-Path: <kvm+bounces-60297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D45ABE836F
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FE686E51A4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B074328633;
	Fri, 17 Oct 2025 10:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXQws1VA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080C5320A34;
	Fri, 17 Oct 2025 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698391; cv=fail; b=PcB3zqKBh1K58T2Qr8krQluE/SzPVzwEVaaY22lQQHygAjQFiDMPnySQKbJshYPu5bNhv1RdTNjQ9cupYXlg1Azs0RfHD3XiF7s1V1vk6YyTMLYYR/cqGvQKB1iTGRrKAQe7dXacof0LvJcmwiTwqAzNzIS7UdfVOr159/NGHMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698391; c=relaxed/simple;
	bh=qf/UncmfjKZ3kPHNRrBkWfjbK44Seko2QhFgPB9Vw6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XN+ZRiMuUP8CyKSxk/LCV+N2qqOjSpRB4Y6rpyQsnBFsXXCzG+Tqt28Sgh4qljUbpHqbKZVUGECgR6V84HjOnv9xzFyILPyZg6rk62sLphdQNVf2YUg2ooDgoo1CuhVQNb9yjDLr39o4M5yX1XmyDAmCKM7WDCYXgULnxq9RMZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXQws1VA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760698390; x=1792234390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qf/UncmfjKZ3kPHNRrBkWfjbK44Seko2QhFgPB9Vw6E=;
  b=kXQws1VADPfVBGhBGdBkQ8g7peX2i3KFCyPR+4IvoiWp/lk/ixBk+Y/4
   t3NPOqjxbxufq41w7LA72Bny2Gh/cSGWIskcQi+yn83L3NRcFPwwRm3HE
   LSjtlbStiYDo0a/YYEx9+llJgCumIp0qpIQlLua+Sz+ZrxhePgSRbQ2p0
   KY+6cxYAcr3qR6Le06JmehXu2cpZNpjyu0dI/z41qTPGEXzMckfEapxQ6
   r1dYAhYoceGYTEZgeDdu9mrDdLL4H6OTr5OZz3Wuj1Mav0Qh4WhTOE16y
   1Pef/vzJAA9ZgtizC4ui6YbKRceYv7XQrjAdB1YETRksEVlEe5YzlifBI
   g==;
X-CSE-ConnectionGUID: WhfKrNIwS06XEkk+8VNHwA==
X-CSE-MsgGUID: EK0+8d7oQL+fUGU9XJpZng==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="73190653"
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="73190653"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 03:53:10 -0700
X-CSE-ConnectionGUID: 05vju5W+TP63+E40huDfPA==
X-CSE-MsgGUID: 2Cuq7CkzTjaKnL3u/035Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="206413636"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 03:53:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 03:53:08 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 03:53:07 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 03:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=biUiTYucbOG6mgbYFhW650zEuPNewCZh47jYt1et+BUsaHxDAw6F5tniQtwg31KO6YbmCkEAvOmqv7tLECsodeVh8WNmpecS7XSPm/QDGFNCL3RtHnY/EZJ7ZQp5MdjhNP3kCTfUZaN0Wt3i4+CD3x2SDzphlihKoOBTZSEHdgRQOfdmwJ7VZTOlvyHksf5D9uSyHSCbRBsclWuFQddvg3zMF/MP4Ek7XAhg68jsR2sW6HIPaUIIpkK3zosfvEqnHRbmx748IvohzP0qzckdCTFVSUXWpcQi42hJ4XiU0WD+zWFD/qoszPgrgGlG7GZMXRhgfZuJgcX/VG07XSNOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qf/UncmfjKZ3kPHNRrBkWfjbK44Seko2QhFgPB9Vw6E=;
 b=c7DHJSCk4DRzhZ0DbAaiQA9+xa8LzjU5oii0aUaseXtNFbSDoGC3E1AGW9mXEHtKEJ/8GBJLif4g3Hz9m4qCIPp2y750ViTma8jihzA0HxxpaOk80IrAPDNigt+l4Rzch+jNM02nw/x4TeuHgxQydPT1eIHY9Px7Vb0FbdzEmSwnT/+zJoAnFYPeKrey5BWFmxq9KFx03MPisHpGLFcEwzLuvChc04rCSHcTMhJp5MCkkTFuP8zTD1ft5ebsf4uxiSTocPmqLk+pW7ab8FbxrhPLpUixvFO3b2aiBjnMxG6piEqV+ZV7KZ4bRwxOyl6dp/idXKRUvaO2zJF7CP1dkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB9469.namprd11.prod.outlook.com (2603:10b6:208:5b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 10:53:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 10:53:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Topic: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Index: AQHcPsnIDCY4Nspo7E6rq2esTUoC+bTGKtiA
Date: Fri, 17 Oct 2025 10:53:05 +0000
Message-ID: <2d00cefad4a5316357e76db7292e8d7ac2793eb1.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
	 <20251016182148.69085-2-seanjc@google.com>
In-Reply-To: <20251016182148.69085-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB9469:EE_
x-ms-office365-filtering-correlation-id: f4fd95c9-2af2-4a5d-ddd9-08de0d6b5a36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cEZaMXV4SDhpMGhDeWtzak5Yc0RKQk9DUDN5Y3lwZVQ1RDE3UUVUaWFYYTQ1?=
 =?utf-8?B?QS9hbXZiT2FSdk80M3JGNENsc1FzdFFwaTJiSHcrNFF4KzVLUmYvQVVYcUF1?=
 =?utf-8?B?eExIUk03QmRld3lGNHVJeS9Qd3UzNk1NK3lGLzJjY0VYZjN1ZnBjTjJPNXJH?=
 =?utf-8?B?VW1GRmlDdlp2d2Y5eVJRa2w2Q3piTkpmcTA3am1Wd2hXdkJXZG94ZGpBdGxO?=
 =?utf-8?B?Z01SN3NDY2h4dGFrSi9aZWx3ODVpZFlzbHdiSFFPNGlXYzREdnFzdXcyRXJj?=
 =?utf-8?B?VjhwMGJCYzBGbDcvYWs0Kzk5elM3M0tBdkdzRXY2OE85Ui9CYlRXc05TU2tJ?=
 =?utf-8?B?SVZ3SXhRb0JET3pSeEhudjc3NVZENnY5V1Bzbk12cUdQNmloM1pQc3pFcW02?=
 =?utf-8?B?YWN0bWRGUC83NHB6OUt5ZGFwa2JnMkd0S0NFbTlIWkpyVUxienpJOFRXR1A5?=
 =?utf-8?B?Y3YxZzUvdFRhRks5K0hGUVdwUzFoSFh5UzMrRlB2THEzUU1TS1hzSGEwZ0tH?=
 =?utf-8?B?ZTF2V3RmMTJtcy9kSkR4aTYxSGV3T2N1UUZrajR0NzNMTlQyOFJHMXc5Ukhw?=
 =?utf-8?B?N1oyUHI0SVhLcGIwcjlzQ25lMUZjMzg5cE1jYmtLRzdYYjVmQ3o4K2s2aHBG?=
 =?utf-8?B?NFlpTC93T0FLVnl4ZmpKa0pHR095Uy9NZlBEbmlzRzROZE8xd2RLaFZOd0h5?=
 =?utf-8?B?YXMwTWpSNzlLdUVFRkxhZHo5dVhoMEpWSkpnNjhMNnNQaFV2U2paZmxBQkVw?=
 =?utf-8?B?dWFOUlM5SzZHSi9mQ0dGK0RiTmpvYmJITkI0bGh0VmdORUtHVThpOTNvcDc2?=
 =?utf-8?B?NTNkd2NzbmhLcE5OL2Q2QU0rejA2SjZPVDBqQ0daWllSQjNKMDhkOEZHWkRm?=
 =?utf-8?B?WmczWDJmSDhNREhzN2NkeVREU1FsMDh6VFZMbUh0MkdPb1R5a0VvYmdhcEZK?=
 =?utf-8?B?UGJ0bGhCSE9YY25DU2xHakxKZWtQbEpTN3JxRzlGbmVuOFBibzU3bXF4RVZG?=
 =?utf-8?B?U2NXQlFXL2UvUXRtQUk2cGU1UGo5alBBWmlobTZsZTBZdzR4WkRjUVp3ZUZ1?=
 =?utf-8?B?MUZWNi9oSkNrbHdzVnZPdW03L2xha090eWx0QWJMeWlZNHVZZEh0anJPM01W?=
 =?utf-8?B?UHRMRkhWVEpmQUdyNEZUR05lVWw4aVZIZ0lqOGRJZzlFUjBjZCtPdi8ySWdj?=
 =?utf-8?B?U1RyV2U1MVJQR0ZjWG5IVTFsYXlMaTdEWnl4QUttYm5meXJXSHlFcUJVOC9z?=
 =?utf-8?B?bmx0di9aeGhOTDhzdzN3Q1ozT0lyTVY5L1dWckNRMGFvOFNBeTFtMC9pTUJC?=
 =?utf-8?B?bnBrcnRWTnhUL01kZHVlNWc4emVpZTQ3b3E4cU1TNXNBd0Yyb3RUZkZvblpC?=
 =?utf-8?B?VE9wdUlhdDQxSVozb0gxUWxMRTZPeTQyZ01jNU5zTGJ6NlVNRWh3bGtWMng0?=
 =?utf-8?B?cS92VVJRYzFDNTVacURrWTVlYlVpcGw1R211cUNvNGxPRUdsU0k1SDk0Vk5F?=
 =?utf-8?B?SlJOVzJvcmNpejNPMXh1TXA0Q2pNc0xOYjdEOXNwKy83dnB6YjNsSzc5WlNn?=
 =?utf-8?B?ZkY1UVNXS3JPMnNNeU1PTjg0SjQ1YUlzUmdJOHR4NE5vQjlLVlBGTTJrajFX?=
 =?utf-8?B?RGdGQk9YUEVFRVBIa25XOUZCSzhlVmlqQVBhbFVycUZPQnk3L0NUZ254akt1?=
 =?utf-8?B?SjJmRndWbERJNDFsdHh5SUdycTIxQi9nU3dVbUVxZTgxMUpnTDQ5WWhGY3dE?=
 =?utf-8?B?Y2xab3RqcElaTnZ5SHdCQlg3b200SCtRbGpUNzlMeE14UXJ4dkdxSmc4QThv?=
 =?utf-8?B?RkIwaHhzZk80aTRydVA0NVJCekM3OFRTV1JHa2xDLzRacUsyNWplVm0zQ294?=
 =?utf-8?B?VkY4eGxFc1hMRllmM1pWV3lTWmdoS1RYRVcvQTh0T3pTSlY5M3R0NUJvSVE3?=
 =?utf-8?B?OFVmdXF0MFVnZm1qa2VoeklSUnZ3M2loL1p3Rzc0NjVEeFRENDZURzZvSFFZ?=
 =?utf-8?B?QkdzMDkwOWpVbHZtSGllaStFODZPei9EbVhaSmVvbGgzZlhVVTFuU2dvSXhi?=
 =?utf-8?Q?Vc8XcZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTU4MVVwUElsUmJpajZ0YjNRRnhmYVRCTlN5dlJma0lTYUtGelJIaWVmWXFh?=
 =?utf-8?B?cVRBenBHdk9oZko5NVhHczFwdS9LWlJxM2ZZb2hEWElTWW1CVFphUkNtNTdX?=
 =?utf-8?B?eXAzV2tJQXMxK2kzZXlHYURPdlhmWTNaeXYvTHkzdXpQaldJalJQNGs3c2J6?=
 =?utf-8?B?YzZWc0pOcU5KcHQvWWJyTlR5UW5YUzBKMkpNQUNFdUxORjUxOEdwbnpiWTZy?=
 =?utf-8?B?elVzSUtyTlFLK2J2L0hoUEZBeVZZSVNuaUZLYjBaaVZEUm45d2FFNy9sK3Z2?=
 =?utf-8?B?Yml3OVBxbEtJdHpYeUNSVTUzYWJ6UVdHMGJQaVJZdWJLRTZKb3c1Sm9sbmVa?=
 =?utf-8?B?V0NCUDBIdDl4S0dxN2phVDBxL1dKZ2VJQ3BhejlPUzFSRVpPRDZ4T25PdUdw?=
 =?utf-8?B?QlVubytrYy9rRzgzY1NJVVcvdnJGRWJHTTlFYm15dUNmRGZSaFBKaVdOVWQy?=
 =?utf-8?B?by9HbWVTZXFBc0YwaUJsQ3pjL1pjYkJ1YjRlV2JVVHduZ2NVS2dhU24rdHJD?=
 =?utf-8?B?UGhqS1FGKzVBem53aUVLMnNYdnBGQjRDbUhORktRTWNWZVNWbUJGODRxWEFq?=
 =?utf-8?B?UGNUdlVGRWM5aERFc2hyazlPOXg0WWNZaFo5TGpKMXczSzN4aXBZRzBMckcy?=
 =?utf-8?B?bkQ1WjBYTk9kNjlLS3A0ZHl5c2IvYWV3Uno5UktCSDdvbFUvVjRrWW8rZzZZ?=
 =?utf-8?B?blhBODBQcTJUeDBkdytHNnRueVZWZVZ2MTUwbVB4bFdlTmd4ei9GMTdsWjkr?=
 =?utf-8?B?NWEwYWo3aTkrMGlyQ2xrcDRZUC9vSHI1OSt5dmQ2QjR4WWN1UlAzVzdoYXcw?=
 =?utf-8?B?ZGN4YnlPckF6UDJVQVdJODVIWGpQSzlSK1ViTkN6MnpMVlBKWTVhTFlDMHlR?=
 =?utf-8?B?Z1haeXYzUXUvbWRYQ0NPY1BsbVJPTmdMR0ZqMU56RlRUTEZ6UXdGZXV0S1o1?=
 =?utf-8?B?dThFUmhSSytZdDRRcmtOK0gwUEM2KzJHUHdKUzhqWTJ6TzkwcFFsT1g3aGRO?=
 =?utf-8?B?Nkd6bmdtMGpaQ0R6Ymt0N1FtZTNGZTFHNWZiaUlvSzJVSG1wc3hmdkt3VnVj?=
 =?utf-8?B?MXA4dFpWY2xYZG1naFo2NW5LY3JGaFR0TGFmQndBaVZIMmNSeHpKdDRtWW5F?=
 =?utf-8?B?VnpRRlROUERxblBHa0c3M3UrVDVxMGVUNXNIZWhMK1l1RVUwUzVCclVRVjY0?=
 =?utf-8?B?Z1Vjb2xrSUxBVnpseDhpZk9JR1RTd2hxbCtGa2JBWWVUQW1uN2lxcUJneUsw?=
 =?utf-8?B?UHZqR1d6VE1zSE1FcFVRbmlxL1FVbzFrYk5vaENYaGNNbytyTG1lOWcvek0w?=
 =?utf-8?B?V2VnL1JLQ2o2V2VEbm5Nd2Y0b0F6UHkzQVczRDh3LzV5OVBTWnRmUjdaSzBq?=
 =?utf-8?B?ZTArbFk3TWx1NkVqN0pIN21aeEkyVjRPR0Vua2FENmdPdnk2cFBSdmp3WWFG?=
 =?utf-8?B?aFp2dXRwanBUdGM2NUl4R25RUGVnd1ppSmJ3QXBpTVVTbUVyVWpReFhkNHZQ?=
 =?utf-8?B?L1BEQXJuODR2TDA3S01zaVhnWlVJQllENGYxRyt4cjl0Z2c5RHpOdHE2RE5x?=
 =?utf-8?B?SUNpZFNNQ2RENUczbk9zUS8ydnNDTW14eFZ5S0Z2TW5MbkhlM01BZ1h1WC9T?=
 =?utf-8?B?dXhlM2x3UlhwcktIQXBTdEJHbFM5cnpxSUprN0x0L1p1R0dOUGt3UkFYOWYr?=
 =?utf-8?B?VC8wNGhPWnVhLzV1R1hNVFJIWWcyWUI2ejZSMzh6SzlZY05US2dvdmIxR2RV?=
 =?utf-8?B?c2IyZEJ6RWRKTzc4aTEwdWZKdjYzcysyOC9ha3RzWFFJaU5BejMwUkRPVmhE?=
 =?utf-8?B?Q0NKOW5hdWQwclpWYUwxWjcvUDFVRTZWMWJEV1h3anBiVUNacCt3NTlpVlln?=
 =?utf-8?B?M3FrWGNuNUhhc05jU1FmRmRxOFV2eHQ5ZUhOMTZDUjJ6YVNreHJPVnVGUmt1?=
 =?utf-8?B?TUw4YWFtbGhSQkptQUIvdXdZMkxGcS9HVFMyeDFQQmxPSXhia2NxQmYvWDFa?=
 =?utf-8?B?WDJMeFlPMncxTlpPZEZRUElUSnFHMTBhV2E2a1R6SWV6ZUVJekhNU0ZlQjNZ?=
 =?utf-8?B?WW1nM01rN3RGRjRrQllDUWtmb3hNU2E2bWgwMEJvMVRoNDMrcXlmaDE4eGhz?=
 =?utf-8?Q?wM0Q6KS0nAlI7QgfPdmhOKGJr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBF0B05011A34B47B0954D533901B99F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fd95c9-2af2-4a5d-ddd9-08de0d6b5a36
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 10:53:05.9324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHrTTwIwk05y65IsvKuUVB3uvdpQQMqPOwTF1/W001mfiyrqyv68yRPT5Xx3EIDQD7YT59nJ3jPAgGDeSd9fYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB9469
X-OriginatorOrg: intel.com

DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMNCj4gKysrIGIvYXJjaC94ODYva3Zt
L3ZteC9uZXN0ZWQuYw0KPiBAQCAtNjcyOCw2ICs2NzI4LDE0IEBAIHN0YXRpYyBib29sIG5lc3Rl
ZF92bXhfbDFfd2FudHNfZXhpdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAJY2FzZSBFWElU
X1JFQVNPTl9OT1RJRlk6DQo+ICAJCS8qIE5vdGlmeSBWTSBleGl0IGlzIG5vdCBleHBvc2VkIHRv
IEwxICovDQo+ICAJCXJldHVybiBmYWxzZTsNCj4gKwljYXNlIEVYSVRfUkVBU09OX1NFQU1DQUxM
Og0KPiArCWNhc2UgRVhJVF9SRUFTT05fVERDQUxMOg0KPiArCQkvKg0KPiArCQkgKiBTRUFNQ0FM
TCBhbmQgVERDQUxMIHVuY29uZGl0aW9uYWxseSBWTS1FeGl0LCBidXQgYXJlbid0DQo+ICsJCSAq
IHZpcnR1YWxpemVkIGJ5IEtWTSBmb3IgTDEgaHlwZXJ2aXNvcnMsIGkuZS4gTDEgc2hvdWxkDQo+
ICsJCSAqIG5ldmVyIHdhbnQgb3IgZXhwZWN0IHN1Y2ggYW4gZXhpdC4NCj4gKwkJICovDQo+ICsJ
CXJldHVybiBmYWxzZTsNCg0KU29ycnkgZm9yIGNvbW1lbnRpbmcgbGF0ZS4NCg0KSSB0aGluayBm
cm9tIGVtdWxhdGluZyBoYXJkd2FyZSBiZWhhdmlvdXIncyBwZXJzcGVjdGl2ZSwgaWYgTDEgZG9l
c24ndA0Kc3VwcG9ydCBURFggKG9idmlvdXNseSB0cnVlKSwgU0VBTUNBTEwvVERDQUxMIGluIEwy
IHNob3VsZCBjYXVzZSBWTUVYSVQgdG8NCkwxLiAgSW4gb3RoZXIgd29yZHMsIEwxIGlzIGV4cGVj
dGluZyBhIFZNRVhJVCBpbiBzdWNoIGNhc2UuICBXaGV0aGVyIEwxDQpjYW4gaGFuZGxlIHN1Y2gg
Vk1FWElUIGlzIGFub3RoZXIgc3RvcnkgLS0gaXQgbWF5IGluamVjdCBhICNVRCB0byBMMiBvcg0K
bWF5IG5vdCAoc2ltaWxhciB0byB0aGUgY3VycmVudCB1cHN0cmVhbSBLVk0pLCBidXQgaXQgaXMg
TDEncw0KcmVzcG9uc2liaWxpdHkuDQoNClNvIEkgdGhpbmsgd2hpbGUgdGhpcyBwYXRjaCBjZXJ0
YWlubHkgaG9ub3JzIHRoZSBjb3JyZWN0IGJlaGF2aW91ciBmb3IgTDIsDQppdCBkb2Vzbid0IGhv
bm9yIGZvciBMMS4gIEJ1dCBJIHRoaW5rIHVsdGltYXRlbHkgTDEgc2hvdWxkIGJlIHRoZSBvbmUg
d2hvDQppcyByZXNwb25zaWJsZSBmb3IgZW11bGF0aW5nIGhhcmR3YXJlIGJlaGF2aW91ciBmb3Ig
TDIuDQoNCkUuZy4sIGFzc3VtaW5nIHdlIGhhdmUgYSBLVk0gc2VsZnRlc3QgaW4gTDEgdG8gdGVz
dCBTRUFNQ0FMTC9URENBTEwgaW4NCm5vcm1hbCBWTVggTDIuICBMMSBzaG91bGQgYmUgYWJsZSB0
byBjYXRjaCBpdCdzIG93biBidWcgd2hlbiBzdWNoIFZNRVhJVA0KaXNuJ3QgaGFuZGxlZCBjb3Jy
ZWN0bHkuICBCdXQgd2l0aCB0aGlzIHBhdGNoLCBMMSB3aWxsIG5ldmVyIGJlIGFibGUgdG8NCmNh
dGNoIHRoaXMgSUlVQy4NCg==

