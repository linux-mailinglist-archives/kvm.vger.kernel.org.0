Return-Path: <kvm+bounces-61277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFA9C13439
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 34C9A4F2042
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 07:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C622C3274;
	Tue, 28 Oct 2025 07:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="dWAXaydm";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b="HCK55JJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FF12C08A8;
	Tue, 28 Oct 2025 07:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761635655; cv=fail; b=rcdO6oeIZJ84P3NQjO/EzrnkVCQV0ivajU7X4SR3RV2ba0JCZ+3gdWEKO/EwHstskfBtsrQYv6oN8kTW3OOmSwZhJtyxFzr14eLTRzRoGCpGuBFe8eZGXWSHbnU7gmYAVsnxjbsTEki9ngbdXThqfdmEhBIrucsGPhwkT3+H1Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761635655; c=relaxed/simple;
	bh=9WnSRMafYr+J7jfZYyg/U06nkspBNAtIUxeh+VrIO50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B+Jr9eRaLf6e5vplBmYfop/wgQrP6ezBhwywjTFOC0KizO5Fss+YBu9Wn5TR9alKf8wyFYkfMK9txl4DIqf9W0KjkdjRmOHeRBfvuBUZvYozX0wpGMnidJtxRzM5IT2bnyacXkXhgoOlNpOvlQz5vcEzKHsllf4zuhPmWK+fc1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=dWAXaydm; dkim=fail (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b=HCK55JJQ reason="signature verification failed"; arc=fail smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Received: from pps.filterd (m0409409.ppops.net [127.0.0.1])
	by m0409409.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 59S73YUx1742979;
	Tue, 28 Oct 2025 07:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=utpjaMBjb26zeYd7ph30mG
	2pqyEb4/HJUH+gkavFgWw=; b=dWAXaydm1gvGflF5wPfizoDvoBx/79XTv/JIKr
	op67r5hDEupG9g17oshoL3btSBHzfxTnq2x9z2OzA0i+nOv0+DzO0SEAzpeW9Wdm
	PAPNFIrbfHonoBu6oOWW3B+KxdAmfBRrodwzyPyC3VZ63dlVopk4EA7XX5SBGldk
	mi7kvsyseptSr33xouEXn8XF4EYIxVsf0wAxgjCFUkSC/BOavnaeYHJOHetLTzIp
	CewBs2QaG2RX+moXzdA155FnGrc5IH29QiPRxT+kL8ZDd7PXhC2PJK59zLTgpQfZ
	3NEpbix1hljtQcHmhKA1K50HW71yvUv+yA83nmCi/d0y3GkQ==
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60])
	by m0409409.ppops.net-00190b01. (PPS) with ESMTPS id 4a285qqnnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 07:14:06 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 59S4bIYK009507;
	Tue, 28 Oct 2025 00:14:05 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.26])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 4a0vh8au9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 00:14:05 -0700
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 03:14:05 -0400
Received: from usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 03:14:04 -0400
Received: from BL2PR08CU001.outbound.protection.outlook.com (184.51.33.212) by
 usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 03:14:04 -0400
