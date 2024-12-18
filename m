Return-Path: <kvm+bounces-34028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 303699F5D6F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 04:26:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9082B7A3FF0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 03:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE5214AD38;
	Wed, 18 Dec 2024 03:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DHDXOJTD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F214A62A;
	Wed, 18 Dec 2024 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734492271; cv=fail; b=Lmqf2wQPWLrcZgbhUtgfi+LDgCYg/d9qhgpHHmXRvwQkOQfXNbp0xcJmltYJhxVZJIUtIgoxauAJf5Dn2duSDBLwcWYYu+Ppih3m4oD4GZScXkCjernOcvXAjksIfNSH87D3uPR+s/IwZ5F1STBoWukm8Z9LYGZ6W3tx+J9793A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734492271; c=relaxed/simple;
	bh=AcUuuYaindvJ8hceDcHUGa+P1zrYZsEvQ2xG78rYnf4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RN0jnU3xYaZf6QJUDVZB6aN22V9V3hqd8z/aG8ibZmvpSzdvX21McsDN1zxaj4myc0BBsqUy7YGv+Wkn3jJA880ovBhy8tBhnpo1sclM/EcanCQDPkf0hJxglu0o0A8yvYpzh5yef49r5nT+mLGHbXDujJFso5KJd++CE+okX9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DHDXOJTD; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734492268; x=1766028268;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=AcUuuYaindvJ8hceDcHUGa+P1zrYZsEvQ2xG78rYnf4=;
  b=DHDXOJTD09hZYLtdlR/xgzCUC+n6FIooFypIb5oCTv1O56CPpPRNDet8
   XofdsX2OEutJYFrS5iwft1wuJVcWkeEF02h1wo0IkZe0i7kSrZzSsLVDK
   mEosxIxg0ifCzsAajsH/7B9j3M1NKZme26ZjSJG0yoJw91E0XvWmzuhO+
   9+JRCkPPhdKu9reI3koDSFptFvJ1eN/IuwyuC70SAMfzCh/t8Zn9TY4ha
   2VE2As5wjX294mzI3swp2nXeL4gg6l38KkEdN3SpW7Al/KXHWpFff98gc
   PGDEU2/Di/sxsSWofMZUpgNbjrmzVkM/UuUS3m459wjEw8wXRNh+h3rA1
   Q==;
X-CSE-ConnectionGUID: ZtPLXqvKRSCg8IWOpK2WbA==
X-CSE-MsgGUID: yN1Lbcf7R/eK3hbD3LHjvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="38889381"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="38889381"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 19:24:27 -0800
X-CSE-ConnectionGUID: V6Vy0GPaT3GqnrJSo3ZLvQ==
X-CSE-MsgGUID: r3/9nZI4SjO+1wiIE/6l/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,243,1728975600"; 
   d="scan'208";a="128540049"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 19:24:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 19:24:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 19:24:27 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 19:24:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERKMwUTpF5irwQZzkJwCk3hC+6nZeMDF/244aDZXKVGFboA3ylyfXsPJxGSCRD4KcSQkELpHGfmNs8gmx2teTb/d+fIW6kYDNEn+p/faK6lpObgtdqSJsgNlkajSZxlehxy3E4XBzmkucYpwddfC+G8uQvbOvvGJZBocFLd97QIRNb89Syxy6MiLtHA0tx2mNQpitEMmXESImDLf7/jRAhbflH19DAW03sviMdsfFX0ml4GVZVY59wX9Bj0joC23jrMDB1pEFyFB9QT7f3uaR6jGQEtKiko7+w3oHhF46EtrluyPFOfNdTgHx8vR+tEGe8sitJjdK0CnyqWIJmJVcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1MSRFb2sAwsxJrAL+nFahtWq5O1mVxkQZyxFs97j4U=;
 b=kdNRE5mWuuvo1IseGvjQ5VgXAAqgCgerBCNLW8XGtZJCU4NVQtGMeFVXJwNmE5p3hUo1O1umoIdg/uwx5HmuI4TWeyhj1rO4H6axjUOHqu+BW80MtvJolOeUdYLyP1nEtfmAeg8FH/iOwbKoWZIGhisGifspl6UEteFbVVBId1XFc2U4yNoiYU/IHSuF+9eWVF0RvKYWS33tFEiBdZV65k9WTiOBm9CKsEN/FiVj0DWYfE3lm4TkEFP73NrWqKBC0f3Vd6okTWtuMV2zGnazvoKm/3BubP+CIfwQeit0UfZDRF/mzh6k5xz/Zph1jcBFaUqc9JceeuWJZ0j+wqB+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7576.namprd11.prod.outlook.com (2603:10b6:a03:4c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Wed, 18 Dec
 2024 03:23:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 03:23:58 +0000
Date: Wed, 18 Dec 2024 10:49:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <binbin.wu@linux.intel.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 17/18] KVM: x86/tdp_mmu: Don't zap valid mirror roots in
 kvm_tdp_mmu_zap_all()
