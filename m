Return-Path: <kvm+bounces-35873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85738A158DE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8F5E3A9769
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11E31ACEA2;
	Fri, 17 Jan 2025 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MKN/58C7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B91E13C9D4;
	Fri, 17 Jan 2025 21:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737148437; cv=fail; b=RA2vyAkbxLxJE4xAvMohvDIAEd+07M7pmktjBVByJBT2ZciT0zutNwNFceD5ccdl8NcIh4eGtxKlRBJAbI/pPgCB/Kqvtj/iyFYTSNcwR64eCKYkS+LPcBp163MUoNViLNTBI5UTJEbQ0yoExYRDhSFACbZdv14HnWsJTTzpQX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737148437; c=relaxed/simple;
	bh=rklYVoQdbaOa4o+rsrG+U6uwxshyKsWVleqPnalzzVo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pYUrr9WYzMKEzYZ0wTitMvKql0F61Fg0IT9w6t1lVReizwDRl8VL1AT6nw/mXGMYxIF7v9EVsNzp0lwHteC3QC2qdMw4ee7jYhkCfCbScJ5YyzWVHT0raP4c8ADb9rPWPSSiWqMQeid3ptunvoMrVN9/fJIZNX5CfkfDpBDu1Zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MKN/58C7; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L624Iy6GZYXzh5ci8rsmx3p02leyy++xZcJidsUIuHPcshNlMSEkhhBAuoniqIf8RkRGQZstbCv9oFUA9/73fwdDT3RtfT/OPMqP9Ooc5+fEd+BKmr/CJE23HqVVWsYA7YxDFTZU721PkqeTGvLZ9ZjN86jo49XDQ2dzJgPW3uf9zTUN6zhwQj0608lVz4Hcqva6ALEOW181wfq9212PQQ+9e6mFhJUzki3mxtsXDI0f80He9YNastH+oXeS02wfLDgcZpx19/bLKJvJq8LbNPE/mKPXxzTmwjHR/ECoEdCXhFAlERmYJ1+ZjHXGjeqAml0psjsuOhKf2hqxfzIcxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rklYVoQdbaOa4o+rsrG+U6uwxshyKsWVleqPnalzzVo=;
 b=f6rXUdNv0k6VUJcIOgz/m1R+DXFqjgg98/BGB8s2NWkxCA++iTp24Sao4sQF5BlN3yHhmGQ11fXcz66432VgL4L2jgzqwAmkRwf0giTNP+mdpvh31qNp138uPEa4aaV02hU0AmuJrDIcrN9AABUfA4SkAYKe2KVmBEBqJhGlx4PBn7ubmWeFIw5tey2BNdrAYgXCVAp0GYKNs7I6N/jyhMnw6f7nkAMotFeL9NYBvE8+lsgIkG+ON9rwOK6Oqjh079tIJW3dJ5UMTYO/ERz7XQpvauqAioZb+iIJpu2ew2n5qvBniUxmUBIEXcVsI6//MDP+BTOSptcCBRdr41VqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rklYVoQdbaOa4o+rsrG+U6uwxshyKsWVleqPnalzzVo=;
 b=MKN/58C7a0WdJYnUod7jgdCCsnjAFQ7vXaEnWiUoEvlETbiBe0jt8g3U0TL7tAongUKqFD7GMoa1OLy4sD1Uy8rw52UPqumcQZeDwfPgIJdzmrJtxHYc7Ev4VA0wsfysXV63wK9DFtmQ2woWXiuoHD1XyiuZLap17Pt/pPBCmlFdzQyg57UoVfoqK2UwB4LGn9/I93aem01509pWnctmIdbpVjua5aXE4e204wJyIxKVi3jHI+MFSwYxCN5pl+79GTVFMLzXqSt4kPU7NDbKfSt5N4Be0o6L65UY1MIB3vwsewPeIX9WhBD4aX2m7DSPRMq0LQyCeBi6FHsvWErvMg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS7PR12MB8203.namprd12.prod.outlook.com (2603:10b6:8:e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 21:13:52 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 21:13:52 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbaPPMr+5jgewsKU+/Cqp4ayIU/LMbSQ4AgAAJq1OAAApqAIAAEg3S
Date: Fri, 17 Jan 2025 21:13:52 +0000
Message-ID:
 <SA1PR12MB7199624F639518D3CA59C7F4B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
	<20250117132736.408954ac.alex.williamson@redhat.com>
	<SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250117143928.13edc014.alex.williamson@redhat.com>
In-Reply-To: <20250117143928.13edc014.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS7PR12MB8203:EE_
x-ms-office365-filtering-correlation-id: d12f5901-c897-4642-5436-08dd373bd7f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?61v/CcOvvUheivQERmU1yyfFxHAse9XCxRacse01xVDYG9r8x9mt/YIcAU?=
 =?iso-8859-1?Q?2zSdpx1RVPpuVKhvtixo23m/bji5LoNQSmSuJV7M9baBjfmWN2ULFGMGec?=
 =?iso-8859-1?Q?U3Z+VgjCb1et4CrtLVwGqXIPDRrot3B7etiuEqvgBmVfyBbBIhM2L5cKxQ?=
 =?iso-8859-1?Q?0s9LftPmnRxEy/pfYmzVgCj3bvXHxhlYMkGfraGh2hLXWU0uPM9ezhy8Rl?=
 =?iso-8859-1?Q?njdUSe5tAqo9b39bvE2OOg1EokFHeUgT9Hqwiw5MumYNagF8dwfyqOKS0S?=
 =?iso-8859-1?Q?C1lZEg+0UPfITrf4P7yjqsy3Xvt8LPzOjZDUupleEfMHb9cc+VwBg5IRiX?=
 =?iso-8859-1?Q?NHeWGQlC7yTMwlwyz7mNBNpolLhrxfqxvyCRUffKL5UBbmxUYjJIsqO9V+?=
 =?iso-8859-1?Q?izQaMBSlud26j+KxyNpb7TPJ5dYLrNeHpqWjXraX6ave7jJXx0stppx1Al?=
 =?iso-8859-1?Q?++sOFcBqt2ZVP0ot5GYuBV47mrY3ThmyMWKUJCIQ484EjmPu0CtezM5+Kv?=
 =?iso-8859-1?Q?XonMFJIAMSNk/ogNXdiiC4HxHFzfX47jv4rHCrx8qiaTwqy0dSKNWepLCw?=
 =?iso-8859-1?Q?PjEDuGWaq0B82GSsSOs8CZ2coEgeGGQZ+ylFNSq3L4sRHXWhs9MGAjn2Er?=
 =?iso-8859-1?Q?zMDkkfmkokIRo4c+EQWEZDHXEqecjvQoUYgLXFnRw0OUegzcx23ih0Y0un?=
 =?iso-8859-1?Q?qcklTZgSvqNDkmfJHCgI76DrRlP9+rb4AI/PVe5FD8XSIVzgD6Qngerjn0?=
 =?iso-8859-1?Q?ayJLlpjumkqWYCA2CmLj/bTu/ij7ZRRL0xf0aob6kHqC8ksXqftfH8pyFK?=
 =?iso-8859-1?Q?+V9H3HkV4/NvKorO/jMMDN2zo1jlfX6rzVlztrlintircoxTrejxSgIdda?=
 =?iso-8859-1?Q?jkcCXL3qM1CnpuGfp6H68lB4gzUOetSM+wEOoBl4OJLlRL6f/NUeyTJY9X?=
 =?iso-8859-1?Q?4jSvjcR1ESIYyLuFb/HmNC+itfitXnf874AGqtcWqsNlNmH20y1ev/pIOL?=
 =?iso-8859-1?Q?VuMEKuDdxWVkRz5Jnu2eyuVu4LYPqc68oQ0lPAIXlSEFdf6OaKUHSUj4ID?=
 =?iso-8859-1?Q?KZ3qEwTyZeDbZzcEf2zRyJMejCJHj9LVf1PSTRsuVfBiU28v49XM6ZHRwq?=
 =?iso-8859-1?Q?zLKT9Avf5QJ92QwsPTT9FDEOjiaRRCOjoAfFeYmsjcdqj8BAaX0ZmbZZjt?=
 =?iso-8859-1?Q?AWlEsYYSYXpAl2h/gy/wYiOGyuwRZPdoOcS9Ji+1gCPutxGsCI1Kji1FA3?=
 =?iso-8859-1?Q?WPZ6zByzi1uuSpLukLLboeXZ8AEXjuJ1XrAnXHqLUp6/v480HqBgIUgup7?=
 =?iso-8859-1?Q?ktcQHecv6QxERNSHjE/jLM7Q4MUNMH/p0NjxgTmmBZhLfAgMs+MRr/LvmJ?=
 =?iso-8859-1?Q?LUOgJbO0TwaOY4gCF5IryfqL5xGWPlDe+beKs+Iz+VKDvigsFqCsF3X+nP?=
 =?iso-8859-1?Q?+psSqJeJjCjNlbP43ERgpsQhtECG3qphq0h1m/CqlmOj3HZApn4MgnWHX0?=
 =?iso-8859-1?Q?cXZnDfaHH/Is9LZS6MHC4j?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?48GHgl0R/JDaoCv2zMQesTr8ABj/EDkYQRkLMCRwcYKPIEFvsDjoqP0OLa?=
 =?iso-8859-1?Q?5DwQXGXUwsDC6BfPXyqIMb1UE63ClvlbXX2yRxJgh+RYOf1buaUtiRWlZh?=
 =?iso-8859-1?Q?KdOIHiGUdcoKPjJrQjHfKs430VFiLKx8riFmtzHaiIKbSsC5bKCsrgbvKz?=
 =?iso-8859-1?Q?MtbSqjPP+qxHOmuC4qB1XHU66xQIuf6izzE0otW+W7i8S/ZeycYGoQxl9Q?=
 =?iso-8859-1?Q?qVOPBA0dUkxylfIkKs/diR13IazvjwsbnxNa4YKc9mpeZtLlmqodcsDOMD?=
 =?iso-8859-1?Q?GkQ7tPoKmLePgvcGbnJQRmG8HtSXThGWE0XBK5b5nWzCqVOiVi2grWahEa?=
 =?iso-8859-1?Q?a/zdllmXtmoIIeaAXS6PfbN6y+jQUJerS1crIKIJOvd+QsEbweIZbUrSAP?=
 =?iso-8859-1?Q?eiJNBoN3bBuTYxZ3c5t4jIdEIvn46z9DNc6mPxoxU4borh3MNMQTupeVKX?=
 =?iso-8859-1?Q?l0bQ0u3e1yMni3UhFZHDQ8TxUg8SiumPGhB2w/WwyRVZAQnW777E/3RqQt?=
 =?iso-8859-1?Q?i9W2Ck7tiN7OCaJijFjmGeRmPZFQr7GV8TXuHyrxnD9i2LjoyYGdELeuZK?=
 =?iso-8859-1?Q?8nOdEVMdQiOR2aQYFqKy4yz0RaNkKGjZ9b5uFwVPoHy/BYT1plJkjHJIjv?=
 =?iso-8859-1?Q?O5GJxQtDQ1P4GkEF/VCAld9lYYA7ZA9Y7rCq2KJWDDifPBR8DFGOAxv9tm?=
 =?iso-8859-1?Q?etrP3XNESHfsry6d7ysmnW8IaiOJtrGlRgSX9wyexrJrGU4naCYg9aI5Xv?=
 =?iso-8859-1?Q?EgX2RQFCOcEqtW+qGQ/DHvUcXgBogjyd1NWu059NamdqsqVhEigv+uYgXX?=
 =?iso-8859-1?Q?yvIeIB7ql3Zv4rbZxFcFuaUOXembITqGJJuhmNSjatZ2qTn1pvEWibX91/?=
 =?iso-8859-1?Q?pZD92/e+59vaGEhNYnOMI6FJwkVRHNODGDauiRvnBJ9wDQGszZXcUA7Epq?=
 =?iso-8859-1?Q?KLapKAL+HZnWdb+4leeOIppTDNgOPUfyNv8ez4kUIKBRXKLYsnLdhrebTy?=
 =?iso-8859-1?Q?0MVizZ4gr7NeSAAMZHcqD+9sWYYzfrNW//GnDdzYaXtpl340V93ebM3gMq?=
 =?iso-8859-1?Q?aTYHK4+thokWRi+0ypby6KJMe4f3JkVkJCzMNpQtr4apiin8DhX0S0otkM?=
 =?iso-8859-1?Q?xwqXR+xG+iSyXHspX16cJhA53C4kNeW9vpYaChrYSp9sEbckFo/+1W2qEV?=
 =?iso-8859-1?Q?7uh/dCOQoAdQTVV3VNXwRvr3PEYAF4xuLIw8hlL3sHb4yKnmMXPmpNX6Po?=
 =?iso-8859-1?Q?G4cxn2VtKoR7k7u63k+feHebpgDFuZuSU9UOQ7z0drVYIEVO48pJxbLUai?=
 =?iso-8859-1?Q?2dFxIbv6NsIvgjxRpb9iX9z8JzEh+IryaKr3dX5lXPbySDSnX6qahXJRB2?=
 =?iso-8859-1?Q?ng5zkfwnvSqd79lcMnR3wSLzL77jN3UieuFbclgmaje6mX/bokbW75vmhc?=
 =?iso-8859-1?Q?BdtEbX4FC/OSfbd0rUTuUFVu2SnFlFygQjZ2HxwxLJeTIXYgl4wWFQ+frS?=
 =?iso-8859-1?Q?UkO7Q0p0JZTciXLGGiso8K2gFkO6RUtLdetGWCV6bfobM/W+YmJX+tqq3A?=
 =?iso-8859-1?Q?2toqdUsOg/9LftKcJG2xHt9sBtNaAm0PUxJduI6bUtDuFERWvRSnPsBfKr?=
 =?iso-8859-1?Q?KbPAM9t22vXwg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12f5901-c897-4642-5436-08dd373bd7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 21:13:52.1551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ClEjdQQjFwdchF/nknfaNjp/Eb2vZPTqjX9s07mSFo1TnQOOJzcQgCu0KDizhTBfmhMGNvXV4BXczwNK06Zx1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8203

=0A=
>> > We're accessing device memory here but afaict the memory enable bit of=
=0A=
>> > the command register is in an indeterminate state.=A0 What happens if =
you=0A=
>> > use setpci to clear the memory enable bit or 'echo 0 > enable' before=
=0A=
>> > binding the driver?=A0 Thanks,=0A=
>> >=0A=
>> > Alex=0A=
>>=0A=
>> Hi Alex, sorry I didn't understand how we are accessing device memory he=
re if=0A=
>> the C2C_LINK_BAR0_OFFSET and HBM_TRAINING_BAR0_OFFSET are BAR0 regs.=0A=
>> But anyways, I tried 'echo 0 > <sysfs_path>/enable' before device bind. =
I am not=0A=
>> observing any issue and the bind goes through.=0A=
>>=0A=
>> Or am I missing something?=0A=
>=0A=
> BAR0 is what I'm referring to as device memory.=A0 We cannot access=0A=
> registers in BAR0 unless the memory space enable bit of the command=0A=
> register is set.=A0 The nvgrace-gpu driver makes no effort to enable this=
=0A=
> and I don't think the PCI core does before probe either.=A0 Disabling=0A=
> through sysfs will only disable if it was previously enabled, so=0A=
> possibly that test was invalid.=A0 Please try with setpci:=0A=
>=0A=
> # Read command register=0A=
> $ setpci -s xxxx:xx:xx.x COMMAND=0A=
> # Clear memory enable=0A=
> $ setpci -s xxxx:xx:xx.x COMMAND=3D0:2=0A=
> # Re-read command register=0A=
> $ setpci -s xxxx:xx:xx.x COMMAND=0A=
>=0A=
> Probe driver here now that the memory enable bit should re--back as=0A=
> unset.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Ok, yeah. I tried to disable through setpci, and the probe is failing with =
ETIME.=0A=
Should we check if disabled and return -EIO for such situation to different=
iate=0A=
from timeout?=0A=

