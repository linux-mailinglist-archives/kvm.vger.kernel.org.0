Return-Path: <kvm+bounces-29589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C849ADC1F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FB641F21993
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 06:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE7F17836B;
	Thu, 24 Oct 2024 06:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yw5ySWQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD64189909;
	Thu, 24 Oct 2024 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751079; cv=fail; b=TVy1UsTvRkvUT4N/sc9wSqNhwllWaOiX7AK24iXoeYf2ERQIKwJKAy3eGXwsr4TtsD/V+gC/MAZodOg7FoYVZg1dxy2Bz2K8xOA2F5nBsrS7s9C5V+wpS/J43oyu+flnuuw7Cg9G4CU1Ph5AmF1DzPtSncQ2vFxZhl2EgrQ4dBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751079; c=relaxed/simple;
	bh=8CgKpXglpCxIApRGGl9UISDpL4tlfpetRQB6JM3MM7E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZxeztB8zfNQNN2N9M5INO6rtowrPJgXv0QBsvXVXHFQcVXnteXH9xHs+X1YI/YbZ4XjrXGUPaaloBfRRBqvhidAl5Cch8a5eiM8j1bD7g1UncIVWi8Z5scql60AKaxHb/7bJlwMKFZJ0iybKN5ODNCaBT2ov5LjzFYsqr2HvoM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yw5ySWQ+; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729751077; x=1761287077;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8CgKpXglpCxIApRGGl9UISDpL4tlfpetRQB6JM3MM7E=;
  b=Yw5ySWQ+wA0eTA6KVyNkOzF0ICSMtckFYbMViNTP+Ve+98/90OaN/ptH
   dxwBEaBOiTKf91DSWFxTjACgig062jja2ZdaH9mW6kkmNZdyzpf+z3SZa
   lpa65RNWdK+4CNZ7r87xcE9mU0o+cStlWPgw8BJMjvpSkOwjtyW2V291B
   QmXgWeHXtfapJ3uGbflCrT2qg6YqIWj4XppK8MR7ID/llGYp5LMSeDY0a
   Z6nBz28E71MIOgoRUfLze6XbbCyseBCfntMsePhQgHK8SDjPj1zlLdmZe
   6nU3WaljYQ9DLc4CktgHioE7tC9nS8OO9+aiuEZVJQPDuSv71ZoJYTw+I
   Q==;
X-CSE-ConnectionGUID: B87u6+5lR/KZSQ+F6lplCg==
X-CSE-MsgGUID: zCwbzJZGTA6tgchkcC1oCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="28806506"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="28806506"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2024 23:24:36 -0700
X-CSE-ConnectionGUID: wt2olRJmS46/QTc/Q6dekA==
X-CSE-MsgGUID: 2Hl5/yf4RFu4P2iYi819WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="80805475"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Oct 2024 23:24:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 23 Oct 2024 23:24:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 23 Oct 2024 23:24:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 23 Oct 2024 23:24:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XvNWjbWuURGmnlq3j3aiy07OPyEuPVnJEIrCD2XAFDAVB2t1Qz7dGF9nuYVr/wtbtdXpVOuDTS5d5pzWQvUwNdWx0FPx58HZSJrtV+xlrI8WGmxx6zPUfwlKINfr0vDse4nINMKvMR0G9/7SkufjHgOw1GSuWpkfBzs0S8r/pQA4CaFm2o7OPcPt2ndHbohz5p1qgcnfjF1up3b5afSa3N5dFS1dJYoDmbO6sfuEJ0eYvQqD1OIPfgP4srAO6ukTxL0NWNbHF2kYPWqYvWUB2XEOT/tSKYYktiKR7vEj9j1YCay7dw/Asn40HsvKUsZRRQdI2/nh1SSkA5pFkInpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKBHlRamnF/pPzsIR9fgzbHA/bc+26TWhgRQSWAdMEA=;
 b=k0tXIOsV26kx/ZM4GmCzkD8b5KSUYd9RiF62SZai0g4TRALuIotoY7GQymfN3xP+u7w5vzvJB2w/oe8Z3XCLM5eJhG/Be+uE4nRvVCtpIc5T0mdRr4BLBa0D8ZB+o23XSgXVsd08C8OhPHFnUC+oOue2YFvZhbOalNkouopKmh9nEiYyt7/wGDETu0HZFU1r9fHlQCwr2KkF5HOg/79bH966RmuY3v0cZnsuX6FCS4XBYyefIPIOcUiTAPiRRULsPn7vCML+3GD9aoKrB0AZxlOw7fLFsmuIWncpnzwqxnbuPvtsfAWSynZnDDpaPLnIz6J7jxh/9T+gC8NXJ//rSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB7030.namprd11.prod.outlook.com (2603:10b6:303:22f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 06:24:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 06:24:32 +0000
