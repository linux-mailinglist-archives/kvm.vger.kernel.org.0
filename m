Return-Path: <kvm+bounces-12489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B62A2886C95
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 14:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C96D1F22229
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 13:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FE74597C;
	Fri, 22 Mar 2024 13:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="krXXdFak"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6433B2AD;
	Fri, 22 Mar 2024 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711112913; cv=fail; b=BGkHTszR9jQA3L7rfku2gebmaRqJzA/ISbacV2t7qq2npaQ6cwQIliG8S5gD8b8GIjdqG+RWuVBtHaDCXevrXFhwRnnK4SDQ7Sfo2oDgQvf7f6FghtmlmfHKQxqq2imfxyrMR7k2UwBqycjJdgowjuRERjcDe+v7NjgLi8G/7LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711112913; c=relaxed/simple;
	bh=MGe5KhFYpWl5TaYBp8n/djAF5d3yYzWSfntGvxqNH60=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tVTLphJNeQ6u13ybNehYB3iLDcfIC6ZtjoqPJMHrnLNzO5bWKfsnj0k3h6HgE1Fycf4/EX83V34mTarYCkxm5X6Bbn8thigUl/ZiHTMePycla3QIIhDrcbQeBEWfOC/nEnS+jAYxVCfIsm5j1AlRsYQtr/2rQOAhl91yuhZG9Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=krXXdFak; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711112912; x=1742648912;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MGe5KhFYpWl5TaYBp8n/djAF5d3yYzWSfntGvxqNH60=;
  b=krXXdFakFA/16kCKTIpgRnjcmdvp4SHeFqAf2thWUujTx4YRLaG7i6Jj
   lh0BqtfLBcwHIVB+y6+R+rygv38RJInjFV7rZ0b6vY63ZWq8t2NTmEHiv
   8XhHVJU1DAIkuRM44z+WWgT2DJVmXYnzCb3oGxUf0AVgsUGu5SfB7ouPd
   pNBlFB13wP9EejNFk0NL38Ru9AXrdzI27IMKkf9qgQYscI5t8mrezjRGN
   xhDosDBHf2ydtMYt6DKWd8WeamguhUcCf6HYBPMJIotysPAaDEdrRUGE/
   5LTlRozmkNYDEDPiA02gOdlEvoS6YcDSpxQ9UpeNLgwUz0LAPfWSXs8zY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6365865"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="6365865"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 06:08:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="15000568"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 06:08:30 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 06:08:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 06:08:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 06:08:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5NCc+b8pCA26GQa0EoNeCZTSYLBTD58EViBwNPvGGUecuhYyZxK20d92WEemWmvpBxKflAIqdlNoX3MLsmq614UgVoM8108S/PQ68p8rkeT54hcd/6cM9YbBZgB8+4jTuh5p+8DkV6QbYYNwpLO5CyLLGNGci3rN08lmTQrllnXQEK441WTiRsqvSQuKe4L0LpZvc+FTrsrciqksVJVxqlIY60GK8B20i4+QiLF+Y0NuN7akGlLU4l90GoveM/uAfQw0mZj/fUn8+rEI4Tu9PEqfdzfynhcIN5CK7E12cMwHmObkGcao3kF8tXNqtz8zwuvZ+3tm6cjldjJT+Uc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGe5KhFYpWl5TaYBp8n/djAF5d3yYzWSfntGvxqNH60=;
 b=Ijd/7y9ZVTAEso6o9e9y063Buw2FIZyYpL7cvjdVGI/Cvxu3cxeVQ8FKfYrqJjqK+lfRPcmZmhyoV6RtT+6QHpaju5cZYo8iJkUIclVvPfqesLNlBZRHICxAxCchckHha35c95dATirAjnFCybZCyszgBLjlYJOkW4y+NW24xw/o/Esw5TRkAqmwisj6EXUpF+pJIuYhD8g4BeKMbWgjBKg2pj+qbK07qO2PNymDL/TqaUOK5SM4Sd86JrZEQlPpbfgvb4qbGaZk9ZJQ54fXWlY06jWraJzpB8u00ktBX8qCflL+I4cmRHhW3qQPuozaGyLN2scWWuptTEuoFtiPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Fri, 22 Mar
 2024 13:08:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 13:08:27 +0000
