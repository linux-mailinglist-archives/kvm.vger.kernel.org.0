Return-Path: <kvm+bounces-30447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCD89BAD1B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637BD1C20DAB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2102197549;
	Mon,  4 Nov 2024 07:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdHXE+FV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE023AB;
	Mon,  4 Nov 2024 07:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730705364; cv=fail; b=SSoQwWxJe3BUlS/0xcmkMVzUy7mCCY7dtbk8TX2UK714/6kDlpkn4hNPRzV7b1wu4lWOvrTcO1XjlYcojNk5ywp9T068/UJsANIShzQLwPb6+YM/us5FSwZNQnGU5cmL96aV337DftEf9cS7ZnEYHkqshnfODAnrxTenUKgFCo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730705364; c=relaxed/simple;
	bh=+E5npLsTJKjA0MZfOnvLDgaVaG++FKN+3nhhlEi2dyA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jRQkhkLS5tqpzTARrQmEEiuKRPZ0PIg8CYrgD/kkqQx13h/qIwVK8z69ncbRwYDOiH3Q6rMMcU5/BjT5+Im1zyMdxu5xsMJri5is4GYjELwDASLVEe5kzfF3LZ/LyAtrQS1JBG66x1vfzEo6FTbqMOBVHtXnboYNebCMsMfuVhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdHXE+FV; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730705363; x=1762241363;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+E5npLsTJKjA0MZfOnvLDgaVaG++FKN+3nhhlEi2dyA=;
  b=DdHXE+FVSoC/vXpDesHZqpNbYgMLU65ZRcbzB5AFtW5xbM2nbhGv2+z+
   v4EpvO4hGhJTHH6qeElXvOOEetgstuaMB/e1yl+3+W8E9KNHBsUvkJmWf
   Uc/8wCZtNWcKq/HXVQwuqVzB/wXpwDUYniFU/0OiyWz3vOxVzHeXmSPlc
   6vHy+X0uqoxz9Ttr35U3s4QQX92MbP1KSkb2ol40KRIOdTZ91GDkWYFho
   9e+g0dCzNeV9m84116fYs8Kxf/vFLP6a6avF9kGEw5qvyCpw8YePbihOS
   WIzALDSjX5cKlPb3GZew0JNCvZ1sJoD9mLDHQQ2Xs1LWZIcVzjl1oi2ym
   w==;
X-CSE-ConnectionGUID: zJ5wUCVfQga5Wph2p75tyQ==
X-CSE-MsgGUID: R3dIdThJRdKGCMMcnKCKug==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41779721"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41779721"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 23:29:22 -0800
X-CSE-ConnectionGUID: 3AKUYgErTkiPNt0SXTx7Eg==
X-CSE-MsgGUID: +Xky6gXpSBG/AA48yZt+nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83500069"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2024 23:29:21 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 3 Nov 2024 23:29:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 3 Nov 2024 23:29:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 3 Nov 2024 23:29:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6cswm0nLGJw1UA6FUmewPa4qnNBIfpUe9ErLCef5WeH7hH5gQqdyEN32uebIWxi0i50AvgVFhTtV1BXa2enKw/z+PNtnHsCl2dDd4nkwGHONrb+DpUM25DSvR9p5u0rbLA3Umw0Oh1kVxZvprdq6H7NNHj1YHUShJCBFrrYBCPU+ZM8J/oFuWHvZ0LD8QhvZivg4nNalVsMZEzcHHrSp2onCndQz0oFkMP3ZrKWBj2n3IPR2JwvnPwvZLRx+1z3H9abt3O6EDd9YLP0aVTG9WrfG1//VCVoEeoace843xTPYZuXE6fCQjdk1hI6isLkPU/GZGSrEEZRQLRewLzLRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZAz8lUUM8pyB4piw0AkNtRiIf0zIZMN6c3KQt9YX4Q=;
 b=vR3nBmNz9U3EUMOmUgyjJvBkwWZltyKNZqrzsAUVm3wd1lgPU3jJ8Ut/PBEfJTDPu16KDeMmTQQqg/bX5xaa5PESp2b3Q1PMgvq2Y7Rd/e6IC2HWY7BLgM/9UVcr4nPkc2KqYlkNfTfaYsrZZf37j8nRCq8kKY/Jx8rozCh6KwinrWx76qxPzXo77PONg72SH0JOYM5y8ayMjy1Q7HqUrXFvKnRAxOC6Ai6fgtNgd3jhyUTsrsz/sSdw8zalBGQf24dyuEdmb8KqM3+SWPrrOs7FVaNaiXZtOiBczVjTsS0P6xpnTr4yFhzfDQgPoqPPv5eQ0qRZV9BNFdFC8PetDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Mon, 4 Nov
 2024 07:29:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 07:29:18 +0000
