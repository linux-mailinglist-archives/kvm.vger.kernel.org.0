Return-Path: <kvm+bounces-51167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0787AEF37E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E7633B69E6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D21526CE1C;
	Tue,  1 Jul 2025 09:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYEtFHrT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23588130A73;
	Tue,  1 Jul 2025 09:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751362713; cv=fail; b=G+R+61to5QPf7ifQ10j+SgF93uNR0oCMYjM374l1TWpk2UWrA9Z78YiQWRvIL/t8q8PlyNdw1TgW1b8IzMWbuD8m0pff9z7m2zVKZR019r6892WDAnpfvKG3uw2RF8U/Xjap7/4FiTT0ZShnt0ZQ6UnvPx/obmvr+xn8Zd1LNbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751362713; c=relaxed/simple;
	bh=7ix2xHuvxdRiEOZXZR199n85/YE1EdQYRHRADutADWE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KKguJdNDK4btAx3BVQm2ORdbjqWnYkwZZgnQ36ThKLc52EQ1sb+qVgk8NPmvOfh13kjqRiQCVKzD4GPBU36zXfvaNNmqyDYnftPMM2iyr72V7+HAqceXjmfpWMgu6zE/XQ5yyO/BxnJX9PgB15bK4e9/KGk5cbOUQZ43GiP/VFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYEtFHrT; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751362713; x=1782898713;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7ix2xHuvxdRiEOZXZR199n85/YE1EdQYRHRADutADWE=;
  b=CYEtFHrTK1Y8jFViO84904FfqVDOQKnB7eCdsxA+tKE2onYUeq2TfO1o
   /RpxUVX0UBykqiglu0BxuR7y2j6p8O7xzWMkcl+xGpQD+1syMo+//THoT
   8Nzb60C35m5Aa6Hqh4F1fBH0FtZIL7OaJ19Hlmx50f5Ri+/rZsZBE6jcW
   /J6/sAAP76SO/W5Qg0wE6LKy0oyPMbIs6jup+Q4jRlgkTj+RPvtSw0TZh
   3KsRC//UDa1CdtPdYRL3C32FfDkE0hknEEnqoY+sKTlexSDh/4RYBXzTo
   nlIcBuMs65YKPV3hk4zPbrVvdqj1YD0MvWpQ0GY+g50FCEGaQXm4w7XvQ
   A==;
