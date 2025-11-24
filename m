Return-Path: <kvm+bounces-64407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B87C81839
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F3AA3ADA4F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A887315D48;
	Mon, 24 Nov 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yKEPTG/T"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF4F315D44;
	Mon, 24 Nov 2025 16:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764000952; cv=fail; b=RmNtE2ygTzyG1jNHi/mOwP5xr/RBzuDn1RWO9e3k3KonM6XP4FpJ+e+bRSPbQY0jMJoRPwYdxSqwjHjtKc9uVRG631TzSblXVwFie0dXOQCbMlQjhUOHfod1s+PtarA5s8p3u65YKTlPCSmYPXz4m/WTHY6z7xF9jWtEjVTs5W4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764000952; c=relaxed/simple;
	bh=gGYYhzsiGeaVdX2/66vCeR50TL/s9Z7t3LhCCB33z0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gm7TI2BDBCemlVBh4mET1hFc2ZNEz43zGqRDFKw3WkvfCfyFhhUiNSlARuB4fEFUpyJk0QF0g+aQQ3//2URAL5vw9qd8Hn/6uUQ5RzE/CUsOcZ0w4to+7gcg/47/7xOphrGtqa/DMfm1gesF9GAbtfpYR18WpDTQDPxZnhC5EuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yKEPTG/T; arc=fail smtp.client-ip=40.93.198.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=At4Vf9VZVGLM2NXRQ6hvYiXHVYYiVe5feloC1Vyo4mieOEXKQX3Xuf0d/QS3UPcRGi8NsM4Y3VxLUbLRn+YQtHfqE/2Eh6ufFKbKnTsyOQdLbfzPVrsCOq2MaIC/kiafEuHhCBhZ7LdE3IdgAVfLgMNZIVmk53DO2rhjrQ1GwcHhsg23AkAOF7HGjKVh3wdj1G1ILQGhOoxuKF9ArZsRdjOyRjsXWRZE8b3Ze7kAQKClPcOy3gTTPrb5y36qJAeDL8icLfssLvhdhfPpKLKJz+5m8n1ZIg16dvz+C6NM9e0wOgOlW7W5AU+m1ENhg1jtDJmErP9epeS8XxkpEOoMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGYYhzsiGeaVdX2/66vCeR50TL/s9Z7t3LhCCB33z0c=;
 b=G1GtRS6BOSEEl1COHN5FbyBltUtppN7DkL9KhbqHV4rB3ZLFQ5yX8+X54nKVxU3dGomnOvtOYV71YYPC53S1RHcz/0E5Zeg/ZHuOWxujbC8d3Gp4VUUzfTQk0kS14T8vaYxAlu1P9lGWQTh2vZm+hsw4lKmzfWBJDiCZe9Yx/OSsUrXInglHmZHnhnhTD1rQ0X/88F/0Id/tpXEALTKbPugzwMocJl2ssTR0umcgb20+9v4rzFYDHAY9vhGiS4HD6if5jJxZdxy68EBVX9junh4FT8rbGHM4ENrq31nto6qMq4gG9/gr5hGmBv8BGIBPnUqqUbTd2JhAoUZLOjOREw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGYYhzsiGeaVdX2/66vCeR50TL/s9Z7t3LhCCB33z0c=;
 b=yKEPTG/T4D3HIHlYz1/nxtTPn2KqpPVgG9bCxBx4OXJ43wifQrqT5BLojLRnANO521z+NFZhtmmvc+hKCLpFnixWFfczEtTznroph8LodLBAtjsRNv0jMmo/54sG/hpSLydJDoexUpHd9OirmKaSbVM8XIuOWdK9MgEFbrx+Pio=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 16:15:47 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 16:15:47 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Topic: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
Thread-Index: AQHcT8mMnd7JB9P6okicpWg0VkazobT8FAuAgAYHjoA=
Date: Mon, 24 Nov 2025 16:15:47 +0000
Message-ID: <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
References: <20251107093239.67012-1-amit@kernel.org>
		 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
