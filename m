Return-Path: <kvm+bounces-43316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BBCA89043
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D707917518B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6ED20487E;
	Mon, 14 Apr 2025 23:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Aabn8blz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2065.outbound.protection.outlook.com [40.92.42.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E92D1F4E27;
	Mon, 14 Apr 2025 23:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.42.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744675032; cv=fail; b=KlSTX6GzbZFJ8da+P47vQ9Pt7gICcOtWrs03Gd6owoYiD0huuHoDt683Dd0ZJQsBYe4RBpzJnvJ5MOVU7X/9Jlht7PAo1Twdj14Ldh3q+jmxqMd3sg1xTnwz31rOF1OXBpsGVZC3JpciIEljeGovx0z2mSyahuYi57mGLYXxD7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744675032; c=relaxed/simple;
	bh=O1FCY4LE9XMmT5BRTUowxRskAd86RZJkysN3CSfU3Ps=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J7TwG96b30pphvza9FG+aUlvrOVbUjeEB8bhJ2aJsKKg6wZ87nibS8gmrEqOnZ06vUoL+jvp981+7FwJUk3LN0S/sdg9iguTs1Xv+eQshaG+pPX2gJqqGSxnUtcg4G9jU8vExO68TXn882o2VvB9H2TVafF8yJN8Wgv8Z2pPGQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Aabn8blz; arc=fail smtp.client-ip=40.92.42.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGKICYaoZvgxQiXs571owYSXZu/m4RmZMzdTuW3vO4FAY5cXyhGuI6qiLkvjeVC3Z6kz34jbtjApNYNwmcC7+Ij35XwYsspUyNXiNRLnOkMe8IAOe8SMLEhcwKI8/79+ihD5sc1jNbW2WkTJUbzeEoSzoZDj8sE1g8JDG+a9ChLkBEdKgjShM7Djk2kHr/lE70XMNngDClxbmU1yMeA8RMYdCZpYcvQ4zoFVftproicpAZauTihXJIQGPzIQAeR8zbmFvnhiRLarKj/0CU/g/GVjp8lQ84pMt8+bp7qU3XceS7b9r0+SFxxRvX/OO16ulTg+wM8rp/LoIDFivB+j4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Pc8Ac4lO6WeIHebUnRnpSt5hXQ+pA6MJwwKAgiBNkE=;
 b=Z66QwvlZkUG15Gzq40lSQkI3H/YB2h+XyiToxpfTgYEBAAXs3IfvQg7S/9NetkEa53aBcsTZo3yBmXKh9HrirfSr9vTgDCFWFN9fA8o8Llbm7o3wFG2VPCHHCJN6Puuuh9ofyvLvC+MAqNM99XYcaObQj3hDjKReJjhQvB+CheJJ7gjuuYJcwLFeBtD5QlygXPO8Tn2TTMmpca7ICD+ffp58dMM7NeTVj89QGcikZmaTZ/ivoI6S3U1zJNlNlLsVxnSXaxb+3PjpWgjtN2bNZEtST4kTJMo8e89AFOw3sqOs+OEaM7Ns2ZDhSWC7FBxnOW2ACtd2adL+xGeLBD6A7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Pc8Ac4lO6WeIHebUnRnpSt5hXQ+pA6MJwwKAgiBNkE=;
 b=Aabn8blzrTsnH2jucJvTYiVGHjDhyHd+Y+dBwbw41cTkZcZR+Q/+oWigabQW0kGqo+k6Z0XWCgbozhUNOBcMX3ziBuThexI4qVdgwqH+uff9zxB2/dvE6fzCF6zp1TckCk9g+IPd3qzrv86ENSDEamNx0+BrhFjW95G/3cjp2jl9ZBrIzSFEeXF23N2/3G/lWDLKwInjz5UtvYKVNGSvZI8X6itZUhDL4TFUqTUe2P7i7xj9pIn28hMNMZiSAZ4xUJVMy7b7r13+FjMFi1juwl5wESK5CtxYmwI7uG7TN+SAWbFtgmSrpsYXcBrrKmVAUz7Hx6gxTiBtwFuKYxWMVw==
Received: from CH3PR17MB6690.namprd17.prod.outlook.com (2603:10b6:610:133::22)
 by LV8PR17MB7232.namprd17.prod.outlook.com (2603:10b6:408:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 23:57:07 +0000
Received: from CH3PR17MB6690.namprd17.prod.outlook.com
 ([fe80::a7b4:2501:fac5:1df5]) by CH3PR17MB6690.namprd17.prod.outlook.com
 ([fe80::a7b4:2501:fac5:1df5%6]) with mapi id 15.20.8632.035; Mon, 14 Apr 2025
 23:57:07 +0000
From: Liz Jordan <Parley4LizJordan@outlook.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Thomas.Lendacky@amd.com"
	<Thomas.Lendacky@amd.com>, "nikunj@amd.com" <nikunj@amd.com>,
	"Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>, "Vasant.Hegde@amd.com"
	<Vasant.Hegde@amd.com>, "Suravee.Suthikulpanit@amd.com"
	<Suravee.Suthikulpanit@amd.com>, "David.Kaplan@amd.com"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"huibo.wang@amd.com" <huibo.wang@amd.com>, "naveen.rao@amd.com"
	<naveen.rao@amd.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>
Subject: Re: [PATCH v3 12/17] x86/apic: Read and write LVT* APIC registers
 from HV for SAVIC guests
Thread-Topic: [PATCH v3 12/17] x86/apic: Read and write LVT* APIC registers
 from HV for SAVIC guests
Thread-Index: AQHbovrzMlbUKc7SfEyefcXamWZCEbOYnHkE
Date: Mon, 14 Apr 2025 23:57:06 +0000
Message-ID:
 <CH3PR17MB6690676327646FB828AB91F898AA2@CH3PR17MB6690.namprd17.prod.outlook.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-13-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250401113616.204203-13-Neeraj.Upadhyay@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-reactions: allow
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR17MB6690:EE_|LV8PR17MB7232:EE_
x-ms-office365-filtering-correlation-id: 74bcc31d-5fa0-407f-c2b3-08dd7bb0100c
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799006|14030799003|19110799003|10112599003|6092099012|461199028|8062599003|8060799006|3412199025|440099028|13095399003|102099032|41001999003|19111999003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?rmCu05+EN8ORBcl8TE8Xo1ocjWQicEXgoEJUeykP051+NDNSM7nE7uT9IjxH?=
 =?us-ascii?Q?0oEG+dGgGgZ/t+M3LVnuIRwSbaW2rPM/Q15d44nwMUPPQ1oV1IpTUvaGqpDk?=
 =?us-ascii?Q?q13OlFcFRRTzulHFeOAQ5eMKf0Vt4BdcXKYGQ7I5PvJewdlH3M6mS4ZjbxQJ?=
 =?us-ascii?Q?TGeQOxEuaRMR9lsqcfuCSxIZ2G4eiWaqfWyx+5hYVu/N6Ho033F2N7d6p4+E?=
 =?us-ascii?Q?vKLHf0lqsyYr/RVOPAxfGDvVbcpoxfh9rI4/nWE4iShwlQrfgNYXVpgjEgJu?=
 =?us-ascii?Q?U/hAaS1GzT+7GhVVEc89wFQGszxM7V9NPN/sTIXBCc/KdayTRbT+6so+evDR?=
 =?us-ascii?Q?7EazjWSsxRVF4dN4OAkGrgfsY7HDsmU1Wo4x4/E71sBDRwzvyzjh43v6ub65?=
 =?us-ascii?Q?oiKbTDyWfsasg13PXuU+qzqRKb+GyBzxuD4EtchrWUpK3nkkZY24yrlcpQld?=
 =?us-ascii?Q?9dbKYpGInLl2c4JxHQXvuf0u1M0lmOw8QmBGSMx1rh0886LTgm9pYkHrmCIq?=
 =?us-ascii?Q?lJ7/ECD3OiNgmjPEs8NYXYrm2ZLvgA58ggSn4cwlVzElT2OboO2z6ySEBcA2?=
 =?us-ascii?Q?ceFgH1RG8xdxs6M+1vRH34PJZXe8AIxfIRPBcd6GAHgxS5AuxFsvtVY0J5at?=
 =?us-ascii?Q?S0CTekVcdXTL6WbssGUxLUmMaTfYYWujU0VNjikceCJB3MEmXuDExogY1hb+?=
 =?us-ascii?Q?Nn7ztu7zWQHBMFJBWE0B73Vgl/dbLzBV/ObB6qK86VjL7V39oGJ2tfkRDh/7?=
 =?us-ascii?Q?MRYZq2Cjhh+0g2lraAwxkTrLnR4icPeNmO/BAGURlFQRcxmXXuxJqkm/Dodv?=
 =?us-ascii?Q?VdUDUxHnGslbL3qNg0kUIKIFXmf8KhdoKxb1kLPtFUGiWr8LOZJjCseVPDZZ?=
 =?us-ascii?Q?hOs9pelk1C/k9LigKF7Nw6Nxo0uhR5jvVL5EoGzplPnEwOW5JZr5TZ6FKCzL?=
 =?us-ascii?Q?cCJSrpoLqekI4q4YDo9d07tIJI++46/W0nUxSGB+tpjd1E1vmsv5rG4216u5?=
 =?us-ascii?Q?Jrc61ko1DC8YnMcaY9nfYhO0KBpPno6ucCGGm7Sfab8OiQB+CRpmPVXj9U5y?=
 =?us-ascii?Q?OCWtrL6dRT6g5prMJC49Ztk6wDnEhdwjq+LGumKlEDDO7K2N4k18LWLrqpSB?=
 =?us-ascii?Q?uT7VLQ7XvhIQcmeOCikeZIOxn0yBfZVEo60Alf7SR0nSYJ5wqoZnVSxw55G0?=
 =?us-ascii?Q?G/tj18rV9e6+cTEqZUkAwS84N2j70AyQwcHUMNrcS7HWcr/eNZtAbE5zc1JQ?=
 =?us-ascii?Q?FZuN1/uiUQdEgWCJ2Egzl1zuDxAetKDKXBtlmRaCsQ=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qtLpPTHw+doevS5LSL9jhXFLwDAMcFOH29K5ZeIeVopDqdQbKwS+k6n8Lq+8?=
 =?us-ascii?Q?0xGJrkoyOKC/WwuCMAGNSXa2OY/e70X/fp+LRGETfWY+P5JWnkgShayB9n0G?=
 =?us-ascii?Q?EGHJIIWVsQeXARMSIVoG3JQB3mijrs7qEQCLhZVgQCVfJxUpBLBCZHSUkUcC?=
 =?us-ascii?Q?fEr4qhszKKww6L85mr+OhGhTEUO3AejpqfjzM4RbqW10CBS61de5paViVjw0?=
 =?us-ascii?Q?74R2LQRXeamZfP4h9pQPGXJaayk5gUwNcJxGcIJXTP+pXpjMxS4w3GyGtt1n?=
 =?us-ascii?Q?IByKiwcP+Y/ofrRSgDWXuwZLOgecw9K/YkQmkgYyPdO4OzUAIZlhdPa0CQMV?=
 =?us-ascii?Q?mF5u+D+MWgKi+93UqrP5LBxjhjxWllOk8s6yOvsfbFy7ksq6guSrfyU+bk3q?=
 =?us-ascii?Q?GOXln+IWrfZgtpfz0sp3ZGdiv5pK5lhiTP3wNNexpIvBAPBAfBTsJtS200UJ?=
 =?us-ascii?Q?vFy+INtRw/DdXDspFD+6BPhQZK9PskT73k5CbPOP98bed3VVQ6nB/2Tcle4D?=
 =?us-ascii?Q?iFm56FqM0QjyYMO0kED9n7YlLehxUnSE386WdBPY+eQORwB4rezIFdzIp1r0?=
 =?us-ascii?Q?XonjtSBRhO3TzB6PauCznRq5rzb5c/uWmuu5Aw2hB7+tRlbXt2PH6dVpwu/m?=
 =?us-ascii?Q?CNA9K9aC1dik1mpiLcFMBsQeakFwKtrQJidjsN0chB0Kd52cV5SXJ/TTaNvq?=
 =?us-ascii?Q?5TShk7alPZ5CyirZrleBc1xwh/jinGMjJZd/DEGdie5rEhDPt8q+RF/u9Tlq?=
 =?us-ascii?Q?qdeFnbo0ZOGTJsp/YSddFmXN5htDKKEURI5lJtpwUzfhNvyf6q0h/kzRkvzO?=
 =?us-ascii?Q?nNhXnmuvPAy07F1JQ/pVPOlTeMuGCAhaMsOfKwp/FlV82sctYRha4wy0LGRb?=
 =?us-ascii?Q?zmZoIyw1RmmWX9oS+9kPbVsUvggC84k6OiPT8eH4WRdC4AabXoIOG0a79kp9?=
 =?us-ascii?Q?RvsV5FtrnIg0rUxOYMuKIlr5qQyL+vhpl9cYPzzkHc0P7b9091AIYDVCFRqg?=
 =?us-ascii?Q?VfbeNUMbFMjw0l73hXJeiTfSGMyf8vmKxYw6mE5cVoGLMhxLGxLNGGFFyTcs?=
 =?us-ascii?Q?tA3Oa5FmCHEqSqMkbL50+tE5XqGMRyH/1rxNVI4XpguQngjiHj4p0LHXym4R?=
 =?us-ascii?Q?9JSRUU9zJEhZv1quxZr8p9SEPdQnYIJf690BcqrEit8n0fNMZeWrvgog0yzs?=
 =?us-ascii?Q?IzvJPxCdizObhlmMr2F/5714FsTx+EEPd0TEJ2JCTO84oqEPaId3BMc5gEbD?=
 =?us-ascii?Q?YSeleTLjw5rNvmSa3Tbign3thpifgQaWQxW0xYGbkA=3D=3D?=
Content-Type: multipart/mixed;
	boundary="_004_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR17MB6690.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bcc31d-5fa0-407f-c2b3-08dd7bb0100c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 23:57:07.0022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR17MB7232

--_004_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_
Content-Type: multipart/alternative;
	boundary="_000_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_"

--_000_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



 __  __ _ _      _     _____       _____
|  \/  (_) |    | |   / ____|     |  __ \
| \  / |_| |    | | _| |  __  ___ | |  | |
| |\/| | | |    | |/ / | |_ |/ _ \| |  | |
| |  | | | |____|   <| |__| | (_) | |__| |
|_|  |_|_|______|_|\_\\_____|\___/|_____/




________________________________
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Sent: Tuesday, April 1, 2025 1:41:05 AM
To: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
Cc: bp@alien8.de <bp@alien8.de>; tglx@linutronix.de <tglx@linutronix.de>; m=
ingo@redhat.com <mingo@redhat.com>; dave.hansen@linux.intel.com <dave.hanse=
n@linux.intel.com>; Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>; niku=
nj@amd.com <nikunj@amd.com>; Santosh.Shukla@amd.com <Santosh.Shukla@amd.com=
>; Vasant.Hegde@amd.com <Vasant.Hegde@amd.com>; Suravee.Suthikulpanit@amd.c=
om <Suravee.Suthikulpanit@amd.com>; David.Kaplan@amd.com <David.Kaplan@amd.=
com>; x86@kernel.org <x86@kernel.org>; hpa@zytor.com <hpa@zytor.com>; peter=
z@infradead.org <peterz@infradead.org>; seanjc@google.com <seanjc@google.co=
m>; pbonzini@redhat.com <pbonzini@redhat.com>; kvm@vger.kernel.org <kvm@vge=
r.kernel.org>; kirill.shutemov@linux.intel.com <kirill.shutemov@linux.intel=
.com>; huibo.wang@amd.com <huibo.wang@amd.com>; naveen.rao@amd.com <naveen.=
rao@amd.com>; francescolavra.fl@gmail.com <francescolavra.fl@gmail.com>
Subject: [PATCH v3 12/17] x86/apic: Read and write LVT* APIC registers from=
 HV for SAVIC guests

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the Hypervisor for Secure AVIC guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2a=
pic_savic.c
index 845d90cbdcdf..4adb9cad0a0c 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -88,6 +88,11 @@ static u32 x2apic_savic_read(u32 reg)
         case APIC_TMICT:
         case APIC_TMCCT:
         case APIC_TDCR:
+       case APIC_LVTTHMR:
+       case APIC_LVTPC:
+       case APIC_LVT0:
+       case APIC_LVT1:
+       case APIC_LVTERR:
                 return savic_ghcb_msr_read(reg);
         case APIC_ID:
         case APIC_LVR:
@@ -98,11 +103,6 @@ static u32 x2apic_savic_read(u32 reg)
         case APIC_SPIV:
         case APIC_ESR:
         case APIC_ICR:
-       case APIC_LVTTHMR:
-       case APIC_LVTPC:
-       case APIC_LVT0:
-       case APIC_LVT1:
-       case APIC_LVTERR:
         case APIC_EFEAT:
         case APIC_ECTRL:
         case APIC_SEOI:
@@ -151,19 +151,19 @@ static void x2apic_savic_write(u32 reg, u32 data)
         case APIC_LVTT:
         case APIC_TMICT:
         case APIC_TDCR:
-               savic_ghcb_msr_write(reg, data);
-               break;
         case APIC_LVT0:
         case APIC_LVT1:
+       case APIC_LVTTHMR:
+       case APIC_LVTPC:
+       case APIC_LVTERR:
+               savic_ghcb_msr_write(reg, data);
+               break;
         case APIC_TASKPRI:
         case APIC_EOI:
         case APIC_SPIV:
         case SAVIC_NMI_REQ:
         case APIC_ESR:
         case APIC_ICR:
-       case APIC_LVTTHMR:
-       case APIC_LVTPC:
-       case APIC_LVTERR:
         case APIC_ECTRL:
         case APIC_SEOI:
         case APIC_IER:
--
2.34.1




--_000_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div dir=3D"auto"><span style=3D"font-family: Aptos, Aptos_MSFontService, -=
apple-system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt;"></spa=
n><br>
</div>
<div id=3D"ms-outlook-mobile-body-separator-line" dir=3D"auto"><br>
</div>
<div dir=3D"auto" id=3D"ms-outlook-mobile-signature" style=3D"font-family: =
Aptos, Aptos_MSFontService, -apple-system, Roboto, Arial, Helvetica, sans-s=
erif; font-size: 12pt;">
<pre><span style=3D"font-family: monospace;"><small><div dir=3D"auto"><b>&n=
bsp;__ &nbsp;__ _ _ &nbsp; &nbsp; &nbsp;_ &nbsp; &nbsp; _____ &nbsp; &nbsp;=
 &nbsp; _____ &nbsp;=0A=
| &nbsp;\/ &nbsp;(_) | &nbsp; &nbsp;| | &nbsp; / ____| &nbsp; &nbsp; | &nbs=
p;__ \ =0A=
| \ &nbsp;/ |_| | &nbsp; &nbsp;| | _| | &nbsp;__ &nbsp;___ | | &nbsp;| |=0A=
| |\/| | | | &nbsp; &nbsp;| |/ / | |_ |/ _ \| | &nbsp;| |=0A=
| | &nbsp;| | | |____| &nbsp; &lt;| |__| | (_) | |__| |=0A=
|_| &nbsp;|_|_|______|_|\_\\_____|\___/|_____/ =0A=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =0A=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; </b></div></small></span><span style=3D"font-family: monospace; font-size=
: 17pt;"><small><div><b>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; </b></div></small></span></pre>
</div>
<div id=3D"mail-editor-reference-message-container" dir=3D"auto"><br>
<hr style=3D"display: inline-block; width: 98%;">
<div id=3D"divRplyFwdMsg" dir=3D"auto" style=3D"font-size:11pt"><b>From:</b=
>&nbsp;Neeraj Upadhyay &lt;Neeraj.Upadhyay@amd.com&gt;<br>
<b>Sent:</b>&nbsp;Tuesday, April 1, 2025 1:41:05 AM<br>
<b>To:</b>&nbsp;linux-kernel@vger.kernel.org &lt;linux-kernel@vger.kernel.o=
rg&gt;<br>
<b>Cc:</b>&nbsp;bp@alien8.de &lt;bp@alien8.de&gt;; tglx@linutronix.de &lt;t=
glx@linutronix.de&gt;; mingo@redhat.com &lt;mingo@redhat.com&gt;; dave.hans=
en@linux.intel.com &lt;dave.hansen@linux.intel.com&gt;; Thomas.Lendacky@amd=
.com &lt;Thomas.Lendacky@amd.com&gt;; nikunj@amd.com &lt;nikunj@amd.com&gt;=
;
 Santosh.Shukla@amd.com &lt;Santosh.Shukla@amd.com&gt;; Vasant.Hegde@amd.co=
m &lt;Vasant.Hegde@amd.com&gt;; Suravee.Suthikulpanit@amd.com &lt;Suravee.S=
uthikulpanit@amd.com&gt;; David.Kaplan@amd.com &lt;David.Kaplan@amd.com&gt;=
; x86@kernel.org &lt;x86@kernel.org&gt;; hpa@zytor.com &lt;hpa@zytor.com&gt=
;;
 peterz@infradead.org &lt;peterz@infradead.org&gt;; seanjc@google.com &lt;s=
eanjc@google.com&gt;; pbonzini@redhat.com &lt;pbonzini@redhat.com&gt;; kvm@=
vger.kernel.org &lt;kvm@vger.kernel.org&gt;; kirill.shutemov@linux.intel.co=
m &lt;kirill.shutemov@linux.intel.com&gt;; huibo.wang@amd.com
 &lt;huibo.wang@amd.com&gt;; naveen.rao@amd.com &lt;naveen.rao@amd.com&gt;;=
 francescolavra.fl@gmail.com &lt;francescolavra.fl@gmail.com&gt;<br>
<b>Subject:</b>&nbsp;[PATCH v3 12/17] x86/apic: Read and write LVT* APIC re=
gisters from HV for SAVIC guests<br>
</div>
<br>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<div dir=3D"auto" class=3D"PlainText" style=3D"font-size: 11pt;">Hypervisor=
 need information about the current state of LVT registers<br>
for device emulation and NMI. So, forward reads and write of these<br>
registers to the Hypervisor for Secure AVIC guests.<br>
<br>
Signed-off-by: Neeraj Upadhyay &lt;Neeraj.Upadhyay@amd.com&gt;<br>
---<br>
Changes since v2:<br>
&nbsp;- No change.<br>
<br>
&nbsp;arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------<br>
&nbsp;1 file changed, 10 insertions(+), 10 deletions(-)<br>
<br>
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2a=
pic_savic.c<br>
index 845d90cbdcdf..4adb9cad0a0c 100644<br>
--- a/arch/x86/kernel/apic/x2apic_savic.c<br>
+++ b/arch/x86/kernel/apic/x2apic_savic.c<br>
@@ -88,6 +88,11 @@ static u32 x2apic_savic_read(u32 reg)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TMICT:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TMCCT:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TDCR:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTTHMR:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTPC:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT0:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT1:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTERR:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; return savic_ghcb_msr_read(reg);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ID:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVR:<br>
@@ -98,11 +103,6 @@ static u32 x2apic_savic_read(u32 reg)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_SPIV:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ESR:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ICR:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTTHMR:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTPC:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT0:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT1:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTERR:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_EFEAT:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ECTRL:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_SEOI:<br>
@@ -151,19 +151,19 @@ static void x2apic_savic_write(u32 reg, u32 data)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTT:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TMICT:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TDCR:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; savic_ghcb_msr_write(reg, data);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT0:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVT1:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTTHMR:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTPC:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTERR:<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; savic_ghcb_msr_write(reg, data);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; break;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_TASKPRI:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_EOI:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_SPIV:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SAVIC_NMI_REQ:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ESR:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ICR:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTTHMR:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTPC:<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_LVTERR:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_ECTRL:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_SEOI:<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case APIC_IER:<br>
--<br>
2.34.1<br>
<br>
<br>
</div>
<br>
</div>
</body>
</html>

--_000_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_--

--_004_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_
Content-Type: image/png; name="1000012130.png"
Content-Description: 1000012130.png
Content-Disposition: attachment; filename="1000012130.png"; size=15413;
	creation-date="Mon, 07 Apr 2025 19:14:54 GMT";
	modification-date="Mon, 07 Apr 2025 19:14:54 GMT"
Content-Transfer-Encoding: base64

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
1P8CT0THaykKA2EAAAAASUVORK5CYII=

--_004_CH3PR17MB6690676327646FB828AB91F898AA2CH3PR17MB6690namp_--