Date: Thu, 24 Oct 2024 14:24:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 16/27] KVM: VMX: Virtualize FRED nested exception
 tracking
Message-ID: <ZxnoE6ltLawgPHdZ@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-17-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-17-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: a26ab650-686e-4a7e-0e3c-08dcf3f485d8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Gv3hGMBDyaZ6j4NscFpa5V0SsyYxXD7+EJabpo8WujwYxHshX/j7OTfgUsK5?=
 =?us-ascii?Q?hKk0QE75bGWFDmM38evH9QFkyt0lOt+I6iNW2yGSkukdomtK3uL4nKt85gme?=
 =?us-ascii?Q?5beN5SLhq+8gxpC0ci7SAXCMK/4pTmq2Db4t3i9C+ndrLebiEKlKlqb9eiAQ?=
 =?us-ascii?Q?2i5wywx4istWfcZCIhVF7V6TEeWkfwy2jj35/0MX8gxXQExxxtrkaMdyL+gZ?=
 =?us-ascii?Q?YtscIUVTBTho7EjewTMP+5nxphlDC3ROP0NJlfoD8mOFSt7bCvCGzwF7atwV?=
 =?us-ascii?Q?F/Z5V5aMb+O2N2uPnminnsk3Nm7rJpjFkk1qA2BeRSjdvZJo1ZtWHKiR2zUr?=
 =?us-ascii?Q?teyPEVJO6lS9+tEBzScbofZrqXO6x8wcHgdpIMfCPu5gR2Xd8bt/mPI+n+K1?=
 =?us-ascii?Q?VpJxYm7lrb+rpUi3skXtNBPBBFyM23jQ6IwB71ul6ODdlwx84pOoY2xdeJ3x?=
 =?us-ascii?Q?g7HBk11eEg6Emgeljz92dsCZaa0467E1/yS4gJnhaq5CIPExLkqVYavtsQT9?=
 =?us-ascii?Q?AmT/Aq51YoQ3H15jx+bKIwGDuR838XCYi3fK0D3FahWhllyMz1ZlB030QnX6?=
 =?us-ascii?Q?uzT8ouvLYYYm7Z9XbFRQNW+4tIQEwOPq3BNsdIbdNRD8O464kyFbnU8hsBOx?=
 =?us-ascii?Q?yRZ5RXWiNPezWEo5RZc/HJautMdsSqLQzRIoMuiRqOX3XNnh+T67NXm20YC4?=
 =?us-ascii?Q?OfOB+OrdbhEvH5M4RhvzJHSQ9AyRzlqwDiZHXbpGVJ8sYOGI05pGmOkPPdzy?=
 =?us-ascii?Q?3oyhFl1R4ExB+Lg5FpS3N3iMB2ZjLARn1v3IgpT0pQrR0NSiKx1KmK/J/09u?=
 =?us-ascii?Q?epRSoueGgFuSqfWt+4NsRoqTK9G9f8bdhEUW00PhlolQ6lVk+h6Q0Ek/xsyn?=
 =?us-ascii?Q?WgyVgDI3qjcpp8PLKzkLbEmngx+fgU3UodkWXMUm/z2iB0rUXzuEV5yBie/l?=
 =?us-ascii?Q?ETE+lQEy0DBarA21VSZmr/k2wYQ46TnQ8Yw3jVIfeE83cBGTgTUy6VCC99DI?=
 =?us-ascii?Q?xj154eedUmoj4jRmsHnEqsXRNxVLwxzeGeaim6gRrUJJ7joQ4gn+FttUWPiU?=
 =?us-ascii?Q?Yt+6jq+gfz+cHElgx5d6CytTj/0IiHM3hme3tddfmlq3iRQ09uagM/2f7xfM?=
 =?us-ascii?Q?SrgQXYt6IkH4xIIp7uTwkMVXue2LTQAynzEVw2Un0UCzN+XRR+FC7wGsQ8GO?=
 =?us-ascii?Q?6C4Siyu37XOVQM7STVjt5JrcSLYv0ESx8NFpSdRbW18zImGTU+fKh7UQkEO0?=
 =?us-ascii?Q?Hz5P3dbBDuauPpaRgvREi4p7tsb6jKQeuCrJ34sQJMyD3qqIWEGw8pO4+GAZ?=
 =?us-ascii?Q?NSwZZWJO+EzYBlN8fY4byyrF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e9893icFpW6pK760T/4ZdYzZeYJR63Q4iEuIRakeWZRZHV490XaLSNSU2MFx?=
 =?us-ascii?Q?oO13s9j1Z7ciq4QKoY9vstLG70St5nlHw9OEH0B8BSdt7mXP6hgeu2jCTm8r?=
 =?us-ascii?Q?1L7Kd5ujKxB2CSuHDG5azJKp0K1Y7t6ZsJtBn07Ylq1t0A1uVSVlwaosy1du?=
 =?us-ascii?Q?VFlSly+GZSyMT/VJq6x3jyOwyetHj+x0WsbrSBTjc6Vw3Epq1jMERBbJbfm7?=
 =?us-ascii?Q?xFjDpyOedtUIuwmf533sfMYS81aMDzhXzjoxdGzgTHiR3QP3ybAzQl+p3lHG?=
 =?us-ascii?Q?GnB8hnEvdK1OzcfGOnRd/cECrDtkW+mccIlAfTZMJIVf+qp477kSMsTLmBjR?=
 =?us-ascii?Q?RCa7Zu5nsBMiKmLWk66hhVPlj0I/ICeH6PgaFFmuQHTsEzA2hSBFf3sfQlo4?=
 =?us-ascii?Q?hvuAjGj9s8CObPnROGpRHqv3HhnPbNzhATYczEpED+xaSHM76YY7IU0XJki/?=
 =?us-ascii?Q?xn/x12d2/EE2U2VW3ZqFeaw+nReO0hRXt2YHFxddkXdhHQ1P7uaU4prbOEg3?=
 =?us-ascii?Q?3z0pS0m0e2rQWpzp9l5uy/LwwxKFQp+4feD9GiYXNK+bDSGiXiv0ejczsNh2?=
 =?us-ascii?Q?5yiCum8xCtPqVaP8+/J7nzNrBuzAX+v9d/2y/MQ1JWDcSVe8aB6oBPT5z6yZ?=
 =?us-ascii?Q?98ZJ4//q2d63JFJGZwVheMrmJYVVcnujC/a20moyGvaIwjMaVs2qzjAejyEQ?=
 =?us-ascii?Q?FKPe5nqbiN+DDt7sn2UOFIEib2PB19MimfrRvI+uwC1hXMiUXY95oplj8Qla?=
 =?us-ascii?Q?ubX0GTazaroZ/cvESJI3AwsYOOanNctBRn0R3WgzyqqTEOTwFAGPr0Qx+0TC?=
 =?us-ascii?Q?xT2TrU4trj2k1y9WEXcHx+loc8aoP1YTWPOB/ls+WAN+N1Qr4WA6S/SHK5za?=
 =?us-ascii?Q?JuIZ0fqxxBjBWOIXFq/X+zTAaR1VJxWzNDLHLyMjc0KhQccHvqOcPc8Cq5mH?=
 =?us-ascii?Q?jkgrsBTBC2pDSzzsbuicmD49eZaGeG4r5yv9P3C37n8jISgp8KwHYSH12Tvl?=
 =?us-ascii?Q?yUHpXdcMepeEFVnF3bItkgm9NwNAJD6rvzxSmhilSu+PWe+D+3yznm88qplG?=
 =?us-ascii?Q?n6tzfXxO4IQtjdgCI5O05zD2IgJphXqWgnDpOG1tr+HpLLuRxNQpNTmAAPVU?=
 =?us-ascii?Q?bCGvpN0uKj8lRP74qe0K0DZQZ+zjNhlPj1iOvWW7VR1HQO1PvK049KAKOKT2?=
 =?us-ascii?Q?I9BNc0D/hGdpv7iQGNRIaUGyIm+l3Y8dtEWCCyPsbbCp7FwXGJeCpKtc2mfT?=
 =?us-ascii?Q?9EoH1p86gmJLlZW9A/frTPtRwCYkGyy2IFt5irstraFDTbkIJY3bq3n/UQWp?=
 =?us-ascii?Q?0GcHxtr7/Wlq7i7Le0waCq43WbdHJhq9Sg371gzh7rhL3/FvDzyw4HpItCin?=
 =?us-ascii?Q?XR2h+lakCRaYwjGLc5s5G2VkSkVI6pl147e1hRQ0Wv9xxNmN+porDU0g2wtr?=
 =?us-ascii?Q?42bpSRxY08rKElJ9g6DXBHPlkkwlG74VZLubGl4+OCzsEE3pjxEdOXwXTj/m?=
 =?us-ascii?Q?s6CTJEbTIda6XsBlc/In7QnB5m5TeCYidpmD6GUbe7P3U8Ntk9Tg970/STlv?=
 =?us-ascii?Q?1EPTo2ZraPwFh9uGKt+BAWdHJcpJJZUHCj54PeJe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a26ab650-686e-4a7e-0e3c-08dcf3f485d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 06:24:32.6464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxnY97v5EkpPRUxFY9nUXfXkhwR1SMXomBwB/mtIT1i5ww2JHqPtj3X163G87QkUUXINOKDCkog2P9tbzkfPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7030
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index b9b82aaea9a3..3830084b569b 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -736,6 +736,7 @@ struct kvm_queued_exception {
> 	u32 error_code;
> 	unsigned long payload;
> 	bool has_payload;
>+	bool nested;
> 	u64 event_data;

how "nested" is migrated in live migration?

> };

