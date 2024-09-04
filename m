Return-Path: <kvm+bounces-25807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2104596AE95
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 04:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8378AB23E2C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 02:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7FD3B78D;
	Wed,  4 Sep 2024 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="as4+1UFn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFCD18054;
	Wed,  4 Sep 2024 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725417019; cv=fail; b=Abq3femT43dF338N7oyfwp7r8asuKv4Bh7hVExVjDyadgokm66Mt+T7ajOxwm36A9LcYBiWyjpXHgJEUPTH1L3rc5vwnXiCjdsknfrhx2ktXIRoqUXDjaIxAVfvnIqg2XxZ0l2jTzNNro9GlLqh2KTsUL120RfBfBGnjhwW+Kio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725417019; c=relaxed/simple;
	bh=YpVg1txxjTwJDMqVQ2Rh1F/pSYjt4aBg2N2tsvbhIek=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CPhBEpDDqWlYep1DJ/gIqsAdqL6ayNP/zokvoura2OCzxD5zbNAFretONJrb2c6eI7MUs9XCw8iE7YzLQgUI/v2EOMG0fzg7uq42TiSiWmCJcRjETCrOIdfMJJ9rsmuvIaHVayybBEH2RsjAta8K23YN1m+RX8u16sqLIXx7a04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=as4+1UFn; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725417018; x=1756953018;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YpVg1txxjTwJDMqVQ2Rh1F/pSYjt4aBg2N2tsvbhIek=;
  b=as4+1UFnVuARdMN46eaPLuNJekEc0XaglzRjv91JMOZe/8MDcc+z9hcf
   Upm/I5ZrDS2wYB2zC4GjM61MAsMlCL0cJ1m+/pBRWlo3xjJCsI+8esouI
   TsH+eIphRwAIKVK17MLQYS4jWOkAzWqw/vz5CpEaKneE3/kDjxrlmuxwe
   coqgn5aVM9y6TDUigF9SDqbMox8FSDBRcw/T5UkZ77grWxTthkEMAduNu
   M3jxqXU52zyCn/uIy1+ZuNe7b6rt4AMu1v1u6SXIwN9XZIyIpmMrNrPy5
   B0JJT2a3n+CktcJZS0IdrZKDbjZnnRyBXY4QDtyYhUF8NHsrmWM8Ipwh8
   w==;
