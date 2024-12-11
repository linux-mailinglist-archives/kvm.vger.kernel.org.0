Return-Path: <kvm+bounces-33472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A18C9EC2A3
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 03:58:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0732D281ECE
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FD81FCFD2;
	Wed, 11 Dec 2024 02:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KPKU+JxD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9961ACECC;
	Wed, 11 Dec 2024 02:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733885927; cv=fail; b=b+Y2HyywQjOjEv+9mqXuByIhqMbMnP969LMjNRKMaZUNZwuG56OxgIAL3GuSKBC4VsCjp+nlwzZzVnA1VqHea7ivVeVFcE+2d+cvRmHpDK5uw4xbDtPBUz7R6VpvT7AVwAw/QEzT28g/ZIMVXydOXCC8Xr/UAHsR4Yzxi5dIrq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733885927; c=relaxed/simple;
	bh=fyjHBv4td4+Ael9pFbhPXxJFEvgvvveboZlnmo8QkTQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g+IudG/8jUqsp7j4Uuv04OhRahuaTrXXS8y+lmP8w1XgZP7FJhpIJQLhhHtduOcOZzBM56W6dIPwOjOaJrBUu/vvqDuMFpGjVd9GuEFcdPV3JBNQ7A41t9r2Px7DNU6g9RjmcDm8Fnp2WHQNkT/295C12aJO/YY1AGHLSjObNlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KPKU+JxD; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JogQRrLyujIr6KHvgxEnXFxtLCIK85r8ZLwpTAs+FkWuwgYrx3pEmqws1aj1GaXtQT3GMPNK8qOqfc9e4EWQMis6vesBl6nyNJa7z1I3spFx/xnujM1NvUs/sf/RvPV1vuAmc7AcsRO++IQfO/3YpJmW5LWQiID04Y/O/hl+UNcNCxGfSociiPygvaSwoYsZt+VQ8Yk22Nks0uVpD7/UYrjoONQ0QpmZ23acDoyfutDBeSJNMZk2ZadEWA7fK1iC0ZxP0G58OLpqoukspRwjF1XHdEVtSKNXiZCtjpMcVDe+0Uo0IB/TeU16hjufA7nhJ67u9p50YZZlfmOYYAm7cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyjHBv4td4+Ael9pFbhPXxJFEvgvvveboZlnmo8QkTQ=;
 b=GyLGhwuKWM5FMjZbHew4Cyp2qUK4IeSyv9s7OTe42Z2V1z2qtxS4gs1csNqapkVe+9qNpREN2pbJgp8lL1IXMOurBs7E/SfTlfBHX7+occVgiN06Yy+d2VaGn053fgHxZDcPmgHFXZG1gifa5xbakSu0yKaMzat+TuTo3H4sMByC8ROCW5ZiB/CfZ6qjnnGS510JPRMEHZMb/JTZ+BLViubldEr5fHQbyU09o4oJXXF9pxN2M7n8gDSk9IGpE0MyzRmcsZx9XAKg15uwfes4JyKCdxiz3GqHAE4j9HQ07CIHyw9WIS+bZiU9G2ekkFFjSVsvomNXO1uOfhPQ6udSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyjHBv4td4+Ael9pFbhPXxJFEvgvvveboZlnmo8QkTQ=;
 b=KPKU+JxD4y31uhD2IufCrh8EkJ7jrBpqtFGoKUN2cqm+Mnw/FCCpqWe3orKVvtjYaTuorWZjPvXrsJGhbFOjH2lf5qmxmaIHn8lV6oH4mRHDQFfVnZfdiF2JDywwKw1aT3w9o1DOuuNcqCPowU/1odUz7EJESVdhCTYj9s64RjRQtc0/Nu+5SaO01UL99Szapvl0Wk9Su121VzqNdZLB8PREbmKDZBYjxOj0bNzM5AVsaSAuiFUjkaxS6kMtib8f/D7KVaB4ti21K5XTUhu08+NFwjz9aZsK2zPQ+Bs3Yqj1YtQaOLPYoIcvdNXAvjQZ8mmJP3aeyuuflcI3TrOUvg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB8928.namprd12.prod.outlook.com (2603:10b6:a03:53e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Wed, 11 Dec
 2024 02:58:38 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%3]) with mapi id 15.20.8207.014; Wed, 11 Dec 2024
 02:58:38 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Will Deacon <will@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke
	<udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com"
	<coltonlewis@google.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Topic: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Thread-Index: AQHbObyY4gofHx3CJE6tGYAUqrUkhLLfp+2AgADUH40=
