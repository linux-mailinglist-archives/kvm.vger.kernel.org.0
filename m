Return-Path: <kvm+bounces-58508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CD9B948FF
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95ACC16BAC4
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C6830F7FB;
	Tue, 23 Sep 2025 06:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ee/ScL+L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DE135959;
	Tue, 23 Sep 2025 06:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758609132; cv=fail; b=ZUQGb63XMax4Hssd39Nlv/+cIVeXURurdGppeGtrOakfypMx7s/BZ4oOKkEJLdjocOEgPCARH6y2xmM2v5U3kZTB5HgrOZ8ymm4et+YlT0hoRXI4BaM1WWtn4TBekB/O0N5FQWRuPr3mE26z30AXtiSO1VdCIerKSFB0k/6rRdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758609132; c=relaxed/simple;
	bh=xXRU57aeXe5OcZVyNn0qXqbOqL52nW0Np5M9HbOpE+s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bZQMe/WlYC9kuffjGGuF5exfiQbFaBx0b3hJ7O+6kO0esvjMHZdWhvmIwsoi92CVozYvhrSc8w8B5CRq+v4tKFIHHq2BdTkuBPBvqOO4Gik472QKnLx59UKl44Qf9phd6BWJMMDj5jOvJqwgLDk9moRdHmpcCtnJB+TLck1Aces=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ee/ScL+L; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758609130; x=1790145130;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xXRU57aeXe5OcZVyNn0qXqbOqL52nW0Np5M9HbOpE+s=;
  b=Ee/ScL+LttENKbMniZjfEpw23oSYZrAYzCIbEJemieqmEH5UQ/5fZuu6
   LJcYUb1g6Wa1tiMHG+RTSRB7kDlAafWs/VpAxyxw6iPrV3tQAs2HVocy3
   7U/oYBlORRZ4ZWbnjDXt8i+4MiNpl3d+/RkDmdtJelZF4VM4Jauedbr1Q
   86oJSfdpsybF3vjZxZnOEN1JL1gG1HueYzUqEPnBd/6QP0UzCtsso0Tw1
   NA0IRJLV1tPDV6kr1Ux+fRna6z/ERxQu0rAt/vV//u4pRaqfgZTFe3pKC
   Y8fP/iyCaBOPkM1lO/Xk6l/RRuUXXyBprICgDAvxPiADcJgH14JkWdnQc
   A==;
X-CSE-ConnectionGUID: KbpKiKhBTWe1S0nSdX2JVg==
X-CSE-MsgGUID: RuiCIhwQQr67ixhCTrk77w==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="64705511"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="64705511"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:32:10 -0700
X-CSE-ConnectionGUID: BomjfL4hTJasAG6Iull8vw==
X-CSE-MsgGUID: vVvLZnP6Q8S3UzlqHSZYjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="181850403"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:32:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:32:08 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 23:32:08 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.55) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 23:32:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBness7ltbt0qQmbk7XT5GZc9CYGJZCyXEpOlHNfHOwwSACpCLHiP3G3zekIfs5bLab6p3bNGlOlMgrgOMoit+FsF1g7Rb0y/a+LmB11HfLxYHM2hklh1j0xAIIJL2KavlxN9b1xet2O7F0mqo6WgosRIz6cULtzQeNdH6OFzcQfW+SM9ew4riZFOWDMiSwNYZfHQOBAnLxW3ounMd+N9p5Cxno86aD4gHdxwkqtEAX1wfQLV9vcRoWstKHEoOeeHMxaKrQVvsvcjZa94oYG3wb0mv494hTQjOG346G9Dz6XMP5E1MF8YWH9ntWfkQf4Au1wtH29Z76vcQ/uc47sEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JvYn5Rytndhdl2AbTs3J0g70Bmu0cM3bELd6uSDNNc=;
 b=ML9zTwAWjmgK1LC2aSFodF3VYtVVOvMWQum0otTZZ4oW/AgoTwqLj6+NpioSwzDPBJM54XrvzDbIC6Yv4lqx6zmB0LL1e5+QQPjt38/OQwlikM0jZc+KmrKZkrGeIT2tpLyYKjeSPw7SS3agqn0YLRh0csh9iDQxfxXjRMzBpomo6c7NCMGXB7qMwhLJwhXnN+lZmulaDcfV+FMbiLlh45ibMKidkh5r/Fd9YAYm4uA/PRpb/cE0n6oqNcFhlQN6qwuyKkYrPOhZNYG65DrRut8cip8CU9vi5KE9Nh/KSUgyamYinW7G+SKnuDlxiD0p61EUWMO6hKTGIjslE9hldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB6530.namprd11.prod.outlook.com (2603:10b6:208:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 06:31:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 06:31:59 +0000
Date: Tue, 23 Sep 2025 14:31:47 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 49/51] KVM: selftests: Add coverate for KVM-defined
 registers in MSRs test
