Return-Path: <kvm+bounces-33208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBF79E6B56
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 11:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E072316AE6E
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 10:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379B01F6686;
	Fri,  6 Dec 2024 10:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="48+9ct3C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99728684;
	Fri,  6 Dec 2024 10:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733479837; cv=fail; b=qD+PnHhDk7wSpsgdTT/ZYa8rfLI6koHMUL6yEs8ME4jqWsfp3vdgqz6hmttMmwtLOAv1SbFCsbrBA/RqYv4yb1sB8LGR0RL8MYZqJuxbU4flFJ4JJo86vfEfxnebM5cB2Bmyg4K9vjwCo7vWveb0OVuaQCLpEPmGJHQIU9W2Lqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733479837; c=relaxed/simple;
	bh=KtxkvRm9Gd4OzZkwDyhsZ5LkATY766mEbdb4XMZI3so=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QFBWlsMiB6ArL1XLJHd75LQ1P9KHVSMwPLf6J87s2i9QcpcLc4wiXGaR4S1/UdKQ+xhPKA5hRHJ717D1WqTmx8la3FDgzHT6X0DgGqhwThioZka6V+r/gmgTW2YXJnVPsiBRPAgvbdsTuLe0BsGmo3DXQq5qkl2M4UZrjjQlCDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=48+9ct3C; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8QSG7Fu/skrtrpDVhP0wXc9CLMEUgg0v1E++4wvSTubECZowDXGINQhwr7v1XtbK9/96pt3POCKDlUO6y+l8MivmRcir7B6dHXWqiZwZT57ZqXkKgRqMXhDHGhnkYtVtL4X/Yrdj5SEXGhDPD+nuCvUTIqFvUHIMo1mCcgvxZEyt2+LROLlM6OQxETbz5m7UW3PtOII37lW43FQMTRi1WjYQOV+IUhHQA6LZeZvi5tk+jzWQbiCTDp+FqOmGZ84P+pYIC6HmvSDK5x27kAgEMAPpVR+sWyR9sQL+5xLvag3wKkz1SnUsG20AOr48L8ZVhcVnqMqYZwEGOxlJZkMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtxkvRm9Gd4OzZkwDyhsZ5LkATY766mEbdb4XMZI3so=;
 b=fV3WmR2IQ+FeD3BH4O9vOIh/bLbwENr5GwHyE4KMvruKtjeLWuI/k0ToXMoYQBJ/VGU/dvVG3RI5QHUgIvuknul5pV1x20CMMqXue66q1uw9WM8msbO1lmq5Xpw5lGdw73v4oopFJbcv3RfmMvPfKuz6czZ2wvY63qB/H4Y198Yr9xJ2XArpaJZbCeTNYiV+acv+vJe/yOc53Whj+GHwc4zCaF38VEXr8D5JnUKft+r6lBLJY+bgCNgxBN8yQCQzICymyM9feoyI9zgPMI1oUaTzjJ6h81wvjQIfbmGk5DeqZcneIbcM22jC94C4bTXVRMHFEyZMRZ1dUD68ZELXwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtxkvRm9Gd4OzZkwDyhsZ5LkATY766mEbdb4XMZI3so=;
 b=48+9ct3Cyg+K4qeG+2YR8XQI4fqRzSacrsqc9j/521bbFtPAS4U14b7rMegmXT/Zb8aVW1ecEK0zLe4ehIrnePwTU44TECAwEPWzWN2PcyUaTAl17nALcObPzwA6MNgQdK4NFw0Ch4xTa0t0h61bOY0oWWQYk1XehY0UDm+WD8I=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by PH8PR12MB6818.namprd12.prod.outlook.com (2603:10b6:510:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 10:10:31 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%6]) with mapi id 15.20.8207.020; Fri, 6 Dec 2024
 10:10:31 +0000
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
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Kaplan, David" <David.Kaplan@amd.com>
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Topic: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Index: AQHbPFEFmhn1AaOfa0iqMfWlRJj4srLYY1aAgACyLQA=
Date: Fri, 6 Dec 2024 10:10:31 +0000
Message-ID: <f1d0197349388c1785eeba356a26553ced29800c.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
	 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
