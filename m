Return-Path: <kvm+bounces-46754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C825AB93F7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 04:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560CE9E76BA
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 02:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B45229B01;
	Fri, 16 May 2025 02:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jvj3xzaC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984B4442C;
	Fri, 16 May 2025 02:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747361642; cv=fail; b=Rffjf+M63E6ZLkPbBgZ2nkhnDkwc71YOKY7yTqdqN4NIrRftZLg+baiVmmFc5sl19o+K7uqoydqoJ0bKKatXPP1aPw0CyIteGgYLUdZp2gRXyGw2Gg29hCH6TXfZhF3fx0TY+jCzpjKRJzswaKi2LmPn7Q8yIQee8jcPhmYhPyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747361642; c=relaxed/simple;
	bh=BsPzvW2+ZwLkzSskuxoyaKOejxnJtY2+V14svhxAW84=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u/o3HXA4dR3JaabR1l9qqnTGts6Dbbtz7DhYcIfX/jBMOTD5BsMQjewNij6vTb9V9oQK3yzGB820YLIsXmwejvYl22lT8FVbeQYNTwZIHpmRXQxuZt+eT+YRO4d+ueeedCVXEU6TUGhutBFYUFh1DiOnZXig+UQnEvhsL+IafW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jvj3xzaC; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747361641; x=1778897641;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BsPzvW2+ZwLkzSskuxoyaKOejxnJtY2+V14svhxAW84=;
  b=jvj3xzaCRkycB0HFn3yDw+iSfs7cQGtkEH4y63yp8EbuZULKVoqRbjeI
   xFTt5zajg0LBtedTGiUeB/VAIzF9X/RszG94lzWt47gtpb7dlxMwjjxE5
   YVvkGlgdlcOtiKhaqLiLaxRViouUsgsQAKkWO+Nyni0I18JDakZIq5m8I
   GaYBMdkG/8Ulkv34erpF7UcGc844lgszpIpoRInvGiTykFRGVzDA6vp1m
   UmXWRRGsE3n8kySo70fI2HXGpFu0+X74pb/0CuCmIfLUKxg7AaV1sFMoZ
   2bUaAj5xBb9KNn2UiW9GdM+4zLF7n7RvyUEQDMepKxXpNgQklkzAoruJZ
   A==;