Message-ID: <aNI+07tytIMh/YvW@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-50-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-50-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:195::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: d32dd82e-c102-4a02-98a6-08ddfa6ae60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2ocII6PN5Hnos9ZzKrBn4vOPjL4OPpN1h0D8/EWm05pTF0lzwlfFUE7HucLO?=
 =?us-ascii?Q?3AiKTjuhfdSILa4bnZDiNlU2k3j38Na/Rx8Uel4lyAbXp2VNKe7O6qzrhRH4?=
 =?us-ascii?Q?5ArqY2mDa72iQwthq2ykUxsCcrzf3cmXLuNukdqMB6ZCUqy5rWnr/oxefwrA?=
 =?us-ascii?Q?U/igDdyUdL5HxuhLdPwT27k0lFjSUy3/6ykWn55/0xQPy/kMjkSIfDFPl8RJ?=
 =?us-ascii?Q?3ymj9hOCunL+MSHRl99zgZFikL/C/T3pzZyqcZVMmGA1X0uXpxHZCvayGf3w?=
 =?us-ascii?Q?OHrqIVMwsJMMHoN0X27S7RDaIz6K3JM/XakM+kzieEl+fLjim4D8B9pncakr?=
 =?us-ascii?Q?wrUEkOJEK+Um72ad9EorLNqmwQYpnQhknM9wNEam43YKErQK+RUqRziNlNP5?=
 =?us-ascii?Q?AwEgxI9RknKvvSaFa+ivckMxm74W47sxaqSc30CN5vvxpmQcYCRcBE5z6JaX?=
 =?us-ascii?Q?E1rdL73bKPFy3q5XIIhB9wNoFZUgXqijmkNsMDOeLJInCpp0OswJrteWCHu5?=
 =?us-ascii?Q?IuAguPohua8cmHJk36QazfGHVitBvEmohSSl3OUF+WH5jY7w4j5zifObtPWn?=
 =?us-ascii?Q?KZtJ6MMoJ6E3R87diJZUj8qkFFGwtp86lAAxrDwuvdGRABXzmdbkPQjw2uqw?=
 =?us-ascii?Q?Ko9ybVKkBNG9cwz8mrNT7xFCckuG6zDITs5fmxgs9jlAs08yU/vJPaFuZN60?=
 =?us-ascii?Q?xEPxkg4Z3kpnCH2y0jFsA7W3JoBJd7SjrO7ZIbxteDxzCSfUmDmIupIyg+ri?=
 =?us-ascii?Q?BzO8rnQKDUiXIYJjsEbx6NBe+QhXZHi2Rc9+meLKsu7znrCI8aZ7mhD03ca6?=
 =?us-ascii?Q?iUc7UhzPjOMxfVi03/qJEXQbZ3yh75a/gQu/g2J6+Wmd9O4DImqvjkOHHXi7?=
 =?us-ascii?Q?Q9L/NUxFYuc5AJAv0lIvbnzY3PpwPitzBYX23pXxCZa4dBqpQRnbju9g6ryO?=
 =?us-ascii?Q?mj//iliMTQmTHuWvQHOHMEzYTRRK6wN39HDsC7EnWvAktIteHBQLXLI6Pe1J?=
 =?us-ascii?Q?G5TwUVndsJER1cAX03z45EFa/8Sn0mVzBNQJLUnJyHG1RSzyqMXg5hklJrJA?=
 =?us-ascii?Q?/049qfDP7BNj9BMfmO+ElL8TUMYm+gACd+4Rv16ac7Csu1qRi89WNG9NYTa7?=
 =?us-ascii?Q?Nngmtgh9vadEER9JVcX/xINhBS3nfkcfSPD/eBS8T+fi2CyuNYtDPPjM5IAk?=
 =?us-ascii?Q?YRcK/FQmN0K7O4j688XayxU+ig9K2ZJHdFKYJw/UkgjiDuWQp9J1Y7Ud6IkP?=
 =?us-ascii?Q?mfQNlWRzrCmtduJDXLEDBfZAMhaihhsAEbwjeZ7Kwe4x1s05+z1OMymF6xqT?=
 =?us-ascii?Q?42TcWjaNjMlLENwxOWVhSvKRHT+8A/oh6KRg4nJIjUF7wUfQv8v8FIByUZXb?=
 =?us-ascii?Q?2h7hTFByjVMh9liIqYrJtB2vGv9ekSGJZFxZwcxIF+cF74vywQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BsLyoozGGrLQnyLQaNpivbGG6Kw/2HIGRRB07gd51M6eTevNhgl43uZ3DpKV?=
 =?us-ascii?Q?hRW0S6i0xBa3rACFb01LH1VPbBOUKv/pHfs1lWt4RvkbxcKUHsKBm9K4lFoG?=
 =?us-ascii?Q?E3j/CfOGOA0n9+dMfqN7+WhfzAPxEtwxgaSWznYw+JHUDTETNLdGLubXHm67?=
 =?us-ascii?Q?5b3jfQ/mLXz6gBEGJ1DorzDCIR0G5n9B6zuvoICqxEEiCwRLYgLv3oXlL0pF?=
 =?us-ascii?Q?lp8Grzo0HKaHIdRuybrKqDYSFpWjjwdC4gMohLFRJYTX5KRw5czMIV7wcaAe?=
 =?us-ascii?Q?HtFSIAeQPpgRvTV3lwR3IUpsBI5KGFj+wtgLfA5O9EkpdXrXCOIKgpxr4ck9?=
 =?us-ascii?Q?ZkqoUBT02STATzWy2+BtRN7zJthYzBt22I8f6x286ly8WSVDYGWkxHU+BtvJ?=
 =?us-ascii?Q?fJsdYqHLPM5n5FB+Hjp4GzlDZhzd1vAsR02sEMWJ0j/8B+knJBygNBx6xel5?=
 =?us-ascii?Q?rv8RVwaXk0H6Ha2LFgtj4CICVrtOXjnt72uXubF+3qp2mmjhCy1IaW2Yha0h?=
 =?us-ascii?Q?6DrKgiDsbrfUH7bdOW/j/OMSw2H1emd9NP9sQw40o/Dfc27dMYGc211wcK8k?=
 =?us-ascii?Q?rtKx+PrrbzdXaTVrvzDoJu5WkujKWz8mlbP2047VNFDn2J3ohjZwVo+0BTET?=
 =?us-ascii?Q?i9QIb/kSQun3ZdBHR1koCmxLe0OGVuCcntftLuFvZAJLAVPxRDaDMkSRyS4J?=
 =?us-ascii?Q?SxAa7uBelZUSdVF7WZX1fcfBi4soXGUUODt39qin/kGFyOKn+n9vBB1HV5qw?=
 =?us-ascii?Q?gK0T984Sp08mtEMRcqjdvi+9Qzaknj5xT0t70AKQe9WOobNqueT1fB+G4oLN?=
 =?us-ascii?Q?zEtqrdlPn5fwLQkhcUiPmzeyeh/BqVBXeV9hRWalxt+YooGycIqEHm6MndVQ?=
 =?us-ascii?Q?BufxMwjfir1oUNXKr/xOsHig8du5wcto53LoiNnURvxiBmtNruWolVzObmNU?=
 =?us-ascii?Q?mdor0hlXU1PsAzkO+ccF4go+zmwgiUsIKTRBW5l0nWCXSatyz0GpRPSLD9U9?=
 =?us-ascii?Q?GTPeNzSBlztIZD1CCiz393b2FpZ0bAsl+gQd9k4AOJjqA3Ox0ardUYBbqzmR?=
 =?us-ascii?Q?FEoi1DknV4p7Ey5jtLxVqr1wMib7oPnFWaENSt9pYlM/w1B5EQPgtdzZmsyk?=
 =?us-ascii?Q?6CpQwvvoUi4bozDn2wewA0E+pMJHBYTZhmRT8x29jNcsVYjFO/9UZzLyCSYK?=
 =?us-ascii?Q?yPvQYrb1Eo5AKQyX5j1ZCFd7BhU6vOex0Nr+7eLc8ryZKapgDw/lxba1cbdP?=
 =?us-ascii?Q?tKj41c+rQDmFN8oj+w/zVOJpCOt9sd5zLiuYk9TE0yKziKj7Z5DUkKDiWrBn?=
 =?us-ascii?Q?TcWkLQkVdlIQU04TORBcihUq2sErvJueBVqZCyhV4RVr5FB1j303I5Q0P5q7?=
 =?us-ascii?Q?DRnV6E96YRUgZNgyuXIxH/4T+51gM2kPn0zR5llKg/3Q0IlOwpI7qYU2WE3e?=
 =?us-ascii?Q?1KXlC9JjdEiePoK8O5ECkYVICvX8jl5HQrlKMksDXuh8EgDqOQ2g6qSTSdww?=
 =?us-ascii?Q?JGtGzt/JSsCiiV0uvpEM0sk/6wIHeFAv693Bt0yd/KiJN1tcfeOH0EL0/KEg?=
 =?us-ascii?Q?HBqyA84IX2ntg+r7LtuueluD+y5de6UsMxjQMn44?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d32dd82e-c102-4a02-98a6-08ddfa6ae60d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 06:31:59.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cdTCsoZFi5d5GnDMZX2Cy2DVvLO11Qm8pJ4SB4o5FQHW9TXivtGCJdLMXhYD7IJoJGtCfxwVfKozVRhWoIxbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6530
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:56PM -0700, Sean Christopherson wrote:
>Add test coverage for the KVM-defined GUEST_SSP "register" in the MSRs
>test.  While _KVM's_ goal is to not tie the uAPI of KVM-defined registers
>to any particular internal implementation, i.e. to not commit in uAPI to
>handling GUEST_SSP as an MSR, treating GUEST_SSP as an MSR for testing
>purposes is a-ok and is a naturally fit given the semantics of SSP.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

