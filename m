Return-Path: <kvm+bounces-35879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA24A1593F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:57:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F31A162B03
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7551AE875;
	Fri, 17 Jan 2025 21:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cuoUXBUL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14255A95C;
	Fri, 17 Jan 2025 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737151020; cv=fail; b=ospzT8JglyLjKMWMBfJEkEZmlZyy/74MDFj3KoTzFQ7vJGpkdmB7x0bQwT4B12hQbxkrX/Fl3zBJTbXt+9rSFeVkNUdIc1k6/QDsvbx1IBwZw0Tb4EtSIHGP//oWfcTiaL6jaV7YNkV26NHCKPDAwe5Ya6xCpY6kL59sEmLATtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737151020; c=relaxed/simple;
	bh=vBcJe5TFb8L3IPObR4wnrTx/YJch5Yv1fUPQq6ffv2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZVAGL5xwpJowMJIQ6EA5poovF1xr328Ondr9Xbc0eIqk6vePhDVkOIzWbewbvG7zebrOzKk8j2pMCD+y+7eCWzpsTyRQapAe8B5KTik/VQcjWlsz8t7HP5DjBHI7CtZ2bkJo7K9vfCaBkkv2aU/6rHMboAe45r3UOwGh60MbcWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cuoUXBUL; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l1PIFkwLpIhib6x8m3bId20CRLkUUgoAd/efqBMbpDNFhioMhVRrTGwdjdu/mst2ivr9kU3ltCOC37RcZLgHnZn6Hj5FYJCgeP+u8zdg2X4S0PSLpijP0NNMDyrzpDtOrcW7X8jauhaJzkAT4+qxJxuAQ1ntWHOSjUlZO+w6YMqzeyzRknc3hZgZVdTapCdb3+pFmF0QfP8bYHMEEn4Ky6Fgtnh37DW2nP6l2VDyoODzJNCi8tB1tAR+Cywfq7Rg1FbFPsYhg10HyTSZm+Lr9RPEVk7CPlx7PTaIsMNcGmJ923+xpsCCqGF+eD62FZxzv/lWh4YT4ipzJYkWFhXwNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBcJe5TFb8L3IPObR4wnrTx/YJch5Yv1fUPQq6ffv2I=;
 b=XECdVieMOL/TCGZedt140d1Yoa0mTXTCwbYGCOwTBFc+15kdIw9LyZd291f8l17k1JUiL+JVLJQIeE2Pb78nP9ztnw4Aj2HN8faVlgFzUOo7PqxIh2I7svCCU4K0nV65ZkxK/si55aPkAZpG29mNuSPtibP9BAsdcs58AmBUdGxIw+95Jnc9XtbY6rBauwE03+HAQ3Tyt2d9Fez8z2TIXn1oSGQAqvjd5GLG286tWSadNOEz7bemBA8Emx0j5ioQC4xOaqgrmzOAkh7sh16q9JVI+hE7QitBhCcszrSqcjPPcbTU1znPr/6II9ey7Ivk7LRWPhZRMPU8lOoPCkeo1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBcJe5TFb8L3IPObR4wnrTx/YJch5Yv1fUPQq6ffv2I=;
 b=cuoUXBUL890+MuCg+dvyGXc+PyNNJ5cfMfPjJpp7YrrSEapwZFjeHs+ZnKXKYMHriqDwi5MmpLOlryJOJC2UPcHsPq/8Lm2iq43gBVktQr8D8nhkr5lq9PRVFKXblSCYVNzslbCBAYsc40SUqFl/zKIYlb+L0jU+uoJLW8wVJJIfiPJ7dpN+HnHWujYSjXpG9mQZRPkBeefKASBknyw3GKx0PBlV02/6mTwN2OykhwN1K/84vAu3icZ62lYOEPZyn1hrKq8X1DciwV+CcOfVdEhsgwhxqzffXvAEOz3afN9uBrOtbiJst/3ryIG4fV/CLoNCLZXhisCldkqhaYiURg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 21:56:56 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 21:56:56 +0000
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
Thread-Index:
 AQHbaPPMr+5jgewsKU+/Cqp4ayIU/LMbSQ4AgAAJq1OAAApqAIAAEg3SgAANJgCAAAJPJ4AABEcy
Date: Fri, 17 Jan 2025 21:56:56 +0000
Message-ID:
 <SA1PR12MB71993DB6EF3BA49D3CAB8E83B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
	<20250117132736.408954ac.alex.williamson@redhat.com>
	<SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250117143928.13edc014.alex.williamson@redhat.com>
	<SA1PR12MB7199624F639518D3CA59C7F4B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250117163108.3f817d4d.alex.williamson@redhat.com>
 <SA1PR12MB71992A6981DD27BCA932C29CB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB71992A6981DD27BCA932C29CB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB8314:EE_
