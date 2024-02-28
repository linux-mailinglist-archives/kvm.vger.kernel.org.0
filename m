Return-Path: <kvm+bounces-10283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2DB86B2F5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 042AF289624
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D884115B987;
	Wed, 28 Feb 2024 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMpDrlT9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75041C10
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709133667; cv=fail; b=tyfx3u4vym+dZuH2oT7ubZwewhTlXzhxC3TdkBI/R2+IM7vn/wE+NcQvpPcZj+mQliYjf/pD1xLk32y88/UAGqUK/pyT2M3L53cBqWz5f8nyHTy2m0Jr/9aLrtq97RuLG4CXz43z+Uc0N5KpCpOsVz3lvHk4v8xa/dlHs4dVyoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709133667; c=relaxed/simple;
	bh=oNfqbnufXO1oh7NgIdkPXT782vHh7gc43Mn+IwmnQ9M=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=r+voP4JXW5MVMgqz3/oKLLjunY4vPkjqoddNx2NgGJzX4qWqfxr8K6ISqj8I4ZOLFkHNAIU2pDaXMJFR4BUC+lCRqZEgS8D3nM1dMy9yQT7fIRp8gcT/Ls9XOY+Bx8+NE/KjUOY1+f/G/JjozkGVT6i6+WOesU71j846dA4JVCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMpDrlT9; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709133665; x=1740669665;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=oNfqbnufXO1oh7NgIdkPXT782vHh7gc43Mn+IwmnQ9M=;
  b=PMpDrlT9LtLU5Ek0q1GTf1lPsHZRNzB2vG10VCiPVWaj25FGoUa3awfe
   56w3grM9P/ihJniIuvUGTbMAOBXP5JkTwR9mku809lEcP7D3/86IQBcKN
   NQrwtrH3qvgryvZ+xENd6l83Wp3vdmAEGbkE1DrtMrE01R0xcLzdgcDRw
   vcIG3O4cKNvwUv7oQ6qXl5Atk63UZSLlGRcBnRl4fUrfFY5Qh6RHsobSX
   kbwmFOOeyZ7UPANfWA5F3HoC4AadHozY7XDV9WGFbksT5y6dY1HFAia2F
   nECneNicJQTDFp7dDMfKvdI9iy7z7gQzgYMaqXxIXMTldPWQwRyZM6+AP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14974684"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="14974684"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 07:21:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7396790"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2024 07:21:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 28 Feb 2024 07:21:03 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 28 Feb 2024 07:21:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 07:21:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4NCNh7wU5vIUNIalLkiqYZSbNeuDEG5rXfA3G6PVxn2ujDA9xsJHwDoKBZBJkL1dG6Mqw2Us6mJi+pZftvhdfrrXh1qIjE1SdDLxFV/Fwq0xSXiYCivvuj3X91g7gARDgbEuv7dvB259gghO6+y6MLl12As60UyqGo1+dXKzgrmLrQhCzvmRl2AltEpTOHssJ4QQaEQE6gNDWuzf+7cyfvyhUPoBe/b+Mq1p5Db69/5OG8EiVq+LMv7RAEyIbjkA+xsErJMaDwQGh1QhsVLspuMEE4M1n85q8sSjC6gd/KcZiN4+4AU4BklcsIoq220IYQHD2ziMGs1kWa63VtwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69L87F9orDV331pJdkPb3VeXv6x1eOhHcnAynx3XrLE=;
 b=JYBgzJZTpWesUVsTDiuQZWbGsdFrmja7HpGQY88SrOrOFmxW9N4PY7+rnn27Pc+gSxkvh2iL0N0mHWo4mErK8QnCbRBU7pB0x5QttWp7Yhu6of+wUqWfdTutfEU/tXvXdaEEcVafBcumIEe9rJmEzpfqUcDxG3D4fwBTs0I/I4ItKVPGoFJcSLWKKy/WVBRaRaC8ACAEC1RJyqUjbQCCxV+0ST5JQwf5v8obUxaftFxi/HSMLlnLtsh6GDNNNjPsjbWhrMedkAOA4WRfcHY0ZUsjUqR3+IrFoOMBg6CChMAfwkYKrAT9W1WOopNR+BgoLc5Z665cq/2KMSJBv3Engg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.12; Wed, 28 Feb
 2024 15:21:01 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e%3]) with mapi id 15.20.7339.024; Wed, 28 Feb 2024
 15:21:01 +0000