In-Reply-To: <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|PH8PR12MB6818:EE_
x-ms-office365-filtering-correlation-id: cea2c0c6-aec9-47fa-7515-08dd15de379c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RTFwOG5zU2k0M1haSTQ2dkE2SXNUUi9UTUJsd1NqcUE4d0ZVQ0lycURFYk1n?=
 =?utf-8?B?WDdZRUlLajZjNnlZT3BrT0prU1NzbmVyVzMxK2c5cTZzTDdsZHlGQ2x5OXN1?=
 =?utf-8?B?dU5GdHo4SWI5Zm5SUWVnZTNTN2dSTVB3Y0xhTDd6K1ROb1cyamJBNUVNQ2Zu?=
 =?utf-8?B?ck1hY3FVcDloU0FBNitJQ1A3U3I5TFJ0OGM3WXZmd1YyeXpwUXNrLzZJVnIr?=
 =?utf-8?B?MDljVjRVcW9XNmZIZlRzYnA2KzBFK1VlV0NGUy90bzhoRnZ3T251czFMWWxm?=
 =?utf-8?B?TTVwMUFUUnR0ODM3WUdKVkdaTG82ZFRIL1BHbEtWa0VUUGNTQXFHa09yVU9p?=
 =?utf-8?B?eS95djV0RkxwSXV2a1l0TE5icUlPZ0ZhYXp4bFRtMkFWTHVBRjVmeWc5Wmta?=
 =?utf-8?B?ejFrUWViQVJvSzYrQkRMMVJCMjZMcHRxRmYvQk95aFNUUytSR1FvdERycWhK?=
 =?utf-8?B?emQ5VUprTjVZWG9UcElPTEpWS1JzSklmMS9uaGlJREZlek9PdUFjcFIwVHNO?=
 =?utf-8?B?ZXdMQU9kNnU1S0dJUitNRzE1VnZKNzBrSkNXTGxDNndCSjNTNkY5UHVBZ09x?=
 =?utf-8?B?SStRR21BL1FqTXFMb09aNFZVQ1dpSGVCdDlTdk85SURiN254T0FKNHgyZVdW?=
 =?utf-8?B?SHgrV0ptWHR5cnAxL1hUYWhFZVRYWEpGQTc3TGZqazduZjFNSko4WjJmRkMv?=
 =?utf-8?B?d3hXak1oMnVzc1F5ZnhEM2lOclRGU1Rkdk1pZlFhd01LUzQvMHBBUThBblRQ?=
 =?utf-8?B?NktUUEI4WDBkUHpxNS9zWjJtT0p3QnZnaU5PbTBva0NLYmRVZnNFWndKSnli?=
 =?utf-8?B?RUgybHZVQ09GR3BYQ3dVWTROT09iQ1ZreXdUbXRCNEZxQ1h3RXhXSVA0SFVB?=
 =?utf-8?B?TXIwUVhWSzVzaEM4cW9pNm1zeWpXTTYwdnV4clZncHpoWFc5VFBwOC9TUHhy?=
 =?utf-8?B?djNIUlNqMUhwL0JwaVAvVUdyeHZkSmJFV1ZuNFlodi94cjdJaWNrcURha2M5?=
 =?utf-8?B?TW5NUEUyblRsdFVoK2J0R3l4eGgyTFlBOG1xcnFzVU1DRThSTDZqYWRqY2ha?=
 =?utf-8?B?eEpVSUJEZEdXS1pJZ09LTDgrTmlhazk0RXRGSFRlRlpPNStaQTFqcFpKWk5P?=
 =?utf-8?B?TnRwNjNiS1p3cHdZa3ZnMTNNYW1TYzVpUS9scTRicVZvM3ZrNmZWTzZBNnc3?=
 =?utf-8?B?Zk9GWjN3MkJ6QWJtd0x5dTBTVkVSWDZ6NytpeWNZRXNUVnFhdFpFdkZXYnpX?=
 =?utf-8?B?MEx2SE9UZXRoYUhXOU02OGY2bWhvSm12RDZUSmRkTWw1aDFPSHAxTVRrYnFx?=
 =?utf-8?B?Yk11Mk9iVWRqcVlMNUZ6U0RWRm4raEhUSm04S20zUXBTaFNINXVsTFJJOGh3?=
 =?utf-8?B?TXZuVTNweUxXeWdXTUVEZUpjU0NpcXF6bTdFMzcxZStnamRHZ0p6aGZzVWJL?=
 =?utf-8?B?NHBOT0F4dm5IU1BIdnZzcFIyZjRNdE5uamU0VjlKQ2dMbUpHT1k0andTUnlq?=
 =?utf-8?B?L3NkcWtWZkdpZVRaVFVnZUx4eWUwNzJoaUxNQWxkSklZL25wakpWcm9KRHhU?=
 =?utf-8?B?amQzNjJjazduYmlLbllpWEtJU0VTUHBBK1d6cDJ1TzdLQVMzWUZVWWQ2V0Zz?=
 =?utf-8?B?TGdHNjF3Y0VSbGJvMGoxY29kREZuNHBRbUowbFptOTF5dlpHbmlRL1MvK1NK?=
 =?utf-8?B?WkYxczdNQjBhelNkS0hHbndORjdOU2M2NHBwUnVpaGROVElsblZwbjRKMTFN?=
 =?utf-8?B?b2VaKzc3UGhTa3F6TmF6NVFYRkJ4Tyt6NmlKc3EzelliVWNUNS9aVS9LUGdP?=
 =?utf-8?B?eDcvWDhKU2sxMDB4SGhXWmpBY1oyMDBVYXRid0l6dnVvMDNrTXgwZ0ZodFpv?=
 =?utf-8?B?Z1JwWGQyKzQ5dHNDVHJPZ291VXd1bXpsVjRlSHBOSS9mbVE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZCt5M3ZablE1VXhmd2Y0eFBidHpEZVRXZURNM25MWVhaVzF6WkdjdllWOG55?=
 =?utf-8?B?ekNtMDBFck9kNStwdzNoU1RhRUVoZVUrb25zNTRhUjloZERmMGNSTEFyK3pC?=
 =?utf-8?B?WUdMWmFnVmU0V04rcU9kV09yTTQ4R0dYdkV1RmZEU3QyWWMrd29ib244YVZu?=
 =?utf-8?B?YXpCUGIyOG5LZmhIYUxPaVJVL0lZQUtFUHZwTThrcVRCc2lEWkJRYWdMUWJ5?=
 =?utf-8?B?MWpHYW5KUndyNlFTY3BnOW8rc25GMzlkU3p0dmtvTFJYRnZlYlVCYk53NnB1?=
 =?utf-8?B?RjVPUVphMGhka25LYlVmWGJhZHUrK2ZmUXZlaW8rcHdFYW4zT1RteDltSWRa?=
 =?utf-8?B?NEhrM1dHL2wvWktpdVIrZkJDeGZwNWFjODhQbjlPZWRRSUhZa3d1Q1V4WlVz?=
 =?utf-8?B?Z0NtOXZsUWtIdFpDK0tQYkgxV1VqQkEvVGx0UkIzTkdUMHdPaXhxUEFidXBB?=
 =?utf-8?B?V25xdlpSekZ3aHd0dnhBRElGbVFocmlJQ2ZIQVM4SGowbk1weVoydlR1WlVT?=
 =?utf-8?B?eU1yNTJKYXdrY1IxOUNBTmh2M01SN3p3dXFjWTJKcS9sY3pWWjFuTlBFWWxy?=
 =?utf-8?B?ZG5pZFZDcURCQzZzNkNuejdlbHVSNU5ldFk4YlZhdTRXbVdTV2YwaU1Wbmkw?=
 =?utf-8?B?Z0tWZVAzTXNObUZFZFBLa05SODJaWXlPVmhHMmp3S0l1YXR4WXRzRE11ckNn?=
 =?utf-8?B?S0dUSTdDdzlvMjd0NTdGbVJrK3FlWUlkbDFKZ1IySTdpUXFqUjNsZ2lSNldq?=
 =?utf-8?B?d0hUd2JJVE10elV4ZjhWUHU4b0l4ZEJhZ1pncDV5Qmo5T0hUTklNTm1WZ3B2?=
 =?utf-8?B?djNRS3E5VUswbzJWOUhSRHhxWmtFQllMOWdKU080Z3hwTnVWc3RnS2Rxd1Fp?=
 =?utf-8?B?dUhEV2VZclZIVUF5Zk9TSUZnbWF5SWI2MEovZHNwMFhUSWU3cjg1TEJnUjA0?=
 =?utf-8?B?WXlyaVFCcG51dFk1eU0wTEhDWHB3OUd2Qnp5dGJ2OUNtcW95cC9XdWZOZGNF?=
 =?utf-8?B?N1d4aEpQYmVhYTlCY2hUMTVpQ1M1VG44aENNSThwUEZLejVPOGdqbG1VWGxY?=
 =?utf-8?B?bzJCNlVhUWhQTTc0MmlwUmxQbWlveVBtRCsxUDM5QlZ3YmVuNTlPcU5FK0xO?=
 =?utf-8?B?bnZhRTF3T3oybm1DRkVudzFsSnhtV1NVbEM1TlJmSFEzczZsbzZkYUZtazRS?=
 =?utf-8?B?VGpZNkxrNGxpTzVTL2tyeVhFNjFGczdtT2dsMWdBUzV3M2pOWDljWStBakcx?=
 =?utf-8?B?ODBKQStsRklvMVIxN2psYWRTaFlISUY2ck80eDZMZlFubzlTQ0ExNjN1R2FG?=
 =?utf-8?B?ZTk2Mkx3ejI3UVhpVTdwQWhMcURJYlY1NkkwZnhuNzJsd1ZzZjdmUXRvTkdN?=
 =?utf-8?B?QXp5V1pUYUgwdjRYcEpYNjAvVyt2cXVOaHhpOEx0cWNZWWg3T2ttaUtaeldv?=
 =?utf-8?B?aHcxRS9RQXcrT2hpWjZwc1RHL1dyeHkwdHRkdkwxdXA2dHdUM2J6azAraFFm?=
 =?utf-8?B?elBRZUcvTkdGSGVqcTR1QWNQQzlQdCtrbnlRV2l5TFhOdjNiMnMrQXVWbWox?=
 =?utf-8?B?VDY5QWl2alF4eXZlbXFSWVkvRkNsV2ExQ0RPTTBPYzJpS1hyS3Bla3V2L3Fa?=
 =?utf-8?B?UXhKKzd5SU54Wk8zb3ZDQnhLVi9vNkJyTm1mdHZkYXVYUXFEd3ZxY1ZtRTR6?=
 =?utf-8?B?aTh2d3ZkZjFrYVR5SkhJeUlMc0lTdkhXS0NqVTdUMUV3RkZpZ1QrZUpWR0Yx?=
 =?utf-8?B?UzNCQXVBZFBzUkxCMHRKWWUzZnhXcWRwK092SGVHd1BmRGFPczdyUjJpbGRl?=
 =?utf-8?B?b3hCK0dwT0VPK1l4ZjVMSDBxVU5XcW9va213dnZsZWk1enBxbExrVjByVEpw?=
 =?utf-8?B?OTFMeStXVC8xK0E3dFk1TWZkWFBjVHRBSGkvRDhHbnBmSWE3ZURoNkpDbTlh?=
 =?utf-8?B?Zy9hZzhiRGQ1YTYwS0hLd2VvallrYzExekdNb1J2c1U5b0dLdVBvcEtCRXRp?=
 =?utf-8?B?SjVGZi9YSjBIMWNPRGtialdFamYzN0VQRE12NDdENmd1N1RHSTkyNVFTTEVh?=
 =?utf-8?B?Z0JvQ3RkS1lFdjE1dU1wRFdodE5RYXN6cndtcFhGSys5RjIyeWZLci9hQU9m?=
 =?utf-8?Q?lQVdDZY4CxoMUMY7WnbCO+PeS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93A35497B1777542A267869B19A7ABF1@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cea2c0c6-aec9-47fa-7515-08dd15de379c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 10:10:31.6001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G2pR7SM0Qx1AVCbgu0VWnCRobH4R4hJfsoYr67cQQIwlq+ILLRcUuFiwQN87VQ4FYXa5Sr/TYCqaTQyQBLbBLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6818

