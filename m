Return-Path: <kvm+bounces-39626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58315A48926
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1627F7A68BA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40A726F44E;
	Thu, 27 Feb 2025 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vUzKILRg";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tzMKpJEl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F8270054;
	Thu, 27 Feb 2025 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740685236; cv=fail; b=M9fSs+0qniAsN3kqO0tK/mDKACSntq+JUkQnQrJ0tF9belGIAVm6WSyvOoDMj3z5vbYZYeEcWuUyFJb78uWf7PRn+sCb9pKzidkWmRNLdhlK0lWfRiEgUDePHlybs9wX8UdtiftXpGFSRC66jgKVXtSqpGgUS3FCiP6SsEwut38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740685236; c=relaxed/simple;
	bh=lnhqln/zG8YzcrXlC9WcI4Resr1FeQ713hcIY+fEWgs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RBMwSpGioC7MEITRogjaZ7NTE9dG0aKELqAtrvQoyDPRRwJCA1sl5CRWX80+CnjVg1W3PvuEaQA7032RWChCPhc0UuFJI4cDE12M1guw6S27Y9cyWUDmL0GBKxh0HIgsB0L8g3sH3YJa5T/E7Glen3hFBweXDeknkzX58kuMWi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vUzKILRg; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tzMKpJEl; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RI832A032193;
	Thu, 27 Feb 2025 11:40:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lnhqln/zG8YzcrXlC9WcI4Resr1FeQ713hcIY+fEW
	gs=; b=vUzKILRglntspgBA/2atqXi5lPkgM/72efbOM/436i5Tkl96LZMZdEDM4
	Sp319Betoh04bMt2fEySeoE+Ype92CifcoUTF+i3v6HyZLYbrq5PRMSvYCalXAuK
	C4bfk8OwMwmDsf63xyzvE85dkyCN41Ks6NGhlJmlo1FYZXFLqS4+QuWXHTCLqKrd
	ePO1BkEvYglJ3+8QwzsZFkVmGsjJTWJqSR93DGc1KfFW1rRz21TdYqzaQoWhnN3u
	t8P3NGkaS5q2pTRXrWZhDivniE0qhhCgvZBw3WnwUfbpW+QnbpzzIEYNME+WZsgk
	N5eVZBhFox1SHYuneIDj9BEUHcOAw==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 44yesfpmsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 11:40:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O3MSYKRGzbni30InLYgJOwub/ffCRhBQU7y9vektktGIsWumzKcCLD7fCRFVCPWI7jdxEaeR8rZR5qPKGvucjyI5IkQWAXYjt+pPdkWIRsUkMhSMb8VrtEPrdwByob4M5iB92MKN7xGkwBoJJ1Dj1jB+YAgIAlOC3KQd3jjdOuLlsi5HpLMm1R6gkOqsWzTYYy8/Njc6q+a3IAQyT0rn3iy1hdj+hSPLh9l/3LTesroONRprqGJ5WyoKBb2hb9xWhy8wAXqsOIlBgoO5a9UxHRPZI9avSZmCRRK9IwkErJSzg+pmznRxApTLzdvWd/oaUVJdk051RFG+mlIdsd0XoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnhqln/zG8YzcrXlC9WcI4Resr1FeQ713hcIY+fEWgs=;
 b=O1A8YFS+ThryhVUrEuK3T2U84hM8MazF/2I7S88QM7MdpjJTEBf1V9vZ9VZDbL3likfrZl8kV91cikg41pcnNd11Oc1agaEI6Z+P//NDsuOefQCjTDizpOo4Nh3oQqafoedR2nBqLnnu3xtQ3h9Ip6HSPfVY8DJnMyicxIgbWUeF5K1zc9h6X9voMsqdBfiy9evaOkG7VZl1MXwC11tP3VKi9IZ6sF/P3r8/kKSAT4CKdNTWy3TOZItywoml2f5uLEncx6aKhSWKdVlvIfwzv1Lpec6zPYOQa9HakleYMiUU3M4fMqqvkTwgTFEsQIoRjUk4XcWBCxI+Dbjv2Pb20Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnhqln/zG8YzcrXlC9WcI4Resr1FeQ713hcIY+fEWgs=;
 b=tzMKpJEl0M4dQ97lwvly1BMv4Aqnks0oBfKT+EJswpkAgFvY++EhJD5IgrnqAeVhIpRJfuEpa18oJj/8GGVKci232F7nD9McGZvNRoSRAHcmX7DOXJl8zwMKygORGUnyoOKpTI+8Q27AdqKxsmWeKeqfFhEfQYy9Yf38A1oXdcnYP0Nih1HjATBzDR923tTq+Tk1Kcj5YHhRbX2vi0iTL4EGncmlyl6aSR4q8bWXmzIhY7QQgd+JghU9hBmLyTbPu8PadVAG7F0RLgAZ7qSv2KVLe/hLVUQXYh3GZttfus2Kz1E/LEZiZ0qOlmB/g1hayEIjl/MoqB4m1cXBZAnCDA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9369.namprd02.prod.outlook.com
 (2603:10b6:8:14b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 19:40:23 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%3]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 19:40:22 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Nikolay Borisov <nik.borisov@suse.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