Date: Wed, 28 Feb 2024 23:20:53 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
	<xudong.hao@intel.com>, <oliver.sang@intel.com>
Subject: [sean-jc:x86/ro_memslot_snafu] [KVM]  666538d29b:
 kernel-selftests.kvm.make.fail
Message-ID: <202402282228.57c4f885-oliver.sang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN2PR11MB4664:EE_
X-MS-Office365-Filtering-Correlation-Id: 7323328e-0719-4a24-6838-08dc3870df38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qmjl0U4XFNjF6b2v+iPQMYGVz693YAHeAtsTrzGvMJ8ZnW3hsGKNASKSBGFHN3e6xrSsPAZMkBZOXHCMO8w7nYktGjPajvxzz2Z+jT5PjPeVsAUdy8iQCeQRU2gW4mSOkzzsr/QKvUao133SOVhSQqSv0IE3EFKHSlmZYwuHDE6XtqN4l7Nm3F17kHL5qeODRlHY5nVydpSOPAuUdShZZnBEqRMXM9JFZToPbO1ygu+yhUQD2oEGr1Fb2nnqIqpLjHOkuHahAErOIs8giA8iaD7H0Mb23iw39voP8wrWPj3tewt0UpbPS0x8qufYCRDH3vAC2cJMFXiaRad+MT+GJWK/eF/wt2uQJKPY2jkCx9/FugwpK0fhvNe8O7hJhLJIlzsQJ1Htcy4vyVQdtISzrD482ltMbN62DMRM6YQGZx001nzwhulj4wlIot9wEG+G+/bSXRRYOQWYJLwCxmILWt8z5/qtr7t5VYFKhV5pZdyUNN1mi4sqZvOVbmrOFmso8amvO1eSIPrlxtlgbOWKkaegG4ta4mGY0rLtIdDFJ0UCl+ElEGaCMGxBFqYxklQSFTYzZE4/FM+ziM4pOFu3E7jAzZsnFxT7f1HvrWOuxvAL1J88iTaK6lUV4fXM1PVyPQwD9kceGjtrcoyCoTE5UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUt0Qjg1YWFTL1JLazJURkVKWDBjYUIxSFNkemRLcmQ2V3Jva0U1dVhYZXJI?=
 =?utf-8?B?T0JDa244Rnh4WFpKemJuMmovaG5ZVjZvTExLc2NqekZ0TTJJNldjVk9qMExM?=
 =?utf-8?B?eVY0azNnbFpNZFZCK3RjWUpDemVXY0ZDZE00MTNDZURHTGs2amJjTEhpVklC?=
 =?utf-8?B?QVEzNUU1aFBnZENDTTdJOXRRN3psY1hyWFUwWVVibnh5U3E2REV3eHBSL0Uy?=
 =?utf-8?B?a2lRRmlRbFJua0dDZ3grOTR1TXJiaEZ4KzZ1alVSOUZ1b2hWZkhJbmtlbUk3?=
 =?utf-8?B?QmhQdWxrdEJOa1U4a29QRVpqWlF0VTFrSkpCbU41U1BZay82Y0ZGVUNWQkxP?=
 =?utf-8?B?WlNvdUFhTDdBcm1yQm1oMTdPUkJKUG1oOWNwdERQZjUxZTZFYytJUXI0d25z?=
 =?utf-8?B?aUE1dC9zV3JwbUREN2liZjBEbTI1bmZ4OWMreDVQYmRyaTRGM25ROU9tRnIy?=
 =?utf-8?B?WHVkRVFWbDErbGVMazNBekxJaXgwK2xNUWRDV29XbFEvSTRueE1IQnFCYVRK?=
 =?utf-8?B?bnMvMTRjZHYyVTMvNUdvVUg3c1dzMHBMS1JNdkJCYWlRdFJvZkZzb2QzWGk1?=
 =?utf-8?B?bmthTTVkeWlmVGFQbGhrUHp3UWFhVWMvT1Q4QmNpamFwWWc2M1BqOVNtb2RY?=
 =?utf-8?B?T1M3MUVKUkt5MTczQVRQdXlZU2JmT0NzTnlldXYvbTJyS1dmaC9yd1Zvdmtv?=
 =?utf-8?B?Y2c4S0RvSndyWVF2TXkrMEZhbVlNTDVFdFdNSmpqT2k1QWtOODFETEJaeSs5?=
 =?utf-8?B?WnMwak1NQ2NIejk5MGxJWGZ6Z2hENldjdWgxWWZCV1JoOXhyZDNOU0Y2ajZj?=
 =?utf-8?B?b21WNy9rSWpSOWlhU25EYVg4MEtZMy9ZVDk4NGZaNDVzb3pybFhrbXR5cXJj?=
 =?utf-8?B?a0QwQWlYOGZtZ0IycUsvZ09LaTY2NVJHRlU5amNkZE44bUNENnhlZzJqc3NS?=
 =?utf-8?B?UmhXdk55YzhYaDNob09HRHV4djRiUVg3SDdJdDJSdGk2eHJxQ3kyQm5vMDNK?=
 =?utf-8?B?d3Z6ZGpMTkh2UUlaOXYrQy9Ja0pDTTA5Q2w1Z0Y5bndGTG9OalpBanFPZVZR?=
 =?utf-8?B?ZzlwYUpnUGQvc2JIKzhlVUNUVGJaSmQxVGhXM0xLMHYrVkpSMTNpZExBZ3V1?=
 =?utf-8?B?MWVnMDhRaXR6UW9ZWFQwSWVjZzMvblAzYWI5OFdBM2JPZFVZcU14MFVJVFp3?=
 =?utf-8?B?VERQTWU4VmNTZlFZMG1WLzFraFJzWjRldGlhSEwzUUlRbVEyWi9McUcyTHF3?=
 =?utf-8?B?eGR3UmFmNzRvalAxRTFlQ3N0YjdKRlYxWUNTK3ZpQzREbTYyeDYxTXozYVBv?=
 =?utf-8?B?cFdHSWVXak41azhvOGZ5M2JpSlRWWGw5SHJCYTgzM1FFWlAxZFlGcGlmbVZ1?=
 =?utf-8?B?bzRpUHVyNys4am9VYXNSU29NemJXcy9ORW5jd0FJeFFjcGUvQnA1a2ZyUzMv?=
 =?utf-8?B?bTkzbzE4UUhtb2VBTnp3Q3dkUGk5Qnl6blVQVkFPYjAzNnlOZzRTKzgzYUdp?=
 =?utf-8?B?S1lvWGhCVEtUUlcvT2hScFR1cFY4LzBCMTR5b1lvRTgrWTRUb3V0U0FJZjQw?=
 =?utf-8?B?Q0hPU3FSSWJka2NvRlN5SVpETGVkY1pqM3pJemQ2alZ6Ung3UThxSWhzTktp?=
 =?utf-8?B?MURrV0xGcUxMUTBkcE1leVgzclJLQXhXeFduSk5kd1RtN0FGQ3R3T3AyV0NJ?=
 =?utf-8?B?SWc2dTYwRDZZQTUzd20xN0l1dDVaeEJleHhHY2VPNlJoZTF2YURXMTc5RUhP?=
 =?utf-8?B?a0lNTG9KdU5tWGFhNTNlMCsyV0dBTGNlRjhwSmYwMVNDdUpiZzVRc0dMcjFU?=
 =?utf-8?B?UVB6c2t4NUZLRU5iOUNkMmp6ZlRsZ3lWelI0S0swcWpJSnVUTG4vYTFGUC8w?=
 =?utf-8?B?ZjhRT0RxRTlJSHlKYzdES0hHWnBMaXJQU0JoT1BGVVNBS2JZSVkvOTVJejJO?=
 =?utf-8?B?Ky9vemVHRHo4Q3o0VUhQL3dYdTdtRHcwcjgzTVpQdzFmekJsVHJ4SXdpdVdI?=
 =?utf-8?B?MXZIYmQwVm1RTEZrZ0VIMFV4cHplZnFaWTNmZWJaa1hQd2FOeGY0UXNSL0NO?=
 =?utf-8?B?NFhKRS96RXgzZWo3SGFjYnorN2pPYThLSlV6Sk1DYk5kMi9YSGFkVWplRDVp?=
 =?utf-8?B?Z1NQeUdKR2tPWkhZaHZpOUNaeXdYL2JQOE42b3U2b3htbkN5em1GNG1jVk8z?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7323328e-0719-4a24-6838-08dc3870df38
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 15:21:01.5479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeR9i6y46lS/maXbM13qrx/nFCAprdp54kb0o7LR0SSiSRPHR2HMalNcuOwLf+jr+6rNRiMckUxWZJ4ds/WncQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kernel-selftests.kvm.make.fail" on:

commit: 666538d29b9c5394d2545cb4052fd3df79e618c8 ("KVM: selftests: Add test=
 for RO memslots")
https://github.com/sean-jc/linux x86/ro_memslot_snafu

in testcase: kernel-selftests
version: kernel-selftests-x86_64-d2f1c3c9-1_20240223
with following parameters:

	group: kvm



compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphi=
re Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202402282228.57c4f885-oliver.sang@=
intel.com



KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8=
.3-kselftests-666538d29b9c5394d2545cb4052fd3df79e618c8
2024-02-24 21:05:57 ln -sf /usr/sbin/iptables-nft /usr/bin/iptables
2024-02-24 21:05:57 ln -sf /usr/sbin/ip6tables-nft /usr/bin/ip6tables
2024-02-24 21:05:57 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2024-02-24 21:05:58 make -j224 -C kvm
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm'

...

ro_memslot_test.c: In function =E2=80=98guest_code=E2=80=99:
ro_memslot_test.c:6:24: warning: implicit declaration of function =E2=80=98=
READ_ONCE=E2=80=99 [-Wimplicit-function-declaration]
    6 |         uint64_t val =3D READ_ONCE(*mem);
      |                        ^~~~~~~~~
ro_memslot_test.c:8:9: warning: implicit declaration of function =E2=80=98G=
UEST_ASSERT=E2=80=99; did you mean =E2=80=98TEST_ASSERT=E2=80=99? [-Wimplic=
it-function-declaration]
    8 |         GUEST_ASSERT(val =3D=3D magic_val,
      |         ^~~~~~~~~~~~
      |         TEST_ASSERT
ro_memslot_test.c:11:9: warning: implicit declaration of function =E2=80=98=
WRITE_ONCE=E2=80=99 [-Wimplicit-function-declaration]
   11 |         WRITE_ONCE(*mem, ~magic_val);
      |         ^~~~~~~~~~
ro_memslot_test.c:12:9: warning: implicit declaration of function =E2=80=98=
GUEST_DONE=E2=80=99 [-Wimplicit-function-declaration]
   12 |         GUEST_DONE();
      |         ^~~~~~~~~~
ro_memslot_test.c: In function =E2=80=98main=E2=80=99:
ro_memslot_test.c:24:14: warning: implicit declaration of function =E2=80=
=98vm_create_with_one_vcpu=E2=80=99 [-Wimplicit-function-declaration]
   24 |         vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
      |              ^~~~~~~~~~~~~~~~~~~~~~~
ro_memslot_test.c:24:12: warning: assignment to =E2=80=98struct kvm_vm *=E2=
=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast=
 [-Wint-conversion]
   24 |         vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
      |            ^
ro_memslot_test.c:26:9: warning: implicit declaration of function =E2=80=98=
vm_userspace_mem_region_add=E2=80=99 [-Wimplicit-function-declaration]
   26 |         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, =
slot, 1,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
ro_memslot_test.c:27:37: error: =E2=80=98KVM_MEM_READONLY=E2=80=99 undeclar=
ed (first use in this function)
   27 |                                     KVM_MEM_READONLY);
      |                                     ^~~~~~~~~~~~~~~~
ro_memslot_test.c:27:37: note: each undeclared identifier is reported only =
once for each function it appears in
ro_memslot_test.c:29:9: warning: implicit declaration of function =E2=80=98=
virt_map=E2=80=99 [-Wimplicit-function-declaration]
   29 |         virt_map(vm, gpa, gpa, 1);
      |         ^~~~~~~~
ro_memslot_test.c:30:31: warning: implicit declaration of function =E2=80=
=98addr_gpa2hva=E2=80=99 [-Wimplicit-function-declaration]
   30 |         *(volatile uint64_t *)addr_gpa2hva(vm, gpa) =3D magic_val;
      |                               ^~~~~~~~~~~~
ro_memslot_test.c:30:10: warning: cast to pointer from integer of different=
 size [-Wint-to-pointer-cast]
   30 |         *(volatile uint64_t *)addr_gpa2hva(vm, gpa) =3D magic_val;
      |          ^
ro_memslot_test.c:32:9: warning: implicit declaration of function =E2=80=98=
vcpu_set_args=E2=80=99 [-Wimplicit-function-declaration]
   32 |         vcpu_set_args(vcpu, 2, gpa, magic_val);
      |         ^~~~~~~~~~~~~
ro_memslot_test.c:34:9: warning: implicit declaration of function =E2=80=98=
vcpu_run=E2=80=99 [-Wimplicit-function-declaration]
   34 |         vcpu_run(vcpu);
      |         ^~~~~~~~
In file included from ro_memslot_test.c:2:
ro_memslot_test.c:35:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:35:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:35:48: error: =E2=80=98KVM_EXIT_MMIO=E2=80=99 undeclared =
(first use in this function)
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                                                ^~~~~~~~~~~~~
include/test_util.h:59:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   59 |         typeof(b) __b =3D (b);                                     =
       \
      |                ^
ro_memslot_test.c:36:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   36 |         TEST_ASSERT_EQ(vcpu->run->mmio.is_write, true);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:36:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   36 |         TEST_ASSERT_EQ(vcpu->run->mmio.is_write, true);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:37:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   37 |         TEST_ASSERT_EQ(vcpu->run->mmio.len, 8);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:37:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   37 |         TEST_ASSERT_EQ(vcpu->run->mmio.len, 8);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:38:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   38 |         TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, gpa);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:38:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   38 |         TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, gpa);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:39:41: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   39 |         TEST_ASSERT_EQ(*(uint64_t *)vcpu->run->mmio.data, ~magic_va=
l);
      |                                         ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:39:41: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   39 |         TEST_ASSERT_EQ(*(uint64_t *)vcpu->run->mmio.data, ~magic_va=
l);
      |                                         ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:42:24: warning: implicit declaration of function =E2=80=
