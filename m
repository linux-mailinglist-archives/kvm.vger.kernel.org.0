Return-Path: <kvm+bounces-44631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE91A9FF03
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEBD57AB343
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E1119CC20;
	Tue, 29 Apr 2025 01:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZovwpq7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC834AEE0;
	Tue, 29 Apr 2025 01:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745889920; cv=fail; b=eifLhuxSPprf9PR8pArd8jUZuWf/fua2YG8v1VpknDh6dneey4Ff4FUwVwj+2PpKgVSaBy+bTAx3ueRtQLjVVIE3VBxboP3Yl0cIoNYbEcsmD/tXtL89d36uHVfhwZAteeJxNfv8ciKcbJbDASiYGW9eRD7GEwZUgBsGA+pD820=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745889920; c=relaxed/simple;
	bh=osKzG38gaoT/TZwjh/2Caw34Cs2ne2Pm2TQmp41SLHc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lC1ZdkbfkweQPWOJ1se408SB5Q64vSC1XRF/WRBDlzMU2MmxNbDucn915Dqk49fGecIk+ZtRTZ9FuSX/Ek6xx1CI0OOP5heg26yACQ+Xqb/bDaHdFf2ueFIrIRb8tj8Bs9SXf6gxtPqSqBAFpele4kQaKIRI0bcDfn29rrpbBRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZovwpq7; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745889919; x=1777425919;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=osKzG38gaoT/TZwjh/2Caw34Cs2ne2Pm2TQmp41SLHc=;
  b=RZovwpq7h0eiYNpuhM7lwrP80kfDZ5sP+aLOAbgRtEJQePNcTI82ciq5
   mIcpFejqiYz/y5xfm90kDM1r7Po1GvcPdc4C43EsUoOdtz/sbIgOFXqvk
   tNXrixQGku3DWUE0pkWKtR77b3GrsxlXnSXFY15DoNfUX8JUmldkUlpP1
   +ALDo4vYeVF098Uh25AJ/IUlonKoAuLyDM1B87aXEIGxQE7qvau+OSPAP
   eybcoruGZrh1r7pgzcB8+byADb56gYY3cZBVU014YbmYNDQ+KjmYqhoMw
   W0P+urThVrP2sEzk9hNkm7Cy7p1o4b69/yrz3AKqUDrRp3fqPzR98WZx9
   Q==;
