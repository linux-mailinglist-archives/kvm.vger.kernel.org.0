Return-Path: <kvm+bounces-61939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 367C7C2F1B7
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 04:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6D6D64F4691
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 03:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C873262FCB;
	Tue,  4 Nov 2025 03:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RpxdSNVs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC226CE1E;
	Tue,  4 Nov 2025 03:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762225851; cv=fail; b=kDT29IR1Rx7Kq81GnUMI/p7P+mcuSh/I2yv4xKryZASG9Tn0y259UqxrGf6HkLLPRdNQqiSMOXKGkykVZk6THgXKRhuf+BGyUUOmCJ5+oua8zV8pd3W4q3eqcbSvZydyPmla3WcR5GMgivArxcVusFCAPxL7vKT6OK/WoDX0sO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762225851; c=relaxed/simple;
	bh=PvufbbPH2XKmr2q0VkVFbMFmPAZhH14BXchfEENLWts=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yl5bq1IvDEI44iHDn2uy6Ctqo2nqvtT0P8a8uZUsgYEVTVFwe9IxgrtkBCFfaqDWyDtVNV3CFkTnofFeFrqKF6YnTriBCvjjAVRLV2yHc17inaguXyYO4ybPAYQXgv7WG81JsmaqcbfwhzKwmfL//LDXuxorishblnHI4Wr+EaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RpxdSNVs; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762225850; x=1793761850;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PvufbbPH2XKmr2q0VkVFbMFmPAZhH14BXchfEENLWts=;
  b=RpxdSNVs2t7qiBFAFFc3SIZ6wz7JCw6qUQc4XGjZD/JFsl0d7LoBUxCr
   R9HnCtMYNdb6nHmXnf11OM9K5hEfW9UIEuMYNBHiTQYFr25NsMNpLHSeh
   LWVJB9t0tbJ22vH+4niJD/ifzbbd8mKL+CgaqQ4xvb2WkJIDmq4TCwFU3
   rosCO9LDEqq3WvcHyZf1AXxgXRMoEPHgn4TNTTMqCDPv/Bq9PIrElvB4l
   IZeoQoQ9W82ZUZgyEkTnf8jzEf8ZnunrlPr1Gw7ibg2QpVZaZvW5S5bdG
   +0EfqRp0xuS+i1Hppi0Eq/+ZCfBLxVQG2AAlazDbnoVdqUw+xRRqeeriL
   w==;