Message-ID: <Z2I4Q7qml4K0zpwZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
 <20241213195711.316050-18-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241213195711.316050-18-pbonzini@redhat.com>
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: 13e08cd1-47ab-4366-3bdf-08dd1f1368f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OBlTOTKqPqMq1hXEzYdHmPn6XDx/Z0KlaXvORh0r4Sg7osLbf+8SaEC0ivMa?=
 =?us-ascii?Q?zhj+h1BsvtmfmLMqn2jecYq7Y4EdSo4LNtzqqpetqGXjrCKdYggxne+fXiyh?=
 =?us-ascii?Q?nw4G1ugV1xT4eACUL+VtomryrvnHqgRDQ9JEVf7UboyLPQrFsD72myjgZImA?=
 =?us-ascii?Q?WnIgDFXvwCoBNHwhUcFIPnMSQoEkybrvKPg1pVYobZjd42Js0qHeJD86MF1n?=
 =?us-ascii?Q?MWUvb/TXpAz/5U26pygMPirx3TpWFx9knfZGVUafnG04EIB9A/eh6Bp7sHRk?=
 =?us-ascii?Q?gFCgYZqGm32VSh9zkUKKI+l3a9ikHxP4lklu6Big1xY5Ua1FoXsaCZ1ouzbW?=
 =?us-ascii?Q?6yyYuenULsA/4B3I5IDE/9X8WOCwryGBXwjFa14lRMxxezWD2vxrYBQ/iW1j?=
 =?us-ascii?Q?8zKqH2uhX5UYm0nkKf5S/xErn3k+V82D3+Y66AIjCwGh+NNtd2ayuEBvCwIi?=
 =?us-ascii?Q?6MljzRCSas5pCQfEiecQFEjFlU0paAG97gM9gk7xtt98bOV1vWCwbWBX6tva?=
 =?us-ascii?Q?a2naawdDuYqSKhUWWqQEPSzOeJ+QvLgHZTn6Uz+yR1hI2AhBKpG8BlnLSA9F?=
 =?us-ascii?Q?A4RsArdBgWq7UCYUJLUBTMOAM2nz+z6oUxn9s82zquWYF1uliXCsx2TUxeTL?=
 =?us-ascii?Q?U2biCyAZqfLgS4SYkP/yxBO+Llit4Lg6mhyMiDjsclVXZJJk921ZtqTt2FCQ?=
 =?us-ascii?Q?ogay2BWYF6Cm+6MOYLlQ/ehGb+CkHX15UUjC3podtgZuo2dFStDEt2+9171W?=
 =?us-ascii?Q?OsaKZCeUdKmGY0TMGkn8W1wgjiTfdzvSxW5kq60jfsFBRebtZCrNX43R061Y?=
 =?us-ascii?Q?UHDT02maUwBed9+3SOwAZsYAqMF4bqRnqtYr89sPbWwyNCYKQQOZAWk7+yfO?=
 =?us-ascii?Q?+7itejh4rA8hiW7DcMj1cXbVWJ/6Ea4+qIe2EdPLDRKY/bE/PS/abo30ZoKX?=
 =?us-ascii?Q?H8wqcNj80TG9AklM1u4Zr6kEA0iQdHZ9RStM3+9FJBSm8FXAKN8mS2b5fBeR?=
 =?us-ascii?Q?PQPWr1Yx0aUAVUbDkZSnO/SumjwjgBSiwcRmjGOz4GcPY8drDEYTJAwF/z94?=
 =?us-ascii?Q?GJgs0mkQ4zLRdpTqbnIDf+V4kYvJy9vVZYz37OPPTxwWkiZdLMYwkytCRtuG?=
 =?us-ascii?Q?xN00M8uTO9yzetgC2so6RWduops0VZpX4F4FvVY0o/pwZGlvXmJjDu8zstlT?=
 =?us-ascii?Q?sQ8DMKu7+UfvOxQZAYUkiz14h964g83W/WFeBt5No4fIHZoauitT+jELRSKL?=
 =?us-ascii?Q?4sFJrP2RWAo35waUfYnLjRkVDLt3tXegawgc1MyCoLC4efPms0x3zTtuuXl/?=
 =?us-ascii?Q?9Dh7ZrY3ZpMIhJLdPsBA6+sZVmO5r23ti/3PQEAF+hWygXF0PeSyxiNi2CzB?=
 =?us-ascii?Q?C3nMHSg5IM8MADZAk4MnOucrO26j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y61jK/Aci+9BuLjsZOrSApF6emHMmLjPrCaOFXroHhMaY2MQblKNyjJibAHE?=
 =?us-ascii?Q?eDpGGDYQsYlxRj+MDGfxShsyu5MZJn98bIzOJqFxrn5/s54okdoZL7BpWeYn?=
 =?us-ascii?Q?ofpnRWiG1GnhXfl9+lytePTS+2HwLVdWodSqAbRyTIkb+l3fG8cfONCkyKuY?=
 =?us-ascii?Q?UAfDueMahT9SNi0IYSJiAx8LdyRxqXMUQuR0cd9AXCbdn3tDOIFfgXuFP311?=
 =?us-ascii?Q?4cXjh4Im8Q23t5wIiDfTdnv1hubEgpRRtd9CguuD18shKPmiBh6YOrKgADAU?=
 =?us-ascii?Q?PlRXz3glWnAcuULGOOJKcAsPVdGEkm9pV/flq3PqOOfWDmbh/Aav8y4XhMrU?=
 =?us-ascii?Q?GGnBXCLX0QmJF5ks+aAJ57BdQ6I5MYmvvSxGwHImn6OCH7lGViyDjdC64S86?=
 =?us-ascii?Q?yWtZ3IZTrPXlvpPKUaWq2xeCh2bAGm39LvsTCWf67X/2r8lW0Poe15V/zpFg?=
 =?us-ascii?Q?A2hW2uK0kQttfIb6JjNR1aQeDk3Tx3pmQBF0pfkDkaTkftHm0G3dQcdNwISz?=
 =?us-ascii?Q?fCpjNrI+AA0t8EX5bOBN5gDgEDPMTzqETpyjU8pacAhigbj7wfPG/Nr2FfzR?=
 =?us-ascii?Q?fR2fhZSNoyhokjwx0euTndPq6h8TaXts6gHiqQn5VWinz9PZj4Wub5SnbDh0?=
 =?us-ascii?Q?ADtBJCXJUTynIQAd0X5c99CtEsT91+6dMn+rUdCkbZG5FR+GtSowyxSgTKUg?=
 =?us-ascii?Q?cltZx35wObSC4kmyumJyg8LbzrZnLBZ1X4I6nP4gHQaPgxDKrBL5xR54+ncW?=
 =?us-ascii?Q?wsJZIW4ukT7gX4CtIDu1CmT/vKI0SnRmKBoREcs+b8XJSPXbviyyLBzDiEe4?=
 =?us-ascii?Q?NADVAxdwN6ceiqYuMVm9I1tI6TdMVoP5xFeXOWuF6v0ZqIuBBbA2Pjq2V33V?=
 =?us-ascii?Q?OOOBF+KgemwDLprOjhxEAXvBKR7mKYuGc24MCmdGWd7/iGomICuYdl2RZRRK?=
 =?us-ascii?Q?HIs4C1lTcPzq/J/MfCribvlMn323K3pROmLpHMzmxe/tRGLztxMDQL4Vg9uX?=
 =?us-ascii?Q?CPN23fU+9E5kxoIHLQIgKCopNeOsgPuTHQ3OKAbTPL+LXYN3wUHvozkmKxlp?=
 =?us-ascii?Q?yK5pfV3BkCyk+D+LO0/6vbuK8/hInJXBpR29df4YSjRmpEvsv0Ym3JZfpLMJ?=
 =?us-ascii?Q?8tMYUz64TImH8dWcWl/yAdHh7o0In1qbs0zZqkI6T/X3KU7NnGZYO62RisMX?=
 =?us-ascii?Q?5CsOpPCHH9gRE0aGnTx2vtOpVN3Sfc7QitRkzLfmL32qWNVLFEJH5Y1OaBCd?=
 =?us-ascii?Q?dbLJ3I1uxIrwDF7DOV8qSazbgZsXWdeGuPa4iBVXwY5vNkJke5HkxUJyC257?=
 =?us-ascii?Q?+++Rnrrz1PjGpCFMyIcc1ZW9MXk/6NNWXh2DcsyqD4REeQIyOCZaEpk0UhsP?=
 =?us-ascii?Q?xtZt4VbV/nLMoUUNRsNfvRFXurwN+LipC9GrkjLUzOmc+ixaTRYBz5XK+dEt?=
 =?us-ascii?Q?/E4kFlfHNNcpdplWIn6eJNOkA2YN2jU6Q2IRwvlrgGRFr18z264j6J1H84Lp?=
 =?us-ascii?Q?aojt8NVUeMVDkb65nzRP2y1dbrKbo/s1YHPYdx3xrO82u4w4rkJKmAv0iD6/?=
 =?us-ascii?Q?mT/Rz+/l6M3VzBIktWUZVaY82a4VKj1VWCz9AhAl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e08cd1-47ab-4366-3bdf-08dd1f1368f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 03:23:58.3773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16MF9ehTw9hg39b9V71MLP0gl9aIjFkTKiPXhn+LHjhCQUiQmKVaiLEGFzWquhObzjD3hXlEb/B+IrLlmMcZMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7576
