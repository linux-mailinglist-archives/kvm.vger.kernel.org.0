Return-Path: <kvm+bounces-49649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5E4ADBEC4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 03:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D55D81886682
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 01:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C274023B637;
	Tue, 17 Jun 2025 01:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IxQmV8WZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E01CAA62;
	Tue, 17 Jun 2025 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750124467; cv=fail; b=n/dbNlS1XWdkyR4Sa2IsLxNRlt6GUn3lZRUHmgBVQxUl0hlkhTvDoQO3Tlaqb/SY1GH9+s9YyYlKahD8W/6wzwv8sFYfZ4wcPP6X2kP95/oanj/zSAVcL9SqNVwX63DDsZVkpEeJXWoBuWx79N0X5xrrroDvHZMcK2gGIvX3hps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750124467; c=relaxed/simple;
	bh=Dd7YWinfztZIy/Aa27OwnAC2ZzoDqNRE+mCuTYZmKiA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gdz/wiLlPO5mOjVveNRyZvPh8TQwW3z7UfBpLhoDjuY4JaGZkIMrnBo8LqqjwfZiVSUThNkovHTYj7+SVylcFLot9zHrP0uvJaGD7aDkg+KzpHyewQunWZYCw5elhxy8lbsdqXtmw4kQVQVUDXuBUKdDZmAyyIDWrzuoXV92da8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IxQmV8WZ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750124467; x=1781660467;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Dd7YWinfztZIy/Aa27OwnAC2ZzoDqNRE+mCuTYZmKiA=;
  b=IxQmV8WZC3HpxV4Y1YR7+9A3cTaDHGf3fpLCHlUkRi0YszXlsoD7UHMT
   4WUn+w1viex5NRVxg3hJvmefa5Nwf+OzNc2S1MaFxyf2b0X2Nf3WyMR0I
   e/lMXxZQix6+FhXZDJUfEfY+mj+aNipuUF4LQj9V7eOoAHCwLEo+H8lPI
   3MUBuxgbeeDNKrFSXc4JTjTsAnw8k2ntDVDfU+pEgkbHfGnJPwNYMMlbF
   UN0gEMZUlBiTcUhgYeTNEKKBwBTuSGxYVXvvbdfF08767k8+8hxsBpx+a
   p/Nz9jpVbHwaxPXX01ERgyme+ogl9MtF4cv1QKAKQvHB+Zssd+j7Cgty4
   g==;
X-CSE-ConnectionGUID: b4W4FnzGSDq0EPzfMUyT7Q==
X-CSE-MsgGUID: j912JjU7SFajjRCd0nriAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52420364"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="52420364"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 18:41:06 -0700
X-CSE-ConnectionGUID: mRt3scKJT7erBTbFq/jFZg==
X-CSE-MsgGUID: HpJxDyIRScmh1nl9eYlgIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="148620604"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 18:41:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 18:41:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 18:41:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 18:41:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ryjq+UYrkVqAtOWwTlMfOUpG/JiWDJ43yJ/EqY9c+1ywBEGzIwMGGdAhdniQB3J/v+a1c/Y1mA3LI0jD6jX75oVIGD+ZDzdE+ptBovrWUWxd9zOJOokR0elDPeNN0a5hwbL5BvmWBDq2We5ZDPmLoGj8KAIqBaaNUA4pJzX03UW4EI3/TZWjRn+gIlVPHcHH+/HoYPBpSqIstvhAvGNTYXjz3MbvD3w2AywSBDStUbw9UgQGPA5Os8f4Ozsl+DwZjrdHMoL6R0gQsBPX1OBYWcE55EPgPBjPNcHrEpNExzV4FcVyp+M3YniNwQM6YX1sW92XnLOJ8qFzrdYh2gdXQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJhOXT8qXo9tbsa//jMNbmhQ4AdCoGt8oiaWqVbdpFk=;
 b=c6uU0FAOzihuHtrbN2phYB+94jkjgUX2mMQgL+EiO3Pn/jW7lq1T4VpO4wrjIFZQ1hVCQSKbVwTy6JvW5fhC4bzLwsb23oiSIAZfZ0JC+nCWOpim3nYuD5V61BsTuML3Ax8MYLZZ8CDq6704rxc0BYqV6b3TgETkHzEcZcU+7YQnDA8wCbXH//ueliwvLKOdejV7RnU1eo5nUozZJTgpaLIuwGjrvLfvVjqdGnAYvMpGZAPr5rQEv1Om9kBeIMgIKYMsTO+vP3HTHXRzKLUPwBENh5B6mIXO+gOECGg8mtTviDtdGs0M/HO26zn2i9vss+/NgC2kF6MpMSJ2v0WVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7816.namprd11.prod.outlook.com (2603:10b6:208:407::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Tue, 17 Jun
 2025 01:41:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 01:41:01 +0000
