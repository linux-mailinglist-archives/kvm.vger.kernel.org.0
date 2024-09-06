Return-Path: <kvm+bounces-26035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFFF96FD67
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 190C9288C75
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 21:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F5416193C;
	Fri,  6 Sep 2024 21:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A6KapYCs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A481607A7;
	Fri,  6 Sep 2024 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725658228; cv=fail; b=fYO0sI5HFERf1j4fNTouf2pvaT4emIaPMW4RZKlVsIcWuGNcKNmFvP2hRMXh7RE98o4hyftQ62SVRV824tKTvdvbzhhzi7ER4XLnQNQhKVgFYmTDMZvqSi0mYrLyQ2sJBEmLxWK7h0bNyjltmhFCyX+P87I6aVSHCEhf5Ay21UM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725658228; c=relaxed/simple;
	bh=iFxqBQFxcLrpOlpAeSe+s5a8HviImWee0P/YmmGvRGE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=huLGI4v4JCgPfs6n0gPqFPRg4c5KgF89nDTghkV1bUFFR0uy3SQAcYvnj8YVsiBtlhsYRN+bI/3mydosGeoQSMtjJuwPAJfh2vLURmYya0ewNaIPHp1BbNUDXokVCLWkf5zafGI54JObgmQZjWjovZ39rqiY6nlU1BcY62gkZYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A6KapYCs; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725658226; x=1757194226;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iFxqBQFxcLrpOlpAeSe+s5a8HviImWee0P/YmmGvRGE=;
  b=A6KapYCsdem49SbfoCcGHiEjtD4bZrn6w9GKiug1BdWGaQiFFzFLIy78
   LDH4eISsRjqMSM3tzF1C1iIarxoQUAhv/cx454giKYJGE64Gt+vBHbpkl
   cNn2En9cCfYvDBChF3/Dj5XzIKC4tW146IbKrlJ294fHoeKD/YKkrWQji
   ngwBOcf2VzDVxMWk9gBowdsE5K+ffAOoW6VPmkfx9gyRCFtH6JrosbQuT
   1t20YGscQ/8x3kNt5jALZmXhKLXNeYg1ShbuB1oSqW9VyKRDP/PJ2pAeJ
   7VkXySCs5+EJLTwYiTIiud3IdtIdvGwB8qVPli0OTo5G+Vi22n2xomrl9
   w==;