=98get_ucall=E2=80=99 [-Wimplicit-function-declaration]
   42 |         TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
      |                        ^~~~~~~~~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:42:47: error: =E2=80=98UCALL_DONE=E2=80=99 undeclared (fi=
rst use in this function)
   42 |         TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
      |                                               ^~~~~~~~~~
include/test_util.h:59:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   59 |         typeof(b) __b =3D (b);                                     =
       \
      |                ^
ro_memslot_test.c:44:9: warning: implicit declaration of function =E2=80=98=
kvm_vm_free=E2=80=99 [-Wimplicit-function-declaration]
   44 |         kvm_vm_free(vm);
      |         ^~~~~~~~~~~
At top level:
cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variable-size=
d-type-not-at-end=E2=80=99 may have been intended to silence earlier diagno=
stics
make: *** [Makefile:279: /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm/ro_me=
mslot_test.o] Error 1
make: *** Waiting for unfinished jobs....
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm'
2024-02-24 21:06:03 make quicktest=3D1 run_tests -C kvm
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm'

...

gcc  -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -Wno-gnu=
-variable-sized-type-not-at-end -MD -MP -fno-builtin-memcmp -fno-builtin-me=
mcpy -fno-builtin-memset -fno-builtin-strnlen -fno-stack-protector -fno-PIE=
 -I/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-666538d29b9c5394d2545=
