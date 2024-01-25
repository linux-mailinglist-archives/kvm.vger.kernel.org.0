Return-Path: <kvm+bounces-6970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E21483B875
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 289E0B24123
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B9B7489;
	Thu, 25 Jan 2024 03:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qc5yxEdq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C7D6FC3;
	Thu, 25 Jan 2024 03:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706154342; cv=fail; b=kynKyZ4bCAG1infZcLz1n/kcmtTbZOxJGtTLVP+pEsTNsxTfu0bLmGpgwwVC30vY821EFGHOy+m6Gi4YSl6VUF7OhOM/dCtPnlxio5ZfyprQQeOrKWHV8/tQwypM7yLM8RDF91Pcl6Efs45chOiRtC+0ivp6TKijAn5WuzfU7tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706154342; c=relaxed/simple;
	bh=+gFBJ1cX4FIBmLdCthemGgDJGL1NKU2E8nG/NAmTnhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WpKdSw1gCxC3jEpYWLTmSHGoGaNIWxRHaYd5CHbj5GKd5A44ZTnpscG/2CqCQVJZc6rg4VCzOyRI9J23zfECD7Z4wEWSCv4GdG8yLEgpSUjve8o3+XJkhGMMrJ9TU3qLj5imY59D9A3NzTtXgOovjNR6vYGv45w91Mes8JsWXa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qc5yxEdq; arc=fail smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706154341; x=1737690341;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+gFBJ1cX4FIBmLdCthemGgDJGL1NKU2E8nG/NAmTnhg=;
  b=Qc5yxEdqEvNlCl3filQh/9J154coMtkX8CDONWafhMH+X10TFxWVyRCq
   BZnjIcE9H9RuYFOYQyoRBFkxbO4xIvAWfkvkooqKpiKQPA9S40dUxcL0C
   IfPIBS+h//A731NkzfG6OysktbKgCqpsM3OmsSKOjP+sURR2aWaErOVdd
   OIUQmIIZcIfFrDYLrZTuPPpjKGoDPsl0l2MfSJqUUlDMD06CVrorlrRha
   4eHUPQ6H5068TxFU0RxENBcGKm1yWIBBjTWfff2TaVMGC43nwWpcyz/J2
   V/BQxDuH03mVM1BRsK/3faKV/oZvGA+qOYJJFga2L2wXrXkidfTdCLYy6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="405798315"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="405798315"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:45:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2265317"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jan 2024 19:44:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Jan 2024 19:44:16 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Jan 2024 19:44:15 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Jan 2024 19:44:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Jan 2024 19:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXgVwEOUYArb8mnIORJYJ2ekWrCe/pUXeC2e0ypAqvxzjTRmM3P/eRWJAO6HAXkMyRKyyqWCzhDBKpKFC13xpMkeiI8EIJ6HKPEsS6kBp/mAw+z+na+2K164VZedNLH/R6dAHp4vUdy+Ku4N2wMWSmYU3NpARwLWkTFp+F5939TPoa9gNvbk6WZYqSJra7lHT/tiSGdslfTj9YQIvzN0VXQK7+FBrd9iAIgKTNnG9oekab6OlLHX/n2BZB+aC1iPe47CKnqp8H9aTgc7/7i3XnajOnh+4IgeOD5+LU3MHn7aFw2oFOPR5Orp5Brio3JI4zSofAjcjXu734NeXhfOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gFBJ1cX4FIBmLdCthemGgDJGL1NKU2E8nG/NAmTnhg=;
 b=GIBW79ZGO/Z+k7sSZWGiz/FtdpJGeCt1A2m0Q5+XagpSdJSiVS+ts2lefWYVfMy4XIZdanlvDkr0f+z0SkBjs+9Md0tLZw+SFnNtyM/NQOA2COIrT2q43cg1KeIbCiY+7lbTxr9ZKhYanv1k7spccvV95o44yNwzERSCLDVXoYSHYdKAWCV/yWsgowO3VG7B5HYXxuwCjm2s3HGrnQRV7HAcJdRex/DXB8it5qOo7enwy39kmdv9ZGHnnkS4p1BYSW5X2IRdV9JYzDQDttXKFYSuPKetrefTgcwOsv9JSMk7Wwu8NpdfyD7k8vJNGd2JpE5RCkdYbqRoEZfMR8j7WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB5458.namprd11.prod.outlook.com (2603:10b6:610:d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 03:44:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 03:44:08 +0000
Date: Thu, 25 Jan 2024 11:43:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 09/27] KVM: x86: Rename kvm_{g,s}et_msr() to menifest
 emulation operations
