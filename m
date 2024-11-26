Return-Path: <kvm+bounces-32497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7B69D91D5
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 07:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 635411652D8
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 06:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38473183CCA;
	Tue, 26 Nov 2024 06:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/yavjbi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF807653;
	Tue, 26 Nov 2024 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732603312; cv=fail; b=XCxn8+uSJIhLuPpSPSq/V2ExdyJTYJtdJSj8vpVfiqrZGLkS+i3SIX2K6ru+m5il7ojwOrFAaFqsI9ayE4BWr01EQ7huQovLpom9b2lk3vgjIPGZddCSEBWuy4+5FiK3q6XsvuD4wHfD19t2sqLx9tntkPFAMSQdvRZwpVA9X3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732603312; c=relaxed/simple;
	bh=vZoMW8HYQC8mSTHzOf3HzVj2kiIyoc6nSXtQ9ZNd+j0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l91qHcIwZKSssUfHgnAeM8i2GK/rrwygSsIwTk3HpqqZpBzIK+hBSS3A/whf2oLfi7jLYpiEYigh0N/6ORjVEGiNlO4zGk7+faDitepjFnQauryP8E16YzMt8fe6/ROvoQpUBOkvV6usd5y6RVQy0BFtupDsSgj2JTZkI23vwjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/yavjbi; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732603311; x=1764139311;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vZoMW8HYQC8mSTHzOf3HzVj2kiIyoc6nSXtQ9ZNd+j0=;
  b=g/yavjbiO8MGTBGQ2ElBs4LZ/6X0hX0MFqGsF1p3Hd0NUiM/tZK5fjkt
   Kgip0KykLlKdLBi6pBr4TBuBnOt/BU6XXf/jvFKWRAyV+Lq72D1fJnF5V
   kB1I6vpbt3mIJYXI7K+Eoa0BYwLpfsXGOXbpavg+g9s/NCTid0j4EqKJ1
   8cFg7MRR1MwfneAk+P7A9MTSTbCKYuADW/cJpcUd3oToc6lIGoZjpxb6W
   Lz5X9rLXCVakUxLiuX3rQR7iWMr9a9dOud8hXoJEfaN/Pd2gNgTBnZeA8
   PSfLXRxnC+oC3Ixxv1kYfcVoAxvSt33Tli9HZ1ltJcWA5bLv6ezuNR77C
   A==;
