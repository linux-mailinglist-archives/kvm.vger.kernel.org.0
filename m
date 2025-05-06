Return-Path: <kvm+bounces-45565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EF7AABDC3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 10:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3EC04C0FB0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63930265CDE;
	Tue,  6 May 2025 08:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUPGL/E2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C12609F7;
	Tue,  6 May 2025 08:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746521415; cv=fail; b=EzDQ7OystfXIx/vZfXk/+GDwerQsJ0oStaxffO2Wa3W7+1wtbGqbvN+X57LtvMwC01rWAtZlcVygwxJM/UlskQZUusaSqEANaIMiMMkUKW/6ESavvKrNMe5b65g76vkrzQvsSwFxwtJ6IN/titlzXMrBiahylcbVF/jcSixyypw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746521415; c=relaxed/simple;
	bh=z6WRKBvBZl5RBnTwUlGQYZqQeFpZl3M06xUQuSLjzmc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XiN2+qxunC4Ua4T7uN9r5jSCyCtarXX3UV+RCnZh0SWjiJeF4TnNgirzAobeL4hY8dnfp3Eo3+Zsw1e7Rjjpz7qBuVKq3Dyhz149fps7jmFwPGpP9Uom7c6Pr+B56lH7wIgUniRBkba1vtBnGNKOs5G2P22hojyus8M8FqG2jfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUPGL/E2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746521413; x=1778057413;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=z6WRKBvBZl5RBnTwUlGQYZqQeFpZl3M06xUQuSLjzmc=;
  b=eUPGL/E2y1wqg7UlC4ilkdTHkm7J+G8vQMvBmVwfzlAY9W6Nybf5CQZ/
   0SV5TpY/srnJrz70riYJBfiQqYDujL1gw/Lm8REwDWIw4SkL+yIpUP2A8
   AVCSV9LWfHIIYAzCb7DtjMW6zJYBxWVChBQs3ZCwe9Je5PMgt7cx/DEjF
   VvrgygB+NBWEREEy7dhSnTJbxN4KitWeMFTlwmiX3L4RUAFvaJqJaAyRe
   VRDSNMRKxsXj5y+qjinyQbUczSTh8l43gKNBt61/LqXtz+ebRQV7vg8BM
   Wjw361e2B9D9W1QHmAo1aopQEvBQ6HkeIm1hOUx5i3plBZBhSmyoKckrL
   Q==;
X-CSE-ConnectionGUID: pwgOJWtMQh+jFbcZjW1jzg==
X-CSE-MsgGUID: jSbVTSyNTbSp8onQeWA9Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="48083168"
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="48083168"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 01:50:12 -0700
X-CSE-ConnectionGUID: fv4J9ppiQ9qiGv+DsMa+9g==
X-CSE-MsgGUID: k7pZ1eULReCy/hzxqVY3yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,265,1739865600"; 
   d="scan'208";a="135448548"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 01:50:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 01:50:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 01:50:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 01:50:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJxVfBpNjrT7iBMVrYyulPjBIrhVmEfFLkpPnLoR9hElDRzBrIo0E6dVimlmYw2z5YmmcczA2vvFk9xnUXn/90AqzosbppHQYSEPvnfgK/2M0Xe1cRvuy8ZT4c7xp9azvrYfmu7Ap/m9GEfG1THsh5ksuwW/e5IhSr8oap8PKX211RZFvfTs8+cY1fvKA0KZINL6tJ7FPTI2bjXlbQdpbRRpvg2aw+ztfkGV7SsbtICoJoF0l/4jyTtdUmtFDCiQ4SzLTSkZEMLB1QPBJPdibkGOPJWl36mAAPBYMZuqNTsNdId+hsQeJix2QgfBZm9SB/NHAH8oNuVjnY+FZXlTEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLSZm/ofprzd8woY+GZgxvsCkVOIiIYRM1nRh1oXGAA=;
 b=bLTQBUAOKunRdDXivCZJL9POFCooxRZTU28DJRQB4aGc8VeV9YOGNq8U2oWlb/NuWsCLdios/XiKuuFE3h1PO1OAr0XNNnFCFAKjv1/8LTy/GpSX5wJZXmntTyFNRgSl+arPVrkBDwupE2Cvp/vki3ieavtehwApkJRBupl1f7pHHVZbqiZ47n2NEDNTn3Wn5aPGQYxFjkfWvFLJXGi3GyiOKPmECZEBXe390P96jMRkQ6lK+zORSSo5giEXnfUvuwn6ILzpZesgx9R8JdtjiG9E6xh0NtQMHfWPVn7GkAk4/Ih6sx3U/gDovHZjE9O6BuLNfENF74KUYMlgy23VXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Tue, 6 May
 2025 08:49:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Tue, 6 May 2025
 08:49:51 +0000
