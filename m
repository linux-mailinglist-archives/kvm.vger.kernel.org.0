Return-Path: <kvm+bounces-44259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A17A9C0E1
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D35143AA7A6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548CE23371E;
	Fri, 25 Apr 2025 08:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Np1xM/if"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8807817A2EE;
	Fri, 25 Apr 2025 08:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745569516; cv=fail; b=eDWXYahrBNpyQFm1crLNfFgRJc58gJXC/nwoXf5dTohyFueEkco4MKNhfIXU+QmBSioQS3CNf6nMt436BwYOEOoQXj7mOVbALJIixRydxagBzRfx1vOByWMAXQfo4MF4iMVcMhw5vxflKqJ3iERKjnNpdOHU3AP8dx8Wt7UiP4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745569516; c=relaxed/simple;
	bh=EThaEnEvioUpAT/be1AxPa9lDz1Bg2RszRfXUg9sQBE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gtjZVpjqukq7Sp/a/lRRilu5iwdsJVvnfB00p0vvp3pIBG2Q0AfKWGCwak0IsmNP1QLIz4MMuHuVmod/TTsRz9Yh0U14NLtVnRjAhK8/uGfaAw2UZW2tS/WIn0fHBALKr7xyy6o7fXspsUREYJ6Sx8cHzFxcJuLsA+lxKPMrsMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Np1xM/if; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745569515; x=1777105515;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=EThaEnEvioUpAT/be1AxPa9lDz1Bg2RszRfXUg9sQBE=;
  b=Np1xM/ifYMzoNtvPurpK7mJ6Pel0k6hP3b+BurPUwZGFWXnlyciXyQ1k
   +LHLnR2FIqZXHULXjBveOrSYHMe23BOVB7NxFM4/7nKpF7UbYBQ9od+ar
   BlycYBI8lzzvHhfSop5a3EHFUnCR6biptOT577lmQii/x459dqSEPgtYx
   G+UCCMuGCmamJz7owGXgEFSB4NoLaFiRWYUB/L6zTGxJnQPqflevxLNwT
   aCLgkTp7gr/YLBaDWbFn5pKViF9rnJ8ua35PBPd18F6pvr9TX4/mdSMks
   KApunTDKBl4gEX90wb+Ozn5xeh12B0z/nuPa8tveKRVmNZLVHmy1Uys+Z
   w==;
