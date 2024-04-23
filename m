Return-Path: <kvm+bounces-15590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3088A8ADBA9
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 03:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54DF11C212A7
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 01:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08BF014A8E;
	Tue, 23 Apr 2024 01:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmx4bTqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD7A3FF4;
	Tue, 23 Apr 2024 01:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713836752; cv=fail; b=JbV2V+A0OwqA1sKYTGnzsz8Qo3o4wHxMbFQy5dbMUSqEsK9LEdCJwgjR+5mSdMFHT6z/OmhQomrqBv9oENq5NTu92+vILu5kJ1MHnp8VbFE7fK9UYfiEJ2OAfng75GQY7BJNDw97nP2JSCQsibKlXr3XZIaAoC46LpugxDMiYv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713836752; c=relaxed/simple;
	bh=kHQM/QBw7jj8Uf3c2/eH5nO5H2G3TZzVyWyUTZ9uJYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cJW9AKZVL0lNBQtrPMX+IdcJnrUHL7izAB8gzB26GYyo5ynhAXAiAwDDAlHblD+Ts8tTf4zYYCifY1bX1lTXUT0DJkuU/hXrBDezKRHakKs2oOvMAaup2RDmWFO6maA+B3D9LmncaN05uAoexWqFqWbyACOUxfv3HPBOERWZvqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmx4bTqt; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713836750; x=1745372750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kHQM/QBw7jj8Uf3c2/eH5nO5H2G3TZzVyWyUTZ9uJYg=;
  b=hmx4bTqtOXWz1Pl98s5pmsABCfyWDhsXOkJeSvz7bdhMevkhz3RQtgSQ
   NE/g2quhpF64DuyOCA+B6MP9k/qM9MXZLZ2i4Jdp09NXZoFEGZFpxmnH4
   ltbEjf0ez2LgBVLlhOaP3aZIsqwZwKt3/HOuEaMlKIs7yHnCdMBOPEz9P
   7TVYjlHr3wtdj9ovtz/ISXyv1JLZq1cmKTfWSE3xdK6pBWPg10NvjCJ2V
   2RQ7vjsZK34iqf7DHlxbVuhTa4fX4AdD6iQErCtn8OCAdq6S8ZNS3ZZNt
   m3l/aJl1efuPf+ECy9g1H1t4w6Tvr0zq7tDW6xC5GiLAnk7xFNScehBHy
   Q==;
