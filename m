Return-Path: <kvm+bounces-43057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D561A83A82
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2B144A42A6
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE97204C23;
	Thu, 10 Apr 2025 07:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wu5ssVIu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C21D5CFE;
	Thu, 10 Apr 2025 07:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269230; cv=fail; b=gv69y7NqxMLRteSRsjnWy8QErdGrlyzrVUx7MTLvpY6LCUgYNCicOtdJYoaqHm756UTaQn1wZD1AOYsNCQm29G+RIxKBaw3BDT33zynobF2+cxwNLmPWTyfoJCOlws6Yy8cwtXO2qA4cqfZtfSRwwTTqGzj+vVmAUwP2dpxIg64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269230; c=relaxed/simple;
	bh=co2E8zYHHjNwByNhyq//towaEYGlAGanVE+M71nN/0E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X+4m/VHh8KfJi73/nj4e0jCEmuA0liV4YiGVFLoxwM8JQmuO61LoUP9F20jtGvlZil+STmMj2vU6gW/SJugV/B/x1oElKHMQUUh1xMorps4yjOf/aSETJOAtOUDJvXuGCKd/5mu+U1ly/yx8UpR5u9AZWfW5/m/1LGhFd8T3mc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wu5ssVIu; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269229; x=1775805229;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=co2E8zYHHjNwByNhyq//towaEYGlAGanVE+M71nN/0E=;
  b=Wu5ssVIug0L5tb8jmRF9UnrltkASG/V58LnPmRDrIN6EfdlFpFPypRzu
   ThuiqIf7GHA/NoE1tzFbWRCpAzMDu8nExbex2bkKtWkofKb/RLY4zmioA
   IkbXelTtYBra67YVajafJ9hb4qqcBuVs2qx2OecBalzG1WigyqoQJbNNl
   Ltj83JUJwlK5jZAjaNVtEt5tv1UXzTkILTIQDERIpIaIhOAvolw0WP6MF
   Q6FChCbP3rtvDo/0fCbWdlI1oTLegSZEcJClOTGkovb1WSxiSu3BjVS6l
   nLk9KcDpNLg3uV0kVMwSMyJ6g80opP0wwDsyHcdyXAeIL8wweRoqkogpU
   g==;
X-CSE-ConnectionGUID: QL3EPtHzT0+EM5CVdRD/0w==
X-CSE-MsgGUID: a2ur2J3bS+WvUcDvGMwXjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="71149258"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="71149258"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:13:47 -0700
X-CSE-ConnectionGUID: x5z3hHumQbC0jnqeBcpboA==
X-CSE-MsgGUID: sQW9702WQbSbBc/WER/CDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128776393"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:13:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:13:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:13:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPliU9xA0uOkYTFhFO1xHCwsPraWzDlY7YEpE4+gGB1AxEXRXZUyVMYkHMkP/ziz5rHkLbL0SjOvxB/UvGfuua44QMFQuw4JWropUpEt/jpHoY2tt+avER8QVHwUED8c4KatseXjvejORn2WvIIxprmjjzhjj3PzrkkRUnvHtIXJ56QOp4U1EyH714PeDmvQRBSXv7aOQePWrHP9kxDrgOCyqiIvC65Y397haozkl432R7KS8EOl6u6lOflMRVYY669yDj3mxyUZVgJ9jilT+nfw1AySN0QHh2BlTEfh8XG0fKur0hD8zKDR51Q6nnLggE52QBBXH1m7gMxQJ4qLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=co2E8zYHHjNwByNhyq//towaEYGlAGanVE+M71nN/0E=;
 b=KAABxQLlQRV6hOZpv3VoxOhUBUelO5ir6Itrpo/e6CsbMYIws7y5uO95YTVGHAbDSy203zhpSwZScbOvv5aATWE9LQpKhqsmcPDk4qyOxhbof532MW09wzQtVCU8eh2tJsGRFfJ3sBGv6VNp5FQ6wsYi0tNy3aJ0GmiHtawpr/Zx7H7Pl2eh2j6tBRwLv3kXy2QdO3Jjo/u4Wviu7dnjvA5iqXG4Ktbv6STvdGrNc4X1A8TZraMltIex+xuBOWmcXkn8ayHqcavfBmwdUJ27EYcsUWAV3bFVNXqhpZfJXo0Faq9hEgjcg4cCipnwtSff1VOof+cV8BqpA9dTeXW3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8159.namprd11.prod.outlook.com (2603:10b6:8:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 07:13:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:13:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 2/7] irqbypass: Drop superfluous might_sleep() annotations
