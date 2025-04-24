Return-Path: <kvm+bounces-44110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFD0A9A91A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A01687AA54D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD4D21D591;
	Thu, 24 Apr 2025 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5OCPUMo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CAA43AA4;
	Thu, 24 Apr 2025 09:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488287; cv=fail; b=Hk/nngtsJNjvhdzQ/iYNQrECkE6FfSiSPbzrocCtx64Gh6z0AXpTimAQz/yI9p77f89Idl9skYYTFE/Xt+YcFYcdwtxRR8fpZa99jA1GbqC6EVmvzrpkQDbAItFfhtOVJ73DV24OCkYeh3YZ60XUVpVAk+eosKAUSh3oPkdCXI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488287; c=relaxed/simple;
	bh=n3HDjEKdL+NXhUKNLSp7wl3kxtH0SuDboppPBMRfjBk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qbbiPolByxQRKUtlhU+QBi3PYYplDlCqfx9VF1Lk5Z4MXMKlHH/SxRnchoCpRj53XBYtEHMC3fP9SY5wfoTLvZUqi0tKqOW4zVx3d1tplQAXULPyOG8Lhf3TKNDhKaj8J0yi37BGL9CT0Ppyrn39RcufrPUgLEGvUWORzfdOaqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5OCPUMo; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745488285; x=1777024285;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=n3HDjEKdL+NXhUKNLSp7wl3kxtH0SuDboppPBMRfjBk=;
  b=Q5OCPUMoFWZl7BFKfI2JubLCE/Wo1iCtquglb6Jqt1FmcfwP6kjtSSJ9
   LSRwawh8Q348jrnK7HORbLLGqBJdtHRyNMtSUz8gfetSHwZLyTwx8mfgY
   NcS5ipdNOXAGy9TAOpmtWqnsmqGBr+yMfkIIJAuTq7O67ILgRVPM0gUs1
   +t4QBw5owfx833e4UmvguQ36RlJqyXttQYQWJOUyQQEXNTd/l1EupJMe3
   3iIUmImY6YHkeG6oaqpzR1Bg1YPgshShHugksDri3RR4mfn2uOE1O5UG0
   5JWUyBxLNSeaYRMPdP3ar+DcUBTygCpNSUYNSeYVRwA+b5bV+2YbjtsmW
   A==;
X-CSE-ConnectionGUID: Z+yZQB8UQpCcK2dBZaKdvg==
X-CSE-MsgGUID: 3AWb9jKaSQ2pI89Mv0RRpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47247314"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="47247314"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 02:51:24 -0700
X-CSE-ConnectionGUID: lzlbHnMBQ9SHo1NF91VBsA==
X-CSE-MsgGUID: IK2TMPQHR5e4uIVBW0trjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="137660115"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 02:51:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 02:51:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 02:51:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 02:51:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcpMVTtD8cfsAWKdvY1R4Do4hrPiW9tn6H/dlnDWp52BOh77/dWvGkJ6fz0kJKAxXaqr/G/ZhMDvOyYi9QBPkkmTcfPruvoNV3x1jIF8znu56ztyeg/6CgkCha/0AtKBsw7cT5t+Bp6kRTHKn2UosOD7wlagUW+cSnEeNw7H/BhN40lLumiDT5bv/PS0z2Ihe4U1ld58kTy8vudC3b291QaPEKPRL8kjBVUjRFTkmYldUwXl2ICeyKwIBPW0YnZsi9ieq/gd2EL/pp9n+Z7BbDOZR4i58lJrcXxMqEt5TcLYmDhZzVaSxPFqAKv2ierge9NCxi9h5FxreUzMk6i74Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7aix5YsU+lAh5sdGBwcVs3uiOmkt1W9raPyn8bSHXU=;
 b=UCvOPRH62mTAdmY3zEHtLnoSQ151dLlbXYaSnUJhzDOOU5gOzGCbp3Q7dcf9waHS0ga9IJU6BGmHBiyjYfLdnXBtcvdMAaSx71V1oTL5Ua7r3hTQMq5Dpu+WZ2kNeqs/PEbVDtxzaIF83tT0esgZHVXZ++ZcJaUACzD6ao/TZdF1MTYkRpKu4pbnDoDzXpBfV4ct+Cz0BufO8oE3IrxxxuScdKv9myCnkQoHRBXYOKoVKDOC+IJqt8L48/7nhoSemmPHu8F2AZurTtluwuDHkU8UOfRPCq9zEfcf27lx6bc1EcuE0Iue8Ipb1X+5ZxDmnhFgBWI9IjbR8j9g4JHQfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.23; Thu, 24 Apr 2025 09:51:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 09:51:14 +0000