X-CSE-ConnectionGUID: 69j3nF6kQ7+XfMe9srtrBQ==
X-CSE-MsgGUID: 41c3JjtNT36qr/c/hTlI8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="64642443"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="64642443"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 01:25:13 -0700
X-CSE-ConnectionGUID: DzswCTS9T5SlknpaZ0YzIg==
X-CSE-MsgGUID: pfhPLPvIS/Ge/lSh2TZOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="132728519"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 01:25:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 25 Apr 2025 01:25:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 25 Apr 2025 01:25:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 25 Apr 2025 01:25:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hj2qoCDV2nEYzQ/lIi9tdRxIryjg9f9310nm4zrUQpbK0pD+smNffHTrOwA5NO1wLmuUbyMBb0OGpyac0jYhQHbiOpeeqKjrGHOt+dMy2G2ol86ozIn3qwJvFE87baIVegY6St04ov+MpZRPGiZ/WeHaNiHqowHtqkZ0FQsmgjJfmi9EPdvJmkGJ1d8XFiewzY5eVqlTHoKaTwg8/CrK7hLRJmnUuKnQCdOMRYcey56NbatsgM4Fstu8RPxl7wKxEcsqcKWEp6FnlFqI1GJpFrYtinog5q/DwddPTY7bOoNRBU52AEml48a+eqGbHG5cHbnIyT6z/txQuLbzlwf9Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBeN4d7Ry6pUbM/FmcliiEhjcHX3C55J6dHxpIXyJpw=;
 b=Pu8fa13IBDgjpgJL9jS0TeUmD4s4i5ms9GDCMEmJ3NZqR9vC6wLTTzJzk1Pqj+FhSZlGx5/VTulQlpSiZpubSzNqg18KMOl/3PTA6lJF1DprfGXN8SJOlrSSM3hg+9+izz8dliphDYvAwc1/JlXZwbB64HGA324ZqfqbdnRsu0jr2WC5aiuQ/vX7ojfRBd/u44BtS2/cR7KzgHnoEKciLbLnf+VS8rpwQM7Pw+D2G8n5/+MpV2qvJ/YmJKrIrmtg9AO+NZ16OXuuo6I0Adpc7DKHOeTmWIgvGu9YEgNlV41JQNQZwQdS+up1JMiVDvJootrm0dFD7ZEpSGNHV2j5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4804.namprd11.prod.outlook.com (2603:10b6:303:6f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 08:25:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 08:25:09 +0000
Date: Fri, 25 Apr 2025 16:24:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Spassov, Stanislav" <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Bae, Chang
 Seok" <chang.seok.bae@intel.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aAtG13wd35yMNahd@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4804:EE_
X-MS-Office365-Filtering-Correlation-Id: f836eafa-2234-4f01-acd2-08dd83d2b12d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?SF8QSTlfNRrcCsxobGKCIMFSLN30gd+1crNjuxp/kxam7ahhmgG9lCrjEI?=
 =?iso-8859-1?Q?/AAbw1SoqpJQOsrDOk6CZhBH+vOScYFrqcElIMqUrQKzjOI8/Sz5QzMcbo?=
 =?iso-8859-1?Q?yrGjuBroMvElrwr5V3/mtoSVNczf0B6xT+/aflf2IfKSQOetx5BFhd6H4R?=
 =?iso-8859-1?Q?4ZYs/sUKbOeE+/YobbwVQ8r1FAltWAWSg2AcnQhNCMGCrX2ioGJos0JtSv?=
 =?iso-8859-1?Q?DNyamKeJSg3b/8/1hcz71Ous7IoZY+yBQgV96ivoxRODxyROiixpWpTdpk?=
 =?iso-8859-1?Q?C2EjHjCg84hwZkyIKTL5kzy6SM9d7MougebxZHKbyypBuiqNQvIU1pUJGn?=
 =?iso-8859-1?Q?l7hn1iQ4c6UNQA93uyAD8oG5qW696ktwORNzzvC5jHNABeXxcxiyW0Zpr9?=
 =?iso-8859-1?Q?8YXY//KSISuywQoTFWt2zAuWyXzEVi6S6Rrp7Fv3n9BR68muMTHIdS1vP/?=
 =?iso-8859-1?Q?kLI5Fr1C4UXfMr06iGxBPHv8a8GIUnkuD8nl7awMALs2zNmhIYLWuy3g9d?=
 =?iso-8859-1?Q?vkzt2HGAOpU9Mw0IVTygEw4atVJRp+FuUbr4OeIN70SxyDZwlgF/7mpZX/?=
 =?iso-8859-1?Q?RoUrH7DSpeuLhN+QtIkWT4FZFeqe2i4/XNOLPs2z6zvST3No/Qo7js+mmu?=
 =?iso-8859-1?Q?qkc+VOHcQlLLZTf2RaGQJWHji4P4AEBERuQ4XsqWqAij8KpVMnh86FT83E?=
 =?iso-8859-1?Q?hfjhpLlJ0g7hKukaKfPB6axJ8tfH7Fd5rFr+2966aGnP5K2IyAU24Ce8Yf?=
 =?iso-8859-1?Q?tkPU7uAVtgLgQXs6Xu/My8IQAuekatqlu7ym7dIwh1ElqvVpypsozV6ffa?=
 =?iso-8859-1?Q?VEZT5na0g/mzW2rDrflSFdP+hosVDd/VJbgJ0wl4AfWnuZPzzxxy2NB8PF?=
 =?iso-8859-1?Q?rGe+VmjM3KkzxO8zQBYXcK+X0YanQHfIDcC+oXt25+AJC7At6X9/hmuMUy?=
 =?iso-8859-1?Q?oI/DhTwi4LzVRC8RQSSQz/qKwOVmscFy3EM87sNFFUe9ENbD7xlyY+ZeSN?=
 =?iso-8859-1?Q?cIIa86eJ6WrKvOxzP8jXrj2Dp3ybilH0N5POAApx8nURShBTyxiEEvGBfZ?=
 =?iso-8859-1?Q?bDkjrnJ+Rtp/IM8oXR4VKcUafNGFHK98gg7aD6R1U6oZojkucI4IdohxX3?=
 =?iso-8859-1?Q?j/26OqXDoJlU867F2bY2g48lBoVo+CgtGoJMEcq7P5yZBWGnogqKnAqggq?=
 =?iso-8859-1?Q?TlOgimnF0xXxQB98H4t8180SbhdJkdq14aldTzWx4wGyJN8ZDNrt/b/OnN?=
 =?iso-8859-1?Q?OU/du7ONB9j2GgoVGFBZU5szbR+6fLUAOq6aOQ7xpgvXoPyX4qEYwkVwkt?=
 =?iso-8859-1?Q?ENQCuFb40ROtbFainlJmwR60ykhtOndtbgX+5HO7ZOMzVari81y2F/w/NX?=
 =?iso-8859-1?Q?32dQiRl+b418wxc9QM5K3X6RPCkrhHhekTWIrbSq5yGdx3jBtP89IGsUBR?=
 =?iso-8859-1?Q?6HhOQGEqdVFpxGiSnxMunBUjLwE2XIKOpNbgeU4X7fb9ter4MERzUNc3GB?=
 =?iso-8859-1?Q?w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?v7jYcSmD7bLSslrE7iXWdYuPXFOuQqvU46GjfkCD+5Po7MpcH9uH0pdQgJ?=
 =?iso-8859-1?Q?YrLPTZxxdwvdrptfZyX/t0494KKAqOdHkMLkRGpUAbAXPHJo3TUgB7WKx/?=
 =?iso-8859-1?Q?hmPWlXXcXXD5tycZFC9LRXmN+3k302ucMRgmszetYu8QU9exrI0545HmkR?=
 =?iso-8859-1?Q?O0ORtyh7+SqV9xAjbLIQn953gAd//KsJzl5fYYC3Kpu4rJ46sAepm9712i?=
 =?iso-8859-1?Q?1wC9K0v5//K/b76uX0/I1NEjZbluBFYBi563+eoKIyyvuUiE/HO5uZgspz?=
 =?iso-8859-1?Q?yzSlbFjfMqTIl+9gk1K843H9hF0VCFsMFVtTYfdlZYoqXV2oazaX+VLCtp?=
 =?iso-8859-1?Q?Dcgf7235ybDBe3EQ4LiCTy8tvOZ+z3U42Z4Wghx1jNi+1Ui8XEbZ2HEWa/?=
 =?iso-8859-1?Q?wgY7ksZL0x1LwDw7AOdyqUGNTCiIDECy/ZgE2ksD933YBz/9YHe3i0TaMC?=
 =?iso-8859-1?Q?QDFCVhiw6xBoT9HhoA8Xp3d8vX+/lFKfN+N27NJRoOOVMXilqMt+uACYuP?=
 =?iso-8859-1?Q?/5GpdFiwYJ7pMYEI19jcW+t/E2GzIRwPcn1os5sIYNV9+IOj1G4BHPIbmP?=
 =?iso-8859-1?Q?PPCNbPzNo0F7Kd/PGYHYae1QmucGCFLu21RhTDzXFUPnHqvFTlLYGaCysq?=
 =?iso-8859-1?Q?03f7wwPaljlmz32mEtOLECToNbBsP9romZ1Rh5k5O7ohxqOFR/Ymcbqbgg?=
 =?iso-8859-1?Q?8mvEEa3qldm7R8so6om48KWJwrzcOmG+jj4WTXR6FcTawD6+VWSfeqYysq?=
 =?iso-8859-1?Q?j3MX7iP28rh0LbOSsASD0WkbkvoMJ7gc9pPi9OlBGOHy0YNbA2HFJJA0Au?=
 =?iso-8859-1?Q?1I0Iuv56lMA5tmy4JsPaCigfoHk51BTThYyWGl65Y/LBUJR9+6j6TdUxcW?=
 =?iso-8859-1?Q?zv2Bgf9uCn4WrFXC37dHpGjX+8/vloK7Jin9ZX0TAOe6Zx26BV9MVuj1Q9?=
 =?iso-8859-1?Q?UmmDz1vo1ezvBVtGi7hUadreZPhyqsjdEfRGWYq5JZRytUoFMk5RrdhsRT?=
 =?iso-8859-1?Q?MFUaWAvY9+XtbKWsA8IfDdcQhAR9vyeqtPnu7TW2AENE7KDXPxX1zD1Tej?=
 =?iso-8859-1?Q?BmiUNtmyLuBoBk35CuHX1ImPEEOUSLjrwfYhArIsP/29AsGyVZJk9+ZTZT?=
 =?iso-8859-1?Q?wMCiAI91Pz3Vc5gdb8adaI0GX4yz/rqtBmnADAjztaGu6/MZ81pBPrbEnu?=
 =?iso-8859-1?Q?Jb7OJw77m1zAxvAQqahP/0df0jnMbEQpfCbbu13RQ2cUBgOpIR8wgIeONf?=
 =?iso-8859-1?Q?/gcMzRs/PG9WKMi/yqE9aBuELqyxDD5RgiUjrqDBqSrMBS9BP09a8ePyx3?=
 =?iso-8859-1?Q?CvC8xm67PY/pFh1L0RRAY4ApnHvI85NXJVAGXGV0IRt/J8eeIWTWRa5QRD?=
 =?iso-8859-1?Q?wDkxnP6DC+QZoulZ6ZBfh1YnzS3h1neFGpoHfQsjPbCLtuDHIwvVEndgVz?=
 =?iso-8859-1?Q?UfgfEtZIcWgRroho7BiPCK21GyCkkTqTitde2lkp6+3FPEDK5f1WnL06RO?=
 =?iso-8859-1?Q?v8UORbsoK4E7eEaZ9o0L94lJ2N2ZqsRHTxKZEMpNRvKCIJynmUJUlsIjXm?=
 =?iso-8859-1?Q?eZryjQXmiN9TYaG2v4PisK+OH391Fn+iRcc8njUYPewGTZKH7kXwS1tAKw?=
 =?iso-8859-1?Q?MDzXs1KKoQ2vIOs27J+p17wMi/Ev9lWswe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f836eafa-2234-4f01-acd2-08dd83d2b12d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 08:25:09.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDmlukmDMBe30gbuzo9+Xlgb7n47SiE5V/2tIsJgZdeuNQYjwnnG0CEnNl6x06j9JzApuy8qspvvjBeLOMPQlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4804
X-OriginatorOrg: intel.com

On Fri, Apr 25, 2025 at 06:52:59AM +0800, Edgecombe, Rick P wrote:
>On Thu, 2025-04-10 at 15:24 +0800, Chao Gao wrote:
>> +
>> +	/*
>> +	 * @user_size:
>> +	 *
>> +	 * The default UABI size of the register state buffer in guest
>> +	 * FPUs. Includes all supported user features except independent
>> +	 * managed features and features which have to be requested by
>> +	 * user space before usage.
>> +	 */
>> +	unsigned int user_size;
>> +
>> +	/*
>> +	 * @features:
>> +	 *
>> +	 * The default supported features bitmap in guest FPUs. Does not
>> +	 * include independent managed features and features which have to
>> +	 * be requested by user space before usage.
>> +	 */
>> +	u64 features;
>> +
>> +	/*
>> +	 * @user_features:
>> +	 *
>> +	 * Same as @features except only user xfeatures are included.
>> +	 */
>> +	u64 user_features;
>> +};
>
>Tracing through the code, it seems that fpu_user_cfg.default_features and
>guest_default_cfg.user_features are the same, leading to
>fpu_user_cfg.default_size and guest_default_cfg.user_size being also the same.

