Return-Path: <kvm+bounces-69183-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPElJwQmeGl7oQEAu9opvQ
	(envelope-from <kvm+bounces-69183-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:42:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DAC8F195
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DDAAE300BC60
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 02:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425492D8762;
	Tue, 27 Jan 2026 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="opHIVYqW";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ffMuQ3VU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C12D7BF;
	Tue, 27 Jan 2026 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769481715; cv=fail; b=LCJygg1p/OVyiQHJ4DGvrf1V6m+2NBydE/lw6ArznbX13ZTpAC3zAFRXe55h7SXkdP4k12xmYGJ9r7DX5XBBt1yqk38Qwd+aYF1eiWlQ2INJ6iUrdWf4OGMn/jeGHwvVvM9Puk8rh4fqp4YAhNiIYA9I5jKZHSIamGUWMVmYH2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769481715; c=relaxed/simple;
	bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hQDTio+Wz5bubcbsUXjP7uz06ZseJIBKX8yu7EgFcvXneRqdxyfLJXRVbgtzsLXFxCSUzTQbTxbg9MN0h3ywFKjWSGT2IGXUJnmVp9G2jmBbWvv2y0rbyZbcWGXZzPaCGV7ZURJNvwEvk4XSdCjI0SBOt0mzytAU4HHBTMdq6YI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=opHIVYqW; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ffMuQ3VU; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QMw4Ha3541445;
	Mon, 26 Jan 2026 18:41:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb
	3E=; b=opHIVYqWyKABHYtD4mkBLsjhMGbRtXD8lRpcU7K3DTqL2CBCZHx0FWKds
	FVQdG65N1F+ma8tosae+dMXCiF9Ui8LkTF9I+ezk3XuigLoYj/I4Iy7pmkAGrxAn
	cSgSDPPxx9uIWbBoba3DY7o50y7JUQh/h0SEVIUcJihxD729bVucHXO12OA9J9mr
	menZtKEew7pV0AAJUhr4XRMtZYWejjFAN3zRdfY/1asEivubpcU2aN/dWccpTAYe
	NRL9u/INmwO6yFcl+0EbY0K+0w49CgaUJBXOyENK6Tck87VorB14Jm2tUHVGkELC
	tme1OgaAjUSPVO1bcOQCtgGKuYAyg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023089.outbound.protection.outlook.com [40.107.201.89])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bxgeerg6h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Jan 2026 18:41:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tu046ThfBArhkI5w+y/GjjpSqy78l9odflqyovzggYrEmWrNGZMXIOHf+OiH2+xXmGAmEsYZdCNxpGcghaiQLlAkMb+HUOhbGCaA3oQQvB53ewIpUeX/qDSn3oWaj0PDolt9OGkHFzB8kxC4jQJZx5yX7i0pVQPAfCMM2DsiqBZTvzZRYT8Sno5olJTvQitj8yuwdKPrmlTi/3kOMW7GbuWClXYDrfF2/fbfLn2a2PZMaOdQZhewnSxp95vnsr03SMzr/KAvATecl6nYE7uMljiNKeXgZFce/g1HIYDlIr81P/Gteo0PyZ4KlmCuDQGyhfxinNR5NqLERGI4GmcpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
 b=rmQkbadggW5cc5QgyaxNtH0uWG31ihH5ZUetTWHtUaFFmUx/9qe20ZeC1N1WadLpmotqH5s52sd8p25a8/KeOKhHw7Q/UBDfiIA5Tj93fQoV2P2JDWTOlh0VohCiyYtsiVVJ++SuSdJnkPJcigjc5CKOZe4MCV4I9KshVHixlgmWXG0n6jojNRZUZ+/ybMWS2UBN3p7SZiRurMBWOpf1X2CBaL4v0hYi29XDj1TJlXzazE2RZ5a6chksQSSbRtg5/3Yn7zF6qEAy8e4+8egussfBZU8vydfYm3QYDQVpETz6Z9aFGhp//XxLJENEnyUOBMe5YKAhJfp5z0vcuoRxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
 b=ffMuQ3VUumpIRYaqzdVFplmRpb9X2kNzGm3A5W/mdNdvHGWkw/jCzom6pKTpvP0GmeZ5TpollChDWIJ5zveb6VVoYuxPt+UDolH3KbLzSTjATgu8C2ZOKgqIdHD3KH7ydNchsw17nPMKTaoAK7VMs9qTYOVy/ZCzWl8vjRLPzckxHsGYjRsLFwU9smfZ49cK1I+T9IIvAxc/L0y2dt4Qa3RCijiGj0JjZNocj3oDJwW8gagt4/9ryM2wtsUHnJraf9m+hr1IHW06Uf3bPuPF+ppklne9sEiTTiSjAwqoDNVzOdrUSHPJRb/8vAhelnN6nY8f902KC861HQkpq8gacQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CO6PR02MB8833.namprd02.prod.outlook.com (2603:10b6:303:144::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 02:41:20 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 02:41:20 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcjGffUO/8EAAunk2YTJVZU0WiVrVlToIA
Date: Tue, 27 Jan 2026 02:41:20 +0000
Message-ID: <C14B59B1-B024-44A1-BB37-49FC6D3B6552@nutanix.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
In-Reply-To: <20260123125657.3384063-1-khushit.shah@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CO6PR02MB8833:EE_
x-ms-office365-filtering-correlation-id: 2bd8abfb-0fcd-484f-9b7e-08de5d4d8d9e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?a3R4amVRcVJ5elZpcGVDWS9pZSt5eis4d0JnUkpDNzlybkg2ZDBaOVFjSEdm?=
 =?utf-8?B?ZUhITytOWmgxT3dwa0V5SXFiUHFQdUY0dkE3aks4dTRrWi8rTmxITFVMeXJN?=
 =?utf-8?B?WmQ3Ui9pMGtqVWhvbzUrWEp2b0pzcTVpQUQ2N3ZXUmowRVNOMTNVREE4QzQr?=
 =?utf-8?B?M084d2EzWGl6RmxPSWFLVjlPcEIybWhmbFFBdU1YaGRqTFdUSDNKNzRBM3F1?=
 =?utf-8?B?NW9rKzdoWlpPM1g2M0hjdDJ1b3QzUnN5ZVN1NXdJWDBGY1ArMzJUbWpSM3ox?=
 =?utf-8?B?cHRkcVo4NzRmWEJMd2tXbVpTMk5vRGxRU1RwRHZSaHZNcTZFcUtoRmx6N1Ay?=
 =?utf-8?B?WnBvNS9tc0Fvem83MGthQThKWnQ2RzNGMzRRVjMxQmdXK3RoN3FIUmkzSEVB?=
 =?utf-8?B?RUcwSTl1aENzN2pNM2tDcElORlYySHFSVjNncjZDbkpXc2NRMUd5Q0l3MTJq?=
 =?utf-8?B?RUlxSmcwWk9yN3JnS1gyTVBwS2RSeDN4QXhNK254VFprZ3FLY3hlWlRzQkM2?=
 =?utf-8?B?L1IvdzMreFovQ01HcForcWZ2ZU90WUlQdHFuZEZPRFJvRlphRFN4NDNZb0Mr?=
 =?utf-8?B?MStpQWZLNkZnbGxBL2tPWXcwODJsTnBZTWRHUkJCaHNtV3BqN3MzdHgvWnF1?=
 =?utf-8?B?WXlna05ORWk1TnlZNnhCWmxJbjdQVmJXZzRUVFM4bWk0aHJwMlVBbE9QUlBZ?=
 =?utf-8?B?cjFZTVJjbk5xZ0I4YU1nblBBVVAxWk9BVGN2Z281eDhjRVE4WGNzR3FZREFo?=
 =?utf-8?B?OEUvcVhEcm9Yd2k0Z3JNUEIxV1dmZTFvQzlJRmFIcThDb0lGR2E3d2Rqd1E3?=
 =?utf-8?B?KzFjbFJSb0pCUWtIMzdwdkdUNlZHL1FyZURVQnJKbGJCaUxGN1JQRXFJS01y?=
 =?utf-8?B?OTF2NHZ1c2ljak8waVZJYms2c1ZFdGllcTBWcFNTWmhQWFhHUE5IcmV3YUdy?=
 =?utf-8?B?eExna2c1c2xYS1lkY3gycEQwNURhT29aM1FiTjR6eUYzaGlDMWpLazBRV05q?=
 =?utf-8?B?MGNHa1VrN0c4cnUxNHdOZUt0S3FJSEJIQWFVVC9xYzdYcVp6Z215NkUzME5u?=
 =?utf-8?B?Nks3OWlZc1FOZkRiZ0dTM2xLcElad2VibFJ0NTZvaEU2cFloQk9tdFRhdFlE?=
 =?utf-8?B?YUFqOCtUTUowbnJKRHphejNubVd4cC9oNmRRbkQvbzl0K2Y0SmtNbFp6aU12?=
 =?utf-8?B?enJ6T2pMTk5US0wwTWllRUMxa1VKNVlFdWx0VHhCWmRUc011MjJqVHZrOFFn?=
 =?utf-8?B?amRqSkpFNGMvYWZTbjhBM2pnMmdQWXNJWVNZRE9JZllUZ044Nk4zcWswTUZn?=
 =?utf-8?B?R2xESXlEM2VRZVBoNEsyRVR4dDRsQ0l4bEhRSFVLSFZSK0NsZnRFMFlXeVFG?=
 =?utf-8?B?OG9vQVNlMzZEdm1XRVNENUkrQklYVXhCM2EvWENHRmZFNzdHTldIRnB6MGdj?=
 =?utf-8?B?S2IxbnNqT296bWhzd3c1K2tmL2RzMklPb1NmM2dXeFhuUFhlRUtLeStJckRR?=
 =?utf-8?B?cVI0eWtSU2xLcXd6S1o1SVJPVFdHS1phbHFZM1lDQ2FJNG1CY1MxVllhaFgz?=
 =?utf-8?B?U1BDWFdpU2JWM21HWkVsRUtmUFpKYnMxRkxOZmdSSVBpNjdOMGI5WGFWUmFM?=
 =?utf-8?B?TXpZY0tkdDZvNlE0eWlKTmt0L0JONTJ0cEJiQnFMUGRFRjdzZWNsZEdhR1Ur?=
 =?utf-8?B?WjdKT3lpdVMyQzF1WWFmWldxamdJMVErT0NDMjlkME9rckdVYk5EdFNJZlQr?=
 =?utf-8?B?WHE3a1IrSTJrRUhvU1RISkd1UE42UzFIVERTd3RXdHVDbXpCSDlMK0dqRDBI?=
 =?utf-8?B?M1ByWmhxMkJidWNRdU1YdGxuU0FLRE4zZVRhdTF6elltWUtMMXFYekVZbWtS?=
 =?utf-8?B?MHZ1YVFLeW1qZ1gvTEpsN1BjM25KSjBRQjVEWDFNcWFWakpXa21xVi9qZ0xJ?=
 =?utf-8?B?Mk0raUR2SnNOSWNjaXhCY3ozVDF2dk0xVDZQWHFRSHhkVWxCbExsYnVjU3px?=
 =?utf-8?B?QUgyNURyTGFIKzJlbTliSjF2NUFoU242VE83VVN4emt0ODVJWjA1S1RpN2di?=
 =?utf-8?B?L2RFRjdBUGx3MyszNHNaUCs2UWlMcU9vYVBBYllsQzFVbXFKSUV2MWJEMXpq?=
 =?utf-8?B?b3dlQ0xKVUVNWjVpZGZTRzhyQysreEN5eFhGNndpbTJ2cjBQWUtHU1MyZklZ?=
 =?utf-8?Q?s0SSchaI6wvECssKoa0nIQw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SW1ncHVlbUIzajJQaTFWYzFOcVBXMHc1cXNTdjhDWVZDR0FHd21NL0ZoN0pI?=
 =?utf-8?B?UzBhTGt6SHdvUVFXRHk5RFQ0bEhkOElqdTV6QndsckF4NUhxcFZOeDFJelB0?=
 =?utf-8?B?cVJjMUU0dW5pbElNVWcrdnBtdWxDYkpwMjAvbGpPbW01Slp3aVVMWXMvVlVw?=
 =?utf-8?B?V0VObmpxdEVUd1Vzc0FhelJ3WVNBcFZ2UXhxbTlHbjdPWXZaaCsyKzhlOHlS?=
 =?utf-8?B?a3hiZzZPZU11OTBFbUN2djl2VHpDQ2ZyZ2thWU1mUGpNUlMzZk50bVVqL3ZC?=
 =?utf-8?B?bFJRU2Y3Ym5ZMndtNmF1MmpCdjlIbHA0aGh1OHZwbXhIRWpPMFppbVErWndF?=
 =?utf-8?B?NDVtOGpnMGdiNnM5aHJpQzdEVWg0NmxmUGdKL05WSGdCc3FxQzJsbkErYmZx?=
 =?utf-8?B?Um5yMnFxTUVGeGhwT1hIRFJiVENXR1Q1WW13LzQ5bWZmWlN0TzdTNVdDdGxn?=
 =?utf-8?B?Nmk4MVorM3VBaVp4V3RQRFRudkpNbGNPMmY0bUl0dkF3aUgyOVMzT084L0VK?=
 =?utf-8?B?SElpTGRIT3hsZExTb0dpREMwMHRmUWhuNU1WZUZiZS9iaWV2Y01OeldaTzg5?=
 =?utf-8?B?ZWJiblRPQU1PaTlIS1RubmRKUjk2ajM4S3Q0WllpMVEvZUxtK2hDZkQxNmdx?=
 =?utf-8?B?cGVWa3FycWNWT3RsQkVRVU1zQkhmRUxhakNOeXVoMHZ5WlNNdnZxVFNZWUJw?=
 =?utf-8?B?TmYwNmlRSDhIWXluU0xkbUEwZysyWmVYWDhVYW5xUnFMMVoxWEFDSWJGZkdQ?=
 =?utf-8?B?RTh5UktKM1JBdk5BWGVGTWh5djFVOUhwbFljZEhuMGNWVU9zdHZ3aVptT1ZZ?=
 =?utf-8?B?bWxmWWQ2dVF1SmYvTVd0bDFxWU84MXNLdFdGRGJxdHAvbW1IRTdsaG91Unlp?=
 =?utf-8?B?R2VsYVAySjdvcFBSVENJK1BXT05OK0thTkxiZm1COGl0WmJDSit1WWpBQVEw?=
 =?utf-8?B?SGdMSFN0S0I4eGF2SThxKzJVQnlQS1owN3BwZGo0NjNvcnRiSmRSczFvYjdF?=
 =?utf-8?B?cWxnNXVWM2x0NmhsbkFTUEtzRXJCbDAvcGdZM1pvWml1OC9FT0Vwa2t1cTBW?=
 =?utf-8?B?NzBEY3l5R3lHTFJaVzhGajlWT3Ard05XWGdUNGlLemluZ1VhbUFKQS8zQlVy?=
 =?utf-8?B?aEsyTXBJa05DVkNOeVZjdEYrVmNGWW96T0thbkJ2dVlNN2t2a1Era3VaOWU5?=
 =?utf-8?B?V3RyaGxkbjNJcDRLdCtIMzdyc2RJYWdabCsrYWptMDluUjVPYzNvV2tWdlVC?=
 =?utf-8?B?czcxRFlOWnN4UWZuR2p2N2JTdnBBUkVxamlLSERmTXI0M0txV3JxS21WYUE1?=
 =?utf-8?B?akY5UmFBQk9ZS2R4K1NmSHB2b3hNZzZNLzlwV2JBNHpnQWlnUTNQbzd2Wmlo?=
 =?utf-8?B?WTl3SDdGSXJFNmVwck1HSFVialpyNk13NEhsWDNad3Zwc0lrczBEQzhWVjN0?=
 =?utf-8?B?UlNoZDhwMnNRdjlyZGZNa0V3UnRqTEZFNkhGNDNwL3d3MkNPKyt2YnNDdVJa?=
 =?utf-8?B?WHIza2lqY1lTNTRPT1VBWmFjN2JSZFV0b0xRRjVmSG9mb09MUGNJSm1SaU1G?=
 =?utf-8?B?WUpJd3UyNmZxZit6d1BtNzFiVzhZUkgyMXZaM0dPVG9KR3ZHbjdvUGF6bFhm?=
 =?utf-8?B?V2IzVzlLaDF6OHA1RHFEKzNnZ1N6OEhvQ1ZkQzBNR0xOZWRKNWwvczQ2Skdn?=
 =?utf-8?B?TWJBQzgvemhMRG8wTUNZeEkrd1FWeER6Nm5McW9VRVloRWNKMzF5SHV1Ync5?=
 =?utf-8?B?L0lMdWFJRGhRWHZ5NFRPTE5UdlJVL1JFRE5MZlAxOHArSVRYSTlHTUxGR1hu?=
 =?utf-8?B?cTQ2a0ZMeVhkZmJwNk9Rdkpad3lCeVNEQmJQVlBqSmtGeDFqQTN1VXJ0cHdw?=
 =?utf-8?B?bHhWQnVXWVd2Z0E1UFBycFowZGx4U1NjaGVwbFRxVTdyRW1TOEIwd21Fckd0?=
 =?utf-8?B?U3ZLd1FWWFVNY29tQ294OWNIeURWN1RxaFFKYlN6bWVRa0YzbENRdjVONG1H?=
 =?utf-8?B?VkI5VzhsMTBDaXZEandvSlMrVlBRcWtIK2ptTHMvTjRHVmRaV2ZGc1pGMTdh?=
 =?utf-8?B?NHJGYytsalM1a0VndmlvMVRYWnBodkFaS3EyNk5adVJpOUhRTmM4SFF0MnM5?=
 =?utf-8?B?dm9KdlliMi84aGQ5TzZMVkphcFhubllCamIwc3Q5QUFxbUtUZ3RZTkx6M2pn?=
 =?utf-8?B?ZkowSGRWcE9iYmdjNTFmOFNmN05vdVJ5SHoxaXFHa2dMTHo4a04yd0tzZ2NV?=
 =?utf-8?B?dWpIVmZYZ1JUZkw4SlUwTDVjM3Brb3pWVUJTekVac2d0YUtITksyc3NhQ05i?=
 =?utf-8?B?L0NTa0JyY0pzOVZGbWJadHFoRVZWdS9TSEo0amg0UXFUU2pVT1MyRTQzMXE0?=
 =?utf-8?Q?Kr1Cz6Qiz8TqdMkA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C5C96E8EDC4164CBFC9082EFE98356D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd8abfb-0fcd-484f-9b7e-08de5d4d8d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 02:41:20.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWxWb67wwqpIH1LAqSfSgqlixsq6cf5E8x7vrG7PsqHa0jDjpJbQsEZwsehtLEzzc62ksH7oe3KpQBEqiL3uTvzaKUvX9ERrykRfz2EERC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB8833
X-Proofpoint-GUID: IsKRJcMs64xS56ooH4oD1Wpuatz_plS_
X-Authority-Analysis: v=2.4 cv=WPVyn3sR c=1 sm=1 tr=0 ts=697825d2 cx=c_pps
 a=WnWl4E2caQIyNlWj2D/b7g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N42Csu5fCSehUJrjJN4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDAyMCBTYWx0ZWRfX0RsJyHkfdf5n
 KLLlWNGreUQeRYh1sFbYoisyE+EGcX5tAUeA3oKqX+uUgwUmVVPgstDaJHeB8VRBf7jEbsXdyss
 DUdNcfgPfCojl8+g/AjdzK3zEVQzbE/sTyHuLScKV1JvikP6ga2Y3OlR/gp7+AnGE9UNqf5iHwl
 beNPQNDUwi9BwKqat2iX2BNTP1514SJMMqCNMiGqY1iiNOiqwYforLF7cvVnF5eyiBDV8DrtKsR
 MRrGEb2QDd9EpGeiheY8tVvBGwN/BL2qvRBgguHSMlas5IWPBAxJ3CpJzf41Gki8k/LXpkjgPQJ
 RbYP/y3h2LK2Y9g8bHE7IoXxYhM9E6+DnW6JWNRuxakyqi3lvhctf5ZWm53+mfK+JdYVa+MYKZl
 2d+XljmpANySCDjaxEsH4+7DpXQBjHRnEP4XUbHuuuz12YAMlcn0vxPxAyysOAL6pQwoaic27zS
 TSFd42MNOcQ5eM1WG5A==
X-Proofpoint-ORIG-GUID: IsKRJcMs64xS56ooH4oD1Wpuatz_plS_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69183-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nutanix.com:mid,nutanix.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C2DAC8F195
X-Rspamd-Action: no action

SWYgbm8gb25lIGhhcyBhbnkgZnVydGhlciBjb21tZW50cywgbGV04oCZcyBnZXQgdGhpcyBtZXJn
ZWQ/

