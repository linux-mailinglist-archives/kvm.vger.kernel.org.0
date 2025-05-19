Return-Path: <kvm+bounces-46957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F603ABB54B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD3723B19FC
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 06:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9036F2459D4;
	Mon, 19 May 2025 06:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkkpYwRW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C994F1CF96;
	Mon, 19 May 2025 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747636920; cv=fail; b=QAJ5hUbZhpwcAJ2nkqFvbKUMZXOdWulSeyl1hGHqjh/q1at77ahKPbbeaNiRVIzR7QHSHYFTRKQ3RW6VqHrZQpzSdy1r3lPYQuwE1wuPrHN22eFBM5v7ADOhoAkG5NAV6Mga0QmovISLIiuPiDX3nDMtfn9v8aMjQWaGO2WzEvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747636920; c=relaxed/simple;
	bh=nUV68x7yBGEkUOL5Ki8DS0cmrFshizgM7ihzMTUyN0A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jbqb6bdx9dl4FzvkBPIM5jqxjdZVDV5i87MoEKRvoy2+B/kY+E996WWLyBMsNiK8JjhurEcXZ0EBSeh291lEU+cEPm/uBwjyKhR4S0U21BHEQRgWfpaYYcEQ8Pi2m/KP1FUSegrcnHN15a8w3uFaIHuG8Qsi0nXX7ADEGIicaww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fkkpYwRW; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747636919; x=1779172919;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nUV68x7yBGEkUOL5Ki8DS0cmrFshizgM7ihzMTUyN0A=;
  b=fkkpYwRW2rzB1+WefnNaIl3PDos19RF9fBMqkPuqswhlgJhI/0S0Yw2e
   tQ+UoaRX1I9h6Pj2OLTfVrsvboK2/LWrgZSwzoUrOOWkpHqZHAZLBwurW
   Ff/wl/+iiEOYwJj46vxQ/61fpYDwADta/pBi4zd3rwSe8kJQ768159i3o
   77xDwdOXS4fibWrmb6UQQ62tFQrwr7OwMtR74b5yyVR5A87tu3IIsqiaR
   wtBAaIQ8QUtlNDU55R0R6yrWmarGFCoWo93EwXUru9hoCLcVOFT0epJV1
   MkjaKRJkCtrsv9/XOKJCeKqXG4lba3F30YkBZn5NET2r3zHROBbFRN6qw
   A==;
X-CSE-ConnectionGUID: no9h3GtsTXOIpgtIvxevqw==
X-CSE-MsgGUID: gluUuGuuSMWpWDafm0jctA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="52154881"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="52154881"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 23:41:55 -0700
X-CSE-ConnectionGUID: Rrk+D5VqS3GigfTAI9wfog==
X-CSE-MsgGUID: iR9U0lq4SeKsKxFIosyz5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139185121"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 23:41:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 May 2025 23:41:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 18 May 2025 23:41:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 23:41:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8TTWRAGJx+a2ABCaakZhPThciaSCN7CV45ZOZHQSJGEHZESOBnYBtzIsns+XEubkjwamVVAzSdfBm+cCMUMLyQBjD3MQ16H6bJhAEGPvb5YxTTzulJVtqjoOKRY7bWcxUNmbs8z8gyGsm3P8k4wNpEM/41uI/pMT5J9eXKgIHiLBjrZElVwp+ww3FHixDmUmpZ4rMUYPifpgL4z4DLjxgNSrMsypDF0pzQZZsIiKUU2e62rltfePnOiS3Q8KEMRS/HCqJg+CbzV4HDc52+/upzCnKTEcB7HDfPtwT6svmmpnRX9U1KveSEuCV5xrvS94HbiX4Qwy8c3a99TF1S0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23nRutfq4r+jEM9k+nJatQb/6wFdEvzxMGvKbb8co8Q=;
 b=h7jM0i6rUnW2Q9EYvISuS1XBTaw7eeAXtiLBwafT/ZGQJt2F5k+lntZpUzULIjKfTnPvl3dgn61pM1lSd4gY5BJbaCcCa2Wn2G3FJP2fXDKMofqYXSLBOvUrfdTNk92ZXDTUqfQ9D8kiva8Gh9xLZ5lOlkI7fSipkJuO7d7R51Zy9b8Bii6/RhLEXyTdsWdYMMR0UT/9ftASqZMRMxRyVC52cVzUC+PyZ9qG1HDnMimUA17Csys//7pmVYA4UDftPwPwOJ44IIZIq4A0Qg67Q87L07CrhWGABqv8366SOriIdPFK18NOsbA0R/0QYi88n6V3QfGwc+EMl1VSBsPLzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7588.namprd11.prod.outlook.com (2603:10b6:510:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 06:41:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 06:41:51 +0000