X-CSE-ConnectionGUID: 5c7MylKjRjWzV2LQJ5+0pg==
X-CSE-MsgGUID: ZdDA0GHkRF+wzLRQrU9p1w==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="20014655"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="20014655"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 18:45:49 -0700
X-CSE-ConnectionGUID: VzMAA8vNRnCKGsKeRWraEw==
X-CSE-MsgGUID: LtmwJ2kHTzeqaN7HY6UGxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24277484"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 18:45:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 18:45:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 18:45:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 18:45:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAoN9qG7klsPT1Iwm/Y7dEmiWkvQBMDeegZLNGtoiT/gY3Q6h5a894+GVg6vYp3hzZKsU0I7OEF+uAzG77ZkXEdCmFMHKbNXpmkpnasVMMoltXMMv/EZ5f1PO9y0eUUV5C9RtHCPJYQW6tkOqt2R5upqFIJyOdWWmOq+HMV35/hqvZ/jlYOJYKKCYeOHyv3tY0x2k/RdQtOObMq2IoVF9cbNu0w/gtuCptMPmtLCaSnVvWqh0tQrniij6QghSkNONMi1egyjkUDAtcd8BxNpgafgEQT9oGt6Flok5uwMjQ8+zU+4XKzvg7kmtXFI7kYj+IWK+OQHxV6f8gt3/U1z0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHQM/QBw7jj8Uf3c2/eH5nO5H2G3TZzVyWyUTZ9uJYg=;
 b=QixCuw5Z5P257U4GFr2YgnEchg5xh85HFDADC4+yNdWPLDTFDsrYjlz4n7bfg2s/pR4mKu54x6OPnckCEgpd18/TzTD+ylUO6UjC9VpZHy2x2kHjK4fyF4oFrprcQ5QzYaWqhqCISs8MNASiB3fTnGwg42Wo3snUq4VyUn14TviIZzgXx7bANfGcdK76aHXDtEx2wJOFRqRGnZkuCgUXjM1i/jY9gZohZsGjdJAwHchEC65KkEqtP6Apy50kgGN/jptvvE+TztdVgrWyhiweMRMXyu82geVCsLYnCovzlFse3PTE3pnnOoGMWBvjxGVQOp+oIfo0wlWp2QBtwCFKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7580.namprd11.prod.outlook.com (2603:10b6:8:148::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Tue, 23 Apr
 2024 01:45:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.018; Tue, 23 Apr 2024
 01:45:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+A
Date: Tue, 23 Apr 2024 01:45:45 +0000
Message-ID: <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
References: <Zh_exbWc90khzmYm@google.com>
	 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
	 <ZiBc13qU6P3OBn7w@google.com>
	 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
In-Reply-To: <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7580:EE_
x-ms-office365-filtering-correlation-id: aa538d4a-5366-4b9e-bf86-08dc633717bc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bVBSMWdKRTJock5vaVhFeXovbmlobzRETW5PejNxRXpSSmptT1BpUHRRbVBs?=
 =?utf-8?B?REZlb3F1R0lrM1JRWTlyeEVJRUcxekpHZlBxeWFocmRuNWJaRGxKY2l4RWc5?=
 =?utf-8?B?cVNyVUYwWnBnaGtpSXBIZWlZSi8wczFWR0o5Y2M0MU1Ld096K083b2lkMjRo?=
 =?utf-8?B?bHNwNHJwNXZKNFdwOUV4OHo3c2g0Q3ltME9aT29nb3pGZkgyTnZPSzZOdGdD?=
 =?utf-8?B?NUtwQ253NDBFWDU2NzJoUHhwZlRvL0NKOFo5UlVDcVZQOVZoZ2dZaXRiczN0?=
 =?utf-8?B?dzlJOU82S0lBMytraldUb096WE1yNHBwZ1pUUlhJMC90UVRQY2NqbFBvaEY4?=
 =?utf-8?B?eitSM0tQVnppTWpqb0g5M09HcnZwN3NjZTFGKzErRGt1T2FaSXgwSGxtVzR0?=
 =?utf-8?B?Y0NpVXBmR3VWNHRvekMzWFo3dVFkWUJncTBndUFuTnJOZFF5MUlkeFQ5T2U0?=
 =?utf-8?B?TDdYQVFWckJoWTlNaFBLT3ZyQWNJOVFTZVVrREkwSTNvWW1lLzVPYVhmS2JU?=
 =?utf-8?B?UERlS1FySWRKNDdSNTBKNlpySFVrdEFIZG5xVlZSdHUxQ2xFbGRBbUV4WW9P?=
 =?utf-8?B?QUtRT3huZmxjYUpFOVBWY0djQitpWUV4eTVUY1VvT3lwb1QxbnZFRXNwRDVx?=
 =?utf-8?B?Q3VvcksyOFo3a3dCeG8xdWFPeFpCdFY1d3pLMi82L2RrV1VmNExuNjhPU1RH?=
 =?utf-8?B?RWVVdzJOT0JHYVNLWUx5MVdlOEYwaDdkZjJWVlR2bEczR2RjSkNwcFBQK3c3?=
 =?utf-8?B?VjZaNW1DRHNmRUZJZXVyaE9RVmJaVHNOTEd1K09ZTDVkOCtXWnFHSXhuUzhC?=
 =?utf-8?B?WmU3bkU1T3pDTUZTZENTVHdVclpHU3R5bGpYU1YyMnRFbEU0SSt6bjNZbjhj?=
 =?utf-8?B?aXQ3RTljcHliZEhhZFo0TWQ2RCtyenpCTG5ZdjNnNGhzNC8zL2l4RE5vWHJR?=
 =?utf-8?B?ZmwrUEZIYzNJSmJEYkw4TEVUN0lDbGFyWU5xUG9MRzJLVGhvcWZOLytpVi94?=
 =?utf-8?B?Qmwrby9aVERaMlVNQ3B2RVpkYnJzTE5DRWR2TjhHakF1cHd4MzRKNXVsWEVI?=
 =?utf-8?B?M2FOVHQ2ek1SNFhzSjJhY0kwY0wrbWNPa2ZtbWVUMWNRYlJZT2ZJUTVSNExU?=
 =?utf-8?B?NVdHOHJuMXpPdTVUdUR5b3l6UU9SSXRZSk5LYnpEK1VXbk9IWjFES1gzczQ5?=
 =?utf-8?B?a3lJL3Q5QUJzRGY5OERjZmtJdUxSQTdqcm1KMVVzWHY1OHNHMUU3SFlmK0RT?=
 =?utf-8?B?VVQzKzNkZXdwYmcwakhKRU42M1lab2JkVGExTy9BS3VFRU9RNmt1V3ZpSWhR?=
 =?utf-8?B?bzhETFFjWDM5VE85bDZEK3RQMlhzOFRaYVZPSGE5cUxJLzZGVTZ4QkU3emx4?=
 =?utf-8?B?eUg4Ym9lc2VtMHE5NjVQWFQ1QTdLTk00R0dxam84Ny83UlZERVV2QUxUd3VG?=
 =?utf-8?B?ZFpiNFJDY1p5c3VtVUJZUFRMbjBIM1MwV1dZQmtZcndxTWZuN2JiMzZWVHh5?=
 =?utf-8?B?OFBoQlhhcy95aG8rZFMvaktFYm1yOUcxUVl2N0k5RGdaN1ZMdC9md1dsaHZ3?=
 =?utf-8?B?WUh2ejVnckxxRmhiRVdzOGxiaDdPWGc5VysyNWJtd0U3bGtMekorYTBIN0Zj?=
 =?utf-8?B?UWh1TFowTm1jWElhaUw4dnlmWmt4eXJ6bkE1VGZzRTB1d05QbU1jeCtGRnVw?=
 =?utf-8?B?NncrVEJlczNTNWRGUTBMTXg0ZUFncXFnSkZWYUlCclRvbmFOOG8zZmVLY2Iw?=
 =?utf-8?Q?AMTUgmP3CKO3YuzJiE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VExZVWFTSEZxUjBBakp5UDNadlB4dEdDRlhtWEJhc3FWczNuYWlyQXE0ZWdY?=
 =?utf-8?B?QjRaVFl2Mk1PaHpyUnRIcGF0cEcvTEh1YTMveHlpaldLR2JLM1FmTmtFWkhU?=
 =?utf-8?B?QStWVTc0NGpyYmUxQnhIZm5zOU51Z1o1NTJDWXNuMzhydTlva0pzejV5eG1v?=
 =?utf-8?B?OE8wRmFVNHhkdHNDcWtWYW9ocUVTSGJTSCs2U0VuYjc3K3cvR1RBSGZwcDA1?=
 =?utf-8?B?bnJIblN3M2liUlF0NEcwajBYeEdaOFRPVEFqbWEvNTEzRHdxSjVsNkh0T1dh?=
 =?utf-8?B?K1Y1d0ZLc0djYnd6UmxiWVREUmxCckEwMUVLRDhkM3F6eHFZUm5EK3N5NG5Z?=
 =?utf-8?B?bDNMVE1lQ1p4Nm5uNktwdmJndGhvenZZMERWRnpMMmdaaitucGJ0SDFyMHJR?=
 =?utf-8?B?T2lvVVN4bjJyNlErMy9lWEh3c0NNS1ZjQWtrOVVVTGVCT1d6dXN2dVVabmNQ?=
 =?utf-8?B?UFVmZzhVRjk4L0xBTEtCNmhnL0ZhQXJIaGs3Y1MwRXY3V1BtcFdiWjNDcUlp?=
 =?utf-8?B?NjVvVGdTRFBjS1p4anFycUJOUFJpaW1PSGp2NEp3cnBMRXYvdzNvcGVqS1Yz?=
 =?utf-8?B?N3g0NEZNTXc2K2M5M2ZQa0NUNS9sUHZuY2ZaZkxna0VLMFhVQk1hZitScXJW?=
 =?utf-8?B?dDVzblhOUkcxVXA2eUxoc2tXdFZVSHRZK1RwOG0wcFFOelhIMjNSUU5vTDZZ?=
 =?utf-8?B?UTNycVRzUVQzdFV6NlloaGZZS0RGMU1mdjJYdTZGcmx4QzdSK3NyaWpnTUo4?=
 =?utf-8?B?NCtGSHJXTWF6Uk9zKzRyR3kwNWIrYnM3SHBNdzUwa3doTkIwNlJ6RWpJbEZr?=
 =?utf-8?B?ZVRNNWdqUE5rd0dUYUNmYXNOQUVaOUFiR0llNkdwR2tSQ2FheFdXaWp3VFI3?=
 =?utf-8?B?aVJlMnlQODlJRSs5K0NXY2ZPRlZOUDVuNDh3SlpTTDJGSmpodENuMjVnZVhr?=
 =?utf-8?B?S3hnWTNLMVpXYVZoUXBkV2VRVHl1bXU3RTRmUVBnUEFqdDVDaUJ4VDF2K1dt?=
 =?utf-8?B?aDkrS1lXQ0h0M20wL25TNGx5dWlsbVhpb1pkWEJ0TTBXYjdEdzNKd1djeVhM?=
 =?utf-8?B?RExZeU40eklHcXI2alQyUlhlMmNRU1NRTEt0OHozSWFtM1FSNXE4ZU1WK1lV?=
 =?utf-8?B?WVE1RTVlZm9qZ0l6N0xINXVJZnRsbTg2Mi9yWlFoOFMwZUNPblU0S2R0MEpL?=
 =?utf-8?B?U2U2QnZRRUQ3aFZrZWJUVXVlZmVvWDRvZE1sbGw0M25ZZVcyRGZoc3Z6WU1z?=
 =?utf-8?B?TWM3UytMcTdkMHhsU3F0RnBBelVsUzVTbCtiYTJoeWRwM3ZFS3YyNzBTOWRp?=
 =?utf-8?B?ODFvdlVGeXZMWlZkVWJLYlFSUXJoVmtLdDZ6cW1SUUZCVVI1a1FSTVVhVS9q?=
 =?utf-8?B?NVBLbStDQkxaNk9RdDNRTGFHNU9kQUNNSlIySHJCQy9pbUxVeElPaTk0TFdh?=
 =?utf-8?B?WGx2STZFZ1F1S0lxdXFaR0lSdmgveDRHclVENmxSbURYMnBCMnU0RzZHTVhH?=
 =?utf-8?B?Zks4enVVOHRmeGh5UnBBT1VZRXF5SmVwcjJiaWUxcXc4aEJadzNZWkdXZ0cz?=
 =?utf-8?B?YUVZS2trTzJGZE5EUEVLeDlnNmR6Y0RSWjlpRVZ2RW9Za0tuVTFMckVIM2E4?=
 =?utf-8?B?MFZYWms3MEp2ckh6c1BrRTdESTVORUx3ZlpoL0d6dmVWUDNvWmRlRnBORjlw?=
 =?utf-8?B?VUNYMDhFRVlEbUw2U2VJOEVlcWRqVHNrbWJnVDdZb3U1ZjNKOUVYVms1SGR5?=
 =?utf-8?B?dTVBMktHUlZERUI3SE8yYS9mWVRyRmcyenpzYkU3VGVXanErZHRFNjZzekl4?=
 =?utf-8?B?UlZLTkhmN2JERzRDc1poT1EyTXZrODdaRXh5RVh3ZGRCVWhmcTMvc3JLcjVt?=
 =?utf-8?B?aFRlMm9vaWxxcDA5c1lEVm5QUncrTkkwQ0lXL3JtK1o2c0J3Y25lSEVuMUZq?=
 =?utf-8?B?L2xEMU9TdFFvOWdUYWJjVXE2RXlQNFJhSFBzMlZvUGowRTczdU5IRlcrR0JJ?=
 =?utf-8?B?eVo4NnIzOHJ2aDg4RmRvOTM1amtpS05IMkErTStML2tJSnJldm41NzRMZG90?=
 =?utf-8?B?VUI3ZitPRDRnYjJ1LzNqak82bUhHdGpuTVRVZExGMGsrRUpJVklOdjVmVzU3?=
 =?utf-8?B?WjJ2M3VWK3gyaHNsM20zOFVzYjd3dkhrZ0tJNnNBNllma1pYOUhRb2hubFZ1?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <474426923B236F47BF0FD910D842127A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa538d4a-5366-4b9e-bf86-08dc633717bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 01:45:45.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nmZoVl0WHFnsh+YOVvJ+9xwL6c3RPph/B4oBFun+rhkK4j/3cLtnhfRccz7r84S35c/2S9qKxs5ZP1Yfi94erA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7580
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTIzIGF0IDEzOjM0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
DQo+ID4gPiA+IEFuZCB0aGUgaW50ZW50IGlzbid0IHRvIGNhdGNoIGV2ZXJ5IHBvc3NpYmxlIHBy
b2JsZW0uICBBcyB3aXRoIG1hbnkgc2FuaXR5IGNoZWNrcywNCj4gPiA+ID4gdGhlIGludGVudCBp
cyB0byBkZXRlY3QgdGhlIG1vc3QgbGlrZWx5IGZhaWx1cmUgbW9kZSB0byBtYWtlIHRyaWFnaW5n
IGFuZCBkZWJ1Z2dpbmcNCj4gPiA+ID4gaXNzdWVzIGEgYml0IGVhc2llci4NCj4gPiA+IA0KPiA+
ID4gVGhlIFNFQU1DQUxMIHdpbGwgbGl0ZXJhbGx5IHJldHVybiBhIHVuaXF1ZSBlcnJvciBjb2Rl
IHRvIGluZGljYXRlIENQVQ0KPiA+ID4gaXNuJ3QgaW4gcG9zdC1WTVhPTiwgb3IgdGR4X2NwdV9l
bmFibGUoKSBoYXNuJ3QgYmVlbiBkb25lLiAgSSB0aGluayB0aGUNCj4gPiA+IGVycm9yIGNvZGUg
aXMgYWxyZWFkeSBjbGVhciB0byBwaW5wb2ludCB0aGUgcHJvYmxlbSAoZHVlIHRvIHRoZXNlIHBy
ZS0NCj4gPiA+IFNFQU1DQUxMLWNvbmRpdGlvbiBub3QgYmVpbmcgbWV0KS4NCj4gPiANCj4gPiBO
bywgU0VBTUNBTEwgI1VEcyBpZiB0aGUgQ1BVIGlzbid0IHBvc3QtVk1YT04uICBJLmUuIHRoZSBD
UFUgZG9lc24ndCBtYWtlIGl0IHRvDQo+ID4gdGhlIFREWCBNb2R1bGUgdG8gcHJvdmlkZSBhIHVu
aXF1ZSBlcnJvciBjb2RlLCBhbGwgS1ZNIHdpbGwgc2VlIGlzIGEgI1VELg0KPiANCj4gI1VEIGlz
IGhhbmRsZWQgYnkgdGhlIFNFQU1DQUxMIGFzc2VtYmx5IGNvZGUuICBQbGVhc2Ugc2VlIFREWF9N
T0RVTEVfQ0FMTA0KPiBhc3NlbWJseSBtYWNybzoNCj4gDQo+IC5Mc2VhbWNhbGxfdHJhcFxAOg0K
PiDCoMKgwqDCoMKgwqDCoMKgLyoNCj4gwqDCoMKgwqDCoMKgwqDCoMKgKiBTRUFNQ0FMTCBjYXVz
ZWQgI0dQIG9yICNVRC4gIEJ5IHJlYWNoaW5nIGhlcmUgUkFYIGNvbnRhaW5zDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoCogdGhlIHRyYXAgbnVtYmVyLiAgQ29udmVydCB0aGUgdHJhcCBudW1iZXIgdG8g
dGhlIFREWCBlcnJvcg0KPiDCoMKgwqDCoMKgwqDCoMKgwqAqIGNvZGUgYnkgc2V0dGluZyBURFhf
U1dfRVJST1IgdG8gdGhlIGhpZ2ggMzItYml0cyBvZiBSQVguDQo+IMKgwqDCoMKgwqDCoMKgwqDC
oCoNCj4gwqDCoMKgwqDCoMKgwqDCoMKgKiBOb3RlIGNhbm5vdCBPUiBURFhfU1dfRVJST1IgZGly
ZWN0bHkgdG8gUkFYIGFzIE9SIGluc3RydWN0aW9uDQo+IMKgwqDCoMKgwqDCoMKgwqDCoCogb25s
eSBhY2NlcHRzIDMyLWJpdCBpbW1lZGlhdGUgYXQgbW9zdC4NCj4gwqDCoMKgwqDCoMKgwqDCoMKg
Ki8NCj4gwqDCoMKgwqDCoMKgwqDCoG1vdnEgJFREWF9TV19FUlJPUiwgJXJkaQ0KPiDCoMKgwqDC
oMKgwqDCoMKgb3JxICAlcmRpLCAlcmF4DQo+IA0KPiAJLi4uDQo+IMKgwqDCoMKgwqDCoMKgDQo+
IAlfQVNNX0VYVEFCTEVfRkFVTFQoLkxzZWFtY2FsbFxALCAuTHNlYW1jYWxsX3RyYXBcQCkNCj4g
LmVuZGlmICAvKiBcaG9zdCAqLw0KPiANCj4gPiANCj4gPiA+ID4gPiBCdHcsIEkgbm90aWNlZCB0
aGVyZSdzIGFub3RoZXIgcHJvYmxlbSwgdGhhdCBpcyBjdXJyZW50bHkgdGR4X2NwdV9lbmFibGUo
KQ0KPiA+ID4gPiA+IGFjdHVhbGx5IHJlcXVpcmVzIElSUSBiZWluZyBkaXNhYmxlZC4gIEFnYWlu
IGl0IHdhcyBpbXBsZW1lbnRlZCBiYXNlZCBvbg0KPiA+ID4gPiA+IGl0IHdvdWxkIGJlIGludm9r
ZWQgdmlhIGJvdGggb25fZWFjaF9jcHUoKSBhbmQga3ZtX29ubGluZV9jcHUoKS4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBJdCBhbHNvIGFsc28gaW1wbGVtZW50ZWQgd2l0aCBjb25zaWRlcmF0aW9u
IHRoYXQgaXQgY291bGQgYmUgY2FsbGVkIGJ5DQo+ID4gPiA+ID4gbXVsdGlwbGUgaW4ta2VybmVs
IFREWCB1c2VycyBpbiBwYXJhbGxlbCB2aWEgYm90aCBTTVAgY2FsbCBhbmQgaW4gbm9ybWFsDQo+
ID4gPiA+ID4gY29udGV4dCwgc28gaXQgd2FzIGltcGxlbWVudGVkIHRvIHNpbXBseSByZXF1ZXN0
IHRoZSBjYWxsZXIgdG8gbWFrZSBzdXJlDQo+ID4gPiA+ID4gaXQgaXMgY2FsbGVkIHdpdGggSVJR
IGRpc2FibGVkIHNvIGl0IGNhbiBiZSBJUlEgc2FmZSAgKGl0IHVzZXMgYSBwZXJjcHUNCj4gPiA+
ID4gPiB2YXJpYWJsZSB0byB0cmFjayB3aGV0aGVyIFRESC5TWVMuTFAuSU5JVCBoYXMgYmVlbiBk
b25lIGZvciBsb2NhbCBjcHUNCj4gPiA+ID4gPiBzaW1pbGFyIHRvIHRoZSBoYXJkd2FyZV9lbmFi
bGVkIHBlcmNwdSB2YXJpYWJsZSkuDQo+ID4gPiA+IA0KPiA+ID4gPiBJcyB0aGlzIGlzIGFuIGFj
dHVhbCBwcm9ibGVtLCBvciBpcyBpdCBqdXN0IHNvbWV0aGluZyB0aGF0IHdvdWxkIG5lZWQgdG8g
YmUNCj4gPiA+ID4gdXBkYXRlZCBpbiB0aGUgVERYIGNvZGUgdG8gaGFuZGxlIHRoZSBjaGFuZ2Ug
aW4gZGlyZWN0aW9uPw0KPiA+ID4gDQo+ID4gPiBGb3Igbm93IHRoaXMgaXNuJ3QsIGJlY2F1c2Ug
S1ZNIGlzIHRoZSBzb2xvIHVzZXIsIGFuZCBpbiBLVk0NCj4gPiA+IGhhcmR3YXJlX2VuYWJsZV9h
bGwoKSBhbmQga3ZtX29ubGluZV9jcHUoKSB1c2VzIGt2bV9sb2NrIG11dGV4IHRvIG1ha2UNCj4g
PiA+IGhhcmR3YXJlX2VuYWJsZV9ub2xvY2soKSBJUEkgc2FmZS4NCj4gPiA+IA0KPiA+ID4gSSBh
bSBub3Qgc3VyZSBob3cgVERYL1NFQU1DQUxMIHdpbGwgYmUgdXNlZCBpbiBURFggQ29ubmVjdC4N
Cj4gPiA+IA0KPiA+ID4gSG93ZXZlciBJIG5lZWRlZCB0byBjb25zaWRlciBLVk0gYXMgYSB1c2Vy
LCBzbyBJIGRlY2lkZWQgdG8ganVzdCBtYWtlIGl0DQo+ID4gPiBtdXN0IGJlIGNhbGxlZCB3aXRo
IElSUSBkaXNhYmxlZCBzbyBJIGNvdWxkIGtub3cgaXQgaXMgSVJRIHNhZmUuDQo+ID4gPiANCj4g
PiA+IEJhY2sgdG8gdGhlIGN1cnJlbnQgdGR4X2VuYWJsZSgpIGFuZCB0ZHhfY3B1X2VuYWJsZSgp
LCBteSBwZXJzb25hbA0KPiA+ID4gcHJlZmVyZW5jZSBpcywgb2YgY291cnNlLCB0byBrZWVwIHRo
ZSBleGlzdGluZyB3YXksIHRoYXQgaXM6DQo+ID4gPiANCj4gPiA+IER1cmluZyBtb2R1bGUgbG9h
ZDoNCj4gPiA+IA0KPiA+ID4gCWNwdXNfcmVhZF9sb2NrKCk7DQo+ID4gPiAJdGR4X2VuYWJsZSgp
Ow0KPiA+ID4gCWNwdXNfcmVhZF91bmxvY2soKTsNCj4gPiA+IA0KPiA+ID4gYW5kIGluIGt2bV9v
bmxpbmVfY3B1KCk6DQo+ID4gPiANCj4gPiA+IAlsb2NhbF9pcnFfc2F2ZSgpOw0KPiA+ID4gCXRk
eF9jcHVfZW5hYmxlKCk7DQo+ID4gPiAJbG9jYWxfaXJxX3Jlc3RvcmUoKTsNCj4gPiA+IA0KPiA+
ID4gQnV0IGdpdmVuIEtWTSBpcyB0aGUgc29sbyB1c2VyIG5vdywgSSBhbSBhbHNvIGZpbmUgdG8g
Y2hhbmdlIGlmIHlvdQ0KPiA+ID4gYmVsaWV2ZSB0aGlzIGlzIG5vdCBhY2NlcHRhYmxlLg0KPiA+
IA0KPiA+IExvb2tpbmcgbW9yZSBjbG9zZWx5IGF0IHRoZSBjb2RlLCB0ZHhfZW5hYmxlKCkgbmVl
ZHMgdG8gYmUgY2FsbGVkIHVuZGVyDQo+ID4gY3B1X2hvdHBsdWdfbG9jayB0byBwcmV2ZW50ICp1
bnBsdWcqLCBpLmUuIHRvIHByZXZlbnQgdGhlIGxhc3QgQ1BVIG9uIGEgcGFja2FnZQ0KPiA+IGZy
b20gYmVpbmcgb2ZmbGluZWQuICBJLmUuIHRoYXQgcGFydCdzIG5vdCBvcHRpb24uDQo+IA0KPiBZ
ZWFoLiAgV2UgY2FuIHNheSB0aGF0LiAgSSBhbG1vc3QgZm9yZ290IHRoaXMgOi0pDQo+IA0KPiA+
IA0KPiA+IEFuZCB0aGUgcm9vdCBvZiB0aGUgcHJvYmxlbS9jb25mdXNpb24gaXMgdGhhdCB0aGUg
QVBJcyBwcm92aWRlZCBieSB0aGUgY29yZSBrZXJuZWwNCj4gPiBhcmUgd2VpcmQsIHdoaWNoIGlz
IHJlYWxseSBqdXN0IGEgcG9saXRlIHdheSBvZiBzYXlpbmcgdGhleSBhcmUgYXdmdWwgOi0pDQo+
IA0KPiBXZWxsLCBhcG9sb2dpemUgZm9yIGl0IDotKQ0KPiANCj4gPiANCj4gPiBUaGVyZSBpcyBu
byByZWFzb24gdG8gcmVseSBvbiB0aGUgY2FsbGVyIHRvIHRha2UgY3B1X2hvdHBsdWdfbG9jaywg
YW5kIGRlZmluaXRlbHkNCj4gPiBubyByZWFzb24gdG8gcmVseSBvbiB0aGUgY2FsbGVyIHRvIGlu
dm9rZSB0ZHhfY3B1X2VuYWJsZSgpIHNlcGFyYXRlbHkgZnJvbSBpbnZva2luZw0KPiA+IHRkeF9l
bmFibGUoKS4gIEkgc3VzcGVjdCB0aGV5IGdvdCB0aGF0IHdheSBiZWNhdXNlIG9mIEtWTSdzIHVu
bmVjZXNzYXJpbHkgY29tcGxleA0KPiA+IGNvZGUsIGUuZy4gaWYgS1ZNIGlzIGFscmVhZHkgZG9p
bmcgb25fZWFjaF9jcHUoKSB0byBkbyBWTVhPTiwgdGhlbiBpdCdzIGVhc3kgZW5vdWdoDQo+ID4g
dG8gYWxzbyBkbyBUREhfU1lTX0xQX0lOSVQsIHNvIHdoeSBkbyB0d28gSVBJcz8NCj4gDQo+IFRo
ZSBtYWluIHJlYXNvbiBpcyB3ZSByZWxheGVkIHRoZSBUREguU1lTLkxQLklOSVQgdG8gYmUgY2Fs
bGVkIF9hZnRlcl8gVERYDQo+IG1vZHVsZSBpbml0aWFsaXphdGlvbi4gwqANCj4gDQo+IFByZXZp
b3VzbHksIHRoZSBUREguU1lTLkxQLklOSVQgbXVzdCBiZSBkb25lIG9uICpBTEwqIENQVXMgdGhh
dCB0aGUNCj4gcGxhdGZvcm0gaGFzIChpLmUuLCBjcHVfcHJlc2VudF9tYXNrKSByaWdodCBhZnRl
ciBUREguU1lTLklOSVQgYW5kIGJlZm9yZQ0KPiBhbnkgb3RoZXIgU0VBTUNBTExzLiAgVGhpcyBk
aWRuJ3QgcXVpdGUgd29yayB3aXRoIChrZXJuZWwgc29mdHdhcmUpIENQVQ0KPiBob3RwbHVnLCBh
bmQgaXQgaGFkIHByb2JsZW0gZGVhbGluZyB3aXRoIHRoaW5ncyBsaWtlIFNNVCBkaXNhYmxlDQo+
IG1pdGlnYXRpb246DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzUyOWEyMmQw
NWUyMWI5MjE4ZGMzZjI5YzE3YWM1YTE3NjMzNGNhYzEuY2FtZWxAaW50ZWwuY29tL1QvI21mNDJm
YTJkNjhkNmI5OGVkY2MyYWFlMTFkYmEzYzI0ODdjYWYzYjhmDQo+IA0KPiBTbyB0aGUgeDg2IG1h
aW50YWluZXJzIHJlcXVlc3RlZCB0byBjaGFuZ2UgdGhpcy4gIFRoZSBvcmlnaW5hbCBwcm9wb3Nh
bA0KPiB3YXMgdG8gZWxpbWluYXRlIHRoZSBlbnRpcmUgVERILlNZUy5JTklUIGFuZCBUREguU1lT
LkxQLklOSVQ6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzUyOWEyMmQwNWUy
MWI5MjE4ZGMzZjI5YzE3YWM1YTE3NjMzNGNhYzEuY2FtZWxAaW50ZWwuY29tL1QvI203OGMwYzQ4
MDc4ZjIzMWU5MmVhMWI4N2E2OWJhYzM4NTY0ZDQ2NDY5DQo+IA0KPiBCdXQgc29tZWhvdyBpdCB3
YXNuJ3QgZmVhc2libGUsIGFuZCB0aGUgcmVzdWx0IHdhcyB3ZSByZWxheGVkIHRvIGFsbG93DQo+
IFRESC5TWVMuTFAuSU5JVCB0byBiZSBjYWxsZWQgYWZ0ZXIgbW9kdWxlIGluaXRpYWxpemF0aW9u
Lg0KPiANCj4gU28gd2UgbmVlZCBhIHNlcGFyYXRlIHRkeF9jcHVfZW5hYmxlKCkgZm9yIHRoYXQu
DQoNCkJ0dywgdGhlIGlkZWFsIChvciBwcm9iYWJseSB0aGUgZmluYWwpIHBsYW4gaXMgdG8gaGFu
ZGxlIHRkeF9jcHVfZW5hYmxlKCkNCmluIFREWCdzIG93biBDUFUgaG90cGx1ZyBjYWxsYmFjayBp
biB0aGUgY29yZS1rZXJuZWwgYW5kIGhpZGUgaXQgZnJvbSBhbGwNCm90aGVyIGluLWtlcm5lbCBU
RFggdXNlcnMuIMKgDQoNClNwZWNpZmljYWxseToNCg0KMSkgdGhhdCBjYWxsYmFjaywgZS5nLiwg
dGR4X29ubGluZV9jcHUoKSB3aWxsIGJlIHBsYWNlZCBfYmVmb3JlXyBhbnkgaW4tDQprZXJuZWwg
VERYIHVzZXJzIGxpa2UgS1ZNJ3MgY2FsbGJhY2suDQoyKSBJbiB0ZHhfb25saW5lX2NwdSgpLCB3
ZSBkbyBWTVhPTiArIHRkeF9jcHVfZW5hYmxlKCkgKyBWTVhPRkYsIGFuZA0KcmV0dXJuIGVycm9y
IGluIGNhc2Ugb2YgYW55IGVycm9yIHRvIHByZXZlbnQgdGhhdCBjcHUgZnJvbSBnb2luZyBvbmxp
bmUuDQoNClRoYXQgbWFrZXMgc3VyZSB0aGF0LCBpZiBURFggaXMgc3VwcG9ydGVkIGJ5IHRoZSBw
bGF0Zm9ybSwgd2UgYmFzaWNhbGx5DQpndWFyYW50ZWVzIGFsbCBvbmxpbmUgQ1BVcyBhcmUgcmVh
ZHkgdG8gaXNzdWUgU0VBTUNBTEwgKG9mIGNvdXJzZSwgdGhlIGluLQ0Ka2VybmVsIFREWCB1c2Vy
IHN0aWxsIG5lZWRzIHRvIGRvIFZNWE9OIGZvciBpdCwgYnV0IHRoYXQncyBURFggdXNlcidzDQpy
ZXNwb25zaWJpbGl0eSkuDQoNCkJ1dCB0aGF0IG9idmlvdXNseSBuZWVkcyB0byBtb3ZlIFZNWE9O
IHRvIHRoZSBjb3JlLWtlcm5lbC4NCg0KQ3VycmVudGx5LCBleHBvcnQgdGR4X2NwdV9lbmFibGUo
KSBhcyBhIHNlcGFyYXRlIEFQSSBhbmQgcmVxdWlyZSBLVk0gdG8NCmNhbGwgaXQgZXhwbGljaXRs
eSBpcyBhIHRlbXBvcmFyeSBzb2x1dGlvbi4NCg0KVGhhdCBiZWluZyBzYWlkLCB3ZSBjb3VsZCBk
byB0ZHhfY3B1X2VuYWJsZSgpIGluc2lkZSB0ZHhfZW5hYmxlKCksIGJ1dCBJDQpkb24ndCBzZWUg
aXQncyBhIGJldHRlciBpZGVhLg0K

