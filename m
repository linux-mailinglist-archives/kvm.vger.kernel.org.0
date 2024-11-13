Return-Path: <kvm+bounces-31721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8D59C6D2D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00433B24906
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 10:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBB51FDF8F;
	Wed, 13 Nov 2024 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmiSaAUp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03594230984;
	Wed, 13 Nov 2024 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731495202; cv=fail; b=tkJUa8Q3tR2n95gq5JPeAxnvfGhubjgNmAkPMeEMU5VAwIX4UMp64tfrMyqsWTWXaCYUgAen4BljgYTagqSnmm7gD79AAe3EzLR90M2ZoRZZG+yivGbycAopodYXh5idL88CcmyCLTyemBawrvp4pfKJRsaXrum0UaHq+x5KP30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731495202; c=relaxed/simple;
	bh=vAft2siuD3YQNuYRTkOQvKkhGxHNte6Iz04tTF+ghvA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bYb6v7FUime5KDh0lzZxR2OnsdIIDU9j9KfEb5Xo/g0eNTAEs5rVWkZGHxq9/PDu0t8fHrfWzG+i29Mli2QCQ4/xGl3fUpg268suVPzvqsCuaw9+2QmqZEkDq1ymmszFl/rtgr9wNq1k/TxcwXZzMdqLquyEGIOtfSWgQQ4nziw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmiSaAUp; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731495200; x=1763031200;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vAft2siuD3YQNuYRTkOQvKkhGxHNte6Iz04tTF+ghvA=;
  b=XmiSaAUpWFtW0IeAsf9l5F+iGyuF8EyLeNZhHQYDRUeql29CPfa5zK9y
   ZFTnicoa4G4JDE4p3Q/OGaPGLwC5ibDiXBmSNLb3vNdGK9Njj9vKrCD7G
   yeo0Ys0c6WRj7ll6fcMt7TA9FRHfABlmJYN8JKU4RgsJsHyQ7vaEZ4T3f
   Z87iyz0puskNkY+YmDIijw8d/8gjgC1bfT3xpv54QAwEQNnvOWEO9q8xS
   Z9Cmc6CYESxrY8C2qCnbyFENa1vMFv/p1spRJbx8tQtuCpApX442yryTg
   OhdcD2OcTogWi5TbfEEdiOBYHC++XTfF8/1Fm6T9gNqR4PkCKDdsulpm9
   w==;
