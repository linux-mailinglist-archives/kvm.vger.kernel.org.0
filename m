Return-Path: <kvm+bounces-32002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 410F49D0E4D
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 11:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0087128358C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 10:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E69B19A288;
	Mon, 18 Nov 2024 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zO4LE0SZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A2A199EB0;
	Mon, 18 Nov 2024 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731924962; cv=fail; b=hNBpZxsm96EJUUgSPepFjpMnUbFfa2FBwp0rHLNfA8VNfiXvmnGe7DtDK+6VHImqV72ixbLX6kcfK2vkYyQoUI3k672JpUXy763xNcDshIVhLr7NCZQx4RhF0UTczBX4P5j7fzJjlJomhTq8uLmobve+Fz0XegJVWgvNdJJ1TWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731924962; c=relaxed/simple;
	bh=TurhxZCYKf45Hvp+9ayxTFHDgfYZJ4hFUUH33Lj7eFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SC7n9KuHS9rwC8GwrKPCjHciSky2MqavRzveHXok6isenuLQ0iQWk8r6DgVCc2a69c5/p0f0PfcPosXzeWzShX+Tq890+fGxWA8sWAZ0NVpJjP/VGuTtN4Q/I95KbFd2tsfel6ncL1SnGGXVJx4OMCTlVy5cr/7POfT566nkFzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zO4LE0SZ; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIqG3KF1jYoGVra4JY4da95wh3xRdRE2CINnE6APb2oxgcoEuhfVp9XHS4bh8LMmJaOdans37TDFL2mjS67vXzyYrqy++ETTsbTiB7i1nvNegNFNcN80PNJogTYTFeylXjVCTG29Ppa+DVNqSlj3kcoZY3RKWnLYnLXzf8+t0VTHV8IzZKn+O21m3tCxhcbma2X/JIABRZAOWkfntD2BJwE+R5qgvpxZGlA8MgeQmhhigL7kCAt+Jg9w9jg+d9KAdefSLe26RHQmghyH8+gjwvMs1UEwv9o848qaUSmtf5NVkRTvfX4r3RVVim5KfSTh8D2n7Tsj3z/KSGbKhiCCIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TurhxZCYKf45Hvp+9ayxTFHDgfYZJ4hFUUH33Lj7eFo=;
 b=d4NMXTMKYMkJ/V+BYuyQtELpqlwuaY6UkdWqOvTDmZDX331b3Nr6f8VB3J/trBxSwMUrg5Yxes6ZZ9XpcDfLycxBbO9b1IrAGXVTWTF3H4zMJzDiPIXAX3M/U9J3T1wZVNrnRvL9m415GHbjAdmhRzNDyoeEngjScZ9W1ljjHutObjlQGTWjUjPisxw+2wafmbpXSOA0W2LskJPzyKeGR8gbAwzw28sJCBYoSWKgTaRYAv92FeOp5KfgN5kg797a39ni3sUENXCI70j75YzX466wCli5XfPMlJOwvgfmMX3CEvReiRGzUkwAfVH15abkW82b+kD42b7fGRU9gtzeBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TurhxZCYKf45Hvp+9ayxTFHDgfYZJ4hFUUH33Lj7eFo=;
 b=zO4LE0SZcKj9gBf6dp2THvn5sIx5xopTONvwuxyonaRedJ5X/jlw14Kd/HQ8KTXo1Jfz5PRkiuulGAk02HfwntOXW1S5DA5M0oTWjHGOSdmh2lpMlS1YgqLPeSJD/f8Syv9Q+SBIsbiP7dywWd1LpLhJOR2UUyQpkQP5Xz3Mkmo=
