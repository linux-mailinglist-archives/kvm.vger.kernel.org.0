Return-Path: <kvm+bounces-46761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8899AB951A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE11D9E1F28
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 04:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66E022F746;
	Fri, 16 May 2025 04:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aV75NRJr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C4D440C;
	Fri, 16 May 2025 04:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747368216; cv=fail; b=Jms4yUKOn5zSS+mju0SLzYCpK1BBPJHWVRX8noUXZScy7SyMYLJ3YXdBUS+evutWis4qDf5PMsr95bUDiOBan6y4k1T/tra5pnqlu2HJvGC3e33AxqGAOgABUuOMBc1qrhsVG+R4ADvLbQf7ZOBFKO4IVSSMXAt4iOAbYus1MJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747368216; c=relaxed/simple;
	bh=lzODdpDrMzqceFWxQPc7A9Q8LOeLVAUVhDbT4tus5fA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mSszy17AEf8xi9aqEKZm5L9NcHdnW9f9LTjGlDToRXRvGKmzi20Rlw1L4vzDpFg9xWIxRo3yQReL+DtFc/lMj1PdwixLIRmQBJENtXFBPeXlqDRg9/yyadefQ1pKeTrE6MXP3RaO0bTDCOC8Ejytx+iv5IbOJoDqvRM12LS+Wk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aV75NRJr; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747368214; x=1778904214;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lzODdpDrMzqceFWxQPc7A9Q8LOeLVAUVhDbT4tus5fA=;
  b=aV75NRJrPFYoNURKCVYr/V9KBQ6s+XWF9m3BsYFYuQFEQjkPV4/1t9GS
   636yteStMvVrtXwbNCjcHSqREgvZl859YIUxc7sxxLjcD1m1Bn3GtovRY
   Bf+cD2rmj4aIA2o3h2WdoDhEHx0GNAwtvyKTu/7ZtAzwdn5VaEV7qpps5
   UIBqDghtoIgMKl+ajiSR6d4x9IaJMnf7209QiRRzbLX+txntWFEjpvvJH
   hWgSBRUDO6BRnoa6cGPlNZn92nFuZh2gAms/ggrM3XUl60qBHEyhHbbuO
   DJEKrpxaU+tnWQUhxl92iyA34q7/M0GWamjb7mXbPN04BJONEKDQSZMU7
   Q==;