<snip>

>+static bool vcpu_has_reg(struct kvm_vcpu *vcpu, u64 reg)
>+{
>+	struct {
>+		struct kvm_reg_list list;
>+		u64 regs[KVM_X86_MAX_NR_REGS];
>+	} regs = {};
>+	int r, i;
>+
>+	/*
>+	 * If KVM_GET_REG_LIST succeeds with n=0, i.e. there are no supported
>+	 * regs, then the vCPU obviously doesn't support the reg.
>+	 */
>+	r = __vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &regs.list.n);
						 ^^^^^^^^^^^^
it would be more clear to use &reg.list here.

>+	if (!r)
>+		return false;
>+
>+	TEST_ASSERT_EQ(errno, E2BIG);
>+
>+	/*
>+	 * KVM x86 is expected to support enumerating a relative small number
>+	 * of regs.  The majority of registers supported by KVM_{G,S}ET_ONE_REG
>+	 * are enumerated via other ioctls, e.g. KVM_GET_MSR_INDEX_LIST.  For
>+	 * simplicity, hardcode the maximum number of regs and manually update
>+	 * the test as necessary.
>+	 */
>+	TEST_ASSERT(regs.list.n <= KVM_X86_MAX_NR_REGS,
>+		    "KVM reports %llu regs, test expects at most %u regs, stale test?",
>+		    regs.list.n, KVM_X86_MAX_NR_REGS);
>+
>+	vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &regs.list.n);

Ditto.