cb4052fd3df79e618c8/tools/testing/selftests/../../../tools/include -I/usr/s=
rc/perf_selftests-x86_64-rhel-8.3-kselftests-666538d29b9c5394d2545cb4052fd3=
df79e618c8/tools/testing/selftests/../../../tools/arch/x86/include -I/usr/s=
rc/perf_selftests-x86_64-rhel-8.3-kselftests-666538d29b9c5394d2545cb4052fd3=
df79e618c8/tools/testing/selftests/../../../usr/include/ -Iinclude -I. -Iin=
clude/x86_64 -I ../rseq -I..  -isystem /usr/src/perf_selftests-x86_64-rhel-=
8.3-kselftests-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selft=
ests/../../../usr/include   -c ro_memslot_test.c -o /usr/src/perf_selftests=
-x86_64-rhel-8.3-kselftests-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/=
testing/selftests/kvm/ro_memslot_test.o
ro_memslot_test.c: In function =E2=80=98guest_code=E2=80=99:
ro_memslot_test.c:6:24: warning: implicit declaration of function =E2=80=98=
READ_ONCE=E2=80=99 [-Wimplicit-function-declaration]
    6 |         uint64_t val =3D READ_ONCE(*mem);
      |                        ^~~~~~~~~
ro_memslot_test.c:8:9: warning: implicit declaration of function =E2=80=98G=
UEST_ASSERT=E2=80=99; did you mean =E2=80=98TEST_ASSERT=E2=80=99? [-Wimplic=
it-function-declaration]
    8 |         GUEST_ASSERT(val =3D=3D magic_val,
      |         ^~~~~~~~~~~~
      |         TEST_ASSERT
ro_memslot_test.c:11:9: warning: implicit declaration of function =E2=80=98=
WRITE_ONCE=E2=80=99 [-Wimplicit-function-declaration]
   11 |         WRITE_ONCE(*mem, ~magic_val);
      |         ^~~~~~~~~~
ro_memslot_test.c:12:9: warning: implicit declaration of function =E2=80=98=
GUEST_DONE=E2=80=99 [-Wimplicit-function-declaration]
   12 |         GUEST_DONE();
      |         ^~~~~~~~~~
ro_memslot_test.c: In function =E2=80=98main=E2=80=99:
ro_memslot_test.c:24:14: warning: implicit declaration of function =E2=80=
=98vm_create_with_one_vcpu=E2=80=99 [-Wimplicit-function-declaration]
   24 |         vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
      |              ^~~~~~~~~~~~~~~~~~~~~~~
ro_memslot_test.c:24:12: warning: assignment to =E2=80=98struct kvm_vm *=E2=
=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast=
 [-Wint-conversion]
   24 |         vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
      |            ^
ro_memslot_test.c:26:9: warning: implicit declaration of function =E2=80=98=
vm_userspace_mem_region_add=E2=80=99 [-Wimplicit-function-declaration]
   26 |         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, =
slot, 1,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
ro_memslot_test.c:27:37: error: =E2=80=98KVM_MEM_READONLY=E2=80=99 undeclar=
ed (first use in this function)
   27 |                                     KVM_MEM_READONLY);
      |                                     ^~~~~~~~~~~~~~~~
