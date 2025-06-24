Return-Path: <kvm+bounces-50476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15612AE61B2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27BE57B616C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9691327C17E;
	Tue, 24 Jun 2025 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AkpXelLw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AC821D59C;
	Tue, 24 Jun 2025 10:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759241; cv=fail; b=AuyZ6bz2ekKlFHbRswB7GV7D/VPBzyeec/iMsswljcTgZ7YbGMYOlcDbxhG38uUZwug/CxaLl+vRCkEvdap/E7BBfyurgBuu69LRoqiscgXYq37ADgEslwY+s3qyCTBaeS6doimFbih2s7dXLSMGrlQ7112Sgaok5S+wzJ4D8iI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759241; c=relaxed/simple;
	bh=qQ0hS0CpKZNtBPZRKi86atnMHVcY99SwkpNhpXvpXGU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EVHf+WHnRReUPjuSo5TjD0DnhFWFrAHm0KYhCpWFuSBxbupa04WeuThXx0Wn9B3qXPOvvLvzipKFDsLV2Pb4Nd+4L0lvLxXz+S6/KZfz4PA4PG2fB64P12wfVSIvoKnJUIpxFcqhRJmxuVQaKqFH0sYUUW10HLGgVkUllZIqv/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AkpXelLw; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750759241; x=1782295241;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=qQ0hS0CpKZNtBPZRKi86atnMHVcY99SwkpNhpXvpXGU=;
  b=AkpXelLwepbQOk5KyReSDQQhbZIczApL6e/++nD24ySEGbiE/NW5kYnN
   VtaM97jPw4aMKIZTMRFz6yBGqGOgPYUZEogiO8YnUkg2wKglM0oGADxAP
   VCr65cUky4K63EFu3EglCWz+BK767ZoOMRtZBxmhyFZYrIMxFiJ5//IiF
   nDmbQ9h/1pYySTYZ9jNMuyTaiAkNimwPIH8TTqdvswlb7abE4G2OPdQOo
   nyaSGccJatjQVamQ3cRR+9s4S8ixSKjpZSV51JKxAbEAg95D9+yUbFwwX
   45/i8Bgh/rPC28CJPY9xO2KIF94xVtpX0gE+jqtaV7TlRjF7IC3Sema3N
   A==;