Date: Tue, 6 May 2025 16:47:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>, <pbonzini@redhat.com>,
	<chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<seanjc@google.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
	<yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
	<amoorthy@google.com>, <dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<mic@digikod.net>, <vbabka@suse.cz>, <vannapurve@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
Message-ID: <aBnMp26iWWhUrsVf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-9-tabba@google.com>
 <diqzecx6prxa.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzecx6prxa.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: KL1PR01CA0095.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: d06ec502-3049-436e-1e36-08dd8c7af6a7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bDbcouo2Rq6rJhiPMBMQ75TlZ/cm3f+eJU/vqgldty576GFbK1Y4vFOhdNdN?=
 =?us-ascii?Q?/RT8VD7nSm8pCMM5s4Rs7S5+h6smAC3baT1cHlfDcKCkjltPL6DMGw8iDc1P?=
 =?us-ascii?Q?t/8C08zkdUBnnS0H4ctvf77grXUwVyKNzWyNzc5B/abcX/faVDgB07i5gABd?=
 =?us-ascii?Q?M1DQk5kvBbEB9QQUscna3WXQk48LOkKB8aNFEw7T3CWSLfSQ6kOXWDUznhB5?=
 =?us-ascii?Q?iFcXShWt5yJv7Bk2oCL/kktm4ZVhTZsymp0etv9FquCQB+fj9lCcKKVY1i9Y?=
 =?us-ascii?Q?5Knfsag4xQcV2oTPPjlqu6LbFWrTKx6Cxl95kBPkM1D4WDvc1UrRa2l9CUWv?=
 =?us-ascii?Q?EvFLiHVrbt3+iQZjPrENMIO6+1NldC4R0o/C08wnl/zVYigp0BR3IrTYIQzb?=
 =?us-ascii?Q?77IkTzuLBhMQCVx6mdqfnaERxxngcUZbLGjm+YtCyXgSNHZs9XpF1r+QiTle?=
 =?us-ascii?Q?Tl69s0+mScSCV0JUnobuOrvCCV6Vquvg1srtvwFN53e8a09R7yPyy9Xsy+xp?=
 =?us-ascii?Q?D77/IPGi52+WBCh+mNMFG4waewOICOtCRklkeJ/zgo5jMHgOcUvycV+TI+wr?=
 =?us-ascii?Q?k/dLRj+HujbnWO+AFycszZYZf+4YJMuTfwShglTFN4FmYMOTI9FakaBEEAye?=
 =?us-ascii?Q?gt2cb9YF3BNEJBOOEvVUF4UEAwdtJrumlaStITVaSacmu1x9MAfrbk5bFcyC?=
 =?us-ascii?Q?APsno5f/wV2mcRvPI8ThoOjgz2DO1A7cBP+LLcRqvgt2PllhllZ5u2FfXZCE?=
 =?us-ascii?Q?L5xLAfmVEpEvJZ9XAllKmln4cMhidMc75/IfK3vg0a4ZO2Bn/ofszuqToshY?=
 =?us-ascii?Q?0l9VIJkJ0wSlAPaiskFR2AXTBy6c4E3NFrF+DZC7r//dFfFhNh9Hiam0bzyS?=
 =?us-ascii?Q?K10LW31r2Caufbtw6E4alrtfoV7ykSY02G4WrJnV6Zp9cd6fXiKSKO4N6L1H?=
 =?us-ascii?Q?JbXhj4S4ujmx2I1x+DwQL1Osl5v6RlP8f/+yia76vC8KbpFiYSvuQoqZig2/?=
 =?us-ascii?Q?bsnNWAlpmkkd0aLFLdrhvV9tsi0lOqFvRxfBiuB829K58cWq4ZhJGbu0Mqo7?=
 =?us-ascii?Q?QFJB3ylSUTa6Eon5ycjXOVZ+EDSZqBGmF30CVrQgbdgWNlnODB5/PXT/2cUV?=
 =?us-ascii?Q?IRMdpa7Exukw9mWlbCl22NSK0lAShLXVd6FrN5WDX6CvC0dMYA4346/zlA8+?=
 =?us-ascii?Q?NodLeXU4tGd0Wfup6K/y4oEJO/tH7cGV8jOiHuFLS6/aGZQQ1GdFHsvf4I1u?=
 =?us-ascii?Q?SMShiPu7VD80N7MZQSCndhUR/FKUw1liLKvzwXbkq8HXvb62B3IvoBiiyVVu?=
 =?us-ascii?Q?JwbqktXtCFS9bB9vHAiYw4czLV+TXeXt5Ms8rKT69MulmiNr/rwQNaLgk2Pv?=
 =?us-ascii?Q?KeH2H0DqpVgjOhFyMLIvRVHZbqgy44pJSCvio4mk6/BxcdsHfAsUD1tR9YGm?=
 =?us-ascii?Q?xBr8WqkTzwM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwepDWvh2QHHl1ylgl9OGblVyGKvoZjNgGjFB7gaaw18+y5t7uqIiHF6nLUB?=
 =?us-ascii?Q?kj1y4Gq5AgjnlhSWtZCsMI/e/68eEvEK+SRPQa6ps2UwUVsZbAvfVuCJSRGf?=
 =?us-ascii?Q?GakkEv4zvoPHH5g3RMSxMbFgKZw3tT0WHfeXnyUZvLoMCf86mKIU1Kzhuoh7?=
 =?us-ascii?Q?BMPPuMblthH8USHTNMo5Hh/S208NHCLapVEVXzqYvRpsjwGUM3D4+VJINpru?=
 =?us-ascii?Q?T2SUDBlTYBPrLACChNuNdrIyuB/WsBhVx5+FEY6dp11cQISbnvXpUt/Ss9Pa?=
 =?us-ascii?Q?F7LCpUdhfxPHFR20ANVzrT2FD1EwVZOzezzGh59fb18Nb6hzD7dDiVjDYcgy?=
 =?us-ascii?Q?eaH9M4JLEoYxUK+iIF98Ss8pjKcBQN5FgUJSL/i99RUWOGNiL8anU3r/QTYG?=
 =?us-ascii?Q?dfKayT8DsxXqIw0Zr6ufBEE1n7Schw7r4Byd/CM/xEEchIBVHA9hs8IKkOwV?=
 =?us-ascii?Q?DkKXJB8QoD849O/AvLTUulv9eNurhpylOTWVmCmKU3395efFFKkiYdvGsXXt?=
 =?us-ascii?Q?wZAcBDrSjGe2d1v+OTlICZbaSrSiNJjJwVyWkfVrfiXYPDdlEUMtB4ipPCaP?=
 =?us-ascii?Q?YgHF4GkCwQi2IisQmeFc+wmGIySbn23wyK3M5b1Y1LuzoQGWMDVKXMCeMt/D?=
 =?us-ascii?Q?AWJklGtIVSiRxtWgDHPRzSP8vQlV6LRxAet2+USBkPpscLdmhPvs9dxYk4FD?=
 =?us-ascii?Q?399c/TZ8GwMCdOqTYbFQDJdjRzg6+mcPNu1QXXosqfChHvU0pq3wKwORbLIo?=
 =?us-ascii?Q?e+9vZrRpSDGAx+vHuPvSw5c5WFQlApVwe8XCNIQjIh6lliMlk/IKSUR4yuKI?=
 =?us-ascii?Q?f4zQ5+TWvtd4mYUzc39J7Yf0AqZ9U0YAdT2sXfwR+u3By3oHZAZd5PgTRtbL?=
 =?us-ascii?Q?K52JJt0UTbdzCBITkkzEpUX3Di4i5JuugL0NUPUHJ/FEwpwJ9VN+oVUbK7Ss?=
 =?us-ascii?Q?SpdxgUBd7zX0pV73bJNmWAgENzDEdOmC0EPS45sg8NfhT18VCYTQ4vg9kKR2?=
 =?us-ascii?Q?O5kUAB3rqtBymuMFk4UvX5x2j28qGWDya/zBqemh5YbNNrmScDKADAyBv/di?=
 =?us-ascii?Q?lRtiiggfPCmphBSKgWcSsXbnjq9h1GdnDbArTNiC2JmdHfIq6eUtKceWNLNQ?=
 =?us-ascii?Q?Poaqpbq0LylOa1cvWlJ2RKDC1MSougnp5zU4aYtXtHc6DYZj9EbhiuDqOYmo?=
 =?us-ascii?Q?qHWDAWVTsKQ77Zp11x1qFnAZU5faGXT1YxOSNG0xgi1nVd0wuGeoFV0LAkE3?=
 =?us-ascii?Q?0H4/xUXef/gJzxsxW+3O0Uzi0mgjImsa7k5Ynf8U8EY5CN2osxgA5yIIRB2U?=
 =?us-ascii?Q?XwstY/WcPG79YJgiVJ4mrCyoq9oehvy7383IRblcYYIfXOAIkE7U8iCv2lp2?=
 =?us-ascii?Q?ZGsgMNgd3PpKTgnGatz1dntSPEmxbyvVbOOVxlU+9KskozpNBH6RqfaekpYg?=
 =?us-ascii?Q?sj+IU/v/4pGMjWTbLZFbKAMYA3XRfTr361eel6dRZvj84iLf1G9jobq5yjt/?=
 =?us-ascii?Q?/YdJLgI18JOC1Co1vwz1p7moKBsYAie5fcIraYgZho/iDbAV27cjDmeac1gg?=
 =?us-ascii?Q?wIZh7MfvidmPZE+9IMYSxndZQFuu3sJFIf+veZj4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d06ec502-3049-436e-1e36-08dd8c7af6a7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 08:49:51.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnHVR5ZIpL5Bfjcq7FeKLKuKgMbbp20gvwaIlk1lNDspy9FNL2pe5c61WV1BbJARYFevPyHmteZlO3hzZdW19Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com