X-CSE-ConnectionGUID: OQ9kh4q5QGO6R4/ieBO9Rw==
X-CSE-MsgGUID: OJEAM8Z3QjiW6fVA+zXH6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="51313959"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="51313959"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:25:15 -0700
X-CSE-ConnectionGUID: qiDm5BK8Q6CckOJ3ecgmxQ==
X-CSE-MsgGUID: MDk5sS9JQjOva0QnAykiZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="138471851"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:25:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 18:25:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 18:25:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 18:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HakCqBlP6FFNxiPuGpQFeAxdfD1HSSyOcKh5NeHj2nd/S3dydQIPbCTED2ouTa8TUTNd0Xf9ybdE9iZWQPl4cl9bYy0lJgq2dXyrnEjIcBHTdN7qPisiBSwTXkWEk/qGhT6oX6vquymdykrYLYS3jBj8L4uH2Rhv4bR9r+ppbdJyJypLdFHk+4Sd+J2XD1m5hlo//7DFQVQTRR6Ha4Nl3TCJk0tfm5+oCeS92MyFE9sCif7KF74fnqOzblT7qxK5H303qJKaYpLIsN8jP5P+ewTdJA0SbEvdtPRMpB2dkdvaHAP2ghUJZ8jRpCgLt7CjQdjuUH0ZMFqN+MhE8Dybeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+vCnCACZ0fQQEKaaxIgcgdsSVu+81btMpAGdkdzZ7A=;
 b=YL2b+l2KDA7OHjTUL56NE7BEwp2Tdh2L4kdFmR+0Kaka5tM7G84ScLAv7Myus1Dcu+lZxmNhLcB74lr2V+z3zcyfUGzZRBy0GxT7IZlRe5TMs4+KTLQVzGoAisrl5+HF3pGl1O+MF0/Sq5r1K4qIiMiasXSx543sPIFah9FhhrYn2Q6noL1Ued/o9I+UIPH0lnrGEZcnDKHucu/SA8+UVO1WkQBRQ64dY4DcS9By02YbChVJWwUNNogAMoodXyJMq+t4PIHxhakBNz7JuemLDapeKmavQl8SjFXeKOlvzq+hgTZuaWkcCFOCANIqh951571yJBCSFX1kQWqGOQx7JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8520.namprd11.prod.outlook.com (2603:10b6:610:1af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Tue, 29 Apr
 2025 01:25:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:25:08 +0000
Date: Tue, 29 Apr 2025 09:23:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
Message-ID: <aBAqAfBQRwP5Dx91@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250426001056.1025157-1-seanjc@google.com>
 <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
 <aA-VrWyCkFuMWsaN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aA-VrWyCkFuMWsaN@google.com>
X-ClientProxiedBy: KL1PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::28) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 28a1b45b-d1b2-4c48-1a7b-08dd86bcadb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mqi9b8R3Dl5o92w2O5II6X6sEJ3XWru1h7v6/0h5x9XcUIEtC3nC3FD98wIM?=
 =?us-ascii?Q?HF9cfcNW7pFPQGx37OJKygc0xD55r28YOPoMzWyCRCwrzCMFc4OF7IAyWVrS?=
 =?us-ascii?Q?qA+COykd1A2q+BVXMtIk22lAOBdvJMTQWrrtHXYWGzW9W0gQZipBa7aw1Q6C?=
 =?us-ascii?Q?TYCPTWkXv8ern5vS9NPPlo/zJ8sBzCLzA6nfZiPrcyUzJm1KeXeaZDnsL/UT?=
 =?us-ascii?Q?0ukD8qmcrYsOevlLgHrClY0JfnL/OWXoz8M91K12gQjsukV6upe9DdsxGJX9?=
 =?us-ascii?Q?uNebFZ0CUS3U7F2bGN5rI+EUvLPbDqJfAVsz0yTZNje46VGlABwJdApRPAXs?=
 =?us-ascii?Q?Psppq1nYZvHALkEFWj9p+EU105/Gj1bD5rS2puFtfxFcLuf74I6ZmbWsyrVc?=
 =?us-ascii?Q?1FqeZGxkDkEFY0Qa/pqRllL4/x8lCfKYkIe3cjgEMiiFTr067AYzNvEs+F4X?=
 =?us-ascii?Q?dMk0WpH0BWruo05SUORV86I1+CVKNbuzBnZSy4z/MieoQt/G4c0ozAhNRmkU?=
 =?us-ascii?Q?n0C5+dCqyMlD3w5dimA/jhwqi0rpbhO+50iFqlcTb8zjWWQs7TH4cPs2BGw2?=
 =?us-ascii?Q?2o0EqMC4JKVAbokayOFh3V2Org98wtu57V+22ndunsA8r9vW5yuYU6sVXzwT?=
 =?us-ascii?Q?ZcslFyusQh+R1KLzTOJkvYWM9y5LLK9y8EKQfg9so001qZj5Px6kr952WVXG?=
 =?us-ascii?Q?A77Li/67NoD1+zypRXq269Hw6NfY3VAyTRt3ZejUc9b/IWcYKfVm3+UGCgqp?=
 =?us-ascii?Q?9wtS+Cd0wAwU3goxrpuEMN0Vu1I/lu5sPDv6GsbD9KRbkTvVE0i6NMF0Jexd?=
 =?us-ascii?Q?nI7eAK4+ZTkG3HQ0m/Z7G6R+I7VVCotWMV4RdJfym3gDe6cgAiY12nh0c3gU?=
 =?us-ascii?Q?yjslm8gN40yixfpahJN5H2cVwolHLARiqAY2aNCrYx+63b9DgA5X9zHOdxcW?=
 =?us-ascii?Q?9zAnQGYNncLgAkFfD/XmvhVIRQ2XTn99iDRZdqp+Ub924aES4zMRZ0wGnNLD?=
 =?us-ascii?Q?Z1f4Xpmw7l1udvBzcxwA4nziI5wAB4gnTRslmcghpxKHQM+xz9Ksa0BRpAZt?=
 =?us-ascii?Q?6wcHzp8W4w9avEJuedXeedNMuPSsOfUGOesSGLL1R3du39jApVGykSKQn/M6?=
 =?us-ascii?Q?kOqLScfajPTjioUIhrU/+c9HfcOMF86AaEsyEd6/kQ5F35nnzXW+0Z1hxG9Y?=
 =?us-ascii?Q?YuRKNq14q64wkn30fK4NeAzzX/L/OiMSzLFpJRbvxgOuKviH8mIHCU4RtjDr?=
 =?us-ascii?Q?X0+SlRfJrcZFIM58COW0VCpReftdtoJsvjVT8V3ySvszrc/5lU2Foo0YJQ8f?=
 =?us-ascii?Q?vhSAinflDe+OszJDiP2VnUxzA38UPIybaiVzPde/4disF4U5atwivAL9hp75?=
 =?us-ascii?Q?gs5wQd4cU3BkwF3U8Emz+3cvEaFK+btVl4HgQzfd+nTVE9BYbvJV4UBskbpQ?=
 =?us-ascii?Q?zCDRgkoNsnU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KlsPwqfrw5Lo73eaqvyvxJvX0I6kRcEU/PDSrJYw8b/y3DFOTJwa1TjCIF+Q?=
 =?us-ascii?Q?iLojttHDQLpjfvWG4qaZrXdDiRmeDKR3R/4aZqbA/UJQ/4Vmcp42aLU41TTu?=
 =?us-ascii?Q?sSpDspn5+/YuOS683jb6i2jhx1BjnfI2nN9gAd5RTa7QcY35e+U/7uGfAqTv?=
 =?us-ascii?Q?82Q835/ws9RI7a+aDsJVcxopVD0tSrgCKi0j6A/y3qGyMASA1mCyE8Q3Ij4Z?=
 =?us-ascii?Q?e8RuBly5VAwuJp61dvpPKfwC1Dii2WK35Prs0uiCwIfofv7bTl2qT4GfR6ur?=
 =?us-ascii?Q?XSCaBwGAg9a1hIGLqT1yMAEAFD+8U+nlNcb3aqrgJ03/jh+WrIVeLZa2Aejp?=
 =?us-ascii?Q?YDcQR0c1ll4mCzbPYlsa5G/kuckSpUXsBf3l2Ca4DB4cDIlbOMmY/kUmhtNQ?=
 =?us-ascii?Q?nTmCv3rDlaIaUZtGM5ibaIopWS/SFrpcfTAJ8xbw9HyrwBTTDWCAeYutOJrp?=
 =?us-ascii?Q?2gD9x1ZEQD2bjHjq5sREsBt5lWSORuUMJhQWq4yxBQ4GegWiFSvUT8TttdOV?=
 =?us-ascii?Q?kkg/zmyl2uZd2FwTBlEeZpFn2uMBAufltkOU+Vk2IMcvTqNPpSqMT1QkIr8E?=
 =?us-ascii?Q?bp541X1KuAwcjt8ECMSgNt7tvnNhO5FBJCgcWu5wmZe9QNoVyRnFoXSOvTgt?=
 =?us-ascii?Q?Kqi44StwuLT4O6THDlBqtX+uX10IcIFHS8WX1DzIfroyBK4j+vpLnVGAYcXh?=
 =?us-ascii?Q?FTaaYMoW9dR7H6rV/LyLP2qf+GWQnNaPVYR+eAQVAxpfCy6QqhHxpEzUmZXf?=
 =?us-ascii?Q?0wAe5JwOBikP8jqOM75sl9gJ3myrBUvk45PhV5IZEgxgZukJagdScySkh0L4?=
 =?us-ascii?Q?v/jGwBOxIjU8Cr0cxyIdWt/07zPGI5EO0ppBLGdmVNX80TA6vMTH15J+vNOw?=
 =?us-ascii?Q?e4ZUlMwMsJJzCCRfy15Dkz4Ht7/ltxHOXmFUmFXmEyVOqbfvEV30kXh5ikYG?=
 =?us-ascii?Q?4cqyOdrfszI9Y2Sn2me5b4eD/aIIv4uadoPbuttpVXPAeSShY0svKQoIo7qY?=
 =?us-ascii?Q?LkC6KG0jW30rXdiUhex9B+te/KxmpNGbty3KNLFJFa2nxcLTtkjRtgyk6Qge?=
 =?us-ascii?Q?0vxU4vFyGETyeetV5thaUaa9IRC416M7mvYcsBxXezIru+MQdMyn3KKBbTMk?=
 =?us-ascii?Q?mtSoIEkDn72TJoM/IvYt2Tzths2rsd8nPpixUeIM7lIyINKlqknexJjD0X6H?=
 =?us-ascii?Q?8ui2mkMTzFcZ9vx58CPjfHZz8+UR0KmVmEwERU2+d09QCOa9LjpKpCd0DSA5?=
 =?us-ascii?Q?sTYgrfTw94imwbU7PMi2dkVECazQnaAFrYuq+xkq8Fay9TJqhR0W60MklmTt?=
 =?us-ascii?Q?jcd1jcMALpCuGW4ptVEtRU/BpO3ON8MpxTHRZNFITO1Or9xuWok8/PQAu6Rr?=
 =?us-ascii?Q?9JTN3/djr2Xiw75SzhSIMg4I+XXS1jTdaSGkhSoMFGEHyWPbWg6QUHhuWkSj?=
 =?us-ascii?Q?4Vb8xgbtDxbDk5GB1zDYBrl//YUrMlyZjneNwVLrjYRCiz/21W6Tl5ei5a1B?=
 =?us-ascii?Q?UR9qNyEZcC1QefAvO/Rd7e+Yu18QRx33ODL4RsSUpF/2s7SHpELBT6kF7ICC?=
 =?us-ascii?Q?hM7T8/A7N0IT878VGcJxDCIMRzbTqpZUmDOmmfD1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a1b45b-d1b2-4c48-1a7b-08dd86bcadb7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:25:08.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 018p0ZGdmHrfF7G9iQrue41BL6s9cnXnzAnB02mFBATgaiNXpLKGSrVGfLmIKAAvAy5aJd1Bi1kHtX9ojRa84Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8520