X-CSE-ConnectionGUID: VYIzMH5iRDKViiJGJmzmKA==
X-CSE-MsgGUID: McZCx8JzRG65jCsIK2BFng==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="70414073"
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="70414073"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:00:38 -0700
X-CSE-ConnectionGUID: iXPe0MS4QBCbLfyTkYfD/Q==
X-CSE-MsgGUID: kziHrffZQy+rY3+mMJT+Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="157637049"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:00:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:00:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 03:00:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.73) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:00:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkoMC4Uqm/sNsaA7KtZbL1JaY3KlRxAWqh2W8beeIOnYEtOCk51ROmaRhzLnHf1UKrUSLpO1CKwMhQiyufupMM39vBlgb7x8IrEuaPlDAC2mPbBPzY6/xWsiQeK8WB7UOufPVec8aZSYoyZfUC2QaEEkRiT/g0HPQK0080cqnI4rSN6hY6nuCaDOUAF9VbFIoxcEX8p8haDUPkEyItrEHhatnftqB7mNNSN24tpaw7YRbcF0G/XAN7zFrB8kGWh9pB22ZjWxLCBmhgwy1dBBnHYp2fK9sbf5H6xaxNfSx/YaCHJXUk81LONUfZGAL/7uJD/L9Wu8IUufmKJ4m0qdUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOVurGyD8Y52wBzoSYkTh7zJ8JpYuTR1IXgg/q+vFkE=;
 b=MFRDRlCUFlPDRviKQrDJF39a8NHdytNp78p8JvDSlIkIxBxZbmPOEWKPoWavpZCf0GoZ71NcxOJE8yklsLNa2j36a+l8vAHXFlkdvrjyjb+NYvKbFhuh7MaTBOIZx4eR4e4gdQynpp7hHfTcb8sPmzZOWA6o4Ti7ZswsQe9ZmXc7+F55BpSb7Gp9RXO4A+G0H7yXS9A7NUglMYLp+YCzA77hVguS5edBo5QpNMmZX6ji6NI7eVpC5OlXg0+kRtLGe6e/WNXuUit2Cu0B5x3HL4rBMHL2LzRbKZHi3m6Ttz4t0OWp6RUIon54vVF4nr2/WOOLVrDgAa3C86VXmLoLlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5071.namprd11.prod.outlook.com (2603:10b6:a03:2d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Tue, 24 Jun
 2025 10:00:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 10:00:02 +0000
Date: Tue, 24 Jun 2025 17:57:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0165.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 84736ca6-d892-45b8-9dae-08ddb305e317
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?LxO+pg/dqlAWTsWVOcZEZ8KWT4XZu7mZ3kIhsvX/EZQNJBZLhkZ3DPcpIM?=
 =?iso-8859-1?Q?Pz8OyLIYrR7N9fPwM5hxNHzDmA5lDuI5M/Wi1XHxX3nsnlcCIXCZUCAjZU?=
 =?iso-8859-1?Q?eIDe6ffuLSeF3RBCpHbjKCzCvC1GBN8oqdxO9bGg3sCINaU903ni5jhJmE?=
 =?iso-8859-1?Q?Rsx4kwhL2YndIZwEBaUwbWX3i37+Gj/TC7eF6IFbNo1YZ5lpnzOklrxIIQ?=
 =?iso-8859-1?Q?FW6P/vOJGHbLD+aWsmbrrR+A+tD0xi69Y1y54xYHVY2l2PoiWNByRIlKkY?=
 =?iso-8859-1?Q?4nTaX0jXMbMi8ARh/HIRjZTt/k77Ls/D5oPl7zz/OFBXyVrfnvxkiJ2v0L?=
 =?iso-8859-1?Q?F3iWXOca39l++1GSFXsnW92iNZDR2WnDKbCqPoYbil9rL401UJBduJMNlt?=
 =?iso-8859-1?Q?3ChrkwvvXjqTYsuN+hPAlsynVCzO/iBFsdQzvbIwf70qQRA0gogmivd1JD?=
 =?iso-8859-1?Q?bAYHuMIRNw9j9ka3GvfQp/IPqro/rxbA9sqcv8KJMMfzVFf9F8xalm9Gd3?=
 =?iso-8859-1?Q?nCwbLrfKt5tHl8mZ7CmXAT3JRdLKvoKUR6eZsL0V95wly9QQHsWEQzyb3A?=
 =?iso-8859-1?Q?0FfaAi3OUTM5rWXuZWRh/jTH2AC6Rb+a65/htB+NNTpIEIwXibL0eIrIm5?=
 =?iso-8859-1?Q?XOdd3yhnIwUXr3525rGbPjHuSdh7/NplLVv4de7GzeP5ZgjcTML2qMRYrQ?=
 =?iso-8859-1?Q?rHzmraVNHfRSZuGrH7jciek+XewoXhmV+gO2NwghWsLBv5YYhsQigh264t?=
 =?iso-8859-1?Q?FZ8V6TYiE05DNlCuPZYeoU2u2HEbE04tIq70zCgTSFhMrxTgEUhff7pGiN?=
 =?iso-8859-1?Q?Cw5kWt8fI4WWXYnKPv0J62nqGhXx/qdGJ/c4taXzmwSk4ItF/Mt4j4+x7b?=
 =?iso-8859-1?Q?pm9Jrgl03Mv351SG2m2yZ5Qw/+NXqtGnl68dQsWfOK5zB6JPV8Qd5K7vYy?=
 =?iso-8859-1?Q?+LKl/ITmZHPoCSZoB+26CmvpspG96OljrTcN2D2+7gCOVVXYzhh+pbxQdq?=
 =?iso-8859-1?Q?DTQxOa4zlY8v50JKf7ldnxQQaUDCIO8fCnSTn3qngMssmISsHvGPV3fsTk?=
 =?iso-8859-1?Q?gYwRN5yzsEkvZJzaZBymnxC+grc3gFxBCXWhBSaYB4xxfrVRiH2U5SxvU5?=
 =?iso-8859-1?Q?MET+708jkznm4C4cP6POa8MnkfOp1qvZ6Ba3r85rt7Fj1e4ON7OBkaR4Kg?=
 =?iso-8859-1?Q?Pl0suJRY5mZCUk1mX6hSBmf+Ix2neT/RqsxThlnuAmR7TpNE9x/KlS8ZI6?=
 =?iso-8859-1?Q?N6r8e8746XJe96LGtP5qy91WE6CpmBBF0RUVR/wxrNbxVv6a8Jj8HKfKj0?=
 =?iso-8859-1?Q?M2n06tP/fzbhV6HCdioyo4yjl/4XgE52YRC+Pri8lfFhAutEF7gGO2R0G+?=
 =?iso-8859-1?Q?yEetrRmCqgn5wUiWFO/iGpHqM9wQjJ0FnhpGtb9+b46PGrh7Kmvx4JBzLr?=
 =?iso-8859-1?Q?kJk9z2jwt4vYlR6kQwSTHFNu0bR/Gpmp/Pdoahasoz7wsMmNnDWg3bxJRZ?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?UUb7KlNzj2sjSNNSwDR+jX/d1zsjbfemL3ZYvgoD3Y3NUohV3v9WiUsLzC?=
 =?iso-8859-1?Q?3z0Yp3mQ3DTS5u2JcNKteJlNNiOyKGon6EHCjcb2R0uar/UQHUUzDhRSVY?=
 =?iso-8859-1?Q?O6MUQ0109xx6TNoL8p+Uy6eqj2DPi9NoQW64tA8yaZjc0nHAf6NJ2k2lpf?=
 =?iso-8859-1?Q?yJmcnEwGqtw7n4GJH6prOhoybhFpAen8dB19wscBxl7F1RQ6R1RGEJxSMe?=
 =?iso-8859-1?Q?ukDWepicvNZvNLt0n+W9cGtVQp+SK2LGdWHh/DZvERpzgr5MPfh8oh+l09?=
 =?iso-8859-1?Q?6Hv038qk2CEaM1bItLU0hRemQHc/EXQixVci56ynj2VJ1lMJOV+CkEnoZu?=
 =?iso-8859-1?Q?7ggoq+qUpa1IXg/x7YaITkZrr1tpkiPP1Vpyggc4f6DnWh2D794hRyjR8g?=
 =?iso-8859-1?Q?WYWxNx6hS3B/dGdy5Gazj/IyMG1Nzz9045pQWE4B3P+//8a2EqnqZ6vzwv?=
 =?iso-8859-1?Q?4TRDnqT4ptLH8whgsYnSmLwxcdqMM59sWGbZabI+kGgpKRZvSyIPDCcbYV?=
 =?iso-8859-1?Q?utvuS+eAJ9qqG/ZA1cVN2ISjERbsNIoSESHVa3DP1h7KxYRMW8IYFICy0C?=
 =?iso-8859-1?Q?a+PH7DmN4yn258XWUw2L2RSDe0Yi4ycuymGPZCmq2D34yhBASkCXAbXjyc?=
 =?iso-8859-1?Q?Zz4dOF8nNP7/494yQ/Rt/yi0qZTWHz5EtjW+whz9Ko9WD6aT21frwmEiZK?=
 =?iso-8859-1?Q?H9DZP3oS11NuyWcHNsTVS5u4AzuUaPU8J29OB41/8YDB4yOFKWRgWIXuJX?=
 =?iso-8859-1?Q?yp8MOiaeBO+S4+wzV4TDCZdg0bjxHrkhq8sD0WYsYsMfdTtPhR439G432k?=
 =?iso-8859-1?Q?8TkU5q8gK7Mh4qd/h9g8Sa8OSOtHFN9D7pbbCT+52WITXKbsFh7w5GIOwv?=
 =?iso-8859-1?Q?WMW6cjJ7qYmGN6Fn5Wcjf0iEubZYESQjm4iaZJAxvFtTJ/wGt+IYh2vFrd?=
 =?iso-8859-1?Q?DpgUBaDO64uIoyYldSWWtTucOlkNMNrWdb9hybtYTfz/XyO94QrIObUBqF?=
 =?iso-8859-1?Q?Tl3r71gpzmeKFXgMOso4KkSFjp2W8PWK3/eGmlT54bd8O6kl06XUfXdO6c?=
 =?iso-8859-1?Q?KEcKa1F4lKcrvy9LCdVqC3fLlE8qLfzhyvd7qY626SuB1NXEGxj51oN4LB?=
 =?iso-8859-1?Q?3UK+AtkOqu6TYKXJCdPrAgjkRWD+MpK4LNWtdL/yROq+3t6h24FWYpYRh/?=
 =?iso-8859-1?Q?IqN8WncxxNACR02pGKfitwldhhKi5XnwQaoN2+o+lFLrp3v9ujdWJWQ+Rt?=
 =?iso-8859-1?Q?/e2HUPauMoe/iGDFcU8YbKe5+JVaDYtEz4Ay7x7zSetfaHdYKnIaC1LLgn?=
 =?iso-8859-1?Q?gHE2BtGKDIgXqRA766JJjWd/ffFJHqAoUcwF3B6vnq08XV2PI8hrISG89P?=
 =?iso-8859-1?Q?onpRe4+l22y3PKoPjfuXZH7kVv4aHupDDwitMBe92IAFexrJhLHbxQXq1e?=
 =?iso-8859-1?Q?DGsJHYjd/tKonESRQIuOzWREiTRSK/Ujqlkg6jII5REk5YvREdd4PzDAXK?=
 =?iso-8859-1?Q?MAO7zNjb1NIdNiVofF72xWXc5OpZYvNtBx7zniTpJzEG9bN18TgTaRO0kv?=
 =?iso-8859-1?Q?CTFjX+28Wjs3zZZzKETk6sXsfLPlBS5/IHko63w1PEjkipj9Ri6WpmdyaY?=
 =?iso-8859-1?Q?fxhouig5XcJY64EgvJTxFGO/yWIqUm8esT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84736ca6-d892-45b8-9dae-08ddb305e317
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 10:00:02.7251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFLzhrA3UWNMNHcmehbHqjsB3uFTPqttohr8qkPDpjPsqDRZNFgjjnqTtUTpeW8V+7tI2LD6owbte5vZL6dvtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5071
X-OriginatorOrg: intel.com

On Tue, Jun 24, 2025 at 05:44:17AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-06-20 at 09:31 -0700, Sean Christopherson wrote:
> > > On Wed, Jun 18, 2025, Yan Zhao wrote:
> > > > >    when an EPT violation carries an ACCEPT level info
> > > > >    KVM maps the page at map level <= the specified level.
> > > 
> > > No.  I want KVM to map at the maximal level KVM supports, irrespective of what
> > > the guest's ACCEPT level says.  I.e. I want KVM to be able to completely ignore
> > > the ACCEPT level.
> 
> This is what I was thinking, but I'm starting to think it might not be a good
> idea.
> 
> The PAGE_SIZE_MISMATCH error code asymmetry is indeed weird. But "accepted" is
> in some important ways a type of permission that is controllable by both the
> guest and host. To change the ABI and guests such that the permission is still
> controlled by the host and guest, but the allowed granularity is only
> controllable by the host, feels wrong in a couple ways.
> 
> First, it turns host mapping details into guest ABI that could break guests that
> rely on it. Second, it bets that there will never be a need for guests to set
> the accept state on a specific smaller granularity. Otherwise, this path would 
> just be a temporary shortcut and not about components imposing things that are
> none of their business.
> 
> Instead I think the two impositions that matter here are:
> 1. TDX requires size to be passed through the generic fault handler somehow.
> 2. TDX demote is hard to make work under mmu read lock (already working on this
> one)
> 
> Sean, were the two options for (1) really that bad? Or how do you think about
> changing directions in general and we can try to find some other options?
> 
> On the subject of alternates to (1). I wonder if the ugly part is that both of
> the options sort of break the KVM model where the TDP is not the real backing
> state. TDG.MEM.PAGE.ACCEPT is kind of two things, changing the "permission" of
> the memory *and* the mapping of it. TDX module asks, map this at this page size
> so that I can map it at the right permission. KVM would rather learn that the
> permission from the backing GPA info (memslots, etc) and then map it at it's
> correct page size. Like what happens with kvm_lpage_info->disallow_lpage.
Could we provide the info via the private_max_mapping_level hook (i.e. via
tdx_gmem_private_max_mapping_level())?

Or what about introducing a vendor hook in __kvm_mmu_max_mapping_level() for a
private fault?

> Maybe we could have EPT violations that contain 4k accept sizes first update the
> attribute for the GFN to be accepted or not, like have tdx.c call out to set
> kvm_lpage_info->disallow_lpage in the rarer case of 4k accept size? Or something
Something like kvm_lpage_info->disallow_lpage would disallow later page
promotion, though we don't support it right now.

> like that. Maybe set a "accepted" attribute, or something. Not sure if could be
Setting "accepted" attribute in the EPT violation handler?
It's a little odd, as the accept operation is not yet completed.

> done without the mmu write lock... But it might fit KVM better?

