Return-Path: <kvm+bounces-42432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6057CA7865C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C4A4189185D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB553FBA7;
	Wed,  2 Apr 2025 02:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hg6ikaqX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDDD2E3385;
	Wed,  2 Apr 2025 02:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743560346; cv=fail; b=qvEbE7QAUdiXFB4oPn++awfJfSuVPsSb8eyVGtpI0YZb99ez0oRbgDQXnxdVK0ceVrLpdMqd9kmGbCzePYQD36SsU0aUZUxnPjegkOGf6c/DbozykSt9Y0wg9Oo/sWMykZlWCC0ut9nYOtbZZs+xYkgXQba2m2Fvm4ZqRm0rADo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743560346; c=relaxed/simple;
	bh=elbnTckNDray8A3Jfv6StByl83HOByC26lIEZGrDP10=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AhNVgiu5M4EDUUN5L3CROmn8/pt6h3tlmILFpyzHD6dEoVBPZfWzyVhNl1fG4MLC73wNlori54OMFWPdEANasKxFeTJFFQA9LQ+wpgsVFvA43ascjAWZ9tCuMhN9AshpdLgaluhuVWmiXvrYsUWwOtnMV4jKJEDTA0D2LPghFT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hg6ikaqX; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743560344; x=1775096344;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=elbnTckNDray8A3Jfv6StByl83HOByC26lIEZGrDP10=;
  b=hg6ikaqX4Cyort+98DwAonA2TPZKsK2UluHy4J3VcFwbIJvNH6MNPBkT
   wQKUUPW3VjBAAT0RiFRU3Dby8WzgLVHrkKMc7bjQ6M+wk1bc8kXxWbSo2
   8lcCRojrVY51GkyiaqaQ0N7XEPo0v4FcqWUADXTQ3qqI78iF3BqEm0A+Z
   nmo3BLvWcJ59u2EUFnZ9jHV22o5VaWGi89QSxK6EXtYROUq3myjJoga8q
   WJPB8AIDgdJ35L6Bl0lZIFfvAv7aUwdTxCWpOblfbbDhVBPX9VK3pHk5J
   Il2xNrlzB0kla+pqnVM9R8WKpmRDNW/ccqMZu5yUjXa+e+26+Cw917pw6
   w==;
