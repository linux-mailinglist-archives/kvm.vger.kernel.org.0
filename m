Return-Path: <kvm+bounces-49788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F37ADE03B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 02:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96D32189B3A3
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A71513CF9C;
	Wed, 18 Jun 2025 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VShbyF3i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D3829A5;
	Wed, 18 Jun 2025 00:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750207754; cv=fail; b=XcPkKx+41dUO2EzVGNPST6QAvziQ8pM88ZZHdcXy6DKbT1iO1VVailDPruljigghABT0ikrb8+aHfxMSvuRGZp5ESJtuiRY4riJhouJBu465q7UxZ+FDtjx5boS32AnYmtYRLMVpX/tZCp67R+xJjVcArSxU6lZybKvZHqToNNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750207754; c=relaxed/simple;
	bh=6LsIxNh+Ilf0i2odmclnNWAa1QyLSC8NWnbUk6lZ3jg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J91X7ebQiGiIBD8Ligqw2jvCJbGD1BjCwtFNFV42jwdGAkkRZRLQ5CHTQ9WodkGJKW4hJlHKh0QoJf8zn8my0BkUJyiSDYfiHG8l8XpFd0gNaq/NhUfHJe0zxJGDoq1BRCuU3NdJhIdn2mdwtJUkb45N2AadgsByshPjfDT1G+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VShbyF3i; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750207753; x=1781743753;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6LsIxNh+Ilf0i2odmclnNWAa1QyLSC8NWnbUk6lZ3jg=;
  b=VShbyF3ii+uxDbB8KEUt1VDxFRd3pSYn90MMMX0rMlrZkaSJnG3f8Nxo
   xd/oZ0t6jyuH2WmU/d6h411bzlHWjmuSr0nm5bFfZBP7WafFWD2R7xZTB
   38OvKrH85xc0SBu/1alBbl4eSsHMXqye9wlhDnEMqf/6Rm2lFsGxU+kXS
   IZbKp5O0Z3oHmribnQ5g/hepzl47H9F+PB36K0x9zcjwpt7adOzb2MidP
   7eOUWIgyhpNuEqMmf2YycFHCigyHf1T2kiaSU3PxUdzNtjq41mKKvfQyA
   RKE3SR33d97FPpgcyj2TkyJDfMMZu7fg9RNawxpL92E0suYdOmeZtz9/q
   g==;
X-CSE-ConnectionGUID: Y5emcCmoSty3fdpACDpq/A==
X-CSE-MsgGUID: PzTADg39S0aKwneV62NYDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52545940"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="52545940"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:49:12 -0700
X-CSE-ConnectionGUID: biVM+rTmQ5OYOhBG/uidYQ==
X-CSE-MsgGUID: atqq3SlVQWG9vP+uKh3JnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="149039614"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:49:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:49:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 17:49:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLI72PIY89PGWHeinRPti4RSA2irRD5getd5Crf41KAMRNc4J9hA5jpYnle5F/LpATKiA6rvotfObCFnI4VI6x0B4dXX9eYCvgpRYnTLOdXxFm9yF7p3AHueyBrTKtK3iNZb/V476p6MyqmANGOpU/kFbi3ox3E5x3f1zPNjMX1JbSvcKh4sRtK8Ue9ju8nz6/xsXHPqtF0y826hF2l1s21tCm67sdFMRU6y2dj9OnBZiLFUjp5e8s32Ip6/ZPcQSJgpSWkhSZ50ZXbv/EBcVGF9AeywnB54UB4+TlL/2/p8RZNE/GTu23My4lvdphNCfBLX1+uPmrxPAf+TsfV80w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9g3fMwoKhbmZGkjsyDjUFqen3AmxTl8nrQJ1XqBmFk=;
 b=cKo+51xvxMNhfHbsyERizWFtJDP2Yo+CpakZBbyOnCvo73nFEmFyL+l1j0REl2UpkUHl1NYh4lY3biNjJnE4RofdMi+gy/kI8il13LWcLXxVT748ApfZWyJui6Zsf3lmUwVlV4CCV+rlakT3eekMV1yoaG3JdC8abpj36AXqZOr0PQWQoNameFT+R0iVjEXngs+nMxX8aD/PpTJwhREELOhgv6Rv55/Xju0KUKKHcfPWWcy727KSJZoiExUHUal+K9dISzgMDbbwct1h23GO6QF3bQt3Lj4uhA3dvFB+hd3pK+/PoD5aFPt90cnTmMyriXhn4Kas+eAlASu0la/GRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Wed, 18 Jun
 2025 00:49:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 00:49:07 +0000
