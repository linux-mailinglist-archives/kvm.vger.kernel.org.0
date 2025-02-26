Return-Path: <kvm+bounces-39226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03993A456C4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 08:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 187803A4CC2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 07:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6332A26B95B;
	Wed, 26 Feb 2025 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VuXkZnQp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99F5158DD4;
	Wed, 26 Feb 2025 07:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740555368; cv=fail; b=XM1cdq1O5soqzPUTP4US9ZQZhOKeWcJvP63Ri43shnuljqwAwfN5y4EbeYhiUpvmGKDy84GPBpxNF4J+wrmzkwQ5+HXaW4K/LwS6qzWt9wLRsugZLqfWTNE7Y8x+qpfoN4wvDKv6zI8dc6rOtFuS9+NPli4q9FTs+10x09VdOI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740555368; c=relaxed/simple;
	bh=eNcjQeXUi6BFyHyhtdiO/tZMFeg6ATDS6DOg9ttr3HY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P3vb2py2O0bHMkgT99FgPQrhky0ppkTNEue3/42e1efiFI8rJR0WMYBPKUT3IZRaBzR9UaERryHDgiVjqatBHCGHFT0qcQefwMpJorq5jadkZasHRKFvDI20qtwww+X8LG9emeuvgCt0esTorZA0z93+S8fkze2M6O/Ybgn5m9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VuXkZnQp; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740555367; x=1772091367;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eNcjQeXUi6BFyHyhtdiO/tZMFeg6ATDS6DOg9ttr3HY=;
  b=VuXkZnQptGqjs3BhQPpn0xneu75C+ltaBhIBHejJt0Z+SmPYscm6NNO7
   bR/Vr1ktLA712S1QdoK2CJlYc6KP9sE3kasNHksPBlyzssM2V7JsSdZL/
   dYbJY6+q/87OK1ygAQPMqWY7rUwIdNPOH0b0Fr7kMC5shAX+wE6eBKuf2
   jjnZ/ZdA0m0mSLFHtHERTEddbHAjlhgyeb0MtPdKNKM5ArhH5pm72EfEq
   czgf4CQWGFNDdPcSoVc6kcu79Nl9GLiguwAei3nckN0L+Q2ziyeGKPCls
   YHCnoFa/Lfo3TW4YBHiIcgBP8zajhrElh8v1lRUsOh7ST2WX6l4cqVcdc
   Q==;
X-CSE-ConnectionGUID: sysAIUHtT8emmrSI5yimpQ==
X-CSE-MsgGUID: 0/W3y7CGTLiRHwUYjiuNkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="51598548"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="51598548"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 23:36:06 -0800
X-CSE-ConnectionGUID: +7jsecTASuO2ejdn8IkO+w==
X-CSE-MsgGUID: q7eoz8sRSi2zrFLC7wtRtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="121559256"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Feb 2025 23:36:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 25 Feb 2025 23:36:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 25 Feb 2025 23:36:05 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 23:36:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dQ9sMERtcU2aLKRyb5GQWgfOrQT7yXHcrocfCRKf0oZJZg7wK4/FWyKBo/wThIBvq4VSAC0yHaWHISxF4NCGl1LJGZ45HyKLSFmUgBGDux8CWG2JwlpDpevaJ9CWDkwSxJwlqAV5S7Z+P/p1o7GP4YBhxDG3wKdLjVZTW48WtR4otjR0Hl/J979yAZtXjzzDNuXJtgSiy8NU+LCja9ENsMZpbKAmpb8qtJV53ZGhkxqVnpxC3J0G9UkfBJMHl033JdAhrpy2Hmtn6Np6kwciITn5NyagBDV6k7mkagqqCT5aeDOtdxY9W/D2qwf8FcFqBEjCROhNfCyMJkDT5975+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuVq9O38il4WGaNgiZFYv8Essq33abnJgGdthZT5DPM=;
 b=abWPCYeI/cNB7cHMkIJHt//FCqvEFMlr4NwCkWBYzZ02tr27L3TvZvEAjfXRNDxkm/gEF7aBJ5rmDyhkrGGT+znS1jAWNHZDCm/A5oQJAn7qsslVw8RC4CFzqg1adO7UJPzTrQqt5xh1dad1nPi+erb3oqGLcOriLZDjcr9/4ylaHnlKjxazLXO7fiBU8OrIMeGdVIabUnI5wQkw1HDWxyUJnoqRuvSN7rUt2GPI5E7EG7x6ujt+a3kLtfrWIQCiL5Tdw9ijNI0q8tLD3WV/X1QojiP8Cs8KcWfT+9YNWuaPySPNTeFQfVpZk7ep+44uN2vny841sxcuhtNUtYwKUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8543.namprd11.prod.outlook.com (2603:10b6:806:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 07:36:03 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 07:36:03 +0000
