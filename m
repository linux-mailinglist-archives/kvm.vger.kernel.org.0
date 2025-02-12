Return-Path: <kvm+bounces-37954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBFFCA31F94
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 08:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D5A67A44D8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 06:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7181FF1BD;
	Wed, 12 Feb 2025 07:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iw/NfmXk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328E1D6DBB;
	Wed, 12 Feb 2025 07:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739343638; cv=fail; b=SwzG+JHfe3g4nNArg7IehSVJycYROPu9RNpXMuylistgZxfnDlA0XT28fzJDoj6SvZl/uBX+s3WjN1Pboxv4HBD47elJGNViEVcVcMPlFZX33/DvmlMwe4De9XaaDm7d5eXE5dEi+KsN0rxCreFkNbqiGE6i5M+I04eVSRzZBHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739343638; c=relaxed/simple;
	bh=HP5fTQkb+6RteOD3fNO745yzlnqJmGPkHoczUY2xckQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iS3hYuerO4/wc3WEqLQ0XL/Zwh7wNvYNYsUODYLny6+gD8YNqAsG27MnX7eK8d4+vFIt1h6hVyQR53JuKgTrZnIODxtQcrjDPf3Tahe2qmfdwRjcD54WEAPMmDmrmVghWEo0cjEzwV+3QVtkjSPeTIlDLB0lT+Ys4JhIDP4+c40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iw/NfmXk; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739343636; x=1770879636;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=HP5fTQkb+6RteOD3fNO745yzlnqJmGPkHoczUY2xckQ=;
  b=Iw/NfmXkYkIYb9O0skBo5SM2XAsLYgwqnEz8qj6L2ZaulyTrt07/q+Q+
   0cbZIHaHeywZW8Hi6B21NXYp800/T6CY+80oEfcwvO0CbvrQcjfWdrm1N
   FmguqzxF4HKAUauMz1q9ZEBlHtmj4EdhJE7erXnNc6OhaCwW5a6bVTyM3
   8i3UhZsDMujcOuJcneInmIcVPoRMcLTw0RFWgFSfrOTubxgAWSrczirDh
   /xQWu4jERgFf8ZYkkV5HcAi6R9sC0LIhsrsNfI20FWH9GnFJHRT8OAJPH
   gR5keIAC2te/Cul9kUjrGgx5Rt2sjhtIu68Mii7hUs8LBp/F7LIXKdCR5
   Q==;