Received: from PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8)
 by PH8PR12MB6986.namprd12.prod.outlook.com (2603:10b6:510:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Mon, 18 Nov
 2024 10:15:56 +0000
Received: from PH8PR12MB6938.namprd12.prod.outlook.com
 ([fe80::16e0:b570:3abe:e708]) by PH8PR12MB6938.namprd12.prod.outlook.com
 ([fe80::16e0:b570:3abe:e708%2]) with mapi id 15.20.8158.023; Mon, 18 Nov 2024
 10:15:56 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "amit@kernel.org"
	<amit@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Topic: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Index:
 AQHbNFhQwY6CJIvrmU2tNHgQpSE0v7KyeFwAgABS0QCAABWWAIABTnUAgAF7OYCAAF1RgIAACjqAgABcFgCAAW1DAIAAyceAgAAFZICABDKEgA==
Date: Mon, 18 Nov 2024 10:15:56 +0000
Message-ID: <2eab0a67613c35ec1aea57b47f6808a507270ad6.camel@amd.com>
References: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
	 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
	 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
	 <20241112214241.fzqq6sqszqd454ei@desk>
	 <20241113202105.py5imjdy7pctccqi@jpoimboe>
	 <20241114015505.6kghgq33i4m6jrm4@desk>
	 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
	 <20241114075403.7wxou7g5udaljprv@desk>
	 <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
	 <20241115175047.bszpeakeodajczav@desk>
	 <20241115181005.xxlebbykksmimgqj@jpoimboe>
In-Reply-To: <20241115181005.xxlebbykksmimgqj@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR12MB6938:EE_|PH8PR12MB6986:EE_
x-ms-office365-filtering-correlation-id: c1d542af-e86e-4bfd-7bf3-08dd07b9fdb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y3NYd0pwbU9oNjVxRFpGWGNpeG81VGVMMmRaa0pZV0VsMVNkelFIbTVPeXY4?=
 =?utf-8?B?RmRVSzdiTU9iTDdvVFF4cWJPSWJtRTIzVE5BUXF3MTByQ1kvTE1uMXdoUlls?=
 =?utf-8?B?ZVZURGpRc1YweE9EeGVkd084RTJEd0lwVmk2aFhGYkY3bFhwdnhtUDlNNTB6?=
 =?utf-8?B?Z3AyN0w3T2R4eTNLQXovRmM0TTZWeDdlaUVWQ0s2eCtWZFpBS1dVaUsxbFZo?=
 =?utf-8?B?bXRFRys2SUttd0tPbjFwc25zclVRdXd1RlFGSy9kQXkyTFVwYk94Zjh6S092?=
 =?utf-8?B?MlVaQU5yY1huL2xBUGNEais5MXVuL1NsZXdrZ2tFTnFTa1MvTXIrRklRRkRu?=
 =?utf-8?B?Q0pvUTBka3NhdDdKc2xoK2ZRSzRyL3V4NjNCN3pQcThKa2JOR0hxTUZQQlU3?=
 =?utf-8?B?YTlwTVpKWTRnLythU1VwYTh1cUdzWjhIZUhlS2hJSTA0Z1Y5clFnenBLTzZC?=
 =?utf-8?B?Wmwrc0xlYUNSVm5QVngrb3dKVGo2NkJhMnFaRElOcXNqSjA4SmVVOXhqNWlu?=
 =?utf-8?B?K1d5T0FGcG5oVWxPZElGazJPK1dVeUpQeWFZTDQ1Ym9qR1FnbzcwMDJqWjdn?=
 =?utf-8?B?V295ODFMa1NJbm12enVZZ01KMWNRMWJmQ2tKUkpBNmsyQVE3TXNsaG5tdGhh?=
 =?utf-8?B?dmp3dFI3dG8yam8vcXVEMHR0UGFiTFZ2YktEVVVuM2ZYV3JxVXNnL2hJaUsy?=
 =?utf-8?B?eDdKWFQ2ZndFZGlJQmpTMml5Mnlqc3dNTVVvaERUdnB3M2EwUXVEQ3Y3MnVF?=
 =?utf-8?B?K1kxVmdSSU5SWWdveU1DVC9QMkhZdklOTWo5REpZSEluc3AyalM4UEFwc3N6?=
 =?utf-8?B?dWlDOTBiWkRSVzljVCtMd2Y1MHlwQ3RIOXlqbHNLZlA3emp0WU5CYjZ3dVkz?=
 =?utf-8?B?dzdlWTQxKzFORWpqblExaDVGRW5yR0RLZnJJeWtlaFh5dUZwQkdBTDJPa1c5?=
 =?utf-8?B?c0RjcXdzSWtJRkhSQU12K0VVVWxaalJ6TU9uYm5oZ2ZrQWx5WHRiVzAxT3Jk?=
 =?utf-8?B?c1JMMG96MzFvcnNCcjg2UDN4dDAvbDRBMlpRcFoyVG9tS1NNVVZWakNZRFFH?=
 =?utf-8?B?eUkxQkwvQmRxZ25Oc0lvckF4ZGtRbTNQR3B2UXZPT2tTeWlxUFQ2WFNwM0s4?=
 =?utf-8?B?bEcyR01jZmhSaGJ6T045SzRzeFhDTUJzTmptbEY3QmtZYUpWMTEwRitTVlVQ?=
 =?utf-8?B?QStuVUhBZVVXQzNYWEllN2pReWZyMGlJbnNtWmhISlErQk1sR1AvY2dMTzlt?=
 =?utf-8?B?Y1phZTh2TWRxdU1LWURnV3krczAwZFp4bWZZQ080Qkx1U0FyRjRsb2I3MHVa?=
 =?utf-8?B?NDdUd3lSRDdVajJyc0xPaEJBL3NRRzVLVktndElFMnRQbXVibTJRaDVSU1Rm?=
 =?utf-8?B?UHczelZFZFFMeVJXbldLb1hjcEtjanRBVlhvdE1KQWlaQjR4OS9LYkZ2RjE4?=
 =?utf-8?B?b3BaQmVOZDRjekZPSlB6UkdKQjI0alhtZFJtOVV1WHhud0ZicWRVYWpxbkcr?=
 =?utf-8?B?NitDVDYrcEhPZFdsWUsrOWk0UHNXeUc1QnFtK2hYZWg4bUhEcS94ZS9MMG9x?=
 =?utf-8?B?UWlYY0NjZVUrODVVVXZsRTMxMzNnRG94SFp1T1ZraUlxRjRTNnZ5Zk9VcC9C?=
 =?utf-8?B?QXQyRFZLRGMyZDRFQVl0cHJnRFRpRGRTRytmRUtmYi9zS3U0Q3dpZEIxbEw2?=
 =?utf-8?B?NVc4b3dpeU1WQUY4LzdhL0o5TnBXYXBZR283R2lsaWpKV1ZBSjU0alU2UWVz?=
 =?utf-8?B?N1NwMlBkU09ESWJ3c014allTM2VicjFodGFLeWp3ODNDdHpRVC96WjZUNmpQ?=
 =?utf-8?Q?4PGSpZbe3xNj+Hu/RGwIO4WX8zFGQvAjtZoSg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB6938.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eTVBSnpmUU04NEdFNWtWekkrbWoxZDRJQmNrd0t2TW9WZFNIMkFJTXhBc2JZ?=
 =?utf-8?B?TGZLVUU3amxGSnloalc1YXQrbW41N0FwUUl0azI5NlowdllUVXRDVFYzUUFl?=
 =?utf-8?B?QU5tZ01NbVFCR0wwZ3hJdDNHTFAwZmpNcEJXOXZ2dWZkTEpSdEcwa3JqeVZZ?=
 =?utf-8?B?QkR2UlhWZ0pwQVFJRFF0MXdhNDViM2JXalBEY1Myb1UwQU8zcUdyRlZydFBC?=
 =?utf-8?B?TjM1YnBPOEpYM05GR1plTXNtWGdHeXlaTjR4UFpEaVBkTytsN2FUQWNCU0VT?=
 =?utf-8?B?MVhLcWhVOWRKWmc4Q1YvZC9iWDhUSmh0bXgya0V1U0NGWHkya09xVmhZeCtu?=
 =?utf-8?B?YmZNZXpWQVovZ2RBY0hEQUpxNnpCbEphWlVaZWpuWUk3Ykt2REpHVDRVZmw2?=
 =?utf-8?B?OHIzOGRRcmVBb0VtSFI4c1lrb0RGOHlwbEdVc1M5M2VuaGludHNsREZlaFRq?=
 =?utf-8?B?MTdwZENkMVNQNEY4YXkrb2JlOEkxdmZGRDMyZXJLSUw5aEIyV3BZK3MvaDZV?=
 =?utf-8?B?YW9BNGwySDJVNU1iVHZIWG8wL3ZuaC84K01RMUNERFE0SFB4Z09CRFRoeWd0?=
 =?utf-8?B?Z2hwYWJwVmpqcmFOamhrNjBmeXNzRFI5OXlBR292aVoxNlFZaUVzVnpWMFFI?=
 =?utf-8?B?Vm5hNHlLN3pQci9UWVBHOWRYY055dHpWUlJ6WU96RzFHMzNxYmUrUXh4NGNS?=
 =?utf-8?B?ZEttekFwVjhMcDhnRC9SRStyakRGQndMREdtbHhOdVE3M1Jsd1pWajc5dzhZ?=
 =?utf-8?B?c3pPY3lBWUMzU0xCeDBiVWNyditHUG1GUHVrMmZ2UDZreFlJNjA3Sit3VEli?=
 =?utf-8?B?K0VCdVMzbEdOZ1BmV21URkUxUmkrdlV1eS9GOW5iZzhhVEY1dEpDRjhZM0ww?=
 =?utf-8?B?N0gyT0VINVBHdlg5NElEYytaOE1keDBvTVpGWDdxcm1KMllrM0N1cXkyVXFn?=
 =?utf-8?B?T1BVUmJBU2pBNEVud2NGckJ5K2lhWStSbXBMNDJmc2t0K2EzbDhzckROZlhR?=
 =?utf-8?B?UG9HT0Z4VmhJNTd0QzR2Y0lLZ1RxK3FBcnFudnNOSlVDZjBpNUFjQTdSeEsr?=
 =?utf-8?B?OGMyYlBDQXhYYUlCVCs5Y2JyZWdqZ2dhMEZqQ1FPOVVlampYdVZuZFRNTkFM?=
 =?utf-8?B?azR1ZTg5Uzk5U0kzSytrQm4rdkwrd2lnV1RMOUFUZWQ3Z1MzakU5RXRZeWtW?=
 =?utf-8?B?bmU4Rk9kOXZtM2pjR0xYa2k2ekxUcm9wSDJtNnMxSmw0d0gzbDVjOHMyRHNQ?=
 =?utf-8?B?eG1lUXdpcnQzNjhzSkJPcmVrVGFmelE4Yk11NHlrVHpuZGNoQWNhYVFTQWZO?=
 =?utf-8?B?ekltYVVCWit3WWxQU0xwKzh3Z1Y4R2c3Wm1Ld0pObWFZZmc3QU9HWVRKYWp2?=
 =?utf-8?B?eXNCTmt2ZTZXNHdybjlxQ1pDZTRod2FtdlpRMjAxZkRMQndIS0lyYXhRZldW?=
 =?utf-8?B?S3lwS3ZmV2dUU0RSZ1hSWDhPUGxONTBLbzZKRjB0akVORktqWDVNOGVzNWdB?=
 =?utf-8?B?aFdaNXZTeUFqWlF5ZXBFVVl6R2Z1aTdnZUI5L3FGNml5ODRnd2RhZzU4UnFG?=
 =?utf-8?B?TWNJTHV3c0VseWNScVgvZXl4OCtnam84R0VhRS9hSkVBcXRWbnhpUmU0Mm1Z?=
 =?utf-8?B?YWErRmFtRm5uUWtOSmZHR3l1OEVLWnRtK2w3bEJFd0tmRitwbk43QlVyVmdm?=
 =?utf-8?B?eklWT0V2VTVKdEw1d2hqNk1TcGZkNnlKeXVjek1MYW12eGh1anQ0WVVpdk1u?=
 =?utf-8?B?UVFwTEQ0cWlSNmpnRytvd1B3U1NDZGNoOE5kSXgxODJEMFNnTkFZVU9TRjU3?=
 =?utf-8?B?a1lkVEhXeS8vQjlOOWF1ZDBDT3hUWlRtc3cwYmhZNU0vOFA4amJmZFdKeWZC?=
 =?utf-8?B?RU00L2J4NWRCNXBCUFh1Y2JuaXNRS1djWEYra1oxZ2RoWjNWWnRqajdnbHN1?=
 =?utf-8?B?VERLdFd0ekZ3QXNwRkR5VXZEaXBVa1g2VnFLdGtMZ3lHNEpOWjRIYmJjNVYz?=
 =?utf-8?B?UEljbjNRZU5WcDZROGorendxTGI0L0JHMEZtdWg3MDlpeWdkZTNqbjNKUVd0?=
 =?utf-8?B?UEVDZjE3UTUyejhLVmlIblYzeks1TnUwemZ2M05JaUpRVlJLb3FHRGZiVHcx?=
 =?utf-8?Q?u/7hYghNQqOvOEhfoUw6+WOQ/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3B0E46A84C71F4C83C18CD15E7BA5AB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB6938.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d542af-e86e-4bfd-7bf3-08dd07b9fdb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2024 10:15:56.2887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d9NBkwKP562h0vwV1V/gM4o8VbDKk5LBzHnVZxi4zrWmdeY4mnInclqEOgQnjupHz6jGeNkETJmUedK+nhwY2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6986

T24gRnJpLCAyMDI0LTExLTE1IGF0IDEwOjEwIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gRnJpLCBOb3YgMTUsIDIwMjQgYXQgMDk6NTA6NDdBTSAtMDgwMCwgUGF3YW4gR3VwdGEg
d3JvdGU6DQo+ID4gVGhpcyBMR1RNLg0KPiA+IA0KPiA+IEkgdGhpbmsgU1BFQ1RSRV9WMl9FSUJS
U19SRVRQT0xJTkUgaXMgcGxhY2VkIGluIHRoZSB3cm9uZyBsZWcsIGl0DQo+ID4gZG9lc24ndCBu
ZWVkIFJTQiBmaWxsaW5nIG9uIGNvbnRleHQgc3dpdGNoLCBhbmQgb25seSBuZWVkcw0KPiA+IFZN
RVhJVF9MSVRFLg0KPiA+IERvZXMgYmVsb3cgY2hhbmdlIG9uIHRvcCBvZiB5b3VyIHBhdGNoIGxv
b2sgb2theT8NCj4gDQo+IFllYWgsIEkgd2FzIHdvbmRlcmluZyBhYm91dCB0aGF0IHRvby7CoCBT
aW5jZSBpdCBjaGFuZ2VzIGV4aXN0aW5nDQo+IFZNRVhJVF9MSVRFIGJlaGF2aW9yIEknbGwgbWFr
ZSBpdCBhIHNlcGFyYXRlIHBhdGNoLsKgIEFuZCBJJ2xsDQo+IHByb2JhYmx5DQo+IGRvIHRoZSBj
b21tZW50IGNoYW5nZXMgaW4gYSBzZXBhcmF0ZSBwYXRjaCBhcyB3ZWxsLg0KDQpTbyBhbGwgb2Yg
dGhhdCBsb29rcyBnb29kIHRvIG1lIGFzIHdlbGwuICBJIHRoaW5rIGEgc3RhbmRhbG9uZSBzZXJp
ZXMNCm1ha2VzIHNlbnNlIC0gbWF5YmUgZXZlbiBmb3IgNi4xMy4gIEknbGwgYmFzZSBteSBwYXRj
aGVzIG9uIHRvcCBvZg0KeW91cnMuDQoNClRoYW5rcyENCg0KCQlBbWl0DQo=

