Return-Path: <kvm+bounces-16299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 965A08B8614
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8D1BB221C6
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13004D13B;
	Wed,  1 May 2024 07:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHawHQIX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83B4C3C3;
	Wed,  1 May 2024 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714548616; cv=fail; b=KhLMR7bz1czYjuqHEQBvNz/AniKUOlXz3Rj8X60bShGw1dkN+jvI0tcl0A0GJMrQ6rdtG+spTR7jbViA3wCzO8sWvCtIilrx4sNNq1h6vJh4a6p3e1uT34H2N3mSXkKxxiA99ad6VUGShdewDWcpsaIDV86Un2NjwXlp4fTtdR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714548616; c=relaxed/simple;
	bh=7fZo+oAMDEY/QYPzlYqQtPep96LitC3uEn3/2HNC7Fs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GfjZLpfCcEbxQccBxoqcmvDosWb6M3Q79gJGlZXTPOVrCKB7vqa8NiGgyIvPo7zRtUGTEotwGQPYyJLACPEgGA+NzS/DPlB+uYw/iEEzHw4mAHnD4EcI/9aU7648V667lluzkInLss6N0M1S9RBHHhu6kcbCseaLB+ILf4DVyVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHawHQIX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714548614; x=1746084614;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7fZo+oAMDEY/QYPzlYqQtPep96LitC3uEn3/2HNC7Fs=;
  b=LHawHQIX2na+lUASDsJLmc28Sin1xHmRGPRdDBPZpGH8p69PX9ghHK2L
   MT3e98rtacMEcN75ojiy2FVu0Yx132IGvmGvAGPjtPivXcdKr7DJKwLFT
   KgBo4ay0eloeTQMRxpDTXRZ6/sKYGVT+JrCEZIGoMV4rzciJcQINRTby3
   w+EF11hlNotbmnU6KUUed3CQy2ge9RWtu2UOowUebDUKvYLwrZM62zpWQ
   tfe6WiOwI8pnwhjJE1yjemCU4T/8not5LbVy+4ZZJ7z5Ed7FRs0Lwdb8W
   w0X4/hLz++f11+PJj62+2HH7i9thh6CG9Yl59XMU6Crq9tvnro24OP5uQ
   Q==;
X-CSE-ConnectionGUID: 7sh0oy3CQHy7Dkv3V+AiMQ==
X-CSE-MsgGUID: 0ggv4twhRfiux9wn4Oz7rQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="13199578"
X-IronPort-AV: E=Sophos;i="6.07,244,1708416000"; 
   d="scan'208";a="13199578"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 00:30:12 -0700
X-CSE-ConnectionGUID: fSRh2XX3QgWYuhx99/qoYQ==
X-CSE-MsgGUID: IZkmU8eYRwybGOpNTofdTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,244,1708416000"; 
   d="scan'208";a="27321246"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 May 2024 00:30:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 00:30:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 1 May 2024 00:30:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 1 May 2024 00:30:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLv/xIW86ZnRAnb8hKSJSxSpmkFXeCpEh8TqTwfg6mtRCMFTKGdfHASxMSY5FjhkilDCPDyb0n+VYzBS8wsj0USqE4c401yqtjkOj/z9L6hOhl7VeTBJp09dZJAAQ4O/1zYxCVuBpvmad9/GFMN7Rs03yUZo4RK6jcY534sqa6ZOzaI4QbU8BV048kb995kTOqFWibomRWCIx6HpwatCcvJDF75MUXjuISk2+XVwQqLeW4Lm4Jkr3dyV77cA15MSSwTBSUGTCLEwZ7QdiXP+Dcb5TTXZ7jge3w9ntU70zm9XGFzv47/8OUCPUh7dwCothSdRBsPNXCDqjiv+Uql8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuMieYIG1IeXL3ePce6e6J/Yk/71v477uope2gHREh8=;
 b=UjZhZvLIq+advcoo9f7Mjb8jxrxBfcuWT533//A1OE6fPOwzKjo5uPqRNHzeMdsxc9TAlx0dhb2I8g+hCFH8ifnGatfvMRjKTknVJ6PqlZKe6ArW441+SRd4MeN3Jx2kO8JBrZwMWYSINE/DJJCPmgMJUrQs/aPuFUQ6IxE23mqii0y9x8gb5a50jhnqE+1T0VnX7CNCxUFiueBv2Ivqt/Gp2dmz0YQj0qIRMlEocejrRTw20yfq47IAsy12c8AfcxiJUILTEmj+wYeDwLkXUqmptHyrbtA3LOTI4FZTb9Os1aC5LYblfB6ZwzyKTRaYBIbHb5qSxhaE88e6mChAdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB5142.namprd11.prod.outlook.com (2603:10b6:510:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 07:30:04 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e%3]) with mapi id 15.20.7519.035; Wed, 1 May 2024
 07:30:03 +0000
