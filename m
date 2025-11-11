Return-Path: <kvm+bounces-62736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F0AC4C98C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C570D189A92C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D762EDD5F;
	Tue, 11 Nov 2025 09:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LXJYyD4H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B6242D6A;
	Tue, 11 Nov 2025 09:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762852527; cv=fail; b=DSQOJutB+9XJJzlmGNaJNd6VSNsMFY/ifgAPxaMzBgHuAOKHyJZOrxNdFth5u0x7COzQGJpgA3vcelQZg12pLFUOHJ4rHJXWgRvwYHPXLrrD3Jeh1wGjvDKShDd6cmy6gYvPcM/g5SuQHIR6QB1g9j+VzUX3CNPbis6KNilI/Fk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762852527; c=relaxed/simple;
	bh=WFW1F72y0gzVulZOaEebBrp2OqLoEPbzcfjCl6voe8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i2lCsVteVWj48gAngweVSFIagWXx3eY9/lxfKoLD1+YH4r9pA16BUATc5S3USRhvT4o8dAV2+RfzMh718yqHGbSkkr5s505enHz5mYGfpdZSIfCcVedRU62n7aORz91Pe2M/qhrr8Rgm5/vKxPycQ9r9aXUrkmAGfjUPlPW2Psw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LXJYyD4H; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762852525; x=1794388525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WFW1F72y0gzVulZOaEebBrp2OqLoEPbzcfjCl6voe8c=;
  b=LXJYyD4HYeIQlSw7u7qbe/8VBhTgroTQRq9FQCe4vFIMWzsBR+At7AX2
   0XstwV7oSiSCfDyR97CjzfO85B7GyLNGwD0tswAbqjMorCpAvpNb/eRDH
   lQu05VhBO9qNJ0CsrX94TmnifhsGT4zR4tVQ8ckn5Y4i0Jk8RVb+p8QsH
   IOUjGTRlEYJKNSkaC9MPQtOcjOOO/d3JnYuLFlViLRXF4zY/BCRoWXCZR
   ehCuWe4fXA/VDTiU5BdfgraYXonC7K3kk8n5l1D7op1PEpDZpxZtpWuQ4
   COSsR8AIOqFUSuyS2tFfWaoiLODsMUfac0aUSGpSMH7/NyIhYySMjF6x2
   g==;
X-CSE-ConnectionGUID: DmFaVs89RJC+vycLChei0Q==
X-CSE-MsgGUID: SFkCdWqhSeSKFvp+C6ONiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="65001861"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="65001861"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:15:25 -0800
X-CSE-ConnectionGUID: 6j74r7xsRU2VBN5zeTp3kg==
X-CSE-MsgGUID: GZXJ3o8cS3yMGUkHNWrDYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="188873987"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 01:15:25 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:15:24 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 01:15:24 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 01:15:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icAx+XzjDx4q8gkTTOR3Cwf/Kl1NXQXRXnzv0hV8b40/BZ6T8miia59YkvrX76OW7WrQ7andQw+ed41k1iB4Cbk+xEBxMUahuFaG/Cd1H3Id9JygR8N5D0pMENZiI3XqH08yPIP06XvOZj+IPXrsd/Gk2ZiQ3M6OhhXsokVclnIVLykwCjvcTQg2xlDVgxhoFRO0k+WYqEA2GS5y/lX//w/4cp1aiZfuklsDMwizuzGjodhkTZyV4mZn60WH92MH4ItjdTU/1AADiM9KVJ30iKQhihn+d3Tm9BynpEZB3FisHolZBOVjG4vkNRbd+8Sp2C+wixLM6/AHsUPffQxtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFW1F72y0gzVulZOaEebBrp2OqLoEPbzcfjCl6voe8c=;
 b=uo1pHHpC8B1GzUPTPRCFtbSUJB1ZHExkusikMWJObJ8TcFYFVfba/s465g1amahIa7scc4WrDoDoILuOJGiL0JnFQq6Un+s6iecq6QStIDTc7dMavHCstmrujHu3GwUAgpR3KoA4nmVFErnMysgNY3yQRtqNq7UjPjpVQ4+V4NQsTOr/P3+0mj0TclzNi8vXO9y8cxuPLcRdfrTdAsQ+boZ4lBwAOzYKfXdWQOkoBfs4LROID6CaRgFpBfQpnZg/xLHKx4Bl6GXMGv99gHmrozcx2VTBQjdaCp1IbweGqpx9eUcz/dMzUROJMiUA9RIsdZ5mop8qNp0Cob3+D4TVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 09:15:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 09:15:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcB3+gmKuDSfTS10GpgpsbOhjPgbR+LVYAgAADmoCAb5d1AA==