Thread-Topic: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
Thread-Index: AQHbiKuSz38dKdLINEOJF/kN397UALNatxIAgADL5ICAAAjlgIAAAaGA
Date: Thu, 27 Feb 2025 19:40:22 +0000
Message-ID: <4A1B24BB-E351-4F98-8A55-F2FB9F45BBF8@nutanix.com>
References: <20250227000705.3199706-1-seanjc@google.com>
 <20250227000705.3199706-3-seanjc@google.com>
 <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com>
 <88E181D6-323E-4352-8E4C-7B7191707611@nutanix.com>
 <Z8C-PRStaoikVlGx@google.com>
In-Reply-To: <Z8C-PRStaoikVlGx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|DS0PR02MB9369:EE_
x-ms-office365-filtering-correlation-id: b2dcf1d3-3ca6-48a9-a9d8-08dd5766937d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S003UmNxOVlPN200dnVXVU5sa1Byemg2YmxWZFFtaHBXa0llZXZGYXpTVitJ?=
 =?utf-8?B?OEgyZGhWeVlHSzgvVHZDTjByVFhIT3lGR004cVo2S0JKRHlRYXhhMDVPeEph?=
 =?utf-8?B?S2FOY3pRVWplRUhFODFxVHM5eFNHSjBxaDdkZjZNRjNFRmZWL3BRdEFqaXo4?=
 =?utf-8?B?NmZFQlVlcFZGcDFRSU9kNDk3SzliR0NNTHpXalVJelY4cytLWEgxY2VCR3g5?=
 =?utf-8?B?L29WOXJSNUhKd1lSYnFtTnZReE1RN20yM3hCcG9KV3JNRWV6bTk3SXljL01o?=
 =?utf-8?B?K0k0MVNqSXVUSkZNd0NrWlhDcDZvVlVqMWc4V3lEdnl4SWpQcTVvMHREM1hM?=
 =?utf-8?B?bVZBVElQcW9yb2FaWVprU3dLVkRLNlBYY2hGQWFqNzRET3kzY3N2ME9SM2Jr?=
 =?utf-8?B?SzhsL0ZxTU5ZRXhzWWhGWHMyeFE1cDZ6YnZIbDJQS0dYTUkwYk1MK2pIcG9D?=
 =?utf-8?B?QUJZSUVGa0hrTlhDdGlyckI0aTgvMC92QWlNSy9QWjJ5OHVaaTZRWFU5aGhu?=
 =?utf-8?B?TnVkcjN0Rk5XRnU0UDg0eERQcVRIQnJ2ZDVWMnVNb0hTOFZUaFduUnhuRUlk?=
 =?utf-8?B?L09TbjNBSk9FcWlWODIyNmFvbDRxdE5lZTJRVFFZSTFkN1ovUG5kV3JBbVRR?=
 =?utf-8?B?MmwzUFJqNlkwYS9Lc0oxUitod21XYWxkOWpZOWR3RkM0ZmtqTlZlbzJKYkRL?=
 =?utf-8?B?UnVtUkNCWTdYQ1lNbGNaUXltNzBibTJGaEZiMXJTZlgzQU9XanNLS3QrbHR1?=
 =?utf-8?B?WDFtaEpBbEtHMGVDVDFRVXN2UW53amZWVDEwNEhjckRXWkNNR01jcjdDSDJY?=
 =?utf-8?B?MFRGUDZrenFqZHppVFpGV3VpQ1JBalIxbGhCUXNHbTd3T1R6Tm5UNTBTVi9p?=
 =?utf-8?B?cERMTm1HcUVjSjVnRmE4NjJkVTVXMURISDN6V0pUM3J4bkc0N3A1S2dVRDRK?=
 =?utf-8?B?MHpGVmY1T1hmUUJheWsxMkcwZnphQ1hESXArRWFJcnc3TXFnMDVFU0tIc3JG?=
 =?utf-8?B?TXV6TldzN2lBNFNRZi9NR3VXR3k1OXdzbXoyQ1VBZ0pQMjZDM1l1S1d1b1Y3?=
 =?utf-8?B?b0luNHVkVStJSW5DTVVJVENvVnZIckNHdVRpeXZ0ckw4ampSVWdCY2VBSSt4?=
 =?utf-8?B?YlVVQnVjQllTcWVFd0huMjUvYjY2VStLRUxSaTk2d0w4bW10UjBvbFRqY1RC?=
 =?utf-8?B?SEhoTzV3bzM0T3NucGNkajZRaEtOVjlrZXhESnltYkZuRk9yRXhVZUxldGxM?=
 =?utf-8?B?ald4ZkhITGtKQWlVelBlenh3UDM1YzQ3dEtvdzRPWUtVZlIrWlBtaThlcVQw?=
 =?utf-8?B?dEY5SjduVmt5OEIxWnllcFNiSjRmaTRwYlgxYUVFcGFYNVZtdUtDRG1YWEVY?=
 =?utf-8?B?K1ViNVBGa3NiUnI2MzZOVk1wOTB0dEtDWUZXUGF3a0tmTi8zSUd6MG9GalJ1?=
 =?utf-8?B?ZW9LNURqZys3YVNyRUE5UmdQMzBNd2t5SkdrQ1hnb3lxK3kvNThxYVNLdmJl?=
 =?utf-8?B?SXVwK0huUzNIa2hkTFJRZ1A3eUl4OG1RQTFkQVdDdmNmLzc0TER5b1FvVzNu?=
 =?utf-8?B?K3Z6dEp6MDNSNHUzQ29FdVVKZmVtZ1c2Q3R1VGpvR2ZaSUFwMElJUTZ5WDFR?=
 =?utf-8?B?TzlSdm44SXkxUUR4Y0JzM3VTMzlyREpDZGFReG9WRlYxblhWS3V6ajVkRFpF?=
 =?utf-8?B?Yy9NaUpuY1QrU2F6RFRIbWdBTGh0V1lBUUk0T2dvclZLU2VzOUo1ZXVYdU5N?=
 =?utf-8?B?azM0d1RYT1JQWWtYaUxtUGVxNkFuVWU4TGtBT0FhelFRWHdobUdSZXNQVnVv?=
 =?utf-8?B?cGh2SGJqNWoyai94YXJIeXNTVzB5RGpxdXJEZ0wxNDRRejJhbHN4SjFnYk5K?=
 =?utf-8?B?RlZaTzc3WWN0c1FmZVBFOE5JRUMvYTF1OTdWMzBhbzlCVW5iOCtBK2V0WnFT?=
 =?utf-8?Q?HXZ2N/MCkQ0xrldFk0rYpjjZLcTd/Tuj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V2NQYVBQazFuSjExd1V2d29kbjFqU0ZnRUpTVU16NFRyVEpCTmhuaUx5RGs3?=
 =?utf-8?B?SXRBNHQzNTJJbjN6ajRBNTZodU1aU0greFFEQ2ZzMUFIQlYwZC9iTHhERTZL?=
 =?utf-8?B?RVpmWU1tT3NXdzFJUkpjMm1kclhQRVNPTkxjR0p1ZU1WaXN0WnpBZmJtemhU?=
 =?utf-8?B?L08zOXh3V0hVdkxjcHp5d1RqbkdudmN6ZVpVeXRVUUZPT2hIUHpNdjJUeTRU?=
 =?utf-8?B?Tnh3S0FwcmNiK3o3aDhtWThaZGl1c0NiMEdyL2Y0VkVsMW0wMEErU0hxSWZU?=
 =?utf-8?B?eklDaFdmV0hjSkZPdlNvQXBibXdoU0lxbkdTSzh5dEZnTDUrdUE4SzV0NlFh?=
 =?utf-8?B?QStWTGtkRE1FWWRTSnNtTUtuVGFaVnJ0L0xDaXVLZmY4OStyKzBVOUlvdmpF?=
 =?utf-8?B?OEkrWFhpNkw4cHZoM01UOFNzVWxoaVYrSHB2VmdwYUg4ckhWY3labVQwS2RQ?=
 =?utf-8?B?WFc5QU5qNXhWakYwb2RyTG1zNDQ0UXptSzlKYmlKWkRKVm93WWR3TWlrOGN2?=
 =?utf-8?B?OUhjZnJmMEJsbTFoVC9JYVUwdzd1SDNHRHpKSTFuNHFrLzJrNndCODlabXNY?=
 =?utf-8?B?bzg1MmdPWjdleGJiTDlSakwzZ0VYMUprNFlDNGJaQVBRU3ZGZ1ZSbmJMV1hy?=
 =?utf-8?B?eEJmN2ZpZ2JwRjFtR29rclFJR0RnbmtHTzExMExyelV5bjRKY1FtWVdDRE42?=
 =?utf-8?B?aTFFRnBSaUhQMW9lOGUrK3pyNGVqbmNBZUZPMEdubXNOSm9LYm85ZWR4VTFW?=
 =?utf-8?B?ZEJZNTcxZ1N6U2RrTE91UEJuL21Qa1MwMTBpVFl1UU9VdXdCMVJEaFg1TjZC?=
 =?utf-8?B?UXBFa3NCSStYZnA2dE5rcTlnUmRveCtaVnlzcmVxWmplbmVBS2g0RXliNHdZ?=
 =?utf-8?B?SGozMEtrcCtrc0dCTG1qdHp1aFBGNnZpS2JwdzE0L3RFTnlFNzg2bHJRdnlY?=
 =?utf-8?B?NFZKaENwS1A3bkVJTUxWeGw0K3B0emtoYy9XTHJOQjFUcitwZXc3RERnQVoy?=
 =?utf-8?B?aWRUWTlzeFMrMVJ1QU91MThhU2xqZTB4Y1JuQnp1cVd0OG5HdVJzYWEweU9q?=
 =?utf-8?B?Q245eC9pRmV4T3lPeUZVbE50Ym95SmhtcTlSdk9sR1VPa2RVZUZqTkJLOE9Z?=
 =?utf-8?B?SlcvbGVqMFdmQ0xCTXAvOE9sR1lTb0J5UWt2OCtwMk55dVhGL0E4dTBBbjNa?=
 =?utf-8?B?eVM3dW8rbjFjNHZqbndoR2FYZFhZTFhqcjVtMDE5UXdJZWErOXB1OGQzd0x0?=
 =?utf-8?B?VFhnZjBKblBTRE51eUkzSk1TckFrTjJGNWJIODJhNW9wTi9ET21RZE5qUHA4?=
 =?utf-8?B?Q1dnZk9JRlFhdWpmTGE4MG1pYzdLb2VrME5YNFBJVWNUSGNrTk5QMVVzMVRv?=
 =?utf-8?B?K1VkZkFCZHZQbmFvSm13a2tFTHpNNEpiZVRaQW5aTy9FeDBJYWdBRmpoeTZk?=
 =?utf-8?B?dUlrKzJaRlJ3NHRpRUJhVjR2UVN1OEdkTUNRRm9xd0dmNGQ4S0VrU2Z1c0l6?=
 =?utf-8?B?U3E5ZEJvZHplS1dlT24vZ1NJTDVXWk5FWmI0c2hTTnJtNmZNcmVkWDVuZzN3?=
 =?utf-8?B?V1U0Tk82bmQ4a1BZd1NBemRQMW83WGVKeG9SRFU0L2tCNGhGREh5V1FtZitR?=
 =?utf-8?B?YWZZV2FBUjZtdERJMERwZFREdzgwdkcxN08wMU15TkRuZmdxbWZRRHFYWCtB?=
 =?utf-8?B?MDdYNEJHa2FhcVZyNHpaVldtdzc0THljZ2FoWFprL3BIdFJiTDZvWWdMYmFq?=
 =?utf-8?B?NkhUUy92VmRrajJRTXBQcVlOaEdwM2xVMnVIZTZ1NDZHcndORVNybTZBY3dE?=
 =?utf-8?B?SkJ0S01tSXVFM2MxNXN3RXZ6Ym5lTVgxa0VDT0I1dkZiSzRLVXpraUE5VnEw?=
 =?utf-8?B?dEx4V2VBQ21Vc0c4UzJmNzhoUUFPa0pTTnNCTEkvT2gyc0h0MzBoMjVpVFcz?=
 =?utf-8?B?cHpSVk5zb1JFYTFzRFVXeE9UM2k5Z0ZTNXFHdDNkSk5xTWJMUFowV3ZiNEM1?=
 =?utf-8?B?VVFpQzJ4eDVnNldtQSt6dnBlbzRMK2luMEttMDFuMHpvODNxZkljZUQ2UFpW?=
 =?utf-8?B?emRvZnRBQlpjTnE2Qi80bWhpMUIyTE1WYytHOE9nei9zWWd3SjkxcTQ2aEZF?=
 =?utf-8?B?ZGxENnZ0bjhXNzRVbm5OV05WVXJvL2ZBRjVBVllmUEJnRTdqcmxCMGx1Tmh5?=
 =?utf-8?B?WWs3V3VVUlE2NVpNeDJ5YjVPV05YR0gyTFBiZ0NQcTZlRlhHNmpPSTNFN3dx?=
 =?utf-8?B?MFh5bnNpRytlSE14NkVhWlExMG1nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57C9C4E10BBA504FAFBD0A04BA806843@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2dcf1d3-3ca6-48a9-a9d8-08dd5766937d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2025 19:40:22.9134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /c2/TQoebxT/hppCkTaaql6k3xvSO9zLGcuPEvM+dqwCT5blPgcV6GdEQAii4/Rk7iMQ4f4pUCPzoa1dWXPw92bLjoPDLatKnSwQnLfvX/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9369
