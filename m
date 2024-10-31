Return-Path: <kvm+bounces-30263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3879B8669
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4B928289B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331011D0F66;
	Thu, 31 Oct 2024 22:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQFIyEf1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56750198E92;
	Thu, 31 Oct 2024 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415427; cv=fail; b=JY8Dbc0PWtZk+ahSk9EHb94Vcv7j9sFA0TtQ+GP9pUSppW+tBjPTzhVHgvR65HQUTRRcevt1GBCNCkflSlJZI0jWr/7mn9E015xnHfKZs0jL1CjEGEIarbPMzIbi+FJIE9nZOW02f0LCsadA+ySUpCCdnuwgxckKvj5INvcbvss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415427; c=relaxed/simple;
	bh=embh64Ak0MgVvi1mJnRrqn1hioctiBRiPc9U5uwPu9Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BbnLl3CYTDQBypkIcDhEy7+NWxuhOqXq/a3ET1Em3KKeiSp1OavRhJ3rodkNJjGlquYZhD2avJ85RtC79G67FlwWV14+NW36XK40Wzux36cPWSwn6FgUBIX/I5d5XIkVfNBYDS8yaaqMVqW4LquGDRTJ0pUWO5EcjGzi6CsPsfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQFIyEf1; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730415421; x=1761951421;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=embh64Ak0MgVvi1mJnRrqn1hioctiBRiPc9U5uwPu9Y=;
  b=dQFIyEf1w5piWJz/bwPeJr6ebAHC2VCUiYv60Pr4YjWd4Ezjm4sdoMfM
   lxwbg5ObE/YHhLFUiKug2aTgH8Povu2wJCVp4dXFyvaB33aqpls5NwEVm
   waqsbMXXa9Kaq3KLLayvS98Af704TqgQGnTeOPOQ0wGYmm5dZjhI7d5t8
   KBBQqrK7uL7OLyTePGzcqU3i2SRxfaF08MCmW8fyUR+jLDarZplPS75Q3
   UDZbYoRlNWHDGe8BTVIvCo5qu8LdcKJPu++A9PsIa6XQ+ASucZ9dYWJ4R
   7DiAHZ/PrbzKDJxO4UmhdZ6iGdxuXht0zRg2/2g0wsN32k66RMVQa8jHu
   w==;
