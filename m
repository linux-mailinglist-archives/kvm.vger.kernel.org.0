Return-Path: <kvm+bounces-47327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DB8AC0176
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 02:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E80B4A2FE9
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 00:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5D53398B;
	Thu, 22 May 2025 00:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+ouQYRY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2062030A;
	Thu, 22 May 2025 00:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747874576; cv=fail; b=o0SvVPZehfXm3/Jtf3yOp5nAYVubzQ9HzzNfsq7hA6151pzWt5DZtD+UmIEG9v4cDbD5Hy1zWvAK9+yjFJq5oPe8tq1CDq2kHm9rGtw11Vf03rKFxy1Ucxr/0t00vrgmVZeWXn2O95Cxu6gl9vex0YEwFLBn24Gnmeo3uGcpuLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747874576; c=relaxed/simple;
	bh=TROw8eCvH+734sfSeekdNtfy3rHSPJ34rV0E3c9gVc8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b6PZntGR69no2fcQDo4XInRd9No8gsBgCiUXyxKGmImJi53trIb0E+M6hiun6CAByPpkdXwbu8kV1smu2UmyTWRCmJ+xBfiO5JMB2yFOM4aUQFZzsK/NZgEouOupXiEWdkhczfWRWn/8d8Sd73BZSGNbOERpn56KkmuOgQnTHHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k+ouQYRY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747874574; x=1779410574;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TROw8eCvH+734sfSeekdNtfy3rHSPJ34rV0E3c9gVc8=;
  b=k+ouQYRYQMRCb0UwBQ7BffHc3tSBsFgflrkdkdYbdpEcWBMekocEZV9B
   QMpHHpkPKFazwdAV/rSRDcx0Aav7QYYR7vLJABGCADJKsu3GA0JhgJu2x
   HW7GP8UZ+io3DjXjUNWXRnc8C/WP7Kwb54jcAvWPtdwzP6qM6RtL63J0L
   ThIUIa4T+FlKfONxKNQ8HiDGB/TFXR4aWa8GixJtmZY+E+25zsoyoaMPr
   dfISl21HjVYDzmqbfQNmFL2GAQxisvC4F9awoMh3Ozm0nF9G2SDG8D0AB
   Re0N6+Hg2+SK4ejoSVXziYmXBlfY3Y0jl8jiM5HjoeGkRxLOFB7sfv37U
   Q==;
