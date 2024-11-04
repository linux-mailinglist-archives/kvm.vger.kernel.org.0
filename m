Return-Path: <kvm+bounces-30556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 491DE9BB86C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 16:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAA5A283F67
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 15:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7151BC062;
	Mon,  4 Nov 2024 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A7vRpaHy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78591F60A;
	Mon,  4 Nov 2024 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730732426; cv=fail; b=cqLJTHKaNC/3JDnqZtlwWsezkhi3Sx0PxPCWTS8VghUsjaRgXglE5OK8bN0a84fUTRyFlFGkHcKalr9CzXHviru6RSxLW1seEd1+G5fDIAIKMMeC+o/X+aqKMWBvVbEfTVYZHEB0KBHHuvRiI82oTQ6KNEfSoHMtfxuAj5QM6X0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730732426; c=relaxed/simple;
	bh=XZemMTIY0WUnzM1iRvdSSV6Kj1Oz5GoIlpnha2Bo9Pc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iEGgO6WPM1bF3rHpf/dbRc77Ddht7Q/dOBoeEB9BKSnSivFNQ3qCsrtPxqPs2SEsENjfKoh/Yk4kyiKzAVgS2ryGoFsDfnBj0Ob/5FHd+xyfnakpeqDx6gfjR7zhUsbHaX4yYSW9TEu+JlsgsZD04R4HVxSb7fEEMWue7tcnq+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A7vRpaHy; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfbVollayi0yZzZAx9kVGrjH/IDBiWFB47YgfN6u9r60NKFXdmSDkNpfnwCEPSnUVuJ7K84QCLJqVnZaBJ/mo328Kah1a5gbn7GdUTWxOvNaoBH9BNq01jD26H61d5Bg5SiSb3NUT0rNPrMd/hSuFp4W8WUrrMsRU5e16PsQ8702eJ/leeUhNuVUba4lfFexgMtll1Vq2Q3HfhYBx+ZaWvxBsiD5m4Q/CnUF0R56Oa4i++qgpnnURaaETgV2TeHcQM0MgZokQZEiz1jsX8bGSdhiVPK45/auEn0vEt4rIz91eurKiDTxSz9b2zIZ2gcIXpzlGHn/aoZvhclIChSAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZemMTIY0WUnzM1iRvdSSV6Kj1Oz5GoIlpnha2Bo9Pc=;
 b=lA88fRhUS2N9Md5Xpy0DLhzG+1PhmSvidaLfFXf+P6ey8Nem8DXgFuCnvFwZHJuWky+SoTLUTeIx6VoPBbwuswyzmJHKOUAS8OcSaoM+3bwqkvcw6Y5Y2PR1UMKWpoBk7rhvBnzCFrGH8nuth1QLBb29kf6ija9GaL3GseSz/hjjcB+ugeUWlQrkwq3mokGERTNIkNeg4TRVxUMeQeA25eMz9+hqh6WbEZTw3ld3nbodM+yLfZOb/HiK8eHneWuQZFhvvVn22sES00bQIVrDEHvBfMYFJub1hqIu+6ge752zDrI3eAHy14Zl3gdm/uwRwNqzrgGcbhAEgUyOkt/vzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZemMTIY0WUnzM1iRvdSSV6Kj1Oz5GoIlpnha2Bo9Pc=;
 b=A7vRpaHyWJ0jNSrGQF83iRLGbTBXME6/W69pcPU9UFiHGjN+X0TxshAhwoYms+YRXW4C8wpCG9LTXRiimR4veLTiNLKyRS8RJjV8dXeYA25W1bpeoq4XYL5lftPHN4Bh8r2l+7tzqKbSsaJOvCA/memygnfoWDyuvmgowUc9GAc=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by DS0PR12MB8343.namprd12.prod.outlook.com (2603:10b6:8:fd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.30; Mon, 4 Nov 2024 15:00:19 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 15:00:19 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"Moger, Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "Kaplan, David" <David.Kaplan@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Topic: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Index: AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhevwAgAVc0QCAAGNIAIAAAhgA
Date: Mon, 4 Nov 2024 15:00:19 +0000
Message-ID: <bbc3dfd40ab27bd6badbafddd88d10cbe29fd536.camel@amd.com>
References: <c3fbf18a4ec015039388617ed899db98272cf181.camel@amd.com>
	 <e9711ae1-b983-4f3e-89b4-513db62e4eef@citrix.com>
In-Reply-To: <e9711ae1-b983-4f3e-89b4-513db62e4eef@citrix.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|DS0PR12MB8343:EE_
x-ms-office365-filtering-correlation-id: 9f6ea741-c5d9-492b-4426-08dcfce16655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZVVIdDYzVkVsUEViSG1BQkZUWElwdFpZZzE0K3Y4cE9abXVqMmptSFBBME45?=
 =?utf-8?B?dDlUdCs2M0UxeEZ5WHc5SWJpTjhXSUxZazluaTFxZ3dLeHFzWkUwK1F3R1Av?=
 =?utf-8?B?UzJtOTdBb1ZXbVkwU2FqM0JJd1V3N014Z1lRdCsvdndhMHB3dm56ajk2SnFv?=
 =?utf-8?B?T0lOaXpYZ2Y3K2VTNEV0UkdHbm5JZ1JvSnB3WnJ4NlFLeEpyMlI5Vm9wTmxv?=
 =?utf-8?B?ZGRxZEhjSGw3ZlVnckZMT04vRjBKeHQvQ1NMc2tIN1BwZ0hXV3R5UkwwS3JN?=
 =?utf-8?B?SkI1R1ZCT2ZWSUdSc2tXbGEyRlRpS1BmTzVOTFBQZ0xaa1BZMHF6WitSMWJ3?=
 =?utf-8?B?NTNYNVZya3NUODN2dnZOU2xjdFd2NGVZWG5RMnp2ZWJxQm8vSTlZVDYvNklx?=
 =?utf-8?B?cEJMU1B0N3ZkQlI3L09oWGRHWWc4RFp6cUkzeloxRmNPRm1sTEFKSmhCZllM?=
 =?utf-8?B?UFByMkN2YW9VUEdqTFNSeGhhZHpGcDJFNEFPd1IwNThoRm9udXc5KzR0cFQy?=
 =?utf-8?B?WWVjWDRQTm1yK3dieE1nQS8rWmVhcHI0a01iNmpWbXFpb05QN2taYkh6bGho?=
 =?utf-8?B?M3ZodE5ya1RIMXE1Y2FYTlgxODVpZ01CM055N2NCOFhaeUcrdmNmRENTVzlp?=
 =?utf-8?B?OE5FV3VFUmh3ZENjSWlxSVYySHRxOURRWURMOWRBRUJwcW00MjJRMEQvTFNk?=
 =?utf-8?B?V3UxbC9CQVREMlVvOFBUZXZwQ2dWUGMyL3NUTTVtNm52eVJ4MitPQ2o4VkpY?=
 =?utf-8?B?d3pkTWdHS3c4QWE0djdxdVAzNCsrSXdFaWEzK2lnTUordG90VXNTTmZQV2pV?=
 =?utf-8?B?VUovejh4eG9MRDVEKzVnU1B4ZlZwdGdHNHdXbWxIL3owc0dWNGc1ZGNIL0NK?=
 =?utf-8?B?a0FETFVocmJiUnZuOGhrYmFrYVFuamMzaWZFSzJLOXpBNWh3KzdaTDhlZ1JI?=
 =?utf-8?B?cFpROHFVUVBzbmRUbE11eHFrYTJGQlcwYitaUVc4T1NEMSt5aTNuU0gyVVhh?=
 =?utf-8?B?Rzg3bWQxcTZtVkNBMEZ1dTkxOE16bURkSnJHN2ozLzZnQ3BUclFWZ0NoMzRw?=
 =?utf-8?B?VitBelNwbmRGcUdzV3ZvUGtsRytFWmpnUUNlTm9jb1JnSExla2ZRSWpIbWNs?=
 =?utf-8?B?ZUoyTTI3MzJkUnU4RzFaa3B4Sks0S1J2L2JaaHR4cUNTMm50U0F2WktndEoy?=
 =?utf-8?B?eXY0L0FHYXVpemg2ZVBYNGg5S2FVdnBJb1JWTGdKN3d3ZEtpNnlFQkkrOUJx?=
 =?utf-8?B?UmxLVFdDQ0dUTzBNZ0tyNENSb0puWWhXSkxsdGdXTmo3K29zQ00wbmpvZDNu?=
 =?utf-8?B?Q2pBSEhyYzNoZXgwcGRTY1lUQm1KTkcyM3l3c2t3ekpsTEQ1YjQ0aURIa3Rx?=
 =?utf-8?B?SnFNSEZGNkNGU2xxMHovMGRrbHRoNVo3OU1zVklRWGJJeTJrN0lMVFBLamth?=
 =?utf-8?B?cUplbWU4QXV6SlJLaDhvd0YzMTFyM3NGdzVwY2xxWFpwVFdEZmNZOWRJQVRQ?=
 =?utf-8?B?WDQwd2NYLzE5dzJ2RkNENEIxbEhJZ0p4OFhrWkxqK3NJSjFWVUlmVGVyZW90?=
 =?utf-8?B?R0ZCZ0p5UnhiZVFZa3MzRk4vNi9VYkc5NEFVamIzekh4UW52c3QyRktPaFNm?=
 =?utf-8?B?Syt6bGZUN3lZQ1NLOVpyYXJFSzdzbVAyaVhudXZ0RWZ6SE5DVUMzQ29BRzJx?=
 =?utf-8?B?UmkyZTlyTEs4dmdhZTE4WFZyYXhGdTY3b3VWMmJMcWpGMXQ3cjB3YUFrK3VT?=
 =?utf-8?Q?eBbCs6FTJxUSpK2Qe8w5gKaMBhay28m4H5pbJrw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWRCWHFIVFVvM0JVYmhGZGlVeWFQOHhJcHZvWm9XYzJIb3U0dHBISExyeEpv?=
 =?utf-8?B?ZHhqSFNMUWN3Rmw4OFN0NGJRc0MvZldBd1lKalV1eit5aVJFdVRmalRJR2lL?=
 =?utf-8?B?SVl5OXNyVXdVSFJYbGtuaU9WRkpZMjc4aXlJaDRGSUdiNFcrWHluTVI0SHl0?=
 =?utf-8?B?cm5icGpVaUp1UlUvL0JwU3pHNlBFeU52ak5PZmpmMUg0UWsxY1JYVWU4OVBm?=
 =?utf-8?B?M1lzQkVHQ3hyUWQ0ZjJueFJpNVkycmg0ZndoOGdCdGdNTiswTEhZQWQ1UjBw?=
 =?utf-8?B?b3FrbXQwRlpaY1pQWmp3bDF6VGhsczJzZStkZFUxVE85cy84Skg5V1o1Qy9S?=
 =?utf-8?B?NTg2OE1FWE8vYi9pQ0pEaVlWdG12WmpkM1UrblYyVXhSVndnZklldm53MUFz?=
 =?utf-8?B?WVRxRTNNaCtSME8vSUlCMDlwejN2cDBsR2ZPSng0ZlRwVTFtd0NNUUFHTUN4?=
 =?utf-8?B?aEZtVllpQUFDbnJMdkNKOEFzWW5aUVhYNDJVUU1iL0xwUGhTNnBhbUQxbTg4?=
 =?utf-8?B?RGwvNTVXWU5HVk5LMFUrcUN6VjNJUm5jR2trRW1LOXlMRW9OZVI4a0RzRnEy?=
 =?utf-8?B?KzRPVmd5bWlsaTk1Y3Nld0pYS2JLR1Z3SlE3WnQ0OXo1UTJ5RUN3bXorK1Av?=
 =?utf-8?B?U3NHVVFKaU1IVEhucXFzT3pvbWZrdWZ6MmZjNithVFFWODR0TEVPV3dlN1VP?=
 =?utf-8?B?MmxIV0JSOWl0aFgyT3BPMXY1dmlESU9JVi9KdFBWVjJUTXlCMEhBd2dUbUpD?=
 =?utf-8?B?TnkvQkVHV0cyalh4TWhTK2h3eVZTeWUyVjRXanB5UzUwMitxUzZQLzBwVXpz?=
 =?utf-8?B?d1hxVUI5SjRPa0oyOEtpZk9VNmhBSzhuaWVDMDBENVpwT255UW5UN2p2eldo?=
 =?utf-8?B?Mlp1VVJqQ2d2SEwvdEFkRDgrS2pxMUdpdm1YZUlBSjk3TGRZc3k3WUxtWnZi?=
 =?utf-8?B?b1c0d2J2Nmp1WTB3QVljcnRYbEdYWWRJTTdFbi9CSGd2K2FrT0FIV3J6Mjh3?=
 =?utf-8?B?b0JISklLRjZXeHRrUW03K2FUSmxGN29vSHhRbWtVZ1diNW5KOFcreURTN2Er?=
 =?utf-8?B?MzAvbENPMk9ubmdWQVJRc2lIWGhqazBmdy85VmNQbTEzeUt3M3dXUlp5TVhk?=
 =?utf-8?B?UXN6K25ZcEZ1T3g2cGZ6NFhSZ0NSVzJxTWVRSnpYVDZHSU1RYnFIcnhGRUtu?=
 =?utf-8?B?aHo2MFV3bm5JQWpXdHZzaVpnZjBmVnpaTFRDUFA1MUlPYXZzVUplSUlCOVQr?=
 =?utf-8?B?aU5NOXNzM2Vaamo1cDBhdDdyMXZnRFZWRmdyY2VGcGZlUE9hL0cwL0RmdTNi?=
 =?utf-8?B?UjA5VGZFU29vZ0Jha1cvZnVnc2FXQ2JSdlVjMWlkcjAzSk1nbktBT3JmcTlw?=
 =?utf-8?B?L1VTNEFFRG5aRkE5WGUzLzRRc2xYRC81U0ZSVFFJb2ZwRWhuK1NnV2JBZ1Fr?=
 =?utf-8?B?aXQ5cldsNDBwNk45Y3V0RzRJTlpRMCtRcmxiQ2tTMm1odlRMbE9LZXpxQitq?=
 =?utf-8?B?U2pnOS9oZTdOcUNkUm9iSjdjTHQ3UUd5ZUt1OWthVjNPaXg0cndCMFFjRkZz?=
 =?utf-8?B?R1BXREZTQUVPU25kRWVVcnBsME43amhBNVZ5UDhYTTR0ZC9naWxUNmFkMmo1?=
 =?utf-8?B?WmRLSGdLeUR0aTVyb1JnSHJ3R2UrdmQxUlBBRlUrYlROTDZ1QVpaMXlrZ2w3?=
 =?utf-8?B?L3p1bEVxRm44VTFIOUluWHpvdXhlQVRsMDN4SDNodldiRnZLZEovZFdmOW9K?=
 =?utf-8?B?SUc3WDdXajc4Ry92c0VIOG95NE5KU2w1eDI4ak4xVG9JRkJObFVsTks4MnFT?=
 =?utf-8?B?ZXZqUDdvTUh1ZUxIRk90Sjl0TUlrSHAvN0FvendwVWZJbENCSFJSaW9XUUk0?=
 =?utf-8?B?S0M3TVg0MTNEYWM4VGpkNCtZbk5KRXU5VFFqZEVKOUUxcDhLSWtCZHZaSVBx?=
 =?utf-8?B?MUhCSk9PeW1MbVQ0eWwzblY3L0ZKMHZ2TS9nSkxMTHA1ZDJjZWFMOU1xS2Vu?=
 =?utf-8?B?VFJ0VUxYd0k1M1BhREFHM3c0c05JOFZlV0lvcEpCWVJHdldBeUVXM21hbGVm?=
 =?utf-8?B?N3hDSXpwZ1c1YS9FN2R2TW03cjU1bFBLbklTQ3dsblhRSTBrdWI0WnJVWmk1?=
 =?utf-8?Q?fVuB6T4gE0XyzQHVH7kNif6f6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E288B779F7E434898BA158774118E95@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6ea741-c5d9-492b-4426-08dcfce16655
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 15:00:19.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GsFEEVx2a2nUN0nvyA3NrNkESADK79YOykr0ODQ6oqOFPvyL7OPi+ql5clCeUGSAUUjTLsFpBMiN87XLDuRrfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8343

T24gTW9uLCAyMDI0LTExLTA0IGF0IDE0OjUyICswMDAwLCBBbmRyZXcgQ29vcGVyIHdyb3RlOg0K
PiA+IFVuZm9ydHVuYXRlbHksIHRoYXQncyBhbGwgd2UgaGF2ZSByaWdodCBub3cgaW4gdGhlIG9m
ZmljaWFsDQo+ID4gZG9jdW1lbnRhdGlvbi4NCj4gPiANCj4gPiBJJ3ZlIHB1dCB1cCBzb21lIG5v
dGVzIGluDQo+ID4gaHR0cHM6Ly9hbWl0c2hhaC5uZXQvMjAyNC8xMS9lcmFwcy1yZWR1Y2VzLXNv
ZnR3YXJlLXRheC1mb3ItaGFyZHdhcmUtYnVncy8NCj4gDQo+IEkgYXBwcmVjaWF0ZSB0aGUgYXR0
ZW1wdCB0byBnZXQgYSBmZXcgZGV0YWlscyBvdXQsIGJ1dCB0aGlzIGlzIHZlcnkNCj4gY29uZnVz
ZWQgb24gYnVuY2ggb2YgZGV0YWlscy4NCj4gDQo+IE1vc3QgaW1wb3J0YW50bHksIHlvdSd2ZSBk
ZXNjcmliZWQgSW50ZWwgUlNCIHVuZGVyZmxvd3MsIGJ1dCBuYW1lZCBpdA0KPiBBTUQgQlRDLg0K
PiANCj4gIlJldGJsZWVkIiBpcyB0d28gdG90YWxseSBkaWZmZXJlbnQgdGhpbmdzLsKgwqAgSSBi
ZWdnZWQgdGhlDQo+IGRpc2NvdmVyZXJzDQo+IHRvIGdpdmUgaXQgdHdvIG5hbWVzLCBhbmQgSSBh
bHNvIGJlZ2dlZCB0aGUgeDg2IG1haW50YWluZXJzIHRvIG5vdA0KPiBhbGlhcw0KPiB0aGVtIGlu
IExpbnV4J3MgdmlldyBvZiB0aGUgd29ybGQsIGJ1dCBhbGFzLg0KPiANCj4gQU1EJ3MgQlRDIGNv
bWVzIGZyb20gYSBiYWQgYnJhbmNoIHR5cGUgcHJlZGljdGlvbiwgYW5kIGEgbGF0ZSByZXN0ZWVy
DQo+IGZyb20gdGhlIHJldCB1b3AgZXhlY3V0aW5nLsKgwqAgSXQgaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCBSQVMvUlNCDQo+IHVuZGVyZmxvdyBjb25kaXRpb25zLg0KDQpCVEMgaW5kZWVkIGlzIG9u
bHkgYnJhbmNoLXR5cGUgY29uZnVzaW9uLiAgVGhlIHBvaW50IEkgd2FudGVkIHRvIG1ha2UNCnRo
ZXJlIGlzIHRoYXQgdG8gZW50aXJlbHkgZ2V0IHJpZCBvZiBYODZfRkVBVFVSRV9SU0JfQ1RYVywg
SSBoYWQgdG8NCmNvbmZpcm0gdGhhdCBBTUQgQ1BVcyBkbyBub3Qgc3BlY3VsYXRlIHJldHVybiBh
ZGRyZXNzZXMgZnJvbSB0aGUgQlRCIG9yDQpCSEIgc2luY2UgQlRDIHdhcyBmaXhlZC4gIChPciwg
aW4gb3RoZXIgd29yZHMsIHRvIGNsYXJpZnkgdGhlIHByZXZpb3VzDQpjb21tZW50cyB0aGVyZSB0
aGF0IHNhaWQgdGhhdCBBTUQgcHJlZGljdHMgZnJvbSB0aGUgQlRCL0JIQiBpbiBldmVyeQ0KY2Fz
ZSkuDQoNClNvIC0gdGhlIG9ubHkgcG9pbnQgaW4gc2F5aW5nIEJUQ19OTyBpcyByZWxldmFudCBo
ZXJlIGlzIG1lIGNvbmZpcm1pbmcNCnRoYXQgQU1EIGlzIG5vdCBnb2luZyB0byBzcGVjdWxhdGUg
cmV0dXJuIGFkZHJlc3NlcyBmcm9tIG91dHNpZGUgb2YgdGhlDQpSU0IuIEFuZCB0aGF0IGNvbW1l
bnQgY2FuIG5vdyByZWZsZWN0IHJlYWxpdHkuDQoNCgkJQW1pdA0K