Date: Mon, 4 Nov 2024 15:29:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Markku =?iso-8859-1?Q?Ahvenj=E4rvi?=
	<mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Plumb in the vCPU to
 kvm_x86_ops.hwapic_isr_update()
Message-ID: <Zyh3wsWVvP2V2fNQ@intel.com>
References: <20241101192114.1810198-1-seanjc@google.com>
 <20241101192114.1810198-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241101192114.1810198-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 343c4a65-82f8-4949-d38d-08dcfca26495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZzuEcqq43zEbcfvZf9J106PV1MarlJUAftV6ylk69tFtt1F9NJoNvG9AsA2/?=
 =?us-ascii?Q?xiM2M7Tzv+mh39sihE+qlT+7OArIcmMUsF74HpD885IsKbNhiP5Klcbi6T6A?=
 =?us-ascii?Q?QxqsSsuNpxLtcSeIAq/zO7tAQoN8qdYwgekA8/XibbYiwiCH3DGyffM/Wcoj?=
 =?us-ascii?Q?e9B67Xf8oA8ugijCdk/RVlKXyr/JIdDs3M+SCaXfMfxMje1DEZIRmFcYBA5G?=
 =?us-ascii?Q?jfmePwd9ooTQXls/cO2Z9bgeQRqeIGgVqFoQvFl/aY2WNMLSkTOgiOsKuRij?=
 =?us-ascii?Q?SmmR6bVbicjXDcSpwJrZS9wZhAFyjPlh8VENd4+CaQFHrDUcSyqf7DO/8o1S?=
 =?us-ascii?Q?SmWdMFG8YbW/cZIxLK3h5AFLcQomJfx0VraFd1uhgOuRySRn8W8byzm9OVoG?=
 =?us-ascii?Q?IwKey3QSmrRb1srWMrD1DK29n9914o+/8oBh9YY3ee8mHR7a0MALwccHKc3E?=
 =?us-ascii?Q?JOMi0ay95L9SyLYtP0LRwqWl2ZaBhyHPu1nN4FeGBJ7ho4gl5H/V30V2byog?=
 =?us-ascii?Q?CgHfn5kgjX1pGUJNTe2U5cPdd9eOf6FKmjwxhMAKNtP9raL/Fn3SXr4gIl6d?=
 =?us-ascii?Q?Ko3LSHjWaDdpc2BGFv0wujMHNZgZI+i6wwonOVYw9brZMPLIss2UqBThnZLr?=
 =?us-ascii?Q?P4zXRAF9YUU6hkKtonhZLiONzPrFnZ/p4WgVq5hXfCV3T+fOMIALRZVR756/?=
 =?us-ascii?Q?81CdETT9yNQbNYM/o9FkqWRFzwaPm00e5FI9WOV+YCHJ7iOKxqaj/7XBfcAZ?=
 =?us-ascii?Q?BtAt25X8KELSW1PySyA/9IsXfEjJ1mf962p1sjjVcG9tAloJZfxttQ2G/iUL?=
 =?us-ascii?Q?UG2yM3VEwrEyH6pvFHunJbWdVK52jsOsEoD8gILjvHGkl/SZGos1Ct5OdKWk?=
 =?us-ascii?Q?7fykeyLVHJy3O5QcbNBpLTGBnSMlzzUvaoEbV3ZVi9XPjhX77SPozlXaH8ZD?=
 =?us-ascii?Q?Y0LObvqv4uIF7i8gNxeuho7qH47/m8rqmZhouZicH7MvDQg/82yzDMmVH72l?=
 =?us-ascii?Q?4MFtFO6m81wQ/k3M/vH8pDiBeOwC5sR+m6k/NkoYgncpO+W50jLS4h01RdRx?=
 =?us-ascii?Q?pKU6gxuEgbSkk0WBzW6vZ+h59+Kvw4jyWJ1mOSFkHMJuytkc58wEUJnawVIX?=
 =?us-ascii?Q?eYAcv9nG2WqHXMReZ0zVwuk2WkckIVkq5scrFl9neJRM4+8W/N9J2BhQBZAJ?=
 =?us-ascii?Q?JzbLEiGE7c+8VpWBxv5S3tnDwnSq9ESi9t6vf4NGowSOkYyPEndeMT/BaC0g?=
 =?us-ascii?Q?nkVYDrMVgJZSJZwhvFr8k9E1ejXxFfnn4Cv0Rc7Y4AUOVMP4lbh4cb/BhEOo?=
 =?us-ascii?Q?4FrXj9kyTadLmG9oPBqVVtSG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SRiXkNufLee9S3zjeJkC37fvBS54v7w0CUsDd+Q2s6TV8xhCx2Qzz6Xxc6H?=
 =?us-ascii?Q?wKMlKTku+O9pyUEHyOLs1oIIYYXbB2MPUUNG5uPzujMGTxTHrernsGlVb6A/?=
 =?us-ascii?Q?Cuc/902IJqZt2ujec+SscVYDJYsHBrY2crg9W2Ex2fTxmE92sFK86AsDagi1?=
 =?us-ascii?Q?t03xAwcykTJ+xgvQzJrKCwNLQCLbrI9egDLKOLw2nqU0CamhS2dYQ41UUUNG?=
 =?us-ascii?Q?MntRDuw0RhyANBMQByKCewpG3y5oZdtFIcE8a2PD51HErlkkuXyEHJlRj3aW?=
 =?us-ascii?Q?K19d0hmMz0xU4Bqql+BTVkFEDrrxXmwQRLH8HL6NTbwrxeyXxFY7Td64m3rK?=
 =?us-ascii?Q?pjwTwJsC0VzyNi35RF57fy42srBICjwjxaat/X9ov4uzl3TsJnc8xtfPi+pB?=
 =?us-ascii?Q?6CNI/BOFO7USkClDyZIF97Jj6rKJ439eMJ73U41+gipCVybbdk9kk5pmuszp?=
 =?us-ascii?Q?5ysIhfY+sVRjKfxYP5koRkOgEhGiYo+EPDYOGz96mpcyHdGdKazOUE8B2s7z?=
 =?us-ascii?Q?Cq/tF36NCG9YGiYqmyYp3+bVt61gif9qZLZqSgJgKATpGMfGq7B1VsdiyirO?=
 =?us-ascii?Q?bQ0zDNyj7xmJwVTCK2WbMN3eM41SHgXYjsUI62tZm3XboVqfdmdof7vs6t3c?=
 =?us-ascii?Q?tltJ+gepcdrvFjrQUCuRLmJzNjIBOHC7GKvPRQiWiVf3Q7wNrlL5WZwHot+u?=
 =?us-ascii?Q?uf2vt4e8+lFCrmLa6wX+zBrYKMyUTBg3qlGIW/qWJPkmTvZC1HZjQdOFQpge?=
 =?us-ascii?Q?Er0gPMuFfyyzvK7mr9ZUE9H5KQQVUYUL5rFeS+XJKOu2N6MeK9QtLIqy3sLM?=
 =?us-ascii?Q?rMhtnjr1SZZEa/tXSFYelRd4ZOlL3P/CvbV/iz4Hh8eAaOjMF2JIhZ+IUw2c?=
 =?us-ascii?Q?CFb+QBKdX7AkRkmrgXm/X4TXA3D0bFWHK+yrGJv4Bd6+8JEZ9SVDVVEJ6XrW?=
 =?us-ascii?Q?FZ0+O0Dgub03bjgxV5LahFiImqChulJP2cjcT8csTWzInq6JBj9hQhNuqik1?=
 =?us-ascii?Q?qq1CzFkMGrz4UL50iDD0Tti4OoL9hnNqHBIk0vUP5UgrENN0kNsrtxSoQron?=
 =?us-ascii?Q?yAe/6XskzUo3AlwWFxvI4/6Kd/uZfK+rnkx+OxAXM+sjpmDZaX1B2ncNgmVi?=
 =?us-ascii?Q?rmXjdZQK5288eqKgKAiwbsM+ASX1BOjvtgb0ROWj4iSvoye27O1CnN25OwbQ?=
 =?us-ascii?Q?ZasVnhEHb2KXFBgnd+WEtGq6k6g71LosaP74fVirj75oqp+L7p/uSxE6lMXo?=
 =?us-ascii?Q?NysVUM9nYd8YEYs+y+AJC2lRPmJmjYWy4lgvytCgB4584ITRIOXoEGC8RaXw?=
 =?us-ascii?Q?2QNiyUhdK5pL4PqY/Ks69lU+R3dEnsEgOUhnMgYQY57xlzkYjr/6e23xYfjG?=
 =?us-ascii?Q?gGGgpKtwZzTf5pdIVPVDq13p2WASeN926DG8Xm1YSF9zjndRhvnqjYjdZhP1?=
 =?us-ascii?Q?tF2tARY96kFL70VPzgEuQw0FziGRZPyw0vj9/f1QQoUEZh/bOcygLddL2aLf?=
 =?us-ascii?Q?Rts/ZQqa8aO4OffJMdI1G2o7j0PT6/9z4sOQwd9+0eG+RQlpIp2V7bzOPXBF?=
 =?us-ascii?Q?Dc2DftQK6Kw/FibsX8mf2vrRmNSBSwSbYhGAwYac?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 343c4a65-82f8-4949-d38d-08dcfca26495
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 07:29:18.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA8E1J6ClRG8z8cYEElja6eAexY7crrNrkFkpGo9JkBErE/R3LEKQNZXTIjSokGDW3BdhgwbI51Kl5oJNfjUrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com