Date: Thu, 24 Apr 2025 17:49:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Message-ID: <aAoJHXsAbdOx+ljo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
 <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
 <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
X-ClientProxiedBy: SG2PR06CA0197.apcprd06.prod.outlook.com (2603:1096:4:1::29)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4984:EE_
X-MS-Office365-Filtering-Correlation-Id: 35596770-40c9-4937-d743-08dd83158cef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xQtlz09uyS855cNArwHhpghQJ0pOH8z3it9X0sPQXnCg5z2KRZi7qG6eAqLm?=
 =?us-ascii?Q?uh6uYKiRAeKQkNGDRxKunsOMMym90CFrKbchKQVDvU06c9F9RdCh9z5IjIm0?=
 =?us-ascii?Q?C3ayy1kYdkW+JU9Jhk8w7ElMWCQUSWmNkFvbHlWfhkpokzBLV3MG1xUrdiD2?=
 =?us-ascii?Q?KFTeahivzoKmmbozN8Ir2XCx4jQMGDHkVC437IUxmAFhrSX2ZBfoBnc/KkpC?=
 =?us-ascii?Q?7MXKtyL1wO/yANdR78X8b+T3QVW2DVi477q7l1TYphhB4qgttoIpHimrm1gS?=
 =?us-ascii?Q?wUGYX3hnc8hnyOCNsPLcgAWdFVJmJV2x6CE0uoVR18chc4rW8sE4zZvYDw2N?=
 =?us-ascii?Q?9R5TOc6kbNPnLh1GQQb0+M6O05FevgaDkjS48mCpxtDbJMwsRzpKtEz6qtAy?=
 =?us-ascii?Q?kpTQvSeZD4uDWFYmMhkuDQQAb68EVtLc5q4efHulHZzDDTGq0bZIjP/J3SVd?=
 =?us-ascii?Q?HgSlgiNkkbNcI+/nJ1XiZNKH6BPmBCXLZu0aPKYmBrDEc90rZPSjcr4/T1z3?=
 =?us-ascii?Q?UYDOFwx6OwUeCGxxZxhy/q+2U9HgE6TswhitQI/lmd0vlpaiLBpKZSSw1zEA?=
 =?us-ascii?Q?XMe1hU92U0rFLh3aXVj9oe7qMD7uBmXQashQIs2H3sMpb5wthapN015ie0sG?=
 =?us-ascii?Q?dTeTvuM/7IzvRRro0C3W/U72wIp8MUC4S3CsCyc9CGilCyPV1ksY1F0wTDB3?=
 =?us-ascii?Q?K0/c4BKu+duARsd3Jwf8lZc2C0VyJTrEmfJJjnRyD/nTPHbLjQWn9uEqnRKM?=
 =?us-ascii?Q?PfRywTo3Yfcvurc4CXcyUWAC+5lLkwrwgiJN0l8/VpmuIdo30aPFpi1VvBzs?=
 =?us-ascii?Q?mdK2qtnIdrFJePQGonAsNPT+1c1+0VWG15ZmvLg2cogXSyFnje8+8ZNk/vsh?=
 =?us-ascii?Q?Glh9Qe4x6F3IXIgoJdWL0VJlFFuGE94H+ksz825eP4Z/GPM6mYXKY/M6z3JL?=
 =?us-ascii?Q?6GDPVtmwQO2nEziBfGEsGRkwGdsziR5aj6AiBeTh3JI1ezQeEQ23PJFZw3ot?=
 =?us-ascii?Q?ALVg8X/yIv265ap+9zDJ3iyAmxuVJ6DpTvt0GlnSHu2LVrmFpG8/+VsKUOWj?=
 =?us-ascii?Q?6p9ikLTty/vl0C59pzp2peKKWGx0Y6HhpEUBRZfE3m1nY89d+acd5lKoGA+N?=
 =?us-ascii?Q?vjb2C26AgTZlexNoYMe5tpaA3NMQMiQkdkImkEgNFxTFDTfF4v/TNz7XMmEW?=
 =?us-ascii?Q?BDbuJwgujcaqxorzC0XWYC30uemlM3PVOVVvPbrEDmbyXY1k2e1qpYZfEAgB?=
 =?us-ascii?Q?q4y/7fXa07rt6EGtYjD25rcIUs+ldWKZ5gT8Fy6MeaYw5cjN6peRjlEnAvDW?=
 =?us-ascii?Q?5H+sdvfj7xjefjyr01Lh3LmRhk+Pw0zGMuYQPNpgmUtjLIDIYTJrWjH+/Ba2?=
 =?us-ascii?Q?qD8AskOIF+2vfMuf/KtTZ7rQl2kD4MnGtkvnwdr/OdLC/P8fK85awi9UqbTJ?=
 =?us-ascii?Q?Jwsp4hYg3mg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jfkwHQ69CQguvyMkrR3FVj0Ws4P17DUnHQb60xWy8k/ii4clTAfrD7JgjThe?=
 =?us-ascii?Q?UKZwneldPHHwhmNn8pQ2UTVxQlAeiLfYoveEQP2kJTfLJlNoCHxyPWLjcd47?=
 =?us-ascii?Q?GfZDLqOUiTkF2AP/nseg6+whyTyCWdkkzzRf0IldJbG/ask8++w3kF05PNOJ?=
 =?us-ascii?Q?y5h9Y5MBPRbAa6xPFMk4elLzPW/VUqbUFuJ0/813vK5b/Yat8H8PYGOMqoik?=
 =?us-ascii?Q?CKzRpPUwUhr9Akw5k5hcZEgaoPx2UJwgUsUi5y6evSKtlDk3cZvMHkUQr/VL?=
 =?us-ascii?Q?YCh8yTeWu/JtSmY/WPiVP+h/9HyNuUI2PH+61PP1K1LUj2ipM008qy1PqjXR?=
 =?us-ascii?Q?oS0R5dEJ0ZRtIX4SnGCMICgc63VXtbmW/vYkINOsrGEAP3Uw0JL6l6c9tcYF?=
 =?us-ascii?Q?uveQf+iIN94JXTcqUIrGEJw4PObZtmRuyQCaERCVzNBhERCwQnGlIXQxgaJT?=
 =?us-ascii?Q?YQEbKIvpnf6Sn14jRNw7TWtiE13xXI28Yb8t9B6wJyCtGN96fykKCtuNH3ua?=
 =?us-ascii?Q?mBOI+QKkUbYHsb+vAMEO4onsbyuXSza/YQ0s82o/VTBxrXWv9ID3k79v6kM3?=
 =?us-ascii?Q?E3KS5i1c1nRPjLqt8B0Z9JVCn3hiTUE+OH4580Lr3tFwVBtedxkIOxmdDq8y?=
 =?us-ascii?Q?83MnnqAr7jXd1+zo42fxw+1rNUj+P98S4UwpIUwJzuSSLz2P8/TAQwFEfI/N?=
 =?us-ascii?Q?3gMFyx+dHrPAgGcuu0JBeV1rR/0uCtQlkiuvfKyDxuBSr2WJ3YPw6bES6wRb?=
 =?us-ascii?Q?bSvmQSbE4vL5ru+XucFtvjRRRDsQMPxdqoLtc2AB9y0obg84zYVChseztVZy?=
 =?us-ascii?Q?WgoUqZSthuSt3ZqBGeUTpyDsDzlNNfJuyazQ3YtEMRoAsnfaD8+nmeYwY6qr?=
 =?us-ascii?Q?nuZqbfHY9aWtV/HR7XilgTg+qhv2eQTgen5he9LScYkfNNkPHyQeCTOIQfRP?=
 =?us-ascii?Q?kHTuX4CyCVD0EpZlnbjYSYxBmH0mD0yR5RY1mp3TKkntBCjgpW0E6QfS+7rh?=
 =?us-ascii?Q?ZP8+d+sniI2uGVLgXDVPUnEUvBeB/O+JhYYLU1EwVg+6uKC0iFyC3t5r74Dk?=
 =?us-ascii?Q?+90L7PbZIfKOEjUbrQzj6SZII1EdTmakg3l63z1ZUo7Rrz9ZSyZv11AyiFW6?=
 =?us-ascii?Q?s2QdEM6SciwcrDgsc60lp3+KG35xbz2HvYlPI2RPkypsENY9muXKIds+nXEc?=
 =?us-ascii?Q?X40n38wBzngqAwPLmBj/SDqAQqJCZi1t8GLxDl8pUuuevMC7C1jzKRjdF3Ez?=
 =?us-ascii?Q?0AQ4LOdkZZGrfo1/66pr8Un5gij4YXsQuXPaJbAJ5B4Zrxt51RldqWVtgtPi?=
 =?us-ascii?Q?SUs4DYuFTLourqoy2ZlCPwKOZ8+NRssDnW+hjWsnRUjt9oALnFMU4gBvDsxn?=
 =?us-ascii?Q?26OgcZKVCGg69Qj/hliVaNStgBwPiS/kJ41VMJfMM9T8hulWoRiyDhdreAwu?=
 =?us-ascii?Q?l7Y5BV64Bed5hcE29DtIZtMuq2Ob+PbZ7vAKlTqSxNe55GKaR6QhHp9tg42T?=
 =?us-ascii?Q?Fi5Hmfoj+H/Jz7IUWDA8F3sRByx6Z1q9j/tgglNed8kX0Fbd0/rQvXiIJgc4?=
 =?us-ascii?Q?qWRPPawaEwjOza9b0C4gmQH2Y/kQMj4OG8cmBkQnKlsEdkCQqjXC8tJGK0TK?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35596770-40c9-4937-d743-08dd83158cef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 09:51:13.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnEkVvD32b38M7TCZ/b83jUqcPXFJnq4B0/W/PgkLQWpJcCye5lmmZhp1rwSoB/vTKPK/rs8TRAu2QI0VdrbjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 12:05:15PM +0300, Kirill A. Shutemov wrote:
> On Thu, Apr 24, 2025 at 04:33:13PM +0800, Yan Zhao wrote:
> > On Thu, Apr 24, 2025 at 10:35:47AM +0300, Kirill A. Shutemov wrote:
> > > On Thu, Apr 24, 2025 at 11:00:32AM +0800, Yan Zhao wrote:
> > > > Basic huge page mapping/unmapping
> > > > ---------------------------------
> > > > - TD build time
> > > >   This series enforces that all private mappings be 4KB during the TD build
> > > >   phase, due to the TDX module's requirement that tdh_mem_page_add(), the
> > > >   SEAMCALL for adding private pages during TD build time, only supports 4KB
> > > >   mappings. Enforcing 4KB mappings also simplifies the implementation of
> > > >   code for TD build time, by eliminating the need to consider merging or
> > > >   splitting in the mirror page table during TD build time.
> > > >   
> > > >   The underlying pages allocated from guest_memfd during TD build time
> > > >   phase can still be large, allowing for potential merging into 2MB
> > > >   mappings once the TD is running.
> > > 
> > > It can be done before TD is running. The merging is allowed on TD build
> > > stage.
> > > 
> > > But, yes, for simplicity we can skip it for initial enabling.
> > Yes, to avoid complicating kvm_tdx->nr_premapped calculation.
> > I also don't see any benefit to allow merging during TD build stage.
> > 
> > > 
> > > > Page splitting (page demotion)
> > > > ------------------------------
> > > > Page splitting occurs in two paths:
> > > > (a) with exclusive kvm->mmu_lock, triggered by zapping operations,
> > > > 
> > > >     For normal VMs, if zapping a narrow region that would need to split a
> > > >     huge page, KVM can simply zap the surrounding GFNs rather than
> > > >     splitting a huge page. The pages can then be faulted back in, where KVM
> > > >     can handle mapping them at a 4KB level.
> > > > 
> > > >     The reason why TDX can't use the normal VM solution is that zapping
> > > >     private memory that is accepted cannot easily be re-faulted, since it
> > > >     can only be re-faulted as unaccepted. So KVM will have to sometimes do
> > > >     the page splitting as part of the zapping operations.
> > > > 
> > > >     These zapping operations can occur for few reasons:
> > > >     1. VM teardown.
> > > >     2. Memslot removal.
> > > >     3. Conversion of private pages to shared.
> > > >     4. Userspace does a hole punch to guest_memfd for some reason.
> > > > 
> > > >     For case 1 and 2, splitting before zapping is unnecessary because
> > > >     either the entire range will be zapped or huge pages do not span
> > > >     memslots.
> > > >     
> > > >     Case 3 or case 4 requires splitting, which is also followed by a
> > > >     backend page splitting in guest_memfd.
> > > > 
> > > > (b) with shared kvm->mmu_lock, triggered by fault.
> > > > 
> > > >     Splitting in this path is not accompanied by a backend page splitting
> > > >     (since backend page splitting necessitates a splitting and zapping
> > > >      operation in the former path).  It is triggered when KVM finds that a
> > > >     non-leaf entry is replacing a huge entry in the fault path, which is
> > > >     usually caused by vCPUs' concurrent ACCEPT operations at different
> > > >     levels.
> > > 
> > > Hm. This sounds like funky behaviour on the guest side.
> > > 
> > > You only saw it in a synthetic test, right? No real guest OS should do
> > > this.
> > Right. In selftest only.
> > Also in case of any guest bugs.
> > 
> > > It can only be possible if guest is reckless enough to be exposed to
> > > double accept attacks.
> > > 
> > > We should consider putting a warning if we detect such case on KVM side.
> > Is it acceptable to put warnings in host kernel in case of guest bugs or
> > attacks?
> 
> pr_warn_once() shouldn't be a big deal.
My previous learning is that even a per-VM warning is not desired.
Maybe Rick or anyone else could chime in.
Compared to warning, what about an exit to userspace for further handling?