Date: Mon, 19 May 2025 14:39:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level
 according to vCPU's ACCEPT level
Message-ID: <aCrSKudi5mUVNcSv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030713.403-1-yan.y.zhao@intel.com>
 <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
 <aCbbkLM/AITIgzXs@yzhao56-desk.sh.intel.com>
 <f94e752bfedb9334ffc663956a89399f36992ed8.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f94e752bfedb9334ffc663956a89399f36992ed8.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0027.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: acf03830-7521-4c4c-b4d8-08dd96a03c5f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?quc14cmcLyv0w0fCSZ4PG/UQSCD5cXx7zkSCIsXYTiTg8tduIe0kgrwFAcva?=
 =?us-ascii?Q?U+IF9RXBdr3PS24zGOYEjraqPYAE4OpfDbvy3LZQt6ERmh/1dhY5wD0OJUss?=
 =?us-ascii?Q?hRIew475yzkiQhCPSME1DBnfMdj0TqvQnP1XcqlJNywqxrh377hKWGOsZDaP?=
 =?us-ascii?Q?IR6tank2nY1xP/PVhT9Vq9ERl+8A2C92ytHm97nmGw4fUN5Ak3nj34Wlt6q6?=
 =?us-ascii?Q?hwj9Gvic2P1iVsW1Hjx9vJmnILQgRExNoS/GoCELPYCKqFoMidcZualsh22J?=
 =?us-ascii?Q?rFvDjZdpcwTLbdeZtbi2NJYEVBMQ+B93+wTr1RAFUPYBPVdfAx6nie66aMvN?=
 =?us-ascii?Q?wxpU1ufuhc7vhLNDYFrHuAHQEaFldYaNSK8mCVSxmrKmOmDlLk9ST+QQzHT9?=
 =?us-ascii?Q?xOvum5bhaE130YZcVmuHfmhArrFfL0TFtz1Nn5/Xjrvyi6WxuWGe/1S3xaoD?=
 =?us-ascii?Q?wRzhzUnPwd7A97hstocCIzjCaNAZIORi1cTiFSbSt6PoYK06GNrT13+S4i9r?=
 =?us-ascii?Q?0dE/oNsKc5evcClImdANxgqsdgDeZxBZVkFI/QOu5ZVYDlkQYW2e88RNtGkX?=
 =?us-ascii?Q?BbHZWJA6MgLjiR0It3VtTiw230VD8U98vBmqAlvOP7nM5sCU7axloophMMPh?=
 =?us-ascii?Q?+h7r4Rw57wmEC5yfsJeZ5QjMcKl9RaztCBwS/7/GGvuTGuSeYiH4SuQE5O9C?=
 =?us-ascii?Q?BVStiGP+eAhs2znhXjHuRWuD0rgyzFKpUfYdWQEzYJzsGKYqn3rwR6GWqL0q?=
 =?us-ascii?Q?kOgq85ukBC5KkAmndVhVrdx1+jH6bRvgdSHKQ59HkEyjjR82kHDLKv+RRt43?=
 =?us-ascii?Q?xo/PL7XGhHKGtM6/rtsipScvMKlkWw3k4OB3JhCSiAcwIsjEFuWlGMzEvY15?=
 =?us-ascii?Q?GMilwzQHpOnsMUI8LX+DYPou0U+15lQ3ds72NPdSKIvxeXEgb+5todZbfYBW?=
 =?us-ascii?Q?PoupgbXEpKoAtpvkKNTRkhNx9h5Y1WLTyh9kVKJijFpFzoFYjKgjeFJa4RJ9?=
 =?us-ascii?Q?CRtqTZJMKNVAIF8f1E5w4H/CFmK1q03FfUDE8seoKzMprxyBiqKma9536CRd?=
 =?us-ascii?Q?k/QK+oOW9psbu2u+vicmylx6Jcc2c2hDGXGabUZFu2xPsBnu1MG/eV3/N9Od?=
 =?us-ascii?Q?UV/r0JomkuyfJjFK0q/2NYHrWJGAdN3B8kwcNuLYr27UGkN9zSKlqlx5tL0Z?=
 =?us-ascii?Q?IQ6/2J+2HPhX687seX0eR89UYS5IwSMy8S1lMgWFjXRfmvJtO5GuRfwVmcuT?=
 =?us-ascii?Q?7NkzmnQn6ows/ucvhNyiswtd0qR534uTIjxM5a+skovpVXovBv0RgZ05ZBZ9?=
 =?us-ascii?Q?W2w6P8qK2OnVrTGen3zxMEn7Czla7klZVha8JQZ0y9BC+XKw1qGW+vmEKTsv?=
 =?us-ascii?Q?Y9m7RyM0N5MabuUsewfii+D7uIpunjm16zlgQMFl70hVm0TqC9fEQGe7pUlz?=
 =?us-ascii?Q?SYBC99KwCBM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x638Cf0FyUwVuL/F74hL9eABuDbkZ9iMRaqZ2BDP+6pCKt3ghdfzgxJRZyYQ?=
 =?us-ascii?Q?CmyyEMw2Mo54WL2erAwrw1Gj3ZWQbC6z3EC5faSKdJRzZ0YA95djSvJXYy0R?=
 =?us-ascii?Q?h0WUBhD4Xu8ggLmLI7UJ9DX4suqGFIVRcwwbe7+JFplE2wFddflHdzRdzbcE?=
 =?us-ascii?Q?jxSvdZl9X19m6sZcOd4JFuWG0XSZ4an0JrMR1oMIQqO7Mflhlp5HgeYH6p2E?=
 =?us-ascii?Q?nvb2rtyWMoI2mrRnrM3nb25EkTXBKrEA0QzPqZCkPKCukaetvS6jwmhpiRML?=
 =?us-ascii?Q?i7o95x8u7bIEZaz75JMVDLdtjptBmYFbl4QkOsK7KCiUnWg0Rk7u7KUo161a?=
 =?us-ascii?Q?VJHlShusUqfEjXiXSjDWtgU0maAYoBmgBFNo4RaE5h3OtjW1miuU8HjkVYMJ?=
 =?us-ascii?Q?c0WDfW+CUoR2svhKDA29DyCpYNrbwWR8im6PAta//LMsY5OjKwWe+C5erTYi?=
 =?us-ascii?Q?mFV+k7nONpPayHd8aIX+IOemXSOeKztyi9w760ZLBC86/WnGsnd3++O48qk3?=
 =?us-ascii?Q?Mij6RHK0n/r1cTXz4kj9KDy0FzZ3MJfx38YA+Ufa/xy2IuM4OVMbQWKGMlXr?=
 =?us-ascii?Q?UggpP32+fhDC5Dy/GBE8V4WcvR5zIHMGoh9L2q2WuS+JVOz3elvti2xpk/Cg?=
 =?us-ascii?Q?uVxtGrZ7XB2vky2o0YrBXOYKTnJ/xy13FwNL75c1Fsmk5Ohi3fk7QwjT0nRh?=
 =?us-ascii?Q?0G5745MpUkNsDxif1Pf900n1T5atNL+Xv4SrEAbnPBfXbaxjxUh94XHGF78w?=
 =?us-ascii?Q?IsPvN0SsGix0x088w7esnc0cv04jiP3Qm0IwFFT6caVfLEwVaCg33adGGF+D?=
 =?us-ascii?Q?YhttajBtn6vQuPubX/5/lSoV4IF+q0pmVyg1gMSp1ESmeve+Je5+tCHWSvbz?=
 =?us-ascii?Q?wiu7cxAULf2hZmUcPMVm0QXp+UbV6M7A3WpV+nt0QxS4vlMBvQCnNMQUp9f+?=
 =?us-ascii?Q?knUcGfYq9yw/0to8bkKs+rB3h6PhM+f12IkxZCgjF28qtDQzK2Q3gqwXeqcw?=
 =?us-ascii?Q?XuCEG7DY/y1sIhS3IHk6UPiaazDcaJrCj6PWagk8hUUv/wDM2ELT9nocoS0b?=
 =?us-ascii?Q?CIFj1Qp5d1cAS6W+bUgbSdRdfjypUd1YtSIetj4NAh0G22q1MeE88Ni4mDwW?=
 =?us-ascii?Q?G7O5g7BAFG0XrOkUEAAffjKXoRLEqskWQILfQz9C+KxOHkwlyFbXN0p7I9o/?=
 =?us-ascii?Q?+i3k8OFIh9uDOU7AyJivduvY1wXx08988+mbDH7mIBc/oPo8eM5GcHjSAaJI?=
 =?us-ascii?Q?r0nGAkRtHbwsiEz4c/LsJ8kM9UZZQfsVtuYPjRToLZKOx4OXjEJpD5yTW+Gj?=
 =?us-ascii?Q?z25+Y25nXvZvsJ1YfYqjzq2YWpd5MUwVIWkyuLQfrM6hG7Uu215HIr3PB8EA?=
 =?us-ascii?Q?d/fYy0n7fMvivPFJTbU95a62RSHIqk+qGb0DHB/MdOs0AthBsk5TeSSjyqFl?=
 =?us-ascii?Q?sdY8yqzfgtc6gIgFbJ1rgHs+nTvBcI5u0NLoDSh3zEKOoEl1nkAEoct36gxA?=
 =?us-ascii?Q?vwE2coTKwDY9RSyTmWkvkVCEqQn7A/n5G686b51cdcLVNMOI7uxFYXybN3OR?=
 =?us-ascii?Q?BMIrtxw81yOdi3Hp/xM76FjiGgFWbmV1Pt3OqBcE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acf03830-7521-4c4c-b4d8-08dd96a03c5f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 06:41:50.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOfv58lYeuj3/+onDMSBIn06soghRxHAv/LGR8ghzJPOvfIvfLuDE/dbDWEAdl7uMCgelchjHbgEL2cTewOP0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7588
