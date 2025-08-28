Return-Path: <kvm+bounces-56139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E18AEB3A4F4
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9601498461F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DD4253351;
	Thu, 28 Aug 2025 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuRqpbgM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E541990C7;
	Thu, 28 Aug 2025 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756396387; cv=fail; b=kxpSLkZEiQZMV7l1jtXFLhk3JJ6JKhZunwZfNzBODVB/g0MdM2T0xqprb0FEZx66GbR3s7qhydbnckLvK2OGVs/gUg5MSaAf6qqbeXFJN9rZSBTL2ueQ3rcaLl8YxkYYYQvqv/BNYeQBZJKpiSMgDYkfIx+FVDo0+Am2OiVab+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756396387; c=relaxed/simple;
	bh=XvQ0dkMfmdiFsafpya46ZzU87m/4+7FiSo4a6lJ1Gf4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UaVDZ3ZkEDgq4p6M92QtoNxnuVqfZP5VcaKlcnADRj0KdZhUu20Ua8YcQdiss4Asxv+N3DJYoQQgBcXsdtnEJb4rVMwTHOkgioEJ58Z4Dez1UkyTgE05J4g7WqfDWE3jNY6YWsJFqtkqky1Chdw0iWVRJ4LlsESNSa87qBAHnwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuRqpbgM; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756396386; x=1787932386;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XvQ0dkMfmdiFsafpya46ZzU87m/4+7FiSo4a6lJ1Gf4=;
  b=XuRqpbgMt1+VShB1qbp7FPSqKlpk44m7oS63HFUmMPy7qxJkhP+H4Ka2
   pMzlVv9dq/cq/aNubotNoSTcPCspzf1MNCAUBv2UPCwN73+axSBkyJRNg
   701YX71tW2+4DzRVJTA4gkAee8DY/SXmEjItrj56GTCe0B2pX/N/kAPP/
   RsVM/pDbzyf86nDWoFhy0SrOqlqNU9Je+jOVSCan3cKYBUN34If11jQZT
   srZ7Gja7ALTyqpdVrIEgATY36P2vvptDn3a0moVmet+FL+IjJOlSac8gY
   Zmbj6fCuMBMvZrRCnOe8XkrwPhDX/U5XtN126x53bmssxZbCmWVDP1JFt
   g==;