Thread-Topic: [PATCH 2/7] irqbypass: Drop superfluous might_sleep()
 annotations
Thread-Index: AQHbpabC8ZnPPB7mV0SqV4GPD8ORBLOchJKQ
Date: Thu, 10 Apr 2025 07:13:01 +0000
Message-ID: <BN9PR11MB5276D82C372026D8E2626E118CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-3-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8159:EE_
x-ms-office365-filtering-correlation-id: 8482b968-cc1a-4a07-7aad-08dd77ff2162
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RkM2d3NoSGpSeGd1Y2NxSUF6akZNaWVLQllodWUxeE8vckpzRlF5ZHVSSFpl?=
 =?utf-8?B?YmNRNm8yRmlpNlJpakVWQU9SUWZYNHBXcWk3U1l0ekJiMFM1TGxzN2VMeGpi?=
 =?utf-8?B?bVA3YnRCNEtrNGxLbXdmYlI4RnU4RXc3eXMycFpqLzRCbU1tTW1keWt6NnRF?=
 =?utf-8?B?T3pTY3ROS2ZyVklES2hTQjRGeE5NalU5SG55TFdXNWFUMTBYOCthbjFHc0ll?=
 =?utf-8?B?S2hsS3VGZlo0ZFZyYzZVWHRuRXBVQVRaTDB6Q2VSZFRqZitqUDVmL3VWRnE0?=
 =?utf-8?B?bmljS0VESHVHUnRmeVdyUTRLWFZ0SS8vdCtnS3EraGVCTjBHU29Fa3NnYm9B?=
 =?utf-8?B?RkRBY1JGdTFoMmhNR1Y3U3Z2bE9SRC9kY25ObXBCUVVtWVhIMGZ6aDJYQW1G?=
 =?utf-8?B?T1MwVytWUFk2YjF0cGhJM0MrL0FwOU96WEp3MFdxME1BWHByd1JOL0JPRTJj?=
 =?utf-8?B?cHozVlFiSUdoSDNhYm02QVdqRHRoZTFUNHhIem8rV1lCSWRha3ZJZlZLU2gz?=
 =?utf-8?B?TjJQckcyNVdsOEdrZVh2TDc3a1Y5ZlJMMGVSQno3V3B2MTF5Z1JvU3Y4elBN?=
 =?utf-8?B?MmVFRXVxczQ5SE5JU1VyVG1CSW03ZS9kcVpVMFpRUE9kTlVDRWc1NmJMMjdw?=
 =?utf-8?B?YmltNXBCc1VuUlRraVZpSnhzQSt3NENEdHMxWFpWa3F6NENWNnVVQlB3cUty?=
 =?utf-8?B?K1dVVmYxdkw4SmM4Q3BXUXFmbjljZnZjcXZyR1J6aEtWT21ScHBEL2NoUlow?=
 =?utf-8?B?d0RyMGNWcUpRc0hrMWc2RzZNVHkvZzl5SU85a2dBdVU3WnhNNjczN1VnUjhx?=
 =?utf-8?B?Q2Vlc3FBR2VjY2hSNEJldFA1c3drczc3M3E0cG9FTml6TXBaaE8zT1VkcXdJ?=
 =?utf-8?B?MG1BVU5DYWlDc2RUMWVwRmZPT2hPYi85ekRGcUJOUWZ4Z2dQN3F0aXFCOFhB?=
 =?utf-8?B?NkJnczlyalZvQ3YwWUdOdFRKY2xQRlBXZEIzZnV2SmtRMzd4T0pxOUZXSWkx?=
 =?utf-8?B?TndQS28wQlRHS1BRbHJYRnlMWW9ERXl1QkR6K3FDV2d1aEV1S2J1NkhGY1Bx?=
 =?utf-8?B?TURyR0NPcVIzZWhnbG16T1JrM0ZiZE5jdGMwQWNjaEdrbkFJclNpcnhWZ3ZO?=
 =?utf-8?B?cFlZN2NBeDlhYnc2K0k3RkdCZTMvOXJibWJZNWlPVFpLWnllcFQ4UkNPczNT?=
 =?utf-8?B?bzU2S1VhVCt4U2NLbVNVTndQL1Q2Y0RmWGNjZnlnNFJiZWNFN2FqWWhnbXhM?=
 =?utf-8?B?UGltZ1piOGJZOTljU3ZGKzFDZ1ozZGRoeFMvWWx0ZktTRHd3WGdyVUdhUG5O?=
 =?utf-8?B?SFhNYU9HVUdITmRxYzVhUEdEVmlTMHA3Ky8wV2grdnQ5bDVVOE9mSGRocE50?=
 =?utf-8?B?NzMwNFpTa2dYMTVFY0ozZUY1aDRuZDAzSjVkV0lpZllJZTVrd05iYVBWa3VS?=
 =?utf-8?B?NUJ0blN3WDN5M1dOd2RFK0dDYjIwRzdOUnpHOG9NMFl2V2QvbkpzTy9wdHVT?=
 =?utf-8?B?NTBOMzZWbWRza0Q3a2JtM1UzeUxHWVlOMS9vbUFWbGduRGVCazliZys0N0FB?=
 =?utf-8?B?NVIwK1RWNHN1WjFhQ0lXVDI3MGdJTFNrUERVQnJteXFyc2p5NnVwMGFIcXBx?=
 =?utf-8?B?dUhPZW42dFFqamp5YVBuQlRObWtpNEZsOVJzclp6aGZsSGtZQlZLVGtVeXpE?=
 =?utf-8?B?eXdXeVI5c09GNGRQNmx4cU42ekt5aE9sQUgrM3lrMVdubFRIYkZYWWhKanpp?=
 =?utf-8?B?by9IdElNWkV0ZmNmRzc0Sk1WbHlKR00rbkNwTm0rN2k4ekdKSlhMMzRMNHJN?=
 =?utf-8?B?TUduWmh6UmtJeUxWVGZDYUczVExoai9KQWhHTWtBcEN0SGNtZFZBUjk0ZXNu?=
 =?utf-8?B?VVNFRVlMeTYzTDZXQWxMVzlxUGtJN1h0TFBzeWdZRWlkUCsxd21XSXhXVitT?=
 =?utf-8?Q?KehKzZhnDc30gYRrax1e/D9UXSgOpb3B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDVIeHgvQmxrZ0RuR000N213cHRDb2xPelNRYk5RTlQ4RHFDSUNNalUxUlVC?=
 =?utf-8?B?b0pFSmNFSXI4a3BrZTc4aUYyMkczVlRKSHlZeFNXZFhnTy9zUnFtZ3VaRFQy?=
 =?utf-8?B?eG1rRHQ1akNYSDRBUjJjWVFqanl4Q1dvNjBoN3JUTG1TY3c4anhwbXRYNEJy?=
 =?utf-8?B?TEFvcUtnSVhEUzNQa0JFZWxOR1hoZ3l0SXorOTJydkRPZGJTT2Z4WHlkdmhZ?=
 =?utf-8?B?WXozM3N3ZlVoeWVxTFUyZmNqc0o5Mld3QlFOOUxlZ2M4bVYyM05Sa28yMHRI?=
 =?utf-8?B?WWQ4R1prZ0VGN1I2L01rSGRXQk1MZExnTVRiZmx2TzkrTTEvbEN6ZUR1WDFq?=
 =?utf-8?B?U2lYYVFGQjVhUmN2Mll2MXBReFNQRWZtUTlMNmJFa1kxc3RteTN4VUJ4K3RC?=
 =?utf-8?B?U2g0QkNMaHVrZE11WXNzOXpLZjVYWmFqOVNsSFduT0pHcWNTRXljNkQ1Skwv?=
 =?utf-8?B?bVNqY05aZG1Cc1pZY0RrWmMzOFhXaW1NMHFXYy9vWVV5dFBabmdRTWxUbCt5?=
 =?utf-8?B?S3pZaUNvT2FmcXpwdTU4R0FXWHdBajlMZmo2WWhBQm5aTGorWkdGTE9vSDV1?=
 =?utf-8?B?NXpaa2ozWjQvNG1PRVpSSldyRHMrSHpNcFloRGJNbXRnRWdUQUFvOUxXWUtI?=
 =?utf-8?B?N1NrSEJ4bktScU5menFrRFZyRllvTW9zeTBQYkMxUGxQZWdGVmd0UjBKT0Va?=
 =?utf-8?B?Y2M1RzJqV0pzQmVTTTk2NUlncTFLb21Dc1FVZjEzKzZ4S1p5cFVOOUhYdDNZ?=
 =?utf-8?B?VlNFc0V3RkVCQWNQOHNPYlBFV3E4SnkrRDh5enRSbWp0TGtkWUlLZ043Sy93?=
 =?utf-8?B?YTZ4Wld2cGQ4bG1DQTZhL3ZJS0luQ3l2MDhCdFZtMjdHL1hTVGRxRjVjVTFu?=
 =?utf-8?B?UXpBVERyUjI1bzRsaXRsVFZudlV3eVBVejBMN3RFQnZHMGh1R0M1cklaWXh6?=
 =?utf-8?B?RlQvWVZLcHNraXVRNUFOTldVUjZ5VTRzekdGcDZ0a1o3dWV6WGhxZzk0KzE4?=
 =?utf-8?B?NHR3cTB5VnJ4Y2pBYmtaRHZlaFlZY0tJMzNEWCtRTThqbDBmeEROWm4ybUZK?=
 =?utf-8?B?KzJLdk5QWnBZVWYxZ3BDMjB5QVRORk0xNGFWNUpveDFWSWpUbkpRc1ArcTF6?=
 =?utf-8?B?QjVlTWVpbEM4em56a0I1NTU1WVZtck9Wem50QnJsK1NWb09PL3NlNlFCZkgz?=
 =?utf-8?B?UlVxYys1S2V1WTZOVkJQcjRFVHFhOW43amRSTUxxbjB4Q1RRVW93Vi8wdEww?=
 =?utf-8?B?WkdIVmNwUURLdC9WcSs2WUJpRm5lTWdYUGZPQnRlaDkxS0VOS2JHV2g0cVVs?=
 =?utf-8?B?ODZRaVhwMDBycnhLc1hJYUFsbmlodFh0VWVwczAwTm1OWHlSSk5WZkswR2ZZ?=
 =?utf-8?B?U3hjaUdiRlVZTUNMbEp1ZnkwdGNSYmUvZWx6dVE2QjFtOHp6SWRmell2dUFz?=
 =?utf-8?B?U3BuZTVCOVg5ME1KL1lTbnc2c2FGRTd1R2JUQmxSY2EzbkZodkx5bDhxRXFp?=
 =?utf-8?B?c01wN08rN21XSUJiaTBMcGtxbVV0ZXFzWXVBb0JRSGxNMmlod2haelhFUk1q?=
 =?utf-8?B?KzRCOFExVjI0SFBmb2pxbnpFRFRERjgrSjlmNDZIYko4Tk1xU25nVEQva25D?=
 =?utf-8?B?ODBNY1Q1dDR4MVJmNEtuOGd4emxrWThoTVVHUU1JRXV4bFZFK2xkdVRIcUVT?=
 =?utf-8?B?YU1ZdFNiVDhzWUJyUkl4eUlUT1lxZHdCdUU3MnhxS3dYRkNPVkp4VFpCTDhD?=
 =?utf-8?B?bnBneVhMdW1IM3Vsc0hLNDlYZnI2anMvR1VkVGxHWnBscDVxdXpYZGRWNzc5?=
 =?utf-8?B?RTlMQjlEOE1ka3VhL1U1R09aN0JYMFZsY3U0b095NWJpTktlcndXdGhsSUxO?=
 =?utf-8?B?U2tBQ1Q1czl1NzczbTJVQnNrTVJqeDgrUGVwakhwMTFsVnNFTlZQdDV5OWVC?=
 =?utf-8?B?a0tFWFpvcEtSYnk0TDdsZFQrM0szYm9tY0sxeHhpeHVERUh3VzdGdUVjYjhu?=
 =?utf-8?B?OXdRMXFJZHpFd3M2UGxKZEVoaDJCOXFYVWtCR3BDZVFVNFpVaDZZelpHckNR?=
 =?utf-8?B?dk1RajdPbUJ1SWdsU2txUGx0c3F1QUZPQVlDaFdLQnByQjltK1FROG5nd1lp?=
 =?utf-8?Q?SDgst4hrdcJ1QvAy1jCXIvio6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8482b968-cc1a-4a07-7aad-08dd77ff2162
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:13:01.6851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VU7oRsB4Sswsveifa1QpClFIUCtHZBEDr6e6nq7mKa6cpa4O7ApfaGUv4QJhZXc5LgT/VjA3Ne2VfHSDXDMFrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8159
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gRHJvcCBzdXBlcmZsdW91cyBt
aWdodF9zbGVlcCgpIGFubm90YXRpb25zIGZyb20gaXJxYnlwYXNzLCBtdXRleF9sb2NrKCkNCj4g
cHJvdmlkZXMgYWxsIG9mIHRoZSBuZWNlc3NhcnkgdHJhY2tpbmcuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQt
Ynk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0K

