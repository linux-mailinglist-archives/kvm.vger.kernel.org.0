Return-Path: <kvm+bounces-59161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A1EBACF52
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 14:59:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86FF21794EA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E961E303A06;
	Tue, 30 Sep 2025 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SO9c/Wob"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229F2FC895;
	Tue, 30 Sep 2025 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759237181; cv=fail; b=JKj6GjSmzgGzavyjpWXxpo4reb9vuKFl4eQ2LkfQNaGo3l2pqP3iTNWr6E8It6euBiL3FjomEteAYffaiRy9rHM9sKxB+7d4gV909/fS7JA80dfva/467S9FNDZEn6YKgGmZLZPljBX0PR37xtWosf8hD9W+BSEr3+eBa7n7vgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759237181; c=relaxed/simple;
	bh=YODeXzbh/omViZYdNJfDHmRo3CMOUgoeCT5Nhd6pPrE=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ead55RUFq/P2zpypkfFjKMOGGXIORwNCPdunJp8JSlAccl3c7HK+KievyD4vLeCeelqDKjWxJsYk8acZ34y7DGdSDjdq9USb/oTqE3hStkiNKisBXt7hJxOAvLOVJuRm/GZ1bNUQxDhUAkeNaXjA7F4VQl2ablySdSkCEFfGn18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SO9c/Wob; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759237180; x=1790773180;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YODeXzbh/omViZYdNJfDHmRo3CMOUgoeCT5Nhd6pPrE=;
  b=SO9c/WobqHaIV12EIKejiVQZO6t2v35vYZKbl02P7gKCv7b/tU8yf1h4
   UmVJxma2A3trrZnXl9n2wbJDQn/Hyx77En4ByFOHEJAfP1I+okcKLq3Uf
   h+EbUCP+Eks7lKpC2VRasWBtACD+QpjkZGfww8AQo+fh52pSPUyg/B3xx
   ePOUXYo9VeEPjlGNSiq7NBjQqHO4TyOuFfVzkzSHfGbDLd8B2Ts6IZN6V
   0ggmHAeodnHSmuQo4V1i9IFSxENMWcEILx0JGNwrXmpgPieTTgEkyqucR
   ItBijENRqXQFyxeY66pGTRDEcA5Xx+5TLzGkR0vjZx1RFO6BNLq5ByGgu
   A==;
