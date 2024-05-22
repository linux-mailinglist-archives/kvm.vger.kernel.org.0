Return-Path: <kvm+bounces-17915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D01CF8CB9A2
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86547281B3C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B073B2BB;
	Wed, 22 May 2024 03:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAggpOGG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A973433C5;
	Wed, 22 May 2024 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347891; cv=fail; b=l6LQQrGiXgpjE+3oADAw+8ip7x8aqRxlEeBbY54NRT+d8KuqJmMB4GyK/LJAEahTX1vgtmVaPFWdjmDjVNCKjzYdKfNz8y/Qs9wqXQj2BSx3Gm6Sf0zbP6S6lSovXLpiwA+54TDYLny5qa8PggRwXB9m87TE5x8ilHEZZlknA0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347891; c=relaxed/simple;
	bh=1Xxoxe1S004Kw+4vt18rGHUJFAuQxLAvmVtUADmKgi8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LU7IGhzSKPS74K0k+ytk4hEScfM/VGW5EXOWrk8Z7VpirCQjiOsWbZZX9ggDgSawsIo7XYcGYzl1k6IdPBk+xr3fgVOzRnW9vBwdeTAlmi9S+p0+FuKAPjA0iQb/vy2HpRNN2/+AropftYRC8db7TgI5uYBl6KrWKTa9MQr+ERI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAggpOGG; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716347888; x=1747883888;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1Xxoxe1S004Kw+4vt18rGHUJFAuQxLAvmVtUADmKgi8=;
  b=HAggpOGGTVgdGtyTqVo+l4UQkk8Fa9dJaAfv6ETMn4dwwdzIbVimX4jQ
   fNv0AUQrkbBSv0VokwMYgrT+aSGXq5MQnuJO4xbjvByT0og2s/KX1+DuP
   V6zUnQAsRvbaI8o0OZM0e76SExFM2l4nbzRsgByIkbK7mHQxLCseLVNbr
   JDr1u+lK/W78cP6hX5ICeEyCcpeeIxsR/Tmjt/L9b14d5MEAjXXrSEJly
   IeRmujg/51RQ4Z+MIqfj2oqaTWimcJGsPM5Tt0iamGJqbIGpZ3P+o/K78
   kKdJIRjAQyeZGXuKJGkYw6DHnMSqyYmsmWcpL9YlLjqQyiy4mDNketyMG
   w==;