On Fri, May 02, 2025 at 03:29:53PM -0700, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private. To that end, this patch adds the ability to
> > check whether the VM type supports in-place conversion, and only
> > allows mapping its memory if that's the case.
> >
> > This patch introduces the configuration option KVM_GMEM_SHARED_MEM,
> > which enables support for in-place shared memory.
> >
> > It also introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > indicates that the host can create VMs that support shared memory.
> > Supporting shared memory implies that memory can be mapped when shared
> > with the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h | 15 ++++++-
> >  include/uapi/linux/kvm.h |  1 +
> >  virt/kvm/Kconfig         |  5 +++
> >  virt/kvm/guest_memfd.c   | 92 ++++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      |  4 ++
> >  5 files changed, 116 insertions(+), 1 deletion(-)
> >
> > <snip>
> 
> At the guest_memfd call on 2025-05-01, we discussed that if guest_memfd
> is created with GUEST_MEMFD_FLAG_SUPPORT_SHARED set, then if
> slot->userspace_addr != 0, we would validate that the folio
> slot->userspace_addr points to matches up with the folio guest_memfd
> would return for the same offset.
Where will the validation be executed? In kvm_gmem_bind()?

> 
> I can think of one way to do this validation, which is to call KVM's
> hva_to_pfn() function and then call kvm_gmem_get_folio() on the fd and
> offset, and then check that the PFNs are equal.
> 
> However, that would cause the page to be allocated. Any ideas on how we
> could do this validation without allocating the page?
If the check is in kvm_gmem_bind() and if there's no worry about munmap() and
re-mmap() of the shared memory pointed by slot->userspace_addr, maybe below?

mm = kvm->mm; 
mmap_read_lock(mm);
vma = vma_lookup(mm, vaddr);
pgoff = ((slot->userspace_addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
mmap_read_unlock(mm);

Then check if pgoff equals to slot->gmem.guest_memfd_offset.


