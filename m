Return-Path: <kvm+bounces-52265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAA0B03513
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 197D217274D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4A61E5B9E;
	Mon, 14 Jul 2025 03:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pt3CqvV2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6EDDC5;
	Mon, 14 Jul 2025 03:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752465494; cv=fail; b=O9zcWhD7T21iQ2rbLiad+fSSaYHK2/wSTw7K1TRiP1kM7XImLUD7oXa990FxMmLD57ryEj+51u7hHRcqGSAhk+pEbgKZHVbPHWzaN2M8CRO7vQDelUwutDvBL6MJLMLQs/ht+DhNml5PjfOkCsjMDiKXAZLXmuHMblQpRIysr/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752465494; c=relaxed/simple;
	bh=lvq+ddSKT8gZoD7yU+Ui2a47Ji0JMym1rW6KIiZjEww=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S3Wa8h3/S5Q5g4FGDgtExeZcPlw8p2YdERX1CNks3ZStCIdm9t1GmSAVwU7wz4o/2+Uk4OlgG8zGcVMSz1Sq9eTHKesLl6kqpfdl70UQkW7hxI/JMJlE4ZSAtieCc2g274vjresBC5QsbEzd2NwHyRZEZrx2NhyX5sFjJI4Ai/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pt3CqvV2; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752465492; x=1784001492;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lvq+ddSKT8gZoD7yU+Ui2a47Ji0JMym1rW6KIiZjEww=;
  b=Pt3CqvV2ljSjiBQN8H9Fk+hh3+mBL+lMBW0c2Fi+bX1N59NE+qdBG1HN
   /0+4VXnkM91SH0xU2/dRXK+SVLfMOaT3dfpQ12L7NEfRs5xliG0dv93BH
   Agy2oZearxZ4m156p1I7FmEOf1ATZxUWsj8sGxjwVnoXgPuo6fyStTKCs
   LsGCTBlrnpX3Q8LG2oO6P+c4adds+q8yV/Mfgx+l9s6p9WicxVt4yNXHz
   4iDytufFu2wL3zEAAumXa+vUWdEvZUYKz0VQ3BasGpFA18XPkexAO4Hio
   thGEL5ZDGuVX3lhu/pOojZUcNP3+FMwQphSSj3S9rww0Bj06U2VVfw/Cj
   Q==;