Date: Wed, 26 Feb 2025 15:34:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Aaron Lewis <aaronlewis@google.com>, "Jim
 Mattson" <jmattson@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
Message-ID: <Z77EEGnHnyWsEt+h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250224235542.2562848-1-seanjc@google.com>
 <20250224235542.2562848-2-seanjc@google.com>
 <Z71072F7FMz5aq/Q@yzhao56-desk.sh.intel.com>
 <Z73cF_pWIFMreOf5@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z73cF_pWIFMreOf5@google.com>
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 07668b60-b402-4820-8b51-08dd5638391b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vDdx3pa8LkNE6mVcdlBG3bAlbB/k+MIqflV1vuZpMaWmvt59d7NgnUvNvWzi?=
 =?us-ascii?Q?MML2b5RLT/PNPjQdDJaVwqV/nG5C4wSnyJhOTC8r4jZrxYzVkTMRztm+ylDN?=
 =?us-ascii?Q?YtUhPA7DCZ4ZLHTSAmI3eUj9LPHhXpXnuscgcNdoddURAtsm1RyOPcacVTAQ?=
 =?us-ascii?Q?dDXpuKv4+8ARaT4meNbMtnLB/0sR1Wd8/X3gzt5128b2zaKPSJre9m2JlNEb?=
 =?us-ascii?Q?ddYXn7DQCa8p0nF1I/k1F8ql3JbPtqf4uJvyfh2qA3tQpeVbKFKblF2gABqZ?=
 =?us-ascii?Q?pX6J0M8Pg0rLuJmOlTNEs/xAun4TPeqFAyhzIV4Wv5sXqU3n6a5REp3Gm+X5?=
 =?us-ascii?Q?GMskO6VbQZyfyXzLbAKprq9Sf8FN5kQL3zZ/Oulwri/xr8OO8AGrlqjSHKcm?=
 =?us-ascii?Q?I4olzJGH/1lU/Iq2X07niaiUDlJlYJmlhnmgtokuJ3Q1j2FtCm5wnGAirTG7?=
 =?us-ascii?Q?2xP11nPLULczBjbL3MO6MdzkGhHhJMUeW3mm77/oKk0xuDkXr394uocULBSu?=
 =?us-ascii?Q?tnyZjd+iBt2+tddTQ399wNWBQ3V8lSAEuGsCrr9I+ngkfNGo8bN8BptlpA9x?=
 =?us-ascii?Q?WskmtRx6w0NEXhB247iW/h7OIlbiVlHV6cHKAJXthb1Wsj6X3+G1Y0S4Xx5t?=
 =?us-ascii?Q?FpXnsUwVL21Wxhf5alQADq8aiOEWp6L3T0iIrdQjk000xVWqJ0wkiTjZIR+W?=
 =?us-ascii?Q?2i5103cuNwb5Ye94jgOplEdRq2Jjc8xfO18MOlxIqQcUXgDTNTbfB4Bn4hEb?=
 =?us-ascii?Q?JVBBWlCmp/zInXCNmhbUkWK2qqMZzoPlGRDd5lfK6gJFIpXD7QbqRgiUtbwS?=
 =?us-ascii?Q?+GokfiE536c2n5lZtpDXv/sLNV6+4hCBiIWELwOYVrdh9NGY0PpstGblBcza?=
 =?us-ascii?Q?I45ah2aIu6tFpt736QM/MaemR9HhUaAGjBWhZbDa3Rnt67bQb8e426kK+JwE?=
 =?us-ascii?Q?GuCWXMAORB33mYyvaCABwOGOxNMqxbSzb3TB5OY2M21MG/6Uzt+cHhzkAyHi?=
 =?us-ascii?Q?2xfx0Zd815HmVh9KMNBM7WzrJ8OJily3y+nUXjdRECw0/lPds1U36xF7Wjw/?=
 =?us-ascii?Q?6TpHJQI7dyqGFO/hGVjvmTOMFoVKmOuFrHQyNG5Mvr2EMPwb0Gm1Sbrqm9kA?=
 =?us-ascii?Q?mTv6zydYN1EeKizadAXicTwpuu06Lmyj2Vi/T0D/ZsAr6CIOa4Mp+o2cIsin?=
 =?us-ascii?Q?DHYBYt1vmzAvKhtQtR/xClsUoDLkF+djHIuR26iVmf9xOgE63kl4c8SVydlr?=
 =?us-ascii?Q?ghbmcCdFi9XJk5fd3g15D9RMoICqHb71oeE9MqKpENNt+5sL0lKHMVKROtE7?=
 =?us-ascii?Q?oAodBVTwjKCF1EkLknTlK4kIIH8BUgcTjBmoPXTxJum1HWWDv90i5E7DCuCB?=
 =?us-ascii?Q?7P0DMxKZIhnHTGAHoNTYARLCv/9m?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3bcHFqkJk7L1qKA6MdbntO/o8DXKkT7PrSZ8MAZ4T1iwj6cXtPI6X9Qn9PZ?=
 =?us-ascii?Q?+RZnNx9GcMngNhn2ww+hEdBWKxp7TDIEGo8plfDnIyXdepzHoNjJLD/go2YT?=
 =?us-ascii?Q?GBux0nHGqH7txRKi1yBlFqM5IAdHt+hGRc3A0/bR9Q5pycOaplC54cTC+j4U?=
 =?us-ascii?Q?yxdsuxK+ELNBjKMudVBdDHtKjDIvHS8RCIVVxe7ThD3pPoLdhTDXpqKClH9g?=
 =?us-ascii?Q?Nsk3ATSvH70Ss/zG1q4Z7ff4AZ3eE0HIvDVxHpv0mOnH/7JQknqBjI2VxWIt?=
 =?us-ascii?Q?BURcm2Jrj+jZo/EuaW5lr4vgPnj5xLudgkYU2+ohFrOX5XtDCqjJDKcjsM3Q?=
 =?us-ascii?Q?FIk6C/kk1TWv0/MRBd40r9vpm27o43pmsq17wOeyGP95OPAFIFqvUtkClAsV?=
 =?us-ascii?Q?TNtGXh0Hje+L5rbdlKq3FV1ssQuL2A7ZYcLlOrhsTbYD9nvySssyCeMkFZuF?=
 =?us-ascii?Q?VApdUJQ8cbz0S5EeA2EVtLh+izHVTZrUAxEPEU9cqeUrOuguXQ9OF0ztQ+6u?=
 =?us-ascii?Q?k0lo8xJk9/BNzYe1atqgHvDYL9gcz9mc9072/GYhSv4MycY2Lb3R60rKNoTr?=
 =?us-ascii?Q?LRMQcjrxuC3qdpmYCKynSEvpmWOXUcVd4HVYFhDVHVMAsjk9VBzimn67wbec?=
 =?us-ascii?Q?VmYezt4NH6kgHfdZcYpdQYv+j6KvpkxPa7E1eiEWnbGHr9ZL22mZBdVLTjmI?=
 =?us-ascii?Q?JQuxWSG98NB2dbh7NUXOfEbiktCfKLwVS2bXuHeXDrJQWUKpZAeVVd3dXW/o?=
 =?us-ascii?Q?CygxbwdgpUx76eWJFCzhAOJRyVy6EUzUdRYgT9u0IsEChKmu3xvK5OzZ+MkU?=
 =?us-ascii?Q?I1ueIbwcqPlNODT/NME/IJJ4e3OKcqv8VXu7hdDnahIlCRQul366VMVPQ5IM?=
 =?us-ascii?Q?U14Ht/lrvmY+lTdZqdogdgGvb8q+qWGwKnMKvWNyjrWGKmCchgn2PerIVBrW?=
 =?us-ascii?Q?xjJtmsUREK1lRquK1mcTgE81X5wuuGkiWlPXNWTtizUc67150QHKBAOxySfc?=
 =?us-ascii?Q?E4hiMW4PV3DCWr35TYvzLUgOjT2cdAqemKThn9R2PkvaT5TMSIt4eGcb4YGv?=
 =?us-ascii?Q?JlOAKc/9Sj2eLvqITpYwUcvqacDXiHrS2iQVTsCdhNK/cXanxM6OkrD4mdW2?=
 =?us-ascii?Q?OZsdeFRMYvAS8Q9S67dekJQTxPtjMU/atMNAd1t4ehpGZA5gc8aw2clCNwd8?=
 =?us-ascii?Q?RWlEEnrI1sxAHYpR0ovCth9wUZyi9yhaV+ed2Rp0likbqNkYp/Cu/IAzeYPD?=
 =?us-ascii?Q?X4vVyhn2qUWT9Re4dycZ5uJi+IWiE1JwMK1V03fDND3p8UaEUNAuiP3jAf8W?=
 =?us-ascii?Q?lhEEUMHGHXHP7yTjA+PuPhd3bePl6GTEibLCnsIxLsCDS06l7KpN0nOJRU4u?=
 =?us-ascii?Q?iybgsWvX6cWyHyC3aYUKMtNxhEId3e+bLCn3cjBCflfwfL9NlU+YW5wgPfuk?=
 =?us-ascii?Q?49JHwLLzbHVxDtPkxbdemb4KyRXjdsdAhDxOqFb8CLJ1L50Nsos2pgi2VWEg?=
 =?us-ascii?Q?unGNqQs7vlAyKD/l4WspYyFOq2k8i8GYdsWGcVUTPIqDn2WNFj6RJsgQXtLl?=
 =?us-ascii?Q?vqcj/Wh+tsIIHKqWwKM55LbTDprWun4mfhopQp8I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07668b60-b402-4820-8b51-08dd5638391b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 07:36:03.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v45b1ml3A7cRCXECiKHjlxEFU6h01hWc1WUV/pG7QGwDRfnhCg/ra8nRrzxuvPif3Nst6uKcZMcrRku2xRQPPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8543
