Return-Path: <kvm+bounces-69292-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDYNM6U8eWlSwAEAu9opvQ
	(envelope-from <kvm+bounces-69292-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 23:31:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDBA9B11F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 23:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A4BB302E794
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 22:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C032877D4;
	Tue, 27 Jan 2026 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qw4OS0Ug"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191751373;
	Tue, 27 Jan 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769553045; cv=fail; b=AD1bXGKgz9dcISbMTWuBO+Ml5jYvILgCqaH+lujuEHFGGi+MfWLAr0Dv8ASsBaUnh7F7RsuWHBgN7rkoJz/pEYNDF2szG1lRVtogzxcqTEUWuoRiqlYNbEhmC8B7ZogqjkWWt/QnpJie8G2rCm83ZnWWW+QWV77gdMVa90dkfSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769553045; c=relaxed/simple;
	bh=z401oJEK05IMaMJQzlq6FHaR7larvafViq/tJJdWvgg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s8egSvOtDwBoVZ2LEQyWFmPXtElEw7ipHA1fZFkxz59Sk2ZyUwnBf0KVa3SINKNXz3q5zicGGBEaKnPEDEFqqP816mb42n7DXrrHSLGiawPZjFbE83+VZuZRrOqjlzT7PrIYh+/lwPCUDOohuSl8TvWBxTfgQN72wpoeTliWWSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qw4OS0Ug; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769553043; x=1801089043;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=z401oJEK05IMaMJQzlq6FHaR7larvafViq/tJJdWvgg=;
  b=Qw4OS0Ug6Kjl4S4jrwUCd9qy6q2NLkrHHKDexCmmh5+d5ubn+7K4rXHc
   wr4tfaTl0uqGngoWedDQIDu2zZhrMZUMnPF0WIUMuWBT9Tws43CVjIqKu
   yfR+E/aZUMUzbnZ7Zvf+yaEpIQxuJSZL+rrDpfiRrt1IRTduPu+o48cNz
   ib6/e4PUOam21jC3wlYY+MuywUHPkGsjm4ZYygXKFk9TLiPCiaY+BAhvw
   PjTfW56uzXGwn+jiT+RNtA+Vd6NpB4HCrKgTHlRRhHbYOojqqBBYkVwJl
   c6g7oyYhTWKKlpyOm3pbVLD6vIuEArh0zdMy56/m/8w1K9UirRM2Fu0bd
   g==;
X-CSE-ConnectionGUID: 1v8ZluHSQjmGIQrR5XbWzg==
X-CSE-MsgGUID: sLHej6s2T6OJiCGuv+Vz0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="88338647"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="88338647"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 14:30:42 -0800
X-CSE-ConnectionGUID: 9q6StUR3T1uGuKxV0lVFyA==
X-CSE-MsgGUID: MLqvsZZWQumpT/EBrc7lpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="231051448"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 14:30:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 14:30:41 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 14:30:41 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 14:30:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSWD0mnR+6P3Y43i7HmfOxLo3hYP6jfeDxfjGhviw6MtCRWXZiQFi9zm68XrEkVlgVXgDruINR8Pw15VR38C78BkyqRXt4KQimkGzA2Trm4BMZ8ilRmybRHq54kvMDza74MrOgtcWHlppDtOaFZ8cpDrNVKl+mCbYpx85FrvRFCg6QUdgdO63fKlJmShlZu6n0QUEQHzuwMYgRhFbaYX/XnQ0zKb+xODs5C06kujBgHw4qkQWAdlGTsxjekSGFUnoE8gkYWnK4Niv0JCaq/2Ag7rjr0SiwVlEC7MX5sg4/6geeuL1xjF1lslwcpR8Kj3vxb4NpworcGeVUbsHoVyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0S3ku2mX/JaTJmERTkipVKB0vzzja4A22avkseS5Vs=;
 b=wQdtEnKgTqyTlAdPAuquvUWTXHPqkCBmTgrM/jkbAVM7VVAONY/6qFuxUt/fWZPQECfvIJcbxj8dwGgYp3TS1JYM/1fVqwO3okd9waigXVsIGxKtRC2oQcJpUW1L9rNodGbPn/2LkU0xfuo7TupQ45ZpA9xGEeEHG35czpPUR5VsqbVj7OcXLxYPvqngCtzmPSBR+r/ztEWVP6LxnSPtumtAEw0HWYkzinPWJSN7VxDwqE6T/muPkDl0c00FkldwtnL1+9inXAUjz+xA6T0DICFD1M697KIUghgVAw5HKZBg/HwrTZ+aKwNS74uC3A2Qqd3zzFRhmItE2n4i9YfRRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN2PR11MB4742.namprd11.prod.outlook.com (2603:10b6:208:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 22:30:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 22:30:32 +0000
Date: Tue, 27 Jan 2026 14:30:29 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aXk8hRtv6ATEjW8A@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
X-ClientProxiedBy: SJ0PR05CA0209.namprd05.prod.outlook.com
 (2603:10b6:a03:330::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN2PR11MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d41e587-2eb3-46f9-a621-08de5df3aea6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NLkoHVMK0rZYArBEZw7pmsdbFqbjb6Nwlc1FPBxzLLu/Mv4ZKuiDlxBiNmqF?=
 =?us-ascii?Q?hNhOfnk/M/2w/+mP1UvWs1KGRpzpwYUmecFlw4Pws+i/f6oW0ujKa0MP7U4Z?=
 =?us-ascii?Q?AUZD8MuMihe+nAwI7GCOKbyceb0vwxVykEx0usU4n+/e30iFIMWoRFFJvbpl?=
 =?us-ascii?Q?sLQlYTXgXcE8R810ABlpkpKEpssLHeFE/QX098L8v1wmvZWrfljF7UuvwAJd?=
 =?us-ascii?Q?kG34tSLnnUaV9ik8ZChQpeJfzeKe+K3c084kVo4cq5Uh9QLxNx7oq/itdtib?=
 =?us-ascii?Q?r8mmatq+b7r06jLEvlp8TxT41gP01j9GPR2bupM3clf8X/COISORTO1Oajqy?=
 =?us-ascii?Q?VRVmJZkjKBXPLN1mOmMJlqmUpMHxQ6B3FXDPe4DpSuNRjEtf5J2h2p+vxAbm?=
 =?us-ascii?Q?M4Xr3uibLScqY241uWjJ/1kGVTCVN+tozvttvrsG8TUPinZpjMILTAfTVXki?=
 =?us-ascii?Q?jp8xjvxxQMSo888rsEq9qmkW5JGDiz4qiU9b+xvqxTYTbxJP+UYsXCPLbHDG?=
 =?us-ascii?Q?EEI3PbQVfpjXIxXm/lS1mKdlr6vSrZNoJ/ElYaClqETPlDonTmzBVwxy8M73?=
 =?us-ascii?Q?+T7caRjCrfqgGUWUvd2IuPo8aDlgwz2s4z0vykscQEqdZvl4mGY0czvbcprL?=
 =?us-ascii?Q?JW7uB/Ib8lebTHMYoj4drUJUaOzPHWSfgiiKSyHDr/SOvJ3EkrWMw8kWO+0e?=
 =?us-ascii?Q?8ozOwSuSzPqfQ628dKBMqyRnGNapGTv5Iw2rRfcjzEOtd56OhKRIMm//hdh8?=
 =?us-ascii?Q?zI+CM7VCgVDPbr0p45JWwZHZKma0j6mrAJnR/sUxtr5xJP/uoLkwuUPunUsa?=
 =?us-ascii?Q?iTMSyRRaXj4zNVxQy7tQ/pHmza5r5Peijf8c91H6RD1XwBsHQTjWqsrMaPZJ?=
 =?us-ascii?Q?RTNksMscCKXEaRb5zmnhoMf7q71A2PF4X39T2pyE5Nimje4VkqQvXjxMATIb?=
 =?us-ascii?Q?JMLDF/f3cYSuWK0jP2uq2HaN3Jv5jCNUCs39n8h10GvPKW7sC7cDUXUy/fJe?=
 =?us-ascii?Q?lPdYMslukSuDTHoeHmogv5CecTlL3dHbmL/+c6mhuzfrRb1XRd9EFwGiUwMg?=
 =?us-ascii?Q?QTnYIt32BsbDOMrcf+xpcHvlx+aabrt9h4b203zS6vIvn0fn+WN6LOVPVO2/?=
 =?us-ascii?Q?0GBVcib41jiWPBsTu1qHhKH6bNOQKVMZxliviXDF3ye6VUY7qcvMHCoo4wCd?=
 =?us-ascii?Q?4Wl6aE7ezBwCicJNB41OH3YzbxbW1q3wr1nt9qNQiC4Ff9akgQTq63L9/kOz?=
 =?us-ascii?Q?sAtUPntReN13WgXhFhjbt9JYav/Ojzm4WvCWDRR5vuJuZjA+aBsSErdeW8Ir?=
 =?us-ascii?Q?bf2VJ/fK/0+6AzRcqJRWHqrjO3V/sk3Shg22xdJT5O6PJUyRtVTwhrJhpdK3?=
 =?us-ascii?Q?LyVy6Z2ALY76W3ZUZhc232yAuOPJbgeiBaHPLwy0x5hckh8H6AqRmhgTpbLs?=
 =?us-ascii?Q?m8Yzc0s5EGJknOs8kk7LXHDTgb+/APKU8LDZPSRvUz9QfzYeyJerKWRvKM7N?=
 =?us-ascii?Q?i4oCq2OTXmkAZ/c1ofxjQYAZf1TQz0UAxBuK5J7i4o4FZaJ93BLAITt72SoP?=
 =?us-ascii?Q?D1kHSFA0xHYG1TQA5BU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oBkD5RaB9hNPu2tT8fgMAvefRhV14ElAzs2DrKAJrTNpShQRRjWZYL/QKGwX?=
 =?us-ascii?Q?6o1Gz/FOKq2+ulhrU1oczpXqTtyIupK7q5Hvs6IPDqAb7cS+t0IjHQEOGgZi?=
 =?us-ascii?Q?hMFsBI9KUBn71T1VCquOsh3oRvEIy9hhrMV7Gy/EGxgqfYn4ltFX0MSuey0j?=
 =?us-ascii?Q?yZF5g4Wx9dKzozYyVqsKI073FUbpBR0tMWxdLhZFozOvBAGIABiKxUGNkTUB?=
 =?us-ascii?Q?iyeIBRT4RkD02nHt/h955UQoqhpCrgZe3mzxOUK8nmyBxdFgrpmi0dZvQNH4?=
 =?us-ascii?Q?wuMoGzNpRBxFcfII93LtTmQIgjPftvEyL2BuDy+Kah751VHo4NdM9vv47zcJ?=
 =?us-ascii?Q?6/yi2nW+TptzjUX7lhg74MEw2c8HZ1tvAOn6OBD78Z4Zm4iZJNNqIZqhaNTs?=
 =?us-ascii?Q?ZfDH5VZfdaL7cSoa+Qs4UQxqrJlAwBpbbcC9c7jRYkz/Tz2hrtMwRLREOq7V?=
 =?us-ascii?Q?pn12eQ+v+1V3h35FrrQnCeU+JZkO8LMN0vbdw7LsjWUjksTqLMoJLDTEV/qH?=
 =?us-ascii?Q?S3/I04fBNvGfBMZl9H9xF2bgc78OjADieeBpJXSZ+tLKjKIE+jtJxslex7VL?=
 =?us-ascii?Q?3VO+NXGn8TsTio1xulNA3cxOb6hIsfklsGgE4H3Vbg+i+Wf5aOwgMVZgjAic?=
 =?us-ascii?Q?XH0wayCyyMJd+f8DRKujwIUZx4/U5IN060jQy9CKjwYVyIeLv55ZlKue0P5g?=
 =?us-ascii?Q?ItbilJArnUom9IblGj3ZcUvVGcWUq0MGguSLiOoiV5p274tbfQso84tVKhV5?=
 =?us-ascii?Q?86/YqfGwz0DbD59X2DzBRwNIVGv5Q1pTbxhP4lS6UXVOQPAlFPelmb9Vvw5M?=
 =?us-ascii?Q?br002Fm2Sjrcxcg75z+R7RFNdCh2S+RzVrBEfKXzFHjiTdzOKZS+Cb7GamUp?=
 =?us-ascii?Q?d9hI11PDtwAHQ8XR+zsIDfu+iSWEOAnK/DpCX/OCUDFs7nROCYKi+POtCSA1?=
 =?us-ascii?Q?fU1RCBkUENZBYcEwv8oGP+vuVgoGt6Izrtazyi93+enRHcThj62QvV3K4P8K?=
 =?us-ascii?Q?LY8SzZ1FuhwTn4azOXI9PuK0SLj6woEJ5ywSCdTLrf9bM8Yk6IIXeZEvJhbf?=
 =?us-ascii?Q?iLpXHE3kVVsTm3FppYCfPJQDabxYjDVv0+Sw6W/uaYuioS42N8O6lpEGDok/?=
 =?us-ascii?Q?ZGAnlSQ6HaqWw1nYEG8GBo/Xms3tpEBi4kVhXUz51Bqpjo08vfRWQIa3pbCQ?=
 =?us-ascii?Q?aRXASNO1sV109nGOfsxtkTJa3MiAr19C4TGwN2N9Vg9+8ndwo6Hjt+qSW6CG?=
 =?us-ascii?Q?xZNhWXnM7hUMY3+dixTcE50Nk1kd2V9P3ZX6+SOAgYWvcSUKosNB47GJKXjW?=
 =?us-ascii?Q?h99YC8EI2mDx23Q9ddpTvysS4wusLTmo3Kpar3svu80EEnNBZoQLtIsJLkAW?=
 =?us-ascii?Q?yAh7UyRxcdczvTfb3IVqYbHyiBADlrSeAzgwyjsEymUZOiklEJL8SUN+Eqoy?=
 =?us-ascii?Q?HmVgN9o0f30C8Srr48/Fg+PxPItCHDGzxTyRVNz8a3fUDNroUyVL5ut+l4Wu?=
 =?us-ascii?Q?oLAypYRQ5R1Yy144g/GDAiasUenhB/PQmV6gWDlAQNI7Kjb2/xwYI+LQCAya?=
 =?us-ascii?Q?HebACZmBe9ft5+RRieVJKYUle5Kp8LKCh8rR3TDVDuFGvQD3SPnniAgFC1fJ?=
 =?us-ascii?Q?KZt6n8jnkh1/vtavDsHiOhxAClHSKOhdiOsiqBujl3jOhXgsOF0dP5PsjE95?=
 =?us-ascii?Q?u8pW/+/XjVA2opw5HOfpw4R62FkoLHy6acOgL2OwajREve5jXtPYmTJCF6fg?=
 =?us-ascii?Q?VTbBljo/fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d41e587-2eb3-46f9-a621-08de5df3aea6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 22:30:32.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JhetUb2SOdMpXvtu+2KMsgXCFIMTqll+SUGAfaXmKsqhUD80LQmdd64jtpo8UotDBNrt77eAGnJV8jj50lMRTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4742
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69292-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[43];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 3EDBA9B11F
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
> @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
>  		state->cur_rmid = rmid;
>  		wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
>  	}
> +
> +	if (static_branch_likely(&rdt_plza_enable_key)) {
> +		tmp = READ_ONCE(tsk->plza);
> +		if (tmp)
> +			plza = tmp;
> +
> +		if (plza != state->cur_plza) {
> +			state->cur_plza = plza;
> +			wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
> +			      RMID_EN | state->plza_rmid,
> +			      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);
> +		}
> +	}
> +

Babu,

This addition to the context switch code surprised me. After your talk
at LPC I had imagined that PLZA would be a single global setting so that
every syscall/page-fault/interrupt would run with a different CLOSID
(presumably one configured with more cache and memory bandwidth).

But this patch series looks like things are more flexible with the
ability to set different values (of RMID as well as CLOSID) per group.

It looks like it is possible to have some resctrl group with very
limited resources just bump up a bit when in ring0, while other
groups may get some different amount.

The additions for plza to the Documentation aren't helping me
understand how users will apply this.

Do you have some more examples?

-Tony

