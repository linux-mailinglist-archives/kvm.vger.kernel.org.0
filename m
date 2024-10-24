Return-Path: <kvm+bounces-29598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1329ADE2A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B2F91C2627F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922291AC887;
	Thu, 24 Oct 2024 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFvZJMND"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE5D172BAE;
	Thu, 24 Oct 2024 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756190; cv=fail; b=HW5/+myziczyevUmLqNvKZJP16ht0a1596E1NMfCy98Y2gFMank0/LUgFMHDcCRcmtrkeW1YhPXzb8pAf9PKlhYdgXvLoKXrk60YaIwnf37B13d5qiEeJX0hKCkYw5H2wO4sBczLRnwB61omnmUTNDGQ1dP/nZ7p4RV4gkoMD9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756190; c=relaxed/simple;
	bh=DRcK6dk5DV7ZuBCF5Pjw2lEX6pI4FtcWrWIP+02K9xY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AXner2m5Ba2hg7HtenLuLkv2xkBc/Li0XPmYPwoL5JtPnpq7ofOVU88nuOuJTPsjseJJUwkWeQNLXrkhJxjkM936bYSsMJoOQlcsYWjTkoYaB7QJi7bzH8D4kEFeJaVff+5DnBWISq1tg7qEuGf7jadF2M1fZA93xar/3M5eXxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MFvZJMND; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729756189; x=1761292189;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DRcK6dk5DV7ZuBCF5Pjw2lEX6pI4FtcWrWIP+02K9xY=;
  b=MFvZJMNDJkeKhkzYXj4hH1orkOKJzYl/DpuHSQi1IM0yLjMq04FGZqd2
   4YkRSEhgbGOkFJVhHJmQVPtaSsj7NpiMhtibUAf1jwjB9B1yMeLG+mdY0
   vUGkVWejCVVCwcSQE7HDZmZsFAeGiHfMgMB1ItrQfTP/rXmcaft5E2Rrs
   DwzkqnjM2IsbEbNLm6SJ+U7tQExpov0pwz4j9pDYDsnaB1oMqLfV9F0Yt
   K9SZ6jvJ8v7WR9ZU93Za56fKzNgfo3O5jwjs11O2+ry7K1hnBGZfMb27E
   D6MmfdLcY5NBOHcFJZIalGAaEWz9p/Vju5GNpzZcRHao5UcLLyudWpuVW
   g==;
X-CSE-ConnectionGUID: ppz5XOXAS6W7NcaDMfGflw==
X-CSE-MsgGUID: LP5VWCMKQGGsCC7kPvfOfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="33281677"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="33281677"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:49:44 -0700
X-CSE-ConnectionGUID: jIgnkMt7RyuxOpXptaKnhA==
X-CSE-MsgGUID: KuikisMSQdmj4JJWUck1Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="85307742"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:49:40 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:49:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:49:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgXIGYgSPl80eHvw2fC2aOBwxm6ZrAk78BBSHd6K0VGic9tEKQXFoc0hovotQdlUFD1K0zVDatMhxZbKUejn+SHcSPsO6nyqwHCIqiJjXehpQI7h2LXW/kOe4Dxh+XwdslnW9ePFsaPcmtgjylNso8W3axpIIN9g0T9TBPg0bQEu2rfmuP49dB+wCZNNUSD2sjbWEZPg6hEHxaIL+XMdLPLDHPXC62zX5UDfDLAizi71KOAxM5QnHHkxOf1S/l8mLdthB0tuZbfBeMJsvLiZl0LgR1HwKHm46wNEjzO9/ywllYuKQYQsNXjlKoZibdYDio7PHSMoezA5I5BNOaZjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23gEkbHSWTewQExl73rpyE0/0/JWoScrUcDXgB5NZ1M=;
 b=r83Qq7Kvkz8S5aoLarllL4Cf1L+vxmKI9kwVpo7RPUlHIg+y/CVt2sdf8pm7H3fi335uL8yjvL9DpewkP1pyyBRDt1mFPPwAxOiY9LKFKU/f/lRNEYH6Y+GfkRCmHLR9j5Mas/zCpZ5r7fE+szJ5LNr7Cs22cB7qL3d9mC7yutPgCPbb/dc3zm85q1aSITJ5/K3OOwFKOGiHWFgPe2neGg6Swe8/uQpz0kvBXr4dhAd5k050P8Tw3Yl22IxapFzCSBFqAUJ7n3STRvu/rgFRZ7LAgTK3sJYL/luiwhBLxJmC+P5/e8df/Oy4KUzdaZt8E087dd8V4rKtG36GXFgn4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Thu, 24 Oct
 2024 07:49:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 07:49:36 +0000
Date: Thu, 24 Oct 2024 15:49:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 21/27] KVM: VMX: Invoke vmx_set_cpu_caps() before
 nested setup