Date: Fri, 22 Mar 2024 21:08:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, <xiangfeix.ma@intel.com>,
	<xudong.hao@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Message-ID: <Zf2CvBs7R3KN6rIl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: 007ffb06-c5e1-4774-e91c-08dc4a7129b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HI66i4wAuE3Fk9FBTcMbSiX5cWzJkBSCGNwnyhDZ3Gi3hlFtDG9PFhg0QccpCUmmzJXwJyV1xwW9dbyNcegBogmvC+pNb4ukHmWllr9os9+hlLMGQRDMz3j+vshcHbVWHEkyqdyyxgxmVnx9qcgQ2nNsX+vwfJQKkUXy+ZWw4l9I76FqfewSyGgcDqrHbJ7pPw7Aeoi1dpDioZHNzxGKF0PyDKK0sXzezRyfJE6UVJh0zcs3XVhbCS/G980/LLJI5aU7qSbi4T8FT+esppo4Yb/Y4mLrOdDVLZ8NrXqpkO2j4oYaDp1GHTk+XS0NTkwO3pE7YQprmF/YlwbBPzJaHJlSluu5Hq1zMbTVDhfVSJoudsI9ZElv7ejNOcheGZBeEY8zBi/AFwBn0RdIIaPJvgpBxNuPqoDbXTZ8JKQihn3ERTzVWWfoiqqndVSmWjdvfrLwXqV9fhQH6a3WMiY9+wsKhPQjAcTlW7ZApx5Be6FAwyDZU6A76tCNGjKAiGnbPg0R9Sbkx1zBYkLe+mVinjDGRB1PrDtC9AOBWYWS9E7Uv+OYtMTG7tR2eQAXTZRxmuhSKh4KavGLIEEWY4a7p8UYqggl43uL9aUR6JuIEEUUmemMIz0Pxp/5VtbCawjpm/utVtAGINWsnBZM+n4GZkY983lhx9YlKUZZQHmbVvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FEwHA+tbgp2BmQ8y6yJq8LjxNlElKcrTbGMCkOGZ6n3p8lx0j9PrsTRFXOhL?=
 =?us-ascii?Q?D/NzqPXbCynTKUgof3IKDnIOOQ5XBTSJNSw37Re/qNXCOX3L6uE2MH2opi8D?=
 =?us-ascii?Q?k/wPjVqCi0gK97bIDbojgTJdXLCGvQ+A3lR/U9zz3QaRYSOOx7L4Y2F8Rme5?=
 =?us-ascii?Q?fxmFuORGVhhjyi2+VgTZGtuFMYnU5XElR/z3PKnBTREMMcJp/kqshfhpbp0y?=
 =?us-ascii?Q?InVwY0Nyk/e7X44oaFpZbF80v/JOoGylvNiqK08WlaCVlzuje6hRgpEANQWU?=
 =?us-ascii?Q?ggMElDfI53s/2BBKPQ02cmYzKoDjjoPuqJN4U8kOUV2mi7EivgDQP7nzlZGr?=
 =?us-ascii?Q?KavHT2nurJm647YP4WqFZ/v6mmeFjea6bPDku9jyCKXh3y0NZOYvcU5NjnCy?=
 =?us-ascii?Q?UrAvOmsF1StmsEt+ZSkINoHwNk4rZcOA5NuQaCck15ReL+D1JE59H0cypqVl?=
 =?us-ascii?Q?sHh3eWwoAUfWzkIPc/aO6b+RGbgb5T3aafPuSPW4Ef686jJdgMu8KegMjYhH?=
 =?us-ascii?Q?VdWGkWOH4Fq62CgueAeLaGtnxb/ePjIZevflfUT2qWQdhd3isg+vqbADssCG?=
 =?us-ascii?Q?NEPrIpiz8oNxv7chORw9EZ3AezMh8+a/SCGPdgWvMWn0tLtyZPQy1Ao91egB?=
 =?us-ascii?Q?YxE8XGMwv2LO6wRjGBEEPdobpd0ymS4bfxCra3jTeDq1vdxJXWD5w2DepS6B?=
 =?us-ascii?Q?Txgk+mM9UxmoPLDuUgXvrKJNdXAB9ght8xkVKUnsjn7a5ZqmRK5nLNM1eB4P?=
 =?us-ascii?Q?68uDQjO6yeulcJ4iPFKFEKWJIVzj5Re0QzKUbpNHbr5EdPIImD5ACNLj9/1B?=
 =?us-ascii?Q?zJvdUEMVBNzLHkpU3+CDbbWXJoKvJxyrVf+tTjmMVi0TDrgeIvV9tkQXPNj9?=
 =?us-ascii?Q?QLhBykqbGRUJeFSqmdwFFlRHbJyu5xjg8W1VMZKCLpXeLa6i+YsDkHYl0bvY?=
 =?us-ascii?Q?48Ajf23u7xKsYaz/b0RuQBMpZWxoEZW6NVRo+56vYfs85m6qws1EiQJSE949?=
 =?us-ascii?Q?vka56prVv9aLqxJsyKsXOZQX+8vwMDcwoPIqIAqCexs/oeHN5af4+/16i9DE?=
 =?us-ascii?Q?coPPs4ZBWieSJ9m05f1GPkOSWHCTMa5Y38OpLN9xjV+Ulw9MiR2sEAosc/bi?=
 =?us-ascii?Q?xRQDaaW0ZCWh8LRHXycJoXQWBlKkZdqIHdh+9JdfccPpwtWWKWYsuqgQIRrz?=
 =?us-ascii?Q?HkTdKAjXx5bFCWi3L5gCcxpfD1s6hO/MU1VQI5OEw/AvWH9J4PcElWfNUSdy?=
 =?us-ascii?Q?Z2sqeIbSD59WqtiMv/lTW7+uuBjX+JFNIbC6KmSMe6hFUEgT9F9BFp25ycaK?=
 =?us-ascii?Q?T5crMyd4pLeXeA/SMUAJF6BWDohBeN3MRVS8LQnhlS9U6SRp+P2aRI6jaCIZ?=
 =?us-ascii?Q?EWUYQj/v8RIjgOlE5lyRPlQStmowvb4/P09DTchmdlPn1VafBuUJI1lXtILi?=
 =?us-ascii?Q?9zNoPtu/nsFN3tzsTnzTeReAeh9eOi2yRtfbPXMa6RdcVOhRe/MleCiw2tIp?=
 =?us-ascii?Q?xq5YTWlpBrknffkP3bkYXdql2T42U8xpnUzaj0JNsCKSo8UWyBvTWoyP8Tc+?=
 =?us-ascii?Q?2EOfLb7IXBDxHx8vqXihPd0s5f0ZHyC7SgGuR3gA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 007ffb06-c5e1-4774-e91c-08dc4a7129b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2024 13:08:27.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: motZVVQ5pKBjNR94vypcjGdnya3L8uKRPqCyNEOiprCFwQ1iuh0ZBsrgn7leOo1rpWFmJP3hUexlezRZgRd5oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-OriginatorOrg: intel.com

Xiangfei found out an failure in kvm unit test rdtsc_vmexit_diff_test
with below error log:
"FAIL: RDTSC to VM-exit delta too high in 100 of 100 iterations, last = 902
FAIL: Guest didn't run to completion."

Fixed it by adding below lines in the unit test rdtsc_vmexit_diff_test before
enter guest in my side.
vmcs_write(HOST_PAT, 0x6);
vmcs_clear_bits(EXI_CONTROLS, EXI_SAVE_PAT);
vmcs_set_bits(EXI_CONTROLS, EXI_LOAD_PAT);