X-Proofpoint-GUID: FMuR2bQNd80-0Tj7AAWRMwUk4fIOqx2N
X-Proofpoint-ORIG-GUID: FMuR2bQNd80-0Tj7AAWRMwUk4fIOqx2N
X-Authority-Analysis: v=2.4 cv=ROdJH5i+ c=1 sm=1 tr=0 ts=67c0bfa9 cx=c_pps a=2bhcDDF4uZIgm5IDeBgkqw==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=0kUYKlekyDsA:10
 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=64Cc0HZtAAAA:8 a=ZvLDo4yYH1RqbTB5dlUA:9 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_07,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gRmViIDI3LCAyMDI1LCBhdCAyOjM04oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgRmViIDI3LCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4+IE9uIEZlYiAyNywgMjAyNSwgYXQgMTo1MuKAr0FNLCBOaWtv
bGF5IEJvcmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29tPiB3cm90ZToNCj4+PiANCj4+PiAhLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gTm90ZWQuICA6LUQN
Cg0KU2lsbHkgSVQgIQ0KDQo+IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IE9uIDI3LjAy
LjI1INCzLiAyOjA3INGHLiwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+Pj4gRGVmaW5l
IGluZGVwZW5kZW50IG1hY3JvcyBmb3IgdGhlIFJXWCBwcm90ZWN0aW9uIGJpdHMgdGhhdCBhcmUg
ZW51bWVyYXRlZA0KPj4+PiB2aWEgRVhJVF9RVUFMSUZJQ0FUSU9OIGZvciBFUFQgVmlvbGF0aW9u
cywgYW5kIHRpZSB0aGVtIHRvIHRoZSBSV1ggYml0cyBpbg0KPj4+PiBFUFQgZW50cmllcyB2aWEg
Y29tcGlsZS10aW1lIGFzc2VydHMuICBQaWdneWJhY2tpbmcgdGhlIEVQVEUgZGVmaW5lcyB3b3Jr
cw0KPj4+PiBmb3Igbm93LCBidXQgaXQgY3JlYXRlcyBob2xlcyBpbiB0aGUgRVBUX1ZJT0xBVElP
Tl94eHggbWFjcm9zIGFuZCB3aWxsDQo+Pj4+IGNhdXNlIGhlYWRhY2hlcyBpZi93aGVuIEtWTSBl
bXVsYXRlcyBNb2RlLUJhc2VkIEV4ZWN1dGlvbiAoTUJFQyksIG9yIGFueQ0KPj4+PiBvdGhlciBm
ZWF0dXJlcyB0aGF0IGludHJvZHVjZXMgYWRkaXRpb25hbCBwcm90ZWN0aW9uIGluZm9ybWF0aW9u
Lg0KPj4+PiBPcHBvcnR1bmlzdGljYWxseSByZW5hbWUgRVBUX1ZJT0xBVElPTl9SV1hfTUFTSyB0
byBFUFRfVklPTEFUSU9OX1BST1RfTUFTSw0KPj4+PiBzbyB0aGF0IGl0IGRvZXNuJ3QgYmVjb21l
IHN0YWxlIGlmL3doZW4gTUJFQyBzdXBwb3J0IGlzIGFkZGVkLg0KPj4+PiBObyBmdW5jdGlvbmFs
IGNoYW5nZSBpbnRlbmRlZC4NCj4+Pj4gQ2M6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4N
Cj4+Pj4gQ2M6IE5pa29sYXkgQm9yaXNvdiA8bmlrLmJvcmlzb3ZAc3VzZS5jb20+DQo+Pj4+IFNp
Z25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPj4+
IA0KPj4+IFJldmlld2VkLWJ5OiBOaWtvbGF5IEJvcmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29t
Pg0KPj4gDQo+PiBMR1RNLCBidXQgYW55IGNoYW5jZSB3ZSBjb3VsZCBob2xkIHRoaXMgdW50aWwg
SSBnZXQgdGhlIE1CRUMgUkZDIG91dD8NCj4gDQo+IE5vPyAgSXQncyBkZWZpbml0ZWx5IGxhbmRp
bmcgYmVmb3JlIHRoZSBNQkVDIHN1cHBvcnQsIGFuZCBJT00gaXQgd29ya3MgcXVpdGUgbmljZWx5
DQo+IHdpdGggdGhlIE1CRUMgc3VwcG9ydCAobXkgZGlmZiBhdCB0aGUgYm90dG9tKS4gIEkgZG9u
J3Qgc2VlIGFueSByZWFzb24gdG8gZGVsYXkNCj4gb3IgY2hhbmdlIHRoaXMgY2xlYW51cC4NCg0K
T2sgbm8gcHJvYmxlbSBhdCBhbGwsIGhhcHB5IHRvIHJlYmFzZSBvbiB0b3Agb2YgdGhpcyB3aGVu
IGl0IGxhbmRzLg0KDQpUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9ucyBvbiB0aGUgZGlmZiwgd2ls
bCBnaXZlIGl0IGEgcG9rZQ0KDQo+IA0KPj4gTXkgYXBvbG9naWVzIG9uIHRoZSBkZWxheSwgSSBj
YXVnaHQgYSB0ZXJyaWJsZSBjaGVzdCBjb2xkIGFmdGVyIHdlIG1ldCBhYm91dA0KPj4gaXQsIGZv
bGxvd2VkIGJ5IGEgc2Vjb25kYXJ5IGNhc2Ugb2Ygc3RyZXAhDQo+IA0KPiBPdy4gIERvbid0IHJ1
c2ggb24gYmVoYWxmIG9mIHVwc3RyZWFtLCBLVk0gaGFzIGxpdmVkIHdpdGhvdXQgTUJFQyBmb3Ig
YSBsb25nIHRpbWUsDQo+IGl0J3Mgbm90IGdvaW5nIGFueXdoZXJlLm8NCj4gDQo+IC0tLQ0KPiBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaCAgICAgfCA0ICsrKy0NCj4gYXJjaC94ODYva3ZtL21t
dS9wYWdpbmdfdG1wbC5oIHwgOSArKysrKysrLS0NCj4gYXJjaC94ODYva3ZtL3ZteC92bXguYyAg
ICAgICAgIHwgNyArKysrKysrDQo+IDMgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92
bXguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oDQo+IGluZGV4IGQ3YWIwYWQ2M2JlNi4u
NjFlMzFlOTE1ZTQ2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaA0K
PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaA0KPiBAQCAtNTg3LDkgKzU4NywxMSBA
QCBlbnVtIHZtX2VudHJ5X2ZhaWx1cmVfY29kZSB7DQo+ICNkZWZpbmUgRVBUX1ZJT0xBVElPTl9Q
Uk9UX1JFQUQgQklUKDMpDQo+ICNkZWZpbmUgRVBUX1ZJT0xBVElPTl9QUk9UX1dSSVRFIEJJVCg0
KQ0KPiAjZGVmaW5lIEVQVF9WSU9MQVRJT05fUFJPVF9FWEVDIEJJVCg1KQ0KPiArI2RlZmluZSBF
UFRfVklPTEFUSU9OX1BST1RfVVNFUl9FWEVDIEJJVCg2KQ0KPiAjZGVmaW5lIEVQVF9WSU9MQVRJ
T05fUFJPVF9NQVNLIChFUFRfVklPTEFUSU9OX1BST1RfUkVBRCAgfCBcDQo+IEVQVF9WSU9MQVRJ
T05fUFJPVF9XUklURSB8IFwNCj4gLSBFUFRfVklPTEFUSU9OX1BST1RfRVhFQykNCj4gKyBFUFRf
VklPTEFUSU9OX1BST1RfRVhFQyAgfCBcDQo+ICsgRVBUX1ZJT0xBVElPTl9QUk9UX1VTRVJfRVhF
QykNCj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX0dWQV9JU19WQUxJRCBCSVQoNykNCj4gI2RlZmlu
ZSBFUFRfVklPTEFUSU9OX0dWQV9UUkFOU0xBVEVEIEJJVCg4KQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaCBiL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5n
X3RtcGwuaA0KPiBpbmRleCA2OGUzMjM1NjhlOTUuLmVkZTgyMDdiZjRkNyAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYva3ZtL21tdS9wYWdpbmdfdG1wbC5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9t
bXUvcGFnaW5nX3RtcGwuaA0KPiBAQCAtMTgxLDggKzE4MSw5IEBAIHN0YXRpYyBpbmxpbmUgdW5z
aWduZWQgRk5BTUUoZ3B0ZV9hY2Nlc3MpKHU2NCBncHRlKQ0KPiB1bnNpZ25lZCBhY2Nlc3M7DQo+
ICNpZiBQVFRZUEUgPT0gUFRUWVBFX0VQVA0KPiBhY2Nlc3MgPSAoKGdwdGUgJiBWTVhfRVBUX1dS
SVRBQkxFX01BU0spID8gQUNDX1dSSVRFX01BU0sgOiAwKSB8DQo+IC0gKChncHRlICYgVk1YX0VQ
VF9FWEVDVVRBQkxFX01BU0spID8gQUNDX0VYRUNfTUFTSyA6IDApIHwNCj4gLSAoKGdwdGUgJiBW
TVhfRVBUX1JFQURBQkxFX01BU0spID8gQUNDX1VTRVJfTUFTSyA6IDApOw0KPiArICgoZ3B0ZSAm
IFZNWF9FUFRfRVhFQ1VUQUJMRV9NQVNLKSA/IEFDQ19FWEVDX01BU0sgOiAwKSB8DQo+ICsgKChn
cHRlICYgVk1YX0VQVF9VU0VSX0VYRUNVVEFCTEVfTUFTSykgPyBBQ0NfVVNFUl9FWEVDX01BU0sg
OiAwKSB8DQo+ICsgKChncHRlICYgVk1YX0VQVF9SRUFEQUJMRV9NQVNLKSA/IEFDQ19VU0VSX01B
U0sgOiAwKTsNCj4gI2Vsc2UNCj4gQlVJTERfQlVHX09OKEFDQ19FWEVDX01BU0sgIT0gUFRfUFJF
U0VOVF9NQVNLKTsNCj4gQlVJTERfQlVHX09OKEFDQ19FWEVDX01BU0sgIT0gMSk7DQo+IEBAIC01
MTEsNiArNTEyLDEwIEBAIHN0YXRpYyBpbnQgRk5BTUUod2Fsa19hZGRyX2dlbmVyaWMpKHN0cnVj
dCBndWVzdF93YWxrZXIgKndhbGtlciwNCj4gKiBBQ0NfKl9NQVNLIGZsYWdzIQ0KPiAqLw0KPiB3
YWxrZXItPmZhdWx0LmV4aXRfcXVhbGlmaWNhdGlvbiB8PSBFUFRfVklPTEFUSU9OX1JXWF9UT19Q
Uk9UKHB0ZV9hY2Nlc3MpOw0KPiArIC8qIFRoaXMgaXMgYWxzbyB3cm9uZy4qLw0KPiArIGlmICh2
Y3B1LT5hcmNoLnB0X2d1ZXN0X2V4ZWNfY29udHJvbCAmJg0KPiArICAgIChwdGVfYWNjZXNzICYg
Vk1YX0VQVF9VU0VSX0VYRUNVVEFCTEVfTUFTSykpDQo+ICsgd2Fsa2VyLT5mYXVsdC5leGl0X3F1
YWxpZmljYXRpb24gfD0gRVBUX1ZJT0xBVElPTl9QUk9UX1VTRVJfRVhFQzsNCj4gfQ0KPiAjZW5k
aWYNCj4gd2Fsa2VyLT5mYXVsdC5hZGRyZXNzID0gYWRkcjsNCj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IDBkYjY0
ZjRhZGYyYS4uNDY4NDY0N2VmMDYzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3Zt
eC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gQEAgLTU4MDYsNiArNTgwNiwx
MyBAQCBzdGF0aWMgaW50IGhhbmRsZV9lcHRfdmlvbGF0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkNCj4gDQo+IGV4aXRfcXVhbGlmaWNhdGlvbiA9IHZteF9nZXRfZXhpdF9xdWFsKHZjcHUpOw0K
PiANCj4gKyAvKg0KPiArICogVGhlIFVTRVJfRVhFQyBmbGFnIGlzIHVuZGVmaW5lZCBpZiBNQkVD
IGlzIGRpc2FibGVkLg0KPiArICogTm90ZSwgdGhpcyBpcyB3cm9uZywgTUJFQyBzaG91bGQgYmUg
YSBwcm9wZXJ0eSBvZiB0aGUgTU1VLg0KPiArICovDQo+ICsgaWYgKCF2Y3B1LT5hcmNoLnB0X2d1
ZXN0X2V4ZWNfY29udHJvbCkNCj4gKyBleGl0X3F1YWxpZmljYXRpb24gJj0gfkVQVF9WSU9MQVRJ
T05fUFJPVF9VU0VSX0VYRUM7DQo+ICsNCj4gLyoNCj4gKiBFUFQgdmlvbGF0aW9uIGhhcHBlbmVk
IHdoaWxlIGV4ZWN1dGluZyBpcmV0IGZyb20gTk1JLA0KPiAqICJibG9ja2VkIGJ5IE5NSSIgYml0
IGhhcyB0byBiZSBzZXQgYmVmb3JlIG5leHQgVk0gZW50cnkuDQo+IA0KPiBiYXNlLWNvbW1pdDog
Njc5ODNkZjA5ZmMzZjk2ZDBkNjEwN2ZlMWE5OWQyOTQ2MGJhYjQ4MQ0KPiAtLSANCj4gDQoNCg==