Date: Wed, 18 Jun 2025 08:46:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFIMbt7ZwrJmPs4y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 758ae282-d771-4187-c799-08ddae01ee7a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hupciZtNO+BcDJv6lCW7GJXiolDNuxgQg0fKkAMFUkJ0zI5JihGko961JuXB?=
 =?us-ascii?Q?xwpbM9wkTPX3wyNnEhC3aWrfow9ilV3Tpyf1aq75T+NJwtVqmP8YTQyabMGl?=
 =?us-ascii?Q?QOUE+NO57HAFfxoYEqJ6CHUF1wISP4pkivdbQlBIgNuIzUm2UuqjVszMwxb6?=
 =?us-ascii?Q?OrRuzy0wcea/vwJ9oiCuX2HxidUD/71ACjc7yOV21laZNqOrJlauEzvyVej7?=
 =?us-ascii?Q?FUZBvTjDcSqca+xGUUCJwjrFxr6N1Wlamdl96cszuNmT6XLeOdqL4faILmHO?=
 =?us-ascii?Q?vZfpWQ4hxDMijg+oTVDBr47Kc5mcwELQc0tB1Vhj5l2eJeGBFi0cdrnqlFOn?=
 =?us-ascii?Q?vGapOH472pR1X6XV72tiVZ/lFdE2Ps8IvF8djaUM+MG5+/78GtX5HyOUlIPJ?=
 =?us-ascii?Q?L3mkDnAHfBCR1fRg9c51ah+km2gUVOirZrLXQV6hHkNaFU9S/lZxR2XmJgIB?=
 =?us-ascii?Q?IglIv41TcvEwJXvaeTI3OeRxv4CX1ByrKgRdzF4d3T3PGQ0YpPd0Ey2UJXrq?=
 =?us-ascii?Q?MvdGfySwOZ+VtOTIYv+zNY+Eg/v5OiXjCWQZcs13VXvlpTSUJ8r2+tyrNIF/?=
 =?us-ascii?Q?9l53QI0aq/aPr/pLcGzxJRbguHcuSQLEJyJ/MhCwhesq9TE9/WKZctr9hxqI?=
 =?us-ascii?Q?OQmZ0GgQ/OLBnwF5GVSYc7kgKeGramifsGKardJ7Byy2sly1Qn5cRoD/vTr6?=
 =?us-ascii?Q?U7+vo1vNeLcPtIUePjXsCSjtlFAYo0Yhn1gDgviI3ze+U78cosgUbmSuuUgn?=
 =?us-ascii?Q?wjvs2RRHt1/VOoMnzVJ7WsdEGGrdKhchkimqE3R6BXd3r8qOsxizjykJkDJ+?=
 =?us-ascii?Q?MUzAmX9Jbmq99/aE8nPx3h9KHxaP+k81iR0/Z1CkgaDwE1ltuX65PtDykPzd?=
 =?us-ascii?Q?ir/UGL8a8vB/UewhxS49H30iTlbRIe8fU2Kl1eejG4k5jMTQZUVgPg4/CxYG?=
 =?us-ascii?Q?/k4My3uZK+yV4hJZVKUiUJF41L+8juugH79ARo/O5M+mXTm7tLpUZ+iGIVZx?=
 =?us-ascii?Q?D5BFCVxEtIrrvwsuwyTtdojvfLs68Z7e9UkCIB7hOGL6ePdOCCzcMLcsIGRj?=
 =?us-ascii?Q?lK3YUNytymccY4FHrUfrgvbfyZ6qZU9zQHtY2TpQpEowsg3++pFW9olO9uT5?=
 =?us-ascii?Q?xB8s/8jLewBSwzFKpEupS5rPygOUuOXX1nD2QZR7gLWzLo8zthZkgvyd0T3f?=
 =?us-ascii?Q?jDPzyAuUgxzqTZulPKekvC1Eaj/n767DJ84AcSbj0KriCEdkwyiy28XeJZUV?=
 =?us-ascii?Q?yAcvjPjCfueq4fQpBnjC1n0W43MLykAXrhuF1GNBFbThbU67dMrHsFLT0OlK?=
 =?us-ascii?Q?kihClFqE1DuFxHP8f2v3NhkKndi5UyA/5vglGXJOg+BcvD639FUoSuYQgjto?=
 =?us-ascii?Q?Mv60ybGAuTTWT+kppJ3f3bBgwN1q51ynF55xHORcz2PPJTMoywx5tZbv4xrh?=
 =?us-ascii?Q?Zx5E5Fkmbqs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qNHWYU6/JXNsRYAI7TTFqT1sI9ZJol0BiDGpku1zkWKYaSV6YS6o1Ihug0JA?=
 =?us-ascii?Q?PuGrkKczw6SZMJnw3WqVIIZq7irMEpQ06xSN9CQ6hTnqO9RWyO7+HmeExkA8?=
 =?us-ascii?Q?H7bGEbtGtYHRQ8tx7Nswa6XMJlLt6SJFI7CI1FL9+Z52JolVnS6857k8y5+M?=
 =?us-ascii?Q?DcDzn4wVJ1pL802lBsJZ2FDNvAxSFsm2P/8k5Fi6VI0vnuBQt9ikCv/VAz6i?=
 =?us-ascii?Q?/3gDWwEuusHC8nb7D0ye0Dc8/I9z4zuPzY9HbUBTjwTXH2dmyYJVa+8w3rI/?=
 =?us-ascii?Q?Cyy9yIV56kNVXGOclpAfzYhdBQOlIhhqEd4schwhbAOVzxLDlFxP+A6CI1wR?=
 =?us-ascii?Q?BitZSeXEphrcAQkQywnk87rEq0ww234PzatKYZWwz3ZDcWWDiuAMB7oTaBZv?=
 =?us-ascii?Q?hKXp6hDSmPk97CiptFrsOTS0mBlx46iuZIsh8Ik0UMeWRdFZ2iypp/Kfmzfh?=
 =?us-ascii?Q?l98hJUwvqzcBG69XiEzZJgfBfkYdfVgis8y130Q/f4twiTOaQKSwKePzZjTC?=
 =?us-ascii?Q?4N0By8gXhPLJPzVL/Edd8XgoKJaXYdd2Dbbv/zdVpPZh70pTDi9F8JzLqPmv?=
 =?us-ascii?Q?ozmKLsUhOuZL2sFmRK7K2KdN1GZoQDmWMIzAMAjjJgx7wCeSujMBdiVwzNbQ?=
 =?us-ascii?Q?cGtAMWaxnjsAsb9WY8Inwcxd2PXUmE5Al0ZdzWuOVVZm/JvZKuJHPnv1YaDT?=
 =?us-ascii?Q?VNtXXlMjrGq6+zioQrVYnEZoth+mxNTJFvdGt22OAwW8BVnImGg6oPj6f6ZH?=
 =?us-ascii?Q?uSRhaD+nENXb9O2Z7T1I8SISRtr+vx1PVlKZ5pGb68V+nfi/3bY5RuDasqw8?=
 =?us-ascii?Q?xBaOpjojlpUV7JMCkmmzcptvo6iykZsiyrVV7mBesRLyNnlrXHyFB5hpPRs9?=
 =?us-ascii?Q?Me4Th/g2S5OJtxWH+BVZ23JdAVIVbR00W7vqyUZrin7Dh192QqpLiNYuaCac?=
 =?us-ascii?Q?cxJ4QtDov2+vpU6WbkeyddOHz9YEhycdLp5gDyIZQLVHzye6W5kqguZF7OIc?=
 =?us-ascii?Q?KLo1vPPt3fl9JD7ntKl6Pg2bqxUJD3/kFTynDhcp2r3cG+U/rq6RUMlsn1qc?=
 =?us-ascii?Q?DBIIIkkp+5kNgKLlmPHmM+2iu/0GQLrDbf9peotNyukQ3gpd/hXsRuGKPQlp?=
 =?us-ascii?Q?jOER3Ne5dhU/MX1QTupG4lMZdpRT6kZKJ06Pzo9/uhOQh/uIYfMUpeRhA/bw?=
 =?us-ascii?Q?eCDPr/fq0RRzeQyj0het16WzgWtP9xC0Xl9JguRsSWIX9ESHa3XqoIankwlD?=
 =?us-ascii?Q?hiVycu3+n2pz7faWAjhUkUTsjCrmhNqZDJCTNZUFsRiUn/JAuzEXpOQqJ+Es?=
 =?us-ascii?Q?/NbzKSz7FAaoe6lJ5u8daheRZf2PseVU8OCbaoeqfoIStsLWPQ6IvQqENdWc?=
 =?us-ascii?Q?Y8PbIZlhJGW4g4q9/8Wf6hBZssm7WlMF3vtsBi6PflvawFxkoVgxbPmAe2f8?=
 =?us-ascii?Q?Z4hhp969Hhs9o7L2ivbiEFK3TjYD6NMd4B7awU2ccOcY/wKGaF3AymzSIp/4?=
 =?us-ascii?Q?1gtpgVDFyGZMbQMBIpHlpPXyw0y68YKLybTMHxgFA4ljXdqIwH6r7012ZApY?=
 =?us-ascii?Q?HoaOydBt0tfPzC16sKgdePHjPHSrL+yOUNX5Y3DP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 758ae282-d771-4187-c799-08ddae01ee7a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 00:49:07.7019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iICzd5kGl6FkH7Dq2wYZN1Hdpjasi4P8yWH5fcnbLHaq0d7EmHWCyktcJYpR7jePaFhlCrzgvh5D34eigozNVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6733
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 08:34:24AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > Sorry I quoted Ackerley's response wrongly. Here is the correct reference [1].
> 
> I'm confused...
> 
> > 
> > Speculative/transient refcounts came up a few times In the context of
> > guest_memfd discussions, some examples include: pagetable walkers,
> > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > can provide more context here as needed.
> > 
> > Effectively some core-mm features that are present today or might land
> > in the future can cause folio refcounts to be grabbed for short
> > durations without actual access to underlying physical memory. These
> > scenarios are unlikely to happen for private memory but can't be
> > discounted completely.
> 
> This means the refcount could be increased for other reasons, and so guestmemfd
> shouldn't rely on refcounts for it's purposes? So, it is not a problem for other
> components handling the page elevate the refcount?
Besides that, in [3], when kvm_gmem_convert_should_proceed() determines whether
to convert to private, why is it allowed to just invoke
kvm_gmem_has_safe_refcount() without taking speculative/transient refcounts into
account? Isn't it more easier for shared pages to have speculative/transient
refcounts?

[3] https://lore.kernel.org/lkml/d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com/

> > 
> > Another reason to avoid relying on refcounts is to not block usage of
> > raw physical memory unmanaged by kernel (without page structs) to back
> > guest private memory as we had discussed previously. This will help
> > simplify merge/split operations during conversions and help usecases
> > like guest memory persistence [2] and non-confidential VMs.
> 
> If this becomes a thing for private memory (which it isn't yet), then couldn't
> we just change things at that point?
> 
> Is the only issue with TDX taking refcounts that it won't work with future code
> changes?
> 
> > 
> > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com/
> > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon.com/
> 

