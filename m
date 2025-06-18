Return-Path: <kvm+bounces-49782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B9CADE005
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 02:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1340F18885FA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FBA72606;
	Wed, 18 Jun 2025 00:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBWyivqX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1837DA932;
	Wed, 18 Jun 2025 00:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206863; cv=fail; b=dRe3giRWEKkX4Q4uRr2qAX92X0L/mLX5fDRFfj0yIcJyKk9eaGtoYvt80YkX+zALF+clOK7ycZMPiBhHOl1sWhaw4D42WWrG7XWPUwsuy2JCrb71hqsrI9V8oMXEr8VmXJi/t3SaS/k+po3jCy2f2qckyZTxeHgbt/JwH7+gsXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206863; c=relaxed/simple;
	bh=+bDQxKVkM4FFy4QaK1Nj7oPu5v62iKXftnM+WWJKdBA=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cHy0XxQi/ejqzlPxxemgbMAPI5l7jpI4QlqdulLet/gfwU4p94xONFV7xrfE0IOxRfhdNsGw/ZHJnHQZ3nW817WlyiQIlMzkhhTQzUwSVupdZ9unzncvFqn4yT6v0n92WnlaB+VmWFXXdpXjlvqVeQQmO8ASKVy+AKKkr5tJ9Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBWyivqX; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750206862; x=1781742862;
  h=date:from:to:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+bDQxKVkM4FFy4QaK1Nj7oPu5v62iKXftnM+WWJKdBA=;
  b=XBWyivqX225pZa8xC8nhVI6ifUtWxyfInaWlZmK4zBOGSIvgLz5FWxnC
   rimnxqWIlcR1gD8+Il1/aPMl2ZD9fgpap0buQx4c1Via0b6pckKLso6Xb
   GAFL4dXn9MfQIbHMpKP7WRUIL1vKUTpFt1324PEJM5jACRaE6BwquVJOm
   KQY7qaA2cPOv2cjdwsRGqEiASpBeS2/laepbZKfOwljNRWVLgHl6D9qTa
   OumqpCUuW8eGStv4mfre5FHIe7rJ34WU6eUAl7XYmcFH2K+s1z+mJn7u0
   9cxS3VyvdbJAxhPmOO5+dxvTx/DzLvx0rKw/aDNduOY5J/08wvpgE87iC
   g==;
X-CSE-ConnectionGUID: dm1EF0c/Qpm5TMsbIHh8Mw==
X-CSE-MsgGUID: XcpobGEqTceCEOfvTwQWYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52322265"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="52322265"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:34:16 -0700
X-CSE-ConnectionGUID: K4PmkHNSReWSv/YBq7ChOQ==
X-CSE-MsgGUID: gJHxAvIxRxO4EqDQ/Em/Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="154469468"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:34:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:34:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 17:34:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:34:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CzoFZRmpF2GqQXjvLJ3BeL+kfIqwlanJJOnE7EyPpmNkdaUF6kjYvxS34IImKJxvj3cXZRV/mY8Jq43JQxS9irzxlDzU1pXMGt2wN3CfyeKe06q56Drvhyv9BDbKgzPjPQt/cEujdnE54ZKXhshcz2dZ39fNfTNwIvGCYr6lLLAxuIK/SwDXhDQehgqD8CRKd0RPoeP9Nj/sNxnlf2v1dSzKXDZwVq8AoVd8oTZHX84npLPmz/mBBG59sN52EWVKtcMqm2Gw+n3a38sC9oXc+k2z71fzfTHyWPr603Z3sPD2awyqnB22oUd8s3bAStt4cWrnbWM82CPJYbmaM2+dgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9OBPTEPTvEWj7SRLvQwDQQFhljgxwB4pK1/5RA1bhw=;
 b=CCcsSNiV95vjziOEv/S6PAHJx3jWummObRlvigsruBPBOBYZSIcRr+6MLcm4DtbY7MjcZS/wikAPy5P7AIhhAciwC/o6V9Dyw0HqI2d0M7njMxCtFtvZ3/H/m4ujVIbku05LXOcLJzqf83oQhbiq+Oq69fCNFyCSwjlYZHfaiu5Gghzc93U+PnfByhLkP4vhu98NyqhCUU/XTGzflrdeyvxHOdUpZ9J5yqwErPwYwsm6cp+96HMS746Y3JJCMq0kOMdk7/WoWl+XALzcoarCQFzubKeC2qBdE9HVh+LBTxj9pMzaDfBaMgM51yn86Jc4Ch3hLhOE1Ma++6HYcPmlBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 00:33:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 00:33:12 +0000
