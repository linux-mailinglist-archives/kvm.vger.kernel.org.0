Return-Path: <kvm+bounces-31810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 167929C7DA0
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E96B1F221F1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F96206067;
	Wed, 13 Nov 2024 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="inNuljGg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD72309AC;
	Wed, 13 Nov 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731533166; cv=fail; b=kc8P3D83AiunIWvVN5p7Hqs7+Rt0nEzmJQlMAwY00zD+t3mnjWK2+6h3bcLJupGfFD2DmjHVSvO3jn45mbDdPJSZtJf4o0oEBDK/hkZzTXFJpGyoyiw9zUv2dkeYGsvzve2p2dG11QFvHiEnEOmFYh+ex/FaNR3+gSVdUgdZ+h4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731533166; c=relaxed/simple;
	bh=gBoUqrrmHc4RJopMlTRnOGvCy5YDCWlJYzWAdzZ3xRA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cQh2uOe7Z0mI0jeSisnF7YXq46Ma5AQVjM6dJZFRymob3UGtyZ3MkLXmP0vC/sheuVrlL+NOMFXhEAZRGyQx3kdC0ob6Q3JP7kRyjaTWsrJqJK9SwMMKIO7l7THOMo5XCKmVdiNLWqkq720DltxuMnPjglC+kG5KsgSWTtyj8Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=inNuljGg; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731533164; x=1763069164;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gBoUqrrmHc4RJopMlTRnOGvCy5YDCWlJYzWAdzZ3xRA=;
  b=inNuljGgpDprvaj/FcXw2tbe1rlD/iLBUFQAIF3dfv/WK4Lio4fOT9Qe
   cBD6BBs+b50oCTN7q4kFuRNfF34KV0a29XCsaZ5VsGyQ3N0aucBy2RDce
   qDxFlWF/bu5ujufJ8X+9I4q+d8eDy62WhWs3QItCKqcmfkiWYrFiZnDHC
   9mL7VroWTy10m8+xTjPXwlxvE+85PLJKqEMObDwFD83Nm4VCykir/R+uV
   k0rQ59YR3PwqA+CWzUVdpT8K5gV7Kf7PobHDVLAChWSBmU9Ld9/RRsJ9B
   M9lLHoSltX1xGOw8PUq507MTuKCCLmyO30XZoBGlmNRYJBbgplY1+h/MZ
   g==;
