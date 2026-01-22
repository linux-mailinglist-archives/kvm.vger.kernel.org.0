Return-Path: <kvm+bounces-68859-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHZZBefPcWnSMQAAu9opvQ
	(envelope-from <kvm+bounces-68859-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:21:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7060862783
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E32E24FDF91
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708D548032D;
	Thu, 22 Jan 2026 07:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m8T4qcKN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3726F2DCF55;
	Thu, 22 Jan 2026 07:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769066396; cv=fail; b=eoWsNAYc1xopWTKEv1GKnO5/yidcTCpCAw3PnvR6Q6ZjcUK6pYx9Ob8v8tdR6P0M2F5YiS9yTJACgqLXhwqsPbUh7H3c+1t3vod52D9C4f0IMl4UKncOmyHkwvSIT1C8dJIGRudrIdVTSkYfMnlJPS0fHXAR//O/rMCsjVkoQIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769066396; c=relaxed/simple;
	bh=Z4QkvA6YaSEHgRxKpZoqYM/SfzsRr/RZN+7cnihz+mk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GJGfhzyCv+xwpvTaikx0V1qkbGuxLnNqiVSigjAQhGv6NzW8wpOKmYYMAu7hjnX4kFCCsAK6h8ko3bg8Q4FxeO/dKeloFTe1QqRAjvKZhOEyyzvGjFlr8bIKg/QIx8Hi7gm9JKSPfvs+6oc9syc0ewZKBYMJQarlhs0LFI7FAvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m8T4qcKN; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769066394; x=1800602394;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Z4QkvA6YaSEHgRxKpZoqYM/SfzsRr/RZN+7cnihz+mk=;
  b=m8T4qcKNrfxWkCx6qHehnXsg8YZxf8guVUuS8p80if35tNhEK5+wTY6D
   rN3DoLCRBfGK4Jpld7yajFd9rguGC1bPUyUsF4kCETITktl2AmPv8cSJE
   znQZy/u1X80Ti7oSLe/ZEt/g0atIm8DqKBshizR2oc2B89xECsst4NGJd
   J9sAlmn5qn2ibVkbsMcrqJwqhzDaaJ1zGfegcmKyih15Pw7UQ5wA1Vo/M
   argOK0ql2z1QYQT7pNOEWU/Wi/m2Jq8KPbPr/38SgvL9pgZgnEW5uvjZH
   O2+bGb2U3uqM8wInT+6Ic8vpK7YJKbtrAE36T3HLPlmIQNrtSamFR+DEx
   w==;
X-CSE-ConnectionGUID: BOZuY80FSeOHu5EwsC2WCQ==
X-CSE-MsgGUID: b2rcVAvXTniUzL3fLPonXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70218614"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70218614"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:19:53 -0800
X-CSE-ConnectionGUID: hA7pCq19QASVCx1ifvFYBA==
X-CSE-MsgGUID: 4FN7r2WrSVKLSM0oDeU4pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="210814141"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:19:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:19:52 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:19:52 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.29) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:19:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6JVxiDpp0blTDAC8M7h8LD6Bxm7DZMQylLc+GaVZyevuE2udlAELr8SSeYqS3suJ0Y1lo7ErqK3y+0WMLsT6yHsqzoS+6jmhMoVR6TdUHgoSqZkghaJmB2+vgjkeBI29lBqcevrRZqxAKDGsbWZfmQ9uvhPT1TtDpOpC9fxtlzyIbB7BiiaWmyBgfjAZ28drQ7ZaC43obDWIZZ8GD9yq4Ls64Tb49lJsCcQ+5CDVA7VWmSsfLFPS7vmC0w7QiWEQdkcbNwZRS/smrlMgYs4yzKuvoXMjiT37FR4ureIY7ZvYqrS8Byo40mk5t909FSHd5CwfTUCR9O/FOCLiQjAwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vpp0BjdYaSjPEGTyUrlUM8/7+7yMaOLnIOsUBtvsURo=;
 b=dflqETHieaLEt/rm2cu9rFWdrEfrpr1q0QS+UmewTCjDzw4VglCuImX9A07dJ7X8HF2jidfd8GB402+Zpz3XU94uCuUyIkBlSU14jWfExHbQFMVMnjOAeopXYoBpCU4Y5mYpjNaVZ7to0Hsd1eIIrnEM8jpCSxi+5QLAY+gRLSecj5RVQCzyFxSAMZreTJ2WAb6qle19WmF1BNZOCVYbPJyn+HSnfQnKON4WCCRB55gXKwA1Ht5h6KkJc9h0dERcM+pOgB/gEEs+AIilXClwcHJbWdIpMT+A+rTA5dslZ1KBe8DRMDcjOvF2lJ8+4T8nUrJYidx5iC7Fyww3wKJkRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MW4PR11MB6982.namprd11.prod.outlook.com (2603:10b6:303:228::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 07:19:49 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 22 Jan 2026
 07:19:49 +0000
Date: Wed, 21 Jan 2026 23:19:45 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Zi Yan <ziy@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
	<Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Leon Romanovsky <leon@kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<nouveau@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
References: <eb94d115-18a6-455b-b020-f18f372e283a@nvidia.com>
 <aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
 <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MW4PR11MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: e45038de-e53e-4b57-9ca0-08de5986a0f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?czB4ZjRQd1M3MUxTMkU4Y28yTWJ6djdHa3VaUXkxV05CL2VaS1ZDNVBwQXlw?=
 =?utf-8?B?RVRXWmtEYW5kTndza21lM2NRcFdpWExxUVNmWThFTW5WWmNYd25VVGdBRC9w?=
 =?utf-8?B?RDRCZnZoaHJ1RVErbmgwSVd4OWN6ekZGbmlVdzBWV3VRVlZmbW9lWmtRZlZR?=
 =?utf-8?B?L3JROE9ieitHMnF3dk9FOFk2b3BKQ3ZuTHMyYVRIYjFUMjN1em5NV2x4SHQr?=
 =?utf-8?B?QmdRRjdJV2lEK04vOXk5ZHIrd3pnV2lLRVJ2MVRKODFLZ1pVdzJLNE9uL00x?=
 =?utf-8?B?RFF3TVREaHYwQjViV3lWYjNEU2ZwVTJLWGVldCtoVk5JRngzenp5VkE4ZE5y?=
 =?utf-8?B?b0pOdXoxRE56MC8yemVZUDBpd0ZzbXB0YmoxZGxNa1pKTk8yd2lZZUFYd3hx?=
 =?utf-8?B?bmZDTmYxYk04aDVTb0d0MXkzZjBHVWhlNXozQmNlekcvYzhWVlF0Q0RwTVlT?=
 =?utf-8?B?MXUwY1FoaXNNY3BTUzZiaUcwcDgrTnhpR0pJVnJaVTBqL3p2LzVsQjdwOWNK?=
 =?utf-8?B?LzNWdHpUcERWZURGZ1pUZW56NUpQOUxCTTNFU0NmUVFTZU1BaWhjbllLZDBv?=
 =?utf-8?B?Z0hFa2NkZVFVNkd3ZlFzdGduMUFaL0thR3ppdjYvbmtiTGxHUHlkUWhEUXZm?=
 =?utf-8?B?UUZCOTM3MlJLcTR3RGZjNmVzY3B6K3pSd091akNIZFE4RWtIR0VYdmVzU0oz?=
 =?utf-8?B?czBoWW84eFdVSmE4UlRYYm5KS0p3bFd5OGpCOGpDKzhZV2N4SGlrVG1scENz?=
 =?utf-8?B?cVZWYkUxdDZuZExyOVRCc25COUIzVkF0N0o3b3IwN084azhPUXdrWW95QUFV?=
 =?utf-8?B?S2hScFlaOFdpcTVhWnVjVzN3VGpmdlhzRVBlMjNxcDZDV2hBRkJHSTZlTU5l?=
 =?utf-8?B?TVZyTkdkbHU4MmJMQkpvL3Z3YlNCbENWUWFOK2k5Qmx6dHg4eDV4UFl3OHhT?=
 =?utf-8?B?a0NrK2F6SkJSd2gxbTROZVpGTjk5TURxTWZoSk50MWZ3RzhENExxbXhxL3FD?=
 =?utf-8?B?Ny9GUFZEUU9PWFdZMW9oc3g0UXorcWl5eUFOQWxtMWhHN2xxeER4OTdsUy9R?=
 =?utf-8?B?SitRVjRMenErODN4SVEzdktjekNJZUNsVE5iWWFsL3JEVlcxcFAveDBpdHh4?=
 =?utf-8?B?QmkreTlLcDhQc1hGczczeFdTWFUvd2FhMkZFSk8vS1BrdFpDQTlOREpRYlZR?=
 =?utf-8?B?czFuRyt0eEdremQxMUMyRzUvUFJ1UGpVakQ5MHZIRTNaNHQ1cGxhMGhBakgw?=
 =?utf-8?B?SHBSR1I5d2haMkRkT29YdU5hZ2h5RzRoeElQbHpMSHUxS0ZHNXVvTHhsd3hX?=
 =?utf-8?B?eWJwNFUrV0VtejJLMURlcjZ1a25qV08yclRLMGlOczBhWmNjNHhjemtzVGNL?=
 =?utf-8?B?cUh3M3hUQXl6Rm9acmc2OGkyWVB3a1NiZ1c5K2pjRWRQMXlWczBwczN5V2tT?=
 =?utf-8?B?MStzNlVLbWZKbXN0SUwrRTVwYlc2MlZKUi9DWHQ3Z3VXSkhZTTdubjVjWGtu?=
 =?utf-8?B?aExNbHJHVXZTNjAxT3R1Tnh0dzNOdmdkc3RNUk12RmtyTHhlemdDUVJxUXVj?=
 =?utf-8?B?VzRUM252QzNXbC9WRVo1c2ZRSlZRa0VHdG5PcEg3WjU4WFdSbHVVMHJyYjZ1?=
 =?utf-8?B?UWhYNU9RZjdXeHJLVnJFa0drckhFWmpwMjRtaDdtRkpkaWZVUmRKODVxNUdN?=
 =?utf-8?B?ZFptcmFEY0VHTDNWdUNrc0ZuYm9hUTNpY3RzN000dCtLTVAxK3B4RWVkUjZW?=
 =?utf-8?B?d0RNNFJsWDBxV0J1YjRNSm9xU3lBWGd0Z1ZpTXN1Vldyek5NZG9LVmlOL3gx?=
 =?utf-8?B?OWcrcENrWVAvYUNKL1dRTWdOTEFKS283WHIrMHE3ZGRhVkFVd1p6Mk14bk5C?=
 =?utf-8?B?b25EbFZhZE5BZWJLc21URklSMjd3VlU4ZlFVRXdocG94QlVpbzVKTGJxY05v?=
 =?utf-8?B?bXVFUVlLekRpZ2lDUlluRERheG5GQm9MNlhuY0R4Qlc3YVNudXlhUFVjV3hy?=
 =?utf-8?B?bndERFZHaHVJSVZOVVhFTCtSNW45dlEyci9sOG5xeWRKRXFWL1YxeGNpeEZx?=
 =?utf-8?B?ckFFR3lvdzB1clJuNWVnalhVeG50V2JBaVFhVUY2ZjZkV3JJVldwMjF2akI2?=
 =?utf-8?Q?T1QY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjM5cXJubmhQRStXUzNhRk9HRlZ3TmhMMWM4UXNKd3V2V3hmQWZuSk90UU51?=
 =?utf-8?B?ZUNVMklXSk8yT1VZU3RRYTJaYndjQ2MzbE8vOUlQbUFvVjdoSmdiN25QQ3Y2?=
 =?utf-8?B?YWFzRE9FWDRXWmg3aDQ5dkZ0d1ZHY3g2Y2tBTXVqTlFmNFhFemhTMnlXN1pt?=
 =?utf-8?B?eGE2aGtYbFVpRm5LRThrK2hubmNPREVoK2h4WCtpME1wN0ZRVVdkL0NpdzVu?=
 =?utf-8?B?VjFSeDY2TWdYZnp1Z1htd3NuSzBpSGV4WWtpdm5XdHJrTWVvSEZRSCswQ1pp?=
 =?utf-8?B?WDNUck9LcVFOT3NuaXRvZDJzNWpWQVRCcXpxRXFBVE9NKzA3dUxzRWZsWDNC?=
 =?utf-8?B?Zk05VlRMSDZwR2tJVUhCRHdJQjk2c1FuZ3M2RnNCdTAwRCt0dUF2VXdIZUJz?=
 =?utf-8?B?d2F1UnFabTdmMHVPVWJCQkFaRFRySEJ2a3NoeEU0TnE0eitnN1NqdjdLeEt4?=
 =?utf-8?B?VjJXUzA3ZlRsTUFtQVp3NEdOc2hIQ3hsSGVyT2xhQ1UrZDVJKzBhbG1CV2Fr?=
 =?utf-8?B?TWZrbEVmQ2RqQW1DTUw3VXNKQ3lzcmg1TWZESm5rUGdLZFI3bFlETUZDQjhJ?=
 =?utf-8?B?UDhaS1BBTG55K3RuZEZ2NmhQNWhsT0d5S3M0K3pkNVZQNXR5WjllaHJPZGk1?=
 =?utf-8?B?NEZsd2N4bnRldThhb0FXZGtnc3c0S1V6dFpWcnY0dndvU2NQTEc4WFNkTm15?=
 =?utf-8?B?K2dwVFNGZCtobDRzZ081UzdVdE5wLzh0dEsxYnQrRmltZUxwaWVSUzliZHo4?=
 =?utf-8?B?MUc1TWFjRHdWcjUzNnBYNURWRTRRYVUrTnk1Q1VuTnR3VFByM3lOWE1KR0pK?=
 =?utf-8?B?MmJxa0NEbytibmlJU0cvTDNMWGxYK1VhUExjVnAxUlU3djVoL2ROZU9tVzlP?=
 =?utf-8?B?Y1F1WFNjMHpUY1R5aDBCbXhsZFlkWU14MFlBd1JoMnlNV0RrblNlQ3lkc2J6?=
 =?utf-8?B?a2pjNFkzaEhFWUhIekdML2dTcTJHaWpUT1J0VTBGMHJXVEJ6aGpBbFk1eHpy?=
 =?utf-8?B?aDZGdjF2TThMUjY4dENwdVNMdU1QZUdxbW0yOERxbXVTUDVPajZRaU5nNjFo?=
 =?utf-8?B?Nngwd09IWXY1aEF3c3JWRnVzR0JiRWNTVEdqWW82dG9uQUFmV250b1NJTEJK?=
 =?utf-8?B?WnZTeGY0SUlMMGFEOVNCclByTkxOZ3ozY3lBcmVUdTVUT0VkVnhteEhIdTE3?=
 =?utf-8?B?NFBBdnFTc09VWGpKOVlWNUxlVGlYaW5ldW85SlUvRkt0MTl0Zyt4ZVFNeTRv?=
 =?utf-8?B?TGYxK0xqRlRmZ0dtTWlGMHVZeTdsMzhzWWJkeVJ5RUEzWUZXTDN2cTlhTTFQ?=
 =?utf-8?B?ZVRoOUZ2RTRaaS81Q1ZEaUVNZlNKVHF6QTY5SG9xdTh2ZXIrWWdwbmsvSDA0?=
 =?utf-8?B?bVpOd3NLUkRJMW41MS9JaTBZYlh0WVU3bWVXZDZYMjkvdVUxam9LMytVQURq?=
 =?utf-8?B?NGJtVzJINE9vYm9vQWlvTXhJM0U0ejAzdnNHQ0lFWHM4MGZVakFOeWVKQ1d5?=
 =?utf-8?B?eE9OSFhUZWdueWdCWlRXaTM3RHNLWXp0NnVwTUJpZE9JdGIrVk5yaS9JSDl4?=
 =?utf-8?B?dkxwQ3N1QWlyR1ZMYzdXbkkrVWppb0JEZFFwaUk5M2haQ2NjU3JqbXhmSmZD?=
 =?utf-8?B?cEpSMzErWEN1Q1JsM01wUlgwQk4wWlU4RllTU2NaK2IwK3FPVGlMM21DQTk2?=
 =?utf-8?B?V1NveDVnTm5Zdk5WVUsrQzJwV3VEM0NGeWduTi9MQ0tuMG55Q3BvNHRCWCtu?=
 =?utf-8?B?K2lFTXlvUFhJUUVsaWJJdVZFM2U0WHB2eDhpNk9KL2luaVJIRUdLeVdScVdX?=
 =?utf-8?B?eG13b3gzV2lKL3RtN2s1VUpGZzVjZFFvUVVQalhOWmJCd2lKWlVWZDZpQy9p?=
 =?utf-8?B?NmJmaTRQRlRJemxuM1F5MUhvN0J3MlBBN3F3ZFptZmNLYVVBN3FEenVCVFVJ?=
 =?utf-8?B?citnSGNVSXA5TDF3aUU1MitCK0NHeGs0VVZ4VzdWNVh4Q3V6VmM4ZmhXRXVm?=
 =?utf-8?B?K0VVd1gvR3pZbWZkeGJORGwzQ3JMaFh6VTRCa2NKQjNuaTlGTWNyZkg1VmJ3?=
 =?utf-8?B?SHp3TTQwV2dKTURSZzJIWk9BQlZaY1h2UENPcVN1SzJHZnZuRkZ3KytaWjUy?=
 =?utf-8?B?V0tJampJd0lQa21IZ1JrZnhiazRCSWRUZDhWeWVrRTJ5SlhrbGVDQU5LTDl3?=
 =?utf-8?B?eGZRbGNUeXozRnVrUDUvaFJZQUNKR3hzVVhGVk5Ba3VsWDNPRnI4ZDRhT1Rk?=
 =?utf-8?B?dTQ3WUg5QVZrMllIcGcwSW1wQ25nakxPekFWS0habVoyVmtzM1I0eVRtTzVO?=
 =?utf-8?B?Q0RVdGJnUVdXTWcrcy8wODZydkFqU3UzYW9XTG0vMUZVdTFFUmxoUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e45038de-e53e-4b57-9ca0-08de5986a0f0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 07:19:49.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cc8SrTJ0ZKI/r8/uxaSMVB0s8p9QOzuIsG9Oy3AH3emxPKc896u89OWizXx2KiCvn2hNWomUJo119STW+5Tawg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6982
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[39];
	FREEMAIL_CC(0.00)[nvidia.com,infradead.org,suse.cz,intel.com,lists.freedesktop.org,linux.ibm.com,gmail.com,ellerman.id.au,kernel.org,amd.com,ffwll.ch,linux.intel.com,suse.de,redhat.com,linux-foundation.org,oracle.com,google.com,suse.com,lists.ozlabs.org,vger.kernel.org,kvack.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68859-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lstrano-desk.jf.intel.com:mid,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,intel.com:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matthew.brost@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7060862783
X-Rspamd-Action: no action

On Tue, Jan 20, 2026 at 10:01:18PM -0500, Zi Yan wrote:
> On 20 Jan 2026, at 8:53, Jason Gunthorpe wrote:
> 

This whole thread makes my head hurt, as does core MM.

IMO the TL;DR is:

- Why is Intel the only one proving this stuff works? We can debate all
  day about what should or should not work — but someone else needs to
  actually prove it.i, rather than type hypotheticals.

- Intel has demonstrated that this works and is still getting blocked.

- This entire thread is about a fixes patch for large device pages.
  Changing prep_compound_page is completely out of scope for a fixes
  patch, and honestly so is most of the rest of what’s being proposed.

- At a minimum, you must clear every page’s flags in the loop. So why not
  conservatively clear anything else a folio might have set before calling
  an existing core-MM function, ensuring the pages are in a known state?
  This is a fixes patch.

- Given the current state of the discussion, I don’t think large device
  pages should be in 6.19. And if so, why didn’t the entire device pages
  series receive this level of scrutiny earlier? It’s my mistake for not
  saying “no” until the reallocation at different sizes issue was resolved.

@Andrew. - I'd revert large device pages in 6.19 as it doesn't work and
we seemly cannot close on this.

Matt

> > On Mon, Jan 19, 2026 at 09:50:16PM -0500, Zi Yan wrote:
> >>>> I suppose we want some prep_single_page(page) and some reorg to share
> >>>> code with the other prep function.
> >>
> >> This is just an unnecessary need due to lack of knowledge of/do not want
> >> to investigate core MM page and folio initialization code.
> >
> > It will be better to keep this related code together, not spread all
> > around.
> 
> Or clarify what code is for preparing pages, which would go away at memdesc
> time, and what code is for preparing folios, which would stay.
> 
> >
> >>>> I don't think so. It should do the above job efficiently and iterate
> >>>> over the page list exactly once.
> >>
> >> folio initialization should not iterate over any page list, since folio is
> >> supposed to be treated as a whole instead of individual pages.
> >
> > The tail pages need to have the right data in them or compound_head
> > won't work.
> 
> That is done by set_compound_head() in prep_compound_tail().
> prep_compound_page() take cares of it. As long as it is called, even if
> the pages in that compound page have random states before, the compound
> page should function correctly afterwards.
> 
> >
> >> folio->mapping = NULL;
> >> folio->memcg_data = 0;
> >> folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>
> >> should be enough.
> >
> > This seems believable to me for setting up an order 0 page.
> 
> It works for any folio, regardless of its order. fields used in second
> or third subpages are all taken care of by prep_compound_page().
> 
> >
> >> if (order)
> >> 	folio_set_large_rmappable(folio);
> >
> > That one is in zone_device_folio_init()
> 
> Yes. And the code location looks right to me.
> 
> >
> > And maybe the naming has got really confused if we have both functions
> > now :\
> 
> Yes. One of the issues is that device private code used to only handles
> order-0 pages and was converted to use high order folio directly without
> using high order page (namely compound page) as an intermediate step.
> This two-step-in-one caused confusion. But the key thing to avoid the
> confusion is that to form a high order folio, a list of contiguous pages
> would become a compound page by calling prep_compound_page(), then
> the compound page becomes a folio by calling folio_set_large_rmappable().
> 
> BTW, the code in prep_compound_head() after folio_set_order(folio, order)
> should belong to folio_set_large_rmappable() and they are causing confusion,
> since they are only applicable to rmappable large folios. I am going to
> send a patch to fix it.
> 
> 
> Best Regards,
> Yan, Zi