X-CSE-ConnectionGUID: ip5CpX7pSrGJyn/lFSTZng==
X-CSE-MsgGUID: 6QSImrMeQGOLLxC7UoP+ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="86935162"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="86935162"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 05:59:39 -0700
X-CSE-ConnectionGUID: 6I2w+JwURRaQtgp9BtxWnQ==
X-CSE-MsgGUID: JKvMisCMS32VXLTPP3wRuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="178090784"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 05:59:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 05:59:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 05:59:37 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.16) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 05:59:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgBCkRspyXX44/pVyCOAuScR68iHqtHE4qkNP25tuPIfVcCxQvCpk4RVRzmpnfTwaVKa3azOvSgyH1BE3ikAww8C2SXRilVMXsjod8sOopSmsWgG+BIxld7Jmg7uxYWk3U3jms0z9Fn6zPlfr2tyLxASn9LnceKQRB//UWrLjsP/4DxSK5a+bB0iY6SpuYJwYpByH7zR0iVJ6XrCi5DNKXtHF/rKoqHMDK/5eehfYPNyQzKVg+pEtts0UWy7Yo6/FV+PiQG7BHRjsje4m9VyWzfPjvfLLLxEhfa6cuhBoI8UkaDnvkPE/g9X3TkwWjP9QYqPw/zglLA6+kkslaMo6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AC8wAgALOfQwkymxb1lZ1CX2a/Cvc487IGbBQjUpHFQ=;
 b=WANNfDJseiT+c9XP4aQCMrZz0PuNMxfZPR7NF1IcgHFZ202CJpmmlwF3LW8lCxs0UQld5yPbJqHCF2Ll/30tjpExJgCv9550uz1c2Y1xJeautIQtPOIsFnzsIiMsfhlnRkzl+loy4Ozcb82lTfhsNwy8jpw9crokKsRjPUefXCmy3pK3HLYvPupyPa+AVtoCJuQRT+DjaaniG3o7E3mpdKV0wS1cIQAny6Y51EHAGbiNKrq05bZptng27YjnBtWpHCv5bwHM7bobTj/lvA3FliUSB1cH5wi5+ceB/VbTcOLDFznVlXQp/ZTlFbGq2IxTHHuww503Vvjtq4Bzpqu9pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7450.namprd11.prod.outlook.com (2603:10b6:510:27e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Tue, 30 Sep
 2025 12:59:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 12:59:34 +0000
Date: Tue, 30 Sep 2025 20:58:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KUZPR03CA0008.apcprd03.prod.outlook.com
 (2603:1096:d10:2a::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7450:EE_
X-MS-Office365-Filtering-Correlation-Id: 2461f205-7d96-4ce0-010f-08de0021346a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gPctVzSktc8Y++6v4dzq1Gsrr2JgduSy6GKkoReQShK4K809d4NrvR6v6Gpj?=
 =?us-ascii?Q?hi3BhvtcWGkBIVH+LjeOssvC7SAIenLKBBGiT3UScOOh+Xt6NrFaWiBl/uQB?=
 =?us-ascii?Q?Q+K8rb8nGDsH5/9tb6xPe7mjhzT9EsLHd+wgOcpL2ebHRSUCDXitODsWwvsS?=
 =?us-ascii?Q?QdT7KH/mmDY0qjvXMOl4mVlJ4yDvp/HRlJU0qUJpgDmlPqzI7amB1ZHLTyn/?=
 =?us-ascii?Q?2MggfXz2ORut/OW0Al/90Ikr1AN4nEJPGJAOK1H7B+1QXtgPF5uyRmmabkYa?=
 =?us-ascii?Q?PJpy2LvJYcOkD6MY3BUCvr1GINQ9tnG5aYstz6pFL357uRsoG7jk7LHR98HX?=
 =?us-ascii?Q?qzWmHOHhB4qaPc34FDrhLRTvkaahfjuXhhQLJAFTc/+eP07kCtKwWgbGO5d7?=
 =?us-ascii?Q?eG98ijM8zXKqenUDpPXDw0BPBt/Hk0qmqebd/z3f5neCqo7TCE8vvcNTtaDi?=
 =?us-ascii?Q?e4AkfmiFFj4gZ5vEoEW3bh6rNlg9TwI90vCCXGtruwvs/jijIlXM7tJi5X22?=
 =?us-ascii?Q?R4xbgfUWudWeW8qmzvnNl34qKXxLq92tnSBAmuvu7uzUgmN1OOLd4UtOmOIA?=
 =?us-ascii?Q?zBfzjL4diJNbhDJJ8F+XiSLtQggIeSfj7BIaFth5PYbZR7kZe2sJsSUunl5U?=
 =?us-ascii?Q?Hh44V1gc9fDmb6kM6jFwUrHOulkA34DM3aCOBeA6UVUukq4v74oNf94/EkUw?=
 =?us-ascii?Q?8TIwHi9pszMNUk+yJH1KyM2QQqdWoRm3PzBX7cmhkb1e0mzrh9vOYnWgfsvE?=
 =?us-ascii?Q?ifYol76QVHGp+W9K3nmjbTCs8ElNjy1sXh+/B6qBhsQHB16z3LhwLzJu+NCx?=
 =?us-ascii?Q?ElG68vHiNhJ+kVnI6xZaHQoFaG7USxCFi6uhfEhOsjH+BAyzapqSk7YjAcib?=
 =?us-ascii?Q?2jFa6g2BF5/KXDShQFlTi98wdRb9Rpbjk364QN1MajRmg+bgThquu5G4Lcgh?=
 =?us-ascii?Q?Z4viKYFdfBjbX+8UnKw1+8iX1tb7zCoAk7TSgWDWr0wSdCpUB4zuecjwr7X8?=
 =?us-ascii?Q?HqXNB2X9vexqiSZbVFQCP9wkFapZlLvcRXVlqIqEIwvRgAr0Wja48QBtzrCd?=
 =?us-ascii?Q?6ld1uSYY8QR6zJqPdu3aPKHVoKmYd5Hi8DGWezzIkwOR5PXHYh9j6fQpXhRR?=
 =?us-ascii?Q?YRJw+/VOzpFARB4fRZ6r/typ1A6173NgME4RLKsG8eIQZOMy+gASA2D2NEwj?=
 =?us-ascii?Q?NELUlWPXvOBAcqCKSvI4dptiyD2ckBJn9ryEZqUrZmE1BNLyNJoxilKDU+9j?=
 =?us-ascii?Q?pM69J4rie0OUtT5AxGBZXOc3LMI7gEhM2NLEk/OIHXScHxRESJmgzCCjJe3n?=
 =?us-ascii?Q?Nv2xtx7nRddu2sJZO6j3xIN/F6qQdOpptzpIlKFBrxPbJ9zK1T5E032aTHYb?=
 =?us-ascii?Q?Z8wNURPQtNWb4vJ87Sik8sEbs4VDn2WJQfSCZfxOf1eV90xESw+YxD0E5Oqz?=
 =?us-ascii?Q?WTbx9CLwMjxHIwPM6VKtd2DLx9TUjo+0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2WjY1keKIMDBax3vjsl6D82s6I4nRxciX3Fz9488uaaA1auN/kw0vE339TEF?=
 =?us-ascii?Q?8cG2KkqLqsP/OGPR2VrkL/H/LLMR/Ola4kiOSahHUmmxa7vRjgcUXx61ZOjr?=
 =?us-ascii?Q?QFbCg8VGzv5HzMJU3KQtyVf4fMmASjmC3cN81R5kxrz+k7va/P3WIxTHuBcV?=
 =?us-ascii?Q?nQDvNFnGjhe8aewQOes/gWyNcEq5TfHiYsf+PPgAkhNK2I7SU7WuTMgFYJwP?=
 =?us-ascii?Q?rxU1ZCSJ5HzIslYqbNYUEm5D65DJkUJp03nbLdNeBNfcSvSR7YjfV4Fv7oRp?=
 =?us-ascii?Q?Uowvre3qzSvhN2F/rb0wUTtrTsM6kuPnudzblcpNbUVchWODvC60Gav5V43z?=
 =?us-ascii?Q?8Ah0FvfPhHpUqwvygNqzflcHw9tIaWvW3YnSKLdc/y79ADrnikKURctrBmtE?=
 =?us-ascii?Q?ldjzwS7C8/OSwLDNwjW1nzEVAuawfOCGE61TagwOdFOGa/nT7TuZVIIjMFrm?=
 =?us-ascii?Q?39e3KrgQ5PD5rz5XEn0vsgFTOWsDPHIM75Xx3ViNOmsqSfuVb73P8al1UrpE?=
 =?us-ascii?Q?UvshJbKr0waEf6biJqlHDfu7+JIBYwxyZ3I4cSpNKd1XmWWlS+9ccyg7kQNF?=
 =?us-ascii?Q?romLB780iiy+HEcbD/L5d/9vzlzPpU56St/9Mb3o+8XN/v7euxoQcPtFvzxu?=
 =?us-ascii?Q?/sMV0l1JdPVBUdyEbVkEzSh7XGT6DM1/JSUBo+EcYh6txbRasRjLObyoOEbZ?=
 =?us-ascii?Q?Byx0gNPYp5C1WZjQB6ENi7GUYN5FgLHXCLtBtI927PrvLINSnEc78sc2ORTR?=
 =?us-ascii?Q?BUNcjIovOG3l3xgbvcemOOVXr9Zn4Ii+lxpTGRCJ2eLM64zTkjXm10+TFmv0?=
 =?us-ascii?Q?ae1WwYda/fuOriHECQ5GgSAOO1/2H88RteX1iaRZA61Aj7dzOtguAz/uK+Rz?=
 =?us-ascii?Q?UuKyZpYjj3nzcpB9vyrq+SAnO2bjuqj3h02kwvzk3Ug1LF0mWvA8xUxBQkk5?=
 =?us-ascii?Q?Rm3Y2JDIUJQ5k0aaul4E9pQcN2PG8yqNbbui28BOlWjNunpMVzs38SieeOG7?=
 =?us-ascii?Q?O5DtGYIE43EiOrxUvSafyj3bNkoJfsejXUNyM81FLfaVgqztdy5ZhPCMML0e?=
 =?us-ascii?Q?m8BQyjQJ5s41OxBW3qgtX01AKJDZCSCDd5pwacAxqFj/wvmLijfkvb/4sMwF?=
 =?us-ascii?Q?Q3EUJrDVLg++nfepRtwoJFKaz2ap4BMNls4K7vQLdTeaCcAL1TdnWLQME0N1?=
 =?us-ascii?Q?0TFP0wXr525YDT5Q9MnV2i2Xh38RR4/78SF+qd9OeHTzzYMrF6gCxNvMkNVe?=
 =?us-ascii?Q?DYLcj/7eYrPCE4zybCMrhmqGaUrcAPLiQErwPYYoXSomee8okQSUf7TYOsyr?=
 =?us-ascii?Q?ZZDNS4Pp2cmUFCU/err9O29/TGo3BLbFzcxiFu4T2q6PkSlU9opXtAEnm1bH?=
 =?us-ascii?Q?9yK8MwK3Q7ytIkaMZvP+FFq2S6C+euF/Nx3z/0D+gZO65n+ODHDZfAwyE70M?=
 =?us-ascii?Q?HW/gjJPv2JA6gKARh4Z+bbv42f7vMJymyc7YcnxkP9ACxk8vVlmrQybFAB1P?=
 =?us-ascii?Q?8Gv6V9Sfy7ZvsHo8ynHqGq9Nq0J6Df2hHno+9gTqmCpzCxkXJQPUbD3LTG0O?=
 =?us-ascii?Q?9aWilZ8BgtA3xdnT73QQxSnAN13s6qIPFLRvKE3w?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2461f205-7d96-4ce0-010f-08de0021346a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 12:59:34.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zgitr2VhBnt9VcqtGgKbFJKY/ZPSeUjTEXgsD6A3pFPYt9N8monRiNEoekHi761MZ+9utxQcR9cAzHqToFS2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7450
X-OriginatorOrg: intel.com

On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > double-underscores version is doing a subset of the work of the "full"
> > setter.
> > 
> > While the function does indeed update a cache, the nomenclature becomes
> > slightly misleading when adding a getter[1], as the current value isn't
> > _just_ the cached value, it's also the value that's currently loaded in
> > hardware.
> Nit:
> 
> For TDX, "it's also the value that's currently loaded in hardware" is not true.
since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
invokes __kvm_set_user_return_msr() in tdx_vcpu_put().

> > Opportunistically rename "index" to "slot" in the prototypes.  The user-
> > return APIs deliberately use "slot" to try and make it more obvious that
> > they take the slot within the array, not the index of the MSR.
> > 
> > No functional change intended.
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> > Cc: Yan Zhao <yan.y.zhao@intel.com>
> > Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> > Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Link: https://lore.kernel.org/all/aM2EvzLLmBi5-iQ5@google.com [1]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>

