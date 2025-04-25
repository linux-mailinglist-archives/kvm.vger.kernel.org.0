Return-Path: <kvm+bounces-44243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6985EA9BC90
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 03:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DB6C3B62FE
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9917F149C7B;
	Fri, 25 Apr 2025 01:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qb9Xtt0f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A2D49620;
	Fri, 25 Apr 2025 01:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745546284; cv=fail; b=mFLX1UunlDd+AGkTvaOSgGjSDib/skvLOqFBLkmUhP24tay0a89feVQRwJMOqewr861czdHCcydA5cQowfw9v4RIMFKVMcFCUIP3E2HnZqdI2LeiLgnpXFJ1GRVPbujgv3cWM7RSLY/x+ELvzFSqziKHBfqL5uuA/nSAfGVlcDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745546284; c=relaxed/simple;
	bh=6fIngvrfWH40VKjzVPKWx6ywXuAi4j1vVOYXOZrzvbA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=imImWy5R47SsY4YWmmXJVl40rVLx429HJDspk6zc85ieNcLUEOwsXRXyBefQhFzyeOsx3mT5WjeP1VbuMkQ355tHyo/MgBGK42T/CMhcJafdF7L/uTEChAG5ru1G6cY8DGNtbfRSmi3tDIcdy5OEQczM6i4VWbReuJxULM2DWJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qb9Xtt0f; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745546283; x=1777082283;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6fIngvrfWH40VKjzVPKWx6ywXuAi4j1vVOYXOZrzvbA=;
  b=Qb9Xtt0f3J5BLgFBr6RHXCeYKVtv7NTl3RABK9U5BYRt+z/qLTG0KAUU
   GCaMxWlNQoXuzGKXSr2u/lw4E32/1P8/fNc4fuUsj/6eUqLQYRFGaGS41
   NFfRtbbf7hjpRehz+oVOMyv81h1jVZQPZC9+EutcspLeC0j4TbXxiTL4p
   MwYun5dgyituqR1A/WyfH4AiFisxDd40EeYucBI+2j2xSlUBubyhtA7fG
   StnS1RPANAAEJiKwAcwCECkFQMuWUW/BvSHGzETlYHBAFpfPg9BxkXfNo
   7YgOlEx7Y3PpomWSM4Dh1VF9fdT4vLGlw7S7kfuJxgrYFAbfGWKd6BjM4
   g==;
