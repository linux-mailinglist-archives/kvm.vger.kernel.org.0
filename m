Return-Path: <kvm+bounces-66775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F175CE6ABA
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 13:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB5C83004CA4
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5EF30F7F5;
	Mon, 29 Dec 2025 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ysGbyg74";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vfzEXMQp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35292BE634;
	Mon, 29 Dec 2025 12:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767010897; cv=fail; b=hcIlHfHZxZf2q3Frvkhy/jdxsHIvaA66TyHBU5G0tFNVBUZyGddJfHjAuIXMgd8N0htvBfX5jjMhJ7pIih/C/e3NFSA02aZNndrrxE6C7X95ufJZckhZU518twPw7ON2LVyoUrjapfZlsBuOCcX+QnIugQXXb6fTySWddGd1kEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767010897; c=relaxed/simple;
	bh=p5iw7vJ3J+cJKYo7rLBxcIIhQiOoAe6RmLB9lJWJ2iY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C7BZDMlRfuFvXbWo4cOouXBIKSIDGEoN4z43LYOdzUv3Wk+hZTpj2huggqjtqQWNese8FxHY7n1dcEbgdbEZ2X6OblycoSpT0RtiMrEQzE7TQOBw8/dyeM3OzbUq1pYbs2TCNcA77B8iVemXlo/nWX29WJDQOfnZFWaDh9v6h/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ysGbyg74; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vfzEXMQp; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BTBp6rF3834886;
	Mon, 29 Dec 2025 04:21:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=p5iw7vJ3J+cJKYo7rLBxcIIhQiOoAe6RmLB9lJWJ2
	iY=; b=ysGbyg740BVR0Jn+cY/hqarENK7ns9tk65oRqQwWntWc0gaS8wmQGLAfh
	luC+r+kNRFM5nzEMNlCh7HsG5Wp9exLoAFNMEdwSKKED5KSVWV0AQrGT/aTDmxK5
	cmrvV+qeQLoAyD22xdW2lds3bO/GI9ltSW0QgzFaMEQHY1Z+MqQKMfo7zUm3r6QV
	yw06KLH2Be+cZOZLx9K6cT7b2aIwgyeycU820wduL5Ed8n+Xb6rSfJVzF6HD0Wgg
	JfBZPOvfu7IhqbI5hMnk2Ej6/AaYFCX0VTYgfXSfnxnPirATTpXA+26ArLkH2HQZ
	zp0V0lWJNlAS5bc9P2zwUuxec8h8w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021096.outbound.protection.outlook.com [52.101.62.96])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4bafw0an7x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 04:21:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rp+7PdGS4+q/nDvlfJYPZSjRSOIGEVlwdRAFVyAcxx/bmN8jfgUcWurFkgbGsum6JPx5TkTc8QcEOhqBZIAVoRCZis0idlFa46jANCarPSijNoyrmMsPPtdoXrFUKKf3e4x8rYWzSxUtsZkkYEEfF6pnFQ6C4Ovia9fGBUHquYCvjTV4+ofGj77ruiJQ6jrFa3vyEzXQrtYXp60cAS3s55a4QGtvQOFEggtM5A/EwqyEjYUkQrPXGTFf58T/tznizC8ZyC8FY9LV9J3yFNo7k2npfioVEOcyjuW2AC2DhXLcJKyZKXZK2WX0Z0bhdSy9sSR7Xl3sMyr+fHBTFFwqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5iw7vJ3J+cJKYo7rLBxcIIhQiOoAe6RmLB9lJWJ2iY=;
 b=KmqabbF+D7Gi+VKGZsEJQOYViWBez5dLiU6WX8FcuDIr1Eomb286ztDnyZDR5BIvwPh7D1qv2v2CgI73W1yOCFCoMXYzar/BPFPe/7bJdX5c4/VJ8dvijf2TGdPLtxblKSjZFSIcUyEMSXKB0jsh4LtOyO7jHxN1f+yeQaujbX46Lwq1r2tfD6HzryM0p83H4kGJhsOsLFGrIkcHSg7rGprP9fGJW/BRDrPhH319sB6qGbY9JrJxRCcALQE5EA0Y/sUNIjGxsi0XRakPZ8FYxrpC2g56WUr4LgnrCz199VVFnqpgWP0TYCcVeinX2S4uzQ350fbbYhhhX8rzVsKmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5iw7vJ3J+cJKYo7rLBxcIIhQiOoAe6RmLB9lJWJ2iY=;
 b=vfzEXMQpVhq36PpfogZqWYdcSE3UsWAFH+pwZhSi2w4I0ZqqT7AJyXppifB66spOXp6cm0c/zT5cNrANcdytBc0A2toirq2O4b08Y8v4cPG5+lzah/0Bk7Ipvg3jz+tsElkP59uOrj3WYM8J2EtO3T/yjNJ7hKAO4NEzA740n913H0qGa7aQ10LAgbDETWOI8M3i/Cd7VldYraq4UWbEWXHxlU3zylrxSES0Y9KfjKxgUiLAjQYTjXF4smt1wrcPqxFyPz9UqoBh5L9MqddW1tpcdqK6hlDXmeNCUAzX5rly8yi4wfvfTdn5TjoEbYNie7Mu4euxnfAHcGwB5nZv2Q==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by BL3PR02MB7857.namprd02.prod.outlook.com (2603:10b6:208:33c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 12:21:02 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 12:21:02 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        David
 Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Topic: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Index: AQHceLTEKfxcrcgmBUCGXzBVU4MWXbU4fimAgAALkYA=
Date: Mon, 29 Dec 2025 12:21:02 +0000
Message-ID: <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-3-khushit.shah@nutanix.com>
 <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
In-Reply-To: <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|BL3PR02MB7857:EE_
x-ms-office365-filtering-correlation-id: 37dc2b5b-2b13-40f9-866d-08de46d4bb4d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MFlwcnVwY0lUallMZHd3Z1g2ZWFaaWp3Ri92em5wRkhKQXA2QXh4WmJLY3ZT?=
 =?utf-8?B?RlhvS3NHV05US1owV3R3R0d2TFlGWGFzbXNBai85VVRFNHB0b1h3cHU4YzBo?=
 =?utf-8?B?TThQUXF6REpRVEd0RzBlbHB6OFo4Q3BBOXI0TVpmVHB2R3hmN09aN2ROZDF5?=
 =?utf-8?B?d2wvTzZpdGdveERpOWEzM0NWTHNOeEhZUFY4eDhzU3dSblpHb0dLTWowdzJj?=
 =?utf-8?B?bWcwYzJXSnQvUlZodWZzQ2l5ZU9IYVAvNVlZVGZXWVVXWXRHdE5aeW51R1BI?=
 =?utf-8?B?bXJyZ1d1U01oSDdhMW9wcTI2RkY2Tmg4SGVvbUFnYjd5RHUvMEQ2RVp3WEhZ?=
 =?utf-8?B?N1lzUTlKLzJpRlhsNHZvL2FSOW1UcDRzZWVENk93dUV3WlZWaEdzRElmRlAy?=
 =?utf-8?B?VE0zc0dyaUJ0VGpuY3E0MkZNNkNTZy9GREJxZ0FVQ2FwVS9oYTdiTWh6WUw1?=
 =?utf-8?B?R3phZUN1U3czUzMzQjBLR0NKL0tKQ3ZnWnBPWkdyZi9yKzlQc2MzTERmRUVu?=
 =?utf-8?B?RGdIYzh2cEJKRTRxWXZaTDE1OCtFYUZvcnAvUGFSRzdScERPYS9YUWxpd0Vz?=
 =?utf-8?B?ejNPcnpNemVKTEZoSjFJT3ZrekRIaE16QVpyK0dJQ3dXaTk5MFE5bDR6aVRm?=
 =?utf-8?B?YmwxQnF5MjVVcHFjR0l4Mm9hV0piSkVHL1UxUWpOYUZUS0k4UlB6MVJEWVIz?=
 =?utf-8?B?THZsbFZidVZ5MWZJbEtVQlM4OEYwYWVadFBoZDZveUxhanhhZnd4T2JrUkJL?=
 =?utf-8?B?UnQ1cXZVeFNkcVZZY1dNcFRJVFBndEM3bFZoazZ0Z0J6RGY3bXlrenhrVjQ3?=
 =?utf-8?B?RXp4T3Qrd0E0Y2NyNnlWNXBvVUYxcUt5eUdhZ1ZaaXpZbXJkV2lGZk1lT1RJ?=
 =?utf-8?B?S0xuRGV2QUV3R2QvdGV6S0NtRzYvNGFMOUFxV3RvbGVCSmdLNmtNaVBGdTMw?=
 =?utf-8?B?NEJ3a0VKTGVtT2NUektidGRaamF0dlBDT0xnYytsWEZWejRoWThhQ0E5SkFa?=
 =?utf-8?B?V1NqUU9qbURva3RIVzNwMkdJTTJ1emtvN215UTdXUFZtNUJEbnFYNW1FK2p4?=
 =?utf-8?B?ZDhzR2JJbmhUVEZoY1R5L01PdzhxQ0J0Y2JlM0ZFR3NQVDh6TU0wTmdRUmg4?=
 =?utf-8?B?cVhzRElyOUR1THFtaG5PdUpqZVNUR1FWOXVmZmFROHg0YURrT2RhVkRSand1?=
 =?utf-8?B?QUZ0U0hsa3J2YVVXdEZsOUVka2tuTysvZU5FdFdGNlBNemZaK2JtSjkyVGRU?=
 =?utf-8?B?b1JtWXBVbStCYVBIck9zZlZTcG5DZldlS0VTQ3NmNE5GMFlBOW0yME5PY1lx?=
 =?utf-8?B?bXNqR05BcGVESDdka2w2VVVLN2tIZ2hsQk41RGZ2SXdYOUpXblNWNTc1UVZl?=
 =?utf-8?B?NFBKbmptaTNvdUJ0emdyeVpwUmNvdWxjS0VxSUtMeTdjcVptZHFENXkwSlVa?=
 =?utf-8?B?UDhKVGVpR3FUbnZ0MENsSjdtVkM3YXFDRUJhcCthd0kwYW14SzR0LzZtdHFz?=
 =?utf-8?B?Qk4xWDFDY2ZZcXA5VGFWM0Z6cVBJVWdNSkFlTkJ4NVdtcWFudmlTMCtRNmdR?=
 =?utf-8?B?aFRXbkp5NkVnU1RyL3YzSkRmVWlDMVN6cXVIdWNReFFqS3VOckhZSzQzK0E3?=
 =?utf-8?B?NlhwZjg3MFk3dWROeFRwWXNqU2k1ZFJMRzB0MkRQbVp3Z3pMUTFmcGhQV2FI?=
 =?utf-8?B?YkxIWjdYdERkM1dHTW41emdGekVpaHhsY1g0NHlpNDAyNjRWbVU0ZlJHcmRF?=
 =?utf-8?B?RjF4T3JuMzdEb2dqU3YyR09XZ2xJQjJiSk5qYkFIRWg1MXNxWnlEbXQ3UitS?=
 =?utf-8?B?SDRWQkIvL09NczM2WU9Ua0FQcUNNQXFJYnJNaUtzU014K2JZOVJtallyZlp6?=
 =?utf-8?B?U3Z0dUdGQ2d6OTJWdTRGZytGTElpT0phS3JaeWYzWVoyZ3I1d0pXaGsxWExS?=
 =?utf-8?B?VHFJRFhoVnFTVkR0TVRaOXp0RGQ2akUzbFVzQ2x5YjNQbU9WcXppYnBjUVpG?=
 =?utf-8?B?anl2ZUF0d2pTUXBDVDk0NVhsTDgyL1ROR2wzbE9iYkp3L0tHQUJDZFFwVjEw?=
 =?utf-8?Q?ZcANAN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MllpSFJIUXBwSkJwVG9RZUh4THZhR1FqRnZaSy95VU95UHppYlhUWGprVXpn?=
 =?utf-8?B?YkJwN05qUkQzbThqdjJRRXdKMTNuengrRGtvY3d2c1lkQzQrOWYwYlFtVGZi?=
 =?utf-8?B?YURpUS8yQjBEM0o0NVVYR2ZoSUR0elRObkFGRER0MUF3OXg0Z25QdllxT1k0?=
 =?utf-8?B?cERBOVJTMUdNaWhGNnpjRHJnRXk5S2o4TDQ4Ly9laW9Ub3JNR0Y1bUdVRUUy?=
 =?utf-8?B?NmZ5bnFFY1FGZUFNdTdyelJjbnlUMnJIa0gveHJJaldjaXVSbE1mSjlQS0pk?=
 =?utf-8?B?bFM4Y21LWGFXUGZwZWlDZnY4dVZuZ2VmTk5NV0QyZys4N0lSOFlka3ZjSEE5?=
 =?utf-8?B?SFRsN1loVVlnblJJdjliR0c5MXVxNVIwR2Q2dzB2MXJ0YTk3UnRpai91cXFm?=
 =?utf-8?B?OHpFSkgyU1QzMFhjdHZZeFQzN3NBemZGdmtKcE1sSnFOWUpvVkJISDdaenJX?=
 =?utf-8?B?cTVscTdFbTNwNDNDeWRKeUdJRG9UdEV5WVQxOW1GeS9MNm1saE1LZDZtS1Vk?=
 =?utf-8?B?R2J6QVVJbDd1NTM4VFMybEQrWTROTGxSbDh6ZkN0dWlicjNMSEJ2Y212WDBP?=
 =?utf-8?B?cTFHcjRKQTJQZWRySGxhSnpuamRKZ3pvRTdDUlY3alNrR3pwcFB4b2UzcDZG?=
 =?utf-8?B?Uk9BTENvV2RnNndxSk8rV3MxbFFER2lsUCtRTFE4eDM5K2dEem5GMXNOUDBs?=
 =?utf-8?B?OVpuZ0dWT0h2VmNIVHJmRWhyS3FZVENELzhDT0tOV1JsWnpCN1ZDVUQ5YTBt?=
 =?utf-8?B?UmVBb0ozZXo0MHF1b1FadXRSTGRDTTROM2xzMWRSV0RWOElLbE5QU3FqelVm?=
 =?utf-8?B?SEhLYlpxYk1XeU43bHBTWEhhZkhMRFRyT0o4YkRsY0NiT1hoeXZHL0ozS1Va?=
 =?utf-8?B?dlhLQWhyZDl1WjZKTWwwc1NHVW1tS0FhR3MxODYzVkZXbXhvZno1ZlFsRlBW?=
 =?utf-8?B?YTNNVmRaenlkVk92bHlUYkYrckdNVURNQzluQkhHaHoxYTl0N0x3eW5mQTh3?=
 =?utf-8?B?THlRbm9JYldRRkVWekFtSE9UaVltWDRqQ2IrVncvRGhlNW5ZT09Rb2JHYmY3?=
 =?utf-8?B?S0NFZkNZaUJ5MmRWZ3Jsci93ZWVTMWNSZXpaUDV2MmxyWWVjM2RyUlF4OHpK?=
 =?utf-8?B?L2E5QmVhTC9SUjJVcXNlZlhaRjB6eW5qVHJNS2R1aHV2RlBlMlJWeCtoSTVa?=
 =?utf-8?B?SXZld3RqT1BTcUIrTHRYTnRKcmRQaFlsc3ZqUk81STZwbFd4NTRHOEdZL25i?=
 =?utf-8?B?Wm52cXNUVWZBWHBUR21VdVJGN1FGSjFQZ1VlV01UdVpKd1hYRzNOSkF3SlRx?=
 =?utf-8?B?SnpIVGw0aHVMNjErZEJXcXdFb2UxUDNCZlpCeExHRmR0SGhZTGVpQXBWVjlT?=
 =?utf-8?B?Nk5oZDE3bmRCanRkWnBKM3BNSDZab1BkcWJIS2pHWGljUkthWnJINVBrU0Q5?=
 =?utf-8?B?Ymh1czdGbmhLUVFVNW1xS3dSdlVOMHdsdk50TFNUYm04VEI2Q3djYTd3ZVFu?=
 =?utf-8?B?Z1orb2NCaXZFSUs5bndNNmhudzVySGN6S0R1ejV3WDkwbVpMcW96aFFCV3Mw?=
 =?utf-8?B?dUJwWXZHWUluZ2RRU0dndmlEQkg4c0xUV0x2TWZLRjBYNUtBUVpXTWpib3ZU?=
 =?utf-8?B?OFY5bUxodDFPd0hCdndhT2xvUFM1d3pJWHV0Z1h1TmpyZkVyZHZkNlZ5dnpX?=
 =?utf-8?B?MDZIdkEwWE8xMHBBdkRQaDFpa1NLQmFiUjMrNElhYjV3elI3WEk1SVh1OE9N?=
 =?utf-8?B?a3NSTDhYelJsbk1CaHRsODJSN1hxK2k1ZjBXL3YwRVhMemJ1cFc1b3hTYTJs?=
 =?utf-8?B?MUc1OVp1bUZNdld1Sk85bS9ESHBqSEF6S3Q3a01QaC9weXV3RXZldGxiMkNh?=
 =?utf-8?B?c2V4YTNXVHJueXpkcDh4Y1ZHL3d0ZXB6RldlQjVyRjZpNkpEL1pJWjJORld2?=
 =?utf-8?B?dmxKcS9nZHVlcVFoQktDRWR6clJaZExnYklhUVRQclIvelByemo3d3JsV2ww?=
 =?utf-8?B?NW1RSytFWUV6UEl6bmFQcjJ1Um5jOXFWc2x1OFJHWXVkQjdMTy8xL09YZzdG?=
 =?utf-8?B?YjdEcWd1REZaMURBNTA5OVF6azU1VE5IWFMwL3h4OElOS1lWZWdkcmVEc002?=
 =?utf-8?B?RG50RVdCajVVbmsxOXlmcURmT25sWHFQUnJkMmxtWFppUFEzbGxJYmU3WlJ5?=
 =?utf-8?B?Rk9LbHJIN0huMk5GaGwwZXd3QVZWT1M3K0FKUkhhUXR0TVMxWVlPL05WSGlZ?=
 =?utf-8?B?WVNPZjZPWTJENnNNdlN1N1RuTURwZmttcWlWR0NCamV0R0RxSmQ2K28wQW10?=
 =?utf-8?B?d2RmaERKNnRlQTk4T295RjlDSzc2VFR5QlZjb0tRdnlKRUhYWVV3LzR1R2Nk?=
 =?utf-8?Q?/ThVVqseLrpjqFro/xS5BPc8HaE7Gruq/ufeKzebHeHi4?=
x-ms-exchange-antispam-messagedata-1: w7qkwHuTaHG5+610UWedb9TDEMg0sR7AbG4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB1B06F28DA0CF4BA273AD33BE6C3449@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dc2b5b-2b13-40f9-866d-08de46d4bb4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2025 12:21:02.1712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQ4zec3gU3SNSk/ewvzG78cbDi/BN5QA1flqHAcj+x2+I53uf62fQ7lU3nPI3kNyVVQ7VXUftRt2tB3yXQm9LA9GiLQDKZ1sy+cAi4XHufA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7857
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDExMyBTYWx0ZWRfX9p42IYnse1Zj
 HNsJuQa3v47X93mnA4TRQkUreg8+XvFVMNeC+jNGfPcgyPIuA5xxm73YI95k8FiwCa4RuFY6LI3
 qgiddLpO7i95cMJrFdQTRMBWVCQODMWG88iks+ToN0kbEczieb9ENYzfw/7RtQXDZQjdm2eltgL
 edH36uwGVgVOXHFOZpXHV66gBKJfF12ZtuEILtCJ99oZ34r+0Ro7y68MMyHMm5QO2eIJNYeOml4
 Bm/s9V+xkLbnnYPiSGu+eerx2jmmy5JubGlED3OQIYa/RdnkzDc6/T93WtTTu6YrerUqBCj2GTs
 ZqpZ5QanJQmn5v/NK2PpCLzHL9r0RASVQ1+b5LmNheLIhPAs7RFWZQjgQ2FA+mUrZSiiQoRn/tH
 kpRGDLVr1Qd/k7f1fhb3DPLk+d26OFjzfIrD1YYNRJxvakw8tix9YXq5kXcaXZK2UMkTL+mDKQR
 x57jW0M8/YKbSTmqO7A==
X-Proofpoint-GUID: _oiY-6O25uducZoPzz1lkm3EK39jrKyO
X-Authority-Analysis: v=2.4 cv=Fe46BZ+6 c=1 sm=1 tr=0 ts=69527230 cx=c_pps
 a=kOv5NEUV9vKuAQ6k4lCurw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=64Cc0HZtAAAA:8 a=pBOR-ozoAAAA:8 a=REiS0IgRsb2Iwax8Yu8A:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: _oiY-6O25uducZoPzz1lkm3EK39jrKyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_04,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDI5IERlYyAyMDI1LCBhdCA1OjA54oCvUE0sIERhdmlkIFdvb2Rob3VzZSA8ZHdtdzJA
aW5mcmFkZWFkLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiAyOSBEZWNlbWJlciAyMDI1IDExOjE3OjA3
IEdNVCwgS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyb3RlOg0KPj4g
RnJvbTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4NCj4+IA0KPj4gSW50cm9k
dWNlIHN1cHBvcnQgZm9yIEkvTyBBUElDIHZlcnNpb24gMHgyMCwgd2hpY2ggaW5jbHVkZXMgdGhl
IEVPSQ0KPj4gUmVnaXN0ZXIgKEVPSVIpIGZvciBkaXJlY3RlZCBFT0kuICBUaGUgRU9JIHJlZ2lz
dGVyIGFsbG93cyBndWVzdHMgdG8NCj4+IHBlcmZvcm0gRU9JcyB0byBpbmRpdmlkdWFsIEkvTyBB
UElDcyBpbnN0ZWFkIG9mIHJlbHlpbmcgb24gYnJvYWRjYXN0IEVPSXMNCj4+IGZyb20gdGhlIGxv
Y2FsIEFQSUMuDQo+PiANCj4+IFdoZW4gU3VwcHJlc3MgRU9JIEJyb2FkY2FzdCAoU0VPSUIpIGNh
cGFiaWxpdHkgaXMgYWR2ZXJ0aXNlZCB0byB0aGUgZ3Vlc3QsDQo+PiBndWVzdHMgdGhhdCBlbmFi
bGUgaXQgd2lsbCBFT0kgaW5kaXZpZHVhbCBJL08gQVBJQ3MgYnkgd3JpdGluZyB0byB0aGVpcg0K
Pj4gRU9JIHJlZ2lzdGVyIGluc3RlYWQgb2YgcmVseWluZyBvbiBicm9hZGNhc3QgRU9JcyBmcm9t
IHRoZSBMQVBJQy4gIEhlbmNlLA0KPj4gd2hlbiBTRU9JQiBpcyBhZHZlcnRpc2VkIChzbyB0aGF0
IGd1ZXN0cyBjYW4gdXNlIGl0IGlmIHRoZXkgY2hvb3NlKSwgdXNlDQo+PiBJL08gQVBJQyB2ZXJz
aW9uIDB4MjAgdG8gcHJvdmlkZSB0aGUgRU9JIHJlZ2lzdGVyLiAgVGhpcyBwcmVwYXJlcyBmb3Ig
YQ0KPj4gdXNlcnNwYWNlIEFQSSB0aGF0IHdpbGwgYWxsb3cgZXhwbGljaXQgY29udHJvbCBvZiBT
RU9JQiBzdXBwb3J0LCBwcm92aWRpbmcNCj4+IGEgY29uc2lzdGVudCBpbnRlcmZhY2UgZm9yIGJv
dGggaW4ta2VybmVsIGFuZCBzcGxpdCBJUlFDSElQIG1vZGUuDQo+PiANCj4+IEFkZCBhIHRyYWNl
cG9pbnQgKGt2bV9pb2FwaWNfZGlyZWN0ZWRfZW9pKSB0byB0cmFjayBkaXJlY3RlZCBFT0lzIGZv
cg0KPj4gZGVidWdnaW5nIGFuZCBvYnNlcnZhYmlsaXR5Lg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5
OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPg0KPj4gU2lnbmVkLW9mZi1ieTog
S2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAtLS0NCj4+IGFyY2gv
eDg2L2t2bS9pb2FwaWMuYyB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4+
IGFyY2gveDg2L2t2bS9pb2FwaWMuaCB8IDE5ICsrKysrKysrKysrLS0tLS0tLS0NCj4+IGFyY2gv
eDg2L2t2bS90cmFjZS5oICB8IDE3ICsrKysrKysrKysrKysrKysrDQo+PiAzIGZpbGVzIGNoYW5n
ZWQsIDU3IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva3ZtL2lvYXBpYy5jIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+PiBpbmRl
eCA2YmY4ZDExMGFlY2UuLmVlYTFlYjc4NDVjNCAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2
bS9pb2FwaWMuYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+PiBAQCAtNDgsOCAr
NDgsMTEgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgaW9hcGljX3JlYWRfaW5kaXJlY3Qoc3RydWN0
IGt2bV9pb2FwaWMgKmlvYXBpYykNCj4+IA0KPj4gc3dpdGNoIChpb2FwaWMtPmlvcmVnc2VsKSB7
DQo+PiBjYXNlIElPQVBJQ19SRUdfVkVSU0lPTjoNCj4+IC0gcmVzdWx0ID0gKCgoKElPQVBJQ19O
VU1fUElOUyAtIDEpICYgMHhmZikgPDwgMTYpDQo+PiAtICAgfCAoSU9BUElDX1ZFUlNJT05fSUQg
JiAweGZmKSk7DQo+PiArIGlmIChrdm1fbGFwaWNfYWR2ZXJ0aXNlX3N1cHByZXNzX2VvaV9icm9h
ZGNhc3QoaW9hcGljLT5rdm0pKQ0KPj4gKyByZXN1bHQgPSBJT0FQSUNfVkVSU0lPTl9JRF9FT0lS
Ow0KPj4gKyBlbHNlDQo+PiArIHJlc3VsdCA9IElPQVBJQ19WRVJTSU9OX0lEOw0KPj4gKyByZXN1
bHQgfD0gKChJT0FQSUNfTlVNX1BJTlMgLSAxKSAmIDB4ZmYpIDw8IDE2Ow0KPiANCj4gSSB0aGlu
ayB0aGF0IHdhbnRzIHRvIGRlcGVuZCBvbiBfcmVzcGVjdF8gbm90IF9hZHZlcnRpc2VfPyBPdGhl
cndpc2UgeW91J3JlIGNoYW5naW5nIGV4aXN0aW5nIGJlaGF2aW91ciBpbiB0aGUgbGVnYWN5L3F1
aXJrIGNhc2Ugd2hlcmUgdGhlIFZNTSBuZWl0aGVyIGV4cGxpY2l0bHkgZW5hYmxlcyBub3QgZGlz
YWJsZXMgdGhlIGZlYXR1cmUuDQoNCkkgdGhpbmsgX2FkdmVydGlzZV8gaXMgY29ycmVjdCwgYXMg
Zm9yIGxlZ2FjeSBjYXNlLCBpbiBrZXJuZWwgSVJRQ0hJUCBtb2RlLCBfYWR2ZXJ0aXNlXyBpcyBm
YWxzZS4gRm9yIGtlcm5lbCBJUlFDSElQLCBfYWR2ZXJ0aXNlXyBpcyBvbmx5IHRydWUgd2hlbiAq
ZW5hYmxlZCouDQoNCg0KDQo=