Date: Tue, 17 Jun 2025 09:38:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
X-ClientProxiedBy: KL1PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:820:d::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ead250-2445-4fcf-cff3-08ddad400408
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CNraY/5Rh7tYWdzlByZnOHbchKIskD0+g8K1vUJ8YxPu+ZjvgDG/94b0oZHw?=
 =?us-ascii?Q?/s0pqct3S71DUGezwJrA8U4MqTkc7+k2EIDkK7oZuVJ5Kr/qdTdXh/l8fDpE?=
 =?us-ascii?Q?JjLclmyNTtEcifA8BmE0GTF9Mg0mpzbuZorU7BoU3j9HxackJx4mnNIEQnQ2?=
 =?us-ascii?Q?PWhhindRHs7qnZoFXPt3ecu/Hf0PstLEZCYjDiKiT2ABDF+ikGAU6irZQxHB?=
 =?us-ascii?Q?5Fn45faBUlJSHoCoW3r3uUJ5muk6wbyl0g18Xz7QrHzZ8vyj2UilzBSrqm5+?=
 =?us-ascii?Q?+QB2dJoGejph7wYMXFHIo6+4qn2MNeUH2yH1bHis3l52IOhpe5wchQ6PhNz/?=
 =?us-ascii?Q?1po8GO1hM5j8BqxuWU6QQZIvjQ9WZ1ENCKKO75tBqITVwAIYf9xcuCJ0gMS+?=
 =?us-ascii?Q?9RuLtbYB3YJKcaEdMpnIWQXctb+aiyCufYWJ4njgfAhXabMTNMlDkCjkweZ7?=
 =?us-ascii?Q?caD6WR5NMu3d1P3nIfJ0vipuQUq6oYJqmiHAfJhlfH6DXa0MVHbvQLf8667K?=
 =?us-ascii?Q?182WOC1qKhoPgkWAxeMpGkUQ6H80vxyisszm+DOSNQmpV2ysMEAsrMzNLCcV?=
 =?us-ascii?Q?OvKvaCzLyYeHir6q4+PaqHqh008ojvyIlKBJpRduUbKkN5zb/5dYbfPc3Woo?=
 =?us-ascii?Q?IwKMKFegqLqm6nCLzocE5ezhvtpGg0LGF8lhfVg0R0xDZdLDQ28sJpEsT3tr?=
 =?us-ascii?Q?3kQJIIhUnsw+UdY3j3szcLUFt0ho3R/VB8w0V6aOu9rkA3DYR68i8wqQQxbV?=
 =?us-ascii?Q?iy4EpUZDF/3reVH5VsV1afqM28ESzAnj3xuTkUqr09RdFA9JPaO3zLvp6NSo?=
 =?us-ascii?Q?xmzAep8XuAmKeougSBQLYQIRakHy9TgFNRUS8IuNAO37O6PlRKCfCiklJKGO?=
 =?us-ascii?Q?GTJfvRurpGtnsQ6Ucsf9N5nyiNodZj7+VnlNujiXyo3H/qwIySCc65i9V5ec?=
 =?us-ascii?Q?VZZMhd8cWXDdq7pLgpklgK7FqU8Xw9VDOFdtRYpCVUkLaaaWhBIg0ybd/+lT?=
 =?us-ascii?Q?Z8j+Nu0tQbpZBBPgkel4bIPhrCOmIauLCUZZ+Xfzt5WRDSQhjxihg4ZtaP6S?=
 =?us-ascii?Q?59BdFim9Jd7q9+qlLHVPr0SniUmeQC1JD70mrRXJ4dZIM8OYdfmSvJwxS1lM?=
 =?us-ascii?Q?XBISFUbzznJAhL7ASXZxeakkZI4vwN4nddcIdRzhGdyDZQ4OS4+//L+exB3c?=
 =?us-ascii?Q?iWS0C4WXg8OxIlHJo6yVq/MhgdeTdMNgex7/bSWmT+kZBwMURp6qCt0hFc23?=
 =?us-ascii?Q?ar+QWgZwuEZ0I5DRDh0dv9tlejKVlAOk22YknDPE73d8yRu8bl3sAiGMg/Ng?=
 =?us-ascii?Q?a4pNNzy/i8ery36WXCjJOyw4uCyTadgQSEhxOClsFA0GjHWCZO6XLBif9mrK?=
 =?us-ascii?Q?3FHmOenz/n4azltwZi002XMkDM8ngEQAEM0IDjsSLhjSVPhFpKFB3sJmPB8Q?=
 =?us-ascii?Q?InNHvvHCyLg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CPY/KHBHXFV3SYrDcaXSLew7ek6b5oP8fSe3DtoZx7y35LWycf+IKIicTjlQ?=
 =?us-ascii?Q?UOT+n8Dnwj441CLLKSS/CU+om0M8CO0pUriPznRELAJvr8KwxWrI2PZ++kQv?=
 =?us-ascii?Q?g6iBqRTxx0gnnUQk/2iSITeK7kMqT4qPU53csc0ka99Yj/pc4dMEQ/28rDPK?=
 =?us-ascii?Q?OFpTc88T8q41HbEwQiVB+kc9hDvzGiU+0cgz19OgY/sgbjakNftUc5LwX8eY?=
 =?us-ascii?Q?ShzB7VrRFf5tx93TxCu1simGsNhyf+WbSYEvULUoPiVATU4yOqXOC0n2Q07s?=
 =?us-ascii?Q?kxE3q2+YR7hSOF4LIAIQtd3ZmpGz/kjliUSI3WoBP3De730VURfqPxT2BVza?=
 =?us-ascii?Q?q+8uHR0PSyLTjW/tVDfioC+KI0UbqkTjR7n7Pq7baSzS/2M6oIjcfrCosHMb?=
 =?us-ascii?Q?Y30cdRQz2HXcpJCqZadic3kK8UmZiFSIXDUdanP7Ug7yTqn5y1mRawyj7E8l?=
 =?us-ascii?Q?9UTdIFWS9X2y8wRgZO/YQTAAe0CiLmYkooveYXyH643csIWOjx14DGI/F0BC?=
 =?us-ascii?Q?sG0bckFRmXTEcszuUSw6PMSq1o9HE5Lmptk3OWNhM506RlP/Y+382L1GiyUi?=
 =?us-ascii?Q?wL3H/LDMR609JA74/wYSG3jnNYO24GihK29rqOAnDqPGHbEGrFzqta+l3//b?=
 =?us-ascii?Q?MHsA9NzaE2ravWXiLXsmmFR+3a1xe5YpHfWbldVJ8RE+8a+o6rK1huy2NeD0?=
 =?us-ascii?Q?SGOt8l5QBEX6Q1WNAZFto/c0gWuPGqdPvmTgA6vVDfvSSi8cOqhFtZaqEkHh?=
 =?us-ascii?Q?m8vZMCQqA1wH5EQyWo/p/FR+zusbsEbntMk0DuAzrpXYwjH9EEmMcf8ANWXo?=
 =?us-ascii?Q?pDp6amlciT544uslDSpcFoaeioqjxI4VXunuvt71hL/qGQMqS/YWDFtA34aQ?=
 =?us-ascii?Q?DomOG6+qB4/96L7lRnVgXV/1JjqkxY9CixU0SrnLtLbMJG70iy60TtQxgUmS?=
 =?us-ascii?Q?52wrM3QSn09AL+nwT+fWVGxwp4iF3mg/hajxzdQN+tLf0/+xx5WOj3NPASM4?=
 =?us-ascii?Q?wDPnAIFEMEbH5TDswrzDImZMcOEEIty1t9UGsG77Odmwk1GxvXxcjAiJldap?=
 =?us-ascii?Q?glXfAZpbe8slQYAqkPFzNc4DF4N2bfzkuLSuecnGlI3Ehd7JaJPumaBokAv2?=
 =?us-ascii?Q?V1aUNIRHeK/hEh1IyettYAUUZRU4nmqYOOz2AdtfVz6DIJs+lLysLyAOLfGT?=
 =?us-ascii?Q?sOwL1WjoXQXRQ//mk09EXjvNM/44kjVzKw0hcMKxcKV67UXT1abS1KIdZ9Po?=
 =?us-ascii?Q?7afrXNY+g3ejnkTIxWcY3zcmphm4NLyK0Vjfk87LfWJaIi37F8jiYLbaxUed?=
 =?us-ascii?Q?NIjUx64nYIqjCFnBeOXLVzyf9xANss3eGIgnYMB33jJKC3Rs0/b2PJVc5wfA?=
 =?us-ascii?Q?ibW1RUqfy2SyR2ck4OTmgrYQ7Ky2vdwUnoh5Z4KNCASreGl5Rs20Wmc21bHG?=
 =?us-ascii?Q?6Sig+v/rb4xnoA0CHuSKDU9LenOre/upyA3ymkUcOkHYpZ5nFt6O2uoQIZiU?=
 =?us-ascii?Q?e50bEPdOfSQuDbXbkND5BlwYATGAA9FMb7JFOx91c1WjrKEhXvVVblTuX1nB?=
 =?us-ascii?Q?bl+B/oRzrHFvQJRx3cpn10UZV4m8jqJA4nQgFMO4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ead250-2445-4fcf-cff3-08ddad400408
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 01:41:01.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPo5bc8Be2ry9TRHemXm9+//5wHdmc33Rz6lyt0SG5pSqdBfqzI/bf52n+X0zCo2f7E8lS2qHdqELVIN0Jv1NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7816
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 08:12:50AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-06-16 at 17:59 +0800, Yan Zhao wrote:
> > If the above changes are agreeable, we could consider a more ambitious approach:
> > introducing an interface like:
> > 
> > int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> > int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);
> 
> We talked about doing something like having tdx_hold_page_on_error() in
> guestmemfd with a proper name. The separation of concerns will be better if we
> can just tell guestmemfd, the page has an issue. Then guestmemfd can decide how
> to handle it (refcount or whatever).
Instead of using tdx_hold_page_on_error(), the advantage of informing
guest_memfd that TDX is holding a page at 4KB granularity is that, even if there
is a bug in KVM (such as forgetting to notify TDX to remove a mapping in
handle_removed_pt()), guest_memfd would be aware that the page remains mapped in
the TDX module. This allows guest_memfd to determine how to handle the
problematic page (whether through refcount adjustments or other methods) before
truncating it.

> > 
> > This would allow guest_memfd to maintain an internal reference count for each
> > private GFN. TDX would call guest_memfd_add_page_ref_count() for mapping and
> > guest_memfd_dec_page_ref_count() after a successful unmapping. Before truncating
> > a private page from the filemap, guest_memfd could increase the real folio
> > reference count based on its internal reference count for the private GFN.
> 
> What does this get us exactly? This is the argument to have less error prone
> code that can survive forgetting to refcount on error? I don't see that it is an
> especially special case.
Yes, for a less error prone code.

If this approach is considered too complex for an initial implementation, using
tdx_hold_page_on_error() is also a viable option.