X-OriginatorOrg: intel.com

On Mon, Apr 28, 2025 at 07:50:21AM -0700, Sean Christopherson wrote:
> On Mon, Apr 28, 2025, Yan Zhao wrote:
> > On Fri, Apr 25, 2025 at 05:10:56PM -0700, Sean Christopherson wrote:
> > > @@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> > >  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> > >  		return false;
> > >  
> > > +	if (WARN_ON_ONCE(range->end <= range->start))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * If the head and tail pages of the range currently allow a hugepage,
> > > +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> > > +	 * add each corresponding hugepage range to the ongoing invalidation,
> > > +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> > > +	 * for a gfn whose attributes aren't changing.  Note, only the range
> > > +	 * of gfns whose attributes are being modified needs to be explicitly
> > > +	 * unmapped, as that will unmap any existing hugepages.
> > > +	 */
> > > +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> > > +		gfn_t start = gfn_round_for_level(range->start, level);
> > > +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> > > +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> > > +
> > > +		if ((start != range->start || start + nr_pages > range->end) &&
> > > +		    start >= slot->base_gfn &&
> > > +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> > > +		    !hugepage_test_mixed(slot, start, level))
> > Instead of checking mixed flag in disallow_lpage, could we check disallow_lpage
> > directly?
> > 
> > So, if mixed flag is not set but disallow_lpage is 1, there's no need to update
> > the invalidate range.
> > 
> > > +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> > > +
> > > +		if (end == start)
> > > +			continue;
> > > +
> > > +		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> > > +		    !hugepage_test_mixed(slot, end, level))
> > if ((end + nr_pages > range->end) &&
Checking "end + nr_pages > range->end" is necessary?

if range->end equals to
"gfn_round_for_level(range->end - 1, level) + KVM_PAGES_PER_HPAGE(level)",
there's no need to do other checks to update the invalidate range.

> >     ((end + nr_pages) <= (slot->base_gfn + slot->npages)) &&
> >     !lpage_info_slot(gfn, slot, level)->disallow_lpage)
> > 
> > ?