X-CSE-ConnectionGUID: fb0QUO0mQR26QkwBOcESjQ==
X-CSE-MsgGUID: 1/te5EiER0eixaX7KXuxLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="19052937"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="19052937"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:26:03 -0800
X-CSE-ConnectionGUID: O2OEtBDRR0GHcA4QEKJtFQ==
X-CSE-MsgGUID: AqsEZrP2T5Sw0EpNcctsZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="111306371"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 13:26:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 13:26:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 13:26:02 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 13:26:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ki/wybEKhGeOSlTQmAl3feFSlBOPnZYJtBmpoeE1Z02sNHUwRA9X1y7yqj9ryPVMKax+vk5gAgCc66pfN9gJGchwTk0KCsbTLlEu7Zae9BqtKU8I2x/b869uwCBYvV6NUI3whbllkXUCcasbYXkeKX/l8tPgQBDfLn7cKtbHb3dkDzQE2oT+86yDIq/XhlUElwu7JBJLB3LwBDcCA0qDSCvsYqHkmlLfnIp0EYb9RSkZ+IyWu7dG1D/tDx704mQ5/MCQClgoTZMtAX3XEyA/0kxf3pINfCcCt73WduS/LXJqwrzBjokUXI5Q6nYtEcChhkokcZxz/nRtkFFLt86ixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apIJKbhZzlMz/fmRInIsVEPUAd7kUO5va6fiuKTqNYg=;
 b=o1AObwmMQx/7zbhXKkuE39O9md7Ri1bazTy0n1ULiygWit+H2Jv10oTP8bBAv538MDliVL0ZZPNuUrAb1M52f2+yGR1iIxTH7i9wxk3ImA8gMNvMVneTs9I+fFHcNY3chyLDdk+Pg7QGsBL5agbROAiWU1gYodM52lQssSR1gGZWCbmupZOEM8Cc+eTjOjpsnadh5ebW6ZpZMY2oj6NU1Dg3VONTNNc/67bk+edBWQ5TknGNRH7Fr5srvre3deLqNpB0qqypAA5yd7S69rVsU7PzR56K1NFsjJAy2IZcpL8jgGws8zvNLSwShjiIh586YvfgHiRRKxFweiKsii8qag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SJ0PR11MB6694.namprd11.prod.outlook.com (2603:10b6:a03:44d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 21:25:59 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 21:25:59 +0000
Message-ID: <94d0ded0-0291-4a1b-ba8f-d0e5484447da@intel.com>
Date: Thu, 14 Nov 2024 10:25:52 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <Xiaoyao.Li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|SJ0PR11MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f510742-99d1-4089-9e70-08dd0429c42f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cEcwMmxCTFo4M0liSUlxOUJOYzF3elBydjUrQXprOG9iaHBVcG9NM2UxZ1or?=
 =?utf-8?B?RkdxcGJvZzJuWU5Fa25vSW9YL2tjSlo3UjNNRUNNVUVpMmttdHpsL1FXUnZW?=
 =?utf-8?B?M0lUSzNzYlBkejYwRHIwb3k2VlhkR0lENzlDbmFDcFp3SnpNUUp4WUxFNXJY?=
 =?utf-8?B?Q1BhM1VkUVp4a08zb0xsbmpLSEhSZU9TMmV6VVJqYVlPY3V6R2U0NzNHQ2NV?=
 =?utf-8?B?bzZSS1BSQU5MR3h5MVdIR0w0WEVoSjI3cllWcWZTaGVUcGsxRnl1OGFWUDQy?=
 =?utf-8?B?eEJkTDRJQjJzM2RORitOV3hhR25HK0l0eHlXQ3J0QmZiSnVvMUVJOHlWdUtT?=
 =?utf-8?B?NWZ4eUUxVVZ0ZFh5OUc0VkU5TGpwTC9tNFFENkxOalliRDJXMVJtWkM3THVN?=
 =?utf-8?B?NDdDOHl4aFJDZk0zcm00a1hwYnJJek53cE9NMm1RYnF4eGZYaFpoNFZIMGVj?=
 =?utf-8?B?U1c5Tk4wT2txbjc2WlRzV0tJL0xLcFRpMEdIR29lTGY0ZlVGTjIwOEJLZXRa?=
 =?utf-8?B?elkwQWUzb0cyOVRlVHBBYXV2MTMyMDVhejVWMEFqc0tmdktocnhJdEtxeHMv?=
 =?utf-8?B?UGtyd2hpZVM2M2djUGQ5MnJQQkt4MzFnVGFkNkgrVFp4RENNRDBJTzJJWndX?=
 =?utf-8?B?YTkvdGNxbVlsbDQ5U0hnc3V3MkorZ2hvZGNyVTNRY1p6UmFzR0lOVmJKR1NV?=
 =?utf-8?B?K29KRTRhMnNSQU04d3IzeTVRdVB2QzQ4S2VGNHZtOUY3bTdRa0ZWU0VLY3gr?=
 =?utf-8?B?WHJSZWRqYmFOQUdLWldpZCtsaHFwbENQK0VaSGE4eHFVVmwwOXgyUk0rVG1v?=
 =?utf-8?B?b3lwbmQzUmJ5cjU5NUZoK1k3cC9taFFVSmFBQlFXT1BhZDZVdzZzNlJUUmtB?=
 =?utf-8?B?alJLeTYzUkx6cTFiT2hCOGtXZFhXRUxSOXJCSWZ3eE5tandJOGNzc0JtVHBw?=
 =?utf-8?B?WG9KUGRIcFlUeG45NHJhdW1WNFlSQ0psRklLc3VaRytNL3lkT1Z1RndiQjNE?=
 =?utf-8?B?blZmR2pZM3dRUGcrR1dpRlorQkFYY1kvQlBoa29ybEFwNHlrSG91UU51MStF?=
 =?utf-8?B?anpLdlZ5OTRubEttaG5uVEo2TkFJM2pvUlBrV2s2ZWllZEs2aWZIVXdxODJS?=
 =?utf-8?B?RmZIYXR4a2ZxT2VNMllUVG91TEEyZktueXRiN1UvWEpYTXZHL0tMclZNQy9i?=
 =?utf-8?B?Nyt4L2wvZkFkMUNzN3lOeEpzdklpTndsMEhWN0pnTXhYdmlNVkI4U0ZscWNY?=
 =?utf-8?B?d3NDREZnOXZMT1ZtdlZSM09qWFJtYkl2MXE5MDdudVVhNjBGTzhoMmd0UHFH?=
 =?utf-8?B?dkg0Q0hNN3Zvemxlekk2bUVtQkNjb016OUl5YkxxdFpEcFBqaTEvcGc4VlFV?=
 =?utf-8?B?Q2s1aGdKZHlSRUZIWVY2WVlvVjQrS3NWb2dMSWpvZHJSa2NnRVhrZ0N5R1Fz?=
 =?utf-8?B?ZWhSSTdhL29uNUwwOWNobVpoRys3cXFMSXcvb2h4WXdNR3EwVjlaRzhOTEFi?=
 =?utf-8?B?UForQkJxK0xTNWl0TFRxWVo4QkUrdDhCZEZiUGJFRVBZaXpHdFRFWENsdGFW?=
 =?utf-8?B?d0RUY0g2cnNkTW92aExBdWQrcnczbW1jLytqcjRTVm1kNy9Xckx0bmtwNFVR?=
 =?utf-8?B?cFYwbHN1QjJ2OUlpU09WdmZ6d205WXFKMExrdXJXdU1HclpjSDJ0MHpHcVho?=
 =?utf-8?B?Y2pQeVJZLzkvVEQ1WE1BYlgydmxneTZhYnBtaC9EbzFhdnNXUXhLRWZuQUV4?=
 =?utf-8?Q?v6CBOn+SQvpck7rcuMASNCMZ9ifI0QIovs97FO7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkJHRkYwdFZqVjYrQzRqL2xFTlR1SVNmeGwvTllDdnlqaGpYZ3E5S3F5NlJY?=
 =?utf-8?B?OVB0RHNiOUtZZnNRQkFXak50KzE5TkVLQ0grd1RNV0xvaE54dllZeDBrd2ZD?=
 =?utf-8?B?L29ORGtsd1l3K2U1YXd2RVlRV2N2Q1c1OUxpbVc2NDFwdkJRRGFseHh4bFcz?=
 =?utf-8?B?SmVoVkdBQ0w0ZXkzZlpQOUJ5QU1GZWdqQXpja29vcmZuSndaUUN3d251TFdw?=
 =?utf-8?B?RlRhaWxoZmFjajlGWExkdThMU0RxNHBHOTJlRkpCQlBLcngwOWY2Q3NIUk45?=
 =?utf-8?B?MHRxbFY0T3Y3WGRqMzFQV1Q1S2k3Ny9QTTVDS0FySnYwdlhyeDhGMUJXcFRm?=
 =?utf-8?B?RUF5K0ZJL3hhbUU5Y0lXRlpIQ1NHME5WM2VUd0xwaWFGaUZiTEJ4djF4ZmVK?=
 =?utf-8?B?N1NqNXd1TDhXc1hWaDJZeVJLcVdNTWtnZElyQzRNRllEd1ZtQisrcEJTcmcz?=
 =?utf-8?B?WlFkRzRvNzZOREt4MENEWm9HWmpucjBEQjlDbjN1YjFGOUFYWW9VaHRnZnZB?=
 =?utf-8?B?KzQ2YjJsaklQalNJd2h5ZkxCejBxdWtBN0pOVm1sMnh1TkRMcEdEUUN5MzY2?=
 =?utf-8?B?U2xuMWVwQzZqSjR6NkNiVkxKNU9NK05UcmU3c1JHQ1Y0cW8wajBRbmI5d25j?=
 =?utf-8?B?MC9PSDNFNHByR256RkFzYm4xY1JlQWg5WVVvWFBOdjhRa3JrSWlKRFhzYkFn?=
 =?utf-8?B?K1J1YXF5eTJJV29uR2haQ2V6cGFuZnNsazBVNDFFSzI5UDBqZjUxSVlBSnd4?=
 =?utf-8?B?U2JUOUxkaXJpTWViVlM2cmVqU0orc2NydGdldXFqbDJtNzYrOGY5SE9MWkRG?=
 =?utf-8?B?ODUraEJ2OXlZUi9Ia0tPMHFRTGI1NnBGdmFFckRBU0xvcDljYzlsL0dGZmhq?=
 =?utf-8?B?dGIyS2pkTTNzelk5YjhqSHFNblNNRVh4RHhRZzIxR0ZYeldpbHZtNHk5STJU?=
 =?utf-8?B?VTdjTlNiTFFENUJ4YWVNZlRmVmxNeHRETDFVaGJselY2RWhZcmZDY0dPeVBZ?=
 =?utf-8?B?S0dmaFNEdHljTzJINGtxSU41eTNBVlNuRDZDS25xRkZWV29reUNEUnAzcnFH?=
 =?utf-8?B?cTRnSEp4VUdWU3hIay9uWWNrSkdKZURNSkt3blJzWWFtcWFhQ2dxZlhXcDU4?=
 =?utf-8?B?YXUzWk9hM1NteWQxbE0vdURFVndCenFONUpBdGNsZkdqSW1nZ3BZSkh5bGRR?=
 =?utf-8?B?L0dpL1VjemlDSzlVcjhhZk5MV2pmRWI4d0tjb3k4VWNZNzhvTHZxTDI5b3o1?=
 =?utf-8?B?OHRRUC9DaUVubkM2NkRlM0RUMm9EMTZJRzhuL3BnTG9vNDFBNk1Pa0dhUGpS?=
 =?utf-8?B?TmVxUFA4T0dTWEZkeENsYWVlMWZDK2Zib3kxY3BxT0E5SjZqT0V2eWl2WkI2?=
 =?utf-8?B?eDg1MkZYUWNCZXhLbVc5UjdEMXlBMHBCZ090QThMb3pFUVcyQW4rMXVnR1pM?=
 =?utf-8?B?V1VxZmJqSFhTcVROY0pOejI2cnNPR0VYcENuRFJ4NlFPNzhTWFpKSEhEQjFX?=
 =?utf-8?B?ZnBTNmJ0eko2WDB6WkhKVG8xMGs2Sk5Edmd2d0MvOHQ0L1VjZlBaZmJELzNY?=
 =?utf-8?B?NE5nNkRxOGo0NmtjN280L3AyZUQyZjArdzVDcVl0VnNEK2hXY1F2SlorMWo2?=
 =?utf-8?B?QUNCWXdpZ3hrSkRkNnBHQUhtZ2VaUG9FaXJQdzhaMlkyVkphaVdnSThzRHRr?=
 =?utf-8?B?KzB0RXFxcmpKMHFleTlyazNmSU9rRmVNVVNPNEh4VUhDVmdNUCtIYUNmeDFi?=
 =?utf-8?B?K21WKy9zNjVqa3JtTzgwWk1qY3JPVTFQNERSNkh2RjVyOVhCUWtPMWxFMndY?=
 =?utf-8?B?RW9CSE5jUjMzM2VGRXgzNkFiVjFMV0w4NkFMNmFGKzNwdStHV1Y5U2ZIUkN5?=
 =?utf-8?B?ZS9JMWZJUjdEM2xFdjJRcmlUb1Buak5kOTJucHZ1TzJldWk5S00xamV0UEsy?=
 =?utf-8?B?Vnk2citOVHZxbitnZjcwLzVUWlNidXB1U3BYaE1xQURkY3VENzZERjdha0M2?=
 =?utf-8?B?L1IxemVwOThwRmlFczBsd3p0UXEwclZjb0E0aXFqckFpMERMQi9xbXQ1cmty?=
 =?utf-8?B?L3pNWmRXWTltemI0NnNnb3BKa3M0bjQreUQrMUJ1RU1BNVYwcngrdC9BUytX?=
 =?utf-8?Q?RFg8NCIS5QA5+kRhrDQkY0zIx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f510742-99d1-4089-9e70-08dd0429c42f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 21:25:58.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+HnbPNSH/lu3laPxo/4GsGq3bTcioaQ0zW+arieqXXTqV40zUMPchtUUXsO2R8WYDRFt+jWvY2vYNHOtmMjlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6694
X-OriginatorOrg: intel.com


> 
> So, yeah, I'd rather not export seamcall_ret(), but I'd rather do that
> than have a layer of abstraction that's adding little value while it
> also brings obfuscation.

Just want to provide one more information:

Peter posted a series to allow us to export one symbol _only_ for a 
particular module:

https://lore.kernel.org/lkml/20241111105430.575636482@infradead.org/

IIUC we can use that to only export __seamcall*() for KVM.

I am not sure whether this addresses the concern of "the exported symbol 
could be potentially abused by other modules like out-of-tree ones"?