Date: Wed, 18 Jun 2025 08:30:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
 <aEt0ZxzvXngfplmN@google.com>
 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: d29fe739-a43b-4f7f-80f2-08ddadffb518
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?FgDr527Pe2mQqX+2dnFOQD+zrFKNf36Ge7shsvmvvIHAIy325laQWaEn3s?=
 =?iso-8859-1?Q?J3cboNvcWdOSPDNBLefJPmChtcMSO4F6lGyNTIu33xD994c0EWkNhhTmYb?=
 =?iso-8859-1?Q?cfCgvNPTuy99rvJ4ExRJ5pzU/0ZELFf+gqc06tRzs3WrlKcuoSfnLJhDcx?=
 =?iso-8859-1?Q?IU7gznuCDnhilXRY1xq8CMpv7yQbip0W0VkKtqMJGRyWjYT2pzg7SklKYQ?=
 =?iso-8859-1?Q?csJ6dF4t7B5gEin6agZdXl+l/akqMSOXtLt9pCajl4qxgFi4BXGXPKnU9p?=
 =?iso-8859-1?Q?YdYTzH3jQaCiikBHNmu6TwbYmCgTihFxwjQbSVyOUUi3FOQ9LkJwnpyTAV?=
 =?iso-8859-1?Q?kltrtNyCcX+EdlGfcOc6HOKPzS2z7lGwipEGN4OuojUl02uZTqje6EUW8I?=
 =?iso-8859-1?Q?b6pFUUrrlT1nyUa3WzsU0029M97TtDZsgbHQodmYSl4evZygGOw3FwFV+M?=
 =?iso-8859-1?Q?GkCW3cL1wn0jEhP6xvqRZ9EYOrhK06TZNx+ydG2kcTCLROvO3nfqfWO0O2?=
 =?iso-8859-1?Q?+/jQqp4XFs2ezAOGxC+lWc40vdY4uQ5Ki4JCN92pm8teQp7yYUMkA7b6Bk?=
 =?iso-8859-1?Q?k1OtMpwKiiHO2Qck1hSdg/xZE0lt1wdzcDuigpaKCiSHjC+1G6sMg491Nv?=
 =?iso-8859-1?Q?UWdoIRMyECQILA5cPZCaPn7ES65p6bS4zvq7ylIvOE5vqIjbE/jZJJukI7?=
 =?iso-8859-1?Q?kq552GHwkwYIgJ/zg6S+yz0JV4ysxwR/EWeHwzBQ77e+EKsP7zjJh0WXmb?=
 =?iso-8859-1?Q?QdU6at4PT25Onz8HOBvPBfDtiPBUmLACe2GhBGtQNY1AyFo6O/ENtkY/1R?=
 =?iso-8859-1?Q?HZAlM4mNT/t5jj67Vh3FN0iOUUCgPu7E3rnXTl2GrBy+3P7+s4v3NmCYS6?=
 =?iso-8859-1?Q?e/zovSSLgBWzNzMgcdRon/xjoOaaonksOf+7dYErVY8eVqZ9o5s8bQbsW4?=
 =?iso-8859-1?Q?lpzKB9wY9+FEet1wPOFGFrreTel1Eexb3WdRvRZUOQuuZYshbQSg5UJ2ch?=
 =?iso-8859-1?Q?BS2xHc6xvmvht4oov4OALsFDKcASy06n4rXNut8+1IHQK3076oAxcEg/Vq?=
 =?iso-8859-1?Q?dtCg2Zl0t/8yiLv0eHO1YZSJcwDYt8TAJ+hKsXzC155M5BwKRxMKT3RQ5+?=
 =?iso-8859-1?Q?5+pEfpPu1blEU2EAN+jNKQAAtP/v7Roz7cqJUlkNlDTZFO/4W+w33UZKq0?=
 =?iso-8859-1?Q?frjDMpjsOosNkveYn+9NQWAoJ9gBYHCjekojYpPDfJenJ8pWO5NAbyOCE3?=
 =?iso-8859-1?Q?WIelsnn9JVqWgdsyCl6bjtaRD5hekEYUiwH1gwuieCHzb9NYNK7Pv+jEbS?=
 =?iso-8859-1?Q?1X8DmV6dbFcaA3moCGUUR6ekfzAesKWRamqhHFJBaM567TSVr9hytstzV/?=
 =?iso-8859-1?Q?Zh8/E6FyrWNyvQduVYJ+IONnodkDKaOePENsah5lG0RTdhFOMKAuYi2fj3?=
 =?iso-8859-1?Q?dPsF9boaWB1tZSpx5rqQ2ksBgpcc0eunkv/6GaC/5l8pVH/U5C44eheNMP?=
 =?iso-8859-1?Q?8CF88xnl9jM9aRzBgX566ij6BPSs6K2uFbj+Czh+HF3Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?WYRCqnMCiU0lrJM63oicqaj3s4h5T5ZeGeAGSqcqeQNtmsQmTlTcO7oTJB?=
 =?iso-8859-1?Q?et3r4BU3pg/vk4diEOAEdvmWYIwlIZb1wEgOk8chS++UhcemUwY6K2KB9/?=
 =?iso-8859-1?Q?W6ErP1sJj4nfrz6omDj0vOmjVcSlAf0EEku3QjDpwezki0mcQqBRK7xYQN?=
 =?iso-8859-1?Q?HFcup3KBkPfvqKsEJ9nk54Pndf/BxuVGatj4oip8EOY0Uf1ZIslRvuEUvR?=
 =?iso-8859-1?Q?7ad5OCpM5RvuFL1qEu4rbImdvN2eT1IW1Y6TKW7CmvuOPpbFKu6Z9MwwGY?=
 =?iso-8859-1?Q?6NlgyaXQTo7I7I58ftSZ2IjoguZaW4Ovrx5gvJkOrz8PXp2H0l09ouQlIZ?=
 =?iso-8859-1?Q?k0+35Gn1xmxJVX0aEyJqVEmctKGt6bI6aWqOoAIa2RZ8zd8SrZ7TZYiLtU?=
 =?iso-8859-1?Q?Z1Aw5s4Mqm3WjhmxpaJzP/MBThCk8177Ud/PgclQZCMGM5BuS4a5p2rDLO?=
 =?iso-8859-1?Q?75JbNe7ZOz0CgW3ARgyCVoyKmenYg2vSED8r3KX0FflZ1e8cUPZBMyW8Te?=
 =?iso-8859-1?Q?8l0rvYFP1WTkuUCwEPU42p/kJMcDtUSm2RPhRlJELqm9usjmL4c9rvw3Cc?=
 =?iso-8859-1?Q?7OlufVK40HKCJ0RqCsghUTv/jsG9s278Np4pHnjH5teK2WGkX48kIJGowd?=
 =?iso-8859-1?Q?JZUafZ1Ueq8agbN94slo+tjpINqhT42iVf/6G+2TtQgsoNvOTYAV6tdAs3?=
 =?iso-8859-1?Q?sreilP0p/liw2RTVZQa9TX7zqLeuZYQEuds3gqd3y2IjLeFmQddmOU7hOX?=
 =?iso-8859-1?Q?WNbwbEdVTSdGlfolNX7iBQoIHK/WC08lagb5EVmoFbDP9IIJjJOZ8nRFQu?=
 =?iso-8859-1?Q?RX+2Bz4r/gTBEXnSppCCvYk0Ic9tVu/lAgCQXV1eYYLmN/mBJmWpuAvOB+?=
 =?iso-8859-1?Q?gLOPPFRcuNvD82MBM6Ly9PIoJdne40tK/HdxBPRX3NJ1O1L8BXJXWliJ65?=
 =?iso-8859-1?Q?NMCMlsbagL4QXUGtS1Lg1nOUywytgD8pYL2XUhkAlSXSitX9FEcVfwLKGQ?=
 =?iso-8859-1?Q?sS9aR4vOPlDC/njTg42jrfuYk+ZyZ8QjUoUC71ZI270QNm1IKnrFIzMZHP?=
 =?iso-8859-1?Q?cVy6+GUoD7RAyJSLvZY3GoAu1DSm+q2Ys1iLKLSYdcBhbJX6KAWIVBqATC?=
 =?iso-8859-1?Q?RPrwQfU9NTPdqabwchSEa7XoZeqYsNFJwYlML/QqNcC3yZkZsVegOIZe77?=
 =?iso-8859-1?Q?DH2kBrJlUQhHaYX/QglrZ4M04XqNlRd2CJagXhbMU2vejYJaQvReB2D3cr?=
 =?iso-8859-1?Q?pdxyC5rI9McaFsvj/E0+LwemJZwC6GiV7tPjJ9TkfyzalTq4+6RjVR++q/?=
 =?iso-8859-1?Q?cQlkJ35LKxowhpzDZKPJN0EoTqylEt4QN8DiVAdzUiwgpzXO4ADM2sbUf9?=
 =?iso-8859-1?Q?BcyVcVrY/ADC4VFy1AFjh7BKWsYlk9aqhyPPZuIDjPSC1/ZY0IHM8McjUl?=
 =?iso-8859-1?Q?9tI7jEaqkRIGImmvUwgMGK19ZoBDuCi+lPp79I/JjakCcA/E2fohbt0dOt?=
 =?iso-8859-1?Q?Vu+cIywIeblPEaIJdzz51TMKdynzLSX581FeirUSnyXzk+txlyRtKlv0jJ?=
 =?iso-8859-1?Q?0+vvPyVlyfwsAu3Rs6Zeku3YhUl9v59FyKIRB+rYyUa/uOxgTiktNNf5Yx?=
 =?iso-8859-1?Q?z0cNUOf67TimnVJj5/xoiCg1nMGpGGIZtB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d29fe739-a43b-4f7f-80f2-08ddadffb518
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 00:33:12.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGjE0ii0bH8rZCqmgrI3Rurxx7D+e1ZCFRefbJ71lDD2bqqm8OgVo2b9IaB5+cqi+Qfnu4/E6xmhY43u6rLTmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6744
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 08:52:49AM +0800, Yan Zhao wrote:
> On Tue, Jun 17, 2025 at 06:49:00AM +0800, Edgecombe, Rick P wrote:
> > On Mon, 2025-06-16 at 11:14 +0800, Yan Zhao wrote:
> > > > Oh, nice. I hadn't seen this. Agree that a comprehensive guest setup is
> > > > quite
> > > > manual. But here we are playing with guest ABI. In practice, yes it's
> > > > similar to
> > > > passing yet another arg to get a good TD.
> > > Could we introduce a TD attr TDX_ATTR_SEPT_EXPLICIT_DEMOTION?
> > > 
> > > It can be something similar to TDX_ATTR_SEPT_VE_DISABLE except that we don't
> > > provide a dynamical way as the TDCS_CONFIG_FLEXIBLE_PENDING_VE to allow guest
> > > to
> > > turn on/off SEPT_VE_DISABLE.
> > > (See the disable_sept_ve() in ./arch/x86/coco/tdx/tdx.c).
> > > 
> > > So, if userspace configures a TD with TDX_ATTR_SEPT_EXPLICIT_DEMOTION, KVM
> > > first
> > > checks if SEPT_EXPLICIT_DEMOTION is supported.
> > > The guest can also check if it would like to support SEPT_EXPLICIT_DEMOTION to
> > > determine to continue or shut down. (If it does not check
> > > SEPT_EXPLICIT_DEMOTION,
> > > e.g., if we don't want to update EDK2, the guest must accept memory before
> > > memory accessing).
> > > 
> > > - if TD is configured with SEPT_EXPLICIT_DEMOTION, KVM allows to map at 2MB
> > > when
> > >   there's no level info in an EPT violation. The guest must accept memory
> > > before
> > >   accessing memory or if it wants to accept only a partial of host's mapping,
> > > it
> > >   needs to explicitly invoke a TDVMCALL to request KVM to perform page
> > > demotion.
> > > 
> > > - if TD is configured without SEPT_EXPLICIT_DEMOTION, KVM always maps at 4KB
> > >   when there's no level info in an EPT violation.
> > > 
> > > - No matter SEPT_EXPLICIT_DEMOTION is configured or not, if there's a level
> > > info
> > >   in an EPT violation, while KVM honors the level info as the max_level info,
> > >   KVM ignores the demotion request in the fault path.
Hi Sean,
Could you please confirm if this matches what you think?
i.e.,

  when an EPT violation carries an ACCEPT level info
  KVM maps the page at map level <= the specified level.
  (If KVM finds a shadow-present lead SPTE, it will not try to merge/split it.)
  Guest's ACCEPT will succeed or return PAGE_SIZE_MATCH if map level < the
  specified level.