X-CSE-ConnectionGUID: YWludXfHTCCKOqr+BbB+mw==
X-CSE-MsgGUID: 8itNiNeoQRWrpsDaiEcehw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58735333"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58735333"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:53:05 -0700
X-CSE-ConnectionGUID: 2xG7vjyuROOM/wylzL0TbA==
X-CSE-MsgGUID: mFynKFjlRAGhaQGDQQ+46w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="201066015"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:53:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:53:04 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:53:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.45) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:53:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8sG4kI2tFCJIaoAP8ioip4eDcRetMa4NJhpuPo+6OmJQSipZq478iMTzXcWcDrl+j4HvWK74DQ2KMnnqhAKR4nnR+BncYoaZSbe4EHy4xxvGqArDluheAvoZkzEri4/fuphjCY+s0nECH40RAg3MmjGeO4V/q5WZpsb1AVkDm+blZQLKenFSos4nL1DC1QdhzncNkid+8YipaVP0jtimYb6bTtPN3TAYuplppP47fkpGo9hH1vgcAauzQNJuJ1ukOCKUsSYmCCYvTtLBXjEKC1KqhmUs6i7mQYz8zTqp7+FMxhh1JwmtBsQ8ydeeDz4rBZNZMgf3j6RrPjcBYqMpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iktnZvklIm64bB6bZCWLPYcGIf4xUFDvMnGMHudgRX8=;
 b=mF/YZzUapi292G3BthNMxp7ZVdpJN/H8YHU0j1BsjtrfOezo9/Ca8mk8nDdMPL2gVpv3cpdTXYtqQBW+xc0sA2dIobu6gvWANYHZOoXvDdOZ97ADCybvdkdK4yXWxRyBhHbojBhCZoULJn5QVvfhfUJUOHk3nmUcm0bjTMXqqoGH7tu07KO+/HDJeaimRCceUJya8azvzt4ZSdLSRc3SRL48+5hzhuz3OzHYgFP0uz2wnM7uYpd14KBOY/YTmA79IqpD6Bbudm4+sPRvmyM8kgAjVJwxaNx/Hc4HKkBoULxPrPo3rvIIkoSn+MnYbxixn7JJLWG2Ax8Gxalc85Ucsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CH3PR11MB7204.namprd11.prod.outlook.com
 (2603:10b6:610:146::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 15:52:48 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:52:48 +0000
Date: Thu, 28 Aug 2025 10:54:36 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny <ira.weiny@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <68b07bbc6d5de_22d982946f@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-6-seanjc@google.com>
 <68afa49e235c9_31552945a@iweiny-mobl.notmuch>
 <aLAAX2fQFZh51ONY@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLAAX2fQFZh51ONY@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MW2PR16CA0027.namprd16.prod.outlook.com (2603:10b6:907::40)
 To PH3PPF9E162731D.namprd11.prod.outlook.com (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CH3PR11MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd9fe91-55ed-4130-cfba-08dde64af022
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8KGJsXDIz2on22NZQeEdpfqRfMmnGsixll/H6Ecsrt1xBZQfwLAnQ26xXIzG?=
 =?us-ascii?Q?vqHk60qwAsHYKHYwHmlPXOJhpeJ3sCno/NtNFImyZTZNG6xRX0jMKgXu8yhk?=
 =?us-ascii?Q?ewOzFnmPiwKUKmDm1kuL7qjrOhVOusDVXB2Hiu2VxpLKlLM+/R8bSD4VeGsF?=
 =?us-ascii?Q?T0Gx3YUhQayPQWO1h+/PSeq7WhY8BZf6UlxPpBt/VnKjmeUZ/7O44NdmPECq?=
 =?us-ascii?Q?2fe01K3TF4PiMnw6tY0tokYY1gq2ISEU0bIxFC4ymOAaV+2OAPTMlSPonNya?=
 =?us-ascii?Q?uQyvH8oBuPMx/GQnz+3FDAGINWfSeBWEK/hZETORyN6U4eMKqZuCNOvX48zy?=
 =?us-ascii?Q?Rc3TzbtjJXgPN9K5yZ69qaKHMYhu2sgRqkLOUgcaWqN9f6VUnEjyYSM19Atj?=
 =?us-ascii?Q?ELaw5NSQFkMwGNlRpDsI/fz0PDvzDefPlj+04ZPvwY67IWlTE4kXEH2jDGzp?=
 =?us-ascii?Q?R6/p4awGOSxwjF6vYVq0llyiFR16BwRx1iNKSC4EQ3+9zzBVeZjxpnhn1VYd?=
 =?us-ascii?Q?SZ3lcmAYNGBkDbejpzaIXg1/UvTN/+Un5Paq92V6IFux1WZj/uDpf/v8kQly?=
 =?us-ascii?Q?W2Lq/A/F3rqrtV/MxWIW4sQ5KIJv01sy2+qGuefKdmZzF23n5cV0VxyxzFFP?=
 =?us-ascii?Q?gXlkoMuXGeaWRazeR/Xz1A2IlQDvpWbZ1spgzOBsTc6RHpxM7PrYv5qEy/VP?=
 =?us-ascii?Q?vXpcwEpBWve/KK4CvJvpCrrVByADQQaTYxaTjwf5dM91la76T2RzLnb//z/i?=
 =?us-ascii?Q?Y5g6zzr2HKyNae9gJgxWEI5Th6GiqBc8TDoQL73/qnMnXatnNpxXBIhAl/4p?=
 =?us-ascii?Q?QmmvAjOjKNiqmEtMBx8Lu+xWKFEEolNNC2QBnveu1DASpI5t4W5Tgb5r5g2y?=
 =?us-ascii?Q?60+NSoYp2L/I02SEhyxql4Nh3SbJ6Sd+eSRPhaaNoHNK3aib2IFjuUMnBRFV?=
 =?us-ascii?Q?n36XqPBBpd0q4rnknftQd2H8YrpMThd1DwREfMROVVt+bygfJ+7NlxIEcTqf?=
 =?us-ascii?Q?rIkafLaxEzuOs40A4fMIcJn58JZRhJOn4SXGhSP1sPva6YJvD/6uyTUROpN3?=
 =?us-ascii?Q?omioyFxhg35QhqmLVaCF7NYg4JYfEIcwzTdJNRhuMRrRwYsL9WwNlxaM0M7c?=
 =?us-ascii?Q?HSWalNXCHUMGSPSQ4FCtdMoWTABvcBUGJnB/s1pvp43Cp2eDUTU+Z+UtJlOz?=
 =?us-ascii?Q?IB1u6srgPdHZMMZY4vTANThkPg33sDktZltCBzCLhtQ/CpvOe9QuRzgwa8vH?=
 =?us-ascii?Q?eSDevUHjiddmX4Mq1Wnbfrl2zVwY5qgtqB2ql4DWLT77Nz+Gc1Bmub9Ym1QK?=
 =?us-ascii?Q?U4SP7kwSZxnmIsrjyYMXI6d3Sc/0wANYzxZ3NJMnwI3FWlg/Z4Tm3yD2iOvR?=
 =?us-ascii?Q?nWBd1ZybsjKVFJAVyjLlAmufLCWmR2W8MMtYn7ungPk0UIWU1g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ry8N+q7/chjrYvy89ErkvEU9Ypp/Kl/ZhCxG7JlbADUPYKfcdeqzMHfkMp1S?=
 =?us-ascii?Q?ldzBhC8eep7XE5NZcGgYct2PIAhytgBe/tmpBX45beUVSe4iHl7lIgWaISsA?=
 =?us-ascii?Q?kg6QkEoNtnEQZzsL/8LBYAsyhsctxbC7fSg1L4DWQC++TphOYOMQaGZRFTvr?=
 =?us-ascii?Q?/P9nfKiZRzpSM29gGREIG8sHTwY4tfzX015s8tZG2AX9nU1jawGtmyW8XZ8S?=
 =?us-ascii?Q?dYh2LV8ndB4W1+WwZZnbZUGNpGXq316UYfUnliU3otPnwR6Q3d3aEHHeGfE9?=
 =?us-ascii?Q?jf7zD+Ht1LwM3k2rpv5xIz69hjcGbSjEJCYQMh+BVEituM/MVo+gt9eyyTlj?=
 =?us-ascii?Q?IG2KMldSQvyvYtSYgoeS9TIQ6lMNzBzU9QVqiDwxRcCqpnFwfGY1eyNJEZWn?=
 =?us-ascii?Q?Zq5WBsvXIU6GH+k0jBjneGYZS+ao7hF6b77VkaaXo0zK0jcgF9r5BXfIfS/A?=
 =?us-ascii?Q?BVooCqn4xD+iem00Qg8W8n4VR5budMIaZ3CeGBgP/PMhHNE+sctatT+eXSIc?=
 =?us-ascii?Q?qLIjY7y2Znjqv1ch48XSUUZuWmXibIEQ/arpiMXgYPF/JVJ3c3iPYcsMQsqI?=
 =?us-ascii?Q?ECZtTWqIKT3TqEHQnX4lDzLl/Q/fdVBmsBwyALYgHE8masjVRhnC4qraKJ10?=
 =?us-ascii?Q?XNssrA9ywfApVRXdDANHTCDF7QQRWIng0zIPomJgrDEM6vkHXmIBLG8zSgUs?=
 =?us-ascii?Q?aDyLInDx8KsSYz7IF3OMLBRDg3n8hHBFo9JjZPzhaFW6RYFz2mL3V/6I6hgf?=
 =?us-ascii?Q?501E/EMlTiasAojFvUQcXxU545bu7cske7IlVVgMWkxdE37ClnxDGiCrr7mN?=
 =?us-ascii?Q?BKD7OYTT4AanCOtnwab6HFcAMBRHXF3x63jvB6OEQJH99TezBYJAKYJwp8rj?=
 =?us-ascii?Q?35z7CeExrvcWX1wKP6NjOS3TyMQGDD5XpDO8HInvd+qEYevjXnjqF6teDfwC?=
 =?us-ascii?Q?npKIbekhAUtvJLYrpJQ0BGmgtcAHZ+Ms0GFqj3vUsC9Lt2J/JRDPv/IQgMNd?=
 =?us-ascii?Q?ZwtRy3WtrbAbqe9p4n6dIQEeAOLJUP0zO4qTCvFduL6vaprINUudWAMjRHlb?=
 =?us-ascii?Q?K1p8tGc01jano9LLv9b1djK6WJM+3yrvLagDT67h8jYJHvfn2qfXt8qjaNib?=
 =?us-ascii?Q?r1PNH3tzOPinAbJ6eq94yxPKiTRav+L15ubXLhQcr64d1xhHgXYrU6WZ1Qn7?=
 =?us-ascii?Q?xb7zTec9h4ovBXg46/dSQeDDVAb2xJZ4snyXv2Cf9n5ih4Y0s+usYu9JpS/c?=
 =?us-ascii?Q?vhCapOWx3f3TPjX/FkLLEXzfnDiuzu6QdAeCgJIJ20ZhSMCNA8fngWsmirOL?=
 =?us-ascii?Q?wWtYVDpDku8kpwApgKD5K9VtxLN5zNTwx/phjBhRgP91T7Z2GMVJ8tyErV/s?=
 =?us-ascii?Q?UObn2IYjM8RRx4kwY1XmQwVzs0iRscUAUzj+yOSTIDSQvjiIoNdwrwDH2eDr?=
 =?us-ascii?Q?M3mV16CS45miVHkaKQf+PoQhy4crE7hP3CqsjiQCx+KrPLTTs++vSHhpF29m?=
 =?us-ascii?Q?DAeh/DMC/ctk4vJSoHeESVuBVOD9OAEGgBlqIJjqcehXQ2lq8ao5iu6Uz+nD?=
 =?us-ascii?Q?h9RjY9agD8GEGN2sSkOZ0HqQuxiOypvnVQFbZJLXzz/fYnTuSObWL35yHbQv?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd9fe91-55ed-4130-cfba-08dde64af022
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:52:48.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np0BJJqrzm8jTdPW3aHCnjETuR22B0XUWSHeyd6mBYffhbLh/j4bBrhyL6sJu331rqZjg0i5tlSCCANws50N4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7204
X-OriginatorOrg: intel.com

Yan Zhao wrote:
> On Wed, Aug 27, 2025 at 07:36:46PM -0500, Ira Weiny wrote:
> > Sean Christopherson wrote:
> > > Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> > > doesn't support page migration in any capacity, i.e. there are no migrate
> > > callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> > > kvm_gmem_migrate_folio().
> > 
> > I like the fact this removes a poorly named function tdx_unpin() as well.
> > 
> > That said, concerning gmem tracking page reference, I have some questions.
> > In the TDX.PAGE.AUG path, [via kvm_gmem_get_pfn()] gmem takes a folio
> kvm_mmu_finish_page_fault() will decrease the folio refcount.

Thanks,
Ira

> 
> > reference whereas the TDX.PAGE.ADD path [via kvm_gmem_populate()] does not
> > take a folio reference.
> > 
> > Why are these paths different?
> > 

[snip]