X-CSE-ConnectionGUID: n3xSD7jQQbyV0l1nPfRHeQ==
X-CSE-MsgGUID: E3njQPdIR4+tO1CJGnGOAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="41546238"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="41546238"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 19:30:08 -0700
X-CSE-ConnectionGUID: hLortL+pS9KcDLpuNkh3xA==
X-CSE-MsgGUID: 9Cs7VgpvRt6kN4PQFGBaOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="95915612"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 19:30:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 19:29:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 19:29:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 19:29:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 19:29:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQGwELB8Wd7UsGNIwCUtBFIky/ADax4tLUMrsu4gN8SLptBnSD0+n9+TZfd7iGJthOB0+txaawsXCDLU90J5yaCjlM7h4BJ/hlRavUfCUzkTH2Eq+kD3wF0gGr57o7Yq21vQcnXJuxi5+SyheC9FmiKeEDVasygGJoR3vWECxZ7fd8OTPwxYJ1fIWb6KW5yxW7N0FcVeIAJHqX+7oLks7Uznp439r1h5NWUXoCTjZo1wH+yabBiScErigBhFW5L4D9fUDkIGHH2RvMaRa6YAB/8kky/x31Un2TmJb+xcDcBLBGEgLuv8sZse49QXaJK3h9fq7BCNtHLB2zdjtlvYfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWJ5flnMlqInGvLRmUvK/sOuGOjZwjkExD2xtvvwM04=;
 b=vWResgT1lWOeeqL55eeWzmInYBXh7+lDacuSwBWzokLNVkNIAT3KIm0fdnvdfCV0ZBU1JQdu2wPOHwOS5IvoEdDlwSAHSbZOzJy/ZPmVGZNO97nbQtOFOJWDvKutP1LhQY2Uufro+Oj9ahjMljF0DpOP8bTHf8Z8WOrRDmND1q9bCzuvyKq2nnRYusG/X2myPa5OWJO9luw0Q1GQG8Gw7nAKPWZZ73SE7B4oUXx4kEjECtr0+vxcURvQZ4IyapZZnsGf4piUVAi6+eDGNAVwVBeOw4FBteHuinOwm7k7SxInAWcsTJK14z5IwnnsEdw006zNAQYGJIgmCALw09LChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4738.namprd11.prod.outlook.com (2603:10b6:5:2a3::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.27; Wed, 4 Sep 2024 02:29:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 02:29:55 +0000
Date: Wed, 4 Sep 2024 10:28:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann
	<kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, "Lai
 Jiangshan" <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
 <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87frqgu2t0.fsf@redhat.com>
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4738:EE_
X-MS-Office365-Filtering-Correlation-Id: daa413a0-cddf-436c-6b03-08dccc8976da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wkVChttRmWt7sIwAeECRV1rPUxvhRrCmL2Eu8/T2ZRz0jUNx1/18tUEUl65x?=
 =?us-ascii?Q?yv0K+F1LQnXkwXShDSmVKPCQVAiH9qc8rpgG8iHVJDfiI8HdYbqvhYX3poey?=
 =?us-ascii?Q?sfDJFNfcUoHpFl+p7aq0mSV7Di/Y7aRfWJ3+how4FQ+ecNQW8qhcuQKUkaqR?=
 =?us-ascii?Q?e0Nxw6/g2IwGpyOily55ePg7zm0AaqQWoJ13MC+syrTtEPTsZKUW7Q5d0oZ5?=
 =?us-ascii?Q?zC2pIfE5Ege/sD0vvt8NnJv2vtZRczWBs6Yf2JOCI8vxJxRY3TVRS8bxX5PJ?=
 =?us-ascii?Q?d0oMat9HCdCyaH0UDNxAbmYoQ/d2F2quehew85pKRV3amYE0oQJUYSw6lAJx?=
 =?us-ascii?Q?HxiVLZBYXje8JogITzMm+FwI+qY8w2n9Vu8RuN47ucK+Mqo4QzcVupio9IlR?=
 =?us-ascii?Q?l4PFRiHH1hI9h8LaYkKgA2KKWNIfna78CfdhQZKWIJsnpWMtk8WQStu6lwHl?=
 =?us-ascii?Q?GefcWptB7GmWKaeAFKdfnmXFQEkZkSpDmxdR5CQ175mY552eGhV90p6ZhIr4?=
 =?us-ascii?Q?2Vtx0PiZS5KNjpEWOyJz237EJi96NEL+bSGnC2pdNY6aE4vjcEc294tYWp8j?=
 =?us-ascii?Q?LM0fh3hYbnFvsvgQQM/GMFGkm3moFsfJ4ojJc0MM+7gcG0M5MoPrxpqo526c?=
 =?us-ascii?Q?VBBzAzfwDkq/NAWOg/q8S+2kXbePP6YwcSKAJ+wsRxV39MaOAiAs4lZwybtK?=
 =?us-ascii?Q?KmvPT0EtLi4vlKinl1046VwL/nIbzpIudtokDoiybsA6SGMjcpI7lMUNMrSx?=
 =?us-ascii?Q?5xO5VCvuBjX1oRbJ++HXmvOH9qJWaHu9/iou+/r19tnBAPliI1Km0SOuCTdD?=
 =?us-ascii?Q?fmwWU3q/7cLas3yoO52v+O3iNsTbWd8uVDIhN2caI9P9ynECMcpWwQLji/ZX?=
 =?us-ascii?Q?pYki0Zoj5ngaD+sPaBzgD+A28q4YsiPfFmuYZ8yB/3RwLGZbChkdM/BScMgi?=
 =?us-ascii?Q?296CTeBMuPTa+73UEMnIHEyZsVuVF/F6zIMZJR8X16hu3/l+ZDfj6RgllDdo?=
 =?us-ascii?Q?aB1PWf/C6Taf8gfYW7dqOeY8ksanuPHf2SLzc8fDmmxBYbk2t+DNO/HqXHxt?=
 =?us-ascii?Q?ZOg3ABDS0rpRLlSRXxzCdDvjiWC91Ss6qswIayzud3AOcxmpc0LyTWwTfOtE?=
 =?us-ascii?Q?P9X+Pg6575KfYdSjYhQvLjNoJWOxRvcDfJFB8Mtq+vHHyVCm2k4uc1dvq9MF?=
 =?us-ascii?Q?sV8RYaQOxgZn73psmSggsYQdtyhATxY8KPq5avZ7rKnokSiGVs3XcRCm2z63?=
 =?us-ascii?Q?g3k97S0E582Oiks8MNfXaQi8ACGQXIspHwejJHDTJuiUmoI8qipuf88mcruo?=
 =?us-ascii?Q?GZXEijqHTqRMRsGH0ZGKdnyE3RasnIIsED7kMzO4ZYlDzg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KWDigKY+PCW4h9255QhuKp103cu/DmwEK8e2fngMmgb2zBRMIAfoegZBtH6T?=
 =?us-ascii?Q?IEpXobdkmEKSRrhGxhAs0MWlumNoffYCtu7TKnAjjZ8T0IAtszl1w4RO2XfP?=
 =?us-ascii?Q?CnjLjdowkl1ZJyprO0cx+UfS/pFVoK5wAVBMXac6D/s5yCXc/m87yzI5J2c6?=
 =?us-ascii?Q?A/QTPROPW9g/5HOT75Ud5n1MRkvXFxRmAQMigQbJKuAMxObCPaSlMt+JwA+H?=
 =?us-ascii?Q?NkkdBPbLISAhPK+uTP/YYHPsJVGladcUTtRpZzx2qp6M5CxKKXSYdjEkY0Wb?=
 =?us-ascii?Q?bgmgJMUo92XP2dLGEZd7+G1W92icYUi/JdvkktH8i16SmSqmv+CC50lj70tV?=
 =?us-ascii?Q?+Frcqj5OGaOQkwhtxL4JPxfDs76IShC5o+ofwOqsFTTli2rIx8cy8ZEXnMB9?=
 =?us-ascii?Q?cXl1kbYRaNDjigzP+svH82DDpckEvunsC9SRdVtXHqVHTNUSiB2pzAqsaPdu?=
 =?us-ascii?Q?0B3khuHyac2Y64qDYEHw9Yv45q2RFweKMZhlylvTj+TUQjqkk9OliVYGi+Jp?=
 =?us-ascii?Q?98I2G+oA0Ub7EuweI4idDrcPIYC7OzyZF8QiUVlVVpzkIjgISFLuEgVy71+9?=
 =?us-ascii?Q?53kSnesNledm8SodLpwW5YyvBoC3+1ybclKL9hekYXCi+OKURepjoKOPLawE?=
 =?us-ascii?Q?54hfM86uih7ELjwe8fFC3Rq+N8z2Plb4EERwxIZnQUDhX+VurFR6MgylWZDA?=
 =?us-ascii?Q?XsH/AIGrQSYPkpkQoheOBNLRd+TGYSlPCdiiVlMfDEqbOMBY8XqOAv87vEIa?=
 =?us-ascii?Q?ig7Db+jN5IwEj46DKtM5AItawmo1s7JuTPvApQ+oqUUlHT/5wffMZwbAdD8l?=
 =?us-ascii?Q?1TTlwbFSKWDRPi0I3L2k4ZMG2koFFS9tytrr6AK3WaYkSkZN3fmFsCeU0qYR?=
 =?us-ascii?Q?4T04ZFPAUyDDqXlaNc4OTqMnDb5N8er4nBdJxqVKXKb+fsG3UrqcgoLS7urZ?=
 =?us-ascii?Q?EPOm6woByHUYnDS6Dvq6vZcJBdEUBN1b0dXYNpMBS80lQSIGWWeeFhEWFopR?=
 =?us-ascii?Q?N9Oe1LuH3o8hJUZh3LO/FxjGgo1dXWbHhepvOFX12onmm2wIB0jcljdJcP2v?=
 =?us-ascii?Q?JNG77SnmC1ptQLmW/8PxJiCJvDSG8xUCoHYaE21UfSHpuNhF1y3nXRZ1qHtz?=
 =?us-ascii?Q?ynKCueXkwPnLynXeVW8qAeYZhocFLDjwnJH5okkk8f+aWe2xMl4veW2Qb9Hs?=
 =?us-ascii?Q?Iu+/7fn/WQ2vxlUMJbN9G9SjzlwBgYIFaac7vhRhYb3/FVYZOi+OX1/GGaYI?=
 =?us-ascii?Q?dlngTOmAuj0k0dNrqN8e+78Jq7hH2LHeqA0u5WlHaCiC9K/OOQv8UC5jAA7G?=
 =?us-ascii?Q?/r38uE/HNmhfVyrdet5miGR0qPEdMfswuCInOZ1eM/fOCfJdZ/dedGtS5IIc?=
 =?us-ascii?Q?J5OQteyxFiyp7dBZbZvDEFE+fk5rtaI6w3+AMuyDwp56UZLOi4B3gIIN7hM5?=
 =?us-ascii?Q?C2MZVykfAJ5a0jgmC1NNNmhgK4+sCef6k22OZuwElPHv7LQOx8PbXl1R0tCu?=
 =?us-ascii?Q?BKQuJKwIJkBo4/MVrWl2xXF3gZj5cunmul7rI5XVTzj4Zy6SbF9dMEqriLpx?=
 =?us-ascii?Q?wG9p4t+zas/0/tjMWo6T8Js4hnKxyPOlwtttq/Lb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: daa413a0-cddf-436c-6b03-08dccc8976da
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 02:29:55.7584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Lft7N1iKXBnsVLsscXvqL3UxvA40bV+Jx5aTOg+QHIfuy+R6KUtIWPDXjHI7NBz3VXoXk2wyXrpweCPiWoIVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4738
X-OriginatorOrg: intel.com

On Tue, Sep 03, 2024 at 06:20:27PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
> >> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> >> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> >> Silver 4410Y".
> >
> > Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
> > on another hardware issue?
> 
> Very possible, as according to Yan Zhao this doesn't reproduce on at
> least "Coffee Lake-S". Let me try to grab some random hardware around
> and I'll be back with my observations.

Update some new findings from my side:

BAR 0 of bochs VGA (fb_map) is used for frame buffer, covering phys range
from 0xfd000000 to 0xfe000000.

On "Sapphire Rapids XCC":

1. If KVM forces this fb_map range to be WC+IPAT, installer/gdm can launch
   correctly. 
   i.e.
   if (gfn >= 0xfd000 && gfn < 0xfe000) {
   	return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
   }
   return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;

2. If KVM forces this fb_map range to be UC+IPAT, installer failes to show / gdm
   restarts endlessly. (though on Coffee Lake-S, installer/gdm can launch
   correctly in this case).

3. On starting GDM, ttm_kmap_iter_linear_io_init() in guest is called to set
   this fb_map range as WC, with
   iosys_map_set_vaddr_iomem(&iter_io->dmap, ioremap_wc(mem->bus.offset, mem->size));

   However, during bochs_pci_probe()-->bochs_load()-->bochs_hw_init(), pfns for
   this fb_map has been reserved as uc- by ioremap().
   Then, the ioremap_wc() during starting GDM will only map guest PAT with UC-.

   So, with KVM setting WB (no IPAT) to this fb_map range, the effective
   memory type is UC- and installer/gdm restarts endlessly.

4. If KVM sets WB (no IPAT) to this fb_map range, and changes guest bochs driver
   to call ioremap_wc() instead in bochs_hw_init(), gdm can launch correctly.
   (didn't verify the installer's case as I can't update the driver in that case).

   The reason is that the ioremap_wc() called during starting GDM will no longer
   meet conflict and can map guest PAT as WC.


WIP to find out why effective UC in fb_map range will make gdm to restart
endlessly.

