Return-Path: <kvm+bounces-52558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 396B0B06B5F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 04:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57EA67AD004
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126AB272E68;
	Wed, 16 Jul 2025 02:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxgayMBc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FAF1581EE;
	Wed, 16 Jul 2025 02:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752631241; cv=fail; b=OLaeOpEY//MOkZ8vtluT8849PxJhi1zTp6pY+WUm00XzROBHF/MyZS5s7zxewVY4rirobqb/Y8LRdHHOBHoMHDbZNv5hIGXUc48md12OrTGEew/p1S/KjJT2Ojhy4KLzwEk45/EKn/JT3uhrn2mm5x79p554oiCis3itVtQyEPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752631241; c=relaxed/simple;
	bh=9XosIn60uMSRivvUo/fsPDILWusK5beDcAmFzdqnorI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MOvSmspesDEOGHOa1aI/K8TBBbVBurqW1FPN3sOG6AI+7ij/eiSzr6VYzNNBiKAmWYjxzVwmZhzTvcLmBxMD4P+2woc1ggiDsES5rlt59jqSI+K1Zk+diVlFisO2BFXVS38SvIZzsK0TMZcxns4ZM/tyuRN5yV9/m+RmvOmUDJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxgayMBc; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752631239; x=1784167239;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9XosIn60uMSRivvUo/fsPDILWusK5beDcAmFzdqnorI=;
  b=YxgayMBcmPVO0y3aR6KofJhYjuePqi++4IVXYNvCoPmaWHx3tFKmBhUd
   pm43kKxYuQPc57CBvEveLdj1wbRyCClE1/K/4ANgN5NRc7pdn5+fIrQ8I
   2DJoWiouU9aDwGs2mkKhDvWjzHnQIKdZy4WWV/gMkX4SlCYATmYOH6GEP
   pYAL4/+ybl/2YxbOhxfk1+DITdv8STzfxqygmWf4VxkIb8zNcTXIpjbvq
   T0W6h9Psjvp57kn3uQ2fs2HTJpsUZZZ1/zannDOW/XCk5Bf48HsaJx6Ga
   nEnDGAV6qBWjzVT32xd2d4aTiAZ7ZQKyhw4dXNs4UIKfKsvyIHjpu89bH
   A==;
X-CSE-ConnectionGUID: kKq6BP+VRJ+i5NaJlyN5wg==
X-CSE-MsgGUID: 4+Xdf+cZSI6cNUBUTqFH9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72439720"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="72439720"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 19:00:38 -0700
X-CSE-ConnectionGUID: Ooy1KPi2SZS8FCtbT7I7yg==
X-CSE-MsgGUID: 18yGwJ3tTOGvCT2nhMCWlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157877940"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 19:00:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 19:00:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 19:00:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.79)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 15 Jul 2025 19:00:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XR4Gw0zrQbEFZ7hrcrfNubBDsb7rCF/T0tEEzvYIRml3pgph/VeO9jtx2g/9ERmouyP3R6YI1TZvwOzXmowiS1HWRAiernpSM7RQpUusrS/3LRMrL4MdqHZC+IWt3QVssiU9yj3b5Sc63gbOpSeRV6BlZo+iJLVDipwWO+/1CSoo/sw/EXRlwgtkKu8j0WySyFgISUOrb3zAmFAIQGB/3vbKljD2foIAaFZH4rMH0xTLZpiApbau0+RIDd8dy5VhGJomSsvn5V8Evk5rIoGT2UmrDfg6QXYvaGwWY/hXoEC1XP8DNQwEEmmJbiGxVNsjYtz0UrlNFB8WnhMLuawpdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oy146nYHt0TrAxxO0uFQB+nohu0W0M/0/4KItjSgUe4=;
 b=bSgvN1qp9NdknebHSItARZxCMkEDSM46ZU/CmpWwfi10F1QFCljynlLVwurgXlOIyiD0rQ/VUJfWmbJVWYSQPU1nl25yPxZ9/FSlOMa2EQ6TuESCzAj/VroMmgJ3jHEe+tPPfev259b4vHZkvfNprG20XcTQGtXy6/by42KqY6yrKSEulAq1lzr/hCqDY9c0gdihHW6nlyz4ZVotZfeukHfBHbbQ1wXos9RW2oUBHinHB1xUCUkqeq/C/VPaVJZgux0heb/wxDzPENWiy8KrJGUe5yE6b6rUSas2ln1irp/M3IW6tB0qsxgqRFFjCCnKOqfUSc6wV6ghmYwGyAIuaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ5PPF33E90C8BE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 02:00:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 02:00:34 +0000
