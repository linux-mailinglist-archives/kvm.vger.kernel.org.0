Return-Path: <kvm+bounces-54675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1821FB26B4F
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 17:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CAF61C86A88
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3022923FC54;
	Thu, 14 Aug 2025 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EI0w9lP2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C9323BD1B;
	Thu, 14 Aug 2025 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755185911; cv=fail; b=N4mQEkYMzATj/XuUp3pObnO0AADFhCm0YeQgS+HKohPyrcDX+1hvVngPVkdae9IlzzFjSmIpuombqHVpS87XrhC7Us3KoyJgEp1HD730hGfvYh4JYlHtvJizfBlI/DKjF1VXlcorSLh5n6YBM5bwGOzDyebzAbh5/vMA7e2vXdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755185911; c=relaxed/simple;
	bh=LxJxURwCh/kUCCk8spMLVjA8o7/Bxt5Kizra0AkxTVE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NBY7lw7FVvClAQ8k93mWaT42M+NQEbPy9SsXl6K0TYQMUPY4gl9gtVzgL1CdlDcbe7u8dofxobmQURVj4ubZjOWybtncuqXv4IgTq4M87g0eTMeckxCIprXd9ODasGqaJa8K4DWEu7zWjcFi1uGnZYs9LlRzovbb6pAFL4Pm8NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EI0w9lP2; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755185910; x=1786721910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LxJxURwCh/kUCCk8spMLVjA8o7/Bxt5Kizra0AkxTVE=;
  b=EI0w9lP251+0nqQcuGi2UOBF6q9sb03ETdqnmIhTvJQ1npJk0R8haw46
   lwYak5Bu5cqq6SWCeWZfnqfgHn7xlMVtd/afw36ehJHTbUrBCMYq+1eQW
   8uaCYjMb1dh+K9ivAs0Dw17ncI2psZN2ipYCSjag9DNj/AvfbfzBFfcjh
   IFfhDS7ec8v0j7zwGrLy0j1qJofmXenrkySaRrXu5UIB0yWSZhkrho+qQ
   W0RVoudF8rH3T+2vlalTQwUmweSRiSaHU+/ULeOT+Nz6fkK5FUnxYB1B3
   LzWlu1a4otOfkZRPQNcS3u8f2P/6PW2qhURz2SqRPmAVLmjr6XQYSWMVE
   Q==;
