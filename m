Return-Path: <kvm+bounces-65094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 61082C9AD22
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0BE3F4E3374
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B16B30BB94;
	Tue,  2 Dec 2025 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dodFWzQG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA13D29BDB0;
	Tue,  2 Dec 2025 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667119; cv=fail; b=hS3VsohKIheRnsskNwxi35faHk22O8czy+SKGrrGYxNvz1r210Fb0Jk79vEs/wbdgxuyshrtCLkiUIRp3sMWqYapXBRyhEkYLKTpCU4/vLDxLOL3QjGa1TkzuN+oGLagL7nRNJzJ7ALrdztIfdAJx+Y5Nd4StE4Edgvyh8103XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667119; c=relaxed/simple;
	bh=OVV40PoFrC/QX4kuaghgWzgz3sLQUWhC+/+1Vpp6PWE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lBlJGQOgydILxlGP+M9ggGGdZfPwtcb4ZQVzzdz5QqpaEqIi3xJfTzwnB7aLTmlxdza0/wuyLB1mW12qm9s6JNUnFnKDlATlQ4VfScMI93H+46XbfT1yhubQXq3s6jjn8i0h1+vSrro530i1kOBuf3vvLNi9mdrENrpy0mFYH+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dodFWzQG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764667118; x=1796203118;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OVV40PoFrC/QX4kuaghgWzgz3sLQUWhC+/+1Vpp6PWE=;
  b=dodFWzQGECnuHG6/Q8EAXsYlEtSMmjAliS6eRSD9Pv6kmObgLMGdOjmi
   NYJnk3D3uGty2GZby3dLOdn8Go63TOJN/WTmYIhd40MqYW98M01Z9lHum
   8XPDgye/B3Ed/awCZJSkKuVZmzjjPY+bryVum1FEUTy7oSCBuIqkY9cPs
   Cpn9uCfhkOpVFK7eRm1SEeKheHhLqdUhhfgG8QX9DPicd02h6d3p6k/x6
   xZmJ7oQJwwdC4YsBqSHMk9nE0q0IWrvg5jHrpnKSgqn1iEDXqgRYMJu5F
   McFy6msQ/tFWh17csMSTnma84wb05zEFKxjVCfGMJcJ2XYrr+v+ergc71
   g==;
