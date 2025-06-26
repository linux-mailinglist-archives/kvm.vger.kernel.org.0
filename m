Return-Path: <kvm+bounces-50782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17501AE9382
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCBEF1C428C6
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE1F19047F;
	Thu, 26 Jun 2025 00:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsU8ACB4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBFEEDE;
	Thu, 26 Jun 2025 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750899177; cv=fail; b=OvEY1nmlmRJwbONmrLRIyaxvrbEf0c/HgoFEopfpl5pUOjuqooYRq7e8OwnNeMlZL2RnfPn+3I9WxWJHaqFwf2WgB9Q/djuTfOBMJKjFhYkcbUpaUhSwfrE0ZHLG/bMUiCeveCFz/G+RXOAHcrHJ2zAkWz5QDeEB5aKWgKRHXAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750899177; c=relaxed/simple;
	bh=u4zknCmPZSi0EPyYaIsmye3fDgdA3yF8AtfKoGZxnOY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pc4zL3qdYgjE2Ge+Q1lKJC91ZZKkwTWqXTGCb8WDIz2z8iYATxE849Mo6fUzbs2XFCowPj9vDUrcaxeSXhuXC+DrZquMZRJJbpmbHwoiAJNBqtlI+h/irJwuJuhYo1o6fg/mNX4ku+KOesfLDumX2dWfjnOEtXbCdT9RWWdnneo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsU8ACB4; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750899176; x=1782435176;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=u4zknCmPZSi0EPyYaIsmye3fDgdA3yF8AtfKoGZxnOY=;
  b=DsU8ACB40DXArep3miENlg52nAokUvM96NZD7hxFSt3llsb2LjHT7WF/
   B73y+q+slIaX3ixHJxWmTTczmoWgaDDESe69MkDETsCtHHyUx6aQycJ6A
   O9Obyc/jOg8MxuRWC3rw5XTDC9L0ri20uUNYDiettqixzbF8nI4UYLMmN
   oGLvx98VX2N5Fc7xj4dqF/d4pLhXkyWLKoeK7TKOe3+67z2cs5y1iT/7O
   EjyWKOXM7eO4+2ePfinjDt7hbp+cv5gsIiAo7MqYbDhU4LE2Et3LuKKI/
   t1iZculffnIcK7CnCds08KKucKMVmL3Vaf4Z32UQW0zaVf9drUZDWz1mv
   A==;