X-CSE-ConnectionGUID: DYOYZu9GSFqoZBySQLSchw==
X-CSE-MsgGUID: yPZiSr3uRoGOrgPbd9WI7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60662773"
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="60662773"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:14:00 -0700
X-CSE-ConnectionGUID: hvreLmxnRMOksTF68+1urQ==
X-CSE-MsgGUID: C0WV1qPxTJ+KDJayAiilLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="169619235"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:13:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 19:13:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 19:13:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 19:13:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HP/IiL1i0G67APuJHH6yOZBd1Z9SRZ8EGuahQsWn95nqmX+a1qnTAsJS7TSTTquUvGpgZl2celvo+tsdJSg+jyDV+CQVXWI9XV0XzqHnKVBgamjtzuJUIWZKPheI25M2/v0BNsxn6AAgOV/Tv8p75rOCIR65BuCV/bfYRsTfhiMmkvn0SUaLtze5mmdxn74aY6Ux2eV2EqT8TCfusj5hoCh+o7rENWrppAd1M9HnSZPX7LIK4gO/KgcKgCIHvfd+R0w2KZ7+vnscfC4Yh08jH6suuSfsv1oCw+Ri8VIN4+C3xnuktRNcGPKIQmVISo6ZrFhmvc20mYHMBDuBzvqZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm7fUIz1oX6t/tVvV84NF49IfBuU2b7SWMqi1dbEaC4=;
 b=nt+vLC7wZ6C2/S8OnmMf8A2AC4JGSNJX30RCfS81rJXdMTQcLjvXDrhvD1TaKgOYNGyvzqxQblEhlM6jPvh/nobZP7GOV8z282XGgKvXmcwepbqcYO9uobXMeWxtS2Axfd9fWtGHxObkgAtKf0Xtw8ysdqlcavwS/6gTabjh6+hEYFq23Mb3Hi+rLgFx7pz9+iBv+dHQkLWf1ecZTlQUt72sMB65ticI0hEKqQcu94AB1xEm7NCayq4LCi0u9rQXp/HRj2Wc44gffMYurJzY+aY9626sy8Kwsn6MvaMQluGPK03L13A8fSNp3c2sDR1dugDlLv/b4Zv48oCmgK+smA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6737.namprd11.prod.outlook.com (2603:10b6:303:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Fri, 16 May
 2025 02:13:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 02:13:39 +0000
Date: Fri, 16 May 2025 10:11:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were
 mapped as expected
Message-ID: <aCae0HX3URjeHwOh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030532.32756-1-yan.y.zhao@intel.com>
 <846bfd9ba7a3a2c6feb2d74b07c8cb1b42dcd323.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <846bfd9ba7a3a2c6feb2d74b07c8cb1b42dcd323.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6737:EE_
X-MS-Office365-Filtering-Correlation-Id: 35540f6a-3049-4a83-e4c0-08dd941f4580
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?RgiEp0AbR/X+pxLltUpnRp5b1YRrxi1ly9VE+UY5btbf6LcKafUP6NyxpP?=
 =?iso-8859-1?Q?h0Wupe34yIS+hR4qm4RxZssmAaBzhQqAvy9zgrREawPibe8zzfNOhtWFQJ?=
 =?iso-8859-1?Q?TpEDapjIWYUrkX+Xo/CFyRvg4Bq4t19uOoNcek8fMEiJFzI+BFPdKkByvq?=
 =?iso-8859-1?Q?SfdfzmrJpTKsOKUvi/snqHx34QGF5RgZlW+H3ys1Em5FB+mz09NnwuEBji?=
 =?iso-8859-1?Q?sSq1hJxfEvf5TveObcYWqnlxdwrtSiQdkA3LGqpRPQuPfqXDY/yFcXAc2J?=
 =?iso-8859-1?Q?fqZu1hl2TbhFIjwalDppQZm+k+gT4NiVHdsCn3a2ECId+avWMasXf2IQMx?=
 =?iso-8859-1?Q?tkYXKDGybH83TdXA44dK6MOa4KVSTqFdTRz3HK+zPkEfqxzWrzyDzvrInm?=
 =?iso-8859-1?Q?ufBXdfQmqfbymxOF65V2OL1cbxfIBX53240COLpI+fUmXDEd+sNCx3djWa?=
 =?iso-8859-1?Q?BtK4t54X4NSWYOT3OLE/ueNy8I0gsretriI7EJtHkmcG4K1E4kNO5A1PWk?=
 =?iso-8859-1?Q?bfLojQFwKG2bJGc5xY9MG6DU4e7vjMquk0ekDLvq/m5cruAynngGlruCNV?=
 =?iso-8859-1?Q?3GUQXb2u9RkL6LltWX/UsyrNU6io0gKeCvq1vDfeMFv+WEJhbE8pSjmt0D?=
 =?iso-8859-1?Q?F/wQTZM/akDMUfhsMbA2pGin1XWEc7qK6XbzsvUnZvpw7oqZv+z/8N93lK?=
 =?iso-8859-1?Q?Bvm2VZmpJCyBOa1VKCxQc8XRoPrelc86y1tPtF+215ZdX0U/8lJ70Ia85K?=
 =?iso-8859-1?Q?MfrlrhkNwYLk/fw+HLZsbVrC0QEEZaPCRVELwYUiiblWcxQb5/AFbKJ9+N?=
 =?iso-8859-1?Q?X0HH+7fuE46Fqj9AKWHvu6cRsNvihhdCOaMaGeb+OJHkiz+zPlW7smlQ94?=
 =?iso-8859-1?Q?xEh27rGIoF1VujOn7sGM1Igp2WsJVOwkaDMPqlZq/DxKukGSTy2h/kb7kp?=
 =?iso-8859-1?Q?JZIcOM+no26qcAGWn191QNYU/S7PPShk2lhhkXZphBAlvGcYEalczFlSMk?=
 =?iso-8859-1?Q?xzcAoTGDngEAimhfzUcVK50tKiBK5bh7ObhmoIKckkdhW8sV8VXwEwRv2W?=
 =?iso-8859-1?Q?NJaAxrgqRj+2ife3t0Am35SvXJ3JUZXv+LyGMb1sQYKA73Bc5mEr80jfKJ?=
 =?iso-8859-1?Q?1NtRJM13AR4rcjgcSsNQ8nAX++7cEP60wl0QlXa6/CLcVgspqwGUQ6RiHN?=
 =?iso-8859-1?Q?TrTTIJnaMD+5XUBwYH9Stly9j/+Pg3ix7+UpZ8jEyA2c04SMo7KxepLOgU?=
 =?iso-8859-1?Q?ke5z19wJZN9LEtWUJeQ4USOIrN1/2hD9PTLXqpzY21tc0sJMBwGUeP96Vt?=
 =?iso-8859-1?Q?zJtPSyIgJQRb3qqH1/61WDqKTyMt1i8Tf5l8cvdqrhjCmQnRGPZ7//Hxqn?=
 =?iso-8859-1?Q?NHzWXTTW0vZe9wuV9iytQZxg1P7pVnjwOKLs1bZoMXaUQJBpKct+VUY2uT?=
 =?iso-8859-1?Q?1C07S5H91mXEELVNioWE80JWz5owOkneyq3qpyg+4tMGC3bAqPjIfCWezZ?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?H5NJSlWf8DUlRNKCKsKYKtH8gzgBBPjb7XWPYlxRdND2VAtHpcdadRUWhI?=
 =?iso-8859-1?Q?BdFnKpWdWyqnHtpTD1NoE3RRD+YXHc6h8Q4bYyZzs8Q7hWF/P+WX7+gOcI?=
 =?iso-8859-1?Q?7ZGRXkfBSssvLtZohyyhaLwlRKZDxIs2vhHetJiT1hJFfnHaSTzD9DA+Gf?=
 =?iso-8859-1?Q?olJNicVujT5nS5Wn6tKWJipH2TR0yx8Ut7cJg04+8noy5Eyt1XcZuN8Mpt?=
 =?iso-8859-1?Q?kiEPcDuaGm/Tqgm7D/oooK07Xr92YKQ7mFY1SiiBynr6bWviPDlOFXXRM7?=
 =?iso-8859-1?Q?cAji8lHGibTmWyQHsrjOaZONDSefvNgOCPT7yhRUHbJa6EH/8DvL25fVSI?=
 =?iso-8859-1?Q?dhqwJlLYRGvhUBDUOjqNFNZGWRXQV6dA64HKyPhHbAy6EM8vugeSfX+FNI?=
 =?iso-8859-1?Q?6d+CW3LeY3+z6W5IU29ybt+uIPb6gwC0hNCk6z+16xhsa5GOp1NRE5VYd8?=
 =?iso-8859-1?Q?/kteKjPakPIOAtoe5RGJUF2ROamI7Xl2kKzF8WiaX0p79u0NL44y4fkr0z?=
 =?iso-8859-1?Q?cxYPNUmRWBzDa0f6f4P6d3hfO8hvBnex3uyaRv+dBUXGUFXWNCIc8Mr3HQ?=
 =?iso-8859-1?Q?fho3KcCdG+dmzuVwEnWzh23DZRtgRtpzZSV02IpoADpeZ+yRafQjiGVYhR?=
 =?iso-8859-1?Q?2TqiwAb7TQKZ9WZ1iNSuuMYi8ly0jYb2QXRz5jOalHe1QQvc8F1tKPb2Fv?=
 =?iso-8859-1?Q?eCo1APOJbeAXQyC5GXdRS3w33WF0cPjYN+RMwicVbCLVQsOTdEv6Vz3z+L?=
 =?iso-8859-1?Q?QmhwMgL3kSgUXDyB8ZvC/dmcLlbClnKSUYqjd3jujTIHdQj/sgpqjbv+ty?=
 =?iso-8859-1?Q?pLJHIgi+Rp2TB042H/WFWUtQ2kKLtjDz0y4yd407XldB0qsru7C+BbAqgx?=
 =?iso-8859-1?Q?ELw7z76wwrFxlZ7LV/gtLCRAzZuPyfVYFEvjc3ib2x9hBaGZYX13n5FaRE?=
 =?iso-8859-1?Q?i2qQdzE8pNsvG6eroRThbVswHghfE3F0yooyFx079hvTUu5nVcJrqJuBTt?=
 =?iso-8859-1?Q?uKPG6ympN+PfT/EOgHQ0X8rsDWJ7pjl3pzfXd0isE3kf2LasQgXT8mDPYt?=
 =?iso-8859-1?Q?yc4o+dXFjeoisjC8x4aXMaQUGSD/hs+QDr84aSBOVvyZ5oSvdwLtRKAgbN?=
 =?iso-8859-1?Q?OaDTpHkh3k8P/5shadYFZPx2RnTsmChrCyr+jAll0XU4kcAJeXhPIfAb5r?=
 =?iso-8859-1?Q?jHN5G2OoT4h0HpuUNmL8tz3bgMNFMqmZz+Q17SP92mybQzW5F62+P8GZh+?=
 =?iso-8859-1?Q?AYnEGmEtfP0XHcgvc0ZKiHpAu2AEVZeDW6NDNS3ZxAh5rWxxTPmUw03IWU?=
 =?iso-8859-1?Q?jy4jxUKq2ndELplItQyeS+/9p/D2YFNYtHRSyPwa1MeQ8uJohuDjU2ATme?=
 =?iso-8859-1?Q?WYZXo5AMNZTpXMgGCCthTFSd4GItgWfbsB4fXmycN2ieRn5lU9NMwYwaA+?=
 =?iso-8859-1?Q?XjyJQzyV2ivjTqC69iQVcGG5GcVkZqMMhzEMP1Ib1VNh8azJ1DCxbDpILT?=
 =?iso-8859-1?Q?eaGc7gnwonBKxvdhHUxroPjwFYdcnIdgx7n+jW957uF6I4R84TyNbw04oQ?=
 =?iso-8859-1?Q?1Y0n6UzpmL7SEaVBQdtkGNDNJNqCX9qLAIJfhRj7E0PAwGj6WF2Iv1FH80?=
 =?iso-8859-1?Q?UEgbCve0nnwa+0K7WOWWFyoWeBBjIBH5pG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35540f6a-3049-4a83-e4c0-08dd941f4580
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 02:13:38.8881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjmGZ86cS3fBXGm7qEpOnSPcq6Pl871EP7OElnZjQiAt7GXmezn/DW88h0XhVP55rEnCGNhjlfiHKbyQAOYi4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6737
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 03:25:29AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:05 +0800, Yan Zhao wrote:
> >  /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
> > -static int __tdx_reclaim_page(struct page *page)
> > +static int __tdx_reclaim_page(struct page *page, int level)
> >  {
> >  	u64 err, tdx_pt, tdx_owner, tdx_size;
> >  
> > @@ -340,16 +340,18 @@ static int __tdx_reclaim_page(struct page *page)
> >  		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, tdx_pt, tdx_owner, tdx_size);
> >  		return -EIO;
> >  	}
> > +
> > +	WARN_ON_ONCE(tdx_size != pg_level_to_tdx_sept_level(level));
> 
> Why not return an error in this case?
Yes, returing error seems reasonable, which indicate a series bug.

> >  	return 0;
> >  }
> >  
> 
> No callers in the series pass anything other than PG_LEVEL_4K, so do we need
> this patch?
Oh, this patch is only for future VM shutdown optimization where huge guest
pages could be reclaimed.
We can of couse include it in the VM shutdown optimization series if you think
it's better.

