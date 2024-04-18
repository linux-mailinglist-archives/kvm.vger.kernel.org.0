Return-Path: <kvm+bounces-15066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 616E68A97B0
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1607F2819C9
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 10:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C1815D5B7;
	Thu, 18 Apr 2024 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CdCxPjyo";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UYjlGNOb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43521442F6
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437235; cv=fail; b=cr70u77A1f7T9sze3eXXBCte/GTi4tXJAyJiNlJNGq0WeBsKfcsGKp+3ssorYSBbRCAKgob5qCxQPan3rsBK9FzFgAd/sjAV9Xup45xRe5jHwHuvdLEC1nc82JDT2asr12SRanH3et0g2QFivtQ/0qZk2lLQ6b9hH/GoDdjxvnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437235; c=relaxed/simple;
	bh=iyKmNs1Kx281iYBEmHYjU1sPBOA6aHxJRxqy6k4NTKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iXl/rSo9kWCFf2hUHAAIBpOmIYQrKo0YQogfwq0nYpPiJpnyimYW/kL+9FuqngDE7cUpT6BYIWSelwEG+Gl+0A4C9fUPZTfWK5Sffe33c/UsjPDp/OSojXJTZt8J9aRS7f2rZOebkOWQqUQbW6hXI5lnZkdF3WeWLfO92BHOS44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CdCxPjyo; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UYjlGNOb; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43I9HwcP026753;
	Thu, 18 Apr 2024 03:46:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=iyKmNs1Kx281iYBEmHYjU1sPBOA6aHxJRxqy6k
	4NTKU=; b=CdCxPjyoLc/Lo4+TOSMHvqHKtWO1M/Z7mlJ/k4noc3d/a9845aVbCk
	i4ioPNURITpOuBAn1pw4hoJ5BgqUDn/zePvZKZOIvm8HztA9pJQo8bmTrETiNdaS
	e/4l7IrLInMuWYFoGT9OuWq7nxRbBPfvQT2YWHrwirfEceIpgPBQentXYk54IZ1p
	DXDTENAylQryVlLX5/dhylVKJaI5UvisxQo6lJBzicfLiDjG/mtcfsgzC1hQqewf
	yuph2yrYKvLRdZjVgeo0RguNcL7h0D0f8VimK7iOgztZkr107WFVt5N8nfYvC3Bg
	/zQHmMJysTpKu1xKlTI8wJXRRMut4tOQ==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3xfr5g2r0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 03:46:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9X2HN8yjF3lZidotIKt559A70mfdTxsDOvBCZ4JDaHvsZJ/lIHX1hnnhc+66DztB4uxm7GjAl4cAddJWxywQkPrxjU/3z4GRJOkFeAkZ1M8lYo30BhFhJ5tegFEZA616rWPTcf5gt5L0sukT7/tuoROXi+Qwp+r+lbzVFMugTU9QSmtw1G5yx7MJz6yO2hbT8qscBIBVp02i/wwzEIESC1IM6nAGZJCUt5VGn40EO6Pb0MGchNupHoQx4xFFnePXEXkyK+ZCE129gj9AWYmKmmzA+P7PI0Cu/F4ji9qH7gz1xH3cZv0mzW6DSrzMk7tbNUbZdIEP2i618blKvUyRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyKmNs1Kx281iYBEmHYjU1sPBOA6aHxJRxqy6k4NTKU=;
 b=Ij6TCC7te19WfpCiTWfJxr9Wl2e5twQ47eeY3YWdgqq0gga947sWtcMusDUlZ/GdsbBP5vD9AU1FLJ6PYkJOB0I7gKskcfnKJNEJAUnsvZWmx/c8LiR/hXLbIR4sWlpve0FY5La7S1xPKpzmAuGqHpBNZ+1r1VA+LAQDdUpdjN5F4Rb0XlMyUQk818eCu0CXjO3L3cgksJTMhEJJj1FEJNsD8ebtjAjUXGp9+LQBx5xuFHBZlHZko4hQ6f8it7986hSG2pG2jf96B2MG3fzB65PHpt8Y1zW7nwKcbxQCQSGPWPglG3qPtzi7dZDDixyaM4PUgPIUqFoTrlhRcWbHWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyKmNs1Kx281iYBEmHYjU1sPBOA6aHxJRxqy6k4NTKU=;
 b=UYjlGNObNQRybWDXa3ddn0+NO3E7K8JqRxORI18PXk4g3oC30CQzELgeD/49KgRkSyLs52gZJkvXKfKMvfB2P86AphAjixFHFExGnejHEiRv6W5eHBhaECBvTQh0egxe6erMD0Pdx3FMcktU6fqkcfihFtkD71RiaCWSvOGf+0nE62pflKwM/fJ0hZ7ngekc2jLMj7FQL5roukoBU9369xyFoDzBkvLGUayiKCK3xW9ykBFqDl0u7aNRSKJjVG9+KjcoNv7N6rKKH43RUdK0gTGRJgqN/gNndxmTTVT0UBb3tZ7OCqYrwhOmWGRfoNtRyqjA1qQo+kwhhWNHqwNR+g==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA2PR02MB7612.namprd02.prod.outlook.com (2603:10b6:806:134::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 10:46:52 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9%5]) with mapi id 15.20.7452.049; Thu, 18 Apr 2024
 10:46:52 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: Marc Zyngier <maz@kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com"
	<seanjc@google.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Aravind Retnakaran
	<aravind.retnakaran@nutanix.com>,
        "Carl Waldspurger [C]"
	<carl.waldspurger@nutanix.com>,
        David Vrabel <david.vrabel@nutanix.com>,
        "david@redhat.com" <david@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Topic: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Index: AQHaZP94vJDynSfMhkS84iipQRUQf7FB3KCAgBY73gCAFhjngA==