Received: from CH3PR17MB6690.namprd17.prod.outlook.com (2603:10b6:610:133::22)
 by SJ0PR17MB4855.namprd17.prod.outlook.com (2603:10b6:a03:37c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 07:13:56 +0000
Received: from CH3PR17MB6690.namprd17.prod.outlook.com
 ([fe80::a7b4:2501:fac5:1df5]) by CH3PR17MB6690.namprd17.prod.outlook.com
 ([fe80::a7b4:2501:fac5:1df5%4]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 07:13:56 +0000
From: "Hudson, Nick" <nhudson@akamai.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "Tottenham, Max" <mtottenh@akamai.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and
 use in net.c
Thread-Topic: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and
 use in net.c
Thread-Index: AQHcRyxBgawnuqxzV0OEwM9PChyIHbTWuSUAgABtTwA=
Date: Tue, 28 Oct 2025 07:13:56 +0000
Message-ID: <8A5BDA6D-21F7-40F8-8A28-0B2F57D89D81@akamai.com>
References: <20251027102644.622305-1-nhudson@akamai.com>
 <CACGkMEtyX6n9uLMmo7X08tFS-V6QZoDVTxhE53h9sLDPNBKnKw@mail.gmail.com>
In-Reply-To: <CACGkMEtyX6n9uLMmo7X08tFS-V6QZoDVTxhE53h9sLDPNBKnKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR17MB6690:EE_|SJ0PR17MB4855:EE_
x-ms-office365-filtering-correlation-id: e4aabce4-15f6-44ff-3827-08de15f18f2f
x-ld-processed: 514876bd-5965-4b40-b0c8-e336cf72c743,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021|4053099003;
x-microsoft-antispam-message-info: =?utf-8?B?YWlkWTRETWh6WnMvMU1WZ2xkRGJQaGtLa0NHSGR3cVJ3bWx2L2ZHOC8zNDdK?=
 =?utf-8?B?TXNJVlVMSEVuK0M0TUlad3huamFtY2tiOHppMjNleE9FMnV4OVV5NlpTRUFk?=
 =?utf-8?B?UU41cFlyZU9qaXdYNG93V0p1Z1d4QTBCTEhoVXBvR1dqK1hLcUtBM1pnS0ts?=
 =?utf-8?B?a2duY0xHVjFZYlJGR1ROdWw0NktYdDhIVG15TTJ2azF2MXIyUzlzSzhTN09m?=
 =?utf-8?B?Ritma0JrUkR5Tk1pN3E4TDJGS04yQ01nTnZOb0JYYWlib016RlgrWXB5d2tL?=
 =?utf-8?B?ZHAwWVVJY2hmYVRBRDg3WklJeHFJamR2eXlENTF2c2RXalcxaFRyamNERmVD?=
 =?utf-8?B?YzhFLzVIbGErZ3FuT0hZNkJudzRHV09JUXluMGFmekhPQi9NYW5UV1VLZEtG?=
 =?utf-8?B?YkJQUUdBZW1GYlpsTHFxQWlYcEVJemRJNVA1dHk5Q3R3WkhGR0s2RllaRDFo?=
 =?utf-8?B?VXgxYmlYcmIvNUtISE4xajdnZlNpblgvNUhZZW04dVVSdGVzME9WRDFFNmN6?=
 =?utf-8?B?OGp1c2tPcitaQnh6c2R3NlVmRXI2UCtFK0FwTUt5VXh6L0d6dVFnMFozNzI4?=
 =?utf-8?B?VnhZbEZlaXJiUmUrTHRmWHB3ZUZNNWlhT1hRTCtJSE1HUzJRU2tNVWhMWm1o?=
 =?utf-8?B?MUEyMkZqNmxiMFlNQWtKTXhPSHozei93MzZJTStmcXFxRUE2WldwUU0rTU9Y?=
 =?utf-8?B?MXBidVN5V1ZFeTBudlVKeE1LZW0xeW5aS0ozOXoyblppZGlTYWJJY0hha29k?=
 =?utf-8?B?YVhHNk1GT2owa3MxRkE2RnNwWlRBa1Z2aEIxMkZQRHVUOThUWFVVelZ6MGRz?=
 =?utf-8?B?VGV2cDVSZjYwY2oyVjFFVW5NZk8rNnF1Y3RvYjZ0SFlGbUlQUU1vaVVCck1X?=
 =?utf-8?B?Z041dWZDd1JqZ3gyMW5vVWRoQXRnTkQvY2YydndXR3RnaHVYMDhkUGtVSWRM?=
 =?utf-8?B?eFQzS2EzK2lzRTR6RElZcXVLb3RTZjB0R3lBRTRpamExemxXR0xKWXZJYTI4?=
 =?utf-8?B?clV5TWhBUUhYRnQrN3k5b1FyejVBeDJ5ekcvak1VRU5RZjFxbjgwODlBcmFv?=
 =?utf-8?B?TlhSVnBMOU5VV2ErM3N4dkFudHFYaGdUQVljWS9oZGpXOVEvYmErUzlOZjhZ?=
 =?utf-8?B?OEV3YkduV3lXdHdpRmJ0MU01djJYakI3VDUzT0xoc1g2ai95TXdjUDJZYThY?=
 =?utf-8?B?WGlCY1JiYVFXTk5jUElSSGI3MWl0cEVMc0FLclhRTHo3dFZRYXhVZWd1SFZz?=
 =?utf-8?B?elVOK2d4cmM3R2FRbGdRbFl3a1hkMndQeWtDMGpBRko1aSsvM1ZRckFUYkgy?=
 =?utf-8?B?OXhDVXg3dG9nUkRseUxaMzE4d0pKWmk0N05NeDR1aENOeXljbTZLSkRKKzZY?=
 =?utf-8?B?OUlaTFdZaEVWeXdNRnp2cEtpRDBHTTVnOTk0MG9DSlkyWWhqY3FJZGZaWmlm?=
 =?utf-8?B?Z0xUYTVtTU5EVW9sWDJWUFllUnZRcHZnZXdQWjB3SGQ3RXA2aitQaWUyNXJy?=
 =?utf-8?B?cDhVM1ltVWtHYWs4OEsyMnkyYTFtODVNeVFDWkhrZDlLUEswd21yNkFNZ3E5?=
 =?utf-8?B?N3BJbmZ0clZuTUg0bWtnVnlyUG14L0o3WGRUY3NiejZabTFLakxSR0RQcGJo?=
 =?utf-8?B?czFGc3o0eC8xaGpQdEhwT0UwSlFGOVZEREN3cDd2eWQzZklQWVdFNUU5TU1V?=
 =?utf-8?B?eFNVNU9DRGtFc1dyYzk5d3B5ZnZTWFNqejVUQi9IeE9LUXZFY0JLQlZuYSt6?=
 =?utf-8?B?UmVLYmdSQ0hpWUs0ZERqbjlqZFlLTEwzMlplQW1xNmljWTlaQnlBbS9JU05F?=
 =?utf-8?B?YmZSa3ZOTkhGbmV5WDV2YkZmT0pUVXNZU3hpWm9zVkVUZ3dzZTRGUXRRNFBH?=
 =?utf-8?B?WHdDY3Uza2pwbGlJdzVrbnpOQnJBUlQvVUx2NFBtbnRHbXV2QnVlbnZRTnpC?=
 =?utf-8?B?Ynp4WUFBVWhGM2J0WjE5MVVTRzFxUElpcEVIdFhMbkFoUXZuYlBuUFY0dHo3?=
 =?utf-8?B?SnQ4YmNFT3BidzE1dnplMlU0anl3ckRDZ3VUbDN3bmw4RWJWZ2dFYmlYbGhC?=
 =?utf-8?Q?snSfcY?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR17MB6690.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021)(4053099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWRqUzAzVVJPb1NadUQ2dElNMUdYVHNCbmRHUll3TjJDckkxYmp5dG1BaE5y?=
 =?utf-8?B?TWdmNktRb2NlWjV4S2lvS0JhZXhKQ1Q5TEcwY2hDc01XUEJjdmgwNUw5NG5o?=
 =?utf-8?B?M0dkQmtIWVdyOVEvZGdIM2VGUDl6Z3ZpWi9CU2Nja2d4djhVVXp4U2hVL21G?=
 =?utf-8?B?MjVrS3o2bHNYVVA0VE5hK2MrMWJrcE5vZlNVWkZ4dWhmSEQ2c0VpRDdFdkF4?=
 =?utf-8?B?RW5Gc2hYbkVzOHp1M1N2eXd2QkJNVlRub0JIWkp1MnhNVjJNOGV2dytLdjV3?=
 =?utf-8?B?WTZmR0VJVTFHU05mVzRDQ0t3SlpUMFNkcjlLZDJhNTNwUTlaYTc2U0F1T3VH?=
 =?utf-8?B?b1JLaDdpRm5pMXg1QWNLQW1uZnc0dTQvV1A3bnNodlpGT2RnWWRjNHczYm5Q?=
 =?utf-8?B?Smo3dWdjT2pmWlZUOExBOHRvQVZ0TXVaMXBoeHJ1VU5NVkNKbnRleHg1TzEx?=
 =?utf-8?B?RnA0SHk2bDdYS2pINzVUNnBHWEdrTXBsSDNpSTJOcW1CM1hoeENnUzJ6TUQz?=
 =?utf-8?B?bmw2VEsrcm83K2grMFNtM0RkSm5QNTg3cHozejcvQVFoaS8yNUlaYUNhRDZT?=
 =?utf-8?B?YVQwNmdxVzRLdk1QSzNtcURyRWZBUG9ObHlNQ2hoaWplVnZDYThjMVJubVps?=
 =?utf-8?B?QTVuMU8zajdNY1JYK1YrOFdMZFRaeS9BVmQzT2w0bHN1M0lIckExN2RveG0y?=
 =?utf-8?B?dDd3dUdLTkEvK0FTckowQW5ZbmNmM1QzVXNpV05FYU5URU1VR0I2dm5wY0xh?=
 =?utf-8?B?Q2ZBajh3RE9rWmYvVzU1a0JtSTJvbzBqSEFyenRMQmFhQndYdW9TcStCOVBD?=
 =?utf-8?B?c3BGUFJlSFhqc1NMaDk2dmkwRHBoWnBlN05XdnR3OU1qUXFQRG9BRm5nUWoy?=
 =?utf-8?B?b0ZybGE5djZJNDBzWjRzMC9McXc1cCt0VG1RWGE1d0diRjRLT3c2ZGlILzFI?=
 =?utf-8?B?WWlKbmxuUFpNdkZSa1k5dktldXNZdVpoTERYaDk1YzcvQ0hkQ0N1MGFkaW5p?=
 =?utf-8?B?Sk12dW5NTGNlSDFIZGgrSm9sdElzalR2M2p3aFJFbC9jREk1Vk93dGltdHcy?=
 =?utf-8?B?ajZjNDNZT3N6bExnZno1V2F5S01zVmRUendyM3Ftd2xjSW5jRnB5Z2VmSEV6?=
 =?utf-8?B?N1R0NXJ6TlBMLzZwODJLdWV3TGZMeXcwTCtRTnAvV0FMWlN3R0ZuTHUwZk9o?=
 =?utf-8?B?T1ZRTW1mdDB1RGs2OVY0YTN0NVVhN2dJdWxTSU13QjRoZm5KWWRuVjJoNHR4?=
 =?utf-8?B?U3RpOXYyczdUNnpGK0wyVkpXNE95MWZZVXRLYW9US0dFMHZ3enpSNFpaQnhG?=
 =?utf-8?B?ZU1XdkUybjg1S1F6eExaZE15YUsydmduTGxMYkJRSmg0Ni8xZ1lPa21Felc5?=
 =?utf-8?B?S3FsbjUvT0RQbUpmd2xZS1pMME5YdEQvNkRadEtEdjZ0NHVpdldjdWhlQ3l2?=
 =?utf-8?B?VmlNUFlNNSthUTZoMXpsaFk2R0RGQkduZmx3Y1NLZVVXT2t6OUp4dW5aSnpw?=
 =?utf-8?B?NXBkL3VWZjdpbER4NGVDaUFZKzVpS3lHZVdoWmRCS1pHRFo2U3A1VEZ4ckRC?=
 =?utf-8?B?UlQ0NE9zWXRLMjVxZ1F2alNrcTdPd1k1bW5kNG42L2VjWUNxRjhaMHdJa0do?=
 =?utf-8?B?ZFN2bFR3Z2g0NXBCcS83OGNHMHNyNnNaWFRsMlZ5K085VkxYRS83RDhzZ2xx?=
 =?utf-8?B?cjM2Mm1lVGRhcXpDZFlhLzhXbUxMOVFvQmJJZWdZbDFvYXNqNjl6R0k4aDA3?=
 =?utf-8?B?Y2loemVLcXFReUlDbDcraU5LbjFjN20vWHRpaGtzYkx2MElpSkhSaWFiVzR6?=
 =?utf-8?B?Zks5L3h0ZGpkVlV5alp3Y0lPc2FUaTYyS0FBUFMwY0J6YS9hVkhORXE3NGNw?=
 =?utf-8?B?QWxlS21MMEl4RDZaWWhBWnlvS0dHa1dZVitZK0I5Q0V0U3pLTk1sZ0pOa2ZN?=
 =?utf-8?B?WWwzcGJIdnNYazhqSUFwNVlJdXd2eUliYXlncjBaVm95cGh3OE1SbXR6bENn?=
 =?utf-8?B?REs0QmF6LytJb2NxcTc4T1JjcWJVeEwrbG1vZUNTNUhsUnQwaTByT25WV2tk?=
 =?utf-8?B?REFvSTVwU2pOUDhZRkhkbVJtVHlxN2tucHZLaHEwSzZ1R3ltd2RNdUlneHQ5?=
 =?utf-8?B?bXBjRXF0bDc0SW5rbkNyL3Rhd3ZqUHFyWEFPbUpWei9GSFN5MnZoc1RMektD?=
 =?utf-8?Q?LFgXyuiKIh0DmvWJ2XOfyqRPqthu/YeB+AWH1rl8bRyX?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTHLOM9bqPGOV7JJdW15zDXGdqAlCCeoItZZ2Gj/Os9cz06yj31S1miyY1qGZQfd/+FRGMqHAgSatofWgECY577zBlJGOotXUVlUVMqz08a/UldFBf4Nx+zX1+OQVgIHTwsvy3EHObVhwq8VSxI2qFf3tk3aW1stn9Fil8CwltoIwxhOFHw6mptaEhiK3+yZ0WLY3CiMVffJBZsA+4RFpapz7XfwYVogiFeslBkrDZ6rVKUbTldVKojcLijgrhgXzGpPKNTfhjcHfVjSjqFvKtwO459ks7pI069Jj/1BtRiH7ZqzYPOClaFX2sdBil2VtbKSlFMVovABgKFGuSX6BA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFa4nbFcBOXWOXan1zK5ts05n8z1ONNWLK5eRJWEvRY=;
 b=NP05GyqMhFxbn/nlOTiavQFbP5j6C4mk558MzHBXOv++ztDj2homWwmrOFxJsFQ9K7vHsqcm8E5l1w+6l0vr2nRpAartFAEjsUZRwdvrnSGDfLPsziCUjLXIlWFtERxCaLCMI+dAFFeBLF0dOk3eahFEVF+F8sGVS17Lt7ZkUEKmM5oGmHsdPrKLUkxKUEB1+83XMhTT/nhDpNHFY9jwDuKrE6WrlIknzE2lV7bEdzBcGF3+/nsp8+1o2ym/ioqXR8k1YHifH5H3Pu0xxus6kwHGqSDYZLO7Ugu4s/g0kXHTUbg0KRuP54kYrrnJXMDQtTpW2g4SdzliZQkhPtpHFw==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=akamai365.onmicrosoft.com; s=selector1-akamai365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFa4nbFcBOXWOXan1zK5ts05n8z1ONNWLK5eRJWEvRY=;
 b=HCK55JJQ0smwv82SwEl12NLaiUXO6RfhbMdd0cRj4lwU0/7v9qQGI5sHksAbKAdg1ni9yYJeUYfJCcsQyiBVYdCILHxhBXhK+7nnYam0OXdU+xj7688q6CT7wJ/mF8KOn21+IKQyFVCjH2oUHlGZjVgG7pj452tHLicdSrgQKEo=
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH3PR17MB6690.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: e4aabce4-15f6-44ff-3827-08de15f18f2f
x-ms-exchange-crosstenant-originalarrivaltime: 28 Oct 2025 07:13:56.6447 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: 3xhd5gqcAnLlQ0FSTAEi5Opau13wCPIhfBEmtV2himfC2YdIhwYrWSxH0bCNaoBc6aP65p56WoOxu8TNGF7YFw==
x-ms-exchange-transport-crosstenantheadersstamped: SJ0PR17MB4855
Content-Type: multipart/signed;
	boundary="Apple-Mail=_018BE3C9-B21F-4CED-9229-3F56BA3CE13D";
	protocol="application/pkcs7-signature"; micalg=sha-256
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280059
X-Authority-Analysis: v=2.4 cv=cJbtc1eN c=1 sm=1 tr=0 ts=69006d40 cx=c_pps
 a=NpDlK6FjLPvvy7XAFEyJFw==:117 a=NpDlK6FjLPvvy7XAFEyJFw==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=g1y_e2JewP0A:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=X7Ea-ya5AAAA:8
 a=NfMJYoaWcJ6JtOWycNYA:9 a=QEXdDO2ut3YA:10 a=wqFnSJPP-FBafd8uH9cA:9
 a=ZVk8-NSrHBgA:10 a=30ssDGKg3p0A:10 a=kppHIGQHXtZhPLBrNlmB:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: K2L65EcKaQKm0ahKcbaKw_CTw3ZZn05f
X-Proofpoint-ORIG-GUID: K2L65EcKaQKm0ahKcbaKw_CTw3ZZn05f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDA2MSBTYWx0ZWRfX7Q2lwFIpLBUP
 epvxPl8UESecAy0fc65XzespZu7QhRuomS84Iwme8cwVsoxQLMwP+iWBnmSKNTe4WWgK9s/swcT
 3BYQ0U0Dv4S7FRPpHnVzLcwF9aTCpZLVsAbUfthCYhy/cUc5iNicR4oIN+rwZxcd1l3tt2Dsg0n
 etFiTdZkn+mVFFUWMyB4dAmsTNQicuCqX7abhXQXKRv25T7u2qSBztp//JJPZDmk4P/5n2kuDII
 ft4EXCZbPydH+ClWnOfo9f/VKAC+tJsdSW7tjYx7XXB7tYVvj9aS0XTsMvM2WXvnx6rKjMakl/x
 199Qk81hq8m4TyeJmPUOb11GqrChlfcB41j7p1FIemn6CWNmJpRW506dMe/kDgbLrROwu6P17vL
 t6FoV1bOCHm6mcNVYQpa5wdOmIiKSQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510210000 definitions=main-2510280061

--Apple-Mail=_018BE3C9-B21F-4CED-9229-3F56BA3CE13D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 28 Oct 2025, at 00:42, Jason Wang <jasowang@redhat.com> wrote:
>=20
> !-------------------------------------------------------------------|
>  This Message Is =46rom an External Sender
>  This message came from outside your organization.
> |-------------------------------------------------------------------!
>=20
> On Mon, Oct 27, 2025 at 6:27=E2=80=AFPM Nick Hudson =
<nhudson@akamai.com> wrote:
>>=20
>> The vhost_net (and vhost_sock) drivers create worker tasks to handle
>> the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO =
that
>> can be used to determine the PID of these tasks so that, for example,
>> they can be pinned to specific CPU(s).
>>=20
>> Signed-off-by: Nick Hudson <nhudson@akamai.com>
>> Reviewed-by: Max Tottenham <mtottenh@akamai.com>
>> ---
>> drivers/vhost/net.c              |  5 +++++
>> drivers/vhost/vhost.c            | 16 ++++++++++++++++
>> include/uapi/linux/vhost.h       |  3 +++
>> include/uapi/linux/vhost_types.h | 13 +++++++++++++
>> kernel/vhost_task.c              | 12 ++++++++++++
>> 5 files changed, 49 insertions(+)
>>=20
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 35ded4330431..e86bd5d7d202 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -1804,6 +1804,11 @@ static long vhost_net_ioctl(struct file *f, =
unsigned int ioctl,
>>                return vhost_net_reset_owner(n);
>>        case VHOST_SET_OWNER:
>>                return vhost_net_set_owner(n);
>> +       case VHOST_GET_VRING_WORKER_INFO:
>> +               mutex_lock(&n->dev.mutex);
>> +               r =3D vhost_worker_ioctl(&n->dev, ioctl, argp);
>> +               mutex_unlock(&n->dev.mutex);
>> +               return r;
>>        default:
>>                mutex_lock(&n->dev.mutex);
>>                r =3D vhost_dev_ioctl(&n->dev, ioctl, argp);
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 8570fdf2e14a..8b52fd5723c3 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2399,6 +2399,22 @@ long vhost_dev_ioctl(struct vhost_dev *d, =
unsigned int ioctl, void __user *argp)
>>                if (ctx)
>>                        eventfd_ctx_put(ctx);
>>                break;
>> +       case VHOST_GET_VRING_WORKER_INFO:
>> +               worker =3D rcu_dereference_check(vq->worker,
>> +                                              =
lockdep_is_held(&dev->mutex));
>> +               if (!worker) {
>> +                       ret =3D -EINVAL;
>> +                       break;
>> +               }
>> +
>> +               memset(&ring_worker_info, 0, =
sizeof(ring_worker_info));
>> +               ring_worker_info.index =3D idx;
>> +               ring_worker_info.worker_id =3D worker->id;
>> +               ring_worker_info.worker_pid =3D =
task_pid_vnr(vhost_get_task(worker->vtsk));
>> +
>> +               if (copy_to_user(argp, &ring_worker_info, =
sizeof(ring_worker_info)))
>> +                       ret =3D -EFAULT;
>> +               break;
>>        default:
>>                r =3D -ENOIOCTLCMD;
>>                break;
>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>> index c57674a6aa0d..c32aa8c71952 100644
>> --- a/include/uapi/linux/vhost.h
>> +++ b/include/uapi/linux/vhost.h
>> @@ -101,6 +101,9 @@
>> /* Return the vring worker's ID */
>> #define VHOST_GET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x16,              =
 \
>>                                     struct vhost_vring_worker)
>> +/* Return the vring worker's ID and PID */
>> +#define VHOST_GET_VRING_WORKER_INFO _IOWR(VHOST_VIRTIO, 0x17,  \
>> +                                    struct vhost_vring_worker_info)
>>=20
>> /* The following ioctls use eventfd file descriptors to signal and =
poll
>>  * for events. */
>> diff --git a/include/uapi/linux/vhost_types.h =
b/include/uapi/linux/vhost_types.h
>> index 1c39cc5f5a31..28e00f8ade85 100644
>> --- a/include/uapi/linux/vhost_types.h
>> +++ b/include/uapi/linux/vhost_types.h
>> @@ -63,6 +63,19 @@ struct vhost_vring_worker {
>>        unsigned int worker_id;
>> };
>>=20
>> +/* Per-virtqueue worker mapping entry */
>> +struct vhost_vring_worker_info {
>> +       /* vring index */
>> +       unsigned int index;
>> +       /*
>> +        * The id of the vhost_worker returned from VHOST_NEW_WORKER =
or
>> +        * allocated as part of vhost_dev_set_owner.
>> +        */
>> +       unsigned int worker_id;
>=20
> I'm not sure the above two are a must and exposing internal workd_id
> seems not like a good idea.

It=E2=80=99s already exposed by VHOST_NEW_WORKER, but happy to drop it =
if you prefer.

>=20
>> +
>> +       __kernel_pid_t worker_pid;  /* PID/TID of worker thread, -1 =
if none */
>=20
> Instead of exposing the worker PID, I wonder if it's simple to just
> having a better naming of the worker instead of a simple:
>=20
>        snprintf(name, sizeof(name), "vhost-%d", current->pid);

This is currently the case

drivers/vhost/vhost.c:  snprintf(name, sizeof(name), "vhost-%d", =
current->pid);

I was hoping to add the IOCTL, use in qemu, and expose it via QMP/HMP. I =
have changes to qemu that do this.

Thanks,
Nick=

--Apple-Mail=_018BE3C9-B21F-4CED-9229-3F56BA3CE13D
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCCdAw
ggShMIIESKADAgECAhMxAAAAIa0XYPGypwcKAAAAAAAhMAoGCCqGSM49BAMCMD8xITAfBgNVBAoT
GEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3QtRzEwHhcN
MjQxMTIxMTgzNzUyWhcNMzQxMTIxMTg0NzUyWjA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9n
aWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAEjkdeMHsSTytADJ7eJ+O+5mpBfm9hVC6Cg9Wf+ER8HXid3E68IHjcCTNFSiezqYclAnIalS1I
cl6hRFZiacQkd6OCAyQwggMgMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFOa0
4dX2BYnqjkbEVEwLgf7BQJ7ZMB0GA1UdDgQWBBS2N+ieDVUAjPmykf1ahsljEXmtXDCBrwYDVR0g
BIGnMIGkMIGhBgsqAwSPTgEJCQgBATCBkTBYBggrBgEFBQcCAjBMHkoAQQBrAGEAbQBhAGkAIABD
AGUAcgB0AGkAZgBpAGMAYQB0AGUAIABQAHIAYQBjAHQAaQBjAGUAIABTAHQAYQB0AGUAbQBlAG4A
dDA1BggrBgEFBQcCARYpaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNQUy5wZGYw
bAYDVR0lBGUwYwYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAICBgorBgEEAYI3CgMEBgor
BgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAwkGCSsGAQQBgjcVBQYKKwYBBAGCNxQCATAZBgkr
BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNV
HSMEGDAWgBStAYfq3FmusRM5lU0PV6Akhot7vTCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2Fr
YW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNvcnBSb290LUcxLmNybIY8aHR0cDovL2FrYW1haWNy
bC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3JsMIHIBggrBgEFBQcB
AQSBuzCBuDA9BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNv
cnBSb290LUcxLmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFr
YW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFp
b2NzcC5ha2FtYWkuY29tL29jc3AwCgYIKoZIzj0EAwIDRwAwRAIgaUoJ7eBk/qNcBVTJW5NC4NsO
6j4/6zQoKeKgOpeiXQUCIGkbSN83n1mMURZIK92KFRtn2X1nrZ7rcNuAQD5bvH1bMIIFJzCCBMyg
AwIBAgITFwALNmsig7+wwzUCkAABAAs2azAKBggqhkjOPQQDAjA8MSEwHwYDVQQKExhBa2FtYWkg
VGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMB4XDTI1MDgyMDEwNDUz
N1oXDTI3MDgyMDEwNDUzN1owUDEZMBcGA1UECxMQTWFjQm9vayBQcm8tM1lMOTEQMA4GA1UEAxMH
bmh1ZHNvbjEhMB8GCSqGSIb3DQEJARYSbmh1ZHNvbkBha2FtYWkuY29tMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAw+xt0nZCcrD8rAKNpeal0GTIwS1cfPfIQXZHKRSOrSlcW9LIeOG4
E9u4ABGfGw+zChN5wtTeySgvvxE1SIwW13aoAscxyAPaS0VuEJGA6lUVsA2o+y/VD7q9pKIZj7X2
OxHykVWBjXBpRcR9XFZ5PV2N60Z2UBlwSdbiVp0KBXzreWMBXnHKkjCSdnbVuvOj3ESrN706h3ff
5Ce7grWg7UWARnS/Jck1QAEDqIHLSxJ3FhgbJZBt6Bqgp28EqkP+dQxzp//vnUDIwxBzpSICAMsk
d9I0nsdVvHV0evJSjqDgLF9gw7/4jjjQGW/ugHBytYSBEjDFuB0HOat0va8SjQIDAQABo4ICzDCC
AsgwCwYDVR0PBAQDAgeAMCkGA1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNwoD
BDAdBgNVHQ4EFgQUWgue6rVjEAcBSPcAqJXWGxAZi9gwRgYDVR0RBD8wPaAnBgorBgEEAYI3FAID
oBkMF25odWRzb25AY29ycC5ha2FtYWkuY29tgRJuaHVkc29uQGFrYW1haS5jb20wHwYDVR0jBBgw
FoAUtjfong1VAIz5spH9WobJYxF5rVwwgYAGA1UdHwR5MHcwdaBzoHGGMWh0dHA6Ly9ha2FtYWlj
cmwuYWthbWFpLmNvbS9Ba2FtYWlDbGllbnRDQSgxKS5jcmyGPGh0dHA6Ly9ha2FtYWljcmwuZGZ3
MDEuY29ycC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEpLmNybDCByAYIKwYBBQUHAQEEgbsw
gbgwPQYIKwYBBQUHMAKGMWh0dHA6Ly9ha2FtYWljcmwuYWthbWFpLmNvbS9Ba2FtYWlDbGllbnRD
QSgxKS5jcnQwSAYIKwYBBQUHMAKGPGh0dHA6Ly9ha2FtYWljcmwuZGZ3MDEuY29ycC5ha2FtYWku
Y29tL0FrYW1haUNsaWVudENBKDEpLmNydDAtBggrBgEFBQcwAYYhaHR0cDovL2FrYW1haW9jc3Au
YWthbWFpLmNvbS9vY3NwMDsGCSsGAQQBgjcVBwQuMCwGJCsGAQQBgjcVCILO5TqHuNQtgYWLB6Lj
IYbSD4FJhaXDEJrVfwIBZAIBUzA1BgkrBgEEAYI3FQoEKDAmMAoGCCsGAQUFBwMCMAoGCCsGAQUF
BwMEMAwGCisGAQQBgjcKAwQwRAYJKoZIhvcNAQkPBDcwNTAOBggqhkiG9w0DAgICAIAwDgYIKoZI
hvcNAwQCAgCAMAcGBSsOAwIHMAoGCCqGSIb3DQMHMAoGCCqGSM49BAMCA0kAMEYCIQDg4lvtCdYN
NSoA7BrmrnhzqPrsFhQejDMGHCeY7ECV5AIhAOV93F+CcxakPdapxskTdtiTYz7dbj7AVto5kQkB
66NEMYIB6TCCAeUCAQEwUzA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9naWVzIEluYy4xFzAV
BgNVBAMTDkFrYW1haUNsaWVudENBAhMXAAs2ayKDv7DDNQKQAAEACzZrMA0GCWCGSAFlAwQCAQUA
oGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjUxMDI4MDcxMzQ2
WjAvBgkqhkiG9w0BCQQxIgQgwJFv+r0KgZP+IsiIBHKUrkk73ZiVVL0LNOOHhiDAbzYwDQYJKoZI
hvcNAQELBQAEggEALn9NKdp2U2Jpz8JzpFaz1jjMsmzG/CIAwVVWy57n2MXaPYUI7RX2E8biDS6n
FDj/1dIkzq0EEAal2GyXt6emBq9sQL52bGYmpZ0yrznI+r//ho4rL70866FhpJUOQUX0vifoA9xx
TEDo6O3OgzDa7KtqmrtIgsfDJXSBJtSaoK/BG8/YaYFrc8v9HqqjGTkRBwCKYDSs98mclHuBVBtp
jhY9bzNy2142IJWEsXR9VuBM2p0YH2SqC/PrVMKt1p2PR1wz8UdewaTNNv8FXhCxx7RATqjYpNfb
hhVl2c/I5+31aqcOsn906fKSr5V+ZJRpufxpaJa4g37mQSoByYT8WQAAAAAAAA==

--Apple-Mail=_018BE3C9-B21F-4CED-9229-3F56BA3CE13D--