X-CSE-ConnectionGUID: HEVHkc9zRh6Hes96W1899g==
X-CSE-MsgGUID: 2YZlKlvHSo+aleIbG8LjAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="60516087"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="60516087"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:42:53 -0700
X-CSE-ConnectionGUID: OgJf+62+S/Oa/4UUobbgoQ==
X-CSE-MsgGUID: yu6E2YzaRLucravMhMm25A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="163591664"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:42:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 17:42:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 17:42:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 17:42:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtsRvZhWxaM0Mq1fdeprOqTCgc6VnxzdjELaO2LelG6gB9lRpOb2NZCeObSWV24AwxBmKaQJ6043STs8r92DRGYgU1WcPc2E3IUxUZ3Zr1uBXMs+matN2OeYdD+kRnRBz2zcM7tSFJZfM04vV9/TbjDB0wEilRaF/lJN+mEp2sOenE7H0S/u7LlHSGUDGW6jL9ghI2ftezaug8ptrhyydfUNfESixfiPUNWwCqO9t7kE8IGdI6ik/lNEq6IC2YuM6nWbndSQas3NGY3EhYPBaB9iysvKs+gK7VRv/BZZEpIdLu2OP+STiqrqKtNV1M8823pJ8jLfNFU+vzsOcYC7yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0X07kC34mvQ/2pweueGyF2/dcTYSKlWNpKmjjeRVZo=;
 b=G2qSrU+YglzISTY4qZF4xTHkRdPNnMEbPoVFb/CDIdleze8gvPmoaa4iBbiOR/mdUqh5A88sEmr7acArwWVcOXm9NO+7GC48wyE+buu2dbfUEGX+TtvYmCRZPdrSxD7LyQPOJPX92jCDhlD11uSloKOc7+bZWDyu+aBuxSBlwYIs0iVm0sh+nDwOLORPw9QTXrQ194fP6e/e7N97gcoVmzgh/R83oOY3olXvhINZtp5joW1IyITjSSB7o/+2YiGMv8KKCQ4PHk4FfsqJzirFLkvvR2bDonO2qDx5Sj598jddN62jyL4hdgUcYr+xgE3BN30DstVIaGs0QnKhSDJ/7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5051.namprd11.prod.outlook.com (2603:10b6:806:11f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.20; Thu, 22 May 2025 00:42:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 00:42:22 +0000
Date: Thu, 22 May 2025 08:40:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Message-ID: <aC5yboPeBkVKR3jo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com>
 <aCsy-m_esVjy8Pey@google.com>
 <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com>
 <aCwUO7cQkPzIe0ZA@yzhao56-desk.sh.intel.com>
 <aCyqJTSDTKt1xiKr@google.com>
 <aC0wT68EY4Ybz+wI@yzhao56-desk.sh.intel.com>
 <aC31EXLNzCVGT0EP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC31EXLNzCVGT0EP@google.com>
X-ClientProxiedBy: KU3P306CA0014.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5051:EE_
X-MS-Office365-Filtering-Correlation-Id: c1ca9865-8cc4-48b7-6c69-08dd98c983e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YIIDnBJg1pwvbHpY9jLmQfB93VfPoY7WxcnymmbNI4hZpV+dkNSE5fzGP8Oc?=
 =?us-ascii?Q?for9SCj2DSZln562sCFRoVTUGOKdUfzc9PIKfzrKqECDPng6Kl+y5jCCN55+?=
 =?us-ascii?Q?vgYuOFO6Ol3iBYGPvb+ffKXIjc+IdxYguu2fcKNOOK0Hvepr8NqNG9itFSc4?=
 =?us-ascii?Q?WxGLSVhgp/+O/qq3+qF5J+N5qigEf6Xn6W4QcNOZDblN7KVskBjhntSmSi4v?=
 =?us-ascii?Q?CoEiAmRze+DTwGWNNTP2bpTMGzmcaWb+PE8Bqlj1ZT7C8iHGkh25Apjd0f7t?=
 =?us-ascii?Q?DJn2hgqiLEG+KGqGYpq5UMHpmQ12K1PM0VdmT5C1xu/Pc89WHC4SJ6ADeU0h?=
 =?us-ascii?Q?VSmSFpaVxShN/+d57bzBoirlj/c/rlIrWW/CFf8R7eZ4ilStAXefS0e8zp2W?=
 =?us-ascii?Q?bppdl6WMW787fYQJkIeTywLpg0fkriOLQhpg88AfyrWGelOkVzsHmfGXBfhO?=
 =?us-ascii?Q?/jfX1i2o/G6+FCpTEoQwzPl8BdGyxJiixFyMzsvY/A9AgdLagM8nPzIxRnBo?=
 =?us-ascii?Q?vnWSyuLdw5F1I/7WFORnx3XEgQsHBgjk0be3W1uS/PvssXjpnFxj9qTY/aEC?=
 =?us-ascii?Q?ViMwbT2V2SPHUYaEc1xUob614uEPECA5gW5VGEgw2kPVnZzfhlM3vsTjOSkx?=
 =?us-ascii?Q?a3olduQEUuaa0J61M4CnuDUtqFT5c/dEieGLFgjIbUCutVwJdl34O89IRB+M?=
 =?us-ascii?Q?wW2zDogi8QqJD0Qp9YqoikelfPrR6hrL5uU4s2YbUqJAgaCSmxAnN+7H8+4b?=
 =?us-ascii?Q?2IY/T8HHu9ZbSIFqruU/ZAKTAIeeNwloyZBCp2IqyUSZAG6VQJCxZhDrO1xY?=
 =?us-ascii?Q?1bKEqEuFuJc/I7hfZ4QBHEvhuA4Gq3s5v6AGlnfWoLVUbZ9aXheq2KjR3Ez2?=
 =?us-ascii?Q?EFgxWmg2oEh5xUrocmcd83ibrjw36JH1XJQNG/b5ebZqI0yFzRBYVIDEwp4H?=
 =?us-ascii?Q?Mrlg16xIGh8jrChtrvdWFQPi/E4WJTsVp5V/6gnHRP7Fq/s3XHiKfkicpvVt?=
 =?us-ascii?Q?te9aAqebUi8ytY9Uyk4huj8Vie1eZN3veCVk+1IcPmx30cL5yW1zIVabUPM4?=
 =?us-ascii?Q?r2Vdu7NEjRw3EL0V0WQnpTnvGtSciQziHSgFnEsOnNiP7FoMI6VzLSS71+CG?=
 =?us-ascii?Q?ClRP2I+5ulLhgxLdXar0hnz/hHRktUsPCPfT7wr3yLdNx0xAoVxCqdPZqXcA?=
 =?us-ascii?Q?hMa9njdwMPrtjngZW66Je+S/8Ywh1ZeaT9d994/YLS5MEjdckqMAhKBEVr8v?=
 =?us-ascii?Q?QsaihRBnTBzToSLmbA3tRPDWHVbY7HKSQvGLiPruxyXrNm1c6HQtrfiHYqUN?=
 =?us-ascii?Q?7azQvF7eVio48NdqzI0mCLOjPqOT45e9eFqp/9bjLctRPwUNCrAmmgh/GboE?=
 =?us-ascii?Q?8chj+LmhRnRB8TJL9zZ1l8G80UGBSuF5r3ntzDda1jKlUWwpGCJyyeBiguCJ?=
 =?us-ascii?Q?hHYG2fnChsk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11Oj+jR/Q4niR/ST3yztJ5BB9IH1KG+b58SRqsk55qMmtSGMlw+Isr/v3D4S?=
 =?us-ascii?Q?zKm7eYeDfoWMfPHH+66gQ3QBlW6It2p5ukyBtGiZ3KfQnkv+Y7rAr5z41+nr?=
 =?us-ascii?Q?LC3l9pM0ylbH8u7LUuiuV6VbXlJ/rudksdJOpHt1OAGTSLEE9sbsqO4OADxv?=
 =?us-ascii?Q?owPzR9FIjYaBPPgjk2fqLy7yXMHfk8Rio1vGIhMiI4PrYV5dwvPHQn58txjQ?=
 =?us-ascii?Q?tqlV4/NZUTGsawdxKguFFwlR3SVenmVpEqRzUqWKAaldMd/5+GRcPar2VB2d?=
 =?us-ascii?Q?WxCXVP/SjFhD7BbRxF3kaD0QzvNPEwHSuO9xAsBhrL5OLNTTVDYzmFxPNYrV?=
 =?us-ascii?Q?ctGDVOy1WdDqfB6IzzyTmYF2mXMQZQBLtcz59JPSjb8DEmkA7aZi5St7T2iq?=
 =?us-ascii?Q?bcreWVx+BMzzg3/UBXmE920XeF4MKNPRzI9D2Bu4l4i/bn3NXJt5iD2paBNq?=
 =?us-ascii?Q?L6QlyTP/GFUWDKMPx+FIguhMRj8g5gnlTIgZvdo47qYA9zHx8V+Pymmo++cS?=
 =?us-ascii?Q?EHKbAm9CIYS7tx9tC8Se9fbVZcyDfE0G3FYEBMGNV9C6Smf0a3dUJHVFPrXC?=
 =?us-ascii?Q?t1A2kQS0hkj0aZNiYKpxqxFBOcBZak9I51hj+1IjNwgHa/802QrgK/eme17p?=
 =?us-ascii?Q?l8K5qFcbCdiQ5LIfSpgqR/V1MO93OahjFsusXLzyvFMYTUeqxuw6vbvbJ3Tl?=
 =?us-ascii?Q?MZc+4q7IcwwkVYf4OB1Fk+OmPDuHN6tLVs1xzUMwKR1cCIlvfBiGxqHJQL8F?=
 =?us-ascii?Q?XP99aCeee1R37Thq9JS8a8oUzW0tZl74RIkeeX9fsocjQAq8S7UhKA8n1ed3?=
 =?us-ascii?Q?ANzbBrneFapwJjlLOKgEDPNJR+PwfqQ3aXDpsXCDepL4myWprjdBvsAMf7C2?=
 =?us-ascii?Q?irDuypwbEsmWPzmMIg1KVNeYO3mEovxOPJq0ZN5U9eCdy3+sTbipFxxW/mhp?=
 =?us-ascii?Q?KjkkUYmo4oBxE/JXLxqC4Loa5lW8PZV76XTcaKPVAHc6GugTQX1NArWvLkcg?=
 =?us-ascii?Q?otimyZFnFWbI8GQAVvCo1qw/9jYkdCgp65cSbCvtWrufTgbpCJLiMS1LWqC2?=
 =?us-ascii?Q?KCJS2Jr72WUrgvW5z25EsSvWzgfcd63AKTD08x/dlyVUfseLwhN87Xsxk2NU?=
 =?us-ascii?Q?JJrLHDJ4QaYifI1vAJO1vtfxYgu7TYF555IiTaIBYaviYJni/2EItFP6xEOS?=
 =?us-ascii?Q?2bDfjSZneARCoZlW1Xi9zyVs67p0ER8Qp9/hg0UFE8gvxP2UpH4g9/CehrFF?=
 =?us-ascii?Q?FTbM2UXskPCoGFq6j8yVRIny/fRKe+TPgSf+TPr4Z3u2xXjiNW9Q7SBb74r+?=
 =?us-ascii?Q?zsaFZn1kgad8X5HVni+lLhUBes02YkeaDmBAOB0BBWncG+/iVIhwAz2QoZP/?=
 =?us-ascii?Q?Mc8EI0o1uijNYI4eKW3VEEAPniA9V5WxcuEXmNX+iGN1jq+JY3pVzXZiUV/d?=
 =?us-ascii?Q?d6XgoqsscSSFomrKlODHoqnaoavl8KWbC/UVzDQFfSJCgF4OBr3rGbp14g2z?=
 =?us-ascii?Q?CDwqijov0UQB+LUntFHmvgu+PeFrWY07Ew24b/X/vUPGtvwX2H/R2RG4zaIV?=
 =?us-ascii?Q?Ps7S86piAVn6y1fwkNEHjFB8A7/2oukRmd4I0tgP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ca9865-8cc4-48b7-6c69-08dd98c983e0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 00:42:22.6665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l11ZK0hQJ3OGGgn3fwHqVt0sUizfknwaBK+2PZhwH4pDU8dLlmnnEulVxsvfqGLpjgDNHVsJ2tDN6KUFgL9jSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5051
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 08:45:21AM -0700, Sean Christopherson wrote:
> On Wed, May 21, 2025, Yan Zhao wrote:
> > On Tue, May 20, 2025 at 09:13:25AM -0700, Sean Christopherson wrote:
> > > > > @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> > > > >  
> > > > > +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> > > > > +{
> > > > > +	int r;
> > > > > +
> > > > > +	/*
> > > > > +	 * Restrict to TDP page fault, since that's the only case where the MMU
> > > > > +	 * is indexed by GPA.
> > > > > +	 */
> > > > > +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> > > > > +		return -EOPNOTSUPP;
> > > > > +
> > > > > +	for (;;) {
> > > > > +		r = kvm_tdp_map_page(vcpu, gpa, error_code, level);
> > > > > +		if (r != -EAGAIN)
> > > > > +			break;
> > > > > +
> > > > > +		/* Comment goes here. */
> > > > > +		kvm_vcpu_srcu_read_unlock(vcpu);
> > > > > +		kvm_vcpu_srcu_read_lock(vcpu);
> > > > For the hang in the pre_fault_memory_test reported by Reinette [1], it's because
> > > > the memslot removal succeeds after releasing the SRCU, then the old root is
> > > > stale. So kvm_mmu_reload() is required here to prevent is_page_fault_stale()
> > > > from being always true.
> > > 
> > > That wouldn't suffice, KVM would also need to process KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
> > > otherwise kvm_mmu_reload() will do nothing.
> > In commit 20a6cff3b283 ("KVM: x86/mmu: Check and free obsolete roots in
> > kvm_mmu_reload()"), KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is processed in
> > kvm_mmu_reload().
> 
> Oh, right!  I completely forgot about that.  Hmm, that reduces the complexity a
> little bit, but I'm still leaning towards punting -EAGAIN to userspace.
> 
> > > Thinking about this scenario more, I don't mind punting this problem to userspace
> > > for KVM_PRE_FAULT_MEMORY because there's no existing behavior/ABI to uphold, and
> > > because the complexity vs. ABI tradeoffs are heavily weighted in favor of punting
> > > to userspace.  Whereas for KVM_RUN, KVM can't change existing behavior without
> > > breaking userspace, should provide consistent behavior regardless of VM type, and
> > > KVM needs the "complex" code irrespective of this particular scenario.
> > > 
> > > I especially like punting to userspace if KVM returns -EAGAIN, not -ENOENT,
> > > because then KVM is effectively providing the same overall behavior as KVM_RUN,
> > > just without slightly different roles and responsibilities between KVM and
> > > userspace.  And -ENOENT is also flat out wrong for the case where a memslot is
> > > being moved, but the new base+size still contains the to-be-faulted GPA.
> > > 
> > > I still don't like RET_PF_RETRY_INVALID_SLOT, because that bleeds gory MMU details
> > > into the rest of KVM, but KVM can simply return -EAGAIN if an invalid memslot is
> > > encountered during prefault (as identified by fault->prefetch).
> > >
> > > For TDX though, tdx_handle_ept_violation() needs to play nice with the scenario,
> > > i.e. punting to userspace is not a viable option.  But that path also has options
> > > that aren't available to prefaulting.  E.g. it could (and probably should) break
> > > early if a request is pending instead of special casing KVM_REQ_VM_DEAD, which
> > Hmm, for TDX, there's no request KVM_REQ_MMU_FREE_OBSOLETE_ROOTS for slot
> > removal. (see commit aa8d1f48d353 ("KVM: x86/mmu: Introduce a quirk to control
> > memslot zap behavior").
> > 
> > > would take care of the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS scenario.  And as Rick
> > > called out, the zero-step mess really needs to be solved in a more robust fashion.
> > > 
> > > So this?
> > Looks good to me for non-TDX side.
> > 
> > For TDX, could we provide below fix based on your change?
> 
> Hmm, I'd prefer not to, mainly because I don't want to special case things even
> more in the common MMU code, e.g. I don't want to bleed the "no memslot == exit"
> logic into multiple locations.  And very strictly speaking, a memory fault exit
> isn't guaranteed, as userspace could set a new memory region before the vCPU
> retries the fault.
> 
> Returning -EAGAIN isn't an option because that would break userspace (e.g. our
> VMM doesn't handle EAGAIN and supports SNP), and documenting the behavior would
> be weird.  For KVM_PRE_FAULT_MEMORY, KVM's documentation can simply state that
> EAGAIN is returned KVM encounters temporary resource contention and that userspace
> should simply try again.  It's an ABI change, but for a nascent ioctl() and a
> scenario that won't be hit in practice, so I'm confident we can make the change
> without breaking userspace.
> 
> And again, this is an unfortunate side effect of zero-step; there's no such
> restriction for SNP, and ideally the TDX zero-step pain will be solved and this
> would also go away for TDX too, so I'm hesitant to bake this behavior into KVM's
> ABI.
> 
> My best idea is to special case this in tdx_handle_ept_violation().  It's also
> very gross, but at least the nastiness is limited to the zero-step mitigation
> mess, and is co-located with the code that doesn't actually play nice with
> RET_PF_RETRY.  E.g.
Thank you, Sean.
We'll go down this path.

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..ca47d08ae112 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1907,6 +1907,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>          * handle retries locally in their EPT violation handlers.
>          */
>         while (1) {
> +               struct kvm_memory_slot *slot;
> +
>                 ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
>  
>                 if (ret != RET_PF_RETRY || !local_retry)
> @@ -1920,6 +1922,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>                         break;
>                 }
>  
> +               slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> +               if (slot && slot->flags & KVM_MEMSLOT_INVALID)
> +                       break;
> +
>                 cond_resched();
>         }
>         return ret;
> 
...
> > And would you mind if I included your patch in my next version? I can update the
> > related selftests as well.
> 
> Yes, please do!
Thanks. 

