Return-Path: <kvm+bounces-34769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5F1A05A69
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 12:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB54F3A1187
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AEF1F8AE0;
	Wed,  8 Jan 2025 11:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nL/OIILr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8D1FA178;
	Wed,  8 Jan 2025 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736337042; cv=fail; b=j4k9/NaYQ6JW+RXDlHlnB8MkukZUICt7UTkMWPloV/IKkyrTsyGcZFXTDYXdEbMlYeYccj15c5F/Uk82tJ5mTLyC2dyTmY/4SOKM1ruEHNvhhtcAcp0EKfbQppMkkM9Z3ipDDaqJEi9Gcfoa0XIEJPq8btg7hv6ErKpS4jKpoUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736337042; c=relaxed/simple;
	bh=Nm4NYgsunH2umHHAOUp6uvwqpYK8qZ8KIjx8SE0iEo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y8Wwu1A5L7ObwMG1mqxQ7tggRzrJsjgcFTr26y/Kx2efjrH2IXlX7MdgA4UZvznn2Dh+EEFKwkgtOjL1EcuBlHe/oUBK6uaUKlECL18kpXBEu1By3XUmkOh45miSY5k+Kpe2ESuc/HaJ4OooIYJBuWp6NOVM6CFFeAN8NAmRm3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nL/OIILr; arc=fail smtp.client-ip=40.107.244.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQI6va1wX+aqK/Uk/j3i5rUj3inEGX2IGpNORtR/P7olQYZxIrLW3N+sPuEs12F1ODdfNrY+OOITSSZqXP6dODBWrAjZRoiAy9dd5UMGxfnlYFvf/0ZOtqy9auH+Iriiwy8a7Hv0zBgKc3V7SPXomkq015G0PzAs4SvrHpwn4PXLb+igPuYRGTm8ca5A7pnqZoAaNHwadnv4Mt97Toa2Z/tH+abH8/19GyNJnF45Yw/YpGBMjq/TUQv+fiheFrxw+uvwFn/4TWOrwAnkPDT4pF2Vzstss1lDxYN+pasqvEPfkLhGPKcON0RS41S+wbGw7Cw0Fo53jVZpkp0xSUoRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm4NYgsunH2umHHAOUp6uvwqpYK8qZ8KIjx8SE0iEo0=;
 b=SoxOYabPWJEKvSKKqcBXa7mrNUKdCXtA7kKqboQlHjpD93HN2EQf2j4m1VygRTmif5Vz0h3yQB0zNEzI/J0tXJ4ij/maoYBhXYBQ/v4Wgcp4hwXcTYuYGNBiOHK1XTh4bJCCWH9L6egtbuclke0FiPUAeXPNlwbgOCNKcZS06kNbmLw/SGBVWRDHTs+6crVMfdvfXxXEy/caKcjsaB2IRAFQKDxr2bFfnm+mxgPMBdnZ5bGF4k2H1gXOustyhjQqQaCIR+CrAJqv8CMSgJPUc3YVmJOOnXQL4nhaz0lNtkO7MaJiQaC0x3YuGJZGm5yUAxvy9LLxGYbRn9ugFb7WmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm4NYgsunH2umHHAOUp6uvwqpYK8qZ8KIjx8SE0iEo0=;
 b=nL/OIILrblFXshCeBzIyI7t7rZaxNTN7vF6EdY0/K8EiY4sDMX5JGMVNO2lEHkohm9Df6YT9xXabPiC1RBIimNSMuPGE44RqwlVlijE24aDRWMsxeg5Jxz5jJx8f/vLT5C3LgFK00ywR5Wx2yMeXk84PCcV1Ef1L2IFJZHPNufI=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by PH7PR12MB5975.namprd12.prod.outlook.com (2603:10b6:510:1da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 11:50:38 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%4]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 11:50:38 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Topic: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Index: AQHbPFEFmhn1AaOfa0iqMfWlRJj4srLYY1aAgAAWbACAAXNgAIAzIUyA