X-OriginatorOrg: intel.com

On Sat, May 17, 2025 at 06:02:14AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-05-16 at 14:30 +0800, Yan Zhao wrote:
> > > Looking more closely, I don't see why it's too hard to pass in a
> > > max_fault_level
> > > into the fault struct. Totally untested rough idea, what do you think?
> > Thanks for bringing this up and providing the idea below. In the previous TDX
> > huge page v8, there's a similar implementation [1] [2].
> > 
> > This series did not adopt that approach because that approach requires
> > tdx_handle_ept_violation() to pass in max_fault_level, which is not always
> > available at that stage. e.g.
> > 
> > In patch 19, when vCPU 1 faults on a GFN at 2MB level and then vCPU 2 faults
> > on
> > the same GFN at 4KB level, TDX wants to ignore the demotion request caused by
> > vCPU 2's 4KB level fault. So, patch 19 sets tdx->violation_request_level to
> > 2MB
> > in vCPU 2's split callback and fails the split. vCPU 2's
> > __vmx_handle_ept_violation() will see RET_PF_RETRY and either do local retry
> > (or
> > return to the guest).
> 
> I think you mean patch 20 "KVM: x86: Force a prefetch fault's max mapping level
> to 4KB for TDX"?
Sorry. It's patch 21 "KVM: x86: Ignore splitting huge pages in fault path for
TDX"