X-CSE-ConnectionGUID: qOBSzKb2TG6rpq/5xfWb2w==
X-CSE-MsgGUID: v9K5FOI/SMegWIQ492b2ZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="49859154"
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="49859154"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 18:57:58 -0700
X-CSE-ConnectionGUID: pQZo3hL4SAOpNba8mBheZQ==
X-CSE-MsgGUID: H+K4TGpZR5iuN42GY0mQvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="132665187"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 18:57:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 18:57:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 18:57:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 18:57:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VX26wuyy0Mtufqnc2IvJmveFb5s2j1XFM/mSc0Sqybjj8YKy2OBUtn21/AfaXE8RFsR7M+b1ryzHBok0rlIap7D4m0K+9lCx4SG+9d5nMru0CAQwkMjcs0k9wgUQP2+p93l0QeM1sSKWcjBbNAUNh6+fnHdIo6pHYrs14yfGZ5c05hWGD7UPsfnFAMDJa6zNl5QqTQiO0hpvYItiOsmG/q92zEoUrrdBl+Lck0+93lJ2y/DNqMp1g/VHbQQindG0l7ZZuecb2SC+1F2z5Jy21pKsjAt4i4sGVALRvE/FkCQiqhyjHg5vgDhBrbnCBode94tdh8KLvRToE08Swi9lrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rpw0L13KRCC1+DUo3/cvp57fHKny8pw8sS8TyUIIpWQ=;
 b=CWy1AGQgmLiLrwsze2cAIRhOJMCzNcA9rAxymn4CcQtuBJ77+PWj0C2HAl6Tc81U1kKnUshxpVYD3EhYd+RYpf7o2SVtiLqLtGb/cSJGhj139mJjZiVz27fzgSoks2Sl/SRg2APmVpRpcCS4ACIBCn008d2YvTlRUI/ZqabapWNCRs0zoQyQI8rbldZcpLJyf871qCDaNBWB5T4/1xkpzthrRXfDCedrSNit2KvVNxHrjHFUkutZE5GVG0fQNaHMg3ZVNjBNGliOfAkYflk0a5Q1Yb2EFHrY6hArMEdfB7BKky4loCrp7Fan/C7RU1CIX8mat4JMXYR1xGycLcEXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFD6B8A798D.namprd11.prod.outlook.com (2603:10b6:518:1::d51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 01:57:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 01:57:16 +0000
Date: Fri, 25 Apr 2025 09:55:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
CC: <ackerleytng@google.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <dave.hansen@intel.com>, <david@redhat.com>,
	<fan.du@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<jroedel@suse.de>, <jun.miao@intel.com>, <kirill.shutemov@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <pbonzini@redhat.com>, <pgonda@google.com>,
	<quic_eberman@quicinc.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <tabba@google.com>, <thomas.lendacky@amd.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <x86@kernel.org>,
	<xiaoyao.li@intel.com>, <zhiquan1.li@intel.com>
Subject: Re: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for punch
 hole of private memory
Message-ID: <aArrh5o/WCSIZeSQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030858.519-1-yan.y.zhao@intel.com>
 <a850503bc9bd789d2531fa64c5321d2d9cce5725.camel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a850503bc9bd789d2531fa64c5321d2d9cce5725.camel@gmail.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFD6B8A798D:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c888cec-32ec-4ec2-8ba5-08dd839c8117
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nKYReSKfQRttucfpCea8/f+5vwkkVWiKvCDAhSpO1ivdkyDz5JafLQUYOhLy?=
 =?us-ascii?Q?ZuLtdv1x8EHAhc76ZFc4HNZgtE0ztvgsj2jEsTZ8slCBE1ExeXPnCiM5ujmp?=
 =?us-ascii?Q?5cYFC8Qhoaw+9eF128lRuyHbuJInVdeLBw7rtjcUpzzWIThMDOiZWkKVVicW?=
 =?us-ascii?Q?bbvmE2kwYPfVev5xP3XQ6+PFPYLG5nXeUqcfLPCdXshsXe5BjNqMVtVtELaz?=
 =?us-ascii?Q?VyeI1lxrmOdANvJIeHCzkK/6b7FRIHbkLgtUjzFOnN3pz+A3bwPa8cz0YHY6?=
 =?us-ascii?Q?Tw7/r+6gI3jdeRR2xT7mIkFxlpgITyqiQgVBY/+xVicTYxTVtFqu/saAqJ7M?=
 =?us-ascii?Q?GJLS350gamcVpPKKRDsUxWru9fFg2tQBgovFVUawuuVIcGAx05uZTfef3yB/?=
 =?us-ascii?Q?tJS3ZSEW+cOnVbVhlnpkH+bTUiqwLQ+HDO4nP3pCWzz5RKxams2xeTHQHxOf?=
 =?us-ascii?Q?3tIWjbPiTlyTeTgjNi9OsOuV0SngnB/7eLA9N5t9HsEF5lsHQheYtfoTESP+?=
 =?us-ascii?Q?sdswu088sV6UeUO0TdsDzvMd2IpTHI3NooQYdJY4xA/Anhnbp4PyN3XjN4NQ?=
 =?us-ascii?Q?mYdBffoXU9X/BMcJYO3jnDL4MxdgmUTUP+988rqilUH9OtIAlAm9zap9JICJ?=
 =?us-ascii?Q?bAn2H1JnYfPJxDHWSo+Lyp7r22Q7JLQ1Cu7G/nc3DUJA5sHWZ/3cC56UXfyg?=
 =?us-ascii?Q?Es53b/KtC55PWEM8vjm+YGzKBTYcDi1GfC3rdCZ59kBJdSyntqzo9XFHnRsv?=
 =?us-ascii?Q?0fk2av2lAVTeS92lEqobOKFDncJ/9UAjgTLhYnA/udr9npvjeCtcR3ztYTrd?=
 =?us-ascii?Q?r1oYGMWwpE4pMi+O9PLuwwPcCIxyZRxYL3A1KvmWJ1wkTh8eAaNyELwwIEv8?=
 =?us-ascii?Q?nOb5GsLrPNMrngP1anPuZQbnCvJvscq6iV9t002Q0lusEdDaHP/qlhbs8r1t?=
 =?us-ascii?Q?AN3XLz0U1GdRBS/Z7WdPIIodUt+9ygllsaXC+SGho0wgWLZgq2a7Le7cHxix?=
 =?us-ascii?Q?NjIL4GVwFtA868yuqgJdviu2SPuux/7cTg5UsbsqBA4cNvSZiccNJWyufJYr?=
 =?us-ascii?Q?YFw4nSj8xUKYdyIbzLO1pl4FnkV0/LzZfQKd1E3yTmThkgNq1NKFkFTVbi3K?=
 =?us-ascii?Q?ZMKkaxGI+YwXVs1F+0WaE/hKtfVMwJsOoAAx6oLjl7g6tDFjZXhNwRqme+9q?=
 =?us-ascii?Q?4gkO3a4gG6SBo8DdlGTV2VtiA2yTklhLC9ZIfTMFg0tVVvgr53PAinvB8AbE?=
 =?us-ascii?Q?c+xPzeSKhAPFRMc1OZM+8UuInt8gAp4OqjdoS+uXBu7ar/EDfvJxBZHhqyCC?=
 =?us-ascii?Q?jj4pat27usKsS81CrWhAW8LARNs3EhQ/+zwhwtpm+FdyTHcr8i2dMdX3y2tD?=
 =?us-ascii?Q?sLCUar/anDJXMPmlnpOzCePAkMPj2OuWTDL3eOdw4+Dh2BxrRsDPVTT4dfk6?=
 =?us-ascii?Q?ov6gkwQTgnU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEK73Nj9vOVrH0kw3Xddq23cQzKO4GHL0uEIEkc60FpA3Fvp2c+xt9LP3TA4?=
 =?us-ascii?Q?ga8Io/2QtGq8Ed1x/qCaYSbR77ElKDz0EhK/XzGGGYeg7Fvr3Wwqwo4iDspA?=
 =?us-ascii?Q?yS/ri0eIwbOhL2v2jDzzJjqMosmMqI3aznto5n3M0OJNYJxMxc9MsYm8CB4R?=
 =?us-ascii?Q?m96G1o1UVfCqoF/+MkKlBKUKe91TFw0zHF6tvMkqZBpM6zfk1wCHKBSpoDSM?=
 =?us-ascii?Q?w1Hui/B2VQ5jv/pA1Md+yaLFTFD4nwU/aRnyRC/1isR2pdy1VAP38eKgUorK?=
 =?us-ascii?Q?V4rjddRGjuUnr6XzPM9MZQKn64BxLzDA6UY5zgDmEKTVNL3sdjfpg05vCblU?=
 =?us-ascii?Q?kWetSYqKvNdTSi0wjacTd1Nlcd+bBDY2GsOsT/4QRmw6zT4Vnm69AqbMQLb0?=
 =?us-ascii?Q?N3KdofC1TZ8RTFHWKe6F/gr9LQlV4j8EmH2v1PyTMc3O1ZJJh1MYKqlUZO3X?=
 =?us-ascii?Q?v4oaaQMKSDkiJpdgxgGkvQ6Uf92mjm3Z5/FfHCE0/QbaQgUBfdOVOYnhXPm5?=
 =?us-ascii?Q?YlcPwvIgcNSkVmf8efrTq7h5c/gYwmXZDZu2Za54UGun/mlSz1MHGVRUA0Jg?=
 =?us-ascii?Q?9x0DIWIAAkcbIDw8U7gyXZuuXb+sZipxv000xu9adq6biX7nmxzM5PinE7Cq?=
 =?us-ascii?Q?1lsdD4+m0dhBnMsdRy/yrTrCbpJCYHchUqtvJ/wte255U9SIR05eer9c1Wl2?=
 =?us-ascii?Q?+EQGIyb6ss4MWbJOV9XtsosuK8pZ+mTpceqH6x9btRPPytqq1GqZUMIfPFh/?=
 =?us-ascii?Q?U4qqxMrvSabIZ9sReR05LRuCLM5lTZwvL/v0hcYG3ebNm7DqiySA6THNN4cs?=
 =?us-ascii?Q?mktJuehxkuzDeICWArZ2CSJWw0bEeKrxhOBqumFv7HAZrNK7SQXUwfEw7eFY?=
 =?us-ascii?Q?X3saxtAxQul3z9HBjOkD2sRfOA+74HCV6VTbSpg7+7PSwrlJaFqd/4w13KKk?=
 =?us-ascii?Q?zqFawsjkvztt15aOb/7pHn87LURL5pbSs12m3YY5XCtuAzfTGN0wqY4ekpMj?=
 =?us-ascii?Q?yaNc6qd/AeLf823Alk05SCOsR5tCjry/7T4dVXqiLJzzrrVmRx9np/bqKX89?=
 =?us-ascii?Q?gePD2GfZxs0TkQLHNSFk0wYLnuFBcTj1JJfKn8HokWsQdqwrWFWBDpVZ6vKd?=
 =?us-ascii?Q?gcug+xsuuwX3Cf929yRJEVuSzjzcL79X8t02vkVEHTZJo5XA6X0Vi3d57W9R?=
 =?us-ascii?Q?+e+WkWtYFn/go8DKYq3n/zjiB4pp6to1yyRL56A7UZbJm+IIBaHqlSTdwb6K?=
 =?us-ascii?Q?1tgXe9Pg6mUydLVXjK7/euXfrI4T2sdrcTf2Wn+Br4808ftlCC8A8fO9qezy?=
 =?us-ascii?Q?KCTJjiIjQiHbk5eXBZLBjrbl4hVCN3Q0SwL2amqE13T75s/odJDS3pNosz+D?=
 =?us-ascii?Q?tNMNKfsLUXR7aGbcmg2VekLMA9f7cuqoM3X1E6YMgUfXU8Rqc3UzpoSzJKXI?=
 =?us-ascii?Q?L5RYKZkEL2wkWiyto1Uj3mvPYLvCjPodmF+0F7hjgrATF6s0cwhc0YjfrV7r?=
 =?us-ascii?Q?KLBLJFimweByvp4r2WEbOiOxfPJmvllcQ74eeEDB3DZcHAuK3SkOTIxHYeIM?=
 =?us-ascii?Q?h5ULTupUXj7RfqVS57VJkZc7wD9KfeeZOdUhf4JQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c888cec-32ec-4ec2-8ba5-08dd839c8117
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 01:57:16.2532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eDEQPkrNfTK7nNIXSicbuO49PimplUhOY5ZTLUiZd2IUgLHUQGnLL6uwcPd1k1AbmJIr3NQFYYX/CZIgjrbRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD6B8A798D
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 12:19:32PM +0200, Francesco Lavra wrote:
> On 2025-04-24 at 3:08, Yan Zhao wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 4bb140e7f30d..008061734ac5 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -292,13 +292,14 @@ static struct folio *kvm_gmem_get_folio(struct
> > inode *inode, pgoff_t index, int
> >  	return folio;
> >  }
> >  
> > -static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t
> > start,
> > -				      pgoff_t end)
> > +static int kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t
> > start,
> > +				     pgoff_t end, bool need_split)
> >  {
> >  	bool flush = false, found_memslot = false;
> >  	struct kvm_memory_slot *slot;
> >  	struct kvm *kvm = gmem->kvm;
> >  	unsigned long index;
> > +	int ret = 0;
> >  
> >  	xa_for_each_range(&gmem->bindings, index, slot, start, end -
> > 1) {
> >  		pgoff_t pgoff = slot->gmem.pgoff;
> > @@ -319,14 +320,23 @@ static void kvm_gmem_invalidate_begin(struct
> > kvm_gmem *gmem, pgoff_t start,
> >  			kvm_mmu_invalidate_begin(kvm);
> >  		}
> >  
> > +		if (need_split) {
> > +			ret = kvm_split_boundary_leafs(kvm,
> > &gfn_range);
> > +			if (ret < 0)
> > +				goto out;
> > +
> > +			flush |= ret;
> > +		}
> >  		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
> >  	}
> >  
> > +out:
> >  	if (flush)
> >  		kvm_flush_remote_tlbs(kvm);
> >  
> >  	if (found_memslot)
> >  		KVM_MMU_UNLOCK(kvm);
> > +	return 0;
> 
> Should return ret, not 0
Yes, thank you for the correction!