Right. This is primarily for readability and symmetry.

I slightly prefer __guest_fpstate_reset() in this series:

	fpstate->size		= guest_default_cfg.size;
	fpstate->user_size	= guest_default_cfg.user_size;
	fpstate->xfeatures	= guest_default_cfg.features;
	fpstate->user_xfeatures	= guest_default_cfg.user_features;

over this version:

	fpstate->size		= guest_default_cfg.size;
	fpstate->xfeatures	= guest_default_cfg.features;

	/*
	 * use fpu_user_cfg for user_* settings for compatibility of exiting
	 * uAPIs.
	 */
	fpstate->user_size	= fpu_user_cfg.user_size;
	fpstate->user_xfeatures	= fpu_user_cfg.default_features;

Referencing different structures for size/xfeatures and their user_*
counterparts is not elegant to me. The need for a comment indicates that
this chunk may cause confusion. And this pattern will repeat when
initializing fpu->guest_perm in fpstate_reset().

>
>In the later patches, it doesn't seem to change the "user" parts. These
>configurations end up controlling the default size and features that gets copied
>to userspace in KVM_SET_XSAVE. I guess today there is only one default size and
>feature set for xstate copied to userspace. The suggestion from Chang was that
>it makes the code more readable, but it seems like it also breaks apart a
>unified concept for no functional benefit.

In the future, the feature and size of the uABI buffer for guest FPUs may
differ from those of non-guest FPUs. Sean rejected the idea of saving/restoring
CET_S xstate in KVM partly because:

 :Especially because another big negative is that not utilizing XSTATE bleeds into
 :KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
 :letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
 :snafu if Linux does gain support for SSS.

*: https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/

[To be clear, it is not an issue caused by Chang's suggestion. v4 which adds
new members @guest_size @guest_default_features to fpu_state_config has the
same problem. i.e., fpu_user_cfg.guest_default_feaures is identical to
fpu_user_cfg.default_features, adding no functional benefit.]

>
>Maybe we don't need user_features or user_size here in vcpu_fpu_config? Or did I

I don't have a strong opinion on this. I am ok with dropping them. Do you have
a strong preference?

>get lost somewhere along the way in all the twists and turns that features and
>sizes go through.

No, your analysis is correct.

>
>