X-OriginatorOrg: intel.com

On Tue, Feb 25, 2025 at 07:04:55AM -0800, Sean Christopherson wrote:
> On Tue, Feb 25, 2025, Yan Zhao wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 58b82d6fd77c..045c61cc7e54 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12890,11 +12890,11 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> > >  		mutex_unlock(&kvm->slots_lock);
> > >  	}
> > >  	kvm_unload_vcpu_mmus(kvm);
> > > +	kvm_destroy_vcpus(kvm);
> > >  	kvm_x86_call(vm_destroy)(kvm);
> > >  	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
> > >  	kvm_pic_destroy(kvm);
> > >  	kvm_ioapic_destroy(kvm);
> > > -	kvm_destroy_vcpus(kvm);
> > >  	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
> > >  	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
> > >  	kvm_mmu_uninit_vm(kvm);
> > After this change, now the sequence is that
> > 
> > 1. kvm_arch_pre_destroy_vm()
> > 2. kvm_arch_destroy_vm()
> >    2.1 kvm_destroy_vcpus()
> >    2.2 .vm_destroy hook
> >    2.3 kvm_mmu_uninit_vm() --> mirror root ref is 1 upon here. Zap the mirror
> >                                root and reclaim SETP page table pages.
> >    2.4 .vm_free hook
> > 
> > Since TDX needs to reclaim the TDR page after reclaiming all other pages, we
> > currently added a vm_free hook at 2.4, after 2.3.
> > 
> > Could we move kvm_mmu_uninit_vm() before the .vm_destroy hook and after
> > kvm_destroy_vcpus()?
> > 
> > Or move the .vm_destroy hook after kvm_mmu_uninit_vm(), e.g. after
> > kvm_page_track_cleanup()?
> 
> I would go for the first option.  I'll tack on a patch since I need to test all
> of these flows anyways, and I would much prefer to change course sooner rather
> than later if it doesn't work for whatever reason.
> 
> Is this comment accurate?
Yes.