X-CSE-ConnectionGUID: y0F6HSR8Sj+dGXaQKjcy/g==
X-CSE-MsgGUID: YVniVqVBROCTBntute3xIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="70268383"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="70268383"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:19:03 -0700
X-CSE-ConnectionGUID: LTnhTZf3S2mtFUEdwIHyZw==
X-CSE-MsgGUID: iJEs/7sVR7mlkPAfdodvPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="127027631"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 19:19:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 19:19:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 19:19:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 19:19:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo7h9Ftx3aZaPIeM8xCnQTUvO/x5ogQ6RoBwWrJuC5uMOMHCwL9R7gAGGVqz6WCzlir+JlMvrGhfDciQLCiae+HrEmZDTB32xODBO3K6QbIRPOnCf7iWZKxTO3pWMbkP9JEQcbd2PLh9iYozlHmxq2FUXuiobnKQLcb/LrHPo2Lh9SJ9zNWMZ2WytYd0hF7Z/PwMWR79tqd0HT2prCNcIdJ292yT4kymsJOaT0sfb66zaBvw6kcfEh/hPAveX/nyfwjBTixYWqRZ8m10uHdGP6aHRd4odz3csId6IxaA2PzhCEflDKPP9h8itchmyiaoSzZsA2XKP0PJ067AIoe19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDlc1Q6tJy6CeejJmC6vr/zIyza1IV2qHP4/yfZuR9Y=;
 b=e3GLqrKw1rIJMX9vms21WtJ0MV2CYuZCC+BCzQUkO9yAPpsCTavdsKDLmHfvan393SZSKYOw3AgxSR31kBH0XPWz6m5mGGT/4RejZBHQL4eW9mad8XJjOyApcsPX/5PMyiFX72u8vCGs3JdfrYV6KKGBeKLg8ObCMSQ9hUSrhEnlOezuFY6p0QpIvRlNZFYBYoREZFIZpVbQEDvr9T6wSOGy+NxBx+Ff0sRJj86gsZFwk62K0xQ7DCJt9zm7uqHyoDg2UanvaQnMZsX9HBjQDR4p+0AB3D84HZk/EyobQr/zocuY29t4FvaOQap2WmYnSfv4C7iyCTfknH1Ib0IGKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7421.namprd11.prod.outlook.com (2603:10b6:510:281::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.49; Wed, 2 Apr
 2025 02:18:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 02:18:59 +0000
Date: Wed, 2 Apr 2025 10:17:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: VMX: Assert that IRQs are disabled when putting
 vCPU on PI wakeup list
Message-ID: <Z+yeMYtvHvUGxMZZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250401154727.835231-1-seanjc@google.com>
 <20250401154727.835231-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250401154727.835231-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: f437fa10-0a3b-4851-4b94-08dd718cba5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DaQq7mDIKKOKFUMVNvBMSWQw5Z3dwbMd8FO4xGnStdEzNFngluQTDxkDKi9y?=
 =?us-ascii?Q?IIowqs43qMTcPL045jylXfcjXv3+RvhvS/HmxoZFGAuzqkcLNvEJT2INFHN0?=
 =?us-ascii?Q?kdKcn5g77XhGNmvP8HNTt7GVwZXNzGKCkP5QYuybhWT97F9yCMRHLm6kxpU5?=
 =?us-ascii?Q?ckyHdRXvqR61jfkRs9iZYrqGdungCt2uLFUk/X3HdppKOU06uvg1WMepEViG?=
 =?us-ascii?Q?LR309PJ775RxXjOdAZExpLq8u5/RM4GHBR9mmaa8bOTRRr1Ijvy/CkIilVW9?=
 =?us-ascii?Q?cuFI7i7OHRH4L3A9yzTbJeGfLLRx3Kcpoz3NtaBxCS1uLEfFmObaZq7Y/UHd?=
 =?us-ascii?Q?0T5/LKc3qkGmeDRe+Hcg6TBjSeGnJa4gN2JqbDzU13KiwnLKfCteKhq0x6Yq?=
 =?us-ascii?Q?XIkC0mNC0t1uTYJ0le2vG0ZCufb+9EfsxbyuG3sOyyL5TOjQPu25OE9dj+D+?=
 =?us-ascii?Q?+qUVx222Oy+0IjZu6IYA+Id3NPIkQ0nyoOQQcpbVsSLXLuIGkbPq/eiMJq9D?=
 =?us-ascii?Q?Z5UOPdsfJckFrSWw8RGWREbTGpDs/s03x0oksiWWOQ8Sl7h1HAfyjaUNhvAU?=
 =?us-ascii?Q?SiHApy0RFbrS5wVJpEn/MlKoSNOIMzmHFyIOmSAHs9vjdOE7GT0N4LxMl1fE?=
 =?us-ascii?Q?y2l5SwSD6zezNa2o+8bw9VeiLRxjoBIy6UUSKvbkuu4zbn+wcOjNR8j02GzM?=
 =?us-ascii?Q?HdJxVGy6FTn2WXswXJJP+Q9cnfSEYr/g/tTDMEU9H0Aus5xaIOxLaVObwsA9?=
 =?us-ascii?Q?G28/vKLKhjoyW/VSoxdXV5yqDcpT4juxQdhSJzXE29sFaC0NbCeUASQ+V4xC?=
 =?us-ascii?Q?WCU99ZNGssHVz8Bty2nw8b1mwxHtU+1y4a2TjbFo9AkSd3ZyGxbgTmHRRfCn?=
 =?us-ascii?Q?+mYAxID7JuugiUJBZ/fWo4eder4gH8K9ad6ZG88x1CHINrWqX2joUeHkP8sa?=
 =?us-ascii?Q?ICneFKoqdEAq/EblNXjzI+SdjrdOXIAx6AjckR70aeu4hsF4XKqWDAzs+Ws/?=
 =?us-ascii?Q?owZLNDurvGrI+Sk4QXdPYlsAjs9GZVSaJaOihC9ncgfbYxHwUhQ+hFo3ZhGM?=
 =?us-ascii?Q?8YO9fb9dt7SR2l62uSoNlMhJWAMC9/iDEjef16FdO7ZYVgoi9nqvJnwjUcPR?=
 =?us-ascii?Q?RnAFDWAY3WUFFoc41YI56bdjh99+LSAnCwXsByk58Def7TBFqO3o0GfbZkeT?=
 =?us-ascii?Q?9QwkhyIovLKtePBkJwI9/PgGsrmeplWdCx+uoqza9TXFczxs8VWCITWKvzsL?=
 =?us-ascii?Q?MAjXS5+8IIepsCVEIgIUD8/9wObAkDfPrc+mAfRGmnbysIyRaK/Bh1mqxQHG?=
 =?us-ascii?Q?mckEDX69FtiKQtCafc3p834Swtm/LwN+87wqdq9eXx7LkgcCl2LQlZ+Sh0CF?=
 =?us-ascii?Q?INzlT5MZngCBFPirR974/aGMXtyG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8jXYbw+l52ONoYVtd7Bup6T46DObTFnX1sTyooj9vIqtvOe8sMHggH3Us1bc?=
 =?us-ascii?Q?uu2SYuDFTwQfgpIVfqWGNCJ0xyHPmcKomB9vPMULESEL2Ny7QCKMXjGdYRBm?=
 =?us-ascii?Q?bAGHBP5jbiUsYqqrBuutqNGjnSk6g9wPMljDEdPIZkNdhrzdHj7s9u28SSOe?=
 =?us-ascii?Q?ycyUDcjqA0XbL5v0Byt8O+19INJkeqMVDB1ED8sVqiwMrVTwXxGuD6aqGaTk?=
 =?us-ascii?Q?SotrxunFsn0MQFaNmsNn+In6wY9E6TpBgMhvh6oiVJePJmQPsRngzVkE9zfQ?=
 =?us-ascii?Q?gC74AOYZho0jrY/Ri4Tdouznjn99ohjR/V8FCpE6Da3RpVKBWb3rvqpoMDQX?=
 =?us-ascii?Q?rY1oMbrrJ1CJuXo5tmF7XxIHWW9OyJhF8yDqULxxAwzPKB84IkXML6a21o5j?=
 =?us-ascii?Q?oGLpBxVIHaeC6H8DiZ0gqLuiSQrmNjjCMi5f7dN89fxtrp/eaDB75pEjcwaG?=
 =?us-ascii?Q?J3PluJnjb1zjB7IGlQF0TRKXxryj61btI4hq8fkF3bsqdHVPKboaUy3AcJ2t?=
 =?us-ascii?Q?zUb38x8ECnA9vyf1UBWfk0HX7ECkfz3jAaXxjdBFkMhRO8w7niYL/x4ujKuS?=
 =?us-ascii?Q?hYAhZkeTFHlqt8s94bd1iusy2CKP5wzHZoZS6WtprkTUE8SexSHVlH8eEJjC?=
 =?us-ascii?Q?lUSd9nzfR1Y5zAie3IyGUSAcZIq1kvB/U6OEVaWpblS7AbJHAtddxvscMdCN?=
 =?us-ascii?Q?vOsU3+L9ODFm811JmUEiWfcBdMOYM2mYk5l19KAI0FtwHhgOaAqLgfqpKpx8?=
 =?us-ascii?Q?0PcBTpqiTNu/1JeGlB6nhEcDiLM6egYlnODruvksIakrwxU4xG/jjzuIqCUf?=
 =?us-ascii?Q?NGwusgu3rgx/f/lrcDfWufMkhD+Mzl+Ku2YHVSvju22V16DhWsMcwZoFwwBp?=
 =?us-ascii?Q?UngeQ6N9Xx4x7BiTlPhCr7gDF6hMn19JkLv4UVdEVj/PmX38rUl/QfZ/7nKd?=
 =?us-ascii?Q?a1UEIFXiF4DkL04pczWPcItQgohgzZwjIn+UKBGvc06cz+1/udO0dfxeLV7a?=
 =?us-ascii?Q?msM5G2SVHODVyhAv2wxEeH2WPZXYNy/eXdb5sqIPMtl+Q/WEsFHKExTejHzi?=
 =?us-ascii?Q?Dt84hq30SHzVFYmg9wzpsOcPOUq+S4VWWZowEStfPnPx7OUD1k/Mch1tBYG/?=
 =?us-ascii?Q?MEdNrsW+gjbs41VEiFpF/yv80ViBTP8wnUGH6YJZaiGxklvyIlVLe7nh1+Qq?=
 =?us-ascii?Q?9i0geeXU0BNMaJdTLALJald6v9j1gYFiY+OSElupol4+s30h5gN6R0gyrU0t?=
 =?us-ascii?Q?QMIM1TVCzVjL6bkafroeuw/VAtjGNe2VnNq8uBhbLfmApddZToWz+sGic3eB?=
 =?us-ascii?Q?3hdQtMjWV5JAPsHVZkkjCueJmWztmYRmpq8b2WyjW4u4E1UFDTBPDq7QeRlW?=
 =?us-ascii?Q?Y1hpYTI+iUK7ZwEku5S9QFX+ZN59y224+xmVxTSoPYB6R8zx9x6+SbBo/xx6?=
 =?us-ascii?Q?021WV9GJH4eEn7WiSZCpEVB6am6Pivac2RC8R+/8IxPDM93urTCNusOm0uQA?=
 =?us-ascii?Q?dBwNR7ASCLmkY7grliEKBAYshWDIUnKimRO1Sp1QNpysacm2Z92fvFkv176R?=
 =?us-ascii?Q?C3UTlfcDrGcsUn/ljfOzT9DQ0TehFk8lSMf1JAFx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f437fa10-0a3b-4851-4b94-08dd718cba5b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 02:18:59.3370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVcgpmeyJVBgo8w1sZr9G7l0DhW+ApnRO+n+4jnzuJ+av/tx62g9KlffEhY+GdZAm51Au+PBu+IhabCB6MbflQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7421
X-OriginatorOrg: intel.com

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Tue, Apr 01, 2025 at 08:47:26AM -0700, Sean Christopherson wrote:
> Assert that IRQs are already disabled when putting a vCPU on a CPU's PI
> wakeup list, as opposed to saving/disabling+restoring IRQs.  KVM relies on
> IRQs being disabled until the vCPU task is fully scheduled out, i.e. until
> the scheduler has dropped all of its per-CPU locks (e.g. for the runqueue),
> as attempting to wake the task while it's being scheduled out could lead
> to deadlock.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..840d435229a8 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -148,9 +148,8 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct pi_desc old, new;
> -	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	lockdep_assert_irqs_disabled();
>  
>  	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>  	list_add_tail(&vmx->pi_wakeup_list,
> @@ -176,8 +175,6 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	 */
>  	if (pi_test_on(&new))
>  		__apic_send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
> -
> -	local_irq_restore(flags);
>  }
>  
>  static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
> -- 
> 2.49.0.472.ge94155a9ec-goog
> 