ro_memslot_test.c:27:37: note: each undeclared identifier is reported only =
once for each function it appears in
ro_memslot_test.c:29:9: warning: implicit declaration of function =E2=80=98=
virt_map=E2=80=99 [-Wimplicit-function-declaration]
   29 |         virt_map(vm, gpa, gpa, 1);
      |         ^~~~~~~~
ro_memslot_test.c:30:31: warning: implicit declaration of function =E2=80=
=98addr_gpa2hva=E2=80=99 [-Wimplicit-function-declaration]
   30 |         *(volatile uint64_t *)addr_gpa2hva(vm, gpa) =3D magic_val;
      |                               ^~~~~~~~~~~~
ro_memslot_test.c:30:10: warning: cast to pointer from integer of different=
 size [-Wint-to-pointer-cast]
   30 |         *(volatile uint64_t *)addr_gpa2hva(vm, gpa) =3D magic_val;
      |          ^
ro_memslot_test.c:32:9: warning: implicit declaration of function =E2=80=98=
vcpu_set_args=E2=80=99 [-Wimplicit-function-declaration]
   32 |         vcpu_set_args(vcpu, 2, gpa, magic_val);
      |         ^~~~~~~~~~~~~
ro_memslot_test.c:34:9: warning: implicit declaration of function =E2=80=98=
vcpu_run=E2=80=99 [-Wimplicit-function-declaration]
   34 |         vcpu_run(vcpu);
      |         ^~~~~~~~