Date: Wed, 16 Jul 2025 09:23:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aHb/ETOMSQRm1bMO@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
 <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ5PPF33E90C8BE:EE_
X-MS-Office365-Filtering-Correlation-Id: aeb42760-3c34-4128-662a-08ddc40c8cfa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GA3i9EzCILhOdGisinU9DRFvP5+b5t6MkLOH38JMQhgGETz0sqPaC5xlBNzr?=
 =?us-ascii?Q?RazWZ00lKCDsLrDrf5QnbpSx7R3gMXeI/KUs6zwEkreGAKGjZxmvF6Iv1gAE?=
 =?us-ascii?Q?AzHV0XlFZTox/pQ3uj4dC47oCmW7i3KCgXiNdeHxIw0OqOWHXOk9xSpFjuag?=
 =?us-ascii?Q?EmvrB3FWAQztd52gQ2snJMJwk29RQ6eMnyqznkyiv7RJ6NEoIFfzqcmPiNXe?=
 =?us-ascii?Q?cesDioV0P0PFFDXpkJSxeTWPkl7XQY2kmNMCdrh5r+1TxfhBaJvXUIVXkCiF?=
 =?us-ascii?Q?9j7SBTMzY6cQHljM6JZJrHNJJEJlKZMvbvM1FfGPKF924Bri/Ey6JXEKW9UM?=
 =?us-ascii?Q?8FAvG42kAD5kTlVn0RMwwgHJukcUC8K1Ci0P4QJXRcnre1rsuAh2J4T00w70?=
 =?us-ascii?Q?mcDm6GmOxVZxWp309wJRP7yILhNcx+5kx3CYQ7nUBWCoedw3Rhqykns+wPiZ?=
 =?us-ascii?Q?Rr2bhWDf4JjLtVI4SAlw6U+28NXSmWxEOuPKmlblYGogI2bxzs4n/K6ws5ue?=
 =?us-ascii?Q?LuiXcWKpX9xu+/yPSloGkzrOWXNVHiOP/ldQjmBF/nwWyq0XDgVLAKx3OxO7?=
 =?us-ascii?Q?jDmQsGJfMW3RhHBexX7C48k4Pk5SS31l6ONJavwlaeqvWunqEA4p6MMIUAp1?=
 =?us-ascii?Q?J9lU4nBR4+XWV1Vt0nMsR3yGfw7+UT1rOQwvgga89RbK8XyAdq0u4+Lmon4h?=
 =?us-ascii?Q?7iilw0eWaB1RdQP/Fn2Nk8zLq07kv+BPXAz3gI7eJprgPtR8mToCQmL0Wt5a?=
 =?us-ascii?Q?6dxQhNv19anXnzmXL1yJ8LtTcOcEzBeqLTptLruwQ2XMICnQUwiA80jgML2l?=
 =?us-ascii?Q?sXoKGb7pG+MntKdMtAVJignQiHIDygMofJM13cGvegkPmgh+0SgbORhim1no?=
 =?us-ascii?Q?y66bhAewer28wtE5GQp9HKMPFusl7gDP8GosXGOLzImMuG4rZW9HgAjRWo7T?=
 =?us-ascii?Q?jkEmd37fAZ1F4ACFMNk3VqkgexOGwPcpPYMISAC2wpCr42kvbURsIF5n9cyw?=
 =?us-ascii?Q?jfaVOvBcWnMZve6LH6dWGIFqpamEk0xIwXXpiTVTzJTYp/6+57MSN+VWf+UM?=
 =?us-ascii?Q?GhdcWZev34Ci7XkgouVO+ieFxVhKtHHPlirDWECYgkFd/jg3cVuOZi9Ig035?=
 =?us-ascii?Q?tS/IL60YaMcn1NImUKCTZyq2DuZE5F+QXeVtUw4eA0JEWqLTBWvsmeoggT7r?=
 =?us-ascii?Q?/ZQ2aqew//+0hLUumysM41EfEWV6AMBI5XYZZM3l5opf98H+SQ/qM6OYou6/?=
 =?us-ascii?Q?memOsWY10/sZEBJQf2jcOxiH7jRi8eqj3jzyfvHpcFepSDBJ+JauqYZbsV2X?=
 =?us-ascii?Q?aUMpa/TuLE8/eE4noGHMLegz1SiO9A6MsjNX5YzQZRHJtjVUT3oJc4K2gWJh?=
 =?us-ascii?Q?FzT/PY7UqMtnZDe5Bi/N2nr4gYVeNDOfQU8Sut8lV322Yh5EfzDMEMWHQkfF?=
 =?us-ascii?Q?+EvvrL8pvHQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtT2JQ7j1pGgeZjjXABQw025YlT+Ol4natiyVp85G7yaI4QXrMJvX4rCe+0+?=
 =?us-ascii?Q?xMpxXjgiq8dyDU553P/Y5H59QIzm1Ig9MQOwqV3jtf063g1LWwoRcMJHeS2I?=
 =?us-ascii?Q?A6iKzTuf601PZfU2O9nMH1m99aCw0A6HuANnICRASf/GmJI8lXh6JRk4X95O?=
 =?us-ascii?Q?+c/snWpY3XhRmpAXAnAchrkKpv6gLDWOyBE0BJbPeDAH5xfHqKNZc7FmbfNh?=
 =?us-ascii?Q?o8D1ZN+VEXvwfuvLjOmw9x96PjqIcAvpZ5WC35YiCzsLAoxsfRS9heBjYUp4?=
 =?us-ascii?Q?MGl4sJLAk7H4jCzpyYVMYX8NZSEr19JZbXGDy/KOpF3f3zxownb0QvPswjqa?=
 =?us-ascii?Q?ZyqIxa8uJaTHn2OtXS3gZHQe3YXZPxoXH7si9jWBeJ6ZWYlGCATOoOYv9ZXH?=
 =?us-ascii?Q?GWpdUdZI87CkpBZ0gnnK6hfNtCJSme6qWGNluoBBrtKQ/XMHuLpoZTCgrMFK?=
 =?us-ascii?Q?33tNCM7/awIM3Un6v9d4wh40AOjp2EbogumXY1VgnC327Bn17Johvp2+nZG6?=
 =?us-ascii?Q?j3lDrbXlh8xTv17ZGML7wpsd3pvT1+G0/GM35muM2YyyH9SFeLJuDetWWbFo?=
 =?us-ascii?Q?h//dPPBOoP/xzFa58Sm3V4nz2tLx93r/4yEhhx7mRCEcK7ELwyRkwwvGc08M?=
 =?us-ascii?Q?kWvJHQuE9f+HSWLWaGxkg/6vINI9ktD0w9I7KhpV9QJuP64RTMshp7KzB9Yz?=
 =?us-ascii?Q?9cjhPL975QAqLUmGlCZ5oBZOXzhVRsA72KpwenmgajY5Jzv5KGWzWQ5mSmK6?=
 =?us-ascii?Q?M3OM/a06F0DM0aCvuvbSreTqYpimmdREyLep2rfy/So84Ch2LeA7U1rQ4eSj?=
 =?us-ascii?Q?4pRvSxA3UI6xuHaa2rnCWAU/w8RkdB/IySITUratC0uKOIsi36CH0PPpWY8k?=
 =?us-ascii?Q?7UW3AFL6PqEL3IFkhNtfEbjsI15JFHZbRmLSn3EHIMXQoLZX8k0DcpmxuK+p?=
 =?us-ascii?Q?R6Y47IZMUekxfcRCXGlMioCqOmWcWANKi7AgnDk6RS9Ebg9pzBerzOzhfLyI?=
 =?us-ascii?Q?6BsIr+h8tj0PonI/a8WwdU8RSg1F5hNc7ji27Z/GcmTHURN2O/0yuQxqo/nk?=
 =?us-ascii?Q?82uMdipnecdMT96xEF7K3fVsMivjl1xU2P75uQ/drd/qENFKrvcX92c4X0BJ?=
 =?us-ascii?Q?xSzpUlbV5ta1QNXqljLLGC31/5K4cgPRG31F7awzs6NAhIvKhYldSde+dPdv?=
 =?us-ascii?Q?AAST3HQ1huZML64eUt0bGIGb8w1rCEKjrEu1FrOEiMLOL5OFJFQW1pofQNB+?=
 =?us-ascii?Q?9JvW7k3twJYug9FnLeUp+614lIETjwUlWqAzAQg9PuvDgAdnzCYiiymvlmrv?=
 =?us-ascii?Q?EKRMG6uC1WFrIaMsuC3Ab0Dcd+emw1wEEb2v0GnSCkBqXsNF3vcyyZDy+H5s?=
 =?us-ascii?Q?C3LwcQoM4GMasoQBv4WwUd2JMeSMksiKNwHyKioP9CNZhsOVA9rFktdAkeGt?=
 =?us-ascii?Q?930x8TS0eESec+wJOvyoLe1LX4b7rj6axBNHsvviDpguSEWsKnb1vj3Pl06m?=
 =?us-ascii?Q?yv4Kdfm3Oz7w76Ox6DQzwaFYDmbRGkze4TGd0RbXLNNcAoF/wqMxHB09U2Pe?=
 =?us-ascii?Q?EfvU6k9K5PdUKSy1EeGMVm+eEnay4ZYM79aVL4hH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb42760-3c34-4128-662a-08ddc40c8cfa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 02:00:34.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evEdrxGOw6sW4PgVq85+HBtSkeCnB8AfcYcv+bGIximURfDVf+iTKIdG+FmchhASsrF5S6r2ujslNqR5/gpxqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF33E90C8BE
X-OriginatorOrg: intel.com

On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> >> Hi Yan,
> >> 
> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
> >> series [1], we took into account conversion failures too. The steps are
> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> >> series from GitHub [2] because the steps for conversion changed in two
> >> separate patches.)
> > ...
> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
> >
> > Hi Ackerley,
> > Thanks for providing this branch.
> 
> Here's the WIP branch [1], which I initially wasn't intending to make
> super public since it's not even RFC standard yet and I didn't want to
> add to the many guest_memfd in-flight series, but since you referred to
> it, [2] is a v2 of the WIP branch :)
> 
> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
Hi Ackerley,

I'm working on preparing TDX huge page v2 based on [2] from you. The current
decision is that the code base of TDX huge page v2 needs to include DPAMT
and VM shutdown optimization as well.

So, we think kvm-x86/next is a good candidate for us.
(It is in repo https://github.com/kvm-x86/linux.git
 commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
 which already includes code for VM shutdown optimization).
I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.

Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
from your side. A straightforward rebase is sufficient, with no need for
any code modification. And it's better to be completed by the end of next
week.

We thought it might be easier for you to do that (but depending on your
bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
parallel.

However, if it's difficult for you, please feel free to let us know.

Thanks
Yan