Date: Wed, 8 Jan 2025 11:50:38 +0000
Message-ID: <5175b163a3736ca5fd01cedf406735636c99a7e5.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
	 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
	 <20241206005300.b4uzyhtaabrrhrlx@jpoimboe>
	 <20241206230212.whcnkib4icz4aabx@jpoimboe>
In-Reply-To: <20241206230212.whcnkib4icz4aabx@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|PH7PR12MB5975:EE_
x-ms-office365-filtering-correlation-id: 23dbd4f6-1a6e-4393-e7e7-08dd2fdaaba6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WDc4T1Rya0hybnRyaFNHVlhORDNQeTk5Wi9WY0xWeTZ1elNEaCtURlRla2FI?=
 =?utf-8?B?Q2ZSVDJtaXY5SmMwOUJ3NXV3c0VoME14YU15dkc0ZUx4NzBMT1ViT25rN00v?=
 =?utf-8?B?NEFxczdJcklrd3RweEhCaElTdjBDMzNneWJGc2poTnRyTVhrZWFnUFpISGZy?=
 =?utf-8?B?ZlU5cGJSNXcyc2lKd0lmMGFZYW1rVXBmbFVsVDRVUHlHeVRVM3BZN05ub3BB?=
 =?utf-8?B?YmtWZml6ZEpra0UwUFdBNUJNR2d6ZXM2U3VNTHpDSW9pTE9rekwzMDU4dEhp?=
 =?utf-8?B?ZEp2MFduanh0aUZyeEhkQ3I4VDZPQWFuT3MrRDVjaS9qNFQxRWhQQzFjQkV5?=
 =?utf-8?B?S3ZVb3hnWHhXOEI1Z0JCSjJ3cXhucVVWbWc0WE1MRDFDTFFjNHhlY3BLVnJ6?=
 =?utf-8?B?c3I3R3M4d0Y2Z1JqOGxOSDZlSFFRa0FOYXh1d3F0TFl1T3RuVnpmUTI3VjFn?=
 =?utf-8?B?OGNYTE9jeHU2SGNjMEpiZWNtV1l0OFBvV2ZDeGwxd0JkMEl2aTB0M2FIb081?=
 =?utf-8?B?aFJQcG1vbklVYXZTR3B6ai90bDZhajJ5ZGZpeXFsaUhPWDBtbWNHTXZSNGlt?=
 =?utf-8?B?NlYvL2xTMEM4K1VTZ2puQWNyaEQ3ekpDZFZkdWt5N2VUY2N2cXhnWDBHZnRJ?=
 =?utf-8?B?VTNRUDFOTEFpa1R3ak02K05JTmN2bGh0RWdhV1JEQksreUJ6M2JaU1ZWTW0x?=
 =?utf-8?B?bHp1a2RVbmRSNWhNcXcvYXN6NWM3U3ovNXF5V0N2YmZKMEdzS1N2Yi9nc09p?=
 =?utf-8?B?cmVoVlphVkIzQTJuTTI1NUg2ZktRWXUzQVNOQ2p3eTZRMy9ZN2pVTnhvL2V2?=
 =?utf-8?B?N2U5dFdWTFIwZkM1aklNdkZQMTQ2TDF2S3kzWlJwRGFTQUMxUDg5Y2tLVGJm?=
 =?utf-8?B?aGpHNUROWEZ0dTk2R2tMN2RFYmd0V241Ymh5ZWphaGFMckQ4ckdSWE9vZ3R1?=
 =?utf-8?B?WWRmMkRadFZuM3Nsc1VVWDg3YitNRmtVR0F2UjcwUU95M3Y0N3RPKzlkblFa?=
 =?utf-8?B?NUJRWUFoeXJEc2IwRnNSRnFSWVkvRmMra3RPNk1ucWVwcW9rc1FxeUZoSEpk?=
 =?utf-8?B?b3RieUVQakR3N0RFVTMxOFBYdGc3Zlh6TnF3b2J3YzgrUXM5NFA1RFN3VHhG?=
 =?utf-8?B?WkVxK0FrTVRMQlJ5dlhVN0dnMWkzZ1BaOTROMlZUREFXb0lHbExwRGJQSnZn?=
 =?utf-8?B?VjJkeUkxc0tadUw2Mkt1TFFQTnVHWmFrTEVxeEJBRzhmOUtHeHZqaGFQWUc3?=
 =?utf-8?B?OUNsTWdmWlBhaGNTMXU5NEdhTWZnWjlLTkIzdllyL3RWaXdaQ3NzNElpbDBh?=
 =?utf-8?B?WnR6azNqcnRIZ0theUpFOU9Cb1FIcEFnZkM5QWJNUXJBaUtqR09YSzJJNS9S?=
 =?utf-8?B?cTZOZ1FrZUR4cVlPaytwVkxkZ05LR0MzYll1eittK05RVmpQR1R0KzVVdDBM?=
 =?utf-8?B?NnZ6YjBRS3c3a2xqYXhHeFBQUlVvT1NHM203bUFPQ1lDdkYrazZSdVFOdjh1?=
 =?utf-8?B?Z0hmN09wd0pQYTMwT2VGSUVmS0VobHQ3SGlPcmIxaEtiSmtENitVb0xIR2JN?=
 =?utf-8?B?WjY1ejRpRUVXWVhqZXNpYk50UXZKb0RpWVRidWRXeUpIckJtTUtraHVIc2dv?=
 =?utf-8?B?MFVVdjJ5K2E4bmg4K0Q0d0RnaUpqOXovV0lNb0pWWGp5TC9GbFo0Y2dsaVZn?=
 =?utf-8?B?eGRGQWFXbjBTTVFCTEJTVHZtZnIrc2lnRFZnbnBVK0hydnF2NGN3cWFoOEdC?=
 =?utf-8?B?V3Z4NXNOL0crVDBJOWNncHliT2hpZzVtQW9Id2I1d2dPUmV6MEJGekNWVjIr?=
 =?utf-8?B?TUdocE9wZzNhMEt1dUIrVG44RlJYSjdSc3F1ak4yUWZ0MnF4ZTYwdEwxazdI?=
 =?utf-8?B?UlY4SlJ1TjdESWhzZnl5aU5yWlAzd1g2OCtmWTRLRHNQVWhLcWgxdERTMm5Y?=
 =?utf-8?Q?7uL0vlCc6X07zILDlBvjD8LD8K/7SXXR?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Vlptb3BQbkdKTWtGOU1NZHVZTHVPMFZlSnkrRDhteElHVGd0WUJ5bUk2TU9P?=
 =?utf-8?B?cHVQbzdIUTg5cEN3elBmTk5kVmIrSHBlMEFMamlpcUxMVkh1K0hCaVY2UDhr?=
 =?utf-8?B?THdYNlJFdHdjVStZQlpCeGtFclN0N2J4ejU4dHJHQWNhYnNaa1IwQkw5MEEy?=
 =?utf-8?B?d2RwRlJlY3RDWU55Y3BjbFdPQmt5aUlROFlydlRPNVFWMzhJYUt5aEh5N2hM?=
 =?utf-8?B?ZWNzZVBMck45WndTUm1tWGRPblFHUzA4dzBkUHh2VlNrRVBtblVLbE9QWW1H?=
 =?utf-8?B?dVc5ZTcvOUt3KzB6c2hsaEVPS0tUT1lEZittejdnNkJwcTVDUlZkdDhnR1p6?=
 =?utf-8?B?NXlDempvZEpCdU55bUN5YytnWFBueThlUDNNcVhvNDhLU2FoK0EvdjhsTUVj?=
 =?utf-8?B?bnljcERIUkp3Z093SFQrdGlHWVZGczFvZERabEc1eHFkVkJPMGtROTduZ1ZG?=
 =?utf-8?B?UXRUbHJRRFR6YUF0QUk4cEN4UDNMSmVKaG4weGRYWU9xNktsTEc0KzVydWdv?=
 =?utf-8?B?NTJtTHpybnU0YWRPdThZTWhDN1R6R2s0MEJqcUVtS0F5ODJreFdrKzJLcXRF?=
 =?utf-8?B?TXhvRWQ4NkUvaG5oRGp6L3lKMm9WZEVpUjh5TmxWckVNbDhFaktlNU1DcUxT?=
 =?utf-8?B?aXlsNi9zcEx0aFJ3bWFFdEREdS9ab0I2NW94L0NKbDRVTDY0K245d0p1cUor?=
 =?utf-8?B?Uk1CNkY3TUlic092Y1pjaUUyOWZYY0c5MHpXSUxPZkF0NG9aUG9HTzZvYnVh?=
 =?utf-8?B?UFd1dXU3U2xmVVd0SGRQcjI4V1B6cHRMMHlLaUc4Q2hoSzByRlk2ZXZWQzZz?=
 =?utf-8?B?OFdYWGtXckRsdzEySm5JQ0d4bm5mM0pEam9EYVpPVGpQU05MbWxyZlNCbldN?=
 =?utf-8?B?c1BSaCt0VUU3UXMwYkpKbVJyQktMQXlkVXVJSE4vWCsza0VFVDBCaHk1SmV4?=
 =?utf-8?B?RGhVaUZMaEpYOExMNFpIYTFXM3BCdGJmSnNwUEoxMTU4UDhwUlFXaHZHQmZO?=
 =?utf-8?B?cGxtUVh0UTB5ZHo4MmVQMGMrRC9FdERuS1Zvb1N6ZGtnUVJLZGkzMEIwVFk2?=
 =?utf-8?B?WWM1d3pYMElldzAwMkxjNTg5MHpKdGpVa0M5QU9YbmNXbXNvVGxlQkFPWUw5?=
 =?utf-8?B?YUtESUF2U2swT3FMdkZZTHg0USt1cFpHb2l0WjFJNlhTUGJkaklOamFKSEJE?=
 =?utf-8?B?aFJPUlBVdGYvcGtCTDVjSERhUTdGVkgxY01TUlNoMEcwMkxqaUxTeGh0REcr?=
 =?utf-8?B?TzZBcHVHOW5vRXE3M0hOVytsY01pK2syUlNaeEcxcnI0bnJKMGx6NktoKzVY?=
 =?utf-8?B?NFBJS3JNZjlrRFJ1bmRJdVYwakRkTkpuano1b3BtZkRFS3JtNGdJVWdNZFFQ?=
 =?utf-8?B?c0crN3FYZlE4N3lOMTB1aUx2c3ZOSXdiVDNucVB1aGhUOFdlcy84MjVsSSt1?=
 =?utf-8?B?UU83ZkswbkQ1QjNheXBUU0tBREhYQXNkRnBkblp2bnBCTVZhQzduU2t3VDF2?=
 =?utf-8?B?czZkMlJZZDhkT3FyMWR2ck85SnJKSlNYL0cwWlJrMXFQWEVnM2F6ek1sNi94?=
 =?utf-8?B?bGY4QnV4VUdsZFZQRnQ5dElidit2YUgxL09RNlF2OUd0QVYvNDZNZnVoVCtI?=
 =?utf-8?B?K0VCWHAvR1ZrcGUyeVZnYTBiWG9scVRuMjBPa1psNGluQ2Qyck9SQVhMZkRl?=
 =?utf-8?B?U2tpWkY0cjF1K3E1elFUMDNNSnlzekVtbUQ5YU9EMmQxcDZiOFh0VE56ZHlQ?=
 =?utf-8?B?L09RTHRLVFR4VCtvc2puV1dtdy9sdndZOFlhYXQ4MDlXMzZoeDV1M1pqQ2pT?=
 =?utf-8?B?aVF1VlFidUpmajRaeW1xVFBQcVNzUis5U1lJY3EzY1E0R2h4Q3MyUHpianFP?=
 =?utf-8?B?bHZ6Qnlya2xMemllRFp2ZEhTbzBLa0x1SFNabmR3NEVBL1dRVVBxbmpJMEpT?=
 =?utf-8?B?T01oU0RkV0FCY3dySUFoRDhTeGsyUlJGNnI3RnJnNlZzdFg1bzVQRk9yRTBI?=
 =?utf-8?B?YklaNG1CZW56YkZjbWRTUnhxVHFjNmpYRlNhRHp1cG8vbDFaQ2Y5NVIwbzZT?=
 =?utf-8?B?N1V3T3FpclhqUDVGblJuRm9BYVpVaHV2LzBReEJkUm9aSTl6dXkzSTE3azhj?=
 =?utf-8?Q?ijOkYMkzoNmfj2RsD44W6FuaF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89504A153E20424A9FEB06A4700DB200@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dbd4f6-1a6e-4393-e7e7-08dd2fdaaba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 11:50:38.5320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLvOGCBussGhaTBdmTqcF3Xizdapntpiv/0gm9X53rf9RyDFiY771SgAuWEsv7999KbbcsDxsBZ0saFTKcN5iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5975

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE1OjAyIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVGh1LCBEZWMgMDUsIDIwMjQgYXQgMDQ6NTM6MDNQTSAtMDgwMCwgSm9zaCBQb2ltYm9l
dWYgd3JvdGU6DQo+ID4gT24gVGh1LCBEZWMgMDUsIDIwMjQgYXQgMDM6MzI6NDdQTSAtMDgwMCwg
Sm9zaCBQb2ltYm9ldWYgd3JvdGU6DQo+ID4gPiBPbiBUaHUsIE5vdiAyMSwgMjAyNCBhdCAxMjow
NzoxOVBNIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToNCj4gPiA+ID4gVXNlci0+dXNlciBT
cGVjdHJlIHYyIGF0dGFja3MgKGluY2x1ZGluZyBSU0IpIGFjcm9zcyBjb250ZXh0DQo+ID4gPiA+
IHN3aXRjaGVzDQo+ID4gPiA+IGFyZSBhbHJlYWR5IG1pdGlnYXRlZCBieSBJQlBCIGluIGNvbmRf
bWl0aWdhdGlvbigpLCBpZiBlbmFibGVkDQo+ID4gPiA+IGdsb2JhbGx5DQo+ID4gPiA+IG9yIGlm
IGVpdGhlciB0aGUgcHJldiBvciB0aGUgbmV4dCB0YXNrIGhhcyBvcHRlZCBpbiB0bw0KPiA+ID4g
PiBwcm90ZWN0aW9uLsKgIFJTQg0KPiA+ID4gPiBmaWxsaW5nIHdpdGhvdXQgSUJQQiBzZXJ2ZXMg
bm8gcHVycG9zZSBmb3IgcHJvdGVjdGluZyB1c2VyDQo+ID4gPiA+IHNwYWNlLCBhcw0KPiA+ID4g
PiBpbmRpcmVjdCBicmFuY2hlcyBhcmUgc3RpbGwgdnVsbmVyYWJsZS4NCj4gPiA+IA0KPiA+ID4g
UXVlc3Rpb24gZm9yIEludGVsL0FNRCBmb2xrczogd2hlcmUgaXMgaXQgZG9jdW1lbnRlZCB0aGF0
IElCUEINCj4gPiA+IGNsZWFycw0KPiA+ID4gdGhlIFJTQj/CoCBJIHRob3VnaHQgSSdkIHNlZW4g
dGhpcyBzb21ld2hlcmUgYnV0IEkgY2FuJ3Qgc2VlbSB0bw0KPiA+ID4gZmluZCBpdC4NCj4gPiAN
Cj4gPiBGb3IgSW50ZWwsIEkgZm91bmQgdGhpczoNCj4gPiANCj4gPiDCoA0KPiA+IGh0dHBzOi8v
d3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9kZXZlbG9wZXIvYXJ0aWNsZXMvdGVjaG5p
Y2FsL3NvZnR3YXJlLXNlY3VyaXR5LWd1aWRhbmNlL2Fkdmlzb3J5LWd1aWRhbmNlL3Bvc3QtYmFy
cmllci1yZXR1cm4tc3RhY2stYnVmZmVyLXByZWRpY3Rpb25zLmh0bWwNCj4gPiANCj4gPiDCoCAi
U29mdHdhcmUgdGhhdCBleGVjdXRlZCBiZWZvcmUgdGhlIElCUEIgY29tbWFuZCBjYW5ub3QgY29u
dHJvbA0KPiA+IHRoZQ0KPiA+IMKgIHByZWRpY3RlZCB0YXJnZXRzIG9mIGluZGlyZWN0IGJyYW5j
aGVzIGV4ZWN1dGVkIGFmdGVyIHRoZSBjb21tYW5kDQo+ID4gb24NCj4gPiDCoCB0aGUgc2FtZSBs
b2dpY2FsIHByb2Nlc3Nvci4gVGhlIHRlcm0gaW5kaXJlY3QgYnJhbmNoIGluIHRoaXMNCj4gPiBj
b250ZXh0DQo+ID4gwqAgaW5jbHVkZXMgbmVhciByZXR1cm4gaW5zdHJ1Y3Rpb25zLCBzbyB0aGVz
ZSBwcmVkaWN0ZWQgdGFyZ2V0cyBtYXkNCj4gPiBjb21lDQo+ID4gwqAgZnJvbSB0aGUgUlNCLg0K
PiA+IA0KPiA+IMKgIFRoaXMgYXJ0aWNsZSB1c2VzIHRoZSB0ZXJtIFJTQi1iYXJyaWVyIHRvIHJl
ZmVyIHRvIGVpdGhlciBhbiBJQlBCDQo+ID4gwqAgY29tbWFuZCBldmVudCwgb3IgKG9uIHByb2Nl
c3NvcnMgd2hpY2ggc3VwcG9ydCBlbmhhbmNlZCBJQlJTKQ0KPiA+IGVpdGhlciBhDQo+ID4gwqAg
Vk0gZXhpdCB3aXRoIElCUlMgc2V0IHRvIDEgb3Igc2V0dGluZyBJQlJTIHRvIDEgYWZ0ZXIgYSBW
TSBleGl0LiINCj4gPiANCj4gPiBJIGhhdmVuJ3Qgc2VlbiBhbnl0aGluZyB0aGF0IGV4cGxpY2l0
IGZvciBBTUQuDQo+IA0KPiBGb3VuZCBpdC7CoCBBcyBBbmRyZXcgbWVudGlvbmVkIGVhcmxpZXIs
IEFNRCBJQlBCIG9ubHkgY2xlYXJzIFJTQiBpZg0KPiB0aGUNCj4gSUJQQl9SRVQgQ1BVSUQgYml0
IGlzIHNldC7CoCBGcm9tIEFQTSB2b2wgMzoNCj4gDQo+IENQVUlEIEZuODAwMF8wMDA4X0VCWCBF
eHRlbmRlZCBGZWF0dXJlIElkZW50aWZpZXJzOg0KPiANCj4gMzAJSUJQQl9SRVQJVGhlIHByb2Nl
c3NvciBjbGVhcnMgdGhlIHJldHVybiBhZGRyZXNzDQo+IAkJCXByZWRpY3RvciB3aGVuIE1TUiBQ
UkVEX0NNRC5JQlBCIGlzIHdyaXR0ZW4NCj4gdG8gMS4NCj4gDQo+IFdlIGNoZWNrIHRoYXQgYWxy
ZWFkeSBmb3IgdGhlIElCUEIgZW50cnkgbWl0aWdhdGlvbiwgYnV0IG5vdyB3ZSdsbA0KPiBhbHNv
DQo+IG5lZWQgdG8gZG8gc28gZm9yIHRoZSBjb250ZXh0IHN3aXRjaCBJQlBCLg0KPiANCj4gUXVl
c3Rpb24gZm9yIEFNRCwgZG9lcyBTQlBCIGJlaGF2ZSB0aGUgc2FtZSB3YXksIGkuZS4gZG9lcyBp
dCBjbGVhcg0KPiBSU0INCj4gaWYgSUJQQl9SRVQ/DQoNClRoYXQncyBjb3JyZWN0IC0gU0JQQiBj
bGVhcnMgdGhlIFJTQiBvbmx5IHdoZW4gSUJQQl9SRVQgaXMgc2V0Lg0KDQoJCUFtaXQNCg0K