X-CSE-ConnectionGUID: Gzn6LP0jTSeGT2x7scnWyA==
X-CSE-MsgGUID: yeS+6JItQ5KSF3ajZ1SFZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57372030"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57372030"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 08:38:29 -0700
X-CSE-ConnectionGUID: Av4TOzXcSJyb7BlcBzO1+Q==
X-CSE-MsgGUID: C5d1ZgRcRJS0PKD2g7MxuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="167048394"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 08:38:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 08:38:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 08:38:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 08:38:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kfavWy+CzrW38XmSop7DS6qbPNqY7k6azZYvZ21FuS9ZfbE0knRjxVRHZW7J9veT7nSjtsbi9cKMrKFz+x43GVcqgKd5EaKB2xezqrOe/COPDpfnxZxJjkhzadcnuU8KvsjBB9lZXEs29fyAhFqu5cgs+LRWb8IqvJpY1xnWI4w6JuVd2TWOvSMfH2mP8TcaRVy6DYUvuSstqBOB5RB/n1CzIvChkMdigiqfaYg+3lU4G/cR6lwWWWkLmAf6sw2PKQo9JO3Ve/0dH6vexuvjQp42i6gwe1PE2O+EbxMpwqZiLqFlS/h1/gfvoUKauv0drUv4gomDafLIHM7fEuwE+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxJxURwCh/kUCCk8spMLVjA8o7/Bxt5Kizra0AkxTVE=;
 b=RE/AVynpsejpulGzdYLUiWmTiR+WSjFLzqySfw2w4+FRGb7XGJDzT/y6JRymUFB+DJGX1TKMWEyPA7h/48ifMygo8YfZOwFqdQLjKWtzdjHOaolw4omKiTLQzWiBGaVOeHRo4ftx8cK/fMorTDN9Q1+PvtezqbL61MC8Z5iD8mVOTecr430hZslecbqKK48+iZ8zHzoOaTbf5lwj/AIiSzoI3aS5VRoYENz10gIT6tcWpGjVQaAyexrH8GIphvKBrhKDaXqzZhUEGAuSGHezigajQV6WYgirTQejUJVhzVdb+TscAJZTan8dpGCPmAQexfzAX4MrhraHVVq86dfD0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7008.namprd11.prod.outlook.com (2603:10b6:303:227::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 15:38:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 15:38:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDK5tuiUygHq430SBA5pGkLDoTrRiLHkAgAAdHIA=
Date: Thu, 14 Aug 2025 15:38:26 +0000
Message-ID: <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
In-Reply-To: <aJ3qhtzwHIRPrLK7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7008:EE_
x-ms-office365-filtering-correlation-id: e66ab47e-c857-405b-0656-08dddb489c84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z1lEZ1JZb0VHK1p5dm9VUE4vSjJsMHd4NEVoNzhyZDc0alNOaStVazF2c1da?=
 =?utf-8?B?aXJ5RVhOeGhpT0tzYUw3R3l5R3AwOFd2Ykd4ZWxaVkNRYXREYVNmVDJtZDJE?=
 =?utf-8?B?V25BajV5RjZZNlpGbENqakJ2L3ZRTVgxd2Y5MldibTZNcTNIR21kZW1IZlBB?=
 =?utf-8?B?cXJ3R3VpZTQvS2RPUXBSb3cvMHNTSG5YNnZQQWJhaHJwQkxGWkNCbjRVcEpT?=
 =?utf-8?B?WlJQdHE0cmlyQkFzRkNrRE1JUW1ZL0NDR0FSRkF6RVI1Mm1XYjVzYytiaVBB?=
 =?utf-8?B?MVdHTG9xdUpVK0dLWitES2pVRVNaVlg4Y0R1STE0TkRJenhmQ215TVlJUFh6?=
 =?utf-8?B?STI1cFoxdHhlb2UwL0t5MExtaFd4YjcyUytHcDZUWVNreUZtTCt1RUhXSTVv?=
 =?utf-8?B?dExLbkhBNnNOMmNiL25DQnIyL2dqWDRHVUVWRVFpQ2EvNVFYTUdTdUVsV2Ir?=
 =?utf-8?B?MW9BZ3c1Vy95M3hXNlBuelRsSEhway82dG5Cc3ZKMGFHVzNOY0dZd013c0Fo?=
 =?utf-8?B?bjZzY0ZqMkRlRjh5R2pjTHBIeFN0VVNhWW41WVV4V09CVHFjWFB0QlNvZURW?=
 =?utf-8?B?QW9YZjN5Ykg3YktXQkdabTZxbm9LNG1Sb1ZhUHMxN2NKVEdpN0RUZURTdXB2?=
 =?utf-8?B?NGJXM1pjazlmaGIxVmx3dFJlRExBalhsRFdJUWY1UFJqclRtZ0dWTkdqQ1A0?=
 =?utf-8?B?NGhwZEJpU1NHdmV2L1YweFk0VUpJcW5RMXdUa3BJNEFia0x0d3d6SWRhVmxo?=
 =?utf-8?B?OFZYRG41eDErWTFSNlowSVAyYUkrL3lNR3VMZFFlUzQydDBXVXRMQmx3cjFM?=
 =?utf-8?B?c2orc2N4SXB1ZTNvMGJIWTVRRUJuQ0daazBLbTUyQm5VM1o5OUkwYzZhOGtr?=
 =?utf-8?B?ajJjbUIwOFJyQnNpWWpTR3NKamFTNHZUak9lTTdUdVFWOHhGbGM1aDVicVRD?=
 =?utf-8?B?U2ZTZ09TY3hSQS95RUt1Y29rZE1iRG42STFJM2czZ293MHlzZDQwQ2FUVzE4?=
 =?utf-8?B?K3JSYzFhNnNuNXRvNHNGR0VuVnFSdVA5eWFBeTNtV0RFcUk4SkZSZm41c0lV?=
 =?utf-8?B?MHFWbUJ1cFczQXN5aEtZMlcycXFsL0x6Vk5DaUsyc3BYbk92NlYvbTlNSDZT?=
 =?utf-8?B?eVFUcSt5SFBBcmd2QW5FdTN1OXFaSzYwMVdjazMxYURqc1ZJNzd2MEZRZ29x?=
 =?utf-8?B?YW8xTmVOeVRrWUlLSW1tZUVMbktpcGp0VGNKSnVIUzNTeVFySElUUUtyUFRS?=
 =?utf-8?B?U2t2YVVVb0pQeVRhZG5zNTZXT0J2ekR3U2FtQ3d2bXcrWDNKTFprbFhxZVN0?=
 =?utf-8?B?YjdkTDZ3Tjg2MWlyYzVjYWRmcWNEV2ZsTUprRitBdGhPQ0dpL3BFUWNKVUNj?=
 =?utf-8?B?Sy9URDZSOTQzaTRWMEtzemVhTEdPTDZJaEdsOHJDUVQ5M2ptSFpVNlQ1ZTZx?=
 =?utf-8?B?cU12OVZMcWlVTnVpZkVQVzF1WTBsampaQkFTaVMxTWZETkNFUndMSXpDN0FR?=
 =?utf-8?B?QUwzTXFSY1ZqVVRLSlE1L2lFSmJqa3piN241cEZRUU5rTVlsaHQrLzN4NGJF?=
 =?utf-8?B?emVvQlF1Q3dBK2pSdWtocHhXazRqRlVDTGphczl2OVRERVpCT0pmYlJ5NnFL?=
 =?utf-8?B?Y09Hbk5ML2t5QVBWWmhEOWpVb2RsZ3hHTE9YSDcwMEZ2TzRkczFVWHdENTZo?=
 =?utf-8?B?anpsOEVOY2dGQ1RnWFpiNzNxcnFhYTlJbThjTldUQXp2WUJEckRRRC9qdm9U?=
 =?utf-8?B?Slh4M3Y1QjhUaTQxV2gvNUdIQlpES0VWczhScmxGUUVXY1JjYitEaGMxbWJs?=
 =?utf-8?B?N21FTHBGcUN4VHRmMnNsK1EvVEpIRE1rZ0ZMZ0srOHZ3dG40R1hOdis1US9G?=
 =?utf-8?B?TDNhcGg1OUhBQmhWOEpYc0ZBWHgxUE9CNnZWem42bDZNMmU5Q3BPQjdnMUU1?=
 =?utf-8?B?S0VzNkFLa2NBa1ZuV1BUbE51N3M1WmlPTEpDUlpVcSt1L2dHQmpTVDVXelNE?=
 =?utf-8?B?YnZPUDJhb3RRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXJRQ251U3RFVGpvSk52d1N4RDVtME5WZnFZMjRUMy9jMWNaS05GWEp4NFNR?=
 =?utf-8?B?Ly9qMkNKZjh1UkoxeE5hRWRyMVFxbTJCa25xTHNtdkdENVZqN3c0RmVSbU5H?=
 =?utf-8?B?cWkxVjJ0TTU0QWdvY3BRazljdlBDK2kzZTFsREN3ZE9qdU9QZG5oenU2bnVY?=
 =?utf-8?B?TW93emQ2TDB0RmViMytqMnlwT0dZWnViMVF1N2xGc2lYUlNUMUtqcTBGUXdu?=
 =?utf-8?B?d3RMZU5xVHFiT0pXYzZCRm4zdzQrN1N3S29HSmY1dmZaWG80bkFTNitRaFN3?=
 =?utf-8?B?WmJuTXk5K0IvY3FkRk8zRVp5VU9yVS93cWsrbE5YcDVjNlRxQUtJcHlWQ2xv?=
 =?utf-8?B?WTFCUlRYQXFKcERwclFkL0NlbXJybk82TWlWRS9aY1FQdllUK3Qxd3BuaUVs?=
 =?utf-8?B?bGxNRXoyZEZHcUQ5TUNQaHE1b3JQbzRNa25IeHZKZDZETE13YndHV05Ua2tp?=
 =?utf-8?B?QzdQY2h3V3RtMkdsMmNSZUJUZGdmVGRIanpqSnlBTGIrZ2N6Qm5vZzFUNUd3?=
 =?utf-8?B?YTlCbVpZdnNKOThmNFphUGFQcTBReTl3UkpaSXB1dFR0RUNQaDBvUTdFbDJw?=
 =?utf-8?B?NHdid2dHekw2d0VuUUIwVFM2WjJkU21oU1JrRk90TUZqOHVJMTU5M2dQQk9K?=
 =?utf-8?B?a05VTGE0MTE4dVdhanR5cytBdmwzM2lKbkc0Y3BSR2N4VEN6dlFtQWxVL25h?=
 =?utf-8?B?U0p3WFVrSWhYemQvRDJJSjlIa1F1ZlozVGYwdXY1SnUwMUF5TW9pczZQYmY5?=
 =?utf-8?B?Vy9CQk9YLzZZaUhRNjFFSExvVmlvUG41WFZtcVVzNWlaY1lMbHVJaC9xVG91?=
 =?utf-8?B?OW5La0R4UnBESC83TEw4WlNMc2J5U2doYmJ2UnV4L0I5eGxGZ0owdHZwK2R5?=
 =?utf-8?B?ZTExWmR5QVNreEV5b25pOE43NFpVcEZJYWFJK3k2SFdvVmtlcE5vOFJFNW9Q?=
 =?utf-8?B?emFwUytmSVRScy8yOWdMRmNsU3E4aE9jc1labWIzRHFUMFFqRllZb2xTS2pl?=
 =?utf-8?B?ajY1dnE2UTUxQ2k0M2JWZXJvSHZmQ2RRTk5uSDBuVmhoWWRKZU9QTUJya3BY?=
 =?utf-8?B?UEZXQjZ4dklnNXE1NDRDTGFNNnhJclR6Q1lrbEJGTXorVUNqbU13cmhCVUlE?=
 =?utf-8?B?WGU0eFg5T2tqeWhFRS9MSUYyZmJ0azllQXB1M213NnE4bEV0Z0RUcHBPVC9O?=
 =?utf-8?B?QlNWSU1hTklGbnJkUnVuaGtkb1JLZFhuelpBeFRSU1RzMklNelBoS3BZMElU?=
 =?utf-8?B?T3IvdERPanlCWHRFWXplUm9DZjFaUkk4MEVVcUlScEFMdXdGd3FWSWYzWG9a?=
 =?utf-8?B?dStMcGdYemRscWw0TkNNR3RNQ1AwRWxiaXlCSE9KSHlQNGZMSmRvZE16TmlO?=
 =?utf-8?B?QzloY2dpWm5EUk5FVnhlRVhsVFB5KzhsZmxFcWJNR2NCSG5JN0RnZHBsYmhq?=
 =?utf-8?B?WkZkT1dtWmVYVWh3Um55MDFXaU5ZYmFHQUpLcWhjdmIrZXRudjhNTGdLT2kx?=
 =?utf-8?B?OFIzalovbXY5Q0c0WlcrcUZBVE5xQlZVeXdLanQzSGpIR3AzN0F5Q3lVZWFL?=
 =?utf-8?B?aDVPN3pUVzI4YlZZamliTWVrOHBZQ3hQQ0w4akdqaUlEYk5ORVRIRWR0QWgv?=
 =?utf-8?B?eE41YnhXZGJnTWhENWZIb3BLa0V6ODFDMTBVUFpYMUttQnlFVW1IaCtEOWp5?=
 =?utf-8?B?c3VxSktPNEJpaXJSN2E0REQyYUpOQWxPUzVRdUoySlk3dW9kSW5ROWlWaE5E?=
 =?utf-8?B?SG9yQndaZCs1T09YTHVXeHNNR0FFWklzOG94VWVldnhjQVV3YlBza1FPaTJy?=
 =?utf-8?B?ZWMwUCtldXN3QTVkRk42TVdjWllXemNwdEFEZFdBVVpoZkV6ZXdZNjR6dTBH?=
 =?utf-8?B?a3dUcHRUaWhLZGZVS0NaQ2VxNi8zcFlYa0VHM1NwUHpDaWlUTWwrRW5PM3l2?=
 =?utf-8?B?TUlkbTgwcC9MSWwxTENyZE9YRHEzcTh6QTRKeURVeG5MR0RXZW5uc2ZsNEow?=
 =?utf-8?B?Z054MzJpVm15aUJSOFZ0dTFKMzlHczRUcmQ3VisySjRXVE0xZnpTd0NxK2Vu?=
 =?utf-8?B?Y3dqRE41cWhEZHpEZ3hWQ0xIVCt4V2w1aEFZZXBKMStaZUx4UEdJVm9WU2Yv?=
 =?utf-8?B?R1VnS0YrM0E3R05FNy9nb1ZQTVZSQTcyNWJuQmxxaU45bXd0dXRJRkM4Yi91?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAD037E2EFDEEE4F859F319F9F76676F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66ab47e-c857-405b-0656-08dddb489c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 15:38:26.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cU1YbO2BI3EXc9MyqzNVGU4oZX2mgV+sv63ZqHGccem8WQbEfI1sNcmO04IFrEdzyEct6YaKUBTJp7LKqhRkroLN9+mNXFuVDSNSzOSrHls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7008
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDA2OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IMKgIHN0YXRpYyBpbmxpbmUgdm9pZCB0ZHhfaW5pdCh2b2lkKSB7IH0NCj4gPiDC
oCBzdGF0aWMgaW5saW5lIGludCB0ZHhfY3B1X2VuYWJsZSh2b2lkKSB7IHJldHVybiAtRU5PREVW
OyB9DQo+ID4gQEAgLTIyNCw2ICsyMjUsNyBAQCBzdGF0aWMgaW5saW5lIGludCB0ZHhfZW5hYmxl
KHZvaWQpwqAgeyByZXR1cm4gLUVOT0RFVjsgfQ0KPiA+IMKgIHN0YXRpYyBpbmxpbmUgdTMyIHRk
eF9nZXRfbnJfZ3Vlc3Rfa2V5aWRzKHZvaWQpIHsgcmV0dXJuIDA7IH0NCj4gPiDCoCBzdGF0aWMg
aW5saW5lIGNvbnN0IGNoYXIgKnRkeF9kdW1wX21jZV9pbmZvKHN0cnVjdCBtY2UgKm0pIHsgcmV0
dXJuIE5VTEw7DQo+ID4gfQ0KPiA+IMKgIHN0YXRpYyBpbmxpbmUgY29uc3Qgc3RydWN0IHRkeF9z
eXNfaW5mbyAqdGR4X2dldF9zeXNpbmZvKHZvaWQpIHsgcmV0dXJuDQo+ID4gTlVMTDsgfQ0KPiA+
ICtzdGF0aWMgaW5saW5lIHZvaWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2b2lkKSB7IH0NCj4gDQo+
IFN0dWIgaXMgdW5uZWNlc3NhcnkuwqAgdGR4LmMgaXMgYnVpbHQgaWZmIEtWTV9JTlRFTF9URFg9
eSwgYW5kIHRoYXQgZGVwZW5kcyBvbg0KPiBJTlRFTF9URFhfSE9TVC4NCj4gDQo+IEF0IGEgZ2xh
bmNlLCBzb21lIG9mIHRoZSBleGlzdGluZyBzdHVicyBhcmUgdXNlbGVzcyBhcyB3ZWxsLg0KDQpP
aCwgeWVwLiBXZSdsbCBhZGQgaXQgdG8gdGhlIGNsZWFudXAgbGlzdC4NCg0KPiANCj4gPiDCoCAj
ZW5kaWYJLyogQ09ORklHX0lOVEVMX1REWF9IT1NUICovDQo+ID4gwqAgDQo+ID4gwqAgI2VuZGlm
IC8qICFfX0FTU0VNQkxFUl9fICovDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ID4gaW5kZXggNjY3NDRmNTc2OGM4Li4x
YmM2ZjUyZTBjZDcgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+
ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiBAQCAtNDQyLDYgKzQ0MiwxOCBAQCB2
b2lkIHRkeF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSh2b2lkKQ0KPiA+IMKgwqAJCXRkeF9m
bHVzaF92cCgmYXJnKTsNCj4gPiDCoMKgCX0NCj4gPiDCoMKgCWxvY2FsX2lycV9yZXN0b3JlKGZs
YWdzKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogTm8gbW9yZSBURFggYWN0aXZpdHkgb24g
dGhpcyBDUFUgZnJvbSBoZXJlLsKgIEZsdXNoIGNhY2hlIHRvDQo+ID4gKwkgKiBhdm9pZCBoYXZp
bmcgdG8gZG8gV0JJTlZEIGluIHN0b3BfdGhpc19jcHUoKSBkdXJpbmcga2V4ZWMuDQo+ID4gKwkg
Kg0KPiA+ICsJICogS2V4ZWMgY2FsbHMgbmF0aXZlX3N0b3Bfb3RoZXJfY3B1cygpIHRvIHN0b3Ag
cmVtb3RlIENQVXMNCj4gPiArCSAqIGJlZm9yZSBib290aW5nIHRvIG5ldyBrZXJuZWwsIGJ1dCB0
aGF0IGNvZGUgaGFzIGEgInJhY2UiDQo+ID4gKwkgKiB3aGVuIHRoZSBub3JtYWwgUkVCT09UIElQ
SSB0aW1lcyBvdXQgYW5kIE5NSXMgYXJlIHNlbnQgdG8NCj4gPiArCSAqIHJlbW90ZSBDUFVzIHRv
IHN0b3AgdGhlbS7CoCBEb2luZyBXQklOVkQgaW4gc3RvcF90aGlzX2NwdSgpDQo+ID4gKwkgKiBj
b3VsZCBwb3RlbnRpYWxseSBpbmNyZWFzZSB0aGUgcG9zc2liaWxpdHkgb2YgdGhlICJyYWNlIi4N
Cj4gPiArCSAqLw0KPiA+ICsJdGR4X2NwdV9mbHVzaF9jYWNoZSgpOw0KPiANCj4gSUlVQywgdGhp
cyBjYW4gYmU6DQo+IA0KPiAJaWYgKElTX0VOQUJMRUQoQ09ORklHX0tFWEVDKSkNCj4gCQl0ZHhf
Y3B1X2ZsdXNoX2NhY2hlKCk7DQo+IA0KDQpObyBzdHJvbmcgb2JqZWN0aW9uLCBqdXN0IDIgY2Vu
dHMuIEkgYmV0ICFDT05GSUdfS0VYRUMgJiYgQ09ORklHX0lOVEVMX1REWF9IT1NUDQprZXJuZWxz
IHdpbGwgYmUgdGhlIG1pbm9yaXR5LiBTZWVtcyBsaWtlIGFuIG9wcG9ydHVuaXR5IHRvIHNpbXBs
aWZ5IHRoZSBjb2RlLg0KDQpCdXQgaWYgd2UgZG8gdGhpcywgd2Ugc2hvdWxkIHByb2JhYmx5IGNv
bXBpbGUgb3V0IHRoZSB1bnVzZWQNCnRkeF9jcHVfZmx1c2hfY2FjaGUoKSB0b28uDQoNCj4gPiDC
oCB9DQo+ID4gwqANCg0K