And since tdx_mmu_release_hkid() is called before kvm_unload_vcpu_mmus(),
patch 4 in this series is required by TDX. Otherwise, the list_add in
tdx_vcpu_load will cause corruption during tearing down, since
tdx_mmu_release_hkid() has already invoked tdx_disassociate_vp() on all
vcpus.

kvm_unload_vcpu_mmu
  vcpu_load
    tdx_vcpu_load
      list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu))


So, maybe a change as below is also required by TDX in case vcpu_load() is
accidentally invoked after .vm_pre_destroy.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b67df0af64f3..183192706ced 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -703,7 +704,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
        struct vcpu_tdx *tdx = to_tdx(vcpu);

        vmx_vcpu_pi_load(vcpu, cpu);
-       if (vcpu->cpu == cpu)
+       if (vcpu->cpu == cpu || !is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
                return;

        tdx_flush_vp_on_cpu(vcpu);



> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1e5f6f820c0b..f5685f153e08 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12874,13 +12874,19 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>                 mutex_unlock(&kvm->slots_lock);
>         }
>         kvm_destroy_vcpus(kvm);
> +
> +       /*
> +        * Do final MMU teardown prior to calling into vendor code.  All pages
> +        * that were donated to the TDX module, e.g. for S-EPT tables, need to
> +        * be reclaimed before the VM metadata page can be freed.
> +        */
> +       kvm_mmu_uninit_vm(kvm);
>         kvm_x86_call(vm_destroy)(kvm);
>         kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
>         kvm_pic_destroy(kvm);
>         kvm_ioapic_destroy(kvm);
>         kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
>         kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
> -       kvm_mmu_uninit_vm(kvm);
>         kvm_page_track_cleanup(kvm);
>         kvm_xen_destroy_vm(kvm);
>         kvm_hv_destroy_vm(kvm);