> > 
> > If it retries locally, tdx_gmem_private_max_mapping_level() will return
> > tdx->violation_request_level, causing KVM to fault at 2MB level for vCPU 2,
> > resulting in a spurious fault, eventually returning to the guest.
> > 
> > As tdx->violation_request_level is per-vCPU and it resets in
> > tdx_get_accept_level() in tdx_handle_ept_violation() (meaning it resets after
> > each invocation of tdx_handle_ept_violation() and only affects the TDX local
> > retry loop), it should not hold any stale value.
> > 
> > Alternatively, instead of having tdx_gmem_private_max_mapping_level() to
> > return
> > tdx->violation_request_level, tdx_handle_ept_violation() could grab
> > tdx->violation_request_level as the max_fault_level to pass to
> > __vmx_handle_ept_violation().
> > 
> > This series chose to use tdx_gmem_private_max_mapping_level() to avoid
> > modification to the KVM MMU core.
> 
> It sounds like Kirill is suggesting we do have to have demotion in the fault
> path. IIRC it adds a lock, but the cost to skip fault path demotion seems to be
> adding up.
Yes, though Kirill is suggesting to support demotion in the fault path, I still
think that using tdx_gmem_private_max_mapping_level() might be more friendly to
other potential scenarios, such as when the KVM core MMU requests TDX to perform
page promotion, and TDX finds that promotion would consistently fail on a GFN.

Another important reason for not passing a max_fault_level into the fault struct
is that the KVM MMU now has the hook private_max_mapping_level to determine a
private fault's maximum level, which was introduced by commit f32fb32820b1
("KVM: x86: Add hook for determining max NPT mapping level"). We'd better not to
introduce another mechanism if the same job can be accomplished via the
private_max_mapping_level hook.

The code in TDX huge page v8 [1][2] simply inherited the old implementation from
its v1 [3], where the private_max_mapping_level hook had not yet been introduced
for private faults.

[1] https://lore.kernel.org/all/4d61104bff388a081ff8f6ae4ac71e05a13e53c3.1708933624.git.isaku.yamahata@intel.com/
[2] https://lore.kernel.org/all/3d2a6bfb033ee1b51f7b875360bd295376c32b54.1708933624.git.isaku.yamahata@intel.com/
[3] https://lore.kernel.org/all/cover.1659854957.git.isaku.yamahata@intel.com/