Date: Tue, 11 Nov 2025 09:15:22 +0000
Message-ID: <fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094149.4467-1-yan.y.zhao@intel.com>
	 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
	 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
In-Reply-To: <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4720:EE_
x-ms-office365-filtering-correlation-id: 764adb0a-5cf9-42a5-b4dd-08de2102d78c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZHdyaXIwQ2x5SVEwTUpGN0kxWlVRa0szOFhrZFZVRFQvOEpUQWdnZnJQQ1Zx?=
 =?utf-8?B?Qzl5cVd3NXB2NnhiWnYzMFNnRDBXMnBKV1ZYR3hKYTlabDBlZHFvRkRuRFlU?=
 =?utf-8?B?VzU3cllmWFpqc1lBVVY0NG8wYWlJNHNxRmNXTFVuWTNqVm1iQzJPbmFlY1Ro?=
 =?utf-8?B?YkZyZzdmTHNEa0hBUnErYkErRFZmY0xHZnVxYTdWakhNYjJXQnA3R0g5ZmJw?=
 =?utf-8?B?NC9VUGVwMktVOHdHeFZhRGdzcWxnVmNRR3VSeTAxdWJIbXZuUmVIMktJOEcz?=
 =?utf-8?B?ZFpJWDVpRjNjTHQ5K1NzTXh5RWpBc3E0SGtVaDFENnZGL2xIbjc0b1k2UDVq?=
 =?utf-8?B?ODRwUk1LN2JSQmx4bnBxSGIrYlZ5VlFTQmZCU0R4KzNOUWVkcjF4TUtXcHpn?=
 =?utf-8?B?VVZSZDFCRm9ZdHdjTXRvNkY2eHgxWGwvVFE3UG1LQXlrZDltRlIzT0xPbXZN?=
 =?utf-8?B?U0Ywd0xFa3o5cXB0S2dJdzNOVHQyU29SRE5mc29zaTA3V0NlR2s5Kzh2amM4?=
 =?utf-8?B?N05PMFZjREcxU2lnMjF3WXNDbDZVOFYyazVHM2puKy9xbnZqaHFOWGw1MkFL?=
 =?utf-8?B?NG43M0FFSlA1REFYZ3FHdDdIQVRKd2pqNUF3Umx6a2ZXaGsvcXdqVTBUMldm?=
 =?utf-8?B?dW0zMFpMQW1PdHByazFYWFE3eGdaMzNYdUk3RnMvNXdvYml3b0g2Q3U3dlNk?=
 =?utf-8?B?c3hYeEJGRkhHZXVRQktxeVNOUk5aNUVWMjRYMXhUcit3SHF3Qi93Q0tyOGRw?=
 =?utf-8?B?V0hYN1Y1eUdPQVF3M3BBa1AvM1J1em5KdndBSmdOWjZnNUtrcUFaS1Q4MzZy?=
 =?utf-8?B?am50T1Naa3JmWFJhUmhLelJnMEl3cHdYVTRWdlJLSjJrUDhHQ3JKVjVrRjNs?=
 =?utf-8?B?b0IvaThqVDROTklzUExyYWRNdVA1YWRKaUIySmU1MVNMN2lGNW5hL1VTWVJn?=
 =?utf-8?B?K3JObDhIYkp0SmZpZGFSK0VaemN0cVN6MmFnZUdia2VwQTM1VzRxcmJKdjJY?=
 =?utf-8?B?M2drZnZFQjBQbFVxWFViY3dDQUdWUmRRdWFXdy9HMWtHYjNIMHdMVG1SbEh4?=
 =?utf-8?B?OUdmU3ZTaFF4WmdIMVV5aFpiUDhBRVIyL25uems2aG5VMFdWQ2lyRkZucjRD?=
 =?utf-8?B?ejg4Y3hMQ1JML1NEYzg3NlFEWjRDTGdVazkyNzJrSlRqT29hZXYya0lVM1ZB?=
 =?utf-8?B?MDRBclBBdWlMNVoxUlRMRjNJYUM3anZTSVB3Zy9ET0NZdDlDc1hzeEVDV2Qv?=
 =?utf-8?B?ek9LZUhPRjNqc0JDUVVJUENXdmkzWENuMkV4M2dzMWRnM29ReWxBSWphNGl5?=
 =?utf-8?B?Vm5zTWdVQ2NjNTZPbnJVdWQrOTVtVmZFOFVnc2I4NTUzSzJSTEsrZXpJTVVJ?=
 =?utf-8?B?eGN0ZzJ3aXV0RlZQTnJDNVZpN0xLOTMzWkFuWDJvUmdkRDhJNVlOWERxUjQ3?=
 =?utf-8?B?bTFpZkhJK1FlWkUvUFZ3WU42Ujl6OTR1VUpZdzNsSnZCNDdXOUdRdnlTRGxz?=
 =?utf-8?B?NnlHa01yN0tkaldod1ZEdU1GVENMLzVqa2RuMW93djJqbXNqL0FrU2Y1MEM1?=
 =?utf-8?B?eDhoeXZ0RS9PYVNRV0pQd3FiRWlXL3A4QnlVb1B3SWJKSForT1NnWlJmSzJG?=
 =?utf-8?B?OHlwZzdWNGtuWU1UR3VDSUsrWHVvMWRsa3IwMmhzbFFiUEJzQXFrZkx4Z0NN?=
 =?utf-8?B?bC9zS1BjZmQ5bEFLNFFsZ2VOT29Dd25lSkk3Q0JQTGsxWk1UcC81MlFTVmtE?=
 =?utf-8?B?ejJzb2lPUWZaVTQ5MDczUG1jeDBleXI4bXlIVjJBUEl3UEFPUEhGUVhMblZo?=
 =?utf-8?B?WFBmd3JyaXdSVXJ2QWxHNXd0dHowUWdhRDNBd2NIdm9UakNzVGU5YnpSQU1L?=
 =?utf-8?B?ejkxRDhqQUNFL015RGRwbm1ydGdaU3RaY3JKanBCOGQ5THFKWE5UUTFBdlNG?=
 =?utf-8?B?OEJEbWNmcjc1d2hhZE9pUk5SNEY4ZGpMblAyeGl1aWZybnMwM2hNTE4xTVh6?=
 =?utf-8?B?NWk4Z0V6Q2Rja3lRQ1l6NGFVdk1DSVlkNTZicFd6SVYxUGF3YVV3bVZyOG9u?=
 =?utf-8?Q?Befz/6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVR5bTF3N2doK0hsejJCZ0hGNW5SSGk5T2J5V1hFajViSUNvYVJpWDdKcDBr?=
 =?utf-8?B?cDNhQWRWWTUydGhoNmM3QlNNNzJQZHBwa0VKajZIUzY5cTVIRnhQYnBjMUxV?=
 =?utf-8?B?bFNGa1lkZVVuY3VyM1pTMm5XOWdVSWFSRkp6OVErbkc5bGlzREl6c0dsaTVK?=
 =?utf-8?B?UVUzRFlKSGFMZG1RYWFlY0I2V0VjdVdLSWY5d25vRDFTanMzUlNwZ0lvU1hq?=
 =?utf-8?B?akNjSkJHRFhOV3NMai9wR3pDZ0kwdzlPU01xemNWZ1Z0UkFtN2xGdDZJajd4?=
 =?utf-8?B?d09FMkhXMjI0eUZaQzZSV3ZPT1orSlZIWUJiQlB6QjJTMVVtN3R4YURYbUMr?=
 =?utf-8?B?a21LSlJWcnd2SUJlbzNMSVAvekRTVWlwZHErcDVzNVZHYzB3aWltZHpIb2ZZ?=
 =?utf-8?B?YmdDMFd0WjRtZ25ZSzJ5NU4xN1RDck96L2xoS3p3YUp5L0c5TnRNdXBkYlRV?=
 =?utf-8?B?dUE4Z1dTU05nZzErRGF2ZFVPeWVkeTRkQUUwWk04dExPRUJyMHNrdWE3Ym1K?=
 =?utf-8?B?UHBveVBuTGpNTVdKWEErTkduQitIWlZLRkZKKzZmVXV1SVFLcDBjYTRUeVV5?=
 =?utf-8?B?WHJETXA4MnRrNGJUMEQ2aDdBOEVrTFJLYzc0SUsrSXRQSUNCK2Q3NlUvTmgx?=
 =?utf-8?B?djVFeFdCZ1M3cWY5cWpUeGZKSy9TWWNwQjY5OHgzQlhLb0ZkK254Qkw4U1o3?=
 =?utf-8?B?b1FudThJRnhmQUlGdjRZcHpESWhkeFk3b0paVGdRMmNGeGlHSlpFYkY0NG01?=
 =?utf-8?B?bXZRaHUyU3FIb0dnSjZZSjVIc3BrL3pTVG5mZUE1VXFxYWpCTWY0N0wrM2tB?=
 =?utf-8?B?YWlVRmNTcEpETitBQk9ya21ud2FwOTU3V1YvWDdhK2RkczhYbjZJMjFTS3F4?=
 =?utf-8?B?TUE4RzdPT3dYZ1BaRVdOY2dmRlY3VlhtTm9OdlY3NmVsVkhLblBsZU1FS3FP?=
 =?utf-8?B?RlkwYitTUHdIYmVxNW9nN0lDeitOWjB5Y2dHcUpuR0dKWXNLcm1vUTRhNUUy?=
 =?utf-8?B?bm54cDg2QU41MjJCaDJ0Z1JsNTV3Z2VPVzU5N053cTZnenZNLzV1SGk5Wndr?=
 =?utf-8?B?Zlpra0NpMFYrL0QyaEY5SURTTDhrTlR5d29aa3o3cjl4bnBid1A3Q3ZoOE1J?=
 =?utf-8?B?OVVkdUlSYmpiUE9CWGs0bFd1N0xwUFZJK21lVU9wS0grbGNSOW5pUUk2RndC?=
 =?utf-8?B?YU9abWZ5L0N2UHNwcU5HbWFiMmhHTWZ5MXExM2FJMTRTWVlHYkhLd25WTzYy?=
 =?utf-8?B?Zkthc0JtaWEvaXBlZGp4QWlCYUFWM0w3RU0yQUxLQjNycGYzQlFJb3ExV0lO?=
 =?utf-8?B?SVlsNXowR1ZLSllKT1hXRWR2VzFFdFVGcTR4azBjYWxYTFFzU09BbnU0aHpG?=
 =?utf-8?B?QTN1QjhjaWRzZzB6OUFZOStqblAvbGFsWFZYWmlSUG40NGZ1QU4waFEzRmxG?=
 =?utf-8?B?c2RaQk05M1lqVXJEYU82OXJYY3F0dThFNlQ0WGV6UVh0ZmQvR1JpNFcxSTdW?=
 =?utf-8?B?TEw3Z1FXeEFUSmhYcnJGc3M5ZHZLbmw2SXMxTW0rakxQdUttTnRSWmNsVEdI?=
 =?utf-8?B?OFhqT3o1Y20xaUVTN05VTEIrL2dOR3NyUzlMZWI3QWYzQm9Ld2Y2cXR3eW83?=
 =?utf-8?B?bTNqWFo4QTRuaCtMeEQ3S3pvVFRnUG03NFU3d0J5cUc1UFE1QW1RVGdHWGps?=
 =?utf-8?B?VGpZNzhsRzZmR3V1b1hCRlNIZ0pPcVB6aUtwTzh2ZTExWUZPOW5FWHdIR2xh?=
 =?utf-8?B?RnZFWG9uUmRQZTFTU1VBUkM3S2dLOHk1blFEMWEwQWNIeTBzOFd0L3h2UlNz?=
 =?utf-8?B?aTBMTDBscnpUSTBQQ3dQcUc5a1N4MUZjTjBuSGhwM1AyV25WYW5wQXdYcDVS?=
 =?utf-8?B?elFNZ05aWHJJRTMxdDJWbDF4YXgrTjdSbWpWZFpzODJ5c1dSQlAweUhtK2lF?=
 =?utf-8?B?Lzh6Qmw2ZWRUMDJMcW8xbC9FbytlY1hQQkZjanVja2V0ajNnbmUrSEp4a0Fk?=
 =?utf-8?B?MlBweHV3UkkzK3NRNWNQRlJOUERIVys0dEhqaFFhUWUxNXZWeGhDV2Q4VUdF?=
 =?utf-8?B?MTRhN0dOUHFZb2JSamEwUFloOXREZGVJRVVZRk11bWZzdU4ycnpDcGxHbnpL?=
 =?utf-8?Q?6UXOsL7LjfPwS3qcBvC874VFn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D3D3196FC38EC4396C8324E9629FF10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 764adb0a-5cf9-42a5-b4dd-08de2102d78c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 09:15:22.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CdqJN320Y82IFnl9jT3ZSa55/VSftlVAUZCtsMPDW/WDRUOR70Ktk/wfDAZ3ZHplMJN8RVAMfhyq0/svYQpa3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTAxIGF0IDE3OjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+