Date: Thu, 18 Apr 2024 10:46:52 +0000
Message-ID: <3D8B597C-89F2-41B5-84F5-CF5FE59A4531@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
 <EDE1F181-FC4F-4E76-9F89-C35579193480@nutanix.com>
 <87h6ghscw9.wl-maz@kernel.org>
In-Reply-To: <87h6ghscw9.wl-maz@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR02MB7555:EE_|SA2PR02MB7612:EE_
x-ms-office365-filtering-correlation-id: 0996aed0-3d62-4b41-0ec3-08dc5f94dbb5
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 5Uy9rOkld+gQd3NJXWn31ACFbmZFRv8LSgRGfmxwqQKCFGewFmoQWEbihZQkH2CzJjt5hUEmLvjcE6QBwVujMKLkr/As1alYYngHFCZdVJ/GqyspNZUcKi7n7chp4uI7iRvtxLekqNK2XRMK+74tpMhY9cbEqfLyq04a6thWNMXrp073Hnp2Fuf6K+m/SZfbWzB6cz6W4fl1Ls6BQA4AESGp+mqIoOLt3qlxbefCALli353Yqu1E3W2Tu9zU5ML1T+gF7nz2iTHgzQgQC/nrUCX8CNz1fbkqHyiTZ/HGwzG2WDZeomGObPImjFXCwJ8mce3m6TUbcruMClTmVynYP2QOx3ePLWVLPoN56NxVdwjtN6moKFA5HJhCNzOR8VWya6GxSuW1/mS9TYbuw4epCi3Cw6xhGlj07JZfEYolWoZQnkV4WXMkrxzJobYO2kMiApIsd/pCUTZw4O1nTmrxrNt2u1aBI9/+MG2J335RrgDmrIrM08SsAyuAVFEnIyFoUZONh2L+sPQXm0HpF1BaX7+mLaOmYcCdrWdJZW/AViV/bvAy2BFEOdqXMgU6jlVJBC5ORboOODo9x5jpiBDTZ78o3dQ3ss2lGNsGQFvCX4rV8iJ/O34wxWKKZvPs8sugWn022hlfyVGCAPiinpJdVlWZzolaRtoXNESEnifGJW2b2I9qvJ/eyZC9k/usrNu30Thtc6Ih9QSlArO1gRNor4IJucgI+JVdTyBMWi//2a0=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?S1RBd1hvMWs2SzlrdndvQlJQK0hlZnFvbW5rak1OOXlNWkRpL0R2ZGxEMEJL?=
 =?utf-8?B?bGd3dUZtOTljN1REM0RKVWQ0dm5CcUJYdDAyenoxWkpDc3VXOTZrb2JWaGVj?=
 =?utf-8?B?dVJWcm9XVjg3bGRvdnEwUEZnNzJOMGoyWFBJNnpMc0Q5dEIyNzhqd0dDMSsr?=
 =?utf-8?B?NEVXSkJBaGhWTHpPSG9zdEIvcno2TlQ1ZytqdE9hanRBK0hvN1ZWcm4weTRt?=
 =?utf-8?B?a1JWNmpiejNLZW10aG4rS1RveHArY25xRUVhU2k2bGJJWkF0VGdVaDYrdWwr?=
 =?utf-8?B?cEUzcWNMS3UwM04rckdISWlsNWwxZFM5NUVxcWx3anRKNHgxK2h1Y1gxNldm?=
 =?utf-8?B?R1dDSDJvdzdVa2NhYUYzTG80cjd6T1hQRlZvQTUrRThUN2RYaFdaUFNjMDUx?=
 =?utf-8?B?QUNVM05qUGxzOE1VRjlsbUk5aWFIZlkrMU5rMktPMnF2YTJxRm5PQmtzOWZH?=
 =?utf-8?B?MGQ2b3VmTlhDVHp4Y0hVRDB3TTcrOHhDUm5jQlQxNThyeXovbUo1cUc3QUY1?=
 =?utf-8?B?NG9pVCthdDRqZWV3ekcyeUdRb0pvNVlEZ2hzZmQ2ZUpuVHlZaXJjUWZFMU1a?=
 =?utf-8?B?Nk1EdHUwbmsyTkNlRFc1ZDBtSEp6QUgzMHZueDVmOTExbjVLNUFHT0d3ZUVL?=
 =?utf-8?B?YzVobVFPcndzUlRsaVFvYkpSd3hJK0h0STRrVHRUdXhEWWcvVWtJV29XRGYw?=
 =?utf-8?B?Z1JuRGR5UnhUdjYzUHNSN0IxR2VHdTdkWVJZck14ZHp2c2NLY3prazVnd2VF?=
 =?utf-8?B?Skl5OUk4SDZsRWlvTVlRNk9zYVE2RnFGM04rT0lBOXBZWGZPcCt4Si81Rk5Q?=
 =?utf-8?B?ZGlBeXM4QTBESWlHMkIwbG80ak5xdXFOMG1uVUdhSS9mcDIrTnZ3TFJKOUY3?=
 =?utf-8?B?RHp0UlhhMVdLb001ckJONTQ5LzI5WFZJVmZ1d24zUFdPeDJENTFGMW9YWllH?=
 =?utf-8?B?T2RDaUJyTC9rWmx6eGQzZzFkTlFjUFN6NGVvdzFEUGlPUUE0NnZxUWQyNEpa?=
 =?utf-8?B?NnNkWnkwZHJHMnR1TUl0QUhTTTBuK2QvWGVCQWtsSW4yRlNEekxWS1dCSm5O?=
 =?utf-8?B?eXBROUVJVEw2WTgyYXFIQjA2RUVzRmdPVzZ3ZDlkN3F5cmpoYjFoVW5iT2Qw?=
 =?utf-8?B?MFNUUW5SOCt6YmJrUUFCVGpwUGN2elVDb3Y2dmZlMzR5Q2RmL1I1aTR0NFBl?=
 =?utf-8?B?WUU1QXpSMEVydGRxMkRERXBjUnErQVlocWxkR1kyeldJVTJxemVUejJrUktj?=
 =?utf-8?B?ajgyS3lNWFVVRzU3UzB6czk1UmxPT09pemxaQjRLVG11bElJV2NYYktmV2tz?=
 =?utf-8?B?cmpYMXNzSGw5UGdhT1lqNnc0UnVYa1JMZUo0SThxUUUvaHV2LzhuNFdJUDJh?=
 =?utf-8?B?S2dIT0N4aU4rai9GZzl6Z2tScm1QbmNJTVhlTG0vbG93ZUw5MVNSdlpldjhG?=
 =?utf-8?B?bjR1U0VpM1UyVmFGRjBWK0NDY3hCRU5aNjl5MTBiMzEyWEJEZTk1dDBhVFhS?=
 =?utf-8?B?RUhleWlIN2EyQTlhSDIxREE4em9walVQb1hNRFlYT2NZOUpIbUxHWTFINDdU?=
 =?utf-8?B?SjRyKyt2eUtZM1RzYXJscGVzZndWR2tsaVFTWWR5RGRhZjhTbUUweEtvRTZZ?=
 =?utf-8?B?bjhNN2J2emlFblhDWnBEalhORFFXTEQxYzFxS1lmamZObm1NZGduYW5jalpk?=
 =?utf-8?B?UHIxeXdYU2U1Q2VSYkFLdVc0TnhFVWlzV1ZSUERqMWRZbzRiSlY1K0pjMkdY?=
 =?utf-8?B?c1JOV2hpZzYrdWl4eTBEYkFaVXpzenplcHZtenZKWmpCT2g5YTkxR1JNSGZS?=
 =?utf-8?B?Z2VPSW5HS3Q4QVZ1UmN2WHVZaHppNFBxVVV6WFg3UnJGWDFrbnFvVkcydVc1?=
 =?utf-8?B?TWQvbmZ5RzhGdUR0S2dEeGtjWERYUnZtd3Vzd1BxSVI2ZWg4cGxtdTBPM1FG?=
 =?utf-8?B?M1BlTVBrY0tzMm9VbDVHRjNqVmtRNTBSelZZMUx4S1NRaTJ5VkprY2lHamk5?=
 =?utf-8?B?clYvaUJKYjhjMnpYbEhjZ1hSNERndDBaUHFsaWR1QmZlZmY0a3NXYXVwaDM5?=
 =?utf-8?B?UWpxSVYyN1V3NmJ0UVFvZUNhWGM2STM3Z2ZBdGVXajRMUnM0RzVSakN5bTBx?=
 =?utf-8?B?dC9ObC81MG5Ha096V0l2ZDJTT2s1YnZNS0YrcXhBZ0o5RmtxaGtvQ0lzN1BQ?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45B21C43B53F9444BF006717F17CE2E2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0996aed0-3d62-4b41-0ec3-08dc5f94dbb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 10:46:52.5163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3PzmZLcnUYhP/VtP/qMc9LQj76VeXI4eymbAWKexWVQ+Vu/1JtgNW1KkOCwIAzRy5nfsirMw5ewsw/6tC8ZQtfMg97k84wSDhYEOWzTOz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7612