Date: Wed, 1 May 2024 15:29:51 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, <iommu@lists.linux.dev>, Thomas Gleixner
	<tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	<kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
	<joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
	<bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
	<paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe
	<axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, <maz@kernel.org>, <seanjc@google.com>, Robin Murphy
	<robin.murphy@arm.com>, <jim.harris@samsung.com>, <a.manzanares@samsung.com>,
	Bjorn Helgaas <helgaas@kernel.org>, <guang.zeng@intel.com>,
	<robert.hoo.linux@gmail.com>, <acme@kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH v3  03/12] x86/irq: Remove bitfields in posted interrupt
 descriptor
Message-ID: <ZjHvb7MjnbuskaVH@xsang-OptiPlex-9020>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
 <20240423174114.526704-4-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240423174114.526704-4-jacob.jun.pan@linux.intel.com>
X-ClientProxiedBy: TYCPR01CA0025.jpnprd01.prod.outlook.com
 (2603:1096:405:1::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: 5330ef44-6cd4-4d3d-b6e0-08dc69b0841c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GNuFl97xflVfa25ipRTJWNEBOI/LjfFDUeF5ytlXiQQ5eipvIRE7G/VOuUWF?=
 =?us-ascii?Q?F7mDwtJo7byRRWbWGwg+0fP9iBiND6+RS0U3qfcFerDVZZbfdEUOc6vrPUvn?=
 =?us-ascii?Q?qkSj7WLyIluviQtpEIk5G13TO0FiMPGdt/5Ugn5S8Zv7j1WOjKlMPh0xPUxB?=
 =?us-ascii?Q?+X1ORklDxsHc6FwRUzLkoLvwJ/Eu1s7kz+Ao6VdA0KpgWFQqk8waZNzR0LwO?=
 =?us-ascii?Q?uF4iJttelqLSZ7eFwlk/WnuQK9mAYV7l+SP6C692pzFjqc5WzvuJYH0fMdDk?=
 =?us-ascii?Q?QeS2OzcvkJUHjlItfzUQri3jZJQKFlYLJ4MhV3rasyi51tsehMqktrZds4PJ?=
 =?us-ascii?Q?GX0zS8Y8uV3Bycfswutmv/VZHHP8HNiOryM2gW0XoEfUlRSNkzQiBjNdZPYQ?=
 =?us-ascii?Q?8tmsNDfTsEjTsR5fR7jOQLxtfTBoWIMqmomAv9HpZAi+8jEtOu49I6A15wdO?=
 =?us-ascii?Q?3a2NL24jTW1DYBY4YpxfK4M+oXqhGvrJzr54btBLyK2vX36PNTzaDvUq+Set?=
 =?us-ascii?Q?scCaA/BlSBD0UY7A8uvu6Yxa9Sy3PBm00Br+q62mU2So2MJJXsGl88GifPct?=
 =?us-ascii?Q?2gISaCU5IytxBw/IFUVt6/oNrvnJVZTVdYVO5OTYTUVOcwRGsuQt50zqjJcZ?=
 =?us-ascii?Q?ukojiLsKjV8XM93Cid+5gPtDSlbkHmxwBDfeQW1AgTjwuPJG3PahGksg8rKF?=
 =?us-ascii?Q?eYry/25wuCfzjSr5mciVnoSnIAADLT3I5RQNht265QirB/Pm3AD4ONUjoft9?=
 =?us-ascii?Q?Pg/XpjyScDr2fj2aHzbHmKoUM1FQRaUXnXky37UFszG0mwNoFUJd2H3ooFQ7?=
 =?us-ascii?Q?Qz86HpJrVM1khGZ61wyaj81zn/e5eUbrdBo9bvViAgT7Hl5glqGi6t0vL0xS?=
 =?us-ascii?Q?gAIFtcD4aVTbQp2+yPlyMbb1/IL2klchyZZsWJXlbXVapqOoAdmvrK6WIVzV?=
 =?us-ascii?Q?zNHeCx83WSZisSBtVkFZ2qwLQ/P/8U631VRrhh8od2OR0ZFqjFlkrJ1MGTIs?=
 =?us-ascii?Q?Zoe0sZWf4qKIXRG66zPm3Ys8UgGRsV4iqtSW0vcDaw0v8jzp7sxJn18I4cOg?=
 =?us-ascii?Q?QYXhMaPOpp8D3JTnknEsl8c5BwAK/wsurli2CnyUe14+OpBWT9dEmL7JSgT1?=
 =?us-ascii?Q?rRSBJZigAz9h80UO5vQhOk4J6SPPqCnveQBao17ikPjNeX/3yYU0hK7buoXs?=
 =?us-ascii?Q?O9KivvmxmlnchadpUfMEdrZziIMAaDU7s4dd9UGBzkcKf9sqNM4NVnNGYIg?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5pzWfdjGKPtMeyrdetdmAXFdAuPvduRuVvoTQjz6V/kK497NLx4/9w7Q3U7m?=
 =?us-ascii?Q?vUB14ImFS6zjo29wk7TMotw8nMngLIUr6dxPfi+YmqM5DsI5bWlH8ZrXEypH?=
 =?us-ascii?Q?QiN3tgZJRzDM3QDS1nc2JpZ5UGF8z4WVYyyv6ZsMBeenm6VPUJ+YDopreBuL?=
 =?us-ascii?Q?IF4r4LTyB9hcRarhk/U5KlqenO45ppc2P+6ME30HV+uqCwIY6IKku0tewvld?=
 =?us-ascii?Q?jpHIJy+vtX+nl0nBZ/RXlVWPl/c8hMBSyFv7i1VKvwhzmb18YWxfZ+wN5kQB?=
 =?us-ascii?Q?cIsBOg5pOfy/nVji5gNy1JCgmOIpfEfM+VnW6J5gexLLrX9N+Lu1sJixtAaV?=
 =?us-ascii?Q?lLQ/3FibKMzCA+lzvFVwc9lpR90aJMBSUziLlQfwdlyWw5uc2sO6GuVVLQZz?=
 =?us-ascii?Q?7JNUQkKbGAGT8+yyXwwV8i/u0otSd1QIoq6hVYefriTn4R8j0e5yzPmwHHli?=
 =?us-ascii?Q?z71NseHO8P56eAwkG6pTvHd7jnYRCuxjNQJUGXxLTUjTMJqXZUhG2YHkJWP+?=
 =?us-ascii?Q?r9nOx85Hmy210AJBdNwQrEQsfN6BtQ0Br0MFiKjVG4lv+xgN0uTlIkT62TeM?=
 =?us-ascii?Q?cJboOSwwZmr9I25tL0HvHYEZiZ8uEhAmVVpFbEq4mLvzdq2FThYoUD1PmwzY?=
 =?us-ascii?Q?v2VRhdLiTong9W4cQ8t9QYzDlQnjRKy9BMVdx68gQiE5hpQfsH+LvrucI3DH?=
 =?us-ascii?Q?2uNtHKnojw6sEWFhqEFObj9R5/RxrDPAZfFVsExhQlbrrVfFelDkpFv8W/TZ?=
 =?us-ascii?Q?sDXeTk2FaIg0FqJw7M89DQcSY+n7LpnfBxOb0mr40b0RWxBAoDyT4KCenlwU?=
 =?us-ascii?Q?mN2iBS+B9XcwH+igJFkZ3YMXUJ//Sga2ozl6rNzs6GHnGSIq4o3I0SwlgJWy?=
 =?us-ascii?Q?gA7RqbedPag14B+W1jnVoEMVO7lHW5s7WGXJtBDcJk+Vhxzde1MoaAvKUK0K?=
 =?us-ascii?Q?3nKqdtispz4hZ9YqvNQXDPRm5XoTloTK3/M5n1r12f/qvAv0m3D9GdXWATQI?=
 =?us-ascii?Q?2rWYbuyCUGStKXnjUKCXsqTcCEa+wHa4xKvDrvYf1bPZX5eczqwx9F47ALQi?=
 =?us-ascii?Q?yGrbahw4Hc1aihZ5JMkr/E0ZrRys2MsUIwnMKzrHNyIGk14eiCS/dPUcbiOA?=
 =?us-ascii?Q?LXgv6VPdUJ1erWqeDnE6l2vsKEYhkZbN2Nak6vYKXv1s05FQJkGeFoBggBfZ?=
 =?us-ascii?Q?GpbqtpYqTGDOzJxYKJqwLcEodC0Z4jDuIwCDLK8yEsB8mfDzznXWNjTVF6Kq?=
 =?us-ascii?Q?0x37xmGaxBDcGW+2pzFpB+/eE2HIMLV8l+vqoTC2XkVKtYz2mIqG1dy0ZEPv?=
 =?us-ascii?Q?OpeBhfGoSH51P8TBchK9Jyd0NRgnDqWrdhvKpb/lqQQzWkGg0mckmIZFWwIq?=
 =?us-ascii?Q?RfpEtRClsCTfd8t5DtKkKnlWJeewWxXhirt4BdDTr1SDdFPI61/q3iAYKUjF?=
 =?us-ascii?Q?oZ8cJMa0SIy4+opGsTGdgwYGtM4D6uWoC69P+M65JkefZYi72OaASaD0oUMs?=
 =?us-ascii?Q?Nta4LY3DfPI+Uwa5s+/yOmyNxnJq973GsjbrRMuQVPtW08rmA5522xBGYtC7?=
 =?us-ascii?Q?m4yfIiNbE5PEK8fkX1cysVDKmD9+YkNhhkCnETU8B+FIgOngTOp1WMfzo2NY?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5330ef44-6cd4-4d3d-b6e0-08dc69b0841c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:30:03.4534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTaN+HlXOd7ya30XWpKNR/TsQ6p7x5gUvJoxZRcQECPJqOXoBPnUy/p9GwQ76ZXpnI9D4D9jQSTS7AKxsoOXwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5142
X-OriginatorOrg: intel.com


hi, Jacob Pan,


On Tue, Apr 23, 2024 at 10:41:05AM -0700, Jacob Pan wrote:
> Mixture of bitfields and types is weird and really not intuitive, remove
> bitfields and use typed data exclusively. Bitfields often result in
> inferior machine code.
> 
> Link: https://lore.kernel.org/all/20240404101735.402feec8@jacob-builder/T/#mf66e34a82a48f4d8e2926b5581eff59a122de53a
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> ---
> v3:
> 	- Fix a bug where SN bit position was used as the mask, reported by
> 	  Oliver Sang.

we tested this verion, and confirmed the issue gone

Tested-by: kernel test robot <oliver.sang@intel.com>


below just for reference.

for previous version, we noticed a
"WARNING:at_arch/x86/kvm/vmx/posted_intr.c:#pi_enable_wakeup_handler[kvm_intel]"
in testcase: kernel-selftests

Call Trace like below:

[  399.225452][ T8098] ------------[ cut here ]------------
[  399.232475][ T8098] PI descriptor SN field set before blocking
[  399.232514][ T8098] WARNING: CPU: 184 PID: 8098 at arch/x86/kvm/vmx/posted_intr.c:160 pi_enable_wakeup_handler+0x421/0x5f0 [kvm_intel]
[  399.254685][ T8098] Modules linked in: openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 intel_rapl_msr intel_rapl_common btrfs
+blake2b_generic x86_pkg_temp_thermal xor intel_powerclamp zstd_compress coretemp raid6_pq libcrc32c kvm_intel kvm nvme crct10dif_pclmul crc32_pclmul
+nvme_core crc32c_intel t10_pi ghash_clmulni_intel ast sha512_ssse3 rapl intel_cstate dax_hmem crc64_rocksoft_generic drm_shmem_helper mei_me i2c_i801
+crc64_rocksoft mei drm_kms_helper i2c_smbus crc64 i2c_ismt wmi ipmi_ssif acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter joydev
+binfmt_misc loop fuse drm dm_mod ip_tables
[  399.321529][ T8098] CPU: 184 PID: 8098 Comm: xapic_ipi_test Not tainted 6.9.0-rc1-00008-g037ccaed5dc5 #1
[  399.333325][ T8098] RIP: 0010:pi_enable_wakeup_handler+0x421/0x5f0 [kvm_intel]
[  399.342631][ T8098] Code: e8 a4 5a 7b c0 e9 b2 fc ff ff e8 5a 5c 7b c0 fb eb 93 bf f1 00 00 00 e8 dd 9c 29 c0 eb 82 48 c7 c7 e0 c6 ee c0 e8 0f 2f 37 c0
+<0f> 0b e9 e7 fe ff ff 4c 89 f7 e8 00 6a c8 c0 e9 cd fe ff ff 4c 89
[  399.365742][ T8098] RSP: 0018:ffa000003a527780 EFLAGS: 00010086
[  399.373626][ T8098] RAX: 0000000000000000 RBX: ff1100247c23c740 RCX: 0000000000000027
[  399.383668][ T8098] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff11003fc3030c08
[  399.393759][ T8098] RBP: ffa000003a527908 R08: 0000000000000001 R09: ffe21c07f8606181
[  399.403834][ T8098] R10: ff11003fc3030c0b R11: 0000000000000000 R12: 1ff40000074a4ef4
[  399.413901][ T8098] R13: 0000000000000000 R14: ff1100247c23e4a0 R15: 00000000000000b8
[  399.423969][ T8098] FS:  00007f10de2006c0(0000) GS:ff11003fc3000000(0000) knlGS:0000000000000000
[  399.435126][ T8098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  399.443651][ T8098] CR2: 0000000000000000 CR3: 000000210b958004 CR4: 0000000000f73ef0
[  399.453753][ T8098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  399.463835][ T8098] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  399.473912][ T8098] PKRU: 55555554
[  399.479005][ T8098] Call Trace:
[  399.483812][ T8098]  <TASK>
[  399.488224][ T8098]  ? __warn+0xcc/0x2d0
[  399.493903][ T8098]  ? pi_enable_wakeup_handler+0x421/0x5f0 [kvm_intel]
[  399.502643][ T8098]  ? report_bug+0x261/0x2c0
[  399.508825][ T8098]  ? handle_bug+0x3a/0x90
[  399.514817][ T8098]  ? exc_invalid_op+0x17/0x40
[  399.521191][ T8098]  ? asm_exc_invalid_op+0x1a/0x20
[  399.527938][ T8098]  ? pi_enable_wakeup_handler+0x421/0x5f0 [kvm_intel]
[  399.536677][ T8098]  ? __pfx_pi_enable_wakeup_handler+0x10/0x10 [kvm_intel]
[  399.545747][ T8098]  ? __pfx_lock_repin_lock+0x10/0x10
[  399.552740][ T8098]  ? newidle_balance+0xc85/0x1300
[  399.559408][ T8098]  ? __pfx_perf_event_context_sched_out+0x10/0x10
[  399.567652][ T8098]  ? lock_acquire+0x432/0x4e0
[  399.573959][ T8098]  ? vmx_get_rflags+0x26/0x2c0 [kvm_intel]
[  399.581527][ T8098]  vmx_vcpu_pi_put+0x1d3/0x230 [kvm_intel]
[  399.589119][ T8098]  vmx_vcpu_put+0x12/0x20 [kvm_intel]
[  399.596205][ T8098]  kvm_arch_vcpu_put+0x49e/0x7b0 [kvm]
[  399.603463][ T8098]  kvm_sched_out+0xb2/0xe0 [kvm]
[  399.610100][ T8098]  prepare_task_switch+0x321/0xc40
[  399.616863][ T8098]  ? lock_release+0x1bf/0x240
[  399.623146][ T8098]  __schedule+0x5a6/0x20b0
[  399.629125][ T8098]  ? __pfx___schedule+0x10/0x10
[  399.635581][ T8098]  ? __pfx_lock_acquire+0x10/0x10
[  399.642228][ T8098]  ? kvm_apic_has_interrupt+0x9c/0x160 [kvm]
[  399.650034][ T8098]  ? lock_acquire+0x432/0x4e0
[  399.656267][ T8098]  ? __pfx_lock_acquire+0x10/0x10
[  399.662905][ T8098]  schedule+0xe2/0x2a0
[  399.668478][ T8098]  kvm_vcpu_block+0xd1/0x1c0 [kvm]
[  399.675308][ T8098]  kvm_vcpu_halt+0xee/0x900 [kvm]
[  399.682018][ T8098]  vcpu_run+0x50a/0x9d0 [kvm]
[  399.688346][ T8098]  kvm_arch_vcpu_ioctl_run+0x377/0x1430 [kvm]
[  399.696254][ T8098]  ? lock_release+0xe5/0x240
[  399.702428][ T8098]  kvm_vcpu_ioctl+0x34c/0xc40 [kvm]
[  399.709341][ T8098]  ? __pfx_kvm_vcpu_ioctl+0x10/0x10 [kvm]
[  399.716821][ T8098]  ? __lock_release+0x103/0x440
[  399.723960][ T8098]  ? __fget_files+0x1c7/0x330
[  399.730219][ T8098]  ? __pfx___lock_release+0x10/0x10
[  399.737750][ T8098]  ? __fget_files+0x1cc/0x330
[  399.744028][ T8098]  ? __fget_files+0x1c7/0x330
[  399.750289][ T8098]  ? lock_release+0xe5/0x240
[  399.756461][ T8098]  ? __fget_files+0x1cc/0x330
[  399.762719][ T8098]  __x64_sys_ioctl+0x134/0x1b0
[  399.769077][ T8098]  do_syscall_64+0x93/0x170
[  399.775146][ T8098]  ? do_user_addr_fault+0x477/0xcb0
[  399.781989][ T8098]  ? lockdep_hardirqs_on_prepare+0x279/0x3e0
[  399.789654][ T8098]  entry_SYSCALL_64_after_hwframe+0x6c/0x74
[  399.797192][ T8098] RIP: 0033:0x7f10de88bc5b
[  399.803079][ T8098] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05
+<89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  399.826105][ T8098] RSP: 002b:00007f10de1ff9c0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  399.836565][ T8098] RAX: ffffffffffffffda RBX: 000000001a5418c0 RCX: 00007f10de88bc5b
[  399.846521][ T8098] R