IERvIG5vdCBoYW5kbGUgVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFIGJlY2F1c2UgU0VBTUNB
TEwNCj4gPiA+IFRESF9NRU1fUEFHRV9ERU1PVEUgZG9lcyBub3QgY2hlY2sgaW50ZXJydXB0cyAo
aW5jbHVkaW5nIE5NSXMpIGZvciBiYXNpYw0KPiA+ID4gVERYICh3aXRoIG9yIHdpdGhvdXQgRHlu
YW1pYyBQQU1UKS4NCj4gPiANCj4gPiBUaGUgY292ZXIgbGV0dGVyIG1lbnRpb25zIHRoYXQgdGhl
cmUgaXMgYSBuZXcgVERYIG1vZHVsZSBpbiBwbGFubmluZywgd2hpY2gNCj4gPiBkaXNhYmxlcyB0
aGUgaW50ZXJydXB0IGNoZWNraW5nLiBJIGd1ZXNzIFREWCBtb2R1bGUgd291bGQgbmVlZCB0byBo
YXZlIGENCj4gPiBpbnRlcmZhY2UgdG8gcmVwb3J0IHRoZSBjaGFuZ2UsIEtWTSB0aGVuIGRlY2lk
ZXMgdG8gZW5hYmxlIGh1Z2UgcGFnZSBzdXBwb3J0IG9yDQo+ID4gbm90IGZvciBURHM/DQo+IFll
cy4gQnV0IEkgZ3Vlc3MgZGV0ZWN0aW5nIFREWCBtb2R1bGUgdmVyc2lvbiBvciBpZiBpdCBzdXBw
b3J0cyBjZXJ0YWluIGZlYXR1cmUNCj4gaXMgYSBnZW5lcmljIHByb2JsZW0uIGUuZy4sIGNlcnRh
aW4gdmVyc2lvbnMgb2YgVERYIG1vZHVsZSBoYXZlIGJ1Z3MgaW4NCj4gemVyby1zdGVwIG1pdGln
YXRpb24gYW5kIG1heSBibG9jayB2Q1BVIGVudGVyaW5nLg0KPiANCj4gU28sIG1heWJlIGl0IGRl
c2VydmVzIGEgc2VwYXJhdGUgc2VyaWVzPw0KDQpMb29raW5nIGF0IHRoZSBzcGVjIChURFggbW9k
dWxlIEFCSSBzcGVjIDM0ODU1MS0wMDdVUyksIGlzIGl0IGVudW1lcmF0ZWQgdmlhDQpURFhfRkVB
VFVSRVMwLkVOSEFOQ0VEX0RFTU9URV9JTlRFUlJVUFRJQklMSVRZPw0KDQogIDUuNC4yNS4zLjku
DQoNCiAgSW50ZXJydXB0aWJpbGl0eQ0KDQogIElmIHRoZSBURCBpcyBub3QgcGFydGl0aW9uZWQg
KGkuZS4sIGl0IGhhcyBiZWVuIGNvbmZpZ3VyZWQgd2l0aCBubyBMMsKgDQogIFZNcyksIGFuZCB0
aGUgVERYIE1vZHVsZSBlbnVtZXJhdGVzwqANCiAgVERYX0ZFQVRVUkVTMC5FTkhBTkNFRF9ERU1P
VEVfSU5URVJSVVBUSUJJTElUWSBhcyAxLCBUREguTUVNLlBBR0UuREVNT1RFwqANCiAgaXMgbm90
IGludGVycnVwdGlibGUuDQoNClNvIGlmIHRoZSBkZWNpc2lvbiBpcyB0byBub3QgdXNlIDJNIHBh
Z2Ugd2hlbiBUREhfTUVNX1BBR0VfREVNT1RFIGNhbiByZXR1cm4NClREWF9JTlRFUlJVUFRFRF9S
RVNUQVJUQUJMRSwgbWF5YmUgd2UgY2FuIGp1c3QgY2hlY2sgdGhpcyBlbnVtZXJhdGlvbiBpbg0K
ZmF1bHQgaGFuZGxlciBhbmQgYWx3YXlzIG1ha2UgbWFwcGluZyBsZXZlbCBhcyA0Sz8NCg==