X-CSE-ConnectionGUID: uI/rZiEnR+6gsnqWKCGDxQ==
X-CSE-MsgGUID: 3wYkyIIwSiG5TBKY4aGxmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53490275"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53490275"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:38:32 -0700
X-CSE-ConnectionGUID: CE5Jq9wQQQqI5THhl/OfrQ==
X-CSE-MsgGUID: z46O0PLwSzmj7OXti++mGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159223865"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:38:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 02:38:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 02:38:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 02:38:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lis0Sv3VvD6SUMezoAYK9tmXxdqEvChl4yTue/+MOdWLe/yewNkEr9PowryADirlbaq2kEgXwhzbtpMSoekWaz31n39/DD9RYus8xbIKqfp1XQWIozWqfozIyNVZK0ZIudylK0Uxl8hewG++PuI0mRwRliysa8gZRwhSHAVnI2oIJJ9sHAr61IM5R2Azs45Tu++wD8+DWQSVU/dXamsHJInzTtqC10M94ZGUwPGJTVRFEhSew2zFw5r3S3mYi7LZYGKKcbmy694VtiydN3j0lXzjNNMUF/pwUvfadq5FDeCSDGB2K6H4rnzB+YZbKy8fkcl1psz0oA/nLsgzE6Ghfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ix2xHuvxdRiEOZXZR199n85/YE1EdQYRHRADutADWE=;
 b=IXhFxksKtCBt7MTh157Tw6qbYu8iF8uNpd5ahbeG5O+eWVSNULfQp9hKhm/vFVK0YnwIPXzuHC0Ig+M6jkJWZv0YYiUcHaC2QEIx2AcFqSYF1cv+jbgm9teTx5AAkKjeCESsYaG9DJoTpRsrCYMKpudtnUyD18LoxUHkbDQYSyP8UV1dmX/A9yLm8sKlW7dv1DgfZkZl1ugfO4g23n+XGaGP1++5e0A+B3G+WdiGjQ4XlYKiN1m7180tj8Jl0hvVcEx9e1FcDscP0nNK5oI85dXWkODyiSl/dWZ4vo3reodxtG7RBe5qJg6I4nV26RI1m56oKHwhNZEPsQ9LqLxENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8775.namprd11.prod.outlook.com (2603:10b6:610:1c7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.29; Tue, 1 Jul 2025 09:38:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 09:38:27 +0000
Date: Tue, 1 Jul 2025 17:35:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0005.APCP153.PROD.OUTLOOK.COM (2603:1096::15) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8775:EE_
X-MS-Office365-Filtering-Correlation-Id: cad56e1e-895f-4446-1540-08ddb883084e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?v0FtbpepAokLfimGuc4c7DbvbMBslQWuZiC5CbxFZEhgSKTT3MNYYcDf1vUF?=
 =?us-ascii?Q?/0heFRmqPiBjeUY26vq3XMKxnO3I5S8gvbo6iA8iDmw8jkwtl6Buv1TtLg1N?=
 =?us-ascii?Q?sFCroYjU2DC940ZH0vm1QWqz47pVPnzs+j0jqwDex7j73ygeYZGk5wFGFMZ0?=
 =?us-ascii?Q?K7lptU2skeWAVjOGuea+mjZoyqhfFNdCWoFZvXURageTACGPWYM+3v4H9YED?=
 =?us-ascii?Q?EbxmsQOKbVA8DGXZQt1/X+k1Y2P5sYz96nCRMRFFe9mOGwf7C72pkxZBavvv?=
 =?us-ascii?Q?SH+dwCii/RaQXMb2oGI9jB4E7gah1AU0JIiNCTANTiX0uMFnC3MJPyJEGgLg?=
 =?us-ascii?Q?nq1XiGZcAGARJ/Vp8/C19slzDsgxN7/G+bDNbsDkwWmx+1KdtdHhkPzAb31m?=
 =?us-ascii?Q?EZ27HIOxJPbLKwaWA7oquBUMEHMivhrBBhULade+g1T6VPxbJu3DThAUsjJX?=
 =?us-ascii?Q?XgB4RETY71RWVOMds+nR6fqXoLezYXtGzgvOMKJ2yU47N+h4u5hfrNF1/ZT0?=
 =?us-ascii?Q?V5qTfIUwCvd5ThPnfvBcuZfAy3RCtpiTnCkbTDImp3Yty8k8CMHRkkxBwcea?=
 =?us-ascii?Q?79JwzsFDspthHh+KLshbysifheUI66+LA8MQexkShVePF7I3Ep9qqE96pWhw?=
 =?us-ascii?Q?2tQ5cp22Tjkppxn/X/lwLIzuvYHLouIPOQ8D30DvvCE2+H9n4pZJ/b+k5GCO?=
 =?us-ascii?Q?8X609o7yY+hUJfpJwwLxVNYb6dh0e22xL4RkmLngvAi+OORaU6REMZzJtMuR?=
 =?us-ascii?Q?kUdQmn42ohbqd6KyZAoQNhxdJIGw6oTiaAayynee7J2zL13hNOz2JMoxsdDN?=
 =?us-ascii?Q?4/IC6X43BRpXZe6YKRkMfPzZVSNI2q9BKz/heFPr2L2r4ibRJyJ0m2xe79jc?=
 =?us-ascii?Q?N6ZjlUEcoE9aFCMJmlfB2scERxeCWqqK0FST8n6Iiv6asZEx5sGWU9gJlqUN?=
 =?us-ascii?Q?cyM+j10yY2BOtRcqUYExJ5eaa8jxU2UsQd1ADwQCn3eVFx5GmSbdayL4e+0x?=
 =?us-ascii?Q?exCtDk5pP/T7lkze1jCwDQjs6FlUyTazJ8PXN6mOQZUoCbfnXHEd2ThueJ2V?=
 =?us-ascii?Q?IZ77UN4cAx6G4hCr4VqdaDNHiu6e/qRXBLsXK/65dUBJ42T5YjYrbYfYcxZ4?=
 =?us-ascii?Q?UnauEEw6j6ggIEZH/GmMZ2FvmwLxTfNhI/qmRwntVY9J39zZsyoRRl+I/lN3?=
 =?us-ascii?Q?WcI2VVLrJApZQ4L/65fJBQL4/bLQSQ+IJEBQvxwJdZr6lOvmZpkX/EtA7LvS?=
 =?us-ascii?Q?gpTqkNpAZhDX+E4FuA/85UrgXypTqfkIROBrpFehNCWeqUE7fCrjQBN8YO9d?=
 =?us-ascii?Q?hrp4XFb+rgV9ZK7xP+Tw/g54zU+0mY7MNuX/GeKFYB5kw+9wS+XcOBaeu3Db?=
 =?us-ascii?Q?8bTiNakuPYRojth4f5ZOIR1KVQB3889dSgAnjSoXHaK3PS1kyeVdQyRsuA0l?=
 =?us-ascii?Q?Ukl3VcjiZwM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tdh6NzjhjlJ3TNduBXjISzAC31uVLG31Ri8rXqbrRdsnNbTLViq0SvfvlJwm?=
 =?us-ascii?Q?Acvy+8hbYA4h9uuW5JryEJXH7pR2EvRkYCiOlSbRzMuzUGtHKNbo8EV7L6t9?=
 =?us-ascii?Q?P6Bzhm1zkbXJTuSrd0J4OOPQ9G99BZ4ugPiYxzBymPuTb1alTjXuZzEKZECr?=
 =?us-ascii?Q?4D61LClWy0PWdApCzH7KGtPqHg3p06HWuOCC332xg8aKgcMyVJSQo7uZGB4B?=
 =?us-ascii?Q?LajY03Fki/8+dTFQWpRiZ7C1AjJauulDsKactbjGfoO35h3IaIc5fsJMsTgr?=
 =?us-ascii?Q?3CtSYdQ1sBgfkednFQyDrh2Ylt0msLx7+nSO71dWDCPPYjmooN+iZLESDd6o?=
 =?us-ascii?Q?V08K9HsiKCzcQsudp+LTde+Kc8wO2Lw4zRhZXTlFmu6HI3QhEBx/701cW4kt?=
 =?us-ascii?Q?8ZC49sEbKK3bJDykaL51w4f/855CDHBxHTwWCu4NosUexqsRdgMGM6F1dUcw?=
 =?us-ascii?Q?r6jgaNkBBA1usAsgijrrZ+a/BSYsM9uLfOVmxxQxtghaw6cZyxFR+pG3ZIMK?=
 =?us-ascii?Q?EzZG8g1gSfogixw8pBR4uOyv0U8Bl84HH6DK3ktw/qiM3Zy5GxO8y9iOam+W?=
 =?us-ascii?Q?FHv3SZSKsCWoUfx7DQPSP4h+25qNUEsF4bv6B8P0XYPN0VN/B0SM53SwIcG9?=
 =?us-ascii?Q?SqKyFw5grIzOn9guHBLIuHn7GTtyub8j/EGVMtcnDQbf9x8q8BPWqHSluyZe?=
 =?us-ascii?Q?pl4i2uoJgm4wrd9u9C8cneuAAqTSqpEVvcXeqyeOSnjCcUmx2DgLRjlwzbVh?=
 =?us-ascii?Q?wd9zE7fdkYwOiLnYZFlSHcbHirIcVaMFWM0/UVu3MTulUVeJhkPhsUJvkzV9?=
 =?us-ascii?Q?XkI/GYtGTfAT94EWytu52BTeuZXEFD76lGJjtcSP312+bYB65vg4nryiws5w?=
 =?us-ascii?Q?29l5nWnLDc0vkIsscesR3P0Lds+Sy81EFRYBTev2/dATeAZOcJFXZDfpyT3I?=
 =?us-ascii?Q?2z/EeuZx6jWcM0JpwL0UIolCzgdunvvV4u7GHaykUjXUHCGcwTGPJjjbtFkA?=
 =?us-ascii?Q?3f1O+JXTLw4ekruABXvyw4Dx1e7IF9Q3+nsaDLbEYqBJ/cVi2vRpH3X9LS9M?=
 =?us-ascii?Q?/7wk//4PHnbE6zf8HNdgFeVIY3zJFoL6S7XtrdDj0d6pN+3jYG4o9kAbog1e?=
 =?us-ascii?Q?sNhQnZRztFDyInqMb4KZntNjzz49lV5KjCp+CxuZQ+3vwJ3pBDPgFuX6n5sv?=
 =?us-ascii?Q?wiFaE+Y6zJ7iv+tD73BcArenZVvd9YGWSmLiCCXW6L6eQ3p781w6lpvaQ9wl?=
 =?us-ascii?Q?fa1lWHqBQ++r7f/BexSkn/BExiaLPz+sD16hfpu9+C1sESkeqJCOuJJbFbzZ?=
 =?us-ascii?Q?SzXZtit8+fGd1g5yWEUA/azQlts7DPhiUZP5o91oV6kkLuXC56wotNiRp9Pl?=
 =?us-ascii?Q?tZCwr1tjMWjAAXlfjYnzgzpuAtWUISWPEa9/gW532LyTEmEfFLSRljc9oDs1?=
 =?us-ascii?Q?uSyzx6AQe0YfjPec+ixkvgP4D2oHWfc/+nfSYwNLLFqvr7rRhdgy4Oqf0w6d?=
 =?us-ascii?Q?xVrt7sOplnfk2qk5qPChKtYYF1PcNb2185ZsUVvWnNzyrHsi4A6ON7eNUxrF?=
 =?us-ascii?Q?KKP4wVWV5oPAeK3TTeaGwcD3QI+gkhlW+X3d9dFJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cad56e1e-895f-4446-1540-08ddb883084e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 09:38:27.7635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irUmd0fPi+8H9GsghMu0n50fcHlFwA64v/zGQnhU8D9j+PtdVjPTImaLD8BgWMl8jETJTSzxECXwP/JeKC2wiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8775
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 01:55:43AM +0800, Edgecombe, Rick P wrote:
> So for this we can do something similar. Have the arch/x86 side of TDX grow a
> new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs after
> that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the system
> die. Zap/cleanup paths return success in the buggy shutdown case.
All TDs in the system die could be too severe for unmap errors due to KVM bugs.

> Does it fit? Or, can you guys argue that the failures here are actually non-
> special cases that are worth more complex recovery? I remember we talked about
> IOMMU patterns that are similar, but it seems like the remaining cases under
> discussion are about TDX bugs.
I didn't mention TDX connect previously to avoid introducing unnecessary
complexity.

For TDX connect, S-EPT is used for private mappings in IOMMU. Unmap could
therefore fail due to pages being pinned for DMA.

So, my thinking was that if that happens, KVM could set a special flag to folios
pinned for private DMA.

Then guest_memfd could check the special flag before allowing private-to-shared
conversion, or punch hole.
guest_memfd could check this special flag and choose to poison or leak the
folio.

Otherwise, if we choose tdx_buggy_shutdown() to "do an all-cpu IPI to kick CPUs
out of SEAMMODE, wbivnd, and set a "no more seamcalls" bool", DMAs may still
have access to the private pages mapped in S-EPT.





