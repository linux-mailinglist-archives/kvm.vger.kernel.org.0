Return-Path: <kvm+bounces-69182-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OULHYIheGk/oQEAu9opvQ
	(envelope-from <kvm+bounces-69182-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:22:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBEF68EFCB
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 91503303323D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 02:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5052D46BD;
	Tue, 27 Jan 2026 02:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gZ5lge2s";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gjD9+J7L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE967149E17;
	Tue, 27 Jan 2026 02:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480562; cv=fail; b=OB0HASv2OfU3xjXb+FTeqGUK6vxN3OymYxzWaq8VNywoGydY/QYLMafKAky2QQxePsGOcD9HlHVzz284+gtFhXTI1vIVIoJnpCPeUn+W4Vc1FM1g1xf7BlUMEMZyGMnKVG3B54Un17n5MaRT3GQMNqmGep3N6RWuRTWK/Rw0KM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480562; c=relaxed/simple;
	bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pun/g0LVScDjX3ZZUXpFBVDKHj0E0BrhQnqWZasWIBec/I+yK5oAqnfgmx0dXH1Rqr8mqlcVsdvKhEyiGFsH66nCiDpkoCZEQqgjU4cmbGaDoPWs5c6n5ZVlvfSJoVwy6gZvzdX8qmoCuzurDMMKOwX18l2mNdKgsVbvSjLbQqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gZ5lge2s; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gjD9+J7L; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QMvsDD3640867;
	Mon, 26 Jan 2026 18:21:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb
	3E=; b=gZ5lge2sjhELU32u5GSbpTYP5W8WXCqpJRzRqo4TmHV/z/owQDZ2umWJZ
	+nleX81XhEFJyAA1BIHtpWBmi7vHYkblYHSWL8o1CsyVKkHBmzRQeqxoEXrYYIG3
	gFtyGizpQc569vIhPM/WfuP6ReXZBor5QIcJ5yrIplGY8cCSO8JQXO79gu3mrWX6
	aotlMigGPzIruuUHBQEQnR+wgOpC6ca0J82OK/+UjVpiYAVHmRNrXp18R21CENrZ
	p52XNoSVV61o4aoEV8RCv+XEIw7Bur8jM/a4D5UdMp3ymbdCRCKT7kLEa7kkWqc5
	AF8TJIT/0j3D4auGlGJ+mzrw6CX1Q==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020099.outbound.protection.outlook.com [52.101.193.99])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bvvg7cqqx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Jan 2026 18:21:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOYZIK9YteWqQaDQW4ur/NLca96eyB0koXx0QaIEEj9RtTEcaMneljsiLPgJnraXy9prQxpsH67KSswLmNZchv21aBfJL3gqRc2Z8R/+YmfyhN4Zt7K0R1KDdxa3mWMahqUx4Va99XLz5tnwE9fBgUTomd0b3AukcGcwCuiTWwtp7SQEEkOWvqQ3KT8XW4MYTVYCnri7PYorSqTslLFVd32WMsj+xZpF3HLMvyov/YqGfqAQ0ysNjJnM++CWacMEtqPUCN/Ut0pr5P6NWryJ9BiKyr+GBenD5tJP/MNfX/HpNDn4Jhs3Q1/IrJ3pbZpO+8AbziND8ormOGWGV/vU5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
 b=AyIifebSHoShGXzLsfkX8TApaufW7xWnf+as9jpb+084lQ6DW6ptyQPR++MfbvsAdhd1m35NLoGgiaqAEZIt58Aj3nhGeoQhZgvNLYeULGGMA8CEh84E7gOKdCWTSLed69s3QyS1gvUlNBOJyDwl5wVS8k9XfEJGyFEMCzj+nd23ABVvzHUb32+M9RRIGHe6CmcOacjZZaPR9jruiKoKSj6HUbD609Zr56GOZ6gXqOf3qaUo8DvkLSHziAe7j3Uqz9x+c+/X7RYtCALDQMXhk49DDhDm8s2qnaAKOOQMH1ZCprbMRCGcakxC0eyhrwD4aVqcMzDMaVSflbOBt/ZBLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vU+MKcUkOAZiy2LzFUv8+AnaLGpRuZK+3DEW9Rkxb3E=;
 b=gjD9+J7L1SXM11V71ddGnfL8YBJxhrmK1fUNunfJJKL4cP183VJPZpftu/jkFuNyHCqSx8g1g4Obw9RprRYozRdbir2b/OTbUrxtI7D4ZWxKzE2Uv1olVsCWOGh01vMxSJYCdqbANoykz/tznF+e4AzLoecAXdW6+ueXXu5ieNSNJ5I1Ni+alkWXgDv/u+RSmaD4/8xh3c9UIf1q8UJTt+ywTxLIqXWaBBNzOjKWGOOZ9S3cT/NUdzqD6Gt6cke/ES1G+Qm0BXr+IhiBa7A4PPZOdqwb2UwTsyY7Ow7b3PlpybKIIP95lZNAr4boDSx9za+EemEYstjCPPdisu1Mww==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MW6PR02MB9936.namprd02.prod.outlook.com (2603:10b6:303:243::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 02:21:40 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 02:21:39 +0000
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
Date: Tue, 27 Jan 2026 02:21:39 +0000
Message-ID: <C14B59B1-B024-44A1-BB37-49FC6D3B6552@nutanix.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
In-Reply-To: <20260123125657.3384063-1-khushit.shah@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MW6PR02MB9936:EE_
x-ms-office365-filtering-correlation-id: bc08854d-a035-437a-e0ea-08de5d4ace03
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z012YmcxdTFLQ3JsaTMwbFNzVlQrc2VsbmpoZzJNeU5GbTA5T1RTMVRVSDBF?=
 =?utf-8?B?TFo0VjdjT3JzMENkYmJQUDdiRFFFanF0RWlYbXNoRFRWOHFNeEhsQ1Z4Tlhi?=
 =?utf-8?B?S2pLWGs2bXZtd1hOZHBJUmgzR2dBOVJnNGZLbnZCRWhzbUV4K2xBUTBpNUdT?=
 =?utf-8?B?L0xhOFhucm1KSXNDaUxYMFJpdWFLZGJ0ZitqQWlXWUNxTFo4MWhtRlVwekgy?=
 =?utf-8?B?SURlTW1GaWNoTUxobXAzdFRlWlBCd21MR2JZL3hYUm4zZk5IdFdMMEROc3kr?=
 =?utf-8?B?N2N1WUI1RjdrRFdKV2xIczlwdEtmLzd0MnU3eEhVU2xBbFQvV3J0VjBONnZX?=
 =?utf-8?B?MFBBaXkyMktUQWdzMHEzTmlkdFdzUzlCN0dDS3V1RlBYL1lVNzBSVlhnTmM2?=
 =?utf-8?B?WGc3eW5zQUxTYWZwdW5YNUFwazF6ZUFTMEc1OENwSTZZblRNdE9wZjRubk1B?=
 =?utf-8?B?MnJvMEJPWk5waDNYakJzUDROTjFUc2I2TFVkVGxlTmdsN3RjN0t4SzFLYS9S?=
 =?utf-8?B?bHh2VWhlWk5PTmd4U2hwVzBzeEJha0dpZGwyOStMRmhMak0rSm02T24zdVZh?=
 =?utf-8?B?QkdJTlRNcUZvbzI1SHlRNUdqOEM0Q2MvbHdnUFdLYVNSdk5JK211akNYejlC?=
 =?utf-8?B?RTVXdkF2RnNuS1Z2UzJ1amFZZ1AvWVlpalpGNGxxRytiTWxRc2Fja2YzSUpY?=
 =?utf-8?B?N3RPWFJudWRvbTVpRER3YjRHRC9nS09jM2V4UUxmeVdwVis1eUI0dmxiVTJx?=
 =?utf-8?B?Z1FtbGpVdDhqSnlJb1BBYlRaaWh0RVlvcHIzMDFCM0J2NG1VVUEzOVMycHhr?=
 =?utf-8?B?WkxleUg0aitWaElUZndhWnpKT1VQaVlQblhnYnBUd0tZTU53OWRWVEVVT1pT?=
 =?utf-8?B?NTI1UFBKRlZSenBVTElqYkFFZUVZa0FBeFpmWmI0Y2tHdlBBUWxzc3Jlbkp5?=
 =?utf-8?B?TzgvV0Q4SWVHRU1LWFovZEM4WkNmaHltOFJkZlpVQjEybnZpamM5V2wyc2xu?=
 =?utf-8?B?M3ZJNVp4aVpSS0FzYy9NWTBGbXFTcWxaRStWdkUrcEZnYU9XSjFQTjhuSmhv?=
 =?utf-8?B?RTdYcGdhZ2VjNXBjVE56dTAwSGxsNnBpRmdSTkxmd2QveHFZMVNUVjg1cCt4?=
 =?utf-8?B?ajA5WE9qRmNUaWJpT2RxUE9zdi94MmFMelpieTlRV2phdG9sQTcyY3E0bERm?=
 =?utf-8?B?LzZBSnkwdExObVpicUtGS1dmOGp3a0hrTzN0OXc1SzJLaXdvY1lhb3NaMlhJ?=
 =?utf-8?B?T1lsdDhkVDJzRWE4WkR5N2pqMWc1TzdYYzFwOFBpOStxU1NCOGNnbU9iQlRQ?=
 =?utf-8?B?T21yS09aVHhMV2dyZ2lJRjZNVFRFYlQyYTB0ZE9oNDJWZHVxc2tFMmUxZ1Yx?=
 =?utf-8?B?cWJGWnVjRVdtYnpMRFU2QStPSWpaanlnaHdLMVIvTiswZW1oWHpEdExKRkFM?=
 =?utf-8?B?Zmh5MUhQZWxZTHgzSTVNeHBpcjZJMVp1eWZHUGRDRVZZbWl6TnZ2THlnMHpv?=
 =?utf-8?B?WGZKNXZnMXNXMjBndHZUYUdka29lcGI2OEd0VEhJQXJ2NGtwZytFeHJ6aGNK?=
 =?utf-8?B?am1hNjYxenhPMlhLS1JUcURLWmJMQXErdHFIdFB3K1plZHFlQmlCeGZxTzZO?=
 =?utf-8?B?TXUzMTJmVXdITXkrS2ZJUXA1czM5ZEhTQ25yb3R1dFVvL1l4ZVo5bGR0YUJq?=
 =?utf-8?B?OGpxMEZ0dk5JMndUQlgvaTQwUzZzVGJnZnFzK1lKdEZaOFlOeCtuZ2d3bTFI?=
 =?utf-8?B?ZmJCbENuVER0L1RYaHg2QzFpRkN4UE45VjNSaHVOYytnTEJsa2NCallHMEdn?=
 =?utf-8?B?SlNaYVRDSGpxV3hnWmxKVVV5WlpyMHl1Vk9MQWtuSmxlRldHdkVqand1aGFm?=
 =?utf-8?B?MExXMERsdlJ0VFhkenZieEdzaWkyck1LWk5RZHhQY25GcVg1MUtKa3BYc0k3?=
 =?utf-8?B?VVpQUDJ2K2xhVTlkWlNQSktGMFNIbGJRSWxHSGtKTVJlU2w0UE5wQkI1QWg5?=
 =?utf-8?B?VFN3czBPa0NKYnQ3bGd6NE9PZnd0RFBUZFFXbWJFRmVFNmlIK1psTW55bWRj?=
 =?utf-8?B?OFVzZ2JHUE1taHo3VVIxVUJZdHV3ZHU3eWF0L0xKSmRaeGlpS0Z0UUVScThV?=
 =?utf-8?B?cjRBT2pwemxQYjc0RTE4RzlXWjhNekliZTk0MFprUk53VlVLZ0Z0eG5FK2M0?=
 =?utf-8?Q?plfOeSGxsYhDrXDFubTuRqo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z1NLUUc0Y1BMMDM3WGdSamxnRXZ6L0prR2xsNXN0bWxIV3o0bFl3TnRQMUlO?=
 =?utf-8?B?d2YrQmVKcnhYNUh6VHNOK3h0Rkx1WmFyelJ2c0dxQWNlSkovcWtRNGR0czZL?=
 =?utf-8?B?Qzl3T0FZajU3bk9POWZpTEFaQXJkN2toSC9Rczd1ODA0dmdIT1Uyd2FDOGY5?=
 =?utf-8?B?ZEF3ZVcxNlNyMEtuTEN2UzhjTGdPLzFlbzhkYm83eGdvUzFENU1wNmpVekdE?=
 =?utf-8?B?VlNMSVJBQTRRRXFCc2tTWW1ONUxQblpkSDduS3V3VVR3ZVdseWNkamdiMzB2?=
 =?utf-8?B?MUt3SVdHM0s0ZVVBR0p4dzJkSDB3T1VGWDRvcEV4dHR0MFRqSGJpTCtYY1Er?=
 =?utf-8?B?Um5ud2pYZnBKak9McUQ1di9JVkdENHByMzhnK0V3TGNvbXc5UHFTN0libDhZ?=
 =?utf-8?B?L05zR25iR0FzUTYxbm1GRmx5ZU0wdmdFTzJDeDRrVnM1cjFjZXlWM01CcHZ3?=
 =?utf-8?B?WUNxbXNxTE91LzdiNEdNNDBxZDBTSnlaVjZ5TXNobGZWNWFQSUt0Ni9vZnE5?=
 =?utf-8?B?RksxS1dSSUF0Zm1tdHlZaUh3aWU5ckFaRUlFWVFyTlZmS2hLaU9zK1prb0ly?=
 =?utf-8?B?TE84WWJLR2FDTTFtaHM4YnJmVy93cFpkQnhYalJVWC9SRkxVMzMyenIyS05j?=
 =?utf-8?B?bXpXT29aT0dYYW5CaFozZDd0eVdzV2t0Ynp5eUxiZjU5OE93Y2I1N2VtM25M?=
 =?utf-8?B?UWRHUFovc1dENzZreWZZMWxZWUhSbVc3UWRvNHJLN2JyVVAwNHVvSlozaE1a?=
 =?utf-8?B?ZXo1OUhwYXQ3VmhWZnR6VWVxWkVIdzc2bUtodHdiK2phQnlNWVBiMTUzNVlG?=
 =?utf-8?B?U0R2bnZJdE4rWEV3ZDZWLzRzVWtnWjdUb1E3eGNjdzhlSkJqNzdmWnR5Q1hs?=
 =?utf-8?B?N25udThQV3NzSEphUnp3dE1iSlhic0lnM2xHWU5WQnJEY3ZRMnNES3J0bXov?=
 =?utf-8?B?a2NUNXFYTGxSVEc4dFc2Y2tBVGtEVWV3S2pWdlJsNEFyUXloeFlqazkvbUFq?=
 =?utf-8?B?cktuRGF0WG93WlhBejNRMklNd3k5QzlLcDNKSGRudHBFQzB4S0xjYlhpT3hN?=
 =?utf-8?B?eS9oUVh2Wk5Ka1RZTDlSUldCWUVGREV5YlN1K3EweDRoTEE2NGRDajBDSVVr?=
 =?utf-8?B?dTJHbThuckdYVEJOSWNtZksrczNtUzkzZkRvVzFBVWdISFZWbzNCeGRMb1Vz?=
 =?utf-8?B?dGRnQUpyazJwVXIyZWZUaTl2VVhZQkY5bFRSLzltYWxacEZEcFRKMGM2ejJO?=
 =?utf-8?B?MEdBUm5FUS9jV3pDY01mank4NUx1MzdZWU04Snl2allCQ3d2NXowa1cyK0tJ?=
 =?utf-8?B?a1h5NE1zL3VuNTFoaFI4WUhrd0xYVFdIcndNSEh4THlLcTFZZE0rZ2xDemh2?=
 =?utf-8?B?Vmo2dk5ua3pEVDNTV2k2MWhpbzRQb1hISWVINUVQSHFFMDI2WU5JNUE3M3lZ?=
 =?utf-8?B?czMxcC9OMzRiV05YT2Rib2REckZCRFcxWWIyY2tUOUEyeHJoZ3lkSTJqYnBk?=
 =?utf-8?B?YzBIOGQ3SkdaVnpjYVloMVJQY2RrTWtkcS9xUmUwZ3RGN01FdTVHQnpYdFNi?=
 =?utf-8?B?YmdYUHV2WEVBV3lrQTZZMmU5blVYUG42UG9sbHJXZTV2VkxJeDY2RFZkUEhY?=
 =?utf-8?B?dTYxWWM5UmE0WFFLMVJiK1VmSzczb3JrZ05INlIzVHp1RzNGUHd6NDdwOFZl?=
 =?utf-8?B?NGt4Y3dZNUpacUt1RUFOWmk4MnM1akVOV25VSzV3dU51R0dGVGlrekU5SDQy?=
 =?utf-8?B?OHcyMlgxcEdoa1FtTHRGeXZOQjkwMlplKyttbDJOL0NzSFN3d1NPMUgwSDBj?=
 =?utf-8?B?L293U2ZOZ01uYi91UytJL1I2VXR0WHdRUlIrQjFtQzVWMUU0elhrOFVTdHJa?=
 =?utf-8?B?V3AyL1lRVXh1NS9IM0xJMHk4TFJKMHJ4RnBRdDZHRExUSTZOWUdsRXR3Njls?=
 =?utf-8?B?cDR3bnBBb2FKYTZxbjF1aGpscThmTHpuQU02WE50SDJ0QiszVVByM3dFRC9Z?=
 =?utf-8?B?SkMzVVZZMXZBVWtMRWdOM0tKUGJlNFROa2FGcnBVSTkwNXZGZzY3dkJIdklF?=
 =?utf-8?B?ZFpVMGxXbUlVNzVxQUxmT0krS1ZPREZpa01JeE1ib1l5RWlYY0hLLzZidHVK?=
 =?utf-8?B?d2JEN09OV2t2bXZjc3pGWXdmMzVzMVFlU3J1eHNHbVplT2E1MmJrbVBnYkdt?=
 =?utf-8?B?WXFEdHVXWU9jVml6aTc1dlNFTUlFZnNtUTE3aW5oaGJUbm9vNXBWaTNKUnhD?=
 =?utf-8?B?aFl1QW9qcU9hVGRHWVU5VW5uV2RBTUcrbCtFUTJpaDlNV21XU1NXNHpOdHNL?=
 =?utf-8?B?by9TZG03cU9MdW92OVBtdlowcEpRa0k2MnBzdXJrRENmUWZPT1hTbXJDRlJF?=
 =?utf-8?Q?6L7bXXmLc76zeQWo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66F3D3D433C95F40A7519AB4DFCBFDDE@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bc08854d-a035-437a-e0ea-08de5d4ace03
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 02:21:39.8329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgSrSnCC/geNMm6pPSjn6S6vywLgGOYFAekiW4XjhupseP5ZTClskBYqzxOjJCbEdC8AHLHjiTsbPeQZdcZcp9fzWv9lezVLovKMMwrNSCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR02MB9936
X-Proofpoint-GUID: 2G39iLCeXtpEbmqTHP1bGB8PpKN0VsYR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDAxOCBTYWx0ZWRfX7lPQpn2uB//y
 Q/JHDVOqwzF4dE92xHAiNoB4itadr0bXiOh5PPVnYcWKkCQRfobE827dtk2alH9H+4nufeWg20C
 utxbrXdmZV/ZmmOZZPiMy9dvKKn3TuWV32h98RD3eJ2oF78kopwoRjnxY/74O8puJ2qjGqZWeWa
 uO9jI+CmaV0u123jm/3FEXRDDy71YtOmICtoEIaq7bK7t5q5pBY8vyz3nTJ58H2dWeHnp+L7lSf
 xpjsQway2jY/RNx8I0SBcRp9adBLT1qWdP08uUSmd4za16hKBLTu0mBmoA3pg/WG5g6y4V76rek
 3RZ9VjvYmj7VNK9D6QLED8LUs6mI0pzooqiz/M/RaqqtlWQUBMtaUNqKHV4Rq46coWXWIvJ/q7b
 T0m5QCrHkKTNTn7zXOn1PKLuMXe8rFdwXNY9v/28gxY6ozqwBsVRXNovfsmppHHMApECqa+bIOz
 YZY26REfn6TyZ7g44+A==
X-Proofpoint-ORIG-GUID: 2G39iLCeXtpEbmqTHP1bGB8PpKN0VsYR
X-Authority-Analysis: v=2.4 cv=Qd1rf8bv c=1 sm=1 tr=0 ts=69782136 cx=c_pps
 a=Yoik/vw0OvDn0K+F3zf8Kg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N42Csu5fCSehUJrjJN4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69182-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
X-Rspamd-Queue-Id: EBEF68EFCB
X-Rspamd-Action: no action

SWYgbm8gb25lIGhhcyBhbnkgZnVydGhlciBjb21tZW50cywgbGV04oCZcyBnZXQgdGhpcyBtZXJn
ZWQ/