Another thing is that there may not be an easy way for KVM to differentiate if a
splitting is caused by two competing 4K vs 2M ACCEPT requests or an operation you
deemed valid below. Guests could turn on #VE dynamically.

> > > >     This series simply ignores the splitting request in the fault path to
> > > >     avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
> > > >     at a lower level would finally figures out the page has been accepted
> > > >     at a higher level by another vCPU.
> > > > 
> > > >     A rare case that could lead to splitting in the fault path is when a TD
> > > >     is configured to receive #VE and accesses memory before the ACCEPT
> > > >     operation. By the time a vCPU accesses a private GFN, due to the lack
> > > >     of any guest preferred level, KVM could create a mapping at 2MB level.
> > > >     If the TD then only performs the ACCEPT operation at 4KB level,
> > > >     splitting in the fault path will be triggered. However, this is not
> > > >     regarded as a typical use case, as usually TD always accepts pages in
> > > >     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
> > > >     splitting request is an endless EPT violation. This would not happen
> > > >     for a Linux guest, which does not expect any #VE.
> > > 
> > > Even if guest accepts memory in response to #VE, it still has to serialize
> > > ACCEPT requests to the same memory block. And track what has been
> > > accepted.
> > > 
> > > Double accept is a guest bug.
> > In the rare case, there're no double accept.
> > 1. Guest acceses a private GPA
> > 2. KVM creates a 2MB mapping in PENDING state and returns to guest.
> > 3. Guest re-accesses, causing the TDX module to inject a #VE.
> > 4. Guest accepts at 4KB level only.
> > 5. EPT violation to KVM for page splitting.
> > 
> > Here, we expect a normal guest to accept from GB->2MB->4KB in step 4.
> 
> Okay, I think I misunderstood this case. I thought there is competing 4k
> vs 2M ACCEPT requests to the same memory block.
> 
> Accepting everything at 4k level is a stupid, but valid behaviour on the
> guest behalf. This splitting case has to be supported before the patchset
> hits the mainline.
Hmm. If you think this is a valid behavior, patches to introduce more locks
in TDX are required :)

Not sure about the value of supporting it though, as it's also purely
hypothetical and couldn't exist in Linux guests.

> BTW, there's no 1G ACCEPT. I know that guest is written as if it is a
> thing, but TDX module only supports 4k and 2M. 1G is only reachable via
> promotion.
Ah, you are right. I re-checked the TDX module code, yes, it returns error on
1G level.