x-ms-office365-filtering-correlation-id: 2e4dfc4b-36bc-4f68-9265-08dd3741dc45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?LbI8g1hsTi4DXMVzUWQJFVRW9YdU1k+tmlCy6mKQ1c5jJLx4DsAR69LYZu?=
 =?iso-8859-1?Q?eFQZPSYCb9AygwScEblKevHp2xIbSnneIf6AC0EycljDvuOzeF0pFeZRsJ?=
 =?iso-8859-1?Q?3/gYrcU+UBDRPSrPfvOg45rUybKKKnVezt5DjhUvz+/tjqpGcts4nln5gG?=
 =?iso-8859-1?Q?CX7q/NOoP+ZBnJDxxm7dKFx/HpiOVXnv15G7CETqLAE6lZ81ROQxhbxNH+?=
 =?iso-8859-1?Q?nU1S+99YlWlwO0gU6wKiJ0h208oVyfevUS6XyFCgW2nYlMQm4HMw6gO2QD?=
 =?iso-8859-1?Q?tnHLcVZgooer2gGQiOATe8DhJcXmRuO/4sOO9aogwalBMZym3PWEkVnG7y?=
 =?iso-8859-1?Q?A9TcUrvrR7vx+sGraL7Pu2xOPxhDtRUdLcITJU26K0GimHEr1xnOS3yJ4R?=
 =?iso-8859-1?Q?6uj5M6k00aSimp9swYsuZvjM8jyiMMlI0vJxUPdiqaDaRNmlNgduxX6cIZ?=
 =?iso-8859-1?Q?BlfqFzMhXYh0RUEFuPhN3UT3vMPZITyjFin8jVGfOiVWD+IqSy/z6Z3Qg0?=
 =?iso-8859-1?Q?DBunIiXRDLGi12Dr9C+u9NEvjHMMBL7Tb+ecntFuXfzf44oAg5p2GtWhvw?=
 =?iso-8859-1?Q?W/mVY13n8B05Zr7vIvVMaA6/EWyCvligsobnHe8SPHFyRgu4rNgVESXt7P?=
 =?iso-8859-1?Q?Xxmx3YTTgAYPNfpl9cZYv9ymmmq2J42yid3giipUIwhtYhFbDYVQcx7oC6?=
 =?iso-8859-1?Q?sXMIfLSeyBhbW7PFeDCCJDFc27tGfvvxaPD5eFhwbJTikXwFdCDWHSPnGo?=
 =?iso-8859-1?Q?MtMxkRu5HGPaqlY9WMwzCrcOlSQ0tNPiNsFFJUi+xdPn/0areCR3kaIDKT?=
 =?iso-8859-1?Q?/Zb003eecat8rGCYL0hq8NFI3NQz9yLb3mhLpt1Qdk6tj91Zkjw+XtoQ6I?=
 =?iso-8859-1?Q?zbbhmdandKcLlSRmfpAizQo7rC/s/IOmwo2MB7nL0djoGkhz8RZ/suPi1e?=
 =?iso-8859-1?Q?F9Pt6KhGp9Z3X3gqbwv7Yu1UxtccUCZ1a98quNkv6yyUO8Gc4rVleGRlI/?=
 =?iso-8859-1?Q?hzkLQIilPQxpN5qv6pkj2HlE1YxH2ksbkbb6HOvwOw+OsW3ZJZQdY1J82S?=
 =?iso-8859-1?Q?a0scFygGKgOpCW29tePpCNFjfn+dh5yItoUBS+gHI03mxeepH0BjjbfOav?=
 =?iso-8859-1?Q?E+qSezfoVna5P5a/sYxu2X6eYTopBeUW7NCeGRhEbqG2urLTgba4auDYNz?=
 =?iso-8859-1?Q?pNgwlorw6pKCCd5wHMbPgX7cQ5HP2clud30A7fL99FqnaihOb+nDr6iyaA?=
 =?iso-8859-1?Q?WURwhSHTCY2Eh/zWaGN3NnqGIvFNLi2sW9SbgsK8WRpo5Vb4oFXPNj0Qg9?=
 =?iso-8859-1?Q?SU8TpRikW3QBbR8GTS7sF7AvCjIFsxoQDvoOOXLTl0Of3xp/d5mUpFd2Hb?=
 =?iso-8859-1?Q?PKrP/8csyDwEer4uFq5Bz80EL5reuNlHJrCqFpjVfhel+fsEw1W3cR8s3A?=
 =?iso-8859-1?Q?BqLQRg2cGPRs7AqnbWQ95sy/+jwEbUCLpa36bIcmgMFwRG7khnw/lDg7ZW?=
 =?iso-8859-1?Q?nwnZjABMbdsZ8RtdPcJNbX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?LpWbUvEcR+5P+rh2xUV404X45cXrKapCTA5lgSYNiNoDYwxRFjeXN2jpUE?=
 =?iso-8859-1?Q?EiygVklfxGW0M0tKsSSP5KPGiYgRSvLJFf42jFHFk7URqCmp2vZQxey69z?=
 =?iso-8859-1?Q?TGMtsRLY+DZYO5AC/0d2dyHFSO9N9k2VkNeo8IFc3DMgW5LMyObnwN1Kva?=
 =?iso-8859-1?Q?p4c0r9STR42lvE1ckJsEWHLAON/6QRbWCLBHz+ICex6iRbGSIy5/xerQAp?=
 =?iso-8859-1?Q?M4g60+JeWg6ums8exDszDInhkzZcAiNSmRZJrRwxKwG8Rcw37mNKgfuaQi?=
 =?iso-8859-1?Q?5tdKkuiG1BMqnOjffhMPE+JY9mx79XTxTrKYV2sLxJaDT+f5hnedb0XwNj?=
 =?iso-8859-1?Q?wwvJSdvVwSn7hStI8w4rbBUwbZPpyrlPlw9ay9RNH7bFA7if+LmDXUc0q+?=
 =?iso-8859-1?Q?PUwphlgdCj3AGgRiw0bXhuUf3xpu1eavtibhQODGVSIXjB4YGys9LN6uCX?=
 =?iso-8859-1?Q?mcQaq4OBvkmgy8+z92WrYdAQtMtRz3b9MaVpocUTW1AlLYSnao9tvkjNcQ?=
 =?iso-8859-1?Q?96ayiiBYUTJxfJyXhyJVAqFDkf2y19hnHwW5ZPN9o5GIqnfYfrj5/nMJcT?=
 =?iso-8859-1?Q?uUJj77d6h/D6cz2Fmk+/9geP9G0ch0DyhiZiowr7WFRqjJ5DNve/Ju5rMN?=
 =?iso-8859-1?Q?n4DuXWi8kv44imUGUPdfc/nHw6pmADlmHtOaopDgrqZMRGH5e4r9wTMBlQ?=
 =?iso-8859-1?Q?36wtpmLQwj3QF3LUN+Kpb+bt9YJKnZQ5aA4WRL7I6biTme2Gg0kUTpGx2l?=
 =?iso-8859-1?Q?IoIGqd5AsmfZLHKsu0Byruw2r+fw7K7coHE+N8bQc0qbmiCNtpeLIciPYF?=
 =?iso-8859-1?Q?Mf4tMer/kJXu5myohIHWsfl8rzY1vnAGGA0oiVV8k/N2KmiRA5zyWTUBp2?=
 =?iso-8859-1?Q?2jfaEeIcRvECpNDBlOhwiOlSJ74FSJsYHvB1WHiMj+sLUXGXINDr0cJfug?=
 =?iso-8859-1?Q?Tl4GPhuzBijw4+ZiObFUSWMLwQN8CXvx8PzUP/50uNcNHNaccxikCtOe4J?=
 =?iso-8859-1?Q?p730/NwiQQvnEX8v57o44/mVFOa0ER4hXbqwUXknlniZbIdyvEqMLta5iX?=
 =?iso-8859-1?Q?1Ie/PjrxjoApU6HmsWsnIpQMlDn9jDU09JTvrpVymfc4Y4J3tQGA9mnyif?=
 =?iso-8859-1?Q?UfrJ2LKgiElFWDWWNkVLnWf2KktYfgggC2aCuVyHvKkXaANs+oCBbav07R?=
 =?iso-8859-1?Q?k7IF/49n4ff3gcAoibSnKGyqphksaAKFSObSB6U/fFTfwdm2UEj0u7qVoI?=
 =?iso-8859-1?Q?RGb8nWZ9eNMMAidbYfnRhR67C1Z7jegUXFvL2S/Jkw/gbId/8aH1C+YhUA?=
 =?iso-8859-1?Q?i3FptSaaYgEP9TOwDUNvhahc/b+pUUg84SDj3MTYKnx/oTPetoZViIh29h?=
 =?iso-8859-1?Q?rxmJ9RyByt8Yd2eWzK+d7tPjX3VuhwYavXEt17WWIyKlCMPXznykxRioah?=
 =?iso-8859-1?Q?4hemKc1crrFWof425oDxO/elEZB3DUW4yNrFPHxgKScJ++QAYOSVZ9u7fV?=
 =?iso-8859-1?Q?/CV5Gp5TGhg82oWJtlAkOnIwRt5PbAgBvtOpeZI8GfkGvUNuJkNHR0nBaa?=
 =?iso-8859-1?Q?TV8qHV2k+cCkA5iL/Vakvkgg4jMTYV/lPGY2zDFuFtR5+Y8Xm9dlUYUDze?=
 =?iso-8859-1?Q?zaPGV/qvivth8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4dfc4b-36bc-4f68-9265-08dd3741dc45
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 21:56:56.4285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Tw59zkYBeN+voKojSVty+34Bm2xNXeB+Aiyt79+uvZypOfvNUXLbe3to03DpVk7gRhiNIVvN3uelf4vL0WYYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

>> No, the driver needs to enable memory on the device around the iomap=0A=
>> rather than assuming the initial state.=A0 Thanks,=0A=
>>=0A=
>> Alex=0A=
>=0A=
> Ack, thanks for the suggestion.=0A=
>=0A=
> I'll change nvgrace_gpu_wait_device_ready to read the PCI_COMMAND=0A=
> through pci_read_config_word before pci_iomap. And if PCI_COMMAND_MEMORY=
=0A=
> is not set, update through pci_write_config_word.=0A=
=0A=
Or perhaps better to call vfio_pci_memory_lock_and_enable(). I'll make the =
change=0A=
and send out the next version.=0A=

