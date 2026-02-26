Return-Path: <kvm+bounces-71925-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKf0IqLpn2l7ewQAu9opvQ
	(envelope-from <kvm+bounces-71925-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:35:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E10C01A157F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13171305B288
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B870A38B7D4;
	Thu, 26 Feb 2026 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQrhqdhl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8C91F5437;
	Thu, 26 Feb 2026 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772087687; cv=fail; b=Gr/s42ILsNgsxk5wq9LbWVpCcgfZpbRcTqh6aIFEPwbpUQA9c8i3isybx76gHRMkQWBh9jUp9ne8i9TCEYFD0eg+IlMzjwEOPiCqssSHiC5YkwPwS6g2hARrT4aNOL/cdgNmJIJxRRAgmvB/9Vam/DQth0t53s7JiAvMUqPSQ9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772087687; c=relaxed/simple;
	bh=7ZZaEz2iJ7y++G+toullYigEsQj9pPIPRhrNCimFKvo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ApTyqR3btQ+q4XlmZSVxz6u/2+ImERwchDqf5F+Bqh0c5rZxvQhOc2Rogl6eLChGwOWP+mD/SBfGkSQkyHOGOZHef4D8c2BlHFeBS7pOXN94IWwzWCNMIbVONk9jJEv7m/2ZTqFQB/tAK60xRFe2B3gzkQEGDCjjY8djwSu16kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQrhqdhl; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772087684; x=1803623684;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=7ZZaEz2iJ7y++G+toullYigEsQj9pPIPRhrNCimFKvo=;
  b=nQrhqdhlwD9KWB2GPEqSJ+GGIbzBO/WdaXpBcbQnq6GMv/JwT6oK/csP
   O3eMtOFNSMWNyopNRdpM46FZtudKyFEvBetTxZGSSncv/jhQaDOdlOUDP
   ibplUjG7go9B/InLU5SDx6nIlQJkYHOczo5dZY44WB2ksAXCCfIbLgQjj
   cddAP5NJp5GrZIaiqfuBin9EZBGAgldq8Y9LsVyTVmSAQxauvgk6dKF2Q
   z6gRjjvw/U5yIPADQsM6J7HxO7khXjBHkTrD/1+UKuCvSGXtFCl4ctFAN
   grsP4HTl/p6rn/05h4veeNSYExUbxSglKJ3U2PPxnD9UAq2aOyqcryLrR
   Q==;
X-CSE-ConnectionGUID: ddYbQbllRDm2RQbmfmJqkQ==
X-CSE-MsgGUID: Ttho5Jc+R3Wddh6vYGW7bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="84235191"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="84235191"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 22:34:44 -0800
X-CSE-ConnectionGUID: hUsRs609SY2+kZb69Qpspg==
X-CSE-MsgGUID: WdCts99BTye6zIEIHp86RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="214491207"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 22:34:43 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Feb 2026 22:34:42 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Feb 2026 22:34:42 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.3) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 22:34:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGQ+ekXz8mT+NjpqJcEeNpXgZN58dHxle5WNuA2uBIgVeuZQveWBylt/2vfIaXjY6Hld7rNjRDZptdJss+6DEq745Iy6GK3rHphIW/H++BjjJLRGbStQuNg3ssDL42eBpTeI43cPny7MRYcSJGcB/h8Xyry571zvCnGTAZ9zRkASkLhz9AkNZoF4XI6QJJNCXDK7k/NZdh6qJJ+vJwDkDXjrzByuMfFV4JPBmLvXFhMp874yZFuYzAGbSkkfxWR9dPz/tThR7g6Y6f/Q4dRFGs+axPAGL6RE3ahOufhuCikiIoaEl5F5/By8G0yD8BZM39lPq4tGKFg7y6fApD/erg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhpuzIkFC6WgWX/7qnzChMTlURa6odpIEhjNgaWZz/w=;
 b=QX3f/ZE6UBd/4wgglk438acAPCoiOVAhFshCbGV3QihqwRmPfU/imOpUcmcq5VzzA1mx9qcfPP6JsxNFd5pS9hsFt/zdKWGCly6fg1DMNLgncGzM8QbYJfw73dPtOea/RtAem3tLYyXt3C5f9NwtohQhYyKnpaMctgmPP8TIMGqdukx6H+5xUtRkOlt1zFQQhB3E7rYpKL839UmJFmNDgwKvHLGVsDf2N5PtgRV3XgDFnSDEx04C4SGs3tzCPqXHSM1IrW2szc0sfG7J8zWAKlUim9CaALhrmh7a7jNEx91+bLJxOrbN1GjX7qkyNTJrS8DSR8ae8pTlbVerolOpcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6879.namprd11.prod.outlook.com (2603:10b6:510:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 06:34:39 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 06:34:39 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 22:34:37 -0800
To: Chao Gao <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Message-ID: <699fe97dc212f_2f4a100b@dwillia2-mobl4.notmuch>
In-Reply-To: <aZ+31DJr0cI7v8C9@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-22-chao.gao@intel.com>
 <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
 <aZ+31DJr0cI7v8C9@intel.com>
Subject: Re: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: f177ad0f-0130-49df-51f7-08de75011ded
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: /SJatkqh6bYqTLOm0v0EzqiSxcVoB9gzCmXd5tQU6/Rq+FTlmkuHvtOIlGBG/irTQu7x9Kdj0oBQvF3eXThZ9BG7eB8EuP3ouCJgHgNCSER17Oaxt7+3Jf5WY6ZVc+O9PjUXFhnogmPhzqtiv4VXHzqMBz43Mug54VQ4pestGwKDUqFtLiNIkNUZ3biGVnXiTFwoUftDsHwPW1e6YjG8E3p25x3Uai6IzBW1XX1qbVXvnN8FY1I4yTN+5ogVpsZbSa2plbN5ELeBrBifAYnkw+9MaxkHf3lnHtNJnjm2QgkSteWCwt0dvaLYXXJ4QYklWXxY2Jwpu/m5gFq25yIW6xBkEHEBbPseYuHWLaVcziBuVbWi/6nbK0xW8YZvHBKwYQDWUk18yPT0I3pvw+ykGDKdFuWHHtMlfaocZ8Nxg4UhY9AMPlklAqGmHbXiPMRu0oaEoLBNP2xqfTtcKqCCXPX1EgRS+pBG7yxeAgdYmFJp7kGkQ/A3WIL1t4d2dU7hT8brhUlD95SzsTaROaIGCGesnLKF7M34GMR6NrmTj6+pEJjfMolBBOsK59OEzWemwk/FyoD9fa7yeQ/53wSCSNFde7+3Jvcc0KO8sU358G24gygAqxrFiEF6dDha5adxTmZbXJaya/xagYHM+VymTeUGRsL3MwlTTO48TswJWuUhfqexlIN/XRWAY462fV3W2KbTjE7umydoasPWo47xGr0sj7BgO479FzVHVjcY+FA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWZwdFNsUTdRQUtwZytQR3lISm5pNWprNmo3TnU2ZzdrUDNWZGtHcjhjTFY1?=
 =?utf-8?B?UElRR3Q4bTNkbFdyOWRSa29xUVJId2RUN2JBZG1KWmg0Sm9JcXlJVVJEdWp5?=
 =?utf-8?B?YWdMME51YVZvczhkNFJxZFgveEhCYTZZaWozZWZSa1ZZUEJvV281TUZnY1E4?=
 =?utf-8?B?NGsyeGxSM3IvRHJnU3FUbU1DVGlnVGV0NjllZjVOZUxIbDVLOXdJdjB4alFi?=
 =?utf-8?B?WFZLYUU3NzV2a3NzeVU0bHVaTUxKR0xLOXhnZmFDdTBRa2NURFVUSVAzN3Bv?=
 =?utf-8?B?cjBVWnNmWXNmSnpuSFJNRU5CWU02NnRFRENBc1A3cFB4TkFvOUxGbVZrUzRP?=
 =?utf-8?B?YmJEU2xmQ0NoWEdkeVlXbTE4bU53dHpEYUVhTHh4Vm1FUXpVRXpsejI4N0JH?=
 =?utf-8?B?Yk5lTG9TVjdYZ2FTajFTNGVLWEt1Wmh5N3A4a0toaExkUHdWY1RtaVQ1WnNI?=
 =?utf-8?B?ZkNHVEdkbHlnd1dPcG5rS0g3NEZXTkVOckhIZjh3TWt6ZUE4ZWxnYzY0cEgx?=
 =?utf-8?B?N0JQZWoyaUN6aFpFZjBhcDlqWVZKeHdXSFUzUkFzVWZ4cndZT0g4Y1ZlTUo0?=
 =?utf-8?B?amZCdGhIWCt4V1FVQWFUNGh4UU51ZEN2Q3dCT0tXSjNOam9yOEdlbUhKNWJQ?=
 =?utf-8?B?Tjhmak1nOWk4WnZPMnlnamcwaFJIanluZmp5RFo4MXg1WXBaZEtqZS9ITkM2?=
 =?utf-8?B?c3YyZWpUcmlwdFlxVDlnbnhTb2NtWnIwM1plSzMvL1lHSUtqTCtNZHVGemxO?=
 =?utf-8?B?dVQ2YmNqUi9IMEpSWWhKUytPd21mMTJNZkd4WnBBWGZvbHZSb0t6QXJ5Y2pa?=
 =?utf-8?B?dHg1WktXTmFYQmE1S0ZKWi9OdjJNTjJ3UHJ3WUlacEw3R29ncUxTTVQzR0ZY?=
 =?utf-8?B?aEdHSnk5MlBFTWNYNkhYUTd6ZVVNM0MwNS93OE4zemt4elFxbFR0elhsRi9E?=
 =?utf-8?B?d3JBekEwWjBkcWxWZjBiOXgzSFRjZUg0K0MwUUZNcG0xTVRqMDJra0FaNk1U?=
 =?utf-8?B?N1UwMDBtR3BUdXM4OXdQREFlQm9HL29Cc3JISjcwVmpDSmlieDI2akZMdjZ5?=
 =?utf-8?B?UEcrQi8wQ04vdms5R2VPVjF2TGU1SGxhSWRHMEdNWjcvYXYzQVo0MUQyZkZl?=
 =?utf-8?B?U241ZUpiTWJxenJmTzRWalMvL2lkUWIvMDdoMmwrY3BXU084SFA0a3ZhRmp3?=
 =?utf-8?B?OWUyVW53bmxTcVlQNEhzSlI4dE12MExWbGdvQm5xTXlRSEZXTmFxVVRGNFRY?=
 =?utf-8?B?TnIrdm9rMWdoQVVraTNRWVBETkFFZldpanFLdFArcXQrMWlIUE1EeWppVVhh?=
 =?utf-8?B?WHNwVTY2Tlg0NFZ3VzVIVU9JSDdia2duYUUrMVMvZkZUN3hsSW5RN0Vyb2Fr?=
 =?utf-8?B?V0hrYlNPZ3h3akJyZldpYVhScitHNjZUVHJpRC82MU42S3d6UjhER2JZVGxJ?=
 =?utf-8?B?L1NJOTQ1TFdJbUFMaDNXV1pvVitkbFJ3d29aT0ZXN0ZTMTM5M3JCeFZMUkY2?=
 =?utf-8?B?TkZmeGlUYURKczc5aEVwak5rMEg1eVZKWGVMK1VHcklLZ1VTYnNJb1pjQm5K?=
 =?utf-8?B?VnFOdStDbDFjTEpXUml6ZVgvUFFTZ0tJZ0JYcmI1cDI4RHplUVMyc2lGUkdY?=
 =?utf-8?B?ZXdPdFJXOUFBdE4rWWMySGdUZ1dZSkJjbUZlSzJtZUN1L2JjTXhPYlcyR0Vp?=
 =?utf-8?B?Z0VrZ0FlK2NsbFZOa2lyb2pxOTVLSVQ5bzNDZ1pYVmRpaFJiYk14azh4aVFv?=
 =?utf-8?B?UW80SE5Ndk1UVXF5eWxmTGNKMFRIYktkOVVEanVmRGpGRlA4SE1wNHdFR1FB?=
 =?utf-8?B?dU01ZjZORUhhVkJPNnZDZEhyTUIzeVlCZDNQa0t1TUo2VmxkNUtETkVYNjBv?=
 =?utf-8?B?ODdqSTdiMDJsUFVHaEhmZkFzNlBlRmlTWGNibURqZWczRDhOY3Y1aXpxUHRJ?=
 =?utf-8?B?YWdTNVFhY054ZUtWZmNvWEowTk5JYXR1cWFlZFg3eXE2M3F3YkowWDhVcTJz?=
 =?utf-8?B?bXlXVHRtYUxtcjcvbjI2L1k5dU0wY0ZteGtGTmIxUmp4VU41bC9sVEZIVTJm?=
 =?utf-8?B?c0w1bGZycE9NdTVIQTZqZ3Y2OFlWazU1cUdOQ1ZBLzhqYU1nbnJsNkk3NTc3?=
 =?utf-8?B?b204b3J3bWVWcDNvbGhJMHVHODN4TGp5bGlURjBMQTJ1czRnSHRLc0oyRzBp?=
 =?utf-8?B?ZkNnVXFjczhYTitVS05JZG5wNmNsQnRIYlNXY2dMYW9Kd1BkSVd6WlRwaXRU?=
 =?utf-8?B?TzltU2lqL2FDUzRMamxVSHZQZU84Rm96Y3NUZ2Evb0xyb2RNVGxzeHdBL2I1?=
 =?utf-8?B?S3ZEQTd0VTlwOHhzUTF5dFNBOGpuWjc0WGRoUU1BTkJvekc4MmJodU5DSDAz?=
 =?utf-8?Q?wIF52FBpO/OlBe7Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f177ad0f-0130-49df-51f7-08de75011ded
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 06:34:39.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vGNNwjpE10eUiAU0EK/gcaRpX/eNANusMDSNxgHZmPKI5pd1uf+3uMJmfNufFE5DJXryXJ/88Wl3ruHDI4155lSvBM/yXo2F1fOFbdtOVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6879
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71925-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E10C01A157F
X-Rspamd-Action: no action

Chao Gao wrote:
> >>  int tdx_module_shutdown(void)
> >>  {
> >>  	struct tdx_module_args args = {};
> >> -	int ret, cpu;
> >> +	u64 ret;
> >> +	int cpu;
> >>  
> >>  	/*
> >>  	 * Shut down the TDX Module and prepare handoff data for the next
> >> @@ -1189,9 +1192,21 @@ int tdx_module_shutdown(void)
> >>  	 * modules as new modules likely have higher handoff version.
> >>  	 */
> >>  	args.rcx = tdx_sysinfo.handoff.module_hv;
> >> -	ret = seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
> >> -	if (ret)
> >> -		return ret;
> >> +
> >> +	if (tdx_supports_update_compatibility(&tdx_sysinfo))
> >> +		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
> >> +
> >> +	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
> >> +
> >> +	/*
> >> +	 * Return -EBUSY to signal that there is one or more ongoing flows
> >> +	 * which may not be compatible with an updated TDX module, so that
> >> +	 * userspace can retry on this error.
> >> +	 */
> >> +	if ((ret & TDX_SEAMCALL_STATUS_MASK) == TDX_UPDATE_COMPAT_SENSITIVE)
> >> +		return -EBUSY;
> >> +	else if (ret)
> >> +		return -EIO;
> >> 
> >
> >The changelog says "doing nothing" isn't an option, and we need to depend on
> >TDH.SYS.SHUTDOWN to catch such incompatibilities.

Doing nothing in the kernel is fine. This is a tooling problem.

> >To me this means we cannot support module update if TDH.SYS.SHUTDOWN doesn't
> >support this "AVOID_COMPAT_SENSITIVE" feature, because w/o it we cannot tell
> >whether the update is happening during any sensitive operation.
> >
> 
> Good point.
> 
> I'm fine with disabling updates in this case. The only concern is that it would
> block even perfectly compatible updates, but this only impacts a few older
> modules, so it shouldn't be a big problem. And the value of supporting old
> modules will also diminish over time.
> 
> But IMO, the kernel's incompatibility check is intentionally best effort, not a
> guarantee. For example, the kernel doesn't verify if the module update is
> compatible with the CPU or P-SEAMLDR. So non-compatible updates may slip through
> anyway, and the expectation for users is "run non-compatible updates at their
> own risk". Given this, allowing updates when one incompatibility check is
> not supported (i.e., AVOID_COMPAT_SENSITIVE) is also acceptable. At minimum,
> users can choose not to perform updates if the module lacks
> AVOID_COMPAT_SENSITIVE support.
> 
> I'm fine with either approach, but slightly prefer disabling updates in
> this case. Let's see if anyone has strong opinions on this.

Do not make Linux carry short lived one-off complexity. Make userspace
do a "if $module_version < $min_module_version_for_compat_detect" and
tell the user to update at their own risk if that minimum version is not
met. Linux should be encouraging the module to be better, not
accommodate every early generation miss like this with permanent hacks.