X-CSE-ConnectionGUID: y4FAGda+QhyVx+7eqhUdnw==
X-CSE-MsgGUID: Pa0UVk8xQpm3a4WGFoYXBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="39688327"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="39688327"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 23:00:35 -0800
X-CSE-ConnectionGUID: RupNu9SuSVmJMZrRlevLlA==
X-CSE-MsgGUID: FvtvgBU2Q1KVNvIFR/dj4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="117761267"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 23:00:35 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 23:00:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 23:00:34 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 23:00:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGqYY5P04TyqM8wUJg/MLoZBQLodg0JwDDlVRj+Upj+Vwrj7wg9qLNmxL3c2X0i6NoOVm1dwTo0qy4FHe7RWiECa7I0choZbFBgwdNjs19JYHdeiopVmroC4KvusDncNbUU+7rm7t99pQTV7SYhOZoHQ3M2GvOYqraS7CvXcwiOAXjZJGgUlU4MAByt1o7Dot8w1kWoZ4k53f2BrZMu93OnFn35oAvbnpH6wMnl3S3XdiAyQ9RQcgeRZ3V/vC9zyYWqN5lER3X60jI9nqm0n4FcSdhY3pdDNYBb44QMpogUKBK3hs/dv9TiK917+j6zqV5mT2usEJv0bYjJ5luv+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gonBey2Piau5jam+8zLI6lHBnT87WLrL07ijAs4fWWM=;
 b=ElS4DaiiBJqmFD6QzZYKdzExNvB5SEzBkRk1+7m6lWLw/frE3g2Cqt0rfQZfJyU5AoSTRwMhT6Mm2unWEGabEDrRCnmVlzIJPAuG+g1X7FWAcc2AcJk4Y/58EdNPnPuerlBP7tSZsKhY7LNxPL0cun9Q+5tlPBBAG2obtziL+VsPgMG0wwc1+HDNaQW/Qgc5UJG6jQsIQ65iGhl/R81xMauEg0OtksvVLLF+5UB6DdJGXQbckYUxNd2beYks4UmPffz1C9vjxtnwrSah/HSt+JPY0/zW80JRh6RO/YAtkmY4LXaWwShKpIjhZtbrEOPWefugj3aLRUZAogasoWnc/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8681.namprd11.prod.outlook.com (2603:10b6:0:49::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.18; Wed, 12 Feb 2025 07:00:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 07:00:23 +0000
Date: Wed, 12 Feb 2025 14:59:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z6xGwnFR9cFg/TOL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
 <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0145.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8681:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc1eaa0-ec88-4801-b606-08dd4b32ebc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?BKkQfEfJFblDtUUl6zJFxTr+fV2a2oflimG/lm4lKY6qGHXsP4Ec5GCGYT?=
 =?iso-8859-1?Q?CWaLbg26DzFIWEx02Ulm66eM+J5jM3MBE+I8+o1gfB+LY0ej37/LywR3Rr?=
 =?iso-8859-1?Q?DREsfD3EnZZvEOAq3TlPTb4mpk/v8Q3orbLjbu1C7aul2GTQzIKG7ccdS+?=
 =?iso-8859-1?Q?NHIekMWOEoMwd0TcjapjxRdsP5htsiFCpYroxbbnXDVdNx5gJvY7oVzjW9?=
 =?iso-8859-1?Q?A7WeS1BF0I345l2IQWqQg73+IYd0sopgVldb5mFN1RAt8Mz3j6LpDrRXar?=
 =?iso-8859-1?Q?ScsmsxhfCcs46S8bKMwEqy021QmULuYe4CYH7XfqDEuJ4Xe3LfPMnsbsJS?=
 =?iso-8859-1?Q?2ImF3dmpabFbLqTVNFV/O1a3C58VMe7iryDCS2rz4KnVVoLJCdGyYWNox5?=
 =?iso-8859-1?Q?3wTUmjsSZGavx7x2Ne0PSkzdo/gtEtqNjWZtYwSSZwilvLEJTU8rVWGyY0?=
 =?iso-8859-1?Q?JxTN+gpYSzh7qAl/wKfbSpvq/RZX63y33Lyfj+yF56bl05Wcb4Joi/9KW8?=
 =?iso-8859-1?Q?f77vcMoyKfd7kbTiPMYK0LwBVltUq4XFYZL7ns4Me2o75sL1BLQXqWVdB+?=
 =?iso-8859-1?Q?JgATCGEZaiwkBIHrf4quoRvTCpLwlMv0F0/dMAKOO+Isg/Pb2KYJelcfcH?=
 =?iso-8859-1?Q?rP9qZxDkuQzlLB7pKaMKXD832sb4eSBaUa5afIh7PatV5/dKE04f9ofXRE?=
 =?iso-8859-1?Q?DTkQ820MfJMCtFFeD7B/WXho8LibsuLoxeCE04ErvEcQMEOiR7K2Cf2GoQ?=
 =?iso-8859-1?Q?cqqkhonVmHzIaTr+mEGSqGS9Ogas/cbCnHykNwuTFZ/+SxLU0AnfBm/iy/?=
 =?iso-8859-1?Q?jW77M1zcV2ctkD7m7z4/TnSyn8lcm7UaLQhO/1guTEdyWCgoG7zHiQB6Fk?=
 =?iso-8859-1?Q?A7BQsJpISbHjteM8iw7RPUbAp83s1tEgSK+B8wRjIaSL1LMH5d2msvtvqs?=
 =?iso-8859-1?Q?7ZsH7+YspX1zhzBGdqJEPX5HHkW6vNuyT0emYNk8ZkVVFZ+yMxP+kKm6sI?=
 =?iso-8859-1?Q?ZRJgp2lYV5Yk4ByRVK9WOvhfiDWSWB0a7XzvfkhcSdps7dbJX+qHQdj644?=
 =?iso-8859-1?Q?yTdQjow2qbZyasuAkEW/0UpKvmbBjfqsGuKt94yiYGlL3aRK6QvZrIn7Rq?=
 =?iso-8859-1?Q?OfoLgHyHHDsVwRckNecW5DboW1oYap+LnGajRlTNjl8LGNadyrwECQPYK4?=
 =?iso-8859-1?Q?pkfM4waM/1mRzzyt3WLkrha0JUKRisHtUFeTYCgs+JImBx6k8uFdwdKxr4?=
 =?iso-8859-1?Q?yL7tMjMoR3t35N+b5tG/8QK8Y9qDP7q6ekSQSzKpezGrI/GK++gU8A1F1N?=
 =?iso-8859-1?Q?FBaGINoDHv5zseBpVf/QfziuJ7smtOMR0L0lRVQ16K08ZlrEJN5LQ1Tz6b?=
 =?iso-8859-1?Q?LLl+p0JBfj8jOli6WQWLOkXAI9x6bgDshIKBoTHO0ShPbBCName1kKJCrd?=
 =?iso-8859-1?Q?XYizbRztmD2uZXtd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LuuJibLqvNw9cHKdqNSOYihNCsBS7hI6+MhvSdeOqJDU04UZXnJjMXVgIU?=
 =?iso-8859-1?Q?HxIiUix3C5Z7qVvs1iuUvIXP5+mklhT9FXOWzK+rO1Lw7hxLaFaEiKhYBz?=
 =?iso-8859-1?Q?Jm3lTbZOZrmoT9WBbKmB3JwiMNzDVQkl06Mz8tZnCSWFh402SMHhUyaJRE?=
 =?iso-8859-1?Q?1U2wvbyF/bIegoYn2gqYAlp9gxs3aJcpAnnNqUUpoMsWAPDx//geQsSufn?=
 =?iso-8859-1?Q?SKw9sAv01Jv9PUVOhGgB6LW7qdKH75hjtg3A/3qxdn7pLCtW0f3bjz7zwD?=
 =?iso-8859-1?Q?M36Y1Q3RcqDocXkYcddUwh5R6Unk6NTC1fCcT+/ARimfxuoHcF8wBIwAss?=
 =?iso-8859-1?Q?qVq63C5GezP3LCvEMYPoBy++oQxnKTgaAiYCY/BHELBSSAvtijC+jnNpbt?=
 =?iso-8859-1?Q?2RKo+ID0c5F+NwvsaE4FiH2iD0AgrvZOJ64/TdFYQzGhF04OaZiYY+ZUCY?=
 =?iso-8859-1?Q?EH7rHVAQs0dS6TvJJArbTfZvLM0dFMPYyJC+abotUHYTn4nn26uFCdhRIB?=
 =?iso-8859-1?Q?q1bC/gM4nkiMVW/bDIwwhz01Kh/20tCuIhLKqnLxmUWFxyRuHrB+74PEdO?=
 =?iso-8859-1?Q?5VDVA22+DOj7ElejFRd2iXCXab+cfvW56w9vxH9c3KQH9VetzCxd1IXg2A?=
 =?iso-8859-1?Q?NBqeCu/IFs+q9W4Ixa60sPJ9TPxSLQKv638jrebjygGOCBRi8NZD/T1jB6?=
 =?iso-8859-1?Q?voETbrju6cExKyBEvhj9Zx8oGTDiMolpS2tKsIqLeldV5122AQqp6N+oRG?=
 =?iso-8859-1?Q?BBMHoXvFp2YXd/Iac4lBHCBOGuYlj34PkuZyOj3DHrY8eLa3mgUwZ31w2X?=
 =?iso-8859-1?Q?YGH9FzC7IL3FaU2EYz8JQfY0GVWPvFaIGfsbJUXSZHFVLdVVLBb1jY7KA7?=
 =?iso-8859-1?Q?SAB+hkjGAOF0eBr/hajFBMD/HIq7/iJR/OYTAQaUMk1ALGmePpZb7tt1G3?=
 =?iso-8859-1?Q?X3ahIHNqn1cwakicZBS5W7g1JoFlYK0eK/Vqlh8YHGfW3RmWdShRUjODSp?=
 =?iso-8859-1?Q?NmQgRP+3tSHqE7roi1ArB5javsoqW5gpkGKrydTi6+mjaXw/oJfzHiKXbP?=
 =?iso-8859-1?Q?26N9AJIIy8lo1OnKvB2HFdlLb6yfRdDjYTZmpgrB1igU1JlHRiFiD8i47w?=
 =?iso-8859-1?Q?pzF0HUgqHy6xDcQNhmWyjlw7jvREtq42H0J9C7h12wRvCani+y92aNeZX6?=
 =?iso-8859-1?Q?z7Tja2SczMojbpO95c27mJ2nxpQuYVTu1AUqOFdpMQfViEdYdJPIf4/jLP?=
 =?iso-8859-1?Q?BHYlqBaYF5KptgGoHEvtHnV+4uJEkuQKM1++TFfXLGu2Z8H00EFNTcboOo?=
 =?iso-8859-1?Q?KIXgqLe6o/KdQjN7OEVFCnYUgL/fN4DpOAbTopyXOv7s656nAwbCosHDaa?=
 =?iso-8859-1?Q?6Vq7Z4V3SqzvWHv0KKA8iWeh7vqghRu1PC1/ZPOsoEhP7kLfnvR7EGz216?=
 =?iso-8859-1?Q?mfNZlrb+jK4ixAgv9jeLVWOKWqRATf4rhoZij8aEf8ta50G0UFZQyLe/gW?=
 =?iso-8859-1?Q?m+q2GKNR4wbHPwm2rq3SxY5UwMJCuzDcL0uVu5Fgl7im14e0XYmeA6S+8V?=
 =?iso-8859-1?Q?5yKk3wuyuWxIok/iL8GQf7uXLYsa0miKjHXGuvLF+AK6qx5clxPxbwl708?=
 =?iso-8859-1?Q?LD/mPCH59rMznerianqN2xt7JgOeD9eShU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc1eaa0-ec88-4801-b606-08dd4b32ebc2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 07:00:23.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbDK0hZyG0Iz6gdZUnYL7eXTzR7ZhVkQ4lzd5n7uTeBuOaRot8GGVCtr2EFJEcwdzeToBpAmP4vA67PrBiRW+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8681
X-OriginatorOrg: intel.com

On Wed, Feb 12, 2025 at 02:29:26AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-02-11 at 09:42 +0800, Yan Zhao wrote:
> > > Is this a fix for the intermittent failure we saw on the v6.13-rc3 based kvm
> > > branch? Funnily, I can't seem to reproduce it anymore, with or without this
> > > fix.
> > Hmm, it can be reproduced in my SPR (non TDX) almost every time.
> > It depends on the timing when mprotect(PROT_READ) is completed done.
> > 
> > Attached the detailed error log in my machine at the bottom.
> 
> I must be getting lucky on timing. BTW, in the above I actually meant on either
It's also not easy for me to reproduce it in my TDX platform.
While the reproducing rate is around 100% in my non-TDX SPR machine, if I add a
minor delay in the guest (e.g. printing the value of mprotect_ro_done in the
beginning of stage 3), the test can also get passed.

> the new or old *kernel*.
Hmm, the test fails in my platform as soon as b6c304aec648 ("KVM: selftests:
Verify KVM correctly handles mprotect(PROT_READ)")" is introduced, which is from
6.13.0-rc2.
 
> >  
> > > On the fix though, doesn't this remove the coverage of writing to a region
> > > that
> > > is in the process of being made RO? I'm thinking about warnings, etc that
> > > may
> > > trigger intermittently based on bugs with a race component. I don't know if
> > > we
> > > could fix the test and still leave the write while the "mprotect(PROT_READ)
> > > is
> > > underway". It seems to be deliberate.
> > Write before "mprotect(PROT_READ)" has been tested in stage 0.
> > Not sure it's deliberate to test write in the process of being made RO.
> > If it is, maybe we could make the fix by writing to RO memory a second time
> > after mprotect_ro_done is true:
> 
> That could work if it's desirable to maintain the testing. I would mention the
> reduced scope in the log at least. Maybe Sean will chime in.
Not really a reduced scope.

Before this patch, it's also not guaranteed for the memory writes to occur
during the mprotect(PROT_READ) transition. i.e. there are 3 possibilities:
1. all writes occur before mprotect(PROT_READ) takes effect.
2. all writes occur after mprotect(PROT_READ) takes effect.
3. some writes occur before mprotect(PROT_READ) takes effect and some occur
   after.

case 3 is not guaranteed without introducing another synchronization flag.

That said, I'm not sure if invoking writes before mprotect_ro_done being read
as true is indeed necessary.

But I'm fine with either way:
1. make sure all writes are after mprotect_ro_done is true (as in this patch).
2. call the do-while loop twice to ensure some writes must happen after
   mprotect_ro_done is true

> Also, I think it needs:
> 
> Fixes: b6c304aec648 ("KVM: selftests: Verify KVM correctly handles
> mprotect(PROT_READ)")
Will add it in v2!