X-CSE-ConnectionGUID: ZXLYRAdGTxuUM4A2AekeIA==
X-CSE-MsgGUID: yFuc2KGISVG7jg9DB4mtBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41941223"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41941223"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 02:53:18 -0800
X-CSE-ConnectionGUID: qI3zeXTqSP2uDHsqml3PtA==
X-CSE-MsgGUID: KQA5N58vTl+ws3xPYvtK4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92768940"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 02:53:18 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 02:53:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 02:53:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 02:53:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GwEbUU4MJXzbzwbxTEIqLLaD3ENmpkombNof6qv2elj+ZBowBINH7RWgXncxJ8veDnnX12chHo7L6eq64DqbDZBZdNFn4iH1o8YbHWCPxT1eZ0rwh5JxgaeeaFHRJ7QsdTkZn+3AooIKOLYpxp/Omf7KnE5k3G/d3VPzRF67aHGrb5hUVghnfORf+6KHhuAB8HArN45onxJRIo2+7KnuLv/AlJxtIhYi8gUrhhmiQRrIj8R4L9rgRdOV/6aojIuTdEum+qXFqfKxe9ieV8dX3WHmqOsms6BW7283U7VCxrd1NFCWAOvT/iS+2GX93g26QKJ4e6P5yXmz681PVlf0Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qtmo8mi0enWyXsLE9U4rmtr9dt5mb0chOxbQwmgs+70=;
 b=RiuwH1cgxnF+Zcu9Um/TdPiYMoODJCQQnaxQou4/1MwqB0nM3wOaz2uOyg3o5ADIzw5XpRd9OFsNX+Mkcq/ikGycxzCTB2rQ9JP0927sVxzrW1UJv2QI+yp6OYlRTlIyffLYUZUJmyfwVlEn521Q+h99tU/m+OLgnfTFF+ceanYHaxU3w1FIbOle1wat7kbUJQWXRr3pEo3cvwlVJwCN2rT0S4VWfCbBrjo1RYUvJnU5MLQ9dCHqnMoZ1y85KBGPbKSzce/fWwKJQQ8/HaBHx7SX+WU0D3jYPSPc8KqIhSzJrsDLjIuM7FK4C7BAsF5v20vGE4onNFn/nBCDLVA1Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB7252.namprd11.prod.outlook.com (2603:10b6:610:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 10:53:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 10:53:14 +0000
Date: Wed, 13 Nov 2024 18:53:03 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Message-ID: <ZzSFD3OTjApdUp9w@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <ZjLP8jLWGOWnNnau@google.com>
 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
 <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
 <ZyuaE9ye3J56foBf@google.com>
 <ZzKiapQZgn0RscrC@intel.com>
 <e1ab320cbf08258176b246906feba1f2ba4e1cfc.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1ab320cbf08258176b246906feba1f2ba4e1cfc.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0158.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: 7514a4a9-2040-4b54-add8-08dd03d15fbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?fukb93k7qUlXK1x2Gr4r417vPgEp5RtbsQ7AxRuCL6Gidl9j1IIQjExYZJ?=
 =?iso-8859-1?Q?J9VnmQHQ462ksLDV9kfPkus3jhXIn3BTfDB5DlqNi5Xc/1Ov2BQn4fCaM4?=
 =?iso-8859-1?Q?KsmQQwwKfZCR1xq3mlfO7VsHOe9Q9E25CtDZRs5FidSLMQZOuDuqPilhYg?=
 =?iso-8859-1?Q?QD6mlWnKkogvUzaXYuwyjf5h8au25vZS0uMZgHU8dkXY7FnrGeGam1LaIq?=
 =?iso-8859-1?Q?nYjrbt3GEPDZXaD22PVF6Tz6PYUN1vjv+Ajt725vJCakSe0fpy6M2MVboO?=
 =?iso-8859-1?Q?py/yQJ2agVheRnUr9lBFuXW3WajFHqez79YuvQ/bddtrJCGObPMZTtH1Jd?=
 =?iso-8859-1?Q?B8rUquN4irwU/1lq13gZ1ywSJ2bXG4XRoW63cnZUnjD1ZE57HBQS/ZCSeN?=
 =?iso-8859-1?Q?Umwolm2i6iwSS7v48hQ+EtfNdmuntwzKrxqSR8kAhCN4BTwds02hfu3SBf?=
 =?iso-8859-1?Q?kxCeq/eZ+wNUoUUHRqja8j8Rn1rvEc9rkDwpB2bAr2c3yvFRxYQNp+uQD5?=
 =?iso-8859-1?Q?UeCuInPZQ1i3JkWuZ5QoSuQSyouix8XsvBdR7ueb7gGNoJN+YKy1rwGTz4?=
 =?iso-8859-1?Q?8jouoAkYatl2yFtDdnhMyzO1o6w3USPdWa3cDgy/iTYUJRd/5y79bLTuyE?=
 =?iso-8859-1?Q?M218MIFg6uVUZFJoGqqlXBEC1nmqUaUvMXC65i8JuefeCqRuntlgjozbi5?=
 =?iso-8859-1?Q?bgqT5EZVMxVyysGc1K7TjaRa5lOhxDh5YuFYwPKbSOPaV5ckeFQMA0exwi?=
 =?iso-8859-1?Q?owgWkvU4OxsTO42LIjmhMLcQP+CRkOT3JW24vG1TXIDhZxWqrQSFEz6BJJ?=
 =?iso-8859-1?Q?FEN/e8Org2uJQ7ZywkPaFMcB7a0gB4osMWP46Z+21WwiiiztAezur6VVEY?=
 =?iso-8859-1?Q?uR8JOIxG42yT8jCxznL3uzlbja3Huxjjdeuw06356hCU+hb2bIYET1zeOR?=
 =?iso-8859-1?Q?wO4bh8IHZZ669BHDu/DmmoJepWZvs0qDKaasCI3uka8q1xTSJ7dtnBOXQO?=
 =?iso-8859-1?Q?gyWrAoBSdTtvRpX2sOmFxbeJiPBuaqhnvoWB/pGZDCmlrecnUdcsN3+ZTF?=
 =?iso-8859-1?Q?l+pnTJi/MlLlrL63ollINiEnVuhQn88dHhUUZpuQdoimvkt/ICMB+mPv/J?=
 =?iso-8859-1?Q?kK22RfN4EviXOnt1pQIBXsl5IORzKezPONpz8dARcoN/wEupWg71d6dwLi?=
 =?iso-8859-1?Q?H+Pe2iqpYPcgxJRMsrhWm4gq9vjezJW7Ap3hmfyBwrnwGZiEjBDLQUnP31?=
 =?iso-8859-1?Q?orw9kfGk9foD2y6NhKoE24f62oGT4YS6bvpWlkljKv2VngqyCp1f+dlOGJ?=
 =?iso-8859-1?Q?7yqdV/mVMArz8uwlyR8NnHFsoikNLYIOtmc1Ir0INxy20MD+DS11oaV/Ow?=
 =?iso-8859-1?Q?QDbih+Rcta?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?jTU5suF7X8mV2A4TtUOOveNOSEge+Krva77f3qsYctcQB75JpjL4lp6fKn?=
 =?iso-8859-1?Q?2swhHVuB6HIkgZ6neiDVqlnVvnfBiTHZqVNOPgrMRYiENInUjrGanhHl+W?=
 =?iso-8859-1?Q?NbrKN8qYZZAggVSEModwLCLWauUEQAQPsDtWu1nblrJyQPv5Krqyh/hx0Z?=
 =?iso-8859-1?Q?BP7mkzdTTa6tkyLPYBvb1GQDeLOZscuQwpAvndsbaNSY4jrNwLX6vtbojr?=
 =?iso-8859-1?Q?fqQSMfqHHkXncJc002ugl4286Rlfvl+ofiomf4HQNR/VyIzvzv0uYwx8Uj?=
 =?iso-8859-1?Q?DRwySeDOUi0uU7D3mHINuWMaXhrY0Yg41TPNlc7C5jYS1MNG6YludvEppy?=
 =?iso-8859-1?Q?wid+CAmiljbHMTkCtSK5XRIb/FLOcn98VwpMweUCN0ZafYK1hOtyAaJ7Cm?=
 =?iso-8859-1?Q?1PDjsao7lFA3cWwqRDSAhE+19fTU9wXjuuvzTpUs38rJ4/NO6PF8wRnAT5?=
 =?iso-8859-1?Q?zO4UTfwkPQ15qA29NU649YnfMBS/GCK31829xltldBygVSIJRiH20D2q1Y?=
 =?iso-8859-1?Q?Qw0NtzmKMTHel/NZRkBv0as1tBLvxSeRrCZ21+PBH2PsPmu80mTZ5w7D6r?=
 =?iso-8859-1?Q?4zb9yJ57SPDwE+CYFb/g7unWJG3RyOMNIN0LiqtoqyyHUBiat6UanDqALb?=
 =?iso-8859-1?Q?hYmk7MnBXNJ+WaCQ5nb1/aFQ9ynnvAEO7wLJf2CUjDAmgHSspJo4zeCASW?=
 =?iso-8859-1?Q?evSLk75BSCWuAsCycQFbrkSHjyXwFSvSNLV70w0upyL0kWz5S4wlfbwmUA?=
 =?iso-8859-1?Q?yR4WCyWGYUNSLZjwLI4QkbBZZRKizm5ZmkW41tMxArZJ/dKWeQyBsAvsrf?=
 =?iso-8859-1?Q?Hbf2hfzRz+51pV8FdNnJ/ctwNj4hTV9XxiIJZestUmz5XYoVqOcQ0+CF5S?=
 =?iso-8859-1?Q?upl0bVbh7pQs8QEZNZf6Vpjxf6l4EurmJvQC1zILJicON4xKaHLIDhf+rN?=
 =?iso-8859-1?Q?fskRCHj4o5TMsggnwKw9aAgGnvF8mUkVIqTl5Tg6NwTSE4DuFMdCS9OxR7?=
 =?iso-8859-1?Q?or1aunSd3R6bVaH58jWA8VNA+NyEytzuY6SX7suQk0X1vEuafXf82bFgWH?=
 =?iso-8859-1?Q?yk4CdWWXxHk2tUM2EUWmxRBARk4gizZ3wXQoK5/dmz8Qh8kqRW7TNnWjHJ?=
 =?iso-8859-1?Q?hh9rWOV937ZAzWFXNSW0TQhexxYqwdrboCGwkSGBIfozLCJNuD/QgVezR2?=
 =?iso-8859-1?Q?f41D4qqe+nV2T8AZ3USSgpfDh5xDL2HmZz/qPDKD6ntdNRcm5a2Ceh5Xdu?=
 =?iso-8859-1?Q?QYUouYn53bIt4g9zWj/7VeLv6mMxmK52yLOLzyzH62I87+ddN6x+LYZBYD?=
 =?iso-8859-1?Q?RJg7Y5SxkBJ36lNNgsXmWd56aitqucchM6HgEAmrjiSIbG77pZVOh/tEcA?=
 =?iso-8859-1?Q?ss9ccfZreDIQ3pbGOmT/qXzI29utKxBvgZEmeN5YjtlNbUCB/kmelD98H+?=
 =?iso-8859-1?Q?zp230f2SGZ5KYiX7uzEUtD8+0oJ0rbYGXuNMkHOyfGN3LjR0x7xMZkv1ka?=
 =?iso-8859-1?Q?mR/2TsNW36ma3uwSi7EYjpkJwuTklQyf91OMymIFxYKAHLJT76/b0wfM6X?=
 =?iso-8859-1?Q?HJGOhRUZTAs7yFR5RZhvEYZEzVyB+PrNRTH7tH9GKLa3dOcMaMBOqMNvdz?=
 =?iso-8859-1?Q?hByDgpC8mVynJUGmTn1YRZg2L7WgqDD6m/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7514a4a9-2040-4b54-add8-08dd03d15fbf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 10:53:14.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKlaIFyKKs8qgtM9sEY87IqQ2z+nol9uyLSSQI0Yywd8dRn1YDKD+ZtVLa1J9hxIP+e6RrPk1joecV++T+nbgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7252
X-OriginatorOrg: intel.com

On Wed, Nov 13, 2024 at 04:03:11AM +0800, Edgecombe, Rick P wrote:
>On Tue, 2024-11-12 at 08:33 +0800, Chao Gao wrote:
>> > 
>> > Or me, if Intel can't conjure up the resource.  I have spent way, way too
>> > much
>> > time and effort on CET virtualization to let it die on the vine :-)
>> 
>> Just FYI, I will take it over; I plan to submit v11 after x86 fpu changes [*]
>> are settled.
>> 
>> [*]:
>> https://lore.kernel.org/kvm/67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com/
>
>This series has some CET intersection:
>https://lore.kernel.org/kvm/20241001050110.3643764-13-xin@zytor.com/
>
>Have you checked if there needs to be any changes to either?

The intersection was already discussed at
https://lore.kernel.org/kvm/496a337d-a20d-4122-93a9-1520779c6d2d@zytor.com/

The plan is to merge the CET KVM series first. Then, the FRED KVM series will
address the intersection by:

1. Allowing guest access to the IA32_FRED_SSP0 MSR if either FRED or CET is
   exposed to the guest.

2. Intercepting the IA32_FRED_SSP0 MSR if CET is not exposed to the guest. This
   way, every access to that MSR is trapped and emulated by KVM when only FRED
   is exposed. Then KVM needn't manually save that MSR or save it through the
   CET_S XSAVE state when the vCPU is being scheduled out.