X-CSE-ConnectionGUID: HOTMrXhrSJCTy8Ddocg/bQ==
X-CSE-MsgGUID: C5och1IUSwSD+9yv7Mogmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74604457"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="74604457"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 19:10:49 -0800
X-CSE-ConnectionGUID: Fc21S3xSS3OKn8swhnf2ZA==
X-CSE-MsgGUID: qgC3X8tHRTmkDEo5WvCMdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="217677629"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 19:10:49 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 19:10:48 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 19:10:48 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.69) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 19:10:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEiVFUqo3TEFYTH7e0b1flYfG8NP4lZkqUvR8t8Te7Sl8kAb4ZG07FU+qhMEftIKaPoLXhsLt5ET1OgIFhhFZizGPYqcPAD9HjiBz2mU4puVmQg6LJAW5dK6xDGjxVqK/TmErs5RItk6ayW47RLpAz8Cxa8F1is52mOL+GEtW+sC4Uu8D8BUlPfxoC6nqSz/xB2ry+PNNeCi+zUu0ekxk8Q2fz3o+cilPZsMBrqiJ6xB72c+x07hFIqtkti+zxX6aQtOJZ3eAqsJn4LzJGP8DL/WLXfpXl/oX9QvuPPXfLKjdMBNu7aBeqEi1P53bRh0DiWvlvZGEt01bRdixOedaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5vIQwQqrH6nNwb2hUHc5ylauXSh29LVVumsi2MTWe8=;
 b=uPD3Xw06hrrR0fCY6xTDRn9UAEJA6G+NQSd5NdtX2rdnPREKlsLIrXqrRCXcVEBzv/xlDWXAHjdfPv5CT/PvRGnq2O3cMuP7tGPjT3vN7iPaQkee699aX6uDDAqLdkre39BroSX56FS/0zvLnlvaRR3VTtepiXuxh9tybbdr4JWa3erNDictjHX+t7TotJNiAHBjL19jpqIJ5C0+lVcCUS92dF4OyzuAnuzwTmP4IcaJABZtWQg8NNuMIozmZ9xwQ70H+XyPEJS3k3qtLdMVCeY38B1+t1qR26kbycbsBlPHCUHcR9V3tI/tZNQtRMmrNTWQkG5Ft2gVXcoi5MRQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8562.namprd11.prod.outlook.com (2603:10b6:610:1b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 03:10:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 03:10:41 +0000
Date: Tue, 4 Nov 2025 11:10:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Unload "FPU" state on INIT if and only if
 its currently in-use
Message-ID: <aQluqPBXclFHxWFD@intel.com>
References: <20251030185802.3375059-1-seanjc@google.com>
 <20251030185802.3375059-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030185802.3375059-2-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 22455868-a9b5-4068-6fd2-08de1b4fbc78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ttc7eC1CvLXSe2lBKCL5u8oZ2ZmgT/nc6NRD5sVsHsQasKyu0EU3+9sbNzV0?=
 =?us-ascii?Q?5ea8KD7I0UrgbgWkuxFmDR4M6Cm5O4ZdbAiGPx3kKUOtJt7C/tlW2DTSEgi8?=
 =?us-ascii?Q?GG4iYGkhmRYO0vww5UgbH22ALeipg4Pyk3g0UvN1uCwBbPdh5qp75ew2XMac?=
 =?us-ascii?Q?oN173eBXJM799p8GD5xMKEvvZK8eSdfV0RTvHWWvszKD/Yr3NRMBIaB+2qVM?=
 =?us-ascii?Q?FiUGlPPCvH5/tMempeilFpvZDQUQa26ta6OSJNLKBoDgYhEUpRNkoczSepQ8?=
 =?us-ascii?Q?DCytwnbl6heRBZoK3JAXSBxEHoyMzPSCKzJKeetXGk82NDlN/H+bF6S+dM0y?=
 =?us-ascii?Q?m/SSuOTW/upsFML04zGbU5/zTYYpO5/OcksRtzZjVfAKk4sN5P+ynzja4exX?=
 =?us-ascii?Q?ZWMojb/J7Q547LE7rGKUm1soCcpW/3Wr1E1WObhw3uPKfFRD0nf4VzelDOlO?=
 =?us-ascii?Q?bgRbYYIkq+wikI+5nMxrvnfkbopKu5vDNyrkvneGMBa8hPJHoBSiPyEyiEKk?=
 =?us-ascii?Q?ngYg7hNvfuH+FFoimlwJ5+IbAuE8QknfU22BMUHE01NsNSikf+ri0uDbysAf?=
 =?us-ascii?Q?S6AsIziltTiOhWpG7FhMhSOYN+gC16wZGrOM82EfTiiYgcTQGC8hEECFHhCb?=
 =?us-ascii?Q?Dj/RqFZmDiUeVnOxMb2vObQdVX+HpCDTDBUBe5Kr9sknMGoZPtsFB+CVrlz6?=
 =?us-ascii?Q?ilo9va7Uuqc9kq9LU5xAJHs/MZg+ohkfGqlSaZC47FgYi/5Q+ph9fHe1nmCE?=
 =?us-ascii?Q?q5gwPmCuaBf4kKgCbSXfG1PwmfB0dGJ61g+qTh9M7KrYwh6IzzlaE7Ysu09t?=
 =?us-ascii?Q?9gJlipGUYbKcjZh/17YzSUWUw9WeJ5P4EY0zQlNlMMO5PcIyH/AB2cjgdq8j?=
 =?us-ascii?Q?WwXt//Yyqpv/L7TL9FsvhK/0HXxmqqHwpRk9lC+9zObjAUAnxARQtbitKMmM?=
 =?us-ascii?Q?o5QeHNmEXFYrVEGzhZGPR7YXW509iUdqqogVDDJGTL8S3AJ1Dr1trKZJVFJT?=
 =?us-ascii?Q?T1jOHM77tEFlVM+ymfLrJl/Dnl9W5pHzHtXXjqomQbvZXDfm2nQOnkGjA74P?=
 =?us-ascii?Q?bRyCjqJ+nLebIf1iFdGF34BJw2SWFvsbX9Kpfm0JgtNMZTFy4CLqdsP5/swK?=
 =?us-ascii?Q?S8pV5Rz3kCzGAdi8LQYjA+G0q1jdc6xrq1LOLmeIJ4xuDP66x5CyvPwPPz1u?=
 =?us-ascii?Q?qcdIzMiGqHzwj+rrB5wjM5gUtKibLKDGguKaTm0Qhpdjfb5n8jzpaEfwVHgm?=
 =?us-ascii?Q?S1UeUAAAV6AOxkXaTlVXyW8Gn5jz9MpnA8+gxufaLUiRaWraMWeM5U0NG6dR?=
 =?us-ascii?Q?eMEmev7bd8ID8osoQTGlDhKiqlDKEvi8FsHc6gLyqggH/a4k5DqG/CBMIbn1?=
 =?us-ascii?Q?dWEcMg7RA7Q2jt3iC3XsFSB4XirBG7aNQPt675YtzBzSsL1a4nLC+4HEq0kQ?=
 =?us-ascii?Q?6ZklWZQJ9ZQe3LYvN58JwACaST1WlOhT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JCj1khrW2PKCEE7+GPHvS0ycbuAwhOypiivHTjBZqQY2gOoF/8xos7ne8E08?=
 =?us-ascii?Q?LTADVDK1UtctrtrTLAhcegYQChR3tKXcjDD/2y+f/DsBi4+f1jytYLZ19sHU?=
 =?us-ascii?Q?M3B12v/9+lCKkP/2Nfjza2V+7BYKn0FsGpn/AttETwCM+ilTx9u/cbyV70uI?=
 =?us-ascii?Q?rntggYaRl0lfwBJV1Wx7izzAF3aPTe3lAOkxHIGKFFnulS4ZyFx67+FsIwE/?=
 =?us-ascii?Q?5YthsidSG9ISX7YeLMQjjA44x5xdD5tQYPu2QDnX+msLrHBdnejBO9UOD+vC?=
 =?us-ascii?Q?YbnpTbAQGpO1xlb0yeSNBox+isBDWdfjEHYW0o+UUeiKlhC+BIwO0MWcjj5z?=
 =?us-ascii?Q?3MoqpH8j+NnXXE8wKlk8nIslycZyCNYZj+p2Qm3LUMu5qj0SJ7WjZCptc3H3?=
 =?us-ascii?Q?60KbfkqogjVcYvbdMhIQUeMIM8D1qq7XisCz8s4Zrvav8McH25BrFG8UmAYO?=
 =?us-ascii?Q?Ui6vdQoFx9Daz5b0vPmgw4BhBUbCr9spzT8iks8Gu3LIw+qKl+XeQu7RAAtP?=
 =?us-ascii?Q?5AuD7BhfPe1ixesolmvN/I1NQVAAjvMqJJu9Qbxiznh92L0S8kdrPyQHe2eU?=
 =?us-ascii?Q?K3u8/FQQ5dDqIxMxSON9v10777IqGiKpxqlHiNFskalrIqBr/B/7sXjTsRk4?=
 =?us-ascii?Q?j1fGy1awLFwMi5WX5vlvf6sO76gImcSuRODdaolkYIcPtp5Fs9vMmL0al0Yw?=
 =?us-ascii?Q?JXWNcc4uPJTPfz3YEG2GyYYMXsLL6mp/yi2DKoMm0qQaFfdUigpQ1dC0Fz9W?=
 =?us-ascii?Q?ytCYJnJlVAH8Zz+qIndawZoOnbFFUFiBr8xHIyshlPlF+7qAAlsFiRFJVl6F?=
 =?us-ascii?Q?tJFsjcXyMxC/SQOL4cH3KKUc9TaM6kZezonVvuGpITk9B+C91N+zmhE8R5Mn?=
 =?us-ascii?Q?TQse1ejU1ky+TS1KCsJpQbau24WvJ2tXbmj6m7xXX6u4ftOb/D7DPBBaxQ0N?=
 =?us-ascii?Q?R5q5Hec+7b/Wqc7Ij3eC0z+ZQ5CUL5Z5P7XwvO4f9kVCJ+5znHDEtgnUaWLX?=
 =?us-ascii?Q?iklDqOnXBdOaSGoHa/OvYyMnQZEFbkkKtr2/kD3EoC95LWjzoM6YAJTRPkH8?=
 =?us-ascii?Q?inhut8oyn5sm5Y6PtYz6u7mq3OeVcIrguohcWxLCF/lZcKtiWDidAe/xadS0?=
 =?us-ascii?Q?iRd6lj3cgFBSlf9jIY8kc5LnGIm5KsHE2WzlWk2VZdd/U2H4ybHuHFSPVAG5?=
 =?us-ascii?Q?dNB0FPgQDnYEiRn3nQm/uWA13NntfpNnXRyx7UMiMzt5hrBUj29COM5H3uS8?=
 =?us-ascii?Q?PhlAK5a/S+mOINragVTDLRH7KytV7Z4R7K761KB3jfFAXqGfIUPBZEkDmfPn?=
 =?us-ascii?Q?kxaGFCPtm6K9josndqUuIvFyOhzXxY4zbXYc2DLL/KxrSOqXqvyOsBKpX0lx?=
 =?us-ascii?Q?uoZhuNn45R4QTd2xvJimkxtJQV1pzIQHMckymnXJD585+sER0awMkd681Rsj?=
 =?us-ascii?Q?7fXwWalUKoT+N5bsdE0qhLueokPYIngeWZlEv7MvTugDFgOTOKsUSlBsgqku?=
 =?us-ascii?Q?40Yzh+H5C7/cpibsktil9rLQjWHoxx1uVV7MlQecxzTJYpg4YOiEuEWqF1TF?=
 =?us-ascii?Q?iY0L53c993EkAFoYo6VpEyjpWgCKbuokM+BhmG+Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22455868-a9b5-4068-6fd2-08de1b4fbc78
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 03:10:41.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/fMC8/iNylix4JEm8GeS1c6bxU6Dxop0ru4SZZzCI8g3cUGYj8pGNOTj49wjI8WKOk7O2gDKSDs4jcy8N8N7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8562
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 11:58:01AM -0700, Sean Christopherson wrote:
>Replace the hack added by commit f958bd2314d1 ("KVM: x86: Fix potential
>put_fpu() w/o load_fpu() on MPX platform") with a more robust approach of
>unloading+reloading guest FPU state based on whether or not the vCPU's FPU
>is currently in-use, i.e. currently loaded.  This fixes a bug on hosts
>that support CET but not MPX, where kvm_arch_vcpu_ioctl_get_mpstate()
>neglects to load FPU state (it only checks for MPX support) and leads to
>KVM attempting to put FPU state due to kvm_apic_accept_events() triggering
>INIT emulation.  E.g. on a host with CET but not MPX, syzkaller+KASAN
>generates:
>
>  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
>  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
>  CPU: 211 UID: 0 PID: 20451 Comm: syz.9.26 Tainted: G S                  6.18.0-smp-DEV #7 NONE
>  Tainted: [S]=CPU_OUT_OF_SPEC
>  Hardware name: Google Izumi/izumi, BIOS 0.20250729.1-0 07/29/2025
>  RIP: 0010:fpu_swap_kvm_fpstate+0x3ce/0x610 ../arch/x86/kernel/fpu/core.c:377
>  RSP: 0018:ff1100410c167cc0 EFLAGS: 00010202
>  RAX: 0000000000000004 RBX: 0000000000000020 RCX: 00000000000001aa
>  RDX: 00000000000001ab RSI: ffffffff817bb960 RDI: 0000000022600000
>  RBP: dffffc0000000000 R08: ff110040d23c8007 R09: 1fe220081a479000
>  R10: dffffc0000000000 R11: ffe21c081a479001 R12: ff110040d23c8d98
>  R13: 00000000fffdc578 R14: 0000000000000000 R15: ff110040d23c8d90
>  FS:  00007f86dd1876c0(0000) GS:ff11007fc969b000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f86dd186fa8 CR3: 00000040d1dfa003 CR4: 0000000000f73ef0
>  PKRU: 80000000
>  Call Trace:
>   <TASK>
>   kvm_vcpu_reset+0x80d/0x12c0 ../arch/x86/kvm/x86.c:11818
>   kvm_apic_accept_events+0x1cb/0x500 ../arch/x86/kvm/lapic.c:3489
>   kvm_arch_vcpu_ioctl_get_mpstate+0xd0/0x4e0 ../arch/x86/kvm/x86.c:12145
>   kvm_vcpu_ioctl+0x5e2/0xed0 ../virt/kvm/kvm_main.c:4539
>   __se_sys_ioctl+0x11d/0x1b0 ../fs/ioctl.c:51
>   do_syscall_x64 ../arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x6e/0x940 ../arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  RIP: 0033:0x7f86de71d9c9
>   </TASK>
>
>with a very simple reproducer:
>
>  r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x80b00, 0x0)
>  r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
>  ioctl$KVM_CREATE_IRQCHIP(r1, 0xae60)
>  r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
>  ioctl$KVM_SET_IRQCHIP(r1, 0x8208ae63, ...)
>  ioctl$KVM_GET_MP_STATE(r2, 0x8004ae98, &(0x7f00000000c0))
>
>Alternatively, the MPX hack in GET_MP_STATE could be extended to cover CET,
>but from a "don't break existing functionality" perspective, that isn't any
>less risky than peeking at the state of in_use, and it's far less robust
>for a long term solution (as evidenced by this bug).
>
>Reported-by: Alexander Potapenko <glider@google.com>
>Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