X-CSE-ConnectionGUID: FxsYhEaOTniPl5rbR8b3Tw==
X-CSE-MsgGUID: GO7OHUHvRU6E903HXIKTQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70242900"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="70242900"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:18:37 -0800
X-CSE-ConnectionGUID: zm+VIKdOQWKh0Z/BOUUfNA==
X-CSE-MsgGUID: BVHFOeaOSB+cYPi++9YGqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="198702498"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:18:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:18:36 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 01:18:36 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYBJLln+bV/LAj6vlKdz5cCzrB9O0EAwT2FFGk+BdGYUULMhXNfMsDeus0sQAY5UDNx1lAmWnFESUtZiyDkVq12g24GRtYUE8cpVzSG8UfCO7CkyEJyb1YPhloBKa6s/Xy8ISzeXmHfZnZUtx7d3R3yO22lV2gyYwxCTBFXv5xWkEWtssttjqT85FDVtKctfE0D2b44pJI/MHiuS78BMvb04pwMvLyym9nsQ1GZRP+I8BwXMiDaNbkmZHARTRT1PvG9SAnOwgdg6nn4fx+2RWqZZAac9MihRGswc8bPdR/2X7WL3gx0w0GiEjiBy6xKz4j9zdglop+5DLYy53y+2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OC7zITKVFsDf5TSeqXovisQZJiydFJTbiCxotBdWX0I=;
 b=Nvku1eDPs0QxxphtyectPpZkNZ5pyhic4VBLCWVuRh9DrWi/fFvfE1HRxwzz0mHJjse+iedpVMa1eCbE6CU3ZSWH8j1DWy9o2Yu4Rp9KxbMEFVsSVSk21djAAqwsUeWg4pETNB0xstcKBwpCDzxhLmeioQ9jx54SSk0esGuCfJwYm3iAWdoa1Ek8cUa07XNuUz1XCrCfpMP1Ldgb/+nQKrpw1ffvXlcrV+1N7v2LD8jciKGlmDjufyTQWBeXCH5CRrrgFf6fbdPcZ8q2WYC+wOj1eTh9STzmm86KhaEMDnSmXzIfSmQw1ekoKoBdNLhhQHDl8JEQYiWK87agW9/03Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6989.namprd11.prod.outlook.com (2603:10b6:806:2be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 09:18:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 09:18:32 +0000
Date: Tue, 2 Dec 2025 17:16:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aS6uFyCd0+qSKeFf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
 <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
 <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9e91a6-bad6-48f2-147c-08de3183c3bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tk40aVJMNy9Ra1BKUWQ3RWJhdDhBcTd4VDVtM2hVdHZjOVNiaThYSFFiUlIy?=
 =?utf-8?B?RXZiMzVrRzBGOHAxc2pKZldaeGNKZ0V2YXRTZWNac3U4QjRpTk9JK0ZBMmJY?=
 =?utf-8?B?SGFqeGVOK255OHpOWS9oS2NKR2V2OTZNNFlWK1E2TGdsYVFlM3lJcTFGNDc2?=
 =?utf-8?B?NittUTdSc3hyUkptaUJnL25XY0d2SmVzcEg1VkgvUWl6S0czZlZjUlJnS2xw?=
 =?utf-8?B?eGt5akdIaExYS1BRaXVhZjJ5Vnp0aGErWkVzT3YrTmU4RSt5Ynk5U2ZDZExu?=
 =?utf-8?B?RVczbW1SakVBdWVKeDM2TUJDcnFIUDhzeWJmMHBaRjY5aWlYTzVMejM4WlF1?=
 =?utf-8?B?N0w5RGFqRFdaOWk4OXJsVHlPM1JCYVlXWGx4VzZ0bUVsTGI1V2lWMWh5dUpY?=
 =?utf-8?B?VzZSQjFEWHZpRnlQN1BNbk90SjU2ZUk2WTZjelF1eFlKYVVYZGR2YmVVMTJv?=
 =?utf-8?B?RGtTSVlUSTVmWmJvTHVqTXBFSnNMajVreVJHenE1SXJwYmpQT0dFRWFSd3dD?=
 =?utf-8?B?NWpFM2RrZnBieDFrelJTYjZKMkpCY0R1UFo4ZStqUzRrK3V3RmNUZ3BuNCtJ?=
 =?utf-8?B?dUJZdTJQNkE4V0xydEdLQWgyQk1MS2MwRWRJc2cyYUFRZGRVY0RqOXpJWUZi?=
 =?utf-8?B?QXBEbDVDTmtWOXFyZGlxUTNPRnpIY2wyazdtbmliWGlzQnZ6dEdqMkNqVHVr?=
 =?utf-8?B?MUcwbkpYdFJRbkFLSFk2YmlneGYyMmg2Qktla1ZIY3phdEgxYkYyY1pHUU03?=
 =?utf-8?B?Z1lQTUhWcjNtVExIUSt1WHdZUDR4TjFDZldyMXJCa2d3ZlNQNkg5MDBVdlZ5?=
 =?utf-8?B?SEl0ZzY1dGZPcEt5REJIRHNUWVVBbXplQ3V0OS9vVGt0S0F3UWlnSEdFMFFI?=
 =?utf-8?B?YU1wOE5CZ1BQcWlYVjk1eGprWHJHNnU0RG1PZVBncGZMWjJCVkpmMzNVRG5p?=
 =?utf-8?B?RDdmaFRxQjBUR29QOHJhYTQ3aUN6ZWpFRlVndFV3Z3k5MlVLdUZnSWJ1R2lR?=
 =?utf-8?B?ZEFDWmFKYWNRbjNSaHRMUlcvdnNZSEk3NVlWblFKaU5vcTdDQzlGV3RuQ2lq?=
 =?utf-8?B?R1lweHdhNWlONW5nRktwT0JnUE5NN0QyT3ZHRFRRdS9sbG9tWHpRdWdHSnFI?=
 =?utf-8?B?aSs2YXJSbStsanFIejNFWUdta3d6T1dvWHo5VkdSZ0UwMHZ4Z0M0ekpBUlBl?=
 =?utf-8?B?alRyV25LM2VpamFicUhtSmY2eGVsWVUrOG5lNy9YNzVjaEU0VThuc3VmdWVm?=
 =?utf-8?B?OURvRDREbFdyYUZOcjFmU0RQUnoyelVzeVRKbTRRN3lFVmFReXBIUWt0Qkhq?=
 =?utf-8?B?ZWdjSHJ3ZGVkRVllL3Q3M1Jmb3I5bGIwOFpSbGEvRjRRK2JwMHFrWEpaRnR4?=
 =?utf-8?B?Y3JhU3ZwL0lUNmFDR0ZibGprcTYwNE4rMEFCMDg4ZldrNVVzS2pmQ29nSmU3?=
 =?utf-8?B?WE01T0hOSUs3Y0w2VUhrbnArZTR3UHlWUVJRTVNmdHlHeXUzWFlhdTNhdGEr?=
 =?utf-8?B?RmV6aHdOZ2Y1M0UweFNCdVdHdWF3SWlrNzU0aFZsY2R0aGhpSUh0eDNsTDkz?=
 =?utf-8?B?OU54b1lCUzB0RE1zQjJzME9kQlVmZ2J3RlUyWkU5WHBjYklsdTIyS3dSbjgv?=
 =?utf-8?B?S2llQjlnamROSWhtQitDbWI4UkpCSDdURzR3Ymd2U1diQlQ4SmlLMTZQekdF?=
 =?utf-8?B?QkFmTmdSako1MUJOOHE1TllrU2dZcDRwSnJYeHBpWGNzeGRTeE9LcURYODF3?=
 =?utf-8?B?RVpZbDhyRERzaGk0UlNyT2tBc09qMllmbG4vSFIrNHh0bnN6dm0zcEFSeXRT?=
 =?utf-8?B?bDF5ZllVS1lxNmRnMXljT05saE53SjUxQk03ckpSNlN1TGZjTG5sUDZFdmpm?=
 =?utf-8?B?QjV3OVRmNFZ0R21xNHlFVmNPMGxwek5OZGcrb2pTakJmVWFLMVJWcTJ5MEVu?=
 =?utf-8?B?K1NNVlAvcElsVFJZcEFJQXV5Z3lTSGIyaDhvdUJ0Rk5HbDJPNGhBSVIvRkFr?=
 =?utf-8?B?SDRxY1FDYS9nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU5WWTVEMjBaTnRyUnkxQUJTQUgybElBbm85cXlyQmdCWnludU45SnB2STN6?=
 =?utf-8?B?RDF0Q2NoTHVaaXJadW13NnpYWnBvQldDUVZhQXpHUDF4OVRlWUoxQmVqclU3?=
 =?utf-8?B?KzJGcUMzOGZKOUdKenN1TmswSU9JazBTb3Bvdy9FMFhkWEQrU1Q4dWlCMVZk?=
 =?utf-8?B?OHpJcjA1M0MxdlVhd2hTMkpkdGV5Z3NDVHJLcm85REluZC9SUGl6MDRmTXBj?=
 =?utf-8?B?TFBxc1dieHF4QkxEa3lRM09nN1E5Sm0wTTdheGdDeUN0WDBHRThJenNZMHZv?=
 =?utf-8?B?SWtQbmZ3OFhnYnlpVUpoZmVva2REeFN2YWZ6cmRXcE5QblpURkY3YjI1T3RX?=
 =?utf-8?B?RHBCcXlVT3N2VnF0djY1dStqZWY3SlJFM0ExWEQvTzFhWmVBanVkOENyajdL?=
 =?utf-8?B?eVdEWDE4aTcwUFg3RWdsWVUrU3ZobUV2UU56UzJtbC9IRFg1VU9ReUIwR3Na?=
 =?utf-8?B?VVhLZXd4NUNJc0dUNHBpOFVvNUFhTVBmdVJ6RlU1VGI2WlcvNFV2aGRMMFFx?=
 =?utf-8?B?S0dDcFNSYnM5YytxYmZvcE5jMXhxc0gzMFhnaVJBZElzUitoclBIYTNsM2Rw?=
 =?utf-8?B?MkRlZlI3ckdEaEU0VkZ4Z25Md3FzbllueXFmMHlySHBPK21SQ0NCS253Rk5s?=
 =?utf-8?B?SDRBWDJFWGtXR1k2TmJmT0N1RjlkVExYNzhUVWdYaEdySHM0cnpiTzNIaUxH?=
 =?utf-8?B?VEVhanVRUDhHNkJISkJYRWd1elFSUU9zT2xldGdCbFduYW02bjc3QjFEU2Y5?=
 =?utf-8?B?bTNlUFNycGNmTCtidmNzWU5jemxYMFJHMlVrenloWGRuY1F3Vk1WOEw5UW52?=
 =?utf-8?B?dERCTXBEYlBJN3JkNVJCckVOSW1GSnArZ3IxYXoxd3d5eEpxY21obVd6THgv?=
 =?utf-8?B?OUxnVGtiZXkyUGhQd1NlWGRkUFFqbG45Ung1WDEydVFMcG9YOTd4Ulg1RzBM?=
 =?utf-8?B?Q3g2Z1BQRzByQ29KTUVOWDJVeW0zMEZmVHU0ZnhyMGRpRTRxZGlyekdmWFVq?=
 =?utf-8?B?SzFjaEZGbU9sTUxKTHUwYWc2cDVZYmNWdHM2VHViUWx1Qkt1MFVoMFpIR29D?=
 =?utf-8?B?dGh3ZWJ3TDFTenpCcm9janZ1YnR1YUtFU1c1b0xSSEN2YVFpTThPMVZkN21m?=
 =?utf-8?B?R1BkaFdRNzhvYitKT2lKY2sxdkVUM2lJbmt6c0xkMWdNUEt3bFhnMXNNdkhz?=
 =?utf-8?B?QU9ha3IxQk1IV2pCT0w0Wk1uWmRoeGd3Q2lIc0l6enp1eUJ4eGJwQmYvWjN5?=
 =?utf-8?B?VWE0QVdVek1qc1dRRUlCUzJ4Z0l0Y1A0d0R0ZkJLVGVhNkxBUDY4NFdjU1RN?=
 =?utf-8?B?RDhmWDkySUs1QjQ3RnpUTXlGN1VLQlZPbytzaVNISThMaStIdFBUTEVDa1Ax?=
 =?utf-8?B?VTR3OHpxOHkvZGthblpWRGFkTWRIdzZETGdLRUNjaHlid3ZKRFBBdVQ3ckJk?=
 =?utf-8?B?V2pWVVh6M0V5aWI3QmJ3empnMjBQaEtqK1RqUysvZ2FSQUR3NktXZW1lNjdz?=
 =?utf-8?B?a2I2cThwaGtJQld3dkVzZWViUDBLS3BHa2p3dHg2czBsM3gyOURVWTJQWCtt?=
 =?utf-8?B?YUhYQW5XVzVTbDcvTmVnUXhLcU82clV3WWg0UGxOVHNVQUxNYTdxQi9GMmRI?=
 =?utf-8?B?bTJMZUxTYUhCdVpjdjZmNjJleStydW9QMHZuTCtqS1BFeHVDcGNyU0JhaHJu?=
 =?utf-8?B?S1ZiT0R5a1NMQUxuNENzSjl2K3N6Ujk1Zk81OWZSMXRtVkVzRnkxQlJ5QStT?=
 =?utf-8?B?cU1LVmZBbFVXUjhlWFQzWG4rRnQzNjFwZmRkMzJ4c3ZpeUZ6T1pCc0lkNGFC?=
 =?utf-8?B?bWl4aWFlRW5CN1l5Mmw4TEdOSWxQSkVndTdyMVZwcW5ROWtCZCtIeXp3OWU1?=
 =?utf-8?B?M0k3elp3aU9JOWV2dkdMVGxHc0tPeHRkL3ByK1hpMloyTkFnWUFCeU1kNGdv?=
 =?utf-8?B?b2w3UnRMdFFnRXo2cUx3NHJLZ2xFZmEySTVzRTNUMzFvOEdtRjlBMy80c2NZ?=
 =?utf-8?B?SkVvTU9qZEZyVUM0UTIraWhsOWJMdW5sSXh2SmRrSjB3YkRnNlBGTXd0bDh4?=
 =?utf-8?B?RU5nWjF2dnRaTXQyT2ZHQUxxdmp4TUVpdjMzU01JMEFmeXY5MEJPeTZEVE1m?=
 =?utf-8?Q?M0Tc4YEVnRaIiyTeIWYhXlL/q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9e91a6-bad6-48f2-147c-08de3183c3bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 09:18:32.9057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMQWhUqcXe9lcfpoyY1a1oP++GnpxsoJraxR1OSTHodPUT+pauhZAGkZ33XaMbnn+CMGJngf5XJ5+7dTgoaVXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6989
X-OriginatorOrg: intel.com

On Mon, Dec 01, 2025 at 11:33:18AM -0800, Vishal Annapurve wrote:
> On Sun, Nov 30, 2025 at 6:53 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Sun, Nov 30, 2025 at 05:35:41PM -0800, Vishal Annapurve wrote:
> > > On Mon, Nov 24, 2025 at 7:15 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > > > >           p = src ? src + i * PAGE_SIZE : NULL;
> > > > > > >           ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > > > >           if (!ret)
> > > > > > > -                 kvm_gmem_mark_prepared(folio);
> > > > > > > +                 folio_mark_uptodate(folio);
> > > > > > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > > > > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > > > > > uptodate?
> > > > >
> > > > > Quoting your example from[1] for more context:
> > > > >
> > > > > > I also have a question about this patch:
> > > > > >
> > > > > > Suppose there's a 2MB huge folio A, where
> > > > > > A1 and A2 are 4KB pages belonging to folio A.
> > > > > >
> > > > > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> > > > > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > > > >
> > > > > In SNP hugepage patchset you responded to, it would only mark A1 as
> > > > You mean code in
> > > > https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
> > > >
> > > > > prepared/cleared. There was 4K-granularity tracking added to handle this.
> > > > I don't find the code that marks only A1 as "prepared/cleared".
> > > > Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
> > > > to mark the entire folio A as uptodate.
> > > >
> > > > However, according to your statement below that "uptodate flag only tracks
> > > > whether a folio has been cleared", I don't follow why and where the entire folio
> > > > A would be cleared if kvm_gmem_populate() only adds page A1.
> > >
> > > I think kvm_gmem_populate() is currently only used by SNP and TDX
> > > logic, I don't see an issue with marking the complete folio as
> > > uptodate even if its partially updated by kvm_gmem_populate() paths as
> > > the private memory will eventually get initialized anyways.
> > Still using the above example,
> > If only page A1 is passed to sev_gmem_post_populate(), will SNP initialize the
> > entire folio A?
> > - if yes, could you kindly point me to the code that does this? .
> > - if sev_gmem_post_populate() only initializes page A1, after marking the
> >   complete folio A as uptodate in kvm_gmem_populate(), later faulting in page A2
> >   in kvm_gmem_get_pfn() will not clear page A2 by invoking clear_highpage(),
> >   since the entire folio A is uptodate. I don't understand why this is OK.
> >   Or what's the purpose of invoking clear_highpage() on other folios?
> 
> I think sev_gmem_post_populate() only initializes the ranges marked
> for snp_launch_update(). Since the current code lacks a hugepage
> provider, the kvm_gmem_populate() doesn't need to explicitly clear
> anything for 4K backings during kvm_gmem_populate().
> 
> I see your point. Once a hugepage provider lands, kvm_gmem_populate()
> can first invoke clear_highpage() or an equivalent API on a complete
> huge folio before calling the architecture-specific post-populate hook
> to keep the implementation consistent.
Maybe clear_highpage() in kvm_gmem_get_folio()?

When in-place copy in kvm_gmem_populate() comes, kvm_gmem_get_folio() can be
invoked first for shared memory, so clear_highpage() there is before userspace
writes to shared memory. No clear_highpage() is required when kvm_gmem_populate()
invokes __kvm_gmem_get_pfn() to get the folio again.

> Subsequently, we need to figure out a way to avoid this clearing for
> SNP/TDX/CCA private faults.
> 
> >
> > Thanks
> > Yan