Message-ID: <Zxn8BX6vxQKY+YNF@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-22-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-22-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7ab568-f699-4226-8a6f-08dcf4006843
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1Cb+h4jnIksbR1TIl1rfDHDJ3JPeYe4nJkbTLhj+RuSxeX0LVkPUnKBPBIn1?=
 =?us-ascii?Q?AKQ8kAWXPKFmEajlLiksauqLMojZkbPfKBzLvUoV9/1XtwjaCmuIWY6+kbBR?=
 =?us-ascii?Q?3f5b7n6lvuaIR6Ognt/852yucO6zLAKN1qLCGOvmXSE0bou5YZ9Qd984Ixh3?=
 =?us-ascii?Q?jVio99jQZYtA6pfld3Ze1WqnooAwiO53AN1wrRfEf0JOTYBr+9Rmt2nisbIV?=
 =?us-ascii?Q?MWr5guEqGzQkmMrWv4iIpWzmsoWKg3hii0f4LwODrCBUjaMAUnhiUZ/Iamo3?=
 =?us-ascii?Q?/GqcgDHNVt6pYeujlRnd6XHmuudpZgPmykmjIOimv0ygpsw/P/q1bdNWPJcS?=
 =?us-ascii?Q?fXqTnK4h1BtBOVL1A3SfzBsDMZ3Zg0XZ65ame257FTDpNugv8h6Li3Olyj0r?=
 =?us-ascii?Q?Brup7ShYo7iI2C+/qXA1psA9x1zxAzl3ladVb3walKT+JEuPCk8Yb7Uq9Qn7?=
 =?us-ascii?Q?e5TdZ/TLgKtsfiUaOa/clj4TXovAAYqib5guE+/6QAYHoEP6ULdyNj7Pz+Ai?=
 =?us-ascii?Q?5BKkdjchfZGwWlfbMjDuDyPbyRV2wgNjAhmL+ROtH/raufvc2qNrVc04iHLY?=
 =?us-ascii?Q?WnNrL7eYxtzwnpxjj4iMJgRJpgdVCiaBVPsJ1ZPyZvUpsBvZWGmAufn0FNDC?=
 =?us-ascii?Q?HBHWo+VnuvK+bTuJsjuBonIw4/9MSWGNnPuf70HXBV9IcgN1RvX0e7XFF1N6?=
 =?us-ascii?Q?vqJEZYJk0B8vurrtZfdzphRJt+IiAqBS+MTTPlipfNjvCKhoCZcdzz7HEtgN?=
 =?us-ascii?Q?ZQG9bTOu2WbxhnsB/LxOMvG+5bxiSICHtcXgNtgODQkTDPjPdREdWVhM5FRm?=
 =?us-ascii?Q?VTqafCEPHw9kKk6e/xkKq18IZpFJiPZSE3oM21m4Dx9wyWgYm/XvkdNe86DY?=
 =?us-ascii?Q?uoPYGFw/2c5CCRKC/PF1DS0RD7RO8vv3PxLcXSqupLK5fU+Sf23/wGRzMnNp?=
 =?us-ascii?Q?KAKfNqnS4Zx7GRVrAg5KxElIEHYheBBoNFaStiC01RHdKP/toEwd+MjEPDqQ?=
 =?us-ascii?Q?LvNcrT42WTSNOhhnKSAesI/oOU2s2QiUsD+g1ROP3cFc4o0KrXb3ivxyL02x?=
 =?us-ascii?Q?eE6wlFQUixzk3qoYUYRBxDeHGX6GQ+9tQUZqUW0e8Z9A4uQ0tu6moHiEQaa7?=
 =?us-ascii?Q?epSAQWQmqcmajGliaQ7bach9MwoROjlHqFm6D1oAhGg3Tnazeq/jlAtFkTqe?=
 =?us-ascii?Q?COYwmW21GSn88zwRwHet6WbmYBQO6OoJVDkFNwNtq1YA77ZJfikKUze+e6wR?=
 =?us-ascii?Q?0cbO4bSf5n8DX1BEHyrBOxF0wVxa9SeT5B1/iOh05Sqnxgg/XcmmjUOlLK2z?=
 =?us-ascii?Q?gere58VDZSRh7ROfJ4a01E1R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkSjedz2cEzJNn7f1ZbLMbnczKWe7RJvrK2uTJhfJzl0qClVo2ltoZ0gitEQ?=
 =?us-ascii?Q?dHUWMfqI7nsu+rwujU/nlGqLwxp1DTDbQOq5oPnR2pSyFxJUIIxk5RwDaQ6y?=
 =?us-ascii?Q?6udCqb75tBXFIa2SGj1x2zpmoCbB0b0tSiGW2Dw6EmjkB/9K7B6twWGcMS2N?=
 =?us-ascii?Q?EsVb3qSNOa5NgvpX5AfgayDCuLL4ccVXCfLat0Eb+Q1feP9Rt8wx0HGruXg/?=
 =?us-ascii?Q?F+uXxcHU2wDFi7a9rhsS8uR+YJWlPpGXST4TkBC5WD77dGd7W1F/fqnEnxTQ?=
 =?us-ascii?Q?qhaT1jZaSvs/BvjPl2IjXl8XMxQ+6jL2F3gYMDnrMWkCuoJ6g6x2If/4nv/b?=
 =?us-ascii?Q?3XdXesOodl97rhqQWc8q7+kChoOcIyrCGAyuKQYFrpYtCC8s4vS/v3LcspvK?=
 =?us-ascii?Q?VSvgTZmTIVYQ5ZZz5F7sxUFR9aHeAf7T8bsvz5yai3MoMgUsF3uD7LumMd8O?=
 =?us-ascii?Q?yjUlhzV1DturMKaFm1YBTsVRRjalTNcxtTIJSkOadYHCywjmMxUuJRKxIw5x?=
 =?us-ascii?Q?hh3qcVYWtc5/eNgoQA3cwVwaflDUbH6RhhEOzTbNqEQCN8xora11Lf1YH9NK?=
 =?us-ascii?Q?PqEc1KIX3e82qwyiQ7MRNcD7a35jRmfrvhZqIlInoOGaTSrEXqNlpFhnVHcN?=
 =?us-ascii?Q?B/GGtw4uvQ0lTtr42UM9JWPyWoKJKCDCXXIf17LuNd7GJSKpG9YEarQGgUpf?=
 =?us-ascii?Q?8YGoSanyyFZE7U4ycCwsJU9ytcx7py6C7LCrKO8BE0aeNe9aBImgHIbfKmRt?=
 =?us-ascii?Q?akrWc2s+6+O3W8QcLUyfbGdvzEBRSoxOrxd84TMP180KpZFqph4vwfW4SjjG?=
 =?us-ascii?Q?s4oQilBBux3xKaCcN6AKWSUlLhqOuUG+oY0AF+B8hG0yGbVMgkFXbCt+rcq2?=
 =?us-ascii?Q?LPG2K+2vlvbtbqdgFSZdowQgkDF+PF5uPY9AfGp5zMStPSs4F+MffPHTjoYY?=
 =?us-ascii?Q?sIbI2589MLGvHYLteYG/f7Bysubd68MH1WjyK/YUpfaz9qQZxcOcx+782p0J?=
 =?us-ascii?Q?ibJFtpXnmCMwpZjY4PPdLVjExbWhYIyLl3JYPLMYlOfx8QZHWHqh0ZLZg60b?=
 =?us-ascii?Q?DZIbwhqbDPxgJuAuHKXm3/8hnD7kxc/rM12vFnQjRY9oCcJoGJqSyexGyonM?=
 =?us-ascii?Q?prB/RuUst+pifOF38u8WagBh4QtDdBFVceE5dRJW3wlblYUhanVXW1ALUjNt?=
 =?us-ascii?Q?knMc1u+1HycGvrHCZQAMEUhVOyjUffBG8ID2PFf+PZfAR+IembNDdv4SRiJH?=
 =?us-ascii?Q?3M6MG56EAZPj7Lqp4mYhq6JgIbCOktPmI9at1GHjPVcLQ7BjLDcGVfw3U6/6?=
 =?us-ascii?Q?PwdudHOTTvNFdmJePFgpINvesn3SjqC5cmhTLKIiBAfkxwAhW31612qi9mqZ?=
 =?us-ascii?Q?1QeO3d1rgY6snkTMtIIu+zxySsq/m89K7PfqKN+24PXHcllR2pX0MhfOPA1f?=
 =?us-ascii?Q?WE7ZCirtyWpZhYxPEcpKKgtjZxxdZp2KFs666W+t4r8/Mr3+Md/obg55S3Jq?=
 =?us-ascii?Q?uZpLg4WM5pvDaYF2f4o7kvQcFGDnlTsxoWgb7cM6koCB0y+3YfZgDWoRzQZ9?=
 =?us-ascii?Q?FIwGiBrAGic87NeNx0Y9yR+sVE5eHOJaV8lXrL5f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7ab568-f699-4226-8a6f-08dcf4006843
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 07:49:36.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7XUGluWkjAfEC/uwObcdvj8u4e3qYh5bzkXVlStpk555FelWKY6csq9ht41g+wvP9OfgGgPD5LX6KYGHLTx7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

On Mon, Sep 30, 2024 at 10:01:04PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Set VMX CPU capabilities before initializing nested instead of after,
>as it needs to check VMX CPU capabilities to setup the VMX basic MSR
>for nested.

Which VMX CPU capabilities are needed? after reading patch 25, I still
don't get that.

>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index ef807194ccbd..522ee27a4655 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8774,6 +8774,12 @@ __init int vmx_hardware_setup(void)
> 
> 	setup_default_sgx_lepubkeyhash();
> 
>+	/*
>+	 * VMX CPU capabilities are required to setup the VMX basic MSR for
>+	 * nested, so this must be done before nested_vmx_setup_ctls_msrs().
>+	 */
>+	vmx_set_cpu_caps();
>+
> 	if (nested) {
> 		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
> 
>@@ -8782,8 +8788,6 @@ __init int vmx_hardware_setup(void)
> 			return r;
> 	}
> 
>-	vmx_set_cpu_caps();
>-
> 	r = alloc_kvm_area();
> 	if (r && nested)
> 		nested_vmx_hardware_unsetup();
>-- 
>2.46.2
>
>