In-Reply-To: <aR913X8EqO6meCqa@google.com>
Accept-Language: en-US, de-DE, en-DE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MW6PR12MB8949:EE_
x-ms-office365-filtering-correlation-id: 0b65eb8a-80cb-4c4e-8a39-08de2b74ba29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cHpLMDZyK3hEQUE5UG04TFlWd3hjeDgrVmM3OGgxL2FyRW5la20wZEg0ejJu?=
 =?utf-8?B?djdWbGhncmNpMVRIVFRDaTh3bUZJamRxQVgzejk4WmVnWm5uemxkR3hURHNm?=
 =?utf-8?B?dUM3RDc4Vml4SzZEWU1CR3BRdlNJaEh6WFE5anBQb09abER0Q0lmeFgvVUx4?=
 =?utf-8?B?cXdpVGp3N0x5OW82MjAzbDE4bVlSTGU2WTdMSzNuVmRmQkF4UXBFMlB3L2Uz?=
 =?utf-8?B?MjZaNDJ0c05ZSlVTcC9paEdxbEtTeXpQMWlYdGwxYmpsb01DUUJsaDUwZEc2?=
 =?utf-8?B?OTllNHM0ZEtXWlF1OWtyNnFkaklhOVVmTFA2RnplckpzQW14bG1nUW9LWnhW?=
 =?utf-8?B?WXEydjBLQS9uWHlQeU91ZTRNZ3drRG94SmNHWUhFWngrN3dQUHF2cm1UdHNw?=
 =?utf-8?B?N1hYMXFYbjlOMkJhY2pGYkRYYXFIY0FpZnR2NFNPcTIrQ3lqTUljTzZoQXpS?=
 =?utf-8?B?NS9jcS9yUFdxbVBHR0prU3hUQXhGOVpXcWpkZUZvUVRObkZjM2k3TEhOWlBI?=
 =?utf-8?B?K2d5cCtUdVB4WjRsOW9jUkRUd1E2c1BvZmQwOFVCb0dnK0M4c3RjTFRQSzNp?=
 =?utf-8?B?N3pvdjViT0I2MzJyZFIzVnFtNCsvTjF4eXhHbFVRM2kxU3FyZW5ZWW5hK3lv?=
 =?utf-8?B?UjQyb2w4Z3Z3SzBZRFAvTFVUYUI4VExDWGlsalpoTG5Ra1gyaW5ubEh0ZUpJ?=
 =?utf-8?B?UUNrTCtHeVRuU0htUEhCRXltQ1JReFp4OFNrYWRVeXFvSWdkZkJMN1NScVZH?=
 =?utf-8?B?cHJhcFFvcmsyZUFmWXQ3QjNYNTNET3NuVHBRMFZaM3NsSFNzU0hHYmZDQ3p1?=
 =?utf-8?B?TWhmWXRCNXJhTG5ROHcvbys4ZUNFektEYlZ5dGtXWkdUQ01WRzdKeUt1NFFt?=
 =?utf-8?B?MjZiRkFFMkhxWE4wRnd2TDBXVXlDNVZMQ0FHQU81bXJuL3hyQjJmN29meFdK?=
 =?utf-8?B?bUJHZDhIT1BDcEpwZ3JZWGo5aFdFN0NqdFozT1NBeTVnS0hzUkVrQWFRNFJN?=
 =?utf-8?B?T3g4RWFlT3pock5KYm9BN2x5QkxqYUI1REtnazQ1TW9GbnJCTjhJM1JyUEty?=
 =?utf-8?B?eTNxYVZ1amdURzhZSUJhSG1FQjJBRHZZZzBmUTE5YldpRjFyMHBjVFNIbVJF?=
 =?utf-8?B?M3BMMS83Z0drM05tdnNyNzVXN3VlSXc2UzlRbVZacVpUMlNuOExnam52ajFI?=
 =?utf-8?B?SlltNlZNTE8wSkVad25uaXRyRU1TSE1wSnErNnc5Szlwd1U1ZTFNVzl1TWc1?=
 =?utf-8?B?UmxhdW96dHRYUEpDMHFrL3dXZWtHV3hDRU5Sc0xtNTJvV2tpZnhudjM1RHJO?=
 =?utf-8?B?cC92QXNuK013MDVEclNoa2kyekV3Nk1SdWIwNjNyd09kQkhzOXJmRnNGL01O?=
 =?utf-8?B?R3RTNWEvOTFSTXJpN0JlTlptNDFZMGNRU2FiYmlYVEJpT3FBeE9GTEtucCtZ?=
 =?utf-8?B?WnYydFNoRnFUUVFqRzNvSHZHNmpjRC9vb2owS1RxS2w2S3R1Rm9PQVJGMHhD?=
 =?utf-8?B?RGdHMEpqaEpTNzFRTEtSTWJ3eGtIMVpMTEpxMFBhU0JOVzdZb0ZpcGVmMnZI?=
 =?utf-8?B?Z1JXSksvWnZ1UXhIQjYzblBueEJoamlXT21xRnlkcEZVUXhISGhxbHdJSHUv?=
 =?utf-8?B?Z3phRHVtMDBpVXY2NEF6eVdiV3VEUDAxVTZqZmN3SXpqekkxMTh1UGpmL09j?=
 =?utf-8?B?bko0VS9Xcm5ycFFtNVd3ay9PazFQejZaQ090R251WFRhRjQrZzFZN1BBSVdx?=
 =?utf-8?B?eXZ0SWVzQUlCbnhHSVNIZkNDNjA3Z1Y3WEFHWlB4MHYyVVZpZ0FIRm1jTnV1?=
 =?utf-8?B?cTNEOW1sRXhVclNJQmxVSkVSNHhMbHZabzFyNTdlSEJwYzdXNVZydnBJeElk?=
 =?utf-8?B?c2RqYmt0d0tPdXlOb0d4RzViYk1GNzUwbHQ3WjhRVk10S2k1VW9TSEE3cHBL?=
 =?utf-8?B?RjdFZm1POVBhekFRTUdzVURrcnZlVHhBalBLbnMwMHRHZlRkQTZKOUFhR3hX?=
 =?utf-8?B?K0xtRG1yYzkxSzFFRmIvc1gxY29KTnVLWm5OMCtZc1VSaE96MmJtT1c2eDdm?=
 =?utf-8?Q?7q9U+5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RGpaMy9TWm9oWW5RZmV1RGdGWktUcHJTSDRqbnNWTXJ1N0Q1aURhSEZYYWFJ?=
 =?utf-8?B?QVF3UWFLR3F4YVlRM0FBTEtnZTJrbUZMTko0MVNrWUNBNlVpWkVvdzB0ZUpN?=
 =?utf-8?B?ODl2TGZsRWkxaGEvS3JjWHNQVEJGTWE3T3o3cU1WRFlIa0VpelI5L01Kcnpk?=
 =?utf-8?B?MlRoMkFhY1pWdFNvc0hXQVNzZHk2VnBXUndIZUFFOEw3b2cxSjJaNURGSTVK?=
 =?utf-8?B?S2pQc3pINHZ1WHF5ZjA5TzUyamRBWVBWT3BsWjBoRWxXUUpsS09WQzRJVEpJ?=
 =?utf-8?B?Y2ZOcDM1bEJBWWRCcHNJTDlsUXllSU1UbkJDR3lsZG5yS21HS20ySDVwV28z?=
 =?utf-8?B?MSsvNDMrMElXUEtteHp5SU52S3NCbUR1MGxtZ0lDb2lzTFpuUkl3Mm50MnYr?=
 =?utf-8?B?Y1BYL2h5RFNiM29pb1ZoazZreUt1dms3SVFFYk9NU2FxQmdBc3BjU04vZnhI?=
 =?utf-8?B?T3c4d3I2K2dzVFdNeHhMMi9uTzlaRUZXZHo4MHROdEZPMlcwL3ZTeWs1cEdJ?=
 =?utf-8?B?aXNJY1NTaGthTE94VHZoNDZ0VGlKOWk2a0JHenlnbVFXQ1lkYkxyVTRVVXRO?=
 =?utf-8?B?djhQUjMxb2pvWS9uZFJzYzIwbUtJQlpaQjQyYVlDa3RwaW1xZ1Z5OTkxQzdJ?=
 =?utf-8?B?bEVKcnpkdVRpZ1YvYW9JT3M2c2lvSWFkcVJXK1NKVlh6VVNqNDFsUjNaQTlU?=
 =?utf-8?B?S1lCWTZFdE1VVis1cEZoNXowd0xCWlB2ZlA4aVpicnJuTGZRMnNHR0lzaUFm?=
 =?utf-8?B?b3E2WHI0aStpelM0T0h6NElSdkhkOWhsS0pRWG1JU0t5RzhDdTQ2Z3lhMjFQ?=
 =?utf-8?B?R1ptS2dadXpvREZ4SGVaWmZuQWVsa21NaWxBcU13T1ovWk1wdmJZNEhidWRM?=
 =?utf-8?B?T0d2K1ZILzN4VlRNTktabEhGcEpvQ3dtOExUOHNOZWpMYk80ZDFCWVZuOEho?=
 =?utf-8?B?U2FaUG1rNnZmZDFncjFmMlN3eVBuS295ODVoMk1Ld1RWSGREdUh2U1hUcnZ1?=
 =?utf-8?B?OGlycFNhSE5pdUJMOVNsRkpsN1RmbFFycmNLT1U4Q0JiQXpqL3RWV0JmaXl5?=
 =?utf-8?B?OGw5N0ZVWS9mNVNoL2RzRUNteG5lSGJzL0o2S1RGL0RFb25xQS9Fc1dXQ1NT?=
 =?utf-8?B?Y3ZscGJ6b2N1MC83bHVKeFlvZitQVmtnUEdXWUpOUXZwRFQxdm5oWks4bVpQ?=
 =?utf-8?B?d3lSZDZ0NVdiYkVHalZrQkRPMmluRGVhcU8yNWR1dmZ0N2hBbis0TGFyN1Zt?=
 =?utf-8?B?d1pmOEZGeDh1V0VSTU1XcmRLaHRmNStISm12SzltdmFDWWhBUGxHZnJLa2Fl?=
 =?utf-8?B?eGdRZUFxL2VqNmVZZW1OVzZrclkvUCtNTThBRWZhNGdTT3BUQWQ4Mk9sbDJq?=
 =?utf-8?B?L1VRcDZvT0IyUXJtN1JTNlNZeHRPUTZGVyticHJ6YjBCNXh6c2RnaDJTWnpy?=
 =?utf-8?B?aUFpb3ltTWFMb2U1ck14T3Q3bzA0ZU9nSWhwQ0IyemdPS1dhT1UwK1hpUXJE?=
 =?utf-8?B?bzh4bGdJQTNyU0ticzhFditFOGlGdElnQnl4Nkh1VmhyZDRhbTRPcHpPV3g4?=
 =?utf-8?B?QUd3c0kzalNLMEVDWDduTGYzL0hMUVhuRlo4OHVheURMZ3lPMzg1dG1CKzJ1?=
 =?utf-8?B?L1pGcm43MGNNZ0Z2S2J6bStySDRoemZFMnJlSTJINjB1eTdKN1dTWWYrTGg2?=
 =?utf-8?B?VGZkU3JTSWJYNlphSUJCM24ydEphbUs3VS85TlM4YnRCRFY1OEFWYnFwbEZl?=
 =?utf-8?B?WFpYSXFPYnhoUmV4VGRJbHI5eENDSmtic2tINldRU0tjTWxoK0dVYVRzc0VM?=
 =?utf-8?B?S3lNcU5HOVlhYmZKb2NnS2gxSUJSckNyeUp0dWF4eXF6dGt0TEg4Y2Q4Q2g2?=
 =?utf-8?B?dU1DNUpqYmNnd05xTUFKd2crb09uaERBWWw1NjhBRFdDZ3BwL2JHSk5VOUVP?=
 =?utf-8?B?NVRzR2dlVElOcmRzeWt5THUwRExZUzJPeFJZMkZRV0s5blV1TGwwaGR0K0Ew?=
 =?utf-8?B?VTRpdmI0aDB1alhsaEp0Z3hveHZVM0JMWnJKN25nQUoxWlhjVVhRMUlPWEZY?=
 =?utf-8?B?NVNVK05KRnJaamEwZDAreG5vQUdmQ2ZsdXQ3MkFZeURWQlFTaWVWQno0VEtF?=
 =?utf-8?Q?9rspjC7gVy+Q6skwXbuChswAJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26AC3E1718767F4AAC361E917698764E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b65eb8a-80cb-4c4e-8a39-08de2b74ba29
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 16:15:47.2477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9IkGezAlB0Xbbmij8sPD7b40bTznkae3EAVflAsDiwPcA102zorImrGzVaDdnhlvukZ3WJS2ecvISJlCquYCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