This can keep linux guests (with SEPT_VE_DISABLE being true) more efficient.
So, for linux guests, if it only wants to accept at 4KB, the flow is
1. guest ACCEPT 4KB
2. KVM maps it at 4KB
3. ACCEPT 4KB returns success

As the ACCEPT comes before KVM actually maps anything, we can avoid the complex
flow:
1. guest ACCEPT 4KB
2. KVM maps it at 2MB
3. ACCEPT 4KB returns PAGE_SIZE_MATCH.
4.(a) guest ACCEPT 2MB or
4.(b) guest triggers TDVMCALL to demote
5. KVM demotes the 2MB mapping
6. guest ACCEPT at 4KB
7. ACCEPT 4KB returns success 

For non-linux guests (with SEPT_VE_DISABLE being false), I totally agree with
your suggestions!

Thanks
Yan

> > I think this is what Sean was suggesting. We are going to need a qemu command
> > line opt-in too.
> > 
> > > 
> > > > We can start with a prototype the host side arg and see how it turns out. I
> > > > realized we need to verify edk2 as well.
> > > Current EDK2 should always accept pages before actual memory access.
> > > So, I think it should be fine.
> > 
> > It's not just that, it needs to handle the the accept page size being lower than
> > the mapping size. I went and looked and it is accepting at 4k size in places. It
> As it accepts pages before memory access, the "accept page size being lower than
> the the mapping size" can't happen. 
> 
> > hopefully is just handling accepting a whole range that is not 2MB aligned. But
> > I think we need to verify this more.
> Ok.

