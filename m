Return-Path: <kvm+bounces-63529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 672A1C68A2B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3F06A4F4950
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D6431DDA4;
	Tue, 18 Nov 2025 09:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAcenNW7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1241D29A30A;
	Tue, 18 Nov 2025 09:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763459096; cv=fail; b=Ev8d/DYVppinuedu4nUINF0LD6YSZyDyj7PgluMMtjCsSxCS+JclK6x60Qrk9pr6kw3D5Pzs8oVpk+BsYyQkHncGKBZ4qnNWzj5AACGzszShin1aSrS9HTzh7rBNplBmNqTI0E1Sgf2Y6bvU/xH49h/xJdJc32Xhz9wIhrwB0TE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763459096; c=relaxed/simple;
	bh=wAZclYWK1OsNTioQdJpiLNVpuoqfgCdh36AEF/5XAFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PsrbmZyrQ1xDdcm7TR3VIaf+kIMHep6dyBr6YKZhDd32aMKJpb+C950d0CrvwdpLfoc0r4b0t9CMtSCFoSOvvJE4dRkpYwcFF8DpZLAkGBtCZFn0hSYjNiEFXhIwSrcZvO+UjBLXygyPULvt5IhvW6Cp+MhOvQCYk6JX079Byug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAcenNW7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763459095; x=1794995095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wAZclYWK1OsNTioQdJpiLNVpuoqfgCdh36AEF/5XAFI=;
  b=LAcenNW74Fl50tz9MM48By6bMRIfPr5pTQUyCFNT47I6OFGS+YkZI+kd
   5BGjVpOxMx2h73DGQCnfxqdMbG170cQEqg7EjW7I41vPh1ZBeRt1bnzll
   DPJGGxh7BI1ZTEkhzaa3W4vaOyoG2oFRNHewuxDKuDp/pXk/4B/tQFL2N
   DbEToiv9yN1lQjULNQRu2Oolgaub2eUq/ApOQ0Ajyb9CWpl1f4ro7bC3i
   PQk9P222oRElxZC7Ky0yKBugn0mO/cqi2mBq/ipC41DOYbjL0JLhgJHju
   cutm0N0AcjPvQ8xGsKI7lu9P33YH70u3TvIylDQPxJpMsZgOMf3S8Dtq2
   g==;
X-CSE-ConnectionGUID: wOuCiz5tSvWWVlPu9dYmlQ==
X-CSE-MsgGUID: floQdYaDTiKH4pQtdeiWzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76826902"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76826902"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:44:54 -0800
X-CSE-ConnectionGUID: XrzmUjHZR1OvenjNXagvgg==
X-CSE-MsgGUID: mJ52tFDNRDyN8gqhUiyrIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="195624983"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 01:44:54 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:44:40 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 01:44:40 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.12) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 01:44:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WoB1M+iQ0o2ryd2B9jVuZlAIOX2eVyQRoDRd6kvXv+vlR8+8ZIjYPV8TcZ2bNegI5hXd+TEtatrJLdgXYxJUmtJ3RP3e64qAPp1nL+tyg5tcI2Zmu5YUDUxbE6O0OyJoEOoNAohlzVWSu5kPz8GcHYcgjxCU7C1fgE83wEUeudm99i37br0Ds7fL8rus5clG8i0VLnRXEYUC2wZi7kgmkLt8nGpZ4Nuv+Vr5/Li2U6u2QTn7EU9vdRg8Qa1utZqn5XrrXjnjBOM9HuyzAasA5NXmArXmGR60cOl4FtBNrF+4FfZWYjXFGdFh2KdUgzAJOJJ1tEoXZpZKo53P6/ahnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAZclYWK1OsNTioQdJpiLNVpuoqfgCdh36AEF/5XAFI=;
 b=dDQmzf0r3scAASDSAilSfir2SngxRGP0dMTZnOt6jV54VemL5x8RUvslJUbRBl9M/HWi1NRilpAAMm2Ge6I3kdI3oIKJfwzTvlcZEEkFmZyu5zJkPi7t5Z2/2CjImy775nA8RQJqdYSFJ3KsxeAgtX38jy8LU97IyGkhw9BOZFA4yb/V1ZJz4oZsb0tCDCp6bjQBOYxa6vK9LT2OLP3aVbjZ9ukTlqmmWX4K/YMMzWwLxH8FSnUAtQJism2wC9kgiaD0KfivLmHweIXknr6f9ybC31NQ+Xp8D2ixpyqpdEGa49XhGjJZRyNUGsR0+fj2VZQ6wIiHYYletTtTUHnTuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 09:44:25 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 09:44:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
