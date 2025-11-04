Return-Path: <kvm+bounces-61989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C98AC3247E
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D24433BCE5B
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318FD299A94;
	Tue,  4 Nov 2025 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZizmwdT9"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7DC338935;
	Tue,  4 Nov 2025 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762276510; cv=fail; b=id5CFQ9Wf0GyINAJCMBAUsVm2KyBvCuc/x/k5Xrr4pwEQvVF6nTa/d+5OcHPeLe3ITcZrYvSHPuYnO6aZaSUN2px/k24ebS39/fljkrrepTUeFH+4PINobAOxsGFvgs9ulAEnEGrTMSFLlGcqINj6lHF100buCDiZfqucgJPfsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762276510; c=relaxed/simple;
	bh=/GGW+YapkhINwX6i9WAD9boeurolhVcMpSIlQ9bGLj0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jhESl31m9XENqahuEtXWjvBqlK2hu/7cUnsS0hiAhR5K9LNbcpdXD1FBm3c1NJd/6KegspkzIu3CGtfVQNQcFdq9DXdzh4kVT+0uARjc5MIBARwGXVia8JIdNUdqsD7qyzBWCe8SrkBy7QTwXG82HElv/gnHXdTmpC2Li1I2GDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZizmwdT9; arc=fail smtp.client-ip=52.101.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzjDT7fk04CjfzQH19SUGUw2ZVbXAuE2K7r3Dw2SWz315gVWznnbWTY0QRyOijVIy95eZTOeUuI2T9/DqnpbjUvm5xy+jj9T9AWzElZE3MX6okrOSe1Qtw2OODQtMvLayI8/eheguCagIKoKk+yciQ0wVe00qq2A2ZmURC5tq9xWig+bSqG80DQbWF5HCAmQx/b9QGfmaBRfkuGp6Xs3sUrEW/6v17oAfACDrpaWBGmkvzZwf+dw6HkaSmuORZVq1PRx7u6Cv95qPRXbgN6eUmhPWjB1szj32cwkJ6ttKRH+4wJL5RDph+jb9KCCLMvjaNm+fqq5KzV1AiCl37d6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GGW+YapkhINwX6i9WAD9boeurolhVcMpSIlQ9bGLj0=;
 b=lfFfUna7hif3dLrYNxOczNR1c8zQGfaaQ+V8tKE9yKQPT/3RODYwujCYEGuGQP3uLcYZFj6gG5JE9+yrOPkmWPCLsp0OX7Woc/XNZZYFr9qqt9nfRKYadUGBzPPgD3Aaq4SHEZCdjGi9bLrEEfgu49cmbVaSzBX8PwT9q68W7KD0PR6Ry8apqge46CKaVJ1E8IwbLYUt6RU5nV8hSCavf9NPTbCKD+scXeF34neYoiXBxFuDNqEq6xG5rIwUE8WgL1cfwRvGlxtjts7S8hGL2NGXELOW3Vg/opZyL9HW1UGOPbGmItWdeDQogrOcYFrsanSt20w2iaDY8SXLlyMbog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GGW+YapkhINwX6i9WAD9boeurolhVcMpSIlQ9bGLj0=;
 b=ZizmwdT9XxrSYHwyZo98tDVP2XKsXWBzwpbYYhf8Wq4Anc/Fwjz4RacYe6F/mB7XCA9BiravlNMqxgmhnoEF2dQaEHis/9mZbsRjjHViFfKqR24Fprgvj6duk92rdqVmbwavm+eXDxvbUvejzyhGV6kl35IkLe4Ji5iJgNleazbn4y+WmxkJdCbwED5sBu8+XZ5MiQIkGh4SzhdVaQW9NQGRXKs2yJVJScNkwB5j5qha3S31uCG9VG5iljHlUZK0/jrfLIHVv4pcVXO3zrnhipCPf8klCv+mEmPi08NdIlvfqPy0AkrzFrH5Od5teSwASepSbVWY9mz1RM2jUTm9tQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB7219.namprd12.prod.outlook.com (2603:10b6:930:59::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Tue, 4 Nov
 2025 17:15:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9275.013; Tue, 4 Nov 2025
 17:15:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Topic: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Index: AQHcTCjI0pjrCheBKUOiFkE7k4wQB7Th0nYAgADyENI=
Date: Tue, 4 Nov 2025 17:15:04 +0000
Message-ID:
 <SA1PR12MB7199FF870DE7DBE9F1757935B0C4A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
 <20251103184742.441e98e93c5ed36320c4f41a@linux-foundation.org>
In-Reply-To: <20251103184742.441e98e93c5ed36320c4f41a@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB7219:EE_
x-ms-office365-filtering-correlation-id: 53a1203c-7992-4c82-a657-08de1bc5b218
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?POomm5zhVHvW5kS8+M1wEk2j9lZlNa/wmatMZExgYGH0MACSjVRea6EbD8?=
 =?iso-8859-1?Q?36EAp8GO6sTT7+nAw6mB8S4Jrqou6edqDA2RWeBD2m+u4aqg2I0Qx9w/Nq?=
 =?iso-8859-1?Q?nfRjNxzqcwq6Z9rzHiF5avkGi4QDuhLNTBjnIxhHXA4ZIreq5vs/NAz6KP?=
 =?iso-8859-1?Q?A84uAhdVQig6Q3Jv36zhpiSnZDTMhIfpgs6B5NqraIu3ef9+3gTGalYMhB?=
 =?iso-8859-1?Q?Qs/O5G6hiLfEHUJIrHERizpU9u6c8COqhGhQlJYk5HsijQ3fHwwEI/kqTQ?=
 =?iso-8859-1?Q?5SjWPlQ/ikB93w5CpAdMAE4308Pkn+0lnEIcAg4GphqNRCdku/eEzCWX1Z?=
 =?iso-8859-1?Q?Und6lVg/ZGp0N/1QaUX3a6y/q71yT9gSmVR6ipfBIj6/k4E+qtJQS8iY1A?=
 =?iso-8859-1?Q?8fMy3oIbyIBnNm/X5jp0/uB6mqbEFgX54OEd2TcLGbM/nskXfVFeO3Ga9Q?=
 =?iso-8859-1?Q?NmB5kQNluG/2wlvQ4mpgEAQJFUavDF/h6ADURhaj5TGFN6VZZmhkv7yodO?=
 =?iso-8859-1?Q?vPFnnYTtlFTaCSmfAnoTEomeSqzJCJ/69BOfYuldHGaPeqOdPduqMYR52q?=
 =?iso-8859-1?Q?oBBpTuJooEc3Nw/QiOUs+Zc9N9CXNdxc7bdAZ5zad/z8LNcPcUWE//NOa3?=
 =?iso-8859-1?Q?pNBRA1akgVdAZxgfWY4I03nIE/zLoYQWaKflyloxMRt+B9MNDqZ/R1KcEK?=
 =?iso-8859-1?Q?nXGZN8gcHRgqCmqp9Jv9inw99UUoFBxkpNWFNZz/BqQZxPpeaXseHAGCmg?=
 =?iso-8859-1?Q?J9HkO+TgYzSY0ohfzjyqloTQ2v/9mxUjjInl4AbTOHejypqJj/kQEieDu6?=
 =?iso-8859-1?Q?7UFEcggJAfolpInTP8mnwLSJwLMrNkxJxA9Olw8V05iPCqcYgkGPb8742v?=
 =?iso-8859-1?Q?ePqbv13M9QBkckxsqVUSxru8j5PmG0qVk2Oldre6JyNVGwAP5dnA/5rD+x?=
 =?iso-8859-1?Q?zANsT6KTFEA0Oux7waxcmzkIYpB/yIDBk7OIQ3uD8mmrr+etCVUPJhz+tI?=
 =?iso-8859-1?Q?58kyfh8oDKoD/KG+dXbvAI1kLesqXnyNLWWhgiLSCZrXpSyMZnniVG2g7U?=
 =?iso-8859-1?Q?uda156cfrM9wgtQGPUtstpEP1czHKvCFtWu6ibQsk/2NKcn4vwoxp8st4y?=
 =?iso-8859-1?Q?3MeyvUFt/VdnfLVrBywZ4JhTS1It66EPQ/qttTrnWPGngQSHC5IcvR9fNp?=
 =?iso-8859-1?Q?KVSc8R1kE5BYVo3S5T/IDm+L5JEngBWaNG9nUiUCi44R9wGN1FbuY45NjZ?=
 =?iso-8859-1?Q?Y98nxrg+NDg6ZJc3+yC24mxF33j4IrfxMPVwNQospC1hHo8Czn1C531x5n?=
 =?iso-8859-1?Q?yuOzFFMCFVOn0vEwPY+cAy4mng/LEv2OJbmffrbLZHS56/Qr5dSlB/KGKx?=
 =?iso-8859-1?Q?dYEgYNGsNet3NlGQh//m0nl+eIb2GU07eBzF2dacVpic9gMnUlwTczdbtm?=
 =?iso-8859-1?Q?V8xAp0Te4zwcVSEa1aggzATv1JRF02HYkhUZx6i3Hudb20QXGsM3USH+B6?=
 =?iso-8859-1?Q?/8myC/p4g5fCCm5FQU/3se0wfxWBJW1Vd8+AY1KGMa/NouXhd+YHkhDycg?=
 =?iso-8859-1?Q?Dp4sTUCkq5TQxOSBlf0PxlkJMIU5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?f9nMQAGDxO7pLLEIZvBMK2yHPvHmHwB4+TzQpgI1CdiChWg2gqlJLhD2SF?=
 =?iso-8859-1?Q?8LX8YJY0z1LD1lfPyMNf4Lu5/7aGd5IjRUted8w0YiQIh5u3tWHnURjwGy?=
 =?iso-8859-1?Q?tbIkMUMAD1mftiqlLwdI7m1K1qDCocglGZixbF3I1JKFJEAz8FNSo8XIqD?=
 =?iso-8859-1?Q?pq6AC/8E2vD5OeJ53yr3n4kazQRniZbw14b3lP/ncamS4j21sLcjdrEoDQ?=
 =?iso-8859-1?Q?ywZZG8C99tDvi0D0UNKYityG6sx+D+fqkQM7ToTP83FPHA3y9djxcXljaM?=
 =?iso-8859-1?Q?MQKNlNXORUE8CoUBymAj5EoitQ6Mtl0nGxqsnBsR1GCpNOZWodOLFDMbKt?=
 =?iso-8859-1?Q?pX7oKE5qg17EaQfXfMscNd1aEqOE1DOjVBTdCd2mQiIfBcFKQQoo9RWZPu?=
 =?iso-8859-1?Q?ez+ARzY526cugkavpS7o0ckp/XYPqa7MVZUwlEqpk3VgA+/qQGua2oPIBZ?=
 =?iso-8859-1?Q?MzTloI1dMRWTaiEAva/ZIAuJdDMoF0kx3ennESwDfMkASqhsCwtsui99h2?=
 =?iso-8859-1?Q?HvXb4JkXkLwK8mJ0a+STX1uOwX1GV4VZ+EnpHaN3Da9G/yjtIeYgDhucZx?=
 =?iso-8859-1?Q?NR0oQJ8Ag1p4f4qZ9w/7inHf9FQRPZ27S7LnLcEd/O8OLmJGvWMBk/IDAz?=
 =?iso-8859-1?Q?HlJLGHbtSwWlXDn3IniMiO0/MFADOB74W7PCFHVRQmq8gP74mPPKY91mxX?=
 =?iso-8859-1?Q?UBYGVeGjVB9bQNyxROtwb1pDDy3LtsioA9wn27ixdrneN25woirDqQ8Zmn?=
 =?iso-8859-1?Q?rxX5C6+xuoyas8hEJSX++72TXAjOBPoPoDFA1yQg40dEol0s0HSJ3HGbLF?=
 =?iso-8859-1?Q?J4ZinkcWBy9ilW8fBTLggxL6Z1pyr+aF34XcqpPdI0fz8YDb8FieXd6qjl?=
 =?iso-8859-1?Q?yW9Exb5x4/VCnxvoqy6k8alPXGX0SfMwOxzpjeQH67MUbE3MtVgKuCuxoe?=
 =?iso-8859-1?Q?el+BzuPqPmIFtTwzsp1hDrfsI25YbzaHGq6nIUks9FoMvdwblFevni9vs9?=
 =?iso-8859-1?Q?ZkdpNhhwHkkeqOu+D5H5oK8sjspktzf3Rkw4chaAv14Vj7bo99ks8ULmok?=
 =?iso-8859-1?Q?V/ZQwIF/cNI5PjMdI2AJnr8TzmUtVg+1T4ptVfB8lvVhHS9/wV5eEO/4a2?=
 =?iso-8859-1?Q?tza9UNJDZOXxDac+EGK2go+7MBF5bOqkLb3I7WmLEXXKE4uX2xADvz9prV?=
 =?iso-8859-1?Q?YhYeY95izR82aho+ikHpN9Tu8f2No2xBxxr5MbwUKt33yg97NNSkM7V9ih?=
 =?iso-8859-1?Q?ArsFfhPRNo6b1+tgtaSXbuxgazmoNFBbt45cY2VO9rC17kq7SimCGPDZ4/?=
 =?iso-8859-1?Q?pn+tEez1hfaVgRxm/xpLD3YqxzhSxK4+1lfwkFkdq6Vku9QzbHP8wHq/Ts?=
 =?iso-8859-1?Q?xC4hf7qu4lwxOQvf9WXRgqRucsrxD0KRFPDiNRgXhRdSK2WsmjMZi/Laat?=
 =?iso-8859-1?Q?YfPAOw2Nmtn0S/4frvKooOm73lyScSaMOoRCK5+DqL6h2Iv7hsvPKCZhzt?=
 =?iso-8859-1?Q?5pWFpWPi9m2Dd9WEfqFE32CcyUDhMJ75dmu0jOiaCLXANyImW3OdWOxHLv?=
 =?iso-8859-1?Q?K7HreLT0RKZmYZMI1E4IvEQTobPgJMTfTi61GzJv1LF7JQGqptxQdOr0eC?=
 =?iso-8859-1?Q?AWB0FQGsPrkdY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a1203c-7992-4c82-a657-08de1bc5b218
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 17:15:04.3507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 041yYJ9sqSS9BbkrdwZ8KDvocErKu7uj8SbW55fpo7sxDShWf95Ucr6BMNP3S//TUKxuKOFZHntZ5/6ZzUjdHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7219

=0A=
> Thanks.=A0 My knowledge of this material is weaker than usual :( But the=
=0A=
> series looks good to my eye so I'll toss it into mm.git's mm-new branch=
=0A=
> for some testing exposure.=A0 If that goes OK then I'll later move it=0A=
> into the mm-unstable branch where it will get linux-next esposure.=A0 At=
=0A=
> that point I'll monitor reviewer and tester feedback (please).=0A=
=0A=
Thanks Andrew! Lets see how that goes.=0A=
=0A=
=0A=
=0A=