X-CSE-ConnectionGUID: mQoCk+s6TTKjK7MhXTDUkA==
X-CSE-MsgGUID: 7umPG4s4SWe+ZZB7cevJ9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43360702"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="43360702"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 22:41:50 -0800
X-CSE-ConnectionGUID: +RnNiI2nS2665SeG2tRqZg==
X-CSE-MsgGUID: ACA0oqd8QOOwSuXhJcfwxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="122478740"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 22:41:50 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 22:41:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 22:41:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 22:41:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dFYFVpObDwVvHl51dsFPXKZKzIFqppBLY4DjEdTYP6ibOEDmAsELAJXmL0MyPQn7w6jxCvoxlHmEK906REkKDafJ1f2GdkiveZL9d56Xmkul6NpIrFMSok0TRWE7wQQjxt0yEP+D4BR8qgyRzTZIocRllqLf144v+PwwhckPN/e8IkEv/eJhKkys3Gl23/mhcslOx08FRM4ib967gXwdiJp2vMbweMtNn/+JVA2m2YOsQdcSLzLeoi+qe/a0yGOgzhdtrXfscS9ta6S+hTWEPRSnvA6dT5nHMqx8fRrkm+Y1WD4oiF4jmYqUFjydI6T7NKY8viRPy1IXhNl5Ym8oTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZceyVcFywaC1o2O0jCdlfJmqdwk5bG43XqDAQtsHLvc=;
 b=UzSaH8mLVsYnk+VkRDoKMx/wmbIiWaKvkt/gjSUTE7UCpF33t+Q/uCJcLAJUHN4Zznl+3tTCWZwQMP5h1+8/U32cwhKClsDX3R/0T9+WzPhAABi2MliDlJY4WopE6o6+hWlKdbpvp9mXVY3a7i02EJ9JCzVlFYZExJMCq9CQRW3fTEB5sdhBujP3JlTWHSHrXSX7Oh/yLJHqthe9bUk0mIiHXhgw7WmkqeoiSoBnWV4M57Ih1rjzhCG4TansUVtGYdLmLEhDVjr5NMXs3nZAMXRjhrqYUkMSQCkSlspWP7LFcX4yNMgLyoTN5IHHhE0m8SVinj868CP2kTQr2StovQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8424.namprd11.prod.outlook.com (2603:10b6:a03:53e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 06:41:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 06:41:47 +0000
Date: Tue, 26 Nov 2024 14:39:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Message-ID: <Z0VtCHqdxwu4YcY+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
 <20241121115703.26381-1-yan.y.zhao@intel.com>
 <0a99ef415e06ecd30b1c40b93bdec5923b9585f2.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a99ef415e06ecd30b1c40b93bdec5923b9585f2.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 9205df0c-ea0e-4059-0364-08dd0de56637
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?E6xDYXkMoXofK0KgWuKqvdP/yWEAAa0tcru6n31gjQpd3/8c/9RYyGVbzJ?=
 =?iso-8859-1?Q?0zcsMHTFcvkfDsDAzuRFQInvzVWXaXhe0J8gSygYEUA01nTFTMHW3JtcU9?=
 =?iso-8859-1?Q?6ZdIfB2Syr+dc/1uoH0EJjQ70psOEKheLW6x7xzFSnOOZ/HGCFaK+7q+Yc?=
 =?iso-8859-1?Q?OVEuuuLpiK6Huwm/mJ621sCrnB4Ukh8ty9tXqTZyHhe01fcHJrCVlohCCO?=
 =?iso-8859-1?Q?YNJwAiIDtqI0E5lEiqT/THVAsq138DqSmCi2GW2yb+YXnAbOx6z7D0KPnA?=
 =?iso-8859-1?Q?YEyZYYZuyS+U8+nJJwmLdY3oxe8vYfTTUijYCNMM41YDOI4ZT+OsksOwry?=
 =?iso-8859-1?Q?GZwCL+KrlXCJt5Fq+gq/wih7e0aZ3Jh2+IKrwRNbFpaLARd+Abf6RzMNKw?=
 =?iso-8859-1?Q?iqXXnmC8gbHbdljRA+x2a0GPQvoYtMcu/5Fdn10CSlTBNbQrEknwuRJTaP?=
 =?iso-8859-1?Q?Za/2I2D/Zsv660wyrVsgRCzc7vEGrU+UXakTfyl38+GLAUZQ6Rtn+6hn1H?=
 =?iso-8859-1?Q?ATWI62Pwc4CbFwV/pENgcIHwO6Uk31ca0nRqkMBuph8H1xaQccus11s//y?=
 =?iso-8859-1?Q?1XNSg02Jk0MDoU3R+qyVwwb2q7BLpkTymoQ2lpJxbxIl7FvxgetfGahCl8?=
 =?iso-8859-1?Q?Be3PKLwLTArbRlvt5CNmV0SMADHlR+LiBBumWQFuQElfAg+cg9CEb5OlPz?=
 =?iso-8859-1?Q?QT6VnL8i0Ivacw81fXU4QLgACwPhuypHquJn8Ial4VMoXuzwMJn3ufQa1F?=
 =?iso-8859-1?Q?G1MJZX3H7+CbCqp5o5FtqOTyf593jUxTs3o/AcaKR2SK7zjoNA7+Nc+0Th?=
 =?iso-8859-1?Q?XPnTnF0j89xD0h4PIiluBW/FhsEGihxHCniFDvw7ktzM1jke2WgBiiyQGb?=
 =?iso-8859-1?Q?iiiBD+aKHHzr9+cNZcWMmd2kFWOvvdfCKpB8t6/N9B5EkogrtQZG2fR2rp?=
 =?iso-8859-1?Q?X72d0Gj2q8BCf10b57W/gtRShJkd4cIUdYx9720QOeYFAIx+mWh8mvmArq?=
 =?iso-8859-1?Q?eLwu+/gxyLk2v9Lx3m3Qt1bkbQWonsal9RTkWOOa7LykMNpRKhqfVzBRnj?=
 =?iso-8859-1?Q?nHipCRAv533GqTPYhebOgjp7zl6L7oUxnwA1rF/37u+a/I7incgDN/xJ6y?=
 =?iso-8859-1?Q?mMG4Bd1x+zaq2zQyhZqyWQZWtxajn8Zk0uxHwAakATeFOoUMGGoNH61NDI?=
 =?iso-8859-1?Q?XL9Pu45hADW7skFSM0Y+adl0EWTYV3+3v1TIVjRl4lyPHkeBQgB9PctdVn?=
 =?iso-8859-1?Q?yZHmAHh3l7gzZnY3/5et/IrKozTmYBnsOrLEkHwH2yNv406og9xJbU+396?=
 =?iso-8859-1?Q?94UpO50BLBm+7tmp2Eiq3EWy2mFm3W9Y3jLPCpeZNJGq98rXaTJIm5dmgy?=
 =?iso-8859-1?Q?2DnyuuhoZbj4us247bEyoDfpcYsJnhvg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?CrIJeKa8pnloTxwx8Rg9CfNy27ag4ky6MPIHFkDgL3tZ2/fwXapWf0vp40?=
 =?iso-8859-1?Q?0i+dCui968WbLHl514bdTWUTmVG3vC/O5ExKeGJFDVK+ktn/pN3ZDq8A1+?=
 =?iso-8859-1?Q?lpZMBKnIl6e4ccIWjrOMgAdCADo1TWZnnaqrD99/J0eaNAtsvcE8LPfT6P?=
 =?iso-8859-1?Q?XVDkwcUj87FvDIjohSzjNT8J3/b2b4ivoxrJYmM5g9h7z+Q4I5JUUSGBbY?=
 =?iso-8859-1?Q?Vmr5AjXu6ghxrILT8UJ+n5i76QPcbJmFOmpvO+4VZy1n1ER1NSh/S+mfQ7?=
 =?iso-8859-1?Q?9fPFo+MHhWmEy/vnuYqJvSziB4PtfWzomqC4bh74ERMCY5BLJ6I+dnC1mJ?=
 =?iso-8859-1?Q?2Nt4jvi3LYnJhh+1Y+cEzTwGdugBixODDBCLsT0j7dR2tO7PGNsghYvECN?=
 =?iso-8859-1?Q?kM0Fog1Dec2CSHiEigYxHD7c15ez6bGsbDU7W15P+NfLB/je2wZ7Bhq/nd?=
 =?iso-8859-1?Q?5BCrFL4j4ZsgMvXszQonBF7EihhxL1038g5raHliuJt0QRXYoSXCV3gnbU?=
 =?iso-8859-1?Q?jY7F5lPLju3fj1h1ywfk+D7wQjDc4isBNHwptNJqo4pzN1wJyBuNqF2Rhg?=
 =?iso-8859-1?Q?ki2cF5kG11f+rXDkIhMgnRYgJZeWgjedgGkJXdOHCf2TTPCALNXLWxRhQ5?=
 =?iso-8859-1?Q?IhvVol6av7ZdK+E+3n5GBH/0MXCLFhNjYwAkfQXKQtjSoihWXBWpgIB+XF?=
 =?iso-8859-1?Q?xgRUzPt6xi7hCjP+C+fOk43v/7UWrzWTR47rG9CEzV+i+udUbyYybXxGSU?=
 =?iso-8859-1?Q?JX3kiztdSE8xN8LHjKGHJr/3byXcA8TdwjkztEMQm+j34zRskWfB5TTbjh?=
 =?iso-8859-1?Q?86Jt1ETq2fFgtfOhVAqmMQdCDeoxlZIcHy2R+CRN8GhtgStXsOg5I0UCQY?=
 =?iso-8859-1?Q?l6D68kAWSnkIylNC4VmivcBc4GZs0g+x728Wug7eJ9tU3+usYAdiwNzeh+?=
 =?iso-8859-1?Q?+eqe9W8jimNYarTGYYSbln9vTqwterZmIj0kY7E8e2jCVOW8AdMSKIA/iQ?=
 =?iso-8859-1?Q?P2gAIC21R81+BCpoBV8EsfwC1QwjlEp2svI37cPh79g9dMtdSzey3oNNTY?=
 =?iso-8859-1?Q?MNBZZK8HZokMJzxfVhISDSa96GYa+s7jchj8O0aC4pWpGDlv8rAgK7CWyL?=
 =?iso-8859-1?Q?znp/1OHoaBJinsw3qq/8SoCr7MymQWxmo+JQlMlNIR9xg/3giOinPT8hkG?=
 =?iso-8859-1?Q?3dtiSSIZJP78Tr7QNDg2QbW/ooMZHxaf0Hjt8Jl+BAPvHTOf/mh9giWJro?=
 =?iso-8859-1?Q?ZTDziVo6rYh9Ag06FtaVwi1++O7OaYaw8ejzTyD164z6LgVlL4/kZ0CSUF?=
 =?iso-8859-1?Q?B1TqrS4jMmed/3Yb5xgfWhpq7UOZQVXWyjeoB6L7Gwi+cKFmHnTgEFLCKJ?=
 =?iso-8859-1?Q?NLDgWEKyMm/yNGt9cOZnsc0rDF4erLiCXOgHWL4ehubSZoZmVg4msJuBGa?=
 =?iso-8859-1?Q?LN0ZaH5/Uzko97Kqc6ilg1ngkOq9RcE5QHJddlTb7oGjgp7C3hONnQ/1kQ?=
 =?iso-8859-1?Q?1BhAyrNrd/5YAdQF9GjH4hMXYuZaf4DuwY5U5dhW01X81dxpD8GaQufyQB?=
 =?iso-8859-1?Q?2jdAONtFPFGR7w+oFw9nrljtexoDuUx9U8jXNopG1MMtlQtgenU8/nq7tt?=
 =?iso-8859-1?Q?GwjdQIBkfZ+A4LEMo3le3DPvY+ZqveTqLC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9205df0c-ea0e-4059-0364-08dd0de56637
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 06:41:47.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJbDDMUzBOdo+aF7Lj8195MrhiwlAA5hpouztVhB9NCDTzNbbs2BN2uH646T13posodYD7WCDq7tNfWT7ePXsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8424
X-OriginatorOrg: intel.com

On Tue, Nov 26, 2024 at 08:47:42AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2024-11-21 at 19:57 +0800, Yan Zhao wrote:
> >  
> > +static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> > +{
> 
> I wonder if an mmu write lock assert here would be excessive.
Hmm, I didn't do it because all current callers already assert on that.

But asserting on that would be safer if the function itself doesn't take a lock
or a counter.


> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);
> > +}
> > +
> > +static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > +		kvm_clear_request(KVM_REQ_NO_VCPU_ENTER_INPROGRESS, vcpu);
> > +}
> > +
> 