[..]

> 
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index d81144bd648f..03f42b218554 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -1910,8 +1910,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
> 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
> 			     vmx->vcpu.arch.event_exit_inst_len);
> 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
>-	} else
>+	} else {
> 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
>+		if (ex->nested)
>+			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;

how about moving the is_fred_enable() check from kvm_multiple_exception() to here? i.e.,

		if (ex->nested && is_fred_enabled(vcpu))
			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;

It is slightly clearer because FRED details don't bleed into kvm_multiple_exception().

>+	}
> 
> 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
> 
>@@ -7290,6 +7293,7 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
> 		kvm_requeue_exception(vcpu, vector,
> 				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
> 				      error_code,
>+				      idt_vectoring_info & VECTORING_INFO_NESTED_EXCEPTION_MASK,
> 				      event_data);
> 		break;
> 	}
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 7a55c1eb5297..8546629166e9 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -874,6 +874,11 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
> 		vcpu->arch.exception.pending = true;
> 		vcpu->arch.exception.injected = false;
> 
>+		vcpu->arch.exception.nested = vcpu->arch.exception.nested ||
>+					      (is_fred_enabled(vcpu) &&
>+					       (vcpu->arch.nmi_injected ||
>+					        vcpu->arch.interrupt.injected));
>+
> 		vcpu->arch.exception.has_error_code = has_error;
> 		vcpu->arch.exception.vector = nr;
> 		vcpu->arch.exception.error_code = error_code;
>@@ -903,8 +908,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
> 		vcpu->arch.exception.injected = false;
> 		vcpu->arch.exception.pending = false;
> 
>+		/* #DF is NOT a nested event, per its definition. */
>+		vcpu->arch.exception.nested = false;
>+
> 		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
> 	} else {
>+		vcpu->arch.exception.nested = is_fred_enabled(vcpu);
>+
> 		/* replace previous exception with a new one in a hope
> 		   that instruction re-execution will regenerate lost
> 		   exception */