X-CSE-ConnectionGUID: VQsedsh5TGOANpdIegQClQ==
X-CSE-MsgGUID: GosmyGZHQeaQb0RryDLPAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47658897"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47658897"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 15:57:00 -0700
X-CSE-ConnectionGUID: /BsAYlRhRZSKOyS294DsZg==
X-CSE-MsgGUID: kn4OhmIURBWdxMgWRlLkJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82887588"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 15:56:40 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 15:56:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 15:56:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 15:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQvTKNTMvA0lGNCZImja/hoEUIFtGZYHOb2P3566jsvw3Vl8ezitSeV07bQLTFhSSWF7OF8qSDsJghIkmWscX7NO4EN3+NwtfXAQaLMw0ln5vB+YViCWVRETPUfkONKvKf9AbC6j7FfH8BRbwLFqrLJ4CWjnFWwwoHq1V1HAGAfhGWCdBAWfcnLOfnnsJKkG7fP3WBDV/oF4zQGQK+uhvl2sR4Ex7XjTpVTcl+pKGjVKdNHp9ciOU2bppMpBQirxHgCiqQFjJ9nVP/QKv5VToNXFPLjTUje3DAa0Y4nJEPJF3MlFgR5j/w4QWu55nhYbh2ywIzK8W07mZeKd0xyirQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIZ8tCwm5/2EEIpZtjSdNs+o5BKwIyj/G2li7QVaD1g=;
 b=ievddYbRvNKdCVUmVZA/OSLbksaq6Q+7tzeM+ZXGBIPyN286GKG/AOgRpsn0Z9454pxao139KgaeazQcRF+alJ9tmCTEp62wE7zRqmQIyNF+icnZ358+80bQ0Wblr6WoUpWFx8Psl8TXy9htAojtLD8wJD6mye2x7LHhaqtuZ0RZMzM5ncN2DBr+CJD85xt+ltTq9URucHZ90pXsWkeRlfqndgqKATQ9spTEq2igYcZ3nAXsOg0Ngbw5Nm2R9bsqKYksVgYEAsJNaBcQrRhbDqyKa4K+3g7fJWH7ppRyH7Vvyfiw2KVIqO2C3w1VbNBk4jFPy9627gYZY4dWaB7uEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6277.namprd11.prod.outlook.com (2603:10b6:208:3c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.19; Thu, 31 Oct
 2024 22:56:37 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 22:56:37 +0000
Date: Thu, 31 Oct 2024 15:56:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Message-ID: <67240b22421bb_60c32947f@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1730120881.git.kai.huang@intel.com>
 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com>
 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
 <6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ebf9897e-dda6-4e74-b08b-5d266c6c0c1b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ebf9897e-dda6-4e74-b08b-5d266c6c0c1b@intel.com>
X-ClientProxiedBy: MW4PR04CA0258.namprd04.prod.outlook.com
 (2603:10b6:303:88::23) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6277:EE_
X-MS-Office365-Filtering-Correlation-Id: 458ad901-4030-447d-61d9-08dcf9ff4661
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f03CVxXZGmDlkgqUWi74VswzBWPkCm+G+YFCfzLmAVDRxBHjx1N/fJ/atRbM?=
 =?us-ascii?Q?vL8mOr4u806ivRhmStFlshq6kswEmBRYlnrAKtE+NqmaOnjUyn/xS5woG/6L?=
 =?us-ascii?Q?gEoWcj4JBmBDXhRT5eFAODil+1PIDjVPvnBysretg7/nedmog4cKwJJCzMcc?=
 =?us-ascii?Q?O4jpCMZFcH5SgCELWsB0HTLUzJcdbnu68fvkwBIl+bJqtJOJb7QCbAhn4w10?=
 =?us-ascii?Q?riV+xKKSA9o4H7PhOz7qBFSfX2B8FH9kWuHZRBPB20omlklvzH3hG2Nm1Uhh?=
 =?us-ascii?Q?s+Qb1/+d4As12ffy2HRuDmZK3nuDuS0wlGzWlrPZrd6rlTeYDuA9tg3jXLUm?=
 =?us-ascii?Q?lfu5zBHBH9T0YxrWvjQUcg5Ohz4lHc8vP/IWyvlfJtAtefJz9ekMJ4B1LlXs?=
 =?us-ascii?Q?koV7KMfFUvvlZ0e6o+vPWlguUsXAndIWAwEBZNHfKnPn/QJ4T9BtLbKKkKLh?=
 =?us-ascii?Q?1WV1oEetrpKlbvNbmny3myVlDIh+EqILjcsH/1p6w10ICXnkyOxCbIpFKrSg?=
 =?us-ascii?Q?Rfd0TDuwYOBJylmo9w5gNvigTxjkPtvxzItHTsRmNIM1P1DBTqac0PBDZJ+w?=
 =?us-ascii?Q?1bCgeVudXVirx989DU+qPBTcgXgvDCHIvrsRrCfs8hHlfAVGU3TLwvJDJmuw?=
 =?us-ascii?Q?rACM40cyqGYsjflzV7D/M5DvPEIuFlkrr8p+mEwgFZ/O8h+y7RBIfyT3hsRn?=
 =?us-ascii?Q?z8vdoj6U+Ou/JL1HMnO1ok5npp0X3sKpeoy/bF6nkUYotC89OGM7dqfQ8Rl9?=
 =?us-ascii?Q?ASY9m14n8WCt6YHPdmX2rJs7g5hmRuP6ZVVcSb4wAK/W1xDEsFMy1eCGJiX/?=
 =?us-ascii?Q?dkQIrU3enKtOtolyxptq5tFVXg98eYJrMe2qQeUo9fqSpyrYtSBQeYtzqa5a?=
 =?us-ascii?Q?QzIyljVUpGjdvIrmyq9B53pNHt9HVvSi+e1r8/SoqMhrOOMc5R4qdIrhl0D5?=
 =?us-ascii?Q?WENCwHLmQS3SGN76xG2o9E35rXIMtUbHT6W35cNUdkViSWkWK/H5Nj9wy5jP?=
 =?us-ascii?Q?nJVuQOAz9uF6OTpiYfpeq6psMyG5dKf97MwMOhXKk0NlmJnAbPe4VBrNqW6j?=
 =?us-ascii?Q?31C0V3g86HxHRiBCBWHlNcmYyNRY7ztl7pykTiIQL/vNikZw2azTJOme6m4+?=
 =?us-ascii?Q?ZoWRlvvqDzQqSiivL43wWjK3B30nxZMXlvLTgM2TcqMdRBLrfe8UpYZY6YCP?=
 =?us-ascii?Q?A4vlob9K+joAZELA+3rfLN3hWfzuA3nVOnX2t16jfoRmNKYpTu7LaGuVWX4H?=
 =?us-ascii?Q?N8xZ83U3b0t2Ia+Df6ouhhkFHEpOJMdGeHuMEQNmu0tsAuOqzxLNSWkUzvUM?=
 =?us-ascii?Q?rp0h6mQ33sJRNf+llub89z/7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z0kOQcjGQEcpOd+vqUBUeX3tdPOzRxht8esMF5JfcVWSGCZqLPG+r8Q/5xOa?=
 =?us-ascii?Q?J0CgoOwbHy29f2bWsQ2TjTCBmuEWAuEpXQSPimS1+rBr3qln5oWytxo2MxFI?=
 =?us-ascii?Q?H++YzrY0U5wT+WWo+8m2MkNlOg3Pd8GmM+C1YGAVKSAWWdIP/t2E8w876tln?=
 =?us-ascii?Q?OYbz/ydaYwJEX/NJCMIi+WwBToNcXrrpnYkWxbX6UhizE+e/Sawwyw6XOBte?=
 =?us-ascii?Q?1Uy9O5qPpBim0WIBTWh4ghs9sFhsR07C3+CfA2j/ZpfGUTcZE1yMyYTY9Bue?=
 =?us-ascii?Q?bDyaJeauBzSuFVeUYYYSvepQaoP2KDIa0xdNc97RelXUqWHzQVbxr2x3YrUL?=
 =?us-ascii?Q?aeQa3loBfLEg7TUzP+Pq4+tNJZ7Vn7BFAxro393s1OPCJP3g6v6CY3g5hhry?=
 =?us-ascii?Q?A4OH6GOyJEDL19fYf+8kOSN3cMKf+pwNedIGYw3j1Sy6B1D7mqSJd1YxWyw6?=
 =?us-ascii?Q?0m5Un/45YqXVtTkHFsvUJ0O3dh+tDKUPjKhHsX6M9rGf08JMwk1eODHExbqe?=
 =?us-ascii?Q?8NkqSNW2K8uNPmXRgwlcWS7yCcwLSCHsrxaRNgIPQYGd5yOMiQix0bEvl+wz?=
 =?us-ascii?Q?ZSoAfyK1zIOVJw0HFd7MrqPzg82roS6B0jHmNVL8IQjfC2m8NFkWq6oaCAM2?=
 =?us-ascii?Q?mabiMprrqbdlq0ARJ4ou/rHfB4uu5GQqQaoVMqkFlgCu5pnKdkZdwsJuJnMR?=
 =?us-ascii?Q?ActfIQ0QxU5Q4V8kbHHXD8uqQzf2uhcJ7jTZ6Sx8SZbNQm+1ep/SKNHn/E0h?=
 =?us-ascii?Q?Et8LLCOjjtB5MFmBZnDgssxIa+xpXcgf/svgpphjSq0XgBJ7lIZZ2WlJU/99?=
 =?us-ascii?Q?5T4o5OTKSoe1aXTCXDBJxboxy1AQ9LxIjcIuWN+f0Lfy6lyKdtFtcYEVL1Wh?=
 =?us-ascii?Q?gaWYUh8a6AeSjgkFvLqkeLVeE+VCtslQsADMMOK8iVn7yOi15IDOvY7aWv7Q?=
 =?us-ascii?Q?F+vCYX1A+w01bE+cEgH7oNEYMzTzRvtB3iWIODlq5gvlU/RsIm6GcKodXw1W?=
 =?us-ascii?Q?kT5hKdCMGgNzu49ZcWMG4Jjmm+FzPTKDbzbVUf3nhof7ZQRJjazp3PMgseLD?=
 =?us-ascii?Q?QOrPQ8U63ej5VzaVQ2ORAMkdyGcpGje+gFVr87D6NhIt2Igr23l0TzI304Or?=
 =?us-ascii?Q?23QwAo26lNP0MUIcra44sKfdT8QOjjR3ZZ1fKbYvi8uFcO5Xj3QT9gRgSf1v?=
 =?us-ascii?Q?fsgyX6juqXoKgE7XUaFjfJ3yr3p9/P3lWr2VJm5dF2nbKoaOfHv/jJb8lJnr?=
 =?us-ascii?Q?thb8sy2oWoNSON+mPRmOJ/KWlBOaH6lOWUmmtZwt1cya8/1SWUJ2sSxRPE/g?=
 =?us-ascii?Q?3jB2xRLMxt0bSdv7y4xhiuMMOGqCfo1fpgBzxR3kci3lp8qXliFdM/FcAgnu?=
 =?us-ascii?Q?uW6VFcd5VE44wC31oJoy8tCavZjg2kbtmPbqv8nP/qXbPLr747+JoboAq0wM?=
 =?us-ascii?Q?k0ooD96g12SoKz0WIfdjw+4Y/DUao0oAbzXU8oo6rdN6eAAfKnGYat4umhUX?=
 =?us-ascii?Q?gyCZAHGCUFXAG73+1uksUTzmU0/5pQA5XUqhCYdx87YGQuxg4fRYcT5ODDVo?=
 =?us-ascii?Q?PslGKjaLOh1chKMRftaSb69HfLX6s2rtUwAxtm0DGd11Ig/RrK+Fy4u/C6qp?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 458ad901-4030-447d-61d9-08dcf9ff4661
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 22:56:37.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXanKp27sYVDpuCzICXJT3ey0ehm20foHRb8nn8KamlfwW+j3+9fFaHYHWb0oaprZkCBA5956rni5FEyaDf51a8+IhZu49eKzBHF/hytbkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6277
X-OriginatorOrg: intel.com

Huang, Kai wrote:
[..]
> One thing is currently INTEL_TDX_HOST depends on KVM_INTEL (with the 
> reason that for now only KVM will use TDX), we can either remove this 
> dependency together with the above diff, or we can have another patch in 
> the future to remove that when TDX Connect comes near.
> 
> I think we can leave this part to the future.

Agree, save that for later. There is latent effort to disconnect VTx
from KVM that TDX Connect is also eyeing, and I expect that work is what
allows INTEL_TDX_HOST to drop its KVM_INTEL dependency.