> 	- Add and use non-atomic helpers to manipulate SN bit
> 	- Use pi_test_sn() instead of open coding
> v2:
> 	- Replace bitfields, no more mix.
> ---
>  arch/x86/include/asm/posted_intr.h | 21 ++++++++++++---------
>  arch/x86/kvm/vmx/posted_intr.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c             |  2 +-
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
> index acf237b2882e..20e31891de15 100644
> --- a/arch/x86/include/asm/posted_intr.h
> +++ b/arch/x86/include/asm/posted_intr.h
> @@ -15,17 +15,9 @@ struct pi_desc {
>  	};
>  	union {
>  		struct {
> -				/* bit 256 - Outstanding Notification */
> -			u16	on	: 1,
> -				/* bit 257 - Suppress Notification */
> -				sn	: 1,
> -				/* bit 271:258 - Reserved */
> -				rsvd_1	: 14;
> -				/* bit 279:272 - Notification Vector */
> +			u16	notifications; /* Suppress and outstanding bits */
>  			u8	nv;
> -				/* bit 287:280 - Reserved */
>  			u8	rsvd_2;
> -				/* bit 319:288 - Notification Destination */
>  			u32	ndst;
>  		};
>  		u64 control;
> @@ -88,4 +80,15 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
>  	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
>  }
>  
> +/* Non-atomic helpers */
> +static inline void __pi_set_sn(struct pi_desc *pi_desc)
> +{
> +	pi_desc->notifications |= BIT(POSTED_INTR_SN);
> +}
> +
> +static inline void __pi_clear_sn(struct pi_desc *pi_desc)
> +{
> +	pi_desc->notifications &= ~BIT(POSTED_INTR_SN);
> +}
> +
>  #endif /* _X86_POSTED_INTR_H */
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index af662312fd07..ec08fa3caf43 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -107,7 +107,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		 * handle task migration (@cpu != vcpu->cpu).
>  		 */
>  		new.ndst = dest;
> -		new.sn = 0;
> +		__pi_clear_sn(&new);
>  
>  		/*
>  		 * Restore the notification vector; in the blocking case, the
> @@ -157,7 +157,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>  
> -	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
> +	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking");
>  
>  	old.control = READ_ONCE(pi_desc->control);
>  	do {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d94bb069bac9..f505745913c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4843,7 +4843,7 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  	 * or POSTED_INTR_WAKEUP_VECTOR.
>  	 */
>  	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> -	vmx->pi_desc.sn = 1;
> +	__pi_set_sn(&vmx->pi_desc);
>  }
>  
>  static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> -- 
> 2.25.1
> 