X-CSE-ConnectionGUID: xMSdHnMjS5u+wJRWxL6VUQ==
X-CSE-MsgGUID: 8Mj/q8x2QpGE9LX9DL4vnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="80087300"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="80087300"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 20:58:11 -0700
X-CSE-ConnectionGUID: /85WLfcSR22NvJeE4hIUTA==
X-CSE-MsgGUID: PlsaDbkmQGu0dVU8w+cYjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="161157219"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 20:58:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 20:58:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 13 Jul 2025 20:58:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.41)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 20:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPJjFYxWJYV3ItNldsIomBha4S1Ioa1lqH0y416ZBWgp7YntRfGPG5k0jkoRamezhXx+eQht2ZoWA01+I2eBnBwMtAQ/wwUo8cR4OQ6omw2eZcVsiA5XZHELFUEiMRCxSdqlgEAuOAx9pz9xtp63vAgs53VhzQBwFMUA4OZSp8oYblJVO0x19txBs78QomaElhtXfAw/sMd/B0AOhgJxrXiFwcLxcy4fPWtNZmNikjsERSnBG0kUQGImJ37Ca0ElhN+LKFqw8KW3UZnJfYhZ5kVvB64UZkT4t/kRszK7LZij/spqrHwHPBiy/AoQEqmU4DutdnYKj+ZqgJH9mLcduQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5H/hdjoFeQWsS0WugV08rdl8HoFUjcpUOsLGW7Xp50=;
 b=IKPyjDAGyI9kWU7Oykm/wZOJpwSPUeKnnowAO7pzAnYOpat2ihenykzA+cRYj1qx2UQaOKpB1SLFFCw7+hwFxmlAxMBqY0GxEvecbNKuPrvWUAGSNLdTrHMJ8dtsDFGAXInHDPEvWSr9jHL9rLloTm+KfFKf4P5WvPmAiTT/7YD7ENmCmw1UNpgFB2dG/oqC/IB58jPDFAEZbRfIr8wLgKuCO1Dl7Wwk+OIW5R1aKdyl06h142gO4lo7DpAn0tVuKEAsUaY8etnOg82ZqOXnkQZ80y2tRmlC7xTMrV92I5mJbX08B/E7T1v7H2QWc3F/eFn/TxJmTuPP4OpAAW8nTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7114.namprd11.prod.outlook.com (2603:10b6:806:299::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 03:57:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 03:57:34 +0000
Date: Mon, 14 Jul 2025 11:20:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aHR3gJ7zaedTjitU@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250711151719.goee7eqti4xyhsqr@amd.com>
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f5b0d8f-4eea-4f2b-5637-08ddc28a903c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QZZd1ItkGAdFb5o/t9rYBgsm6er6fNqfcP3WE+ObZKNu5+NQCAXHCrN6X3kH?=
 =?us-ascii?Q?j4YDhGUSCAqX0d8vKjAHZAzlkQLs7y+1aBes7Ctd8okQ6iTNuQJIMloEzeQq?=
 =?us-ascii?Q?cUNSBYCyg9dv7rc3JhvlDpnRRmnl/VbO2apxGyZP98+3/Xh21+h1dFxpTkny?=
 =?us-ascii?Q?91HHwuMNCRXwn0WMrXcv2GyPIpy6f2YS21YrHUP0x593nQWvq7lY8Ijvg3Kv?=
 =?us-ascii?Q?dgC4wueBJqusnyeCEkBkRrcE+SqKoqGsL71ERPh16gtHM5mvrvmmR/AzBEMP?=
 =?us-ascii?Q?MlRgM5jfaj97hGfjMF7WavitJL12ZRMdFY4ntxSgP32mIIfZ0INkSQDgsDs/?=
 =?us-ascii?Q?9vj3+5BbXqiGZ+TA2rhQiCBjCmeUNwPbpFlIUA5jpZYCl6U9721OEnNo8kUW?=
 =?us-ascii?Q?eS/eveRyPV9Z6YyGCw12rdNPtO3+EBxQrwdzGwyHFGwMeVrIXs4F0fR0EzMt?=
 =?us-ascii?Q?D1rtWar/68DvvxxQUA262pRqM3V/W0+Dl3woX+ofvvLL+jeBwgQlLn0x8qcm?=
 =?us-ascii?Q?rDDEjUJz7mjKLLGVcdeFMt5Om7j1dV7g5DPTk0a0b0fcTIHI14YcwglfZH++?=
 =?us-ascii?Q?FHkeBg8+xkdMFyIL5IFMRYKH77ts9/3VrPktS3LS/9Qjk1mYA52exo814A2Z?=
 =?us-ascii?Q?5x0GoJrlZ74QxKGRXry/z8+ehAo4r2qiiIf47xYYwhEAYoZXjOT6SPyYpPlc?=
 =?us-ascii?Q?nQxO6Xf0SPH3WoqBsJtsYavg07s6PWz+43U/QCfGB6CiT0L5imgiKMONMcBT?=
 =?us-ascii?Q?QS6XLQGxok1z759455rfeh+SQWqhMkh1+B21UAWoNIZ463Xc8tmnqf8DA0UV?=
 =?us-ascii?Q?GqymQHrd8uLhLAxOs61DkS3/qqxoPZXWbFevjdkqrb0XUhR4LSlWXRKZUsH3?=
 =?us-ascii?Q?3GVsUd90TdPFABHHjrDRlJvXZ7CrM19bHSgnH6rizZ1/6z7ZmULOy8b4h4y1?=
 =?us-ascii?Q?BP+xvhZfxPYxGnWcC5LJyUPQ09mxZ2tq44sZ3xKcFP5Ent1/P2yoSC6q9QBC?=
 =?us-ascii?Q?N5RPgKyEQbvYQn+9/rV4EdTEEMew2CL2y7JKFXPmexrGIBSm4hZaL6TvfW7U?=
 =?us-ascii?Q?IHdTUIb2WwQo3cg6aIfDD2MUzin5xmLfFP8w4r3b/MzdXOMbPirIN1EkDb36?=
 =?us-ascii?Q?PkNtGeiumKjsm9ZVyKB7H8OlUfSZn0NknLXvY5Qpn8gAPYzA0s2M2k/m1GI5?=
 =?us-ascii?Q?/QvoujFVGMDTykQiYu3/gRW9n3hFpamMNxVTkAuj7IouNXPMn9ePeIF4+Uti?=
 =?us-ascii?Q?T2knZQLcRQw5oYshAvKwaoSihbz62V1q16MhIdIHNJqOH1nKTtA+Q2nxxhNX?=
 =?us-ascii?Q?cJf6BgcfIeaYMOmYWwNpkzieEhB4Kcnn+VAVSBqtT0JfBoq76m36RPyyAR6A?=
 =?us-ascii?Q?nwXVAbPW7Ry1fu2TjIlEMBMhf8ulYzMfRWyazkbNsaDUSL4k84GeH9yUFX4m?=
 =?us-ascii?Q?ptbEqij2Z4s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqZbTwEJl+sRHb43aab9lvAIpjcp35QdqQhe9ZOiX7S3AusZthJStwAvNfQE?=
 =?us-ascii?Q?UFQKnwXxtPQR648y3plN1AhXxTojPI5QXrg0U8OvSPGcxjiFcLsm+pc7c2Ug?=
 =?us-ascii?Q?CRORwTyLjHmGicUYY4An2aCxABksBJKbsHyt0b1U6HKAuzg2K9Olzn+24Pj8?=
 =?us-ascii?Q?M8LLlCSJcjfYbLST0zyrMJVHq3Yx3WpJYJV+KexftCUZpxuhPPXJkMAWOcnf?=
 =?us-ascii?Q?E2k3nAsXucdEO3sAdxzcU+UP33Z/ZywGjLvTrxK/9/u1U+HBJkug0CWOtAE7?=
 =?us-ascii?Q?rCeXko77VnQnCi6N8gcRicaISAdS4Ura2z1ULfsmkFZ3mrNky6Sy6hDsuKbL?=
 =?us-ascii?Q?3Z9tdzwajuVdthb1ASMUqPCHFoG0EZ0N9gDxal7RZk+/fSwDZO1qZ8i+P14d?=
 =?us-ascii?Q?QSUHJnspbP9xkDUlaqyGR2Akl66/rZTXsyb+C7Vo4eXf6wdPUUBMZn6b76Iu?=
 =?us-ascii?Q?BMhrAe21pXM9W01lkRsNTV3IB4esmaTBVrFtc4a+dYIulH0QNk0E8ZbE8fVV?=
 =?us-ascii?Q?tSs7DmWB6Q044Fmzt7mRNhBTEeq5b1U67MMJaogxjEPi9++kYnKqzrQ4OR0R?=
 =?us-ascii?Q?SJSE+QtzBfy4x2XrRwLacQqVzRgl5jbJNrk6KQoRZY5aLOg1ekusvbXH0uyv?=
 =?us-ascii?Q?yVj5tK6c5PQVDaKRLjo9/E8+i/pfpxD79I5kGEW3EXQ/RyjqFJ1bnNZ8lpM1?=
 =?us-ascii?Q?duzmz4fQ5MvS8oBXYBKQC2sQriaCPmktjcjTnBeg4kICyeSo9rGUod0edGX6?=
 =?us-ascii?Q?VGtbSl+b76WJgP3w6tLxWfDvxgl3hHKh9ZcDfpyAUDbbaYaRUcdIKTvAJP37?=
 =?us-ascii?Q?eONNjAe8O9qUGtrNEcu87WU/hGX5gIrb9/ADfD5m03MSwZ21NrwYTQI4oI1L?=
 =?us-ascii?Q?WDEujdZX3LXiCK4JE1rbytIkcRGJIpQm3z/uRytRgeCUGhXS0shxSN6AhgaS?=
 =?us-ascii?Q?bkhSLSVBiW2Mc14RjYCjVCTyuEpCmtFL5mwjW0M+0jsuQ+ogqYJA5dy5U994?=
 =?us-ascii?Q?e8DVu64iflawNOIh/KmmsdMEJ5qt1zYv0wfunrxR5hDptc2dJ04ghOTYWH+4?=
 =?us-ascii?Q?QDTXBflOp3h49CufhVjg71c3A04gz/m1SjFV0dtt91p/iHoITw5kuQxAwTz0?=
 =?us-ascii?Q?VYhGjedqRPHVHfLtYo42PsYZn1CAM4/H3FaXl+TVl7ECU1ZLHRPQqVSIgK9p?=
 =?us-ascii?Q?tgZeejj7ALWAyFltAYsfaU8oesGEZZ4wtcpd34YKTTF1KGmk6pE4jrx0KjCU?=
 =?us-ascii?Q?GyY6xB5LHlmyOU5H4CEg1lXqGed+2RHHiRGq7UydjOp5k+owdR4NAx4JpxC3?=
 =?us-ascii?Q?y+ok+htzg6fDXpNzoXjIm0VEcvgOA3EdiXJ8d/BXBTkk8dfoo9HFqox6qKBw?=
 =?us-ascii?Q?IZIyFb5EqrYMZRT1PJfbRtfHc6/XP1AG3/fUshznP95NKo4TmtnRT5Md13By?=
 =?us-ascii?Q?7I7fgWWpIneCSoyUoQYolXmJaLG65rW6oBX/JzRzaro66kwUf9ljl8tZayS7?=
 =?us-ascii?Q?KSYFqcLodKiKXTSbcpWi5TGIgp5Ef+jSBkTy/A1XfAwKF/UXllSqnYduBwGo?=
 =?us-ascii?Q?gPWDJdAOcp7RpyogMCz/P4tvmZURQN6qDdnuM4q4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f5b0d8f-4eea-4f2b-5637-08ddc28a903c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 03:57:34.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKVyad7MALNzo+Du561KTkLlmpt3p7aclWcoxW96ksuVGJC9OBMLnftxYIhrSn00VTxhuIdBGvcdhWbMunfi5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7114
X-OriginatorOrg: intel.com

On Fri, Jul 11, 2025 at 10:17:19AM -0500, Michael Roth wrote:
> On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > On Thu, Jul 10, 2025 at 09:24:13AM -0700, Sean Christopherson wrote:
> > > On Wed, Jul 09, 2025, Michael Roth wrote:
> > > > On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> > > > > Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> > > > > to use open code to populate the initial memory region into the mirror page
> > > > > table, and add the region to S-EPT.
> > > > > 
> > > > > Background
> > > > > ===
> > > > > Sean initially suggested TDX to populate initial memory region in a 4-step
> > > > > way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> > > > > interface [2] to help TDX populate init memory region.
> > > 
> > > I wouldn't give my suggestion too much weight; I did qualify it with "Crazy idea."
> > > after all :-)
> > > 
> > > > > tdx_vcpu_init_mem_region
> > > > >     guard(mutex)(&kvm->slots_lock)
> > > > >     kvm_gmem_populate
> > > > >         filemap_invalidate_lock(file->f_mapping)
> > > > >             __kvm_gmem_get_pfn      //1. get private PFN
> > > > >             post_populate           //tdx_gmem_post_populate
> > > > >                 get_user_pages_fast //2. get source page
> > > > >                 kvm_tdp_map_page    //3. map private PFN to mirror root
> > > > >                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
> > > > >                                          source page to it.
> > > > > 
> > > > > kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> > > > > invalidate lock also helps ensure the private PFN remains valid when
> > > > > tdh_mem_page_add() is invoked in TDX's post_populate hook.
> > > > > 
> > > > > Though TDX does not need the folio prepration code, kvm_gmem_populate()
> > > > > helps on sharing common code between SEV-SNP and TDX.
> > > > > 
> > > > > Problem
> > > > > ===
> > > > > (1)
> > > > > In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> > > > > changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> > > > > invalidation lock for protecting its preparedness tracking. Similarly, the
> > > > > in-place conversion version of guest_memfd series by Ackerly also requires
> > > > > kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> > > > > 
> > > > > kvm_gmem_get_pfn
> > > > >     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > > > > 
> > > > > However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> > > > > in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> > > > > filemap invalidation lock.
> > > > 
> > > > Bringing the prior discussion over to here: it seems wrong that
> > > > kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
> > > > chain, because:
> > > > 
> > > > 1) kvm_gmem_populate() is specifically passing the gmem PFN down to
> > > >    tdx_gmem_post_populate(), but we are throwing it away to grab it
> > > >    again kvm_gmem_get_pfn(), which is then creating these locking issues
> > > >    that we are trying to work around. If we could simply pass that PFN down
> > > >    to kvm_tdp_map_page() (or some variant), then we would not trigger any
> > > >    deadlocks in the first place.
> > > 
> > > Yes, doing kvm_mmu_faultin_pfn() in tdx_gmem_post_populate() is a major flaw.
> > > 
> > > > 2) kvm_gmem_populate() is intended for pre-boot population of guest
> > > >    memory, and allows the post_populate callback to handle setting
> > > >    up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
> > > >    calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
> > > >    setup of private memory. Having kvm_gmem_get_pfn() called as part of
> > > >    kvm_gmem_populate() chain brings things 2 things in conflict with
> > > >    each other, and TDX seems to be relying on that fact that it doesn't
> > > >    implement a handler for kvm_arch_gmem_prepare(). 
> > > > 
> > > > I don't think this hurts anything in the current code, and I don't
> > > > personally see any issue with open-coding the population path if it doesn't
> > > > fit TDX very well, but there was some effort put into making
> > > > kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
> > > > design of the interface itself, but instead just some inflexibility on the
> > > > KVM MMU mapping side, then it seems more robust to address the latter if
> > > > possible.
> > > > 
> > > > Would something like the below be reasonable? 
> > > 
> > > No, polluting the page fault paths is a non-starter for me.  TDX really shouldn't
> > > be synthesizing a page fault when it has the PFN in hand.  And some of the behavior
> > > that's desirable for pre-faults looks flat out wrong for TDX.  E.g. returning '0'
> > > on RET_PF_WRITE_PROTECTED and RET_PF_SPURIOUS (though maybe spurious is fine?).
> > > 
> > > I would much rather special case this path, because it absolutely is a special
> > > snowflake.  This even eliminates several exports of low level helpers that frankly
> > > have no business being used by TDX, e.g. kvm_mmu_reload().
> > > 
> > > ---
> > >  arch/x86/kvm/mmu.h         |  2 +-
> > >  arch/x86/kvm/mmu/mmu.c     | 78 ++++++++++++++++++++++++++++++++++++--
> > >  arch/x86/kvm/mmu/tdp_mmu.c |  1 -
> > >  arch/x86/kvm/vmx/tdx.c     | 24 ++----------
> > >  4 files changed, 78 insertions(+), 27 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index b4b6860ab971..9cd7a34333af 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -258,7 +258,7 @@ extern bool tdp_mmu_enabled;
> > >  #endif
> > >  
> > >  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> > > -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> > > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
> > >  
> > >  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> > >  {
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 6e838cb6c9e1..bc937f8ed5a0 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4900,7 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >  	return direct_page_fault(vcpu, fault);
> > >  }
> > >  
> > > -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> > > +static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > +				 u64 error_code, u8 *level)
> > >  {
> > >  	int r;
> > >  
> > > @@ -4942,7 +4943,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > >  		return -EIO;
> > >  	}
> > >  }
> > > -EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> > >  
> > >  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  				    struct kvm_pre_fault_memory *range)
> > > @@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  	 * Shadow paging uses GVA for kvm page fault, so restrict to
> > >  	 * two-dimensional paging.
> > >  	 */
> > > -	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
> > > +	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
> > >  	if (r < 0)
> > >  		return r;
> > >  
> > > @@ -4990,6 +4990,77 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  	return min(range->size, end - range->gpa);
> > >  }
> > >  
> > > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > > +{
> > > +	struct kvm_page_fault fault = {
> > > +		.addr = gfn_to_gpa(gfn),
> > > +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> > > +		.prefetch = true,
> > > +		.is_tdp = true,
> > > +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> > > +
> > > +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> > > +		.req_level = PG_LEVEL_4K,
> > kvm_mmu_hugepage_adjust() will replace the PG_LEVEL_4K here to PG_LEVEL_2M,
> > because the private_max_mapping_level hook is only invoked in
> > kvm_mmu_faultin_pfn_gmem().
> > 
> > Updating lpage_info can fix it though.
> > 
> > > +		.goal_level = PG_LEVEL_4K,
> > > +		.is_private = true,
> > > +
> > > +		.gfn = gfn,
> > > +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> > > +		.pfn = pfn,
> > > +		.map_writable = true,
> > > +	};
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	int r;
> > > +
> > > +	lockdep_assert_held(&kvm->slots_lock);
> > > +
> > > +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> > > +		return -EIO;
> > > +
> > > +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> > > +		return -EPERM;
> > > +
> > > +	r = kvm_mmu_reload(vcpu);
> > > +	if (r)
> > > +		return r;
> > > +
> > > +	r = mmu_topup_memory_caches(vcpu, false);
> > > +	if (r)
> > > +		return r;
> > > +
> > > +	do {
> > > +		if (signal_pending(current))
> > > +			return -EINTR;
> > > +
> > > +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> > > +			return -EIO;
> > > +
> > > +		cond_resched();
> > > +
> > > +		guard(read_lock)(&kvm->mmu_lock);
> > > +
> > > +		r = kvm_tdp_mmu_map(vcpu, &fault);
> > > +	} while (r == RET_PF_RETRY);
> > > +
> > > +	if (r != RET_PF_FIXED)
> > > +		return -EIO;
> > > +
> > > +	/*
> > > +	 * The caller is responsible for ensuring that no MMU invalidations can
> > > +	 * occur.  Sanity check that the mapping hasn't been zapped.
> > > +	 */
> > > +	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> > > +		cond_resched();
> > > +
> > > +		scoped_guard(read_lock, &kvm->mmu_lock) {
> > > +			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, fault.addr), kvm))
> > > +				return -EIO;
> > > +		}
> > > +	}
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);
> > 
> > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > log:
> > 
> > Problem
> > ===
> > ...
> > (2)
> > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > - filemap invalidation lock --> mm->mmap_lock
> > 
> > However, in future code, the shared filemap invalidation lock will be held
> > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > - mm->mmap_lock --> filemap invalidation lock
> 
> I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).