On Fri, Nov 01, 2024 at 12:21:13PM -0700, Sean Christopherson wrote:
>Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
>can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
>occurs while L2 is active.
>
>No functional change intended.
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
> arch/x86/include/asm/kvm_host.h |  2 +-
> arch/x86/kvm/lapic.c            | 11 +++++------
> arch/x86/kvm/vmx/vmx.c          |  2 +-
> arch/x86/kvm/vmx/x86_ops.h      |  2 +-
> 4 files changed, 8 insertions(+), 9 deletions(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 70c7ed0ef184..3f3de047cbfd 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1734,7 +1734,7 @@ struct kvm_x86_ops {
> 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
> 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
> 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>-	void (*hwapic_isr_update)(int isr);
>+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
> 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
> 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index 65412640cfc7..5be2be44a188 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -763,7 +763,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> 	 * just set SVI.
> 	 */
> 	if (unlikely(apic->apicv_active))
>-		kvm_x86_call(hwapic_isr_update)(vec);
>+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, vec);

Both branches need braces here. So, maybe take the opportunity to fix the coding style
issue.

> 	else {
> 		++apic->isr_count;
> 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
>@@ -808,7 +808,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> 	 * and must be left alone.
> 	 */
> 	if (unlikely(apic->apicv_active))
>-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
>+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));

ditto

> 	else {
> 		--apic->isr_count;
> 		BUG_ON(apic->isr_count < 0);

