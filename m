Return-Path: <kvm+bounces-57694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7DEB58FA0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BB0E3B3AAC
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA4824338F;
	Tue, 16 Sep 2025 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bWGYjk2w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67BA198851;
	Tue, 16 Sep 2025 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008928; cv=fail; b=OgYLMqsu5iz1Y95PQ2uj27/phz+vUClIjyIJOa33h7MN96KRCJoyf1gUN3unw/aJqo7dWpU6hbKqC853DBFJhqmxRei1aYwtGhPs8JtU1hu5muFg3XkARiY6aD8JVXQ46WRbJ511BBb8QRigYyxH1MfYX0TBcf0Q+p4v2APe1Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008928; c=relaxed/simple;
	bh=ASIx10wHVMu4Kto9sODvVYXwZs/TVY/EklUIr0Aq9dc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H99RTeSjv60kbNlgXKl8YxLqydJnwvl0Ed/8udjmFQVm7DzdCjbaKQgh3tuOCazI5X/9/HH7UY3RyunEZNt2BH4M/5GAXYG49fcG20Imhx6PuaA/r5054WlxWR0IVj8RQ/zy3higlTA1LOe+xC1bXRXD5+g52syQdSypa0YFLgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bWGYjk2w; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758008927; x=1789544927;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ASIx10wHVMu4Kto9sODvVYXwZs/TVY/EklUIr0Aq9dc=;
  b=bWGYjk2wIDlZTeA3fWGtaTcPzzfxZqHIcRRN+aFHupmb2JvuyQZNpZBG
   LzOBSN5u8hVksJD75JlLB4r+P90tnq/5uD6k1iQuNDtANslJrWWIWOCMV
   fLbZfgJDLbKZZdbsPPvTkM0xZh+j1QdIA0Y/JIm7m2t7ovGEZ8h5ehXan
   r/lpDi1cO5ZJLpxyqGtkxr0SZKlTRPPJ2qjBkLTkpKz6Ik2dhR2ji4vUX
   f8f0Ba8opZ2/YbDXy4HSlLd3LxnJNxqpYDFLBoc6Gio35ob3An1IOf5Qi
   PTaHzsfcNOhAIsqIX6Ghu2ehLu/Ykd9YDZk8wjP/N6NwFdhGhg/PfU/b8
   g==;