In file included from ro_memslot_test.c:2:
ro_memslot_test.c:35:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:35:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:35:48: error: =E2=80=98KVM_EXIT_MMIO=E2=80=99 undeclared =
(first use in this function)
   35 |         TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MMIO);
      |                                                ^~~~~~~~~~~~~
include/test_util.h:59:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   59 |         typeof(b) __b =3D (b);                                     =
       \
      |                ^
ro_memslot_test.c:36:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   36 |         TEST_ASSERT_EQ(vcpu->run->mmio.is_write, true);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:36:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   36 |         TEST_ASSERT_EQ(vcpu->run->mmio.is_write, true);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:37:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   37 |         TEST_ASSERT_EQ(vcpu->run->mmio.len, 8);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:37:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   37 |         TEST_ASSERT_EQ(vcpu->run->mmio.len, 8);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:38:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   38 |         TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, gpa);
      |                            ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:38:28: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   38 |         TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, gpa);
      |                            ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:39:41: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   39 |         TEST_ASSERT_EQ(*(uint64_t *)vcpu->run->mmio.data, ~magic_va=
l);
      |                                         ^~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:39:41: error: invalid use of undefined type =E2=80=98stru=
ct kvm_vcpu=E2=80=99
   39 |         TEST_ASSERT_EQ(*(uint64_t *)vcpu->run->mmio.data, ~magic_va=
l);
      |                                         ^~
include/test_util.h:58:26: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                          ^
ro_memslot_test.c:42:24: warning: implicit declaration of function =E2=80=
=98get_ucall=E2=80=99 [-Wimplicit-function-declaration]
   42 |         TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
      |                        ^~~~~~~~~
include/test_util.h:58:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   58 |         typeof(a) __a =3D (a);                                     =
       \
      |                ^
ro_memslot_test.c:42:47: error: =E2=80=98UCALL_DONE=E2=80=99 undeclared (fi=
rst use in this function)
   42 |         TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
      |                                               ^~~~~~~~~~
include/test_util.h:59:16: note: in definition of macro =E2=80=98TEST_ASSER=
T_EQ=E2=80=99
   59 |         typeof(b) __b =3D (b);                                     =
       \
      |                ^
ro_memslot_test.c:44:9: warning: implicit declaration of function =E2=80=98=
kvm_vm_free=E2=80=99 [-Wimplicit-function-declaration]
   44 |         kvm_vm_free(vm);
      |         ^~~~~~~~~~~
At top level:
cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variable-size=
d-type-not-at-end=E2=80=99 may have been intended to silence earlier diagno=
stics
make: *** [Makefile:279: /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm/ro_me=
mslot_test.o] Error 1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-666538d29b9c5394d2545cb4052fd3df79e618c8/tools/testing/selftests/kvm'



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240228/202402282228.57c4f885-oliv=
er.sang@intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