X-Proofpoint-ORIG-GUID: kGQfxpq9wBY2bwb135C8cAXFzBga03am
X-Proofpoint-GUID: kGQfxpq9wBY2bwb135C8cAXFzBga03am
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_08,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDA0LUFwci0yMDI0LCBhdCAyOjQ5IFBNLCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gT24gVGh1LCAyMSBNYXIgMjAyNCAwNTo0ODowMSArMDAwMCwNCj4gU2hp
dmFtIEt1bWFyIDxzaGl2YW0ua3VtYXIxQG51dGFuaXguY29tPiB3cm90ZToNCj4+IA0KPj4gDQo+
Pj4gT24gMjItRmViLTIwMjQsIGF0IDE6MjIgQU0sIFNoaXZhbSBLdW1hciA8c2hpdmFtLmt1bWFy
MUBudXRhbml4LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gVGhlIGN1cnJlbnQgdjEwIHBhdGNoc2V0
IGluY2x1ZGVzIHRoZSBmb2xsb3dpbmcgY2hhbmdlcyBvdmVyIHY5Og0KPj4+IA0KPj4+IDEuIFVz
ZSB2bWFfcGFnZXNpemUgYXMgdGhlIGRpcnR5IGdyYW51bGFyaXR5IGZvciB1cGRhdGluZyBkaXJ0
eSBxdW90YQ0KPj4+IG9uIGFybTY0Lg0KPj4+IDIuIERvIG5vdCB1cGRhdGUgZGlydHkgcXVvdGEg
Zm9yIGluc3RhbmNlcyB3aGVyZSB0aGUgaHlwZXJ2aXNvciBpcw0KPj4+IHdyaXRpbmcgaW50byBn
dWVzdCBtZW1vcnkuIEFjY291bnRpbmcgZm9yIHRoZXNlIGluc3RhbmNlcyBpbiB2Q1BVcycNCj4+
PiBkaXJ0eSBxdW90YSBpcyB1bmZhaXIgdG8gdGhlIHZDUFVzLiBBbHNvLCBzb21lIG9mIHRoZXNl
IGluc3RhbmNlcywNCj4+PiBzdWNoIGFzIHJlY29yZF9zdGVhbF90aW1lLCBmcmVxdWVudGx5IHRy
eSB0byByZWR1bmRhbnRseSBtYXJrIHRoZSBzYW1lDQo+Pj4gc2V0IG9mIHBhZ2VzIGRpcnR5IGFn
YWluIGFuZCBhZ2Fpbi4gVG8gYXZvaWQgdGhlc2UgZGlzdG9ydGlvbnMsIHdlIGhhZA0KPj4+IHBy
ZXZpb3VzbHkgcmVsaWVkIG9uIGNoZWNraW5nIHRoZSBkaXJ0eSBiaXRtYXAgdG8gYXZvaWQgcmVk
dW5kYW50bHkNCj4+PiB1cGRhdGluZyBxdW90YXMuIFNpbmNlIHdlIGhhdmUgbm93IGRlY291cGxl
ZCBkaXJ0eS1xdW90YS1iYXNlZA0KPj4+IHRocm90dGxpbmcgZnJvbSB0aGUgbGl2ZS1taWdyYXRp
b24gZGlydHktdHJhY2tpbmcgcGF0aCwgd2UgaGF2ZQ0KPj4+IHJlc29sdmVkIHRoaXMgaXNzdWUg
Ynkgc2ltcGx5IGF2b2lkaW5nIHRoZSBtaXMtYWNjb3VudGluZyBjYXVzZWQgYnkNCj4+PiB0aGVz
ZSBoeXBlcnZpc29yLWluZHVjZWQgd3JpdGVzIHRvIGd1ZXN0IG1lbW9yeS4gIFRocm91Z2ggZXh0
ZW5zaXZlDQo+Pj4gZXhwZXJpbWVudHMsIHdlIGhhdmUgdmVyaWZpZWQgdGhhdCB0aGlzIG5ldyBh
cHByb2FjaCBpcyBhcHByb3hpbWF0ZWx5DQo+Pj4gYXMgZWZmZWN0aXZlIGFzIHRoZSBwcmlvciBh
cHByb2FjaCB0aGF0IHJlbGllZCBvbiBjaGVja2luZyB0aGUgZGlydHkNCj4+PiBiaXRtYXAuDQo+
Pj4gDQo+PiANCj4+IEhpIE1hcmMsDQo+PiANCj4+IEnigJl2ZSB0cmllZCBteSBiZXN0IHRvIGFk
ZHJlc3MgYWxsIHRoZSBjb25jZXJucyByYWlzZWQgaW4gdGhlDQo+PiBwcmV2aW91cyBwYXRjaHNl
dC4gSeKAmWQgcmVhbGx5IGFwcHJlY2lhdGUgaXQgaWYgeW91IGNvdWxkIHNoYXJlIHlvdXINCj4+
IHRob3VnaHRzIGFuZCBhbnkgZmVlZGJhY2sgeW91IG1pZ2h0IGhhdmUgb24gdGhpcyBvbmUuDQo+
IA0KPiBJJ2xsIGdldCB0byBpdCBhdCBzb21lIHBvaW50LiBIb3dldmVyLCBnaXZlbiB0aGF0IGl0
IGhhcyB5b3UgdGFrZW4gdGhlDQo+IGJlc3QgcGFydCBvZiBhIHllYXIgdG8gcmVzcGluIHRoaXMs
IEkgbmVlZCB0byBwYWdlIGl0IGFsbCBiYWNrIGl0LA0KPiB3aGljaCBpcyBnb2luZyB0byB0YWtl
IGEgYml0IG9mIHRpbWUgYXMgd2VsbC4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANCj4g
LS0gDQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5vdCBw
b3NzaWJsZS4NCj4gDQpObyBwcm9ibGVtLiBUaGFuayB5b3UgZm9yIGFja25vd2xlZGdpbmcuDQoN
ClRoYW5rcywNClNoaXZhbQ==