For the AB-BA issue,

kvm_gmem_fault_shared() can be invoked by

(AB1) the guest_memfd (supporting in-place conversion) used for the init memory
      region.

      When the memory is converted from private to shared during TD's runtime,
      i.e., after the init memory region population stage.
     (though it's unusually to convert GFNs populated from initial memory region
     to shared during TD's runtime, it's still a valid for guests to do so).

(AB2) the guest_memfd (supporting in-place conversion) which is not used for the
      init memory region.


The get_user_pages_fast() can be invoked by
(BA1) the guest_memfd (supporting in-place conversion) used for the init memory
      region, when userspace brings a separate buffer.

(BA2) the guest_memfd (not supporting in-place conversion) used for the init
      memory region.

> There was some discussion during previous guest_memfd upstream call
> (May/June?) about whether to continue using kvm_gmem_populate() (or the
> callback you hand it) to handle initializing memory contents before
> in-place encryption, verses just expecting that userspace will
> initialize the contents directly via mmap() prior to issuing any calls
> that trigger kvm_gmem_populate().
> 
> I was planning on enforcing that the 'src' parameter to
> kvm_gmem_populate() must be NULL for cases where
> KVM_MEMSLOT_SUPPORTS_GMEM_SHARED is set, or otherwise it will return
> -EINVAL, because:
> 
> 1) it avoids this awkward path you mentioned where kvm_gmem_fault_shared()
>    triggers during kvm_gmem_populate()
It still can't.
Forcing src to NULL will remove the above (BA1), however, AB-BA lock issue is
still present between (BA2) and (AB1) (AB2).

Compared to fine-grained annotation to further address this issue, I think
Sean's fix [1] is cleaner. Besides, Vishal's concern [2] that "userspace can
still bring a separate source buffer even with in-place conversion available"
is reasonable.

[1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
[2] https://lore.kernel.org/all/CAGtprH9dCCxK=GwVZTUKCeERQGbYD78-t4xDzQprmwtGxDoZXw@mail.gmail.com/

> 2) it makes no sense to have to have to copy anything from 'src' when we
>    now support in-place update
> 
> For the SNP side, that will require a small API update for
> SNP_LAUNCH_UPDATE that mandates that corresponding 'uaddr' argument is
> ignored/disallowed in favor of in-place initialization from userspace via
> mmap(). Not sure if TDX would need similar API update.
> 
> Would that work on the TDX side as well?
I believe the TDX side will support it as well, but I prefer not to rely on it
to resolve the AB-BA issue.