T24gVGh1LCAyMDI1LTExLTIwIGF0IDEyOjExIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCg0KPiA+IDIuIEhvc3RzIHRoYXQgZGlzYWJsZSBOUFQ6IHRoZSBFUkFQUyBmZWF0
dXJlIGZsdXNoZXMgdGhlIFJTQg0KPiA+IGVudHJpZXMgb24NCj4gPiDCoMKgIHNldmVyYWwgY29u
ZGl0aW9ucywgaW5jbHVkaW5nIENSMyB1cGRhdGVzLsKgIEVtdWxhdGluZyBoYXJkd2FyZQ0KPiA+
IMKgwqAgYmVoYXZpb3VyIG9uIFJTQiBmbHVzaGVzIGlzIG5vdCB3b3J0aCB0aGUgZWZmb3J0IGZv
ciBOUFQ9b2ZmDQo+ID4gY2FzZSwNCj4gPiDCoMKgIG5vciBpcyBpdCB3b3J0aHdoaWxlIHRvIGVu
dW1lcmF0ZSBhbmQgZW11bGF0ZSBldmVyeSB0cmlnZ2VyIHRoZQ0KPiA+IMKgwqAgaGFyZHdhcmUg
dXNlcyB0byBmbHVzaCBSU0IgZW50cmllcy7CoCBJbnN0ZWFkIG9mIGlkZW50aWZ5aW5nIGFuZA0K
PiA+IMKgwqAgcmVwbGljYXRpbmcgUlNCIGZsdXNoZXMgdGhhdCBoYXJkd2FyZSB3b3VsZCBoYXZl
IHBlcmZvcm1lZCBoYWQNCj4gPiBOUFQNCj4gPiDCoMKgIGJlZW4gT04sIGRvIG5vdCBsZXQgTlBU
PW9mZiBWTXMgdXNlIHRoZSBFUkFQUyBmZWF0dXJlcy4NCj4gDQo+IFRoZSBlbXVsYXRpb24gcmVx
dWlyZW1lbnRzIGFyZSBub3QgbGltaXRlZCB0byBzaGFkb3cgcGFnaW5nLsKgIEZyb20NCj4gdGhl
IEFQTToNCj4gDQo+IMKgIFRoZSBFUkFQUyBmZWF0dXJlIGVsaW1pbmF0ZXMgdGhlIG5lZWQgdG8g
ZXhlY3V0ZSBDQUxMIGluc3RydWN0aW9ucw0KPiB0byBjbGVhcg0KPiDCoCB0aGUgcmV0dXJuIGFk
ZHJlc3MgcHJlZGljdG9yIGluIG1vc3QgY2FzZXMuIE9uIHByb2Nlc3NvcnMgdGhhdA0KPiBzdXBw
b3J0IEVSQVBTLA0KPiDCoCByZXR1cm4gYWRkcmVzc2VzIGZyb20gQ0FMTCBpbnN0cnVjdGlvbnMg
ZXhlY3V0ZWQgaW4gaG9zdCBtb2RlIGFyZQ0KPiBub3QgdXNlZCBpbg0KPiDCoCBndWVzdCBtb2Rl
LCBhbmQgdmljZSB2ZXJzYS4gQWRkaXRpb25hbGx5LCB0aGUgcmV0dXJuIGFkZHJlc3MNCj4gcHJl
ZGljdG9yIGlzDQo+IMKgIGNsZWFyZWQgaW4gYWxsIGNhc2VzIHdoZW4gdGhlIFRMQiBpcyBpbXBs
aWNpdGx5IGludmFsaWRhdGVkIChzZWUNCj4gU2VjdGlvbiA1LjUuMyDigJxUTEINCj4gwqAgXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4N
Cj4gwqAgTWFuYWdlbWVudCzigJ0gb24gcGFnZSAxNTkpIGFuZCBpbiB0aGUgZm9sbG93aW5nIGNh
c2VzOg0KPiANCj4gwqAg4oCiIE1PViBDUjMgaW5zdHJ1Y3Rpb24NCj4gwqAg4oCiIElOVlBDSUQg
b3RoZXIgdGhhbiBzaW5nbGUgYWRkcmVzcyBpbnZhbGlkYXRpb24gKG9wZXJhdGlvbiB0eXBlIDAp
DQo+IA0KPiBZZXMsIEtWTSBvbmx5IGludGVyY2VwdHMgTU9WIENSMyBhbmQgSU5WUENJRCB3aGVu
IE5QVCBpcyBkaXNhYmxlZCAob3INCj4gSU5WUENJRCBpcw0KPiB1bnN1cHBvcnRlZCBwZXIgZ3Vl
c3QgQ1BVSUQpLCBidXQgdGhhdCBpcyBhbiBpbXBsZW1lbnRhdGlvbiBkZXRhaWwsDQo+IHRoZSBp
bnN0cnVjdGlvbnMNCj4gYXJlIHN0aWxsIHJlYWNoYWJsZSB2aWEgZW11bGF0b3IsIGFuZCBLVk0g
bmVlZHMgdG8gZW11bGF0ZSBpbXBsaWNpdA0KPiBUTEIgZmx1c2gNCj4gYmVoYXZpb3IuDQo+IA0K
PiBTbyBwdW50aW5nIG9uIGVtdWxhdGluZyBSQVAgY2xlYXJpbmcgYmVjYXVzZSBpdCdzIHRvbyBo
YXJkIGlzIG5vdCBhbg0KPiBvcHRpb24uwqAgQW5kDQo+IEFGQUlDVCwgaXQncyBub3QgZXZlbiB0
aGF0IGhhcmQuDQoNCkkgZGlkbid0IG1lYW4gb24gcHVudGluZyBpdCBpbiB0aGUgIml0J3MgdG9v
IGhhcmQiIHNlbnNlLCBidXQgaW4gdGhlDQpzZW5zZSB0aGF0IHdlIGRvbid0IGtub3cgYWxsIHRo
ZSBkZXRhaWxzIG9mIHdoZW4gaGFyZHdhcmUgZGVjaWRlcyB0byBkbw0KYSBmbHVzaDsgYW5kIGV2
ZW4gaWYgdHJpZ2dlcnMgYXJlIG1lbnRpb25lZCBpbiB0aGlzIEFQTSB0b2RheSwgZnV0dXJlDQpj
aGFuZ2VzIHRvIG1pY3JvY29kZSBvciBBUE0gZG9jcyBtaWdodCByZXZlYWwgbW9yZSB0cmlnZ2Vy
cyB0aGF0IHdlDQpuZWVkIHRvIGVtdWxhdGUgYW5kIGFjY291bnQgZm9yLiAgVGhlcmUncyBubyB3
YXkgdG8gdHJhY2sgc3VjaCBjaGFuZ2VzLA0Kc28gbXkgdGhpbmtpbmcgaXMgdGhhdCB3ZSBzaG91
bGQgYmUgY29uc2VydmF0aXZlIGFuZCBub3QgYXNzdW1lDQphbnl0aGluZy4NCg0KPiBUaGUgY2hh
bmdlbG9nIGFsc28gbmVlZHMgdG8gaW5jbHVkZSB0aGUgYXJjaGl0ZWN0dXJhbCBiZWhhdmlvciwN
Cj4gb3RoZXJ3aXNlICJpcyBub3QNCj4gd29ydGggdGhlIGVmZm9ydCIgaXMgZXZlbiBtb3JlIHN1
YmplY3RpdmUgc2luY2UgdGhlcmUncyBubw0KPiBkb2N1bWVudGF0aW9uIG9mIHdoYXQNCj4gdGhl
IGVmZm9ydCB3b3VsZCBhY3R1YWxseSBiZS4NCg0KPiBBcyBmb3IgZW11bGF0aW5nIHRoZSBSQVAg
Y2xlYXJzLCBhIGNsZXZlciBpZGVhIGlzIHRvIHBpZ2d5YmFjayBhbmQNCj4gYWxpYXMgZGlydHkN
Cj4gdHJhY2tpbmcgZm9yIFZDUFVfRVhSRUdfQ1IzLCBhcyBWQ1BVX0VYUkVHX0VSQVBTLsKgIEku
ZS4gbWFyayB0aGUgdkNQVQ0KPiBhcyBuZWVkaW5nDQo+IGEgUkFQIGNsZWFyIGlmIENSMyBpcyB3
cml0dGVuIHRvLCBhbmQgdGhlbiBsZXQgY29tbW9uIHg4NiBhbHNvIHNldA0KPiBWQ1BVX0VYUkVH
X0VSQVBTDQo+IGFzIG5lZWRlZCwgZS5nLiB3aGVuIGhhbmRsaW5nIElOVlBDSUQuDQoNCj4gQ29t
cGlsZSB0ZXN0ZWQgb25seSBhdCB0aGlzIHBvaW50LCBidXQgdGhpcz8NCg0KSSdsbCBydW4gdGhp
cyBvbiBteSBoYXJkd2FyZSBhbmQgY2hlY2sgZm9yIGFueXRoaW5nIG9idmlvdXMuDQoNClNpbmNl
IHlvdSdyZSBhbHNvIHNheWluZyB0aGUgbnB0PW9uIGFuZCBucHQ9b2ZmIGNhc2VzIGFyZW4ndCB2
ZXJ5DQpkaWZmZXJlbnQsIEknbGwgY2hlY2sgd2l0aCB0aGUgaGFyZHdhcmUgYXJjaGl0ZWN0cyB0
byBjb25maXJtIHdlIGNhbg0KaW5kZWVkIGdvIHdpdGggdGhlIFJBUCBjbGVhcmluZyB0cmlnZ2Vy
cyBhcyBwcmVzZW50ZWQuDQoNCgkJQW1pdA0K