X-OriginatorOrg: intel.com

On Fri, Dec 13, 2024 at 02:57:10PM -0500, Paolo Bonzini wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> Don't zap valid mirror roots in kvm_tdp_mmu_zap_all(), which in effect
> is only direct roots (invalid and valid).
> 
> For TDX, kvm_tdp_mmu_zap_all() is only called during MMU notifier
> release. Since, mirrored EPT comes from guest mem, it will never be
> mapped to userspace, and won't apply. But in addition to be unnecessary,
> mirrored EPT is cleaned up in a special way during VM destruction.
> 
> Pass the KVM_INVALID_ROOTS bit into __for_each_tdp_mmu_root_yield_safe()
> as well, to clean up invalid direct roots, as is the current behavior.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <20240718211230.1492011-18-rick.p.edgecombe@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 94c464ce1d12..e08c60834d0c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -999,19 +999,23 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  	struct kvm_mmu_page *root;
>  
>  	/*
> -	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
> -	 * before returning to the caller.  Zap directly even if the root is
> -	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
> -	 * all that expensive and mmu_lock is already held, which means the
> -	 * worker has yielded, i.e. flushing the work instead of zapping here
> -	 * isn't guaranteed to be any faster.
> +	 * Zap all roots, except valid mirror roots, as all direct SPTEs must
As now specifying "KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS" only zaps valid direct
roots + invalid direct roots, do we need to update the comment? e.g. to

	* Zap all direct roots, including invalid direct roots, as all direct
	* SPTEs must be dropped before returning to the caller.	For TDX, mirror
	* roots don't need handling in response to the mmu notifier (the caller).



> +	 * be dropped before returning to the caller. For TDX, mirror roots
> +	 * don't need handling in response to the mmu notifier (the caller) and
> +	 * they also won't be invalid until the VM is being torn down.
> +	 *
> +	 * Zap directly even if the root is also being zapped by a worker.
> +	 * Walking zapped top-level SPTEs isn't all that expensive and mmu_lock
> +	 * is already held, which means the worker has yielded, i.e. flushing
> +	 * the work instead of zapping here isn't guaranteed to be any faster.
>  	 *
>  	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
>  	 * is being destroyed or the userspace VMM has exited.  In both cases,
>  	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>  	 */
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> -	for_each_tdp_mmu_root_yield_safe(kvm, root)
> +	__for_each_tdp_mmu_root_yield_safe(kvm, root, -1,
> +					   KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS)
>  		tdp_mmu_zap_root(kvm, root, false);
>  }
>  
> -- 
> 2.43.5
> 
> 