T24gVGh1LCAyMDI0LTEyLTA1IGF0IDE1OjMyIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVGh1LCBOb3YgMjEsIDIwMjQgYXQgMTI6MDc6MTlQTSAtMDgwMCwgSm9zaCBQb2ltYm9l
dWYgd3JvdGU6DQo+ID4gVXNlci0+dXNlciBTcGVjdHJlIHYyIGF0dGFja3MgKGluY2x1ZGluZyBS
U0IpIGFjcm9zcyBjb250ZXh0DQo+ID4gc3dpdGNoZXMNCj4gPiBhcmUgYWxyZWFkeSBtaXRpZ2F0
ZWQgYnkgSUJQQiBpbiBjb25kX21pdGlnYXRpb24oKSwgaWYgZW5hYmxlZA0KPiA+IGdsb2JhbGx5
DQo+ID4gb3IgaWYgZWl0aGVyIHRoZSBwcmV2IG9yIHRoZSBuZXh0IHRhc2sgaGFzIG9wdGVkIGlu
IHRvIHByb3RlY3Rpb24uwqANCj4gPiBSU0INCj4gPiBmaWxsaW5nIHdpdGhvdXQgSUJQQiBzZXJ2
ZXMgbm8gcHVycG9zZSBmb3IgcHJvdGVjdGluZyB1c2VyIHNwYWNlLA0KPiA+IGFzDQo+ID4gaW5k
aXJlY3QgYnJhbmNoZXMgYXJlIHN0aWxsIHZ1bG5lcmFibGUuDQo+IA0KPiBRdWVzdGlvbiBmb3Ig
SW50ZWwvQU1EIGZvbGtzOiB3aGVyZSBpcyBpdCBkb2N1bWVudGVkIHRoYXQgSUJQQiBjbGVhcnMN
Cj4gdGhlIFJTQj/CoCBJIHRob3VnaHQgSSdkIHNlZW4gdGhpcyBzb21ld2hlcmUgYnV0IEkgY2Fu
J3Qgc2VlbSB0byBmaW5kDQo+IGl0Lg0KDQoiQU1ENjQgVEVDSE5PTE9HWSBJTkRJUkVDVCBCUkFO
Q0ggQ09OVFJPTCBFWFRFTlNJT04iDQpodHRwczovL3d3dy5hbWQuY29tL2NvbnRlbnQvZGFtL2Ft
ZC9lbi9kb2N1bWVudHMvcHJvY2Vzc29yLXRlY2gtZG9jcy93aGl0ZS1wYXBlcnMvMTExMDA2LWFy
Y2hpdGVjdHVyZS1ndWlkZWxpbmVzLXVwZGF0ZS1hbWQ2NC10ZWNobm9sb2d5LWluZGlyZWN0LWJy
YW5jaC1jb250cm9sLWV4dGVuc2lvbi5wZGYNCg0KaGFzOg0KDQpJbmRpcmVjdCBicmFuY2ggcHJl
ZGljdGlvbiBiYXJyaWVyIChJQlBCKSBleGlzdHMgYXQgTVNSIDB4NDkgKFBSRURfQ01EKQ0KaXQg
MC4gVGhpcyBpcyBhIHdyaXRlIG9ubHkgTVNSIHRoYXQgYm90aCBHUCBmYXVsdHMgd2hlbiBzb2Z0
d2FyZSByZWFkcw0KaXQgb3IgaWYgc29mdHdhcmUgdHJpZXMgdG8gd3JpdGUgYW55IG9mIHRoZSBi
aXRzIGluIDYzOjEuIFdoZW4gYml0IHplcm8NCmlzIHdyaXR0ZW4sIHRoZSBwcm9jZXNzb3IgZ3Vh
cmFudGVlcyB0aGF0IG9sZGVyIGluZGlyZWN0IGJyYW5jaGVzDQpjYW5ub3QgaW5mbHVlbmNlIHBy
ZWRpY3Rpb25zIG9mIGluZGlyZWN0IGJyYW5jaGVzIGluIHRoZSBmdXR1cmUuIFRoaXMNCmFwcGxp
ZXMgdG8gam1wIGluZGlyZWN0cywgY2FsbCBpbmRpcmVjdHMgYW5kIHJldHVybnMuIEFzIHRoaXMg
cmVzdHJpY3RzDQp0aGUgcHJvY2Vzc29yIGZyb20gdXNpbmcgYWxsIHByZXZpb3VzIGluZGlyZWN0
IGJyYW5jaCBpbmZvcm1hdGlvbiwgaXQNCmlzICBpbnRlbmRlZCB0byBvbmx5IGJlIHVzZWQgYnkg
c29mdHdhcmUgd2hlbiBzd2l0Y2hpbmcgZnJvbSBvbmUgdXNlcg0KY29udGV4dCB0byBhbm90aGVy
IHVzZXIgY29udGV4dCB0aGF0IHJlcXVpcmVzIHByb3RlY3Rpb24sIG9yIGZyb20gb25lDQpndWVz
dCB0byBhbm90aGVyIGd1ZXN0Lg0KDQoJCUFtaXQNCg==