Date: Wed, 11 Dec 2024 02:58:38 +0000
Message-ID:
 <SA1PR12MB71991EC85E8EEDD1C5115886B03E2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <20241210141334.GD15607@willie-the-truck>
In-Reply-To: <20241210141334.GD15607@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB8928:EE_
x-ms-office365-filtering-correlation-id: 358bb3a9-bfa7-4874-0331-08dd198fb619
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?l3YHN8EWlLMDQHRHTY17HNQBoe2zFW7bFRYDrGoR+1mleZss/F4QZXTMOP?=
 =?iso-8859-1?Q?hQoWErDiOg3WksUi9Z4tO+1HYAvTtugTrG+cOD5lA2SB0eTFx55Ak+xW6U?=
 =?iso-8859-1?Q?WRhs4qRdR9ndCj4jeBunXScGuZpoPRDBsE+A9E/OYaPLT1faH0VPHsm0Yl?=
 =?iso-8859-1?Q?wgb9XRzWDTeR1AZHvjE1mNl4oxUTNU5JIJKhLyaZShQAYChwPgel2j9uuB?=
 =?iso-8859-1?Q?yz0FcSt79AR9fXXfUskq0uijxZb/peAOPzDBjuv5AguL7/Us6jVjcyx4Mj?=
 =?iso-8859-1?Q?BbitEj+94wbTE9ih+FmMjb6ZllwG3Nlz3zCRcFoAVNKvkLu2UVVH+xFtIw?=
 =?iso-8859-1?Q?DiJlxt302ZS8fkLdeShPLmfA1R37ahwQZ+UJ36JgQDk/Lm3EQsg+v0Ca8j?=
 =?iso-8859-1?Q?jSop9R4A99uzyLvF5v4+zhj8lKdKgsjR8H2b/+pUm4Ho6Aq/elOqsORmXU?=
 =?iso-8859-1?Q?TK2MfvGOQTDnLKZrsdWJ6PTfsUJLuOnruI1xaPUtQFYRAZfp4e7O7BXSCI?=
 =?iso-8859-1?Q?D6TMn3zDsybM2+lGYCnpPFXjHEDKRYGC8Z46OJ5GFzCK9Z5qfF120w8JjK?=
 =?iso-8859-1?Q?zXxXgA7FtsKc8ob4iZsNpN6mVL7lgrpyudF77JwO/TN7MpBjH37KAxq2sG?=
 =?iso-8859-1?Q?Zw+piOkC4TThnlASk1tdB+cgf/5JaNi9Wjb0KuiilJsDUnr6BPR1vbmW4d?=
 =?iso-8859-1?Q?K7roSwQMwzCW1mok4HvE4gokntZRLlwYrVFDFMdjRIrw2u/1sHy6EYcsfH?=
 =?iso-8859-1?Q?SZdSfxZtNM88GBFNKh9zSktZ/N3AYg09WMLjCxGfFVEkxLXtIHddvjVJ+W?=
 =?iso-8859-1?Q?w5swkS2sdK6e32r63b7IokqzkFRW/pb0Nst6P+cy/ML8/YIgXr5ctqncXA?=
 =?iso-8859-1?Q?83uLhRd9R/n0pKM4gKM7yqOA+RYSg3mJztCP+b5Yxtc77MdyhuIRMYU+CA?=
 =?iso-8859-1?Q?uZ4DiC30cUi/4DZ3qe3BpEhkIFyuCr2JSikbYbTfwg3QgUavw+v+C+Bb/r?=
 =?iso-8859-1?Q?YcCqsO7GvcEfEuDgXgKoYUAIVBbLF/IH8/He+T3EjzzpqqAZCPrsTzsAxn?=
 =?iso-8859-1?Q?tTODvJz2PtNjA1UAl5bP2DHQ2MO9X/n/fyeJ/bqNLqO6QjQWyi+Fya1YJf?=
 =?iso-8859-1?Q?EuVPB4G9bsGp+Rmi9KAqaLo+j4PN14/Unp+29tImbKFlRO4MbEHDamhzRD?=
 =?iso-8859-1?Q?DC8pVQlowz9oEOiOPcIGZLH8Qbjjy87wXIp0VW1HQ34YLG/oi+4J22h66U?=
 =?iso-8859-1?Q?UyhKTAEyyVC93Cq3eWBpgKxkdoYiwSsP2lsG7N2KfgZjQM6M18kIPmvWKz?=
 =?iso-8859-1?Q?MYRnvQQHGLFtmEHcZiY3yujG69hrwAzc6kNMiHDnl65N3s+k1jYnS9H4dh?=
 =?iso-8859-1?Q?EvSFrXfm6qBp/tb//0BskSZXTHSu2kj552r95pXHngtJ/rSbObToEOIO35?=
 =?iso-8859-1?Q?noZ9Wr/PCSHPeSvBvRhnN/r0GGjx1iU9fmBlVA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?t/8guk6HaRFWo8RVePZM14mgSojFu3yG1D8cEVxOf8XhvkDhsgug6w2e6Z?=
 =?iso-8859-1?Q?kx1oMnWy8IHN3piSeDtIzHINA0q5pcpi7+LNvOJSsH1ycbDhoMjP5Tg3W6?=
 =?iso-8859-1?Q?3JF2O8iSPsd1fEoycm1qUJr915fbVk7sSOWKv1Mh9V6S0JmzfYaiMfi4L6?=
 =?iso-8859-1?Q?7xLwYwgGIqKX0xPQyTgrQcFhFGsM1Kn1bILVWChHpIa1FBVvZmbq4gEeIK?=
 =?iso-8859-1?Q?1+nILxqgY14YNbHYdjyYbbCsOdewhXwKcDre4XQGe8WRWMamdX8N3QoZIx?=
 =?iso-8859-1?Q?HjssEoI1niyIBK5cQyjPWnbBs57VJmjXovyzhWiLglNhIntxz9jZ50HNp4?=
 =?iso-8859-1?Q?7siGhOO1kOZMqOBdV0yI5X+/PMi4NTkFbYlwbDEcGfNsHLE68uUa7DJNt1?=
 =?iso-8859-1?Q?n4aFlzLg1+sjlI+4Ggr7GgxvBNszTsk1QBLAq+HWvItBupZzq+Q1oDopWp?=
 =?iso-8859-1?Q?HC77yo1bEdFfByqmcE/rf1xuSerXb8/YoldWuiHztusc4Zr4EhVMTU6u47?=
 =?iso-8859-1?Q?JVSv25PR8hKbZV/SSufjp8pj8Mqod2Bnbi+4ebgJQJZWnnXG/dHdx9RWMD?=
 =?iso-8859-1?Q?+ZKnyucLsxANy93ithph+MxVsH7XXeEMm7b3PBIliaHJQN3pY9tWrCFJ79?=
 =?iso-8859-1?Q?nRiKTki5l1dBCjT07Iq6gwffpu24YfiZNp68PNXS42reurJVzu1Cbw7qN6?=
 =?iso-8859-1?Q?9fTAeg9wniJcQ3KgvDKeozDpJA2azR64OFdb+0oP6Y9VSFCXfgblxNn++s?=
 =?iso-8859-1?Q?k68PUpieumjYrHcHfqXoyi8Ug7ydF3nOsWtCezC10bWxtejuHRlChxZTeb?=
 =?iso-8859-1?Q?QDZi2QVrEp0Uv16lkWFSynnMp0b//L7UJziIyl2eCDRUz43Xp36N8XQ8q5?=
 =?iso-8859-1?Q?WScQAvVjSJuTxbyt0VT/cCZG5jmvxbmNtcmStkysoai25L+yZSnlHI+lcI?=
 =?iso-8859-1?Q?MxY0P89qu+Xo3xTgxbQSLR7OMmq7zlH0dpfh06tuMwyWoeoTiZ7uV2W1Wr?=
 =?iso-8859-1?Q?HvjREJWzqwjEgPerZwlQFV1rDJ21WLadXTUmY/vvwLIysKuHIznIJZP4GB?=
 =?iso-8859-1?Q?lVxAVEzE0WTl/9/EMK3F6ugA124brxD+4nba85rxRbGSgGGgQOU4kc0Mrw?=
 =?iso-8859-1?Q?RqRSoyq3HQ6rBlwhaHAuA6L9tjozwbM3x2bxf4epp1bDukBWtU4Vkbb/vT?=
 =?iso-8859-1?Q?OkAe5KXIliUnfv+hih/yaWUmlazADKz/I6ocbssHE9brn2BueoVlsF8E8S?=
 =?iso-8859-1?Q?RrbkG6sItLQpvxBRhVsJdnubHS6TNqeCpMdUih/O8e18/4PeKtOuN+suoi?=
 =?iso-8859-1?Q?ZNbqEjFwFfUHGP5TiQvtzo/KRRt5vjURHWJMssuqD03xtfW3lyLv072D4g?=
 =?iso-8859-1?Q?obho+FSd6Yt2/9gVWxWhJoN+SzVp2IebL0Mj50Av5oJSiMxumqSpYvWUkN?=
 =?iso-8859-1?Q?FgTUd7FbcCyqmUaB/YPEJpNx0OAG415/iEg/q49WntF00Qm33IP7sbMv1g?=
 =?iso-8859-1?Q?Qt/37+PQVbNjpasG9h9+xJoRol9fx/gk568V9tOSVCz5ehsjhZmHXTEx0j?=
 =?iso-8859-1?Q?/eMJrWoDMMc3cyCxRBm/CNwCzsYfESl8VBDuEuDdy0oeTg4kJVPB/k/l+k?=
 =?iso-8859-1?Q?hAYgQfdeE5Pf8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 358bb3a9-bfa7-4874-0331-08dd198fb619
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2024 02:58:38.2044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKYxk+oOeQi/IL0QyfdByvrYitVdTY1K9E3eue3MLorytYViiFnikTfBmPaprEORA1HQcmRs83HujjxNcdmYzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8928

Thanks Will for taking a look.=0A=
=0A=
>> The device memory such as on the Grace Hopper systems is interchangeable=
=0A=
>> with DDR memory and retains its properties. Allow executable faults=0A=
>> on the memory determined as Normal cacheable.=0A=
>=0A=
> Sorry, but a change this subtle to the arch code is going to need a _much=
_=0A=
> better explanation than the rambling text above.=0A=
=0A=
Understood, I'll work on the text and try to make it coherent.=0A=
=0A=
=0A=
> I also suspect that you're trying to do too many things in one patch.=0A=
> In particular, the changes to execute permission handling absolutely=0A=
> need to be discussed as a single patch in the series.=0A=
>=0A=
> Please can you split this up in to a set of changes with useful commit=0A=
> messages so that we can review them?=0A=
=0A=
Yes. I'll take out the execute permission part to a separate patch.=0A=
=0A=
=0A=
> Jason knows how to do this so you could ask him for help if you're stuck.=
=0A=
> Otherwise, there are plenty of examples of well-written commit messages=
=0A=
> on the mailing list and in the git history.=0A=
=0A=
Ack.=0A=
=0A=