Message-ID: <ZbHY/UVpRVRuyELV@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-10-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-10-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB5458:EE_
X-MS-Office365-Filtering-Correlation-Id: b02bd932-f302-460e-dac4-08dc1d57e27f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmKZFE2AopR1pOmk4CBjSMYk+puYHJR70wznhts4o34legxxjczs/akqLixBBawuyNh/xg28gLUZ8HURkTTHTnRSrYts/YylDoSNub+4MJBUVsuKk29dKrf2OvU6Xz3k9MpLfyO5lV9CvIZSnuAu5I58iPd09UP/dP6LdFxtFJ+n0Wywl9newGjTvkT3D+8wyESwh5TFYqfANgKhpNsK0SEVufnTT/8fFixoauVMXI00KQu3pXP6/xrNO3rNwQjgCvZapobwN8eHokaiBMrFz5gby6btSL6pW74ywhEESzI/uAqDQMZ+OfBIcGm93OzLP0qrlgozLJ6luZVgHJMlPYbAvzBVUUE/ji0Zwb7hXYR3XaVJUMpzASklQKx8/0FCHLzHwuE0u3W/W8F0DUULEYMJhVywn1rROIxD0NBWqvSvlzIBZORghcwff8QHypSL/gESMoasQVsu59fpU+Sd5xxCo8qNQs4FsoNpgSemxxM2VeV2fiJC5H8j/v1tRF+JwiTVSpFeJIxkt37nZhrEy7yEnkdtQBoogTfImbgDw7GY/PoMr2gk21q13u5/6N7A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(366004)(39860400002)(136003)(396003)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(86362001)(82960400001)(38100700002)(26005)(33716001)(6486002)(9686003)(66556008)(6512007)(4744005)(66476007)(6506007)(316002)(66946007)(6636002)(6666004)(44832011)(478600001)(2906002)(4326008)(6862004)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5p3i0FEUq/nHAwCHk2ZsGzR4EScSoSSlb38W4imX9r+MeI6V9JJI4zv21haH?=
 =?us-ascii?Q?9OrGxeKFQOZqew6lpKaHnsT8HUrjdPqxX4MSUsAZloWu2xGC0rh+q4W/oXSg?=
 =?us-ascii?Q?7XHql3Q26a/68tkV4RydsFLQa56G+u56dC1i9PmYMCObkNHpmge2JM3gyyle?=
 =?us-ascii?Q?xzGx33BPeNKV24qKH2BtBNAcRSkReBgzd1kpgTCruU2L17rELMzKHLjktjvt?=
 =?us-ascii?Q?SnQ7ybKDWJXbZNEEUXA4q573BSB3waIUqCIVNLMEmQBFhK8H7oeXkJ+87o6P?=
 =?us-ascii?Q?BW/lQ56GWhB7sCh9lcc6dGe45h/ucWDmeYtViYyQUGTq+6ylk2MM1CaZbxNC?=
 =?us-ascii?Q?ud8y6uLea47QpFugOS/MTxmR/iLXBhJWbuLZw0ou41nxdjWsdz7cxV95hDgr?=
 =?us-ascii?Q?DVqU/njOlETT3H1D11tw/6z2qp75U/AlYbtDDRe/xf3qz9ccypVhKaSx8Cdt?=
 =?us-ascii?Q?9OVHD0eOs8W6x+SkR+ORVRc3T6dlc5EDD3+CGbEDnBwF4j1VTtkwFwj+PU8w?=
 =?us-ascii?Q?9nP9yoFbN46OHinDjANG6cOuh1CRnP9Rw7oIP7OksAZ3ICWflkQMHDk/P2pK?=
 =?us-ascii?Q?aMR3rFPS4Fuy6jYlsFgNhUbHu0oMgZKDeDxfioizMfnuY9Yikw98qDFwo8Eg?=
 =?us-ascii?Q?1XygT9XPZB++wZq1cWXbJuUEep9bnU1P37P8HuIGlq1NrPnFzVSZc/WXKDsv?=
 =?us-ascii?Q?ftp/wcrMbVcIKORfjqPovJNDeMXeNYLg2BKhwlPC9jcLZH6X3rcyTre60hzh?=
 =?us-ascii?Q?elWjtIp++iB9LNZSd4LKXx/gvkcDNlzhWWz53RNSKMytgp/YTFe6/UaWYiA5?=
 =?us-ascii?Q?64wM6oRb/EsI73LBNt8RFakWcleETnV5xPfG9SioFH3jU88RTklS6FU7+KTi?=
 =?us-ascii?Q?sIziJLzNPc5grl79w/c0k0qKP8DXnxKBk7puy4M4z6Gco/MSzxMI3iriAlK3?=
 =?us-ascii?Q?y8Y0+vLarxhUWQSpqu4SVjhQdjWzMnel2aF9srtaYEr3ryTFTtw0vUgA86Wv?=
 =?us-ascii?Q?tZDWNXIWqyATrbcqUUYwFDDcQRj9msnv7Tm/w9ExZY25K/VjrtVYAKXw5LbP?=
 =?us-ascii?Q?hZIdcvOuetsoAO5IilLrAuqYCKZty5cNyDJZWRfBUDz7jeoqwDoqs0CQVtCF?=
 =?us-ascii?Q?Frp0sLmjSRqVlS32DDuATq8htm9kYS9ze4iXFkoj7IBc+Tr075m71hv9dpYV?=
 =?us-ascii?Q?NyDVRi01PvNWVkVvSo+hnAyzAMuBZh8C6JUIyc7acic7AmxHsB8kcih6YTgN?=
 =?us-ascii?Q?Lh5dC5UECRqeDADM8F504wzNE3/3K72o0j7Mm8maReLbZssTJormHy67pYr1?=
 =?us-ascii?Q?kxn99uRv+L4ioAXUm5qKLqHxvLYYWZmomDlYMAzVPOUl3TLFGohlGXEVQ3wg?=
 =?us-ascii?Q?tRGTf8Jc2Ut+UjpMZW2VHhqmpwPfuLWrfM2NOTQtEoEUAenAEdPIdMQKTvMX?=
 =?us-ascii?Q?DE5O7BL2BQl2aKIOmO5EcsPprBAIY6kMlPVYQQDeDOtyUd4pRjPLlMLo8GvK?=
 =?us-ascii?Q?75lEutDMEJgFGDuHhQ8RCJaGdJ7mSKGJlyQqL2SxcoLW+YaD+n19hbK4zArW?=
 =?us-ascii?Q?UTXwwpePqjipK6uwEYNFY+DKlyeVYfhv5GqPiHfl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b02bd932-f302-460e-dac4-08dc1d57e27f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 03:44:08.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5fDaMOZJL37E3u2g07hYvRkXv16Uy1y1288jykqtOi05dD83LVDw8qGsg5IVDKQzvBCUsVhFi2RVd+B6Ff18Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5458
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:42PM -0800, Yang Weijiang wrote:
>Rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
>more obvious that KVM uses these helpers to emulate guest behaviors,
>i.e., host_initiated == false in these helpers.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

I think {kvm,emulator}_{g,s}et_msr_with_filter are equally confusing.
Maybe you can rename them as well.

Anyway, this patch looks good;

Reviewed-by: Chao Gao <chao.gao@intel.com>