X-CSE-ConnectionGUID: u92tWvpnRIC3Aj2x5Mt4Qw==
X-CSE-MsgGUID: 1Qp7TsU4THOTkPAvT/xADQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59502905"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="59502905"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:48:46 -0700
X-CSE-ConnectionGUID: xxAv3hjhSNi4/LZ20DPdCQ==
X-CSE-MsgGUID: OmknGdg2Q3CZ4x0xInS3bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174164544"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:48:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 00:48:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 00:48:45 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 00:48:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjkaBN6q/pY2mMa0MK4LjFluaqv6JejKdNIUmMMzdAJxnrMYNhpyczrbj8GXRLQtwNLAkDj7c09o/DBdoKfkx+7jEZIOdIeezD0PcjZpf68MJLwYYxwygEUUa74N4Lbpy4a5GNDndzA3iRVcn9VaimtJmLGO00ewBrlGtPR5sYWTsqCljGZfmhvGNMLUDOnNTzDUtxohrq+chsR1nw/cFzjQMJrWUtRBO+JYVYLKp/uuu6W99rbVbwEvVd2xDMHawmyeC+YIMu/ceejO7LN5jxFOrEa9D8H+nDDwxTR44vxdfZhd7Kf7lgjQtdlKlXZBlY7PeU71K+L31wAwv3LApQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QD4sksC4kChFxyQga/GGxG4VQ81YdBIs6kaj3xc++C0=;
 b=iVvIFppB6DPwlcsV/0X7hSp8jaxlTBsf2iedaWqeqdh7oRPHiKkZqRn/c9Hb9vDhX55G+pPhdA2+dCAxBKyKxc9nSrbntUaGhLAkbanGwK3N4llr62yo2mP6mTOR+qNBQvXzKlwAn03llSXh5mAKHZXjPstAMuLznFIb1WhA44ZT3NbWXuJYvgvNcWXqcRcAroTXSGv795RVqZ5Cbd5kaRN8noqMifam7RaUT86O+Tf4F3SLM3NMh42ZG+ClE1Chpx16RUC2vx+1kJhSw1OJ162a7Ul29bL40IhdldsQRiWGA+Fgm7YYBBsBL9fo8lX8QiaBzjf5478liT50mMoEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7066.namprd11.prod.outlook.com (2603:10b6:806:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 07:48:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 07:48:43 +0000
Date: Tue, 16 Sep 2025 15:48:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Zhang Yi
 Z" <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 14/41] KVM: VMX: Emulate read and write to CET MSRs
Message-ID: <aMkWT/8cBVwi2mfN@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-15-seanjc@google.com>
 <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com>
X-ClientProxiedBy: SI1PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: f6148f9a-94dd-4c7b-3205-08ddf4f57550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yERU5EQpb4hnOBbo2iHd/5AZZpZvFSQ8M9vT4EfFXSSRTAaAwshy8gu4rAlQ?=
 =?us-ascii?Q?AJFHrZQUT9HpbwoDmbJNIUQ2J0B0p9yKWzwXxJ8b10IBFNgOzNVZW4NbuiIo?=
 =?us-ascii?Q?/wAJIUw2ZkTsK6NJOPUp1C0/HEmZBzJK02XwRtwuS0qcB0xUmioJvqVdBrzr?=
 =?us-ascii?Q?qkzAxQUfb+jk3RZfqSinTPXf8Y+6O4iEp84S+/RMZis2mX476midnCa8onbg?=
 =?us-ascii?Q?6Wye+nVlchC+siY6pt+V4SKBFhyIfGszobXJJtCzCWHlXnDf+pcYiWXta5OT?=
 =?us-ascii?Q?QU8AHm+WDt/qDniGeyVRwYayvKm2RRd8ZGalkHQtkJpkPgb1+oS4NLJagnQu?=
 =?us-ascii?Q?ESGSDCnzjJgFUV+Ie+z7IkLZuyV1ZUnWkdcc95K6tKW1yOSuVH1+5JjaE1xE?=
 =?us-ascii?Q?AixR4XZD1lkc2saouufSGpsF1inmsv8qcQLLtCh+kEaVHNxVgt5JywnAnBO+?=
 =?us-ascii?Q?K0O89ZD7Yq8kTFdzKWHdTjyJjdfPybMcRpRA99piGfs6/g/JluJ6GlV7tkbC?=
 =?us-ascii?Q?wBFEfuXEKtkXYAoSIKTn2UWDt+kmufC9DtXwmanpXKUqOs94tLlaScK8yuoq?=
 =?us-ascii?Q?pEmOCi6WN5Pa9zC7A1mxho0cYaus7Wr5EyLLjfJ/temYJnENhP8pYHRcYrl4?=
 =?us-ascii?Q?m8Ds7JC6C4TtmUMPQ0ViHg+nGS774qISNxeWCzzvuo2+gjXLTl3SEpb1vzrp?=
 =?us-ascii?Q?+O4wIqZxvXmXlrujmJCwqrUy3NIhHGc341cG8uCKwuEtSNhz1lckbAyS2oDN?=
 =?us-ascii?Q?ctBNnSlEt20fZ7hvyZcBxAVHo29Gz1nVbXnNMCTgGd9FWi4Me6vm1hSdhtsj?=
 =?us-ascii?Q?6OZ7tlif4tLNJA6xkesnVT6h+fqK/S8aHXbGIfd03/pVmQP4WND93709L4Ed?=
 =?us-ascii?Q?/8En5KFWbPzkCcRIjKcbA59NNncK4jUG/jOfB5jmppyLohnl7XZ+KwIX3rlj?=
 =?us-ascii?Q?iJ3qzB4j6g7cOm9NsEX/CdOo9Vv5iZC6DHx4Qlo8HNYuc9xVCIah4rt7QRdx?=
 =?us-ascii?Q?d/4CMGfR20OergzpRuSgT+WouqPPgpWMedSK9QWoUMLszFD06Wr/Vz9ywnwB?=
 =?us-ascii?Q?E61th5Cb2dEe7xRDfceIqoeFjYgjiTbkI8MDkL4cjX+g5VXzbwVAg/4o8qov?=
 =?us-ascii?Q?/ZwLye3ZAr0gVlluvoB9JzmSL9hlStAueDyY39NSw0CL08dx3iYI8NHnazla?=
 =?us-ascii?Q?7LLYfL0p5F9IWpSMk89CGeRX3087GFH15JAXvj9bH2fK2/N1JDvVOq6mR7FY?=
 =?us-ascii?Q?SOafL6VMCymtxXnXtfJm3jDwhe8Z/QQESnIhiq8dpEliia/16iKO8txmRAbK?=
 =?us-ascii?Q?wwTNClRNGf2JQ/MKNFouutzBAkmnOUGbuni6rOeMiu1rwfkZ0smPEror1Z12?=
 =?us-ascii?Q?MnUbMXg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4O6gr/GmOAWYp0uQxEAYlBn4SMRu+RG/GijaWCE2DSMS46tkL0VJGt8uDE9+?=
 =?us-ascii?Q?M6wcnYp0wLAPPvT4nrIoqkdBuMYMAZB0FAWA18AuSEBZZnY9H1CRidRTOjgq?=
 =?us-ascii?Q?dip2IgjYhv04G+dyWOxDXT6Au4SmYCtdjgVO7fbPb88Tf4amm5Cvowg+lUbE?=
 =?us-ascii?Q?OXcxWMhAAfhj+CtsTB+1gLZjC+vLaBUJjEh36YRoc5zFv3YNB/QdtMGUj9Nc?=
 =?us-ascii?Q?nsmCgCPjSCnh74rbt3F4RipKXP7d3u+Dmliq2+jQMPViS9Cd7GXz70kCHEwf?=
 =?us-ascii?Q?LKypllDSNzRT/LeTzIdTKl8w7XBdWKHbQViycvBeJIJTT1rnlpCvcsjXTT5X?=
 =?us-ascii?Q?ddAQ9V2hysiO/UBgKIJwE2UJXAtvQgfa6HtAcy+J7r4xL27NMMXP7bsyw/fD?=
 =?us-ascii?Q?EF/1jtStRpDxrw+97kLyCwh3QUOv6nzkA8C70dBb1UMCWTA3YIbRjKaXdJKK?=
 =?us-ascii?Q?Q7APW+L6iynJm3LO4MNzHSAKKUaeS/qLtgNMRL+exAmBUhOm5vf/I3jRk+1R?=
 =?us-ascii?Q?GeT+6sI9vX9mobid0qfXlFxi3+3/uF7Fy88ICYtnkrakmpQVEbuT+NP5KSlT?=
 =?us-ascii?Q?YRi0FdrodOUEChhfZnoT5uEnAr1InuAl+U9EAaXK6BVvdu22MmR6X6FWZZEP?=
 =?us-ascii?Q?UMEyNf3zntiARMCfXRqxXQ0ABBPHREh7Exa20awp+ovNNcwKxf4/p3QeweAn?=
 =?us-ascii?Q?A1rw2OjDuzCHB1N7XvLg0DhJ7s/ZEW8sZ6xL5FF26rWawWiXh8aPqlkV7mK2?=
 =?us-ascii?Q?yPzLV5ABxrRSGYxIs4iiCricZV5FEkc8TbJBwCDK21ebvKS7D37zfJKR9Pog?=
 =?us-ascii?Q?sSAEt5j91ZE3xcnZglu+njcDoDfv/way07I3gj71HvrH4znHupXgj7vWwpyY?=
 =?us-ascii?Q?Ag+KFEi9Pix2ldIyaSXdVwEgd7OFRWPd3WOAvdSHMGfx4PRjlf5eKfEDeE6U?=
 =?us-ascii?Q?OLAHm8CRs+Vk+JUAD4Q1seCsv8MslL50C37po1U7FIN87NRl9E7NJs2q75AO?=
 =?us-ascii?Q?IV6ZULHjIc2XTmpPHKzkVaH5qVstgHqh1A1XujXopzz3eT3tMKHtmQ8GfI80?=
 =?us-ascii?Q?IaWcTmK4HJv89sSD521bfL/FVblpEstfhcabbS91CgNfvr5zDWe6WB+DOGwa?=
 =?us-ascii?Q?8KRbO2D+klS9NQ2690GtUYwZW/HManHqdrTtsQEnUNyCGCVRAcz2gCx7f1WS?=
 =?us-ascii?Q?jDZBMxBvsH/HyREYHID6akkB0aLCzrBUrvb0ZJ6IGtx7d4CBGk/edQ5D+Aa2?=
 =?us-ascii?Q?tYfoq019tHIUFr40fQ4IanIQ5V6oY+Xgw7gbP8rSLzvIavO97tM3yle8mmgx?=
 =?us-ascii?Q?PvG4Ayx8u7zjLdoNgadfH8pTAKLux/MGxTlLy6gqb/shrVcln32s9piqTBFG?=
 =?us-ascii?Q?lJPALHHeknbFWhbkYLjE5WHMhSCsFpvcCvNynd6emjaZqwQrvGA4FZmiEtKV?=
 =?us-ascii?Q?XRxOx28OYiQSozvSVKAG/3yIW8SkmLdL6GG05kTItIqwjVCJYkLDYgtnM2n6?=
 =?us-ascii?Q?z3K5KDMWF3EQs/LPgIyfbMhn/t2eSkMpOO4YbbGDQBR4OpQE0JH4pDYqcnEN?=
 =?us-ascii?Q?Ckl4jkdHgbMPKnbETNcyhj0O7bj+4OuvrEE+hTUt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6148f9a-94dd-4c7b-3205-08ddf4f57550
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 07:48:43.0567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8IGp1mGJCjIEvQi+/CMNdlX9sEeih+20WD7xK6CldgwDzzEiR+TpYRSufL42f/cw6TsxOyreftoZtE+Ey69Uhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7066
X-OriginatorOrg: intel.com

On Tue, Sep 16, 2025 at 03:07:06PM +0800, Xiaoyao Li wrote:
>On 9/13/2025 7:22 AM, Sean Christopherson wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Add emulation interface for CET MSR access. The emulation code is split
>> into common part and vendor specific part. The former does common checks
>> for MSRs, e.g., accessibility, data validity etc., then passes operation
>> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
>> 
>> SSP can only be read via RDSSP. Writing even requires destructive and
>> potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
>> SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
>> for the GUEST_SSP field of the VMCS.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Tested-by: Mathias Krause <minipli@grsecurity.net>
>> Tested-by: John Allen <john.allen@amd.com>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> [sean: drop call to kvm_set_xstate_msr() for S_CET, consolidate code]
>
>Is the change/update of "drop call to kvm_set_xstate_msr() for S_CET" true
>for this patch?

v14 has that call, but it is incorrect. So Sean dropped it. See v14:

https://lore.kernel.org/kvm/20250909093953.202028-12-chao.gao@intel.com/

>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>
>Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