Thread-Topic: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Thread-Index: AQHcB4ATc43XQ6PqxUuwXAgCtykiwLTt5ymAgAR4xgCABd+VgIAAFViAgAB7+IA=
Date: Tue, 18 Nov 2025 09:44:25 +0000
Message-ID: <3866c2e32d51f87ac80cb46489f99ee09e3e3864.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094423.4644-1-yan.y.zhao@intel.com>
	 <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
	 <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
	 <6635e53388c7d2f1bde4da7648a9cffa2bda8caf.camel@intel.com>
	 <aRvX9846Acx8NSZ8@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRvX9846Acx8NSZ8@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ1PR11MB6105:EE_
x-ms-office365-filtering-correlation-id: eb58d7e5-abdb-4bf1-ed6b-08de26870f5e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cTRpL09CczR4Y0EzNzRpRHZMZGRBOXdGblB4TTZEZ0hEU1JFMGdydVBxU1ZY?=
 =?utf-8?B?bzNjNUp4R3Ruemc3azQvVVRhT1B4VEhVY0lwYkhXc0k5aFZOMk5qRTRGKzBS?=
 =?utf-8?B?emUrazBXVWlNSWtoMjExTU85RFFiOVFpM3ZNcTM5NGtPN1ZIWU5wNGJ2L3VE?=
 =?utf-8?B?bXVPSVhrV1FJeng1UWVnbExIU3REazhLdnBLSHh4YzhzcGZRK1VZd01DcmI2?=
 =?utf-8?B?Q09jUUF3c3FLNXNqMHFiQU5YNHRTYVVEbmRCT215YlBTamkwd3ZLWXQraGFQ?=
 =?utf-8?B?UVVwM1lFaHc1MVNFdDVSWDE2SUQrOVJQN1BmbEdkWkhGbDhTZU9LVXZxS2Uv?=
 =?utf-8?B?aWZrOWJsVnd4bk5BZVMzQWxyVEwrcjZ1enVBaGFocXIzeWFNOTZuMWJ0Y1Nq?=
 =?utf-8?B?dHQzaE5rUk9jTU1lT1NIWllnVElFMkFjb2hOU1U2VisxVi81enBncWxkbm5V?=
 =?utf-8?B?a1JQczBVeUp4ZDg1c0lBZ1FkUmtCMVFoaDhQemthZlpHMHhIUmRub0RyWnY4?=
 =?utf-8?B?SkdaMDBQczd5Z0ZuMC9sQTVSTlFwQm5LdkJ5MEc3cWZ1VE0za1RjbzJoa05D?=
 =?utf-8?B?MW1DU29QckFlZmQrMTlaNGtERnhZN2FHSGZKRERnVm9iZHR2WTBRWHlnTlZa?=
 =?utf-8?B?WlJ0VmtnWkFURUZaQmdaQS9maGMvWDRCMXVZWlRUZmtYVXhObWY1WWtCeWp3?=
 =?utf-8?B?ckRjemZTY2g4OUtPcE0vNEdWTG84TEF5N1VySFhWOGczZnJ4NTRyL0QvUXlR?=
 =?utf-8?B?WE1wY0pKVkdadVlkdXg5UXkwK0xJdU9Vakw2QTR2S1hlYlYyQ2w0R21ud0JT?=
 =?utf-8?B?LzA2L2dQeDJ1eUEzZWQ4TVNmUmNOUGZOSkxGQUh0T3g2NE9yNnRkZnMyaktP?=
 =?utf-8?B?cEdVTTZtUnd3d1FWclkxYi9Ca1NVU1ZhOEl3RWVJRTZpY3BMOEpkNTlFRCsw?=
 =?utf-8?B?TkFOYU92S0FtbkkzWkJ3bjFaM2F4TWhqZHVQM0krK05LWWo2aURGbXc3Ymlo?=
 =?utf-8?B?Q0pMdXNRWlBjK1gzeVp0SXdtVDBSRFVrT2hFZW5wL0krWDNubkV4dy9zRjli?=
 =?utf-8?B?SUtjdXZuck1aSCtBcHQ0cU5iSUxuTlJoTVVBWk1tV3NHV2dwNVhhd09XVGd3?=
 =?utf-8?B?Y1oyT29CR2pzaDFwb3AyNnd6MWtrOW5GRzBqYnR4eVdWd2t5amNxQjBqdGda?=
 =?utf-8?B?RElLOHl0USt2dnV0bS9JSEZGSGVZY2dsWkVtbWZuRjV4L0JLRml4QUlsQnNI?=
 =?utf-8?B?NE4vUURTQWU1SmUwcXVVWGdJb0o1VURxVVp2c2ZHNXA4eG03OWVwdGg3NVFz?=
 =?utf-8?B?QUNWelRnbXlselBpalFJNldPSnNiVUplY0hZUVpXT0FobG5pYlY1OHQ3eGUr?=
 =?utf-8?B?NzBqSzZJdWdZbWhBbG8xNFhpaDZBNmFvTlhxTjBTNHFuMHJEUklOdFBZTlZB?=
 =?utf-8?B?K3AxYmlGaitPOGFiaVVBVUNHbnNpQnpaWXFYTm9pUEdoSFp3NVFWQlBmSEFn?=
 =?utf-8?B?MEtQVGNrS0NIUE9uUFN6TGRYTW4xd1FTUzdtLzNwU0lJdkRscmpWcHVnb3JD?=
 =?utf-8?B?SGdzdVlmMnNwQjFxVGJYWmRTNldhbnE5eWtwWmdHSG5pMnk3UWpMQW90U3Z6?=
 =?utf-8?B?K0ZibFMvOFByamV6cXpRMlVsbXI1eUorUDF1Sm1uY3IzSTJnUlVsM1pWWFFm?=
 =?utf-8?B?NW1hNzlScHZwZUZuWW9XY3VZY2lGaXAwOXpIbW83YzJYT3o2Zkt5cXZRWE9E?=
 =?utf-8?B?V2dkZ0JndlN2UkdUaVR2L2UvT1FtWk1qNzFmcG5XcncybzhLSHVlVms0SzdB?=
 =?utf-8?B?Z0kvZFAxU0VnaVUxRzMvTUoxYjdPUmEza1plbm1EaVJ1OVBuTmF3bzdUNXVx?=
 =?utf-8?B?U0ZnV09TaFpERFVxdG5vZzVTbjVsVEM5WEMxcWlOM1R4ekNTbUcvazhtZnE3?=
 =?utf-8?B?QkZxdjRadHFnZnplVnpmejhEK2xwemQzSnI5L1N2QS9pY3l4KzM0ZmFSUzFO?=
 =?utf-8?B?VXFnYld3dmc3MWNRNFZrT2pUdDh5amkzS1JYYWljZ1ZlZ1hPMnhxT2xMdlRz?=
 =?utf-8?Q?275zhW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0JvblNPcEJGeEhrOWVtSXA5SXVNQjRRS3hwL1FURkx2aXBSaVUzT3RaUDlj?=
 =?utf-8?B?c2RLaEtWYzFnZlcyZzRsRzkzRlJkbDJsRnNnakc2Z1lRK0NrYXZYUTY3S3RE?=
 =?utf-8?B?cEx6K3QzeWNacFNwRDJ1MmZDRk5zQjAzVWlZMDlJcHRwYUI0clFFUW9CK0VF?=
 =?utf-8?B?SDhiMC9aYW5ERVVPMFErRVVhYXFneHhsbUJPdHFVMGEwMUJ3N3dpSVEvNWpk?=
 =?utf-8?B?TXBUcFUrWitnU0RvNVZzR3dmcFh4RkVHbE8xcm9pS1JGdXc3b0xSalJDS054?=
 =?utf-8?B?aXBxWUF5b0VCVTJxQzdxb0p5Rkg5cWN0ZEZ0OWtQWVlRMmt2VnFDVkpMWEpF?=
 =?utf-8?B?NE5wR1lwc3hIeDNMSE5PcVBGdHo5Q1F5RTJRVTdQSWFhd0VLVUFOSXNrWVBo?=
 =?utf-8?B?Tis2QXhMVHZtenVBbG1FMlJLOWdKN3NGdWhsNDY0T3NVVGYyamZZdDl6aW5R?=
 =?utf-8?B?b1kxS3BHYnAzUVZzbmJDdDU4RS9nb0laWGc3WGh4UitHeVpQV0RhT20rb0JH?=
 =?utf-8?B?cVJLNVpGbFF6MmRxKzFtSW42aENkWUFIRVljZERTRUx3bHN5WFhQSngrYmxF?=
 =?utf-8?B?Rjh0TmtFeGF6VGtlOCtKc1JjblFXV1kxR3FhSTQ3TTFzVTVVZjRFSnZDOXRm?=
 =?utf-8?B?R3NweHAybnIrVlY1QkhaVVY2eWtMN2ZLUHNURGF4QnU2VU1GQXJIejNmRkVO?=
 =?utf-8?B?UVFJalgvNkRxMnlXT0xwbng1Vm5DNUloRkcyOXYxT2dCWVRJR0dmS09xWWdW?=
 =?utf-8?B?MDZUMUg3Q0Z4Vyt0bm5EaE1EL012NmZKRXRGM1V5dXpFc1B4R3FsUlRjSFJO?=
 =?utf-8?B?RGE2c2VPNjhobXN3aVZQd2MzZ1lWSXpZc2lOK3d0cEo0eFdqcG1reVJSUUt4?=
 =?utf-8?B?Tzd5OE5WSE9LbzRYNlpIZ3l4UDV0T292VjlTR3VjbzZ0ZTNwRk4xZlZabm9m?=
 =?utf-8?B?UGx3NEkzZDNPNmszMFBVYWRob3hoanFXM1FOUXk1WXFLckprTHVvMm1TZVQ2?=
 =?utf-8?B?U0VFSFVicmYrRENZaS9hTGw2dDdVTGd3S2tsUG11dzM2c3lieXpMVmphTDQz?=
 =?utf-8?B?dlZqb3RzeWpHM0NCVGkwbWl6ZUdvRjhxU0xybG9TcWtXMWhFVkNrbUV3a0gr?=
 =?utf-8?B?U2NiUXRlRkFhRDVqQmQwS2M2OTdmcmlTZTA2eUVIYTUzeHFsZEphaFZMTTcz?=
 =?utf-8?B?a012QlNZRTVPN2ExRnFwdkREa3NDKzFNNVE0b2NSU0oxUjVVSGFGeVZuTDV5?=
 =?utf-8?B?WWRtU2lBM1FUTGRUQUpub01adXg3Zk9OcWswWEcvVDU2YTJ6YmFOTUdyVVVu?=
 =?utf-8?B?YjMyUGNxQXQ2QTUzTGVmSnRiUFYzc0JEWUVjQjl1T3IrKzl4c2x6emhpckgv?=
 =?utf-8?B?aFBYLzJqMm5UTnlleDhFcnhncDZVZXgzeFE2cjZCRXVGRndhOHFyWnU4b0Qw?=
 =?utf-8?B?QndVai9rYmsvYzVUWGQ5U0RhSUY4Umh3MDc5a3dvU0E2SE81bEFoRTl5Sm9K?=
 =?utf-8?B?WUwxRFp0N3d0Y2czMExQbDNTa1FIcXhSTU0xYStBT05vYWhyWVBOcnkwMlc0?=
 =?utf-8?B?ZnM3M1RFazZYY0hrVDRuZkpxQ0FZT2MzZ0F6N0x1UVpzMmJZazNVNTZ6SFJ5?=
 =?utf-8?B?cUp5d2VEVzVRQjg0ZnNqcVhUcmxFc0o1ODJGdHZMYWtQK0xOOVdacEpHc29i?=
 =?utf-8?B?ZURNV3J5UHREODFQczkxNU5QRUlDQktGSStUTG1xYzQ1SXlHZ3ovZTdWODNr?=
 =?utf-8?B?d2VpU2NHL2tXcTh0OU9OTzI5bE1jWVRoR0hhUWF4eTl3TVJoVWdXcUViTTFh?=
 =?utf-8?B?ek9oak9JbjJDcG9KN0FSRG0vNVFXUUNkZERQNmtDWnMzSUx3ZG5pYm1EMDQv?=
 =?utf-8?B?M215YndURUkwZ0I2Zm9GdFV1NGJDcHJpUjBKemVKcHRiOFkrdDdDbG84eXRz?=
 =?utf-8?B?MVpxbnloa2gwV0w1NUwvNzFBRXhWRGZENXpxSGUxVWZoOGxDOTk0TlhFaWtT?=
 =?utf-8?B?dHRWRmI3SG1rU1dQKytUS01kVEUzNVkxSnBwTEVDZlJEU2h2QmwydzJIRVgv?=
 =?utf-8?B?RGJ2dDh0Ni8vN29vbEM3SVlWZlI4ZnhlNG54Qlhsei9RZWE4bWVjeEhSQVBr?=
 =?utf-8?Q?HGPK8ngxPb8haZDjvyf/0kQbB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BD15EE514FB9B46A5EB883B60EDC218@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb58d7e5-abdb-4bf1-ed6b-08de26870f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 09:44:25.3385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PTYiNFdKzLD5lx8iR4YhMKgl3nsDLZ4tWhHRnX/ss/VF4ltV7Fws2LlynfAmBn3GN1dHR2IZiCJuM2cqBkB28Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6105
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTE4IGF0IDEwOjIwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMTgsIDIwMjUgYXQgMDk6MDQ6MjBBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBGcmksIDIwMjUtMTEtMTQgYXQgMTU6MjIgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gPiBXaWxsICdsZXZlbCA9PSBQR19MRVZFTF80SycgaW4gdGhpcyBjYXNlP8KgIE9yIHdp
bGwgdGhpcyBmdW5jdGlvbiByZXR1cm4NCj4gPiA+ID4gZWFybHkgcmlnaHQgYWZ0ZXIgY2hlY2sg
dGhlIGVlcV90eXBlPw0KPiA+ID4gVGhlIGZ1bmN0aW9uIHdpbGwgcmV0dXJuIGVhcmx5IHJpZ2h0
IGFmdGVyIGNoZWNrIHRoZSBlZXFfdHlwZS4NCj4gPiANCj4gPiBCdXQgZm9yIHN1Y2ggY2FzZSB0
aGUgZmF1bHQgaGFuZGxlciB3aWxsIHN0aWxsIHJldHVybiAyTSBhbmQgS1ZNIHdpbGwgQVVHIDJN
DQo+ID4gcGFnZT8gIFRoZW4gaWYgZ3Vlc3QgYWNjZXB0cyA0SyBwYWdlLCBhIG5ldyBleGl0IHRv
IEtWTSB3b3VsZCBoYXBwZW4/DQo+ID4gDQo+ID4gQnV0IHRoaXMgdGltZSBLVk0gaXMgYWJsZSB0
byBmaW5kIHRoZSBpbmZvIHRoYXQgZ3Vlc3QgaXMgYWNjZXB0aW5nIDRLIGFuZCBLVk0NCj4gPiB3
aWxsIHNwbGl0IHRoZSAyTSB0byA0SyBwYWdlcyBzbyB3ZSBhcmUgZ29vZCB0byBnbz8NCj4gDQo+
IElmIGd1ZXN0IGFjY2Vzc2VzIGEgcHJpdmF0ZSBtZW1vcnkgd2l0aG91dCBmaXJzdCBhY2NlcHRp
bmcgaXQgKGxpa2Ugbm9uLUxpbnV4DQo+IGd1ZXN0cyksIHRoZSBzZXF1ZW5jZSBpczoNCj4gMS4g
R3Vlc3QgYWNjZXNzZXMgYSBwcml2YXRlIG1lbW9yeS4NCj4gMi4gS1ZNIGZpbmRzIGl0IGNhbiBt
YXAgdGhlIEdGTiBhdCAyTUIuIFNvLCBBVUcgMk1CIHBhZ2VzLg0KPiAzLiBHdWVzdCBhY2NlcHRz
IHRoZSBHRk4gYXQgNEtCLg0KPiA0LiBLVk0gcmVjZWl2ZXMgYSBFUFQgdmlvbGF0aW9uIHdpdGgg
ZWVxX3R5cGUgb2YgQUNDRVBUIGFuZCBsZXZlbCA0S0INCj4gNS4gS1ZNIHNwbGl0cyB0aGUgMk1C
IG1hcHBpbmcuDQo+IDYuIEd1ZXN0IGFjY2VwdHMgc3VjY2Vzc2Z1bGx5IGFuZCBhY2Nlc3NlcyB0
aGUgcGFnZS4NCg0KWWVhaCBsb29rcyBnb29kLg0KDQpCdHcsIHRoZSBjaGFuZ2UgdG8gbWFrZSBL
Vk0gQVVHIDJNIHdoZW4gbm8gYWNjZXB0IGxldmVsIGlzIHNwZWNpZmllZCBpcyBkb25lIGluDQpw
YXRjaCAyMy4gIEkgdGhpbmsgeW91IGNhbiBhZGQgc29tZSB0ZXh0IHRvIGV4cGxhaW4gaW4gdGhh
dCBwYXRjaD8NCg0KRS5nLiwgc29tZXRoaW5nIGxpa2U6DQoNCiAgQWx3YXlzIHRyeSB0byBBVUcg
Mk0gaHVnZXBhZ2UsIGV2ZW4gdGhlcmUncyBubyBhY2NlcHQgbGV2ZWwgZnJvbSB0aGUgZ3Vlc3Qu
DQogIElmIHRoZSBndWVzdCBsYXRlciBhY2NlcHRzIGF0IDRLIHBhZ2UsIHRoZSBURFggbW9kdWxl
IHdpbGwgZXhpdCB0byBLVk0gd2l0aMKgDQogIHRoZSBhY3R1YWwgYWNjZXB0IGxldmVsIGluZm8g
YW5kIEtWTSB3aWxsIHNwbGl0IHRvIDRLIHBhZ2VzLiAgVGhlIGd1ZXN0IHRoZW4NCiAgd2lsbCBi
ZSBhYmxlIHRvIGFjY2VwdCB0aGUgNEsgcGFnZXMgc3VjY2Vzc2Z1bGx5Lg0K