X-CSE-ConnectionGUID: +5LWcKSATBCLVGlvYvG6nQ==
X-CSE-MsgGUID: 9u7E4hb9Qd63fMFDrGz8qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64542099"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="64542099"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:52:54 -0700
X-CSE-ConnectionGUID: zZiwI+0KSDKdWt6xWe3GzQ==
X-CSE-MsgGUID: AXJOmKDLQ76e2cRXPvekpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152134189"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:52:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:52:53 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 17:52:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.86) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:52:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AH2RFWKwoO2IRlrl/TrNxg2Rm7ku8AMWDfmnD0I1ddzGams+L4IPcEtsMIYcdfacbAvrzbihCXaWV40gm3yYmwK46wZlXAcwKGekAjehAsJKcII+utkunTaoIjcc5O+aWsOmzwhixfaeWfLCNC9eZI3c5dcJ9G/hLa/TIUc7rzb5vh+kj+VflToe7Y2TWanhbgoRsGaXp1ZOrSOuEpUtSzWnmQwSBGX26b9qLIKZBN1nvyczioQfRwzx3VfmslGFCRtoskYEySVbu0GOvjcQ+q2TYa3Co6pRxDqrTdApi+qhjV6MZn9iVoX+G/eBhzu3s2fBleZDLGhYom/FgBHm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EdhDRVsLJwqdDcwpPDK/xUlvkA+TMHTUdAUv0dKD9g=;
 b=VEyNxl9K9xO3t3ogC3YSFpgpIXyCdjb1tD7dDB4ghL2ah9HdVqfnF3AvpKjVlGKUMAVWhRNDf+NETUaqw+vr4fvTmDPsedeVsiYNu+y5u/XpXhcJYQ8iXYVmAlV32b6zLM8b+MVMGTS77LmOqFD+e2uogULPD+4sj6VP4CRZZyKk47/onF2WhXLP4QRYstsMGKsw7aFmyJjB82YLwuD3ThsBsBNCGSURWjXURjMhrMVj5k+5IHnlXQRcb350NTNxARStFUh0bt96dT6/qtfWl5QryXoga/0wAOvXaV19o72jC7vGt1R1w9egt67hKWVJkGRXalxzNxnPaEVfVnB1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4708.namprd11.prod.outlook.com (2603:10b6:5:28f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.17; Thu, 26 Jun 2025 00:52:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 00:52:49 +0000
Date: Thu, 26 Jun 2025 08:50:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"tabba@google.com" <tabba@google.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFyZRvN/qARWcZkC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <aFvDIDZ+Y3ny/WuF@yzhao56-desk.sh.intel.com>
 <97cdcbd6ba0305fd3875813e46b6f625dde0d0d3.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97cdcbd6ba0305fd3875813e46b6f625dde0d0d3.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:4:188::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: 3326fbfe-d448-464c-0410-08ddb44bc5f1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?+zhXP54uNr9/8gqEXkiqGKABC4LmYLyRyrM4mO/9lNNrKXsO5zpZAuzQVz?=
 =?iso-8859-1?Q?tZpIpj3UUKFOKyw2naXf4UrmgyfFRzBR9hJyWcGCBNmzX2aCFVFTssYPRt?=
 =?iso-8859-1?Q?KLjf2xT4M+9mJW7WYjPveZYDtHYU0xRwJe9YXui/Kmi6PuADB7HFujqNMi?=
 =?iso-8859-1?Q?pYkcpl26JwLCAEQr14gzO78etxyJC39YvKcmrSuLNCcWB35/7Tm1IDiA3/?=
 =?iso-8859-1?Q?hSvxbSrCpRGhDXmi2ak8RAOHfJjfl9gU5UD1/afQXvHFDbuGxuYxeMYqKO?=
 =?iso-8859-1?Q?D/vqrzm1KhfkC/OSQgyh++ByY1rm9TZHlSrxwBNzgzJywwIzokTp6qAndB?=
 =?iso-8859-1?Q?wPrAXZWavZcozgqXNbhsoygkNXRThdjAO44doYJbr5mhncy4WeO0KLx2zF?=
 =?iso-8859-1?Q?VU5cISX4mTi4zGeuP2U56T9IPwsjvTivJ4HdUWVBgHy74YNnb5oDKD0DXZ?=
 =?iso-8859-1?Q?v35rhnPQx2eUrtmZ2LYOEfyf3CgVVV/DH9lc95lyVd/qECpPTMPCKdmJJk?=
 =?iso-8859-1?Q?tTUTZ6qHbqW0b0CNHGA8wccNyOTR/11Lyq92jAH41HLPdXooS5eRe2zQ5K?=
 =?iso-8859-1?Q?0nXcSS59cJThHwxa9jvI30kXxMbRSAQMiN9oOB5R+3zUbudM/xRXEiyUZ7?=
 =?iso-8859-1?Q?PY/KVyCOPbrEY3IrtGJ1msElw8zd50KPrh4a21sNisIN/+wNMv0Smy5tOu?=
 =?iso-8859-1?Q?nlAkTvlSndJJi+g1okuTmoC3Lz0T4gRaTQbAUFLAPeiWol/0VmDt3xzOtI?=
 =?iso-8859-1?Q?gPGt82QxEDjbasrDZHuzI1V8BMOIibdWwX2YBlWoZ7gFinsyW0JVYbw4Cs?=
 =?iso-8859-1?Q?QskcE3GItSxs/RCyvhEixjZTXQgmr+BmxMPzrd2zb1CkIU7qJfuvAYxUvD?=
 =?iso-8859-1?Q?e7+ESXzo0hYIK0wZOWiBJDBSpGdFXzLWL0HRFmAhA5yNlI+QEG3hh1VUXO?=
 =?iso-8859-1?Q?uuuJ9bB2hAsC/8BBsH1SYnXdeJmcjzQ7tXsi6Jo0K7Gu4BhQ7jfc4XpQAR?=
 =?iso-8859-1?Q?cCRH8rMuSuZZRSm8EBiaqndUvu+kNREFS3D4TZyvIzUCK29YJNEqxVDFY0?=
 =?iso-8859-1?Q?GaiJE0o+uyVmo5KIUYiDBY3opcoYynWQvzUMhkIlYmg1Xwu0wuXzXUZBE6?=
 =?iso-8859-1?Q?aQHdKfuPI+Q5mcZOq4RlA3RDU9KSPs05PHLTx38TnD1d+gjP9Q4uzeCp7I?=
 =?iso-8859-1?Q?M/PwT7OlsGO+dIRmkU7982Zf1aRNqJCFyiritFpCjET/9ybQjlunrmwuor?=
 =?iso-8859-1?Q?66Tmw9A24KYm5TsILvvpvZZhA7L4vTRhEzyTflSjpxdGKAhN2NOfX3U4pA?=
 =?iso-8859-1?Q?Qd4REsZ3GNqGNpxz3dx3lIV3rgczpZjVIPN5Dxmsu6l+/tst1gwUCHFHwt?=
 =?iso-8859-1?Q?mySIcBYDyCHJUPCJ0eC6T5VfGjBDKT0XMt+MGfbwEBsAiqCOC5+QC8ed1U?=
 =?iso-8859-1?Q?yiZBgDPQpLgf3eBCqHT02G9oHAPS68HI+uQtydzKsUgceOut+CkFG4Z17Q?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JN8SPctSm/iE28YCkql9SMS/bY0o3NXWWHSHSTAyTkBJhnrql0codG2daG?=
 =?iso-8859-1?Q?jUEpC73CwnppkZyyXARkA8SR9Drd3OoFZtJI0z7RKnehD5Y1KRLvOx2nVL?=
 =?iso-8859-1?Q?cw/RP0sM1Erk3b/trF7QIqB7FI34T2P+iGZCaRIdHj6tEcX7WGNDotcg2e?=
 =?iso-8859-1?Q?sJ6hZ4CVJHBGJZSf9KGZTf3BZQ5ZazkLoYJwET9Ctc1SViJUL81+c2upKK?=
 =?iso-8859-1?Q?wi3P7yULIi0syl70BUNJYtcZwHe4ptNgHWJbL2Rpyj8TqVnhcC5l72XBZH?=
 =?iso-8859-1?Q?z60xnUfJWZT1v1OCmxwzYXAl6LlYY1sg5aRh62VCHzTrS/jPhFM9IIfQvK?=
 =?iso-8859-1?Q?LCEea0uSMWhW2wc8jqnuEjfUx8uTWXExNYguD/BJHkvH+NAToeztdcmFlB?=
 =?iso-8859-1?Q?FzsmuNDEJ+/pJAEaw7jvGvwfDVY0UqeQxSYihk++Q7nartBZEXl7rbkrm1?=
 =?iso-8859-1?Q?AQXSCadIFiRT6DoUWfMDJB21cUI9IdLNtrypB/y9WHBVxlRQne364pgdZb?=
 =?iso-8859-1?Q?IeTOM/y2I+/YPNRJMRHrduxO2+R9of/Gxy7tVIbcDoO3zYW9ORPPW5G51g?=
 =?iso-8859-1?Q?e8ZNcrqfz9s3wa4VD2PoV8rwbxf2IKXK3iodmSf5o9ErBymR1gbpxdbu3Q?=
 =?iso-8859-1?Q?pccjjGpRsW3muFU7zTO9USgAvqoqmXcDynXjoQ5j/Eq0quIv3QY/TOMpaF?=
 =?iso-8859-1?Q?FQJpm+cftGI0BqaHRim24OUpZQTwlWwTo0Lj7WD5NFPMF69LxQv2ZPXFLL?=
 =?iso-8859-1?Q?HILzFVYKhasnV0+YNFdLnCvK8ahxz0BhzhrPfiAg4oxvSS5pj91WViEFDk?=
 =?iso-8859-1?Q?dGSmiiYK0X/VM9hm7da8IDORADMbmpuRj+jm7hKNw777OJUo9bmuZtwEkq?=
 =?iso-8859-1?Q?W4QXEt1dEXKXLUk4pgoMBXdRHDSHkbnhsJMNFDxaRDg669UwV/O5aNrIX8?=
 =?iso-8859-1?Q?prSwa2Fv6L89ZNhwL1MIY8t2RqbKECviM4jLe1+h7XISh6uiDjAvyLP1ln?=
 =?iso-8859-1?Q?t2GYU/0kllC2oYgdLUURihTILZf9GFhe0/87PjERmrP60WIDzm+JnRMiNo?=
 =?iso-8859-1?Q?geVBeI3ZgJmuksCbMGjxS4Fw2zeJ8JwbkGQ5zdrYz5a21kBLMBqJ2b8GgI?=
 =?iso-8859-1?Q?OQL9GDOU+WbxJ2Cebu8hRSIJiD0ZhdtWPaeJiVZsPhkoCWYBjqzUQ42QWU?=
 =?iso-8859-1?Q?HzDA8rsYIJrTgUSXLAsk6PBVXJ9X95M8CLdN7yyNsbZonjarxNrUGFop1f?=
 =?iso-8859-1?Q?T/M4n/e1W/O7JEJik9DUVXjMdH/zMQGu7udI+vRFB4epNK4KpRK+PaPApD?=
 =?iso-8859-1?Q?igxczNpn5Bx/fCmk5mcIMkQIpAsUsPPRqFM2lFGHhFcxZhK6Y6lxdwG9KY?=
 =?iso-8859-1?Q?VQblbFLKnnCS8DI6o/4bbD9vkvfZUaQlwCUVgpsJ7ozom08j+LULWMprZw?=
 =?iso-8859-1?Q?kkcQEhYKPPULRc5JiafiLJiFF1EWzXxrnCcME7DphaUpue4kx+PigqHXy3?=
 =?iso-8859-1?Q?mterH/VnbIhZy4DpOdkNJGoTwFDbO3PC+7itnaGSqR2EKco6f+4MNO2TxU?=
 =?iso-8859-1?Q?ge32UxoB5AIrCq/jbIaIoUEKo5tsWWtQE3OIOKGxJpFgpSzliOwMYH4dqe?=
 =?iso-8859-1?Q?WToRWHwIlcJleZ++hfu1FF4qdOVdvdC25b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3326fbfe-d448-464c-0410-08ddb44bc5f1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:52:49.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjkS/FV4tkG2x79OkhYhDvcYSkO+77nqTBvwR7DBC+Ssheq3mAv6V06ZU9Qd8kC8g7I95GgFLNJYbHbY11yEzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4708
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 10:48:00PM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-06-25 at 17:36 +0800, Yan Zhao wrote:
> > On Wed, Jun 25, 2025 at 05:28:22PM +0800, Yan Zhao wrote:
> > > Write down my understanding to check if it's correct:
> > > 
> > > - when a TD is NOT configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL, KVM
> > >    always maps at 4KB
> > > 
> > > - When a TD is configured to support KVM_LPAGE_GUEST_INHIBIT TDVMCALL,
> > Sorry, the two conditions are stale ones. No need any more.
> > So it's always
> >  
> >  (a)
> >  1. guest accepts at 4KB
> >  2. TDX sets KVM_LPAGE_GUEST_INHIBIT and try splitting.(with write mmu_lock)
> >  3. KVM maps at 4KB (with read mmu_lock)
> >  4. guest's 4KB accept succeeds.
> 
> Yea.
> 
> >  
> >  (b)
> >  1. guest accepts at 2MB.
> >  2. KVM maps at 4KB due to a certain reason.
> 
> I don't follow this part. You mean because it spans a memslot or other?
Sorry for bringing confusion. (b) is the same as the current bahavior.
I listed (b) just to contrast with (a)...

KVM may map at 4KB due to adjacent shared GFNs, spanning a memslot, or because
the TDX code doesn't support huge pages at all...

> Basically that KVM won't guarantee the page size at exactly the accept size? I
> think this is ok and good. The ABI can be that KVM will guarantee the S-EPT
> mapping size <= the accept size.
Right.

> >  3. guest's accept 2MB fails with TDACCEPT_SIZE_MISMATCH.
> >  4. guest accepts at 4KB
> >  5. guest's 4KB accept succeeds.
> >  
> In this option accept behavior doesn't need to change, but the
> TDACCEPT_SIZE_MISMATCH in step 3 still is a little weird. TDX module could
> accept at 4k mapping size. But this is an issue for the guest to deal with, not
> KVM.
With current TDX module, TDACCEPT_SIZE_MISMATCH is returned in step 3.