X-CSE-ConnectionGUID: FAmvGvpQQHi4ZprRRqc++g==
X-CSE-MsgGUID: cfVEQUEdSHCHbRZu59vIsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="28216059"
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="28216059"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 14:30:25 -0700
X-CSE-ConnectionGUID: NYSRKn6AT2yEy963tTzG3w==
X-CSE-MsgGUID: uVFcc51+SY6TQdd8ubtu8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="66046268"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 14:30:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 14:30:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 14:30:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 14:30:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 14:30:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9xDglsLp+fw9pEDGsweSL3HwN3J/QNNy/q022jZqwS9IB+rZCtxMltHhg9O6dnUibnsuaSDpR7vRgJl/sreVKCRvGX0LdbJ/vL4xjv5e0+Vr8olWxD2KEIypWK4z4gCj8bCml9OjavtgN5BQs/HTgUhC93ayU1PUYpyHDXVUqpeFeD7AOqwKmHoQDsTCG5Lw4fV0ymhGXMTXzgOqBvOeYBRQ3Wai0jadQmD9uM2Cos6C/ZKFaBVo5ydN5IJiRQPQdwJ9Hr2ewkEmzBGt8lXdX/MQCFyrg8Q6NOiJjWltrM38Knnp+La4H7PeLYnbRpofv/D2IkxIDN+rZgpT7MeeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maCTg7lEuXhbWd2hJJMPr0o/obpjyV850BcB2rEuAMM=;
 b=T87p3KFrybwb0WizLwlxm9R7QWs6ImRSd6FuCZCcLGG5hhNhUjpuS6gPTKE+HJx3Wq45tx0SIKGcfvRGEqo1gyeiqiXdLCUXVn/ctceFbZkzsTeC0zdkuALP36NdNyuz6Gregq2CvCeAClRn1Gqd7uvXCV6k9XNdfTPsh2/KMCRdEJ17W49FiCRHPt4W42o60Ug1d45dWoH0WjzutRzh3q12OnGGDjktFISwg4nmO1LjMf6J5Y6ePgIZMji5GrlCEOkKrMVk5iXN5YFKnr8tLnC4WESu467Nb3rgAvrdIeIiHpKA9Ooi/UUYJBYvuwbBbC+2ReKQP1lCaPCr3zhuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7183.namprd11.prod.outlook.com (2603:10b6:8:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 21:30:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 21:30:20 +0000
Date: Fri, 6 Sep 2024 14:30:17 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Kai Huang <kai.huang@intel.com>,
	<dave.hansen@intel.com>, <kirill.shutemov@linux.intel.com>,
	<tglx@linutronix.de>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <hpa@zytor.com>, <dan.j.williams@intel.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Message-ID: <66db7469dbfdd_22a2294c0@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
 <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
X-ClientProxiedBy: MW2PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:907:1::39) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: ef6f08d5-120b-40bd-4325-08dccebb1c1e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fof7MpfBJPFXYHWZP6bZ/wqa2HSqp/I+CMGj2cDOuymFAZlccYPDBGNX5QGl?=
 =?us-ascii?Q?m2Rnr1SWGqKr/36cV6x+3ElTwmNe0WBjAITVz0Sk/yPefdi2p8w4OiMtjZGD?=
 =?us-ascii?Q?6/1dP98P+W1ZdQ/mkD9OkuNmVqoiXtBKrkIOYwmQPjlarLIRfi0rMibIO9tU?=
 =?us-ascii?Q?CkAMI8kPepOGqMUYrmTivdF1jycUt7UPs69/gu0nIlfOHlfj+keFzGt/+Y85?=
 =?us-ascii?Q?xEmMohRtg9DKYaS1YYGVn+UZsmzTJ6dbH7vq07j4q2L2oRYhh47uVj3KnQE7?=
 =?us-ascii?Q?7DfLcbOVeFMtfBui/HjcQr7yYg20H9j4ZY8Mi5HriTJwRLG+lkiGFgF+Rvlw?=
 =?us-ascii?Q?mfHba43/x9TUIHj4qUOH+QCNMRTp5FldK/hF3tlqLgfXUCsT8DhAZ4WK9j6O?=
 =?us-ascii?Q?2a6GPMST8k2vb7rI8vWDJ2HzralASVw9xl8HdejnUC3P40FBQWxQIKX2TfZ/?=
 =?us-ascii?Q?CIpAtp4hjvN3pXzXU2ZxB6L1dVy6oj4WOBjVdNJUi7WItudCCnWqz0FGQxXg?=
 =?us-ascii?Q?p3l7fwxCdc1FWPsS08TNMzDFRiSTZoL2z+JfHUpRXjvfPJUYQ3rHogIFtrmE?=
 =?us-ascii?Q?k/xd2d5Qx54OnLIa5hjhgwdgM085QilI1wXWu10urWR17d5FX0YrOA7er9Qt?=
 =?us-ascii?Q?nyzV5qopuwTREhuUvAvrO1Ge0RgVMgiENT7E9NIHAq/qAUrN3yH7TdXtk4kr?=
 =?us-ascii?Q?YZAQPRWbbgdBB3oPSiyJCBlClvm870FkEHEPVwvWVAQ+40tsNFr5RrBcCuF1?=
 =?us-ascii?Q?TRpZXvyO7Vk12EfBIFz03fXgEgGTv5izKe27/+1lJBkhbQ9OeJWRqgbrMSbr?=
 =?us-ascii?Q?faXj1jsT/pUsmXGfF3QNJiUrxMjUzAEz5m68MlF2uA0TJnCYJ1Ol59OAqa9d?=
 =?us-ascii?Q?dQ6ga2xlPcszlUdpwDZkOLds32F1G7UaT+6KNNwly2whT9zL8ikM8VphnAHC?=
 =?us-ascii?Q?qki6GX7vlFWwHgAa+Ur686VtMUt1e6edzkR57ni4OHe7OA/EPdACSgcsDkAz?=
 =?us-ascii?Q?K3dnMPbYYfGrjE2LlsyhFIwGGC+qCqxOh6znhxZpum311EpwbxvsHUU3RXDa?=
 =?us-ascii?Q?X546mUpMmOTNZiZeqqGlxVg7b90TVToCkP00cxhKiRiYoOa65xi/p9+1Hlon?=
 =?us-ascii?Q?Sm4q/+1yb1cTY/pcZ1yl2rFuHF3JKbuwhKVAp/QhYMqjgESDYL22+gHAnS9D?=
 =?us-ascii?Q?NsQGYnAPuK0FHDVk9TaRMn9z1jIj2ronuZh9MGXaJLJjtJTOMMRgd8iyCzdT?=
 =?us-ascii?Q?SLSSfZEoZKvfRQqzFZR8Ke8lFfWJrtqMXW1/cpy/AAiT+jmkIv1AI9qynm0d?=
 =?us-ascii?Q?2VU5TMj5wFcarlHS1xwCrhZepPCFmV+Od9ecU09hz99i9073C/ny367ldTKl?=
 =?us-ascii?Q?7I7n5jHUaeZVujfII72PNwgHNpKz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMhiBlmzHZTtdhN5BJBCaev3m1wKvXc8VgeZlSSuzSQZd+a/juTo/0AZ8wi4?=
 =?us-ascii?Q?v4eEORM30mFUq/OBCRuUq76nqgs+8W+5VANnfr0Hmz2pcCD1RBUNZ2dcAwvT?=
 =?us-ascii?Q?SNZtO5jpqo+SijeqBsmqIn+mBmgC+TMxVNRQFFVU6a6poXp9AR3WpD4HnRgY?=
 =?us-ascii?Q?yM4886/JSgDTh7QrU/Q7RqKjOv3HF55mcVIaVpYSuQJqOxmSPcSnC+5p+3bP?=
 =?us-ascii?Q?p5QqQSozWDQpF4w49A2i5eI9foMtSq7chJDHz+ohHf753LT1/ISwPXLexBAy?=
 =?us-ascii?Q?GQpRvKqTUMFzMz32hHnQ1TXwq1WGQMEu+dDjyeTWSDVuToUVIT3itDz8nF6a?=
 =?us-ascii?Q?jV/v+S3ZyCkwH46Kn4Z9VRkv5Peo08rZAboHgo8wFbJk6qu2FwQbjQJ+Z8Dr?=
 =?us-ascii?Q?CtmvEtpRD/0I8Wow3atmtBoBSF+H9B+p4rY18uavejOAF1NsWwYCr5SkbI9d?=
 =?us-ascii?Q?e6Ue32JxuV3VZj9YEP/moCgnID9qUdW9hjQL/jSA6WP6sR2afRc3m9YCxNnr?=
 =?us-ascii?Q?HYgsuziloXgh/jkB3O0Wd+EJiUthjqorSEoE0lIVlo1tLwWOJSooA2OCA+QT?=
 =?us-ascii?Q?BNK76OWMk2A9ECBfRsZu7ID6I9/WFaS6GKCq2QbR4ttST2YECm76vtLAJwe0?=
 =?us-ascii?Q?BH8DAaH0SU4LWjlOxL6GhPG8o+oam6C/E9a3hDmsLmC/cRoBXZkljPAuNj6h?=
 =?us-ascii?Q?p9l2kSzrkjKyhGlOqtsyxm8ku4DXUS0TYTO8JC/BOEyzdwS6GpdZ/c7oQ8zz?=
 =?us-ascii?Q?ofqZUeqAkzq22VOdRTK/9ANm5L5HzK6j5y6SJaBd0jI/HFckzvVEHZ2k1snk?=
 =?us-ascii?Q?OOkrKY9kKIh02nu4tAN+6x/OA3xP0YCHgPi3D133s5iwIZVGT6SGVKCsxrpd?=
 =?us-ascii?Q?rqSYRwRf2W890rE14N7hf1MqnX+ccZJz+hgtMxetr+xUaJA+OUpzrwIZCS3s?=
 =?us-ascii?Q?UAnYUUS4fQl6gw8o+jD8VApT//1ROBj7gx7BR+5oAA2Wp+hilFlTfbDbW3VW?=
 =?us-ascii?Q?jdkq+kV++1kB6AqE4E1FXiMAaEpNHBT1edtB07eOQcYHveUuE+Fxz4LvsPDv?=
 =?us-ascii?Q?ha7DUG1xIeO8Yg0ZQxHTTbTqca+gwPG3VhUDpwcIZJo0VqWETmy1UaKToiHJ?=
 =?us-ascii?Q?/f1YzxTMyvOjGAvOMuS1P/X1MtK8xrn7uW9QPO0dLMeRFhLwY6GpPcA/8Xv/?=
 =?us-ascii?Q?ppQgw8xH7SVS6pZK1o2R5zzQjsthqCi48mcCI3bHdwJFmiU7DOdJPaW5XcjC?=
 =?us-ascii?Q?AxA1a4XYRHbaK2OTg7UqcQqXQOpwTtHcxMWhf0LMvDz4usRu+/7TD1jqgw+1?=
 =?us-ascii?Q?lsCZUnQUIZ1fsk8A1o8rtHZnYlM9C/uizILKnbm1U082x1dbUbhM3F5abUH6?=
 =?us-ascii?Q?ktRNGrJjT3UTvjG/XnyW0+bz3e1m9hTqNGlzf/hmr3dgrFvB+UptPyoEQZ51?=
 =?us-ascii?Q?iBe3cTUYl2QILnwRlfJjZG9k1LS344NAU0wF6Ncf71Fjlq1d/0C4+D97PoMi?=
 =?us-ascii?Q?Ci/1yukG5wFR6LZOWyPzpxdxLkRbEe24fVZbleWHnJQmU7dmjB7iiDDw93Gf?=
 =?us-ascii?Q?KhuVqDP2NTwYMi5/yW7Gh75jQPiOuSlC6ptQw7Ch5sWY/JBqWFH+rAa18epL?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6f08d5-120b-40bd-4325-08dccebb1c1e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:30:20.6750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbtWtzhxFtnpotr2f1O8TEdgMSGk0XVQqnJ4+leGEaaBBsk5n0d1uIhM4qoauQHjT+QUvcwBt1Krf70n6bRyeO694PQpOlVT4sBN2wXOegc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7183
X-OriginatorOrg: intel.com

Adrian Hunter wrote:
[..]
> Another possibility is to put the macro at the invocation site:
> 
> #define READ_SYS_INFO(_field_id, _member)				\
> 	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
> 					       &sysinfo_tdmr->_member)
> 
> 	READ_SYS_INFO(MAX_TDMRS,             max_tdmrs);
> 	READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
> 	READ_SYS_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
> 	READ_SYS_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
> 	READ_SYS_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
> 
> #undef READ_SYS_INFO
> 
> And so on in later patches:
> 
> #define READ_SYS_INFO(_field_id, _member)				\
> 	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
> 					     &sysinfo_version->_member)
> 
> 	READ_SYS_INFO(MAJOR_VERSION,    major);
> 	READ_SYS_INFO(MINOR_VERSION,    minor);
> 	READ_SYS_INFO(UPDATE_VERSION,   update);
> 	READ_SYS_INFO(INTERNAL_VERSION, internal);
> 	READ_SYS_INFO(BUILD_NUM,        build_num);
> 	READ_SYS_INFO(BUILD_DATE,       build_date);
> 
> #undef READ_SYS_INFO

Looks like a reasonable enhancement to me.