X-CSE-ConnectionGUID: nFk8krb3T9OVweX+dl9vdg==
X-CSE-MsgGUID: itimsI9ZT166+WqDmeBd+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49024950"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49024950"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:03:33 -0700
X-CSE-ConnectionGUID: tXTBmqj2QzOX0sO1VSjR+w==
X-CSE-MsgGUID: qml4ywlWRmmsoipWouOg0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="139453912"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:03:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 21:03:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 21:03:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 21:03:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9MRDzvOQCcHxVH8XlKO0MnSgThjJekUlvBlDG7D/3vGHqUzXeci2g3TCKyFFlQ9qQrHDAty7wgmvW6hmxMC4i4UR/5P0foAz0Gg+r4xM6pjs1du9NT6UgcNoMQrW9YjRbvp8QkT9mtl71YfYnn6WwBqeuHD0d7vlYk//Clv0RFNDiB+XCBqzwE8eF/HSvJX+/hhkYH2gyMLI/M7upPh1sVwlHQENNjhApLpYr/ZIGg3RbrBfVyLAMaFpFzfSyzqKj5DzD6gzKQrZ2sf2ZFJiGQMITp3hDoZIqW4kHMx+VvVkVaj+uQatthuvH1kmEBb7DOoOfmqADW7sauRwXdXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SN5A+OtWesqNq0D6Orxq/xmzbbkYcSeKnt/YBsXSFNM=;
 b=V/NQRjQasFUSdwBdrGBKiI+DPF5KEozTKDjzQnvL8TYH7xr01xIBVGcoh+JEz9n6C8RgIH+YlS7fByo4JJxQ+Yi9+l1okXSzPk7YHUZMVacs1DHAcW8JGmnyZYbdYv7EtmEPl6NOcktxH/bnj/UVLLHLe6al5L+8ffbcahoNtNh+ug+m9MnYg92k4gnQvhc3Njix4IxNovirvhKeZFTYPwOX6YT5tOOtnOKreT7G0KmScL6ldJ+RmlqpR/Sh5SAYQkuf8r1T4OUbN+KJZbjJZMUJmsF7oAOkRffYizr4RkwT+nnSkShh82FWOicoMNK8wluo31+mFmCMbt5Z8BGJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB7023.namprd11.prod.outlook.com (2603:10b6:510:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Fri, 16 May
 2025 04:03:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 04:03:29 +0000
Date: Fri, 16 May 2025 12:01:19 +0800
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
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Message-ID: <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030634.369-1-yan.y.zhao@intel.com>
 <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
X-ClientProxiedBy: SG3P274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 192b985e-7dfc-43ee-c2dc-08dd942e9dc8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pD0FEed0QTXellz34OKt9zbWaqu4+fRlFHYO5PRKnkGMBaCTIR+N+VBMNweP?=
 =?us-ascii?Q?lJ7Fk49saUYCkWISWmkrPaobfDjJcWR81MdaLt7Dz+ZzAfR6JKQ+/h+bgaUD?=
 =?us-ascii?Q?9jXOW/9Uhv/6AWphUjntaZip3Qc3I8Y38s3IjjooqlxF/DD2Ll1A/9+UTYK8?=
 =?us-ascii?Q?yvSOrWEVD/kcgAwr1DLdK/L5ExjQIpqHbNyezRj1HKr9JnrTUKqpSxZGfDG4?=
 =?us-ascii?Q?tDyIT5knjD4QSs/dnIOBrzRhkQiRFhwE9QtPs1VgBU8ggF0vExAV1tBtV7cP?=
 =?us-ascii?Q?b3r5pNNii0Yhy9/0CEvE1LU2dzn0VEOL3iAyYaRqpe1sum09wN9iT+Vi6DIL?=
 =?us-ascii?Q?rbfI9i56LquNmGFeSkkvFxWQQQ6935kiwPbQgVefkpX9k3dXDv47ozwp1Sby?=
 =?us-ascii?Q?fSQX3W/BDzxBJ4WTVDygEtQogA6ZkCrWfiZr+yDQy1OVOXKlARFgtvhLYfQc?=
 =?us-ascii?Q?IfTzoRdKpHOQp6fWAbKmombWrBVeMP45oTsouTEGd9Dao/j/Xr7tFrTnKQJf?=
 =?us-ascii?Q?1BIHmLBK3H3sggUqRg1Z2WsDoB8bNg++gj1lz2nplzdnwGqhezXN2d0WIZL8?=
 =?us-ascii?Q?joZhnf5gyXphBQWyuUcmx226kMg+gSg+54z0tJqfH/jNQF39pZvhhApJMXPN?=
 =?us-ascii?Q?JVAfU9QlpuvhYt/JnlUfMOhlCmneQ6iVgbssgFX/IKO8BbL5iKzejObE5qCm?=
 =?us-ascii?Q?BjdjG+62Wa08hnch2oM2A4qc0aRFTnror6Z+PeEyiS3a0qBFYnLa1K80oshs?=
 =?us-ascii?Q?jf2nRHxZcyOdFY+3OfmjGyL+70MhyN055aFU4uh1f8ewdMTBYtjisL13vAeL?=
 =?us-ascii?Q?Zw4PNfSZ5NKvtTPYS+758khQ2HzDqwGnesY+qYXXKMvg4XzrHOIAXmNoVlik?=
 =?us-ascii?Q?eArsXgizI+wfd+/jrMaRn/uzbHfU1AZP+HCYH9QI8FMVHc+qof1GaIahNcGA?=
 =?us-ascii?Q?MaGVz6LoMwoyVRORLFpmUIJX/jpkfTJk715+zdT9MLIO3PNws9FuQ6toCz74?=
 =?us-ascii?Q?fTjxaKRM2CQx4VHm/LQEYDyWJqEXk6cNYoqg9hsPgYH+ZfLO9n0m+Wuh7A9t?=
 =?us-ascii?Q?u3C3y3VlfHklrEbHaOBmT9gCgCABHrH2yJK6BkyPoF0FokHgIlWaou2QsEbw?=
 =?us-ascii?Q?0jjAN3oobgTMvjaode7lS+daO132fud9/BSZNo1fYS8pVK30tJxBba7/1STS?=
 =?us-ascii?Q?f2e/XQ1FJPFWiVeHY1r1UyZk+LniBRLroYB8ig5eti4E6lP61Sg+20lJUA3X?=
 =?us-ascii?Q?1nKfgcf5iWSA66MPHgwd0RU+v2prRJL18iIacdjMINl3bsW82aU3Dx9tlqOE?=
 =?us-ascii?Q?bWw0VLOc3Y+9PNOkkGPw8NP6uhK4ywJo6+PrWLFO69SdlNdNy+wIBR1K7Qut?=
 =?us-ascii?Q?MgFD1SNu4L5NmHmCU1q0wao+vm/hDVposJwtofJMGoUUKLkNgA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PYQGkk0w5V+SWdXpLEUCZhandSngJZKQtO/xqByPyeaFexGAbEX30SKK8H1O?=
 =?us-ascii?Q?PTYdd8uarFEi0qLGu3L7+sewPgtORdZniooRkO4A8eHluJVaqM66HmOor7hl?=
 =?us-ascii?Q?ANCxQLiB98OQ7HK8COlHcC2WbLUt767xIMzXL5JwKngj9B/+aIhqvdTbRgaO?=
 =?us-ascii?Q?G3a9nV/OTNVvT2PLxs4vjIFDtLoSuDo5vTwkRPC20jYR6Z6fhemQ6H23R7BV?=
 =?us-ascii?Q?54ieYriQgdTFN4HTh3kWWXr/1q7htGRPMyZxOc0BiyE3ZLxgEsWFWkpW7b+V?=
 =?us-ascii?Q?aWb+XclPYM79NjDin2jOlT3b30BSUdSWbA3siGpsNoHo2Kj7cs+WPb9RIVl+?=
 =?us-ascii?Q?391V84yySkT7Rmz5h2Ju+gy1GOqMmiNnhjXANKrk6lQ6mqdWhgXsB988/yir?=
 =?us-ascii?Q?+TE+iBs9YwwW0Yx8xqs9Uv2uhNk1b5o912NVvtJcFbD0X9cldkpJrX5+2YcJ?=
 =?us-ascii?Q?OsOg74fE6qpiYSqc8e6UO1om5lwPCKb1+r5XwfJ6M6Xvy4DQLr759g7iHvEK?=
 =?us-ascii?Q?LfiP5wsjGoOUeDmbPawTgAjONwf6x+w5+uRIjZ/HjsbKmPKiUUZOfdMpIwxQ?=
 =?us-ascii?Q?6BPoa56+SjEGqZt0jw7hI07UwRJqFkN9ZshhnBfsZZ4yRbZnOrGLNBwxCy1u?=
 =?us-ascii?Q?64xoaePU4zqwJHqY1kUK8/CmYNeTI4EP7OVaBcXgOuA06lczbCo/CW8c2geC?=
 =?us-ascii?Q?vHPZxMfB437ydQwbImezQsAlTyb9LGF6kmK3XADtP1H1Ks7js2bnvJ6ykCOT?=
 =?us-ascii?Q?A52QdqxERkWeI1PL8kKHjrrqjFyXTWHiF+7oriHk78uv56C4yj94Lcc7TXQA?=
 =?us-ascii?Q?zwXNsdapGHha9DbE7Er3II2MV31UVqnbZh0K9c2H4XUlZspiArppN1IxHOe3?=
 =?us-ascii?Q?crnElVCMAyfef96huYCWXlj3Dw8SN+xoVaQqpXRImuAWKeOiKoKkDvw/yxvD?=
 =?us-ascii?Q?ScUmgt1R0OL348NPSjX7kzP3T1KQe9iizdUWJi5ol1x3K6jk8J0XOsUPtW7g?=
 =?us-ascii?Q?AVRWBN/ClVSbURTjFvvNb6MCvLeN9hagCwWu54pGhoMQlplL5Wi75cmDfecf?=
 =?us-ascii?Q?b9dWvoF9wgmt5INzCVvNgKdcRYBbh6ztYCcuWLiLu7FHzLOHtz5uh7awrmB1?=
 =?us-ascii?Q?T7OK6VNOKXLxZBIC08VCQJ7cMYnCuQuqTxE6geE9y9Wtc2LmQgp0YRT3+zln?=
 =?us-ascii?Q?tNfUdob1OcpIOfjagJ+cb+54tBVQ2Weyj+qJsH9HahFnZAJEXpXLjstU3OWs?=
 =?us-ascii?Q?2VX0ZLUrQBViTFValWettaKBv7MSH4qiiy+12LPUabOJbkZLzFSQNXoOpgpi?=
 =?us-ascii?Q?CnhPlJ/qkKgZ4XDAPwRH1CKkN9ZCT3tc9AI2st2E/aQAcdtTVlDXm57pCc/J?=
 =?us-ascii?Q?8hgoyPCreVsfC4Oj/oWft6r1JHGjvyxaO1tLQsi7bruhhJpUKI4FbUNLLURk?=
 =?us-ascii?Q?j72MnaX9BQtuZCiJvefVl+0PGehpQn2TkqksUe++moVAx6lFcKMI4v7p3S+Z?=
 =?us-ascii?Q?cDUniwW2bVFls0FxsOsi1DdVTNMeQygogCs15a5B/RsaSoLrOdzj8f2oHjTN?=
 =?us-ascii?Q?pWue05WWJ5zjfCxK8i7Mu48Sl5pF3td4NiyeldmVf5XE98OeGmnKlzP4FH5v?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 192b985e-7dfc-43ee-c2dc-08dd942e9dc8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 04:03:29.4793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3efC/Kf2pA8fhFT5aia2acD2sZ4XYml59udSQpAOsXKBrAD7L9p3sLkx3o+78UvqOLYuhRgLcYqSnCF3NQyvVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7023
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 04:15:14AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:06 +0800, Yan Zhao wrote:
> > From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
> > 
> > Disallow page merging (huge page adjustment) for mirror root by leveraging
> > the disallowed_hugepage_adjust().
> > 
> > [Yan: Passing is_mirror to disallowed_hugepage_adjust()]
> > 
> > Signed-off-by: Edgecombe, Rick P <rick.p.edgecombe@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 6 +++---
> >  arch/x86/kvm/mmu/mmu_internal.h | 2 +-
> >  arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 7 ++++---
> >  4 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a284dce227a0..b923deeeb62e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3326,13 +3326,13 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	fault->pfn &= ~mask;
> >  }
> >  
> > -void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level)
> > +void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level, bool is_mirror)
> >  {
> >  	if (cur_level > PG_LEVEL_4K &&
> >  	    cur_level == fault->goal_level &&
> >  	    is_shadow_present_pte(spte) &&
> >  	    !is_large_pte(spte) &&
> > -	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
> > +	    (spte_to_child_sp(spte)->nx_huge_page_disallowed || is_mirror)) {
> >  		/*
> >  		 * A small SPTE exists for this pfn, but FNAME(fetch),
> >  		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
> > @@ -3363,7 +3363,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  		 * large page, as the leaf could be executable.
> >  		 */
> >  		if (fault->nx_huge_page_workaround_enabled)
> > -			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
> > +			disallowed_hugepage_adjust(fault, *it.sptep, it.level, false);
> >  
> >  		base_gfn = gfn_round_for_level(fault->gfn, it.level);
> >  		if (it.level == fault->goal_level)
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index db8f33e4de62..1c1764f46e66 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  int kvm_mmu_max_mapping_level(struct kvm *kvm,
> >  			      const struct kvm_memory_slot *slot, gfn_t gfn);
> >  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> > -void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
> > +void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level, bool is_mirror);
> >  
> >  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> >  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 68e323568e95..1559182038e3 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -717,7 +717,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  		 * large page, as the leaf could be executable.
> >  		 */
> >  		if (fault->nx_huge_page_workaround_enabled)
> > -			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
> > +			disallowed_hugepage_adjust(fault, *it.sptep, it.level, false);
> >  
> >  		base_gfn = gfn_round_for_level(fault->gfn, it.level);
> >  		if (it.level == fault->goal_level)
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 405874f4d088..8ee01277cc07 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1244,6 +1244,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	struct tdp_iter iter;
> >  	struct kvm_mmu_page *sp;
> >  	int ret = RET_PF_RETRY;
> > +	bool is_mirror = is_mirror_sp(root);
> >  
> >  	kvm_mmu_hugepage_adjust(vcpu, fault);
> >  
> > @@ -1254,8 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
> >  		int r;
> >  
> > -		if (fault->nx_huge_page_workaround_enabled)
> > -			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
> > +		if (fault->nx_huge_page_workaround_enabled || is_mirror)
> 
> Maybe we should rename nx_huge_page_workaround_enabled to something more generic
> and do the is_mirror logic in kvm_mmu_do_page_fault() when setting it. It should
> shrink the diff and centralize the logic.
Hmm, I'm reluctant to rename nx_huge_page_workaround_enabled, because

(1) Invoking disallowed_hugepage_adjust() for mirror root is to disable page
    promotion for TDX private memory, so is only applied to TDP MMU.
(2) nx_huge_page_workaround_enabled is used specifically for nx huge pages.
    fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;

    if (fault->huge_page_disallowed)
        account_nx_huge_page(vcpu->kvm, sp,
                             fault->req_level >= it.level);
    
    sp->nx_huge_page_disallowed = fault->huge_page_disallowed.

    Affecting fault->huge_page_disallowed would impact
    sp->nx_huge_page_disallowed as well and would disable huge pages entirely.

    So, we still need to keep nx_huge_page_workaround_enabled.

If we introduce a new flag fault->disable_hugepage_adjust, and set it in
kvm_mmu_do_page_fault(), we would also need to invoke
tdp_mmu_get_root_for_fault() there as well.

Checking for mirror root for non-TDX VMs is not necessary, and the invocation of
tdp_mmu_get_root_for_fault() seems redundant with the one in kvm_tdp_mmu_map().


> > +			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level, is_mirror);
> >  
> >  		/*
> >  		 * If SPTE has been frozen by another thread, just give up and
> > @@ -1278,7 +1279,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  		 */
> >  		sp = tdp_mmu_alloc_sp(vcpu);
> >  		tdp_mmu_init_child_sp(sp, &iter);
> > -		if (is_mirror_sp(sp))
> > +		if (is_mirror)
> >  			kvm_mmu_alloc_external_spt(vcpu, sp);
> >  
> >  		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> 