X-CSE-ConnectionGUID: u3a71QdPQ2Sq2leQkhn08A==
X-CSE-MsgGUID: DvedMratTGO9kFxx89E/yw==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12363798"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12363798"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:18:07 -0700
X-CSE-ConnectionGUID: p+oUnmuSSuWexp8GsvF63Q==
X-CSE-MsgGUID: b4FUESJ4TX23KQrTD+a8mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37894631"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 20:18:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:17:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:17:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 20:17:57 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 20:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH7xiA23ACCQfcKl9MpjN04z1Jtpyee+Ljve7GZC70FpX8ohrNno9d6OO7vGNQl+L0rQ0ShXjPuNC01azJfWmedE6BcrsUjxk3ScLtcfKfUSo9GCSr0rXVS0uAJ7lO7hsmxAnOpGG1+17lhqnrLiclUfbbeyztcmOL40vcKqATFpB+eTGVMWme9NjgcHMdot89/yzLazcx9fSV+G5KbDx2ItlSWnFlrBdRoRBMQ0VfEjuZ3jy+sH6h9oDNlZlVSNLV5H7wTxzmlY/DLUKng7rnREnbcze2YUWVOoA9k0yJPdIvTm5k451Bjd3xNYGgSJQ6+AcbUUz5Z99r1XQuKrkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U36n+CIFCDayZO1m1MGp5HhDT4X17Y+BkrsnGzRLKTM=;
 b=KHNrsMpwkSxP79LAypWbn8g64SOJ0UE+5KLO+GDwGyYdWl9Eoa9PY4UgFE7dilagGxwMpx5Yydb28OnzYRC55zuosEXxbSSqna9kjjGA1/7GclRrywYiSRbfXDNCgygChzzEgNOdghPnWrfabBrC3Sv8h44h0/okRzhccg55OVeNYxtgJMXWKE1sFi0hC75OYfMF5LScawWBVIr4OsSDWNaOXlbchDvqcQYcV9cD8PqJUXuQFliiI4lbViZvHpveXQ+GtwbXdCsJW2GPNbK5P8xrBjA/8E3ts0/iWypO7QLtXKh+qmemkLlMHSNu/9A/889GA3V390sOz9F1FQDXfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6903.namprd11.prod.outlook.com (2603:10b6:510:228::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Wed, 22 May 2024 03:17:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 03:17:54 +0000
Date: Wed, 22 May 2024 11:17:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
 <20240521160442.GI20229@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240521160442.GI20229@nvidia.com>
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d50afea-c962-4107-a956-08dc7a0dc53f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oKCFbn/1BlNBugJ4bjQiLZvZecmY3Z/E9LNiPzDRtx0A9ffHj7PsG8hT1Qth?=
 =?us-ascii?Q?3CYzVuy1CRHCuc6xKGrVcQRtg/H1cTJwI0jfOwlNUGefvJmjIB03aEAbNPcs?=
 =?us-ascii?Q?OJ9IeplDUDzRlY3sYagwfWcX/+XJ0Dim8nnulsYDoQmOJzs6SzxxCzHbKm0p?=
 =?us-ascii?Q?jLtedKIJRsnbuqxENu4tn53i8B1GYHsPeT70Tf7gGriW6ihZItk/bBL4XTLe?=
 =?us-ascii?Q?Ijqja1tQSCOl7X9OnAFPtzOJx7QKRU5z8O8chwIhU1MQMH8nyDiG0LbDPKWn?=
 =?us-ascii?Q?JT6H707Mr6nR0yKajUkXEChtnChwKUwsaTOAhOvTkz25msLRDxo+kTdFw/8b?=
 =?us-ascii?Q?rETokDDIkJZboptuZ4SJdUSME/iA7Ri/pTmoJSxNVQlo0e9TFhM1zWn3xVvf?=
 =?us-ascii?Q?NGf7xnzUJDj5mwUotWfiKH1RRjwp6znYnHIhDJ0i265EoqMJZMGbus8tSKhE?=
 =?us-ascii?Q?pkaxnPFHKLNZyvvE2uwaamRHvOZDtcc0h0dEGVWBmgw7QW6xfrZgjCdlNlN0?=
 =?us-ascii?Q?NlI0HKGqCb6jwpaMeCTUn3uwVxF/crr/8nF0Ks/D5YNMrJotf4oORdtMbjw8?=
 =?us-ascii?Q?1oTCsQhbHdV/EdNwH0df9FT9xVww4U1WCrfo0DYloB2EZ2LdCPJygQWrCrTF?=
 =?us-ascii?Q?LY095+b8WArILuZFIlZErqFZ6T1PpCf7Uv0yQGs4ylmpuMz+SyJ0iJjrqtk+?=
 =?us-ascii?Q?JGUaiw7ertLzdG4/Tipr+VEM8ttuLZkBgBEZQUkshH8bR2wa3M0xA01zd4o+?=
 =?us-ascii?Q?Xk+BtJfc9Yml7xH6/orflmLae7ZgXg9IAGEuUTQ9Tdktbxqpxfg2Fhs1AMBH?=
 =?us-ascii?Q?S7vNvTrG8uJgJB2OoRGBxR7G6gv3oC1OQ+uKulEGCu4ot9HBRwdwUXLEqzlA?=
 =?us-ascii?Q?YMO0VzKMkC/eL3x+AERp1XZFCLcfWclFFEJi1kflWk5LUG19V/OzhXYA6hLZ?=
 =?us-ascii?Q?oF9tMjFZRq9VnHA6WggOpSsQcLB2Ck1duYbaH+JuBf2/Y6Jg2tylS1hS4ODn?=
 =?us-ascii?Q?bex2GpGDFAbvc208NuNU+g3jZNV/gEL5IWD0jyJkEQ6a6GPjdzQCe0GHKmHn?=
 =?us-ascii?Q?Zuio4ERgR9BNJSDPv4ONkBjz0ZGgyS1aJ/xZl4nLs2ZkhuP691MSl477X5Z+?=
 =?us-ascii?Q?CnUs4RgWZxWH5AoMy0BmrkVS1XdLV5mA91ouZz1+77EWg89ucUdehAsnMQUz?=
 =?us-ascii?Q?6xDP4ob7eK+HoExkeXJkKMfltSMR/Q7gBvqJ28lVmc00Dd+qV6XtNVONJRV2?=
 =?us-ascii?Q?Rabja9QpXSEf2lQ8DaaDh2yZ9242Hp7dh4KxcdJ3uQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JxVPqcynWksoOSvBtRvx17f22xTw7ugX5a0O7X7YHRYjAZX/DbV1kuDxcVE2?=
 =?us-ascii?Q?oU/YZSQrt2J0nTSoDeY4L2NiT08nTdK3k+QY57szxBrSrv555vOT/7SNgRmf?=
 =?us-ascii?Q?OlghlLGET5YIXoQRpngp2tjPIsSHb2wfNHXcxEWWQbScwXXihTvbA5rvTr2i?=
 =?us-ascii?Q?WFW4eaA8micFIIdv58JEwWDSTAwLmbw9WP9f1Qvri0HMp5ej9Snd8s+qvutK?=
 =?us-ascii?Q?CFjx/oq5tEfXngCKhja4NMiYiLl1CJKWTfaUechQ9eHbghkTNrP5mMBUjNLM?=
 =?us-ascii?Q?T2eq/O5/rfkKsFKYfrYjmTvDIJr5yBTpFPaQt1w79UsyUHp7QYdLBN/6J3dQ?=
 =?us-ascii?Q?FKUxyNc57VhZQp7ozDPZjA+mns1fOo8vBWPmcyrGEr9Lp8YxnolJv1ykkzv9?=
 =?us-ascii?Q?C7avYNodTBNyQlJxY83SI2fXzQdDYPbKwVQulHg6z2DQQi8QXPitOBnwRwuW?=
 =?us-ascii?Q?dqceqtjMgtujime+Eoo0s7Edmi/GWW/qrlD0B+hDvfIfA3YuqkfLlLd0zM3C?=
 =?us-ascii?Q?FJv0HW3et4bx/MtvWjlDkaLpX+OcJ04ZIyNZ35FRyVTKEXPyxL/cmdj0wNtX?=
 =?us-ascii?Q?HONUF6chERFIqm8PE0sI9i/xwLNTXHV7MOmAusagVkjtQONdHBrW/1TRkNeI?=
 =?us-ascii?Q?MxYn8aIlfv4whRqEz68Ip4gMwnVOJ1T8RVslXLmhqnlyzTSBJrG5Nr5lc6mK?=
 =?us-ascii?Q?Oktei7nfAw6Pj9X+PETTgxLxemdETKASB74IZ/UktMsY18DN7Vk7ag8+yKou?=
 =?us-ascii?Q?Hj3hrIGZNsd9P/9U0dbl6kCytq1VmFXbf6Xw9GIgSPY0torbpJB/XaNnlfnM?=
 =?us-ascii?Q?+Toa/rma1Zc/fxLBJ5kYV85ON9nEXQdJD1CYktbJ2eF1o7kfRZu7N7CViVWT?=
 =?us-ascii?Q?7Savkb+r37M/y6sXmOeRxKfD1z5F1bxUT4NiaiG1Qiqkyk8gnEUThJl/aMeo?=
 =?us-ascii?Q?UBIlup4vqGDbgarprLE2eyLXpX/i9pLWSKz1ZhJLWW3yDWvT27WItOFgVMhV?=
 =?us-ascii?Q?VK0MtWGQKfte1j2RrfVAaBna5q3SNqMx1ijcnmU9rerp7xPGHtXQ0XOMSFA+?=
 =?us-ascii?Q?HlHWUWens+MPvUZF3FpE+Db2gGWfjwFXVhzGwx4sPLrqs7Rx/+H3zlEZQ3KP?=
 =?us-ascii?Q?woPxWY8FBYEtF8dpduRQ503AxjpzpiNiO+zpy905OGf/kxpZyLr5yzx+nGNr?=
 =?us-ascii?Q?Kvlhd9B+GLpCQZIclRMkJleXMsRND5Ymar+JL74QrNfo/oHCTSk0SEYUjJ6L?=
 =?us-ascii?Q?qQV8+WQao46G0FjDTKOtANIT+SNtQBf+OGY4wQpde3xLrgVrzDUCLqPykv6z?=
 =?us-ascii?Q?DPb+C3HdmZzFkITnj64fpqT8Ez39SjxoPeytaxB2PDw0NKGsYvqiYge9+2WM?=
 =?us-ascii?Q?N2OYOtanN0EXb8C+5Blr0axxngLFwKYrbhNyfDOlwEkBJUvPvP/ZsD9mgTqT?=
 =?us-ascii?Q?oo3SsQ0kTu6iGOR63hI5V5OJH7Aemow2S0z7rYRtXWNdE/uDXea6ft3VMLFZ?=
 =?us-ascii?Q?5krV9k1Z/FT+hTS8oyn2B4ziFppwd9K43XBygBockNo6L6zVqr8w6PfgJuZ3?=
 =?us-ascii?Q?EbuR0nOUWeLhbvPRRjqjglKN26R3OpxQiM6KYIM7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d50afea-c962-4107-a956-08dc7a0dc53f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 03:17:54.3548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pnia+XNU3caPX9tL+lXoBQf26689zMavxtiGL6gvRxQ3mskzUd7c0sApDZXQIp2iS9IgUdb4TpIgB7CdYOSTlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6903
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 01:04:42PM -0300, Jason Gunthorpe wrote:
> On Mon, May 20, 2024 at 10:45:56AM +0800, Yan Zhao wrote:
> > On Fri, May 17, 2024 at 02:04:18PM -0300, Jason Gunthorpe wrote:
> > > On Thu, May 16, 2024 at 10:32:43AM +0800, Yan Zhao wrote:
> > > > On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> > > > > 
> > > > > > > So it has to be calculated on closer to a page by page basis (really a
> > > > > > > span by span basis) if flushing of that span is needed based on where
> > > > > > > the pages came from. Only pages that came from a hwpt that is
> > > > > > > non-coherent can skip the flushing.
> > > > > > Is area by area basis also good?
> > > > > > Isn't an area either not mapped to any domain or mapped into all domains?
> > > > > 
> > > > > Yes, this is what the span iterator turns into in the background, it
> > > > > goes area by area to cover things.
> > > > > 
> > > > > > But, yes, considering the limited number of non-coherent domains, it appears
> > > > > > more robust and clean to always flush for non-coherent domain in
> > > > > > iopt_area_fill_domain().
> > > > > > It eliminates the need to decide whether to retain the area flag during a split.
> > > > > 
> > > > > And flush for pin user pages, so you basically always flush because
> > > > > you can't tell where the pages came from.
> > > > As a summary, do you think it's good to flush in below way?
> > > > 
> > > > 1. in iopt_area_fill_domains(), flush before mapping a page into domains when
> > > >    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
> > > >    Record cache_flush_required in pages for unpin.
> > > > 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
> > > >    flush before mapping a page into a non-coherent domain, no matter where the
> > > >    page is from.
> > > >    Record cache_flush_required in pages for unpin.
> > > > 3. in batch_unpin(), flush if pages->cache_flush_required before
> > > >    unpin_user_pages.
> > > 
> > > It does not quite sound right, there should be no tracking in the
> > > pages of this stuff.
> > What's the downside of having tracking in the pages?
> 
> Well, a counter doesn't make sense. You could have a single sticky bit
> that indicates that all PFNs are coherency dirty and overflush them on
> every map and unmap operation.
cache_flush_required is a sticky bit actually. It's set if any PFN in the
iopt_pages is mapped into a noncoherent domain.
batch_unpin() checks this sticky bit for flush.

@@ -198,6 +198,11 @@ struct iopt_pages {
        void __user *uptr;
        bool writable:1;
        u8 account_mode;
+       /*
+        * CPU cache flush is required before mapping the pages to or after
+        * unmapping it from a noncoherent domain
+        */
+       bool cache_flush_required:1;

(Please ignore the confusing comment).

iopt->noncoherent_domain_cnt is a counter. It's increased/decreased on
non-coherent hwpt attach/detach.

@@ -53,6 +53,7 @@ struct io_pagetable {
        struct rb_root_cached reserved_itree;
        u8 disable_large_pages;
        unsigned long iova_alignment;
+       unsigned int noncoherent_domain_cnt;
 };

Since iopt->domains contains no coherency info, this counter helps
iopt_area_fill_domains() to decide whether to flush pages and set sticky bit
cache_flush_required in iopt_pages.
Though it's not that useful to iopt_area_fill_domain(), after your suggestion
to pass in hwpt.

> This is certainly the simplest option, but gives the maximal flushes.

Why does this give the maximal flushes?
Considering the flush after unmap,
- With a sticky bit in iopt_pages, once a iopt_pages has been mapped into a
  non-coherent domain, the PFNs in the iopt_pages will be flushed for only once
  right before the page is unpinned.

- But if we do the flush after each iopt_area_unmap_domain_range() for each
  non-coherent domain, then the flush count for each PFN is the count of
  non-coherent domains.

> 
> If you want to minimize flushes then you can't store flush
> minimization information in the pages because it isn't global to the
> pages and will not be accurate enough.
> 
> > > If pfn_reader_fill_span() does batch_from_domain() and
> > > the source domain's storage_domain is non-coherent then you can skip
> > > the flush. This is not pedantically perfect in skipping all flushes, but
> > > in practice it is probably good enough.
> 
> > We don't know whether the source storage_domain is non-coherent since
> > area->storage_domain is of "struct iommu_domain".
>  
> > Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> > and set this flag along side setting storage_domain?
> 
> Sure, that could work.
When the storage_domain is set in iopt_area_fill_domains(),
    "area->storage_domain = xa_load(&area->iopt->domains, 0);"
is there a convenient way to know the storage_domain is non-coherent?

> 
> > > __iopt_area_unfill_domain() (and children) must flush after
> > > iopt_area_unmap_domain_range() if the area's domain is
> > > non-coherent. This is also not perfect, but probably good enough.
> > Do you mean flush after each iopt_area_unmap_domain_range() if the domain is
> > non-coherent?
> > The problem is that iopt_area_unmap_domain_range() knows only IOVA, the
> > IOVA->PFN relationship is not available without iommu_iova_to_phys() and
> > iommu_domain contains no coherency info.
> 
> Yes, you'd have to read back the PFNs on this path which it doesn't do
> right now.. Given this pain it would be simpler to have one bit in the
> pages that marks it permanently non-coherent and all pfns will be
> flushed before put_page is called.
> 
> The trouble with a counter is that the count going to zero doesn't
> really mean we flushed the PFN if it is being held someplace else.
Not sure if you are confused between iopt->noncoherent_domain_cnt and
pages->cache_flush_required.

iopt->noncoherent_domain_cnt is increased/decreased on non-coherent hwpt
attach/detach.

Once iopt->noncoherent_domain_cnt is non-zero, sticky bit cache_flush_required
in iopt_pages will be set during filling domain, PFNs in the iopt_pages will be
flushed right before unpinning even though iopt->noncoherent_domain_cnt might
have gone to 0 at that time.

