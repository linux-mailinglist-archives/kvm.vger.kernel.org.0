Return-Path: <kvm+bounces-28714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D51399C36F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53E6EB254D8
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 08:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5FC152517;
	Mon, 14 Oct 2024 08:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jH/gxLZL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D88F153812
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 08:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894727; cv=fail; b=YHRCaVdqgCM7oQtqmYzKzg3UM1SFu0KAjZ/v4Xbnca4cxbWxxkURLRco7f6L8C4IoDVoljB2DobEe3PeZYu+Nn66XMrEqlsDN/lXAmkbuVjzlI2OxYZZeJEGcVkHekyvB5PzZhiuxUd5jOom4javgA1PF99W7pULP3MSn6BRl7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894727; c=relaxed/simple;
	bh=MUWSNaFjHYjlKE0weB5MiN8tN9LULPlApnEpUlGz5Hw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dEaiA+xfDm8bPuL/0wE2Mla2WPhz4/y/CBAIu10EvEY01mLPoc89teSrx6R6BcH6HrPiZo+DOLzP6ABnkJhoggmJ0nik4bjRTi7LKGNwvwUQwkWCLAxOaQxXTEERMaCPar6BW7P2AAwwItX6WpMgWVdb+GhaBuWM8li1Aq1bMJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jH/gxLZL; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GlRGYftTX7+rB8iSqhR6aM/YT4vCVHtG/zQ/6RMYlNNNlmTVHwafc8JgNk8OPnNntGQBrC1OJdkQW3cmDyO4TBJcY6GgA64P7RXC9qHstqK27bRlT0yITdZyRcfjuT3TCKS+d7BMGcNFQXzIY5doR7ag4qhx/16OdoGs/Y098YarHXTXTMZaYF4kHinKe2QD990NANliy8S9EaYMhPy4FZV1TKUhWGBfFeKaZzH+JwKOsBSzaTkm4gSxAUneZj1GZG9ZX4bP6x3NBqstFt9SpFsMPwXub2a4B4h2HriNxqGkZJuaizwqj67OwQbjVZUFekobec1yKZf9tS0y3onghg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUWSNaFjHYjlKE0weB5MiN8tN9LULPlApnEpUlGz5Hw=;
 b=qJ30xwQpbCY0eRBZ1QBYeKqUZPlukUklgVZyq1MLU0gn3v+XX/N1SjK8iOaUDgzpy1cJUPbQkYKr2+Tr21HfNOms/evCcdr4B3B6RYhbJBSwIdrxJ/1cnDZwLTgT6M+lK7IExU1PP6jMQ6g4ucj89kmoj9LlrufF3ynCCmavr0ReV1d7vJoSpHXDVj431Mj0SlGsWOZbwMmU8XAwGtP5ViV1dFW7uQRjess1SHKIi5Vs8IDF1yiuGOQsbqTs5EW8esFNBz3LrUs0LMBv3epM66eFvA0gwJ9L1VWzAmgoW79gT+MYE8AAqiZ+g4KAtTUFwJKQldUVBwWQMPzXU4ddsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUWSNaFjHYjlKE0weB5MiN8tN9LULPlApnEpUlGz5Hw=;
 b=jH/gxLZLA/KJk/E/0kmuNfUnSm/NScxmrx+c22VMtoD6G3LabngZi/V25xblc7o8vP0fEIbggDbU00hoRtJpVN9Iw/pmHaKO+m35dJCOSj3VxLmrFYBhOpmsOXY3ME/oesEK4xcwjRRtO0nmamqPoNVXmDQj/R/XSUEaUyya8r8hDlqU0I5Ie057b/g9NWLy94SJrLsjJMu3OGqck5br9tDkTVsPs1430Ks2b73gm9deQlLJTVM9OP6BwgdlNSyLwY3hccwtasoG0rPATuaMwLiDu5jvpj6BuYvq5bVP+lgKEu6Kwg/CbpCEFGfhy5Mi6oeDugbvZe1BgIhikDrMOA==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by SA1PR12MB9470.namprd12.prod.outlook.com (2603:10b6:806:459::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 08:32:03 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 08:32:03 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Topic: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in
 nvkm
Thread-Index: AQHbDO4P31Y+kUihTU61ZqQfAXOF0bJqtLIAgBtYiIA=
Date: Mon, 14 Oct 2024 08:32:03 +0000
Message-ID: <d46ff67d-92f2-4e84-b1a7-1576b422b6a6@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-19-zhiw@nvidia.com>
 <20240926225610.GW9417@nvidia.com>
In-Reply-To: <20240926225610.GW9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|SA1PR12MB9470:EE_
x-ms-office365-filtering-correlation-id: 32aef8a6-b872-4293-2cb0-08dcec2aae14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aWtDS3daLytzV09vVlk3TytWYStCaXNHS2tWaGpUSWtNOEsxbTZCMGxJcGFZ?=
 =?utf-8?B?WTBPNGFIRFhhSE9IbEZUV3hGcmpKK2E3a0ZBTjFKY3lEUFVoQ2VIZ2ZjVFk2?=
 =?utf-8?B?MW9YcWdnakNtUHI4b0VDbTZSUEY2eW5wT2JNRmJ4SDNNZVVGTmd0WG1yOVBq?=
 =?utf-8?B?eUpGNmp4NlVIdnlveUJhN1R0WjE0bGhGbmN0aE5ZS3ZnNXlLRGR2cG9Ub1RZ?=
 =?utf-8?B?QnQ2bFRKdzAwUllMaUxEQ3BFdURmUHZYS0oyTHZLTG01Yk5qT2VuMHpabEth?=
 =?utf-8?B?THpxTXVHWW1zNmFKWmcxd3ZVK0d5ZzFIcTNRMnlXRlRLbDVxcTlGcllQVTFZ?=
 =?utf-8?B?ZWZVQitrYU55QmJYRitBdmo2ekk5S3JFakZNRVNxb2NwSHJTM0EwdlcyWjQy?=
 =?utf-8?B?WXNOYjR0TTRYVDdKZlBKQWNPUHhiYjgyTllOZHpYVU1wTWhpZUZBUm1nSEtT?=
 =?utf-8?B?Y0x2RTk2TDY4S0dNMWZ4b2JxUXJrTXlQK3BmaGsvb3VBMDdhcFBJSERpR2Ny?=
 =?utf-8?B?aU16MWlLZFdUY2RnbGgvRlJVNzdlalNBTWFLYkRsUUtka0xycFZqQkRoYXFx?=
 =?utf-8?B?MitNRjhsOHp5TXNRK28zU2VVb21UMVhwLzBxTk5lbGxUQXRIbGkwWGYxV0Vv?=
 =?utf-8?B?ZmxNd2JNd01PZno0TUd6RDhYK0FibFBXbE9COFNtbWJYaEExUW4vUkhzaUZW?=
 =?utf-8?B?azFjQnVVOGJWSEUyMXl4b0phV0xGSDgxMFJXZXBDNHp1RnlJNjRmOEdpRWdQ?=
 =?utf-8?B?NXNkaHlQd0lKSjZtaDZxUU12SjlqYlBlV09QT092WVdKVElXdDEzUXlRTW9M?=
 =?utf-8?B?SVRjNjJOb2gxUzhaa1FnV0pZUVZxVDBqRHQvajhSUE9ZVDZ3Sktxb1J3Q2Vp?=
 =?utf-8?B?ZW9qcUhQQUVvc1ZVTFJKL1NxOEpSVHBFdmQwdlI0UVNXYllGVFV5RnB5WmxL?=
 =?utf-8?B?TEN0TkpLSnhtOC9oRFdvTzh0ZUNNU1BSWmU4NURFTUg4ZG9RV3RUL0Njalo4?=
 =?utf-8?B?RjNTNENsMiszSFZkZUdhNlNKNUFWcWk5cGw2QlZTbDZROU5QMFEza0lwaG15?=
 =?utf-8?B?dHBOcTJPUFl1SXZnc2UyOXJZa0ZROEpnbkJhTW9LQnBmVzZKckNjRkRpRm5t?=
 =?utf-8?B?blVSSVZSenBwR0VDUkhNVFpLRDlHTmlOOTNIVVd3NU5MaDRETmlDbENpaXNS?=
 =?utf-8?B?UnRNTzVVZGk2M1c2MzF5OWFqT05HaHZSeXUrYUtPbk1EODQvL3lKYzJ1RTBR?=
 =?utf-8?B?OHlFSGo0dTdIZElpeElwREkzdG9zV3R1SVhPcW54czNMS0hkN0xEWmlsZGp0?=
 =?utf-8?B?bHo5N2FOaGNMMlFTRzc2UlNIaFZEYTl0K0xnRW9BRzJDeVI1Q0xDTTF4NTdS?=
 =?utf-8?B?ODRSaVZGQWt2U2drN1pueitZbmY0RzVjcHdyVFI4a1FhSE9Ic2dmaE0wS2pD?=
 =?utf-8?B?LzRnN1V5RkpMTlFQaVRpbU5OcHpiSzdRNi9iR1pXbW5zZWNhWE12a1diRzE0?=
 =?utf-8?B?Y08yMWgzNW5XS3dESmorR2tzRXVpTVd0b0FNVk0zWGpaY2QyVFMrMGlaK2ta?=
 =?utf-8?B?cnc0eVRybDEzekNET3gwZzltMUJyWk40NmJDSmIvTmpFZTVrdVBKcEFiSjls?=
 =?utf-8?B?SE1HYWlWVVdDS1l5b3B3cGVxRXpqUEdtODFRdmpsT2F4OWtIQ1FGTzhNeEsw?=
 =?utf-8?B?Q3VFaTkvK010TXgrRm9MZ3RzRVdsWmdMemtFV0cvMzUvUXhQZTlSMnU1YUtW?=
 =?utf-8?B?TFNwWDU1d3E4a0FmQS94RUxKTFhUTWxLTGNNK1JoTElnL1V2MnBHVWZHVC83?=
 =?utf-8?B?OHJ2cXJ6UjlOQTd4cXA5Zz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M0RpRHFBTTcrOE9aZ1VHSWMrL1JBaEVITmM2aFBKTGh3QnZYNEUzR0dCRTNS?=
 =?utf-8?B?YWFWVjB0OGNEamtuRWNuaWhNcGJSMkZJTk16V0pMekNIb0xMNGlJSzI4RThn?=
 =?utf-8?B?aDVWcURwWTBWZkpBYmpVL01OVVl5bUI2U1VKTG1CZlM2d2JkaTNWalY4RmNi?=
 =?utf-8?B?bDRIWlY4dzdvMVAwVi9Vd0xhSlorZC9sMGJvVFUzRFd0cXpzMFFRajI5V0Np?=
 =?utf-8?B?NmNDNXhnOWhKL2k1N3J4NFJWQ1BtWXdHTnMxcWRQNHZNTlJUQi9SdnZSUDBs?=
 =?utf-8?B?WDlZaEsxejdYWnl2MStTR3I4b0s2QmdKVWV4L3FnMHp2cFF5UEE1TytlZDV5?=
 =?utf-8?B?bUc3VGxKZldiZG1naitCZ0VTU01hVzZ5VmpzcjVCeXZIa3pjQ01TYWsrK0dl?=
 =?utf-8?B?dzJZM05UdTRlSHFvcjZ6QlFmNWdKZjNzMzdEc1RRZEJHNCtzTnZhMS9xNERY?=
 =?utf-8?B?bDF3ajNQamUyVi9TWVF1czZiS0tVNDRmSk5QOFkyYTB0VjR0NkJmZjJ1c1JH?=
 =?utf-8?B?VStzaHZNUlQxZ1R0cHlWOFNlNFArTGNQQzh3VzRHSmdQNmhrVEZIUm5Vc3N0?=
 =?utf-8?B?VUJmMGxrTkExNmJyRlNJME1kbTJmNjNxZklHTEpiaVcyQmVPRHZwRXFlYzdi?=
 =?utf-8?B?bHFnUVhCckdPd1M5Vzd1SCtvWWZJMW1pOUpPemhtSktLUWhTU1JPMUYwOGhn?=
 =?utf-8?B?Q21jTWp0M1V3WFJqb1JJS05CTTB3dnM1Sy96TWJhOEV5SjFhNC9YTVJ1aW9Q?=
 =?utf-8?B?N1dmdWVZb3d3Z3d2R2RNb05xaFRoR3F4SXJjV0NjRDVJcTQyeS9KTzdLN0NX?=
 =?utf-8?B?RE1KR2FEcEFGaFlKcUIrcmJWMkx0QzZySzJhYWpzT3N2WkFkd3lwTFhxUDNJ?=
 =?utf-8?B?RGUrcnZaMnNjL1YyNVM4NmV4MGo4R1EvVWRJUWxvd2gwRmVkZnRyNFAydXpD?=
 =?utf-8?B?T3F0VHRlNkkxUWd3VDVERnpnQ2JqSmorYTVJZ29NVjFWVnFPOWU2UnM4eEJB?=
 =?utf-8?B?YUN1RExwSzhIcFdidlFNeGU1NkVqT1dmcmdXUmQ5T0ZYZWtQY25FbHh2ckl3?=
 =?utf-8?B?YWhOcDdrOUVCRXhuU3RoRnpRVnJ1dVJjMlluS1dSa2ZaYlBmb0lpMjIySUY1?=
 =?utf-8?B?Q2lYeVJOUzljcXd3bUcwcHN5NFFocUdMa3cySFZMSVUveGJDd0FJeTQ2ejhT?=
 =?utf-8?B?UzQrbGZOdm80UCtRZVQvM3NEUzREcFZ3TUo4dVU3aFJDVGh2c0wwdURnamVV?=
 =?utf-8?B?R2J4ZGdwN1JOSU54OStDTzFLZyt0RDNVcDBQWXd0MWZ6d3B2UFJQZCtVRXdY?=
 =?utf-8?B?WDUzNGVXRWxkTGNjUVBpVEJUZTVXUEhsQTlBYkdUb3A3bGt6ZStwUzk5dUEv?=
 =?utf-8?B?ZG5qUEx2WTFoNTFCWmk1YUtLZGtPNjJRbW5MZk9raGQrOTFSMnYrK0dHS0hh?=
 =?utf-8?B?WDlROUJJTUp0V25OejhyRklhOVpmMVhSdXVWK2hGL2YyVWQ5cDhsajJWOTg3?=
 =?utf-8?B?bGlDZnhNejlSUjh5SWtOYXpURnpIT29WNE0vMUtSenhJS0ZHdVcrNWFjRitv?=
 =?utf-8?B?OUFkVGxmdnYyeGxGb2NIUGE3VmI4L01rQUgrclBvQk01a3RoRzVzMGlkK0g4?=
 =?utf-8?B?cktDYTdUTnZSUi9BNGxPL00wdUwxZGtUdDhEc1k4eUo4WllJY1Z3VVFvQUJy?=
 =?utf-8?B?UC92V2lrREU5SjdObUJxak9LK1VmYnFJREkyMWFyUk9NcGZuVU5OVGV2Rk9M?=
 =?utf-8?B?VFo3U3FCNUhvbFdOVGRTa2g2WkhYemhkV2llRXNURHpxbS9YQlpvNGYwVWFy?=
 =?utf-8?B?TW9kQWlFdjF5MFBMMUdiMjFpS2Nrd2tDWVlrdE53RHlYcUFiNHMxUTJJSTd5?=
 =?utf-8?B?QjdpcWE0K21ZTjNSd1JFL3BueEdQTHRvWVpiVXhSd1dzNVhDaUJSWDRnVzFC?=
 =?utf-8?B?eUl0aHk3anhFR2RnL2JnMldQRVFKVzUzc1BKZTJlMjB3UGpwbVltNktZM1g3?=
 =?utf-8?B?VmJCOWxYRGVvZG4ydldJSVh3WjlDQ1d4NUMxN3NqRDRPQWJNWHdQYmJpK1d5?=
 =?utf-8?B?a0UzWkJSK3hUREc0Ny9XNTVMK1ljQWhjNDBSU2JIOCtFMWZKc0xSTmZKd1ZT?=
 =?utf-8?Q?H/wA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65EEBAE991A9724CA2BBCF702967027C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32aef8a6-b872-4293-2cb0-08dcec2aae14
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 08:32:03.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ZPoetHmMWSNmEEZEB2fUxW0x8jGLvWo4RE05b+9iZkkDbutmFD08dwnyYoFON74
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9470

T24gMjcvMDkvMjAyNCAxLjU2LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+IE9uIFN1biwgU2Vw
IDIyLCAyMDI0IGF0IDA1OjQ5OjQwQU0gLTA3MDAsIFpoaSBXYW5nIHdyb3RlOg0KPiANCj4+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL2RybS9udmttX3ZncHVfbWdyX3ZmaW8uaCBiL2luY2x1ZGUvZHJt
L252a21fdmdwdV9tZ3JfdmZpby5oDQo+PiBpbmRleCBkOWVkMmNkMjAyZmYuLjVjMmM2NTBjMmRm
OSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvZHJtL252a21fdmdwdV9tZ3JfdmZpby5oDQo+PiAr
KysgYi9pbmNsdWRlL2RybS9udmttX3ZncHVfbWdyX3ZmaW8uaA0KPj4gQEAgLTYsOCArNiwxMyBA
QA0KPj4gICAjaWZuZGVmIF9fTlZLTV9WR1BVX01HUl9WRklPX0hfXw0KPj4gICAjZGVmaW5lIF9f
TlZLTV9WR1BVX01HUl9WRklPX0hfXw0KPj4gICANCj4+ICtlbnVtIHsNCj4+ICsJTlZJRElBX1ZH
UFVfRVZFTlRfUENJX1NSSU9WX0NPTkZJR1VSRSA9IDAsDQo+PiArfTsNCj4+ICsNCj4+ICAgc3Ry
dWN0IG52aWRpYV92Z3B1X3ZmaW9faGFuZGxlX2RhdGEgew0KPj4gICAJdm9pZCAqcHJpdjsNCj4+
ICsJc3RydWN0IG5vdGlmaWVyX2Jsb2NrIG5vdGlmaWVyOw0KPj4gICB9Ow0KPiANCj4gTm90aGlu
ZyByZWZlcmVuY2VzIHRoaXM/IFdoeSB3b3VsZCB5b3UgbmVlZCBpdD8NCj4gDQoNCk9vcHMsIHRo
ZXNlIGFyZSB0aGUgbGVmdG92ZXJzIG9mIHRoZSBkaXNjYXJkIGNoYW5nZXMuIFdpbGwgcmVtb3Zl
IHRoZW0gDQphY2NvcmRpbmdseSBpbiB0aGUgbmV4dCBpdGVyYXRpb24uIFRoYW5rcyBzbyBtdWNo
IGZvciBjYXRjaGluZyB0aGlzLg0KDQo+IEl0IGxvb2tzIGFwcHJveCBjb3JyZWN0IHRvIG1lIHRv
IGp1c3QgZGlyZWN0bHkgcHV0IHlvdXIgZnVuY3Rpb24gaW4NCj4gdGhlIHNyaW92X2NvbmZpZ3Vy
ZSBjYWxsYmFjay4NCj4gDQo+IFRoaXMgaXMgdGhlIGNhbGxiYWNrIHRoYXQgaW5kaWNhdGVzIHRo
ZSBhZG1pbiBoYXMgZGVjaWRlZCB0byB0dXJuIG9uDQo+IHRoZSBTUklPViBmZWF0dXJlLg0KDQpU
dXJuaW5nIG9uIHRoZSBTUklPViBmZWF0dXJlIGlzIGp1c3QgYSBwYXJ0IG9mIHRoZSBwcm9jZXNz
IGVuYWJsaW5nIGEgDQp2R1BVLiBUaGUgVkYgaXMgbm90IGluc3RhbnRseSB1c2FibGUgYmVmb3Jl
IGEgdkdQVSB0eXBlIGlzIGNob3NlbiB2aWEgDQphbm90aGVyIHVzZXJzcGFjZSBpbnRlcmZhY2Ug
KGUuZy4gZndjdGwpLg0KDQpCZXNpZGVzLCBhZG1pbiBoYXMgdG8gZW5hYmxlIHRoZSB2R1BVIHN1
cHBvcnQgYnkgc29tZSBtZWFucyAoZS5nLiBhIA0Ka2VybmVsIHBhcmFtZXRlciBpcyBqdXN0IG9u
ZSBjYW5kaWRhdGUpIGFuZCBHU1AgZmlybXdhcmUgbmVlZHMgdG8gYmUgDQpjb25maWd1cmVkIGFj
Y29yZGluZ2x5IHdoZW4gYmVpbmcgbG9hZGVkLg0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0K
IA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0K
IA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0K
IA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0KIA0K
IA0KIA0KDQpBcyB0aGlzIGlzIHJlbGF0ZWQgdG8gdXNlciBzcGFjZSBpbnRlcmZhY2UsIEkgYW0g
bGVhbmluZyB0b3dhcmRzIHB1dHRpbmcgDQpzb21lIHJlc3RyaWN0aW9uL2NoZWNrcyBmb3IgdGhl
IHByZS1jb25kaXRpb24gaW4gdGhlIA0KZHJpdmVyLnNyaW92X2NvbmZpZ3VyZSgpLCBzbyBhZG1p
biB3b3VsZCBrbm93IHRoZXJlIGlzIHNvbWV0aGluZyB3cm9uZyANCmluIGhpcyBjb25maWd1cmF0
aW9uIGFzIGVhcmx5IGFzIHBvc3NpYmxlLCBpbnN0ZWFkIG9mIGhlIGZhaWxlZCB0byANCmNyZWF0
aW5nIHZHUFVzIGFnYWluIGFuZCBhZ2FpbiwgdGhlbiBoZSBmb3VuZCBoZSBmb3Jnb3QgdG8gZW5h
YmxlIHRoZSANCnZHUFUgc3VwcG9ydC4NCg0KVGhhbmtzLA0KWmhpLg0KDQo+IEphc29uDQoNCg==

