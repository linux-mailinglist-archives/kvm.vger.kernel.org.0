Return-Path: <kvm+bounces-29014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E931C9A109D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F281283AFF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486AA210C2F;
	Wed, 16 Oct 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="u2+krc7r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D295F2101AB
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729099722; cv=fail; b=LK98LDyF/6kBcOp+KdLy4tGBLQXhOzJ095mIQV/eOoVFsCHfMUiabEpr1ue2TVwpjxF90jegnvkvf+Vh36fFuxudfTcYxJGju/4huVCa0m34/oaylT4aJXBIK1CQdpxYnHul2V7AoNE5p3L4TD/AdTBUpkFBlcgDuPhqyBQhoz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729099722; c=relaxed/simple;
	bh=Ddx5B7IVNNVY8QS/8EBWxXmoue5Qb5SrQAcDWUvYDhA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=LPdkvTWzP4eC9PkA94/tUwIlB02u9odXVzQiq6Dhm0/UleM+SGOhY62Mu4pbZN4rN9M7n1fQka4599zl112URqUh8PtQqtUE/66/NqrNcFI8eN+vQHQpY75sG/hjQpKsCPsUrcHE3Jr4Dseomaur0yIP7OF6BwJjefIwxUQc9Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=fail (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=u2+krc7r reason="signature verification failed"; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GAnipG024201;
	Wed, 16 Oct 2024 10:28:32 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42ac2wgtm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 10:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qboohaGZ64wFgq+BxV4O6Sg9PPICfldA5ZUsQthHiaBoVHXB9MfhiH2xBVzKuIiE2+Tv/jFwuob3Y1TCb21lI/16aPrctnZu1Aa0EBYcp1+Y8On3xIX3gi7gV4RwEfV75dbMeeLVGOMWuEPN97O16DJOBn//NvUUtdS3DAPVTzloyk3SMkz0KMyyoMLEXEZFyZr2gFxZkfgWCw8SR6lfGyRwr+LpRBs++i2vk3fmdyrmBvwLjGH1Edfe958++Ze15/8EyPIhcT44iVSWJ86SYkaAFoHE5n+50KGDyfA8QToBMtFyA0tJz0UbFW4vKg29fFC/7syqDkuSJKv7wuxfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dD2tdUmCvjxu+3CjhH+5GA1QetVZIIb9LY5i66Hxcl0=;
 b=To72ApkrTU0Yc5rio1TwN/ccBtxWZ4QB1uAcQ1ZETgX19FSdO6R4itDrg04eVQo7PgjVOhGNLr+bwIScd6aB9fjMkkE9OEyKyJVm+ljTZgxJhHJsFrbLPJwG0AbgbMPuWcTu33ERAdcNcYVg8AEcdbGQ9yel8kMYTw1ynsLvyg+GHpH475g+AFTQtFbb1GFKc475XuOz73A+QeojQqNu+s9L/A7iuGto5H+QyB8hnp2QHRYU6PLG+EWh33B1NvY3odF9oFWu7GlUupY6cMkTA/CX1LUeWLxau+h5fBnDsFHpqkJhukRwRqzsdTqFDB6Bddy3lURZmJAn8zlfPUwYPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dD2tdUmCvjxu+3CjhH+5GA1QetVZIIb9LY5i66Hxcl0=;
 b=u2+krc7r+Z+By3DS5lT9geZX42HfmOURXHiFq/DE5FOfDCMx2En/PIad3BobEOPR9EpDGGM96kc7ubB+SmZzL+xoyqwe7E1kZv39oQSFkQZO2vcfs4DJHUMlmNsK7eq/NCU+iG26PPA801fMFeKX6rhQcFRVTEQxJUZdZjl0Dv0=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by BN9PR18MB4313.namprd18.prod.outlook.com (2603:10b6:408:11e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 17:28:27 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%4]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 17:28:27 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index: AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnCmAA==
Date: Wed, 16 Oct 2024 17:28:27 +0000
Message-ID:
 <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
In-Reply-To: <Zw3mC3Ej7m0KyZVv@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|BN9PR18MB4313:EE_
x-ms-office365-filtering-correlation-id: d463475a-53b0-4630-c668-08dcee07f221
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dkkyNVY3eW4xbHltalhRSDFOVmFnTEs2NjV2UWJ0YkJTa2kwN0tZQnEzcjlX?=
 =?utf-8?B?WmdmQ05NNlRIVU1YeFFSVWlqVk1SSlljMVZyMzdzT2hyZkd5NW5QYWFoYUVT?=
 =?utf-8?B?MzJ1clg2Q3RDTS9ja2RSSzBqem9hNkt1K0pWa1R5ZkhwZ21UQmZhZ0tvVVV6?=
 =?utf-8?B?N1U4V3ZyTjlIR1QyaDgzQndDZkowMUttVlVjRjloV3hhdHZmaEo0OE8vNnJl?=
 =?utf-8?B?L0J5WHBidmtNSmo3S29OZDV6L2hIVGtBaHVabHY3cloyZ1NMSDZXckVLUytq?=
 =?utf-8?B?MXRqblRLaWtTeU9KVzBsM09Ca0EyZ1ozc1F4eVNpYml1cTI2a3N1bEs3aU55?=
 =?utf-8?B?ajdvTFBpcHhjeGhuMkd0WU5FOXFBeVlJSnhZUnlzTTFZUjFRSENGdnJxUzhy?=
 =?utf-8?B?TGIybHRQMXlISks2dkxnMkhsZWNxdDlVL000UlE1MW9waDhueXRwb3N2dzVK?=
 =?utf-8?B?czBvRWszRDJNVkhla0V0S1dDR1J2NnViYVB5VlAwWFd4Q2x4MCtTeUdqd2dt?=
 =?utf-8?B?WFd6RlREaGpLL05xdFNnR0ZYWDViRW0zOGlFRTZTSUxmS1ptdFVWVHRrS0ov?=
 =?utf-8?B?MGNtcjk1SXIyQVRMS0xwMjBhU0xkVVR6YW1WVXdSQTF1b2Vqbjd1TzZkUWlk?=
 =?utf-8?B?YW95dWtEcERjS0ZQeVJETlY5UDBXY0YrZFpsRDZ3WWRSR0kvWTNkT1FrUHI2?=
 =?utf-8?B?ZTVTNTZ4a2luTFJlcFNTaUdvNnRmUFNCMWE0RUlHOVJaaGtqc1UzUHBwS2V6?=
 =?utf-8?B?STBEUURNZ0xmWWppUUZaY3ZVSG56WmJIc1dDUmlXUUZCRS9jdUcvTFFRUG00?=
 =?utf-8?B?OXpVdkhFcDBiRTlYbnlQNlUrQlRCcDB1NVZDOXY5VGNPMHFNM0Z0cVJkbm1G?=
 =?utf-8?B?b0FLS3NQcTRFSnE0MjBad1NwZjRQSVFlaHZ3b2NUS2JhcUNRcndaRDdHYkVw?=
 =?utf-8?B?S2ZLVFpsSlhPTjNRYVJGYlA5SzZ4Qm1UdGVhd1pJR1lhNFBEMzNLV0luNjJ6?=
 =?utf-8?B?bEJ0VGg4V0s1Mk1uREpjQ0NWNUxka0VyWFYwMzgveE1RaGhKL2pta0NicTRx?=
 =?utf-8?B?ZFBSU0pQclJwQzRDb2EzVFFaWXI2Z3g4NDNYUEFBNE5GOXdOeG5OTXkzcm5n?=
 =?utf-8?B?a2lKd1hFMmVTZndieDN4Tlp6M1U2eDlTbHBRb1Y3MXp6cEZUWUhwZEtrQzZl?=
 =?utf-8?B?MzEyQ3l3OUlTajVRMlhkVmJsUDdlTmoxaHBPNmNpaFM5OTUzQzZnOTFsOTNk?=
 =?utf-8?B?a2ovd0RBeFI0YXhEaFlaVGpXQmNQL1BxU3FXYll1aFhkMjY2elJFNDlRSS9l?=
 =?utf-8?B?YWlIN1Bub1kwdlQ4T0Q3NjlVU2V5dU5zUHR6VkhmUGNnMC9YMUVQelBWMWY1?=
 =?utf-8?B?Um5DRm5wQ1BuaS9JRFQvc1dxSXFHY0kzTkZIUW02bE1HY0xvZFVDNEhnaUtE?=
 =?utf-8?B?UEJndHBBY2FXaysrdEZLU0VHL3VuV21WTEhWaHN6VTNaTGJrNU9nYVJtMnlD?=
 =?utf-8?B?b3pmVU1uK1plQmRJOXRnakFMOGcwdWUvVU5KQ2h3YmZ1b2N5OExnRmFNZ0Z4?=
 =?utf-8?B?a256NExQekttMitMNUxSNEZGS1JDYWgrNEZLcXYwZ3V0ckhxZy93U29SOVNO?=
 =?utf-8?B?UENwYXRsRlJBck1iV0EzYmRWS2UyR2RXQ3ZJdDJ5a2NsRTZXQ2QxaUYzRDd6?=
 =?utf-8?B?ZFpvY1VacE9hTU5sWU5Td3g0b28rSENobDFxWktjOEhrRklVM2NMdmF3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?THJKdGVlZUhHMno4WWd5OVhjK1BRU2ZOWjRpckhxUzNFNWdwOXViQk5QK3FG?=
 =?utf-8?B?Tk5kYW5zaUk1MU94K3VVeUViNVFZaWI0cWpUNE1XOXQ3aWd0b1FHcHNsdGRP?=
 =?utf-8?B?ejlzUGdaR2wyT0FvWG5jL2hZaWV1UjJ5SGU1MStrTlJxRnl5aDVoc1ZqZCtz?=
 =?utf-8?B?bVAvdzd0aFk2eHFsTm12bk9XemxVMUFLWTNFcCsxNVdsNE83T01vR3RVSXJU?=
 =?utf-8?B?MmR2c3ZhSlA4UGt1cmFsWmtNNUxwVXloaE9UVEk1cE9mY295cjJjQnl3aEVo?=
 =?utf-8?B?a3VsYmZIUjFKQ2FYRVhacjZUbEFWVi9vcmo5L2tUWUhkZDJJY1h3Z284cnpu?=
 =?utf-8?B?MGltekxZZVQvbEJPbU8ralgvVmJUNWZ0U3EreldqMmRXNXNoSkUzUWF5T202?=
 =?utf-8?B?Y05nc25obFh0dVd1ZXk0QjM3eUxoZ0lPLzVWRjVxWWNjeXdZOUpmcVBVUitH?=
 =?utf-8?B?ZVhhTTZmcTZ3K0VDQ1RqWW9zOC9PeDRaQ1ZvdFoyY1RrTms5dzFBTENDem1s?=
 =?utf-8?B?OWp5WTVJNzRMbHdDSEVOWVNzNmswZkx2Sy8vZ1lCS1dUa3kva0V0ZXJDSGVT?=
 =?utf-8?B?TFZFSDNEUDBsNmlGYkx2b3F2US9BbVlsWnZveXVkSEpEemc0bHozQlFwTk54?=
 =?utf-8?B?M1hVa3ZWR01STzQ5Q0VST2RzVnkxOE1jbWluTXBheHlUT0hpZU5ZMlZ2a2VD?=
 =?utf-8?B?SEYxUk4rSXV1L2xhYWN5T3NveVk1eStzeGJUa0pweWZycENJenlsSTJUUStk?=
 =?utf-8?B?WUpuayt6d2tlbUlBanhvVisrSFF0bENMN05zUzQzQUZyZ0JGdXhsRlZHdW0r?=
 =?utf-8?B?RnpvajdoTFNVYVl0dW1ybnZabDlzMEdlNHBmenMzY255VDdCWVJVVEpjTkNQ?=
 =?utf-8?B?MmI3eUxva1J4WjNKeDhtQm9qdEtUc2JYaUFORDVtemxacGFyazFHZWFmOU5l?=
 =?utf-8?B?eDQ1b0oycTZ6RU1GTGYzY2ZHcEIyVEh5SVVmWHRnYmxieERwTlR6MUdwaU1J?=
 =?utf-8?B?eUpwRWZzNE5HUmFOc3pnZFlrQTYwNjBuY0xOS0RHaUUwRDlWVHlXRlFRVXZm?=
 =?utf-8?B?Y2ZWWXJSZ3MyeHg0WVR3Mm10RjZXelk2bzBqNXROT0JlTEl0ZC9HdEkwZ1dY?=
 =?utf-8?B?YzAyNTBQUXl6U2xzY0dVWVppZzEyK3dSb2lKQjBhNVZvWWVsQ2JqRis1U29U?=
 =?utf-8?B?N1dUSnphbUtOTzdDcHVIWDM2eUROcWZYUnRFZHIvZGZnMFVmY3NqaGJZcFZP?=
 =?utf-8?B?R1lLRktXUEUxSi9rZ1JlZVNjaXB4UVVNR0JJSW1BRlAybmZRdEVYbnZFL0gy?=
 =?utf-8?B?UUFldWNmdkdNdTcyR2kwZWpoQ1NFaGp0NFdZcnVsZmpSa2NacVIyL0t5Y2Q2?=
 =?utf-8?B?ZWRXa0VzRDFBSmkxNlBHUTlaY3FzckdMWnM1UzVQU0liL3AzV1FuQjdWTzh2?=
 =?utf-8?B?ZFN5SWdHdzMrZDdRSmd6dk94S1lVMmZWNEZzVHVydWsrL3FYaWtQN3pnUmFV?=
 =?utf-8?B?ZEdSaXZrNFp5UjdaVUxXeU5vOWpWMDA4dVJyQVgwelY1Nm5PU2dWUll6T2Qz?=
 =?utf-8?B?ZlFZUEhVOWNTSWFya1JzT0REWjIxZ096NmZ3ZzF1Q0JyWERaOFZoTHBzcjhR?=
 =?utf-8?B?Nkd2L2NHc3B0cTJ4QXdKYjB4SE11cDRQZXl3eUdFWVdZeTY4c3ZGZ1Z5RlQ4?=
 =?utf-8?B?OHpkd2JFZEdnT3grdm8yYktJbS9pcXBjd1pWRE02Sk9ITU5mdUZXZ0IwSGpC?=
 =?utf-8?B?Nm5Id1FqeWVJaGVmV3laMjFLVVZRYnlKRzE4QTJzV0lVMkM4NlRFWm5vV2dT?=
 =?utf-8?B?YjRrb3NlTDN1N0lFcm13MW9TU1Y2T052UVNDNmNpOXE1RFJkbEJwR3R1eTNK?=
 =?utf-8?B?OU9LM0tneXNGNkJMbW1QcTFGd1I0a3JFdURWbkpzMCsyVTV0TFMydzBuR0Rr?=
 =?utf-8?B?eEtrV3FOT1k5U2JxZ0FrcGhTcm5OeFNDSDA2YndwMEk1emFiaHpaYVNMeC9Y?=
 =?utf-8?B?K0Z0OGtlSmkybXpQVlhsMEh4U0ZXWkk5cklnRk5wOTJwZm5GdlJ2YVUxR1JK?=
 =?utf-8?B?VW44Ui9jaW1Jdi9QbWpobW82UDNlN01iTGMxekI5VGZ2WVk1QkxQek9HQ1Bl?=
 =?utf-8?Q?wK9BbCLCAFYDxz3GmiJqrii9E?=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d463475a-53b0-4630-c668-08dcee07f221
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 17:28:27.3636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nsD2EpJhEiDI8dFylbKb1xS7ZL/eNryrdrEC8KEHdqhf3R9tTEuBDBfbsrGe54c1QlnknuM9b1vf7uhiGTcttg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4313
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: g8Tvlqihp-RocYM1F32KK96v00J9ACI1
X-Proofpoint-ORIG-GUID: g8Tvlqihp-RocYM1F32KK96v00J9ACI1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

> Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-
> IOMMU mode
>=20
> On Mon, Oct 14, 2024 at 01:=E2=80=8A18:=E2=80=8A01PM +0000, Srujana Chall=
a wrote: > > On Fri,
> Sep 20, 2024 at 07:=E2=80=8A35:=E2=80=8A28PM +0530, Srujana Challa wrote:=
 > > > This patchset
> introduces support for an UNSAFE, no-IOMMU mode in the > > > vhost-vdpa
>=20
> On Mon, Oct 14, 2024 at 01:18:01PM +0000, Srujana Challa wrote:
> > > On Fri, Sep 20, 2024 at 07:35:28PM +0530, Srujana Challa wrote:
> > > > This patchset introduces support for an UNSAFE, no-IOMMU mode in
> > > > the vhost-vdpa driver. When enabled, this mode provides no device
> > > > isolation, no DMA translation, no host kernel protection, and
> > > > cannot be used for device assignment to virtual machines. It
> > > > requires RAWIO permissions and will taint the kernel.
> > > >
> > > > This mode requires enabling the
> > > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > > option on the vhost-vdpa driver and also negotiate the feature
> > > > flag VHOST_BACKEND_F_NOIOMMU. This mode would be useful to get
> > > > better performance on specifice low end machines and can be
> > > > leveraged by embedded platforms where applications run in controlled
> environment.
> > >
> > > ... and is completely broken and dangerous.
> > Based on the discussions in this thread
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.spinics.net_l
> >
> ists_kvm_msg357569.html&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4O
> oD5hcK
> >
> FpANhTWdwQzjT1Jpf7veC5263T47JVpnc&m=3DKj2YVdoGecovW95oPf_fILveQer
> 4EsJfWJ
> >
> XmzmACF_v1jROPwW343ZXF2nEc5JN7&s=3DDw7EoKg_W8Ak7E0uGR4gT3vHBv
> Em2uEP1Pvx0
> > 5dXVHI&e=3D, we have decided to proceed with this implementation. Could
> > you please share any alternative ideas or suggestions you might have?
>=20
> Don't do this.  It is inherently unsafe and dangerous and there is not va=
lid
> reason to implement it.
>=20
> Double-Nacked-by: Christoph Hellwig <hch@lst.de>

When using the DPDK virtio user PMD, we=E2=80=99ve noticed a significant 70%
performance improvement when IOMMU is disabled on specific low-end
x86 machines. This performance improvement can be particularly
advantageous for embedded platforms where applications operate in
controlled environments. Therefore, we believe supporting the intel_iommu=
=3Doff
mode is beneficial.

Thanks.=20

